extends SceneTree
## ADP-001 captures the real HALCYON CAPTCHA encounter and records its runtime audio mix.

var main: Node
var view: FriendlyEncounter
var failures := 0
var checks := 0
var effects: Array[String] = []

func _initialize() -> void:
 call_deferred("run")

func check(ok: bool, message: String) -> void:
 checks += 1
 if not ok:
  failures += 1
  push_error("ADP: " + message)

func settle() -> void:
 for _frame in 6: await process_frame
 await RenderingServer.frame_post_draw

func start() -> Game:
 main.reduced_motion = true
 main._start_as("GENERALIST")
 var g: Game = main.g
 g.rng.seed = 711
 g.animate = false
 g.row = 0
 g.available = [0]
 g.enter_node(0)
 if g.phase == "READY_RIG":
  var pick: Dictionary = g.draw_pile.filter(func(card): return card.id == "FORTRESS_ICEPICK")[0]
  g.choose_ready_rig(pick.uid)
 main.refresh()
 return g

func luminance(color: Color) -> float:
 var linear := color.srgb_to_linear()
 return linear.r * 0.2126 + linear.g * 0.7152 + linear.b * 0.0722

func contrast(ink: Color, paper: Color) -> float:
 var a := luminance(ink)
 var b := luminance(paper)
 return (maxf(a,b) + 0.05) / (minf(a,b) + 0.05)

func snapshot(name: String, expected: float) -> void:
 await settle()
 check(is_equal_approx(view.bleed, expected), name + " has the expected bleed")
 check(view.bleed_label.text == "BLEED %.2f" % expected, name + " shows the bleed readout")
 check(contrast(FriendlyLook.PAPER, FriendlyLook.TONER) >= 4.5, "bleed readout contrast")
 check(contrast(view.skin.plaque_ink, view.skin.plaque_ground) >= 4.5, "corporate sign text contrast")
 if view.strike_overlay.visible:
  var modal := view.strike_overlay.get_child(1)
  var headline: Label = modal.find_children("*", "Label", true, false).filter(func(label): return label.text == view.skin.strike_title)[0]
  check(headline.get_theme_font("font") == view.skin.display_font and headline.get_theme_font_size("font_size") >= 28, "Poiret One is large on the Strike headline")
  check(contrast(headline.get_theme_color("font_color"), modal.get_theme_stylebox("panel").bg_color) >= 4.5, "Strike headline contrast")
 var sign := view.get_node("CorporateDisplay")
 for label: Label in sign.get_children():
  check(label.get_theme_font("font") == view.skin.display_font and label.get_theme_font_size("font_size") >= 28, "Poiret One is large on the corporate sign")
 for label: Label in view.find_children("*", "Label", true, false):
  check(label.material == null, "no wear material on a glyph")
 for wear in view.worn_panels:
  check(wear.surface.material is ShaderMaterial, "the wear shader is isolated to the panel surface")
 var image := root.get_texture().get_image()
 check(image.save_png(OS.get_environment("SHOT_DIR").path_join(name + ".png")) == OK, "save " + name)

func test_controls() -> void:
 var slider: HSlider = main.find_child("MusicVolume", true, false)
 var mute: CheckBox = main.find_child("MuteMusic", true, false)
 slider.value = 0.37
 check(is_equal_approx(db_to_linear(view.music.stems.volume_db), 0.37), "the slider changes music gain")
 mute.button_pressed = true
 check(is_zero_approx(db_to_linear(view.music.stems.volume_db)) and is_zero_approx(db_to_linear(view.music.wet_corporate.volume_db)) and is_zero_approx(db_to_linear(view.music.chime.volume_db)), "mute silences all music paths")
 mute.button_pressed = false
 check(is_equal_approx(db_to_linear(view.music.stems.volume_db), 0.37), "unmute restores slider gain")
 slider.value = AtomicDecoPunk.settings.music.default_volume

