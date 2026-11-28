extends SceneTree
## MAP-003f / UPLINK-SPEC-001 screens: the V2 map board and the Uplink room draw the Game's state and
## act through one Game call each. Expectations from UPLINK-SPEC-001 (sold slots visible and
## unavailable; full CAP rack asks for a replacement; cancel changes nothing; exit to map) and the map
## (only the Nodes you can enter now are open).

var passed := 0
var failed := 0

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	call_deferred("run")

func frames(n := 3) -> void:
	for i in n: await process_frame

func run() -> void:
	root.size = Vector2i(1600, 1000)
	await map_board()
	await uplink_room()
	print("MAP + UPLINK UI: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

func map_board() -> void:
	var g := Game.new(5)
	g.new_run("GENERALIST")
	g.use_generated_map(2)
	var m := NodeMapScreen.new()
	root.add_child(m)
	await frames()
	m.attach(g)
	check(m.pins.size() == 16, "one column of pins per map row (16)")
	var total := 0
	for r in m.pins.size(): total += m.pins[r].size()
	var nodes := 0
	for row in g.map_rows: nodes += row.size()
	check(total == nodes, "one pin per Node (%d)" % nodes)
	var open := []
	for r in m.pins.size():
		for p in m.pins[r]:
			if p.open: open.append([r, p.index])
	check(open == [[0, 0]], "a new run: only the Opening Node is open")
	var chosen := []
	m.node_chosen.connect(func(i): chosen.append(i))
	var ev := InputEventMouseButton.new(); ev.button_index = MOUSE_BUTTON_LEFT; ev.pressed = true
	m.pins[1][0]._gui_input(ev)
	check(chosen.is_empty(), "a locked Node can't be chosen")
	m.pins[0][0]._gui_input(ev)
	check(chosen == [0], "an open Node is chosen by click")
	m.pins[0][0].grab_focus()
	m.inspector.advance(0.5)
	await frames()
	var words := m.inspector.find_children("*", "Label", true, false).map(func(l): return String(l.text))
	check(words.has("COOKIE BANNER"), "hover/focus names the Node")
	m.queue_free()

func uplink_room() -> void:
	var g := Game.new(21)
	g.new_run("GENERALIST")
	g.use_generated_map(0)
	for ri in g.map_rows.size():
		for i in g.map_rows[ri].size():
			if g.phase == "MAP" and g.map_rows[ri][i].kind == "UPLINK":
				g.row = ri - 1; g.available = [i]; g.enter_node(i)
	check(g.phase == "UPLINK", "in the Uplink")
	g.cred = 200
	var room := UplinkRoom.new()
	root.add_child(room)
	await frames()
	room.attach(g)
	check(room.card_views.filter(func(c): return c.visible).size() == 8, "8 cards on the wall")
	check(room.cap_slots.size() == 3 and room.ghost_slots.size() == 3, "3 CAP sockets and 3 Ghostware medallions")
	var price := int(g.uplink.cards[0].price)
	room._buy_card(0)
	check(g.cred == 200 - price and g.uplink.cards[0].sold, "a click on a card buys it (one Game call)")
	check(room.card_tags[0].text == "SOLD" and room.card_views[0].visible, "the sold card stays on the wall, marked SOLD")
	check(room.cred_label.text == "CRED %d" % g.cred, "the ledger shows the new CRED")
	var before := g.cred
	room._buy_card(0)
	check(g.cred == before, "a sold card can't be bought again")
	# Full CAP rack: the replacement dialog; cancel changes nothing.
	for k in 3:
		g.caps.append({"uid": g.next_uid, "id": "FLUSH"}); g.next_uid += 1
	var caps_before := g.caps.duplicate(true)
	room._buy_cap(0)
	await frames()
	check(room.dialog != null and is_instance_valid(room.dialog), "a full CAP rack opens the replacement dialog")
	room._close_dialog()
	check(g.caps == caps_before and g.cred == before and not g.uplink.caps[0].sold, "cancel changes nothing")
	# Clinic.
	g.cortex = 2
	room._open_clinic()
	await frames()
	check(room.dialog != null, "the Clinic opens from the grille")
	room._close_dialog()
	var left := []
	room.leave_requested.connect(func(): left.append(true))
	room.find_child("Leave", true, false).pressed.emit()
	check(left == [true], "LEAVE asks to go back to the map")
	room.queue_free()
