class_name IcePanelLayout
extends Resource
## CAS-001 C18 (ARCH-V2-003): the ICE panel's geometry and art, kept out of the component code so
## visual exploration can move zones or swap art without architectural rework. Reference pixels
## (VAS-001 1536 × 864 composition). PROVISIONAL until the designer approves the composition.
##
## Composition (VAS-001 + ARCH-V2-003b): portrait on the left (virtual expression); nameplate top
## right with the STR medallion on its upper-right corner; the type medallion on the portrait's
## upper-left corner (identity); the key bed below the nameplate (tactical controls); the status
## strip along the foot (persistent status). Space left over stays empty (negative space).

@export var panel_size := Vector2(586, 352)
## ARCH-V2-003p (PROPOSED): three ICE use a taller panel (same width) so the lane's height is
## used and the avatar stays large: portrait top left, nameplate and speech bubble beside it,
## keys in a full-width bed below, status strip at the foot.
@export var compact_panel_size := Vector2(586, 560)
@export var compact_window_margins := Vector4(70, 70, 70, 70)
@export var margin := 26.0
@export var column_gap := 20.0

@export_group("Virtual expression")
@export var portrait_side := 176.0
## Used when the lane has to shrink panels (three ICE) so keys stay ≥ 44 px on screen.
@export var portrait_side_compact := 268.0
@export var margin_compact := 18.0
@export var column_gap_compact := 12.0
@export var portrait_inset := 11.0
@export var portrait_radius := 16.0

@export_group("Speech bubble (ICE lines; room reserved per designer 2026-11-26)")
@export var bubble_rect_normal := Rect2(206, 196, 300, 92)
@export var bubble_rect_compact := Rect2(290, 96, 276, 160)
@export var bubble_font_size := 18
@export var bubble_font_size_compact := 26

@export_group("Identity")
@export var nameplate_size := Vector2(264, 52)
@export var nameplate_right := 530.0
@export var name_font_size := 30
@export var type_badge_size := 60.0
@export var str_badge_size := 64.0
@export var str_font_size := 30

@export_group("Tactical controls")
@export var bank_top := 102.0
@export var bank_bottom := 272.0
@export var bank_rim := 10.0
@export var key_unit_max := 1.0
@export var chevron_width := 10.0
@export var chevron_width_compact := 6.0
@export var key_unit_max_compact := 1.3
@export var pool_gap := 14.0

@export_group("Persistent status")
@export var strip_top := 288.0
@export var strip_height := 32.0
@export var compact_bank_rect := Rect2(22, 312, 542, 170)
@export var compact_strip_top := 500.0

@export_group("Art (paths under res://assets/architecture_v2/; missing = drawn fallback)")
@export var window_art := "ice/V2_ICE_WINDOW.png"
@export var portrait_frame_art := "ice/V2_PORTRAIT_FRAME.png"
@export var nameplate_art := "ice/V2_NAMEPLATE.png"
@export var key_bed_art := "ice/V2_KEY_BED.png"
@export var key_bed_margins := Vector4(60, 60, 60, 60)
@export var status_strip_art := "ice/V2_STATUS_STRIP.png"
@export var status_strip_margins := Vector4(90, 20, 50, 20)
@export var type_icons := {"FORTRESS": "ice/V2_MEDALLION_FORTRESS.png", "TUMBLER": "ice/V2_MEDALLION_TUMBLER.png", "VOID": "ice/V2_MEDALLION_VOID.png"}
@export var str_icon := "ice/V2_MEDALLION_STR.png"
## Portrait art: %s = ICE id, %s = mood art ("cheery", "wary", "lethal"). The designer's revised
## avatars (2026-11-26, ChatGPT set) come first; the older concept mascots are the fallback.
@export var portrait_pattern := "res://assets/architecture_v2/avatars/%s_%s.png"
@export var portrait_fallback_pattern := "res://assets/concept/mascots/%s_%s.png"
@export var bubble_art := "ice/V2_SPEECH_BUBBLE.png"

const DEFAULT_PATH := "res://themes/architecture_v2/ice_panel_layout.tres"

static func load_default() -> IcePanelLayout:
	if ResourceLoader.exists(DEFAULT_PATH):
		var r := load(DEFAULT_PATH)
		if r is IcePanelLayout: return r
	return IcePanelLayout.new()

func size_of(compact: bool) -> Vector2:
	return compact_panel_size if compact else panel_size

func portrait_rect(compact: bool) -> Rect2:
	if compact: return Rect2(margin_compact + 4.0, margin, portrait_side_compact, portrait_side_compact)
	return Rect2(margin, margin, portrait_side, portrait_side)

func nameplate_rect(compact: bool = false) -> Rect2:
	if compact:
		var x := margin_compact + 4.0 + portrait_side_compact + column_gap_compact + 2.0
		var w := compact_panel_size.x - margin - str_badge_size * 0.5 - 8.0 - x
		return Rect2(x, margin + 8.0, w, nameplate_size.y)
	return Rect2(nameplate_right - nameplate_size.x, margin + 8.0, nameplate_size.x, nameplate_size.y)

func bubble_rect(compact: bool) -> Rect2:
	return bubble_rect_compact if compact else bubble_rect_normal

func bank_rect(compact: bool) -> Rect2:
	if compact: return compact_bank_rect
	var x := margin + portrait_side + column_gap
	return Rect2(x, bank_top, panel_size.x - margin - x, bank_bottom - bank_top)

func chevron(compact: bool) -> float:
	return chevron_width_compact if compact else chevron_width

func unit_max(compact: bool) -> float:
	return key_unit_max_compact if compact else key_unit_max

func strip_rect(compact: bool = false) -> Rect2:
	var sz := size_of(compact)
	return Rect2(margin, compact_strip_top if compact else strip_top, sz.x - 2.0 * margin, strip_height)
