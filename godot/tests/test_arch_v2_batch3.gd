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
	print("- rail: LAYER, CRED and extraction ants, log, parting shot")
	await test_rail()
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

func test_rail() -> void:
	var sb := sandbox()
	await frames()
	var g := sb.game
	var lg := sb.ledger
	check(lg.layers == 1 and lg.current == 0, "LAYER mark: N2A has one layer")
	check(lg.reserve == int(g.enc.reserve) and lg.cred == g.cred, "ledger shows CRED and the layer reserve")
	check(lg.cred_cell.position.x < lg.reserve_cell.position.x, "layer CRED sits right of the Rustler's CRED")
	check(lg.position.x < sb.rail.position.x, "ledger sits at the left end of the rail")
	# Extraction through the rules: ants run left, CRED counts up to the new value.
	var before := g.cred
	g.extract(5); sb.refresh()
	check(g.cred == before + 5 and lg.cred == g.cred, "ledger has the new CRED")
	check(lg.ants > 0.0 and roundi(lg.shown_cred) == before, "ants run before the count goes up")
	for i in 90: await process_frame
	lg.finish()
	check(roundi(lg.shown_cred) == g.cred, "CRED window counts up to the new value")
	sb.reduced_motion = true; sb.refresh()
	g.extract(2); sb.refresh()
	check(lg.ants == 0.0 and roundi(lg.shown_cred) == g.cred, "reduced motion: no ants, value at once")
	sb.reduced_motion = false
	# LAYER mark on a three-layer Node (display model only).
	lg.set_values(3, 1, g.cred, 4)
	check(lg.layers == 3 and lg.layer_mark.title == "LAYER 2 / 3", "three layers, second lit")
	sb.refresh()
	# Log: hover on the rail shows the latest lines; a click pins the full log; Esc closes.
	g.log.append("Test line for the log.")
	sb.refresh()
	sb.rail_log.grab_focus(); await frames(2)
	check(sb.inspector.visible and _inspector_text(sb).contains("Test line for the log."), "rail hover shows the latest log lines")
	sb.rail_log.release_focus(); sb.inspector.close()
	sb.toggle_log()
	check(sb.log_panel.visible and sb.log_panel.count() == g.log.size(), "click pins the full log")
	var esc := InputEventAction.new(); esc.action = "ui_cancel"; esc.pressed = true
	sb._unhandled_input(esc)
	check(not sb.log_panel.visible, "Esc closes the log")
	check(sb.find_child("Ticker", true, false) == null, "no log ticker")
	# Parting shot: after a BREACH the PULP meter and END TURN say what fires; the rail drops DEADLOCKs.
	g.enc.breached = true; sb.refresh()
	check(sb.meters.PULP.title.begins_with("PARTING SHOT"), "PULP meter becomes PARTING SHOT after BREACH")
	check(sb.end_key.lines.size() == 1 and String(sb.end_key.lines[0]).begins_with("Parting shot"), "END TURN hover states the parting shot")
	var dl := false
	for c in sb.rail.steps(): dl = dl or String(c.model.kind) == "DEADLOCK"
	check(not dl, "parting-shot rail has no DEADLOCK")
	sb.queue_free(); await frames()

func _inspector_text(sb: IceEncounterSandbox) -> String:
	var out := ""
	for l in sb.inspector.find_children("*", "Label", true, false): out += (l as Label).text + "\n"
	return out
