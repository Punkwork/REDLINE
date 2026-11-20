shader_type canvas_item;
// MOOD-PIXEL-001: one ICE avatar drops to 16-bit when its mood changes, and pulses
// in and out of 16-bit while it is lethal. Same method as trace_pixel (square cells
// on a screen-aligned grid, fewer colour levels, 4x4 ordered dither), but masked by
// the avatar's own alpha so only the character is redrawn. Presentation only.
uniform sampler2D screen_tex : hint_screen_texture, filter_nearest;
uniform sampler2D mask_tex : filter_linear;
uniform float cell = 1.0;
uniform float levels = 256.0;
uniform float dither = 0.0;

float bayer(vec2 p) {
	int x = int(mod(p.x, 4.0));
	int y = int(mod(p.y, 4.0));
	int i = x + y * 4;
	int m[16] = int[16](0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5);
	return (float(m[i]) + 0.5) / 16.0 - 0.5;
}

void fragment() {
	vec2 block = floor(FRAGCOORD.xy / cell);
	vec2 centre = (block + 0.5) * cell;
	vec3 c = textureLod(screen_tex, centre * SCREEN_PIXEL_SIZE, 0.0).rgb;
	float steps = max(levels - 1.0, 1.0);
	c = floor(c * steps + 0.5 + bayer(block) * dither) / steps;
	float a = step(0.35, texture(mask_tex, UV).a);
	COLOR = vec4(clamp(c, 0.0, 1.0), a);
}
