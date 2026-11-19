class_name FriendlyCard
extends Control
## Paper UI only. Playing a card always goes through the existing Game API.
const CARD_SIZE:=Vector2(164,244)
const PHYSICAL_RECT:=Rect2(-10,-12,184,268)
const PCB_RULES_INSET := 5.0
const PCB_RULES_MAX := 11
const PCB_RULES_MIN := 9
## Last resort for very long text (compiled cards), tall layout only: shrink rather than clip.
const PCB_RULES_FLOOR := 7
const PCB_TYPE_MAX := 9
const PCB_TYPE_MIN := 8
## CARDS-002: card text sits on dark solder-mask panels, never on the bare board.
const PCB_GLOW_INK := Color("#FFF3D0")
const PCB_GLOW_NUMBER := Color("#FFC861")
const PCB_GLOW_HALO := Color(1.0, 0.86, 0.55, 0.32)
const PCB_PLATE_PAD := 8.0
const PCB_CACHE_GLOW := Color("#7FE3F0")
## CARDS-002 (APPROVED 2026-11-19): every card type gets the PCB glow treatment.
## Each mask is a deep tint of its own laminate; BLOATWARE keeps its corporate face.
const GLOW_TREATMENT := {
 "SCRIPT": {"laminate": Color("#AE924D"), "mask": Color("#2E2712"), "lamp": Vector2(63, 6)},
 "PROGRAM": {"laminate": Color("#5A8048"), "mask": Color("#172312"), "lamp": Vector2(63, 16)},
 "PROTOCOL": {"laminate": Color("#60938A"), "mask": Color("#14272A"), "lamp": Vector2(100, 11)},
 "BLOATWARE": {"mask": Color("#2A1411")},
}
const CORP_FACE := Rect2(10, 58, 144, 153)

## Rects for the title panel, art, type plate, rules panel and cache edge,
## derived from each Rustler board (or the corporate face for BLOATWARE).
static func glow_layout(type: String, tall := false) -> Dictionary:
 if type == "BLOATWARE":
  return {
   "title": Rect2(15, 60, 120, 26), "art": Rect2(16, 91, 128, 16),
   "type": Rect2(16, 108, 128, 13), "rules": Rect2(15, 124, 130, 84),
   "edge": Rect2(11, 57, 142, 155), "leads": false,
  }
 var board: Rect2 = BOARD_RECT[type]
 var top := board.position.y
 if tall:
  # Long text: the stencil slot collapses, the type plate moves up under the
  # title and the rules panel takes the freed space at full glow-safe width.
  return {
   "title": Rect2(13, top + 3, 124, 38), "art": Rect2(),
   "type": Rect2(16, top + 46, 128, 13), "rules": Rect2(12, top + 62, 138, board.end.y - 14 - (top + 62)),
   "edge": Rect2(9.5, top - 0.5, 143, board.end.y - 2.5 - (top - 0.5)), "leads": true, "tall": true,
  }
 return {
  "title": Rect2(13, top + 3, 124, 38), "art": Rect2(16, top + 48, 128, 40),
  "type": Rect2(16, top + 90, 128, 13), "rules": Rect2(13, top + 105, 134, board.end.y - 14 - (top + 105)),
  "edge": Rect2(9.5, top - 0.5, 143, board.end.y - 2.5 - (top - 0.5)), "leads": true,
 }

static func glow_mask(type: String) -> Color:
 return GLOW_TREATMENT[type]["mask"]
const PCB_NUMBER := "([+−\\-]?[0-9]+(?: STR| BW| SHIELD| CRED| TRACE| RAM)?)"
## Rustler board area on each cartridge shell.
const BOARD_RECT := {
 "SCRIPT": Rect2(7, 18, 148, 203),
 "PROGRAM": Rect2(7, 30, 148, 199),
 "PROTOCOL": Rect2(7, 23, 148, 198),
}
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
  var c:=Vector2(size.x/2,8)
  draw_line(c+Vector2(0,7),c-Vector2(0,3),Color("#FFF9E9"),2,true)
  draw_circle(c-Vector2(0,4),2,Color("#FFF9E9"))
  draw_arc(c,7,-PI*0.8,-PI*0.2,20,Color("#FFF9E9"),1,true)
  draw_arc(c,12,-PI*0.8,-PI*0.2,20,Color("#FFF9E9"),1,true)
