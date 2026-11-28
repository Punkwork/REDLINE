extends SceneTree
## CSA-04 (CONSISTENCY-001a): the canonical card records reach their consumers.
## e: the Universal Object Inspector content contract (CardDB.inspector_model; CSA T3).
## Expectations that describe approved design are literals tagged with their decision IDs, never read
## back from cards.json; propagation is proven on a modified copy of the records, never the live file.

var passed := 0
var failed := 0

## PROBE-004a approved text (Master Design), the literal the contract must carry.
const PROBE_004A := "Choose one: Target ICE: −2 STR this encounter. OR Target VOID: Reveal all hidden subroutines. Costs 1 additional BW for each PROBE already played on the target ICE this turn."

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	test_inspector_model()
	await test_inspector_consumers()
	print("CSA-04 CONSUMERS: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

func test_inspector_model() -> void:
	var im := CardDB.inspector_model("PROBE")
	check(im.rules == PROBE_004A, "T3: inspector_model(PROBE).rules is the approved PROBE-004a text")
	check(im.name == "PROBE" and im.classification == "SCRIPT · EXPLOIT" and im.costs.bw == 0, "contract: name, classification, cost")
	check(im.flavour == "The deeper you probe, the costlier it gets." and String(im.art).ends_with("PROBE.png"), "contract: flavour and art")
	# Propagation (T1/T3): a change to the canonical record changes what the Inspector says.
	var copy: Dictionary = CardDB.RECORDS.duplicate(true)
	copy.PROBE.text = String(copy.PROBE.text).replace("−2", "−3")
	copy.PROBE.bw = 5
	copy.PROBE.flavor = "changed"
	var changed := CardDB.inspector_model("PROBE", copy)
	check(changed.rules.contains("−3 STR") and changed.costs.bw == 5 and changed.flavour == "changed", "a canonical change reaches the Inspector contract")
	check(CardDB.inspector_model("PROBE").rules == PROBE_004A, "the live record is untouched by the test copy")
	# Every live card has a complete contract.
	var missing := []
	for id in CardDB.DEFS:
		var m := CardDB.inspector_model(id)
		if m.name == "" or m.classification == "" or m.rules == "": missing.append(id)
	check(missing.is_empty(), "every card has a name, classification and rules text (%s)" % [missing])

func test_inspector_consumers() -> void:
	# The V2 card model takes its static fields from the contract (consumer coverage).
	var g := Game.new(5); g.new_run("GENERALIST")
	var off := []
	for id in CardDB.DEFS:
		var inst := {"uid": 1, "id": id}
		var m := VisibleStateAdapter.card_model(g, inst, "pick")
		var im := CardDB.inspector_model(id)
		if m.name != im.name or m.classification != im.classification or m.bw != im.costs.bw or m.cred != im.costs.cred \
				or m.trace != im.costs.trace or m.flavor != im.flavour or m.art != im.art:
			off.append(id)
	check(off.is_empty(), "V2 card model equals the contract for every card (%d cards; off: %s)" % [CardDB.DEFS.size(), off])
	# The shared inspector shows the contract's classification and rules for a hovered card.
	var k := KeyInspector.new(); root.add_child(k)
	var cv := CardView.new(); root.add_child(cv)
	cv.set_model(VisibleStateAdapter.card_model(g, {"uid": 2, "id": "PROBE"}, "pick"))
	cv.position = Vector2(400, 400)
	cv.grab_focus()
	k.show_card(cv)
	var words := k.find_children("*", "Label", true, false).map(func(l): return String(l.text))
	check(words.has("SCRIPT · EXPLOIT") and words.has(PROBE_004A), "the inspector shows the contract's classification and rules")
	k.queue_free(); cv.queue_free()
	for i in 2: await process_frame
