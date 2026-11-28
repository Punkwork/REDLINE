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
	var heading := ""
	var rows: Array = []              # icon rows ([kind, words]) for show_rich
	var picture: Callable             # returns a Control drawn large in the panel (optional)
	func _show() -> void:
		if not is_instance_valid(inspector) or title == "": queue_redraw(); return
		if rows.is_empty() and not picture.is_valid() and heading == "":
			inspector.show_info("", title, lines, get_global_rect(), self)
		else:
			inspector.show_rich(heading, title, lines, rows, get_global_rect(), self, picture.call() if picture.is_valid() else null)
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
	## F09 / ARCH-V2-007c: a warning pulse (low VITAE); steady red under reduced motion.
	var warn := false:
		set(v):
			warn = v; set_process(v); queue_redraw()
	var reduced_motion := false
	var _t := 0.0
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
		if warn:
			var a := 0.45 if reduced_motion else 0.25 + 0.25 * (0.5 + 0.5 * sin(_t * TAU * 1.2))
			var g := StyleBoxFlat.new(); g.draw_center = false; g.border_color = Color(1.0, 0.2, 0.15, a + 0.3)
			g.set_border_width_all(2); g.set_corner_radius_all(int(h / 2.0)); g.shadow_color = Color(1.0, 0.15, 0.1, a); g.shadow_size = 8
			draw_style_box(g, r.grow(-1))
		var font := VasTokens.FONT_READOUT
		var px := int(h * 0.42)
		var tw := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
		var win_c := Vector2(size.x * 0.885, h * 0.5)
		draw_string(font, Vector2(win_c.x - tw / 2.0, win_c.y + px * 0.36), text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, VasTokens.IVORY)
		focus_ring()
	func _process(d: float) -> void:
		if not warn or reduced_motion: return
		_t += d; queue_redraw()
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
	var box: StyleBox
	func setup(sz: Vector2) -> void:
		## ARCH-V2-005: half width. Uses V2_GLASS_PLAQUE_HALF when it lands; until then the full
		## plaque as a nine-slice (manifest margins) so its rim isn't squeezed.
		size = sz; custom_minimum_size = sz
		## The delivered half plaque is 3:1 (asked 2:1): nine-sliced so the rounded ends and screws keep shape.
		box = V2Art.nine("controls/V2_GLASS_PLAQUE_HALF.png", Vector4(230, 120, 230, 120), sz.y * 230.0 / 576.0)
		if box == null: box = V2Art.nine("controls/V2_GLASS_PLAQUE.png", Vector4(140, 60, 140, 60), sz.y * 0.26)
	func set_phase(is_corp: bool) -> void:
		corp = is_corp; title = "CORPORATION RESPONSE" if corp else "RUSTLER TURN"; queue_redraw()
	func _draw() -> void:
		if art: draw_texture_rect(art, Rect2(Vector2.ZERO, size), false)
		elif box: draw_style_box(box, Rect2(Vector2.ZERO, size))
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
	var half_art := false
	var ico: Texture2D
	var value := 0
	const THRESHOLD := 20
	var box: StyleBox
	func setup(sz: Vector2) -> void:
		## ARCH-V2-005: half width. V2_GAUGE_HOUSING_HALF when it lands; until then the full housing
		## as a nine-slice (manifest margins).
		size = sz; custom_minimum_size = sz
		art = V2Art.tex("controls/V2_GAUGE_HOUSING_HALF.png", sz.x)
		half_art = art != null
		if art == null: box = V2Art.nine("controls/V2_GAUGE_HOUSING.png", Vector4(130, 80, 130, 80), sz.y * 0.2)
		ico = IceKey.art("ICON_TRACE_LIGHT")
	func set_value(v: int) -> void:
		value = v; title = "TRACE %d" % v; queue_redraw()
	func _draw() -> void:
		if art: draw_texture_rect(art, Rect2(Vector2.ZERO, size), false)
		elif box: draw_style_box(box, Rect2(Vector2.ZERO, size))
		var h := size.y
		var s := h * 0.34
		## V2_GAUGE_HOUSING_HALF (measured): glass window x 9%–91%, y 13%–58%; trough with ten baked
		## cells x 11.5%–87.5%, y 64.5%–77.5%. Older full housing: icon row at 16%, trough 67.5%–80.5%.
		var row_y := h * (0.18 if half_art else 0.16)
		if ico: draw_texture_rect(ico, Rect2(Vector2(size.x * (0.13 if half_art else 0.09), row_y), Vector2(s, s)), false, VasTokens.IVORY)
		var font := VasTokens.FONT_READOUT
		var px := int(h * 0.30)
		var text := str(value)
		var tw := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
		draw_string(font, Vector2(size.x * (0.86 if half_art else 0.9) - tw, row_y + s * 0.5 + px * 0.36), text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, VasTokens.IVORY)
		var t := Rect2(size.x * 0.115, h * 0.645, size.x * 0.76, h * 0.13) if half_art \
			else Rect2(size.x * 0.075, h * 0.675, size.x * 0.85, h * 0.13)
		## ARCH-V2-005: at half width, 10 segments of 2 TRACE each (20 thin cells would blur).
		var segs := 10
		var gap := 1.5
		var w := (t.size.x - gap * (segs - 1)) / segs
		var hot := value >= THRESHOLD
		var lit := mini(int(ceil(value / 2.0)), segs)
		for k in segs:
			var on := k < lit
			var col := VasTokens.WARNING if hot else VasTokens.AMBER
			var cell := Rect2(t.position.x + k * (w + gap), t.position.y, w, t.size.y)
			if on: draw_rect(cell, col)
			elif not half_art: draw_rect(cell, Color(col, 0.10))   # the half housing paints its own empty cells
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
## RUN-001 / ARCH-V2-008b (designer 2026-11-27): a small, quiet END RUN plate under END TURN, rarely
## used but always there (Build 12 had it). Pressing it asks for confirmation before anything happens.
class EndRunKey extends Explained:
	signal pressed
	var enabled := true
	var _down := false
	func setup(sz: Vector2) -> void:
		size = sz; custom_minimum_size = sz
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		title = "END RUN"
		lines = ["End this run. Your Rustler fails.", "You are asked to confirm first."]
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
	func _draw() -> void:
		var r := Rect2(Vector2(0, 2.0 if _down else 0.0), size)
		var sb := StyleBoxFlat.new()
		sb.bg_color = VasTokens.BAKELITE.darkened(0.25)
		sb.border_color = Color("#8a5a3c") if (has_focus() or is_hovered()) and enabled else Color("#5a3a28")
		sb.set_border_width_all(1); sb.set_corner_radius_all(4)
		draw_style_box(sb, r)
		var px := 13
		var t := "END RUN"
		var tw := VasTokens.FONT_PLAQUE.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
		var ink := Color("#ff8f8f") if enabled else Color("#a08878")
		draw_string(VasTokens.FONT_PLAQUE, Vector2((size.x - tw) / 2.0, r.position.y + size.y / 2.0 + px * 0.36), t, HORIZONTAL_ALIGNMENT_LEFT, -1, px, ink)
		if has_focus(): focus_ring()
	func is_hovered() -> bool:
		return Rect2(Vector2.ZERO, size).has_point(get_local_mouse_position())

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

