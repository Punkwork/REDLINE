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
var note: Panel
var note_text: Label
var log_text: Label
var ice_scroll: ScrollContainer
var ice_row: HBoxContainer
var response: HBoxContainer
var hand: FriendlyHand
var rig_row: HBoxContainer
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
func _ready() -> void:
 theme = FriendlyLook.THEME
 mouse_filter = Control.MOUSE_FILTER_PASS
 skin = ui.friendly_skin
 app_ground = ColorRect.new(); app_ground.color = skin.ground; app_ground.position = Vector2.ZERO; app_ground.size = Vector2(1600, 1000); app_ground.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(app_ground)
 background = TextureRect.new(); background.expand_mode=TextureRect.EXPAND_IGNORE_SIZE; background.texture = skin.background; background.position = Vector2.ZERO; background.size = Vector2(1600, 1000); background.stretch_mode = TextureRect.STRETCH_SCALE; background.modulate.a = 1.0; background.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(background)
 surveillance_layer=TextureRect.new(); surveillance_layer.expand_mode=TextureRect.EXPAND_IGNORE_SIZE; surveillance_layer.texture=skin.hostile_background; surveillance_layer.size=Vector2(1600,1000); surveillance_layer.stretch_mode=TextureRect.STRETCH_SCALE; surveillance_layer.modulate.a=0.20; surveillance_layer.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(surveillance_layer); surveillance_layer.hide()
 glitch_layer = Control.new(); glitch_layer.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(glitch_layer)
 for y in [192,362,557,853]:
  var band := ColorRect.new(); band.color=Color("#E5484D29"); band.position=Vector2(0,y); band.size=Vector2(1600,3); band.mouse_filter=Control.MOUSE_FILTER_IGNORE; glitch_layer.add_child(band)
 node_tag = FriendlyLook.panel(FriendlyLook.TONER); node_tag.position = Vector2(40, 32); node_tag.size = Vector2(720, 86); node_tag.rotation_degrees = -1.0; add_child(node_tag)
 trace_tag = FriendlyLook.panel(FriendlyLook.TONER); trace_tag.position = Vector2(972, 32); trace_tag.size = Vector2(588, 106); trace_tag.rotation_degrees = 0.7; add_child(trace_tag)
 ice_scroll = ScrollContainer.new(); ice_scroll.position = Vector2(150, 136); ice_scroll.size = Vector2(1300, 446); ice_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO; ice_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO; add_child(ice_scroll)
 ice_row = HBoxContainer.new(); ice_row.add_theme_constant_override("separation", 42); ice_row.alignment = BoxContainer.ALIGNMENT_CENTER; ice_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL; var ice_margin:=MarginContainer.new(); ice_margin.add_theme_constant_override("margin_top",10); ice_margin.size_flags_horizontal=Control.SIZE_EXPAND_FILL; ice_scroll.add_child(ice_margin); ice_margin.add_child(ice_row)
 var strip := FriendlyLook.panel(FriendlyLook.PAPER, FriendlyLook.TONER, 3); strip.position = Vector2(248, 590); strip.size = Vector2(1104, 49); add_child(strip)
 var rs := ScrollContainer.new(); rs.position = Vector2(10, 7); rs.size = Vector2(1084, 36); rs.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; strip.add_child(rs)
 response = HBoxContainer.new(); response.add_theme_constant_override("separation", 7); rs.add_child(response)
 note = FriendlyLook.panel(FriendlyLook.TONER); note.position = Vector2(248, 650); note.size = Vector2(1104, 44); note.rotation_degrees = -0.4; add_child(note)
 note_text = FriendlyLook.label("", 12, FriendlyLook.HIGHLIGHT); note_text.position = Vector2(10, 4); note_text.size = Vector2(900, 36); note_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; note.add_child(note_text)
 var voice := FriendlyLook.button("VOICE / M", func(): ui._toggle_voice(), FriendlyLook.TONER, FriendlyLook.PAPER); voice.position = Vector2(995, 7); voice.size = Vector2(100, 30); note.add_child(voice)
 var rig_ground := FriendlyLook.panel(FriendlyLook.TONER); rig_ground.position=Vector2(248,696); rig_ground.size=Vector2(1104,28); add_child(rig_ground)
 var rig_scroll := ScrollContainer.new(); rig_scroll.position = Vector2(248, 696); rig_scroll.size = Vector2(1104, 28); rig_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; add_child(rig_scroll)
 rig_row = HBoxContainer.new(); rig_row.add_theme_constant_override("separation", 8); rig_scroll.add_child(rig_row)
 hand = FriendlyHand.new(); hand.position = Vector2(248, 728); hand.size = Vector2(1104, 272); hand.focus_mode = Control.FOCUS_ALL; hand.mouse_filter = Control.MOUSE_FILTER_PASS; add_child(hand)
 bottom_hud = FriendlyLook.panel(FriendlyLook.TONER); bottom_hud.position = Vector2(40, 770); bottom_hud.size = Vector2(200, 212); add_child(bottom_hud)
 var piles_paper:=FriendlyLook.panel(FriendlyLook.PAPER); piles_paper.position=Vector2(1358,766); piles_paper.size=Vector2(204,70); piles_paper.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(piles_paper)
 pile_text = FriendlyLook.label("", 12, FriendlyLook.TONER); pile_text.position = Vector2(1364, 770); pile_text.size = Vector2(198, 64); pile_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; add_child(pile_text)
 end_button = FriendlyLook.button("END TURN →", func(): ui._on_end_turn()); end_button.position = Vector2(1360, 842); end_button.size = Vector2(200, 65); end_button.add_theme_font_size_override("font_size", 20); add_child(end_button)
 var deck := FriendlyLook.button("DECK / COVERAGE", func(): ui.deck_open = true; ui.refresh(), FriendlyLook.PAPER); deck.position = Vector2(1360, 916); deck.size = Vector2(200, 28); add_child(deck)
 end_run_button = FriendlyLook.button("END RUN", func(): ui._confirm_end_run(), FriendlyLook.TONER, FriendlyLook.RED); end_run_button.position = Vector2(1360, 951); end_run_button.size = Vector2(200, 29); add_child(end_run_button)
 toast = FriendlyLook.panel(Color.WHITE,FriendlyLook.RED,1,18,3); toast.position=Vector2(530,110); toast.size=Vector2(540,34); toast.z_index=5; add_child(toast)
 var toast_text := FriendlyLook.label("Is everything okay? We're just checking on you.",15,skin.ink,skin.font); toast_text.position=Vector2(15,6); toast.add_child(toast_text); toast.hide()
 strike_overlay = Control.new(); strike_overlay.name="StrikeOneModal"; strike_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); strike_overlay.mouse_filter=Control.MOUSE_FILTER_STOP; strike_overlay.z_index=200; add_child(strike_overlay); strike_overlay.hide()
 motion_button=FriendlyLook.button("REDUCED MOTION: OFF",func(): ui.set_reduced_motion(not ui.reduced_motion),FriendlyLook.PAPER)
 motion_button.position=Vector2(1360,718); motion_button.size=Vector2(200,28); motion_button.add_theme_font_size_override("font_size",10); add_child(motion_button)
 watcher_warning=FriendlyLook.panel(FriendlyLook.RED); watcher_warning.position=Vector2(1030,540); watcher_warning.size=Vector2(510,36); watcher_warning.z_index=150; watcher_warning.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(watcher_warning)
 watcher_text=FriendlyLook.label("",12,FriendlyLook.TONER,FriendlyLook.BOLD); watcher_text.position=Vector2(8,7); watcher_warning.add_child(watcher_text); watcher_warning.hide()
 strike_overlay.gui_input.connect(func(e):
  if e is InputEventMouseButton and e.pressed: dismiss_strike())
 feedback_panel=FriendlyLook.panel(FriendlyLook.TONER,FriendlyLook.HIGHLIGHT,2); feedback_panel.position=Vector2(606,32); feedback_panel.size=Vector2(350,82); feedback_panel.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(feedback_panel); feedback_panel.hide()
 feedback_label=FriendlyLook.label("",12,FriendlyLook.HIGHLIGHT,FriendlyLook.BOLD); feedback_label.position=Vector2(10,7); feedback_label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; feedback_label.size=Vector2(330,70); feedback_panel.add_child(feedback_label)
 var log_paper:=FriendlyLook.panel(FriendlyLook.PAPER); log_paper.position=Vector2(248,577); log_paper.size=Vector2(1104,13); log_paper.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(log_paper)
 log_text = FriendlyLook.label("", 10, FriendlyLook.TONER); log_text.position = Vector2(248, 577); log_text.size = Vector2(1104, 13); log_text.tooltip_text = "Chronological game log"; add_child(log_text)
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
 if not is_same(last_encounter,game.enc) or last_turn!=game.enc.turn: bw_capacity=maxi(Game.BW_PER_TURN,game.bw)
 else: bw_capacity=maxi(bw_capacity,game.bw)
 last_encounter=game.enc; last_turn=game.enc.turn
 update_corporation()
 clear(node_tag); clear(trace_tag); clear(bottom_hud)
 node_tag.size.x = FriendlyLook.BOLD.get_string_size("NODE: " + game.node.name, HORIZONTAL_ALIGNMENT_LEFT, -1, 29).x + 28
 at(node_tag, FriendlyLook.label("NODE: " + game.node.name, 29, FriendlyLook.PAPER, FriendlyLook.BOLD), Vector2(12, 0), Vector2(700, 46))
 var node_meta := FriendlyLook.panel(FriendlyLook.HIGHLIGHT); at(node_tag, node_meta, Vector2(0, 48), Vector2(540, 30))
 at(node_meta, FriendlyLook.label("HALCYON · %s · LAYER %d/%d · TURN %d" % ["OPENING" if game.is_opening() else game.node.get("tier", "TIER 1"), game.layer + 1, game.node.layers.size(), game.enc.turn], 13, FriendlyLook.TONER, FriendlyLook.BOLD), Vector2(9, 4))
 at(trace_tag, FriendlyLook.label("TRACE", 13, FriendlyLook.PAPER), Vector2(14, 12))
 var bar := ProgressBar.new(); bar.min_value = 0; bar.max_value = Game.MAX_TRACE; bar.value = game.trace; bar.show_percentage = false
 bar.add_theme_stylebox_override("background", FriendlyLook.style(Color("#3A3A3A"))); bar.add_theme_stylebox_override("fill", FriendlyLook.style(FriendlyLook.RED))
 at(trace_tag, bar, Vector2(86, 15), Vector2(240, 18))
 var tick := ColorRect.new(); tick.color = FriendlyLook.PAPER; tick.mouse_filter = Control.MOUSE_FILTER_IGNORE; at(trace_tag, tick, Vector2(205, 10), Vector2(2, 28))
 at(trace_tag, FriendlyLook.label("%d/40" % game.trace, 25, FriendlyLook.RED if game.trace >= 20 else FriendlyLook.PAPER, FriendlyLook.BOLD), Vector2(340, 2))
 at(trace_tag, FriendlyLook.label("STRIKES " + "■".repeat(mini(3, game.strikes)) + "□".repeat(maxi(0, 3 - game.strikes)), 13, FriendlyLook.RED), Vector2(450, 12))
 at(trace_tag, FriendlyLook.label("CRED %d  ·  RESERVE %d/%d  ·  RAM %d/%d" % [game.cred, game.enc.reserve, game.enc.reserve_start, game.ram_used(), game.ram_total()], 12, FriendlyLook.RED if game.enc.reserve==0 else FriendlyLook.PAPER), Vector2(14, 45))
 var reserve := ProgressBar.new(); reserve.max_value=maxi(1,game.enc.reserve_start); reserve.value=game.enc.reserve; reserve.show_percentage=false; reserve.add_theme_stylebox_override("background",FriendlyLook.style(Color("#3A3A3A"))); reserve.add_theme_stylebox_override("fill",FriendlyLook.style(FriendlyLook.HIGHLIGHT)); at(trace_tag,reserve,Vector2(14,65),Vector2(264,3))
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
 var context := ""
 if corporation_state=="mask_off": context="the mask is off. one more strike and we can't leave. "
 elif corporation_state=="cracking": context="%d TRACE to a strike. " % maxi(0,Game.MAX_TRACE-game.trace)
 note_text.text="NUL/REM: " + context + ui.nr_text.text
 if last_note!=note_text.text:
  last_note=note_text.text; note_text.tooltip_text=note_text.text
  var fs:=12
  while fs>8 and FriendlyLook.MONO.get_multiline_string_size(note_text.text,HORIZONTAL_ALIGNMENT_LEFT,900,fs).y>36: fs-=1
  note_text.add_theme_font_size_override("font_size",fs)
 note_text.visible_ratio=ui.nr_text.visible_ratio if context=="" else 1.0
 var now := Time.get_ticks_msec()/1000.0
 toast.visible=now<toast_until
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
 rig_row.add_child(FriendlyLook.label("RIG / RACK · CHAIN " + ("/".join(game.enc.get("last_tags",[])) if not game.enc.get("last_tags",[]).is_empty() else "—"), 11, FriendlyLook.PAPER, FriendlyLook.BOLD))
 for p in game.installed:
  var d := CardDB.def(p.inst.id)
  var text: String = d.name
  if d.has("pick"): text += " · STR %d · BOOST %d / BREAK %d" % [game.pick_str(p), d.pick.boost_cost, d.pick.break_cost]
  var chip: Button
  if d.has("pick"):
   var draggable := FriendlyRigChip.new(); draggable.view=self; draggable.uid=p.inst.uid; draggable.text=text; draggable.pressed.connect(func(): ui._show_inspect(p.inst.id)); draggable.add_theme_color_override("font_color",FriendlyLook.PAPER); chip=draggable
  else: chip=FriendlyLook.button(text,func(): ui._show_inspect(p.inst.id),FriendlyLook.TONER,FriendlyLook.PAPER)
  chip.tooltip_text = game.card_text(p.inst.id); rig_row.add_child(chip)
  if d.has("pick"):
   rig_row.add_child(FriendlyLook.button("+STR", func(): game.boost_pick(p.inst.uid); ui.refresh()))
  if d.get("uninstall_cache", false):
   var cache_action := FriendlyLook.button("UNINSTALL 1 BW", func(): game.uninstall_cache(p.inst.uid); ui.refresh()); cache_action.name="SmashGrabCache"; cache_action.disabled=game.bw<1 or game.hand.is_empty(); rig_row.add_child(cache_action)
  rig_row.add_child(FriendlyLook.button("×", func(): game.unload(p.inst.uid); ui.refresh(), FriendlyLook.PAPER))
 for c in game.rack:
  var d := CardDB.def(c.id)
  rig_row.add_child(FriendlyLook.button(d.name, func(): ui._show_inspect(c.id), FriendlyLook.TONER, FriendlyLook.PAPER))
