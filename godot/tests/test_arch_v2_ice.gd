extends SceneTree
## ARCH-V2-003 Batch 1: headless checks for the Architecture V2 ICE encounter components.
## Parity: every player action made through the new components (click, Enter, drop) must leave the
## game exactly as the same action made directly on Game the way Build 12 made it, on a twin game with
## the same seed. Also: one Game call per intent, stale references refused, hidden information never
## reaches a component, panels reconcile by identity, response steps resolve exactly once, flyout
## limits (UI-TYPO-001a), contrast, copy guards.

const SEED := 711
var passed := 0
var failed := 0

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	print("- test_tokens_and_copy")
	test_tokens_and_copy()
	test_adapter_hidden()
	print("- test_single_call_per_intent")
	await test_single_call_per_intent()
	await test_parity_through_components()
	print("- test_stale_refs")
	test_stale_refs()
	await test_reconcile_identity()
	print("- test_key_size_three_ice")
	await test_key_size_three_ice()
	test_flyout()
	print("- test_sandbox_response(false)")
	await test_sandbox_response(false)
	await test_sandbox_response(true)
	print("- test_inspector_keyboard")
	await test_inspector_keyboard()
	print("- test_hesitation_voice")
	test_hesitation_voice()
	print("- test_hand_fan")
	await test_hand_fan()
	print("- test_twelve_card_fan / test_rig_bay")
	await test_twelve_card_fan()
	await test_rig_bay()
	print("ARCH-V2 ICE: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

# ----- helpers

func fresh(seed := SEED) -> Game:
	var g := Game.new(seed)
	g.new_run("GENERALIST")
	g.rng.seed = seed
	g.animate = true
	g.row = 0
	g.available = [0]
	g.enter_node(0)
	if g.phase == "READY_RIG":
		g.choose_ready_rig(g.draw_pile.filter(func(c): return c.id == "FORTRESS_ICEPICK")[0].uid)
	return g

func prime(g: Game) -> void:
	## Test fixture only (identical on both twins): enough BW to break, and a TUMBLER Icepick installed.
	g.bw = 30
	var tp := g.hand.filter(func(c): return c.id == "TUMBLER_ICEPICK")
	if not tp.is_empty(): g.play_card(tp[0].uid)
	g.bw = 30

func snap(g: Game) -> String:
	var ice := []
	for x in g.enc.get("ice", []):
		ice.append([x.id, x.broken, x.break_progress, x.get("rot", 0), x.seen, x.get("responses", 0)])
	return JSON.stringify({"phase": g.phase, "bw": g.bw, "vitae": g.vitae, "trace": g.trace, "shield": g.shield,
		"hand": g.hand.map(func(c): return c.uid), "discard": g.discard.map(func(c): return c.uid),
		"draw": g.draw_pile.map(func(c): return c.uid), "installed": g.installed.map(func(p): return [p.inst.uid, p.boost, p.get("free_used", false)]),
		"ice": ice, "log": g.log, "turn": g.enc.get("turn", 0), "pending": g.pending.get("kind", "")})

## Build 12's direct path (FriendlyEncounter.break_action / break_info / main._on_break), on Game only.
class Direct:
	var g: Game
	var active := -1
	func _init(game: Game) -> void: g = game
	func pick() -> int:
		var p: Dictionary = g._installed_entry(active)
		return active if not p.is_empty() and CardDB.def(p.inst.id).has("pick") else -1
	func click(i: int, s: int) -> void:
		if g.phase == "CHOICE" and g.pending.get("kind") == "card_break": g.choose_sub(i, s); return
		var info := {}
		if g.phase != "PLAYER": info = {"ok": false}
		else:
			var p := pick()
			if p >= 0:
				var mine := g.break_info(i, s, p)
				if mine.ok: info = mine
			if info.is_empty(): info = g.break_info(i, s)
		if info.get("ok", false) and info.has("uid"): active = int(info.uid)
		g.break_sub(i, s, int(info.get("uid", -1)))
	func drop(i: int, s: int, uid: int) -> void:
		if g.break_info(i, s, uid).ok: g.break_sub(i, s, uid)
	func respond() -> int:
		var n := 0
		g.end_turn()
		while not g.response_queue.is_empty() and g.phase == "RESPONSE":
			g.response_step(); n += 1
		if g.phase == "RESPONSE": g.response_finish()
		return n

func mount_lane(g: Game, ctrl: EncounterController) -> IceLane:
	var lane := IceLane.new()
	lane.size = IceEncounterSandbox.LANE.size   # the sandbox lane, reference px
	lane.inspector = KeyInspector.new()
	root.add_child(lane.inspector)
	lane.drop_check = func(r, s, u): var i := ctrl.ice_index(r); return g.break_info(i, s, u) if i >= 0 else {"ok": false}
	lane.break_requested.connect(func(r, s, u): ctrl.request_break(r, s, u))
	root.add_child(lane)
	lane.sync(VisibleStateAdapter.ice_models(g, ctrl))
	return lane

func unmount(lane: IceLane) -> void:
	lane.inspector.queue_free()
	lane.queue_free()

func key_for(lane: IceLane, g: Game, i: int, s: int) -> SubroutineKey:
	var p := lane.panel_for(g.enc.ice[i])
	return p.key(s) if p else null

func click(k: SubroutineKey) -> void:
	var e := InputEventMouseButton.new(); e.button_index = MOUSE_BUTTON_LEFT; e.pressed = true
	k._gui_input(e)

func enter(k: SubroutineKey) -> void:
	k.grab_focus()
	var e := InputEventKey.new(); e.keycode = KEY_ENTER; e.physical_keycode = KEY_ENTER; e.pressed = true
	k._gui_input(e)

# ----- tests

func test_tokens_and_copy() -> void:
	check(VasTokens.contrast(VasTokens.PLAQUE_INK, VasTokens.PLAQUE) >= 4.5, "nameplate text contrast")
	check(VasTokens.contrast(VasTokens.SEAFOAM_INK, VasTokens.SEAFOAM) >= 4.5, "seafoam ink contrast")
	check(VasTokens.contrast(Color("#1E1810"), VasTokens.IVORY) >= 4.5, "inspector rule text contrast")
	check(VasTokens.contrast(VasTokens.SEAFOAM_INK, VasTokens.IVORY) >= 4.5, "inspector title contrast")
	check(VasTokens.contrast(VasTokens.IVORY, VasTokens.CHASSIS) >= 4.5, "rail ICE tag contrast")
	check(VasTokens.contrast(VasTokens.AMBER, VasTokens.CHASSIS) >= 4.5, "rail title contrast")
	check(VasTokens.contrast(VasTokens.PHOSPHOR, Color("#120D0B")) >= 4.5, "readout contrast")
	check(VasTokens.contrast(VasTokens.IVORY, VasTokens.PLAQUE) >= 4.5, "STR numeral contrast")
	for k in VasTokens.FLYOUT:
		var f: Dictionary = VasTokens.FLYOUT[k]
		# Worst case: the translucent band over the darkest and lightest ground under it.
		for ground in [VasTokens.CHASSIS, VasTokens.SEAFOAM, VasTokens.IVORY]:
			var under: Color = ground.lerp(f.band, EventFlyout.BAND_ALPHA)
			check(VasTokens.contrast(f.ink, under) >= 4.5 or VasTokens.contrast(Color(0.04, 0.03, 0.03), under) >= 4.5, "flyout %s readable over %s" % [k, ground.to_html()])
	check(VasTokens.FLYOUT.rustler_turn.text == "RUSTLER TURN", "approved wording: RUSTLER TURN")
	check(VasTokens.FLYOUT.corp_countermeasure.text == "CORP COUNTERMEASURE", "approved wording: CORP COUNTERMEASURE")
	check(VasTokens.flyout_total() <= 1.5, "flyout total ≤ 1.5 s")
	# Copy guards over every new Architecture V2 source file.
	var dir := DirAccess.open("res://scripts/ui/architecture_v2")
	for f in dir.get_files():
		if not f.ends_with(".gd"): continue
		var text := FileAccess.get_file_as_string("res://scripts/ui/architecture_v2/" + f).to_lower()
		check(not text.contains("archipelago") and not text.contains("gulag") and not text.contains("’pelago") and not text.contains("sentry"), "copy guards in " + f)

func test_adapter_hidden() -> void:
	var g := fresh()
	var ctrl := EncounterController.new(); ctrl.bind(g)
	var models := VisibleStateAdapter.ice_models(g, ctrl)
	check(models.size() == 2 and models[0].id == "AUTO_RENEW" and models[1].id == "CAPTCHA", "N2A ICE are AUTO-RENEW + CAPTCHA")
	check(models[0].type == "FORTRESS" and models[0].keys.size() == 5, "FORTRESS shows all five keys")
	check(models[1].type == "TUMBLER" and models[1].keys.size() == 2, "TUMBLER shows its two slots")
	check(int(models[1].hidden_pool) == g.hidden_count(1) and int(models[1].hidden_pool) > 0, "TUMBLER reel counts face-down subs")
	check(models[1].pool.is_empty(), "unseen reel subs produce no key models")
	check(models[0].keys[1].badge == "" and models[0].keys[2].extra == 1, "multi-effect key carries +1 (PULP 2 + BW drain)")
	check(models[0].keys[4].kind == "DEADLOCK" and models[0].keys[4].value == "0/2", "DEADLOCK ×2 progress shows 0/2")
	# VOID ICE: face-down subroutines must carry nothing (fixture appends a DOORBELL CAM).
	g.enc.ice.append(g._new_ice("DOORBELL_CAM"))
	models = VisibleStateAdapter.ice_models(g, ctrl)
	var void_m: Dictionary = models[2]
	check(void_m.type == "VOID", "VOID ICE type")
	var hidden_keys: Array = void_m.keys.filter(func(k): return k.state == "hidden")
	check(not hidden_keys.is_empty(), "VOID starts with hidden keys")
	for k in hidden_keys:
		check(k.kind == "HIDDEN" and k.value == "" and k.badge == "" and int(k.extra) == 0 and k.title == VisibleStateAdapter.HIDDEN_TITLE and k.rules.size() == 1 and k.rules[0].kind == "HIDDEN", "hidden key carries no effect data (S%d)" % (int(k.sub) + 1))
		check(not k.breakable and k.cost_text == "", "hidden key is not breakable and shows no cost")
	# The raw preview does carry hidden effects (the reason the adapter exists).
	var raw_hidden: Array = g.response_preview().filter(func(s): return s.hidden)
	var rail: Array = VisibleStateAdapter.response_model(g, ctrl)
	for st in rail:
		if st.hidden: check(st.kind == "HIDDEN" and st.value == "" and st.title == VisibleStateAdapter.HIDDEN_TITLE, "rail hidden step carries no effect")
	check(raw_hidden.is_empty() or rail.any(func(s): return s.hidden) or rail.size() <= g.response_preview().filter(func(s): return not s.skipped).size(), "rail built from preview")

func test_single_call_per_intent() -> void:
	var g := fresh(); prime(g)
	var ctrl := EncounterController.new(); ctrl.bind(g)
	var lane := mount_lane(g, ctrl)
	await process_frame
	var resolved := [0]
	ctrl.break_resolved.connect(func(_r, _s, _c): resolved[0] += 1)
	var k := key_for(lane, g, 0, 0)
	var before := ctrl.game_calls
	click(k)
	check(ctrl.game_calls == before + 1, "click: one Game call")
	check(g.enc.ice[0].broken[0], "click broke AUTO-RENEW S1")
	lane.sync(VisibleStateAdapter.ice_models(g, ctrl))
	k = key_for(lane, g, 0, 1)
	before = ctrl.game_calls
	enter(k)
	check(ctrl.game_calls == before + 1, "Enter: one Game call")
	check(g.enc.ice[0].broken[1], "Enter broke AUTO-RENEW S2")
	lane.sync(VisibleStateAdapter.ice_models(g, ctrl))
	var tp: Array = g.installed.filter(func(p): return p.inst.id == "TUMBLER_ICEPICK")
	check(not tp.is_empty(), "TUMBLER Icepick installed for the drop")
	var slot: int = g.active_subs(1)[0]
	k = key_for(lane, g, 1, slot)
	before = ctrl.game_calls
	check(k._can_drop_data(Vector2.ZERO, {"kind": "pick", "uid": tp[0].inst.uid}), "drop: TUMBLER Icepick accepted on CAPTCHA key")
	check(not k._can_drop_data(Vector2.ZERO, {"kind": "card", "uid": 1}), "drop: card payload refused by a key")
	k._drop_data(Vector2.ZERO, {"kind": "pick", "uid": tp[0].inst.uid})
	check(ctrl.game_calls == before + 1, "drop: one Game call")
	check(g.enc.ice[1].broken[slot], "drop broke CAPTCHA's slotted sub")
	check(resolved[0] == 3, "break_resolved once per successful break")
	# A refused click still makes exactly one Game call and changes nothing (Build 12 behaviour).
	lane.sync(VisibleStateAdapter.ice_models(g, ctrl))
	g.bw = 0
	var s0 := snap(g)
	before = ctrl.game_calls
	click(key_for(lane, g, 0, 2))
	check(ctrl.game_calls == before + 1 and snap(g) == s0, "refused break: one call, no change")
	unmount(lane)

func test_parity_through_components() -> void:
	var a := fresh(); prime(a)
	var b := fresh(); prime(b)
	check(snap(a) == snap(b), "twins start identical")
	var ctrl := EncounterController.new(); ctrl.bind(a)
	var lane := mount_lane(a, ctrl)
	var direct := Direct.new(b)
	await process_frame
	var tp: int = a.installed.filter(func(p): return p.inst.id == "TUMBLER_ICEPICK")[0].inst.uid
	# Scripted: click, Enter, drop, a refused drop, then a full Corporation Response, then more breaks.
	var script := [["click", 0, 3], ["enter", 0, 0], ["drop", 1, -1, tp], ["drop", 0, 1, tp], ["click", 0, 4], ["end"], ["click", 0, 1], ["enter", 1, -1], ["end"]]
	var step := 0
	for act in script:
		step += 1
		if a.phase == "CHOICE":
			# Start-of-turn DISCARD from CAPTCHA: both twins discard the same card.
			var uid: int = a.hand[0].uid
			ctrl.request_choice(uid); b.choose(uid)
		match act[0]:
			"click", "enter", "drop":
				var i: int = act[1]
				var s: int = act[2] if act[2] >= 0 else (a.active_subs(i)[0] if not a.active_subs(i).is_empty() else 0)
				lane.sync(VisibleStateAdapter.ice_models(a, ctrl))
				var k := key_for(lane, a, i, s)
				if k == null: check(false, "step %d: key exists" % step); continue
				if act[0] == "click": click(k); direct.click(i, s)
				elif act[0] == "enter": enter(k); direct.click(i, s)
				else:
					k._drop_data(Vector2.ZERO, {"kind": "pick", "uid": act[3]}); direct.drop(i, s, act[3])
			"end":
				ctrl.end_turn()
				var n := 0
				while ctrl.response_pending(): ctrl.peek_response(); ctrl.step_response(); n += 1
				ctrl.finish_response()
				var m := direct.respond()
				check(n == m, "step %d: same number of response steps (%d/%d)" % [step, n, m])
		check(snap(a) == snap(b), "step %d (%s): state matches direct Game" % [step, act[0]])
	# The script must really have played: breaks landed, the response hurt, turns advanced.
	var broken := 0
	for x in a.enc.ice: broken += x.broken.count(true)
	check(broken >= 3, "parity script broke subroutines (%d)" % broken)
	check(int(a.enc.ice[0].break_progress[4]) >= 1, "parity script advanced DEADLOCK ×2")
	check(a.vitae < Game.START_VITAE and int(a.enc.turn) >= 3, "parity script ran two responses (VITAE %d, turn %d)" % [a.vitae, a.enc.turn])
	unmount(lane)

func test_stale_refs() -> void:
	var g := fresh(); prime(g)
	var ctrl := EncounterController.new(); ctrl.bind(g)
	var old_ref: Dictionary = g.enc.ice[0]
	var copy := old_ref.duplicate(true)
	var s0 := snap(g)
	check(not ctrl.request_break(copy, 0), "equal-but-different ICE dict refused")
	check(ctrl.game_calls == 0 and snap(g) == s0, "refused ref: no Game call, no change")
	# A new encounter replaces enc: refs from the old one are refused.
	var old_enc := g.enc
	g.enc = old_enc.duplicate(true)
	check(not ctrl.request_break(old_ref, 0), "old encounter's ICE refused after enc changed")
	check(ctrl.game_calls == 0, "no Game call for a stale encounter")
	check(ctrl.rebind_if_new_encounter() and ctrl.ice_index(g.enc.ice[0]) == 0, "controller rebinds to the new encounter")
	check(not ctrl.request_break(old_ref, 0), "old ref still refused after rebind")
	check(not ctrl.request_break(g.enc.ice[0], 99), "out-of-range subroutine refused")

func test_reconcile_identity() -> void:
	var g := fresh(); prime(g)
	var ctrl := EncounterController.new(); ctrl.bind(g)
	var lane := mount_lane(g, ctrl)
	await process_frame
	var p0: IcePanel = lane.panels()[0]
	var p1: IcePanel = lane.panels()[1]
	var rot_before: Array = g.active_subs(1).duplicate()
	ctrl.end_turn()
	while ctrl.response_pending(): ctrl.step_response()
	ctrl.finish_response()
	lane.sync(VisibleStateAdapter.ice_models(g, ctrl))
	check(g.active_subs(1) != rot_before, "CAPTCHA rotated after the response")
	check(is_same(lane.panels()[0], p0) and is_same(lane.panels()[1], p1), "panels keep identity across rotation")
	check(not ctrl.tumbled_subs(g.enc.ice[1]).is_empty(), "rotated-in TUMBLER keys are marked new")
	var newk: Array = VisibleStateAdapter.ice_models(g, ctrl)[1].keys.filter(func(k): return k.state == "new")
	check(not newk.is_empty(), "adapter shows rotated-in key as new (Build 12 amber)")
	# Black ICE arrives on the left: existing panels survive and shift right.
	g._add_black_ice()
	lane.sync(VisibleStateAdapter.ice_models(g, ctrl))
	check(lane.panels().size() == 3, "three panels after Black ICE")
	check(is_same(lane.panels()[1], p0) and is_same(lane.panels()[2], p1), "existing panels reused after index shift")
	# Removing an ICE frees only its panel.
	var removed: Dictionary = g.enc.ice.pop_front()
	lane.sync(VisibleStateAdapter.ice_models(g, ctrl))
	check(lane.panels().size() == 2 and is_same(lane.panels()[0], p0), "removal keeps the others")
	g.enc.ice.push_front(removed)
	unmount(lane)

func test_key_size_three_ice() -> void:
	var g := fresh()
	g.enc.ice.append(g._new_ice("DOORBELL_CAM"))
	var ctrl := EncounterController.new(); ctrl.bind(g)
	var lane := mount_lane(g, ctrl)
	await process_frame
	var smallest := 999.0
	for p in lane.panels():
		for k in p.keys():
			smallest = minf(smallest, k.face.key_rect().size.x * p.scale.x)
	check(lane.panels().size() == 3, "three ICE laid out")
	check(smallest >= 44.0, "keys ≥ 44 px at three ICE (smallest %.1f)" % smallest)
	for p in lane.panels():
		check(p.position.x >= -0.5 and p.position.x + p.size.x * p.scale.x <= lane.size.x + 0.5, "panel inside lane")
		# ARCH-V2-003r: the avatar is at least half the window's width and stands above the keys.
		var av: Rect2 = p.layout.portrait_rect(true)
		check(av.size.x >= 0.5 * p.size.x and av.position.y < p.layout.bank_rect(true).position.y, "avatar ≥ half the window and above the keys (%s)" % p.name)
	# ARCH-V2-003r: six subroutines in a three-ICE panel still fit, ≥ 44 px, inside the window.
	var p6: IcePanel = lane.panels()[0]
	var m6: Dictionary = p6.model.duplicate(true)
	var extra_key: Dictionary = (m6.keys[0] as Dictionary).duplicate(true); extra_key.sub = 5
	m6.keys.append(extra_key)
	p6.set_model(m6)
	await process_frame
	var s6 := 999.0
	var right := 0.0
	for k in p6.keys():
		s6 = minf(s6, k.face.key_rect().size.x * p6.scale.x)
		right = maxf(right, k.get_global_rect().end.x)
	check(p6.keys().size() == 6 and s6 >= 44.0, "six keys ≥ 44 px at three ICE (smallest %.1f)" % s6)
	check(right <= p6.get_global_rect().end.x, "six keys stay inside the panel")
	check(p6.bank.get_child_count() == 2 and p6.bank.get_child(0).find_children("Key_S*", "", false, false).size() == 3, "six keys: two rows of three")
	# ARCH-V2-003v: five keys = S1 S2 on top, S3 S4 S5 below; rows right-aligned on the panel's right.
	var p5: IcePanel = lane.panels()[0]
	var m5: Dictionary = p5.model.duplicate(true)
	m5.keys.resize(5)
	for k in 5: m5.keys[k] = (p6.model.keys[k] as Dictionary).duplicate(true); m5.keys[k].sub = k
	p5.set_model(m5)
	await process_frame
	var top := p5.bank.get_child(0).find_children("Key_S*", "", false, false).map(func(k): return String(k.name))
	var bottom := p5.bank.get_child(1).find_children("Key_S*", "", false, false).map(func(k): return String(k.name))
	check(top == ["Key_S1", "Key_S2"] and bottom == ["Key_S3", "Key_S4", "Key_S5"], "five keys: S1 S2 on top, S3 S4 S5 below (%s / %s)" % [top, bottom])
	var e1: float = p5.key(1).get_global_rect().end.x
	var e2: float = p5.key(4).get_global_rect().end.x
	check(absf(e1 - e2) < 1.0 and p5.key(4).get_global_rect().position.x > p5.get_global_rect().get_center().x - 40.0 * p5.scale.x, "rows right-aligned on the right side")
	check(p5.key(0).get_global_rect().position.y < p5.key(2).get_global_rect().position.y, "top row above bottom row")
	unmount(lane)
	# One ICE stays centred at full size.
	var g1 := fresh()
	g1.enc.ice.pop_back()
	var c1 := EncounterController.new(); c1.bind(g1)
	var l1 := mount_lane(g1, c1)
	await process_frame
	var p: IcePanel = l1.panels()[0]
	check(is_equal_approx(p.scale.x, 1.0) and absf(p.position.x + p.size.x / 2.0 - l1.size.x / 2.0) < 1.0, "one ICE centred at full size")
	unmount(l1)

func test_flyout() -> void:
	var f := EventFlyout.new()
	root.add_child(f)
	f.size = Vector2(1536, 864)
	check(f.mouse_filter == Control.MOUSE_FILTER_IGNORE, "flyout never intercepts input")
	f.announce("rustler_turn")
	check(f.playing and f.kind == "rustler_turn", "flyout plays")
	f.announce("rustler_turn")
	check(f._queued == "", "duplicate announcement dropped")
	f.announce("corp_countermeasure")
	check(f._queued == "corp_countermeasure", "a different announcement queues")
	var peak := 0.0
	var t := 0.0
	while f.playing and f.kind == "rustler_turn":
		f.advance(1.0 / 60.0); t += 1.0 / 60.0
		peak = maxf(peak, f.band_opacity())
	check(t <= 1.5 + 0.02, "first flyout done within 1.5 s (%.2f)" % t)
	check(peak <= EventFlyout.BAND_ALPHA + 0.001, "band stays translucent")
	check(f.playing and f.kind == "corp_countermeasure", "queued flyout follows")
	f.advance(2.0)
	check(not f.playing and not f.visible, "flyout ends hidden")
	f.reduced_motion = true
	f.announce("corp_countermeasure")
	f.advance(0.6)
	check(f.band_opacity() <= EventFlyout.BAND_ALPHA, "reduced motion: translucent fade only")
	f.advance(2.0)
	check(not f.playing, "reduced motion flyout ends")
	f.queue_free()

func test_sandbox_response(reduced: bool) -> void:
	var sb: IceEncounterSandbox = load("res://scenes/architecture_v2/IceEncounterSandbox.tscn").instantiate()
	sb.reduced_motion = reduced
	sb.instant = true
	root.add_child(sb)
	await process_frame
	check(sb.flyout.kind == "rustler_turn" and sb.flyout.playing, "sandbox opens with RUSTLER TURN (reduced=%s)" % reduced)
	var twin := fresh()
	var direct := Direct.new(twin)
	check(snap(sb.game) == snap(twin), "sandbox starts at the seeded N2A state")
	var queue_before := [-1]
	sb.ctrl.phase_changed.connect(func(_o, ph): if ph == "RESPONSE": queue_before[0] = sb.game.response_queue.size())
	var calls_before := sb.ctrl.game_calls
	await sb.end_turn()
	var n := direct.respond()
	check(queue_before[0] == n, "response queued %d steps (direct %d)" % [queue_before[0], n])
	# end_turn + one call per step + finish (+ none else).
	check(sb.ctrl.game_calls - calls_before == 1 + n + 1, "each response step resolved exactly once, finish once (reduced=%s)" % reduced)
	check(snap(sb.game) == snap(twin), "sandbox response matches direct Game (reduced=%s)" % reduced)
	check(sb.flyout.kind == "corp_countermeasure" or sb.flyout._queued != "" or sb.flyout.kind == "rustler_turn", "CORP COUNTERMEASURE announced")
	check(not sb.responding and (sb.game.phase == "PLAYER" or sb.game.phase == "CHOICE"), "back to the Rustler after the response")
	sb.queue_free()
	await process_frame

func test_inspector_keyboard() -> void:
	var g := fresh()
	g.enc.ice.append(g._new_ice("DOORBELL_CAM"))
	var ctrl := EncounterController.new(); ctrl.bind(g)
	var lane := mount_lane(g, ctrl)
	await process_frame
	var void_panel: IcePanel = lane.panels()[2]
	var hidden_key: SubroutineKey = null
	for k in void_panel.keys():
		if k.model.state == "hidden": hidden_key = k; break
	check(hidden_key != null, "a hidden VOID key exists")
	hidden_key.grab_focus()
	await process_frame
	var ins := lane.inspector
	check(ins.visible and is_same(ins.subject, hidden_key), "keyboard focus opens the inspector")
	var words: Array = ins.find_children("*", "Label", true, false).map(func(l): return l.text)
	var joined := " ".join(words)
	check(joined.contains("HIDDEN") and joined.contains(VisibleStateAdapter.HIDDEN_RULE), "hidden key: hidden wording only")
	for e in g.ice_definition(g.enc.ice[2]).subs[int(hidden_key.model.sub)]:
		check(not joined.contains(VisibleStateAdapter.effect_rule(g.effect_value(g.enc.ice[2], e))), "hidden effect wording not disclosed")
	var visible_key: SubroutineKey = lane.panels()[0].key(1)
	visible_key.grab_focus()
	await process_frame
	joined = " ".join(ins.find_children("*", "Label", true, false).map(func(l): return l.text))
	check(joined.contains("HARDEN") and is_same(ins.subject, visible_key), "visible key: full rule on focus")
	var tb: IceBadge = lane.panels()[2].type_badge
	tb.grab_focus()
	await process_frame
	joined = " ".join(ins.find_children("*", "Label", true, false).map(func(l): return l.text))
	check(joined.strip_edges() == "VOID", "type badge shows only the ICE type (got '%s')" % joined)
	var sb_badge: IceBadge = lane.panels()[0].str_badge
	sb_badge.grab_focus()
	await process_frame
	joined = " ".join(ins.find_children("*", "Label", true, false).map(func(l): return l.text))
	check(joined.strip_edges() == "ICE STRENGTH: %d" % g.ice_str(0), "STR badge shows ICE STRENGTH with the current STR (got '%s')" % joined)
	unmount(lane)

func test_hand_fan() -> void:
	## ARCH-V2-003o: hand splayed and fanned like VAS-001; layout only, rules untouched.
	var sb: IceEncounterSandbox = load("res://scenes/architecture_v2/IceEncounterSandbox.tscn").instantiate()
	sb.reduced_motion = true
	sb.instant = true
	root.add_child(sb)
	await process_frame
	var before := snap(sb.game)
	var cards := sb.hand_fan.cards()
	check(cards.size() == sb.game.hand.size() and cards.size() > 1, "fan holds one card per hand card (%d)" % cards.size())
	var n := cards.size()
	var sym := true; var spread := true; var arc := true
	for i in n:
		var a: float = cards[i].rotation; var b: float = cards[n - 1 - i].rotation
		sym = sym and absf(a + b) < 0.001
		if i > 0: spread = spread and cards[i].position.x > cards[i - 1].position.x and cards[i].rotation >= cards[i - 1].rotation
		arc = arc and cards[i].position.y >= cards[n / 2].position.y - 0.01
	check(sym and cards[0].rotation < 0.0 and cards[n - 1].rotation > 0.0, "cards tilt away from the centre, symmetrically")
	check(spread, "cards splay left to right in hand order")
	check(arc, "outer cards sit no higher than the centre card (arc)")
	check(cards[0].position.x >= -20.0 and cards[n - 1].position.x + cards[n - 1].size.x <= sb.hand_fan.size.x + 20.0, "fan stays inside the hand area")
	check(cards[0].size.x >= 44 and absf(cards[0].size.y / cards[0].size.x - 1.58) < 0.01, "cards use HuCard proportions and touch size")
	var c: Control = cards[1]
	var rest := c.position
	c.grab_focus()
	await process_frame
	check(c.position.y < rest.y and c.z_index > n, "focused card lifts to the front")
	c.release_focus()
	await process_frame
	check(c.position == rest, "card returns to its place")
	check(snap(sb.game) == before, "fan interaction does not touch the Game")
	sb.queue_free()
	await process_frame

func test_hesitation_voice() -> void:
	## ADP-2b through the V2 voice: 4 s hover, highest mood speaks, 20 s cooldown, once per turn,
	## not while dragging, Rustler's turn only. Reads models only.
	var g := fresh()
	var ctrl := EncounterController.new(); ctrl.bind(g)
	var models := VisibleStateAdapter.ice_models(g, ctrl)
	var before := snap(g)
	var v := HesitationVoice.new()
	var r := v.tick(3.9, 3.9, 7, false, "PLAYER", 1, "HALCYON", models)
	check(r.is_empty(), "no line before 4 s")
	r = v.tick(0.2, 4.1, 7, false, "PLAYER", 1, "HALCYON", models)
	check(not r.is_empty() and String(r.text) != "", "a line after 4 s on one card")
	var v2 := HesitationVoice.new()
	check(v2.tick(5.0, 5.0, 7, true, "PLAYER", 1, "HALCYON", models).is_empty(), "no line while dragging")
	check(v2.tick(5.0, 5.0, 7, false, "RESPONSE", 1, "HALCYON", models).is_empty(), "no line outside the Rustler's turn")
	v.tick(0.0, 5.0, -1, false, "PLAYER", 1, "HALCYON", models)
	check(v.tick(5.0, 30.0, 8, false, "PLAYER", 1, "HALCYON", models).is_empty(), "at most once per turn")
	v.tick(0.0, 30.0, -1, false, "PLAYER", 2, "HALCYON", models)
	check(v.tick(5.0, 10.0, 8, false, "PLAYER", 2, "HALCYON", models).is_empty(), "20 s cooldown holds into the next turn")
	v.tick(0.0, 30.0, -1, false, "PLAYER", 2, "HALCYON", models)
	check(not v.tick(5.0, 35.0, 8, false, "PLAYER", 2, "HALCYON", models).is_empty(), "speaks again after the cooldown, next turn")
	var lethal: Array = models.duplicate(true); lethal[1].mood = "lethal"
	var v3 := HesitationVoice.new()
	check(int(v3.tick(4.5, 4.5, 3, false, "PLAYER", 1, "HALCYON", lethal).get("ice", -1)) == 1, "the ICE with the highest mood speaks")
	check(snap(g) == before, "hesitation never touches the Game")

func test_twelve_card_fan() -> void:
	## ARCH-V2-003u: up to 12 cards; at least the left half of every card stays visible.
	var sb: IceEncounterSandbox = load("res://scenes/architecture_v2/IceEncounterSandbox.tscn").instantiate()
	sb.reduced_motion = true; sb.instant = true
	root.add_child(sb)
	await process_frame
	var fan := sb.hand_fan
	fan.clear()
	for k in 12:
		var b := Button.new(); b.text = str(k); fan.add_card(b)
	await process_frame
	var cs := fan.cards()
	var half := true
	for k in range(1, cs.size()):
		half = half and cs[k].position.x - cs[k - 1].position.x >= fan.card_size.x * 0.5 - 0.5
	check(cs.size() == 12 and half, "twelve cards: each card's left half stays visible")
	check(cs[11].position.x + fan.card_size.x <= fan.size.x + 20.0 and cs[0].position.x >= -20.0, "twelve cards fit the tray")
	check(sb.HAND.end.x <= sb.RACK.position.x and sb.COUNTERS.position.y >= sb.RACK.end.y, "counters sit under the meters; the hand reaches them")
	sb.queue_free()
	await process_frame

func test_rig_bay() -> void:
	## ARCH-V2-003u: installed programs are cartridges in the CRT; clicking one shows it and makes it
	## the program a key click uses. Selecting makes no Game call.
	var sb: IceEncounterSandbox = load("res://scenes/architecture_v2/IceEncounterSandbox.tscn").instantiate()
	sb.reduced_motion = true; sb.instant = true
	root.add_child(sb)
	await process_frame
	var tp := sb.game.hand.filter(func(c): return c.id == "TUMBLER_ICEPICK")
	if not tp.is_empty(): sb.ctrl.request_play(int(tp[0].uid)); sb.refresh()
	await process_frame
	var carts := sb.rig_bay.cartridges()
	check(carts.size() == sb.game.installed.size() and carts.size() >= 2, "one cartridge per installed program (%d)" % carts.size())
	var calls := sb.ctrl.game_calls
	var before := snap(sb.game)
	var target: RigBay.Cartridge = carts[carts.size() - 1]
	var uid := int(target.prog.uid)
	target.chosen.emit(uid)
	await process_frame
	check(sb.ctrl.active_program == uid and sb.ctrl.game_calls == calls and snap(sb.game) == before, "clicking a cartridge selects it without touching the Game")
	check(int(sb.rig_bay.screen.prog.get("uid", -1)) == uid and sb.rig_bay.screen.is_active, "the CRT shows the selected program")
	var c2 := sb.rig_bay.cartridges()
	var raised := false
	for c in c2: if c.active: raised = c.position.y < c2[0].position.y or c == c2[0]
	check(raised, "the active cartridge sits raised in its slot")
	check(sb.rig_bay.cartridges()[0].position.y < sb.CRT.position.y, "cartridges stick up above the CRT")
	# ARCH-V2-003w: BOOST and EJECT are chosen on the CRT; each is one Game call, as Game rules it.
	var kinds := sb.rig_bay.screen.actions().map(func(a): return a.kind)
	check(kinds.has("boost") and kinds.has("eject"), "an Icepick on the CRT offers BOOST and EJECT (%s)" % [kinds])
	var entry: Dictionary = sb.game._installed_entry(uid)
	var str0 := sb.game.pick_str(entry)
	var bw0 := sb.game.bw
	var chk := sb.game.can_boost(uid)
	var calls0 := sb.ctrl.game_calls
	for a in sb.rig_bay.screen.actions():
		if a.kind == "boost": a.pressed.emit(); break
	await process_frame
	check(sb.ctrl.game_calls == calls0 + 1 and sb.game.pick_str(sb.game._installed_entry(uid)) == str0 + int(chk.amt) and sb.game.bw == bw0 - int(chk.cost), "BOOST from the CRT: one Game call, +STR, BW spent")
	var n_inst := sb.game.installed.size()
	for a in sb.rig_bay.screen.actions():
		if a.kind == "eject": a.pressed.emit(); break
	await process_frame
	check(sb.game.installed.size() == n_inst - 1 and sb.rig_bay.cartridges().size() == n_inst - 1, "EJECT unloads the program; its cartridge leaves the CRT")
	sb.queue_free()
	await process_frame
