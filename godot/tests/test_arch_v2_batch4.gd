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
	print("- ORIGIN Ghostware art in the reel (008a)")
	test_origin_art()
	print("- CAPS in the rack: inject, CRACKER aims (CAPS-TEST-001)")
	await test_caps_rack()
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
	sb._pixel_tween.pause()   # step the transition by hand so the check doesn't depend on timing
	sb._pixel_tween.custom_step(0.12)
	var mid := p0.trace_pixel_cell()
	sb._pixel_tween.custom_step(1.0)
	check(mid > float(AtomicDecoPunk.settings.pixel.trace_20.cell) and p0.trace_pixel_cell() == float(AtomicDecoPunk.settings.pixel.trace_20.cell), "transition spikes coarser, then settles (%.0f then %.0f)" % [mid, p0.trace_pixel_cell()])
	# Mood flicker: a mood change drops the avatar into 16-bit and back; lethal pulses; reduced motion: none.
	p0._mood_prev = "cheery"; p0._mood_now = "wary"; p0._mood_age = 0.3
	p0._process(0.0)
	check(p0.mood_pixel_on(), "mood change: the avatar drops into 16-bit")
	p0._mood_age = 5.0; p0._process(0.0)
	check(not p0.mood_pixel_on(), "and resolves")
	# Lethal pulse, on a fixed clock (2 s in 16-bit, 2 s crisp) so the check never depends on timing.
	p0.apply_mood_look(FriendlyMascot.mood_look("lethal", "wary", 5.0, 1.0, false, 1.0))
	var on_phase := p0.mood_pixel_on()
	p0.apply_mood_look(FriendlyMascot.mood_look("lethal", "wary", 5.0, 3.0, false, 1.0))
	check(on_phase and not p0.mood_pixel_on(), "lethal: the avatar pulses into 16-bit and back")
	p0._mood_prev = "wary"; p0._mood_now = "lethal"; p0._mood_age = 5.0
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
	# Graffiti removed for now (ARCH-V2-007f): none at any bleed.
	sb.reduced_motion = true
	g.trace = 25; sb.refresh()
	var a := sb.graffiti_count()
	g.strikes = 2; sb.refresh()
	check(a == 0 and sb.graffiti_count() == 0, "no graffiti on screen (removed for now)")
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


## ARCH-V2-008a: every Rustler's ORIGIN shows its icon and rules text in the Ghostware reel.
func test_origin_art() -> void:
	for rid in CardDB.RUSTLERS:
		var g := Game.new(); g.rustler = rid
		var m: Array = VisibleStateAdapter.ghostware_models(g)
		check(not m.is_empty() and bool(m[0].origin), "%s: ORIGIN first in the reel" % rid)
		check(ResourceLoader.exists(String(m[0].art)), "%s: %s has art" % [rid, m[0].name])
		check(String(m[0].text) != "", "%s: %s has rules text for the hover" % [rid, m[0].name])


## CAPS-TEST-001: the rack shows the run's CAPS with the designer's vials; a click injects (one controller
## call); CRACKER aims at an ICE like a targeted card; nothing works during the Corporation Response.
func test_caps_rack() -> void:
	var sb := sandbox()
	await frames(4)
	var g: Game = sb.game
	check(g.phase == "PLAYER", "sandbox on the Rustler's turn")
	g.caps = [{"uid": 9001, "id": "BULWARK"}, {"uid": 9002, "id": "CRACKER"}]
	sb.refresh(); await frames()
	var slots: Array = sb.cap_rack.slots
	check(String(slots[0].item.get("name", "")) == "BULWARK" and String(slots[1].item.get("name", "")) == "CRACKER" and slots[2].item.is_empty(), "rack shows BULWARK, CRACKER, one empty slot")
	check(ResourceLoader.exists(String(slots[0].item.art)), "BULWARK uses the designer's vial art")
	check(slots[0].picture.is_valid(), "hover shows the full vial (HOVER-001)")
	check(slots[0].lines.any(func(l): return String(l).contains("+8 SHIELD")), "hover text gives the effect")
	var sh0 := g.shield
	var calls0: int = sb.ctrl.game_calls
	var click := InputEventMouseButton.new(); click.button_index = MOUSE_BUTTON_LEFT; click.pressed = true
	slots[0]._gui_input(click); await frames()
	check(g.shield == sh0 + 8 and sb.ctrl.game_calls == calls0 + 1, "click injects BULWARK (+8 SHIELD, one Game call)")
	check(g.caps.size() == 1 and String(sb.cap_rack.slots[0].item.get("name", "")) == "CRACKER", "BULWARK leaves the rack; CRACKER moves up")
	# CRACKER: click arms the arrow, then click an ICE.
	var str0 := g.ice_str(1)
	sb.cap_rack.slots[0]._gui_input(click); await frames()
	check(sb.aiming_cap and sb.arrow.visible and g.caps.size() == 1, "CRACKER arms the aiming arrow")
	var panel = sb.lane.panels()[1]
	sb.release_aim(panel.get_global_rect().get_center()); await frames()
	check(g.ice_str(1) == str0 - 4 and g.caps.is_empty(), "CRACKER on CAPTCHA: −4 STR (%d → %d)" % [str0, g.ice_str(1)])
	check(not sb.aiming_cap and not sb.arrow.visible, "arrow gone after injecting")
	# Esc cancels an armed CRACKER without using it.
	g.caps = [{"uid": 9003, "id": "CRACKER"}]
	sb.refresh(); await frames()
	sb.cap_rack.slots[0]._gui_input(click); await frames()
	sb.cancel_aim(); sb.refresh(); await frames()
	check(g.caps.size() == 1, "cancelled CRACKER stays in the rack")
	# Not usable outside the Rustler's turn.
	g.phase = "RESPONSE"; sb.refresh(); await frames()
	check(not bool(sb.cap_rack.slots[0].item.get("usable", true)), "CAPS unusable during the Corporation Response")
	sb.cap_rack.slots[0]._gui_input(click); await frames()
	check(g.caps.size() == 1 and not sb.aiming_cap, "clicking does nothing then")
	sb.queue_free(); await frames()
