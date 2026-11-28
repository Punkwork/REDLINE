extends SceneTree
## MAP-TIER-001 / MAP-TIER-001a / ESCAPE-ICE-001 spec test (designer 2026-11-28). Expectations are literals from
## the approved texts, not read back from the code under test:
##   Core Rules §10.1: row 1 the Opening Node; rows 2–8 Tier 1 ICE; row 9's ordinary ICE Nodes (2 layers) and
##     rows 10–15 Tier 2 ICE; row 16 the BOSS. The rule is by row, on every generated map.
##   PACE-008: Tier 2 Nodes have 1–2 layers; card reward odds Tier 2 1-layer 45/40/15, 2-layer 30/45/25.
##   ICE Corp 1 §8.1: a Tier 1 ICE can support a Tier 2 main. §8.2 (UPL-008): Tier 2 reserves 15 / 20.
##   Roster: ICE Corp 1 §5 Tier 2 table, FREE TRIAL (DSY-013) and the former escape ICE
##     (Upgrades/Events/Escape §4; ESCAPE-ICE-001). HOUSE CALL stays Black ICE.
##   Values (designer 2026-11-28, "quickest method"): the doc values plus STR-001 (+2 STR) and FORM-002
##     (TRACE +2, PULP +1). Abilities held except DEADBOLT's "Its STR can't be reduced below 3."
##     PANIC BUTTON's TRACER goes into the draw pile (designer 2026-11-28). FREE TRIAL unchanged as built.
##   The four-row slice map stays the test default.

var passed := 0
var failed := 0

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

# The doc rows before adjustment: [type, STR, subroutines]. Each subroutine is a list of [effect, value].
const DOC := {
	"SMART_LOCK": ["FORTRESS", 6, [[["PULP", 3], ["DEADLOCK", 0]]]],
	"PANIC_ROOM": ["FORTRESS", 4, [[["PULP", 4]], [["DEADLOCK", 0]], [["DEADLOCK", 0]]]],
	"LOYALTY_PROGRAM": ["TUMBLER", 3, [[["INSERT", 1]], [["TRACE", 2], ["DEADLOCK", 0]]]],
	"FIRMWARE_UPDATE": ["TUMBLER", 4, [[["PURGE_ALL", 0]], [["PULP", 3]], [["DEADLOCK", 0]]]],
	"NANNY_CAM": ["VOID", 3, [[["PULP", 3]], [["TRACE", 2], ["DEADLOCK", 0]]]],
	"HOME_ASSISTANT": ["VOID", 4, [[["CORTEX", 1]], [["PULP", 2], ["DEADLOCK", 0]]]],
	"REPO_DRONE": ["VOID", 3, [[["PULP", 4]], [["PULP", 4], ["DEADLOCK", 0]]]],
	"ALARM_PANEL": ["TUMBLER", 3, [[["TRACE", 3]], [["DEADLOCK", 0]]]],
	"MOTION_SENSOR": ["VOID", 3, [[["PULP", 3], ["DEADLOCK", 0]]]],
	"DEADBOLT": ["FORTRESS", 6, [[["PULP", 4]], [["DEADLOCK", 0]]]],
	"PANIC_BUTTON": ["TUMBLER", 2, [[["INSERT", 1]], [["DEADLOCK", 0]]]],
}

