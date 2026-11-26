class_name ResponseRail
extends PanelContainer
## CAS-001 C14, PROVISIONAL (designer 2026-11-26: shared NEXT RESPONSE rail; final presentation under
## visual review). One rail for the whole Corporation Response, in firing order: a compact key per
## subroutine that will fire (icon + number), grouped by ICE, chevrons between. Broken subroutines are
## left out; hidden ones show "?" only. During a response the firing step glows and fired steps dim,
## following the controller's step/finish calls (VAS-001 §8); the rail never advances rules itself.
## Nothing here repeats under the ICE panels.

var inspector: KeyInspector
var unit := 0.62
var _row: HBoxContainer
var _title: Label
var _empty: Label

func _init() -> void:
	name = "ResponseRail"
	mouse_filter = Control.MOUSE_FILTER_PASS
	var st := StyleBoxFlat.new()
	st.bg_color = VasTokens.CHASSIS
	st.border_color = VasTokens.BRONZE
	st.set_border_width_all(4)
	st.set_corner_radius_all(14)
	st.content_margin_left = 16; st.content_margin_right = 16; st.content_margin_top = 6; st.content_margin_bottom = 6
	add_theme_stylebox_override("panel", st)
	var row := HBoxContainer.new(); row.add_theme_constant_override("separation", 14); row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(row)
	_title = Label.new(); _title.name = "Title"; _title.text = "NEXT\nRESPONSE"
	_title.add_theme_font_override("font", VasTokens.FONT_PLAQUE)
	_title.add_theme_font_size_override("font_size", 17)
	_title.add_theme_color_override("font_color", VasTokens.AMBER)
	_title.add_theme_constant_override("line_spacing", -4)
	_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.add_child(_title)
	_row = HBoxContainer.new(); _row.name = "Steps"; _row.add_theme_constant_override("separation", 4)
	_row.mouse_filter = Control.MOUSE_FILTER_IGNORE; _row.alignment = BoxContainer.ALIGNMENT_BEGIN
	_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(_row)
	_empty = Label.new(); _empty.text = "—"; _empty.add_theme_color_override("font_color", VasTokens.IVORY)
	_empty.add_theme_font_override("font", VasTokens.FONT_PLAQUE); _empty.add_theme_font_size_override("font_size", 22)
	row.add_child(_empty)

func steps() -> Array:
	return _row.get_children().filter(func(c): return c is SubroutineKey)

func sync(model: Array) -> void:
	for c in _row.get_children():
		_row.remove_child(c); c.queue_free()
	_empty.visible = model.is_empty()
	var last_ice: Variant = null
	for n in model.size():
		var st: Dictionary = model[n]
		if last_ice == null or not is_same(last_ice, st.ref):
			if last_ice != null: _row.add_child(_divider())
			_row.add_child(_ice_tag(String(st.ice_name)))
			last_ice = st.ref
		elif n > 0:
			_row.add_child(_arrow())
		var k := SubroutineKey.new()
		k.focus_mode = Control.FOCUS_ALL
		k.mouse_default_cursor_shape = Control.CURSOR_HELP
		k.set_model({"ref": st.ref, "sub": st.sub, "mini": false, "kind": st.kind, "value": st.value, "badge": st.badge,
			"extra": st.extra, "state": "hidden" if st.hidden else "ready",
			"cost_text": "", "firing": st.state == "firing", "title": st.title,
			"rules": [{"kind": "HIDDEN", "text": VisibleStateAdapter.HIDDEN_RULE}] if st.hidden else [],
			"place": "RESPONSE %d" % (n + 1)}, unit)
		k.custom_minimum_size.y = (IceKey.KEY + IceKey.LAMP_H) * unit
		k.set_meta("rail_state", st.state)
		# Fired steps dim (they are spent, not broken by the Rustler); the firing step keeps full light.
		if st.state == "fired": k.modulate = Color(1, 1, 1, 0.38)
		# The rail explains only order and identity; the ICE's own key carries the full rule.
		k.inspect_requested.connect(func(key): if is_instance_valid(inspector): inspector.show_info("RESPONSE STEP %d · %s" % [n + 1, String(st.ice_name)], String(st.title), [], key.get_global_rect(), key))
		k.inspect_ended.connect(func(key): if is_instance_valid(inspector): inspector.close(key))
		_row.add_child(k)

func _ice_tag(text: String) -> Label:
	var l := Label.new(); l.text = text
	l.add_theme_font_override("font", VasTokens.FONT_PLAQUE_SEMI)
	l.add_theme_font_size_override("font_size", 15)
	l.add_theme_color_override("font_color", VasTokens.IVORY)
	l.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return l

func _arrow() -> Control:
	var c := Control.new(); c.custom_minimum_size = Vector2(10, 20); c.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	c.draw.connect(func(): c.draw_colored_polygon(PackedVector2Array([Vector2(1, 4), Vector2(9, 10), Vector2(1, 16)]), VasTokens.COPPER))
	return c

func _divider() -> Control:
	var c := Control.new(); c.custom_minimum_size = Vector2(18, 44); c.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	c.draw.connect(func():
		c.draw_line(Vector2(9, 2), Vector2(9, 42), VasTokens.BRONZE, 2.0)
		c.draw_colored_polygon(PackedVector2Array([Vector2(3, 16), Vector2(15, 22), Vector2(3, 28)]), VasTokens.COPPER))
	return c
