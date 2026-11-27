"""MAP-003f validation harness for the V5 map generator (Claude Code, 2026-11-27).

Independent of the generator's internal bookkeeping: it reads only the rows/edges a map exposes, enumerates
every complete route explicitly and asserts every mandatory constraint on each one.

    python3 prototypes/map/validate_map003_v5.py                 # 200 accepted maps, V4 comparison, determinism
    python3 prototypes/map/validate_map003_v5.py --maps 500 --json out.json
    python3 prototypes/map/validate_map003_v5.py --samples prototypes/map/samples   # write sample maps

Exit status 0 only if every accepted map passes and every determinism check matches.
"""
import argparse, collections, contextlib, hashlib, io, json, os, subprocess, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
with contextlib.redirect_stdout(io.StringIO()):   # the v1 block prints when imported by older revisions
    import map003_generator as G

NONCOMBAT = ("UPLINK", "SAFEHOUSE", "DEAD DROP", "CONSOLE LAB", "SIGNAL")   # order of the distributions
VALID = {(3,1,1,1,1): "3-1-1-1-1", (2,2,1,1,1): "2-2-1-1-1", (2,1,2,1,1): "2-1-2-1-1",
         (2,1,1,2,1): "2-1-1-2-1", (2,1,1,1,2): "2-1-1-1-2"}
COMBAT = ("ICE", "MINIBOSS")
KNOWN = set(NONCOMBAT) | {"ICE", "MINIBOSS", "BOSS"}
MAX_RUN = 4


