shader_type canvas_item;

uniform vec2 size = vec2(32.0, 28.0);
// If you intend to read from mipmaps with `textureLod()` LOD values greater than `0.0`,
// use `filter_nearest_mipmap` instead. This shader doesn't require it.
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
		
		// lightness_formula:  0.299 * red + 0.587 * green + 0.114 * blue;
		vec3 c1 = vec3(0.7, 0.6, 0.5);
		float c1_lightness = 0.6185;
		vec3 c2 = vec3(0.4, 0.8, 0.257);
		// same lightness, different red
		vec3 or_c2 = vec3(0.05, 1, 0.145); 
		
		
		c1 = vec3(0.7, 0.6, 0.5);
		
		vec3 c3 = vec3(0.7, 0.3, 0.5);
		
		vec3 c4 = vec3(0.7, 0.6, 0.2);
		
		
		vec4 screen_color = textureLod(screen_texture, SCREEN_UV, 0.0);
		
		float grayscale = 0.299 * screen_color.r + 0.587 * screen_color.g + 0.114 * screen_color.b;
		
}