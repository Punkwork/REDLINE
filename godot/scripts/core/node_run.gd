extends RefCounted
## Rules engine for one ICE Node: its layers, turns, cards, Icepicks, CAPS, Ghostware,
## the Corporation Response, TRACE strikes, extraction, BREACH and rewards.
## No UI code lives here, so it can be tested headless.
##
## Rules follow docs/REDLINE_CORE_RULES.md. Card, CAP, Ghostware and ICE values come from res://data.
##
## Flow:
##     node.setup(db, run, corp_id, layers, {"central": false})
##     node.start()                          # "ready_rig" or "player"
##     node.play_card(uid, target) / node.use_cap(slot, target)
##     node.boost_and_break(icepick_uid, ice_index, sub_index)
##     node.resolve_choice(picks)            # whenever node.choice is not empty
##     node.end_turn()                       # Corporation Response, or BREACH
##     node.go_deeper() / node.leave_node()  # "layer_choice"
##     node.choose_reward(card_id)           # "reward": the Node's one card reward (CORE-010)
##     node.choose_completion(cap_id)        # "completion": full clear -> a CAP
##     node.choose_payload(ghostware_id)     # "payload": Central Node only
##     -> "node_complete" or "defeat"

signal changed
signal logged(text: String)

const PHASE_READY_RIG := "ready_rig"
const PHASE_PLAYER := "player"
const PHASE_LAYER_CHOICE := "layer_choice"
const PHASE_REWARD := "reward"
const PHASE_COMPLETION := "completion"
const PHASE_PAYLOAD := "payload"
const PHASE_NODE_COMPLETE := "node_complete"
const PHASE_DEFEAT := "defeat"

const MAX_LOG := 300

var db
var run
var corporation_id := ""
var layers: Array = []          ## [{ "ice": [ids], "cred_reserve": int }]
var is_central := false
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

# Encounter state.
var bw := 0
var shield := 0
var node_shield := 0            ## SUBDERMAL PLATING: lasts the whole Node
var ram_used := 0
var ram_bonus_node := 0         ## MEMORY SPIKE
var ice_list: Array = []        ## [{ "id", "def", "str_mod", "broken": [bool], "virus": {strain: n} }]
var reserve := 0
var reserve_start := 0
var full_extraction_paid := false
var boosts := {}
var once_per_encounter_used := {}
var trace_reduce_next := 0
var trace_block_next := false   ## VANISH
var skip_next_response := false ## BLACKOUT
var stabilizer := false         ## STABILIZER CAP
var trace_gained_this_encounter := false
var trace_gained_this_node := false
var lockdown := false
var in_corp_response := false
var killswitch_used := false

# Turn state.
var free_break_used := {}
var cards_played_this_turn := 0
var cloak_played_this_turn := 0
var toolbelt_used := false
var recycler_used := false
var pocket_used := false
var suppressed_types: Array = []
var turn_str_mods: Array = []   ## [[ice_index, n]] reverted at end of your turn

# Results.
var reward_options: Array = []
var completion_options: Array = []
var payload_options: Array = []
var layers_cleared := 0
var node_fully_cleared := false
var jacked_out := false
var cred_earned := 0
var reward_taken := ""

## A choice the player must make before doing anything else:
## { "prompt": String, "options": [{"key", "label"}], "min": int, "max": int, "action": String, "ctx": Dictionary }
var choice := {}
var log_lines: Array[String] = []


# ------------------------------------------------------------------ setup

func setup(game_data, run_state, p_corporation_id: String, p_layers: Array, options: Dictionary = {}) -> void:
	db = game_data
	run = run_state
	corporation_id = p_corporation_id
	layers = p_layers
	is_central = options.get("central", false)


## Builds the layer list for a corporation that defines fixed layers (e.g. the Training Node).
static func layers_for(game_data, corp_id: String) -> Array:
	var out: Array = []
	for layer in game_data.corporations[corp_id].get("layers", []):
		out.append({"ice": layer["ice"], "cred_reserve": int(layer.get("cred_reserve", 10))})
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
	ram_bonus_node = 0
	lockdown = false
	killswitch_used = false
	trace_gained_this_node = false
	layer_index = 0
	layers_cleared = 0
	node_fully_cleared = false
	jacked_out = false
	cred_earned = 0
	node_shield = 0
	if run.has_ghostware("subdermal_plating"):
		node_shield = 6
	_log("== Entering %s ==" % ("the Central Node" if is_central else "an ICE Node"))
	if node_shield > 0:
		_log("SUBDERMAL PLATING: 6 SHIELD for the whole Node.")
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
		ice_list.append(_make_ice(ice_id))
	reserve = int(layer.get("cred_reserve", 10))
	reserve_start = reserve
	run.stats["reserve_seen"] = int(run.stats.get("reserve_seen", 0)) + reserve
	full_extraction_paid = false
	boosts.clear()
	once_per_encounter_used.clear()
	trace_gained_this_encounter = false
	stabilizer = false
	trace_reduce_next = 0
	trace_block_next = false
	skip_next_response = false
	turn = 0
	_log("-- Layer %d of %d: %s (CRED reserve %d) --" % [index + 1, layers.size(),
			", ".join(ice_list.map(func(x): return x["def"]["name"])), reserve])
	_ghostware_effects("start_of_encounter")
	if index == 0 and run.has_ghostware("first_contact"):
		ice_list[-1]["str_mod"] -= 2
		_log("FIRST CONTACT: %s −2 STR." % ice_list[-1]["def"]["name"])
	_start_turn()


