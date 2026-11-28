class_name EventFlyout
extends Control
## UI-TYPO-001 / M06 (ARCH-V2-003, UI-TYPO-002): the reusable event flyout: virtual-world typography
## announcing an event over the physical console. Each event has its own designer-approved treatment
## (UI-TYPO-002, 2026-11-27; specification in the UI Design Bible §2b). Timing, typography, colours
## and easing live in VasTokens.FLYOUT, so a treatment can be tuned without touching callers.
##
## Constraints honoured (UI-TYPO-001a; designer 2026-11-26/27):
## * each run stays inside the 1–2 s flyout exception (VasTokens.FLYOUT_MAX_SECONDS);
## * never intercepts input (mouse_filter IGNORE all the way down, including MASK OFF's layers);
## * hides nothing: every filled area is translucent (≤ BAND_ALPHA) and type is outlined;
## * reduced motion: no travel, wipe, scale, flicker or orbit; a plain fade in place, same duration;
## * no hazardous flashing: CORP COUNTERMEASURE's acquisition flicker stays ≤ 3 flashes a second;
## * one at a time: arrivals queue (at most QUEUE_MAX, oldest first); duplicates are dropped.
## Driven by phase changes and events the screen reports; it never reads or advances rules.

signal finished(kind: String)
## A run begins (also for a queued one). RESERVE EXTRACTED uses it to keep the CRED readout in step.
signal started(kind: String)

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
var _timing: Dictionary = {}
## MASK OFF: the corporation's actual artwork (CorporationLook HOSTILE room), set by the screen.
var mask_art: Texture2D
var _mask_root: Control      # letterforms (clip_children): the art shows only through them
var _mask_letters: TextureRect
var _mask_ink: Control       # letter outlines, above the art
var _mask_full: TextureRect  # the complete image once the mask withdraws
var _warned_missing := false

const BAND_H := 118.0
const BAND_ALPHA := 0.55
const FONT_PX := 76
const DARK := Color(0.04, 0.03, 0.03)

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

func treatment() -> String:
	return String(_spec.get("treatment", ""))

## Assets a treatment needs but cannot find (flagged, never substituted): today only MASK OFF's art.
func missing_assets() -> Array:
	return ["mask_art"] if kind == "mask_off" and mask_art == null else []

func _start(k: String) -> void:
	kind = k
	_spec = VasTokens.FLYOUT[k]
	_timing = VasTokens.flyout_timing(k)
	t = 0.0
	playing = true
	show()
	_sync_mask_layers()
	set_process(true)
	queue_redraw()
	started.emit(k)

## Fixtures and design review: show an announcement frozen at time t (seconds into its run).
func hold_at(k: String, at: float) -> void:
	_queued = ""
	_queue.clear()
	_start(k)
	set_process(false)
	t = at
	_update_mask_layers()
	queue_redraw()

## Deterministic stepping for tests and fixtures.
func advance(dt: float) -> void:
	if not playing: return
	t += dt
	if t >= VasTokens.flyout_total(kind):
		playing = false
		set_process(false)
		hide()
		var done := kind
		_sync_mask_layers()
		finished.emit(done)
		while not _queue.is_empty() and String(_queue[0]) == done: _queue.pop_front()
		if not _queue.is_empty():
			var next := String(_queue.pop_front())
			_queued = String(_queue[0]) if not _queue.is_empty() else ""
			_start(next)
		else:
			_queued = ""
	_update_mask_layers()
	queue_redraw()

func _process(delta: float) -> void:
	advance(delta)

## 0..1 progress values of each phase at the current time.
func phases() -> Dictionary:
	var T := _timing if not _timing.is_empty() else VasTokens.FLYOUT_TIMING
	var a := float(T.enter); var b := a + float(T.reveal); var c := b + float(T.hold); var d := c + float(T.exit)
	return {
		"enter": clampf(t / a, 0.0, 1.0),
		"reveal": clampf((t - a) / (b - a), 0.0, 1.0),
		"hold": clampf((t - b) / (c - b), 0.0, 1.0),
		"exit": clampf((t - c) / (d - c), 0.0, 1.0),
	}

