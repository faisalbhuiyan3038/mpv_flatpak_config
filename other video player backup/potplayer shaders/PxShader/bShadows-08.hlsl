// $MinimumShaderProfile: ps_2_0
#define Shadows -0.08

/* --- bShadows (dx9) --- */
/* v1.41 (2023-11) released by butterw under GPLv3
(1 texture, 6 arithmetic)

Darken (or lighten) the shadows.

out = x + Shadows*(1-x1)^4
    with x, out: pixel.rgb in [0, 1.0]
    and x1 = luma(x).

- parameter Shadows [-1, 1.0], 0: no change
>> Negative: darkens the shadows, ex: -0.08
Use to ensure shadows are darks, doesn't alter the rest of the picture.
Can be used to correct raised black levels.
for Shadows:-0.10, clipped input <0.0736
    first order approximation: clips <S/(4S-1)
    a cheaper alternative would be to use bLift-08 (or expand7_255).

positive: lighten the shadows.

*/

#define LumaCoef float3(0.2126, 0.7152, 0.0722)
sampler s0: register(s0);

float4 main(float2 tex: TEXCOORD0): COLOR {
	float4 c0 = tex2D(s0, tex);
	float shadowsBleed = 1.0 - dot(c0.rgb, LumaCoef);
	shadowsBleed *=shadowsBleed;
	shadowsBleed *=shadowsBleed;
	//shadowsBleed *=shadowsBleed; //tryout: (1-luma)^8

	return c0 + Shadows*shadowsBleed;
}