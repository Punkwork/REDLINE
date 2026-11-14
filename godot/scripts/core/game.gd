class_name Game
extends RefCounted
## REDLINE rules engine for the vertical slice. No UI code here, so it can be tested headless.
## Rules: REDLINE_CORE_RULES.md v0.2 (§2 resources, §4 turn, §5 ICE, §6 damage, §7 TRACE, §8 Nodes, §9 rewards, §10.1a Opening Node).

const MAX_TRACE := 40
const BW_PER_TURN := 4
const BASE_DRAW := 5
const BASE_RAM := 4
const START_VITAE := 30
const SAFEHOUSE_HEAL := 10
const CLEAN_NODE_BONUS := 5

var rng := RandomNumberGenerator.new()

# --- run state ---
var phase := "MAP"            # MAP, READY_RIG, PLAYER, RESPONSE, CHOICE, DEEPER, REWARD, SAFEHOUSE, SLICE_DONE, DEAD
var vitae := START_VITAE
var max_vitae := START_VITAE
var cred := 0
var trace := 0
var strikes := 0
var cortex := 0
var run_deck: Array = []      # [{uid, id}]
var next_uid := 1
var row := -1                 # last completed map row (-1 = before COOKIE BANNER)
var available: Array = [0]    # node indices selectable in row+1
var path: Array = []          # visited node ids
var seen_ice := {}            # EV-05: first sight per ICE (per save, here per run)
var entered_corp := false

# --- node / encounter state ---
var node: Dictionary = {}
var layer := 0
var layers_cleared := 0
var enc: Dictionary = {}
var draw_pile: Array = []
var hand: Array = []
var discard: Array = []
var burned: Array = []
var installed: Array = []     # [{inst, boost}]
var rack: Array = []          # protocol insts
var bw := 0
var shield := 0
var lockdown := false
var pending_black := false
var trace_gained_node := 0
var low_vitae_warned := false
var reward_options: Array = []
var reward_note := ""

# --- choices and the response queue ---
var pending: Dictionary = {}  # {kind, ...}
var response_queue: Array = []
var animate := false          # UI plays the Corporation Response step by step (PLAY-001)

# --- output for UI and NUL/REM ---
var events: Array = []        # [{t: "EV-07", ...}]
var log: Array = []

func _init(seed_value: int = -1) -> void:
	if seed_value >= 0:
		rng.seed = seed_value
	else:
		rng.randomize()

# =====================================================================
# Run setup and map
# =====================================================================

func new_run() -> void:
	run_deck.clear()
	log.clear()
	for id in CardDB.STARTER_GENERALIST:
		run_deck.append(_new_inst(id))
	vitae = START_VITAE
	max_vitae = START_VITAE
	cred = 0
	trace = 0
	strikes = 0
	cortex = 0
	row = -1
	available = [0]
	path.clear()
	phase = "MAP"
	_event("EV-01")

func _new_inst(id: String) -> Dictionary:
	var inst := {"uid": next_uid, "id": id, "cached": false}
	next_uid += 1
	return inst

func map_row(r: int) -> Array:
	return IceDB.MAP[r]

func enter_node(index: int) -> void:
	if phase != "MAP" or not available.has(index):
		return
	var r := row + 1
	node = IceDB.MAP[r][index]
	path.append(node.id)
	if not entered_corp:
		entered_corp = true
		_event("EV-03", {"corp": "HALCYON"})
	if node.kind == "SAFEHOUSE":
		phase = "SAFEHOUSE"
		_event("EV-28")
		_say("SAFEHOUSE. Choose: heal %d VITAE, or a PATCHWORK upgrade (not in this slice)." % SAFEHOUSE_HEAL)
		return
	_start_ice_node()

func safehouse_heal() -> void:
	if phase != "SAFEHOUSE":
		return
	heal(SAFEHOUSE_HEAL)
	_complete_map_step()

func _complete_map_step() -> void:
	row += 1
	if row >= IceDB.MAP.size() - 1:
		phase = "SLICE_DONE"
		_event("SLICE_DONE")
		return
	available = node.next.duplicate()
	phase = "MAP"

