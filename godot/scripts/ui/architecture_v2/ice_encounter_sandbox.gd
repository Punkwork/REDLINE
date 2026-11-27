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
## ARCH-V2-006a (designer 2026-11-26 19:20): the PANOPTICON plate is replaced by the all-seeing eye
## in the very top-left corner, strike lamps under it; everything else moves left and the Ghostware
## reel sits left of the CAPS rack. Negative space stays before the ad plate.
const EYE := Rect2(10, 4, 76, 88)
const TURN_ICON := Rect2(98, 31, 32, 32)
const TURN := Rect2(136, 13, 112, 69)
## ARCH-V2-005: the turn indicator and the TRACE meter are half their former width (252 → 126,
## 230 → 115); the freed header holds the CAPS and PROTOCOLS racks, three slots each to start.
const PHASE := Rect2(264, 16, 126, 63)
const TRACE := Rect2(402, 11, 115, 74)
const GHOST := Rect2(532, 12, 96, 72)
const CAPS := Rect2(642, 14, 219, 68)
const PROTOCOLS := Rect2(869, 14, 219, 68)
const CAP_SLOTS := 3        ## UPL-001: 3 CAP slots (Ghostware/Hardware may add more later)
const PROTOCOL_SLOTS := 3   ## designer: "start with 3"; more deployed than slots shows "+n"
const AD := Rect2(1196, 1, 306, 94)
## ARCH-V2-007c (designer 2026-11-26): ADP graffiti stickers in the header gap before the ad plate.
const GRAFFITI := Rect2(1092, 4, 104, 90)
const GRAFFITI_MAX := 2
## ARCH-V2-007f (designer 2026-11-26 22:12: "the graffiti isn't even necessary. i would remove it for
## now"): off. The code stays so it can come back without rework.
const SHOW_GRAFFITI := false
const ADP_STENCIL := preload("res://assets/fonts/StardosStencil-Regular.ttf")
const ADP_MARKER := preload("res://assets/fonts/PermanentMarker-Regular.ttf")
## ARCH-V2-003s (designer 2026-11-26 15:34): the ICE enclosure spans the full width; the CRT moves
## to the lower left and holds the rig; the effects note sits under it; END TURN is a small brown
## power button; the meters move to the right of the hand. The second CRT
## and the side pipe are gone. END TURN moved to the bottom-right corner (designer 15:37).
const ENCLOSURE := Rect2(6, 100, 1524, 499)
const LANE := Rect2(40, 134, 1456, 354)
const RAIL_HOUSING := Rect2(192, 494, 1152, 63)
## ARCH-V2-006d: LAYER and CRED over the rail's left vent grille.
const LEDGER := Rect2(206, 502, 168, 47)
## ARCH-V2-006f: NUL/REM's two speaker grilles: below the left avatar, and below the right ICE's keys.
const SPEAKER_L := Rect2(70, 504, 96, 48)
const SPEAKER_R := Rect2(1370, 504, 96, 48)
const MAIN_UI := preload("res://scripts/ui/main.gd")   # its event priority list (Build 12's NUL/REM picks)
const FLAGS := "user://redline_flags.json"
const CRT := Rect2(6, 632, 262, 156)   ## cartridges stick up above it (ARCH-V2-003u)
const NOTE := Rect2(8, 794, 258, 66)
const END_TURN := Rect2(1464, 794, 64, 64)   ## designer 15:37: the very bottom-right corner
const TRAY := Rect2(272, 600, 984, 264)   ## ARCH-V2-003u: widened for up to 12 cards
const HAND := Rect2(296, 592, 952, 264)   ## fan area: cards overhang the tray top like VAS-001
const RACK := Rect2(1262, 604, 196, 196)
const COUNTERS := Rect2(1262, 806, 196, 52)   ## horizontal, under the meters (ARCH-V2-003u)

## ARCH-V2-006g: the KEY LEGEND, shown on the eye's hover. [icon, words]; key cap colours per ARCH-V2-003r.
const KEY_LEGEND := [
	["", "Key lit cream-amber: ready, will fire in the response."],
	["", "Key bright red: the biggest PULP hit this response. Red: DEADLOCK."],
	["", "Key amber: tumbled in this turn; dim amber: BOOTING. Unlit: broken."],
	["HIDDEN_LIGHT", "Smoked glass: hidden until it fires."],
	["PULP", "PULP: damage to VITAE (SHIELD absorbs it first)."],
	["TRACE", "TRACE: at 40 you take a strike; the third strike is LOCKDOWN."],
	["DISCARD", "DISCARD: discard cards from your hand."],
	["CORTEX", "CORTEX: each counter is −1 DRAW."],
	["BW_DRAIN", "BW DRAIN: less BANDWIDTH next turn."],
	["DEADLOCK", "DEADLOCK: does nothing itself; break every DEADLOCK to BREACH."],
	["INSERT", "INSERT: Bloatware goes into your deck."],
	["BOOTING", "BOOTING: locked now, opens on a later turn."],
	["PASSIVE", "PASSIVE: the ICE's standing ability."],
]

@export var auto_ready_rig := "FORTRESS_ICEPICK"
## C03: 0 = Build 12 pacing (the steps share 5 s); fixtures set a long gap to park mid-response.
@export var step_seconds := 0.0
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
var eye: HudWidgets.EyeLamp
var ledger: HudWidgets.RailLedger
var log_panel: HudWidgets.LogPanel
var rail_log: HudWidgets.Explained
var flash: ColorRect
var pile_view: ChoiceOverlay
var arrow: HudWidgets.TargetArrow
var crt_glow: HudWidgets.CrtDropGlow
var _dragging_program := -1
var aiming_uid := -1
var _aim_moved := false
var speakers: Array = []
var nr := NulRem.new()
var sequencer := ResponseSequencer.new()
var last_effect_sound := ""
## ARCH-V2-007b: the corporation's music (Build 12's ADP stems: corporate / Rustler / drone, mixed by
## bleed, strike chime) and its effect sounds; the TRACE pixel step as shown (animated).
var music: FriendlyMusic
var bleed := 0.0
var pixel_shown := {}
var pixel_target := {}
var _pixel_tween: Tween
var ad_plate: TextureRect
var graffiti: Control
var _graffiti_key := ""
var punch_arrival: Control
var ad_copy: Label
## Announcements the response waits for (Build 12 waited for its strike overlay).
const HOLD_FOR := ["corp_countermeasure", "mask_off", "lockdown", "ice_lethal"]
var nr_voice: AudioStreamPlayer
var voice_on := true
## Tests point this at a scratch file so they never touch the player's settings.
var flags_path := FLAGS
var nr_lines: Array = []     # what NUL/REM said this encounter, newest last
## R06: the last batch of Game.events this screen handled (tests read it).
var last_events: Array = []
## ARCH-V2-006j (designer 2026-11-26 20:35): no TRACE STRIKE banner; the first strike shows on the
## eye's lamps with the red wash and NUL/REM.
const EVENT_FLYOUT := {"EV-15": "mask_off", "EV-16": "lockdown", "EV-07": "breached",
	"ICE_LETHAL": "ice_lethal", "PARTING_SHOT": "parting_shot", "EV-09": "full_extraction"}
