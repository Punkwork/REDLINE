class_name KeyInspector
extends PanelContainer
## CAS-001 C16 slice (ARCH-V2-003): the hover/focus panel that explains. Keys and badges only show
## icons and numbers; this panel carries the full rule in words (Build 12 HOVER-001: the key drawn
## large beside its rule, one row per effect). Opens identically for mouse hover and keyboard focus.
## Hidden subroutines show only "? HIDDEN / Revealed when it fires." (the adapter supplies nothing more).

const MAX_W := 420.0
var _image: CenterContainer
var _list: VBoxContainer
var anchor := Rect2()
var subject: Variant = null   # what it currently explains (a SubroutineKey or a badge Control)

func _init() -> void:
	name = "KeyInspector"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 200
	top_level = true
	var st := StyleBoxFlat.new()
	st.bg_color = VasTokens.IVORY
	st.border_color = VasTokens.CHROME_LO
	st.set_border_width_all(3)
	st.set_corner_radius_all(14)
	st.set_content_margin_all(14)
	st.shadow_color = Color(0, 0, 0, 0.45); st.shadow_size = 12; st.shadow_offset = Vector2(0, 6)
	add_theme_stylebox_override("panel", st)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(row)
	_image = CenterContainer.new(); _image.name = "Image"; _image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(_image)
	_list = VBoxContainer.new(); _list.name = "Words"; _list.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_list.add_theme_constant_override("separation", 5)
	row.add_child(_list)
	hide()

func show_key(key: SubroutineKey, ice_name: String) -> void:
	_clear()
	subject = key
	var m := key.model
	var big := LitKey.new()   # ARCH-V2-003r: the inspector shows the same lit button
	big.configure(String(m.kind), String(m.value), String(m.state), String(m.cost_text), false, 2.0)
	big.badge = String(m.get("badge", "")); big.extra = int(m.get("extra", 0)); big.locked = bool(m.get("locked", false))
	big.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_image.add_child(big); _image.show()
	_line("%s  ·  %s" % [String(m.get("place", "")), ice_name], 13, Color("#5E4B35"), VasTokens.FONT_PLAQUE_SEMI)
	_line(String(m.title), 24, VasTokens.SEAFOAM_INK, VasTokens.FONT_PLAQUE)
	for r in m.rules:
		_rule(String(r.kind), String(r.text))
	if not m.get("mini", false) and m.state != "broken" and m.kind != "HIDDEN":
		var why := String(m.get("reason", ""))
		if why.ends_with(" BW"): why = "needs " + why
		var cost := ("Break: %s" % m.cost_text) if m.get("breakable", false) else ("Can't break now" + (": " + why if why != "" else "."))
		_line(cost, 14, Color("#5E4B35"), VasTokens.FONT_RULES)
	_place(key.get_global_rect())

func show_info(heading: String, title: String, lines: Array, at: Rect2, who: Variant = null) -> void:
	_clear()
	subject = who
	_image.hide()
	if heading != "": _line(heading, 13, Color("#5E4B35"), VasTokens.FONT_PLAQUE_SEMI)
	var t := _line(title, 24, VasTokens.SEAFOAM_INK, VasTokens.FONT_PLAQUE)
	if lines.is_empty() and heading == "":
		# A one-line answer (ICE type, ICE STRENGTH) sizes to its words.
		t.custom_minimum_size.x = 0
		t.autowrap_mode = TextServer.AUTOWRAP_OFF
	for l in lines: _rule("", String(l))
	_place(at)

func close(who: Variant = null) -> void:
	if who != null and not is_same(who, subject): return
	subject = null
	hide()

func _clear() -> void:
	for c in _image.get_children(): c.queue_free(); _image.remove_child(c)
	for c in _list.get_children(): c.queue_free(); _list.remove_child(c)

func _line(text: String, px: int, col: Color, font: Font) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_override("font", font)
	l.add_theme_font_size_override("font_size", px)
	l.add_theme_color_override("font_color", col)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size.x = 260
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_list.add_child(l)
	return l

func _rule(kind: String, text: String) -> void:
	var row := HBoxContainer.new(); row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", 8)
	var tex: Texture2D = IceKey.art("ICON_" + kind) if kind != "" else null
	if tex:
		var icon := TextureRect.new(); icon.texture = tex; icon.custom_minimum_size = Vector2(22, 22)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(icon)
	var l := Label.new(); l.text = text; l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size.x = 260; l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	l.add_theme_font_override("font", VasTokens.FONT_RULES); l.add_theme_font_size_override("font_size", 16)
	l.add_theme_color_override("font_color", Color("#1E1810")); l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(l)
	_list.add_child(row)

func _place(at: Rect2) -> void:
	anchor = at
	reset_size()
	show()
	var vp := get_viewport_rect().size
	var s := get_combined_minimum_size()
	size = s
	# Prefer above the subject so the key, its neighbours and the hand stay visible; else below.
	var pos := Vector2(at.get_center().x - s.x / 2.0, at.position.y - s.y - 10.0)
	if pos.y < 8.0: pos.y = at.end.y + 10.0
	pos.x = clampf(pos.x, 8.0, vp.x - s.x - 8.0)
	pos.y = clampf(pos.y, 8.0, vp.y - s.y - 8.0)
	global_position = pos
