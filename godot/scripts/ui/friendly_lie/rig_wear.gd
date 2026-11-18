class_name FriendlyRigWear
extends Control
## Paint on the panel perimeter, behind all of its regular children.
const EDGE := preload("res://themes/adp_rig_wear.gdshader")
const BARS := [2,1,1,2,3,1,1,3,1,1,2,2,1,1,3,2,2,1,3,1,1,2,1,2]

var code_strip := false
var bleed := 0.0
var code_alpha := 0.0
var surface: ColorRect
var wear: ShaderMaterial

func _ready() -> void:
 mouse_filter = Control.MOUSE_FILTER_IGNORE
 var cfg: Dictionary = AtomicDecoPunk.settings.wear
 wear = ShaderMaterial.new()
 wear.shader = EDGE
 for key in ["edge_px","shadow_px","speckle_strength","edge_darkening","shadow_opacity"]:
  wear.set_shader_parameter(key, cfg[key])
 surface = ColorRect.new()
 surface.material = wear
 surface.mouse_filter = Control.MOUSE_FILTER_IGNORE
 add_child(surface, false, Node.INTERNAL_MODE_BACK)
 var panel := get_parent() as Control
 panel.resized.connect(fit)
 fit()

func fit() -> void:
 var panel := get_parent() as Control
 size = panel.size
 var shadow: float = AtomicDecoPunk.settings.wear.shadow_px
 surface.size = size + Vector2(shadow, shadow)
 wear.set_shader_parameter("panel_size", size)
 queue_redraw()

func update_wear(value: float, reduced: bool, seconds: float) -> void:
 var cfg: Dictionary = AtomicDecoPunk.settings.wear
 var alpha: float = cfg.code_opacity
 if code_strip and not reduced and value > float(cfg.flicker_start):
  alpha *= 1.0 - float(cfg.flicker_strength) * value * (0.5 + 0.5 * sin(TAU * float(cfg.flicker_hz) * seconds))
 if value == bleed and alpha == code_alpha: return
 bleed = value
 code_alpha = alpha
 wear.set_shader_parameter("bleed", bleed)
 queue_redraw()

func _draw() -> void:
 var cfg: Dictionary = AtomicDecoPunk.settings.wear
 if bleed > 0.0:
  var tape := Color("#D6B675")
  tape.a = cfg.tape_opacity * bleed
  var w: float = cfg.tape_width_px
  var h: float = cfg.tape_height_px
  var x := size.x - w
  # Outside the lower edge so neither the tape nor the lifted fold crosses text.
  draw_colored_polygon(PackedVector2Array([Vector2(x,size.y), Vector2(size.x,size.y), Vector2(size.x+3,size.y+h), Vector2(x+2,size.y+h-1)]),tape)
  var fold := tape.lightened(0.38)
  draw_colored_polygon(PackedVector2Array([Vector2(size.x-6,size.y),Vector2(size.x,size.y),Vector2(size.x+3,size.y+h)]),fold)
 if code_strip:
  var x := 12.0
  var rail := Color("#191616")
  rail.a = code_alpha
  draw_rect(Rect2(x-3,-9,62,9),rail)
  var toner := Color("#F5E8CA")
  toner.a = code_alpha
  for i in BARS.size():
   if i % 2 == 0: draw_rect(Rect2(x,-7,BARS[i],5),toner)
   x += BARS[i]
