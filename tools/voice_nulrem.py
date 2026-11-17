"""Render NUL/REM's spoken lines as pre-recorded voice audio (VOICE-001).

Run from the repository root after tools/export_nulrem.py:  python3 tools/voice_nulrem.py
Reads godot/data/nulrem_lines.json and writes one Ogg Vorbis file per line to
godot/audio/nulrem/<ID>.ogg ("NR-016 v2" -> NR-016_v2.ogg). Only lines whose spoken text
changed are re-rendered (godot/audio/nulrem/manifest.json).

Voice (approved: sample 3, "old speaker"): Kokoro-82M neural TTS (Apache-2.0) via kokoro-onnx, British
male voice bm_lewis at speed 0.85 for a slow, flat, dry delivery, then the FX chain below. Needs `pip install kokoro-onnx soundfile`
and sox; the model files (~350 MB) are downloaded once to $KOKORO_DIR (default ~/.cache/redline-tts).
"""
import hashlib
import json
import pathlib
import re
import subprocess
import sys
import tempfile

ROOT = pathlib.Path(__file__).resolve().parents[1]
LINES = ROOT / "godot" / "data" / "nulrem_lines.json"
OUT = ROOT / "godot" / "audio" / "nulrem"
VOICE = "bm_lewis"
SPEED = 0.85
WORKERS = 2
# "Old speaker": pitched down slightly, small-speaker band, light overdrive, a short cabinet echo.
FX = ["pitch", "-120", "highpass", "220", "lowpass", "4800", "overdrive", "3", "echo", "0.8", "0.6", "9", "0.2"]
RECIPE = f"kokoro-v1.0 {VOICE} speed {SPEED} | " + " ".join(FX) + " | 22050 ogg q1"

# Whole-token replacements, checked before the generic ALL-CAPS lowercasing.
SAY = {
    "NUL/REM": "null rem", "MER/LUN": "mer lun", "BW": "B W", "TV": "T V", "ATM": "A T M", "AA": "double A",
    "ATDT": "A T D T", "VU": "vee you", "DMG-01": "D M G zero one", "7-Zark-7": "seven zark seven",
    "T-1000": "T one thousand", "ED-209": "E D two oh nine", "SR-71": "S R seventy one", "R.U.D.I.": "Rudy",
    "R.O.B.": "rob", "B.O.B.": "bob", "E.T.": "E T", "MM7": "M M seven", "K44": "K forty four", "IV": "four",
    "III": "three", "II": "two", "WALL-E": "wall E", "808": "eight oh eight", "2600": "twenty six hundred",
    "1200": "twelve hundred", "9000": "nine thousand", "1982": "nineteen eighty two", "1987": "nineteen eighty seven",
    "VITAE": "vee tie", "IRONWATCH": "iron watch", "OVERWATCH": "over watch", "SAFEHOUSE": "safe house",
    "LOCKDOWN": "lock down", "KILLSWITCH": "kill switch", "DEADLOCK": "dead lock", "CAPS": "caps", "CAP": "cap",
    "SID": "sid", "ROM": "rom", "RAM": "ram", "HAL": "hal", "ICE": "ice", "CRED": "cred",
}
DIGIT = dict(zip("0123456789", "zero one two three four five six seven eight nine".split()))
TOKEN = re.compile(r"[A-Za-z0-9][A-Za-z0-9/.\-]*[A-Za-z0-9]|[A-Za-z0-9]")


