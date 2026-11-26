class_name RigBay
extends Control
## ARCH-V2-003u (PROPOSED; designer 2026-11-26 15:45): the rig is a games console. Each installed
## program is a HuCard cartridge pushed into the CRT: only a sliver of its top sticks up above the
## set. Clicking a cartridge (or Enter on it) shows that program on the CRT screen and makes it the
## active program, the one a key click breaks with (EncounterController.active_program, Build 12's
## "program last used"). Cartridges can still be dragged onto a key (Build 12 payload).
## Presentation only: values come in from the screen; selecting never calls Game.

signal selected(uid: int)

var inspector: KeyInspector
var crt_rect: Rect2            ## the CRT housing, in this control's coordinates
var screen_rect: Rect2         ## the CRT glass
var slot_y := 0.0              ## top of the CRT where cartridges go in
var sliver := 36.0             ## how much of each cartridge shows above the set
var cart_size := Vector2(62, 74)
var _carts: Array[Cartridge] = []
var screen: ProgramScreen

func build(crt_art: Texture2D, glass: Texture2D) -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var holder := Control.new(); holder.name = "Slots"; holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(holder)
	var back := ColorRect.new(); back.color = Color("#06231A"); back.position = screen_rect.position; back.size = screen_rect.size
	back.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(back)
	screen = ProgramScreen.new(); screen.name = "ProgramScreen"; screen.position = screen_rect.position; screen.size = screen_rect.size
	add_child(screen)
	var set_art := TextureRect.new(); set_art.name = "Crt"; set_art.texture = crt_art
	set_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; set_art.stretch_mode = TextureRect.STRETCH_SCALE
	set_art.position = crt_rect.position; set_art.size = crt_rect.size; set_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(set_art)
	var g := TextureRect.new(); g.name = "Glass"; g.texture = glass
	g.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; g.stretch_mode = TextureRect.STRETCH_SCALE
	g.position = screen_rect.position; g.size = screen_rect.size; g.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(g)

## programs: [{uid, name, pick, str, text}] in install order; active: uid shown/used, or -1.
func sync(programs: Array, active: int) -> void:
	var holder: Control = get_node("Slots")
	for c in _carts: holder.remove_child(c); c.queue_free()
	_carts.clear()
	var n := programs.size()
	var gap := 10.0
	var w := n * cart_size.x + maxf(0, n - 1) * gap
	var x0 := crt_rect.position.x + (crt_rect.size.x * 0.82 - w) / 2.0
	var shown := {}
	for k in n:
		var p: Dictionary = programs[k]
		var c := Cartridge.new()
		c.inspector = inspector
		c.prog = p
		c.active = int(p.uid) == active
		c.size = cart_size; c.custom_minimum_size = cart_size
		c.position = Vector2(x0 + k * (cart_size.x + gap), slot_y - sliver - (4.0 if c.active else 0.0))
		c.title = String(p.name) + ("  ·  STR %d" % int(p.str) if p.pick else "")
		c.lines = [String(p.get("text", ""))]
		c.chosen.connect(func(uid): selected.emit(uid))
		holder.add_child(c)
		_carts.append(c)
		if c.active: shown = p
	if shown.is_empty() and n > 0: shown = programs[0]
	screen.show_program(shown, not shown.is_empty() and int(shown.uid) == active)

func cartridges() -> Array[Cartridge]:
	return _carts