func build_ice() -> void:
 clear(ice_row)
 for i in game.enc.ice.size():
  var column := VBoxContainer.new(); column.add_theme_constant_override("separation",9); column.custom_minimum_size.x=400 if game.enc.ice.size()==3 else 480; ice_row.add_child(column)
  var mascot := FriendlyMascot.new()
  var prior := previous_mascot(i)
  mascot.previous_mood=prior.get("mood", "")
  mascot.just_broken=not prior.is_empty() and game.enc.ice[i].broken.count(true)>prior.broken.count(true)
  mascot.setup(self,i,mood_for(i))
  # Scale the illustration carrier, not the actor's flinch transform or any rule text.
  var stage:=Control.new(); stage.name="MascotStage"; stage.custom_minimum_size=Vector2(400 if game.enc.ice.size()==3 else 480,190); column.add_child(stage)
  var carrier:=Control.new(); carrier.name="IllustrationScale"; carrier.scale=Vector2(0.70,0.70) if game.enc.ice.size()==3 else Vector2(0.82,0.82); carrier.position=Vector2(32 if game.enc.ice.size()==3 else 42,0); stage.add_child(carrier); carrier.add_child(mascot)
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
    var effect := game.effect_value(game.enc.ice[step.ice], e)
    words.append(effect_text(game.enc.ice[step.ice],e))
  var danger := false
  if not step.hidden:
   for source in step.effects:
    var e := game.effect_value(game.enc.ice[step.ice],source)
    if e.k=="PULP" and e.get("curve", "")!="B" and int(e.get("v",0))==biggest_hit() and biggest_hit()>0: danger=true
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
  if step.ice != i or step.skipped: continue
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
   if e.k=="PULP" and e.get("curve", "")!="B": biggest=maxi(biggest,int(e.get("v",0)))
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
 if e.get("curve", "") == "B": return "PULP ? · RANDOM"
 if e.k == "BW_DRAIN": return "−%d BW next turn" % e.v
 if e.k == "DISCARD": return "DISCARD %d next turn" % e.v + (" ↑" if e.get("escalate",false) else "")
 if e.k == "INSERT": return "INSERT %d %s → %s" % [e.v,e.card,e.to]
 return ui._effect_word(e) + (" ↑" if e.get("escalate",false) else "")
