#!/usr/bin/env python3
"""CSA-03 (CONSISTENCY-001a): validate godot/data/cards.json, the single card source.

    python3 tools/csa/validate_cards.py              # exit 0 when valid
    python3 tools/csa/validate_cards.py path.json    # validate another file (tests use this)
    python3 tools/csa/validate_cards.py --strategy-matrix markdown
    python3 tools/csa/validate_cards.py --strategy-matrix json
    python3 tools/csa/validate_cards.py --strategy-report

Checks (C1): schema name; one record per ID with no duplicate keys anywhere in the file; required fields
and their types on every card and CAP; known card types and rarities; every number whole (the Godot loader
turns JSON numbers back into int); starter decks, the core pool and pool extras name existing cards.
Later CSA-03 commits add status, decision and eligibility checks (see CANONICAL_SOURCE_ARCHITECTURE.md §7).
"""
import argparse
from collections import Counter
import glob, json, os, re, sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from card_text import TemplateError, loose_digits, render   # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
DEFAULT = os.path.join(ROOT, "godot", "data", "cards.json")
SCHEMA = "panopticon.cards/1"
CARD_TYPES = {"PROGRAM", "SCRIPT", "PROTOCOL", "BLOATWARE"}
RARITIES = {"STARTER", "COMMON", "UNCOMMON", "RARE", "BLOAT"}   # BLOAT: Bloatware (SPAM, TRACER)
CAP_RARITIES = {"COMMON", "UNCOMMON", "RARE"}
CARD_REQUIRED = {"name": str, "type": str, "tags": list, "bw": int, "rarity": str, "text": str}
CAP_REQUIRED = {"name": str, "rarity": str, "price": int, "text": str}
GHOST_REQUIRED = {"name": str, "set": str, "text": str}   # CSA-07 Ghostware records
GHOST_SETS = {"GENERAL", "RESERVE", "HALCYON", "IRONWATCH", "LUCIDA", "ORIGIN"}
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


def load_canonical(path):
    with open(path, encoding="utf-8") as f:
        data = json.load(f, object_pairs_hook=_no_duplicates)
    if not isinstance(data, dict):
        raise ValueError("canonical source must be an object")
    return data


