extends Control
## VAS-001 / CAS-001 C07–C09. Isolated visual study with a seeded legacy Game.
## Run the scene directly. SHOT_DIR enables deterministic capture and checks.

const CONSOLE = preload("res://assets/concept/ui/UI_ICE_CONSOLE_2.png")
const BACKDROP = preload("res://assets/concept/ui/UI_BACKDROP_MACHINE.png")
const FONT = preload("res://assets/fonts/BarlowCondensed-Bold.ttf")
const RULE_FONT = preload("res://assets/fonts/DM-Sans.ttf")
const EFFECT_NAMES := {
	"PULP": "PULP", "DEADLOCK": "DEADLOCK", "TRACE": "TRACE",
	"HARDEN": "HARDEN STR", "BW_DRAIN": "BW drain", "DISCARD": "Discard"
}

var game: Game
var panel_limit := 2
var reverse_lane := false
var lane: HBoxContainer
var details: Label
var status: Label
var response: Label
var pick_button: Button
var pick_uid: int
var selected_row := ""
var rows := {}


func _ready() -> void:
	if get_parent() is Window and not OS.get_environment("SHOT_DIR").is_empty():
		capture.call_deferred()
		return
	game = Game.new(711)
	game.new_run()
	game.row = 0
	game.available = [0]
	game.enter_node(0)
	var starter: Array = game.draw_pile.filter(func(card: Dictionary) -> bool:
		return card.id == "FORTRESS_ICEPICK")
	pick_uid = int(starter[0].uid)
	game.choose_ready_rig(pick_uid)
	build()
	render_lane()


func build() -> void:
	var backdrop := TextureRect.new()
	backdrop.texture = BACKDROP
	backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var margin := MarginContainer.new()
	add_child(margin)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 28)
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 12)
	margin.add_child(stack)
	stack.add_child(plaque("PANOPTICON     /     HALCYON · CAPTCHA", 32))
	var toolbar := HBoxContainer.new()
	stack.add_child(toolbar)
	for count in range(1, 4):
		var button := Button.new()
		button.text = "%d ICE" % count
		button.pressed.connect(select_count.bind(count))
		toolbar.add_child(button)
	var reorder := Button.new()
	reorder.text = "Reverse display order"
	reorder.pressed.connect(toggle_order)
	toolbar.add_child(reorder)
	pick_button = Button.new()
	pick_button.text = "FORTRESS ICEPICK · drag to a slot"
	pick_button.set_drag_forwarding(get_pick_drag, Callable(), Callable())
	toolbar.add_child(pick_button)
	var probe := Button.new()
	probe.text = "Play PROBE on AUTO-RENEW"
	probe.pressed.connect(play_probe)
	toolbar.add_child(probe)
	var end_turn := Button.new()
	end_turn.text = "Resolve response"
	end_turn.pressed.connect(run_response)
	toolbar.add_child(end_turn)
	for child: Control in toolbar.get_children():
		child.custom_minimum_size.y = 44
	lane = HBoxContainer.new()
	lane.add_theme_constant_override("separation", 12)
	lane.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stack.add_child(lane)
	response = plaque("", 19)
	response.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stack.add_child(response)
	status = plaque("", 20)
	stack.add_child(status)
	details = plaque("Focus or hover a subroutine to inspect it.", 17)
	details.add_theme_font_override("font", RULE_FONT)
	details.custom_minimum_size.y = 62
	details.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	stack.add_child(details)


func select_count(count: int) -> void:
	panel_limit = count
	if count == 3 and game.enc.ice.size() == 2:
		# Exercise the actual Black ICE insertion without simulating multiple rounds.
		game.add_trace(40, false)
		game.add_trace(40, false)
	render_lane()


func toggle_order() -> void:
	reverse_lane = not reverse_lane
	render_lane()


func play_probe() -> void:
	var probe: Array = game.hand.filter(func(card: Dictionary) -> bool:
		return card.id == "PROBE")
	for index in game.enc.ice.size():
		if game.enc.ice[index].id == "AUTO_RENEW" and not probe.is_empty():
			if game.play_card(int(probe[0].uid), index):
				render_lane()
				status.text += "   ·   PROBE resolved"
				return
	status.text += "   ·   No playable PROBE in this hand"


