class_name IcePanel
extends Control
## CAS-001 C08 (ARCH-V2-003): one ICE in its painted console window, in four zones
## (designer 2026-11-26), composed after the VAS-001 reference:
##   Identity           nameplate (top right) with the STR medallion on its upper-right corner;
##                      the type medallion on the portrait's upper-left corner
##   Virtual expression the painted ICE portrait (left), mood from FORM-001
##   Tactical controls  the subroutine keys (C09), right-aligned; more than four go into two rows
##                      (top row first, ARCH-V2-003v),
##                      plus the TUMBLER reel
##   Persistent status  the cream strip along the foot: power lamp and the passive's icon
## Icons communicate, numbers quantify, hover explains: no rule text on the panel. Unused space stays
## empty. Geometry and art come from IcePanelLayout. Never reads or calls Game.

signal break_requested(ice_ref: Dictionary, sub: int, pick_uid: int)
## ARCH-V2-004 targeting: a targeted card is waiting for an ICE; the whole panel is the target.
signal target_chosen(ice_ref: Dictionary)
var targetable := false
var _target_cover: Button

var layout: IcePanelLayout
var inspector: KeyInspector
## Callable(ice_ref, sub, pick_uid) -> {ok, cost, reason}; supplied by the lane (controller-backed).
var drop_check: Callable
var reduced_motion := false
## Narrow portrait so the keys get more room; the lane sets it when it has to shrink panels.
var compact := false
var model: Dictionary = {}
var ice_ref: Dictionary = {}

@onready var window: TextureRect = $Window
@onready var portrait_clip: Panel = $Expression/PortraitClip
@onready var portrait: TextureRect = $Expression/PortraitClip/Portrait
@onready var placeholder: Label = $Expression/PortraitClip/Placeholder
@onready var frame: TextureRect = $Expression/Frame
@onready var nameplate: TextureRect = $Identity/Nameplate
@onready var name_label: Label = $Identity/Nameplate/Name
@onready var type_badge: IceBadge = $Identity/TypeBadge
@onready var str_badge: IceBadge = $Identity/StrBadge
@onready var status: Panel = $Status
@onready var status_row: HBoxContainer = $Status/Row
@onready var power: Control = $Status/Row/Power
@onready var passive_chip: Button = $Status/Row/Passive
@onready var notes: Label = $Status/Row/Notes
@onready var band: Panel = $Controls
var bubble: SpeechBubble
## UI-TYPO-002 (M06): LETHAL's Cold Recognition lens, on this panel only, while the ICE is LETHAL.
var lethal_lens: LethalLens
@onready var bank: VBoxContainer = $Controls/Bank   # rows of keys (ARCH-V2-003v)

var _keys := {}          # sub -> SubroutineKey (active bank)
var _art_cache := {}
var _art_key := ""
var _power_on := true
var _laid_out_compact := -1

func setup(l: IcePanelLayout, insp: KeyInspector) -> void:
	layout = l
	inspector = insp
	if is_node_ready(): _apply_layout()

func _ready() -> void:
	if layout == null: layout = IcePanelLayout.load_default()
	bubble = SpeechBubble.new(); bubble.name = "Bubble"; bubble.visible = false
	add_child(bubble); move_child(bubble, $Expression.get_index() + 1)
	lethal_lens = LethalLens.new(); lethal_lens.name = "LethalLens"
	add_child(lethal_lens); move_child(lethal_lens, $Expression.get_index() + 1)
	_apply_layout()
	for b in [type_badge, str_badge]:
		b.inspect_requested.connect(_inspect_badge)
		b.inspect_ended.connect(func(x): if is_instance_valid(inspector): inspector.close(x))
	power.draw.connect(func():
		var c := power.size / 2.0
		power.draw_circle(c, 9.0, VasTokens.CHROME_LO)
		power.draw_circle(c, 6.5, VasTokens.LAMP_ON if _power_on else VasTokens.LAMP_OFF)
		if _power_on: power.draw_circle(c - Vector2(2, 2), 2.0, Color(1, 1, 1, 0.75)))
	passive_chip.text = ""
	passive_chip.icon = IceKey.art("ICON_PASSIVE")
	passive_chip.focus_mode = Control.FOCUS_ALL
	passive_chip.mouse_entered.connect(_inspect_passive)
	passive_chip.focus_entered.connect(_inspect_passive)
	passive_chip.mouse_exited.connect(func(): if is_instance_valid(inspector) and not passive_chip.has_focus(): inspector.close(passive_chip))
	passive_chip.focus_exited.connect(func(): if is_instance_valid(inspector): inspector.close(passive_chip))

