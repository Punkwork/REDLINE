extends SceneTree
## Actual type/rarity templates, extended hardware bounds, and worst-case authored text.
var main: Node
var failures:=0
var checks:=0
const EXAMPLES:=["DEEP_PROBE","STRESS_TEST","PAYDAY","PASSKEY","JACKHAMMER","SKELETON_KEY","TOOLBELT","SURGE_PROTECTOR","FAILSAFE","TRACER","SPAM"]
func _initialize() -> void: call_deferred("run")
func check(ok: bool, message: String) -> void:
 checks+=1
 if not ok: failures+=1; push_error("Cartridges: "+message)
func settle(n: int=6) -> void:
 for i in n: await process_frame
 await RenderingServer.frame_post_draw
func check_card(card: FriendlyCard) -> void:
 var d:=CardDB.def(card.card_id)
 for child in card.body.get_children():
  # CARDS-003: rules sit in the rules panel; art in the type's art slot; rarity on the lamp.
  if child.name=="SolderRulesFrame":
   var rules: RichTextLabel=child.get_node("CenteredRules")
   check(rules.get_content_height()<=child.size.y+1,"full rules fit: "+card.card_id)
  if child.name=="CircuitStencil" or child is FriendlyCard.CorporateArt: check(FriendlyCard.glow_layout(d.type).art.encloses(child.get_rect()),"art stays inside its frame")
  if child is FriendlyCard.RarityLight: check(child.tier==d.rarity,"authored rarity preserved")
 var shells:=card.find_children("SlotCartridge","TextureRect",true,false)
 check(shells.size()==1 and shells[0].size==FriendlyCard.PHYSICAL_RECT.size,"chassis extends beyond paper card")
func run() -> void:
 main=load("res://scenes/Main.tscn").instantiate(); root.add_child(main); main.voice_on=false; main.voice.stop(); await settle()
 main._start_as("GENERALIST"); var g: Game=main.g
 g.rng.seed=711; g.row=0; g.available=[0]; g.enter_node(0)
 if g.phase=="READY_RIG": g.skip_ready_rig()
 main.refresh(); await settle()
 var viewport:=SubViewport.new(); viewport.size=Vector2i(620,860); viewport.render_target_update_mode=SubViewport.UPDATE_ALWAYS; root.add_child(viewport)
 var background:=ColorRect.new(); background.color=Color("#E6EEEA"); background.size=Vector2(620,860); viewport.add_child(background)
 var current: FriendlyCard
 for id in EXAMPLES:
  if is_instance_valid(current): viewport.remove_child(current); current.queue_free()
  current=FriendlyCard.new(); current.setup(main.friendly,id,-1); current.position=Vector2(64,58); current.scale=Vector2(3,3); viewport.add_child(current)
  var d:=CardDB.def(id)
  var caption:=FriendlyLook.label(d.type+" / "+d.rarity,18,FriendlyLook.SLATE,FriendlyLook.BOLD); caption.position=Vector2(46,829); viewport.add_child(caption)
  await settle(); check_card(current)
  var path:=OS.get_environment("SHOT_DIR").path_join(d.type.to_lower()+"-"+d.rarity.to_lower()+"-"+id.to_lower()+".png")
  check(viewport.get_texture().get_image().save_png(path)==OK,"save "+path); print("shot ",id)
  viewport.remove_child(caption); caption.queue_free()
 viewport.queue_free()
 # Every authored card, plus the longest legal shared-tag compiled SCRIPT pair.
 var staging:=Control.new(); staging.position=Vector2(1800,0); root.add_child(staging)
 var ids: Array=CardDB.DEFS.keys(); var combined:=""; var longest:=0
 for a in ids:
  if CardDB.def(a).type!="SCRIPT": continue
  for b in ids:
   if a==b or CardDB.def(b).type!="SCRIPT" or not CardDB.def(a).tags.any(func(t): return CardDB.def(b).tags.has(t)): continue
   var id: String="COMPILED::"+a+"::"+b; var length:=g.card_text(id).length()
   if length>longest: longest=length; combined=id
 ids.append(combined)
 for id in ids:
  var card:=FriendlyCard.new(); card.setup(main.friendly,id,-1); staging.add_child(card)
 for id in ["TRACER","SPAM"]:
  var inst:=g._new_inst(id); inst.cached=true; g.hand.append(inst)
  var card:=FriendlyCard.new(); card.setup(main.friendly,id,inst.uid); staging.add_child(card)
 await settle(2)
 for card in staging.get_children(): check_card(card)
 staging.queue_free()
 # Full hands (up to the HAND-MAX-001 maximum of 10) fan inside the hand area, hardware included.
 for count in [6,8,10]:
  g.hand.clear()
  for i in count: g.hand.append(g._new_inst(EXAMPLES[i%EXAMPLES.size()]))
  main.refresh(); await settle()
  for card in main.friendly.hand.get_children():
   var rect:=FriendlyCard.PHYSICAL_RECT
   for point in [rect.position,Vector2(rect.end.x,rect.position.y),rect.end,Vector2(rect.position.x,rect.end.y)]:
    var world: Vector2=card.get_global_transform()*point
    var area: Rect2=main.friendly.hand.get_global_rect()
    check(world.x>=area.position.x-1 and world.x<=area.end.x+1 and world.y>=area.position.y and world.y<=1050,"hardware fits hand and clears rig/buttons: %d %s"%[count,str(world)])
  if count==6 or count==8:
   var path:=OS.get_environment("SHOT_DIR").path_join("encounter-cartridges-%d.png"%count)
   check(root.get_texture().get_image().save_png(path)==OK,"save encounter")
 # Corporate junk is a bulky physical module but keeps its real unplayability/clear costs.
 g.hand.clear()
 for id in ["PROBE","PASSKEY","TOOLBELT","TRACER","SPAM","PULP_SHIELD"]: g.hand.append(g._new_inst(id))
 main.refresh(); await settle()
 check(root.get_texture().get_image().save_png(OS.get_environment("SHOT_DIR").path_join("encounter-whirlwind-bloat.png"))==OK,"save mixed bloat hand")
 print("CARTRIDGE UI: %d checks, %d failures"%[checks,failures])
 main.voice.stop(); main.voice.stream=null; main.queue_free(); await settle(); quit(1 if failures else 0)
