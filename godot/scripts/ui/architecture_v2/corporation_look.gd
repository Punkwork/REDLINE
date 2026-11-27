class_name CorporationLook
extends RefCounted
## CAS-001 C06 (ARCH-V2-007, Batch 4): what a corporation looks like on the V2 encounter screen, from
## data, so every corporation uses the same screen. First part: its painted rooms (designer art,
## `assets/concept/backgrounds/BG_<CORP>_<STATE>.png`): FRIENDLY, HOSTILE, CENTRAL, ESCAPE. Missing
## files return null and the window keeps its seafoam field. Presentation only.

const ROOT := "res://assets/concept/backgrounds/"

static var _cache := {}

static func room(corp: String, state: String) -> Texture2D:
	var path := ROOT + "BG_%s_%s.png" % [corp.to_upper(), state.to_upper()]
	if not _cache.has(path): _cache[path] = load(path) if ResourceLoader.exists(path) else null
	return _cache[path]

## The room for this encounter: the Central Node's vault, the escape's alarm, otherwise the
## FRIENDLY room (whose HOSTILE twin shows through with the reveal).
static func rooms_for(game: Game) -> Dictionary:
	var corp := String(game.corporation)
	var base := "FRIENDLY"
	if bool(game.node.get("central", false)): base = "CENTRAL"
	elif bool(game.node.get("escape", false)): base = "ESCAPE"
	var friendly := room(corp, base)
	if friendly == null and base != "FRIENDLY": friendly = room(corp, "FRIENDLY")
	return {"friendly": friendly, "hostile": room(corp, "HOSTILE") if base == "FRIENDLY" else null}

## Enamel for the ICE windows' painted seafoam (Build 12's CONSOLE_ENAMEL); null keeps seafoam.
const ENAMEL := {"IRONWATCH": Color("#1F3A5F"), "LUCIDA": Color("#C9B6F2")}
static func enamel(corp: String) -> Variant:
	return ENAMEL.get(corp.to_upper(), null)

## The header's ad plate and its approved line, per corporation. Only HALCYON has painted art and
## approved copy today; others show no plate (negative space) until both exist.
const AD_COPY := {"HALCYON": "A Halcyon Homesteads™\ncommunity"}
static func ad_plate(corp: String) -> Dictionary:
	var c := corp.to_upper()
	var art := "chassis/V2_AD_PLATE_%s.png" % c
	if not AD_COPY.has(c) or not ResourceLoader.exists(V2Art.ROOT + art): return {}
	return {"art": art, "copy": AD_COPY[c]}

