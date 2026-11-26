extends Control
## UI-TYPO-001 / UI-TYPO-001a. Scripted specimens for the two visual languages.
## Playback accepts presentation data only. SHOT_DIR enables deterministic capture.

const DISPLAY = preload("res://assets/fonts/BarlowCondensed-Bold.ttf")
const MONO = preload("res://assets/fonts/SpaceMono-Bold.ttf")
const RULE = preload("res://assets/fonts/DM-Sans.ttf")
const BACKPLATE = preload("res://assets/concept/ui/UI_BACKDROP_MACHINE.png")
const AUTO = preload("res://assets/concept/mascots/AUTO_RENEW_cheery.png")
const CAPTCHA = preload("res://assets/concept/mascots/CAPTCHA_cheery.png")
const IVORY := Color("#fff1d6")
const GLASS := Color("#191513")
const FLYOUT_FILL := Color("#1c1718")
const SPAN := Vector2(720, 90)
const CUES := {
	"entry": {"title": "ICE ENCOUNTER", "colour": Color("#ffc577"), "rank": 2, "direction": -1},
	"rustler": {"title": "RUSTLER TURN", "colour": Color("#6effee"), "rank": 2, "direction": -1},
	"response": {"title": "CORP COUNTERMEASURE", "colour": Color("#ff987d"), "rank": 2, "direction": 1},
	"break": {"title": "SUBROUTINE BROKEN", "colour": Color("#7df8e4"), "rank": 1, "direction": -1},
	"trace": {"title": "TRACE", "colour": Color("#ff987d"), "rank": 1, "direction": 1},
	"breach": {"title": "BREACH", "colour": Color("#ff91dc"), "rank": 3, "direction": 0}
}

var reduce_motion := false
var reduce_flash := false
var current: Dictionary = {}
var pending: Array[Dictionary] = []
var elapsed := 0.0
var rail: Control
var flyout: PanelContainer
var headline: Label
var note: Label
var burst: Label
var action: Button
var action_count := 0
var motion_toggle: CheckButton
var flash_toggle: CheckButton
var enamel: StyleBoxFlat


func _ready() -> void:
	if get_parent() is Window and not OS.get_environment("SHOT_DIR").is_empty():
		capture.call_deferred()
		return
	build()


func build() -> void:
	var backdrop := TextureRect.new()
	backdrop.texture = BACKPLATE
	backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var margin := MarginContainer.new()
	add_child(margin)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 32)
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation", 10)
	margin.add_child(stack)
	var instruments := HBoxContainer.new()
	instruments.add_theme_constant_override("separation", 12)
	stack.add_child(instruments)
	instruments.add_child(plaque("PANOPTICON   /   HALCYON", 32))
	instruments.add_child(plaque("TURN 02     BW 3/3     VITAE 26/30", 22, MONO))
	instruments.add_child(plaque("TRACE 12/40", 22, MONO))
	rail = Control.new()
	rail.custom_minimum_size.y = 144
	rail.clip_contents = true
	rail.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rail.draw.connect(draw_streaks)
	stack.add_child(rail)
	flyout = PanelContainer.new()
	flyout.mouse_filter = Control.MOUSE_FILTER_IGNORE
	flyout.hide()
	rail.add_child(flyout)
	enamel = style(FLYOUT_FILL, IVORY, 2)
	flyout.add_theme_stylebox_override("panel", enamel)
	var copy := HBoxContainer.new()
	copy.mouse_filter = Control.MOUSE_FILTER_IGNORE
	copy.add_theme_constant_override("separation", 17)
	flyout.add_child(copy)
	burst = type_label("///", 54, DISPLAY)
	copy.add_child(burst)
	var lines := VBoxContainer.new()
	lines.mouse_filter = Control.MOUSE_FILTER_IGNORE
	copy.add_child(lines)
	var display_italic := FontVariation.new()
	display_italic.base_font = DISPLAY
	display_italic.variation_transform = Transform2D(Vector2.RIGHT, Vector2(-0.14, 1), Vector2.ZERO)
	headline = type_label("", 49, display_italic)
	lines.add_child(headline)
	note = type_label("", 16, MONO)
	lines.add_child(note)
	var panels := HBoxContainer.new()
	panels.add_theme_constant_override("separation", 14)
	panels.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stack.add_child(panels)
	add_ice(panels, "AUTO-RENEW   /   FORTRESS   ·   STR 7", AUTO, "S1   PULP 2\nS2   HARDEN +1 STR\nS3   PULP 2 + BW DRAIN 1")
	add_ice(panels, "CAPTCHA   /   TUMBLER   ·   STR 6", CAPTCHA, "S1   DISCARD 1\nS2   DEADLOCK\nPOOL   ·   4 FACE DOWN")
	stack.add_child(plaque("NEXT RESPONSE    PULP 2  ›  HARDEN  ›  DISCARD 1", 24))
	var controls := HBoxContainer.new()
	stack.add_child(controls)
	for event: String in CUES:
		var button := Button.new()
		button.text = CUES[event].title
		button.custom_minimum_size.y = 44
		button.pressed.connect(play_specimen.bind(event))
		controls.add_child(button)
	motion_toggle = effect_toggle(controls, "Reduced motion")
	flash_toggle = effect_toggle(controls, "Reduced flash")
	action = Button.new()
	action.text = "END TURN"
	action.custom_minimum_size.y = 44
	action.pressed.connect(count_action)
	controls.add_child(action)


