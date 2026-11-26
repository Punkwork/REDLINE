class_name IceEncounterSandbox
extends Control
## ARCH-V2-003 harness: the representative ICE encounter (N2A CAPTCHA: AUTO-RENEW + CAPTCHA) on the
## Architecture V2 components, composed to the VAS-001 reference (1536 × 864, scaled into the
## existing 1600 × 1000 window) with the VAS-ASSET-001 painted parts. Real Game state; every action
## goes through EncounterController.
##
## Icon-first (VAS-ASSET-001 §2a): instruments show icons and numbers; names on hover/focus only.
## Negative space is kept (ARCH-V2-003m): the mockup's HOSTILE REVEAL / LAYER / EXTRACT plaques are
## left out until their content is decided, and END TURN is an illuminated key, not a dome.
##
## Not the app entry (Main.tscn is untouched). Open in the editor (F6) or from tests. The hand and
## the choice list are plain DEV stand-ins until Batch 2 (C10–C12, C15); response pacing is a minimal
## stand-in for C03 using the same step/finish contract.

const REF := Vector2(1536, 864)
const SEED := 711
## VAS-001 composition, reference pixels.
const HEADER := Rect2(0, 0, 1536, 96)
const LOGO := Rect2(8, 4, 300, 89)
const TURN_ICON := Rect2(320, 31, 32, 32)
const TURN := Rect2(360, 13, 112, 69)
const PHASE := Rect2(488, 16, 252, 63)
const TRACE := Rect2(758, 11, 230, 74)
const AD := Rect2(1196, 1, 306, 94)
## ARCH-V2-003s (designer 2026-11-26 15:34): the ICE enclosure spans the full width; the CRT moves
## to the lower left and holds the rig; the effects note sits under it; END TURN is a small brown
## power button; the meters move to the right of the hand. The second CRT
## and the side pipe are gone. END TURN moved to the bottom-right corner (designer 15:37).
const ENCLOSURE := Rect2(6, 100, 1524, 499)
const LANE := Rect2(40, 134, 1456, 354)
const RAIL_HOUSING := Rect2(192, 494, 1152, 63)
const CRT := Rect2(6, 632, 262, 156)   ## cartridges stick up above it (ARCH-V2-003u)
const NOTE := Rect2(8, 794, 258, 66)
const END_TURN := Rect2(1464, 794, 64, 64)   ## designer 15:37: the very bottom-right corner
const TRAY := Rect2(272, 600, 984, 264)   ## ARCH-V2-003u: widened for up to 12 cards
const HAND := Rect2(296, 592, 952, 264)   ## fan area: cards overhang the tray top like VAS-001
const RACK := Rect2(1262, 604, 196, 196)
const COUNTERS := Rect2(1262, 806, 196, 52)   ## horizontal, under the meters (ARCH-V2-003u)

@export var auto_ready_rig := "FORTRESS_ICEPICK"
@export var step_seconds := 0.45
@export var reduced_motion := false
## Tests/fixtures: resolve the response without waiting.
var instant := false

var game: Game
var ctrl := EncounterController.new()
var stage: Control
var lane: IceLane
var rail: ResponseRail
var inspector: KeyInspector
var flyout: EventFlyout
var end_key: HudWidgets.EndTurnKey
var responding := false
var meters := {}
var turn_counter: HudWidgets.FlipCounter
var phase_plaque: HudWidgets.PhasePlaque
var trace_gauge: HudWidgets.TraceGauge
var counters: HudWidgets.CounterStack
var effect_card: HudWidgets.EffectCard
var signal_screen: HudWidgets.SignalScreen
var rig_bay: RigBay
var _hand_box: HBoxContainer
var hand_fan: HandFan
## ADP-2b: hovering one card 4 s makes the moodiest ICE say an approved hesitation line.
var voice := HesitationVoice.new()
var _prompt: Label
var _banner: PanelContainer
var _last_turn := 0
var _pending_target := -1

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build()
	get_viewport().size_changed.connect(_fit)
	_fit()
	if game == null: start(SEED)

