extends SceneTree
## VIS-001: real-state fixtures and display/input regressions. Fixture budgets are not balance claims.
var main: Node
var failures := 0
var checks := 0
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
 checks+=1
 if not ok: failures+=1; push_error("Friendly Lie: "+message)
func settle(frames: int=8) -> void:
 for i in frames: await process_frame
 await RenderingServer.frame_post_draw
func snap(name: String) -> void:
 if main.tween and main.tween.is_running(): main.tween.custom_step(100.0)
 main.nr_text.visible_ratio=1.0
 await settle()
 check(root.get_texture().get_image().save_png(OS.get_environment("SHOT_DIR").path_join(name+".png"))==OK,"save "+name)
 print("shot ",name)
func start(row: int=0, index: int=0) -> Game:
 main.reduced_motion=false
 main._start_as("GENERALIST")
 var g: Game=main.g; g.rng.seed=711; g.animate=false; g.hold_enabled=false
 g.row=row; g.available=[index]; g.enter_node(index)
 if g.phase=="READY_RIG": g.skip_ready_rig()
 main.refresh()
 return g
func install(g: Game, id: String) -> int:
 var c:=g._new_inst(id); g.hand.append(c); g.bw=40
 check(g.play_card(c.uid),"fixture installs "+id)
 return c.uid
func move_mouse(at: Vector2, held: bool=false, relative: Vector2=Vector2.ZERO) -> void:
 var e:=InputEventMouseMotion.new(); e.position=at; e.global_position=at; e.relative=relative; e.button_mask=MOUSE_BUTTON_MASK_LEFT if held else 0; Input.parse_input_event(e)
func mouse(at: Vector2, pressed: bool) -> void:
 var e:=InputEventMouseButton.new(); e.position=at; e.global_position=at; e.button_index=MOUSE_BUTTON_LEFT; e.pressed=pressed; Input.parse_input_event(e)
func drag(from: Vector2, to: Vector2) -> void:
 move_mouse(from); await settle(2); mouse(from,true); await settle(2)
 move_mouse(from+Vector2(30,-30),true,Vector2(30,-30)); await settle(3)
 move_mouse(to,true,to-from); await settle(3)
func cards_readable() -> void:
 for card in main.friendly.hand.get_children():
  for child in card.body.get_children():
   if child is RichTextLabel: check(child.get_content_height()<=child.size.y+1,"all rules fit on "+card.card_id)
