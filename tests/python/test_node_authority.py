"""NODE-AUTHORITY-001: tests for tools/csa/scan_node_authority.py (Core Rules §8.3 is the only Node definition).

    python3 -m unittest tests/python/test_node_authority.py -v

Each negative test runs the scanner on a temporary copy of the docs; the live repository is never edited.
"""
import os, shutil, sys, tempfile, unittest

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(ROOT, "tools", "csa"))
import scan_node_authority as S


class LiveRepository(unittest.TestCase):
    def test_no_independent_active_node_definitions(self):
        docs, _ = S.scan(ROOT)
        self.assertEqual(docs, [])

    def test_runtime_consumers_are_reported_as_pending(self):
        _, runtime = S.scan(ROOT)
        files = {f["file"] for f in runtime}
        self.assertIn("godot/scripts/core/game.gd", files)        # SAFEHOUSE prompt still offers PATCHWORK
        self.assertIn("godot/data/nulrem_lines.json", files)      # DEAD DROP line still offers healing

    def test_agent_files_identical(self):
        with open(os.path.join(ROOT, "AGENTS.md"), encoding="utf-8") as a, open(os.path.join(ROOT, "CLAUDE.md"), encoding="utf-8") as c:
            self.assertEqual(a.read(), c.read())

    def test_governance_names_the_authority(self):
        with open(os.path.join(ROOT, "AGENTS.md"), encoding="utf-8") as f:
            self.assertIn("**`docs/REDLINE_CORE_RULES.md` §8.3 is the single current definition**", f.read())


class CatchesDrift(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp()
        shutil.copytree(os.path.join(ROOT, "docs"), os.path.join(self.tmp, "docs"))
        for f in ("AGENTS.md", "CLAUDE.md", "README.md"):
            shutil.copy(os.path.join(ROOT, f), self.tmp)

    def tearDown(self):
        shutil.rmtree(self.tmp)

    def append(self, rel, text):
        with open(os.path.join(self.tmp, rel), "a", encoding="utf-8") as f:
            f.write("\n" + text + "\n")

    def rules(self):
        return {f["rule"] for f in S.scan(self.tmp)[0]}

    def test_baseline_copy_is_clean(self):
        self.assertEqual(self.rules(), set())

    def test_stale_uplink_wipe(self):
        self.append("docs/REDLINE_UPLINK_AND_CAPS.md", "- **Wipe:** remove 1 card for 50 CRED.")
        self.assertIn("uplink-wipe", self.rules())

    def test_clinic_restoring_vitae(self):
        self.append("docs/REDLINE_PACING.md", "The Clinic restores 10 VITAE.")
        self.assertIn("clinic-vitae", self.rules())

    def test_black_clinic_event_is_not_the_uplink_clinic(self):
        self.append("docs/REDLINE_PACING.md", "BLACK CLINIC: pay 6 VITAE to apply 1 PATCHWORK.")
        self.assertNotIn("clinic-vitae", self.rules())

    def test_dead_drop_healing(self):
        self.append("docs/REDLINE_PACING.md", "At a DEAD DROP, PATCH UP for +10 VITAE.")
        self.assertIn("dead-drop-healing", self.rules())

    def test_second_node_table(self):
        self.append("docs/REDLINE_ENGINES.md", "| Node | Does |\n|---|---|\n| **Console Lab** | Remove a card. |")
        self.assertIn("second-node-table", self.rules())

    def test_labelled_history_is_allowed(self):
        self.append("docs/REDLINE_UPLINK_AND_CAPS.md", "*(Historical: UPL-006 put Wipe at every Uplink.)*")
        self.assertEqual(self.rules(), set())

    def test_missing_anchor(self):
        p = os.path.join(self.tmp, S.CANON)
        t = open(p, encoding="utf-8").read().replace(S.CANON_ANCHOR, "")
        open(p, "w", encoding="utf-8").write(t)
        self.assertIn("canon-anchor", self.rules())

    def test_missing_canonical_row(self):
        p = os.path.join(self.tmp, S.CANON)
        t = open(p, encoding="utf-8").read().replace('<a id="node-dead-drop"></a>**DEAD DROP**', "**DROP SITE**")
        open(p, "w", encoding="utf-8").write(t)
        self.assertIn("canon-row", self.rules())


if __name__ == "__main__":
    unittest.main()
