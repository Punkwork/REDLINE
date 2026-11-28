extends SceneTree
## CORTEX-001 spec test (designer, 2026-11-28). Approved text:
##   "For every unprevented point of CORTEX damage: immediately discard one random card from the Rustler's
##    hand; apply one CORTEX counter; each accumulated counter reduces subsequent DRAW by 1, to a minimum
##    of 1. CORTEX prevention prevents both consequences for each prevented point. If insufficient cards
##    remain, discard only the available cards. Do not introduce overflow damage. Retain existing CORTEX
##    recovery rules and ordinary SHIELD restrictions."
## TURN-001 (confirmed 2026-11-28): the next hand is drawn before the Corporation Response, so CORTEX
## from the response hits that new hand. Expectations are literals from these texts, never read from the
## engine. Fixture: one FORTRESS whose subroutines are set per case (CORTEX X, DISCARD X, DEADLOCK).

var passed := 0
var failed := 0

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	draw_before_response()
	cortex_hits_new_hand()
	several_points()
	prevention_partial_and_complete()
	failsafe()
	draw_minimum_one()
	empty_and_short_hand()
	cache_and_discard()
	shield_and_vitae()
	parting_shot_and_next_encounter()
	print("SPEC CORTEX: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

# --- fixtures ---------------------------------------------------------------------------------

func game_with(subs: Array, layers := 1, seed := 5) -> Game:
	var g := Game.new(seed)
	g.new_run("RIOT")   # no READY RIG prompt
	var ls := []
	for k in layers: ls.append({"ice": ["COOKIE_WALL"], "reserve": 15})
	g.node = {"id": "SPEC", "kind": "ICE", "name": "SPEC", "layers": ls, "next": [0]}
	g._start_ice_node()
	set_ice(g, subs)
	g.vitae = 30
	g.shield = 0
	g.phase = "PLAYER"
	return g

func set_ice(g: Game, subs: Array) -> void:
	var d := {"name": "SPEC WALL", "type": "FORTRESS", "str": 9, "tier": "T1", "subs": subs}
	var ice: Dictionary = g._new_ice("COOKIE_WALL", d)
	for s in ice.seen.size(): ice.seen[s] = true
	g.enc.ice = [ice]

func uids(a: Array) -> Array:
	var out := a.map(func(c): return int(c.uid))
	out.sort()
	return out

## END TURN with the response held, so the hand can be seen before the subroutines fire.
func end_turn_held(g: Game) -> Array:
	g.animate = true
	g.end_turn()
	return uids(g.hand)

func finish_response(g: Game) -> void:
	while not g.response_queue.is_empty() and g.phase != "DEAD": g.response_step()
	if g.phase == "RESPONSE": g.response_finish()

const CORTEX_1 := [[{"k": "CORTEX", "v": 1}], [{"k": "DEADLOCK"}]]
const CORTEX_2 := [[{"k": "CORTEX", "v": 2}], [{"k": "DEADLOCK"}]]
const CORTEX_3 := [[{"k": "CORTEX", "v": 3}], [{"k": "DEADLOCK"}]]

# --- spec -------------------------------------------------------------------------------------

func draw_before_response() -> void:
	var g := game_with(CORTEX_1)
	var drawn := end_turn_held(g)
	check(g.phase == "RESPONSE" and drawn.size() == 6, "TURN-001: a 6-card hand is drawn before the Corporation Response (%d)" % drawn.size())

func cortex_hits_new_hand() -> void:
	var g := game_with(CORTEX_1)
	var drawn := end_turn_held(g)
	var before := g.cortex
	finish_response(g)
	var gone := drawn.filter(func(u): return not uids(g.hand).has(u))
	check(gone.size() == 1, "CORTEX 1: one card of the newly drawn hand is discarded")
	check(g.discard.any(func(c): return int(c.uid) == gone[0]), "the discarded card is in the discard pile")
	check(g.cortex == before + 1, "CORTEX 1: one counter")
	check(g.hand.size() == 5, "the turn starts with 5 cards")
	# The counter reduces the next DRAW.
	var h := game_with([[{"k": "TRACE", "v": 0}], [{"k": "DEADLOCK"}]])
	h.cortex = 1
	end_turn_held(h)
	check(h.hand.size() == 5, "one counter: the next hand is DRAW 6 − 1 = 5")

func several_points() -> void:
	var g := game_with(CORTEX_3)
	var drawn := end_turn_held(g)
	finish_response(g)
	var gone := drawn.filter(func(u): return not uids(g.hand).has(u))
	check(gone.size() == 3 and g.cortex == 3, "CORTEX 3: three random discards and three counters")
	# Random: different seeds pick different cards.
	var picks := {}
	for sd in 12:
		var r := game_with(CORTEX_1, 1, 100 + sd)
		var d := end_turn_held(r)
		finish_response(r)
		var lost := d.filter(func(u): return not uids(r.hand).has(u))
		var ids := r.discard.filter(func(c): return lost.has(int(c.uid))).map(func(c): return String(c.id))
		if not ids.is_empty(): picks[ids[0]] = true
	check(picks.size() > 1, "the discarded card is random (%d different cards over 12 seeds)" % picks.size())

func prevention_partial_and_complete() -> void:
	var g := game_with(CORTEX_2)
	g.installed.append({"inst": g._new_inst("CORTEX_BUFFER"), "boost": 0, "free_used": false})
	var drawn := end_turn_held(g)
	finish_response(g)
	var gone := drawn.filter(func(u): return not uids(g.hand).has(u))
	check(gone.size() == 1 and g.cortex == 1, "CORTEX BUFFER prevents 1 of 2: one discard and one counter")
	var h := game_with(CORTEX_1)
	h.installed.append({"inst": h._new_inst("CORTEX_BUFFER"), "boost": 0, "free_used": false})
	var d2 := end_turn_held(h)
	finish_response(h)
	check(uids(h.hand) == d2 and h.cortex == 0, "CORTEX BUFFER prevents CORTEX 1 completely: no discard, no counter")
	# Once per encounter: the second response gets through.
	h.phase = "PLAYER"
	var d3 := end_turn_held(h)
	finish_response(h)
	check(h.cortex == 1 and d3.filter(func(u): return not uids(h.hand).has(u)).size() == 1, "CORTEX BUFFER is once per encounter")

func failsafe() -> void:
	var g := game_with(CORTEX_3)
	g.rack.append(g._new_inst("FAILSAFE"))
	var drawn := end_turn_held(g)
	finish_response(g)
	check(uids(g.hand) == drawn and g.cortex == 0, "FAILSAFE prevents all of it: no discards, no counters")

func draw_minimum_one() -> void:
	var g := game_with([[{"k": "TRACE", "v": 0}], [{"k": "DEADLOCK"}]])
	g.cortex = 9
	end_turn_held(g)
	check(g.hand.size() == 1, "nine counters: DRAW is 1, never below")

func empty_and_short_hand() -> void:
	var g := game_with(CORTEX_3)
	g.cortex = 5   # next draw: 1 card
	var v := g.vitae
	var drawn := end_turn_held(g)
	finish_response(g)
	check(drawn.size() == 1, "a 1-card hand before the response")
	check(g.hand.is_empty() and g.cortex == 8, "CORTEX 3 with one card: that card is discarded and three counters are added")
	check(g.vitae == v, "no overflow damage")
	var e := game_with(CORTEX_2)
	e.hand.clear()
	e.draw_pile.clear()
	e.discard.clear()
	var ve := e.vitae
	e.animate = true
	e.end_turn()
	finish_response(e)
	check(e.cortex == 2 and e.vitae == ve, "an empty hand: counters only, no overflow")

func cache_and_discard() -> void:
	# A CACHED card is in the hand, so a random CORTEX discard can take it.
	var g := game_with(CORTEX_1)
	g.cortex = 5   # draws 1
	for c in g.hand: c.cached = false
	var keep: Dictionary = g._new_inst("PULP_SHIELD")
	keep.cached = true
	g.hand = [keep]
	end_turn_held(g)
	check(g.hand.size() == 2, "the CACHED card stays through cleanup, plus a 1-card draw")
	finish_response(g)
	check(g.hand.size() == 1 and g.cortex == 6, "CORTEX 1 discards one of the two cards")
	# An ordinary DISCARD subroutine still waits for the start of the turn and is chosen from what's left.
	var h := game_with([[{"k": "CORTEX", "v": 1}], [{"k": "DISCARD", "v": 2}], [{"k": "DEADLOCK"}]])
	end_turn_held(h)
	finish_response(h)
	check(h.hand.size() == 5 and h.phase == "CHOICE" and h.pending.get("kind", "") == "discard" and int(h.pending.n) == 2,
		"CORTEX discards at once (6 → 5); DISCARD 2 is then chosen from the remaining hand at the start of the turn")

func shield_and_vitae() -> void:
	var g := game_with(CORTEX_1)
	var drawn := end_turn_held(g)
	g.shield = 10
	var v := g.vitae
	finish_response(g)
	check(g.cortex == 1 and drawn.filter(func(u): return not uids(g.hand).has(u)).size() == 1, "SHIELD doesn't stop CORTEX")
	check(g.vitae == v, "CORTEX costs no VITAE")

func parting_shot_and_next_encounter() -> void:
	var g := game_with(CORTEX_2, 2)
	for c in g.hand.duplicate(): g.discard.append(g._take_from(g.hand, c.uid))
	for k in 3: g.hand.append(g._new_inst("PULP_SHIELD"))
	while not g.enc.ice[0].broken[1]: g._do_break(0, 1)   # BREACH; CORTEX 2 stays unbroken
	check(g.enc.breached, "BREACH")
	g.end_turn()   # PARTING SHOT fires CORTEX 2 at the hand still held
	check(g.cortex == 2, "the PARTING SHOT's CORTEX 2 adds two counters")
	check(g.phase == "DEEPER", "the encounter ends")
	g.go_deeper()
	check(g.layer == 1 and g.hand.size() == 4, "the next encounter's first draw is DRAW 6 − 2 = 4 (%d)" % g.hand.size())