def validate(rows, edges):
    """Return (errors, stats). errors is a list of strings; empty means every constraint holds on every route."""
    err = []
    def e(msg):
        if len(err) < 50: err.append(msg)
    # --- structure ---
    if len(rows) != 16: return ["expected 16 rows, got %d" % len(rows)], {}
    if len(edges) != 15: return ["expected 15 edge rows, got %d" % len(edges)], {}
    if len(rows[0]) != 1 or rows[0][0]["t"] != "ICE": e("row 1 must be a single ICE Node")
    if len(rows[15]) != 1 or rows[15][0]["t"] != "BOSS": e("row 16 must be a single BOSS Node")
    for ri in range(1, 15):
        if not 3 <= len(rows[ri]) <= 4: e("row %d has %d Nodes (3-4 required)" % (ri + 1, len(rows[ri])))
    for ri, row in enumerate(rows):
        for i, q in enumerate(row):
            t = q["t"]
            if t not in KNOWN: e("row %d Node %d: unknown type %r" % (ri + 1, i, t))
            if t == "MINIBOSS" and ri != 8: e("MINIBOSS outside row 9 (row %d)" % (ri + 1))
            if t == "BOSS" and ri != 15: e("BOSS outside row 16 (row %d)" % (ri + 1))
            if ri == 8 and t not in COMBAT: e("row 9 Node %d is %s (ICE or MINIBOSS only)" % (i, t))
    minis = [i for i, q in enumerate(rows[8]) if q["t"] == "MINIBOSS"]
    if len(minis) != 1: e("row 9 must hold exactly one MINIBOSS, found %d" % len(minis))
    # --- edges: forward-only (row ri -> ri+1 by construction of the format), in range, no duplicates ---
    for ri in range(15):
        if len(edges[ri]) != len(rows[ri]): e("row %d: edge list length mismatch" % (ri + 1)); continue
        for i, out in enumerate(edges[ri]):
            if not out: e("dead end: row %d Node %d has no way forward" % (ri + 1, i))
            if len(set(out)) != len(out): e("row %d Node %d: duplicate links" % (ri + 1, i))
            for j in out:
                if not 0 <= j < len(rows[ri + 1]): e("row %d Node %d links to missing Node %r" % (ri + 1, i, j))
    if err: return err, {}
    # --- reachability: forward from the opening Node, backward from the boss ---
    fwd = [set() for _ in rows]; fwd[0] = {0}
    for ri in range(15):
        for i in fwd[ri]: fwd[ri + 1].update(edges[ri][i])
    bwd = [set() for _ in rows]; bwd[15] = {0}
    for ri in range(14, -1, -1):
        bwd[ri] = {i for i in range(len(rows[ri])) if any(j in bwd[ri + 1] for j in edges[ri][i])}
    for ri in range(16):
        for i in range(len(rows[ri])):
            if i not in fwd[ri]: e("unreachable: row %d Node %d" % (ri + 1, i))
            if i not in bwd[ri]: e("cannot reach the boss: row %d Node %d" % (ri + 1, i))
    # --- Mini-Boss optionality: every Node leading into it also offers a standard ICE Node ---
    mb = minis[0] if len(minis) == 1 else None
    if mb is not None:
        for i, out in enumerate(edges[7]):
            if mb in out and len(out) < 2: e("row 8 Node %d forces the MINIBOSS (no ICE alternative)" % i)
    # --- every complete route ---
    st = {"routes": 0, "uplinks": collections.Counter(), "dist": collections.Counter(), "via_mini": 0,
          "max_run": collections.Counter(), "boss_run5": 0}
    path = []
    def walk(ri, i):
        path.append(rows[ri][i]["t"])
        if ri == 15:
            check(path)
        else:
            for j in edges[ri][i]: walk(ri + 1, j)
        path.pop()
    def check(p):
        st["routes"] += 1
        n = st["routes"]
        if len(p) != 16: e("route %d: %d Nodes" % (n, len(p))); return
        if p[0] != "ICE" or p[15] != "BOSS" or p[8] not in COMBAT: e("route %d: fixed rows wrong %r" % (n, p))
        ice = sum(t in COMBAT for t in p)
        non = sum(t in NONCOMBAT for t in p)
        if ice != 8: e("route %d: %d ICE Nodes (8 required) %r" % (n, ice, p))
        if non != 7: e("route %d: %d non-combat Nodes (7 required) %r" % (n, non, p))
        d = tuple(p.count(t) for t in NONCOMBAT)
        if d not in VALID: e("route %d: non-combat distribution %r not allowed %r" % (n, d, p))
        else: st["dist"][VALID[d]] += 1
        st["uplinks"][d[0]] += 1
        if p[8] == "MINIBOSS": st["via_mini"] += 1
        run = best = 1
        for a, b in zip(p[:14], p[1:15]):                    # rows 1-15; the boss is not an ICE Node
            run = run + 1 if (a in COMBAT) == (b in COMBAT) else 1
            best = max(best, run)
        st["max_run"][best] += 1
        if best > MAX_RUN: e("route %d: %d consecutive Nodes of one kind %r" % (n, best, p))
        if all(t in COMBAT for t in p[11:15]): st["boss_run5"] += 1   # informational: 4 ICE then the boss
    walk(0, 0)
    # independent route count (dynamic programming) must equal the enumeration
    cnt = [1]
    for ri in range(15):
        nxt = [0] * len(rows[ri + 1])
        for i, c in enumerate(cnt):
            for j in edges[ri][i]: nxt[j] += c
        cnt = nxt
    if cnt[0] != st["routes"]: e("route count mismatch: enumerated %d, counted %d" % (st["routes"], cnt[0]))
    if mb is not None:
        if st["via_mini"] == 0: e("no route reaches the MINIBOSS")
        if st["via_mini"] == st["routes"]: e("no route avoids the MINIBOSS")
        # from how many Nodes in rows 1-8 can the Rustler still both reach and avoid the Mini-Boss?
        reach = [[False] * len(r) for r in rows]; avoid = [[False] * len(r) for r in rows]
        for i in range(len(rows[8])): reach[8][i] = i == mb; avoid[8][i] = i != mb
        for ri in range(7, -1, -1):
            for i in range(len(rows[ri])):
                reach[ri][i] = any(reach[ri + 1][j] for j in edges[ri][i])
                avoid[ri][i] = any(avoid[ri + 1][j] for j in edges[ri][i])
        pre = [(ri, i) for ri in range(8) for i in range(len(rows[ri]))]
        st["pre_nodes"] = len(pre)
        st["pre_both"] = sum(reach[a][b] and avoid[a][b] for a, b in pre)
        st["pre_can_avoid"] = sum(avoid[a][b] for a, b in pre)
        st["mini_parents"] = sum(mb in out for out in edges[7])
    # placement: route-weighted sum of row numbers per Node type (routes through a Node = paths in x paths out)
    out_n = [[0] * len(r) for r in rows]; out_n[15][0] = 1
    for ri in range(14, -1, -1):
        for i in range(len(rows[ri])): out_n[ri][i] = sum(out_n[ri + 1][j] for j in edges[ri][i])
    in_n = [[0] * len(r) for r in rows]; in_n[0][0] = 1
    for ri in range(15):
        for i, c in enumerate(in_n[ri]):
            for j in edges[ri][i]: in_n[ri + 1][j] += c
    st["row_sum"] = collections.Counter(); st["type_visits"] = collections.Counter(); st["early"] = collections.Counter()
    for ri, row in enumerate(rows):
        for i, q in enumerate(row):
            w = in_n[ri][i] * out_n[ri][i]
            st["row_sum"][q["t"]] += w * (ri + 1); st["type_visits"][q["t"]] += w
            if 1 <= ri <= 7: st["early"][q["t"]] += w
    return err, st


