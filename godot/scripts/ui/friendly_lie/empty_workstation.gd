class_name EmptyWorkstation
extends Control

func _draw() -> void:
 draw_rect(Rect2(Vector2.ZERO, size), Color("#10151B"))
 var center := Vector2(size.x * 0.5, size.y * 0.73)
 draw_rect(Rect2(center + Vector2(-310, 55), Vector2(620, 90)), Color("#171D24"))
 draw_rect(Rect2(center + Vector2(-325, 45), Vector2(650, 17)), Color("#30343B"))
 draw_rect(Rect2(center + Vector2(-116, -112), Vector2(232, 140)), Color("#292D34"))
 draw_rect(Rect2(center + Vector2(-103, -98), Vector2(206, 111)), Color("#090C0F"))
 draw_rect(Rect2(center + Vector2(-52, 28), Vector2(104, 17)), Color("#222730"))
 draw_colored_polygon(PackedVector2Array([
  center + Vector2(110, 30), center + Vector2(181, 30),
  center + Vector2(202, 45), center + Vector2(110, 45)
 ]), Color("#272B31"))
