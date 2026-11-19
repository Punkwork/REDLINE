extends SceneTree
## PIXEL-TRACE-001 (PROPOSED): the COOKIE BANNER encounter at TRACE 0, 20, 30
## and Mask off. Checks that rules text, cards and buttons are never pixelated.

var main: Node
var view: FriendlyEncounter
var failures := 0
var checks := 0

func _initialize() -> void:
 call_deferred("run")

func check(ok: bool, message: String) -> void:
 checks += 1
 if not ok:
  failures += 1
  push_error("Assertion failed: PIXEL-TRACE-001 " + message)

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

func shot(name: String, cell: float) -> void:
 await settle()
 var visible_layers := view.pixel_layers.filter(func(l): return is_instance_valid(l) and l.visible)
 check(is_equal_approx(float(view.pixel_material.get_shader_parameter("cell")), cell), name + " uses cell %d" % cell)
 check((visible_layers.size() > 0) == (cell > 1.0), name + " shows the pixel layers only when active")
 # Every pixel layer sits behind text: the full-screen one right after the backdrops,
 # and each mascot's before its first text.
 for layer in visible_layers:
  if layer.get_parent() == view:
   check(layer.get_index() < view.node_tag.get_index() and layer.get_index() < view.ice_scroll.get_index(), name + " backdrop layer draws under the HUD")
  elif is_instance_valid(layer.get_parent()) and layer.is_inside_tree():
   var mascot: Node = layer.get_parent()
   for child in mascot.get_children():
    if child.get_index() >= layer.get_index(): break
    var texts: Array = ([child] if child is Label else []) + child.find_children("*", "Label", true, false)
    for label: Label in texts:
     check(label.text.is_empty() or not label.is_visible_in_tree(), name + " mascot text '%s' is drawn after the pixel layer" % label.text.left(20))
 var img := root.get_texture().get_image()
 var dir := OS.get_environment("SHOT_DIR")
 if dir != "": img.save_png(dir.path_join(name + ".png"))

func run() -> void:
 main = load("res://scenes/Main.tscn").instantiate()
 root.add_child(main)
 main.voice_on = false
 view = main.friendly
 var g := start()
 await shot("trace-pixel-00", 1.0)
 g.add_trace(20,false); main.refresh()
 await shot("trace-pixel-20", 2.0)
 g.add_trace(10,false); main.refresh()
 await shot("trace-pixel-30", 3.0)
 g.add_trace(10,false); main.refresh()
 view.dismiss_strike()
 g.add_trace(40,false); main.refresh()
 if view.strike_overlay.visible: view.dismiss_strike()
 check(g.strikes >= 2 and view.corporation_state == "mask_off", "reached Mask off")
 view._process(0.0)
 await shot("trace-pixel-mask-off", 5.0)
 main.queue_free()
 await settle()
 print("PIXEL-TRACE-001 FIXTURE: %d checks, %d failures" % [checks, failures])
 quit(1 if failures else 0)
