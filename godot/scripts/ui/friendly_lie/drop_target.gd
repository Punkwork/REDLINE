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
 elif data.kind=="card": ok=view.card_target_ok(int(data.uid),i)
 allowed=ok; queue_redraw()
 return ok
func _drop_data(_at: Vector2, data) -> void:
 var i: int = view.game.enc.ice.find(ice_ref)
 if i<0 or not _can_drop_data(_at,data): return
 if data.kind=="pick": view.game.break_sub(i,sub,int(data.uid))
 elif data.kind=="card":
  var inst: Dictionary = view.game.find_card(int(data.uid))
  view.game.play_card(int(data.uid),i if CardDB.def(inst.id).get("target",false) else -1)
 view.end_drag(); view.ui.refresh()
func _draw() -> void:
 if not get_viewport().gui_is_dragging(): return
 if get_global_rect().has_point(get_global_mouse_position()): draw_rect(Rect2(Vector2.ZERO,size),FriendlyLook.HIGHLIGHT if allowed else FriendlyLook.RED,false,2)

func _gui_input(event: InputEvent) -> void:
 if event is InputEventMouseButton and event.pressed and event.button_index==MOUSE_BUTTON_LEFT:
  var i: int = view.game.enc.ice.find(ice_ref)
  if i<0: return
  if view.ui.targeting>=0 or view.game.pending.get("kind")=="patient_zero": view.click_ice(i)
  elif sub>=0: view.break_action(i,sub)
