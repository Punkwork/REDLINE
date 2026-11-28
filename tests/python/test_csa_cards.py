"""CSA-03 (CONSISTENCY-001a): tests for tools/csa/validate_cards.py, the cards.json validator.

    python3 -m unittest tests/python/test_csa_cards.py -v
"""
import copy, json, os, subprocess, sys, tempfile, unittest

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(ROOT, "tools", "csa"))
import validate_cards as V

with open(V.DEFAULT, encoding="utf-8") as f:
    LIVE = json.load(f)


# CSA-04h: cards with no traceable decision ID after the backfill. Shrink this list as IDs are found;
# a new card record without a decision fails test_every_card_cites_a_decision.
NO_DECISION_YET = set()   # DSY-CARDS-001 (2026-11-28) approved the last six; every card now cites a decision


class StrategicCoverage(unittest.TestCase):
    def setUp(self):
        self.data = {
            "cards": {
                "MULTI": {"strategy": {"recursion": ["payoff"], "momentum": ["support", "enabler"]}},
                "MISSING": {"status": {"design": "approved"}, "decisions": ["DSY-004"]},
                "EMPTY": {"strategy": {}},
                "GENERAL": {"strategy": {}},
            },
            "caps": {"SINGLE": {"strategy": {"momentum": ["enabler"]}}},
        }
        self.reviewed = {("CARDS", "MULTI"), ("CARDS", "GENERAL"), ("CARDS", "MISSING")}

    def test_metadata_validation(self):
        self.assertEqual(V.strategy_errors({"momentum": ["enabler"]}), [])
        self.assertEqual(V.strategy_errors(self.data["cards"]["MULTI"]["strategy"]), [])
        for strategy, message in [
            (None, "must be an object"),
            ([], "must be an object"),
            ({"other": ["enabler"]}, "unknown strategy family"),
            ({"momentum": ["other"]}, "unknown strategy role"),
            ({"momentum": [{}]}, "unknown strategy role"),
            ({"momentum": ["support", "support"]}, "duplicate strategy role"),
            ({"momentum": "enabler"}, "non-empty array"),
            ({"momentum": []}, "non-empty array"),
        ]:
            with self.subTest(strategy=strategy):
                self.assertIn(message, " ".join(V.strategy_errors(strategy)))

    def test_projection_and_diagnostic(self):
        matrix, report = V.strategic_coverage(self.data, reviewed=self.reviewed)
        self.assertEqual(report["canonical_totals"], {"CARDS": 4, "CAPS": 1, "GHOSTWARE": None})
        self.assertEqual(report["classification_counts"], {
            "reviewed": 1, "general_purpose": 1, "provisional": 1, "unreviewed": 2, "invalid": 0,
        })
        self.assertEqual(report["reviewed_records"], 2)
        self.assertEqual(report["unreviewed_records"], 3)
        self.assertEqual(report["classified_records"], 2)
        self.assertEqual(report["result"], "PASS")
        self.assertIn("CSA-07", " ".join(report["outstanding_dependencies"]))
        self.assertEqual(len(report["coverage_gaps"]), 29)
        self.assertEqual(len(matrix["cells"]), 32)
        self.assertEqual({(cell["family"], cell["role"]) for cell in matrix["cells"]},
                         {(family, role) for family in V.STRATEGY_FAMILIES for role in V.STRATEGY_ROLES})
        self.assertEqual({
            (cell["family"], cell["role"]): [(item["category"], item["id"], item["state"])
                                           for item in cell["entries"]]
            for cell in matrix["cells"] if cell["entries"]
        }, {
            ("momentum", "enabler"): [("CARDS", "MULTI", "reviewed"), ("CAPS", "SINGLE", "provisional")],
            ("momentum", "support"): [("CARDS", "MULTI", "reviewed")],
            ("recursion", "payoff"): [("CARDS", "MULTI", "reviewed")],
        })
        records = {record["id"]: record for record in matrix["records"]}
        self.assertIsNone(records["MISSING"]["strategy"])
        self.assertEqual(records["EMPTY"]["strategy"], {})
        self.assertEqual(records["EMPTY"]["state"], "unreviewed")
        self.assertEqual(records["GENERAL"]["state"], "general_purpose")
        matrix["cells"][0]["entries"].pop()
        self.assertFalse(V.matrix_is_consistent(matrix["cells"], matrix["records"]))
        fixture_only, _ = V.strategic_coverage(self.data)
        self.assertEqual(fixture_only["cells"][0]["entries"][0]["state"], "provisional")

    def test_determinism(self):
        matrix, report = V.strategic_coverage(self.data, reviewed=self.reviewed)
        reordered = json.loads(json.dumps(self.data, sort_keys=True))
        reordered["cards"]["MULTI"]["strategy"]["momentum"].reverse()
        next_matrix, next_report = V.strategic_coverage(reordered, reviewed=self.reviewed)
        self.assertEqual(json.dumps((matrix, report)), json.dumps((next_matrix, next_report)))
        self.assertEqual(V.render_strategy_markdown(matrix, report),
                         V.render_strategy_markdown(next_matrix, next_report))

    def test_missing_sources_and_invalid_metadata(self):
        del self.data["caps"]
        self.data["cards"]["MULTI"]["strategy"] = None
        matrix, report = V.strategic_coverage(self.data)
        self.assertEqual(report["result"], "FAIL")
        self.assertEqual(set(report["checks"].values()), {"FAIL"})
        self.assertIn("CAPS", report["source_errors"][0])
        self.assertEqual(report["invalid_metadata"], [
            {"category": "CARDS", "id": "MULTI", "errors": ["strategy must be an object"]},
        ])
        self.assertTrue(all(not cell["entries"] for cell in matrix["cells"]))

    def test_future_ghostware_source(self):
        self.data["ghostware"] = {"SINGLE": {"strategy": {"recursion": ["bridge"]}}}
        matrix, report = V.strategic_coverage(self.data, reviewed={("GHOSTWARE", "SINGLE")})
        self.assertEqual(report["canonical_totals"]["GHOSTWARE"], 1)
        self.assertEqual(report["classification_counts"]["reviewed"], 1)
        self.assertNotIn("CSA-07", " ".join(report["outstanding_dependencies"]))
        self.assertEqual(matrix["cells"][15]["entries"], [
            {"category": "GHOSTWARE", "id": "SINGLE", "state": "reviewed"},
        ])

    def test_cli_and_live_data(self):
        command = [sys.executable, V.__file__]
        result = subprocess.run([*command, "--strategy-report"], capture_output=True, text=True)
        report = json.loads(result.stdout)
        self.assertEqual(result.returncode, int(report["result"] == "FAIL"))
        self.assertEqual(report["canonical_totals"]["CARDS"], len(LIVE["cards"]))
        self.assertEqual(report["canonical_totals"]["CAPS"], len(LIVE["caps"]))
        for output in ("markdown", "json"):
            result = subprocess.run([*command, "--strategy-matrix", output],
                                    capture_output=True, text=True)
            if output == "json":
                self.assertEqual(len(json.loads(result.stdout)["cells"]), 32)
            else:
                self.assertEqual(sum(result.stdout.count(f"| {family} |")
                                     for family in V.STRATEGY_FAMILIES), 32)
        with tempfile.TemporaryDirectory() as directory:
            path = os.path.join(directory, "missing.json")
            result = subprocess.run([*command, "--strategy-report", path], capture_output=True, text=True)
            self.assertEqual(result.returncode, 1)
            self.assertIn("cannot read", json.loads(result.stdout)["source_errors"][0])
            with open(path, "w", encoding="utf-8") as source:
                source.write('{"cards": {}, "cards": {}}')
            result = subprocess.run([*command, "--strategy-report", path], capture_output=True, text=True)
            self.assertEqual(result.returncode, 1)
            self.assertIn("duplicate key", json.loads(result.stdout)["source_errors"][0])
            with open(path, "w", encoding="utf-8") as source:
                self.data["caps"]["SINGLE"]["strategy"] = {"momentum": []}
                json.dump(self.data, source)
            result = subprocess.run([*command, "--strategy-report", path], capture_output=True, text=True)
            self.assertEqual(result.returncode, 1)
            report = json.loads(result.stdout)
            self.assertEqual(report["checks"]["strategy_metadata"], "FAIL")
            self.assertEqual(report["checks"]["canonical_sources"], "PASS")
            self.assertEqual(report["invalid_metadata"][0]["id"], "SINGLE")


class LiveFile(unittest.TestCase):
    def test_live_cards_json_is_valid(self):
        self.assertEqual(V.validate(), [])

    def test_every_card_cites_a_decision(self):
        missing = {k for k, c in LIVE["cards"].items() if not c.get("decisions")}
        self.assertEqual(missing, NO_DECISION_YET)   # fewer is progress: update the list

    def test_counts(self):
        self.assertEqual(len(LIVE["cards"]), 127)   # 112 engine cards + 10 SYNERGY-PLAYTEST-002 + 5 CSA-04f pool records (pending)
        self.assertEqual(len(LIVE["caps"]), 5)

    def test_register(self):
        reg = V.register()
        self.assertEqual(len(reg["pending"]), 5)    # CSA-04f: KEYLOGGER, STASH, QUANTUM CORE, HOT SWAP, JACK OF ALL TRADES (UI-PROTOCOL-001 built the ten playtest cards)
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
        self.assertIn("cannot be a reward", self.errors(lambda d: d["pool_extra"]["ECHO"].update(KEYLOGGER="RARE")))

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
