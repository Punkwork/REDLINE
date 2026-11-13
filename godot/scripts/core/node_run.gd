extends RefCounted
## Rules engine for one ICE Node: its layers, turns, cards, Icepicks, the Corporation Response,
## TRACE strikes, extraction, BREACH and rewards. No UI code lives here, so it can be tested headless.
##
## Rules follow docs/REDLINE_CORE_RULES.md. Card and ICE values come from res://data.
##
## Typical flow:
##     node.setup(db, run, "training", layers)
##     node.start()                      # phase "ready_rig" or "player"
##     node.play_card(uid, target)       # during phase "player"
##     node.boost(icepick_uid) / node.break_subroutine(icepick_uid, ice_index, sub_index)
##     node.end_turn()                   # Corporation Response, or BREACH -> "layer_choice" or "reward"
##     node.go_deeper() / node.leave_node()   # during "layer_choice"; leaving -> "reward"
##     node.choose_reward(card_id)       # once per Node, at the end (CORE-010) -> "node_complete"

signal changed
signal logged(text: String)

const PHASE_READY_RIG := "ready_rig"
const PHASE_PLAYER := "player"
const PHASE_REWARD := "reward"
const PHASE_LAYER_CHOICE := "layer_choice"
const PHASE_NODE_COMPLETE := "node_complete"
const PHASE_DEFEAT := "defeat"

var db
var run
var corporation_id := ""
var layers: Array = []          ## [{ "ice": [ids], "cred_reserve": int }]
var layer_index := 0
var phase := ""
var turn := 0

# Card zones (arrays of card instances {"uid","id",...}).
var draw_pile: Array = []
var hand: Array = []
var discard_pile: Array = []
var installed: Array = []       ## PROGRAMs in play
var rack: Array = []            ## PROTOCOLs in play
var burned: Array = []
var cached := {}                ## uid -> true

# Per-turn and per-encounter state.
var bw := 0
var shield := 0
var ram_used := 0
var ice_list: Array = []        ## [{ "id", "def", "str_mod", "broken": [bool], "virus": {strain: n} }]
var reserve := 0
var reserve_start := 0
var full_extraction_paid := false
var boosts := {}                ## icepick uid -> extra STR this encounter
var free_break_used := {}       ## icepick uid -> true this turn
var once_per_encounter_used := {}  ## "uid:key" -> true
var trace_reduce_next := 0      ## amount to remove from the first TRACE in the next Corporation Response
var trace_gained_this_encounter := false
var trace_gained_this_node := false
var lockdown := false
var reward_options: Array = []
var layers_cleared := 0         ## sets the card reward's rarity odds (CORE-010)
var node_fully_cleared := false
var log_lines: Array[String] = []

const MAX_LOG := 200


# ------------------------------------------------------------------ setup

func setup(game_data, run_state, p_corporation_id: String, p_layers: Array) -> void:
	db = game_data
	run = run_state
	corporation_id = p_corporation_id
	layers = p_layers


## Builds the layer list for a corporation that defines fixed layers (e.g. the Training Node).
static func layers_for(game_data, corp_id: String) -> Array:
	var out: Array = []
	for layer in game_data.corporations[corp_id].get("layers", []):
		out.append({"ice": layer["ice"], "cred_reserve": int(layer.get("cred_reserve", 15))})
	return out


func start() -> void:
	draw_pile = run.deck.duplicate()
	_shuffle(draw_pile)
	hand.clear()
	discard_pile.clear()
	installed.clear()
	rack.clear()
	burned.clear()
	cached.clear()
	ram_used = 0
	lockdown = false
	trace_gained_this_node = false
	layer_index = 0
	layers_cleared = 0
	node_fully_cleared = false
	_log("== Entering Node (%s) ==" % corporation_id)
	if run.has_ghostware("ready_rig") and not ready_rig_options().is_empty():
		phase = PHASE_READY_RIG
		_log("READY RIG: choose a Program to start installed.")
		changed.emit()
	else:
		_start_layer(0)


func ready_rig_options() -> Array:
	return draw_pile.filter(func(inst): return card_def(inst)["type"] == "PROGRAM")


## READY RIG (Generalist ORIGIN): install one Program from the deck for free. uid -1 skips.
func ready_rig_choose(uid: int) -> void:
	if phase != PHASE_READY_RIG:
		return
	if uid != -1:
		var inst = _find(draw_pile, uid)
		if inst != null:
			draw_pile.erase(inst)
			installed.append(inst)
			ram_used += int(card_def(inst).get("ram", 0))
			_log("READY RIG installs %s." % card_name(inst))
	_start_layer(0)


