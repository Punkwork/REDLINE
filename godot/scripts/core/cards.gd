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

	# --- ECHO starter (Rustlers §4; HUSH is the TUMBLER Icepick since ROT-001) ---
	"HUSH": {"name": "HUSH", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 1, "ram": 1, "rarity": "STARTER",
		"pick": {"itype": "TUMBLER", "str": 0, "boost_cost": 2, "boost_amt": 1, "break_cost": 1},
		"text": "STR 0. Boost: 2 BW → +1 STR. Break: 1 BW."},
	"BACKDOOR": {"name": "BACKDOOR", "type": "SCRIPT", "tags": ["EXPLOIT"], "bw": 3, "rarity": "STARTER",
		"breaker": {"n": 1, "max_str": 3}, "text": "Break 1 subroutine on any ICE with STR 3 or less."},
	"SLOW_DRIP": {"name": "SLOW DRIP", "type": "PROGRAM", "tags": ["EXTRACTOR"], "bw": 1, "ram": 1, "rarity": "STARTER",
		"extract": 3, "extract_quiet": 6, "text": "End of your turn: extract 3 CRED. If you have gained no TRACE this encounter, extract 6 instead."},
	"SMOKESCREEN": {"name": "SMOKESCREEN", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 1, "rarity": "STARTER",
		"text": "+2 SHIELD. The first TRACE you gain during the next Corporation Response is reduced by 2."},
	"DEAD_AIR": {"name": "DEAD AIR", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 0, "rarity": "STARTER",
		"text": "CACHE 1 card in your hand."},

	# --- ECHO pool (Card Pools §5) ---
	"MUFFLE": {"name": "MUFFLE", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 0, "rarity": "COMMON", "pool": "ECHO", "text": "−2 TRACE."},
	"GHOST_STEP": {"name": "GHOST STEP", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 1, "rarity": "COMMON", "pool": "ECHO", "text": "Draw 2."},
	"PATIENCE": {"name": "PATIENCE", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 1, "rarity": "COMMON", "pool": "ECHO",
		"text": "+4 SHIELD if you've gained no TRACE this encounter; otherwise +2 SHIELD."},
	"DECOY_SIGNAL": {"name": "DECOY SIGNAL", "type": "SCRIPT", "tags": [], "bw": 1, "rarity": "COMMON", "pool": "ECHO",
		"text": "Until the end of your turn, VOID reactive abilities do nothing."},
	"SILENT_PARTNER": {"name": "SILENT PARTNER", "type": "PROGRAM", "tags": ["EXTRACTOR"], "bw": 1, "ram": 1, "rarity": "UNCOMMON", "pool": "ECHO",
		"text": "End of your turn: extract 2 CRED for each CLOAK card you played this turn."},
	"LONG_GAME": {"name": "LONG GAME", "type": "PROTOCOL", "tags": [], "bw": 1, "rarity": "UNCOMMON", "pool": "ECHO",
		"text": "While your TRACE is under 10, your Extractors extract +2 CRED each."},
	"VANISH": {"name": "VANISH", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 2, "rarity": "UNCOMMON", "pool": "ECHO",
		"text": "During the next Corporation Response, TRACE effects add nothing. BURNED."},
	"SIDE_CHANNEL": {"name": "SIDE CHANNEL", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 2, "ram": 1, "rarity": "RARE", "pool": "ECHO",
		"pick": {"itype": "ANY", "str": 3, "boost_cost": 2, "boost_amt": 1, "break_cost": 2},
		"text": "STR 3. Boost: 2 BW → +1 STR. Break: 2 BW. Any ICE type."},
	"BLACKOUT": {"name": "BLACKOUT", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 3, "rarity": "RARE", "pool": "ECHO",
		"text": "Skip the next Corporation Response. BURNED."},

	# --- RIOT starter (Rustlers §5) ---
	"SLEDGE": {"name": "SLEDGE", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 1, "ram": 1, "rarity": "STARTER",
		"pick": {"itype": "FORTRESS", "str": 2, "boost_cost": 1, "boost_amt": 1, "break_cost": 1, "free_first": true, "trace_per_break": 1},
		"text": "STR 2. Boost: 1 BW → +1 STR. First break each turn free; then 1 BW per break. Each break: +1 TRACE."},
	"BRUTE_FORCE": {"name": "BRUTE FORCE", "type": "SCRIPT", "tags": ["EXPLOIT"], "bw": 1, "trace_cost": 4, "rarity": "STARTER",
		"breaker": {"n": 1, "max_str": 4}, "text": "Break 1 subroutine on any ICE with STR 4 or less. (+4 TRACE)"},
	"OVERLOAD": {"name": "OVERLOAD", "type": "SCRIPT", "tags": ["EXPLOIT"], "bw": 0, "trace_cost": 2, "rarity": "STARTER", "target": true,
		"text": "Target ICE: −2 STR this encounter. (+2 TRACE)"},
	"FEEDBACK": {"name": "FEEDBACK", "type": "SCRIPT", "tags": ["EXPLOIT"], "bw": 2, "rarity": "STARTER", "target": true,
		"text": "Target ICE: −1 STR this encounter for every 10 TRACE you have."},
	"ADRENAL_SPIKE": {"name": "ADRENAL SPIKE", "type": "SCRIPT", "tags": [], "bw": 0, "trace_cost": 2, "rarity": "STARTER",
		"text": "Gain 1 BW. (+2 TRACE)"},
	# RIOT-003: SHATTER redesigned.
	"SHATTER": {"name": "SHATTER", "type": "SCRIPT", "tags": ["EXPLOIT"], "bw": 1, "trace_cost": 3, "rarity": "STARTER", "target": true,
		"text": "This turn, SLEDGE can break subroutines on target ICE of any type. At the end of your turn, SLEDGE drops to STR 0 for the rest of the encounter. (+3 TRACE)"},
	"LAY_LOW": {"name": "LAY LOW", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 1, "rarity": "STARTER", "text": "−3 TRACE."},
	"SMASH_AND_GRAB": {"name": "SMASH & GRAB", "type": "PROGRAM", "tags": ["EXTRACTOR"], "bw": 1, "ram": 1, "rarity": "STARTER",
		"extract": 8, "extract_trace": 1, "extract_trace_below": 20, "text": "End of your turn: extract 8 CRED. +1 TRACE while your TRACE is under 20."},

	# --- RIOT pool (Card Pools §6; SIGYL → TUMBLER) ---
	"SMASH": {"name": "SMASH", "type": "SCRIPT", "tags": ["EXPLOIT"], "bw": 0, "trace_cost": 3, "rarity": "COMMON", "pool": "RIOT",
		"target": true, "target_type": "FORTRESS", "text": "Target FORTRESS: −4 STR this encounter. (+3 TRACE)"},
	"ROAR": {"name": "ROAR", "type": "SCRIPT", "tags": [], "bw": 0, "trace_cost": 3, "rarity": "COMMON", "pool": "RIOT", "text": "Draw 2. (+3 TRACE)"},
	"CRASH_CART": {"name": "CRASH CART", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 1, "rarity": "COMMON", "pool": "RIOT", "text": "−3 TRACE. +2 SHIELD."},
	"PAIN_TOLERANCE": {"name": "PAIN TOLERANCE", "type": "PROTOCOL", "tags": [], "bw": 1, "rarity": "UNCOMMON", "pool": "RIOT",
		"text": "Start of your turn: if your TRACE is 20 or more, +2 SHIELD."},
	"BERSERK": {"name": "BERSERK", "type": "PROTOCOL", "tags": [], "bw": 1, "rarity": "UNCOMMON", "pool": "RIOT",
		"text": "While your TRACE is 20 or more, your EXPLOIT SCRIPTS cost 1 less BW (minimum 0)."},
	"WRECKING_BALL": {"name": "WRECKING BALL", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 1, "ram": 1, "rarity": "UNCOMMON", "pool": "RIOT",
		"pick": {"itype": "TUMBLER", "str": 3, "boost_cost": 1, "boost_amt": 1, "break_cost": 0, "trace_per_break": 2},
		"text": "STR 3. Boost: 1 BW → +1 STR. Break: 0 BW, +2 TRACE."},
	"CHAINSAW": {"name": "CHAINSAW", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 1, "ram": 1, "rarity": "UNCOMMON", "pool": "RIOT",
		"pick": {"itype": "VOID", "str": 2, "boost_cost": 1, "boost_amt": 1, "break_cost": 0, "trace_per_break": 2},
		"text": "STR 2. Boost: 1 BW → +1 STR. Break: 0 BW, +2 TRACE."},
	"FLASHPOINT": {"name": "FLASHPOINT", "type": "SCRIPT", "tags": ["EXPLOIT"], "bw": 2, "trace_cost": 5, "rarity": "RARE", "pool": "RIOT",
		"text": "Break 1 subroutine on every ICE with STR 3 or less. (+5 TRACE)"},
	"NO_WITNESSES": {"name": "NO WITNESSES", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 1, "rarity": "RARE", "pool": "RIOT",
		"text": "If your TRACE is 30 or more, set it to 10. BURNED."},

	# --- VECTOR starter (Rustlers §6) ---
	"STINGER": {"name": "STINGER", "type": "PROGRAM", "tags": ["ICEPICK"], "bw": 1, "ram": 1, "rarity": "STARTER",
		"pick": {"itype": "VOID", "str": 0, "boost_cost": 1, "boost_amt": 1, "break_cost": 1, "rot_per_break": 1},
		"text": "STR 0. Boost: 1 BW → +1 STR. Break: 1 BW. Each break also INFECTs 1 ROT on that ICE."},
	"RUNTIME_ERROR": {"name": "RUNTIME ERROR", "type": "SCRIPT", "tags": ["EXPLOIT", "VIRUS"], "bw": 2, "trace_cost": 1, "rarity": "STARTER",
		"breaker": {"n": 1, "min_virus": 2}, "text": "Break 1 subroutine on any ICE with 2 or more virus counters. (+1 TRACE)"},
	"INJECT": {"name": "INJECT", "type": "SCRIPT", "tags": ["EXPLOIT", "VIRUS"], "bw": 1, "rarity": "STARTER", "target": true,
		"infect": {"ROT": 2}, "text": "INFECT 2 ROT. (Each ROT: −1 STR.)"},
	"REPLICATOR": {"name": "REPLICATOR", "type": "PROGRAM", "tags": ["VIRUS"], "bw": 1, "ram": 1, "rarity": "STARTER",
		"text": "Start of your turn: on every ICE with virus counters, add 1 counter of each strain already on it."},
	"OUTBREAK": {"name": "OUTBREAK", "type": "SCRIPT", "tags": ["VIRUS"], "bw": 2, "rarity": "STARTER", "target": true,
		"text": "Double the counters of every strain on target ICE."},

	# --- VECTOR pool (Card Pools §7). INCUBATOR triggers on the corporation's PURGE (PURGE-001). ---
	"SCRAMBLER": {"name": "SCRAMBLER", "type": "SCRIPT", "tags": ["VIRUS"], "bw": 1, "rarity": "COMMON", "pool": "VECTOR", "target": true,
		"infect": {"SCRAMBLE": 2}, "text": "INFECT 2 SCRAMBLE. (Each SCRAMBLE: this ICE's PULP subroutines deal 1 less.)"},
	"BLINDFOLD": {"name": "BLINDFOLD", "type": "SCRIPT", "tags": ["VIRUS"], "bw": 1, "rarity": "COMMON", "pool": "VECTOR", "target": true,
		"infect": {"BLIND": 2}, "text": "INFECT 2 BLIND. (Each BLIND: this ICE's TRACE subroutines add 1 less.)"},
	"LEECHWARE": {"name": "LEECHWARE", "type": "SCRIPT", "tags": ["VIRUS"], "bw": 1, "rarity": "COMMON", "pool": "VECTOR", "target": true,
		"infect": {"LEECH": 2}, "text": "INFECT 2 LEECH. (Each LEECH: extract 1 CRED at the start of your turn.)"},
	"QUARANTINE": {"name": "QUARANTINE", "type": "SCRIPT", "tags": ["CLOAK"], "bw": 1, "rarity": "COMMON", "pool": "VECTOR", "target": true,
		"text": "+1 SHIELD for each virus counter on target ICE (maximum +6)."},
	"WORMHOLE": {"name": "WORMHOLE", "type": "SCRIPT", "tags": ["VIRUS"], "bw": 1, "rarity": "UNCOMMON", "pool": "VECTOR", "target": true,
		"infect": {"WORM": 1, "ROT": 1}, "text": "INFECT 1 WORM and 1 ROT. (Each WORM: at the start of your turn, copy 1 counter of each strain here onto the ICE to its right. Each ROT: −1 STR.)"},
	"COCKTAIL": {"name": "COCKTAIL", "type": "SCRIPT", "tags": ["VIRUS"], "bw": 2, "rarity": "UNCOMMON", "pool": "VECTOR", "target": true,
		"infect": {"ROT": 1, "SCRAMBLE": 1, "BLIND": 1, "LEECH": 1, "WORM": 1}, "text": "INFECT 1 of each strain (ROT, SCRAMBLE, BLIND, LEECH, WORM)."},
	"INCUBATOR": {"name": "INCUBATOR", "type": "PROTOCOL", "tags": [], "bw": 1, "rarity": "UNCOMMON", "pool": "VECTOR",
		"text": "Whenever a PURGE removes virus counters from an ICE, INFECT 2 ROT on that ICE afterward."},
	"PANDEMIC": {"name": "PANDEMIC", "type": "SCRIPT", "tags": ["VIRUS"], "bw": 3, "rarity": "RARE", "pool": "VECTOR", "target": true,
		"text": "Copy all virus counters on target ICE onto every other ICE."},
	"HOST_TAKEOVER": {"name": "HOST TAKEOVER", "type": "SCRIPT", "tags": ["VIRUS", "EXPLOIT"], "bw": 2, "rarity": "RARE", "pool": "VECTOR", "target": true,
		"breaker": {"n": 2, "min_virus": 5, "same_ice": true}, "text": "Break 2 subroutines on an ICE with 5 or more virus counters."},

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