func test_effects(g: Game) -> void:
 effects.clear()
 var card := g._new_inst("PULP_SHIELD")
 g.hand.append(card)
 g.bw = 20
 main.refresh()
 view.hover_uid = card.uid
 await settle()
 check(effects.is_empty(), "hover is silent")
 main._on_card(card.uid)
 main.refresh()
 check(effects == ["seat"], "accepted card sounds once")
 var pick_uid: int = g.installed[0].inst.uid
 var chip := view.program_slots.find_children("*", "FriendlyRigChip", true, false)[0] as Control
 view.begin_drag({"kind":"pick","uid":pick_uid},chip)
 view.begin_drag({"kind":"pick","uid":pick_uid},chip)
 view.end_drag()
 check(effects == ["seat","pick_drag"], "one scrape for a drag")
 main._on_break(0,0)
 main._on_break(0,0)
 check(effects == ["seat","pick_drag","break"], "only the successful break sounds")
 main._on_end_turn()
 main.refresh()
 check(effects.count("end_turn") == 1, "END TURN sounds once")
 g.add_trace(40-g.trace,false)
 main.refresh()
 main.refresh()
 check(effects.count("bloat") == 1, "strike's actual TRACER insert sounds once")

func take_audio() -> void:
 var record := AudioEffectRecord.new()
 record.format = AudioStreamWAV.FORMAT_16_BITS
 AudioServer.add_bus_effect(0, record)
 var g := start()
 main.reduced_motion = false
 main.refresh()
 record.set_recording_active(true)
 await create_timer(2.0).timeout
 g.add_trace(20,false); main.refresh()
 await create_timer(2.0).timeout
 g.add_trace(19,false); main.refresh()
 await create_timer(3.0).timeout
 check(absf(view.music.current_cents) <= 35.0 and FriendlyMusic.depth(view.bleed,false) >= 34.9, "Cracking detune is bounded and reaches the approved depth")
 g.add_trace(1,false); main.refresh()
 await create_timer(2.8).timeout
 g.add_trace(20,false); main.refresh()
 await create_timer(2.2).timeout
 check(is_zero_approx(view.music.current_cents) and is_equal_approx(view.music.pitch_effect.pitch_scale, 1.0), "Mask Off is exactly in tune")
 var sync_error := absf(wrapf(view.music.stems.get_playback_position() - view.music.wet_corporate.get_playback_position(), -4.0, 4.0))
 check(sync_error < 0.05, "corporate DSP feed shares the synchronized transport: %.4f seconds offset" % sync_error)
 record.set_recording_active(false)
 var clip := record.get_recording()
 check(clip != null and clip.get_length() > 10.0, "captured live audio from all states")
 if clip != null:
  check(clip.save_to_wav(OS.get_environment("SHOT_DIR").path_join("adp-bleed-sweep.wav")) == OK, "save audio capture")
 AudioServer.remove_bus_effect(0,AudioServer.get_bus_effect_count(0)-1)

func test_backdrop_resize() -> void:
 var original_size := root.size
 root.size = Vector2i(1600,900)
 await settle()
 check(view.size.x > 1600.0, "wide window expands the encounter viewport")
 for layer in [view.app_ground, view.background, view.surveillance_layer]:
  check(layer.get_rect().is_equal_approx(Rect2(Vector2.ZERO,view.size)), "backdrop fills the wide viewport")
 view.reduced_motion = false
 view.corporation_state = "mask_off"
 view.apply_background()
 check(is_instance_valid(view.fade_layer) and view.fade_layer.get_rect().is_equal_approx(Rect2(Vector2.ZERO,view.size)), "hostile crossfade also fills the viewport")
 for carrier in view.find_children("IllustrationScale", "Control", true, false):
  # ENCOUNTER-DISPLAY-001 enlarged avatars 25%; CARDS-004 gives up 44 px of the stage (x194/238) for the larger hand.
  check(carrier.scale.is_equal_approx(Vector2.ONE * 0.82 * 1.25 * 194.0 / 238.0), "two-ICE lane avatars keep the CARDS-004 stage scale")
 root.size = original_size
 await settle()

