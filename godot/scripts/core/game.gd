class_name Game
extends RefCounted
## PANOPTICON rules engine for the vertical slice. No UI code here, so it can be tested headless.
## Rules: REDLINE_CORE_RULES.md v0.2 (§2 resources, §4 turn, §5 ICE, §6 damage, §7 TRACE, §8 Nodes, §9 rewards, §10.1a Opening Node).

const MAX_TRACE := 40
const BW_PER_TURN := 4
const BASE_DRAW := 6   # DRAW-001 (was 5)
const BASE_RAM := 4
const START_VITAE := 30
const SAFEHOUSE_HEAL := 10
const CLEAN_NODE_BONUS := 5

var rng := RandomNumberGenerator.new()

# --- run state ---
var pulp_stats := {"incoming": 0, "absorbed": 0, "hits": 0, "black": 0, "encounters": 0}   # playtest stats
var played := {}            # playtest stats: card id → times played
var purges_run := 0          # PURGE-001: run total, for playtest stats
var rustler := "GENERALIST"   # RUSTLER-001: GENERALIST, ECHO, RIOT or VECTOR
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
var corporation := "HALCYON"
var ghost_draw_enabled := false # DSY-001b: optional, OFF by default.
var bloat_tax_paid := 0
var node_tax_pending := false
var compiled_queue: Array = []
var compiled_owner: Dictionary = {}
var compiled_target: Dictionary = {}
var compiled_burn := false
var hold_enabled := true
var ghostware: Array[String] = []
var amp := 0
var reboots := 0
var drawing_depth := 0
var pending_reboots := 0
var draining_reboots := false

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

func new_run(who: String = "GENERALIST") -> void:
	amp = 0
	bloat_tax_paid = 0
	ghostware.clear()
	compiled_queue.clear()
	compiled_owner = {}
	compiled_target = {}
	rustler = who
	run_deck.clear()
	log.clear()
	for id in CardDB.RUSTLERS[rustler].starter:
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
	bloat_tax_paid = 0
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
	node_tax_pending = true
	amp = 1 if ghostware.has("MINIMAL_INSTALL") and footprint_band() == "GHOST" else 0
	reboots = 0
	pending_reboots = 0
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
	if rustler != "GENERALIST":
		_start_encounter()
		return
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
		"spam_filter_used": false, "cortex_buffer_used": false, "failsafe_used": false,
		"reactive_said": false, "breaks_turn": 0, "ghost": false, "pending_discard": 0, "bw_drain": 0, "bw_drained": 0,
		"trace_gained_enc": 0, "smoke": 0, "vanish": false, "blackout": false, "decoy": false, "cloak_turn": 0,
		"purge_limit": IceDB.CORPS.HALCYON.purge_limit, "purges": 0, "purged_now": false, "skipped": false}
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
	pulp_stats.encounters += 1
	if node_tax_pending:
		node_tax_pending = false
		var tax := maxi(0, footprint() - footprint_cap())
		var before_tax := trace_gained_node
		if tax > 0:
			add_trace(tax, false)
			bloat_tax_paid += trace_gained_node - before_tax
			_say("BLOAT TAX: FOOTPRINT %d / %d; +%d TRACE before Rustler modifiers." % [footprint(), footprint_cap(), tax])
	_start_turn()
	# PATIENT ZERO (VECTOR ORIGIN, VECTOR-001): choose an ICE; it starts with 1 ROT.
	if rustler == "VECTOR" and phase == "PLAYER":
		pending = {"kind": "patient_zero"}
		phase = "CHOICE"
		_say("PATIENT ZERO: choose an ICE to INFECT with 1 ROT.")

func _new_ice(id: String, definition: Dictionary = {}) -> Dictionary:
	var d := IceDB.def(id) if definition.is_empty() else definition
	var broken := []
	var seen := []
	for s in d.subs:
		broken.append(false)
		seen.append(false)
	return {"id": id, "definition": d, "str_mod": 0, "zeroed": false, "zeroed_blocked": d.str <= 0 or int(d.get("str_floor", 0)) > 0, "last_str": int(d.str), "broken": broken, "seen": seen, "rot": 0, "responses": 0, "rainbow": -1, "virus": {},
		"break_progress": d.subs.map(func(_s): return 0), "escalation": {}, "corp_turns": 0, "curves": _curves_for(d)}

func _curves_for(d: Dictionary) -> Dictionary:
	## PULP-002: each curve this ICE uses, as its own sequence (B shuffled with the run's RNG).
	var out := {}
	for sub in d.subs:
		for e in sub:
			if e.k == "PULP_CURVE" and not out.has(e.curve):
				var seq: Array = IceDB.CURVES[e.curve].seq.duplicate()
				if e.curve == "B":
					for k in range(seq.size() - 1, 0, -1):
						var j := rng.randi_range(0, k)
						var t = seq[k]
						seq[k] = seq[j]
						seq[j] = t
				out[e.curve] = seq
	return out

# =====================================================================
# TUMBLER rotation (ROT-001): a conveyor window of `slots` over the subroutine pool.
# =====================================================================

func active_subs(i: int) -> Array:
	## Pool indices of the subroutines in this ICE's slots, in slot order. Non-TUMBLERs: all of them.
	var ice: Dictionary = enc.ice[i]
	var d := ice_definition(ice)
	var out := []
	if d.type == "VOID":
		# VOID-001: response n fires subs 1..n; each is revealed when it first fires.
		for s in mini(ice.responses + 1, d.subs.size()):
			out.append(s)
		return out
	if d.type != "TUMBLER":
		for s in d.subs.size():
			out.append(s)
		return out
	for offset in d.subs.size():
		var sub: int = (ice.rot + offset) % d.subs.size()
		if not ice.broken[sub]: out.append(sub)
		if out.size() >= int(d.get("slots", d.subs.size())): break
	return out

func is_active(i: int, s: int) -> bool:
	return active_subs(i).has(s)

func hidden_count(i: int) -> int:
	## Face-down subroutines outside the slots (TUMBLER) or not yet fired (VOID, beyond this response).
	var ice: Dictionary = enc.ice[i]
	if ice_definition(ice).type == "TUMBLER": return ice.broken.count(false) - active_subs(i).size()
	return ice_definition(ice).subs.size() - active_subs(i).size()

func _rotate_tumblers() -> void:
	for i in enc.ice.size():
		var ice: Dictionary = enc.ice[i]
		var d := ice_definition(ice)
		var active := active_subs(i)
		if d.type == "TUMBLER" and ice.broken.count(false) > int(d.get("slots", d.subs.size())):
			for offset in range(1, d.subs.size() + 1):
				var candidate: int = (int(active[0]) + offset) % d.subs.size()
				if not ice.broken[candidate]:
					ice.rot = candidate
					break
	_mark_seen()

func _mark_seen() -> void:
	for i in enc.ice.size():
		if ice_definition(enc.ice[i]).type == "VOID":
			continue   # VOID subroutines are revealed only when they fire
		for s in active_subs(i):
			enc.ice[i].seen[s] = true