func _start_layer(index: int) -> void:
	layer_index = index
	var layer: Dictionary = layers[index]
	ice_list.clear()
	for ice_id in layer["ice"]:
		var def: Dictionary = db.ice[ice_id]
		var broken: Array = []
		broken.resize(def["subroutines"].size())
		broken.fill(false)
		ice_list.append({"id": ice_id, "def": def, "str_mod": 0, "broken": broken, "virus": {}})
	reserve = int(layer.get("cred_reserve", 15))
	reserve_start = reserve
	full_extraction_paid = false
	boosts.clear()
	once_per_encounter_used.clear()
	trace_gained_this_encounter = false
	turn = 0
	if run.has_ghostware("patient_zero"):
		for i in ice_list.size():
			_infect(i, "rot", 1)
	_log("-- Layer %d of %d: %s (CRED reserve %d) --" % [index + 1, layers.size(),
			", ".join(ice_list.map(func(x): return x["def"]["name"])), reserve])
	_start_turn()


func _start_turn() -> void:
	turn += 1
	phase = PHASE_PLAYER
	bw = int(db.rules["turn"]["bw_per_turn"])
	shield = 0
	free_break_used.clear()
	if run.has_ghostware("redliner") and run.trace >= 20:
		bw += 1
		_log("REDLINER: +1 BW.")
	for inst in installed + rack:
		_apply_effects(card_def(inst)["effects"], -1, inst, "start_of_turn")
	_start_of_turn_viruses()
	var n: int = max(1, run.draw_size - run.void_counters)
	_draw(n)
	_log("Turn %d: %d BW, drew %d." % [turn, bw, n])
	changed.emit()


# ------------------------------------------------------------------ queries

func card_def(inst) -> Dictionary:
	return db.cards[inst["id"]]


func card_name(inst) -> String:
	return card_def(inst)["name"]


func ice_str(ice_index: int) -> int:
	var ice: Dictionary = ice_list[ice_index]
	var value: int = int(ice["def"]["str"]) + int(ice["str_mod"]) - int(ice["virus"].get("rot", 0))
	var floor_value := 0
	var ability = ice["def"].get("ability", {})
	for e in ability.get("effects", []):
		if e["op"] == "str_floor":
			floor_value = int(e["n"])
	return max(floor_value, value)


func icepick_str(inst) -> int:
	var ip: Dictionary = card_def(inst)["icepick"]
	var bonus := 0
	if run.has_ghostware("burnout_chip"):
		bonus += 2
	return int(ip["str"]) + int(boosts.get(inst["uid"], 0)) + bonus


func installed_icepicks() -> Array:
	return installed.filter(func(inst): return card_def(inst).has("icepick"))


func is_breached() -> bool:
	for ice in ice_list:
		var subs: Array = ice["def"]["subroutines"]
		for s in subs.size():
			if ice["broken"][s]:
				continue
			for e in subs[s]["effects"]:
				if e["op"] == "deadlock":
					return false
	return true


func can_play(inst) -> Dictionary:
	if phase != PHASE_PLAYER:
		return {"ok": false, "reason": "Not your turn."}
	if not hand.has(inst):
		return {"ok": false, "reason": "Not in hand."}
	var def := card_def(inst)
	if def["cost_bw"] == null:
		return {"ok": false, "reason": "This card can't be played."}
	var cost := play_cost(inst)
	if cost > bw:
		return {"ok": false, "reason": "Needs %d BW." % cost}
	if def["type"] == "PROGRAM" and ram_used + int(def.get("ram", 0)) > run.ram:
		return {"ok": false, "reason": "Not enough RAM."}
	return {"ok": true, "reason": ""}


func play_cost(inst) -> int:
	var def := card_def(inst)
	if def["cost_bw"] == null:
		return 0
	return int(def["cost_bw"])


