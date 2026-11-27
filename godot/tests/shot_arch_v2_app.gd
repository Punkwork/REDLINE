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
	app._start_as("GENERALIST")
	var g: Game = app.g
	await shot("app_01_map")
	if g.enc.is_empty(): g.enter_node(g.available[0]); app.refresh()
	if g.phase == "READY_RIG" and g.enc.is_empty():
		var pick: Array = g.pending.get("options", [])
		if not pick.is_empty(): g.choose_ready_rig(int(pick[0]))
		else: g.skip_ready_rig()
		app.refresh()
	app.v2.flyout.advance(10.0)
	await shot("app_02_encounter_v2")
	for i in g.enc.ice.size():
		var d := g.ice_definition(g.enc.ice[i])
		for s in d.subs.size():
			if g._has_deadlock(d.subs[s]): g.enc.ice[i].broken[s] = true
	g.enc.breached = true
	app.v2.instant = true
	await app.v2.end_turn()
	app.v2.flyout.advance(10.0)
	await shot("app_03_after_breach_%s" % g.phase.to_lower())
	print("ARCH-V2 APP screenshots: %d written to %s" % [n, out])
	quit(0)
