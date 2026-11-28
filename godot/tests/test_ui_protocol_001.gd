extends SceneTree
## UI-PROTOCOL-001 (designer 2026-11-28, issue #26): active Protocol lifecycle and the ten
## SYNERGY-PLAYTEST-002 cards, as approved. Expectations are literals from the decisions, never read
## from cards.json or the engine:
##   Core Rules §3.1 / UI-PROTOCOL-001: a played PROTOCOL pays its BW, leaves the hand for the active
##     RACK, uses no RAM, has no maximum; active cards are outside hand, draw and discard and can't be
##     retrieved; each copy has its own effect.
##   PROTOCOL-DURATION-001/a/b: active through BREACH, END TURN and PARTING SHOT; then, the Rustler
##     alive, every Protocol expires to the discard pile exactly once, before progression or rewards,
##     on normal progression, forced LOCKDOWN and early exit; fatal PARTING SHOT: no rewards. Programs
##     and RAM persist within the Node.
##   SYNERGY-PLAYTEST-002/002a: REACTIVE ARMOUR 1 BW +1 SHIELD per card played; COUNTERINTELLIGENCE
##     1 BW −1 TRACE per CLOAK; OVERCLOCK 2 BW third card each turn: draw 2, +1 BW (once per turn per
##     copy); FEEDBACK LOOP 1 BW +1 BW per ZERO; SALVAGE 2 BW first DEADLOCK broken each turn: return a
##     chosen discard card; ADAPTIVE DEFENCE 1 BW +3 SHIELD per PROGRAM installed; FOLLOW THROUGH 1 BW
##     −2 STR, −2 more after an EXPLOIT; ESCALATION 1 BW −1 STR per EXPLOIT this turn incl. itself;
##     AFTERBURN 0 BW +4 SHIELD with 3+ other cards this turn; REPRISE 2 BW repeats the previous
##     SCRIPT's effect this turn, not its play, and can't repeat itself. No self-trigger on deployment.
## Multi-layer Nodes: the slice map has only one-layer Nodes, so two- and three-layer Nodes are fixtures.

