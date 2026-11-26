class_name HandFan
extends Control
## ARCH-V2-003o (PROPOSED): the hand splayed and fanned as in the VAS-001 reference.
## Presentation only: lays out whatever card controls it is given, never reads rules.
## Each card pivots on its bottom centre; cards spread across the width, tilt away from
## the centre and drop slightly towards the edges. Hover or keyboard focus lifts a card
## to the front; reduced motion snaps instead of tweening.

var card_size := Vector2(150, 237)   ## HuCard 1 : 1.58 (CARD-HUCARD-001)
var max_step := 0.0                  ## 0 = card width - overlap; set from card_size
var overlap := 12.0                  ## px cards overlap when there is room
var tilt_deg := 3.5                  ## tilt per card from centre
var max_tilt_deg := 10.0
var arc_drop := 14.0                 ## px the outermost cards sit lower than the centre
var hover_lift := 26.0
var reduced_motion := false

var _cards: Array[Control] = []
var _base: Dictionary = {}           ## card -> Vector2 resting position
var _tweens: Dictionary = {}

func clear() -> void:
	for c in _cards:
		if is_instance_valid(c): remove_child(c); c.queue_free()
	_cards.clear(); _base.clear(); _tweens.clear()

func add_card(c: Control) -> void:
	c.custom_minimum_size = card_size
	c.size = card_size
	c.pivot_offset = Vector2(card_size.x * 0.5, card_size.y)
	add_child(c)
	_cards.append(c)
	c.mouse_entered.connect(_lift.bind(c, true))
	c.mouse_exited.connect(_lift.bind(c, false))
	c.focus_entered.connect(_lift.bind(c, true))
	c.focus_exited.connect(_lift.bind(c, false))
	_layout()

func cards() -> Array[Control]:
	return _cards

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED: _layout()

func _layout() -> void:
	var n := _cards.size()
	if n == 0: return
	var step := card_size.x - overlap
	if n > 1: step = minf(step, (size.x - card_size.x) / float(n - 1))
	var span := step * float(n - 1)
	var x0 := (size.x - span - card_size.x) * 0.5
	var mid := float(n - 1) * 0.5
	for i in n:
		var c := _cards[i]
		var t := 0.0 if n == 1 else (float(i) - mid) / maxf(mid, 1.0)   # -1 .. 1
		c.rotation = deg_to_rad(clampf((float(i) - mid) * tilt_deg, -max_tilt_deg, max_tilt_deg))
		var p := Vector2(x0 + step * float(i), size.y - card_size.y + arc_drop * t * t)
		_base[c] = p
		c.position = p
		c.z_index = i

func _lift(c: Control, on: bool) -> void:
	if not is_instance_valid(c) or not c.is_inside_tree() or not _base.has(c): return
	var up := on
	var target: Vector2 = _base[c] - Vector2(0, hover_lift if up else 0.0)
	c.z_index = 100 if up else _cards.find(c)
	if _tweens.has(c) and is_instance_valid(_tweens[c]): (_tweens[c] as Tween).kill()
	if reduced_motion:
		c.position = target
		return
	var tw := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_property(c, "position", target, 0.12)
	_tweens[c] = tw
