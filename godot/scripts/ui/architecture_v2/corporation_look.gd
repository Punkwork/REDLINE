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
