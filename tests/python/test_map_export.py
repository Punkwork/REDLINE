"""MAP-003f: the game's maps (godot/data/maps/map003_v5.json) are generated, never hand-edited.

    python3 -m unittest tests/python/test_map_export.py -v
"""
import json, os, subprocess, sys, unittest

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TOOL = os.path.join(ROOT, "tools", "map", "export_maps.py")
DATA = os.path.join(ROOT, "godot", "data", "maps", "map003_v5.json")


class MapExport(unittest.TestCase):
    def test_committed_maps_match_the_generator(self):
        r = subprocess.run([sys.executable, TOOL, "--check"], capture_output=True, text=True)
        self.assertEqual(r.returncode, 0, r.stdout + r.stderr)

    def test_every_map_has_the_v5_shape(self):
        d = json.load(open(DATA, encoding="utf-8"))
        self.assertEqual(len(d["maps"]), 20)
        for m in d["maps"]:
            rows = m["rows"]
            self.assertEqual(len(rows), 16)
            self.assertEqual([n["type"] for n in rows[0]], ["ICE"])
            self.assertEqual([n["type"] for n in rows[15]], ["BOSS"])
            ids = {n["id"] for row in rows for n in row}
            for ri, row in enumerate(rows[:-1]):
                for n in row:
                    self.assertTrue(n["next"], "%s is a dead end" % n["id"])
                    self.assertTrue(all(x in ids and x.startswith("r%dn" % (ri + 2)) for x in n["next"]))


if __name__ == "__main__":
    unittest.main()
