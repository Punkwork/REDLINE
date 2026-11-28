extends RefCounted
## STRIP-001 core-loop rules checks (docs/REDLINE_CORE_LOOP.md). Called from test_game.gd when Game.CORE_LOOP is true.

var t   # the test_game.gd runner (check, uid_of, put_in_hand)

func run(runner) -> void:
	t = runner
	test_turn_and_costs()
	test_parting_shot()
	test_turn_001_draw()
	test_void_probe_reveal()
	test_pool_and_data()
	test_forms()
	test_sub_001()
	test_defrag_amend()
	test_riders()

func opening(seed_value: int) -> Game:
	var g := Game.new(seed_value)
	g.new_run()
	g.enter_node(0)
	g.choose_ready_rig(t.uid_of(g, g.draw_pile, "TUMBLER_ICEPICK"))
	return g

func test_turn_and_costs() -> void:
	var g := opening(1)
	t.check(g.bw == 3, "BW-001: 3 BW per turn (got %d)" % g.bw)
	t.check(g.hand.size() == Game.BASE_DRAW, "turn 1 draws 6")
	var pick: Dictionary = g.installed[0]
	t.check(g.pick_str(pick) == 2, "STR-001: starter Icepick STR 2")
	t.check(IceDB.def("REJECT_ALL").str == 6 and not IceDB.def("REJECT_ALL").has("ability"), "STR-001: REJECT ALL STR 6, no BOOTING")
	# PROBE-001 / PROBE-003
	var p1: int = t.put_in_hand(g, "PROBE")
	t.check(g.card_cost("PROBE", p1, 1) == 0, "PROBE-001: first PROBE on an ICE costs 0")
	t.check(g.play_card(p1, 1) and g.bw == 3, "first PROBE played for 0 BW")
	var p2: int = t.put_in_hand(g, "PROBE")
	t.check(g.card_cost("PROBE", p2, 1) == 1, "PROBE-003: second PROBE on the same ICE costs 1")
	t.check(g.card_cost("PROBE", p2, 0) == 0, "PROBE-003: a PROBE on another ICE still costs 0")
	t.check(g.play_card(p2, 1) and g.bw == 2, "second PROBE on the same ICE paid 1 BW")
	t.check(g.ice_str(1) == 2, "two PROBEs: STR 6 → 2")
	# BURST-001
	g.bw = 3
	var b: int = t.put_in_hand(g, "BURST")
	t.check(g.card_cost("BURST", b) == 3, "BURST-001: costs 3")
	t.check(g.play_card(b) and g.bw == 5, "BURST-001: 3 BW → 5 BW")
	t.check(g.discard.any(func(c): return c.uid == b), "BURST is not BURNED")
	t.check(g.card_cost("BURST", b) == 4, "BURST-001: the same copy now costs 4")
	var b2 := g._new_inst("BURST")
	t.check(g.card_cost("BURST", b2.uid) == 3, "BURST-001: another copy keeps its own count")
	# PROBE count resets next turn
	g.end_turn()
	if g.phase == "CHOICE":
		g.choose(g.hand[0].uid)
	var p3: int = t.put_in_hand(g, "PROBE")
	t.check(g.card_cost("PROBE", p3, 1) == 0, "PROBE-003: the count resets each turn")

func test_parting_shot() -> void:
	var g := opening(2)
	# REJECT ALL: 1 slot; its first PULP 2 guards the DEADLOCK. Break the guard, then the DEADLOCK.
	g.bw = 20
	t.check(g.break_sub(1, 0), "break REJECT ALL's guard (PULP 2)")
	t.check(g.active_subs(1) == [1], "TUMBLE-001: the DEADLOCK tumbles into the slot at once")
	t.check(g.break_sub(1, 1) and g.enc.breached, "break the DEADLOCK: BREACH")
	var v := g.vitae
	g.shield = 0
	var showing := 0
	for st in g.response_preview():
		if not st.skipped and not st.hidden:
			for e in st.effects:
				if e.k == "PULP": showing += int(e.v)
	g.end_turn()
	t.check(showing > 0 and v - g.vitae == showing, "BREACH-001: every unbroken showing PULP (%d) fires as a parting shot (lost %d)" % [showing, v - g.vitae])
	t.check(g.phase in ["REWARD", "DEEPER", "MAP"], "encounter ends after the parting shot")