def speakable(text: str) -> str:
    t = text.replace("DÉJÀ VU", "day zha voo").replace(" + ", " and ").replace("&", " and ").replace("+", " plus ").replace("*", " ").replace("…", "... ")
    for k in [k for k in SAY if k.endswith(".")]:   # dotted initials, swallowing the final dot
        t = t.replace(k, SAY[k])
    t = re.sub(r"\b0\.(\d)(\d)\b", lambda m: "zero point %s %s" % (DIGIT[m.group(1)], DIGIT[m.group(2)]), t)

    def fix(m: re.Match) -> str:
        w = m.group(0)
        bare = w.rstrip(".")
        tail = w[len(bare):]
        if w in SAY:
            return SAY[w]
        if bare in SAY:
            return SAY[bare] + tail
        if bare.endswith("s") and bare[:-1] in SAY:
            return SAY[bare[:-1]] + "s" + tail
        if bare.endswith("s") and len(bare) > 2 and bare[:-1].isupper():
            bare = bare[:-1].lower() + "s"
            return bare + tail
        if len(bare) > 1 and bare.isupper() and not any(ch.isdigit() for ch in bare):
            return bare.lower() + tail   # stop espeak spelling ALL-CAPS words letter by letter
        return w

    return TOKEN.sub(fix, t)


def fname(line_id: str) -> str:
    return line_id.replace(" ", "_") + ".ogg"


MODEL_URL = "https://github.com/thewh1teagle/kokoro-onnx/releases/download/model-files-v1.0/"
_tts = None


def tts():
    global _tts
    if _tts is None:
        import os
        import urllib.request
        from kokoro_onnx import Kokoro
        d = pathlib.Path(os.environ.get("KOKORO_DIR", pathlib.Path.home() / ".cache" / "redline-tts"))
        d.mkdir(parents=True, exist_ok=True)
        for f in ["kokoro-v1.0.onnx", "voices-v1.0.bin"]:
            if not (d / f).exists():
                print("downloading", f)
                urllib.request.urlretrieve(MODEL_URL + f, d / f)
        _tts = Kokoro(str(d / "kokoro-v1.0.onnx"), str(d / "voices-v1.0.bin"))
    return _tts


def render(line: dict) -> str:
    import soundfile as sf
    out = OUT / fname(line["id"])
    samples, sr = tts().create(speakable(line["text"]), voice=VOICE, speed=SPEED, lang="en-us")
    with tempfile.TemporaryDirectory() as td:
        raw = pathlib.Path(td) / "raw.wav"
        sf.write(raw, samples, sr)
        subprocess.run(["sox", "-V1", str(raw), "-r", "22050", "-C", "1", str(out)] + FX + ["gain", "-n", "-1"], check=True)
    return line["id"]


def main() -> None:
    data = json.loads(LINES.read_text())
    lines = data if isinstance(data, list) else data["lines"]
    OUT.mkdir(parents=True, exist_ok=True)
    man_path = OUT / "manifest.json"
    manifest = json.loads(man_path.read_text()) if man_path.exists() else {}
    want = {}
    todo = []
    for ln in lines:
        h = hashlib.sha1((RECIPE + "|" + speakable(ln["text"])).encode()).hexdigest()[:12]
        want[ln["id"]] = h
        if manifest.get(ln["id"]) != h or not (OUT / fname(ln["id"])).exists():
            todo.append(ln)
    # Two worker processes (one model each); the manifest is saved as lines finish, so a run can resume.
    from concurrent.futures import ProcessPoolExecutor, as_completed
    done = {k: v for k, v in manifest.items() if k in want and want[k] == v}
    with ProcessPoolExecutor(max_workers=WORKERS) as ex:
        futs = [ex.submit(render, ln) for ln in todo]
        for n, f in enumerate(as_completed(futs), 1):
            lid = f.result()
            done[lid] = want[lid]
            man_path.write_text(json.dumps(done, indent=1, sort_keys=True) + "\n")
            if n % 25 == 0:
                print(f"  {n}/{len(todo)}", flush=True)
    for old in set(manifest) - set(want):   # lines retired from the Bible
        (OUT / fname(old)).unlink(missing_ok=True)
        (OUT / (fname(old) + ".import")).unlink(missing_ok=True)
    man_path.write_text(json.dumps(want, indent=1, sort_keys=True) + "\n")
    print(f"{len(todo)} rendered, {len(want)} lines voiced -> {OUT.relative_to(ROOT)}")
    if "--show" in sys.argv:
        for ln in lines:
            if speakable(ln["text"]) != ln["text"]:
                print(ln["id"], "|", speakable(ln["text"]))


if __name__ == "__main__":
    main()