func deadlock_view() -> Dictionary:
	## What the Rustler knows: broken / seen DEADLOCKs, and how many subroutines are still unseen.
	var done := 0
	var seen_total := 0
	var unseen := 0
	for ice in enc.ice:
		var d := ice_definition(ice)
		for s in d.subs.size():
			if not ice.seen[s]:
				unseen += 1
			elif _has_deadlock(d.subs[s]):
				seen_total += deadlock_steps(d.subs[s])
				done += deadlock_steps(d.subs[s]) if ice.broken[s] else int(ice.break_progress[s])
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

func _roll_fortress_pulp() -> void:
	for ice in enc.ice:
		var definition := ice_definition(ice)
		if definition.type != "FORTRESS":
			continue
		var rolls := []
		for sub_index in definition.subs.size():
			if ice.broken[sub_index]:
				continue
			for effect in definition.subs[sub_index]:
				if effect.k != "PULP" or not effect.has("v"):
					continue
				var big_swing := rng.randf() < 0.30
				var swing := 3 * (1 - 2 * rng.randi_range(0, 1)) if big_swing else rng.randi_range(-2, 2)
				rolls.append({"source": effect, "value": maxi(1, int(effect.v) + swing)})
		ice["pulp_rolls"] = rolls

func _start_turn() -> void:
	enc.turn += 1
	enc["last_tags"] = []
	enc["tag_counts"] = {}
	enc["chain_draws"] = {}
	# ROT-001: TUMBLERs rotate one step at the start of each Rustler turn after the first.
	if enc.turn > 1:
		_rotate_tumblers()
	else:
		_mark_seen()
	_roll_fortress_pulp()
	# DET-001: a DETAINER's −1 BW from the last Corporation Response lands on this turn.
	bw = maxi(0, BW_PER_TURN - enc.bw_drain) + (1 if ghostware.has("ONE_TRICK") else 0)
	enc.bw_drained = enc.bw_drain
	if enc.bw_drain > 0:
		_say("DETAINER: −%d BW this turn." % enc.bw_drain)
	enc.bw_drain = 0
	# REDLINER (RIOT ORIGIN): +1 BW at the start of your turn while TRACE is 20 or more.
	if rustler == "RIOT" and trace >= 20:
		bw += 1
		_say("REDLINER: +1 BW.")
	enc.decoy = false
	enc.cloak_turn = 0
	_virus_turn()
	shield = 0
	if trace >= 20:
		shield += (2 + amp) * _rack_count("PAIN_TOLERANCE")
	enc.breaks_turn = 0
	for p in installed:
		p.free_used = false
	enc["toolbelt_used"] = false
	for ice in enc.ice:
		ice.rainbow = -1
	_sync_strengths()
	if _rack_has("SURGE_PROTECTOR"):
		shield += (2 + amp) * _rack_count("SURGE_PROTECTOR")
	var n := draw_size()
	if enc.turn == 1 and ghost_draw_enabled and footprint_band() == "GHOST":
		n += 1
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
	drawing_depth += 1
	for i in n:
		if draw_pile.is_empty():
			if discard.is_empty(): break
			draw_pile.assign(discard)
			discard.clear()
			_shuffle(draw_pile)
			_queue_reboot()
		hand.append(draw_pile.pop_back())
	drawing_depth -= 1
	if drawing_depth == 0: _drain_reboots()

func _queue_reboot() -> void:
	reboots += 1
	pending_reboots += 1
	_say("REBOOT %d." % reboots)

func force_reboot() -> void:
	draw_pile.append_array(discard)
	discard.clear()
	_shuffle(draw_pile)
	_queue_reboot()
	if drawing_depth == 0: _drain_reboots()

func _drain_reboots() -> void:
	if draining_reboots: return
	draining_reboots = true
	var guard := 0
	while pending_reboots > 0 and phase != "DEAD":
		pending_reboots -= 1
		guard += 1
		if guard > 128:
			_say("REBOOT loop safeguard reached; stop resolving the repeating trigger chain.")
			pending_reboots = 0
			break
		if ghostware.has("HEARTBEAT"): trace = maxi(0, trace - 2)
		for ice in enc.ice.duplicate():
			match ice_definition(ice).get("ability", ""):
				"REBOOT_SPAM": _apply_effect({"k": "INSERT", "card": "SPAM", "to": "draw", "v": 1})
				"REBOOT_FORGET": _apply_effect({"k": "FORGET", "v": 1})
		for card in rack.duplicate():
			match card.id:
				"WARM_BOOT": shield += 5 + amp
				"ROLLING_RESTART": amp += 1
				"SHORT_LOOP":
					bw += 1 + amp
					draw_cards(2 + amp)
		_sync_strengths()
	draining_reboots = false

func finish_scan() -> void:
	_finish_scan()
	_resume_compiled()

func _finish_scan() -> void:
	if pending.get("kind", "") != "scan": return
	var top: Array = pending.cards
	var bottom: Array = []
	for uid in pending.bottom:
		bottom.append(_take_from(top, uid))
	bottom.reverse()
	top.reverse()
	draw_pile = bottom + draw_pile + top
	pending = {}
	phase = "PLAYER"
	draw_cards(1)

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
	if (inst.id == "GARBAGE_COLLECT" or d.get("compiled", []).has("GARBAGE_COLLECT")) and hand.size() < 2:
		return {"ok": false, "reason": "Need another hand card to BURN"}
	if d.get("unplayable", false):
		return {"ok": false, "reason": "Can't be played"}
	if bw < card_cost(inst.id):
		return {"ok": false, "reason": "Need %d BW" % card_cost(inst.id)}
	if cred < int(d.get("cred_cost", 0)):
		return {"ok": false, "reason": "Need %d CRED" % d.cred_cost}
	if d.has("target_types") and not enc.ice.any(func(ice): return d.target_types.has(ice_definition(ice).type)):
		return {"ok": false, "reason": "Need a FORTRESS or VOID target"}
	if d.has("breaker") and not d.breaker.get("same_ice", false) and _breaker_targets(d.breaker, -1).is_empty():
		return {"ok": false, "reason": "No subroutine it can break"}
	if d.has("breaker") and d.breaker.get("same_ice", false):
		var any := false
		for i in enc.ice.size():
			if not _breaker_targets(d.breaker, i).is_empty():
				any = true
		if not any:
			return {"ok": false, "reason": "No ICE at STR 0 with a subroutine to break" if d.breaker.has("max_str") else "No ICE with 5+ virus counters"}
	if inst.id == "FLASHPOINT" and _flashpoint_targets().is_empty():
		return {"ok": false, "reason": "No ICE at STR 3 or less"}
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
	if d.has("target_type") and ice_definition(enc.ice[target]).type != d.target_type:
		_say("%s needs a %s." % [d.name, d.target_type])
		return false
	if d.has("target_types") and not d.target_types.has(ice_definition(enc.ice[target]).type):
		_say("Choose a FORTRESS or VOID for %s." % d.name)
		return false
	if d.has("breaker") and d.breaker.get("same_ice", false) and (target < 0 or _breaker_targets(d.breaker, target).is_empty()):
		_say("Choose an ICE at STR 0." if d.breaker.has("max_str") else "Choose an ICE with 5 or more virus counters.")
		return false
	for part_id in d.get("compiled", []):
		var part := CardDB.def(part_id)
		if part.has("target_types") and not part.target_types.has(ice_definition(enc.ice[target]).type): return false
		if part.has("target_type") and part.target_type != ice_definition(enc.ice[target]).type: return false
	_take_from(hand, uid)
	inst["previous_tags"] = enc.get("last_tags", []).duplicate()
	inst["chain_active"] = enc.get("last_tags", []).has(d.get("chain", ""))
	enc["last_tags"] = d.tags.duplicate()
	for tag in d.tags:
		enc.tag_counts[tag] = int(enc.tag_counts.get(tag, 0)) + 1
	played[inst.id] = int(played.get(inst.id, 0)) + 1
	bw -= card_cost(inst.id)
	cred -= int(d.get("cred_cost", 0))
	if d.type == "BLOATWARE":
		burned.append(inst)  # SPAM: pay 1 BW to clear it
		_say("SPAM cleared.")
		return true
	var target_ref: Dictionary = enc.ice[target] if target >= 0 and target < enc.ice.size() else {}
	if d.get("trace_cost", 0) > 0:
		add_trace(d.trace_cost, false)
	if not target_ref.is_empty():
		target = enc.ice.find(target_ref)
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
			if d.has("compiled"):
				compiled_owner = inst
				compiled_target = target_ref
				compiled_queue = d.compiled.duplicate()
				compiled_burn = false
				_resume_compiled()
				return true
			var burn := _resolve_script(inst, target)
			if pending.is_empty() or pending.get("card_uid", -1) != uid:
				if burn:
					burned.append(inst)
				else:
					discard.append(inst)
	if inst.get("chain_active", false): _chain_bonus()
	if d.tags.has("CLOAK"):
		enc.cloak_turn += 1
		_reactive_cloak()
	_check_low_vitae()
	return true

