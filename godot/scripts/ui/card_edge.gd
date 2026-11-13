extends StyleBox
## Card frame with a distinct edge for each card owner (data/visuals.json → owners.<id>.edge):
##
##   plain     SHARED       rounded border
##   brackets  GENERALIST   thin frame with heavy corner brackets (a toolkit)
##   glow      ECHO         thin, very rounded, soft halo (quiet)
##   hazard    RIOT         thick, cut corners, hazard stripes across the top (loud)
##   spores    VECTOR       rounded, with spores budding along the edge (infection)
##   glitch    CORPORATION  broken, dashed edge with misaligned slices (Bloatware)
##
## Used as a Button / PanelContainer stylebox. `state` is "normal", "hover", "pressed" or "disabled".

const BG := Color("151a23")

var edge := "plain"
var color := Color.WHITE
var state := "normal"
var selected := false


## top_margin: 30 leaves room for a card's type icon and owner emblem; use ~8 for plain buttons.
static func make(edge_name: String, edge_color: Color, edge_state := "normal", is_selected := false, top_margin := 30) -> StyleBox:
	var s = load("res://scripts/ui/card_edge.gd").new()
	s.content_margin_top = top_margin
	s.edge = edge_name
	s.color = edge_color
	s.state = edge_state
	s.selected = is_selected
	return s


func _init() -> void:
	content_margin_left = 10
	content_margin_right = 10
	content_margin_top = 30       # room for the type icon and owner emblem
	content_margin_bottom = 10


func _draw(to_canvas_item: RID, rect: Rect2) -> void:
	if rect.size.x < 24 or rect.size.y < 24:
		return      # not laid out yet
	var rs := RenderingServer
	var bg := BG
	var line := color
	match state:
		"hover":
			bg = BG.lightened(0.12)
		"pressed":
			bg = BG.lightened(0.2)
		"disabled":
			bg = BG.darkened(0.25)
			line = Color(color, 0.4)
	if selected:
		bg = bg.lerp(color, 0.12)
	# A faint wash of the owner colour so cards are recognisable at a glance.
	var wash := bg.lerp(color, 0.06 if state != "disabled" else 0.03)

	match edge:
		"brackets":
			var pts := _rounded(rect, 3)
			rs.canvas_item_add_polygon(to_canvas_item, pts, [wash])
			_outline(to_canvas_item, pts, Color(line, line.a * 0.45), 1.0)
			var l: float = min(18.0, rect.size.x * 0.2)
			var w := 3.5
			var p := rect.grow(-1)
			for c in [[p.position, Vector2(1, 1)], [Vector2(p.end.x, p.position.y), Vector2(-1, 1)],
					[p.end, Vector2(-1, -1)], [Vector2(p.position.x, p.end.y), Vector2(1, -1)]]:
				var o: Vector2 = c[0]
				var d: Vector2 = c[1]
				rs.canvas_item_add_polyline(to_canvas_item, PackedVector2Array([o + Vector2(0, d.y * l), o, o + Vector2(d.x * l, 0)]),
						[line], w, true)
		"glow":
			var pts := _rounded(rect, 12)
			if state != "disabled":
				for i in 3:
					_outline(to_canvas_item, _rounded(rect.grow(2.0 + i * 2.5), 12 + 2 + i * 2.5), Color(line, 0.22 - i * 0.06), 2.5)
			rs.canvas_item_add_polygon(to_canvas_item, pts, [wash])
			_outline(to_canvas_item, pts, line, 1.5)
		"hazard":
			var pts := _chamfer(rect, 11)
			rs.canvas_item_add_polygon(to_canvas_item, pts, [wash])
			# Hazard stripes along the top edge.
			var band := Rect2(rect.position + Vector2(12, 3), Vector2(rect.size.x - 24, 6))
			var x := band.position.x
			var stripe := 7.0
			var on := true
			while x < band.end.x:
				if on and band.end.x - x > 4:
					var x2: float = min(x + stripe, band.end.x - 1)
					rs.canvas_item_add_polygon(to_canvas_item, PackedVector2Array([
							Vector2(x, band.end.y), Vector2(x + 3, band.position.y),
							Vector2(min(x2 + 3, band.end.x), band.position.y), Vector2(x2, band.end.y)]),
							[Color(line, line.a * 0.8)])
				x += stripe
				on = not on
			_outline(to_canvas_item, pts, line, 3.0)
		"spores":
			var pts := _rounded(rect, 9)
			rs.canvas_item_add_polygon(to_canvas_item, pts, [wash])
			_outline(to_canvas_item, pts, line, 2.0)
			# Spores budding off the edge at irregular but fixed spots.
			var perimeter := _closed(pts)
			var total := _length(perimeter)
			var t := 0.07
			var i := 0
			while t < 1.0:
				var at := _point_at(perimeter, total * t)
				var out := (at - rect.get_center()).normalized() * 1.5
				rs.canvas_item_add_circle(to_canvas_item, at + out, 4.0 if i % 3 == 0 else 2.6, line)
				t += 0.11 if i % 2 == 0 else 0.07
				i += 1
		"glitch":
			var pts := _rounded(rect, 2)
			rs.canvas_item_add_polygon(to_canvas_item, pts, [wash.darkened(0.15)])
			_dashed(to_canvas_item, _closed(pts), line, 2.0, 9.0, 5.0)
			# Misaligned slices, as if the frame failed to render.
			var y1 := rect.position.y + rect.size.y * 0.32
			var y2 := rect.position.y + rect.size.y * 0.71
			rs.canvas_item_add_line(to_canvas_item, Vector2(rect.position.x - 4, y1), Vector2(rect.position.x + rect.size.x * 0.35, y1),
					Color("4dd0e1", line.a * 0.7), 2.0)
			rs.canvas_item_add_line(to_canvas_item, Vector2(rect.end.x - rect.size.x * 0.45, y2), Vector2(rect.end.x + 4, y2),
					Color(line, line.a * 0.8), 2.0)
		_:
			var pts := _rounded(rect, 5)
			rs.canvas_item_add_polygon(to_canvas_item, pts, [wash])
			_outline(to_canvas_item, pts, line, 2.0)
	if selected:
		_outline(to_canvas_item, _rounded(rect.grow(4), 8), Color(color, 0.9), 2.0)


