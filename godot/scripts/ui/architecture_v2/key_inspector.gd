class_name KeyInspector
extends PanelContainer
## UI-INSPECTOR-001 (designer-approved 2026-11-27; UI Bible "Final universal hover and rollover
## specification"): the one shared hover/rollover inspector for the Architecture V2 encounter (CAS-001
## C16). Every source (cards, subroutine keys, badges, HUD, Ghostware, CAPS, PROBE modes) opens it
## through the show_* calls below; there are no component-specific hover panels.
##
## * Composition: the object's enlarged artwork left / top-left; a right-aligned column with identity
##   (T1), classification (T2), costs (T3), mechanical effects (T4), restrictions (T5) and an optional
##   subordinate flavour line at the bottom (T5 italic). Irrelevant fields are omitted. Jost T1–T5
##   from VasTokens.TYPE (UI-TYPO-001).
## * Activation: 150 ms initial hover, 120 ms entrance; leaving the object starts a 150 ms grace, then a
##   100 ms exit. Once open, another object replaces the content at once. The pointer over the
##   inspector keeps it open. Escape dismisses at once. Keyboard focus opens at once with the same
##   content. Reduced motion: instant appearance and disappearance.
## * Motion: a restrained fade and a 7 px move from the source's direction; nothing else.
## * Position: beside the source, fully inside the viewport, never over the source; stationary.
## * Cleanup: removal of the source, a modal opening, an encounter change and card drags clear it now.
## Hover never changes rules state: the inspector only reads the models it is given.

const OPEN_DELAY := 0.150
const ENTER_S := 0.120
const GRACE_S := 0.150
const EXIT_S := 0.100
const TRAVEL := 7.0
const GAP := 10.0
const COLUMN_W := 340.0     # at 1080 p
const ART_W := 240.0        # at 1080 p
const INK := Color("#1E1810")
const INK_SOFT := Color("#5E4B35")
const INK_TITLE := VasTokens.SEAFOAM_INK
const INK_WARN := Color("#8E2A1E")
const INK_NOTE := Color("#1E6E6A")

var _image: VBoxContainer
var _list: VBoxContainer
var anchor := Rect2()
var subject: Variant = null   # what it currently explains (a source Control)
var reduced_motion := false
## "hidden" | "pending" (waiting the initial hover) | "open" | "grace" | "exiting"
var state := "hidden"
var _timer := 0.0
var _enter_t := 1.0
var _home := Vector2.ZERO
var _dir := Vector2.ZERO
var _pending: Callable
var _pointer_inside := false

func _init() -> void:
	name = "KeyInspector"
	mouse_filter = Control.MOUSE_FILTER_STOP   # the pointer over the inspector keeps it open
	z_index = 200
	top_level = true
	var st := StyleBoxFlat.new()
	st.bg_color = VasTokens.IVORY
	st.border_color = VasTokens.CHROME_LO
	st.set_border_width_all(3)
	st.set_corner_radius_all(14)
	st.set_content_margin_all(16)
	st.shadow_color = Color(0, 0, 0, 0.45); st.shadow_size = 12; st.shadow_offset = Vector2(0, 6)
	add_theme_stylebox_override("panel", st)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 18)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(row)
	_image = VBoxContainer.new(); _image.name = "Image"; _image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_image.alignment = BoxContainer.ALIGNMENT_BEGIN   # artwork anchored top-left
	row.add_child(_image)
	_list = VBoxContainer.new(); _list.name = "Words"; _list.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_list.add_theme_constant_override("separation", 6)
	_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(_list)
	mouse_entered.connect(_on_pointer_in)
	mouse_exited.connect(_on_pointer_out)
	set_process(false)
	hide()

# ----- Public API (every hover source)

