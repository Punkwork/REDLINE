extends SceneTree
## MAP-003f: captures of the V2 map board for designer review, to SHOT_DIR:
##   map_01_start     a new run: row 1 open
##   map_02_midrun    after three Nodes: the walked path, the next choices open, a Node inspected
var out := ""
var shots := 0

func _initialize() -> void:
	call_deferred("run")

func frames(n := 5) -> void:
	for i in n: await process_frame
	await RenderingServer.frame_post_draw

func shot(name: String) -> void:
	await frames()
	if out == "": return
	root.get_texture().get_image().save_png(out.path_join(name + ".png"))
	shots += 1
	print("shot ", name)

func run() -> void:
	out = OS.get_environment("SHOT_DIR")
	root.size = Vector2i(1600, 1000)
	var g := Game.new(5)
	g.new_run("GENERALIST")
	g.use_generated_map(0)
	var m := NodeMapScreen.new()
	root.add_child(m)
	await frames()
	m.attach(g)
	await shot("map_01_start")
	for step in 3:
		var idx: int = g.available[0]
		g.enter_node(idx)
		match g.phase:
			"UPLINK": g.leave_uplink()
			"SAFEHOUSE": g.safehouse_heal()
			"MAP": pass
			_:
				if g.phase == "READY_RIG": g.skip_ready_rig()
				g._end_ice_node(); g._complete_map_step()
	m.refresh()
	var p: Control = m.pins[g.row + 1][g.available[0]]
	p.grab_focus()
	m.inspector.advance(0.5)
	await shot("map_02_midrun")
	print("NODE MAP screenshots: %d written" % shots)
	quit()
