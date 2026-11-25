class_name FriendlyEncounter
extends Control
## Read-only presentation of Game, delegating all actions to the existing controller.
var ui
var game: Game
var skin: CorporationSkin
var background: TextureRect
var surveillance_layer: TextureRect
var node_tag: Panel
var trace_tag: Panel
var bottom_hud: Panel
## CARDS-004 layout: 1.4x cards in a full-width hand; the ICE area scales to 85%.
## ENC-CONCEPT-001 layout pass (concept 2): the hand sits in the copper tray between the deck
## and discard wells; the ICE consoles fill the middle band; the left column is CRT, punch
## cards, the NUL/REM slip and toggles; vitals sit bottom-left beside the tray.
const HAND_RECT := Rect2(400, 778, 662, 214)   # the CAP rack sits right of the hand (UPL caps rules: "beside your hand")
const ICE_SCALE := 0.85
const ICE_X := 264.0
const ICE_TOP := 110.0
const ICE_W := 1320.0 / ICE_SCALE
## ICE-ANALOG-001: bigger mascots on a taller stage; the analog console below is shorter than the old scan tag.
const MASCOT_GROWTH := 1.18
const STAGE_H := 236
const ICE_AREA_H := 632.0 / ICE_SCALE   # on screen y110 to y742; the ticker sits below
const NOTE_W := 196.0
const NOTE_H := 96.0
const CRT_INK := Color("#7DFFB8")
var crt_screen: Panel
var crt_status: Label
var end_lamp: Analog
var crt_picture: TextureRect
var deck_count: Label
var discard_count: Label
var legend: Control
var key_u := 1.0
## ENC-CONCEPT-001 program screen: the CRT shows one installed program at a time (the active one);
## ◀ ▶ (or the mouse wheel) rotate through the rig. A newly installed program becomes active.
var active_program := -1
var known_programs: Array = []
var program_connector: Control
var ghost_rail: HBoxContainer   # Ghostware badges hanging from the pipe above the ICE, any number
var cap_rack: Control           # CAP slots beside the hand (3 minimum; more later)
var obj_tip: PanelContainer     # HOVER-001: the shared hover box (large picture + text)
var obj_tip_owner: Control
var key_tip_image: Control
const CAP_SLOTS := 3
var cart_rack: Control   # slim program cards sticking out of the CRT's top, one per installed program
const CONSOLE_OVERLAP := -14   # the mascot peeks over the console's top edge
## Graffiti lands in free margins: under the Program Bay and under the TRACE panel.
## ENC-CONCEPT-001: graffiti goes on the decal plate in the top bar, between the node plate and the corporate sign.
const GRAFFITI_SPOTS := [Vector2(328, 14), Vector2(328, 36), Vector2(328, 58), Vector2(328, 80)]
const GRAFFITI_W := 136.0
var note: Panel
var note_text: Label
var log_text: Label
var ice_scroll: ScrollContainer
var ice_row: HBoxContainer
var response: HBoxContainer
var hand: FriendlyHand
var rig_row: HBoxContainer
var program_bay: FriendlyProgramBay
var program_slots: VBoxContainer
var end_button: Button
var end_run_button: Button
var pile_text: Label
var hover_uid := -1
var dragging_uid := -1
var drag_kind := ""
var drag_source: Control
var reduced_motion := false
var hand_signature := ""
var new_subroutines: Array = []
var corporation_state := "friendly"
var bleed := 0.0
var bleed_from := 0.0
var bleed_target := 0.0
var bleed_elapsed := 0.0
var bleed_label: Label
var music: FriendlyMusic
var worn_panels: Array[FriendlyRigWear] = []
var previous_trace := 0
var previous_strikes := 0
var warned := false
var strike_until := 0.0
var toast_until := 0.0
var strike_overlay: Control
var toast: Panel
var app_ground: ColorRect
var glitch_layer: Control
var mascot_history: Array = []
var state_before_refresh := "friendly"
var background_target: Texture2D
var background_fade: Tween
var fade_layer: TextureRect
var motion_button: Button
var watcher_warning: Panel
var watcher_text: Label
var next_flicker := 0.0
var flicker_frames := 0
var card_positions := {}
var last_note := ""
var feedback_panel: Panel
var feedback_label: Label
var feedback_until:=0.0
var feedback_message:=""
var drag_description:=""
var bw_capacity := Game.BW_PER_TURN
var last_encounter: Dictionary = {}
var last_turn := -1
var voice_rng := RandomNumberGenerator.new()
var used_leaks := {}
var leak := ""
var note_serial := -1
var graffiti: Control
var graffiti_count := 0
var shell_graffiti := {}
var mascots: Array[FriendlyMascot] = []
# PIXEL-TRACE-001 (PROPOSED): one shared material quantizes the backdrop and mascot art.
const TRACE_PIXEL := preload("res://themes/trace_pixel.gdshader")
var pixel_material: ShaderMaterial
var pixel_layers: Array[Control] = []
var pixel_target := {}   # the step the TRACE state asks for
var pixel_shown := {}    # what is on screen now (differs mid-transition)
var pixel_tween: Tween
var hover_card := -1
var hover_time := 0.0
var hesitation_cooldown := 0.0
var hesitation_turn := -1
var hesitation_index := {}
var hesitation_ice := -1
var hesitation_line := ""
var hesitation_until := 0.0
var early_toast := false
var tomorrow_toast := false
var mask_toast := false
var toast_text: Label
var toast_reply: Label
var punch_holder: Panel
var punch_count: Label
var punch_shadow: Control
var last_punches: Array = []
var punch_arrival: Panel
var arrival_until := 0.0
func _ready() -> void:
 theme = FriendlyLook.THEME
 mouse_filter = Control.MOUSE_FILTER_PASS
 skin = concept_backgrounds(ui.friendly_skin)
 music = FriendlyMusic.new()
 add_child(music)
 music.set_level(ui.music_volume, ui.music_muted)
 visibility_changed.connect(func(): music.set_active(is_visible_in_tree()))
 app_ground = ColorRect.new()
 app_ground.color = skin.ground
 app_ground.mouse_filter = Control.MOUSE_FILTER_IGNORE
 add_child(app_ground)
 app_ground.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 background = add_backdrop(skin.background, 1.0)
 surveillance_layer = add_backdrop(skin.hostile_background, AtomicDecoPunk.reveal(0.0))
 surveillance_layer.hide()
 pixel_material = ShaderMaterial.new(); pixel_material.shader = TRACE_PIXEL
 add_child(pixel_overlay(Vector2.ZERO, Vector2.ZERO, true))
 glitch_layer = Control.new(); glitch_layer.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(glitch_layer)
 for y in [192,362,557,853]:
  var band := ColorRect.new(); band.color=Color("#E5484D29"); band.position=Vector2(0,y); band.size=Vector2(1600,3); band.mouse_filter=Control.MOUSE_FILTER_IGNORE; glitch_layer.add_child(band)
 graffiti = Control.new()
 graffiti.mouse_filter = Control.MOUSE_FILTER_IGNORE
 add_child(graffiti)
 var screen_frame := painted("UI_FRAME")
 if screen_frame:
  var frame_rect := TextureRect.new(); frame_rect.name = "ScreenFrame"; frame_rect.texture = screen_frame; frame_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; frame_rect.stretch_mode = TextureRect.STRETCH_SCALE
  frame_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE; frame_rect.position = Vector2.ZERO; frame_rect.size = Vector2(1600, 1000); add_child(frame_rect)
 build_pipework()
 var top_bar := Panel.new(); top_bar.name = "TopBar"; top_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE; top_bar.add_theme_stylebox_override("panel", Analog.bakelite())
 paint_panel(top_bar, "UI_TOPBAR_S", Vector4(50, 30, 50, 30)); at(self, top_bar, Vector2(10, 4), Vector2(1580, 104))
 node_tag = Panel.new(); node_tag.add_theme_stylebox_override("panel", Analog.bakelite()); paint_panel(node_tag, "UI_BRAND_PLATE", Vector4(110, 30, 30, 30), Vector4.ZERO); node_tag.position = Vector2(18, 10); node_tag.size = Vector2(298, 92); add_child(node_tag)
 var decal := Panel.new(); decal.name = "DecalPlate"; decal.add_theme_stylebox_override("panel", Analog.bakelite()); decal.position = Vector2(320, 10); decal.size = Vector2(150, 92); decal.mouse_filter = Control.MOUSE_FILTER_IGNORE; paint_panel(decal, "UI_PLATE_DARK_S", Vector4(20, 14, 20, 14)); add_child(decal); move_child(decal, node_tag.get_index())
 decal.draw.connect(func():
  for k in 7: decal.draw_rect(Rect2(14, 14 + k * 10, 122, 3), Color(1, 1, 1, 0.05))
  var screw := painted("UI_SCREW")
  for q in [Vector2(5, 5), Vector2(135, 5), Vector2(5, 77), Vector2(135, 77)]:
   if screw: decal.draw_texture_rect(screw, Rect2(q, Vector2(10, 10)), false)
   else: decal.draw_circle(q + Vector2(5, 5), 3, Color("#B9A27A")))
 trace_tag = Panel.new(); trace_tag.add_theme_stylebox_override("panel", Analog.bakelite() if painted("UI_TURN_PLATE") == null else StyleBoxEmpty.new()); trace_tag.position = Vector2(476, 8); trace_tag.size = Vector2(808, 96); add_child(trace_tag)
 ice_scroll = ScrollContainer.new(); ice_scroll.position = Vector2(ICE_X, ICE_TOP); ice_scroll.size = Vector2(ICE_W, ICE_AREA_H); ice_scroll.scale = Vector2.ONE * ICE_SCALE; ice_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO; ice_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO; add_child(ice_scroll)
 ice_row = HBoxContainer.new(); ice_row.add_theme_constant_override("separation", 42); ice_row.alignment = BoxContainer.ALIGNMENT_CENTER; ice_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL; var ice_margin:=MarginContainer.new(); ice_margin.add_theme_constant_override("margin_top",10); ice_margin.size_flags_horizontal=Control.SIZE_EXPAND_FILL; ice_scroll.add_child(ice_margin); ice_margin.add_child(ice_row)
 # ENC-CONCEPT-001: each ICE carries its own NEXT RESPONSE plate (scan_tag); no shared strip.
 # The NUL/REM note is a typed slip clipped under the CRT (concept-2 layout pass).
 var slip := painted("UI_NOTE_SLIP") != null
 note = FriendlyLook.panel(FriendlyLook.TONER); note.name = "NulRemNote"; note.position = Vector2(18, 458); note.size = Vector2(238, 176); note.rotation_degrees = -1.0 if slip else -0.6; note.mouse_filter = Control.MOUSE_FILTER_PASS; add_child(note)  # PASS: a SCRIPT dropped on the note still plays
 paint_panel(note, "UI_NOTE_SLIP", Vector4(60, 70, 40, 40), Vector4.ZERO)
 note_text = FriendlyLook.label("", 12, FriendlyLook.TONER if slip else FriendlyLook.HIGHLIGHT); note_text.position = Vector2(26, 72) if slip else Vector2(10, 8); note_text.size = Vector2(NOTE_W, NOTE_H); note_text.clip_text = slip; note_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; note.add_child(note_text)
 var voice := FriendlyLook.button("VOICE / M", func(): ui._toggle_voice(), FriendlyLook.TONER, FriendlyLook.PAPER); voice.name = "VoiceButton"; voice.position = Vector2(16, 670); voice.size = Vector2(118, 28); voice.add_theme_font_size_override("font_size", 11); paint_button(voice); add_child(voice)
 var legend_button := FriendlyLook.button("KEY LEGEND", func(): legend.visible = not legend.visible, FriendlyLook.TONER, FriendlyLook.PAPER); legend_button.name = "LegendButton"; legend_button.add_theme_font_size_override("font_size", 11); paint_button(legend_button); legend_button.add_theme_font_override("font", console_font(2)); at(self, legend_button, Vector2(138, 670), Vector2(118, 28))
 build_left_trim()
 # The log and the rack run along a black-glass ticker under the ICE.
 var rig_ground := Panel.new(); rig_ground.name = "Ticker"; rig_ground.add_theme_stylebox_override("panel", Analog.glass(4, Color("#2A2622"))); paint_panel(rig_ground, "UI_TICKER", Vector4(40, 10, 40, 10), Vector4.ZERO); rig_ground.position=Vector2(264,744); rig_ground.size=Vector2(1320,24); add_child(rig_ground)
 var rig_scroll := ScrollContainer.new(); rig_scroll.position = Vector2(284, 747); rig_scroll.size = Vector2(520, 18); rig_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; add_child(rig_scroll)
 rig_row = HBoxContainer.new(); rig_row.add_theme_constant_override("separation", 8); rig_scroll.add_child(rig_row)
 program_bay = FriendlyProgramBay.new()
 program_bay.encounter = self
 program_bay.name = "ProgramBay"
 program_bay.mouse_filter = Control.MOUSE_FILTER_PASS
 program_bay.add_theme_stylebox_override("panel", Analog.bakelite())
 paint_panel(program_bay, "UI_CRT_MONITOR", Vector4.ZERO)
 cart_rack = Control.new(); cart_rack.name = "ProgramCartridges"; cart_rack.mouse_filter = Control.MOUSE_FILTER_PASS
 at(self, cart_rack, Vector2(16, 104), Vector2(240, 50))
 at(self, program_bay, Vector2(16,140), Vector2(240,279))
 crt_screen = Panel.new(); crt_screen.name = "CrtScreen"; crt_screen.mouse_filter = Control.MOUSE_FILTER_PASS
 var screen_style := StyleBoxFlat.new(); screen_style.bg_color = Color("#0E1F1A"); screen_style.border_color = Color("#C9B796"); screen_style.set_border_width_all(3); screen_style.set_corner_radius_all(18)
 crt_screen.add_theme_stylebox_override("panel", screen_style)
 if painted("UI_CRT_MONITOR"):
  # The painted monitor's own glass is the screen: x45–397, y50–340 of 448×520, drawn at 240/448.
  screen_style.draw_center = false; screen_style.set_border_width_all(0)
  at(program_bay, crt_screen, Vector2(25,28), Vector2(188,154))
  crt_picture = TextureRect.new(); crt_picture.name = "CrtPicture"; crt_picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; crt_picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
  crt_picture.mouse_filter = Control.MOUSE_FILTER_IGNORE; crt_picture.modulate = Color(1, 1, 1, 0.8); at(crt_screen, crt_picture, Vector2.ZERO, Vector2(188, 154))
  var scrim := ColorRect.new(); scrim.name = "ProgramScrim"; scrim.color = Color(0.02, 0.06, 0.05, 0.72); scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
  at(crt_screen, scrim, Vector2(2, 34), Vector2(184, 118))   # keeps the program readout off the skyline
 else:
  at(program_bay, crt_screen, Vector2(8,8), Vector2(208,224))
 var on_crt := painted("UI_CRT_MONITOR") != null
 var crt_l := [Vector2(8,3), Vector2(172,30), 32.0, Vector2(8,34), Vector2(6,36), Vector2(176,116), Vector2(6,120), Vector2(176,28)] if on_crt else [Vector2(14,6), Vector2(184,50), 58.0, Vector2(14,62), Vector2(10,80), Vector2(188,102), Vector2(10,186), Vector2(188,30)]
 crt_status = FriendlyLook.label("", 11 if on_crt else 12, CRT_INK, console_font(2)); at(crt_screen, crt_status, crt_l[0], crt_l[1])
 crt_screen.draw.connect(func():
  for y in range(6, 220, 4): crt_screen.draw_line(Vector2(6, y), Vector2(202, y), Color(0.45, 1, 0.75, 0.035), 1)
  crt_screen.draw_line(Vector2(8, crt_l[2]), Vector2(crt_screen.size.x - 8, crt_l[2]), Color(CRT_INK, 0.4), 1))
 if not on_crt: at(crt_screen, FriendlyLook.label("PROGRAMS", 12, CRT_INK, console_font(3)), crt_l[3])
 var program_scroll := ScrollContainer.new()
 program_scroll.mouse_filter = Control.MOUSE_FILTER_PASS
 program_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
 program_scroll.gui_input.connect(func(e):
  if e is InputEventMouseButton and e.pressed and e.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]:
   cycle_program(-1 if e.button_index == MOUSE_BUTTON_WHEEL_UP else 1); program_scroll.accept_event())
 at(crt_screen, program_scroll, crt_l[4], crt_l[5])
 program_slots = VBoxContainer.new()
 program_slots.name = "ProgramSlots"
 program_slots.mouse_filter = Control.MOUSE_FILTER_PASS
 program_slots.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 program_slots.add_theme_constant_override("separation", 8)
 program_scroll.add_child(program_slots)
 var connector := FriendlyLook.panel(Color("#14302A"), CRT_INK, 1, 6)
 program_connector = connector
 connector.mouse_filter = Control.MOUSE_FILTER_IGNORE
 at(crt_screen, connector, crt_l[6], crt_l[7])
 at(connector, FriendlyLook.label("DROP PROGRAM HERE", 11 if on_crt else 12, CRT_INK, console_font(2)), Vector2(10,1))
 for pin in range(18):
  var contact := ColorRect.new()
  contact.color = Color(CRT_INK, 0.6)
  contact.mouse_filter = Control.MOUSE_FILTER_IGNORE
  at(connector, contact, Vector2(10 + pin * 9, 20 if on_crt else 21), Vector2(5,4))
 build_tray()
 build_cap_rack()
 hand = FriendlyHand.new(); hand.position = HAND_RECT.position; hand.size = HAND_RECT.size; hand.focus_mode = Control.FOCUS_ALL; hand.mouse_filter = Control.MOUSE_FILTER_PASS; add_child(hand)
 bottom_hud = Panel.new(); bottom_hud.add_theme_stylebox_override("panel", Analog.bakelite()); paint_panel(bottom_hud, "UI_VITALS_PANEL", Vector4.ZERO); bottom_hud.position = Vector2(16, 772); bottom_hud.size = Vector2(240, 214); add_child(bottom_hud)
 var piles_paper:=Panel.new(); piles_paper.add_theme_stylebox_override("panel", Analog.bakelite() if painted("UI_HAND_TRAY") == null else StyleBoxEmpty.new()); piles_paper.position=Vector2(1268,898); piles_paper.size=Vector2(142,50); piles_paper.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(piles_paper)
 pile_text = FriendlyLook.label("", 10, Analog.CREAM, console_font(1)); pile_text.position = Vector2(1272, 900); pile_text.size = Vector2(136, 46); pile_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; add_child(pile_text)
 end_button = FriendlyLook.button("END\nTURN", func(): ui._on_end_turn()); end_button.position = Vector2(1418, 774); end_button.size = Vector2(160, 180); style_end_turn(end_button); add_child(end_button)
 end_lamp = Analog.lamp(Color("#FFB020"), true, 14); at(self, end_lamp, Vector2(1400, 778))
 var deck := FriendlyLook.button("DECK / COVERAGE", func(): ui.deck_open = true; ui.refresh(), Analog.BAKELITE, Analog.CREAM, 6, console_font(2)); deck.add_theme_font_size_override("font_size", 12); paint_button(deck); paint_tray_button(deck); deck.position = Vector2(1268, 798); deck.size = Vector2(142, 46); add_child(deck)
 end_run_button = FriendlyLook.button("END RUN", func(): ui._confirm_end_run(), Analog.BAKELITE_EDGE, Color("#F0A090"), 6, console_font(3)); end_run_button.add_theme_font_size_override("font_size", 13); paint_button(end_run_button); end_run_button.add_theme_color_override("font_color", Color("#FFB4A4")); paint_tray_button(end_run_button, Color("#8A1408")); end_run_button.position = Vector2(1268, 848); end_run_button.size = Vector2(142, 46); add_child(end_run_button)
 toast = FriendlyLook.panel(Color.WHITE, FriendlyLook.RED, 1, 10, 3)
 at(self, toast, Vector2(18, 458), Vector2(238, 105))
 toast.z_index = 5
 toast_text = FriendlyLook.label(skin.cracking_copy, 15, FriendlyLook.TONER, skin.font)
 toast_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 at(toast, toast_text, Vector2(8, 6), Vector2(184, 72))
 toast_reply = FriendlyLook.label("", 14, FriendlyLook.TONER, ADP_MARKER)
 at(toast, toast_reply, Vector2(8, 80), Vector2(184, 20))
 toast.hide()
 punch_arrival = FriendlyLook.panel(FriendlyLook.TONER, FriendlyLook.HIGHLIGHT, 1, 5)
 at(self, punch_arrival, Vector2(18, 458), Vector2(238, 105))
 punch_arrival.clip_contents = true
 punch_arrival.hide()
 punch_holder = Panel.new(); var punch_style := Analog.bakelite(8); punch_style.shadow_size = 4; punch_holder.add_theme_stylebox_override("panel", punch_style)
 at(self, punch_holder, Vector2(16, 422), Vector2(240, 32))
 punch_holder.clip_contents = true
 punch_count = FriendlyLook.label("", 13, FriendlyLook.PAPER, FriendlyLook.BOLD)
 at(punch_holder, punch_count, Vector2(8, 5))
 punch_shadow = Control.new()
 punch_shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
 punch_holder.add_child(punch_shadow)
 var inspect_punches := FriendlyLook.button("VIEW", func(): ui.open_punches(), FriendlyLook.TONER, FriendlyLook.PAPER)
 paint_button(inspect_punches); inspect_punches.add_theme_font_override("font", console_font(2))
 at(punch_holder, inspect_punches, Vector2(184, 3), Vector2(52, 26))
 strike_overlay = Control.new(); strike_overlay.name="StrikeOneModal"; strike_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); strike_overlay.mouse_filter=Control.MOUSE_FILTER_STOP; strike_overlay.z_index=200; add_child(strike_overlay); strike_overlay.hide()
 motion_button=FriendlyLook.button("REDUCED MOTION: OFF",func(): ui.set_reduced_motion(not ui.reduced_motion),FriendlyLook.PAPER)
 paint_button(motion_button); motion_button.add_theme_font_override("font", console_font(2))
 motion_button.position=Vector2(16,638); motion_button.size=Vector2(240,28); motion_button.add_theme_font_size_override("font_size",11); add_child(motion_button)
 watcher_warning=FriendlyLook.panel(FriendlyLook.RED); watcher_warning.position=Vector2(1030,540); watcher_warning.size=Vector2(510,36); watcher_warning.z_index=150; watcher_warning.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(watcher_warning)
 watcher_text=FriendlyLook.label("",12,FriendlyLook.TONER,FriendlyLook.BOLD); watcher_text.position=Vector2(8,7); watcher_warning.add_child(watcher_text); watcher_warning.hide()
 strike_overlay.gui_input.connect(func(e):
  if e is InputEventMouseButton and e.pressed: dismiss_strike())
 feedback_panel=FriendlyLook.panel(FriendlyLook.TONER,FriendlyLook.HIGHLIGHT,2); feedback_panel.position=Vector2(606,32); feedback_panel.size=Vector2(350,82); feedback_panel.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(feedback_panel); feedback_panel.hide()
 feedback_label=FriendlyLook.label("",12,FriendlyLook.HIGHLIGHT,FriendlyLook.BOLD); feedback_label.position=Vector2(10,7); feedback_label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; feedback_label.size=Vector2(330,70); feedback_panel.add_child(feedback_label)
 log_text = FriendlyLook.label("", 11, Analog.CREAM, console_font(1)); log_text.position = Vector2(816, 748); log_text.size = Vector2(752, 16); log_text.clip_text = true; log_text.tooltip_text = "Chronological game log"; add_child(log_text)
 for panel in [node_tag, trace_tag, bottom_hud, note, rig_ground, piles_paper, program_bay]:
  if panel == trace_tag and painted("UI_TURN_PLATE") != null: continue   # transparent holder of painted plates
  var wear := FriendlyRigWear.new()
  wear.code_strip = panel in [node_tag,trace_tag]
  panel.add_child(wear, false, Node.INTERNAL_MODE_BACK)
  worn_panels.append(wear)

 build_key_tip()
 var display: Dictionary = AtomicDecoPunk.settings.display
 var sign := FriendlyLook.panel(skin.plaque_ground, skin.plaque_accent, 2, 10)
 sign.name = "CorporateDisplay"
 sign.mouse_filter = Control.MOUSE_FILTER_IGNORE
 at(self, sign, Vector2(1290,12), Vector2(290,88))
 var wordmark := FriendlyLook.label(skin.app_name, int(display.wordmark_px), skin.plaque_ink, skin.display_font)
 var headline := FriendlyLook.label(skin.background_headline, int(display.background_headline_px), skin.plaque_ink, skin.display_font)
 for title in [wordmark, headline]:
  title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 at(sign, wordmark, Vector2(10,4), Vector2(270,40))
 at(sign, headline, Vector2(10,47), Vector2(270,32))
 build_legend()
 build_ghost_rail()