func rule_chip(text: String, state: String = "normal") -> Control:
 var chip := PanelContainer.new(); chip.mouse_filter=Control.MOUSE_FILTER_PASS
 var bg := FriendlyLook.PAPER; var ink := FriendlyLook.TONER
 if state == "deadlock": bg=FriendlyLook.HIGHLIGHT
 if state == "new": bg=FriendlyLook.RED
 if state in ["broken","hidden"]: bg=Color("#DCE7E3") if state=="broken" else Color("#F8FBF9"); ink=FriendlyLook.MUTED_INK
 var style := FriendlyLook.style(bg); style.set_content_margin_all(3); chip.add_theme_stylebox_override("panel",style)
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
 var style := FriendlyLook.style(FriendlyLook.ENAMEL,FriendlyLook.AMBER if eligible else Color("#A2B6BA"),3 if eligible else 2,12,5); style.shadow_color=Color("#243C4533"); style.shadow_offset=Vector2(0,4); style.set_content_margin_all(12); panel.add_theme_stylebox_override("panel",style)
 if eligible: panel.tooltip_text="ZEROED available: "+" / ".join(candidates.map(func(c): return CardDB.def(c.id).name))
 var list := VBoxContainer.new(); list.add_theme_constant_override("separation",4); panel.add_child(list)
 var heading := HBoxContainer.new(); list.add_child(heading)
 var name := FriendlyLook.label(d.name,17,FriendlyLook.SLATE,skin.bold_font); name.size_flags_horizontal=Control.SIZE_EXPAND_FILL; heading.add_child(name)
 var delta: int = game.ice_str(i)-int(d.str)
 heading.add_child(FriendlyLook.label("STR %d%s" % [game.ice_str(i)," ↑%d" % delta if delta>0 else ""],15,FriendlyLook.SERVICE_TEAL,FriendlyLook.BOLD))
 var meta := FriendlyLook.label(" · ".join([d.type,d.get("subtype", ""),d.get("passive",d.get("ability", ""))]).replace(" ·  · "," · "),12,FriendlyLook.MUTED_INK)
 meta.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; meta.custom_minimum_size.x=scan_width-24; list.add_child(meta)
 if ice.get("zeroed",false): list.add_child(FriendlyLook.label("ZEROED · chance consumed",10,FriendlyLook.SERVICE_TEAL))
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
  var tag := FriendlyLook.label(label,12,FriendlyLook.MUTED_INK); tag.custom_minimum_size.x=85; row.add_child(tag)
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
  var chip := rule_chip(" + ".join(words),state)
  chip.tooltip_text = "\n".join(words); row.add_child(chip)
  if ui._is_flash(ice,s):
   var firing:=chip.get_theme_stylebox("panel").duplicate() as StyleBoxFlat; firing.border_color=FriendlyLook.SERVICE_TEAL; firing.set_border_width_all(2); chip.add_theme_stylebox_override("panel",firing); ui._pulse(chip)
  if not hidden and not ice.broken[s]:
   var info := break_info(i,s)
   var action := FriendlyLook.button("BREAK" if game.phase=="CHOICE" else ("%d BW" % info.get("cost",0) if info.ok else "—"),func(): break_action(i,s),Color("#DDEAE5"),FriendlyLook.SLATE)
   action.add_theme_color_override("font_disabled_color",FriendlyLook.MUTED_INK); action.disabled = not info.ok; action.tooltip_text = info.get("reason", "") + (" · MARGIN %d" % info.margin if info.has("margin") else ""); row.add_child(action)
  if Game.deadlock_steps(d.subs[s])>1: row.add_child(FriendlyLook.label("%d/%d" % [ice.break_progress[s],Game.deadlock_steps(d.subs[s])],12,FriendlyLook.SLATE))
  var wrapped_row := drop_wrapper(row,i,s)
  if d.type=="TUMBLER" and slot>=0 and ui.spin.has(i) and not reduced_motion:
   var wrapped: Control = ui._reel(wrapped_row,null,slot,true); list.add_child(wrapped)
  elif d.type=="TUMBLER" and slot>=0 and ui.tumble.has(i) and not reduced_motion: list.add_child(ui._tumble_reel(i,slot,s,wrapped_row))
  else: list.add_child(wrapped_row)
 if game.hidden_count(i)>0 and d.type=="TUMBLER":
  var pool := HBoxContainer.new(); pool.add_child(FriendlyLook.label("POOL",10,FriendlyLook.MUTED_INK)); pool.add_child(rule_chip("? HIDDEN ×%d" % game.hidden_count(i),"hidden")); list.add_child(pool)
 var passive := FriendlyLook.label(d.get("ability_text",""),12,FriendlyLook.MUTED_INK); passive.custom_minimum_size.x=scan_width-24; passive.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; list.add_child(passive)
 if not ice.virus.is_empty():
  var counts := []
  for strain in ice.virus:
   if ice.virus[strain]>0: counts.append("%s %d" % [strain,ice.virus[strain]])
  var strains := FriendlyLook.label(" · ".join(counts),12,FriendlyLook.SERVICE_TEAL); strains.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; list.add_child(strains)
  if game.worm_ok(i): list.add_child(FriendlyLook.button("SPEND 2 WORM · BREAK 1",func(): game.use_worm(i); ui.refresh()))
 if game.pending.get("kind")=="patient_zero": list.add_child(FriendlyLook.button("INFECT THIS ICE",func(): game.choose_ice(i); ui.refresh()))
 var tape := ColorRect.new(); tape.color=FriendlyLook.SERVICE_TEAL; tape.size=Vector2(76,3); tape.position=Vector2(scan_width/2-38,3); tape.rotation_degrees=0; tape.mouse_filter=Control.MOUSE_FILTER_IGNORE; var decoration := Control.new(); decoration.mouse_filter=Control.MOUSE_FILTER_IGNORE; panel.add_child(decoration); decoration.add_child(tape)
 panel.draw.connect(func(): panel.draw_line(Vector2(14,3),Vector2(panel.size.x-14,3),Color.WHITE,2,true))
 return panel