func start(seed: int, rustler: String = "GENERALIST") -> void:
	game = Game.new(seed)
	game.new_run(rustler)
	game.rng.seed = seed
	game.animate = true
	game.row = 0
	game.available = [0]
	game.enter_node(0)   # N2A: AUTO-RENEW (FORTRESS) + CAPTCHA (TUMBLER)
	if game.phase == "READY_RIG" and auto_ready_rig != "":
		var pick := game.draw_pile.filter(func(c): return c.id == auto_ready_rig)
		if not pick.is_empty(): game.choose_ready_rig(pick[0].uid)
	ctrl = EncounterController.new()
	ctrl.bind(game)
	ctrl.changed.connect(refresh)
	ctrl.phase_changed.connect(_on_phase)
	_last_turn = 0
	_banner.hide()
	refresh()
	_announce_turn()

# ----- Build

func _build() -> void:
	var bg := TextureRect.new(); bg.name = "Chassis"
	bg.texture = V2Art.tex("chassis/V2_CHASSIS_TILE.png", 384)
	bg.stretch_mode = TextureRect.STRETCH_TILE
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	stage = Control.new(); stage.name = "Stage"; stage.size = REF; stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(stage)
	inspector = KeyInspector.new()
	_build_header()
	_build_left_rail()
	_build_enclosure()
	_build_tray()
	_build_meters()
	flyout = EventFlyout.new(); flyout.name = "EventFlyout"; flyout.position = Vector2.ZERO; flyout.size = REF
	flyout.band_y = 0.36
	stage.add_child(flyout)
	_banner = PanelContainer.new(); _banner.name = "Outcome"; stage.add_child(_banner)
	_banner.add_theme_stylebox_override("panel", _box(Color(VasTokens.CHASSIS, 0.94), VasTokens.AMBER, 4, 18, 24))
	var bb := VBoxContainer.new(); bb.alignment = BoxContainer.ALIGNMENT_CENTER; _banner.add_child(bb)
	bb.add_child(_label("", 40, VasTokens.AMBER, VasTokens.FONT_PLAQUE)); bb.get_child(0).name = "Title"
	bb.add_child(_button("RESTART ENCOUNTER", func(): start(SEED)))
	_banner.position = Vector2(REF.x / 2 - 260, 300); _banner.custom_minimum_size = Vector2(520, 180); _banner.hide()
	add_child(inspector)

func _fit() -> void:
	var vp := get_viewport_rect().size
	var k := minf(vp.x / REF.x, vp.y / REF.y)
	stage.scale = Vector2(k, k)
	stage.position = (vp - REF * k) / 2.0

func _art(rel: String, r: Rect2, n: String) -> TextureRect:
	var t := V2Art.rect(rel, r.position, r.size, n)
	stage.add_child(t)
	return t

func _build_header() -> void:
	_art("chassis/V2_HEADER_BAR.png", HEADER, "HeaderBar")
	var logo := _art("chassis/V2_LOGO_PLATE.png", LOGO, "Logo")
	var title := _label("PANOPTICON", 40, VasTokens.AMBER, VasTokens.FONT_PLAQUE)
	title.position = Vector2(LOGO.size.x * 0.27, LOGO.size.y * 0.18); logo.add_child(title)
	var ti := TextureRect.new(); ti.name = "TurnIcon"; ti.texture = IceKey.art("ICON_TIMING_LIGHT")
	ti.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; ti.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ti.modulate = Color(VasTokens.IVORY, 0.85); ti.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(ti)
	ti.position = TURN_ICON.position; ti.size = TURN_ICON.size; ti.custom_minimum_size = TURN_ICON.size
	turn_counter = HudWidgets.FlipCounter.new(); turn_counter.name = "Turn"; turn_counter.inspector = inspector
	turn_counter.setup(TURN.size); turn_counter.position = TURN.position; stage.add_child(turn_counter)
	phase_plaque = HudWidgets.PhasePlaque.new(); phase_plaque.name = "Phase"; phase_plaque.inspector = inspector
	phase_plaque.setup(PHASE.size); phase_plaque.position = PHASE.position; stage.add_child(phase_plaque)
	trace_gauge = HudWidgets.TraceGauge.new(); trace_gauge.name = "Trace"; trace_gauge.inspector = inspector
	trace_gauge.setup(TRACE.size); trace_gauge.position = TRACE.position; stage.add_child(trace_gauge)
	var ad := _art("chassis/V2_AD_PLATE_HALCYON.png", AD, "AdPlate")
	# Approved HALCYON programme line (arch_copy.json, approval "approved").
	var copy := _label("A Halcyon Homesteads™\ncommunity", 19, Color("#8E2A1E"), VasTokens.FONT_PLAQUE_SEMI)
	copy.add_theme_constant_override("line_spacing", -4)
	copy.position = Vector2(AD.size.x * 0.07, AD.size.y * 0.3); ad.add_child(copy)

