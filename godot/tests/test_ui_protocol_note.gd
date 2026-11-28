extends SceneTree
## UI-PROTOCOL-001 (designer 2026-11-28, issue #26): the Active Protocol display on the V2 encounter
## screen. Approved: the paperclip note (V2_NOTE_CARD) shows one icon per active Protocol, no inline
## words, no slot limit; it scrolls vertically when the icons outgrow it and every Protocol stays
## reachable; hover/focus opens the shared inspector (UI-INSPECTOR-001) with the canonical card content;
## it is drawn from the engine's RACK, updates at once and empties when the encounter ends. The three
## header PROTOCOL slots are superseded; CAP slots, the Ghostware reel and the Program CRT are unchanged.

var passed := 0
var failed := 0
var sb: IceEncounterSandbox

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	call_deferred("run")

func frames(n := 3) -> void:
	for i in n: await process_frame

func run() -> void:
	root.size = Vector2i(1600, 1000)
	sb = load("res://scenes/architecture_v2/IceEncounterSandbox.tscn").instantiate()
	sb.instant = true
	root.add_child(sb)
	await frames(4)
	var g := sb.game
	var note := sb.protocol_note
	var adjacent := {}
	for n in ["CapRack", "GhostReel", "RigBay", "HandFan", "Counters", "MeterVITAE", "EndTurn"]:
		var c: Control = sb.stage.find_child(n, true, false)
		if c: adjacent[n] = Rect2(c.position, c.size)
	# --- zero ---
	check(note != null and note.name == "ProtocolNote", "the Active Protocol note is on the screen")
	check(note.count() == 0 and not note.overflowing(), "zero active Protocols: an empty note")
	check(Rect2(note.position, note.size) == IceEncounterSandbox.NOTE, "the note keeps the paperclip card's place")
	check(note.find_children("*", "Label", true, false).is_empty(), "no inline words on the note")
	# --- one, deployed through the controller: the note follows without an explicit refresh ---
	var first := deploy(g, "REACTIVE_ARMOUR")
	await frames()
	check(note.count() == 1, "one active Protocol: one icon, at once")
	await inspect_check(note.icons[0], "REACTIVE ARMOUR", "Whenever you play a card, gain 1 SHIELD.")
	# --- several, including two copies (not grouped: grouping is unapproved) ---
	for id in ["COUNTERINTELLIGENCE", "OVERCLOCK", "REACTIVE_ARMOUR", "SURGE_PROTECTOR"]: deploy(g, id)
	await frames()
	check(note.count() == 5 and not note.overflowing(), "five active Protocols fit on the note")
	check(order_matches(g), "icons follow game.rack's order, one per card (two REACTIVE ARMOURs, two icons)")
	# --- overflow ---
	var ids := ["FEEDBACK_LOOP", "SALVAGE", "ADAPTIVE_DEFENCE", "PROXY_CHAIN", "TOOLBELT", "SPAM_FILTER", "READY_STANCE"]
	for k in 18: deploy(g, ids[k % ids.size()])
	await frames(4)
	check(note.count() == 23 and g.rack.size() == 23, "23 active Protocols, 23 icons: no limit")
	check(order_matches(g), "still one icon per card, in order")
	check(note.overflowing(), "the icons outgrow the paper")
	check(note.scroll.get_v_scroll_bar().visible, "a vertical scroll bar appears")
	# Every icon reachable: focus each in turn; the note scrolls it into view; the inspector names it.
	var unreachable := []
	var wrong := []
	for k in note.icons.size():
		var ic: Control = note.icons[k]
		ic.grab_focus()
		await frames(2)
		var view := note.scroll.get_global_rect().grow(0.5)
		if not view.encloses(ic.get_global_rect()): unreachable.append(k)
		var words := words_of(sb.inspector)
		var d := CardDB.def(String(g.rack[k].id))
		if not (sb.inspector.visible and words.has(String(d.name).to_upper()) or words.has(String(d.name))) or not words.has(String(d.text)): wrong.append(k)
	check(unreachable.is_empty(), "every icon scrolls into view when focused (%s)" % [unreachable])
	check(wrong.is_empty(), "every icon opens the inspector with its own name and rules (%s)" % [wrong])
	note.icons[0].release_focus()
	sb.inspector.clear()
	note.scroll.scroll_vertical = 0
	await frames()
	var top := note.scroll.scroll_vertical
	note.scroll.scroll_vertical = 100000
	await frames()
	check(note.scroll.scroll_vertical > top, "the note scrolls vertically")
	check(note.scroll.get_global_rect().grow(0.5).encloses(note.icons[-1].get_global_rect()), "scrolled to the end, the last icon is in view")
	check(note.scroll.get_h_scroll_bar().visible == false, "no horizontal scrolling")
	# State from the engine: OVERCLOCK already fired this turn.
	g.enc.overclock_used[g.rack.filter(func(c): return c.id == "OVERCLOCK")[0].uid] = true
	sb.refresh()
	var oc: int = g.rack.map(func(c): return c.id).find("OVERCLOCK")
	note.icons[oc].grab_focus()
	await frames(2)
	check(words_of(sb.inspector).has("Already triggered this turn."), "the inspector reports a spent once-per-turn trigger")
	note.icons[oc].release_focus()
	sb.inspector.clear()
	# --- adjacent components unchanged ---
	for n in adjacent:
		var c: Control = sb.stage.find_child(n, true, false)
		check(c != null and Rect2(c.position, c.size) == adjacent[n], "%s unchanged" % n)
	check(sb.cap_rack.slots.size() == 3, "CAP slots unchanged (3)")
	check(sb.stage.find_child("ProtocolRack", true, false) == null, "the header PROTOCOL slots are gone (superseded)")
	# --- reset when the encounter ends ---
	for c in g.hand.duplicate(): g.discard.append(g._take_from(g.hand, c.uid))
	breach(g)
	sb.ctrl.end_turn()
	var guard := 0
	while g.phase == "RESPONSE" and guard < 50:
		if sb.ctrl.response_pending(): sb.ctrl.step_response()
		else: sb.ctrl.finish_response()
		guard += 1
	await frames()
	sb.refresh()
	await frames()
	check(g.phase in ["REWARD", "DEEPER", "MAP"], "the encounter ended (%s)" % g.phase)
	check(g.rack.is_empty() and g.discard.any(func(c): return c.uid == first.uid), "the Protocols expired to the discard pile")
	check(note.count() == 0, "the note is empty after the encounter")
	print("UI-PROTOCOL-001 NOTE: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

func deploy(g: Game, id: String) -> Dictionary:
	var c: Dictionary = g._new_inst(id)
	g.hand.append(c)
	g.bw = 99
	check(sb.ctrl.request_play(int(c.uid)), "%s deploys through the controller" % id)
	return c

func order_matches(g: Game) -> bool:
	if sb.protocol_note.count() != g.rack.size(): return false
	for k in g.rack.size():
		if int(sb.protocol_note.icons[k].model.get("uid", -1)) != int(g.rack[k].uid): return false
	return true

func words_of(k: KeyInspector) -> Array:
	return k.find_children("*", "Label", true, false).map(func(l): return String(l.text))

func inspect_check(ic: Control, name: String, rules: String) -> void:
	ic.grab_focus()
	await frames(2)
	var w := words_of(sb.inspector)
	check(sb.inspector.visible, "focusing an icon opens the shared inspector")
	check(w.has(name) or w.has(name.to_upper()), "the inspector names the card (%s)" % name)
	check(w.has(rules), "the inspector shows its canonical rules text")
	check(w.any(func(x): return String(x).contains("discard pile")), "the inspector says it expires to the discard pile")
	ic.release_focus()
	sb.inspector.clear()

func breach(g: Game) -> void:
	for i in g.enc.ice.size():
		var subs: Array = g.ice_definition(g.enc.ice[i]).subs
		for s in subs.size():
			while not g.enc.ice[i].broken[s]: g._do_break(i, s)