func show_key(key: SubroutineKey, ice_name: String) -> void:
	## Subroutines: icon, full rule, timing, break requirements.
	var build := func() -> void:
		var m := key.model
		var big := LitKey.new()   # ARCH-V2-003r: the same lit button, enlarged
		big.configure(String(m.kind), String(m.value), String(m.state), String(m.cost_text), false, 2.0)
		big.badge = String(m.get("badge", "")); big.extra = int(m.get("extra", 0)); big.locked = bool(m.get("locked", false))
		_art(big)
		_text("T1", String(m.title))
		_text("T2", "%s  ·  %s" % [String(m.get("place", "")), ice_name])
		for r in m.rules: _rule(String(r.kind), String(r.text))
		if not m.get("mini", false) and m.state != "broken" and m.kind != "HIDDEN":
			if m.get("breakable", false):
				_text("T3", "Break: %s" % m.cost_text)
			else:
				var why := String(m.get("reason", ""))
				if why.ends_with(" BW"): why = "needs " + why
				_text("T5", "Can't break now" + (": " + why if why != "" else "."), INK_WARN)
	_request(key, build)

func show_card(card: CardView) -> void:
	## Cards: artwork, name, classification, cost, effect, restrictions, flavour.
	var build := func() -> void:
		var m := card.model
		var costs := "%d BW" % int(m.get("bw", 0))
		if int(m.get("cred", 0)) > 0: costs += "  ·  %d CRED" % int(m.cred)
		if int(m.get("trace", 0)) > 0: costs += "  ·  +%d TRACE" % int(m.trace)
		var notes := []
		if bool(m.get("cached", false)):
			var turns := int(m.get("cache_turns", 0))
			notes.append(["CACHED: stays in your hand " + ("for the rest of the encounter." if turns <= 0 else "for %d more turn%s." % [turns, "" if turns == 1 else "s"]), INK_NOTE])
		if not bool(m.get("playable", true)) and String(m.get("reason", "")) != "":
			notes.append(["Can't play now: " + String(m.reason), INK_WARN])
		_object(card_art(m), String(m.get("name", "")), card.type_line(), costs, [String(m.get("text", ""))], notes, String(m.get("flavor", "")))
	_request(card, build)

## Any object by the content contract: artwork (Texture2D or Control), name, classification, cost,
## effects (T4 lines), restrictions ([text, colour] or text, T5) and flavour. Empty fields are omitted.
func show_object(who: Control, art: Variant, title: String, classification: String, cost: String, effects: Array, restrictions: Array = [], flavour := "") -> void:
	_request(who, func() -> void: _object(art, title, classification, cost, effects, restrictions, flavour))

func show_info(heading: String, title: String, lines: Array, at: Rect2, who: Variant = null) -> void:
	var build := func() -> void:
		_text("T1", title)
		if heading != "": _text("T2", heading)
		for l in lines: _text("T4", String(l))
	_request(who, build, at)

## ARCH-V2-006: an optional picture (Ghostware art at full size) and icon rows (the KEY LEGEND:
## [icon kind, words]); icon kinds are IceKey ICON_ names without the prefix.
func show_rich(heading: String, title: String, lines: Array, rows: Array, at: Rect2, who: Variant = null, picture: Control = null) -> void:
	var build := func() -> void:
		if picture: _art(picture)
		_text("T1", title)
		if heading != "": _text("T2", heading)
		for l in lines: _text("T4", String(l))
		for r in rows: _rule(String(r[0]), String(r[1]))
	_request(who, build, at)

## The source stops being hovered or focused: the grace period starts (or a pending open is dropped).
func close(who: Variant = null) -> void:
	if who != null and not is_same(who, subject): return
	match state:
		"pending": _hide_now()
		"open":
			if not _pointer_inside: _begin_grace()

## Immediate dismissal: Escape, a modal opening, the source removed, a new encounter, a card drag.
func clear() -> void:
	_hide_now()

## Deterministic stepping for tests and fixtures (the same clock _process uses).
func advance(dt: float) -> void:
	_tick(dt)

# ----- Activation and dismissal

