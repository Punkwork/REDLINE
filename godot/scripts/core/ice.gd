class_name IceDB
extends RefCounted
## HALCYON ICE used by the slice. Source: REDLINE_ICE_CORP1.md §5, §6, §8.4 (working values).

const DEFS := {
	"ACCEPT_ALL": {"name": "ACCEPT ALL", "type": "SIGYL", "str": 3, "tier": "OPENING",
		"subs": [[{"k": "INSERT", "card": "SPAM", "to": "draw", "v": 1}], [{"k": "TRACE", "v": 1}]]},
	"REJECT_ALL": {"name": "REJECT ALL", "type": "SIGYL", "str": 3, "tier": "OPENING", "ability": "BOOTING",
		"ability_text": "BOOTING: its DEADLOCK can't be broken before your 3rd turn of the encounter.",
		"subs": [[{"k": "TRACE", "v": 2}], [{"k": "DEADLOCK"}]]},
	"COOKIE_WALL": {"name": "COOKIE WALL", "type": "FORTRESS", "str": 3, "tier": "T1",
		"subs": [[{"k": "TRACE", "v": 2}], [{"k": "DEADLOCK"}]]},
	"TERMS_OF_SERVICE": {"name": "TERMS OF SERVICE", "type": "FORTRESS", "str": 5, "tier": "T1",
		"subs": [[{"k": "INSERT", "card": "SPAM", "to": "discard", "v": 1}], [{"k": "DEADLOCK"}]]},
	"CONSENT_FORM": {"name": "CONSENT FORM", "type": "SIGYL", "str": 2, "tier": "T1",
		"subs": [[{"k": "TRACE", "v": 1}], [{"k": "TRACE", "v": 1}], [{"k": "DEADLOCK"}]]},
	"CAPTCHA": {"name": "CAPTCHA", "type": "SIGYL", "str": 3, "tier": "T1",
		"subs": [[{"k": "DISCARD", "v": 1}], [{"k": "PULP", "v": 2}], [{"k": "DEADLOCK"}]]},
	"DOORBELL_CAM": {"name": "DOORBELL CAM", "type": "VOID", "str": 2, "tier": "T1", "ability": "CLOAK_TRACE",
		"ability_text": "Whenever you play a CLOAK card: TRACE 1.",
		"subs": [[{"k": "TRACE", "v": 3}, {"k": "DEADLOCK"}]]},
	"HOUSE_CALL": {"name": "HOUSE CALL", "type": "VOID", "str": 5, "tier": "BLACK", "black": true,
		"subs": [[{"k": "PULP", "v": 4}], [{"k": "PULP", "v": 4}]]},
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
