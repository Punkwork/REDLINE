class_name FriendlyHand
extends Control
## No maximum hand size. Overlapping cards can always be raised with hover/wheel/arrows.
var selected := -1
var reduced_motion := false
func arrange() -> void:
 var count := get_child_count()
 if count == 0: return
 var step := minf(158.0, (size.x - 174.0) / maxf(1, count - 1))
 var span := 146.0 + step * (count - 1)
 for i in count:
  var c = get_child(i)
  var t := (float(i) / maxf(1, count - 1) - 0.5) * 2
  c.rest_position = Vector2((size.x - span) * 0.5 + i * step, 8 + (12 * t * t if count >= 7 else 0))
  c.rest_rotation = deg_to_rad(t * 5 if count >= 7 else float((c.uid % 5) - 2))
  c.pivot_offset = Vector2(73, 109); c.position = c.rest_position; c.rotation = c.rest_rotation; c.z_index = i
func focus_card(card: Control) -> void:
 grab_focus()
 selected = card.get_index()
 card.z_index = 100
 card.rotation = 0.0
 card.position = card.rest_position - Vector2(0, 28)
func release_card(card: Control) -> void:
 card.z_index = card.get_index(); card.rotation = card.rest_rotation; card.position = card.rest_position
func browse(direction: int) -> void:
 if get_child_count() == 0: return
 for child in get_children(): release_card(child)
 selected = posmod(selected + direction, get_child_count())
 focus_card(get_child(selected))
func _gui_input(event: InputEvent) -> void:
 if event is InputEventMouseButton and event.pressed:
  if event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]: browse(1 if event.button_index == MOUSE_BUTTON_WHEEL_DOWN else -1); accept_event()
 if event is InputEventKey and event.pressed:
  if event.keycode in [KEY_LEFT, KEY_RIGHT]: browse(1 if event.keycode == KEY_RIGHT else -1); accept_event()
