shader_type canvas_item;
// ENC-CONCEPT-001 console colour: repaint the painted seafoam enamel of UI_ICE_CONSOLE_2 in a
// corporation's enamel (IRONWATCH navy, LUCIDA lilac) until per-corporation art exists.
// Only saturated green-to-cyan pixels change; chrome, brass, dark slots and shadows keep their
// colour. The panel's shading is kept by scaling value: the plain panel (#93BBA4) maps exactly
// to the target colour. Presentation only. No source_color hint: 2D colours stay sRGB here,
// and the hint would linearise the target.
uniform vec4 target = vec4(0.12, 0.23, 0.37, 1.0);
const float BASE_V = 0.733;   // value of the plain panel, #93BBA4

vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv2rgb(vec3 c) {
	vec3 p = abs(fract(c.xxx + vec3(0.0, 2.0 / 3.0, 1.0 / 3.0)) * 6.0 - 3.0);
	return c.z * mix(vec3(1.0), clamp(p - 1.0, 0.0, 1.0), c.y);
}

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	vec3 hsv = rgb2hsv(col.rgb);
	vec3 t = rgb2hsv(target.rgb);
	// seafoam enamel: green to cyan hues with some saturation
	float enamel = smoothstep(0.08, 0.16, hsv.y) * smoothstep(0.24, 0.30, hsv.x) * (1.0 - smoothstep(0.52, 0.58, hsv.x));
	vec3 painted = hsv2rgb(vec3(t.x, t.y * clamp(hsv.y / 0.21, 0.6, 1.4), clamp(hsv.z * t.z / BASE_V, 0.0, 1.0)));
	COLOR = vec4(mix(col.rgb, painted, enamel), col.a);
}
