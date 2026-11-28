"""CSA-04f: tests for tools/csa/gen_card_docs.py (generated card views in Card Pools and Rustlers).

    python3 -m unittest tests/python/test_gen_card_docs.py -v

CSA T2 ("generated docs cannot silently diverge") and the reference checks run on temporary copies of
the docs and card data; the live repository is never edited.
"""
import json, os, shutil, sys, tempfile, unittest

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.insert(0, os.path.join(ROOT, "tools", "csa"))
import gen_card_docs as G

POOLS = os.path.join(ROOT, "docs", "REDLINE_CARD_POOLS.md")
RUSTLERS = os.path.join(ROOT, "docs", "REDLINE_RUSTLERS.md")
CARDS = os.path.join(ROOT, "godot", "data", "cards.json")
# PROBE-004a approved text (Master Design), a literal the generated starter rows must show.
PROBE_004A = "Choose one: Target ICE: −2 STR this encounter. OR Target VOID: Reveal all hidden subroutines. Costs 1 additional BW for each PROBE already played on the target ICE this turn."


class Copies(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp()
        self.pools = shutil.copy(POOLS, self.tmp)
        self.rustlers = shutil.copy(RUSTLERS, self.tmp)
        self.cards = shutil.copy(CARDS, self.tmp)

    def tearDown(self):
        shutil.rmtree(self.tmp)

    def run_gen(self, *extra):
        return G.main(["--cards", self.cards, "--docs", self.pools, self.rustlers, *extra])

    def edit(self, path, old, new):
        with open(path, encoding="utf-8") as f: text = f.read()
        self.assertIn(old, text)
        with open(path, "w", encoding="utf-8") as f: f.write(text.replace(old, new, 1))


class LiveRepository(unittest.TestCase):
    def test_blocks_in_step_with_cards_json(self):
        self.assertEqual(G.main(["--check"]), 0)

    def test_every_owner_doc_has_blocks(self):
        for doc in (POOLS, RUSTLERS):
            with open(doc, encoding="utf-8") as f: text = f.read()
            self.assertGreater(len(G.BLOCK.findall(text)), 0, doc)

    def test_starters_show_approved_probe_text(self):
        with open(RUSTLERS, encoding="utf-8") as f: text = f.read()
        blocks = "".join(m.group(4) for m in G.BLOCK.finditer(text))
        self.assertEqual(blocks.count(PROBE_004A), 4)   # all four starter decks carry PROBE

    def test_pending_cards_are_marked(self):
        with open(POOLS, encoding="utf-8") as f: text = f.read()
        self.assertIn("**KEYLOGGER** *(not built yet)*", text)


class Drift(Copies):
    def test_t2_hand_edit_inside_a_block_fails_the_check(self):
        self.edit(self.pools, "| **PASSKEY** | Common |", "| **PASSKEY** | Uncommon |")
        self.assertEqual(self.run_gen("--check"), 1)

    def test_canonical_change_fails_the_check_until_regenerated(self):
        data = json.load(open(self.cards, encoding="utf-8"))
        data["cards"]["PASSKEY"]["bw"] = 2
        json.dump(data, open(self.cards, "w", encoding="utf-8"), ensure_ascii=False, indent="\t")
        self.assertEqual(self.run_gen("--check"), 1)
        self.assertEqual(self.run_gen(), 0)
        self.assertEqual(self.run_gen("--check"), 0)
        with open(self.pools, encoding="utf-8") as f:
            self.assertIn("| **PASSKEY** | Common | PROGRAM — ICEPICK (TUMBLER) | 2 BW, 1 RAM |", f.read())

    def test_invalid_card_id_fails(self):
        self.edit(self.pools, "ids=BATTERING_RAM,", "ids=BATTERING_RAMM,")
        self.assertEqual(self.run_gen("--check"), 1)

    def test_unknown_rustler_fails(self):
        self.edit(self.rustlers, "rustler=ECHO", "rustler=ECH0")
        self.assertEqual(self.run_gen("--check"), 1)

    def test_text_outside_blocks_is_untouched(self):
        with open(self.rustlers, encoding="utf-8") as f: before = f.read()
        self.assertEqual(self.run_gen(), 0)
        with open(self.rustlers, encoding="utf-8") as f: self.assertEqual(f.read(), before)


if __name__ == "__main__":
    unittest.main()


class GhostwareSingleSource(unittest.TestCase):
    """CSA-06/07 (designer 2026-11-28): every Ghostware record appears in a generated block, and the
    generated Ghostware tables cannot drift from cards.json."""
    def docs(self):
        return [str(d) for d in G.DOCS]

    def test_every_ghostware_record_is_shown_once(self):
        import re
        seen = []
        for path in self.docs():
            with open(path, encoding="utf-8") as f:
                for m in re.finditer(r"<!-- GENERATED:ghostware ids=([A-Z0-9_,]+) -->", f.read()):
                    seen += m.group(1).split(",")
        with open(CARDS, encoding="utf-8") as f: ghost = json.load(f)["ghostware"]
        self.assertEqual(sorted(seen), sorted(ghost), "each Ghostware record in exactly one generated block")

    def test_hand_edit_or_record_change_fails_check(self):
        tmp = tempfile.mkdtemp()
        try:
            docs = [shutil.copy(p, tmp) for p in self.docs()]
            cards = shutil.copy(CARDS, tmp)
            args = ["--cards", cards, "--docs", *docs]
            self.assertEqual(G.main(args + ["--check"]), 0)
            up = [d for d in docs if d.endswith("REDLINE_UPGRADES_EVENTS_ESCAPE.md")][0]
            with open(up, encoding="utf-8") as f: text = f.read()
            with open(up, "w", encoding="utf-8") as f: f.write(text.replace("+1 RAM.", "+2 RAM.", 1))
            self.assertNotEqual(G.main(args + ["--check"]), 0, "hand edit in a Ghostware table is caught")
            G.main(args)
            with open(cards, encoding="utf-8") as f: data = json.load(f)
            data["ghostware"]["EXPANDED_MEMORY"]["text"] = "+3 RAM."
            with open(cards, "w", encoding="utf-8") as f: json.dump(data, f)
            self.assertNotEqual(G.main(args + ["--check"]), 0, "a record change is caught until regenerated")
            G.main(args)
            self.assertEqual(G.main(args + ["--check"]), 0)
        finally:
            shutil.rmtree(tmp)
