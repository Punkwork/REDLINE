class_name CardView
extends Control
## CAS-001 C11 (ARCH-V2-004, Batch 2; PROPOSED): one card as a PC Engine HuCard (CARD-HUCARD-001):
## portrait 1 : 1.58, rounded corners, a thin darker-white edge on the right and bottom, gold contacts
## along the bottom edge. VAS-001 finish: type-coloured frame around the art window, white BW cost
## medallion top left, name and type line left-aligned (so the left half of a fanned card identifies
## it), cream rules field. Drawn in the engine so it is crisp at any size; a painted body can replace
## the drawing later (VAS-ASSET-001 §3f). States: playable, unplayable (dimmed), hover/focus (cyan
## edge, inspector with the large card, HOVER-001), selected (thick cyan, glow).
## Emits intent only; never calls Game.

signal pressed(uid: int)
## C04 (PT11-UI 2): a drag that ended over no drop target, with the global point it ended at. The
## screen decides: untargeted cards play when dropped above the hand tray; targeted ones on an ICE.
signal drag_dropped(uid: int, at: Vector2)

const BASE := Vector2(140, 221)
const FACE := Color("#F6F1E4")
const EDGE := Color("#BDB29A")
const INK := Color("#2A1D0E")
const SUB_INK := Color("#5E4B35")
const RULES_BG := Color("#FBF3DC")
const TAG_COLORS := {"EXPLOIT": Color("#C8452F"), "CLOAK": Color("#7C4BA0"), "ICEPICK": Color("#3E8E5A"),
	"EXTRACTOR": Color("#C9861E"), "VIRUS": Color("#7A9A2A"), "HARDWARE": Color("#5E6E7A"), "DEFENSE": Color("#D89A2A")}
const TYPE_COLORS := {"PROGRAM": Color("#2E8C8A"), "SCRIPT": Color("#C2604E"), "PROTOCOL": Color("#B8921E"), "BLOATWARE": Color("#8E3A2A")}

var model: Dictionary = {}
var inspector: KeyInspector
var selected := false
var show_rules := true
var draggable := true
var _down := false
var _dragging := false
static var _art_cache := {}

func _init() -> void:
	focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_entered.connect(_inspect)
	focus_entered.connect(_inspect)
	mouse_exited.connect(func(): if not has_focus(): _release())
	focus_exited.connect(_release)

func set_model(m: Dictionary) -> void:
	model = m
	tooltip_text = ""
	queue_redraw()

func uid() -> int: return int(model.get("uid", -1))

func frame_color() -> Color:
	for t in model.get("tags", []):
		if TAG_COLORS.has(String(t)): return TAG_COLORS[String(t)]
	return TYPE_COLORS.get(String(model.get("type", "")), Color("#6E6458"))

func type_line() -> String:
	var parts := [String(model.get("type", ""))]
	for t in model.get("tags", []): parts.append(String(t))
	return " · ".join(parts)

static func art_for(path: String) -> Texture2D:
	if not _art_cache.has(path): _art_cache[path] = load(path) if path != "" and ResourceLoader.exists(path) else null
	return _art_cache[path]

func _gui_input(e: InputEvent) -> void:
	## A click plays on release (so a press can become a drag); Enter/Space plays at once.
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
		accept_event()
		if e.pressed:
			_down = true; grab_focus()
		elif _down:
			_down = false
			if Rect2(Vector2.ZERO, size).has_point(e.position): pressed.emit(uid())
	elif e.is_action_pressed("ui_accept"):
		accept_event(); pressed.emit(uid())

func _get_drag_data(_at: Vector2) -> Variant:
	if not draggable or not bool(model.get("playable", false)): return null
	_down = false; _dragging = true
	if is_instance_valid(inspector): inspector.close(self)
	var holder := Control.new()
	var ghost := CardView.new(); ghost.set_model(model); ghost.draggable = false
	ghost.custom_minimum_size = size * 0.85; ghost.size = size * 0.85; ghost.position = -ghost.size / 2.0
	ghost.modulate = Color(1, 1, 1, 0.85); ghost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(ghost)
	if get_viewport() and get_viewport().gui_is_dragging(): set_drag_preview(holder)
	else: holder.queue_free()
	return {"card_uid": uid()}

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END and _dragging:
		_dragging = false
		if not get_viewport().gui_is_drag_successful(): drag_dropped.emit(uid(), get_global_mouse_position())

