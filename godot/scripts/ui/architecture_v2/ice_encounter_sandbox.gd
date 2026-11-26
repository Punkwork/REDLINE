class_name IceEncounterSandbox
extends Control
## ARCH-V2-003 Batch 1 harness: the representative ICE encounter (N2A CAPTCHA: AUTO-RENEW + CAPTCHA) on
## the Architecture V2 components, in the VAS-001 1536×864 reference composition inside the existing
## 1600×1000 window. Real Game state; every action goes through EncounterController.
##
## Not the app entry (Main.tscn is untouched). Open in the editor (F6) or from tests. The hand, rig,
## readouts, log and choice list are plain DEV stand-ins until Batch 2 (C10–C12, C15) and Batch 3 (C13).
## The response pacing here is a minimal stand-in for C03 using the same step/finish contract.

const REF := Vector2(1536, 864)
const SEED := 711
## VAS-001 §3 zones in reference coordinates.
const LANE := Rect2(284, 104, 1244, 412)
const RAIL := Rect2(284, 524, 1244, 70)
const HUD := Rect2(0, 0, 1536, 96)
const LEFT := Rect2(8, 104, 268, 490)
const TRAY := Rect2(284, 606, 916, 250)
const TURN := Rect2(1208, 606, 320, 250)

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
var end_button: Button
var responding := false
var _hud: Dictionary = {}
var _hand_box: HFlowContainer
var _rig_box: VBoxContainer
var _log: Label
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
	var bg := ColorRect.new(); bg.color = VasTokens.CHASSIS; bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE; add_child(bg)
	stage = Control.new(); stage.name = "Stage"; stage.size = REF; stage.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(stage)
	_plate(Rect2(0, 0, REF.x, REF.y), VasTokens.BAKELITE, VasTokens.BRONZE, 0, 10, "Chassis")
	_plate(Rect2(LANE.position - Vector2(6, 4), LANE.size + Vector2(12, 8)), Color("#2B1E18"), VasTokens.COPPER, 4, 26, "IceWell")
	# ICE lane (C07) with its panels (C08) and keys (C09)
	inspector = KeyInspector.new()
	lane = IceLane.new(); lane.name = "IceLane"; lane.position = LANE.position; lane.size = LANE.size
	lane.inspector = inspector
	lane.drop_check = func(ice_ref: Dictionary, sub: int, uid: int) -> Dictionary:
		var i := ctrl.ice_index(ice_ref)
		return game.break_info(i, sub, uid) if i >= 0 and game.phase == "PLAYER" else {"ok": false}
	lane.break_requested.connect(func(r, s, u): ctrl.request_break(r, s, u))
	stage.add_child(lane)
	rail = ResponseRail.new(); rail.position = RAIL.position; rail.size = RAIL.size; rail.custom_minimum_size = RAIL.size
	rail.inspector = inspector
	stage.add_child(rail)
	_build_hud()
	_build_left()
	_build_tray()
	_build_turn()
	flyout = EventFlyout.new(); flyout.name = "EventFlyout"; flyout.position = Vector2.ZERO; flyout.size = REF
	flyout.band_y = 0.30
	stage.add_child(flyout)
	_banner = PanelContainer.new(); _banner.name = "Outcome"; stage.add_child(_banner)
	_banner.add_theme_stylebox_override("panel", _box(Color(VasTokens.CHASSIS, 0.94), VasTokens.AMBER, 4, 18, 24))
	var bb := VBoxContainer.new(); bb.alignment = BoxContainer.ALIGNMENT_CENTER; _banner.add_child(bb)
	bb.add_child(_label("", 40, VasTokens.AMBER, VasTokens.FONT_PLAQUE)); bb.get_child(0).name = "Title"
	var again := _button("RESTART ENCOUNTER", func(): start(SEED)); bb.add_child(again)
	_banner.position = Vector2(REF.x / 2 - 260, 300); _banner.custom_minimum_size = Vector2(520, 180); _banner.hide()
	add_child(inspector)

