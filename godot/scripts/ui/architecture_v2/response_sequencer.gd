class_name ResponseSequencer
extends Node
## CAS-001 C03 (ARCH-V2-006, Batch 3): plays the Corporation Response one subroutine at a time,
## ported from Build 12's main._play_response. Contract kept: light the key (peek), resolve exactly one
## step, repeat; then finish exactly once. Pacing as Build 12: the steps share RESPONSE_MIN_SECONDS
## (a short lead-in, then one gap per step). The sequence holds while `hold` says so (a strike or
## LOCKDOWN flyout is playing; Build 12 waited for its strike overlay), at most HOLD_MAX seconds.
## Each resolved step is reported with its effects so the screen can sound it (PLAY-002) and shake
## on PULP. Interruption-safe: a new run, cancel(), a new encounter or leaving the tree stops it
## without resolving anything further. Never resolves rules itself; every step is one controller call.

signal step_started(step: Dictionary)
signal step_resolved(effects: Array)
signal finished

const RESPONSE_MIN_SECONDS := 5.0
const HOLD_MAX := 3.0

var ctrl: EncounterController
## 0 = Build 12 pacing; any other value is the gap per step (fixtures park on a long one).
var step_seconds := 0.0
var instant := false
var hold: Callable = func() -> bool: return false
var running := false
var _epoch := 0

func run() -> void:
	if running or ctrl == null or not ctrl.response_pending(): return
	_epoch += 1
	var epoch := _epoch
	var enc_ref: Dictionary = ctrl.game.enc
	running = true
	var n: int = ctrl.game.response_queue.size()
	var gap := step_seconds if step_seconds > 0.0 else RESPONSE_MIN_SECONDS / float(n + 1)
	await _wait(gap * 0.6)
	await _hold(epoch, enc_ref)
	while _live(epoch, enc_ref) and ctrl.response_pending():
		var st: Dictionary = ctrl.game.response_queue[0]
		var effects: Array = st.get("effects", [])
		step_started.emit(ctrl.peek_response())
		await _wait(gap * 0.35)
		if not _live(epoch, enc_ref): return
		ctrl.step_response()
		step_resolved.emit(effects)
		await _hold(epoch, enc_ref)
		await _wait(gap * 0.65)
	if not _live(epoch, enc_ref): return
	await _wait(gap * 0.4)
	if not _live(epoch, enc_ref): return
	if ctrl.game.phase == "RESPONSE": ctrl.finish_response()
	running = false
	finished.emit()

func cancel() -> void:
	_epoch += 1
	running = false

func _live(epoch: int, enc_ref: Dictionary) -> bool:
	if epoch != _epoch or not is_inside_tree() or not is_same(ctrl.game.enc, enc_ref):
		if epoch == _epoch: running = false
		return false
	return true

func _hold(epoch: int, enc_ref: Dictionary) -> void:
	var held := 0.0
	while not instant and _live(epoch, enc_ref) and hold.call() and held < HOLD_MAX:
		await get_tree().process_frame
		held += get_process_delta_time()

func _wait(s: float) -> void:
	if instant or s <= 0.0 or not is_inside_tree(): return
	await get_tree().create_timer(s).timeout