func effect_toggle(parent: Control, mode: String) -> CheckButton:
	var toggle := CheckButton.new()
	toggle.text = mode
	toggle.toggled.connect(set_effect_mode.bind(mode))
	parent.add_child(toggle)
	return toggle


func add_ice(parent: Control, title: String, art: Texture2D, terms: String) -> void:
	var frame := PanelContainer.new()
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	frame.add_theme_stylebox_override("panel", style(Color("#294640"), Color("#bda17d"), 4))
	parent.add_child(frame)
	var stack := VBoxContainer.new()
	frame.add_child(stack)
	stack.add_child(plaque(title, 26))
	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stack.add_child(body)
	var mascot := TextureRect.new()
	mascot.texture = art
	mascot.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	mascot.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	mascot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_child(mascot)
	var rules := plaque(terms, 21, RULE)
	rules.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	body.add_child(rules)


func type_label(value: String, points: int, font: Font) -> Label:
	var label := Label.new()
	label.text = value
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", points)
	label.add_theme_color_override("font_color", IVORY)
	return label


func plaque(value: String, points: int, font: Font = DISPLAY) -> Label:
	var label := type_label(value, points, font)
	label.add_theme_stylebox_override("normal", style(GLASS, Color("#a48258"), 2))
	return label


func style(fill: Color, edge: Color, width: int) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = edge
	box.set_border_width_all(width)
	box.set_corner_radius_all(8)
	box.content_margin_left = 18
	box.content_margin_right = 18
	box.content_margin_top = 6
	box.content_margin_bottom = 6
	return box


func set_effect_mode(enabled: bool, mode: String) -> void:
	if mode == "Reduced motion":
		reduce_motion = enabled
	else:
		reduce_flash = enabled
	paint()


func count_action() -> void:
	action_count += 1
	action.text = "END TURN  ·  %d" % action_count


func play_specimen(kind: String) -> void:
	match kind:
		"entry": enqueue(kind, "HALCYON  /  CAPTCHA")
		"rustler": enqueue(kind, "TURN 02")
		"response": enqueue(kind, "RESOLVING VISIBLE SUBROUTINES")
		"break": enqueue(kind, "AUTO-RENEW  /  SLOT 1")
		"trace": enqueue(kind, "", 2)
		"breach": enqueue(kind, "DEADLOCKS CLEARED")


func enqueue(kind: String, detail: String, delta := 0) -> void:
	# Coalesce queued TRACE changes without displacing an announcement in its readable hold.
	if kind == "trace":
		for item in pending:
			if item.kind == kind:
				item.delta += delta
				return
	pending.append({"kind": kind, "detail": detail, "delta": delta})
	if current.is_empty():
		show_next()


func show_next() -> void:
	if pending.is_empty():
		current = {}
		flyout.hide()
		rail.queue_redraw()
		return
	var chosen := 0
	for index in pending.size():
		if CUES[pending[index].kind].rank > CUES[pending[chosen].kind].rank:
			chosen = index
	current = pending.pop_at(chosen)
	elapsed = 0
	var cue: Dictionary = CUES[current.kind]
	headline.text = cue.title if current.delta == 0 else "%s %+d" % [cue.title, current.delta]
	headline.add_theme_font_size_override("font_size", 39 if cue.rank == 1 else 49)
	note.text = current.detail if current.delta == 0 else "CORP COUNTERMEASURE"
	burst.text = "✦" if cue.rank == 3 else ("///" if cue.direction < 0 else "\\\\\\")
	burst.add_theme_color_override("font_color", cue.colour)
	enamel.set_border_width_all(3 if cue.rank == 3 else 2)
	flyout.show()
	paint()


func _process(delta: float) -> void:
	if not current.is_empty():
		advance(delta)


func advance(delta: float) -> void:
	elapsed += delta
	if elapsed >= 1.30:
		show_next()
	else:
		paint()


