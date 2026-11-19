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
## Graffiti lands in free margins: under the Program Bay and under the TRACE panel.
const GRAFFITI_SPOTS := [Vector2(40, 357), Vector2(1360, 262), Vector2(1360, 290), Vector2(1360, 318)]
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
 node_tag = FriendlyLook.panel(FriendlyLook.TONER); node_tag.position = Vector2(40, 32); node_tag.size = Vector2(720, 86); node_tag.rotation_degrees = -1.0; add_child(node_tag)
 trace_tag = FriendlyLook.panel(FriendlyLook.TONER); trace_tag.position = Vector2(972, 32); trace_tag.size = Vector2(588, 106); trace_tag.rotation_degrees = 0.7; add_child(trace_tag)
 ice_scroll = ScrollContainer.new(); ice_scroll.position = Vector2(ICE_X, 136); ice_scroll.size = Vector2(1300, 402); ice_scroll.scale = Vector2.ONE * ICE_SCALE; ice_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO; ice_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO; add_child(ice_scroll)
 ice_row = HBoxContainer.new(); ice_row.add_theme_constant_override("separation", 42); ice_row.alignment = BoxContainer.ALIGNMENT_CENTER; ice_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL; var ice_margin:=MarginContainer.new(); ice_margin.add_theme_constant_override("margin_top",10); ice_margin.size_flags_horizontal=Control.SIZE_EXPAND_FILL; ice_scroll.add_child(ice_margin); ice_margin.add_child(ice_row)
 var strip := FriendlyLook.panel(FriendlyLook.PAPER, FriendlyLook.TONER, 3); strip.position = Vector2(248, 486); strip.size = Vector2(1104, 49); add_child(strip)
 var rs := ScrollContainer.new(); rs.position = Vector2(10, 7); rs.size = Vector2(1084, 36); rs.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; strip.add_child(rs)
 response = HBoxContainer.new(); response.add_theme_constant_override("separation", 7); rs.add_child(response)
 note = FriendlyLook.panel(FriendlyLook.TONER); note.position = Vector2(248, 546); note.size = Vector2(1104, 44); note.rotation_degrees = -0.4; add_child(note)
 note_text = FriendlyLook.label("", 12, FriendlyLook.HIGHLIGHT); note_text.position = Vector2(10, 4); note_text.size = Vector2(900, 36); note_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; note.add_child(note_text)
 var voice := FriendlyLook.button("VOICE / M", func(): ui._toggle_voice(), FriendlyLook.TONER, FriendlyLook.PAPER); voice.position = Vector2(995, 7); voice.size = Vector2(100, 30); note.add_child(voice)
 var rig_ground := FriendlyLook.panel(FriendlyLook.TONER); rig_ground.position=Vector2(248,592); rig_ground.size=Vector2(1104,28); add_child(rig_ground)
 var rig_scroll := ScrollContainer.new(); rig_scroll.position = Vector2(248, 592); rig_scroll.size = Vector2(1104, 28); rig_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; add_child(rig_scroll)
 rig_row = HBoxContainer.new(); rig_row.add_theme_constant_override("separation", 8); rig_scroll.add_child(rig_row)
 program_bay = FriendlyProgramBay.new()
 program_bay.encounter = self
 program_bay.name = "ProgramBay"
 program_bay.mouse_filter = Control.MOUSE_FILTER_PASS
 program_bay.add_theme_stylebox_override("panel", FriendlyLook.style(FriendlyLook.TONER, FriendlyLook.HIGHLIGHT, 2))
 at(self, program_bay, Vector2(40,153), Vector2(200,200))
 at(program_bay, FriendlyLook.label("PROGRAM BAY", 15, FriendlyLook.PAPER, FriendlyLook.BOLD), Vector2(11,9))
 var program_scroll := ScrollContainer.new()
 program_scroll.mouse_filter = Control.MOUSE_FILTER_PASS
 program_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
 at(program_bay, program_scroll, Vector2(9,39), Vector2(182,110))
 program_slots = VBoxContainer.new()
 program_slots.name = "ProgramSlots"
 program_slots.mouse_filter = Control.MOUSE_FILTER_PASS
 program_slots.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 program_slots.add_theme_constant_override("separation", 8)
 program_scroll.add_child(program_slots)
 var connector := FriendlyLook.panel(Color("#322B21"), FriendlyLook.HIGHLIGHT, 1, 3)
 connector.mouse_filter = Control.MOUSE_FILTER_IGNORE
 at(program_bay, connector, Vector2(10,151), Vector2(180,44))
 at(connector, FriendlyLook.label("DROP PROGRAM HERE", 12, FriendlyLook.HIGHLIGHT, FriendlyLook.BOLD), Vector2(9,6))
 for pin in range(18):
  var contact := ColorRect.new()
  contact.color = FriendlyLook.HIGHLIGHT
  contact.mouse_filter = Control.MOUSE_FILTER_IGNORE
  at(connector, contact, Vector2(10 + pin * 9,29), Vector2(5,8))
 hand = FriendlyHand.new(); hand.position = HAND_RECT.position; hand.size = HAND_RECT.size; hand.focus_mode = Control.FOCUS_ALL; hand.mouse_filter = Control.MOUSE_FILTER_PASS; add_child(hand)
 bottom_hud = FriendlyLook.panel(FriendlyLook.TONER); bottom_hud.position = Vector2(40, 416); bottom_hud.size = Vector2(200, 212); add_child(bottom_hud)
 var piles_paper:=FriendlyLook.panel(FriendlyLook.PAPER); piles_paper.position=Vector2(1358,404); piles_paper.size=Vector2(204,70); piles_paper.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(piles_paper)
 pile_text = FriendlyLook.label("", 12, FriendlyLook.TONER); pile_text.position = Vector2(1364, 408); pile_text.size = Vector2(198, 64); pile_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; add_child(pile_text)
 end_button = FriendlyLook.button("END TURN →", func(): ui._on_end_turn()); end_button.position = Vector2(1360, 480); end_button.size = Vector2(200, 65); end_button.add_theme_font_size_override("font_size", 20); add_child(end_button)
 var deck := FriendlyLook.button("DECK / COVERAGE", func(): ui.deck_open = true; ui.refresh(), FriendlyLook.PAPER); deck.position = Vector2(1360, 554); deck.size = Vector2(200, 28); add_child(deck)
 end_run_button = FriendlyLook.button("END RUN", func(): ui._confirm_end_run(), FriendlyLook.TONER, FriendlyLook.RED); end_run_button.position = Vector2(1360, 589); end_run_button.size = Vector2(200, 29); add_child(end_run_button)
 toast = FriendlyLook.panel(Color.WHITE, FriendlyLook.RED, 1, 10, 3)
 at(self, toast, Vector2(1358, 150), Vector2(204, 105))
 toast.z_index = 5
 toast_text = FriendlyLook.label(skin.cracking_copy, 15, FriendlyLook.TONER, skin.font)
 toast_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 at(toast, toast_text, Vector2(8, 6), Vector2(184, 72))
 toast_reply = FriendlyLook.label("", 14, FriendlyLook.TONER, ADP_MARKER)
 at(toast, toast_reply, Vector2(8, 80), Vector2(184, 20))
 toast.hide()
 punch_arrival = FriendlyLook.panel(FriendlyLook.TONER, FriendlyLook.HIGHLIGHT, 1, 5)
 at(self, punch_arrival, Vector2(1358, 150), Vector2(204, 105))
 punch_arrival.clip_contents = true
 punch_arrival.hide()
 punch_holder = FriendlyLook.panel(FriendlyLook.TONER, FriendlyLook.PAPER, 1, 4)
 at(self, punch_holder, Vector2(40, 380), Vector2(200, 31))
 punch_holder.clip_contents = true
 punch_count = FriendlyLook.label("", 13, FriendlyLook.PAPER, FriendlyLook.BOLD)
 at(punch_holder, punch_count, Vector2(8, 5))
 punch_shadow = Control.new()
 punch_shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
 punch_holder.add_child(punch_shadow)
 var inspect_punches := FriendlyLook.button("VIEW", func(): ui.open_punches(), FriendlyLook.TONER, FriendlyLook.PAPER)
 at(punch_holder, inspect_punches, Vector2(149, 2), Vector2(48, 26))
 strike_overlay = Control.new(); strike_overlay.name="StrikeOneModal"; strike_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); strike_overlay.mouse_filter=Control.MOUSE_FILTER_STOP; strike_overlay.z_index=200; add_child(strike_overlay); strike_overlay.hide()
 motion_button=FriendlyLook.button("REDUCED MOTION: OFF",func(): ui.set_reduced_motion(not ui.reduced_motion),FriendlyLook.PAPER)
 motion_button.position=Vector2(1360,356); motion_button.size=Vector2(200,28); motion_button.add_theme_font_size_override("font_size",10); add_child(motion_button)
 watcher_warning=FriendlyLook.panel(FriendlyLook.RED); watcher_warning.position=Vector2(1030,540); watcher_warning.size=Vector2(510,36); watcher_warning.z_index=150; watcher_warning.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(watcher_warning)
 watcher_text=FriendlyLook.label("",12,FriendlyLook.TONER,FriendlyLook.BOLD); watcher_text.position=Vector2(8,7); watcher_warning.add_child(watcher_text); watcher_warning.hide()
 strike_overlay.gui_input.connect(func(e):
  if e is InputEventMouseButton and e.pressed: dismiss_strike())
 feedback_panel=FriendlyLook.panel(FriendlyLook.TONER,FriendlyLook.HIGHLIGHT,2); feedback_panel.position=Vector2(606,32); feedback_panel.size=Vector2(350,82); feedback_panel.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(feedback_panel); feedback_panel.hide()
 feedback_label=FriendlyLook.label("",12,FriendlyLook.HIGHLIGHT,FriendlyLook.BOLD); feedback_label.position=Vector2(10,7); feedback_label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; feedback_label.size=Vector2(330,70); feedback_panel.add_child(feedback_label)
 var log_paper:=FriendlyLook.panel(FriendlyLook.PAPER); log_paper.position=Vector2(248,473); log_paper.size=Vector2(1104,13); log_paper.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(log_paper)
 log_text = FriendlyLook.label("", 10, FriendlyLook.TONER); log_text.position = Vector2(248, 473); log_text.size = Vector2(1104, 13); log_text.tooltip_text = "Chronological game log"; add_child(log_text)
 for panel in [node_tag, trace_tag, bottom_hud, note, rig_ground, piles_paper, program_bay]:
  var wear := FriendlyRigWear.new()
  wear.code_strip = panel in [node_tag,trace_tag]
  panel.add_child(wear, false, Node.INTERNAL_MODE_BACK)
  worn_panels.append(wear)

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
 node_tag.size.x = FriendlyLook.BOLD.get_string_size("NODE: " + game.node.name, HORIZONTAL_ALIGNMENT_LEFT, -1, 29).x + 28
 at(node_tag, FriendlyLook.label("NODE: " + game.node.name, 29, FriendlyLook.PAPER, FriendlyLook.BOLD), Vector2(12, 0), Vector2(700, 46))
 var node_meta := FriendlyLook.panel(FriendlyLook.HIGHLIGHT); at(node_tag, node_meta, Vector2(0, 48), Vector2(540, 30))
 at(node_meta, FriendlyLook.label("%s · %s · LAYER %d/%d · TURN %d" % [skin.corporation,"OPENING" if game.is_opening() else game.node.get("tier", "TIER 1"), game.layer + 1, game.node.layers.size(), game.enc.turn], 13, FriendlyLook.TONER, FriendlyLook.BOLD), Vector2(9, 4))
 at(trace_tag, FriendlyLook.label("TRACE", 13, FriendlyLook.PAPER), Vector2(14, 12))
 var bar := ProgressBar.new(); bar.min_value = 0; bar.max_value = Game.MAX_TRACE; bar.value = game.trace; bar.show_percentage = false
 bar.add_theme_stylebox_override("background", FriendlyLook.style(Color("#3A3A3A"))); bar.add_theme_stylebox_override("fill", FriendlyLook.style(FriendlyLook.RED))
 at(trace_tag, bar, Vector2(86, 15), Vector2(240, 18))
 var tick := ColorRect.new(); tick.color = FriendlyLook.PAPER; tick.mouse_filter = Control.MOUSE_FILTER_IGNORE; at(trace_tag, tick, Vector2(205, 10), Vector2(2, 28))
 at(trace_tag, FriendlyLook.label("%d/40" % game.trace, 25, FriendlyLook.RED if game.trace >= 20 else FriendlyLook.PAPER, FriendlyLook.BOLD), Vector2(340, 2))
 at(trace_tag, FriendlyLook.label("STRIKES " + "■".repeat(mini(3, game.strikes)) + "□".repeat(maxi(0, 3 - game.strikes)), 13, FriendlyLook.RED), Vector2(450, 12))
 at(trace_tag, FriendlyLook.label("CRED %d  ·  RESERVE %d/%d  ·  RAM %d/%d" % [game.cred, game.enc.reserve, game.enc.reserve_start, game.ram_used(), game.ram_total()], 12, FriendlyLook.RED if game.enc.reserve==0 else FriendlyLook.PAPER), Vector2(14, 45))
 var reserve := ProgressBar.new(); reserve.max_value=maxi(1,game.enc.reserve_start); reserve.value=game.enc.reserve; reserve.show_percentage=false; reserve.add_theme_stylebox_override("background",FriendlyLook.style(Color("#3A3A3A"))); reserve.add_theme_stylebox_override("fill",FriendlyLook.style(FriendlyLook.HIGHLIGHT)); at(trace_tag,reserve,Vector2(14,65),Vector2(264,3))
 bleed_label = FriendlyLook.label("", 11, FriendlyLook.PAPER)
 at(trace_tag, bleed_label, Vector2(448, 73))
 update_bleed_readout()
 at(trace_tag, FriendlyLook.label("PAST 50% · THEY'RE LOOKING" if corporation_state=="cracking" else "FOOTPRINT %d/%d · %s · AMP %d" % [game.footprint(),game.footprint_cap(),game.footprint_band(),game.amp],11,FriendlyLook.RED if corporation_state=="cracking" else FriendlyLook.HIGHLIGHT),Vector2(14,73))
 var stats := [["BW", str(game.bw), FriendlyLook.HIGHLIGHT], ["VITAE", "%d/%d" % [game.vitae, game.max_vitae], FriendlyLook.PAPER], ["SHIELD", str(game.shield), FriendlyLook.PAPER], ["NEXT DRAW", str(game.draw_size()), FriendlyLook.PAPER]]
 for i in stats.size():
  at(bottom_hud, FriendlyLook.label(stats[i][0], 11, FriendlyLook.PAPER), Vector2(12, i * 52 + 15))
  at(bottom_hud, FriendlyLook.label(stats[i][1], 22, stats[i][2], FriendlyLook.BOLD), Vector2(99, i * 52 + 5))
  if i > 0:
   var line := ColorRect.new(); line.color = Color("#3A3A3A"); at(bottom_hud, line, Vector2(0, i * 52), Vector2(200, 2))
 for i in mini(12,bw_capacity):
  var slit := ColorRect.new(); slit.color = FriendlyLook.HIGHLIGHT if i<maxi(0,bw_capacity-game.bw) else Color("#3A3A3A"); at(bottom_hud,slit,Vector2(12+i*14,39),Vector2(10,5))
 pile_text.text = "DECK %d · DISCARD %d\nFP %d/%d · %s\nREBOOT ~%d · AMP %d" % [game.draw_pile.size(), game.discard.size(),game.footprint(),game.footprint_cap(),game.footprint_band(),int(ceil(float(game.draw_pile.size())/maxi(1,game.draw_size()))),game.amp]
 end_button.disabled = game.phase != "PLAYER" or ui.responding
 end_run_button.disabled = ui.responding
 track_new_subs()
 build_rig(); build_ice(); build_response(); build_hand()
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
  while fs>8 and FriendlyLook.MONO.get_multiline_string_size(note_text.text,HORIZONTAL_ALIGNMENT_LEFT,900,fs).y>36: fs-=1
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
  chip.add_theme_font_size_override("font_size", 12)
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
 clear(ice_row)
 for i in game.enc.ice.size():
  var column := VBoxContainer.new(); column.add_theme_constant_override("separation",9); column.custom_minimum_size.x=400 if game.enc.ice.size()==3 else 480; ice_row.add_child(column)
  var mascot := FriendlyMascot.new()
  var prior := previous_mascot(i)
  mascot.previous_mood=prior.get("mood", "")
  mascot.just_broken=not prior.is_empty() and game.enc.ice[i].broken.count(true)>prior.broken.count(true)
  mascot.setup(self,i,mood_for(i))
  mascots.append(mascot)
  # Grow the animated illustration independently from its rules plaque.
  var width := 400.0 if game.enc.ice.size()==3 else 480.0
  # CARDS-004: the mascot stage gives up 44 px so the larger hand fits below.
  var illustration_scale := (0.70 if game.enc.ice.size()==3 else 0.82) * 1.25 * (194.0 / 238.0)
  var stage := Control.new()
  stage.name = "MascotStage"
  var plate := AdpCopy.pick("plate", skin.corporation, 0, {"ice": game.enc.ice[i].id})
  stage.custom_minimum_size = Vector2(width, 194 if plate.is_empty() else 210)
  column.add_child(drop_wrapper(stage,i,-1))
  if not plate.is_empty():
   var plaque := FriendlyLook.label(plate.text, 10, FriendlyLook.TONER, skin.font)
   plaque.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
   var enamel := FriendlyLook.panel(Color("#E2ECEB"))
   enamel.mouse_filter = Control.MOUSE_FILTER_IGNORE
   enamel.add_child(plaque)
   plaque.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
   at(stage, enamel, Vector2(0, 194), Vector2(width, 15))
  var carrier := Control.new()
  carrier.name = "IllustrationScale"
  carrier.scale = Vector2.ONE * illustration_scale
  carrier.position.x = (width - mascot.size.x * illustration_scale) / 2.0
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
  var scan := scan_tag(i); scan.size_flags_horizontal=Control.SIZE_SHRINK_CENTER; column.add_child(scan)
  if mood_for(i)=="knocked_out" and not reduced_motion:
   scan.ready.connect(func(): var peel:=scan.create_tween().set_parallel(true); peel.tween_property(scan,"rotation_degrees",1.5,0.4); peel.tween_property(scan,"position:y",scan.position.y+8,0.4))