class CircuitStencil extends Control:
 ## CARDS-002: one silkscreen footprint per Rustler type, drawn in a 128 x 40 slot.
 ## SCRIPT: edge connector. PROGRAM: DIP chip. PROTOCOL: TO-5 can between two coils.
 const SILK := Color("#F2E5C2")
 const CORE := Color("#24231C")
 var kind := "SCRIPT"

 func via(at: Vector2, r := 2.5) -> void:
  draw_circle(at, r, SILK, true, -1.0, true)
  draw_circle(at, r * 0.56, CORE, true, -1.0, true)

 func routes(list: Array) -> void:
  for route in list:
   draw_polyline(PackedVector2Array(route), SILK, 1.25, true)
   via(route[0] if route[0].x < 64 else route[-1])

 func _draw() -> void:
  match kind:
   "PROGRAM": draw_dip()
   "PROTOCOL": draw_can()
   _: draw_connector()

 func draw_connector() -> void:
  var connector := Rect2(35, 9, 58, 26)
  draw_rect(connector, SILK, false, 1.6)
  draw_arc(Vector2(35, 22), 13, PI / 2, PI * 1.5, 24, SILK, 1.6, true)
  draw_arc(Vector2(93, 22), 13, -PI / 2, PI / 2, 24, SILK, 1.6, true)
  for pin_x in [43, 53, 63, 73, 83]:
   via(Vector2(pin_x, 22), 3.0)
  routes([
   [Vector2(7, 6), Vector2(15, 6), Vector2(22, 13), Vector2(26, 13)],
   [Vector2(102, 31), Vector2(107, 31), Vector2(114, 38), Vector2(121, 38)],
   [Vector2(11, 34), Vector2(18, 34), Vector2(22, 30)],
   [Vector2(106, 14), Vector2(113, 7), Vector2(122, 7)],
  ])

 func draw_dip() -> void:
  # Chip body with its orientation notch, and six pads on each side.
  var body := Rect2(36, 12, 56, 17)
  draw_rect(body, SILK, false, 1.6)
  draw_arc(Vector2(body.position.x, body.get_center().y), 4.0, -PI / 2, PI / 2, 16, SILK, 1.4, true)
  draw_circle(Vector2(body.position.x + 8, body.end.y - 4), 1.3, SILK, true, -1.0, true)
  for i in range(6):
   var x := 41.0 + i * 9.2
   for y in [6.0, 35.0]:
    draw_rect(Rect2(x - 2.2, y - 2.8, 4.4, 5.6), SILK)
    draw_circle(Vector2(x, y), 1.1, CORE, true, -1.0, true)
  routes([
   [Vector2(7, 9), Vector2(16, 9), Vector2(22, 15), Vector2(36, 15)],
   [Vector2(9, 32), Vector2(17, 32), Vector2(21, 26), Vector2(36, 26)],
   [Vector2(92, 15), Vector2(106, 15), Vector2(112, 9), Vector2(121, 9)],
   [Vector2(92, 26), Vector2(107, 26), Vector2(112, 32), Vector2(119, 32)],
  ])

 func draw_can() -> void:
  # TO-5 can: outline, tab and three plated leads, between two coil footprints.
  var c := Vector2(64, 21)
  draw_arc(c, 13.0, 0, TAU, 40, SILK, 1.6, true)
  var tab := c + Vector2(9.5, -9.5)
  draw_polyline(PackedVector2Array([tab + Vector2(-2.5, -1), tab + Vector2(1.5, -5), tab + Vector2(5, -1.5), tab + Vector2(1, 2.5)]), SILK, 1.4, true)
  for lead in [Vector2(-5.5, 3.5), Vector2(0, -5.5), Vector2(5.5, 3.5)]:
   via(c + lead, 2.6)
  for side in [-1.0, 1.0]:
   var start := Vector2(64 + side * 19, 21)
   var hump := 6.5
   for i in range(4):
    var center := start + Vector2(side * (hump * (i + 0.5)), 0)
    draw_arc(center, hump / 2.0, PI, TAU, 12, SILK, 1.7, true)
   draw_line(Vector2(64 + side * 13, 21), start, SILK, 1.6, true)
   var end := start + Vector2(side * (hump * 4 + 4), 0)
   draw_line(start + Vector2(side * hump * 4, 0), end, SILK, 1.6, true)
   via(end, 2.8)
  for route in [
   [Vector2(9, 21), Vector2(9, 12), Vector2(15, 6), Vector2(24, 6)],
   [Vector2(119, 21), Vector2(119, 30), Vector2(113, 36), Vector2(104, 36)],
  ]:
   draw_polyline(PackedVector2Array(route), SILK, 1.25, true)
   via(route[-1])

