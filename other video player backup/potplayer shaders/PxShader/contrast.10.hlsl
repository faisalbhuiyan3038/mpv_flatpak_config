// $MinimumShaderProfile: ps_2_0
#define Contrast 0.10

/* --- contrast (dx9) --- */
/* v1.42 (2023-11) released by butterw under GPLv3
(1 texture, 1 arithmetic)

Increases (or decreases) contrast by symmetrical expansion of the rgb histogram around the midpoint (0.5, 0.5).
For asymmetrical expansion use the shader expandB_W(bk, wh) instead.

out = f(x, C: Contrast) = x + C*(x-0.5) = (1 + C)*x -0.5*C
    with x, out: pixel.rgb in [0, 1.0]

Mid-point is unaffected by contrast, f(x:0.5)=0.5
- contrast, df/dx: 1+C, 0 when clipping occurs.
- brightness change: (x-0.5)*C.

parameter Contrast, typ [0 to 0.30], 0: no effect
[-1.0, ..], -1: All mid-gray (out=0.5)
>> Positive: increases the contrast, ex: 0.10
brightness is increased above the mid-point, and decreased below the mid-point.
! input will be clipped (out=0):
    for x <   C/2. *1/(1+C)
    and x > 1-C/2. *1/(1+C)
Contrast.10: clips for x<0.0455 and x>0.954

negative: decreases the contrast. Doesn't clip, but the output range is limited:
f(x:0)= -C/2; f(1)= 1+C/2
deContrast or sCurve(negative value) are better curves, unless you want constant contrast.

*/
sampler s0: register(s0);

float4 main(float2 tex: TEXCOORD0): COLOR {
    float4 c0 = tex2D(s0, tex);

    c0.rgb = c0.rgb*(1.0 + Contrast) -0.5*Contrast;
    return c0;
}