extends SceneTree
## Dev check: capture TUMBLER reels mid-spin and the END RUN confirmation.
var main: Node
var step := 0
var frames := 0
var n := 0

func _initialize() -> void:
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)

func _snap(name: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT_DIR") + "/" + name + ".png")
	print("shot ", name)

func _process(_d: float) -> bool:
	frames += 1
	var g: Game = main.g
	match step:
		0:
			if frames < 30:
				return false
			main._start_as("GENERALIST")
			g = main.g
			g.enter_node(0)
			if g.phase == "READY_RIG":
				g.skip_ready_rig()
			main.refresh()
			step = 1
			frames = 0
		1:
			if frames < 30:
				return false
			_snap("reel0_before")
			main._on_end_turn()
			step = 2
			frames = 0
		2:
			if main.spinning and frames % 6 == 0:
				n += 1
				_snap("reel%d" % n)
			if not main.spinning and n > 0:
				step = 3
				frames = 0
		3:
			if frames < 20:
				return false
			_snap("reel_after")
			main._confirm_end_run()
			step = 4
			frames = 0
		4:
			if frames < 20:
				return false
			_snap("endrun_confirm")
			return true
	return false
