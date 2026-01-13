Shader "Unlit/Shader1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Velocita ("Velocita", Float) = 2.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                // Clip space position o system value
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Velocita;

            v2f vert (appdata v)
            {
                v2f o;
                // trasforma la posizione del vertice in clip space
                o.vertex = UnityObjectToClipPos(v.vertex);
                // permette il tiling e offset della texture
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                col = fixed4(1, 0, 0, 1.0);

                // _Time.y è il tempo di Unity in secondi
                float oscillazione = sin(_Time.y * _Velocita);
    
                // Convertiamo l'oscillazione da (-1 a 1) a (0 a 1) per i colori
                float valore01 = oscillazione * 0.5 + 0.5;

                return fixed4(valore01, 0, 0, 1); // Il cubo pulsa di rosso
                //return col;
            }
            ENDCG
        }
    }
}