# =====================================================================
# ICE Nodes and encounters (Core Rules §8)
# =====================================================================

func _start_ice_node() -> void:
	layer = 0
	layers_cleared = 0
	lockdown = false
	pending_black = false
	trace_gained_node = 0
	low_vitae_warned = false
	draw_pile = []
	for c in run_deck:
		var inst := {"uid": c.uid, "id": c.id, "cached": false}
		draw_pile.append(inst)
	_shuffle(draw_pile)
	hand = []
	discard = []
	burned = []
	installed = []
	rack = []
	# READY RIG (Generalist ORIGIN): install one PROGRAM from the deck for free before the first draw.
	var options := []
	for c in draw_pile:
		if CardDB.def(c.id).type == "PROGRAM":
			options.append(c.uid)
	if options.is_empty():
		_start_encounter()
	else:
		pending = {"kind": "ready_rig", "options": options}
		phase = "READY_RIG"

func choose_ready_rig(uid: int) -> void:
	if phase != "READY_RIG":
		return
	var inst := _take_from(draw_pile, uid)
	if not inst.is_empty():
		installed.append({"inst": inst, "boost": 0, "free_used": false})
		_say("READY RIG installs %s for free." % CardDB.def(inst.id).name)
	pending = {}
	_start_encounter()

func skip_ready_rig() -> void:
	if phase != "READY_RIG":
		return
	pending = {}
	_start_encounter()

func _start_encounter() -> void:
	var L: Dictionary = node.layers[layer]
	enc = {"ice": [], "reserve": L.reserve, "reserve_start": L.reserve, "turn": 0, "breached": false,
		"bonus_paid": false, "spam_filter_used": false, "cortex_buffer_used": false, "failsafe_used": false,
		"reactive_said": false, "breaks_turn": 0, "ghost": false, "pending_discard": 0, "bw_drain": 0, "bw_drained": 0}
	for id in L.ice:
		enc.ice.append(_new_ice(id))
	if pending_black:
		pending_black = false
		_add_black_ice()
	for ice in enc.ice:
		if not seen_ice.has(ice.id):
			seen_ice[ice.id] = true
			_event("EV-05", {"ice": ice.id})
	for p in installed:
		p.boost = 0
	_start_turn()

func _new_ice(id: String) -> Dictionary:
	var d := IceDB.def(id)
	var broken := []
	var seen := []
	for s in d.subs:
		broken.append(false)
		seen.append(false)
	return {"id": id, "str_mod": 0, "bomb": false, "broken": broken, "seen": seen, "rot": 0, "responses": 0, "rainbow": -1}

# =====================================================================
# TUMBLER rotation (ROT-001): a conveyor window of `slots` over the subroutine pool.
# =====================================================================

func active_subs(i: int) -> Array:
	## Pool indices of the subroutines in this ICE's slots, in slot order. Non-TUMBLERs: all of them.
	var ice: Dictionary = enc.ice[i]
	var d := IceDB.def(ice.id)
	var out := []
	if d.type == "VOID":
		# VOID-001: response n fires subs 1..n; each is revealed when it first fires.
		for s in mini(ice.responses + 1, d.subs.size()):
			out.append(s)
		return out
	if not IceDB.is_tumbler(ice.id):
		for s in d.subs.size():
			out.append(s)
		return out
	for k in IceDB.slots(ice.id):
		out.append((ice.rot + k) % d.subs.size())
	return out

func is_active(i: int, s: int) -> bool:
	return active_subs(i).has(s)

func hidden_count(i: int) -> int:
	## Face-down subroutines outside the slots (TUMBLER) or not yet fired (VOID, beyond this response).
	var ice: Dictionary = enc.ice[i]
	return IceDB.def(ice.id).subs.size() - active_subs(i).size()

func _rotate_tumblers() -> void:
	for i in enc.ice.size():
		var ice: Dictionary = enc.ice[i]
		if IceDB.is_tumbler(ice.id) and IceDB.slots(ice.id) < IceDB.def(ice.id).subs.size():
			ice.rot = (ice.rot + 1) % IceDB.def(ice.id).subs.size()
	_mark_seen()