func _fit() -> void:
	var vp := get_viewport_rect().size
	var k := minf(vp.x / REF.x, vp.y / REF.y)
	stage.scale = Vector2(k, k)
	stage.position = (vp - REF * k) / 2.0

func _build_hud() -> void:
	var bar := _plate(HUD, VasTokens.CHASSIS, VasTokens.COPPER, 3, 12, "TopBar")
	var title := _label("PANOPTICON", 30, VasTokens.IVORY, VasTokens.FONT_PLAQUE); title.position = Vector2(24, 14); bar.add_child(title)
	var sub := _label("ARCHITECTURE V2 · ICE ENCOUNTER SANDBOX · DEV", 13, VasTokens.COPPER, VasTokens.FONT_PLAQUE_SEMI); sub.position = Vector2(26, 56); bar.add_child(sub)
	var x := 520.0
	for k in ["TURN", "VITAE", "BW", "SHIELD", "TRACE", "RESERVE"]:
		var plate := _plate(Rect2(x, 14, 150, 66), Color("#120D0B"), VasTokens.BRONZE, 3, 10, "Hud" + k)
		bar.add_child(plate)
		var cap := _label(k, 13, VasTokens.COPPER, VasTokens.FONT_PLAQUE_SEMI); cap.position = Vector2(12, 4); plate.add_child(cap)
		var val := _label("", 30, VasTokens.PHOSPHOR, VasTokens.FONT_READOUT); val.position = Vector2(12, 20); plate.add_child(val)
		_hud[k] = val
		x += 162.0
	stage.add_child(bar)

func _build_left() -> void:
	var p := _plate(LEFT, Color("#120D0B"), VasTokens.BRONZE, 3, 14, "LeftRail")
	stage.add_child(p)
	var v := VBoxContainer.new(); v.position = Vector2(12, 10); v.size = LEFT.size - Vector2(24, 20); p.add_child(v)
	v.add_child(_label("RIG · DRAG AN ICEPICK ONTO A KEY", 13, VasTokens.COPPER, VasTokens.FONT_PLAQUE_SEMI))
	_rig_box = VBoxContainer.new(); _rig_box.add_theme_constant_override("separation", 6); v.add_child(_rig_box)
	var gap := Control.new(); gap.custom_minimum_size.y = 10; v.add_child(gap)
	v.add_child(_label("LOG", 13, VasTokens.COPPER, VasTokens.FONT_PLAQUE_SEMI))
	_log = _label("", 13, VasTokens.PHOSPHOR, VasTokens.FONT_RULES)
	_log.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; _log.custom_minimum_size = Vector2(LEFT.size.x - 24, 0)
	_log.size_flags_vertical = Control.SIZE_EXPAND_FILL; _log.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM; _log.clip_text = true
	v.add_child(_log)

func _build_tray() -> void:
	var p := _plate(TRAY, Color("#5A3A26"), VasTokens.COPPER, 4, 18, "Tray")
	stage.add_child(p)
	var v := VBoxContainer.new(); v.position = Vector2(14, 10); v.size = TRAY.size - Vector2(28, 20); p.add_child(v)
	_prompt = _label("", 15, VasTokens.IVORY, VasTokens.FONT_PLAQUE_SEMI); v.add_child(_prompt)
	_hand_box = HFlowContainer.new(); _hand_box.add_theme_constant_override("h_separation", 8); _hand_box.add_theme_constant_override("v_separation", 8)
	_hand_box.size_flags_vertical = Control.SIZE_EXPAND_FILL; v.add_child(_hand_box)

