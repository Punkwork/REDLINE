extends RefCounted
## One corporation heist (HALCYON, IRONWATCH or LUCIDA) for the economy playtest: the 10 infiltration rows and the Central Node.
## (The escape isn't in this slice yet.) Owns the map, the non-ICE rooms (Uplink, DEAD DROP,
## SAFEHOUSE, Console Lab, SIGNAL UNCLEAR) and the playtest summary. ICE Nodes run in NodeRun.
##
## Map rules follow Core Rules §10.1 and REDLINE_UPLINK_AND_CAPS.md §3.3. Prices and reserves come
## from rules.json, so they can be tuned between playtests without touching code.

signal changed
signal logged(text: String)

const NodeRun = preload("res://scripts/core/node_run.gd")
const RunState = preload("res://scripts/core/run_state.gd")

const PHASE_MAP := "map"
const PHASE_ENCOUNTER := "encounter"
const PHASE_ROOM := "room"          ## uplink, dead_drop, safehouse, console_lab, event
const PHASE_PICK := "pick_card"     ## choosing a card from the deck (removal, trade)
const PHASE_SUMMARY := "summary"

const ROWS := 10               ## infiltration rows (MAP-002): 1 Opening Node, 2–5 Tier 1, 6–9 Tier 2, 10 Uplink/DEAD DROP
const LAST_T1_ROW := 4         ## 0-based: rows 2–5 are Tier 1
const UPLINK_ROWS := [3, 6]    ## 0-based: rows 4 and 7 always offer an Uplink
const FINAL_ROW := ROWS - 1    ## row 10: Uplink or DEAD DROP only
const WIDTH := 3

var db
var run
var corp_id := "halcyon"
var corp: Dictionary
var rows: Array = []          ## rows[r] = [{ "type", "label", "links": [ints], "data": {} }]
var row_index := -1
var pos := -1
var path: Array = []          ## [[row, column]] visited
var phase := ""
var room := {}                ## the current non-ICE room: { "type", ... }
var pick := {}                ## { "prompt", "action", "ctx" }
var node                      ## NodeRun for the current ICE encounter
var current_node_info := {}
var won := false
var log_lines: Array[String] = []
var start_msec := 0


func setup(game_data, rustler_id: String, seed_value: int = 0, p_corp_id: String = "halcyon") -> void:
	db = game_data
	corp_id = p_corp_id
	run = RunState.new()
	run.setup(db, rustler_id, seed_value)
	corp = db.corporations[corp_id]


func start() -> void:
	start_msec = Time.get_ticks_msec()
	for note in run.start_corporation(corp_id):
		_log(note)
	_generate_map()
	phase = PHASE_MAP
	_log("== %s: infiltrate 10 rows to the Central Node. ==" % corp["name"])
	changed.emit()


# ------------------------------------------------------------------ map

func _generate_map() -> void:
	rows.clear()
	var safehouse_rows: Array = []
	var candidates: Array = [1, 2, 4, 5, 7, 8]   # never the Opening Node, an Uplink row or row 10
	candidates.shuffle()
	for i in run.rng.randi_range(1, 2):
		safehouse_rows.append(candidates[i])
	for r in ROWS:
		var row: Array = []
		for c in WIDTH:
			row.append({"type": _roll_type(r), "data": {}})
		if UPLINK_ROWS.has(r):
			row[run.rng.randi_range(0, WIDTH - 1)]["type"] = "uplink"
		if r == FINAL_ROW:
			row = [{"type": "uplink", "data": {}}, {"type": "dead_drop", "data": {}}, {"type": "uplink", "data": {}}]
		if r == 0:
			row = [{"type": "opener", "data": {}}]
		if safehouse_rows.has(r):
			var options: Array = range(WIDTH).filter(func(c): return row[c]["type"] != "uplink")
			row[options[run.rng.randi_range(0, options.size() - 1)]]["type"] = "safehouse"
		if r > 0 and r < FINAL_ROW and not row.any(func(n): return n["type"].begins_with("ice")):
			var options2: Array = range(WIDTH).filter(func(c): return row[c]["type"] != "uplink" and row[c]["type"] != "safehouse")
			if not options2.is_empty():
				row[options2[0]]["type"] = "ice_t1" if r <= LAST_T1_ROW else "ice_t2"
		for c in row.size():
			var n: Dictionary = row[c]
			n["links"] = range(WIDTH) if r == 0 else range(max(0, c - 1), min(WIDTH, c + 2))
			if n["type"] == "uplink":
				n["data"]["clinic"] = run.rng.randf() < float(db.rules["uplink"]["clinic_chance"])
			n["label"] = node_label(n)
		rows.append(row)
	rows.append([{"type": "central", "data": {}, "links": [], "label": "CENTRAL NODE"}])
	for c in WIDTH:
		rows[FINAL_ROW][c]["links"] = [0]