func reset_session() -> void:
 feedback_until=0; feedback_message=""; end_drag(); mascot_history.clear(); card_positions.clear(); last_encounter={}; last_turn=-1; previous_trace=0; previous_strikes=0; warned=false; strike_until=0; toast_until=0; new_subroutines.clear(); hand_signature=""
 if is_instance_valid(strike_overlay): strike_overlay.hide()
func update_corporation() -> void:
 var now := Time.get_ticks_msec()/1000.0
 state_before_refresh=corporation_state
 corporation_state="mask_off" if game.strikes>=2 else ("cracking" if game.trace>=20 or game.strikes==1 else "friendly")
 if not warned and previous_trace<20 and game.trace>=20:
  warned=true; toast_until=now+3.0
  if not reduced_motion:
   toast.position.y=96; toast.create_tween().tween_property(toast,"position:y",110.0,0.18)
 if game.strikes==1 and previous_strikes==0:
  strike_until=now+2.5; build_strike(); strike_overlay.show()
  if not reduced_motion: strike_flash()
 if game.strikes>=2: strike_overlay.hide()
 previous_trace=game.trace; previous_strikes=game.strikes
 apply_background()
func apply_background() -> void:
 surveillance_layer.visible=corporation_state=="cracking" and not strike_overlay.visible
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
  fade_layer=TextureRect.new(); fade_layer.expand_mode=TextureRect.EXPAND_IGNORE_SIZE; fade_layer.texture=target; fade_layer.size=Vector2(1600,1000); fade_layer.modulate.a=0.0; fade_layer.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(fade_layer); move_child(fade_layer,background.get_index()+1)
  background_fade=create_tween(); background_fade.tween_property(fade_layer,"modulate:a",1.0,0.3)
  background_fade.tween_callback(func(): background.texture=target; fade_layer.queue_free())
 glitch_layer.visible=false
