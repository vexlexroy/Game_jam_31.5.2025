shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 color = mix(vec3(1, 0, 1), vec3(1, 1, 1), UV.x);
	ALBEDO = vec3(sin(UV.x * 20.0 + UV.y * 12.0), 0, 0);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