class CostCircle extends Control:
 func _draw() -> void:
  draw_circle(Vector2(14,15),15,Color("#253237"))
  draw_circle(Vector2(13,13),14,Color("#D3DEDB"))
  draw_circle(Vector2(13,13),11.5,Color("#29352F"))
  draw_line(Vector2(3,3),Vector2(7,3),Color.WHITE,1,true)
class PrintedBoard extends Control:
 const SILK := Color("#F2E5C2")
 const CONTACT := Color("#24231C")
 var laminate: Color
 var face: Color
 func _draw() -> void:
  var bounds := Rect2(Vector2.ZERO, size)
  draw_rect(bounds, laminate)
  draw_rect(bounds.grow(-5), face)
  var right := size.x - 2.5
  var bottom := size.y - 2.5
  draw_polyline(PackedVector2Array([
   Vector2(2.5, 34), Vector2(2.5, 8), Vector2(8, 2.5), Vector2(38, 2.5)
  ]), SILK, 1.0, true)
  draw_polyline(PackedVector2Array([
   Vector2(right, bottom - 42), Vector2(right, bottom - 5),
   Vector2(right - 5, bottom), Vector2(right - 44, bottom)
  ]), SILK, 1.0, true)
  for hole in [Vector2(2.5, 34), Vector2(38, 2.5), Vector2(right, bottom - 42), Vector2(right - 44, bottom)]:
   draw_circle(hole, 1.8, SILK, true, -1.0, true)
   draw_circle(hole, 1.0, CONTACT, true, -1.0, true)
  draw_rect(Rect2(12, size.y - 4.5, 31, 4), SILK, false, 0.7)
  for pin in range(6):
   draw_circle(Vector2(15 + 5 * pin, bottom), 1.15, CONTACT, true, -1.0, true)
class RarityLight extends Control:
 const LAMPS := {
  "COMMON": Color("#F5CA76"),
  "UNCOMMON": Color("#94D98C"),
  "RARE": Color("#BF9EF6"),
 }
 const CELLS := {"COMMON": 1, "UNCOMMON": 2, "RARE": 3}
 var tier: String

 func lit_cells() -> int:
  return CELLS.get(tier, 0)

 func _draw() -> void:
  var light: Color = LAMPS[tier]
  var housing := Rect2(Vector2.ZERO, size)
  draw_style_box(make_box(Color("#3C372C"), Color("#92866D"), 1, 2), housing)
  draw_style_box(make_box(Color("#211E19"), Color("#211E19"), 0, 1), housing.grow(-1))
  # Three cells fill left to right (1 Common, 2 Uncommon, 3 Rare), so rarity
  # never depends on colour alone. Unlit cells stay smoked glass.
  var slot := housing.grow(-2)
  var gap := 1.0
  var cell_w := (slot.size.x - gap * 2) / 3.0
  for cell in range(3):
   var r := Rect2(slot.position.x + cell * (cell_w + gap), slot.position.y, cell_w, slot.size.y)
   if cell < lit_cells():
    draw_style_box(make_box(light.darkened(0.48), light.darkened(0.48), 0, 1), r)
    draw_style_box(make_box(light, light, 0, 1), r.grow(-0.7))
    draw_line(Vector2(r.position.x + 1.5, 2.8), Vector2(r.end.x - 1.5, 2.8), light.lightened(0.28), 0.5, true)
   else:
    draw_style_box(make_box(Color("#2E2A22"), Color("#2E2A22"), 0, 1), r)

 func make_box(fill: Color, edge: Color, rim: int, radius: int) -> StyleBoxFlat:
  var box := StyleBoxFlat.new()
  box.bg_color = fill
  box.border_color = edge
  box.set_border_width_all(rim)
  box.set_corner_radius_all(radius)
  return box