func _roll_type(r: int) -> String:
	var roll: float = run.rng.randf()
	if r == 0:
		return "ice_t1"
	var odds: Dictionary = db.rules["map"]["node_odds"]
	if r <= LAST_T1_ROW:
		return "ice_t1" if roll < float(odds["tier1_ice"]) else "signal"
	if roll < float(odds["tier2_ice"]):
		return "ice_t2"
	if roll < float(odds["tier2_ice"]) + float(odds["tier2_signal"]):
		return "signal"
	return "console_lab"


static func node_label(n: Dictionary) -> String:
	match n["type"]:
		"opener":
			return "OPENING NODE"
		"ice_t1":
			return "ICE (Tier 1)"
		"ice_t2":
			return "ICE (Tier 2)"
		"uplink":
			return "UPLINK + CLINIC" if n["data"].get("clinic", false) else "UPLINK"
		"dead_drop":
			return "DEAD DROP"
		"safehouse":
			return "SAFEHOUSE"
		"console_lab":
			return "CONSOLE LAB"
		"signal":
			return "SIGNAL UNCLEAR"
		"central":
			return "CENTRAL NODE"
	return n["type"]


func reachable() -> Array:
	if phase != PHASE_MAP:
		return []
	if row_index < 0:
		return range(rows[0].size())
	return rows[row_index][pos]["links"]


func choose_node(c: int) -> void:
	if not reachable().has(c):
		return
	row_index += 1
	pos = c
	path.append([row_index, c])
	var n: Dictionary = rows[row_index][c]
	current_node_info = {"row": row_index + 1, "type": n["label"], "cred_before": run.cred,
			"earned_before": run.stats["cred_earned"], "notes": ""}
	_log("-- Row %d: %s --" % [row_index + 1, n["label"]])
	match n["type"]:
		"opener":
			var o: Dictionary = corp["opener"]
			_start_encounter([{"ice": o["ice_left_to_right"], "cred_reserve": int(o["cred_reserve"])}], false)
		"ice_t1":
			_start_encounter(_ice_layers(1, run.rng.randi_range(1, 2)), false)
		"ice_t2":
			_start_encounter(_ice_layers(2, run.rng.randi_range(2, 3)), false)
		"central":
			var c_def: Dictionary = corp["central_node"]
			_start_encounter([{"ice": c_def["ice_left_to_right"], "cred_reserve": int(db.rules["cred_reserves"]["central"])}], true)
		"uplink":
			_open_uplink(n["data"].get("clinic", false))
		"dead_drop":
			_open_room({"type": "dead_drop"})
		"safehouse":
			_open_room({"type": "safehouse"})
		"console_lab":
			_open_room({"type": "console_lab"})
		"signal":
			_open_event()


# ------------------------------------------------------------------ ICE encounters

func _ice_pool(tier: int) -> Array:
	return corp["tier%d" % tier].duplicate()


func _pick(pool: Array, exclude: Array) -> String:
	var options: Array = pool.filter(func(id): return not exclude.has(id))
	return options[run.rng.randi_range(0, options.size() - 1)]


## Builds layers per HALCYON ICE §8.1, with reserves from rules.json.
func _ice_layers(tier: int, count: int) -> Array:
	var t1 := _ice_pool(1)
	var main_pool := _ice_pool(tier)
	var reserves: Array = db.rules["cred_reserves"]["tier%d" % tier]
	var out: Array = []
	for i in count:
		var ice: Array = []
		var main := _pick(main_pool, [])
		if i == 1 and run.rng.randf() < 0.5:
			ice.append(_pick(t1, [main]))
		if i == 2:
			var s1 := _pick(t1, [main])
			ice.append(s1)
			ice.append(_pick(t1, [main, s1]))
		ice.append(main)
		out.append({"ice": ice, "cred_reserve": int(reserves[min(i, reserves.size() - 1)])})
	return out