func test_turn_001_draw() -> void:
	var g := opening(3)
	g.enc["jammer"] = 9   # keep TRACE riders (DISCARD) out of this count
	var drawn_before := g.draw_pile.size() + g.discard.size() + g.hand.size()
	g.end_turn()
	if g.phase == "CHOICE":
		g.choose(g.hand[0].uid)
	t.check(g.enc.turn == 2 and g.phase == "PLAYER", "turn 2 starts")
	t.check(g.hand.size() == Game.BASE_DRAW, "TURN-001: one 6-card hand, drawn before the response (got %d)" % g.hand.size())
	t.check(g.draw_pile.size() + g.discard.size() + g.hand.size() == drawn_before, "no extra draw at turn start")

func test_void_probe_reveal() -> void:
	var g := Game.new(4)
	g.new_run()
	g.row = 1
	g.available = [1]
	g.enter_node(1)   # DOORBELL
	if g.phase == "READY_RIG":
		g.choose_ready_rig(t.uid_of(g, g.draw_pile, "VOID_ICEPICK"))
	t.check(g.enc.ice[0].id == "DOORBELL_CAM", "DOORBELL CAM encounter")
	t.check(not g.enc.ice[0].seen[0], "VOID starts face-down")
	# PROBE-004a (CSA-04b) supersedes STRIP-001's "a PROBE on a VOID reveals its top face-down sub":
	# PROBE is choose-one, and its reveal mode reveals every hidden subroutine. Full spec: test_spec_probe.gd.
	var p: int = t.put_in_hand(g, "PROBE")
	g.play_card(p, 0)
	t.check(not g.enc.ice[0].seen[0], "PROBE-004a: PROBE's −2 STR mode reveals nothing")
	var p2: int = t.put_in_hand(g, "PROBE")
	g.play_card(p2, 0, "reveal")
	t.check(g.enc.ice[0].seen[0] and g.enc.ice[0].seen[1] and g.sub_breakable(0, 0) and g.sub_breakable(0, 1),
		"PROBE-004a: the reveal mode reveals every hidden subroutine; they are breakable")

func test_pool_and_data() -> void:
	for id in CardDB.CORE_POOL:
		t.check(CardDB.DEFS.has(id), "CORE_POOL card exists: " + id)
	for rar in ["COMMON", "UNCOMMON", "RARE"]:
		for pool in ["SHARED", "GENERALIST"]:
			for id in CardDB.reward_pool(pool, rar):
				t.check(CardDB.CORE_POOL.has(id), "reward pool only offers core cards (%s)" % id)
	t.check(not CardDB.reward_pool("SHARED", "COMMON").is_empty() and not CardDB.reward_pool("GENERALIST", "COMMON").is_empty(), "core reward pools are not empty")
	for id in IceDB.DEFS:
		var d: Dictionary = IceDB.DEFS[id]
		if d.tier in ["OPENING", "T1", "BLACK"]:
			t.check(not d.has("passive") and not d.has("ability"), "STRIP-001: %s has no passive" % id)
			for sub in d.subs:
				for e in sub:
					t.check(e.k != "PULP_CURVE", "STRIP-001: %s has fixed PULP" % id)

func test_forms() -> void:
	## FORM-001: WARY below half STR; LETHAL below half STR with half the subroutines broken (rounded up).
	var g := opening(5)
	g.bw = 20
	t.check(g.ice_form(1) == "CHEERY", "FORM-001: REJECT ALL starts CHEERY")
	g.play_card(t.put_in_hand(g, "PROBE"), 1)
	g.play_card(t.put_in_hand(g, "PROBE"), 1)
	t.check(g.ice_str(1) == 2 and g.ice_form(1) == "WARY", "FORM-001: STR 2 of 6 is WARY")
	t.check(g.break_sub(1, 0), "break REJECT ALL's guard")
	t.check(g.ice_form(1) == "WARY", "one of three broken: still WARY")
	# Break ACCEPT ALL to 2 of 3 without reducing its STR: it stays WARY-free (STR is full)
	t.check(g.break_sub(1, 1) and g.ice_form(1) == "LETHAL", "FORM-001: two of three broken below half STR: LETHAL")
	var e: Dictionary = g.effect_value(g.enc.ice[1], {"k": "PULP", "v": 3})
	t.check(e.v == 6, "FORM-001: LETHAL doubles PULP (3 → %d)" % e.v)
	var tr: Dictionary = g.effect_value(g.enc.ice[1], {"k": "TRACE", "v": 3})
	t.check(tr.v == 6, "FORM-001: LETHAL doubles TRACE")
	g.enc.ice.push_front(g._new_ice("HOUSE_CALL"))
	g.enc.ice[0].str_mod = -9
	g.enc.ice[0].broken[0] = true
	g._sync_strengths()
	t.check(g.ice_form(0) == "LETHAL" and not g.enc.ice[0].get("lethal", false), "Black ICE show the LETHAL form")
	t.check(g.effect_value(g.enc.ice[0], {"k": "PULP", "v": 5}).v == 5, "Black ICE never deal double")
	

