extends SceneTree
## CSA-04c spec test: BURNED as approved by the designer, 2026-11-27.
##   BURNED-001:  "BURNED should be for the rest of the encounter" (was: the rest of the Node).
##   BURNED-001a: at the end of an encounter, that encounter's BURNED cards go to the discard pile.
##   BURNED-001b: "Cleared SPAM does not return - it disappears forever."
## Interpretation to confirm (recorded in HANDOFF): Bloatware BURNED any other way (UNINSTALLER) does
## not return either. Expectations are literals from those decisions, never read from the engine.
## The HALCYON slice has one encounter per Node, so the fixture adds a second layer to a copy of the
## Node (never to IceDB.MAP), as test_game.gd's legacy_layer_fixture does.

var passed := 0
var failed := 0

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	burned_stays_out_for_the_encounter()
	burned_goes_to_discard_when_the_encounter_ends()
	garbage_collect_card_returns()
	cleared_spam_disappears_forever()
	uninstaller_bloatware_does_not_return()
	node_end_unchanged()
	card_text()
	print("SPEC BURNED: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

# --- fixtures ---------------------------------------------------------------------------------

func two_encounter_node(seed_value: int = 7) -> Game:
	var g := Game.new(seed_value)
	g.new_run()
	g.enter_node(0)
	if g.phase == "READY_RIG": g.skip_ready_rig()
	g.node = g.node.duplicate(true)
	g.node.layers.append({"ice": ["CONSENT_FORM"], "reserve": 15})
	return g

func hand(g: Game, id: String) -> Dictionary:
	## A real deck copy (so it belongs to the run deck): one already in hand, or moved from the piles; else make one.
	for c in g.hand:
		if c.id == id: return c
	for pile in [g.draw_pile, g.discard]:
		for i in pile.size():
			if pile[i].id == id:
				var c: Dictionary = pile[i]
				pile.remove_at(i)
				g.hand.append(c)
				return c
	var made: Dictionary = g._new_inst(id)
	g.hand.append(made)
	return made

func where(g: Game, c: Dictionary) -> String:
	for pile in ["hand", "draw_pile", "discard", "burned"]:
		if (g.get(pile) as Array).has(c): return pile
	return "gone"

func next_encounter(g: Game) -> bool:
	g.enc.breached = true
	g.end_turn()
	if g.phase != "DEEPER": return false
	g.go_deeper()
	return g.layer == 1 and g.phase in ["PLAYER", "CHOICE", "READY_RIG"]

# --- checks -----------------------------------------------------------------------------------

func burned_stays_out_for_the_encounter() -> void:
	var g := two_encounter_node()
	g.bw = 5
	var gs := hand(g, "GHOST_SIGNAL")
	check(g.play_card(int(gs.uid)), "GHOST SIGNAL plays")
	check(where(g, gs) == "burned", "BURNED-001: a BURNED card is out of play (in the burned pile)")
	g.end_turn()
	while g.phase == "RESPONSE": g.response_step()
	check(g.layer == 0 and where(g, gs) == "burned", "BURNED-001: it stays out for the rest of the encounter, across turns")

func burned_goes_to_discard_when_the_encounter_ends() -> void:
	var g := two_encounter_node()
	g.bw = 5
	var gs := hand(g, "GHOST_SIGNAL")
	g.play_card(int(gs.uid))
	# The rule itself, at the moment the encounter ends (go_deeper calls this before the next one starts):
	var probe := two_encounter_node(11)
	probe.bw = 5
	var gs2 := hand(probe, "GHOST_SIGNAL")
	probe.play_card(int(gs2.uid))
	probe._return_burned()
	check(where(probe, gs2) == "discard" and probe.burned.is_empty(), "BURNED-001a: when the encounter ends the BURNED card goes to the discard pile")
	check(next_encounter(g), "fixture reaches the Node's second encounter")
	check(where(g, gs) in ["discard", "draw_pile", "hand"], "BURNED-001: next encounter the card is back in circulation (is in %s)" % where(g, gs))
	check(g.burned.is_empty(), "BURNED-001a: the burned pile is empty at the start of the next encounter")

func garbage_collect_card_returns() -> void:
	var g := two_encounter_node()
	var other := hand(g, "PULP_SHIELD")
	var gc := hand(g, "GARBAGE_COLLECT")
	g.play_card(int(gc.uid))
	if g.phase == "CHOICE": g.choose(int(other.uid))
	check(where(g, other) == "burned", "GARBAGE COLLECT burns the chosen card")
	next_encounter(g)
	check(where(g, other) in ["discard", "draw_pile", "hand"], "BURNED-001: the card GARBAGE COLLECT burned is back in circulation next encounter (is in %s)" % where(g, other))

func cleared_spam_disappears_forever() -> void:
	var g := two_encounter_node()
	g.bw = 5
	var spam := hand(g, "SPAM")
	check(g.play_card(int(spam.uid)), "SPAM can be cleared for 1 BW")
	check(where(g, spam) == "gone" and g.find_card(int(spam.uid)).is_empty(), "BURNED-001b: cleared SPAM is in no pile at all")
	next_encounter(g)
	check(where(g, spam) == "gone", "BURNED-001b: cleared SPAM does not come back next encounter")

func uninstaller_bloatware_does_not_return() -> void:
	var g := two_encounter_node()
	g.bw = 5
	var spam := hand(g, "SPAM")
	var un := hand(g, "UNINSTALLER")
	g.play_card(int(un.uid))
	if g.phase == "CHOICE": g.choose(int(spam.uid))
	check(where(g, spam) == "burned", "UNINSTALLER burns the Bloatware")
	next_encounter(g)
	check(where(g, spam) == "gone", "Interpretation: Bloatware BURNED by UNINSTALLER does not return either")

func node_end_unchanged() -> void:
	## Leaving the Node: everything returns to the deck, as before (Core Rules §3.1); BURNED changes nothing there.
	var g := two_encounter_node()
	g.bw = 5
	var gs := hand(g, "GHOST_SIGNAL")
	g.play_card(int(gs.uid))
	g.enc.breached = true
	g.end_turn()
	g.leave_node()
	check(g.burned.is_empty() and g.run_deck.any(func(c): return int(c.uid) == int(gs.uid)), "Node end: the BURNED card is back in the run deck")

func card_text() -> void:
	check(String(CardDB.def("GARBAGE_COLLECT").text) == "BURN 1 other card in your hand. Draw 1.", "GARBAGE COLLECT shows its approved text")
	check(not String(CardDB.def("SPAM").text).to_lower().contains("rest of the node"), "SPAM no longer says it is BURNED for the rest of the Node")
	for id in ["GHOST_SIGNAL", "FLINCH", "BURN_NOTICE", "UNINSTALLER", "PATCH_KIT", "VANISH", "BLACKOUT", "NO_WITNESSES", "SPAM", "FORCE_REBOOT", "NULL_POINTER", "GARBAGE_COLLECT"]:
		check(String(CardDB.RECORDS[id].status.implementation) == "implemented", "%s record is implemented, no longer divergent" % id)
