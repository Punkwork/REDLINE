extends SceneTree
## CSA-04 (CONSISTENCY-001a): the canonical card records reach their consumers.
## e: the Universal Object Inspector content contract (CardDB.inspector_model; CSA T3).
## g: the Black Market Uplink contract (UplinkContract): services and Clinic (Core Rules §8.3), card
##    eligibility (BASIC-001), base prices (UPL-008, UPL-002) and shelf shape (UPLINK-SPEC-001).
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
	test_uplink_contract()
	test_card_art()
	test_templates()
	print("CSA-04 CONSUMERS: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

func test_inspector_model() -> void:
	var im := CardDB.inspector_model("PROBE")
	check(im.rules == PROBE_004A, "T3: inspector_model(PROBE).rules is the approved PROBE-004a text")
	check(im.name == "PROBE" and im.classification == "SCRIPT · EXPLOIT" and im.costs.bw == 0, "contract: name, classification, cost")
	check(im.flavour == "The deeper you probe, the costlier it gets." and String(im.art).ends_with("PROBE.png"), "contract: flavour and art")
	# Propagation (T1/T3): a change to the canonical record changes what the Inspector says.
	# CSA T1: the number lives once, in the record; the text, the engine parameter and the Inspector follow it.
	var copy: Dictionary = CardDB.RECORDS.duplicate(true)
	copy.PROBE.modes[0].params.amount = 3
	check(CardDB.param("PROBE", "modes.weaken.amount", copy) == 3 and CardDB.param("PROBE", "modes.weaken.amount") == 2, "T1: param() reads the record (copy 3, live 2)")
	check(CardDB.rules_text("PROBE", copy).contains("−3 STR") and not CardDB.rules_text("PROBE", copy).contains("−2"), "T1: the rules text follows the record")
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

func test_uplink_contract() -> void:
	# Core Rules §8.3 (NODE-AUTHORITY-001): cards, CAPS, Ghostware and the Clinic; never removal or VITAE.
	for s in ["CARDS", "CAPS", "GHOSTWARE", "CLINIC"]: check(UplinkContract.offers(s), "Uplink offers %s (§8.3)" % s)
	for s in ["CARD_REMOVAL", "VITAE", "REFACTOR", "PATCHWORK", "FUSE"]: check(not UplinkContract.offers(s), "Uplink never offers %s (§8.3)" % s)
	check(UplinkContract.CLINIC_REMOVES == "CORTEX", "the Clinic removes CORTEX only (§8.3)")
	# CLINIC-001: 30 per counter; 25% off for 2 or more, rounded up: 2 = 45, 3 = 68, 4 = 90.
	var clinic := {1: 30, 2: 45, 3: 68, 4: 90}
	for n in clinic: check(UplinkContract.clinic_price(n) == clinic[n], "Clinic: %d CORTEX costs %d CRED (CLINIC-001)" % [n, clinic[n]])
	# UPL-008: 40 / 60 / 90 CRED by rarity.
	var prices := {"COMMON": 40, "UNCOMMON": 60, "RARE": 90}
	for r in prices:
		var ids := CardDB.reward_pool("SHARED", r)
		check(not ids.is_empty() and ids.all(func(id): return UplinkContract.card_base_price(id) == prices[r]), "%s cards cost %d CRED (UPL-008)" % [r, prices[r]])
	# UPL-002 / CAPS-TEST-001: common CAPS cost 20 CRED.
	check(UplinkContract.cap_pool("COMMON").all(func(id): return UplinkContract.cap_base_price(id) == 20), "common CAPS cost 20 CRED (UPL-002)")
	# UPLINK-SPEC-001: eight cards, exactly 5 common / 2 uncommon / 1 rare, 6 shared / 2 Rustler, one at half price.
	var shelf := UplinkContract.card_shelf()
	check(shelf.size == 8 and shelf.rarity == {"COMMON": 5, "UNCOMMON": 2, "RARE": 1} and shelf.shared == 6 and shelf.rustler == 2, "card shelf: 8 cards, 5/2/1, 6 shared + 2 Rustler (UPLINK-SPEC-001)")
	check(shelf.on_sale == 1 and shelf.sale_percent_off == 50, "one card at half price (UPLINK-SPEC-001)")
	# BASIC-001: starter and basic cards are never sold; nor are pending or experimental cards.
	var sold := {}
	for r in ["GENERALIST", "ECHO", "RIOT", "VECTOR"]:
		for rar in ["COMMON", "UNCOMMON", "RARE"]:
			var pool := UplinkContract.card_pool(r, rar)
			for id in pool.shared + pool.rustler: sold[id] = true
	var starters := []
	for deck in [CardDB.STARTER_GENERALIST, CardDB.STARTER_ECHO, CardDB.STARTER_RIOT, CardDB.STARTER_VECTOR]: starters += deck
	check(starters.all(func(id): return not sold.has(id)), "no starter or basic card is ever on the shelf (BASIC-001)")
	check(not sold.has("KEYLOGGER") and not sold.has("STASH") and not sold.has("MINIMALIST"), "pending and experimental cards are never on the shelf")
	# Propagation: a change to the canonical price table reaches the contract.
	var copy: Dictionary = CardDB.DATA.duplicate(true)
	copy.uplink.card_prices.COMMON = 55
	var common_id: String = CardDB.reward_pool("SHARED", "COMMON")[0]
	check(UplinkContract.card_base_price(common_id, copy) == 55 and UplinkContract.card_base_price(common_id) == 40, "a canonical price change reaches the contract; the live data is untouched")
	# UPLINK-SPEC-001: no silent relaxation; shortfalls are reported, not filled.
	for r in ["GENERALIST", "ECHO", "RIOT", "VECTOR"]:
		var short := UplinkContract.stock_shortfalls(r)
		print("  Uplink stock check %s: %s" % [r, "OK" if short.is_empty() else "; ".join(short)])
	check(UplinkContract.stock_shortfalls("GENERALIST").is_empty(), "the current build can always stock a GENERALIST Uplink")


## CARD-ART-001: imported card art is JPEG 600x520; the lookup prefers it; every art file names a real card.
func test_card_art() -> void:
	check(CardDB.art_path("PROBE").ends_with("PROBE.png"), "PNG art is still found where no JPEG exists")
	check(CardDB.art_path("BRUTE_FORCE").ends_with("BRUTE_FORCE.jpg"), "JPEG art is preferred")
	check(CardDB.inspector_model("HUSH").art == CardDB.art_path("HUSH"), "the inspector contract uses the art lookup")
	var dir := "res://assets/concept/cards/"
	var jpgs := 0
	var bad := []
	for f in DirAccess.get_files_at(dir):
		if not (f.ends_with(".jpg") or f.ends_with(".png")) or f.begins_with("CARD_FRAME_"): continue
		var id := f.get_basename()
		if not CardDB.DEFS.has(id): bad.append(f)
		if f.ends_with(".jpg"):
			jpgs += 1
			var t: Texture2D = load(dir + f)
			if t == null or t.get_size() != Vector2(600, 520): bad.append(f + " size")
	check(bad.is_empty(), "every card art file names a card and JPEGs are 600x520 (%s)" % [bad])
	check(jpgs == 83, "83 imported JPEG card images (got %d)" % jpgs)
	var with_art := 0
	for id in CardDB.DEFS:
		if ResourceLoader.exists(CardDB.art_path(id)): with_art += 1
	print("  card art coverage: %d of %d cards" % [with_art, CardDB.DEFS.size()])
	check(with_art >= 93, "art coverage did not shrink (%d cards)" % with_art)

## CSA-04i/j: templates render to finished text; engine parameters resolve; the gap is declared.
func test_templates() -> void:
	var raw := []
	var off := []
	for id in CardDB.RECORDS:
		var d: Dictionary = CardDB.RECORDS[id]
		if String(d.text).contains("{") or d.get("modes", []).any(func(m): return String(m.label).contains("{")): raw.append(id)
		if CardDB.rules_text(id) != String(d.text): off.append(id)
	check(raw.is_empty(), "no card shows a raw {placeholder} (%s)" % [raw])
	check(off.is_empty(), "rules_text() equals the loaded text for every record (%s)" % [off])
	check(CardDB.def("BRUTE_FORCE").text == "Break 1 subroutine on any ICE with STR 4 or less. (+4 TRACE)", "a templated card reads exactly as approved (BRUTE FORCE)")
	check(CardDB.def("SKIMMER").text == "When installed: extract 4 CRED. End of your turn: extract 4 CRED.", "two fields with the same value render in place (SKIMMER)")
	check(String(CardDB.RECORDS.PROBE.modes[0].label) == "−2 STR this encounter", "PROBE's mode label renders from its params")
	check(CardDB.RECORDS.PULP_SHIELD.text_template == "+{shield} SHIELD.", "the template is kept for tools and tests")
	# Every CardDB.param("ID", "path") in the scripts resolves against the live record.
	var re := RegEx.create_from_string("CardDB\\.param\\(\"([A-Z_]+)\", \"([A-Za-z_.]+)\"")
	var calls := 0
	var bad := []
	for f in ["res://scripts/core/game.gd", "res://scripts/ui/architecture_v2/ice_encounter_sandbox.gd"]:
		for m in re.search_all(FileAccess.get_file_as_string(f)):
			calls += 1
			if CardDB.resolve(CardDB.RECORDS.get(m.get_string(1), {}), m.get_string(2)) == null: bad.append(m.get_string(0))
	check(calls >= 30 and bad.is_empty(), "%d engine parameter reads, all resolve (%s)" % [calls, bad])
	var in_code := CardDB.RECORDS.keys().filter(func(id): return CardDB.RECORDS[id].get("params_in_code", false))
	print("  numbers still in code (params_in_code): %d of %d records" % [in_code.size(), CardDB.RECORDS.size()])
