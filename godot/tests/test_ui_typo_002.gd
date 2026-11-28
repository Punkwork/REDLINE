extends SceneTree
## UI-TYPO-002 (M06): headless checks for the eight designer-approved event treatments (2026-11-27).
## Expected values come from the designer's approved table (UI Design Bible §2b), not from the
## implementation: wording, target durations, 85% PARTING SHOT scale, LETHAL with no global
## announcement. Drives the production EventFlyout, LethalLens and IceEncounterSandbox with the real
## Game; events the rules take many turns to reach are emitted directly. Drawing never changes Game.

var passed := 0
var failed := 0

## The designer's approved table (2026-11-27): wording and target durations in seconds.
const APPROVED := {
	"rustler_turn": {"text": "RUSTLER TURN", "s": 1.3, "treatment": "kinetic_sweep"},
	"corp_countermeasure": {"text": "CORP COUNTERMEASURE", "s": 1.3, "treatment": "institutional_transmission"},
	"breached": {"text": "DEADLOCK BREACHED", "s": 1.5, "treatment": "kinetic_breakthrough"},
	"lockdown": {"text": "LOCKDOWN", "s": 1.7, "treatment": "surveillance_convergence"},
	"mask_off": {"text": "MASK OFF", "s": 1.7, "treatment": "masked_revelation"},
	"parting_shot": {"text": "PARTING SHOT", "s": 1.15, "treatment": "corner_slingshot"},
	"full_extraction": {"text": "RESERVE EXTRACTED", "s": 1.7, "treatment": "atomic_ascension"},
}
const ORIGINAL_FLYOUT_PX := 76   # the original proposed flyout scale PARTING SHOT is 85% of
const DARK := Color(0.04, 0.03, 0.03)

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	call_deferred("run")

func frames(n := 3) -> void:
	for i in n: await process_frame

func sandbox() -> IceEncounterSandbox:
	var sb: IceEncounterSandbox = load("res://scenes/architecture_v2/IceEncounterSandbox.tscn").instantiate()
	sb.instant = true
	sb.flags_path = "user://test_ui_typo_002_flags.json"
	root.add_child(sb)
	return sb

func flyout() -> EventFlyout:
	var f := EventFlyout.new()
	f.size = Vector2(1536, 864)
	root.add_child(f)
	return f

