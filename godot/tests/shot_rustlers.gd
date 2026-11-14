extends SceneTree
## Dev check: render the Rustler screens to SHOT_DIR.
var main: Node
var step := 0
var frames := 0

func _require(ok: bool, message: String) -> bool:
	if not ok:
		push_error("Rustler screenshot setup: " + message)
		quit(1)
	return ok

func _initialize() -> void:
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)

func _snap(name: String) -> void:
	var error := root.get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT_DIR") + "/" + name + ".png")
	_require(error == OK, "could not save " + name)
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
	if step == 4:
		return true
	var g: Game = main.g
	match step:
		0:
			_snap("r1_select")
			main._start_as("VECTOR")
			g = main.g
			g.enter_node(0)
			if not _require(g.phase == "CHOICE" and g.pending.get("kind", "") == "patient_zero", "expected PATIENT ZERO"):
				return true
			g.choose_ice(1)
			if not _require(g.phase == "PLAYER" and g.enc.ice[1].virus.get("ROT", 0) == 1, "PATIENT ZERO must infect the chosen ICE and release the choice"):
				return true
			g.bw = 6
			# Explicit fixture cards/BW, not a natural hand or balance simulation.
			var inject := _hand(g, "INJECT")
			if not _require(g.play_card(inject, 1), "INJECT was rejected"):
				return true
			var scrambler := _hand(g, "SCRAMBLER")
			if not _require(g.play_card(scrambler, 1), "SCRAMBLER was rejected"):
				return true
			if not _require(g.hand.size() == Game.BASE_DRAW and g.enc.ice[1].virus.get("ROT", 0) == 3 and g.enc.ice[1].virus.get("SCRAMBLE", 0) == 2, "virus snapshot must show successful plays and the normal six-card hand"):
				return true
			main.refresh()
		1:
			_snap("r2_vector_virus")
			g.bw = 4
			var runtime_error := _hand(g, "RUNTIME_ERROR")
			if not _require(g.play_card(runtime_error), "RUNTIME ERROR was rejected"):
				return true
			if not _require(g.phase == "CHOICE" and g.pending.get("kind", "") == "card_break" and g.card_break_ok(1, 1), "expected the card-break choice"):
				return true
			main.refresh()
		2:
			_snap("r3_card_break")
			g.choose_sub(1, 1)
			if not _require(g.phase == "PLAYER" and g.enc.ice[1].broken[1], "chosen subroutine was not broken"):
				return true
			g.extract(15)
			if not _require(g.enc.reserve == 0, "expected an empty CRED reserve"):
				return true
			main.refresh()
		3:
			_snap("r4_cred_empty")
			main.queue_free()
	step += 1
	return false
