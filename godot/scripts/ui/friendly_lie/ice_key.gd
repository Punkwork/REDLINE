class_name IceKey
extends Control
## ICE-ANALOG-001: one subroutine drawn as an instrument key: a glyph and a value,
## a status lamp and a BW chip. The full rule lives in the encounter's key tooltip.
## Presentation only; the key never reads or changes rules state on its own.

const FACE := Color("#F4ECDA")
const FACE_LOW := Color("#DCCFB2")
const INK := Color("#2A1D0E")
const CHROME_HI := Color("#FBFCFC")
const CHROME_LO := Color("#8E9698")
const RED := Color("#D8321F")
const RED_DEEP := Color("#7A1208")
const GREEN := Color("#3C9A62")
const AMBER := Color("#FFB020")
const LAMP_GREEN := Color("#4DFF6E")
const GLASS := Color("#141210")
const FOCUS := Color("#165B55")
const KEY := 60.0
const CHIP_H := 18.0
const FONT = preload("res://assets/fonts/BarlowCondensed-Bold.ttf")
const FONT_SEMI = preload("res://assets/fonts/BarlowCondensed-SemiBold.ttf")

var kind := "PULP"        # PULP TRACE DEADLOCK DISCARD INSERT BW_DRAIN CORTEX FORGET HIDDEN
var value := ""           # big numeral ("" for none)
var badge := ""           # "", "lock" (also a DEADLOCK), "dice" (random curve), "hammer", "up" (escalates)
var extra := 0            # further effects on the same subroutine
var state := "ready"      # ready deadlock broken hidden hit new
var cost := ""            # chip text: "1 BW", "FREE", "—"
var firing := false
var locked := false       # BOOTING: not breakable yet
var lit := false          # hovered or focused (drawn ring)
var small := false        # spent / pool chips in the TUMBLER strip
var pulse := 0.0

func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

const LAMP_H := 14.0

var u := 1.0               # ENC-CONCEPT-001 layout pass: console keys scale with the console (concept 2's big keys)

func configure(k: String, v: String, s: String, chip: String, is_small: bool = false, unit: float = 1.0) -> void:
	kind = k; value = v; state = s; cost = chip; small = is_small; u = 1.0 if small else unit
	var d := 30.0 if small else KEY * u
	custom_minimum_size = Vector2(d + (0.0 if small else 8.0 * u), d + (0.0 if small else LAMP_H * u) + (0.0 if small or chip == "" else (CHIP_H + 4.0) * u))
	size = custom_minimum_size
	queue_redraw()

func key_rect() -> Rect2:
	var d := 30.0 if small else KEY * u
	return Rect2(Vector2((size.x - d) / 2.0, 0.0 if small else LAMP_H * u), Vector2(d, d))

func _process(delta: float) -> void:
	if firing:
		pulse += delta
		queue_redraw()

func _box(r: Rect2, col: Color, radius: float, border: Color = Color.TRANSPARENT, bw: float = 0.0) -> void:
	var sb := StyleBoxFlat.new()
	sb.bg_color = col; sb.set_corner_radius_all(int(radius)); sb.anti_aliasing = true
	if bw > 0.0:
		sb.border_color = border; sb.set_border_width_all(int(bw))
	draw_style_box(sb, r)

const ART := "res://assets/concept/ui/"
static var art_cache := {}

static func art(name: String) -> Texture2D:
	## ENC-CONCEPT-001 painted parts; null when a part hasn't been delivered (the vector look draws instead).
	if not art_cache.has(name):
		var path := ART + name + ".png"
		art_cache[name] = load(path) if ResourceLoader.exists(path) else null
	return art_cache[name]

