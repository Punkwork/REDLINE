class_name ChoiceOverlay
extends Control
## CAS-001 C15 (ARCH-V2-004, Batch 2; PROPOSED): the physical-console modal for a pending choice.
## Dims the console, shows a plaque with the choice's name and its existing wording, and the valid
## candidates as cards (cyan when selected). Supports the Game's choice variants, not only discard:
## READY RIG (with skip), DISCARD, GARBAGE COLLECT, TAIL CALL, UNINSTALLER, FIELD KIT, CACHE, SCAN
## (multi-select + finish), CULL (strain buttons + finish). card_break is chosen on the keys and
## never opens this. Emits intent only; legality stays with Game. Never auto-commits on rebuild.

signal chosen(uid: int)
signal secondary(intent: String)
signal strain(name: String)

var inspector: KeyInspector
var spec: Dictionary = {}
var _cards: Array[CardView] = []
var _panel: PanelContainer
## C08 (#15): "peek" hides the plaque and the dimming so the board can be looked at (and hovered)
## while a choice is pending; a BACK TO CHOICE button brings it back. Kept across rebuilds of the
## same choice. View-only specs (spec.view) are used for the pile viewers (C09) and have no peek.
var peek := false
var _back: Button

func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP   # modal: the console underneath takes no clicks
	hide()

## spec: {kind, title, text, cards: [card models], selected: [uids], secondary: {label, intent},
## strains: [{name, n}], options: [{label, intent}]}. Empty spec closes the overlay. `options` are plain
## buttons that emit `secondary(intent)`, e.g. Cancel. An option with `art` is a ModeKey instead
## (PROBE-004a modes, ARCH-V2-003 / HOVER-001): icon and number on the key, words only in the
## inspector on hover or focus, beside the large card (`picture`, a card model).
func open(s: Dictionary) -> void:
	var same: bool = not spec.is_empty() and spec.get("kind") == s.get("kind") and _uids(spec) == _uids(s)
	var same_kind: bool = not spec.is_empty() and spec.get("kind") == s.get("kind")
	spec = s
	if s.is_empty():
		peek = false
		hide(); _clear(); return
	if not same_kind:
		peek = false
		if is_instance_valid(inspector): inspector.clear()   # UI-INSPECTOR-001: a modal opening clears it
	var keep_focus := -1
	for c in _cards:
		if is_instance_valid(c) and c.has_focus(): keep_focus = c.uid()
	_clear()
	_build()
	show()
	_apply_peek()
	if peek: return
	var target: Control = null
	for c in _cards:
		if c.uid() == keep_focus: target = c
	if target == null and not _cards.is_empty() and not same: target = _cards[0]
	if target is CardView: (target as CardView).quiet_focus = true
	if target: (func(): if is_instance_valid(target) and target.is_inside_tree() and target.is_visible_in_tree(): target.grab_focus()).call_deferred()

func cards() -> Array[CardView]:
	return _cards

func _uids(s: Dictionary) -> Array:
	return s.get("cards", []).map(func(m): return int(m.uid))

func _clear() -> void:
	_cards.clear()
	for c in get_children(): remove_child(c); c.queue_free()

func _draw() -> void:
	if visible and not peek: draw_rect(Rect2(Vector2.ZERO, size), Color(0.05, 0.03, 0.02, 0.72))

func set_peek(on: bool) -> void:
	peek = on and not bool(spec.get("view", false))
	_apply_peek()

func _apply_peek() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE if peek else Control.MOUSE_FILTER_STOP
	if is_instance_valid(_panel): _panel.visible = not peek
	if is_instance_valid(_back):
		_back.visible = peek
		if peek: (func(): if is_instance_valid(_back) and _back.is_visible_in_tree(): _back.grab_focus()).call_deferred()
	queue_redraw()