## What a break with this Icepick on this subroutine would cost, or why it can't happen.
func break_check(icepick_uid: int, ice_index: int, sub_index: int) -> Dictionary:
	if phase != PHASE_PLAYER:
		return {"ok": false, "reason": "Not your turn."}
	var inst = _find(installed, icepick_uid)
	if inst == null or not card_def(inst).has("icepick"):
		return {"ok": false, "reason": "No such Icepick."}
	if ice_index < 0 or ice_index >= ice_list.size():
		return {"ok": false, "reason": "No such ICE."}
	var ice: Dictionary = ice_list[ice_index]
	if sub_index < 0 or sub_index >= ice["broken"].size() or ice["broken"][sub_index]:
		return {"ok": false, "reason": "Already broken."}
	var ip: Dictionary = card_def(inst)["icepick"]
	if ip["ice_type"] != "ANY" and ip["ice_type"] != ice["def"]["type"]:
		return {"ok": false, "reason": "%s can't break %s." % [card_name(inst), ice["def"]["type"]]}
	var need := ice_str(ice_index)
	var have := icepick_str(inst)
	if have < need:
		return {"ok": false, "reason": "STR %d < ICE STR %d." % [have, need], "boosts_needed": _boosts_needed(inst, need)}
	var cost := int(ip["break_bw"])
	if ip.get("free_first_break_each_turn", false) and not free_break_used.get(icepick_uid, false):
		cost = 0
	if cost > bw:
		return {"ok": false, "reason": "Needs %d BW." % cost}
	return {"ok": true, "cost": cost, "reason": ""}


func _boosts_needed(inst, need: int) -> int:
	var ip: Dictionary = card_def(inst)["icepick"]
	var per := int(ip["boost_str"])
	var missing := need - icepick_str(inst)
	return int(ceil(float(missing) / per))


## Total BW to boost (if needed) and break this subroutine, for the UI. -1 if impossible.
func total_break_cost(icepick_uid: int, ice_index: int, sub_index: int) -> int:
	var inst = _find(installed, icepick_uid)
	if inst == null:
		return -1
	var ip: Dictionary = card_def(inst)["icepick"]
	var ice: Dictionary = ice_list[ice_index]
	if ice["broken"][sub_index]:
		return -1
	if ip["ice_type"] != "ANY" and ip["ice_type"] != ice["def"]["type"]:
		return -1
	var need := ice_str(ice_index)
	var boost_cost := 0
	if icepick_str(inst) < need:
		boost_cost = _boosts_needed(inst, need) * int(ip["boost_bw"])
	var cost := int(ip["break_bw"])
	if ip.get("free_first_break_each_turn", false) and not free_break_used.get(icepick_uid, false):
		cost = 0
	return boost_cost + cost


# ------------------------------------------------------------------ player actions

func play_card(uid: int, target_ice: int = -1) -> bool:
	var inst = _find(hand, uid)
	if inst == null:
		return false
	var check := can_play(inst)
	if not check["ok"]:
		_log("Can't play %s: %s" % [card_name(inst), check["reason"]])
		return false
	var def := card_def(inst)
	if target_ice < 0:
		target_ice = ice_list.size() - 1   # default: the main ICE (right-most)
	bw -= play_cost(inst)
	hand.erase(inst)
	cached.erase(uid)
	match def["type"]:
		"PROGRAM":
			installed.append(inst)
			ram_used += int(def.get("ram", 0))
			_log("Installed %s." % def["name"])
			_apply_effects(def["effects"], target_ice, inst, "installed")
			_trigger_ice_abilities("player_installs", def)
		"PROTOCOL":
			rack.append(inst)
			_log("Deployed %s." % def["name"])
		"BLOATWARE":
			burned.append(inst)
			_log("Cleared %s." % def["name"])
		_:
			_log("Played %s." % def["name"])
			_apply_effects(def["effects"], target_ice, inst, "")
			if def.get("burned_after_use", false):
				burned.append(inst)
			else:
				discard_pile.append(inst)
	if int(def.get("trace", 0)) > 0:
		add_trace(int(def["trace"]), false)
	_trigger_ice_abilities("player_plays_tag", def)
	_check_defeat()
	changed.emit()
	return true


func unload(uid: int) -> void:
	var inst = _find(installed, uid)
	if inst == null or phase != PHASE_PLAYER:
		return
	installed.erase(inst)
	ram_used -= int(card_def(inst).get("ram", 0))
	boosts.erase(uid)
	discard_pile.append(inst)
	_log("Unloaded %s." % card_name(inst))
	changed.emit()


func boost(icepick_uid: int) -> bool:
	var inst = _find(installed, icepick_uid)
	if inst == null or phase != PHASE_PLAYER or not card_def(inst).has("icepick"):
		return false
	var ip: Dictionary = card_def(inst)["icepick"]
	var cost := int(ip["boost_bw"])
	if cost > bw:
		_log("Boost needs %d BW." % cost)
		return false
	bw -= cost
	boosts[icepick_uid] = int(boosts.get(icepick_uid, 0)) + int(ip["boost_str"])
	_log("Boosted %s to STR %d." % [card_name(inst), icepick_str(inst)])
	changed.emit()
	return true


