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
const HAND_RECT := Rect2(16, 622, 1568, 378)
const ICE_SCALE := 0.85
const ICE_X := 800.0 - 1300.0 * ICE_SCALE / 2.0
## ICE-ANALOG-001: bigger mascots on a taller stage; the analog console below is shorter than the old scan tag.
const MASCOT_GROWTH := 1.18
const STAGE_H := 236
const ICE_AREA_H := 572.0   # x0.85 on screen: y114 to y600
const NOTE_W := 204.0
const NOTE_H := 160.0
const CRT_INK := Color("#7DFFB8")
var crt_screen: Panel
var crt_status: Label
var end_lamp: Analog
const CONSOLE_OVERLAP := -14   # the mascot peeks over the console's top edge
## Graffiti lands in free margins: under the Program Bay and under the TRACE panel.
## ENC-CONCEPT-001: graffiti goes on the decal plate in the top bar, between the node plate and the corporate sign.
const GRAFFITI_SPOTS := [Vector2(426, 14), Vector2(426, 36), Vector2(426, 58), Vector2(426, 80)]
const GRAFFITI_W := 152.0
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
 skin = ui.friendly_skin
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
 node_tag = Panel.new(); node_tag.add_theme_stylebox_override("panel", Analog.bakelite()); node_tag.position = Vector2(16, 10); node_tag.size = Vector2(400, 96); add_child(node_tag)
 var decal := Panel.new(); decal.name = "DecalPlate"; decal.add_theme_stylebox_override("panel", Analog.bakelite()); decal.position = Vector2(420, 10); decal.size = Vector2(164, 96); decal.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(decal); move_child(decal, node_tag.get_index())
 decal.draw.connect(func():
  for k in 7: decal.draw_rect(Rect2(14, 14 + k * 11, 136, 4), Color(0, 0, 0, 0.35))
  for q in [Vector2(7, 7), Vector2(157, 7), Vector2(7, 89), Vector2(157, 89)]: decal.draw_circle(q, 3, Color("#B9A27A")))
 trace_tag = Panel.new(); trace_tag.add_theme_stylebox_override("panel", Analog.bakelite()); trace_tag.position = Vector2(950, 10); trace_tag.size = Vector2(634, 96); add_child(trace_tag)
 ice_scroll = ScrollContainer.new(); ice_scroll.position = Vector2(ICE_X, 114); ice_scroll.size = Vector2(1300, ICE_AREA_H); ice_scroll.scale = Vector2.ONE * ICE_SCALE; ice_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO; ice_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO; add_child(ice_scroll)
 ice_row = HBoxContainer.new(); ice_row.add_theme_constant_override("separation", 42); ice_row.alignment = BoxContainer.ALIGNMENT_CENTER; ice_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL; var ice_margin:=MarginContainer.new(); ice_margin.add_theme_constant_override("margin_top",10); ice_margin.size_flags_horizontal=Control.SIZE_EXPAND_FILL; ice_scroll.add_child(ice_margin); ice_margin.add_child(ice_row)
 # ENC-CONCEPT-001: each ICE carries its own NEXT RESPONSE plate (scan_tag); no shared strip.
 note = FriendlyLook.panel(FriendlyLook.TONER); note.position = Vector2(1360, 114); note.size = Vector2(224, 206); note.rotation_degrees = -0.6; note.mouse_filter = Control.MOUSE_FILTER_PASS; add_child(note)  # PASS: a SCRIPT dropped on the note still plays
 note_text = FriendlyLook.label("", 12, FriendlyLook.HIGHLIGHT); note_text.position = Vector2(10, 8); note_text.size = Vector2(NOTE_W, NOTE_H); note_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; note.add_child(note_text)
 var voice := FriendlyLook.button("VOICE / M", func(): ui._toggle_voice(), FriendlyLook.TONER, FriendlyLook.PAPER); voice.position = Vector2(118, 172); voice.size = Vector2(96, 26); voice.add_theme_font_size_override("font_size", 11); note.add_child(voice)
 var rig_ground := Panel.new(); rig_ground.add_theme_stylebox_override("panel", Analog.glass(4, Color("#2A2622"))); rig_ground.position=Vector2(24,350); rig_ground.size=Vector2(208,22); add_child(rig_ground)
 var rig_scroll := ScrollContainer.new(); rig_scroll.position = Vector2(30, 351); rig_scroll.size = Vector2(198, 20); rig_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; add_child(rig_scroll)
 rig_row = HBoxContainer.new(); rig_row.add_theme_constant_override("separation", 8); rig_scroll.add_child(rig_row)
 program_bay = FriendlyProgramBay.new()
 program_bay.encounter = self
 program_bay.name = "ProgramBay"
 program_bay.mouse_filter = Control.MOUSE_FILTER_PASS
 program_bay.add_theme_stylebox_override("panel", Analog.bakelite())
 at(self, program_bay, Vector2(16,114), Vector2(224,262))
 crt_screen = Panel.new(); crt_screen.name = "CrtScreen"; crt_screen.mouse_filter = Control.MOUSE_FILTER_PASS
 var screen_style := StyleBoxFlat.new(); screen_style.bg_color = Color("#0E1F1A"); screen_style.border_color = Color("#C9B796"); screen_style.set_border_width_all(3); screen_style.set_corner_radius_all(18)
 crt_screen.add_theme_stylebox_override("panel", screen_style)
 at(program_bay, crt_screen, Vector2(8,8), Vector2(208,224))
 crt_status = FriendlyLook.label("", 12, CRT_INK, console_font(2)); at(crt_screen, crt_status, Vector2(14,6), Vector2(184,50))
 crt_screen.draw.connect(func():
  for y in range(6, 220, 4): crt_screen.draw_line(Vector2(6, y), Vector2(202, y), Color(0.45, 1, 0.75, 0.035), 1)
  crt_screen.draw_line(Vector2(14, 58), Vector2(194, 58), Color(CRT_INK, 0.4), 1))
 at(crt_screen, FriendlyLook.label("PROGRAMS", 12, CRT_INK, console_font(3)), Vector2(14,62))
 var program_scroll := ScrollContainer.new()
 program_scroll.mouse_filter = Control.MOUSE_FILTER_PASS
 program_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
 at(crt_screen, program_scroll, Vector2(10,80), Vector2(188,102))
 program_slots = VBoxContainer.new()
 program_slots.name = "ProgramSlots"
 program_slots.mouse_filter = Control.MOUSE_FILTER_PASS
 program_slots.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 program_slots.add_theme_constant_override("separation", 8)
 program_scroll.add_child(program_slots)
 var connector := FriendlyLook.panel(Color("#14302A"), CRT_INK, 1, 6)
 connector.mouse_filter = Control.MOUSE_FILTER_IGNORE
 at(crt_screen, connector, Vector2(10,186), Vector2(188,30))
 at(connector, FriendlyLook.label("DROP PROGRAM HERE", 12, CRT_INK, console_font(2)), Vector2(10,1))
 for pin in range(18):
  var contact := ColorRect.new()
  contact.color = Color(CRT_INK, 0.6)
  contact.mouse_filter = Control.MOUSE_FILTER_IGNORE
  at(connector, contact, Vector2(10 + pin * 9,21), Vector2(5,5))
 hand = FriendlyHand.new(); hand.position = HAND_RECT.position; hand.size = HAND_RECT.size; hand.focus_mode = Control.FOCUS_ALL; hand.mouse_filter = Control.MOUSE_FILTER_PASS; add_child(hand)
 bottom_hud = Panel.new(); bottom_hud.add_theme_stylebox_override("panel", Analog.bakelite()); bottom_hud.position = Vector2(16, 418); bottom_hud.size = Vector2(224, 196); add_child(bottom_hud)
 var piles_paper:=Panel.new(); piles_paper.add_theme_stylebox_override("panel", Analog.bakelite()); piles_paper.position=Vector2(1360,358); piles_paper.size=Vector2(224,64); piles_paper.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(piles_paper)
 pile_text = FriendlyLook.label("", 13, Analog.CREAM, console_font(1)); pile_text.position = Vector2(1372, 362); pile_text.size = Vector2(204, 58); pile_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; add_child(pile_text)
 end_button = FriendlyLook.button("END\nTURN", func(): ui._on_end_turn()); end_button.position = Vector2(1418, 428); end_button.size = Vector2(108, 108); style_end_turn(end_button); add_child(end_button)
 end_lamp = Analog.lamp(Color("#FFB020"), true, 14); at(self, end_lamp, Vector2(1538, 474))
 var deck := FriendlyLook.button("DECK / COVERAGE", func(): ui.deck_open = true; ui.refresh(), Analog.BAKELITE, Analog.CREAM, 6, console_font(2)); deck.add_theme_font_size_override("font_size", 14); deck.position = Vector2(1360, 546); deck.size = Vector2(224, 30); add_child(deck)
 end_run_button = FriendlyLook.button("END RUN", func(): ui._confirm_end_run(), Analog.BAKELITE_EDGE, Color("#F0A090"), 6, console_font(3)); end_run_button.add_theme_font_size_override("font_size", 14); end_run_button.position = Vector2(1360, 582); end_run_button.size = Vector2(224, 30); add_child(end_run_button)
 toast = FriendlyLook.panel(Color.WHITE, FriendlyLook.RED, 1, 10, 3)
 at(self, toast, Vector2(1360, 114), Vector2(224, 105))
 toast.z_index = 5
 toast_text = FriendlyLook.label(skin.cracking_copy, 15, FriendlyLook.TONER, skin.font)
 toast_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 at(toast, toast_text, Vector2(8, 6), Vector2(184, 72))
 toast_reply = FriendlyLook.label("", 14, FriendlyLook.TONER, ADP_MARKER)
 at(toast, toast_reply, Vector2(8, 80), Vector2(184, 20))
 toast.hide()
 punch_arrival = FriendlyLook.panel(FriendlyLook.TONER, FriendlyLook.HIGHLIGHT, 1, 5)
 at(self, punch_arrival, Vector2(1360, 114), Vector2(224, 105))
 punch_arrival.clip_contents = true
 punch_arrival.hide()
 punch_holder = Panel.new(); var punch_style := Analog.bakelite(8); punch_style.shadow_size = 4; punch_holder.add_theme_stylebox_override("panel", punch_style)
 at(self, punch_holder, Vector2(16, 382), Vector2(224, 31))
 punch_holder.clip_contents = true
 punch_count = FriendlyLook.label("", 13, FriendlyLook.PAPER, FriendlyLook.BOLD)
 at(punch_holder, punch_count, Vector2(8, 5))
 punch_shadow = Control.new()
 punch_shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
 punch_holder.add_child(punch_shadow)
 var inspect_punches := FriendlyLook.button("VIEW", func(): ui.open_punches(), FriendlyLook.TONER, FriendlyLook.PAPER)
 at(punch_holder, inspect_punches, Vector2(170, 2), Vector2(48, 26))
 strike_overlay = Control.new(); strike_overlay.name="StrikeOneModal"; strike_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); strike_overlay.mouse_filter=Control.MOUSE_FILTER_STOP; strike_overlay.z_index=200; add_child(strike_overlay); strike_overlay.hide()
 motion_button=FriendlyLook.button("REDUCED MOTION: OFF",func(): ui.set_reduced_motion(not ui.reduced_motion),FriendlyLook.PAPER)
 motion_button.position=Vector2(1360,326); motion_button.size=Vector2(224,26); motion_button.add_theme_font_size_override("font_size",10); add_child(motion_button)
 watcher_warning=FriendlyLook.panel(FriendlyLook.RED); watcher_warning.position=Vector2(1030,540); watcher_warning.size=Vector2(510,36); watcher_warning.z_index=150; watcher_warning.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(watcher_warning)
 watcher_text=FriendlyLook.label("",12,FriendlyLook.TONER,FriendlyLook.BOLD); watcher_text.position=Vector2(8,7); watcher_warning.add_child(watcher_text); watcher_warning.hide()
 strike_overlay.gui_input.connect(func(e):
  if e is InputEventMouseButton and e.pressed: dismiss_strike())
 feedback_panel=FriendlyLook.panel(FriendlyLook.TONER,FriendlyLook.HIGHLIGHT,2); feedback_panel.position=Vector2(606,32); feedback_panel.size=Vector2(350,82); feedback_panel.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(feedback_panel); feedback_panel.hide()
 feedback_label=FriendlyLook.label("",12,FriendlyLook.HIGHLIGHT,FriendlyLook.BOLD); feedback_label.position=Vector2(10,7); feedback_label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; feedback_label.size=Vector2(330,70); feedback_panel.add_child(feedback_label)
 var log_paper:=FriendlyLook.panel(Color("#F4ECDA"), FriendlyLook.TONER, 0, 4); log_paper.position=Vector2(248,602); log_paper.size=Vector2(1104,15); log_paper.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(log_paper)
 log_text = FriendlyLook.label("", 10, FriendlyLook.TONER); log_text.position = Vector2(256, 603); log_text.size = Vector2(1092, 13); log_text.tooltip_text = "Chronological game log"; add_child(log_text)
 for panel in [node_tag, trace_tag, bottom_hud, note, rig_ground, piles_paper, program_bay]:
  var wear := FriendlyRigWear.new()
  wear.code_strip = panel in [node_tag,trace_tag]
  panel.add_child(wear, false, Node.INTERNAL_MODE_BACK)
  worn_panels.append(wear)

 build_key_tip()
 var display: Dictionary = AtomicDecoPunk.settings.display
 var sign := FriendlyLook.panel(skin.plaque_ground, skin.plaque_accent, 2, 10)
 sign.name = "CorporateDisplay"
 sign.mouse_filter = Control.MOUSE_FILTER_IGNORE
 at(self, sign, Vector2(590,16), Vector2(350,88))
 var wordmark := FriendlyLook.label(skin.app_name, int(display.wordmark_px), skin.plaque_ink, skin.display_font)
 var headline := FriendlyLook.label(skin.background_headline, int(display.background_headline_px), skin.plaque_ink, skin.display_font)
 for title in [wordmark, headline]:
  title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 at(sign, wordmark, Vector2(12,4), Vector2(326,40))
 at(sign, headline, Vector2(12,47), Vector2(326,32))
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
 for p in game.installed:
  var id: String = p.inst.id
  var uid: int = p.inst.uid
  var d := CardDB.def(id)
  var slot := VBoxContainer.new()
  slot.mouse_filter = Control.MOUSE_FILTER_PASS
  program_slots.add_child(slot)

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
  chip.text = d.name
  chip.clip_text = true
  chip.mouse_filter = Control.MOUSE_FILTER_STOP
  chip.size_flags_horizontal = Control.SIZE_EXPAND_FILL
  chip.add_theme_font_size_override("font_size", 13)
  crt_chip(chip)
  chip.tooltip_text = game.card_text(id)
  chip.pressed.connect(func(): ui.toggle_card_inspection(id, uid))
  chip.mouse_entered.connect(func(): ui.hover_program(id))
  chip.mouse_exited.connect(func(): ui.leave_program())
  slot.add_child(chip)

  var controls := HBoxContainer.new()
  controls.mouse_filter = Control.MOUSE_FILTER_PASS
  slot.add_child(controls)
  if d.has("pick"):
   var stats := FriendlyLook.label("STR %d · BOOST %d · BREAK %d" % [game.pick_str(p), d.pick.boost_cost, d.pick.break_cost], 10, FriendlyLook.PAPER)
   slot.add_child(stats)
   slot.move_child(stats, 1)
   var boost := FriendlyLook.button("+STR", func(): game.boost_pick(uid); ui.refresh())
   boost.tooltip_text = "Boost %d BW · Break %d BW" % [d.pick.boost_cost, d.pick.break_cost]
   controls.add_child(boost)
  elif d.get("uninstall_cache", false):
   var cache_action := FriendlyLook.button("UNINSTALL 1 BW", func(): game.uninstall_cache(uid); ui.refresh())
   cache_action.name = "SmashGrabCache"
   cache_action.disabled = game.bw < 1 or game.hand.is_empty()
   controls.add_child(cache_action)
  controls.add_child(FriendlyLook.button("×", func(): game.unload(uid); ui.leave_program(); ui.refresh(), FriendlyLook.PAPER))
  for control in controls.get_children():
   control.mouse_filter = Control.MOUSE_FILTER_PASS
 for c in game.rack:
  var d := CardDB.def(c.id)
  rig_row.add_child(FriendlyLook.button(d.name, func(): ui._show_inspect(c.id), FriendlyLook.TONER, FriendlyLook.PAPER))
