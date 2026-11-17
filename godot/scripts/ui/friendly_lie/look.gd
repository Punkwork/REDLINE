class_name FriendlyLook
extends RefCounted
const TONER := Color("#111111")
const PAPER := Color("#F7F7F2")
const HIGHLIGHT := Color("#D6B675")
const RED := Color("#E5484D")
const GREY := Color("#A9A9A0")
const ENAMEL := Color("#EDF4F0")
const SLATE := Color("#20343B")
const MUTED_INK := Color("#465D64")
const SERVICE_TEAL := Color("#165B55")
const AMBER := Color("#E8B04A")
const MONO = preload("res://assets/fonts/SpaceMono-Regular.ttf")
const BOLD = preload("res://assets/fonts/SpaceMono-Bold.ttf")
const THEME = preload("res://themes/rustler.tres")
static func skin(corporation: String = "HALCYON") -> CorporationSkin:
 return load("res://themes/" + corporation.to_lower() + ".tres")
static func label(text: String, size: int = 14, color: Color = TONER, font: Font = MONO) -> Label:
 var l := Label.new()
 l.text = text
 l.add_theme_font_override("font", font)
 l.add_theme_font_size_override("font_size", size)
 l.add_theme_color_override("font_color", color)
 l.mouse_filter = Control.MOUSE_FILTER_IGNORE
 return l
static func style(bg: Color, border: Color = TONER, width: int = 0, radius: int = 0, shadow: int = 0) -> StyleBoxFlat:
 var s := StyleBoxFlat.new()
 s.bg_color = bg
 s.border_color = border
 s.set_border_width_all(width)
 s.set_corner_radius_all(radius)
 s.shadow_color = TONER
 s.shadow_size = 0
 if shadow > 0:
  s.shadow_size = shadow
  s.shadow_offset = Vector2(shadow, shadow)
 return s
static func panel(bg: Color, border: Color = TONER, width: int = 0, radius: int = 0, shadow: int = 0) -> Panel:
 var p := Panel.new()
 p.add_theme_stylebox_override("panel", style(bg, border, width, radius, shadow))
 return p
static func button(text: String, callback: Callable, bg: Color = HIGHLIGHT, ink: Color = TONER, radius: int = 0, font: Font = BOLD) -> Button:
 var b := Button.new()
 b.text = text
 b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
 b.add_theme_font_override("font", font)
 b.add_theme_font_size_override("font_size", 13)
 b.add_theme_color_override("font_color", ink)
 b.add_theme_color_override("font_hover_color", ink)
 b.add_theme_color_override("font_pressed_color", ink)
 b.add_theme_color_override("font_disabled_color", GREY)
 for state in ["normal", "hover", "pressed", "disabled"]:
  var fill := bg if state != "hover" else bg.lightened(0.08)
  var s := style(fill, TONER, 2 if radius == 0 else 0, radius)
  s.content_margin_left = 8; s.content_margin_right = 8
  s.content_margin_top = 4; s.content_margin_bottom = 4
  b.add_theme_stylebox_override(state, s)
 if callback.is_valid(): b.pressed.connect(callback)
 return b
