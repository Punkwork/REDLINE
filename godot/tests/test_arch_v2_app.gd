extends SceneTree
## ARCH-V2-007d (C05): the V2 encounter inside the real app (Main.tscn / main.gd). A run goes from
## Rustler select through the map into an ICE Node on the V2 screen, plays turns there, breaches,
## takes the reward and returns to the map; Build 12's encounter stays hidden. No rules change.

var passed := 0
var failed := 0

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	call_deferred("run")

func frames(n := 3) -> void:
	for i in n: await process_frame

func run() -> void:
	root.size = Vector2i(1600, 1000)
	var app = load("res://scenes/Main.tscn").instantiate()
	root.add_child(app)
	await frames(4)
	check(app.v2 != null and app.use_v2, "the app uses the V2 encounter screen")
	check(not app.v2.visible, "not shown before a run starts")
	app._start_as("GENERALIST")
	await frames()
	var g: Game = app.g
	check(g.phase == "MAP" or g.phase == "SELECT" or not g.enc.is_empty(), "run started (%s)" % g.phase)
	if g.enc.is_empty():
		g.enter_node(g.available[0]); app.refresh(); await frames()
	if g.phase == "READY_RIG" and g.enc.is_empty():
		# READY RIG comes before the encounter exists: the app's overlay asks it (as Build 12).
		check(app.overlay.get_child_count() > 0, "READY RIG asked by the app before the encounter")
		g.skip_ready_rig(); app.refresh(); await frames()
	check(app.v2.visible and not app.friendly.visible, "ICE Node opens on the V2 screen, Build 12's hidden")
	check(app.v2.game == g, "the V2 screen shows the app's Game")
	app.v2.instant = true
	if g.phase == "READY_RIG":
		check(app.v2.choice.visible and app.overlay.get_child_count() == 0, "READY RIG on the V2 screen's choice, not the app overlay")
		app.v2.ctrl.request_skip_ready_rig(); await frames()
	check(g.phase == "PLAYER", "Rustler's turn on the V2 screen")
	# Play a few turns through the V2 screen (responses resolve instantly here).
	for t in 3:
		if g.phase != "PLAYER": break
		await app.v2.end_turn()
		await frames()
		while g.phase == "CHOICE":
			var spec: Dictionary = app.v2._choice_spec()
			if spec.has("cards") and not spec.cards.is_empty(): app.v2.ctrl.request_choice(int(spec.cards[0].uid))
			elif g.pending.get("kind", "") == "scan": app.v2.ctrl.request_finish_scan()
			else: break
			await frames()
	check(g.phase in ["PLAYER", "CHOICE", "DEAD"], "turns played through the V2 screen (%s)" % g.phase)
	# BREACH through the rules: break every DEADLOCK, end the turn: the app takes over (reward/deeper).
	if g.phase == "PLAYER":
		for i in g.enc.ice.size():
			var d := g.ice_definition(g.enc.ice[i])
			for s in d.subs.size():
				if g._has_deadlock(d.subs[s]): g.enc.ice[i].broken[s] = true
		g.enc.breached = true
		app.v2.refresh()
		await app.v2.end_turn()
		await frames(4)
		check(g.phase in ["REWARD", "DEEPER"], "after the BREACH the run moves on (%s)" % g.phase)
		check(app.overlay.get_child_count() > 0, "the app shows its %s overlay" % g.phase)
		if g.phase == "DEEPER": g.leave_node(); app.refresh(); await frames()
		if g.phase == "REWARD":
			g.choose_reward(""); app.refresh(); await frames()
		check(not app.v2.visible and g.phase in ["MAP", "SAFEHOUSE", "SLICE_DONE"], "back on the map: V2 screen hidden (%s)" % g.phase)
		# The next ICE Node opens on the V2 screen again, on the new encounter.
		if g.phase == "MAP":
			var nxt := -1
			for idx in g.available:
				if String(IceDB.MAP[g.row + 1][idx].get("kind", "")) == "ICE": nxt = idx; break
			if nxt >= 0:
				g.enter_node(nxt); app.refresh(); await frames()
				if not g.enc.is_empty():
					check(app.v2.visible and app.v2.ctrl.is_current(), "next ICE Node on the V2 screen, bound to the new encounter")
	# Leaving the run: the app's relocation overlay, V2 hidden.
	g.abandon(); app.refresh(); await frames()
	check(not app.v2.visible and app.overlay.get_child_count() > 0, "run over: the app's overlay, V2 screen hidden")
	# Settings flow both ways.
	app.set_reduced_motion(true)
	check(app.v2.reduced_motion, "reduced motion reaches the V2 screen")
	app.set_reduced_motion(false)
	print("ARCH-V2 APP: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))
