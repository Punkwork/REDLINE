extends SceneTree
## ICE-ANALOG-001: visual-only screenshot fixture. Not connected to gameplay.
## Usage: SHOT_DIR=/absolute/existing/path godot --path godot --script res://tests/shot_ice_analog.gd
const SCENARIOS=["friendly","cracking","tooltip","illegal","void","three"]
var view: Control
func _initialize() -> void:
 call_deferred("_run")
func _run() -> void:
 var script: Script=load("res://tests/ice_analog_visual.gd")
 view=script.new()
 view.set_anchors_preset(Control.PRESET_FULL_RECT)
 root.add_child(view)
 root.content_scale_size=Vector2i(1600,1000)
 root.size=Vector2i(1600,1000)
 var output: String=OS.get_environment("SHOT_DIR")
 if output.is_empty() or not DirAccess.dir_exists_absolute(output):
  push_error("ICE-ANALOG-001: SHOT_DIR must name an existing absolute directory")
  quit(1)
  return
 for name in SCENARIOS:
  view.scenario=name
  view.illegal=name=="illegal"
  view.hovered=Vector2i(-1,-1)
  if name=="tooltip": view.hovered=Vector2i(1,0)
  view.queue_redraw()
  for frame in 4: await process_frame
  await RenderingServer.frame_post_draw
  var image: Image=root.get_texture().get_image()
  var path: String=output.path_join("ICE-ANALOG-001_"+name+".png")
  if image.save_png(path)!=OK:
   push_error("ICE-ANALOG-001: failed to save "+path)
   quit(1)
   return
  print("ICE-ANALOG-001 shot: "+path)
 quit()