## ARCH-V2-005 (designer 2026-11-26 18:22): CAPS and PROTOCOLS slot racks in the header, three slots
## each to start. Icon-first: a group icon in the left socket, then the slots; names and rules on
## hover/focus only. Placeholder drawing until ChatGPT's parts land (VAS-ASSET-001 §6e): each part is
## used when its file exists, otherwise drawn. More items than slots: the last slot shows "+n" and
## its hover lists the rest. Presentation only; models come from VisibleStateAdapter.
class SlotRack extends Control:
	var kind := "CAP"            # "CAP" or "PROTOCOL"
	var slots: Array = []
	var housing: StyleBox
	var group_icon: Control
	const ICON_W := 0.20         # group-icon socket, fraction of the width (drawn placeholder)
	## V2_SLOT_RACK (2186 × 410, measured): icon socket centre (285, 205), radius ~125; bed x 430–2040,
	## y 80–335. Nine-sliced (left margin holds the socket) so the rack can be narrower than the art.
	const ART := Vector2(2186, 410)
	const MARGINS := Vector4(440, 80, 150, 80)
	func setup(sz: Vector2, k: String, n: int, insp: KeyInspector) -> void:
		kind = k; size = sz; custom_minimum_size = sz
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		var a := sz.y / ART.y   # art → reference px
		housing = V2Art.nine("controls/V2_SLOT_RACK.png", MARGINS, MARGINS.x * a)
		var gi := RackIcon.new(); gi.name = "GroupIcon"; gi.kind = k; gi.inspector = insp
		gi.title = "CAPS" if k == "CAP" else "PROTOCOLS (RACK)"
		gi.lines = ["Single-use. Flip, inject, discard. 0 BW, any time in your turn. 3 slots."] if k == "CAP" \
			else ["Deployed PROTOCOLs stay active for the whole Node and return to your deck at Node end."]
		var x0: float
		var area: Rect2
		if housing:
			var d := 250.0 * a
			gi.position = Vector2(285.0 * a - d / 2.0, 205.0 * a - d / 2.0); gi.size = Vector2(d, d)
			x0 = 432.0 * a
			area = Rect2(x0, 4, sz.x - x0 - 140.0 * a, sz.y - 8)
		else:
			gi.position = Vector2(6, 6); gi.size = Vector2(sz.x * ICON_W - 6, sz.y - 12)
			x0 = sz.x * ICON_W + 2
			area = Rect2(x0, 6, sz.x - x0 - 6, sz.y - 12)
		add_child(gi); group_icon = gi
		var gap := 3.0
		var sw := (area.size.x - gap * (n - 1)) / n
		var sh := minf(area.size.y, sw / 0.9) if housing else area.size.y   # sockets are 0.9 : 1
		for i in n:
			var s := RackSlot.new(); s.name = "%sSlot%d" % [("Cap" if k == "CAP" else "Protocol"), i]
			s.kind = k; s.inspector = insp
			s.position = Vector2(area.position.x + i * (sw + gap), area.position.y + (area.size.y - sh) / 2.0)
			s.size = Vector2(sw, sh)
			add_child(s); slots.append(s)
		set_items([])
	func set_items(items: Array) -> void:
		var n := slots.size()
		for i in n:
			var s: RackSlot = slots[i]
			s.item = items[i] if i < items.size() else {}
			s.overflow = items.slice(n) if i == n - 1 and items.size() > n else []
			s.refresh_title()
	func filled() -> int:
		return slots.filter(func(s): return not s.item.is_empty()).size()
	func _draw() -> void:
		if housing: draw_style_box(housing, Rect2(Vector2.ZERO, size)); return
		var sb := StyleBoxFlat.new(); sb.bg_color = Color("#1E1510"); sb.border_color = Color("#8A5A36")
		sb.set_border_width_all(3); sb.set_corner_radius_all(12); sb.anti_aliasing = true
		sb.shadow_color = Color(0, 0, 0, 0.45); sb.shadow_size = 4; sb.shadow_offset = Vector2(0, 2)
		draw_style_box(sb, Rect2(Vector2.ZERO, size))
		# Two small brass screws, ends of the plate.
		for x in [size.x * 0.035, size.x * 0.965]:
			draw_circle(Vector2(x, size.y * 0.5), 2.6, Color("#B98A52"))

## The group icon in the rack's left socket: a CAP vial or a PROTOCOL rack glyph (drawn placeholders;
## ChatGPT's V2_ICON_CAPS_LIGHT / V2_ICON_PROTOCOL_LIGHT replace them when present).
class RackIcon extends Explained:
	var kind := "CAP"
	func _draw() -> void:
		var tex := V2Art.tex("icons/V2_ICON_%s_LIGHT.png" % ("CAPS" if kind == "CAP" else "PROTOCOL"), 64)
		var s := minf(size.x, size.y) * (0.62 if tex else 0.78)
		var c := size / 2.0
		if tex: draw_texture_rect(tex, Rect2(c - Vector2(s, s) / 2.0, Vector2(s, s)), false); focus_ring(); return
		HudWidgets.draw_group_glyph(self, kind, c, s, VasTokens.IVORY)
		focus_ring()

