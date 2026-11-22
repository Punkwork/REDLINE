class_name IceDB
extends RefCounted
## HALCYON ICE used by the slice. Source: REDLINE_ICE_CORP1.md §5, §6, §8.4 (working values).
## TUMBLER (replaces SIGYL, ROT-001): "subs" is the rotating pool and "slots" is how many are active at once.
## TUNE-001: STR +1 (OPENING) / +2 (T1, BLACK); PULP ×4/3 rounded up.
## Each Rustler turn after the first, the window moves one step (conveyor). TUMBLER pools are placeholders for playtest.

const DEFS := {
	# STRIP-001 (2026-11-21): core-loop values (docs/REDLINE_CORE_LOOP.md §3). STR +2 (STR-001), no passives,
	# fixed PULP (no curves or rolls), about a third less threat, no CORTEX, no BOOTING. COOKIE BANNER is about PULP.
	# Earlier values are in git history before this change.
	# FORM-002 (designer, 2026-11-21, after Playtest 8): every TRACE subroutine +2, every PULP subroutine +1.
	"ACCEPT_ALL": {"name": "ACCEPT ALL", "type": "TUMBLER", "str": 6, "tier": "OPENING", "slots": 1,
		"subs": [[{"k": "PULP", "v": 3}], [{"k": "PULP", "v": 2}], [{"k": "PULP", "v": 3}]]},
	"REJECT_ALL": {"name": "REJECT ALL", "type": "TUMBLER", "str": 6, "tier": "OPENING", "slots": 1,
		"subs": [[{"k": "PULP", "v": 3}], [{"k": "DEADLOCK"}], [{"k": "PULP", "v": 3}]]},
	"COOKIE_WALL": {"name": "COOKIE WALL", "type": "FORTRESS", "str": 7, "tier": "T1",
		"subs": [[{"k": "PULP", "v": 2}], [{"k": "TRACE", "v": 3}], [{"k": "PULP", "v": 3}], [{"k": "DEADLOCK"}]]},
	"TERMS_OF_SERVICE": {"name": "TERMS OF SERVICE", "type": "FORTRESS", "str": 9, "tier": "T1",
		"subs": [[{"k": "PULP", "v": 4}], [{"k": "INSERT", "card": "SPAM", "to": "discard", "v": 1}], [{"k": "PULP", "v": 4}], [{"k": "DEADLOCK"}]]},
	"AUTO_RENEW": {"name": "AUTO-RENEW", "type": "FORTRESS", "str": 7, "tier": "T1",
		"subs": [[{"k": "PULP", "v": 2}], [{"k": "PULP", "v": 2}], [{"k": "PULP", "v": 3}], [{"k": "DEADLOCK"}]]},
	"CONSENT_FORM": {"name": "CONSENT FORM", "type": "TUMBLER", "str": 6, "tier": "T1", "slots": 2,
		"subs": [[{"k": "TRACE", "v": 3}], [{"k": "DEADLOCK"}], [{"k": "PULP", "v": 3}], [{"k": "DEADLOCK"}]]},
	"CAPTCHA": {"name": "CAPTCHA", "type": "TUMBLER", "str": 6, "tier": "T1", "slots": 2,
		"subs": [[{"k": "DISCARD", "v": 1}], [{"k": "DEADLOCK"}], [{"k": "TRACE", "v": 4}], [{"k": "DEADLOCK"}], [{"k": "TRACE", "v": 4}]]},
	"DOORBELL_CAM": {"name": "DOORBELL CAM", "type": "VOID", "str": 5, "tier": "T1",
		"subs": [[{"k": "PULP", "v": 4}], [{"k": "DEADLOCK"}]]},
	"HOUSE_CALL": {"name": "HOUSE CALL", "type": "VOID", "str": 9, "tier": "BLACK", "black": true,
		"subs": [[{"k": "PULP", "v": 5}], [{"k": "PULP", "v": 5}]]},
	"FREE_TRIAL": {"name": "FREE TRIAL", "type": "TUMBLER", "str": 4, "tier": "T2", "slots": 2, "ability": "REBOOT_SPAM", "ability_text": "Whenever you REBOOT: INSERT 1 SPAM into draw.", "subs": [[{"k": "TRACE", "v": 2}], [{"k": "DEADLOCK"}], [{"k": "PULP", "v": 3}], [{"k": "DEADLOCK"}]]},
	"PATTERN_ANALYSIS": {"name": "PATTERN ANALYSIS", "type": "VOID", "str": 4, "tier": "T2", "ability": "CHAIN_PULP", "subs": [[{"k": "PULP", "v": 3}], [{"k": "DEADLOCK"}]]},
	"RECURRING_DREAM": {"name": "RECURRING DREAM", "type": "TUMBLER", "str": 4, "tier": "T2", "slots": 2, "ability": "REBOOT_FORGET", "subs": [[{"k": "FORGET", "v": 1}], [{"k": "TRACE", "v": 2}], [{"k": "DEADLOCK"}]]},
}

## The slice's HALCYON route: 4 rows. Each node: kind, layers (each layer = list of ICE ids left→right + reserve).
const MAP := [
	[{"id": "COOKIE_BANNER", "kind": "ICE", "name": "COOKIE BANNER", "opening": true,
		"layers": [{"ice": ["ACCEPT_ALL", "REJECT_ALL"], "reserve": 23}], "next": [0, 1]}],
	[{"id": "N2A", "kind": "ICE", "name": "CAPTCHA", "layers": [{"ice": ["AUTO_RENEW", "CAPTCHA"], "reserve": 15}], "next": [0, 1]},
	 {"id": "N2B", "kind": "ICE", "name": "CONSENT WALL",
		"layers": [{"ice": ["COOKIE_WALL"], "reserve": 15}], "next": [0, 1]}],
	[{"id": "N3A", "kind": "SAFEHOUSE", "name": "SAFEHOUSE", "next": [0]},
	 {"id": "N3B", "kind": "ICE", "name": "DOORBELL",
		"layers": [{"ice": ["DOORBELL_CAM"], "reserve": 15}], "next": [0]}],
	[{"id": "N4", "kind": "ICE", "name": "TERMS & CONDITIONS",
		"layers": [{"ice": ["TERMS_OF_SERVICE"], "reserve": 15}], "next": []}],
]

## PULP-002: PULP curves, on the harder FORTRESSES (COOKIE WALL: B; TERMS OF SERVICE: C). A is defined for later ICE.
## A curve subroutine deals the next value of its sequence each Corporation Response
## (looping after 9). A and C run in order; B's 9 values are shuffled for each ICE, so the order is random.
const CURVES := {
	"A": {"name": "SEQUENTIAL", "seq": [2, 3, 4, 2, 3, 4, 2, 3, 4]},   # 27 over 9 turns
	"B": {"name": "RANDOM", "seq": [5, 3, 2, 6, 2, 3, 6, 2, 1]},       # 30 over 9 turns, shuffled per ICE
	"C": {"name": "HAMMER", "seq": [4, 3, 4, 9, 3, 4, 3, 8, 2]},       # 40 over 9 turns
}

## PURGE-001: at the start of its turn, a corporation that counts this many virus counters across the
## encounter's ICE PURGES them all instead of taking its turn. The limit rises after each purge (per encounter).
## Deliberately not shown to the Rustler.
const CORPS := {"HALCYON": {"purge_limit": 10, "purge_step": 5}}

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
