extends Control
## PANOPTICON vertical slice UI. Everything is built in code from the Game state; refresh() rebuilds the views.
## Visual language: ICE Design doc (icon = type, frame = role, chip colour = effect, response preview).

const BG := Color("#0b0e13")
const PANEL := Color("#141922")
const PANEL_2 := Color("#1b2230")
const TEXT := Color("#e6ebf2")
const DIM := Color("#8b95a5")
const RUSTLER_COL := {"GENERALIST": Color("#e6ebf2"), "ECHO": Color("#7fb6ff"), "RIOT": Color("#ff6a3d"), "VECTOR": Color("#9ad17a")}
const STRAIN_COL := {"ROT": Color("#9ad17a"), "SCRAMBLE": Color("#ff4d5e"), "BLIND": Color("#ffb020"), "LEECH": Color("#ffd34d"), "WORM": Color("#c7b9ff")}
const STRAIN_TIP := {"ROT": "Each ROT: −1 STR.", "SCRAMBLE": "Each SCRAMBLE: this ICE's PULP subroutines deal 1 less.",
	"BLIND": "Each BLIND: this ICE's TRACE subroutines add 1 less.", "LEECH": "Each LEECH: extract 1 CRED at the start of your turn.",
	"WORM": "Each WORM: at the start of your turn, copy 1 counter of each strain here onto the ICE to its right."}
const TYPE_COL := {"PROGRAM": Color("#4fd2ff"), "SCRIPT": Color("#e6ebf2"), "PROTOCOL": Color("#7ee081"), "BLOATWARE": Color("#b08a5a")}
const RARITY_COL := {"COMMON": Color("#c9d3df"), "UNCOMMON": Color("#5aa8ff"), "RARE": Color("#ffb020"), "STARTER": Color("#6c7787"), "BLOAT": Color("#b08a5a")}
const PRIORITY := ["EV-35", "EV-16", "EV-15", "EV-14", "EV-02", "EV-01", "EV-03", "EV-04", "EV-18", "EV-07", "EV-13",
	"EV-08", "EV-27", "EV-28", "EV-11", "EV-12", "EV-09", "EV-10", "EV-17", "EV-05", "EV-21", "EV-26", "EV-06", "EV-37", "EV-39"]
const KONAMI := [KEY_UP, KEY_UP, KEY_DOWN, KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_LEFT, KEY_RIGHT, KEY_B, KEY_A]

var g: Game
var nr: NulRem
var targeting := -1
var konami_pos := 0
var idle := 0.0
var first_run := true
var last_bloat := ""

var hud: HBoxContainer
var info: HBoxContainer
var rig: VBoxContainer
var ice_row: HBoxContainer
var preview: HBoxContainer
var preview_total: Label
var hand_row: HBoxContainer
var log_label: Label
var end_btn: Button
var piles: Label
var nr_text: Label
var nr_mode: Label
var overlay: Control
var inspect: CenterContainer
## VOICE-001: NUL/REM reads every line aloud (pre-recorded, tools/voice_nulrem.py). M toggles the voice.
var voice: AudioStreamPlayer
var voice_on := true
var voice_btn: Button
## PLAY-001: the Corporation Response plays one subroutine at a time over at least 5 seconds.
const RESPONSE_MIN_SECONDS := 5.0
var responding := false
## REEL-001: TUMBLER slots are slot-machine reels; they spin when the TUMBLER rotates.
const REEL_H := 33.0
var spin := {}            # ICE index → its slots' subroutines before the rotation
var spinning := false
var spin_built := false
var spin_deferred := false
var blocker: Control
var endrun_btn: Button
var confirming_end := false
var flash := {}        # {ref, sub} of the subroutine firing now
var fired: Array = []  # [{ref, sub}] already fired this response
var resp_total := 0
var tween: Tween

# =====================================================================
# setup
# =====================================================================

func _ready() -> void:
	theme = _make_theme()
	_load_flags()
	nr = NulRem.new()
	g = Game.new()
	g.animate = true
	_build_layout()
	_new_run()

func _make_theme() -> Theme:
	var t := Theme.new()
	t.default_font_size = 15
	var sb := StyleBoxFlat.new()
	sb.bg_color = PANEL_2
	sb.border_color = Color("#3a4558")
	sb.set_border_width_all(1)
	sb.set_corner_radius_all(4)
	sb.content_margin_left = 10
	sb.content_margin_right = 10
	sb.content_margin_top = 6
	sb.content_margin_bottom = 6
	var hov := sb.duplicate()
	hov.bg_color = Color("#26314a")
	hov.border_color = Color("#4fd2ff")
	var dis := sb.duplicate()
	dis.bg_color = Color("#151a22")
	dis.border_color = Color("#262d3a")
	t.set_stylebox("normal", "Button", sb)
	t.set_stylebox("hover", "Button", hov)
	t.set_stylebox("pressed", "Button", hov)
	t.set_stylebox("disabled", "Button", dis)
	t.set_stylebox("focus", "Button", StyleBoxEmpty.new())
	t.set_color("font_color", "Button", TEXT)
	t.set_color("font_disabled_color", "Button", Color("#5d6675"))
	t.set_color("font_color", "Label", TEXT)
	return t

func _load_flags() -> void:
	first_run = true
	if FileAccess.file_exists("user://redline_flags.json"):
		var data = JSON.parse_string(FileAccess.get_file_as_string("user://redline_flags.json"))
		if data is Dictionary:
			first_run = not data.get("first_run_done", true)
			voice_on = data.get("voice_on", true)

func _save_flags() -> void:
	var f := FileAccess.open("user://redline_flags.json", FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify({"first_run_done": not first_run, "voice_on": voice_on}))

