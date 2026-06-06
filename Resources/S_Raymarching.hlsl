float2 iResolution;
float iTime;

float CustomiTime() {
	return iTime / 50;
}

//https://iquilezles.org/articles/smin/
float smin (float a, float b, float k)
{
	float h = max(k - abs(a-b), 0.0) / k;
	return min(a, b) - h * h * k * (1.0 / 4.0);
}

float map(float3 p)
{
	//https://iquilezles.org/articles/distfunctions/
	float d1 = length(p - float3(3.0 * cos(CustomiTime()), 0.0, 0.0)) - 0.8;
    float an = 2.0 * sin(CustomiTime());
	//https://es.wikipedia.org/wiki/Matriz_de_rotaci%C3%B3n
    float2x2 rot = float2x2(
        cos(an), -sin(an),
        sin(an), cos(an)
    );
    float3 q = p;
    q.yz = mul(rot, q.yz);
    float d2 = length(float2(q.y, length(q.xz) - 1.0)) - 0.4;
    float d = smin(d1, d2, 0.5);
    d += 0.05 * sin (6.0 * p.x + 5.0 * CustomiTime()) + 0.027 * sin(3.0 * p.y + 5.0 * CustomiTime());
    return d;
}

float3 calcNormal(float3 p)
{
	float2 eps = float2(0.001, 0.0);
    return normalize(float3(
        map(p + eps.xyy) - map(p - eps.xyy),
        map(p + eps.yxy) - map(p - eps.yxy),
        map(p + eps.yyx) - map(p - eps.yyx)
    ));
}

float4 main(in float2 uv: TEXCOORD0) : SV_Target
{
	//https://www.khanacademy.org/computer-programming/program/6500474647871488/embedded?buttons=no&embed=yes&editor=no&author=no&width=500&height=400
	float2 screen_pos = ((2.0 * uv * iResolution) - iResolution) / iResolution.y;

	float3 cam_orig = float3(0.0, 0.0, 5.0);
	float3 cam_target = float3(0.0, 0.0, 0.0);

	float3 cam_forward = normalize(cam_target - cam_orig);
	float3 cam_right = normalize(cross(cam_forward, float3(0.0, 1.0, 0.0)));
	float3 cam_up = normalize(cross(cam_right, cam_forward));

	float3 ro = cam_orig;
	float3 ray = normalize(
		float3(
			(screen_pos.x * cam_right) + (screen_pos.y * cam_up) + (1.0 * cam_forward)
		)
	);
	
	float distance = 0.0;
	float3 col = float3(0.0, 0.0, 0.0);
	for(int i = 0; i < 100; i++)
	{
		float3 pos = ro + distance * ray;
		float dist = map(pos);
		if(dist < 0.1)
		{
			col = calcNormal(pos);
			break;
		}
		distance += dist;
	}
	//return float4(screen_pos, 0.0, 1.0);
	return float4(col, 1.0);
}