# ECHO-001: SLOW DRIP moved to ECHO's reward pool; ECHO starts with 3 PROBE and 3 PULP Shield.
# ECHO-003: GHOST SIGNAL (a shared basic, BASIC-001) back in the starter deck; one SMOKESCREEN out.
const STARTER_ECHO := [
	"HUSH", "BACKDOOR", "BASIC_EXTRACTOR", "PROBE", "PROBE", "PROBE", "PULP_SHIELD", "PULP_SHIELD", "PULP_SHIELD",
	"SMOKESCREEN", "DEAD_AIR", "GHOST_SIGNAL",
]
## Cards offered in a Rustler's reward pool besides those tagged with "pool" (rarity used for the reward roll).
const POOL_EXTRA := {"ECHO": {"SLOW_DRIP": "COMMON"}}
# RIOT-002 (playtest): 15 cards. +1 SHATTER, +2 PROBE, +1 PULP Shield, −1 OVERLOAD.
const STARTER_RIOT := [
	"SLEDGE", "BRUTE_FORCE", "SHATTER", "OVERLOAD", "PROBE", "PROBE", "PROBE", "FEEDBACK", "ADRENAL_SPIKE",
	"PULP_SHIELD", "PULP_SHIELD", "PULP_SHIELD", "LAY_LOW", "SMASH_AND_GRAB", "BASIC_EXTRACTOR",
]
const STARTER_VECTOR := [
	"STINGER", "RUNTIME_ERROR", "INJECT", "INJECT", "INJECT", "REPLICATOR", "OUTBREAK", "PROBE",
	"PULP_SHIELD", "PULP_SHIELD", "BASIC_EXTRACTOR", "GHOST_SIGNAL",
]

## RUSTLER-001..008 (REDLINE_RUSTLERS.md). Shared stats: 30 VITAE, 4 BW, DRAW 6, 4 RAM.
const RUSTLERS := {
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
	return DEFS[id]

static func reward_pool(pool: String, rarity: String) -> Array:
	var out := []
	for id in DEFS:
		var d: Dictionary = DEFS[id]
		if d.rarity != rarity or d.get("slice_excluded", false):
			continue
		var p: String = d.get("pool", "SHARED")
		if p == pool:
			out.append(id)
	var extra: Dictionary = POOL_EXTRA.get(pool, {})
	for id in extra:
		if extra[id] == rarity:
			out.append(id)
	return out