func clear(node: Node) -> void:
 for child in node.get_children(): node.remove_child(child); child.queue_free()
func at(parent: Node, control: Control, pos: Vector2, extent: Vector2 = Vector2.ZERO) -> Control:
 control.position = pos
 if extent != Vector2.ZERO: control.size = extent
 parent.add_child(control); return control
func sync(model: Game) -> void:
 game = model
 if game.enc.is_empty(): return
 reduced_motion=ui.reduced_motion
 motion_button.text="REDUCED MOTION: " + ("ON" if reduced_motion else "OFF")
 if not is_same(last_encounter, game.enc):
  reset_voice()
 if not is_same(last_encounter,game.enc) or last_turn!=game.enc.turn: bw_capacity=maxi(Game.BW_PER_TURN,game.bw)
 else: bw_capacity=maxi(bw_capacity,game.bw)
 last_encounter=game.enc; last_turn=game.enc.turn
 update_corporation()
 update_punch_holder()
 clear(node_tag); clear(trace_tag); clear(bottom_hud)
 build_node_plate(); build_trace_plate(); build_instruments(); update_crt_status()
 pile_text.text = "DECK %d  ·  DISCARD %d\nFP %d/%d · %s\nREBOOT ~%d · AMP %d" % [game.draw_pile.size(), game.discard.size(),game.footprint(),game.footprint_cap(),game.footprint_band(),int(ceil(float(game.draw_pile.size())/maxi(1,game.draw_size()))),game.amp]
 end_button.disabled = game.phase != "PLAYER" or ui.responding
 end_lamp.on = not end_button.disabled; end_lamp.queue_redraw()
 if deck_count: deck_count.text = "DECK %d" % game.draw_pile.size()
 if discard_count: discard_count.text = "DISCARD %d" % game.discard.size()
 end_run_button.disabled = ui.responding
 track_new_subs()
 build_rig(); build_ice(); build_hand()
 mascot_history=[]
 for i in game.enc.ice.size(): mascot_history.append({"ice":game.enc.ice[i],"mood":mood_for(i),"broken":game.enc.ice[i].broken.duplicate()})
 log_text.text = " · ".join(game.log.slice(maxi(0, game.log.size() - 2)))
 log_text.tooltip_text = "\n".join(game.log)
func _process(_dt: float) -> void:
 if not visible or not is_instance_valid(ui): return
 advance_bleed(_dt)
 music.set_active(true)
 music.update_mix(bleed, reduced_motion, _dt)
 for wear in worn_panels: wear.update_wear(bleed, reduced_motion, Time.get_ticks_msec() / 1000.0)
 var context := ""
 if corporation_state=="mask_off": context="the mask is off. one more strike and we can't leave. "
 elif corporation_state=="cracking": context="%d TRACE to a strike. " % maxi(0,Game.MAX_TRACE-game.trace)
 update_voice(_dt)
 note_text.text="NUL/REM: " + context + ui.nr_text.text
 if not leak.is_empty(): note_text.text += "\n" + leak
 if last_note!=note_text.text:
  last_note=note_text.text; note_text.tooltip_text=note_text.text
  var fs:=12
  while fs>8 and FriendlyLook.MONO.get_multiline_string_size(note_text.text,HORIZONTAL_ALIGNMENT_LEFT,NOTE_W,fs).y>NOTE_H: fs-=1
  note_text.add_theme_font_size_override("font_size",fs)
  # The label's own line height (theme spacing included) is the real measure on the paper slip.
  while fs>8 and note_text.get_line_count()*(note_text.get_line_height()+note_text.get_theme_constant("line_spacing"))>NOTE_H:
   fs-=1; note_text.add_theme_font_size_override("font_size",fs)
 note_text.visible_ratio=ui.nr_text.visible_ratio if context=="" and leak.is_empty() else 1.0
 var now := Time.get_ticks_msec()/1000.0
 punch_arrival.visible = now < arrival_until
 toast.visible=now<toast_until and not punch_arrival.visible
 if strike_overlay.visible and now>=strike_until: dismiss_strike()
 feedback_panel.visible=dragging_uid>=0 or now<feedback_until
 if dragging_uid>=0:
  var source: Dictionary=game.find_card(dragging_uid)
  if source.is_empty():
   var installed_source: Dictionary=game._installed_entry(dragging_uid)
   if not installed_source.is_empty(): source=installed_source.inst
  feedback_label.text=(CardDB.def(source.id).name+"\n" if not source.is_empty() else "") + (drag_description if drag_description!="" else "Drop on a compatible rule row.")
 else: feedback_label.text=feedback_message
 watcher_warning.visible=false
 if dragging_uid>=0 and drag_kind=="card":
  var c := game.find_card(dragging_uid)
  if not c.is_empty() and CardDB.def(c.id).tags.has("CLOAK") and game.enc.get("ice",[]).any(func(ice): return game.ice_definition(ice).get("ability","")=="CLOAK_TRACE"):
   watcher_warning.show(); watcher_warning.position=Vector2(40 if get_global_mouse_position().x>800 else 1050,550); watcher_text.text="WATCHER: play this CLOAK card · +%d TRACE" % (0 if game.rustler=="ECHO" or game.enc.get("decoy",false) else 1)
 if reduced_motion: glitch_layer.hide()
 elif corporation_state=="cracking":
  if now>=next_flicker:
   flicker_frames=3; next_flicker=now+4.0+fmod(now,4.0)
  glitch_layer.visible=flicker_frames>0
  flicker_frames=maxi(0,flicker_frames-1)
func build_rig() -> void:
 clear(rig_row)
 clear(program_slots)
 rig_row.add_child(FriendlyLook.label("RACK · CHAIN " + ("/".join(game.enc.get("last_tags",[])) if not game.enc.get("last_tags",[]).is_empty() else "—"), 11, FriendlyLook.PAPER, FriendlyLook.BOLD))
 sync_active_program()
 build_cartridges()
 if ghost_rail: build_ghost_rail()
 if program_connector: program_connector.visible = game.installed.is_empty()
 var shown := game.installed.filter(func(q): return q.inst.uid == active_program)
 for p in shown:
  var id: String = p.inst.id
  var uid: int = p.inst.uid
  var d := CardDB.def(id)
  var slot := VBoxContainer.new()
  slot.name = "ActiveProgram"
  slot.mouse_filter = Control.MOUSE_FILTER_PASS
  slot.add_theme_constant_override("separation", 3)
  program_slots.add_child(slot)

  # 0: the program's name plate; an Icepick's plate is what you drag onto a key.
  var chip: Button
  if d.has("pick"):
   var pick := FriendlyRigChip.new()
   pick.view = self
   pick.uid = uid
   for state in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
    pick.add_theme_color_override(state, FriendlyLook.PAPER)
   chip = pick
  else:
   chip = FriendlyLook.button(d.name, Callable(), FriendlyLook.TONER, FriendlyLook.PAPER)
  chip.text = ("✥ " if d.has("pick") else "") + d.name
  chip.clip_text = true
  chip.mouse_filter = Control.MOUSE_FILTER_STOP
  chip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
  chip.custom_minimum_size.y = 24
  chip.add_theme_font_size_override("font_size", 13)
  crt_chip(chip)
  tip_on_hover(chip, func(): return [big_card(id), d.name, game.card_text(id), "Drag onto a subroutine key to break it." if d.has("pick") else ""])
  chip.pressed.connect(func(): ui.toggle_card_inspection(id, uid))
  chip.mouse_entered.connect(func(): ui.hover_program(id))
  chip.mouse_exited.connect(func(): ui.leave_program())
  slot.add_child(chip)

  # 1: what it does, in big type.
  if d.has("pick"):
   var row := HBoxContainer.new(); row.mouse_filter = Control.MOUSE_FILTER_IGNORE; slot.add_child(row)
   var str_label := FriendlyLook.label("STR %d" % game.pick_str(p), 20, CRT_INK, CONDENSED); str_label.name = "ProgramStr"; row.add_child(str_label)
   var breaks := FriendlyLook.label("breaks\n" + String(d.pick.itype), 10, Color(CRT_INK, 0.85), console_font(2)); breaks.size_flags_horizontal = Control.SIZE_EXPAND_FILL; breaks.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; row.add_child(breaks)
   slot.add_child(FriendlyLook.label("BREAK %d BW · BOOST +%d STR / %d BW" % [d.pick.break_cost, d.pick.boost_amt, d.pick.boost_cost], 10, CRT_INK, console_font(1)))
  else:
   var what := FriendlyLook.label(game.card_text(id), 10, CRT_INK, console_font(1)); what.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; what.custom_minimum_size = Vector2(170, 0); what.max_lines_visible = 3
   slot.add_child(what)

  # 2: actions — boost (Icepicks), uninstall-cache, unload.
  var controls := HBoxContainer.new()
  controls.mouse_filter = Control.MOUSE_FILTER_PASS
  controls.add_theme_constant_override("separation", 4)
  slot.add_child(controls)
  if d.has("pick"):
   var chk := game.can_boost(uid)
   var boost := FriendlyLook.button("+STR  · %d BW" % chk.cost, func(): game.boost_pick(uid); ui.refresh())
   boost.name = "BoostButton"
   boost.disabled = not chk.ok
   boost.size_flags_horizontal = Control.SIZE_EXPAND_FILL
   boost.tooltip_text = "Raise this Icepick's STR by %d for the rest of the encounter." % d.pick.boost_amt
   crt_action(boost)
   controls.add_child(boost)
  elif d.get("uninstall_cache", false):
   var cache_action := FriendlyLook.button("UNINSTALL 1 BW", func(): game.uninstall_cache(uid); ui.refresh())
   cache_action.name = "SmashGrabCache"
   cache_action.disabled = game.bw < 1 or game.hand.is_empty()
   cache_action.size_flags_horizontal = Control.SIZE_EXPAND_FILL
   crt_action(cache_action)
   controls.add_child(cache_action)
  else:
   var spacer := Control.new(); spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL; spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE; controls.add_child(spacer)
  var unload := FriendlyLook.button("×", func(): game.unload(uid); ui.leave_program(); ui.refresh(), FriendlyLook.PAPER)
  unload.name = "UnloadButton"; unload.tooltip_text = "Unload this program"; unload.custom_minimum_size = Vector2(26, 0); crt_action(unload)
  controls.add_child(unload)

  # 3: ◀ n/N ▶ when more than one program is installed.
  if game.installed.size() > 1:
   var nav := HBoxContainer.new(); nav.name = "ProgramNav"; nav.mouse_filter = Control.MOUSE_FILTER_PASS; slot.add_child(nav)
   var prev := FriendlyLook.button("◀", func(): cycle_program(-1)); prev.name = "PrevProgram"; prev.custom_minimum_size = Vector2(34, 22); crt_action(prev); nav.add_child(prev)
   var index := game.installed.find(p)
   var count := FriendlyLook.label("PROGRAM %d / %d" % [index + 1, game.installed.size()], 10, CRT_INK, console_font(2)); count.size_flags_horizontal = Control.SIZE_EXPAND_FILL; count.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; nav.add_child(count)
   var next := FriendlyLook.button("▶", func(): cycle_program(1)); next.name = "NextProgram"; next.custom_minimum_size = Vector2(34, 22); crt_action(next); nav.add_child(next)
 for c in game.rack:
  var d := CardDB.def(c.id)
  rig_row.add_child(FriendlyLook.button(d.name, func(): ui._show_inspect(c.id), FriendlyLook.TONER, FriendlyLook.PAPER))
