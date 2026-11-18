extends SceneTree
## Fan geometry and real GUI input; oversized hands are controlled fixtures.
var main: Node
var failures := 0
func _initialize() -> void: call_deferred("_run")
func _check(ok: bool, message: String) -> void:
 if not ok: failures+=1; push_error("Hand layout: "+message)
func _settle() -> void:
 for i in 18: await process_frame
 await RenderingServer.frame_post_draw
func _snap(name: String) -> void:
 _check(root.get_texture().get_image().save_png(OS.get_environment("SHOT_DIR").path_join(name+".png"))==OK,"save "+name)
 print("shot ",name)
func _click(at: Vector2, button := MOUSE_BUTTON_LEFT) -> void:
 var motion:=InputEventMouseMotion.new(); motion.position=at; motion.global_position=at; Input.parse_input_event(motion)
 await process_frame
 var down:=InputEventMouseButton.new(); down.position=at; down.global_position=at; down.button_index=button; down.pressed=true; Input.parse_input_event(down)
 await process_frame
 var up:=down.duplicate(); up.pressed=false; Input.parse_input_event(up)
 await _settle()
func _move(at: Vector2, held: bool = false, relative := Vector2.ZERO) -> void:
 Input.warp_mouse(at)
 var motion := InputEventMouseMotion.new()
 motion.position = at
 motion.global_position = at
 motion.relative = relative
 motion.button_mask = MOUSE_BUTTON_MASK_LEFT if held else 0
 Input.parse_input_event(motion)

func _drag(source: Vector2, destination: Vector2) -> void:
 _move(source)
 await process_frame
 var button := InputEventMouseButton.new()
 button.position = source
 button.global_position = source
 button.button_index = MOUSE_BUTTON_LEFT
 button.pressed = true
 Input.parse_input_event(button)
 await process_frame
 _move(source+Vector2(0,-35), true, Vector2(0,-35))
 await process_frame
 _move(destination, true, destination-source)
 await process_frame
 _check(root.gui_is_dragging(), "native drag starts")
 var up := InputEventMouseButton.new()
 up.position = destination
 up.global_position = destination
 up.button_index = MOUSE_BUTTON_LEFT
 Input.parse_input_event(up)
 await _settle()

func _bay_and_inspection() -> void:
 main._start_as("GENERALIST")
 var g: Game = main.g
 g.enter_node(0)
 g.skip_ready_rig()
 g.hand.clear()
 var program := g._new_inst("BASIC_EXTRACTOR")
 var probe := g._new_inst("PROBE")
 var shield := g._new_inst("PULP_SHIELD")
 g.hand.assign([program,probe,shield])
 main.refresh()
 await _settle()

 var view: FriendlyEncounter = main.friendly
 var first: FriendlyCard = view.hand.get_child(0)
 var first_position := first.get_global_rect().get_center()
 await _click(first_position,MOUSE_BUTTON_RIGHT)
 _check(main.inspect.visible and main.inspect.get_child(0).scale == Vector2(1.5,1.5), "right click enlarges a hand card to 150%")
 var preview: Rect2 = main.inspect.get_global_rect()
 _check(preview.get_center().is_equal_approx(Vector2(800,500)), "enlarged cartridge is centered")
 _snap("card_inspection_150_percent")
 await _click(preview.get_center(),MOUSE_BUTTON_RIGHT)
 _check(not main.inspect.visible, "right click on the preview restores the hand")

 var before := g.bw
 await _click(first_position)
 _check(g.bw == before and g._installed_entry(program.uid).is_empty(), "clicking a hand PROGRAM does not install it")
 await _drag(first.get_global_rect().get_center(),Vector2(1510,230))
 _check(g.bw == before and g._installed_entry(program.uid).is_empty(), "drop away from the PROGRAM bay spends nothing")
 await _drag(first.get_global_rect().get_center(),Vector2(140,531))
 _check(not g._installed_entry(program.uid).is_empty() and g.bw == before-1, "drop on the bay installs the PROGRAM exactly once")
 _check(view.program_slots.get_child_count() == 1, "installed PROGRAM is in the left bay")
 var chip: Button = view.program_slots.get_child(0).get_child(0)
 _move(Vector2(140,531))
 await process_frame
 var chip_center := chip.get_global_rect().get_center()
 _move(chip_center, false, chip_center - Vector2(140,531))
 await _settle()
 _check(main.inspect.visible and not main.inspection_pinned, "installed PROGRAM has a hover preview")
 await _click(chip.get_global_rect().get_center())
 _check(main.inspection_pinned and main.inspected_uid == program.uid, "installed PROGRAM click pins inspection")
 await _click(chip.get_global_rect().get_center())
 _check(not main.inspect.visible, "click again closes installed PROGRAM inspection")
 _snap("program_bay_installed")

 before = g.bw
 var untargeted: FriendlyCard = view.hand.get_child(1)
 await _drag(untargeted.get_global_rect().get_center(),Vector2(1505,660))
 _check(g.bw == before and not g.find_card(shield.uid).is_empty(), "non-targeted SCRIPT cannot be dropped on the lower half")
 await _drag(untargeted.get_global_rect().get_center(),Vector2(1510,225))
 _check(g.bw == before-1 and g.shield == 3, "non-targeted SCRIPT plays on the upper half")

 before = g.bw
 var targeted: FriendlyCard = view.hand.get_child(0)
 await _drag(targeted.get_global_rect().get_center(),Vector2(1510,225))
 _check(g.bw == before and not g.find_card(probe.uid).is_empty(), "targeted SCRIPT requires ICE")
 var target: FriendlyDropTarget = view.find_children("*","FriendlyDropTarget",true,false).filter(func(candidate): return candidate.sub == -1 and is_same(candidate.ice_ref,g.enc.ice[0]))[0]
 var strength := g.ice_str(0)
 await _drag(targeted.get_global_rect().get_center(),target.get_global_rect().get_center())
 _check(g.bw == before-1 and g.ice_str(0) == strength-2, "targeted SCRIPT resolves on eligible ICE")