func _mark_seen() -> void:
	for i in enc.ice.size():
		if IceDB.def(enc.ice[i].id).type == "VOID":
			continue   # VOID subroutines are revealed only when they fire
		for s in active_subs(i):
			enc.ice[i].seen[s] = true

func deadlock_view() -> Dictionary:
	## What the Rustler knows: broken / seen DEADLOCKs, and how many subroutines are still unseen.
	var done := 0
	var seen_total := 0
	var unseen := 0
	for ice in enc.ice:
		var d := IceDB.def(ice.id)
		for s in d.subs.size():
			if not ice.seen[s]:
				unseen += 1
			elif _has_deadlock(d.subs[s]):
				seen_total += 1
				if ice.broken[s]:
					done += 1
	return {"done": done, "seen": seen_total, "unseen": unseen}

func _add_black_ice() -> void:
	for ice in enc.ice:
		if ice.id == "HOUSE_CALL":
			return
	enc.ice.push_front(_new_ice("HOUSE_CALL"))
	_mark_seen()
	_say("Black ICE HOUSE CALL joins on the left. It has no DEADLOCK.")

func is_opening() -> bool:
	return node.get("opening", false)

# =====================================================================
# Turn structure (Core Rules §4)
# =====================================================================

func _start_turn() -> void:
	enc.turn += 1
	# ROT-001: TUMBLERs rotate one step at the start of each Rustler turn after the first.
	if enc.turn > 1:
		_rotate_tumblers()
	else:
		_mark_seen()
	# DET-001: a DETAINER's −1 BW from the last Corporation Response lands on this turn.
	bw = maxi(0, BW_PER_TURN - enc.bw_drain)
	enc.bw_drained = enc.bw_drain
	if enc.bw_drain > 0:
		_say("DETAINER: −%d BW this turn." % enc.bw_drain)
	enc.bw_drain = 0
	shield = 0
	enc.breaks_turn = 0
	for p in installed:
		p.free_used = false
	enc["toolbelt_used"] = false
	for ice in enc.ice:
		ice.bomb = false
		ice.rainbow = -1
	if _rack_has("SURGE_PROTECTOR"):
		shield += 2 * _rack_count("SURGE_PROTECTOR")
	var n := draw_size()
	if enc.turn == 1 and _rack_has("READY_STANCE"):
		n += _rack_count("READY_STANCE")
	draw_cards(n)
	phase = "PLAYER"
	if is_opening() and enc.turn == 1:
		_event("EV-04", {"corp": "HALCYON"})
	# FIX-001: DISCARD subroutines resolve at the start of the Rustler's turn, after the draw.
	if enc.pending_discard > 0:
		var k: int = mini(enc.pending_discard, hand.size())
		enc.pending_discard = 0
		if k > 0:
			pending = {"kind": "discard", "n": k}
			phase = "CHOICE"
			_say("DISCARD %d: choose from your new hand." % k)

func draw_size() -> int:
	return max(1, BASE_DRAW - cortex)

func draw_cards(n: int) -> void:
	for i in n:
		if draw_pile.is_empty():
			if discard.is_empty():
				return
			draw_pile = discard
			discard = []
			_shuffle(draw_pile)
		hand.append(draw_pile.pop_back())

func ram_total() -> int:
	var t := BASE_RAM
	for p in installed:
		t += CardDB.def(p.inst.id).get("ram_bonus", 0)
	return t

func ram_used() -> int:
	var t := 0
	for p in installed:
		t += CardDB.def(p.inst.id).get("ram", 0)
	return t

func can_play(uid: int) -> Dictionary:
	if phase != "PLAYER":
		return {"ok": false, "reason": "Not your turn"}
	var inst := _find(hand, uid)
	if inst.is_empty():
		return {"ok": false, "reason": "Not in hand"}
	var d := CardDB.def(inst.id)
	if d.get("unplayable", false):
		return {"ok": false, "reason": "Can't be played"}
	if bw < d.bw:
		return {"ok": false, "reason": "Need %d BW" % d.bw}
	if d.type == "PROGRAM" and ram_used() + d.get("ram", 0) > ram_total():
		return {"ok": false, "reason": "Not enough RAM"}
	return {"ok": true, "reason": ""}