func build_obj_tip() -> void:
 obj_tip = PanelContainer.new(); obj_tip.name = "ObjectTip"; obj_tip.mouse_filter = Control.MOUSE_FILTER_IGNORE; obj_tip.z_index = 170
 var st := FriendlyLook.style(Color("#F6EFDF"), CONSOLE_CHROME, 3, 12); st.set_content_margin_all(14)
 obj_tip.add_theme_stylebox_override("panel", st)
 paint_panel(obj_tip, "UI_TOOLTIP_PLATE_S", Vector4(34, 40, 26, 40), Vector4(62, 34, 36, 32))   # clear of the plate's chrome and pointer
 add_child(obj_tip); obj_tip.hide()

func show_object_tip(anchor: Control, picture: Control, title: String, body: String, note: String = "") -> void:
 ## HOVER-001: a large picture of the object beside its name and rules, placed next to the
 ## object (never over it) and kept on screen.
 if obj_tip == null: build_obj_tip()
 clear(obj_tip)
 obj_tip_owner = anchor
 var row := HBoxContainer.new(); row.add_theme_constant_override("separation", 14); row.mouse_filter = Control.MOUSE_FILTER_IGNORE; obj_tip.add_child(row)
 ignore_mouse(picture); row.add_child(picture)
 var text := VBoxContainer.new(); text.add_theme_constant_override("separation", 6); text.mouse_filter = Control.MOUSE_FILTER_IGNORE; row.add_child(text)
 text.add_child(FriendlyLook.label(title, 20, IceKey.INK, CONDENSED))
 var rule := FriendlyLook.label(body, 14, IceKey.INK, skin.font); rule.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; rule.custom_minimum_size.x = 260; text.add_child(rule)
 if note != "":
  var n := FriendlyLook.label(note, 13, Color("#4A5355"), skin.bold_font); n.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; n.custom_minimum_size.x = 260; text.add_child(n)
 obj_tip.reset_size(); obj_tip.show()
 await get_tree().process_frame
 if not is_instance_valid(obj_tip) or obj_tip_owner != anchor: return
 obj_tip.reset_size()
 var a := anchor.get_global_rect(); var sz := obj_tip.size; var view_r := Rect2(Vector2(8, 8), Vector2(1584, 984))
 var spots := [Vector2(a.end.x + 10, a.get_center().y - sz.y / 2.0), Vector2(a.get_center().x - sz.x / 2.0, a.end.y + 10),
  Vector2(a.get_center().x - sz.x / 2.0, a.position.y - sz.y - 10), Vector2(a.position.x - sz.x - 10, a.get_center().y - sz.y / 2.0)]
 var pick: Vector2 = spots[0]
 for spot in spots:
  var r := Rect2(spot, sz)
  if view_r.encloses(r) and not r.intersects(a): pick = spot; break
 pick.x = clampf(pick.x, view_r.position.x, view_r.end.x - sz.x); pick.y = clampf(pick.y, view_r.position.y, view_r.end.y - sz.y)
 obj_tip.position = pick

func hide_object_tip(anchor: Control) -> void:
 if obj_tip and obj_tip_owner == anchor: obj_tip.hide(); obj_tip_owner = null

func ignore_mouse(node: Node) -> void:
 if node is Control: (node as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE
 for c in node.get_children(): ignore_mouse(c)

func big_card(id: String, k: float = 1.1) -> Control:
 ## A card face drawn large for a hover box (display-only copy).
 var holder := Control.new(); holder.custom_minimum_size = FriendlyCard.CONCEPT_RECT.size * k + Vector2(0, FriendlyCard.CONCEPT_RECT.position.y * k)
 var card := FriendlyCard.new(); card.setup(self, id, -1); card.scale = Vector2.ONE * k; holder.add_child(card)
 return holder

func tip_on_hover(target: Control, make: Callable) -> void:
 ## Show the HOVER-001 box while the pointer (or keyboard focus) is on target.
 target.tooltip_text = ""
 var show := func(): var parts: Array = make.call(); show_object_tip(target, parts[0], parts[1], parts[2], parts[3] if parts.size() > 3 else "")
 target.mouse_entered.connect(show); target.focus_entered.connect(show)
 target.mouse_exited.connect(func(): hide_object_tip(target)); target.focus_exited.connect(func(): hide_object_tip(target))

func ghostware_list() -> Array:
 ## The Rustler's ORIGIN Ghostware first, then any others the run has picked up.
 var rows := []
 if game == null: return rows
 var r: Dictionary = CardDB.RUSTLERS.get(game.rustler, {})
 if not r.is_empty(): rows.append({"name": String(r.origin), "text": String(r.origin_text), "origin": true})
 for id in game.ghostware:
  rows.append({"name": String(id).replace("_", " "), "text": "", "origin": false})
 return rows

func build_ghost_rail() -> void:
 ## Ghostware badges hang from the copper pipe along the top of the ICE area, left to right,
 ## shrinking to fit when there are many. Roll over a badge to read it.
 if ghost_rail == null:
  ghost_rail = HBoxContainer.new(); ghost_rail.name = "GhostwareRail"; ghost_rail.mouse_filter = Control.MOUSE_FILTER_PASS; ghost_rail.z_index = 40
  ghost_rail.add_theme_constant_override("separation", 4)
  at(self, ghost_rail, Vector2(272, 100), Vector2(1300, 30))
 clear(ghost_rail)
 var rows := ghostware_list()
 if rows.is_empty(): return
 var tag := console_plate("GHOSTWARE", Color("#1A1412"), Analog.CREAM_DIM, 10, console_font(3)); tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
 ghost_rail.add_child(tag)
 var d := clampf((1300.0 - 90.0) / float(rows.size()) - 4.0, 16.0, 28.0)
 for row in rows:
  var badge := Button.new(); badge.name = "Ghostware"; badge.custom_minimum_size = Vector2(d, d); badge.focus_mode = Control.FOCUS_ALL
  badge.tooltip_text = ("ORIGIN GHOSTWARE · " if row.origin else "GHOSTWARE · ") + String(row.name) + ("\n" + String(row.text) if String(row.text) != "" else "")
  var key := String(row.name).to_upper().replace(" ", "_").replace("'", "").replace("’", "")
  var art_path := "res://assets/concept/ghostware/GW_%s.png" % key
  var face := StyleBoxFlat.new(); face.bg_color = Color("#241A14"); face.set_corner_radius_all(int(d)); face.set_border_width_all(2)
  face.border_color = Color("#E0B04A") if row.origin else Color("#9FB7AE")
  for st in ["normal", "hover", "pressed", "focus"]:
   var f := face.duplicate() as StyleBoxFlat
   if st == "hover" or st == "focus": f.border_color = Color("#FFF1C2")
   badge.add_theme_stylebox_override(st, f)
  if ResourceLoader.exists(art_path):
   var icon := TextureRect.new(); icon.texture = load(art_path); icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
   icon.mouse_filter = Control.MOUSE_FILTER_IGNORE; icon.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); badge.add_child(icon)
  else:
   # Placeholder until the painted icon arrives: the Ghostware's initials.
   var initials := "".join(Array(String(row.name).split(" ")).map(func(w): return w.substr(0, 1)))
   badge.text = initials.substr(0, 2); badge.add_theme_font_override("font", console_font(3)); badge.add_theme_font_size_override("font_size", int(d * 0.42))
   badge.add_theme_color_override("font_color", Analog.CREAM); badge.add_theme_color_override("font_hover_color", Color.WHITE)
  ghost_rail.add_child(badge)
  var row_copy: Dictionary = row
  tip_on_hover(badge, func():
   var pic: Control
   if ResourceLoader.exists(art_path):
    var t := TextureRect.new(); t.texture = load(art_path); t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED; t.custom_minimum_size = Vector2(128, 128); pic = t
   else:
    var big := Button.new(); big.custom_minimum_size = Vector2(128, 128); big.text = badge.text; big.add_theme_font_override("font", console_font(3)); big.add_theme_font_size_override("font_size", 48)
    for st in ["normal", "disabled"]:
     var f := (badge.get_theme_stylebox("normal") as StyleBoxFlat).duplicate() as StyleBoxFlat; f.set_corner_radius_all(64); f.set_border_width_all(5); big.add_theme_stylebox_override(st, f)
    big.add_theme_color_override("font_color", Analog.CREAM); pic = big
   return [pic, String(row_copy.name), String(row_copy.text) if String(row_copy.text) != "" else "Effect text arrives with the Ghostware data.", "ORIGIN GHOSTWARE" if row_copy.origin else "GHOSTWARE"])

func build_cap_rack() -> void:
 ## CAPS (UPL rules §1): single-use, outside the deck, 3 slots to start. Empty placeholders until
 ## CAPS are in the build; the rack widens when a Rustler gains more slots.
 cap_rack = Panel.new(); cap_rack.name = "CapRack"; cap_rack.mouse_filter = Control.MOUSE_FILTER_PASS
 var sb := StyleBoxFlat.new(); sb.bg_color = Color(0.08, 0.05, 0.03, 0.7); sb.set_corner_radius_all(8); sb.set_border_width_all(1); sb.border_color = Color("#8A6A3A")
 cap_rack.add_theme_stylebox_override("panel", sb)
 at(self, cap_rack, Vector2(1066, 794), Vector2(76, 154))
 centred("CAPS", 11, Analog.AMBER, console_font(3), Vector2(0, 3), Vector2(76, 14), cap_rack)
 var slot_art := painted("UI_CAP_SLOT")
 var w := (76.0 - 10.0 - 4.0 * float(CAP_SLOTS - 1)) / float(CAP_SLOTS)
 for k in CAP_SLOTS:
  var slot := Panel.new(); slot.name = "CapSlot%d" % k; slot.tooltip_text = "Empty CAP slot. CAPS are single-use: flip, inject, discard. 0 BW, any time in your turn."
  slot.mouse_filter = Control.MOUSE_FILTER_STOP
  if slot_art:
   var st := StyleBoxTexture.new(); st.texture = slot_art; slot.add_theme_stylebox_override("panel", st)
  else:
   var glass := StyleBoxFlat.new(); glass.bg_color = Color("#10201C"); glass.set_corner_radius_all(int(w / 2.0)); glass.set_border_width_all(2); glass.border_color = Color("#6E8C82")
   slot.add_theme_stylebox_override("panel", glass)
  at(cap_rack, slot, Vector2(5.0 + float(k) * (w + 4.0), 20), Vector2(w, 126))
  slot.focus_mode = Control.FOCUS_ALL
  tip_on_hover(slot, func():
   var big := Panel.new(); big.custom_minimum_size = Vector2(60, 240)
   big.add_theme_stylebox_override("panel", slot.get_theme_stylebox("panel"))
   return [big, "EMPTY CAP SLOT", "CAPS are single-use injectable code, outside your deck: flip, inject, discard. 0 BW, any time during your turn.", "Get CAPS at Uplinks, as a Node reward, or as a drop after a BREACH."])

func build_cartridges() -> void:
 ## Each installed program is a slim card pushed into a slot on top of the CRT, like a
 ## cartridge in a player: count the cards to count the programs. The one on screen sticks
 ## out further. Click a card to put it on screen.
 if cart_rack == null: return
 clear(cart_rack)
 var n := game.installed.size()
 if n == 0: return
 var w := 40.0
 var gap := clampf((200.0 - w) / maxf(1.0, float(n - 1)), 0.0, 44.0) if n > 1 else 0.0
 var start := 120.0 - (w + gap * float(n - 1)) / 2.0
 for k in n:
  var p: Dictionary = game.installed[k]
  var d := CardDB.def(p.inst.id)
  var uid: int = p.inst.uid
  var on := uid == active_program
  var cart := TextureButton.new(); cart.name = "Cartridge%d" % k
  var frame_path := "res://assets/concept/cards/CARD_FRAME_%s.png" % String(d.type)
  var frame: Texture2D = load(frame_path) if ResourceLoader.exists(frame_path) else null
  var pic_path := "res://assets/concept/cards/%s.png" % p.inst.id
  cart.texture_normal = frame if frame else null
  cart.ignore_texture_size = true; cart.stretch_mode = TextureButton.STRETCH_SCALE
  var cart_id: String = p.inst.id
  tip_on_hover(cart, func(): return [big_card(cart_id), d.name, game.card_text(cart_id), "On screen." if active_program == uid else "Click to put it on screen."])
  cart.focus_mode = Control.FOCUS_ALL
  cart.pressed.connect(func(): active_program = uid; ui.leave_program(); build_rig())
  if frame == null:
   var plain := Panel.new(); plain.mouse_filter = Control.MOUSE_FILTER_IGNORE
   plain.add_theme_stylebox_override("panel", FriendlyLook.style(Color("#F6F1E4"), Color("#2C7A8C"), 2, 3)); plain.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); cart.add_child(plain)
  if ResourceLoader.exists(pic_path):
   var pic := TextureRect.new(); pic.texture = load(pic_path); pic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
   pic.mouse_filter = Control.MOUSE_FILTER_IGNORE; at(cart, pic, Vector2(4, 11), Vector2(w - 8, 22))
  # the card rises out of the slot: the one on screen by 34 px, the others by 22
  at(cart_rack, cart, Vector2(start + float(k) * (w + gap) if n > 1 else start, 6.0 if on else 17.0), Vector2(w, 56))
  if on:
   var lamp := Analog.lamp(Color("#4DFF6E"), true, 8); lamp.mouse_filter = Control.MOUSE_FILTER_IGNORE; at(cart, lamp, Vector2(w / 2.0 - 4, 1))

func concept_backgrounds(base: CorporationSkin) -> CorporationSkin:
 ## ENC-CONCEPT-001: a corporation's painted backgrounds replace its atrium when delivered
 ## (res://assets/concept/backgrounds/BG_<CORP>_FRIENDLY.png and _HOSTILE.png).
 var friendly := "res://assets/concept/backgrounds/BG_%s_FRIENDLY.png" % base.corporation
 if not ResourceLoader.exists(friendly): return base
 var painted_skin: CorporationSkin = base.duplicate()
 painted_skin.background = load(friendly)
 var hostile := "res://assets/concept/backgrounds/BG_%s_HOSTILE.png" % base.corporation
 if ResourceLoader.exists(hostile): painted_skin.hostile_background = load(hostile)
 return painted_skin

func sync_active_program() -> void:
 var uids: Array = game.installed.map(func(q): return q.inst.uid)
 for uid in uids:
  if not known_programs.has(uid): active_program = uid   # a new install comes to the front
 known_programs = uids
 if not uids.has(active_program): active_program = int(uids[0]) if not uids.is_empty() else -1

func cycle_program(step: int) -> void:
 var uids: Array = game.installed.map(func(q): return q.inst.uid)
 if uids.size() < 2: return
 active_program = int(uids[(uids.find(active_program) + step + uids.size()) % uids.size()])
 ui.leave_program(); build_rig()

func active_pick() -> int:
 ## The active program's uid when it is an Icepick, else -1.
 var p: Dictionary = game._installed_entry(active_program)
 return active_program if not p.is_empty() and CardDB.def(p.inst.id).has("pick") else -1

func crt_action(button: Button) -> void:
 ## A phosphor-green CRT button: dark glass, bright ink, readable when disabled.
 crt_chip(button)
 button.add_theme_font_size_override("font_size", 12)
 button.add_theme_color_override("font_disabled_color", Color(CRT_INK, 0.45))

func build_ice() -> void:
 ice_scroll.position.x = ICE_X
 mascots.clear()
 key_nodes.clear()
 hover_key = {}
 if is_instance_valid(key_tip): key_tip.hide()
 clear(ice_row)
 for i in game.enc.ice.size():
  var two := painted("UI_ICE_CONSOLE_2") != null
  var column := VBoxContainer.new(); column.add_theme_constant_override("separation",0 if two else CONSOLE_OVERLAP); column.custom_minimum_size.x=400 if game.enc.ice.size()==3 else 480; ice_row.add_child(column)
  if two: column.custom_minimum_size.x = console_width()
  var mascot := FriendlyMascot.new()
  mascot.console_two = two
  var prior := previous_mascot(i)
  mascot.previous_mood=prior.get("mood", "")
  mascot.just_broken=not prior.is_empty() and game.enc.ice[i].broken.count(true)>prior.broken.count(true)
  mascot.setup(self,i,mood_for(i))
  mascots.append(mascot)
  # Grow the animated illustration independently from its rules plaque.
  var width := (400.0 if game.enc.ice.size()==3 else 480.0) if not two else console_width()
  # CARDS-004: the mascot stage gives up 44 px so the larger hand fits below.
  # ICE-ANALOG-001: the mascot grows about 18% (as far as the column width allows).
  var illustration_scale := (0.70 if game.enc.ice.size()==3 else 0.82) * 1.25 * (194.0 / 238.0) * MASCOT_GROWTH
  var stage := Control.new()
  stage.name = "MascotStage"
  var plate := AdpCopy.pick("plate", skin.corporation, 0, {"ice": game.enc.ice[i].id})
  var painted_console := painted("UI_ICE_CONSOLE") != null
  var k := width / 960.0
  if two:
   # Concept 2: the painted character fills the cabinet's top-left; a drawn appliance (no art yet)
   # is scaled to stay left of the name and STR slots.
   illustration_scale = (1.37 if mascot.concept_art != null else 0.95) * k
   column.custom_minimum_size.y = ICE_AREA_H - 14.0   # the cabinet's plain foot stretches to the ticker
  stage.custom_minimum_size = Vector2(width, (462.0 if two else 520.0) * k if (two or painted_console) else STAGE_H)
  column.add_child(drop_wrapper(stage,i,-1))
  var frame := ice_frame(width)
  stage.add_child(frame)
  if two or painted_console:
   var min_h := 1000.0 if two else 1100.0
   column.resized.connect(func(): if is_instance_valid(frame): frame.size.y = maxf(min_h, column.size.y / k))
  var carrier := Control.new()
  carrier.name = "IllustrationScale"
  carrier.scale = Vector2.ONE * illustration_scale
  carrier.position = Vector2((width - mascot.size.x * illustration_scale) / 2.0, (508.0 * k - 230.0 * illustration_scale) if painted_console else FRAME_TOP + 16.0)
  if two: carrier.position = Vector2(34.0, 34.0) * k
  stage.add_child(carrier)
  carrier.add_child(mascot)
  # Only the art is pixelated: the layer goes in before the mascot's first child that
  # carries text (status tag, speech bubble), so every text and the graffiti draw on top, crisp.
  var over := pixel_overlay(Vector2.ZERO, mascot.size, false)
  var first_text := -1
  for child in mascot.get_children():
   if child is Label or not child.find_children("*", "Label", true, false).is_empty():
    first_text = child.get_index(); break
  mascot.add_child(over)
  if first_text >= 0: mascot.move_child(over, first_text)
  if game.enc.ice[i].id == "AUTO_RENEW" and mascot.concept_art == null: add_shell_graffiti(mascot)
  if two: console_heading(i, stage, k)
  var scan := scan_tag(i, String(plate.get("text",""))); scan.size_flags_horizontal=Control.SIZE_FILL; column.add_child(scan)
  if mood_for(i)=="knocked_out" and not reduced_motion:
   scan.ready.connect(func(): var peel:=scan.create_tween().set_parallel(true); peel.tween_property(scan,"rotation_degrees",1.5,0.4); peel.tween_property(scan,"position:y",scan.position.y+8,0.4))