## Boosts as many times as needed, then breaks. Returns false (and changes nothing) if unaffordable.
func boost_and_break(icepick_uid: int, ice_index: int, sub_index: int) -> bool:
	var total := total_break_cost(icepick_uid, ice_index, sub_index)
	if total < 0 or total > bw or phase != PHASE_PLAYER:
		return false
	var inst = _find(installed, icepick_uid)
	while icepick_str(inst) < ice_str(ice_index):
		boost(icepick_uid)
	return break_subroutine(icepick_uid, ice_index, sub_index)


func break_subroutine(icepick_uid: int, ice_index: int, sub_index: int) -> bool:
	var check := break_check(icepick_uid, ice_index, sub_index)
	if not check["ok"]:
		_log("Can't break: %s" % check["reason"])
		return false
	var inst = _find(installed, icepick_uid)
	var ip: Dictionary = card_def(inst)["icepick"]
	bw -= int(check["cost"])
	if ip.get("free_first_break_each_turn", false):
		free_break_used[icepick_uid] = true
	_mark_broken(ice_index, sub_index, card_name(inst))
	var extra := int(ip.get("subroutines_per_break", 1)) - 1
	var subs: Array = ice_list[ice_index]["broken"]
	for s in subs.size():
		if extra <= 0:
			break
		if not subs[s]:
			_mark_broken(ice_index, s, card_name(inst))
			extra -= 1
	if int(ip.get("break_trace", 0)) > 0:
		add_trace(int(ip["break_trace"]), false)
	if ip.has("on_break"):
		_apply_effects(ip["on_break"], ice_index, inst, "")
	if is_breached():
		_log("BREACH! Every DEADLOCK is broken. End your turn to skip the final Corporation Response.")
	changed.emit()
	return true


func end_turn() -> void:
	if phase != PHASE_PLAYER:
		return
	# End-of-turn effects: Extractors pay out, TRACER punishes being held.
	for inst in installed:
		var def := card_def(inst)
		if def.has("extractor"):
			_extract_for(inst)
	for inst in hand:
		if inst["id"] == "tracer":
			add_trace(3, false)
			_log("TRACER in hand: +3 TRACE.")
	if _check_defeat():
		return
	if is_breached():
		_cleanup_hand()
		_layer_cleared()
		return
	_corporation_response()
	if _check_defeat():
		return
	_cleanup_hand()
	_start_turn()


# ------------------------------------------------------------------ corporation

func _corporation_response() -> void:
	_log("-- Corporation Response --")
	for i in ice_list.size():
		var ice: Dictionary = ice_list[i]
		var subs: Array = ice["def"]["subroutines"]
		for s in subs.size():
			if ice["broken"][s]:
				continue
			_resolve_subroutine(i, s)
			if phase == PHASE_DEFEAT:
				return
	for i in ice_list.size():
		var ability = ice_list[i]["def"].get("ability", {})
		if ability.get("trigger", "") == "end_of_corp_response":
			_apply_ice_effects(ability["effects"], i)
	trace_reduce_next = 0


func _resolve_subroutine(ice_index: int, sub_index: int) -> void:
	var ice: Dictionary = ice_list[ice_index]
	var effects: Array = ice["def"]["subroutines"][sub_index]["effects"]
	var shown: Array = []
	for e in effects:
		if e["op"] != "deadlock":
			shown.append(_describe_ice_effect(e))
	if not shown.is_empty():
		_log("%s [S%d]: %s" % [ice["def"]["name"], sub_index + 1, ", ".join(shown)])
	_apply_ice_effects(effects, ice_index)


func _apply_ice_effects(effects: Array, ice_index: int) -> void:
	var ice: Dictionary = ice_list[ice_index]
	for e in effects:
		match e["op"]:
			"deadlock":
				pass
			"pulp":
				var n := int(e["n"]) + _ice_pulp_bonus(ice) - int(ice["virus"].get("scramble", 0))
				take_pulp(max(0, n))
			"trace":
				var n2 := int(e["n"]) - int(ice["virus"].get("blind", 0))
				add_trace(max(0, n2), true)
			"void":
				take_void(int(e["n"]))
			"discard":
				_discard_from_hand(int(e["n"]))
			"insert":
				_insert_bloatware(e["card"], e["dest"], int(e.get("n", 1)))
			"ice_gain_str":
				var target := ice_index
				if e["target"] != "self":
					target = _ice_index_by_id(e["target"])
				if target >= 0:
					ice_list[target]["str_mod"] += int(e["n"])
					_log("%s gains +%d STR." % [ice_list[target]["def"]["name"], int(e["n"])])
			"purge":
				ice["virus"].clear()
				_log("%s PURGEs its virus counters." % ice["def"]["name"])
			"purge_all":
				for other in ice_list:
					other["virus"].clear()
				_log("PURGE ALL: every virus counter removed.")
			_:
				_log("(Not yet implemented: ICE effect '%s')" % e["op"])
		if phase == PHASE_DEFEAT:
			return


