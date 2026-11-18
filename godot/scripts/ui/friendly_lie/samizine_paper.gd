class_name SamizinePaper
extends Control

const PAGE := Color("#EEF0E6")
const CARBON := Color("#23277A")
const DITTO := Color("#6A2C9A")
const MARKER := Color("#B3262B")
const TYPEWRITER = preload("res://assets/fonts/SpecialElite-Regular.ttf")
const STENCIL = preload("res://assets/fonts/StardosStencil-Regular.ttf")
const MARKER_FONT = preload("res://assets/fonts/PermanentMarker-Regular.ttf")
const CUT_OUT = preload("res://assets/fonts/PoiretOne-Regular.ttf")
const STOCK := [Color("#7FD8BE"), Color("#C9B6F2"), Color("#F2C14E"), Color("#FFE3D3")]

var generation: int

func _init(copy: int) -> void:
 generation = copy
 mouse_filter = Control.MOUSE_FILTER_IGNORE
 resized.connect(queue_redraw)

func _draw() -> void:
 var w := size.x
 var h := size.y
 var wear := 0.06 + generation * 0.017
 draw_colored_polygon(PackedVector2Array([
  Vector2(3, 4), Vector2(w * 0.48, 0), Vector2(w - 12, 3), Vector2(w, 17),
  Vector2(w - 2, h - 7), Vector2(w * 0.68, h), Vector2(7, h - 3)
 ]), PAGE)
 for inset in range(4, 15):
  var ink := Color(0.22, 0.17, 0.11, wear / 11.0)
  draw_rect(Rect2(inset, inset, w - 2 * inset, h - 2 * inset), ink, false, 1.0)
 for y in [h * 0.2, h * 0.5, h * 0.8]:
  draw_circle(Vector2(23, y + 0.75), 6.5, Color("#8E8B80"))
  draw_circle(Vector2(22, y), 5.25, Color("#C1BCAF"))
 # The folds stop at the live content area.
 for offset in range(-3, 4):
  var ink := Color(0.21, 0.20, 0.16, wear * (1.0 - absf(offset) / 4.0))
  var x := w * 0.51 + offset
  var y := h * 0.5 + offset
  draw_line(Vector2(x, 2), Vector2(x, 32), ink)
  draw_line(Vector2(x, h - 37), Vector2(x, h - 3), ink)
  draw_line(Vector2(2, y), Vector2(38, y), ink)
  draw_line(Vector2(w - 38, y), Vector2(w - 2, y), ink)
 var barcode_x := w - 108.0
 for width in [1, 4, 2, 5, 1, 3, 6, 2, 3, 1, 5]:
  draw_rect(Rect2(barcode_x, h - 35, width, 17), FriendlyLook.TONER)
  barcode_x += width + 2
 draw_string(FriendlyLook.MONO, Vector2(58, h - 22), "TOMORROW, TOGETHER.", HORIZONTAL_ALIGNMENT_LEFT, -1, 11, Color(0.14, 0.15, 0.47, wear))

static func masthead(text: String) -> HBoxContainer:
 var title := HBoxContainer.new()
 title.add_theme_constant_override("separation", 5)
 for index in text.length():
  var letter := text[index]
  var cell := Control.new()
  cell.custom_minimum_size = Vector2(14 if letter == " " else 35, 50)
  title.add_child(cell)
  if letter == " ": continue
  var tile := FriendlyLook.panel(STOCK[index % STOCK.size()])
  tile.size = Vector2(34, 45)
  tile.position.y = 3
  tile.pivot_offset = Vector2(17, 22)
  tile.rotation_degrees = [-4.0, 3.0, -2.0, 4.0][index % 4]
  tile.mouse_filter = Control.MOUSE_FILTER_IGNORE
  cell.add_child(tile)
  var font: Font = [CUT_OUT, STENCIL, TYPEWRITER][index % 3]
  var glyph := FriendlyLook.label(letter, 32, FriendlyLook.TONER, font)
  glyph.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
  glyph.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
  tile.add_child(glyph)
  glyph.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 return title