func build_ice() -> void:
 ice_scroll.position.x = ICE_X
 mascots.clear()
 key_nodes.clear()
 hover_key = {}
 if is_instance_valid(key_tip): key_tip.hide()
 clear(ice_row)
 for i in game.enc.ice.size():
  var column := VBoxContainer.new(); column.add_theme_constant_override("separation",CONSOLE_OVERLAP); column.custom_minimum_size.x=400 if game.enc.ice.size()==3 else 480; ice_row.add_child(column)
  var mascot := FriendlyMascot.new()
  var prior := previous_mascot(i)
  mascot.previous_mood=prior.get("mood", "")
  mascot.just_broken=not prior.is_empty() and game.enc.ice[i].broken.count(true)>prior.broken.count(true)
  mascot.setup(self,i,mood_for(i))
  mascots.append(mascot)
  # Grow the animated illustration independently from its rules plaque.
  var width := 400.0 if game.enc.ice.size()==3 else 480.0
  # CARDS-004: the mascot stage gives up 44 px so the larger hand fits below.
  # ICE-ANALOG-001: the mascot grows about 18% (as far as the column width allows).
  var illustration_scale := (0.70 if game.enc.ice.size()==3 else 0.82) * 1.25 * (194.0 / 238.0) * MASCOT_GROWTH
  var stage := Control.new()
  stage.name = "MascotStage"
  var plate := AdpCopy.pick("plate", skin.corporation, 0, {"ice": game.enc.ice[i].id})
  stage.custom_minimum_size = Vector2(width, STAGE_H)
  column.add_child(drop_wrapper(stage,i,-1))
  stage.add_child(ice_frame(width))
  var carrier := Control.new()
  carrier.name = "IllustrationScale"
  carrier.scale = Vector2.ONE * illustration_scale
  carrier.position = Vector2((width - mascot.size.x * illustration_scale) / 2.0, FRAME_TOP + 16.0)
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
  if game.enc.ice[i].id == "AUTO_RENEW": add_shell_graffiti(mascot)
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
 return game.break_info(i,sub)
