extends SceneTree
# Renders the main scene in several states and saves PNGs to user:// (dev check only).

var main: Node
var step := 0
var frames := 0

func _initialize() -> void:
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)

func _snap(name: String) -> void:
	var img := root.get_viewport().get_texture().get_image()
	img.save_png(OS.get_environment("SHOT_DIR") + "/" + name + ".png")
	print("shot ", name)

func _process(_d: float) -> bool:
	frames += 1
	if frames < 30:
		return false
	frames = 0
	var g = main.g
	match step:
		0:
			_snap("01_map")
			g.enter_node(0)
			main.refresh()
		1:
			_snap("02_ready_rig")
			var rid := -1
			for u in g.pending.options:
				if g._find(g.draw_pile, u).id == "TUMBLER_ICEPICK":
					rid = u
			g.choose_ready_rig(rid)
			main.refresh()
		2:
			_snap("03_encounter")
			# play a couple of installs if possible
			for c in g.hand.duplicate():
				if g.can_play(c.uid).ok and CardDB.def(c.id).type == "PROGRAM":
					g.play_card(c.uid, -1)
					break
			main.refresh()
		3:
			_snap("04_after_install")
			g.end_turn()
			main.refresh()
		4:
			_snap("05_after_response")
			if g.phase == "CHOICE":
				g.choose(g.hand[0].uid)
			main._show_inspect(g.installed[0].inst.id if not g.installed.is_empty() else "")
			main.refresh()
			main._show_inspect(g.installed[0].inst.id if not g.installed.is_empty() else "")
		5:
			_snap("06_inspect")
			g.new_run()
			g.entered_corp = true
			g.row = 1
			g.available = [1]
			g.enter_node(1)
			if g.phase == "READY_RIG":
				g.skip_ready_rig()
			main.refresh()
		6:
			_snap("07_void")
			return true
	step += 1
	return false
