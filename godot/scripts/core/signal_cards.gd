class_name SignalCards
extends RefCounted

const ORDER := ["HALCYON", "IRONWATCH", "LUCIDA"]
## SIGNAL-002 (designer 2026-11-28): the First Signal item is a Signal barcode (was a punch card, SIGNAL-001).
## Code names and saved keys stay "punch" until a rename is approved; old saves store corporation keys only.
## Each barcode is drawn on a 36-module strip: the shared guard bars at both ends, plus that corporation's
## bars ([start, width] in modules). The three corporations' bars never overlap, and overlaid they fill in
## every bar of SIGNAL_BARS: one barcode alone is a barcode, the three together form the Signal.
const MODULES := 36
const GUARDS := [[0, 1], [2, 1], [33, 1], [35, 1]]
const SIGNAL_BARS := [[4, 2], [7, 1], [9, 1], [11, 2], [14, 1], [16, 1], [18, 2], [21, 1], [23, 1], [25, 2], [28, 1], [30, 1]]
const DATA := {
 "HALCYON": {"id": "halcyon-punch", "stock": "#C4DDCF", "accent": "#3A5F58", "mark": "H", "patent": "HD–12",
  "bars": [[4, 2], [16, 1], [21, 1], [25, 2]]},
 "IRONWATCH": {"id": "ironwatch-punch", "stock": "#253650", "accent": "#F0D38A", "mark": "I", "patent": "IW–12",
  "bars": [[7, 1], [18, 2], [23, 1], [28, 1]]},
 "LUCIDA": {"id": "lucida-punch", "stock": "#E2D2F4", "accent": "#784D55", "mark": "L", "patent": "L–12",
  "bars": [[9, 1], [11, 2], [14, 1], [30, 1]]}
}

## The bars to draw for a set of held barcodes, overlaid: the guards plus every held corporation's bars.
static func bars_for(corps: Array) -> Array:
 var out: Array = GUARDS.duplicate(true)
 for corp in ORDER:
  if corps.has(corp): out.append_array(DATA[corp].bars)
 return out

static func restore(values: Array) -> Array[String]:
 var result: Array[String] = []
 for corp in ORDER:
  if values.has(corp): result.append(corp)
 return result

static func may_reveal(held: Array) -> bool:
 return ORDER.all(func(corp): return held.has(corp))
