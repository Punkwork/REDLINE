class_name LitKey
extends IceKey
## ARCH-V2-003r (PROPOSED; designer 2026-11-26 15:25): the subroutine key as a thick, raised panel
## push-button lit from inside, as on old control panels: a dark socket, a translucent cap with a
## visible side (thickness), a specular band, light glowing out around it, and a drop shadow so it
## reads above the avatar it floats over. The cap's light is the state (no separate lamp):
##   ready    warm cream-amber           DEADLOCK  red
##   hit      bright red, strong glow    new       (TUMBLED) amber, strong glow
##   locked   (BOOTING) dim amber        broken    unlit (dark cap, icon faded, slash)
##   hidden   smoked glass, unlit "?"
## Same fields and size contract as IceKey (Build 12's renderer stays untouched for `main`);
## icons and numbers come from the same art. Mini reel chips still use IceKey's drawing.

const SOCKET := Color("#15100C")
const SOCKET_RIM := Color("#6B5A4A")
const SHADOW := Color(0, 0, 0, 0.55)

func _state_colors() -> Dictionary:
	## top / bottom of the lit cap, glow colour and strength, ink for the glyph.
	var deadlock := kind == "DEADLOCK"
	if state == "hidden":
		return {"top": Color("#4A443E"), "bot": Color("#231F1B"), "glow": Color.TRANSPARENT, "g": 0.0, "ink": CREAM_INK, "lit": false}
	if state == "broken":
		return {"top": Color("#7A6F62"), "bot": Color("#4B4239"), "glow": Color.TRANSPARENT, "g": 0.0, "ink": Color("#2A2018"), "lit": false}
	if state == "hit":
		return {"top": Color("#FFB09A"), "bot": Color("#E0301C"), "glow": Color("#FF4A2A"), "g": 1.0, "ink": Color("#2A0A04"), "lit": true}
	if deadlock:
		return {"top": Color("#FF9A84"), "bot": Color("#B8200F"), "glow": Color("#FF3A1E"), "g": 0.75, "ink": CREAM_INK, "lit": true}
	if state == "new":
		return {"top": Color("#FFF0B8"), "bot": Color("#FFA21A"), "glow": Color("#FFB020"), "g": 1.0, "ink": INK, "lit": true}
	if locked:
		return {"top": Color("#D8C49A"), "bot": Color("#9A7A3E"), "glow": Color("#FFB020"), "g": 0.3, "ink": INK, "lit": true}
	return {"top": Color("#FFF6DC"), "bot": Color("#F2BE66"), "glow": Color("#FFC456"), "g": 0.6, "ink": INK, "lit": true}

func _round(r: Rect2, col: Color, radius: float, shadow: Color = Color.TRANSPARENT, shadow_px: float = 0.0, offset := Vector2.ZERO) -> void:
	var sb := StyleBoxFlat.new()
	sb.bg_color = col; sb.set_corner_radius_all(int(radius)); sb.anti_aliasing = true
	if shadow_px > 0.0:
		sb.shadow_color = shadow; sb.shadow_size = int(shadow_px); sb.shadow_offset = offset
	draw_style_box(sb, r)

