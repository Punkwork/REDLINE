class_name IcePanel
extends Control
## CAS-001 C08 (ARCH-V2-003): one ICE as a console window in four zones (designer 2026-11-26):
##   Identity          nameplate; type icon on the portrait's upper-left corner; STR icon + number on
##                     the nameplate's upper-right corner
##   Virtual expression the painted ICE portrait (mood art from FORM-001)
##   Tactical controls  the horizontal bank of illuminated subroutine keys (C09) and the TUMBLER reel
##   Persistent status  power lamp and only what isn't shown elsewhere (passive, ZEROED, strains)
## Negative space is deliberate: nothing is added to fill it. Geometry and art come from an
## IcePanelLayout so they can change without code changes. Never reads or calls Game: it renders
## adapter models and forwards intents.

signal break_requested(ice_ref: Dictionary, sub: int, pick_uid: int)

var layout: IcePanelLayout
var inspector: KeyInspector
## Callable(ice_ref, sub, pick_uid) -> {ok, cost, reason}; supplied by the lane (controller-backed).
var drop_check: Callable
var reduced_motion := false
var model: Dictionary = {}
var ice_ref: Dictionary = {}

@onready var console: Panel = $Console
@onready var portrait_frame: Panel = $Expression/PortraitFrame
@onready var portrait: TextureRect = $Expression/PortraitFrame/Portrait
@onready var placeholder: Label = $Expression/PortraitFrame/Placeholder
@onready var nameplate: Panel = $Identity/Nameplate
@onready var name_label: Label = $Identity/Nameplate/Name
@onready var type_badge: IceBadge = $Identity/TypeBadge
@onready var str_badge: IceBadge = $Identity/StrBadge
@onready var status: HBoxContainer = $Status
@onready var power: Control = $Status/Power
var _power_on := true
@onready var passive_chip: Button = $Status/Passive
@onready var notes: Label = $Status/Notes
@onready var band: Panel = $Controls
@onready var bank: HBoxContainer = $Controls/Bank

var _keys := {}          # sub -> SubroutineKey (active bank)
var _art_cache := {}
var _art_key := ""

func setup(l: IcePanelLayout, insp: KeyInspector) -> void:
	layout = l
	inspector = insp
	if is_node_ready(): _apply_layout()

func _ready() -> void:
	if layout == null: layout = IcePanelLayout.load_default()
	_apply_layout()
	for b in [type_badge, str_badge]:
		b.inspect_requested.connect(_inspect_badge)
		b.inspect_ended.connect(func(x): if is_instance_valid(inspector): inspector.close(x))
	power.draw.connect(func():
		var c := power.size / 2.0
		power.draw_circle(c, 10.0, VasTokens.CHROME_LO)
		power.draw_circle(c, 7.5, VasTokens.LAMP_ON if _power_on else VasTokens.LAMP_OFF)
		if _power_on: power.draw_circle(c - Vector2(2, 2), 2.5, Color(1, 1, 1, 0.7)))
	passive_chip.text = ""
	passive_chip.icon = IceKey.art("ICON_PASSIVE")
	passive_chip.expand_icon = true
	passive_chip.mouse_entered.connect(_inspect_passive)
	passive_chip.focus_entered.connect(_inspect_passive)
	passive_chip.mouse_exited.connect(func(): if is_instance_valid(inspector) and not passive_chip.has_focus(): inspector.close(passive_chip))
	passive_chip.focus_exited.connect(func(): if is_instance_valid(inspector): inspector.close(passive_chip))

func _apply_layout() -> void:
	var L := layout
	custom_minimum_size = L.panel_size
	size = L.panel_size
	console.position = Vector2.ZERO
	console.size = L.panel_size
	console.add_theme_stylebox_override("panel", _console_style())
	portrait_frame.position = L.portrait_rect.position
	portrait_frame.size = L.portrait_rect.size
	portrait_frame.add_theme_stylebox_override("panel", _frame_style())
	portrait_frame.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
	for n in [portrait, placeholder]:
		n.position = Vector2(6, 6); n.size = L.portrait_rect.size - Vector2(12, 12)
	nameplate.position = L.nameplate_rect.position
	nameplate.size = L.nameplate_rect.size
	nameplate.add_theme_stylebox_override("panel", _plate_style())
	name_label.position = Vector2(14, 0)
	name_label.size = Vector2(L.nameplate_rect.size.x - 28 - L.str_badge_size * 0.45, L.nameplate_rect.size.y)
	name_label.add_theme_font_override("font", VasTokens.FONT_PLAQUE)
	name_label.add_theme_color_override("font_color", VasTokens.PLAQUE_INK)
	status.position = L.status_rect.position
	status.size = L.status_rect.size
	band.position = L.bank_rect.position
	band.size = L.bank_rect.size
	band.add_theme_stylebox_override("panel", _band_style())
	bank.position = Vector2.ZERO
	bank.size = L.bank_rect.size

