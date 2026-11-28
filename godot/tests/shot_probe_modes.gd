extends SceneTree
## CSA-04b (PROBE-004a): the V2 screen asking which PROBE mode on a VOID with hidden subroutines.
## Writes probe_modes_choice.png to SHOT_DIR.

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	root.size = Vector2i(1600, 1000)
	var sb: IceEncounterSandbox = load("res://scenes/architecture_v2/IceEncounterSandbox.tscn").instantiate()
	sb.instant = true
	sb.flags_path = "user://shot_probe_modes_flags.json"
	root.add_child(sb)
	for i in 4: await process_frame
	var g := Game.new(1)
	g.new_run(); g.enter_node(0)
	g.choose_ready_rig(g.draw_pile.filter(func(c): return c.id == "TUMBLER_ICEPICK")[0].uid)
	g.new_run(); g.row = 1; g.available = [1]; g.enter_node(1)   # DOORBELL CAM, a VOID, face-down
	if g.phase == "READY_RIG": g.choose_ready_rig(g.draw_pile.filter(func(c): return c.id == "VOID_ICEPICK")[0].uid)
	sb.attach(g)
	var c: Dictionary = g._new_inst("PROBE"); g.hand.append(c)
	sb.refresh()
	for i in 4: await process_frame
	sb.play_targeted(int(c.uid), g.enc.ice[0]); sb.refresh()
	for i in 8: await process_frame
	var dir := OS.get_environment("SHOT_DIR")
	if dir != "":
		root.get_texture().get_image().save_png(dir.path_join("probe_modes_choice.png"))
		print("PROBE MODES: 1 screenshot written to ", dir)
	quit()