## Applies the effects of owned Ghostware that fire at this timing (PATIENT ZERO, HEARTH KEY,
## BADGE CLONE at "start_of_encounter"; DASHCAM FEED at "breach").
func _ghostware_effects(timing: String) -> void:
	for gid in run.ghostware:
		for e in db.ghostware[gid].get("effects", []):
			if str(e.get("when", "")) == timing:
				_log("%s:" % db.ghostware[gid]["name"])
				_apply_effect(e, -1, null)


func _make_ice(ice_id: String) -> Dictionary:
	var def: Dictionary = db.ice[ice_id]
	var broken: Array = []
	broken.resize(def["subroutines"].size())
	broken.fill(false)
	return {"id": ice_id, "def": def, "str_mod": 0, "broken": broken, "virus": {}}


func _start_turn() -> void:
	turn += 1
	phase = PHASE_PLAYER
	bw = int(db.rules["turn"]["bw_per_turn"])
	shield = 0
	free_break_used.clear()
	cards_played_this_turn = 0
	cloak_played_this_turn = 0
	toolbelt_used = false
	recycler_used = false
	pocket_used = false
	suppressed_types.clear()
	if run.has_ghostware("redliner") and run.trace >= 20:
		bw += 1
		_log("REDLINER: +1 BW.")
	if run.has_ghostware("black_mirror"):
		bw += 1
	if turn == 1 and run.has_ghostware("overclocked_bus"):
		bw += 1
		_log("OVERCLOCKED BUS: +1 BW.")
	for inst in installed + rack:
		_apply_effects(card_def(inst)["effects"], _strongest_ice(), inst, "start_of_turn")
		if turn == 1:
			_apply_effects(card_def(inst)["effects"], -1, inst, "first_turn_of_encounter")
		if card_def(inst).get("script", "") == "replicator":
			_replicate()
	_start_of_turn_viruses()
	var floor_draw := 1
	if run.has_ghostware("lucid_dream"):
		floor_draw = min(3, run.draw_size)
	var n: int = max(floor_draw, run.draw_size - run.void_counters)
	_draw(n)
	_log("Turn %d: %d BW, drew %d." % [turn, bw, n])
	changed.emit()


# ------------------------------------------------------------------ queries

func card_def(inst) -> Dictionary:
	return db.cards[inst["id"]]


func card_name(inst) -> String:
	return card_def(inst)["name"]


func ram_capacity() -> int:
	var cap: int = run.ram + ram_bonus_node
	for inst in installed:
		for e in card_def(inst)["effects"]:
			if e["op"] == "ram" and not e.has("when"):
				cap += int(e["n"])
	return cap


func ice_str(ice_index: int) -> int:
	var ice: Dictionary = ice_list[ice_index]
	var value: int = int(ice["def"]["str"]) + int(ice["str_mod"]) - int(ice["virus"].get("rot", 0))
	var floor_value := 0
	for e in ice["def"].get("ability", {}).get("effects", []):
		if e["op"] == "str_floor":
			floor_value = int(e["n"])
	return max(floor_value, value)


func icepick_str(inst) -> int:
	var ip: Dictionary = card_def(inst)["icepick"]
	var bonus := 2 if run.has_ghostware("burnout_chip") else 0
	return int(ip["str"]) + int(boosts.get(inst["uid"], 0)) + bonus


func installed_icepicks() -> Array:
	return installed.filter(func(inst): return card_def(inst).has("icepick"))


func has_in_play(card_id_or_script: String) -> bool:
	for inst in installed + rack:
		var def := card_def(inst)
		if def["id"] == card_id_or_script or def.get("script", "") == card_id_or_script:
			return true
	return false


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


func busy() -> bool:
	return phase != PHASE_PLAYER or not choice.is_empty()


func play_cost(inst) -> int:
	var def := card_def(inst)
	if def["cost_bw"] == null:
		return 0
	var cost := int(def["cost_bw"])
	if run.has_ghostware("long_memory") and cards_played_this_turn == 0:
		cost += 1
	if run.has_ghostware("cold_storage") and cached.has(inst["uid"]):
		cost -= 1
	if has_in_play("berserk") and run.trace >= 20 and def["type"] == "SCRIPT" and def.get("tags", []).has("EXPLOIT"):
		cost -= 1
	return max(0, cost)


func can_play(inst) -> Dictionary:
	if busy():
		return {"ok": false, "reason": "Not now."}
	if not hand.has(inst):
		return {"ok": false, "reason": "Not in hand."}
	var def := card_def(inst)
	if def["cost_bw"] == null:
		return {"ok": false, "reason": "This card can't be played."}
	var cost := play_cost(inst)
	if cost > bw:
		return {"ok": false, "reason": "Needs %d BW." % cost}
	if def["type"] == "PROGRAM" and ram_used + int(def.get("ram", 0)) > ram_capacity():
		return {"ok": false, "reason": "Not enough RAM."}
	return {"ok": true, "reason": ""}


## The extra BW an Icepick pays to break this ICE (ADAPTER makes off-type breaks possible), or -1.
func _type_surcharge(inst, ice: Dictionary) -> int:
	var ip: Dictionary = card_def(inst)["icepick"]
	if ip["ice_type"] == "ANY" or ip["ice_type"] == ice["def"]["type"]:
		return 0
	if has_in_play("adapter"):
		return 1
	return -1


