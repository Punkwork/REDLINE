# PANOPTICON — DEVELOPMENT LOG
**Initialized:** 2026-11-09  
**Policy:** append dated entries; distinguish reported outcomes from verified tests.

**LOG-001 (2026-11-16):** entries from 2026-11-08 to 2026-11-14 are in `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md`, unchanged. Keep this file under about 60 KB (HANDOFF, "How we work" 6).

## 2026-11-15 — HANDOFF-001 / REJECT-001: shared to-do file, working branch, design sync (Claude)

**Designer decisions (2026-11-15):**
- **HANDOFF-001:** Codex and Claude coordinate through `docs/HANDOFF.md`, a shared list of decided-but-unfinished work with owners and statuses. The repo is the source of truth; the Claude project holds copies. **One working branch: `codex/halcyon-playtest-stabilization`**; changes arrive as pull requests into it. Claude now has write access to the repository.
- **REJECT-001:** REJECT ALL has **one DEADLOCK** (pool DEADLOCK · TRACE 3 · PULP 4, 2 slots), resolving the REEL-001 confusion. Recorded in `REDLINE_ICE_CORP1.md`; **build change not made** (listed for Codex in HANDOFF).
- **VIRUS-001 confirmed:** WORM counters are spent to break; they don't spread. The "copy vs move" note under VECTOR-001 no longer applies.
- **DSY-006 (end-of-run target only):** decks should be **30–35 cards by the end of LUCIDA**.

**Docs added (Claude, written in the Panopticon project 2026-11-15):** `REDLINE_DECK_SYNERGY.md` v0.3 (DSY-001 to DSY-014, PROPOSED), `REDLINE_PACING.md` v0.2 (PACE-001 to PACE-010, PROPOSED), and copies of the designer's `ICE Rules Bible` and `Ice Passive Abilities` Claude Docs as `REDLINE_ICE_RULES_BIBLE.md` and `REDLINE_ICE_PASSIVES.md`. **Docs changed:** `REDLINE_ICE_CORP1.md` (REJECT-001), `REDLINE_PLAYTEST_CHECKLIST.md` v0.1.1 (G1 and G5 targets for 30–35 cards), `REPOSITORY_STRUCTURE.md` (new docs, HANDOFF, working branch).

