extends SceneTree
## Saves screenshots of the main screens, to review icons and card edges without playing.
## Needs a real renderer (not --headless). On Linux without a display:
##     xvfb-run -s "-screen 0 1600x900x24" godot --path godot --script res://tests/screenshots.gd -- /tmp/shots
## Default output folder: user://screenshots

const Heist = preload("res://scripts/core/heist.gd")

var ui
var out_dir := "user://screenshots"
var frame := 0
var steps: Array = []


func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	ui = load("res://scenes/main.tscn").instantiate()
	root.add_child(ui)
	steps = [
		["menu", func(): ui._go_menu()],
		["encounter", _setup_encounter],
		["uplink", _setup_uplink],
		["reward", _setup_reward],
		["payload", _setup_payload],
	]


func _process(_delta: float) -> bool:
	frame += 1
	# Each step: set up on one frame, capture a few frames later.
	var i := frame / 6
	var phase := frame % 6
	if i >= steps.size():
		print("Screenshots saved to %s" % ProjectSettings.globalize_path(out_dir))
		quit(0)
		return true
	if phase == 1:
		steps[i][1].call()
	elif phase == 5:
		var img := root.get_texture().get_image()
		var path := "%s/%02d_%s.png" % [out_dir, i + 1, steps[i][0]]
		img.save_png(path)
		print("saved ", path)
	return false


func _heist(rid: String, corp: String) -> void:
	ui.menu_corp = corp
	ui._start_heist(rid, 7, corp)


## An encounter hand with one card from each owner, and a full Ghostware rack.
func _setup_encounter() -> void:
	_heist("vector", "ironwatch")
	var h = ui.heist
	h.choose_node(h.reachable()[0])
	var node = ui.node
	if node.phase == "ready_rig":
		node.ready_rig_choose(-1)
	var run = h.run
	for gid in ["subdermal_plating", "black_mirror", "kevlar_weave", "voice_mimic", "lucid_dream", "killswitch", "chaos_engine"]:
		run.add_ghostware(gid)
	run.gain_cap("zero_day")
	run.gain_cap("bw_spike", true)
	node.hand.clear()
	for id in ["probe", "icepick_wall", "hush", "sledge", "inject", "citation"]:
		node.hand.append(run.make_temp_card(id))
	node.changed.emit()


func _setup_uplink() -> void:
	_heist("riot", "halcyon")
	ui.heist._open_uplink(true)


func _setup_reward() -> void:
	_heist("echo", "lucida")
	var h = ui.heist
	h.choose_node(h.reachable()[0])
	var node = ui.node
	node.reward_options = ["skeleton_key", "surge_protector", "long_game", "deep_probe"]
	node.phase = "reward"
	node.changed.emit()


func _setup_payload() -> void:
	_heist("generalist", "lucida")
	var h = ui.heist
	h.choose_node(h.reachable()[0])
	var node = ui.node
	node.payload_options = ["neural_firewall", "bleeding_edge", "money_mule"]
	node.phase = "payload"
	node.changed.emit()
