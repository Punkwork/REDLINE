class_name ResponseRail
extends Control
## CAS-001 C14, PROVISIONAL (designer 2026-11-26: one shared NEXT RESPONSE rail; final presentation
## under visual review). Sits in the black glass channel of the painted rail housing. One capsule
## per subroutine that will fire, in firing order: the effect's icon and its number (icon-first,
## VAS-ASSET-001 §2a), no words. Each ICE's run starts with its small type medallion; brass chevrons
## between steps. Broken subroutines are left out; hidden ones show "?" only. During the Corporation
## Response the firing capsule is backlit amber and fired ones dim (VAS-001 §8). Hover/focus names the
## step. Never advances rules itself.

var inspector: KeyInspector
var height := 40.0
var _row: HBoxContainer
var _items: Array = []

func _init() -> void:
	name = "ResponseRail"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_row = HBoxContainer.new(); _row.name = "Steps"
	_row.add_theme_constant_override("separation", 6)
	_row.alignment = BoxContainer.ALIGNMENT_CENTER
	_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_row)
	resized.connect(func(): _row.size = size; _row.position = Vector2.ZERO)

func steps() -> Array:
	return _items.duplicate()

func sync(model: Array) -> void:
	for c in _row.get_children():
		_row.remove_child(c); c.queue_free()
	_items.clear()
	_row.size = size
	var last_ice: Variant = null
	for n in model.size():
		var st: Dictionary = model[n]
		if last_ice == null or not is_same(last_ice, st.ref):
			if last_ice != null: _row.add_child(_spacer(14))
			_row.add_child(_medallion(String(st.get("ice_type", ""))))
			last_ice = st.ref
		elif n > 0:
			_row.add_child(_arrow())
		var cap := RailCapsule.new()
		cap.setup(st, n + 1, height)
		cap.inspect_requested.connect(func(c): if is_instance_valid(inspector): inspector.show_info("RESPONSE STEP %d · %s" % [c.step, String(c.model.ice_name)], String(c.model.title), [], c.get_global_rect(), c))
		cap.inspect_ended.connect(func(c): if is_instance_valid(inspector): inspector.close(c))
		_row.add_child(cap)
		_items.append(cap)

func _medallion(t: String) -> Control:
	var r := TextureRect.new()
	r.texture = V2Art.tex("ice/V2_MEDALLION_%s.png" % t, height * 0.8) if t != "" else null
	r.custom_minimum_size = Vector2(height * 0.8, height * 0.8)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	r.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r

func _arrow() -> Control:
	var r := TextureRect.new()
	r.texture = V2Art.tex("controls/V2_RAIL_ARROW.png", 12)
	r.custom_minimum_size = Vector2(12, height * 0.5)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	r.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r

func _spacer(w: float) -> Control:
	var c := Control.new(); c.custom_minimum_size.x = w; c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c

## One response step: painted black-glass capsule, effect icon, number. Amber backlight while firing.
class RailCapsule extends Control:
	signal inspect_requested(c)
	signal inspect_ended(c)
	var model: Dictionary
	var step := 0
	var state := "waiting"
	var _cap: Texture2D
	var _icon: Texture2D

	func setup(st: Dictionary, n: int, h: float) -> void:
		model = st; step = n; state = String(st.state)
		var w := h * 2.1
		custom_minimum_size = Vector2(w, h)
		size_flags_vertical = Control.SIZE_SHRINK_CENTER
		focus_mode = Control.FOCUS_ALL
		mouse_filter = Control.MOUSE_FILTER_STOP
		mouse_default_cursor_shape = Control.CURSOR_HELP
		_cap = V2Art.tex("controls/V2_RAIL_CAPSULE.png", w)
		var kind := String(st.kind)
		_icon = IceKey.art("ICON_%s_LIGHT" % kind)
		if _icon == null: _icon = IceKey.art("ICON_%s" % kind)
		set_meta("rail_state", state)
		modulate = Color(1, 1, 1, 0.4) if state == "fired" else Color.WHITE
		mouse_entered.connect(func(): inspect_requested.emit(self))
		focus_entered.connect(func(): inspect_requested.emit(self))
		mouse_exited.connect(func(): if not has_focus(): inspect_ended.emit(self))
		focus_exited.connect(func(): inspect_ended.emit(self))

	func _draw() -> void:
		var r := Rect2(Vector2.ZERO, size)
		if state == "firing":
			var glow := StyleBoxFlat.new()
			glow.bg_color = Color(VasTokens.AMBER, 0.9); glow.set_corner_radius_all(int(size.y / 2))
			glow.shadow_color = Color(VasTokens.AMBER, 0.6); glow.shadow_size = 10
			draw_style_box(glow, r.grow(-2))
		if _cap: draw_texture_rect(_cap, r, false, Color(1, 1, 1, 0.55) if state == "firing" else Color.WHITE)
		var ih := size.y * 0.58
		var x := size.x * 0.16
		if _icon:
			draw_texture_rect(_icon, Rect2(Vector2(x, (size.y - ih) / 2.0), Vector2(ih, ih)), false, VasTokens.IVORY)
		elif not bool(model.get("hidden", false)):
			# No icon art for this effect yet (e.g. HARDEN): the same short code the key shows.
			var code := String(model.kind).substr(0, 2)
			draw_string(VasTokens.FONT_PLAQUE, Vector2(x, size.y / 2.0 + size.y * 0.16), code, HORIZONTAL_ALIGNMENT_LEFT, -1, int(size.y * 0.42), Color(VasTokens.IVORY, 0.75))
		var text := "?" if bool(model.get("hidden", false)) else String(model.value)
		if int(model.get("extra", 0)) > 0: text += " +%d" % int(model.extra)
		if text != "":
			var font := VasTokens.FONT_PLAQUE
			var px := int(size.y * 0.55)
			var ink := VasTokens.CHASSIS if state == "firing" else VasTokens.IVORY
			draw_string(font, Vector2(x + ih + size.y * 0.15, size.y / 2.0 + px * 0.36), text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, ink)
		if has_focus():
			var f := StyleBoxFlat.new(); f.draw_center = false; f.set_border_width_all(2); f.border_color = VasTokens.FOCUS
			f.set_corner_radius_all(int(size.y / 2)); draw_style_box(f, r.grow(2))
