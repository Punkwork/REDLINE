extends SceneTree
## Headless rules tests. Run: godot --headless --path godot --script res://tests/test_game.gd

var fails := 0
var passes := 0

func check(cond: bool, label: String) -> void:
	if cond:
		passes += 1
	else:
		fails += 1
		print("FAIL: ", label)

func uid_of(g: Game, arr: Array, id: String) -> int:
	for c in arr:
		if c.id == id:
			return c.uid
	return -1

func put_in_hand(g: Game, id: String) -> int:
	## Move a card with this id from any pile into the hand (or create it) for deterministic tests.
	for a in [g.draw_pile, g.discard]:
		for i in a.size():
			if a[i].id == id:
				var c = a[i]
				a.remove_at(i)
				g.hand.append(c)
				return c.uid
	var inst := g._new_inst(id)
	g.hand.append(inst)
	return inst.uid

func install(g: Game, id: String) -> void:
	var u := put_in_hand(g, id)
	g.bw += CardDB.def(id).bw
	check(g.play_card(u), "install " + id)

func _init() -> void:
	test_opening_node()
	test_shield_and_pulp()
	test_trace_strikes()
	test_captcha_discard()
	test_extraction_bonus()
	test_rainbow_and_toolbelt()
	test_spam_and_filter()
	test_cloak_reactive()
	test_go_deeper_keeps_programs()
	test_full_slice_path()
	print("TESTS: %d passed, %d failed" % [passes, fails])
	quit(1 if fails > 0 else 0)

func test_opening_node() -> void:
	var g := Game.new(1)
	g.new_run()
	g.enter_node(0)
	check(g.phase == "READY_RIG", "READY RIG offered")
	g.choose_ready_rig(uid_of(g, g.draw_pile, "SIGYL_ICEPICK"))
	check(g.phase == "PLAYER", "turn starts")
	check(g.hand.size() == 5, "draw 5")
	check(g.bw == 4, "4 BW")
	check(g.ram_used() == 1, "rig uses 1 RAM")
	# BOOTING: REJECT ALL's DEADLOCK locked before turn 3.
	var info := g.break_info(1, 1)
	check(not info.ok and info.reason.begins_with("LOCKED"), "BOOTING locks DEADLOCK on turn 1")
	# ACCEPT ALL STR 3 vs SIGYL Icepick STR 3: break 1 BW.
	check(g.break_info(0, 0).cost == 1, "break ACCEPT ALL [S1] for 1 BW")
	check(g.break_sub(0, 0), "break ACCEPT ALL [S1]")
	check(g.break_sub(0, 1), "break ACCEPT ALL [S2]")
	check(g.bw == 2, "2 BW left")
	# preview: ACCEPT ALL skipped twice, REJECT ALL TRACE 2 then DEADLOCK
	var pv := g.response_preview()
	check(pv.size() == 4 and pv[0].skipped and pv[1].skipped and not pv[2].skipped, "response preview order")
	g.end_turn()
	check(g.trace == 2, "REJECT ALL TRACE 2 resolved (got %d)" % g.trace)
	check(g.enc.turn == 2, "turn 2")
	check(not g.break_info(1, 1).ok, "still BOOTING on turn 2")
	g.end_turn()
	check(g.enc.turn == 3, "turn 3")
	check(g.break_info(1, 1).ok, "DEADLOCK breakable on turn 3")
	g.break_sub(1, 1)
	check(g.enc.breached, "BREACH")
	var t := g.trace
	g.end_turn()
	check(g.trace == t, "response skipped after BREACH")
	check(g.phase == "REWARD" and g.reward_options.size() == 3, "card reward 1 of 3")
	check(g.reward_note != "", "full clear noted")
	var pick: String = g.reward_options[0]
	g.choose_reward(pick)
	check(g.run_deck.size() == 13, "reward added to deck")
	check(g.phase == "MAP" and g.row == 0, "back to map")

func start_node(g: Game, row: int, idx: int, rig: String) -> void:
	g.row = row - 1
	g.available = [idx]
	g.enter_node(idx)
	if g.phase == "READY_RIG":
		g.choose_ready_rig(uid_of(g, g.draw_pile, rig))