func build_hand() -> void:
 var signature := str(game.hand) + str(game.enc.get("last_tags", [])) + str(game.bw) + str(game.amp) + str(game.phase) + str(ui.targeting)
 if signature == hand_signature: return
 hand_signature = signature
 card_positions.clear()
 for old in hand.get_children(): card_positions[old.uid]=old.position
 clear(hand)
 for c in game.hand:
  var card := FriendlyCard.new(); card.setup(self, c.id, c.uid); hand.add_child(card)
 hand.reduced_motion=reduced_motion; hand.arrange()
 if not reduced_motion:
  for c in hand.get_children():
   var destination: Vector2=c.rest_position
   c.position=card_positions.get(c.uid,destination+Vector2(0,7))
   c.motion=c.create_tween(); c.motion.tween_property(c,"position",destination,0.09).set_trans(Tween.TRANS_LINEAR)
func begin_drag(data: Dictionary, source: Control) -> void:
 ui._show_inspect("")
 if data.kind == "pick" and (dragging_uid != int(data.uid) or drag_kind != "pick"): music.play_effect("pick_drag")
 dragging_uid = data.uid; drag_kind = data.kind; drag_source = source; hover_uid = data.uid; drag_description=""
func end_drag() -> void:
 dragging_uid = -1; drag_kind = ""; hover_uid = -1; drag_source = null; drag_description=""
func click_ice(i: int) -> void:
 if game.phase == "CHOICE" and game.pending.get("kind") == "patient_zero": game.choose_ice(i); ui.refresh()
 else: ui._on_ice_clicked(i)
func break_info(i: int, sub: int) -> Dictionary:
 if game.phase == "CHOICE" and game.pending.get("kind") == "card_break": return {"ok": game.card_break_ok(i,sub), "reason": "normal break limits", "cost": 0}
 if game.phase != "PLAYER": return {"ok": false, "reason": "Not your turn", "cost": 0}
 # Clicking a key uses the program on the screen; if it can't, the cheapest Icepick that can.
 var pick := active_pick()
 if pick >= 0:
  var mine := game.break_info(i,sub,pick)
  if mine.ok: return mine
 return game.break_info(i,sub)
func break_action(i: int, sub: int) -> void:
 if game.phase == "CHOICE" and game.pending.get("kind") == "card_break": game.choose_sub(i,sub); ui.refresh()
 else:
  var ice: Dictionary=game.enc.ice[i]; var before: int=ice.break_progress[sub]; var cost: int=game.bw
  var info := break_info(i,sub)
  if info.get("ok", false) and info.has("uid"): active_program = int(info.uid)
  ui._on_break(i,sub,int(info.get("uid",-1)))
  if ice.break_progress[sub]>before: show_break_feedback(ice,sub,cost-game.bw)
func mood_for(i: int) -> String:
 if game.enc.get("breached",false): return "knocked_out"
 var ice: Dictionary = game.enc.ice[i]
 if Game.CORE_LOOP:  # FORM-001: the form follows STR and breaks (rules state), not TRACE
  return game.ice_form(i).to_lower()
 if game.strikes>=2 or game.ice_definition(ice).get("black",false): return "lethal"
 for step in game.response_preview():
  if step.ice != i or step.skipped or step.hidden: continue
  for source in step.effects:
   var e := game.effect_value(ice,source)
   if (e.k=="PULP" and int(e.get("v",0))>=ui.lethal_pulp_threshold) or (e.k=="CORTEX" and int(e.get("v",0))>0): return "lethal"
 return "wary" if game.trace>=20 or ice.broken.has(true) else "cheery"
func biggest_hit() -> int:
 var biggest := 0
 for step in game.response_preview():
  if step.skipped or step.hidden: continue
  for source in step.effects:
   var e := game.effect_value(game.enc.ice[step.ice],source)
   if e.k=="PULP": biggest=maxi(biggest,int(e.get("v",0)))
 return biggest
func new_subs(i: int) -> Array:
 var ice: Dictionary = game.enc.ice[i]
 for item in new_subroutines:
  if is_same(item.ice,ice) and item.turn==game.enc.turn: return item.subs
 return []
func track_new_subs() -> void:
 var current := []
 for i in game.enc.ice.size():
  var subs: Array = new_subs(i).duplicate()
  if ui.tumble.has(i):
   for sub in game.active_subs(i):
    if not ui.tumble[i].has(sub) and not subs.has(sub): subs.append(sub)
  current.append({"ice":game.enc.ice[i],"turn":game.enc.turn,"subs":subs})
 new_subroutines=current
func effect_text(ice: Dictionary, source: Dictionary) -> String:
 var e := game.effect_value(ice,source)
 if e.k == "DEADLOCK": return "DEADLOCK" + (" ×%d" % e.v if e.get("v",1) > 1 else "")
 if e.get("curve", "") == "B": return "PULP %d · RANDOM" % e.v
 if e.k == "BW_DRAIN": return "−%d BW next turn" % e.v
 if e.k == "DISCARD": return "DISCARD %d next turn" % e.v + (" ↑" if e.get("escalate",false) else "")
 if e.k == "INSERT": return "INSERT %d %s → %s" % [e.v,e.card,e.to]
 return ui._effect_word(e) + (" ↑" if e.get("escalate",false) else "")
func rule_chip(text: String, state: String = "normal", plaque: bool = false) -> Control:
 var chip := PanelContainer.new(); chip.mouse_filter=Control.MOUSE_FILTER_PASS
 var bg := FriendlyLook.PAPER; var ink := FriendlyLook.TONER
 if state == "deadlock": bg=FriendlyLook.HIGHLIGHT
 if state == "new": bg=FriendlyLook.RED
 if state in ["broken","hidden"]: bg=Color("#DCE7E3") if state=="broken" else Color("#F8FBF9"); ink=FriendlyLook.MUTED_INK
 var corporate_palette := plaque and skin.corporation!="HALCYON"
 if corporate_palette:
  bg=skin.plaque_ground.darkened(0.035) if state=="broken" else skin.plaque_ground
  ink=skin.plaque_muted if state in ["broken","hidden"] else (skin.plaque_accent if state in ["deadlock","new"] else skin.plaque_ink)
 var is_emphasis := corporate_palette and state in ["deadlock","new"]
 var style := FriendlyLook.style(bg,ink if is_emphasis else Color.TRANSPARENT,1 if is_emphasis else 0)
 style.set_content_margin_all(3); chip.add_theme_stylebox_override("panel",style)
 chip.add_child(FriendlyLook.label(text,14,ink,FriendlyLook.BOLD))
 if state in ["broken","hidden"]:
  chip.draw.connect(func():
   var r := Rect2(Vector2(1,1),chip.size-Vector2(2,2))
   for edge in [[r.position,Vector2(r.end.x,r.position.y)],[Vector2(r.end.x,r.position.y),r.end],[r.end,Vector2(r.position.x,r.end.y)],[Vector2(r.position.x,r.end.y),r.position]]: chip.draw_dashed_line(edge[0],edge[1],ink,1,4))
 if state == "broken":
  var overlay := Control.new(); overlay.mouse_filter=Control.MOUSE_FILTER_IGNORE; chip.add_child(overlay)
  var line := ColorRect.new(); line.color=ink; line.mouse_filter=Control.MOUSE_FILTER_IGNORE; line.anchor_right=1; line.anchor_top=0.5; line.anchor_bottom=0.5; line.offset_top=-1; line.offset_bottom=0; overlay.add_child(line)
  if not reduced_motion:
   overlay.ready.connect(func(): line.scale.x=0.0; var strike:=line.create_tween(); strike.tween_property(line,"scale:x",1.0,0.15))
 return chip
func scan_tag(i: int, plate_text: String = "") -> Control:
 var two := painted("UI_ICE_CONSOLE_2") != null
 ## ENC-CONCEPT-001 (concept 3) with ICE-ANALOG-001 keys: the lower half of the ICE console.
 ## Power lamp and name plate, STR plate, icon keys (+ TUMBLER reel), the passive plate and this
 ## ICE's NEXT RESPONSE plate in full words. Hover or focus a key for its full rule.
 var ice: Dictionary = game.enc.ice[i]; var d := game.ice_definition(ice)
 var panel := PanelContainer.new(); var scan_width:=(400 if game.enc.ice.size()==3 else 480) if not two else int(console_width())
 if two: panel.mouse_filter = Control.MOUSE_FILTER_PASS   # an untargeted SCRIPT dropped on the cabinet still plays
 var k := scan_width / 960.0
 key_u = clampf(k * 1.9, 0.8, 1.45) if two else 1.0
 panel.custom_minimum_size=Vector2(scan_width,0)
 var candidates:=game.hand.filter(func(c): return CardDB.def(c.id).get("zeroed_reduction",0)>0 and game.can_play(c.uid).ok and game.would_zero(i,int(CardDB.def(c.id).get("zeroed_reduction",0))))
 var eligible:=not candidates.is_empty()
 var style := StyleBoxFlat.new(); style.bg_color = console_ground()
 var on_paint := painted("UI_ICE_CONSOLE") != null
 style.border_color = FriendlyLook.AMBER if eligible else CONSOLE_CHROME
 style.border_width_left = 4; style.border_width_right = 4; style.border_width_bottom = 4; style.border_width_top = 0
 style.corner_radius_bottom_left = 22; style.corner_radius_bottom_right = 22
 style.shadow_color = Color("#1A110A66"); style.shadow_size = 8; style.shadow_offset = Vector2(0, 6)
 style.content_margin_left = 16; style.content_margin_right = 16; style.content_margin_top = 8; style.content_margin_bottom = 12
 if on_paint:
  # The painted mint panel shows through; console_ground() is that paint's colour, so text
  # contrast is still checked against what the player sees.
  style.draw_center = false; style.set_border_width_all(0); style.shadow_size = 0
  style.content_margin_left = 30.0 * scan_width / 480.0; style.content_margin_right = style.content_margin_left; style.content_margin_bottom = 30
  if eligible: style.set_border_width_all(3); style.border_color = FriendlyLook.AMBER
 if two:
  # Keys centred in the recessed band (the speaker grille keeps the band's left end).
  var bank_h := (IceKey.KEY + IceKey.LAMP_H + IceKey.CHIP_H + 4.0) * key_u
  style.content_margin_left = 50.0 * k; style.content_margin_right = 52.0 * k
  style.content_margin_top = 3.0 * k + maxf(0.0, (233.0 * k - bank_h) / 2.0); style.content_margin_bottom = 40.0 * k
 panel.add_theme_stylebox_override("panel",style)
 if eligible: panel.tooltip_text="ZEROED available: "+" / ".join(candidates.map(func(c): return CardDB.def(c.id).name))
 var list := VBoxContainer.new(); list.add_theme_constant_override("separation",6); panel.add_child(list)
 var heading := HBoxContainer.new(); heading.add_theme_constant_override("separation",6); list.add_child(heading)
 if two: heading.visible = false   # name, STR and type sit in the cabinet's top-right slots (console_heading)
 var power := Analog.lamp(Color("#4DFF6E") if not game.enc.get("breached",false) else Color("#3A3632"), not game.enc.get("breached",false), 14)
 power.size_flags_vertical = Control.SIZE_SHRINK_CENTER; heading.add_child(power)
 heading.add_child(console_plate(d.name.to_upper(),CONSOLE_GLASS,CONSOLE_CREAM,20,console_font(2)))
 var gap := Control.new(); gap.size_flags_horizontal=Control.SIZE_EXPAND_FILL; heading.add_child(gap)
 heading.add_child(console_plate("STR %d" % game.ice_str(i),CONSOLE_CREAM,CONSOLE_INK,20,console_font(1)))
 var delta: int = game.ice_str(i)-int(d.str)
 if delta!=0: heading.add_child(console_plate(("↑%d" if delta>0 else "↓%d") % absi(delta),Color("#2F7A4C") if delta>0 else Color("#B3261A"),Color.WHITE,16,console_font(0)))
 var meta := FriendlyLook.label(" · ".join([d.type,d.get("subtype", "")]).trim_suffix(" · "),12,console_ink(),console_font(3))
 list.add_child(meta)
 if two: meta.visible = false
 if ice.get("zeroed",false): list.add_child(FriendlyLook.label("ZEROED · chance consumed",11,console_ink()))
 var bank := HBoxContainer.new(); bank.alignment=BoxContainer.ALIGNMENT_CENTER; bank.add_theme_constant_override("separation",2)
 if two:
  var band := MarginContainer.new(); band.name = "KeyBand"; band.add_theme_constant_override("margin_left", int(220.0 * k)); band.mouse_filter = Control.MOUSE_FILTER_PASS
  band.custom_minimum_size.y = (IceKey.KEY + IceKey.LAMP_H + IceKey.CHIP_H + 4.0) * key_u
  list.add_child(band); band.add_child(bank)
 else: list.add_child(bank)
 var active: Array = game.active_subs(i)
 var shown: Array = []
 if d.type == "TUMBLER": shown = active.duplicate()
 else:
  for s in d.subs.size(): shown.append(s)
 for n in shown.size():
  var s: int = shown[n]
  if n>0: bank.add_child(chevron())
  var key := build_key(i,s)
  var slot: int = active.find(s)
  var wrapped := key_wrapper(key,i,s)
  if d.type=="TUMBLER" and slot>=0 and ui.spin.has(i) and not reduced_motion: bank.add_child(ui._reel(wrapped,null,slot,true))
  elif d.type=="TUMBLER" and slot>=0 and ui.tumble.has(i) and not reduced_motion: bank.add_child(ui._tumble_reel(i,slot,s,wrapped))
  else: bank.add_child(wrapped)
 if d.type == "TUMBLER":
  # The reel column: the rest of the pool, spent subroutines struck through, unseen ones as "?".
  var reel := PanelContainer.new(); var rs := FriendlyLook.style(CONSOLE_GLASS,CONSOLE_CHROME,3,10); rs.set_content_margin_all(5); reel.add_theme_stylebox_override("panel",rs)
  paint_panel(reel, "UI_REEL_WINDOW_S", Vector4(12, 16, 12, 16), Vector4(9, 12, 9, 12))
  reel.size_flags_vertical=Control.SIZE_SHRINK_CENTER
  var column := GridContainer.new(); column.columns=2; column.add_theme_constant_override("h_separation",3); column.add_theme_constant_override("v_separation",3); reel.add_child(column)
  var any := false
  for s in d.subs.size():
   if active.has(s): continue
   if not ice.seen[s] and not ice.broken[s]: continue
   column.add_child(build_key(i,s,true)); any=true
  for h in game.hidden_count(i):
   var q := IceKey.new(); q.configure("HIDDEN","","hidden","",true); q.tooltip_text="Hidden in the pool until it tumbles in"; q.mouse_filter=Control.MOUSE_FILTER_PASS; column.add_child(q); any=true
  if any:
   var spacer := Control.new(); spacer.custom_minimum_size.x=10; bank.add_child(spacer); bank.add_child(reel)
 var passive_text := String(d.get("ability_text",""))
 var plate_w := scan_width - 2.0 * style.content_margin_left - 4.0
 if two:
  # Drop below the band to the cabinet's plain foot (y710 of 1000).
  var foot := Control.new(); foot.custom_minimum_size.y = maxf(4.0, 130.5 * k - (IceKey.KEY + IceKey.LAMP_H + IceKey.CHIP_H + 4.0) * key_u / 2.0 - 12.0); foot.mouse_filter = Control.MOUSE_FILTER_IGNORE; list.add_child(foot)
 if not passive_text.is_empty(): list.add_child(cream_plate("PASSIVE: " + passive_text, plate_w, "PassivePlate"))
 list.add_child(cream_plate("NEXT RESPONSE: " + response_words(i), plate_w, "NextResponse"))
 if not ice.virus.is_empty():
  var counts := []
  for strain in ice.virus:
   if ice.virus[strain]>0: counts.append("%s %d" % [strain,ice.virus[strain]])
  var strains := FriendlyLook.label(" · ".join(counts),12,Color("#7A1208"),console_font(1)); strains.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; list.add_child(strains)
  if game.worm_ok(i): list.add_child(FriendlyLook.button("SPEND 2 WORM · BREAK 1",func(): game.use_worm(i); ui.refresh()))
 if game.pending.get("kind")=="patient_zero": list.add_child(FriendlyLook.button("INFECT THIS ICE",func(): game.choose_ice(i); ui.refresh()))
 key_u = 1.0
 if not plate_text.is_empty() and game.enc.ice.size() < 3:
  # The ADP-2c patent plate sits at the foot of the console.
  var plaque := FriendlyLook.label(plate_text, 9, console_ink(), skin.font); plaque.name="PatentPlate"
  plaque.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; plaque.clip_text=true; plaque.custom_minimum_size.x=plate_w
  list.add_child(plaque)
 return panel

