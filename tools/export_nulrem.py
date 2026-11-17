"""Export NUL/REM's CANON verses from docs/REDLINE_BIBLE.md to godot/data/nulrem_lines.json.

Run from the repository root:  python3 tools/export_nulrem.py
Only CANON verses are exported (RETIRED verses are skipped; a v2 replaces its original).
Each line keeps its trigger (EV-xx), mode and simple filter tags read from the verse's
Placement and Function text (corporation, Rustler, after-loss / after-win, special conditions).
"""
import json
import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parents[1]
BIBLE = ROOT / "docs" / "REDLINE_BIBLE.md"
OUT = ROOT / "godot" / "data" / "nulrem_lines.json"

VERSE = re.compile(
    # Meta and line must stay inside one verse: a verse without a **Placement:** line
    # (e.g. "Possible placement (OPEN)") must not swallow the next verse.
    r"### VERSE (NR-\d+(?: v2)?) — ([^\n]*)\n\*\*Status:\*\* (\w+)((?:(?!### VERSE).)*?)\n\n> “([^”]*)”\n\n(\*\*Placement:\*\*[^\n]*)",
    re.S,
)

CORPS = ["HALCYON", "IRONWATCH", "LUCIDA", "THE HEARTH", "OVERWATCH", "ANIMA"]
RUSTLERS = ["Generalist", "ECHO", "RIOT", "VECTOR"]


def tags_for(meta: str, placement: str, line: str = "") -> dict:
    text = meta + " " + placement
    t = {}
    for c in CORPS:
        if c in placement or re.search(r"\b" + re.escape(c) + r"\b (lesson|escape|ICE)", meta):
            t.setdefault("corp", []).append(c)
    m = re.search(r"Rustler identity: (?:[Tt]he )?(\w+)", meta)
    if m:
        t["rustler"] = m.group(1)
    if "after a lost run" in text or "after loss" in text:
        t["after"] = "loss"
    if "after a won run" in text or "after win" in text:
        t["after"] = "win"
    if "first win only" in text.lower():
        t["first_win"] = True
    if "only after NR-025" in text or "only once NR-025" in text or "NR-025 has already been heard" in text:
        t["requires"] = "NR-025"
    if "only when Bootleg CAPS" in text or "Only when Bootleg CAPS" in text:
        t["bootleg"] = True
    for bloat in ["SPAM", "CITATION", "INTRUSIVE THOUGHT"]:
        if re.search(r"Bloatware inserted;? " + bloat + r"\b", meta) or meta.strip().endswith(bloat + "."):
            t["bloat"] = bloat
    if line.startswith("DEAD DROP") or ("DEAD DROP" in meta and "SAFEHOUSE" not in meta):
        t["rest"] = "DEAD_DROP"
    elif "SAFEHOUSE" in meta or "SAFEHOUSE" in placement:
        t["rest"] = "SAFEHOUSE"
    if "cause: Black ICE" in placement:
        t["cause"] = "BLACK_ICE"
    elif "cause: high CORTEX" in placement:
        t["cause"] = "CORTEX"
    elif "cause: TRACE" in placement:
        t["cause"] = "TRACE"
    if "plays when the player chooses to go deeper" in placement:
        t["deeper"] = True
    return t


def main() -> None:
    s = BIBLE.read_text()
    lines = []
    for m in VERSE.finditer(s):
        vid, title, status, meta, line, placement = m.groups()
        if status != "CANON":
            continue
        assert "###" not in line and "**" not in line, vid
        trig = re.findall(r"EV-\d\d", placement)
        if not trig:
            continue
        mode = re.search(r"\*\*Mode:\*\* ([^·]+)", meta)
        lines.append({
            "id": vid,
            "title": title.strip(),
            "trigger": trig[0],
            "mode": mode.group(1).strip() if mode else "",
            "text": line,
            "tags": tags_for(meta, placement, line),
        })
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps({"source": "docs/REDLINE_BIBLE.md", "lines": lines}, ensure_ascii=False, indent=1))
    by = {}
    for l in lines:
        by[l["trigger"]] = by.get(l["trigger"], 0) + 1
    print(f"{len(lines)} lines exported to {OUT.relative_to(ROOT)}")
    print(" ".join(f"{k}:{v}" for k, v in sorted(by.items())))


if __name__ == "__main__":
    main()
