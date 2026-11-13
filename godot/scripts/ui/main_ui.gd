extends Control
## Playtest UI: main menu, the HALCYON heist (map, Uplink, rooms, encounters, summary) and the
## Training Node. All UI is built in code so the scene file stays trivial. A test harness, not final art.

const GameData = preload("res://scripts/data/game_data.gd")
const RunState = preload("res://scripts/core/run_state.gd")
const NodeRun = preload("res://scripts/core/node_run.gd")
const Heist = preload("res://scripts/core/heist.gd")

const C_BG := Color("0b0d12")
const C_PANEL := Color("151a23")
const C_TEXT := Color("d8dee9")
const C_DIM := Color("7a8494")
const C_ACCENT := Color("ff3860")
const C_GOOD := Color("3ddc97")
const C_WARN := Color("ffb000")
const C_CRED := Color("f5d76e")
const TYPE_COLORS := {"WALL": Color("4ea8de"), "CODE GATE": Color("c77dff"), "SENTRY": Color("ff6b6b")}
const CARD_COLORS := {"PROGRAM": Color("4ea8de"), "SCRIPT": Color("3ddc97"), "PROTOCOL": Color("c77dff"),
		"BLOATWARE": Color("7a8494")}
const NODE_COLORS := {"opener": Color("ff9f43"), "ice_t1": Color("4ea8de"), "ice_t2": Color("c77dff"), "uplink": Color("f5d76e"),
		"dead_drop": Color("3ddc97"), "safehouse": Color("3ddc97"), "console_lab": Color("ffb000"),
		"signal": Color("7a8494"), "central": Color("ff3860")}

var db
var mode := "menu"            ## "menu", "training", "heist"
var heist
var node                      ## the NodeRun on screen
var training_run

var selected_target := -1
var selected_icepick := -1
var choice_picks: Array = []
var show_deck := false
var menu_corp := "halcyon"

# Encounter screen
var encounter_root: Control
var stats_label: Label
var cap_row: HBoxContainer
var ice_row: HBoxContainer
var rig_row: HBoxContainer
var hand_row: HBoxContainer
var log_box: RichTextLabel
var end_turn_button: Button
var piles_label: Label
var overlay: PanelContainer
var overlay_body: VBoxContainer
# Other screens (menu, map, rooms, summary), rebuilt on every refresh
var screen_root: PanelContainer
var screen_body: VBoxContainer
var side_log: RichTextLabel


func _ready() -> void:
	db = GameData.new()
	if not db.load_all():
		push_error("Data failed to load: %s" % [db.errors])
		return
	_build_layout()
	_refresh()


# ------------------------------------------------------------------ modes

func _go_menu() -> void:
	mode = "menu"
	heist = null
	node = null
	_refresh()


func _start_training() -> void:
	mode = "training"
	heist = null
	training_run = RunState.new()
	training_run.setup(db, "generalist")
	_set_node(NodeRun.new())
	node.setup(db, training_run, "training", NodeRun.layers_for(db, "training"))
	log_box.clear()
	node.logged.connect(_on_log)
	node.start()
	_refresh()


func _start_heist(rustler_id: String, seed_value: int = 0, corp_id: String = "") -> void:
	mode = "heist"
	node = null
	heist = Heist.new()
	heist.setup(db, rustler_id, seed_value, corp_id if corp_id != "" else menu_corp)
	heist.changed.connect(_refresh)
	heist.logged.connect(_on_log)
	log_box.clear()
	side_log.clear()
	heist.start()


func _set_node(n) -> void:
	node = n
	selected_target = -1
	selected_icepick = -1
	choice_picks.clear()
	if node != null and not node.changed.is_connected(_refresh):
		node.changed.connect(_refresh)


func _run():
	return heist.run if heist != null else training_run


# ------------------------------------------------------------------ layout