func set_compact(on: bool) -> void:
	if on == compact: return
	compact = on
	if is_node_ready():
		_apply_layout()
		_keys.clear()
		for c in bank.get_children(): bank.remove_child(c); c.queue_free()
		if not model.is_empty(): set_model(model)

func _apply_layout() -> void:
	var L := layout
	_laid_out_compact = int(compact)
	var psz := L.size_of(compact)
	custom_minimum_size = psz
	size = psz
	# Window: the painted chrome bezel and seafoam field, nine-sliced with a thin rim (ARCH-V2-003r)
	# so the field, the avatar and the keys get the pixels. The stretched texture is the fallback.
	window.position = Vector2.ZERO
	window.size = psz
	window.texture = V2Art.tex(L.window_art, L.panel_size.x)
	_set_window_nine(true, psz)
	if window.texture == null and not has_node("FallbackWindow"): _fallback_window()
	# Virtual expression
	var pr := L.portrait_rect(compact)
	# Frameless avatar (transparent art) standing in the field: the biggest thing in the window.
	frame.visible = false
	var inner := pr.grow(-L.portrait_inset)
	portrait_clip.position = inner.position
	portrait_clip.size = inner.size
	portrait_clip.clip_children = CanvasItem.CLIP_CHILDREN_DISABLED
	portrait_clip.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	for n in [portrait, placeholder]:
		n.position = Vector2.ZERO
		n.size = inner.size
	# Identity
	var np := L.nameplate_rect(compact)
	nameplate.position = np.position
	nameplate.size = np.size
	nameplate.texture = V2Art.tex(L.nameplate_art, np.size.x)
	name_label.position = Vector2(np.size.y * 0.42, 0)
	name_label.size = Vector2(np.size.x - np.size.y * 0.42 - L.str_badge_size * 0.5, np.size.y)
	name_label.add_theme_font_override("font", VasTokens.FONT_PLAQUE)
	name_label.add_theme_color_override("font_color", VasTokens.PLAQUE_INK)
	# Tactical controls
	var br := L.bank_rect(compact)
	band.position = br.position
	band.size = br.size
	# No bed: the keys float over the avatar's lower edge; their own drop shadows separate them.
	band.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	bank.position = Vector2.ZERO
	bank.size = br.size
	# Speech bubble: a momentary overlay on top of everything in the panel.
	var br2 := L.bubble_rect(compact)
	move_child(bubble, get_child_count() - 1)
	bubble.position = br2.position
	bubble.size = br2.size
	bubble.font_px = L.bubble_font_size_compact if compact else L.bubble_font_size
	bubble.art = V2Art.tex(L.bubble_art, br2.size.x)
	bubble._fit()
	bubble.queue_redraw()
	# Persistent status (under the keys, so floating keys and chips stay on top)
	move_child(status, band.get_index())
	var sr := L.strip_rect(compact)
	status.position = sr.position
	status.size = sr.size
	var strip := V2Art.nine(L.status_strip_art, L.status_strip_margins, sr.size.y)
	status.add_theme_stylebox_override("panel", strip if strip else _strip_style())
	# The painted lamp socket sits near the left end of the strip; the power lamp goes in it.
	status_row.position = Vector2(sr.size.y * 0.12, 0)
	status_row.size = Vector2(sr.size.x - sr.size.y * 0.5, sr.size.y)
	power.custom_minimum_size = Vector2(sr.size.y * 0.8, sr.size.y * 0.8)

