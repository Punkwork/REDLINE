extends SceneTree
## Loads the main scene headless, clicks through a few actions, and fails on script errors.
##     godot --headless --path godot --script res://tests/smoke_ui.gd

var frames := 0
var ui


func _init() -> void:
	ui = load("res://scenes/main.tscn").instantiate()
	root.add_child(ui)


func _process(_delta: float) -> bool:
	frames += 1
	if frames > 20 or not ("node" in ui):
		print("UI smoke test: FAILED (scene script did not load)")
		quit(1)
		return true
	if frames == 2:
		var node = ui.node
		if node.phase == "ready_rig":
			node.ready_rig_choose(node.ready_rig_options()[0]["uid"])
		for inst in node.hand.duplicate():
			if node.can_play(inst)["ok"]:
				node.play_card(inst["uid"])
		node.end_turn()
	if frames == 4:
		var ok: bool = ui.node != null and ui.hand_row.get_child_count() > 0 or ui.overlay.visible
		print("UI smoke test: %s (phase %s)" % ["OK" if ok else "FAILED", ui.node.phase])
		quit(0 if ok else 1)
	return false