class SolderRuleFrame extends Control:
 var fill := Color.TRANSPARENT
 var leads := true
 var pads := true
 const TRACE_INK := Color("#E8DBB1")
 const SOLDER := Color("#D7CAA5")
 const PAD_EDGE := Color("#6F5933")
 const HOLE := Color("#252219")

 func _draw() -> void:
  var right := size.x
  var bottom := size.y
  var corner := 4.0
  if fill.a > 0:
   draw_colored_polygon(PackedVector2Array([
    Vector2(corner, 0), Vector2(right - corner, 0), Vector2(right, corner),
    Vector2(right, bottom - corner), Vector2(right - corner, bottom),
    Vector2(corner, bottom), Vector2(0, bottom - corner), Vector2(0, corner)
   ]), fill)
  draw_polyline(PackedVector2Array([
   Vector2(corner, 0), Vector2(right - corner, 0), Vector2(right, corner),
   Vector2(right, bottom - corner), Vector2(right - corner, bottom),
   Vector2(corner, bottom), Vector2(0, bottom - corner), Vector2(0, corner),
   Vector2(corner, 0)
  ]), TRACE_INK, 0.85, true)

  if not leads:
   if not pads: return
   for pad in [Vector2(corner, 0), Vector2(right - corner, 0), Vector2(0, bottom - corner), Vector2(right, bottom - corner)]:
    draw_circle(pad, 2.25, PAD_EDGE, true, -1.0, true)
    draw_circle(pad + Vector2(0, -0.18), 1.85, SOLDER, true, -1.0, true)
    draw_circle(pad, 0.93, HOLE, true, -1.0, true)
   return
  var left_joint := Vector2(45, bottom)
  var right_joint := Vector2(96, bottom)
  var left_lead := Vector2(51, bottom + 7)
  var right_lead := Vector2(90, bottom + 7)
  draw_polyline(PackedVector2Array([
   left_joint, Vector2(45, bottom + 3), Vector2(49, left_lead.y), left_lead
  ]), TRACE_INK, 0.8, true)
  draw_polyline(PackedVector2Array([
   right_joint, Vector2(96, bottom + 3), Vector2(92, right_lead.y), right_lead
  ]), TRACE_INK, 0.8, true)

  # Empty axial resistor footprint, printed between its two plated lead holes.
  draw_line(left_lead, Vector2(58, left_lead.y), TRACE_INK, 0.75, true)
  draw_rect(Rect2(58, left_lead.y - 2.5, 25, 5), TRACE_INK, false, 0.75)
  draw_line(Vector2(83, right_lead.y), right_lead, TRACE_INK, 0.75, true)
  for pad in [
   Vector2(corner, 0), Vector2(right - corner, 0),
   Vector2(0, bottom - corner), Vector2(right, bottom - corner),
   left_joint, right_joint, left_lead, right_lead
  ]:
   draw_circle(pad, 2.25, PAD_EDGE, true, -1.0, true)
   draw_circle(pad + Vector2(0, -0.18), 1.85, SOLDER, true, -1.0, true)
   draw_circle(pad, 0.93, HOLE, true, -1.0, true)

class CacheEdgeGlow extends Control:
 ## CARDS-002: a cached card's board edge glows icy cyan. One state:
 ## a temporary cache looks the same as one held until played.

 func _draw() -> void:
  var r := Rect2(Vector2.ZERO, size)
  var c := 6.0
  var ring := PackedVector2Array([
   Vector2(c, 0), Vector2(r.end.x - c, 0), Vector2(r.end.x, c),
   Vector2(r.end.x, r.end.y - c), Vector2(r.end.x - c, r.end.y),
   Vector2(c, r.end.y), Vector2(0, r.end.y - c), Vector2(0, c), Vector2(c, 0)])
  var glow := PCB_CACHE_GLOW
  # Halo first (wide, faint), then the bright core.
  for pass_ in [[4.0, 0.10], [2.6, 0.22], [1.4, 1.0]]:
   draw_polyline(ring, Color(glow, pass_[1]), pass_[0], true)