func play_card(uid: int, target: int = -1) -> bool:
	var chk := can_play(uid)
	if not chk.ok:
		_say(chk.reason)
		return false
	var inst := _find(hand, uid)
	var d := CardDB.def(inst.id)
	if d.get("target", false) and (target < 0 or target >= enc.ice.size()):
		_say("Choose an ICE for %s." % d.name)
		return false
	_take_from(hand, uid)
	bw -= d.bw
	if d.type == "BLOATWARE":
		burned.append(inst)  # SPAM: pay 1 BW to clear it
		_say("SPAM cleared.")
		return true
	if d.get("trace_cost", 0) > 0:
		add_trace(d.trace_cost, false)
	match d.type:
		"PROGRAM":
			installed.append({"inst": inst, "boost": 0, "free_used": false})
			if d.has("extract_on_install"):
				extract(d.extract_on_install)
			if d.get("ram_bonus", 0) > 0:
				_event("EV-26")
		"PROTOCOL":
			rack.append(inst)
		"SCRIPT":
			var burn := _resolve_script(inst, target)
			if pending.is_empty() or pending.get("card_uid", -1) != uid:
				if burn:
					burned.append(inst)
				else:
					discard.append(inst)
	if d.tags.has("CLOAK"):
		_reactive_cloak()
	_check_low_vitae()
	return true

func _resolve_script(inst: Dictionary, target: int) -> bool:
	match inst.id:
		"PULP_SHIELD": shield += 3
		"PROBE": enc.ice[target].str_mod -= 2
		"GHOST_SIGNAL":
			enc.ghost = true
			return true
		"HARDENED_SHELL": shield += 7
		"FLINCH":
			shield += 2
			return true
		"MIRROR":
			shield += 3
			draw_cards(1)
		"DEEP_PROBE": enc.ice[target].str_mod -= 4
		"STRESS_TEST":
			for ice in enc.ice:
				ice.str_mod -= 1
		"LOGIC_BOMB":
			enc.ice[target].bomb = true
			return true
		"DEFRAG": draw_cards(1)
		"STIM_PATCH": draw_cards(2)
		"BURST":
			bw += 1
			return true
		"SCRUB": trace = max(0, trace - 4)
		"BURN_NOTICE":
			trace = trace / 2
			return true
		"PATCH_KIT":
			heal(4)
			return true
		"PAYDAY": extract(12)
		"BALANCED_LOAD":
			shield += 2
			enc.ice[target].str_mod -= 1
		"UNINSTALLER":
			var opts := []
			for c in hand:
				if CardDB.def(c.id).type == "BLOATWARE":
					opts.append(c.uid)
			if opts.is_empty():
				draw_cards(1)
			else:
				pending = {"kind": "uninstaller", "options": opts, "card_uid": inst.uid}
				discard.append(inst)
				phase = "CHOICE"
		"FIELD_KIT":
			var progs := []
			for c in draw_pile:
				if CardDB.def(c.id).type == "PROGRAM":
					progs.append(c.uid)
			if not progs.is_empty():
				pending = {"kind": "field_kit", "options": progs, "card_uid": inst.uid}
				discard.append(inst)
				phase = "CHOICE"
	return false

func unload(uid: int) -> void:
	## Core Rules §3.1: unload a Program for 0 BW in your turn; it goes to the discard pile.
	if phase != "PLAYER":
		return
	for i in installed.size():
		if installed[i].inst.uid == uid:
			discard.append(installed[i].inst)
			installed.remove_at(i)
			return

func end_turn() -> void:
	if phase != "PLAYER":
		return
	# §4.3 end of turn: Extractors pay out; TRACER in hand adds TRACE.
	for p in installed:
		var d := CardDB.def(p.inst.id)
		if d.has("extract"):
			extract(d.extract)
	for c in hand:
		if c.id == "TRACER":
			add_trace(3, false)
	bw = 0
	for ice in enc.ice:
		ice.bomb = false
	if enc.turn >= 6 and enc.breaks_turn == 0 and not enc.breached:
		_event("EV-10")
	if enc.breached:
		_say("BREACHED: Corporation Response skipped.")
		_cleanup()
		_after_breach()
		return
	_begin_response()