func _break_bw(inst, ice: Dictionary) -> int:
	var ip: Dictionary = card_def(inst)["icepick"]
	var cost := int(ip["break_bw"])
	if ip.get("free_first_break_each_turn", false) and not free_break_used.get(inst["uid"], false):
		cost = 0
	return cost + _type_surcharge(inst, ice)


func _boosts_needed(inst, need: int) -> int:
	var ip: Dictionary = card_def(inst)["icepick"]
	var missing := need - icepick_str(inst)
	return int(ceil(float(missing) / int(ip["boost_str"])))


func _boost_cost(inst) -> int:
	return 0 if (has_in_play("toolbelt") and not toolbelt_used) else int(card_def(inst)["icepick"]["boost_bw"])


## Total BW to boost (if needed) and break this subroutine. -1 if impossible.
func total_break_cost(icepick_uid: int, ice_index: int, sub_index: int) -> int:
	var inst = _find(installed, icepick_uid)
	if inst == null or not card_def(inst).has("icepick") or ice_index >= ice_list.size():
		return -1
	var ice: Dictionary = ice_list[ice_index]
	if sub_index >= ice["broken"].size() or ice["broken"][sub_index] or _type_surcharge(inst, ice) < 0:
		return -1
	var ip: Dictionary = card_def(inst)["icepick"]
	var need := ice_str(ice_index)
	var boost_cost := 0
	if icepick_str(inst) < need:
		var n := _boosts_needed(inst, need)
		boost_cost = n * int(ip["boost_bw"])
		if has_in_play("toolbelt") and not toolbelt_used:
			boost_cost -= int(ip["boost_bw"])
	return boost_cost + _break_bw(inst, ice)


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
	if target_ice < 0 or target_ice >= ice_list.size():
		target_ice = ice_list.size() - 1   # default: the main ICE (right-most)
	bw -= play_cost(inst)
	hand.erase(inst)
	cached.erase(uid)
	cards_played_this_turn += 1
	if def.get("tags", []).has("CLOAK"):
		cloak_played_this_turn += 1
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
			_burn(inst)
			_log("Cleared %s." % def["name"])
		_:
			_log("Played %s." % def["name"])
			_apply_effects(def["effects"], target_ice, inst, "")
			if def.has("script"):
				_card_script(def["script"], target_ice)
			if def.get("burned_after_use", false):
				_burn(inst)
			else:
				discard_pile.append(inst)
	if int(def.get("trace", 0)) > 0:
		add_trace(int(def["trace"]), false)
	_trigger_ice_abilities("player_plays_tag", def)
	if cards_played_this_turn == 4 and run.has_ghostware("chaos_engine"):
		_log("CHAOS ENGINE: draw 1.")
		_draw(1)
	_check_defeat()
	changed.emit()
	return true


func unload(uid: int) -> void:
	var inst = _find(installed, uid)
	if inst == null or busy():
		return
	installed.erase(inst)
	ram_used -= int(card_def(inst).get("ram", 0))
	boosts.erase(uid)
	discard_pile.append(inst)
	_log("Unloaded %s." % card_name(inst))
	changed.emit()


func boost(icepick_uid: int) -> bool:
	var inst = _find(installed, icepick_uid)
	if inst == null or busy() or not card_def(inst).has("icepick"):
		return false
	var ip: Dictionary = card_def(inst)["icepick"]
	var cost := _boost_cost(inst)
	if cost > bw:
		_log("Boost needs %d BW." % cost)
		return false
	bw -= cost
	if cost == 0 and has_in_play("toolbelt"):
		toolbelt_used = true
	boosts[icepick_uid] = int(boosts.get(icepick_uid, 0)) + int(ip["boost_str"])
	_log("Boosted %s to STR %d." % [card_name(inst), icepick_str(inst)])
	changed.emit()
	return true


## Boosts as many times as needed, then breaks. Returns false (and changes nothing) if unaffordable.
func boost_and_break(icepick_uid: int, ice_index: int, sub_index: int) -> bool:
	var total := total_break_cost(icepick_uid, ice_index, sub_index)
	if total < 0 or total > bw or busy():
		return false
	var inst = _find(installed, icepick_uid)
	while icepick_str(inst) < ice_str(ice_index):
		if not boost(icepick_uid):
			return false
	return break_subroutine(icepick_uid, ice_index, sub_index)


func break_subroutine(icepick_uid: int, ice_index: int, sub_index: int) -> bool:
	var inst = _find(installed, icepick_uid)
	if inst == null or busy() or not card_def(inst).has("icepick"):
		return false
	var ice: Dictionary = ice_list[ice_index]
	if ice["broken"][sub_index] or _type_surcharge(inst, ice) < 0:
		return false
	if icepick_str(inst) < ice_str(ice_index):
		_log("Can't break: STR %d < ICE STR %d." % [icepick_str(inst), ice_str(ice_index)])
		return false
	var cost := _break_bw(inst, ice)
	if cost > bw:
		_log("Can't break: needs %d BW." % cost)
		return false
	var ip: Dictionary = card_def(inst)["icepick"]
	bw -= cost
	if ip.get("free_first_break_each_turn", false):
		free_break_used[icepick_uid] = true
	_mark_broken(ice_index, sub_index, card_name(inst))
	var extra := int(ip.get("subroutines_per_break", 1)) - 1
	var subs: Array = ice["broken"]
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
		_log("BREACH! Every DEADLOCK is broken. End your turn to skip the Corporation Response.")
	changed.emit()
	return true