## One slot. Empty: a recessed socket with a faint glyph. Filled: the item's art (or initials) in a
## lit frame (PROTOCOL blue-green per CARDS-003, CAP amber). Hover: name and rules.
class RackSlot extends Explained:
	signal inject(uid: int)   ## CAPS-TEST-001: a CAP slot was pressed (left button or Enter)
	var kind := "CAP"
	var item: Dictionary = {}
	var overflow: Array = []
	func refresh_title() -> void:
		picture = Callable()
		mouse_default_cursor_shape = Control.CURSOR_HELP
		if item.is_empty():
			title = "EMPTY CAP SLOT" if kind == "CAP" else "EMPTY PROTOCOL SLOT"
			lines = ["CAPS are bought at Uplinks, chosen as Node rewards, or dropped after BREACH."] if kind == "CAP" \
				else ["Play a PROTOCOL card to deploy it here."]
		else:
			title = String(item.get("name", ""))
			lines = [String(item.get("text", ""))] if String(item.get("text", "")) != "" else []
			if not overflow.is_empty():
				lines.append("Also deployed: " + ", ".join(overflow.map(func(o): return String(o.get("name", "")))))
			if kind == "CAP":
				lines.append("Drag onto an ICE to inject (0 BW, your turn)." if bool(item.get("target", false)) \
					else "Click to inject: 0 BW, any time in your turn. Single use.")
				if bool(item.get("usable", false)): mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
				var art := String(item.get("art", ""))
				if ResourceLoader.exists(art):
					picture = func() -> Control:   # HOVER-001: the full vial, large
						var t := TextureRect.new(); t.texture = load(art)
						t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
						t.custom_minimum_size = Vector2(64, 192); return t
		queue_redraw()
	func _gui_input(e: InputEvent) -> void:
		if kind != "CAP" or item.is_empty() or not bool(item.get("usable", false)): return
		if (e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and e.pressed) or e.is_action_pressed("ui_accept"):
			accept_event(); inject.emit(int(item.get("uid", -1)))
	func accent() -> Color:
		return Color("#3FB8A8") if kind == "PROTOCOL" else VasTokens.AMBER
	func _draw() -> void:
		var r := Rect2(Vector2.ZERO, size)
		var socket := V2Art.tex("controls/V2_%s_SOCKET.png" % kind, size.x)
		if socket:
			draw_texture_rect(socket, r, false)
			## The sockets' dark windows (measured by eye on the art): CAP 17–83% × 16–83%,
			## PROTOCOL 14–86% × 13–87% (the guide rails sit inside the top and bottom).
			var f := Rect2(0.17, 0.16, 0.66, 0.67) if kind == "CAP" else Rect2(0.14, 0.17, 0.72, 0.66)
			r = Rect2(size * f.position, size * f.size).grow(5)
		else:
			var sb := StyleBoxFlat.new(); sb.bg_color = Color("#0B0806"); sb.border_color = Color("#5A3E28")
			sb.set_border_width_all(2); sb.set_corner_radius_all(10 if kind == "CAP" else 5); sb.anti_aliasing = true
			draw_style_box(sb, r)
			draw_line(Vector2(5, 3), Vector2(size.x - 5, 3), Color(0, 0, 0, 0.6), 2.0)   # inset shadow
		var inner := r.grow(-5)
		if item.is_empty():
			if not socket: HudWidgets.draw_group_glyph(self, kind, size / 2.0, minf(size.x, size.y) * 0.5, Color(VasTokens.IVORY, 0.14))
		else:
			var tex := CardView.art_for(String(item.get("art", "")))
			if tex and kind == "CAP":
				# CAPS-TEST-001: the sockets are too small for a whole 1 : 3 vial, so they show a close-up
				# of the glass around its symbol (the liquid colour and the icon); hover shows the full vial.
				var ts := tex.get_size()
				var gw := ts.x * 0.46                      # the glass body, measured on the vials
				var gh := gw * inner.size.y / inner.size.x
				draw_texture_rect_region(tex, inner, Rect2(Vector2((ts.x - gw) / 2.0, ts.y * 0.5 - gh / 2.0), Vector2(gw, gh)))
			elif tex:
				var ts := tex.get_size()
				var k := maxf(inner.size.x / ts.x, inner.size.y / ts.y)
				var src := Rect2((ts - inner.size / k) / 2.0, inner.size / k)
				draw_texture_rect_region(tex, inner, src)
			else:
				draw_rect(inner, Color(accent(), 0.22))
				var words := String(item.get("name", "?")).split(" ", false)
				var ini := ""
				for w in words.slice(0, 2): ini += w.substr(0, 1)
				var px := int(inner.size.y * 0.42)
				var tw := VasTokens.FONT_PLAQUE.get_string_size(ini, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
				draw_string(VasTokens.FONT_PLAQUE, inner.position + Vector2((inner.size.x - tw) / 2.0, inner.size.y / 2.0 + px * 0.36), ini, HORIZONTAL_ALIGNMENT_LEFT, -1, px, VasTokens.IVORY)
			# Lit rim and a small glow: the slot is in use.
			for g in 3: draw_rect(r.grow(-2 + g), Color(accent(), 0.18 - g * 0.05), false, 2.0)
			draw_rect(inner, accent(), false, 2.0)
		if not overflow.is_empty():
			var t := "+%d" % overflow.size()
			var px := 11
			var font := VasTokens.FONT_READOUT
			var tw := font.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
			var badge := Rect2(Vector2(size.x - tw - 10, size.y - px - 8), Vector2(tw + 8, px + 4))
			draw_rect(badge, Color("#1E1510"))
			draw_rect(badge, accent(), false, 1.5)
			draw_string(font, badge.position + Vector2(4, px - 1), t, HORIZONTAL_ALIGNMENT_LEFT, -1, px, VasTokens.IVORY)
		focus_ring()

## Drawn placeholder glyphs for the two racks. CAP: a capsule vial with a needle cap (flip, inject).
## PROTOCOL: three stacked rack cards with a lamp each.
static func draw_group_glyph(ci: CanvasItem, kind: String, c: Vector2, s: float, col: Color) -> void:
	if kind == "CAP":
		var w := s * 0.34
		var body := Rect2(c + Vector2(-w / 2.0, -s * 0.30), Vector2(w, s * 0.62))
		var sb := StyleBoxFlat.new(); sb.draw_center = false; sb.border_color = col; sb.set_border_width_all(2)
		sb.set_corner_radius_all(int(w / 2.0)); sb.anti_aliasing = true
		ci.draw_style_box(sb, body)
		ci.draw_rect(Rect2(body.position + Vector2(3, body.size.y * 0.5), Vector2(w - 6, body.size.y * 0.5 - 4)), Color(col, col.a * 0.7))
		ci.draw_rect(Rect2(c + Vector2(-w * 0.62, -s * 0.44), Vector2(w * 1.24, s * 0.12)), col)
		ci.draw_line(c + Vector2(0, s * 0.32), c + Vector2(0, s * 0.48), col, 2.0, true)
	else:
		for k in 3:
			var y := c.y - s * 0.36 + k * s * 0.26
			var rr := Rect2(Vector2(c.x - s * 0.40, y), Vector2(s * 0.80, s * 0.18))
			ci.draw_rect(rr, col, false, 2.0)
			ci.draw_circle(Vector2(rr.position.x + rr.size.x - s * 0.10, rr.position.y + rr.size.y / 2.0), s * 0.045, col)

## ARCH-V2-006a/c/g/h: the all-seeing eye in the top-left corner. Its lens is the HOSTILE REVEAL
## alarm lamp: cool green with no reveal to near-neon red at full reveal, subtle. Three strike lamps
## sit under it; at LOCKDOWN all three burn red with a lock mark. Hover/focus: tier, Node, reveal,
## strikes, and the KEY LEGEND. Uses chassis/V2_EYE.png (white iris, tinted here) when it lands.
class EyeLamp extends Explained:
	var reveal := 0.0          # 0..1 hostile reveal (VisibleStateAdapter.hostile_reveal)
	var strikes := 0
	var lockdown := false
	var reduced_motion := false
	var t := 0.0
	var art: Texture2D
	const COOL := Color("#39E58C")
	const HOT := Color("#FF2440")
	func setup(sz: Vector2) -> void:
		size = sz; custom_minimum_size = sz
		art = V2Art.tex("chassis/V2_EYE.png", sz.x)
	func _process(d: float) -> void:
		if reduced_motion: return
		t += d; queue_redraw()
	func lens_colour() -> Color:
		return COOL.lerp(HOT, clampf(reveal, 0.0, 1.0))
	func set_state(r: float, st: int, lock: bool) -> void:
		reveal = r; strikes = st; lockdown = lock
		set_process(not reduced_motion)   # the red pupil always pulses (designer 2026-11-26 21:17)
		queue_redraw()
	func _draw() -> void:
		var eye_d := minf(size.x, size.y - 18.0)
		var c := Vector2(size.x / 2.0, eye_d / 2.0)
		var r := eye_d / 2.0
		var col := lens_colour()
		# A slow, faint breath once the mask starts slipping (static under reduced motion).
		var breath := 1.0 if reduced_motion or reveal <= 0.0 else 0.9 + 0.1 * sin(t * (1.5 + 3.0 * reveal))
		if art:
			## V2_EYE (measured): pupil radius 0.14 r, white iris out to about 0.46 r. The iris is tinted
			## as a ring so the pupil stays dark.
			draw_texture_rect(art, Rect2(c - Vector2(r, r), Vector2(eye_d, eye_d)), false)
			draw_arc(c, r * 0.30, 0, TAU, 64, Color(col, 0.42 * breath), r * 0.30, true)
		else:
			draw_circle(c + Vector2(0, 2), r, Color(0, 0, 0, 0.45))
			draw_circle(c, r, Color("#8A5A36"))
			draw_arc(c, r * 0.93, PI * 1.05, PI * 1.85, 24, Color("#F0C890"), r * 0.08, true)
			draw_circle(c, r * 0.80, Color("#2A2522"))
			draw_circle(c, r * 0.70, Color("#050404"))
			for k in 6:
				draw_circle(c, r * (0.52 - k * 0.07), Color(col, (0.10 + k * 0.10) * breath))
			draw_circle(c, r * 0.10, Color(1, 1, 1, 0.85 * breath))
			draw_circle(c + Vector2(-r * 0.32, -r * 0.34), r * 0.10, Color(1, 1, 1, 0.35))
		# The red pupil dot: always there, pulsing slowly (faster as the reveal grows); steady under
		# reduced motion (designer 2026-11-26 21:17).
		var beat := 1.0 if reduced_motion else 0.55 + 0.45 * (0.5 + 0.5 * sin(t * TAU * (0.5 + 1.0 * reveal)))
		draw_circle(c, r * 0.13, Color(1.0, 0.1, 0.1, 0.22 * beat))
		draw_circle(c, r * 0.075, Color(1.0, 0.12, 0.12, 0.55 + 0.45 * beat))
		draw_circle(c + Vector2(-r * 0.02, -r * 0.025), r * 0.025, Color(1, 0.8, 0.8, 0.8 * beat))
		# Strike lamps.
		var lr := 5.5
		for k in 3:
			var p := Vector2(size.x / 2.0 + (k - 1) * 18.0, size.y - 11.0)
			var lit := lockdown or k < strikes
			draw_circle(p, lr + 1.5, Color("#1A1210"))
			draw_circle(p, lr, (Color("#FF3030") if lockdown else Color("#FFB32E")) if lit else Color("#3A2A22"))
			if lit: draw_circle(p, lr * 2.0, Color(Color("#FF3030") if lockdown else Color("#FFB32E"), 0.18))
		if lockdown:
			var lp := Vector2(size.x / 2.0 + 32.0, size.y - 12.0)
			draw_rect(Rect2(lp + Vector2(-4, -1), Vector2(8, 7)), Color("#FF3030"))
			draw_arc(lp + Vector2(0, -1), 3.0, PI, TAU, 10, Color("#FF3030"), 1.6, true)
		if has_focus(): draw_arc(c, r + 3.0, 0, TAU, 40, VasTokens.FOCUS, 2.5, true)

## ARCH-V2-006b: the Ghostware reel. One Ghostware shows in the window; the up/down arrows beside it
## roll to the previous/next (ORIGIN first). Hover/focus the window: full name, text and the art large.
## Uses controls/V2_GHOST_REEL.png when it lands; drawn until then.
class GhostReel extends Control:
	var items: Array = []     # [{name, text, origin, art}]
	var index := 0
	var inspector: KeyInspector
	var window: Explained
	var up: Button
	var down: Button
	var art: Texture2D
	var roll := 0.0           # -1..1 drum offset while rolling (0 when still)
	var reduced_motion := false
	func setup(sz: Vector2, insp: KeyInspector) -> void:
		size = sz; custom_minimum_size = sz; inspector = insp
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		art = V2Art.tex("controls/V2_GHOST_REEL.png", sz.x)
		var aw := sz.x * 0.26
		window = ReelWindow.new(); window.name = "GhostWindow"; window.inspector = insp; window.reel = self
		## V2_GHOST_REEL (measured): window x 20–62%, y 20–79%; arrow buttons x 70–88%, y 21–46% / 51–76%.
		var wr := Rect2(sz * Vector2(0.20, 0.20), sz * Vector2(0.42, 0.59)) if art else Rect2(sz.x * 0.08, sz.y * 0.12, sz.x * 0.62, sz.y * 0.76)
		window.position = wr.position; window.size = wr.size
		add_child(window)
		var ur := Rect2(sz * Vector2(0.70, 0.21), sz * Vector2(0.18, 0.25)) if art else Rect2(sz.x - aw - 4, 6, aw, sz.y / 2.0 - 8)
		var dr := Rect2(sz * Vector2(0.70, 0.51), sz * Vector2(0.18, 0.25)) if art else Rect2(sz.x - aw - 4, sz.y / 2.0 + 2, aw, sz.y / 2.0 - 8)
		up = _arrow("GhostUp", true, ur)
		down = _arrow("GhostDown", false, dr)
		up.pressed.connect(func(): step(-1))
		down.pressed.connect(func(): step(1))
		set_items([])
	func _arrow(n: String, is_up: bool, r: Rect2) -> Button:
		var b := Button.new(); b.name = n; b.flat = true; b.focus_mode = Control.FOCUS_ALL
		b.position = r.position; b.size = r.size
		b.tooltip_text = ""
		b.draw.connect(func():
			var c := r.size / 2.0
			var w := r.size.x * 0.32
			var on := b.disabled == false
			var col := VasTokens.IVORY if on else Color(VasTokens.IVORY, 0.25)
			if b.is_hovered() or b.has_focus(): col = VasTokens.FOCUS
			var pts := PackedVector2Array([c + Vector2(-w, w * 0.5), c + Vector2(w, w * 0.5), c + Vector2(0, -w * 0.6)]) if is_up \
				else PackedVector2Array([c + Vector2(-w, -w * 0.5), c + Vector2(w, -w * 0.5), c + Vector2(0, w * 0.6)])
			if art:
				# The painted buttons carry the arrows; the game adds hover/focus and a dim when idle.
				if b.is_hovered() or b.has_focus(): b.draw_arc(c, minf(r.size.x, r.size.y) * 0.5, 0, TAU, 32, VasTokens.FOCUS, 2.0, true)
				if not on: b.draw_circle(c, minf(r.size.x, r.size.y) * 0.46, Color(0, 0, 0, 0.45))
				return
			var sb := StyleBoxFlat.new(); sb.bg_color = Color("#2A1D16"); sb.border_color = Color("#B98A52")
			sb.set_border_width_all(2); sb.set_corner_radius_all(5); b.draw_style_box(sb, Rect2(Vector2.ZERO, r.size))
			b.draw_colored_polygon(pts, col))
		add_child(b)
		return b
	func set_items(list: Array) -> void:
		items = list
		index = clampi(index, 0, maxi(0, items.size() - 1))
		_sync()
	func current() -> Dictionary:
		return items[index] if index < items.size() else {}
	func step(d: int) -> void:
		if items.size() < 2: return
		index = (index + d + items.size()) % items.size()
		roll = 0.0 if reduced_motion else float(d)
		_sync()
		if window.has_focus() or window.get_global_rect().has_point(window.get_global_mouse_position()): window._show()
	func _process(delta: float) -> void:
		if roll == 0.0: set_process(false); return
		roll = move_toward(roll, 0.0, delta * 6.0)
		window.queue_redraw()
	func _sync() -> void:
		up.disabled = items.size() < 2; down.disabled = items.size() < 2
		var it := current()
		window.title = ("ORIGIN GHOSTWARE · " if it.get("origin", false) else "GHOSTWARE · ") + String(it.get("name", "")) if not it.is_empty() else "GHOSTWARE"
		window.lines = [String(it.get("text", ""))] if String(it.get("text", "")) != "" else (["No Ghostware yet. Ghostware are permanent upgrades that are not cards."] if it.is_empty() else [])
		if items.size() > 1: window.lines.append("%d of %d · use the arrows to roll" % [index + 1, items.size()])
		up.queue_redraw(); down.queue_redraw(); window.queue_redraw()
		set_process(roll != 0.0)
	func _draw() -> void:
		if art: draw_texture_rect(art, Rect2(Vector2.ZERO, size), false); return
		var sb := StyleBoxFlat.new(); sb.bg_color = Color("#1E1510"); sb.border_color = Color("#8A5A36")
		sb.set_border_width_all(3); sb.set_corner_radius_all(10); sb.anti_aliasing = true
		draw_style_box(sb, Rect2(Vector2.ZERO, size))

class ReelWindow extends Explained:
	var reel: GhostReel
	func _init() -> void:
		super()
		picture = func() -> Control:
			var it := reel.current()
			if it.is_empty(): return null
			var big := GhostFace.new(); big.item = it; big.custom_minimum_size = Vector2(128, 128)
			return big
	func _draw() -> void:
		var r := Rect2(Vector2.ZERO, size)
		var painted := reel.art != null   # the painted reel has its own dark drum window
		if not painted: draw_rect(r, Color("#0B0806"))
		var it := reel.current()
		var off := reel.roll * size.y * 0.6
		if not it.is_empty():
			var s := minf(size.x, size.y) * 0.86
			GhostFace.paint(self, it, Rect2(size / 2.0 - Vector2(s, s) / 2.0 + Vector2(0, off), Vector2(s, s)))
		else:
			draw_string(VasTokens.FONT_PLAQUE, Vector2(size.x / 2.0 - 4, size.y / 2.0 + 6), "–", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(VasTokens.IVORY, 0.25))
		# Drum shading top and bottom (painted on the art).
		for k in (0 if painted else 6):
			var a := 0.30 - k * 0.05
			draw_rect(Rect2(0, k * 2.0, size.x, 2.0), Color(0, 0, 0, a))
			draw_rect(Rect2(0, size.y - (k + 1) * 2.0, size.x, 2.0), Color(0, 0, 0, a))
		if not painted or it.get("origin", false):
			draw_rect(r, Color("#E0B04A") if it.get("origin", false) else Color("#5A3E28"), false, 2.0)
		focus_ring()

## A Ghostware face: its painted art if there is one (assets/concept/ghostware/GW_<ID>.png), else
## a round badge with initials (gold rim for ORIGIN), like the prototype.
class GhostFace extends Control:
	var item: Dictionary = {}
	func _draw() -> void:
		GhostFace.paint(self, item, Rect2(Vector2.ZERO, size))
	static func paint(ci: CanvasItem, it: Dictionary, r: Rect2) -> void:
		var path := String(it.get("art", ""))
		var tex: Texture2D = CardView.art_for(path)
		if tex:
			ci.draw_texture_rect(tex, r, false); return
		var c := r.get_center(); var rad := minf(r.size.x, r.size.y) / 2.0
		ci.draw_circle(c, rad, Color("#E0B04A") if it.get("origin", false) else Color("#9FB7AE"))
		ci.draw_circle(c, rad * 0.88, Color("#241A14"))
		var words := String(it.get("name", "?")).split(" ", false)
		var ini := ""
		for w in words.slice(0, 2): ini += w.substr(0, 1)
		var px := int(rad * 0.8)
		var tw := VasTokens.FONT_PLAQUE.get_string_size(ini, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
		ci.draw_string(VasTokens.FONT_PLAQUE, c + Vector2(-tw / 2.0, px * 0.36), ini, HORIZONTAL_ALIGNMENT_LEFT, -1, px, VasTokens.IVORY)


## ARCH-V2-006d: the ledger at the left end of the NEXT RESPONSE rail. Left to right: the LAYER
## mark (a hamburger of one bar per layer in the Node: current lit, cleared dim, later unlit), the
## Rustler's CRED (CRED icon + value), then the layer's CRED reserve. When CRED is extracted, red
## marching ants run LEFT from the reserve to the Rustler's CRED, which then counts up. Reduced
## motion: no ants, the values change at once. Presentation only; values come from Game via the screen.
class RailLedger extends Control:
	var inspector: KeyInspector
	var layer_mark: Explained
	var cred_cell: Explained
	var reserve_cell: Explained
	var layers := 1
	var current := 0
	var cred := 0
	var reserve := 0
	var shown_cred := 0.0     # what the CRED window shows (lags during the ants)
	var ants := 0.0           # seconds left of the ants run
	var gained := 0
	var reduced_motion := false
	var cred_icon: Texture2D
	const ANTS_S := 0.9
	const COUNT_S := 0.45
	var _count_t := 0.0
	func setup(sz: Vector2, insp: KeyInspector) -> void:
		size = sz; custom_minimum_size = sz; inspector = insp
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		cred_icon = V2Art.tex("icons/V2_ICON_CRED_LIGHT.png", 32)
		var h := sz.y
		layer_mark = _cell("LayerMark", Rect2(0, 0, h * 0.62, h))
		cred_cell = _cell("CredValue", Rect2(h * 0.70, 0, sz.x * 0.40, h))
		reserve_cell = _cell("LayerCred", Rect2(sz.x - sz.x * 0.30, 0, sz.x * 0.30, h))
		set_process(false)
	func _cell(n: String, r: Rect2) -> Explained:
		var c := Explained.new(); c.name = n; c.inspector = inspector
		c.position = r.position; c.size = r.size; c.draw.connect(queue_redraw)
		add_child(c)
		return c
	func set_values(n_layers: int, cur: int, c: int, res: int) -> void:
		layers = clampi(n_layers, 1, 3); current = clampi(cur, 0, layers - 1); reserve = res
		if c > cred and not reduced_motion and is_inside_tree():
			gained = c - cred
			ants = ANTS_S; _count_t = 0.0
			set_process(true)
		elif ants <= 0.0:
			shown_cred = c
		cred = c
		if reduced_motion: shown_cred = c; ants = 0.0
		layer_mark.title = "LAYER %d / %d" % [current + 1, layers]
		layer_mark.lines = ["This ICE Node has %d encounter layer%s." % [layers, "" if layers == 1 else "s"]]
		cred_cell.title = "CRED %d" % cred
		cred_cell.lines = ["Your CRED. Extractors take it from the layer's reserve."]
		reserve_cell.title = "LAYER CRED %d" % reserve
		reserve_cell.lines = ["CRED left to extract in this layer."]
		queue_redraw()
	## Tests and fixtures: run the animation to its end at once.
	func finish() -> void:
		ants = 0.0; shown_cred = cred; set_process(false); queue_redraw()
	## UI-TYPO-002 RESERVE EXTRACTED: restart a still-running gain so its count lands together with
	## the flyout's gold EXTRACTED (the flyout's enter + reveal equals ANTS_S + COUNT_S). A gain that
	## has already landed is left alone (no rewind).
	func sync_reward() -> void:
		if reduced_motion or gained <= 0: return
		if ants > 0.0 or is_processing():
			ants = ANTS_S; _count_t = 0.0; shown_cred = float(cred - gained)
			set_process(true); queue_redraw()
	func _process(d: float) -> void:
		if ants > 0.0:
			ants = maxf(0.0, ants - d)
		else:
			_count_t += d
			shown_cred = lerpf(float(cred - gained), float(cred), clampf(_count_t / COUNT_S, 0.0, 1.0))
			if _count_t >= COUNT_S: shown_cred = cred; set_process(false)
		queue_redraw()
	func _draw() -> void:
		var h := size.y
		var glass := StyleBoxFlat.new(); glass.bg_color = Color("#0B0806"); glass.border_color = Color("#5A3E28")
		glass.set_border_width_all(2); glass.set_corner_radius_all(int(h * 0.3)); glass.anti_aliasing = true
		draw_style_box(glass, Rect2(Vector2.ZERO, size))
		# LAYER hamburger.
		var lm := Rect2(layer_mark.position, layer_mark.size)
		var bw := lm.size.x * 0.56; var bh := h * 0.11
		for k in 3:
			var y := h * 0.30 + k * h * 0.2 - bh / 2.0
			var col := Color(VasTokens.IVORY, 0.10)
			if k < layers:
				col = VasTokens.PHOSPHOR if k == current else (Color(VasTokens.PHOSPHOR, 0.30) if k < current else Color(VasTokens.IVORY, 0.35))
			draw_rect(Rect2(lm.position.x + (lm.size.x - bw) / 2.0 + 4, y, bw, bh), col)
		# Rustler's CRED: icon + value.
		var cc := Rect2(cred_cell.position, cred_cell.size)
		var s := h * 0.52
		if cred_icon: draw_texture_rect(cred_icon, Rect2(cc.position + Vector2(2, (h - s) / 2.0), Vector2(s, s)), false, VasTokens.AMBER)
		var font := VasTokens.FONT_READOUT
		var px := int(h * 0.42)
		var ct := str(roundi(shown_cred))
		draw_string(font, Vector2(cc.position.x + s + 8, h / 2.0 + px * 0.36), ct, HORIZONTAL_ALIGNMENT_LEFT, -1, px, VasTokens.AMBER if ants <= 0.0 else VasTokens.IVORY)
		# Layer reserve.
		var rc := Rect2(reserve_cell.position, reserve_cell.size)
		var rt := str(reserve)
		var rw := font.get_string_size(rt, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
		draw_string(font, Vector2(rc.end.x - rw - 8, h / 2.0 + px * 0.36), rt, HORIZONTAL_ALIGNMENT_LEFT, -1, px, Color(VasTokens.IVORY, 0.75))
		# Marching ants, right to left, between the reserve and the Rustler's CRED.
		var x0 := cc.position.x + s + 8 + font.get_string_size(ct, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x + 6
		var x1 := rc.end.x - rw - 14
		if x1 > x0:
			var y := h / 2.0
			if ants > 0.0:
				var phase := fmod((ANTS_S - ants) * 60.0, 12.0)
				var x := x1 - phase
				while x > x0:
					draw_line(Vector2(maxf(x - 6.0, x0), y), Vector2(x, y), Color("#FF3A2A"), 2.5)
					x -= 12.0
				draw_colored_polygon(PackedVector2Array([Vector2(x0, y), Vector2(x0 + 7, y - 5), Vector2(x0 + 7, y + 5)]), Color("#FF3A2A"))
			else:
				var x := x1
				while x > x0:
					draw_line(Vector2(maxf(x - 3.0, x0), y), Vector2(x, y), Color(VasTokens.IVORY, 0.12), 1.5)
					x -= 9.0
		for c in [layer_mark, cred_cell, reserve_cell]:
			if c.has_focus():
				var f := StyleBoxFlat.new(); f.draw_center = false; f.set_border_width_all(2); f.border_color = VasTokens.FOCUS
				f.set_corner_radius_all(6); draw_style_box(f, Rect2(c.position, c.size).grow(1))

## ARCH-V2-006i: the encounter log, opened from the NEXT RESPONSE rail (hover shows the latest lines;
## click pins the full log until clicked again or Esc). No ticker. Lines come from Game.log.
class LogPanel extends PanelContainer:
	var _list: VBoxContainer
	var _scroll: ScrollContainer
	signal closed
	func _init() -> void:
		name = "LogPanel"; z_index = 150
		var st := StyleBoxFlat.new(); st.bg_color = Color("#120D0A", 0.96); st.border_color = VasTokens.BRONZE
		st.set_border_width_all(3); st.set_corner_radius_all(14); st.set_content_margin_all(14)
		st.shadow_color = Color(0, 0, 0, 0.5); st.shadow_size = 12
		add_theme_stylebox_override("panel", st)
		var col := VBoxContainer.new(); add_child(col)
		var head := Label.new(); head.text = "ENCOUNTER LOG"; head.add_theme_font_override("font", VasTokens.FONT_PLAQUE)
		head.add_theme_font_size_override("font_size", 22); head.add_theme_color_override("font_color", VasTokens.AMBER)
		col.add_child(head)
		_scroll = ScrollContainer.new(); _scroll.custom_minimum_size = Vector2(560, 300)
		_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		col.add_child(_scroll)
		_list = VBoxContainer.new(); _list.size_flags_horizontal = Control.SIZE_EXPAND_FILL; _scroll.add_child(_list)
		hide()
	func set_lines(lines: Array) -> void:
		for c in _list.get_children(): _list.remove_child(c); c.queue_free()
		for l in lines:
			var lab := Label.new(); lab.text = String(l); lab.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			lab.custom_minimum_size.x = 540
			lab.add_theme_font_override("font", VasTokens.FONT_RULES); lab.add_theme_font_size_override("font_size", 15)
			lab.add_theme_color_override("font_color", VasTokens.IVORY)
			_list.add_child(lab)
		_scroll.set_deferred("scroll_vertical", 1 << 20)   # newest line in view
	func count() -> int:
		return _list.get_child_count()
	func _gui_input(e: InputEvent) -> void:
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
			hide(); closed.emit(); accept_event()

## ARCH-V2-006f: NUL/REM's speaker grille. NUL/REM speaks (pre-recorded voice); the grille glows
## while it speaks, and hovering/focusing it shows the line's text (with the two before it). Clicking
## it (or M) mutes and unmutes the voice; muted shows a slash. Uses controls/V2_SPEAKER_GRILLE.png
## when it lands. Presentation only.
class SpeakerGrille extends Explained:
	signal toggled
	var speaking := 0.0        # seconds of glow left
	var muted := false
	var reduced_motion := false
	var art: Texture2D
	var t := 0.0
	func setup(sz: Vector2) -> void:
		size = sz; custom_minimum_size = sz
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		art = V2Art.tex("controls/V2_SPEAKER_GRILLE.png", sz.x)
		set_process(false)
	func speak(seconds: float) -> void:
		speaking = seconds; set_process(true); queue_redraw()
	func _process(d: float) -> void:
		speaking = maxf(0.0, speaking - d); t += d
		if speaking <= 0.0: set_process(false)
		queue_redraw()
	func _gui_input(e: InputEvent) -> void:
		if (e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT) or e.is_action_pressed("ui_accept"):
			accept_event(); toggled.emit()
	func _draw() -> void:
		var r := Rect2(Vector2.ZERO, size)
		var on := speaking > 0.0 and not muted
		var glow := 1.0 if reduced_motion else 0.75 + 0.25 * sin(t * 14.0)
		if on:
			var g := StyleBoxFlat.new(); g.bg_color = Color(VasTokens.AMBER, 0.0); g.set_corner_radius_all(int(size.y / 2.0))
			g.shadow_color = Color(VasTokens.AMBER, 0.45 * glow); g.shadow_size = 10; draw_style_box(g, r.grow(-2))
		if art:
			draw_texture_rect(art, r, false, Color(1.15, 1.05, 0.9) if on else Color.WHITE)
		else:
			var sb := StyleBoxFlat.new(); sb.bg_color = Color("#1A1310"); sb.border_color = Color("#C9CED0") if not muted else Color("#7E878A")
			sb.set_border_width_all(3); sb.set_corner_radius_all(int(size.y / 2.0)); sb.anti_aliasing = true
			draw_style_box(sb, r)
			var col := Color(VasTokens.AMBER, 0.55 + 0.45 * glow) if on else Color("#6B5A4A")
			var n := 5
			for k in n:
				var y := size.y * (0.26 + k * 0.12)
				draw_line(Vector2(size.x * 0.18, y), Vector2(size.x * 0.82, y), col, 2.5, true)
		if muted:
			draw_line(Vector2(size.x * 0.2, size.y * 0.85), Vector2(size.x * 0.8, size.y * 0.15), Color("#FF3A2A"), 3.5, true)
		focus_ring()

## ARCH-V2-006k: the targeting arrow. A curved line from the aimed card to the pointer, dotted trail
## and an arrowhead; it turns bright and rings the ICE when the pointer is over a valid target.
class TargetArrow extends Control:
	var from := Vector2.ZERO
	var to := Vector2.ZERO
	var over := Rect2()        # the hovered ICE panel (stage coords); empty when none
	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		hide()
	func curve_point(t: float) -> Vector2:
		var mid := (from + to) / 2.0
		var lift := clampf(from.distance_to(to) * 0.35, 40.0, 220.0)
		var ctrl := Vector2(mid.x - (to.x - from.x) * 0.25, minf(from.y, to.y) - lift)
		return from.lerp(ctrl, t).lerp(ctrl.lerp(to, t), t)
	func _draw() -> void:
		var hot := over.has_area()
		var col := VasTokens.FOCUS if hot else Color(VasTokens.IVORY, 0.92)
		if hot:
			var ring := StyleBoxFlat.new(); ring.draw_center = false; ring.border_color = VasTokens.FOCUS
			ring.set_border_width_all(6); ring.set_corner_radius_all(30); ring.anti_aliasing = true
			ring.shadow_color = Color(VasTokens.FOCUS, 0.4); ring.shadow_size = 14
			draw_style_box(ring, over.grow(4))
		var pts := PackedVector2Array()
		var n := 32
		for k in n + 1: pts.append(curve_point(float(k) / n))
		draw_polyline(pts, Color(0, 0, 0, 0.45), 11.0, true)
		draw_polyline(pts, col, 6.0, true)
		# Arrowhead along the last segment.
		var tip := pts[n]
		var dir := (pts[n] - pts[n - 3]).normalized()
		var side := Vector2(-dir.y, dir.x)
		var head := PackedVector2Array([tip + dir * 10.0, tip - dir * 18.0 + side * 14.0, tip - dir * 18.0 - side * 14.0])
		draw_colored_polygon(head, Color(0, 0, 0, 0.45))
		draw_colored_polygon(PackedVector2Array([tip + dir * 7.0, tip - dir * 15.0 + side * 11.0, tip - dir * 15.0 - side * 11.0]), col)
		draw_circle(from, 7.0, col)

## ARCH-V2-006l: the CRT as the install target. While a PROGRAM is dragged the screen glows phosphor
## and a slot arrow shows above the set; over the CRT it brightens ("let go to install").
class CrtDropGlow extends Control:
	var screen := Rect2()
	var slot_y := 0.0
	var state := 0            # 0 off, 1 a PROGRAM is being dragged, 2 the pointer is over the CRT
	var reduced_motion := false
	var t := 0.0
	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		set_process(false)
	func set_state(s: int) -> void:
		if s == state: return
		state = s; set_process(s > 0 and not reduced_motion); queue_redraw()
	func _process(d: float) -> void:
		t += d; queue_redraw()
	func _draw() -> void:
		if state == 0: return
		var pulse := 1.0 if reduced_motion else 0.8 + 0.2 * sin(t * 6.0)
		var hot := state == 2
		var col := Color(VasTokens.PHOSPHOR, (0.9 if hot else 0.55) * pulse)
		var ring := StyleBoxFlat.new(); ring.bg_color = Color(VasTokens.PHOSPHOR, 0.18 if hot else 0.06)
		ring.border_color = col; ring.set_border_width_all(5 if hot else 3); ring.set_corner_radius_all(14)
		ring.shadow_color = Color(VasTokens.PHOSPHOR, 0.45 if hot else 0.2); ring.shadow_size = 16 if hot else 8
		ring.anti_aliasing = true
		draw_style_box(ring, screen.grow(4))
		# Slot arrow above the set: where the cartridge goes in.
		var c := Vector2(screen.get_center().x, slot_y - 18.0 - (0.0 if reduced_motion else 4.0 * sin(t * 6.0)))
		var w := 16.0
		draw_colored_polygon(PackedVector2Array([c + Vector2(-w, -w * 0.6), c + Vector2(w, -w * 0.6), c + Vector2(0, w * 0.7)]), col)
		draw_line(c + Vector2(0, -w * 1.6), c + Vector2(0, -w * 0.6), col, 5.0)

