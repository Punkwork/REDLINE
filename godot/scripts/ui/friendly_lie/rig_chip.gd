class_name FriendlyRigChip
extends Button
var view
var uid := -1
func _get_drag_data(_at: Vector2):
 if view.game.phase!="PLAYER": return null
 view.begin_drag({"kind":"pick","uid":uid},self)
 var preview:=PanelContainer.new(); var paper:=FriendlyLook.style(FriendlyLook.HIGHLIGHT,FriendlyLook.TONER,2); paper.set_content_margin_all(6); preview.add_theme_stylebox_override("panel",paper); preview.add_child(FriendlyLook.label("↘",14,FriendlyLook.TONER,FriendlyLook.BOLD)); preview.position=Vector2(12,-28)
 set_drag_preview(preview)
 return {"kind":"pick","uid":uid}
func _notification(what: int) -> void:
 if what==NOTIFICATION_DRAG_END and is_instance_valid(view): view.end_drag()
