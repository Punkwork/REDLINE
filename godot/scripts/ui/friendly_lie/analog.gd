class_name Analog
extends Control
## ENC-ANALOG-001: the Rustler's flip-clock and cockpit parts, drawn in code.
## One Control draws one instrument; `kind` picks which. Presentation only.

const BAKELITE := Color("#3E2B1D")
const BAKELITE_EDGE := Color("#1A110A")
const CREAM := Color("#F4ECDA")
const CREAM_DIM := Color("#C9B796")
const AMBER := Color("#E9963F")
const GLOW := Color("#FFB85A")
const GLASS := Color("#0A0908")
const RED := Color("#FF3A2A")
const GREEN := Color("#4DFF6E")
const BLUE := Color("#66C6FF")
const FONT = preload("res://assets/fonts/BarlowCondensed-Bold.ttf")
const FONT_SEMI = preload("res://assets/fonts/BarlowCondensed-SemiBold.ttf")

var kind := "tiles"        # tiles lamp gauge bars vial ring
var text := ""             # tiles: the characters
var tile := Vector2(20, 32)
var font_px := 22
var ink := CREAM
var value := 0.0
var maximum := 1.0
var color := GREEN
var on := false

static func bakelite(radius: int = 12) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = BAKELITE
	s.border_color = BAKELITE_EDGE; s.set_border_width_all(1)
	s.set_corner_radius_all(radius)
	s.shadow_color = Color(0, 0, 0, 0.45); s.shadow_size = 10; s.shadow_offset = Vector2(0, 6)
	s.set_content_margin_all(10)
	return s

static func glass(radius: int = 6, bezel: Color = Color("#E6DCC6")) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = GLASS; s.border_color = bezel; s.set_border_width_all(2); s.set_corner_radius_all(radius)
	s.set_content_margin_all(4)
	return s

static func tiles(t: String, size_px: Vector2 = Vector2(20, 32), px: int = 22, col: Color = CREAM) -> Analog:
	var a := Analog.new(); a.kind = "tiles"; a.text = t; a.tile = size_px; a.font_px = px; a.ink = col
	a.custom_minimum_size = Vector2(t.length() * (size_px.x + 2.0) - 2.0, size_px.y)
	a.size = a.custom_minimum_size
	return a

static func lamp(col: Color, lit: bool, d: float = 12.0) -> Analog:
	var a := Analog.new(); a.kind = "lamp"; a.color = col; a.on = lit
	a.custom_minimum_size = Vector2(d, d); a.size = a.custom_minimum_size
	return a

static func icon(k: String, d: float, col: Color) -> Analog:
	var a := Analog.new(); a.kind = "icon"; a.text = k; a.color = col
	a.custom_minimum_size = Vector2(d, d); a.size = a.custom_minimum_size
	return a

static func instrument(k: String, v: float, maxv: float, extent: Vector2, col: Color = GREEN) -> Analog:
	var a := Analog.new(); a.kind = k; a.value = v; a.maximum = maxf(1.0, maxv); a.color = col
	a.custom_minimum_size = extent; a.size = extent
	return a

func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _draw() -> void:
	match kind:
		"tiles": _tiles()
		"lamp": _lamp(size / 2.0, size.x / 2.0, color, on)
		"gauge": _gauge()
		"bars": _bars()
		"vial": _vial()
		"ring": _ring()
		"lamps": _lamps()
		"icon": _icon()

func _box(r: Rect2, col: Color, radius: float) -> void:
	var sb := StyleBoxFlat.new(); sb.bg_color = col; sb.set_corner_radius_all(int(radius)); sb.anti_aliasing = true
	draw_style_box(sb, r)

