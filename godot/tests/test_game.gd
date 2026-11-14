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
	test_boost_installed()
	test_void_reveal()
	test_detainer_rules()
	test_extraction_bonus()
	test_rainbow_and_toolbelt()
	test_spam_and_filter()
	test_cloak_reactive()
	test_go_deeper_keeps_programs()
	test_full_slice_path()
	if OS.get_environment("SIM") != "":
		sim_many()
	print("TESTS: %d passed, %d failed" % [passes, fails])
	quit(1 if fails > 0 else 0)

func test_opening_node() -> void:
	var g := Game.new(1)
	g.new_run()
	g.enter_node(0)
	check(g.phase == "READY_RIG", "READY RIG offered")
	g.choose_ready_rig(uid_of(g, g.draw_pile, "TUMBLER_ICEPICK"))
	check(g.phase == "PLAYER", "turn starts")
	check(g.hand.size() == 5, "draw 5")
	check(g.bw == 4, "4 BW")
	check(g.ram_used() == 1, "rig uses 1 RAM")
	# ROT-001 + DET-001: ACCEPT ALL (DETAINER TUMBLER, 1 slot of 3: −1 BW, SPAM, PULP 3);
	# REJECT ALL (TUMBLER, 2 slots of 4: DL, TRACE 3, DL, PULP 3).
	check(g.active_subs(0) == [0] and g.active_subs(1) == [0, 1], "turn 1 slots")
	check(g.response_preview()[0].effects[0].k == "BW_DRAIN", "DETAINER S1 is −1 BW")
	check(g.break_info(1, 0).reason.begins_with("LOCKED"), "BOOTING locks DEADLOCK on turn 1")
	check(g.break_info(1, 2).reason == "HIDDEN", "hidden subroutine can't be broken")
	check(g.break_info(1, 1).cost == 3, "REJECT ALL STR 4: 1 boost (2 BW) + break 1 BW")
	check(g.break_sub(1, 1), "break TRACE 3")
	check(g.bw == 1 and g.pick_str(g.installed[0]) == 4, "1 BW left, Icepick stays boosted")
	var dv := g.deadlock_view()
	check(dv.seen == 1 and dv.unseen == 4, "DEADLOCK view: 1 seen, 4 unseen (got %s)" % str(dv))
	g.end_turn()
	check(g.trace == 0, "broken TRACE didn't fire")
	check(g.enc.turn == 2 and g.bw == 3 and g.enc.bw_drained == 1, "DETAINER: −1 BW on turn 2 (bw %d)" % g.bw)
	check(g.active_subs(0) == [1] and g.active_subs(1) == [1, 2], "conveyor: one step on turn 2")
	check(g.response_preview()[1].skipped, "broken TRACE 3 stays broken in its new slot")
	check(g.break_info(1, 2).reason.begins_with("LOCKED"), "still BOOTING on turn 2")
	g.end_turn()
	check(g.bw == 4 and uid_of(g, g.draw_pile + g.hand + g.discard, "SPAM") > 0, "BW back to 4; SPAM inserted")
	check(g.enc.turn == 3 and g.active_subs(0) == [2] and g.active_subs(1) == [2, 3], "turn 3 slots")
	check(g.break_sub(1, 2), "DEADLOCK breakable on turn 3")
	check(not g.enc.breached, "a seen but unbroken DEADLOCK remains")
	g.end_turn()
	check(g.vitae == 23, "PULP 3 + PULP 4 (got %d)" % g.vitae)
	check(g.active_subs(0) == [0] and g.active_subs(1) == [3, 0], "conveyor wraps; −1 BW and first DEADLOCK return")
	g.break_sub(1, 0)
	check(g.enc.breached, "BREACH after every DEADLOCK is broken")
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
	start_node(g, 1, 0, "TUMBLER_ICEPICK")   # CAPTCHA: DISCARD 1, PULP 2, DEADLOCK
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
	start_node(g, 1, 0, "TUMBLER_ICEPICK")
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
	start_node(g, 1, 0, "TUMBLER_ICEPICK")
	g.end_turn()
	check(g.phase == "CHOICE" and g.pending.kind == "discard", "CAPTCHA DISCARD asks at the start of the next turn")
	check(g.hand.size() == 5 and g.enc.turn == 2, "the new hand is drawn first")
	g.choose(g.hand[0].uid)
	check(g.phase == "PLAYER" and g.hand.size() == 4, "discard 1, then play")
	check(g.vitae == 30, "no PULP on turn 1 (PULP 6 was hidden)")
	check(g.is_active(0, 2), "PULP 4 rotated into a slot")

func test_boost_installed() -> void:
	var g := Game.new(11)
	g.new_run()
	g.entered_corp = true
	start_node(g, 1, 0, "TUMBLER_ICEPICK")   # CAPTCHA STR 5
	var p: Dictionary = g.installed[0]
	var c := g.can_boost(p.inst.uid)
	check(c.ok and c.cost == 2, "TUMBLER Icepick boost costs 2 BW")
	check(g.boost_pick(p.inst.uid) and g.bw == 2 and g.pick_str(p) == 4, "boosted to STR 4")
	g.end_turn()
	if g.phase == "CHOICE":
		g.choose(g.hand[0].uid)
	check(g.pick_str(p) == 4, "boost lasts the encounter")