**Code changes:** none. **Tests run:** none (no Godot in Claude's environment). The proposals' numbers are working values, not tested.

## 2026-11-15 — DSY-001 to DSY-014 and PACE-001 to PACE-010 approved for the next build (Claude)

**Designer decision:** "Approve everything as written", to be implemented in the next build. `REDLINE_DECK_SYNERGY.md` → v1.0 and `REDLINE_PACING.md` → v1.0, every decision marked **APPROVED 2026-11-15**. Numbers remain working values to tune in playtest. Optional and conditional items stay as written: DSY-001b (GHOST +1 DRAW) optional; PACE-003's BOOTING-on-turn-4 only if playtest 2 shows an Opening Node breach before turn 4; PACE-006's safety valves held in reserve.

**Docs amended** (a "Later amendments (deck synergy and pacing)" table added to each, which wins where it conflicts with older section text): Core Rules, Card Pools, Uplink & CAPS, Upgrades/Events/Escape, Rustlers, Engines, ICE Corp 1–3. `REDLINE_PLAYTEST_CHECKLIST.md` → v0.2 (B1, C1, K1 revised; C9–C11, G6–G11 added). `HANDOFF.md`: build work listed for Codex in five synergy steps plus pacing; Claude tasks for scoring the slice and Phase 7 pools.

**Code changes:** none. **Tests run:** none.


## 2026-11-15 — REJECT-001: Use one DEADLOCK on REJECT ALL (Codex)

**Commit reference:** `playtest3-step0` (tag on this step commit).

**Changed:** REJECT ALL has one DEADLOCK in its three-entry pool; BOOTING remains turn 3. Updated opening rules checks and bot timing reporting.

**Interpretations to confirm:** The bot now installs/pre-boosts HUSH for BORROWED CREDENTIALS off-type coverage; stalled simulations are reported separately from deaths. These are harness corrections, not balance changes. Earliest observed opening BREACH was turn 3 for all Rustlers.

**Deferred:** Conditional BOOTING-on-turn-4 and safety valves remain excluded.

**Executed:** official Godot 4.3 Linux; full rules suite followed by the 30-seed sim for each Rustler (seeds 100–129), via `SIM=1 godot --headless --path godot --script res://tests/test_game.gd`.

```text
Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org

  bot: phase=SLICE_DONE vitae=10 trace=16 strikes=0 cred=16 deck=15 steps=28
  opening GENERALIST: earliest BREACH 3
  pulp GENERALIST: per encounter 13.2 incoming (1.7 from Black ICE), 5.8 absorbed by SHIELD, 7.4 to VITAE, 3.5 hits
  sim GENERALIST: 3/30 cleared; deaths by node { "CONSENT WALL": 4, "TERMS & CONDITIONS": 10, "DOORBELL": 13 }; survivors' avg end VITAE 18.7; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  opening ECHO: earliest BREACH 3
  pulp ECHO: per encounter 9.8 incoming (0.0 from Black ICE), 3.2 absorbed by SHIELD, 6.7 to VITAE, 3.0 hits
  sim ECHO: 14/30 cleared; deaths by node { "DOORBELL": 6, "CAPTCHA": 4, "TERMS & CONDITIONS": 6 }; survivors' avg end VITAE 12.9; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  opening RIOT: earliest BREACH 3
  pulp RIOT: per encounter 11.1 incoming (1.9 from Black ICE), 4.1 absorbed by SHIELD, 7.0 to VITAE, 2.9 hits
  sim RIOT: 3/30 cleared; deaths by node { "DOORBELL": 15, "TERMS & CONDITIONS": 10, "CAPTCHA": 2 }; survivors' avg end VITAE 14.0; purges 0 in 0 runs; SHATTER played 67 times in 29 runs
  opening VECTOR: earliest BREACH 3
  pulp VECTOR: per encounter 11.3 incoming (0.1 from Black ICE), 3.6 absorbed by SHIELD, 7.8 to VITAE, 3.2 hits
  sim VECTOR: 7/30 cleared; deaths by node { "CAPTCHA": 5, "TERMS & CONDITIONS": 9, "DOORBELL": 9 }; survivors' avg end VITAE 7.0; purges 22 in 17 runs; SHATTER played 0 times in 0 runs
TESTS: 219 passed, 0 failed
```


## 2026-11-15 — DSY-001, DSY-002, DSY-003, DSY-006: Add footprint pressure, deck analysis and DECOMPILE (Codex)

**Commit reference:** `playtest3-step1` (tag on this step commit).

**Changed:** FOOTPRINT/caps and bands, per-Node bloat TRACE, optional GHOST draw OFF, duplicate-aware draw estimates and key-card previews, COVERAGE/tag density, and guarded full-clear DECOMPILE.

**Interpretations to confirm:** Draw estimates use nominal stage lengths of 5/6/7 Rustler turns for HALCYON/IRONWATCH/LUCIDA. Conditional fallback cards count toward coverage; BORROWED CREDENTIALS requires HUSH and SHATTER requires SLEDGE. Existing TRACE modifiers apply to bloat tax; reported tax is actual TRACE gained. Empty-card reward skips still work.

**Deferred:** Playable IRONWATCH/LUCIDA are outside the slice; their cap values are supported by the analysis API. Deck-editing services outside full-clear rewards are later work.

**Executed:** official Godot 4.3 Linux; full rules suite followed by the 30-seed sim for each Rustler (seeds 100–129), via `SIM=1 godot --headless --path godot --script res://tests/test_game.gd`.

```text
Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org

  bot: phase=SLICE_DONE vitae=10 trace=16 strikes=0 cred=16 deck=15 steps=28
  deck GENERALIST: avg end size 14.07; avg bloat tax paid 0.00 TRACE
  opening GENERALIST: earliest BREACH 3
  pulp GENERALIST: per encounter 13.2 incoming (1.7 from Black ICE), 5.8 absorbed by SHIELD, 7.4 to VITAE, 3.5 hits
  sim GENERALIST: 3/30 cleared; deaths by node { "CONSENT WALL": 4, "TERMS & CONDITIONS": 10, "DOORBELL": 13 }; survivors' avg end VITAE 18.7; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck ECHO: avg end size 14.43; avg bloat tax paid 0.00 TRACE
  opening ECHO: earliest BREACH 3
  pulp ECHO: per encounter 9.8 incoming (0.0 from Black ICE), 3.2 absorbed by SHIELD, 6.7 to VITAE, 3.0 hits
  sim ECHO: 14/30 cleared; deaths by node { "DOORBELL": 6, "CAPTCHA": 4, "TERMS & CONDITIONS": 6 }; survivors' avg end VITAE 12.9; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck RIOT: avg end size 17.20; avg bloat tax paid 0.00 TRACE
  opening RIOT: earliest BREACH 3
  pulp RIOT: per encounter 11.1 incoming (1.9 from Black ICE), 4.1 absorbed by SHIELD, 7.0 to VITAE, 2.9 hits
  sim RIOT: 3/30 cleared; deaths by node { "DOORBELL": 15, "TERMS & CONDITIONS": 10, "CAPTCHA": 2 }; survivors' avg end VITAE 14.0; purges 0 in 0 runs; SHATTER played 67 times in 29 runs
  deck VECTOR: avg end size 14.17; avg bloat tax paid 0.00 TRACE
  opening VECTOR: earliest BREACH 3
  pulp VECTOR: per encounter 11.3 incoming (0.1 from Black ICE), 3.6 absorbed by SHIELD, 7.8 to VITAE, 3.2 hits
  sim VECTOR: 7/30 cleared; deaths by node { "CAPTCHA": 5, "TERMS & CONDITIONS": 9, "DOORBELL": 9 }; survivors' avg end VITAE 7.0; purges 22 in 17 runs; SHATTER played 0 times in 0 runs
TESTS: 233 passed, 0 failed
```


## 2026-11-15 — DSY-007, DSY-008: Add REBOOT engines, SCAN and in-Node card routing (Codex)

**Commit reference:** `playtest3-step2` (tag on this step commit).

**Changed:** REBOOT queues drain only after draws finish; AMP and seven specified cards, SCAN bottom-order choice, in-Node BURN and discard retrieval, HUD reboot estimate, and bot choice handling.

**Interpretations to confirm:** SCAN does not itself reshuffle; selected bottom cards are ordered first-selected-first-drawn when reached. FORCE REBOOT counts even with an empty discard. ROLLING RESTART adds its printed +1 AMP without self-amplification; SHIELD/BW/draw ENGINE outputs gain current AMP. A 128-trigger repeating-chain safeguard prevents unbounded loops. One RIOT bot run stalled at the guard rather than dying; it is reported separately.

**Deferred:** CRON/PROCESS and unbuilt corporation systems remain deferred; AMP support for the existing virus outputs is completed with the UNDERFLOW/virus step.

**Executed:** official Godot 4.3 Linux; full rules suite followed by the 30-seed sim for each Rustler (seeds 100–129), via `SIM=1 godot --headless --path godot --script res://tests/test_game.gd`.

```text
Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org

  bot: phase=SLICE_DONE vitae=10 trace=17 strikes=0 cred=16 deck=15 steps=46
  deck GENERALIST: avg end size 14.23; avg bloat tax paid 0.00 TRACE
  opening GENERALIST: earliest BREACH 3
  pulp GENERALIST: per encounter 14.5 incoming (1.8 from Black ICE), 7.4 absorbed by SHIELD, 7.0 to VITAE, 4.8 hits
  sim GENERALIST: 8/30 cleared; deaths by node { "CONSENT WALL": 3, "TERMS & CONDITIONS": 11, "CAPTCHA": 3, "DOORBELL": 5 }; survivors' avg end VITAE 13.6; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck ECHO: avg end size 14.40; avg bloat tax paid 0.00 TRACE
  opening ECHO: earliest BREACH 3
  pulp ECHO: per encounter 10.7 incoming (0.0 from Black ICE), 3.9 absorbed by SHIELD, 6.8 to VITAE, 3.2 hits
  sim ECHO: 12/30 cleared; deaths by node { "DOORBELL": 11, "TERMS & CONDITIONS": 4, "CAPTCHA": 3 }; survivors' avg end VITAE 10.2; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck RIOT: avg end size 17.30; avg bloat tax paid 0.00 TRACE
  opening RIOT: earliest BREACH 3
  stalled RIOT (3000-step guard, not deaths): { "CAPTCHA": 1 }
  pulp RIOT: per encounter 10.9 incoming (2.2 from Black ICE), 3.9 absorbed by SHIELD, 7.0 to VITAE, 2.8 hits
  sim RIOT: 4/30 cleared; deaths by node { "TERMS & CONDITIONS": 15, "DOORBELL": 8, "CAPTCHA": 2 }; survivors' avg end VITAE 14.5; purges 0 in 0 runs; SHATTER played 81 times in 30 runs
  deck VECTOR: avg end size 14.13; avg bloat tax paid 0.00 TRACE
  opening VECTOR: earliest BREACH 3
  pulp VECTOR: per encounter 11.6 incoming (0.0 from Black ICE), 3.3 absorbed by SHIELD, 8.3 to VITAE, 3.2 hits
  sim VECTOR: 7/30 cleared; deaths by node { "TERMS & CONDITIONS": 10, "DOORBELL": 9, "CAPTCHA": 4 }; survivors' avg end VITAE 7.4; purges 19 in 16 runs; SHATTER played 0 times in 0 runs
TESTS: 244 passed, 0 failed
```


## 2026-11-15 — DSY-011,012: Add CHAIN and HOLD (Codex)

**Commit reference:** `playtest3-step3` (tag on this step commit).

**Changed:** CHAIN tracks successful card plays; PIVOT, COVER FIRE, HANDOFF and KILL CHAIN; HOLD 1 and DEAD MAN’S POCKET HOLD 2; scrollable choices.

**Interpretations to confirm:** HOLD can retain a temporary cached card as ordinary CACHE. CHAIN effects are card-triggered rather than per-turn AMP processes. Bot stalls are reported separately from deaths.

**Deferred:** Ghostware acquisition and CAPS remain absent from the slice; the pocket effect is exercised through the Ghostware state hook.

**Executed:** official Godot 4.3 Linux; full rules suite followed by the 30-seed sim for each Rustler (seeds 100–129), via `SIM=1 godot --headless --path godot --script res://tests/test_game.gd`.

```text
Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org

  bot: phase=SLICE_DONE vitae=2 trace=18 strikes=0 cred=34 deck=15 steps=29
  deck GENERALIST: avg end size 14.50; avg bloat tax paid 0.00 TRACE
  opening GENERALIST: earliest BREACH 3
  stalled GENERALIST (3000-step guard, not deaths): { "DOORBELL": 1 }
  pulp GENERALIST: per encounter 266.4 incoming (259.4 from Black ICE), 260.3 absorbed by SHIELD, 6.1 to VITAE, 45.2 hits
  sim GENERALIST: 12/30 cleared; deaths by node { "TERMS & CONDITIONS": 9, "DOORBELL": 7, "CONSENT WALL": 1 }; survivors' avg end VITAE 15.8; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck ECHO: avg end size 14.23; avg bloat tax paid 0.00 TRACE
  opening ECHO: earliest BREACH 3
  stalled ECHO (3000-step guard, not deaths): { "TERMS & CONDITIONS": 1, "CAPTCHA": 2 }
  pulp ECHO: per encounter 10.4 incoming (0.0 from Black ICE), 3.0 absorbed by SHIELD, 7.3 to VITAE, 3.1 hits
  sim ECHO: 9/30 cleared; deaths by node { "TERMS & CONDITIONS": 5, "CAPTCHA": 4, "DOORBELL": 8, "CONSENT WALL": 1 }; survivors' avg end VITAE 11.4; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck RIOT: avg end size 17.53; avg bloat tax paid 0.00 TRACE
  opening RIOT: earliest BREACH 3
  pulp RIOT: per encounter 10.7 incoming (2.8 from Black ICE), 4.1 absorbed by SHIELD, 6.6 to VITAE, 2.7 hits
  sim RIOT: 12/30 cleared; deaths by node { "TERMS & CONDITIONS": 9, "DOORBELL": 7, "CAPTCHA": 2 }; survivors' avg end VITAE 10.8; purges 0 in 0 runs; SHATTER played 86 times in 30 runs
  deck VECTOR: avg end size 14.20; avg bloat tax paid 0.00 TRACE
  opening VECTOR: earliest BREACH 3
  pulp VECTOR: per encounter 10.0 incoming (0.0 from Black ICE), 2.7 absorbed by SHIELD, 7.3 to VITAE, 2.8 hits
  sim VECTOR: 6/30 cleared; deaths by node { "TERMS & CONDITIONS": 6, "DOORBELL": 14, "CAPTCHA": 4 }; survivors' avg end VITAE 5.7; purges 25 in 23 runs; SHATTER played 0 times in 0 runs
TESTS: 255 passed, 0 failed
```


## 2026-11-15 — DSY-009,010: Add UNDERFLOW OVERKILL and virus cash-outs (Codex)

**Commit reference:** `playtest3-step4` (tag on this step commit).

**Changed:** Negative ICE STR, MARGIN previews, SCALPEL, STACK SMASH, INTEGER UNDERFLOW, CULL and HARVEST; AMP on virus effects.

**Interpretations to confirm:** LOGIC BOMB sets even negative STR to exactly zero. Explicit STR floors prevail. TOLL remains an additional cost when OVERKILL waives the break cost.

**Deferred:** ZEROED has no approved numbers or card definition and remains a later RIOT-pool design. Other-corporation floor ICE are not on this map.

**Executed:** official Godot 4.3 Linux; full rules suite followed by the 30-seed sim for each Rustler (seeds 100–129), via `SIM=1 godot --headless --path godot --script res://tests/test_game.gd`.

```text
Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org

  bot: phase=SLICE_DONE vitae=7 trace=17 strikes=0 cred=16 deck=15 steps=28
  deck GENERALIST: avg end size 14.77; avg bloat tax paid 0.00 TRACE
  opening GENERALIST: earliest BREACH 3
  pulp GENERALIST: per encounter 7.2 incoming (1.1 from Black ICE), 1.6 absorbed by SHIELD, 5.6 to VITAE, 1.9 hits
  sim GENERALIST: 15/30 cleared; deaths by node { "TERMS & CONDITIONS": 11, "DOORBELL": 4 }; survivors' avg end VITAE 16.2; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck ECHO: avg end size 14.33; avg bloat tax paid 0.00 TRACE
  opening ECHO: earliest BREACH 3
  stalled ECHO (3000-step guard, not deaths): { "TERMS & CONDITIONS": 1, "CAPTCHA": 2 }
  pulp ECHO: per encounter 9.8 incoming (0.0 from Black ICE), 2.8 absorbed by SHIELD, 7.0 to VITAE, 3.1 hits
  sim ECHO: 10/30 cleared; deaths by node { "TERMS & CONDITIONS": 6, "CAPTCHA": 5, "DOORBELL": 5, "CONSENT WALL": 1 }; survivors' avg end VITAE 9.1; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck RIOT: avg end size 17.53; avg bloat tax paid 0.00 TRACE
  opening RIOT: earliest BREACH 3
  pulp RIOT: per encounter 10.3 incoming (2.5 from Black ICE), 3.9 absorbed by SHIELD, 6.4 to VITAE, 2.6 hits
  sim RIOT: 12/30 cleared; deaths by node { "TERMS & CONDITIONS": 9, "DOORBELL": 8, "CAPTCHA": 1 }; survivors' avg end VITAE 13.3; purges 0 in 0 runs; SHATTER played 79 times in 30 runs
  deck VECTOR: avg end size 14.30; avg bloat tax paid 0.00 TRACE
  opening VECTOR: earliest BREACH 3
  pulp VECTOR: per encounter 9.3 incoming (0.0 from Black ICE), 2.4 absorbed by SHIELD, 6.9 to VITAE, 2.6 hits
  sim VECTOR: 8/30 cleared; deaths by node { "DOORBELL": 12, "TERMS & CONDITIONS": 6, "CAPTCHA": 4 }; survivors' avg end VITAE 9.0; purges 23 in 20 runs; SHATTER played 0 times in 0 runs
TESTS: 264 passed, 0 failed
```


## 2026-11-15 — DSY-004,005,013: Add SAFEHOUSE COMPILE and corporation pushback hooks (Codex)

**Commit reference:** `playtest3-step5` (tag on this step commit).

**Changed:** SAFEHOUSE COMPILE with ordered effects, combined costs and tags, interactive continuations, CLEAN BUILD; MINIMALIST and ZERO FOOTPRINT; Ghostware effect hooks; FREE TRIAL on the final HALCYON layer.

**Interpretations to confirm:** The explicit shared-tag requirement overrides the contradictory PROBE × PULP SHIELD example. Compilation order is chosen by selecting cards in order. Targeted halves use the selected ICE; costs are prepaid once. SAFEHOUSE compilation replaces healing. Compiled cards burn if either half burns. MINIMALIST waives the full first-break BW action cost. Other-corporation reactive ICE have definitions and tested hooks, not map placement.

**Deferred:** REFACTOR 50-CRED Uplink service, PATCHWORK/FUSE acquisition and modifications, DEDUPLICATOR, Ghostware acquisition, and IRONWATCH/LUCIDA routes are absent from this slice; no acquisition or Uplink flow invented.

**Executed:** official Godot 4.3 Linux; full rules suite followed by the 30-seed sim for each Rustler (seeds 100–129), via `SIM=1 godot --headless --path godot --script res://tests/test_game.gd`.

```text
Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org

  bot: phase=SLICE_DONE vitae=7 trace=13 strikes=0 cred=16 deck=15 steps=28
  deck GENERALIST: avg end size 14.57; avg bloat tax paid 0.00 TRACE
  opening GENERALIST: earliest BREACH 3
  stalled GENERALIST (3000-step guard, not deaths): { "CAPTCHA": 1 }
  pulp GENERALIST: per encounter 137.5 incoming (1.3 from Black ICE), 131.1 absorbed by SHIELD, 6.3 to VITAE, 66.8 hits
  sim GENERALIST: 13/30 cleared; deaths by node { "TERMS & CONDITIONS": 12, "DOORBELL": 4 }; survivors' avg end VITAE 15.8; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck ECHO: avg end size 14.20; avg bloat tax paid 0.00 TRACE
  opening ECHO: earliest BREACH 3
  stalled ECHO (3000-step guard, not deaths): { "TERMS & CONDITIONS": 1, "CAPTCHA": 3 }
  pulp ECHO: per encounter 80.7 incoming (0.0 from Black ICE), 73.5 absorbed by SHIELD, 7.2 to VITAE, 26.7 hits
  sim ECHO: 8/30 cleared; deaths by node { "TERMS & CONDITIONS": 6, "DOORBELL": 7, "CAPTCHA": 4, "CONSENT WALL": 1 }; survivors' avg end VITAE 10.2; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck RIOT: avg end size 17.47; avg bloat tax paid 0.00 TRACE
  opening RIOT: earliest BREACH 3
  pulp RIOT: per encounter 9.9 incoming (2.0 from Black ICE), 3.7 absorbed by SHIELD, 6.2 to VITAE, 2.7 hits
  sim RIOT: 10/30 cleared; deaths by node { "DOORBELL": 8, "TERMS & CONDITIONS": 10, "CAPTCHA": 2 }; survivors' avg end VITAE 16.6; purges 0 in 0 runs; SHATTER played 77 times in 29 runs
  deck VECTOR: avg end size 14.10; avg bloat tax paid 0.00 TRACE
  opening VECTOR: earliest BREACH 3
  stalled VECTOR (3000-step guard, not deaths): { "TERMS & CONDITIONS": 1 }
  pulp VECTOR: per encounter 10.1 incoming (0.0 from Black ICE), 2.8 absorbed by SHIELD, 7.4 to VITAE, 2.9 hits
  sim VECTOR: 5/30 cleared; deaths by node { "TERMS & CONDITIONS": 6, "DOORBELL": 13, "CAPTCHA": 5 }; survivors' avg end VITAE 8.2; purges 23 in 20 runs; SHATTER played 0 times in 0 runs
TESTS: 278 passed, 0 failed
```


## 2026-11-15 — PACE-003,005,007,008: Add pacing mechanics and prepare HALCYON PLAYTEST 3 (Codex)

**Commit reference:** `playtest3-pacing` (tag on this step commit).

**Changed:** DEADLOCK ×N progress for paid/card/WORM breaks; independent ESCALATE counters for TRACE/DISCARD/FORGET; reward need icons and visible draw chance; Tier 1 one-layer route; tier-aware reward odds; +50% reserves; version/label 0.3.0-playtest.3 / HALCYON PLAYTEST 3; post-merge-only Windows export; updated playtest guide and nine new UI fixtures. Final regression review also completed AMP for SILENT PARTNER/PAIN TOLERANCE, amplified card text, compiled fallback coverage, and Node/run state resets.

**Interpretations to confirm:** All four slice rows are Opening/Tier 1 (ICE Corp 1 §5.0 and Pacing §7); retain each Node’s first layer and remove later layers, without rebalance. FREE TRIAL remains Tier 2 data/trigger only after this cut, superseding its temporary Step 5 placement. 15 ×1.5 CRED rounds up to whole 23. No existing ICE receives an unspecified ×N or ESCALATE assignment; controlled fixtures exercise both. Cards outside the DRILL/HULL/COVERAGE definitions have no misleading role label. REBOOT resolves rack effects in installation order; ROLLING RESTART gains a fixed one AMP rather than amplifying its own AMP production. A finite repeating-trigger guard prevents recursive draw loops from hanging the app. Numeric GHOST thresholds override contradictory RIOT starter prose: 15 is in HALCYON GHOST. Compiled effects resolve against the board in order; a conditional break half with no eligible subroutine does nothing, so a preceding STR reduction can enable it.

**Deferred:** No conditional BOOTING/safety-valve changes. Tier 2 map placement, other corporations, Uplink/REFACTOR, PATCHWORK/FUSE, Ghostware acquisition/DEDUPLICATOR and CAPS remain deferred as listed in HANDOFF. Phase 7 HULL pools, ZEROED and manual BREACH WORK scoring retain their existing owners. Windows export happens after merge; Windows launch/human playtest have not been run.

**Executed:** official Godot 4.3 Linux; full rules suite followed by the 30-seed sim for each Rustler (seeds 100–129), via `SIM=1 godot --headless --path godot --script res://tests/test_game.gd`.

```text
Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org

  bot: phase=SLICE_DONE vitae=7 trace=8 strikes=0 cred=26 deck=15 steps=24
  deck GENERALIST: avg end size 15.37; avg bloat tax paid 0.00 TRACE
  opening GENERALIST: earliest BREACH 3
  stalled GENERALIST (3000-step guard, not deaths): { "CAPTCHA": 1 }
  pulp GENERALIST: per encounter 181.2 incoming (0.0 from Black ICE), 175.8 absorbed by SHIELD, 5.4 to VITAE, 89.4 hits
  sim GENERALIST: 29/30 cleared; deaths by node {  }; survivors' avg end VITAE 16.2; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck ECHO: avg end size 14.80; avg bloat tax paid 0.00 TRACE
  opening ECHO: earliest BREACH 3
  pulp ECHO: per encounter 14.5 incoming (0.0 from Black ICE), 5.2 absorbed by SHIELD, 9.3 to VITAE, 4.4 hits
  sim ECHO: 20/30 cleared; deaths by node { "TERMS & CONDITIONS": 5, "CAPTCHA": 4, "CONSENT WALL": 1 }; survivors' avg end VITAE 8.8; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck RIOT: avg end size 18.20; avg bloat tax paid 0.00 TRACE
  opening RIOT: earliest BREACH 3
  pulp RIOT: per encounter 9.6 incoming (0.8 from Black ICE), 4.1 absorbed by SHIELD, 5.6 to VITAE, 2.8 hits
  sim RIOT: 24/30 cleared; deaths by node { "TERMS & CONDITIONS": 3, "CAPTCHA": 2, "DOORBELL": 1 }; survivors' avg end VITAE 18.0; purges 0 in 0 runs; SHATTER played 18 times in 12 runs
  deck VECTOR: avg end size 14.87; avg bloat tax paid 0.00 TRACE
  opening VECTOR: earliest BREACH 3
  pulp VECTOR: per encounter 12.5 incoming (0.0 from Black ICE), 4.2 absorbed by SHIELD, 8.3 to VITAE, 3.6 hits
  sim VECTOR: 20/30 cleared; deaths by node { "CAPTCHA": 5, "TERMS & CONDITIONS": 5 }; survivors' avg end VITAE 11.1; purges 12 in 12 runs; SHATTER played 0 times in 0 runs
TESTS: 310 passed, 0 failed
```


## 2026-11-15 — UI-004: horizontal card-choice menus (Codex)

**Request:** First Windows playtest showed HOLD and Generalist READY RIG cards wrapping vertically, hiding most choices. Display the cards horizontally.

**Changed:** Replaced the shared choice menu's HFlowContainer with an HBoxContainer and explicitly enabled horizontal scrolling. All choice cards remain in one row; the full height fits above the scrollbar. This also fixes other menus using the same helper.

**Verification:** Godot 4.3 full rules suite: 310 passed, 0 failed. The display-backed playtest-3 script passes with zero failures, including horizontal alignment/full-height checks for HOLD and READY RIG, an overflowing READY RIG fixture, and scrolling until its final card is fully visible. Ten fixture screenshots render.

**Delivery:** Feature branch `codex/horizontal-choice-menus`, targeting `codex/halcyon-playtest-stabilization`. The existing Windows ZIP remains unchanged until this fix is merged and the stabilization workflow exports it.


## 2026-11-16 — ZEROED-001: ICE STR floors at 0; ZEROED keyword, once per ICE; ROT-001 doc sync (Claude)

**Designer decisions (2026-11-16):**
- **ZEROED-001 (APPROVED):** "I think 0 str is a good bottom … it results in too much confusion and counting for the player." ICE STR can't go below 0; DSY-009's UNDERFLOW is withdrawn and ROT keeps its "minimum 0". A reduction past 0 is lost; spare ROT counters keep an ICE at 0 if it gains STR. MARGIN and OVERKILL stay (the game shows MARGIN).
- **ZEROED keyword (APPROVED), "once per ICE":** a card's ZEROED bonus triggers if it takes target ICE from above 0 to 0. Each ICE can be ZEROED once per encounter; the first drop to 0 from any cause uses it up, so the ZEROED card has to land last. Floored ICE (DEADBOLT, SYNAPSE BARRIER, AMNESIA) and ICE starting at 0 can't be ZEROED. The "any cause" reading is Claude's write-up for the designer to confirm.
- **Cards (PROPOSED):** NULL POINTER replaces INTEGER UNDERFLOW (target ICE at 0 STR: break 2 subroutines, BURNED); RIOT ZEROED examples FLATLINE (ZEROED: −4 TRACE), KNOCKOUT (ZEROED: break 1), SECOND WIND (ZEROED: +1 BW).
- **ROT-001 sync:** remaining SIGYL labels in Card Pools, Rustlers, ICE Corp 1–3, Upgrades and Engines changed to TUMBLER; non-slice TUMBLERS still need slot counts.

**Docs changed:** `REDLINE_DECK_SYNERGY.md` v1.1 (§0, §5.2, §5.3 rewritten, new §5.3a ZEROED, §7, §9.2, §10, §11, §12); Core Rules §5.3, §5.7 and amendments; Rustlers, Pacing amendments; HANDOFF (build item for Codex: revert negative STR from `playtest3-step4`, add ZEROED flag). **Code changes:** none. **Tests:** none.

## 2026-11-16 — ZEROED-001 cards approved; TUMBLE-001; LOG-001; Codex handoff (Claude)

**Designer decisions (2026-11-16):**
- **ZEROED-001 cards (APPROVED):** "Approved for all those card changes you made." NULL POINTER replaces INTEGER UNDERFLOW; FLATLINE, KNOCKOUT and SECOND WIND join RIOT's pool (`REDLINE_DECK_SYNERGY.md` §9.2).
- **TUMBLE-001 (APPROVED):** "if a subroutine is broken, any unbroken subroutines slide 'tumble' into (its) place." Written up in Core Rules §5.4: a broken TUMBLER subroutine leaves the pool; the slots after it shift back; the next unbroken subroutine tumbles into the last slot, active at once; rotation skips broken subroutines and stops once every unbroken one is showing. Replaces "broken stays broken… rotates out and back in", and removes the REEL-001 confusion at its source. Two readings for the designer to confirm (HANDOFF, Waiting): a tumbled-in subroutine is active at once; and any drop to 0 uses up an ICE's ZEROED.
- **LOG-001:** this log is split. Entries from 2026-11-08 to 2026-11-14 moved unchanged to `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md`; the live log is kept under about 60 KB so the Claude project copy can be rewritten in one pass.

**Docs changed:** Core Rules (§5.4, amendments), ICE Rules Bible (TUMBLER), ICE Corp 1 and Pacing (amendments), Deck Synergy (§9.2, §12), HANDOFF (a "Start here (Codex)" block listing today's build work in order; ZEROED-001, ZEROED-001 cards and TUMBLE-001 rows; two Waiting rows; LOG-001 rule). **Code changes:** none. **Tests:** none.

## 2026-11-16 — ZEROED-001 and TUMBLE-001 readings confirmed (Claude)

**Designer decision:** "Confirmed on both." (1) Any drop to 0 STR, from any source, uses up an ICE's one ZEROED; the bonus only comes from a card that prints ZEROED (Synergy §5.3a rule 2, Core Rules §5.3). (2) A TUMBLER subroutine that tumbles into a slot is active at once: breakable that turn, and it fires in that turn's Corporation Response if unbroken (Core Rules §5.4). Both readings were already written this way; the two WAITING rows in HANDOFF are closed. **Code changes:** none. **Tests:** none.


## 2026-11-17 — ZEROED-001: Restore STR floor and track once-per-ICE ZEROED (Codex)

**Commit tag:** `zeroed-tumble-step1`.

**Changed:** Restore STR floor and track once-per-ICE ZEROED

**Interpretations to confirm:** Positive STR floors also constrain LOGIC BOMB; its displayed STR stays at the floor and it cannot consume ZEROED. Loss of RELAY discards any resulting non-ROT deficit so later gains rise from zero. These readings preserve the explicit floor and no-hidden-debt rules.

**Tests:** Godot 4.3 full rules suite and 30 seeds (100–129) for each Rustler. Turns measure all non-stalled encounters; cleared-run turns measure survivors only. Stalls remain separate from deaths.

```text
sim GENERALIST: 29/30 cleared; deaths by node {  }; survivors' avg end VITAE 16.2; turns per non-stalled encounter 2.84; avg cleared-run turns 9.8
sim ECHO: 20/30 cleared; deaths by node { "TERMS & CONDITIONS": 5, "CAPTCHA": 4, "CONSENT WALL": 1 }; survivors' avg end VITAE 8.8; turns per non-stalled encounter 4.06; avg cleared-run turns 12.9
sim RIOT: 24/30 cleared; deaths by node { "TERMS & CONDITIONS": 3, "CAPTCHA": 2, "DOORBELL": 1 }; survivors' avg end VITAE 18.0; turns per non-stalled encounter 3.19; avg cleared-run turns 10.5
sim VECTOR: 20/30 cleared; deaths by node { "CAPTCHA": 5, "TERMS & CONDITIONS": 5 }; survivors' avg end VITAE 11.1; turns per non-stalled encounter 3.69; avg cleared-run turns 13.1
TESTS: 320 passed, 0 failed
```