func _resolve_script(inst: Dictionary, target: int) -> bool:
	match inst.id:
		"ZERO_FOOTPRINT":
			trace = maxi(0, trace - mini(10, maxi(0, footprint_cap() - footprint())))
			return true
		"STACK_SMASH": reduce_ice_str(target, int(enc.tag_counts.get("EXPLOIT", 0)))
		"FLATLINE", "KNOCKOUT", "SECOND_WIND":
			if reduce_ice_str(target, int(CardDB.def(inst.id).zeroed_reduction)):
				match inst.id:
					"FLATLINE": trace = maxi(0, trace - 4)
					"SECOND_WIND": bw += 1
					"KNOCKOUT":
						var br := {"same_ice": true}
						if not _breaker_targets(br, target).is_empty():
							pending = {"kind": "card_break", "n": 1, "ice": target, "breaker": br, "card_uid": inst.uid, "card": "KNOCKOUT"}
							discard.append(inst)
							phase = "CHOICE"
		"CULL":
			if virus_total(target) > 0:
				pending = {"kind": "cull", "ice_ref": enc.ice[target], "n": 3, "card_uid": inst.uid}
				discard.append(inst)
				phase = "CHOICE"
		"HARVEST":
			extract(3 * int(enc.ice[target].virus.get("LEECH", 0)))
			enc.ice[target].virus.erase("LEECH")
		"PIVOT": reduce_ice_str(target, 3 if inst.get("chain_active", false) else 2)
		"COVER_FIRE": shield += 5 if inst.get("chain_active", false) else 3
		"HANDOFF":
			trace = maxi(0, trace - 2)
			if inst.get("chain_active", false): draw_cards(1)
		"FORCE_REBOOT":
			force_reboot()
			return true
		"PORT_SCAN":
			var cards := []
			for _i in mini(3, draw_pile.size()): cards.append(draw_pile.pop_back())
			pending = {"kind": "scan", "cards": cards, "bottom": [], "card_uid": inst.uid}
			discard.append(inst)
			phase = "CHOICE"
		"GARBAGE_COLLECT":
			pending = {"kind": "burn_hand", "options": hand.map(func(c): return c.uid), "card_uid": inst.uid}
			discard.append(inst)
			phase = "CHOICE"
		"TAIL_CALL":
			var opts := discard.filter(func(c): return CardDB.def(c.id).type == "SCRIPT").map(func(c): return c.uid)
			if not opts.is_empty():
				pending = {"kind": "retrieve", "options": opts, "card_uid": inst.uid}
				discard.append(inst)
				phase = "CHOICE"
		"PULP_SHIELD": shield += 3
		"PROBE": reduce_ice_str(target, 2)
		# ECHO
		"SMOKESCREEN":
			shield += 2
			enc.smoke = 2
		"DEAD_AIR":
			var opts := []
			for c in hand:
				if not c.cached:
					opts.append(c.uid)
			if not opts.is_empty():
				pending = {"kind": "cache", "options": opts, "card_uid": inst.uid}
				discard.append(inst)
				phase = "CHOICE"
		"MUFFLE": trace = maxi(0, trace - 2)
		"GHOST_STEP": draw_cards(2)
		"PATIENCE": shield += 4 if enc.trace_gained_enc == 0 else 2
		"DECOY_SIGNAL": enc.decoy = true
		"VANISH":
			enc.vanish = true
			return true
		"BLACKOUT":
			enc.blackout = true
			return true
		# RIOT
		"OVERLOAD": reduce_ice_str(target, 2)
		"FEEDBACK": reduce_ice_str(target, trace / 10)
		"ADRENAL_SPIKE": bw += 1
		"LAY_LOW": trace = maxi(0, trace - 3)
		"SMASH": reduce_ice_str(target, 4)
		"ROAR": draw_cards(2)
		"CRASH_CART":
			trace = maxi(0, trace - 3)
			shield += 2
		"FLASHPOINT":
			var refs := []
			for st in _flashpoint_targets():
				refs.append([enc.ice[st.x], st.y])
			for r in refs:
				var idx: int = enc.ice.find(r[0])
				if idx >= 0 and sub_breakable(idx, r[1]):
					_do_break(idx, r[1])
		"NO_WITNESSES":
			if trace >= 30:
				trace = 10
			return true
		# VECTOR
		"INJECT", "SCRAMBLER", "BLINDFOLD", "LEECHWARE", "WORMHOLE", "COCKTAIL":
			var inf: Dictionary = CardDB.def(inst.id).infect
			for k in inf:
				infect(target, k, inf[k])
		"OUTBREAK":
			var vv: Dictionary = enc.ice[target].virus
			for k in vv.keys():
				vv[k] = vv[k] * 2
		"PANDEMIC":
			var src: Dictionary = enc.ice[target].virus.duplicate()
			for j in enc.ice.size():
				if j != target:
					for k in src:
						infect(j, k, src[k])
		"QUARANTINE": shield += mini(6, virus_total(target))
		"SHATTER":
			enc["shatter_ice"] = enc.ice[target]
			_say("SHATTER: SLEDGE can break %s this turn." % ice_definition(enc.ice[target]).name)
		"BORROWED_CREDENTIALS":
			if not enc.has("borrowed_ice"):
				enc.borrowed_ice = []
			if not enc.borrowed_ice.any(func(ice): return is_same(ice, enc.ice[target])):
				enc.borrowed_ice.append(enc.ice[target])
			_say("BORROWED CREDENTIALS: HUSH can break %s this turn." % ice_definition(enc.ice[target]).name)
		"BRUTE_FORCE", "RUNTIME_ERROR", "HOST_TAKEOVER", "NULL_POINTER":
			var br: Dictionary = CardDB.def(inst.id).breaker
			if _breaker_targets(br, target if br.get("same_ice", false) else -1).is_empty(): return false
			pending = {"kind": "card_break", "n": br.n, "ice": target if br.get("same_ice", false) else -1,
				"breaker": br, "card_uid": inst.uid, "card": CardDB.def(inst.id).name}
			if inst.id == "NULL_POINTER": burned.append(inst)
			else: discard.append(inst)
			phase = "CHOICE"
			return inst.id == "NULL_POINTER"
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
		"DEEP_PROBE": reduce_ice_str(target, 4)
		"STRESS_TEST":
			for i in enc.ice.size():
				reduce_ice_str(i, 1)
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
			reduce_ice_str(target, 1)
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

