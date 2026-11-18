"""Build original placeholder audio for ADP-001 with the Python standard library."""
import math
import random
import struct
import wave
from pathlib import Path

RATE = 22050
LOOP = 8.0
DEST = Path(__file__).resolve().parents[1] / "godot" / "audio"
TAU = math.tau
CHORDS = [(60, 64, 67, 71), (57, 60, 64, 67), (53, 57, 60, 64), (55, 59, 62, 65)]


def tone(midi, t):
    return math.sin(TAU * 440 * 2 ** ((midi - 69) / 12) * t)


def envelope(t, duration, attack=0.025, release=0.18):
    return max(0, min(1, t / attack, (duration - t) / release))


def corporate(t):
    note = t % 0.5
    chord = CHORDS[int(t / 2) % 4]
    melody = chord[int(t / 0.5) % 4] + 12
    swell = envelope(t % 2, 2, 0.25, 0.4)
    hall = sum(tone(n, t) + 0.15 * tone(n + 12, t) for n in chord) * 0.039 * swell
    bell = 0.18 * (tone(melody, t) + 0.3 * tone(melody + 12, t)) * envelope(note, 0.5) * math.exp(-5 * note)
    return hall + bell


def rustler(t):
    beat = t % 0.5
    n = CHORDS[int(t / 2) % 4][0] - 24
    bass = math.tanh(2.7 * (tone(n, t) + 0.23 * tone(n + 19, t))) * 0.27
    relay = math.sin(TAU * 73 * beat) * math.exp(-34 * beat) * 0.18
    return bass * envelope(beat, 0.5, 0.008, 0.22) + relay * envelope(beat, 0.5, 0.003)


def drone(t):
    return 0.23 * (math.sin(TAU * 41.25 * t) + 0.42 * math.sin(TAU * 55 * t)) * (0.8 + 0.2 * math.cos(TAU * t / LOOP))


def strike(t):
    return sum(
        0.21 * tone(note, t - onset) * envelope(t - onset, 0.59) * math.exp(-3.4 * (t - onset))
        for note, onset in [(72, 0), (76, 0.17), (79, 0.37)]
        if onset <= t
    )


def save(relative_path, duration, signal):
    path = DEST / relative_path
    path.parent.mkdir(parents=True, exist_ok=True)
    with wave.open(str(path), "wb") as output:
        output.setparams((1, 2, RATE, 0, "NONE", "not compressed"))
        output.writeframes(b"".join(
            struct.pack("<h", round(32767 * max(-1, min(1, signal(i / RATE)))))
            for i in range(round(RATE * duration))
        ))


def mechanical(name, duration, pulses, seed):
    rng = random.Random(seed)
    state = 0.0

    def signal(t):
        nonlocal state
        state = 0.62 * state + 0.38 * rng.uniform(-1, 1)
        out = 0.0
        for onset, frequency, decay, noise in pulses:
            elapsed = t - onset
            if elapsed >= 0:
                ring = math.sin(TAU * frequency * elapsed)
                out += (ring * (1 - noise) + 2 * state * noise) * math.exp(-decay * elapsed)
        return 0.63 * out * envelope(t, duration, 0.0015, 0.018)

    save(f"sfx/{name}.wav", duration, signal)


def main():
    for name, wave_fn in [("corporate", corporate), ("rustler", rustler), ("drone", drone)]:
        save(f"music/{name}.wav", LOOP, wave_fn)
    save("music/strike-chime.wav", 1.0, strike)
    mechanical("seat", 0.15, [(0, 148, 53, 0.55), (0.039, 96, 86, 0.25)], 110)
    mechanical("pick-drag", 0.25, [(0, 73, 16, 0.96), (0.11, 39, 19, 0.94)], 111)
    mechanical("break", 0.16, [(0, 113, 38, 0.42), (0.044, 169, 76, 0.58)], 112)
    mechanical("end-turn", 0.11, [(0, 198, 64, 0.48), (0.029, 98, 113, 0.36)], 113)
    mechanical("bloat", 0.20, [(0, 51, 20, 0.99), (0.057, 95, 27, 0.94)], 114)


if __name__ == "__main__":
    main()