func test_sub_001() -> void:
	var g := opening(6)
	g.bw = 20
	# BOOST-001: boosts end with the turn
	var pick: Dictionary = g.installed[0]
	g.boost_pick(pick.inst.uid)
	t.check(g.pick_str(pick) == 3, "boost +1 this turn")
	g.end_turn()
	if g.phase == "CHOICE": g.choose(g.hand[0].uid)
	t.check(g.pick_str(g.installed[0]) == 2, "BOOST-001: boost gone next turn")
	# HARDEN, SHIELD_BREAK, RETALIATE
	var ice: Dictionary = g.enc.ice[1]
	var before := g.ice_str(1)
	g.acting_ice = ice
	g._apply_effect({"k": "HARDEN", "v": 1})
	t.check(g.ice_str(1) == before + 1, "SUB-001: HARDEN +1 STR")
	g.shield = 5
	g._apply_effect({"k": "SHIELD_BREAK"})
	t.check(g.shield == 0, "SUB-001: SHIELD BREAK")
	ice.broken[0] = true
	var r: Dictionary = g.effect_value(ice, {"k": "RETALIATE", "v": 2})
	t.check(r.dmg == 2, "SUB-001: RETALIATE 2 with one broken = PULP 2")
	ice["lethal"] = true
	t.check(g.effect_value(ice, {"k": "RETALIATE", "v": 2}).dmg == 4, "LETHAL doubles RETALIATE")
	var v := g.vitae
	g.shield = 0
	g._apply_effect(g.effect_value(ice, {"k": "RETALIATE", "v": 2}))
	t.check(v - g.vitae == 4, "RETALIATE deals its PULP")

func test_defrag_amend() -> void:
	var g := opening(8)
	g.bw = 5
	var d: int = t.put_in_hand(g, "DEFRAG")
	var n := g.hand.size()
	t.check(g.play_card(d) and g.phase == "CHOICE" and g.pending.kind == "discard", "DEFRAG-001: asks for a discard")
	g.choose(g.hand[0].uid)
	t.check(g.phase == "PLAYER" and g.hand.size() == n - 2 + 2, "DEFRAG-001: discard 1, then draw 2 (hand %d)" % g.hand.size())
	# AMEND-001 on the final Node
	var h := Game.new(9)
	h.new_run()
	h.row = 2
	h.available = [0]
	h.enter_node(0)
	if h.phase == "READY_RIG":
		h.choose_ready_rig(t.uid_of(h, h.draw_pile, "FORTRESS_ICEPICK"))
	t.check(h.enc.ice.map(func(i): return i.id) == ["CONSENT_FORM", "TERMS_OF_SERVICE"], "AMEND-001: CONSENT FORM supports TERMS OF SERVICE")
	h.acting_ice = h.enc.ice[0]
	h._apply_effect({"k": "AMEND", "v": 2})
	t.check(h.effect_value(h.enc.ice[1], {"k": "PULP", "v": 4}).v == 6, "AMEND +2 on the ICE to its right")
	h.response_finish()
	t.check(h.effect_value(h.enc.ice[1], {"k": "PULP", "v": 4}).v == 4, "AMEND lasts one response")

func test_riders() -> void:
	var g := opening(10)
	g.acting_ice = g.enc.ice[1]
	var n := g.hand.size()
	var rider := {"k": "TRACE", "v": 2, "then": [{"k": "DISCARD", "v": 1}]}
	g._apply_effect(rider)
	t.check(g.enc.pending_discard == 1, "RIDER-001: TRACE lands, so its DISCARD rider happens")
	g.enc.pending_discard = 0
	g.enc["jammer"] = 2
	var tr := g.trace
	g._apply_effect(rider)
	t.check(g.trace == tr and g.enc.pending_discard == 0, "JAMMER: TRACE adds 0 and the rider doesn't happen")
	t.check(CardDB.CORE_POOL.has("JAMMER"), "JAMMER is a core reward")
