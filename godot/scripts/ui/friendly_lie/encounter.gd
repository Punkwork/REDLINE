class_name FriendlyEncounter
extends Control
## Read-only presentation of Game, delegating all actions to the existing controller.
var ui
var game: Game
var skin: CorporationSkin
var background: TextureRect
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
func _ready() -> void:
 theme = FriendlyLook.THEME
 mouse_filter = Control.MOUSE_FILTER_IGNORE
 skin = ui.friendly_skin
 var ground := ColorRect.new(); ground.color = skin.ground; ground.position = Vector2.ZERO; ground.size = Vector2(1600, 1000); ground.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(ground)
 background = TextureRect.new(); background.texture = skin.background; background.position = Vector2.ZERO; background.size = Vector2(1600, 1000); background.stretch_mode = TextureRect.STRETCH_SCALE; background.modulate.a = 0.75; background.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(background)
 node_tag = FriendlyLook.panel(FriendlyLook.TONER); node_tag.position = Vector2(40, 32); node_tag.size = Vector2(720, 86); node_tag.rotation_degrees = -1.0; add_child(node_tag)
 trace_tag = FriendlyLook.panel(FriendlyLook.TONER); trace_tag.position = Vector2(972, 32); trace_tag.size = Vector2(588, 106); trace_tag.rotation_degrees = 0.7; add_child(trace_tag)
 ice_scroll = ScrollContainer.new(); ice_scroll.position = Vector2(150, 156); ice_scroll.size = Vector2(1300, 456); ice_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO; ice_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO; add_child(ice_scroll)
 ice_row = HBoxContainer.new(); ice_row.add_theme_constant_override("separation", 42); ice_row.alignment = BoxContainer.ALIGNMENT_CENTER; ice_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL; ice_scroll.add_child(ice_row)
 var strip := FriendlyLook.panel(FriendlyLook.PAPER, FriendlyLook.TONER, 3); strip.position = Vector2(248, 620); strip.size = Vector2(1104, 49); add_child(strip)
 var rs := ScrollContainer.new(); rs.position = Vector2(10, 7); rs.size = Vector2(1084, 36); rs.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; strip.add_child(rs)
 response = HBoxContainer.new(); response.add_theme_constant_override("separation", 7); rs.add_child(response)
 note = FriendlyLook.panel(FriendlyLook.TONER); note.position = Vector2(248, 680); note.size = Vector2(1104, 44); note.rotation_degrees = -0.4; add_child(note)
 note_text = FriendlyLook.label("", 12, FriendlyLook.HIGHLIGHT); note_text.position = Vector2(10, 4); note_text.size = Vector2(900, 36); note_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; note.add_child(note_text)
 var voice := FriendlyLook.button("VOICE / M", func(): ui._toggle_voice(), FriendlyLook.TONER, FriendlyLook.PAPER); voice.position = Vector2(995, 7); voice.size = Vector2(100, 30); note.add_child(voice)
 var rig_scroll := ScrollContainer.new(); rig_scroll.position = Vector2(248, 726); rig_scroll.size = Vector2(1104, 28); rig_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED; add_child(rig_scroll)
 rig_row = HBoxContainer.new(); rig_row.add_theme_constant_override("separation", 8); rig_scroll.add_child(rig_row)
 hand = FriendlyHand.new(); hand.position = Vector2(248, 758); hand.size = Vector2(1104, 232); hand.focus_mode = Control.FOCUS_ALL; hand.mouse_filter = Control.MOUSE_FILTER_PASS; add_child(hand)
 bottom_hud = FriendlyLook.panel(FriendlyLook.TONER); bottom_hud.position = Vector2(40, 770); bottom_hud.size = Vector2(200, 212); add_child(bottom_hud)
 pile_text = FriendlyLook.label("", 11, FriendlyLook.TONER); pile_text.position = Vector2(1364, 770); pile_text.size = Vector2(198, 64); pile_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; add_child(pile_text)
 end_button = FriendlyLook.button("END TURN →", func(): ui._on_end_turn()); end_button.position = Vector2(1360, 842); end_button.size = Vector2(200, 65); end_button.add_theme_font_size_override("font_size", 20); add_child(end_button)
 var deck := FriendlyLook.button("DECK / COVERAGE", func(): ui.deck_open = true; ui.refresh(), FriendlyLook.PAPER); deck.position = Vector2(1360, 916); deck.size = Vector2(200, 28); add_child(deck)
 end_run_button = FriendlyLook.button("END RUN", func(): ui._confirm_end_run(), FriendlyLook.TONER, FriendlyLook.RED); end_run_button.position = Vector2(1360, 951); end_run_button.size = Vector2(200, 29); add_child(end_run_button)
 log_text = FriendlyLook.label("", 10, FriendlyLook.TONER); log_text.position = Vector2(248, 607); log_text.size = Vector2(1104, 13); log_text.tooltip_text = "Chronological game log"; add_child(log_text)
