class_name VisibleStateAdapter
extends RefCounted
## CAS-001 C04 (ARCH-V2-003): read-only display models for the Architecture V2 ICE components.
## Ported from Build 12's FriendlyEncounter.build_key / key_rule_lines / response_words so keys show
## the same glyph, value, badge, state and BW chip. Never mutates Game.
##
## Hidden information: a hidden subroutine's model carries only its position and state "hidden".
## Game.response_preview() includes the effects of hidden steps; they are dropped here, before any
## component sees them.

const HIDDEN_TITLE := "? HIDDEN"
const HIDDEN_RULE := "Revealed when it fires."

static func ice_models(game: Game, ctrl: EncounterController) -> Array:
	var out := []
	if game.enc.is_empty(): return out
	var biggest := biggest_hit(game)
	for i in game.enc.ice.size(): out.append(ice_model(game, ctrl, i, biggest))
	return out

static func ice_model(game: Game, ctrl: EncounterController, i: int, biggest: int) -> Dictionary:
	var ice: Dictionary = game.enc.ice[i]
	var d := game.ice_definition(ice)
	var tumbler := String(d.type) == "TUMBLER"
	var active: Array = game.active_subs(i)
	var order: Array = active.duplicate() if tumbler else range(d.subs.size())
	var keys := []
	for n in order.size(): keys.append(key_model(game, ctrl, i, int(order[n]), n, biggest, false))
	var pool := []
	if tumbler:
		# The reel column: spent or seen subroutines outside the slots; unseen ones only as a count.
		for s in d.subs.size():
			if active.has(s) or (not ice.seen[s] and not ice.broken[s]): continue
			pool.append(key_model(game, ctrl, i, s, -1, biggest, true))
	var delta: int = game.ice_str(i) - int(d.str)
	return {
		"ref": ice, "index": i, "id": String(ice.id), "name": String(d.name).to_upper(),
		"type": String(d.type), "subtype": String(d.get("subtype", "")), "black": bool(d.get("black", false)),
		"str": game.ice_str(i), "str_base": int(d.str), "str_delta": delta,
		"mood": mood(game, i), "breached": bool(game.enc.get("breached", false)),
		"passive": String(d.get("ability_text", "")), "zeroed": bool(ice.get("zeroed", false)),
		"keys": keys, "pool": pool, "hidden_pool": game.hidden_count(i) if tumbler else 0,
		"broken": ice.broken.count(true), "subs": d.subs.size(),
		"slots": int(d.get("slots", d.subs.size())) if tumbler else d.subs.size(),
	}

static func key_model(game: Game, ctrl: EncounterController, i: int, s: int, order: int, biggest: int, mini: bool) -> Dictionary:
	var ice: Dictionary = game.enc.ice[i]
	var d := game.ice_definition(ice)
	var m := {"ref": ice, "sub": s, "order": order, "mini": mini, "kind": "HIDDEN", "value": "", "badge": "",
		"extra": 0, "state": "hidden", "cost_text": "", "cost": 0, "breakable": false, "locked": false,
		"reason": "", "firing": ctrl.is_firing(ice, s), "title": HIDDEN_TITLE, "rules": [{"kind": "HIDDEN", "text": HIDDEN_RULE}],
		"place": place_label(game, i, s)}
	var hidden: bool = not ice.seen[s] and not ice.broken[s]
	if ice.broken[s]: m.state = "broken"
	if hidden:
		return m   # nothing about the effect leaves the adapter
	var effects := []
	for source in d.subs[s]: effects.append(game.effect_value(ice, source))
	var main := {}
	for e in effects:
		if e.k != "DEADLOCK": main = e; break
	var kind := "DEADLOCK" if main.is_empty() else String(main.k)
	var value := ""
	if not main.is_empty() and main.has("v"): value = ("−%d" if kind == "BW_DRAIN" else "%d") % int(main.v)
	if kind == "DEADLOCK" and Game.deadlock_steps(d.subs[s]) > 1:
		value = "%d/%d" % [ice.break_progress[s], Game.deadlock_steps(d.subs[s])]
	var state := "ready"
	if ice.broken[s]: state = "broken"
	elif not mini:
		if kind == "PULP" and main.get("curve", "") != "B" and int(main.get("v", 0)) == biggest and biggest > 0: state = "hit"
		elif ctrl.tumbled_subs(ice).has(s): state = "new"
	m.kind = kind; m.value = value; m.state = state
	if not mini and not ice.broken[s]:
		var info := ctrl.break_preview(i, s)
		m.breakable = bool(info.get("ok", false))
		m.cost = int(info.get("cost", 0))
		m.reason = String(info.get("reason", ""))
		m.cost_text = ("FREE" if m.cost == 0 else "%d BW" % m.cost) if m.breakable else "—"
		m.locked = m.reason.begins_with("LOCKED")
	if not mini:
		if Game._has_deadlock(d.subs[s]) and kind != "DEADLOCK": m.badge = "lock"
		elif m.locked: m.badge = "lock"
		elif main.get("curve", "") == "B": m.badge = "dice"
		elif main.get("curve", "") == "C": m.badge = "hammer"
		elif main.get("escalate", false): m.badge = "up"
		m.extra = maxi(0, effects.filter(func(e): return e.k != "DEADLOCK").size() - 1)
	var words := []
	var rules := []
	for source in d.subs[s]:
		var e := game.effect_value(ice, source)
		words.append(effect_text(e))
		rules.append({"kind": String(e.k), "text": effect_rule(e)})
	m.title = " + ".join(words)
	m.rules = rules
	return m

