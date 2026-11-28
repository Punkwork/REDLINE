class_name NodeMapScreen
extends Control
## MAP-003f: the corporation map on the HALCYON map board (BG_MAP_HALCYON.png, unchanged). The map is
## Game.map_rows (the validated V5 generator's output, tools/map/export_maps.py), drawn left to right:
## one column per row, its Nodes stacked, links drawn as inked paths. Visited Nodes are filled, the
## Nodes you can enter now glow and can be clicked or focused + Enter; the rest are shown but locked.
## Hover or focus opens the shared inspector with the Node's type and what lies in it. Presentation
## only: entering a Node is one Game call (enter_node). Positions are fitted to the board for review.

signal node_chosen(index: int)

const REF := Vector2(1586, 992)                       ## the board's own size
const BG := "res://assets/concept/backgrounds/BG_MAP_HALCYON.png"
const AREA := Rect2(200, 205, 1110, 585)              ## the parchment inside the painted borders
const PIN := 44.0
const INK := Color("#5A3E28")
const KIND_COL := {"ICE": Color("#C8452F"), "UPLINK": Color("#2E8C8A"), "SAFEHOUSE": Color("#3E8E5A"),
	"DEAD DROP": Color("#6E5A9A"), "CONSOLE LAB": Color("#B8921E"), "SIGNAL": Color("#7A7A7A")}
const KIND_TEXT := {"ICE": "ICE Node: an encounter with the corporation's ICE.",
	"UPLINK": "Black Market Uplink: buy cards and CAPS; the Clinic removes CORTEX.",
	"SAFEHOUSE": "SAFEHOUSE: recover VITAE.",
	"DEAD DROP": "DEAD DROP: its services are not in this build yet.",
	"CONSOLE LAB": "Console Lab: its services are not in this build yet.",
	"SIGNAL": "SIGNAL (unclear): its services are not in this build yet."}

var game: Game
var stage: Control
var board: Board
var inspector: KeyInspector
var pins: Array = []        # [[Pin]] per row
var title: Label

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var back := ColorRect.new(); back.color = Color.BLACK; back.set_anchors_preset(Control.PRESET_FULL_RECT); add_child(back)
	stage = Control.new(); stage.name = "Stage"; stage.size = REF; stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(stage)
	var bg := TextureRect.new(); bg.name = "Board"; bg.texture = load(BG); bg.size = REF
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(bg)
	board = Board.new(); board.name = "Links"; board.size = REF; board.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(board)
	title = Label.new(); title.name = "Title"; title.position = Vector2(AREA.position.x, AREA.position.y - 62); title.size = Vector2(AREA.size.x, 48)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_override("font", VasTokens.FONT_PLAQUE); title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", INK)
	stage.add_child(title)
	inspector = KeyInspector.new(); inspector.name = "Inspector"; add_child(inspector)
	get_viewport().size_changed.connect(_fit)
	_fit()

func _fit() -> void:
	var vp := get_viewport_rect().size
	var k := minf(vp.x / REF.x, vp.y / REF.y)
	stage.scale = Vector2(k, k)
	stage.position = (vp - REF * k) / 2.0

func attach(g: Game) -> void:
	game = g
	_build()
	refresh()

## Where Node i of row r sits: rows spread across the board, a row's Nodes centred vertically.
func pin_pos(r: int, i: int) -> Vector2:
	var rows := game.map_rows.size()
	var n: int = game.map_rows[r].size()
	var x := AREA.position.x + (AREA.size.x * (r + 0.5) / rows)
	var gap := minf(150.0, AREA.size.y / maxf(1.0, n))
	var y := AREA.position.y + AREA.size.y / 2.0 + (i - (n - 1) / 2.0) * gap
	return Vector2(x, y)

func _build() -> void:
	for row in pins:
		for p in row: p.queue_free()
	pins.clear()
	for r in game.map_rows.size():
		var row := []
		for i in game.map_rows[r].size():
			var n: Dictionary = game.map_rows[r][i]
			var p := Pin.new(); p.name = "Node_%s" % String(n.id)
			p.inspector = inspector; p.node = n; p.row = r; p.index = i
			p.size = Vector2(PIN, PIN) * (1.35 if n.get("central", false) else 1.0)
			p.position = pin_pos(r, i) - p.size / 2.0
			var idx: int = i
			p.chosen.connect(func(): node_chosen.emit(idx))
			stage.add_child(p)
			row.append(p)
		pins.append(row)

func refresh() -> void:
	if game == null: return
	if pins.size() != game.map_rows.size(): _build()
	title.text = "HALCYON NETWORK  ·  ROW %d OF %d" % [mini(game.row + 2, game.map_rows.size()), game.map_rows.size()]
	var links := []
	for r in game.map_rows.size() - 1:
		for i in game.map_rows[r].size():
			for j in game.map_rows[r][i].next:
				var a: String = String(game.map_rows[r][i].id)
				var b: String = String(game.map_rows[r + 1][j].id)
				links.append({"from": pin_pos(r, i), "to": pin_pos(r + 1, j), "walked": game.path.has(a) and game.path.has(b)})
	board.links = links
	board.queue_redraw()
	for r in pins.size():
		for p in pins[r]:
			p.visited = game.path.has(String(p.node.id))
			p.open = game.phase == "MAP" and r == game.row + 1 and game.available.has(p.index)
			p.refresh_title()

