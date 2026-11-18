class_name SignalCards
extends RefCounted

const ORDER := ["HALCYON", "IRONWATCH", "LUCIDA"]
const DATA := {
 "HALCYON": {"id": "halcyon-punch", "stock": "#C4DDCF", "accent": "#3A5F58", "mark": "H", "patent": "HD–12", "holes": [[],[5],[4,7],[3,8],[2,9],[4,7],[5],[]]},
 "IRONWATCH": {"id": "ironwatch-punch", "stock": "#253650", "accent": "#F0D38A", "mark": "I", "patent": "IW–12", "holes": [[],[6],[3,8],[2,9],[3,8],[5,6],[6],[]]},
 "LUCIDA": {"id": "lucida-punch", "stock": "#E2D2F4", "accent": "#784D55", "mark": "L", "patent": "L–12", "holes": [[],[],[5,6],[4,7],[4,5,6,7],[3,8],[],[]]}
}

static func restore(values: Array) -> Array[String]:
 var result: Array[String] = []
 for corp in ORDER:
  if values.has(corp): result.append(corp)
 return result

static func may_reveal(held: Array) -> bool:
 return ORDER.all(func(corp): return held.has(corp))
