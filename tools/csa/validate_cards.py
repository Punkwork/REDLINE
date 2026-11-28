#!/usr/bin/env python3
"""CSA-03 (CONSISTENCY-001a): validate godot/data/cards.json, the single card source.

    python3 tools/csa/validate_cards.py              # exit 0 when valid
    python3 tools/csa/validate_cards.py path.json    # validate another file (tests use this)

Checks (C1): schema name; one record per ID with no duplicate keys anywhere in the file; required fields
and their types on every card and CAP; known card types and rarities; every number whole (the Godot loader
turns JSON numbers back into int); starter decks, the core pool and pool extras name existing cards.
Later CSA-03 commits add status, decision and eligibility checks (see CANONICAL_SOURCE_ARCHITECTURE.md §7).
"""
import json, os, sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
DEFAULT = os.path.join(ROOT, "godot", "data", "cards.json")
SCHEMA = "panopticon.cards/1"
CARD_TYPES = {"PROGRAM", "SCRIPT", "PROTOCOL", "BLOATWARE"}
RARITIES = {"STARTER", "COMMON", "UNCOMMON", "RARE", "BLOAT"}   # BLOAT: Bloatware (SPAM, TRACER)
CAP_RARITIES = {"COMMON", "UNCOMMON", "RARE"}
CARD_REQUIRED = {"name": str, "type": str, "tags": list, "bw": int, "rarity": str, "text": str}
CAP_REQUIRED = {"name": str, "rarity": str, "price": int, "text": str}
RUSTLERS = {"GENERALIST", "ECHO", "RIOT", "VECTOR"}


class DuplicateKey(ValueError):
    pass


def _no_duplicates(pairs):
    seen = {}
    for k, v in pairs:
        if k in seen:
            raise DuplicateKey("duplicate key %r" % k)
        seen[k] = v
    return seen


def validate(path=DEFAULT):
    """Return a list of error strings; empty means valid."""
    errors = []
    try:
        with open(path, encoding="utf-8") as f:
            data = json.load(f, object_pairs_hook=_no_duplicates)
    except DuplicateKey as e:
        return ["%s (each ID may have one record only)" % e]
    except (OSError, ValueError) as e:
        return ["cannot read %s: %s" % (path, e)]
    if data.get("schema") != SCHEMA:
        errors.append("schema must be %r, got %r" % (SCHEMA, data.get("schema")))
    cards, caps = data.get("cards"), data.get("caps")
    if not isinstance(cards, dict) or not cards:
        return errors + ["'cards' must be a non-empty object"]
    if not isinstance(caps, dict):
        errors.append("'caps' must be an object")
        caps = {}

    def whole(v, where):
        if isinstance(v, float):
            errors.append("%s: %r is not a whole number" % (where, v))
        elif isinstance(v, dict):
            for k, x in v.items():
                whole(x, where + "." + k)
        elif isinstance(v, list):
            for i, x in enumerate(v):
                whole(x, "%s[%d]" % (where, i))
    whole(data, "cards.json")

    for kind, table, required in (("card", cards, CARD_REQUIRED), ("CAP", caps, CAP_REQUIRED)):
        for cid, rec in table.items():
            if not cid or cid != cid.upper() or " " in cid:
                errors.append("%s ID %r must be UPPER_SNAKE_CASE" % (kind, cid))
            if not isinstance(rec, dict):
                errors.append("%s %s: record must be an object" % (kind, cid)); continue
            for field, typ in required.items():
                if field not in rec:
                    errors.append("%s %s: missing %r" % (kind, cid, field))
                elif not isinstance(rec[field], typ) or (typ is int and isinstance(rec[field], bool)):
                    errors.append("%s %s: %r must be %s" % (kind, cid, field, typ.__name__))
            if rec.get("rarity") not in (RARITIES if kind == "card" else CAP_RARITIES):
                errors.append("%s %s: unknown rarity %r" % (kind, cid, rec.get("rarity")))
    for cid, rec in cards.items():
        if isinstance(rec, dict) and rec.get("type") not in CARD_TYPES:
            errors.append("card %s: unknown type %r" % (cid, rec.get("type")))

    starters = data.get("starters", {})
    if set(starters) != RUSTLERS:
        errors.append("starters must name exactly %s" % sorted(RUSTLERS))
    for r, deck in starters.items():
        for cid in deck:
            if cid not in cards:
                errors.append("starter deck %s names unknown card %r" % (r, cid))
    for cid in data.get("core_pool", []):
        if cid not in cards:
            errors.append("core_pool names unknown card %r" % cid)
    if len(set(data.get("core_pool", []))) != len(data.get("core_pool", [])):
        errors.append("core_pool lists a card twice")
    for r, extra in data.get("pool_extra", {}).items():
        if r not in RUSTLERS:
            errors.append("pool_extra names unknown Rustler %r" % r)
        for cid, rar in extra.items():
            if cid not in cards:
                errors.append("pool_extra %s names unknown card %r" % (r, cid))
            if rar not in RARITIES:
                errors.append("pool_extra %s %s: unknown rarity %r" % (r, cid, rar))
    return errors


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else DEFAULT
    errors = validate(path)
    for e in errors:
        print("ERROR:", e)
    with open(path, encoding="utf-8") as f:
        d = json.load(f)
    print("cards.json: %d cards, %d CAPS, %d starter decks: %s" % (
        len(d.get("cards", {})), len(d.get("caps", {})), len(d.get("starters", {})),
        "VALID" if not errors else "%d error(s)" % len(errors)))
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
