extends SceneTree
## FACADE-ART-001 presentation fixtures. These definitions stay out of the playable slice.
const SKINS := [preload("res://themes/ironwatch.tres"), preload("res://themes/lucida.tres")]
const OPENINGS := {
 "IRONWATCH": {
  "name": "FRONT DESK",
  "ice": [
   ["TURNSTILE", {"name": "TURNSTILE", "type": "FORTRESS", "str": 3, "subs": [[{"k": "PULP", "v": 2}], [{"k": "PULP", "v": 2}]]}],
   ["SECURITY_GUARD", {"name": "SECURITY GUARD", "type": "VOID", "str": 3, "ability": "BOOTING", "subs": [[{"k": "PULP", "v": 2}], [{"k": "DEADLOCK"}]]}],
  ],
 },
 "LUCIDA": {
  "name": "INTAKE",
  "ice": [
   ["BASELINE_SCAN", {"name": "BASELINE SCAN", "type": "VOID", "str": 3, "subs": [[{"k": "FORGET", "v": 1}], [{"k": "PULP", "v": 2}]]}],
   ["ONBOARDING", {"name": "ONBOARDING", "type": "TUMBLER", "str": 3, "slots": 2, "ability": "BOOTING", "subs": [[{"k": "FORGET", "v": 1}], [{"k": "DEADLOCK"}]]}],
  ],
 },
}
var failures := 0

func _initialize() -> void:
 call_deferred("run")

func check(ok: bool, message: String) -> void:
 if not ok:
  failures += 1
  push_error("Facade: " + message)

func settle(count: int = 4) -> void:
 for _frame in count:
  await process_frame
 await RenderingServer.frame_post_draw

func linear(channel: float) -> float:
 return channel / 12.92 if channel <= 0.04045 else pow((channel + 0.055) / 1.055, 2.4)

func luminance(color: Color) -> float:
 return 0.2126 * linear(color.r) + 0.7152 * linear(color.g) + 0.0722 * linear(color.b)

func contrast(fg: Color, bg: Color, scrim: Color) -> float:
 var a := luminance(fg.lerp(scrim, scrim.a))
 var b := luminance(bg.lerp(scrim, scrim.a))
 return (maxf(a, b) + 0.05) / (minf(a, b) + 0.05)

func check_plaques(view: FriendlyEncounter) -> float:
 var minimum := INF
 var scrim := Color.TRANSPARENT
 if view.strike_overlay.visible:
  var dim: ColorRect = view.strike_overlay.get_child(0)
  scrim = dim.color
 for column in view.ice_row.get_children():
  var plaque: PanelContainer = column.get_child(1)
  var backing: StyleBoxFlat = plaque.get_theme_stylebox("panel")
  # ENC-CONCEPT-001: with the painted console the panel shows through; console_ground() is that paint.
  check(backing.bg_color == view.console_ground() and backing.bg_color.a == 1.0, "plaque is solid corporate enamel")
  # ENC-CONCEPT-001 console colour: text straight on the console's own enamel stays readable.
  check(contrast(view.console_ink(), view.console_ground(), Color(0, 0, 0, 0)) >= 4.5, "console ink on %s enamel" % view.skin.corporation)
  check(plaque.find_children("*", "TextureRect", true, false).is_empty(), "no art behind plaque text")
  check(plaque.size.x <= column.size.x + 1, "plaque fits the column")
  for label: Label in plaque.find_children("*", "Label", true, false):
   var bg := backing.bg_color
   if label.get_parent() is PanelContainer:
    bg = FriendlyEncounter.style_ground(label.get_parent().get_theme_stylebox("panel"))
   minimum = minf(minimum, contrast(label.get_theme_color("font_color"), bg, scrim))
  for button: Button in plaque.find_children("*", "Button", true, false):
   var state := "disabled" if button.disabled else "normal"
   var ink := button.get_theme_color("font_disabled_color" if button.disabled else "font_color")
   minimum = minf(minimum, contrast(ink, FriendlyEncounter.style_ground(button.get_theme_stylebox(state)), scrim))
 check(minimum >= 4.5, "minimum plaque contrast %.2f:1" % minimum)
 return minimum

func run() -> void:
 var scene := preload("res://scenes/Main.tscn")
 for skin: CorporationSkin in SKINS:
  var main := scene.instantiate()
  main.friendly_skin = skin
  root.add_child(main)
  main.reduced_motion = true
  main.voice_on = false
  main._start_as("GENERALIST")
  main.voice.stop()
  var g: Game = main.g
  g.rng.seed = 711
  g.enter_node(0)
  if g.phase == "READY_RIG":
   g.skip_ready_rig()
  var opening: Dictionary = OPENINGS[skin.corporation]
  g.node = {"id": opening.name, "name": opening.name, "opening": true, "layers": [{}]}
  g.enc.reserve = 15
  g.enc.reserve_start = 15
  g.enc.ice.clear()
  for item in opening.ice:
   g.enc.ice.append(g._new_ice(item[0], item[1]))
  g._mark_seen()
  g._roll_fortress_pulp()
  for state in ["friendly", "cracking", "strike", "mask-off"]:
   # Preview trace presentation without running HALCYON's strike injection.
   g.trace = {"friendly": 0, "cracking": 26, "strike": 20, "mask-off": 20}[state]
   g.strikes = {"friendly": 0, "cracking": 0, "strike": 1, "mask-off": 2}[state]
   if state in ["strike", "mask-off"]:
    main.friendly.toast_until = 0.0
   main.refresh()
   await settle()
   var view: FriendlyEncounter = main.friendly
   var hostile: bool = state in ["strike", "mask-off"]
   check(view.background.texture == (skin.hostile_background if hostile else skin.background), state + " uses the corporate backdrop")
   check(view.surveillance_layer.visible == (state == "cracking"), "only Cracking uses the reveal overlay")
   check(view.strike_overlay.visible == (state == "strike"), "Strike modal visibility")
   check(view.find_children("FacadeShell", "TextureRect", true, false).size() == 2, "both opening shell textures render")
   var minimum := check_plaques(view)
   var name: String = skin.corporation.to_lower() + "-" + state
   var path := OS.get_environment("SHOT_DIR").path_join(name + ".png")
   check(root.get_texture().get_image().save_png(path) == OK, "save " + path)
   print("FACADE %s — minimum plaque contrast %.2f:1" % [name, minimum])
  main.voice.stop()
  main.voice.stream = null
  main.queue_free()
  await settle()
 print("FACADE: %d failures" % failures)
 quit(1 if failures else 0)