func _ice_pulp_bonus(ice: Dictionary) -> int:
	var ability = ice["def"].get("ability", {})
	if ability.get("trigger", "") != "constant":
		return 0
	if run.trace < int(ability.get("if_trace_at_least", 0)):
		return 0
	var bonus := 0
	for e in ability.get("effects", []):
		if e["op"] == "ice_pulp_bonus":
			bonus += int(e["n"])
	return bonus


func _trigger_ice_abilities(trigger: String, card: Dictionary) -> void:
	for i in ice_list.size():
		var ability = ice_list[i]["def"].get("ability", {})
		if ability.get("trigger", "") != trigger:
			continue
		if trigger == "player_plays_tag" and not card.get("tags", []).has(ability["tag"]):
			continue
		if trigger == "player_installs" and card["type"] != ability.get("card_type", "PROGRAM"):
			continue
		_log("%s reacts: %s" % [ice_list[i]["def"]["name"], ability["text"]])
		_apply_ice_effects(ability["effects"], i)


func _describe_ice_effect(e: Dictionary) -> String:
	match e["op"]:
		"pulp", "trace", "void", "discard":
			return "%s %d" % [String(e["op"]).to_upper(), int(e["n"])]
		"insert":
			return "INSERT %s (%s)" % [db.cards[e["card"]]["name"], e["dest"]]
		"ice_gain_str":
			return "%s +%d STR" % [e["target"].to_upper(), int(e["n"])]
		_:
			return String(e["op"]).to_upper()


# ------------------------------------------------------------------ damage, TRACE, CRED

func take_pulp(n: int) -> void:
	if n <= 0:
		return
	var absorbed: int = min(shield, n)
	shield -= absorbed
	var dmg := n - absorbed
	run.vitae -= dmg
	_log("PULP %d: %d blocked, %d damage. VITAE %d." % [n, absorbed, dmg, run.vitae])
	_check_defeat()


func take_void(n: int) -> void:
	for inst in installed + rack:
		for e in card_def(inst)["effects"]:
			if e["op"] != "prevent_void" or n <= 0:
				continue
			var key := "%d:prevent_void" % inst["uid"]
			if e.get("limit", "") in ["once_per_encounter", "first_each_encounter"] and once_per_encounter_used.get(key, false):
				continue
			var prevented: int = n if str(e["n"]) == "all" else min(n, int(e["n"]))
			n -= prevented
			once_per_encounter_used[key] = true
			_log("%s prevents %d VOID." % [card_name(inst), prevented])
	if n > 0:
		run.void_counters += n
		_log("VOID %d: you now draw %d fewer card(s)." % [n, run.void_counters])


func heal(n: int) -> void:
	run.vitae = min(run.max_vitae, run.vitae + n)


## Adds (or removes, if negative) TRACE. from_corp marks TRACE from a Corporation Response.
func add_trace(n: int, from_corp: bool) -> void:
	if n == 0:
		return
	if n > 0:
		if from_corp and trace_reduce_next > 0:
			var cut: int = min(n, trace_reduce_next)
			n -= cut
			trace_reduce_next = 0
			_log("TRACE reduced by %d." % cut)
		if run.has_ghostware("low_profile"):
			n = max(0, n - 1)
		if n <= 0:
			return
		trace_gained_this_encounter = true
		trace_gained_this_node = true
	run.trace = max(0, run.trace + n)
	_log("TRACE %+d → %d/%d." % [n, run.trace, int(db.rules["trace"]["max"])])
	if run.trace >= int(db.rules["trace"]["max"]):
		_strike()


