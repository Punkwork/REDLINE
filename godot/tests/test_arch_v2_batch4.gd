extends SceneTree
## ARCH-V2-007 Batch 4: headless checks for the corporation look and the screen's integration.

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
	sb.flags_path = "user://test_arch_v2_flags.json"
	root.add_child(sb)
	return sb

func frames(n := 3) -> void:
	for i in n: await process_frame

func run() -> void:
	root.size = Vector2i(1600, 1000)
	print("- rooms through the ICE windows (007a)")
	await test_rooms()
	print("- corporation look: enamel, ad plate, TRACE pixel steps, mood flicker, music (007b)")
	await test_look()
	print("- graffiti, punch cards, low VITAE, PATIENT ZERO (007c)")
	await test_rest()
	print("ARCH-V2 BATCH 4: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

func test_rooms() -> void:
	for corp in ["HALCYON", "IRONWATCH", "LUCIDA"]:
		for st in ["FRIENDLY", "HOSTILE", "CENTRAL", "ESCAPE"]:
			check(CorporationLook.room(corp, st) != null, "%s %s room loads" % [corp, st])
	check(CorporationLook.room("NOBODY", "FRIENDLY") == null, "a corporation without art has no room")
	var sb := sandbox(); await frames(); var g := sb.game
	var panels: Array = sb.lane.panels()
	check(panels.all(func(p): return p.has_room()), "every ICE window shows the room")
	# One continuous room: each window's part of the image follows on from the one to its left.
	var mats: Array = panels.map(func(p): return (p.find_child("Room", false, false) as ColorRect).material)
	var a: Vector4 = mats[0].get_shader_parameter("uv_rect")
	var b: Vector4 = mats[1].get_shader_parameter("uv_rect")
	check(a.x + a.z < b.x and b.x - (a.x + a.z) < 0.08, "the two windows show neighbouring parts of one room")
	check(absf(a.y - b.y) < 0.001 and absf(a.w - b.w) < 0.001, "same height band in both windows")
	check(mats[0].get_shader_parameter("friendly") == CorporationLook.room("HALCYON", "FRIENDLY"), "HALCYON's FRIENDLY room")
	check(is_equal_approx(float(mats[0].get_shader_parameter("reveal")), 0.0), "no hostile room at TRACE 0")
	g.trace = 30; sb.refresh()
	var r := float(mats[0].get_shader_parameter("reveal"))
	check(is_equal_approx(r, VisibleStateAdapter.hostile_reveal(g)) and r > 0.2, "HOSTILE room shows through with the reveal")
	# The room sits inside the bezel and behind the avatar and keys.
	var p0: IcePanel = panels[0]
	var room: ColorRect = p0.find_child("Room", false, false)
	check(room.position.x > 0.0 and room.size.x < p0.size.x, "room inside the bezel")
	check(room.get_index() < p0.find_child("Expression", false, false).get_index(), "room behind the avatar")
	# Another corporation, same screen.
	g.corporation = "LUCIDA"; sb.refresh()
	check(mats[0].get_shader_parameter("friendly") == CorporationLook.room("LUCIDA", "FRIENDLY"), "LUCIDA's room on the same screen")
	g.corporation = "NOBODY"; sb.refresh()
	check(not p0.has_room(), "no art: the seafoam field stays")
	sb.queue_free(); await frames()

func test_look() -> void:
	var sb := sandbox(); await frames(); var g := sb.game
	var p0: IcePanel = sb.lane.panels()[0]
	check(p0.window.material == null, "HALCYON keeps its seafoam enamel")
	check(sb.ad_plate.visible and sb.ad_copy.text.begins_with("A Halcyon"), "HALCYON ad plate with its approved line")
	g.corporation = "IRONWATCH"; sb.refresh()
	check(p0.window.material != null and (p0.window.material as ShaderMaterial).get_shader_parameter("target") == CorporationLook.ENAMEL.IRONWATCH, "IRONWATCH navy enamel")
	check(not sb.ad_plate.visible, "no IRONWATCH ad plate until its art and copy exist")
	g.corporation = "HALCYON"; sb.refresh()
	# TRACE pixel steps: none below 20; coarser with TRACE; keys and plates stay above the cells.
	check(p0.trace_pixel_cell() == 1.0, "sharp below TRACE 20")
	sb.reduced_motion = true
	g.trace = 30; sb.refresh()
	check(p0.trace_pixel_cell() == float(AtomicDecoPunk.settings.pixel.trace_30.cell), "TRACE 30: the window drops to its pixel step")
	var px := p0.find_child("TracePixel", false, false)
	check(px.get_index() < p0.find_child("Controls", false, false).get_index() and px.get_index() < p0.find_child("Identity", false, false).get_index(), "keys and plates stay sharp above the cells")
	check(px.get_index() > p0.find_child("Expression", false, false).get_index(), "the avatar and room are under the cells")
	g.trace = 5; sb.refresh()
	check(p0.trace_pixel_cell() == 1.0, "back to sharp when TRACE drops")
	# Animated transition (not reduced): a spike then the step.
	sb.reduced_motion = false
	g.trace = 25; sb.refresh()
	await create_timer(0.08).timeout
	var mid := p0.trace_pixel_cell()
	await create_timer(0.6).timeout
	check(mid > float(AtomicDecoPunk.settings.pixel.trace_20.cell) and p0.trace_pixel_cell() == float(AtomicDecoPunk.settings.pixel.trace_20.cell), "transition spikes coarser, then settles (%.0f then %.0f)" % [mid, p0.trace_pixel_cell()])
	# Mood flicker: a mood change drops the avatar into 16-bit and back; lethal pulses; reduced motion: none.
	p0._mood_prev = "cheery"; p0._mood_now = "wary"; p0._mood_age = 0.3
	p0._process(0.0)
	check(p0.mood_pixel_on(), "mood change: the avatar drops into 16-bit")
	p0._mood_age = 5.0; p0._process(0.0)
	check(not p0.mood_pixel_on(), "and resolves")
	p0._mood_prev = "wary"; p0._mood_now = "lethal"; p0._mood_age = 5.0
	var on := false
	for i in 50:
		p0._process(0.1)
		on = on or p0.mood_pixel_on()
	check(on, "lethal: the avatar pulses into 16-bit")
	p0.reduced_motion = true; p0._process(0.0)
	check(not p0.mood_pixel_on(), "reduced motion: no flicker")
	# Music: present, follows the bleed, strike chime on a strike.
	check(sb.music != null and sb.music.stems.playing, "corporation music playing")
	sb.reduced_motion = true
	g.add_trace(40 - g.trace, false); sb.refresh(); sb._process(0.1)
	check(sb.bleed >= float(AtomicDecoPunk.settings.bleed.cracking_start), "music bleed follows TRACE and strikes")
	check(sb.music.chime.playing, "strike chime triggered")
	sb.queue_free(); await frames()


func test_rest() -> void:
	var sb := sandbox(); await frames(); var g := sb.game
	# Graffiti in the header gap: none while friendly; more as the bleed rises; inside the gap.
	check(sb.graffiti_count() == 0, "no graffiti while friendly")
	sb.reduced_motion = true
	g.trace = 25; sb.refresh()
	var a := sb.graffiti_count()
	g.strikes = 2; sb.refresh()
	var c := sb.graffiti_count()
	check(a >= 1 and c > a and c <= 4, "graffiti grows with the bleed (%d then %d)" % [a, c])
	var gap := Rect2(IceEncounterSandbox.GRAFFITI.position, IceEncounterSandbox.GRAFFITI.size)
	check(sb.graffiti.position == gap.position and sb.graffiti.clip_contents, "graffiti stays inside the header gap")
	check(gap.end.x <= IceEncounterSandbox.AD.position.x and gap.position.x >= IceEncounterSandbox.PROTOCOLS.end.x, "the gap is between PROTOCOLS and the ad plate")
	g.strikes = 0; g.trace = 0; sb.refresh()
	# Punch cards: in the eye's hover; an arrival drops onto the eye.
	check(String(sb.eye.lines[1]).begins_with("Punch cards 0 / 3"), "eye hover counts punch cards")
	g.punch_cards.append("HALCYON"); g.events.append({"t": "PUNCH_CARD", "corp": "HALCYON"}); sb.refresh()
	check(is_instance_valid(sb.punch_arrival) and sb.punch_arrival.visible, "a new punch card arrives at the eye")
	check(sb.eye.picture.is_valid(), "eye hover shows the punch cards")
	# Low VITAE: the VITAE meter pulses red at a quarter or less.
	check(not sb.meters.VITAE.warn, "no warning at full VITAE")
	g.vitae = g.max_vitae / 4; sb.refresh()
	check(sb.meters.VITAE.warn, "VITAE meter warns at a quarter")
	g.vitae = g.max_vitae; sb.refresh()
	# PATIENT ZERO: the ICE windows light; clicking one infects it with 1 ROT (one call); no ✕.
	g.pending = {"kind": "patient_zero"}; g.phase = "CHOICE"; sb.refresh(); await frames()
	check(sb.lane.targeting and sb._target_plaque.visible, "PATIENT ZERO lights the ICE")
	check(not sb.choice.visible, "no card overlay for PATIENT ZERO")
	check(not sb._target_plaque.get_child(0).get_child(1).visible, "PATIENT ZERO can't be skipped")
	var calls := sb.ctrl.game_calls
	sb.lane.target_chosen.emit(g.enc.ice[1])
	check(int(g.enc.ice[1].virus.get("ROT", 0)) == 1 and g.phase == "PLAYER" and sb.ctrl.game_calls == calls + 1, "chosen ICE gets 1 ROT, one call")
	sb.queue_free(); await frames()