func _build_layout() -> void:
	var bg := ColorRect.new()
	bg.color = C_BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	encounter_root = HBoxContainer.new()
	encounter_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	encounter_root.add_theme_constant_override("separation", 12)
	_margin(encounter_root, 14)
	add_child(encounter_root)

	var main := VBoxContainer.new()
	main.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main.add_theme_constant_override("separation", 8)
	encounter_root.add_child(main)

	stats_label = _label("", 18, C_TEXT)
	main.add_child(_panel(stats_label))
	cap_row = HBoxContainer.new()
	cap_row.add_theme_constant_override("separation", 8)
	main.add_child(cap_row)

	main.add_child(_label("ICE  (Corporation Response runs left to right, top to bottom)", 13, C_DIM))
	ice_row = HBoxContainer.new()
	ice_row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ice_row.add_theme_constant_override("separation", 10)
	ice_row.alignment = BoxContainer.ALIGNMENT_CENTER
	main.add_child(ice_row)

	main.add_child(_label("RIG  (installed Programs and Protocols — click an Icepick to use it for breaks)", 13, C_DIM))
	rig_row = HBoxContainer.new()
	rig_row.custom_minimum_size.y = 100
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
	hand_area.custom_minimum_size.y = 165
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
	side.custom_minimum_size.x = 400
	encounter_root.add_child(side)
	side.add_child(_label("LOG", 13, C_DIM))
	log_box = _make_log()
	side.add_child(_panel(log_box, true))
	var menu_btn := Button.new()
	menu_btn.text = "Main menu"
	menu_btn.pressed.connect(_go_menu)
	side.add_child(menu_btn)

	overlay = PanelContainer.new()
	overlay.custom_minimum_size = Vector2(780, 0)
	overlay.add_theme_stylebox_override("panel", _box(Color("1d2330"), C_ACCENT, 2))
	overlay_body = VBoxContainer.new()
	overlay_body.add_theme_constant_override("separation", 10)
	overlay.add_child(overlay_body)
	overlay.visible = false
	add_child(overlay)

	screen_root = PanelContainer.new()
	screen_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	screen_root.add_theme_stylebox_override("panel", _box(C_BG, C_BG, 0))
	var screen_split := HBoxContainer.new()
	screen_split.add_theme_constant_override("separation", 12)
	screen_root.add_child(screen_split)
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	screen_split.add_child(scroll)
	screen_body = VBoxContainer.new()
	screen_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	screen_body.add_theme_constant_override("separation", 12)
	scroll.add_child(screen_body)
	var side2 := VBoxContainer.new()
	side2.custom_minimum_size.x = 400
	screen_split.add_child(side2)
	side2.add_child(_label("LOG", 13, C_DIM))
	side_log = _make_log()
	side2.add_child(_panel(side_log, true))
	add_child(screen_root)


func _make_log() -> RichTextLabel:
	var l := RichTextLabel.new()
	l.scroll_following = true
	l.bbcode_enabled = true
	l.size_flags_vertical = Control.SIZE_EXPAND_FILL
	l.add_theme_font_size_override("normal_font_size", 13)
	l.add_theme_color_override("default_color", C_TEXT)
	return l


# ------------------------------------------------------------------ refresh

func _refresh() -> void:
	if mode == "heist" and heist != null and heist.node != node:
		if heist.node != null:
			_set_node(heist.node)
	var show_encounter: bool = mode == "training" or (mode == "heist" and heist.phase == Heist.PHASE_ENCOUNTER and node != null)
	encounter_root.visible = show_encounter
	screen_root.visible = not show_encounter
	if show_encounter:
		_refresh_encounter()
	else:
		overlay.visible = false
		_clear(screen_body)
		match mode:
			"menu":
				_screen_menu()
			"heist":
				match heist.phase:
					Heist.PHASE_MAP:
						_screen_map()
					Heist.PHASE_ROOM:
						_screen_room()
					Heist.PHASE_PICK:
						_screen_pick()
					Heist.PHASE_SUMMARY:
						_screen_summary()


func _status_line() -> String:
	var r = _run()
	return "VITAE %d/%d    TRACE %d/40 (strikes %d)    CRED %d    VOID %d    Deck %d    CAPS %d/%d" % [
		r.vitae, r.max_vitae, r.trace, r.strikes, r.cred, r.void_counters, r.deck.size(), r.caps.size(), r.cap_slots]


# ------------------------------------------------------------------ menu, map, rooms, summary

