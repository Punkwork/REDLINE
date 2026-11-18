class_name GraftArt
extends Control

const PAPER := Color("#E5D6AD")

func _draw() -> void:
 var center := size / 2.0
 var radius := minf(minf(size.y / 2.0 - 2.0, size.x / 4.0), 18.0)
 var span := minf(46.0, size.x / 2.0 - 1.0)
 draw_line(center - Vector2(span, 0), center + Vector2(span, 0), PAPER, 1.0)
 draw_line(center + Vector2(-span * 0.8, -6), center + Vector2(span * 0.8, 6), PAPER, 1.0)
 if name == "AUTO_RENEW":
  draw_rect(Rect2(center - Vector2(radius, radius) * 0.7, Vector2(radius, radius) * 1.4), PAPER)
  for offset in [-0.4, 0, 0.4]:
   for side in [-1, 1]:
    var pin := center + Vector2(radius * offset, side * radius)
    draw_line(pin, pin - Vector2(0, side * radius * 0.4), PAPER, 1.0)
 else:
  var width := radius * (1.9 if name == "CAPTCHA" else 1.0)
  draw_set_transform(center, 0.0, Vector2(width / radius, 1.0))
  draw_circle(Vector2.ZERO, radius, PAPER)
  draw_circle(Vector2.ZERO, radius * 0.68, FriendlyLook.TONER)
  draw_circle(Vector2.ZERO, radius * 0.33, PAPER)
  draw_circle(Vector2(-radius * 0.2, -radius * 0.22), radius * 0.13, Color.WHITE)