func _build_left_rail() -> void:
	## Lower left (ARCH-V2-003s): the CRT holds the rig (installed programs as draggable chips),
	## the effects note sits under it.
	rig_bay = RigBay.new(); rig_bay.name = "RigBay"; rig_bay.inspector = inspector
	rig_bay.position = Vector2.ZERO; rig_bay.size = REF
	rig_bay.crt_rect = CRT
	rig_bay.screen_rect = Rect2(CRT.position + CRT.size * Vector2(0.14, 0.15), CRT.size * Vector2(0.64, 0.70))
	rig_bay.slot_y = CRT.position.y + 10.0
	rig_bay.build(V2Art.tex("crt/V2_CRT_SMALL.png", CRT.size.x), V2Art.tex("crt/V2_CRT_GLASS.png", CRT.size.x))
	rig_bay.selected.connect(func(uid): ctrl.active_program = uid; refresh())
	rig_bay.action_requested.connect(func(kind, uid):
		match kind:
			"boost": ctrl.request_boost(uid)
			"cache": ctrl.request_uninstall_cache(uid)
			"eject": ctrl.request_unload(uid)
		refresh())
	stage.add_child(rig_bay)
	effect_card = HudWidgets.EffectCard.new(); effect_card.name = "Effects"
	effect_card.setup(NOTE.size, inspector); effect_card.position = NOTE.position; stage.add_child(effect_card)

func _build_meters() -> void:
	## Right of the hand (ARCH-V2-003s): VITAE, BW, RAM, SHIELD, incoming PULP; icon + number.
	_art("controls/V2_METER_RACK.png", RACK, "MeterRack")
	var defs := [["VITAE", IceKey.art("ICON_VITAE"), Color("#E23B2E")], ["BW", IceKey.art("ICON_BW"), VasTokens.AMBER],
		["RAM", null, Color("#7FE0D0")], ["SHIELD", IceKey.art("ICON_SHIELD"), Color("#6C8CFF")], ["PULP", IceKey.art("ICON_PULP_LIGHT"), Color("#FF7A4A")]]
	var rw := RACK.size.x - 24.0
	var rh := rw / 5.84
	for k in defs.size():
		var m := HudWidgets.MeterRow.new(); m.name = "Meter" + defs[k][0]; m.inspector = inspector
		m.setup(Vector2(rw, rh), defs[k][1], defs[k][2])
		if defs[k][0] == "RAM": m.draw_glyph = "ram"
		m.position = RACK.position + Vector2(12, 12 + k * (rh + (RACK.size.y - 24 - 5 * rh) / 4.0))
		stage.add_child(m)
		meters[defs[k][0]] = m

func _build_enclosure() -> void:
	var inner := ENCLOSURE.grow(-24)
	var back := TextureRect.new(); back.name = "EnclosureBack"; back.texture = V2Art.tex("chassis/V2_ENCLOSURE_BACK.png", 300)
	back.stretch_mode = TextureRect.STRETCH_TILE; back.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	back.position = inner.position; back.size = inner.size; back.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(back)
	lane = IceLane.new(); lane.name = "IceLane"; lane.position = LANE.position; lane.size = LANE.size
	lane.inspector = inspector
	lane.drop_check = func(ice_ref: Dictionary, sub: int, uid: int) -> Dictionary:
		var i := ctrl.ice_index(ice_ref)
		return game.break_info(i, sub, uid) if i >= 0 and game.phase == "PLAYER" else {"ok": false}
	lane.break_requested.connect(func(r, s, u): ctrl.request_break(r, s, u))
	stage.add_child(lane)
	_art("controls/V2_RAIL_HOUSING.png", RAIL_HOUSING, "RailHousing")
	rail = ResponseRail.new()
	rail.height = 30.0
	rail.position = RAIL_HOUSING.position + Vector2(RAIL_HOUSING.size.x * 0.16, RAIL_HOUSING.size.y * 0.18)
	rail.size = Vector2(RAIL_HOUSING.size.x * 0.68, RAIL_HOUSING.size.y * 0.64)
	rail.inspector = inspector
	stage.add_child(rail)
	_art("chassis/V2_ENCLOSURE_FRAME.png", ENCLOSURE, "EnclosureFrame")