## True during the stable, readable hold (type at rest, full strength).
func in_hold() -> bool:
	var p := phases()
	return p.reveal >= 1.0 and p.exit <= 0.0

## Opacity of the largest filled area right now (0..1); tests check it never exceeds BAND_ALPHA.
func band_opacity() -> float:
	if not playing: return 0.0
	var p := phases()
	var fade := _fade(p)
	match treatment():
		"masked_revelation":
			return maxf(float(_spec.mask_alpha) * _mask_level(p), float(_spec.image_alpha) * _image_level(p))
		"institutional_transmission", "atomic_ascension", "kinetic_breakthrough":
			return BAND_ALPHA * fade
		"surveillance_convergence":
			return BAND_ALPHA * (fade if reduced_motion else _lockdown_panel_level(p))
		"corner_slingshot":
			return 0.0
	if reduced_motion:
		return BAND_ALPHA * fade
	return BAND_ALPHA * (1.0 - p.exit * 0.4)

## Overall type intensity (0..1): what a flash-safety check samples.
func signal_level() -> float:
	if not playing: return 0.0
	var p := phases()
	if reduced_motion: return _fade(p)
	if treatment() == "institutional_transmission":
		return _acquire_level() * (1.0 - _fizzle(p))
	return _fade(p)

# ----- helpers

func _fade(p: Dictionary) -> float:
	return minf(p.enter + p.reveal, 1.0) * (1.0 - p.exit)

func _e(x: float, curve: float) -> float:
	return ease(clampf(x, 0.0, 1.0), curve)

func _width(font: Font, text: String, px: int, tracking := 0.0) -> float:
	return font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x + tracking * maxf(0.0, text.length() - 1)

## Outlined title: edge glow, dark keyline, fill. Readable over anything under it.
func _title(font: Font, pos: Vector2, text: String, px: int, ink: Color, edge: Color, a: float, glow := 0.45) -> void:
	if a <= 0.01: return
	draw_string_outline(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, int(px * 0.18), Color(edge, glow * a))
	draw_string_outline(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, maxi(4, int(px * 0.08)), Color(DARK, a))
	draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, Color(ink, a))