# =====================================================================
# Corporation Response (Core Rules §4.4)
# =====================================================================

func response_preview() -> Array:
	## Every unbroken subroutine resolves left to right, top to bottom (ICE Design doc: response preview).
	var steps := []
	if enc.is_empty():
		return steps
	for i in enc.ice.size():
		var ice: Dictionary = enc.ice[i]
		var d := IceDB.def(ice.id)
		for s in active_subs(i):
			steps.append({"ice": i, "sub": s, "name": d.name, "effects": d.subs[s], "skipped": ice.broken[s], "hidden": not ice.seen[s]})
	return steps

func _begin_response() -> void:
	phase = "RESPONSE"
	response_queue = []
	enc["resp_void"] = []
	for st in response_preview():
		var ice: Dictionary = enc.ice[st.ice]
		st["ref"] = ice
		if not st.skipped:
			response_queue.append(st)
		if IceDB.def(ice.id).type == "VOID" and not enc.resp_void.has(ice):
			enc.resp_void.append(ice)
	if not animate:
		_continue_response()

func _continue_response() -> void:
	while not response_queue.is_empty():
		response_step()
		if phase == "DEAD":
			return
	response_finish()

func response_step() -> Dictionary:
	## PLAY-001: resolve one subroutine. The UI calls this once per flash so values change only as each fires.
	if response_queue.is_empty():
		return {}
	var st: Dictionary = response_queue.pop_front()
	st.ref.seen[st.sub] = true   # VOID: revealed as it fires
	for e in st.effects:
		_apply_effect(e)
		if phase == "DEAD":
			break
	return st

func response_finish() -> void:
	if phase == "DEAD":
		return
	for ice in enc.get("resp_void", []):
		ice.responses += 1
	enc.ghost = false
	_cleanup()
	if phase == "DEAD":
		return
	_start_turn()

func _apply_effect(e: Dictionary) -> void:
	match e.k:
		"PULP": take_pulp(e.v)
		"TRACE": add_trace(e.v, true)
		"CORTEX": add_cortex(e.v)
		"DEADLOCK": pass
		"BW_DRAIN": enc.bw_drain += e.v
		"DISCARD":
			enc.pending_discard += e.v   # FIX-001: resolves after the next draw
		"INSERT":
			for i in e.v:
				var inst := _new_inst(e.card)
				if not enc.spam_filter_used and _rack_has("SPAM_FILTER"):
					enc.spam_filter_used = true
					discard.append(inst)
				elif e.to == "draw":
					draw_pile.insert(rng.randi_range(0, draw_pile.size()), inst)
				else:
					discard.append(inst)
			_event("EV-21", {"card": e.card})

func choose(uid: int) -> void:
	## Resolve a pending choice: discard, uninstaller, field_kit.
	if pending.is_empty():
		return
	var kind: String = pending.kind
	if not pending.get("options", [uid]).has(uid) and kind != "discard":
		return
	match kind:
		"discard":
			var c := _take_from(hand, uid)
			if c.is_empty():
				return
			discard.append(c)
			pending.n -= 1
			if pending.n > 0 and not hand.is_empty():
				return
			pending = {}
			phase = "PLAYER"
			return
		"uninstaller":
			var c := _take_from(hand, uid)
			burned.append(c)
			draw_cards(1)
		"field_kit":
			var c := _take_from(draw_pile, uid)
			hand.append(c)
	pending = {}
	phase = "PLAYER"

func _cleanup() -> void:
	## §4.5: discard every card in hand that isn't CACHED.
	var keep := []
	for c in hand:
		if c.cached:
			keep.append(c)
		else:
			discard.append(c)
	hand = keep

# =====================================================================
# Breaking ICE (Core Rules §5.3)
# =====================================================================

func ice_str(i: int) -> int:
	var ice: Dictionary = enc.ice[i]
	if ice.bomb:
		return 0
	return max(0, IceDB.def(ice.id).str + ice.str_mod)

