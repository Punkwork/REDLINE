class_name FriendlyCard
extends Control
## Paper UI only. Playing a card always goes through the existing Game API.
const CARD_SIZE:=Vector2(164,244)
const PHYSICAL_RECT:=Rect2(-10,-12,184,268)
var view
var corporate:=false
var card_id := ""
var uid := -1
var placeholder := false
var body: Control
var rest_position := Vector2.ZERO
var rest_rotation := 0.0
var drag_started := false
var motion: Tween
class CorporateArt extends Control:
 func _draw() -> void:
  draw_style_box(FriendlyLook.style(Color("#FFE5E5"),Color.TRANSPARENT,0,6),Rect2(Vector2.ZERO,size))
  draw_arc(Vector2(size.x/2,12),4,0,TAU,24,FriendlyLook.RED,2,true)
  draw_arc(Vector2(size.x/2,32),9,PI,TAU,24,FriendlyLook.RED,2,true)
class ArtBox extends Control:
 func _draw() -> void:
  var r:=Rect2(Vector2.ZERO,size)
  for edge in [[r.position,Vector2(r.end.x,0)],[Vector2(r.end.x,0),r.end],[r.end,Vector2(0,r.end.y)],[Vector2(0,r.end.y),r.position]]: draw_dashed_line(edge[0],edge[1],FriendlyLook.GREY,1,5)
class CostCircle extends Control:
 func _draw() -> void:
  draw_circle(Vector2(14,15),15,Color("#253237"))
  draw_circle(Vector2(13,13),14,Color("#D3DEDB"))
  draw_circle(Vector2(13,13),11.5,FriendlyLook.HIGHLIGHT)
  draw_line(Vector2(3,3),Vector2(7,3),Color.WHITE,1,true)