## Use the CAP in this slot. Returns false (and keeps the CAP) if it can't be used now.
func use_cap(slot: int, target_ice: int = -1) -> bool:
	if busy() or slot < 0 or slot >= run.caps.size():
		return false
	var cap: Dictionary = run.caps[slot]
	var def: Dictionary = db.caps[cap["id"]]
	if cap["id"] == "jack_out":
		var why := jack_out_blocked()
		if why != "":
			_log("JACK OUT can't be used: %s" % why)
			return false
	if target_ice < 0 or target_ice >= ice_list.size():
		target_ice = ice_list.size() - 1
	run.caps.remove_at(slot)
	run.stats["caps_used"] += 1
	_log("CAP: %s%s." % [def["name"], " (BOOTLEG)" if cap["bootleg"] else ""])
	var bl: Dictionary = db.raw["caps"]["rules"]["bootleg"]
	if cap["bootleg"] and run.rng.randf() < float(bl["fizzle_chance"]):
		_log("The bootleg CAP fizzles.")
		add_trace(int(bl["fizzle_trace"]), false)
		changed.emit()
		return true
	for e in def["effects"]:
		match e["op"]:
			"jack_out":
				jacked_out = true
			"discard_hand":
				for inst in hand.duplicate():
					hand.erase(inst)
					discard_pile.append(inst)
			"ram":
				ram_bonus_node += int(e["n"])
			"prevent_void":
				stabilizer = true
			"remove_all_bloatware":
				for zone in [hand, draw_pile, discard_pile]:
					for inst in zone.duplicate():
						if card_def(inst)["type"] == "BLOATWARE":
							zone.erase(inst)
				_log("All Bloatware removed.")
			"remove_strike":
				run.strikes = max(0, run.strikes - int(e["n"]))
				_log("A TRACE strike is removed (%d left)." % run.strikes)
			"break":
				var s := _best_unbroken_subroutine(target_ice)
				if s >= 0:
					_mark_broken(target_ice, s, def["name"])
			_:
				_apply_effect(e, target_ice, null)
	if jacked_out:
		_log("JACK OUT: you leave the Node. No card reward.")
		_finish_node()
		return true
	if is_breached():
		_log("BREACH! Every DEADLOCK is broken.")
	_check_defeat()
	changed.emit()
	return true


func jack_out_blocked() -> String:
	if is_central:
		return "not at the Central Node."
	if lockdown:
		return "LOCKDOWN."
	if is_breached():
		return "you've already BREACHED; leave normally."
	for ice in ice_list:
		if ice["def"]["tier"] == "black_ice" and ice["broken"].has(false):
			return "a Black ICE has an unbroken subroutine."
	return ""


## DEAD MAN'S POCKET: once per turn, CACHE 1 card for free.
func can_pocket() -> bool:
	return run.has_ghostware("dead_mans_pocket") and not pocket_used and not busy() and not hand.is_empty()


func pocket() -> void:
	if not can_pocket():
		return
	pocket_used = true
	_ask_hand_cards("DEAD MAN'S POCKET: choose a card to CACHE.", 1, "cache", func(_i): return true)


func end_turn() -> void:
	if busy():
		return
	for m in turn_str_mods:
		if m[0] < ice_list.size():
			ice_list[m[0]]["str_mod"] -= m[1]
	turn_str_mods.clear()
	for inst in installed:
		if card_def(inst).has("extractor"):
			_extract_for(inst)
	for inst in hand.duplicate():
		for e in card_def(inst)["effects"]:
			if str(e.get("when", "")) == "end_of_turn_in_hand":
				_log("%s in hand:" % card_name(inst))
				_apply_effect(e, -1, inst)
	if _check_defeat():
		return
	if is_breached():
		_cleanup_hand()
		_layer_cleared()
		return
	if skip_next_response:
		skip_next_response = false
		_log("BLACKOUT: the Corporation Response is skipped.")
	else:
		_corporation_response()
	if _check_defeat():
		return
	_cleanup_hand()
	_start_turn()


# ------------------------------------------------------------------ player choices

func _ask(prompt: String, options: Array, min_n: int, max_n: int, action: String, ctx: Dictionary = {}) -> void:
	if options.is_empty():
		return
	choice = {"prompt": prompt, "options": options, "min": min_n, "max": max_n, "action": action, "ctx": ctx}
	changed.emit()


func _ask_hand_cards(prompt: String, max_n: int, action: String, filter: Callable) -> void:
	var opts: Array = []
	for inst in hand:
		if filter.call(inst) and not cached.has(inst["uid"]):
			opts.append({"key": inst["uid"], "label": card_name(inst)})
	_ask(prompt, opts, 0, max_n, action)


