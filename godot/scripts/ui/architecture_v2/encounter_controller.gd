class_name EncounterController
extends RefCounted
## CAS-001 C02 (ARCH-V2-003): the single route from player intent to the rules engine for the
## Architecture V2 encounter. Every intent makes at most one mutating Game call. ICE are addressed by
## reference (is_same), never by a cached index: a strike can add Black ICE on the left and shift
## indices. Requests whose ICE is not in the current encounter are refused without touching Game.
## Presentation state kept here (active program, firing key, tumbled-in keys) never feeds rules.

signal changed
signal break_resolved(ice_ref: Dictionary, sub: int, bw_spent: int)
signal phase_changed(old_phase: String, new_phase: String)

var game: Game
## Build 12 rule: a click uses the program last used on screen, else the cheapest Icepick that can.
var active_program := -1
## {"ref": ice, "sub": int} while that subroutine fires in the Corporation Response.
var firing := {}
## Response steps already fired this response, in order ([{ref, sub}]).
var fired: Array = []
## [{"ice": ref, "turn": int, "subs": [int]}]: TUMBLER subs that rotated in this turn (Build 12 "new").
var tumbled_in: Array = []
## Count of mutating Game calls this controller has made (tests assert one per intent).
var game_calls := 0

var _enc_ref: Dictionary = {}
var _phase := ""
var _tumbler_before := []   # [[ref, active subs]]

func bind(g: Game) -> void:
	game = g
	_enc_ref = g.enc
	_phase = g.phase
	firing = {}; fired = []; tumbled_in = []

## True while the bound encounter is still the Game's current one.
func is_current() -> bool:
	return game != null and not game.enc.is_empty() and is_same(game.enc, _enc_ref)

func rebind_if_new_encounter() -> bool:
	if game != null and not game.enc.is_empty() and not is_same(game.enc, _enc_ref):
		bind(game)
		return true
	return false

func ice_index(ice_ref: Dictionary) -> int:
	if not is_current(): return -1
	for i in game.enc.ice.size():
		if is_same(game.enc.ice[i], ice_ref): return i
	return -1

func active_pick() -> int:
	var p: Dictionary = game._installed_entry(active_program)
	return active_program if not p.is_empty() and CardDB.def(p.inst.id).has("pick") else -1

## What breaking this subroutine would take, as Build 12 shows it on the key's chip. Read-only.
func break_preview(i: int, sub: int) -> Dictionary:
	if game.phase == "CHOICE" and game.pending.get("kind") == "card_break":
		return {"ok": game.card_break_ok(i, sub), "reason": "normal break limits", "cost": 0}
	if game.phase != "PLAYER": return {"ok": false, "reason": "Not your turn", "cost": 0}
	var pick := active_pick()
	if pick >= 0:
		var mine := game.break_info(i, sub, pick)
		if mine.ok: return mine
	return game.break_info(i, sub)

## The one break route for click, keyboard and drop. pick_uid < 0 means "the program the click would
## use" (Build 12 break_action); a dragged program passes its own uid (Build 12 _drop_data).
func request_break(ice_ref: Dictionary, sub: int, pick_uid: int = -1) -> bool:
	var i := ice_index(ice_ref)
	if i < 0 or sub < 0 or sub >= ice_ref.broken.size(): return false
	if game.phase == "CHOICE" and game.pending.get("kind") == "card_break":
		game_calls += 1
		game.choose_sub(i, sub)
		_after()
		return true
	if game.phase != "PLAYER": return false
	var uid := pick_uid
	if uid < 0:
		var info := break_preview(i, sub)
		if info.get("ok", false) and info.has("uid"):
			uid = int(info.uid)
			active_program = uid
	var before: int = int(ice_ref.break_progress[sub])
	var bw_before := game.bw
	game_calls += 1
	var ok := game.break_sub(i, sub, uid)
	if ok and int(ice_ref.break_progress[sub]) > before:
		break_resolved.emit(ice_ref, sub, bw_before - game.bw)
	_after()
	return ok

func request_play(uid: int, ice_ref: Variant = null) -> bool:
	## Cards are batch 2 (C10–C12); the sandbox uses this for its plain dev hand.
	var target := -1
	if ice_ref is Dictionary:
		target = ice_index(ice_ref)
		if target < 0: return false
	if game.phase != "PLAYER": return false
	game_calls += 1
	var ok := game.play_card(uid, target)
	_after()
	return ok

func request_choice(uid: int) -> bool:
	if game.phase != "CHOICE" and game.phase != "READY_RIG": return false
	game_calls += 1
	if game.phase == "READY_RIG": game.choose_ready_rig(uid)
	else: game.choose(uid)
	_after()
	return true

## Choice-overlay secondary intents (C15): READY RIG skip, SCAN finish, CULL strain/finish.
func request_skip_ready_rig() -> bool:
	if game.phase != "READY_RIG": return false
	game_calls += 1
	game.skip_ready_rig()
	_after()
	return true

