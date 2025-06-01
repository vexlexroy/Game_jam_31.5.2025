shader_type canvas_item;

uniform int stage = 0;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
		
		vec4 screen_color = textureLod(screen_texture, SCREEN_UV, 0.0);
		
		float grayscale = 0.299 * screen_color.r + 0.587 * screen_color.g + 0.114 * screen_color.b;
		
		vec3 result = vec3(grayscale);
		if (stage == 1) {
			result = vec3(screen_color.r, 0, 0);	
		} else if (stage == 2) {
			result = vec3(screen_color.r, screen_color.g, 0);
		} else if (stage == 3) {
			result = vec3(screen_color.r, screen_color.g, screen_color.b);
		}
		
        COLOR = vec4(result, 1);
}