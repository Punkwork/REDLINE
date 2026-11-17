class_name FriendlyMascot
extends FriendlyDropTarget
var index := 0
var mood := "cheery"
var face: FriendlyFace
var body: Panel
var base_position := Vector2.ZERO
var motion_offset := Vector2.ZERO
var clock := 0.0
var previous_mood := ""
var just_broken := false
var glow: Panel
var applied_knockout := false
var chrome: ChromeFrame
const WORDS := {
 "COOKIE_WALL": ["We use cookies to make your visit sweeter!", "You declined 2 cookies. Interesting.", "COOKIES ARE NOT OPTIONAL."],
 "CAPTCHA": ["Just one quick check!", "Hmm. Try that again.", "WRONG ANSWER."],
 "DOORBELL_CAM": ["Ding dong! Who's there?", "Recording, for your safety.", "I SEE YOU."],
 "AUTO_RENEW": ["Your plan renews automatically!", "You cancelled Basic? We'll remember that.", "Your plan cannot be cancelled."],
 "ACCEPT_ALL": ["Make yourself at home!", "We noticed you hesitating.", "YOUR CONSENT IS ASSUMED."],
 "REJECT_ALL": ["You may change your preferences.", "Are you absolutely sure?", "THERE IS NO OPT OUT."],
 "TERMS_OF_SERVICE": ["A few little terms before we begin!", "You haven't read the fine print.", "YOU ALREADY AGREED."],
 "CONSENT_FORM": ["Your choices matter to us!", "We saved your preferences. All of them.", "CONSENT IS MANDATORY."],
 "HOUSE_CALL": ["Your technician is on the way!", "Please stay where you are.", "WE KNOW YOU'RE HOME."],
 "FREE_TRIAL": ["Try us. No strings attached!", "Your trial is almost over.", "YOU CANNOT CANCEL."]}
const BUTTONS := {"COOKIE_WALL": "Accept all", "CAPTCHA": "I'm not a robot", "DOORBELL_CAM": "○", "AUTO_RENEW": "Keep my plan", "REJECT_ALL": "Reject all", "TERMS_OF_SERVICE": "I have read and agree", "CONSENT_FORM": "Submit", "FREE_TRIAL": "Start free trial"}
func place(child: Control, pos: Vector2, extent: Vector2 = Vector2.ZERO) -> Control:
 child.position = pos
 if extent != Vector2.ZERO: child.size = extent
 add_child(child); return child
