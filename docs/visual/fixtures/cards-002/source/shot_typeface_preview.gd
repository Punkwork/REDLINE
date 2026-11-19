extends SceneTree
## CARDS-002 mustard PCB preview fixture. PREVIEW_SCALE (default 3) sets the
## capture scale; 1 renders at hand size.

const FACES := ["DEEP_PROBE", "STRESS_TEST", "NULL_POINTER"]
const BOARD_LEFT := 7.0
const MIN_GAP := 3.0

var failures := 0

func _initialize() -> void:
 call_deferred("run")

func fail(message: String) -> void:
 push_error(message)
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

 sweep_text_fit(g)

 # Cached copies in hand: one held indefinitely, one temporary with 2 turns left.
 g.hand.append({"uid": 9001, "id": "DEEP_PROBE", "cached": true})
 g.hand.append({"uid": 9002, "id": "STRESS_TEST", "cached": true, "cache_turns": 2})

 var scale := maxf(1.0, float(OS.get_environment("PREVIEW_SCALE"))) if OS.get_environment("PREVIEW_SCALE") != "" else 3.0
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
  ["DEEP_PROBE", -1, "DEEP_PROBE"],
  ["STRESS_TEST", -1, "STRESS_TEST"],
  ["NULL_POINTER", -1, "NULL_POINTER"],
  ["DEEP_PROBE", 9001, "DEEP_PROBE_CACHED"],
  ["STRESS_TEST", 9002, "STRESS_TEST_CACHED_TEMP"],
  ["NULL_POINTER", -1, "LONGEST_RULES_STRESS"],
 ]
 for shot in shots:
  var card := FriendlyCard.new()
  card.setup(main.friendly, shot[0], shot[1])
  if shot[2] == "LONGEST_RULES_STRESS":
   # Swap in the longest rules text in the card pool to show the size floor.
   var longest := longest_rule(g)
   var old := card.body.get_node("SolderRulesFrame")
   card.body.remove_child(old)
   old.free()
   card.body.add_child(FriendlyCard.build_mustard_rules(longest))
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
 await process_frame
 print("CARDS-002 preview checks: %d failure(s)" % failures)
 quit(1 if failures else 0)

func longest_rule(g: Game) -> String:
 var best := ""
 for id in CardDB.DEFS:
  var t: String = g.card_text(id)
  if t.length() > best.length():
   best = t
 return best

## Every card's rules (with AMP 0 to 3) must fit the fixed frame at 9 px or
## larger, and every Rustler type stamp must fit one line at 8 px or larger.
func sweep_text_fit(g: Game) -> void:
 var saved_amp: int = g.amp
 var font: Font = preload("res://assets/fonts/Preview-RoutedGothic.ttf")
 var checked := 0
 for amp in range(4):
  g.amp = amp
  for id in CardDB.DEFS:
   var rule: String = g.card_text(id)
   if FriendlyCard.mustard_rules_size(rule) < FriendlyCard.MUSTARD_RULES_MIN:
    fail("%s (AMP %d): rules do not fit the frame at %d px" % [id, amp, FriendlyCard.MUSTARD_RULES_MIN])
   checked += 1
 g.amp = saved_amp
 for id in CardDB.DEFS:
  var d := CardDB.def(id)
  if d.type == "BLOATWARE":
   continue
  var stamp := " · ".join([d.type] + Array(d.tags))
  if font.get_string_size(stamp, HORIZONTAL_ALIGNMENT_LEFT, -1, FriendlyCard.MUSTARD_TYPE_MIN).x > FriendlyCard.MUSTARD_TYPE_RECT.size.x:
   fail(id + ": type stamp does not fit one line")
 print("CARDS-002 text-fit sweep: %d rules texts checked" % checked)

