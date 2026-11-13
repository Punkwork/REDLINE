extends SceneTree
## Headless rules tests. Run from the repo root:
##     godot --headless --path godot --script res://tests/run_tests.gd
## Exits with code 1 if any check fails.

const GameData = preload("res://scripts/data/game_data.gd")
const RunState = preload("res://scripts/core/run_state.gd")
const NodeRun = preload("res://scripts/core/node_run.gd")

var db
var passed := 0
var failed := 0


func _init() -> void:
	db = GameData.new()
	check(db.load_all(), "data loads: %s" % [db.errors])
	test_start_of_node()
	test_install_and_ram()
	test_str_and_boost()
	test_wall_free_first_break()
	test_breach_skips_response()
	test_reward_at_node_end()
	test_shield_absorbs_pulp()
	test_trace_strike()
	test_watchdog_cloak()
	test_void_reduces_draw()
	test_ghost_signal()
	test_full_extraction_bonus()
	test_bot_plays_training_node()
	print("\n%d passed, %d failed" % [passed, failed])
	quit(1 if failed > 0 else 0)


func check(cond: bool, label: String) -> void:
	if cond:
		passed += 1
	else:
		failed += 1
		print("FAIL: " + label)


func new_node(seed_value := 1234, ready_rig := false):
	var run = RunState.new()
	run.setup(db, "generalist", seed_value)
	if not ready_rig:
		run.ghostware.clear()
	var node = NodeRun.new()
	node.setup(db, run, "training", NodeRun.layers_for(db, "training"))
	return node


## Moves a card with this id into the hand (from wherever it is) and returns it.
func force_hand(node, card_id: String):
	for zone in [node.draw_pile, node.discard_pile, node.hand]:
		for inst in zone:
			if inst["id"] == card_id:
				zone.erase(inst)
				node.hand.append(inst)
				return inst
	var inst = node.run.make_temp_card(card_id)
	node.hand.append(inst)
	return inst


func test_start_of_node() -> void:
	var node = new_node()
	node.start()
	check(node.phase == "player", "starts in player phase without READY RIG")
	check(node.hand.size() == 5, "draws 5")
	check(node.bw == 4, "4 BW")
	check(node.run.deck.size() == 12, "12-card starter deck")
	check(node.ice_list.size() == 1 and node.ice_list[0]["id"] == "white_picket_fence", "layer 1 ICE")
	check(node.reserve == 15, "layer 1 reserve 15")

	var rr = new_node(99, true)
	rr.start()
	check(rr.phase == "ready_rig", "READY RIG phase with origin Ghostware")
	var prog = rr.ready_rig_options()[0]
	rr.ready_rig_choose(prog["uid"])
	check(rr.installed.size() == 1 and rr.phase == "player", "READY RIG installs for free")
	check(rr.bw == 4, "READY RIG costs no BW")


func test_install_and_ram() -> void:
	var node = new_node()
	node.start()
	var ip = force_hand(node, "icepick_wall")
	check(node.play_card(ip["uid"]), "install WALL Icepick")
	check(node.bw == 3 and node.ram_used == 1, "install costs 1 BW and 1 RAM")
	node.ram_used = 4
	var ex = force_hand(node, "basic_extractor")
	check(not node.can_play(ex)["ok"], "RAM limit blocks install")


func test_str_and_boost() -> void:
	var node = new_node()
	node.start()
	var ip = force_hand(node, "icepick_wall")
	node.play_card(ip["uid"])
	check(not node.break_check(ip["uid"], 0, 1)["ok"], "STR 1 can't break STR 3")
	check(node.total_break_cost(ip["uid"], 0, 1) == 2, "2 boosts + free first break = 2 BW")
	check(node.boost_and_break(ip["uid"], 0, 1), "boost and break")
	check(node.bw == 1, "BW left 1")
	check(node.is_breached(), "DEADLOCK broken = BREACH")