func _build_tray() -> void:
	_art("controls/V2_TRAY.png", TRAY, "Tray")
	## ARCH-V2-003o: the hand is fanned across the tray as in VAS-001; cards rise above the
	## tray's top edge like the reference. Target and choice prompts use a plain row.
	hand_fan = HandFan.new(); hand_fan.name = "HandFan"; hand_fan.reduced_motion = reduced_motion
	hand_fan.card_size = Vector2(140, 221)   ## HuCard 1 : 1.58; twelve cards keep half of each showing
	hand_fan.position = HAND.position; hand_fan.size = HAND.size; stage.add_child(hand_fan)
	var v := VBoxContainer.new(); v.position = TRAY.position + Vector2(36, 26); v.size = TRAY.size - Vector2(72, 70)
	v.add_theme_constant_override("separation", 6); v.mouse_filter = Control.MOUSE_FILTER_IGNORE; stage.add_child(v)
	_prompt = _label("", 14, Color(VasTokens.IVORY, 0.75), VasTokens.FONT_PLAQUE_SEMI); v.add_child(_prompt)
	_hand_box = HBoxContainer.new(); _hand_box.add_theme_constant_override("separation", 10)
	_hand_box.alignment = BoxContainer.ALIGNMENT_CENTER; _hand_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(_hand_box)
	counters = HudWidgets.CounterStack.new(); counters.name = "Counters"
	counters.setup(COUNTERS.size, inspector, true); counters.position = COUNTERS.position; stage.add_child(counters)
	end_key = HudWidgets.EndTurnKey.new(); end_key.name = "EndTurn"; end_key.inspector = inspector
	end_key.setup(Vector2(END_TURN.size.x, END_TURN.size.y)); end_key.position = END_TURN.position
	end_key.pressed.connect(end_turn)
	stage.add_child(end_key)

# ----- Flow

func end_turn() -> void:
	if responding: return
	if ctrl.end_turn() and game.phase == "RESPONSE":
		await play_response()

func play_response() -> void:
	## Minimal C03 stand-in: light the key, resolve exactly one step, repeat; then finish once.
	responding = true
	refresh()
	if not instant: await _wait(VasTokens.flyout_total() * 0.6)
	while ctrl.response_pending() and game.phase == "RESPONSE":
		ctrl.peek_response()
		if not instant: await _wait(step_seconds * 0.5)
		ctrl.step_response()
		if not instant: await _wait(step_seconds)
	if game.phase == "RESPONSE": ctrl.finish_response()
	responding = false
	refresh()

func _wait(s: float) -> void:
	await get_tree().create_timer(s).timeout

func _on_phase(_old: String, new_phase: String) -> void:
	if new_phase == "RESPONSE": flyout.announce("corp_countermeasure")
	_announce_turn()

func _announce_turn() -> void:
	if game == null or game.enc.is_empty(): return
	if game.phase in ["PLAYER", "CHOICE"] and int(game.enc.turn) != _last_turn:
		_last_turn = int(game.enc.turn)
		flyout.announce("rustler_turn")

# ----- Refresh