func break_action(i: int, sub: int) -> void:
 if game.phase == "CHOICE" and game.pending.get("kind") == "card_break": game.choose_sub(i,sub); ui.refresh()
 else:
  var ice: Dictionary=game.enc.ice[i]; var before: int=ice.break_progress[sub]; var cost: int=game.bw
  ui._on_break(i,sub)
  if ice.break_progress[sub]>before: show_break_feedback(ice,sub,cost-game.bw)
func mood_for(i: int) -> String:
 if game.enc.get("breached",false): return "knocked_out"
 var ice: Dictionary = game.enc.ice[i]
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
 ## ENC-CONCEPT-001 (concept 3) with ICE-ANALOG-001 keys: the lower half of the ICE console.
 ## Power lamp and name plate, STR plate, icon keys (+ TUMBLER reel), the passive plate and this
 ## ICE's NEXT RESPONSE plate in full words. Hover or focus a key for its full rule.
 var ice: Dictionary = game.enc.ice[i]; var d := game.ice_definition(ice)
 var panel := PanelContainer.new(); var scan_width:=400 if game.enc.ice.size()==3 else 480
 panel.custom_minimum_size=Vector2(scan_width,0)
 var candidates:=game.hand.filter(func(c): return CardDB.def(c.id).get("zeroed_reduction",0)>0 and game.can_play(c.uid).ok and game.would_zero(i,int(CardDB.def(c.id).get("zeroed_reduction",0))))
 var eligible:=not candidates.is_empty()
 var style := StyleBoxFlat.new(); style.bg_color = console_ground()
 style.border_color = FriendlyLook.AMBER if eligible else CONSOLE_CHROME
 style.border_width_left = 4; style.border_width_right = 4; style.border_width_bottom = 4; style.border_width_top = 0
 style.corner_radius_bottom_left = 22; style.corner_radius_bottom_right = 22
 style.shadow_color = Color("#1A110A66"); style.shadow_size = 8; style.shadow_offset = Vector2(0, 6)
 style.content_margin_left = 16; style.content_margin_right = 16; style.content_margin_top = 8; style.content_margin_bottom = 12
 panel.add_theme_stylebox_override("panel",style)
 if eligible: panel.tooltip_text="ZEROED available: "+" / ".join(candidates.map(func(c): return CardDB.def(c.id).name))
 var list := VBoxContainer.new(); list.add_theme_constant_override("separation",6); panel.add_child(list)
 var heading := HBoxContainer.new(); heading.add_theme_constant_override("separation",6); list.add_child(heading)
 var power := Analog.lamp(Color("#4DFF6E") if not game.enc.get("breached",false) else Color("#3A3632"), not game.enc.get("breached",false), 14)
 power.size_flags_vertical = Control.SIZE_SHRINK_CENTER; heading.add_child(power)
 heading.add_child(console_plate(d.name.to_upper(),CONSOLE_GLASS,CONSOLE_CREAM,20,console_font(2)))
 var gap := Control.new(); gap.size_flags_horizontal=Control.SIZE_EXPAND_FILL; heading.add_child(gap)
 heading.add_child(console_plate("STR %d" % game.ice_str(i),CONSOLE_CREAM,CONSOLE_INK,20,console_font(1)))
 var delta: int = game.ice_str(i)-int(d.str)
 if delta!=0: heading.add_child(console_plate(("↑%d" if delta>0 else "↓%d") % absi(delta),Color("#2F7A4C") if delta>0 else Color("#B3261A"),Color.WHITE,16,console_font(0)))
 var meta := FriendlyLook.label(" · ".join([d.type,d.get("subtype", "")]).trim_suffix(" · "),12,CONSOLE_INK,console_font(3))
 list.add_child(meta)
 if ice.get("zeroed",false): list.add_child(FriendlyLook.label("ZEROED · chance consumed",11,CONSOLE_INK))
 var bank := HBoxContainer.new(); bank.alignment=BoxContainer.ALIGNMENT_CENTER; bank.add_theme_constant_override("separation",2); list.add_child(bank)
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
 if not passive_text.is_empty(): list.add_child(cream_plate("PASSIVE: " + passive_text, scan_width - 32, "PassivePlate"))
 list.add_child(cream_plate("NEXT RESPONSE: " + response_words(i), scan_width - 32, "NextResponse"))
 if not ice.virus.is_empty():
  var counts := []
  for strain in ice.virus:
   if ice.virus[strain]>0: counts.append("%s %d" % [strain,ice.virus[strain]])
  var strains := FriendlyLook.label(" · ".join(counts),12,Color("#7A1208"),console_font(1)); strains.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; list.add_child(strains)
  if game.worm_ok(i): list.add_child(FriendlyLook.button("SPEND 2 WORM · BREAK 1",func(): game.use_worm(i); ui.refresh()))
 if game.pending.get("kind")=="patient_zero": list.add_child(FriendlyLook.button("INFECT THIS ICE",func(): game.choose_ice(i); ui.refresh()))
 if not plate_text.is_empty() and game.enc.ice.size() < 3:
  # The ADP-2c patent plate sits at the foot of the console.
  var plaque := FriendlyLook.label(plate_text, 9, CONSOLE_INK, skin.font); plaque.name="PatentPlate"
  plaque.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; plaque.clip_text=true; plaque.custom_minimum_size.x=scan_width-32
  list.add_child(plaque)
 return panel

