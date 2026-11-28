"""CSA-04i/j: card rules-text templates and engine parameters.

    python3 -m unittest tests/python/test_card_text.py -v

Checks run on copies of cards.json; the live data is never edited. Expectations are literals from the
approved decisions (PROBE-004a, RUSTLER-005), not read back from the data under test.
"""
import glob, json, os, re, shutil, subprocess, sys, tempfile, unittest

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(ROOT, "tools", "csa"))
import card_text as T
import validate_cards as V

CARDS = os.path.join(ROOT, "godot", "data", "cards.json")
PROBE_004A = "Choose one: Target ICE: −2 STR this encounter. OR Target VOID: Reveal all hidden subroutines. Costs 1 additional BW for each PROBE already played on the target ICE this turn."
BRUTE_FORCE = "Break 1 subroutine on any ICE with STR 4 or less. (+4 TRACE)"   # RUSTLER-005
PARAM_CALL = re.compile(r'CardDB\.param\("([A-Z_]+)", "([A-Za-z_.]+)"')


def load():
    with open(CARDS, encoding="utf-8") as f:
        return json.load(f)


def engine_reads():
    out = set()
    for p in glob.glob(os.path.join(ROOT, "godot", "scripts", "**", "*.gd"), recursive=True):
        with open(p, encoding="utf-8") as f:
            out |= set(PARAM_CALL.findall(f.read()))
    return out


class Renderer(unittest.TestCase):
    def test_paths(self):
        rec = {"trace_cost": 4, "pick": {"str": 2}, "params": {"shield": 3},
               "modes": [{"id": "weaken", "params": {"amount": 2}}]}
        self.assertEqual(T.render("{trace_cost}/{pick.str}/{shield}/{modes.weaken.amount}", rec), "4/2/3/2")
        for bad in ("{missing}", "{pick.nope}", "{modes.reveal.amount}"):
            with self.assertRaises(T.TemplateError):
                T.render(bad, rec)

    def test_loose_digits(self):
        self.assertEqual(T.loose_digits("+{shield} SHIELD."), [])
        self.assertEqual(T.loose_digits("STR 0. Break: 0 BW."), [])                  # a lone 0 is "none"
        self.assertEqual(T.loose_digits("INFECT {infect.ROT} ROT. (Each ROT: −1 STR.)"), [])   # reminder text
        self.assertEqual(T.loose_digits("Draw 2. (+{trace_cost} TRACE)"), ["2"])

    def test_live_text_reads_as_approved(self):
        cards = load()["cards"]
        self.assertEqual(T.rules_text(cards["PROBE"]), PROBE_004A)
        self.assertEqual(T.rules_text(cards["BRUTE_FORCE"]), BRUTE_FORCE)
        self.assertIn("{", cards["BRUTE_FORCE"]["text"], "BRUTE FORCE is stored as a template")


class Wiring(unittest.TestCase):
    def test_every_param_is_read_by_the_engine(self):
        """A named parameter nobody reads would be a number the text shows but the game ignores."""
        cards, reads = load()["cards"], engine_reads()
        unread = []
        for cid, rec in cards.items():
            if rec.get("status", {}).get("implementation") == "pending":
                continue
            for k in rec.get("params", {}):
                if (cid, k) not in reads:
                    unread.append("%s.%s" % (cid, k))
            for m in rec.get("modes", []):
                for k in m.get("params", {}):
                    if (cid, "modes.%s.%s" % (m["id"], k)) not in reads:
                        unread.append("%s.modes.%s.%s" % (cid, m["id"], k))
        self.assertEqual(unread, [])

    def test_every_engine_read_resolves(self):
        cards = load()["cards"]
        for cid, path in engine_reads():
            T.resolve(cards[cid], path)   # raises on a missing number

    def test_core_loop_numbers_live_in_the_record(self):
        """STRIP-001 cards: only the two declared gaps keep numbers in code."""
        d = load()
        core = set(d["core_pool"]) | {c for deck in d["starters"].values() for c in deck}
        in_code = sorted(c for c in core if d["cards"][c].get("params_in_code"))
        self.assertEqual(in_code, ["DEAD_AIR", "RAINBOW_TABLE"])


class Validation(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp()
        self.path = os.path.join(self.tmp, "cards.json")
        self.data = load()

    def tearDown(self):
        shutil.rmtree(self.tmp)

    def errors(self):
        with open(self.path, "w", encoding="utf-8") as f:
            json.dump(self.data, f, ensure_ascii=False)
        return V.validate(self.path)

    def test_live_is_valid(self):
        self.assertEqual(self.errors(), [])

    def test_t1_change_propagates_to_docs_or_fails_the_check(self):
        """CSA T1 + T2: change the number once; the generated docs go stale until regenerated."""
        self.data["cards"]["PROBE"]["modes"][0]["params"]["amount"] = 3
        self.assertEqual(self.errors(), [])
        self.assertIn("−3 STR", T.rules_text(self.data["cards"]["PROBE"]))
        docs = []
        for name in ("REDLINE_CARD_POOLS.md", "REDLINE_RUSTLERS.md"):
            docs.append(shutil.copy(os.path.join(ROOT, "docs", name), self.tmp))
        r = subprocess.run([sys.executable, os.path.join(ROOT, "tools", "csa", "gen_card_docs.py"), "--check",
                            "--cards", self.path, "--docs", *docs], capture_output=True, text=True)
        self.assertEqual(r.returncode, 1, r.stdout + r.stderr)
        self.assertNotIn("usage:", r.stderr)

    def test_literal_number_without_flag_is_rejected(self):
        self.data["cards"]["PULP_SHIELD"]["text"] = "+3 SHIELD."
        self.assertTrue(any("PULP_SHIELD" in e and "instead of reading" in e for e in self.errors()))

    def test_unknown_placeholder_is_rejected(self):
        self.data["cards"]["PULP_SHIELD"]["text"] = "+{sheild} SHIELD."
        self.assertTrue(any("{sheild}" in e for e in self.errors()))

    def test_stale_flag_is_rejected(self):
        self.data["cards"]["PULP_SHIELD"]["params_in_code"] = True
        self.assertTrue(any("remove the flag" in e for e in self.errors()))


if __name__ == "__main__":
    unittest.main()