func _build_layout() -> void:
	var bg := ColorRect.new()
	bg.color = BG
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var top := _panel(Vector2(0, 0), Vector2(1600, 60), Color("#10141b"))
	hud = HBoxContainer.new()
	hud.add_theme_constant_override("separation", 26)
	hud.position = Vector2(16, 12)
	top.add_child(hud)

	info = HBoxContainer.new()
	info.position = Vector2(244, 68)
	info.add_theme_constant_override("separation", 22)
	add_child(info)

	var rp := _panel(Vector2(10, 100), Vector2(220, 440), PANEL)
	rig = VBoxContainer.new()
	rig.position = Vector2(10, 8)
	rig.size = Vector2(200, 420)
	rig.add_theme_constant_override("separation", 6)
	rp.add_child(rig)

	ice_row = HBoxContainer.new()
	ice_row.position = Vector2(244, 100)
	ice_row.size = Vector2(1090, 360)
	ice_row.alignment = BoxContainer.ALIGNMENT_CENTER
	ice_row.add_theme_constant_override("separation", 14)
	add_child(ice_row)

	var pp := _panel(Vector2(244, 470), Vector2(1090, 70), PANEL)
	var pv := VBoxContainer.new()
	pv.position = Vector2(10, 4)
	pp.add_child(pv)
	var ph := HBoxContainer.new()
	ph.add_child(_lbl("CORPORATION RESPONSE", 12, DIM))
	preview_total = _lbl("", 13, TEXT)
	ph.add_theme_constant_override("separation", 16)
	ph.add_child(preview_total)
	pv.add_child(ph)
	preview = HBoxContainer.new()
	preview.add_theme_constant_override("separation", 10)
	pv.add_child(preview)

	log_label = _lbl("", 13, DIM)
	log_label.position = Vector2(244, 548)
	log_label.size = Vector2(1090, 40)
	log_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	add_child(log_label)

	hand_row = HBoxContainer.new()
	hand_row.position = Vector2(244, 600)
	hand_row.size = Vector2(1090, 230)
	hand_row.alignment = BoxContainer.ALIGNMENT_CENTER
	hand_row.add_theme_constant_override("separation", 8)
	add_child(hand_row)

	end_btn = Button.new()
	end_btn.text = "END TURN"
	end_btn.position = Vector2(1352, 640)
	end_btn.size = Vector2(236, 76)
	end_btn.add_theme_font_size_override("font_size", 22)
	end_btn.pressed.connect(_on_end_turn)
	add_child(end_btn)
	endrun_btn = Button.new()   # RUN-001
	endrun_btn.text = "END RUN"
	endrun_btn.position = Vector2(1352, 846)
	endrun_btn.size = Vector2(236, 36)
	endrun_btn.add_theme_font_size_override("font_size", 13)
	endrun_btn.add_theme_color_override("font_color", Color("#ff6b78"))
	endrun_btn.pressed.connect(_confirm_end_run)
	add_child(endrun_btn)
	piles = _lbl("", 13, DIM)
	piles.position = Vector2(1352, 724)
	piles.size = Vector2(236, 80)
	add_child(piles)

	var np := _panel(Vector2(1346, 100), Vector2(244, 520), Color("#07120c"), Color("#2c7a4f"))
	var nv := VBoxContainer.new()
	nv.position = Vector2(12, 10)
	nv.size = Vector2(220, 500)
	nv.add_theme_constant_override("separation", 8)
	np.add_child(nv)
	var nh := HBoxContainer.new()
	nh.add_child(RIcon.make("NULREM", 34))
	var nt := VBoxContainer.new()
	var tr := HBoxContainer.new()
	var tl := _lbl("NUL/REM", 18, RIcon.COL.NULREM)
	tl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tr.add_child(tl)
	voice_btn = Button.new()
	voice_btn.tooltip_text = "NUL/REM's voice (M)"
	voice_btn.add_theme_font_size_override("font_size", 10)
	voice_btn.pressed.connect(_toggle_voice)
	tr.add_child(voice_btn)
	nt.add_child(tr)
	nt.add_child(_lbl("personality ROM · rev 0.08", 11, Color("#3f9a68")))
	nt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nh.add_child(nt)
	nv.add_child(nh)
	voice = AudioStreamPlayer.new()
	add_child(voice)
	_update_voice_btn()
	nr_text = _lbl("", 15, RIcon.COL.NULREM)
	nr_text.autowrap_mode = TextServer.AUTOWRAP_WORD
	nr_text.custom_minimum_size = Vector2(220, 0)
	nv.add_child(nr_text)
	nr_mode = _lbl("", 11, Color("#3f9a68"))
	nv.add_child(nr_mode)

	inspect = CenterContainer.new()
	inspect.position = Vector2(236, 100)
	inspect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inspect.visible = false
	inspect.z_index = 10
	add_child(inspect)
	blocker = Control.new()   # swallows clicks while the reels spin
	blocker.set_anchors_preset(Control.PRESET_FULL_RECT)
	blocker.mouse_filter = Control.MOUSE_FILTER_STOP
	blocker.visible = false
	add_child(blocker)
	overlay = Control.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(overlay)

func _new_run() -> void:
	g = Game.new()
	g.animate = true
	g.phase = "SELECT"   # RUSTLER-001: choose a Rustler first
	targeting = -1
	refresh()

func _start_as(who: String) -> void:
	g.new_run(who)
	nr.rustler = CardDB.RUSTLERS[who].nulrem
	if first_run:
		g.events.append({"t": "EV-02"})
		g.events = g.events.filter(func(e): return e.t != "EV-01")
	targeting = -1
	refresh()

# =====================================================================
# input
# =====================================================================

func _process(delta: float) -> void:
	idle += delta
	if idle > 60.0:
		idle = 0.0
		_speak_event({"t": "EV-37"})

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventKey:
		idle = 0.0
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KONAMI[konami_pos]:
			konami_pos += 1
			if konami_pos == KONAMI.size():
				konami_pos = 0
				_speak_event({"t": "EV-39"})
		else:
			konami_pos = 1 if event.keycode == KONAMI[0] else 0
		if event.keycode == KEY_M:
			_toggle_voice()
		if event.keycode == KEY_ESCAPE and targeting >= 0:
			targeting = -1
			refresh()
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT and targeting >= 0:
		targeting = -1
		refresh()

func _on_end_turn() -> void:
	if responding:
		return
	targeting = -1
	g.end_turn()
	refresh()
	if g.phase == "RESPONSE":
		_play_response()

func _play_response() -> void:
	responding = true
	fired = []
	flash = {}
	resp_total = g.response_queue.size()
	var gap: float = RESPONSE_MIN_SECONDS / float(resp_total + 1)
	refresh()
	await get_tree().create_timer(gap * 0.6).timeout
	while not g.response_queue.is_empty() and g.phase == "RESPONSE":
		var st: Dictionary = g.response_queue[0]
		flash = {"ref": st.ref, "sub": st.sub}
		g.response_step()        # values change only now, as it flashes
		refresh()
		await get_tree().create_timer(gap).timeout
		fired.append(flash)
	flash = {}
	await get_tree().create_timer(gap * 0.4).timeout
	var before := {}
	var enc_ref: Dictionary = g.enc
	for i in g.enc.ice.size():
		if IceDB.is_tumbler(g.enc.ice[i].id):
			before[i] = g.active_subs(i)
	g.response_finish()
	responding = false
	fired = []
	spin = {}
	if is_same(g.enc, enc_ref) and g.phase in ["PLAYER", "CHOICE"]:
		for i in before:
			if i < g.enc.ice.size() and g.active_subs(i) != before[i]:
				spin[i] = before[i]
	if spin.is_empty():
		refresh()
		return
	var longest := 0
	for i in spin:
		longest = maxi(longest, spin[i].size())
	spinning = true
	spin_built = false
	blocker.visible = true
	refresh()
	spin_built = true
	await get_tree().create_timer(_reel_time(longest - 1) + 0.35).timeout
	spinning = false
	spin = {}
	blocker.visible = false
	spin_deferred = false
	refresh()

func _is_flash(ice: Dictionary, s: int) -> bool:
	return not flash.is_empty() and is_same(flash.ref, ice) and flash.sub == s

func _was_fired(ice: Dictionary, s: int) -> bool:
	for f in fired:
		if is_same(f.ref, ice) and f.sub == s:
			return true
	return false

func _pulse(c: Control) -> void:
	c.modulate = Color(1.8, 1.8, 1.8)
	var tw := c.create_tween().set_loops(3)
	tw.tween_property(c, "modulate", Color(1, 1, 1), 0.14)
	tw.tween_property(c, "modulate", Color(1.8, 1.8, 1.8), 0.14)

func _on_card(uid: int) -> void:
	if g.phase != "PLAYER":
		return
	var c := g.find_card(uid)
	var d := CardDB.def(c.id)
	if d.get("target", false):
		if not g.can_play(uid).ok:
			g.log.append(g.can_play(uid).reason)
			refresh()
			return
		targeting = uid if targeting != uid else -1
		refresh()
		return
	g.play_card(uid)
	refresh()

func _on_ice_clicked(i: int) -> void:
	if targeting < 0:
		return
	g.play_card(targeting, i)
	targeting = -1
	refresh()

func _on_break(i: int, s: int) -> void:
	g.break_sub(i, s)
	refresh()

# =====================================================================
# refresh
# =====================================================================

func refresh() -> void:
	if spinning and spin_built:
		spin_deferred = true   # don't rebuild (and restart) the reels mid-spin
		return
	_handle_events()
	_build_hud()
	_build_info()
	_build_rig()
	_build_ice()
	_build_preview()
	_build_hand()
	var in_enc: bool = not g.enc.is_empty() and g.phase in ["PLAYER", "CHOICE", "RESPONSE"]
	end_btn.disabled = g.phase != "PLAYER"
	end_btn.visible = in_enc
	endrun_btn.visible = g.phase not in ["SELECT", "DEAD", "SLICE_DONE"]
	endrun_btn.disabled = responding
	log_label.text = "  ·  ".join(g.log.slice(max(0, g.log.size() - 3)))
	if g.phase == "CHOICE" and g.pending.get("kind", "") == "card_break":
		log_label.text = "%s: choose a subroutine to break (%d left)." % [g.pending.card, g.pending.n]
	if g.phase == "CHOICE" and g.pending.get("kind", "") == "patient_zero":
		log_label.text = "PATIENT ZERO: choose an ICE to INFECT with 1 ROT."
	if targeting >= 0:
		log_label.text = "Choose an ICE for %s (right-click or Esc to cancel)." % CardDB.def(g.find_card(targeting).id).name
	piles.text = "DECK %d   DISCARD %d   BURNED %d" % [g.draw_pile.size(), g.discard.size(), g.burned.size()] if in_enc else ""
	_build_overlay()

