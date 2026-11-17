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
func _click(at: Vector2) -> void:
 var motion:=InputEventMouseMotion.new(); motion.position=at; motion.global_position=at; Input.parse_input_event(motion)
 await process_frame
 var down:=InputEventMouseButton.new(); down.position=at; down.global_position=at; down.button_index=MOUSE_BUTTON_LEFT; down.pressed=true; Input.parse_input_event(down)
 await process_frame
 var up:=down.duplicate(); up.pressed=false; Input.parse_input_event(up)
 await _settle()
func _geometry() -> void:
 var view: FriendlyEncounter=main.friendly
 _check(view.hand.get_child_count()==main.g.hand.size(),"every card has a view")
 var bound:=view.hand.get_global_rect()
 _check(bound.end.x<=view.end_button.position.x,"hand stays left of END TURN")
 _check(not bound.intersects(view.pile_text.get_global_rect()),"hand stays clear of pile counters")
 for card in view.hand.get_children():
  _check(card.size==Vector2(146,218),"cards retain their printed size")
  _check(card.rest_position.x>=0 and card.rest_position.x+146<=view.hand.size.x,"fan has no clipped outer cards")
func _run() -> void:
 main=load("res://scenes/Main.tscn").instantiate(); root.add_child(main)
 await _settle()
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
  await _click(last.get_global_rect().get_center())
  _check(g._find(g.hand,shield.uid).is_empty() and g.bw==before-1 and g.shield==3,"last card click plays normally")
  _check(g.phase=="PLAYER","card click does not trigger END TURN")
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
