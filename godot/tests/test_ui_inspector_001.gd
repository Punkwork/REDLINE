extends SceneTree
## UI-INSPECTOR-001 (designer-approved 2026-11-27): headless checks for the shared hover/rollover
## inspector. Expected values are the approved specification's (UI Bible "Final universal hover and
## rollover specification" and the T1–T5 table), not read back from the implementation: 150 ms
## initial hover, 120 ms entrance, 150 ms grace, 100 ms exit, 6–8 px travel, right-aligned column,
## Jost T1–T5, placement beside the source and inside the viewport, Escape, pointer transfer,
## replacement, cleanup, reduced motion and no rules change from hovering.

var passed := 0
var failed := 0
const APPROVED_TYPE := {   # size px at 1080 p, weight, tracking, uppercase
	"T1": [28, 500, 2, true], "T2": [15, 300, 2, true], "T3": [24, 500, 1, false],
	"T4": [17, 400, 0, false], "T5": [14, 400, 0, false],
}

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	call_deferred("run")

func frames(n := 2) -> void:
	for i in n: await process_frame

func source(pos: Vector2, sz := Vector2(80, 80)) -> Control:
	var c := Button.new(); c.position = pos; c.size = sz; c.focus_mode = Control.FOCUS_ALL
	root.add_child(c)
	return c

func inspector() -> KeyInspector:
	var k := KeyInspector.new(); root.add_child(k)
	return k

func open_on(k: KeyInspector, src: Control, title := "PROBE") -> void:
	k.show_object(src, null, title, "SCRIPT · EXPLOIT", "1 BW", ["−2 STR this encounter"], ["Target: DOORBELL CAM."], "The deeper you probe, the costlier it gets.")

