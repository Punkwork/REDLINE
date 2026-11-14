# PANOPTICON (repo: REDLINE) — Handoff for Codex

**Written:** 2026-11-14 (America/Toronto) by Claude, for the next coding agent (Codex).
**Scope:** the Godot 4.3 HALCYON vertical slice in `godot/`, plus the design docs in `docs/` it implements.

---

## 1. Branch and commit

| Item | Value |
|---|---|
| Repository | `github.com/Punkwork/REDLINE` (game is named PANOPTICON; repo and file names keep REDLINE) |
| Working branch | **`docs/simplified-redesign-sync`** (open **PR #2** → `main`) |
| Code baseline this handoff describes | `a75b907cbce8752d18874546672e8145783a3e89` — "Status: repo location and latest build" (2026-11-14 09:32) |
| This handoff | committed on top of `a75b907` on the same branch (see `git log -1 -- godot/CODEX_HANDOFF.md`) |
| `main` | `03fc312` — docs only; **no Godot project on `main`** (`godot/` is an empty `.gitkeep`) |

Other remote branches (not the current build):

- `docs/simplified-design` (`c42adc5`, open **PR #1** → `main`) — earlier docs + data. **Not an ancestor of PR #2**; the two PRs have diverged and will likely conflict if both are merged.
- `dev/training-node` (`61c1a8b`, 2026-11-12) — an earlier Godot prototype (training node, SyN modal). **Superseded** by BUILD-001 ("build anew"); reference only.
- `backup/pre-authoritative-docs-2026-11-10` — archival.

Start with:

```bash
git fetch origin docs/simplified-redesign-sync
git checkout docs/simplified-redesign-sync
```

## 2. Changed files

No game source was changed in the session that wrote this handoff; it was an audit plus a verification run. The only file added is this one:

- `godot/CODEX_HANDOFF.md` (new)

Here is what the working branch changes relative to `main` (549 files, +17,947 / −480). About 93% of the files are NUL/REM voice assets:

**Godot project (`godot/`)**
- `project.godot` — Godot 4.3, GL Compatibility, 1600×900, main scene `res://scenes/Main.tscn`
- `export_presets.cfg` — "Windows Desktop" → `../build/PANOPTICON_HALCYON_slice.exe` (`build/` is git-ignored)
- `scenes/Main.tscn`
- `scripts/core/game.gd` (~1,415 lines) — the rules engine and run state machine (phases `MAP`, `READY_RIG`, `PLAYER`, `CHOICE`, `REWARD`, `DEEPER`, `SAFEHOUSE`, `SLICE_DONE`, `DEAD`)
- `scripts/core/cards.gd` — `CardDB`: card definitions for all four Rustlers' starters and pools
- `scripts/core/ice.gd` — ICE definitions (FORTRESS / TUMBLER / VOID, subtypes, passives)
- `scripts/core/nulrem.gd` — NUL/REM line selection by trigger
- `scripts/ui/main.gd` (~1,439 lines) — the whole UI, built in code; `scripts/ui/icon.gd` draws the icons
- `data/nulrem_lines.json` — 263 NUL/REM verses mapped to triggers
- `audio/nulrem/NR-*.ogg` (+ `.import`) and `audio/nulrem/manifest.json` — voiced lines (VOICE-001)
- `icon.svg`
- `tests/test_game.gd` — headless rules tests plus an optional bot balance sim
- `tests/shot.gd`, `tests/shot_reel.gd`, `tests/shot_rustlers.gd` — screenshot smoke scripts (need a display)

**Tools:** `tools/export_nulrem.py` (Bible → `nulrem_lines.json`), `tools/voice_nulrem.py` (TTS → `.ogg`)

**Docs (`docs/`):** new `REDLINE_CORE_RULES.md` (**the rules authority**), `REDLINE_ICE_CORP1/2/3.md`, `REDLINE_CARD_POOLS.md`, `REDLINE_RUSTLERS.md`, `REDLINE_UPLINK_AND_CAPS.md`, `REDLINE_UPGRADES_EVENTS_ESCAPE.md`, `REDLINE_ENGINES.md`, `REDLINE_PLAYTEST_CHECKLIST.md`, `REDLINE_UI_NULREM_Design_For_Claude.md`. Also updated: Bible, Current Status, Dev Log, Master Design, Rule Review 126, Core Design & Worldbuilding, Repository Structure.

Latest feature commits on the branch, newest first: VIRUS-001 WORM (`37292de`, `0c0c649`), VECTOR-001 PATIENT ZERO (`1c324a8`), REEL-001 TUMBLER slot reels + RUN-001 END RUN (`eb181a7`), PULP-002 PULP curves (`f9facea`), NAME-002 + DRAW-001 DRAW 6 (`55da1ba`), RIOT-002/003/004, ECHO-001..004, GHOST-011, PURGE-001, UI-002, BUILD-003 (all four Rustlers), PASSIVE-001, VOICE-001, BUILD-002 (`976226a`, the first HALCYON slice).

## 3. Test runs and results (run 2026-11-14, against `a75b907`)

Environment: Linux x86_64, official **Godot v4.3.stable.official.77dcf97d8** (`Godot_v4.3-stable_linux.x86_64`).

| # | Command (run from repo root) | Result |
|---|---|---|
| 1 | `godot --headless --path godot --import` | exit 0, no errors or warnings; working tree still clean afterwards |
| 2 | `godot --headless --path godot --script res://tests/test_game.gd` | **exit 0 — `TESTS: 134 passed, 0 failed`** |
| 3 | `SIM=1 godot --headless --path godot --script res://tests/test_game.gd` | exit 0, 134/134. Bot sim results below |
| 4 | `SHOT_DIR=/tmp/shots xvfb-run -a -s "-screen 0 1600x900x24" godot --rendering-driver opengl3 --path godot --script res://tests/<shot\|shot_reel\|shot_rustlers>.gd` | all exit 0, 32 PNGs written (but see known issue 1: the VECTOR shots `r2`/`r3` don't show their intended states). The only log noise is ALSA "no sound card" messages, which come from the container and are harmless |

The 21 test groups in `test_game.gd`: opening_node, shield_and_pulp, trace_strikes, captcha_discard, boost_installed, void_reveal, detainer_rules, passives, rustlers, purge, shatter, pulp_curves, end_run, patient_zero, worm, extraction_bonus, rainbow_and_toolbelt, spam_and_filter, cloak_reactive, go_deeper_keeps_programs, full_slice_path.

**Bot balance sim (30 seeds, 100–129, per Rustler; the bot plays every card it can, so these numbers are pessimistic):**

| Rustler | Cleared | Main killers | Avg PULP to VITAE / encounter |
|---|---|---|---|
| GENERALIST | 10 / 30 | DOORBELL 9, TERMS & CONDITIONS 8 | 6.7 |
| ECHO | 6 / 30 | CAPTCHA 13, DOORBELL 8 | 8.2 |
| VECTOR | 5 / 30 | CAPTCHA 18, DOORBELL 6 | 9.9 (12 PURGEs in 11 runs) |
| RIOT | 1 / 30 | TERMS & CONDITIONS 15, DOORBELL 9 | 7.9 (SHATTER played 70× in 28 runs) |

VECTOR rose from 2/30 in the 2026-11-14 status note to **5/30**, which is consistent with the later PATIENT ZERO and WORM commits. The other three match the status note.

Not run: a Windows export or a live Windows UI playtest. `docs/REDLINE_PLAYTEST_CHECKLIST.md` (61 checks) has not been executed against this build.

## 4. Known issues

1. **`tests/shot_rustlers.gd` broke when VECTOR-001 landed, and its screenshots are misleading.** Step 0 injects INJECT, SCRAMBLER and RUNTIME_ERROR straight into VECTOR's hand and calls `play_card` on each. Since VECTOR-001, though, `enter_node` puts VECTOR into `phase = "CHOICE"` (`pending.kind = "patient_zero"`), so every `play_card` returns false and is silently ignored. The three injected cards pile on top of the 6-card draw. That leaves an artificial **9-card hand**, and `r2_vector_virus.png` and `r3_card_break.png` don't show the states their names claim. Fix: resolve PATIENT ZERO first (`g.choose_ice(...)`), and `assert` on `play_card`'s return value. Verified headlessly: phase=CHOICE, draw_size=6, hand 6 → 9, all three plays returned false.
1a. **The hand row has no room to spare (latent UI bug).** `hand_row` in `scripts/ui/main.gd` (around lines 169–174) is a fixed 1090 px `HBoxContainer` at x = 244, and it fits only about 6–7 cards. Real hands can reach 7 or more: the first-turn +1-card program, net-positive draw cards like ROAR (0 BW, Draw 2), STIM PATCH, GHOST STEP or MIRROR, and SPAM/Bloatware added to hand. Past about 7 cards, the extra cards render under the END TURN button and the pile counters overlap the card text (the shot artifact above shows exactly this).
2. **`test_full_slice_path` asserts very little.** It passes when the bot reaches either `SLICE_DONE` or `DEAD`, so it only proves that the run terminates. With seed 10 the GENERALIST bot dies (`phase=DEAD vitae=0 trace=32 strikes=2`). Balance therefore has no test guard.
3. **Bot sim results are printed only.** There is no threshold, so a balance regression would not fail CI. There is also no CI at all.
4. **The status doc is partly stale.** `docs/REDLINE_CURRENT_STATUS.md` still says "As of: 2026-11-09" at the top. Its evidence matrix says "Headless tests 50/50" (the suite now has 134 checks), and older sections still treat the Python archive as the gameplay reference.
5. **ROT-001 rename is incomplete in the docs.** SIGYL still appears in the ICE, Card Pools, Rustlers, Bible, Master Design and other docs. In code it appears only in two comments (`ice.gd:4`, `cards.gd:155`), so no code change is needed.
6. **PR #1 and PR #2 have diverged.** `docs/simplified-design` is not an ancestor of `docs/simplified-redesign-sync`. Merging both to `main` will need a deliberate choice; PR #2 is the superset that matters for the build.
7. **The voice assets bloat the repo.** About 500 `.ogg` and `.import` files are committed directly, with no Git LFS. This is acceptable for now, but it will keep growing.
8. **The `.import` files are committed.** They are tracked alongside the assets. Godot regenerates them, so an import on a different Godot version can cause churn.

## 5. Unresolved design decisions (owner: designer — do not decide these in code)

- **REJECT ALL's two DEADLOCKs:** should TUMBLERs show a DEADLOCK total, or should REJECT ALL have only one DEADLOCK?
- **ICE Rules Bible audit**, and **reward-card refinement**.
- **Syncing doc copies** between the repo `docs/` and the Claude "Panopticon" project, which is the source of the PR #2 docs.
- **In-world name VOID vs CORTEX** (NAME-001 made the mechanical damage CORTEX).
- **CRON Rustler name**; details of **ENG-001 to ENG-005**.
- **NUL/REM origin and the First Signal fragments.**
- **Licensing of quoted and pastiche lines** in the NUL/REM verses, and of the voiced audio, before any public build.
- **Merge plan for PR #1 / PR #2** into `main`.
- **What to do with `dev/training-node`:** archive it or delete it.

The rules authority is `docs/REDLINE_CORE_RULES.md`. Slice ICE values are in `docs/REDLINE_ICE_CORP1.md` §5.0. Where older Master Design entries conflict, Core Rules §15 supersedes them. Do not change locked values to make tests or the bot pass.

## 6. Recommended next tasks for Codex (in priority order)

1. **Repair `tests/shot_rustlers.gd` (known issue 1)** so the VECTOR shots resolve PATIENT ZERO before playing cards and fail loudly when a play is rejected. Then **make the hand row adapt (known issue 1a)**: scale or overlap the cards when they exceed the width, for example by shrinking `custom_minimum_size` or fanning them with negative separation. Keep it clear of the END TURN / END RUN column and the pile counters. Add a screenshot state for a deliberate 9–10-card hand to verify.
2. **Add CI.** Add a GitHub Actions workflow that downloads Godot 4.3, runs `--import`, then runs `tests/test_game.gd` headless and fails on a non-zero exit. Optionally run the shot scripts under `xvfb-run` and upload the PNGs as artifacts.
3. **Strengthen the tests.** Split `test_full_slice_path` into (a) a termination check and (b) a deterministic seed that must reach `SLICE_DONE`. Add an opt-in sim floor, for example "GENERALIST ≥ N/30", that is reported but not blocking until the designer sets targets.
4. **Prepare for the designer playtest.** Produce the Windows export (`PANOPTICON_HALCYON_slice.exe`) and record the results of `docs/REDLINE_PLAYTEST_CHECKLIST.md` against it.
5. **Next slice features (after the designer confirms scope):** CAPS, Uplinks and PATCHWORK, as listed in the 2026-11-13 handoff. Implement from `REDLINE_UPLINK_AND_CAPS.md` and `REDLINE_UPGRADES_EVENTS_ESCAPE.md`.
6. **Housekeeping:** update the header and evidence matrix of `REDLINE_CURRENT_STATUS.md` (the test count is now 134), finish the ROT-001 SIGYL → TUMBLER doc pass, and consider moving `godot/audio/**` to Git LFS.

## 7. Working conventions in this repo

- Each commit carries the decision ID it implements, for example `VIRUS-001: …`, and appends the decision to `docs/REDLINE_DEVELOPMENT_LOG.md`.
- Don't mark anything implemented or tested without reproducible evidence (`docs/REPOSITORY_STRUCTURE.md` ground rule 4).
- `game.gd` is UI-free and fully testable headless. Keep rules there and keep presentation in `scripts/ui/`.


## 8. Codex follow-up — 2026-11-14 (latest engineering handoff)

This follow-up supersedes known issues 1/1a and the stale test-count part of issue 4 above. Work is on `codex/halcyon-playtest-stabilization`, based on `8a7dad9`; original code/rules baseline remains unchanged except for UI presentation.

- **QA-HALCYON-001:** screenshot fixture resolves PATIENT ZERO first, checks every card play and expected state, and fails on rejected actions or PNG-write failures.
- **UI-003:** readable cards scroll inside the bounded hand area; all cards remain reachable. Scroll range is recalculated after deferred layout and position survives refresh. Counters no longer share a long overflowing line. Automated display/input checks cover hands of 6/7/9/10/16 cards, actual mouse wheel and card clicks.
- **CI-001:** workflow verifies import, 134 rules checks and all four screenshot scripts; push builds export a Windows artifact with the guide/checklist. Hosted success must be verified separately on Actions.
- **Verified locally:** Godot 4.3 Linux; import and rules 134/134; all screenshot scripts; large-hand input checks; Windows export generation. Bot results reproduce 10/30 GENERALIST, 6/30 ECHO, 5/30 VECTOR, 1/30 RIOT. No rules or card-value changes.
- **Still pending:** real Windows runtime/playtest, subjective readability/audio/difficulty, remaining original handoff issues and open decisions. `docs/HALCYON_PLAYTEST_GUIDE.md` distinguishes applicable checks from unimplemented full-game features.
- **Merge correction:** PR #1 contains a separate heist implementation and JSON/assets absent from PR #2, so “PR #2 is the superset” above must not be interpreted as a verified code-superset claim. Keep PR #1 for explicit review; no PR was merged.

The exact changed files and final revision are available in the stabilization PR. Continue from that revision after checking whether Claude or the designer has made newer changes.
