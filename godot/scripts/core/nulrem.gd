class_name NulRem
extends RefCounted
## NUL/REM's dialogue picker. Lines come from data/nulrem_lines.json (exported from the Bible by tools/export_nulrem.py).
## Trigger table rules: speak chance per trigger (the rest is silence), shuffled pools with repeat suppression.

const SPEAK := {
	"EV-01": 1.0, "EV-02": 1.0, "EV-03": 1.0, "EV-04": 1.0, "EV-05": 0.6, "EV-06": 0.35, "EV-07": 0.5,
	"EV-08": 0.8, "EV-09": 0.9, "EV-10": 0.8, "EV-11": 1.0, "EV-12": 0.9, "EV-13": 1.0, "EV-14": 1.0,
	"EV-15": 1.0, "EV-16": 1.0, "EV-17": 1.0, "EV-18": 1.0, "EV-21": 0.5, "EV-26": 0.8, "EV-27": 0.5,
	"EV-28": 1.0, "EV-35": 1.0, "EV-37": 1.0, "EV-39": 1.0,
}

var lines: Array = []
var heard := {}
var recent: Array = []
var rng := RandomNumberGenerator.new()
var rustler := "Generalist"
var corp := "HALCYON"

func _init() -> void:
	rng.randomize()
	var f := FileAccess.open("res://data/nulrem_lines.json", FileAccess.READ)
	if f:
		var data = JSON.parse_string(f.get_as_text())
		if data is Dictionary:
			lines = data.get("lines", [])

func pick(trigger: String, ctx: Dictionary = {}) -> Dictionary:
	if rng.randf() > SPEAK.get(trigger, 0.5):
		return {}
	var pool := []
	for l in lines:
		if l.trigger != trigger:
			continue
		var t: Dictionary = l.tags
		if t.has("rustler") and t.rustler != rustler:
			continue
		if t.has("after") and t.after != ctx.get("after", ""):
			continue
		if t.has("corp") and not (t.corp as Array).has(ctx.get("corp", corp)):
			continue
		if t.has("bloat") and t.bloat != ctx.get("bloat", ""):
			continue
		if t.has("rest") and t.rest != ctx.get("rest", "SAFEHOUSE"):
			continue
		if t.has("cause") and t.cause != ctx.get("cause", ""):
			continue
		if t.has("requires") and not heard.has(t.requires):
			continue
		if t.get("first_win", false) or t.get("deeper", false) or t.get("bootleg", false):
			continue
		pool.append(l)
	if pool.is_empty():
		return {}
	var fresh := []
	for l in pool:
		if not recent.has(l.id):
			fresh.append(l)
	if fresh.is_empty():
		fresh = pool
	var chosen: Dictionary = fresh[rng.randi_range(0, fresh.size() - 1)]
	heard[chosen.id.split(" ")[0]] = true
	recent.append(chosen.id)
	if recent.size() > 40:
		recent.pop_front()
	return chosen