func run() -> void:
	root.size = Vector2i(1920, 1080)
	await frames()
	await test_timing()
	await test_pointer_and_keys()
	await test_placement()
	await test_content_and_type()
	await test_cleanup_and_rules()
	print("UI-INSPECTOR-001: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

func test_timing() -> void:
	var k := inspector(); var a := source(Vector2(900, 600)); var b := source(Vector2(1100, 600))
	open_on(k, a)
	k.advance(0.140)
	check(not k.visible, "nothing before the 150 ms initial hover")
	k.advance(0.015)
	check(k.visible and k.state == "open", "opens at 150 ms")
	check(k.modulate.a < 0.5, "entrance starts as a fade")
	var start := k.global_position
	k.advance(0.120)
	var travel := start.distance_to(k.global_position)
	check(is_equal_approx(k.modulate.a, 1.0), "entrance complete at 120 ms")
	check(travel >= 5.5 and travel <= 8.0, "6–8 px travel from the source's direction (%.1f px)" % travel)
	check(k.placement_ok(), "stationary beside the source once open")
	# Rapid scanning: another object replaces the content at once, without a new delay.
	open_on(k, b, "PIVOT")
	check(k.visible and is_same(k.subject, b) and _words(k).has("PIVOT"), "switching objects replaces content immediately")
	# Leaving: 150 ms grace, then a 100 ms exit.
	k.close(b)
	k.advance(0.140)
	check(k.visible and k.state == "grace", "still open inside the 150 ms grace")
	k.advance(0.020)
	check(k.state == "exiting", "exit begins after the grace")
	k.advance(0.080)   # 240 ms after leaving
	check(k.visible, "exit lasts 100 ms")
	k.advance(0.015)   # 255 ms
	check(not k.visible and k.state == "hidden", "hidden after grace + exit (250 ms)")
	# A close during the initial delay cancels the open.
	open_on(k, a); k.advance(0.05); k.close(a); k.advance(0.3)
	check(not k.visible, "leaving before 150 ms never opens it")
	# Reduced motion: no animated transition.
	k.reduced_motion = true
	open_on(k, a); k.advance(0.151)
	check(k.visible and is_equal_approx(k.modulate.a, 1.0), "reduced motion: instant appearance")
	k.close(a); k.advance(0.151)
	check(not k.visible, "reduced motion: instant disappearance after the grace")
	for n in [k, a, b]: n.queue_free()
	await frames()

func test_pointer_and_keys() -> void:
	var k := inspector(); var a := source(Vector2(900, 600))
	open_on(k, a); k.advance(0.3)
	k.close(a); k.advance(0.05)
	k.mouse_entered.emit()
	k.advance(0.5)
	check(k.visible and k.state == "open", "the pointer over the inspector keeps it open")
	k.mouse_exited.emit(); k.advance(0.3)
	check(not k.visible, "leaving the inspector dismisses it")
	open_on(k, a); k.advance(0.3)
	var esc := InputEventKey.new(); esc.keycode = KEY_ESCAPE; esc.pressed = true
	root.push_input(esc); await frames()
	check(not k.visible, "Escape dismisses immediately")
	a.grab_focus(); open_on(k, a)
	check(k.visible, "keyboard focus gives the same information at once")
	a.release_focus()
	for n in [k, a]: n.queue_free()
	await frames()

func test_placement() -> void:
	var k := inspector()
	var vp := Vector2(root.size)
	for p in [Vector2(10, 10), Vector2(vp.x - 90, 10), Vector2(10, vp.y - 90), Vector2(vp.x - 90, vp.y - 90),
			Vector2(vp.x / 2 - 40, 10), Vector2(vp.x / 2 - 40, vp.y - 90), Vector2(vp.x / 2 - 40, vp.y / 2 - 40)]:
		var s := source(p)
		open_on(k, s); k.advance(0.3)
		check(k.placement_ok(), "inside the viewport and never over its source at %s" % p)
		k.clear(); s.queue_free()
	k.queue_free()
	await frames()

func test_content_and_type() -> void:
	var k := inspector(); var a := source(Vector2(900, 700))
	open_on(k, a); k.advance(0.3)
	var labels: Array = k.find_children("*", "Label", true, false)
	check(labels.all(func(l): return l.horizontal_alignment == HORIZONTAL_ALIGNMENT_RIGHT), "explanatory column right-aligned")
	var order := labels.map(func(l): return String(l.text))
	check(order == ["PROBE", "SCRIPT · EXPLOIT", "1 BW", "−2 STR this encounter", "Target: DOORBELL CAM.", "The deeper you probe, the costlier it gets."],
		"contract order: identity, classification, cost, effect, restrictions, flavour last (%s)" % [order])
	var scale := k.get_viewport_rect().size.y / 1080.0   # the logical viewport the stretched UI uses
	var levels := ["T1", "T2", "T3", "T4", "T5", "T5"]
	for i in levels.size():
		var l: Label = labels[i]
		var spec: Array = APPROVED_TYPE[levels[i]]
		var f := l.get_theme_font("font") as FontVariation
		var base := f.base_font as FontFile if f else null
		check(base != null and base.font_name.begins_with("Jost"), "%s set in Jost" % levels[i])
		check(l.get_theme_font_size("font_size") == roundi(spec[0] * scale), "%s at %d px (1080 p)" % [levels[i], spec[0]])
		check(f != null and f.spacing_glyph == int(spec[2]), "%s tracking %+d" % [levels[i], spec[2]])
	check((labels[5].get_theme_font("font") as FontVariation).base_font.resource_path.contains("Italic"), "flavour in T5 italic")
	check(VasTokens.JOST[300].resource_path.ends_with("Jost-300-Light.ttf") and VasTokens.JOST[500].resource_path.ends_with("Jost-500-Medium.ttf"), "approved weights present (300, 400, 500, 600)")
	check(FileAccess.file_exists("res://assets/fonts/Jost-OFL.txt"), "Jost's SIL OFL licence ships beside the font")
	# Artwork anchored left/top-left of the column.
	var tex := CardView.art_for("res://assets/concept/cards/PROBE.png")
	k.show_object(a, tex, "PROBE", "SCRIPT · EXPLOIT", "1 BW", ["x"])
	var img := k.find_child("Image", true, false) as Control
	var words := k.find_child("Words", true, false) as Control
	await frames()
	check(img.visible and img.get_global_rect().position.x < words.get_global_rect().position.x and img.get_global_rect().position.y <= words.get_global_rect().position.y + 1.0, "artwork left / top-left of the words")
	for n in [k, a]: n.queue_free()
	await frames()

func snapshot(g: Game) -> String:
	return JSON.stringify([g.vitae, g.trace, g.cred, g.bw, g.phase, g.hand.size(), g.draw_pile.size(), g.discard.size(), g.enc.get("turn", 0)])

func test_cleanup_and_rules() -> void:
	var sb: IceEncounterSandbox = load("res://scenes/architecture_v2/IceEncounterSandbox.tscn").instantiate()
	sb.instant = true; sb.flags_path = "user://test_ui_inspector_flags.json"
	root.add_child(sb); await frames(4)
	var g := sb.game
	var before := snapshot(g)
	var card: CardView = sb.hand_fan.find_children("*", "CardView", true, false)[0]
	card.mouse_entered.emit(); sb.inspector.advance(0.3); await frames()
	check(sb.inspector.visible and is_same(sb.inspector.subject, card), "a hand card opens the shared inspector")
	var w := _words(sb.inspector)
	check(w.has(String(card.model.name).to_upper()) and w.any(func(x): return x.ends_with("BW")), "card contract: name and cost")
	check(snapshot(g) == before, "hovering changes no rules state")
	# A modal opening clears it.
	sb.choice.open({"kind": "mode", "title": "PROBE", "text": "Choose one.", "options": [{"label": "Cancel", "intent": "mode_cancel"}]})
	check(not sb.inspector.visible, "a modal opening clears the inspector")
	sb.choice.open({})
	# The source removed clears it.
	card.mouse_entered.emit(); sb.inspector.advance(0.3)
	card.get_parent().remove_child(card); card.queue_free(); await frames()
	sb.refresh(); sb.inspector.advance(0.0)
	check(not sb.inspector.visible, "removing the source clears the inspector")
	# A new encounter clears it.
	var other: CardView = sb.hand_fan.find_children("*", "CardView", true, false)[0]
	other.mouse_entered.emit(); sb.inspector.advance(0.3)
	sb.attach(g)
	check(not sb.inspector.visible, "an encounter change clears the inspector")
	sb.queue_free(); await frames()

func _words(k: KeyInspector) -> Array:
	return k.find_children("*", "Label", true, false).map(func(l): return String(l.text))