## Letter-spaced line (widely spaced kickers), drawn glyph by glyph from a left baseline point.
func _tracked(font: Font, pos: Vector2, text: String, px: int, tracking: float, col: Color, outline := 0) -> void:
	var x := pos.x
	for ch in text:
		if outline > 0: draw_string_outline(font, Vector2(x, pos.y), ch, HORIZONTAL_ALIGNMENT_LEFT, -1, px, outline, Color(DARK, col.a))
		draw_string(font, Vector2(x, pos.y), ch, HORIZONTAL_ALIGNMENT_LEFT, -1, px, col)
		x += font.get_string_size(ch, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x + tracking

func _skewed(origin: Vector2, skew: float, k := 1.0) -> void:
	draw_set_transform_matrix(Transform2D(0.0, Vector2(k, k), -skew, origin))

func _reset() -> void:
	draw_set_transform_matrix(Transform2D.IDENTITY)

# ----- draw

func _draw() -> void:
	if not playing or _spec.is_empty(): return
	var p := phases()
	match treatment():
		"kinetic_sweep": _draw_kinetic_sweep(p)
		"institutional_transmission": _draw_institutional(p)
		"kinetic_breakthrough": _draw_breakthrough(p)
		"surveillance_convergence": _draw_convergence(p)
		"masked_revelation": _draw_mask_backdrop(p)
		"corner_slingshot": _draw_slingshot(p)
		"atomic_ascension": _draw_ascension(p)
	_reset()

## RUSTLER TURN · Kinetic Sweep: condensed, forward-leaning ivory over a cyan-edged band that sweeps
## left to right; the type arrives from the left, keeps a little forward momentum through the hold,
## then accelerates out to the right.
func _draw_kinetic_sweep(p: Dictionary) -> void:
	var S := _spec
	var w := size.x
	var cy := size.y * band_y
	var band := Rect2(Vector2(-40, cy - BAND_H / 2.0), Vector2(w + 80, BAND_H))
	var slant: float = S.skew
	var edge: Color = S.edge
	var dx := 0.0
	var clip_l := 0.0
	var clip_r := 1.0
	var a := _fade(p)
	if not reduced_motion:
		clip_r = _e(p.enter, S.ease_in)
		clip_l = _e(p.exit, S.ease_out)
		dx = -float(S.travel) * (1.0 - _e(p.enter, S.ease_in)) + float(S.momentum) * p.hold \
			+ float(S.travel) * 4.0 * _e(p.exit, S.ease_out)
		a = minf(1.0, p.enter * 1.5) * (1.0 - p.exit)
	var x0 := band.position.x + band.size.x * clip_l
	var x1 := band.position.x + band.size.x * clip_r
	if x1 <= x0: return
	var op := band_opacity()
	var sk := BAND_H * slant
	var poly := PackedVector2Array([Vector2(x0 + sk, band.position.y), Vector2(x1 + sk, band.position.y),
		Vector2(x1, band.end.y), Vector2(x0, band.end.y)])
	draw_colored_polygon(poly, Color(S.band, op))
	draw_line(poly[0], poly[1], Color(edge, op + 0.3), 4.0, true)
	draw_line(poly[3], poly[2], Color(edge, op + 0.3), 4.0, true)
	var font: Font = S.font
	var px: int = S.px
	var text := String(S.text)
	var tw := _width(font, text, px)
	var cx := w / 2.0 + dx
	if not reduced_motion and a > 0.01:
		# Directional momentum: tapered cyan streaks trailing the type on its left.
		for n in 4:
			var y := cy - BAND_H * 0.30 + n * BAND_H * 0.20
			var len: float = (150.0 - n * 26.0) * (0.6 + 0.4 * (1.0 - float(p.hold)))
			var tail := cx - tw / 2.0 - 34.0 - n * 10.0
			draw_colored_polygon(PackedVector2Array([Vector2(tail, y - 3), Vector2(tail - len, y), Vector2(tail, y + 3)]), Color(edge, 0.75 * a))
	_skewed(Vector2(cx, cy), slant * 0.6)
	_title(font, Vector2(-tw / 2.0, px * 0.36), text, px, S.ink, edge, a)

func _acquire_level() -> float:
	if t <= 0.0: return 0.0
	var keys: Array = _spec.acquire
	var level := 0.0
	for k in keys:
		if t >= float(k[0]): level = float(k[1])
	return level

func _fizzle(p: Dictionary) -> float:
	return _e(p.exit, _spec.ease_out)

## CORP COUNTERMEASURE · Institutional Transmission (B2): a small, widely spaced vermilion CORP over
## a dominant, heavy, upright ivory COUNTERMEASURE, between horizontal rules. Irregular signal
## acquisition, a stable hold, then an electronic fizzle.
func _draw_institutional(p: Dictionary) -> void:
	var S := _spec
	var w := size.x
	var cy := size.y * band_y
	var h := 150.0
	var edge: Color = S.edge
	var ink: Color = S.ink
	var band_a := band_opacity()
	var sig := signal_level()
	var fz := 0.0 if reduced_motion else _fizzle(p)
	var jitter := 0.0
	if not reduced_motion and p.enter < 1.0:
		var step := int(t / 0.035)
		jitter = [6.0, -9.0, 3.0, -4.0, 8.0, 0.0][step % 6] * (1.0 - p.enter)
	# Band and its two rules (an Art Deco pair: heavy outside, hairline inside). The rules close in
	# toward the centre as the transmission fizzles out.
	var half := w * 0.5 * (1.0 - fz * 0.85)
	draw_rect(Rect2(w / 2.0 - half, cy - h / 2.0, half * 2.0, h), Color(S.band, band_a))
	var rule_a := minf(1.0, band_a / BAND_ALPHA)
	for side in [-1.0, 1.0]:
		var y: float = cy + side * h / 2.0
		draw_line(Vector2(w / 2.0 - half, y), Vector2(w / 2.0 + half, y), Color(edge, rule_a), 4.0)
		draw_line(Vector2(w / 2.0 - half * 0.92, y - side * 8.0), Vector2(w / 2.0 + half * 0.92, y - side * 8.0), Color(edge, rule_a * 0.8), 1.5)
	if sig <= 0.01: return
	var kfont: Font = S.kicker_font
	var kpx: int = S.kicker_px
	var trk: float = S.kicker_tracking
	var lines: Array = S.lines
	var kick := String(lines[0])
	var kw := _width(kfont, kick, kpx, trk)
	var kc := Color(S.kicker_ink, sig)
	_tracked(kfont, Vector2(w / 2.0 - kw / 2.0 + jitter, cy - h * 0.14), kick, kpx, trk, kc, 6)
	var font: Font = S.font
	var px: int = S.px
	var main := String(lines[1])
	var mw := _width(font, main, px)
	var base := Vector2(w / 2.0 - mw / 2.0 + jitter, cy + h * 0.33)
	if fz > 0.0:
		# Fizzle: the signal tears into offset copies and scan-dashes, and fades.
		for n in 3:
			var off := (n - 1) * float(S.fizzle_shift) * fz * (0.6 + 0.2 * n)
			draw_string(font, base + Vector2(off, (n - 1) * 3.0), main, HORIZONTAL_ALIGNMENT_LEFT, -1, px, Color(edge, 0.35 * sig))
		var slices: int = S.slices
		for n in slices:
			var y := cy - h * 0.4 + n * h * 0.8 / float(slices)
			var sx := w / 2.0 + sin(n * 2.7) * mw * 0.45 * (0.3 + fz)
			draw_line(Vector2(sx - 40.0 * fz - 12.0, y), Vector2(sx + 40.0 * fz + 12.0, y), Color(ink, 0.5 * sig), 2.0)
	_title(font, base, main, px, ink, edge, sig, 0.3)

## DEADLOCK BREACHED · Kinetic Breakthrough: DEADLOCK enters from the right, BREACHED from the left;
## four principal cyan lines accelerate outward to the screen edges while amber and vermilion lines
## travel inward.
func _draw_breakthrough(p: Dictionary) -> void:
	var S := _spec
	var w := size.x
	var cy := size.y * band_y
	var font: Font = S.font
	var px: int = S.px
	var lines: Array = S.lines
	var edge: Color = S.edge
	var a := _fade(p)
	var arrive := 1.0 if reduced_motion else _e(p.enter, S.ease_in)
	var leave := 0.0 if reduced_motion else _e(p.exit, S.ease_out)
	var travel: float = S.travel
	var gap := px * 1.12          # baseline to baseline: the two words never touch
	var h := gap + px * 1.2
	draw_rect(Rect2(-20, cy - h / 2.0, w + 40, h), Color(S.band, band_opacity()))
	if not reduced_motion:
		# Burst: the principal cyan lines leave the centre at the lock-in and accelerate to the edges.
		var q := clampf((t - float(_timing.enter)) / (float(_timing.reveal) + float(_timing.hold) * 0.7), 0.0, 1.0)
		if q > 0.0 and p.exit < 1.0:
			var head := _e(q, 2.2)
			var tail := _e(maxf(0.0, q - 0.18), 2.2)
			for n in 4:
				var dir := -1.0 if n < 2 else 1.0
				var y := cy + (-1.0 if n % 2 == 0 else 1.0) * h * 0.58
				var x_start := w / 2.0 + dir * 140.0
				var reach := w / 2.0 - 140.0
				draw_line(Vector2(x_start + dir * reach * tail, y + (n % 2 * 2 - 1) * 26.0 * tail),
					Vector2(x_start + dir * reach * head, y + (n % 2 * 2 - 1) * 26.0 * head), Color(edge, 0.95 * (1.0 - p.exit)), 5.0, true)
			# Contrasting lines travel inward from the edges.
			var inward: Array = S.inward
			for n in 4:
				var dir := -1.0 if n % 2 == 0 else 1.0
				var y := cy + (n - 1.5) * h * 0.30
				var pos := 1.0 - _e(q, 0.5)
				var xa := w / 2.0 + dir * (180.0 + (w / 2.0 - 180.0) * pos)
				draw_line(Vector2(xa, y), Vector2(xa + dir * 120.0, y), Color(inward[n % 2], 0.85 * (1.0 - q) * (1.0 - p.exit)), 3.0, true)
	draw_line(Vector2(-20, cy - h / 2.0), Vector2(w + 20, cy - h / 2.0), Color(edge, band_opacity() + 0.3), 3.0)
	draw_line(Vector2(-20, cy + h / 2.0), Vector2(w + 20, cy + h / 2.0), Color(edge, band_opacity() + 0.3), 3.0)
	var top := String(lines[0]); var bottom := String(lines[1])
	var tw := _width(font, top, px); var bw := _width(font, bottom, px)
	# DEADLOCK from the right (and out to the left); BREACHED from the left (and out to the right):
	# they cross through each other, breaking through.
	var top_x := w / 2.0 - tw / 2.0 + travel * (1.0 - arrive) - travel * 2.0 * leave
	var bot_x := w / 2.0 - bw / 2.0 - travel * (1.0 - arrive) + travel * 2.0 * leave
	var ta: float = a if reduced_motion else minf(1.0, float(p.enter) * 2.0) * (1.0 - float(p.exit))
	_skewed(Vector2(top_x + tw / 2.0, cy - gap * 0.5), float(S.skew))
	_title(font, Vector2(-tw / 2.0, px * 0.36), top, px, S.ink, edge, ta)
	_skewed(Vector2(bot_x + bw / 2.0, cy + gap * 0.5), float(S.skew))
	_title(font, Vector2(-bw / 2.0, px * 0.36), bottom, px, S.ink, edge, ta)

func _lockdown_panel_level(p: Dictionary) -> float:
	# The panel fades up as the frames close in and is fully asserted by the end of the reveal; its
	# exit is the geometric collapse in _draw_convergence (CRT off), so the level holds until the end.
	if p.exit >= 1.0: return 0.0
	var e := float(_timing.enter)
	return clampf((t - e * 0.6) / (e * 0.4 + float(_timing.reveal)), 0.0, 1.0)

## LOCKDOWN · Surveillance Convergence (L3): concentric red frames contract inward around a deep
## crimson panel holding heavy, upright ivory type; a stable assertion, then electronic
## extinguishment (the panel collapses to a line, the line to a point).
func _draw_convergence(p: Dictionary) -> void:
	var S := _spec
	var w := size.x
	var cy := size.y * band_y
	var edge: Color = S.edge
	var panel_sz: Vector2 = S.panel
	var panel := Rect2(Vector2(w / 2.0, cy) - panel_sz / 2.0, panel_sz)
	var n_frames: int = S.frames
	var gap: float = S.frame_gap
	var screen := Rect2(Vector2(-6, -6), size + Vector2(12, 12))
	var fa := _fade(p) if reduced_motion else (1.0 - _e(p.exit * 2.0, 1.0))
	for i in n_frames:
		var final := panel.grow(gap * (i + 1))
		var r := final
		if not reduced_motion:
			# Inner frames arrive first; each contracts from the screen edge with a decelerating ease.
			var delay := 0.12 * float(i) / float(n_frames)
			var q := _e((t - delay) / maxf(0.01, float(_timing.enter) - delay), S.ease_in)
			r = Rect2(screen.position.lerp(final.position, q), screen.size.lerp(final.size, q))
		var alpha := fa * (0.95 - 0.13 * i)
		if alpha > 0.01: draw_rect(r, Color(edge, alpha), false, 3.0 if i == 0 else 2.0)
	var level := band_opacity() / BAND_ALPHA
	if level <= 0.01: return
	var cx := 1.0
	var cyk := 1.0
	if not reduced_motion and p.exit > 0.0:
		cyk = maxf(0.02, 1.0 - _e(p.exit / 0.6, 2.0))           # vertical collapse to a line
		cx = 1.0 - _e((p.exit - 0.55) / 0.45, 2.0) if p.exit > 0.55 else 1.0   # the line shrinks to a point
	var pr := Rect2(Vector2(w / 2.0 - panel_sz.x * cx / 2.0, cy - panel_sz.y * cyk / 2.0), Vector2(panel_sz.x * cx, panel_sz.y * cyk))
	if pr.size.x < 1.0: return
	draw_rect(pr, Color(S.band, BAND_ALPHA * level))
	draw_rect(pr, Color(edge, level), false, 3.0)
	if cyk < 0.2:
		draw_line(Vector2(pr.position.x, cy), Vector2(pr.end.x, cy), Color(S.ink, level * 0.9), 3.0)
		return
	var font: Font = S.font
	var px: int = S.px
	var text := String(S.text)
	var tw := _width(font, text, px)
	draw_set_transform_matrix(Transform2D(0.0, Vector2(cx, cyk), 0.0, Vector2(w / 2.0, cy)))
	_title(font, Vector2(-tw / 2.0, px * 0.36), text, px, S.ink, edge, level, 0.3)

# ----- MASK OFF · Masked Revelation

func _mask_level(p: Dictionary) -> float:
	var withdraw := clampf(p.exit * 2.0, 0.0, 1.0)
	if reduced_motion: return minf(p.enter + p.reveal, 1.0) * (1.0 - withdraw)
	return _e(p.enter, _spec.ease_in) * (1.0 - _e(withdraw, _spec.ease_out))

func _image_level(p: Dictionary) -> float:
	var withdraw := clampf(p.exit * 2.0, 0.0, 1.0)
	var back := clampf(p.exit * 2.0 - 1.0, 0.0, 1.0)
	return withdraw * (1.0 - back)

func _letter_scale(p: Dictionary) -> float:
	if reduced_motion: return 1.0
	var settle := lerpf(1.12, 1.0, _e(p.enter, _spec.ease_in))
	var grow: float = 1.0 + float(_spec.grow) * float(p.hold)
	var lift := 1.0 + 3.0 * _e(clampf(p.exit * 2.0, 0.0, 1.0), _spec.ease_out)
	return settle * grow * lift

func _sync_mask_layers() -> void:
	var on := playing and treatment() == "masked_revelation"
	if on and _mask_root == null:
		_mask_root = Control.new(); _mask_root.name = "MaskLetters"
		_mask_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_mask_root.clip_children = CanvasItem.CLIP_CHILDREN_ONLY
		_mask_root.draw.connect(func(): _draw_mask_letters(_mask_root, false))
		add_child(_mask_root)
		_mask_letters = _art_rect("Art"); _mask_root.add_child(_mask_letters)
		_mask_ink = Control.new(); _mask_ink.name = "MaskInk"; _mask_ink.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_mask_ink.draw.connect(func(): _draw_mask_letters(_mask_ink, true))
		add_child(_mask_ink)
		_mask_full = _art_rect("FullImage"); add_child(_mask_full)
	if _mask_root == null: return
	for n in [_mask_root, _mask_ink, _mask_full]:
		n.visible = on
		n.position = Vector2.ZERO
		n.size = size
	_mask_letters.size = size
	_mask_letters.texture = mask_art
	_mask_full.texture = mask_art
	if on and mask_art == null and not _warned_missing:
		_warned_missing = true
		push_warning("M06 MASK OFF: the corporation's HOSTILE artwork is missing; letters show outlines only.")
	_update_mask_layers()

func _art_rect(n: String) -> TextureRect:
	var r := TextureRect.new(); r.name = n
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	return r

func _update_mask_layers() -> void:
	if _mask_root == null or not _mask_root.visible: return
	var p := phases()
	var ml := _mask_level(p)
	_mask_letters.modulate = Color(1, 1, 1, float(_spec.letter_alpha) * minf(1.0, ml * 1.4))
	_mask_full.modulate = Color(1, 1, 1, float(_spec.image_alpha) * _image_level(p))
	_mask_root.queue_redraw()
	_mask_ink.queue_redraw()

## The mask: a dark, translucent veil whose letterforms are windows onto the corporation's art.
func _draw_mask_backdrop(p: Dictionary) -> void:
	var ml := _mask_level(p)
	if ml <= 0.0: return
	# A veil with the letter shapes left to the art layers above it (they draw over the veil).
	draw_rect(Rect2(Vector2.ZERO, size), Color(_spec.band, float(_spec.mask_alpha) * ml))

func _draw_mask_letters(ci: CanvasItem, ink: bool) -> void:
	if not playing or treatment() != "masked_revelation": return
	var p := phases()
	var ml := _mask_level(p)
	if ml <= 0.01: return
	var font: Font = _spec.font
	var px: int = _spec.px
	var text := String(_spec.text)
	var k := _letter_scale(p)
	var tw := _width(font, text, px)
	var origin := Vector2(size.x / 2.0, size.y * band_y)
	ci.draw_set_transform_matrix(Transform2D(0.0, Vector2(k, k), 0.0, origin))
	var pos := Vector2(-tw / 2.0, px * 0.36)
	if ink:
		var edge: Color = _spec.edge
		ci.draw_string_outline(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, 12, Color(edge, 0.9 * ml))
		ci.draw_string_outline(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, 4, Color(_spec.ink, 0.9 * ml))
		if mask_art == null:
			ci.draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, Color(_spec.ink, 0.25 * ml))
	else:
		ci.draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, Color.WHITE)
	ci.draw_set_transform_matrix(Transform2D.IDENTITY)