func _strike() -> void:
	run.strikes += 1
	var ladder: Array = db.rules["trace"]["strikes"]
	var step: Dictionary = ladder[min(run.strikes, ladder.size()) - 1]
	_log("!! TRACE STRIKE %d: the corporation has found you." % run.strikes)
	for e in step["effects"]:
		match e["op"]:
			"insert":
				_insert_bloatware(e["card"], e["dest"], int(e.get("n", 1)))
			"add_black_ice":
				var corp: Dictionary = db.corporations.get(corporation_id, {})
				if corp.has("black_ice"):
					var def: Dictionary = db.ice[corp["black_ice"]]
					var broken: Array = []
					broken.resize(def["subroutines"].size())
					broken.fill(false)
					ice_list.insert(0, {"id": def["id"], "def": def, "str_mod": 0, "broken": broken, "virus": {}})
					_log("%s joins the encounter." % def["name"])
				else:
					_log("(This network has no Black ICE.)")
			"lockdown":
				lockdown = true
				_log("LOCKDOWN: you can't leave this Node early.")
	run.trace = int(step["trace_after"])


func _extract_for(inst) -> void:
	var ex: Dictionary = card_def(inst)["extractor"]
	var amount := int(ex.get("cred", 0))
	if ex.has("cred_if_no_trace_this_encounter") and not trace_gained_this_encounter:
		amount = int(ex["cred_if_no_trace_this_encounter"])
	_extract(amount, card_name(inst))
	if int(ex.get("trace_per_extract", 0)) > 0:
		add_trace(int(ex["trace_per_extract"]), false)


func _extract(amount: int, source: String) -> void:
	if run.has_ghostware("money_mule"):
		amount = int(ceil(amount * 1.25))
	var got: int = min(amount, reserve)
	reserve -= got
	run.cred += got
	if got > 0:
		_log("%s extracts %d CRED (reserve %d left)." % [source, got, reserve])
	if reserve == 0 and not full_extraction_paid and reserve_start > 0:
		full_extraction_paid = true
		var bonus := int(ceil(reserve_start * float(db.rules["rewards"]["full_extraction_bonus"])))
		run.cred += bonus
		_log("Reserve emptied: +%d CRED bonus." % bonus)


# ------------------------------------------------------------------ card effects

func _apply_effects(effects: Array, target_ice: int, source, timing: String) -> void:
	for e in effects:
		if str(e.get("when", "")) != timing:
			if not (timing == "" and not e.has("when")):
				continue
		if e.has("if_trace_at_least") and run.trace < int(e["if_trace_at_least"]):
			continue
		_apply_effect(e, target_ice, source)


func _apply_effect(e: Dictionary, target_ice: int, source) -> void:
	match e["op"]:
		"shield":
			var n := int(e.get("n", 0))
			if e.has("n_per_virus_counter") and target_ice >= 0:
				n = min(int(e.get("max", 99)), _virus_total(target_ice) * int(e["n_per_virus_counter"]))
			shield += n
			_log("+%d SHIELD (%d)." % [n, shield])
		"trace":
			add_trace(int(e["n"]), false)
		"trace_set":
			run.trace = int(e["value"])
			_log("TRACE set to %d." % run.trace)
		"trace_halve":
			run.trace = run.trace / 2
			_log("TRACE halved to %d." % run.trace)
		"trace_reduce_next":
			trace_reduce_next = 999 if str(e["amount"]) == "all" else int(e["amount"])
			_log("The next TRACE in the Corporation Response will be reduced.")
		"draw":
			_draw(int(e["n"]))
		"gain_bw":
			bw += int(e["n"])
		"heal":
			heal(int(e["n"]))
		"ice_str":
			_apply_ice_str(e, target_ice)
		"ice_str_set":
			if target_ice >= 0:
				ice_list[target_ice]["str_mod"] -= ice_str(target_ice) - int(e["value"])
		"break":
			_script_break(e, target_ice)
		"extract":
			_extract(int(e["n"]), card_name(source) if source != null else "Effect")
		"infect":
			var targets: Array = range(ice_list.size()) if e.get("target", "target") == "all" else [target_ice]
			for t in targets:
				_infect(t, e["strain"], int(e["n"]))
		"double_virus":
			for strain in ice_list[target_ice]["virus"].keys():
				ice_list[target_ice]["virus"][strain] *= 2
			_log("Virus counters doubled on %s." % ice_list[target_ice]["def"]["name"])
		"ram":
			run.ram += int(e["n"])
		"prevent_void", "deadlock":
			pass   # handled passively when VOID arrives
		_:
			_log("(Not yet implemented: card effect '%s')" % e["op"])