func check_card(card: FriendlyCard, face: String, uid: int, g: Game) -> void:
 var body := card.body
 var tag := face + (" uid %d" % uid if uid >= 0 else "")

 # Rarity: lamp tier, position, and lit cell count (1/2/3) so colour is not the only cue.
 var lamp: Control = body.get_node("TopRarityLight")
 var rarity: String = CardDB.def(face).rarity
 if lamp.tier != rarity or lamp.get_rect() != Rect2(63, 6, 37, 8) or body.has_node("RarityFinish"):
  fail(tag + ": rarity indicator mismatch")
 if lamp.lit_cells() != {"COMMON": 1, "UNCOMMON": 2, "RARE": 3}[rarity]:
  fail(tag + ": rarity cell count mismatch")

 # Rules: fixed frame, size floor, centred block inside the inset bounds.
 var frame: Control = body.get_node("SolderRulesFrame")
 var rules: RichTextLabel = frame.get_node("CenteredRules")
 var bounds := Rect2(Vector2.ZERO, frame.size).grow(-FriendlyCard.MUSTARD_RULES_INSET)
 if frame.get_rect() != FriendlyCard.MUSTARD_RULES_RECT:
  fail(tag + ": rules frame moved")
 if rules.get_theme_font_size("normal_font_size") < FriendlyCard.MUSTARD_RULES_MIN:
  fail(tag + ": rules below the size floor")
 if rules.get_content_height() > bounds.size.y + 0.5 or not bounds.grow(0.5).encloses(rules.get_rect()):
  fail(tag + ": rules overflow the frame")
 if absf(rules.get_rect().get_center().y - bounds.get_center().y) > 0.5:
  fail(tag + ": rules not vertically centred")
 if not rules.text.begins_with("[center]"):
  fail(tag + ": rules not horizontally centred")
 var digits := RegEx.new(); digits.compile("[0-9]")
 if digits.search(g.card_text(face)) and not rules.text.contains("[b]"):
  fail(tag + ": numbers not set in bold")

 # Type stamp: one centred line, clear of the stencil above and the frame below.
 var stamp: Label = body.get_node("TypeStamp")
 if stamp.get_line_count() != 1 or stamp.get_theme_font_size("font_size") < FriendlyCard.MUSTARD_TYPE_MIN:
  fail(tag + ": type stamp wraps or is too small")
 var stamp_font: Font = stamp.get_theme_font("font")
 var ink_bottom := stamp.get_rect().get_center().y + stamp_font.get_height(stamp.get_theme_font_size("font_size")) / 2.0
 if ink_bottom + MIN_GAP > FriendlyCard.MUSTARD_RULES_RECT.position.y:
  fail(tag + ": type stamp crowds the rules frame")

 # Glow study: title, type stamp and rules each sit on a dark mask panel,
 # and every ink on that mask clears 4.5:1 (the halo is decoration only).
 for panel in ["TitlePanel", "TypePlate", "SolderRulesFrame"]:
  if not body.has_node(panel) or body.get_node(panel).fill != FriendlyCard.MUSTARD_MASK:
   fail(tag + ": " + panel + " is not on the dark mask")
 for ink in [FriendlyCard.MUSTARD_GLOW_INK, FriendlyCard.MUSTARD_GLOW_NUMBER]:
  if contrast(ink, FriendlyCard.MUSTARD_MASK) < 4.5:
   fail(tag + ": ink below 4.5:1 on the mask")
 var title_ok := false
 for child in body.get_children():
  if child is Label and child.text == CardDB.def(face).name.to_upper():
   title_ok = child.get_theme_color("font_color") == FriendlyCard.MUSTARD_GLOW_INK and FriendlyCard.MUSTARD_TITLE_RECT.encloses(child.get_rect())
 if not title_ok:
  fail(tag + ": title is not glowing ivory inside its panel")
 if stamp.get_theme_color("font_color") != FriendlyCard.MUSTARD_GLOW_INK or rules.get_theme_color("default_color") != FriendlyCard.MUSTARD_GLOW_INK:
  fail(tag + ": stamp or rules not in glowing ivory")
 var plate: Control = body.get_node("TypePlate")
 if plate.pads:
  fail(tag + ": plated pads on the type plate would touch the stamp")
 if plate.get_rect().end.y > FriendlyCard.MUSTARD_RULES_RECT.position.y - 1:
  fail(tag + ": type plate touches the rules panel")

 # Cached: never printed on the face; a badge outside the board instead.
 for child in body.find_children("*", "Label", true, false) + body.find_children("*", "RichTextLabel", true, false):
  if "CACHED" in child.text:
   fail(tag + ": CACHED printed on the card face")
 var entry: Dictionary = g._find(g.hand, uid)
 var is_cached: bool = entry.get("cached", false)
 if body.has_node("CacheBadge") != is_cached or body.has_node("CacheEdgeGlow") != is_cached:
  fail(tag + ": cache badge presence mismatch")
 if is_cached:
  var badge: Control = body.get_node("CacheBadge")
  if badge.get_rect().end.x > BOARD_LEFT or badge.turns != int(entry.get("cache_turns", 0)):
   fail(tag + ": cache badge overlaps the board or shows the wrong turns")
  var edge: Control = body.get_node_or_null("CacheEdgeGlow")
  if edge == null or edge.temporary != entry.has("cache_turns"):
   fail(tag + ": cache edge glow missing or wrong style")
  else:
   # The glow (core plus 2 px halo) must stay outside every text panel.
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