func _build() -> void:
	queue_redraw()
	_panel = PanelContainer.new(); _panel.name = "Plaque"
	var sb := StyleBoxFlat.new(); sb.bg_color = Color("#1E1510"); sb.border_color = Color("#B07A44")
	sb.set_border_width_all(4); sb.set_corner_radius_all(22); sb.set_content_margin_all(26); sb.anti_aliasing = true
	sb.shadow_color = Color(0, 0, 0, 0.6); sb.shadow_size = 18
	_panel.add_theme_stylebox_override("panel", sb)
	add_child(_panel)
	var v := VBoxContainer.new(); v.add_theme_constant_override("separation", 14); _panel.add_child(v)
	var t := Label.new(); t.text = String(spec.get("title", "")); t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	t.add_theme_font_override("font", VasTokens.FONT_PLAQUE); t.add_theme_font_size_override("font_size", 38)
	t.add_theme_color_override("font_color", VasTokens.AMBER); v.add_child(t)
	var d := Label.new(); d.text = String(spec.get("text", "")); d.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; d.custom_minimum_size.x = 560
	d.add_theme_font_override("font", VasTokens.FONT_RULES); d.add_theme_font_size_override("font_size", 17)
	d.add_theme_color_override("font_color", VasTokens.IVORY); v.add_child(d)
	var models: Array = spec.get("cards", [])
	if not models.is_empty():
		# One or two rows; cards shrink only when there are many (12-card hands).
		var per_row := mini(models.size(), 7)
		var rows := ceili(float(models.size()) / per_row)
		var k := clampf(minf(1180.0 / (per_row * (CardView.BASE.x + 14.0)), (560.0 / rows) / (CardView.BASE.y + 14.0)), 0.6, 1.25)
		var grid := GridContainer.new(); grid.columns = per_row
		grid.add_theme_constant_override("h_separation", 14); grid.add_theme_constant_override("v_separation", 14)
		var cc := CenterContainer.new(); cc.add_child(grid); v.add_child(cc)
		var sel: Array = spec.get("selected", [])
		for m in models:
			var cv := CardView.new(); cv.inspector = inspector
			cv.custom_minimum_size = CardView.BASE * k
			var mm: Dictionary = m.duplicate(); mm.playable = true
			cv.set_model(mm)
			cv.draggable = false
			cv.selected = sel.has(int(m.uid))
			cv.pressed.connect(func(u): chosen.emit(u))
			grid.add_child(cv)
			_cards.append(cv)
	var strains: Array = spec.get("strains", [])
	var buttons := HBoxContainer.new(); buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	buttons.add_theme_constant_override("separation", 12)
	for st in strains:
		var name := String(st.name)
		buttons.add_child(_button("%s (%d)" % [name, int(st.n)], func(): strain.emit(name)))
	var keys := HBoxContainer.new(); keys.alignment = BoxContainer.ALIGNMENT_CENTER
	keys.add_theme_constant_override("separation", 28)
	for o in spec.get("options", []):
		var oi := String(o.intent)
		if o.has("art"):
			var mk := ModeKey.new(); mk.name = "Option_" + oi.replace(":", "_")
			mk.setup(o, inspector)
			mk.pressed.connect(func(): secondary.emit(oi))
			keys.add_child(mk)
			continue
		var ob := _button(String(o.label), func(): secondary.emit(oi)); ob.name = "Option_" + oi.replace(":", "_")
		buttons.add_child(ob)
	if keys.get_child_count() > 0: v.add_child(keys)
	var sec: Dictionary = spec.get("secondary", {})
	if not sec.is_empty():
		var intent := String(sec.intent)
		buttons.add_child(_button(String(sec.label), func(): secondary.emit(intent)))
	if not bool(spec.get("view", false)):
		var sb_btn := _button("SHOW BOARD", func(): set_peek(true)); sb_btn.name = "ShowBoard"
		buttons.add_child(sb_btn)
	if buttons.get_child_count() > 0: v.add_child(buttons)
	_panel.reset_size()
	_panel.position = (size - _panel.get_combined_minimum_size()) / 2.0
	if not bool(spec.get("view", false)):
		_back = _button("BACK TO %s" % String(spec.get("title", "CHOICE")), func(): set_peek(false)); _back.name = "BackToChoice"
		add_child(_back)
		_back.reset_size()
		_back.position = Vector2((size.x - _back.get_combined_minimum_size().x) / 2.0, 108)
		_back.visible = false

