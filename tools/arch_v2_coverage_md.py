#!/usr/bin/env python3
"""ARCH-V2-005: write docs/architecture-v2/ENCOUNTER_COVERAGE.md from godot/tests/arch_v2_coverage.json.

The JSON is the source; test_arch_v2_coverage.gd checks the V2 screen against it and checks that this
Markdown lists every row with the same status. Run after editing the JSON:
    python3 tools/arch_v2_coverage_md.py
"""
import json, pathlib, collections

root = pathlib.Path(__file__).resolve().parent.parent
data = json.loads((root / "godot/tests/arch_v2_coverage.json").read_text(encoding="utf-8"))
rows = data["rows"]
count = collections.Counter(r["status"] for r in rows)
out = [
    "# Encounter coverage: prototype → Architecture V2 (ARCH-V2-005)",
    "",
    "Every element the Build 12 encounter shows, and where it lives on the V2 encounter screen. "
    "Generated from `godot/tests/arch_v2_coverage.json` by `tools/arch_v2_coverage_md.py`; do not edit by hand. "
    "`godot/tests/test_arch_v2_coverage.gd` fails if a BUILT or PLACEHOLDER row has no node on the V2 screen, "
    "or if this file and the JSON disagree.",
    "",
    "**Totals:** " + " · ".join(f"{s} {count.get(s, 0)}" for s in data["statuses"]) + f" · {len(rows)} rows.",
    "",
    "| Status | Meaning |",
    "|---|---|",
]
out += [f"| {s} | {m} |" for s, m in data["statuses"].items()]
area = None
for r in rows:
    if r["area"] != area:
        area = r["area"]
        out += ["", f"## {area}", "", "| ID | Element | Prototype source | V2 node | Status | Next | Note |", "|---|---|---|---|---|---|---|"]
    v2 = f"`{r['v2']}`" if r["v2"] else "—"
    out.append(f"| {r['id']} | {r['element']} | {r['prototype']} | {v2} | {r['status']} | {r['next'] or '—'} | {r['note'] or ''} |")
(root / "docs/architecture-v2/ENCOUNTER_COVERAGE.md").write_text("\n".join(out) + "\n", encoding="utf-8")
print(f"wrote {len(rows)} rows")