func _screen_menu() -> void:
	_margin_box(screen_body)
	screen_body.add_child(_label("REDLINE", 48, C_ACCENT))
	screen_body.add_child(_label("Economy playtest build", 16, C_DIM))
	screen_body.add_child(_label("\nA corporation heist: 9 infiltration rows, Uplinks, events and the Central Node (no escape yet).\n1. Choose a corporation:", 16, C_TEXT))
	var crow := HBoxContainer.new()
	crow.add_theme_constant_override("separation", 8)
	for cid in ["halcyon", "ironwatch", "lucida"]:
		var c: Dictionary = db.corporations[cid]
		var cb := Button.new()
		cb.text = "%s%s\n%s · %s" % ["◉ " if menu_corp == cid else "", c["name"], c["theme"], c["main_threat"]]
		cb.custom_minimum_size = Vector2(330, 56)
		cb.add_theme_color_override("font_color", C_ACCENT if menu_corp == cid else C_TEXT)
		cb.pressed.connect(func():
			menu_corp = cid
			_refresh())
		crow.add_child(cb)
	screen_body.add_child(crow)
	screen_body.add_child(_label("2. Choose a Rustler to start:", 16, C_TEXT))
	for rid in ["generalist", "echo", "riot", "vector"]:
		var r: Dictionary = db.rustlers[rid]
		var origin: Dictionary = db.ghostware[r["origin_ghostware"]]
		screen_body.add_child(_choice("%s — %s\nORIGIN: %s — %s" % [r["name"], r["playstyle"], origin["name"], origin["text"]],
				func(): _start_heist(rid)))
	screen_body.add_child(_label("\nOr learn the basics:", 16, C_TEXT))
	screen_body.add_child(_choice("Training Node (THE GENERALIST, 3 layers)", _start_training))


func _header(title: String) -> void:
	screen_body.add_child(_label(title, 28, C_ACCENT))
	screen_body.add_child(_label(_status_line(), 16, C_TEXT))
	var r = _run()
	var g: Array = r.ghostware.map(func(id): return db.ghostware[id]["name"])
	var caps: Array = r.caps.map(func(c): return db.caps[c["id"]]["name"] + (" (bootleg)" if c["bootleg"] else ""))
	screen_body.add_child(_label("Ghostware: %s\nCAPS: %s" % [", ".join(g), ", ".join(caps) if not caps.is_empty() else "none"], 13, C_DIM))
	var row := HBoxContainer.new()
	var deck_btn := Button.new()
	deck_btn.text = "Hide deck" if show_deck else "View deck (%d)" % r.deck.size()
	deck_btn.pressed.connect(func():
		show_deck = not show_deck
		_refresh())
	row.add_child(deck_btn)
	var menu_btn := Button.new()
	menu_btn.text = "Main menu"
	menu_btn.pressed.connect(_go_menu)
	row.add_child(menu_btn)
	screen_body.add_child(row)
	if show_deck:
		var counts := {}
		for inst in r.deck:
			var name: String = db.cards[inst["id"]]["name"]
			counts[name] = int(counts.get(name, 0)) + 1
		var names: Array = counts.keys()
		names.sort()
		var l := _label(", ".join(names.map(func(n): return "%s ×%d" % [n, counts[n]] if counts[n] > 1 else n)), 13, C_TEXT)
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		screen_body.add_child(_panel(l))


func _screen_map() -> void:
	_header("%s — choose your next Node" % heist.corp["name"])
	screen_body.add_child(_label("Left to right: rows 1–9, then the Central Node. You can move to the highlighted Nodes.", 13, C_DIM))
	var grid := HBoxContainer.new()
	grid.add_theme_constant_override("separation", 6)
	var reach: Array = heist.reachable()
	for r in heist.rows.size():
		var col := VBoxContainer.new()
		col.add_theme_constant_override("separation", 6)
		col.add_child(_label("Row %d" % (r + 1) if r < 9 else "Core", 13, C_DIM))
		for c in heist.rows[r].size():
			var n: Dictionary = heist.rows[r][c]
			var b := Button.new()
			b.custom_minimum_size = Vector2(108, 64)
			b.text = n["label"].replace(" (", "\n(").replace(" + ", "\n+ ")
			b.add_theme_font_size_override("font_size", 12)
			var visited: bool = heist.path.has([r, c])
			var here: bool = r == heist.row_index and c == heist.pos
			var can: bool = r == heist.row_index + 1 and reach.has(c)
			b.disabled = not can
			var col_c: Color = NODE_COLORS.get(n["type"], C_TEXT)
			b.add_theme_color_override("font_color", col_c)
			b.add_theme_color_override("font_disabled_color", col_c.darkened(0.5) if not visited else col_c)
			var border := C_GOOD if can else (C_ACCENT if here else (col_c if visited else C_PANEL.lightened(0.1)))
			b.add_theme_stylebox_override("normal", _box(C_PANEL, border, 2))
			b.add_theme_stylebox_override("disabled", _box(C_PANEL.darkened(0.3) if not visited else C_PANEL, border, 2 if visited or here else 1))
			b.add_theme_stylebox_override("hover", _box(C_PANEL.lightened(0.1), border, 3))
			b.pressed.connect(func(): heist.choose_node(c))
			col.add_child(b)
		grid.add_child(col)
	screen_body.add_child(grid)