func _button(text: String, cb: Callable) -> Button:
	var b := Button.new(); b.text = text; b.custom_minimum_size = Vector2(0, 48)
	b.add_theme_font_override("font", VasTokens.FONT_PLAQUE_SEMI); b.add_theme_font_size_override("font_size", 20)
	for st in ["normal", "hover", "pressed", "focus"]:
		var s := StyleBoxFlat.new(); s.set_corner_radius_all(10); s.set_content_margin_all(12); s.anti_aliasing = true
		s.bg_color = Color("#3A2A1E") if st != "hover" else Color("#4E3826"); s.border_color = VasTokens.FOCUS if st == "focus" else Color("#B07A44")
		s.set_border_width_all(3 if st == "focus" else 2)
		if st == "focus": s.draw_center = false
		b.add_theme_stylebox_override(st, s)
	b.add_theme_color_override("font_color", VasTokens.IVORY)
	b.pressed.connect(cb)
	return b

## PROBE-004a mode key (ARCH-V2-003: icons communicate, numbers quantify, hover panels explain).
## The face carries only the mode's icon and number; hover or keyboard focus opens the shared
## inspector with the large card beside the mode's words (HOVER-001). Enter/Space or click chooses.
class ModeKey extends Button:
	const SIZE := Vector2(132, 132)
	var art: Texture2D
	var value := ""
	var label := ""
	var inspect: Dictionary = {}
	var picture: Dictionary = {}
	var inspector: KeyInspector
	var inside := false   # the number sits in the icon (the STR medallion, as on the ICE's STR badge)
	func setup(o: Dictionary, insp: KeyInspector) -> void:
		inspector = insp
		label = String(o.label)
		value = String(o.get("value", ""))
		var a := String(o.art)
		art = IceKey.art(a) if a.begins_with("ICON_") else V2Art.tex(a, SIZE.x)   # key icons or V2 medallions
		inside = bool(o.get("value_inside", false))
		inspect = o.get("inspect", {})
		picture = o.get("picture", {})
		text = ""
		custom_minimum_size = SIZE
		focus_mode = Control.FOCUS_ALL
		tooltip_text = ""
		for st in ["normal", "hover", "pressed", "focus"]:
			var s := StyleBoxFlat.new(); s.set_corner_radius_all(18); s.anti_aliasing = true
			s.bg_color = Color("#2A1E16") if st == "normal" else Color("#3E2C1E")
			s.border_color = VasTokens.FOCUS if st in ["focus", "hover"] else Color("#B07A44")
			s.set_border_width_all(4 if st in ["focus", "hover"] else 2)
			if st == "focus": s.draw_center = false
			add_theme_stylebox_override(st, s)
		mouse_entered.connect(_inspect)
		focus_entered.connect(_inspect)
		mouse_exited.connect(func(): if not has_focus() and is_instance_valid(inspector): inspector.close(self))
		focus_exited.connect(func(): if is_instance_valid(inspector): inspector.close(self))
	func _inspect() -> void:
		## UI-INSPECTOR-001: the shared inspector with the card's content contract for this mode.
		if not is_instance_valid(inspector): return
		var m: Dictionary = picture.duplicate(); m.playable = true
		inspector.show_object(self, inspector.card_art(m), String(inspect.get("title", label)), String(inspect.get("classification", "")),
			String(inspect.get("cost", "")), inspect.get("effects", [label]), inspect.get("restrictions", []), String(inspect.get("flavour", "")))
	func _draw() -> void:
		var c := size / 2.0
		var lift := 0.0 if inside else 12.0
		if art:
			var d := minf(size.x, size.y) * (0.78 if inside else 0.58)
			draw_texture_rect(art, Rect2(c - Vector2(d, d) / 2.0 - Vector2(0, lift), Vector2(d, d)), false)
		if value != "":
			var f := VasTokens.FONT_READOUT
			var px := 36
			var w := f.get_string_size(value, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
			var pos := Vector2(c.x - w / 2.0, c.y + px * 0.36) if inside else Vector2(c.x - w / 2.0, size.y - 14.0)
			draw_string_outline(f, pos, value, HORIZONTAL_ALIGNMENT_LEFT, -1, px, 8, Color("#0A0807"))
			draw_string(f, pos, value, HORIZONTAL_ALIGNMENT_LEFT, -1, px, VasTokens.IVORY)
