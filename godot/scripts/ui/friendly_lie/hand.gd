class_name FriendlyHand
extends Control
## HAND-MAX-001: at most 10 cards (Game.MAX_HAND). CARDS-004: 1.4x cards in a
## centred, gently fanned hand that overlaps slightly from the start and more as it grows.
const OVERLAP := [0.05, 0.05, 0.05, 0.05, 0.05, 0.08, 0.10, 0.18, 0.26, 0.35, 0.43]
const FAN_TOTAL_DEG := 20.0
const FAN_MAX_STEP_DEG := 4.0
const RAISE := 36.0
## ENC-CONCEPT-001 layout pass: hand cards are drawn smaller so they sit inside the tray (concept 2).
const HAND_SCALE := 0.72
## Cards sit this far below the top of the hand area, so the chassis hardware
## above each card (and a fanned card's lifted corner) clears the rack.
const TOP_OFFSET := 24.0
var selected := -1
var reduced_motion := false

static func overlap_for(count: int) -> float:
 return OVERLAP[clampi(count, 0, OVERLAP.size() - 1)]

static func fan_step_deg(count: int) -> float:
 return minf(FAN_MAX_STEP_DEG, FAN_TOTAL_DEG / maxf(1, count - 1))

func arrange() -> void:
 var count := get_child_count()
 if count == 0: return
 var k := HAND_SCALE
 var w := FriendlyCard.PHYSICAL_RECT.size.x * k
 var step := fan_step_deg(count)
 var mid := (count - 1) / 2.0
 # A tilted outer card swings sideways at the top; keep that swing inside the hand area.
 var swing := FriendlyCard.PHYSICAL_RECT.size.y * k * sin(deg_to_rad(step * mid))
 var stride := w * (1.0 - overlap_for(count))
 if count > 1: stride = minf(stride, (size.x - 2.0 * swing - w) / (count - 1))
 var span := w + stride * (count - 1)
 for i in count:
  var c = get_child(i)
  var off := i - mid
  c.scale = Vector2.ONE * k
  # Fan about the bottom centre; scaling also happens about the pivot, so offset the position.
  c.pivot_offset = Vector2(FriendlyCard.CARD_SIZE.x / 2.0, FriendlyCard.CARD_SIZE.y)
  var top_left := Vector2((size.x - span) * 0.5 + i * stride - FriendlyCard.PHYSICAL_RECT.position.x * k, TOP_OFFSET + off * off * step * 0.5)
  c.rest_position = top_left + c.pivot_offset * (k - 1.0)
  c.rest_rotation = deg_to_rad(off * step)
  c.position = c.rest_position; c.rotation = c.rest_rotation; c.z_index = i
func focus_card(card: Control) -> void:
 grab_focus()
 if card.motion: card.motion.kill()
 selected = card.get_index()
 card.z_index = 100
 card.rotation = 0.0
 card.position = card.rest_position - Vector2(0, RAISE); card.queue_redraw()
func release_card(card: Control) -> void:
 card.z_index = card.get_index(); card.rotation = card.rest_rotation; card.position = card.rest_position; card.queue_redraw()
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
  elif event.keycode in [KEY_ENTER, KEY_KP_ENTER] and selected >= 0 and selected < get_child_count():
   var card: FriendlyCard = get_child(selected)
   card.view.ui._on_card(card.uid)
   accept_event()