static func place_label(game: Game, i: int, s: int) -> String:
	var d := game.ice_definition(game.enc.ice[i])
	var slot: int = game.active_subs(i).find(s)
	return ("SLOT %d · S%d" % [slot + 1, s + 1]) if d.type == "TUMBLER" and slot >= 0 else "S%d" % (s + 1)

## The shared NEXT RESPONSE rail, in firing order. Broken (skipped) steps are left out; hidden steps
## carry no effect. "state" is "fired", "firing" or "waiting" during a response.
static func response_model(game: Game, ctrl: EncounterController) -> Array:
	var out := []
	if game.enc.is_empty(): return out
	var steps: Array = []
	if game.phase == "RESPONSE":
		for f in ctrl.fired: steps.append({"ref": f.ref, "sub": f.sub, "done": true})
		for st in game.response_queue:
			if ctrl.is_firing(st.ref, st.sub) and not steps.is_empty() and is_same(steps[-1].ref, st.ref) and steps[-1].sub == st.sub: continue
			steps.append({"ref": st.ref, "sub": st.sub, "done": false})
	else:
		for st in game.response_preview():
			if st.skipped: continue
			steps.append({"ref": game.enc.ice[st.ice], "sub": st.sub, "done": false})
	var biggest := biggest_hit(game)
	for st in steps:
		var i := ctrl.ice_index(st.ref)
		if i < 0: continue
		var key := key_model(game, ctrl, i, st.sub, -1, biggest, false)
		var state := "waiting"
		if ctrl.is_firing(st.ref, st.sub): state = "firing"
		elif st.done: state = "fired"
		out.append({"ref": st.ref, "sub": st.sub, "ice_name": String(game.ice_definition(st.ref).name).to_upper(),
			"kind": key.kind, "value": key.value, "badge": key.badge, "extra": key.extra,
			"hidden": key.kind == "HIDDEN", "title": key.title, "state": state})
	return out

static func biggest_hit(game: Game) -> int:
	var biggest := 0
	for step in game.response_preview():
		if step.skipped or step.hidden: continue
		for source in step.effects:
			var e := game.effect_value(game.enc.ice[step.ice], source)
			if e.k == "PULP": biggest = maxi(biggest, int(e.get("v", 0)))
	return biggest

## Portrait mood. CORE_LOOP: FORM-001 (rules state). Mapped to the three painted moods.
static func mood(game: Game, i: int) -> String:
	if game.enc.get("breached", false): return "wary"
	if Game.CORE_LOOP: return game.ice_form(i).to_lower()
	if game.strikes >= 2 or game.ice_definition(game.enc.ice[i]).get("black", false): return "lethal"
	return "wary" if game.trace >= 20 or game.enc.ice[i].broken.has(true) else "cheery"

