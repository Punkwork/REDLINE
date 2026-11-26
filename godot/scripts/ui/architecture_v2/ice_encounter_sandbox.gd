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
const CRT_SMALL := Rect2(8, 104, 258, 166)
const RACK := Rect2(14, 276, 246, 214)
const NOTE := Rect2(12, 496, 240, 105)
const CRT_LARGE := Rect2(8, 606, 254, 200)
const ENCLOSURE := Rect2(272, 100, 1232, 499)
const LANE := Rect2(312, 140, 1152, 346)
const RAIL_HOUSING := Rect2(312, 494, 1152, 63)
const TRAY := Rect2(272, 600, 930, 264)
const COUNTERS := Rect2(1214, 624, 132, 165)
const END_TURN := Rect2(1372, 650, 112, 160)
const PIPE_X := 1510.0

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
var _rig_box: VBoxContainer
var _hand_box: HBoxContainer
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
	_build_pipe()
	_build_header()
	_build_left_rail()
	_build_enclosure()
	_build_tray()
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

func _build_pipe() -> void:
	var tile := V2Art.tex("controls/V2_PIPE_V.png", 20)
	var p := TextureRect.new(); p.name = "Pipe"; p.texture = tile
	p.stretch_mode = TextureRect.STRETCH_TILE; p.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	p.position = Vector2(PIPE_X, 90); p.size = Vector2(20, REF.y - 90); p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stage.add_child(p)
	for y in [300.0, 640.0]:
		_art("controls/V2_PIPE_JOINT.png", Rect2(PIPE_X - 8, y, 36, 36), "PipeJoint")

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
	signal_screen = HudWidgets.SignalScreen.new(); signal_screen.name = "SignalScreen"
	signal_screen.position = CRT_SMALL.position + CRT_SMALL.size * Vector2(0.15, 0.15); signal_screen.size = CRT_SMALL.size * Vector2(0.62, 0.70)
	stage.add_child(signal_screen)
	_art("crt/V2_CRT_SMALL.png", CRT_SMALL, "CrtSmall")
	_art("crt/V2_CRT_GLASS.png", Rect2(signal_screen.position, signal_screen.size), "CrtSmallGlass")
	_art("controls/V2_METER_RACK.png", RACK, "MeterRack")
	var defs := [["VITAE", IceKey.art("ICON_VITAE"), Color("#E23B2E")], ["BW", IceKey.art("ICON_BW"), VasTokens.AMBER],
		["RAM", null, Color("#7FE0D0")], ["SHIELD", IceKey.art("ICON_SHIELD"), Color("#6C8CFF")], ["PULP", IceKey.art("ICON_PULP_LIGHT"), Color("#FF7A4A")]]
	var rw := RACK.size.x - 28.0
	var rh := rw / 5.84
	for k in defs.size():
		var m := HudWidgets.MeterRow.new(); m.name = "Meter" + defs[k][0]; m.inspector = inspector
		m.setup(Vector2(rw, rh), defs[k][1], defs[k][2])
		if defs[k][0] == "RAM": m.draw_glyph = "ram"
		m.position = RACK.position + Vector2(14, 12 + k * (rh + (RACK.size.y - 24 - 5 * rh) / 4.0))
		stage.add_child(m)
		meters[defs[k][0]] = m
	effect_card = HudWidgets.EffectCard.new(); effect_card.name = "Effects"
	effect_card.setup(NOTE.size, inspector); effect_card.position = NOTE.position; stage.add_child(effect_card)
	var screen := Rect2(CRT_LARGE.position + CRT_LARGE.size * Vector2(0.15, 0.15), CRT_LARGE.size * Vector2(0.70, 0.70))
	var back := ColorRect.new(); back.color = Color("#06231A"); back.position = screen.position; back.size = screen.size
	back.mouse_filter = Control.MOUSE_FILTER_IGNORE; stage.add_child(back)
	_art("crt/V2_CRT_LARGE.png", CRT_LARGE, "CrtLarge")
	_art("crt/V2_CRT_GLASS.png", screen, "CrtLargeGlass")
	_rig_box = VBoxContainer.new(); _rig_box.name = "Rig"
	_rig_box.position = screen.position + Vector2(10, 10); _rig_box.size = screen.size - Vector2(20, 20)
	_rig_box.add_theme_constant_override("separation", 6)
	stage.add_child(_rig_box)

