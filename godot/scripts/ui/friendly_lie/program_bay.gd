class_name FriendlyProgramBay
extends Panel

var encounter: FriendlyEncounter

func _can_drop_data(_at: Vector2, data) -> bool:
 if not data is Dictionary or data.get("kind") != "card":
  return false
 var card := encounter.game.find_card(int(data.uid))
 if card.is_empty():
  return false
 var definition := CardDB.def(card.id)
 return definition.type == "PROGRAM" and encounter.game.can_play(card.uid).ok

func _drop_data(at: Vector2, data) -> void:
 if not _can_drop_data(at, data):
  return
 encounter.ui.play_seated_card(int(data.uid))
 encounter.end_drag()
 encounter.ui.refresh()

func _process(_delta: float) -> void:
 if encounter.dragging_uid < 0:
  modulate = Color.WHITE
  return
 var data := {"kind":encounter.drag_kind, "uid":encounter.dragging_uid}
 modulate = Color("#FFF0C0") if _can_drop_data(Vector2.ZERO, data) else Color.WHITE
