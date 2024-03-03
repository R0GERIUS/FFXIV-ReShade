/*
 *  Collection of simple base effects often used across shaders by prod80
 *  Required for proper effect execution
 *  Includes [range]: exposure [-4, 4], contrast [-1, 1.5], brightness [-1, 1.5], saturation [-1, 1], vibrance[-1, 1]

 *  MIT License

 *  Copyright (c) 2020 prod80

 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:

 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.

 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

float3 sl( float3 c, float3 b )
{ 
    return b < 0.5f ? ( 2.0f * c * b + c * c * ( 1.0f - 2.0f * b )) :
                      ( sqrt( c ) * ( 2.0f * b - 1.0f ) + 2.0f * c * ( 1.0f - b ));
}

float getLum( in float3 x )
{
    return dot( x, float3( 0.212656, 0.715158, 0.072186 ));
}

float3 exposure( float3 res, float x )
{
    x = x < 0.0f ? x * 0.333f : x;
    return saturate( res.xyz * ( x * ( 1.0f - res.xyz ) + 1.0f ));
}

float3 con( float3 res, float x )
{
    //softlight
    float3 c = sl( res.xyz, res.xyz );
    x = ( x < 0.0f ) ? x * 0.5f : x;
    return saturate( lerp( res.xyz, c.xyz, x ));
}

float3 bri( float3 res, float x )
{
    //screen
    float3 c = 1.0f - ( 1.0f - res.xyz ) * ( 1.0f - res.xyz );
    x = ( x < 0.0f ) ? x * 0.5f : x;
    return saturate( lerp( res.xyz, c.xyz, x ));   
}

float3 sat( float3 res, float x )
{
    return saturate( lerp( getLum( res.xyz ), res.xyz, x + 1.0f ));
}

float3 vib( float3 res, float x )
{
    float4 sat = 0.0f;
    sat.xy = float2( min( min( res.x, res.y ), res.z ), max( max( res.x, res.y ), res.z ));
    sat.z = sat.y - sat.x;
    sat.w = getLum( res.xyz );
    return saturate( lerp( sat.w, res.xyz, 1.0f + ( x * ( 1.0f - sat.z ))));
}