func _geometry() -> void:
 var view: FriendlyEncounter=main.friendly
 _check(view.hand.get_child_count()==main.g.hand.size(),"every card has a view")
 var bound:=view.hand.get_global_rect()
 _check(bound.end.x<=view.end_button.position.x,"hand stays left of END TURN")
 _check(not bound.intersects(view.pile_text.get_global_rect()),"hand stays clear of pile counters")
 for card in view.hand.get_children():
  _check(card.size==FriendlyCard.CARD_SIZE,"cards retain their printed size")
  _check(card.rest_position.x>=0 and card.rest_position.x+FriendlyCard.CARD_SIZE.x<=view.hand.size.x,"fan has no clipped outer cards")
func _run() -> void:
 main=load("res://scenes/Main.tscn").instantiate(); root.add_child(main)
 await _settle()
 main.reduced_motion = true
 await _bay_and_inspection()
 for count in [6,7,8,9,10,16]:
  main._start_as("VECTOR"); var g: Game=main.g; g.enter_node(0); g.choose_ice(1)
  _check(g.phase=="PLAYER","PATIENT ZERO resolved")
  g.hand.clear()
  var ids:=["SMASH_AND_GRAB","BORROWED_CREDENTIALS","REPLICATOR","INJECT","RUNTIME_ERROR","PROBE","OUTBREAK","STINGER"]
  for i in count-1: g.hand.append(g._new_inst(ids[i%ids.size()]))
  var shield:=g._new_inst("PULP_SHIELD"); g.hand.append(shield)
  main.refresh(); await _settle(); _geometry(); _snap("hand_%02d_fan"%count)
  var hand: FriendlyHand=main.friendly.hand
  # Wheel/keyboard browse every card without changing the maximum hand size.
  for i in count:
   hand.browse(1)
   var card: FriendlyCard=hand.get_child(hand.selected)
   _check(card.rotation==0 and card.z_index==100,"browsed card fully faces the player")
  var last: FriendlyCard=hand.get_child(count-1); hand.focus_card(last); await _settle()
  _check(last.get_global_rect().end.y<=1000,"raised card fits the viewport")
  _snap("hand_%02d_revealed"%count)
  var before:=g.bw
  await _drag(last.get_global_rect().get_center(),Vector2(1510,230))
  _check(g._find(g.hand,shield.uid).is_empty() and g.bw==before-1 and g.shield==3,"last card drag plays normally")
  _check(g.phase=="PLAYER","card drag does not trigger END TURN")
 main._start_as("RIOT"); var riot: Game=main.g; riot.enter_node(0)
 var source:=riot._new_inst("SMASH_AND_GRAB"); riot.hand.append(source)
 _check(riot.play_card(source.uid),"install SMASH & GRAB")
 var target:=riot._new_inst("PULP_SHIELD"); riot.hand.append(target)
 main.refresh(); await _settle()
 var action: Button=main.find_child("SmashGrabCache",true,false)
 _check(action!=null and not action.disabled,"paid CACHE action available")
 if action!=null:
  action.pressed.emit(); await _settle()
  _check(riot.phase=="CHOICE" and riot.pending.options.has(target.uid) and not riot.pending.options.has(source.uid),"rig opens hand-card CACHE choice")
  _snap("smash_grab_choose"); riot.choose(target.uid); main.refresh(); await _settle()
  _check(riot._find(riot.hand,target.uid).cached and riot._installed_entry(source.uid).is_empty(),"another hand card CACHED; extractor uninstalled")
  _snap("smash_grab_cached")
 print("HAND LAYOUT: %d failures"%failures)
 main.queue_free(); await _settle(); quit(1 if failures else 0)
