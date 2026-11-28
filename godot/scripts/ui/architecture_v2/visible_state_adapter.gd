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
		## UI-TYPO-002 LETHAL lens: the ICE has turned LETHAL (FORM-001); not Black ICE's look-only form.
		"lethal": bool(ice.get("lethal", false)),
		"passive": String(d.get("ability_text", "")), "zeroed": bool(ice.get("zeroed", false)),
		"keys": keys, "pool": pool, "hidden_pool": game.hidden_count(i) if tumbler else 0,
		"broken": ice.broken.count(true), "subs": d.subs.size(),
		"slots": int(d.get("slots", d.subs.size())) if tumbler else d.subs.size(),
		"virus": virus_model(ice),
	}

## I10 (Core Rules §5.4 strains): virus counters on an ICE, in a fixed strain order.
const STRAIN_RULE := {
	"ROT": "−1 STR each (minimum 0).",
	"SCRAMBLE": "This ICE's PULP −1 each when it acts.",
	"BLIND": "This ICE's TRACE −1 each when it acts.",
	"LEECH": "Extract 1 CRED each at the start of your turn.",
	"WORM": "On your turn, remove 2 WORM to break 1 subroutine on this ICE (no Icepick, no BW).",
}
static func virus_model(ice: Dictionary) -> Array:
	var out := []
	var v: Dictionary = ice.get("virus", {})
	for st in ["ROT", "SCRAMBLE", "BLIND", "LEECH", "WORM"]:
		if int(v.get(st, 0)) > 0: out.append({"strain": st, "n": int(v[st]), "rule": STRAIN_RULE[st]})
	for st in v:
		if not STRAIN_RULE.has(st) and int(v[st]) > 0: out.append({"strain": String(st), "n": int(v[st]), "rule": ""})
	return out

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
		var breached: bool = game.enc.get("breached", false)
		for st in game.response_preview():
			if st.skipped: continue
			# After a BREACH the rail previews the parting shot: no DEADLOCKs, no hidden steps (BREACH-001).
			if breached and (st.hidden or game._has_deadlock(st.effects)): continue
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
			"ice_type": String(game.ice_definition(st.ref).type),
			"kind": key.kind, "value": key.value, "badge": key.badge, "extra": key.extra,
			"hidden": key.kind == "HIDDEN", "title": key.title, "state": state})
	return out

## PULP the next Corporation Response will deal from subroutines the Rustler can see (hidden steps
## are not counted, so the readout discloses nothing). Before SHIELD.
static func incoming_pulp(game: Game) -> int:
	var total := 0
	if game.enc.is_empty(): return 0
	for step in game.response_preview():
		if step.skipped or step.hidden: continue
		for source in step.effects:
			var e := game.effect_value(game.enc.ice[step.ice], source)
			if e.k == "PULP": total += int(e.get("v", 0))
	return total

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

## CAS-001 C11 (ARCH-V2-004, Batch 2): a card's display model. `where` is "hand" (playability comes
## from Game.can_play) or "pick" (a choice candidate; always selectable). Read-only.
static func card_model(game: Game, c: Dictionary, where: String = "hand") -> Dictionary:
	## CSA-04e: static fields come from the Inspector content contract (CardDB.inspector_model), built
	## from the canonical record; only live state (playability, the engine's current text) is added here.
	var id := String(c.id)
	var im := CardDB.inspector_model(id)
	var play := game.can_play(int(c.uid)) if where == "hand" else {"ok": true, "reason": ""}
	return {"uid": int(c.uid), "id": id, "name": String(im.name), "type": String(im.type), "classification": String(im.classification),
		"tags": im.tags, "bw": int(im.costs.bw), "cred": int(im.costs.cred), "trace": int(im.costs.trace),
		"text": game.card_text(id) if game.has_method("card_text") else String(im.rules),
		"target": bool(CardDB.def(id).get("target", false)), "playable": bool(play.get("ok", false)), "reason": String(play.get("reason", "")),
		"art": String(im.art),
		"flavor": String(im.flavour),   # UI-INSPECTOR-001: subordinate flavour line
		"cached": bool(c.get("cached", false)), "cache_turns": int(c.get("cache_turns", 0))}

## ARCH-V2-005 header slots. Display models only; nothing here changes Game.
## PROTOCOLs deployed this Node sit on the RACK (Core Rules §3: "Stays active for the whole Node").
static func protocol_models(game: Game) -> Array:
	var out := []
	for c in game.rack:
		var m := card_model(game, c, "rack")
		m["kind"] = "PROTOCOL"
		out.append(m)
	return out