func _handle_events() -> void:
	if g.events.is_empty():
		return
	var best := {}
	var best_rank := 999
	for e in g.events:
		if e.t == "EV-21":
			last_bloat = e.get("card", "")
		if e.t == "SLICE_DONE":
			continue
		var rank := PRIORITY.find(e.t)
		if rank >= 0 and rank < best_rank:
			best_rank = rank
			best = e
	g.events.clear()
	if not best.is_empty():
		_speak_event(best)

func _speak_event(e: Dictionary) -> void:
	var ctx := {"corp": "HALCYON", "bloat": e.get("card", last_bloat), "rest": "SAFEHOUSE"}
	if e.t == "EV-35":
		ctx["cause"] = "TRACE" if g.lockdown else ""
	var line := nr.pick(e.t, ctx)
	if line.is_empty():
		return
	if e.t == "EV-02" and first_run:
		first_run = false
		_save_flags()
	nr_text.text = line.text
	nr_mode.text = "%s · %s · %s" % [line.id, e.t, line.mode]
	nr_text.visible_ratio = 0.0
	if tween:
		tween.kill()
	var type_time: float = clamp(line.text.length() / 45.0, 0.6, 3.5)
	voice.stop()
	var path := "res://audio/nulrem/%s.ogg" % str(line.id).replace(" ", "_")
	if voice_on and ResourceLoader.exists(path):
		var stream: AudioStream = load(path)
		voice.stream = stream
		voice.play()
		type_time = max(0.6, stream.get_length() * 0.92)   # type in step with the voice
	tween = create_tween()
	tween.tween_property(nr_text, "visible_ratio", 1.0, type_time)

func _toggle_voice() -> void:
	voice_on = not voice_on
	if not voice_on:
		voice.stop()
	_update_voice_btn()
	_save_flags()

func _update_voice_btn() -> void:
	voice_btn.text = "VOICE ON" if voice_on else "MUTED"
	voice_btn.modulate = Color(1, 1, 1) if voice_on else Color(1, 1, 1, 0.5)

func _build_hud() -> void:
	_clear(hud)
	hud.add_child(_stat("VITAE", "%d / %d" % [g.vitae, g.max_vitae]))
	hud.add_child(_stat("SHIELD", str(g.shield)))
	var bwbox := HBoxContainer.new()
	bwbox.add_child(RIcon.make("BW", 22))
	for i in Game.BW_PER_TURN:
		var pip := ColorRect.new()
		pip.custom_minimum_size = Vector2(14, 22)
		pip.color = RIcon.COL.BW if i < g.bw else Color("#26303f")
		bwbox.add_child(pip)
	if g.bw > Game.BW_PER_TURN:
		bwbox.add_child(_lbl("+%d" % (g.bw - Game.BW_PER_TURN), 15, RIcon.COL.BW))
	bwbox.add_child(_lbl(" BW %d" % g.bw, 15, RIcon.COL.BW))
	if not g.enc.is_empty() and g.enc.get("bw_drained", 0) > 0 and g.phase in ["PLAYER", "CHOICE"]:
		bwbox.add_child(_lbl(" −%d DETAINED " % g.enc.bw_drained, 12, Color("#0b0e13"), RIcon.COL.BW))
	hud.add_child(bwbox)
	var tb := HBoxContainer.new()
	tb.add_child(RIcon.make("TRACE", 22))
	var bar := TraceBar.new()
	bar.value = g.trace
	bar.custom_minimum_size = Vector2(240, 22)
	tb.add_child(bar)
	tb.add_child(_lbl(" TRACE %d / 40" % g.trace, 15, RIcon.COL.TRACE))
	var sp := HBoxContainer.new()
	for i in 3:
		sp.add_child(_lbl("●" if i < g.strikes else "○", 15, RIcon.COL.PULP if i < g.strikes else DIM))
	tb.add_child(_lbl("  STRIKES ", 12, DIM))
	tb.add_child(sp)
	hud.add_child(tb)
	hud.add_child(_stat("CRED", str(g.cred)))
	if not g.installed.is_empty():
		hud.add_child(_stat("RAM", "%d / %d" % [g.ram_used(), g.ram_total()]))
	hud.add_child(_stat("DRAW", "%d" % g.draw_size()))
	if g.phase != "SELECT":
		var rc := _lbl("  %s · %s  " % [CardDB.RUSTLERS[g.rustler].name, CardDB.RUSTLERS[g.rustler].origin], 13, Color("#0b0e13"), RUSTLER_COL[g.rustler])
		rc.tooltip_text = CardDB.RUSTLERS[g.rustler].origin_text
		rc.mouse_filter = Control.MOUSE_FILTER_PASS
		hud.add_child(rc)
	var corp := _lbl("  HALCYON  ", 14, Color("#2a1a10"))
	var sb := StyleBoxFlat.new()
	sb.bg_color = RIcon.COL.HALCYON
	sb.set_corner_radius_all(3)
	corp.add_theme_stylebox_override("normal", sb)
	hud.add_child(corp)

func _build_info() -> void:
	_clear(info)
	if g.enc.is_empty() or not (g.phase in ["PLAYER", "CHOICE", "RESPONSE"]):
		return
	info.add_child(_lbl(g.node.name, 18, TEXT))
	info.add_child(_lbl("LAYER %d of %d" % [g.layer + 1, g.node.layers.size()], 14, DIM))
	var dl := g.deadlock_view()
	var dh := HBoxContainer.new()
	dh.add_child(RIcon.make("DEADLOCK", 16))
	var dtxt := " DEADLOCKS %d of %d seen" % [dl.done, dl.seen]
	if dl.unseen > 0:
		dtxt += "  ·  %d subroutine%s unseen" % [dl.unseen, "" if dl.unseen == 1 else "s"]
	dh.add_child(_lbl(dtxt, 14, TEXT))
	info.add_child(dh)
	info.add_child(_lbl("TURN %d" % g.enc.turn, 14, DIM))
	# CRED meter (UI-002): this encounter's reserve, left / total; 0 shows in red.
	var rh := HBoxContainer.new()
	rh.add_theme_constant_override("separation", 6)
	rh.add_child(RIcon.make("CRED", 16))
	var left: int = g.enc.reserve
	var total: int = max(1, g.enc.reserve_start)
	var bar := Control.new()
	bar.custom_minimum_size = Vector2(120, 14)
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var back := ColorRect.new()
	back.color = Color("#26303f")
	back.size = Vector2(120, 14)
	bar.add_child(back)
	var fill := ColorRect.new()
	fill.color = RIcon.COL.CRED
	fill.size = Vector2(120.0 * float(left) / float(total), 14)
	bar.add_child(fill)
	rh.add_child(bar)
	var red := Color("#ff4d5e")
	rh.add_child(_lbl("%d" % left, 15, red if left == 0 else RIcon.COL.CRED))
	rh.add_child(_lbl("/ %d CRED" % g.enc.reserve_start, 13, DIM))
	rh.tooltip_text = "CRED left to extract in this encounter."
	info.add_child(rh)
	if g.enc.breached:
		info.add_child(_lbl("BREACHED", 18, Color("#58f29a")))
	if g.lockdown:
		info.add_child(_lbl("LOCKDOWN", 18, RIcon.COL.PULP))

