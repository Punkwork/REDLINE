"""CSA-04i/j: card rules-text templates (Python side of CardDB.rules_text and CardDB.param).

A record's "text" is a template. "{path}" placeholders read numbers from the record itself:
  {trace_cost}, {pick.boost_cost}, {infect.ROT}     a field, or a field inside one
  {shield}                                          a key missing from the record is read from "params"
  {modes.weaken.amount}                             an array step picks the element whose "id" matches

The Godot loader (scripts/core/cards.gd) renders the same way; tests/python/test_card_text.py and
godot/tests/test_csa04_consumers.gd keep the two in step.
"""
import re

PLACEHOLDER = re.compile(r"\{([A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z0-9_]+)*)\}")
# Reminder text explains a keyword, not this card's numbers: "(Each ROT: −1 STR.)", "(WORM: on your turn …)".
REMINDER = re.compile(r"\((?:Each |[A-Z]{3,}: )[^)]*\)")
# A digit that is not part of a placeholder; a lone 0 ("STR 0", "costs 0 BW") means "none", not a number to tune.
LOOSE_DIGIT = re.compile(r"(?<![\w.])(?!0(?!\d))\d+")


class TemplateError(KeyError):
    pass


def resolve(rec, path):
    """The value at a dotted path in a record (see the module docstring). Raises TemplateError."""
    v = rec
    for seg in path.split("."):
        if isinstance(v, dict):
            if seg in v:
                v = v[seg]
            elif isinstance(v.get("params"), dict) and seg in v["params"]:
                v = v["params"][seg]
            else:
                raise TemplateError(path)
        elif isinstance(v, list):
            hit = [e for e in v if isinstance(e, dict) and e.get("id") == seg]
            if not hit:
                raise TemplateError(path)
            v = hit[0]
        else:
            raise TemplateError(path)
    if isinstance(v, bool) or not isinstance(v, (int, float)):
        raise TemplateError(path)
    return int(v)


def render(template, rec):
    return PLACEHOLDER.sub(lambda m: str(resolve(rec, m.group(1))), template)


def placeholders(template):
    return PLACEHOLDER.findall(template)


def loose_digits(template):
    """Numbers written into the template instead of read from the record."""
    t = REMINDER.sub("", PLACEHOLDER.sub("", template))
    return LOOSE_DIGIT.findall(t)


def rules_text(rec):
    return render(rec.get("text", ""), rec)
