extends SceneTree

func _initialize() -> void:
 call_deferred("run")

func run() -> void:
 var main: Node = load("res://scenes/Main.tscn").instantiate()
 root.add_child(main)
 main.voice_on = false
 main.voice.stop()
 for step in range(6):
  await process_frame
 main._start_as("GENERALIST")
 var g: Game = main.g
 g.rng.seed = 711
 g.row = 0
 g.available = [0]
 g.enter_node(0)
 if g.phase == "READY_RIG":
  g.skip_ready_rig()
 main.refresh()
 for step in range(6):
  await process_frame
 var surface := SubViewport.new()
 surface.size = Vector2i(620, 860)
 surface.render_target_update_mode = SubViewport.UPDATE_ALWAYS
 root.add_child(surface)
 var backdrop := ColorRect.new()
 backdrop.color = Color("#E6EEEA")
 backdrop.size = Vector2(620, 860)
 surface.add_child(backdrop)
 var failures := 0
 for face in ["DEEP_PROBE", "STRESS_TEST", "NULL_POINTER"]:
  var card := FriendlyCard.new()
  card.setup(main.friendly, face, -1)
  card.position = Vector2(64, 58)
  card.scale = Vector2(3, 3)
  surface.add_child(card)
  for step in range(5):
   await process_frame
  await RenderingServer.frame_post_draw
  var lamp: Control = card.body.get_node("TopRarityLight")
  if lamp.tier != CardDB.def(face).rarity or lamp.get_rect() != Rect2(63, 6, 37, 8) or card.body.has_node("RarityFinish"):
   push_error(face + ": rarity indicator mismatch")
   failures += 1
  var frame: Control = card.body.get_node("SolderRulesFrame")
  var rules: Label = frame.get_node("CenteredRules")
  if frame.get_rect() != FriendlyCard.MUSTARD_RULES_RECT or not is_equal_approx(rules.get_rect().get_center().distance_to(frame.size / 2), 0):
   push_error(face + ": rules box shifted")
   failures += 1
  if rules.horizontal_alignment != HORIZONTAL_ALIGNMENT_CENTER or rules.vertical_alignment != VERTICAL_ALIGNMENT_CENTER or rules.get_line_count() != rules.get_visible_line_count():
   push_error(face + ": rules alignment or overflow")
   failures += 1
  var path := OS.get_environment("SHOT_DIR").path_join(face + ".png")
  if surface.get_texture().get_image().save_png(path) != OK:
   push_error(face + ": could not save capture")
   failures += 1
  surface.remove_child(card)
  card.queue_free()
 await process_frame
 quit(1 if failures else 0)