func dismiss_strike() -> void:
 var was_visible := strike_overlay.visible
 strike_overlay.hide(); strike_until=0; apply_background()
 if was_visible and not reduced_motion:
  var tracer := FriendlyCard.new(); tracer.setup(self,"TRACER",-1); tracer.position=Vector2(1090,265); tracer.z_index=150; add_child(tracer)
  var flight := tracer.create_tween().set_parallel(true); flight.tween_property(tracer,"position",Vector2(1445,780),0.35); flight.tween_property(tracer,"scale",Vector2(0.15,0.15),0.35); flight.chain().tween_callback(tracer.queue_free)
func strike_flash() -> void:
 var flash := ColorRect.new(); flash.color=Color("#E5484D55"); flash.size=Vector2(1600,1000); flash.mouse_filter=Control.MOUSE_FILTER_IGNORE; add_child(flash); move_child(flash,glitch_layer.get_index()+1)
 var light := flash.create_tween(); light.tween_property(flash,"modulate:a",0.0,0.3); light.tween_callback(flash.queue_free)
func build_strike() -> void:
 clear(strike_overlay)
 var dim := ColorRect.new(); dim.color=Color(0.05,0,0,0.5); dim.size=Vector2(1600,1000); dim.mouse_filter=Control.MOUSE_FILTER_IGNORE; strike_overlay.add_child(dim)
 var modal := FriendlyLook.panel(Color("#140809"),FriendlyLook.RED,2,skin.radius); modal.position=Vector2(295,200); modal.size=Vector2(1010,400); strike_overlay.add_child(modal)
 modal.mouse_filter=Control.MOUSE_FILTER_PASS
 var chrome_modal:=ChromeFrame.new(); chrome_modal.name="StrikeChrome"; chrome_modal.hostile=true; chrome_modal.radius=skin.radius; chrome_modal.size=modal.size; modal.add_child(chrome_modal)
 at(modal,FriendlyLook.label("TRACE STRIKE 1 OF 3",16,FriendlyLook.RED,FriendlyLook.BOLD),Vector2(32,30))
 at(modal,FriendlyLook.label("We see you.",68,Color("#F6E7E7"),skin.bold_font),Vector2(32,64))
 var line := FriendlyLook.label("HALCYON has located you. We've added something to help us keep in touch.",20,Color("#E4B5B7"),skin.font); line.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; at(modal,line,Vector2(32,166),Vector2(660,70))
 at(modal,FriendlyLook.label("+1 TRACER shuffled into your draw pile",15,FriendlyLook.HIGHLIGHT),Vector2(32,260))
 at(modal,FriendlyLook.label("TRACE drops to 20",15,FriendlyLook.HIGHLIGHT),Vector2(32,290))
 at(modal,FriendlyLook.label("next strike: BLACK ICE joins this encounter",13,FriendlyLook.PAPER),Vector2(32,322))
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
 if d.has("target_types") and not d.target_types.has(game.ice_definition(game.enc.ice[i]).type): return false
 if d.has("target_type") and d.target_type!=game.ice_definition(game.enc.ice[i]).type: return false
 if d.has("breaker") and d.breaker.get("same_ice",false): return not game._breaker_targets(d.breaker,i).is_empty()
 return true