func _build_enclosure() -> void:
	var inner := ENCLOSURE.grow(-30)
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
	var v := VBoxContainer.new(); v.position = TRAY.position + Vector2(36, 26); v.size = TRAY.size - Vector2(72, 70)
	v.add_theme_constant_override("separation", 6); stage.add_child(v)
	_prompt = _label("", 14, Color(VasTokens.IVORY, 0.75), VasTokens.FONT_PLAQUE_SEMI); v.add_child(_prompt)
	_hand_box = HBoxContainer.new(); _hand_box.add_theme_constant_override("separation", 10)
	_hand_box.alignment = BoxContainer.ALIGNMENT_CENTER; _hand_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(_hand_box)
	counters = HudWidgets.CounterStack.new(); counters.name = "Counters"
	counters.setup(COUNTERS.size, inspector); counters.position = COUNTERS.position; stage.add_child(counters)
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
	signal_screen.reduced_motion = reduced_motion
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
	for c in _rig_box.get_children(): _rig_box.remove_child(c); c.queue_free()
	for p in game.installed:
		var d := CardDB.def(p.inst.id)
		var chip := HudWidgets.RigChip.new()
		chip.inspector = inspector
		chip.uid = int(p.inst.uid)
		chip.pick = d.has("pick")
		chip.str_value = game.pick_str(p) if chip.pick else 0
		chip.active = ctrl.active_program == chip.uid
		chip.ico = IceKey.art("ICON_BREAK_LIGHT") if chip.pick else IceKey.art("ICON_PASSIVE_LIGHT")
		chip.title = String(d.name) + ("  ·  STR %d" % chip.str_value if chip.pick else "")
		chip.custom_minimum_size = Vector2(0, 30)
		_rig_box.add_child(chip)

func _refresh_hand() -> void:
	for c in _hand_box.get_children(): _hand_box.remove_child(c); c.queue_free()
	if game.phase == "READY_RIG":
		_prompt.text = "DEV · READY RIG"
		for c in game.draw_pile.filter(func(c): return CardDB.def(c.id).type == "PROGRAM"):
			_hand_box.add_child(_card_button(c, func(): ctrl.request_choice(int(c.uid))))
		return
	if game.phase == "CHOICE":
		var k := String(game.pending.get("kind", ""))
		if k == "card_break":
			_prompt.text = "DEV · CHOOSE A KEY"
			return
		_prompt.text = "DEV · CHOOSE: %s" % k.to_upper().replace("_", " ")
		var options: Array = game.pending.get("cards", game.hand)
		for c in options: _hand_box.add_child(_card_button(c, func(): ctrl.request_choice(int(c.uid))))
		return
	if _pending_target >= 0:
		_prompt.text = "DEV · CHOOSE AN ICE"
		for m in VisibleStateAdapter.ice_models(game, ctrl):
			var r: Dictionary = m.ref
			_hand_box.add_child(_button("→ " + String(m.name), func(): var u := _pending_target; _pending_target = -1; ctrl.request_play(u, r); refresh()))
		_hand_box.add_child(_button("CANCEL", func(): _pending_target = -1; refresh()))
		return
	_prompt.text = "DEV · HAND (cards arrive in Batch 2)"
	for c in game.hand:
		var uid := int(c.uid)
		var b := _card_button(c, func():
			if CardDB.def(c.id).get("target", false): _pending_target = uid; refresh()
			else: ctrl.request_play(uid))
		b.disabled = not game.can_play(uid).ok or responding
		_hand_box.add_child(b)

# ----- Small builders

func _card_button(c: Dictionary, on_press: Callable) -> Button:
	## DEV stand-in in HuCard proportions (CARD-HUCARD-001: 1 : 1.58); Batch 2 replaces it.
	var d := CardDB.def(c.id)
	var b := _button("%s\n\n%d BW" % [String(d.name), int(d.get("bw", 0))], on_press)
	b.custom_minimum_size = Vector2(112, 177)
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