const FLASH_EVENTS := {"EV-14": 0.30, "EV-15": 0.38, "EV-16": 0.45, "ICE_LETHAL": 0.18}
var ghost_reel: HudWidgets.GhostReel
var cap_rack: HudWidgets.SlotRack
var protocol_rack: HudWidgets.SlotRack
var counters: HudWidgets.CounterStack
var effect_card: HudWidgets.EffectCard
var signal_screen: HudWidgets.SignalScreen
var rig_bay: RigBay
var hand_fan: HandFan
## ADP-2b: hovering one card 4 s makes the moodiest ICE say an approved hesitation line.
var voice := HesitationVoice.new()
var _banner: PanelContainer
var _last_turn := 0
var _pending_target := -1
var choice: ChoiceOverlay
var _target_plaque: Control

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	## F04/F05: the app's saved settings (the same flags file the settings menu writes) apply here:
	## reduced motion and NUL/REM's voice. Reduced motion set by a caller stays on.
	var flags := LocalRecord.read(flags_path)
	reduced_motion = reduced_motion or bool(flags.get("reduced_motion", false))
	voice_on = bool(flags.get("voice_on", true))
	nr_voice = AudioStreamPlayer.new(); nr_voice.name = "NulRemVoice"; add_child(nr_voice)
	music = FriendlyMusic.new(); music.name = "Music"; add_child(music)
	music.set_level(float(flags.get("music_volume", AtomicDecoPunk.settings.music.default_volume)), bool(flags.get("music_muted", false)))
	music.set_active(true)
	_build()
	get_viewport().size_changed.connect(_fit)
	_fit()
	## The music plays only while the screen is shown (the app hides it outside encounters).
	visibility_changed.connect(func(): if music: music.set_active(is_visible_in_tree()))
	if game == null and not embedded: start(SEED)

func start(seed: int, rustler: String = "GENERALIST") -> void:
	var g := Game.new(seed)
	g.new_run(rustler)
	g.rng.seed = seed
	g.animate = true
	g.row = 0
	g.available = [0]
	g.enter_node(0)   # N2A: AUTO-RENEW (FORTRESS) + CAPTCHA (TUMBLER)
	if g.phase == "READY_RIG" and auto_ready_rig != "":
		var pick := g.draw_pile.filter(func(c): return c.id == auto_ready_rig)
		if not pick.is_empty(): g.choose_ready_rig(pick[0].uid)
	attach(g)

