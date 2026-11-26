class_name SpeechBubble
extends Control
## ARCH-V2-003p (PROPOSED): the ICE's comic speech bubble, beside the avatar as in VAS-001.
## Ivory balloon, ink text (contrast well over 4.5:1), tail pointing left at the portrait.
## Presentation only; what it says and when is decided by the copy system (ADP/VIS-001 lines).

const FILL := Color("#FFF8E6")
const EDGE := Color("#2A2018")
const INK := Color("#2A2018")
const TAIL := 22.0

var text := "":
	set(v):
		text = v
		if _label: _label.text = v
var font_px := 18:
	set(v):
		font_px = v
		if _label: _label.add_theme_font_size_override("font_size", v)

var art: Texture2D   ## painted balloon (tail lower left); null = drawn balloon
var _label: Label

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label = Label.new()
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.add_theme_font_override("font", VasTokens.FONT_PLAQUE_SEMI)
	_label.add_theme_color_override("font_color", INK)
	_label.add_theme_font_size_override("font_size", font_px)
	_label.text = text
	add_child(_label)
	resized.connect(_fit)
	_fit()

func _fit() -> void:
	if _label == null: return
	if art:
		# Text inside the painted oval: clear of the rim and the tail.
		_label.position = Vector2(size.x * 0.14, size.y * 0.14)
		_label.size = Vector2(size.x * 0.72, size.y * 0.62)
	else:
		_label.position = Vector2(TAIL + 12.0, 8.0)
		_label.size = Vector2(maxf(0.0, size.x - TAIL - 24.0), maxf(0.0, size.y - 16.0))
	queue_redraw()

func _draw() -> void:
	if text == "": return
	if art:
		draw_texture_rect(art, Rect2(Vector2.ZERO, size), false)
		return
	var body := Rect2(Vector2(TAIL, 0), size - Vector2(TAIL, 0))
	var sb := StyleBoxFlat.new()
	sb.bg_color = FILL; sb.border_color = EDGE; sb.set_border_width_all(3)
	sb.set_corner_radius_all(int(minf(body.size.y * 0.5, 34.0))); sb.anti_aliasing = true
	var cy := clampf(body.size.y * 0.62, 18.0, body.size.y - 18.0)
	var tail := PackedVector2Array([Vector2(TAIL + 6, cy - 12), Vector2(0, cy + 10), Vector2(TAIL + 10, cy + 8)])
	draw_colored_polygon(tail, FILL)
	draw_polyline(PackedVector2Array([tail[0], tail[1], tail[2]]), EDGE, 3.0, true)
	draw_style_box(sb, body)
	# Re-cover the tail's root so the outline reads as one balloon.
	draw_line(Vector2(TAIL + 1.5, cy - 9), Vector2(TAIL + 1.5, cy + 5), FILL, 4.0)
