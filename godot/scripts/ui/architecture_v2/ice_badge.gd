class_name IceBadge
extends Control
## CAS-001 C08 identity badges (ARCH-V2-003): the ICE type icon (on the portrait's upper-left corner)
## and the STR icon with its number (on the nameplate's upper-right corner). Drawn enamel discs until
## final art lands: a texture set in IcePanelLayout replaces the drawn glyph without code changes.
## Focusable: hover or focus asks the panel's inspector for the full explanation.

signal inspect_requested(badge: IceBadge)
signal inspect_ended(badge: IceBadge)

var kind := "type"      # "type" or "str"
var ice_type := "FORTRESS"
var value := 0
var delta := 0          # STR above/below printed
var texture: Texture2D
var lit := false

func _init() -> void:
	focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_entered.connect(func(): lit = true; queue_redraw(); inspect_requested.emit(self))
	focus_entered.connect(func(): lit = true; queue_redraw(); inspect_requested.emit(self))
	mouse_exited.connect(_release)
	focus_exited.connect(_release)

func _release() -> void:
	if not is_inside_tree() or is_queued_for_deletion(): return
	if has_focus() or get_global_rect().has_point(get_global_mouse_position()): return
	lit = false; queue_redraw(); inspect_ended.emit(self)

func set_badge(k: String, t: String, v: int, d: int, tex: Texture2D, diameter: float) -> void:
	kind = k; ice_type = t; value = v; delta = d; texture = tex
	custom_minimum_size = Vector2(diameter, diameter)
	size = custom_minimum_size
	queue_redraw()

func _draw() -> void:
	var r := size.x / 2.0
	var c := size / 2.0
	# Chrome rim, enamel face.
	draw_circle(c + Vector2(0, 3), r, Color(0, 0, 0, 0.35))
	draw_circle(c, r, VasTokens.CHROME_LO)
	draw_circle(c, r - 2.0, VasTokens.CHROME_HI)
	var face_col := VasTokens.PLAQUE if kind == "str" else _type_colour()
	draw_circle(c, r - 6.0, face_col)
	if lit:
		draw_arc(c, r + 3.0, 0, TAU, 48, VasTokens.FOCUS, 3.0, true)
	if texture:
		var s := (r - 8.0) * 2.0
		draw_texture_rect(texture, Rect2(c - Vector2(s, s) / 2.0, Vector2(s, s)), false)
		if kind == "str": _number(c + Vector2(0, r * 0.18), r)
		return
	if kind == "str":
		_str_glyph(c + Vector2(0, -r * 0.42), r * 0.26)
		_number(c + Vector2(0, r * 0.16), r)
		return
	match ice_type:
		"FORTRESS": _fortress(c, r * 0.5)
		"TUMBLER": _tumbler(c, r * 0.5)
		"VOID": _void(c, r * 0.52)
		_: _number(c, r)

func _type_colour() -> Color:
	match ice_type:
		"FORTRESS": return Color("#8C2A1E")    # hits hard
		"TUMBLER": return Color("#1F5E6E")     # puzzles
		"VOID": return Color("#141018")        # where the deadly happens
	return VasTokens.PLAQUE

func _number(c: Vector2, r: float) -> void:
	var text := str(value)
	var fs := int(r * (0.95 if text.length() < 2 else 0.8))
	var font := VasTokens.FONT_PLAQUE
	var w := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
	var col := VasTokens.IVORY
	if delta > 0: col = Color("#FFB0A0")
	elif delta < 0: col = Color("#9BF0B4")
	draw_string(font, c + Vector2(-w.x / 2.0, fs * 0.36), text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)

func _str_glyph(c: Vector2, s: float) -> void:
	# A small hexagonal armour nut: "strength".
	var pts := PackedVector2Array()
	for k in 6: pts.append(c + Vector2.from_angle(TAU * k / 6.0 + PI / 6.0) * s)
	draw_colored_polygon(pts, VasTokens.AMBER)
	draw_circle(c, s * 0.4, VasTokens.PLAQUE)

func _fortress(c: Vector2, s: float) -> void:
	var ivory := VasTokens.IVORY
	var base := Rect2(c + Vector2(-s, -s * 0.35), Vector2(s * 2.0, s * 1.35))
	draw_rect(base, ivory)
	for k in 3:
		draw_rect(Rect2(base.position + Vector2(k * s * 0.8, -s * 0.45), Vector2(s * 0.42, s * 0.5)), ivory)
	draw_rect(Rect2(c + Vector2(-s * 0.22, s * 0.35), Vector2(s * 0.44, s * 0.65)), _type_colour())

func _tumbler(c: Vector2, s: float) -> void:
	var ivory := VasTokens.IVORY
	draw_arc(c, s, 0.3, TAU - 0.3, 32, ivory, s * 0.28, true)
	var tip := c + Vector2.from_angle(0.3) * s
	draw_colored_polygon(PackedVector2Array([tip + Vector2(-s * 0.35, -s * 0.05), tip + Vector2(s * 0.3, -s * 0.05), tip + Vector2(0, s * 0.45)]), ivory)
	for k in 3: draw_circle(c + Vector2.from_angle(TAU * k / 3.0 - PI / 2.0) * s * 0.42, s * 0.16, ivory)

func _void(c: Vector2, s: float) -> void:
	# An eye opening on darkness: face-down subroutines.
	var pts := PackedVector2Array()
	for k in 25:
		var t := PI * k / 24.0
		pts.append(c + Vector2(-cos(t) * s * 1.15, -sin(t) * s * 0.62))
	for k in 25:
		var t := PI * k / 24.0
		pts.append(c + Vector2(cos(t) * s * 1.15, sin(t) * s * 0.62))
	draw_colored_polygon(pts, Color("#C8B8F0"))
	draw_circle(c, s * 0.5, VasTokens.WARNING)
	draw_circle(c, s * 0.26, Color.BLACK)