func _build_rig() -> void:
	_clear(rig)
	rig.add_child(_lbl("RIG", 13, DIM))
	if g.enc.is_empty():
		return
	for p in g.installed:
		var d := CardDB.def(p.inst.id)
		var row := HBoxContainer.new()
		var k := "RAM"
		if d.has("pick"):
			k = d.pick.itype
		elif d.has("extract"):
			k = "CRED"
		row.add_child(RIcon.make(k, 22))
		var v := VBoxContainer.new()
		v.add_child(_lbl(d.name, 13, TEXT))
		if d.has("pick"):
			var extra := " (+%d)" % p.boost if p.boost > 0 else ""
			var sh := HBoxContainer.new()
			sh.add_child(_lbl("STR %d%s" % [g.pick_str(p), extra], 13, TEXT))
			var bchk := g.can_boost(p.inst.uid)
			var bb := Button.new()
			bb.text = "+%d STR · %s" % [d.pick.boost_amt, "FREE" if bchk.cost == 0 else "%d BW" % bchk.cost]
			bb.tooltip_text = "Boost this Icepick. Boosts last until the encounter ends."
			bb.add_theme_font_size_override("font_size", 11)
			bb.disabled = not bchk.ok or targeting >= 0
			var puid: int = p.inst.uid
			bb.pressed.connect(func(): g.boost_pick(puid); refresh())
			sh.add_child(bb)
			v.add_child(sh)
			if d.pick.get("free_first", false) and not p.free_used:
				v.add_child(_lbl("free break ready", 11, Color("#58f29a")))
		elif d.has("extract"):
			v.add_child(_lbl("+%d CRED end of turn" % d.extract, 12, DIM))
		v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(v)
		var x := Button.new()
		x.text = "×"
		x.tooltip_text = "Unload (0 BW): goes to your discard pile"
		x.disabled = g.phase != "PLAYER"
		x.pressed.connect(func(): g.unload(p.inst.uid); refresh())
		row.add_child(x)
		_make_inspectable(row, p.inst.id)
		rig.add_child(row)
	if not g.rack.is_empty():
		rig.add_child(_lbl("RACK (Protocols)", 13, DIM))
		for c in g.rack:
			var r := HBoxContainer.new()
			var sw := ColorRect.new()
			sw.custom_minimum_size = Vector2(6, 18)
			sw.color = TYPE_COL.PROTOCOL
			r.add_child(sw)
			r.add_child(_lbl(" " + CardDB.def(c.id).name, 13, TEXT))
			_make_inspectable(r, c.id)
			rig.add_child(r)

func _make_inspectable(c: Control, id: String) -> void:
	## FIX-002: hover (or click) an installed card to see the full card beside the rig.
	c.mouse_filter = Control.MOUSE_FILTER_PASS
	c.mouse_entered.connect(func(): _show_inspect(id))
	c.mouse_exited.connect(func(): _show_inspect(""))
	c.gui_input.connect(func(ev):
		if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT:
			_show_inspect("" if inspect.visible else id))

func _show_inspect(id: String) -> void:
	_clear(inspect)
	inspect.visible = id != ""
	if id != "":
		var cv := _card_view(id, -1)
		cv.custom_minimum_size = Vector2(200, 270)
		cv.mouse_filter = Control.MOUSE_FILTER_IGNORE
		inspect.add_child(cv)

func _build_ice() -> void:
	_clear(ice_row)
	if g.enc.is_empty() or not (g.phase in ["PLAYER", "CHOICE", "RESPONSE"]):
		return
	var main_i: int = g.enc.ice.size() - 1
	for i in g.enc.ice.size():
		ice_row.add_child(_ice_card(i, i == main_i))

func _ice_card(i: int, is_main: bool) -> Control:
	var ice: Dictionary = g.enc.ice[i]
	var d := IceDB.def(ice.id)
	var black: bool = d.get("black", false)
	var pc := PanelContainer.new()
	pc.custom_minimum_size = Vector2(320 if is_main else 290, 350)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color("#0a0a0c") if black else PANEL
	sb.border_color = Color("#ff4d5e") if black else (Color("#e6ebf2") if is_main else Color("#4a5568"))
	sb.set_border_width_all(4 if is_main or black else 1)
	if targeting >= 0:
		sb.border_color = Color("#4fd2ff")
		sb.set_border_width_all(4)
	sb.set_corner_radius_all(6)
	sb.content_margin_left = 12
	sb.content_margin_right = 12
	sb.content_margin_top = 8
	sb.content_margin_bottom = 10
	pc.add_theme_stylebox_override("panel", sb)
	pc.gui_input.connect(func(ev):
		if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT:
			_on_ice_clicked(i))
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 5)
	pc.add_child(v)
	# corporation band, tier badge, role tab
	var band := HBoxContainer.new()
	var corp := _lbl(" HALCYON ", 11, Color("#2a1a10"))
	var cs := StyleBoxFlat.new()
	cs.bg_color = RIcon.COL.HALCYON
	corp.add_theme_stylebox_override("normal", cs)
	band.add_child(corp)
	band.add_child(_lbl("  " + str(d.tier), 11, DIM))
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	band.add_child(sp)
	band.add_child(_lbl("BLACK ICE · NO DEADLOCK" if black else ("MAIN" if is_main else "SUPPORT"), 11, RIcon.COL.PULP if black else TEXT))
	v.add_child(band)
	# header: icon, NAME — TYPE, STR
	var head := HBoxContainer.new()
	head.add_child(RIcon.make(d.type, 34))
	var nm := VBoxContainer.new()
	nm.add_child(_lbl(d.name, 19, TEXT))
	if d.get("subtype", "") != "":
		var th := HBoxContainer.new()
		th.add_child(_lbl(d.type + " · ", 12, DIM))
		th.add_child(_lbl(" %s " % d.subtype, 11, Color("#0b0e13"), RIcon.COL.BW if d.subtype == "DETAINER" else Color("#c7b9ff")))
		nm.add_child(th)
	else:
		nm.add_child(_lbl(d.type, 12, DIM))
	nm.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(nm)
	var cur := g.ice_str(i)
	var sv := VBoxContainer.new()
	sv.add_child(_lbl("STR %d" % cur, 28, TEXT))
	if cur != d.str:
		sv.add_child(_lbl("base %d" % d.str, 11, DIM))
	head.add_child(sv)
	v.add_child(head)
	# BOOTING pips
	if d.get("ability", "") == "BOOTING":
		var bh := HBoxContainer.new()
		bh.add_child(_lbl("BOOTING ", 12, RIcon.COL.TRACE))
		for t in 3:
			var on: bool = g.enc.turn >= t + 1
			bh.add_child(_lbl(" T%d " % (t + 1), 12, Color("#0b0e13") if on else DIM, RIcon.COL.TRACE if on else Color("#232a36")))
		v.add_child(bh)
	if g.phase == "CHOICE" and g.pending.get("kind", "") == "patient_zero":
		var pzb := Button.new()
		pzb.text = "PATIENT ZERO · INFECT 1 ROT HERE"
		pzb.add_theme_color_override("font_color", STRAIN_COL.ROT)
		pzb.pressed.connect(func(): g.choose_ice(i); refresh())
		v.add_child(pzb)
	# subroutines (TUMBLERs: only the subroutines in its slots; the rest are face-down)
	var act := g.active_subs(i)
	var tumbler := IceDB.is_tumbler(ice.id)
	for k in act.size():
		var s: int = act[k]
		if not ice.seen[s]:
			var fh := HBoxContainer.new()
			fh.add_child(_lbl("[S%d]" % (s + 1), 12, DIM))
			fh.add_child(RIcon.make("HIDDEN", 20, RIcon.COL.VOID))
			fh.add_child(_lbl("  ? fires this turn · revealed when it fires", 12, RIcon.COL.VOID))
			v.add_child(fh)
			continue
		var srow := _sub_row(i, s, d.subs[s], ice.broken[s], ("SLOT %d · S%d" % [k + 1, s + 1]) if tumbler else ("[S%d]" % (s + 1)))
		var content: Control = srow
		if _is_flash(ice, s):
			var fp := PanelContainer.new()
			var fsb := StyleBoxFlat.new()
			fsb.bg_color = Color(1, 0.3, 0.35, 0.22)
			fsb.border_color = Color("#ff4d5e")
			fsb.set_border_width_all(2)
			fsb.set_corner_radius_all(4)
			fp.add_theme_stylebox_override("panel", fsb)
			fp.add_child(srow)
			_pulse(fp)
			content = fp
		elif _was_fired(ice, s):
			srow.modulate = Color(1, 1, 1, 0.55)
		if tumbler:
			var prev_row: Control = null
			if spin.has(i) and k < spin[i].size():
				var ps: int = spin[i][k]
				prev_row = _sub_row(i, ps, d.subs[ps], ice.broken[ps], "SLOT %d · S%d" % [k + 1, ps + 1])
			v.add_child(_reel(content, prev_row, k, spin.has(i)))
		else:
			v.add_child(content)
	var hid := g.hidden_count(i)
	if hid > 0:
		var hh := HBoxContainer.new()
		for n in hid:
			hh.add_child(RIcon.make("HIDDEN", 20, DIM))
		hh.add_child(_lbl("  %d hidden · %s" % [hid, "rotates 1 step each turn" if tumbler else "one more fires each turn"], 12, DIM))
		v.add_child(hh)
	if not ice.virus.is_empty():
		var vh := HFlowContainer.new()
		vh.add_theme_constant_override("h_separation", 6)
		for k in Game.STRAINS:
			var n: int = int(ice.virus.get(k, 0))
			if n <= 0:
				continue
			var chip := _lbl(" %s %d " % [k, n], 12, Color("#0b0e13"), STRAIN_COL[k])
			chip.tooltip_text = STRAIN_TIP[k]
			chip.mouse_filter = Control.MOUSE_FILTER_PASS
			vh.add_child(chip)
		var vrow := HBoxContainer.new()
		vrow.add_child(RIcon.make("VIRUS", 18))
		vrow.add_child(vh)
		v.add_child(vrow)
	if d.has("ability_text"):
		var ah := HBoxContainer.new()
		var pk: String = d.get("passive", d.get("ability", ""))
		var picon := {"CLOAK_TRACE": "CLOAK", "WATCHER": "CLOAK", "BOOTING": "TRACE", "TOLL": "BW", "SEQUENCED": "DEADLOCK",
			"HARDENING": "STR", "RELAY": "STR", "TRIPWIRE": "TRACE"}
		ah.add_child(RIcon.make(picon.get(pk, "ICE"), 16))
		var al := _lbl(" " + d.ability_text, 12, Color("#c7b9ff"))
		al.autowrap_mode = TextServer.AUTOWRAP_WORD
		al.custom_minimum_size = Vector2(250, 0)
		ah.add_child(al)
		v.add_child(ah)
	return pc

