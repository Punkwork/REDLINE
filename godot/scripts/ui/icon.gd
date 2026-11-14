class_name RIcon
extends Control
## Code-drawn placeholder icons (ICE Design doc: icon = type, chip colour = effect, every colour paired with an icon and a word).

const COL := {
	"PULP": Color("#ff4d5e"), "CORTEX": Color("#a66bff"), "TRACE": Color("#ffb020"), "DEADLOCK": Color("#f2f2f2"),
	"TEAL": Color("#2fd3c4"), "SLATE": Color("#8aa0b8"), "HALCYON": Color("#ffb38a"),
	"BW": Color("#4fd2ff"), "VITAE": Color("#ff4d5e"), "SHIELD": Color("#5aa8ff"), "CRED": Color("#ffd34d"),
	"RAM": Color("#9ad17a"), "FORTRESS": Color("#c9d3df"), "TUMBLER": Color("#c9d3df"), "VOID": Color("#a66bff"),
	"ANY": Color("#c9d3df"), "CLOAK": Color("#7fb6ff"), "EXPLOIT": Color("#ff8a4d"), "NULREM": Color("#58f29a"),
}

var kind := "BW"
var color := Color.WHITE
var thick := 2.0

static func make(k: String, size_px: float = 22.0, c: Color = Color(0, 0, 0, 0)) -> RIcon:
	var ic := RIcon.new()
	ic.kind = k
	ic.color = c if c.a > 0.0 else COL.get(k, Color.WHITE)
	ic.custom_minimum_size = Vector2(size_px, size_px)
	ic.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return ic

