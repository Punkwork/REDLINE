class_name FriendlyFace
extends Control
## Separate animated features, traced from the supplied 100×100 mascot SVG geometry.
var mood := "cheery"
var kind := "face"
var ink := Color("#1B2230")
var accent := Color("#7FD8BE")
var look := Vector2.ZERO
var features := {}
var blink := 1.0
var reduced_motion := false
var clock := 0.0
var next_blink := 4.0
var blink_end := 0.0
var cosmetic_rng := RandomNumberGenerator.new()
class Feature extends Control:
 var face: FriendlyFace
 var feature: String
 func _draw() -> void: face.draw_feature(self, feature)
func _ready() -> void:
 mouse_filter = Control.MOUSE_FILTER_IGNORE
 for name in ["shell", "eyes", "pupil", "brows", "mouth", "blush"]:
  var part := Feature.new(); part.face = self; part.feature = name; part.name = name.capitalize(); part.size = size; part.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(part); features[name] = part
 cosmetic_rng.seed=hash(kind+str(get_instance_id()))
 next_blink=cosmetic_rng.randf_range(3.0,6.0)
 redraw_features()
func _process(delta: float) -> void:
 if not is_visible_in_tree(): return
 clock+=delta
 if not reduced_motion and clock>=next_blink:
  blink_end=clock+0.12; next_blink=clock+cosmetic_rng.randf_range(3.0,6.0)
 var value := 0.08 if not reduced_motion and clock<blink_end else 1.0
 for feature in ["eyes","pupil"]:
  if features.has(feature): features[feature].pivot_offset=size/2; features[feature].scale.y=value
 redraw_features()
func redraw_features() -> void:
 for p in features.values(): p.queue_redraw()
func quad(a: Vector2, b: Vector2, c: Vector2) -> PackedVector2Array:
 var pts := PackedVector2Array()
 for i in 21:
  var t := i / 20.0; pts.append((1-t)*(1-t)*a + 2*(1-t)*t*b + t*t*c)
 return pts
func ellipse(center: Vector2, radius: Vector2) -> PackedVector2Array:
 var pts := PackedVector2Array()
 for i in 49:
  var a := i * TAU / 48; pts.append(center + Vector2(cos(a), sin(a)) * radius)
 return pts
func draw_feature(p: Control, feature: String) -> void:
 p.draw_set_transform(Vector2.ZERO, 0.0, size / 100.0)
 var hostile := mood == "lethal"
 var knocked := mood == "knocked_out"
 var color := FriendlyLook.RED if hostile else ink
 var watching := mood != "cheery"
 if feature == "shell" and kind == "lens":
  p.draw_circle(Vector2(50,50),46, Color("#140809") if hostile else Color("#C9D7FF"))
  p.draw_arc(Vector2(50,50),46,0,TAU,64,color,4,true)
  p.draw_circle(Vector2(50,50),28,ink)
  if watching: p.draw_circle(Vector2(80,20),6,FriendlyLook.RED)
 if feature == "shell" and kind == "eye":
  var eye := ellipse(Vector2(50,50), Vector2(42, 20 if watching else 30))
  p.draw_colored_polygon(eye, Color("#140809") if hostile else Color.WHITE); p.draw_polyline(eye,color,4,true)
 if feature == "eyes" and kind in ["face", "cookie", "house"]:
  if knocked:
   for x in [35,65]:
    p.draw_line(Vector2(x-6,44),Vector2(x+6,56),color,4,true); p.draw_line(Vector2(x+6,44),Vector2(x-6,56),color,4,true)
  elif watching or kind == "house":
   for x in [35,65]: p.draw_circle(Vector2(x + look.x*3,50 + look.y*3),5,color)
  else:
   p.draw_polyline(quad(Vector2(28,44),Vector2(35,34),Vector2(42,44)),color,5,true)
   p.draw_polyline(quad(Vector2(58,44),Vector2(65,34),Vector2(72,44)),color,5,true)
 if feature == "pupil" and kind in ["eye", "lens"]:
  var center := Vector2(50,50) + look * (9 if kind == "eye" else 12)
  var iris := FriendlyLook.RED if hostile else (FriendlyLook.AMBER if watching else (Color("#4A6CF7") if kind == "lens" else accent))
  if knocked:
   p.draw_line(center-Vector2(8,8),center+Vector2(8,8),color,4,true); p.draw_line(center-Vector2(-8,8),center+Vector2(-8,8),color,4,true)
  elif hostile and kind == "eye": p.draw_colored_polygon(ellipse(center,Vector2(4,17)),iris)
  else:
   p.draw_circle(center,16 if kind == "lens" else 17,iris)
   if kind == "eye": p.draw_circle(center,8,ink)
   p.draw_circle(center-Vector2(6,6),4,Color.WHITE)
 if feature == "brows" and watching:
  if kind == "eye": p.draw_line(Vector2(16,30),Vector2(84,42) if hostile else Vector2(84,23),color,5,true)
  elif kind in ["face", "cookie"]:
   p.draw_line(Vector2(22 if hostile else 26,32 if hostile else 38),Vector2(45,44 if hostile else 42),color,5,true)
   p.draw_line(Vector2(55,44 if hostile else 42),Vector2(78 if hostile else 74,32 if hostile else 38),color,5,true)
 if feature == "mouth" and kind != "house":
  if kind == "eye":
   if not watching: p.draw_polyline(quad(Vector2(18,80),Vector2(50,92),Vector2(82,80)),color,4,true)
  elif kind == "lens":
   if not watching: p.draw_polyline(quad(Vector2(34,82),Vector2(50,92),Vector2(66,82)),color,4,true)
  elif hostile:
   p.draw_polyline(PackedVector2Array([Vector2(28,72),Vector2(36,64),Vector2(44,72),Vector2(52,64),Vector2(60,72),Vector2(68,64),Vector2(74,70)]),color,5,true)
  elif watching or knocked: p.draw_line(Vector2(36,70),Vector2(64,68),color,5,true)
  else: p.draw_polyline(quad(Vector2(32,60),Vector2(50,80),Vector2(68,60)),color,5,true)
 if feature == "blush" and not watching and not knocked and kind in ["face", "cookie"]:
  p.draw_circle(Vector2(24,58),6,Color("#FF9FA8B3")); p.draw_circle(Vector2(76,58),6,Color("#FF9FA8B3"))
