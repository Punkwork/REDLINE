#!/usr/bin/env python3
"""CSA-04f: generated card views in the owner docs (CSA-02 element 5, Q2).

The canonical card records live in godot/data/cards.json. Card Pools (pool cards) and Rustlers (starter
decks) show them in marked blocks that this tool writes; nobody edits inside a block by hand.

  <!-- GENERATED:cards ids=BATTERING_RAM,JACKHAMMER -->   one row per listed card, in that order
  <!-- GENERATED:starter rustler=GENERALIST -->           the Rustler's starter deck, with quantities
  ... generated table ...
  <!-- /GENERATED -->

The doc keeps its own headings, grouping and prose; the marker names which cards a block shows, and
every value in the block comes from cards.json.

Usage:
  python3 tools/csa/gen_card_docs.py          rewrite every block in the owner docs
  python3 tools/csa/gen_card_docs.py --check  exit 1 if any block differs from what cards.json gives
Options --cards PATH and --docs PATH... (tests run them on copies; the live files are the defaults).
"""
import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CARDS = ROOT / "godot" / "data" / "cards.json"
DOCS = [ROOT / "docs" / "REDLINE_CARD_POOLS.md", ROOT / "docs" / "REDLINE_RUSTLERS.md"]

BLOCK = re.compile(r"(<!-- GENERATED:(cards|starter) ([^>]*?) -->\n)(.*?)(<!-- /GENERATED -->)", re.S)
BANNER = "*Generated from `godot/data/cards.json` by `tools/csa/gen_card_docs.py`. Edit the card records, not this table.*\n\n"


class GenError(Exception):
    pass


def cell(text: str) -> str:
    return str(text).replace("|", "\\|").replace("\n", " ")


def type_line(c: dict) -> str:
    tags = list(c.get("tags", []))
    line = c.get("type", "")
    if tags:
        line += " — " + ", ".join(tags)
    pick = c.get("pick", {})
    if pick.get("itype"):
        line += " (%s)" % ("any type" if pick["itype"] == "ANY" else pick["itype"])
    return line


def cost(c: dict) -> str:
    parts = ["%d BW" % int(c.get("bw", 0))]
    if int(c.get("ram", 0)) > 0:
        parts.append("%d RAM" % int(c["ram"]))
    if int(c.get("trace_cost", 0)) > 0:
        parts.append("+%d TRACE" % int(c["trace_cost"]))
    if int(c.get("cred_cost", 0)) > 0:
        parts.append("%d CRED" % int(c["cred_cost"]))
    return ", ".join(parts)


def name(c: dict) -> str:
    n = "**%s**" % c["name"]
    if c.get("status", {}).get("implementation") == "pending":
        n += " *(not built yet)*"
    return n


def args_of(raw: str) -> dict:
    return dict(kv.split("=", 1) for kv in raw.split())


def cards_block(data: dict, raw: str) -> str:
    ids = [i for i in args_of(raw).get("ids", "").split(",") if i]
    if not ids:
        raise GenError("a cards block lists no ids")
    rows = ["| Card | Rarity | Type / tags | Cost | Effect |", "|---|---|---|---|---|"]
    for i in ids:
        c = data["cards"].get(i)
        if c is None:
            raise GenError("unknown card id %r" % i)
        rows.append("| %s | %s | %s | %s | %s |" % (name(c), c.get("rarity", "").title(), cell(type_line(c)), cost(c), cell(c.get("text", ""))))
    return BANNER + "\n".join(rows) + "\n"


def starter_block(data: dict, raw: str) -> str:
    r = args_of(raw).get("rustler", "")
    deck = data.get("starters", {}).get(r)
    if deck is None:
        raise GenError("unknown rustler %r" % r)
    counts = {}
    for i in deck:
        if i not in data["cards"]:
            raise GenError("unknown card id %r in %s's starter deck" % (i, r))
        counts[i] = counts.get(i, 0) + 1
    rows = ["| Qty | Card | Type / tags | Cost | Effect |", "|---:|---|---|---|---|"]
    for i, n in counts.items():
        c = data["cards"][i]
        rows.append("| %d | %s | %s | %s | %s |" % (n, name(c), cell(type_line(c)), cost(c), cell(c.get("text", ""))))
    return BANNER + "\n".join(rows) + "\n"


def render(text: str, data: dict) -> str:
    def sub(m):
        body = cards_block(data, m.group(3)) if m.group(2) == "cards" else starter_block(data, m.group(3))
        return m.group(1) + body + m.group(5)
    return BLOCK.sub(sub, text)


def main(argv=None) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true")
    ap.add_argument("--cards", default=str(CARDS))
    ap.add_argument("--docs", nargs="*", default=[str(p) for p in DOCS])
    a = ap.parse_args(argv)
    data = json.loads(Path(a.cards).read_text(encoding="utf-8"))
    stale = []
    for doc in a.docs:
        p = Path(doc)
        text = p.read_text(encoding="utf-8")
        try:
            out = render(text, data)
        except GenError as e:
            print("ERROR: %s: %s" % (p.name, e))
            return 1
        if out != text:
            if a.check:
                stale.append(p.name)
            else:
                p.write_text(out, encoding="utf-8")
                print("updated %s" % p.name)
    if stale:
        print("ERROR: generated card blocks differ from cards.json in: %s (run tools/csa/gen_card_docs.py)" % ", ".join(stale))
        return 1
    if a.check:
        print("generated card blocks: in step with cards.json (%d docs)" % len(a.docs))
    return 0


if __name__ == "__main__":
    sys.exit(main())