func _screen_room() -> void:
	var room: Dictionary = heist.room
	match room["type"]:
		"uplink":
			_header("BLACK MARKET UPLINK" + ("  ·  CLINIC" if room["clinic"] else ""))
			for shelf in ["Cards", "CAPS", "Ghostware"]:
				screen_body.add_child(_label(shelf.to_upper(), 15, C_DIM))
				var row := HFlowContainer.new()
				row.add_theme_constant_override("h_separation", 8)
				row.add_theme_constant_override("v_separation", 8)
				for i in room["items"].size():
					var item: Dictionary = room["items"][i]
					if item["shelf"] != shelf:
						continue
					var b := Button.new()
					b.custom_minimum_size = Vector2(220, 120)
					b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
					b.add_theme_font_size_override("font_size", 12)
					var price := "SOLD" if item.get("sold", false) else "%d CRED%s" % [item["price"], "  (SALE)" if item.get("sale", false) else ""]
					b.text = "%s\n%s\n%s" % [heist.item_name(item), price, heist.item_text(item)]
					var why: String = heist.can_buy(i)
					b.disabled = why != ""
					b.tooltip_text = why
					b.pressed.connect(func(): heist.buy(i))
					row.add_child(b)
				screen_body.add_child(row)
			screen_body.add_child(_label("SERVICES", 15, C_DIM))
			var srow := HBoxContainer.new()
			var wipe := Button.new()
			wipe.text = "WIPE: remove a card (%d CRED)%s" % [heist.wipe_price(), "  — used" if room["wipe_used"] else ""]
			wipe.disabled = room["wipe_used"] or _run().cred < heist.wipe_price()
			wipe.pressed.connect(heist.start_wipe)
			srow.add_child(wipe)
			if room["clinic"]:
				var clinic := Button.new()
				clinic.text = "CLINIC: remove all VOID (%d CRED)" % heist.clinic_price()
				clinic.disabled = room["clinic_used"] or _run().void_counters == 0 or _run().cred < heist.clinic_price()
				clinic.pressed.connect(heist.use_clinic)
				srow.add_child(clinic)
			screen_body.add_child(srow)
			screen_body.add_child(_choice("Leave the Uplink", heist.leave_room))
		"dead_drop":
			_header("DEAD DROP")
			screen_body.add_child(_choice("PATCH UP: +10 VITAE", func(): heist.room_choice("patch_up")))
			screen_body.add_child(_choice("WIPE TRAIL: −20 TRACE", func(): heist.room_choice("wipe_trail")))
		"safehouse":
			_header("SAFEHOUSE")
			screen_body.add_child(_choice("Heal 10 VITAE", func(): heist.room_choice("heal")))
			var pw := _choice("Apply 1 PATCHWORK (not in this build yet)", func(): pass)
			pw.disabled = true
			screen_body.add_child(pw)
			screen_body.add_child(_choice("Leave", heist.leave_room))
		"console_lab":
			_header("CONSOLE LAB")
			var price := int(db.rules["prices"]["console_lab_removal"])
			var rm := _choice("Remove a card from your deck (%d CRED)" % price, func(): heist.room_choice("remove"))
			rm.disabled = _run().cred < price
			screen_body.add_child(rm)
			var pw2 := _choice("Apply 1 PATCHWORK free (not in this build yet)", func(): pass)
			pw2.disabled = true
			screen_body.add_child(pw2)
			screen_body.add_child(_choice("Leave", heist.leave_room))
		"event":
			var ev: Dictionary = room["event"]
			_header("SIGNAL UNCLEAR: " + ev["name"])
			var t := _label(ev["text"], 16, C_TEXT)
			t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			screen_body.add_child(t)
			for i in ev["choices"].size():
				var b := _choice(ev["choices"][i]["label"], func(): heist.room_choice(str(i)))
				b.disabled = not heist.event_choice_allowed(i)
				screen_body.add_child(b)