## ARCH-V2-007d (C05): show a Game the app owns. The app (main.gd) calls this when a run starts and
## refresh() whenever it changes the Game; the screen tells the app when the phase leaves the
## encounter (app_phase_changed) so the app can show the map, reward or DEEPER choice.
signal app_phase_changed(phase: String)
signal voice_toggled(on: bool)
## Inside the app: no sandbox Outcome banner (the app's overlays take over), no auto start.
var embedded := false
func attach(g: Game) -> void:
	if sequencer and sequencer.running: sequencer.cancel()
	responding = false
	game = g
	nr.rustler = String(CardDB.RUSTLERS.get(String(g.rustler), {}).get("nulrem", "Generalist")) if g.rustler != "" else "Generalist"
	nr.corp = game.corporation
	nr_lines.clear()
	ctrl = EncounterController.new()
	ctrl.bind(game)
	ctrl.changed.connect(refresh)
	ctrl.phase_changed.connect(_on_phase)
	ctrl.phase_changed.connect(func(_o, n): app_phase_changed.emit(n))
	_last_turn = 0
	_banner.hide()
	_graffiti_key = ""
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
	choice = ChoiceOverlay.new(); choice.name = "ChoiceOverlay"; choice.position = Vector2.ZERO; choice.size = REF
	choice.inspector = inspector
	choice.chosen.connect(func(u): ctrl.request_choice(u); refresh())
	choice.secondary.connect(func(intent):
		match intent:
			"skip_ready_rig": ctrl.request_skip_ready_rig()
			"finish_scan": ctrl.request_finish_scan()
			"finish_cull": ctrl.request_cull("")
		refresh())
	choice.strain.connect(func(st): ctrl.request_cull(st); refresh())
	stage.add_child(choice)
	log_panel = HudWidgets.LogPanel.new(); stage.add_child(log_panel)
	pile_view = ChoiceOverlay.new(); pile_view.name = "PileView"; pile_view.position = Vector2.ZERO; pile_view.size = REF
	pile_view.inspector = inspector
	pile_view.secondary.connect(func(_i): pile_view.open({}))
	stage.add_child(pile_view)
	## I12: a brief red wash for strikes and lethal ICE (never under reduced motion).
	flash = ColorRect.new(); flash.name = "Flash"; flash.color = Color(1.0, 0.1, 0.12, 0.0)
	flash.mouse_filter = Control.MOUSE_FILTER_IGNORE; flash.size = REF; stage.add_child(flash)
	stage.move_child(flash, flyout.get_index())
	sequencer.name = "ResponseSequencer"
	sequencer.hold = func() -> bool: return flyout.playing and HOLD_FOR.has(flyout.kind)
	sequencer.step_resolved.connect(_effect_feedback)
	sequencer.step_started.connect(func(_s): refresh())
	add_child(sequencer)
	arrow = HudWidgets.TargetArrow.new(); arrow.name = "TargetArrow"; arrow.size = REF; stage.add_child(arrow)
	_target_plaque = _build_target_plaque()
	lane.target_chosen.connect(func(r):
		if game.phase == "CHOICE" and String(game.pending.get("kind", "")) == "patient_zero":
			ctrl.request_choose_ice(r); refresh(); return
		var u := _pending_target; _pending_target = -1
		if u >= 0: ctrl.request_play(u, r)
		refresh())
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
	eye = HudWidgets.EyeLamp.new(); eye.name = "Eye"; eye.inspector = inspector
	eye.setup(EYE.size); eye.position = EYE.position; stage.add_child(eye)
	eye.rows = KEY_LEGEND
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
	ghost_reel = HudWidgets.GhostReel.new(); ghost_reel.name = "GhostReel"
	ghost_reel.setup(GHOST.size, inspector); ghost_reel.position = GHOST.position; stage.add_child(ghost_reel)
	cap_rack = HudWidgets.SlotRack.new(); cap_rack.name = "CapRack"
	cap_rack.setup(CAPS.size, "CAP", CAP_SLOTS, inspector); cap_rack.position = CAPS.position; stage.add_child(cap_rack)
	protocol_rack = HudWidgets.SlotRack.new(); protocol_rack.name = "ProtocolRack"
	protocol_rack.setup(PROTOCOLS.size, "PROTOCOL", PROTOCOL_SLOTS, inspector); protocol_rack.position = PROTOCOLS.position
	stage.add_child(protocol_rack)
	graffiti = Control.new(); graffiti.name = "Graffiti"; graffiti.mouse_filter = Control.MOUSE_FILTER_IGNORE
	graffiti.position = GRAFFITI.position; graffiti.size = GRAFFITI.size; graffiti.clip_contents = true
	stage.add_child(graffiti)
	ad_plate = _art("chassis/V2_AD_PLATE_HALCYON.png", AD, "AdPlate")
	# Approved programme line per corporation (CorporationLook.ad_plate; HALCYON only so far).
	ad_copy = _label("", 19, Color("#8E2A1E"), VasTokens.FONT_PLAQUE_SEMI)
	ad_copy.add_theme_constant_override("line_spacing", -4)
	ad_copy.position = Vector2(AD.size.x * 0.07, AD.size.y * 0.3); ad_plate.add_child(ad_copy)

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
	crt_glow = HudWidgets.CrtDropGlow.new(); crt_glow.name = "CrtDropGlow"; crt_glow.size = REF
	crt_glow.screen = rig_bay.screen_rect; crt_glow.slot_y = rig_bay.slot_y
	stage.add_child(crt_glow)
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
	lane.break_requested.connect(func(r, s, u):
		var bw_before := game.bw
		if ctrl.request_break(r, s, u): _break_feedback(r, s, bw_before - game.bw))
	stage.add_child(lane)
	_art("controls/V2_RAIL_HOUSING.png", RAIL_HOUSING, "RailHousing")
	## ARCH-V2-006i: the log opens from the rail. Hover on the rail's glass shows the latest lines;
	## a click (on the glass or a step) pins the full log; Esc or another click closes it.
	rail_log = HudWidgets.Explained.new(); rail_log.name = "RailLog"; rail_log.inspector = inspector
	rail_log.position = RAIL_HOUSING.position; rail_log.size = RAIL_HOUSING.size
	rail_log.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	rail_log.gui_input.connect(func(e):
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT: toggle_log()
		elif e.is_action_pressed("ui_accept"): toggle_log())
	stage.add_child(rail_log)
	rail = ResponseRail.new()
	rail.height = 30.0
	rail.position = RAIL_HOUSING.position + Vector2(RAIL_HOUSING.size.x * 0.16, RAIL_HOUSING.size.y * 0.18)
	rail.size = Vector2(RAIL_HOUSING.size.x * 0.68, RAIL_HOUSING.size.y * 0.64)
	rail.inspector = inspector
	rail.log_requested.connect(toggle_log)
	stage.add_child(rail)
	_art("chassis/V2_ENCLOSURE_FRAME.png", ENCLOSURE, "EnclosureFrame")
	for k in 2:
		var sp := HudWidgets.SpeakerGrille.new(); sp.name = "Speaker" + ("L" if k == 0 else "R"); sp.inspector = inspector
		var r: Rect2 = SPEAKER_L if k == 0 else SPEAKER_R
		sp.setup(r.size); sp.position = r.position; sp.toggled.connect(toggle_voice)
		stage.add_child(sp); speakers.append(sp)
	ledger = HudWidgets.RailLedger.new(); ledger.name = "Ledger"
	ledger.setup(LEDGER.size, inspector); ledger.position = LEDGER.position; stage.add_child(ledger)

func _build_tray() -> void:
	_art("controls/V2_TRAY.png", TRAY, "Tray")
	## ARCH-V2-003o: the hand is fanned across the tray as in VAS-001; cards rise above the
	## tray's top edge like the reference. Target and choice prompts use a plain row.
	hand_fan = HandFan.new(); hand_fan.name = "HandFan"; hand_fan.reduced_motion = reduced_motion
	hand_fan.card_size = Vector2(140, 221)   ## HuCard 1 : 1.58; twelve cards keep half of each showing
	hand_fan.position = HAND.position; hand_fan.size = HAND.size; stage.add_child(hand_fan)
	counters = HudWidgets.CounterStack.new(); counters.name = "Counters"
	counters.setup(COUNTERS.size, inspector, true); counters.position = COUNTERS.position; stage.add_child(counters)
	for k in 3:
		var pile: String = ["deck", "discard", "burned"][k]
		var row: Control = counters.rows[k]
		row.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		row.gui_input.connect(func(e):
			if (e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT) or e.is_action_pressed("ui_accept"):
				open_pile(pile))
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
	## C03: ResponseSequencer plays the response step by step (light, resolve one, repeat, finish once).
	responding = true
	refresh()
	sequencer.ctrl = ctrl
	sequencer.instant = instant
	sequencer.step_seconds = step_seconds
	await sequencer.run()
	if not is_inside_tree(): return
	responding = sequencer.running
	refresh()

