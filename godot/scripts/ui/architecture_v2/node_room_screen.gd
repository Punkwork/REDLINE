class_name NodeRoomScreen
extends Control
## DEAD DROP, Console Lab and SIGNAL Nodes (designer 2026-11-28: "rooms with backgrounds only"): the
## Node's painted room, its name and a LEAVE key. Their services (Core Rules §8.3) are not built yet.

signal leave_requested

const REF := Vector2(1600, 1000)
const BGS := {"DEAD DROP": "res://assets/concept/backgrounds/BG_NODE_DEAD_DROP.png",
	"CONSOLE LAB": "res://assets/concept/backgrounds/BG_NODE_CONSOLE_LAB.png",
	"SIGNAL": "res://assets/concept/backgrounds/BG_NODE_SIGNAL_UNCLEAR.png"}
const NAMES := {"DEAD DROP": "DEAD DROP", "CONSOLE LAB": "CONSOLE LAB", "SIGNAL": "SIGNAL UNCLEAR"}

var game: Game
var stage: Control
var bg: TextureRect
var plate: Label
var kind := ""

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var back := ColorRect.new(); back.color = Color.BLACK; back.set_anchors_preset(Control.PRESET_FULL_RECT); add_child(back)
	stage = Control.new(); stage.name = "Stage"; stage.size = REF; stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(stage)
	bg = TextureRect.new(); bg.name = "Room"; bg.size = REF
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(bg)
	plate = Label.new(); plate.name = "Plate"; plate.position = Vector2(560, 36); plate.size = Vector2(480, 64)
	plate.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; plate.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	plate.add_theme_font_override("font", VasTokens.FONT_PLAQUE); plate.add_theme_font_size_override("font_size", 36)
	plate.add_theme_color_override("font_color", VasTokens.AMBER)
	var sb := StyleBoxFlat.new(); sb.bg_color = Color("#14100C", 0.88); sb.border_color = UplinkRoom.BRASS; sb.set_border_width_all(2); sb.set_corner_radius_all(6)
	plate.add_theme_stylebox_override("normal", sb)
	stage.add_child(plate)
	var leave := UplinkRoom._styled(Button.new(), 26); leave.name = "Leave"; leave.text = "LEAVE"
	leave.position = Vector2(1352, 920); leave.size = Vector2(200, 56)
	leave.pressed.connect(func(): leave_requested.emit())
	stage.add_child(leave)
	get_viewport().size_changed.connect(_fit)
	_fit()

func _fit() -> void:
	var vp := get_viewport_rect().size
	var k := minf(vp.x / REF.x, vp.y / REF.y)
	stage.scale = Vector2(k, k)
	stage.position = (vp - REF * k) / 2.0

func attach(g: Game) -> void:
	game = g
	kind = String(g.node.get("kind", ""))
	bg.texture = load(BGS.get(kind, BGS["SIGNAL"]))
	plate.text = String(NAMES.get(kind, kind))