def validate(path=DEFAULT):
    """Return a list of error strings; empty means valid."""
    errors = []
    try:
        data = load_canonical(path)
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
    # --- CSA-04g: the Uplink card contract ---
    up = data.get("uplink")
    if up is not None:
        prices = up.get("card_prices", {})
        if set(prices) != {"COMMON", "UNCOMMON", "RARE"} or not all(isinstance(v, int) and v > 0 for v in prices.values()):
            errors.append("uplink.card_prices must give a positive whole price for COMMON, UNCOMMON and RARE")
        shelf = up.get("card_shelf", {})
        size = shelf.get("size")
        if not isinstance(size, int) or sum(shelf.get("rarity", {}).values()) != size or shelf.get("shared", 0) + shelf.get("rustler", 0) != size:
            errors.append("uplink.card_shelf: rarity counts and shared + rustler must each add up to size")
        if not 0 <= shelf.get("on_sale", 0) <= (size or 0) or not 0 < shelf.get("sale_percent_off", 0) <= 100:
            errors.append("uplink.card_shelf: on_sale and sale_percent_off out of range")
        if not isinstance(up.get("decisions"), list) or not up.get("decisions"):
            errors.append("uplink: decisions must list the approving decision IDs")

    # --- CSA-04i/j: rules-text templates and engine parameters ---
    for cid, rec in cards.items():
        if not isinstance(rec, dict): continue
        if "params" in rec and (not isinstance(rec["params"], dict) or not all(isinstance(v, int) and not isinstance(v, bool) for v in rec["params"].values())):
            errors.append("card %s: params must map names to whole numbers" % cid)
            continue
        for where, tpl, scope in [("text", rec.get("text", ""), rec)] + [("mode %s label" % m.get("id"), m.get("label", ""), m) for m in rec.get("modes", []) if isinstance(m, dict)]:
            try:
                render(str(tpl), scope)
            except TemplateError as e:
                errors.append("card %s: %s placeholder {%s} has no whole number in the record" % (cid, where, e.args[0]))
        loose = loose_digits(str(rec.get("text", "")))
        pending = rec.get("status", {}).get("implementation") == "pending"
        if loose and not pending and not rec.get("params_in_code"):
            errors.append("card %s: text writes %s instead of reading the record; use a {placeholder} or mark params_in_code" % (cid, loose))
        if rec.get("params_in_code") and not loose:
            errors.append("card %s: params_in_code but the text has no literal numbers; remove the flag" % cid)
        if "params_in_code" in rec and rec["params_in_code"] is not True:
            errors.append("card %s: params_in_code must be true or absent" % cid)

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
    if data.get("uplink") is not None:
        check_decisions(data["uplink"].get("decisions", []), "uplink")
    ghost = data.get("ghostware", {})
    if not isinstance(ghost, dict):
        errors.append("'ghostware' must be an object"); ghost = {}
    for gid, rec in ghost.items():
        if not gid or gid != gid.upper() or " " in gid:
            errors.append("Ghostware ID %r must be UPPER_SNAKE_CASE" % gid)
        if not isinstance(rec, dict):
            errors.append("Ghostware %s: record must be an object" % gid); continue
        for field, typ in GHOST_REQUIRED.items():
            if not isinstance(rec.get(field), typ):
                errors.append("Ghostware %s: %r must be %s" % (gid, field, typ.__name__))
        if rec.get("set") not in GHOST_SETS:
            errors.append("Ghostware %s: unknown set %r" % (gid, rec.get("set")))
        if "price" in rec and (not isinstance(rec["price"], int) or isinstance(rec["price"], bool) or rec["price"] <= 0):
            errors.append("Ghostware %s: price must be a positive whole number" % gid)
        if rec.get("set") in ("ORIGIN", "HALCYON", "IRONWATCH", "LUCIDA") and "price" in rec:
            errors.append("Ghostware %s: %s Ghostware is never sold (P5-003, P5-008)" % (gid, rec.get("set")))
        if rec.get("set") == "ORIGIN" and rec.get("rustler") not in RUSTLERS:
            errors.append("Ghostware %s: an ORIGIN names its Rustler" % gid)
    for kind, table in (("card", cards), ("CAP", caps), ("Ghostware", ghost)):
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
    out = {"divergent": [], "pending": [], "experimental": [], "no_decisions": [], "params_in_code": []}
    for cid, rec in cards.items():
        st = rec.get("status", {})
        if st.get("implementation") == "divergent": out["divergent"].append((cid, rec.get("divergence", "")))
        if st.get("implementation") == "pending": out["pending"].append(cid)
        if st.get("design") == "experimental": out["experimental"].append(cid)
        if not rec.get("decisions"): out["no_decisions"].append(cid)
        if rec.get("params_in_code"): out["params_in_code"].append(cid)
    return out


STRATEGY_FAMILIES = (
    "momentum", "ice_suppression", "defensive_endurance", "recursion",
    "surveillance_evasion", "program_synergy", "exploit_synergy", "precision_breaching",
)
STRATEGY_ROLES = ("enabler", "support", "payoff", "bridge")
STRATEGY_SOURCES = {"CARDS": "cards", "CAPS": "caps", "GHOSTWARE": "ghostware"}
STRATEGY_STATES = ("reviewed", "provisional", "unreviewed", "general_purpose", "invalid")