const CONSOLE_INK := Color("#1F3A33")
const FRAME_TOP := 14.0

func console_ground() -> Color:
 ## The console's enamel: the corporation's plaque ground tinted toward its accent (HALCYON: seafoam).
 return skin.plaque_ground.lerp(skin.accent, 0.42)

func cream_plate(text: String, width: float, plate_name: String) -> PanelContainer:
 var plate := PanelContainer.new(); plate.name = plate_name; plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
 var st := FriendlyLook.style(CONSOLE_CREAM, Color("#C9B796"), 1, 8); st.content_margin_left = 10; st.content_margin_right = 10; st.content_margin_top = 4; st.content_margin_bottom = 4
 plate.add_theme_stylebox_override("panel", st)
 var label := FriendlyLook.label(text, 12, CONSOLE_INK, skin.medium_font)
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

func ice_frame(width: float) -> Control:
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
 var st := FriendlyLook.style(bg,Color.TRANSPARENT,0,6); st.content_margin_left=9; st.content_margin_right=9; st.content_margin_top=1; st.content_margin_bottom=1
 plate.add_theme_stylebox_override("panel",st)
 plate.add_child(FriendlyLook.label(text,px,ink,font))
 return plate

func chevron() -> Control:
 var c := Control.new(); c.custom_minimum_size=Vector2(12,60); c.mouse_filter=Control.MOUSE_FILTER_IGNORE
 c.draw.connect(func():
  var y := 14.0+30.0
  c.draw_colored_polygon(PackedVector2Array([Vector2(3,y-6),Vector2(10,y),Vector2(3,y+6)]),Color("#B07A2A")))
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
 key.configure(kind,value,state,chip,mini)
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
  _: t = ui._effect_word(e)
 if e.get("curve","")=="B": t += " Random roll."
 if e.get("curve","")=="C": t += " Hammer curve."
 if e.get("escalate",false): t += " Grows each response."
 return t

