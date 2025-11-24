shader_type canvas_item;

uniform float t;

void fragment() {
	float l = distance(UV, vec2(0.0, 0.0));
	float r = distance(UV, vec2(1.0, 1.0));
	
	float a = 0.0;
	if ((t < l) || (t < r)) {
		a = 1.0;
	}
	COLOR = vec4(0.0, 0.0, 0.0, a);
}
