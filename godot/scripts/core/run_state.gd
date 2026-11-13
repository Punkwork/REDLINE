extends RefCounted
## Everything that lasts for a whole run: the Rustler, VITAE, TRACE, CRED, deck and Ghostware.
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
var corporation_id := "training"
var rng := RandomNumberGenerator.new()
var _next_uid := 1


func setup(game_data, p_rustler_id: String, seed_value: int = 0) -> void:
	db = game_data
	rustler_id = p_rustler_id
	if seed_value != 0:
		rng.seed = seed_value
	else:
		rng.randomize()
	var stats: Dictionary = db.starting_stats()
	vitae = int(stats["vitae"])
	max_vitae = int(stats["max_vitae"])
	draw_size = int(stats["draw"])
	ram = int(stats["ram"])
	trace = 0
	strikes = 0
	cred = 0
	void_counters = 0
	deck.clear()
	var rustler: Dictionary = db.rustlers[rustler_id]
	for entry in rustler["starter_deck"]:
		for i in int(entry["qty"]):
			add_card(entry["card"])
	ghostware = [rustler["origin_ghostware"]]


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


func has_ghostware(id: String) -> bool:
	return ghostware.has(id)