func _start_encounter(layers: Array, central: bool) -> void:
	node = NodeRun.new()
	node.setup(db, run, corp_id, layers, {"central": central})
	node.logged.connect(func(t): logged.emit(t))
	phase = PHASE_ENCOUNTER
	changed.emit()
	node.start()


## Call when the NodeRun reaches "node_complete" or "defeat".
func finish_encounter() -> void:
	if node == null:
		return
	current_node_info["layers"] = "%d/%d" % [node.layers_cleared, node.layers.size()]
	current_node_info["card"] = node.reward_taken
	current_node_info["notes"] = "JACK OUT" if node.jacked_out else ""
	var was_central: bool = node.is_central
	var defeated: bool = node.phase == NodeRun.PHASE_DEFEAT
	_record_node()
	node = null
	if defeated:
		_end_run(false)
	elif was_central:
		_end_run(true)
	else:
		phase = PHASE_MAP
		changed.emit()


func _record_node() -> void:
	current_node_info["cred_earned"] = int(run.stats["cred_earned"]) - int(current_node_info["earned_before"])
	current_node_info["cred_spent"] = max(0, int(current_node_info["cred_before"]) + int(current_node_info["cred_earned"]) - run.cred)
	run.stats["nodes"].append(current_node_info.duplicate())


# ------------------------------------------------------------------ Uplink

func _open_uplink(clinic: bool) -> void:
	var u: Dictionary = db.rules["uplink"]
	var prices: Dictionary = db.rules["prices"]
	var items: Array = []   # No basic cards are ever sold here (BASIC-001).
	var taken: Array = []
	for owner in ["shared", "shared", "shared", "shared", run.rustler_id, run.rustler_id]:
		var rarity: String = run.roll_rarity()
		var id: String = run.random_card_id(rarity, owner, taken)
		if id == "":
			continue
		taken.append(id)
		items.append({"kind": "card", "id": id, "price": int(prices["card"][db.cards[id]["rarity"]]), "shelf": "Cards"})
	var card_slots: Array = range(items.size()).filter(func(i): return items[i]["shelf"] == "Cards")
	if not card_slots.is_empty():
		var sale: int = card_slots[run.rng.randi_range(0, card_slots.size() - 1)]
		items[sale]["price"] = int(items[sale]["price"] * (1.0 - float(u["sale_discount"])))
		items[sale]["sale"] = true
	var bootleg_slot: int = run.rng.randi_range(0, int(u["caps"]) - 1) if run.rng.randf() < 0.5 else -1
	for i in int(u["caps"]):
		var cid: String = run.random_cap_id()
		var price := int(db.caps[cid]["price"])
		var bootleg := i == bootleg_slot
		if bootleg:
			price = int(price * float(db.raw["caps"]["rules"]["bootleg"]["price_multiplier"]))
		items.append({"kind": "cap", "id": cid, "price": price, "bootleg": bootleg, "shelf": "CAPS"})
	var gpool: Array = run.ghostware_offer_pool("general")
	gpool.shuffle()
	var gcount: int = run.rng.randi_range(int(u["ghostware"][0]), int(u["ghostware"][1]))
	for i in min(gcount, gpool.size()):
		var gid: String = gpool[i]
		var gprice := int(prices["ghostware_with_drawback"] if db.ghostware[gid].has("drawback") else prices["ghostware"])
		items.append({"kind": "ghostware", "id": gid, "price": gprice, "shelf": "Ghostware"})
	_open_room({"type": "uplink", "items": items, "clinic": clinic, "wipe_used": false, "clinic_used": false})


func wipe_price() -> int:
	var w: Dictionary = db.rules["prices"]["uplink_wipe"]
	return int(w["base"]) + int(w["increase_per_use"]) * run.wipes_used


func clinic_price() -> int:
	return int(db.rules["prices"]["clinic_void_removal"])


func can_buy(i: int) -> String:
	if room.get("type", "") != "uplink" or i < 0 or i >= room["items"].size():
		return "Not here."
	var item: Dictionary = room["items"][i]
	if item.get("sold", false):
		return "Sold."
	if item["price"] > run.cred:
		return "Not enough CRED."
	if item["kind"] == "cap" and run.free_cap_slots() <= 0:
		return "No free CAP slot."
	return ""


