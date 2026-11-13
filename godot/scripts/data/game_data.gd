extends RefCounted
## Loads and indexes the game data in res://data/*.json.
##
## Usage:
##     const GameData = preload("res://scripts/data/game_data.gd")
##     var db = GameData.new()
##     var ok := db.load_all()      # false if any file failed; see db.errors
##
## JSON numbers load as floats in Godot. Callers should wrap numeric fields in int().

const DATA_DIR := "res://data/"
const FILES := ["cards", "rustlers", "ice", "caps", "ghostware", "patchwork",
		"events", "contracts", "strains", "rules"]

var raw := {}            ## file name -> parsed Dictionary
var cards := {}          ## card id -> card Dictionary (fused versions included, with "fused_from")
var ice := {}            ## ice id -> ICE Dictionary
var corporations := {}   ## corporation id -> Dictionary
var rustlers := {}       ## rustler id -> Dictionary
var ghostware := {}      ## ghostware id -> Dictionary
var caps := {}           ## cap id -> Dictionary
var strains := {}        ## strain id -> Dictionary
var rules := {}          ## rules.json contents
var errors: Array[String] = []


func load_all() -> bool:
	errors.clear()
	for name in FILES:
		var path: String = DATA_DIR + name + ".json"
		if not FileAccess.file_exists(path):
			errors.append("missing " + path)
			continue
		var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
		if typeof(parsed) != TYPE_DICTIONARY:
			errors.append("cannot parse " + path)
			continue
		raw[name] = parsed
	if not errors.is_empty():
		return false

	for c in raw["cards"]["cards"]:
		cards[c["id"]] = c
		if c.has("fused"):
			var f: Dictionary = c.duplicate(true)
			f.erase("fused")
			f["id"] = c["fused"]["id"]
			f["name"] = c["fused"]["name"]
			f["text"] = c["fused"]["text"]
			f["effects"] = c["fused"]["effects"]
			f["fused_from"] = c["id"]
			cards[f["id"]] = f
	for i in raw["ice"]["ice"]:
		ice[i["id"]] = i
	for corp in raw["ice"]["corporations"]:
		corporations[corp["id"]] = corp
	for r in raw["rustlers"]["rustlers"]:
		rustlers[r["id"]] = r
	for g in raw["ghostware"]["ghostware"]:
		ghostware[g["id"]] = g
	for cap in raw["caps"]["caps"]:
		caps[cap["id"]] = cap
	for s in raw["strains"]["strains"]:
		strains[s["id"]] = s
	rules = raw["rules"]
	return true


func starting_stats() -> Dictionary:
	return raw["rustlers"]["starting_stats"]


## Cards a reward or shop can offer: "shared" or a Rustler id, optionally filtered by rarity.
func reward_pool(owner: String, rarity: String = "") -> Array:
	var out: Array = []
	for c in raw["cards"]["cards"]:
		if c["pool"] != "reward" or c["owner"] != owner:
			continue
		if rarity != "" and c["rarity"] != rarity:
			continue
		out.append(c["id"])
	return out
