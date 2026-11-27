extends SceneTree
## CSA-01 evidence (not a CI test; run with an absolute --script path): current engine vs approved PROBE-004a. Expectations come from the
## approved text in REDLINE_MASTER_DESIGN.md PROBE-004a, not from the implementation.
var rows := []
func rec(id: String, ok: bool, note: String) -> void:
	rows.append("%s | %s | %s" % [id, "PASS" if ok else "FAIL", note])
func hand(g: Game, id: String) -> int:
	var c = g._new_inst(id); g.hand.append(c); return c.uid
func doorbell(seed_value: int) -> Game:
	var g := Game.new(seed_value); g.new_run(); g.enter_node(0)
	g.choose_ready_rig(g.draw_pile.filter(func(c): return c.id == "TUMBLER_ICEPICK")[0].uid)
	g.new_run(); g.row = 1; g.available = [1]; g.enter_node(1)
	if g.phase == "READY_RIG": g.choose_ready_rig(g.draw_pile.filter(func(c): return c.id == "VOID_ICEPICK")[0].uid)
	return g
func hidden(g: Game, i: int) -> int:
	var n := 0
	for s in g.enc.ice[i].seen.size():
		if not g.enc.ice[i].seen[s]: n += 1
	return n
func _init() -> void:
	print("CORE_LOOP=", Game.CORE_LOOP)
	var g := doorbell(1)
	var h0 := hidden(g, 0); var s0 := g.ice_str(0)
	print("encounter ", g.enc.ice[0].id, " hidden subs ", h0, " STR ", s0)
	g.play_card(hand(g, "PROBE"), 0)
	rec("B1 STR mode does not reveal", hidden(g, 0) == h0, "hidden %d -> %d, STR %d -> %d" % [h0, hidden(g, 0), s0, g.ice_str(0)])
	rec("B2 reveal mode reveals ALL, STR unchanged", hidden(g, 0) == 0 and g.ice_str(0) == s0, "no mode parameter exists; one play reveals %d of %d and changes STR by %d" % [h0 - hidden(g, 0), h0, g.ice_str(0) - s0])
	var g2 := doorbell(2)
	var a := hand(g2, "PROBE"); var b := hand(g2, "PROBE")
	var c0 := g2.card_cost("PROBE", a, 0); g2.play_card(a, 0); var c1 := g2.card_cost("PROBE", b, 0)
	rec("B5 escalating cost across copies", c0 == 0 and c1 == 1, "costs %d then %d" % [c0, c1])
	var twin: Dictionary = g2.enc.ice[0].duplicate(true); g2.enc.ice.append(twin)
	rec("B6 independent counter per ICE (two copies of the same ICE)", g2.card_cost("PROBE", b, 1) == 0, "cost on the second copy: %d (counter keyed by ICE type id %s)" % [g2.card_cost("PROBE", b, 1), twin.id])
	var g3 := doorbell(3); var p := hand(g3, "PROBE"); g3.play_card(p, 0); var q := hand(g3, "PROBE"); g3.bw = 0
	var before := g3.ice_str(0); var ok := g3.play_card(q, 0)
	rec("B9 insufficient BW prevents the action", not ok and g3.ice_str(0) == before and g3.bw == 0, "play_card returned %s" % ok)
	var txt := String(CardDB.def("PROBE").text)
	var approved := "Choose one: Target ICE: −2 STR this encounter. OR Target VOID: Reveal all hidden subroutines. Costs 1 additional BW for each PROBE already played on the target ICE this turn."
	rec("A  CardDB text equals approved printed rules", txt == approved, "CardDB: " + txt)
	rec("B8 cancellation without expenditure", false, "not testable: no choose-one step exists to cancel")
	for r in rows: print(r)
	quit()
