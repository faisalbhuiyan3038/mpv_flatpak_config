// $MinimumShaderProfile: ps_2_0
#define CAS 0.35
#define Show_Edge 0 //1

/* --- CAS_lite (dx9) --- */

/* Contrast Adaptive Sharpening (AMD FidelityFX CAS)
mpc-hc mod by butterw (9 texture, 47 arithmetic) (2023-11)
based on this reshade port: https://gist.github.com/martymcmodding/30304c4bffa6e2bd2eb59ff8bb09d135
Original: https://github.com/GPUOpen-Effects/FidelityFX-CAS
The shader uses sRGB rather than the linear colorspace recommended by the documentation.

The algorithm adjusts the amount of sharpening per pixel to target an even level of sharpness across the image. Areas of the input image that are already sharp are sharpened less, while areas that lack detail are sharpened more. This allows for higher overall natural visual sharpness with fewer artifacts.
Sharpeners are typically used at 100% zoom or after upscaling (to achieve the same sharpening effect at high output resolutions you need to increase the CAS amount).

parameters:
- CAS: Contrast sharpening Amount. ex: 0.35 [.. to 2.66]. Negative values are possible for lighter sharpening.
- Show_Edge: integer [0 or 1] 0: sharpened image, 1: detail.
*/
#define peak (3*CAS -8.) // must be <0
sampler s0: register(s0);
float2  p1: register(c1);
#define px p1.x
#define py p1.y
#define texo(x, y) tex2D(s0, tex + float2(x, y)).rgb
#define min4(x1, x2, x3, x4) min(min(x1, x2), min(x3, x4))
#define max4(x1, x2, x3, x4) max(max(x1, x2), max(x3, x4))
#define CoefLuma float3(0.212656, 0.715158, 0.072186) // BT.709 & sRBG luma coefficient

float4 main(float2 tex: TEXCOORD0): COLOR {
 /* Get pixels in 3x3 neighborhood:
      [ 1, 2, 3 ]
      [ 4, o, 6 ]
      [ 7, 8, 9 ]     */
    float3 c2  = texo(  0, -py);
    float3 c4  = texo(-px,   0);
    float3 c6  = texo( px,   0);
    float3 c8  = texo(  0,  py);
    float4 ori = tex2D(s0, tex);

    /* Local contrast: determine minRGB, maxRGB, [0 to 2.]
       [  2        [1   3
        4 o 6   +     .
          8  ]      7   9]  */
    float3 minRGB = min( min4(c2, c4, c6, c8), ori.rgb );
    float3 maxRGB = max( max4(c2, c4, c6, c8), ori.rgb );
    c2 = c2 + c4 + c6 + c8;

    float3 c1 = texo(-px, -py);
    float3 c9 = texo( px,  py);
    float3 c3 = texo( px, -py);
    float3 c7 = texo(-px,  py);
    minRGB+= min( minRGB, min4(c1, c3, c7, c9) );
    maxRGB+= max( maxRGB, max4(c1, c3, c7, c9) );

    /* Amount of sharpening
      -- 2.0
          .  <-- ampRGB
        maxRGB
        minRGB
          |
      -- 0.0 */
    minRGB = min(minRGB, 2-maxRGB);       //[ 0 to 1.] smallest distance to the signal limit.
    float3 ampRGB = minRGB *rcp(maxRGB);  //[ 0 to 1.] sharpening 0: none, 1: full.
    float3 wRGB = sqrt(ampRGB) *1.0/peak; //[-1 to 0.] 0: no sharpening.

    /* Sharpening filter
      [ 0 w 0 ]
      [ w 1 w ]
      [ 0 w 0 ], normalization: *1.0/(4w +1)
    sharp = ori + (c2 + c4 + c6 + c8)*wRGB */
    float3 sharp = ori.rgb + c2*wRGB;
    sharp = saturate( sharp *rcp(4*wRGB +1.) ); // sharp rgb can be >1

    #if Show_Edge == 1
        float3 detail = sharp - ori.rgb;
        return dot(detail, 12*CoefLuma ) +0.15;
    #endif

    ori.rgb = sharp;
    return ori;
}

/* LICENSE: Copyright (c) 2020 Advanced Micro Devices, Inc. All rights reserved. Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */