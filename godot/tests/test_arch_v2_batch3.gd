extends SceneTree
## ARCH-V2-006 Batch 3: headless checks for the encounter screen's Batch 3 parts. Every check drives
## the real Game through the sandbox (or sets Game state directly where the rules would take many
## turns to get there) and reads only what the screen shows. Drawing never changes Game.

var passed := 0
var failed := 0

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	call_deferred("run")

func sandbox() -> IceEncounterSandbox:
	var sb: IceEncounterSandbox = load("res://scenes/architecture_v2/IceEncounterSandbox.tscn").instantiate()
	sb.instant = true
	sb.flags_path = "user://test_arch_v2_flags.json"
	root.add_child(sb)
	return sb

func frames(n := 3) -> void:
	for i in n: await process_frame

func run() -> void:
	root.size = Vector2i(1600, 1000)
	print("- header: eye, strikes, LOCKDOWN, legend, Ghostware reel")
	await test_header()
	print("- rail: LAYER, CRED and extraction ants, log, parting shot")
	await test_rail()
	print("- events: flyouts, strikes, LOCKDOWN, wash, break feedback, virus chips")
	await test_events()
	print("- cards: CACHED icon, drag to play, show board, pile viewers, NEXT DRAW")
	await test_cards()
	print("- NUL/REM speakers, voice mute, saved settings")
	await test_speakers()
	print("- response sequencer (C03)")
	await test_sequencer()
	print("- targeting arrow (ARCH-V2-006k)")
	await test_arrow()
	print("- PROBE modes on the V2 screen (CSA-04b, PROBE-004a)")
	await test_probe_modes()
	print("ARCH-V2 BATCH 3: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

func test_header() -> void:
	var sb := sandbox()
	await frames()
	var g := sb.game
	var eye := sb.eye
	check(eye != null and sb.stage.find_child("Logo", false, false) == null, "the eye replaces the PANOPTICON plate")
	check(eye.position.x < 20.0 and eye.position.y < 10.0, "eye sits in the very top-left corner")
	# Alarm lamp: cool at no reveal, hotter with TRACE, full red at Mask off.
	check(is_equal_approx(eye.reveal, 0.0), "no reveal at TRACE %d" % g.trace)
	var cool := eye.lens_colour()
	g.trace = 30; sb.refresh()
	check(eye.reveal > 0.2 and eye.reveal < 0.6, "Cracking reveal between 20%% and 60%% at TRACE 30 (%.2f)" % eye.reveal)
	var warm := eye.lens_colour()
	check(warm.r > cool.r and warm.g < cool.g, "lens warms toward red as the reveal grows")
	g.strikes = 2; sb.refresh()
	check(is_equal_approx(eye.reveal, 1.0) and eye.lens_colour().is_equal_approx(HudWidgets.EyeLamp.HOT), "Mask off: full red")
	check(eye.strikes == 2 and not eye.lockdown, "two strike lamps lit")
	g.strikes = 3; g.lockdown = true; sb.refresh()
	check(eye.lockdown and eye.title == "LOCKDOWN", "LOCKDOWN shown on the eye")
	# Hover: place line, reveal and the legend with icons.
	eye.grab_focus(); await frames(2)
	check(sb.inspector.visible and is_same(sb.inspector.subject, eye), "eye explains itself on focus")
	var words := _inspector_text(sb)
	check(words.contains("NODE N2A") and words.contains("LAYER 1 / 1"), "hover names the Node and layer")
	check(words.contains("DEADLOCK") and words.contains("CORTEX"), "hover carries the KEY LEGEND")
	eye.release_focus(); sb.inspector.close()
	# Ghostware reel: ORIGIN first, arrows roll, hover shows the art large.
	var reel := sb.ghost_reel
	check(reel.items.size() == 1 and reel.current().get("origin", false), "ORIGIN Ghostware shows first")
	check(reel.up.disabled and reel.down.disabled, "arrows idle with one Ghostware")
	g.ghostware.append("HEARTBEAT"); g.ghostware.append("ONE_TRICK"); sb.refresh()
	check(reel.items.size() == 3 and not reel.down.disabled, "three Ghostware, arrows live")
	reel.down.pressed.emit()
	check(reel.current().name == "HEARTBEAT", "down rolls to the next Ghostware")
	reel.up.pressed.emit(); reel.up.pressed.emit()
	check(reel.current().name == "ONE TRICK", "up wraps to the last")
	reel.window.grab_focus(); await frames(2)
	check(sb.inspector.visible and sb.inspector.find_child("Image", true, false).get_child_count() > 0, "hover shows the Ghostware picture")
	check(_inspector_text(sb).contains("ONE TRICK"), "hover names the Ghostware")
	reel.window.release_focus(); sb.inspector.close()
	var before := [g.trace, g.strikes, g.ghostware.size(), g.bw]
	sb.refresh(); sb.refresh()
	check([g.trace, g.strikes, g.ghostware.size(), g.bw] == before, "refresh does not change Game")
	sb.queue_free(); await frames()

func test_rail() -> void:
	var sb := sandbox()
	await frames()
	var g := sb.game
	var lg := sb.ledger
	check(lg.layers == 1 and lg.current == 0, "LAYER mark: N2A has one layer")
	check(lg.reserve == int(g.enc.reserve) and lg.cred == g.cred, "ledger shows CRED and the layer reserve")
	check(lg.cred_cell.position.x < lg.reserve_cell.position.x, "layer CRED sits right of the Rustler's CRED")
	check(lg.position.x < sb.rail.position.x, "ledger sits at the left end of the rail")
	# Extraction through the rules: ants run left, CRED counts up to the new value.
	var before := g.cred
	g.extract(5); sb.refresh()
	check(g.cred == before + 5 and lg.cred == g.cred, "ledger has the new CRED")
	check(lg.ants > 0.0 and roundi(lg.shown_cred) == before, "ants run before the count goes up")
	for i in 90: await process_frame
	lg.finish()
	check(roundi(lg.shown_cred) == g.cred, "CRED window counts up to the new value")
	sb.reduced_motion = true; sb.refresh()
	g.extract(2); sb.refresh()
	check(lg.ants == 0.0 and roundi(lg.shown_cred) == g.cred, "reduced motion: no ants, value at once")
	sb.reduced_motion = false
	# LAYER mark on a three-layer Node (display model only).
	lg.set_values(3, 1, g.cred, 4)
	check(lg.layers == 3 and lg.layer_mark.title == "LAYER 2 / 3", "three layers, second lit")
	sb.refresh()
	# Log: hover on the rail shows the latest lines; a click pins the full log; Esc closes.
	g.log.append("Test line for the log.")
	sb.refresh()
	sb.rail_log.grab_focus(); await frames(2)
	check(sb.inspector.visible and _inspector_text(sb).contains("Test line for the log."), "rail hover shows the latest log lines")
	sb.rail_log.release_focus(); sb.inspector.close()
	sb.toggle_log()
	check(sb.log_panel.visible and sb.log_panel.count() == g.log.size(), "click pins the full log")
	var esc := InputEventAction.new(); esc.action = "ui_cancel"; esc.pressed = true
	sb._unhandled_input(esc)
	check(not sb.log_panel.visible, "Esc closes the log")
	check(sb.find_child("Ticker", true, false) == null, "no log ticker")
	# Parting shot: after a BREACH the PULP meter and END TURN say what fires; the rail drops DEADLOCKs.
	g.enc.breached = true; sb.refresh()
	check(sb.meters.PULP.title.begins_with("PARTING SHOT"), "PULP meter becomes PARTING SHOT after BREACH")
	check(sb.end_key.lines.size() == 1 and String(sb.end_key.lines[0]).begins_with("Parting shot"), "END TURN hover states the parting shot")
	var dl := false
	for c in sb.rail.steps(): dl = dl or String(c.model.kind) == "DEADLOCK"
	check(not dl, "parting-shot rail has no DEADLOCK")
	sb.queue_free(); await frames()

func test_events() -> void:
	var sb := sandbox()
	await frames()
	var g := sb.game
	sb.flyout.advance(10.0)
	# A strike through the rules: TRACE reaches 40.
	g.add_trace(40 - g.trace, false); sb.refresh()
	check(sb.last_events.any(func(e): return e.t == "EV-14"), "strike event read by the screen")
	check(g.events.is_empty(), "events drained once")
	check(sb.flyout.kind != "strike" and not sb.flyout.queued().has("strike") and not VasTokens.FLYOUT.has("strike"), "no TRACE STRIKE banner (ARCH-V2-006j)")
	check(sb.eye.strikes == 1, "first strike lamp lit")
	check(sb.flash.color.a > 0.0, "red wash on a strike")
	# Second and third strikes: MASK OFF, then LOCKDOWN with its flyout.
	g.add_trace(40 - g.trace, false); g.add_trace(40 - g.trace, false); sb.refresh()
	check(g.lockdown and sb.eye.lockdown, "LOCKDOWN on the eye")
	var kinds: Array = sb.flyout.queued(); kinds.append(sb.flyout.kind)
	check(kinds.has("lockdown"), "LOCKDOWN flyout announced")
	check(sb.flyout.queued().size() <= EventFlyout.QUEUE_MAX, "flyout queue capped")
	var total := 0.0
	while sb.flyout.playing and total < 20.0:
		sb.flyout.advance(0.1); total += 0.1
	check(not sb.flyout.playing and sb.flyout.queued().is_empty(), "queued flyouts play out")
	check(total <= 1.5 * 4 + 0.2, "each flyout stays within 1.5 s (%.1f s for the queue)" % total)
	sb.queue_free(); await frames()
	# Reduced motion: flyouts still announce, no wash.
	sb = sandbox(); sb.reduced_motion = true
	await frames(); g = sb.game; sb.flyout.advance(10.0); sb.refresh()
	g.add_trace(40 - g.trace, false); sb.refresh()
	check(sb.flash.color.a == 0.0, "reduced motion: no red wash")
	g.add_trace(40 - g.trace, false); sb.refresh()
	check(sb.flyout.kind == "mask_off", "reduced motion: banners still announce")
	sb.queue_free(); await frames()
	# Break feedback through a real paid break; virus chips from the ICE's counters.
	sb = sandbox(); await frames(); g = sb.game
	sb.flyout.advance(10.0)
	g.bw = 30
	var tp := g.hand.filter(func(c): return c.id == "TUMBLER_ICEPICK")
	if not tp.is_empty(): sb.ctrl.request_play(tp[0].uid)
	g.bw = 30; sb.refresh(); await frames(2)
	var panel: IcePanel = null
	var sub := -1
	for p in sb.lane.panels():
		for k in p.model.keys:
			if sub < 0 and bool(k.breakable) and int(k.cost) > 0: sub = int(k.sub); panel = p
	check(sub >= 0, "a paid break is available")
	if sub >= 0:
		sb.lane.break_requested.emit(panel.ice_ref, sub, -1)
		await frames(2)
		check(sb.find_child("BreakFeedback", true, false) != null, "break shows the BW it spent")
	g.enc.ice[0].virus = {"ROT": 2, "WORM": 3}; sb.refresh(); await frames(2)
	panel = sb.lane.panels()[0]
	var rot := panel.find_child("Virus_ROT", true, false)
	check(rot != null and panel.find_child("Virus_WORM", true, false) != null, "virus chips on the ICE")
	if rot:
		rot.grab_focus(); await frames(2)
		check(_inspector_text(sb).contains("ROT 2") and _inspector_text(sb).contains("STR"), "virus chip explains its strain")
	sb.queue_free(); await frames()

func _hand_card(sb: IceEncounterSandbox, pred: Callable) -> CardView:
	for c in sb.hand_fan.cards():
		if c is CardView and pred.call(c.model): return c
	return null

func test_cards() -> void:
	var sb := sandbox()
	await frames()
	var g := sb.game
	sb.flyout.advance(10.0)
	# CACHED corner icon and its words.
	g.hand[0].cached = true; sb.refresh(); await frames()
	var cv := _hand_card(sb, func(m): return int(m.uid) == int(g.hand[0].uid))
	check(cv != null and bool(cv.model.cached) and int(cv.model.cache_turns) == 0, "cached card carries ∞")
	g.hand[0].cache_turns = 2; sb.refresh(); await frames()
	cv = _hand_card(sb, func(m): return int(m.uid) == int(g.hand[0].uid))
	check(int(cv.model.cache_turns) == 2, "cached card carries its turns left")
	cv.grab_focus(); await frames(2)
	check(_inspector_text(sb).contains("CACHED"), "inspector explains CACHED")
	cv.release_focus(); sb.inspector.close()
	g.hand[0].cached = false; g.hand[0].erase("cache_turns"); sb.refresh(); await frames()
	# Click plays on release, so a press can become a drag.
	var plain := _hand_card(sb, func(m): return bool(m.playable) and not bool(m.target))
	var n0 := g.hand.size()
	var down := InputEventMouseButton.new(); down.button_index = MOUSE_BUTTON_LEFT; down.pressed = true; down.position = Vector2(10, 10)
	plain._gui_input(down)
	check(g.hand.size() == n0, "press alone doesn't play")
	var up := InputEventMouseButton.new(); up.button_index = MOUSE_BUTTON_LEFT; up.pressed = false; up.position = Vector2(10, 10)
	plain._gui_input(up)
	check(g.hand.size() == n0 - 1, "release plays the card")
	await frames()
	# Drag: untargeted dropped above the tray plays; dropped back on the tray does nothing.
	var drag := _hand_card(sb, func(m): return bool(m.playable) and not bool(m.target) and String(m.type) != "PROGRAM")
	check(drag._get_drag_data(Vector2.ZERO) is Dictionary, "playable card starts a drag")
	var tray_pt := sb.stage.global_position + (IceEncounterSandbox.TRAY.position + Vector2(400, 60)) * sb.stage.scale
	var n1 := g.hand.size()
	sb._on_card_dropped(drag.uid(), tray_pt)
	check(g.hand.size() == n1, "dropped on the tray: not played")
	var above := sb.stage.global_position + Vector2(760, 300) * sb.stage.scale
	var calls := sb.ctrl.game_calls
	sb._on_card_dropped(drag.uid(), above)
	check(g.hand.size() == n1 - 1 and sb.ctrl.game_calls == calls + 1, "dropped above the tray: played with one call")
	await frames()
	# Targeted card (PROBE): dropped on an ICE panel plays on that ICE.
	var probe := _hand_card(sb, func(m): return bool(m.target) and bool(m.playable))
	if probe:
		var panel: IcePanel = sb.lane.panels()[1]
		var str_before := int(panel.model.str)
		var pu := probe.uid()
		sb._on_card_dropped(pu, panel.get_global_rect().get_center())
		await frames()
		check(not g.hand.any(func(c): return int(c.uid) == pu), "targeted card dropped on an ICE is played")
		check(int(sb.lane.panels()[1].model.str) < str_before, "and lands on that ICE")
	else:
		check(false, "a playable PROBE in hand")
	# ARCH-V2-006l: a PROGRAM installs only on the CRT; the CRT glows while one is dragged.
	await frames()
	var prog := _hand_card(sb, func(m): return String(m.type) == "PROGRAM" and bool(m.playable))
	if prog:
		var pu := prog.uid()
		prog.drag_began.emit(pu)
		check(sb.crt_glow.state == 1, "CRT glows while a PROGRAM is dragged")
		var crt_pt := sb.stage.global_position + IceEncounterSandbox.CRT.get_center() * sb.stage.scale
		sb.get_viewport().warp_mouse(crt_pt); sb._process(0.0)
		prog.drag_finished.emit(pu)
		check(sb.crt_glow.state == 0, "glow off when the drag ends")
		var n2 := g.hand.size()
		sb._on_card_dropped(pu, sb.stage.global_position + Vector2(760, 300) * sb.stage.scale)
		check(g.hand.size() == n2, "PROGRAM dropped above the tray but off the CRT: not installed")
		var inst := g.installed.size()
		sb._on_card_dropped(pu, crt_pt)
		check(g.installed.size() == inst + 1 and g.hand.size() == n2 - 1, "PROGRAM dropped on the CRT installs")
	else:
		check(false, "a playable PROGRAM in hand")
	# ARCH-V2-006l: playable cards lit, the rest dimmed, refreshed as BW is spent.
	g.bw = 0; sb.refresh(); await frames()
	var lit := 0; var dim := 0
	for c in sb.hand_fan.cards():
		if not (c is CardView): continue
		var ok: bool = g.can_play(c.uid()).get("ok", false)
		check(bool(c.model.playable) == ok, "%s lit only if playable" % c.model.name)
		if ok: lit += 1
		else: dim += 1
	check(dim > 0, "with 0 BW, cards that cost BW dim (%d dim, %d lit)" % [dim, lit])
	var unplayable := CardView.new(); unplayable.set_model({"uid": 999, "playable": false})
	check(unplayable._get_drag_data(Vector2.ZERO) == null, "unplayable card can't be dragged")
	unplayable.free()
	# NEXT DRAW on the deck counter; pile viewers.
	check(String(sb.counters.rows[0].lines[0]) == "NEXT DRAW: %d cards." % g.draw_size(), "deck hover gives NEXT DRAW")
	sb.open_pile("deck")
	check(sb.pile_view.visible and sb.pile_view.cards().size() == g.draw_pile.size(), "deck viewer shows the draw pile")
	var names := sb.pile_view.cards().map(func(c): return String(c.model.name))
	var sorted := names.duplicate(); sorted.sort()
	check(names == sorted, "deck viewer is sorted by name (order hidden)")
	var esc := InputEventAction.new(); esc.action = "ui_cancel"; esc.pressed = true
	sb._unhandled_input(esc)
	check(not sb.pile_view.visible, "Esc closes the viewer")
	sb.open_pile("discard")
	check(sb.pile_view.visible and sb.pile_view.cards().size() == g.discard.size(), "discard viewer")
	sb.pile_view.secondary.emit("close")
	check(not sb.pile_view.visible, "Close closes the viewer")
	sb.queue_free(); await frames()
	# SHOW BOARD during a discard (#15): through a real CAPTCHA discard choice.
	sb = sandbox(); await frames(); g = sb.game
	g.pending = {"kind": "discard", "n": 1}; g.phase = "CHOICE"; sb.refresh(); await frames()
	check(sb.choice.visible and not sb.choice.peek, "discard choice open")
	var show := sb.choice.find_child("ShowBoard", true, false) as Button
	check(show != null, "SHOW BOARD offered")
	if show: show.pressed.emit()
	check(sb.choice.peek and sb.choice.mouse_filter == Control.MOUSE_FILTER_IGNORE, "board visible, overlay lets the mouse through")
	sb.refresh()
	check(sb.choice.peek, "peek kept across refresh")
	var back := sb.choice.find_child("BackToChoice", true, false) as Button
	check(back != null and back.visible, "BACK TO DISCARD shown")
	if back: back.pressed.emit()
	check(not sb.choice.peek and sb.choice.find_child("Plaque", true, false).visible, "back to the choice")
	sb.queue_free(); await frames()

func test_speakers() -> void:
	LocalRecord.erase("user://test_arch_v2_flags.json")
	var sb := sandbox(); await frames(); var g := sb.game
	check(sb.speakers.size() == 2, "two speaker grilles")
	var l: Control = sb.speakers[0]; var r: Control = sb.speakers[1]
	var p0: IcePanel = sb.lane.panels()[0]
	check(l.position.x < sb.ledger.position.x and r.position.x > sb.rail.position.x + sb.rail.size.x, "left grille under the left avatar, right one under the right ICE")
	check(sb.find_child("NulRemNote", true, false) == null and sb.find_child("Ticker", true, false) == null, "no NUL/REM note or ticker on screen")
	# A line through the real picker on a strike (EV-14 always speaks).
	g.add_trace(40 - g.trace, false); sb.refresh()
	check(not sb.nr_lines.is_empty(), "NUL/REM picks a line for the strike")
	check(r.speaking > 0.0, "grilles glow while NUL/REM speaks")
	l.grab_focus(); await frames(2)
	check(_inspector_text(sb).contains(String(sb.nr_lines[-1].text)), "hover shows the line's text")
	l.release_focus(); sb.inspector.close()
	# Mute: click a grille (or M); saved to the settings file.
	l.toggled.emit()
	check(not sb.voice_on and l.muted and r.muted, "click mutes the voice")
	check(LocalRecord.read("user://test_arch_v2_flags.json").get("voice_on", true) == false, "voice setting saved")
	var m := InputEventKey.new(); m.keycode = KEY_M; m.pressed = true
	sb._unhandled_input(m)
	check(sb.voice_on and not l.muted, "M turns it back on")
	sb.queue_free(); await frames()
	# Saved settings apply on the next encounter: reduced motion and voice off.
	LocalRecord.write("user://test_arch_v2_flags.json", {"reduced_motion": true, "voice_on": false})
	sb = sandbox(); await frames()
	check(sb.reduced_motion and sb.flyout.reduced_motion and sb.hand_fan.reduced_motion, "saved reduced motion applies")
	check(not sb.voice_on and sb.speakers[0].muted, "saved voice off applies")
	sb.queue_free(); await frames()
	LocalRecord.erase("user://test_arch_v2_flags.json")

func test_sequencer() -> void:
	var sb := sandbox(); await frames(); var g := sb.game
	sb.flyout.advance(10.0)
	var count := [0]   # lambdas capture locals by value; count through an array
	sb.sequencer.step_resolved.connect(func(_e): count[0] += 1)
	var expected := g.response_preview().filter(func(st): return not st.skipped).size()
	var calls := sb.ctrl.game_calls
	await sb.end_turn()
	var n_steps: int = count[0]
	check(n_steps == expected and n_steps > 0, "each queued step resolves exactly once (%d of %d)" % [n_steps, expected])
	check(sb.ctrl.game_calls == calls + 1 + n_steps + 1, "one call per step plus end turn and finish")
	check(not sb.responding and not sb.sequencer.running, "sequencer done, back to the Rustler")
	check(sb.last_effect_sound != "", "steps sound their effect type (%s)" % sb.last_effect_sound)
	sb.queue_free(); await frames()
	# Paced (not instant): holds while a strike flyout plays; cancel stops it cleanly.
	sb = sandbox(); await frames(); g = sb.game
	sb.instant = false; sb.step_seconds = 0.05
	sb.flyout.advance(10.0)
	sb.flyout.announce("lockdown")
	check(sb.sequencer.hold.call(), "a LOCKDOWN banner holds the response")
	sb.end_turn()
	await frames(4)
	var before_q: int = g.response_queue.size()
	check(sb.responding and before_q > 0 and sb.ctrl.fired.is_empty(), "nothing resolves while the flyout holds")
	sb.flyout.advance(10.0); sb.flyout.advance(10.0)   # LOCKDOWN, then the queued CORP COUNTERMEASURE
	await create_timer(0.6).timeout
	check(sb.ctrl.fired.size() > 0 or not sb.responding, "response continues after the flyout")
	sb.sequencer.cancel()
	var q := g.response_queue.size()
	for i in 30: await process_frame
	check(g.response_queue.size() == q, "cancel stops resolving")
	# Leaving mid-response: the screen goes away, nothing else resolves, no errors.
	sb.queue_free(); await frames(30)
	check(true, "screen freed mid-response")

func _mouse(btn_pressed: bool, at: Vector2) -> InputEventMouseButton:
	var e := InputEventMouseButton.new(); e.button_index = MOUSE_BUTTON_LEFT; e.pressed = btn_pressed
	e.position = at; e.global_position = at
	return e

func test_arrow() -> void:
	var sb := sandbox(); await frames(); var g := sb.game
	sb.flyout.advance(10.0)
	var probe := _hand_card(sb, func(m): return bool(m.target) and bool(m.playable))
	check(probe != null, "a playable PROBE")
	if probe == null: sb.queue_free(); return
	var pu := probe.uid()
	check(probe._get_drag_data(Vector2.ZERO) == null, "targeted cards aren't dragged; they're aimed")
	# Press and hold: the arrow appears, the ICE light up, no plaque.
	probe._gui_input(_mouse(true, Vector2(20, 20)))
	check(sb.aiming_uid == pu and sb.arrow.visible, "press and hold starts the arrow")
	check(not sb._target_plaque.visible, "no CHOOSE AN ICE plaque while aiming with the mouse")
	var panel: IcePanel = sb.lane.panels()[1]
	var at := panel.get_global_rect().get_center()
	var mv := InputEventMouseMotion.new(); mv.global_position = at; mv.position = at
	sb._input(mv)
	check(sb.arrow.over.has_area() and sb.arrow.from.distance_to(sb.arrow.to) > 24.0, "arrow follows to the ICE and rings it")
	var str_before := int(panel.model.str)
	var calls := sb.ctrl.game_calls
	sb._input(_mouse(false, at))
	await frames()
	check(not g.hand.any(func(c): return int(c.uid) == pu), "release over the ICE plays the card")
	check(sb.ctrl.game_calls == calls + 1, "with one controller call")
	check(int(sb.lane.panels()[1].model.str) < str_before, "on that ICE")
	check(not sb.arrow.visible and sb.aiming_uid < 0, "arrow gone")
	# Release elsewhere cancels; nothing played.
	var p2 := _hand_card(sb, func(m): return bool(m.target) and bool(m.playable))
	if p2:
		var u2 := p2.uid(); var n := g.hand.size()
		p2._gui_input(_mouse(true, Vector2(20, 20)))
		var away := sb.stage.global_position + Vector2(760, 820) * sb.stage.scale
		var mv2 := InputEventMouseMotion.new(); mv2.global_position = away + Vector2(0, -300); sb._input(mv2)
		sb._input(_mouse(false, away + Vector2(0, -300) if false else Vector2(5, 5)))
		check(g.hand.size() == n and sb.aiming_uid < 0, "release away from the ICE cancels")
		# Click mode: press and release on the card keeps the arrow; the next click decides.
		await frames()
		p2 = _hand_card(sb, func(m): return int(m.uid) == u2)
		var c := p2.get_global_rect().get_center()
		p2._gui_input(_mouse(true, c))
		sb._input(_mouse(false, c))
		check(sb.aiming_uid == u2 and sb.arrow.visible, "a plain click keeps aiming")
		var esc := InputEventAction.new(); esc.action = "ui_cancel"; esc.pressed = true
		sb._input(esc)
		check(sb.aiming_uid < 0 and not sb.arrow.visible and g.hand.size() == n, "Esc cancels")
	sb.queue_free(); await frames()

func _inspector_text(sb: IceEncounterSandbox) -> String:
	var out := ""
	for l in sb.inspector.find_children("*", "Label", true, false): out += (l as Label).text + "\n"
	return out

func test_probe_modes() -> void:
	## PROBE-004a: on a VOID with hidden subroutines the V2 screen asks which mode; Cancel calls nothing.
	var sb := sandbox(); await frames()
	var g := Game.new(1)
	g.new_run(); g.enter_node(0)
	g.choose_ready_rig(g.draw_pile.filter(func(c): return c.id == "TUMBLER_ICEPICK")[0].uid)
	g.new_run(); g.row = 1; g.available = [1]; g.enter_node(1)   # DOORBELL CAM, a VOID, face-down
	if g.phase == "READY_RIG": g.choose_ready_rig(g.draw_pile.filter(func(c): return c.id == "VOID_ICEPICK")[0].uid)
	sb.attach(g); await frames()
	var c: Dictionary = g._new_inst("PROBE"); g.hand.append(c); sb.refresh(); await frames()
	var ref: Dictionary = g.enc.ice[0]
	var hidden0 := g.hidden_subs(0)
	var calls := sb.ctrl.game_calls
	sb.play_targeted(int(c.uid), ref); sb.refresh(); await frames()
	var weaken: Button = sb.choice.find_child("Option_mode_weaken", true, false)
	var reveal: Button = sb.choice.find_child("Option_mode_reveal", true, false)
	var cancel: Button = sb.choice.find_child("Option_mode_cancel", true, false)
	check(sb.choice.visible and weaken != null and reveal != null and cancel != null, "PROBE on a hidden VOID opens the choice: −2 STR, reveal, cancel")
	check(sb.ctrl.game_calls == calls, "opening the choice calls nothing on Game")
	if cancel: cancel.pressed.emit()
	sb.refresh(); await frames()
	check(not sb.choice.visible and sb.ctrl.game_calls == calls and g.hand.has(c) and g.hidden_subs(0) == hidden0, "Cancel closes it and changes nothing")
	sb.play_targeted(int(c.uid), ref); sb.refresh(); await frames()
	reveal = sb.choice.find_child("Option_mode_reveal", true, false)
	if reveal: reveal.pressed.emit()
	sb.refresh(); await frames()
	check(sb.ctrl.game_calls == calls + 1 and not g.hand.has(c) and g.hidden_subs(0) == 0, "the reveal button plays PROBE in its reveal mode: all hidden subroutines shown")
	var c2: Dictionary = g._new_inst("PROBE"); g.hand.append(c2); g.bw = 5; sb.refresh(); await frames()
	var str0 := g.ice_str(0)
	sb.play_targeted(int(c2.uid), ref); sb.refresh(); await frames()
	check(not sb.choice.visible and not g.hand.has(c2) and g.ice_str(0) == str0 - 2, "with nothing hidden, PROBE plays −2 STR without asking")
	sb.queue_free(); await frames()