## PLAY-002 in V2: each resolved step sounds its effect type; PULP shakes the console briefly
## (not under reduced motion).
func _effect_feedback(effects: Array) -> void:
	var kinds := effects.map(func(e): return String(e.get("k", "")))
	var id := ""
	if kinds.has("PULP") or kinds.has("RETALIATE"): id = "hit_pulp"
	elif kinds.has("SHIELD_BREAK"): id = "hit_shield"
	elif kinds.has("CORTEX"): id = "hit_cortex"
	elif kinds.has("TRACE"): id = "hit_trace"
	elif kinds.has("HARDEN") or kinds.has("AMEND"): id = "hit_harden"
	elif kinds.has("DISCARD") or kinds.has("INSERT") or kinds.has("BW_DRAIN"): id = "hit_card"
	if id == "" or not FriendlyMusic.EFFECTS.has(id): return
	last_effect_sound = id
	music.play_effect(id)
	if id == "hit_pulp" and not reduced_motion and is_inside_tree():
		var home := stage.position
		var tw := create_tween()
		for k in 4: tw.tween_property(stage, "position", home + Vector2(randf_range(-6, 6), randf_range(-4, 4)), 0.035)
		tw.tween_property(stage, "position", home, 0.04)

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
	if game == null or game.enc.is_empty() and embedded: return
	ctrl.rebind_if_new_encounter()
	flyout.reduced_motion = reduced_motion
	lane.reduced_motion = reduced_motion
	if signal_screen: signal_screen.reduced_motion = reduced_motion
	hand_fan.reduced_motion = reduced_motion
	if not game.enc.is_empty():
		lane.sync(VisibleStateAdapter.ice_models(game, ctrl))
		## ARCH-V2-007a: the corporation's room through the ICE windows; HOSTILE shows through with the reveal.
		var rooms := CorporationLook.rooms_for(game)
		lane.set_room(rooms.friendly, rooms.hostile, VisibleStateAdapter.hostile_reveal(game))
		_update_pixel()
		lane.set_look(CorporationLook.enamel(game.corporation), pixel_shown)
		rail.sync(VisibleStateAdapter.response_model(game, ctrl))
	_update_ad_plate()
	_update_graffiti()
	_handle_events()
	_refresh_speakers()
	_refresh_inspector()
	turn_counter.set_value(int(game.enc.get("turn", 0)))
	phase_plaque.set_phase(game.phase == "RESPONSE")
	trace_gauge.set_value(game.trace)
	var rev := VisibleStateAdapter.hostile_reveal(game)
	eye.reduced_motion = reduced_motion
	eye.set_state(rev, game.strikes, game.lockdown)
	eye.heading = VisibleStateAdapter.place_line(game)
	eye.title = "LOCKDOWN" if game.lockdown else "THE EYE"
	eye.lines = ["Hostile reveal %d%%. Strikes %d / 3%s." % [roundi(rev * 100.0), mini(game.strikes, 3), " · you can't leave this Node early" if game.lockdown else ""],
		"Punch cards %d / 3%s" % [game.punch_cards.size(), (": " + ", ".join(game.punch_cards)) if not game.punch_cards.is_empty() else ""], "KEY LEGEND"]
	eye.picture = _punch_picture if not game.punch_cards.is_empty() else Callable()
	## ARCH-V2-007c / F09: low VITAE (a quarter or less) makes the VITAE meter pulse red.
	meters.VITAE.warn = game.vitae > 0 and game.vitae <= game.max_vitae / 4
	meters.VITAE.reduced_motion = reduced_motion
	ghost_reel.reduced_motion = reduced_motion
	ghost_reel.set_items(VisibleStateAdapter.ghostware_models(game))
	cap_rack.set_items(VisibleStateAdapter.cap_models(game))
	protocol_rack.set_items(VisibleStateAdapter.protocol_models(game))
	meters.VITAE.set_value(game.vitae, game.max_vitae, 10, str(game.vitae), "VITAE %d / %d" % [game.vitae, game.max_vitae])
	meters.BW.set_value(game.bw, Game.BW_PER_TURN, Game.BW_PER_TURN, str(game.bw), "BANDWIDTH %d" % game.bw)
	meters.RAM.set_value(game.ram_used(), game.ram_total(), game.ram_total(), "%d/%d" % [game.ram_used(), game.ram_total()], "RAM %d / %d" % [game.ram_used(), game.ram_total()])
	meters.SHIELD.set_value(game.shield, 10, 10, str(game.shield), "SHIELD %d" % game.shield)
	var inc := VisibleStateAdapter.incoming(game)
	var incoming: int = inc.pulp
	if inc.parting:
		meters.PULP.set_value(incoming, maxi(1, game.vitae), 10, str(incoming), "PARTING SHOT: PULP %d · TRACE %d" % [inc.pulp, inc.trace])
		meters.PULP.lines = ["After a BREACH, the unbroken subroutines you can see fire once when you press END TURN. DEADLOCKs don't."]
		end_key.title = "END TURN"
		end_key.lines = ["Parting shot: PULP %d, TRACE %d." % [inc.pulp, inc.trace]] if inc.pulp + inc.trace > 0 else ["Parting shot: nothing (everything showing is broken)."]
	else:
		meters.PULP.set_value(incoming, maxi(1, game.vitae), 10, str(incoming), "PULP INCOMING %d" % incoming)
		meters.PULP.lines = []
		end_key.lines = []
	var lg := VisibleStateAdapter.ledger(game)
	ledger.reduced_motion = reduced_motion
	ledger.set_values(lg.layers, lg.current, lg.cred, lg.reserve)
	rail_log.title = "ENCOUNTER LOG"
	rail_log.lines = game.log.slice(maxi(0, game.log.size() - 5)) if not game.log.is_empty() else ["Nothing yet."]
	rail_log.lines.append("Click the rail for the full log.")
	if log_panel.visible: log_panel.set_lines(game.log)
	counters.set_counts(game.draw_pile.size(), game.discard.size(), _burned_count())
	## V06: NEXT DRAW on the deck counter's hover (CORTEX already lowers it).
	counters.rows[0].lines = ["NEXT DRAW: %d card%s." % [game.draw_size(), "" if game.draw_size() == 1 else "s"], "Click to see your deck."]
	counters.rows[1].lines = ["Click to see your discard pile."]
	counters.rows[2].lines = ["Click to see what's burned."]
	effect_card.set_stamps(_stamps())
	end_key.set_enabled(not responding and game.phase == "PLAYER")
	_refresh_rig()
	_refresh_hand()
	var done := not (game.phase in ["PLAYER", "RESPONSE", "CHOICE", "READY_RIG"])
	_banner.visible = done and not responding and not embedded
	if _banner.visible:
		var title: Label = _banner.find_child("Title", true, false)
		title.text = "FLATLINED" if game.phase == "DEAD" else ("ENCOUNTER COMPLETE · " + game.phase)

