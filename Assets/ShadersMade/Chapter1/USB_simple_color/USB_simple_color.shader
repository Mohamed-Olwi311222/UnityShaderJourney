Shader "Unlit/USB_simple_color"
{
    // name ("display name", Range(min, max)) = defaultValue
    // name ("display name", Float) = defaultValue
    // name ("display name", Int) = defaultValue
    Properties
    {
        _Specular ("Specular", Range(0.0, 1.1)) = 0.3 //SLIDER
        _Factor ("Color Factor", Float) = 0.3 //FLOAT
        _Cid ("Color id", Int) = 2 //INT
        _MainTex ("Texture", 2D) = "white" {} //TEX TO GET TEXTURES
        _3DTexture("3D Texture", 3D) = "Black" {} //3D Texture
        _Reflection("Reflection", Cube) = "Black" {} //to put in a reflection cube
        [Toggle] _Enable ("Enable ?", Float) = 0 //toggle to maybe use it in shaderfeature
        _Color ("Color", Color) = (1, 1, 1, 1)
        [Toggle(MY_FEATURE)] _EnableMyFeature ("Enable MY_FEATURE?", Float) = 0
        //pop-up style menu
        [KeywordEnum(StateOff, State01, etc...)]
        _PropertyName ("Display name", Float) = 0

        [Header(PowerSliders and IntRange)]

        [Space(10)]

        [PowerSlider(3.0)]
        _Brightness ("Brightness", Range (0.01, 1)) = 0.08

        [Space(5)]

        [IntRange]
        _Samples ("Samples", Range (0, 255)) = 100
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
            // make fog work
            #include "UnityCG.cginc"
            float4 ourFunction();

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };


            // add connection variables they must be the same name as the properties in the shaderlab
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Brightness;
            int _Samples;

            //When you use [Toggle] with no name in brackets, Unity automatically creates a shader keyword from the property name:
            /*
            It is worth mentioning that shader_feature cannot compile multiple variants for an 
            application, what does this mean? Unity will not include variants that we are not using in 
            the final build, which means that we will not be able to move from one state to another at 
            execution time. For this, we will have to use the KeywordEnum drawer that has the variant 
            shader “multi_compile”
            */
            #pragma shader_feature _ENABLE_ON //enable the shaderfeature to use togglex
            #pragma shader_feature MY_FEATURE //as i made one insde the brackets

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                ourFunction();
                fixed4 col = tex2D(_MainTex, i.uv);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                //conditions for the toggle
                #if _ENABLE_ON
                return col;
                #else
                    return col * _Color;
                #endif

            }
            float4 ourFunction()
            {
                return 4;
            }
            ENDCG
        }
    }
}