# ----- Words, ported unchanged from Build 12 (encounter.gd effect_text / effect_rule, main._effect_word).

static func effect_word(e: Dictionary) -> String:
	match e.k:
		"INSERT": return "INSERT %s" % e.card
		"DEADLOCK": return "DEADLOCK"
		"BW_DRAIN": return "−%d BW" % e.v
		"SHIELD_BREAK": return "SHIELD BREAK"
		"AMEND": return "AMEND +%d" % e.v
		"TRACE":
			var w := "TRACE %d" % e.v
			for rider in e.get("then", []): w += " ▸ " + effect_word(rider)
			return w
		"HARDEN": return "HARDEN +%d STR" % e.v
		"RETALIATE": return "RETALIATE %d · PULP %d" % [e.v, int(e.get("dmg", 0))]
		_: return "%s %d" % [e.k, e.get("v", 0)]

static func effect_text(e: Dictionary) -> String:
	if e.k == "DEADLOCK": return "DEADLOCK" + (" ×%d" % e.v if e.get("v", 1) > 1 else "")
	if e.get("curve", "") == "B": return "PULP %d · RANDOM" % e.v
	if e.k == "BW_DRAIN": return "−%d BW next turn" % e.v
	if e.k == "DISCARD": return "DISCARD %d next turn" % e.v + (" ↑" if e.get("escalate", false) else "")
	if e.k == "INSERT": return "INSERT %d %s → %s" % [e.v, e.card, e.to]
	return effect_word(e) + (" ↑" if e.get("escalate", false) else "")

static func effect_rule(e: Dictionary) -> String:
	var v := int(e.get("v", 0))
	var t := ""
	match String(e.k):
		"PULP": t = "Lose %d VITAE (SHIELD blocks)." % v
		"TRACE": t = "Gain %d TRACE." % v
		"DEADLOCK": t = "Blocks BREACH until broken."
		"DISCARD": t = "Discard %d card%s at the start of your next turn." % [v, "" if v == 1 else "s"]
		"INSERT": t = "Put %d %s into your %s." % [v, e.get("card", ""), String(e.get("to", "draw pile")).replace("_", " ")]
		"BW_DRAIN": t = "You have %d less BW next turn." % v
		"CORTEX": t = "Gain %d CORTEX (−1 DRAW each)." % v
		"FORGET": t = "%d random non-CACHED card%s in your hand go to the bottom of your draw pile." % [v, "" if v == 1 else "s"]
		"HARDEN": t = "HARDEN: this ICE gains %d STR for the rest of the encounter." % v
		"SHIELD_BREAK": t = "SHIELD BREAK: your SHIELD drops to 0 when this fires, so PULP after it hits in full."
		"RETALIATE": t = "RETALIATE: PULP %d for each subroutine already broken on this ICE (now PULP %d)." % [v, int(e.get("dmg", 0))]
		"AMEND": t = "AMEND: this response, the ICE to its right deals +%d on each of its PULP subroutines." % v
		_: t = effect_word(e)
	if e.k == "TRACE" and not e.get("then", []).is_empty():
		var riders := []
		for r in e.then: riders.append(effect_word(r))
		t += " If any of this TRACE lands (not stopped by JAMMER, GHOST SIGNAL or PROXY CHAIN), also: %s." % ", ".join(riders)
	if e.get("curve", "") == "B": t += " Random roll."
	if e.get("curve", "") == "C": t += " Hammer curve."
	if e.get("escalate", false): t += " Grows each response."
	return t

## ICE type and STR explanations for the hover panel (REDLINE_ICE_RULES_BIBLE wording, shortened).
const TYPE_RULES := {
	"FORTRESS": "FORTRESS: every subroutine fires each Corporation Response, left to right. FORTRESSES hit hard.",
	"TUMBLER": "TUMBLER: only the subroutines in its slots fire; it rotates one step at the start of each of your turns after the first. The rest wait face-down in the reel.",
	"VOID": "VOID ICE: subroutines start face-down. Response 1 fires subroutine 1, then 1–2, then 1–3, revealing each as it first fires. Hidden subroutines can't be broken.",
}