func setup(owner_view, i: int, state: String) -> void:
 view = owner_view; ice_ref=view.game.enc.ice[i]; index = i; mood = state; custom_minimum_size = Vector2(480, 230); size = custom_minimum_size
 mouse_filter = Control.MOUSE_FILTER_PASS
 var ice: Dictionary = view.game.enc.ice[i]; var id: String = ice.id
 var lethal := mood == "lethal"; var wary := mood == "wary"
 var accent: Color = FriendlyLook.RED if lethal else (FriendlyLook.AMBER if wary else view.skin.accent)
 var ink: Color = Color("#F6E7E7") if lethal else view.skin.ink
 var fill: Color = Color("#140809") if lethal else Color.WHITE
 var radius: int = 0 if lethal else view.skin.radius
 var body_rect := Rect2(45, 15, 280, 172)
 var face_rect := Rect2(155, 50, 100, 100)
 var face_kind := "face"
 match id:
  "COOKIE_WALL": body_rect = Rect2(0, 60, 475, 110); face_rect = Rect2(15,65,100,100); face_kind = "cookie"; radius = 55 if not lethal else 0
  "CAPTCHA": body_rect = Rect2(40,0,230,230); face_rect = Rect2(105,7,100,80); face_kind = "eye"
  "DOORBELL_CAM": body_rect = Rect2(95,0,145,230); face_rect = Rect2(100,12,135,135); face_kind = "lens"; radius = 72 if not lethal else 0
  "ACCEPT_ALL": body_rect = Rect2(45,65,300,90); face_rect = Rect2(65,65,90,90); radius = 45 if not lethal else 0
  "REJECT_ALL": body_rect = Rect2(140,90,155,34); face_rect = Rect2(165,16,70,70); radius = 8 if not lethal else 0
  "TERMS_OF_SERVICE": body_rect = Rect2(65,0,235,225); face_rect = Rect2(120,0,90,85); radius = 4
  "CONSENT_FORM": body_rect = Rect2(65,5,235,220); face_rect = Rect2(138,15,85,80); radius = 8
  "HOUSE_CALL": body_rect = Rect2(65,8,235,215); face_rect = Rect2(132,58,100,100); face_kind = "house"; radius = 0
 if lethal:
  glow = FriendlyLook.panel(Color("#E5484D18"), FriendlyLook.RED, 2, radius, 12); place(glow,body_rect.position-Vector2(5,5),body_rect.size+Vector2(10,10)); glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
  var red_glow := glow.get_theme_stylebox("panel").duplicate() as StyleBoxFlat; red_glow.shadow_color=Color("#E5484D66"); red_glow.shadow_size=18; glow.add_theme_stylebox_override("panel",red_glow)
 if view.corporation_state=="cracking":
  for sign in [-1,1]:
   var split := FriendlyLook.panel(Color.TRANSPARENT,FriendlyLook.RED if sign<0 else Color("#77ABDF"),3,radius)
   split.mouse_filter=Control.MOUSE_FILTER_IGNORE; place(split,body_rect.position+Vector2(sign*3,0),body_rect.size)
 body = FriendlyLook.panel(accent if id in ["AUTO_RENEW", "FREE_TRIAL", "ACCEPT_ALL"] and not lethal else fill, accent if lethal else Color("#D5DCE5"), 2 if lethal else 0, radius, 4)
 var soft := body.get_theme_stylebox("panel").duplicate() as StyleBoxFlat; soft.shadow_color = Color(0,0,0,0.12); soft.shadow_size=14; soft.shadow_offset=Vector2(0,7); body.add_theme_stylebox_override("panel",soft)
 body.mouse_filter = Control.MOUSE_FILTER_PASS; place(body,body_rect.position,body_rect.size)
 chrome=ChromeFrame.new(); chrome.name="ChromeEnamel"; chrome.position=body_rect.position; chrome.size=body_rect.size; chrome.radius=radius; chrome.enamel=(accent if id=="AUTO_RENEW" and not lethal else fill); chrome.hostile=lethal; chrome.credit_card=id=="AUTO_RENEW"; add_child(chrome)
 if id in ["AUTO_RENEW","CAPTCHA"]:
  body.self_modulate.a=0.0; chrome.hide()
  var enamel_art:=TextureRect.new(); enamel_art.name="IllustratedShell"; enamel_art.texture=load("res://assets/friendly_lie/chrome/"+("auto-renew-shell.png" if id=="AUTO_RENEW" else "captcha-shell.png")); enamel_art.expand_mode=TextureRect.EXPAND_IGNORE_SIZE; enamel_art.stretch_mode=TextureRect.STRETCH_SCALE; enamel_art.mouse_filter=Control.MOUSE_FILTER_IGNORE
  enamel_art.modulate=Color(0.30,0.09,0.12) if lethal else (Color(1.0,0.88,0.64) if wary else Color.WHITE)
  place(enamel_art,body_rect.position-Vector2(5,5),body_rect.size+Vector2(10,10))
 body.gui_input.connect(func(e):
  if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT: view.click_ice(index))
 face = FriendlyFace.new(); face.reduced_motion=view.reduced_motion; face.kind = face_kind; face.mood = mood; face.ink = view.skin.ink; face.accent = accent; place(face,face_rect.position,face_rect.size)
 if id == "COOKIE_WALL":
  var cookie := FriendlyLook.panel(Color("#DFAF71") if not lethal else Color("#140809"), Color("#8D5A2A") if not lethal else accent, 3, 50)
  cookie.mouse_filter = Control.MOUSE_FILTER_IGNORE; place(cookie, Vector2(15,65), Vector2(100,100)); move_child(cookie,face.get_index()); face.move_to_front()
  for point in [Vector2(38,85),Vector2(88,142),Vector2(30,135)]:
   var crumb := FriendlyLook.label("•",20,Color("#8D5A2A")); place(crumb,point)
 if id in ["AUTO_RENEW", "FREE_TRIAL"]:
  place(FriendlyLook.label("HALCYON",10,ink,view.skin.bold_font),Vector2(64,20))
  var product:=FriendlyLook.label("AUTO-\nRENEW" if id=="AUTO_RENEW" else "FREE\nTRIAL",15,ink,view.skin.bold_font); place(product,Vector2(62,85),Vector2(86,48))
  if id!="AUTO_RENEW": place(FriendlyLook.panel(Color("#F2D77E"),Color.TRANSPARENT,0,6),Vector2(62,35),Vector2(35,26))
  place(FriendlyLook.label("•••• 4417",13,ink,view.skin.font),Vector2(62,147))
  var sticker := FriendlyLook.panel(FriendlyLook.RED if lethal else Color.WHITE,Color.TRANSPARENT,0,18)
  place(sticker,Vector2(195,-4),Vector2(174,32))
  var words := "NO REFUNDS" if lethal else ("Renews next turn" if wary else "FREE for 30 days!")
  var sticker_text := FriendlyLook.label(words,13, FriendlyLook.TONER if lethal else view.skin.deep,view.skin.bold_font); sticker_text.position=Vector2(10,5); sticker.add_child(sticker_text)
 if id == "CAPTCHA":
  var challenge := FriendlyLook.label("PROVE IT." if lethal else "Let's make sure you're human!",13,ink,view.skin.bold_font); challenge.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; challenge.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; place(challenge,Vector2(54,83),Vector2(203,40))
  for tile in 9:
   var strong: bool = tile in [1,4,8]
   var color: Color = accent if strong else (Color("#3C1014") if lethal else accent.lightened(0.65))
   var square := FriendlyLook.panel(color,Color.TRANSPARENT,0,0 if lethal else 4); square.mouse_filter=Control.MOUSE_FILTER_IGNORE; place(square,Vector2(54+(tile%3)*69,126+(tile/3 as int)*22),Vector2(64,19))
   var tile_art:=TextureRect.new(); tile_art.texture=preload("res://assets/friendly_lie/chrome/atrium.png"); tile_art.expand_mode=TextureRect.EXPAND_IGNORE_SIZE; tile_art.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED; tile_art.mouse_filter=Control.MOUSE_FILTER_IGNORE; tile_art.modulate=Color(1.0,0.2,0.25) if lethal else Color(0.75,0.85,0.82); place(tile_art,Vector2(56+(tile%3)*69,128+(tile/3 as int)*22),Vector2(60,15))
 if id == "TERMS_OF_SERVICE":
  for line in 5:
   var rule := ColorRect.new(); rule.color=Color("#C9A3A5") if lethal else Color("#CCD5D0"); rule.mouse_filter=Control.MOUSE_FILTER_IGNORE; place(rule,Vector2(81,96+line*13),Vector2(190-(line%3)*25,3))
  place(FriendlyLook.panel(accent),Vector2(287,22),Vector2(4,155))
 if id == "CONSENT_FORM":
  place(FriendlyLook.panel(view.skin.ink,Color.TRANSPARENT,0,4),Vector2(138,0),Vector2(88,20))
  for line in 3:
   place(FriendlyLook.panel(accent,Color.TRANSPARENT,0,9),Vector2(97,105+line*23),Vector2(90,15))
   place(FriendlyLook.panel(Color.WHITE,Color.TRANSPARENT,0,6),Vector2(165,107+line*23),Vector2(11,11))
 if id == "HOUSE_CALL":
  place(FriendlyLook.panel(Color("#1B0709")),Vector2(113,143),Vector2(140,59))
  var black_header := FriendlyLook.panel(FriendlyLook.RED); place(black_header,Vector2(32,-8),Vector2(410,24))
  var joined := FriendlyLook.label("BLACK ICE · JOINED AT STRIKE %d" % view.game.strikes,11,FriendlyLook.TONER,FriendlyLook.BOLD); joined.position=Vector2(8,3); black_header.add_child(joined)
 var entries: Array = WORDS.get(id, ["Just a quick check!", "Please stay on this screen.", "ACCESS DENIED."])
 var line: String = entries[2 if lethal else (1 if wary else 0)]
 if view.corporation_state=="cracking" and not lethal:
  if id=="AUTO_RENEW": line="We noticed unusual activity on your plan."
  elif id=="CAPTCHA": line="Are you sure you're human?"
 if mood == "knocked_out": line = "SESSION ENDED."
 var speech := FriendlyLook.panel(fill,accent if lethal else Color("#91A7AA"),2 if lethal else 1,0 if lethal else 14,3)
 var speech_pos := Vector2(294,38)
 var speech_size := Vector2(180,100)
 if id == "COOKIE_WALL": speech_pos=Vector2(122,72); speech_size=Vector2(188,78)
 if id == "ACCEPT_ALL": speech_pos=Vector2(290,3); speech_size=Vector2(185,57)
 var soft_speech := speech.get_theme_stylebox("panel").duplicate() as StyleBoxFlat; soft_speech.shadow_color=Color(0,0,0,0.10); soft_speech.shadow_size=12; soft_speech.shadow_offset=Vector2(0,5); speech.add_theme_stylebox_override("panel",soft_speech)
 place(speech,speech_pos,speech_size); speech.mouse_filter=Control.MOUSE_FILTER_IGNORE
 var copy_size:=18
 while copy_size>14 and view.skin.bold_font.get_multiline_string_size(line,HORIZONTAL_ALIGNMENT_LEFT,speech_size.x-24,copy_size).y>speech_size.y-18: copy_size-=1
 var copy := FriendlyLook.label(line,copy_size,ink,view.skin.bold_font); copy.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; copy.position=Vector2(12,10); copy.size=speech_size-Vector2(24,18); speech.add_child(copy)
 var d: Dictionary = view.game.ice_definition(ice)
 for sub in d.subs.size():
  if not Game._has_deadlock(d.subs[sub]): continue
  var text: String = BUTTONS.get(id, "Continue")
  var done: bool = ice.broken[sub]
  if done: text = "✓ " + text
  elif d.get("ability", "") == "BOOTING" and view.game.enc.turn < 3: text = "LOCKED · " + text
  var action := FriendlyLook.button(text,func(): view.break_action(index,sub), FriendlyLook.RED if lethal else Color.WHITE, FriendlyLook.TONER if lethal else ink,0 if lethal else 18,view.skin.bold_font)
  var chk: Dictionary = view.break_info(index,sub)
  action.add_theme_color_override("font_disabled_color",FriendlyLook.TONER if lethal else ink)
  for button_state in ["normal","hover","disabled"]:
   var button_style := action.get_theme_stylebox(button_state).duplicate() as StyleBoxFlat; button_style.border_color=FriendlyLook.RED if lethal else Color("#6D878C"); button_style.set_border_width_all(1); action.add_theme_stylebox_override(button_state,button_style)
  action.disabled = not chk.ok; action.tooltip_text = "DEADLOCK · " + ("BROKEN" if done else chk.get("reason", ""))
  var pos := Vector2(86,188); var extent := Vector2(210,34)
  if id == "CAPTCHA": pos=Vector2(54,198); extent=Vector2(202,28)
  if id == "DOORBELL_CAM": pos=Vector2(135,164); extent=Vector2(66,49)
  if id == "COOKIE_WALL": pos=Vector2(320,94); extent=Vector2(140,40)
  if id == "REJECT_ALL": pos=Vector2(145,94); extent=Vector2(146,28)
  place(action,pos,extent)
  if done:
   action.modulate.a=0.85
  break # The primary button remains ticked when it drops out; further locks remain in the scan.