func pick_str(p: Dictionary) -> int:
	return CardDB.def(p.inst.id).pick.str + p.boost

func break_info(i: int, s: int) -> Dictionary:
	## Cheapest way to break subroutine s on ICE i from the current state, boosts included (screen rule §5.3).
	var ice: Dictionary = enc.ice[i]
	var d := IceDB.def(ice.id)
	if ice.broken[s]:
		return {"ok": false, "reason": "BROKEN"}
	if not is_active(i, s) or not ice.seen[s]:
		return {"ok": false, "reason": "HIDDEN"}
	if d.get("ability", "") == "BOOTING" and _has_deadlock(d.subs[s]) and enc.turn < 3:
		return {"ok": false, "reason": "LOCKED until turn 3"}
	var adapter := _installed_has("ADAPTER")
	var best := {}
	for p in installed:
		var cd := CardDB.def(p.inst.id)
		if not cd.has("pick"):
			continue
		var pk: Dictionary = cd.pick
		var extra := 0
		if pk.itype != "ANY" and pk.itype != d.type:
			if not adapter:
				continue
			extra = 1
		var need: int = max(0, ice_str(i) - pick_str(p))
		var boosts := int(ceil(float(need) / float(pk.boost_amt)))
		var boost_bw: int = boosts * pk.boost_cost
		if boosts > 0 and _rack_has("TOOLBELT") and not enc.toolbelt_used:
			boost_bw -= pk.boost_cost
		var brk: int = pk.break_cost
		var free := false
		if pk.get("free_first", false) and not p.free_used:
			brk = 0
			free = true
		elif pk.get("double", false) and ice.rainbow == p.inst.uid:
			brk = 0
		var cost: int = boost_bw + brk + extra
		var better: bool = best.is_empty() or cost < best.cost or (cost == best.cost and pk.get("double", false))
		if better:
			best = {"ok": true, "cost": cost, "uid": p.inst.uid, "boosts": boosts, "free": free, "reason": ""}
	if best.is_empty():
		return {"ok": false, "reason": "NO %s ICEPICK" % d.type}
	if best.cost > bw:
		best.ok = false
		best.reason = "%d BW" % best.cost
		best["short"] = true
	return best

func can_boost(uid: int) -> Dictionary:
	## FIX-002: boost an installed Icepick by hand. Boosts last until the encounter ends.
	var p := _installed_entry(uid)
	if p.is_empty() or not CardDB.def(p.inst.id).has("pick"):
		return {"ok": false, "cost": 0, "amt": 0}
	var pk: Dictionary = CardDB.def(p.inst.id).pick
	var cost: int = pk.boost_cost
	if _rack_has("TOOLBELT") and not enc.get("toolbelt_used", true):
		cost = 0
	return {"ok": phase == "PLAYER" and bw >= cost, "cost": cost, "amt": pk.boost_amt}

func boost_pick(uid: int) -> bool:
	var chk := can_boost(uid)
	if not chk.ok:
		return false
	var p := _installed_entry(uid)
	bw -= chk.cost
	p.boost += chk.amt
	if _rack_has("TOOLBELT"):
		enc.toolbelt_used = true
	return true

func break_sub(i: int, s: int) -> bool:
	if phase != "PLAYER":
		return false
	var info := break_info(i, s)
	if not info.ok:
		return false
	var p := _installed_entry(info.uid)
	var pk: Dictionary = CardDB.def(p.inst.id).pick
	var ice: Dictionary = enc.ice[i]
	bw -= info.cost
	if info.boosts > 0:
		p.boost += info.boosts * pk.boost_amt
		if _rack_has("TOOLBELT"):
			enc.toolbelt_used = true
	if info.free:
		p.free_used = true
	if pk.get("double", false):
		ice.rainbow = -1 if ice.rainbow == p.inst.uid else p.inst.uid
	if pk.get("shield_per_break", 0) > 0:
		shield += pk.shield_per_break
	ice.broken[s] = true
	enc.breaks_turn += 1
	var d := IceDB.def(ice.id)
	if _has_deadlock(d.subs[s]):
		_event("EV-06")
	if enc.breaks_turn == 3:
		_event("EV-12")
	if not enc.breached and _all_deadlocks_broken():
		enc.breached = true
		_event("EV-07")
		_say("BREACH. Press END TURN: the Corporation Response is skipped.")
	return true

