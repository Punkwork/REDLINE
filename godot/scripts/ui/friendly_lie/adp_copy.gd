class_name AdpCopy
extends RefCounted

static var lines: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/adp_copy.json"))

static func pool(kind: String, corp: String, fields: Dictionary = {}) -> Array:
 return lines.filter(func(line):
  if line.kind != kind or line.corp != corp or line.approval != "approved" or line.tag == "reveal":
   return false
  for key in fields:
   if line.get(key) != fields[key]: return false
  return true)

static func pick(kind: String, corp: String, index: int, fields: Dictionary = {}) -> Dictionary:
 var choices := pool(kind, corp, fields)
 return choices[posmod(index, choices.size())] if not choices.is_empty() else {}

static func band(bleed: float) -> String:
 if bleed >= 0.8: return "C"
 if bleed >= 0.4: return "B"
 if bleed >= 0.2: return "A"
 return ""