func _screen_pick() -> void:
	_header("CHOOSE A CARD")
	screen_body.add_child(_label(heist.pick["prompt"], 16, C_WARN))
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 8)
	flow.add_theme_constant_override("v_separation", 8)
	for o in heist.pick_options():
		var d: Dictionary = db.cards[o["id"]]
		var b := Button.new()
		b.custom_minimum_size = Vector2(200, 90)
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.add_theme_font_size_override("font_size", 12)
		b.add_theme_color_override("font_color", CARD_COLORS.get(d["type"], C_TEXT))
		b.text = "%s\n%s · %s\n%s" % [d["name"], d["type"], d["rarity"], d["text"]]
		b.pressed.connect(func(): heist.resolve_pick(o["uid"]))
		flow.add_child(b)
	screen_body.add_child(flow)
	screen_body.add_child(_choice("Cancel", func(): heist.resolve_pick(-1)))


func _screen_summary() -> void:
	screen_body.add_child(_label("RUN SUMMARY" + ("  —  CENTRAL NODE CRACKED" if heist.won else "  —  FLATLINED"), 28, C_GOOD if heist.won else C_ACCENT))
	var row := HBoxContainer.new()
	var copy := Button.new()
	copy.text = "Copy summary to clipboard"
	copy.pressed.connect(func():
		DisplayServer.clipboard_set(heist.summary_text())
		copy.text = "Copied!")
	row.add_child(copy)
	var menu_btn := Button.new()
	menu_btn.text = "Main menu"
	menu_btn.pressed.connect(_go_menu)
	row.add_child(menu_btn)
	screen_body.add_child(row)
	screen_body.add_child(_label("Paste the summary into the chat so we can tune prices and reserves together.", 13, C_DIM))
	var t := TextEdit.new()
	t.text = heist.summary_text()
	t.editable = false
	t.custom_minimum_size = Vector2(0, 680)
	t.add_theme_font_size_override("font_size", 13)
	screen_body.add_child(t)


# ------------------------------------------------------------------ encounter

func _refresh_encounter() -> void:
	if node == null:
		return
	var r = _run()
	stats_label.text = "VITAE %d/%d    SHIELD %d%s    BW %d    TRACE %d/40 (strikes %d)    CRED %d    RAM %d/%d    VOID %d    Layer %d/%d · Turn %d" % [
		r.vitae, r.max_vitae, node.shield, (" (+%d Node)" % node.node_shield) if node.node_shield > 0 else "", node.bw,
		r.trace, r.strikes, r.cred, node.ram_used, node.ram_capacity(), r.void_counters,
		node.layer_index + 1, node.layers.size(), node.turn]
	stats_label.add_theme_color_override("font_color", C_ACCENT if r.trace >= 30 else (C_WARN if r.trace >= 20 else C_TEXT))
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
	_build_caps()
	_build_ice()
	_build_rig()
	_build_hand()
	end_turn_button.disabled = node.busy()
	end_turn_button.text = "END TURN\n(BREACH: skip response)" if not node.busy() and node.is_breached() else "END TURN"
	_build_overlay()


func _target() -> int:
	return selected_target if selected_target >= 0 else node.ice_list.size() - 1


func _build_caps() -> void:
	_clear(cap_row)
	var r = _run()
	cap_row.add_child(_label("CAPS %d/%d:" % [r.caps.size(), r.cap_slots], 14, C_DIM))
	for slot in r.caps.size():
		var cap: Dictionary = r.caps[slot]
		var d: Dictionary = db.caps[cap["id"]]
		var b := Button.new()
		b.text = "%s%s" % [d["name"], " (bootleg)" if cap["bootleg"] else ""]
		b.tooltip_text = d["text"] + ("\nBOOTLEG: 25% fizzle, +3 TRACE." if cap["bootleg"] else "")
		b.disabled = node.busy()
		b.pressed.connect(func(): node.use_cap(slot, _target()))
		cap_row.add_child(b)
	if node.run.has_ghostware("dead_mans_pocket"):
		var p := Button.new()
		p.text = "DEAD MAN'S POCKET: CACHE 1"
		p.disabled = not node.can_pocket()
		p.pressed.connect(node.pocket)
		cap_row.add_child(p)


