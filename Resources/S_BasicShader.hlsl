//CONSTANTES
const float PI = 3.1415926535897932384626433832795f;
float2 iResolution;
float iTime;

float4 main(in float2 uv: TEXCOORD0) : SV_Target
{
	float2 screen_pos = ((2.0 * uv * iResolution) - iResolution) / iResolution.y;

	float x = screen_pos.x;
	float y = screen_pos.y;

	const float alpha = 0.5 + 0.5 * sin(iTime / 50);

	float a = lerp(1.0, -2.0, alpha);
	float b = lerp(-1.0, 1.0, alpha);
	float n = lerp(7.0, 4.0, alpha);
	float m = lerp(2.0, 4.6, alpha);

	//https://thelig.ht/chladni/
	float path = a * sin(PI * n * x) * sin(PI * m * y) + b * sin (PI * m * x) * sin(PI * n * y);
	
	float pathStep = step(abs(path), 0.1);
	float3 result = float3(pathStep, pathStep, pathStep);

	return float4(result, 1.0);
}