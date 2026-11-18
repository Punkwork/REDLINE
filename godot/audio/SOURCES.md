# Audio provenance

## ADP-001 Phase 1 placeholder audio

Original synthesis using the Python standard library in `tools/synthesize_adp_audio.py`. No external audio, samples, or generated voice were used for these files.

| Source file | Synthesis |
|---|---|
| `music/corporate.wav` | Sustained sine organ harmony and exponentially decaying service-bell harmonics |
| `music/rustler.wav` | Saturated low oscillator plus relay-like pulses |
| `music/drone.wav` | Low sustained oscillator pair with slow amplitude movement |
| `music/strike-chime.wav` | Three staggered, fading oscillator notes derived from the corporate melody |

The three music files are 8.0-second, 22,050 Hz mono PCM loops with the same bar grid.

| Sound effect | Synthesis |
|---|---|
| `sfx/seat.wav` | Damped low ring and secondary contact click |
| `sfx/pick-drag.wav` | Two overlapping filtered noise scrapes |
| `sfx/break.wav` | Low relay clunk and bright contact rebound |
| `sfx/end-turn.wav` | Short two-stage toggle click |
| `sfx/bloat.wav` | Two filtered noise bursts resembling a tape tear |

Mechanical sound effects use seeded filtered noise and short damped resonances. The same generator produces every WAV.

The review MP3 in `docs/visual/fixtures/adp-001/` is an in-engine recording of these sources made by `godot/tests/shot_adp.gd` and encoded with FFmpeg/libmp3lame. The capture moves through Friendly, two Cracking levels, Strike 1, and Mask Off.
