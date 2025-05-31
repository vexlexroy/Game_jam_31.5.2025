shader_type spatial;

uniform float limit;
uniform sampler2D noise_tex;

void vertex()
{
}
void fragment() {
	float noise = texture(noise_tex, 3.0 * VERTEX.xy).r;
    //ALBEDO = vec3(noise);
	ALPHA = (noise - (VERTEX.x + VERTEX.y) > limit) ? 1.0 : 0.0;
	ALBEDO = (noise - (VERTEX.x + VERTEX.y) < limit + 0.15) ? vec3(0.05, 0.2, 50) : ALBEDO;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
