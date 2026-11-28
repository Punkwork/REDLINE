extends SceneTree
## CARD-REVIEW-001 spec test (designer 2026-11-28; built 2026-11-28). Approved texts and boundaries:
##   VOID ICEPICK: "Whenever you break a subroutine, reveal one remaining concealed subroutine on that ICE."
##     The next concealed subroutine in resolution order on the same ICE; nothing if none remain.
##   TASER: "If TASER breaks at least one subroutine on an ICE, disable that ICE's PARTING SHOT." This
##     encounter only; ordinary Corporation Responses unaffected; other ICE unaffected; no stacking.
##   STACK SMASH: "Each ICE −1 STR per EXPLOIT played this turn, including itself." No target.
## Expectations are literals from these texts.

var passed := 0
var failed := 0

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	void_icepick()
	taser()
	stack_smash()
	print("SPEC CARD REVIEW: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

func game_with(ids: Array, seed := 3) -> Game:
	var g := Game.new(seed)
	g.new_run("RIOT")
	var ls := [{"ice": ids, "reserve": 15}]
	g.node = {"id": "SPEC", "kind": "ICE", "name": "SPEC", "layers": ls, "next": [0]}
	g._start_ice_node()
	for c in g.hand.duplicate(): g.discard.append(g._take_from(g.hand, c.uid))
	g.bw = 30; g.vitae = 30; g.phase = "PLAYER"; g.pending = {}
	return g

func install(g: Game, id: String) -> Dictionary:
	var c: Dictionary = g._new_inst(id)
	g.installed.append({"inst": c, "boost": 0, "free_used": false})
	return c

func void_icepick() -> void:
	var g := game_with(["DOORBELL_CAM"])   # VOID, every subroutine face-down
	var ice: Dictionary = g.enc.ice[0]
	for s in ice.seen.size(): ice.seen[s] = false
	ice.seen[0] = true   # S1 showing
	var pick := install(g, "VOID_ICEPICK")
	var hidden_before := g.hidden_subs(0)
	check(g.break_sub(0, 0, int(pick.uid)), "VOID ICEPICK breaks S1")
	check(g.hidden_subs(0) == hidden_before - 1 and ice.seen[1] and not ice.seen[2], "the next concealed subroutine (S2) is revealed, only one")
	check(g.break_sub(0, 1, int(pick.uid)), "break S2")
	check(ice.seen[2] and not ice.seen[3], "the next one (S3) is revealed")
	var h := game_with(["DOORBELL_CAM"])
	for s in h.enc.ice[0].seen.size(): h.enc.ice[0].seen[s] = true
	var p2 := install(h, "VOID_ICEPICK")
	check(h.break_sub(0, 0, int(p2.uid)) and h.hidden_subs(0) == 0, "nothing concealed: no effect")
	var t := game_with(["DOORBELL_CAM"])
	var tice: Dictionary = t.enc.ice[0]
	for s in tice.seen.size(): tice.seen[s] = false
	tice.seen[0] = true
	var other := install(t, "TASER")
	t.break_sub(0, 0, int(other.uid))
	check(not tice.seen[1], "another VOID Icepick (TASER) doesn't reveal")

func taser() -> void:
	# Two VOIDs; TASER breaks one subroutine on the first; both have unbroken PULP when BREACHED.
	var g := game_with(["DOORBELL_CAM", "DOORBELL_CAM"])
	for ice in g.enc.ice:
		for s in ice.seen.size(): ice.seen[s] = true
	var tz := install(g, "TASER")
	check(g.break_sub(0, 0, int(tz.uid)), "TASER breaks a subroutine on ICE 1")
	g._do_break(0, 1)   # another break on that ICE: still the same single suppression
	check(g.enc.ice[0].get("no_parting_shot", false) == true, "the suppression is a flag, not a count (no stacking)")
	# BREACH: break the DEADLOCKs directly; PULP 4 (S1) stays unbroken on both.
	for i in 2:
		while not g.enc.ice[i].broken[3]: g._do_break(i, 3)
	check(g.enc.breached, "BREACH")
	g.animate = true
	g.end_turn()
	var firing := g.response_queue.map(func(st): return g.enc.ice.find(st.ref))
	check(not firing.has(0), "ICE 1 (broken by TASER) fires no PARTING SHOT")
	check(firing.has(1), "ICE 2 still fires its PARTING SHOT")
	# Ordinary Corporation Responses are unaffected: the flag changes nothing in a normal response.
	var r := game_with(["DOORBELL_CAM"])
	for k in r.enc.ice[0].seen.size(): r.enc.ice[0].seen[k] = true
	var before := r.response_preview().size()
	r.enc.ice[0]["no_parting_shot"] = true
	r.animate = true
	r.end_turn()
	check(r.phase == "RESPONSE" and r.response_queue.size() > 0 and r.response_preview().size() == before, "a normal Corporation Response still fires that ICE's subroutines")
	# Encounter only: a new encounter starts without it.
	check(not r._new_ice("DOORBELL_CAM").has("no_parting_shot"), "a new ICE (next encounter) has its PARTING SHOT")

func stack_smash() -> void:
	var g := game_with(["COOKIE_WALL", "AUTO_RENEW"])
	var s0 := g.ice_str(0)
	var s1 := g.ice_str(1)
	var o: Dictionary = g._new_inst("OVERLOAD"); g.hand.append(o)
	g.play_card(o.uid, 0)   # EXPLOIT 1: ICE 1 −2
	var c: Dictionary = g._new_inst("STACK_SMASH"); g.hand.append(c)
	check(not bool(CardDB.def("STACK_SMASH").get("target", false)), "STACK SMASH has no target")
	check(g.play_card(c.uid), "STACK SMASH plays without a target")
	check(g.ice_str(0) == s0 - 2 - 2 and g.ice_str(1) == s1 - 2, "each ICE −1 STR per EXPLOIT this turn including itself (2): ICE 1 %d → %d, ICE 2 %d → %d" % [s0, g.ice_str(0), s1, g.ice_str(1)])
