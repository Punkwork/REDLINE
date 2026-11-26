class_name IcePanelLayout
extends Resource
## CAS-001 C18 (ARCH-V2-003): the ICE panel's geometry and art, kept out of the component code so
## visual exploration can move zones or swap art without architectural rework. Reference pixels
## (VAS-001 1536 × 864 composition). PROVISIONAL until the designer approves the composition.
##
## Composition (ARCH-V2-003r, designer 2026-11-26 15:25: "Avatars, Subroutines, Cards in hand …
## should stand out"): the avatar is the largest thing in the window (at least half its field),
## frameless; the subroutine keys float over the avatar's lower edge with drop shadows; nameplate
## with the STR medallion top right (two ICE) or across the top (three ICE); type medallion in the
## upper-left corner; status strip along the foot. The bezel is nine-sliced thin so the field gets
## the pixels. Speech bubbles are momentary overlays and take no layout room.

@export var panel_size := Vector2(700, 352)   ## ARCH-V2-003s: wider, the lane spans the screen
## Three ICE: same width, taller, so the lane's height goes to the avatar and keys.
@export var compact_panel_size := Vector2(720, 550)
## Window bezel: nine-slice margins in the painted file's pixels (its bezel is ~78 px of 1619, the
## corners ~130), and how wide the left margin is drawn (reference px): 27 draws the bezel ~16 px.
@export var window_margins := Vector4(130, 130, 130, 130)
@export var window_rim := 27.0
@export var margin := 26.0

@export_group("Virtual expression (avatar)")
@export var avatar_rect_normal := Rect2(16, 6, 320, 320)
@export var avatar_rect_compact := Rect2(150, 62, 420, 420)
@export var portrait_inset := 0.0
@export var portrait_radius := 0.0

@export_group("Speech bubble (momentary overlay, 1–2 s; covers what is under it)")
@export var bubble_rect_normal := Rect2(340, 64, 340, 150)
@export var bubble_rect_compact := Rect2(380, 60, 320, 160)
@export var bubble_font_size := 22
@export var bubble_font_size_compact := 28
@export var bubble_seconds := 1.6

@export_group("Identity")
@export var nameplate_rect_normal := Rect2(420, 30, 230, 52)
@export var nameplate_rect_compact := Rect2(86, 22, 560, 56)
@export var name_font_size := 30
@export var type_badge_size := 60.0
@export var type_badge_center := Vector2(46, 44)
@export var str_badge_size := 64.0
@export var str_font_size := 30

@export_group("Tactical controls (keys float over the avatar's lower edge)")
@export var bank_rect_normal := Rect2(22, 180, 656, 136)
@export var bank_rect_compact := Rect2(20, 368, 680, 136)
@export var bank_rim := 8.0
@export var key_unit_max := 1.15
@export var key_unit_max_compact := 1.3
@export var chevron_width := 10.0
@export var chevron_width_compact := 6.0
@export var pool_gap := 14.0

@export_group("Persistent status")
@export var strip_height := 26.0
@export var strip_bottom_gap := 16.0

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
	return avatar_rect_compact if compact else avatar_rect_normal

func nameplate_rect(compact: bool = false) -> Rect2:
	return nameplate_rect_compact if compact else nameplate_rect_normal

func bubble_rect(compact: bool) -> Rect2:
	return bubble_rect_compact if compact else bubble_rect_normal

func bank_rect(compact: bool) -> Rect2:
	return bank_rect_compact if compact else bank_rect_normal

func chevron(compact: bool) -> float:
	return chevron_width_compact if compact else chevron_width

func unit_max(compact: bool) -> float:
	return key_unit_max_compact if compact else key_unit_max

func strip_rect(compact: bool = false) -> Rect2:
	var sz := size_of(compact)
	return Rect2(margin, sz.y - strip_bottom_gap - strip_height, sz.x - 2.0 * margin, strip_height)