func setup(owner_view, id: String, card_uid: int) -> void:
 view = owner_view; card_id = id; uid = card_uid
 custom_minimum_size = CARD_SIZE; size = custom_minimum_size
 mouse_filter = Control.MOUSE_FILTER_STOP
 mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
 var d := CardDB.def(id)
 var corp: bool = d.type == "BLOATWARE"
 corporate=corp
 var rarity: String=d.get("rarity","COMMON")
 var label_top:=38 if d.type=="PROGRAM" else (30 if d.type=="PROTOCOL" else 24)
 var label_bottom:=218 if d.type=="PROGRAM" else 211
 if corp: label_top=8; label_bottom=234
 body = Control.new(); body.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); body.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(body)
 var bg := FriendlyLook.panel(Color.WHITE if corp else FriendlyLook.PAPER, FriendlyLook.RED if corp else FriendlyLook.TONER, 3, view.skin.radius / 2 if corp else 0)
 bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); bg.mouse_filter = Control.MOUSE_FILTER_IGNORE; body.add_child(bg)
 if not corp:
  bg.hide()
  var shell:=TextureRect.new(); shell.name="SlotCartridge"; shell.expand_mode=TextureRect.EXPAND_IGNORE_SIZE; shell.texture=load("res://assets/friendly_lie/cartridges/"+d.type.to_lower()+".png"); shell.stretch_mode=TextureRect.STRETCH_SCALE; shell.position=PHYSICAL_RECT.position; shell.size=PHYSICAL_RECT.size; shell.mouse_filter=Control.MOUSE_FILTER_IGNORE; body.add_child(shell)
  var finish:=CartridgeFinish.new(); finish.name="RarityFinish"; finish.rarity=rarity; finish.size=CARD_SIZE; body.add_child(finish)
 var title_ink:=Color("#4A3B32") if d.type=="SCRIPT" else (Color("#24564E") if d.type=="PROTOCOL" else FriendlyLook.SLATE)
 var head := FriendlyLook.panel(FriendlyLook.RED if corp else Color.TRANSPARENT)
 head.position = Vector2(15, label_top); head.size = Vector2(130, 40); head.mouse_filter = Control.MOUSE_FILTER_IGNORE; body.add_child(head)
 var title := FriendlyLook.label(d.name.to_upper(), 10 if d.name.length() > 25 else (11 if d.name.length()>15 else 12), FriendlyLook.TONER if corp else title_ink, view.skin.bold_font if corp else FriendlyLook.BOLD)
 title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; title.position = Vector2(19, label_top+1); title.size = Vector2(104, 39)
 var title_size:=int(title.get_theme_font_size("font_size"))
 var title_font: Font=view.skin.bold_font if corp else FriendlyLook.BOLD
 while title_size>7 and title_font.get_multiline_string_size(title.text,HORIZONTAL_ALIGNMENT_LEFT,104,title_size).y>39: title_size-=1
 title.add_theme_font_size_override("font_size",title_size); body.add_child(title)
 if not corp:
  var separator:=ColorRect.new(); separator.color=Color("#9CADA666"); separator.position=Vector2(19,label_top+39); separator.size=Vector2(122,1); separator.mouse_filter=Control.MOUSE_FILTER_IGNORE; body.add_child(separator)
 var circle := CostCircle.new(); circle.position = Vector2(142, 5); circle.size = Vector2(26, 26); circle.mouse_filter = Control.MOUSE_FILTER_IGNORE; body.add_child(circle)
 var cost := FriendlyLook.label(str(view.game.card_cost(id)) if uid >= 0 else str(d.bw), 15, FriendlyLook.TONER, FriendlyLook.BOLD)
 cost.position = Vector2(143, 5); cost.size = Vector2(25, 25); cost.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; body.add_child(cost)
 var rule: String = view.game.card_text(id)
 var art_h := 44.0 if rule.length()<100 else (32.0 if rule.length()<145 else (16.0 if rule.length()<280 else 0.0))
 var art_y:=label_top+44
 var type_h:=14 if rule.length()>280 else 26
 var art := FriendlyLook.label("" if corp else "[  %s  ]" % ("ICEPICK" if d.has("pick") else ("NUL/REM" if d.type == "PROTOCOL" else "↯")), 11, view.skin.deep if corp else FriendlyLook.TONER)
 art.position = Vector2(16, art_y); art.size = Vector2(128, art_h); art.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; art.vertical_alignment = VERTICAL_ALIGNMENT_CENTER; body.add_child(art)
 if not corp and art_h>10:
  art.hide()
  var atlas:=preload("res://assets/friendly_lie/chrome/toner-illustrations.png")
  var index:=0
  if d.has("pick"): index=1
  elif d.get("extract",0)>0: index=2
  elif id=="PULP_SHIELD": index=3+posmod(uid,2)
  elif id=="CORTEX_BUFFER" or d.type=="PROTOCOL": index=5
  var tile:=AtlasTexture.new(); tile.atlas=atlas; tile.filter_clip=true; tile.region=Rect2(Vector2((index%3)*atlas.get_width()/3,(index/3 as int)*atlas.get_height()/2),Vector2(atlas.get_width()/3,atlas.get_height()/2))
  var illustration:=TextureRect.new(); illustration.name="TonerIllustration"; illustration.expand_mode=TextureRect.EXPAND_IGNORE_SIZE; illustration.texture=tile; illustration.position=Vector2(16,art_y); illustration.size=Vector2(128,art_h); illustration.clip_contents=true; illustration.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED; illustration.mouse_filter=Control.MOUSE_FILTER_IGNORE; body.add_child(illustration)
  var box := ArtBox.new(); box.position=Vector2(16,art_y); box.size=Vector2(128,art_h); box.mouse_filter=Control.MOUSE_FILTER_IGNORE; body.add_child(box)
 if corp:
  var corporate_art := CorporateArt.new(); corporate_art.position=Vector2(16,art_y); corporate_art.size=Vector2(128,art_h); corporate_art.mouse_filter=Control.MOUSE_FILTER_IGNORE; body.add_child(corporate_art)
 var category: String=d.type + (" · " + view.skin.corporation if corp else " · " + rarity)
 if not corp and not d.tags.is_empty() and type_h>14: category+="\n"+" / ".join(d.tags)
 var type_line := FriendlyLook.label(category, 8, Color("#4A5568") if corp else Color("#3A3A3A"), view.skin.font if corp else FriendlyLook.MONO)
 type_line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; type_line.position = Vector2(16, art_y+art_h+3); type_line.size = Vector2(128, type_h); body.add_child(type_line)
 var rules := RichTextLabel.new(); rules.mouse_filter = Control.MOUSE_FILTER_IGNORE; rules.bbcode_enabled = true; rules.scroll_active = false
 var font: Font = view.skin.font if corp else FriendlyLook.MONO
 var cached: Dictionary = view.game._find(view.game.hand, uid)
 var cache_h := 15 if cached.get("cached", false) else 0
 var y := art_y+art_h+type_h+6
 var available := label_bottom - y - cache_h - (20 if corp else 0)
 var font_size := 11
 while font_size > 7 and font.get_multiline_string_size(rule, HORIZONTAL_ALIGNMENT_LEFT, 128, font_size).y > available: font_size -= 1
 rules.add_theme_font_override("normal_font", font); rules.add_theme_font_size_override("normal_font_size", font_size); rules.add_theme_color_override("default_color", FriendlyLook.TONER)
 var re := RegEx.new(); re.compile("([+−\\-]?[0-9]+(?: STR| BW| SHIELD| CRED| TRACE| RAM)?)")
 rules.text = re.sub(rule, "[bgcolor=#E4FF3A][color=#111111]$1[/color][/bgcolor]", true)
 rules.position = Vector2(16, y); rules.size = Vector2(128, available); body.add_child(rules)
 if corp:
  var footer := FriendlyLook.label("We just want to stay in touch." if id=="TRACER" else "Recommended for you.",9,Color("#4A5568"),view.skin.font)
  footer.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; footer.position=Vector2(16,214); footer.size=Vector2(128,19); body.add_child(footer)
 if cache_h > 0:
  var cached_tag := FriendlyLook.label("CACHED" + (" · TEMP" if cached.has("cache_turns") else ""), 9, FriendlyLook.TONER, FriendlyLook.BOLD)
  cached_tag.position = Vector2(16, label_bottom-12); body.add_child(cached_tag)
 tooltip_text = d.name + " · " + d.type + " · " + rarity + "\n" + rule
 if uid >= 0:
  var chk: Dictionary = view.game.can_play(uid)
  if not chk.ok: tooltip_text += "\n" + chk.reason
  mouse_entered.connect(func(): view.hover_uid = uid; view.hand.focus_card(self))
  mouse_exited.connect(func(): view.hover_uid = -1; view.hand.release_card(self))
 gui_input.connect(_card_input)
 queue_redraw()
