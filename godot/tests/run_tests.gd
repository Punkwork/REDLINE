extends SceneTree
## Headless rules tests. Run from the repo root:
##     godot --headless --path godot --script res://tests/run_tests.gd
## Exits with code 1 if any check fails.

const GameData = preload("res://scripts/data/game_data.gd")
const RunState = preload("res://scripts/core/run_state.gd")
const NodeRun = preload("res://scripts/core/node_run.gd")
const Heist = preload("res://scripts/core/heist.gd")
const Bot = preload("res://tests/bot.gd")

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
	test_caps()
	test_uplink()
	test_heists()
	test_new_corporations()
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
	check(node.reserve == 10, "layer 1 reserve 10")

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
	check(not node.break_subroutine(ip["uid"], 0, 1), "STR 1 can't break STR 3")
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
	check(node.layer_index == 1 and node.ice_list.size() == 2 and node.reserve == 15, "layer 2 set up")


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
	check(node.phase == "completion" and node.completion_options.size() == 2, "full clear offers a CAP")
	node.choose_completion(node.completion_options[0])
	check(node.phase == "node_complete" and node.run.deck.size() == 12 and node.run.caps.size() >= 1, "skip card, take CAP")


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
	node._extract(15, "test", "extraction")
	check(node.run.cred == 10 + 1, "10 extracted + 10%% bonus rounded up (cred %d)" % node.run.cred)
	node._extract(5, "test", "extraction")
	check(node.run.cred == 11, "empty reserve pays nothing")


## The test bot plays the whole Training Node, to catch crashes and loops.
func test_bot_plays_training_node() -> void:
	var wins := 0
	var added: Array = []
	for seed_value in range(1, 21):
		var node = new_node(seed_value, true)
		node.start()
		check(Bot.new().play_node(node), "bot finished (seed %d, phase %s)" % [seed_value, node.phase])
		if node.phase == "node_complete":
			wins += 1
			added.append(node.run.deck.size() - 12)
			check(node.run.deck.size() <= 13, "at most 1 card per Node")
	print("Bot cleared the Training Node in %d/20 seeds; cards added per run: %s." % [wins, added])
	check(wins > 0, "bot can clear the Training Node at least once")


## IRONWATCH and LUCIDA mechanics: FORGET, end-of-turn Bloatware, ARMORY, and their Ghostware.
func test_new_corporations() -> void:
	var node = new_node()
	node.setup(db, node.run, "lucida", [{"ice": ["sleep_tracker"], "cred_reserve": 10}])
	node.start()
	var before: int = node.hand.size()
	node._forget(1)
	check(node.hand.size() == before - 1 and node.burned.size() == 1, "FORGET burns a card from hand")
	node.run.add_ghostware("memory_backup")
	node._forget(1)
	check(node.burned.size() == 1 and node.discard_pile.size() == 1, "MEMORY BACKUP: FORGET goes to discard")
	node.hand.append(node.run.make_temp_card("intrusive_thought"))
	var v: int = node.run.void_counters
	node.end_turn()
	check(node.run.void_counters == v + 1, "INTRUSIVE THOUGHT held at end of turn: VOID 1")
	node.run.add_ghostware("lucid_dream")
	node.run.void_counters = 4
	node.hand.clear()
	node._start_turn()
	check(node.hand.size() == 3, "LUCID DREAM: DRAW can't go below 3")

	var n2 = new_node()
	n2.setup(db, n2.run, "ironwatch", [{"ice": ["armory", "checkpoint"], "cred_reserve": 10}])
	n2.start()
	var str_before: int = n2.ice_str(1)
	n2._apply_ice_effects(db.ice["armory"]["subroutines"][0]["effects"], 0)
	check(n2.ice_str(1) == str_before + 1 and n2.ice_str(0) == 5, "ARMORY: every other ICE +1 STR")
	n2.hand.append(n2.run.make_temp_card("citation"))
	n2.run.vitae = 30
	n2.shield = 0
	n2.run.add_ghostware("kevlar_weave")
	n2._apply_ice_effects([{"op": "pulp", "n": 3}], 1)
	check(n2.run.vitae == 28, "KEVLAR WEAVE: ICE PULP 3 deals 2")

	for cid in ["ironwatch", "lucida"]:
		for rid in ["generalist", "vector"]:
			var h = Heist.new()
			h.setup(db, rid, 900, cid)
			h.start()
			Bot.new().play_heist(h, 2)
			check(h.phase == "summary", "%s heist with %s finished" % [cid, rid])


## Every Rustler can play a whole HALCYON heist without the engine getting stuck.
func test_heists() -> void:
	for rid in ["generalist", "echo", "riot", "vector"]:
		for i in 3:
			var h = Heist.new()
			h.setup(db, rid, 500 + i)
			h.start()
			check(h.rows.size() == 10, "9 rows + Central Node")
			var uplink_rows := 0
			for r in [2, 5, 8]:
				if h.rows[r].any(func(n): return n["type"] == "uplink"):
					uplink_rows += 1
			check(uplink_rows == 3, "Uplinks in rows 3, 6 and 9")
			Bot.new(i == 1).play_heist(h, 2)
			check(h.phase == "summary", "%s heist %d finished (phase %s)" % [rid, i, h.phase])
			check(h.summary_text().length() > 100, "summary written")


func test_uplink() -> void:
	var h = Heist.new()
	h.setup(db, "generalist", 77)
	h.start()
	h.run.cred = 500
	h._open_uplink(true)
	var items: Array = h.room["items"]
	check(items.filter(func(i): return i["shelf"] == "Reserve").size() == 2, "2 reserve cards")
	check(items.filter(func(i): return i["shelf"] == "Cards").size() == 6, "6 shelf cards")
	check(items.filter(func(i): return i.get("sale", false)).size() == 1, "1 card on sale")
	check(items.filter(func(i): return i["kind"] == "cap").size() == 3, "3 CAPS")
	var g := items.filter(func(i): return i["kind"] == "ghostware").size()
	check(g >= 2 and g <= 3, "2-3 Ghostware")
	var deck_before: int = h.run.deck.size()
	var idx := -1
	for i in items.size():
		if items[i]["shelf"] == "Cards":
			idx = i
			break
	var price: int = items[idx]["price"]
	check(h.buy(idx), "buy a card")
	check(h.run.cred == 500 - price and h.run.deck.size() == deck_before + 1, "CRED spent, card added")
	check(not h.buy(idx), "can't buy twice")
	h.start_wipe()
	check(h.phase == "pick_card", "Wipe asks for a card")
	h.resolve_pick(h.run.deck[0]["uid"])
	check(h.run.deck.size() == deck_before and h.run.cred == 500 - price - 50, "Wipe removes a card for 50")
	h.run.void_counters = 2
	h.use_clinic()
	check(h.run.void_counters == 0 and h.run.cred == 500 - price - 100, "Clinic removes VOID for 50")


func test_caps() -> void:
	var node = new_node()
	node.start()
	node.run.gain_cap("bulwark")
	node.run.gain_cap("jack_out")
	check(node.use_cap(0), "use BULWARK")
	check(node.shield == 8, "+8 SHIELD")
	check(node.use_cap(0), "use JACK OUT")
	check(node.phase == "node_complete" and node.jacked_out, "JACK OUT ends the Node")
	check(node.run.deck.size() == 12, "JACK OUT gives no card reward")
