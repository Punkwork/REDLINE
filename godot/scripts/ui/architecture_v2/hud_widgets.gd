class_name HudWidgets
extends RefCounted
## VAS-001 composition pass (ARCH-V2-003, VAS-ASSET-001 §2a): the encounter's instruments, built on
## the painted housings. Icon-first: each shows an icon and a number (and a bar where it has one);
## its name and value appear only in the hover/focus panel. Presentation only: every value is passed
## in by the screen from Game state; nothing here reads or changes rules.

const ICONS := "res://assets/concept/ui/"

static func icon(n: String) -> Texture2D:
	return IceKey.art(n)

## Base for anything that explains itself on hover/focus through the shared KeyInspector.
class Explained extends Control:
	var inspector: KeyInspector
	var title := ""
	var lines: Array = []
	func _init() -> void:
		focus_mode = Control.FOCUS_ALL
		mouse_filter = Control.MOUSE_FILTER_STOP
		mouse_default_cursor_shape = Control.CURSOR_HELP
		mouse_entered.connect(_show)
		focus_entered.connect(_show)
		mouse_exited.connect(func(): if not has_focus(): _hide())
		focus_exited.connect(_hide)
	func _show() -> void:
		if is_instance_valid(inspector) and title != "": inspector.show_info("", title, lines, get_global_rect(), self)
		queue_redraw()
	func _hide() -> void:
		if is_instance_valid(inspector): inspector.close(self)
		queue_redraw()
	func focus_ring() -> void:
		if has_focus():
			var f := StyleBoxFlat.new(); f.draw_center = false; f.set_border_width_all(2); f.border_color = VasTokens.FOCUS
			f.set_corner_radius_all(8); draw_style_box(f, Rect2(Vector2.ZERO, size).grow(2))

## One resource meter on V2_METER_ROW: icon in the socket, segmented bar in the trough, number in
## the window. Geometry fractions measured on the painted row.
class MeterRow extends Explained:
	var art: Texture2D
	var ico: Texture2D
	var draw_glyph := ""          # "ram" when no icon art exists
	var value := 0
	var maximum := 1
	var segments := 10
	var colour := VasTokens.PHOSPHOR
	var text := ""
	func setup(sz: Vector2, icon_tex: Texture2D, col: Color) -> void:
		size = sz; custom_minimum_size = sz
		art = V2Art.tex("controls/V2_METER_ROW.png", sz.x)
		ico = icon_tex; colour = col
	func set_value(v: int, mx: int, segs: int, shown: String, name_line: String) -> void:
		value = v; maximum = maxi(1, mx); segments = clampi(segs, 1, 12); text = shown
		title = name_line
		queue_redraw()
	func _draw() -> void:
		var r := Rect2(Vector2.ZERO, size)
		if art: draw_texture_rect(art, r, false)
		var h := size.y
		# Socket: centred ~10% across; trough 18%–79%; window 81%–96% (measured on the art).
		var sc := Vector2(size.x * 0.103, h * 0.5)
		var s := h * 0.56
		if ico: draw_texture_rect(ico, Rect2(sc - Vector2(s, s) / 2.0, Vector2(s, s)), false)
		elif draw_glyph == "ram": _ram_glyph(sc, s * 0.5)
		var t := Rect2(size.x * 0.192, h * 0.40, size.x * 0.59, h * 0.27)
		var gap := 2.0
		var w := (t.size.x - gap * (segments - 1)) / segments
		var lit := int(ceil(float(value) / maximum * segments)) if value > 0 else 0
		for k in segments:
			var cell := Rect2(t.position.x + k * (w + gap), t.position.y, w, t.size.y)
			draw_rect(cell, colour if k < lit else Color(colour, 0.12))
		var font := VasTokens.FONT_READOUT
		var px := int(h * 0.42)
		var tw := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
		var win_c := Vector2(size.x * 0.885, h * 0.5)
		draw_string(font, Vector2(win_c.x - tw / 2.0, win_c.y + px * 0.36), text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, VasTokens.IVORY)
		focus_ring()
	func _ram_glyph(c: Vector2, s: float) -> void:
		draw_rect(Rect2(c - Vector2(s, s) * 0.75, Vector2(s, s) * 1.5), Color("#7FE0D0"))
		draw_rect(Rect2(c - Vector2(s, s) * 0.4, Vector2(s, s) * 0.8), Color("#0E2A26"))
		for k in 3:
			var o := -s * 0.5 + k * s * 0.5
			draw_line(c + Vector2(o, -s * 1.05), c + Vector2(o, -s * 0.75), Color("#7FE0D0"), 2.0)
			draw_line(c + Vector2(o, s * 0.75), c + Vector2(o, s * 1.05), Color("#7FE0D0"), 2.0)
			draw_line(c + Vector2(-s * 1.05, o), c + Vector2(-s * 0.75, o), Color("#7FE0D0"), 2.0)
			draw_line(c + Vector2(s * 0.75, o), c + Vector2(s * 1.05, o), Color("#7FE0D0"), 2.0)

