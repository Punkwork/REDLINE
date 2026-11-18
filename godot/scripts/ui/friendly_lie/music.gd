class_name FriendlyMusic
extends Node

signal effect_played(id: String)

const CORPORATE := preload("res://audio/music/corporate.wav")
const RUSTLER := preload("res://audio/music/rustler.wav")
const DRONE := preload("res://audio/music/drone.wav")
const CHIME := preload("res://audio/music/strike-chime.wav")

const EFFECTS := {
 "seat": preload("res://audio/sfx/seat.wav"),
 "pick_drag": preload("res://audio/sfx/pick-drag.wav"),
 "break": preload("res://audio/sfx/break.wav"),
 "end_turn": preload("res://audio/sfx/end-turn.wav"),
 "bloat": preload("res://audio/sfx/bloat.wav"),
}

var effect_players := {}
var group := AudioStreamSynchronized.new()
var stems := AudioStreamPlayer.new()
var wet_corporate := AudioStreamPlayer.new()
var chime := AudioStreamPlayer.new()
var pitch_effect := AudioEffectPitchShift.new()
var volume: float = AtomicDecoPunk.settings.music.default_volume
var muted := false
var mix_time := 0.0
var current_cents := 0.0
var pitch_bus: StringName

func _ready() -> void:
 var dry := loop(CORPORATE)
 group.stream_count = 3
 group.set_sync_stream(0, dry)
 group.set_sync_stream(1, loop(RUSTLER))
 group.set_sync_stream(2, loop(DRONE))
 stems.stream = group
 add_child(stems)

 # Godot 4.3 exposes gain, but no per-track pitch, on the synchronized stream.
 # Start a parallel corporate feed in the same audio frame; DSP never changes its playback speed.
 pitch_bus = StringName("ADP Wow %s" % get_instance_id())
 AudioServer.add_bus()
 var bus_index := AudioServer.bus_count - 1
 AudioServer.set_bus_name(bus_index, pitch_bus)
 pitch_effect.fft_size = int(AtomicDecoPunk.settings.music.pitch_fft_size)
 AudioServer.add_bus_effect(bus_index, pitch_effect)
 wet_corporate.stream = dry
 wet_corporate.bus = pitch_bus
 add_child(wet_corporate)

 for id in EFFECTS:
  var player := AudioStreamPlayer.new()
  player.stream = EFFECTS[id]
  player.volume_db = linear_to_db(AtomicDecoPunk.settings.effects[id])
  add_child(player)
  effect_players[id] = player

 chime.stream = CHIME
 add_child(chime)
 set_level(volume, muted)
 update_mix(0.0, true, 0.0)

func _exit_tree() -> void:
 var bus_index := AudioServer.get_bus_index(pitch_bus)
 if bus_index >= 0: AudioServer.remove_bus(bus_index)

func loop(source: AudioStreamWAV) -> AudioStreamWAV:
 var result := source.duplicate() as AudioStreamWAV
 result.loop_mode = AudioStreamWAV.LOOP_FORWARD
 result.loop_end = result.data.size() / 2
 return result

func set_active(active: bool) -> void:
 if active == stems.playing: return
 if active:
  mix_time = 0.0
  stems.play()
  wet_corporate.play()
 else:
  stems.stop()
  wet_corporate.stop()
  chime.stop()

func set_level(level: float, is_muted: bool) -> void:
 volume = clampf(level, 0.0, 1.0)
 muted = is_muted
 stems.volume_db = linear_to_db(0.0 if muted else volume)
 chime.volume_db = linear_to_db((0.0 if muted else volume) * float(AtomicDecoPunk.settings.music.chime_gain))
 if muted: wet_corporate.volume_db = -INF

static func weights(bleed: float) -> Vector3:
 var points: Array = AtomicDecoPunk.settings.music.mix
 for i in range(1, points.size()):
  var right: Array = points[i]
  if bleed <= float(right[0]):
   var left: Array = points[i - 1]
   var a := Vector3(left[1], left[2], left[3])
   var b := Vector3(right[1], right[2], right[3])
   return a.lerp(b, clampf(inverse_lerp(left[0], right[0], bleed), 0.0, 1.0))
 var last: Array = points.back()
 return Vector3(last[1], last[2], last[3])

static func depth(bleed: float, reduced: bool) -> float:
 if reduced: return 0.0
 var cfg: Dictionary = AtomicDecoPunk.settings.music
 if bleed <= float(cfg.fade_in_end):
  return float(cfg.detune_cents) * clampf(bleed / float(cfg.fade_in_end), 0.0, 1.0)
 return float(cfg.detune_cents) * (1.0 - clampf(inverse_lerp(cfg.fade_in_end, cfg.mask_in_tune, bleed), 0.0, 1.0))

func update_mix(bleed: float, reduced: bool, delta: float) -> void:
 mix_time += delta
 var cfg: Dictionary = AtomicDecoPunk.settings.music
 var amount := depth(bleed, reduced)
 var flutter: float = cfg.flutter_share
 current_cents = amount * ((1.0 - flutter) * sin(TAU * float(cfg.wow_hz) * mix_time) + flutter * sin(TAU * float(cfg.flutter_hz) * mix_time))
 pitch_effect.pitch_scale = pow(2.0, current_cents / 1200.0)
 var gain := weights(bleed)
 var wet := clampf(amount / (float(cfg.detune_cents) * float(cfg.wet_crossfade_depth)), 0.0, 1.0)
 group.set_sync_stream_volume(0, linear_to_db(gain.x * (1.0 - wet)))
 group.set_sync_stream_volume(1, linear_to_db(gain.y))
 group.set_sync_stream_volume(2, linear_to_db(gain.z))
 wet_corporate.volume_db = linear_to_db(0.0 if muted else volume * gain.x * wet)

func play_strike() -> void:
 chime.play()


func play_effect(id: String) -> void:
 var player: AudioStreamPlayer = effect_players[id]
 player.play()
 effect_played.emit(id)
