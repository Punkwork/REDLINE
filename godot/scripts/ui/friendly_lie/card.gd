class_name FriendlyCard
extends Control
## Paper UI only. Playing a card always goes through the existing Game API.
var view
var card_id := ""
var uid := -1
var placeholder := false
var body: Control
var rest_position := Vector2.ZERO
var rest_rotation := 0.0
var drag_started := false
class CostCircle extends Control:
 func _draw() -> void: draw_circle(Vector2(13, 13), 13, FriendlyLook.HIGHLIGHT)
func setup(owner_view, id: String, card_uid: int) -> void:
 view = owner_view; card_id = id; uid = card_uid
 custom_minimum_size = Vector2(146, 218); size = custom_minimum_size
 mouse_filter = Control.MOUSE_FILTER_STOP
 mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
 var d := CardDB.def(id)
 var corp: bool = d.type == "BLOATWARE"
 body = Control.new(); body.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); body.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(body)
 var bg := FriendlyLook.panel(Color.WHITE if corp else FriendlyLook.PAPER, FriendlyLook.RED if corp else FriendlyLook.TONER, 3, view.skin.radius / 2 if corp else 0)
 bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); bg.mouse_filter = Control.MOUSE_FILTER_IGNORE; body.add_child(bg)
 var head := FriendlyLook.panel(FriendlyLook.RED if corp else FriendlyLook.TONER)
 head.position = Vector2(3, 3); head.size = Vector2(140, 40); head.mouse_filter = Control.MOUSE_FILTER_IGNORE; body.add_child(head)
 var title := FriendlyLook.label(d.name.to_upper(), 11 if d.name.length() > 25 else 13, FriendlyLook.PAPER, view.skin.bold_font if corp else FriendlyLook.BOLD)
 title.position = Vector2(8, 4); title.size = Vector2(105, 38); title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; body.add_child(title)
 var circle := CostCircle.new(); circle.position = Vector2(114, 9); circle.size = Vector2(26, 26); circle.mouse_filter = Control.MOUSE_FILTER_IGNORE; body.add_child(circle)
 var cost := FriendlyLook.label(str(view.game.card_cost(id)) if uid >= 0 else str(d.bw), 15, FriendlyLook.TONER, FriendlyLook.BOLD)
 cost.position = Vector2(115, 8); cost.size = Vector2(25, 25); cost.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; body.add_child(cost)
 var rule: String = view.game.card_text(id)
 var art_h := 42.0 if rule.length() < 145 else (22.0 if rule.length() < 280 else 4.0)
 var art := FriendlyLook.label("◉" if corp else "[  %s  ]" % ("ICEPICK" if d.has("pick") else ("NUL/REM" if d.type == "PROTOCOL" else "↯")), 11, view.skin.deep if corp else FriendlyLook.TONER)
 art.position = Vector2(9, 49); art.size = Vector2(128, art_h); art.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; art.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; body.add_child(art)
 var type_line := FriendlyLook.label(d.type + (" · " + "/".join(d.tags) if not d.tags.is_empty() else ""), 8, Color("#4A5568") if corp else Color("#3A3A3A"), view.skin.font if corp else FriendlyLook.MONO)
 type_line.position = Vector2(9, 54 + art_h); type_line.size = Vector2(128, 24); type_line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; body.add_child(type_line)
 var rules := RichTextLabel.new(); rules.mouse_filter = Control.MOUSE_FILTER_IGNORE; rules.bbcode_enabled = true; rules.scroll_active = false
 var font: Font = view.skin.font if corp else FriendlyLook.MONO
 var cached: Dictionary = view.game._find(view.game.hand, uid)
 var cache_h := 15 if cached.get("cached", false) else 0
 var y := 80 + art_h
 var available := 210 - y - cache_h
 var font_size := 11
 while font_size > 7 and font.get_multiline_string_size(rule, HORIZONTAL_ALIGNMENT_LEFT, 128, font_size).y > available: font_size -= 1
 rules.add_theme_font_override("normal_font", font); rules.add_theme_font_size_override("normal_font_size", font_size); rules.add_theme_color_override("default_color", FriendlyLook.TONER)
 var re := RegEx.new(); re.compile("([+−\\-]?[0-9]+(?: STR| BW| SHIELD| CRED| TRACE| RAM)?)")
 rules.text = re.sub(rule, "[bgcolor=#E4FF3A][color=#111111]$1[/color][/bgcolor]", true)
 rules.position = Vector2(9, y); rules.size = Vector2(128, available); body.add_child(rules)
 if cache_h > 0:
  var cached_tag := FriendlyLook.label("CACHED" + (" · TEMP" if cached.has("cache_turns") else ""), 9, FriendlyLook.TONER, FriendlyLook.BOLD)
  cached_tag.position = Vector2(9, 199); body.add_child(cached_tag)
 tooltip_text = d.name + "\n" + rule
 if uid >= 0:
  var chk: Dictionary = view.game.can_play(uid)
  if not chk.ok: tooltip_text += "\n" + chk.reason
  mouse_entered.connect(func(): view.hover_uid = uid; view.hand.focus_card(self))
  mouse_exited.connect(func(): view.hover_uid = -1; view.hand.release_card(self))
 gui_input.connect(_card_input)
 queue_redraw()
func _draw() -> void:
 draw_rect(Rect2(Vector2(5, 5), size), FriendlyLook.TONER)
 if placeholder:
  draw_rect(Rect2(Vector2.ZERO, size), Color("#F7F7F2"))
  var rect := Rect2(Vector2(2, 2), size - Vector2(4, 4))
  for edge in [[rect.position, Vector2(rect.end.x, rect.position.y)], [Vector2(rect.end.x, rect.position.y), rect.end], [rect.end, Vector2(rect.position.x, rect.end.y)], [Vector2(rect.position.x, rect.end.y), rect.position]]:
   draw_dashed_line(edge[0], edge[1], Color("#737373"), 2, 7)
 else:
  draw_circle(Vector2(127, 22), 13, FriendlyLook.HIGHLIGHT)
  if is_instance_valid(body): body.move_to_front()
func _card_input(event: InputEvent) -> void:
 if event is InputEventMouseButton and event.pressed and event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN]:
  view.hand.browse(1 if event.button_index == MOUSE_BUTTON_WHEEL_DOWN else -1); accept_event(); return
 if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
  if event.pressed: drag_started = false
  elif uid >= 0 and not drag_started and view.dragging_uid < 0: view.ui._on_card(uid)
 if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed: view.ui._show_inspect(card_id)
func _get_drag_data(_at: Vector2):
 if uid < 0 or view.game.phase != "PLAYER" or not view.game.can_play(uid).ok: return null
 drag_started = true; placeholder = true; body.hide(); queue_redraw()
 view.begin_drag({"kind": "card", "uid": uid}, self)
 var preview := FriendlyCard.new(); preview.setup(view, card_id, -1); preview.rotation_degrees = -3; preview.position = Vector2(-73, -109); set_drag_preview(preview)
 return {"kind": "card", "uid": uid}
func _notification(what: int) -> void:
 if what == NOTIFICATION_DRAG_END and drag_started:
  placeholder = false
  if is_instance_valid(body): body.show()
  queue_redraw()
  if is_instance_valid(view): view.end_drag()
