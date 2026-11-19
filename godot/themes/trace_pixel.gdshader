shader_type canvas_item;
// PIXEL-TRACE-001 (PROPOSED): as TRACE rises, the corporation's picture drops
// toward 16-bit. Reads what is already drawn underneath (backdrop or mascot art)
// and redraws it in square cells on a screen-aligned grid, with fewer colour
// levels and a 4x4 ordered dither. Presentation only; text is never under it.
uniform sampler2D screen_tex : hint_screen_texture, filter_nearest;
uniform float cell = 1.0;      // cell size in framebuffer pixels; 1 = off
uniform float levels = 256.0;  // colour levels per channel
uniform float dither = 0.0;    // 0..1 ordered-dither strength

float bayer(vec2 p) {
	int x = int(mod(p.x, 4.0));
	int y = int(mod(p.y, 4.0));
	int i = x + y * 4;
	int m[16] = int[16](0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5);
	return (float(m[i]) + 0.5) / 16.0 - 0.5;
}

void fragment() {
	vec2 px = FRAGCOORD.xy;
	vec2 block = floor(px / cell);
	vec2 centre = (block + 0.5) * cell;
	vec3 c = textureLod(screen_tex, centre * SCREEN_PIXEL_SIZE, 0.0).rgb; // LOD 0: the stepped UVs would otherwise pick a blurred mip at cell edges
	float steps = max(levels - 1.0, 1.0);
	c = floor(c * steps + 0.5 + bayer(block) * dither) / steps;
	COLOR = vec4(clamp(c, 0.0, 1.0), 1.0);
}