func can_uninstall_cache(uid: int) -> Dictionary:
	if phase != "PLAYER":
		return {"ok": false, "reason": "Not your turn"}
	var program := _installed_entry(uid)
	if program.is_empty() or not CardDB.def(program.inst.id).get("uninstall_cache", false):
		return {"ok": false, "reason": "SMASH & GRAB must be installed"}
	if bw < 1:
		return {"ok": false, "reason": "Need 1 BW"}
	if hand.filter(func(c): return c.uid != uid).is_empty():
		return {"ok": false, "reason": "Need another card in hand to CACHE"}
	return {"ok": true, "reason": ""}

func uninstall_cache(uid: int) -> bool:
	if not can_uninstall_cache(uid).ok:
		return false
	var options := hand.filter(func(c): return c.uid != uid).map(func(c): return c.uid)
	bw -= 1
	unload(uid)
	# Two end-turn checkpoints: the activation turn, then the next Rustler
	# turn. Count turns, not enc.turn, which restarts at each ICE layer.
	pending = {"kind": "cache", "options": options, "cache_turns": 2,
		"title": "SMASH & GRAB", "description": "Choose another card in your hand. CACHE expires at the end of your next Rustler turn."}
	phase = "CHOICE"
	_say("SMASH & GRAB uninstalled for 1 BW. Choose a hand card to CACHE.")
	return true

func _expire_temporary_cache() -> void:
	for card in hand:
		if not card.has("cache_turns"):
			continue
		card.cache_turns -= 1
		if card.cache_turns <= 0:
			card.cached = false
			card.erase("cache_turns")
			_say("%s: temporary CACHE expires." % CardDB.def(card.id).name)

func end_turn() -> void:
	if phase != "PLAYER": return
	var options := hand.filter(func(c): return not c.cached or c.has("cache_turns")).map(func(c): return c.uid)
	if hold_enabled and not node.get("training", false) and not str(node.get("id", "")).begins_with("TRAINING") and not options.is_empty():
		pending = {"kind": "hold", "options": options, "n": 2 if ghostware.has("DEAD_MANS_POCKET") else 1}
		phase = "CHOICE"
		return
	_end_turn_effects()

func _end_turn_effects() -> void:
	# §4.3 end of turn: Extractors pay out; TRACER in hand adds TRACE.
	var long_game: int = 2 * _rack_count("LONG_GAME") if trace < 10 else 0
	for p in installed:
		var d := CardDB.def(p.inst.id)
		if d.has("extract"):
			var amt: int = d.extract + amp
			if d.has("extract_quiet") and enc.trace_gained_enc == 0:
				amt = d.extract_quiet + amp
			extract(amt + long_game)
			if d.get("extract_trace", 0) > 0 and trace < d.get("extract_trace_below", 9999):
				add_trace(d.extract_trace, false)
		elif p.inst.id == "SILENT_PARTNER":
			if enc.cloak_turn > 0:
				extract(2 * enc.cloak_turn + amp + long_game)
	for c in hand:
		if c.id == "TRACER":
			add_trace(3, false)
	_expire_temporary_cache()
	enc.erase("borrowed_ice")
	bw = 0
	# SHATTER's price: SLEDGE drops to STR 0 for the rest of the encounter.
	if enc.get("shatter_ice") != null:
		enc.shatter_ice = null
		for p in installed:
			if p.inst.id == "SLEDGE":
				p.boost = -CardDB.def("SLEDGE").pick.str
		_say("SHATTER: SLEDGE drops to STR 0.")
	_sync_strengths()
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
		var d := ice_definition(ice)
		for s in active_subs(i):
			steps.append({"ice": i, "sub": s, "name": d.name, "effects": d.subs[s], "skipped": ice.broken[s], "hidden": not ice.seen[s]})
	return steps

func _begin_response() -> void:
	phase = "RESPONSE"
	response_queue = []
	enc["resp_void"] = []
	# PURGE-001: too many virus counters, so the corporation spends its turn purging them.
	var total := 0
	for i in enc.ice.size():
		total += virus_total(i)
	if total > 0 and total >= enc.purge_limit:
		_purge(total)
		if not animate:
			response_finish()
		return
	if enc.blackout:
		enc.blackout = false
		enc.skipped = true
		_say("BLACKOUT: the Corporation Response is skipped.")
		if not animate:
			response_finish()
		return
	for st in response_preview():
		var ice: Dictionary = enc.ice[st.ice]
		st["ref"] = ice
		if not st.skipped:
			response_queue.append(st)
		if ice_definition(ice).type == "VOID" and not enc.resp_void.has(ice):
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
		_apply_effect(effect_value(st.ref, e))
		var key := escalation_key(st.ref, e)
		if key != "": st.ref.escalation[key] = int(st.ref.escalation.get(key, 0)) + 1
		if phase == "DEAD":
			break
	return st

func response_finish() -> void:
	if phase == "DEAD":
		return
	for ice in enc.get("resp_void", []):
		ice.responses += 1
	# HARDENING: +1 STR after each Corporation Response, up to +3 (a PURGE or BLACKOUT turn isn't a response).
	if not enc.skipped:
		for ice in enc.ice:
			ice.corp_turns += 1   # PULP-002: curves advance one step per Corporation Response
	for ice in ([] if enc.skipped else enc.ice):
		if ice_definition(ice).get("passive", "") == "HARDENING" and ice.get("harden", 0) < 3:
			ice["harden"] = ice.get("harden", 0) + 1
	_sync_strengths()
	enc.ghost = false
	enc.smoke = 0
	enc.vanish = false
	enc.skipped = false
	enc.purged_now = false
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
		"FORGET":
			for _n in int(e.v):
				var opts := hand.filter(func(c): return not c.cached)
				if opts.is_empty(): break
				var card: Dictionary = opts[rng.randi_range(0, opts.size() - 1)]
				draw_pile.push_front(_take_from(hand, card.uid))
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
	_choose(uid)
	_resume_compiled()