func _build_turn() -> void:
	var p := _plate(TURN, Color("#2B1E18"), VasTokens.COPPER, 4, 18, "TurnControl")
	stage.add_child(p)
	_hud["DECK"] = _label("", 15, VasTokens.IVORY, VasTokens.FONT_PLAQUE_SEMI); _hud["DECK"].position = Vector2(20, 16); p.add_child(_hud["DECK"])
	end_button = Button.new(); end_button.name = "EndTurn"; end_button.text = "END TURN"
	end_button.position = Vector2(60, 70); end_button.size = Vector2(200, 140); end_button.custom_minimum_size = end_button.size
	end_button.add_theme_font_override("font", VasTokens.FONT_PLAQUE); end_button.add_theme_font_size_override("font_size", 36)
	end_button.add_theme_color_override("font_color", VasTokens.CHASSIS)
	end_button.add_theme_color_override("font_hover_color", VasTokens.CHASSIS)
	end_button.add_theme_color_override("font_disabled_color", Color("#5C4A3C"))
	end_button.add_theme_stylebox_override("normal", _box(VasTokens.IVORY, VasTokens.WARNING, 6, 22))
	end_button.add_theme_stylebox_override("hover", _box(Color("#FFF4D8"), VasTokens.WARNING, 6, 22))
	end_button.add_theme_stylebox_override("pressed", _box(Color("#E8D6AE"), VasTokens.WARNING, 6, 22))
	end_button.add_theme_stylebox_override("disabled", _box(Color("#C9B99A"), Color("#7A5A44"), 6, 22))
	end_button.add_theme_stylebox_override("focus", _box(Color.TRANSPARENT, VasTokens.FOCUS, 4, 22))
	end_button.pressed.connect(end_turn)
	p.add_child(end_button)

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
	if not game.enc.is_empty():
		lane.sync(VisibleStateAdapter.ice_models(game, ctrl))
		rail.sync(VisibleStateAdapter.response_model(game, ctrl))
	_refresh_inspector()
	_hud.TURN.text = "%02d" % int(game.enc.get("turn", 0))
	_hud.VITAE.text = "%d/%d" % [game.vitae, Game.START_VITAE]
	_hud.BW.text = str(game.bw)
	_hud.SHIELD.text = str(game.shield)
	_hud.TRACE.text = str(game.trace)
	_hud.RESERVE.text = str(int(game.enc.get("reserve", 0)))
	_hud.DECK.text = "DECK %d · DISCARD %d · HAND %d" % [game.draw_pile.size(), game.discard.size(), game.hand.size()]
	_log.text = "\n".join(game.log.slice(maxi(0, game.log.size() - 8)))
	end_button.disabled = responding or game.phase != "PLAYER"
	_refresh_rig()
	_refresh_hand()
	var done := not (game.phase in ["PLAYER", "RESPONSE", "CHOICE", "READY_RIG"])
	_banner.visible = done and not responding
	if _banner.visible:
		var title: Label = _banner.find_child("Title", true, false)
		title.text = "FLATLINED" if game.phase == "DEAD" else ("ENCOUNTER COMPLETE · " + game.phase)

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
		var chip := RigChip.new()
		chip.uid = int(p.inst.uid)
		chip.text = "%s · STR %d" % [String(d.name), game.pick_str(p)] if d.has("pick") else String(d.name)
		chip.disabled = not d.has("pick")
		chip.focus_mode = Control.FOCUS_NONE
		chip.custom_minimum_size = Vector2(240, 44)
		_style_chip(chip, ctrl.active_program == chip.uid)
		_rig_box.add_child(chip)

func _refresh_hand() -> void:
	for c in _hand_box.get_children(): _hand_box.remove_child(c); c.queue_free()
	if game.phase == "READY_RIG":
		_prompt.text = "READY RIG: install one program for free"
		for c in game.draw_pile.filter(func(c): return CardDB.def(c.id).type == "PROGRAM"):
			_hand_box.add_child(_card_button(c, func(): ctrl.request_choice(int(c.uid))))
		return
	if game.phase == "CHOICE":
		var k := String(game.pending.get("kind", ""))
		if k == "card_break":
			_prompt.text = "CHOOSE A SUBROUTINE TO BREAK (click a key)"
			return
		_prompt.text = "CHOOSE · %s" % k.to_upper().replace("_", " ")
		var options: Array = game.pending.get("cards", game.hand)
		for c in options: _hand_box.add_child(_card_button(c, func(): ctrl.request_choice(int(c.uid))))
		return
	if _pending_target >= 0:
		_prompt.text = "TARGET: choose an ICE"
		for m in VisibleStateAdapter.ice_models(game, ctrl):
			var r: Dictionary = m.ref
			_hand_box.add_child(_button("→ " + String(m.name), func(): var u := _pending_target; _pending_target = -1; ctrl.request_play(u, r); refresh()))
		_hand_box.add_child(_button("CANCEL", func(): _pending_target = -1; refresh()))
		return
	_prompt.text = "HAND · DEV STAND-IN (cards arrive in Batch 2)"
	for c in game.hand:
		var uid := int(c.uid)
		var b := _card_button(c, func():
			if CardDB.def(c.id).get("target", false): _pending_target = uid; refresh()
			else: ctrl.request_play(uid))
		b.disabled = not game.can_play(uid).ok or responding
		_hand_box.add_child(b)

