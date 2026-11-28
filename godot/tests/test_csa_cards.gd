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
	"PROBE": "Choose one: Target ICE: −2 STR this encounter. OR Target VOID: Reveal all hidden subroutines. Costs 1 additional BW for each PROBE already played on the target ICE this turn.",   # CSA-04b
	"GARBAGE_COLLECT": "BURN 1 other card in your hand. Draw 1.",   # CSA-04c, BURNED-001
	"SPAM": "Can't be played normally. Pay 1 BW to clear it: it disappears for good.",   # CSA-04c, BURNED-001b
	"PIVOT": "Target ICE −1 STR this encounter. If target ICE STR is 0, break one of the target ICE subroutines for no cost.",   # CSA-04d, CHAIN-PARK-001; PIVOT-001 wording
	"BORROWED_CREDENTIALS": "Choose a FORTRESS or VOID. This turn, HUSH can break its subroutines using normal Strength requirements, boosts and break costs.",   # CRED-COST-001: the 8 CRED is on the card face
}
## Approved value changes on single cards since the snapshot: id -> {field: new value}. A compiled
## card's BW is the sum of its parts' BW, so it follows its parts.
const APPROVED_VALUES := {"NULL_POINTER": {"bw": 1},   # NULL-POINTER-001 (designer 2026-11-24): 2 BW -> 1 BW
	"GHOST_SIGNAL": {"bw": 1}}   # CARD-REVIEW-001 Generalist review (designer 2026-11-28): 2 BW -> 1 BW
## Fields CSA-03 C2 adds to records. Every other field must equal the snapshot.
const METADATA := ["status", "decisions", "divergence", "approved_text", "unresolved", "params", "params_in_code", "text_template", "strategy", "flavor"]   # CARD-REVIEW-001: flavour and strategy metadata are content, not rules   # CSA-04i: params carry the numbers the text and engine used
## Approved new fields on single cards since the snapshot: id -> [fields].
const APPROVED_FIELDS := {"PROBE": ["modes"], "PIVOT": ["zeroed_reduction"]}   # CSA-04b PROBE-004a; CSA-04d PIVOT
## Approved field removals since the snapshot: id -> [fields].
const APPROVED_REMOVED := {"PIVOT": ["chain"]}   # CSA-04d, CHAIN-PARK-001: CHAIN removed from all current cards
const RIOT_STARTER := ["SLEDGE", "BRUTE_FORCE", "SHATTER", "OVERLOAD", "PROBE", "PROBE", "PROBE", "PROBE", "FEEDBACK",
	"ADRENAL_SPIKE", "PULP_SHIELD", "PULP_SHIELD", "PULP_SHIELD", "LAY_LOW", "BASIC_EXTRACTOR"]
## SYNERGY-PLAYTEST-002 rarities (Master Design, playtest values): the shared reward pools that gain them.
const PLAYTEST_REWARDS := {
	"SHARED/COMMON": ["COUNTERINTELLIGENCE", "FEEDBACK_LOOP", "ADAPTIVE_DEFENCE", "FOLLOW_THROUGH", "ESCALATION", "AFTERBURN"],
	"SHARED/UNCOMMON": ["REACTIVE_ARMOUR", "OVERCLOCK", "SALVAGE"], "SHARED/RARE": ["REPRISE"]}   # CARD-REVIEW-001: REACTIVE ARMOUR UNCOMMON
const PLAYTEST := ["REACTIVE_ARMOUR", "COUNTERINTELLIGENCE", "OVERCLOCK", "FEEDBACK_LOOP", "SALVAGE", "ADAPTIVE_DEFENCE",
	"FOLLOW_THROUGH", "ESCALATION", "AFTERBURN", "REPRISE"]