func run_response() -> void:
	if game.phase != "PLAYER":
		return
	game.animate = false
	game.end_turn()
	if game.phase == "CHOICE" and game.pending.get("kind") == "discard" and not game.hand.is_empty():
		game.choose(int(game.hand[0].uid))
	render_lane()


func plaque(value: String, points: int) -> Label:
	var label := Label.new()
	label.text = value
	label.add_theme_font_override("font", FONT)
	label.add_theme_font_size_override("font_size", points)
	label.add_theme_color_override("font_color", Color("#fff1d9"))
	label.add_theme_stylebox_override("normal", plate(Color("#221811"), Color("#a67e55")))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func plate(fill: Color, rim: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = rim
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 5
	style.content_margin_bottom = 5
	return style


func render_lane() -> void:
	for child in lane.get_children():
		lane.remove_child(child)
		child.queue_free()
	rows.clear()
	var indices := range(mini(panel_limit, game.enc.ice.size()))
	if reverse_lane:
		indices.reverse()
	for index: int in indices:
		build_panel(index)
	var preview := PackedStringArray()
	for step: Dictionary in game.response_preview():
		if step.ice in indices and not step.skipped:
			preview.append("Hidden" if step.hidden else effect_text(game.enc.ice[step.ice], step.effects))
	response.text = "NEXT RESPONSE    " + "  ›  ".join(preview)
	status.text = "TURN %d   ·   BW %d   ·   TRACE %d" % [game.enc.turn, game.bw, game.trace]
	var focused: Button = rows.get(selected_row)
	if is_instance_valid(focused):
		focused.grab_focus()
	else:
		details.text = "Focus or hover a subroutine to inspect it."


func build_panel(index: int) -> void:
	var ice: Dictionary = game.enc.ice[index]
	var definition := game.ice_definition(ice)
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.clip_contents = true
	var skin := StyleBoxTexture.new()
	skin.texture = CONSOLE
	skin.draw_center = false
	for side in [SIDE_LEFT, SIDE_TOP, SIDE_RIGHT, SIDE_BOTTOM]:
		skin.set_texture_margin(side, 56)
		skin.set_content_margin(side, 26)
	panel.add_theme_stylebox_override("panel", skin)
	lane.add_child(panel)
	var enamel := ColorRect.new()
	enamel.color = Color("#8db9a6")
	enamel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(enamel)
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 8)
	panel.add_child(stack)
	var identity := HBoxContainer.new()
	stack.add_child(identity)
	var type_badge := IceBadge.new()
	type_badge.set_badge("type", definition.type, 0, 0, null, 48)
	identity.add_child(type_badge)
	type_badge.inspect_requested.connect(func(_badge: IceBadge) -> void:
		details.text = "%s ICE" % definition.type)
	var nameplate := plaque(definition.name.to_upper(), 26)
	nameplate.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nameplate.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	identity.add_child(nameplate)
	var str_badge := IceBadge.new()
	var strength := game.ice_str(index)
	str_badge.set_badge("str", definition.type, strength, strength - int(definition.str), null, 48)
	identity.add_child(str_badge)
	str_badge.inspect_requested.connect(func(_badge: IceBadge) -> void:
		details.text = "Current STR %d · printed STR %d" % [strength, int(definition.str)])
	var body := VBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stack.add_child(body)
	var portrait := TextureRect.new()
	var image := "res://assets/concept/mascots/%s_cheery.png" % ice.id
	if ResourceLoader.exists(image):
		portrait.texture = load(image)
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.size_flags_vertical = Control.SIZE_EXPAND_FILL
	portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if portrait.texture:
		body.add_child(portrait)
	else:
		portrait.free()
		var fallback := plaque("PORTRAIT UNAVAILABLE", 17)
		fallback.size_flags_vertical = Control.SIZE_EXPAND_FILL
		fallback.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		fallback.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		body.add_child(fallback)
	var bank := HBoxContainer.new()
	bank.alignment = BoxContainer.ALIGNMENT_CENTER
	bank.add_theme_constant_override("separation", 4)
	body.add_child(bank)
	var slot := 0
	for sub: int in game.active_subs(index):
		slot += 1
		add_row(bank, ice, index, sub, slot)
	var hidden: int = game.hidden_count(index)
	if hidden > 0:
		var pool := IceKey.new()
		pool.configure("HIDDEN", "", "hidden", "", true)
		pool.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		bank.add_child(pool)
		var count := plaque(str(hidden), 18)
		count.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		bank.add_child(count)
	var passive := String(definition.get("passive", ""))
	if passive != "":
		stack.add_child(plaque(passive, 18))