var passed := 0
var failed := 0

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	deploy_and_circulation()
	no_limit_and_copies()
	no_self_trigger()
	reactive_armour_and_counterintelligence()
	overclock_once_per_turn()
	feedback_loop_on_zero()
	salvage_first_deadlock()
	adaptive_defence()
	synergy_scripts()
	reprise()
	lifecycle_two_layers()
	lifecycle_three_layers_lockdown()
	early_exit()
	fatal_parting_shot()
	rewards_and_fixture()
	print("UI-PROTOCOL-001: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

# --- fixtures ---------------------------------------------------------------------------------

## A Node of `layers` encounters, each one COOKIE WALL (FORTRESS, STR 7, one DEADLOCK), every subroutine
## face up. The Rustler starts with BW to spare and an empty hand.
func node_game(layers := 1, ice_id := "COOKIE_WALL", seed := 11) -> Game:
	var g := Game.new(seed)
	g.new_run("RIOT")   # no READY RIG prompt
	var ls := []
	for k in layers: ls.append({"ice": [ice_id], "reserve": 15})
	g.node = {"id": "TEST%d" % layers, "kind": "ICE", "name": "TEST", "layers": ls, "next": [0]}
	g._start_ice_node()
	prepare(g)
	return g

func prepare(g: Game) -> void:
	for ice in g.enc.ice:
		for s in ice.seen.size(): ice.seen[s] = true
	for c in g.hand.duplicate(): g.discard.append(g._take_from(g.hand, c.uid))
	g.bw = 40
	g.vitae = 30
	g.phase = "PLAYER"
	g.pending = {}

func give(g: Game, id: String) -> Dictionary:
	var c: Dictionary = g._new_inst(id)
	g.hand.append(c)
	return c

func deploy(g: Game, id: String) -> Dictionary:
	var c := give(g, id)
	check(g.play_card(c.uid), "%s deploys" % id)
	return c

func set_str(g: Game, i: int, v: int) -> void:
	var ice: Dictionary = g.enc.ice[i]
	ice.str_mod = v - int(g.ice_definition(ice).str)
	ice.last_str = v

func where(g: Game, c: Dictionary) -> String:
	for pile in ["hand", "draw_pile", "discard", "burned", "rack"]:
		if (g.get(pile) as Array).any(func(x): return x.uid == c.uid): return pile
	for p in g.installed:
		if p.inst.uid == c.uid: return "installed"
	return "gone"

func count_uid(g: Game, uid: int) -> int:
	var n := 0
	for pile in ["hand", "draw_pile", "discard", "burned", "rack"]:
		n += (g.get(pile) as Array).filter(func(x): return x.uid == uid).size()
	n += g.installed.filter(func(p): return p.inst.uid == uid).size()
	return n

func all_uids(g: Game) -> Array:
	var out := []
	for pile in ["hand", "draw_pile", "discard", "burned", "rack"]:
		for c in g.get(pile): out.append(int(c.uid))
	for p in g.installed: out.append(int(p.inst.uid))
	out.sort()
	return out

## Break every unbroken subroutine except `keep` (indices) on every ICE, DEADLOCKs last: BREACH.
func breach(g: Game, keep: Array = []) -> void:
	for i in g.enc.ice.size():
		var subs: Array = g.ice_definition(g.enc.ice[i]).subs
		for s in subs.size():
			if keep.has(s) or Game._has_deadlock(subs[s]): continue
			while not g.enc.ice[i].broken[s]: g._do_break(i, s)
		for s in subs.size():
			if Game._has_deadlock(subs[s]):
				while not g.enc.ice[i].broken[s]: g._do_break(i, s)

# --- mechanics --------------------------------------------------------------------------------

func deploy_and_circulation() -> void:
	var g := node_game()
	var ram_before := g.ram_used()
	var c := give(g, "REACTIVE_ARMOUR")
	g.bw = 5
	check(g.play_card(c.uid), "a PROTOCOL in hand deploys")
	check(g.bw == 4, "REACTIVE ARMOUR costs 1 BW (5 -> 4)")
	check(where(g, c) == "rack", "the deployed card is in the active RACK, not hand, draw, discard or BURNED")
	check(g.ram_used() == ram_before, "a PROTOCOL uses no RAM")
	# Recursion can't reach it: SALVAGE and TAIL CALL choose from the discard pile only.
	g.discard.append(g._new_inst("PROBE"))
	g.enc.salvage_due = 1
	deploy(g, "SALVAGE")
	g._flush_salvage()
	check(g.pending.get("kind", "") == "retrieve" and not g.pending.options.has(c.uid), "recursion options never include an active Protocol")
	g.choose(g.pending.options[0])
	check(where(g, c) == "rack", "the active Protocol stays put through a recursion choice")

func no_limit_and_copies() -> void:
	var g := node_game()
	var dep := []
	for k in 14: dep.append(deploy(g, "REACTIVE_ARMOUR"))
	check(g.rack.size() == 14, "no maximum: 14 Protocols active at once")
	check(dep.all(func(c): return where(g, c) == "rack"), "every copy is in the RACK")
	g.shield = 0
	var p := give(g, "PULP_SHIELD")
	g.play_card(p.uid)
	check(g.shield == 3 + 14, "each copy fires on its own: PULP SHIELD +3, fourteen REACTIVE ARMOURs +1 each")

func no_self_trigger() -> void:
	var g := node_game()
	g.shield = 0
	deploy(g, "REACTIVE_ARMOUR")
	check(g.shield == 0, "REACTIVE ARMOUR doesn't fire for its own deployment")
	deploy(g, "REACTIVE_ARMOUR")
	check(g.shield == 1, "a second copy's deployment is a card play for the first copy only (+1)")
	var t := give(g, "STIM_PATCH")
	g.play_card(t.uid)
	check(g.shield == 3, "then a card play fires both copies (+2)")
	var spam := give(g, "SPAM")
	g.play_card(spam.uid)
	check(g.shield == 3, "clearing SPAM isn't a card play for REACTIVE ARMOUR")

func reactive_armour_and_counterintelligence() -> void:
	var g := node_game()
	deploy(g, "COUNTERINTELLIGENCE")
	g.trace = 10
	var a := give(g, "STIM_PATCH")   # not a CLOAK; +2 TRACE
	g.play_card(a.uid)
	check(g.trace == 12, "COUNTERINTELLIGENCE ignores a non-CLOAK (STIM PATCH +2: 10 -> 12)")
	var b := give(g, "LAY_LOW")   # CLOAK, −3 TRACE
	g.play_card(b.uid)
	check(g.trace == 8, "COUNTERINTELLIGENCE: −1 TRACE when you play a CLOAK (LAY LOW −3, then −1: 12 -> 8)")
	g.trace = 0
	var c := give(g, "SMOKESCREEN")
	g.play_card(c.uid)
	check(g.trace == 0, "TRACE doesn't go below 0")

func overclock_once_per_turn() -> void:
	var g := node_game()
	for k in 6: g.draw_pile.append(g._new_inst("PULP_SHIELD"))
	deploy(g, "OVERCLOCK")                     # card 1
	g.play_card(give(g, "PULP_SHIELD").uid)     # card 2
	var bw_before := g.bw
	var hand_before := g.hand.size()
	g.play_card(give(g, "PULP_SHIELD").uid)     # card 3: −1 BW to play, then +1 BW, draw 2
	check(g.bw == bw_before - 1 + 1, "OVERCLOCK: +1 BW on the third card (SYNERGY-PLAYTEST-002a)")
	check(g.hand.size() == hand_before + 2, "OVERCLOCK: draw 2 on the third card")
	hand_before = g.hand.size()
	g.play_card(give(g, "PULP_SHIELD").uid)     # card 4
	check(g.hand.size() == hand_before, "OVERCLOCK fires once per turn")
	g._start_turn()
	prepare(g)
	for k in 2: g.play_card(give(g, "PULP_SHIELD").uid)
	hand_before = g.hand.size()
	g.play_card(give(g, "PULP_SHIELD").uid)
	check(g.hand.size() == hand_before + 2, "OVERCLOCK resets at the start of the next turn")
	# A copy deployed as the third card doesn't fire for itself.
	var h := node_game()
	for k in 4: h.draw_pile.append(h._new_inst("PULP_SHIELD"))
	h.play_card(give(h, "PULP_SHIELD").uid)
	h.play_card(give(h, "PULP_SHIELD").uid)
	hand_before = h.hand.size()
	deploy(h, "OVERCLOCK")
	check(h.hand.size() == hand_before, "OVERCLOCK deployed as the third card doesn't fire for itself")

func feedback_loop_on_zero() -> void:
	var g := node_game()
	deploy(g, "FEEDBACK_LOOP")
	set_str(g, 0, 2)
	g._sync_strengths()
	var before := g.bw
	g.play_card(give(g, "OVERLOAD").uid, 0)   # 0 BW, −2 STR: ZERO
	check(g.ice_str(0) == 0, "OVERLOAD takes the wall to 0")
	check(g.bw == before + 1, "FEEDBACK LOOP: +1 BW when you ZERO an ICE")
	before = g.bw
	g.play_card(give(g, "OVERLOAD").uid, 0)
	check(g.bw == before, "an ICE is ZEROED once per encounter (ZEROED-001): no second BW")

func salvage_first_deadlock() -> void:
	var g := node_game(1, "AUTO_RENEW")   # DEADLOCK 2: one subroutine, two breaks
	g.enc.ice.append(g._new_ice("CAPTCHA"))   # two more DEADLOCKs
	prepare(g)
	var s := deploy(g, "SALVAGE")
	var kept := g._new_inst("BRUTE_FORCE")
	g.discard.append(kept)
	g._do_break(0, 4)
	g._flush_salvage()
	check(g.pending.is_empty(), "half of a DEADLOCK 2 isn't a DEADLOCK broken")
	g._do_break(0, 4)
	g._flush_salvage()
	check(g.phase == "CHOICE" and g.pending.get("kind", "") == "retrieve" and String(g.pending.get("title", "")) == "SALVAGE", "SALVAGE: the first DEADLOCK broken opens a choice")
	g.choose(kept.uid)
	check(where(g, kept) == "hand" and g.phase == "PLAYER", "the chosen discard card returns to hand")
	g._do_break(1, 1)
	g._flush_salvage()
	check(g.pending.is_empty(), "only the first DEADLOCK each turn")
	check(where(g, s) == "rack", "SALVAGE stays active")
	g._start_turn()
	prepare(g)
	g.discard.append(g._new_inst("PROBE"))
	g._do_break(1, 4)
	g._flush_salvage()
	check(g.pending.get("kind", "") == "retrieve", "SALVAGE resets each turn")

func adaptive_defence() -> void:
	var g := node_game()
	deploy(g, "ADAPTIVE_DEFENCE")
	deploy(g, "ADAPTIVE_DEFENCE")
	g.shield = 0
	g.play_card(give(g, "FORTRESS_ICEPICK").uid)
	check(g.shield == 6, "ADAPTIVE DEFENCE: +3 SHIELD per copy when you install a PROGRAM")
	g.play_card(give(g, "PULP_SHIELD").uid)
	check(g.shield == 9, "a SCRIPT isn't an install (PULP SHIELD +3 only)")

func synergy_scripts() -> void:
	var g := node_game()
	set_str(g, 0, 7)
	g.play_card(give(g, "FOLLOW_THROUGH").uid, 0)
	check(g.ice_str(0) == 5, "FOLLOW THROUGH: −2 STR (7 -> 5)")
	g._start_turn(); prepare(g); set_str(g, 0, 7)
	g.play_card(give(g, "OVERLOAD").uid, 0)          # EXPLOIT, −2
	g.play_card(give(g, "FOLLOW_THROUGH").uid, 0)    # previous card EXPLOIT: −4
	check(g.ice_str(0) == 1, "FOLLOW THROUGH after an EXPLOIT: −2 more (7 −2 −4 = 1)")
	g._start_turn(); prepare(g); set_str(g, 0, 7)
	g.play_card(give(g, "PULP_SHIELD").uid)
	g.play_card(give(g, "FOLLOW_THROUGH").uid, 0)
	check(g.ice_str(0) == 5, "FOLLOW THROUGH after a non-EXPLOIT: −2 only")
	g._start_turn(); prepare(g); set_str(g, 0, 9)
	g.play_card(give(g, "OVERLOAD").uid, 0)          # EXPLOIT 1: 9 -> 7
	g.play_card(give(g, "ESCALATION").uid, 0)        # EXPLOIT 2 incl. itself: −2
	check(g.ice_str(0) == 5, "ESCALATION: −1 STR per EXPLOIT this turn including itself (7 −2 = 5)")
	g._start_turn(); prepare(g); g.shield = 0
	g.play_card(give(g, "AFTERBURN").uid)
	check(g.shield == 0, "AFTERBURN with no other cards: nothing")
	for k in 3: g.play_card(give(g, "STIM_PATCH").uid)
	g.play_card(give(g, "AFTERBURN").uid)
	check(g.shield == 4, "AFTERBURN with three other cards this turn: +4 SHIELD")
	# Interactions with the Protocols.
	var h := node_game()
	deploy(h, "COUNTERINTELLIGENCE")
	deploy(h, "REACTIVE_ARMOUR")
	h.trace = 5; h.shield = 0
	h.play_card(give(h, "AFTERBURN").uid)   # CLOAK, the third card this turn
	check(h.trace == 4, "AFTERBURN is a CLOAK: COUNTERINTELLIGENCE −1 TRACE")
	check(h.shield == 1, "AFTERBURN with two other cards: no +4; REACTIVE ARMOUR +1")

func reprise() -> void:
	var g := node_game()
	check(not g.can_play(give(g, "REPRISE").uid).ok, "REPRISE: nothing to repeat before a SCRIPT this turn")
	set_str(g, 0, 11)
	g.play_card(give(g, "OVERLOAD").uid, 0)       # 11 -> 9
	g.play_card(give(g, "FOLLOW_THROUGH").uid, 0)  # after EXPLOIT: 9 -> 5
	var r: Dictionary = g.hand.filter(func(c): return c.id == "REPRISE")[0]
	var bw_before := g.bw
	check(g.play_card(r.uid), "REPRISE plays after a SCRIPT")
	check(g.bw == bw_before - 2, "REPRISE costs 2 BW")
	check(g.ice_str(0) == 1, "REPRISE repeats FOLLOW THROUGH on the same ICE, its condition read now: the card before REPRISE (FOLLOW THROUGH) is an EXPLOIT, −4 (5 -> 1)")
	check(where(g, r) == "discard", "REPRISE goes to the discard pile")
	check(not g.can_play(give(g, "REPRISE").uid).ok, "REPRISE can't repeat a REPRISE")
	# PROBE: repeating the effect isn't another PROBE played.
	var p := node_game()
	set_str(p, 0, 9)
	p.play_card(give(p, "PROBE").uid, 0, "weaken")
	var cost_before := p.card_cost("PROBE", -1, 0)
	p.play_card(give(p, "REPRISE").uid)
	check(p.ice_str(0) == 5, "REPRISE repeats PROBE's −2 (9 −2 −2 = 5)")
	check(p.card_cost("PROBE", -1, 0) == cost_before, "REPRISE doesn't add to the PROBE count on that ICE")
	# An interactive SCRIPT: the choice opens again; every card is still there once.
	var d := node_game()
	for k in 3: d.draw_pile.append(d._new_inst("PULP_SHIELD"))
	var before := all_uids(d)
	var df := give(d, "DEFRAG")
	var x1 := give(d, "LAY_LOW")
	var x2 := give(d, "SCRUB")
	d.play_card(df.uid)
	d.choose(x1.uid)
	var rp := give(d, "REPRISE")
	check(d.play_card(rp.uid), "REPRISE repeats DEFRAG")
	check(d.phase == "CHOICE" and d.pending.get("kind", "") == "discard", "the repeated DEFRAG asks for a discard")
	d.choose(x2.uid)
	var after := all_uids(d)
	var expect := before + [df.uid, x1.uid, x2.uid, rp.uid]
	expect.sort()
	check(after == expect, "card conservation through a repeated choice")
	check(where(d, rp) == "discard" and count_uid(d, rp.uid) == 1, "REPRISE is in the discard pile once")

# --- encounter lifecycle ----------------------------------------------------------------------

func lifecycle_two_layers() -> void:
	var g := node_game(2)
	var before_cards := all_uids(g)
	var prog := give(g, "FORTRESS_ICEPICK")
	g.play_card(prog.uid)
	var ram := g.ram_used()
	var p1 := deploy(g, "REACTIVE_ARMOUR")
	var p2 := deploy(g, "REACTIVE_ARMOUR")
	var p3 := deploy(g, "PROXY_CHAIN")
	breach(g, [0])   # leave PULP 2 unbroken: the PARTING SHOT fires it
	check(g.enc.breached and g.rack.size() == 3, "BREACH: Protocols still active")
	g.animate = true
	g.end_turn()
	check(g.enc.get("parting", false) and g.rack.size() == 3, "PARTING SHOT: Protocols still active while it resolves")
	while not g.response_queue.is_empty(): g.response_step()
	g.response_finish()
	check(g.phase == "DEEPER", "two-layer Node: after the first BREACH, go deeper or leave")
	check(g.rack.is_empty(), "the RACK is empty after the encounter")
	for c in [p1, p2, p3]:
		check(where(g, c) == "discard" and count_uid(g, c.uid) == 1, "%s expired to the discard pile exactly once" % c.id)
	check(where(g, prog) == "installed" and g.ram_used() == ram, "the PROGRAM and its RAM persist")
	g.go_deeper()
	prepare(g)
	check(g.layer == 1 and g.rack.is_empty(), "layer 2 starts with an empty RACK")
	check(where(g, prog) == "installed" and g.ram_used() == ram, "the PROGRAM is still installed in layer 2")
	g.shield = 0
	g.play_card(give(g, "STIM_PATCH").uid)
	check(g.shield == 0, "expired REACTIVE ARMOURs don't fire")
	var expect := before_cards + [prog.uid, p1.uid, p2.uid, p3.uid]
	var stim: Array = g.discard.filter(func(c): return c.id == "STIM_PATCH")
	for c in stim: expect.append(int(c.uid))
	expect.sort()
	check(all_uids(g) == expect, "no card lost or duplicated across the layers")
	# Final layer: expire before the completion reward.
	var p4 := deploy(g, "SALVAGE")
	breach(g)
	g.animate = false
	g.end_turn()
	check(g.phase == "REWARD" and g.rack.is_empty() and where(g, p4) == "discard", "last layer: Protocols expire to discard before the reward")

func lifecycle_three_layers_lockdown() -> void:
	var g := node_game(3)
	var prog := give(g, "FORTRESS_ICEPICK")
	g.play_card(prog.uid)
	var p1 := deploy(g, "OVERCLOCK")
	g.lockdown = true   # forced progression
	breach(g)
	g.end_turn()
	check(g.layer == 1 and g.phase != "DEEPER", "LOCKDOWN: straight into layer 2")
	check(g.rack.is_empty() and count_uid(g, p1.uid) == 1 and where(g, p1) != "rack", "LOCKDOWN progression expires the Protocol once")
	check(where(g, prog) == "installed", "the PROGRAM persists through LOCKDOWN")
	prepare(g)
	var p2 := deploy(g, "ADAPTIVE_DEFENCE")
	breach(g)
	g.end_turn()
	check(g.layer == 2 and g.rack.is_empty() and count_uid(g, p2.uid) == 1, "layer 3 of 3: the RACK resets again")
	check(where(g, prog) == "installed", "the PROGRAM persists into layer 3")

func early_exit() -> void:
	var g := node_game(2)
	var p := deploy(g, "FEEDBACK_LOOP")
	breach(g)
	g.end_turn()
	check(g.phase == "DEEPER" and where(g, p) == "discard", "before leaving: expired to discard")
	g.leave_node()
	check(g.phase == "MAP" and g.rack.is_empty(), "leaving early: RACK empty, no reward")

func fatal_parting_shot() -> void:
	var g := node_game(2)
	deploy(g, "REACTIVE_ARMOUR")
	breach(g, [3])   # PULP 3 stays unbroken
	g.vitae = 1
	g.shield = 0
	g.end_turn()
	check(g.phase == "DEAD", "the PARTING SHOT is fatal")
	check(g.reward_options.is_empty() and g.phase != "REWARD" and g.phase != "DEEPER", "a fatal PARTING SHOT gives no completion reward or progression")

func rewards_and_fixture() -> void:
	var ten := ["REACTIVE_ARMOUR", "COUNTERINTELLIGENCE", "OVERCLOCK", "FEEDBACK_LOOP", "SALVAGE", "ADAPTIVE_DEFENCE",
		"FOLLOW_THROUGH", "ESCALATION", "AFTERBURN", "REPRISE"]
	var offered := []
	for r in ["COMMON", "UNCOMMON", "RARE"]: offered += CardDB.reward_pool("SHARED", r)
	check(ten.all(func(id): return offered.has(id)), "all ten are in the shared reward pools")
	var costs := {"REACTIVE_ARMOUR": 1, "COUNTERINTELLIGENCE": 1, "OVERCLOCK": 2, "FEEDBACK_LOOP": 1, "SALVAGE": 2,
		"ADAPTIVE_DEFENCE": 1, "FOLLOW_THROUGH": 1, "ESCALATION": 1, "AFTERBURN": 0, "REPRISE": 2}
	for id in costs:
		check(CardDB.def(id).bw == costs[id], "%s costs %d BW (SYNERGY-PLAYTEST-002)" % [id, costs[id]])
	var types := {"PROTOCOL": ["REACTIVE_ARMOUR", "COUNTERINTELLIGENCE", "OVERCLOCK", "FEEDBACK_LOOP", "SALVAGE", "ADAPTIVE_DEFENCE"],
		"SCRIPT": ["FOLLOW_THROUGH", "ESCALATION", "AFTERBURN", "REPRISE"]}
	for t in types:
		for id in types[t]: check(CardDB.def(id).type == t, "%s is a %s" % [id, t])
	# Normal acquisition: rewards over many runs offer every one of the ten.
	var seen := {}
	for sd in 300:
		var g := Game.new(1000 + sd)
		g.new_run("RIOT")
		for id in g._roll_rewards(3): seen[id] = true
	check(ten.all(func(id): return seen.has(id)), "node rewards offer each of the ten (300 seeded rolls; missing %s)" % [ten.filter(func(id): return not seen.has(id))])
