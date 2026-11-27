extends SceneTree
## ARCH-V2-006 Batch 3: headless checks for the encounter screen's Batch 3 parts. Every check drives
## the real Game through the sandbox (or sets Game state directly where the rules would take many
## turns to get there) and reads only what the screen shows. Drawing never changes Game.

var passed := 0
var failed := 0

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	call_deferred("run")

func sandbox() -> IceEncounterSandbox:
	var sb: IceEncounterSandbox = load("res://scenes/architecture_v2/IceEncounterSandbox.tscn").instantiate()
	sb.instant = true
	root.add_child(sb)
	return sb

func frames(n := 3) -> void:
	for i in n: await process_frame

func run() -> void:
	root.size = Vector2i(1600, 1000)
	print("- header: eye, strikes, LOCKDOWN, legend, Ghostware reel")
	await test_header()
	print("ARCH-V2 BATCH 3: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

func test_header() -> void:
	var sb := sandbox()
	await frames()
	var g := sb.game
	var eye := sb.eye
	check(eye != null and sb.stage.find_child("Logo", false, false) == null, "the eye replaces the PANOPTICON plate")
	check(eye.position.x < 20.0 and eye.position.y < 10.0, "eye sits in the very top-left corner")
	# Alarm lamp: cool at no reveal, hotter with TRACE, full red at Mask off.
	check(is_equal_approx(eye.reveal, 0.0), "no reveal at TRACE %d" % g.trace)
	var cool := eye.lens_colour()
	g.trace = 30; sb.refresh()
	check(eye.reveal > 0.2 and eye.reveal < 0.6, "Cracking reveal between 20% and 60% at TRACE 30 (%.2f)" % eye.reveal)
	var warm := eye.lens_colour()
	check(warm.r > cool.r and warm.g < cool.g, "lens warms toward red as the reveal grows")
	g.strikes = 2; sb.refresh()
	check(is_equal_approx(eye.reveal, 1.0) and eye.lens_colour().is_equal_approx(HudWidgets.EyeLamp.HOT), "Mask off: full red")
	check(eye.strikes == 2 and not eye.lockdown, "two strike lamps lit")
	g.strikes = 3; g.lockdown = true; sb.refresh()
	check(eye.lockdown and eye.title == "LOCKDOWN", "LOCKDOWN shown on the eye")
	# Hover: place line, reveal and the legend with icons.
	eye.grab_focus(); await frames(2)
	check(sb.inspector.visible and is_same(sb.inspector.subject, eye), "eye explains itself on focus")
	var words := _inspector_text(sb)
	check(words.contains("NODE N2A") and words.contains("LAYER 1 / 1"), "hover names the Node and layer")
	check(words.contains("DEADLOCK") and words.contains("CORTEX"), "hover carries the KEY LEGEND")
	eye.release_focus(); sb.inspector.close()
	# Ghostware reel: ORIGIN first, arrows roll, hover shows the art large.
	var reel := sb.ghost_reel
	check(reel.items.size() == 1 and reel.current().get("origin", false), "ORIGIN Ghostware shows first")
	check(reel.up.disabled and reel.down.disabled, "arrows idle with one Ghostware")
	g.ghostware.append("HEARTBEAT"); g.ghostware.append("ONE_TRICK"); sb.refresh()
	check(reel.items.size() == 3 and not reel.down.disabled, "three Ghostware, arrows live")
	reel.down.pressed.emit()
	check(reel.current().name == "HEARTBEAT", "down rolls to the next Ghostware")
	reel.up.pressed.emit(); reel.up.pressed.emit()
	check(reel.current().name == "ONE TRICK", "up wraps to the last")
	reel.window.grab_focus(); await frames(2)
	check(sb.inspector.visible and sb.inspector.find_child("Image", true, false).get_child_count() > 0, "hover shows the Ghostware picture")
	check(_inspector_text(sb).contains("ONE TRICK"), "hover names the Ghostware")
	reel.window.release_focus(); sb.inspector.close()
	var before := [g.trace, g.strikes, g.ghostware.size(), g.bw]
	sb.refresh(); sb.refresh()
	check([g.trace, g.strikes, g.ghostware.size(), g.bw] == before, "refresh does not change Game")
	sb.queue_free(); await frames()

func _inspector_text(sb: IceEncounterSandbox) -> String:
	var out := ""
	for l in sb.inspector.find_children("*", "Label", true, false): out += (l as Label).text + "\n"
	return out