func build_response() -> void:
 clear(response); response.add_child(FriendlyLook.label("NEXT RESPONSE ▸", 15, FriendlyLook.TONER, FriendlyLook.BOLD))
 for step in game.response_preview():
  if step.skipped: continue
  var words := []
  if step.hidden: words.append("? HIDDEN")
  else:
   for e in step.effects:
    words.append(effect_text(game.enc.ice[step.ice],e))
  var danger := false
  if not step.hidden:
   for source in step.effects:
    var e := game.effect_value(game.enc.ice[step.ice],source)
    if e.k=="PULP" and int(e.get("v",0))==biggest_hit() and biggest_hit()>0: danger=true
  var chip := rule_chip(" + ".join(words),"new" if danger else "normal")
  chip.tooltip_text = step.name; response.add_child(chip)

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
func scan_tag(i: int) -> Control:
 var ice: Dictionary = game.enc.ice[i]; var d := game.ice_definition(ice)
 var panel := PanelContainer.new(); var scan_width:=380 if game.enc.ice.size()==3 else 440
 panel.custom_minimum_size=Vector2(scan_width,0)
 var candidates:=game.hand.filter(func(c): return CardDB.def(c.id).get("zeroed_reduction",0)>0 and game.can_play(c.uid).ok and game.would_zero(i,int(CardDB.def(c.id).get("zeroed_reduction",0))))
 var eligible:=not candidates.is_empty()
 var style := FriendlyLook.style(skin.plaque_ground,FriendlyLook.AMBER if eligible else Color("#A2B6BA"),3 if eligible else 2,12,5); style.shadow_color=Color("#243C4533"); style.shadow_offset=Vector2(0,4); style.set_content_margin_all(12); panel.add_theme_stylebox_override("panel",style)
 if eligible: panel.tooltip_text="ZEROED available: "+" / ".join(candidates.map(func(c): return CardDB.def(c.id).name))
 var list := VBoxContainer.new(); list.add_theme_constant_override("separation",4); panel.add_child(list)
 var heading := HBoxContainer.new(); list.add_child(heading)
 var name := FriendlyLook.label(d.name,17,skin.plaque_ink,skin.bold_font); name.size_flags_horizontal=Control.SIZE_EXPAND_FILL; heading.add_child(name)
 var delta: int = game.ice_str(i)-int(d.str)
 heading.add_child(FriendlyLook.label("STR %d%s" % [game.ice_str(i)," ↑%d" % delta if delta>0 else ""],15,skin.plaque_accent,FriendlyLook.BOLD))
 var meta := FriendlyLook.label(" · ".join([d.type,d.get("subtype", ""),d.get("passive",d.get("ability", ""))]).replace(" ·  · "," · "),12,skin.plaque_muted)
 meta.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; meta.custom_minimum_size.x=scan_width-24; list.add_child(meta)
 if ice.get("zeroed",false): list.add_child(FriendlyLook.label("ZEROED · chance consumed",10,skin.plaque_accent))
 var rows: Array = game.active_subs(i).duplicate()
 if d.type == "TUMBLER":
  for s in d.subs.size():
   if ice.broken[s] and not rows.has(s): rows.append(s)
 elif d.type == "VOID":
  for s in d.subs.size():
   if not rows.has(s): rows.append(s)
 for s in rows:
  var row := HBoxContainer.new(); row.add_theme_constant_override("separation",6)
  var slot: int = game.active_subs(i).find(s)
  var label := "SLOT %d · S%d" % [slot+1,s+1] if d.type=="TUMBLER" and slot>=0 else "S%d" % (s+1)
  var tag := FriendlyLook.label(label,12,skin.plaque_muted); tag.custom_minimum_size.x=85; row.add_child(tag)
  var hidden: bool = not ice.seen[s]
  var words := []
  if hidden: words.append("? HIDDEN")
  else:
   for e in d.subs[s]: words.append(effect_text(ice,e))
  var loud := false
  if not hidden:
   for source in d.subs[s]:
    var effect := game.effect_value(ice,source)
    if effect.k=="PULP" and effect.get("curve", "")!="B" and int(effect.get("v",0))==biggest_hit() and biggest_hit()>0: loud=true
  if new_subs(i).has(s) and not ice.broken[s]: tag.text += " · NEW"
  var state := "broken" if ice.broken[s] else ("hidden" if hidden else ("deadlock" if Game._has_deadlock(d.subs[s]) else "normal"))
  if not hidden and not ice.broken[s] and (loud or new_subs(i).has(s)): state="new"
  var chip := rule_chip(" + ".join(words),state,true)
  chip.tooltip_text = "\n".join(words); row.add_child(chip)
  if ui._is_flash(ice,s):
   var firing:=chip.get_theme_stylebox("panel").duplicate() as StyleBoxFlat; firing.border_color=skin.plaque_accent; firing.set_border_width_all(2); chip.add_theme_stylebox_override("panel",firing); ui._pulse(chip)
  if not hidden and not ice.broken[s]:
   var info := break_info(i,s)
   var action := FriendlyLook.button("BREAK" if game.phase=="CHOICE" else ("%d BW" % info.get("cost",0) if info.ok else "—"),func(): break_action(i,s),Color("#DDEAE5") if skin.corporation=="HALCYON" else skin.plaque_ground,skin.plaque_ink)
   action.add_theme_color_override("font_disabled_color",skin.plaque_muted); action.disabled = not info.ok; action.tooltip_text = info.get("reason", "") + (" · MARGIN %d" % info.margin if info.has("margin") else ""); row.add_child(action)
  if Game.deadlock_steps(d.subs[s])>1: row.add_child(FriendlyLook.label("%d/%d" % [ice.break_progress[s],Game.deadlock_steps(d.subs[s])],12,skin.plaque_ink))
  var wrapped_row := drop_wrapper(row,i,s)
  if d.type=="TUMBLER" and slot>=0 and ui.spin.has(i) and not reduced_motion:
   var wrapped: Control = ui._reel(wrapped_row,null,slot,true); list.add_child(wrapped)
  elif d.type=="TUMBLER" and slot>=0 and ui.tumble.has(i) and not reduced_motion: list.add_child(ui._tumble_reel(i,slot,s,wrapped_row))
  else: list.add_child(wrapped_row)
 if game.hidden_count(i)>0 and d.type=="TUMBLER":
  var pool := HBoxContainer.new(); pool.add_child(FriendlyLook.label("POOL",10,skin.plaque_muted)); pool.add_child(rule_chip("? HIDDEN ×%d" % game.hidden_count(i),"hidden",true)); list.add_child(pool)
 var passive := FriendlyLook.label(d.get("ability_text",""),12,skin.plaque_muted); passive.custom_minimum_size.x=scan_width-24; passive.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; list.add_child(passive)
 if not ice.virus.is_empty():
  var counts := []
  for strain in ice.virus:
   if ice.virus[strain]>0: counts.append("%s %d" % [strain,ice.virus[strain]])
  var strains := FriendlyLook.label(" · ".join(counts),12,skin.plaque_accent); strains.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; list.add_child(strains)
  if game.worm_ok(i): list.add_child(FriendlyLook.button("SPEND 2 WORM · BREAK 1",func(): game.use_worm(i); ui.refresh()))
 if game.pending.get("kind")=="patient_zero": list.add_child(FriendlyLook.button("INFECT THIS ICE",func(): game.choose_ice(i); ui.refresh()))
 var tape := ColorRect.new(); tape.color=skin.plaque_accent; tape.size=Vector2(76,3); tape.position=Vector2(scan_width/2-38,3); tape.rotation_degrees=0; tape.mouse_filter=Control.MOUSE_FILTER_IGNORE; var decoration := Control.new(); decoration.mouse_filter=Control.MOUSE_FILTER_IGNORE; panel.add_child(decoration); decoration.add_child(tape)
 panel.draw.connect(func(): panel.draw_line(Vector2(14,3),Vector2(panel.size.x-14,3),Color.WHITE,2,true))
 return panel

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
  while px > 8 and font.get_string_size(line.text, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x > 194:
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