## Set before a programmatic focus (a choice opening) so the inspector waits for the player.
var quiet_focus := false

func _inspect() -> void:
	if quiet_focus:
		quiet_focus = false
		queue_redraw()
		return
	if is_instance_valid(inspector) and not model.is_empty(): inspector.show_card(self)
	queue_redraw()

func _release() -> void:
	if not is_inside_tree() or is_queued_for_deletion(): return
	if is_instance_valid(inspector): inspector.close(self)
	queue_redraw()

func _rr(r: Rect2, col: Color, radius: float, border := Color.TRANSPARENT, bw := 0.0) -> void:
	var sb := StyleBoxFlat.new(); sb.bg_color = col; sb.set_corner_radius_all(int(radius)); sb.anti_aliasing = true
	if bw > 0.0: sb.border_color = border; sb.set_border_width_all(maxi(1, int(bw)))
	draw_style_box(sb, r)

func _draw() -> void:
	if model.is_empty(): return
	var k := size.x / BASE.x
	var w := size.x
	var h := size.y
	var edge := 3.0 * k
	var body := Rect2(Vector2.ZERO, Vector2(w - edge, h - edge))
	var lit := has_focus() or get_global_rect().has_point(get_global_mouse_position())
	# Selection glow behind the card.
	if selected:
		var g := StyleBoxFlat.new(); g.bg_color = Color(VasTokens.FOCUS, 0.0); g.set_corner_radius_all(int(12 * k))
		g.shadow_color = Color("#4FE3E0", 0.6); g.shadow_size = int(14 * k)
		draw_style_box(g, body)
	# HuCard body: darker-white edge on the right and bottom, then the face.
	_rr(Rect2(Vector2(edge, edge), body.size), EDGE, 11 * k)
	_rr(body, FACE, 11 * k, Color("#D8CFBC"), 1.0 * k)
	# Type-coloured frame around the art window.
	var frame := Rect2(Vector2(6, 6) * k, Vector2(body.size.x - 12 * k, 110 * k))
	var fc := frame_color()
	_rr(frame, fc, 7 * k)
	var win := frame.grow(-5 * k)
	var tex := art_for(String(model.get("art", "")))
	if tex:
		# Cover the window, keeping the art's aspect.
		var ts := Vector2(tex.get_width(), tex.get_height())
		var sc := maxf(win.size.x / ts.x, win.size.y / ts.y)
		var src_size := win.size / sc
		var src := Rect2((ts - src_size) / 2.0, src_size)
		draw_texture_rect_region(tex, win, src)
	else:
		_rr(win, fc.darkened(0.35), 4 * k)
		var ico: Texture2D = IceKey.art("ICON_BREAK_LIGHT" if "ICEPICK" in model.get("tags", []) else "ICON_PASSIVE_LIGHT")
		if ico: draw_texture_rect(ico, Rect2(win.get_center() - Vector2(22, 22) * k, Vector2(44, 44) * k), false, Color(1, 1, 1, 0.8))
	# Cost medallion (white, black ring), top left, over the frame.
	var mc := Vector2(21, 21) * k
	draw_circle(mc + Vector2(0, 1.5) * k, 14 * k, Color(0, 0, 0, 0.35))
	draw_circle(mc, 14 * k, Color("#151515"))
	draw_circle(mc, 11.5 * k, Color("#FFFDF7"))
	var cf := VasTokens.FONT_READOUT
	var cost := str(int(model.get("bw", 0)))
	var cpx := int(15 * k)
	draw_string(cf, mc + Vector2(-cf.get_string_size(cost, HORIZONTAL_ALIGNMENT_LEFT, -1, cpx).x / 2.0, cpx * 0.36), cost, HORIZONTAL_ALIGNMENT_LEFT, -1, cpx, INK)
	var bw_ico: Texture2D = IceKey.art("ICON_BW")
	if bw_ico: draw_texture_rect(bw_ico, Rect2(mc + Vector2(7, 5) * k, Vector2(10, 10) * k), false)
	# Name and type line, left-aligned.
	var nf := VasTokens.FONT_PLAQUE
	var name := String(model.get("name", "")).to_upper()
	var npx := int(16 * k)
	var nw := body.size.x - 16 * k
	while npx > int(10 * k) and nf.get_string_size(name, HORIZONTAL_ALIGNMENT_LEFT, -1, npx).x > nw: npx -= 1
	draw_string(nf, Vector2(8 * k, 132 * k), name, HORIZONTAL_ALIGNMENT_LEFT, nw, npx, INK)
	draw_string(VasTokens.FONT_PLAQUE_SEMI, Vector2(8 * k, 145 * k), type_line(), HORIZONTAL_ALIGNMENT_LEFT, nw, int(9.5 * k), SUB_INK)
	# Cream rules field.
	var rules := Rect2(Vector2(7, 150) * k, Vector2(body.size.x - 14 * k, 42 * k))
	_rr(rules, RULES_BG, 4 * k, Color("#E4D6B4"), 1.0 * k)
	if show_rules:
		draw_multiline_string(VasTokens.FONT_RULES, rules.position + Vector2(4, 10) * k, String(model.get("text", "")), HORIZONTAL_ALIGNMENT_LEFT, rules.size.x - 8 * k, int(8.5 * k), 3, INK)
	# Gold contacts along the bottom edge.
	var strip := Rect2(Vector2(14, 197) * k, Vector2(body.size.x - 28 * k, 16 * k))
	_rr(strip, Color("#E3D8C0"), 3 * k)
	var n := 9
	var gap := 2.5 * k
	var cw := (strip.size.x - 8 * k - (n - 1) * gap) / n
	for i in n:
		var c := Rect2(strip.position + Vector2(4 * k + i * (cw + gap), 2.5 * k), Vector2(cw, strip.size.y - 5 * k))
		_rr(c, Color("#C79A36"), 1.5 * k)
		draw_rect(Rect2(c.position + Vector2(0.8, 0.8) * k, Vector2(c.size.x - 1.6 * k, c.size.y * 0.35)), Color("#F0D58A"))
		draw_rect(Rect2(c.position + Vector2(0, c.size.y * 0.8), Vector2(c.size.x, c.size.y * 0.2)), Color("#7E5C1A"))
	# CACHE-001 corner icon: a cyan disc on the art frame's top-right with ∞ (the encounter) or the
	# turns left.
	if bool(model.get("cached", false)):
		var cc := Vector2(frame.end.x - 13 * k, frame.position.y + 13 * k)
		draw_circle(cc, 12 * k, Color("#06262A"))
		draw_arc(cc, 11 * k, 0, TAU, 24, Color("#4FE3E0"), 2.2 * k, true)
		var turns := int(model.get("cache_turns", 0))
		var ct := "∞" if turns <= 0 else str(turns)
		var cpx2 := int((17 if turns <= 0 else 14) * k)
		var cw2 := VasTokens.FONT_PLAQUE.get_string_size(ct, HORIZONTAL_ALIGNMENT_LEFT, -1, cpx2).x
		draw_string(VasTokens.FONT_PLAQUE, cc + Vector2(-cw2 / 2.0, cpx2 * 0.36), ct, HORIZONTAL_ALIGNMENT_LEFT, -1, cpx2, Color("#BFFBF8"))
	# Unplayable: dimmed (the reason is on hover).
	if not bool(model.get("playable", true)):
		_rr(body, Color(0.12, 0.09, 0.06, 0.38), 11 * k)
	# Hover / focus / selected: cyan edge.
	if lit or selected:
		var f := StyleBoxFlat.new(); f.draw_center = false; f.border_color = Color("#4FE3E0") if selected else VasTokens.FOCUS
		f.set_border_width_all(int((4 if selected else 3) * k)); f.set_corner_radius_all(int(12 * k)); f.anti_aliasing = true
		draw_style_box(f, body.grow(2 * k))
