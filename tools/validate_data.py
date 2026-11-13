#!/usr/bin/env python3
"""Validate REDLINE game data in godot/data/.

Checks that every file parses, ids are unique, every reference points at something
that exists, decks and pools have the approved sizes, and every effect uses a known op.

Usage:  python3 tools/validate_data.py            (exits 1 if anything is wrong)
"""
import json
import sys
from collections import Counter
from pathlib import Path

DATA = Path(__file__).resolve().parent.parent / "godot" / "data"

# Every effect "op" the engine must implement. Keep in sync with godot/data/README.md.
KNOWN_OPS = {
    "add_black_ice", "add_random_card", "break", "burn_bloatware", "cache", "cap_slots", "copy_virus",
    "deadlock", "discard", "discard_hand", "double_virus", "draw", "draw_stat", "extract",
    "extract_multiplier", "forget", "gain_bw", "gain_cred", "gain_random_cap", "gain_random_ghostware", "heal",
    "ice_gain_str", "ice_pulp_bonus", "ice_str", "ice_str_set", "icepick_str", "infect", "insert",
    "jack_out", "lockdown", "max_vitae", "patchwork", "prevent_void", "pulp", "pulp_direct", "purge",
    "purge_all", "ram", "redirect_insert", "reduce_ice_pulp", "reduce_ice_trace", "remove_all_bloatware",
    "remove_card", "remove_strike", "reward_choices", "shield", "skip_corp_response", "spread_virus",
    "start_encounter", "str_floor", "suppress_abilities", "trace", "trace_block", "trace_halve",
    "trace_reduce_each", "trace_reduce_next", "trace_set", "trade_up", "tutor", "void",
}

APPROVED_COUNTS = {
    "shared_reward_cards": 31,
    "rustler_reward_cards": 9,
    "starter_deck_size": 12,
    "caps": 12,
    "general_ghostware_enabled": 20,
    "reserve_ghostware": 4,
    "events": 9,
    "contracts": 8,
    "patchwork_mods": 12,
    "corp_tier1": 5,
    "corp_tier2": 7,
    "corp_escape_ice": 4,
    "corp_ghostware_set": 3,
}

errors = []


def err(msg):
    errors.append(msg)


