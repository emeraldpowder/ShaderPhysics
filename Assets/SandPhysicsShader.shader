Shader "Custom Render Texture Effect/SandPhysics"
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
            
            float4 _DrawPosition;
            float4 _DrawColor;
            
            float4 get(v2f_customrendertexture IN, int x, int y) : COLOR
            {
                fixed2 uv = IN.localTexcoord.xy + fixed2(x/_CustomRenderTextureWidth, -y/_CustomRenderTextureHeight);
                
                if (uv.y < 0)
                    return float4(1,1,1,1);
                else if (uv.y > 1)
                    return float4(0,0,0,0);
            
                return tex2D(_SelfTexture2D, uv);
            }
            
            float4 frag(v2f_customrendertexture IN) : COLOR
            {
                float4 color = get(IN, 0, 0);
                
                if (distance(_DrawPosition, IN.localTexcoord.xy) < 0.01)
                {
                    // Если этот пиксель - близко к курсору, заливаем его текущим цветом рисования
                    color = _DrawColor;
                }
                else if (color.a <= 0.1)
                {
                    // Если этот пиксель - прозрачный (в нём нет песчинки)
                    
                    if (get(IN, 0, -1).a >= 0.9)
                        color = get(IN, 0, -1); // Заливаем пиксель цветом того, что на пиксель выше
                    else if (get(IN, 1, -1).a >= 0.9 && get(IN, 2, 0).a >= 0.9 && get(IN, 1, 0).a >= 0.9 && !(get(IN, -1, -1).a >= 0.9 && get(IN, -2, 0).a >= 0.9 && get(IN, -1, 0).a >= 0.9))
                        color = get(IN, 1, -1); // Заливаем пиксель цветом того, что на пиксель выше и правее
                    else if (get(IN, -1, -1).a >= 0.9 && get(IN, -2, 0).a >= 0.9 && get(IN, -1, 0).a >= 0.9)
                        color = get(IN, -1, -1); // Заливаем пиксель цветом того, что на пиксель выше и левее
                }
                else if (
                    get(IN, 0, 1).a <= 0.1 || (
                    (get(IN, -1, 1).a <= 0.1 && get(IN, 1, 1).a >= 0.9 && get(IN, -1, 0).a <= 0.1 && !(get(IN, -2, 0).a >= 0.9 && get(IN, -3, 1).a >= 0.9 && get(IN, -2, 1).a >= 0.9)) ||
                    (get(IN, 1, 1).a <= 0.1 && get(IN, -1, 1).a >= 0.9 && get(IN, 1, 0).a <= 0.1)))
                {
                    color = float4(0,0,0,0); // Заливаем пиксель прозрачным
                }
                
                return color;
            }
            ENDCG
        }
    }
}