func _ready() -> void:
 pivot_offset=Vector2(240,115)
 if view.reduced_motion: return
 if just_broken:
  scale=Vector2(0.9,0.9); create_tween().tween_property(self,"scale",Vector2.ONE,0.08)
 if mood=="wary" and previous_mood=="cheery":
  var brows: Control = face.features.brows
  brows.position.y=-3; brows.create_tween().tween_property(brows,"position:y",0.0,0.15)
 if view.corporation_state=="mask_off" and view.state_before_refresh!="mask_off":
  var style := body.get_theme_stylebox("panel") as StyleBoxFlat
  style.bg_color=view.skin.accent
  var peel := create_tween().set_parallel(true)
  peel.tween_property(style,"bg_color",Color("#140809"),0.3)
  peel.tween_method(func(v): style.set_corner_radius_all(int(v)),view.skin.radius,0,0.3)
 if view.game.ice_definition(view.game.enc.ice[index]).get("black",false) and previous_mood=="":
  motion_offset.y=-60; create_tween().tween_property(self,"motion_offset",Vector2.ZERO,0.3)
 if mood=="knocked_out":
  applied_knockout=true
  var ko := create_tween().set_parallel(true); ko.tween_property(self,"motion_offset",Vector2(0,44),0.4); ko.tween_property(self,"modulate:a",0.0,0.4)
 for sub in view.game.ice_definition(view.game.enc.ice[index]).subs.size():
  if view.ui._is_flash(view.game.enc.ice[index],sub):
   var lunge := create_tween(); lunge.tween_property(self,"motion_offset",Vector2(0,12),0.12); lunge.tween_property(self,"motion_offset",Vector2.ZERO,0.12); break
func _process(delta: float) -> void:
 if not is_visible_in_tree() or not is_instance_valid(view) or not is_instance_valid(face) or view.game.enc.is_empty() or index>=view.game.enc.ice.size(): return
 clock+=delta
 var target: Vector2 = view.interaction_position()
 var direction := (target-face.get_global_rect().get_center())/Vector2(260,180) if target!=Vector2.INF else Vector2.ZERO
 face.look=Vector2(clampf(direction.x,-1,1),clampf(direction.y,-1,1))
 if view.reduced_motion: return
 var d: Dictionary = view.game.ice_definition(view.game.enc.ice[index])
 var bob := 0.0
 if mood=="cheery":
  bob=sin(clock*TAU/(3.6 if d.type=="FORTRESS" else 2.4))*(0.3 if d.type=="VOID" else 4.0)
  if d.type=="TUMBLER": rotation_degrees=sin(clock*5)*0.35
 var shake := sin(clock*180)*2 if mood=="lethal" and previous_mood!="lethal" and clock<0.06 else 0.0
 position=base_position+motion_offset+Vector2(shake,bob)
 if is_instance_valid(glow): glow.modulate.a=0.65+0.35*(sin(clock*TAU)*0.5+0.5)
