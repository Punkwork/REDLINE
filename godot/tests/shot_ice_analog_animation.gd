extends SceneTree
## ICE-ANALOG-001: export animation frames for GIF/MP4 assembly.
## 72 frames at 12 fps: idle, attention, telegraph, break reaction, TUMBLE.
## ffmpeg -framerate 12 -i ICE-ANALOG-001_anim_%03d.png -vf "scale=800:-1" ICE-ANALOG-001.gif
var view: Control
func _initialize() -> void: call_deferred("_run")
func _run() -> void:
 var out: String=OS.get_environment("SHOT_DIR")
 if out.is_empty() or not DirAccess.dir_exists_absolute(out):
  push_error("ICE-ANALOG-001 animation: SHOT_DIR must exist")
  quit(1)
  return
 view=load("res://tests/ice_analog_visual.gd").new()
 root.add_child(view)
 root.content_scale_size=Vector2i(1600,1000)
 root.size=Vector2i(1600,1000)
 view.scenario="animation"
 for i in 72:
  view.elapsed=float(i)/12.0
  view.animation_phase="idle" if i<12 else ("attention" if i<24 else ("telegraph" if i<36 else ("break" if i<48 else "tumble")))
  view.telegraph_slot=(i-24)/4%2 if i>=24 and i<36 else -1
  view.break_flash=i>=36 and i<48
  view.tumble_progress=clampf(float(i-48)/24.0,0.0,1.0)
  view.hovered=Vector2i(1,0) if i>=12 and i<24 else Vector2i(-1,-1)
  view.illegal=false
  view.queue_redraw()
  await process_frame
  await RenderingServer.frame_post_draw
  var image: Image=root.get_texture().get_image()
  var p: String=out.path_join("ICE-ANALOG-001_anim_%03d.png" % i)
  if image.save_png(p)!=OK:
   push_error("Cannot save "+p)
   quit(1)
   return
 print("ICE-ANALOG-001: 72 animation frames written")
 quit()
