extends SceneTree
## ARCH-V2-005: before Batch 3, check the Architecture V2 encounter screen against the coverage table
## (godot/tests/arch_v2_coverage.json, rendered to docs/architecture-v2/ENCOUNTER_COVERAGE.md):
## - every prototype element has a row and a valid status, with a next step unless BUILT;
## - every BUILT or PLACEHOLDER row has its node on the V2 screen;
## - the Markdown lists every row with the same status (it is generated, not hand-edited);
## - the header change: turn indicator and TRACE meter at half width, CAPS and PROTOCOLS racks with
##   three slots each, nothing overlapping, everything inside the header bar;
## - PROTOCOL slots follow game.rack through a real play (one controller call), overflow shows "+n",
##   and the screen never changes Game state by drawing it.

const COVERAGE := "res://tests/arch_v2_coverage.json"
var passed := 0
var failed := 0

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(COVERAGE))
	check(data != null and data.has("rows"), "coverage JSON parses")
	var sb: IceEncounterSandbox = load("res://scenes/architecture_v2/IceEncounterSandbox.tscn").instantiate()
	sb.instant = true
	root.size = Vector2i(1600, 1000)
	root.add_child(sb)
	for i in 4: await process_frame
	print("- table")
	test_table(data)
	print("- nodes on screen")
	test_nodes(data, sb)
	print("- markdown in sync")
	test_markdown(data)
	print("- header geometry")
	test_header(sb)
	print("- racks")
	test_racks(sb)
	print("ARCH-V2 COVERAGE: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

func test_table(data: Dictionary) -> void:
	var statuses: Dictionary = data.statuses
	var ids := {}
	for r in data.rows:
		check(not ids.has(r.id), "unique id %s" % r.id)
		ids[r.id] = true
		check(statuses.has(r.status), "%s has a known status (%s)" % [r.id, r.status])
		check(String(r.element) != "" and String(r.prototype) != "", "%s names the element and its prototype source" % r.id)
		if r.status != "BUILT":
			check(String(r.next) != "", "%s (%s) says what happens next" % [r.id, r.status])
		if r.status in ["BUILT", "PLACEHOLDER"]:
			check(String(r.v2) != "", "%s (%s) names its V2 node" % [r.id, r.status])
	# The two header racks the designer asked for are in the table.
	var by_v2 := {}
	for r in data.rows: by_v2[String(r.v2)] = r
	check(by_v2.has("CapRack") and by_v2.has("ProtocolRack"), "CAPS and PROTOCOLS racks are rows in the table")

func test_nodes(data: Dictionary, sb: IceEncounterSandbox) -> void:
	for r in data.rows:
		if not (r.status in ["BUILT", "PLACEHOLDER"]): continue
		var n := sb.find_child(String(r.v2), true, false)
		check(n != null, "%s %s: node %s is on the V2 screen" % [r.id, r.element, r.v2])

func test_markdown(data: Dictionary) -> void:
	var path := ProjectSettings.globalize_path("res://").path_join("../docs/architecture-v2/ENCOUNTER_COVERAGE.md").simplify_path()
	var md := FileAccess.get_file_as_string(path)
	check(md != "", "ENCOUNTER_COVERAGE.md exists (run tools/arch_v2_coverage_md.py)")
	for r in data.rows:
		check(md.contains("| %s | %s |" % [r.id, r.element]) and md.contains("| %s |" % r.status),
			"%s listed in ENCOUNTER_COVERAGE.md" % r.id)
		var line := ""
		for l in md.split("\n"):
			if l.begins_with("| %s |" % r.id): line = l
		check(line.contains("| %s |" % r.status), "%s status matches in ENCOUNTER_COVERAGE.md" % r.id)

func test_header(sb: IceEncounterSandbox) -> void:
	check(is_equal_approx(IceEncounterSandbox.PHASE.size.x, 252.0 / 2.0), "turn indicator is half its former width")
	check(is_equal_approx(IceEncounterSandbox.TRACE.size.x, 230.0 / 2.0), "TRACE meter is half its former width")
	var names := ["Logo", "TurnIcon", "Turn", "Phase", "Trace", "CapRack", "ProtocolRack", "AdPlate"]
	var rects := []
	for n in names:
		var c: Control = sb.stage.find_child(n, false, false)
		check(c != null, "header part %s exists" % n)
		if c == null: continue
		var r := Rect2(c.position, c.size)
		check(IceEncounterSandbox.HEADER.encloses(r), "%s sits inside the header bar" % n)
		rects.append([n, r])
	for a in rects.size():
		for b in range(a + 1, rects.size()):
			check(not rects[a][1].intersects(rects[b][1]), "%s and %s do not overlap" % [rects[a][0], rects[b][0]])
	# Left to right: turn, phase, TRACE, CAPS, PROTOCOLS, ad.
	var order := ["Turn", "Phase", "Trace", "CapRack", "ProtocolRack", "AdPlate"]
	for k in order.size() - 1:
		var l: Control = sb.stage.find_child(order[k], false, false)
		var r: Control = sb.stage.find_child(order[k + 1], false, false)
		if l and r: check(l.position.x < r.position.x, "%s is left of %s" % [order[k], order[k + 1]])

func test_racks(sb: IceEncounterSandbox) -> void:
	var g := sb.game
	check(sb.cap_rack.slots.size() == 3, "3 CAP slots")
	check(sb.protocol_rack.slots.size() == 3, "3 PROTOCOL slots")
	check(sb.cap_rack.filled() == 0, "CAP slots empty (no CAPS inventory in the engine yet)")
	check(sb.protocol_rack.filled() == 0, "PROTOCOL slots empty at the start of the Node")
	check(sb.cap_rack.slots[0].title == "EMPTY CAP SLOT", "empty CAP slot explains itself on hover")
	for s in sb.cap_rack.slots + sb.protocol_rack.slots:
		## Size follows the delivered rack art (ARCH-V2-005d): sockets are about 37 × 41 reference px.
		check(s.focus_mode == Control.FOCUS_ALL and s.size.x >= 34.0 and s.size.y >= 38.0, "%s is focusable and at least 34 × 38 px" % s.name)
	# Deploy PROTOCOLs through the controller, one call each; the rack follows game.rack.
	var ids := ["SPAM_FILTER", "PROXY_CHAIN", "TOOLBELT", "SURGE_PROTECTOR"]
	for k in ids.size():
		var c := {"uid": g.next_uid, "id": ids[k]}
		g.next_uid += 1
		g.hand.append(c)
		g.bw = 30
		var ok := sb.ctrl.request_play(int(c.uid))
		check(ok, "%s deploys" % ids[k])
		sb.refresh()
		check(g.rack.size() == k + 1, "game.rack holds %d" % (k + 1))
		var shown := mini(k + 1, 3)
		check(sb.protocol_rack.filled() == shown, "%d PROTOCOL slot(s) filled" % shown)
		for i in shown:
			check(String(sb.protocol_rack.slots[i].item.get("id", "")) == String(g.rack[i].id), "slot %d shows rack[%d]" % [i, i])
	var last: HudWidgets.RackSlot = sb.protocol_rack.slots[2]
	check(last.overflow.size() == 1 and String(last.overflow[0].id) == "SURGE_PROTECTOR", "4th PROTOCOL shows as +1 on the last slot")
	check(last.lines.any(func(l): return String(l).contains("SURGE PROTECTOR")), "+1 slot's hover names the extra PROTOCOL")
	check(sb.protocol_rack.slots[0].title == "SPAM FILTER", "filled slot's hover shows the card name")
	# Drawing never changes state.
	var before := [g.rack.size(), g.bw, g.hand.size(), g.trace]
	for i in 3: sb.refresh()
	check([g.rack.size(), g.bw, g.hand.size(), g.trace] == before, "refresh does not change Game")
	# Node end returns PROTOCOLs to the deck (Core Rules §3): the slots empty with the rack.
	g.rack.clear()
	sb.refresh()
	check(sb.protocol_rack.filled() == 0 and sb.protocol_rack.slots[2].overflow.is_empty(), "slots empty when the rack empties")