static func pcb_rules_markup(rule: String) -> String:
 var re := RegEx.new(); re.compile(PCB_NUMBER)
 return "[center]" + re.sub(rule.replace("[", "[lb]"), "[b][color=#%s]$1[/color][/b]" % PCB_GLOW_NUMBER.to_html(false), true) + "[/center]"

## Soft phosphor halo: a zero-offset shadow outline in warm ivory.
static func add_glow(control: Control, radius: int) -> void:
 control.add_theme_color_override("font_shadow_color", PCB_GLOW_HALO)
 control.add_theme_constant_override("shadow_offset_x", 0)
 control.add_theme_constant_override("shadow_offset_y", 0)
 control.add_theme_constant_override("shadow_outline_size", radius)

## Largest print size at which the rule fits the frame, or 0 if it does not
## fit at PCB_RULES_MIN. Measured in the bold face, which is the wider.
static func glow_rules_size(rule: String, frame_size: Vector2, bold: Font, footer := false, floor_size := PCB_RULES_MIN) -> int:
 var bounds := frame_size - Vector2.ONE * PCB_RULES_INSET * 2 - Vector2(0, FOOTER_H if footer else 0)
 for print_size in range(PCB_RULES_MAX, floor_size - 1, -1):
  if bold.get_multiline_string_size(rule, HORIZONTAL_ALIGNMENT_CENTER, bounds.x, print_size).y <= bounds.y:
   return print_size
 return 0

const FOOTER_H := 12.0
const FOOTER_INK := Color("#D9CCA8")

static func build_glow_rules(rule: String, rect: Rect2, mask: Color, normal: Font, bold: Font, leads := true, footer := "", floor_size := PCB_RULES_MIN) -> Control:
 var frame := SolderRuleFrame.new()
 frame.name = "SolderRulesFrame"
 frame.position = rect.position
 frame.size = rect.size
 frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
 frame.fill = mask
 frame.leads = leads
 var bounds := Rect2(Vector2.ZERO, frame.size).grow(-PCB_RULES_INSET)
 if footer != "":
  bounds.size.y -= FOOTER_H
  var foot := Label.new()
  foot.name = "PanelFooter"
  foot.text = footer
  foot.add_theme_font_override("font", normal)
  foot.add_theme_font_size_override("font_size", 8)
  foot.add_theme_color_override("font_color", FOOTER_INK)
  foot.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
  foot.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
  foot.clip_text = true
  foot.position = Vector2(bounds.position.x, bounds.end.y)
  foot.size = Vector2(bounds.size.x, FOOTER_H)
  foot.mouse_filter = Control.MOUSE_FILTER_IGNORE
  frame.add_child(foot)
 var print_size := maxi(glow_rules_size(rule, rect.size, bold, footer != "", floor_size), floor_size)
 var rules := RichTextLabel.new()
 rules.name = "CenteredRules"
 rules.mouse_filter = Control.MOUSE_FILTER_IGNORE
 rules.bbcode_enabled = true
 rules.scroll_active = false
 rules.fit_content = true
 rules.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 rules.add_theme_font_override("normal_font", normal)
 rules.add_theme_font_override("bold_font", bold)
 rules.add_theme_font_size_override("normal_font_size", print_size)
 rules.add_theme_font_size_override("bold_font_size", print_size)
 rules.add_theme_color_override("default_color", PCB_GLOW_INK)
 add_glow(rules, 3)
 rules.position = bounds.position
 rules.size = Vector2(bounds.size.x, 0)
 rules.text = pcb_rules_markup(rule)
 frame.add_child(rules)
 # fit_content resizes the label once its text is laid out; keep the block
 # centred vertically inside the fixed frame whenever that happens.
 var recentre := func() -> void:
  rules.position = Vector2(bounds.position.x, bounds.position.y + (bounds.size.y - rules.size.y) / 2.0)
 rules.resized.connect(recentre)
 recentre.call()
 return frame