func _build_ice() -> void:
	_clear(ice_row)
	for i in node.ice_list.size():
		var ice: Dictionary = node.ice_list[i]
		var def: Dictionary = ice["def"]
		var col: Color = TYPE_COLORS.get(def["type"], C_TEXT)
		var box := VBoxContainer.new()
		box.add_theme_constant_override("separation", 5)
		box.custom_minimum_size.x = 250
		box.add_child(_label("%s\n%s · STR %d" % [def["name"], def["type"], node.ice_str(i)], 17, col))
		if not ice["virus"].is_empty():
			var parts: Array = []
			for k in ice["virus"].keys():
				parts.append("%s %d" % [String(k).to_upper(), ice["virus"][k]])
			box.add_child(_label("Virus: " + ", ".join(parts), 13, C_GOOD))
		if def.has("ability"):
			var ab := _label(def["ability"]["text"], 12, C_WARN)
			ab.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			box.add_child(ab)
		for s in def["subroutines"].size():
			box.add_child(_sub_button(i, s))
		var target_btn := Button.new()
		target_btn.text = "◉ TARGET" if _target() == i else "Target this ICE"
		target_btn.pressed.connect(func():
			selected_target = i
			_refresh())
		box.add_child(target_btn)
		var border: Color = col if _target() == i else C_PANEL.lightened(0.15)
		var panel := _panel(box)
		panel.add_theme_stylebox_override("panel", _box(C_PANEL, border, 2))
		ice_row.add_child(panel)


func _sub_button(ice_index: int, sub_index: int) -> Button:
	var ice: Dictionary = node.ice_list[ice_index]
	var effects: Array = ice["def"]["subroutines"][sub_index]["effects"]
	var text: String = ", ".join(effects.map(func(e): return node.describe_ice_effect(e)))
	var b := Button.new()
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.custom_minimum_size.y = 32
	b.clip_text = true
	if ice["broken"][sub_index]:
		b.text = "  ✕ S%d  %s  (broken)" % [sub_index + 1, text]
		b.disabled = true
		return b
	if node.deadlock_locked(ice_index, sub_index):
		b.text = "  ⧗ S%d  %s  (BOOTING)" % [sub_index + 1, text]
		b.disabled = true
		b.tooltip_text = "This DEADLOCK can't be broken yet."
		return b
	var cost := -1
	if selected_icepick != -1:
		cost = node.total_break_cost(selected_icepick, ice_index, sub_index)
	if cost >= 0:
		b.text = "  ▶ S%d  %s    [break: %d BW]" % [sub_index + 1, text, cost]
		b.disabled = cost > node.bw or node.busy()
		b.tooltip_text = "Boosts as needed, then breaks this subroutine."
		b.pressed.connect(func(): node.boost_and_break(selected_icepick, ice_index, sub_index))
	else:
		b.text = "  ▶ S%d  %s" % [sub_index + 1, text]
		b.disabled = true
		b.tooltip_text = "Your selected Icepick can't break this ICE type."
	if text.contains("DEADLOCK"):
		b.add_theme_color_override("font_color", C_WARN)
		b.add_theme_color_override("font_disabled_color", C_WARN.darkened(0.3))
	return b


