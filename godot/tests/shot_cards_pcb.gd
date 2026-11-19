extends SceneTree
## CARDS-002 PCB glow card fixture, all four card types. CARD_SHOT_SCALE
## (default 3) sets the capture scale; 1 renders at hand size.

var failures := 0

func _initialize() -> void:
 call_deferred("run")

func fail(message: String) -> void:
 push_error(message)
 # CI greps fixture logs for this phrase.
 print("Assertion failed: CARDS-003 " + message)
 failures += 1

func run() -> void:
 var main: Node = load("res://scenes/Main.tscn").instantiate()
 root.add_child(main)
 main.voice_on = false
 main.voice.stop()
 for step in range(6):
  await process_frame
 main._start_as("GENERALIST")
 var g: Game = main.g
 g.rng.seed = 711
 g.row = 0
 g.available = [0]
 g.enter_node(0)
 if g.phase == "READY_RIG":
  g.skip_ready_rig()
 main.refresh()
 for step in range(6):
  await process_frame

 sweep_text_fit(g, main.friendly)

 # Cached copies in hand: held until played, and temporary. They must look the same.
 g.hand.append({"uid": 9001, "id": "DEEP_PROBE", "cached": true})
 g.hand.append({"uid": 9002, "id": "PASSKEY", "cached": true, "cache_turns": 2})
 g.hand.append({"uid": 9003, "id": "TRACER", "cached": true})
 # A grafted run-deck card: its graft art replaces the circuit stencil.
 g.run_deck.append({"uid": 9004, "id": "TOOLBELT", "cached": false, "graft": Game.GRAFT_PARTS[0]})

 var scale := float(OS.get_environment("CARD_SHOT_SCALE")) if OS.get_environment("CARD_SHOT_SCALE") != "" else 3.0
 scale = maxf(1.0, scale)
 var surface := SubViewport.new()
 surface.size = Vector2i(roundi(206 * scale), roundi(286 * scale))
 surface.render_target_update_mode = SubViewport.UPDATE_ALWAYS
 root.add_child(surface)
 var backdrop := ColorRect.new()
 backdrop.color = Color("#E6EEEA")
 backdrop.size = Vector2(surface.size)
 surface.add_child(backdrop)
 var suffix := "" if scale == 3.0 else "_%dx" % int(scale)

 var shots := [
  ["DEEP_PROBE", -1, "SCRIPT_DEEP_PROBE"],
  ["PASSKEY", -1, "PROGRAM_PASSKEY"],
  ["TOOLBELT", -1, "PROTOCOL_TOOLBELT"],
  ["TRACER", -1, "BLOATWARE_TRACER"],
  ["STRESS_TEST", -1, "SCRIPT_STRESS_TEST_UNCOMMON"],
  ["NULL_POINTER", -1, "SCRIPT_NULL_POINTER_RARE"],
  ["DEEP_PROBE", 9001, "SCRIPT_DEEP_PROBE_CACHED"],
  ["PASSKEY", 9002, "PROGRAM_PASSKEY_CACHED_TEMP"],
  ["TRACER", 9003, "BLOATWARE_TRACER_CACHED"],
  ["SHATTER", -1, "SCRIPT_SHATTER_LONGEST_RULES"],
  ["TOOLBELT", 9004, "PROTOCOL_TOOLBELT_GRAFTED"],
  ["COMPILED::SHATTER::BORROWED_CREDENTIALS", -1, "SCRIPT_COMPILED_LONGEST"],
  ["FORTRESS_ICEPICK", -1, "PROGRAM_FORTRESS_ICEPICK"],
  ["VOID_ICEPICK", -1, "PROGRAM_VOID_ICEPICK"],
  ["SKELETON_KEY", -1, "PROGRAM_SKELETON_KEY_ANY_TYPE"],
 ]
 for shot in shots:
  var card := FriendlyCard.new()
  card.setup(main.friendly, shot[0], shot[1])
  card.position = Vector2(21, 19) * scale
  card.scale = Vector2(scale, scale)
  surface.add_child(card)
  for step in range(5):
   await process_frame
  await RenderingServer.frame_post_draw
  check_card(card, shot[0], shot[1], g)
  var path := OS.get_environment("SHOT_DIR").path_join(shot[2] + suffix + ".png")
  if surface.get_texture().get_image().save_png(path) != OK:
   fail(shot[2] + ": could not save capture")
  surface.remove_child(card)
  card.queue_free()
 await hover_capture(main, g)
 await process_frame
 print("CARDS-003 card checks: %d failure(s)" % failures)
 quit(1 if failures else 0)