func run() -> void:
	root.size = Vector2i(1600, 1000)
	print("- tokens: wording, treatments, targets, scale")
	test_tokens()
	print("- readability: translucency, contrast, stable hold, input")
	await test_readability()
	print("- reduced motion and flash safety")
	await test_reduced_motion_and_flash()
	print("- sequencing: queue, per-kind durations, started/finished")
	await test_sequencing()
	print("- MASK OFF artwork, RESERVE EXTRACTED and CRED in step")
	await test_mask_and_extraction()
	print("- live triggering through the sandbox; LETHAL local only; no rules change")
	await test_triggering()
	print("UI-TYPO-002: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

func test_tokens() -> void:
	check(VasTokens.FLYOUT.size() == APPROVED.size(), "seven flyout treatments (LETHAL is not a flyout)")
	check(not VasTokens.FLYOUT.has("ice_lethal"), "no global LETHAL flyout")
	for k in APPROVED:
		var a: Dictionary = APPROVED[k]
		check(VasTokens.FLYOUT.has(k), "%s has tokens" % k)
		if not VasTokens.FLYOUT.has(k): continue
		var s: Dictionary = VasTokens.FLYOUT[k]
		check(String(s.text) == String(a.text), "approved wording %s" % a.text)
		check(String(s.treatment) == String(a.treatment), "%s uses %s" % [k, a.treatment])
		check(absf(VasTokens.flyout_total(k) - float(a.s)) < 0.001, "%s target %.2f s (got %.2f)" % [k, a.s, VasTokens.flyout_total(k)])
		check(VasTokens.flyout_total(k) <= VasTokens.FLYOUT_MAX_SECONDS, "%s within the UI-TYPO-001a 2 s exception" % k)
		var tm: Dictionary = s.timing
		check(float(tm.enter) > 0.0 and float(tm.reveal) > 0.0 and float(tm.hold) > 0.0 and float(tm.exit) > 0.0, "%s has all four phases" % k)
		check(s.font is Font and int(s.px) > 0 and s.has("ease_in") and s.has("ease_out"), "%s type and easing are tokens" % k)
	check(int(VasTokens.FLYOUT.parting_shot.px) == roundi(ORIGINAL_FLYOUT_PX * 0.85), "PARTING SHOT at 85%% of the original scale")
	check(VasTokens.FLYOUT.corp_countermeasure.lines == ["CORP", "COUNTERMEASURE"], "B2: CORP above COUNTERMEASURE")
	check(VasTokens.FLYOUT.breached.lines == ["DEADLOCK", "BREACHED"], "DEADLOCK and BREACHED as separate lines")
	check(String(VasTokens.LETHAL_LENS.text) == "LETHAL", "LETHAL lens wording")

func test_readability() -> void:
	# Contrast: each ink over its band on the darkest, the seafoam and the lightest console ground.
	for k in VasTokens.FLYOUT:
		var s: Dictionary = VasTokens.FLYOUT[k]
		for ground in [VasTokens.CHASSIS, VasTokens.SEAFOAM, VasTokens.IVORY]:
			var under: Color = ground.lerp(s.band, EventFlyout.BAND_ALPHA)
			check(VasTokens.contrast(s.ink, under) >= 4.5 or VasTokens.contrast(DARK, under) >= 4.5, "%s ink readable over %s" % [k, ground.to_html()])
	# Gold and dim EXTRACTED are keylined in near-black, so each glyph reads against its own outline.
	check(VasTokens.contrast(VasTokens.FLYOUT.full_extraction.gold, DARK) >= 4.5, "gold EXTRACTED against its keyline")
	check(VasTokens.contrast(VasTokens.FLYOUT.full_extraction.dim, DARK) >= 4.5, "unlit EXTRACTED against its keyline")
	var L := VasTokens.LETHAL_LENS
	check(VasTokens.contrast(L.ink, Color(L.plate)) >= 4.5, "LETHAL capitals on their plate")
	# Translucency and a stable, full-strength hold, in both motion modes.
	for rm in [false, true]:
		var f := flyout()
		f.reduced_motion = rm
		f.mask_art = CorporationLook.room("HALCYON", "HOSTILE")
		for k in VasTokens.FLYOUT:
			f.hold_at(k, 0.0)
			var peak := 0.0
			var hold_ok := true
			var tt := 0.0
			while tt < VasTokens.flyout_total(k):
				f.t = tt
				peak = maxf(peak, f.band_opacity())
				if f.in_hold() and f.signal_level() < 0.999: hold_ok = false
				tt += 1.0 / 120.0
			check(peak <= EventFlyout.BAND_ALPHA + 0.001, "%s fills stay translucent (peak %.2f, reduced=%s)" % [k, peak, rm])
			check(hold_ok, "%s holds at full strength (reduced=%s)" % [k, rm])
		# Input: the flyout and every layer under it ignore the mouse.
		f.hold_at("mask_off", 0.5)
		var all_ignore := f.mouse_filter == Control.MOUSE_FILTER_IGNORE
		for n in f.find_children("*", "Control", true, false): all_ignore = all_ignore and (n as Control).mouse_filter == Control.MOUSE_FILTER_IGNORE
		check(all_ignore, "flyout layers never intercept input (reduced=%s)" % rm)
		f.queue_free()
	var lens := LethalLens.new(); root.add_child(lens)
	check(lens.mouse_filter == Control.MOUSE_FILTER_IGNORE, "LETHAL lens never intercepts input")
	lens.queue_free()
	await frames()

## Counts "flashes" WCAG 2.3.1-style: a pair of opposing changes of at least 0.1 in intensity.
func max_flashes_per_second(samples: Array, hz: float) -> int:
	var turns: Array = []   # times of direction reversals that complete a ≥ 0.1 swing
	var last := float(samples[0]); var dir := 0; var anchor := last
	for i in range(1, samples.size()):
		var v := float(samples[i])
		var d := signf(v - last)
		if d != 0 and d != dir:
			if absf(last - anchor) >= 0.1 and dir != 0: turns.append(i / hz)
			anchor = last; dir = int(d)
		last = v
	var most := 0
	for a in turns:
		var n := turns.filter(func(b): return b >= a and b < a + 1.0).size()
		most = maxi(most, n)
	return int(ceil(most / 2.0))

func test_reduced_motion_and_flash() -> void:
	var f := flyout()
	f.mask_art = CorporationLook.room("HALCYON", "HOSTILE")
	for rm in [false, true]:
		f.reduced_motion = rm
		for k in VasTokens.FLYOUT:
			f.hold_at(k, 0.0)
			var hz := 240.0
			var samples := []
			var tt := 0.0
			while tt <= VasTokens.flyout_total(k):
				f.t = tt; samples.append(f.signal_level()); tt += 1.0 / hz
			check(max_flashes_per_second(samples, hz) <= 3, "%s: ≤ 3 flashes a second (reduced=%s)" % [k, rm])
			if rm:
				# Reduced motion: a plain fade in place: up, steady, down, never a flicker.
				var reversals := 0; var last := 0.0; var dir := 0
				for v in samples:
					var d := signf(float(v) - last)
					if d != 0 and d != dir and dir != 0: reversals += 1
					if d != 0: dir = int(d)
					last = float(v)
				check(reversals <= 1, "%s reduced motion is a plain fade (%d reversals)" % [k, reversals])
	# Reduced motion keeps the information: MASK OFF letters do not scale; EXTRACTED is fully gold.
	f.reduced_motion = true
	f.hold_at("mask_off", 0.6)
	check(is_equal_approx(f._letter_scale(f.phases()), 1.0), "reduced motion: MASK OFF letters stay at rest")
	f.hold_at("full_extraction", 0.6)
	check(is_equal_approx(f.illumination(), 1.0), "reduced motion: EXTRACTED shows fully gold")
	f.reduced_motion = false
	f.hold_at("corp_countermeasure", 0.05)
	check(f.signal_level() > 0.0 and f.signal_level() < 1.0, "CORP acquisition is irregular, not instant")
	f.queue_free()
	# LETHAL: still; reduced motion shows it at once.
	var lens := LethalLens.new(); root.add_child(lens)
	lens.set_active(true)
	var levels := []
	for i in 600: lens.advance(1.0 / 60.0); levels.append(lens.opacity())
	var still := true
	for i in range(60, 600): still = still and is_equal_approx(float(levels[i]), 1.0)
	check(still, "LETHAL lens settles and stays utterly still (10 s)")
	lens.set_active(false)
	lens.reduced_motion = true; lens.set_active(true)
	check(is_equal_approx(lens.opacity(), 1.0), "reduced motion: LETHAL lens appears at once")
	lens.queue_free()
	await frames()

func test_sequencing() -> void:
	var f := flyout()
	var started := []
	var done := []
	f.started.connect(func(k): started.append(k))
	f.finished.connect(func(k): done.append(k))
	f.announce("lockdown")
	f.announce("mask_off")
	f.announce("lockdown")            # duplicate of the playing one: dropped
	f.announce("parting_shot")
	f.announce("full_extraction")
	f.announce("breached")            # queue full (QUEUE_MAX): dropped
	check(f.queued() == ["mask_off", "parting_shot", "full_extraction"], "arrivals queue in order, capped at %d" % EventFlyout.QUEUE_MAX)
	var clock := 0.0
	var ends := {}
	var last := f.kind
	while f.playing and clock < 20.0:
		f.advance(1.0 / 120.0); clock += 1.0 / 120.0
		if f.kind != last or not f.playing:
			ends[last] = clock; last = f.kind
	check(started == ["lockdown", "mask_off", "parting_shot", "full_extraction"], "each run starts once, in order (%s)" % [started])
	check(done == started, "each run finishes once, in order")
	var expect := 0.0
	var n := 0
	for k in started:
		expect += VasTokens.flyout_total(k); n += 1
		# Each run ends on the first 1/120 s step past its target, so allow one step per run so far.
		check(absf(float(ends.get(k, -1.0)) - expect) <= n / 120.0 + 0.001, "%s ends at its own target (%.3f vs %.3f)" % [k, ends.get(k, -1.0), expect])
	check(not f.visible and f._mask_root != null and not f._mask_root.visible, "flyout and MASK OFF layers end hidden")
	f.queue_free()
	await frames()

func test_mask_and_extraction() -> void:
	var f := flyout()
	# MASK OFF shows the corporation's actual (HOSTILE) artwork through the letters, then whole.
	for corp in ["HALCYON", "IRONWATCH", "LUCIDA"]:
		check(CorporationLook.room(corp, "HOSTILE") != null, "%s HOSTILE artwork present" % corp)
	f.mask_art = CorporationLook.room("HALCYON", "HOSTILE")
	f.hold_at("mask_off", 0.6)
	check(f._mask_root.clip_children == CanvasItem.CLIP_CHILDREN_ONLY and f._mask_letters.texture == f.mask_art, "art clipped to the letterforms")
	check(f._mask_letters.modulate.a > 0.0 and f._mask_full.modulate.a == 0.0, "letters reveal the art during the hold")
	var T := VasTokens.flyout_timing("mask_off")
	f.hold_at("mask_off", float(T.enter) + float(T.reveal) + float(T.hold) + float(T.exit) * 0.5)
	check(f._mask_full.modulate.a > 0.4 and f.band_opacity() <= EventFlyout.BAND_ALPHA + 0.001, "mask withdrawn: the complete image, still translucent")
	f.hold_at("mask_off", VasTokens.flyout_total("mask_off") - 0.01)
	check(f._mask_full.modulate.a < 0.05, "returns to the encounter")
	f.mask_art = null
	f.hold_at("mask_off", 0.6)
	check(f.missing_assets() == ["mask_art"], "missing artwork is flagged, not substituted")
	# RESERVE EXTRACTED: EXTRACTED is fully gold exactly as the CRED readout lands.
	var E := VasTokens.flyout_timing("full_extraction")
	var lands := HudWidgets.RailLedger.ANTS_S + HudWidgets.RailLedger.COUNT_S
	check(absf(float(E.enter) + float(E.reveal) - lands) < 0.001, "gold completes with the CRED count (%.2f s)" % lands)
	f.hold_at("full_extraction", lands * 0.5)
	var mid := f.illumination()
	f.hold_at("full_extraction", lands + 0.01)
	check(mid > 0.05 and mid < 0.95 and is_equal_approx(f.illumination(), 1.0), "EXTRACTED lights progressively (%.2f mid-way)" % mid)
	f.queue_free()
	await frames()

func snapshot(g: Game) -> String:
	return JSON.stringify([g.vitae, g.trace, g.cred, g.bw, g.shield, g.phase, g.strikes, g.lockdown, g.hand.size(),
		g.draw_pile.size(), g.discard.size(), g.response_queue.size(), g.enc.get("reserve", 0), g.enc.get("breached", false)])

func test_triggering() -> void:
	var sb := sandbox()
	await frames()
	var g := sb.game
	check(sb.flyout.kind == "rustler_turn", "RUSTLER TURN opens the encounter")
	check(sb.flyout.mask_art == CorporationLook.room(g.corporation, "HOSTILE"), "MASK OFF gets this corporation's artwork")
	sb.flyout.advance(10.0)
	# DEADLOCK BREACHED, PARTING SHOT (only when something fires), RESERVE EXTRACTED.
	var cases := [["EV-07", {}, "breached"], ["PARTING_SHOT", {"fired": 2}, "parting_shot"]]
	for c in cases:
		var before := snapshot(g)
		g._event(String(c[0]), c[1]); sb.refresh()
		check(sb.flyout.kind == String(c[2]) and sb.flyout.playing, "%s announces %s" % [c[0], c[2]])
		check(snapshot(g) == before, "%s presentation leaves the rules state unchanged" % c[0])
		sb.flyout.advance(10.0)
	g._event("PARTING_SHOT", {"fired": 0}); sb.refresh()
	check(not sb.flyout.playing, "an empty parting shot is not announced")
	if int(g.enc.get("reserve", 0)) > 0:
		var cred0 := g.cred
		g.extract(int(g.enc.reserve)); sb.refresh()
		check(sb.flyout.kind == "full_extraction" and g.cred > cred0, "extracting the whole reserve announces RESERVE EXTRACTED")
		check(sb.ledger.ants > 0.0 or sb.ledger.reduced_motion, "CRED feedback runs alongside")
		sb.flyout.advance(10.0)
	else:
		check(false, "the test encounter has a reserve to extract")
	# Strikes: MASK OFF then LOCKDOWN, through the rules.
	g.add_trace(40 - g.trace, false); sb.refresh()
	g.add_trace(40 - g.trace, false); sb.refresh()
	check(sb.flyout.kind == "mask_off", "second strike announces MASK OFF")
	g.add_trace(40 - g.trace, false); sb.refresh()
	var seen: Array = sb.flyout.queued(); seen.append(sb.flyout.kind)
	check(seen.has("lockdown"), "LOCKDOWN announced")
	sb.flyout.advance(10.0); sb.flyout.advance(10.0); sb.flyout.advance(10.0)
	# LETHAL: local lens on that ICE only; no flyout and no red wash.
	sb.flash.color.a = 0.0
	var ice: Dictionary = g.enc.ice[0]
	ice["lethal"] = true
	g._event("ICE_LETHAL", {"ice": ice.id}); sb.refresh()
	check(not sb.flyout.playing and sb.flyout.queued().is_empty(), "LETHAL has no global announcement")
	check(sb.flash.color.a == 0.0, "LETHAL has no global red wash")
	var lenses := sb.lane.find_children("LethalLens", "LethalLens", true, false)
	var on := lenses.filter(func(l): return (l as LethalLens).active)
	check(lenses.size() == g.enc.ice.size() and on.size() == 1, "one lens lit, on the LETHAL ICE (%d of %d)" % [on.size(), lenses.size()])
	if on.size() == 1:
		var panel := (on[0] as Node).get_parent() as IcePanel
		check(panel.ice_ref == ice, "the lens is on the affected ICE")
		var lens_rect := Rect2((on[0] as Control).position, (on[0] as Control).size)
		var bank_rect := Rect2(panel.band.position, panel.band.size)
		check(not lens_rect.intersects(bank_rect), "the lens stays clear of the subroutine keys")
	sb.refresh()
	check(sb.lane.find_children("LethalLens", "LethalLens", true, false).filter(func(l): return l.active).size() == 1, "the lens persists while LETHAL")
	# Response phase: CORP COUNTERMEASURE; the sequencer holds while it plays (no reorder).
	sb.queue_free(); await frames()
	sb = sandbox(); await frames(); g = sb.game
	sb.flyout.advance(10.0)
	sb.ctrl.end_turn(); sb.refresh()
	var k2: Array = sb.flyout.queued(); k2.append(sb.flyout.kind)
	check(k2.has("corp_countermeasure"), "END TURN announces CORP COUNTERMEASURE")
	sb.queue_free(); await frames()