func _reel_time(k: int) -> float:
	return 0.95 + 0.5 * k   # each later slot spins longer, so the reels stop one after another

func _reel(final_row: Control, prev_row: Control, k: int, spin_now: bool) -> Control:
	## A slot-machine window. The real row sets the window's size; while spinning, a strip of rows
	## rolls downward over it (the previous subroutine, a blur of others, then this turn's) and clunks to a stop.
	var frame := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color("#0a0e14")
	sb.border_color = Color("#3a4658")
	sb.set_border_width_all(1)
	sb.set_corner_radius_all(4)
	sb.content_margin_left = 3
	sb.content_margin_right = 3
	frame.add_theme_stylebox_override("panel", sb)
	var holder := MarginContainer.new()
	holder.custom_minimum_size = Vector2(0, REEL_H)
	holder.clip_contents = true
	frame.add_child(holder)
	final_row.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	holder.add_child(final_row)
	if spin_now:
		final_row.modulate.a = 0.0
		var win := Control.new()
		win.clip_contents = true
		win.mouse_filter = Control.MOUSE_FILTER_IGNORE
		holder.add_child(win)
		var strip := VBoxContainer.new()
		strip.add_theme_constant_override("separation", 0)
		strip.set_anchors_preset(Control.PRESET_TOP_WIDE)
		strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		win.add_child(strip)
		var landing: Control = final_row.duplicate()
		landing.modulate.a = 1.0
		var rows: Array = [landing]
		for n in 7 + 4 * k:
			rows.append(_reel_blur_row())
		rows.append(prev_row if prev_row != null else _reel_blur_row())
		for r in rows:
			var cell := MarginContainer.new()
			cell.custom_minimum_size = Vector2(0, REEL_H)
			cell.mouse_filter = Control.MOUSE_FILTER_IGNORE
			r.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			cell.add_child(r)
			strip.add_child(cell)
		var n_rows: int = rows.size()
		strip.position.y = -(n_rows - 1) * REEL_H
		strip.modulate = Color(1, 1, 1, 0.75)
		var dur := _reel_time(k)
		var tw := strip.create_tween()
		# fast spin that slows down, runs slightly past the stop, then clunks back into place
		tw.tween_property(strip, "position:y", REEL_H * 0.22, dur).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		tw.parallel().tween_property(strip, "modulate", Color(1, 1, 1, 1), dur * 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tw.tween_property(strip, "position:y", 0.0, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tw.tween_callback(func():
			final_row.modulate.a = 1.0
			win.queue_free()
			frame.modulate = Color(1.7, 1.7, 1.7)
			var fl := frame.create_tween()
			fl.tween_property(frame, "modulate", Color(1, 1, 1), 0.3))
	# glass: darker at the top and bottom edges of the window, like a reel drum curving away
	var glass := Control.new()
	glass.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(glass)
	for top in [true, false]:
		var shade := TextureRect.new()
		var grad := Gradient.new()
		grad.set_color(0, Color(0, 0, 0, 0.7) if top else Color(0, 0, 0, 0))
		grad.set_color(1, Color(0, 0, 0, 0) if top else Color(0, 0, 0, 0.7))
		var gt := GradientTexture2D.new()
		gt.gradient = grad
		gt.fill_from = Vector2(0, 0)
		gt.fill_to = Vector2(0, 1)
		gt.width = 4
		gt.height = 32
		shade.texture = gt
		shade.stretch_mode = TextureRect.STRETCH_SCALE
		shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
		shade.set_anchors_preset(Control.PRESET_TOP_WIDE if top else Control.PRESET_BOTTOM_WIDE)
		if top:
			shade.offset_bottom = 8
		else:
			shade.offset_top = -8
		glass.add_child(shade)
	return frame

func _reel_blur_row() -> Control:
	## A subroutine passing by too fast to read (random icons, so it reveals nothing).
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 10)
	h.add_child(_lbl("· · ·", 12, DIM))
	var kinds := ["PULP", "TRACE", "DEADLOCK", "BW", "CARD", "CORTEX"]
	for n in 2 + randi() % 2:
		h.add_child(RIcon.make(kinds[randi() % kinds.size()], 18, Color(0.55, 0.6, 0.7, 0.5)))
	var streak := ColorRect.new()
	streak.color = Color(0.6, 0.66, 0.78, 0.18)
	streak.custom_minimum_size = Vector2(90 + randi() % 120, 3)
	streak.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(streak)
	return h

func _sub_row(i: int, s: int, effects: Array, broken: bool, tag: String) -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	row.add_child(_lbl(tag, 12, DIM))
	var chips := HFlowContainer.new()
	chips.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for e0 in effects:
		var ch := _chip(g.effect_value(g.enc.ice[i], e0) if e0.k == "PULP_CURVE" else e0)
		if e0.k == "PULP_CURVE":
			var cv: Dictionary = IceDB.CURVES[e0.curve]
			ch.tooltip_text = "%s PULP curve: deals the next value each Corporation Response (%s)." % [cv.name, ", ".join(cv.seq.map(func(x): return str(x))) if e0.curve != "B" else "9 values from 1 to 6, in a random order"]
			ch.mouse_filter = Control.MOUSE_FILTER_PASS
		chips.add_child(ch)
	row.add_child(chips)
	if broken:
		row.modulate = Color(1, 1, 1, 0.4)
		row.add_child(_lbl("BROKEN", 12, DIM))
		return row
	if g.phase == "CHOICE" and g.pending.get("kind", "") == "card_break":
		var cb := Button.new()
		cb.custom_minimum_size = Vector2(92, 30)
		cb.text = "BREAK · %s" % g.pending.card
		cb.disabled = not g.card_break_ok(i, s)
		cb.pressed.connect(func(): g.choose_sub(i, s); refresh())
		row.add_child(cb)
		return row
	var info := g.break_info(i, s)
	var b := Button.new()
	b.custom_minimum_size = Vector2(92, 30)
	if info.ok:
		b.text = "FREE" if info.cost == 0 else "BREAK %d BW" % info.cost
		if info.boosts > 0:
			b.tooltip_text = "Includes %d boost(s)." % info.boosts
	else:
		b.text = info.reason
		b.disabled = true
	b.disabled = b.disabled or g.phase != "PLAYER" or targeting >= 0
	b.pressed.connect(func(): _on_break(i, s))
	row.add_child(b)
	return row

func _chip(e: Dictionary) -> Control:
	var k: String = e.k
	var col := RIcon.COL.SLATE
	var icon := "STR"
	var word := k
	match k:
		"PULP":
			col = RIcon.COL.PULP; icon = "PULP"; word = "PULP %d" % e.v
			if e.has("curve"):
				word = ("PULP ?" if e.curve == "B" else "PULP %d" % e.v) + " · " + IceDB.CURVES[e.curve].name
		"CORTEX":
			col = RIcon.COL.CORTEX; icon = "CORTEX"; word = "CORTEX %d" % e.v
		"TRACE":
			col = RIcon.COL.TRACE; icon = "TRACE"; word = "TRACE %d" % e.v
		"DEADLOCK":
			col = RIcon.COL.DEADLOCK; icon = "DEADLOCK"; word = "DEADLOCK"
		"BW_DRAIN":
			col = RIcon.COL.BW; icon = "BW"; word = "−%d BW next turn" % e.v
		"DISCARD":
			col = RIcon.COL.TEAL; icon = "CARD"; word = "DISCARD %d next turn" % e.v
		"INSERT":
			col = RIcon.COL.TEAL; icon = "CARD"; word = "INSERT %d %s → %s" % [e.v, e.card, "draw pile" if e.to == "draw" else "discard pile"]
	var pc := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(col.r, col.g, col.b, 0.16)
	sb.border_color = col
	sb.set_border_width_all(1)
	sb.set_corner_radius_all(3)
	sb.content_margin_left = 4
	sb.content_margin_right = 6
	pc.add_theme_stylebox_override("panel", sb)
	var h := HBoxContainer.new()
	h.add_child(RIcon.make(icon, 16, col))
	h.add_child(_lbl(" " + word, 12, col))
	pc.add_child(h)
	return pc

func _build_preview() -> void:
	_clear(preview)
	preview_total.text = ""
	if g.enc.is_empty() or not (g.phase in ["PLAYER", "CHOICE", "RESPONSE"]):
		return
	if g.enc.breached:
		preview_total.text = "BREACHED: Corporation Response skipped."
		return
	var n := 1
	var pulp := 0
	var tr := 0
	var ghost: bool = g.enc.ghost
	var proxy := g._rack_count("PROXY_CHAIN")
	var unknown := 0
	var random_pulp := 0
	for st in g.response_preview():
		var txt := []
		if st.hidden and not st.skipped:
			unknown += 1
			preview.add_child(_lbl("%s %s ? (hidden)" % [_circled(n), st.name], 12, RIcon.COL.VOID))
			n += 1
			continue
		for e0 in st.effects:
			var e: Dictionary = g.effect_value(g.enc.ice[st.ice], e0)
			if e.get("curve", "") == "B":
				txt.append("PULP ?")
				if not st.skipped:
					random_pulp += 1
				continue
			txt.append(_effect_word(e))
			if not st.skipped:
				if e.k == "PULP":
					pulp += e.v
				elif e.k == "TRACE":
					var t: int = e.v
					if ghost:
						ghost = false
						t = 0
					tr += max(0, t - proxy)
		var sref: Dictionary = g.enc.ice[st.ice]
		var now := _is_flash(sref, st.sub)
		var done := _was_fired(sref, st.sub)
		var l := _lbl("%s%s %s %s" % ["▶ " if now else "", _circled(n), st.name, " + ".join(txt)], 13 if now else 12, Color("#ff4d5e") if now else (DIM if st.skipped or done else TEXT))
		if st.skipped:
			l.text += " (skipped)"
		preview.add_child(l)
		n += 1
	var tracer := 0
	for c in g.hand:
		if c.id == "TRACER":
			tracer += 3
	var drain := 0
	for st in g.response_preview():
		if not st.skipped and not st.hidden:
			for e in st.effects:
				if e.k == "BW_DRAIN":
					drain += e.v
	var absorbed: int = min(g.shield, pulp)
	var parts := []
	if pulp > 0:
		parts.append("PULP %d → SHIELD absorbs %d, VITAE −%d" % [pulp, absorbed, pulp - absorbed])
	if tr + tracer > 0:
		parts.append("TRACE +%d → %d / 40" % [tr + tracer, min(40, g.trace + tr + tracer)])
	if drain > 0:
		parts.append("BW −%d next turn" % drain)
	if random_pulp > 0:
		parts.append("+ random PULP (1–6)")
	if unknown > 0:
		parts.append("+ %d hidden subroutine%s" % [unknown, "" if unknown == 1 else "s"])
	preview_total.text = "If you end turn: " + ("  ·  ".join(parts) if not parts.is_empty() else "no damage, no TRACE")
	if responding:
		preview_total.text = "Resolving %d of %d…" % [fired.size() + (0 if flash.is_empty() else 1), resp_total]
		if g.enc.get("purged_now", false):
			preview_total.text = "HALCYON PURGES every virus counter instead of taking its turn."
			preview_total.add_theme_color_override("font_color", STRAIN_COL.ROT)
		else:
			preview_total.remove_theme_color_override("font_color")

func _effect_word(e: Dictionary) -> String:
	match e.k:
		"INSERT": return "INSERT %s" % e.card
		"DEADLOCK": return "DEADLOCK"
		"BW_DRAIN": return "−%d BW" % e.v
		_: return "%s %d" % [e.k, e.get("v", 0)]

func _circled(n: int) -> String:
	var c := ["①", "②", "③", "④", "⑤", "⑥", "⑦", "⑧", "⑨", "⑩"]
	return c[n - 1] if n <= c.size() else str(n)

func _build_hand() -> void:
	_clear(hand_row)
	if g.enc.is_empty() or not (g.phase in ["PLAYER", "CHOICE", "RESPONSE"]):
		return
	for c in g.hand:
		var cv := _card_view(c.id, c.uid, targeting == c.uid)
		if c.get("cached", false):
			var cb := _lbl(" CACHED ", 10, Color("#0b0e13"), RIcon.COL.CLOAK)
			cv.get_child(0).add_child(cb)
		var chk := g.can_play(c.uid)
		if not chk.ok:
			cv.modulate = Color(1, 1, 1, 0.55)
			cv.tooltip_text = chk.reason
		var uid: int = c.uid
		cv.gui_input.connect(func(ev):
			if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT:
				_on_card(uid))
		hand_row.add_child(cv)

func _card_view(id: String, uid: int, selected: bool = false) -> PanelContainer:
	var d := CardDB.def(id)
	var pc := PanelContainer.new()
	pc.custom_minimum_size = Vector2(150, 214)
	var col: Color = TYPE_COL.get(d.type, TEXT)
	var sb := StyleBoxFlat.new()
	sb.bg_color = PANEL
	sb.border_color = Color("#4fd2ff") if selected else col.darkened(0.35)
	sb.set_border_width_all(3 if selected else 2)
	sb.set_corner_radius_all(6)
	sb.content_margin_left = 8
	sb.content_margin_right = 8
	sb.content_margin_top = 6
	sb.content_margin_bottom = 6
	pc.add_theme_stylebox_override("panel", sb)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 4)
	pc.add_child(v)
	var top := HBoxContainer.new()
	var tl := _lbl(" " + d.type + " ", 10, Color("#0b0e13"), col)
	top.add_child(tl)
	var sp := Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(sp)
	top.add_child(_lbl(d.rarity, 9, RARITY_COL.get(d.rarity, DIM)))
	v.add_child(top)
	var nl := _lbl(d.name, 14, TEXT)
	nl.autowrap_mode = TextServer.AUTOWRAP_WORD
	v.add_child(nl)
	var cost := HBoxContainer.new()
	cost.add_child(RIcon.make("BW", 16))
	var shown_cost: int = g.card_cost(id) if not g.enc.is_empty() else d.bw
	cost.add_child(_lbl("%d " % shown_cost, 13, RIcon.COL.BW))
	if d.type == "PROGRAM":
		cost.add_child(RIcon.make("RAM", 16))
		cost.add_child(_lbl("%d " % d.get("ram", 0), 13, RIcon.COL.RAM))
	if d.get("trace_cost", 0) > 0:
		cost.add_child(RIcon.make("TRACE", 16))
		cost.add_child(_lbl("+%d" % d.trace_cost, 13, RIcon.COL.TRACE))
	v.add_child(cost)
	var tags := HBoxContainer.new()
	if d.has("pick"):
		tags.add_child(RIcon.make(d.pick.itype, 18))
		tags.add_child(_lbl(" ICEPICK · " + d.pick.itype + " ", 10, DIM))
	for t in d.tags:
		if t == "CLOAK" or t == "EXPLOIT":
			tags.add_child(RIcon.make(t, 16))
			tags.add_child(_lbl(" " + t + " ", 10, RIcon.COL[t]))
		elif t == "EXTRACTOR":
			tags.add_child(RIcon.make("CRED", 14))
			tags.add_child(_lbl(" EXTRACTOR", 10, RIcon.COL.CRED))
		elif t == "VIRUS":
			tags.add_child(RIcon.make("VIRUS", 16))
			tags.add_child(_lbl(" VIRUS ", 10, RIcon.COL.VIRUS))
	v.add_child(tags)
	var tx := _lbl(d.text, 11, Color("#c4ccd8"))
	tx.autowrap_mode = TextServer.AUTOWRAP_WORD
	tx.custom_minimum_size = Vector2(132, 0)
	v.add_child(tx)
	return pc

