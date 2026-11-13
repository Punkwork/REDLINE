extends SceneTree
## Measures each corporation's Opening Node: turns until BREACH for every Rustler's starter deck,
## played by the rushing test bot (breaks DEADLOCKs as early as it can).
##     godot --headless --path godot --script res://tests/opener_sim.gd
const GameData = preload("res://scripts/data/game_data.gd")
const RunState = preload("res://scripts/core/run_state.gd")
const NodeRun = preload("res://scripts/core/node_run.gd")
const Bot = preload("res://tests/bot.gd")
const N := 200

func _init() -> void:
	var db = GameData.new()
	db.load_all()
	var corps: Array = ["halcyon", "ironwatch", "lucida"]
	if OS.get_environment("CORP") != "":
		corps = [OS.get_environment("CORP")]
	for cid in corps:
		var o: Dictionary = db.corporations[cid]["opener"]
		print("\n%s — %s: %s" % [db.corporations[cid]["name"], o["name"], ", ".join(o["ice_left_to_right"].map(func(i): return db.ice[i]["name"]))])
		print("Rustler      min  avg   ≤2 turns  ≥6 turns  VITAE lost  TRACE  VOID  flatlined")
		for rid in ["generalist", "echo", "riot", "vector"]:
			var turns: Array = []
			var lost := 0
			var tr := 0
			var vo := 0
			var dead := 0
			for i in N:
				var run = RunState.new()
				run.setup(db, rid, 7000 + i)
				run.start_corporation(cid)
				var node = NodeRun.new()
				node.setup(db, run, cid, [{"ice": o["ice_left_to_right"], "cred_reserve": int(o["cred_reserve"])}])
				node.start()
				var bot = Bot.new(false)
				var guard := 0
				while node.phase not in ["reward", "defeat", "node_complete"] and guard < 300:
					guard += 1
					if not node.choice.is_empty():
						node.resolve_choice([node.choice["options"][0]["key"]] if int(node.choice["max"]) > 0 else [])
					elif node.phase == "ready_rig":
						bot.play_node(node)   # handles READY RIG, then keeps playing
					else:
						bot.turn(node)
				if node.phase == "defeat":
					dead += 1
					continue
				turns.append(node.turn)
				lost += 30 - run.vitae
				tr += run.trace
				vo += run.void_counters
			var n: float = max(1, turns.size())
			var avg := 0.0
			for t in turns:
				avg += t
			print("%-10s  %3d  %4.1f  %6.0f%%  %7.0f%%  %9.1f  %5.1f  %4.1f  %4d" % [rid, turns.min() if not turns.is_empty() else -1, avg / n,
					100.0 * turns.filter(func(t): return t <= 2).size() / n, 100.0 * turns.filter(func(t): return t >= 6).size() / n,
					lost / n, tr / n, vo / n, dead])
	quit()