## The turn counter: number on the two split flaps; "Turn n" on hover.
class FlipCounter extends Explained:
	var art: Texture2D
	var value := 0
	func setup(sz: Vector2) -> void:
		size = sz; custom_minimum_size = sz; art = V2Art.tex("controls/V2_FLIP_COUNTER.png", sz.x)
	func set_value(v: int) -> void:
		value = v; title = "TURN %d" % v; queue_redraw()
	func _draw() -> void:
		if art: draw_texture_rect(art, Rect2(Vector2.ZERO, size), false)
		var digits := "%02d" % clampi(value, 0, 99)
		var font := VasTokens.FONT_PLAQUE
		var px := int(size.y * 0.42)
		for k in 2:
			var cx := size.x * (0.355 if k == 0 else 0.645)
			var cy := size.y * 0.575
			var tw := font.get_string_size(digits[k], HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
			draw_string(font, Vector2(cx - tw / 2.0, cy + px * 0.36), digits[k], HORIZONTAL_ALIGNMENT_LEFT, -1, px, VasTokens.IVORY)
		focus_ring()

## Whose turn: two phosphor icons on the glass plaque (Rustler: a fanned hand; Corporation: a
## surveillance lens); the active one lit. The change itself is announced by the flyouts.
class PhasePlaque extends Explained:
	var art: Texture2D
	var corp := false
	func setup(sz: Vector2) -> void:
		size = sz; custom_minimum_size = sz; art = V2Art.tex("controls/V2_GLASS_PLAQUE.png", sz.x)
	func set_phase(is_corp: bool) -> void:
		corp = is_corp; title = "CORPORATION RESPONSE" if corp else "RUSTLER TURN"; queue_redraw()
	func _draw() -> void:
		if art: draw_texture_rect(art, Rect2(Vector2.ZERO, size), false)
		var cy := size.y * 0.52
		var s := size.y * 0.24
		_hand(Vector2(size.x * 0.36, cy), s, not corp)
		_lens(Vector2(size.x * 0.64, cy), s, corp)
		focus_ring()
	func _col(on: bool) -> Color:
		return VasTokens.PHOSPHOR if on else Color(VasTokens.PHOSPHOR, 0.16)
	func _hand(c: Vector2, s: float, on: bool) -> void:
		var col := _col(on)
		for k in 3:
			var a := deg_to_rad(-18 + k * 18)
			var xf := Transform2D(a, c + Vector2(0, s * 0.6))
			var pts := PackedVector2Array([Vector2(-s * 0.42, -s * 1.7), Vector2(s * 0.42, -s * 1.7), Vector2(s * 0.42, 0), Vector2(-s * 0.42, 0)])
			var p2 := PackedVector2Array()
			for p in pts: p2.append(xf * p)
			draw_colored_polygon(p2, Color(0.02, 0.06, 0.05))
			p2.append(p2[0])
			draw_polyline(p2, col, 2.0, true)
		if on: draw_circle(c, s * 2.0, Color(col, 0.08))
	func _lens(c: Vector2, s: float, on: bool) -> void:
		var col := _col(on)
		draw_arc(c, s * 1.15, 0, TAU, 32, col, 2.5, true)
		draw_circle(c, s * 0.55, col)
		draw_circle(c, s * 0.25, Color(0.02, 0.04, 0.04))
		draw_circle(c + Vector2(s * 1.05, -s * 0.85), s * 0.18, VasTokens.WARNING if on else Color(VasTokens.WARNING, 0.2))
		if on: draw_circle(c, s * 2.0, Color(col, 0.08))

## TRACE: icon, value, and a bar toward the 20 threshold (red past it).
class TraceGauge extends Explained:
	var art: Texture2D
	var ico: Texture2D
	var value := 0
	const THRESHOLD := 20
	func setup(sz: Vector2) -> void:
		size = sz; custom_minimum_size = sz; art = V2Art.tex("controls/V2_GAUGE_HOUSING.png", sz.x)
		ico = IceKey.art("ICON_TRACE_LIGHT")
	func set_value(v: int) -> void:
		value = v; title = "TRACE %d" % v; queue_redraw()
	func _draw() -> void:
		if art: draw_texture_rect(art, Rect2(Vector2.ZERO, size), false)
		var h := size.y
		var s := h * 0.34
		if ico: draw_texture_rect(ico, Rect2(Vector2(size.x * 0.09, h * 0.16), Vector2(s, s)), false, VasTokens.IVORY)
		var font := VasTokens.FONT_READOUT
		var px := int(h * 0.30)
		var text := str(value)
		var tw := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
		draw_string(font, Vector2(size.x * 0.9 - tw, h * 0.16 + s * 0.5 + px * 0.36), text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, VasTokens.IVORY)
		# Trough measured on the art: x 6%–94%, y 66%–82%.
		var t := Rect2(size.x * 0.075, h * 0.675, size.x * 0.85, h * 0.13)
		var segs := 20
		var gap := 1.5
		var w := (t.size.x - gap * (segs - 1)) / segs
		var hot := value >= THRESHOLD
		for k in segs:
			var on := k < mini(value, segs)
			var col := VasTokens.WARNING if hot else VasTokens.AMBER
			draw_rect(Rect2(t.position.x + k * (w + gap), t.position.y, w, t.size.y), col if on else Color(col, 0.10))
		focus_ring()

## Deck, discard and burned: icon + number in each window (designer, ARCH-V2-003n).
class CounterStack extends Control:
	var art: Texture2D
	var rows: Array = []
	var horizontal := false
	func setup(sz: Vector2, insp: KeyInspector, across: bool = false) -> void:
		## across (ARCH-V2-003u): one row of three cells under the meters, on a drawn plate.
		horizontal = across
		size = sz; custom_minimum_size = sz
		art = null if across else V2Art.tex("controls/V2_COUNTER_STACK.png", sz.x)
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		var icons := ["V2_ICON_DECK_LIGHT", "V2_ICON_DISCARD_LIGHT", "V2_ICON_BURNED_LIGHT"]
		for k in 3:
			var row := CounterRow.new()
			row.inspector = insp
			if across:
				var cw := (sz.x - 16.0) / 3.0
				row.position = Vector2(8 + k * cw, 8); row.size = Vector2(cw - 4, sz.y - 16)
			else:
				# Row centres measured on the art: 26%, 53%, 80% of the height.
				var cy: float = sz.y * [0.262, 0.533, 0.805][k]
				row.position = Vector2(sz.x * 0.11, cy - sz.y * 0.11)
				row.size = Vector2(sz.x * 0.78, sz.y * 0.22)
			row.ico = V2Art.tex("icons/%s.png" % icons[k], 64)
			add_child(row)
			rows.append(row)
	func set_counts(deck: int, discard: int, burned: int) -> void:
		var names := ["DECK", "DISCARD", "BURNED"]
		var v := [deck, discard, burned]
		for k in 3:
			rows[k].value = v[k]; rows[k].title = "%s: %d" % [names[k], v[k]]; rows[k].queue_redraw()
	func _draw() -> void:
		if art: draw_texture_rect(art, Rect2(Vector2.ZERO, size), false)
		elif horizontal:
			var sb := StyleBoxFlat.new(); sb.bg_color = Color("#1E1510"); sb.border_color = Color("#8A5A36")
			sb.set_border_width_all(3); sb.set_corner_radius_all(10); sb.anti_aliasing = true
			sb.shadow_color = Color(0, 0, 0, 0.45); sb.shadow_size = 4; sb.shadow_offset = Vector2(0, 2)
			draw_style_box(sb, Rect2(Vector2.ZERO, size))
			for k in rows.size():
				var r: Control = rows[k]
				var w := StyleBoxFlat.new(); w.bg_color = Color("#0E0A08"); w.set_corner_radius_all(6)
				draw_style_box(w, Rect2(r.position, r.size))

class CounterRow extends Explained:
	var ico: Texture2D
	var value := 0
	func _draw() -> void:
		var h := size.y
		var s := h * 0.82
		# Socket centre at ~13% of the housing width → ~3% of this row; window centre at ~76% → 85%.
		if ico: draw_texture_rect(ico, Rect2(Vector2(maxf(3.0, size.x * 0.17 - s / 2.0), (h - s) / 2.0), Vector2(s, s)), false)
		var font := VasTokens.FONT_READOUT
		var px := int(h * 0.48)
		var text := "%02d" % clampi(value, 0, 99)
		var tw := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
		draw_string(font, Vector2(size.x * 0.835 - tw / 2.0, h / 2.0 + px * 0.36), text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, VasTokens.IVORY)
		focus_ring()

## END TURN as an illuminated key from the subroutine-key family (ARCH-V2-003m): jewel lamp above a
## cream cap carrying a hand-over glyph; lamp lit amber while the turn can end. "END TURN" on hover.
class EndTurnKey extends Explained:
	signal pressed
	var enabled := true
	var _down := false
	var cap: Texture2D
	var lamp_on: Texture2D
	var lamp_off: Texture2D
	func setup(sz: Vector2) -> void:
		size = sz; custom_minimum_size = sz
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		cap = IceKey.art("UI_KEY_READY"); lamp_on = IceKey.art("UI_KEY_LAMP_AMBER"); lamp_off = IceKey.art("UI_KEY_LAMP_OFF")
		title = "END TURN"
	func set_enabled(on: bool) -> void:
		enabled = on; queue_redraw()
	func _gui_input(e: InputEvent) -> void:
		if not enabled: return
		if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
			_down = e.pressed; queue_redraw()
			if not e.pressed and Rect2(Vector2.ZERO, size).has_point(e.position): pressed.emit()
			accept_event()
		elif e.is_action_pressed("ui_accept"):
			accept_event(); pressed.emit()
	func _has_point(p: Vector2) -> bool:
		return p.distance_to(size / 2.0) <= size.x * 0.5
	func _draw() -> void:
		## ARCH-V2-003s (designer 2026-11-26 15:34): a small round brown Bakelite power button, C64
		## brown, raised, with a cream power symbol (circle with a notch). Lit amber ring when the
		## turn can end; dull when it can't. Pressed: the cap drops into the socket.
		var c := size / 2.0
		var r := size.x * 0.5
		var press := 2.5 if _down else 0.0
		# Drop shadow, then glow when ready.
		draw_circle(c + Vector2(0, 3), r * 0.98, Color(0, 0, 0, 0.45))
		if enabled:
			for k in 5:
				draw_circle(c, r * (1.0 + 0.06 * (5 - k)), Color(VasTokens.AMBER, 0.05 + 0.03 * k))
		# Socket ring (bronze) and dark recess.
		draw_circle(c, r, Color("#6B5A4A"))
		draw_circle(c, r * 0.9, Color("#15100C"))
		# Lamp ring inside the socket.
		draw_arc(c, r * 0.84, 0, TAU, 48, VasTokens.AMBER if enabled else Color("#4A3A2A"), r * 0.07, true)
		# Cap: side (thickness) then face, C64 brown.
		var cr := r * 0.72
		var top := c + Vector2(0, -r * 0.06 + press)
		draw_circle(top + Vector2(0, r * 0.1), cr, Color("#2E1C10"))
		draw_circle(top, cr, Color("#6A4428") if enabled else Color("#4E3B2C"))
		draw_circle(top + Vector2(0, -cr * 0.18), cr * 0.78, Color("#7E5534") if enabled else Color("#56422F"))
		draw_arc(top, cr * 0.86, PI * 1.12, PI * 1.88, 24, Color(1, 1, 1, 0.22), cr * 0.1, true)
		# Power symbol: an open circle with a notch at the top and a bar through the notch.
		var ink := Color("#F4ECDA") if enabled else Color(0.85, 0.8, 0.72, 0.45)
		var gr := cr * 0.42
		draw_arc(top, gr, -PI * 0.5 + 0.62, PI * 1.5 - 0.62, 32, ink, cr * 0.12, true)
		draw_line(top + Vector2(0, -gr * 1.18), top + Vector2(0, -gr * 0.1), ink, cr * 0.12, true)
		if has_focus():
			draw_arc(c, r * 1.08, 0, TAU, 48, VasTokens.FOCUS, 3.0, true)

## The rig on the large CRT: installed programs as phosphor chips (tool icon + STR), draggable onto
## keys with Build 12's payload. Name and STR on hover.
class RigChip extends Explained:
	var uid := -1
	var pick := false
	var str_value := 0
	var active := false
	var ico: Texture2D
	func _get_drag_data(_at: Vector2) -> Variant:
		if not pick: return null
		var ghost := TextureRect.new(); ghost.texture = ico; ghost.custom_minimum_size = Vector2(36, 36)
		ghost.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; ghost.modulate = VasTokens.FOCUS
		set_drag_preview(ghost)
		return {"kind": "pick", "uid": uid}
	func _draw() -> void:
		var r := Rect2(Vector2.ZERO, size)
		var col := VasTokens.PHOSPHOR if pick else Color(VasTokens.PHOSPHOR, 0.5)
		var sb := StyleBoxFlat.new(); sb.bg_color = Color(col, 0.10); sb.border_color = VasTokens.FOCUS if active else Color(col, 0.55)
		sb.set_border_width_all(2 if active else 1); sb.set_corner_radius_all(5)
		draw_style_box(sb, r)
		var s := size.y * 0.7
		if ico: draw_texture_rect(ico, Rect2(Vector2(size.y * 0.15, (size.y - s) / 2.0), Vector2(s, s)), false, col)
		if pick:
			var font := VasTokens.FONT_READOUT
			var px := int(size.y * 0.52)
			var text := str(str_value)
			var tw := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
			draw_string(font, Vector2(size.x - tw - size.y * 0.25, size.y / 2.0 + px * 0.36), text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, col)
		focus_ring()

## Active effects on the paperclipped card: inked rubber-stamp icons with a count. Blank when none.
class EffectCard extends Control:
	var art: Texture2D
	var stamps: Array = []     # [{icon: Texture2D, n: int, title: String}]
	var inspector: KeyInspector
	var _hit: Array = []
	func setup(sz: Vector2, insp: KeyInspector) -> void:
		size = sz; custom_minimum_size = sz; art = V2Art.tex("controls/V2_NOTE_CARD.png", sz.x); inspector = insp
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	func set_stamps(list: Array) -> void:
		for c in get_children(): remove_child(c); c.queue_free()
		stamps = list
		var x := size.x * 0.2
		for st in list:
			var e := Stamp.new(); e.inspector = inspector; e.ico = st.icon; e.n = int(st.n); e.title = String(st.title)
			e.position = Vector2(x, size.y * 0.3); e.size = Vector2(size.y * 0.5, size.y * 0.5)
			add_child(e)
			x += size.y * 0.62
		queue_redraw()
	func _draw() -> void:
		if art: draw_texture_rect(art, Rect2(Vector2.ZERO, size), false)

class Stamp extends Explained:
	var ico: Texture2D
	var n := 0
	func _draw() -> void:
		var ink := Color("#6B2A1A")
		draw_set_transform(size / 2.0, -0.08, Vector2.ONE)
		var r := Rect2(-size / 2.0, size)
		draw_rect(r, Color(ink, 0.85), false, 2.0)
		if ico: draw_texture_rect(ico, r.grow(-size.x * 0.14), false, Color(ink, 0.9))
		if n > 1:
			draw_string(VasTokens.FONT_PLAQUE, r.end - Vector2(size.x * 0.32, -2), "×%d" % n, HORIZONTAL_ALIGNMENT_LEFT, -1, int(size.y * 0.34), ink)
		draw_set_transform(Vector2.ZERO)
		focus_ring()

## Small CRT: a quiet phosphor trace (content still open with the designer). Static under reduced motion.
class SignalScreen extends Control:
	var reduced_motion := false
	var t := 0.0
	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	func _process(d: float) -> void:
		if reduced_motion: return
		t += d
		queue_redraw()
	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color("#06231A"))
		for y in range(0, int(size.y), 3): draw_line(Vector2(0, y), Vector2(size.x, y), Color(0, 0, 0, 0.18))
		var pts := PackedVector2Array()
		for k in 64:
			var x := size.x * k / 63.0
			var y := size.y * 0.5 + sin(k * 0.35 + t * 2.0) * size.y * 0.14 * (0.6 + 0.4 * sin(k * 0.11 + t))
			pts.append(Vector2(x, y))
		draw_polyline(pts, Color(VasTokens.PHOSPHOR, 0.25), 6.0, true)
		draw_polyline(pts, VasTokens.PHOSPHOR, 2.0, true)
