class_name CardDB
extends RefCounted
## Card definitions (CSA-03, CONSISTENCY-001a). The card records, CAPS, starter decks and reward pools live in
## res://data/cards.json, the single authoritative source. This class loads it and keeps the API every caller
## uses: DEFS, CAPS, STARTER_*, CORE_POOL, POOL_EXTRA, RUSTLERS, def(), reward_pool(), roles(), caps_of().
## Edit cards in the JSON, not here. The comments that sat on the old constants are in git history (a278aee);
## their decision IDs move into each record's "decisions" field (CSA-03 C2).
const DATA_PATH := "res://data/cards.json"
const SCHEMA := "panopticon.cards/1"
static var DATA: Dictionary = _load_data()
## Every card record, including the approved playtest cards not yet built (status.implementation "pending").
static var RECORDS: Dictionary = DATA.get("cards", {})
## The cards the engine can deal, play and reward: every record except "pending" ones (CSA-03 C2).
static var DEFS: Dictionary = _playable(RECORDS)
static var CAPS: Dictionary = DATA.get("caps", {})
static var STARTER_GENERALIST: Array = DATA.get("starters", {}).get("GENERALIST", [])
static var STARTER_ECHO: Array = DATA.get("starters", {}).get("ECHO", [])
static var STARTER_RIOT: Array = DATA.get("starters", {}).get("RIOT", [])
static var STARTER_VECTOR: Array = DATA.get("starters", {}).get("VECTOR", [])
## Cards offered in a Rustler's reward pool besides those tagged with "pool" (rarity used for the reward roll).
static var POOL_EXTRA: Dictionary = DATA.get("pool_extra", {})
## STRIP-001: reward cards allowed in the core-loop build (only break, defend and build; no switched-off systems).
## Only cards the engine can play: an approved card that is still "pending" (e.g. SYNERGY-PLAYTEST-002) is listed
## in cards.json's core_pool and joins this list automatically once its handler is built (CSA-03 C2).
static var CORE_POOL: Array = _in_defs(DATA.get("core_pool", []))

static func _load_data() -> Dictionary:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(DATA_PATH))
	if not parsed is Dictionary or String(parsed.get("schema", "")) != SCHEMA:
		push_error("CardDB: %s is missing or is not %s" % [DATA_PATH, SCHEMA])
		return {}
	var data: Dictionary = _whole_numbers(parsed)
	_freeze(data)
	return data

static func _playable(records: Dictionary) -> Dictionary:
	var out := {}
	for id in records:
		if String(records[id].get("status", {}).get("implementation", "implemented")) != "pending":
			out[id] = records[id]
	out.make_read_only()
	return out

static func _in_defs(ids: Array) -> Array:
	var out := ids.filter(func(id): return DEFS.has(id))
	out.make_read_only()
	return out

static func design_status(id: String) -> String:
	## "approved", "playtest", "experimental" or "historical" (CSA-03 C2; validated by tools/csa/validate_cards.py).
	return String(RECORDS.get(id, {}).get("status", {}).get("design", ""))

static func _whole_numbers(v: Variant) -> Variant:
	## JSON numbers arrive as floats. Every number in the card data is whole (tools/csa/validate_cards.py checks it).
	if v is float and v == floorf(v):
		return int(v)
	if v is Dictionary:
		var out := {}
		for k in v:
			out[k] = _whole_numbers(v[k])
		return out
	if v is Array:
		var a := []
		for x in v:
			a.append(_whole_numbers(x))
		return a
	return v

static func _freeze(v: Variant) -> void:
	## Read-only, as the old constants were: nothing may change card data at run time.
	if v is Dictionary:
		for k in v:
			_freeze(v[k])
		v.make_read_only()
	elif v is Array:
		for x in v:
			_freeze(x)
		v.make_read_only()


## RUSTLER-001..008 (REDLINE_RUSTLERS.md). Shared stats: 30 VITAE, 4 BW, DRAW 6, 4 RAM.
static var RUSTLERS: Dictionary = {
	"GENERALIST": {"name": "THE GENERALIST", "quote": "A bit of everything. Enough of nothing.", "difficulty": 1,
		"style": "Balanced: an Icepick for every ICE type.", "origin": "READY RIG",
		"origin_text": "At the start of each ICE Node, choose one PROGRAM in your deck and install it for free.",
		"starter": STARTER_GENERALIST, "nulrem": "Generalist"},
	"ECHO": {"name": "ECHO", "quote": "If they never notice you, you were never there.", "difficulty": 2,
		"style": "Quiet: low TRACE, long encounters, more CRED. Strong vs TUMBLERS.", "origin": "LOW PROFILE",
		"origin_text": "Whenever you would gain TRACE, gain 1 less (minimum 0).",
		"starter": STARTER_ECHO, "nulrem": "ECHO"},
	"RIOT": {"name": "RIOT", "quote": "Subtle is for people with time.", "difficulty": 3,
		"style": "Loud: cheap cards that add TRACE; stronger above TRACE 20. Strong vs FORTRESSES.", "origin": "REDLINER",
		"origin_text": "At the start of your turn, if your TRACE is 20 or more, gain 1 BW.",
		"starter": STARTER_RIOT, "nulrem": "RIOT"},
	"VECTOR": {"name": "VECTOR", "quote": "I don't break in. I wait for it to rot.", "difficulty": 2,
		"style": "Viruses: weakens every ICE over time. Strong vs VOIDS.", "origin": "PATIENT ZERO",
		"origin_text": "At the start of each encounter, choose an ICE: INFECT 1 ROT on it.",
		"starter": STARTER_VECTOR, "nulrem": "VECTOR"},
}