func buy(i: int) -> bool:
	if can_buy(i) != "":
		return false
	var item: Dictionary = room["items"][i]
	var name := item_name(item)
	var category: String = {"card": "cards", "cap": "CAPS", "ghostware": "Ghostware"}[item["kind"]]
	run.spend(item["price"], category, name)
	item["sold"] = true
	match item["kind"]:
		"card":
			run.add_card(item["id"])
			run.stats["cards_bought"] += 1
		"cap":
			run.gain_cap(item["id"], item.get("bootleg", false), "bought")
		"ghostware":
			run.add_ghostware(item["id"])
	_log("Bought %s for %d CRED (%d left)." % [name, item["price"], run.cred])
	changed.emit()
	return true


func item_name(item: Dictionary) -> String:
	match item["kind"]:
		"card":
			return db.cards[item["id"]]["name"]
		"cap":
			return db.caps[item["id"]]["name"] + (" (BOOTLEG)" if item.get("bootleg", false) else "")
		"ghostware":
			return db.ghostware[item["id"]]["name"]
	return item["id"]


func item_text(item: Dictionary) -> String:
	match item["kind"]:
		"card":
			var d: Dictionary = db.cards[item["id"]]
			var cost := "—" if d["cost_bw"] == null else str(int(d["cost_bw"]))
			return "%s · %s · %s BW\n%s" % [d["type"], d["rarity"], cost, d["text"]]
		"cap":
			var c: Dictionary = db.caps[item["id"]]
			var t: String = "CAP · %s\n%s" % [c["rarity"], c["text"]]
			if item.get("bootleg", false):
				t += "\nBOOTLEG: 25% chance to fizzle for +3 TRACE."
			return t
		"ghostware":
			var g: Dictionary = db.ghostware[item["id"]]
			return "GHOSTWARE\n%s%s" % [g["text"], ("\n⚠ " + g["drawback"]) if g.has("drawback") else ""]
	return ""


func start_wipe() -> void:
	if room.get("type", "") != "uplink" or room["wipe_used"] or run.cred < wipe_price():
		return
	_start_pick("WIPE: choose a card to remove permanently (%d CRED)." % wipe_price(), "wipe", {})


func use_clinic() -> void:
	if room.get("type", "") != "uplink" or not room["clinic"] or room["clinic_used"] or run.void_counters == 0:
		return
	if run.spend(clinic_price(), "Clinic", "remove VOID"):
		room["clinic_used"] = true
		run.void_counters = 0
		_log("Clinic: all VOID removed.")
		changed.emit()


# ------------------------------------------------------------------ other rooms

func _open_room(r: Dictionary) -> void:
	room = r
	phase = PHASE_ROOM
	changed.emit()


func room_choice(key: String) -> void:
	if phase != PHASE_ROOM:
		return
	match room["type"]:
		"dead_drop":
			if key == "patch_up":
				_heal(10)
				_log("PATCH UP: +10 VITAE.")
			elif key == "wipe_trail":
				run.trace = max(0, run.trace - 20)
				_log("WIPE TRAIL: −20 TRACE.")
			leave_room()
		"safehouse":
			if key == "heal":
				_heal(10)
				_log("SAFEHOUSE: +10 VITAE.")
			leave_room()
		"console_lab":
			if key == "remove":
				var price := int(db.rules["prices"]["console_lab_removal"])
				if run.cred >= price:
					_start_pick("CONSOLE LAB: choose a card to remove (%d CRED)." % price, "console_lab", {})
					return
			leave_room()
		"event":
			_resolve_event_choice(int(key))


func leave_room() -> void:
	if phase != PHASE_ROOM and phase != PHASE_PICK:
		return
	room = {}
	_record_node()
	phase = PHASE_MAP
	changed.emit()


func _heal(n: int) -> void:
	run.vitae = min(run.max_vitae, run.vitae + n)


# ------------------------------------------------------------------ SIGNAL UNCLEAR

