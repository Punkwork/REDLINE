class_name AtomicDecoPunk
extends RefCounted
## Presentation settings. Game rules do not consume these data.
static var settings: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/atomic_deco_punk.json"))

static func target(trace: int, strikes: int, modal_open: bool) -> float:
 var cfg: Dictionary = settings.bleed
 if strikes >= 2: return cfg.mask_off
 if modal_open: return cfg.strike
 if strikes == 0 and trace < int(cfg.trace_start): return cfg.friendly
 return lerpf(cfg.cracking_start, cfg.cracking_end, inverse_lerp(cfg.trace_start, cfg.trace_end, clampi(trace, cfg.trace_start, cfg.trace_end)))

static func ease_weight(elapsed: float, reduced_motion: bool) -> float:
 if reduced_motion: return 1.0
 var t := clampf(elapsed / float(settings.bleed.ease_seconds), 0.0, 1.0)
 return smoothstep(0.0, 1.0, t)

static func reveal(bleed: float) -> float:
 var curve: Dictionary = settings.bleed
 var ends: Dictionary = settings.reveal
 return lerpf(ends.start, ends.end, clampf(inverse_lerp(curve.cracking_start, curve.cracking_end, bleed), 0.0, 1.0))

## PIXEL-TRACE-001 (PROPOSED): the pixel step for the backdrop and mascot art.
static func pixel_step(trace: int, strikes: int, modal_open: bool) -> Dictionary:
 var cfg: Dictionary = settings.pixel
 if strikes >= 2: return cfg.mask_off
 if modal_open or strikes == 1: return cfg.strike
 if trace >= 30: return cfg.trace_30
 if trace >= 20: return cfg.trace_20
 return cfg.friendly
