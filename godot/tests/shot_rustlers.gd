extends SceneTree
## Dev check: render the Rustler screens to SHOT_DIR.
var main: Node
var step := 0
var frames := 0

func _initialize() -> void:
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)

func _snap(name: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT_DIR") + "/" + name + ".png")
	print("shot ", name)

func _hand(g: Game, id: String) -> int:
	var inst := g._new_inst(id)
	g.hand.append(inst)
	return inst.uid

func _process(_d: float) -> bool:
	frames += 1
	if frames < 40:
		return false
	frames = 0
	var g: Game = main.g
	match step:
		0:
			_snap("r1_select")
			main._start_as("VECTOR")
			g = main.g
			g.enter_node(0)
			g.bw = 6
			g.play_card(_hand(g, "INJECT"), 1)
			g.play_card(_hand(g, "SCRAMBLER"), 1)
			main.refresh()
		1:
			_snap("r2_vector_virus")
			g.bw = 4
			g.play_card(_hand(g, "RUNTIME_ERROR"))
			main.refresh()
		2:
			_snap("r3_card_break")
			return true
	step += 1
	return false
