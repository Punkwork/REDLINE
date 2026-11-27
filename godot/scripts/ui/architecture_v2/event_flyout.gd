class_name EventFlyout
extends Control
## UI-TYPO-001 / M06 (ARCH-V2-003): the reusable event flyout: virtual-world typography announcing an
## event over the physical console. First specimens: RUSTLER TURN and CORP COUNTERMEASURE (approved
## wording, designer 2026-11-26). The treatment (shape, colour, type) is PROVISIONAL and lives in
## VasTokens.FLYOUT and this _draw, so it can change without touching callers.
##
## Constraints honoured (UI-TYPO-001a; designer 2026-11-26):
## * total time ≤ 1.5 s (enter, reveal, hold, exit from VasTokens.FLYOUT_TIMING);
## * never intercepts input (mouse_filter IGNORE all the way down);
## * hides nothing: the band is translucent and the type is outlined, so what is under it stays readable;
## * reduced motion: no travel, wipe or scale; a plain fade in place, same duration;
## * one at a time: a new announcement replaces a queued one; duplicates are dropped.
## Driven by phase changes the controller reports; it never reads or advances rules.

signal finished(kind: String)

var reduced_motion := false
## Vertical centre of the band as a fraction of this control's height (offset from key values).
var band_y := 0.36
var kind := ""
var t := 0.0
var playing := false
var _queued := ""
## R06: announcements that arrive while one plays wait their turn (at most QUEUE_MAX, oldest first).
var _queue: Array = []
const QUEUE_MAX := 3
var _spec: Dictionary = {}

const BAND_H := 118.0
const BAND_ALPHA := 0.55
const FONT_PX := 76

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process(false)
	hide()

func announce(k: String) -> void:
	if not VasTokens.FLYOUT.has(k): return
	if playing and k == kind: return
	if playing:
		if not _queue.has(k) and _queue.size() < QUEUE_MAX: _queue.append(k)
		_queued = String(_queue[0]) if not _queue.is_empty() else ""
		return
	_start(k)

func queued() -> Array:
	return _queue.duplicate()

func _start(k: String) -> void:
	kind = k
	_spec = VasTokens.FLYOUT[k]
	t = 0.0
	playing = true
	show()
	set_process(true)
	queue_redraw()

## Fixtures and design review: show an announcement frozen at time t (seconds into its 1.3 s run).
func hold_at(k: String, at: float) -> void:
	_queued = ""
	_queue.clear()
	_start(k)
	set_process(false)
	t = at
	queue_redraw()

## Deterministic stepping for tests and fixtures.
func advance(dt: float) -> void:
	if not playing: return
	t += dt
	if t >= VasTokens.flyout_total():
		playing = false
		set_process(false)
		hide()
		var done := kind
		finished.emit(done)
		while not _queue.is_empty() and String(_queue[0]) == done: _queue.pop_front()
		if not _queue.is_empty():
			var next := String(_queue.pop_front())
			_queued = String(_queue[0]) if not _queue.is_empty() else ""
			_start(next)
		else:
			_queued = ""
	queue_redraw()

func _process(delta: float) -> void:
	advance(delta)

## 0..1 progress values of each phase at the current time.
func phases() -> Dictionary:
	var T := VasTokens.FLYOUT_TIMING
	var a := float(T.enter); var b := a + float(T.reveal); var c := b + float(T.hold); var d := c + float(T.exit)
	return {
		"enter": clampf(t / a, 0.0, 1.0),
		"reveal": clampf((t - a) / (b - a), 0.0, 1.0),
		"hold": clampf((t - b) / (c - b), 0.0, 1.0),
		"exit": clampf((t - c) / (d - c), 0.0, 1.0),
	}

## The band's current opacity factor (0..1); tests check it peaks ≤ BAND_ALPHA.
func band_opacity() -> float:
	var p := phases()
	if reduced_motion:
		return BAND_ALPHA * minf(p.enter + p.reveal, 1.0) * (1.0 - p.exit)
	return BAND_ALPHA * (1.0 - p.exit * 0.4)

