extends SceneTree
## CSA-03 C1/C2 (CONSISTENCY-001a): CardDB loads res://data/cards.json and must give exactly what the old
## GDScript constants gave. csa_carddb_snapshot.txt was written from those constants at a278aee
## (var_to_str keeps types; key order is kept in def_keys / cap_keys). Approved changes to the data
## after C1 are listed in APPROVED_CHANGES, each with its decision ID; anything else that differs fails.

var passed := 0
var failed := 0

## Approved data changes since the C1 snapshot: what -> decision ID. Everything else must match the snapshot.
const APPROVED_CHANGES := {"RUSTLERS.RIOT.starter": "RIOT-006"}
## CSA-03 C3: approved wording now shown (CONSISTENCY-001a conflict table). id -> [field, new value].
const APPROVED_TEXT := {
	"TAIL_CALL": "Put a SCRIPT from your discard pile into your hand.",
	"HOST_TAKEOVER": "Break 2 subroutines on target ICE with 5 or more virus counters.",
	"FORCE_REBOOT": "Shuffle your discard pile into your draw pile (this is a REBOOT). BURNED.",
	"BORROWED_CREDENTIALS": "Choose a FORTRESS or VOID. This turn, HUSH can break its subroutines using normal Strength requirements, boosts and break costs. Costs 8 CRED.",
}
## Fields CSA-03 C2 adds to records. Every other field must equal the snapshot.
const METADATA := ["status", "decisions", "divergence", "approved_text", "unresolved"]
const RIOT_STARTER := ["SLEDGE", "BRUTE_FORCE", "SHATTER", "OVERLOAD", "PROBE", "PROBE", "PROBE", "PROBE", "FEEDBACK",
	"ADRENAL_SPIKE", "PULP_SHIELD", "PULP_SHIELD", "PULP_SHIELD", "LAY_LOW", "BASIC_EXTRACTOR"]
const PLAYTEST := ["REACTIVE_ARMOUR", "COUNTERINTELLIGENCE", "OVERCLOCK", "FEEDBACK_LOOP", "SALVAGE", "ADAPTIVE_DEFENCE",
	"FOLLOW_THROUGH", "ESCALATION", "AFTERBURN", "REPRISE"]