## picks: Array of option keys.
func resolve_choice(picks: Array) -> void:
	if choice.is_empty():
		return
	var c := choice
	choice = {}
	match c["action"]:
		"cache":
			for uid in picks:
				cached[uid] = true
				var inst = _find(hand, uid)
				if inst != null:
					_log("CACHED %s." % card_name(inst))
		"tutor":
			for uid in picks:
				var inst = _find(draw_pile, uid)
				if inst != null:
					draw_pile.erase(inst)
					hand.append(inst)
					_log("FIELD KIT finds %s." % card_name(inst))
			_shuffle(draw_pile)
		"burn_bloatware":
			for uid in picks:
				var inst = _find(hand, uid)
				if inst != null:
					hand.erase(inst)
					_burn(inst)
					_log("%s is BURNED." % card_name(inst))
		"hot_swap_unload":
			for uid in picks:
				var inst = _find(installed, uid)
				if inst != null:
					installed.erase(inst)
					ram_used -= int(card_def(inst).get("ram", 0))
					discard_pile.append(inst)
					_log("HOT SWAP unloads %s." % card_name(inst))
			_ask_hand_cards("HOT SWAP: install a PROGRAM from your hand for 0 BW.", 1, "hot_swap_install",
					func(i): return card_def(i)["type"] == "PROGRAM" and ram_used + int(card_def(i).get("ram", 0)) <= ram_capacity())
		"hot_swap_install":
			for uid in picks:
				var inst = _find(hand, uid)
				if inst != null:
					hand.erase(inst)
					installed.append(inst)
					ram_used += int(card_def(inst).get("ram", 0))
					_log("HOT SWAP installs %s." % card_name(inst))
					_apply_effects(card_def(inst)["effects"], ice_list.size() - 1, inst, "installed")
					_trigger_ice_abilities("player_installs", card_def(inst))
	changed.emit()


# ------------------------------------------------------------------ card scripts

func _card_script(script: String, target_ice: int) -> void:
	match script:
		"patience":
			var n := 2 if trace_gained_this_encounter else 4
			shield += n
			_log("+%d SHIELD (%d)." % [n, shield])
		"hot_swap":
			var opts: Array = installed.map(func(i): return {"key": i["uid"], "label": card_name(i)})
			if opts.is_empty():
				_ask_hand_cards("HOT SWAP: install a PROGRAM from your hand for 0 BW.", 1, "hot_swap_install",
						func(i): return card_def(i)["type"] == "PROGRAM" and ram_used + int(card_def(i).get("ram", 0)) <= ram_capacity())
			else:
				_ask("HOT SWAP: unload one of your PROGRAMS (or none).", opts, 0, 1, "hot_swap_unload")
		"jack_of_all_trades":
			var types := {}
			for ip in installed_icepicks():
				types[card_def(ip)["icepick"]["ice_type"]] = ip
			if not (types.has("WALL") and types.has("CODE GATE") and types.has("SENTRY")):
				_log("JACK OF ALL TRADES needs a WALL, a CODE GATE and a SENTRY Icepick installed.")
				return
			for i in ice_list.size():
				var ip = types.get(ice_list[i]["def"]["type"])
				if ip == null or icepick_str(ip) < ice_str(i):
					continue
				var s := _best_unbroken_subroutine(i)
				if s >= 0:
					_mark_broken(i, s, "JACK OF ALL TRADES")
		_:
			_log("(Not yet implemented: card script '%s')" % script)


func _replicate() -> void:
	for i in ice_list.size():
		for strain in ice_list[i]["virus"].keys():
			_infect(i, strain, 1)


# ------------------------------------------------------------------ corporation

func _corporation_response() -> void:
	_log("-- Corporation Response --")
	in_corp_response = true
	var voice_mimic_ready: bool = run.has_ghostware("voice_mimic") and not once_per_encounter_used.get("voice_mimic", false)
	# Snapshot: a Black ICE joining mid-response (2nd strike) waits for the next response.
	for ice in ice_list.duplicate():
		var subs: Array = ice["def"]["subroutines"]
		for s in subs.size():
			var i := _index_of(ice)
			if i < 0 or ice["broken"][s]:
				continue
			var effects: Array = subs[s]["effects"]
			if voice_mimic_ready and effects.any(func(e): return e["op"] == "trace"):
				voice_mimic_ready = false
				once_per_encounter_used["voice_mimic"] = true
				_log("VOICE MIMIC: %s [S%d] fails." % [ice["def"]["name"], s + 1])
				continue
			_resolve_subroutine(i, s)
			if phase == PHASE_DEFEAT:
				in_corp_response = false
				return
	for i in ice_list.size():
		var ability = ice_list[i]["def"].get("ability", {})
		if ability.get("trigger", "") == "end_of_corp_response":
			_apply_ice_effects(ability["effects"], i)
	in_corp_response = false
	trace_reduce_next = 0
	trace_block_next = false


func _resolve_subroutine(ice_index: int, sub_index: int) -> void:
	var ice: Dictionary = ice_list[ice_index]
	var effects: Array = ice["def"]["subroutines"][sub_index]["effects"]
	var shown: Array = []
	for e in effects:
		if e["op"] != "deadlock":
			shown.append(describe_ice_effect(e))
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
				if run.has_ghostware("kevlar_weave"):
					n -= 1
				take_pulp(max(0, n))
			"forget":
				_forget(int(e["n"]))
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
				var targets: Array = [ice_index]
				if e["target"] == "others":
					targets = range(ice_list.size()).filter(func(k): return k != ice_index)
				elif e["target"] != "self":
					targets = [_ice_index_by_id(e["target"])]
				for target in targets:
					if target >= 0:
						ice_list[target]["str_mod"] += int(e["n"])
						_log("%s gains +%d STR." % [ice_list[target]["def"]["name"], int(e["n"])])
			"purge":
				_purge(ice_index)
			"purge_all":
				for i in ice_list.size():
					_purge(i)
			_:
				_log("(Not yet implemented: ICE effect '%s')" % e["op"])
		if phase == PHASE_DEFEAT:
			return