func _choose(uid: int) -> void:
	## Resolve a pending choice: discard, uninstaller, field_kit.
	if pending.is_empty():
		return
	var kind: String = pending.kind
	if kind == "hold":
		if uid != -1:
			if not pending.options.has(uid): return
			var card := _find(hand, uid)
			if card.is_empty(): return
			card.cached = true
			card.erase("cache_turns")
			pending.options.erase(uid)
			pending.n -= 1
			if pending.n > 0 and not pending.options.is_empty(): return
		pending = {}
		phase = "PLAYER"
		_end_turn_effects()
		return
	if kind == "scan":
		if pending.cards.any(func(c): return c.uid == uid):
			if pending.bottom.has(uid): pending.bottom.erase(uid)
			else: pending.bottom.append(uid)
		return
	if not pending.get("options", [uid]).has(uid) and kind != "discard":
		return
	match kind:
		"burn_hand":
			var card := _take_from(hand, uid)
			if card.is_empty(): return
			burned.append(card)
			draw_cards(1)
		"retrieve":
			var card := _take_from(discard, uid)
			if card.is_empty(): return
			hand.append(card)
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
		"cache":
			var cc := _find(hand, uid)
			if cc.is_empty():
				return
			if pending.has("cache_turns"):
				# Do not shorten an already indefinite CACHE effect.
				if not cc.cached or cc.has("cache_turns"):
					cc.cache_turns = maxi(int(cc.get("cache_turns", 0)), int(pending.cache_turns))
			else:
				cc.erase("cache_turns")
			cc.cached = true
			_say("%s is CACHED." % CardDB.def(cc.id).name)
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

func _strength_floor(ice: Dictionary) -> int:
	return maxi(0, int(ice.get("str_floor", ice_definition(ice).get("str_floor", 0))))

func _raw_strength(i: int) -> int:
	var ice: Dictionary = enc.ice[i]
	var value: int = ice_definition(ice).str + ice.str_mod + ice.get("harden", 0)
	return value

func ice_str(i: int) -> int:
	var ice: Dictionary = enc.ice[i]
	var floor_value := _strength_floor(ice)
	var rot: int = int(ice.virus.get("ROT", 0))
	return maxi(floor_value, _raw_strength(i) - rot - (amp if rot > 0 else 0))

func _sync_strengths() -> void:
	# Ordinary reductions cannot leave hidden debt. ROT counters are retained separately.
	for i in enc.ice.size():
		var ice: Dictionary = enc.ice[i]
		var floor_value := _strength_floor(ice)
		if _raw_strength(i) < floor_value:
			ice.str_mod += floor_value - _raw_strength(i)
		var current := ice_str(i)
		if int(ice.get("last_str", current)) > 0 and current == 0 and not ice.get("zeroed_blocked", false) and floor_value == 0:
			ice.zeroed = true
		ice.last_str = current

func would_zero(i: int, reduction: int) -> bool:
	var ice: Dictionary = enc.ice[i]
	return not ice.get("zeroed", false) and not ice.get("zeroed_blocked", false) and _strength_floor(ice) == 0 and ice_str(i) > 0 and reduction >= ice_str(i)

func reduce_ice_str(i: int, amount: int) -> bool:
	_sync_strengths()
	var triggers := would_zero(i, amount)
	enc.ice[i].str_mod -= mini(maxi(0, amount), maxi(0, ice_str(i) - _strength_floor(enc.ice[i])))
	_sync_strengths()
	return triggers

func passive(i: int) -> String:
	return ice_definition(enc.ice[i]).get("passive", "")

func pick_str(p: Dictionary) -> int:
	return CardDB.def(p.inst.id).pick.str + p.boost

func break_info(i: int, s: int, pick_uid: int = -1) -> Dictionary:
	## Cheapest way to break subroutine s on ICE i from the current state, boosts included (screen rule §5.3).
	var ice: Dictionary = enc.ice[i]
	var d := ice_definition(ice)
	if ice.broken[s]:
		return {"ok": false, "reason": "BROKEN"}
	if not is_active(i, s) or not ice.seen[s]:
		return {"ok": false, "reason": "HIDDEN"}
	if d.get("ability", "") == "BOOTING" and _has_deadlock(d.subs[s]) and enc.turn < 3:
		return {"ok": false, "reason": "LOCKED until turn 3"}
	# SEQUENCED: subroutines are broken left to right.
	if d.get("passive", "") == "SEQUENCED":
		for k in s:
			if not ice.broken[k]:
				return {"ok": false, "reason": "BREAK S%d FIRST" % (k + 1)}
	var toll: int = 1 if d.get("passive", "") == "TOLL" and not _has_deadlock(d.subs[s]) else 0
	var adapter := _installed_has("ADAPTER")
	var best := {}
	for p in installed:
		if pick_uid >= 0 and p.inst.uid != pick_uid: continue
		var cd := CardDB.def(p.inst.id)
		if not cd.has("pick"):
			continue
		var pk: Dictionary = cd.pick
		var extra := 0
		# SHATTER: SLEDGE breaks the chosen ICE whatever its type, this turn only.
		var shattered: bool = p.inst.id == "SLEDGE" and enc.get("shatter_ice") != null and is_same(enc.get("shatter_ice"), ice)
		var borrowed: bool = p.inst.id == "HUSH" and enc.get("borrowed_ice", []).any(func(target): return is_same(target, ice))
		if pk.itype != "ANY" and pk.itype != d.type and not shattered and not borrowed:
			if not adapter:
				continue
			extra = 1
		var need: int = max(0, ice_str(i) - pick_str(p))
		var boosts := int(ceil(float(need) / float(pk.boost_amt)))
		var boost_bw: int = boosts * pk.boost_cost
		if boosts > 0 and _rack_has("TOOLBELT") and not enc.toolbelt_used:
			boost_bw -= pk.boost_cost
		var margin: int = pick_str(p) + boosts * pk.boost_amt - ice_str(i)
		var brk: int = 0 if pk.has("overkill") and margin >= pk.overkill else pk.break_cost
		var free := false
		if pk.get("free_first", false) and not p.free_used:
			brk = 0
			free = true
		elif pk.get("double", false) and ice.rainbow == p.inst.uid:
			brk = 0
		var cost: int = boost_bw + brk + extra + toll
		if _rack_has("MINIMALIST") and footprint_band() == "GHOST" and enc.breaks_turn == 0: cost = 0
		var better: bool = best.is_empty() or cost < best.cost or (cost == best.cost and pk.get("double", false))
		if better:
			best = {"ok": true, "cost": cost, "uid": p.inst.uid, "boosts": boosts, "free": free, "reason": "", "margin": margin}
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