def fingerprint(m):
    return hashlib.sha256(json.dumps(G.v5_json(m), sort_keys=True).encode()).hexdigest()


def subprocess_fingerprints(seeds, hashseed):
    code = ("import sys,json,contextlib,io;sys.path.insert(0,%r)\n"
            "with contextlib.redirect_stdout(io.StringIO()):\n import validate_map003_v5 as V\n"
            "print(json.dumps({s:V.fingerprint(V.G.gen5(s)) for s in %r}))") % (HERE, list(seeds))
    env = dict(os.environ, PYTHONHASHSEED=str(hashseed))
    out = subprocess.run([sys.executable, "-c", code], env=env, capture_output=True, text=True, check=True)
    return {int(k): v for k, v in json.loads(out.stdout).items()}


def v4_compare(n_seeds):
    """V4 over the same number of candidate seeds: acceptance, time, and its accepted maps checked against MAP-003f."""
    t = time.time(); acc = []
    for s in range(n_seeds):
        g = G.gen4(s)
        if g: acc.append(g)
    dt = time.time() - t
    ok = dead = 0; why = collections.Counter()
    for rows, edges in acc:
        errs, _ = validate(rows, edges)
        if not errs: ok += 1
        kinds = {k for x in errs for k, key in (("dead end", "dead end"), ("Uplink distribution", "distribution"),
                 ("spacing incl. row 1", "consecutive"), ("MINIBOSS forced", "forces the MINIBOSS"),
                 ("cannot reach boss", "cannot reach")) if key in x}
        why.update(kinds or ({"other"} if errs else set()))
        if any(not out for row in edges for out in row): dead += 1
    return {"candidates": n_seeds, "accepted": len(acc), "rate": len(acc) / n_seeds, "seconds": dt,
            "meet_map003f": ok, "with_dead_ends": dead, "maps_by_failure_kind": dict(why.most_common())}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--maps", type=int, default=200)
    ap.add_argument("--start", type=int, default=0)
    ap.add_argument("--max-seeds", type=int, default=20000)
    ap.add_argument("--json")
    ap.add_argument("--samples")
    ap.add_argument("--no-v4", action="store_true")
    a = ap.parse_args()

    t0 = time.time(); gen_time = 0.0; worst = 0.0; accepted = []; rejected = []; seed = a.start
    while len(accepted) < a.maps and seed - a.start < a.max_seeds:
        t = time.time(); m = G.gen5(seed); dt = time.time() - t; gen_time += dt; worst = max(worst, dt)
        (accepted if m["status"] == "ok" else rejected).append(m); seed += 1
    cands = seed - a.start

    failures = []; tot = collections.Counter(); dist = collections.Counter(); up = collections.Counter()
    maxrun = collections.Counter(); per_map_routes = []; per_map_mini = []
    attempts = collections.Counter(); rowsum = collections.Counter(); visits = collections.Counter(); early = collections.Counter()
    t = time.time()
    for m in accepted:
        errs, st = validate(m["rows"], m["edges"])
        if errs: failures.append((m["seed"], errs[:5])); continue
        per_map_routes.append(st["routes"]); per_map_mini.append(st["via_mini"] / st["routes"])
        dist.update(st["dist"]); up.update(st["uplinks"]); maxrun.update(st["max_run"])
        for k in ("routes", "via_mini", "boss_run5", "pre_nodes", "pre_both", "pre_can_avoid", "mini_parents"): tot[k] += st[k]
        tot["maps_with_3_uplink_route"] += st["uplinks"][3] > 0
        tot["maps_all_five_dists"] += len(st["dist"]) == 5
        for k, v in m["stats"].items(): attempts[k] += v
        rowsum.update(st["row_sum"]); visits.update(st["type_visits"]); early.update(st["early"])
    val_time = time.time() - t

    # determinism: regenerate in-process, then in two fresh interpreters with different hash seeds
    det_seeds = [m["seed"] for m in accepted[:25]]
    fp = {s: fingerprint(G.gen5(s)) for s in det_seeds}
    fp_again = {s: fingerprint(G.gen5(s)) for s in det_seeds}
    fp_a = subprocess_fingerprints(det_seeds, 1); fp_b = subprocess_fingerprints(det_seeds, 4242)
    det_ok = fp == fp_again == fp_a == fp_b

    v4 = None if a.no_v4 else v4_compare(cands if cands >= 1000 else 1000)

    R = tot["routes"] or 1
    res = {
        "generator": "V5 (MAP-003f)", "candidates": cands, "accepted": len(accepted), "rejected": len(rejected),
        "rejected_reasons": [m["reason"] for m in rejected][:5], "acceptance_rate": len(accepted) / cands,
        "generation_seconds": round(gen_time, 2), "ms_per_map": round(1000 * gen_time / max(1, cands), 1), "ms_worst_map": round(1000 * worst, 1),
        "validation_seconds": round(val_time, 2), "maps_failing_validation": len(failures), "failures": failures[:5],
        "routes_validated": tot["routes"], "routes_per_map": {"min": min(per_map_routes, default=0),
            "mean": round(sum(per_map_routes) / max(1, len(per_map_routes)), 1), "max": max(per_map_routes, default=0)},
        "routes_by_uplinks": {str(k): v for k, v in sorted(up.items())},
        "routes_by_uplinks_pct": {str(k): round(100 * v / R, 2) for k, v in sorted(up.items())},
        "distribution_routes": {k: dist[k] for k in VALID.values()},
        "distribution_pct": {k: round(100 * dist[k] / R, 2) for k in VALID.values()},
        "maps_with_a_3_uplink_route": tot["maps_with_3_uplink_route"], "maps_with_all_five_distributions": tot["maps_all_five_dists"],
        "minibosses": {"maps_with_exactly_one": len(accepted) - len(failures),
            "routes_via_miniboss_pct": round(100 * tot["via_mini"] / R, 2),
            "per_map_via_pct_min_max": [round(100 * min(per_map_mini, default=0), 1), round(100 * max(per_map_mini, default=0), 1)],
            "row8_nodes_leading_to_it_mean": round(tot["mini_parents"] / max(1, len(per_map_routes)), 2),
            "rows1_8_nodes_that_can_still_avoid_pct": round(100 * tot["pre_can_avoid"] / max(1, tot["pre_nodes"]), 2),
            "rows1_8_nodes_that_can_reach_or_avoid_pct": round(100 * tot["pre_both"] / max(1, tot["pre_nodes"]), 2)},
        "spacing_longest_run_routes": {str(k): v for k, v in sorted(maxrun.items())},
        "placement_by_type": {t: {"per_route": round(visits[t] / R, 2), "mean_row": round(rowsum[t] / visits[t], 2),
            "rows_2_8_pct": round(100 * early[t] / visits[t], 1)} for t in NONCOMBAT + ("ICE",) if visits[t]},
        "info_routes_4_ice_then_boss_pct": round(100 * tot["boss_run5"] / R, 2),
        "generator_attempt_totals": dict(attempts),
        "determinism": {"seeds": len(det_seeds), "in_process": fp == fp_again,
                        "fresh_processes_PYTHONHASHSEED_1_and_4242": fp == fp_a == fp_b, "ok": det_ok},
        "v4": v4, "total_seconds": round(time.time() - t0, 1),
    }
    if v4: res["acceptance_vs_v4"] = "V5 %.1f%% vs V4 %.1f%% (V4 maps also meeting MAP-003f: %d of %d)" % (
        100 * res["acceptance_rate"], 100 * v4["rate"], v4["meet_map003f"], v4["accepted"])
    print(json.dumps(res, indent=1))
    if a.json:
        with open(a.json, "w") as f: json.dump(res, f, indent=1)
    if a.samples:
        os.makedirs(a.samples, exist_ok=True)
        for m in accepted[:4]:
            _, st = validate(m["rows"], m["edges"])
            base = os.path.join(a.samples, "v5_seed_%d" % m["seed"])
            with open(base + ".json", "w") as f: json.dump(G.v5_json(m), f, indent=1)
            with open(base + ".txt", "w") as f:
                f.write("MAP-003f V5, seed %d (regenerate: python3 prototypes/map/map003_generator.py --v5 %d)\n" % (m["seed"], m["seed"]))
                f.write("Columns: index:type; '-> i>j,k' = Node i links to Nodes j and k in the next row.\n\n")
                f.write(G.v5_render(m) + "\n\n")
                f.write("routes %d; Uplinks per route %s; distributions %s; via MINIBOSS %d\nsha256 %s\n" % (
                    st["routes"], dict(sorted(st["uplinks"].items())), dict(sorted(st["dist"].items())), st["via_mini"], fingerprint(m)))
    ok = not failures and det_ok and len(accepted) >= a.maps
    print("RESULT:", "PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