func test_void_reveal() -> void:
	var g := Game.new(12)
	g.new_run()
	g.entered_corp = true
	start_node(g, 2, 1, "VOID_ICEPICK")   # DOORBELL CAM: [TRACE 3 + DEADLOCK]
	check(g.break_info(0, 0).reason == "HIDDEN", "VOID sub hidden on turn 1")
	var pv := g.response_preview()
	check(pv.size() == 1 and pv[0].hidden, "it still fires, unseen")
	g.end_turn()
	check(g.trace == 3 and g.enc.ice[0].seen[0], "fired and revealed (trace %d)" % g.trace)
	check(g.break_info(0, 0).reason != "HIDDEN", "revealed sub breakable on turn 2 (BW permitting)")
	# HOUSE CALL (VOID, 2 subs): response 1 fires sub 1, response 2 fires subs 1 and 2
	var h := g._new_ice("HOUSE_CALL")
	g.enc.ice.push_front(h)
	check(g.active_subs(0) == [0], "black VOID: only sub 1 fires first")
	g.break_sub(1, 0)
	var v0 := g.vitae
	g.end_turn()
	check(g.vitae == v0 - 6 and h.seen[0] and not h.seen[1], "HOUSE CALL sub 1 fired and revealed (vitae %d)" % g.vitae)
	check(g.active_subs(0) == [0, 1], "then subs 1 and 2")

func test_detainer_rules() -> void:
	var total := 0
	for row in IceDB.MAP:
		for n in row:
			for L in n.get("layers", []):
				check(IceDB.detainers_in(L.ice) <= 1, "at most 1 DETAINER in %s" % n.name)
				total += IceDB.detainers_in(L.ice)
	for id in IceDB.DEFS:
		if IceDB.is_detainer(id):
			check(IceDB.is_tumbler(id) and IceDB.def(id).subs[0][0].k == "BW_DRAIN", "%s: DETAINER is a TUMBLER with −1 BW at S1" % id)
	check(total >= 1, "the slice has a DETAINER")

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
	start_node(g, 2, 1, "TUMBLER_ICEPICK")   # DOORBELL node, layer 1 DOORBELL CAM (VOID)
	g.layer = 1
	g._start_encounter()                    # CONSENT FORM + TERMS OF SERVICE
	install(g, "RAINBOW_TABLE")
	g.bw = 4
	# CONSENT FORM STR 4; RAINBOW TABLE STR 2: 2 boosts + break = 3 BW, second break on same ICE free
	var c1 := g.break_info(0, 0)
	check(c1.ok and c1.cost == 3, "rainbow first break 3 BW (got %s)" % str(c1))
	g.break_sub(0, 0)
	check(g.break_info(0, 1).cost == 0, "rainbow second break free")
	install(g, "TOOLBELT")
	g.bw = 4
	install(g, "FORTRESS_ICEPICK")
	g.bw = 4
	# TERMS OF SERVICE STR 7 vs FORTRESS Icepick STR 1: 6 boosts at 1 BW, first boost free (TOOLBELT), first break free
	var c2 := g.break_info(1, 0)
	check(c2.cost == 5, "TOOLBELT makes the first boost free (got %s)" % str(c2))

func test_spam_and_filter() -> void:
	var g := Game.new(7)
	g.new_run()
	g.enter_node(0)
	g.choose_ready_rig(uid_of(g, g.draw_pile, "TUMBLER_ICEPICK"))
	var sf := put_in_hand(g, "SPAM_FILTER")
	g.play_card(sf)
	g.end_turn()   # turn 1: ACCEPT ALL −1 BW
	g.end_turn()   # turn 2: ACCEPT ALL inserts SPAM into draw pile -> filtered to discard
	check(g.enc.spam_filter_used, "SPAM FILTER sent the SPAM to the discard pile")
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
	# FORTRESS Icepick STR 1 vs COOKIE WALL STR 5 → 4 boosts (4 BW) + free first break
	check(g.break_info(0, 1).cost == 4, "COOKIE WALL DEADLOCK costs 4 BW")
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

func sim_many() -> void:
	var done := 0
	var rows := {}
	var vit := []
	for seed in range(100, 130):
		var g := Game.new(seed)
		g.new_run()
		var guard := 0
		while g.phase != "SLICE_DONE" and g.phase != "DEAD" and guard < 3000:
			guard += 1
			match g.phase:
				"MAP": g.enter_node(g.available[g.rng.randi_range(0, g.available.size() - 1)])
				"READY_RIG": g.choose_ready_rig(bot_rig(g))
				"SAFEHOUSE": g.safehouse_heal()
				"DEEPER": g.go_deeper()
				"REWARD": g.choose_reward(g.reward_options[0])
				"CHOICE": g.choose(g.pending.get("options", [g.hand[0].uid if not g.hand.is_empty() else -1])[0])
				"PLAYER": bot_turn(g)
		if g.phase == "SLICE_DONE":
			done += 1
			vit.append(g.vitae)
		else:
			rows[g.node.get("name", "?")] = rows.get(g.node.get("name", "?"), 0) + 1
	print("  sim: %d/30 cleared; deaths by node %s; end VITAE of survivors %s" % [done, str(rows), str(vit)])

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
	# bank leftover BW into boosts (they last the encounter)
	for p in g.installed:
		if g.bw > 0 and CardDB.def(p.inst.id).has("pick") and t.has(CardDB.def(p.inst.id).pick.itype):
			while g.can_boost(p.inst.uid).ok and g.can_boost(p.inst.uid).cost > 0:
				g.boost_pick(p.inst.uid)
	g.end_turn()