# ------------------------------------------------------------------ geometry helpers

func _rounded(r: Rect2, radius: float, seg := 5) -> PackedVector2Array:
	radius = min(radius, min(r.size.x, r.size.y) * 0.5)
	var pts := PackedVector2Array()
	var centers := [Vector2(r.end.x - radius, r.position.y + radius), Vector2(r.end.x - radius, r.end.y - radius),
			Vector2(r.position.x + radius, r.end.y - radius), Vector2(r.position.x + radius, r.position.y + radius)]
	for k in 4:
		var start := -PI / 2 + k * PI / 2
		for s in seg + 1:
			var a: float = start + (PI / 2) * float(s) / seg
			pts.append(centers[k] + Vector2(cos(a), sin(a)) * radius)
	return pts


func _chamfer(r: Rect2, c: float) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(r.position.x + c, r.position.y), Vector2(r.end.x - c, r.position.y), Vector2(r.end.x, r.position.y + c),
		Vector2(r.end.x, r.end.y - c), Vector2(r.end.x - c, r.end.y), Vector2(r.position.x + c, r.end.y),
		Vector2(r.position.x, r.end.y - c), Vector2(r.position.x, r.position.y + c)])


func _closed(pts: PackedVector2Array) -> PackedVector2Array:
	var out := pts.duplicate()
	out.append(pts[0])
	return out


func _outline(item: RID, pts: PackedVector2Array, col: Color, width: float) -> void:
	RenderingServer.canvas_item_add_polyline(item, _closed(pts), [col], width, true)


func _length(pts: PackedVector2Array) -> float:
	var total := 0.0
	for i in pts.size() - 1:
		total += pts[i].distance_to(pts[i + 1])
	return total


func _point_at(pts: PackedVector2Array, dist: float) -> Vector2:
	for i in pts.size() - 1:
		var seg := pts[i].distance_to(pts[i + 1])
		if dist <= seg:
			return pts[i].lerp(pts[i + 1], dist / max(seg, 0.001))
		dist -= seg
	return pts[pts.size() - 1]


func _dashed(item: RID, pts: PackedVector2Array, col: Color, width: float, dash: float, gap: float) -> void:
	var total := _length(pts)
	var d := 0.0
	while d < total:
		var a := _point_at(pts, d)
		var b := _point_at(pts, min(d + dash, total))
		RenderingServer.canvas_item_add_line(item, a, b, col, width, true)
		d += dash + gap