# =====================================================================
# overlays for non-encounter phases
# =====================================================================

func _build_overlay() -> void:
	_clear(overlay)
	if confirming_end:
		var v := _dim_box("END THIS RUN?", "Your Rustler fails and the run is over. You'll return to the start menu to choose a Rustler.", 620)
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 16)
		var yes := Button.new()
		yes.text = "YES, END THE RUN"
		yes.custom_minimum_size = Vector2(260, 52)
		yes.add_theme_color_override("font_color", Color("#ff6b78"))
		yes.pressed.connect(_end_run)
		var no := Button.new()
		no.text = "KEEP PLAYING"
		no.custom_minimum_size = Vector2(260, 52)
		no.pressed.connect(func(): confirming_end = false; refresh())
		row.add_child(yes)
		row.add_child(no)
		v.add_child(row)
		return
	match g.phase:
		"SELECT": _overlay_select()
		"MAP": _overlay_map()
		"READY_RIG": _overlay_options("READY RIG", "Generalist ORIGIN: choose one PROGRAM in your deck. It starts installed for free; your first hand stays full.", g.pending.options, g.draw_pile, func(u): g.choose_ready_rig(u); refresh(), "Skip", func(): g.skip_ready_rig(); refresh())
		"CHOICE":
			match g.pending.kind:
				"discard": _overlay_options("DISCARD %d" % g.pending.n, "CAPTCHA: choose a card in your hand to discard.", g.hand.map(func(c): return c.uid), g.hand, func(u): g.choose(u); refresh())
				"uninstaller": _overlay_options("UNINSTALLER", "Choose a Bloatware in your hand to BURN.", g.pending.options, g.hand, func(u): g.choose(u); refresh())
				"field_kit": _overlay_options("FIELD KIT", "Choose a PROGRAM from your draw pile.", g.pending.options, g.draw_pile, func(u): g.choose(u); refresh())
				"cache": _overlay_options("DEAD AIR", "Choose a card to CACHE: it stays in your hand at the end of your turn.", g.pending.options, g.hand, func(u): g.choose(u); refresh())
		"DEEPER": _overlay_deeper()
		"REWARD": _overlay_reward()
		"SAFEHOUSE": _overlay_safehouse()
		"SLICE_DONE": _overlay_end("SLICE COMPLETE", "You made it through HALCYON's first rows.\nVITAE %d · CRED %d · TRACE %d · strikes %d · deck %d cards" % [g.vitae, g.cred, g.trace, g.strikes, g.run_deck.size()])
		"DEAD": _overlay_end("VITAE 0", "The run is over.")