func _all_deadlocks_broken() -> bool:
	for ice in enc.ice:
		var d := IceDB.def(ice.id)
		for s in d.subs.size():
			if _has_deadlock(d.subs[s]) and not ice.broken[s]:
				return false
	return true

func deadlock_count() -> Vector2i:
	var total := 0
	var done := 0
	for ice in enc.ice:
		var d := IceDB.def(ice.id)
		for s in d.subs.size():
			if _has_deadlock(d.subs[s]):
				total += 1
				if ice.broken[s]:
					done += 1
	return Vector2i(done, total)

static func _has_deadlock(effects: Array) -> bool:
	for e in effects:
		if e.k == "DEADLOCK":
			return true
	return false

# =====================================================================
# BREACH, going deeper, leaving, rewards (Core Rules §8.2, §9)
# =====================================================================

func _after_breach() -> void:
	layers_cleared = layer + 1
	if layer + 1 < node.layers.size():
		if lockdown:
			go_deeper()
			return
		phase = "DEEPER"
		_event("EV-08")
	else:
		_finish_node(true)

func go_deeper() -> void:
	if phase != "DEEPER" and not lockdown:
		return
	layer += 1
	# Between layers: Programs, Protocols and CACHED cards stay; everything else in hand is discarded.
	_cleanup()
	_start_encounter()

func leave_node() -> void:
	if phase != "DEEPER" or lockdown:
		return
	_finish_node(false)

func _finish_node(full: bool) -> void:
	if trace_gained_node == 0:
		cred += CLEAN_NODE_BONUS
		_say("Clean Node: +%d CRED." % CLEAN_NODE_BONUS)
	reward_note = "Full clear: completion reward (CAP or PATCHWORK) is not in this slice." if full else ""
	reward_options = _roll_rewards(layers_cleared)
	phase = "REWARD"
	_event("EV-27")

func _roll_rewards(cleared: int) -> Array:
	## 2 shared + 1 Rustler-specific (RUSTLER-007); each slot rolls rarity by depth (Core Rules §9.1).
	var odds := {1: [60, 30, 10], 2: [45, 40, 15], 3: [30, 45, 25]}
	var o: Array = odds.get(clamp(cleared, 1, 3))
	var out := []
	for pool in ["SHARED", "SHARED", "GENERALIST"]:
		var roll := rng.randi_range(1, 100)
		var rar := "COMMON"
		if roll > o[0] + o[1]:
			rar = "RARE"
		elif roll > o[0]:
			rar = "UNCOMMON"
		var cands := CardDB.reward_pool(pool, rar)
		for picked in out:
			cands.erase(picked)
		if cands.is_empty():
			cands = CardDB.reward_pool(pool, "COMMON")
			for picked in out:
				cands.erase(picked)
		out.append(cands[rng.randi_range(0, cands.size() - 1)])
	return out

func choose_reward(id: String) -> void:
	if phase != "REWARD":
		return
	if id != "" and reward_options.has(id):
		run_deck.append(_new_inst(id))
		_say("%s added to your deck." % CardDB.def(id).name)
	reward_options = []
	_end_ice_node()
	_complete_map_step()

func _end_ice_node() -> void:
	## Node end: everything returns to the deck; Bloatware is removed (Core Rules §3.1).
	hand = []
	draw_pile = []
	discard = []
	burned = []
	installed = []
	rack = []
	enc = {}
	lockdown = false

# =====================================================================
# Damage, healing, TRACE (Core Rules §6, §7)
# =====================================================================

func take_pulp(n: int) -> void:
	var absorbed: int = min(shield, n)
	shield -= absorbed
	vitae -= n - absorbed
	if vitae <= 0:
		vitae = 0
		phase = "DEAD"
		pending = {}
		_event("EV-35")
		return
	_check_low_vitae()