func _build_rig() -> void:
	_clear(rig_row)
	for inst in node.installed + node.rack:
		var def: Dictionary = node.card_def(inst)
		var box := VBoxContainer.new()
		box.custom_minimum_size.x = 180
		var head: String = def["name"]
		if def.has("icepick"):
			head += "\n%s · STR %d" % [def["icepick"]["ice_type"], node.icepick_str(inst)]
		box.add_child(_label(head, 14, CARD_COLORS.get(def["type"], C_TEXT)))
		var row := HBoxContainer.new()
		if def.has("icepick"):
			var use := Button.new()
			use.text = "● Using" if selected_icepick == inst["uid"] else "Use"
			use.pressed.connect(func():
				selected_icepick = inst["uid"]
				_refresh())
			row.add_child(use)
			var boost := Button.new()
			boost.text = "+%d STR (%d BW)" % [int(def["icepick"]["boost_str"]), node._boost_cost(inst)]
			boost.disabled = node.busy() or node._boost_cost(inst) > node.bw
			boost.pressed.connect(func(): node.boost(inst["uid"]))
			row.add_child(boost)
		if node.installed.has(inst):
			var unl := Button.new()
			unl.text = "Unload"
			unl.disabled = node.busy()
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
		b.custom_minimum_size = Vector2(150, 160)
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		var cost := "—" if def["cost_bw"] == null else str(node.play_cost(inst))
		var extra := "  RAM %d" % int(def["ram"]) if def.has("ram") else ""
		var tr := "  +%d TRACE" % int(def["trace"]) if int(def.get("trace", 0)) > 0 else ""
		b.text = "%s%s\n%s · %s BW%s%s\n\n%s" % ["[CACHED] " if node.cached.has(inst["uid"]) else "", def["name"], def["type"], cost, extra, tr, def["text"]]
		b.add_theme_font_size_override("font_size", 12)
		b.add_theme_color_override("font_color", CARD_COLORS.get(def["type"], C_TEXT))
		var check: Dictionary = node.can_play(inst)
		b.disabled = not check["ok"]
		b.tooltip_text = check["reason"] if not check["ok"] else def["text"]
		b.pressed.connect(func(): node.play_card(inst["uid"], _target()))
		hand_row.add_child(b)


func _build_overlay() -> void:
	_clear(overlay_body)
	overlay.visible = true
	_margin_box(overlay_body)
	if not node.choice.is_empty():
		_overlay_choice()
	else:
		match node.phase:
			NodeRun.PHASE_READY_RIG:
				_title("READY RIG", C_ACCENT)
				_text("Your ORIGIN Ghostware: choose one Program from your deck to start installed, for free.")
				var seen := {}
				for inst in node.ready_rig_options():
					if seen.has(inst["id"]):
						continue
					seen[inst["id"]] = true
					var def: Dictionary = node.card_def(inst)
					overlay_body.add_child(_choice("%s — %s" % [def["name"], def["text"]], func(): node.ready_rig_choose(inst["uid"])))
				overlay_body.add_child(_choice("Skip", func(): node.ready_rig_choose(-1)))
			NodeRun.PHASE_LAYER_CHOICE:
				_title("LAYER %d BREACHED — GO DEEPER?" % node.layers_cleared, C_ACCENT)
				var next: Dictionary = node.layers[node.layer_index + 1]
				var names: Array = next["ice"].map(func(id): return db.ice[id]["name"])
				_text("Layer %d: %s (CRED reserve %d)" % [node.layer_index + 2, ", ".join(names), int(next["cred_reserve"])])
				overlay_body.add_child(_choice("Go deeper (better card reward odds; a full clear also earns a CAP)", func(): node.go_deeper()))
				var leave := _choice("Leave now and take the Node's card reward at %d-layer odds" % node.layers_cleared, func(): node.leave_node())
				leave.disabled = not node.can_leave()
				overlay_body.add_child(leave)
			NodeRun.PHASE_REWARD:
				_title("NODE CLEARED" if node.node_fully_cleared else "LEAVING THE NODE", C_GOOD)
				var odds: Dictionary = node.rarity_odds()
				_text("Card reward for %d layer(s) cleared (odds %d%% common / %d%% uncommon / %d%% rare):" % [
						node.layers_cleared, roundi(odds["common"] * 100), roundi(odds["uncommon"] * 100), roundi(odds["rare"] * 100)])
				for id in node.reward_options:
					var def: Dictionary = db.cards[id]
					var cost := "—" if def["cost_bw"] == null else str(int(def["cost_bw"]))
					overlay_body.add_child(_choice("%s  (%s, %s BW, %s)\n%s" % [def["name"], def["type"], cost, def["rarity"], def["text"]],
							func(): node.choose_reward(id)))
				overlay_body.add_child(_choice("Skip the card", func(): node.choose_reward("")))
			NodeRun.PHASE_COMPLETION:
				_title("FULL CLEAR: COMPLETION REWARD", C_GOOD)
				_text("Choose a CAP (%d free slot(s)). PATCHWORK isn't in this build yet." % _run().free_cap_slots())
				for id in node.completion_options:
					var b := _choice("%s — %s" % [db.caps[id]["name"], db.caps[id]["text"]], func(): node.choose_completion(id))
					b.disabled = _run().free_cap_slots() <= 0
					overlay_body.add_child(b)
				overlay_body.add_child(_choice("Skip", func(): node.choose_completion("")))
			NodeRun.PHASE_PAYLOAD:
				_title("THE PAYLOAD: AN ENCRYPTED DATA CORE", C_ACCENT)
				_text("Crack out one piece of usable tech. It's active immediately. The rest stays encrypted until you escape.")
				for id in node.payload_options:
					var g: Dictionary = db.ghostware[id]
					overlay_body.add_child(_choice("%s — %s%s" % [g["name"], g["text"], ("  ⚠ " + g["drawback"]) if g.has("drawback") else ""],
							func(): node.choose_payload(id)))
			NodeRun.PHASE_NODE_COMPLETE:
				_title("NODE FINISHED", C_GOOD)
				_text("CRED earned here: %d · total CRED %d · VITAE %d/%d · TRACE %d" % [node.cred_earned, _run().cred, _run().vitae, _run().max_vitae, _run().trace])
				if mode == "heist":
					overlay_body.add_child(_choice("Continue", heist.finish_encounter))
				else:
					overlay_body.add_child(_choice("Play again", _start_training))
					overlay_body.add_child(_choice("Main menu", _go_menu))
			NodeRun.PHASE_DEFEAT:
				_title("FLATLINED", C_ACCENT)
				_text("VITAE reached 0 on layer %d." % (node.layer_index + 1))
				if mode == "heist":
					overlay_body.add_child(_choice("See the run summary", heist.finish_encounter))
				else:
					overlay_body.add_child(_choice("Try again", _start_training))
			_:
				overlay.visible = false
	if overlay.visible:
		overlay.reset_size()
		overlay.position = (size - overlay.size) / 2


