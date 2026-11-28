#!/usr/bin/env python3
"""NODE-AUTHORITY-001 reference check (Claude, 2026-11-27). Read-only.

Core Rules §8.3 is the single current definition of Node purposes and services (AGENTS.md / CLAUDE.md §7).
This scan fails when another active document restates or contradicts it:

  * the canonical section, its anchor or its Node table is missing from Core Rules;
  * a second Node table (a row per Node type) appears in another active document without citing §8.3;
  * an active line repeats a retired or prohibited Node service (Uplink Wipe, REFACTOR at the Uplink,
    VITAE at the DEAD DROP or the Clinic, PATCHWORK at the SAFEHOUSE, "1 Uplink in 3", the 40 CRED Lab price)
    without being labelled historical or superseded.

Runtime consumers (godot/scripts, godot/data) are listed as *pending* (runtime implementation is still open), and they
don't fail the scan. Decision records, the development log and lore documents are history (AGENTS.md §7).

    python3 tools/csa/scan_node_authority.py          # summary; exit 1 on any documentation finding
    python3 tools/csa/scan_node_authority.py --json   # findings as JSON

A prototype for the CSA-05 drift job, like scan_card_drift.py.
"""
import argparse, glob, json, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CANON = "docs/REDLINE_CORE_RULES.md"
CANON_START = "### 8.3 Other Nodes"
CANON_ANCHOR = '<a id="node-authority"></a>'
NODES = ["Black Market Uplink", "Console Lab", "SAFEHOUSE", "DEAD DROP", "SIGNAL UNCLEAR"]
# History and lore (AGENTS.md §7), decision records and dated reports: not current definitions.
NOT_CURRENT = re.compile(r"ARCHIVE|REDLINE_BIBLE\.md$|CORE_DESIGN_AND_WORLDBUILDING|RULE_REVIEW_126|HALCYON_PLAYTEST3|"
                         r"DEVELOPMENT_LOG|MASTER_DESIGN|/history/|/operations/reports/|/evidence/|SURPRISES\.md$|"
                         r"PLAYTEST_GUIDE")   # the playtest guide describes one shipped build
HISTORICAL = re.compile(r"historical|superseded|retired|NODE-AUTHORITY-001|\bwas\b|~~", re.I)
RULES = [
    ("uplink-wipe", re.compile(r"\bW(?:ipe|IPE)\b(?! TRAIL)")),
    ("uplink-refactor", re.compile(r"REFACTOR.{0,40}\bUplink\b|\bUplink\b.{0,40}REFACTOR")),
    ("clinic-frequency", re.compile(r"1 Uplink in 3", re.I)),
    ("clinic-vitae", re.compile(r"(?<!BLACK )Clinic\b.{0,60}\bVITAE\b|\bVITAE\b.{0,60}(?<!BLACK )Clinic\b")),   # BLACK CLINIC is a SIGNAL UNCLEAR event
    ("dead-drop-healing", re.compile(r"DEAD DROP.{0,60}(PATCH UP|Patch yourself up|heal|\+\d+ VITAE)|(PATCH UP|heal).{0,60}DEAD DROP", re.I)),
    ("safehouse-patchwork", re.compile(r"SAFEHOUSE.{0,60}PATCHWORK|PATCHWORK.{0,60}SAFEHOUSE")),
    ("lab-old-price", re.compile(r"Console Lab.{0,60}40 CRED|40 CRED.{0,60}Console Lab")),
]
NODE_ROW = re.compile(r"^\|\s*\**\s*(?:<a [^>]*></a>)?\**(" + "|".join(map(re.escape, NODES)) + r")\**\s*\|")


def active_docs(root):
    paths = glob.glob(os.path.join(root, "docs/**/*.md"), recursive=True) + [os.path.join(root, f) for f in ("AGENTS.md", "CLAUDE.md", "README.md")]
    return sorted(p for p in paths if os.path.exists(p) and not NOT_CURRENT.search(p.replace(os.sep, "/")))


def canon_span(lines):
    """Line range (0-based, end exclusive) of Core Rules §8.3."""
    start = next((i for i, l in enumerate(lines) if l.startswith(CANON_START)), None)
    if start is None:
        return None
    end = next((i for i in range(start + 1, len(lines)) if re.match(r"^#{2,3} ", lines[i])), len(lines))
    return start, end


def scan(root=ROOT):
    docs, runtime = [], []
    canon_path = os.path.join(root, CANON)
    lines = open(canon_path, encoding="utf-8").read().split("\n")
    span = canon_span(lines)
    if span is None:
        docs.append({"rule": "canon-missing", "file": CANON, "line": 0, "text": "Core Rules §8.3 not found"})
        span = (0, 0)
    else:
        body = lines[span[0]:span[1]]
        if not any(CANON_ANCHOR in l for l in body):
            docs.append({"rule": "canon-anchor", "file": CANON, "line": span[0] + 1, "text": "anchor node-authority missing"})
        found = {m.group(1) for l in body for m in [NODE_ROW.match(l)] if m}
        for n in NODES:
            if n not in found:
                docs.append({"rule": "canon-row", "file": CANON, "line": span[0] + 1, "text": "no canonical row for " + n})
    for p in active_docs(root):
        rel = os.path.relpath(p, root).replace(os.sep, "/")
        for ln, line in enumerate(open(p, encoding="utf-8"), 1):
            if rel == CANON and span[0] < ln <= span[1]:
                continue
            m = NODE_ROW.match(line)
            if m and "§8.3" not in line and not HISTORICAL.search(line):
                docs.append({"rule": "second-node-table", "file": rel, "line": ln, "text": line.strip()[:160]})
                continue
            if HISTORICAL.search(line) or "§8.3" in line:   # labelled history, or a reference to the authority
                continue
            for rule, rx in RULES:
                if rx.search(line):
                    docs.append({"rule": rule, "file": rel, "line": ln, "text": line.strip()[:160]})
                    break
    for p in sorted(glob.glob(os.path.join(root, "godot/scripts/**/*.gd"), recursive=True) + glob.glob(os.path.join(root, "godot/data/*.json"))):
        rel = os.path.relpath(p, root).replace(os.sep, "/")
        for ln, line in enumerate(open(p, encoding="utf-8"), 1):
            for rule, rx in RULES:
                if rule != "uplink-wipe" and rx.search(line):   # "wipe" is also an animation word in code
                    runtime.append({"rule": rule, "file": rel, "line": ln, "text": line.strip()[:160]})
                    break
    return docs, runtime


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--json", action="store_true")
    ap.add_argument("--root", default=ROOT)
    a = ap.parse_args()
    docs, runtime = scan(a.root)
    if a.json:
        print(json.dumps({"documentation": docs, "runtime_pending": runtime}, indent=1, ensure_ascii=False))
    else:
        print("NODE-AUTHORITY-001 scan: %d active documents" % len(active_docs(a.root)))
        print("Documentation findings: %d" % len(docs))
        for f in docs:
            print("  [%s] %s:%d  %s" % (f["rule"], f["file"], f["line"], f["text"]))
        print("Runtime consumers pending (not a failure): %d" % len(runtime))
        for f in runtime:
            print("  [%s] %s:%d  %s" % (f["rule"], f["file"], f["line"], f["text"]))
    return 1 if docs else 0


if __name__ == "__main__":
    sys.exit(main())