func setup(owner_view, id: String, card_uid: int) -> void:
 view = owner_view; card_id = id; uid = card_uid
 custom_minimum_size = CARD_SIZE; size = custom_minimum_size
 mouse_filter = Control.MOUSE_FILTER_STOP
 mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
 var d := CardDB.def(id)
 var corp: bool = d.type == "BLOATWARE"
 corporate=corp
 var rarity: String=d.get("rarity","COMMON")
 # CARDS-003: one presentation for every card type (BLOATWARE keeps its corporate face).
 var lay: Dictionary = glow_layout(d.type)
 var mask: Color = glow_mask(d.type)
 var rule: String = view.game.card_text(id)
 var rules_bold: Font = view.skin.bold_font if corp else preload("res://assets/fonts/Barlow-Bold.ttf")
 if not corp and glow_rules_size(rule, lay.rules.size, rules_bold) == 0:
  lay = glow_layout(d.type, true)
 body = Control.new(); body.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); body.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(body)
 var shell:=TextureRect.new(); shell.name="SlotCartridge"; shell.expand_mode=TextureRect.EXPAND_IGNORE_SIZE; shell.texture=load("res://assets/friendly_lie/cartridges/"+d.type.to_lower()+".png"); shell.stretch_mode=TextureRect.STRETCH_SCALE; shell.position=PHYSICAL_RECT.position; shell.size=PHYSICAL_RECT.size; shell.mouse_filter=Control.MOUSE_FILTER_IGNORE; body.add_child(shell)
 # Rustler boards: laminate with silkscreen and holes around the perimeter.
 if BOARD_RECT.has(d.type):
  var board := PrintedBoard.new()
  board.name = "PrintedBoard"
  board.position = BOARD_RECT[d.type].position
  board.size = BOARD_RECT[d.type].size
  board.laminate = GLOW_TREATMENT[d.type]["laminate"]
  board.face = board.laminate
  board.mouse_filter = Control.MOUSE_FILTER_IGNORE
  body.add_child(board)
 # A stationary material layer sits behind printing, inset from chassis and contacts.
 var grain:=ColorRect.new(); grain.name="BoardMaterialGrain"; grain.mouse_filter=Control.MOUSE_FILTER_IGNORE
 var grain_rect:=Rect2(11,26,136,176)
 if d.type=="PROGRAM": grain_rect=Rect2(12,49,135,159)
 elif d.type=="PROTOCOL": grain_rect=Rect2(13,32,134,172)
 elif corp: grain_rect=Rect2(15,66,132,139)
 grain.position=grain_rect.position; grain.size=grain_rect.size
 var grain_shader:=Shader.new()
 grain_shader.code="""shader_type canvas_item;
 uniform int material_kind = 0;
 float hash(vec2 p) { return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453); }
 float noise(vec2 p) {
  vec2 i=floor(p), f=fract(p); f=f*f*(3.0-2.0*f);
  return mix(mix(hash(i),hash(i+vec2(1,0)),f.x),mix(hash(i+vec2(0,1)),hash(i+vec2(1,1)),f.x),f.y);
 }
 void fragment() {
  vec2 p=UV*vec2(136.0,176.0);
  float grain=noise(p*2.2)-0.5;
  float material=0.0;
  if(material_kind==0) { material=(noise(p*vec2(0.32,1.5))-0.5)*0.65+grain*0.35; }
  else if(material_kind==1) { material=sin(p.x*4.1)*sin(p.y*4.1)*0.27+grain*0.25; }
  else if(material_kind==2) { material=(noise(p*vec2(2.0,0.075))-0.5)*0.75+grain*0.2; }
  else { material=(noise(p*0.10)-0.5)*0.6+(noise(p*0.43)-0.5)*0.4+grain*0.15; }
  float edge=smoothstep(0.0,0.035,UV.x)*smoothstep(0.0,0.035,1.0-UV.x)*smoothstep(0.0,0.025,UV.y)*smoothstep(0.0,0.025,1.0-UV.y);
  float opacity=abs(material)*0.26;
  // Bound the lightest Rustler grain so amber printing stays above 4.5:1.
  if (material_kind != 3 && material > 0.0) { opacity=min(opacity,0.05); }
  COLOR=vec4(material>0.0 ? vec3(0.94,0.85,0.65) : vec3(0.12,0.16,0.12),opacity*edge);
 }
 """
 var grain_material:=ShaderMaterial.new(); grain_material.shader=grain_shader
 grain_material.set_shader_parameter("material_kind",["SCRIPT","PROGRAM","PROTOCOL","BLOATWARE"].find(d.type))
 grain.material=grain_material; body.add_child(grain)
 # Rarity: a lamp with 1/2/3 lit cells; starters and BLOATWARE carry none.
 if RarityLight.LAMPS.has(rarity):
  var lamp := RarityLight.new()
  lamp.name = "TopRarityLight"
  lamp.tier = rarity
  lamp.position = GLOW_TREATMENT[d.type]["lamp"]
  lamp.size = Vector2(37, 8)
  lamp.mouse_filter = Control.MOUSE_FILTER_IGNORE
  body.add_child(lamp)
 var title_panel := SolderRuleFrame.new()
 title_panel.name = "TitlePanel"
 title_panel.fill = mask
 title_panel.leads = false
 title_panel.position = lay.title.position; title_panel.size = lay.title.size
 title_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
 body.add_child(title_panel)
 var title_font: Font=view.skin.bold_font if corp else FriendlyLook.BOLD
 var title := FriendlyLook.label(d.name.to_upper(), 10 if d.name.length() > 25 else (11 if d.name.length()>15 else 12), PCB_GLOW_INK, title_font)
 title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 var title_size:=int(title.get_theme_font_size("font_size"))
 while title_size>7 and title_font.get_multiline_string_size(title.text,HORIZONTAL_ALIGNMENT_LEFT,104,title_size).y>39: title_size-=1
 title.add_theme_font_size_override("font_size",title_size); body.add_child(title)
 title.position = lay.title.position + Vector2(6, 0); title.size = lay.title.size - Vector2(12, 0)
 title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
 add_glow(title, 4)
 var circle := CostCircle.new(); circle.position = Vector2(142, 5); circle.size = Vector2(26, 26); circle.mouse_filter = Control.MOUSE_FILTER_IGNORE; body.add_child(circle)
 var cost := FriendlyLook.label(str(view.game.card_cost(id)) if uid >= 0 else str(d.bw), 15, Color("#F2CD87") if corp else Color.WHITE, FriendlyLook.BOLD)
 cost.add_theme_color_override("font_shadow_color", Color("#D6B67580")); cost.add_theme_constant_override("shadow_offset_x", 0); cost.add_theme_constant_override("shadow_offset_y", 0); cost.add_theme_constant_override("shadow_outline_size", 2)
 cost.position = Vector2(143, 5); cost.size = Vector2(25, 25); cost.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; body.add_child(cost)
 # Art slot: the type's circuit stencil, a graft in its place, or BLOATWARE's corporate art.
 var graft: String = view.game._find(view.game.run_deck, uid).get("graft", "")
 if corp:
  var corporate_art := CorporateArt.new(); corporate_art.position=lay.art.position; corporate_art.size=lay.art.size; corporate_art.mouse_filter=Control.MOUSE_FILTER_IGNORE; body.add_child(corporate_art)
 elif lay.has("tall"):
  # No art slot on a long card; a graft shows as a small part on the chassis edge.
  if graft in Game.GRAFT_PARTS:
   add_graft_art(graft, Rect2(149, 75, 20, 22))
 else:
  var stencil := CircuitStencil.new()
  stencil.name = "CircuitStencil"
  stencil.kind = d.type
  stencil.position = lay.art.position
  stencil.size = lay.art.size
  stencil.mouse_filter = Control.MOUSE_FILTER_IGNORE
  body.add_child(stencil)
  if graft in Game.GRAFT_PARTS:
   stencil.hide()
   add_graft_art(graft, lay.art)
 var stamp := " · ".join([d.type] + ([view.skin.corporation] if corp else Array(d.tags)))
 var stamp_font: Font = view.skin.font if corp else preload("res://assets/fonts/RoutedGothic.ttf")
 var stamp_size := PCB_TYPE_MAX
 while stamp_size > PCB_TYPE_MIN and stamp_font.get_string_size(stamp, HORIZONTAL_ALIGNMENT_LEFT, -1, stamp_size).x > lay.type.size.x:
  stamp_size -= 1
 var stamp_w := stamp_font.get_string_size(stamp, HORIZONTAL_ALIGNMENT_LEFT, -1, stamp_size).x + PCB_PLATE_PAD * 2
 var plate := SolderRuleFrame.new()
 plate.name = "TypePlate"
 plate.fill = mask
 plate.leads = false
 plate.pads = false
 plate.size = Vector2(minf(stamp_w, lay.type.size.x + 4), lay.type.size.y)
 plate.position = Vector2(lay.type.get_center().x - plate.size.x / 2.0, lay.type.position.y)
 plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
 body.add_child(plate)
 var type_stamp := FriendlyLook.label(stamp, stamp_size, PCB_GLOW_INK, stamp_font)
 type_stamp.name = "TypeStamp"
 type_stamp.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 type_stamp.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
 type_stamp.clip_text = true
 # Routed Gothic is a single-stroke face; a 1 px outline in the same ink gives it weight at hand size.
 type_stamp.add_theme_color_override("font_outline_color", PCB_GLOW_INK)
 type_stamp.add_theme_constant_override("outline_size", 1)
 add_glow(type_stamp, 2)
 body.add_child(type_stamp)
 var stamp_h := maxf(lay.type.size.y, type_stamp.get_minimum_size().y)
 type_stamp.size = Vector2(lay.type.size.x, stamp_h)
 type_stamp.position = Vector2(lay.type.position.x, lay.type.get_center().y - stamp_h / 2.0)
 var cached: Dictionary = view.game._find(view.game.hand, uid)
 var is_cached: bool = cached.get("cached", false)
 var footer := ("We just want to stay in touch." if id=="TRACER" else "Recommended for you.") if corp and not is_cached else ""
 var normal_font: Font = view.skin.font if corp else preload("res://assets/fonts/Barlow-SemiBold.ttf")
 body.add_child(build_glow_rules(rule, lay.rules, mask, normal_font, rules_bold, lay.leads, footer, PCB_RULES_FLOOR if lay.has("tall") else PCB_RULES_MIN))
 # Cached: never printed; one cyan glow on the board, beneath the cost and every text panel.
 if is_cached:
  var edge := CacheEdgeGlow.new()
  edge.name = "CacheEdgeGlow"
  edge.position = lay.edge.position; edge.size = lay.edge.size
  edge.mouse_filter = Control.MOUSE_FILTER_IGNORE
  body.add_child(edge)
  body.move_child(edge, body.get_node("BoardMaterialGrain").get_index() + 1)
 tooltip_text = d.name + " · " + d.type + " · " + rarity + "\n" + rule
 if is_cached:
  tooltip_text += "\nCACHED" + (" (temporary)" if cached.has("cache_turns") else "")
 if uid >= 0:
  var chk: Dictionary = view.game.can_play(uid)
  if not chk.ok: tooltip_text += "\n" + chk.reason
  mouse_entered.connect(func(): view.hover_uid = uid; view.hand.focus_card(self))
  mouse_exited.connect(func(): view.hover_uid = -1; view.hand.release_card(self))
 gui_input.connect(_card_input)
 queue_redraw()
func add_graft_art(graft: String, bounds: Rect2) -> void:
 var overlay := GraftArt.new()
 overlay.name = graft
 overlay.position = bounds.position
 overlay.size = bounds.size
 overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
 body.add_child(overlay)

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
  elif uid >= 0 and not drag_started and view.dragging_uid < 0 and CardDB.def(card_id).type not in ["PROGRAM", "SCRIPT"]: view.ui._on_card(uid)
 if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
  view.ui.toggle_card_inspection(card_id, uid)
  accept_event()
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
 return PHYSICAL_RECT.has_point(point)