func break_sub(i: int, s: int, pick_uid: int = -1) -> bool:
	if phase != "PLAYER":
		return false
	var info := break_info(i, s, pick_uid)
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
	# Mark the break first: TRACE from the break can cause a strike that adds Black ICE on the left
	# and shifts every ICE index.
	_do_break(i, s)
	if pk.get("rot_per_break", 0) > 0:
		var v: Dictionary = ice.virus
		infect(enc.ice.find(ice), "ROT", pk.rot_per_break)
	if pk.get("trace_per_break", 0) > 0:
		add_trace(pk.trace_per_break, false)
	return true

func _do_break(i: int, s: int) -> bool:
	## What happens whenever a subroutine breaks, by Icepick or by card.
	var ice: Dictionary = enc.ice[i]
	ice.break_progress[s] += 1
	ice.broken[s] = ice.break_progress[s] >= deadlock_steps(ice_definition(ice).subs[s])
	if ice.broken[s] and ice_definition(ice).type == "TUMBLER":
		var showing := active_subs(i)
		if not showing.is_empty(): ice.rot = showing[0]
		_mark_seen() # Tumbled-in subs are active and face up before any next choice/preview.
	_sync_strengths()
	enc.breaks_turn += 1
	var d := ice_definition(ice)
	if _has_deadlock(d.subs[s]):
		_event("EV-06")
	if enc.breaks_turn == 3:
		_event("EV-12")
	if not enc.breached and _all_deadlocks_broken():
		enc.breached = true
		_event("EV-07")
		_say("BREACH. Press END TURN: the Corporation Response is skipped.")
	if d.get("passive", "") == "TRIPWIRE":
		add_trace(1, false)
	return true

func _all_deadlocks_broken() -> bool:
	for ice in enc.ice:
		var d := ice_definition(ice)
		for s in d.subs.size():
			if _has_deadlock(d.subs[s]) and not ice.broken[s]:
				return false
	return true

func deadlock_count() -> Vector2i:
	var total := 0
	var done := 0
	for ice in enc.ice:
		var d := ice_definition(ice)
		for s in d.subs.size():
			if _has_deadlock(d.subs[s]):
				total += deadlock_steps(d.subs[s])
				done += deadlock_steps(d.subs[s]) if ice.broken[s] else int(ice.break_progress[s])
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
	# CORE-011: leaving before the final layer forfeits the card reward.
	# Do not roll offers, emit the reward event, or stop at a reward screen.
	reward_options = []
	reward_note = ""
	if not full:
		_say("Left the Node early: no card reward.")
		_end_ice_node()
		_complete_map_step()
		return
	reward_note = "Full clear: completion reward (CAP or PATCHWORK) is not in this slice."
	reward_options = [] if ghostware.has("ONE_TRICK") and footprint() >= footprint_cap() - 4 else _roll_rewards(layers_cleared)
	phase = "REWARD"
	_event("EV-27")

func _roll_rewards(cleared: int) -> Array:
	## 2 shared + 1 Rustler-specific (RUSTLER-007); each slot rolls rarity by depth (Core Rules §9.1).
	var odds := {1: [60, 30, 10], 2: [45, 40, 15], 3: [30, 45, 25]}
	var o: Array = reward_odds(cleared)
	var out := []
	for pool in ["SHARED", "SHARED", rustler]:
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
	if id != "" and reward_options.has(id) and not (ghostware.has("ONE_TRICK") and footprint() >= footprint_cap() - 4):
		run_deck.append(_new_inst(id))
		_say("%s added to your deck." % CardDB.def(id).name)
	reward_options = []
	_end_ice_node()
	_complete_map_step()

func _end_ice_node() -> void:
	amp = 0
	compiled_queue.clear()
	compiled_owner = {}
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

func worm_ok(i: int) -> bool:
	## VIRUS-001: on your turn, spend 2 WORM on an ICE to break one of its subroutines.
	if phase != "PLAYER" or i < 0 or i >= enc.ice.size():
		return false
	if int(enc.ice[i].virus.get("WORM", 0)) < 2:
		return false
	for s in ice_definition(enc.ice[i]).subs.size():
		if sub_breakable(i, s):
			return true
	return false

func use_worm(i: int) -> bool:
	if not worm_ok(i):
		return false
	enc.ice[i].virus.WORM = int(enc.ice[i].virus.WORM) - 2
	if enc.ice[i].virus.WORM <= 0:
		enc.ice[i].virus.erase("WORM")
	pending = {"kind": "card_break", "n": 1, "ice": i, "breaker": {"n": 1, "same_ice": true}, "card": "WORM"}
	phase = "CHOICE"
	_say("WORM: choose a subroutine on %s to break." % ice_definition(enc.ice[i]).name)
	return true

func choose_ice(i: int) -> void:
	## PATIENT ZERO's choice.
	if phase != "CHOICE" or pending.get("kind", "") != "patient_zero" or i < 0 or i >= enc.ice.size():
		return
	infect(i, "ROT", 1)
	pending = {}
	phase = "PLAYER"

func abandon() -> void:
	## RUN-001: the player ends the run; the Rustler fails.
	phase = "DEAD"
	pending = {}
	response_queue = []
	_say("Run ended. The Rustler failed.")
	_event("EV-35")

func take_pulp(n: int) -> void:
	var absorbed: int = min(shield, n)
	pulp_stats.incoming += n
	pulp_stats.absorbed += absorbed
	pulp_stats.hits += 1
	if not enc.is_empty() and enc.ice.any(func(x): return x.id == "HOUSE_CALL"):
		pulp_stats.black += n
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
	if during_response and enc.get("vanish", false):
		_say("VANISH: TRACE %d adds nothing." % n)
		return
	# LOW PROFILE (ECHO ORIGIN): every TRACE gain is 1 less.
	if rustler == "ECHO" and n > 0:
		n -= 1
	if during_response and enc.get("smoke", 0) > 0 and n > 0:
		var cut: int = mini(n, enc.smoke)
		enc.smoke = 0
		n -= cut
		_say("SMOKESCREEN: TRACE reduced by %d." % cut)
	if during_response and n > 0:
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
	if not enc.is_empty():
		enc.trace_gained_enc += n
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
	if enc.decoy:
		return
	for ice in enc.ice:
		if ice_definition(ice).get("ability", "") == "CLOAK_TRACE":
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
	# CORE-012: extraction only transfers the remaining reserve; no bonus.
	# Keep the full-extraction notification on the actual depletion event.
	if amt > 0 and enc.reserve == 0:
		_say("Reserve fully extracted.")
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
			if is_same(a, hand) and c.has("cache_turns"):
				# The duration applies only while retained in this hand, not to
				# later redraws of the same physical card after play/discard.
				c.cached = false
				c.erase("cache_turns")
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


# =====================================================================
# Rustler cards: costs, card-based breaks, viruses (RUSTLER-001..008)
# =====================================================================

func card_cost(id: String) -> int:
	var d := CardDB.def(id)
	var c: int = maxi(0, d.bw - (_rack_count("CLEAN_BUILD") if d.has("compiled") else 0))
	# BERSERK: EXPLOIT SCRIPTS cost 1 less BW while TRACE is 20 or more.
	if d.type == "SCRIPT" and d.tags.has("EXPLOIT") and trace >= 20 and _rack_has("BERSERK"):
		c = maxi(0, c - 1)
	return c