func build_key_tip() -> void:
 key_tip = PanelContainer.new(); key_tip.name="KeyTip"; key_tip.mouse_filter=Control.MOUSE_FILTER_IGNORE; key_tip.z_index=160
 var st := FriendlyLook.style(Color("#F6EFDF"),CONSOLE_CHROME,3,12); st.set_content_margin_all(14); st.shadow_color=Color("#1A110A66"); st.shadow_size=10; st.shadow_offset=Vector2(0,6)
 key_tip.add_theme_stylebox_override("panel",st)
 key_tip_list = VBoxContainer.new(); key_tip_list.add_theme_constant_override("separation",5); key_tip.add_child(key_tip_list)
 add_child(key_tip); key_tip.hide()

func show_key_tip(i: int, s: int, anchor: Rect2) -> void:
 if dragging_uid >= 0: return   # the drag header already explains a drop
 clear(key_tip_list)
 var ice: Dictionary = game.enc.ice[i]; var d := game.ice_definition(ice)
 var lines := key_rule_lines(i,s)
 var slot: int = game.active_subs(i).find(s)
 var where := ("SLOT %d · S%d" % [slot+1,s+1]) if d.type=="TUMBLER" and slot>=0 else "S%d" % (s+1)
 key_tip_list.add_child(FriendlyLook.label(where + "  ·  " + d.name, 12, Color("#6B5A44"), skin.bold_font))
 key_tip_list.add_child(FriendlyLook.label(lines[0], 22, IceKey.INK, CONDENSED))
 var rule := FriendlyLook.label("Rule: " + " ".join(lines.slice(1)), 14, IceKey.INK, skin.font); rule.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; rule.custom_minimum_size.x=300; key_tip_list.add_child(rule)
 var timing := "Broken." if ice.broken[s] else ("Fires in the next Corporation Response." if game.is_active(i,s) else "Not in a slot this turn.")
 key_tip_list.add_child(FriendlyLook.label("Timing: " + timing, 14, IceKey.INK, skin.font))
 if not ice.broken[s] and ice.seen[s]:
  var info := break_info(i,s)
  var text := ("Break: %s" % ("free" if int(info.get("cost",0))==0 else "%d BW" % info.cost)) if info.ok else "Break: " + String(info.get("reason","not now"))
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
 return at.y < (size.y * 0.5 if d.type == "SCRIPT" else 696.0)
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