# ----- PARTING SHOT · Corner Slingshot

func _bezier(a: Vector2, c: Vector2, b: Vector2, u: float) -> Vector2:
	return a.lerp(c, u).lerp(c.lerp(b, u), u)

## Position on the slingshot curve (0 = the corner, 1 = the apex).
func _sling(u: float) -> Vector2:
	var S := _spec
	var corner: Vector2 = Vector2(S.corner) * size
	var apex: Vector2 = Vector2(S.apex) * size
	var ctrl: Vector2 = (corner + apex) / 2.0 + Vector2(S.bulge) * size
	return _bezier(corner, ctrl, apex, u)

## Staggered, ascending diagonal type at 85% scale: a curved entry from the lower-left corner, a
## readable hold at the apex, then a rapid, accelerating retraction with a simultaneous fade.
func _draw_slingshot(p: Dictionary) -> void:
	var S := _spec
	var font: Font = S.font
	var px: int = S.px
	var lines: Array = S.lines
	var edge: Color = S.edge
	var angle := deg_to_rad(float(S.angle_deg))
	var stagger: Vector2 = S.stagger
	var lag := 0.22
	for n in lines.size():
		var u := 1.0
		var a := _fade(p)
		if not reduced_motion:
			var e_in := clampf(p.enter * (1.0 + lag) - lag * n, 0.0, 1.0)      # second line trails the first
			var e_out := clampf(p.exit * (1.0 + lag) - lag * (lines.size() - 1 - n), 0.0, 1.0)
			u = _e(e_in, S.ease_in) * (1.0 - _e(e_out, S.ease_out))
			a = minf(1.0, e_in * 2.5) * (1.0 - e_out)
		if a <= 0.01: continue
		var pos := _sling(u) + stagger.rotated(angle) * n
		var rot := angle if reduced_motion else lerpf(angle * 2.4, angle, u)
		var text := String(lines[n])
		var tw := _width(font, text, px)
		if not reduced_motion and u < 0.98:
			for g in 3:   # trail along the curve while it travels
				var gp := _sling(maxf(0.0, u - 0.07 * (g + 1))) + stagger.rotated(angle) * n
				draw_set_transform_matrix(Transform2D(rot, Vector2.ONE, -float(S.skew), gp))
				draw_string(font, Vector2(-tw / 2.0, px * 0.36), text, HORIZONTAL_ALIGNMENT_LEFT, -1, px, Color(edge, 0.22 * a / (g + 1)))
		draw_set_transform_matrix(Transform2D(rot, Vector2.ONE, -float(S.skew), pos))
		_title(font, Vector2(-tw / 2.0, px * 0.36), text, px, S.ink, edge, a)
	_reset()

