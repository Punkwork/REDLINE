extends SceneTree
## ARCH-V2-007d: the V2 encounter inside the real app (map → ICE Node → reward overlay). Writes PNGs
## to $SHOT_DIR (default user://shots). Needs a display (xvfb-run).
var out := ""
var n := 0

func _initialize() -> void:
	call_deferred("run")

func shot(name: String) -> void:
	for i in 8: await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out.path_join(name + ".png")); n += 1
	print("shot ", name)

func run() -> void:
	out = OS.get_environment("SHOT_DIR")
	if out == "": out = ProjectSettings.globalize_path("user://shots")
	DirAccess.make_dir_recursive_absolute(out)
	root.size = Vector2i(1600, 1000)
	var app = load("res://scenes/Main.tscn").instantiate()
	root.add_child(app)
	await process_frame
	await shot("app_00_rustler_select")   # RUSTLER-SELECT-001
	var card: Button = app.overlay.find_children("Portrait", "TextureRect", true, false)[0].get_parent()
	card.mouse_entered.emit()
	await shot("app_00b_rustler_select_hover")
	card.mouse_exited.emit()
	app._start_as("GENERALIST")
	var g: Game = app.g
	g.map_rows = IceDB.MAP; g.map_seed = -1; app.refresh()   # this fixture walks the four-row slice route (the V5 map board has shot_node_map)
	await shot("app_01_map")
	if g.enc.is_empty(): g.enter_node(g.available[0]); app.refresh()
	if g.phase == "READY_RIG" and g.enc.is_empty():
		var pick: Array = g.pending.get("options", [])
		if not pick.is_empty(): g.choose_ready_rig(int(pick[0]))
		else: g.skip_ready_rig()
		app.refresh()
	app.v2.flyout.advance(10.0)
	await shot("app_02_encounter_v2")
	app.v2.end_run_key.pressed.emit()
	await shot("app_02b_end_run_confirm")   # ARCH-V2-008b
	app.confirming_end = false; app.refresh()
	for i in g.enc.ice.size():
		var d := g.ice_definition(g.enc.ice[i])
		for s in d.subs.size():
			if g._has_deadlock(d.subs[s]): g.enc.ice[i].broken[s] = true
	g.enc.breached = true
	app.v2.instant = true
	await app.v2.end_turn()
	app.v2.flyout.advance(10.0)
	await shot("app_03_after_breach_%s" % g.phase.to_lower())
	# CAPS-TEST-001: take a card, enter CAPTCHA (row 2), clear it: card reward + the bonus CAP.
	if g.phase == "REWARD": g.choose_reward(g.reward_options[0]); app.refresh()
	if g.phase == "MAP" and g.available.has(0):
		g.enter_node(0); app.refresh()
		if g.phase == "READY_RIG" and g.enc.is_empty():
			g.skip_ready_rig(); app.refresh()
		for i in 4: await process_frame
		if g.phase == "READY_RIG": app.v2.ctrl.request_skip_ready_rig()
		g.enc.breached = true
		app.v2.instant = true
		await app.v2.end_turn()
		app.v2.flyout.advance(10.0)
		await shot("app_04_captcha_reward_cap")
		if g.phase == "REWARD": g.choose_reward(g.reward_options[0]); app.refresh()
		if g.phase == "MAP":
			g.enter_node(g.available[g.available.size() - 1]); app.refresh()
			if g.phase == "READY_RIG" and g.enc.is_empty(): g.skip_ready_rig(); app.refresh()
			for i in 4: await process_frame
			if g.phase == "READY_RIG": app.v2.ctrl.request_skip_ready_rig()
			app.v2.flyout.advance(10.0); app.refresh()
			await shot("app_05_cap_in_rack")
	print("ARCH-V2 APP screenshots: %d written to %s" % [n, out])
	quit(0)
