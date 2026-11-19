extends Control
## ICE-ANALOG-001 — isolated, editable visual exploration. No Game/model dependency.
## Illustrative numbers only. Never wire this fixture into the default encounter.
const BG=Color("#19110f")
const MINT=Color("#a9c8b9")
const CREAM=Color("#f4e6c7")
const INK=Color("#251b17")
const COPPER=Color("#b47b4c")
const RED=Color("#bb3835")
const GREEN=Color("#428d67")
var scenario: String="friendly"
var reduced_motion: bool=false
var elapsed: float=0.0
var hovered: Vector2i=Vector2i(-1,-1)
var focused: Vector2i=Vector2i(-1,-1)
var illegal: bool=false
var animation_phase: String="idle"
var telegraph_slot: int=-1
var break_flash: bool=false
var tumble_progress: float=1.0
var key_boxes: Array[Dictionary]=[]
var font: Font=ThemeDB.fallback_font
var icons: Dictionary={"PULP":"✸","TRACE":"◎","DEADLOCK":"▣","DISCARD":"↪","INSERT":"✉","BW":"⌁","CORTEX":"♧","CURVE":"✸","VOID":"?","BOOTING":"▣"}
var examples: Dictionary={
 "friendly":{"turn":2,"trace":12,"mood":"FRIENDLY","auto_str":"5","captcha_str":"4","auto":[["PULP","1","ready"],["PULP","2","ready"],["PULP","3","ready"],["DEADLOCK","","ready"]],"captcha":[["TRACE","2","ready"],["DEADLOCK","","ready"]],"next":"PULP 1 → PULP 2 → PULP 3 → DEADLOCK"},
 "cracking":{"turn":3,"trace":30,"mood":"CRACKING","auto_str":"6 ↑2","captcha_str":"3 ↓2","auto":[["DEADLOCK","","broken"],["PULP","2","ready"],["PULP","3","ready"],["PULP","1","ready"]],"captcha":[["PULP","6","hit"],["TRACE","3","tumbled"]],"next":"PULP 6 → TRACE 3"},
 "tooltip":{"turn":3,"trace":30,"mood":"CRACKING","auto_str":"6 ↑2","captcha_str":"3 ↓2","auto":[["DEADLOCK","","broken"],["PULP","2","ready"],["PULP","3","ready"],["PULP","1","ready"]],"captcha":[["PULP","6","hit"],["TRACE","3","ready"]],"next":"PULP 6 → TRACE 3"},
 "illegal":{"turn":3,"trace":30,"mood":"CRACKING","auto_str":"6 ↑2","captcha_str":"3 ↓2","auto":[["DEADLOCK","","broken"],["PULP","2","ready"],["PULP","3","ready"],["PULP","1","ready"]],"captcha":[["PULP","6","hit"],["TRACE","3","ready"]],"next":"PULP 6 → TRACE 3"},
 "void":{"turn":3,"trace":30,"mood":"CRACKING","auto_str":"3","captcha_str":"7","auto":[["PULP","4","ready"],["CORTEX","1","ready"],["VOID","","hidden"]],"captcha":[["PULP","6","ready"],["DEADLOCK","","ready"]],"next":"PULP 4 → CORTEX 1 → unrevealed"},
 "three":{"turn":3,"trace":30,"mood":"CRACKING","auto_str":"5","captcha_str":"4","auto":[["PULP","1","ready"],["PULP","2","ready"],["DEADLOCK","","ready"]],"captcha":[["TRACE","2","ready"],["DEADLOCK","","ready"]],"next":"TRACE 2 → DEADLOCK"},
 "animation":{"turn":3,"trace":30,"mood":"CRACKING","auto_str":"6 ↑2","captcha_str":"3 ↓2","auto":[["DEADLOCK","","broken"],["PULP","2","ready"],["PULP","3","ready"],["PULP","1","ready"]],"captcha":[["PULP","6","tumbled"],["TRACE","3","ready"]],"next":"PULP 6 → TRACE 3"}
}
func _ready() -> void:
 custom_minimum_size=Vector2(1600,1000)
 mouse_filter=Control.MOUSE_FILTER_STOP
 set_process(true)
 set_process_input(true)
func _process(delta: float) -> void:
 elapsed+=delta
 queue_redraw()
func label(s: String,p: Vector2,sz: int=22,color: Color=INK) -> void:
 draw_string(font,p,s,HORIZONTAL_ALIGNMENT_LEFT,-1,sz,color)
func panel(r: Rect2,fill: Color,edge: Color=COPPER,rounding: float=16.0) -> void:
 draw_rect(r,fill,true)
 draw_rect(r,edge,false,3.0)