## R06 / I12: this screen is the only reader of its Game's events (the sandbox owns its Game; at C05
## integration the app shell hands them over). Each mapped event gets its flyout (queued, one at a
## time); strikes and lethal ICE also get a short red wash. Never changes rules state.
func _handle_events() -> void:
	if game.events.is_empty(): return
	last_events = game.events.duplicate()
	game.events.clear()
	for e in last_events:
		var t := String(e.get("t", ""))
		if t == "PARTING_SHOT" and int(e.get("fired", 0)) == 0: continue
		if EVENT_FLYOUT.has(t): flyout.announce(EVENT_FLYOUT[t])
		if FLASH_EVENTS.has(t) and not reduced_motion: _flash(FLASH_EVENTS[t])
		if t in ["EV-14", "EV-15", "EV-16"]: music.play_strike()
		if t == "PUNCH_CARD": _punch_arrives(String(e.get("corp", game.corporation)))
	_on_events(last_events)

## ARCH-V2-006f: NUL/REM picks one line per batch of events (Build 12's priority order), speaks it
## through the voice player (unless muted) and the grilles glow; the text waits on their hover.
func _on_events(list: Array) -> void:
	var best := {}
	var best_rank := 999
	for e in list:
		var rank: int = MAIN_UI.PRIORITY.find(String(e.get("t", "")))
		if rank >= 0 and rank < best_rank: best_rank = rank; best = e
	if best.is_empty() or game.phase == "DEAD": return
	var ctx := {"punch_cards": game.punch_cards, "corp": best.get("corp", game.corporation), "bloat": best.get("card", ""), "rest": "SAFEHOUSE"}
	if best.t == "EV-35": ctx["cause"] = "TRACE" if game.lockdown else ""
	say(nr.pick(String(best.t), ctx))

func say(line: Dictionary) -> void:
	if line.is_empty(): return
	nr_lines.append(line)
	var seconds: float = clampf(String(line.text).length() / 15.0, 1.5, 6.0)
	nr_voice.stop()
	var path := "res://audio/nulrem/%s.ogg" % String(line.id).replace(" ", "_")
	if voice_on and ResourceLoader.exists(path):
		var stream: AudioStream = load(path)
		nr_voice.stream = stream
		if nr_voice.is_inside_tree(): nr_voice.play()
		seconds = maxf(1.0, stream.get_length())
	for sp in speakers: sp.speak(seconds)
	_refresh_speakers()

func toggle_voice() -> void:
	voice_on = not voice_on
	if not voice_on: nr_voice.stop()
	var flags := LocalRecord.read(flags_path)
	flags["voice_on"] = voice_on
	LocalRecord.write(flags_path, flags)
	voice_toggled.emit(voice_on)
	_refresh_speakers()

func _refresh_speakers() -> void:
	for sp in speakers:
		sp.muted = not voice_on
		sp.reduced_motion = reduced_motion
		sp.title = "NUL/REM" + ("" if voice_on else " · VOICE OFF")
		var recent := nr_lines.slice(maxi(0, nr_lines.size() - 3))
		recent.reverse()
		sp.lines = recent.map(func(l): return String(l.text)) if not recent.is_empty() else ["Nothing said yet."]
		sp.lines.append("Click (or M) to " + ("mute the voice." if voice_on else "turn the voice on."))
		sp.queue_redraw()

func _flash(peak: float) -> void:
	if not is_inside_tree(): return
	flash.color.a = peak
	var tw := create_tween()
	tw.tween_property(flash, "color:a", 0.0, 0.45)

## I11: a small "−n BW" rises from the key a paid break used (none for free breaks).
func _break_feedback(ice_ref: Dictionary, sub: int, spent: int) -> void:
	if spent <= 0: return
	var key: Control = null
	for p in lane.panels():
		if is_same(p.ice_ref, ice_ref): key = p.find_child("Key_S%d" % (sub + 1), true, false)
	var at := key.get_global_rect().get_center() if key else get_viewport_rect().size / 2.0
	var l := _label("−%d BW" % spent, 26, VasTokens.AMBER, VasTokens.FONT_PLAQUE)
	l.name = "BreakFeedback"
	l.add_theme_constant_override("outline_size", 6); l.add_theme_color_override("font_outline_color", Color(0.04, 0.03, 0.03))
	l.z_index = 160; l.top_level = true
	add_child(l)
	l.reset_size()
	l.global_position = at - l.size / 2.0
	if reduced_motion or not is_inside_tree():
		get_tree().create_timer(0.9).timeout.connect(l.queue_free) if is_inside_tree() else l.queue_free()
		return
	var tw := create_tween().set_parallel(true)
	tw.tween_property(l, "global_position:y", l.global_position.y - 40.0, 0.8)
	tw.tween_property(l, "modulate:a", 0.0, 0.8).set_delay(0.3)
	tw.chain().tween_callback(l.queue_free)

## ARCH-V2-007b: PIXEL-TRACE-001 step from TRACE and strikes, with Build 12's transition (a short
## spike to coarser cells, then settle); instant under reduced motion.
func _update_pixel() -> void:
	var step := AtomicDecoPunk.pixel_step(game.trace, game.strikes, false)
	if step == pixel_target: return
	var first := pixel_target.is_empty()
	pixel_target = step
	if _pixel_tween: _pixel_tween.kill()
	if first or reduced_motion or pixel_shown.is_empty() or not is_inside_tree():
		pixel_shown = step.duplicate(); return
	var cfg: Dictionary = AtomicDecoPunk.settings.pixel_transition
	var from := pixel_shown.duplicate()
	var peak := {"cell": maxf(from.cell, step.cell) + float(cfg.spike_cells), "levels": maxf(minf(from.levels, step.levels) * float(cfg.spike_levels), 4.0), "dither": 1.0}
	var apply := func(look: Dictionary) -> void:
		pixel_shown = look
		lane.set_look(CorporationLook.enamel(game.corporation), look)
	_pixel_tween = create_tween()
	_pixel_tween.tween_method(func(t: float): apply.call(FriendlyEncounter.blend_pixel(from, peak, t)), 0.0, 1.0, float(cfg.spike_seconds))
	_pixel_tween.tween_method(func(t: float): apply.call(FriendlyEncounter.blend_pixel(peak, step, t)), 0.0, 1.0, float(cfg.settle_seconds))
	_pixel_tween.tween_callback(func(): apply.call(step.duplicate()))