func _request(who: Variant, build: Callable, at := Rect2()) -> void:
	var src := at
	var live: bool = who != null and is_instance_valid(who) and who is Control
	if src.size == Vector2.ZERO and live: src = (who as Control).get_global_rect()
	var focused: bool = live and (who as Control).has_focus()
	subject = who
	anchor = src
	if state in ["open", "grace", "exiting"] or focused:
		# Already open (rapid scanning) or keyboard focus: replace or open at once.
		var was_open := state in ["open", "grace", "exiting"]
		_build(build)
		_open(not was_open and not focused)
		return
	_pending = build
	state = "pending"
	_timer = OPEN_DELAY
	set_process(true)

func _build(build: Callable) -> void:
	_clear_content()
	build.call()

func _open(animate: bool) -> void:
	state = "open"
	_place(anchor)
	show()
	if reduced_motion or not animate:
		_enter_t = 1.0
	else:
		_enter_t = 0.0
	_apply_motion()
	set_process(true)

func _reopen() -> void:
	state = "open"
	_enter_t = 1.0
	_apply_motion()

func _on_pointer_in() -> void:
	_pointer_inside = true
	if state == "grace" or state == "exiting": _reopen()

func _on_pointer_out() -> void:
	_pointer_inside = false
	if state == "open": _begin_grace()

func _begin_grace() -> void:
	state = "grace"
	_timer = GRACE_S
	set_process(true)

func _hide_now() -> void:
	state = "hidden"
	subject = null
	_pending = Callable()
	_pointer_inside = false
	set_process(false)
	modulate.a = 1.0
	hide()

func _process(delta: float) -> void:
	_tick(delta)

func _tick(dt: float) -> void:
	if typeof(subject) == TYPE_OBJECT and not is_instance_valid(subject):   # a freed object == null
		_hide_now(); return   # the source was removed
	match state:
		"pending":
			_timer -= dt
			if _timer <= 0.0:
				var b := _pending; _pending = Callable()
				if b.is_valid(): _build(b)
				_open(true)
		"open":
			if _enter_t < 1.0:
				_enter_t = minf(1.0, _enter_t + dt / ENTER_S)
				_apply_motion()
			else:
				set_process(false)
		"grace":
			_timer -= dt
			if _timer <= 0.0:
				if reduced_motion: _hide_now(); return
				state = "exiting"; _timer += EXIT_S   # carry any overshoot into the exit
				_tick(0.0)
		"exiting":
			_timer -= dt
			modulate.a = clampf(_timer / EXIT_S, 0.0, 1.0)
			if _timer <= 0.0: _hide_now()

func _apply_motion() -> void:
	var k := ease(_enter_t, 0.5)
	modulate.a = k
	global_position = _home - _dir * TRAVEL * (1.0 - k)

func _input(e: InputEvent) -> void:
	if visible and e is InputEventKey and e.pressed and e.keycode == KEY_ESCAPE:
		_hide_now()
		get_viewport().set_input_as_handled()

# ----- Content

func _scale() -> float:
	var vp := get_viewport_rect().size if is_inside_tree() else Vector2(1920, 1080)
	return vp.y / VasTokens.TYPE_BASE_HEIGHT

func _clear_content() -> void:
	for c in _image.get_children(): c.queue_free(); _image.remove_child(c)
	for c in _list.get_children(): c.queue_free(); _list.remove_child(c)
	_image.hide()

func _object(art: Variant, title: String, classification: String, cost: String, effects: Array, restrictions: Array, flavour: String) -> void:
	if art is Texture2D:
		var tr := TextureRect.new(); tr.texture = art
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		var w := ART_W * _scale()
		tr.custom_minimum_size = Vector2(w, w * float((art as Texture2D).get_height()) / float(maxi(1, (art as Texture2D).get_width())))
		_art(tr)
	elif art is Control:
		_art(art)
	if title != "": _text("T1", title)
	if classification != "": _text("T2", classification)
	if cost != "": _text("T3", cost)
	for e in effects:
		if String(e) != "": _text("T4", String(e))
	for r in restrictions:
		if r is Array: _text("T5", String(r[0]), r[1])
		elif String(r) != "": _text("T5", String(r))
	if flavour != "": _text("T5", flavour, INK_SOFT, true)