func _apply_ice_str(e: Dictionary, target_ice: int) -> void:
	var targets: Array = []
	match str(e.get("target", "target")):
		"all", "each_ice":
			targets = range(ice_list.size())
		_:
			if target_ice >= 0:
				targets = [target_ice]
	var n := int(e.get("n", 0))
	if e.has("n_per_10_trace"):
		n = int(e["n_per_10_trace"]) * (run.trace / 10)
	for t in targets:
		if e.has("ice_type") and ice_list[t]["def"]["type"] != e["ice_type"]:
			continue
		ice_list[t]["str_mod"] += n
		_log("%s STR %+d → %d." % [ice_list[t]["def"]["name"], n, ice_str(t)])


func _script_break(e: Dictionary, target_ice: int) -> void:
	var targets: Array = range(ice_list.size()) if e.get("target", "") == "each_ice" else [target_ice]
	for t in targets:
		if t < 0:
			continue
		if e.has("max_ice_str") and ice_str(t) > int(e["max_ice_str"]) and not e.get("ignore_str", false):
			_log("%s is too strong (STR %d)." % [ice_list[t]["def"]["name"], ice_str(t)])
			continue
		if e.has("min_virus_counters") and _virus_total(t) < int(e["min_virus_counters"]):
			_log("%s needs more virus counters." % ice_list[t]["def"]["name"])
			continue
		for i in int(e.get("count", 1)):
			var s := _best_unbroken_subroutine(t)
			if s >= 0:
				_mark_broken(t, s, "card")
	if is_breached():
		_log("BREACH! Every DEADLOCK is broken.")


## Script breaks pick a subroutine automatically: DEADLOCKs first, then the most harmful.
func _best_unbroken_subroutine(ice_index: int) -> int:
	var subs: Array = ice_list[ice_index]["def"]["subroutines"]
	var best := -1
	var best_score := -1
	for s in subs.size():
		if ice_list[ice_index]["broken"][s]:
			continue
		var score := 0
		for e in subs[s]["effects"]:
			score += 100 if e["op"] == "deadlock" else int(e.get("n", 1))
		if score > best_score:
			best_score = score
			best = s
	return best


func _mark_broken(ice_index: int, sub_index: int, by: String) -> void:
	ice_list[ice_index]["broken"][sub_index] = true
	_log("Broke %s [S%d] (%s)." % [ice_list[ice_index]["def"]["name"], sub_index + 1, by])


func _infect(ice_index: int, strain: String, n: int) -> void:
	if ice_index < 0 or ice_index >= ice_list.size():
		return
	var v: Dictionary = ice_list[ice_index]["virus"]
	v[strain] = int(v.get(strain, 0)) + n
	_log("INFECT %d %s on %s." % [n, strain.to_upper(), ice_list[ice_index]["def"]["name"]])


func _virus_total(ice_index: int) -> int:
	var total := 0
	for n in ice_list[ice_index]["virus"].values():
		total += int(n)
	return total


func _start_of_turn_viruses() -> void:
	for i in ice_list.size():
		var leech := int(ice_list[i]["virus"].get("leech", 0))
		if leech > 0:
			_extract(leech, "LEECH")
	var snapshot: Array = ice_list.map(func(x): return x["virus"].duplicate())
	for i in ice_list.size():
		var worm := int(snapshot[i].get("worm", 0))
		if worm > 0 and i + 1 < ice_list.size():
			for strain in snapshot[i].keys():
				_infect(i + 1, strain, worm)


# ------------------------------------------------------------------ zones

func _draw(n: int) -> void:
	for i in n:
		if draw_pile.is_empty():
			if discard_pile.is_empty():
				return
			draw_pile = discard_pile.duplicate()
			discard_pile.clear()
			_shuffle(draw_pile)
			_log("Shuffled the discard pile into the draw pile.")
		hand.append(draw_pile.pop_back())


func _discard_from_hand(n: int) -> void:
	# The player should choose; for now the right-most non-CACHED cards are discarded.
	for i in n:
		var pick = null
		for j in range(hand.size() - 1, -1, -1):
			if not cached.has(hand[j]["uid"]):
				pick = hand[j]
				break
		if pick == null:
			return
		hand.erase(pick)
		discard_pile.append(pick)
		_log("Discarded %s." % card_name(pick))


func _insert_bloatware(card_id: String, dest: String, n: int) -> void:
	for i in n:
		var inst: Dictionary = run.make_temp_card(card_id)
		match dest:
			"hand":
				hand.append(inst)
			"discard":
				discard_pile.append(inst)
			_:
				draw_pile.insert(run.rng.randi_range(0, draw_pile.size()), inst)
		_log("The corporation INSERTs %s into your %s." % [db.cards[card_id]["name"], dest.replace("_", " ")])


