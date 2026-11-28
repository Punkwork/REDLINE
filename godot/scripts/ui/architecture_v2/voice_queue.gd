class_name VoiceQueue
extends AudioStreamPlayer
## Playtest 13 note (designer 2026-11-28): voice clips must not play over each other; a new clip waits
## until the one playing has finished. One VoiceQueue is shared by the app shell (main.gd) and the
## encounter screen, so a line from one never talks over a line from the other. Sound effects and
## music are separate players and are not queued.
##
## It is an AudioStreamPlayer, so existing callers and fixtures that read `playing` or `stream`, or
## call stop(), keep working. stop() alone keeps any waiting clips; clear() drops them too (mute).

## At most this many clips wait behind the one playing; a newer line replaces the last waiting one,
## so the voice never falls far behind the game.
const MAX_WAITING := 1

var waiting: Array[AudioStream] = []

func _init() -> void:
	finished.connect(_next)

## Play now if the channel is free, otherwise wait. Returns the seconds until this clip starts.
func enqueue(clip: AudioStream) -> float:
	if clip == null: return 0.0
	if not playing and waiting.is_empty():
		_start(clip)
		return 0.0
	if waiting.size() >= MAX_WAITING: waiting.pop_back()
	waiting.append(clip)
	return remaining()

## Seconds left on the clip playing now (0 when silent).
func remaining() -> float:
	if not playing or stream == null: return 0.0
	return maxf(0.0, stream.get_length() - get_playback_position())

## Mute: stop the clip and drop anything waiting.
func clear() -> void:
	waiting.clear()
	stop()

func _start(clip: AudioStream) -> void:
	stream = clip
	if is_inside_tree(): play()

func _next() -> void:
	if not waiting.is_empty(): _start(waiting.pop_front())
