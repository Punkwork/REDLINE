extends Control
## Playable test screen for one Node: the Generalist against the Training Node.
## All UI is built in code so the scene file stays trivial. It is a test harness, not final art.

const GameData = preload("res://scripts/data/game_data.gd")
const RunState = preload("res://scripts/core/run_state.gd")
const NodeRun = preload("res://scripts/core/node_run.gd")

const C_BG := Color("0b0d12")
const C_PANEL := Color("151a23")
const C_TEXT := Color("d8dee9")
const C_DIM := Color("7a8494")
const C_ACCENT := Color("ff3860")
const C_GOOD := Color("3ddc97")
const C_WARN := Color("ffb000")
const TYPE_COLORS := {"WALL": Color("4ea8de"), "CODE GATE": Color("c77dff"), "SENTRY": Color("ff6b6b"),
		"BLACK ICE": Color("e5e5e5")}
const CARD_COLORS := {"PROGRAM": Color("4ea8de"), "SCRIPT": Color("3ddc97"), "PROTOCOL": Color("c77dff"),
		"BLOATWARE": Color("7a8494")}

var db
var run
var node

var selected_target := -1     ## ICE index chosen for targeted Scripts
var selected_icepick := -1    ## uid of the Icepick used for breaks

var stats_label: Label
var ice_row: HBoxContainer
var rig_row: HBoxContainer
var hand_row: HBoxContainer
var log_box: RichTextLabel
var end_turn_button: Button
var piles_label: Label
var overlay: PanelContainer
var overlay_body: VBoxContainer


func _ready() -> void:
	db = GameData.new()
	if not db.load_all():
		push_error("Data failed to load: %s" % [db.errors])
		return
	_build_layout()
	_new_run()


func _new_run() -> void:
	run = RunState.new()
	run.setup(db, "generalist")
	node = NodeRun.new()
	node.setup(db, run, "training", NodeRun.layers_for(db, "training"))
	node.changed.connect(_refresh)
	node.logged.connect(_on_log)
	log_box.clear()
	selected_target = -1
	selected_icepick = -1
	node.start()
	_refresh()


# ------------------------------------------------------------------ layout

func _build_layout() -> void:
	var bg := ColorRect.new()
	bg.color = C_BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var root := HBoxContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", 12)
	_margin(root, 14)
	add_child(root)

	var main := VBoxContainer.new()
	main.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main.add_theme_constant_override("separation", 10)
	root.add_child(main)

	stats_label = _label("", 20, C_TEXT)
	main.add_child(_panel(stats_label))

	main.add_child(_label("ICE  (Corporation Response runs left to right, top to bottom)", 13, C_DIM))
	ice_row = HBoxContainer.new()
	ice_row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ice_row.add_theme_constant_override("separation", 10)
	ice_row.alignment = BoxContainer.ALIGNMENT_CENTER
	main.add_child(ice_row)

	main.add_child(_label("RIG  (installed Programs and Protocols — click an Icepick to use it for breaks)", 13, C_DIM))
	rig_row = HBoxContainer.new()
	rig_row.custom_minimum_size.y = 110
	rig_row.add_theme_constant_override("separation", 8)
	main.add_child(rig_row)

	var hand_header := HBoxContainer.new()
	hand_header.add_child(_label("HAND", 13, C_DIM))
	piles_label = _label("", 13, C_DIM)
	piles_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	piles_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hand_header.add_child(piles_label)
	main.add_child(hand_header)

	var hand_area := HBoxContainer.new()
	hand_area.custom_minimum_size.y = 170
	hand_area.add_theme_constant_override("separation", 12)
	main.add_child(hand_area)
	hand_row = HBoxContainer.new()
	hand_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hand_row.add_theme_constant_override("separation", 8)
	hand_area.add_child(hand_row)
	end_turn_button = Button.new()
	end_turn_button.text = "END TURN"
	end_turn_button.custom_minimum_size = Vector2(150, 0)
	end_turn_button.add_theme_font_size_override("font_size", 20)
	end_turn_button.pressed.connect(func(): node.end_turn())
	hand_area.add_child(end_turn_button)

	var side := VBoxContainer.new()
	side.custom_minimum_size.x = 430
	root.add_child(side)
	side.add_child(_label("LOG", 13, C_DIM))
	log_box = RichTextLabel.new()
	log_box.scroll_following = true
	log_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	log_box.add_theme_font_size_override("normal_font_size", 13)
	log_box.add_theme_color_override("default_color", C_TEXT)
	side.add_child(_panel(log_box, true))
	var restart := Button.new()
	restart.text = "Restart run"
	restart.pressed.connect(_new_run)
	side.add_child(restart)

	overlay = PanelContainer.new()
	overlay.set_anchors_preset(Control.PRESET_CENTER)
	overlay.custom_minimum_size = Vector2(760, 0)
	overlay.add_theme_stylebox_override("panel", _box(Color("1d2330"), C_ACCENT, 2))
	overlay_body = VBoxContainer.new()
	overlay_body.add_theme_constant_override("separation", 12)
	_margin(overlay_body, 20)
	overlay.add_child(overlay_body)
	overlay.visible = false
	add_child(overlay)