func add_cortex(n: int) -> void:
	if not enc.is_empty():
		if _rack_has("FAILSAFE") and not enc.failsafe_used:
			enc.failsafe_used = true
			return
		if _installed_has("CORTEX_BUFFER") and not enc.cortex_buffer_used:
			enc.cortex_buffer_used = true
			n -= 1
	if n > 0:
		cortex += n
		_event("EV-17")

func heal(n: int) -> void:
	vitae = min(max_vitae, vitae + n)

func _check_low_vitae() -> void:
	if vitae > 0 and vitae <= max_vitae / 4 and not low_vitae_warned:
		low_vitae_warned = true
		_event("EV-18")

func add_trace(n: int, during_response: bool) -> void:
	if during_response:
		if enc.get("ghost", false):
			enc.ghost = false
			_say("GHOST SIGNAL: TRACE %d reduced to 0." % n)
			return
		if _rack_has("PROXY_CHAIN"):
			n = max(0, n - _rack_count("PROXY_CHAIN"))
	if n <= 0:
		return
	var before := trace
	trace += n
	trace_gained_node += n
	if before < 20 and trace >= 20 and trace < MAX_TRACE:
		_event("EV-13")
	while trace >= MAX_TRACE:
		_strike()

func _strike() -> void:
	strikes += 1
	match strikes:
		1:
			trace = 20
			draw_pile.insert(rng.randi_range(0, draw_pile.size()), _new_inst("TRACER"))
			_say("TRACE STRIKE 1: a TRACER is in your draw pile for the rest of the Node.")
			_event("EV-14")
		2:
			trace = 20
			if enc.get("breached", false):
				pending_black = true
			else:
				_add_black_ice()
			_event("EV-15")
		_:
			trace = 10
			lockdown = true
			if enc.get("breached", false):
				pending_black = true
			else:
				_add_black_ice()
			_say("LOCKDOWN: you can't leave this Node early.")
			_event("EV-16")

func _reactive_cloak() -> void:
	for ice in enc.ice:
		if IceDB.def(ice.id).get("ability", "") == "CLOAK_TRACE":
			add_trace(1, false)
			if not enc.reactive_said:
				enc.reactive_said = true
				_event("EV-11")

# =====================================================================
# Extraction (Core Rules §9.2)
# =====================================================================

func extract(n: int) -> void:
	if enc.is_empty():
		return
	var amt: int = min(n, enc.reserve)
	enc.reserve -= amt
	cred += amt
	if enc.reserve == 0 and not enc.bonus_paid and enc.reserve_start > 0:
		enc.bonus_paid = true
		var bonus := int(ceil(enc.reserve_start * 0.1))
		cred += bonus
		_say("Reserve fully extracted: +%d CRED bonus." % bonus)
		_event("EV-09")

# =====================================================================
# helpers
# =====================================================================

func _event(t: String, data: Dictionary = {}) -> void:
	var e := data.duplicate()
	e["t"] = t
	events.append(e)

func _say(s: String) -> void:
	log.append(s)

func _shuffle(a: Array) -> void:
	for i in range(a.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var tmp = a[i]
		a[i] = a[j]
		a[j] = tmp

func _find(a: Array, uid: int) -> Dictionary:
	for c in a:
		if c.uid == uid:
			return c
	return {}

func _take_from(a: Array, uid: int) -> Dictionary:
	for i in a.size():
		if a[i].uid == uid:
			var c: Dictionary = a[i]
			a.remove_at(i)
			return c
	return {}

func _installed_entry(uid: int) -> Dictionary:
	for p in installed:
		if p.inst.uid == uid:
			return p
	return {}

func _installed_has(id: String) -> bool:
	for p in installed:
		if p.inst.id == id:
			return true
	return false

func _rack_has(id: String) -> bool:
	return _rack_count(id) > 0

func _rack_count(id: String) -> int:
	var n := 0
	for c in rack:
		if c.id == id:
			n += 1
	return n

func find_card(uid: int) -> Dictionary:
	for a in [hand, draw_pile, discard, burned, rack]:
		var c := _find(a, uid)
		if not c.is_empty():
			return c
	var p := _installed_entry(uid)
	return p.get("inst", {})