func _initialize() -> void:
	roster()
	placement()
	effects()
	slice_default()
	print("MAP TIER: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

func tier_of(id: String) -> String:
	return String(IceDB.def(id).get("tier", ""))

func roster() -> void:
	for id in DOC:
		check(IceDB.DEFS.has(id), "%s is in IceDB" % id)
		if not IceDB.DEFS.has(id): continue
		var d: Dictionary = IceDB.def(id)
		var doc: Array = DOC[id]
		check(d.tier == "T2" and d.type == doc[0], "%s: Tier 2 %s" % [id, doc[0]])
		check(int(d.str) == int(doc[1]) + 2, "%s: STR %d + 2 (STR-001)" % [id, doc[1]])
		check(d.subs.size() == doc[2].size(), "%s: %d subroutines, none added" % [id, doc[2].size()])
		for s in mini(d.subs.size(), doc[2].size()):
			var want: Array = doc[2][s]
			check(d.subs[s].size() == want.size(), "%s S%d: %d effects" % [id, s + 1, want.size()])
			for k in mini(d.subs[s].size(), want.size()):
				var e: Dictionary = d.subs[s][k]
				var bonus: int = {"TRACE": 2, "PULP": 1}.get(want[k][0], 0)   # FORM-002
				check(e.k == want[k][0], "%s S%d: %s" % [id, s + 1, want[k][0]])
				if want[k][0] in ["PULP", "TRACE", "CORTEX", "INSERT"]:
					check(int(e.v) == int(want[k][1]) + bonus, "%s S%d: %s %d" % [id, s + 1, e.k, int(want[k][1]) + bonus])
		check(d.subs.any(func(sub): return sub.any(func(e): return e.k == "DEADLOCK")), "%s has a DEADLOCK (main ICE, ICE Corp 1 §2.4)" % id)
		check(not d.has("passive") and (id == "DEADBOLT" or not d.has("ability")), "%s: no reactive ability built" % id)
	check(int(IceDB.def("DEADBOLT").get("str_floor", 0)) == 3, "DEADBOLT: STR can't be reduced below 3")
	check(not IceDB.def("SMART_LOCK").has("passive") and not IceDB.def("SMART_LOCK").has("ability"), "SMART LOCK: no +1 STR per response (ENTRENCH is THE GRID's)")
	check(IceDB.def("LOYALTY_PROGRAM").subs[0][0].card == "SPAM" and IceDB.def("LOYALTY_PROGRAM").subs[0][0].to == "draw", "LOYALTY PROGRAM: INSERT 1 SPAM into the draw pile")
	check(IceDB.def("PANIC_BUTTON").subs[0][0].card == "TRACER" and IceDB.def("PANIC_BUTTON").subs[0][0].to == "draw", "PANIC BUTTON: INSERT 1 TRACER into the draw pile")
	var ft: Dictionary = IceDB.def("FREE_TRIAL")
	check(ft.tier == "T2" and ft.type == "TUMBLER" and int(ft.str) == 4, "FREE TRIAL unchanged: Tier 2 TUMBLER 4 (DSY-013)")
	check(tier_of("HOUSE_CALL") == "BLACK", "HOUSE CALL stays Black ICE")
	for id in DOC.keys() + ["FREE_TRIAL"]:
		check(IceDB.TIER2.has(id), "%s is in the Tier 2 roster" % id)
	check(not IceDB.TIER2.has("HOUSE_CALL"), "HOUSE CALL is not a Tier 2 Node ICE")
	for id in IceDB.TIER1:
		check(tier_of(id) == "T1", "%s (Tier 1 support pool) is Tier 1" % id)

func placement() -> void:
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(Game.MAP_DATA))
	var maps := int((data.maps as Array).size())
	check(maps == 20, "20 generated maps")
	var row9 := 0
	var one := 0
	var two := 0
	for k in maps:
		var g := Game.new(5)
		g.new_run()
		g.use_generated_map(k)
		var again := Game.new(99)
		again.new_run()
		again.use_generated_map(k)
		check(JSON.stringify(g.map_rows) == JSON.stringify(again.map_rows), "map %d: the same Nodes every time (from the map, not the run RNG)" % k)
		var early_t2 := []
		var wrong := []
		for ri in g.map_rows.size():
			for n in g.map_rows[ri]:
				if n.kind != "ICE": continue
				var ids := []
				for L in n.layers: ids.append_array(L.ice)
				var row := ri + 1
				if row == 1:
					if not (n.get("opening", false) or n.name == "COOKIE BANNER") or n.layers.size() != 1: wrong.append("%d opening" % row)
				elif row == 16:
					if not n.get("central", false) or n.layers.size() != 3: wrong.append("16 boss")
				elif n.get("miniboss", false):
					if row != 9: wrong.append("%d miniboss" % row)
				elif row <= 8:
					if n.layers.size() != 1 or not ids.all(func(id): return tier_of(id) == "T1"): wrong.append("%d %s tier 1" % [row, n.id])
				else:
					var want_layers := [2] if row == 9 else [1, 2]
					if not want_layers.has(n.layers.size()): wrong.append("%d %s layers %d" % [row, n.id, n.layers.size()])
					if n.get("tier", "") != "T2": wrong.append("%d %s not marked Tier 2" % [row, n.id])
					for li in n.layers.size():
						var L: Dictionary = n.layers[li]
						var main: String = L.ice[L.ice.size() - 1]
						if tier_of(main) != "T2": wrong.append("%d %s main %s" % [row, n.id, main])
						if int(L.reserve) != [15, 20][li]: wrong.append("%d %s reserve" % [row, n.id])
						if L.ice.size() == 2 and tier_of(L.ice[0]) != "T1": wrong.append("%d %s support" % [row, n.id])
						if L.ice.size() > 2 or (li == 0 and L.ice.size() != 1): wrong.append("%d %s layout" % [row, n.id])
					if row == 9: row9 += 1
					if row >= 10:
						if n.layers.size() == 1: one += 1
						else: two += 1
				if row < 9 and ids.any(func(id): return tier_of(id) == "T2"): early_t2.append("%d %s" % [row, n.id])
		check(early_t2.is_empty(), "map %d: no Tier 2 ICE before row 9 %s" % [k, early_t2])
		check(wrong.is_empty(), "map %d: tier by row %s" % [k, wrong])
	check(row9 > 0, "row 9 has ordinary ICE Nodes on the generated maps (%d)" % row9)
	check(one > 0 and two > 0, "rows 10–15 have both 1- and 2-layer Tier 2 Nodes (%d / %d)" % [one, two])

