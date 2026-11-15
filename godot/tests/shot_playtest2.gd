extends SceneTree
## Playtest 2: ECHO's targeted dual-cost SCRIPT and early exit through the UI.
var main: Node
var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error("Playtest 2: " + message)

func _settle() -> void:
	for _i in 15:
		await process_frame
	await RenderingServer.frame_post_draw

func _snap(name: String) -> void:
	var path := OS.get_environment("SHOT_DIR").path_join(name + ".png")
	_check(root.get_texture().get_image().save_png(path) == OK, "saving " + path)
	print("shot ", name)

func _run() -> void:
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle()
	_snap("playtest2_select")
	main._start_as("ECHO")
	var g: Game = main.g
	g.row = 0
	g.available = [1]
	g.enter_node(1)
	# Explicit multilayer fixture for the early-exit regression; production Tier 1 is one layer.
	g.node = g.node.duplicate(true)
	g.node.layers.append({"ice": ["CONSENT_FORM"], "reserve": 23})
	# Fixture funds/cards isolate the new interaction from shuffle luck.
	g.hand.clear()
	var hush := g._new_inst("HUSH")
	g.hand.append(hush)
	_check(g.play_card(hush.uid), "HUSH installs")
	g.installed[0].boost = 5
	var credentials := g._new_inst("BORROWED_CREDENTIALS")
	g.hand.append(credentials)
	g.hand.append(g._new_inst("BASIC_EXTRACTOR"))
	g.cred = 8
	g.bw = 4
	main.refresh()
	await _settle()
	_snap("playtest2_echo_costs")
	main._on_card(credentials.uid)
	_check(main.targeting == credentials.uid and g.bw == 4 and g.cred == 8, "selecting the SCRIPT waits for ICE before payment")
	main._on_ice_clicked(0)
	await _settle()
	_check(g.bw == 3 and g.cred == 0 and g.break_info(0, 3).ok, "chosen ICE enables HUSH after 1 BW + 8 CRED")
	_snap("playtest2_echo_paid")
	main._on_break(0, 3)
	main._on_end_turn()
	if g.pending.get("kind", "") == "hold": main._on_hold_choice(-1)
	await _settle()
	_check(g.phase == "DEEPER", "nonfinal breached layer offers a choice")
	_snap("playtest2_leave_warning")
	var leave: Button = main.find_child("LeaveNodeEarly", true, false)
	_check(leave != null, "leave-without-card-reward control exists")
	if leave != null:
		var deck_size := g.run_deck.size()
		leave.pressed.emit()
		await _settle()
		_check(g.phase == "MAP" and g.reward_options.is_empty() and g.run_deck.size() == deck_size, "early-exit UI goes to map without a card reward")
		_snap("playtest2_left_no_reward")
	print("PLAYTEST 2 UI: %d failures" % failures)
	main.queue_free()
	await _settle()
	quit(1 if failures else 0)