func paint() -> void:
	if current.is_empty():
		return
	var cue: Dictionary = CUES[current.kind]
	var accent: Color = cue.colour
	var focal := 46.0 if cue.rank == 1 else 70.0
	var motion := 0.0
	var opacity := 1.0
	# Enter 0–.12, reveal .12–.25, hold .25–1.10, exit 1.10–1.30.
	if not reduce_motion:
		var enter := clampf(elapsed / 0.25, 0.0, 1.0)
		var leave := clampf((elapsed - 1.10) / 0.20, 0.0, 1.0)
		motion = (pow(1.0 - enter, 3) - leave) * focal * int(cue.direction)
		opacity = clampf(elapsed / 0.12, 0.0, 1.0) * (1.0 - leave)
	var rim := accent
	if not reduce_flash and not reduce_motion and elapsed < 0.25:
		rim = accent.lerp(IVORY, sin(elapsed / 0.25 * PI) * 0.26)
	enamel.border_color = rim
	flyout.modulate.a = opacity
	var width := minf(rail.size.x, 570.0 if cue.rank == 1 else SPAN.x)
	var floating := -0.028 if cue.direction < 0 else 0.028
	flyout.rotation = 0 if reduce_motion else floating
	flyout.size = Vector2(width, SPAN.y)
	var anchor := rail.size.x * (0.32 if cue.rank == 1 and current.kind == "break" else 0.5)
	var offset := clampf(anchor - width * 0.5, 0, rail.size.x - width)
	flyout.position = Vector2(offset + motion, 20)
	rail.queue_redraw()


func draw_streaks() -> void:
	if current.is_empty() or reduce_motion:
		return
	var cue: Dictionary = CUES[current.kind]
	var tint: Color = cue.colour
	var rect := flyout.get_rect()
	var height := rect.position.y + rect.size.y * 0.5
	var alpha := 0.20 if reduce_flash else 0.34
	for band in range(3):
		var width := 118.0 - band * 24.0
		var y := height + (band - 1) * 15.0
		tint.a = alpha * flyout.modulate.a
		if cue.direction <= 0:
			draw_streak(rect.position.x + 4, y, -width, tint)
		if cue.direction >= 0:
			draw_streak(rect.end.x - 4, y, width, tint)


func draw_streak(x: float, y: float, length: float, tint: Color) -> void:
	rail.draw_colored_polygon(PackedVector2Array([
		Vector2(x, y - 5), Vector2(x + length, y + 2), Vector2(x, y + 5)
	]), tint)


func contrast(ink: Color, paper: Color) -> float:
	return (ink.srgb_to_linear().get_luminance() + 0.05) / (paper.srgb_to_linear().get_luminance() + 0.05)


func capture() -> void:
	var viewport := SubViewport.new()
	viewport.size = Vector2i(1536, 864)
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(viewport)
	var fixture: Control = load(scene_file_path).instantiate()
	viewport.add_child(fixture)
	fixture.set_process(false)
	await get_tree().process_frame
	var passed := contrast(IVORY, GLASS) >= 4.5 and contrast(IVORY, FLYOUT_FILL) >= 4.5
	for cue: Dictionary in CUES.values():
		passed = passed and contrast(cue.colour, FLYOUT_FILL) >= 4.5
	for kind in ["entry", "rustler", "response", "break", "breach"]:
		fixture.play_specimen(kind)
		fixture.advance(0.50)
		passed = await shot(viewport, "Type-" + kind) and passed
		fixture.advance(0.81)
	fixture.play_specimen("response")
	fixture.play_specimen("trace")
	fixture.play_specimen("trace")
	fixture.play_specimen("breach")
	fixture.action.grab_focus()
	fixture.action.pressed.emit()
	passed = passed and fixture.action_count == 1 and fixture.action.has_focus()
	fixture.advance(1.31)
	passed = passed and fixture.current.kind == "breach"
	fixture.advance(1.31)
	passed = passed and fixture.current.kind == "trace" and fixture.current.delta == 4
	fixture.advance(0.50)
	passed = await shot(viewport, "Type-competing-trace") and passed
	fixture.advance(0.81)
	fixture.flash_toggle.button_pressed = true
	fixture.play_specimen("response")
	fixture.advance(0.19)
	passed = await shot(viewport, "Type-reduced-flash") and passed
	fixture.motion_toggle.button_pressed = true
	passed = passed and fixture.flyout.rotation == 0 and fixture.flyout.modulate.a == 1
	passed = await shot(viewport, "Type-reduced-motion") and passed
	fixture.advance(1.30)
	passed = passed and not fixture.flyout.visible
	print("UI-TYPO-001 event fixture: ", "PASS" if passed else "FAIL")
	get_tree().quit(0 if passed else 1)


func shot(viewport: SubViewport, name: String) -> bool:
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var path := OS.get_environment("SHOT_DIR").path_join(name + ".png")
	return viewport.get_texture().get_image().save_png(path) == OK