func clear(node: Node) -> void:
 for child in node.get_children(): node.remove_child(child); child.queue_free()
func at(parent: Node, control: Control, pos: Vector2, extent: Vector2 = Vector2.ZERO) -> Control:
 control.position = pos
 if extent != Vector2.ZERO: control.size = extent
 parent.add_child(control); return control
func sync(model: Game) -> void:
 game = model
 if game.enc.is_empty(): return
 clear(node_tag); clear(trace_tag); clear(bottom_hud)
 at(node_tag, FriendlyLook.label("NODE: " + game.node.name, 29, FriendlyLook.PAPER, FriendlyLook.BOLD), Vector2(12, 0), Vector2(700, 46))
 var node_meta := FriendlyLook.panel(FriendlyLook.HIGHLIGHT); at(node_tag, node_meta, Vector2(0, 48), Vector2(720, 30))
 at(node_meta, FriendlyLook.label("HALCYON · %s · LAYER %d/%d · TURN %d" % ["OPENING" if game.is_opening() else game.node.get("tier", "TIER 1"), game.layer + 1, game.node.layers.size(), game.enc.turn], 13, FriendlyLook.TONER, FriendlyLook.BOLD), Vector2(9, 4))
 at(trace_tag, FriendlyLook.label("TRACE", 13, FriendlyLook.PAPER), Vector2(14, 12))
 var bar := ProgressBar.new(); bar.min_value = 0; bar.max_value = Game.MAX_TRACE; bar.value = game.trace; bar.show_percentage = false
 bar.add_theme_stylebox_override("background", FriendlyLook.style(Color("#3A3A3A"))); bar.add_theme_stylebox_override("fill", FriendlyLook.style(FriendlyLook.RED))
 at(trace_tag, bar, Vector2(86, 15), Vector2(240, 18))
 var tick := ColorRect.new(); tick.color = FriendlyLook.PAPER; tick.mouse_filter = Control.MOUSE_FILTER_IGNORE; at(trace_tag, tick, Vector2(205, 10), Vector2(2, 28))
 at(trace_tag, FriendlyLook.label("%d/40" % game.trace, 25, FriendlyLook.RED if game.trace >= 20 else FriendlyLook.PAPER, FriendlyLook.BOLD), Vector2(340, 2))
 at(trace_tag, FriendlyLook.label("STRIKES " + "■".repeat(mini(3, game.strikes)) + "□".repeat(maxi(0, 3 - game.strikes)), 13, FriendlyLook.RED), Vector2(450, 12))
 at(trace_tag, FriendlyLook.label("CRED %d  ·  RESERVE %d/%d  ·  RAM %d/%d" % [game.cred, game.enc.reserve, game.enc.reserve_start, game.ram_used(), game.ram_total()], 12, FriendlyLook.PAPER), Vector2(14, 45))
 at(trace_tag, FriendlyLook.label("FOOTPRINT %d/%d · %s · AMP %d" % [game.footprint(), game.footprint_cap(), game.footprint_band(), game.amp], 11, FriendlyLook.HIGHLIGHT), Vector2(14, 73))
 var stats := [["BW", str(game.bw), FriendlyLook.HIGHLIGHT], ["VITAE", "%d/%d" % [game.vitae, game.max_vitae], FriendlyLook.PAPER], ["SHIELD", str(game.shield), FriendlyLook.PAPER], ["NEXT DRAW", str(game.draw_size()), FriendlyLook.PAPER]]
 for i in stats.size():
  at(bottom_hud, FriendlyLook.label(stats[i][0], 11, FriendlyLook.PAPER), Vector2(12, i * 52 + 15))
  at(bottom_hud, FriendlyLook.label(stats[i][1], 22, stats[i][2], FriendlyLook.BOLD), Vector2(99, i * 52 + 5))
  if i > 0:
   var line := ColorRect.new(); line.color = Color("#3A3A3A"); at(bottom_hud, line, Vector2(0, i * 52), Vector2(200, 2))
 for i in Game.BW_PER_TURN:
  var slit := ColorRect.new(); slit.color = FriendlyLook.HIGHLIGHT if i < maxi(0, Game.BW_PER_TURN - game.bw) else Color("#3A3A3A"); at(bottom_hud, slit, Vector2(12 + i * 16, 39), Vector2(12, 5))
 pile_text.text = "DECK %d · DISCARD %d\nREBOOT ~%d turns\nLast: %s" % [game.draw_pile.size(), game.discard.size(), int(ceil(float(game.draw_pile.size()) / maxi(1, game.draw_size()))), "/".join(game.enc.get("last_tags", []))]
 end_button.disabled = game.phase != "PLAYER" or ui.responding
 end_run_button.disabled = ui.responding
 build_rig(); build_ice(); build_response(); build_hand()
 log_text.text = " · ".join(game.log.slice(maxi(0, game.log.size() - 2)))
 log_text.tooltip_text = "\n".join(game.log)
