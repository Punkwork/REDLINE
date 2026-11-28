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
        self.assertEqual(len(LIVE["cards"]), 112)
        self.assertEqual(len(LIVE["caps"]), 5)


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

    def test_bad_id_case(self):
        self.assertIn("UPPER_SNAKE_CASE", self.errors(lambda d: d["cards"].update(probe=d["cards"]["PROBE"])))


if __name__ == "__main__":
    unittest.main()