func refresh() -> void:
	if game == null: return
	ctrl.rebind_if_new_encounter()
	flyout.reduced_motion = reduced_motion
	lane.reduced_motion = reduced_motion
	if signal_screen: signal_screen.reduced_motion = reduced_motion
	hand_fan.reduced_motion = reduced_motion
	if not game.enc.is_empty():
		lane.sync(VisibleStateAdapter.ice_models(game, ctrl))
		rail.sync(VisibleStateAdapter.response_model(game, ctrl))
	_refresh_inspector()
	turn_counter.set_value(int(game.enc.get("turn", 0)))
	phase_plaque.set_phase(game.phase == "RESPONSE")
	trace_gauge.set_value(game.trace)
	meters.VITAE.set_value(game.vitae, game.max_vitae, 10, str(game.vitae), "VITAE %d / %d" % [game.vitae, game.max_vitae])
	meters.BW.set_value(game.bw, Game.BW_PER_TURN, Game.BW_PER_TURN, str(game.bw), "BANDWIDTH %d" % game.bw)
	meters.RAM.set_value(game.ram_used(), game.ram_total(), game.ram_total(), "%d/%d" % [game.ram_used(), game.ram_total()], "RAM %d / %d" % [game.ram_used(), game.ram_total()])
	meters.SHIELD.set_value(game.shield, 10, 10, str(game.shield), "SHIELD %d" % game.shield)
	var incoming := VisibleStateAdapter.incoming_pulp(game)
	meters.PULP.set_value(incoming, maxi(1, game.vitae), 10, str(incoming), "PULP INCOMING %d" % incoming)
	counters.set_counts(game.draw_pile.size(), game.discard.size(), _burned_count())
	effect_card.set_stamps(_stamps())
	end_key.set_enabled(not responding and game.phase == "PLAYER")
	_refresh_rig()
	_refresh_hand()
	var done := not (game.phase in ["PLAYER", "RESPONSE", "CHOICE", "READY_RIG"])
	_banner.visible = done and not responding
	if _banner.visible:
		var title: Label = _banner.find_child("Title", true, false)
		title.text = "FLATLINED" if game.phase == "DEAD" else ("ENCOUNTER COMPLETE · " + game.phase)

func _burned_count() -> int:
	for k in ["burned", "burn_pile", "exiled"]:
		var v: Variant = game.get(k)
		if v is Array: return v.size()
	return 0

func _stamps() -> Array:
	var out := []
	if game.cortex > 0: out.append({"icon": IceKey.art("ICON_CORTEX_LIGHT"), "n": game.cortex, "title": "CORTEX %d" % game.cortex})
	var drain := int(game.enc.get("bw_drain", 0))
	if drain > 0: out.append({"icon": IceKey.art("ICON_BW_DRAIN_LIGHT"), "n": drain, "title": "−%d BW NEXT TURN" % drain})
	return out

func _refresh_inspector() -> void:
	var s: Variant = inspector.subject
	if s is SubroutineKey and is_instance_valid(s) and s.is_inside_tree() and inspector.visible:
		var p: Node = s.get_parent()
		while p and not (p is IcePanel): p = p.get_parent()
		inspector.show_key(s, String(p.model.name) if p else "")
	elif s != null and not (is_instance_valid(s) and s.is_inside_tree()):
		inspector.close()

func _refresh_rig() -> void:
	var progs := []
	for p in game.installed:
		var d := CardDB.def(p.inst.id)
		var pk: Dictionary = d.get("pick", {})
		progs.append({"uid": int(p.inst.uid), "name": String(d.name), "pick": d.has("pick"),
			"str": game.pick_str(p) if d.has("pick") else 0, "text": String(d.get("text", "")),
			"itype": String(pk.get("itype", "")), "break_cost": int(pk.get("break_cost", 0)),
			"boost": game.can_boost(int(p.inst.uid)) if d.has("pick") else {},
			"cache": d.get("uninstall_cache", false), "cache_ok": game.can_uninstall_cache(int(p.inst.uid)).get("ok", false),
			"can_unload": game.phase == "PLAYER" and not responding})
	var act := ctrl.active_program if not game._installed_entry(ctrl.active_program).is_empty() else ctrl.active_pick()
	rig_bay.sync(progs, act)