def strategy_errors(strategy):
    if not isinstance(strategy, dict):
        return ["strategy must be an object"]
    errors = []
    for family, roles in sorted(strategy.items()):
        if family not in STRATEGY_FAMILIES:
            errors.append(f"unknown strategy family {family!r}")
        if not isinstance(roles, list) or not roles:
            errors.append(f"{family}: roles must be a non-empty array")
            continue
        seen = set()
        for role in roles:
            if not isinstance(role, str) or role not in STRATEGY_ROLES:
                errors.append(f"{family}: unknown strategy role {role!r}")
            elif role in seen:
                errors.append(f"{family}: duplicate strategy role {role!r}")
            else:
                seen.add(role)
    return sorted(errors)


def matrix_is_consistent(cells, records):
    expected_cells = [(family, role) for family in STRATEGY_FAMILIES for role in STRATEGY_ROLES]
    expected = Counter(
        (record["category"], record["id"], record["state"], family, role)
        for record in records
        for family, roles in (record["strategy"] or {}).items()
        for role in roles
    )
    actual = Counter(
        (item["category"], item["id"], item["state"], cell["family"], cell["role"])
        for cell in cells for item in cell["entries"]
    )
    return [(cell["family"], cell["role"]) for cell in cells] == expected_cells and actual == expected


def strategic_coverage(data, *, reviewed=(), read_error=None):
    """Project canonical data. Only synthetic tests supply reviewed (category, ID) pairs."""
    reviewed = set(reviewed)
    dependencies = ["Revision-specific designer approval contract and baseline review pending."]
    source_errors = [read_error] if read_error else []
    invalid = []
    records = []
    totals = {}
    cells = {
        (family, role): {"family": family, "role": role, "entries": []}
        for family in STRATEGY_FAMILIES for role in STRATEGY_ROLES
    }
    for category, key in STRATEGY_SOURCES.items():
        totals[category] = None
        if category == "GHOSTWARE" and key not in data:
            dependencies.append("GHOSTWARE coverage incomplete until CSA-07 establishes its canonical source.")
            continue
        table = data.get(key)
        if not isinstance(table, dict):
            if not read_error:
                source_errors.append(f"{category}: canonical '{key}' table is missing or malformed")
            continue
        totals[category] = len(table)
        if category == "CARDS" and not table:
            source_errors.append("CARDS: canonical 'cards' table must be non-empty")
        for cid, record in sorted(table.items()):
            if not isinstance(record, dict):
                source_errors.append(f"{category} {cid}: canonical record must be an object")
                continue
            strategy = record.get("strategy")
            errors = strategy_errors(strategy) if "strategy" in record else []
            if errors:
                state = "invalid"
                invalid.append({"category": category, "id": cid, "errors": errors})
                strategy = None
            elif strategy is None:
                state = "unreviewed"
            elif (category, cid) in reviewed:
                state = "reviewed" if strategy else "general_purpose"
            else:
                state = "provisional" if strategy else "unreviewed"
            if strategy is not None:
                strategy = {
                    family: [role for role in STRATEGY_ROLES if role in strategy[family]]
                    for family in STRATEGY_FAMILIES if family in strategy
                }
            item = {"category": category, "id": cid, "state": state}
            records.append({**item, "strategy": strategy})
            for family, roles in (strategy or {}).items():
                for role in roles:
                    cells[family, role]["entries"].append(item)
    matrix = {"cells": list(cells.values()), "records": records}
    counts = Counter(record["state"] for record in records)
    gaps = [{"family": family, "role": role}
            for (family, role), cell in cells.items() if not cell["entries"]]
    consistent = not source_errors and matrix_is_consistent(matrix["cells"], records)
    checks = {
        "canonical_sources": "FAIL" if source_errors else "PASS",
        "strategy_metadata": "FAIL" if invalid else "PASS",
        "matrix_consistency": "PASS" if consistent else "FAIL",
    }
    report = {
        "scope": "Diagnostic only. Checks cover source availability, strategy metadata and matrix consistency.",
        "result": "FAIL" if "FAIL" in checks.values() else "PASS",
        "checks": checks,
        "canonical_totals": totals,
        "classification_counts": {state: counts[state] for state in STRATEGY_STATES},
        "classified_records": counts["reviewed"] + counts["provisional"],
        "reviewed_records": counts["reviewed"] + counts["general_purpose"],
        "unreviewed_records": counts["unreviewed"] + counts["provisional"] + counts["invalid"],
        "records": records,
        "invalid_metadata": invalid,
        "source_errors": source_errors,
        "coverage_gaps": gaps,
        "outstanding_dependencies": dependencies,
    }
    return matrix, report


