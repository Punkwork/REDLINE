#!/usr/bin/env python3
"""CSA-03 (CONSISTENCY-001a): validate godot/data/cards.json, the single card source.

    python3 tools/csa/validate_cards.py              # exit 0 when valid
    python3 tools/csa/validate_cards.py path.json    # validate another file (tests use this)

Checks (C1): schema name; one record per ID with no duplicate keys anywhere in the file; required fields
and their types on every card and CAP; known card types and rarities; every number whole (the Godot loader
turns JSON numbers back into int); starter decks, the core pool and pool extras name existing cards.
Later CSA-03 commits add status, decision and eligibility checks (see CANONICAL_SOURCE_ARCHITECTURE.md §7).
"""
import glob, json, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
DEFAULT = os.path.join(ROOT, "godot", "data", "cards.json")
SCHEMA = "panopticon.cards/1"
CARD_TYPES = {"PROGRAM", "SCRIPT", "PROTOCOL", "BLOATWARE"}
RARITIES = {"STARTER", "COMMON", "UNCOMMON", "RARE", "BLOAT"}   # BLOAT: Bloatware (SPAM, TRACER)
CAP_RARITIES = {"COMMON", "UNCOMMON", "RARE"}
CARD_REQUIRED = {"name": str, "type": str, "tags": list, "bw": int, "rarity": str, "text": str}
CAP_REQUIRED = {"name": str, "rarity": str, "price": int, "text": str}
RUSTLERS = {"GENERALIST", "ECHO", "RIOT", "VECTOR"}
DESIGN = {"approved", "playtest", "experimental", "historical"}
IMPLEMENTATION = {"implemented", "pending", "divergent"}
DECISION_ID = re.compile(r"^[A-Z][A-Z0-9]*(?:-[A-Z0-9]+)*-\d{3}[a-z]?$")
BANNED = ("archipelago", "gulag")   # ARCH-SLANG-001 copy guard, as ArchCopy.valid_line
# Where a decision ID may be recorded: Master Design first, then the active rules docs (AGENTS.md §7).
NOT_CURRENT = re.compile(r"ARCHIVE|REDLINE_BIBLE\.md$|CORE_DESIGN_AND_WORLDBUILDING|RULE_REVIEW_126|HALCYON_PLAYTEST3|"
                         r"DEVELOPMENT_LOG|HANDOFF")