func _tiles() -> void:
	# Split-flap cards: dark rounded card, a split line, metal hinge pins.
	for i in text.length():
		var r := Rect2(Vector2(i * (tile.x + 2.0), 0), tile)
		_box(Rect2(r.position + Vector2(0, 2), r.size), Color(0, 0, 0, 0.6), 4)
		_box(r, Color("#262626"), 4)
		_box(Rect2(r.position, Vector2(r.size.x, r.size.y * 0.48)), Color("#353535"), 4)
		draw_rect(Rect2(r.position + Vector2(0, r.size.y * 0.48), Vector2(r.size.x, 2)), Color("#050505"))
		var c := text[i]
		if c != " ":
			var w := FONT.get_string_size(c, HORIZONTAL_ALIGNMENT_LEFT, -1, font_px).x
			draw_string(FONT, Vector2(r.position.x + (r.size.x - w) / 2.0, r.position.y + r.size.y * 0.5 + font_px * 0.36), c, HORIZONTAL_ALIGNMENT_LEFT, -1, font_px, ink)
		var pin := Vector2(1.5, r.size.y * 0.32)
		for x in [r.position.x + 0.5, r.end.x - 2.0]:
			draw_rect(Rect2(Vector2(x, r.position.y + r.size.y * 0.34), pin), Color("#BDBDBD"))

func _lamp(c: Vector2, r: float, col: Color, lit: bool) -> void:
	if lit: draw_circle(c, r * 1.6, Color(col, 0.22))
	draw_circle(c, r, Color(0, 0, 0, 0.7))
	draw_circle(c, r * 0.82, col if lit else Color("#3A3632"))
	if lit: draw_circle(c - Vector2(r, r) * 0.28, r * 0.3, Color(1, 1, 1, 0.85))

func _gauge() -> void:
	# Backlit needle meter: cream face, ticks, a red danger zone near the top, the needle.
	var face := Rect2(Vector2.ZERO, size)
	_box(face, Color("#8E8C85"), 6)
	var inner := face.grow(-4)
	_box(inner, Color("#F3D98F"), 4)
	_box(Rect2(inner.position + Vector2(0, inner.size.y * 0.45), Vector2(inner.size.x, inner.size.y * 0.55)), Color("#FFF3C9"), 4)
	var pivot := Vector2(inner.get_center().x, inner.end.y - 4)
	var rad := minf(inner.size.x * 0.46, inner.size.y - 10)
	var a0 := deg_to_rad(-140.0); var a1 := deg_to_rad(-40.0)
	draw_arc(pivot, rad, lerpf(a0, a1, 0.75), a1, 16, Color("#B3261A"), 4.0, true)
	draw_arc(pivot, rad, a0, lerpf(a0, a1, 0.75), 24, Color("#2A1D0E"), 1.2, true)
	for i in 11:
		var a := lerpf(a0, a1, i / 10.0)
		var l := 7.0 if i % 5 == 0 else 4.0
		draw_line(pivot + Vector2.from_angle(a) * (rad - l), pivot + Vector2.from_angle(a) * rad, Color("#2A1D0E"), 1.4, true)
	var t := clampf(value / maximum, 0.0, 1.0)
	var na := lerpf(a0, a1, t)
	draw_line(pivot, pivot + Vector2.from_angle(na) * (rad - 2), Color("#1A1A1A"), 2.0, true)
	draw_circle(pivot, 4.0, Color("#1A1A1A"))
	draw_line(inner.position + Vector2(2, 2), inner.position + Vector2(inner.size.x * 0.4, 2), Color(1, 1, 1, 0.5), 2.0)

func _bars() -> void:
	# LED bar graph, green → amber → red, one segment per unit.
	var n := int(maximum)
	var gap := 2.0
	var w := (size.x - gap * (n - 1)) / n
	for i in n:
		var r := Rect2(Vector2(i * (w + gap), 0), Vector2(w, size.y))
		var col := color
		var lit := i < int(value)
		_box(r, col if lit else Color("#222222"), 1)
		if lit: _box(r.grow(1), Color(col, 0.18), 2)