# ------------------------------------------------------------------ refresh

func _refresh() -> void:
	if node == null:
		return
	var trace_color := "ff3860" if run.trace >= 30 else ("ffb000" if run.trace >= 20 else "d8dee9")
	stats_label.text = "VITAE %d/%d    SHIELD %d    BW %d    TRACE %d/40 (strikes %d)    CRED %d    RAM %d/%d    VOID %d    Layer %d/%d · Turn %d" % [
		run.vitae, run.max_vitae, node.shield, node.bw, run.trace, run.strikes, run.cred,
		node.ram_used, run.ram, run.void_counters, node.layer_index + 1, node.layers.size(), node.turn]
	stats_label.add_theme_color_override("font_color", Color(trace_color) if run.trace >= 20 else C_TEXT)
	piles_label.text = "Draw %d · Discard %d · Burned %d · CRED reserve %d%s" % [
		node.draw_pile.size(), node.discard_pile.size(), node.burned.size(), node.reserve,
		"   LOCKDOWN" if node.lockdown else ""]

	if selected_target >= node.ice_list.size():
		selected_target = -1
	if node.installed.filter(func(i): return i["uid"] == selected_icepick).is_empty():
		selected_icepick = -1
		var picks: Array = node.installed_icepicks()
		if not picks.is_empty():
			selected_icepick = picks[0]["uid"]

	_build_ice()
	_build_rig()
	_build_hand()
	end_turn_button.disabled = node.phase != NodeRun.PHASE_PLAYER
	end_turn_button.text = "END TURN\n(BREACH: skip response)" if node.phase == NodeRun.PHASE_PLAYER and node.is_breached() else "END TURN"
	_build_overlay()


func _build_ice() -> void:
	_clear(ice_row)
	for i in node.ice_list.size():
		var ice: Dictionary = node.ice_list[i]
		var def: Dictionary = ice["def"]
		var col: Color = TYPE_COLORS.get(def["type"], C_TEXT)
		var box := VBoxContainer.new()
		box.add_theme_constant_override("separation", 6)
		box.custom_minimum_size.x = 280
		var title := _label("%s\n%s · STR %d" % [def["name"], def["type"], node.ice_str(i)], 18, col)
		box.add_child(title)
		if not ice["virus"].is_empty():
			var parts: Array = []
			for k in ice["virus"].keys():
				parts.append("%s %d" % [String(k).to_upper(), ice["virus"][k]])
			box.add_child(_label("Virus: " + ", ".join(parts), 13, C_GOOD))
		if def.has("ability"):
			var ab := _label(def["ability"]["text"], 12, C_WARN)
			ab.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			box.add_child(ab)
		var subs: Array = def["subroutines"]
		for s in subs.size():
			box.add_child(_sub_button(i, s))
		var target_btn := Button.new()
		target_btn.text = "◉ TARGET" if selected_target == i or (selected_target == -1 and i == node.ice_list.size() - 1) else "Target for Scripts"
		target_btn.pressed.connect(func():
			selected_target = i
			_refresh())
		box.add_child(target_btn)
		var border: Color = col if selected_target == i else C_PANEL.lightened(0.15)
		var panel := _panel(box)
		panel.add_theme_stylebox_override("panel", _box(C_PANEL, border, 2))
		ice_row.add_child(panel)