## ARCH-V2-007c: ADP graffiti (Build 12's counts: 1 sticker when the bleed reaches band A, 2 at B,
## 4 at C; approved lines from adp_copy.json, the last one shared across corporations at C).
func _update_graffiti() -> void:
	if not SHOW_GRAFFITI:
		for c in graffiti.get_children(): graffiti.remove_child(c); c.queue_free()
		return
	var band := AdpCopy.band(AtomicDecoPunk.target(game.trace, game.strikes, false))
	## Build 12 shows 1 / 2 / 4; the header gap holds two readable stickers, so it shows at most two
	## (the newest two at band C). Interpretation to confirm (ARCH-V2-007c).
	var full := int({"A": 1, "B": 2, "C": 4}.get(band, 0))
	var count := mini(full, GRAFFITI_MAX)
	var key := "%s|%s|%d" % [game.corporation, band, game.row]
	if key == _graffiti_key: return
	_graffiti_key = key
	for c in graffiti.get_children(): graffiti.remove_child(c); c.queue_free()
	var index := SignalCards.ORDER.find(game.corporation)
	for k in count:
		var n := full - count + k   # which of Build 12's stickers this is (the newest ones)
		var shared := band == "C" and n == full - 1 and index > 0
		var line := AdpCopy.pick("graffiti", "" if shared else game.corporation, n + game.row)
		if line.is_empty(): break
		var tag := _graffiti_sticker(line)
		tag.name = "Sticker%d" % k
		graffiti.add_child(tag)
		tag.reset_size()
		tag.position = Vector2(1 + (k % 2) * 3, 4 + k * 44)
		tag.rotation_degrees = [-3.0, 2.5][k]

func graffiti_count() -> int:
	return graffiti.get_child_count()

func _graffiti_sticker(line: Dictionary) -> PanelContainer:
	var paper := PanelContainer.new(); paper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var st := StyleBoxFlat.new(); st.bg_color = FriendlyLook.TONER; st.set_content_margin_all(2)
	paper.add_theme_stylebox_override("panel", st)
	if String(line.get("style", "")) == "P":
		paper.add_child(PunchedLetters.new(String(line.text)))
	else:
		## Two lines at most: the gap is narrow, so long lines wrap rather than shrink past reading.
		var font: Font = ADP_STENCIL if String(line.get("style", "")) == "S" else ADP_MARKER
		var px := 11
		var w := GRAFFITI.size.x - 10
		while px > 8 and font.get_string_size(String(line.text), HORIZONTAL_ALIGNMENT_LEFT, -1, px).x > w * 2.0 - 8: px -= 1
		var l := FriendlyLook.label(String(line.text), px, FriendlyLook.PAPER, font)
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; l.custom_minimum_size.x = w
		paper.add_child(l)
	return paper

## ARCH-V2-007c (designer: "Hover on the eye only"): the punch cards collected, drawn in the eye's
## hover; a newly earned card drops onto the eye for a moment.
func _punch_picture() -> Control:
	var row := HBoxContainer.new(); row.add_theme_constant_override("separation", 6)
	for corp in SignalCards.ORDER:
		var c := PunchStock.new([corp] if game.punch_cards.has(corp) else [])
		c.custom_minimum_size = Vector2(46, 30); row.add_child(c)
	return row

func _punch_arrives(corp: String) -> void:
	if is_instance_valid(punch_arrival): punch_arrival.queue_free()
	punch_arrival = PunchStock.new([corp]); punch_arrival.name = "PunchArrival"
	punch_arrival.size = Vector2(92, 60)
	var target := EYE.position + Vector2(EYE.size.x + 8, 8)
	punch_arrival.position = target
	stage.add_child(punch_arrival)
	if reduced_motion or not is_inside_tree():
		get_tree().create_timer(2.5).timeout.connect(func(): if is_instance_valid(punch_arrival): punch_arrival.queue_free()) if is_inside_tree() else null
		return
	punch_arrival.position.y = target.y - 70
	var tw := create_tween()
	tw.tween_property(punch_arrival, "position:y", target.y, 0.38).set_trans(Tween.TRANS_CUBIC)
	tw.tween_interval(2.2)
	tw.tween_property(punch_arrival, "modulate:a", 0.0, 0.4)
	tw.tween_callback(punch_arrival.queue_free)

func _update_ad_plate() -> void:
	var ad := CorporationLook.ad_plate(game.corporation)
	ad_plate.visible = not ad.is_empty()
	if ad.is_empty(): return
	ad_plate.texture = V2Art.tex(String(ad.art), AD.size.x)
	ad_copy.text = String(ad.copy)

