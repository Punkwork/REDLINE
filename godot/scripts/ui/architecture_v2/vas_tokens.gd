class_name VasTokens
extends RefCounted
## CAS-001 C18 / VAS-001 §5 (ARCH-V2-003): palette, type and flyout tokens for the Architecture V2
## encounter. The hex values are VAS-001's approximate starting targets, to be tuned against the
## reference; change them here, not in components. Presentation only.

# VAS-001 §5 material palette.
const CHASSIS := Color("#211915")
const BAKELITE := Color("#422A1F")
const BRONZE := Color("#9D633B")
const COPPER := Color("#D99B59")
const IVORY := Color("#F5E6C4")
const SEAFOAM := Color("#78BBA7")
const PHOSPHOR := Color("#64F2C3")
const WARNING := Color("#D73A32")
const AMBER := Color("#FFB32E")

# Derived roles (chosen for ≥ 4.5:1 text contrast; checked in test_arch_v2_ice.gd).
const SEAFOAM_DEEP := Color("#4E8F7D")    # recess behind the key bank
const SEAFOAM_INK := Color("#10241E")     # dark text on seafoam
const PLAQUE := Color("#17110E")          # nameplate glass
const PLAQUE_INK := IVORY
const CHROME_HI := Color("#F2F5F4")
const CHROME_LO := Color("#7E878A")
const FOCUS := Color("#2EE6F0")           # electric-cyan selection/focus (VAS-001 §7)
const LAMP_ON := Color("#4DFF6E")
const LAMP_OFF := Color("#3A3632")

# Type: plaques and readouts in Barlow Condensed, rules in DM Sans (VAS-001 §5; licensed in repo).
const FONT_PLAQUE := preload("res://assets/fonts/BarlowCondensed-Bold.ttf")
const FONT_PLAQUE_SEMI := preload("res://assets/fonts/BarlowCondensed-SemiBold.ttf")
const FONT_RULES := preload("res://assets/fonts/DM-Sans.ttf")
const FONT_READOUT := preload("res://assets/fonts/SpaceMono-Bold.ttf")

# Flyout type (M06 / UI-TYPO-002): condensed and forward-leaning for Rustler agency, heavy and
# upright for institutional authority, thin Art Deco capitals for LETHAL's cold recognition.
const FONT_FLYOUT_CONDENSED := FONT_PLAQUE
const FONT_FLYOUT_TRACKED := FONT_PLAQUE_SEMI
const FONT_FLYOUT_HEAVY := preload("res://assets/fonts/Barlow-Bold.ttf")
const FONT_FLYOUT_THIN := preload("res://assets/fonts/PoiretOne-Regular.ttf")