func _set_window_nine(on: bool, psz: Vector2) -> void:
	## Compact panels are taller than the painted window: nine-slice it (margins given in
	## reference px of the normal panel, converted to the source file's pixels).
	var nine: Panel = get_node_or_null("WindowNine")
	var src := V2Art.image(layout.window_art)
	if not on or src == null:
		if nine: nine.visible = false
		window.visible = true
		return
	if nine == null:
		nine = Panel.new(); nine.name = "WindowNine"; nine.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(nine); move_child(nine, window.get_index() + 1)
	nine.add_theme_stylebox_override("panel", V2Art.nine(layout.window_art, layout.window_margins, layout.window_rim))
	nine.position = Vector2.ZERO
	nine.size = psz
	nine.visible = true
	window.visible = false

func set_targetable(on: bool) -> void:
	## Cyan glow round the window and one big hit area (keys are not in play while targeting).
	targetable = on
	if on and _target_cover == null:
		_target_cover = Button.new(); _target_cover.name = "TargetCover"
		_target_cover.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		for st in ["normal", "hover", "pressed", "focus", "disabled"]:
			var ring := StyleBoxFlat.new(); ring.bg_color = Color(VasTokens.FOCUS, 0.10 if st == "hover" else 0.0)
			ring.border_color = VasTokens.FOCUS; ring.set_border_width_all(8 if st in ["hover", "focus"] else 5)
			ring.set_corner_radius_all(30); ring.anti_aliasing = true
			_target_cover.add_theme_stylebox_override(st, ring)
		_target_cover.pressed.connect(func(): if targetable: target_chosen.emit(ice_ref))
		add_child(_target_cover)
	if _target_cover:
		_target_cover.visible = on
		_target_cover.position = Vector2.ZERO
		_target_cover.size = size
		move_child(_target_cover, get_child_count() - 1)
	queue_redraw()

var _say_tween: Tween

func say(text: String, seconds: float = -1.0) -> void:
	## Momentary speech (designer 2026-11-26, ARCH-V2-003r): the bubble covers what is under it for
	## `seconds` (default layout.bubble_seconds, 1–2 s), then goes. seconds = 0 holds it (fixtures).
	## Empty text hides it at once. Presentation only.
	if _say_tween and _say_tween.is_valid(): _say_tween.kill()
	bubble.text = text
	bubble.visible = text != ""
	bubble.modulate.a = 1.0
	bubble.queue_redraw()
	if text == "" or seconds == 0.0 or not is_inside_tree(): return
	var hold := layout.bubble_seconds if seconds < 0.0 else seconds
	_say_tween = create_tween()
	_say_tween.tween_interval(hold)
	if not reduced_motion: _say_tween.tween_property(bubble, "modulate:a", 0.0, 0.2)
	_say_tween.tween_callback(func(): bubble.visible = false; bubble.modulate.a = 1.0)