func run() -> void:
 main=load("res://scenes/Main.tscn").instantiate(); root.add_child(main); main.voice_on=false; main.voice.stop(); await settle()
 var g:=start()
 check(g.enc.ice[0].id=="AUTO_RENEW" and g.enc.ice[1].id=="CAPTCHA","turn 1 uses actual CAPTCHA node")
 check(main.friendly.mood_for(1)=="cheery","turn 1 CAPTCHA is cheery")
 check((main.friendly.mood_for(0)=="lethal") == (main.friendly.biggest_hit()>=5),"AUTO-RENEW mood follows the published roll")
 check(g.hand.size()==6 and g.draw_pile.size()==6,"normal Generalist hand/deck counts")
 await snap("vis_01_friendly_turn1"); cards_readable()
 # Two real responses advance HARDENING and the live conveyor. No rotation is fabricated.
 install(g,"FORTRESS_ICEPICK"); var tumbler:=install(g,"TUMBLER_ICEPICK")
 g.boost_pick(tumbler); g.boost_pick(tumbler); g.bw=40
 check(g.break_sub(0,0),"AUTO-RENEW S1 broken")
 for turn in 2:
  g.end_turn()
  while g.phase=="CHOICE" and g.pending.get("kind")=="discard": g.choose(g.hand[0].uid)
 check(g.enc.turn==3 and g.ice_str(0)==7,"two responses produce turn 3 STR 7")
 main.refresh()
 check(g.break_sub(1,3),"turn 3 active CAPTCHA DEADLOCK broken")
 main.refresh(); await settle(35)
 var expected_hit := 0
 for step in g.response_preview():
  if step.skipped or step.hidden: continue
  for source in step.effects:
   var effect := g.effect_value(g.enc.ice[step.ice], source)
   if effect.k=="PULP": expected_hit=maxi(expected_hit,effect.v)
 check(main.friendly.mood_for(1)=="wary","turn 3 CAPTCHA is wary after the DEADLOCK break")
 check((main.friendly.mood_for(0)=="lethal") == (expected_hit>=5),"AUTO-RENEW turn 3 mood follows the published roll")
 check(main.friendly.biggest_hit()==expected_hit,"biggest hit matches the rolled response")
 check(main.friendly.new_subs(1).has(4),"actual newly tumbled TRACE recorded")
 var preview:=str(g.response_preview())
 main.lethal_pulp_threshold=7
 check(main.friendly.mood_for(0)=="wary" and str(g.response_preview())==preview,"threshold tunes presentation only")
 main.lethal_pulp_threshold=5
 await snap("vis_02_wary_lethal_turn3")
 g.add_trace(26-g.trace,false); main.refresh()
 check(main.friendly.corporation_state=="cracking","TRACE 26 cracks the corporation")
 await snap("vis_03_cracking")
 check(main.friendly.toast.visible,"first crossing shows corporate toast")
 var tracer_before:=g.draw_pile.filter(func(c): return c.id=="TRACER").size()
 g.add_trace(40-g.trace,false); main.refresh()
 check(g.strikes==1 and g.trace==20 and main.friendly.strike_overlay.visible,"first strike displays actual post-strike state")
 check(g.draw_pile.filter(func(c): return c.id=="TRACER").size()==tracer_before+1,"Game inserted exactly one TRACER")
 await snap("vis_04_strike1")
 main.friendly.dismiss_strike(); check(main.friendly.corporation_state=="cracking","dismiss returns to Cracking")
 g.add_trace(20,false); main.refresh(); await settle(15)
 check(g.strikes==2 and g.enc.ice[0].id=="HOUSE_CALL" and main.friendly.corporation_state=="mask_off","second strike adds real Black ICE and Mask off")
 await snap("vis_05_mask_off")
 check(not main.friendly.ice_scroll.get_h_scroll_bar().visible,"three Mask-off mascots fit horizontally")
 for i in g.enc.ice.size(): check(main.friendly.mood_for(i)=="lethal","every Mask-off ICE lethal")
 # Native drag: the real GHOST SIGNAL leaves a dashed gap and VOID watches its preview.
 g=start(1,1); g.hand.clear()
 for id in ["PULP_SHIELD","PROBE","VOID_ICEPICK","BASIC_EXTRACTOR","PROBE","GHOST_SIGNAL"]: g.hand.append(g._new_inst(id))
 main.refresh(); await settle(15)
 var card: FriendlyCard=main.friendly.hand.get_child(5)
 main.friendly.hand.focus_card(card); await settle()
 var before:=g.bw
 await drag(card.get_global_rect().get_center(),Vector2(1130,475))
 check(root.gui_is_dragging() and main.friendly.dragging_uid==card.uid and card.placeholder,"native drag leaves a hand gap")
 check(main.friendly.watcher_warning.visible,"CLOAK drag warns about WATCHER")
 var mascot: FriendlyMascot=main.friendly.ice_row.find_children("*","FriendlyMascot",true,false)[0]
 check(mascot.face.look.x>0,"VOID pupil follows dragged card")
 check(g.response_preview()[0].hidden and not g.enc.ice[0].seen[0],"VOID rule remains hidden")
 await snap("vis_06_doorbell_drag")
 mouse(Vector2(1130,475),false); await settle()
 check(g.bw==before-2 and g.trace==1,"real drop plays CLOAK and pays existing WATCHER rule")
 # Eight-card fan includes corporate junk. Last card stays individually accessible.
 g=start(); g.hand.clear()
 for id in ["FORTRESS_ICEPICK","TUMBLER_ICEPICK","VOID_ICEPICK","BASIC_EXTRACTOR","PROBE","GHOST_SIGNAL","TRACER","SPAM"]: g.hand.append(g._new_inst(id))
 main.refresh(); await settle(15)
 check(main.friendly.hand.get_child_count()==8,"eight-card hand has no cap")
 await snap("vis_07_eight_card_hand"); cards_readable()
 # Real rig drag onto a visible subroutine; invalid hidden drop is checked without payment.
 var pick:=install(g,"FORTRESS_ICEPICK"); main.refresh(); await settle(15)
 var chip: FriendlyRigChip
 for c in main.friendly.rig_row.get_children():
  if c is FriendlyRigChip and c.uid==pick: chip=c
 var target: FriendlyDropTarget
 for c in main.friendly.find_children("*","FriendlyDropTarget",true,false):
  if c.sub==0 and is_same(c.ice_ref,g.enc.ice[0]): target=c
 check(chip!=null and target!=null,"rig chip and subroutine targets exist")
 if chip!=null and target!=null:
  var cost: int=g.break_info(0,0,pick).cost; before=g.bw
  await drag(chip.get_global_rect().get_center(),target.get_global_rect().get_center())
  check(root.gui_is_dragging(),"native installed-Icepick drag starts")
  mouse(target.get_global_rect().get_center(),false); await settle(15)
  check(g.enc.ice[0].broken[0] and g.bw==before-cost,"native rig drop breaks selected subroutine at normal cost")
 var scene_before:=str(g.response_preview())
 main.set_reduced_motion(true); await settle()
 check(main.friendly.reduced_motion and not main.friendly.glitch_layer.visible,"reduced motion suppresses glitch")
 mascot=main.friendly.ice_row.find_children("*","FriendlyMascot",true,false)[0]
 var old_position:=mascot.position; var old_rotation:=mascot.rotation
 await settle(20)
 check(mascot.position==old_position and mascot.rotation==old_rotation,"reduced-motion mascot stays still")
 check(str(g.response_preview())==scene_before,"visual option preserves response")
 # Existing at-least-five-second response timing is retained with motion disabled.
 g.animate=true; var started:=Time.get_ticks_msec()
 main._on_end_turn()
 while main.responding: await process_frame
 check(Time.get_ticks_msec()-started>=5000,"reduced motion retains response timing")
 # Every authored card must fit its full rule text, including the longest starter/reward cards.
 var staging:=Control.new(); staging.position=Vector2(1700,0); root.add_child(staging)
 for id in CardDB.DEFS:
  var paper:=FriendlyCard.new(); paper.setup(main.friendly,id,-1); staging.add_child(paper)
 await settle(2)
 for paper in staging.get_children():
  for child in paper.body.get_children():
   if child is RichTextLabel: check(child.get_content_height()<=child.size.y+1,"full authored rules fit: "+paper.card_id)
 staging.queue_free()
 for i in g.enc.ice.size():
  var definition:=g.ice_definition(g.enc.ice[i])
  for sub in definition.subs.size():
   if Game._has_deadlock(definition.subs[sub]): g._do_break(i,sub)
 main.refresh(); await settle()
 check(g.enc.breached and main.friendly.mood_for(0)=="knocked_out","BREACH produces knocked-out mood")
 g=start(0,1)
 await settle()
 var curve: Dictionary=g.ice_definition(g.enc.ice[0]).subs[2][0]
 var shown: String="PULP %d · RANDOM" % g.effect_value(g.enc.ice[0],curve).v
 check(main.friendly.effect_text(g.enc.ice[0],curve)==shown,"curve B publishes its next number on ICE")
 var response_text: Array=main.friendly.response.find_children("*","Label",true,false).map(func(label): return label.text)
 check(response_text.has(shown),"response strip publishes the same curve B number")
 main.set_reduced_motion(false)
 print("FRIENDLY LIE: %d checks, %d failures"%[checks,failures])
 main.voice.stop(); main.voice.stream=null
 main.queue_free(); await settle(15); quit(1 if failures else 0)
