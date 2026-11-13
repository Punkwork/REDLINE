extends SceneTree
## Loads the main scene, then lets the test bot play a Training Node and a whole HALCYON heist through
## the UI (every state change rebuilds the screens). Check the output for SCRIPT ERROR lines.
##     godot --headless --path godot --script res://tests/smoke_ui.gd

const Bot = preload("res://tests/bot.gd")

var frames := 0
var ui


func _init() -> void:
	ui = load("res://scenes/main.tscn").instantiate()
	root.add_child(ui)


func _process(_delta: float) -> bool:
	frames += 1
	if frames > 30 or not ("mode" in ui):
		print("UI smoke test: FAILED (scene script did not load)")
		quit(1)
		return true
	if frames == 2:
		ui._start_training()
		Bot.new().play_node(ui.node)
		print("Training Node through the UI: %s" % ui.node.phase)
	if frames == 4:
		for rid in ["generalist", "echo", "riot", "vector"]:
			ui._start_heist(rid)
			Bot.new().play_heist(ui.heist, 2)
			print("%s heist through the UI: %s (%s)" % [rid, ui.heist.phase, "won" if ui.heist.won else "lost"])
	if frames == 6:
		var ok: bool = ui.mode == "heist" and ui.heist.phase == "summary" and ui.screen_body.get_child_count() > 0
		print("UI smoke test: %s" % ("OK" if ok else "FAILED"))
		quit(0 if ok else 1)
	return false