func request_finish_scan() -> bool:
	if game.phase != "CHOICE" or game.pending.get("kind") != "scan": return false
	game_calls += 1
	game.finish_scan()
	_after()
	return true

func request_cull(strain: String = "") -> bool:
	if game.phase != "CHOICE" or game.pending.get("kind") != "cull": return false
	game_calls += 1
	game.cull_strain(strain)
	_after()
	return true

# ----- Program actions from the CRT (ARCH-V2-003w; Build 12's rig actions). One Game call each.

func request_boost(uid: int) -> bool:
	if game.phase != "PLAYER" or not game.can_boost(uid).get("ok", false): return false
	game_calls += 1
	var ok := game.boost_pick(uid)
	if ok: active_program = uid
	_after()
	return ok

func request_uninstall_cache(uid: int) -> bool:
	if not game.can_uninstall_cache(uid).get("ok", false): return false
	game_calls += 1
	var ok := game.uninstall_cache(uid)
	_after()
	return ok

func request_unload(uid: int) -> bool:
	if game.phase != "PLAYER" or game._installed_entry(uid).is_empty(): return false
	game_calls += 1
	game.unload(uid)
	if active_program == uid: active_program = -1
	_after()
	return true

# ----- Corporation Response: the existing Game step/finish contract, driven one call at a time.

## CAPS-TEST-001: inject a CAP (one Game call). CRACKER needs an ICE.
func request_use_cap(uid: int, ice_ref: Variant = null) -> bool:
	var target := -1
	if ice_ref is Dictionary:
		target = ice_index(ice_ref)
		if target < 0: return false
	if game.phase != "PLAYER": return false
	game_calls += 1
	var ok := game.use_cap(uid, target)
	_after()
	return ok

## ARCH-V2-008b / RUN-001: the player ends the run (only between plays on their own turn or a choice).
func end_run() -> bool:
	if not (game.phase in ["PLAYER", "CHOICE", "READY_RIG"]): return false
	game_calls += 1
	game.abandon()
	_after()
	return true

func end_turn() -> bool:
	if game.phase != "PLAYER" or not is_current(): return false
	game_calls += 1
	game.end_turn()
	firing = {}; fired = []
	_after()
	return true

## ARCH-V2-007c: PATIENT ZERO (VECTOR ORIGIN): infect the chosen ICE with 1 ROT. One Game call.
func request_choose_ice(ice_ref: Dictionary) -> bool:
	var i := ice_index(ice_ref)
	if i < 0 or game.phase != "CHOICE" or game.pending.get("kind", "") != "patient_zero": return false
	game_calls += 1
	game.choose_ice(i)
	_after()
	return true

func response_pending() -> bool:
	return game.phase == "RESPONSE" and not game.response_queue.is_empty()

## Marks the next queued subroutine as firing without resolving it (lets the view light the key first).
func peek_response() -> Dictionary:
	if not response_pending(): return {}
	var st: Dictionary = game.response_queue[0]
	firing = {"ref": st.ref, "sub": st.sub}
	changed.emit()
	return firing

## Resolves exactly one queued subroutine. Returns the step ({} when nothing was queued).
func step_response() -> Dictionary:
	if not response_pending(): return {}
	var st: Dictionary = game.response_queue[0]
	firing = {"ref": st.ref, "sub": st.sub}
	game_calls += 1
	var done := game.response_step()
	fired.append(firing.duplicate())
	_after()
	return done

## Ends the response once the queue is empty. Records TUMBLER keys that rotated in (Build 12 "new").
func finish_response() -> bool:
	if game.phase != "RESPONSE" or not game.response_queue.is_empty(): return false
	_tumbler_before = []
	for i in game.enc.ice.size():
		if IceDB.is_tumbler(game.enc.ice[i].id):
			_tumbler_before.append([game.enc.ice[i], game.active_subs(i).duplicate()])
	game_calls += 1
	game.response_finish()
	firing = {}; fired = []
	tumbled_in = []
	if is_current():
		for pair in _tumbler_before:
			var i := ice_index(pair[0])
			if i < 0: continue
			var now: Array = game.active_subs(i)
			var fresh := now.filter(func(s): return not pair[1].has(s))
			if not fresh.is_empty(): tumbled_in.append({"ice": pair[0], "turn": game.enc.turn, "subs": fresh})
	_after()
	return true

func tumbled_subs(ice_ref: Dictionary) -> Array:
	for item in tumbled_in:
		if is_same(item.ice, ice_ref) and item.turn == game.enc.turn: return item.subs
	return []

func is_firing(ice_ref: Dictionary, sub: int) -> bool:
	return not firing.is_empty() and is_same(firing.ref, ice_ref) and firing.sub == sub

func _after() -> void:
	if game.phase != _phase:
		var old := _phase
		_phase = game.phase
		phase_changed.emit(old, _phase)
	changed.emit()