class Cartridge extends HudWidgets.Explained:
	signal chosen(uid: int)
	var prog: Dictionary = {}
	var active := false
	func _init() -> void:
		super._init()
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	func _gui_input(e: InputEvent) -> void:
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
			accept_event(); grab_focus(); chosen.emit(int(prog.uid))
		elif e.is_action_pressed("ui_accept"):
			accept_event(); chosen.emit(int(prog.uid))
	func _get_drag_data(_at: Vector2) -> Variant:
		if not prog.get("pick", false): return null
		var ghost := Cartridge.new(); ghost.prog = prog; ghost.size = size; ghost.modulate.a = 0.8
		set_drag_preview(ghost)
		return {"kind": "pick", "uid": int(prog.uid)}
	func _draw() -> void:
		## A HuCard seen edge-on from above: rounded top, PROGRAM teal band, label window with the icon.
		var r := Rect2(Vector2.ZERO, size)
		var body := StyleBoxFlat.new()
		body.bg_color = Color("#E9E2D0"); body.border_color = Color("#2E8C8A"); body.set_border_width_all(2)
		body.corner_radius_top_left = 8; body.corner_radius_top_right = 8; body.anti_aliasing = true
		if active: body.shadow_color = Color(VasTokens.PHOSPHOR, 0.55); body.shadow_size = 8
		draw_style_box(body, r)
		draw_rect(Rect2(2, 2, size.x - 4, 7), Color("#2E8C8A"))
		var lab := Rect2(6, 12, size.x - 12, 22)
		draw_rect(lab, Color("#173A36"))
		var ico: Texture2D = IceKey.art("ICON_BREAK_LIGHT" if prog.get("pick", false) else "ICON_PASSIVE_LIGHT")
		if ico: draw_texture_rect(ico, Rect2(lab.position + Vector2(3, 2), Vector2(18, 18)), false, VasTokens.PHOSPHOR)
		if prog.get("pick", false):
			var t := str(int(prog.str))
			var f := VasTokens.FONT_READOUT
			draw_string(f, Vector2(lab.end.x - f.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x - 4, lab.position.y + 17), t, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, VasTokens.PHOSPHOR)
		# Grip ridges.
		for k in 3: draw_line(Vector2(10, 40 + k * 5), Vector2(size.x - 10, 40 + k * 5), Color("#B9AE96"), 1.5)
		focus_ring()

class ProgramScreen extends Control:
	## The CRT shows the selected program: tool icon, name, STR, its rule, in phosphor.
	var prog: Dictionary = {}
	var is_active := false
	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	func show_program(p: Dictionary, on: bool) -> void:
		prog = p; is_active = on; queue_redraw()
	func _draw() -> void:
		## Icons communicate, numbers quantify: name, the icepick's ICE type, STR and break cost.
		## The full rule is on the cartridge's hover/focus panel.
		if prog.is_empty(): return
		var col := VasTokens.PHOSPHOR
		var pad := 11.0   # clear of the glass's rounded corners
		var f := VasTokens.FONT_PLAQUE_SEMI
		var name := String(prog.name).to_upper()
		var px := 17
		while px > 11 and f.get_string_size(name, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x > size.x - 2 * pad: px -= 1
		draw_string(f, Vector2(pad, pad + px), name, HORIZONTAL_ALIGNMENT_LEFT, size.x - 2 * pad, px, col)
		draw_line(Vector2(pad, pad + px + 5), Vector2(size.x - pad, pad + px + 5), Color(col, 0.4), 1.0)
		var y := pad + px + 12
		var row_h := (size.y - y - pad) / 2.0
		var rf := VasTokens.FONT_READOUT
		var isz := minf(row_h - 2, 24.0)
		if prog.get("pick", false):
			# Row 1: the ICE type it breaks + STR.
			var t: Texture2D = null
			var it := String(prog.get("itype", ""))
			var L := IcePanelLayout.load_default()
			if L.type_icons.has(it): t = V2Art.tex(String(L.type_icons[it]), 48)
			if t: draw_texture_rect(t, Rect2(Vector2(pad, y), Vector2(isz, isz)), false)
			var st := "STR %d" % int(prog.str)
			draw_string(rf, Vector2(pad + isz + 8, y + isz * 0.78), st, HORIZONTAL_ALIGNMENT_LEFT, -1, int(isz * 0.8), col)
			# Row 2: break cost in BW.
			var y2 := y + row_h
			var bw: Texture2D = IceKey.art("ICON_BW")
			if bw: draw_texture_rect(bw, Rect2(Vector2(pad, y2), Vector2(isz, isz)), false, col)
			draw_string(rf, Vector2(pad + isz + 8, y2 + isz * 0.78), str(int(prog.get("break_cost", 1))), HORIZONTAL_ALIGNMENT_LEFT, -1, int(isz * 0.8), col)
		else:
			var ico: Texture2D = IceKey.art("ICON_PASSIVE_LIGHT")
			if ico: draw_texture_rect(ico, Rect2(Vector2(pad, y), Vector2(isz, isz)), false, col)
		if is_active:
			# Active lamp: this is the program a key click breaks with.
			var lc := Vector2(size.x - pad - 5, size.y - pad - 5)
			draw_circle(lc, 8.0, Color(col, 0.25)); draw_circle(lc, 4.5, col)