# ----- Small builders

func _card_button(c: Dictionary, on_press: Callable) -> Button:
	var d := CardDB.def(c.id)
	var b := _button("%s\n%d BW · %s" % [String(d.name), int(d.get("bw", 0)), String(d.type)], on_press)
	b.custom_minimum_size = Vector2(170, 64)
	return b

func _button(text: String, on_press: Callable) -> Button:
	var b := Button.new(); b.text = text
	b.add_theme_font_override("font", VasTokens.FONT_PLAQUE_SEMI); b.add_theme_font_size_override("font_size", 16)
	b.add_theme_color_override("font_color", VasTokens.CHASSIS)
	b.add_theme_color_override("font_hover_color", VasTokens.CHASSIS)
	b.add_theme_color_override("font_disabled_color", Color("#6E5D4E"))
	b.add_theme_stylebox_override("normal", _box(VasTokens.IVORY, VasTokens.BRONZE, 3, 8))
	b.add_theme_stylebox_override("hover", _box(Color("#FFF4D8"), VasTokens.COPPER, 3, 8))
	b.add_theme_stylebox_override("pressed", _box(Color("#E8D6AE"), VasTokens.COPPER, 3, 8))
	b.add_theme_stylebox_override("disabled", _box(Color("#B9AB90"), Color("#6E5D4E"), 3, 8))
	b.add_theme_stylebox_override("focus", _box(Color.TRANSPARENT, VasTokens.FOCUS, 3, 8))
	b.pressed.connect(on_press)
	return b

func _style_chip(b: Button, active: bool) -> void:
	b.add_theme_font_override("font", VasTokens.FONT_PLAQUE_SEMI); b.add_theme_font_size_override("font_size", 16)
	b.add_theme_color_override("font_color", VasTokens.PHOSPHOR)
	b.add_theme_color_override("font_disabled_color", Color("#7FA597"))
	var st := _box(Color("#0E1A16"), VasTokens.FOCUS if active else Color("#2F5E52"), 3 if active else 2, 8)
	for s in ["normal", "hover", "pressed", "disabled"]: b.add_theme_stylebox_override(s, st)

func _plate(r: Rect2, fill: Color, border: Color, bw: int, radius: int, n: String) -> Panel:
	var p := Panel.new(); p.name = n; p.position = r.position; p.size = r.size; p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_theme_stylebox_override("panel", _box(fill, border, bw, radius))
	return p

func _box(fill: Color, border: Color, bw: int, radius: int, margin: int = 8) -> StyleBoxFlat:
	var s := StyleBoxFlat.new(); s.bg_color = fill; s.border_color = border; s.set_border_width_all(bw)
	s.set_corner_radius_all(radius); s.set_content_margin_all(margin); s.anti_aliasing = true
	return s

func _label(text: String, px: int, col: Color, font: Font) -> Label:
	var l := Label.new(); l.text = text
	l.add_theme_font_override("font", font); l.add_theme_font_size_override("font_size", px)
	l.add_theme_color_override("font_color", col); l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l

## DEV rig chip: drags an installed Icepick with Build 12's payload ({"kind": "pick", "uid"}).
class RigChip extends Button:
	var uid := -1
	func _get_drag_data(_at: Vector2) -> Variant:
		if disabled: return null
		var ghost := Label.new(); ghost.text = text
		ghost.add_theme_color_override("font_color", VasTokens.FOCUS)
		set_drag_preview(ghost)
		return {"kind": "pick", "uid": uid}