const EXPERIMENTAL := ["MINIMALIST", "SCALPEL", "ZERO_FOOTPRINT", "SMASH_AND_GRAB", "COVER_FIRE", "KILL_CHAIN", "HANDOFF"]

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	var snap: Dictionary = str_to_var(FileAccess.get_file_as_string("res://tests/csa_carddb_snapshot.txt"))
	check(not snap.is_empty(), "snapshot readable")
	check(CardDB.DATA.get("schema", "") == CardDB.SCHEMA, "cards.json schema " + CardDB.SCHEMA)
	check(CardDB.DEFS.keys() == snap.def_keys, "card order unchanged (reward pools iterate it)")
	check(CardDB.CAPS.keys() == snap.cap_keys, "CAP order unchanged")
	for id in snap.defs:
		var old: Dictionary = snap.defs[id]
		if APPROVED_TEXT.has(id):
			check(CardDB.def(id).text == APPROVED_TEXT[id], "%s shows its approved wording (C3)" % id)
			old = old.duplicate(true); old.text = APPROVED_TEXT[id]
		check(same(legacy(CardDB.def(id), old), old), "def(%s) unchanged apart from C2 metadata and C3 wording" % id)
		check(only_metadata_added(CardDB.def(id), snap.defs[id]), "def(%s) adds only %s" % [id, METADATA])
		check(same(CardDB.roles(id), snap.roles[id]), "roles(%s) unchanged" % id)
	for cid in snap.compiled:
		var exp: Dictionary = snap.compiled[cid].duplicate(true)
		for part in String(cid).split("::").slice(1):
			if APPROVED_TEXT.has(part):
				exp.text = String(exp.text).replace(snap.defs[part].text, APPROVED_TEXT[part])
		check(same(legacy(CardDB.def(cid), exp), exp), "compiled %s unchanged apart from its parts' C3 wording" % cid)
	for key in snap.pools:
		var p: PackedStringArray = String(key).split("/")
		check(same(CardDB.reward_pool(p[0], p[1]), snap.pools[key]), "reward_pool(%s) unchanged" % key)
	for r in snap.caps_of:
		check(same(CardDB.caps_of(r), snap.caps_of[r]), "caps_of(%s) unchanged" % r)
	for r in snap.rustlers:
		if r == "RIOT":
			var expected: Dictionary = snap.rustlers[r].duplicate(true)
			expected.starter = RIOT_STARTER
			check(same(CardDB.RUSTLERS[r], expected), "RUSTLERS[RIOT]: only the approved RIOT-006 starter change")
		else:
			check(same(CardDB.RUSTLERS[r], snap.rustlers[r]), "RUSTLERS[%s] unchanged (starter deck included)" % r)
	# --- CSA-03 C2 ---
	check(CardDB.RECORDS.size() == snap.def_keys.size() + PLAYTEST.size(), "records = the 112 cards + 10 playtest cards")
	for id in PLAYTEST:
		check(CardDB.RECORDS.has(id) and not CardDB.DEFS.has(id), "%s: recorded, pending, not dealt or played" % id)
		check(CardDB.design_status(id) == "playtest" and CardDB.DATA.core_pool.has(id) and not CardDB.CORE_POOL.has(id),
			"%s: approved for the core pool (cards.json), joins CardDB.CORE_POOL once its handler is built" % id)
	for pool in ["SHARED", "GENERALIST", "ECHO", "RIOT", "VECTOR"]:
		for rar in ["COMMON", "UNCOMMON", "RARE"]:
			for id in CardDB.reward_pool(pool, rar):
				check(not PLAYTEST.has(id) and not EXPERIMENTAL.has(id), "reward_pool(%s/%s) offers no pending or experimental card (%s)" % [pool, rar, id])
	for id in EXPERIMENTAL:
		check(CardDB.design_status(id) == "experimental" and CardDB.DEFS.has(id), "%s: experimental, its handler kept" % id)
	for deck in [CardDB.STARTER_GENERALIST, CardDB.STARTER_ECHO, CardDB.STARTER_RIOT, CardDB.STARTER_VECTOR]:
		for id in deck:
			check(CardDB.design_status(id) == "approved" and CardDB.DEFS.has(id), "starter card %s is approved and built" % id)
	check(CardDB.def("PROBE").text == snap.defs.PROBE.text and String(CardDB.RECORDS.PROBE.get("approved_text", "")).begins_with("Choose one"),
		"PROBE shows the engine text; the approved PROBE-004a text is stored until CSA-04")
	check(CardDB.DEFS.is_read_only() and CardDB.DEFS.PROBE.is_read_only() and CardDB.STARTER_RIOT.is_read_only(), "card data read-only, as the constants were")
	check(no_floats(CardDB.DATA), "no float values after loading (JSON numbers restored to int)")
	print("CSA CARDS: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

func legacy(live: Dictionary, old: Dictionary) -> Dictionary:
	## The live record restricted to the fields the snapshot had.
	var out := {}
	for k in old:
		if live.has(k): out[k] = live[k]
	return out

func only_metadata_added(live: Dictionary, old: Dictionary) -> bool:
	for k in live:
		if not old.has(k) and not METADATA.has(k): return false
	return true

func same(a: Variant, b: Variant) -> bool:
	## Deep equality that also compares types (1 is not 1.0) and array order.
	if typeof(a) != typeof(b): return false
	if a is Dictionary:
		if a.size() != b.size(): return false
		for k in a:
			if not b.has(k) or not same(a[k], b[k]): return false
		return true
	if a is Array:
		if a.size() != b.size(): return false
		for i in a.size():
			if not same(a[i], b[i]): return false
		return true
	return a == b

func no_floats(v: Variant) -> bool:
	if v is float: return false
	if v is Dictionary:
		for k in v:
			if not no_floats(v[k]): return false
	if v is Array:
		for x in v:
			if not no_floats(x): return false
	return true
