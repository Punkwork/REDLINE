class_name ChromeFrame
extends Control
## Pure presentation: layered silver fillets, enamel and small Deco ribs.
var radius:=20
var enamel:=Color("#E7F1EE")
var hostile:=false
var credit_card:=false
func _ready() -> void:
 mouse_filter=Control.MOUSE_FILTER_IGNORE
 queue_redraw()
func _draw() -> void:
 var bounds:=Rect2(Vector2.ZERO,size)
 var silver: Array[Color]=[Color("#34474D"),Color("#F7FFFF"),Color("#70888E"),Color("#F6FFFF"),Color("#A1B6B9"),Color("#FFFFFF")]
 for inset in silver.size():
  var style:=FriendlyLook.style(enamel,silver[inset],1,maxi(0,radius-inset))
  draw_style_box(style,bounds.grow(-inset))
 var inner:=FriendlyLook.style(Color("#170D12") if hostile else enamel,Color("#ED535E") if hostile else Color("#9DAFAF"),1,maxi(0,radius-7))
 draw_style_box(inner,bounds.grow(-7))
 # Highlights are confined to the rim. Decorative speed lines occupy the blank edge.
 var left:=Vector2(13,10); var right:=Vector2(size.x-13,10)
 draw_line(left,right,Color("#FFFFFFCC"),1,true)
 for row in 3:
  var y:=size.y-15+row*3
  draw_line(Vector2(16,y),Vector2(42+row*5,y),Color("#E5484D") if hostile else Color("#7B969A"),1,true)
 if credit_card:
  # A modest Deco fan in an otherwise empty corner of the credit card.
  var origin:=Vector2(size.x-24,size.y-24)
  for ray in 6:
   var angle: float=PI+float(ray)*PI/10
   draw_line(origin,origin+Vector2(cos(angle),sin(angle))*27,Color("#96BCB566"),1,true)