func set_model(m: Dictionary) -> void:
	model = m
	ice_ref = m.ref
	if not is_node_ready():
		push_error("IcePanel.set_model before the panel is in the tree")
		return
	if _laid_out_compact != int(compact): _apply_layout()
	var L := layout
	# Identity
	name_label.text = String(m.name)
	var fs := L.name_font_size
	while fs > 14 and VasTokens.FONT_PLAQUE.get_string_size(name_label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x > name_label.size.x: fs -= 1
	name_label.add_theme_font_size_override("font_size", fs)
	var pr := L.portrait_rect(compact)
	var type_tex: Texture2D = V2Art.tex(String(L.type_icons[String(m.type)]), L.type_badge_size) if L.type_icons.has(String(m.type)) else null
	type_badge.set_badge("type", String(m.type), 0, 0, type_tex, L.type_badge_size)
	type_badge.position = L.type_badge_center - Vector2(L.type_badge_size, L.type_badge_size) / 2.0
	var np := L.nameplate_rect(compact)
	str_badge.font_px = L.str_font_size
	str_badge.set_badge("str", String(m.type), int(m.str), int(m.str_delta), V2Art.tex(L.str_icon, L.str_badge_size), L.str_badge_size)
	str_badge.position = Vector2(np.end.x, np.position.y) - Vector2(L.str_badge_size, L.str_badge_size) / 2.0
	# Virtual expression
	_set_portrait(String(m.id), String(m.mood))
	if String(m.mood) != _mood_now:
		_mood_prev = _mood_now; _mood_now = String(m.mood); _mood_age = 0.0
	portrait.modulate = Color(0.55, 0.55, 0.55) if m.breached else Color.WHITE
	# LETHAL lens: under the type medallion, on the portrait's left edge, clear of the keys and plates.
	lethal_lens.reduced_motion = reduced_motion
	lethal_lens.position = Vector2(maxf(L.window_rim + 4.0, L.type_badge_center.x - lethal_lens.size.x / 2.0),
		L.type_badge_center.y + L.type_badge_size / 2.0 + 10.0)
	lethal_lens.set_active(bool(m.get("lethal", false)))
	# Persistent status: power lamp, then the passive's icon (rule on hover/focus).
	_power_on = not m.breached
	power.queue_redraw()
	passive_chip.visible = String(m.passive) != ""
	passive_chip.custom_minimum_size = Vector2(L.strip_height * 0.82, L.strip_height * 0.82)
	notes.visible = false
	_sync_virus(m.get("virus", []))
	# Tactical controls
	_build_bank(m)

static func row_split(n: int) -> Array:
	## ARCH-V2-003v (designer 2026-11-26 15:51): up to four keys in one row; more than four go into
	## two rows, the top row holding the first ones and the bottom row the rest (5 → 2 + 3, 6 → 3 + 3).
	## Order reads left to right, top row then bottom row.
	if n <= 4: return [n]
	return [n / 2, n - n / 2]

func _build_bank(m: Dictionary) -> void:
	var L := layout
	var wanted := []
	for k in m.keys: wanted.append(int(k.sub))
	var unit := _unit(m)
	var br := L.bank_rect(compact)
	band.size = br.size
	bank.position = Vector2(L.bank_rim, L.bank_rim)
	bank.size = br.size - Vector2(2.0 * L.bank_rim, 2.0 * L.bank_rim)
	var reuse: bool = wanted == _keys.keys() and bank.get_child_count() > 0 and m.pool.is_empty() and int(m.hidden_pool) == 0 and not _has_pool()
	if reuse:
		for k in m.keys: _keys[int(k.sub)].set_model(k, unit)
		return
	var focused_sub := -1
	for s in _keys:
		if is_instance_valid(_keys[s]) and _keys[s].has_focus(): focused_sub = s
	for c in bank.get_children():
		bank.remove_child(c); c.queue_free()
	_keys.clear()
	var split := row_split(m.keys.size())
	var n := 0
	for r in split.size():
		var row := HBoxContainer.new(); row.name = "Row%d" % (r + 1)
		row.alignment = BoxContainer.ALIGNMENT_END
		row.add_theme_constant_override("separation", 0)
		row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bank.add_child(row)
		for j in int(split[r]):
			if j > 0: row.add_child(_chevron(unit))
			var key := SubroutineKey.new()
			key.name = "Key_S%d" % (int(m.keys[n].sub) + 1)
			key.set_model(m.keys[n], unit)
			key.drop_check = func(sub: int, uid: int) -> Dictionary: return drop_check.call(ice_ref, sub, uid) if drop_check.is_valid() else {"ok": false}
			key.break_requested.connect(func(rf, s, u): break_requested.emit(rf, s, u))
			key.inspect_requested.connect(func(k): if is_instance_valid(inspector): inspector.show_key(k, String(model.name)))
			key.inspect_ended.connect(func(k): if is_instance_valid(inspector): inspector.close(k))
			row.add_child(key)
			_keys[int(m.keys[n].sub)] = key
			n += 1
		if r == 0 and split.size() > 1 and L.row_return_arrow:
			var ret := ReturnArrow.new(); ret.name = "RowReturn"
			ret.custom_minimum_size = Vector2(34, 60) * unit
			row.add_child(ret)
		if r == split.size() - 1 and (not m.pool.is_empty() or int(m.hidden_pool) > 0):
			var gap := Control.new(); gap.custom_minimum_size.x = L.pool_gap; gap.mouse_filter = Control.MOUSE_FILTER_IGNORE
			row.add_child(gap)
			row.add_child(_reel(m))
	if focused_sub >= 0 and _keys.has(focused_sub): _keys[focused_sub].grab_focus.call_deferred()

func _has_pool() -> bool:
	return bank.find_child("Reel", true, false) != null

func _unit(m: Dictionary) -> float:
	## As large as the key area allows, up to key_unit_max (1.0 = 60 px caps), for the row layout.
	var L := layout
	var n: int = m.keys.size()
	var pool_w := 0.0
	if not m.pool.is_empty() or int(m.hidden_pool) > 0: pool_w = L.pool_gap + 2 * 30 + 3 + 16
	var br := L.bank_rect(compact)
	var split := row_split(n)
	var fit := 99.0
	for r in split.size():
		var len := int(split[r])
		var extra := pool_w if r == split.size() - 1 else 0.0
		var room := br.size.x - 2.0 * L.bank_rim - extra - maxf(0, len - 1) * L.chevron(compact)
		fit = minf(fit, room / maxf(1.0, len * (IceKey.KEY + 8.0)))
	var rows := float(split.size())
	var tall := (br.size.y - 2.0 * L.bank_rim - (rows - 1.0) * 6.0) / (rows * (IceKey.KEY + IceKey.LAMP_H + IceKey.CHIP_H + 4.0))
	return clampf(minf(minf(L.unit_max(compact), fit), tall), 0.5, L.unit_max(compact))

func _reel(m: Dictionary) -> Control:
	## Build 12 TUMBLER reel: spent/seen subroutines as small keys, unseen ones as "?".
	var reel := PanelContainer.new(); reel.name = "Reel"
	var st := StyleBoxFlat.new(); st.bg_color = Color("#141210"); st.border_color = VasTokens.CHROME_LO
	st.set_border_width_all(2); st.set_corner_radius_all(8); st.set_content_margin_all(4)
	reel.add_theme_stylebox_override("panel", st)
	reel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var grid := GridContainer.new(); grid.columns = 2
	grid.add_theme_constant_override("h_separation", 3); grid.add_theme_constant_override("v_separation", 3)
	reel.add_child(grid)
	for p in m.pool:
		var mini := SubroutineKey.new(); mini.set_model(p); grid.add_child(mini)
		mini.inspect_requested.connect(func(k): if is_instance_valid(inspector): inspector.show_key(k, String(model.name)))
		mini.inspect_ended.connect(func(k): if is_instance_valid(inspector): inspector.close(k))
	for h in int(m.hidden_pool):
		var q := SubroutineKey.new()
		q.set_model({"ref": m.ref, "sub": -1, "mini": true, "kind": "HIDDEN", "value": "", "state": "hidden", "cost_text": "",
			"title": VisibleStateAdapter.HIDDEN_TITLE, "rules": [{"kind": "HIDDEN", "text": "Hidden in the reel until it tumbles in."}], "place": "REEL"})
		q.inspect_requested.connect(func(k): if is_instance_valid(inspector): inspector.show_key(k, String(model.name)))
		q.inspect_ended.connect(func(k): if is_instance_valid(inspector): inspector.close(k))
		grid.add_child(q)
	return reel

func _chevron(unit: float) -> Control:
	## Firing order between keys: the rail's brass chevron art (drawn fallback if missing).
	var c := Control.new(); c.name = "Order"
	c.custom_minimum_size = Vector2(layout.chevron(compact), (IceKey.KEY + IceKey.LAMP_H + IceKey.CHIP_H + 4.0) * unit)
	c.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var arrow := V2Art.tex("controls/V2_RAIL_ARROW.png", maxf(layout.chevron(compact), 8.0))
	c.draw.connect(func():
		var mid := Vector2(c.size.x / 2.0, (IceKey.LAMP_H + IceKey.KEY / 2.0) * unit)
		if arrow:
			var w := c.size.x * 0.75
			var h := w * float(arrow.get_height()) / arrow.get_width()
			c.draw_texture_rect(arrow, Rect2(mid - Vector2(w, h) / 2.0, Vector2(w, h)), false)
		else:
			var w2 := c.size.x * 0.32
			c.draw_colored_polygon(PackedVector2Array([mid + Vector2(-w2, -w2 * 1.2), mid + Vector2(w2, 0), mid + Vector2(-w2, w2 * 1.2)]), VasTokens.SEAFOAM_INK))
	return c

func key(sub: int) -> SubroutineKey:
	return _keys.get(sub)

func keys() -> Array:
	return _keys.values()

func _set_portrait(id: String, mood: String) -> void:
	var art_mood := "lethal" if mood == "lethal" else ("wary" if mood in ["wary", "knocked_out"] else "cheery")
	var path := layout.portrait_pattern % [id, art_mood]
	# Revised avatar for this mood, then the concept mascot, then the revised avatar's nearest mood.
	for alt in [layout.portrait_fallback_pattern % [id, art_mood], layout.portrait_pattern % [id, "wary" if art_mood == "lethal" else "cheery"], layout.portrait_pattern % [id, "lethal"]]:
		if ResourceLoader.exists(path): break
		path = alt
	if path == _art_key: return
	var old := portrait.texture
	_art_key = path
	if not _art_cache.has(path): _art_cache[path] = load(path) if ResourceLoader.exists(path) else null
	var tex: Texture2D = _art_cache[path]
	portrait.texture = tex
	placeholder.visible = tex == null
	placeholder.text = id.replace("_", " ")
	if old != null and tex != null and old != tex and not reduced_motion and is_inside_tree():
		portrait.modulate.a = 0.0
		create_tween().tween_property(portrait, "modulate:a", 1.0, 0.25)

func _inspect_badge(b: IceBadge) -> void:
	## Designer 2026-11-26 (ARCH-V2-003j): the type badge shows the ICE type; the STR badge shows
	## "ICE STRENGTH: n" with the ICE's current STR. Nothing else.
	if not is_instance_valid(inspector): return
	if b.kind == "type":
		inspector.show_info("", String(model.type), [], b.get_global_rect(), b)
	else:
		inspector.show_info("", "ICE STRENGTH: %d" % int(model.str), [], b.get_global_rect(), b)

func _inspect_passive() -> void:
	if is_instance_valid(inspector) and String(model.get("passive", "")) != "":
		inspector.show_info("PASSIVE", String(model.name), [String(model.passive)], passive_chip.get_global_rect(), passive_chip)

# ----- Drawn fallbacks (used only if a painted part is missing).

func _fallback_window() -> void:
	var p := Panel.new(); p.name = "FallbackWindow"; p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.size = layout.panel_size
	var s := StyleBoxFlat.new(); s.bg_color = VasTokens.SEAFOAM; s.border_color = VasTokens.CHROME_HI
	s.set_border_width_all(7); s.set_corner_radius_all(30)
	p.add_theme_stylebox_override("panel", s)
	add_child(p); move_child(p, 0)

func _band_style() -> StyleBox:
	var s := StyleBoxFlat.new(); s.bg_color = VasTokens.SEAFOAM_DEEP; s.border_color = Color("#2F5E52")
	s.set_border_width_all(3); s.set_corner_radius_all(14)
	return s

func _strip_style() -> StyleBox:
	var s := StyleBoxFlat.new(); s.bg_color = VasTokens.IVORY; s.border_color = VasTokens.CHROME_LO
	s.set_border_width_all(2); s.set_corner_radius_all(14)
	return s

class ReturnArrow extends Control:
	## A brass typewriter carriage-return mark (↵): the order continues on the row below.
	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	func _draw() -> void:
		var w := size.x
		var h := size.y
		var brass := Color("#C8913A")
		var dark := Color("#3A2414")
		var top := Vector2(w * 0.72, h * 0.18)
		var corner := Vector2(w * 0.72, h * 0.78)
		var tip := Vector2(w * 0.12, h * 0.78)
		for pass_i in 2:
			var col := dark if pass_i == 0 else brass
			var th := (w * 0.2) if pass_i == 0 else (w * 0.12)
			draw_polyline(PackedVector2Array([top, corner, tip + Vector2(w * 0.18, 0)]), col, th, true)
			var hw := w * (0.24 if pass_i == 0 else 0.18)
			draw_colored_polygon(PackedVector2Array([tip, tip + Vector2(hw * 1.4, -hw), tip + Vector2(hw * 1.4, hw)]), col)
		draw_circle(top, w * 0.07, brass)

## I10: one chip per virus strain on this ICE (strain initial + count); the rule on hover/focus.
func _sync_virus(list: Array) -> void:
	var row: Node = passive_chip.get_parent()
	for c in row.get_children():
		if c.name.begins_with("Virus_"): row.remove_child(c); c.queue_free()
	var h := layout.strip_height * 0.82
	for v in list:
		var chip := VirusChip.new(); chip.name = "Virus_%s" % v.strain
		chip.strain = String(v.strain); chip.n = int(v.n); chip.inspector = inspector
		chip.title = "%s %d" % [v.strain, v.n]; chip.lines = [String(v.rule)] if String(v.rule) != "" else []
		chip.custom_minimum_size = Vector2(h * 1.9, h)
		row.add_child(chip)

class VirusChip extends HudWidgets.Explained:
	var strain := ""
	var n := 0
	const COL := {"ROT": Color("#9BCB3C"), "SCRAMBLE": Color("#E07AE0"), "BLIND": Color("#7FB7FF"), "LEECH": Color("#FFB32E"), "WORM": Color("#FF7A4A")}
	func _draw() -> void:
		var r := Rect2(Vector2.ZERO, size)
		var col: Color = COL.get(strain, VasTokens.IVORY)
		var sb := StyleBoxFlat.new(); sb.bg_color = Color("#14100C"); sb.border_color = col
		sb.set_border_width_all(2); sb.set_corner_radius_all(int(size.y / 2.0)); sb.anti_aliasing = true
		draw_style_box(sb, r)
		var px := int(size.y * 0.6)
		var t := "%s %d" % [strain.substr(0, 1), n]
		var tw := VasTokens.FONT_PLAQUE.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
		draw_string(VasTokens.FONT_PLAQUE, Vector2((size.x - tw) / 2.0, size.y / 2.0 + px * 0.36), t, HORIZONTAL_ALIGNMENT_LEFT, -1, px, col)
		focus_ring()

## ARCH-V2-007a: the corporation's room in this window, inside the bezel, behind the avatar. `uv`
## is the part of the room behind this panel (the lane works it out so the windows read as one view).
var _room: ColorRect
const ROOM_SHADER := preload("res://themes/architecture_v2/corp_room.gdshader")
func set_room(friendly: Texture2D, hostile: Texture2D, uv: Rect2, reveal: float) -> void:
	if friendly == null:
		if _room: _room.visible = false
		return
	if _room == null:
		_room = ColorRect.new(); _room.name = "Room"; _room.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var m := ShaderMaterial.new(); m.shader = ROOM_SHADER; _room.material = m
		add_child(_room)
		var above: Node = get_node_or_null("WindowNine")
		move_child(_room, (above.get_index() if above else window.get_index()) + 1)
	var inset := layout.window_rim * 0.62
	_room.position = Vector2(inset, inset)
	_room.size = size - Vector2(inset, inset) * 2.0
	_room.visible = true
	var mat: ShaderMaterial = _room.material
	mat.set_shader_parameter("friendly", friendly)
	mat.set_shader_parameter("hostile", hostile)
	mat.set_shader_parameter("has_hostile", 1.0 if hostile else 0.0)
	mat.set_shader_parameter("reveal", reveal)
	var pad := Vector2(inset, inset) / size   # the room's part shrinks with the inset
	mat.set_shader_parameter("uv_rect", Vector4(uv.position.x + uv.size.x * pad.x, uv.position.y + uv.size.y * pad.y, uv.size.x * (1.0 - 2.0 * pad.x), uv.size.y * (1.0 - 2.0 * pad.y)))
	mat.set_shader_parameter("size_px", _room.size)
	mat.set_shader_parameter("radius_px", layout.window_rim * 0.8)

func has_room() -> bool:
	return _room != null and _room.visible

## ARCH-V2-007b: PIXEL-TRACE-001 in the V2 window. As TRACE rises the room and the avatar drop
## toward 16-bit (square cells, fewer colours, dither); the keys, plates, bubble and text above stay
## sharp. `look` is {cell, levels, dither} from AtomicDecoPunk.pixel_step (the screen animates it).
const TRACE_PIXEL := preload("res://themes/trace_pixel.gdshader")
const MOOD_PIXEL := preload("res://themes/mood_pixel.gdshader")
var _pixel: Control
var _pixel_mat: ShaderMaterial
var pixel_base := 1.0
func set_trace_pixel(look: Dictionary) -> void:
	var cell := float(roundi(float(look.get("cell", 1.0))))
	pixel_base = cell
	if cell <= 1.0:
		if _pixel: _pixel.visible = false
		return
	if _pixel == null:
		_pixel = Control.new(); _pixel.name = "TracePixel"; _pixel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var copy := BackBufferCopy.new(); copy.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT; _pixel.add_child(copy)
		_pixel_mat = ShaderMaterial.new(); _pixel_mat.shader = TRACE_PIXEL
		var r := ColorRect.new(); r.name = "Cells"; r.material = _pixel_mat; r.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_pixel.add_child(r)
		add_child(_pixel); move_child(_pixel, $Expression.get_index() + 1)   # above room and avatar, below bubble and keys
	var inset := layout.window_rim * 0.62
	_pixel.position = Vector2(inset, inset); _pixel.size = size - Vector2(inset, inset) * 2.0
	(_pixel.get_node("Cells") as ColorRect).size = _pixel.size
	_pixel.visible = true
	_pixel_mat.set_shader_parameter("cell", cell)
	_pixel_mat.set_shader_parameter("levels", float(look.get("levels", 256.0)))
	_pixel_mat.set_shader_parameter("dither", float(look.get("dither", 0.0)))

func trace_pixel_cell() -> float:
	return float(_pixel_mat.get_shader_parameter("cell")) if _pixel and _pixel.visible else 1.0

## ARCH-V2-007b: MOOD-PIXEL-001 in V2. When the avatar's mood changes it drops into 16-bit and
## resolves; while lethal it pulses 2 s in 16-bit, 2 s crisp (Build 12's timings and look, shared
## with FriendlyMascot.mood_look). Masked by the avatar's own alpha. Off under reduced motion.
var _mood_now := ""
var _mood_prev := ""
var _mood_age := 99.0
var _mood_fx: Control
var _mood_mat: ShaderMaterial
func _process(delta: float) -> void:
	_mood_age += delta
	var look := FriendlyMascot.mood_look(_mood_now, _mood_prev, _mood_age, Time.get_ticks_msec() / 1000.0, reduced_motion, pixel_base)
	apply_mood_look(look)

func apply_mood_look(look: Dictionary) -> void:
	var cell := float(roundi(float(look.cell)))
	if cell <= 1.0 or portrait.texture == null:
		if _mood_fx: _mood_fx.visible = false
		return
	if _mood_fx == null:
		_mood_fx = Control.new(); _mood_fx.name = "MoodPixel"; _mood_fx.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var copy := BackBufferCopy.new(); copy.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT; _mood_fx.add_child(copy)
		_mood_mat = ShaderMaterial.new(); _mood_mat.shader = MOOD_PIXEL
		var r := ColorRect.new(); r.name = "Cells"; r.material = _mood_mat; r.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_mood_fx.add_child(r)
		portrait.add_child(_mood_fx)
	# The fx rect covers exactly where the portrait texture is drawn (keep-aspect, centred), so the
	# mask lines up with the avatar.
	var ts := portrait.texture.get_size()
	var k := minf(portrait.size.x / ts.x, portrait.size.y / ts.y)
	var drawn := ts * k
	_mood_fx.position = (portrait.size - drawn) / 2.0; _mood_fx.size = drawn
	(_mood_fx.get_node("Cells") as ColorRect).size = drawn
	_mood_mat.set_shader_parameter("mask_tex", portrait.texture)
	_mood_mat.set_shader_parameter("cell", cell)
	_mood_mat.set_shader_parameter("levels", float(look.levels))
	_mood_mat.set_shader_parameter("dither", float(look.dither))
	_mood_fx.visible = true

func mood_pixel_on() -> bool:
	return _mood_fx != null and _mood_fx.visible

## ARCH-V2-007b: the corporation's enamel on the window's painted seafoam (IRONWATCH navy, LUCIDA
## lilac; HALCYON keeps its seafoam). Chrome and brass keep their colour (console_tint shader).
const CONSOLE_TINT := preload("res://themes/console_tint.gdshader")
func set_enamel(target: Variant) -> void:
	var nine: CanvasItem = get_node_or_null("WindowNine")
	for n in [window, nine]:
		if n == null: continue
		if target == null: n.material = null
		else:
			var m := ShaderMaterial.new(); m.shader = CONSOLE_TINT; m.set_shader_parameter("target", target)
			n.material = m