func add_row(bank: HBoxContainer, ice: Dictionary, index: int, sub: int, slot: int) -> void:
	var known: bool = ice.seen[sub]
	var spent: bool = ice.broken[sub]
	var effects: Array = game.ice_definition(ice).subs[sub] if known else []
	var main_effect: Dictionary = game.effect_value(ice, effects[0]) if not effects.is_empty() else {}
	var kind := String(main_effect.get("k", "HIDDEN"))
	var info := game.break_info(index, sub, pick_uid)
	var state := "BROKEN" if spent else ("HIDDEN" if not known else ("READY" if info.ok else "BLOCKED"))
	var value: Variant = main_effect.get("v", "")
	var cost_text := ("FREE" if int(info.cost) == 0 else "%d BW" % int(info.cost)) if info.ok else ("—" if known else "")
	var key_state := "broken" if spent else ("hidden" if not known else ("deadlock" if kind == "DEADLOCK" else "ready"))
	var key := IceKey.new()
	key.configure(kind, str(value), key_state, cost_text, false, 0.96)
	key.extra = maxi(0, effects.size() - 1)
	key.locked = kind == "DEADLOCK" and not info.ok
	var button := Button.new()
	button.flat = true
	button.custom_minimum_size = Vector2(key.custom_minimum_size.x, 95)
	button.add_child(key)
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	var ring := plate(Color.TRANSPARENT, Color("#83ffe8"))
	ring.set_border_width_all(3)
	button.add_theme_stylebox_override("focus", ring)
	var rule := effect_text(ice, effects) if known else "Face-down subroutine"
	var reason := "%d BW" % int(info.cost) if info.ok else String(info.get("reason", state))
	var row_id := "%s/%d" % [ice.id, sub]
	bank.add_child(button)
	rows[row_id] = button
	button.mouse_entered.connect(inspect.bind(slot, rule, state, reason))
	button.focus_entered.connect(focus_row.bind(row_id, slot, rule, state, reason))
	button.pressed.connect(attempt_break.bind(ice, sub))
	button.set_drag_forwarding(Callable(), can_drop_pick.bind(ice, sub), drop_pick.bind(ice, sub))


func effect_text(ice: Dictionary, effects: Array) -> String:
	var parts := PackedStringArray()
	for effect: Dictionary in effects:
		var visible := game.effect_value(ice, effect)
		var name := String(EFFECT_NAMES.get(visible.k, visible.k))
		var value: Variant = visible.get("v", "")
		var text := ("%s %s" % [name, str(value)]).strip_edges()
		if visible.has("then"):
			text += " → " + effect_text(ice, visible.then)
		parts.append(text)
	return " + ".join(parts)


func inspect(slot: int, rule: String, state: String, reason: String) -> void:
	details.text = "SLOT %d   ·   %s   ·   %s\n%s" % [slot, state, reason, rule]


func focus_row(id: String, slot: int, rule: String, state: String, reason: String) -> void:
	selected_row = id
	inspect(slot, rule, state, reason)


func get_pick_drag(_position: Vector2) -> Variant:
	var preview := plaque("FORTRESS ICEPICK", 20)
	pick_button.set_drag_preview(preview)
	return pick_uid


func current_index(ice: Dictionary) -> int:
	for index in game.enc.ice.size():
		if is_same(ice, game.enc.ice[index]):
			return index
	return -1


func can_drop_pick(_position: Vector2, data: Variant, ice: Dictionary, sub: int) -> bool:
	var index := current_index(ice)
	return data == pick_uid and index >= 0 and game.break_info(index, sub, pick_uid).ok


