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

# UI-TYPO-001 event flyouts (refined treatment, reference 02). Treatment is provisional.
# Copy approved by the designer 2026-11-26: RUSTLER TURN, CORP COUNTERMEASURE.
const FLYOUT := {
	"rustler_turn": {"text": "RUSTLER TURN", "ink": Color("#FFF3D6"), "edge": Color("#29E3E8"), "band": Color("#0B3A40")},
	"corp_countermeasure": {"text": "CORP COUNTERMEASURE", "ink": Color("#FFE9C8"), "edge": Color("#FF5A2A"), "band": Color("#4A0D08")},
	## ARCH-V2-006h / R06 (PROPOSED wording and colours, UI-TYPO-001 catalogue 04 families):
	"lockdown": {"text": "LOCKDOWN", "ink": Color("#FFF4EC"), "edge": Color("#FF2A3A"), "band": Color("#2A0305"), "glyph": "lock"},
	"strike": {"text": "TRACE STRIKE", "ink": Color("#FFE9C8"), "edge": Color("#FF6A2A"), "band": Color("#4A1408")},
	"mask_off": {"text": "MASK OFF", "ink": Color("#FFF4EC"), "edge": Color("#FF2A6A"), "band": Color("#2A0315")},
	"breached": {"text": "DEADLOCK BREACHED", "ink": Color("#FFFAF2"), "edge": Color("#FF7A2A"), "band": Color("#1E0803"), "glyph": "open_lock"},
	"ice_lethal": {"text": "LETHAL", "ink": Color("#FFF4F4"), "edge": Color("#FF2A55"), "band": Color("#2A030C")},
	"parting_shot": {"text": "PARTING SHOT", "ink": Color("#FFE9C8"), "edge": Color("#FF8A3A"), "band": Color("#3A1A06")},
	"full_extraction": {"text": "RESERVE EXTRACTED", "ink": Color("#FFF3D6"), "edge": Color("#3AE8A0"), "band": Color("#06301E")},
}
## Refined-flyout timing (reference 02): enter 0–0.12 s, reveal to 0.25 s, hold to 1.10 s, exit by 1.30 s.
## UI-TYPO-001a caps any pass over rule text at 1–2 s; the total stays ≤ 1.5 s.
const FLYOUT_TIMING := {"enter": 0.12, "reveal": 0.13, "hold": 0.85, "exit": 0.20}

static func flyout_total() -> float:
	var t := 0.0
	for k in FLYOUT_TIMING: t += float(FLYOUT_TIMING[k])
	return t

static func luminance(c: Color) -> float:
	var ch := func(v: float) -> float: return v / 12.92 if v <= 0.03928 else pow((v + 0.055) / 1.055, 2.4)
	return 0.2126 * ch.call(c.r) + 0.7152 * ch.call(c.g) + 0.0722 * ch.call(c.b)

static func contrast(a: Color, b: Color) -> float:
	var la := luminance(a); var lb := luminance(b)
	return (maxf(la, lb) + 0.05) / (minf(la, lb) + 0.05)