def load(name):
    try:
        return json.loads((DATA / name).read_text(encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001 - report any parse failure
        err(f"{name}: cannot parse ({exc})")
        return None


def walk_effects(obj, where):
    """Yield (effect, where) for every effect dict found under 'effects'/'on_break'/'per_counter' keys."""
    if isinstance(obj, dict):
        for key, val in obj.items():
            if key in ("effects", "on_break", "per_counter") and isinstance(val, list):
                for i, eff in enumerate(val):
                    if isinstance(eff, dict) and "op" in eff:
                        yield eff, f"{where}.{key}[{i}]"
            yield from walk_effects(val, f"{where}.{key}")
    elif isinstance(obj, list):
        for i, item in enumerate(obj):
            yield from walk_effects(item, f"{where}[{i}]")


def unique(items, label):
    counts = Counter(x["id"] for x in items)
    for k, n in counts.items():
        if n > 1:
            err(f"{label}: duplicate id '{k}'")
    return set(counts)


def main():
    files = {n: load(n) for n in ["cards.json", "rustlers.json", "ice.json", "caps.json", "ghostware.json",
                                  "patchwork.json", "events.json", "contracts.json", "strains.json", "rules.json"]}
    if errors:
        return report()

    cards = files["cards.json"]["cards"]
    card_ids = unique(cards, "cards")
    fused_ids = set()
    for c in cards:
        if "fused" in c:
            if c["type"] != "SCRIPT":
                err(f"card {c['id']}: FUSE is SCRIPTs only, but type is {c['type']}")
            fused_ids.add(c["fused"]["id"])
        if c["type"] == "PROGRAM" and "ram" not in c:
            err(f"card {c['id']}: PROGRAM without ram")
        if c["type"] != "PROGRAM" and "ram" in c:
            err(f"card {c['id']}: only PROGRAMs use RAM")
    if fused_ids & card_ids:
        err(f"fused ids collide with card ids: {sorted(fused_ids & card_ids)}")

    shared_reward = [c for c in cards if c["owner"] == "shared" and c["pool"] == "reward"]
    if len(shared_reward) != APPROVED_COUNTS["shared_reward_cards"]:
        err(f"shared reward pool has {len(shared_reward)} cards, expected {APPROVED_COUNTS['shared_reward_cards']}")

    strains = {s["id"] for s in files["strains.json"]["strains"]}
    ghost = files["ghostware.json"]["ghostware"]
    ghost_ids = unique(ghost, "ghostware")

    for r in files["rustlers.json"]["rustlers"]:
        total = sum(x["qty"] for x in r["starter_deck"])
        if total != APPROVED_COUNTS["starter_deck_size"]:
            err(f"rustler {r['id']}: starter deck has {total} cards, expected 12")
        for x in r["starter_deck"]:
            if x["card"] not in card_ids:
                err(f"rustler {r['id']}: unknown card '{x['card']}'")
        og = next((g for g in ghost if g["id"] == r["origin_ghostware"]), None)
        if not og or og["pool"] != "origin":
            err(f"rustler {r['id']}: origin ghostware '{r['origin_ghostware']}' missing or not in the origin pool")
        pool = [c for c in cards if c["owner"] == r["id"] and c["pool"] == "reward"]
        if len(pool) != APPROVED_COUNTS["rustler_reward_cards"]:
            err(f"rustler {r['id']}: reward pool has {len(pool)} cards, expected 9")

    ice = files["ice.json"]["ice"]
    ice_ids = unique(ice, "ice")
    for corp in files["ice.json"]["corporations"]:
        refs = []
        for key in ("tier1", "tier2", "escape_ice"):
            refs += corp.get(key, [])
        refs += corp.get("central_node", {}).get("ice_left_to_right", [])
        for layer in corp.get("layers", []):
            refs += layer["ice"]
        for step in corp.get("escape_layout", []):
            refs += step.get("plus", [])
        if corp.get("black_ice"):
            refs.append(corp["black_ice"])
        for ref in refs:
            if ref not in ice_ids:
                err(f"corporation {corp['id']}: unknown ice '{ref}'")
        for gid in corp.get("ghostware_set", []):
            if gid not in ghost_ids:
                err(f"corporation {corp['id']}: unknown ghostware '{gid}'")
        if corp.get("signature_bloatware") and corp["signature_bloatware"] not in card_ids:
            err(f"corporation {corp['id']}: unknown bloatware '{corp['signature_bloatware']}'")
        if corp["id"] != "training":
            if len(corp["tier1"]) != APPROVED_COUNTS["corp_tier1"] or len(corp["tier2"]) != APPROVED_COUNTS["corp_tier2"]:
                err(f"{corp['id']}: tier sizes differ from the approved 5 + 7")
            if len(corp["escape_ice"]) != APPROVED_COUNTS["corp_escape_ice"]:
                err(f"{corp['id']}: expected 4 escape ICE")
            if len(corp["ghostware_set"]) != APPROVED_COUNTS["corp_ghostware_set"]:
                err(f"{corp['id']}: expected 3 Ghostware in its set")
            if len(corp["central_node"]["ice_left_to_right"]) != 3:
                err(f"{corp['id']}: the Central Node should have 3 ICE")
            for gid in corp["ghostware_set"]:
                g = next((x for x in ghost if x["id"] == gid), None)
                if g and g["pool"] != corp["id"]:
                    err(f"{corp['id']}: ghostware '{gid}' should be in pool '{corp['id']}'")
    for i in ice:
        is_main_candidate = i["tier"] in (1, 2, "escape", "training") or i.get("boss_role") == "main"
        has_deadlock = any(e["op"] == "deadlock" for s in i["subroutines"] for e in s["effects"])
        if i["id"] in ("overclock", "hotwire"):  # Training Node supports (locked values)
            continue
        if is_main_candidate and not has_deadlock:
            err(f"ice {i['id']}: can be a main ICE but has no DEADLOCK")
        if i.get("black_ice") and has_deadlock:
            err(f"ice {i['id']}: Black ICE must not have a DEADLOCK")

    caps = files["caps.json"]["caps"]
    unique(caps, "caps")
    if len(caps) != APPROVED_COUNTS["caps"]:
        err(f"caps: {len(caps)}, expected 12")

    enabled_general = [g for g in ghost if g["pool"] == "general" and g.get("enabled", True)]
    reserve = [g for g in ghost if g["pool"] == "reserve"]
    if len(enabled_general) != APPROVED_COUNTS["general_ghostware_enabled"]:
        err(f"ghostware: {len(enabled_general)} enabled general, expected 20")
    if len(reserve) != APPROVED_COUNTS["reserve_ghostware"] or any(g.get("enabled", True) for g in reserve):
        err("ghostware: reserve must hold 4 disabled entries")

    events = files["events.json"]["events"]
    unique(events, "events")
    if len(events) != APPROVED_COUNTS["events"]:
        err(f"events: {len(events)}, expected 9")
    total_weight = sum(e["weight"] for e in events)
    if abs(total_weight - 1.0) > 0.001:
        err(f"events: weights sum to {total_weight:.4f}, expected 1.0")

    if len(files["contracts.json"]["contracts"]) != APPROVED_COUNTS["contracts"]:
        err("contracts: expected 8")
    unique(files["contracts.json"]["contracts"], "contracts")
    mods = files["patchwork.json"]["mods"]
    unique(mods, "patchwork mods")
    if len(mods) != APPROVED_COUNTS["patchwork_mods"]:
        err("patchwork: expected 12 mods")

    rules = files["rules.json"]
    for cid in rules["uplink"]["reserve_pool"]:
        if cid not in card_ids:
            err(f"rules.uplink.reserve_pool: unknown card '{cid}'")

    # Effects: known ops, and references inside effects.
    for fname, data in files.items():
        for eff, where in walk_effects(data, fname):
            op = eff["op"]
            if op not in KNOWN_OPS:
                err(f"{where}: unknown op '{op}'")
            if op == "infect" and eff.get("strain") not in strains:
                err(f"{where}: unknown strain '{eff.get('strain')}'")
            if op == "insert" and eff.get("card") not in card_ids:
                err(f"{where}: unknown card '{eff.get('card')}'")
            if op == "ice_gain_str" and eff.get("target") not in ("self", "others") and eff.get("target") not in ice_ids:
                err(f"{where}: unknown ice target '{eff.get('target')}'")

    return report()


def report():
    if errors:
        print(f"FAILED: {len(errors)} problem(s)")
        for e in errors:
            print("  -", e)
        return 1
    print("OK: all REDLINE data files are valid.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
