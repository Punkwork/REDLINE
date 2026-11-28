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
 # SIGNAL-002 (PROPOSED art, designer review in a UI issue): a barcode, not punched holes. Several layers
 # overlay into one strip, so the three corporations' barcodes together show the whole Signal.
 var left := size.x * 0.08
 var module := (size.x - left * 2.0) / float(SignalCards.MODULES)
 var top := size.y * 0.14
 var bottom := size.y * (0.70 if stock and size.y > 45 and size.x >= 140 else 0.86)
 for bar in SignalCards.bars_for(layers):
  draw_rect(Rect2(left + float(bar[0]) * module, top, maxf(1.0, float(bar[1]) * module), bottom - top), fg)
 var caption := "%s · PAT. %s" % [spec.mark, spec.patent] if not spec.is_empty() else ""
 if stock and size.y > 45 and FriendlyLook.MONO.get_string_size(caption, HORIZONTAL_ALIGNMENT_LEFT, -1, 12).x <= size.x - 16:
  draw_string(FriendlyLook.MONO, Vector2(8, size.y - 8), caption, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, fg)