func _open_event() -> void:
	var excluded := ["black_clinic"]   # PATCHWORK isn't in this build yet
	var events: Array = db.raw["events"]["events"].filter(func(e): return not excluded.has(e["id"]))
	var total := 0.0
	for e in events:
		total += float(e["weight"])
	var roll: float = run.rng.randf() * total
	var chosen: Dictionary = events[-1]
	for e in events:
		roll -= float(e["weight"])
		if roll <= 0:
			chosen = e
			break
	current_node_info["type"] = "SIGNAL UNCLEAR: " + chosen["name"]
	_open_room({"type": "event", "event": chosen})


func event_choice_allowed(i: int) -> bool:
	var ch: Dictionary = room["event"]["choices"][i]
	if ch.get("requires", "") == "free_cap_slot" and run.free_cap_slots() <= 0:
		return false
	return true


func _resolve_event_choice(i: int) -> void:
	var ev: Dictionary = room["event"]
	if i < 0 or i >= ev["choices"].size() or not event_choice_allowed(i):
		return
	var effects: Array = ev["choices"][i]["effects"]
	current_node_info["notes"] = ev["choices"][i]["label"]
	var pending := ""
	for e in effects:
		match e["op"]:
			"gain_cred":
				run.gain_cred(int(e["n"]), "events")
				_log("+%d CRED." % int(e["n"]))
			"gain_random_cap":
				var cid: String = run.random_cap_id()
				run.gain_cap(cid, false, "event")
				_log("Gained %s." % db.caps[cid]["name"])
			"add_random_card":
				var id: String = run.random_card_id(e.get("rarity", ""))
				if id != "":
					run.add_card(id)
					run.stats["cards_other"] += 1
					_log("Added %s." % db.cards[id]["name"])
			"trace":
				run.trace = clampi(run.trace + int(e["n"]), 0, int(db.rules["trace"]["max"]) - 1)
				_log("TRACE %+d → %d." % [int(e["n"]), run.trace])
			"heal":
				_heal(int(e["n"]))
				_log("Heal %d." % int(e["n"]))
			"pulp_direct":
				run.vitae -= int(e["n"])
				_log("−%d VITAE." % int(e["n"]))
			"gain_random_ghostware":
				var pool: Array = run.ghostware_offer_pool("general")
				if not pool.is_empty():
					var gid: String = pool[run.rng.randi_range(0, pool.size() - 1)]
					run.add_ghostware(gid)
					_log("Gained Ghostware: %s." % db.ghostware[gid]["name"])
			"remove_card":
				pending = "event_remove"
			"trade_up":
				pending = "trade_up"
			"start_encounter":
				var tier := 1 if row_index <= LAST_T1_ROW else 2
				var reserves: Array = db.rules["cred_reserves"]["tier%d" % tier]
				room = {}
				_start_encounter([{"ice": [_pick(_ice_pool(tier), [])], "cred_reserve": int(reserves[0])}], false)
				return
	if run.vitae <= 0:
		run.vitae = 0
		_end_run(false)
		return
	if pending == "event_remove":
		_start_pick("Choose a card to remove from your deck.", "event_remove", {})
	elif pending == "trade_up":
		_start_pick("Choose a card to trade for a random card one rarity higher.", "trade_up", {})
	else:
		leave_room()


# ------------------------------------------------------------------ picking a card from the deck

func _start_pick(prompt: String, action: String, ctx: Dictionary) -> void:
	pick = {"prompt": prompt, "action": action, "ctx": ctx}
	phase = PHASE_PICK
	changed.emit()


func pick_options() -> Array:
	var out: Array = []
	for inst in run.deck:
		out.append({"uid": inst["uid"], "label": db.cards[inst["id"]]["name"], "id": inst["id"]})
	out.sort_custom(func(a, b): return a["label"] < b["label"])
	return out


