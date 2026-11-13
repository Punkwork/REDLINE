extends RefCounted
## Everything that lasts for a whole run: the Rustler, VITAE, TRACE, CRED, deck, CAPS, Ghostware,
## and the economy statistics the playtest summary reports.
## A deck entry is a card instance: {"uid": int, "id": String}. PATCHWORK will attach to instances.

var db  ## GameData
var rustler_id := ""
var vitae := 0
var max_vitae := 0
var trace := 0
var strikes := 0
var cred := 0
var void_counters := 0
var draw_size := 5
var ram := 4
var deck: Array = []
var ghostware: Array[String] = []
var caps: Array = []            ## [{"id": String, "bootleg": bool}]
var cap_slots := 3
var corporation_id := "training"
var scrambled_used := false     ## SCRAMBLED ID: first strike this corporation already ignored
var wipes_used := 0
var rng := RandomNumberGenerator.new()
var _next_uid := 1

## Economy statistics for the playtest summary.
var stats := {}


func setup(game_data, p_rustler_id: String, seed_value: int = 0) -> void:
	db = game_data
	rustler_id = p_rustler_id
	if seed_value != 0:
		rng.seed = seed_value
	else:
		rng.randomize()
	var s: Dictionary = db.starting_stats()
	vitae = int(s["vitae"])
	max_vitae = int(s["max_vitae"])
	draw_size = int(s["draw"])
	ram = int(s["ram"])
	cap_slots = int(db.raw["caps"]["rules"]["slots"])
	trace = 0
	strikes = 0
	cred = 0
	void_counters = 0
	wipes_used = 0
	deck.clear()
	caps.clear()
	stats = {
		"cred_earned": 0, "cred_by_source": {}, "cred_spent": 0, "spent_by_category": {},
		"purchases": [], "cards_from_rewards": 0, "cards_bought": 0, "cards_other": 0,
		"cards_removed": 0, "caps_used": 0, "caps_gained": {}, "nodes": [],
	}
	var rustler: Dictionary = db.rustlers[rustler_id]
	for entry in rustler["starter_deck"]:
		for i in int(entry["qty"]):
			add_card(entry["card"])
	ghostware.clear()
	add_ghostware(rustler["origin_ghostware"])


# ------------------------------------------------------------------ cards

func add_card(card_id: String) -> Dictionary:
	var inst := {"uid": _next_uid, "id": card_id}
	_next_uid += 1
	deck.append(inst)
	return inst


## A temporary card (Bloatware) that is not part of the deck and disappears at Node end.
func make_temp_card(card_id: String) -> Dictionary:
	var inst := {"uid": _next_uid, "id": card_id, "temporary": true}
	_next_uid += 1
	return inst


func remove_card(uid: int) -> bool:
	for inst in deck:
		if inst["uid"] == uid:
			deck.erase(inst)
			stats["cards_removed"] += 1
			return true
	return false


func roll_rarity(odds: Dictionary = {}) -> String:
	if odds.is_empty():
		odds = db.rules["rewards"]["rarity_odds"]
	var roll := rng.randf()
	if roll < float(odds["rare"]):
		return "rare"
	if roll < float(odds["rare"]) + float(odds["uncommon"]):
		return "uncommon"
	return "common"


## A random reward-pool card id. owner "" picks shared or this Rustler's pool.
func random_card_id(rarity: String = "", owner: String = "", exclude: Array = []) -> String:
	var owners: Array = [owner] if owner != "" else ["shared", rustler_id]
	var pool: Array = []
	for o in owners:
		pool.append_array(db.reward_pool(o, rarity))
	pool = pool.filter(func(id): return not exclude.has(id))
	if pool.is_empty():
		return ""
	return pool[rng.randi_range(0, pool.size() - 1)]


# ------------------------------------------------------------------ Ghostware

func has_ghostware(id: String) -> bool:
	return ghostware.has(id)


## Adds a Ghostware and applies its permanent stat changes.
func add_ghostware(id: String) -> void:
	if ghostware.has(id):
		return
	ghostware.append(id)
	var g: Dictionary = db.ghostware.get(id, {})
	for e in g.get("effects", []):
		if e.has("when"):
			continue
		match e["op"]:
			"max_vitae":
				max_vitae += int(e["n"])
				if int(e["n"]) > 0:
					vitae += int(e["n"])
				vitae = min(vitae, max_vitae)
			"ram":
				ram += int(e["n"])
			"cap_slots":
				cap_slots += int(e["n"])
			"draw_stat":
				draw_size += int(e["n"])


## Ghostware that could be offered (general pool, enabled, not owned).
func ghostware_offer_pool(pool_name: String = "general") -> Array:
	var out: Array = []
	for g in db.raw["ghostware"]["ghostware"]:
		if g["pool"] == pool_name and g.get("enabled", true) and not ghostware.has(g["id"]):
			out.append(g["id"])
	return out


## Runs a corporation's start-of-corporation effects (SPARE SOCKET, BLACK MIRROR, SLEEPER AGENT).
func start_corporation(corp_id: String) -> Array[String]:
	corporation_id = corp_id
	trace = 0
	strikes = 0
	void_counters = 0
	scrambled_used = false
	var notes: Array[String] = []
	if has_ghostware("spare_socket") and free_cap_slots() > 0:
		var id := random_cap_id("common")
		gain_cap(id, false, "Ghostware")
		notes.append("SPARE SOCKET: gained %s." % db.caps[id]["name"])
	if has_ghostware("black_mirror"):
		trace += 10
		notes.append("BLACK MIRROR: start at 10 TRACE.")
	if has_ghostware("sleeper_agent"):
		var cid := random_card_id("rare")
		if cid != "":
			add_card(cid)
			stats["cards_other"] += 1
			notes.append("SLEEPER AGENT: added %s." % db.cards[cid]["name"])
	return notes


# ------------------------------------------------------------------ CAPS

func free_cap_slots() -> int:
	return cap_slots - caps.size()


func random_cap_id(rarity: String = "") -> String:
	if rarity == "":
		rarity = roll_rarity()
	var pool: Array = db.raw["caps"]["caps"].filter(func(c): return c["rarity"] == rarity).map(func(c): return c["id"])
	return pool[rng.randi_range(0, pool.size() - 1)]


func gain_cap(id: String, bootleg: bool = false, source: String = "") -> bool:
	if free_cap_slots() <= 0:
		return false
	caps.append({"id": id, "bootleg": bootleg})
	if source != "":
		stats["caps_gained"][source] = int(stats["caps_gained"].get(source, 0)) + 1
	return true


# ------------------------------------------------------------------ CRED

func gain_cred(n: int, source: String) -> void:
	if n <= 0:
		return
	cred += n
	stats["cred_earned"] += n
	stats["cred_by_source"][source] = int(stats["cred_by_source"].get(source, 0)) + n


func spend(n: int, category: String, label: String) -> bool:
	if n > cred:
		return false
	cred -= n
	stats["cred_spent"] += n
	stats["spent_by_category"][category] = int(stats["spent_by_category"].get(category, 0)) + n
	stats["purchases"].append({"category": category, "item": label, "price": n})
	return true