## FORGET X: X random non-CACHED cards in your hand are BURNED for the rest of the Node
## (MEMORY BACKUP sends them to the discard pile instead).
func _forget(n: int) -> void:
	for i in n:
		var options: Array = hand.filter(func(c): return not cached.has(c["uid"]))
		if options.is_empty():
			return
		var inst = options[run.rng.randi_range(0, options.size() - 1)]
		hand.erase(inst)
		if run.has_ghostware("memory_backup"):
			discard_pile.append(inst)
			_log("FORGET: %s (MEMORY BACKUP: to your discard pile)." % card_name(inst))
		else:
			burned.append(inst)
			_log("FORGET: %s is BURNED for the rest of the Node." % card_name(inst))


func _purge(ice_index: int) -> void:
	if ice_list[ice_index]["virus"].is_empty():
		return
	ice_list[ice_index]["virus"].clear()
	_log("PURGE: %s loses its virus counters." % ice_list[ice_index]["def"]["name"])
	if has_in_play("incubator"):
		_infect(ice_index, "rot", 2)


func _ice_pulp_bonus(ice: Dictionary) -> int:
	var ability = ice["def"].get("ability", {})
	if ability.get("trigger", "") != "constant" or run.trace < int(ability.get("if_trace_at_least", 0)):
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
		if suppressed_types.has(ice_list[i]["def"]["type"]):
			_log("%s's ability is suppressed." % ice_list[i]["def"]["name"])
			continue
		_log("%s reacts: %s" % [ice_list[i]["def"]["name"], ability["text"]])
		_apply_ice_effects(ability["effects"], i)


func describe_ice_effect(e: Dictionary) -> String:
	match e["op"]:
		"pulp", "trace", "void", "discard":
			return "%s %d" % [String(e["op"]).to_upper(), int(e["n"])]
		"insert":
			return "INSERT %s → %s" % [db.cards[e["card"]]["name"], String(e["dest"]).replace("_", " ")]
		"ice_gain_str":
			var who := "EVERY OTHER ICE" if e["target"] == "others" else String(e["target"]).to_upper().replace("_", " ")
			return "%s +%d STR" % [who, int(e["n"])]
		"purge_all":
			return "PURGE ALL"
		"forget":
			return "FORGET %d" % int(e["n"])
		_:
			return String(e["op"]).to_upper()


# ------------------------------------------------------------------ damage, TRACE, CRED

func take_pulp(n: int) -> void:
	if n <= 0:
		return
	var absorbed: int = min(shield, n)
	shield -= absorbed
	var rest := n - absorbed
	var absorbed_node: int = min(node_shield, rest)
	node_shield -= absorbed_node
	var dmg := rest - absorbed_node
	if dmg > 0 and run.has_ghostware("burnout_chip"):
		dmg += 1
	_lose_vitae(dmg)
	_log("PULP %d: %d blocked, %d damage. VITAE %d." % [n, absorbed + absorbed_node, dmg, run.vitae])
	_check_defeat()


func _lose_vitae(n: int) -> void:
	run.vitae -= n
	if run.vitae <= 0 and run.has_ghostware("killswitch") and not killswitch_used:
		killswitch_used = true
		run.vitae = 1
		_log("KILLSWITCH: VITAE stays at 1.")


func take_void(n: int) -> void:
	if stabilizer and n > 0:
		_log("STABILIZER prevents %d VOID." % n)
		return
	if n > 0 and run.has_ghostware("neural_firewall") and not once_per_encounter_used.get("neural_firewall", false):
		once_per_encounter_used["neural_firewall"] = true
		n -= 1
		_log("NEURAL FIREWALL prevents 1 VOID.")
	for inst in installed + rack:
		for e in card_def(inst)["effects"]:
			if e["op"] != "prevent_void" or n <= 0:
				continue
			var key := "%d:prevent_void" % inst["uid"]
			if once_per_encounter_used.get(key, false):
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
		if from_corp and trace_block_next:
			_log("VANISH: TRACE %d adds nothing." % n)
			return
		if from_corp and trace_reduce_next > 0:
			var cut: int = min(n, trace_reduce_next)
			n -= cut
			trace_reduce_next = 0
			_log("TRACE reduced by %d." % cut)
		if from_corp and has_in_play("proxy_chain"):
			n -= 1
		if run.has_ghostware("low_profile"):
			n -= 1
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
	if run.strikes == 1 and run.has_ghostware("scrambled_id") and not run.scrambled_used:
		run.scrambled_used = true
		run.trace = int(step["trace_after"])
		_log("SCRAMBLED ID: no penalty this time.")
		return
	for e in step["effects"]:
		match e["op"]:
			"insert":
				_insert_bloatware(e["card"], e["dest"], int(e.get("n", 1)))
			"add_black_ice":
				var corp: Dictionary = db.corporations.get(corporation_id, {})
				if corp.has("black_ice"):
					var ice := _make_ice(corp["black_ice"])
					ice_list.insert(0, ice)
					for m in turn_str_mods:
						m[0] += 1
					_log("%s joins the encounter." % ice["def"]["name"])
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
	if ex.has("cred_per_cloak_played"):
		amount = int(ex["cred_per_cloak_played"]) * cloak_played_this_turn
	if has_in_play("long_game") and run.trace < 10:
		amount += 2
	if run.has_ghostware("money_mule"):
		amount = int(ceil(amount * 1.25))
	_extract(amount, card_name(inst), "extraction")
	if int(ex.get("trace_per_extract", 0)) > 0:
		add_trace(int(ex["trace_per_extract"]), false)


