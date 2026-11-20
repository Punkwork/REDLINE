extends SceneTree
## ICE-ANALOG-001: the real CAPTCHA encounter with analog ICE consoles, icon keys and key tips.
## Captures Friendly, a key tip (mouse and keyboard focus), Cracking at turn 3 and Mask off with Black ICE.
var main: Node
var failures := 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
	if not ok: failures += 1; push_error("ICE-ANALOG: " + message)
func settle(frames: int = 12) -> void:
	for i in frames: await process_frame
	await RenderingServer.frame_post_draw
func snapshot(name: String) -> void:
	if main.tween and main.tween.is_running(): main.tween.custom_step(100)
	main.nr_text.visible_ratio = 1
	await settle()
	check(root.get_texture().get_image().save_png(OS.get_environment("SHOT_DIR").path_join(name + ".png")) == OK, "save " + name)
	print("shot ", name)
func keys() -> Array:
	return main.friendly.ice_row.find_children("*", "IceKey", true, false).filter(func(k): return not k.small)
func drop_for(key: IceKey) -> FriendlyDropTarget:
	return key.get_parent().get_child(1) as FriendlyDropTarget
func check_keys(label: String) -> void:
	var view: FriendlyEncounter = main.friendly
	var all := keys()
	check(all.size() >= 4, label + ": icon keys drawn (%d)" % all.size())
	for k: IceKey in all:
		var r: Rect2 = k.get_global_rect()
		var kr: Rect2 = k.key_rect()
		# The ICE area is scaled; measure the key face on screen.
		var scale_y: float = k.get_global_transform().get_scale().y
		check(kr.size.y * scale_y >= 44.0, label + ": key target at least 44 px (%.1f)" % (kr.size.y * scale_y))
		check(r.end.y <= FriendlyEncounter.HAND_RECT.position.y, label + ": key clear of the hand")
	for column in view.ice_row.get_children():
		check(column.get_child(1).size.x <= column.size.x + 1, label + ": console fits its column")
func check_tip(key: IceKey, how: String) -> void:
	var tip: PanelContainer = main.friendly.key_tip
	check(tip.visible, how + ": key tip opens")
	var tr := tip.get_global_rect()
	check(not tr.intersects(key.get_global_rect().grow(-2)), how + ": tip does not cover its key")
	check(tr.end.y <= FriendlyEncounter.HAND_RECT.position.y + 1, how + ": tip clear of the hand")
	var text := " ".join(tip.find_children("*", "Label", true, false).map(func(l): return l.text))
	check(text.contains("Rule:") and text.contains("Timing:"), how + ": tip has the full rule")
func run() -> void:
	main = load("res://scenes/Main.tscn").instantiate(); root.add_child(main); main.voice_on = false; main.voice.stop(); await settle()
	main.reduced_motion = true; main._start_as("GENERALIST")
	var g: Game = main.g; g.rng.seed = 711; g.animate = false
	g.row = 0; g.available = [0]; g.enter_node(0)
	if g.phase == "READY_RIG":
		g.choose_ready_rig(g.draw_pile.filter(func(c): return c.id == "FORTRESS_ICEPICK")[0].uid)
	main.refresh(); Input.warp_mouse(Vector2(20, 150)); await settle()
	check(g.enc.ice[0].id == "AUTO_RENEW" and g.enc.ice[1].id == "CAPTCHA", "real CAPTCHA node")
	check_keys("friendly")
	await snapshot("ICE-ANALOG-001_01_friendly")
	# Mouse hover over the first CAPTCHA key.
	var captcha: Array = keys().filter(func(k): return is_same(drop_for(k).ice_ref, g.enc.ice[1]))
	var target: IceKey = captcha[0]
	var p: Vector2 = target.get_global_rect().get_center()
	var motion := InputEventMouseMotion.new(); motion.position = p; motion.global_position = p
	Input.warp_mouse(p); root.push_input(motion); await settle()
	check_tip(target, "hover")
	await snapshot("ICE-ANALOG-001_02_tooltip_hover")
	Input.warp_mouse(Vector2(20, 150)); var away := InputEventMouseMotion.new(); away.position = Vector2(20, 150); root.push_input(away); await settle()
	# Keyboard focus on the first AUTO-RENEW key.
	var first: IceKey = keys()[0]
	drop_for(first).grab_focus(); await settle()
	check_tip(first, "focus")
	await snapshot("ICE-ANALOG-001_03_tooltip_focus")
	drop_for(first).release_focus(); await settle()
	# ENC-CONCEPT-001 layout pass: the KEY LEGEND card toggles over the right console.
	var legend_button: Button = main.friendly.get_node("LegendButton")
	legend_button.pressed.emit(); await settle()
	check(main.friendly.legend.visible, "KEY LEGEND opens the legend card")
	await snapshot("ENC-CONCEPT-001_06_key_legend")
	legend_button.pressed.emit(); await settle()
	check(not main.friendly.legend.visible, "KEY LEGEND closes it again")
	# Cracking, turn 3: AUTO-RENEW hardened with S1 broken; CAPTCHA probed.
	var c := g._new_inst("TUMBLER_ICEPICK"); g.hand.append(c); g.bw = 8; g.play_card(c.uid)
	g.bw = 4; check(g.break_sub(0, 0), "break AUTO-RENEW S1")
	for turn in 2:
		g.end_turn()
		while g.phase == "CHOICE" and g.pending.get("kind") == "discard": g.choose(g.hand[0].uid)
	g.add_trace(30 - g.trace, false)
	main.refresh(); await settle()
	check(main.friendly.corporation_state == "cracking", "cracking state")
	check(keys().any(func(k): return k.state == "broken"), "a broken key shows")
	check_keys("cracking")
	await snapshot("ICE-ANALOG-001_04_cracking")
	# Mask off: two strikes bring HOUSE CALL in as a third ICE.
	g.add_trace(40, false); main.friendly.dismiss_strike(); g.add_trace(40, false); main.refresh(); await settle()
	check(g.enc.ice.size() == 3, "Black ICE joins (3 ICE)")
	check_keys("three ICE")
	await snapshot("ICE-ANALOG-001_05_mask_off_three_ice")
	print("ICE-ANALOG-001: %d failures" % failures)
	main.voice.stop(); main.voice.stream = null; main.queue_free(); await settle(); quit(1 if failures else 0)
