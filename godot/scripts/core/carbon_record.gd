class_name CarbonRecord
extends RefCounted

const PATH := "user://carbon.json"
const ISLAND_INDEX := {
 "HALCYON": [0, 1, 2, 0, 0],
 "IRONWATCH": [0, 1, 2, 0, 1],
 "LUCIDA": [0, 1, 2, 2, 0]
}

static func entries() -> Array:
 var items = LocalRecord.read(PATH).get("entries", [])
 return items if items is Array else []

static func append_defeat(run_id: String, game: Game) -> Dictionary:
 var items := entries()
 for previous in items:
  if previous.get("run_id") == run_id: return previous
 var corp := game.corporation if ISLAND_INDEX.has(game.corporation) else "HALCYON"
 var issue := 1 if items.is_empty() else int(items.back().issue) + 1
 var index := posmod(issue - 1, 5)
 var entry := {
  "run_id": run_id,
  "rustler": game.rustler,
  "issue": issue,
  "corp": corp,
  "node": game.node.get("name", ""),
  "date": Time.get_date_string_from_system(),
  "island": ArchCopy.pool("island", corp, true)[ISLAND_INDEX[corp][index]].text,
  "relocation_id": ArchCopy.pool("relocation", corp)[index].id
 }
 items.append(entry)
 entry["saved"] = LocalRecord.write(PATH, {"entries": items.duplicate(true)})
 return entry

static func relocation(entry: Dictionary) -> String:
 for line in ArchCopy.pool("relocation", entry.corp):
  if line.id == entry.relocation_id:
   return line.text.replace("[NAME]", entry.rustler)
 return ""