func build_node_plate() -> void:
 # PANOPTICON wordmark with its eye, then the network/node plate.
 var eye := Analog.icon("EYE", 26, Analog.GLOW); at(node_tag, eye, Vector2(14, 10))
 at(node_tag, FriendlyLook.label("PANOPTICON", 22, Analog.CREAM, console_font(5)), Vector2(48, 6))
 var tier := "OPENING" if game.is_opening() else String(game.node.get("tier", "TIER 1"))
 at(node_tag, FriendlyLook.label("%s · LAYER %d/%d" % [tier, game.layer + 1, game.node.layers.size()], 13, Analog.CREAM_DIM, console_font(2)), Vector2(232, 12))
 var plate := console_plate("%s NETWORK  //  NODE: %s" % [skin.corporation, String(game.node.name).to_upper()], CONSOLE_CREAM, CONSOLE_INK, 16, console_font(1))
 at(node_tag, plate, Vector2(14, 46))
 plate.custom_minimum_size.x = 370

func build_trace_plate() -> void:
 var hostile := corporation_state == "mask_off" or strike_overlay.visible
 var cond := "MASK OFF" if hostile else corporation_state.to_upper()
 var cond_bg := Color("#2F7A4C") if corporation_state == "friendly" else (Color("#14070A") if hostile else Color("#B3261A"))
 var pill := console_plate("CONDITION: " + cond, cond_bg, Color.WHITE, 16, console_font(2))
 at(trace_tag, pill, Vector2(14, 12))
 var reveal := 0
 if corporation_state == "cracking": reveal = roundi(AtomicDecoPunk.reveal(bleed) * 100.0)
 elif hostile: reveal = 100
 at(trace_tag, console_plate("HOSTILE REVEAL  %d%%" % reveal, Color("#2A0606") if reveal > 0 else CONSOLE_GLASS, Color("#FF7A6A") if reveal > 0 else Analog.CREAM_DIM, 15, console_font(2)), Vector2(14, 52))
 at(trace_tag, amber_label("TURN", 12), Vector2(232, 10))
 at(trace_tag, Analog.tiles("%02d" % game.enc.turn, Vector2(24, 38), 28), Vector2(232, 28))
 var hot := game.trace >= 20
 at(trace_tag, amber_label("TRACE", 12), Vector2(300, 10))
 at(trace_tag, Analog.tiles("%02d" % game.trace, Vector2(24, 38), 28, Color("#FF6A5A") if hot else Analog.CREAM), Vector2(300, 28))
 at(trace_tag, FriendlyLook.label("/40", 16, Analog.CREAM_DIM, console_font(1)), Vector2(352, 40))
 at(trace_tag, Analog.instrument("bars", roundi(game.trace / 4.0), 10, Vector2(80, 6), Color("#FF3A2A") if hot else Analog.GLOW), Vector2(300, 72))
 at(trace_tag, amber_label("STRIKES", 12), Vector2(398, 10))
 for k in 3: at(trace_tag, Analog.lamp(Analog.RED, k < game.strikes, 16), Vector2(400 + k * 24, 34))
 at(trace_tag, amber_label("RESERVE", 12), Vector2(486, 10))
 at(trace_tag, Analog.tiles("%02d" % game.enc.reserve, Vector2(20, 30), 22, Analog.GLOW if game.enc.reserve > 0 else Color("#FF6A5A")), Vector2(486, 28))
 at(trace_tag, FriendlyLook.label("/ %d CRED" % game.enc.reserve_start, 14, Analog.CREAM_DIM, console_font(1)), Vector2(532, 34))
 at(trace_tag, FriendlyLook.label("CRED %d · RAM %d/%d" % [game.cred, game.ram_used(), game.ram_total()], 13, Analog.CREAM, console_font(1)), Vector2(398, 62))
 at(trace_tag, FriendlyLook.label("PAST 50% · THEY'RE LOOKING" if corporation_state=="cracking" else "", 12, Color("#FF7A6A"), console_font(1)), Vector2(398, 78))
 bleed_label = FriendlyLook.label("", 11, FriendlyLook.PAPER)
 at(trace_tag, bleed_label, Vector2(560, 64))
 update_bleed_readout()