## Every base card's rules (AMP 0 to 3) must fit its panel at 9 px or larger.
## A compiled SCRIPT pair either fits too, or its face names the component
## cards (which must fit at 9 px) and hover shows the full text.
func sweep_text_fit(g: Game, view) -> void:
 var saved_amp: int = g.amp
 var routed: Font = preload("res://assets/fonts/RoutedGothic.ttf")
 var barlow_bold: Font = preload("res://assets/fonts/Barlow-Bold.ttf")
 var tally := {"base": 0, "compiled on face": 0, "compiled names + hover": 0}
 for amp in range(4):
  g.amp = amp
  for id in CardDB.DEFS:
   var d := CardDB.def(id)
   var corp: bool = d.type == "BLOATWARE"
   var bold: Font = view.skin.bold_font if corp else barlow_bold
   if FriendlyCard.glow_rules_size(g.card_text(id), FriendlyCard.glow_layout(d.type).rules.size, bold, corp) < FriendlyCard.PCB_RULES_MIN:
    fail("%s (%s, AMP %d): rules do not fit the panel at %d px" % [id, d.type, amp, FriendlyCard.PCB_RULES_MIN])
   tally.base += 1
 g.amp = saved_amp
 var ids: Array = CardDB.DEFS.keys()
 var rect: Rect2 = FriendlyCard.glow_layout("SCRIPT").rules
 for a in ids:
  if CardDB.def(a).type != "SCRIPT": continue
  for b in ids:
   if a == b or CardDB.def(b).type != "SCRIPT" or not CardDB.def(a).tags.any(func(t): return CardDB.def(b).tags.has(t)): continue
   var cid: String = "COMPILED::" + a + "::" + b
   if FriendlyCard.glow_rules_size(g.card_text(cid), rect.size, barlow_bold) > 0:
    tally["compiled on face"] += 1
    continue
   var names: String = CardDB.def(a).name.to_upper() + "\nTHEN\n" + CardDB.def(b).name.to_upper()
   if FriendlyCard.glow_rules_size(names, rect.size, barlow_bold, true) == 0:
    fail(cid + ": component names do not fit the face at 9 px")
   tally["compiled names + hover"] += 1
 for id in CardDB.DEFS:
  var d := CardDB.def(id)
  var corp: bool = d.type == "BLOATWARE"
  var stamp := " · ".join([d.type] + ([view.skin.corporation] if corp else Array(d.tags)))
  var font: Font = view.skin.font if corp else routed
  if font.get_string_size(stamp, HORIZONTAL_ALIGNMENT_LEFT, -1, FriendlyCard.PCB_TYPE_MIN).x > FriendlyCard.glow_layout(d.type).type.size.x:
   fail(id + ": type stamp does not fit one line")
 # Corner icons: at most four, so the stack ends above the type plate on every card.
 var most := 0
 var corner_ids: Array = CardDB.DEFS.keys()
 for a in ids:
  if CardDB.def(a).type != "SCRIPT": continue
  for b in ids:
   if a != b and CardDB.def(b).type == "SCRIPT" and CardDB.def(a).tags.any(func(t): return CardDB.def(b).tags.has(t)):
    corner_ids.append("COMPILED::" + a + "::" + b)
 for cid in corner_ids:
  var n := FriendlyCard.corner_icons(CardDB.def(cid)).size()
  most = maxi(most, n)
  if n > 4:
   fail(cid + ": more than four corner icons")
 tally["most corner icons"] = most
 print("CARDS-003 text-fit sweep: %s" % str(tally))