func _extract(amount: int, source: String, category: String) -> void:
	var got: int = min(amount, reserve)
	reserve -= got
	run.gain_cred(got, category)
	cred_earned += got
	if got > 0:
		_log("%s extracts %d CRED (reserve %d left)." % [source, got, reserve])
	if reserve == 0 and not full_extraction_paid and reserve_start > 0:
		full_extraction_paid = true
		var bonus := int(ceil(reserve_start * float(db.rules["rewards"]["full_extraction_bonus"])))
		run.gain_cred(bonus, "full extraction bonus")
		cred_earned += bonus
		_log("Reserve emptied: +%d CRED bonus." % bonus)


# ------------------------------------------------------------------ card effects

func _apply_effects(effects: Array, target_ice: int, source, timing: String) -> void:
	for e in effects:
		var when := str(e.get("when", ""))
		if when != timing:
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
		"trace_block":
			trace_block_next = true
			_log("TRACE effects add nothing in the next Corporation Response.")
		"skip_corp_response":
			skip_next_response = true
			_log("The next Corporation Response will be skipped.")
		"suppress_abilities":
			suppressed_types.append(e["ice_type"])
			_log("%s abilities do nothing until the end of your turn." % e["ice_type"])
		"pulp":
			take_pulp(int(e["n"]))
		"void":
			take_void(int(e["n"]))
		"draw":
			_draw(int(e["n"]))
		"gain_bw":
			bw += int(e["n"])
			_log("+%d BW." % int(e["n"]))
		"heal":
			heal(int(e["n"]))
			_log("Heal %d. VITAE %d." % [int(e["n"]), run.vitae])
		"ice_str":
			_apply_ice_str(e, target_ice)
		"ice_str_set":
			if target_ice >= 0:
				var delta := int(e["value"]) - ice_str(target_ice)
				ice_list[target_ice]["str_mod"] += delta
				if e.get("duration", "") == "turn":
					turn_str_mods.append([target_ice, delta])
				_log("%s STR is now %d." % [ice_list[target_ice]["def"]["name"], ice_str(target_ice)])
		"break":
			_script_break(e, target_ice)
		"extract":
			_extract(int(e["n"]), card_name(source) if source != null else "Effect", "extraction")
		"infect":
			var targets: Array = range(ice_list.size()) if e.get("target", "target") == "all" else [target_ice]
			for t in targets:
				_infect(t, e["strain"], int(e["n"]))
		"double_virus":
			for strain in ice_list[target_ice]["virus"].keys():
				ice_list[target_ice]["virus"][strain] *= 2
			_log("Virus counters doubled on %s." % ice_list[target_ice]["def"]["name"])
		"copy_virus":
			var from: Dictionary = ice_list[target_ice]["virus"].duplicate()
			for i in ice_list.size():
				if i != target_ice:
					for strain in from.keys():
						_infect(i, strain, int(from[strain]))
		"cache":
			_ask_hand_cards("CACHE up to %d card(s) in your hand." % int(e["n"]), int(e["n"]), "cache", func(_i): return true)
		"tutor":
			var opts: Array = []
			for inst in draw_pile:
				if card_def(inst)["type"] == e["card_type"]:
					opts.append({"key": inst["uid"], "label": card_name(inst)})
			if opts.is_empty():
				_log("No %s in your draw pile." % e["card_type"])
			_ask("Choose a %s from your draw pile." % e["card_type"], opts, 1, 1, "tutor")
		"burn_bloatware":
			_ask_hand_cards("Choose a Bloatware in your hand to BURN.", int(e["n"]), "burn_bloatware",
					func(i): return card_def(i)["type"] == "BLOATWARE")
		"forget":
			_forget(int(e["n"]))
		"ram", "prevent_void", "deadlock", "trace_reduce_each", "redirect_insert":
			pass   # passive: checked where they apply
		_:
			_log("(Not yet implemented: effect '%s')" % e["op"])


func _apply_ice_str(e: Dictionary, target_ice: int) -> void:
	var targets: Array = []
	match str(e.get("target", "target")):
		"all", "each_ice":
			targets = range(ice_list.size())
		"choose":
			targets = [_strongest_ice()]
		_:
			if target_ice >= 0:
				targets = [target_ice]
	var n := int(e.get("n", 0))
	if e.has("n_per_10_trace"):
		n = int(e["n_per_10_trace"]) * (run.trace / 10)
	for t in targets:
		if t < 0 or (e.has("ice_type") and ice_list[t]["def"]["type"] != e["ice_type"]):
			continue
		ice_list[t]["str_mod"] += n
		_log("%s STR %+d → %d." % [ice_list[t]["def"]["name"], n, ice_str(t)])


func _strongest_ice() -> int:
	var best := -1
	var high := -1
	for i in ice_list.size():
		if ice_list[i]["broken"].has(false) and ice_str(i) > high:
			high = ice_str(i)
			best = i
	return best


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
	if ice_index < 0 or ice_index >= ice_list.size():
		return -1
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
	if ice_index < 0 or ice_index >= ice_list.size() or n <= 0:
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
			_extract(leech, "LEECH", "extraction")
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