## CSA-04f (CSA-02 Q8): approved pool cards never built, recorded as `pending` so the generated doc views
## are complete (Card Pools §3–4, CARD-003/004; in the core-loop pool by STRIP-001).
const PENDING_POOL := ["KEYLOGGER", "STASH", "QUANTUM_CORE", "HOT_SWAP", "JACK_OF_ALL_TRADES"]
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
	# UI-PROTOCOL-001: the ten playtest cards joined DEFS after the snapshot's cards; the snapshot's order is kept.
	check(CardDB.DEFS.keys().filter(func(id): return not PLAYTEST.has(id)) == snap.def_keys, "card order unchanged (reward pools iterate it)")
	check(CardDB.DEFS.keys().filter(func(id): return PLAYTEST.has(id)).size() == PLAYTEST.size(), "the ten playtest cards are dealt and played")
	check(CardDB.CAPS.keys() == snap.cap_keys, "CAP order unchanged")
	for id in snap.defs:
		var old: Dictionary = snap.defs[id]
		if APPROVED_TEXT.has(id):
			check(CardDB.def(id).text == APPROVED_TEXT[id], "%s shows its approved wording (C3)" % id)
			old = old.duplicate(true); old.text = APPROVED_TEXT[id]
		for k in APPROVED_VALUES.get(id, {}):
			check(same(CardDB.def(id)[k], APPROVED_VALUES[id][k]), "%s.%s is its approved value %s" % [id, k, APPROVED_VALUES[id][k]])
			old = old.duplicate(true); old[k] = APPROVED_VALUES[id][k]
		for k in APPROVED_REMOVED.get(id, []):
			check(not CardDB.def(id).has(k), "%s no longer has the approved-removed field %s" % [id, k])
			old = old.duplicate(true); old.erase(k)
		check(same(legacy(CardDB.def(id), old), old), "def(%s) unchanged apart from C2 metadata and C3 wording" % id)
		check(only_metadata_added(CardDB.def(id), snap.defs[id]), "def(%s) adds only %s" % [id, METADATA])
		check(same(CardDB.roles(id), snap.roles[id]), "roles(%s) unchanged" % id)
	for cid in snap.compiled:
		var exp: Dictionary = snap.compiled[cid].duplicate(true)
		for part in String(cid).split("::").slice(1):
			if APPROVED_TEXT.has(part):
				exp.text = String(exp.text).replace(snap.defs[part].text, APPROVED_TEXT[part])
			if APPROVED_VALUES.get(part, {}).has("bw"):
				exp.bw = int(exp.bw) - int(snap.defs[part].bw) + int(APPROVED_VALUES[part].bw)
		check(same(legacy(CardDB.def(cid), exp), exp), "compiled %s unchanged apart from its parts' approved wording and cost" % cid)
	for key in snap.pools:
		var p: PackedStringArray = String(key).split("/")
		var live: Array = CardDB.reward_pool(p[0], p[1])
		check(same(live.filter(func(id): return not PLAYTEST.has(id)), snap.pools[key]), "reward_pool(%s) unchanged apart from the playtest cards" % key)
		var added: Array = live.filter(func(id): return PLAYTEST.has(id))
		check(same(added, PLAYTEST_REWARDS.get(key, [])), "reward_pool(%s) adds the approved playtest cards %s (SYNERGY-PLAYTEST-002)" % [key, added])
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
	check(CardDB.RECORDS.size() == snap.def_keys.size() + PLAYTEST.size() + PENDING_POOL.size(), "records = the 112 cards + 10 playtest cards + 5 pending pool cards")
	for id in PENDING_POOL:
		check(CardDB.RECORDS.has(id) and not CardDB.DEFS.has(id) and CardDB.design_status(id) == "approved", "%s: recorded, approved, pending, never dealt or played" % id)
		check(CardDB.DATA.core_pool.has(id) and not CardDB.CORE_POOL.has(id), "%s: in the core pool's data, joins CardDB.CORE_POOL once built" % id)
	# UI-PROTOCOL-001 (designer 2026-11-28): the ten playtest cards are built; they stay "playtest" in design
	# and join the core-loop reward pool (SYNERGY-PLAYTEST-002: obtainable through normal rewards).
	for id in PLAYTEST:
		check(CardDB.RECORDS.has(id) and CardDB.DEFS.has(id), "%s: built, dealt and played (UI-PROTOCOL-001)" % id)
		check(CardDB.design_status(id) == "playtest" and CardDB.CORE_POOL.has(id),
			"%s: a playtest card in CardDB.CORE_POOL (SYNERGY-PLAYTEST-002)" % id)
	for pool in ["SHARED", "GENERALIST", "ECHO", "RIOT", "VECTOR"]:
		for rar in ["COMMON", "UNCOMMON", "RARE"]:
			for id in CardDB.reward_pool(pool, rar):
				check(not PENDING_POOL.has(id) and not EXPERIMENTAL.has(id), "reward_pool(%s/%s) offers no pending or experimental card (%s)" % [pool, rar, id])
	for id in EXPERIMENTAL:
		check(CardDB.design_status(id) == "experimental" and CardDB.DEFS.has(id), "%s: experimental, its handler kept" % id)
	for deck in [CardDB.STARTER_GENERALIST, CardDB.STARTER_ECHO, CardDB.STARTER_RIOT, CardDB.STARTER_VECTOR]:
		for id in deck:
			check(CardDB.design_status(id) == "approved" and CardDB.DEFS.has(id), "starter card %s is approved and built" % id)
	check(String(CardDB.def("PROBE").text).begins_with("Choose one") and not CardDB.RECORDS.PROBE.has("approved_text"),
		"PROBE shows its approved PROBE-004a text and is no longer divergent (CSA-04b)")
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
		if not old.has(k) and not METADATA.has(k) and not APPROVED_FIELDS.get(String(live.get("name", "")).to_upper(), []).has(k): return false
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
