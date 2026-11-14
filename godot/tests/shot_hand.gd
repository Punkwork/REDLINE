extends SceneTree
## UI-003: large-hand geometry, scrolling and real GUI click checks.
## SHOT_DIR must exist. Run with a display, like the other screenshot scripts.
var main: Node
var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _check(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		push_error("Hand layout: " + message)

func _settle() -> void:
	for _i in 15:
		await process_frame
	await RenderingServer.frame_post_draw

func _snap(name: String) -> void:
	var path := OS.get_environment("SHOT_DIR").path_join(name + ".png")
	_check(root.get_texture().get_image().save_png(path) == OK, "saving " + path)
	print("shot ", name)

func _visible_rect(card: Control) -> Rect2:
	return card.get_global_rect().intersection(main.hand_scroll.get_global_rect())

func _geometry() -> void:
	var viewport: Rect2 = main.hand_scroll.get_global_rect()
	_check(viewport.end.x <= main.end_btn.get_global_rect().position.x, "hand viewport stays left of END TURN")
	_check(not viewport.intersects(main.piles.get_global_rect()), "hand viewport stays clear of pile counters")
	_check(main.hand_row.get_child_count() == main.g.hand.size(), "every card has a view")
	for card in main.hand_row.get_children():
		var visible := _visible_rect(card)
		if visible.has_area():
			_check(not visible.intersects(main.end_btn.get_global_rect()), "visible card stays clear of END TURN")
			_check(not visible.intersects(main.piles.get_global_rect()), "visible card stays clear of pile counters")
			var scrollbar: HScrollBar = main.hand_scroll.get_h_scroll_bar()
			var bar_height := scrollbar.size.y if scrollbar.visible else 0.0
			_check(card.size.y <= viewport.size.y - bar_height, "card text fits vertically")

func _run() -> void:
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle()
	for count in [6, 7, 9, 10, 16]:
		main._start_as("VECTOR")
		var g: Game = main.g
		g.enter_node(0)
		g.choose_ice(1)
		_check(g.phase == "PLAYER", "PATIENT ZERO is resolved")
		# Deliberately oversized fixture, not a claim about VECTOR's base DRAW.
		g.hand.clear()
		var ids := ["STINGER", "REPLICATOR", "INJECT", "RUNTIME_ERROR", "PROBE", "OUTBREAK"]
		for i in count - 1:
			g.hand.append(g._new_inst(ids[i % ids.size()]))
		var shield := g._new_inst("PULP_SHIELD")
		g.hand.append(shield)
		main.refresh()
		main.hand_scroll.scroll_horizontal = 0
		await _settle()
		_geometry()
		_snap("hand_%02d_left" % count)
		if main.hand_scroll.get_h_scroll_bar().visible:
			var wheel := InputEventMouseButton.new()
			wheel.position = main.hand_scroll.get_global_rect().get_center()
			wheel.global_position = wheel.position
			wheel.button_index = MOUSE_BUTTON_WHEEL_DOWN
			wheel.factor = 3.0
			wheel.pressed = true
			var old_scroll: int = main.hand_scroll.scroll_horizontal
			Input.parse_input_event(wheel)
			await _settle()
			_check(main.hand_scroll.scroll_horizontal > old_scroll, "mouse wheel scrolls the hand")
		var last: Control = main.hand_row.get_child(count - 1)
		main.hand_scroll.ensure_control_visible(last)
		await _settle()
		_check(_visible_rect(last).size.x >= last.size.x - 1, "last card can be fully revealed")
		_geometry()
		_snap("hand_%02d_right" % count)
		# Refresh must not jump back to the beginning of a large hand.
		var before: int = main.hand_scroll.scroll_horizontal
		main.refresh()
		await _settle()
		_check(absi(main.hand_scroll.scroll_horizontal - before) <= 1, "refresh preserves horizontal position")
		# Send actual mouse input through Godot's GUI to the last card.
		last = main.hand_row.get_child(count - 1)
		var at := _visible_rect(last).get_center()
		var bw_before: int = g.bw
		var down := InputEventMouseButton.new()
		down.position = at
		down.global_position = at
		down.button_index = MOUSE_BUTTON_LEFT
		down.pressed = true
		Input.parse_input_event(down)
		var up := down.duplicate()
		up.pressed = false
		Input.parse_input_event(up)
		await _settle()
		_check(g._find(g.hand, shield.uid).is_empty() and g.bw == bw_before - 1 and g.shield == 3, "last card can be clicked and plays normally")
		_check(g.phase == "PLAYER", "card click does not activate END TURN")
	print("HAND LAYOUT: %d failures" % failures)
	main.free()
	quit(1 if failures else 0)