func drop_pick(position: Vector2, data: Variant, ice: Dictionary, sub: int) -> void:
	if can_drop_pick(position, data, ice, sub):
		attempt_break(ice, sub)


func attempt_break(ice: Dictionary, sub: int) -> void:
	var index := current_index(ice)
	if index >= 0 and game.break_sub(index, sub, pick_uid):
		render_lane()
		status.text += "   ·   Subroutine break resolved"
	elif index >= 0:
		var info := game.break_info(index, sub, pick_uid)
		status.text = "BREAK BLOCKED   ·   %s" % info.get("reason", "Unavailable")


func capture() -> void:
	var viewport := SubViewport.new()
	viewport.size = Vector2i(1536, 864)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(viewport)
	var fixture: Control = load(scene_file_path).instantiate()
	viewport.add_child(fixture)
	var passed: bool = fixture.game.enc.ice[0].id == "AUTO_RENEW" and fixture.game.enc.ice[1].id == "CAPTCHA"
	passed = await shot(viewport, "ICE-01-N2A-1536x864") and passed
	var blocked_ice: Dictionary = fixture.game.enc.ice[1]
	var blocked_sub: int = fixture.game.active_subs(1)[0]
	var blocked: Button = fixture.rows["CAPTCHA/%d" % blocked_sub]
	var bw_before: int = fixture.game.bw
	blocked.grab_focus()
	fixture.attempt_break(blocked_ice, blocked_sub)
	passed = passed and blocked.has_focus() and fixture.game.bw == bw_before
	passed = passed and fixture.status.text.begins_with("BREAK BLOCKED")
	passed = await shot(viewport, "ICE-02-blocked-focus") and passed
	fixture.play_probe()
	var auto: Dictionary = fixture.game.enc.ice[0]
	var legal: bool = fixture.can_drop_pick(Vector2.ZERO, fixture.pick_uid, auto, 0)
	passed = passed and legal and not fixture.can_drop_pick(Vector2.ZERO, fixture.pick_uid, blocked_ice, blocked_sub)
	if legal:
		var multi: Button = fixture.rows["AUTO_RENEW/2"]
		multi.mouse_entered.emit()
		passed = passed and fixture.details.text.contains("PULP 2 + BW drain 1")
		passed = await shot(viewport, "ICE-02b-legal-and-multiple-effects") and passed
		fixture.drop_pick(Vector2.ZERO, fixture.pick_uid, auto, 0)
		passed = passed and auto.broken[0]
		passed = await shot(viewport, "ICE-03-break") and passed
	fixture.select_count(1)
	viewport.size = Vector2i(1366, 768)
	passed = await shot(viewport, "ICE-04-one-1366x768") and passed
	fixture.select_count(2)
	viewport.size = Vector2i(1600, 1000)
	passed = await shot(viewport, "ICE-05-two-1600x1000") and passed
	fixture.select_count(3)
	fixture.toggle_order()
	viewport.size = Vector2i(1920, 810)
	passed = passed and fixture.lane.get_child_count() == 3
	passed = passed and fixture.rows["CAPTCHA/%d" % blocked_sub].has_focus()
	passed = passed and not fixture.can_drop_pick(Vector2.ZERO, fixture.pick_uid, auto, 0)
	var hidden: Button = fixture.rows["HOUSE_CALL/0"]
	hidden.grab_focus()
	passed = passed and fixture.details.text.contains("Face-down subroutine")
	passed = passed and not fixture.details.text.contains("PULP")
	passed = await shot(viewport, "ICE-06-three-1920x810") and passed
	var captcha_index: int = fixture.current_index(blocked_ice)
	var previous_slots: Array = fixture.game.active_subs(captcha_index)
	fixture.run_response()
	passed = passed and fixture.game.enc.turn == 2
	passed = passed and fixture.game.active_subs(captcha_index) != previous_slots
	passed = await shot(viewport, "ICE-07-tumbler-rotated") and passed
	print("VAS-001 ICE fixture: ", "PASS" if passed else "FAIL")
	get_tree().quit(0 if passed else 1)


func shot(viewport: SubViewport, name: String) -> bool:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var path := OS.get_environment("SHOT_DIR").path_join(name + ".png")
	return viewport.get_texture().get_image().save_png(path) == OK