func incoming_pulp() -> int:
 var total := 0
 for step in game.response_preview():
  if step.skipped or step.hidden: continue
  for source in step.effects:
   var e := game.effect_value(game.enc.ice[step.ice], source)
   if e.k == "PULP": total += int(e.get("v", 0))
 return total

func vital_row(y: float, icon_kind: String, label: String, col: Color, readout: String, gauge: Control) -> void:
 at(bottom_hud, Analog.icon(icon_kind, 22, col), Vector2(12, y + 2))
 at(bottom_hud, amber_label(label, 12), Vector2(42, y))
 var value := FriendlyLook.label(readout, 18, Analog.CREAM, CONDENSED); value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
 at(bottom_hud, value, Vector2(142, y - 4), Vector2(70, 22))
 at(bottom_hud, gauge, Vector2(42, y + 17))

func build_instruments() -> void:
 # Concept 2's vitals: an icon, a label, a segmented gauge and the number.
 vital_row(10, "VITAE", "VITAE", Color("#FF5A4A"), "%d/%d" % [game.vitae, game.max_vitae], Analog.instrument("bars", ceili(10.0 * game.vitae / maxf(1.0, game.max_vitae)), 10, Vector2(170, 8), Color("#FF3A2A")))
 vital_row(48, "BW", "BANDWIDTH", Color("#FFC84A"), "%d/%d" % [game.bw, bw_capacity], Analog.instrument("lamps", game.bw, mini(10, bw_capacity), Vector2(170, 12), Color("#FFB020")))
 vital_row(86, "SHIELD", "SHIELD", Color("#7FD0FF"), str(game.shield), Analog.instrument("bars", mini(12, game.shield), 12, Vector2(170, 8), Analog.BLUE))
 var pulp := incoming_pulp()
 vital_row(124, "PULP", "PULP INCOMING", Color("#FF8A3A"), str(pulp), Analog.instrument("bars", mini(12, pulp), 12, Vector2(170, 8), Color("#FF8A3A")))
 vital_row(162, "DRAW", "NEXT DRAW", Analog.CREAM, str(game.draw_size()), Control.new())

