shader_type canvas_item;
render_mode unshaded;

uniform vec2 panel_size;
uniform float bleed;
uniform float edge_px;
uniform float shadow_px;
uniform float speckle_strength;
uniform float edge_darkening;
uniform float shadow_opacity;

void fragment() {
	vec2 p = UV * (panel_size + vec2(shadow_px));
	vec2 offset = vec2(shadow_px) * bleed;
	vec2 shadow = p - offset;
	float edge = min(min(p.x, p.y), min(panel_size.x - p.x, panel_size.y - p.y));
	float noise = fract(sin(dot(floor(p), vec2(12.9898, 78.233))) * 43758.5453);
	float alpha = 0.0;
	if (edge >= 0.0 && edge < edge_px) {
		alpha = bleed * (edge_darkening * (1.0 - edge / edge_px) + speckle_strength * step(0.65, noise));
	} else if (edge < 0.0 && all(greaterThanEqual(shadow, vec2(0.0))) && all(lessThan(shadow, panel_size))) {
		alpha = shadow_opacity * bleed;
	}
	COLOR = vec4(0.035, 0.027, 0.021, alpha);
}