func test_wall_free_first_break() -> void:
	var node = new_node()
	node.start()
	var ip = force_hand(node, "icepick_wall")
	node.play_card(ip["uid"])
	node.ice_list[0]["str_mod"] = -2
	node.break_subroutine(ip["uid"], 0, 0)
	check(node.bw == 3, "first break free")
	node.break_subroutine(ip["uid"], 0, 1)
	check(node.bw == 2, "second break costs 1")


func test_breach_skips_response() -> void:
	var node = new_node()
	node.start()
	var vitae_before: int = node.run.vitae
	var ip = force_hand(node, "icepick_wall")
	node.play_card(ip["uid"])
	node.boost_and_break(ip["uid"], 0, 1)   # DEADLOCK only; PULP 5 unbroken
	node.end_turn()
	check(node.run.vitae == vitae_before, "BREACH skips the PULP subroutine")
	check(node.phase == "layer_choice" and node.reward_options.is_empty(), "no card reward after a layer (CORE-010)")
	node.go_deeper()
	check(node.layer_index == 1 and node.ice_list.size() == 2 and node.reserve == 25, "layer 2 set up")


func test_reward_at_node_end() -> void:
	# Leaving early after layer 1: one card reward at 1-layer odds, no completion reward.
	var node = new_node()
	node.start()
	node._layer_cleared()
	node.leave_node()
	check(node.phase == "reward" and node.reward_options.size() == 3, "leaving early offers the Node's card reward")
	check(is_equal_approx(float(node.rarity_odds()["rare"]), 0.1), "1 layer cleared: 10% rare")
	node.choose_reward(node.reward_options[0])
	check(node.phase == "node_complete" and node.run.deck.size() == 13 and not node.node_fully_cleared, "one card added, Node over")
	# Clearing all three layers: exactly one card reward, at 3-layer odds.
	node = new_node()
	node.start()
	for i in 3:
		node._layer_cleared()
		if node.phase == "layer_choice":
			check(node.reward_options.is_empty(), "no reward between layers")
			node.go_deeper()
	check(node.phase == "reward" and node.node_fully_cleared, "full clear offers the card reward")
	check(is_equal_approx(float(node.rarity_odds()["rare"]), 0.25), "3 layers cleared: 25% rare")
	node.choose_reward("")
	check(node.phase == "node_complete" and node.run.deck.size() == 12, "skipping adds nothing")


func test_shield_absorbs_pulp() -> void:
	var node = new_node()
	node.start()
	node.hand.clear()
	var s = force_hand(node, "pulp_shield")
	node.play_card(s["uid"])
	node.end_turn()   # PULP 5 vs SHIELD 3
	check(node.run.vitae == 28, "SHIELD 3 absorbs; take 2 (vitae %d)" % node.run.vitae)
	check(node.shield == 0, "SHIELD expires at start of turn")


func test_trace_strike() -> void:
	var node = new_node()
	node.start()
	node.run.trace = 38
	node.add_trace(4, true)
	check(node.run.strikes == 1, "strike at 40")
	check(node.run.trace == 20, "TRACE reset to 20")
	var tracer_in_pile: bool = node.draw_pile.any(func(c): return c["id"] == "tracer")
	check(tracer_in_pile, "TRACER inserted into draw pile")


func test_watchdog_cloak() -> void:
	var node = new_node()
	node.start()
	node.go_deeper()   # not allowed outside layer_choice: nothing happens
	node._start_layer(2)
	var wd: int = node._ice_index_by_id("watchdog")
	var before: int = node.ice_str(wd)
	var s = force_hand(node, "pulp_shield")
	node.play_card(s["uid"])
	check(node.ice_str(wd) == before + 1, "WATCHDOG +1 STR on CLOAK")


func test_void_reduces_draw() -> void:
	var node = new_node()
	node.start()
	node.take_void(2)
	check(node.run.void_counters == 2, "2 VOID counters")
	node.hand.clear()
	node._start_turn()
	check(node.hand.size() == 3, "draw 5-2 = 3")
	node.run.void_counters = 10
	node.hand.clear()
	node._start_turn()
	check(node.hand.size() == 1, "minimum draw 1")


