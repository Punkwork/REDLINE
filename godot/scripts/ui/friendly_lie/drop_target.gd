class_name FriendlyDropTarget
extends Control
var view
var ice_ref: Dictionary
var sub := -1
var allowed := false
func _can_drop_data(_at: Vector2, data) -> bool:
 if not data is Dictionary or not data.has("kind"): return false
 var i: int = view.game.enc.ice.find(ice_ref)
 if i<0: return false
 var ok := false
 if data.kind=="pick" and sub>=0:
  var info: Dictionary = view.game.break_info(i,sub,int(data.uid)); ok=info.ok
  tooltip_text="%d BW · MARGIN %d" % [info.cost,info.get("margin",0)] if ok else info.reason
  view.drag_description=view.game.ice_definition(ice_ref).name+" · S%d\n"%(sub+1)+tooltip_text
 elif data.kind=="card": ok=view.card_target_ok(int(data.uid),i)
 allowed=ok; queue_redraw()
 return ok
func _drop_data(_at: Vector2, data) -> void:
 var i: int = view.game.enc.ice.find(ice_ref)
 if i<0 or not _can_drop_data(_at,data): return
 if data.kind=="pick":
  var cost: int=view.game.break_info(i,sub,int(data.uid)).cost
  if view.game.break_sub(i,sub,int(data.uid)): view.show_break_feedback(ice_ref,sub,cost)
 elif data.kind=="card":
  var inst: Dictionary = view.game.find_card(int(data.uid))
  view.ui.play_seated_card(int(data.uid),i if CardDB.def(inst.id).get("target",false) else -1)
 view.end_drag(); view.ui.refresh()
func _process(_delta: float) -> void:
 if not is_visible_in_tree() or not is_instance_valid(view): return
 var was_allowed:=allowed
 if view.dragging_uid>=0:
  var i: int=view.game.enc.ice.find(ice_ref)
  if i>=0:
   if view.drag_kind=="pick" and sub>=0:
    var info: Dictionary=view.game.break_info(i,sub,view.dragging_uid); allowed=info.ok
    if get_global_rect().has_point(get_global_mouse_position()):
     view.drag_description=view.game.ice_definition(ice_ref).name+" · S%d\n"%(sub+1)+("%d BW · MARGIN %d"%[info.cost,info.get("margin",0)] if info.ok else info.reason)
   elif view.drag_kind=="card": allowed=view.card_target_ok(view.dragging_uid,i)
 else: allowed=false
 if was_allowed!=allowed or view.dragging_uid>=0: queue_redraw()
func _draw() -> void:
 if not get_viewport().gui_is_dragging(): return
 var rect:=Rect2(Vector2(1,1),size-Vector2(2,2))
 var hovering:=get_global_rect().has_point(get_global_mouse_position())
 if hovering: draw_rect(rect,FriendlyLook.SERVICE_TEAL if allowed else Color("#A62639"),false,3)
 elif allowed and sub>=0:
  for edge in [[rect.position,Vector2(rect.end.x,rect.position.y)],[Vector2(rect.end.x,rect.position.y),rect.end],[rect.end,Vector2(rect.position.x,rect.end.y)],[Vector2(rect.position.x,rect.end.y),rect.position]]: draw_dashed_line(edge[0],edge[1],FriendlyLook.SERVICE_TEAL,1,5)

func _gui_input(event: InputEvent) -> void:
 if event is InputEventMouseButton and event.pressed and event.button_index==MOUSE_BUTTON_LEFT:
  var i: int = view.game.enc.ice.find(ice_ref)
  if i<0: return
  if view.ui.targeting>=0 or view.game.pending.get("kind")=="patient_zero": view.click_ice(i)
  elif sub>=0: view.break_action(i,sub)

func _get_tooltip(_at: Vector2) -> String:
 # The persistent header carries drag costs/reasons; a native tooltip would cover rule text.
 return "" if is_instance_valid(view) and view.dragging_uid>=0 else tooltip_text
