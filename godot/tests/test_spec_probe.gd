extends SceneTree
## CSA-04b spec test: PROBE as approved (PROBE-004a, designer 2026-11-27; restated 20:27):
##   "0 BW. Choose one: −2 STR on the target ICE or reveal (all) hidden subroutines on a target VOID.
##    Probe costs +1 BW for each Probe already played on target ICE this turn." Counter per ICE (Q6).
## Every expectation below is a literal from that text, never read from cards.json or the engine.
## B1–B9 follow docs/architecture-v2/CANONICAL_SOURCE_ARCHITECTURE.md §6.

var passed := 0
var failed := 0

const APPROVED_TEXT := "Choose one: Target ICE: −2 STR this encounter. OR Target VOID: Reveal all hidden subroutines. Costs 1 additional BW for each PROBE already played on the target ICE this turn."

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	b1_weaken_does_not_reveal()
	b2_reveal_all_without_weakening()
	b3_targeting()
	b4_reveal_unavailable_when_nothing_hidden()
	b5_shared_escalation_across_modes_and_copies()
	b6_independent_counter_per_ice()
	b7_reset_next_rustler_turn()
	b8_cancellation_changes_nothing()
	b9_insufficient_bw()
	a1_text_and_record()
	print("SPEC PROBE: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

# --- fixtures ---------------------------------------------------------------------------------

func void_encounter(seed_value: int = 1) -> Game:
	## DOORBELL CAM: a VOID whose subroutines start hidden (STRIP-001).
	var g := Game.new(seed_value)
	g.new_run()
	g.enter_node(0)
	g.choose_ready_rig(g.draw_pile.filter(func(c): return c.id == "TUMBLER_ICEPICK")[0].uid)
	g.new_run()
	g.row = 1
	g.available = [1]
	g.enter_node(1)
	if g.phase == "READY_RIG":
		g.choose_ready_rig(g.draw_pile.filter(func(c): return c.id == "VOID_ICEPICK")[0].uid)
	return g

func hand(g: Game, id: String) -> int:
	var c: Dictionary = g._new_inst(id)
	g.hand.append(c)
	return int(c.uid)

func hidden(g: Game, i: int) -> int:
	var n := 0
	for s in g.enc.ice[i].seen.size():
		if not g.enc.ice[i].seen[s] and not g.enc.ice[i].broken[s]: n += 1
	return n

func state(g: Game) -> String:
	var ice := []
	for x in g.enc.get("ice", []):
		ice.append([x.id, x.broken, x.seen, x.get("str_mod", 0), x.get("reveal", 0)])
	return JSON.stringify({"phase": g.phase, "bw": g.bw, "trace": g.trace, "hand": g.hand.map(func(c): return c.uid),
		"discard": g.discard.map(func(c): return c.uid), "burned": g.burned.map(func(c): return c.uid), "ice": ice,
		"probes": str(g.enc.get("probes", null)), "pending": g.pending})

# --- B1–B9 ------------------------------------------------------------------------------------

func b1_weaken_does_not_reveal() -> void:
	var g := void_encounter()
	var h0 := hidden(g, 0); var s0 := g.ice_str(0)
	check(h0 > 0, "B1 setup: the VOID starts with hidden subroutines")
	check(g.play_card(hand(g, "PROBE"), 0, "weaken"), "B1 PROBE plays in the −2 STR mode")
	check(g.ice_str(0) == s0 - 2, "B1 target ICE −2 STR (was %d, now %d)" % [s0, g.ice_str(0)])
	check(hidden(g, 0) == h0, "B1 the STR mode reveals nothing (hidden %d → %d)" % [h0, hidden(g, 0)])
	var g2 := void_encounter()
	g2.play_card(hand(g2, "PROBE"), 0)
	check(hidden(g2, 0) == h0 and g2.ice_str(0) == s0 - 2, "B1 with no mode given, PROBE uses −2 STR and reveals nothing")

func b2_reveal_all_without_weakening() -> void:
	var g := void_encounter()
	var s0 := g.ice_str(0)
	check(g.play_card(hand(g, "PROBE"), 0, "reveal"), "B2 PROBE plays in the reveal mode on a VOID")
	check(hidden(g, 0) == 0, "B2 every hidden subroutine is revealed (left hidden: %d)" % hidden(g, 0))
	check(g.ice_str(0) == s0, "B2 the reveal mode does not change STR (was %d, now %d)" % [s0, g.ice_str(0)])

func b3_targeting() -> void:
	var g := void_encounter()
	check(g.play_modes("PROBE", 0) == ["weaken", "reveal"], "B3 on a VOID with hidden subroutines both modes are offered")
	var g2 := void_encounter()
	var twin: Dictionary = g2._new_ice("REJECT_ALL")   # a FORTRESS
	g2.enc.ice.append(twin)
	var f: int = g2.enc.ice.size() - 1
	check(g2.play_modes("PROBE", f) == ["weaken"], "B3 on a non-VOID only the STR mode is offered")
	var before := state(g2)
	check(not g2.play_card(hand(g2, "PROBE"), f, "reveal"), "B3 the reveal mode is refused on a non-VOID")
	g2.hand.pop_back()
	check(state(g2) == before, "B3 a refused reveal changes nothing")
	var g3 := void_encounter()
	var b := state(g3)
	var u := hand(g3, "PROBE")
	check(not g3.play_card(u, -1), "B3 PROBE needs an ICE target")
	g3.hand.pop_back()
	check(state(g3) == b, "B3 a PROBE with no target changes nothing")

func b4_reveal_unavailable_when_nothing_hidden() -> void:
	var g := void_encounter()
	g.play_card(hand(g, "PROBE"), 0, "reveal")
	check(g.play_modes("PROBE", 0) == ["weaken"], "B4 once nothing is hidden only the STR mode is offered")
	var before := state(g)
	var u := hand(g, "PROBE")
	check(not g.play_card(u, 0, "reveal"), "B4 a forced reveal is refused")
	g.hand.pop_back()
	check(state(g) == before, "B4 a refused reveal changes nothing (no BW, no count)")

func b5_shared_escalation_across_modes_and_copies() -> void:
	var g := void_encounter()
	g.bw = 9
	var a := hand(g, "PROBE"); var b := hand(g, "PROBE"); var c := hand(g, "PROBE")
	check(g.card_cost("PROBE", a, 0) == 0, "B5 first PROBE on the ICE costs 0 BW")
	g.play_card(a, 0, "weaken")
	check(g.card_cost("PROBE", b, 0) == 1, "B5 second costs 1 BW after a −2 STR PROBE")
	var bw0 := g.bw
	g.play_card(b, 0, "reveal")
	check(g.bw == bw0 - 1, "B5 the reveal mode paid the escalated 1 BW")
	check(g.card_cost("PROBE", c, 0) == 2, "B5 third costs 2 BW: both modes share one count")

func b6_independent_counter_per_ice() -> void:
	var g := void_encounter()
	var twin: Dictionary = g._new_ice(String(g.enc.ice[0].id))   # a second copy of the same ICE
	g.enc.ice.append(twin)
	var t: int = g.enc.ice.size() - 1
	var a := hand(g, "PROBE"); var b := hand(g, "PROBE")
	g.play_card(a, 0, "weaken")
	check(g.card_cost("PROBE", b, 0) == 1, "B6 a second PROBE on the same ICE costs 1 BW")
	check(g.card_cost("PROBE", b, t) == 0, "B6 a PROBE on another copy of the same ICE still costs 0 BW (per ICE, Q6)")

func b7_reset_next_rustler_turn() -> void:
	var g := void_encounter()
	var a := hand(g, "PROBE")
	g.play_card(a, 0, "weaken")
	var b := hand(g, "PROBE")
	check(g.card_cost("PROBE", b, 0) == 1, "B7 the count holds within the turn")
	g.end_turn()
	var guard := 0
	while g.phase != "PLAYER" and guard < 50:
		if g.phase == "RESPONSE" and g.has_method("response_step"): g.response_step()
		elif g.phase == "RESPONSE": break
		else: break
		guard += 1
	if g.phase == "PLAYER":
		check(g.card_cost("PROBE", b, 0) == 0, "B7 the count resets at the start of the next Rustler turn")
	else:
		check(false, "B7 could not reach the next Rustler turn (phase %s)" % g.phase)

func b8_cancellation_changes_nothing() -> void:
	## Engine side of cancel: offering the choice is read-only. The UI cancel paths are checked in
	## test_arch_v2_batch3 (V2) and test_arch_v2_app (app); both call nothing on Game when cancelled.
	var g := void_encounter()
	hand(g, "PROBE")
	var before := state(g)
	g.play_modes("PROBE", 0); g.play_modes("PROBE", 0)
	check(state(g) == before, "B8 asking for the modes changes nothing")

func b9_insufficient_bw() -> void:
	var g := void_encounter()
	g.play_card(hand(g, "PROBE"), 0, "weaken")
	g.bw = 0
	var before := state(g)
	var u := hand(g, "PROBE")
	check(not g.play_card(u, 0, "weaken"), "B9 a PROBE costing 1 BW is refused with 0 BW")
	g.hand.pop_back()
	check(state(g) == before, "B9 a refused PROBE changes nothing")

func a1_text_and_record() -> void:
	var d := CardDB.def("PROBE")
	check(String(d.text) == APPROVED_TEXT, "A1 PROBE shows the approved PROBE-004a text")
	check(int(d.bw) == 0 and d.type == "SCRIPT" and d.tags == ["EXPLOIT"] and d.rarity == "STARTER", "A1 0 BW STARTER SCRIPT — EXPLOIT")
	check(String(d.get("flavor", "")) == "The deeper you probe, the costlier it gets.", "A1 flavour")
	check(String(d.status.implementation) == "implemented" and not d.has("approved_text"), "A1 the record is no longer divergent")