func check_card(card: FriendlyCard, face: String, uid: int, g: Game) -> void:
 var body := card.body
 var d := CardDB.def(face)
 var mask: Color = FriendlyCard.glow_mask(d.type)
 var lay: Dictionary = FriendlyCard.glow_layout(d.type)
 var tag := face + (" uid %d" % uid if uid >= 0 else "")

 # Rarity lamp: Rustler commons, uncommons and rares only; 1/2/3 lit cells.
 var rarity: String = d.rarity
 if FriendlyCard.RarityLight.LAMPS.has(rarity):
  var lamp: Control = body.get_node_or_null("TopRarityLight")
  if lamp == null or lamp.tier != rarity or lamp.lit_cells() != {"COMMON": 1, "UNCOMMON": 2, "RARE": 3}[rarity]:
   fail(tag + ": rarity lamp mismatch")
 if body.has_node("RarityFinish"):
  fail(tag + ": printed rarity finish still present")

 # Each Rustler type has its own circuit stencil; BLOATWARE keeps its corporate art.
 var stencil: Control = body.get_node_or_null("CircuitStencil")
 if d.type == "BLOATWARE":
  if stencil != null:
   fail(tag + ": corporate card should not carry a Rustler stencil")
 elif stencil == null or stencil.kind != d.type or stencil.get_rect() != lay.art:
  fail(tag + ": stencil missing, wrong type or moved")
 var graft: String = g._find(g.run_deck, uid).get("graft", "")
 if graft in Game.GRAFT_PARTS:
  var art: Control = body.get_node_or_null(graft)
  if art == null or stencil.visible or art.get_rect() != lay.art:
   fail(tag + ": graft art missing or the stencil still shows")

 # Rules panel: per-type rect, size floor, centred, bold numbers.
 var frame: Control = body.get_node("SolderRulesFrame")
 var rules: RichTextLabel = frame.get_node("CenteredRules")
 var bounds := Rect2(Vector2.ZERO, frame.size).grow(-FriendlyCard.PCB_RULES_INSET)
 if frame.has_node("PanelFooter"):
  bounds.size.y -= FriendlyCard.FOOTER_H
  var foot: Label = frame.get_node("PanelFooter")
  var ink_bottom := foot.get_rect().get_center().y + foot.get_theme_font("font").get_height(foot.get_theme_font_size("font_size")) / 2.0
  if ink_bottom > frame.size.y - 4:
   fail(tag + ": footer line touches the plated pads on the panel edge")
 if frame.get_rect() != lay.rules or frame.fill != mask:
  fail(tag + ": rules panel moved or not on the type's mask")
 if rules.get_theme_font_size("normal_font_size") < FriendlyCard.PCB_RULES_MIN:
  fail(tag + ": rules below the size floor")
 if rules.get_content_height() > bounds.size.y + 0.5 or not bounds.grow(0.5).encloses(rules.get_rect()):
  fail(tag + ": rules overflow the panel")
 if absf(rules.get_rect().get_center().y - bounds.get_center().y) > 0.5:
  fail(tag + ": rules not vertically centred")
 var digits := RegEx.new(); digits.compile("[0-9]")
 if card.summary_rules:
  # Too long for the face: it names the component cards, and hover holds the full text.
  for part in d.compiled:
   if not rules.text.contains(CardDB.def(part).name.to_upper()):
    fail(tag + ": face does not name " + part)
  if not frame.has_node("PanelFooter") or card.full_rules == null or "\n" + g.card_text(face) in card.tooltip_text:
   fail(tag + ": hover hint or full-rules panel missing")
 elif digits.search(g.card_text(face)) and not rules.text.contains("[b]"):
  fail(tag + ": numbers not set in bold")

 # Title and type plate on the mask, in glowing ivory.
 var title_panel: Control = body.get_node("TitlePanel")
 if title_panel.get_rect() != lay.title or title_panel.fill != mask:
  fail(tag + ": title panel moved or not on the mask")
 var title_ok := false
 for child in body.get_children():
  if child is Label and child.text == d.name.to_upper():
   title_ok = child.get_theme_color("font_color") == FriendlyCard.PCB_GLOW_INK and lay.title.encloses(child.get_rect())
 if not title_ok:
  fail(tag + ": title is not glowing ivory inside its panel")
 var stamp: Label = body.get_node("TypeStamp")
 var plate: Control = body.get_node("TypePlate")
 if stamp.get_line_count() != 1 or stamp.get_theme_font_size("font_size") < FriendlyCard.PCB_TYPE_MIN or stamp.get_theme_color("font_color") != FriendlyCard.PCB_GLOW_INK:
  fail(tag + ": type stamp wraps, is too small or is not ivory")
 if plate.fill != mask or plate.pads or plate.get_rect().end.y > lay.rules.position.y - 1:
  fail(tag + ": type plate wrong or touching the rules panel")
 for ink in [FriendlyCard.PCB_GLOW_INK, FriendlyCard.PCB_GLOW_NUMBER, FriendlyCard.FOOTER_INK]:
  if contrast(ink, mask) < 4.5:
   fail(tag + ": an ink is below 4.5:1 on the mask")

 # Corner icons: the right set, in order, inside the card, clear of every text panel.
 var expected := FriendlyCard.corner_icons(d)
 var chips := []
 for child in body.get_children():
  if child is FriendlyCard.CornerChip:
   chips.append(child)
 if chips.size() != expected.size():
  fail(tag + ": expected %d corner icons, found %d" % [expected.size(), chips.size()])
 else:
  for i in chips.size():
   if chips[i].kind != expected[i][0] or chips[i].value != expected[i][1]:
    fail(tag + ": corner icon %d is %s, expected %s" % [i, chips[i].kind, expected[i][0]])
   if not Rect2(Vector2(-12, -14), Vector2(190, 270)).encloses(chips[i].get_rect()):
    fail(tag + ": corner icon outside the cartridge")
   for panel in ["TitlePanel", "TypePlate", "SolderRulesFrame"]:
    if body.get_node(panel).get_rect().intersects(chips[i].get_rect()):
     fail(tag + ": corner icon crosses " + panel)
   if contrast(chips[i].ink(), FriendlyCard.CornerChip.PLATE) < 4.5:
    fail(tag + ": corner icon ink below 4.5:1")
  if not chips.is_empty() and not FriendlyCard.corner_legend(expected) in card.tooltip_text:
   fail(tag + ": tooltip does not explain the corner icons")

 # Cached: never printed; one cyan edge glow, the same for a temporary cache.
 for child in body.find_children("*", "Label", true, false) + body.find_children("*", "RichTextLabel", true, false):
  if "CACHED" in child.text:
   fail(tag + ": CACHED printed on the card face")
 var entry: Dictionary = g._find(g.hand, uid)
 var is_cached: bool = entry.get("cached", false)
 if body.has_node("CacheBadge") or body.has_node("CacheEdgeGlow") != is_cached:
  fail(tag + ": cache glow presence mismatch, or a leftover padlock")
 if is_cached:
  var edge: Control = body.get_node("CacheEdgeGlow")
  if edge.get_rect() != lay.edge:
   fail(tag + ": cache glow not on the type's edge")
  for child in body.get_children():
   if child is FriendlyCard.CostCircle and child.get_index() < edge.get_index():
    fail(tag + ": cache glow draws over the BW cost")
  var inner := edge.get_rect().grow(-2.0)
  for panel in ["TitlePanel", "TypePlate", "SolderRulesFrame"]:
   if not inner.encloses(body.get_node(panel).get_rect()):
    fail(tag + ": cache glow crosses " + panel)
  if not "CACHED" in card.tooltip_text:
   fail(tag + ": tooltip does not name the cached state")