# UI-TYPO-002 (M06): the eight designer-approved event treatments (2026-11-27). The canonical
# specification is the UI Design Bible §2b; these are its implementation values. Every number here is
# an initial playtest target, tuned here and nowhere else. Wording approved 2026-11-26 (ARCH-V2-006f/j).
# Keys per event: text (approved wording), treatment (EventFlyout draw routine), timing (enter, reveal,
# hold, exit in seconds; the hold is the stable readable phase), ink/edge/band (+ treatment accents),
# font/px, ease_in/ease_out (Godot ease() curves: < 1 decelerates, > 1 accelerates).
# Semantic roles (UI Bible §2a): cyan Rustler agency, vermilion corporate authority, magenta
# disruption, gold achievement, warm ivory primary text.
const FLYOUT := {
	"rustler_turn": {"text": "RUSTLER TURN", "treatment": "kinetic_sweep",
		"timing": {"enter": 0.14, "reveal": 0.12, "hold": 0.82, "exit": 0.22},
		"ink": Color("#FFF3D6"), "edge": Color("#29E3E8"), "band": Color("#0B3A40"),
		"font": FONT_FLYOUT_CONDENSED, "px": 76, "skew": 0.32, "travel": 70.0, "momentum": 14.0,
		"ease_in": 0.35, "ease_out": 2.4},
	"corp_countermeasure": {"text": "CORP COUNTERMEASURE", "treatment": "institutional_transmission",
		"timing": {"enter": 0.20, "reveal": 0.08, "hold": 0.80, "exit": 0.22},
		"lines": ["CORP", "COUNTERMEASURE"],
		"ink": Color("#FFF1DC"), "edge": Color("#FF4A24"), "band": Color("#220402"),
		"font": FONT_FLYOUT_HEAVY, "px": 66, "kicker_font": FONT_FLYOUT_TRACKED, "kicker_px": 36, "kicker_tracking": 24.0, "kicker_ink": Color("#FF6A40"),
		## Signal acquisition: [time s, signal level] keyframes held step-wise (irregular, not periodic).
		## Levels stay ≥ 0.25 after first light, so no full-contrast flashes (≤ 3 per second, tested).
		"acquire": [[0.0, 0.0], [0.03, 0.45], [0.07, 0.25], [0.10, 0.75], [0.15, 0.55], [0.20, 1.0]],
		"slices": 7, "fizzle_shift": 90.0, "ease_in": 1.0, "ease_out": 1.8},
	"breached": {"text": "DEADLOCK BREACHED", "treatment": "kinetic_breakthrough",
		"timing": {"enter": 0.24, "reveal": 0.16, "hold": 0.80, "exit": 0.30},
		"lines": ["DEADLOCK", "BREACHED"],
		"ink": Color("#FFFAF2"), "edge": Color("#29E3E8"), "band": Color("#03171C"),
		"inward": [Color("#FFB32E"), Color("#FF4A24")],
		"font": FONT_FLYOUT_CONDENSED, "px": 74, "skew": 0.22, "travel": 520.0,
		"ease_in": 0.3, "ease_out": 2.2},
	"lockdown": {"text": "LOCKDOWN", "treatment": "surveillance_convergence",
		"timing": {"enter": 0.42, "reveal": 0.14, "hold": 0.84, "exit": 0.30},
		"ink": Color("#FFF4EC"), "edge": Color("#FF2A3A"), "band": Color("#2C0306"),
		"font": FONT_FLYOUT_HEAVY, "px": 78, "frames": 5, "frame_gap": 22.0, "panel": Vector2(560, 132),
		"ease_in": 0.45, "ease_out": 2.0},
	"mask_off": {"text": "MASK OFF", "treatment": "masked_revelation",
		## exit = withdraw (first half: the mask lifts off the complete image) + return (second half).
		"timing": {"enter": 0.25, "reveal": 0.15, "hold": 0.45, "exit": 0.85},
		"ink": Color("#FFF4EC"), "edge": Color("#FF2A9A"), "band": Color("#16040E"),
		"font": FONT_FLYOUT_HEAVY, "px": 250, "art_state": "HOSTILE",
		## Translucency caps keep the console readable underneath (UI-TYPO-001a: nothing hidden).
		"mask_alpha": 0.55, "letter_alpha": 0.55, "image_alpha": 0.50, "grow": 0.10,
		"ease_in": 0.5, "ease_out": 2.0},
	"parting_shot": {"text": "PARTING SHOT", "treatment": "corner_slingshot",
		"timing": {"enter": 0.30, "reveal": 0.07, "hold": 0.55, "exit": 0.23},
		"lines": ["PARTING", "SHOT"],
		"ink": Color("#FFEBD0"), "edge": Color("#FF8A3A"), "band": Color("#3A1A06"),
		## 85% of the original proposed 76 px flyout scale (designer 2026-11-27).
		"font": FONT_FLYOUT_CONDENSED, "px": 65, "skew": 0.28, "angle_deg": -14.0, "stagger": Vector2(210, -66),
		"apex": Vector2(0.40, 0.42), "corner": Vector2(-0.08, 1.10), "bulge": Vector2(-0.10, -0.20),
		"ease_in": 0.4, "ease_out": 3.0},
	"full_extraction": {"text": "RESERVE EXTRACTED", "treatment": "atomic_ascension",
		## enter + reveal = RailLedger.ANTS_S + COUNT_S (1.35 s): EXTRACTED turns fully gold as the CRED
		## readout lands on its new value (tested).
		"timing": {"enter": 0.20, "reveal": 1.15, "hold": 0.15, "exit": 0.20},
		"lines": ["RESERVE", "EXTRACTED"],
		"ink": Color("#FFF3D6"), "edge": Color("#3AE8D8"), "band": Color("#011012"), "gold": Color("#FFD25A"),
		"dim": Color("#9A8A6A"),
		"font": FONT_FLYOUT_CONDENSED, "px": 74, "kicker_px": 34, "orbits": 3, "orbit_turns": 1.25,
		"ease_in": 0.4, "ease_out": 2.0},
}
## LETHAL (Cold Recognition) is not a flyout: a red optical lens and thin capitals on the affected
## ICE's own portrait, shown for as long as that ICE is LETHAL. No global announcement, no motion.
const LETHAL_LENS := {"text": "LETHAL", "font": FONT_FLYOUT_THIN, "px": 22, "tracking": 7.0,
	"ink": Color("#FFE3E0"), "plate": Color("#0A0607"), "plate_alpha": 0.82,
	"rim_hi": Color("#C9CED0"), "rim_lo": Color("#3E4446"), "glass": Color("#050203"),
	"core": Color("#D3101C"), "hot": Color("#FFC46A"), "radius": 30.0, "fade_in": 0.6}
## UI-TYPO-001a: a flyout may pass over rule text for at most 1–2 s. Every M06 timing stays inside it.
const FLYOUT_MAX_SECONDS := 2.0
## Fallback timing for a kind without its own (none today): the refined 1.3 s treatment.
const FLYOUT_TIMING := {"enter": 0.12, "reveal": 0.13, "hold": 0.85, "exit": 0.20}

static func flyout_timing(k: String) -> Dictionary:
	return FLYOUT.get(k, {}).get("timing", FLYOUT_TIMING)

## Total run time of one flyout kind; with no kind, the longest of them (for queue bounds).
static func flyout_total(k: String = "") -> float:
	if k == "":
		var most := 0.0
		for kind in FLYOUT: most = maxf(most, flyout_total(kind))
		return most
	var t := 0.0
	var timing := flyout_timing(k)
	for p in timing: t += float(timing[p])
	return t

static func luminance(c: Color) -> float:
	var ch := func(v: float) -> float: return v / 12.92 if v <= 0.03928 else pow((v + 0.055) / 1.055, 2.4)
	return 0.2126 * ch.call(c.r) + 0.7152 * ch.call(c.g) + 0.0722 * ch.call(c.b)

static func contrast(a: Color, b: Color) -> float:
	var la := luminance(a); var lb := luminance(b)
	return (maxf(la, lb) + 0.05) / (minf(la, lb) + 0.05)
