class_name PunchStock
extends Control

var layers: Array
var stock := true

func _init(values: Array, shows_stock: bool = true) -> void:
 layers = values
 stock = shows_stock
 mouse_filter = Control.MOUSE_FILTER_IGNORE

func _draw() -> void:
 var last: String = layers.back() if not layers.is_empty() else ""
 var spec: Dictionary = SignalCards.DATA.get(last, {})
 var bg := Color(spec.stock) if stock and not spec.is_empty() else FriendlyLook.TONER
 var fg := Color(spec.accent) if stock and not spec.is_empty() else FriendlyLook.PAPER
 draw_rect(Rect2(Vector2.ZERO, size), bg)
 draw_rect(Rect2(Vector2.ONE, size - Vector2(2, 2)), fg, false, 1.0)
 if layers.is_empty(): return
 var cell := Vector2(size.x * 0.065, size.y * 0.084)
 var origin := Vector2(size.x * 0.17, size.y * 0.16)
 for corp in layers:
  var pattern: Array = SignalCards.DATA[corp].holes
  for row in pattern.size():
   for column in pattern[row]:
    draw_circle(origin + Vector2(column, row) * cell, cell.y * 0.35, fg)
 if stock and size.y > 45:
  var font := FriendlyLook.MONO
  draw_string(font, Vector2(8, size.y - 8), "%s · PAT. %s" % [spec.mark, spec.patent], HORIZONTAL_ALIGNMENT_LEFT, -1, 12, fg)