func _confirm_end_run() -> void:
	if responding or spinning:
		return
	confirming_end = true
	refresh()

func _end_run() -> void:
	## The Rustler fails: NUL/REM gets his line, then back to the start menu.
	confirming_end = false
	g.abandon()
	refresh()
	_clear(overlay)
	await get_tree().create_timer(2.5).timeout
	_new_run()

func _dim_box(title: String, sub: String, w: float = 900) -> VBoxContainer:
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.72)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay.add_child(dim)
	var pc := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = PANEL
	sb.border_color = Color("#3a4558")
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(8)
	sb.set_content_margin_all(22)
	pc.add_theme_stylebox_override("panel", sb)
	pc.custom_minimum_size = Vector2(w, 0)
	pc.position = Vector2((1600 - w) / 2.0, 150)
	overlay.add_child(pc)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 14)
	pc.add_child(v)
	v.add_child(_lbl(title, 26, TEXT))
	if sub != "":
		var s := _lbl(sub, 14, DIM)
		s.autowrap_mode = TextServer.AUTOWRAP_WORD
		v.add_child(s)
	return v

func _overlay_map() -> void:
	var v := _dim_box("HALCYON NETWORK", "Choose your next Node. Icons show what probably lies ahead. Row %d of %d." % [g.row + 2, IceDB.MAP.size()], 1200)
	var cols := HBoxContainer.new()
	cols.add_theme_constant_override("separation", 24)
	v.add_child(cols)
	for r in IceDB.MAP.size():
		var col := VBoxContainer.new()
		col.add_theme_constant_override("separation", 10)
		col.add_child(_lbl("ROW %d" % (r + 1), 12, DIM))
		for idx in IceDB.MAP[r].size():
			var n: Dictionary = IceDB.MAP[r][idx]
			var b := Button.new()
			b.custom_minimum_size = Vector2(250, 64)
			var layers := ""
			if n.kind == "ICE":
				layers = "  ·  %d layer%s" % [n.layers.size(), "" if n.layers.size() == 1 else "s"]
			b.text = "%s%s" % [n.name, layers]
			b.icon = null
			b.alignment = HORIZONTAL_ALIGNMENT_LEFT
			for st in ["normal", "hover", "pressed", "disabled", "focus"]:
				var sb0: StyleBox = b.get_theme_stylebox(st).duplicate()
				sb0.content_margin_left = 40
				b.add_theme_stylebox_override(st, sb0)
			var ic := RIcon.make("SAFEHOUSE" if n.kind == "SAFEHOUSE" else "ICE", 22, RIcon.COL.SHIELD if n.kind == "SAFEHOUSE" else RIcon.COL.HALCYON)
			ic.position = Vector2(8, 21)
			b.add_child(ic)
			var visited: bool = g.path.has(n.id)
			b.disabled = not (r == g.row + 1 and g.available.has(idx))
			if visited:
				b.text += "  ✓"
			if n.kind == "ICE":
				var names := []
				for L in n.layers:
					names.append(" + ".join(L.ice.map(func(x): return IceDB.def(x).name)))
				b.tooltip_text = "\n".join(names)
			b.pressed.connect(func(): g.enter_node(idx); refresh())
			col.add_child(b)
		cols.add_child(col)

