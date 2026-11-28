"""CSA-03 (CONSISTENCY-001a): tests for tools/csa/validate_cards.py, the cards.json validator.

    python3 -m unittest tests/python/test_csa_cards.py -v
"""
import copy, json, os, sys, tempfile, unittest

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(ROOT, "tools", "csa"))
import validate_cards as V

with open(V.DEFAULT, encoding="utf-8") as f:
    LIVE = json.load(f)


class LiveFile(unittest.TestCase):
    def test_live_cards_json_is_valid(self):
        self.assertEqual(V.validate(), [])

    def test_counts(self):
        self.assertEqual(len(LIVE["cards"]), 122)   # 112 engine cards + 10 SYNERGY-PLAYTEST-002 records (pending)
        self.assertEqual(len(LIVE["caps"]), 5)

    def test_register(self):
        reg = V.register()
        self.assertEqual(len(reg["pending"]), 10)
        self.assertEqual(sorted(reg["experimental"]), sorted(["MINIMALIST", "SCALPEL", "ZERO_FOOTPRINT", "SMASH_AND_GRAB", "COVER_FIRE", "KILL_CHAIN", "HANDOFF"]))
        self.assertEqual(reg["divergent"], [])   # CSA-04d: PIVOT, the last divergent card, aligned
        self.assertNotIn("PROBE", [c for c, _ in reg["divergent"]])   # CSA-04b: PROBE aligned
        self.assertEqual(LIVE["starters"]["RIOT"].count("PROBE"), 4)   # RIOT-006
        self.assertNotIn("SMASH_AND_GRAB", LIVE["starters"]["RIOT"])


class CatchesMistakes(unittest.TestCase):
    """Each broken copy must be reported; the live file is never edited."""
    def errors(self, mutate=None, raw=None):
        with tempfile.NamedTemporaryFile("w", suffix=".json", delete=False, encoding="utf-8") as f:
            if raw is not None:
                f.write(raw)
            else:
                d = copy.deepcopy(LIVE); mutate(d); json.dump(d, f, ensure_ascii=False)
            path = f.name
        try:
            return " | ".join(V.validate(path))
        finally:
            os.unlink(path)

    def test_wrong_schema(self):
        self.assertIn("schema", self.errors(lambda d: d.update(schema="cards/0")))

    def test_duplicate_id(self):
        text = json.dumps(LIVE, ensure_ascii=False)
        dup = text.replace('"cards": {', '"cards": {"PROBE": {"name": "X"}, ', 1)
        self.assertIn("duplicate key 'PROBE'", self.errors(raw=dup))

    def test_missing_field(self):
        self.assertIn("missing 'text'", self.errors(lambda d: d["cards"]["PROBE"].pop("text")))

    def test_wrong_type(self):
        self.assertIn("'bw' must be int", self.errors(lambda d: d["cards"]["PROBE"].update(bw="0")))

    def test_decimal_number(self):
        self.assertIn("not a whole number", self.errors(lambda d: d["cards"]["PROBE"].update(bw=0.5)))

    def test_unknown_rarity_and_type(self):
        e = self.errors(lambda d: d["cards"]["PROBE"].update(rarity="EPIC", type="SPELL"))
        self.assertIn("unknown rarity", e); self.assertIn("unknown type", e)

    def test_invalid_reference(self):
        self.assertIn("unknown card 'PR0BE'", self.errors(lambda d: d["starters"]["RIOT"].append("PR0BE")))
        self.assertIn("core_pool names unknown card", self.errors(lambda d: d["core_pool"].append("NOPE")))
        self.assertIn("pool_extra ECHO names unknown card", self.errors(lambda d: d["pool_extra"]["ECHO"].update(NOPE="COMMON")))

    def test_invalid_status(self):
        self.assertIn("status must be", self.errors(lambda d: d["cards"]["PROBE"]["status"].update(design="final")))

    def test_experimental_card_in_starter_deck(self):
        self.assertIn("starter cards must be current", self.errors(lambda d: d["starters"]["RIOT"].append("SMASH_AND_GRAB")))

    def test_pending_card_as_reward(self):
        self.assertIn("cannot be a reward", self.errors(lambda d: d["pool_extra"]["ECHO"].update(REPRISE="RARE")))

    def test_experimental_card_in_core_pool(self):
        self.assertIn("core_pool holds experimental", self.errors(lambda d: d["core_pool"].append("SCALPEL")))

    @staticmethod
    def make_divergent(d, card="DEFRAG"):
        """No live card is divergent since CSA-04d, so the negative tests build one."""
        r = d["cards"][card]
        r["status"]["implementation"] = "divergent"
        r["approved_text"] = r["text"] + " (approved)"
        r["divergence"] = "test fixture"
        return r

    def test_divergent_fixture_is_valid(self):
        self.assertEqual(self.errors(lambda d: self.make_divergent(d)), "")

    def test_divergent_without_reason(self):
        self.assertIn("must say why", self.errors(lambda d: self.make_divergent(d).pop("divergence")))

    def test_divergence_on_implemented_record(self):
        self.assertIn("only for divergent", self.errors(lambda d: d["cards"]["DEFRAG"].update(divergence="x")))

    def test_approved_text_matching_text(self):
        def mutate(d):
            r = self.make_divergent(d)
            r["text"] = r["approved_text"]
        self.assertIn("no longer divergent", self.errors(mutate))

    def test_decisions(self):
        self.assertIn("not a decision ID", self.errors(lambda d: d["cards"]["PROBE"].update(decisions=["probe four"])))
        self.assertIn("not recorded", self.errors(lambda d: d["cards"]["PROBE"].update(decisions=["NOSUCH-999"])))

    def test_banned_wording(self):
        self.assertIn("banned wording", self.errors(lambda d: d["cards"]["REPRISE"].update(text="Back to the Archipelago.")))

    def test_bad_id_case(self):
        self.assertIn("UPPER_SNAKE_CASE", self.errors(lambda d: d["cards"].update(probe=d["cards"]["PROBE"])))


if __name__ == "__main__":
    unittest.main()
