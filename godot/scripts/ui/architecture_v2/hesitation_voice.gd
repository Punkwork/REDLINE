class_name HesitationVoice
extends RefCounted
## ADP-2b (approved 2026-11-17; UI Design Bible Phase 2): hovering one card for 4 s prompts a line
## from the ICE with the highest mood. 20 s cooldown, at most once per turn, disabled while dragging,
## Rustler's turn only. Flavour only: reads visible models and the approved copy (AdpCopy, Phase 2
## Copy Pack §2), never Game. Ported from Build 12's FriendlyEncounter.update_hesitation.
## The line shows in that ICE's speech bubble for `seconds` (ARCH-V2-003r: momentary, 1–2 s).

const THRESHOLD := 4.0
const COOLDOWN := 20.0
const MOODS := ["cheery", "wary", "lethal"]

var seconds := 2.0
var hover_time := 0.0
var hover_uid := -1
var cooldown_until := 0.0
var fired_turn := -1
var _index := {}

## Call every frame. `models` are VisibleStateAdapter ICE models (id, mood). Returns {} or
## {"ice": index into models, "text": line}.
func tick(delta: float, now: float, hovered_uid: int, dragging: bool, phase: String, turn: int, corp: String, models: Array) -> Dictionary:
	var eligible := phase == "PLAYER" and not dragging and hovered_uid >= 0
	if not eligible or hovered_uid != hover_uid:
		hover_time = 0.0
		hover_uid = hovered_uid if eligible else -1
	if not eligible: return {}
	hover_time += delta
	if hover_time < THRESHOLD or now < cooldown_until or fired_turn == turn: return {}
	var selected := -1
	var highest := -1
	for i in models.size():
		var rank := MOODS.find(mood_of(models[i]))
		if rank >= 0 and rank >= highest:
			highest = rank
			selected = i
	if selected < 0: return {}
	var id := String(models[selected].id)
	var mood := mood_of(models[selected])
	var key := id + mood
	var n: int = _index.get(key, 0)
	var line := AdpCopy.pick("hesitation", corp, n, {"ice": id if corp == "HALCYON" else "", "mood": mood})
	if line.is_empty(): return {}
	_index[key] = n + 1
	fired_turn = turn
	cooldown_until = now + COOLDOWN
	return {"ice": selected, "text": String(line.text)}

static func mood_of(m: Dictionary) -> String:
	var mood := String(m.get("mood", "cheery"))
	return "lethal" if mood == "lethal" else ("wary" if mood in ["wary", "knocked_out"] else "cheery")
