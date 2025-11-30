// NOTE: Shader automatically converted from Godot Engine 4.5.1.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_front, diffuse_burley, specular_schlick_ggx, unshaded;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform float alpha_scissor_threshold : hint_range(0.0, 1.0, 0.001);

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;

	vec4 albedo_tex = texture(texture_albedo, base_uv + vec2(1.0, TIME));
	ALBEDO = albedo.rgb * albedo_tex.rgb;

	METALLIC = 0.5;
	SPECULAR = 1.0;

	ROUGHNESS = 0.0;
	ALPHA *= albedo_tex.r;
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
}
