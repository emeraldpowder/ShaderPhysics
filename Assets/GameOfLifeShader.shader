Shader "Custom Render Texture Effect/Game Of Life"
{
    Properties
    {
    }

    SubShader
    {
        Lighting Off
        Blend One Zero
        
        Pass
        {
            CGPROGRAM
            #include "UnityCustomRenderTexture.cginc"
            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment frag
            #pragma target 3.0
            
            float4 get(v2f_customrendertexture IN, int x, int y) : COLOR
            {
                return tex2D(_SelfTexture2D, IN.localTexcoord.xy + fixed2(x/_CustomRenderTextureWidth, y/_CustomRenderTextureHeight));
            }
            
            float4 frag(v2f_customrendertexture IN) : COLOR
            {
                float self = get(IN, 0, 0).a;
                
                int neighbours = int(
                    get(IN, -1, -1).a +
                    get(IN, 0, -1).a +
                    get(IN, 1, -1).a +
                    get(IN, -1, 0).a +
                    get(IN, 1, 0).a +
                    get(IN, -1, 1).a +
                    get(IN, 0, 1).a +
                    get(IN, 1, 1).a);
                    
                if (self > 0.5)
                {
                    if (neighbours < 2)
                        return float4(0, 0, 0, 0);
                    else if (neighbours == 2 || neighbours == 3)
                        return float4(1, 1, 1, 1);
                    else
                        return float4(0, 0, 0, 0);
                }
                else if (self <= 0.5 && neighbours == 3)
                {
                    return float4(1, 1, 1, 1);
                }
                else
                {
                    return float4(0, 0, 0, 0);
                }
            }
            ENDCG
        }
    }
}