func _draw() -> void:
 draw_rect(Rect2(Vector2(4,22),size-Vector2(0,18)),FriendlyLook.TONER)
 if uid>=0 and (z_index==100 or view.ui.targeting==uid): draw_rect(PHYSICAL_RECT.grow(2),FriendlyLook.HIGHLIGHT,false,3)
 if placeholder:
  draw_rect(Rect2(Vector2.ZERO, size), Color("#F7F7F2"))
  var rect := Rect2(Vector2(2, 2), size - Vector2(4, 4))
  for edge in [[rect.position, Vector2(rect.end.x, rect.position.y)], [Vector2(rect.end.x, rect.position.y), rect.end], [rect.end, Vector2(rect.position.x, rect.end.y)], [Vector2(rect.position.x, rect.end.y), rect.position]]:
   draw_dashed_line(edge[0], edge[1], Color("#737373"), 2, 7)
 else:
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
 var preview := FriendlyCard.new(); preview.setup(view, card_id, -1); preview.rotation_degrees = -3; preview.position = -CARD_SIZE/2; set_drag_preview(preview)
 return {"kind": "card", "uid": uid}
func _notification(what: int) -> void:
 if what == NOTIFICATION_DRAG_END and drag_started:
  placeholder = false
  if is_instance_valid(body): body.show()
  queue_redraw()
  if is_instance_valid(view): view.end_drag()

func _has_point(point: Vector2) -> bool:
 # Components and the BW tab are interactive even where they protrude beyond the label body.
 return (Rect2(Vector2.ZERO,CARD_SIZE) if corporate else PHYSICAL_RECT).has_point(point)
