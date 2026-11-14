class_name CardDB
extends RefCounted
## Card definitions for the vertical slice.
## Source: REDLINE_CORE_RULES.md §13, REDLINE_RUSTLERS.md §3, REDLINE_CARD_POOLS.md §3–4, REDLINE_ICE_CORP1.md §4.
## All numbers are the docs' working values.

const DEFS := {
	# --- Generalist starter deck (Core Rules §13) ---
	"FORTRESS_ICEPICK": {"name": "FORTRESS Icepick", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 1, "ram": 1, "rarity": "STARTER",
		"pick": {"itype": "FORTRESS", "str": 1, "boost_cost": 1, "boost_amt": 1, "break_cost": 1, "free_first": true},
		"text": "STR 1. Boost: 1 BW → +1 STR. First break each turn free; then 1 BW per break."},
	"TUMBLER_ICEPICK": {"name": "TUMBLER Icepick", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 1, "ram": 1, "rarity": "STARTER",
		"pick": {"itype": "TUMBLER", "str": 3, "boost_cost": 2, "boost_amt": 1, "break_cost": 1},
		"text": "STR 3. Boost: 2 BW → +1 STR. Break: 1 BW."},
	"VOID_ICEPICK": {"name": "VOID Icepick", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 1, "ram": 1, "rarity": "STARTER",
		"pick": {"itype": "VOID", "str": 0, "boost_cost": 1, "boost_amt": 1, "break_cost": 1},
		"text": "STR 0. Boost: 1 BW → +1 STR. Break: 1 BW."},
	"BASIC_EXTRACTOR": {"name": "Basic Extractor", "type": "PROGRAM", "tags": ["EXTRACTOR"], "bw": 1, "ram": 1, "rarity": "STARTER",
		"extract": 5, "text": "End of your turn: extract 5 CRED."},
	"CORTEX_BUFFER": {"name": "CORTEX BUFFER", "type": "PROGRAM", "tags": [], "bw": 1, "ram": 1, "rarity": "STARTER",
		"text": "Once per encounter, prevent 1 CORTEX."},
	"PULP_SHIELD": {"name": "PULP Shield", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 1, "rarity": "STARTER",
		"text": "+3 SHIELD."},
	"PROBE": {"name": "PROBE", "type": "SCRIPT", "tags": ["EXPLOIT"], "bw": 1, "rarity": "STARTER", "target": true,
		"text": "Target ICE: −2 STR this encounter."},
	"GHOST_SIGNAL": {"name": "GHOST SIGNAL", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 2, "rarity": "STARTER",
		"text": "The first TRACE added in the next Corporation Response becomes 0. BURNED."},

	# --- Shared pool (Card Pools §3) ---
	"BATTERING_RAM": {"name": "BATTERING RAM", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 1, "ram": 1, "rarity": "COMMON",
		"pick": {"itype": "FORTRESS", "str": 3, "boost_cost": 1, "boost_amt": 1, "break_cost": 1, "free_first": true},
		"text": "STR 3. Boost: 1 BW → +1 STR. First break each turn free; then 1 BW per break."},
	"JACKHAMMER": {"name": "JACKHAMMER", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 1, "ram": 1, "rarity": "UNCOMMON",
		"pick": {"itype": "FORTRESS", "str": 2, "boost_cost": 1, "boost_amt": 2, "break_cost": 1, "free_first": true},
		"text": "STR 2. Boost: 1 BW → +2 STR. First break each turn free; then 1 BW."},
	"PASSKEY": {"name": "PASSKEY", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 1, "ram": 1, "rarity": "COMMON",
		"pick": {"itype": "TUMBLER", "str": 3, "boost_cost": 1, "boost_amt": 1, "break_cost": 1},
		"text": "STR 3. Boost: 1 BW → +1 STR. Break: 1 BW."},
	"RAINBOW_TABLE": {"name": "RAINBOW TABLE", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 1, "ram": 1, "rarity": "UNCOMMON",
		"pick": {"itype": "TUMBLER", "str": 2, "boost_cost": 1, "boost_amt": 1, "break_cost": 1, "double": true},
		"text": "STR 2. Boost: 1 BW → +1 STR. Break: 1 BW for up to 2 subroutines on the same ICE."},
	"TASER": {"name": "TASER", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 1, "ram": 1, "rarity": "COMMON",
		"pick": {"itype": "VOID", "str": 2, "boost_cost": 1, "boost_amt": 1, "break_cost": 1},
		"text": "STR 2. Boost: 1 BW → +1 STR. Break: 1 BW."},
	"STUN_BATON": {"name": "STUN BATON", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 1, "ram": 1, "rarity": "UNCOMMON",
		"pick": {"itype": "VOID", "str": 2, "boost_cost": 1, "boost_amt": 1, "break_cost": 1, "shield_per_break": 2},
		"text": "STR 2. Boost: 1 BW → +1 STR. Break: 1 BW. Each break: +2 SHIELD."},
	"SKELETON_KEY": {"name": "SKELETON KEY", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 2, "ram": 2, "rarity": "RARE",
		"pick": {"itype": "ANY", "str": 3, "boost_cost": 2, "boost_amt": 1, "break_cost": 1},
		"text": "STR 3. Boost: 2 BW → +1 STR. Break: 1 BW. Works on FORTRESS, TUMBLER and VOID."},
	"DATA_SIPHON": {"name": "DATA SIPHON", "type": "PROGRAM", "tags": ["EXTRACTOR"], "bw": 1, "ram": 1, "rarity": "COMMON",
		"extract": 6, "text": "End of your turn: extract 6 CRED."},
	"SKIMMER": {"name": "SKIMMER", "type": "PROGRAM", "tags": ["EXTRACTOR"], "bw": 0, "ram": 1, "rarity": "UNCOMMON",
		"extract": 4, "extract_on_install": 4, "text": "When installed: extract 4 CRED. End of your turn: extract 4 CRED."},
	"PAYDAY": {"name": "PAYDAY", "type": "SCRIPT", "tags": ["EXTRACTOR", "EXPLOIT"], "bw": 1, "trace_cost": 2, "rarity": "RARE",
		"text": "Extract 12 CRED now. (+2 TRACE)"},
	"HARDENED_SHELL": {"name": "HARDENED SHELL", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 2, "rarity": "COMMON", "text": "+7 SHIELD."},
	"FLINCH": {"name": "FLINCH", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 0, "rarity": "COMMON", "text": "+2 SHIELD. BURNED."},
	"MIRROR": {"name": "MIRROR", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 1, "rarity": "UNCOMMON", "text": "+3 SHIELD. Draw 1."},
	"SURGE_PROTECTOR": {"name": "SURGE PROTECTOR", "type": "PROTOCOL", "tags": [], "bw": 1, "rarity": "UNCOMMON",
		"text": "Start of each of your turns: +2 SHIELD."},
	"FAILSAFE": {"name": "FAILSAFE", "type": "PROTOCOL", "tags": [], "bw": 2, "rarity": "RARE",
		"text": "The first time each encounter you would gain CORTEX, prevent all of it."},
	"DEEP_PROBE": {"name": "DEEP PROBE", "type": "SCRIPT", "tags": ["EXPLOIT"], "bw": 2, "rarity": "COMMON", "target": true,
		"text": "Target ICE: −4 STR this encounter."},
	"STRESS_TEST": {"name": "STRESS TEST", "type": "SCRIPT", "tags": ["EXPLOIT"], "bw": 1, "rarity": "UNCOMMON",
		"text": "Every ICE: −1 STR this encounter."},
	"LOGIC_BOMB": {"name": "LOGIC BOMB", "type": "SCRIPT", "tags": ["EXPLOIT"], "bw": 3, "rarity": "RARE", "target": true,
		"text": "Target ICE's STR becomes 0 until the end of your turn. BURNED."},
	"DEFRAG": {"name": "DEFRAG", "type": "SCRIPT", "tags": [], "bw": 0, "rarity": "COMMON", "text": "Draw 1."},
	"STIM_PATCH": {"name": "STIM PATCH", "type": "SCRIPT", "tags": [], "bw": 0, "trace_cost": 2, "rarity": "UNCOMMON",
		"text": "Draw 2. (+2 TRACE)"},
	"BURST": {"name": "BURST", "type": "SCRIPT", "tags": [], "bw": 0, "rarity": "UNCOMMON", "text": "Gain 1 BW. BURNED."},
	"CO_PROCESSOR": {"name": "CO-PROCESSOR", "type": "PROGRAM", "tags": ["HARDWARE"], "bw": 2, "ram": 0, "rarity": "UNCOMMON",
		"ram_bonus": 1, "text": "+1 RAM."},
	"SCRUB": {"name": "SCRUB", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 1, "rarity": "COMMON", "text": "−4 TRACE."},
	"PROXY_CHAIN": {"name": "PROXY CHAIN", "type": "PROTOCOL", "tags": [], "bw": 1, "rarity": "UNCOMMON",
		"text": "Whenever you would gain TRACE during a Corporation Response, gain 1 less."},
	"BURN_NOTICE": {"name": "BURN NOTICE", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 2, "rarity": "RARE",
		"text": "Halve your TRACE (round down). BURNED."},
	"SPAM_FILTER": {"name": "SPAM FILTER", "type": "PROTOCOL", "tags": [], "bw": 1, "rarity": "COMMON",
		"text": "The first Bloatware the corporation would INSERT each encounter goes to your discard pile instead."},
	"UNINSTALLER": {"name": "UNINSTALLER", "type": "SCRIPT", "tags": [], "bw": 1, "rarity": "UNCOMMON",
		"text": "Choose a Bloatware in your hand: it's BURNED. Draw 1."},
	"PATCH_KIT": {"name": "PATCH KIT", "type": "SCRIPT", "tags": [], "bw": 1, "rarity": "UNCOMMON", "text": "Heal 4 VITAE. BURNED."},

	# --- Generalist pool (Card Pools §4) ---
	"FIELD_KIT": {"name": "FIELD KIT", "type": "SCRIPT", "tags": [], "bw": 1, "rarity": "COMMON", "pool": "GENERALIST",
		"text": "Search your draw pile for a PROGRAM and put it in your hand."},
	"TOOLBELT": {"name": "TOOLBELT", "type": "PROTOCOL", "tags": [], "bw": 1, "rarity": "COMMON", "pool": "GENERALIST",
		"text": "Your first Icepick boost each turn costs 0 BW."},
	"BALANCED_LOAD": {"name": "BALANCED LOAD", "type": "SCRIPT", "tags": ["CLOAK", "EXPLOIT"], "bw": 1, "rarity": "COMMON", "pool": "GENERALIST",
		"target": true, "text": "+2 SHIELD. Target ICE: −1 STR this encounter."},
	"ADAPTER": {"name": "ADAPTER", "type": "PROGRAM", "tags": [], "bw": 1, "ram": 1, "rarity": "UNCOMMON", "pool": "GENERALIST",
		"text": "Your Icepicks can break subroutines on any ICE type, for +1 BW per break."},
	"RAM_UPGRADE": {"name": "RAM UPGRADE", "type": "PROGRAM", "tags": ["HARDWARE"], "bw": 1, "ram": 0, "rarity": "UNCOMMON", "pool": "GENERALIST",
		"ram_bonus": 1, "text": "+1 RAM."},
	"READY_STANCE": {"name": "READY STANCE", "type": "PROTOCOL", "tags": [], "bw": 2, "rarity": "UNCOMMON", "pool": "GENERALIST",
		"text": "On the first turn of each encounter, draw 1 extra card."},
	"MULTITOOL": {"name": "MULTITOOL", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 1, "ram": 1, "rarity": "RARE", "pool": "GENERALIST",
		"pick": {"itype": "ANY", "str": 2, "boost_cost": 1, "boost_amt": 1, "break_cost": 2},
		"text": "STR 2. Boost: 1 BW → +1 STR. Break: 2 BW."},

	# --- Bloatware (ICE Corp 1 §4) ---
	"SPAM": {"name": "SPAM", "type": "BLOATWARE", "tags": [], "bw": 1, "rarity": "BLOAT",
		"text": "Can't be played normally. Pay 1 BW to clear it: it's BURNED for the rest of the Node."},
	"TRACER": {"name": "TRACER", "type": "BLOATWARE", "tags": [], "bw": 0, "rarity": "BLOAT", "unplayable": true,
		"text": "Can't be played. If TRACER is in your hand at the end of your turn: +3 TRACE."},
}

const STARTER_GENERALIST := [
	"FORTRESS_ICEPICK", "TUMBLER_ICEPICK", "VOID_ICEPICK", "BASIC_EXTRACTOR", "CORTEX_BUFFER",
	"PULP_SHIELD", "PULP_SHIELD", "PULP_SHIELD", "PROBE", "PROBE", "PROBE", "GHOST_SIGNAL",
]

static func def(id: String) -> Dictionary:
	return DEFS[id]

static func reward_pool(pool: String, rarity: String) -> Array:
	var out := []
	for id in DEFS:
		var d: Dictionary = DEFS[id]
		if d.rarity != rarity:
			continue
		var p: String = d.get("pool", "SHARED")
		if p == pool:
			out.append(id)
	return out