func _vial() -> void:
	# A glass tube of glowing red liquid, lying on its side, with graduation marks.
	var tube := Rect2(Vector2(0, 1), size - Vector2(0, 2))
	_box(tube, Color(1, 1, 1, 0.08), size.y / 2.0)
	var fill := Rect2(tube.position, Vector2(tube.size.x * clampf(value / maximum, 0.0, 1.0), tube.size.y))
	if fill.size.x > 2.0:
		_box(fill.grow(2), Color(1, 0.16, 0.08, 0.25), size.y / 2.0)
		_box(fill, Color("#D4180C"), size.y / 2.0)
		_box(Rect2(fill.position + Vector2(2, 2), Vector2(fill.size.x - 4, fill.size.y * 0.3)), Color("#FF6A5A"), size.y / 4.0)
	for i in range(1, 10):
		draw_line(Vector2(tube.size.x * i / 10.0, tube.end.y - 3), Vector2(tube.size.x * i / 10.0, tube.end.y), Color(0.94, 0.9, 0.82, 0.7), 1.0)
	var sb := StyleBoxFlat.new(); sb.draw_center = false; sb.border_color = Color(0.92, 0.88, 0.82, 0.6); sb.set_border_width_all(1); sb.set_corner_radius_all(int(size.y / 2.0)); sb.anti_aliasing = true
	draw_style_box(sb, tube)

func _ring() -> void:
	# Twelve blue lamps around a centre.
	var c := size / 2.0
	var r := minf(size.x, size.y) / 2.0 - 5.0
	for i in 12:
		var a := TAU * i / 12.0 - PI / 2.0
		_lamp(c + Vector2.from_angle(a) * r, 4.0, BLUE, i < int(value))

func _lamps() -> void:
	# One jewel lamp per unit (bandwidth).
	var n := int(maximum)
	var r := minf(size.y / 2.0, (size.x / n) / 2.0 - 1.0)
	for i in n:
		_lamp(Vector2(r + 1 + i * (r * 2.0 + 3.0), size.y / 2.0), r, color, i < int(value))

func _icon() -> void:
	var c := size / 2.0
	var s := size.x / 2.0
	match text:
		"VITAE":
			draw_circle(c + Vector2(-s * 0.36, -s * 0.2), s * 0.42, color)
			draw_circle(c + Vector2(s * 0.36, -s * 0.2), s * 0.42, color)
			draw_colored_polygon(PackedVector2Array([c + Vector2(-s * 0.78, -s * 0.05), c + Vector2(s * 0.78, -s * 0.05), c + Vector2(0, s * 0.85)]), color)
		"BW":
			draw_colored_polygon(PackedVector2Array([c + Vector2(s * 0.15, -s * 0.95), c + Vector2(-s * 0.55, s * 0.12), c + Vector2(-s * 0.02, s * 0.12), c + Vector2(-s * 0.2, s * 0.95), c + Vector2(s * 0.55, -s * 0.15), c + Vector2(s * 0.02, -s * 0.15)]), color)
		"SHIELD":
			draw_colored_polygon(PackedVector2Array([c + Vector2(0, -s * 0.9), c + Vector2(s * 0.75, -s * 0.6), c + Vector2(s * 0.6, s * 0.3), c + Vector2(0, s * 0.9), c + Vector2(-s * 0.6, s * 0.3), c + Vector2(-s * 0.75, -s * 0.6)]), color)
		"PULP":
			var pts := PackedVector2Array()
			for i in 16:
				var a := TAU * i / 16.0 - PI / 2.0
				pts.append(c + Vector2(cos(a), sin(a)) * (s * 0.9 if i % 2 == 0 else s * 0.4))
			draw_colored_polygon(pts, color)
		"DRAW":
			draw_rect(Rect2(c + Vector2(-s * 0.7, -s * 0.6), Vector2(s * 0.95, s * 1.3)), color, false, 2.0)
			draw_rect(Rect2(c + Vector2(-s * 0.3, -s * 0.85), Vector2(s * 0.95, s * 1.3)), color, false, 2.0)
		"EYE":
			var lid := PackedVector2Array()
			for i in 21:
				var t := float(i) / 20.0
				lid.append(c + Vector2(lerpf(-s, s, t), -sin(t * PI) * s * 0.6))
			for i in 21:
				var t := 1.0 - float(i) / 20.0
				lid.append(c + Vector2(lerpf(-s, s, t), sin(t * PI) * s * 0.6))
			draw_colored_polygon(lid, color)
			draw_circle(c, s * 0.42, Color("#2A1D0E"))
			draw_circle(c, s * 0.2, color)