func update_crt_status() -> void:
 var state: String = {"friendly": "FRIENDLY", "cracking": "CRACKING", "mask_off": "MASK OFF"}.get(corporation_state, "")
 crt_status.text = "%s\nNODE // %s\nSTATUS: %s" % [skin.corporation, String(game.node.name).to_upper(), state]
 crt_status.add_theme_color_override("font_color", CRT_INK if corporation_state == "friendly" else Color("#FF8FB8"))

func style_end_turn(button: Button) -> void:
 ## A round red push-button in a chrome ring (concept 3).
 button.add_theme_font_override("font", console_font(3))
 button.add_theme_font_size_override("font_size", 22)
 for state in ["normal", "hover", "pressed", "disabled", "focus"]:
  var st := StyleBoxFlat.new()
  st.bg_color = {"normal": Color("#C9271B"), "hover": Color("#E0382A"), "pressed": Color("#9C1F15"), "disabled": Color("#6E4A44"), "focus": Color.TRANSPARENT}[state]
  st.border_color = Color("#D5DBDD"); st.set_border_width_all(6); st.set_corner_radius_all(54); st.anti_aliasing = true
  if state in ["normal", "hover"]:
   st.shadow_color = Color("#00000088"); st.shadow_size = 8; st.shadow_offset = Vector2(0, 5)
  if state == "focus":
   st.draw_center = false; st.border_color = FriendlyLook.SERVICE_TEAL; st.set_border_width_all(3)
  button.add_theme_stylebox_override(state, st)
 for c in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color", "font_disabled_color"]:
  button.add_theme_color_override(c, Color.WHITE)

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