func _draw() -> void:
	if not playing or _spec.is_empty(): return
	var p := phases()
	var w := size.x
	var cy := size.y * band_y
	var band := Rect2(Vector2(-40, cy - BAND_H / 2.0), Vector2(w + 80, BAND_H))
	var slant := 0.32   # skew of the band and type (virtual-world italics)
	var edge: Color = _spec.edge
	var ink: Color = _spec.ink
	var fill: Color = _spec.band
	var drift := 0.0
	var reveal := 1.0
	var clip_l := 0.0
	var clip_r := 1.0
	var text_alpha := 1.0
	if reduced_motion:
		text_alpha = minf(p.enter + p.reveal, 1.0) * (1.0 - p.exit)
	else:
		clip_r = p.enter                        # fast wipe in from the left
		clip_l = p.exit                         # wipe out to the right
		reveal = p.reveal
		drift = 10.0 * p.hold                   # subtle drift through the hold
		text_alpha = reveal * (1.0 - p.exit)
	var x0 := band.position.x + band.size.x * clip_l
	var x1 := band.position.x + band.size.x * clip_r
	if x1 <= x0: return
	var op := band_opacity()
	# Translucent skewed band with a bright edge rule top and bottom.
	var sk := BAND_H * slant
	var poly := PackedVector2Array([Vector2(x0 + sk, band.position.y), Vector2(x1 + sk, band.position.y),
		Vector2(x1, band.end.y), Vector2(x0, band.end.y)])
	draw_colored_polygon(poly, Color(fill, op))
	draw_line(poly[0], poly[1], Color(edge, op + 0.3), 4.0, true)
	draw_line(poly[3], poly[2], Color(edge, op + 0.3), 4.0, true)
	# Three speed slashes at each end of the visible band.
	for n in 3:
		var sx := x0 + 30.0 + n * 22.0
		draw_line(Vector2(sx + sk * 0.8, cy - BAND_H * 0.38), Vector2(sx, cy + BAND_H * 0.38), Color(edge, text_alpha * 0.9), 7.0, true)
		var ex := x1 - 90.0 + n * 22.0
		draw_line(Vector2(ex + sk * 0.8, cy - BAND_H * 0.38), Vector2(ex, cy + BAND_H * 0.38), Color(edge, text_alpha * 0.9), 7.0, true)
	if text_alpha <= 0.01: return
	# Title: skewed, outlined, readable over anything; scales from 1.12 to 1.0 as it snaps into focus.
	var text := String(_spec.text)
	var font := VasTokens.FONT_PLAQUE
	var px := FONT_PX
	var tw := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
	var k := 1.0 if reduced_motion else lerpf(1.12, 1.0, reveal)
	var origin := Vector2(w / 2.0 + drift, cy)
	draw_set_transform_matrix(Transform2D(0.0, Vector2(k, k), -slant * 0.6, origin))
	var pos := Vector2(-tw / 2.0, px * 0.36)
	draw_string_outline(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, 14, Color(edge, 0.45 * text_alpha))
	draw_string_outline(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, 6, Color(0.04, 0.03, 0.03, text_alpha))
	draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, Color(ink, text_alpha))
	var glyph := String(_spec.get("glyph", ""))
	if glyph != "":
		# A padlock beside the title (open shackle for BREACHED), in the edge colour.
		var g := Vector2(pos.x - px * 0.85, -px * 0.08)
		var bw := px * 0.5; var bh := px * 0.4
		draw_rect(Rect2(g + Vector2(-bw / 2.0, 0), Vector2(bw, bh)), Color(edge, text_alpha))
		var sh := g + Vector2(0, 0) + (Vector2(bw * 0.28, -bh * 0.18) if glyph == "open_lock" else Vector2.ZERO)
		draw_arc(sh, bw * 0.32, PI, TAU, 16, Color(edge, text_alpha), px * 0.08, true)
		draw_circle(g + Vector2(0, bh * 0.45), px * 0.05, Color(0.04, 0.03, 0.03, text_alpha))
	draw_set_transform_matrix(Transform2D.IDENTITY)
