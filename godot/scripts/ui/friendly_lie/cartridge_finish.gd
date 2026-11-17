class_name CartridgeFinish
extends Control
## A restrained physical finish, orthogonal to the authored card type/rarity.
var rarity:="COMMON"
func _ready() -> void: mouse_filter=Control.MOUSE_FILTER_IGNORE
func _draw() -> void:
 var level:=3 if rarity=="RARE" else (2 if rarity=="UNCOMMON" else 1)
 var metal:=Color("#B59A65") if level>1 else Color("#A5ADAA")
 # One/two/three engraved indexing notches: readable without relying on hue.
 for i in level:
  draw_line(Vector2(1,179+i*5),Vector2(6,179+i*5),Color("#29383B"),2,true)
  draw_line(Vector2(1,181+i*5),Vector2(6,181+i*5),metal,1,true)
 if level>=2:
  draw_style_box(FriendlyLook.style(metal,Color("#574B39"),1,1),Rect2(150,198,7,8))
 if level==3:
  draw_line(Vector2(151,66),Vector2(151,193),Color("#D7E4E2"),1,true)
  draw_line(Vector2(153,66),Vector2(153,193),Color("#6B7E80"),1,true)
  draw_circle(Vector2(153.5,202),1.8,Color("#263A3C"))