func sub_breakable(i: int, s: int) -> bool:
	## Shared limits for any break: in a slot, seen, unbroken, not BOOTING-locked, SEQUENCED order.
	var ice: Dictionary = enc.ice[i]
	var d := ice_definition(ice)
	if ice.broken[s] or not is_active(i, s) or not ice.seen[s]:
		return false
	if d.get("ability", "") == "BOOTING" and _has_deadlock(d.subs[s]) and enc.turn < 3:
		return false
	if d.get("passive", "") == "SEQUENCED":
		for k in s:
			if not ice.broken[k]:
				return false
	return true

func _breaker_ok_ice(br: Dictionary, i: int) -> bool:
	if br.has("max_str") and ice_str(i) > br.max_str:
		return false
	if br.has("min_virus") and virus_total(i) < br.min_virus:
		return false
	return true

func _breaker_targets(br: Dictionary, only_ice: int) -> Array:
	var out := []
	for i in enc.ice.size():
		if only_ice >= 0 and i != only_ice:
			continue
		if not _breaker_ok_ice(br, i):
			continue
		for s in ice_definition(enc.ice[i]).subs.size():
			if sub_breakable(i, s):
				out.append(Vector2i(i, s))
	return out

func card_break_ok(i: int, s: int) -> bool:
	if phase != "CHOICE" or pending.get("kind", "") != "card_break":
		return false
	return _breaker_targets(pending.breaker, pending.ice).has(Vector2i(i, s))

func choose_sub(i: int, s: int) -> void:
	_choose_sub(i, s)
	_resume_compiled()

func _choose_sub(i: int, s: int) -> void:
	if not card_break_ok(i, s):
		return
	var target_ref: Dictionary = enc.ice[i]
	_do_break(i, s)
	pending.n -= 1
	if pending.breaker.get("same_ice", false):
		pending.ice = enc.ice.find(target_ref)
	if pending.n <= 0 or _breaker_targets(pending.breaker, pending.ice).is_empty():
		pending = {}
		phase = "PLAYER"

func _best_sub(i: int) -> int:
	## Auto-pick for FLASHPOINT: a DEADLOCK first, then the biggest PULP, then the first breakable.
	var d := ice_definition(enc.ice[i])
	var best := -1
	var score := -1
	for s in d.subs.size():
		if not sub_breakable(i, s):
			continue
		var sc := 1
		for e in d.subs[s]:
			if e.k == "DEADLOCK":
				sc = 100
			elif e.k == "PULP":
				sc = maxi(sc, 10 + e.v)
		if sc > score:
			score = sc
			best = s
	return best

func _flashpoint_targets() -> Array:
	var out := []
	for i in enc.ice.size():
		if ice_str(i) <= 3:
			var s := _best_sub(i)
			if s >= 0:
				out.append(Vector2i(i, s))
	return out

const STRAINS := ["ROT", "SCRAMBLE", "BLIND", "LEECH", "WORM"]

func infect(i: int, strain: String, n: int) -> void:
	if i < 0 or i >= enc.ice.size() or n <= 0:
		return
	var v: Dictionary = enc.ice[i].virus
	_sync_strengths()
	v[strain] = int(v.get(strain, 0)) + n
	_sync_strengths()

func virus_total(i: int) -> int:
	var t := 0
	for k in enc.ice[i].virus:
		t += int(enc.ice[i].virus[k])
	return t

func effect_value(ice: Dictionary, e: Dictionary) -> Dictionary:
	var key := escalation_key(ice, e)
	if e.k == "PULP":
		for roll in ice.get("pulp_rolls", []):
			if is_same(roll.source, e):
				e = e.duplicate()
				e.v = roll.value
				break
	if key != "":
		e = e.duplicate()
		e.v += int(ice.escalation.get(key, 0))
	## SCRAMBLE and BLIND act when this ICE acts: each counter lowers PULP / TRACE by 1.
	var v: Dictionary = ice.get("virus", {})
	if e.k == "PULP_CURVE":
		var seq: Array = ice.curves[e.curve]
		e = {"k": "PULP", "v": int(seq[int(ice.corp_turns) % seq.size()]), "curve": e.curve}
	if e.k == "PULP" and v.get("SCRAMBLE", 0) > 0:
		var out := e.duplicate()
		out.v = maxi(0, e.v - int(v.SCRAMBLE) - amp)
		return out
	if e.k == "TRACE" and v.get("BLIND", 0) > 0:
		var out := e.duplicate()
		out.v = maxi(0, e.v - int(v.BLIND) - amp)
		return out
	return e

func _virus_turn() -> void:
	## "Your turn" strains and REPLICATOR, at the start of the Rustler's turn.
	if enc.turn > 1:
		for r in _installed_count("REPLICATOR"):
			for i in enc.ice.size():
				for k in enc.ice[i].virus.keys():
					if enc.ice[i].virus[k] > 0:
						infect(i, k, 1)
	for i in enc.ice.size():
		var l: int = int(enc.ice[i].virus.get("LEECH", 0))
		if l > 0:
			extract(l + amp)

func _installed_count(id: String) -> int:
	var n := 0
	for p in installed:
		if p.inst.id == id:
			n += 1
	return n

func _purge(total: int) -> void:
	## Remove every virus counter; INCUBATOR re-infects 2 ROT on each ICE that was purged.
	var incub := _rack_count("INCUBATOR")
	for i in enc.ice.size():
		var had := virus_total(i) > 0
		enc.ice[i].virus = {}
		if had and incub > 0:
			infect(i, "ROT", 2 * incub)
	_sync_strengths()
	enc.purges += 1
	purges_run += 1
	enc.purge_limit += IceDB.CORPS.HALCYON.purge_step
	enc.purged_now = true
	enc.skipped = true
	_say("HALCYON PURGES %d virus counters instead of taking its turn." % total)

# DSY-001/002/003/006: permanent deck analysis and pruning.
func footprint(deck: Array = []) -> int:
	if deck.is_empty(): deck = run_deck
	var count := 0
	for card in deck:
		if CardDB.def(card.id).type != "BLOATWARE": count += 1
	return count

func footprint_cap() -> int:
	return int({"HALCYON": 22, "IRONWATCH": 29, "LUCIDA": 35}.get(corporation, 22))

func footprint_band() -> String:
	if footprint() <= footprint_cap() - 6: return "GHOST"
	return "LEAN" if footprint() <= footprint_cap() else "HEAVY"

func coverage(deck: Array = []) -> Dictionary:
	if deck.is_empty(): deck = run_deck
	var result := {"FORTRESS": false, "TUMBLER": false, "VOID": false}
	var ids := deck.map(func(c): return c.id)
	var capabilities := []
	for card in deck:
		capabilities.append(card.id)
		capabilities.append_array(CardDB.def(card.id).get("compiled", []))
	for id in capabilities:
		var d := CardDB.def(id)
		if d.has("pick"):
			for kind in result:
				if d.pick.itype in [kind, "ANY"]: result[kind] = true
		if d.has("breaker") or id == "FLASHPOINT" or id == "NULL_POINTER":
			for kind in result: result[kind] = true
		if id == "BORROWED_CREDENTIALS" and ids.has("HUSH"):
			result.FORTRESS = true; result.VOID = true
		if id == "SHATTER" and ids.has("SLEDGE"):
			for kind in result: result[kind] = true
	return result

