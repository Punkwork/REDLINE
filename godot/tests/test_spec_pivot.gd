extends SceneTree
## CSA-04d spec test: PIVOT as approved by the designer, 2026-11-27 (CHAIN-PARK-001 follow-up).
##   Text: "[1 BW] Target ICE −1 STR this encounter. If this reduces target ICE STR to 0, break one of
##          the target ICE subroutines for no cost."
##   PIVOT-001 (designer 2026-11-28 05:59): the text becomes "Target ICE −1 STR this encounter. If target
##   ICE STR is 0, break one of the target ICE subroutines for no cost." An ICE already at 0 breaks too.
##   "Chain mechanic is moved to Experimental. CHAIN should be removed from all current cards."
##   Follow-up: the Rustler chooses which subroutine breaks. Any subroutine they could normally break is
##   eligible (visible, unbroken, usual order rules); there is no prompt when only one qualifies.
## Expectations are literals from that text, never read from the engine.
## Fixture: one COOKIE WALL (FORTRESS, every subroutine face up) with its STR set directly.

var passed := 0
var failed := 0

const APPROVED := "Target ICE −1 STR this encounter. If target ICE STR is 0, break one of the target ICE subroutines for no cost."   # PIVOT-001

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	costs_one_bw_and_reduces_one()
	reduction_lasts_the_encounter()
	zero_with_choice_prompts_and_breaks_chosen()
	zero_with_one_eligible_breaks_without_prompt()
	hidden_and_out_of_order_not_eligible()
	zero_with_none_eligible_breaks_nothing()
	already_zero_breaks()
	floor_above_zero_never_breaks()
	no_chain_bonus()
	record()
	print("SPEC PIVOT: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

# --- fixtures ---------------------------------------------------------------------------------

func game_with_wall(strength: int, ice_id: String = "COOKIE_WALL") -> Game:
	var g := Game.new(7)
	g.new_run()
	g.enter_node(0)
	if g.phase == "READY_RIG": g.skip_ready_rig()
	var ice: Dictionary = g._new_ice(ice_id)
	for s in ice.seen.size(): ice.seen[s] = true
	ice.str_mod = strength - int(g.ice_definition(ice).str)
	ice.last_str = strength
	g.enc.ice = [ice]
	g.hand.clear()
	g.bw = 5
	return g

func play_pivot(g: Game) -> Dictionary:
	var c: Dictionary = g._new_inst("PIVOT")
	g.hand.append(c)
	check(g.play_card(c.uid, 0), "PIVOT can be played on a targeted ICE")
	return c

func in_pile(g: Game, c: Dictionary) -> String:
	for pile in ["hand", "draw_pile", "discard", "burned"]:
		if (g.get(pile) as Array).has(c): return pile
	return "gone"

# --- spec -------------------------------------------------------------------------------------

func costs_one_bw_and_reduces_one() -> void:
	var g := game_with_wall(3)
	var c := play_pivot(g)
	check(g.bw == 4, "[1 BW]: PIVOT costs 1 BW (5 -> 4)")
	check(g.ice_str(0) == 2, "Target ICE −1 STR (3 -> 2)")
	check(g.enc.ice[0].broken.count(true) == 0, "no break when STR does not reach 0")
	check(g.phase == "PLAYER" and g.pending.is_empty(), "no prompt when STR does not reach 0")
	check(in_pile(g, c) == "discard", "PIVOT goes to discard")

func reduction_lasts_the_encounter() -> void:
	var g := game_with_wall(3)
	play_pivot(g)
	g.end_turn()
	if g.phase == "CHOICE": return   # a Corporation response needing a choice; the turn reset is covered below
	check(g.enc.ice.size() == 1 and g.ice_str(0) == 2, "−1 STR lasts the encounter: still 2 on the next turn")

func zero_with_choice_prompts_and_breaks_chosen() -> void:
	var g := game_with_wall(1)
	var c := play_pivot(g)
	check(g.ice_str(0) == 0, "STR 1 -> 0")
	check(g.phase == "CHOICE" and g.pending.get("kind", "") == "card_break", "reaching 0 with several eligible subroutines asks which to break")
	check(int(g.pending.get("n", 0)) == 1, "break one subroutine")
	check(int(g.pending.get("ice", -1)) == 0, "only the target ICE's subroutines")
	check(g.bw == 4, "the break costs nothing beyond PIVOT's 1 BW")
	for s in 5:
		check(g.card_break_ok(0, s), "visible unbroken subroutine %d is eligible" % s)
	g.choose_sub(0, 3)
	check(g.enc.ice[0].broken == [false, false, false, true, false], "the chosen subroutine (3) breaks, and only it")
	check(g.phase == "PLAYER" and g.pending.is_empty(), "back to the Rustler after one break")
	check(g.bw == 4, "still no BW paid for the break")
	check(in_pile(g, c) == "discard", "PIVOT goes to discard after the break")

func zero_with_one_eligible_breaks_without_prompt() -> void:
	var g := game_with_wall(1)
	g.enc.ice[0].broken = [true, true, false, true, true]
	g.enc.ice[0].break_progress = [1, 1, 0, 1, 1]
	var c := play_pivot(g)
	check(g.enc.ice[0].broken[2], "the only eligible subroutine breaks")
	check(g.phase == "PLAYER" and g.pending.is_empty(), "no prompt when only one subroutine qualifies")
	check(g.bw == 4, "the automatic break costs nothing")
	check(in_pile(g, c) == "discard", "PIVOT goes to discard")

func hidden_and_out_of_order_not_eligible() -> void:
	# Hidden subroutines are not eligible.
	var g := game_with_wall(1)
	g.enc.ice[0].seen = [true, false, true, false, false]
	play_pivot(g)
	check(g.phase == "CHOICE" and g.pending.get("kind", "") == "card_break", "two visible subroutines: prompt")
	check(g.card_break_ok(0, 0) and g.card_break_ok(0, 2), "visible subroutines 0 and 2 are eligible")
	check(not g.card_break_ok(0, 1) and not g.card_break_ok(0, 3) and not g.card_break_ok(0, 4), "face-down subroutines are not eligible")
	# One visible subroutine: no prompt, and that one breaks.
	var h := game_with_wall(1)
	h.enc.ice[0].seen = [false, false, false, true, false]
	play_pivot(h)
	check(h.enc.ice[0].broken == [false, false, false, true, false], "the one visible subroutine breaks without a prompt")
	check(h.phase == "PLAYER", "no prompt with one visible subroutine")

func zero_with_none_eligible_breaks_nothing() -> void:
	var g := game_with_wall(1)
	g.enc.ice[0].seen = [false, false, false, false, false]
	var c := play_pivot(g)
	check(g.ice_str(0) == 0, "STR still reaches 0")
	check(g.enc.ice[0].broken.count(true) == 0, "nothing eligible: nothing breaks")
	check(g.phase == "PLAYER" and g.pending.is_empty(), "nothing eligible: no prompt")
	check(in_pile(g, c) == "discard", "PIVOT goes to discard")

func already_zero_breaks() -> void:
	# PIVOT-001: "If target ICE STR is 0" — an ICE already at 0 qualifies.
	var g := game_with_wall(0)
	g.enc.ice[0].zeroed = true
	var c := play_pivot(g)
	check(g.ice_str(0) == 0, "ICE already at 0 stays at 0")
	check(g.phase == "CHOICE" and g.pending.get("card", "") == "PIVOT", "ICE already at 0: PIVOT offers its free break (PIVOT-001)")
	g.choose_sub(0, 0)
	check(g.enc.ice[0].broken.count(true) == 1, "ICE already at 0: one subroutine breaks for no cost")
	check(g.bw == 4 and in_pile(g, c) == "discard", "only PIVOT's 1 BW is paid; PIVOT goes to discard")

func floor_above_zero_never_breaks() -> void:
	# An ICE whose STR can't fall to 0 never qualifies: the condition is the STR after the −1.
	var g := game_with_wall(2)
	play_pivot(g)
	check(g.ice_str(0) == 1 and g.enc.ice[0].broken.count(true) == 0 and g.phase == "PLAYER", "STR 2 -> 1: no break")

func no_chain_bonus() -> void:
	var g := game_with_wall(5)
	var cloak: Dictionary = g._new_inst("PULP_SHIELD")
	g.hand.append(cloak)
	g.play_card(cloak.uid)
	check(g.enc.get("last_tags", []).has("CLOAK"), "fixture: a CLOAK card was just played")
	play_pivot(g)
	check(g.ice_str(0) == 4, "CHAIN removed: still −1 STR after a CLOAK (5 -> 4)")

func record() -> void:
	var d: Dictionary = CardDB.def("PIVOT")
	check(String(d.text) == APPROVED, "PIVOT shows the approved text")
	check(int(d.bw) == 1, "PIVOT record costs 1 BW")
	check(not d.has("chain"), "PIVOT has no CHAIN field")
	check(String(CardDB.RECORDS.PIVOT.status.implementation) == "implemented", "PIVOT record is implemented")
