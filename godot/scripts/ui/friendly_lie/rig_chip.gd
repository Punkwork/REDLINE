class_name FriendlyRigChip
extends Button
var view
var uid := -1
func _get_drag_data(_at: Vector2):
 if view.game.phase!="PLAYER": return null
 view.begin_drag({"kind":"pick","uid":uid},self)
 var preview := FriendlyLook.label(text,13,FriendlyLook.TONER,FriendlyLook.BOLD)
 preview.add_theme_stylebox_override("normal",FriendlyLook.style(FriendlyLook.HIGHLIGHT,FriendlyLook.TONER,2))
 set_drag_preview(preview)
 return {"kind":"pick","uid":uid}
func _notification(what: int) -> void:
 if what==NOTIFICATION_DRAG_END and is_instance_valid(view): view.end_drag()
