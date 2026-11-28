extends Control
## UI-TYPO-001 / UI-TYPO-001a / UI-TYPO-002 (M06): the event typography and motion fixture, now driving
## the production components: the Architecture V2 encounter (IceEncounterSandbox), its EventFlyout and
## the ICE panels' LethalLens, with the real Game. No mock flyout lives here any more.
## Interactive: a button per event (and LETHAL), reduced motion, and the real console underneath.
## Capture (SHOT_DIR set): each treatment at enter, hold and exit, MASK OFF's withdrawn image, LETHAL
## on one ICE, every treatment under reduced motion, a competing queue and an input pass-through
## check. Prints "UI-TYPO-002 event fixture: PASS" and exits 0 when every check holds.

const REF := Vector2i(1536, 864)
const KINDS := ["rustler_turn", "corp_countermeasure", "breached", "lockdown", "mask_off", "parting_shot", "full_extraction"]

var sb: IceEncounterSandbox
var motion_toggle: CheckButton
var passed := true
var shots := 0

func _ready() -> void:
	if get_parent() is Window and not OS.get_environment("SHOT_DIR").is_empty():
		capture.call_deferred()
		return
	build()

func fresh(reduced := false) -> void:
	if is_instance_valid(sb): sb.queue_free(); await get_tree().process_frame
	sb = load("res://scenes/architecture_v2/IceEncounterSandbox.tscn").instantiate()
	sb.reduced_motion = reduced
	sb.instant = true
	sb.flags_path = "user://ui_typo_fixture_flags.json"
	add_child(sb)
	move_child(sb, 0)
	await settle()

func build() -> void:
	await fresh()
	var bar := HBoxContainer.new(); bar.name = "SpecimenBar"
	bar.position = Vector2(12, 12)
	var layer := CanvasLayer.new(); layer.layer = 10; add_child(layer); layer.add_child(bar)
	for k in KINDS:
		var b := Button.new(); b.text = String(VasTokens.FLYOUT[k].text)
		b.pressed.connect(func(): sb.flyout.announce(k))
		bar.add_child(b)
	var lethal := Button.new(); lethal.text = "LETHAL"
	lethal.pressed.connect(func():
		var ice: Dictionary = sb.game.enc.ice[0]
		ice["lethal"] = not ice.get("lethal", false)
		sb.refresh())
	bar.add_child(lethal)
	motion_toggle = CheckButton.new(); motion_toggle.text = "Reduced motion"
	motion_toggle.toggled.connect(func(on: bool): sb.reduced_motion = on; sb.refresh())
	bar.add_child(motion_toggle)

func settle(n := 6) -> void:
	for i in n: await get_tree().process_frame
	await RenderingServer.frame_post_draw

func expect(ok: bool, what: String) -> void:
	if not ok:
		passed = false
		push_error("FIXTURE FAIL: " + what)

func shot(name: String) -> void:
	await settle()
	var path := OS.get_environment("SHOT_DIR").path_join(name + ".png")
	expect(get_viewport().get_texture().get_image().save_png(path) == OK, "saved " + name)
	shots += 1

func at(k: String, phase: String, frac := 0.5) -> float:
	var T := VasTokens.flyout_timing(k)
	var start := 0.0
	for p in ["enter", "reveal", "hold", "exit"]:
		if p == phase: return start + float(T[p]) * frac
		start += float(T[p])
	return start

func capture() -> void:
	get_window().size = REF
	await fresh()
	expect(sb.flyout.mask_art != null and sb.flyout.missing_assets().is_empty(), "MASK OFF artwork bound")
	# Each treatment at its entry, its readable hold and its exit.
	for k in KINDS:
		for phase in ["enter", "hold", "exit"]:
			sb.flyout.hold_at(k, at(k, phase))
			await shot("M06-%s-%s" % [k, phase])
	# MASK OFF with the mask withdrawn: the complete image, still see-through.
	sb.flyout.hold_at("mask_off", at("mask_off", "exit", 0.48))
	expect(sb.flyout.band_opacity() <= EventFlyout.BAND_ALPHA + 0.001, "withdrawn mask stays translucent")
	await shot("M06-mask_off-withdrawn")
	# RESERVE EXTRACTED part-way: EXTRACTED part-lit while the CRED readout counts.
	sb.flyout.hold_at("full_extraction", at("full_extraction", "reveal", 0.5))
	await shot("M06-full_extraction-illuminating")
	sb.flyout.advance(10.0)
	# LETHAL: the lens on one ICE only, no flyout.
	var ice: Dictionary = sb.game.enc.ice[1 if sb.game.enc.ice.size() > 1 else 0]
	ice["lethal"] = true
	sb.game._event("ICE_LETHAL", {"ice": ice.id})
	sb.refresh()
	for l in sb.lane.find_children("LethalLens", "LethalLens", true, false): (l as LethalLens).advance(2.0)
	expect(not sb.flyout.playing, "LETHAL makes no global announcement")
	expect(sb.lane.find_children("LethalLens", "LethalLens", true, false).filter(func(l): return l.active).size() == 1, "one LETHAL lens")
	await shot("M06-lethal-lens")
	ice["lethal"] = false; sb.refresh()
	# Competing events: LOCKDOWN playing, MASK OFF and PARTING SHOT waiting their turn.
	sb.flyout.announce("lockdown"); sb.flyout.announce("mask_off"); sb.flyout.announce("parting_shot")
	sb.flyout.set_process(false)
	sb.flyout.advance(at("lockdown", "hold"))
	expect(sb.flyout.kind == "lockdown" and sb.flyout.queued() == ["mask_off", "parting_shot"], "competing events queue in order")
	await shot("M06-competing-queue")
	# Input passes through a playing flyout: the real END TURN key still ends the turn.
	var turn0 := int(sb.game.enc.turn)
	for pressed in [true, false]:
		var ev := InputEventMouseButton.new()
		ev.button_index = MOUSE_BUTTON_LEFT; ev.pressed = pressed
		ev.position = sb.end_key.get_global_rect().get_center()
		ev.global_position = ev.position
		get_viewport().push_input(ev, true)   # viewport (not window) coordinates: the view is stretched
		await get_tree().process_frame
	# The fixture resolves the response at once, so a pressed END TURN shows as the next turn.
	expect(int(sb.game.enc.turn) > turn0 or sb.game.phase != "PLAYER", "END TURN works under a playing flyout (turn %d → %d)" % [turn0, int(sb.game.enc.turn)])
	# Reduced motion: every treatment as a plain fade in place, at its hold.
	await fresh(true)
	for k in KINDS:
		sb.flyout.hold_at(k, at(k, "hold"))
		await shot("M06-reduced-%s" % k)
	print("UI-TYPO-002 event fixture: %d screenshots · %s" % [shots, "PASS" if passed else "FAIL"])
	get_tree().quit(0 if passed else 1)
