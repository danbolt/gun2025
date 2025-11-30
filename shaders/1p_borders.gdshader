shader_type canvas_item;

uniform sampler2D noise_tex;

uniform float t;
uniform bool black;

void fragment() {
	
	if (t < 0.1) {
		discard;
	}
	
	float distance_from_center = distance(SCREEN_UV, vec2(0.5, 0.5));
	float ratio = distance_from_center - (1.0 - t);
	

	
	if (black) {
		COLOR = vec4(0.0, 0.0, 0.0, distance_from_center * ratio);
	}
	else {
		vec4 noise_val = texture(noise_tex, SCREEN_UV);
		COLOR = vec4(1.0, 0.0, 0.0, ratio * noise_val.r);
	}
	
	
}