## Card artwork: the card's illustration; without one, the card face itself stands in.
func card_art(m: Dictionary) -> Variant:
	var tex := CardView.art_for(String(m.get("art", "")))
	if tex: return tex
	var big := CardView.new()
	var face := m.duplicate()
	face.playable = true   # Playtest 13: the hand dims unplayable cards; the inspector never does
	face.selected = false
	big.set_model(face)
	big.focus_mode = Control.FOCUS_NONE
	big.custom_minimum_size = CardView.BASE * 1.6
	return big

func _art(c: Control) -> void:
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_image.add_child(c)
	_image.show()

func _text(level: String, text: String, col: Color = Color(0, 0, 0, 0), italic := false) -> Label:
	var l := Label.new()
	l.text = VasTokens.type_case(level, text)
	var px := VasTokens.type_px(level, get_viewport_rect().size.y if is_inside_tree() else VasTokens.TYPE_BASE_HEIGHT)
	l.add_theme_font_override("font", VasTokens.type_font(level, italic))
	l.add_theme_font_size_override("font_size", px)
	var ink := col if col.a > 0.0 else (INK_TITLE if level == "T1" else (INK_SOFT if level == "T2" else INK))
	l.add_theme_color_override("font_color", ink)
	l.add_theme_constant_override("line_spacing", int(px * (float(VasTokens.TYPE[level].line) - 1.0)))
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size.x = COLUMN_W * _scale()
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_list.add_child(l)
	return l

## A mechanical rule with its icon (subroutine effects, KEY LEGEND); right-aligned, icon leading.
func _rule(kind: String, text: String) -> void:
	var row := HBoxContainer.new(); row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.alignment = BoxContainer.ALIGNMENT_END
	row.add_theme_constant_override("separation", 8)
	var tex: Texture2D = IceKey.art("ICON_" + kind) if kind != "" else null
	var l := _text("T4", text)
	_list.remove_child(l)
	l.custom_minimum_size.x = (COLUMN_W - (30.0 if tex else 0.0)) * _scale()
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if tex:
		var icon := TextureRect.new(); icon.texture = tex; icon.custom_minimum_size = Vector2(22, 22) * maxf(1.0, _scale())
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE; icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(icon)
	row.add_child(l)
	_list.add_child(row)

# ----- Position

## Beside the source, fully inside the viewport, never over it: above, then below, right, left.
func _place(at: Rect2) -> void:
	reset_size()
	var vp := get_viewport_rect().size
	var s := get_combined_minimum_size()
	size = s
	var c := at.get_center()
	var tries := [
		[Vector2(c.x - s.x / 2.0, at.position.y - s.y - GAP), Vector2.UP],
		[Vector2(c.x - s.x / 2.0, at.end.y + GAP), Vector2.DOWN],
		[Vector2(at.end.x + GAP, c.y - s.y / 2.0), Vector2.RIGHT],
		[Vector2(at.position.x - s.x - GAP, c.y - s.y / 2.0), Vector2.LEFT],
	]
	var best: Array = []
	for tr in tries:
		var p: Vector2 = tr[0]
		p.x = clampf(p.x, 8.0, maxf(8.0, vp.x - s.x - 8.0))
		p.y = clampf(p.y, 8.0, maxf(8.0, vp.y - s.y - 8.0))
		if not Rect2(p, s).grow(-1.0).intersects(at):
			best = [p, tr[1]]; break
	if best.is_empty():
		# Nowhere fits without overlap (very small viewport): the corner farthest from the source.
		var p := Vector2(8.0 if c.x > vp.x / 2.0 else vp.x - s.x - 8.0, 8.0 if c.y > vp.y / 2.0 else vp.y - s.y - 8.0)
		best = [p, (p + s / 2.0 - c).normalized()]
	_home = best[0]
	_dir = best[1]
	global_position = _home

## Tests: true when the inspector covers no part of its source and sits inside the viewport.
func placement_ok() -> bool:
	var r := Rect2(global_position, size)
	return Rect2(Vector2.ZERO, get_viewport_rect().size).encloses(r.grow(-0.5)) and not r.grow(-1.0).intersects(anchor)