func run() -> void:
 main = load("res://scenes/Main.tscn").instantiate()
 root.add_child(main)
 main.voice_on = false
 view = main.friendly
 view.music.effect_played.connect(func(id: String): effects.append(id))
 test_controls()
 var g := start()
 await test_backdrop_resize()
 g = start()
 await snapshot("adp-bleed-0",0.0)
 check(view.leak.is_empty() and view.graffiti_count == 0, "zero bleed has no leaks or graffiti")
 view.hover_uid = g.hand[0].uid
 var now := Time.get_ticks_msec() / 1000.0
 view.update_hesitation(3.9, now)
 check(view.hesitation_turn == -1, "hesitation does not fire early")
 view.update_hesitation(0.2, now)
 check(view.hesitation_line == "No rush! Humans take a moment.", "ties prefer the main ICE")
 check(g.enc.turn == 1, "hesitation does not advance play")
 await snapshot("adp-hesitation",0.0)
 view.hover_uid = -1
 view.update_hesitation(0.0, now)

 g.add_trace(20,false); main.refresh()
 check(is_equal_approx(view.surveillance_layer.modulate.a,0.2), "TRACE 20 reveals 20% without motion")
 # Capture the midpoint of the actual 20-to-39 transition at exactly 0.40.
 view.set_process(false)
 main.reduced_motion = false
 g.add_trace(19,false); main.refresh()
 view.advance_bleed(float(AtomicDecoPunk.settings.bleed.ease_seconds) / 2.0)
 for wear in view.worn_panels: wear.update_wear(view.bleed,true,0.0)
 # Seed only the cosmetic RNG to select a leak at the documented 1-in-2 rate.
 for seed_value in 16:
  view.voice_rng.seed = seed_value
  main.note_revision += 1
  view._process(0.0)
  if not view.leak.is_empty(): break
 check(not view.leak.is_empty() and view.graffiti_count == 2, "band B can show a leak and two tags")
 await snapshot("adp-bleed-04",0.4)
 var stamp: Control = view.find_child("ShellGraffiti", true, false)
 check(is_instance_valid(stamp), "a tag appears in the reserved shell strip")
 if is_instance_valid(stamp):
  for target in stamp.get_parent().find_children("*", "Button", false, false):
   # Half-pixel tolerance: the tag sits exactly on the button's edge, and the scaled ICE area adds float error.
   check(not stamp.get_global_rect().grow(-0.5).intersects(target.get_global_rect()), "shell graffiti stays clear of the mascot button")
 view.advance_bleed(float(AtomicDecoPunk.settings.bleed.ease_seconds) / 2.0)
 check(is_equal_approx(view.surveillance_layer.modulate.a,0.6), "TRACE 39 finishes at 60%")
 view.set_process(true)
 main.reduced_motion = true
 g.add_trace(1,false); main.refresh()
 check(view.background.texture == view.skin.hostile_background and not view.surveillance_layer.visible, "Strike uses the existing full hostile background")
 check(view.strike_overlay.find_children("*", "Label", true, false).any(func(label): return label.text == "SEE THIS"), "strike reply appears outside the modal")
 # Keep the modal open for the capture even on slow software-rendered CI.
 view.strike_until = Time.get_ticks_msec() / 1000.0 + 60.0
 await snapshot("adp-strike",0.8)
 view.dismiss_strike()
 check(is_equal_approx(view.bleed,0.2), "dismissal restores the post-strike floor")
 g.add_trace(20,false); main.refresh()
 check(view.background.texture == view.skin.hostile_background and not view.surveillance_layer.visible, "Mask Off uses the existing full hostile background")
 view._process(0.0)
 check(view.toast.visible and view.toast_reply.text == "NOT FOR LONG", "Mask off toast has a scrawled reply")
 view.toast_until = Time.get_ticks_msec() / 1000.0 + 60.0
 await snapshot("adp-bleed-1",1.0)
 var rail := view.worn_panels[0]
 rail.update_wear(1.0,true,0.0)
 var opacity := rail.code_alpha
 rail.update_wear(1.0,true,0.2)
 check(is_equal_approx(opacity,rail.code_alpha), "reduced-motion barcode is static")
 check(is_zero_approx(FriendlyMusic.depth(0.6,true)), "reduced motion suppresses pitch wobble")

 await test_effects(start())
 await take_audio()
 view.music.set_active(false)
 main.voice.stop()
 main.voice.stream = null
 main.queue_free()
 await settle()
 print("ADP FIXTURE: %d checks, %d failures" % [checks,failures])
 quit(int(failures > 0))