func _refresh_hand() -> void:
	for c in _hand_box.get_children(): _hand_box.remove_child(c); c.queue_free()
	hand_fan.clear()
	_prompt.text = ""
	if game.phase == "READY_RIG":
		_prompt.text = "DEV · READY RIG"
		for c in game.draw_pile.filter(func(c): return CardDB.def(c.id).type == "PROGRAM"):
			hand_fan.add_card(_card_button(c, func(): ctrl.request_choice(int(c.uid))))
		return
	if game.phase == "CHOICE":
		var k := String(game.pending.get("kind", ""))
		if k == "card_break":
			_prompt.text = "DEV · CHOOSE A KEY"
			return
		_prompt.text = "DEV · CHOOSE: %s" % k.to_upper().replace("_", " ")
		var options: Array = game.pending.get("cards", game.hand)
		for c in options: hand_fan.add_card(_card_button(c, func(): ctrl.request_choice(int(c.uid))))
		return
	if _pending_target >= 0:
		_prompt.text = "DEV · CHOOSE AN ICE"
		for m in VisibleStateAdapter.ice_models(game, ctrl):
			var r: Dictionary = m.ref
			_hand_box.add_child(_button("→ " + String(m.name), func(): var u := _pending_target; _pending_target = -1; ctrl.request_play(u, r); refresh()))
		_hand_box.add_child(_button("CANCEL", func(): _pending_target = -1; refresh()))
		return
	for c in game.hand:
		var uid := int(c.uid)
		var b := _card_button(c, func():
			if CardDB.def(c.id).get("target", false): _pending_target = uid; refresh()
			else: ctrl.request_play(uid))
		b.disabled = not game.can_play(uid).ok or responding
		hand_fan.add_card(b)

# ----- Small builders

func _process(delta: float) -> void:
	if game == null or game.enc.is_empty() or hand_fan == null: return
	var h := hand_fan.hovered
	var uid := int(h.get_meta("uid", -1)) if is_instance_valid(h) else -1
	var said := voice.tick(delta, Time.get_ticks_msec() / 1000.0, uid, get_viewport().gui_is_dragging(), game.phase,
		int(game.enc.get("turn", 0)), String(game.enc.get("corp", "HALCYON")), lane.panels().map(func(p): return p.model))
	if not said.is_empty(): lane.panels()[int(said.ice)].say(String(said.text), voice.seconds)

func _card_button(c: Dictionary, on_press: Callable) -> Button:
	## DEV stand-in in HuCard proportions (CARD-HUCARD-001: 1 : 1.58); Batch 2 replaces it.
	var d := CardDB.def(c.id)
	var b := _button("%s\n\n%d BW" % [String(d.name), int(d.get("bw", 0))], on_press)
	b.set_meta("uid", int(c.uid))
	b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return b

func _button(text: String, on_press: Callable) -> Button:
	var b := Button.new(); b.text = text
	b.add_theme_font_override("font", VasTokens.FONT_PLAQUE_SEMI); b.add_theme_font_size_override("font_size", 16)
	b.add_theme_color_override("font_color", VasTokens.CHASSIS)
	b.add_theme_color_override("font_hover_color", VasTokens.CHASSIS)
	b.add_theme_color_override("font_disabled_color", Color("#6E5D4E"))
	b.add_theme_stylebox_override("normal", _box(VasTokens.IVORY, VasTokens.BRONZE, 3, 10))
	b.add_theme_stylebox_override("hover", _box(Color("#FFF4D8"), VasTokens.COPPER, 3, 10))
	b.add_theme_stylebox_override("pressed", _box(Color("#E8D6AE"), VasTokens.COPPER, 3, 10))
	b.add_theme_stylebox_override("disabled", _box(Color("#B9AB90"), Color("#6E5D4E"), 3, 10))
	b.add_theme_stylebox_override("focus", _box(Color.TRANSPARENT, VasTokens.FOCUS, 3, 10))
	b.pressed.connect(on_press)
	return b

func _box(fill: Color, border: Color, bw: int, radius: int, margin: int = 8) -> StyleBoxFlat:
	var s := StyleBoxFlat.new(); s.bg_color = fill; s.border_color = border; s.set_border_width_all(bw)
	s.set_corner_radius_all(radius); s.set_content_margin_all(margin); s.anti_aliasing = true
	return s

func _label(text: String, px: int, col: Color, font: Font) -> Label:
	var l := Label.new(); l.text = text
	l.add_theme_font_override("font", font); l.add_theme_font_size_override("font_size", px)
	l.add_theme_color_override("font_color", col); l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l