func _overlay_options(title: String, sub: String, uids: Array, source: Array, on_pick: Callable, alt_text: String = "", on_alt: Callable = Callable()) -> void:
	var v := _dim_box(title, sub, 1200)
	var row := HFlowContainer.new()
	row.add_theme_constant_override("h_separation", 10)
	row.add_theme_constant_override("v_separation", 10)
	v.add_child(row)
	for u in uids:
		var c := {}
		for x in source:
			if x.uid == u:
				c = x
		if c.is_empty():
			continue
		var cv := _card_view(c.id, u)
		cv.gui_input.connect(func(ev):
			if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT:
				on_pick.call(u))
		row.add_child(cv)
	if alt_text != "":
		var b := Button.new()
		b.text = alt_text
		b.pressed.connect(on_alt)
		v.add_child(b)

func _overlay_deeper() -> void:
	var nxt: Dictionary = g.node.layers[g.layer + 1]
	var names: Array = nxt.ice.map(func(x): return IceDB.def(x).name)
	var v := _dim_box("BREACHED · LAYER %d of %d" % [g.layer + 1, g.node.layers.size()],
		"Go deeper for a bigger CRED reserve and better card odds, or leave now and keep what you've earned (this Node's card reward at the odds you've reached). Next layer: %s · reserve %d." % [" + ".join(names), nxt.reserve], 900)
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 16)
	var a := Button.new()
	a.text = "GO DEEPER"
	a.custom_minimum_size = Vector2(240, 56)
	a.pressed.connect(func(): g.go_deeper(); refresh())
	var b := Button.new()
	b.text = "LEAVE THE NODE"
	b.custom_minimum_size = Vector2(240, 56)
	b.pressed.connect(func(): g.leave_node(); refresh())
	h.add_child(a)
	h.add_child(b)
	v.add_child(h)
	v.add_child(_lbl("VITAE %d · TRACE %d / 40 · CRED %d" % [g.vitae, g.trace, g.cred], 14, DIM))

func _overlay_reward() -> void:
	var odds := {1: "60 / 30 / 10", 2: "45 / 40 / 15", 3: "30 / 45 / 25"}
	var sub := "Choose 1 card to add to your deck, or skip. Odds after %d layer%s (common / uncommon / rare): %s." % [g.layers_cleared, "" if g.layers_cleared == 1 else "s", odds.get(clamp(g.layers_cleared, 1, 3))]
	if g.reward_note != "":
		sub += "\n" + g.reward_note
	var v := _dim_box("CARD REWARD", sub, 900)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	v.add_child(row)
	for id in g.reward_options:
		var cv := _card_view(id, -1)
		var cid: String = id
		cv.gui_input.connect(func(ev):
			if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT:
				g.choose_reward(cid)
				refresh())
		row.add_child(cv)
	var b := Button.new()
	b.text = "Skip (a thin deck is a happy deck)"
	b.pressed.connect(func(): g.choose_reward(""); refresh())
	v.add_child(b)

func _overlay_safehouse() -> void:
	var v := _dim_box("SAFEHOUSE", "Choose one. VITAE %d / %d." % [g.vitae, g.max_vitae], 700)
	var a := Button.new()
	a.text = "Heal %d VITAE" % Game.SAFEHOUSE_HEAL
	a.custom_minimum_size = Vector2(0, 52)
	a.pressed.connect(func(): g.safehouse_heal(); refresh())
	v.add_child(a)
	var b := Button.new()
	b.text = "Apply 1 PATCHWORK upgrade (not in this slice)"
	b.disabled = true
	v.add_child(b)

func _overlay_select() -> void:
	var v := _dim_box("CHOOSE YOUR RUSTLER", "Same stats for all: 30 VITAE, 4 BW, DRAW 6, 4 RAM. They differ by deck and ORIGIN Ghostware.", 1360)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	v.add_child(row)
	for who in ["GENERALIST", "ECHO", "RIOT", "VECTOR"]:
		var r: Dictionary = CardDB.RUSTLERS[who]
		var b := Button.new()
		b.custom_minimum_size = Vector2(320, 300)
		b.clip_text = false
		var col := VBoxContainer.new()
		col.set_anchors_preset(Control.PRESET_FULL_RECT)
		col.offset_left = 16
		col.offset_right = -16
		col.offset_top = 14
		col.mouse_filter = Control.MOUSE_FILTER_IGNORE
		col.add_theme_constant_override("separation", 8)
		col.add_child(_lbl(r.name, 22, RUSTLER_COL[who]))
		col.add_child(_lbl("★".repeat(r.difficulty) + "☆".repeat(3 - r.difficulty), 14, DIM))
		for txt in ["\"%s\"" % r.quote, r.style]:
			var l := _lbl(txt, 13, TEXT if txt == r.style else DIM)
			l.autowrap_mode = TextServer.AUTOWRAP_WORD
			l.custom_minimum_size = Vector2(286, 0)
			col.add_child(l)
		col.add_child(_lbl("ORIGIN · " + r.origin, 13, RIcon.COL.NULREM))
		var ot := _lbl(r.origin_text, 12, Color("#a8d8b9"))
		ot.autowrap_mode = TextServer.AUTOWRAP_WORD
		ot.custom_minimum_size = Vector2(286, 0)
		col.add_child(ot)
		for c in col.get_children():
			c.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(col)
		var w: String = who
		b.pressed.connect(func(): _start_as(w))
		row.add_child(b)

func _overlay_end(title: String, sub: String) -> void:
	var v := _dim_box(title, sub, 700)
	var b := Button.new()
	b.text = "New run"
	b.custom_minimum_size = Vector2(0, 52)
	b.pressed.connect(_new_run)
	v.add_child(b)

# =====================================================================
# small helpers
# =====================================================================

func _panel(pos: Vector2, sz: Vector2, col: Color, border: Color = Color("#232b38")) -> Panel:
	var p := Panel.new()
	p.position = pos
	p.size = sz
	var sb := StyleBoxFlat.new()
	sb.bg_color = col
	sb.border_color = border
	sb.set_border_width_all(1)
	sb.set_corner_radius_all(6)
	p.add_theme_stylebox_override("panel", sb)
	add_child(p)
	return p

func _lbl(text: String, size_px: int = 15, col: Color = TEXT, bg: Color = Color(0, 0, 0, 0)) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size_px)
	l.add_theme_color_override("font_color", col)
	if bg.a > 0:
		var sb := StyleBoxFlat.new()
		sb.bg_color = bg
		sb.set_corner_radius_all(3)
		l.add_theme_stylebox_override("normal", sb)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l

func _stat(icon: String, text: String) -> HBoxContainer:
	var h := HBoxContainer.new()
	h.add_child(RIcon.make(icon, 22))
	h.add_child(_lbl(" " + icon + " " + text, 15, RIcon.COL.get(icon, TEXT)))
	return h

func _clear(n: Node) -> void:
	for c in n.get_children():
		n.remove_child(c)
		c.queue_free()

class TraceBar extends Control:
	## TRACE meter with the 20 warning mark and the 40 strike mark (Core Rules §7).
	var value := 0
	func _draw() -> void:
		var w := size.x
		var h := size.y
		draw_rect(Rect2(0, 0, w, h), Color("#1d2430"))
		var col := Color("#ffb020") if value < 20 else Color("#ff7a20")
		draw_rect(Rect2(0, 0, w * clamp(value / 40.0, 0.0, 1.0), h), col)
		draw_line(Vector2(w / 2, -2), Vector2(w / 2, h + 2), Color("#e6ebf2"), 2)
		draw_rect(Rect2(0, 0, w, h), Color("#5b4a2a"), false, 1)