## The links between Nodes, as inked paths; walked ones heavier.
class Board extends Control:
	var links: Array = []
	func _draw() -> void:
		for l in links:
			var col := Color(NodeMapScreen.INK, 0.85 if l.walked else 0.35)
			var w := 4.0 if l.walked else 2.0
			var a: Vector2 = l.from
			var b: Vector2 = l.to
			var steps := int(a.distance_to(b) / 10.0)
			for k in steps:
				if k % 2 == 1 and not l.walked: continue   # dashed until walked
				draw_line(a.lerp(b, float(k) / steps), a.lerp(b, float(k + 1) / steps), col, w, true)

## One Node: an enamel pin with the Node type's glyph. Open Nodes glow and can be entered.
class Pin extends HudWidgets.Explained:
	signal chosen
	var node: Dictionary = {}
	var row := 0
	var index := 0
	var visited := false
	var open := false
	var t := 0.0
	func refresh_title() -> void:
		var kind := String(node.get("kind", ""))
		title = String(node.get("name", kind))
		heading = "BOSS · CENTRAL NODE" if node.get("central", false) else ("MINI-BOSS" if node.get("miniboss", false) else kind)
		lines = [String(NodeMapScreen.KIND_TEXT.get(kind, ""))]
		if kind == "ICE":
			for L in node.get("layers", []):
				lines.append("ICE: " + " + ".join((L.ice as Array).map(func(x): return IceDB.def(x).name)))
		lines.append("Visited." if visited else ("Open: click or press Enter to go here." if open else "Not reachable from where you are."))
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if open else Control.CURSOR_HELP
		set_process(open)
		queue_redraw()
	func _process(d: float) -> void:
		t += d
		queue_redraw()
	func _gui_input(e: InputEvent) -> void:
		if not open: return
		if (e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and e.pressed) or e.is_action_pressed("ui_accept"):
			accept_event(); chosen.emit()
	func _draw() -> void:
		var c := size / 2.0
		var r := size.x / 2.0 - 3.0
		var kind := String(node.get("kind", ""))
		var col: Color = NodeMapScreen.KIND_COL.get(kind, Color("#7A7A7A"))
		if node.get("unbuilt", false): col = col.lerp(Color("#9A9080"), 0.55)
		if open:
			var pulse := 0.5 + 0.5 * sin(t * 4.0)
			draw_circle(c, r + 6 + pulse * 3, Color(VasTokens.AMBER, 0.35 + 0.25 * pulse))
		draw_circle(c + Vector2(2, 3), r, Color(0, 0, 0, 0.35))
		draw_circle(c, r, Color("#B08A4A"))                     # brass rim
		draw_circle(c, r - 3, col if (visited or open) else col.lerp(Color("#E9DDB8"), 0.45))
		var ink := Color("#F5E6C4")
		var s := r * 0.9
		match kind:
			"ICE":
				var pts := PackedVector2Array([c + Vector2(0, -s * 0.6), c + Vector2(s * 0.5, -s * 0.3), c + Vector2(s * 0.42, s * 0.3), c + Vector2(0, s * 0.62), c + Vector2(-s * 0.42, s * 0.3), c + Vector2(-s * 0.5, -s * 0.3)])
				draw_colored_polygon(pts, ink)
				if node.get("miniboss", false) or node.get("central", false):
					draw_circle(c, s * 0.2, col)
			"UPLINK":
				draw_circle(c, s * 0.5, ink); draw_circle(c, s * 0.34, col)
				draw_line(c + Vector2(0, -s * 0.3), c + Vector2(0, s * 0.3), ink, 3.0)
			"SAFEHOUSE":
				draw_colored_polygon(PackedVector2Array([c + Vector2(-s * 0.5, 0), c + Vector2(0, -s * 0.5), c + Vector2(s * 0.5, 0)]), ink)
				draw_rect(Rect2(c + Vector2(-s * 0.36, 0), Vector2(s * 0.72, s * 0.45)), ink)
			"DEAD DROP":
				draw_rect(Rect2(c - Vector2(s * 0.45, s * 0.3), Vector2(s * 0.9, s * 0.6)), ink, false, 3.0)
				draw_line(c + Vector2(-s * 0.45, -s * 0.3), c + Vector2(0, s * 0.05), ink, 2.5); draw_line(c + Vector2(s * 0.45, -s * 0.3), c + Vector2(0, s * 0.05), ink, 2.5)
			"CONSOLE LAB":
				draw_arc(c, s * 0.4, 0, TAU, 24, ink, 3.0); draw_circle(c, s * 0.14, ink)
			_:
				var f := VasTokens.FONT_PLAQUE
				var tw := f.get_string_size("?", HORIZONTAL_ALIGNMENT_LEFT, -1, int(s)).x
				draw_string(f, c + Vector2(-tw / 2.0, s * 0.36), "?", HORIZONTAL_ALIGNMENT_LEFT, -1, int(s), ink)
		if visited:
			draw_arc(c, r - 1, 0, TAU, 32, Color("#2A1D0E"), 3.0, true)
		focus_ring()
