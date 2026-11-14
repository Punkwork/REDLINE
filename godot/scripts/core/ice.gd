class_name IceDB
extends RefCounted
## HALCYON ICE used by the slice. Source: REDLINE_ICE_CORP1.md §5, §6, §8.4 (working values).
## TUMBLER (replaces SIGYL, ROT-001): "subs" is the rotating pool and "slots" is how many are active at once.
## TUNE-001: STR +1 (OPENING) / +2 (T1, BLACK); PULP ×4/3 rounded up.
## Each Rustler turn after the first, the window moves one step (conveyor). TUMBLER pools are placeholders for playtest.

const DEFS := {
	# DETAINER (DET-001): a TUMBLER subtype (about 1 in 5 TUMBLERs). Its S1 is always −1 BW; at most 1 per encounter.
	"ACCEPT_ALL": {"name": "ACCEPT ALL", "type": "TUMBLER", "subtype": "DETAINER", "str": 4, "tier": "OPENING", "slots": 1,
		"subs": [[{"k": "BW_DRAIN", "v": 1}], [{"k": "INSERT", "card": "SPAM", "to": "draw", "v": 1}], [{"k": "PULP", "v": 3}]]},
	"REJECT_ALL": {"name": "REJECT ALL", "type": "TUMBLER", "str": 4, "tier": "OPENING", "slots": 2, "ability": "BOOTING",
		"ability_text": "BOOTING: its DEADLOCKs can't be broken before your 3rd turn of the encounter.",
		"subs": [[{"k": "DEADLOCK"}], [{"k": "TRACE", "v": 3}], [{"k": "DEADLOCK"}], [{"k": "PULP", "v": 4}]]},
	"COOKIE_WALL": {"name": "COOKIE WALL", "type": "FORTRESS", "str": 5, "tier": "T1",
		"subs": [[{"k": "TRACE", "v": 2}], [{"k": "DEADLOCK"}]]},
	"TERMS_OF_SERVICE": {"name": "TERMS OF SERVICE", "type": "FORTRESS", "str": 7, "tier": "T1",
		"subs": [[{"k": "INSERT", "card": "SPAM", "to": "discard", "v": 1}], [{"k": "DEADLOCK"}]]},
	"CONSENT_FORM": {"name": "CONSENT FORM", "type": "TUMBLER", "str": 4, "tier": "T1", "slots": 2,
		"subs": [[{"k": "TRACE", "v": 2}], [{"k": "DEADLOCK"}], [{"k": "PULP", "v": 4}], [{"k": "DEADLOCK"}]]},
	"CAPTCHA": {"name": "CAPTCHA", "type": "TUMBLER", "str": 5, "tier": "T1", "slots": 2,
		"subs": [[{"k": "DISCARD", "v": 1}], [{"k": "DEADLOCK"}], [{"k": "PULP", "v": 6}], [{"k": "DEADLOCK"}], [{"k": "TRACE", "v": 3}]]},
	"DOORBELL_CAM": {"name": "DOORBELL CAM", "type": "VOID", "str": 4, "tier": "T1", "ability": "CLOAK_TRACE",
		"ability_text": "Whenever you play a CLOAK card: TRACE 1.",
		"subs": [[{"k": "TRACE", "v": 3}, {"k": "DEADLOCK"}]]},
	"HOUSE_CALL": {"name": "HOUSE CALL", "type": "VOID", "str": 7, "tier": "BLACK", "black": true,
		"subs": [[{"k": "PULP", "v": 6}], [{"k": "PULP", "v": 6}]]},
}

## The slice's HALCYON route: 4 rows. Each node: kind, layers (each layer = list of ICE ids left→right + reserve).
const MAP := [
	[{"id": "COOKIE_BANNER", "kind": "ICE", "name": "COOKIE BANNER", "opening": true,
		"layers": [{"ice": ["ACCEPT_ALL", "REJECT_ALL"], "reserve": 15}], "next": [0, 1]}],
	[{"id": "N2A", "kind": "ICE", "name": "CAPTCHA", "layers": [{"ice": ["CAPTCHA"], "reserve": 10}], "next": [0, 1]},
	 {"id": "N2B", "kind": "ICE", "name": "CONSENT WALL",
		"layers": [{"ice": ["COOKIE_WALL"], "reserve": 10}, {"ice": ["CONSENT_FORM"], "reserve": 15}], "next": [0, 1]}],
	[{"id": "N3A", "kind": "SAFEHOUSE", "name": "SAFEHOUSE", "next": [0]},
	 {"id": "N3B", "kind": "ICE", "name": "DOORBELL",
		"layers": [{"ice": ["DOORBELL_CAM"], "reserve": 10}, {"ice": ["CONSENT_FORM", "TERMS_OF_SERVICE"], "reserve": 15}], "next": [0]}],
	[{"id": "N4", "kind": "ICE", "name": "TERMS & CONDITIONS",
		"layers": [{"ice": ["TERMS_OF_SERVICE"], "reserve": 10}, {"ice": ["CAPTCHA", "DOORBELL_CAM"], "reserve": 15}], "next": []}],
]

static func def(id: String) -> Dictionary:
	return DEFS[id]

static func is_detainer(id: String) -> bool:
	return DEFS[id].get("subtype", "") == "DETAINER"

static func detainers_in(ids: Array) -> int:
	var n := 0
	for id in ids:
		if is_detainer(id):
			n += 1
	return n

static func is_tumbler(id: String) -> bool:
	return DEFS[id].type == "TUMBLER"

static func slots(id: String) -> int:
	var d: Dictionary = DEFS[id]
	return mini(int(d.get("slots", d.subs.size())), d.subs.size())
