class_name LethalLens
extends Control
## UI-TYPO-002 (M06) LETHAL · Cold Recognition: a red optical lens (HAL 9000-inspired) with restrained,
## thin, tracked capitals, on the affected ICE's own portrait only. No global announcement. It stays
## for as long as that ICE is LETHAL and is utterly still: it fades in once (the recognition) and does
## not pulse, drift or flash. Under reduced motion it appears at once. Values in VasTokens.LETHAL_LENS.
## Presentation only: the panel shows it from the ICE model's `lethal` flag; it never reads rules.

var reduced_motion := false
var active := false
var _age := 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var L := VasTokens.LETHAL_LENS
	var r: float = L.radius
	var font: Font = L.font
	var tw := font.get_string_size(String(L.text), HORIZONTAL_ALIGNMENT_LEFT, -1, int(L.px)).x + float(L.tracking) * (String(L.text).length() - 1)
	size = Vector2(maxf(r * 2.0, tw + 20.0), r * 2.0 + float(L.px) + 18.0)
	custom_minimum_size = size
	set_process(false)
	visible = false

## Show or clear the lens. Turning on starts the one-time recognition fade.
func set_active(on: bool) -> void:
	if on == active: return
	active = on
	visible = on
	_age = 0.0
	set_process(on and not reduced_motion)
	queue_redraw()

## 0..1 opacity right now (tests: it settles at 1 and stays there, no flicker).
func opacity() -> float:
	if not active: return 0.0
	if reduced_motion: return 1.0
	return clampf(_age / float(VasTokens.LETHAL_LENS.fade_in), 0.0, 1.0)

## Deterministic stepping for tests and fixtures.
func advance(dt: float) -> void:
	_age += dt
	if _age >= float(VasTokens.LETHAL_LENS.fade_in): set_process(false)
	queue_redraw()

func _process(delta: float) -> void:
	advance(delta)

func _draw() -> void:
	if not active: return
	var L := VasTokens.LETHAL_LENS
	var a := opacity()
	var r: float = L.radius
	var c := Vector2(size.x / 2.0, r)
	# Chrome bezel: dark ring, bright hairline, then black glass.
	draw_circle(c, r, Color(L.rim_lo, a))
	draw_arc(c, r - 1.5, PI * 0.9, PI * 2.1, 32, Color(L.rim_hi, 0.8 * a), 2.0, true)
	draw_circle(c, r * 0.80, Color(L.glass, a))
	# The eye: a deep red glow that brightens toward a small hot centre.
	var steps := 22
	for i in steps:
		var k := 1.0 - float(i) / float(steps)
		var col: Color = Color(L.glass).lerp(L.core, smoothstep(0.0, 0.7, 1.0 - k))
		if k < 0.22: col = Color(L.core).lerp(L.hot, smoothstep(0.22, 0.0, k))
		draw_circle(c, r * 0.74 * k, Color(col, a))
	# A cold specular glint on the glass.
	draw_arc(c, r * 0.62, PI * 1.12, PI * 1.42, 12, Color(1, 1, 1, 0.32 * a), 2.0, true)
	# Thin capitals on a dark plate (≥ 4.5:1, tested).
	var font: Font = L.font
	var px: int = L.px
	var trk: float = L.tracking
	var text := String(L.text)
	var tw := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x + trk * (text.length() - 1)
	var plate := Rect2(Vector2(size.x / 2.0 - tw / 2.0 - 8.0, r * 2.0 + 6.0), Vector2(tw + 16.0, px + 8.0))
	draw_rect(plate, Color(L.plate, float(L.plate_alpha) * a))
	var x := plate.position.x + 8.0
	for ch in text:
		draw_string(font, Vector2(x, plate.position.y + px * 0.92), ch, HORIZONTAL_ALIGNMENT_LEFT, -1, px, Color(L.ink, a))
		x += font.get_string_size(ch, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x + trk
