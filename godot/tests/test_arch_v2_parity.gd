extends SceneTree
## ARCH-V2-007e: behaviour comparison for RELEASE-002c. The rules engine (godot/scripts/core, godot/data)
## is byte-identical to `prototype-baseline` (21922ad; checked with git diff when this test was written),
## so the comparison is of the paths: a deterministic bot plays seeded encounters through the whole V2
## screen (card clicks and drops, key clicks, choice overlay, END TURN with the ResponseSequencer) and,
## on a twin Game with the same seed, through Build 12's direct calls. After every action the two
## games must be identical (phase, BW, VITAE, TRACE, SHIELD, piles by uid, rig, every ICE's state,
## log, pending choice). Four Rustlers × every ICE Node of the slice map × four seeds.

## All four Rustlers (the CORE-LOOP-REWARD-GAP fix lets ECHO, RIOT and VECTOR finish a Node).
const SEEDS := [711, 20261126, 1, 42]
var RUSTLERS: Array = ["GENERALIST", "ECHO", "RIOT", "VECTOR"]
const MAX_ACTIONS := 60
var passed := 0
var failed := 0
var encounters := 0
var actions := 0

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	call_deferred("run")

func snap(g: Game) -> String:
	var ice := []
	for x in g.enc.get("ice", []):
		ice.append([x.id, x.broken, x.break_progress, x.get("rot", 0), x.seen, x.get("responses", 0), x.get("virus", {}), x.get("str_mod", 0)])
	return JSON.stringify({"phase": g.phase, "bw": g.bw, "vitae": g.vitae, "trace": g.trace, "shield": g.shield, "cred": g.cred,
		"strikes": g.strikes, "cortex": g.cortex, "hand": g.hand.map(func(c): return c.uid), "discard": g.discard.map(func(c): return c.uid),
		"burned": g.burned.map(func(c): return c.uid), "draw": g.draw_pile.map(func(c): return c.uid), "rack": g.rack.map(func(c): return c.uid),
		"installed": g.installed.map(func(p): return [p.inst.uid, p.boost, p.get("free_used", false)]),
		"ice": ice, "log": g.log, "turn": g.enc.get("turn", 0), "pending": g.pending.get("kind", "")})

func twin(seed: int, rustler: String, node_index: int, row: int) -> Game:
	var g := Game.new(seed)
	g.new_run(rustler)
	g.rng.seed = seed
	g.animate = true
	g.row = row - 1
	g.available = [node_index]
	g.phase = "MAP"
	g.enter_node(node_index)
	return g

func run() -> void:
	root.size = Vector2i(1600, 1000)
	for row in IceDB.MAP.size():
		for idx in IceDB.MAP[row].size():
			var node: Dictionary = IceDB.MAP[row][idx]
			if String(node.get("kind", "")) != "ICE": continue
			for rustler in RUSTLERS:
				for seed in SEEDS:
					await play(seed, rustler, idx, row, String(node.id))
	print("ARCH-V2 PARITY: %d encounters, %d actions compared · %d passed, %d failed" % [encounters, actions, passed, failed])
	quit(int(failed > 0))

func play(seed: int, rustler: String, idx: int, row: int, node_id: String) -> void:
	var a := twin(seed, rustler, idx, row)
	var b := twin(seed, rustler, idx, row)
	var tag := "%s/%s/%d" % [node_id, rustler, seed]
	if a.enc.is_empty() and a.phase != "READY_RIG":
		check(false, "%s: encounter opens (%s)" % [tag, a.phase]); return
	var sb: IceEncounterSandbox = load("res://scenes/architecture_v2/IceEncounterSandbox.tscn").instantiate()
	sb.embedded = true; sb.instant = true; sb.reduced_motion = true
	sb.flags_path = "user://test_arch_v2_parity_flags.json"
	root.add_child(sb)
	await process_frame
	encounters += 1
	# READY RIG (before the encounter exists): both pick the first option.
	if a.phase == "READY_RIG":
		var opt: Array = a.pending.get("options", [])
		if opt.is_empty(): a.skip_ready_rig(); b.skip_ready_rig()
		else: a.choose_ready_rig(int(opt[0])); b.choose_ready_rig(int(opt[0]))
	sb.attach(a)
	check(snap(a) == snap(b), "%s: twins start identical" % tag)
	var n := 0
	while n < MAX_ACTIONS and a.phase in ["PLAYER", "CHOICE", "READY_RIG"]:
		n += 1
		var did := await act(sb, a, b)
		if did == "": break
		actions += 1
		var same := snap(a) == snap(b)
		check(same, "%s: identical after action %d (%s)" % [tag, n, did])
		if not same:
			var ja: Dictionary = JSON.parse_string(snap(a)); var jb: Dictionary = JSON.parse_string(snap(b))
			for k in ja:
				if JSON.stringify(ja[k]) != JSON.stringify(jb[k]): print("  diff ", k, ": V2=", JSON.stringify(ja[k]).left(300), " / direct=", JSON.stringify(jb[k]).left(300))
			break
	sb.queue_free()
	await process_frame