func _sub_button(ice_index: int, sub_index: int) -> Button:
	var ice: Dictionary = node.ice_list[ice_index]
	var effects: Array = ice["def"]["subroutines"][sub_index]["effects"]
	var text: String = ", ".join(effects.map(func(e): return node._describe_ice_effect(e)))
	var b := Button.new()
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.custom_minimum_size.y = 34
	if ice["broken"][sub_index]:
		b.text = "  ✕ S%d  %s  (broken)" % [sub_index + 1, text]
		b.disabled = true
		return b
	var cost := -1
	if selected_icepick != -1:
		cost = node.total_break_cost(selected_icepick, ice_index, sub_index)
	if cost >= 0:
		b.text = "  ▶ S%d  %s    [break: %d BW]" % [sub_index + 1, text, cost]
		b.disabled = cost > node.bw or node.phase != NodeRun.PHASE_PLAYER
		b.tooltip_text = "Boosts as needed, then breaks this subroutine."
		b.pressed.connect(func(): node.boost_and_break(selected_icepick, ice_index, sub_index))
	else:
		b.text = "  ▶ S%d  %s" % [sub_index + 1, text]
		b.disabled = true
		b.tooltip_text = "No selected Icepick can break this ICE type."
	if text == "DEADLOCK":
		b.add_theme_color_override("font_color", C_WARN)
		b.add_theme_color_override("font_disabled_color", C_WARN.darkened(0.3))
	return b


func _build_rig() -> void:
	_clear(rig_row)
	for inst in node.installed + node.rack:
		var def: Dictionary = node.card_def(inst)
		var box := VBoxContainer.new()
		box.custom_minimum_size.x = 190
		var head: String = def["name"]
		if def.has("icepick"):
			var ip: Dictionary = def["icepick"]
			head += "\n%s · STR %d" % [ip["ice_type"], node.icepick_str(inst)]
		var head_label := _label(head, 14, CARD_COLORS.get(def["type"], C_TEXT))
		box.add_child(head_label)
		var row := HBoxContainer.new()
		if def.has("icepick"):
			var use := Button.new()
			use.text = "● Using" if selected_icepick == inst["uid"] else "Use"
			use.pressed.connect(func():
				selected_icepick = inst["uid"]
				_refresh())
			row.add_child(use)
			var boost := Button.new()
			boost.text = "+%d STR (%d BW)" % [int(def["icepick"]["boost_str"]), int(def["icepick"]["boost_bw"])]
			boost.disabled = node.phase != NodeRun.PHASE_PLAYER or int(def["icepick"]["boost_bw"]) > node.bw
			boost.pressed.connect(func(): node.boost(inst["uid"]))
			row.add_child(boost)
		if node.installed.has(inst):
			var unl := Button.new()
			unl.text = "Unload"
			unl.disabled = node.phase != NodeRun.PHASE_PLAYER
			unl.pressed.connect(func(): node.unload(inst["uid"]))
			row.add_child(unl)
		box.add_child(row)
		var panel := _panel(box)
		var border: Color = C_ACCENT if selected_icepick == inst["uid"] else C_PANEL.lightened(0.15)
		panel.add_theme_stylebox_override("panel", _box(C_PANEL, border, 2))
		panel.tooltip_text = def["text"]
		rig_row.add_child(panel)
	if node.installed.is_empty() and node.rack.is_empty():
		rig_row.add_child(_label("Nothing installed. Play a PROGRAM card from your hand.", 13, C_DIM))


func _build_hand() -> void:
	_clear(hand_row)
	for inst in node.hand:
		var def: Dictionary = node.card_def(inst)
		var b := Button.new()
		b.custom_minimum_size = Vector2(165, 165)
		b.clip_text = false
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		var cost := "—" if def["cost_bw"] == null else str(int(def["cost_bw"]))
		var extra := "  RAM %d" % int(def["ram"]) if def.has("ram") else ""
		b.text = "%s\n%s · %s BW%s\n\n%s" % [def["name"], def["type"], cost, extra, def["text"]]
		b.add_theme_font_size_override("font_size", 12)
		b.add_theme_color_override("font_color", CARD_COLORS.get(def["type"], C_TEXT))
		var check: Dictionary = node.can_play(inst)
		b.disabled = not check["ok"]
		b.tooltip_text = check["reason"] if not check["ok"] else def["text"]
		b.pressed.connect(func(): node.play_card(inst["uid"], selected_target))
		hand_row.add_child(b)