func test_ghost_signal() -> void:
	var node = new_node()
	node.start()
	node.go_deeper()
	node._start_layer(1)   # TOLLBOOTH: TRACE 4
	node.hand.clear()
	var g = force_hand(node, "ghost_signal")
	node.play_card(g["uid"])
	check(node.burned.has(g), "GHOST SIGNAL is BURNED")
	var before: int = node.run.trace
	node.run.vitae = 100
	node.end_turn()
	check(node.run.trace == before, "first TRACE becomes 0 (trace %d)" % node.run.trace)


func test_full_extraction_bonus() -> void:
	var node = new_node()
	node.start()
	node._extract(15, "test")
	check(node.run.cred == 15 + 2, "15 extracted + 10%% bonus rounded up (cred %d)" % node.run.cred)
	node._extract(5, "test")
	check(node.run.cred == 17, "empty reserve pays nothing")


## A simple greedy bot plays the whole Training Node, to catch crashes and loops.
func test_bot_plays_training_node() -> void:
	var wins := 0
	var added: Array = []
	for seed_value in range(1, 21):
		var node = new_node(seed_value, true)
		node.start()
		var guard := 0
		while node.phase not in ["node_complete", "defeat"] and guard < 400:
			guard += 1
			match node.phase:
				"ready_rig":
					var opts: Array = node.ready_rig_options()
					node.ready_rig_choose(opts[0]["uid"] if not opts.is_empty() else -1)
				"player":
					bot_turn(node)
				"reward":
					node.choose_reward(node.reward_options[0] if not node.reward_options.is_empty() else "")
				"layer_choice":
					node.go_deeper()
		check(guard < 400, "bot finished (seed %d, phase %s)" % [seed_value, node.phase])
		if node.phase == "node_complete":
			wins += 1
			added.append(node.run.deck.size() - 12)
			check(node.run.deck.size() <= 13, "at most 1 card per Node")
	print("Bot cleared the Training Node in %d/20 seeds; cards added per run: %s." % [wins, added])
	check(wins > 0, "bot can clear the Training Node at least once")


func bot_turn(node) -> void:
	var progress := true
	while progress and node.phase == "player":
		progress = false
		# 1. Break a DEADLOCK, then other subroutines, with the cheapest Icepick.
		var best := []
		for ip in node.installed_icepicks():
			for i in node.ice_list.size():
				var subs: Array = node.ice_list[i]["broken"]
				for s in subs.size():
					var cost: int = node.total_break_cost(ip["uid"], i, s)
					if cost >= 0 and cost <= node.bw:
						var is_dl: bool = node.ice_list[i]["def"]["subroutines"][s]["effects"].any(func(e): return e["op"] == "deadlock")
						var score: int = (0 if is_dl else 100) + cost
						if best.is_empty() or score < best[0]:
							best = [score, ip["uid"], i, s]
		# 2. Otherwise install a Program or play a Script.
		if not best.is_empty() and best[0] < 100:
			progress = node.boost_and_break(best[1], best[2], best[3])
			continue
		for inst in node.hand.duplicate():
			if node.can_play(inst)["ok"] and node.card_def(inst)["type"] == "PROGRAM":
				progress = node.play_card(inst["uid"])
				break
		if progress:
			continue
		if not best.is_empty():
			progress = node.boost_and_break(best[1], best[2], best[3])
			if progress:
				continue
		for inst in node.hand.duplicate():
			if node.can_play(inst)["ok"] and node.card_def(inst)["type"] == "SCRIPT":
				var target := 0
				var high := -1
				for i in node.ice_list.size():
					if node.ice_str(i) > high:
						high = node.ice_str(i)
						target = i
				progress = node.play_card(inst["uid"], target)
				break
	if node.phase == "player":
		node.end_turn()
