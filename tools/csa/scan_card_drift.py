#!/usr/bin/env python3
"""CSA-01 evidence scanner (Claude Code, 2026-11-27). Read-only; not a CI gate.

Compares the card definitions in godot/scripts/core/cards.gd (CardDB.DEFS) with every card row in the
Markdown tables of the active docs, and lists approved PROBE-004a text versus the engine text.

    python3 tools/csa/scan_card_drift.py            # summary
    python3 tools/csa/scan_card_drift.py --json f   # full findings

A prototype for the CSA-05 drift check; the proposal is docs/architecture-v2/CANONICAL_SOURCE_ARCHITECTURE.md.
"""
import argparse, collections, glob, json, os, re

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
# Lore/history documents (AGENTS.md §7) and the decision records are not current card definitions.
NOT_CURRENT = re.compile(r"ARCHIVE|REDLINE_BIBLE\.md$|CORE_DESIGN_AND_WORLDBUILDING|RULE_REVIEW_126|HALCYON_PLAYTEST3|"
                         r"DEVELOPMENT_LOG|HANDOFF|MASTER_DESIGN")
RUSTLER_NAMES = {"ECHO", "RIOT", "VECTOR", "GENERALIST"}


def card_db():
    src = open(os.path.join(ROOT, "godot/scripts/core/cards.gd"), encoding="utf-8").read()
    part = src[src.index("const DEFS"):src.index("const STARTER_GENERALIST")]
    keys = list(re.finditer(r'^\t"([A-Z0-9_]+)": \{', part, re.M))
    out = {}
    for k, nx in zip(keys, keys[1:] + [None]):
        body = part[k.start():nx.start() if nx else len(part)]
        name = re.search(r'"name": "([^"]+)"', body).group(1).upper()
        text = re.search(r'"text": "((?:[^"\\]|\\.)*)"', body)
        out[name] = {"id": k.group(1), "bw": int(re.search(r'"bw": (-?\d+)', body).group(1)),
                     "text": text.group(1) if text else ""}
    caps = set(re.findall(r'"([A-Z0-9_]+)": \{\s*"name": "[^"]+", "rarity"', src))
    return out, caps


def doc_rows():
    occ = collections.defaultdict(list)
    docs = [p for p in sorted(glob.glob(os.path.join(ROOT, "docs/*.md"))) if not NOT_CURRENT.search(p)]
    for p in docs:
        for ln, line in enumerate(open(p, encoding="utf-8"), 1):
            if not line.startswith("|"): continue
            c = [x.strip() for x in line.strip().strip("|").split("|")]
            for i, x in enumerate(c):
                if re.match(r"^(PROGRAM|SCRIPT|PROTOCOL|HARDWARE)\b", x) and i >= 1 and i + 2 < len(c):
                    j = i - 1
                    if re.match(r"^\**(Common|Uncommon|Rare|Starter)\**$", c[j], re.I) and j >= 1: j -= 1
                    name = re.sub(r"\s*\(.*\)$", "", re.sub(r"[*_`]", "", c[j]).strip().upper())
                    if re.match(r"^[A-Z][A-Z0-9 '’&.\-]+$", name) and not name.isdigit():
                        bw = re.match(r"^(\d+)\s*BW", c[i + 1])
                        occ[name].append({"doc": os.path.relpath(p, ROOT), "line": ln,
                                          "bw": int(bw.group(1)) if bw else None, "text": c[i + 2]})
                    break
    return docs, occ


def norm(s):
    s = re.sub(r"\*|_|`|\(.*?\)", "", s.lower().replace("−", "-"))
    return re.sub(r"[^a-z0-9]+", " ", s).strip()


def main():
    ap = argparse.ArgumentParser(); ap.add_argument("--json"); a = ap.parse_args()
    db, caps = card_db(); docs, occ = doc_rows()
    rows = [(n, r) for n, rs in occ.items() for r in rs]
    matched = [(n, r) for n, r in rows if n in db]
    text_diff = [{"card": n, **r, "carddb": db[n]["text"]} for n, r in matched if norm(r["text"]) != norm(db[n]["text"])]
    bw_diff = [{"card": n, **r, "carddb_bw": db[n]["bw"]} for n, r in matched if r["bw"] is not None and r["bw"] != db[n]["bw"]]
    absent = sorted(n for n in occ if n not in db and n not in RUSTLER_NAMES)
    multi = {n: sorted({r["doc"] for r in rs}) for n, rs in occ.items() if len({r["doc"] for r in rs}) > 1}
    res = {"carddb_cards": len(db), "carddb_caps": len(caps), "active_docs_scanned": len(docs),
           "doc_card_rows": len(rows), "doc_rows_matching_a_carddb_card": len(matched),
           "rows_text_differs_from_carddb": len(text_diff), "rows_bw_differs_from_carddb": len(bw_diff),
           "doc_card_names_absent_from_carddb": absent, "carddb_cards_without_doc_row": sorted(n for n in db if n not in occ),
           "cards_tabulated_in_more_than_one_doc": multi, "bw_diffs": bw_diff, "text_diffs": text_diff}
    print(json.dumps({k: v for k, v in res.items() if k not in ("text_diffs",)}, indent=1, ensure_ascii=False))
    if a.json:
        with open(a.json, "w", encoding="utf-8") as f: json.dump(res, f, indent=1, ensure_ascii=False)


if __name__ == "__main__":
    main()
