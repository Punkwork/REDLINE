"""CSA-04g: the Uplink contract (godot/scripts/core/uplink_contract.gd) stays in step with Core Rules §8.3.

    python3 -m unittest tests/python/test_uplink_contract.py -v

Core Rules §8.3 is the single definition of the Uplink's services and the Clinic (NODE-AUTHORITY-001).
The contract mirrors those values for code; these tests fail if either side changes without the other.
Negative tests run on temporary copies; the live repository is never edited.
"""
import os, re, shutil, tempfile, unittest

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RULES = os.path.join(ROOT, "docs", "REDLINE_CORE_RULES.md")
CONTRACT = os.path.join(ROOT, "godot", "scripts", "core", "uplink_contract.gd")


def uplink_row(rules_text):
    m = re.search(r'^\| <a id="node-uplink"></a>.*$', rules_text, re.M)
    if not m:
        raise AssertionError("Core Rules §8.3 has no Uplink row (#node-uplink)")
    return m.group(0)


def constants(gd_text):
    out = {}
    for name, value in re.findall(r"^const (\w+) := (.+?)\s*(?:#.*)?$", gd_text, re.M):
        out[name] = value.strip()
    return out


def mismatches(rules_text, gd_text):
    """Every way the contract and §8.3 disagree (empty when in step)."""
    row = uplink_row(rules_text)
    c = constants(gd_text)
    services, never = row.split("|")[3], row.split("|")[4]
    out = []
    per = re.search(r"(\d+) CRED per counter", services)
    off = re.search(r"(\d+)% off the total when removing (\d+) or more", services)
    if not per or per.group(1) != c.get("CLINIC_PER_COUNTER"):
        out.append("Clinic price per counter")
    if not off or off.group(1) != c.get("CLINIC_BULK_PERCENT_OFF") or off.group(2) != c.get("CLINIC_BULK_MIN"):
        out.append("Clinic bulk discount")
    if "CORTEX only" not in services or c.get("CLINIC_REMOVES") != '"CORTEX"':
        out.append("Clinic removes CORTEX only")
    if "rounded up" not in services or "ceil(" not in gd_text:
        out.append("Clinic rounds up")
    offered = set(re.findall(r'"(\w+)"', c.get("SERVICES", "")))
    if offered != {"CARDS", "CAPS", "GHOSTWARE", "CLINIC"} or not re.search(r"Buy cards, CAPS and Ghostware", services) or "Clinic" not in services:
        out.append("services")
    refused = set(re.findall(r'"(\w+)"', c.get("NEVER", "")))
    expected_never = {"VITAE": "VITAE", "CARD_REMOVAL": "card removal", "REFACTOR": "REFACTOR", "PATCHWORK": "PATCHWORK", "FUSE": "FUS"}
    for key, words in expected_never.items():
        if (key in refused) != (words in never):
            out.append("never offers " + key)
    if offered & refused:
        out.append("a service is both offered and refused")
    return out


class LiveRepository(unittest.TestCase):
    def test_contract_matches_core_rules(self):
        with open(RULES, encoding="utf-8") as r, open(CONTRACT, encoding="utf-8") as g:
            self.assertEqual(mismatches(r.read(), g.read()), [])

    def test_examples_in_core_rules_follow_the_rule(self):
        # §8.3 states 2 = 45, 3 = 68, 4 = 90; the stated rule must produce them.
        with open(RULES, encoding="utf-8") as f:
            row = uplink_row(f.read())
        for n, price in re.findall(r"(\d) = (\d+)", row):
            n, price = int(n), int(price)
            self.assertEqual(-(-30 * n * 75 // 100), price, "%d counters" % n)


class Drift(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp()
        with open(RULES, encoding="utf-8") as f: self.rules = f.read()
        with open(CONTRACT, encoding="utf-8") as f: self.gd = f.read()

    def tearDown(self):
        shutil.rmtree(self.tmp)

    def test_price_change_in_rules_alone_is_caught(self):
        rules = self.rules.replace("30 CRED per counter", "35 CRED per counter", 1)
        self.assertIn("Clinic price per counter", mismatches(rules, self.gd))

    def test_price_change_in_code_alone_is_caught(self):
        gd = self.gd.replace("const CLINIC_PER_COUNTER := 30", "const CLINIC_PER_COUNTER := 35", 1)
        self.assertIn("Clinic price per counter", mismatches(self.rules, gd))

    def test_adding_removal_to_the_uplink_is_caught(self):
        gd = self.gd.replace('const SERVICES := ["CARDS", "CAPS", "GHOSTWARE", "CLINIC"]', 'const SERVICES := ["CARDS", "CAPS", "GHOSTWARE", "CLINIC", "CARD_REMOVAL"]', 1)
        self.assertTrue(mismatches(self.rules, gd))


if __name__ == "__main__":
    unittest.main()