func game_with(ids: Array, tier := "T2") -> Game:
	var g := Game.new(3)
	g.new_run("VECTOR")
	g.node = {"id": "SPEC", "kind": "ICE", "name": "SPEC", "tier": tier, "layers": [{"ice": ids, "reserve": 15}], "next": [0]}
	g._start_ice_node()
	g.phase = "PLAYER"; g.pending = {}
	return g

func effects() -> void:
	# PURGE ALL: every ICE loses every virus counter.
	var g := game_with(["NANNY_CAM", "FIRMWARE_UPDATE"])
	g.infect(0, "ROT", 3)
	g.infect(1, "ROT", 2)
	check(g.virus_total(0) == 3 and g.virus_total(1) == 2, "virus counters on both ICE")
	g.acting_ice = g.enc.ice[1]
	g._apply_effect({"k": "PURGE_ALL"})
	check(g.virus_total(0) == 0 and g.virus_total(1) == 0, "PURGE ALL removes every counter from every ICE")
	# PANIC BUTTON: the TRACER goes into the draw pile, not the hand.
	var p := game_with(["PANIC_BUTTON"])
	var hand_before := p.hand.size()
	var tracers := p.draw_pile.filter(func(c): return c.id == "TRACER").size()
	p._apply_effect(IceDB.def("PANIC_BUTTON").subs[0][0])
	check(p.draw_pile.filter(func(c): return c.id == "TRACER").size() == tracers + 1 and p.hand.size() == hand_before, "PANIC BUTTON: 1 TRACER into the draw pile")
	# DEADBOLT: STR never below 3.
	var d := game_with(["DEADBOLT"])
	d.enc.ice[0].str_mod = -20
	d._sync_strengths()
	check(d.ice_str(0) == 3, "DEADBOLT's STR stops at 3 (%d)" % d.ice_str(0))
	# PACE-008 reward odds.
	check(game_with(["SMART_LOCK"]).reward_odds(1) == [45, 40, 15], "Tier 2 1-layer reward odds 45/40/15")
	check(game_with(["SMART_LOCK"]).reward_odds(2) == [30, 45, 25], "Tier 2 2-layer reward odds 30/45/25")
	check(game_with(["CAPTCHA"], "T1").reward_odds(1) == [60, 30, 10], "Tier 1 1-layer reward odds 60/30/10")
	# The V2 encounter view models every Tier 2 ICE, in words a player can read (no raw effect keys).
	for id in IceDB.TIER2:
		var v := game_with(["CAPTCHA", id])
		for ice in v.enc.ice:
			for s in ice.seen.size(): ice.seen[s] = true
		var ctrl := EncounterController.new(); ctrl.bind(v)
		var models := VisibleStateAdapter.ice_models(v, ctrl)
		var shown := []
		_shown_text(models, shown)
		var text := " | ".join(shown)
		check(models.size() == 2 and not shown.is_empty() and not text.contains("_") and not text.contains(" 0 "), "%s: the V2 view names its subroutines in plain words (%s)" % [id, text])
	check(VisibleStateAdapter.effect_word({"k": "PURGE_ALL"}) == "PURGE ALL", "PURGE ALL is named in plain words")
	check(game_with(["SMART_LOCK"]).ice_str(0) == 8, "SMART LOCK enters at STR 8")

func _shown_text(v: Variant, out: Array) -> void:
	## The words a player reads: every "title" and "text" in the view models (not internal keys such as "kind").
	if v is Dictionary:
		for k in v:
			if k in ["title", "text"] and v[k] is String: out.append(v[k])
			elif k != "ref": _shown_text(v[k], out)
	elif v is Array:
		for x in v: _shown_text(x, out)

func slice_default() -> void:
	var g := Game.new(1)
	g.new_run()
	check(g.map_rows.size() == 4 and JSON.stringify(g.map_rows) == JSON.stringify(IceDB.MAP), "the four-row slice map stays the default")
	var ids := []
	for row in IceDB.MAP:
		for n in row:
			for L in n.get("layers", []): ids.append_array(L.ice)
	check(not ids.any(func(id): return tier_of(id) == "T2"), "the slice map has no Tier 2 ICE")