def decision_texts():
    docs = os.path.join(ROOT, "docs")
    master = open(os.path.join(docs, "REDLINE_MASTER_DESIGN.md"), encoding="utf-8").read()
    rest = "\n".join(open(p, encoding="utf-8").read() for p in sorted(glob.glob(os.path.join(docs, "*.md")))
                     if not NOT_CURRENT.search(p) and not p.endswith("REDLINE_MASTER_DESIGN.md"))
    return master, rest


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
    # --- CSA-03 C2: status, decisions, eligibility, copy guard ---
    master, rest = decision_texts()
    def check_decisions(ids, where):
        if not isinstance(ids, list):
            errors.append("%s: decisions must be a list" % where); return
        for did in ids:
            if not isinstance(did, str) or not DECISION_ID.match(did):
                errors.append("%s: %r is not a decision ID" % (where, did))
            elif did not in master and did not in rest:
                errors.append("%s: decision %s is not recorded in Master Design or the active rules docs" % (where, did))
    for kind, table in (("card", cards), ("CAP", caps)):
        for cid, rec in table.items():
            if not isinstance(rec, dict):
                continue
            st = rec.get("status")
            if not isinstance(st, dict) or st.get("design") not in DESIGN or st.get("implementation") not in IMPLEMENTATION:
                errors.append("%s %s: status must be {design: %s, implementation: %s}" % (kind, cid, sorted(DESIGN), sorted(IMPLEMENTATION)))
                continue
            check_decisions(rec.get("decisions"), "%s %s" % (kind, cid))
            divergent = st["implementation"] == "divergent"
            if divergent and not str(rec.get("divergence", "")).strip():
                errors.append("%s %s: divergent records must say why in 'divergence'" % (kind, cid))
            if not divergent and ("divergence" in rec or "approved_text" in rec):
                errors.append("%s %s: 'divergence'/'approved_text' are only for divergent records" % (kind, cid))
            if "approved_text" in rec and rec["approved_text"] == rec.get("text"):
                errors.append("%s %s: approved_text equals text; the record is no longer divergent" % (kind, cid))
            if st["implementation"] == "pending" and st["design"] not in ("approved", "playtest"):
                errors.append("%s %s: only approved or playtest designs can be pending" % (kind, cid))
            if not isinstance(rec.get("unresolved", []), list):
                errors.append("%s %s: 'unresolved' must be a list of field names" % (kind, cid))
            for field in ("name", "text", "approved_text", "flavor"):
                low = str(rec.get(field, "")).lower()
                for word in BANNED:
                    if word in low:
                        errors.append("%s %s: %s contains banned wording %r (ARCH-SLANG-001)" % (kind, cid, field, word))
    def status(cid):
        return cards.get(cid, {}).get("status", {}) if isinstance(cards.get(cid), dict) else {}
    for r, deck in starters.items():
        for cid in set(deck):
            st = status(cid)
            if st.get("implementation") == "pending" or st.get("design") in ("experimental", "historical"):
                errors.append("starter deck %s holds %s (%s/%s); starter cards must be current and built" % (r, cid, st.get("design"), st.get("implementation")))
    for cid in data.get("core_pool", []):
        if status(cid).get("design") in ("experimental", "historical"):
            errors.append("core_pool holds %s card %s" % (status(cid).get("design"), cid))
    for r, extra in data.get("pool_extra", {}).items():
        for cid in extra:
            st = status(cid)
            if st.get("implementation") == "pending" or st.get("design") in ("experimental", "historical"):
                errors.append("pool_extra %s holds %s, which cannot be a reward" % (r, cid))
    for r, ids in data.get("starter_decisions", {}).items():
        check_decisions(ids, "starter_decisions %s" % r)
    check_decisions(data.get("core_pool_decisions", []), "core_pool_decisions")
    return errors


def register(path=DEFAULT):
    """The open gaps the records declare: divergent, pending and experimental cards."""
    with open(path, encoding="utf-8") as f:
        cards = json.load(f)["cards"]
    out = {"divergent": [], "pending": [], "experimental": [], "no_decisions": []}
    for cid, rec in cards.items():
        st = rec.get("status", {})
        if st.get("implementation") == "divergent": out["divergent"].append((cid, rec.get("divergence", "")))
        if st.get("implementation") == "pending": out["pending"].append(cid)
        if st.get("design") == "experimental": out["experimental"].append(cid)
        if not rec.get("decisions"): out["no_decisions"].append(cid)
    return out


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    path = args[0] if args else DEFAULT
    errors = validate(path)
    for e in errors:
        print("ERROR:", e)
    with open(path, encoding="utf-8") as f:
        d = json.load(f)
    print("cards.json: %d cards, %d CAPS, %d starter decks: %s" % (
        len(d.get("cards", {})), len(d.get("caps", {})), len(d.get("starters", {})),
        "VALID" if not errors else "%d error(s)" % len(errors)))
    if not errors and "--register" in sys.argv:
        reg = register(path)
        print("\nOpen implementation gaps declared by the records:")
        for cid, why in reg["divergent"]:
            print("  divergent  %-20s %s" % (cid, why))
        print("  pending    %s" % ", ".join(reg["pending"]))
        print("  experimental (never rewards, not in starter decks): %s" % ", ".join(reg["experimental"]))
        print("  records with no decision ID yet: %d of %d" % (len(reg["no_decisions"]), len(d["cards"])))
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