func _build_overlay() -> void:
	_clear(overlay_body)
	overlay.visible = true
	match node.phase:
		NodeRun.PHASE_READY_RIG:
			overlay_body.add_child(_label("READY RIG", 26, C_ACCENT))
			overlay_body.add_child(_label("Your ORIGIN Ghostware: choose one Program from your deck to start installed, for free.", 15, C_TEXT))
			var seen := {}
			for inst in node.ready_rig_options():
				if seen.has(inst["id"]):
					continue
				seen[inst["id"]] = true
				var def: Dictionary = node.card_def(inst)
				overlay_body.add_child(_choice("%s — %s" % [def["name"], def["text"]], func(): node.ready_rig_choose(inst["uid"])))
			overlay_body.add_child(_choice("Skip", func(): node.ready_rig_choose(-1)))
		NodeRun.PHASE_REWARD:
			overlay_body.add_child(_label("LAYER %d BREACHED" % (node.layer_index + 1), 26, C_GOOD))
			overlay_body.add_child(_label("The Corporation Response was skipped. Choose a card to add to your deck:", 15, C_TEXT))
			for id in node.reward_options:
				var def: Dictionary = db.cards[id]
				var cost := "—" if def["cost_bw"] == null else str(int(def["cost_bw"]))
				overlay_body.add_child(_choice("%s  (%s, %s BW, %s)\n%s" % [def["name"], def["type"], cost, def["rarity"], def["text"]],
						func(): node.choose_reward(id)))
			overlay_body.add_child(_choice("Skip the card", func(): node.choose_reward("")))
		NodeRun.PHASE_LAYER_CHOICE:
			overlay_body.add_child(_label("GO DEEPER?", 26, C_ACCENT))
			var next: Dictionary = node.layers[node.layer_index + 1]
			var names: Array = next["ice"].map(func(id): return db.ice[id]["name"])
			overlay_body.add_child(_label("Layer %d: %s (CRED reserve %d)" % [node.layer_index + 2, ", ".join(names), int(next["cred_reserve"])], 15, C_TEXT))
			overlay_body.add_child(_choice("Go deeper", func(): node.go_deeper()))
			var leave := _choice("Leave the Node with what you have", func(): node.leave_node())
			leave.disabled = not node.can_leave()
			overlay_body.add_child(leave)
		NodeRun.PHASE_NODE_COMPLETE:
			overlay_body.add_child(_label("NODE COMPLETE", 26, C_GOOD))
			overlay_body.add_child(_label("VITAE %d/%d · TRACE %d · CRED %d · Deck %d cards" % [run.vitae, run.max_vitae, run.trace, run.cred, run.deck.size()], 15, C_TEXT))
			overlay_body.add_child(_choice("Play again", _new_run))
		NodeRun.PHASE_DEFEAT:
			overlay_body.add_child(_label("FLATLINED", 26, C_ACCENT))
			overlay_body.add_child(_label("VITAE reached 0 on layer %d." % (node.layer_index + 1), 15, C_TEXT))
			overlay_body.add_child(_choice("Try again", _new_run))
		_:
			overlay.visible = false
	if overlay.visible:
		overlay.reset_size()
		overlay.position = (size - overlay.size) / 2


func _on_log(text: String) -> void:
	var color := "d8dee9"
	if text.begins_with("==") or text.begins_with("!!"):
		color = "ff3860"
	elif text.begins_with("--"):
		color = "ffb000"
	elif text.begins_with("(Not yet"):
		color = "7a8494"
	log_box.append_text("[color=#%s]%s[/color]\n" % [color, text])


# ------------------------------------------------------------------ helpers

func _label(text: String, font_size: int, color: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", font_size)
	l.add_theme_color_override("font_color", color)
	return l


func _choice(text: String, action: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	b.custom_minimum_size.y = 44
	b.add_theme_font_size_override("font_size", 15)
	b.pressed.connect(action)
	return b


func _panel(child: Control, expand := false) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", _box(C_PANEL, C_PANEL.lightened(0.15), 1))
	if expand:
		p.size_flags_vertical = Control.SIZE_EXPAND_FILL
	p.add_child(child)
	return p


func _box(bg: Color, border: Color, width: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(width)
	s.set_corner_radius_all(4)
	s.set_content_margin_all(10)
	return s


func _margin(c: Control, px: int) -> void:
	c.offset_left = px
	c.offset_top = px
	c.offset_right = -px
	c.offset_bottom = -px


func _clear(c: Node) -> void:
	for child in c.get_children():
		c.remove_child(child)
		child.queue_free()