func _process(_dt: float) -> void:
 if not visible or not is_instance_valid(ui): return
 note_text.text = "NUL/REM: " + ui.nr_text.text
 note_text.visible_ratio = ui.nr_text.visible_ratio
func build_rig() -> void:
 clear(rig_row)
 rig_row.add_child(FriendlyLook.label("RIG / RACK", 11, FriendlyLook.PAPER, FriendlyLook.BOLD))
 for p in game.installed:
  var d := CardDB.def(p.inst.id)
  var text: String = d.name
  if d.has("pick"): text += " · STR %d · BOOST %d / BREAK %d" % [game.pick_str(p), d.pick.boost_cost, d.pick.break_cost]
  var chip := FriendlyLook.button(text, func(): ui._show_inspect(p.inst.id), FriendlyLook.TONER, FriendlyLook.PAPER)
  chip.tooltip_text = game.card_text(p.inst.id); rig_row.add_child(chip)
  if d.has("pick"):
   rig_row.add_child(FriendlyLook.button("+STR", func(): game.boost_pick(p.inst.uid); ui.refresh()))
  if d.get("uninstall_cache", false): rig_row.add_child(FriendlyLook.button("UNINSTALL 1 BW", func(): game.uninstall_cache(p.inst.uid); ui.refresh()))
  rig_row.add_child(FriendlyLook.button("×", func(): game.unload(p.inst.uid); ui.refresh(), FriendlyLook.PAPER))
 for c in game.rack:
  var d := CardDB.def(c.id)
  rig_row.add_child(FriendlyLook.button(d.name, func(): ui._show_inspect(c.id), FriendlyLook.TONER, FriendlyLook.PAPER))
func build_ice() -> void:
 clear(ice_row)
 for i in game.enc.ice.size(): ice_row.add_child(ui._ice_card(i, i == game.enc.ice.size() - 1))
func build_response() -> void:
 clear(response); response.add_child(FriendlyLook.label("NEXT RESPONSE ▸", 13, FriendlyLook.TONER, FriendlyLook.BOLD))
 for step in game.response_preview():
  if step.skipped: continue
  var words := []
  if step.hidden: words.append("? HIDDEN")
  else:
   for e in step.effects:
    var effect := game.effect_value(game.enc.ice[step.ice], e)
    words.append("PULP ?" if effect.get("curve", "") == "B" else ui._effect_word(effect))
  var chip := FriendlyLook.label(" + ".join(words), 12, FriendlyLook.TONER, FriendlyLook.BOLD)
  chip.tooltip_text = step.name; chip.mouse_filter = Control.MOUSE_FILTER_PASS
  var panel := PanelContainer.new(); var sb := FriendlyLook.style(FriendlyLook.PAPER, FriendlyLook.TONER, 1); sb.set_content_margin_all(3); panel.add_theme_stylebox_override("panel", sb); panel.add_child(chip); response.add_child(panel)
func build_hand() -> void:
 var signature := str(game.hand) + str(game.enc.get("last_tags", [])) + str(game.bw) + str(game.amp) + str(game.phase) + str(ui.targeting)
 if signature == hand_signature: return
 hand_signature = signature
 clear(hand)
 for c in game.hand:
  var card := FriendlyCard.new(); card.setup(self, c.id, c.uid); hand.add_child(card)
 hand.arrange()
func begin_drag(data: Dictionary, source: Control) -> void:
 dragging_uid = data.uid; drag_kind = data.kind; drag_source = source; hover_uid = data.uid
func end_drag() -> void:
 dragging_uid = -1; drag_kind = ""; hover_uid = -1; drag_source = null
