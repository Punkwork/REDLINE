extends SceneTree
## Counts Node types along random routes through generated maps (no encounters played).
##     godot --headless --path godot --script res://tests/route_sim.gd
const GameData = preload("res://scripts/data/game_data.gd")
const Heist = preload("res://scripts/core/heist.gd")
func _init() -> void:
	var db = GameData.new()
	db.load_all()
	var totals := {}
	var ice_counts: Array = []
	var best_counts: Array = []
	var n := 2000
	for i in n:
		var h = Heist.new()
		h.setup(db, "generalist", 100 + i)
		h.run.start_corporation("halcyon")
		h._generate_map()
		var c := 0
		var col: int = h.run.rng.randi_range(0, h.rows[1].size() - 1)
		for r in h.rows.size() - 1:
			var row: Array = h.rows[r]
			var pick: int = 0 if row.size() == 1 else col
			var t: String = row[pick]["type"]
			totals[t] = int(totals.get(t, 0)) + 1
			if t in ["opener", "ice_t1", "ice_t2"]:
				c += 1
			if r + 1 < h.rows.size() - 1:
				var links: Array = row[pick]["links"]
				col = links[h.run.rng.randi_range(0, links.size() - 1)]
		ice_counts.append(c)
		# the route with the most ICE Nodes (dynamic programming over the grid)
		var best := []
		for r in h.rows.size() - 1:
			var cur := []
			for k in h.rows[r].size():
				var here := 1 if h.rows[r][k]["type"] in ["opener", "ice_t1", "ice_t2"] else 0
				var prev := 0
				if r > 0:
					for j in h.rows[r - 1].size():
						if h.rows[r - 1][j]["links"].has(k):
							prev = max(prev, best[j])
				cur.append(prev + here)
			best = cur
		best_counts.append(best.max())
	var avg := 0.0
	for c in ice_counts:
		avg += c
	var avg_best := 0.0
	for c in best_counts:
		avg_best += c
	print("ICE Nodes per route (incl. Opening Node, excl. Central Node): random route %.2f, most-ICE route %.2f" % [avg / n, avg_best / n])
	for k in totals.keys():
		print("  %s: %.2f per route" % [k, float(totals[k]) / n])
	quit()
