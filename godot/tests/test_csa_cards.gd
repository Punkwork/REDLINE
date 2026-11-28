extends SceneTree
## CSA-03 C1 (CONSISTENCY-001a): CardDB loads res://data/cards.json and must give exactly what the old
## GDScript constants gave. csa_carddb_snapshot.txt was written from those constants at a278aee
## (var_to_str keeps types; key order is kept in def_keys / cap_keys). Approved changes to the data
## after C1 are listed in APPROVED_CHANGES, each with its decision ID; anything else that differs fails.

var passed := 0
var failed := 0

## Approved data changes since the C1 snapshot: id -> decision ID. Empty in C1.
const APPROVED_CHANGES := {}

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
		if APPROVED_CHANGES.has(id): continue
		check(same(CardDB.def(id), snap.defs[id]), "def(%s) unchanged" % id)
		check(same(CardDB.roles(id), snap.roles[id]), "roles(%s) unchanged" % id)
	for cid in snap.compiled:
		check(same(CardDB.def(cid), snap.compiled[cid]), "compiled %s unchanged" % cid)
	for key in snap.pools:
		var p: PackedStringArray = String(key).split("/")
		check(same(CardDB.reward_pool(p[0], p[1]), snap.pools[key]), "reward_pool(%s) unchanged" % key)
	for r in snap.caps_of:
		check(same(CardDB.caps_of(r), snap.caps_of[r]), "caps_of(%s) unchanged" % r)
	for r in snap.rustlers:
		check(same(CardDB.RUSTLERS[r], snap.rustlers[r]), "RUSTLERS[%s] unchanged (starter deck included)" % r)
	check(CardDB.DEFS.is_read_only() and CardDB.DEFS.PROBE.is_read_only() and CardDB.STARTER_RIOT.is_read_only(), "card data read-only, as the constants were")
	check(no_floats(CardDB.DATA), "no float values after loading (JSON numbers restored to int)")
	print("CSA CARDS: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

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
