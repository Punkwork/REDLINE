shader_type canvas_item;
// ARCH-V2-007a (designer 2026-11-26 21:25): the corporation's room seen through an ICE window.
// Draws the part of the room (uv_rect, 0..1 of the image) that sits behind this panel, so two or
// three windows show one continuous room. The HOSTILE room shows through as the hostile reveal
// grows (reveal 0..1). Rounded corners inside the bezel; a soft wash and vignette keep the avatar
// and keys readable. Presentation only.
uniform sampler2D friendly : source_color, filter_linear_mipmap;
uniform sampler2D hostile : source_color, filter_linear_mipmap;
uniform float has_hostile = 0.0;
uniform float reveal = 0.0;
uniform vec4 uv_rect = vec4(0.0, 0.0, 1.0, 1.0);
uniform vec2 size_px = vec2(700.0, 352.0);
uniform float radius_px = 22.0;
uniform vec4 wash : source_color = vec4(0.47, 0.73, 0.65, 1.0);
uniform float wash_amount = 0.12;
uniform float vignette = 0.35;

float rounded_alpha(vec2 p) {
	vec2 half_size = size_px * 0.5;
	vec2 q = abs(p - half_size) - (half_size - vec2(radius_px));
	float d = length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - radius_px;
	return clamp(0.5 - d, 0.0, 1.0);
}

void fragment() {
	vec2 uv = uv_rect.xy + UV * uv_rect.zw;
	vec4 room = texture(friendly, uv);
	if (has_hostile > 0.5) {
		room = mix(room, texture(hostile, uv), clamp(reveal, 0.0, 1.0));
	}
	vec3 c = mix(room.rgb, wash.rgb, wash_amount);
	vec2 v = UV - vec2(0.5);
	c *= 1.0 - vignette * dot(v, v) * 1.6;
	COLOR = vec4(c, rounded_alpha(UV * size_px));
}