def render_strategy_markdown(matrix, report):
    lines = ["# Strategic Coverage Matrix", "",
             "Empty cells indicate design opportunities.", "",
             "| Family | Role | Records |", "| --- | --- | --- |"]
    for cell in matrix["cells"]:
        entries = ", ".join(
            f'{entry["category"]} {entry["id"]} ({entry["state"]})' for entry in cell["entries"]
        ).replace("|", r"\|").replace("\n", " ")
        lines.append(f'| {cell["family"]} | {cell["role"]} | {entries or "Empty"} |')
    lines.extend(["", "## Records without matrix entries", ""])
    for item in matrix["records"]:
        if item["strategy"]:
            continue
        label = item["state"]
        if label == "unreviewed":
            label += ", missing metadata" if item["strategy"] is None else ", empty strategy"
        lines.append(f'- {item["category"]} {item["id"]} ({label})')
    lines.extend(["", "## Outstanding dependencies", ""])
    lines.extend(f"- {dependency}" for dependency in report["outstanding_dependencies"])
    lines.extend(f"- {error}" for error in report["source_errors"])
    lines.extend(f'- {item["category"]} {item["id"]}: {", ".join(item["errors"])}'
                 for item in report["invalid_metadata"])
    return "\n".join(lines) + "\n"


def print_strategy(path, output):
    try:
        data = load_canonical(path)
    except (OSError, ValueError) as error:
        matrix, report = strategic_coverage({}, read_error=f"cannot read {path}: {error}")
    else:
        matrix, report = strategic_coverage(data)
    if output == "markdown":
        print(render_strategy_markdown(matrix, report), end="")
    else:
        if output == "json":
            matrix["outstanding_dependencies"] = report["outstanding_dependencies"]
            matrix["source_errors"] = report["source_errors"]
            matrix["invalid_metadata"] = report["invalid_metadata"]
        print(json.dumps(report if output == "report" else matrix, indent=2))
    return int(report["result"] == "FAIL")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("path", nargs="?", default=DEFAULT)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--register", action="store_true")
    mode.add_argument("--strategy-matrix", choices=("markdown", "json"))
    mode.add_argument("--strategy-report", action="store_true", help="emit diagnostic JSON")
    args = parser.parse_args()
    path = args.path
    if args.strategy_matrix or args.strategy_report:
        return print_strategy(path, args.strategy_matrix or "report")
    errors = validate(path)
    for e in errors:
        print("ERROR:", e)
    with open(path, encoding="utf-8") as f:
        d = json.load(f)
    print("cards.json: %d cards, %d CAPS, %d starter decks: %s" % (
        len(d.get("cards", {})), len(d.get("caps", {})), len(d.get("starters", {})),
        "VALID" if not errors else "%d error(s)" % len(errors)))
    if not errors and args.register:
        reg = register(path)
        print("\nOpen implementation gaps declared by the records:")
        for cid, why in reg["divergent"]:
            print("  divergent  %-20s %s" % (cid, why))
        print("  pending    %s" % ", ".join(reg["pending"]))
        print("  experimental (never rewards, not in starter decks): %s" % ", ".join(reg["experimental"]))
        print("  records with no decision ID yet: %d of %d" % (len(reg["no_decisions"]), len(d["cards"])))
        print("  numbers still in code (params_in_code, CSA-04i): %d — %s" % (len(reg["params_in_code"]), ", ".join(reg["params_in_code"])))
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