func _overlay_choice() -> void:
	var c: Dictionary = node.choice
	_title("CHOOSE", C_WARN)
	_text(c["prompt"])
	var single: bool = int(c["max"]) == 1 and int(c["min"]) == 1
	for o in c["options"]:
		var key = o["key"]
		var on := choice_picks.has(key)
		var b := _choice(("☑ " if on else "☐ ") + o["label"] if not single else o["label"], func():
			if single:
				choice_picks.clear()
				node.resolve_choice([key])
				return
			if choice_picks.has(key):
				choice_picks.erase(key)
			elif choice_picks.size() < int(c["max"]):
				choice_picks.append(key)
			_refresh())
		overlay_body.add_child(b)
	if not single:
		overlay_body.add_child(_choice("Done (%d chosen)" % choice_picks.size(), func():
			var picks := choice_picks.duplicate()
			choice_picks.clear()
			node.resolve_choice(picks)))


func _on_log(text: String) -> void:
	var color := "d8dee9"
	if text.begins_with("==") or text.begins_with("!!"):
		color = "ff3860"
	elif text.begins_with("--"):
		color = "ffb000"
	elif text.begins_with("(Not yet"):
		color = "7a8494"
	elif text.contains("CRED"):
		color = "f5d76e"
	var line := "[color=#%s]%s[/color]\n" % [color, text]
	log_box.append_text(line)
	side_log.append_text(line)


# ------------------------------------------------------------------ helpers

func _title(text: String, color: Color) -> void:
	overlay_body.add_child(_label(text, 24, color))


func _text(text: String) -> void:
	var l := _label(text, 15, C_TEXT)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size.x = 720
	overlay_body.add_child(l)


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
	b.custom_minimum_size.y = 42
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
	s.set_content_margin_all(8)
	return s


func _margin(c: Control, px: int) -> void:
	c.offset_left = px
	c.offset_top = px
	c.offset_right = -px
	c.offset_bottom = -px


func _margin_box(c: Control) -> void:
	c.add_theme_constant_override("separation", 10)


func _clear(c: Node) -> void:
	for child in c.get_children():
		c.remove_child(child)
		child.queue_free()