func _draw() -> void:
	var s: float = min(size.x, size.y)
	var o := (size - Vector2(s, s)) / 2.0
	var c := color
	var w: float = max(1.5, s / 11.0)
	match kind:
		"FORTRESS":
			# stacked slab
			for i in 3:
				var y := o.y + s * (0.18 + i * 0.24)
				var inset := s * (0.08 + (2 - i) * 0.06)
				draw_rect(Rect2(o.x + inset, y, s - inset * 2, s * 0.18), c, false, w)
		"TUMBLER":
			# lock cylinder: rotation arrow ring, five pin tumblers, keyway
			var tc := o + Vector2(s / 2, s / 2)
			draw_arc(tc, s * 0.42, -PI * 0.3, PI * 1.45, 28, c, w)
			var tip := tc + Vector2(cos(-PI * 0.3), sin(-PI * 0.3)) * s * 0.42
			draw_colored_polygon(PackedVector2Array([tip + Vector2(-s * 0.13, -s * 0.06), tip + Vector2(s * 0.07, -s * 0.07), tip + Vector2(-s * 0.02, s * 0.13)]), c)
			for k in 5:
				var a := -PI / 2 + k * TAU / 5
				draw_circle(tc + Vector2(cos(a), sin(a)) * s * 0.24, s * 0.055, c)
			draw_rect(Rect2(tc.x - s * 0.035, tc.y - s * 0.09, s * 0.07, s * 0.18), c)
		"HIDDEN":
			# face-down subroutine
			draw_rect(Rect2(o + Vector2(s * 0.15, s * 0.1), Vector2(s * 0.7, s * 0.8)), c, false, w)
			draw_line(o + Vector2(s * 0.15, s * 0.1), o + Vector2(s * 0.85, s * 0.9), c, w * 0.6)
			draw_line(o + Vector2(s * 0.85, s * 0.1), o + Vector2(s * 0.15, s * 0.9), c, w * 0.6)
		"VOID":
			# eye
			var cen := o + Vector2(s / 2, s / 2)
			draw_arc(cen + Vector2(0, s * 0.32), s * 0.5, PI * 1.22, PI * 1.78, 20, c, w)
			draw_arc(cen - Vector2(0, s * 0.32), s * 0.5, PI * 0.22, PI * 0.78, 20, c, w)
			draw_circle(cen, s * 0.13, c)
		"ANY":
			draw_arc(o + Vector2(s / 2, s / 2), s * 0.42, 0, TAU, 6, c, w)
			draw_circle(o + Vector2(s / 2, s / 2), s * 0.12, c)
		"PULP":
			var tip := o + Vector2(s / 2, s * 0.08)
			draw_colored_polygon(PackedVector2Array([tip, o + Vector2(s * 0.22, s * 0.58), o + Vector2(s * 0.78, s * 0.58)]), c)
			draw_circle(o + Vector2(s / 2, s * 0.62), s * 0.29, c)
		"CORTEX":
			var cc := o + Vector2(s / 2, s / 2)
			for r in [0.42, 0.28, 0.14]:
				draw_arc(cc, s * r, 0.4, TAU - 0.4, 24, c, w)
		"TRACE":
			var base := o + Vector2(s * 0.2, s * 0.8)
			for r in [0.25, 0.45, 0.65]:
				draw_arc(base, s * r, -PI / 2, 0, 16, c, w)
			draw_circle(base, s * 0.08, c)
		"DEADLOCK":
			draw_arc(o + Vector2(s / 2, s * 0.42), s * 0.2, PI, TAU, 16, c, w)
			draw_rect(Rect2(o.x + s * 0.2, o.y + s * 0.42, s * 0.6, s * 0.46), c)
			draw_circle(o + Vector2(s / 2, s * 0.63), s * 0.06, Color.BLACK)
		"UNLOCK":
			draw_arc(o + Vector2(s * 0.62, s * 0.36), s * 0.2, PI, TAU, 16, c, w)
			draw_rect(Rect2(o.x + s * 0.2, o.y + s * 0.42, s * 0.6, s * 0.46), c, false, w)
		"CARD":
			draw_rect(Rect2(o.x + s * 0.24, o.y + s * 0.1, s * 0.52, s * 0.8), c, false, w)
			draw_line(o + Vector2(s * 0.34, s * 0.3), o + Vector2(s * 0.66, s * 0.3), c, w)
		"STR":
			draw_colored_polygon(PackedVector2Array([o + Vector2(s / 2, s * 0.1), o + Vector2(s * 0.85, s * 0.55), o + Vector2(s * 0.15, s * 0.55)]), c)
			draw_rect(Rect2(o.x + s * 0.38, o.y + s * 0.55, s * 0.24, s * 0.35), c)
		"BW":
			draw_colored_polygon(PackedVector2Array([o + Vector2(s * 0.58, s * 0.04), o + Vector2(s * 0.2, s * 0.56), o + Vector2(s * 0.48, s * 0.56), o + Vector2(s * 0.38, s * 0.96), o + Vector2(s * 0.8, s * 0.4), o + Vector2(s * 0.52, s * 0.4)]), c)
		"VITAE":
			draw_circle(o + Vector2(s * 0.33, s * 0.36), s * 0.2, c)
			draw_circle(o + Vector2(s * 0.67, s * 0.36), s * 0.2, c)
			draw_colored_polygon(PackedVector2Array([o + Vector2(s * 0.14, s * 0.44), o + Vector2(s * 0.86, s * 0.44), o + Vector2(s / 2, s * 0.9)]), c)
		"SHIELD":
			draw_colored_polygon(PackedVector2Array([o + Vector2(s / 2, s * 0.06), o + Vector2(s * 0.88, s * 0.2), o + Vector2(s * 0.8, s * 0.62), o + Vector2(s / 2, s * 0.94), o + Vector2(s * 0.2, s * 0.62), o + Vector2(s * 0.12, s * 0.2)]), c)
		"CRED":
			draw_circle(o + Vector2(s / 2, s / 2), s * 0.42, c)
			draw_arc(o + Vector2(s / 2, s / 2), s * 0.22, 0.6, TAU - 0.6, 16, Color(0.1, 0.08, 0.02), w)
		"RAM":
			draw_rect(Rect2(o.x + s * 0.22, o.y + s * 0.22, s * 0.56, s * 0.56), c, false, w)
			for i in 3:
				var t := s * (0.32 + i * 0.18)
				draw_line(o + Vector2(t, s * 0.06), o + Vector2(t, s * 0.22), c, w)
				draw_line(o + Vector2(t, s * 0.78), o + Vector2(t, s * 0.94), c, w)
		"DRAW":
			for i in 3:
				draw_rect(Rect2(o.x + s * (0.12 + i * 0.12), o.y + s * (0.3 - i * 0.1), s * 0.5, s * 0.62), c, false, w)
		"CLOAK":
			draw_arc(o + Vector2(s / 2, s * 0.6), s * 0.38, PI, TAU, 20, c, w)
			draw_line(o + Vector2(s * 0.12, s * 0.6), o + Vector2(s * 0.88, s * 0.6), c, w)
			draw_circle(o + Vector2(s * 0.38, s * 0.48), s * 0.05, c)
			draw_circle(o + Vector2(s * 0.62, s * 0.48), s * 0.05, c)
		"EXPLOIT":
			draw_polyline(PackedVector2Array([o + Vector2(s * 0.3, s * 0.1), o + Vector2(s * 0.55, s * 0.45), o + Vector2(s * 0.4, s * 0.55), o + Vector2(s * 0.7, s * 0.92)]), c, w * 1.4)
		"NULREM":
			draw_rect(Rect2(o.x + s * 0.08, o.y + s * 0.16, s * 0.84, s * 0.64), c, false, w)
			draw_rect(Rect2(o.x + s * 0.26, o.y + s * 0.34, s * 0.12, s * 0.16), c)
			draw_rect(Rect2(o.x + s * 0.62, o.y + s * 0.34, s * 0.12, s * 0.16), c)
			draw_line(o + Vector2(s * 0.34, s * 0.64), o + Vector2(s * 0.66, s * 0.64), c, w)
		"SAFEHOUSE":
			draw_colored_polygon(PackedVector2Array([o + Vector2(s / 2, s * 0.1), o + Vector2(s * 0.9, s * 0.48), o + Vector2(s * 0.1, s * 0.48)]), c)
			draw_rect(Rect2(o.x + s * 0.22, o.y + s * 0.48, s * 0.56, s * 0.42), c, false, w)
		"ICE":
			draw_colored_polygon(PackedVector2Array([o + Vector2(s / 2, s * 0.06), o + Vector2(s * 0.92, s / 2), o + Vector2(s / 2, s * 0.94), o + Vector2(s * 0.08, s / 2)]), c)
		_:
			draw_circle(o + Vector2(s / 2, s / 2), s * 0.3, c)
