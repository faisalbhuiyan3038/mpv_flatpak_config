// $MinimumShaderProfile: ps_2_0
#define S 0.05

/* --- sCurve (dx9) --- */
/* v1.42 (2023-11) released by butterw under GPLv3
(1 texture, 12 arithmetic)

Boosts (or reduces) midtone contrast by applying a blended Sigmoid s-curve.
- With S>0:
Reduces contrast in darks and brights, but doesn't clip them.
When clipping is undesirable, an S-curve is preferable to the classic contrast.10 (or expand10_245) adjustment. Brightness of darks and brights isn't changed much for small values of S.

- With S<0: inverse S-curve.
reduces midtone contrast, but increases contrast in darks and brights.

Sigmoid equation
out = 1.0/( 1.0 + exp(-14*x +7.0) ) = 1.0/( 1.0 + exp(-14(x-0.5))
    with x, out: pixel.rgb in [0, 1.0].

The curve is symmetrical around the midpoint (x=0.5) and doesn't change the Black point (x=0) or White point (x=1).
- Contrast boost at the midpoint: S*2.5.
- Contrast degradation at the Black and White points: S.

parameter S, Blending Strength, typ: [-0.2 to 0.2], 0: no effect, [-1.0, 1.0]
- Positive: increases midtone contrast, ex:0.05
Not good with dark scenes, especially with higher values of S, because of the reduced contrast (and brightness) in Shadows.
It is not typically necessary to increase contrast for movies (though a low Strength s-curve adjustment could be beneficial in special cases, ex: faded colors in older films).

Alternative s-curve equation, slightly simpler to calculate (1 texture, 9 arithmetic).
out = 0.5 + x1/( 0.5 + abs(x1) )
    with x1 = x - 0.5.
This is curve #2 in sweetfx.curves. ex: s2(0.125). Sigmoid has higher peak contrast boost, and less contrast/brightness degradation in darks, but has a narrower midtone contrast boost.
- Contrast boost at the midpoint: S.
- Contrast degradation at the Black and White points: S/2.

*/
sampler s0: register(s0);

float4 main(float2 tex: TEXCOORD0): COLOR {
    float4 c0 = tex2D(s0, tex);

    c0.rgb = lerp(c0.rgb, 1.0/( 1.0 + exp(-14*c0.rgb +7.0) ), S);
    return c0;
}