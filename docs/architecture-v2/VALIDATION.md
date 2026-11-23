# Baseline and architecture validation — ARCH-V2-001

**Status: NOT YET VERIFIED.** This document defines evidence to collect; it does not claim tests were run.

## Prototype baseline record
| Field | Value |
|---|---|
| Repository | `Punkwork/REDLINE` |
| Prototype branch | `main` |
| Exact prototype commit SHA | **PENDING** |
| Godot version / binary | **PENDING** (project targets 4.3) |
| Renderer | GL Compatibility (verify actual run) |
| Baseline tag | `prototype-v1-final` **NOT CREATED/VERIFIED** |
| OS / environment | **PENDING** |
| Test execution date | **PENDING** |
| Windows hands-on playtest | **NOT CLAIMED** |

## Baseline test commands
From repository root, with Godot 4.3 editor in `$GODOT`:

```bash
"$GODOT" --headless --path godot --editor --import --quit
"$GODOT" --headless --path godot --script res://tests/test_game.gd
"$GODOT" --headless --path godot --script res://tests/test_adp.gd
"$GODOT" --headless --path godot --script res://tests/test_signal_carbon.gd
```

Capture exit code, pass/fail count, warnings, logs, Godot build and commit SHA for each. See `AGENTS.md` and `.github/workflows/godot-validation.yml` for authoritative screenshot fixture commands. For optional simulations, record seed, `SIM` and `SIM_ONLY`. Run display-backed fixtures with isolated `user://` data; do not conflate them with headless tests.

## New architecture acceptance gates
1. Same approved action produces equivalent Game state and logs in old and new presentation.
2. Visual effects never modify gameplay RNG, damage, card movement or turn order.
3. Stable UID targeting survives mutations, inserted ICE, duplicate cards and compiled cards.
4. All pending choices and response queues complete exactly once.
5. Hidden VOID and SIGNAL-001 content never leak; editorial copy guards remain enforced.
6. Rule text and controls meet at least 4.5:1 contrast; reduced-motion and input paths remain usable.
7. One additional corporation skin uses the same encounter scenes without duplicate rules code.
8. CI headless suites pass; display fixtures are checked; Windows packaging and real Windows interaction are reported separately.

## Evidence template
```text
Commit / branch:
Godot binary / version:
OS / renderer / resolution:
Test command:
Exit code / pass / fail:
Logs / artifact path:
Manual interaction verified?:
Known limitations:
Reviewer / date:
```

Do not declare the architecture production-ready until the designer approves the reviewed blueprint and relevant validation evidence.