static func def(id: String) -> Dictionary:
	if id.begins_with("COMPILED::"):
		var parts := id.split("::")
		var a := def(parts[1]); var b := def(parts[2])
		var tags: Array = a.tags.duplicate()
		for tag in b.tags:
			if not tags.has(tag): tags.append(tag)
		return {"name": a.name + " ⨯ " + b.name, "type": "SCRIPT", "tags": tags, "bw": mini(4, a.bw + b.bw), "trace_cost": int(a.get("trace_cost", 0)) + int(b.get("trace_cost", 0)), "cred_cost": int(a.get("cred_cost", 0)) + int(b.get("cred_cost", 0)), "rarity": "RARE", "compiled": [parts[1], parts[2]], "target": a.get("target", false) or b.get("target", false), "text": a.text + " THEN " + b.text}
	return DEFS[id]

## CSA-04e (CSA-02 element 9): the Universal Object Inspector's content contract for a card, built from
## its canonical record and nothing else: name, classification, costs, rules text, flavour, art. The V2
## card model and the shared inspector (UI-INSPECTOR-001) read it. `records` lets tests pass a modified
## copy of the records to prove a canonical change reaches the Inspector (CSA T3).
static func inspector_model(id: String, records: Dictionary = {}) -> Dictionary:
	var d: Dictionary = records[id] if not records.is_empty() else def(id)
	var tags: Array = d.get("tags", [])
	return {"id": id, "name": String(d.get("name", id)),
		"classification": " · ".join([String(d.get("type", ""))] + tags.map(func(t): return String(t))),
		"type": String(d.get("type", "")), "tags": tags,
		"costs": {"bw": int(d.get("bw", 0)), "cred": int(d.get("cred_cost", 0)), "trace": int(d.get("trace_cost", 0))},
		"rules": String(d.get("text", "")), "flavour": String(d.get("flavor", "")),
		"art": "res://assets/concept/cards/%s.png" % id}

## CAPS-TEST-001 (designer 2026-11-27): the five common CAPS; data in res://data/cards.json ("caps").

static func caps_of(rarity: String) -> Array:
	var out := []
	for id in CAPS:
		if CAPS[id].rarity == rarity: out.append(id)
	return out

static func reward_pool(pool: String, rarity: String) -> Array:
	var out := []
	for id in DEFS:
		var d: Dictionary = DEFS[id]
		if d.rarity != rarity or d.get("slice_excluded", false):
			continue
		if String(d.get("status", {}).get("design", "approved")) in ["experimental", "historical"]:
			continue   # CSA-03 C2: experimental and historical cards are never rewards
		if Game.CORE_LOOP and not CORE_POOL.has(id):
			continue
		var p: String = d.get("pool", "SHARED")
		if p == pool:
			out.append(id)
	var extra: Dictionary = POOL_EXTRA.get(pool, {})
	for id in extra:
		if extra[id] == rarity:
			out.append(id)
	return out

static func roles(id: String) -> Array:
	var d := def(id)
	var out := []
	if d.has("pick") or d.has("breaker") or id in ["ADAPTER", "BORROWED_CREDENTIALS", "SHATTER", "FLASHPOINT"]: out.append("◇ COVERAGE")
	if d.has("pick") or d.tags.has("VIRUS") or d.has("zeroed_reduction") or id in ["PROBE", "OVERLOAD", "DEEP_PROBE", "SMASH", "PIVOT", "STACK_SMASH", "NULL_POINTER", "FIELD_KIT", "STRESS_TEST", "MINIMALIST"]: out.append("↯ DRILL")
	if id in ["SURGE_PROTECTOR", "WARM_BOOT", "STUN_BATON"]: out.append("▣ HULL")
	if d.has("compiled"):
		for part in d.compiled:
			for role in roles(part):
				if not out.has(role): out.append(role)
	return out