## uid -1 cancels (only where cancelling is allowed: the Uplink and Console Lab).
func resolve_pick(uid: int) -> void:
	if phase != PHASE_PICK:
		return
	var action: String = pick["action"]
	pick = {}
	if uid == -1:
		if action == "wipe":
			phase = PHASE_ROOM
			changed.emit()
		else:
			leave_room()
		return
	var card_id := ""
	for inst in run.deck:
		if inst["uid"] == uid:
			card_id = inst["id"]
	var name: String = db.cards[card_id]["name"] if card_id != "" else "?"
	match action:
		"wipe":
			var price := wipe_price()
			run.spend(price, "Wipe", name)
			run.wipes_used += 1
			run.remove_card(uid)
			room["wipe_used"] = true
			_log("WIPE: removed %s for %d CRED." % [name, price])
			phase = PHASE_ROOM
			changed.emit()
			return
		"console_lab":
			run.spend(int(db.rules["prices"]["console_lab_removal"]), "Console Lab", name)
			run.remove_card(uid)
			_log("CONSOLE LAB: removed %s." % name)
		"event_remove":
			run.remove_card(uid)
			_log("DATA PURGE: removed %s." % name)
		"trade_up":
			var rarity: String = db.cards[card_id]["rarity"]
			var up: String = {"common": "uncommon", "uncommon": "rare"}.get(rarity, "rare")
			run.remove_card(uid)
			run.stats["cards_removed"] -= 1
			var nid: String = run.random_card_id(up)
			if nid != "":
				run.add_card(nid)
				_log("Traded %s for %s." % [name, db.cards[nid]["name"]])
	leave_room()


# ------------------------------------------------------------------ end of run and summary

func _end_run(p_won: bool) -> void:
	won = p_won
	phase = PHASE_SUMMARY
	_log("== Run over: %s ==" % ("Central Node cracked" if won else "flatlined"))
	changed.emit()


func summary_text() -> String:
	var s: Dictionary = run.stats
	var lines: Array[String] = []
	var minutes := float(Time.get_ticks_msec() - start_msec) / 60000.0
	lines.append("REDLINE economy playtest — %s (10 rows + Central Node, no escape)" % corp["name"])
	lines.append("Rustler: %s · Result: %s · Time: %.0f min" % [db.rustlers[run.rustler_id]["name"],
			"Central Node cracked" if won else "flatlined at row %d" % (row_index + 1), minutes])
	lines.append("End state: VITAE %d/%d · TRACE %d · strikes %d · VOID %d" % [run.vitae, run.max_vitae, run.trace, run.strikes, run.void_counters])
	lines.append("")
	var seen := int(s.get("reserve_seen", 0))
	lines.append("CRED earned: %d · CRED in the reserves you faced: %d (extracted %d%%)" % [s["cred_earned"], seen, roundi(100.0 * int(s["cred_by_source"].get("extraction", 0)) / max(1, seen))])
	for k in s["cred_by_source"].keys():
		lines.append("  %s: %d" % [k, s["cred_by_source"][k]])
	lines.append("CRED spent: %d · unspent: %d" % [s["cred_spent"], run.cred])
	for k in s["spent_by_category"].keys():
		lines.append("  %s: %d" % [k, s["spent_by_category"][k]])
	lines.append("")
	var added: int = int(s["cards_from_rewards"]) + int(s["cards_bought"]) + int(s["cards_other"])
	lines.append("Cards added: %d (rewards %d, bought %d, other %d) · removed: %d · deck now %d" % [
			added, s["cards_from_rewards"], s["cards_bought"], s["cards_other"], s["cards_removed"], run.deck.size()])
	var gains: Array = []
	for k in s["caps_gained"].keys():
		gains.append("%s %d" % [k, s["caps_gained"][k]])
	lines.append("CAPS gained: %s · used: %d · held: %d" % [", ".join(gains) if not gains.is_empty() else "none", s["caps_used"], run.caps.size()])
	lines.append("Ghostware: %s" % ", ".join(run.ghostware.map(func(g): return db.ghostware[g]["name"])))
	lines.append("")
	lines.append("Purchases:")
	if s["purchases"].is_empty():
		lines.append("  (none)")
	for p in s["purchases"]:
		lines.append("  %s — %s: %d CRED" % [p["category"], p["item"], p["price"]])
	lines.append("")
	lines.append("Route:")
	for n in s["nodes"]:
		var extra := ""
		if n.has("layers"):
			extra = " · layers %s · card: %s" % [n["layers"], n["card"] if n["card"] != "" else "—"]
		if n.get("notes", "") != "":
			extra += " · " + n["notes"]
		lines.append("  Row %d %s: +%d CRED, −%d spent%s" % [n["row"], n["type"], n["cred_earned"], n["cred_spent"], extra])
	return "\n".join(lines)


func _log(text: String) -> void:
	log_lines.append(text)
	logged.emit(text)