func toggle_log() -> void:
	if log_panel.visible:
		log_panel.hide(); return
	inspector.close()
	log_panel.set_lines(game.log)
	log_panel.reset_size()
	log_panel.position = Vector2(REF.x / 2.0 - log_panel.size.x / 2.0, RAIL_HOUSING.position.y - log_panel.size.y - 8)
	log_panel.show()

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
	## C10 HandView: the hand as CardViews in the fan. Choices open the C15 overlay; a targeted card
	## lights the ICE panels as targets (click one; ✕ or Esc cancels).
	hand_fan.clear()
	choice.open(_choice_spec())
	var patient_zero := game.phase == "CHOICE" and String(game.pending.get("kind", "")) == "patient_zero"
	var targeting := (_pending_target >= 0 and game.phase == "PLAYER") or patient_zero
	if not targeting or patient_zero: _pending_target = -1
	var plaque_text := "PATIENT ZERO: CHOOSE AN ICE TO INFECT (1 ROT)" if patient_zero else "CHOOSE AN ICE"
	var plaque_label := _target_plaque.get_child(0).get_child(0) as Label
	if plaque_label.text != plaque_text:
		plaque_label.text = plaque_text
		_target_plaque.get_child(0).get_child(1).visible = not patient_zero   # PATIENT ZERO can't be skipped
		_target_plaque.reset_size()
		_target_plaque.position.x = REF.x / 2.0 - _target_plaque.get_combined_minimum_size().x / 2.0
	lane.set_targeting(targeting)
	_target_plaque.visible = targeting and aiming_uid < 0   # the arrow replaces the plaque for the mouse
	for c in game.hand:
		var cv := _card_view(VisibleStateAdapter.card_model(game, c, "hand"))
		cv.selected = int(c.uid) == _pending_target
		if responding: cv.model.playable = false
		hand_fan.add_card(cv)

func _choice_spec() -> Dictionary:
	## Existing wording from Build 12's overlays (main.gd), one variant per pending kind.
	var cards_of := func(uids: Array, pile: Array) -> Array:
		var out := []
		for c in pile:
			if uids.has(int(c.uid)): out.append(VisibleStateAdapter.card_model(game, c, "pick"))
		return out
	if game.phase == "READY_RIG":
		return {"kind": "ready_rig", "title": "READY RIG", "text": "Generalist ORIGIN: choose one PROGRAM in your deck. It starts installed for free; your first hand stays full.",
			"cards": cards_of.call(game.pending.get("options", []), game.draw_pile), "secondary": {"label": "Skip", "intent": "skip_ready_rig"}}
	if game.phase != "CHOICE": return {}
	var p: Dictionary = game.pending
	var hand_uids: Array = game.hand.map(func(c): return int(c.uid))
	match String(p.get("kind", "")):
		"discard": return {"kind": "discard", "title": "DISCARD %d" % int(p.get("n", 1)), "text": "CAPTCHA: choose a card in your hand to discard.", "cards": cards_of.call(hand_uids, game.hand)}
		"burn_hand": return {"kind": "burn_hand", "title": "GARBAGE COLLECT", "text": "BURN another hand card for this Node, then draw 1.", "cards": cards_of.call(p.options, game.hand)}
		"retrieve": return {"kind": "retrieve", "title": "TAIL CALL", "text": "Choose a SCRIPT from discard.", "cards": cards_of.call(p.options, game.discard)}
		"uninstaller": return {"kind": "uninstaller", "title": "UNINSTALLER", "text": "Choose a Bloatware in your hand to BURN.", "cards": cards_of.call(p.options, game.hand)}
		"field_kit": return {"kind": "field_kit", "title": "FIELD KIT", "text": "Choose a PROGRAM from your draw pile.", "cards": cards_of.call(p.options, game.draw_pile)}
		"cache": return {"kind": "cache", "title": String(p.get("title", "DEAD AIR")), "text": String(p.get("description", "Choose a card to CACHE: it stays in your hand at the end of your turn.")), "cards": cards_of.call(p.options, game.hand)}
		"scan":
			return {"kind": "scan", "title": "SCAN 3", "text": "Click cards to bottom them, in selection order; click again to undo.",
				"cards": cards_of.call(p.cards.map(func(c): return int(c.uid)), p.cards), "selected": p.get("bottom", []),
				"secondary": {"label": "Finish SCAN, then draw 1", "intent": "finish_scan"}}
		"cull":
			var strains := []
			for st in p.ice_ref.virus:
				if int(p.ice_ref.virus[st]) > 0: strains.append({"name": String(st), "n": int(p.ice_ref.virus[st])})
			return {"kind": "cull", "title": "CULL", "text": "Choose up to %d more counters to remove." % int(p.get("n", 0)), "strains": strains,
				"secondary": {"label": "Finish", "intent": "finish_cull"}}
		"card_break": return {}   # chosen on the subroutine keys
		"patient_zero": return {}  # chosen on the ICE windows (ARCH-V2-007c)
	return {}

func _build_target_plaque() -> Control:
	var pc := PanelContainer.new(); pc.name = "TargetPlaque"
	var sb := StyleBoxFlat.new(); sb.bg_color = Color("#1E1510"); sb.border_color = VasTokens.FOCUS
	sb.set_border_width_all(3); sb.set_corner_radius_all(14); sb.set_content_margin_all(10)
	pc.add_theme_stylebox_override("panel", sb)
	var row := HBoxContainer.new(); row.add_theme_constant_override("separation", 14); pc.add_child(row)
	row.add_child(_label("CHOOSE AN ICE", 22, VasTokens.FOCUS, VasTokens.FONT_PLAQUE))
	var x := _button("✕", func(): _pending_target = -1; refresh())
	x.custom_minimum_size = Vector2(44, 44); x.tooltip_text = ""
	row.add_child(x)
	stage.add_child(pc)
	pc.reset_size()
	pc.position = Vector2(REF.x / 2.0 - 120, ENCLOSURE.position.y - 8)
	pc.hide()
	return pc

func _unhandled_input(e: InputEvent) -> void:
	if e is InputEventKey and e.pressed and not e.echo and e.keycode == KEY_M:
		toggle_voice(); get_viewport().set_input_as_handled(); return
	if pile_view.visible and e.is_action_pressed("ui_cancel"):
		pile_view.open({}); get_viewport().set_input_as_handled(); return
	if log_panel.visible and e.is_action_pressed("ui_cancel"):
		log_panel.hide(); get_viewport().set_input_as_handled(); return
	if _pending_target >= 0 and e.is_action_pressed("ui_cancel"):
		_pending_target = -1; refresh(); get_viewport().set_input_as_handled()

func _card_view(m: Dictionary) -> CardView:
	var cv := CardView.new()
	cv.inspector = inspector
	cv.set_model(m)
	cv.set_meta("uid", int(m.uid))
	cv.pressed.connect(func(u):
		if _pending_target == u: _pending_target = -1; refresh(); return
		if not bool(cv.model.get("playable", false)): return
		if bool(m.get("target", false)): _pending_target = u; refresh()
		else: ctrl.request_play(u); refresh())
	cv.drag_dropped.connect(_on_card_dropped)
	cv.aim_started.connect(func(u): start_aim(u, cv))
	cv.drag_began.connect(func(u):
		if String(m.get("type", "")) == "PROGRAM":
			_dragging_program = u; crt_glow.reduced_motion = reduced_motion; crt_glow.set_state(1))
	cv.drag_finished.connect(func(_u): _dragging_program = -1; crt_glow.set_state(0))
	return cv