func _draw() -> void:
	if small:
		super._draw()
		return
	var kr := key_rect()
	var st := _state_colors()
	var radius := kr.size.x * 0.2
	var thick := maxf(4.0, kr.size.y * 0.11)          # the cap's visible side
	var socket := kr.grow(kr.size.x * 0.07)
	# Drop shadow under the whole button (separates it from the avatar), then glow from within.
	_round(socket, Color(SHADOW, 0.0), radius * 1.15, SHADOW, 7.0 * u, Vector2(0, 5.0 * u))
	var g: float = st.g
	if firing: g = maxf(g, 0.6 + 0.4 * sin(pulse * TAU * 2.0))
	if lit and st.lit: g = minf(1.0, g + 0.25)
	if g > 0.0:
		_round(socket, Color(st.glow, 0.0), radius * 1.15, Color(st.glow, 0.5 * g), 20.0 * u)
		_round(socket, Color(st.glow, 0.0), radius * 1.15, Color(st.glow, 0.7 * g), 7.0 * u)
	# Socket: dark recess with a bronze rim.
	_round(socket, SOCKET, radius * 1.15)
	var rim := StyleBoxFlat.new()
	rim.draw_center = false; rim.set_border_width_all(maxi(1, int(2.0 * u))); rim.border_color = SOCKET_RIM
	rim.set_corner_radius_all(int(radius * 1.15)); rim.anti_aliasing = true
	draw_style_box(rim, socket)
	# Cap side (thickness): the darker body below the top face.
	var top := Rect2(kr.position + Vector2(kr.size.x * 0.04, 0), Vector2(kr.size.x * 0.92, kr.size.y - thick))
	var side := Rect2(top.position + Vector2(0, thick * 0.6), top.size)
	_round(side, (st.bot as Color).darkened(0.45), radius)
	# Top face: lit plastic, light at the top, deeper at the bottom (two layers + a core of light).
	_round(top, st.bot, radius)
	_round(Rect2(top.position, Vector2(top.size.x, top.size.y * 0.62)), Color(st.top, 0.85), radius)
	if st.lit:
		_round(top.grow(-top.size.x * 0.22), Color(1, 1, 0.92, 0.22 * maxf(g, 0.4)), radius * 0.7)
	# Specular band across the upper face.
	_round(Rect2(top.position + Vector2(top.size.x * 0.12, top.size.y * 0.06), Vector2(top.size.x * 0.76, top.size.y * 0.14)), Color(1, 1, 1, 0.42 if st.lit else 0.16), radius * 0.5)
	# Focus / hover ring (keyboard focus must read without colour alone: a solid ring).
	if lit:
		var fr := StyleBoxFlat.new()
		fr.draw_center = false; fr.set_border_width_all(maxi(2, int(2.5 * u))); fr.border_color = FOCUS
		fr.set_corner_radius_all(int(radius * 1.3)); fr.anti_aliasing = true
		draw_style_box(fr, socket.grow(4.0 * u))
	# Glyph + number on the face.
	var face := top.grow(-top.size.x * 0.14)
	var c := top.get_center()
	var broken := state == "broken"
	var hidden := state == "hidden"
	var deadlock := kind == "DEADLOCK"
	var ink: Color = st.ink
	var light_icon := ink == CREAM_INK
	var icon_name := "ICON_HIDDEN" if hidden else ("ICON_DEADLOCK_OPEN" if deadlock and broken else ("ICON_" + kind))
	var icon := art(icon_name + ("_LIGHT" if light_icon else ""))
	var with_value := value != "" and not hidden
	var alpha := 0.55 if broken else 1.0
	if icon:
		var isz := face.size.y * (0.5 if with_value else 0.78)
		var ic := c + (Vector2(0, -face.size.y * 0.2) if with_value else Vector2.ZERO)
		draw_texture_rect(icon, Rect2(ic - Vector2(isz, isz) / 2.0, Vector2(isz, isz)), false, Color(1, 1, 1, alpha))
	else:
		_icon(kind, c + (Vector2(0, -face.size.y * 0.17) if with_value else Vector2.ZERO), face.size.y * (0.22 if with_value else 0.3), Color(ink, alpha))
	if with_value:
		var fs := int((26 if value.length() <= 2 else 19) * u)
		var tw := FONT.get_string_size(value, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
		draw_string(FONT, Vector2(c.x - tw.x / 2.0, face.end.y - 1 * u), value, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color(ink, alpha))
	if broken and not deadlock:
		draw_line(face.position + Vector2(2, face.size.y - 2), face.position + Vector2(face.size.x - 2, 2), Color(SOCKET, 0.85), 3.5 * u, true)
	if badge != "" or locked:
		var bp := socket.position + Vector2(socket.size.x - 2, 2)
		var bi := art("ICON_BOOTING_LIGHT") if locked else null
		draw_circle(bp, 10.0 * u, Color("#2E2016"))
		if bi: draw_texture_rect(bi, Rect2(bp - Vector2(7, 7) * u, Vector2(14, 14) * u), false)
		else: _badge(bp)
	if extra > 0:
		var p := socket.position + Vector2(2, socket.size.y - 2)
		draw_circle(p, 9.0 * u, INK)
		draw_string(FONT, p + Vector2(-7, 5) * u, "+%d" % extra, HORIZONTAL_ALIGNMENT_LEFT, -1, int(12 * u), FACE)
	if cost != "":
		var chip := Rect2(Vector2(size.x / 2.0 - 26 * u, socket.end.y + 3 * u), Vector2(52, CHIP_H + 1) * u)
		var chip_art := art("UI_BW_CHIP")
		if chip_art: draw_texture_rect(chip_art, chip, false)
		else: _box(chip, Color("#2E2016"), 9)
		var cfs := int(13 * u)
		var cw := FONT_SEMI.get_string_size(cost, HORIZONTAL_ALIGNMENT_LEFT, -1, cfs).x
		draw_string(FONT_SEMI, Vector2(chip.get_center().x - cw / 2.0, chip.position.y + chip.size.y * 0.74), cost, HORIZONTAL_ALIGNMENT_LEFT, -1, cfs, Color("#F4ECDA") if cost != "—" else Color("#B8A890"))