func _draw() -> void:
 key_boxes.clear()
 draw_rect(Rect2(Vector2.ZERO,size),BG)
 var d: Dictionary=examples.get(scenario,examples["friendly"])
 panel(Rect2(16,16,1568,76),Color("#39231b"))
 label("PANOPTICON   /   HALCYON NETWORK   /   CAPTCHA NODE",Vector2(40,66),33,CREAM)
 panel(Rect2(1050,26,250,54),GREEN if d["mood"]=="FRIENDLY" else RED)
 label(d["mood"],Vector2(1080,63),25,CREAM)
 label("TURN %02d   TRACE %02d" % [d["turn"],d["trace"]],Vector2(1320,63),22,CREAM)
 panel(Rect2(18,115,260,680),Color("#3b251c"))
 label("RUSTLER",Vector2(46,155),31,CREAM)
 label("BAKELITE / CRT",Vector2(46,188),19,CREAM)
 panel(Rect2(46,225,202,190),Color("#101b19"))
 label("HALCYON",Vector2(70,273),28,MINT)
 label("SECURITY",Vector2(70,316),23,MINT)
 label("MONITOR",Vector2(70,354),23,MINT)
 label("VITAE   16 / 20",Vector2(45,497),24,CREAM)
 label("BW       2 / 4",Vector2(45,540),24,CREAM)
 label("TRACE    %02d" % d["trace"],Vector2(45,590),24,CREAM)
 var three: bool=scenario=="three"
 var x0: float=300.0
 var cw: float=390.0 if three else 585.0
 var gap: float=18.0
 draw_console(Rect2(x0,118,cw,645),"DOORBELL CAM" if scenario=="void" else "AUTO-RENEW",str(d["auto_str"]),d["auto"],0,three)
 draw_console(Rect2(x0+cw+gap,118,cw,645),"HOUSE CALL" if scenario=="void" else "CAPTCHA",str(d["captcha_str"]),d["captcha"],1,three)
 if three:
  draw_console(Rect2(x0+2*(cw+gap),118,cw,645),"THE HEARTH","5",[["PULP","3","ready"],["TRACE","2","ready"],["DEADLOCK","","ready"]],2,true)
 panel(Rect2(300,785,1265,64),CREAM)
 label("NEXT RESPONSE  /  "+str(d["next"]),Vector2(320,825),25)
 panel(Rect2(20,867,1545,110),Color("#39231b"))
 label("HAND  /  PIERCE     REWIRE     BUFFER     OVERCLOCK     PATCH",Vector2(45,924),28,CREAM)
 label("SUPPORT  0/2",Vector2(1150,924),21,CREAM)
 if scenario=="tooltip" or scenario=="illegal" or hovered.x>=0 or focused.x>=0:
  draw_tooltip(d)
func draw_console(r: Rect2,title: String,strength: String,keys: Array,idx: int,compact: bool) -> void:
 panel(r,MINT)
 panel(Rect2(r.position+Vector2(12,10),Vector2(r.size.x-24,53)),CREAM)
 label("HALCYON   /   "+title,r.position+Vector2(23,46),26 if not compact else 20)
 label("STR "+strength,r.position+Vector2(r.size.x-155,105),24)
 var cx: float=r.position.x+r.size.x*0.50
 var cy: float=r.position.y+190
 var bob: float=0.0 if reduced_motion else sin(elapsed*(1.2 if idx==0 else 2.3)+idx)*5.0
 if animation_phase=="break" and not reduced_motion:
  bob-=12.0*abs(sin(elapsed*20.0))
 draw_circle(Vector2(cx,cy+bob),73.0 if not compact else 55.0,CREAM)
 draw_arc(Vector2(cx,cy+bob),73.0 if not compact else 55.0,0,TAU,40,COPPER,5)
 var eye_dx: float=0.0 if reduced_motion else 5.0*sin(elapsed*0.7)
 if not reduced_motion and animation_phase=="attention": eye_dx=15.0
 if not reduced_motion and animation_phase=="telegraph": eye_dx=-14.0
 for side in [-1,1]:
  draw_circle(Vector2(cx+side*24+eye_dx,cy-12+bob),5,INK)
 draw_arc(Vector2(cx,cy+15+bob),20,0.2,PI-0.2,18,INK,3)
 label("CHEERY" if idx==0 else "WARY",r.position+Vector2(25,340),17)
 var y: float=r.position.y+362
 var count: int=keys.size()
 var key_size: float=72.0 if not compact else 60.0
 var space: float=11.0 if not compact else 7.0
 var total: float=count*key_size+(count-1)*space
 var start: float=r.position.x+(r.size.x-total)/2.0
 for i in count:
  var data: Array=keys[i]
  var kr:=Rect2(start+i*(key_size+space),y,key_size,key_size)
  if animation_phase=="tumble" and idx==1 and i==0 and not reduced_motion:
   kr.position.y+=24.0*(1.0-tumble_progress)
  draw_key(kr,str(data[0]),str(data[1]),str(data[2]),idx,i)
  if i<count-1:
   label("›",Vector2(kr.end.x+1,y+key_size*0.64),20)
 panel(Rect2(r.position.x+14,r.position.y+478,r.size.x-28,47),CREAM)
 label("PASSIVE / "+("NONE" if idx>0 else "AUTO-RENEW"),r.position+Vector2(24,509),20)
 panel(Rect2(r.position.x+14,r.position.y+539,r.size.x-28,75),CREAM)
 label("RESPONSE / "+("TUMBLER" if idx==1 else "FORTRESS"),r.position+Vector2(24,568),21)
 label("ICON KEYS · HOVER OR FOCUS FOR RULE",r.position+Vector2(24,596),17)