const CONSOLE_INK := Color("#1F3A33")
const FRAME_TOP := 14.0

## ENC-CONCEPT-001 console colour (designer 2026-11-20: "yes add console colour"): each corporation's
## ICE consoles in its own enamel. Painted per-corporation art (UI_ICE_CONSOLE_2_<CORP>.png) wins;
## until it exists, console_tint.gdshader repaints the seafoam console. HALCYON keeps seafoam.
const CONSOLE_ENAMEL := {"IRONWATCH": Color("#1F3A5F"), "LUCIDA": Color("#C9B6F2")}
const CONSOLE_TINT := preload("res://themes/console_tint.gdshader")

func console_art() -> Texture2D:
 return painted("UI_ICE_CONSOLE_2_" + skin.corporation) if painted("UI_ICE_CONSOLE_2_" + skin.corporation) else painted("UI_ICE_CONSOLE_2")

func console_tint_material() -> ShaderMaterial:
 if painted("UI_ICE_CONSOLE_2_" + skin.corporation) or not CONSOLE_ENAMEL.has(skin.corporation): return null
 var m := ShaderMaterial.new(); m.shader = CONSOLE_TINT; m.set_shader_parameter("target", CONSOLE_ENAMEL[skin.corporation])
 return m

func console_ink() -> Color:
 ## Text straight on the console's enamel: dark ink on light enamel, cream on dark (navy).
 return CONSOLE_CREAM if console_ground().get_luminance() < 0.35 else CONSOLE_INK

func console_ground() -> Color:
 ## The console's enamel: the corporation's plaque ground tinted toward its accent (HALCYON: seafoam).
 if painted("UI_ICE_CONSOLE_2") != null: return CONSOLE_ENAMEL.get(skin.corporation, Color("#93BBA4"))   # #93BBA4: UI_ICE_CONSOLE_2's plain panel
 if painted("UI_ICE_CONSOLE") != null: return Color(143.0 / 255.0, 178.0 / 255.0, 144.0 / 255.0)   # sampled from UI_ICE_CONSOLE's lower panel
 return skin.plaque_ground.lerp(skin.accent, 0.42)

func cream_plate(text: String, width: float, plate_name: String) -> PanelContainer:
 var px := 15 if painted("UI_ICE_CONSOLE_2") != null and width > 500.0 else 12
 var plate := PanelContainer.new(); plate.name = plate_name; plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
 var st := FriendlyLook.style(CONSOLE_CREAM, Color("#C9B796"), 1, 8); st.content_margin_left = 10; st.content_margin_right = 10; st.content_margin_top = 4 if px < 14 else 7; st.content_margin_bottom = 4 if px < 14 else 7
 plate.add_theme_stylebox_override("panel", st)
 var label := FriendlyLook.label(text, px, CONSOLE_INK, skin.medium_font)
 label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; label.custom_minimum_size.x = width - 20
 plate.add_child(label)
 return plate

func response_words(i: int) -> String:
 ## This ICE's part of the next Corporation Response, in the rules engine's words.
 var steps := []
 for step in game.response_preview():
  if step.ice != i or step.skipped: continue
  if step.hidden: steps.append("? HIDDEN"); continue
  var words := []
  for e in step.effects: words.append(effect_text(game.enc.ice[i], e))
  steps.append(" + ".join(words))
 return " → ".join(steps) if not steps.is_empty() else "nothing"

func console_width() -> float:
 return 470.0 if game.enc.ice.size() >= 3 else 700.0

func ice_frame(width: float) -> Control:
 var two_art := painted("UI_ICE_CONSOLE_2")
 if two_art:
  # Concept 2's cabinet: the character stands top-left, name and STR slots top-right, the keys
  # in the recessed band (y465–698 of 1000), the plates below; only the plain foot stretches.
  var cab := NinePatchRect.new(); cab.name = "IceFrame"; cab.texture = console_art(); cab.mouse_filter = Control.MOUSE_FILTER_IGNORE
  cab.material = console_tint_material()
  cab.patch_margin_left = 60; cab.patch_margin_right = 60; cab.patch_margin_top = 720; cab.patch_margin_bottom = 60
  var kk := width / 960.0
  cab.scale = Vector2(kk, kk); cab.size = Vector2(960, 1000)
  return cab
 var console_art := painted("UI_ICE_CONSOLE")
 if console_art:
  # The painted console spans the whole column (mascot window on top, keys and plates below);
  # it scales to the column width and stretches only through its plain lower panel.
  var patch := NinePatchRect.new(); patch.name = "IceFrame"; patch.texture = console_art; patch.mouse_filter = Control.MOUSE_FILTER_IGNORE
  patch.patch_margin_left = 60; patch.patch_margin_right = 60; patch.patch_margin_top = 530; patch.patch_margin_bottom = 90
  var k := width / 960.0
  patch.scale = Vector2(k, k); patch.size = Vector2(960, 1100)
  return patch
 return ice_frame_drawn(width)

