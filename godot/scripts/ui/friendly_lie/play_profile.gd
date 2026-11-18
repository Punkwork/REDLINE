class_name PlayProfile
extends RefCounted

const PATH := "user://redline_stats.json"
const AD := {
 "HALCYON": ["A home that knows you", "We noticed you favour %s. HALCYON Welcome™ is ready when you are."],
 "IRONWATCH": ["A familiar beat", "You keep returning to %s. Trusted Resident™ gets to know your routine."],
 "LUCIDA": ["A little quiet tonight", "Still thinking about %s? Rest Easy™ can take it from here."]
}

var card_plays := {}
var broken_ice := {}
var traces := {}
var longest_hover := 0.0
var encounter: Dictionary
var run_finished := false

func reset(game: Game) -> void:
 card_plays = game.played.duplicate()
 broken_ice = game.broken_ice.duplicate()
 traces = game.strikes_by_corp.duplicate()
 longest_hover = 0.0
 encounter = {}
 run_finished = false

func observe(game: Game, enabled: bool) -> void:
 var finished := game.phase in ["DEAD", "SLICE_DONE"] and not run_finished
 var changed := not encounter.is_empty() and (not is_same(encounter, game.enc) or game.phase in ["DEEPER", "REWARD", "DEAD"])
 if enabled and (changed or finished):
  var data := LocalRecord.read(PATH)
  for grouping in [["plays", game.played, card_plays], ["breaks", game.broken_ice, broken_ice], ["strikes", game.strikes_by_corp, traces]]:
   var counts: Dictionary = data.get(grouping[0], {})
   for key in grouping[1]:
    var delta: int = grouping[1][key] - int(grouping[2].get(key, 0))
    if delta > 0: counts[key] = int(counts.get(key, 0)) + delta
   data[grouping[0]] = counts
  data.runs = int(data.get("runs", 0)) + int(finished)
  data.hover = maxf(float(data.get("hover", 0)), longest_hover)
  if not LocalRecord.write(PATH, data): return
 if changed or finished:
  card_plays = game.played.duplicate()
  broken_ice = game.broken_ice.duplicate()
  traces = game.strikes_by_corp.duplicate()
  longest_hover = 0.0
 if finished: run_finished = true
 encounter = {} if game.phase in ["DEEPER", "REWARD", "DEAD"] else game.enc

static func most(counts: Dictionary) -> String:
 var best := ""
 var highest := 0
 for key in counts:
  if int(counts[key]) > highest:
   best = key
   highest = int(counts[key])
 return best

static func ad(corp: String, enabled: bool) -> Dictionary:
 if not enabled or not AD.has(corp): return {}
 var data := LocalRecord.read(PATH)
 var types := {}
 for id in data.get("plays", {}):
  if not CardDB.DEFS.has(id): continue
  var kind: String = CardDB.def(id).type
  types[kind] = int(types.get(kind, 0)) + int(data.plays[id])
 var feature := most(types)
 if feature.is_empty(): return {}
 var lines: Array = AD[corp]
 var text: String = lines[1] % feature.to_lower()
 if int(data.get("runs", 0)) >= 2:
  var ice := most(data.get("breaks", {}))
  var watched := most(data.get("strikes", {}))
  if not ice.is_empty() and IceDB.DEFS.has(ice): text += " We remember %s, too." % IceDB.def(ice).name
  if not watched.is_empty(): text += " We can help you feel at home with %s." % watched
  if float(data.get("hover", 0)) >= 4: text += " Take your time. We can wait another %d seconds." % roundi(data.hover)
 return {"title": lines[0], "text": text}