func _cleanup_hand() -> void:
	for inst in hand.duplicate():
		if cached.has(inst["uid"]):
			continue
		hand.erase(inst)
		discard_pile.append(inst)


func _shuffle(arr: Array) -> void:
	for i in range(arr.size() - 1, 0, -1):
		var j: int = run.rng.randi_range(0, i)
		var tmp = arr[i]
		arr[i] = arr[j]
		arr[j] = tmp


func _find(arr: Array, uid: int):
	for inst in arr:
		if inst["uid"] == uid:
			return inst
	return null


func _ice_index_by_id(ice_id: String) -> int:
	for i in ice_list.size():
		if ice_list[i]["id"] == ice_id:
			return i
	return -1


# ------------------------------------------------------------------ BREACH, rewards, leaving

func _layer_cleared() -> void:
	layers_cleared = layer_index + 1
	_log("== Layer %d BREACHED (Corporation Response skipped) ==" % layers_cleared)
	if layers_cleared < layers.size():
		phase = PHASE_LAYER_CHOICE
		_log("Go deeper (layer %d, better card odds), or leave the Node now?" % (layers_cleared + 1))
		changed.emit()
	else:
		node_fully_cleared = true
		_offer_node_reward()


## The Node's one card reward (CORE-010), given when the Node ends by full clear or by leaving.
func _offer_node_reward() -> void:
	reward_options = _roll_rewards()
	phase = PHASE_REWARD
	_log("Node reward: choose 1 of %d cards (odds for %d layer(s) cleared)." % [reward_options.size(), layers_cleared])
	changed.emit()


func rarity_odds() -> Dictionary:
	var r: Dictionary = db.rules["rewards"]
	var table: Dictionary = r.get("rarity_odds_by_layers_cleared", {})
	var key := str(clampi(layers_cleared, 1, table.size()))
	return table.get(key, r["rarity_odds"])


func _roll_rewards() -> Array:
	var r: Dictionary = db.rules["rewards"]
	var options: Array = []
	var picks: Array = []
	for i in int(r["mix"]["shared"]):
		picks.append("shared")
	for i in int(r["mix"]["rustler"]):
		picks.append(run.rustler_id)
	for owner in picks:
		var rarity := _roll_rarity()
		var pool: Array = db.reward_pool(owner, rarity)
		pool = pool.filter(func(id): return not options.has(id))
		if pool.is_empty():
			pool = db.reward_pool(owner).filter(func(id): return not options.has(id))
		if not pool.is_empty():
			options.append(pool[run.rng.randi_range(0, pool.size() - 1)])
	return options


func _roll_rarity() -> String:
	var odds := rarity_odds()
	var roll: float = run.rng.randf()
	if roll < float(odds["rare"]):
		return "rare"
	if roll < float(odds["rare"]) + float(odds["uncommon"]):
		return "uncommon"
	return "common"


## card_id "" skips the reward.
func choose_reward(card_id: String) -> void:
	if phase != PHASE_REWARD:
		return
	if card_id != "":
		run.add_card(card_id)
		_log("Added %s to your deck." % db.cards[card_id]["name"])
	reward_options.clear()
	_complete_node()


func can_leave() -> bool:
	return phase == PHASE_LAYER_CHOICE and not lockdown


func go_deeper() -> void:
	if phase != PHASE_LAYER_CHOICE:
		return
	_start_layer(layer_index + 1)


func leave_node() -> void:
	if not can_leave():
		return
	_log("You leave the Node after %d layer(s). No completion reward." % layers_cleared)
	_offer_node_reward()


func _complete_node() -> void:
	phase = PHASE_NODE_COMPLETE
	if node_fully_cleared:
		_log("== Node complete: every layer cleared. Completion reward: a CAP or a PATCHWORK upgrade (not in this build yet). ==")
	else:
		_log("== Node finished early. ==")
	if not trace_gained_this_node:
		run.cred += int(db.rules["rewards"]["clean_node_cred"])
		_log("Clean Node: +%d CRED." % int(db.rules["rewards"]["clean_node_cred"]))
	changed.emit()


func _check_defeat() -> bool:
	if run.vitae <= 0:
		run.vitae = 0
		phase = PHASE_DEFEAT
		_log("== FLATLINED. VITAE reached 0. Run over. ==")
		changed.emit()
		return true
	return false


func _log(text: String) -> void:
	log_lines.append(text)
	if log_lines.size() > MAX_LOG:
		log_lines.pop_front()
	logged.emit(text)