func set_model(m: Dictionary) -> void:
	model = m
	ice_ref = m.ref
	if not is_node_ready():
		push_error("IcePanel.set_model before the panel is in the tree")
		return
	var L := layout
	# Identity
	name_label.text = String(m.name)
	var fs := L.name_font_size
	while fs > 14 and VasTokens.FONT_PLAQUE.get_string_size(name_label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x > name_label.size.x: fs -= 1
	name_label.add_theme_font_size_override("font_size", fs)
	type_badge.set_badge("type", String(m.type), 0, 0, L.type_icons.get(String(m.type)), L.type_badge_size)
	type_badge.position = L.portrait_rect.position - Vector2(L.type_badge_size, L.type_badge_size) / 2.0 + L.type_badge_offset
	str_badge.set_badge("str", String(m.type), int(m.str), int(m.str_delta), L.str_icon, L.str_badge_size)
	str_badge.position = Vector2(L.nameplate_rect.end.x, L.nameplate_rect.position.y) - Vector2(L.str_badge_size, L.str_badge_size) / 2.0 + L.str_badge_offset
	# Virtual expression
	_set_portrait(String(m.id), String(m.mood))
	portrait.modulate = Color(0.55, 0.55, 0.55) if m.breached else Color.WHITE
	# Persistent status: power, plus only what isn't on the keys.
	_power_on = not m.breached
	power.queue_redraw()
	passive_chip.visible = String(m.passive) != ""
	var extra := []
	if m.zeroed: extra.append("ZEROED")
	notes.text = "  ".join(extra)
	notes.visible = not extra.is_empty()
	# Tactical controls
	_build_bank(m)

func _build_bank(m: Dictionary) -> void:
	var L := layout
	var wanted := []
	for k in m.keys: wanted.append(int(k.sub))
	var reuse: bool = wanted == _keys.keys() and bank.get_child_count() > 0 and m.pool.is_empty() and int(m.hidden_pool) == 0 and not _has_pool()
	if reuse:
		for k in m.keys: _keys[int(k.sub)].set_model(k, _unit(m))
		return
	var focused_sub := -1
	for s in _keys:
		if is_instance_valid(_keys[s]) and _keys[s].has_focus(): focused_sub = s
	for c in bank.get_children():
		bank.remove_child(c); c.queue_free()
	_keys.clear()
	var unit := _unit(m)
	for n in m.keys.size():
		if n > 0: bank.add_child(_chevron(unit))
		var key := SubroutineKey.new()
		key.name = "Key_S%d" % (int(m.keys[n].sub) + 1)
		key.set_model(m.keys[n], unit)
		key.drop_check = func(sub: int, uid: int) -> Dictionary: return drop_check.call(ice_ref, sub, uid) if drop_check.is_valid() else {"ok": false}
		key.break_requested.connect(func(r, s, u): break_requested.emit(r, s, u))
		key.inspect_requested.connect(func(k): if is_instance_valid(inspector): inspector.show_key(k, String(model.name)))
		key.inspect_ended.connect(func(k): if is_instance_valid(inspector): inspector.close(k))
		bank.add_child(key)
		_keys[int(m.keys[n].sub)] = key
	if not m.pool.is_empty() or int(m.hidden_pool) > 0:
		var gap := Control.new(); gap.custom_minimum_size.x = L.pool_gap; gap.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bank.add_child(gap)
		bank.add_child(_reel(m))
	if focused_sub >= 0 and _keys.has(focused_sub): _keys[focused_sub].grab_focus.call_deferred()

func _has_pool() -> bool:
	for c in bank.get_children():
		if c.name == "Reel": return true
	return false

func _unit(m: Dictionary) -> float:
	# Keys stay as large as the band allows (≥ 1.0 = 60 px caps, above the 44 px minimum target).
	var L := layout
	var n: int = m.keys.size()
	var pool_w := 0.0
	if not m.pool.is_empty() or int(m.hidden_pool) > 0: pool_w = L.pool_gap + 2 * 30 + 3 + 22
	var room := L.bank_rect.size.x - 28.0 - pool_w - maxf(0, n - 1) * L.chevron_width
	var fit := room / maxf(1.0, n * (IceKey.KEY + 8.0))
	return clampf(minf(L.key_unit, fit), 1.0, L.key_unit)

func _reel(m: Dictionary) -> Control:
	## Build 12 TUMBLER reel: spent/seen subroutines as small keys, unseen ones as "?".
	var reel := PanelContainer.new(); reel.name = "Reel"
	var st := StyleBoxFlat.new(); st.bg_color = Color("#141210"); st.border_color = VasTokens.CHROME_LO
	st.set_border_width_all(3); st.set_corner_radius_all(10); st.set_content_margin_all(6)
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
	var c := Control.new(); c.name = "Order"
	c.custom_minimum_size = Vector2(layout.chevron_width, (IceKey.KEY + IceKey.LAMP_H + IceKey.CHIP_H + 4.0) * unit)
	c.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	c.draw.connect(func():
		var mid := Vector2(c.size.x / 2.0, IceKey.LAMP_H * unit + IceKey.KEY * unit / 2.0)
		var w := c.size.x * 0.32
		c.draw_colored_polygon(PackedVector2Array([mid + Vector2(-w, -w * 1.2), mid + Vector2(w, 0), mid + Vector2(-w, w * 1.2)]), VasTokens.SEAFOAM_INK))
	return c

func key(sub: int) -> SubroutineKey:
	return _keys.get(sub)

func keys() -> Array:
	return _keys.values()

func _set_portrait(id: String, mood: String) -> void:
	var art_mood := "lethal" if mood == "lethal" else ("wary" if mood in ["wary", "knocked_out"] else "cheery")
	var path := layout.portrait_pattern % [id, art_mood]
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

# ----- Drawn fallbacks (replaced by layout textures when final art lands).

func _console_style() -> StyleBox:
	if layout.console_texture:
		var t := StyleBoxTexture.new(); t.texture = layout.console_texture
		t.texture_margin_left = layout.console_margins.x; t.texture_margin_top = layout.console_margins.y
		t.texture_margin_right = layout.console_margins.z; t.texture_margin_bottom = layout.console_margins.w
		return t
	var s := StyleBoxFlat.new()
	s.bg_color = VasTokens.SEAFOAM
	s.border_color = VasTokens.CHROME_HI
	s.set_border_width_all(layout.rim_width)
	s.set_corner_radius_all(layout.corner_radius)
	s.shadow_color = Color(0, 0, 0, 0.5); s.shadow_size = 10; s.shadow_offset = Vector2(0, 6)
	s.anti_aliasing = true
	return s

func _frame_style() -> StyleBox:
	if layout.portrait_frame_texture:
		var t := StyleBoxTexture.new(); t.texture = layout.portrait_frame_texture; return t
	var s := StyleBoxFlat.new()
	s.bg_color = Color("#CFE7DE")
	s.border_color = VasTokens.CHROME_LO
	s.set_border_width_all(6)
	s.set_corner_radius_all(layout.portrait_radius)
	return s

func _plate_style() -> StyleBox:
	var s := StyleBoxFlat.new()
	s.bg_color = VasTokens.PLAQUE
	s.border_color = VasTokens.CHROME_LO
	s.set_border_width_all(4)
	s.set_corner_radius_all(12)
	s.shadow_color = Color(0, 0, 0, 0.35); s.shadow_size = 4; s.shadow_offset = Vector2(0, 3)
	return s

func _band_style() -> StyleBox:
	var s := StyleBoxFlat.new()
	s.bg_color = VasTokens.SEAFOAM_DEEP
	s.border_color = Color("#2F5E52")
	s.set_border_width_all(3)
	s.set_corner_radius_all(18)
	s.content_margin_left = 14; s.content_margin_right = 14
	return s
