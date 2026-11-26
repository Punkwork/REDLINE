class_name IcePanelLayout
extends Resource
## CAS-001 C18 (ARCH-V2-003): the ICE panel's geometry and replaceable art, kept out of the
## component code so visual exploration (ChatGPT, Codex, designer) can move zones or drop in new
## art without architectural rework. Coordinates are panel-local at scale 1.
## Default instance: res://themes/architecture_v2/ice_panel_layout.tres. PROVISIONAL geometry:
## not locked until the latest visual reference is agreed with ChatGPT and Codex.

@export var panel_size := Vector2(600, 404)
@export var corner_radius := 30
@export var rim_width := 7

@export_group("Identity")
## Nameplate: the ICE name on dark glass.
@export var nameplate_rect := Rect2(262, 40, 300, 60)
@export var name_font_size := 32
## Type icon: centred on the portrait frame's upper-left corner.
@export var type_badge_size := 62.0
@export var type_badge_offset := Vector2(0, 0)
## STR icon and number: centred on the nameplate's upper-right corner.
@export var str_badge_size := 66.0
@export var str_badge_offset := Vector2(-6, 2)
@export var str_font_size := 30

@export_group("Virtual expression")
@export var portrait_rect := Rect2(34, 32, 206, 206)
@export var portrait_radius := 22

@export_group("Persistent status")
@export var status_rect := Rect2(262, 118, 300, 44)

@export_group("Tactical controls")
@export var bank_rect := Rect2(18, 252, 564, 138)
@export var key_unit := 1.32
@export var chevron_width := 16.0
@export var pool_gap := 18.0

@export_group("Replaceable art (null = drawn fallback)")
@export var console_texture: Texture2D
@export var console_margins := Vector4(48, 48, 48, 48)
@export var portrait_frame_texture: Texture2D
@export var type_icons: Dictionary = {}     # "FORTRESS" / "TUMBLER" / "VOID" -> Texture2D
@export var str_icon: Texture2D
## Portrait art: path pattern with %s = ICE id, %s = mood art ("cheery", "wary", "lethal").
@export var portrait_pattern := "res://assets/concept/mascots/%s_%s.png"

const DEFAULT_PATH := "res://themes/architecture_v2/ice_panel_layout.tres"

static func load_default() -> IcePanelLayout:
	if ResourceLoader.exists(DEFAULT_PATH):
		var r := load(DEFAULT_PATH)
		if r is IcePanelLayout: return r
	return IcePanelLayout.new()