func _draw() -> void:
	var cap := art("UI_KEY_READY")
	if cap == null:
		_draw_vector()
		return
	var kr := key_rect()
	var c := kr.get_center()
	var broken := state == "broken"
	var hidden := state == "hidden"
	var deadlock := kind == "DEADLOCK"
	var cap_name := "UI_KEY_READY"
	if hidden: cap_name = "UI_KEY_HIDDEN"
	elif deadlock: cap_name = "UI_KEY_DEADLOCK_OPEN" if broken else "UI_KEY_DEADLOCK"
	elif broken: cap_name = "UI_KEY_BROKEN"
	elif state == "hit": cap_name = "UI_KEY_HIT"
	elif state == "new": cap_name = "UI_KEY_TUMBLED"
	if not small:
		var lamp_name := "UI_KEY_LAMP_OFF"
		if not broken and not hidden:
			lamp_name = "UI_KEY_LAMP_RED" if state == "hit" else ("UI_KEY_LAMP_AMBER" if deadlock or locked or state == "new" else "UI_KEY_LAMP_GREEN")
		var lamp := art(lamp_name)
		if lamp: draw_texture_rect(lamp, Rect2(Vector2(c.x - 7 * u, 0), Vector2(14, 14) * u), false)
	if firing:
		var a := 0.45 + 0.35 * sin(pulse * TAU * 2.0)
		_box(kr.grow(4), Color(RED, 0.3 * a), 14)
	if lit:
		var glow := art("UI_KEY_GLOW")
		if glow: draw_texture_rect(glow, kr.grow(kr.size.x * 0.22), false)
		_box(kr.grow(6), Color.TRANSPARENT, 16, FOCUS, 2)
	draw_texture_rect(art(cap_name), kr.grow(2), false)
	var face := kr.grow(-kr.size.x * 0.16)
	var light := deadlock or hidden
	var icon_name := "ICON_HIDDEN" if hidden else ("ICON_DEADLOCK_OPEN" if deadlock and broken else ("ICON_" + kind))
	var icon := art(icon_name + ("_LIGHT" if light else ""))
	var with_value := value != "" and not small and not hidden
	var tint := Color(1, 1, 1, 0.42 if broken and not deadlock else 1.0)
	if icon:
		var isz := face.size.y * (0.52 if with_value else 0.72)
		var ic := c + (Vector2(0, -face.size.y * 0.17) if with_value else Vector2.ZERO)
		draw_texture_rect(icon, Rect2(ic - Vector2(isz, isz) / 2.0, Vector2(isz, isz)), false, tint)
	else:
		_icon(kind, c + (Vector2(0, -face.size.y * 0.17) if with_value else Vector2.ZERO), face.size.y * (0.22 if with_value else 0.3), Color(INK, tint.a))
	if with_value:
		var fs := int((24 if value.length() <= 2 else 18) * u)
		var tw := FONT.get_string_size(value, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
		draw_string(FONT, Vector2(c.x - tw.x / 2.0, face.end.y + 3 * u), value, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color(CREAM_INK if light else INK, tint.a))
	if broken and not deadlock:
		draw_line(face.position + Vector2(4, face.size.y - 4), face.position + Vector2(face.size.x - 4, 4), Color(INK, 0.8), 3.0, true)
	if not small and (badge != "" or locked):
		var bp := kr.position + Vector2(kr.size.x - 3, 3)
		var bi := art("ICON_BOOTING_LIGHT") if locked else null
		draw_circle(bp, 10.0 * u, Color("#2E2016"))
		if bi: draw_texture_rect(bi, Rect2(bp - Vector2(7, 7) * u, Vector2(14, 14) * u), false)
		else: _badge(bp)
	if extra > 0 and not small:
		var p := kr.position + Vector2(3, kr.size.y - 3)
		draw_circle(p, 9.0, INK)
		draw_string(FONT, p + Vector2(-7, 5), "+%d" % extra, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, FACE)
	if cost != "" and not small:
		var chip := Rect2(Vector2(size.x / 2.0 - 26 * u, kr.end.y + 4 * u), Vector2(52, CHIP_H + 1) * u)
		var chip_art := art("UI_BW_CHIP")
		if chip_art: draw_texture_rect(chip_art, chip, false)
		else: _box(chip, Color("#2E2016"), 9)
		var cfs := int(13 * u)
		var cw := FONT_SEMI.get_string_size(cost, HORIZONTAL_ALIGNMENT_LEFT, -1, cfs).x
		draw_string(FONT_SEMI, Vector2(chip.get_center().x - cw / 2.0, chip.position.y + chip.size.y * 0.74), cost, HORIZONTAL_ALIGNMENT_LEFT, -1, cfs, Color("#F4ECDA") if cost != "—" else Color("#B8A890"))

const CREAM_INK := Color("#F6EEDC")

func _draw_vector() -> void:
	var kr := key_rect()
	var c := kr.get_center()
	var rad := 7.0 if small else 12.0
	var broken := state == "broken"
	var hidden := state == "hidden"
	var deadlock := kind == "DEADLOCK"
	# Lamp above the key: lit while the subroutine will fire.
	if not small:
		var lp := Vector2(c.x, 6.0)
		var on := not broken and not hidden
		var col := RED if state == "hit" else (AMBER if deadlock or locked or state == "new" else LAMP_GREEN)
		if on: draw_circle(lp, 7.0, Color(col, 0.25))
		draw_circle(lp, 4.5, Color(0, 0, 0, 0.55))
		draw_circle(lp, 3.6, col if on else Color("#3A3632"))
		if on: draw_circle(lp - Vector2(1, 1), 1.3, Color(1, 1, 1, 0.85))
	# Halo: biggest hit, fresh slot, firing.
	if state == "hit" or firing:
		var a := 0.6 + (0.35 * sin(pulse * TAU * 2.0) if firing else 0.0)
		_box(kr.grow(6), Color(RED, 0.22 * a), rad + 6)
		_box(kr.grow(3), Color.TRANSPARENT, rad + 3, Color(RED, a), 3)
	elif state == "new":
		_box(kr.grow(3), Color.TRANSPARENT, rad + 3, AMBER, 2)
	if lit:
		_box(kr.grow(7), Color.TRANSPARENT, rad + 7, FOCUS, 2)
	# Chrome bezel with a drop shadow, then the key face.
	_box(Rect2(kr.position + Vector2(0, 3), kr.size), Color(0, 0, 0, 0.32), rad)
	_box(kr, CHROME_LO, rad)
	_box(Rect2(kr.position, kr.size - Vector2(0, 2)), CHROME_HI, rad)
	var inset := 3.0 if small else 4.0
	var face := kr.grow(-inset)
	if hidden:
		_box(face, GLASS, rad - 2)
		_dashed_rect(face.grow(-3), Color("#B9C0C2"))
		_glyph_text("?", c, face.size.y * 0.55, Color("#E6DCC6"))
		return
	if deadlock:
		var top := GREEN if broken else RED
		var bottom := Color("#1C5A36") if broken else RED_DEEP
		_box(face, bottom, rad - 2)
		_box(Rect2(face.position, face.size - Vector2(0, 3)), top, rad - 2)
		_box(Rect2(face.position + Vector2(3, 3), Vector2(face.size.x - 6, face.size.y * 0.4)), Color(1, 1, 1, 0.16), rad - 4)
		_padlock(c, face.size.y * 0.3, Color(1, 1, 1, 0.95), broken)
	else:
		_box(face, FACE_LOW if broken else (Color("#FFD9CF") if state == "hit" else FACE), rad - 2)
		_box(Rect2(face.position + Vector2(3, 2), Vector2(face.size.x - 6, face.size.y * 0.35)), Color(1, 1, 1, 0.45), rad - 4)
		var ink := Color(INK, 0.38 if broken else 1.0)
		var with_value := value != "" and not small
		var g_c := c + (Vector2(0, -face.size.y * 0.16) if with_value else Vector2.ZERO)
		_icon(kind, g_c, face.size.y * (0.22 if with_value else 0.3), ink)
		if with_value:
			var fs := 24 if value.length() <= 2 else 18
			var tw := FONT.get_string_size(value, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
			draw_string(FONT, Vector2(c.x - tw.x / 2.0, face.end.y - 5), value, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, ink)
	if broken and not deadlock:
		draw_line(face.position + Vector2(5, face.size.y - 5), face.position + Vector2(face.size.x - 5, 5), Color(INK, 0.85), 3.0, true)
	if badge != "" and not small:
		_badge(kr.position + Vector2(kr.size.x - 2, 2))
	if extra > 0 and not small:
		var p := kr.position + Vector2(2, kr.size.y - 2)
		draw_circle(p, 8.0, INK)
		draw_string(FONT, p + Vector2(-6, 5), "+%d" % extra, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, FACE)
	if cost != "" and not small:
		var chip := Rect2(Vector2(size.x / 2.0 - 24, kr.end.y + 5), Vector2(48, CHIP_H))
		_box(chip, Color("#2E2016"), 9)
		var cw := FONT_SEMI.get_string_size(cost, HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x
		draw_string(FONT_SEMI, Vector2(chip.get_center().x - cw / 2.0, chip.position.y + 14), cost, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("#F4ECDA") if cost != "—" else Color("#B8A890"))

func _dashed_rect(r: Rect2, col: Color) -> void:
	var pts := [r.position, Vector2(r.end.x, r.position.y), r.end, Vector2(r.position.x, r.end.y)]
	for i in 4:
		draw_dashed_line(pts[i], pts[(i + 1) % 4], col, 2.0, 5.0)

func _glyph_text(t: String, c: Vector2, px: float, col: Color) -> void:
	var w := FONT.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, int(px)).x
	draw_string(FONT, c + Vector2(-w / 2.0, px * 0.36), t, HORIZONTAL_ALIGNMENT_LEFT, -1, int(px), col)

func _dashed_ring(c: Vector2, r: float, col: Color) -> void:
	for i in 12:
		var a := TAU * i / 12.0
		draw_arc(c, r, a, a + TAU / 24.0, 4, col, 2.0, true)

func _padlock(c: Vector2, s: float, col: Color, open: bool) -> void:
	var body := Rect2(c + Vector2(-s * 0.62, -s * 0.05), Vector2(s * 1.24, s * 0.95))
	var sb := StyleBoxFlat.new(); sb.bg_color = col; sb.set_corner_radius_all(int(s * 0.18))
	draw_style_box(sb, body)
	var sh_c := c + Vector2(s * (0.45 if open else 0.0), -s * 0.05)
	draw_arc(sh_c, s * 0.42, PI, TAU, 16, col, s * 0.22, true)
	draw_line(sh_c + Vector2(-s * 0.42, 0), sh_c + Vector2(-s * 0.42, s * (-0.35 if open else 0.1)), col, s * 0.22, true)
	draw_line(sh_c + Vector2(s * 0.42, 0), sh_c + Vector2(s * 0.42, s * 0.1), col, s * 0.22, true)
	draw_circle(body.get_center(), s * 0.13, Color(RED_DEEP if not open else Color("#1C5A36"), 0.9))

func _icon(k: String, c: Vector2, s: float, col: Color) -> void:
	match k:
		"PULP":
			# The HUD's PULP starburst.
			var pts := PackedVector2Array()
			for i in 16:
				var a := TAU * i / 16.0 - PI / 2.0
				pts.append(c + Vector2(cos(a), sin(a)) * (s if i % 2 == 0 else s * 0.42))
			draw_colored_polygon(pts, col)
		"TRACE":
			# The HUD's TRACE orbit: a tilted ring around a core.
			var ring := PackedVector2Array()
			for i in 33:
				var a := TAU * i / 32.0
				var p := Vector2(cos(a) * s, sin(a) * s * 0.42).rotated(-0.45)
				ring.append(c + p)
			draw_polyline(ring, col, maxf(1.6, s * 0.16), true)
			draw_circle(c, s * 0.3, col)
			draw_circle(c + Vector2(s * 0.7, -s * 0.62), s * 0.13, col)
		"CORTEX":
			draw_arc(c + Vector2(-s * 0.32, -s * 0.12), s * 0.5, PI * 0.5, PI * 1.9, 18, col, s * 0.16, true)
			draw_arc(c + Vector2(s * 0.32, -s * 0.12), s * 0.5, -PI * 0.9, PI * 0.5, 18, col, s * 0.16, true)
			draw_line(c + Vector2(0, -s * 0.6), c + Vector2(0, s * 0.55), col, s * 0.14, true)
			draw_line(c + Vector2(-s * 0.32, s * 0.38), c + Vector2(s * 0.32, s * 0.38), col, s * 0.14, true)
		"DISCARD":
			var card := Rect2(c + Vector2(-s * 0.75, -s * 0.8), Vector2(s * 0.95, s * 1.4))
			draw_rect(card, col, false, maxf(1.6, s * 0.15))
			draw_line(c + Vector2(-s * 0.05, s * 0.05), c + Vector2(s * 0.9, s * 0.05), col, s * 0.16, true)
			draw_line(c + Vector2(s * 0.55, -s * 0.3), c + Vector2(s * 0.9, s * 0.05), col, s * 0.16, true)
			draw_line(c + Vector2(s * 0.55, s * 0.4), c + Vector2(s * 0.9, s * 0.05), col, s * 0.16, true)
		"INSERT":
			var env := Rect2(c + Vector2(-s * 0.9, -s * 0.6), Vector2(s * 1.8, s * 1.2))
			draw_rect(env, col, false, maxf(1.6, s * 0.15))
			draw_polyline(PackedVector2Array([env.position, c + Vector2(0, s * 0.1), Vector2(env.end.x, env.position.y)]), col, s * 0.15, true)
		"BW_DRAIN":
			draw_line(c + Vector2(0, s * 0.9), c + Vector2(0, -s * 0.2), col, s * 0.16, true)
			draw_line(c + Vector2(-s * 0.5, s * 0.9), c + Vector2(s * 0.5, s * 0.9), col, s * 0.16, true)
			draw_arc(c + Vector2(0, -s * 0.2), s * 0.45, -PI * 0.85, -PI * 0.15, 12, col, s * 0.13, true)
			draw_arc(c + Vector2(0, -s * 0.2), s * 0.85, -PI * 0.82, -PI * 0.18, 16, col, s * 0.13, true)
			draw_line(c + Vector2(s * 0.45, s * 0.35), c + Vector2(s * 0.95, s * 0.35), col, s * 0.16, true)
		"FORGET":
			draw_arc(c, s * 0.75, PI * 0.2, PI * 1.8, 20, col, s * 0.16, true)
			draw_line(c + Vector2(-s * 0.5, s * 0.5), c + Vector2(s * 0.5, -s * 0.5), col, s * 0.16, true)
		"DEADLOCK":
			_padlock(c, s, col, false)
		_:
			_glyph_text(k.substr(0, 2), c, s * 1.2, col)

func _badge(p: Vector2) -> void:
	draw_circle(p, 9.0, Color("#2E2016"))
	match badge:
		"lock": _padlock(p, 5.5, Color("#FFB85A"), false)
		"dice":
			draw_rect(Rect2(p - Vector2(5, 5), Vector2(10, 10)), Color("#FFB85A"), false, 1.5)
			draw_circle(p, 1.4, Color("#FFB85A"))
		"hammer":
			draw_line(p + Vector2(-4, 5), p + Vector2(3, -2), Color("#FFB85A"), 2.0)
			draw_rect(Rect2(p + Vector2(0, -6), Vector2(7, 4)), Color("#FFB85A"))
		"up":
			draw_colored_polygon(PackedVector2Array([p + Vector2(0, -5), p + Vector2(5, 3), p + Vector2(-5, 3)]), Color("#FFB85A"))
