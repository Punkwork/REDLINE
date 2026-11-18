class_name ArchCopy
extends RefCounted

static var lines: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/arch_copy.json"))
const REVEAL_KINDS := ["island_purpose", "signal_purpose", "signal_command"]
const SECRET_TEXT := ["synchronization scrambler", "scramble sync", "umbrella ai", "the same ai", "merge everyone", "test the merge", "merges people", "merging people", "synchronization signal"]

static func may_show(line: Dictionary, held: Array = [], working_copy: bool = false) -> bool:
 if not valid_line(line): return false
 if line.get("approval") != "approved" and not (working_copy and line.get("approval") == "proposed"): return false
 return line.get("tag") != "reveal" or (line.get("trigger") == "third_card" and SignalCards.may_reveal(held))

static func pool(kind: String, corp: String = "", working_copy: bool = false, held: Array = []) -> Array:
 return lines.filter(func(line):
  return line.kind == kind and line.corp == corp and may_show(line, held, working_copy))

static func valid_line(line: Dictionary) -> bool:
 var text: String = (str(line.get("title", "")) + " " + str(line.get("text", ""))).to_lower()
 if "gulag" in text or "archipelago" in text: return false
 if "pelago" in text:
  if line.get("voice", line.get("tag")) in ["corporate", "rules"]: return false
  if "’pelago" not in text or "'pelago" in text: return false
 var sensitive: bool = line.get("kind") in REVEAL_KINDS
 for phrase in SECRET_TEXT:
  sensitive = sensitive or phrase in text
 if sensitive and line.get("tag") != "reveal": return false
 return line.get("tag") != "reveal" or line.get("trigger") == "third_card"
