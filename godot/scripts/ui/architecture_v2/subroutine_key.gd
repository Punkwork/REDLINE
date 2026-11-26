class_name SubroutineKey
extends Control
## CAS-001 C09 (ARCH-V2-003): one subroutine as an illuminated electromechanical key, as in V1 Build 12
## (ICE-ANALOG-001): the glyph says the effect, the numeral its size, the lamp its state, the chip its
## current BW break cost, the corner badge a modifier, "+n" further effects. Order is spatial (left to
## right, chevrons between keys). Full rule text lives in the hover/focus inspector, never on the key.
##
## Click, Enter/Space and a dropped program all leave through the single break_requested signal;
## the key never calls Game. Draws through IceKey (Build 12's key renderer), unchanged.

signal break_requested(ice_ref: Dictionary, sub: int, pick_uid: int)
signal inspect_requested(key: SubroutineKey)
signal inspect_ended(key: SubroutineKey)

## Called with a drag payload; returns {ok, cost, reason}. Set by the owning panel (controller-backed).
var drop_check: Callable
var model: Dictionary = {}
## The key's words for assistive tech (the same text the inspector shows).
var unit := 1.32
var face: IceKey
var _drop_state := ""   # "", "ok", "no"

func _init() -> void:
	focus_mode = Control.FOCUS_ALL
	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	face = IceKey.new()
	face.name = "Face"
	add_child(face)
	mouse_entered.connect(func(): _set_lit(true); inspect_requested.emit(self))
	focus_entered.connect(func(): _set_lit(true); inspect_requested.emit(self))
	mouse_exited.connect(func(): _drop_state = ""; queue_redraw(); _release())
	focus_exited.connect(_release)

func set_model(m: Dictionary, key_unit: float = -1.0) -> void:
	model = m
	if key_unit > 0.0: unit = key_unit
	var mini: bool = m.get("mini", false)
	face.configure(String(m.kind), String(m.value), String(m.state), String(m.cost_text), mini, unit)
	face.badge = String(m.get("badge", ""))
	face.extra = int(m.get("extra", 0))
	face.locked = bool(m.get("locked", false))
	face.firing = bool(m.get("firing", false))
	custom_minimum_size = face.custom_minimum_size
	if not mini:
		# Every bank key is as tall as one with a chip, so lamps, caps and chips line up across the row.
		custom_minimum_size.y = (IceKey.KEY + IceKey.LAMP_H + IceKey.CHIP_H + 4.0) * unit
	size = custom_minimum_size
	size_flags_vertical = Control.SIZE_SHRINK_CENTER
	face.position = Vector2.ZERO
	tooltip_text = ""   # the inspector replaces native tooltips
	var place := String(m.get("place", "S%d" % (int(m.sub) + 1)))
	# Screen readers / keyboard users get the same words the inspector shows.
	accessibility_text = "%s: %s" % [place, String(m.get("title", ""))]
	queue_redraw()

var accessibility_text := ""

func sub() -> int: return int(model.get("sub", -1))
func ice_ref() -> Dictionary: return model.get("ref", {})

func _gui_input(event: InputEvent) -> void:
	if model.is_empty() or model.get("mini", false): return
	if event.is_action_pressed("ui_accept") and has_focus():
		accept_event()
		break_requested.emit(ice_ref(), sub(), -1)
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		accept_event()
		grab_focus()
		break_requested.emit(ice_ref(), sub(), -1)

func _can_drop_data(_at: Vector2, data) -> bool:
	if model.is_empty() or model.get("mini", false): return false
	if not (data is Dictionary) or data.get("kind", "") != "pick" or not drop_check.is_valid(): return false
	var info: Dictionary = drop_check.call(sub(), int(data.uid))
	_drop_state = "ok" if info.get("ok", false) else "no"
	queue_redraw()
	return info.get("ok", false)

func _drop_data(at: Vector2, data) -> void:
	if not _can_drop_data(at, data): return
	_drop_state = ""
	queue_redraw()
	break_requested.emit(ice_ref(), sub(), int(data.uid))

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		_drop_state = ""
		queue_redraw()

func _draw() -> void:
	if model.get("firing", false):
		# Corporation Response: the subroutine resolving now. A static amber ring (reads under reduced
		# motion too); IceKey adds its own pulse on top when motion is allowed.
		var fr := StyleBoxFlat.new()
		fr.draw_center = false; fr.set_border_width_all(4); fr.border_color = VasTokens.AMBER; fr.set_corner_radius_all(18)
		fr.shadow_color = Color(VasTokens.AMBER, 0.55); fr.shadow_size = 10
		draw_style_box(fr, face.key_rect().grow(7))
	if _drop_state == "": return
	var r := face.key_rect().grow(8)
	var col := VasTokens.FOCUS if _drop_state == "ok" else VasTokens.WARNING
	var sb := StyleBoxFlat.new()
	sb.draw_center = false; sb.set_border_width_all(3); sb.border_color = col; sb.set_corner_radius_all(18)
	draw_style_box(sb, r)

func _set_lit(on: bool) -> void:
	face.lit = on
	face.queue_redraw()

func _release() -> void:
	if not is_inside_tree() or is_queued_for_deletion(): return
	if has_focus() or get_global_rect().has_point(get_global_mouse_position()): return
	_set_lit(false)
	inspect_ended.emit(self)