func luminance(c: Color) -> float:
 var ch := [c.r, c.g, c.b]
 for i in 3:
  ch[i] = ch[i] / 12.92 if ch[i] <= 0.03928 else pow((ch[i] + 0.055) / 1.055, 2.4)
 return 0.2126 * ch[0] + 0.7152 * ch[1] + 0.0722 * ch[2]

func contrast(a: Color, b: Color) -> float:
 var la := luminance(a); var lb := luminance(b)
 return (maxf(la, lb) + 0.05) / (minf(la, lb) + 0.05)

## A long compiled card at hand size with its full-rules hover panel showing.
func hover_capture(main: Node, g: Game) -> void:
 var surface := SubViewport.new()
 surface.size = Vector2i(420, 520)
 surface.render_target_update_mode = SubViewport.UPDATE_ALWAYS
 root.add_child(surface)
 var backdrop := ColorRect.new(); backdrop.color = Color("#E6EEEA"); backdrop.size = Vector2(surface.size); surface.add_child(backdrop)
 var id := "COMPILED::SHATTER::BORROWED_CREDENTIALS"
 var card := FriendlyCard.new()
 card.setup(main.friendly, id, -1)
 card.position = Vector2(128, 262)
 surface.add_child(card)
 for step in range(3):
  await process_frame
 card.show_full_rules()
 for step in range(4):
  await process_frame
 await RenderingServer.frame_post_draw
 var panel: Control = card.full_rules
 var rules: RichTextLabel = panel.get_node("CenteredRules")
 var shown := Rect2(panel.global_position, panel.size)
 if not panel.visible or not rules.text.contains("SLEDGE") or not rules.text.contains("HUSH"):
  fail("hover panel hidden or missing the full text")
 if rules.get_content_height() > panel.size.y - FriendlyCard.PCB_RULES_INSET * 2 + 0.5:
  fail("hover panel text overflows")
 if not Rect2(Vector2.ZERO, Vector2(surface.size)).encloses(shown) or shown.end.y > card.get_global_rect().position.y:
  fail("hover panel off screen or covering the card")
 var suffix := "" if OS.get_environment("CARD_SHOT_SCALE") in ["", "3"] else "_1x"
 if surface.get_texture().get_image().save_png(OS.get_environment("SHOT_DIR").path_join("SCRIPT_COMPILED_HOVER" + suffix + ".png")) != OK:
  fail("could not save hover capture")
 card.full_rules.visible = false
 surface.queue_free()
