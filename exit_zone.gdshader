shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_front, diffuse_burley, specular_schlick_ggx, unshaded;


void fragment() {
	ALBEDO = vec3(0.0, 0.7, 0.815);
	EMISSION = vec3(0.0, 0.4, 0.515);
	float mod_value = mod(UV.y + TIME * 0.125, 0.1) * 2.0;
	ALPHA = mod_value;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