## CAPS (UPL-001: 3 slots, single-use, 0 BW, your turn only). CAPS-TEST-001: Game.caps holds [{uid, id}];
## names and text come from CardDB.CAPS; art is the designer's vial (assets/architecture_v2/caps/).
static func cap_models(game: Game) -> Array:
	var out := []
	for c in game.caps:
		var id := String(c.get("id", ""))
		var d: Dictionary = CardDB.CAPS.get(id, {})
		out.append({"uid": int(c.get("uid", -1)), "id": id, "name": String(d.get("name", id.replace("_", " "))), "kind": "CAP",
			"text": String(d.get("text", "")), "target": bool(d.get("target", false)),
			"usable": game.phase == "PLAYER" and not game.enc.is_empty(),
			"art": "res://assets/architecture_v2/caps/%s.png" % id})
	return out

## ARCH-V2-006c: the hostile reveal as 0..1, from TRACE and strikes (the ADP bleed curve; Friendly 0,
## Cracking 20%–60% from TRACE 20 to 39, strike 1 counts as Cracking, Mask off (2+ strikes) 100%).
static func hostile_reveal(game: Game) -> float:
	if game.strikes >= 2: return 1.0
	if game.strikes == 0 and game.trace < 20: return 0.0
	return AtomicDecoPunk.reveal(AtomicDecoPunk.target(game.trace, game.strikes, false))

## ARCH-V2-006b: Ghostware for the reel, ORIGIN first (as the prototype's rail).
static func ghostware_models(game: Game) -> Array:
	var out := []
	var r: Dictionary = CardDB.RUSTLERS.get(game.rustler, {})
	if not r.is_empty():
		out.append(_ghost(String(r.origin), String(r.origin_text), true))
	for id in game.ghostware:
		out.append(_ghost(String(id).replace("_", " "), "", false))
	return out

static func _ghost(n: String, text: String, origin: bool) -> Dictionary:
	var key := n.to_upper().replace(" ", "_").replace("'", "").replace("’", "")
	return {"name": n, "text": text, "origin": origin, "art": "res://assets/concept/ghostware/GW_%s.png" % key}

## ARCH-V2-006g: where the run is, for the eye's hover.
static func place_line(game: Game) -> String:
	var n: Dictionary = game.node
	var tier := String(n.get("tier", "T1")).replace("T", "TIER ")
	var layers: Array = n.get("layers", [])
	var lay := " · LAYER %d / %d" % [game.layer + 1, layers.size()] if layers.size() > 0 else ""
	return "%s · %s · NODE %s %s%s" % [game.corporation, tier, String(n.get("id", "?")), String(n.get("name", "")), lay]

## PT11-UI / R03: what the next response deals, or after a BREACH what the parting shot deals at
## END TURN (DEADLOCKs never fire in the parting shot). Visible steps only. PULP includes RETALIATE.
static func incoming(game: Game) -> Dictionary:
	var out := {"pulp": 0, "trace": 0, "parting": bool(game.enc.get("breached", false))}
	if game.enc.is_empty(): return out
	for step in game.response_preview():
		if step.skipped or step.hidden: continue
		if out.parting and game._has_deadlock(step.effects): continue
		for source in step.effects:
			var e := game.effect_value(game.enc.ice[step.ice], source)
			if e.k == "PULP": out.pulp += int(e.get("v", 0))
			elif e.k == "RETALIATE": out.pulp += int(e.get("dmg", 0))
			elif e.k == "TRACE": out.trace += int(e.get("v", 0))
	return out

## ARCH-V2-006d: the ledger's values.
static func ledger(game: Game) -> Dictionary:
	var layers: Array = game.node.get("layers", [])
	return {"layers": maxi(1, layers.size()), "current": game.layer, "cred": game.cred,
		"reserve": int(game.enc.get("reserve", 0)) if not game.enc.is_empty() else 0}

## C09: a pile to view. The draw pile is shown sorted by name so its order is never disclosed;
## discard and burned show in the order they arrived (newest last).
static func pile_models(game: Game, pile: String) -> Array:
	var src: Array = {"deck": game.draw_pile, "discard": game.discard, "burned": game.burned}.get(pile, [])
	var out := src.map(func(c): return card_model(game, c, "pile"))
	if pile == "deck": out.sort_custom(func(a, b): return String(a.name) < String(b.name))
	return out