func ice_frame_drawn(width: float) -> Control:
 ## The top half of the console: an enamel body with a chrome rim, rivets and an arched corporate tab.
 var frame := Control.new(); frame.name = "IceFrame"; frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
 frame.size = Vector2(width, STAGE_H + 60.0); frame.position = Vector2.ZERO
 var ground := console_ground()
 var corp := skin.corporation
 var font: Font = skin.bold_font
 frame.draw.connect(func():
  var body := Rect2(Vector2(0, FRAME_TOP), Vector2(width, STAGE_H + 60.0 - FRAME_TOP))
  var rim := StyleBoxFlat.new(); rim.bg_color = ground; rim.border_color = CONSOLE_CHROME; rim.border_width_left = 4; rim.border_width_right = 4; rim.border_width_top = 4; rim.border_width_bottom = 0
  rim.corner_radius_top_left = 28; rim.corner_radius_top_right = 28; rim.anti_aliasing = true
  rim.shadow_color = Color("#1A110A55"); rim.shadow_size = 8
  frame.draw_style_box(rim, body)
  var window := StyleBoxFlat.new(); window.bg_color = ground.darkened(0.12); window.corner_radius_top_left = 22; window.corner_radius_top_right = 22; window.anti_aliasing = true
  frame.draw_style_box(window, Rect2(Vector2(14, FRAME_TOP + 14), Vector2(width - 28, STAGE_H - FRAME_TOP - 6)))
  for q in [Vector2(14, FRAME_TOP + 20), Vector2(width - 14, FRAME_TOP + 20)]:
   frame.draw_circle(q, 4, Color("#9AA2A4")); frame.draw_circle(q - Vector2(1, 1), 2, Color("#F4F6F6"))
  var tw := font.get_string_size(corp, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x + 36
  var tab := StyleBoxFlat.new(); tab.bg_color = ground.lightened(0.18); tab.border_color = CONSOLE_CHROME; tab.set_border_width_all(3)
  tab.corner_radius_top_left = 14; tab.corner_radius_top_right = 14; tab.anti_aliasing = true
  frame.draw_style_box(tab, Rect2(Vector2((width - tw) / 2.0, 0), Vector2(tw, 26)))
  frame.draw_string(font, Vector2((width - tw) / 2.0 + 18, 19), corp, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, CONSOLE_INK))
 return frame

const CONSOLE_GLASS := Color("#1A1714")
const CONSOLE_CREAM := Color("#F4ECDA")
const CONSOLE_CHROME := Color("#A9B3B6")
const CONDENSED = preload("res://assets/fonts/BarlowCondensed-Bold.ttf")
## Approved corporate captions per subroutine (VIS-001 §2.6), shown in the key tooltip.
const KEY_FLAVOUR := {"AUTO_RENEW": ["Basic plan", "Plus plan", "Premium plan"], "CAPTCHA": ["Select every traffic light"]}
var key_tip: PanelContainer
var key_tip_list: VBoxContainer
var hover_key := {}
var key_nodes := {}

func console_font(spacing: int) -> Font:
 var f := FontVariation.new(); f.base_font = CONDENSED; f.spacing_glyph = spacing
 return f

func console_plate(text: String, bg: Color, ink: Color, px: int, font: Font) -> PanelContainer:
 var plate := PanelContainer.new(); plate.mouse_filter=Control.MOUSE_FILTER_IGNORE
 var st: StyleBox = null
 var art := ""
 if bg == CONSOLE_GLASS or bg == Color("#14070A") or bg == Color("#2A0606"): art = "UI_PLATE_DARK_S"
 elif bg == CONSOLE_CREAM: art = "UI_PLATE_CREAM_S"
 elif bg == Color("#2F7A4C"): art = "UI_PILL_GREEN_S" if px >= 16 and text.length() > 6 else "UI_BADGE_UP_S"
 elif bg == Color("#B3261A"): art = "UI_PILL_RED_S" if px >= 16 and text.length() > 6 else "UI_BADGE_DOWN_S"
 if not art.is_empty():
  var badge := art.begins_with("UI_BADGE")
  st = painted_box(art, Vector4(10, 9, 10, 9) if badge else Vector4(16, 9, 16, 9), Vector4(9, 2, 9, 2) if badge else Vector4(14, 3, 14, 3))
 if st == null:
  var flat := FriendlyLook.style(bg,Color.TRANSPARENT,0,6); flat.content_margin_left=9; flat.content_margin_right=9; flat.content_margin_top=1; flat.content_margin_bottom=1
  st = flat
 plate.add_theme_stylebox_override("panel",st)
 plate.add_child(FriendlyLook.label(text,px,ink,font))
 return plate

func chevron() -> Control:
 var u := key_u
 var c := Control.new(); c.custom_minimum_size=Vector2(12,60) * u; c.mouse_filter=Control.MOUSE_FILTER_IGNORE
 c.draw.connect(func():
  var y := (14.0+30.0) * u
  c.draw_colored_polygon(PackedVector2Array([Vector2(3,y-6) * Vector2(1, 1),Vector2(10*u,y),Vector2(3,y+6)]),Color("#B07A2A")))
 return c

func key_effects(ice: Dictionary, s: int) -> Array:
 var out := []
 for source in game.ice_definition(ice).subs[s]: out.append(game.effect_value(ice,source))
 return out

func build_key(i: int, s: int, mini: bool = false) -> IceKey:
 var ice: Dictionary = game.enc.ice[i]; var d := game.ice_definition(ice)
 var key := IceKey.new()
 var effects := key_effects(ice,s)
 var hidden: bool = not ice.seen[s]
 var main := {}
 for e in effects:
  if e.k != "DEADLOCK": main = e; break
 var has_lock := Game._has_deadlock(d.subs[s])
 var kind := "DEADLOCK" if main.is_empty() else String(main.k)
 var value := ""
 if not main.is_empty() and main.has("v"): value = ("−%d" if kind=="BW_DRAIN" else "%d") % int(main.v)
 if kind=="DEADLOCK" and Game.deadlock_steps(d.subs[s])>1: value="%d/%d" % [ice.break_progress[s],Game.deadlock_steps(d.subs[s])]
 var state := "ready"
 if ice.broken[s]: state="broken"
 elif hidden: state="hidden"
 elif not mini:
  var loud := false
  if kind=="PULP" and main.get("curve","")!="B" and int(main.get("v",0))==biggest_hit() and biggest_hit()>0: loud=true
  if loud: state="hit"
  elif new_subs(i).has(s): state="new"
 var chip := ""
 if not mini and not ice.broken[s] and not hidden:
  var info := break_info(i,s)
  chip = ("FREE" if int(info.get("cost",0))==0 else "%d BW" % info.cost) if info.ok else "—"
  key.locked = String(info.get("reason","")).begins_with("LOCKED")
 key.configure(kind,value,state,chip,mini,key_u)
 if not mini:
  if not key_nodes.has(i): key_nodes[i] = {}
  key_nodes[i][s] = key
  key.firing = ui._is_flash(ice,s)
  if has_lock and kind!="DEADLOCK": key.badge="lock"
  elif key.locked: key.badge="lock"
  elif main.get("curve","")=="B": key.badge="dice"
  elif main.get("curve","")=="C": key.badge="hammer"
  elif main.get("escalate",false): key.badge="up"
  key.extra = maxi(0, effects.filter(func(e): return e.k!="DEADLOCK").size()-1)
 else:
  key.tooltip_text = key_rule_lines(i,s)[0]
  key.mouse_filter = Control.MOUSE_FILTER_PASS
 return key

func key_wrapper(key: IceKey, i: int, s: int) -> Control:
 var wrap := drop_wrapper(key,i,s)
 var drop: FriendlyDropTarget = wrap.get_child(1)
 drop.tooltip_text = ""   # the key tip replaces the native tooltip
 drop.focus_mode = Control.FOCUS_ALL
 drop.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
 var ice: Dictionary = game.enc.ice[i]
 var show := func():
  key.lit = true; key.queue_redraw()
  var j: int = game.enc.ice.find(ice)
  if j >= 0:
   hover_key = {"ice": ice, "sub": s, "pos": key.get_global_rect().get_center()}
   show_key_tip(j, s, key.get_global_rect())
 var hide := func():
  if drop.has_focus() or drop.get_global_rect().has_point(get_global_mouse_position()): return
  key.lit = false; key.queue_redraw()
  if hover_key.get("sub",-1)==s and is_same(hover_key.get("ice"),ice): hover_key = {}; key_tip.hide()
 drop.mouse_entered.connect(show); drop.focus_entered.connect(show)
 drop.mouse_exited.connect(hide)
 drop.focus_exited.connect(hide)
 return wrap

func key_rule_lines(i: int, s: int) -> Array:
 ## [title, rule lines...] in the rules engine's own words.
 var ice: Dictionary = game.enc.ice[i]; var d := game.ice_definition(ice)
 if not ice.seen[s] and not ice.broken[s]: return ["? HIDDEN", "Revealed when it fires."]
 var words := []; var rules := []
 for source in d.subs[s]:
  var e := game.effect_value(ice,source)
  words.append(effect_text(ice,source))
  rules.append(effect_rule(e))
 return [" + ".join(words)] + rules

func effect_rule(e: Dictionary) -> String:
 var v := int(e.get("v",0))
 var t := ""
 match String(e.k):
  "PULP": t = "Lose %d VITAE (SHIELD blocks)." % v
  "TRACE": t = "Gain %d TRACE." % v
  "DEADLOCK": t = "Blocks BREACH until broken."
  "DISCARD": t = "Discard %d card%s at the start of your next turn." % [v, "" if v==1 else "s"]
  "INSERT": t = "Put %d %s into your %s." % [v, e.get("card",""), String(e.get("to","draw pile")).replace("_"," ")]
  "BW_DRAIN": t = "You have %d less BW next turn." % v
  "CORTEX": t = "Gain %d CORTEX (−1 DRAW each)." % v
  "FORGET": t = "%d random non-CACHED card%s in your hand go to the bottom of your draw pile." % [v, "" if v==1 else "s"]
  # PT11-UI: the SUB-001 / RIDER-001 / AMEND-001 effects in plain words
  "HARDEN": t = "HARDEN: this ICE gains %d STR for the rest of the encounter." % v
  "SHIELD_BREAK": t = "SHIELD BREAK: your SHIELD drops to 0 when this fires, so PULP after it hits in full."
  "RETALIATE": t = "RETALIATE: PULP %d for each subroutine already broken on this ICE (now PULP %d)." % [v, int(e.get("dmg", 0))]
  "AMEND": t = "AMEND: this response, the ICE to its right deals +%d on each of its PULP subroutines." % v
  _: t = ui._effect_word(e)
 if e.k == "TRACE" and not e.get("then", []).is_empty():
  var riders := []
  for r in e.then: riders.append(ui._effect_word(r))
  t += " If any of this TRACE lands (not stopped by JAMMER, GHOST SIGNAL or PROXY CHAIN), also: %s." % ", ".join(riders)
 if e.get("curve","")=="B": t += " Random roll."
 if e.get("curve","")=="C": t += " Hammer curve."
 if e.get("escalate",false): t += " Grows each response."
 return t

func build_key_tip() -> void:
 key_tip = PanelContainer.new(); key_tip.name="KeyTip"; key_tip.mouse_filter=Control.MOUSE_FILTER_IGNORE; key_tip.z_index=160
 var st := FriendlyLook.style(Color("#F6EFDF"),CONSOLE_CHROME,3,12); st.set_content_margin_all(14); st.shadow_color=Color("#1A110A66"); st.shadow_size=10; st.shadow_offset=Vector2(0,6)
 key_tip.add_theme_stylebox_override("panel",st)
 paint_panel(key_tip, "UI_TOOLTIP_PLATE_S", Vector4(34, 40, 26, 40), Vector4(50, 30, 32, 28))
 # HOVER-001: the key, drawn large, beside its rule.
 var row := HBoxContainer.new(); row.add_theme_constant_override("separation", 14); key_tip.add_child(row)
 key_tip_image = CenterContainer.new(); key_tip_image.name = "KeyTipImage"; key_tip_image.custom_minimum_size = Vector2(150, 0); row.add_child(key_tip_image)
 key_tip_list = VBoxContainer.new(); key_tip_list.add_theme_constant_override("separation",5); row.add_child(key_tip_list)
 add_child(key_tip); key_tip.hide()

func show_key_tip(i: int, s: int, anchor: Rect2) -> void:
 if dragging_uid >= 0: return   # the drag header already explains a drop
 clear(key_tip_list)
 clear(key_tip_image)
 var small_key = key_nodes.get(i, {}).get(s)
 if small_key and is_instance_valid(small_key):
  var big := IceKey.new(); big.configure(small_key.kind, small_key.value, small_key.state, small_key.cost, false, 2.2)
  big.badge = small_key.badge; big.extra = small_key.extra; big.locked = small_key.locked; big.firing = small_key.firing
  big.mouse_filter = Control.MOUSE_FILTER_IGNORE; key_tip_image.add_child(big)
 var ice: Dictionary = game.enc.ice[i]; var d := game.ice_definition(ice)
 var lines := key_rule_lines(i,s)
 var slot: int = game.active_subs(i).find(s)
 var where := ("SLOT %d · S%d" % [slot+1,s+1]) if d.type=="TUMBLER" and slot>=0 else "S%d" % (s+1)
 key_tip_list.add_child(FriendlyLook.label(where + "  ·  " + d.name, 12, Color("#6B5A44"), skin.bold_font))
 key_tip_list.add_child(FriendlyLook.label(lines[0], 22, IceKey.INK, CONDENSED))
 # Every effect of the subroutine, one row each with its own icon: a key shows one icon, but a
 # subroutine can do more than that (HOVER-001, designer 2026-11-20).
 key_tip_list.add_child(FriendlyLook.label("Rule:", 12, Color("#6B5A44"), skin.bold_font))
 if not ice.seen[s] and not ice.broken[s]:
  var hid := FriendlyLook.label(" ".join(lines.slice(1)), 14, IceKey.INK, skin.font); hid.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; hid.custom_minimum_size.x=300; key_tip_list.add_child(hid)
 else:
  for source in d.subs[s]:
   var e := game.effect_value(ice, source)
   var effect_row := HBoxContainer.new(); effect_row.add_theme_constant_override("separation", 8); effect_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
   var icon_name := "ICON_" + String(e.k)
   var icon_tex := IceKey.art(icon_name)
   if icon_tex:
    var ic := TextureRect.new(); ic.texture = icon_tex; ic.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; ic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED; ic.custom_minimum_size = Vector2(26, 26); effect_row.add_child(ic)
   else:
    effect_row.add_child(FriendlyLook.label("•", 16, IceKey.INK, CONDENSED))
   var line := FriendlyLook.label(effect_rule(e), 14, IceKey.INK, skin.font); line.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; line.custom_minimum_size.x=266; effect_row.add_child(line)
   key_tip_list.add_child(effect_row)
 # What else touches this subroutine: multi-step DEADLOCK, BOOTING, TUMBLE, the ICE's passive.
 var also := []
 if Game.deadlock_steps(d.subs[s]) > 1: also.append("Takes %d breaks to open (%d done)." % [Game.deadlock_steps(d.subs[s]), ice.break_progress[s]])
 var lock_info := break_info(i, s)
 if String(lock_info.get("reason", "")).begins_with("LOCKED"): also.append(String(lock_info.reason) + ".")
 if d.type == "TUMBLER": also.append("TUMBLE: when a subroutine is broken it drops out and the others slide along; the next one tumbles in.")
 if String(d.get("ability_text", "")) != "": also.append("This ICE: " + String(d.ability_text))
 for extra_line in also:
  var al := FriendlyLook.label(extra_line, 13, Color("#4A5355"), skin.font); al.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; al.custom_minimum_size.x=300; key_tip_list.add_child(al)
 var timing := "Broken." if ice.broken[s] else ("Fires in the next Corporation Response." if game.is_active(i,s) else "Not in a slot this turn.")
 key_tip_list.add_child(FriendlyLook.label("Timing: " + timing, 14, IceKey.INK, skin.font))
 if not ice.broken[s] and ice.seen[s]:
  var info := break_info(i,s)
  var text := ("Break: %s" % ("free" if int(info.get("cost",0))==0 else "%d BW" % info.cost)) if info.ok else "Break: " + String(info.get("reason","not now"))
  if info.ok and info.has("uid"):
   var used: Dictionary = game._installed_entry(int(info.uid))
   if not used.is_empty(): text += " with " + CardDB.def(used.inst.id).name + (" (+%d boost)" % info.boosts if int(info.get("boosts",0)) > 0 else "")
  var passive := String(d.get("passive",""))
  if info.ok and passive=="TRIPWIRE": text += " · +1 TRACE (TRIPWIRE)"
  if info.ok and info.has("margin"): text += " · margin %d" % info.margin
  var b := FriendlyLook.label(text, 14, IceKey.INK if info.ok else Color("#9C1F15"), skin.bold_font); b.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; b.custom_minimum_size.x=300; key_tip_list.add_child(b)
 var flavour: Array = KEY_FLAVOUR.get(ice.id, [])
 if s < flavour.size():
  key_tip_list.add_child(FriendlyLook.label("“%s” — %s" % [flavour[s], skin.corporation], 13, Color("#4A5355"), skin.font))
 key_tip.reset_size()
 await get_tree().process_frame
 if not is_instance_valid(key_tip): return
 key_tip.reset_size()
 var local := get_global_transform().affine_inverse() * anchor.position
 var local_end := get_global_transform().affine_inverse() * anchor.end
 # Above the key, over the mascot art, so no other key, rule or card is covered;
 # to the side only when there is no room above.
 var x := clampf((local.x + local_end.x) / 2.0 - key_tip.size.x / 2.0, 10.0, 1590.0 - key_tip.size.x)
 var y := local.y - 12.0 - key_tip.size.y
 if y < 8.0:
  var right := local_end.x + 14.0 + key_tip.size.x <= 1590.0
  x = local_end.x + 14.0 if right else local.x - 14.0 - key_tip.size.x
  y = clampf((local.y + local_end.y) / 2.0 - key_tip.size.y / 2.0, 8.0, 612.0 - key_tip.size.y)
 key_tip.position = Vector2(x, y)
 key_tip.show()

func mascot_focus(index: int) -> Vector2:
 ## Where a mascot looks: at the key it is about to fire, else at its key under the pointer.
 if index >= game.enc.ice.size(): return Vector2.INF
 var ice: Dictionary = game.enc.ice[index]
 for s in game.ice_definition(ice).subs.size():
  if ui._is_flash(ice,s) and key_nodes.has(index) and key_nodes[index].has(s) and is_instance_valid(key_nodes[index][s]): return key_nodes[index][s].get_global_rect().get_center()
 if not hover_key.is_empty() and is_same(hover_key.ice, ice): return hover_key.pos
 return Vector2.INF

func reset_session() -> void:
 feedback_until=0; feedback_message=""; end_drag(); mascot_history.clear(); card_positions.clear(); last_encounter={}; last_turn=-1; previous_trace=0; previous_strikes=0; warned=false; strike_until=0; toast_until=0; new_subroutines.clear(); hand_signature=""
 music.set_active(false)
 bleed = 0.0; bleed_from = 0.0; bleed_target = 0.0; bleed_elapsed = 0.0
 pixel_target = {}  # a new encounter snaps to its step without a transition
 if is_instance_valid(strike_overlay): strike_overlay.hide()
 reset_voice()
 hesitation_cooldown = 0.0
 hesitation_index.clear()
 last_punches = []
 arrival_until = 0.0
func update_corporation() -> void:
 var now := Time.get_ticks_msec()/1000.0
 state_before_refresh=corporation_state
 corporation_state="mask_off" if game.strikes>=2 else ("cracking" if game.trace>=20 or game.strikes==1 else "friendly")
 if not warned and previous_trace<20 and game.trace>=20:
  warned=true
  show_voice_toast(skin.cracking_copy, now)
 if game.strikes>previous_strikes: music.play_strike()
 if game.strikes==1 and previous_strikes==0:
  strike_until=now+2.5; build_strike(); strike_overlay.show()
  if not reduced_motion: strike_flash()
 if game.strikes>=2: strike_overlay.hide()
 previous_trace=game.trace; previous_strikes=game.strikes
 update_bleed_target()
 apply_background()
func pixel_overlay(pos: Vector2, area: Vector2, full: bool) -> Control:
 var holder := Control.new(); holder.name = "TracePixel"; holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
 var copy := BackBufferCopy.new(); copy.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT; holder.add_child(copy)
 var rect := ColorRect.new(); rect.material = pixel_material; rect.mouse_filter = Control.MOUSE_FILTER_IGNORE; holder.add_child(rect)
 if full:
  holder.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 else:
  holder.position = pos; holder.size = area; rect.size = area
 pixel_layers = pixel_layers.filter(func(c): return is_instance_valid(c))
 holder.visible = false
 pixel_layers.append(holder)
 update_pixel()
 return holder
func update_pixel() -> void:
 if pixel_material == null or game == null: return
 var step := AtomicDecoPunk.pixel_step(game.trace, game.strikes, is_instance_valid(strike_overlay) and strike_overlay.visible)
 if step == pixel_target:
  apply_pixel(pixel_shown)  # new layers (a rebuilt ICE row) pick up the current look
  return
 var first := pixel_target.is_empty()
 pixel_target = step
 if pixel_tween: pixel_tween.kill()
 if first or reduced_motion or pixel_shown.is_empty():
  apply_pixel(step)
  return
 # PIXEL-TRACE-001 transition: a short glitch spike to coarser cells and fewer colours,
 # then settle on the new step. Reduced motion changes at once.
 var cfg: Dictionary = AtomicDecoPunk.settings.pixel_transition
 var from := pixel_shown.duplicate()
 var peak := {"cell": maxf(from.cell, step.cell) + float(cfg.spike_cells), "levels": maxf(minf(from.levels, step.levels) * float(cfg.spike_levels), 4.0), "dither": 1.0}
 pixel_tween = create_tween()
 pixel_tween.tween_method(func(t: float): apply_pixel(blend_pixel(from, peak, t)), 0.0, 1.0, float(cfg.spike_seconds))
 pixel_tween.tween_method(func(t: float): apply_pixel(blend_pixel(peak, step, t)), 0.0, 1.0, float(cfg.settle_seconds))
 pixel_tween.tween_callback(func(): apply_pixel(step))
static func blend_pixel(a: Dictionary, b: Dictionary, t: float) -> Dictionary:
 return {"cell": lerpf(a.cell, b.cell, t), "levels": lerpf(a.levels, b.levels, t), "dither": lerpf(a.dither, b.dither, t)}
func apply_pixel(look: Dictionary) -> void:
 if look.is_empty(): return
 pixel_shown = look.duplicate()
 var cell := float(roundi(float(look.cell)))  # whole cells only, so blocks stay square
 pixel_material.set_shader_parameter("cell", cell)
 pixel_material.set_shader_parameter("levels", float(look.levels))
 pixel_material.set_shader_parameter("dither", float(look.dither))
 for layer in pixel_layers:
  if is_instance_valid(layer): layer.visible = cell > 1.0
func update_bleed_target() -> void:
 update_pixel()
 var target := AtomicDecoPunk.target(game.trace, game.strikes, strike_overlay.visible)
 if target != bleed_target:
  bleed_from = bleed
  bleed_target = target
  bleed_elapsed = 0.0
 advance_bleed(0.0)
func advance_bleed(delta: float) -> void:
 if bleed == bleed_target: return
 bleed_elapsed += delta
 var weight := AtomicDecoPunk.ease_weight(bleed_elapsed, reduced_motion)
 bleed = lerpf(bleed_from, bleed_target, weight) if weight < 1.0 else bleed_target
 update_bleed_readout()
 update_reveal_opacity()
func update_bleed_readout() -> void:
 if is_instance_valid(bleed_label): bleed_label.text = "BLEED %.2f" % bleed
func update_reveal_opacity() -> void:
 surveillance_layer.modulate.a = AtomicDecoPunk.reveal(bleed)
func add_backdrop(texture: Texture2D, opacity: float) -> TextureRect:
 var layer := TextureRect.new()
 layer.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
 layer.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
 layer.texture = texture
 layer.modulate.a = opacity
 layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
 add_child(layer)
 layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 return layer

func apply_background() -> void:
 surveillance_layer.visible=corporation_state=="cracking" and not strike_overlay.visible
 update_reveal_opacity()
 var hostile := corporation_state=="mask_off" or strike_overlay.visible
 app_ground.color=Color("#14070A") if hostile else skin.ground
 var target: Texture2D = skin.hostile_background if hostile and skin.hostile_background!=null else skin.background
 if reduced_motion:
  if background_fade: background_fade.kill()
  if is_instance_valid(fade_layer): fade_layer.queue_free()
  background.texture=target; background_target=target
 elif background_target!=target:
  background_target=target
  if background_fade: background_fade.kill()
  if is_instance_valid(fade_layer): fade_layer.queue_free()
  fade_layer = add_backdrop(target, 0.0)
  move_child(fade_layer, background.get_index()+1)
  background_fade=create_tween(); background_fade.tween_property(fade_layer,"modulate:a",1.0,0.3)
  background_fade.tween_callback(func(): background.texture=target; fade_layer.queue_free())
 glitch_layer.visible=false
func dismiss_strike() -> void:
 var was_visible := strike_overlay.visible
 strike_overlay.hide(); strike_until=0; update_bleed_target(); apply_background()
 if was_visible and not reduced_motion and skin.corporation=="HALCYON":
  var tracer := FriendlyCard.new(); tracer.setup(self,"TRACER",-1); tracer.position=Vector2(1090,265); tracer.scale=Vector2.ONE*FriendlyCard.DISPLAY_SCALE; tracer.z_index=150; add_child(tracer)
  var flight := tracer.create_tween().set_parallel(true); flight.tween_property(tracer,"position",Vector2(1445,430),0.35); flight.tween_property(tracer,"scale",Vector2(0.15,0.15),0.35); flight.chain().tween_callback(tracer.queue_free)
func strike_flash() -> void:
 var flash := ColorRect.new(); flash.color=Color("#E5484D55"); flash.size=Vector2(1600,1000); flash.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(flash); move_child(flash,glitch_layer.get_index()+1)
 var light := flash.create_tween(); light.tween_property(flash,"modulate:a",0.0,0.3); light.tween_callback(flash.queue_free)
func build_strike() -> void:
 clear(strike_overlay)
 var dim := ColorRect.new(); dim.color=Color(0.05,0,0,0.5 if skin.corporation=="HALCYON" else 0.10); dim.size=Vector2(1600,1000); dim.mouse_filter=Control.MOUSE_FILTER_IGNORE; strike_overlay.add_child(dim)
 var modal := FriendlyLook.panel(Color("#140809"),FriendlyLook.RED,2,skin.radius); modal.position=Vector2(295,200); modal.size=Vector2(1010,400); strike_overlay.add_child(modal)
 modal.mouse_filter=Control.MOUSE_FILTER_PASS
 var reply := AdpCopy.pick("reply", skin.corporation, 0, {"trigger": skin.strike_title})
 if not reply.is_empty():
  var tag := graffiti_label(reply)
  at(strike_overlay, tag, Vector2(310, 178))
 var chrome_modal:=ChromeFrame.new(); chrome_modal.name="StrikeChrome"; chrome_modal.hostile=true; chrome_modal.radius=skin.radius; chrome_modal.size=modal.size; modal.add_child(chrome_modal)
 at(modal,FriendlyLook.label("TRACE STRIKE 1 OF 3",16,FriendlyLook.RED,FriendlyLook.BOLD),Vector2(32,30))
 at(modal,FriendlyLook.label(skin.strike_title,int(AtomicDecoPunk.settings.display.strike_headline_px),Color("#F6E7E7"),skin.display_font),Vector2(32,64))
 var line := FriendlyLook.label(skin.strike_copy,20,Color("#E4B5B7"),skin.font); line.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; at(modal,line,Vector2(32,166),Vector2(660,70))
 if skin.corporation=="HALCYON":
  at(modal,FriendlyLook.label("+1 TRACER shuffled into your draw pile",15,FriendlyLook.HIGHLIGHT),Vector2(32,260))
 at(modal,FriendlyLook.label("TRACE drops to 20",15,FriendlyLook.HIGHLIGHT),Vector2(32,290))
 at(modal,FriendlyLook.label("next strike: BLACK ICE joins this encounter",13,FriendlyLook.PAPER),Vector2(32,322))
 if skin.corporation=="HALCYON":
  var tracer := FriendlyCard.new(); tracer.setup(self,"TRACER",-1); tracer.position=Vector2(790,65); tracer.scale=Vector2(1.2,1.2); tracer.rotation_degrees=3; modal.add_child(tracer)
 at(modal,FriendlyLook.button("CONTINUE",dismiss_strike,FriendlyLook.RED,FriendlyLook.TONER,skin.radius,skin.bold_font),Vector2(32,353),Vector2(160,32))

func previous_mascot(i: int) -> Dictionary:
 for item in mascot_history:
  if is_same(item.ice,game.enc.ice[i]): return item
 return {}
func interaction_position() -> Vector2:
 if dragging_uid>=0: return get_global_mouse_position()
 for card in hand.get_children():
  if card.uid==hover_uid: return card.get_global_rect().get_center()
 return Vector2.INF
func card_target_ok(uid: int, i: int) -> bool:
 if game.phase!="PLAYER" or not game.can_play(uid).ok: return false
 var inst := game.find_card(uid)
 if inst.is_empty(): return false
 var d := CardDB.def(inst.id)
 if d.type == "PROGRAM" or not d.get("target",false): return false
 if d.has("target_types") and not d.target_types.has(game.ice_definition(game.enc.ice[i]).type): return false
 if d.has("target_type") and d.target_type!=game.ice_definition(game.enc.ice[i]).type: return false
 if d.has("breaker") and d.breaker.get("same_ice",false): return not game._breaker_targets(d.breaker,i).is_empty()
 return true
func drop_wrapper(row: Control, i: int, sub: int) -> Control:
 var wrap := MarginContainer.new(); wrap.add_child(row)
 var drop := FriendlyDropTarget.new(); drop.view=self; drop.ice_ref=game.enc.ice[i]; drop.sub=sub; drop.mouse_filter=Control.MOUSE_FILTER_PASS; drop.tooltip_text=break_info(i,sub).get("reason", "") if sub>=0 else ""; wrap.add_child(drop)
 return wrap
func _can_drop_data(at: Vector2, data) -> bool:
 if not data is Dictionary or data.get("kind") != "card": return false
 var inst := game.find_card(int(data.uid))
 if inst.is_empty() or not game.can_play(inst.uid).ok: return false
 var d := CardDB.def(inst.id)
 if d.type == "PROGRAM" or d.get("target",false): return false
 # PT11-UI: untargeted cards (PULP Shield, BURST, DEFRAG…) play when dropped anywhere above the hand tray.
 return at.y < HAND_RECT.position.y - 10.0
func _drop_data(at: Vector2, data) -> void:
 if not _can_drop_data(at,data): return
 ui.play_seated_card(int(data.uid)); end_drag(); ui.refresh()

func show_break_feedback(ice: Dictionary, subroutine: int, cost: int) -> void:
 feedback_message=("BROKEN" if ice.broken[subroutine] else "BREAK STEP")+" · "+game.ice_definition(ice).name+" · S%d\n%d BW spent · rules updated"%[subroutine+1,cost]
 feedback_until=Time.get_ticks_msec()/1000.0+2.5

const ADP_STENCIL = preload("res://assets/fonts/StardosStencil-Regular.ttf")
const ADP_MARKER = preload("res://assets/fonts/PermanentMarker-Regular.ttf")

func reset_voice() -> void:
 used_leaks.clear()
 leak = ""
 note_serial = -1
 clear(graffiti)
 graffiti_count = 0
 shell_graffiti = {}
 hover_card = -1
 hover_time = 0.0
 hesitation_turn = -1
 hesitation_ice = -1
 hesitation_until = 0.0
 early_toast = false
 tomorrow_toast = false
 mask_toast = false
 toast_until = 0.0

func graffiti_label(line: Dictionary, font_px: int = 12, padding: int = 3) -> PanelContainer:
 var paper := PanelContainer.new()
 paper.mouse_filter = Control.MOUSE_FILTER_IGNORE
 var style := StyleBoxFlat.new()
 style.bg_color = FriendlyLook.TONER
 style.set_content_margin_all(padding)
 paper.add_theme_stylebox_override("panel", style)
 var font: Font = ADP_STENCIL if line.style == "S" else ADP_MARKER
 if line.style == "P":
  paper.add_child(PunchedLetters.new(line.text))
 else:
  var px := font_px
  while px > 8 and font.get_string_size(line.text, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x > GRAFFITI_W:
   px -= 1
  paper.add_child(FriendlyLook.label(line.text, px, FriendlyLook.PAPER, font))
 return paper

func show_voice_toast(line: String, now: float) -> void:
 toast_text.text = line
 var px := 15
 while px > 10 and skin.font.get_multiline_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, 184, px).y > 72:
  px -= 1
 toast_text.add_theme_font_size_override("font_size", px)
 toast_until = now + 3.0

func update_voice(delta: float) -> void:
 var now := Time.get_ticks_msec() / 1000.0
 var band := AdpCopy.band(bleed)
 if note_serial != ui.note_revision:
  note_serial = ui.note_revision
  leak = ""
  var rate := int({"A": 4, "B": 2, "C": 1}.get(band, 0))
  if rate > 0 and voice_rng.randi_range(1, rate) == 1:
   var pool := AdpCopy.pool("leak", skin.corporation, {"band": band}).filter(
    func(line): return not used_leaks.has(line.id))
   if not pool.is_empty():
    var line: Dictionary = pool[voice_rng.randi_range(0, pool.size() - 1)]
    used_leaks[line.id] = true
    leak = line.text
 var targets := GRAFFITI_SPOTS
 var count := int({"A": 1, "B": 2, "C": 4}.get(band, 0))
 while graffiti_count < count:
  var index := SignalCards.ORDER.find(game.corporation)
  var shared := band == "C" and count - 1 == graffiti_count and index > 0
  var line := AdpCopy.pick("graffiti", "" if shared else skin.corporation, graffiti_count + game.row)
  if line.is_empty(): break
  var shell := -1
  if graffiti_count == 1:
   shell = game.enc.ice.map(func(ice): return ice.id).find("AUTO_RENEW")
  if shell >= 0:
   shell_graffiti = line
   add_shell_graffiti(mascots[shell])
  else:
   at(graffiti, graffiti_label(line), targets[graffiti_count])
  graffiti_count += 1
 if band == "C" and corporation_state == "mask_off" and not mask_toast:
  mask_toast = true
  var line := AdpCopy.pick("reply", skin.corporation, 0)
  if not line.is_empty(): show_voice_toast(line.trigger, now)
 if now >= toast_until:
  if not early_toast and band in ["", "A"] and game.enc.turn >= 2:
   early_toast = true
   var line := AdpCopy.pick("toast_status", skin.corporation, game.row)
   if not line.is_empty(): show_voice_toast(line.text, now)
  elif band == "B" and not tomorrow_toast:
   tomorrow_toast = true
   var line := AdpCopy.pick("toast_tomorrow", skin.corporation, game.row)
   if not line.is_empty(): show_voice_toast(line.text, now)
 var reply := AdpCopy.pick("reply", skin.corporation, 0, {"trigger": toast_text.text})
 toast_reply.text = reply.get("text", "") if band == "C" else ""
 if not toast_reply.text.is_empty():
  var font: Font = ADP_STENCIL if reply.style == "S" else ADP_MARKER
  toast_reply.add_theme_font_override("font", font)
 update_hesitation(delta, now)

func update_hesitation(delta: float, now: float) -> void:
 var eligible := game.phase == "PLAYER" and not strike_overlay.visible and dragging_uid < 0 and hover_uid >= 0 and not get_viewport().gui_is_dragging()
 if not eligible or hover_card != hover_uid:
  hover_time = 0.0
  hover_card = hover_uid if eligible else -1
 if eligible:
  hover_time += delta
  if ui.personalized_ads: ui.profile.longest_hover = maxf(ui.profile.longest_hover, hover_time)
  if hover_time >= 4.0 and now >= hesitation_cooldown and hesitation_turn != game.enc.turn:
   var selected := -1
   var highest := -1
   for i in mascots.size():
    var rank := ["cheery", "wary", "lethal"].find(mood_for(i))
    if rank >= 0 and rank >= highest:
     highest = rank
     selected = i
   if selected >= 0:
    var ice: String = game.enc.ice[selected].id
    var key := ice + mood_for(selected)
    var index: int = hesitation_index.get(key, 0)
    var ice_id := ice if skin.corporation == "HALCYON" else ""
    var line := AdpCopy.pick("hesitation", skin.corporation, index, {"ice": ice_id, "mood": mood_for(selected)})
    if not line.is_empty():
     hesitation_index[key] = index + 1
     hesitation_turn = game.enc.turn
     hesitation_ice = selected
     hesitation_line = line.text
     hesitation_until = now + 3.0
     hesitation_cooldown = now + 20.0
 for i in mascots.size():
  var line := hesitation_line if eligible and i == hesitation_ice and now < hesitation_until and hesitation_turn == game.enc.turn else ""
  mascots[i].set_hesitation(line)

func update_punch_holder() -> void:
 if last_punches == game.punch_cards and punch_shadow.get_child_count() != 0: return
 clear(punch_shadow)
 punch_count.text = "%d/3" % game.punch_cards.size()
 for i in SignalCards.ORDER.size():
  var corp: String = SignalCards.ORDER[i]
  var has_card := game.punch_cards.has(corp)
  var card := PunchStock.new([corp] if has_card else [])
  var target := Vector2(40 + i * 36, 5)
  at(punch_shadow, card, target, Vector2(32, 21))
  if has_card and not last_punches.has(corp) and not reduced_motion:
   card.position.y = -21
   card.create_tween().tween_property(card, "position:y", target.y, 0.32).set_trans(Tween.TRANS_CUBIC)
 last_punches = game.punch_cards.duplicate()

func add_shell_graffiti(mascot: FriendlyMascot) -> void:
 if shell_graffiti.is_empty(): return
 # The Auto-Renew card has an unused strip above its action and below the account digits.
 var stamp := graffiti_label(shell_graffiti, 10, 2)
 stamp.name = "ShellGraffiti"
 at(mascot, stamp, Vector2(62, 168))

func present_punch_arrival(corp: String) -> void:
 clear(punch_arrival)
 var card := PunchStock.new([corp])
 at(punch_arrival, card, Vector2(24, 20), Vector2(152, 65))
 var slot := FriendlyLook.panel(FriendlyLook.SLATE, FriendlyLook.PAPER, 1, 2)
 at(punch_arrival, slot, Vector2(18, 12), Vector2(164, 8))
 if not ui.reduced_motion:
  card.position.y = -49
  card.create_tween().tween_property(card, "position:y", 20, 0.38).set_trans(Tween.TRANS_CUBIC)
 arrival_until = Time.get_ticks_msec() / 1000.0 + 3.0

# ---- ENC-CONCEPT-001: top bar, CRT, vitals and END TURN ----

func amber_label(text: String, px: int = 12) -> Label:
 return FriendlyLook.label(text, px, Analog.AMBER, console_font(3))

func bakelite_panel(extent: Vector2) -> Panel:
 var p := Panel.new(); p.add_theme_stylebox_override("panel", Analog.bakelite()); p.size = extent; p.mouse_filter = Control.MOUSE_FILTER_IGNORE; return p

func art_rect(name: String, pos: Vector2, extent: Vector2, parent: Control = null) -> TextureRect:
 ## A painted part placed as a picture (null when the part hasn't been delivered).
 var tex := painted(name)
 if tex == null: return null
 var r := TextureRect.new(); r.name = name; r.texture = tex; r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; r.stretch_mode = TextureRect.STRETCH_SCALE
 r.mouse_filter = Control.MOUSE_FILTER_IGNORE
 at(parent if parent else self, r, pos, extent)
 return r

func build_node_plate() -> void:
 if painted("UI_BRAND_PLATE"):
  # Concept 2's brand plate: the brass starburst is painted; the game writes the name and tier.
  at(node_tag, FriendlyLook.label("PANOPTICON", 26, Analog.CREAM, console_font(5)), Vector2(66, 12))
  var tier_text := "OPENING" if game.is_opening() else String(game.node.get("tier", "TIER 1"))
  var sub := FriendlyLook.label("RUSTLER INTERFACE · %s · LAYER %d/%d" % [tier_text, game.layer + 1, game.node.layers.size()], 12, Analog.CREAM_DIM, console_font(1))
  var sub_px := 12
  while sub_px > 9 and console_font(1).get_string_size(sub.text, HORIZONTAL_ALIGNMENT_LEFT, -1, sub_px).x > 218: sub_px -= 1
  sub.add_theme_font_size_override("font_size", sub_px); at(node_tag, sub, Vector2(68, 50))
  return
 # PANOPTICON wordmark with its eye, then the network/node plate.
 var eye := Analog.icon("EYE", 26, Analog.GLOW); at(node_tag, eye, Vector2(14, 10))
 at(node_tag, FriendlyLook.label("PANOPTICON", 22, Analog.CREAM, console_font(5)), Vector2(48, 6))
 var tier := "OPENING" if game.is_opening() else String(game.node.get("tier", "TIER 1"))
 at(node_tag, FriendlyLook.label("%s · LAYER %d/%d" % [tier, game.layer + 1, game.node.layers.size()], 13, Analog.CREAM_DIM, console_font(2)), Vector2(232, 12))
 var plate := console_plate("%s NETWORK  //  NODE: %s" % [skin.corporation, String(game.node.name).to_upper()], CONSOLE_CREAM, CONSOLE_INK, 16, console_font(1))
 at(node_tag, plate, Vector2(14, 46))
 plate.custom_minimum_size.x = 370

func reveal_percent() -> int:
 var hostile := corporation_state == "mask_off" or strike_overlay.visible
 if corporation_state == "cracking": return roundi(AtomicDecoPunk.reveal(bleed) * 100.0)
 return 100 if hostile else 0

func centred(text: String, px: int, col: Color, font: Font, pos: Vector2, extent: Vector2, parent: Control) -> Label:
 var l := FriendlyLook.label(text, px, col, font); l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
 at(parent, l, pos, extent); return l

func build_trace_plate() -> void:
 ## Concept 2's top bar: TURN plate, TRACE counter, HOSTILE REVEAL alarm, the reserve dial;
 ## a second row with the strike lamps, the TRACE bar or warning, CONDITION and CRED/RAM.
 var hostile := corporation_state == "mask_off" or strike_overlay.visible
 var cond := "MASK OFF" if hostile else corporation_state.to_upper()
 var reveal := reveal_percent()
 var hot := game.trace >= 20
 var t := trace_tag
 # TURN plate (cream label strip over a dark flip window).
 if art_rect("UI_TURN_PLATE", Vector2(0, 2), Vector2(200, 66), t) == null: at(t, bakelite_panel(Vector2(200, 66)), Vector2(0, 2))
 centred("TURN", 12, CONSOLE_INK, console_font(3), Vector2(22, 7), Vector2(156, 15), t)
 at(t, Analog.tiles("%02d" % game.enc.turn, Vector2(24, 28), 24), Vector2(73, 27))
 # TRACE counter: label window, two big flip digits, the cap.
 if art_rect("UI_TRACE_COUNTER", Vector2(206, 2), Vector2(240, 66), t) == null: at(t, bakelite_panel(Vector2(240, 66)), Vector2(206, 2))
 centred("TRACE", 15, Analog.AMBER, console_font(3), Vector2(228, 18), Vector2(78, 34), t)
 at(t, Analog.tiles("%02d" % game.trace, Vector2(34, 38), 32, Color("#FF6A5A") if hot else Analog.CREAM), Vector2(311, 15))
 centred("/%d" % Game.MAX_TRACE, 11, Analog.CREAM_DIM, console_font(0), Vector2(402, 17), Vector2(24, 34), t)
 # HOSTILE REVEAL alarm: dim at 0, hot from 40%.
 var alarm := "UI_ALARM_PLATE_HOT" if reveal >= 40 else "UI_ALARM_PLATE"
 var alarm_ink := Color.WHITE if reveal >= 40 else (Color("#FF9A8A") if reveal > 0 else Analog.CREAM_DIM)
 if art_rect(alarm, Vector2(452, 2), Vector2(200, 66), t) == null: at(t, console_plate("", Color("#2A0606"), alarm_ink, 12, console_font(0)), Vector2(452, 2))
 centred("HOSTILE REVEAL", 12, alarm_ink, console_font(3), Vector2(462, 9), Vector2(180, 15), t)
 centred("%d%%" % reveal, 28, alarm_ink, CONDENSED, Vector2(462, 24), Vector2(180, 36), t)
 # RESERVE dial: the needle sweeps from empty (-135°) to full (+135°).
 var full := float(game.enc.reserve) / maxf(1.0, float(game.enc.reserve_start))
 if art_rect("UI_DIAL", Vector2(660, 2), Vector2(64, 64), t):
  var needle := art_rect("UI_DIAL_NEEDLE", Vector2(660, 2), Vector2(64, 64), t)
  if needle: needle.pivot_offset = Vector2(32, 32); needle.rotation = deg_to_rad(-135.0 + 270.0 * clampf(full, 0.0, 1.0))
 at(t, amber_label("RESERVE", 11), Vector2(730, 4))
 at(t, FriendlyLook.label("%d/%d" % [game.enc.reserve, game.enc.reserve_start], 20, Analog.GLOW if game.enc.reserve > 0 else Color("#FF6A5A"), CONDENSED), Vector2(730, 18))
 at(t, FriendlyLook.label("CRED", 10, Analog.CREAM_DIM, console_font(2)), Vector2(730, 42))
 bleed_label = FriendlyLook.label("", 10, Analog.CREAM_DIM)
 at(t, bleed_label, Vector2(730, 54))
 # Second row.
 at(t, amber_label("STRIKES", 11), Vector2(4, 76))
 for k in 3:
  var lamp_art := "UI_STRIKE_LAMP_ON" if k < game.strikes else "UI_STRIKE_LAMP_OFF"
  if art_rect(lamp_art, Vector2(66 + k * 22, 72), Vector2(20, 20), t) == null: at(t, Analog.lamp(Analog.RED, k < game.strikes, 16), Vector2(68 + k * 22, 74))
 if corporation_state == "cracking":
  at(t, FriendlyLook.label("PAST 50% · THEY'RE LOOKING", 11, Color("#FF9A8A"), console_font(1)), Vector2(212, 76))
 else:
  at(t, Analog.instrument("bars", roundi(game.trace / 4.0), 10, Vector2(228, 8), Color("#FF3A2A") if hot else Analog.GLOW), Vector2(212, 80))
 var cond_bg := Color("#2F7A4C") if corporation_state == "friendly" else (Color("#14070A") if hostile else Color("#B3261A"))
 var pill := console_plate("CONDITION: " + cond, cond_bg, Color.WHITE, 12, console_font(2)); pill.custom_minimum_size = Vector2(200, 22)
 at(t, pill, Vector2(452, 72))
 at(t, FriendlyLook.label("CRED %d · RAM %d/%d" % [game.cred, game.ram_used(), game.ram_total()], 11, Analog.CREAM, console_font(1)), Vector2(662, 76))
 update_bleed_readout()

func incoming_pulp() -> int:
 return incoming().pulp

func incoming() -> Dictionary:
 ## PT11-UI: what the next response (or, after a BREACH, the parting shot) will deal.
 var out := {"pulp": 0, "trace": 0}
 for step in game.response_preview():
  if step.skipped or step.hidden: continue
  if game.enc.get("breached", false) and game._has_deadlock(step.effects): continue
  for source in step.effects:
   var e := game.effect_value(game.enc.ice[step.ice], source)
   if e.k == "PULP": out.pulp += int(e.get("v", 0))
   elif e.k == "RETALIATE": out.pulp += int(e.get("dmg", 0))
   elif e.k == "TRACE": out.trace += int(e.get("v", 0))
 return out

const VITAL_SLOTS := [25.0, 60.0, 94.0, 129.0, 163.0]   # UI_VITALS_PANEL's five recessed rows, drawn at 240/448

func vital_icon(kind: String, col: Color) -> Control:
 var names := {"VITAE": "ICON_VITAE", "BW": "ICON_BW", "SHIELD": "ICON_SHIELD", "DRAW": "ICON_DRAW", "PULP": "ICON_PULP_LIGHT"}
 var tex := painted(names.get(kind, ""))
 if tex == null: return Analog.icon(kind, 20, col)
 var r := TextureRect.new(); r.texture = tex; r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 r.mouse_filter = Control.MOUSE_FILTER_IGNORE; r.custom_minimum_size = Vector2(20, 20); r.size = Vector2(20, 20)
 if kind == "PULP": r.modulate = col
 return r

func vital_row(slot: int, icon_kind: String, label: String, col: Color, readout: String, gauge: Control) -> void:
 var y: float = VITAL_SLOTS[slot]
 at(bottom_hud, vital_icon(icon_kind, col), Vector2(17, y + 4))
 at(bottom_hud, amber_label(label, 11), Vector2(45, y + 1))
 var value := FriendlyLook.label(readout, 16, Analog.CREAM, CONDENSED); value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
 at(bottom_hud, value, Vector2(150, y - 2), Vector2(72, 19))
 if gauge.custom_minimum_size.x > 0:
  gauge.custom_minimum_size = Vector2(163, 7); gauge.size = gauge.custom_minimum_size
  at(bottom_hud, gauge, Vector2(45, y + 18))

func build_instruments() -> void:
 # Concept 2's vitals on the painted panel: an icon, a label, a segmented gauge and the number.
 vital_row(0, "VITAE", "VITAE", Color("#FF5A4A"), "%d/%d" % [game.vitae, game.max_vitae], Analog.instrument("bars", ceili(10.0 * game.vitae / maxf(1.0, game.max_vitae)), 10, Vector2(152, 6), Color("#FF3A2A")))
 vital_row(1, "BW", "BANDWIDTH", Color("#FFC84A"), "%d/%d" % [game.bw, bw_capacity], Analog.instrument("lamps", game.bw, mini(10, bw_capacity), Vector2(152, 9), Color("#FFB020")))
 vital_row(2, "SHIELD", "SHIELD", Color("#7FD0FF"), str(game.shield), Analog.instrument("bars", mini(12, game.shield), 12, Vector2(152, 6), Analog.BLUE))
 var inc := incoming()
 var pulp: int = inc.pulp
 # PT11-UI: after a BREACH this row shows the parting shot you'll take at END TURN.
 var breached: bool = game.enc.get("breached", false)
 vital_row(3, "PULP", "PARTING SHOT" if breached else "PULP INCOMING", Color("#FF8A3A"), ("%d · T%d" % [pulp, inc.trace]) if breached else str(pulp), Analog.instrument("bars", mini(12, pulp), 12, Vector2(152, 6), Color("#FF8A3A")))
 vital_row(4, "DRAW", "NEXT DRAW", Analog.CREAM, str(game.draw_size()), Control.new())

func update_crt_status() -> void:
 var state: String = {"friendly": "FRIENDLY", "cracking": "CRACKING", "mask_off": "MASK OFF"}.get(corporation_state, "")
 if crt_picture:
  var shot: String = "STRIKE" if strike_overlay.visible else {"friendly": "FRIENDLY", "cracking": "CRACKING", "mask_off": "MASKOFF"}.get(corporation_state, "FRIENDLY")
  crt_picture.texture = painted("UI_CRT_SCREEN_" + shot)
 crt_status.text = "%s // %s\nSTATUS: %s" % [skin.corporation, String(game.node.name).to_upper(), state]
 crt_status.add_theme_color_override("font_color", CRT_INK if corporation_state == "friendly" else Color("#FF8FB8"))

func style_end_turn(button: Button) -> void:
 if painted("UI_END_TURN_BOX"):
  # Concept 2: the red mushroom plunger on a bakelite box; END TURN is written on its cream plate
  # (x40–280, y180–315 of 320×360).
  button.add_theme_font_override("font", console_font(3)); button.add_theme_font_size_override("font_size", 22)
  var states := {"normal": "UI_END_TURN_BOX", "hover": "UI_END_TURN_BOX_HOVER", "pressed": "UI_END_TURN_BOX_PRESSED", "disabled": "UI_END_TURN_BOX_DISABLED"}
  var k := button.size.x / 320.0
  for state in states:
   var st := painted_box(states[state], Vector4.ZERO, Vector4(40, 180, 40, 45) * k)
   button.add_theme_stylebox_override(state, st)
  var focus := StyleBoxFlat.new(); focus.draw_center = false; focus.border_color = FriendlyLook.SERVICE_TEAL; focus.set_border_width_all(3); focus.set_corner_radius_all(16)
  button.add_theme_stylebox_override("focus", focus)
  for c in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
   button.add_theme_color_override(c, Color("#3A1A0A"))
  button.add_theme_color_override("font_disabled_color", Color("#5A4636"))
  button.add_theme_constant_override("outline_size", 0)
  return
 ## The round red push-button in a chrome ring (concept 3); painted when the art is in.
 button.add_theme_font_override("font", console_font(3))
 button.add_theme_font_size_override("font_size", 22)
 var art := {"normal": "UI_END_TURN", "hover": "UI_END_TURN", "pressed": "UI_END_TURN_PRESSED", "disabled": "UI_END_TURN_DISABLED"}
 for state in ["normal", "hover", "pressed", "disabled", "focus"]:
  var painted_state: StyleBox = painted_box(art[state], Vector4.ZERO) if art.has(state) else null
  if painted_state:
   if state == "hover": (painted_state as StyleBoxTexture).modulate_color = Color(1.12, 1.08, 1.08)
   button.add_theme_stylebox_override(state, painted_state); continue
  var st := StyleBoxFlat.new()
  st.bg_color = {"normal": Color("#C9271B"), "hover": Color("#E0382A"), "pressed": Color("#9C1F15"), "disabled": Color("#6E4A44"), "focus": Color.TRANSPARENT}[state]
  st.border_color = Color("#D5DBDD"); st.set_border_width_all(6); st.set_corner_radius_all(54); st.anti_aliasing = true
  if state in ["normal", "hover"]:
   st.shadow_color = Color("#00000088"); st.shadow_size = 8; st.shadow_offset = Vector2(0, 5)
  if state == "focus":
   st.draw_center = false; st.border_color = FriendlyLook.SERVICE_TEAL; st.set_border_width_all(3); st.set_corner_radius_all(54)
  button.add_theme_stylebox_override(state, st)
 for c in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color", "font_disabled_color"]:
  button.add_theme_color_override(c, Color.WHITE)
 button.add_theme_color_override("font_outline_color", Color("#4A0A05")); button.add_theme_constant_override("outline_size", 4)

func crt_chip(chip: Button) -> void:
 ## Installed Programs read as phosphor entries on the CRT.
 for state in ["normal", "hover", "pressed", "focus", "disabled"]:
  var st := StyleBoxFlat.new(); st.bg_color = Color("#14302A") if state != "hover" else Color("#1C4238")
  st.border_color = CRT_INK if state != "focus" else FriendlyLook.HIGHLIGHT; st.set_border_width_all(1); st.set_corner_radius_all(4)
  st.content_margin_left = 6; st.content_margin_right = 6; st.content_margin_top = 2; st.content_margin_bottom = 2
  if state == "focus": st.draw_center = false; st.set_border_width_all(2)
  chip.add_theme_stylebox_override(state, st)
 for c in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
  chip.add_theme_color_override(c, CRT_INK)
 chip.add_theme_font_override("font", console_font(2))

# ---- ENC-CONCEPT-001: painted parts from ChatGPT (UI Design Bible, Source 5) ----

func painted(name: String) -> Texture2D:
 return IceKey.art(name)

func painted_box(name: String, margins: Vector4, content: Vector4 = Vector4(-1, -1, -1, -1)) -> StyleBox:
 ## A nine-slice of a painted part: margins = left, top, right, bottom in texture pixels.
 var tex := painted(name)
 if tex == null: return null
 var st := StyleBoxTexture.new(); st.texture = tex
 st.texture_margin_left = margins.x; st.texture_margin_top = margins.y; st.texture_margin_right = margins.z; st.texture_margin_bottom = margins.w
 var c := margins if content.x < 0 else content
 st.content_margin_left = c.x; st.content_margin_top = c.y; st.content_margin_right = c.z; st.content_margin_bottom = c.w
 return st

func paint_panel(panel: Control, name: String, margins: Vector4, content: Vector4 = Vector4(-1, -1, -1, -1)) -> void:
 var st := painted_box(name, margins, content)
 if st: panel.add_theme_stylebox_override("panel", st)

func paint_button(button: Button) -> void:
 var names := {"normal": "UI_BUTTON_S", "hover": "UI_BUTTON_HOVER_S", "pressed": "UI_BUTTON_PRESSED_S", "disabled": "UI_BUTTON_PRESSED_S", "focus": ""}
 for state in names:
  if names[state] == "":
   var focus := StyleBoxFlat.new(); focus.draw_center = false; focus.border_color = FriendlyLook.SERVICE_TEAL; focus.set_border_width_all(2); focus.set_corner_radius_all(14)
   button.add_theme_stylebox_override(state, focus); continue
  var st := painted_box(names[state], Vector4(16, 10, 16, 10), Vector4(14, 3, 14, 3))
  if st == null: return
  button.add_theme_stylebox_override(state, st)
 for c in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
  button.add_theme_color_override(c, Analog.CREAM)
 button.add_theme_color_override("font_disabled_color", Analog.CREAM_DIM)

func paint_tray_button(button: Button, ink: Color = Color("#3A1A0A")) -> void:
 ## Concept 2's chunky tray button; the label is written on its cream plate.
 var names := {"normal": "UI_TRAY_BUTTON", "hover": "UI_TRAY_BUTTON_HOVER", "pressed": "UI_TRAY_BUTTON_PRESSED", "disabled": "UI_TRAY_BUTTON_PRESSED"}
 for state in names:
  var st := painted_box(names[state], Vector4.ZERO, Vector4(14, 5, 14, 8))
  if st == null: return
  if state == "disabled": (st as StyleBoxTexture).modulate_color = Color(0.85, 0.82, 0.78)
  button.add_theme_stylebox_override(state, st)
 for c in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
  button.add_theme_color_override(c, ink)
 button.add_theme_color_override("font_disabled_color", Color("#5A4636"))

func console_heading(i: int, stage: Control, k: float) -> void:
 ## Name, STR and type in the cabinet's top-right slots (name x505–855 y70–155, STR x672–893 y178–250).
 var ice: Dictionary = game.enc.ice[i]; var d := game.ice_definition(ice)
 var head := Control.new(); head.name = "ConsoleHeading"; head.mouse_filter = Control.MOUSE_FILTER_IGNORE; stage.add_child(head)
 var power := Analog.lamp(Color("#4DFF6E") if not game.enc.get("breached",false) else Color("#3A3632"), not game.enc.get("breached",false), int(16 * k / 0.73))
 at(head, power, Vector2(868, 100) * k)
 var name_box := Vector2(330, 80) * k
 var title := centred(d.name.to_upper(), int(44 * k), CONSOLE_CREAM, console_font(2), Vector2(515, 72) * k, name_box, head); title.name = "IceName"
 var fs := int(44 * k)
 while fs > 10 and console_font(2).get_string_size(title.text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x > name_box.x - 8: fs -= 1
 title.add_theme_font_size_override("font_size", fs)
 centred("STR %d" % game.ice_str(i), int(40 * k), CONSOLE_CREAM, console_font(1), Vector2(680, 180) * k, Vector2(205, 66) * k, head).name = "IceStr"
 var delta: int = game.ice_str(i) - int(d.str)
 if delta != 0:
  var badge := console_plate(("↑%d" if delta > 0 else "↓%d") % absi(delta), Color("#2F7A4C") if delta > 0 else Color("#B3261A"), Color.WHITE, int(28 * k), console_font(0))
  at(head, badge, Vector2(578, 186) * k)
 var meta := FriendlyLook.label(" · ".join([d.type, d.get("subtype", "")]).trim_suffix(" · "), int(maxf(11.0, 20.0 * k)), console_ink(), console_font(3))
 meta.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
 at(head, meta, Vector2(505, 262) * k, Vector2(390, 30) * k)

func build_pipework() -> void:
 ## Copper pipes behind the panels, showing in the gaps (concept 2); a darker vignette at the edges.
 var vignette := painted("UI_VIGNETTE")
 if vignette:
  var v := TextureRect.new(); v.name = "Vignette"; v.texture = vignette; v.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; v.stretch_mode = TextureRect.STRETCH_SCALE
  v.mouse_filter = Control.MOUSE_FILTER_IGNORE; at(self, v, Vector2.ZERO, Vector2(1600, 1000))
 var pipes := Control.new(); pipes.name = "Pipework"; pipes.mouse_filter = Control.MOUSE_FILTER_IGNORE; at(self, pipes, Vector2.ZERO, Vector2(1600, 1000))
 var h := painted("UI_PIPE_H"); var v2 := painted("UI_PIPE_V"); var elbow := painted("UI_PIPE_ELBOW")
 pipes.draw.connect(func():
  if h: pipes.draw_texture_rect(h, Rect2(Vector2(20, 100), Vector2(1560, 18)), false)
  if h: pipes.draw_texture_rect(h, Rect2(Vector2(20, 760), Vector2(1560, 18)), false)
  if v2: pipes.draw_texture_rect(v2, Rect2(Vector2(251, 108), Vector2(18, 660)), false)
  if elbow: pipes.draw_texture_rect(elbow, Rect2(Vector2(244, 94), Vector2(32, 32)), false))

func build_left_trim() -> void:
 ## Hardware under the left column's buttons: a vent grille, a valve and a pressure gauge.
 art_rect("UI_VENT_GRILLE", Vector2(18, 704), Vector2(150, 46))
 art_rect("UI_PIPE_VALVE", Vector2(170, 704), Vector2(42, 42))
 art_rect("UI_PIPE_GAUGE", Vector2(214, 704), Vector2(40, 42))

func build_tray() -> void:
 ## Concept 2's copper tray: deck well, the hand, discard well, tray buttons, END TURN in the housing.
 var tray_art := painted("UI_HAND_TRAY")
 if tray_art == null: return
 var tk := 222.0 / 360.0
 var tray := NinePatchRect.new(); tray.name = "HandTray"; tray.texture = tray_art; tray.mouse_filter = Control.MOUSE_FILTER_IGNORE
 tray.patch_margin_left = 60; tray.patch_margin_right = 290; tray.patch_margin_top = 50; tray.patch_margin_bottom = 50
 tray.scale = Vector2(tk, tk); tray.size = Vector2(1322.0 / tk, 360); at(self, tray, Vector2(262, 768))
 for well in [["UI_DECK_WELL", Vector2(274, 794)], ["UI_DISCARD_WELL", Vector2(1146, 794)]]:
  art_rect(well[0], well[1], Vector2(118, 154))
 deck_count = centred("", 12, Analog.CREAM, console_font(2), Vector2(274, 950), Vector2(118, 16), self); deck_count.name = "DeckCount"
 discard_count = centred("", 12, Analog.CREAM, console_font(2), Vector2(1146, 950), Vector2(118, 16), self); discard_count.name = "DiscardCount"
 for l in [deck_count, discard_count]:
  l.add_theme_color_override("font_outline_color", Color("#1A0A04")); l.add_theme_constant_override("outline_size", 4)

func build_legend() -> void:
 ## The key legend card (concept 2), toggled by KEY LEGEND; the game draws the lamps and words.
 legend = Panel.new(); legend.name = "KeyLegend"; legend.mouse_filter = Control.MOUSE_FILTER_STOP; legend.z_index = 120
 legend.add_theme_stylebox_override("panel", Analog.bakelite()); paint_panel(legend, "UI_LEGEND_CARD", Vector4.ZERO)
 at(self, legend, Vector2(1272, 472), Vector2(308, 264))
 var k := 308.0 / 560.0
 var rows := [["UI_KEY_LAMP_GREEN", "Ready (will fire)"], ["UI_KEY_LAMP_RED", "Biggest hit (this response)"], ["UI_KEY_LAMP_OFF", "Broken (inactive)"], ["?", "Hidden (unrevealed)"], ["UI_KEY_LAMP_AMBER", "Tumbled in / DEADLOCK"], ["BOOT", "BOOTING (locks, opens later)"]]
 for r in rows.size():
  var cy: float = (82.0 + r * 66.0) * k
  var mark: String = rows[r][0]
  if mark == "?": centred("?", 16, Analog.CREAM, CONDENSED, Vector2(80 * k - 14, cy - 14), Vector2(28, 28), legend)
  elif mark == "BOOT":
   art_rect("ICON_BOOTING_LIGHT", Vector2(80 * k - 9, cy - 9), Vector2(18, 18), legend)
  else: art_rect(mark, Vector2(80 * k - 9, cy - 9), Vector2(18, 18), legend)
  at(legend, FriendlyLook.label(rows[r][1], 13, Analog.CREAM, console_font(1)), Vector2(130 * k, cy - 9), Vector2(380 * k, 18))
 legend.gui_input.connect(func(e): if e is InputEventMouseButton and e.pressed: legend.hide())
 legend.hide()

## The colour a painted part shows behind text (sampled from each image), for contrast checks.
const PAINT_GROUND := {"UI_TRAY_BUTTON": Color("#F2D8AD"), "UI_TRAY_BUTTON_HOVER": Color("#F2D8AD"), "UI_TRAY_BUTTON_PRESSED": Color("#E8CDA2"), "UI_END_TURN_BOX": Color("#EED0AB"), "UI_END_TURN_BOX_HOVER": Color("#EED0AB"), "UI_END_TURN_BOX_PRESSED": Color("#EED0AB"), "UI_END_TURN_BOX_DISABLED": Color("#D8C4A8"), "UI_NOTE_SLIP": Color("#F4DBB3"), "UI_BRAND_PLATE": Color("#2C0E06"), "UI_TICKER": Color("#1A1A19"), "UI_LEGEND_CARD": Color("#2A150F"), "UI_PLATE_DARK_S": Color("#010000"), "UI_PLATE_CREAM_S": Color("#EDD9B4"), "UI_PILL_GREEN_S": Color("#015B0B"), "UI_PILL_RED_S": Color("#8B0101"), "UI_BADGE_UP_S": Color("#01480B"), "UI_BADGE_DOWN_S": Color("#6B0100"), "UI_TOOLTIP_PLATE_S": Color("#E9D1B0"), "UI_BUTTON_S": Color("#3F1407")}

static func style_ground(style: StyleBox) -> Color:
 if style is StyleBoxFlat: return (style as StyleBoxFlat).bg_color
 if style is StyleBoxTexture and (style as StyleBoxTexture).texture:
  var name: String = (style as StyleBoxTexture).texture.resource_path.get_file().get_basename()
  return PAINT_GROUND.get(name, Color.BLACK)
 return Color.BLACK