func test_shield_and_pulp() -> void:
	var g := Game.new(2)
	g.new_run()
	g.entered_corp = true
	start_node(g, 1, 0, "SIGYL_ICEPICK")   # CAPTCHA: DISCARD 1, PULP 2, DEADLOCK
	var u := put_in_hand(g, "PULP_SHIELD")
	g.play_card(u)
	check(g.shield == 3, "+3 SHIELD")
	g.take_pulp(2)
	check(g.shield == 1 and g.vitae == 30, "SHIELD absorbs PULP")
	g.take_pulp(4)
	check(g.shield == 0 and g.vitae == 27, "overflow to VITAE")

func test_trace_strikes() -> void:
	var g := Game.new(3)
	g.new_run()
	g.entered_corp = true
	start_node(g, 1, 0, "SIGYL_ICEPICK")
	g.add_trace(40, false)
	check(g.strikes == 1 and g.trace == 20, "strike 1, TRACE to 20")
	check(uid_of(g, g.draw_pile, "TRACER") > 0, "TRACER in draw pile")
	g.add_trace(20, false)
	check(g.strikes == 2 and g.enc.ice[0].id == "HOUSE_CALL", "strike 2: HOUSE CALL on the left")
	g.add_trace(20, false)
	check(g.strikes == 3 and g.trace == 10 and g.lockdown, "strike 3: LOCKDOWN, TRACE 10")
	var tu := put_in_hand(g, "TRACER")
	var before := g.trace
	g.end_turn()
	check(g.trace >= before + 3, "TRACER in hand adds 3 TRACE")

func test_captcha_discard() -> void:
	var g := Game.new(4)
	g.new_run()
	g.entered_corp = true
	start_node(g, 1, 0, "SIGYL_ICEPICK")
	var n := g.hand.size()
	g.end_turn()
	check(g.phase == "CHOICE" and g.pending.kind == "discard", "CAPTCHA DISCARD asks for a choice")
	g.choose(g.hand[0].uid)
	check(g.phase == "PLAYER", "response continues after choice")
	check(g.vitae == 28, "CAPTCHA PULP 2 after the discard (got %d)" % g.vitae)

func test_extraction_bonus() -> void:
	var g := Game.new(5)
	g.new_run()
	g.entered_corp = true
	start_node(g, 1, 0, "BASIC_EXTRACTOR")   # reserve 10
	g.end_turn()
	if g.phase == "CHOICE":
		g.choose(g.hand[0].uid)
	check(g.cred == 5, "extract 5 (got %d)" % g.cred)
	g.end_turn()
	if g.phase == "CHOICE":
		g.choose(g.hand[0].uid)
	check(g.cred == 11 and g.enc.reserve == 0, "reserve emptied + 10%% bonus (got %d)" % g.cred)

func test_rainbow_and_toolbelt() -> void:
	var g := Game.new(6)
	g.new_run()
	g.entered_corp = true
	start_node(g, 2, 1, "SIGYL_ICEPICK")   # DOORBELL node, layer 1 DOORBELL CAM (VOID)
	g.layer = 1
	g._start_encounter()                    # CONSENT FORM + TERMS OF SERVICE
	install(g, "RAINBOW_TABLE")
	g.bw = 4
	# CONSENT FORM STR 2; RAINBOW TABLE STR 2 break 1 BW, second break on same ICE free
	var c1 := g.break_info(0, 0)
	check(c1.ok and c1.cost == 1, "rainbow first break 1 BW (got %s)" % str(c1))
	g.break_sub(0, 0)
	check(g.break_info(0, 1).cost == 0, "rainbow second break free")
	install(g, "TOOLBELT")
	g.bw = 4
	install(g, "FORTRESS_ICEPICK")
	g.bw = 4
	# TERMS OF SERVICE STR 5 vs FORTRESS Icepick STR 1: 4 boosts at 1 BW, first boost free (TOOLBELT), first break free
	var c2 := g.break_info(1, 0)
	check(c2.cost == 3, "TOOLBELT makes the first boost free (got %s)" % str(c2))

func test_spam_and_filter() -> void:
	var g := Game.new(7)
	g.new_run()
	g.enter_node(0)
	g.choose_ready_rig(uid_of(g, g.draw_pile, "SIGYL_ICEPICK"))
	var sf := put_in_hand(g, "SPAM_FILTER")
	g.play_card(sf)
	g.end_turn()   # ACCEPT ALL inserts SPAM into draw pile -> filtered to discard
	check(uid_of(g, g.discard, "SPAM") > 0 or uid_of(g, g.hand, "SPAM") > 0, "SPAM FILTER sends SPAM to discard")
	var sp := put_in_hand(g, "SPAM")
	var bw0 := g.bw
	g.play_card(sp)
	check(g.bw == bw0 - 1 and uid_of(g, g.burned, "SPAM") > 0, "SPAM cleared for 1 BW, BURNED")