func _burn(inst) -> void:
	burned.append(inst)
	if run.has_ghostware("recycler") and not recycler_used:
		recycler_used = true
		bw += 1
		_log("RECYCLER: +1 BW.")


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
		var to := dest
		if run.has_ghostware("ad_blocker"):
			to = "discard"
		elif has_in_play("spam_filter") and not once_per_encounter_used.get("spam_filter", false):
			once_per_encounter_used["spam_filter"] = true
			to = "discard"
		var inst: Dictionary = run.make_temp_card(card_id)
		match to:
			"hand":
				hand.append(inst)
			"discard":
				discard_pile.append(inst)
			_:
				draw_pile.insert(run.rng.randi_range(0, draw_pile.size()), inst)
		_log("The corporation INSERTs %s into your %s." % [db.cards[card_id]["name"], to.replace("_", " ")])


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


func _index_of(ice: Dictionary) -> int:
	for k in ice_list.size():
		if is_same(ice_list[k], ice):
			return k
	return -1


func _ice_index_by_id(ice_id: String) -> int:
	for i in ice_list.size():
		if ice_list[i]["id"] == ice_id:
			return i
	return -1


# ------------------------------------------------------------------ BREACH, rewards, leaving

func _layer_cleared() -> void:
	layers_cleared = layer_index + 1
	_log("== Layer %d BREACHED (Corporation Response skipped) ==" % layers_cleared)
	_ghostware_effects("breach")
	var drop := float(db.raw["caps"]["rules"]["post_breach_drop_chance"])
	if run.free_cap_slots() > 0 and run.rng.randf() < drop:
		var id: String = run.random_cap_id()
		run.gain_cap(id, false, "BREACH drop")
		_log("CAP drop: %s." % db.caps[id]["name"])
	if layers_cleared < layers.size():
		phase = PHASE_LAYER_CHOICE
		_log("Go deeper (layer %d, better card odds), or leave the Node now?" % (layers_cleared + 1))
		changed.emit()
	else:
		node_fully_cleared = true
		_offer_node_reward()


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
	if run.has_ghostware("lucky_strike"):
		picks.append("shared")
	for owner in picks:
		var id: String = run.random_card_id(run.roll_rarity(rarity_odds()), owner, options)
		if id == "":
			id = run.random_card_id("", owner, options)
		if id != "":
			options.append(id)
	return options


## card_id "" skips the reward.
func choose_reward(card_id: String) -> void:
	if phase != PHASE_REWARD:
		return
	if card_id != "":
		run.add_card(card_id)
		run.stats["cards_from_rewards"] += 1
		reward_taken = db.cards[card_id]["name"]
		_log("Added %s to your deck." % db.cards[card_id]["name"])
	reward_options.clear()
	if is_central:
		payload_options = _roll_payload()
		phase = PHASE_PAYLOAD
		_log("The payload: an encrypted data core. Choose 1 Ghostware, active immediately.")
		changed.emit()
	elif node_fully_cleared:
		completion_options = []
		for i in 2:
			completion_options.append(run.random_cap_id())
		phase = PHASE_COMPLETION
		_log("Node complete: choose a CAP (PATCHWORK isn't in this build yet).")
		changed.emit()
	else:
		_finish_node()


## cap_id "" skips. Needs a free CAP slot.
func choose_completion(cap_id: String) -> void:
	if phase != PHASE_COMPLETION:
		return
	if cap_id != "":
		if run.gain_cap(cap_id, false, "Node completion"):
			_log("Took %s." % db.caps[cap_id]["name"])
		else:
			_log("No free CAP slot.")
	completion_options.clear()
	_finish_node()


func _roll_payload() -> Array:
	var out: Array = []
	var corp_set: Array = run.ghostware_offer_pool(corporation_id)
	if not corp_set.is_empty():
		out.append(corp_set[run.rng.randi_range(0, corp_set.size() - 1)])
	var general: Array = run.ghostware_offer_pool("general")
	while out.size() < 3 and not general.is_empty():
		var g: String = general[run.rng.randi_range(0, general.size() - 1)]
		general.erase(g)
		out.append(g)
	return out


func choose_payload(ghostware_id: String) -> void:
	if phase != PHASE_PAYLOAD:
		return
	if ghostware_id != "":
		run.add_ghostware(ghostware_id)
		_log("Payload Ghostware: %s." % db.ghostware[ghostware_id]["name"])
	payload_options.clear()
	_finish_node()


func can_leave() -> bool:
	return phase == PHASE_LAYER_CHOICE and not lockdown and not is_central


func go_deeper() -> void:
	if phase != PHASE_LAYER_CHOICE:
		return
	_start_layer(layer_index + 1)


func leave_node() -> void:
	if not can_leave():
		return
	_log("You leave the Node after %d layer(s). No completion reward." % layers_cleared)
	_offer_node_reward()


func _finish_node() -> void:
	phase = PHASE_NODE_COMPLETE
	if not trace_gained_this_node and not jacked_out:
		var bonus := int(db.rules["rewards"]["clean_node_cred"])
		run.gain_cred(bonus, "clean Node bonus")
		cred_earned += bonus
		_log("Clean Node: +%d CRED." % bonus)
	ram_bonus_node = 0
	_log("== Node finished: %d CRED earned here. ==" % cred_earned)
	changed.emit()


func _check_defeat() -> bool:
	if run.vitae <= 0:
		run.vitae = 0
		phase = PHASE_DEFEAT
		choice = {}
		_log("== FLATLINED. VITAE reached 0. Run over. ==")
		changed.emit()
		return true
	return false


func _log(text: String) -> void:
	log_lines.append(text)
	if log_lines.size() > MAX_LOG:
		log_lines.pop_front()
	logged.emit(text)