func drop_wrapper(row: Control, i: int, sub: int) -> Control:
 var wrap := MarginContainer.new(); wrap.add_child(row)
 var drop := FriendlyDropTarget.new(); drop.view=self; drop.ice_ref=game.enc.ice[i]; drop.sub=sub; drop.mouse_filter=Control.MOUSE_FILTER_PASS; drop.tooltip_text=break_info(i,sub).get("reason", ""); wrap.add_child(drop)
 return wrap
func _can_drop_data(at: Vector2, data) -> bool:
 if not data is Dictionary or data.get("kind")!="card" or at.y>=696: return false
 var inst := game.find_card(int(data.uid))
 return not inst.is_empty() and not CardDB.def(inst.id).get("target",false) and game.can_play(inst.uid).ok
func _drop_data(at: Vector2, data) -> void:
 if not _can_drop_data(at,data): return
 game.play_card(int(data.uid)); end_drag(); ui.refresh()

func show_break_feedback(ice: Dictionary, subroutine: int, cost: int) -> void:
 feedback_message=("BROKEN" if ice.broken[subroutine] else "BREAK STEP")+" · "+game.ice_definition(ice).name+" · S%d\n%d BW spent · rules updated"%[subroutine+1,cost]
 feedback_until=Time.get_ticks_msec()/1000.0+2.5