## One deterministic bot action, decided on A, applied to A through the V2 screen and to B directly.
func act(sb: IceEncounterSandbox, a: Game, b: Game) -> String:
	if a.phase == "CHOICE":
		var kind := String(a.pending.get("kind", ""))
		match kind:
			"patient_zero":
				sb.lane.target_chosen.emit(a.enc.ice[0]); b.choose_ice(0); return "patient_zero"
			"card_break":
				for i in a.enc.ice.size():
					for s in a.active_subs(i):
						if not a.enc.ice[i].broken[s]:
							sb.lane.break_requested.emit(a.enc.ice[i], s, -1); b.choose_sub(i, s); return "card_break"
				return ""
			"scan":
				sb.ctrl.request_finish_scan(); b.finish_scan(); return "scan_finish"
			"cull":
				sb.ctrl.request_cull(""); b.cull_strain(); return "cull_finish"
			_:
				var spec: Dictionary = sb._choice_spec()
				var cards: Array = spec.get("cards", [])
				if cards.is_empty(): return ""
				var u := int(cards[0].uid)
				var cv: CardView = sb.choice.cards()[0]
				cv.pressed.emit(u); b.choose(u)
				return "choice:" + kind
	if a.phase != "PLAYER": return ""
	# 1. Play the first playable card from the hand (left to right), through the hand's CardView.
	for c in a.hand:
		var u := int(c.uid)
		if not a.can_play(u).get("ok", false): continue
		var d := CardDB.def(String(c.id))
		var cv: CardView = null
		for x in sb.hand_fan.cards():
			if x is CardView and x.uid() == u: cv = x
		if cv == null: continue
		if bool(d.get("target", false)):
			var t := 0
			for i in a.enc.ice.size():
				if a.card_target_ok(u, i) if a.has_method("card_target_ok") else true: t = i; break
			sb.start_aim(u, cv)
			var at: Vector2 = sb.lane.panels()[t].get_global_rect().get_center()
			sb.release_aim(at)
			b.play_card(u, t)
			return "aim:" + String(c.id)
		if String(d.get("type", "")) == "PROGRAM":
			sb._on_card_dropped(u, sb.stage.global_position + IceEncounterSandbox.CRT.get_center() * sb.stage.scale)
		else:
			cv.pressed.emit(u)
		b.play_card(u)
		return "play:" + String(c.id)
	# 2. Break the first breakable subroutine (left to right), by clicking its key.
	for i in a.enc.ice.size():
		var d := a.ice_definition(a.enc.ice[i])
		for s in d.subs.size():
			var info := sb.ctrl.break_preview(i, s)
			if info.get("ok", false):
				var key: Node = sb.lane.panels()[i].find_child("Key_S%d" % (s + 1), true, false)
				if key == null: continue
				sb.lane.break_requested.emit(a.enc.ice[i], s, -1)
				var direct := Direct.new(b); direct.click(i, s, int(info.get("uid", -1)))
				return "break %d/%d" % [i, s]
	# 3. End the turn: V2's END TURN with the ResponseSequencer; Build 12's loop on the twin.
	await sb.end_turn()
	b.end_turn()
	while not b.response_queue.is_empty() and b.phase == "RESPONSE": b.response_step()
	if b.phase == "RESPONSE": b.response_finish()
	return "end_turn"

class Direct:
	var g: Game
	func _init(game: Game) -> void: g = game
	func click(i: int, s: int, uid: int) -> void:
		g.break_sub(i, s, uid)
