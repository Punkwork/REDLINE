extends SceneTree
## CHROME-001: per-step screenshots of actual CAPTCHA rules and native inputs.
var main: Node
var failures:=0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
 if not ok: failures+=1; push_error("Chrome: "+message)
func settle(frames: int=12) -> void:
 for i in frames: await process_frame
 await RenderingServer.frame_post_draw
func snapshot(name: String) -> void:
 if main.tween and main.tween.is_running(): main.tween.custom_step(100)
 main.nr_text.visible_ratio=1
 await settle()
 check(root.get_texture().get_image().save_png(OS.get_environment("SHOT_DIR").path_join(name+".png"))==OK,"save "+name)
 print("shot ",name)
func start() -> Game:
 main.reduced_motion=true; main._start_as("GENERALIST")
 var g: Game=main.g; g.rng.seed=711; g.animate=false; g.hold_enabled=false
 g.row=0; g.available=[0]; g.enter_node(0)
 if g.phase=="READY_RIG":
  var uid: int=g.draw_pile.filter(func(c): return c.id=="FORTRESS_ICEPICK")[0].uid
  g.choose_ready_rig(uid)
 main.refresh()
 Input.warp_mouse(Vector2(20,150))
 check(g.phase=="PLAYER" and g.enc.ice[0].id=="AUTO_RENEW" and g.enc.ice[1].id=="CAPTCHA","real CAPTCHA fixture starts")
 return g
func run() -> void:
 main=load("res://scenes/Main.tscn").instantiate(); root.add_child(main); main.voice_on=false; main.voice.stop(); await settle()
 var g:=start()
 await settle()
 var stage:=int(OS.get_environment("CHROME_STAGE"))
 if stage==0: stage=5
 if stage==1: await snapshot("01-layout-and-readability")
 elif stage==2:
  await snapshot("02a-mascots-cheery")
  var c:=g._new_inst("TUMBLER_ICEPICK"); g.hand.append(c); g.bw=8; check(g.play_card(c.uid),"fixture installs TUMBLER Icepick")
  g.boost_pick(c.uid); g.boost_pick(c.uid)
  g.bw=4; check(g.break_sub(0,0),"break AUTO-RENEW S1")
  for turn in 2:
   g.end_turn()
   while g.phase=="CHOICE" and g.pending.get("kind")=="discard": g.choose(g.hand[0].uid)
  check(g.enc.turn==3 and g.ice_str(0)==6,"real HARDENING and turn 3")
  check(g.break_sub(1,3),"actual CAPTCHA S4 break")
  main.refresh(); await snapshot("02b-mascots-wary-and-lethal")
 elif stage==3: await snapshot("03-welcome-atrium")
 elif stage==4:
  g.add_trace(26,false); main.refresh(); await snapshot("04a-cracking")
  g.add_trace(14,false); main.refresh(); await snapshot("04b-first-strike")
  main.friendly.dismiss_strike(); g.add_trace(20,false); main.refresh(); await snapshot("04c-mask-off")
 elif stage==5:
  await interaction(g)
 # Inspect the real laid-out rule tags, including the last passive line.
 await settle()
 for column in main.friendly.ice_row.get_children():
  var scan: Control=column.get_child(1)
  check(scan.size.x<=column.size.x+1,"scan fits its column")
 for c in main.friendly.hand.get_children():
  for child in c.body.get_children():
   if child is RichTextLabel: check(child.get_content_height()<=child.size.y+1,"real card rules fit: "+c.card_id)
   if child.name=="TonerIllustration": check(child.size.x<=128 and child.size.y<=64,"illustration does not cover rules or neighbouring cards")
 print("CHROME STAGE %d: %d failures"%[stage,failures])
 main.voice.stop(); main.voice.stream=null; main.queue_free(); await settle(); quit(1 if failures else 0)
func interaction(g: Game) -> void:
 var chip: FriendlyRigChip
 for child in main.friendly.rig_row.get_children():
  if child is FriendlyRigChip: chip=child; break
 var target: FriendlyDropTarget
 for child in main.friendly.find_children("*","FriendlyDropTarget",true,false):
  if child.sub==0 and is_same(child.ice_ref,g.enc.ice[0]): target=child; break
 check(chip!=null and target!=null,"rig and legal target available")
 if chip==null or target==null: return
 var from:=chip.get_global_rect().get_center(); var to:=target.get_global_rect().get_center()
 motion(from); await settle(2); mouse(from,true); await settle(2)
 motion(from+Vector2(30,-30),true,Vector2(30,-30)); await settle(3)
 motion(to,true,to-from); await settle(3)
 check(root.gui_is_dragging(),"native Icepick drag active")
 check(target.allowed and main.friendly.feedback_panel.visible and main.friendly.feedback_label.text.contains("3 BW"),"legal drag has visible exact BW feedback")
 await snapshot("05a-legal-icepick-target")
 var before:=g.bw; var cost: int=g.break_info(0,0,chip.uid).cost
 mouse(to,false); await settle()
 check(g.enc.ice[0].broken[0] and g.bw==before-cost,"native drop breaks at normal cost")
 await snapshot("05b-broken-subroutine")
 check(main.friendly.feedback_label.text.contains("BROKEN") and main.friendly.mood_for(0)=="wary","successful break has confirmation and wary mood")
 # An incompatible native drop must explain itself and spend no remaining BW.
 for child in main.friendly.rig_row.get_children():
  if child is FriendlyRigChip: chip=child; break
 for child in main.friendly.find_children("*","FriendlyDropTarget",true,false):
  if child.sub==0 and is_same(child.ice_ref,g.enc.ice[1]): target=child; break
 from=chip.get_global_rect().get_center(); to=target.get_global_rect().get_center(); before=g.bw
 motion(from); await settle(2); mouse(from,true); await settle(2)
 motion(from+Vector2(30,-30),true,Vector2(30,-30)); await settle(3)
 motion(to,true,to-from); await settle(3)
 check(root.gui_is_dragging() and not target.allowed and main.friendly.feedback_label.text.contains("NO TUMBLER ICEPICK"),"incompatible drag shows an explicit reason")
 await snapshot("05c-incompatible-target")
 mouse(to,false); await settle()
 check(g.bw==before and not g.enc.ice[1].broken[0],"invalid native drop spends no resources")
func motion(at: Vector2, held: bool=false, relative: Vector2=Vector2.ZERO) -> void:
 Input.warp_mouse(at)
 var event:=InputEventMouseMotion.new(); event.position=at; event.global_position=at; event.relative=relative; event.button_mask=MOUSE_BUTTON_MASK_LEFT if held else 0; Input.parse_input_event(event)
func mouse(at: Vector2, pressed: bool) -> void:
 var event:=InputEventMouseButton.new(); event.position=at; event.global_position=at; event.button_index=MOUSE_BUTTON_LEFT; event.pressed=pressed; Input.parse_input_event(event)