func tag_density() -> Dictionary:
	var result := {}
	for card in run_deck:
		for tag in CardDB.def(card.id).tags:
			result[tag] = int(result.get(tag, 0)) + 1
	return result

func draw_chance(id: String, extra_cards: int = 0, extra_copies: int = 0) -> float:
	# Nominal stage length 5/6/7 turns, no replacement within the estimate.
	var size := footprint() + extra_cards
	if size <= 0: return 0.0
	var copies := run_deck.filter(func(c): return c.id == id).size() + extra_copies
	var turns := int({"HALCYON": 5, "IRONWATCH": 6, "LUCIDA": 7}.get(corporation, 5))
	var draws := mini(size, draw_size() * turns)
	var miss := 1.0
	for k in draws:
		miss *= maxf(0.0, float(size - copies - k) / float(size - k))
	return 100.0 * (1.0 - miss)

func coverage_text(deck: Array = []) -> String:
	var c := coverage(deck)
	return "COVERAGE: FORTRESS %s · TUMBLER %s · VOID %s" % ["✓" if c.FORTRESS else "✗", "✓" if c.TUMBLER else "✗", "✓" if c.VOID else "✗"]

func can_decompile(uid: int) -> Dictionary:
	if footprint() <= 10: return {"ok": false, "reason": "10-card floor"}
	var card := _find(run_deck, uid)
	if card.is_empty() or CardDB.def(card.id).type == "BLOATWARE": return {"ok": false, "reason": "Not a permanent deck card"}
	var after := run_deck.filter(func(c): return c.uid != uid)
	for kind in coverage(after):
		if not coverage(after)[kind]: return {"ok": false, "reason": "Would lose " + kind + " COVERAGE"}
	return {"ok": true, "reason": ""}

func begin_decompile() -> void:
	if phase == "REWARD": phase = "DECOMPILE"

func decompile(uid: int) -> bool:
	if phase != "DECOMPILE" or not can_decompile(uid).ok: return false
	var card := _take_from(run_deck, uid)
	_say("DECOMPILE: removed " + CardDB.def(card.id).name)
	reward_options.clear()
	_end_ice_node()
	_complete_map_step()
	return true

func _chain_bonus() -> void:
	for ice in enc.ice.duplicate():
		if ice_definition(ice).get("ability", "") == "CHAIN_PULP": take_pulp(1)
	_say("CHAIN bonus.")
	for card in rack.duplicate():
		if card.id == "KILL_CHAIN" and int(enc.chain_draws.get(card.uid, 0)) < 2:
			enc.chain_draws[card.uid] = int(enc.chain_draws.get(card.uid, 0)) + 1
			draw_cards(1)

func cull_strain(strain: String = "") -> void:
	_cull_strain(strain)
	_resume_compiled()

func _cull_strain(strain: String = "") -> void:
	if phase != "CHOICE" or pending.get("kind") != "cull": return
	var v: Dictionary = pending.ice_ref.virus
	if strain != "":
		if int(v.get(strain, 0)) <= 0: return
		v[strain] -= 1
		_sync_strengths()
		shield += 2
		pending.n -= 1
	if strain == "" or pending.n == 0 or v.values().all(func(n): return n == 0):
		pending = {}
		phase = "PLAYER"

func can_compile(a_uid: int, b_uid: int) -> bool:
	var a := _find(run_deck, a_uid); var b := _find(run_deck, b_uid)
	if a.is_empty() or b.is_empty() or a.id == b.id: return false
	var da := CardDB.def(a.id); var db := CardDB.def(b.id)
	return da.type == "SCRIPT" and db.type == "SCRIPT" and not da.has("compiled") and not db.has("compiled") and da.tags.any(func(t): return db.tags.has(t))

func compile_cards(a_uid: int, b_uid: int) -> bool:
	if phase != "SAFEHOUSE" or not can_compile(a_uid, b_uid): return false
	var a := _take_from(run_deck, a_uid); var b := _take_from(run_deck, b_uid)
	run_deck.append(_new_inst("COMPILED::" + a.id + "::" + b.id))
	_complete_map_step()
	return true

func _resume_compiled() -> void:
	if compiled_owner.is_empty() or phase != "PLAYER": return
	while not compiled_queue.is_empty() and phase == "PLAYER":
		var id: String = compiled_queue.pop_front()
		var part := compiled_owner.duplicate()
		part.id = id
		var d := CardDB.def(id)
		part.chain_active = compiled_owner.get("previous_tags", []).has(d.get("chain", ""))
		compiled_burn = _resolve_script(part, enc.ice.find(compiled_target)) or compiled_burn
		# Interactive scripts temporarily park their source; keep only the combined physical card.
		_take_from(discard, part.uid); _take_from(burned, part.uid)
		if part.chain_active: _chain_bonus()
	if compiled_queue.is_empty() and phase == "PLAYER":
		if CardDB.def(compiled_owner.id).tags.has("CLOAK"):
			enc.cloak_turn += 1
			_reactive_cloak()
		if compiled_burn: burned.append(compiled_owner)
		else: discard.append(compiled_owner)
		compiled_owner = {}

static func deadlock_steps(effects: Array) -> int:
	for e in effects:
		if e.k == "DEADLOCK": return maxi(1, int(e.get("v", 1)))
	return 1

func escalation_key(ice: Dictionary, e: Dictionary) -> String:
	if not e.get("escalate", false) or not e.k in ["TRACE", "DISCARD", "FORGET"]: return ""
	var subs: Array = ice_definition(ice).subs
	for si in subs.size():
		for ei in subs[si].size():
			if is_same(subs[si][ei], e): return "%d:%d" % [si, ei]
	return ""

func reward_odds(cleared: int) -> Array:
	var depth := clampi(cleared, 1, 3)
	if node.get("tier", "T1") == "T2": depth = mini(3, cleared + 1)
	return {1: [60, 30, 10], 2: [45, 40, 15], 3: [30, 45, 25]}[depth]

func ice_definition(ice: Dictionary) -> Dictionary:
	return ice.get("definition", IceDB.def(ice.id))

func card_text(id: String) -> String:
	var d := CardDB.def(id)
	if amp == 0: return d.text
	if d.has("extract"):
		return d.text + " Current payout: %d CRED (+%d AMP)." % [int(d.extract) + amp, amp]
	match id:
		"WARM_BOOT": return "Whenever you REBOOT: +%d SHIELD (AMP included)." % (5 + amp)
		"SHORT_LOOP": return "Whenever you REBOOT: +%d BW, draw %d (AMP included)." % [1 + amp, 2 + amp]
		"SURGE_PROTECTOR", "PAIN_TOLERANCE": return d.text + " Current SHIELD: %d (AMP included)." % (2 + amp)
		"SILENT_PARTNER": return d.text + " +%d AMP per payout." % amp
	return d.text