func test_cloak_reactive() -> void:
	var g := Game.new(8)
	g.new_run()
	g.entered_corp = true
	start_node(g, 2, 1, "VOID_ICEPICK")   # DOORBELL CAM
	var u := put_in_hand(g, "PULP_SHIELD")
	g.play_card(u)
	check(g.trace == 1, "DOORBELL CAM: CLOAK card adds TRACE 1")

func test_go_deeper_keeps_programs() -> void:
	var g := Game.new(9)
	g.new_run()
	g.entered_corp = true
	start_node(g, 1, 1, "FORTRESS_ICEPICK")   # COOKIE WALL (FORTRESS 3) then CONSENT FORM
	# FORTRESS Icepick STR 1 → 2 boosts (2 BW) + free first break
	check(g.break_info(0, 1).cost == 2, "COOKIE WALL DEADLOCK costs 2 BW")
	g.break_sub(0, 1)
	check(g.enc.breached, "COOKIE WALL breached")
	g.end_turn()
	check(g.phase == "DEEPER", "go deeper or leave")
	g.go_deeper()
	check(g.layer == 1 and g.installed.size() == 1 and g.installed[0].boost == 0, "programs stay, boosts reset")
	check(g.enc.ice[0].id == "CONSENT_FORM", "layer 2 ICE")

func test_full_slice_path() -> void:
	## A simple bot plays the whole slice: break the cheapest subroutines, prioritising DEADLOCKs.
	var g := Game.new(10)
	g.new_run()
	var guard := 0
	while g.phase != "SLICE_DONE" and g.phase != "DEAD" and guard < 2000:
		guard += 1
		match g.phase:
			"MAP": g.enter_node(g.available[0])
			"READY_RIG": g.choose_ready_rig(bot_rig(g))
			"SAFEHOUSE": g.safehouse_heal()
			"DEEPER": g.go_deeper()
			"REWARD": g.choose_reward(g.reward_options[0])
			"CHOICE": g.choose(g.pending.get("options", [g.hand[0].uid if not g.hand.is_empty() else -1])[0])
			"PLAYER": bot_turn(g)
	check(g.phase == "SLICE_DONE" or g.phase == "DEAD", "bot finishes the slice (phase %s, row %d)" % [g.phase, g.row])
	print("  bot: phase=%s vitae=%d trace=%d strikes=%d cred=%d deck=%d steps=%d" % [g.phase, g.vitae, g.trace, g.strikes, g.cred, g.run_deck.size(), guard])

func needed_types(g: Game) -> Array:
	var t := []
	for L in g.node.layers:
		for id in L.ice:
			t.append(IceDB.def(id).type)
	return t

func bot_rig(g: Game) -> int:
	var t := needed_types(g)
	for u in g.pending.options:
		var d := CardDB.def(g._find(g.draw_pile, u).id)
		if d.has("pick") and (t.has(d.pick.itype) or d.pick.itype == "ANY"):
			return u
	return g.pending.options[0]

func bot_turn(g: Game) -> void:
	# install the Icepicks this Node needs, play probes and shields, then break what it can.
	var t := needed_types(g)
	t.append("VOID")  # HOUSE CALL
	for c in g.hand.duplicate():
		var d := CardDB.def(c.id)
		if d.has("pick") and (t.has(d.pick.itype) or d.pick.itype == "ANY") and g.can_play(c.uid).ok:
			g.play_card(c.uid)
	for c in g.hand.duplicate():
		if c.id == "PROBE" and g.can_play(c.uid).ok:
			g.play_card(c.uid, g.enc.ice.size() - 1)
	var progress := true
	while progress:
		progress = false
		for i in g.enc.ice.size():
			var subs: Array = IceDB.def(g.enc.ice[i].id).subs
			for s in subs.size():
				if g.break_info(i, s).ok:
					g.break_sub(i, s)
					progress = true
	for c in g.hand.duplicate():
		if c.id == "PULP_SHIELD" and g.can_play(c.uid).ok:
			g.play_card(c.uid)
	g.end_turn()
