Shader "Lezione/CuboDinamicoCompleto"
{
    Properties
    {
        _MainTex ("TextureBase", 2D) = "white" {}
        _Velocita ("Velocita Animazione", Float) = 2.0
        _Espansione ("Forza Espansione", Range(0, 0.5)) = 0.2
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

            // 1. DATI DAL MODELLO (Input)
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL; // Necessaria per muovere i vertici verso l'esterno
            };

            // 2. IL VASSOIO (Ponte tra Vertex e Fragment)
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 debugColor : COLOR; // Passiamo un dato extra per test
            };

            sampler2D _MainTex;
            float _Velocita;
            float _Espansione;

            // --- VERTEX SHADER: Modifica la FORMA ---
            v2f vert (appdata v)
            {
                v2f o;

                // Calcoliamo l'onda sinusoidale usando il tempo globale di Unity
                float onda = sin(_Time.y * _Velocita) * 0.5 + 0.5;

                // Spostiamo i vertici lungo la loro normale (direzione della faccia)
                // v.vertex.xyz è la posizione locale del punto 3D
                v.vertex.xyz += v.normal * onda * _Espansione;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            // --- FRAGMENT SHADER: Modifica il COLORE ---
            fixed4 frag (v2f i) : SV_Target
            {
                // Calcoliamo la stessa onda per sincronizzare il colore con il movimento
                float oscillazione = sin(_Time.y * _Velocita) * 0.5 + 0.5;

                // Creiamo un colore che interpola tra Rosso (1,0,0) e Blu (0,0,1)
                fixed4 col = fixed4(oscillazione, 0, 1 - oscillazione, 1);

                // Opzionale: moltiplichiamo per la texture se presente
                // col *= tex2D(_MainTex, i.uv);

                return col;
            }
            ENDCG
        }
    }
}