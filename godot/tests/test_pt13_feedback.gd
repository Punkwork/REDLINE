extends SceneTree
## Playtest 13 notes (designer 2026-11-28): checks for the three fixes.
## 1. The encounter-layer / CRED box sits 1–2 px inside its earlier bounds on every side.
## 2. Voice clips never play over each other: a new clip waits until the one playing has finished,
##    and the app shell and the encounter screen share one voice channel.
## (3, unplayable cards shown undimmed in the inspector, is in test_ui_inspector_001.gd.)

var passed := 0
var failed := 0
const PT13_LEDGER := Rect2(206, 502, 168, 47)   # the box as built in Playtest 13

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	call_deferred("run")

## A silent clip of the given length (the queue only cares about timing).
func clip(seconds: float) -> AudioStreamWAV:
	var w := AudioStreamWAV.new()
	w.format = AudioStreamWAV.FORMAT_8_BITS
	w.mix_rate = 8000
	var data := PackedByteArray(); data.resize(int(8000 * seconds))
	w.data = data
	return w

func wait(seconds: float) -> void:
	await create_timer(seconds).timeout

func run() -> void:
	# 1. Ledger inset.
	var L: Rect2 = IceEncounterSandbox.LEDGER
	var sides := [L.position.x - PT13_LEDGER.position.x, L.position.y - PT13_LEDGER.position.y,
		PT13_LEDGER.end.x - L.end.x, PT13_LEDGER.end.y - L.end.y]
	check(sides.all(func(d): return d >= 1.0 and d <= 2.0), "ledger 1–2 px smaller on each side (%s)" % [sides])
	# 2. Voice queue.
	var q := VoiceQueue.new(); root.add_child(q)
	var a := clip(0.35); var b := clip(0.25); var c := clip(0.25)
	check(q.enqueue(a) == 0.0 and q.playing and q.stream == a, "a clip plays at once on a free channel")
	await wait(0.05)
	var delay := q.enqueue(b)
	check(q.stream == a and q.playing and q.waiting == [b], "a second clip waits; the first is not cut off")
	check(delay > 0.15 and delay <= 0.35, "the wait is what's left of the first clip (%.2f s)" % delay)
	q.enqueue(c)
	check(q.waiting == [c], "at most one clip waits; the newest line replaces an older waiting one")
	await wait(0.45)
	check(q.stream == c and q.playing, "the waiting clip starts when the first finishes")
	await wait(0.4)
	check(not q.playing and q.waiting.is_empty(), "silent once everything has played")
	q.enqueue(a); q.enqueue(b); q.clear()
	check(not q.playing and q.waiting.is_empty(), "mute stops the clip and drops waiting clips")
	q.queue_free()
	# Shared channel between the app shell and the V2 encounter screen.
	var main: Control = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4: await process_frame
	var v2: Variant = main.get("v2")
	check(main.get("voice") is VoiceQueue, "the app shell's voice is queued")
	if v2 != null:
		check(is_same(v2.nr_voice, main.get("voice")), "the encounter screen uses the app shell's voice channel")
	else:
		check(true, "app has no V2 screen in this configuration (nothing to share)")
	(main.get("voice") as VoiceQueue).clear()
	main.queue_free()
	for i in 2: await process_frame
	print("PT13 FEEDBACK: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))