## ARCH-V2-006k: aim a targeted card. Press and hold the card: an arrow runs from it to the pointer
## and the ICE light up; release over an ICE plays the card on it (one controller call); release
## anywhere else cancels. A plain click (release on the card) keeps the arrow until the next click.
## Esc or right-click cancels. Keyboard play keeps the CHOOSE AN ICE plaque.
func start_aim(uid: int, cv: CardView) -> void:
	if responding or game.phase != "PLAYER": return
	aiming_uid = uid; _aim_moved = false
	_pending_target = uid
	inspector.close()
	var r := cv.get_global_rect()
	arrow.from = _to_stage(Vector2(r.get_center().x, r.position.y + 12.0))
	arrow.to = _to_stage(get_global_mouse_position())
	arrow.over = Rect2()
	arrow.show(); arrow.queue_redraw()
	cv.selected = true; cv.queue_redraw()
	lane.set_targeting(true)

func _to_stage(p: Vector2) -> Vector2:
	return (p - stage.global_position) / stage.scale

func _panel_at(global: Vector2) -> IcePanel:
	for p in lane.panels():
		if p.get_global_rect().has_point(global): return p
	return null

func aim_at(global: Vector2) -> void:
	arrow.to = _to_stage(global)
	var p := _panel_at(global)
	arrow.over = Rect2(_to_stage(p.get_global_rect().position), p.get_global_rect().size / stage.scale) if p else Rect2()
	if arrow.from.distance_to(arrow.to) > 24.0: _aim_moved = true
	arrow.queue_redraw()

func release_aim(global: Vector2) -> void:
	if aiming_uid < 0: return
	var p := _panel_at(global)
	if p == null and not _aim_moved: return   # a plain click: keep aiming until the next click
	var uid := aiming_uid
	cancel_aim()
	if p: ctrl.request_play(uid, p.ice_ref)
	refresh()

func cancel_aim() -> void:
	aiming_uid = -1; _pending_target = -1
	arrow.hide()
	lane.set_targeting(false)

func _input(e: InputEvent) -> void:
	if aiming_uid < 0: return
	if e is InputEventMouseMotion:
		aim_at(e.global_position)
	elif e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
		if e.pressed:
			# Click mode: the second click decides (on an ICE: play it there; elsewhere: cancel).
			_aim_moved = true
			release_aim(e.global_position)
			get_viewport().set_input_as_handled()
		else:
			release_aim(e.global_position)
	elif (e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_RIGHT and e.pressed) or e.is_action_pressed("ui_cancel"):
		cancel_aim(); refresh(); get_viewport().set_input_as_handled()

## C04 (PT11-UI 2): a card dragged out of the hand. Untargeted cards play when dropped anywhere above
## the hand tray; targeted cards play on the ICE panel they were dropped on. One controller call.
func _on_card_dropped(uid: int, at: Vector2) -> void:
	if responding or game.phase != "PLAYER": return
	var p := (at - stage.global_position) / stage.scale
	var c := game.hand.filter(func(x): return int(x.uid) == uid)
	if c.is_empty(): return
	var d := CardDB.def(String(c[0].id))
	## ARCH-V2-006l: a PROGRAM installs only when dropped on the CRT (its glass or the slot above it).
	if String(d.get("type", "")) == "PROGRAM":
		if over_crt(at): ctrl.request_play(uid); refresh()
		return
	if p.y >= TRAY.position.y: return
	if bool(d.get("target", false)):
		for panel in lane.panels():
			if panel.get_global_rect().has_point(at):
				_pending_target = -1
				ctrl.request_play(uid, panel.ice_ref); refresh(); return
		return
	ctrl.request_play(uid); refresh()

func over_crt(global: Vector2) -> bool:
	var p := _to_stage(global)
	var zone := Rect2(CRT.position.x, rig_bay.slot_y - 60.0, CRT.size.x, CRT.end.y - rig_bay.slot_y + 60.0)
	return zone.has_point(p)

## C09: click a counter to see that pile (deck sorted by name, so its order stays hidden).
func open_pile(pile: String) -> void:
	var names := {"deck": "DECK", "discard": "DISCARD", "burned": "BURNED"}
	var models := VisibleStateAdapter.pile_models(game, pile)
	var text: String = {"deck": "Your draw pile, sorted by name (the draw order stays hidden).",
		"discard": "Your discard pile, oldest first.", "burned": "Burned for this Node."}[pile]
	if models.is_empty(): text = "Empty."
	inspector.close()
	pile_view.open({"kind": "view_" + pile, "view": true, "title": "%s · %d" % [names[pile], models.size()],
		"text": text, "cards": models, "secondary": {"label": "Close", "intent": "close"}})

func _process(delta: float) -> void:
	if game != null and music != null:
		## The music follows the ADP bleed (eased like Build 12): friendly stems give way to the drone.
		var target := AtomicDecoPunk.target(game.trace, game.strikes, false)
		bleed = target if reduced_motion else move_toward(bleed, target, delta / maxf(0.05, float(AtomicDecoPunk.settings.bleed.ease_seconds)))
		music.update_mix(bleed, reduced_motion, delta)
	if _dragging_program >= 0: crt_glow.set_state(2 if over_crt(get_global_mouse_position()) else 1)
	if game == null or game.enc.is_empty() or hand_fan == null: return
	var h := hand_fan.hovered
	var uid := int(h.get_meta("uid", -1)) if is_instance_valid(h) else -1
	var said := voice.tick(delta, Time.get_ticks_msec() / 1000.0, uid, get_viewport().gui_is_dragging(), game.phase,
		int(game.enc.get("turn", 0)), String(game.enc.get("corp", "HALCYON")), lane.panels().map(func(p): return p.model))
	if not said.is_empty(): lane.panels()[int(said.ice)].say(String(said.text), voice.seconds)

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
