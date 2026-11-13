extends SceneTree
## Economy simulation: bots play many HALCYON heists and report average CRED and cards.
##     godot --headless --path godot --script res://tests/heist_sim.gd
## The bots are weak players, so treat win rates as a lower bound; the CRED numbers are the point.

const GameData = preload("res://scripts/data/game_data.gd")
const Heist = preload("res://scripts/core/heist.gd")
const Bot = preload("res://tests/bot.gd")

const RUNS := 60


func _init() -> void:
	var db = GameData.new()
	db.load_all()
	var corps: Array = ["halcyon", "ironwatch", "lucida"]
	var only := OS.get_environment("CORP")
	if only != "":
		corps = [only]
	for cid in corps:
		var patient := true
		print("\n=== %s · %s bot ===" % [db.corporations[cid]["name"], "Patient (extracts fully)" if patient else "Hasty (breaks ASAP)"])
		print("Averages over winning runs only (full 10 rows + Central Node).")
		print("Rustler     wins  earned  reserve  extr%  spent  rewards  bought  Uplinks  deck")
		for rid in ["generalist", "echo", "riot", "vector"]:
			var t := {"wins": 0, "earned": 0, "seen": 0, "extr": 0, "spent": 0, "rewards": 0, "bought": 0, "uplinks": 0, "deck": 0}
			for i in RUNS:
				var h = Heist.new()
				h.setup(db, rid, 1000 + i, cid)
				h.start()
				Bot.new(patient).play_heist(h, 3)
				var s: Dictionary = h.run.stats
				t["wins"] += 1 if h.won else 0
				if not h.won:
					continue
				t["earned"] += int(s["cred_earned"])
				t["seen"] += int(s.get("reserve_seen", 0))
				t["extr"] += int(s["cred_by_source"].get("extraction", 0))
				t["spent"] += int(s["cred_spent"])
				t["rewards"] += int(s["cards_from_rewards"])
				t["bought"] += int(s["cards_bought"])
				t["uplinks"] += s["nodes"].filter(func(n): return String(n["type"]).begins_with("UPLINK")).size()
				t["deck"] += h.run.deck.size()
			var w: float = max(1, t["wins"])
			print("%-10s %3d/%d  %6.0f  %7.0f  %4.0f%%  %5.0f  %7.1f  %6.1f  %7.1f  %4.1f" % [rid, t["wins"], RUNS,
					t["earned"] / w, t["seen"] / w, 100.0 * t["extr"] / max(1, t["seen"]),
					t["spent"] / w, t["rewards"] / w, t["bought"] / w,
					t["uplinks"] / w, t["deck"] / w])
	quit()
