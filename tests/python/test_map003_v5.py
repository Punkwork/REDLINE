"""MAP-003f: automated assertions for the V5 map generator (Claude Code, 2026-11-27).

    python3 -m unittest tests/python/test_map003_v5.py -v

The full 200-map validation with statistics is prototypes/map/validate_map003_v5.py.
"""
import contextlib, copy, hashlib, io, json, os, sys, unittest

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(ROOT, "prototypes", "map"))
with contextlib.redirect_stdout(io.StringIO()):
    import map003_generator as G
    import validate_map003_v5 as V

SEEDS = range(40)


class V5Generates(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.maps = [G.gen5(s) for s in SEEDS]

    def test_every_seed_accepted(self):
        for m in self.maps:
            self.assertEqual(m["status"], "ok", (m["seed"], m["reason"]))

    def test_every_route_meets_every_constraint(self):
        for m in self.maps:
            errs, st = V.validate(m["rows"], m["edges"])
            self.assertEqual(errs, [], m["seed"])
            self.assertGreater(st["routes"], 1)
            self.assertTrue(set(st["uplinks"]) <= {2, 3})
            self.assertEqual(sum(st["dist"].values()), st["routes"])

    def test_route_rules_directly(self):
        """Second, simpler check of each route with the v1-v4 path walker."""
        for m in self.maps[:10]:
            for p in G.paths(m["rows"], m["edges"]):
                self.assertEqual(len(p), 16)
                self.assertEqual((p[0], p[15]), ("ICE", "BOSS"))
                self.assertIn(p[8], ("ICE", "MINIBOSS"))
                self.assertEqual(p.count("ICE") + p.count("MINIBOSS"), 8)
                self.assertEqual(sum(t in G.V5_TYPES for t in p), 7)
                self.assertIn(tuple(p.count(t) for t in G.V5_TYPES), G.V5_DISTRIBUTIONS)

    def test_distributions_are_exactly_the_approved_five(self):
        # every (U,S,D,L,G) with U in 2..3, others >= 1, sum 7 -- derived independently of the table
        derived = {(u, s, d, l, g) for u in (2, 3) for s in range(1, 7) for d in range(1, 7)
                   for l in range(1, 7) for g in range(1, 7) if u + s + d + l + g == 7}
        self.assertEqual(derived, set(G.V5_DISTRIBUTIONS))
        self.assertEqual(set(V.VALID), set(G.V5_DISTRIBUTIONS))

    def test_miniboss_category_kept_and_identity_absent(self):
        for m in self.maps:
            j = G.v5_json(m)
            nodes = [n for row in j["rows"] for n in row]
            self.assertEqual(sum(n["type"] == "MINIBOSS" for n in nodes), 1)
            self.assertTrue(all(set(n) == {"id", "type", "next"} for n in nodes))   # no identity / ability fields


class V5Deterministic(unittest.TestCase):
    def test_same_seed_same_map(self):
        for s in range(10):
            self.assertEqual(V.fingerprint(G.gen5(s)), V.fingerprint(G.gen5(s)))

    def test_independent_of_hash_randomisation(self):
        seeds = list(range(6))
        here = {s: V.fingerprint(G.gen5(s)) for s in seeds}
        self.assertEqual(here, V.subprocess_fingerprints(seeds, 7))
        self.assertEqual(here, V.subprocess_fingerprints(seeds, 99991))

    def test_different_seeds_differ(self):
        self.assertEqual(len({V.fingerprint(G.gen5(s)) for s in range(20)}), 20)


class V5Bounded(unittest.TestCase):
    def test_failure_is_reported_not_relaxed(self):
        lim = dict(G.V5_LIMITS, skeleton_attempts=2, type_steps=3)
        m = G.gen5(0, lim)
        self.assertEqual(m["status"], "failed")
        self.assertIsNone(m["rows"])
        self.assertIn("not relaxed", m["reason"])
        self.assertLessEqual(m["stats"]["skeleton_attempts"], 2)
        self.assertLessEqual(m["stats"]["type_steps"], m["stats"]["type_attempts"] * (lim["type_steps"] + 1))


class ValidatorCatchesViolations(unittest.TestCase):
    """Each mandatory constraint, broken on purpose, must be reported."""
    def setUp(self):
        m = G.gen5(3)
        self.rows, self.edges = copy.deepcopy(m["rows"]), copy.deepcopy(m["edges"])
        self.assertEqual(V.validate(self.rows, self.edges)[0], [])

    def errs(self):
        return " | ".join(V.validate(self.rows, self.edges)[0])

    def first(self, t, rows=range(1, 15)):
        return next((ri, i) for ri in rows for i, q in enumerate(self.rows[ri]) if q["t"] == t)

    def test_dead_end(self):
        self.edges[5][0] = []
        self.assertIn("dead end", self.errs())

    def test_unreachable(self):
        ri = next(r for r in range(1, 15) if len(self.rows[r]) == 3)
        self.rows[ri].append({"t": "ICE", "c": 0}); self.edges[ri].append([0])
        self.assertIn("unreachable", self.errs())

    def swap_breaks(self, old, new):
        """True if swapping some `old` Node to `new` is reported as a distribution error; every swap is undone."""
        hit = False
        for ri in range(1, 15):
            for q in self.rows[ri]:
                if q["t"] == old:
                    q["t"] = new; hit = hit or "distribution" in self.errs(); q["t"] = old
        return hit

    def test_uplink_count(self):
        self.assertTrue(self.swap_breaks("UPLINK", "SAFEHOUSE"))   # a route drops to 1 Uplink
        self.assertTrue(self.swap_breaks("SIGNAL", "UPLINK"))      # a route reaches 4 Uplinks or loses SIGNAL

    def test_missing_type(self):
        for t in ("SAFEHOUSE", "DEAD DROP", "CONSOLE LAB", "SIGNAL"):
            for ri in range(1, 15):
                for q in self.rows[ri]:
                    if q["t"] == t: q["t"] = "UPLINK" if t != "SAFEHOUSE" else "DEAD DROP"
            self.assertIn("distribution", self.errs(), t)
            self.setUp()

    def test_ice_count(self):
        ri, i = self.first("SAFEHOUSE"); self.rows[ri][i]["t"] = "ICE"
        self.assertIn("ICE Nodes (8 required)", self.errs())

    def test_miniboss_rules(self):
        mb = next(i for i, q in enumerate(self.rows[8]) if q["t"] == "MINIBOSS")
        self.rows[8][mb]["t"] = "ICE"
        self.assertIn("exactly one MINIBOSS", self.errs())
        self.rows[8][mb]["t"] = "MINIBOSS"
        i = next(i for i, out in enumerate(self.edges[7]) if mb in out); self.edges[7][i] = [mb]
        self.assertIn("forces the MINIBOSS", self.errs())

    def test_row_sizes_and_fixed_rows(self):
        self.rows[0][0]["t"] = "UPLINK"
        self.assertIn("row 1 must be a single ICE", self.errs())

    def test_spacing(self):
        # a five-long run of non-ICE: rebuild rows 2-6 of a single forced route
        rows = [[{"t": "ICE"}]] + [[{"t": t}] * 3 for t in
                ["SAFEHOUSE", "DEAD DROP", "CONSOLE LAB", "SIGNAL", "UPLINK", "ICE", "ICE", "MINIBOSS",
                 "ICE", "UPLINK", "SAFEHOUSE", "ICE", "ICE", "ICE"]] + [[{"t": "BOSS"}]]
        rows[8] = [{"t": "MINIBOSS"}, {"t": "ICE"}, {"t": "ICE"}]
        edges = [[[0, 1, 2]]] + [[[0, 1, 2]] * 3 for _ in range(13)] + [[[0]] * 3]
        self.assertIn("consecutive", " | ".join(V.validate(rows, edges)[0]))


class V4Preserved(unittest.TestCase):
    def test_v4_output_unchanged(self):
        """gen4 for seeds 0-59, hashed with the pre-MAP-003f file (commit ae20160)."""
        h = hashlib.sha256()
        for s in range(60): h.update(json.dumps(G.gen4(s)).encode())
        self.assertEqual(h.hexdigest(), "6d3826bb5824f42d39080ba11744df3a7c9fe650fd654268830977ac6a427e5e")


if __name__ == "__main__":
    unittest.main()