# ----- RESERVE EXTRACTED · Atomic Ascension

## 0..1: how much of EXTRACTED is lit gold (in step with the CRED readout's count).
func illumination() -> float:
	if not playing or treatment() != "atomic_ascension": return 0.0
	var p := phases()
	return 1.0 if reduced_motion else _e(p.reveal, 1.2)

## Turquoise Atomic Age orbital trails swirl around the type while EXTRACTED lights progressively in
## luminous gold; the whole composition rises as it arrives and leaves.
func _draw_ascension(p: Dictionary) -> void:
	var S := _spec
	var w := size.x
	var lines: Array = S.lines
	var font: Font = S.font
	var px: int = S.px
	var kpx: int = S.kicker_px
	var edge: Color = S.edge
	var a := _fade(p)
	var rise := 0.0
	if not reduced_motion:
		rise = 34.0 * (1.0 - _e(p.enter, S.ease_in)) - 46.0 * _e(p.exit, S.ease_out)
		a = minf(1.0, p.enter * 1.6) * (1.0 - p.exit)
	var cy := size.y * band_y + rise
	var main := String(lines[1])
	var mw := _width(font, main, px)
	var h := 156.0
	draw_rect(Rect2(-20, cy - h / 2.0, w + 40, h), Color(S.band, band_opacity()))
	draw_line(Vector2(-20, cy - h / 2.0), Vector2(w + 20, cy - h / 2.0), Color(edge, 0.5 * a), 2.0)
	draw_line(Vector2(-20, cy + h / 2.0), Vector2(w + 20, cy + h / 2.0), Color(edge, 0.5 * a), 2.0)
	var centre := Vector2(w / 2.0, cy + 6)
	var rx := mw * 0.62
	var ry := h * 0.40
	var orbits: int = S.orbits
	var spin := float(S.orbit_turns) * TAU * clampf(t / VasTokens.flyout_total(kind), 0.0, 1.0)
	for o in orbits:
		var tilt := deg_to_rad(-28.0 + 28.0 * o)
		# Faint path, then a comet with a fading trail (Atomic Age orbit).
		var path := PackedVector2Array()
		for s in 49:
			var th := TAU * s / 48.0
			path.append(centre + Vector2(cos(th) * rx, sin(th) * ry).rotated(tilt))
		draw_polyline(path, Color(edge, 0.18 * a), 1.5, true)
		if reduced_motion: continue
		var head := spin + TAU * o / float(orbits)
		var trail := PackedVector2Array()
		var segs := 16
		for s in segs + 1:
			var th := head - 1.7 * float(segs - s) / float(segs)
			trail.append(centre + Vector2(cos(th) * rx, sin(th) * ry).rotated(tilt))
		for s in segs:
			draw_line(trail[s], trail[s + 1], Color(edge, a * float(s + 1) / float(segs)), 1.0 + 3.0 * float(s + 1) / float(segs), true)
		draw_circle(trail[segs], 5.0, Color(edge.lightened(0.5), a))
	# RESERVE: ivory, tracked, above.
	var kick := String(lines[0])
	var kw := _width(S.font, kick, kpx, 10.0)
	_tracked(S.font, Vector2(w / 2.0 - kw / 2.0, cy - h * 0.20), kick, kpx, 10.0, Color(S.ink, a), 4)
	# EXTRACTED: dim until the light passes through it, glyph by glyph, left to right.
	var lit := illumination()
	var gold: Color = S.gold
	var dim: Color = S.dim
	var x := w / 2.0 - mw / 2.0
	var base_y := cy + h * 0.36
	if lit > 0.0:
		draw_string_outline(font, Vector2(x, base_y), main, HORIZONTAL_ALIGNMENT_LEFT, -1, px, int(px * 0.22), Color(gold, 0.35 * lit * a))
	draw_string_outline(font, Vector2(x, base_y), main, HORIZONTAL_ALIGNMENT_LEFT, -1, px, int(px * 0.08), Color(DARK, a))
	var n_chars := main.length()
	var i := 0
	for ch in main:
		var local := clampf(lit * float(n_chars) - float(i), 0.0, 1.0)
		draw_string(font, Vector2(x, base_y), ch, HORIZONTAL_ALIGNMENT_LEFT, -1, px, Color(dim.lerp(gold, local), a))
		x += font.get_string_size(ch, HORIZONTAL_ALIGNMENT_LEFT, -1, px).x
		i += 1