func draw_key(r: Rect2,kind: String,value: String,state: String,ice: int,slot: int) -> void:
 key_boxes.append({"rect":r,"ice":ice,"slot":slot,"kind":kind,"value":value,"state":state})
 var fill: Color=RED if kind=="DEADLOCK" else CREAM
 if state=="broken": fill=Color("#6a7770")
 if state=="hidden": fill=Color("#363b3a")
 if state=="hit": fill=Color("#ffb0a0")
 if state=="tumbled": fill=Color("#f6d189")
 panel(r,fill,RED if state=="hit" else COPPER)
 if state=="hidden":
  draw_dashed_rect(r)
 label(str(icons.get(kind,"?")),r.position+Vector2(13,35),29,CREAM if state=="hidden" or kind=="DEADLOCK" else INK)
 if value!="": label(value,r.position+Vector2(r.size.x-29,r.size.y-13),27,CREAM if state=="hidden" else INK)
 if state=="broken":
  draw_line(r.position+Vector2(8,r.size.y-9),r.position+Vector2(r.size.x-8,9),INK,4)
 if state=="hit" or (animation_phase=="telegraph" and ice==1 and slot==telegraph_slot):
  draw_arc(r.get_center(),r.size.x*0.6,0,TAU,48,RED,3)
 if state=="tumbled": label("↓",r.position+Vector2(r.size.x-16,16),18,RED)
 if kind=="DEADLOCK" and state=="broken": label("✓",r.position+Vector2(4,17),18,GREEN)
 if state!="hidden":
  panel(Rect2(r.position.x+9,r.end.y-2,r.size.x-18,20),Color("#49352b"))
  label("1 BW",Vector2(r.position.x+14,r.end.y+14),14,CREAM)
func draw_dashed_rect(r: Rect2) -> void:
 for i in 8:
  var xx: float=r.position.x+float(i)*r.size.x/8.0
  draw_line(Vector2(xx,r.position.y),Vector2(xx+r.size.x/16.0,r.position.y),CREAM,2)
func draw_tooltip(_d: Dictionary) -> void:
 var kind: String="PULP"
 var value: String="6"
 var slot: int=1
 var target: Vector2i=hovered if hovered.x>=0 else focused
 if target.x>=0:
  for b in key_boxes:
   if b["ice"]==target.x and b["slot"]==target.y:
    kind=b["kind"]; value=b["value"]; slot=b["slot"]+1
 var r:=Rect2(970,475,530,280)
 panel(r,CREAM)
 label("S%d  /  %s %s" % [slot,kind,value],r.position+Vector2(25,42),30)
 label("RULE  /  "+("Lose %s VITAE (SHIELD blocks)" % value if kind=="PULP" else "Effect resolves when this slot fires"),r.position+Vector2(25,91),21)
 label("TIMING  /  This response",r.position+Vector2(25,137),20)
 label("BREAK  /  1 BW  ·  +1 TRACE",r.position+Vector2(25,178),20)
 label("HALCYON  /  Standard compliance check.",r.position+Vector2(25,225),19)
 if scenario=="illegal" or illegal: label("ILLEGAL: insufficient BW — no resources spent",r.position+Vector2(25,256),18,RED)
func _gui_input(event: InputEvent) -> void:
 if event is InputEventMouseMotion:
  hovered=Vector2i(-1,-1)
  for b in key_boxes:
   if b["rect"].has_point(event.position):
    hovered=Vector2i(b["ice"],b["slot"])
    break
 if event is InputEventMouseButton and event.pressed:
  illegal=true
  queue_redraw()
func _input(event: InputEvent) -> void:
 if event is InputEventKey and event.pressed and event.keycode==KEY_TAB:
  focused=Vector2i(0,0) if focused.x<0 else Vector2i((focused.x+1)%2,0)
  queue_redraw()
