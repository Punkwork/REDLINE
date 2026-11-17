# PANOPTICON — DEVELOPMENT LOG
**Initialized:** 2026-11-09  
**Policy:** append dated entries; distinguish reported outcomes from verified tests.

**LOG-001 (2026-11-16):** entries from 2026-11-08 to 2026-11-14 are in `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md`, unchanged. Keep this file under about 60 KB (HANDOFF, "How we work" 6).

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

## 2026-11-17 — VIS-001: visual language "The Friendly Lie" handed to Codex (Claude)

**Designer decision:** direction B chosen from three explorations (A Phosphor, B The Friendly Lie, C Watchtower): "I do really like the B option the friendly lie … I think this is a more suitable direction." Further requests in the same session: one encounter screen per corporation with its own background and palette; Rustlers draw 6 cards (maximum hand size not decided); show how the friendly face breaks and what full TRACE looks like; give ICE a personality that flips from cheery to lethal; put the mascots into the encounter screen; hand it to Codex.

**Docs added:** `REDLINE_VISUAL_LANGUAGE.md` (Part 1 brief, Part 2 design, Part 3 build steps VIS-001a–g); `docs/visual/reference/` (10 PNGs), `docs/visual/backgrounds/` (4 placeholder JPGs), `docs/visual/mascots/` (9 SVGs). **Atomic Salvage deprecated (designer):** "I would deprecate that atomic salvage look." A deprecation note heads `REDLINE_UI_NULREM_Design_For_Claude.md` §1. §2.10 records that VIS-001 replaces the look of `REDLINE_UI_NULREM_Design_For_Claude.md` (Atomic Salvage) but keeps its requirements (drag-to-ICE chips, BW slits, no clipped text, REEL-001, END RUN, CRED meter, NUL/REM personality). **HANDOFF:** VIS-001 row (Codex, TO DO), a WAITING row (hand size, lethal threshold, proposal silhouettes). **Code changes:** none. **Tests:** none.

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


## 2026-11-17 — ZEROED-001-cards: Replace INTEGER UNDERFLOW with NULL POINTER and add RIOT ZEROED cards (Codex)

**Commit tag:** `zeroed-tumble-step2`.

**Changed:** Replace INTEGER UNDERFLOW with NULL POINTER and add RIOT ZEROED cards

**Interpretations to confirm:** None.

**Tests:** Godot 4.3 full rules suite and 30 seeds (100–129) for each Rustler. Turns measure all non-stalled encounters; cleared-run turns measure survivors only. Stalls remain separate from deaths.

```text
sim GENERALIST: 29/30 cleared; deaths by node {  }; survivors' avg end VITAE 16.2; turns per non-stalled encounter 2.84; avg cleared-run turns 9.8
sim ECHO: 20/30 cleared; deaths by node { "TERMS & CONDITIONS": 5, "CAPTCHA": 4, "CONSENT WALL": 1 }; survivors' avg end VITAE 8.8; turns per non-stalled encounter 4.06; avg cleared-run turns 12.9
sim RIOT: 24/30 cleared; deaths by node { "TERMS & CONDITIONS": 3, "CAPTCHA": 2, "DOORBELL": 1 }; survivors' avg end VITAE 18.0; turns per non-stalled encounter 3.19; avg cleared-run turns 10.5
sim VECTOR: 20/30 cleared; deaths by node { "CAPTCHA": 5, "TERMS & CONDITIONS": 5 }; survivors' avg end VITAE 11.1; turns per non-stalled encounter 3.69; avg cleared-run turns 13.1
TESTS: 331 passed, 0 failed
```


## 2026-11-17 — TUMBLE-001: Remove broken TUMBLER subs and tumble immediately active replacements (Codex)

**Commit tag:** `zeroed-tumble-step3`.

**Changed:** Remove broken TUMBLER subs and tumble immediately active replacements

**Interpretations to confirm:** None.

**Tests:** Godot 4.3 full rules suite and 30 seeds (100–129) for each Rustler. Turns measure all non-stalled encounters; cleared-run turns measure survivors only. Stalls remain separate from deaths.

```text
sim GENERALIST: 25/30 cleared; deaths by node { "CAPTCHA": 2, "TERMS & CONDITIONS": 1 }; survivors' avg end VITAE 16.2; turns per non-stalled encounter 3.09; avg cleared-run turns 9.2
sim ECHO: 17/30 cleared; deaths by node { "TERMS & CONDITIONS": 9, "CAPTCHA": 3, "CONSENT WALL": 1 }; survivors' avg end VITAE 9.5; turns per non-stalled encounter 3.91; avg cleared-run turns 12.6
sim RIOT: 25/30 cleared; deaths by node { "CAPTCHA": 4, "TERMS & CONDITIONS": 1 }; survivors' avg end VITAE 15.2; turns per non-stalled encounter 3.14; avg cleared-run turns 10.9
sim VECTOR: 20/30 cleared; deaths by node { "CAPTCHA": 6, "TERMS & CONDITIONS": 4 }; survivors' avg end VITAE 10.7; turns per non-stalled encounter 3.61; avg cleared-run turns 12.9
TESTS: 352 passed, 0 failed
```

**TUMBLE comparison with Step 2 (same seeds/policy):** clears GENERALIST 29→25, ECHO 20→17, RIOT 24→25, VECTOR 20→20. Turns per non-stalled encounter: GENERALIST 2.84→3.09, ECHO 4.06→3.91, RIOT 3.19→3.14, VECTOR 3.69→3.61. GENERALIST stalls at the action guard rose from 1 to 2; these are not deaths. The bot takes the first shared reward, so the new RIOT reward cards are exercised by deterministic card tests rather than normally drafted by this policy.

**UI verification:** all six display-backed scripts pass, including actual SCAN/CULL choices, horizontal HOLD/READY RIG access, ZEROED target highlighting and marker, tumble motion, immediate breakability during animation, and settled slots. Existing negative-STR and opening-rotation assertions were updated in place. Stable subroutine IDs remain for labels/history; broken entries are filtered out of the circulating pool.

**Candidate requested by designer:** “give me a build I can download.” The existing CI export gate now also permits this exact feature branch; it still excludes other feature branches and PR events. The candidate remains version 0.3.0-playtest.3 and displays ZEROED + TUMBLE. Its ZIP includes BUILD_COMMIT.txt. No merge or direct push to stabilization is performed.


## 2026-11-17 — VIS-001a: fixed Rustler theme and corporation skin resources (Codex)

**Commit tag:** `vis-001a`. Added DM Sans variable font (400/500/700 UI weights), Space Mono regular/bold, both SIL OFL licenses, fixed toner/paper/highlighter Rustler theme, and HALCYON/IRONWATCH/LUCIDA skin resources. HALCYON is selected for the slice; the other corporations are data only. Runtime copies of the supplied backgrounds and mascot SVGs are packaged under Godot assets so exports do not depend on files outside res://.

**Interpretations to confirm:** only HALCYON has supplied hostile background art; the other two resources leave that texture unset rather than reusing HALCYON art. Corporate fonts and palettes are isolated from the invariant Rustler theme.

**Validation:** Godot 4.3 editor import and script/resource parsing. No gameplay data or values changed. ZEROED/TUMBLE from PR #9 were integrated into this feature branch first; stabilization itself is unchanged.


## 2026-11-17 — VIS-001b: encounter scaffold and paper hand (Codex)

**Commit tag:** `vis-001b`. Added a 1600×1000 encounter presentation inside the existing main controller: corporate app background, node/TRACE tags, reserve and deck data, fixed zine HUD, response strip, stationary NUL/REM note, RIG/RACK strip, END TURN and END RUN. Existing map/reward/choice flows remain with the controller. Six 146×218 paper cards use hard shadows and highlights; 7+ fan without changing deck or hand limits. Hover, wheel and arrow browsing bring each card forward. Bloatware uses the corporate font, rounded white body and red header.

**Interpretations to confirm:** long card rules progressively reduce the art placeholder and font size to retain all rule text; full text also remains available in inspection/tooltips. Extremely large hands keep readable individual cards and use fan browsing, rather than imposing a cap. BW slits represent spending from the left; numeric BW remains authoritative for bonuses.

**Validation:** Godot 4.3 import and display-backed encounter render, including six actual game cards. This step establishes layout; mascot/scan replacement follows in VIS-001c. No gameplay values changed.


## 2026-11-17 — VIS-001c: mascot silhouettes and independent scan tags (Codex)

**Commit tag:** `vis-001c`. Recreated COOKIE WALL banner/cookie, CAPTCHA widget/grid/eye, DOORBELL pill/lens and AUTO-RENEW credit card. Added simple proposed ACCEPT ALL pill, REJECT ALL link, TERMS OF SERVICE document, CONSENT FORM clipboard and HOUSE CALL silhouette. Separate face features trace the supplied SVG coordinates. Primary corporate buttons represent DEADLOCKs; scan tags retain exact rule text, states, progress, hidden pool counts, passive rules and virus actions. Existing reel/tumble presentation is reused. Hidden effects remain hidden rather than being disclosed by decoration.

**Interpretations to confirm — proposed copy (cheery / wary / lethal):** ACCEPT ALL: “Make yourself at home!” / “We noticed you hesitating.” / “YOUR CONSENT IS ASSUMED.” REJECT ALL: “You may change your preferences.” / “Are you absolutely sure?” / “THERE IS NO OPT OUT.” TERMS OF SERVICE: “A few little terms before we begin!” / “You haven't read the fine print.” / “YOU ALREADY AGREED.” CONSENT FORM: “Your choices matter to us!” / “We saved your preferences. All of them.” / “CONSENT IS MANDATORY.” HOUSE CALL: “Your technician is on the way!” / “Please stay where you are.” / “WE KNOW YOU'RE HOME.” FREE TRIAL (fallback for existing test data): “Try us. No strings attached!” / “Your trial is almost over.” / “YOU CANNOT CANCEL.” Proposal shapes follow the spec's table; final illustration remains out of scope.

**Validation:** Godot 4.3 parsing and display-backed render checked against reference 08. Rule chips are independent of the corporate face and wording. Mascot/scan columns scroll only when the rule content needs more space, preserving text. No gameplay changes.


## 2026-11-17 — VIS-001d: per-ICE mood ladder and threat wording (Codex)

**Commit tag:** `vis-001d`. Mood is computed from the actual next-response effects and broken state: cheery, wary, lethal, then knocked out on BREACH. Black ICE and Mask off force lethal. The main scene exposes `lethal_pulp_threshold` (default 5) for tuning. Facial features, panel colors/corners, speech and price-sticker wording follow mood; rule wording and values do not. New tumbled entries are remembered for the current turn; biggest visible PULP is red in both scan and response. Card-choice previews also use the paper card component.

**Interpretations to confirm:** the PULP threshold applies to the largest individual subroutine, not the sum of an ICE's PULP, to reproduce reference 08 (AUTO-RENEW 1+2+3 remains cheery) and 09 (incoming CAPTCHA PULP 6 becomes lethal). Any positive CORTEX qualifies. Hidden rules remain “? HIDDEN”; random curve values remain “PULP ?”, even when the mascot telegraphs danger. Red rule chips use toner text rather than white for 4.5:1 contrast.

**Validation:** code/resource parsing and state-based mood calculations; the final VIS-001g fixtures exercise the real turn-1/turn-3 board. No rules, card stats or corporation values changed.


## 2026-11-17 — VIS-001e: Cracking, strike disclosure and Mask off (Codex)

**Commit tag:** `vis-001e`. TRACE/strike state drives the app background and corporate edges; the Rustler theme stays fixed. Added a one-time checking-on-you toast, background-only glitch bands, the PAST 50% tag and NUL/REM countdown. First strike displays the hostile “We see you.” modal and a corporate TRACER card, then returns to Cracking; strike 2+ keeps the hostile background and square red/black mascots. The reserve meter and actual post-strike TRACE remain visible.

**Interpretations to confirm:** Cracking persists after strike 1 even if TRACE is reduced below 20, since the Friendly definition requires no strikes. The modal shows the real post-strike TRACE of 20 in the HUD rather than faking 40; its copy describes the strike and inserted TRACER. The toast lasts 3 seconds; the modal lasts 2.5 seconds or until dismissed. SPAM's proposed footer is “Recommended for you.” A red rule chip uses toner text for contrast. All distortion stays behind opaque text panels.

**Validation:** Godot 4.3 parser; state changes read Game.trace/strikes and never insert cards or Black ICE themselves. Only the existing game rules cause those changes. Live-state fixture screenshots follow in VIS-001g.


## 2026-11-17 — VIS-001f: live drag targets, mascot motion and reduced motion (Codex)

**Commit tag:** `vis-001f`. Added installed-Icepick drag targets with legality/cost tooltips, card drag previews and dashed hand gaps, VOID pupil tracking, and WATCHER's actual TRACE warning. The existing break API accepts an optional selected Icepick; omitted selection still uses the cheapest legal pick. Added cheery bob/blinks, wary brows, lethal shake/glow, response lunges, break flinch/strike-through, knockout slide and scan peel, background cross-fade, strike-card flight and Mask-off transition. Reduced motion is persistent and available on both selection and encounter screens; it removes ambient/reel motion, flashes and typing without shortening response timing.

**Interpretations to confirm:** FORTRESS bob period is 3.6 s; VOID amplitude is 0.3 px; TUMBLER fidget is ±0.35°. Card snaps are linear 90 ms. The scan's knockout peel moves/tilts without fading its rules, retaining readability. Strike flight is 350 ms and toast entry is 180 ms. Cosmetic blink randomness uses a separate generator, never Game's RNG. WATCHER shows 0 additional TRACE for ECHO or active DECOY SIGNAL. Existing reel glass is omitted over the new scan text. These are presentation choices, not approved rule changes.

**Validation:** Godot 4.3 import, display render, full rules suite **357 passed, 0 failed**. Five new rules regressions cover explicit Icepick selection, unchanged automatic selection/cost, incompatible/missing pick, and insufficient BW; invalid drops spend nothing. No gameplay numbers changed. Display interaction and screenshot fixtures are checked in VIS-001g.


## 2026-11-17 — VIS-001g: live fixtures, readability and interaction regression (Codex)

**Commit tag:** `vis-001g`. Added seven phone-review PNG fixtures: friendly turn 1, wary/lethal turn 3, Cracking, Strike 1, Mask off, DOORBELL CAM card drag and eight-card hand. Updated the existing large-hand test in place for fan browsing and real last-card clicks at 6/7/8/9/10/16 cards. Added native card and selected-Icepick drag checks, actual strike/TRACER/Black ICE checks, tunable moods, hidden VOID rules, reduced-motion timing, BREACH mood and full authored-card text fit. All 112 authored card definitions fit their rule text. Retained ZEROED target borders and paper inspection; response chips flash with the firing rule. CI runs all seven display scripts at a fitting desktop size. The guide/status are updated in place; HANDOFF is the sole task list. Audio was muted during final visual checks at the designer's request; no audio assets or dialogue were changed.

**Interpretations to confirm:** The turn-3 fixture advances two real responses and resolves DISCARD normally. The real conveyor has PULP 6 in slot 1 and a new TRACE 3 in slot 2 after breaking S4; it is not rearranged to force mockup 09's slots. Fixture preparation uses granted cards/BW, and the eight-card hand is deliberately constructed, not a starting-deck claim. Three-mascot boards scale silhouettes to 80% while retaining full-size scans. Longer scans scroll vertically and the response strip scrolls horizontally; hand cards never shrink. Long NUL/REM notes fit by reducing type to a minimum of 8 px. Red buttons/Bloatware headers use toner rather than pale text for contrast. Proposed wording and silhouette choices in VIS-001c remain unapproved.

**Validation:** Godot 4.3 imports; full rules suite **357 passed, 0 failed**. Seven display-backed scripts pass; Friendly Lie has **170 checks, 0 failures**. Large-hand and playtest 2/3 interaction tests report zero failures. Minimum five-second response timing is checked with reduced motion enabled. Thirty seeds per Rustler exactly match the pre-VIS ZEROED/TUMBLE results (including two GENERALIST stalls; not deaths):

```text
sim GENERALIST: 25/30 cleared; deaths by node { "CAPTCHA": 2, "TERMS & CONDITIONS": 1 }; survivors' avg end VITAE 16.2
sim ECHO: 17/30 cleared; deaths by node { "TERMS & CONDITIONS": 9, "CAPTCHA": 3, "CONSENT WALL": 1 }; survivors' avg end VITAE 9.5
sim RIOT: 25/30 cleared; deaths by node { "CAPTCHA": 4, "TERMS & CONDITIONS": 1 }; survivors' avg end VITAE 15.2
sim VECTOR: 20/30 cleared; deaths by node { "CAPTCHA": 6, "TERMS & CONDITIONS": 4 }; survivors' avg end VITAE 10.7
TESTS: 357 passed, 0 failed
```

Average end deck sizes GENERALIST/ECHO/RIOT/VECTOR: 15.03 / 14.83 / 18.27 / 14.87; average bloat tax 0.00 TRACE for each. No gameplay values changed by VIS-001; the optional Icepick-selection API preserves existing default costs/selection. ZEROED/TUMBLE PR #9 was integrated locally before VIS; the visual PR includes that dependency and targets stabilization without pushing to or merging it. Designer visual approval and a Windows playtest remain outstanding.

## 2026-11-17 — CHROME-001 step 1: real encounter layout and readability (Codex)

**Direction:** designer: “I agree with your assessment. Work on those items in that order. Giving samples or examples in png format for each step”. Refine one playable CAPTCHA encounter in Chrome Deco, retaining actual rules and the Rustler paper layer. Working branch is unchanged; this feature locally includes the reviewed VIS-001 PR #11 dependency, which remains open.

**Changed:** larger scan headings, rules and passive text; full-size scan panels; smaller illustration carriers preserve separate actor/flinch transforms. CHAIN tags sit in the rig strip; deck counters use three unclipped lines. Added a per-step screenshot fixture using real Generalist READY RIG, cards, AUTO-RENEW and CAPTCHA. All art/state values remain presentation only.

**Sample:** `01-layout-and-readability.png`. Godot 4.3 stage-1 fixture reports zero failures, including actual card text fit and scan width. **Interpretations to confirm:** two-ICE silhouettes use 82% carriers to give rules more room; three-ICE carriers use 70%. These scales are working presentation values. No gameplay values changed.

## 2026-11-17 — CHROME-001 step 2: chrome/enamel mascot objects (Codex)

**Changed:** layered silver/chrome rims, pearl/mint enamel, restrained Deco ribs and card-corner fan, more substantial speech bubbles and corporate name/wordmark. AUTO-RENEW retains its card/chip silhouette and CAPTCHA its eye/grid widget. Individual face parts and actual mood computations are retained; the Rustler paper layer is unchanged. Speech scales to fit rather than clipping.

**Samples:** `02a-mascots-cheery.png`, `02b-mascots-wary-and-lethal.png`. Godot stage-2 fixture reports zero failures: two actual Corporation Responses produce AUTO-RENEW STR 6 and the actual active CAPTCHA DEADLOCK can be broken to show lethal PULP 6. **Interpretations to confirm:** the six-layer silver rim and small geometric card fan are proposed construction details; the HALCYON wordmark is a placeholder. Background is deliberately still the old placeholder until step 3. No rule values changed.

## 2026-11-17 — CHROME-001 step 3: architectural atrium and illustrated materials (Codex)

**Correction from designer:** “Those dont look anything like Chrome Deco corporate luxury above, photocopied Rustler resistance below”. The first thin-rim samples did not meet the target. A corrected concept PNG established the visual benchmark; this implementation now uses a dedicated pearl/celadon/chrome atrium, illustrated transparent appliance shells and monochrome collage card art. This replaces the blurred app placeholder for HALCYON. Face features, text and controls remain live and separate from artwork; the architecture contains no baked-in game UI. Paper cards and rules retain their own contrast.

**Sample:** `03-welcome-atrium.png`, captured from Godot. Stage 3 reports zero failures for actual rules/cards, scan width and illustration bounds. Fixed TextureRect sizing order so illustrations cannot grow to source-atlas size over rules/neighbouring cards. **Interpretations to confirm:** generated shell art is provisional; six collage motifs are assigned by card role rather than final individual illustrations. Detailed architecture is visible at full opacity; all rule panels remain opaque. This is the revised implementation direction, not a claim of exact pixel identity with the concept. Asset provenance is in the asset folder. No gameplay values changed.

## 2026-11-17 — CHROME-001 step 4: the same atrium reveals its purpose (Codex)

**Changed:** hostile background is an illustrated edit of the same atrium/perspective, revealing clean observation galleries, cameras, processing rails and restraint cradles under controlled red light. Cracking exposes a restrained 20% glimpse beneath the existing warnings; strike 1 switches to the hostile lighting and a sculpted chrome modal; strike 2 keeps the revealed environment. Generated backgrounds contain no game text. The actual Game strike/TRACER/Black ICE transitions still own the state. Paper cards and counters keep their style.

**Samples:** `04a-cracking.png`, `04b-first-strike.png`, `04c-mask-off.png`. Stage-4 Godot fixture reports zero failures, including readable cards/illustration bounds and scan widths in the three-ICE state. **Interpretations to confirm:** 20% Cracking reveal is a working compositing value; scene treatment and generated environment art are provisional. No game rule, TRACE threshold or card insertion behaviour changed.

## 2026-11-17 — CHROME-001 step 5: clear interactions and refreshed five-step review set (Codex)

**Commit tag:** `chrome-001-step5`. Legal subroutine targets get dashed lime outlines and a solid hover border; the separate top-center feedback panel shows the actual selected Icepick, target, BW cost and MARGIN, or the engine's rejection reason. Successful breaks confirm actual BW spent and update the struck rule/mood. The drag cursor is small; duplicate native tooltips are suppressed during drag to avoid covering rules. Raised/targeted hand cards get a lime paper edge. Normal click-to-break, hidden rules, immediate TUMBLE and reduced motion remain. Eight UI scripts run in CI, including native compatible/incompatible Chrome drags and bounded card illustrations. No core Game/CardDB/IceDB files or rule values were changed by CHROME-001.

**Samples:** ten separate full-screen Godot PNGs: 01 layout, 02a cheery / 02b wary-lethal, 03 atrium, 04a Cracking / 04b strike / 04c Mask off, 05a legal target / 05b broken rule / 05c incompatible target. The first two steps were refreshed with the revised art and supersede the rejected flat/thin-rim samples. These are live captures, distinct from the generated concept benchmark. All samples are committed under `docs/visual/fixtures/chrome-001/`; workspace downloads also have a ZIP.

**Validation:** Godot 4.3 imports; **357 rules checks passed, 0 failed**. All eight display-backed scripts exit 0 without script/assertion errors. Friendly Lie remains **170 checks, 0 failures** (including all 112 authored card texts); large-hand/playtest2/playtest3 checks report zero failures. All five per-step Chrome fixtures report zero failures, including native selected-pick cost/confirmation, incompatible-target explanation and no payment on a rejected drop. Render review caught and fixed an atlas TextureRect sizing issue; card illustration bounds are now checked. Thirty seeds per Rustler reproduce the pre-Chrome baseline:

```text
sim GENERALIST: 25/30 cleared; deaths by node { "CAPTCHA": 2, "TERMS & CONDITIONS": 1 }; survivors' avg end VITAE 16.2
sim ECHO: 17/30 cleared; deaths by node { "TERMS & CONDITIONS": 9, "CAPTCHA": 3, "CONSENT WALL": 1 }; survivors' avg end VITAE 9.5
sim RIOT: 25/30 cleared; deaths by node { "CAPTCHA": 4, "TERMS & CONDITIONS": 1 }; survivors' avg end VITAE 15.2
sim VECTOR: 20/30 cleared; deaths by node { "CAPTCHA": 6, "TERMS & CONDITIONS": 4 }; survivors' avg end VITAE 10.7
TESTS: 357 passed, 0 failed
```

GENERALIST also has two stalls, counted separately from deaths. Mean end decks GENERALIST/ECHO/RIOT/VECTOR: 15.03 / 14.83 / 18.27 / 14.87; average bloat tax 0.00 TRACE each.

**Interpretations to confirm:** 2.5-second break confirmation and header placement are working UI choices. Illustrated shells, shared collage motifs and detailed backgrounds remain prototype art; final fidelity to the concept and undrawn ICE/copy await designer review. This implements one encounter direction, not a completed whole-game art collection. Audio development, Windows export and manual Windows playtest are deferred. One feature PR targets stabilization and includes unmerged PR #11/#9 dependencies; nothing was merged or pushed directly to the working branch. The guide/status/HANDOFF are updated in place; design documents and Claude project copies are unchanged.

**Sample delivery:** `chrome-001-review` stores the ten selected PNGs. The download ZIP excludes unrelated regression screenshots; `chrome-001-step5` identifies the implementation commit.

## 2026-11-17 — CHROME-001 plaque revision: pearl enamel instead of black ICE panels (Codex)

**Commit tag:** `chrome-001-enamel`.

**Designer request:** “The black backgrounds on the ice in the images don’t work with the rest of the design. Find an appropriate change … atomic age /art deco / clean friendly corporation design.” Also: “Once approved, commit pr #12 to the shared game branch.” This authorizes the revision and a merge after designer approval of the result; no merge is performed in this revision.

**Changed:** the ICE rule surfaces are now corporate pearl-enamel service plaques with dark slate text, silver edges/soft shadows, a restrained teal service mark and corporate heading font. Hidden/broken chips use pale surfaces while preserving dashed borders and strike-through. Costs remain legible; TUMBLER reel frames match the enamel. Legal target outlines use dark teal instead of lime against the light panels; invalid targets remain red. The Rustler paper/toner hand/HUD remain distinct. Dark hostile mascot shells still communicate Mask off; this removes the large black rule rectangles beneath them without hiding any rules.

**Validation:** Godot 4.3 import and 357 rules checks pass; Friendly Lie 170 checks pass; all five Chrome screenshot stages pass, including actual legal/incompatible native drops and no payment on invalid drops. Refreshed ten full-screen PNGs and the download ZIP. Calculated text contrast: slate/enamel 11.64:1, muted text/enamel 6.25:1, muted text/broken chip 5.51:1, teal/enamel 7.06:1. No rule values changed. The five-step samples in the existing PR are updated in place.

**Interpretations to confirm:** enamel plaques stay clean even in Mask off, reinforcing the corporation's immaculate administrative cruelty. Pearl #EDF4F0, slate #20343B and teal #165B55 are working presentation colors. Final art/fidelity approval remains with the designer. PR #12 remains open targeting `codex/halcyon-playtest-stabilization`; merge is pending that approval.

## 2026-11-17 — CARDS-001: heavy type-specific 1950s slot cartridges (Codex)

**Designer request:** distinct templates for Scripts/other types, subtle common/uncommon/rare differences, vacuum tubes/transistors/exposed wiring/metal/resistors; cards should feel heavy with protruding parts and BW costs mostly outside the white interior. The designer said “Looks good” to the blank carrier art; integrated rules/layout remain for review. No merge authorization for this finished revision is inferred from that art feedback.

**Changed:** SCRIPT stamped steel/Bakelite fuse-and-resistor carrier; PROGRAM cast-aluminum/tube/transistor cassette; PROTOCOL celadon relay/terminal module. Paper labels and live rules sit on the chassis. BW mounts on the upper-right metal tab. Common is plain/single-notch, uncommon has two notches and a brass fitting, rare three notches and fine double-metal detail; full authored rarity labels remain. STARTER and BLOAT classifications remain. Three generated frames are prototype art; Bloatware retains its corporate treatment. Cards are 164×244 with component bounds extending 10 px sideways / 12 px vertically. A shallower hand fan, raised hand/rack spacing and padded choices protect the hardware; protrusions participate in hit-testing. Reward offers and inspection use the same carriers. No card definitions, rarity weights, costs or rules changed.

**Validation:** Godot 4.3 imports; 357 rules pass and 30-seed bot summaries match the pre-card baseline (GENERALIST/ECHO/RIOT/VECTOR clears 25/17/25/20, survivor VITAE 16.2/9.5/15.2/10.7). Nine UI scripts pass. Cartridge fixture: 612 checks / zero failures, including all 112 authored rule texts, the longest legal shared-tag compiled SCRIPT pair, actual rarity, illustration bounds and 6-/8-/16-card protrusion bounds. Existing native hand clicks, HOLD/READY RIG, reward, SCAN/CULL/ZEROED/TUMBLE and five-second reduced-motion response checks remain. Nine individual close-up PNGs plus six/eight-card encounter captures are in `docs/visual/fixtures/cards-001/` and the downloadable ZIP.

**Review:** physical finish details and motif reuse are proposed art choices. Labels/costs remain live data; no gameplay is baked into textures. The revised PR #12 remains open against the shared game branch and awaits designer approval before merge. Audio/Windows export are outside this task. Asset provenance, guide, status and the shared HANDOFF are updated in place.


## 2026-11-17 — CARDS-001: integrated light faces and printed titles (Codex)

**Commit tag:** `cards-001-lightfaces`.

**Designer feedback:** black title backgrounds and dark beige card faces do not fit the chassis. Removed the opaque black title strip; dark titles now print directly on each inset face with a restrained separator. Generated edits preserve the three carriers and change only the blank face: near-white ivory instruction stock for SCRIPT, cool pearl instrument plate for PROGRAM, pale celadon enamel for PROTOCOL. Hardware, protrusions, outside BW tab, rarity details, authored metadata and rules are unchanged. The corporate Bloatware treatment remains separate.

**Validation:** 357 rules checks and 612 cartridge UI checks pass, including authored/compiled text fit and protruding bounds. Five Chrome stages pass; refreshed nine close-ups, six/eight-card captures and ten encounter review PNGs. The earlier dated whole entry was appended unchanged to the archive under LOG-001 to keep this live log below about 60 KB.

**Review:** material tint and direct-print title treatment are proposed visual refinements. PR #12 is updated, not merged; designer approval of the integrated revision is still required under the existing merge instruction. No gameplay data, rarity odds or costs changed.


## 2026-11-17 — CARDS-001: selected board colours and Whirlwind Bloatware (Codex)

**Commit tag:** `cards-001-board-palette`.

**Designer choices:** A/C/D board colours selected for card faces; Whirlwind #3 selected as Bloatware prototype. The pale Bloatware plate was rejected (“No card should have a white background for the text”). Brown Bloatware was then rejected for matching SCRIPT; oxide-red D received “Perfect”. That confirms the D material choice; no approval of the entire PR/merge is inferred.

**Changed:** tobacco-brown SCRIPT, earthy olive PROGRAM, muted blue-green PROTOCOL; direct light printing on real board-style textures. BLOATWARE now has the Whirlwind-inspired protective U-handle, paired tubes, open cage/stacked boards and oxide-red phenolic face. Names, costs and rules are live controls. TRACER/SPAM remain BLOATWARE with unchanged unplayability/clear/TRACE rules; both now use the same component-aware bounds as other cartridges. Cached Bloatware retains full rules and CACHED marker; optional corporate flavour footer yields space when cached. No white card text panels remain. A–D review labels denote the four types; source-reference letters A/C/D remain palette provenance.

**Validation:** Godot 4.3 import, 357 rules checks and 170 Friendly Lie UI checks pass. Extended cartridge fixture passes 625 checks and covers all authored/compiled texts, both Bloatware examples including cached text, component bounds and a mixed-type hand. Selected older log entry appended unchanged to the archive under LOG-001. Asset sources/guide/status/HANDOFF and PNGs are updated. No card definitions, rarity weights, costs or gameplay values changed. PR #12 remains open for integrated review before merge.

## 2026-11-17 — CARDS-001: instrument amber accents (Codex)

**Commit tag:** `cards-001-amber`. Replaced neon yellow-green with warm instrument amber (`#D6B675`) for the shared highlight and printed numeric highlights. The brass/gauge reference fits the selected brown, olive, teal and oxide-red boards. BW badges, selection accents and shared HUD controls inherit the same colour. No rules or costs changed.

**Interpretations to confirm:** exact amber hue is a visual proposal for designer review. PR #12 remains open.

**Validation:** 357 rules checks and 625 cartridge UI checks pass; updated four-type PNG rendered from live Godot controls.

## 2026-11-17 — CARDS-001: glowing text instead of amber blocks (Codex)

**Commit tag:** `cards-001-amber-glow`. Designer requested glowing amber text instead of highlighted backgrounds. Numeric rule text now uses warm amber ink (`#F2CD87`) with a faint translucent amber halo; removed rectangular fills. External BW badges use a dark instrument face and glowing amber numerals. Board textures stay visible.

**Interpretations to confirm:** restrained halo intensity and dark BW instrument face are proposed treatments. No gameplay changes. 625 cartridge UI checks pass; refreshed live-control comparison and card/hand PNGs. PR #12 remains open for review.

## 2026-11-17 — CARDS-001: distinct board surface textures (Codex)

**Commit tag:** `cards-001-board-textures`. Added subtle stationary procedural material grain behind card printing: pressed phenolic fibres for brown SCRIPT, woven laminate for olive PROGRAM, brushed resin for teal PROTOCOL, mottled Bakelite for oxide-red BLOATWARE. Inset feathered bounds protect chassis and contacts; text/illustrations draw above the texture. Existing palette and amber text glow retained.

**Interpretations to confirm:** these four material patterns and their restrained intensity are proposed for review. No gameplay changes. 625 cartridge UI checks pass. Refreshed four-type comparison and card/hand fixtures. Oldest whole log entry appended unchanged to the archive under LOG-001.

## 2026-11-17 — VISUAL-DECISIONS-2026-11-17: approved visual decisions recorded in the master design doc (Claude)

**Designer instruction:** record the approved visual decisions from VIS-001, CHROME-001 and CARDS-001 in `REDLINE_MASTER_DESIGN.md`, leaving out everything still waiting for review. Added the VISUAL-DECISIONS-2026-11-17 table after the Raygun Gothic section: The Friendly Lie, Atomic Salvage deprecated, 6-card draw, Chrome Deco encounter, no black ICE rule panels, type-specific cartridges, A/C/D board colours, no white card text backgrounds, oxide-red Whirlwind Bloatware, glowing amber numbers. Each row quotes the designer and cites its commit. Final art, working values and Interpretations to confirm stay in HANDOFF *Waiting on the designer*. LOG-001: the oldest whole entry (DSY-001/002/003/006, 2026-11-15) moved unchanged to the archive. **Code changes:** none.

## 2026-11-17 — MAIN-001: HANDOFF points to main (Claude)

**Designer instruction:** fix the contradiction between `HANDOFF.md` and the shared working agreement. Rule 1 now says to work on `main` under `AGENTS.md` / `CLAUDE.md` (the former working branch was merged at a523502); rule 2 and the session-start step say `main`. Added a MAIN-001 row to *Done*. **Found, not changed:** `.github/workflows/godot-validation.yml` only runs the Windows export on pushes to `codex/halcyon-playtest-stabilization` or `codex/zeroed-tumble-2026-11-16`, so pushes to `main` never export. CI belongs to Codex; raised with the designer. **Code changes:** none.

## 2026-11-17 — MAIN-001: Windows export runs on main (Claude)

**Designer instruction:** make the Windows export run from `main`. In `.github/workflows/godot-validation.yml`, the three Windows steps (install template, export, upload) now run on pushes to `main` instead of `codex/halcyon-playtest-stabilization` / `codex/zeroed-tumble-2026-11-16`. Validation, rules and screenshot steps are unchanged; the workflow still triggers only on changes under `godot/` or to the workflow file. HANDOFF's deferred Windows line updated to match.

## 2026-11-17 — RUSTLER-LOOK-001: two Rustler styles kept on purpose (Claude)

**Designer decision:** "B Each corp will have a different look. The HUD will probably change in the near future, but I want to keep it this way for now." The CARDS-001 hardware cards and the zine HUD/tags/END TURN/NUL/REM notes stay as they are; this is recorded as a deliberate exception to Visual Language Rule 1. Added RUSTLER-LOOK-001 to the master design doc and an amendment note under Rule 1 in `REDLINE_VISUAL_LANGUAGE.md`. **Code changes:** none.

## 2026-11-17 — VISUAL-APPROVALS-002: prototype art and working values approved (Claude)

**Designer decision:** "Okay, all those changes that you listed are all approved." Covers the CHROME-001 art review, CARDS-001 as a whole, and the VIS-001 details (hand size, lethal threshold, undrawn ICE silhouettes and wording, motion timings, Cracking after a strike). Recorded as VISUAL-APPROVALS-002 in the master design doc with the approved values. HANDOFF: the two matching *Waiting* rows moved to *Done*; the CARDS-001, CHROME-001 and VIS-001 *Built* rows note art approval with playtest still pending. The rules questions in *Waiting* are not covered. **Code changes:** none.

## 2026-11-17 — CHROME-001 / CARDS-001 / MAIN-001 follow-up (Codex)

Refreshed ten CHROME-001 PNGs from `main` with Godot 4.3. All five capture stages passed. Amber numbers on brown SCRIPT faces are harder to read. Synced status and handoff and documented nine assets, including oxide-red Whirlwind Bloatware. Exact prompts/model IDs and the corrected concept PNG were unavailable. No Windows export. LOG-001 moved the oldest whole live entry to the archive unchanged.

## 2026-11-17 — DEPRECATE-001: LOGIC BOMB and RELAY deprecated (Claude)

**Designer decision:** "Let's deprecate logic bomb and relay for now. They don't work in the current rules environment." Recorded DEPRECATE-001 in the master design doc. Marked deprecated, not deleted, in Card Pools (LOGIC BOMB), ICE Passives, Core Rules §passives, Deck Synergy, ICE Corp 1 and the ICE Rules Bible (RELAY). CONSENT FORM and SWITCHBOARD have no passive for now. HANDOFF: ZEROED-001 interpretation closed; new Codex TO DO row to remove both from the build. Note: the approved CARDS-001 fixture `script-rare-logic_bomb.png` still shows LOGIC BOMB as a rarity sample. **Code changes:** none.

## 2026-11-17 — READ-001: darker SCRIPT face for legible printing (Claude)

**Designer instruction:** "make the contrast stronger so that the brown script cards are legible" (after Codex reported amber on brown SCRIPT was hard to read). Measured on the CARDS-001 fixtures: SCRIPT face (127,102,74) gave amber 3.55:1 and ivory 5.12:1 (amber below 4.5:1); PROGRAM amber 6.91:1. **Changed:** `godot/scripts/ui/friendly_lie/card.gd` adds a soft-edged `ScriptFaceShade` (#2A1C10 at 55%) over SCRIPT's face only, below the board grain, fitted to the face bounds measured from `script.png` (11,21,139,188). Result: face about (83,64,44), amber about 6.5:1, ivory about 9.3:1. Brown stays brown; chassis art, textures, colours of other types, rules and costs are unchanged. **Validation:** Godot 4.3 import; rules 357 passed, 0 failed; cartridge UI 625 checks, 0 failures; Chrome stages 1–5, 0 failures. Refreshed SCRIPT and encounter PNGs in `fixtures/cards-001/` and all ten in `fixtures/chrome-001/`; `four-card-types.png` is not produced by a checked-in script and was not refreshed. **Not changed:** PROTOCOL's blue-green face measures amber 4.18:1, also under 4.5:1; raised with the designer. Committed with [skip ci]: no Windows build.

## 2026-11-17 — PULP-001: FORTRESS PULP rolled each time (Claude)

**Designer decision:** "For number 4, they are rolled each time. They should be slightly variable so that the rustler can plan to some degree." Reverses the 2026-11-13 working assumption (fixed per subroutine). Recorded in the master design doc and the ICE Rules Bible. The roll's width, its on-screen display and its relation to PULP-002 curves are open; HANDOFF's PULP-001 row now asks those questions. Nothing to build until they're answered. **Code changes:** none.

## 2026-11-17 — RIOT-003: SHATTER readings confirmed (Claude)

**Designer decision:** "For number 3, that is correct." SHATTER lets SLEDGE break any one chosen ICE of any type this turn; SLEDGE then stays at STR 0 until the encounter ends and returns to STR 2 next encounter. Matches the build, so nothing changes in code. Recorded in the master design doc and Rustlers doc; HANDOFF row moved to *Done*.

## 2026-11-17 — REEL-001 follow-up closed; TUMBLE-001 reaffirmed (Claude)

**Designer:** a broken TUMBLER subroutine disappears at once and the next unbroken subroutine in sequence tumbles in; TUMBLERS still rotate once each turn. This is TUMBLE-001 (approved 2026-11-16, built `zeroed-tumble-step3`), so no DEADLOCK counter is needed. Added TUMBLE-001 to the master design doc (it was only in Core Rules) and closed the REEL-001 follow-up in HANDOFF. **Code changes:** none.

## 2026-11-17 — ICE-AUDIT-001 applied; PULP-001 roll size (Claude)

**Designer decisions:** "apply the changes to the Halcyon ICE now. That is before the playtest." and "the roll should be +2, -2 with once every 3 to 4 turns, a +3 or a -3." In-session choices: CAPTCHA's PULP 6 becomes TRACE 2; CONSENT FORM and REJECT ALL PULP 4 become PULP 3; the ±3 swing is a random ~30% chance, not a fixed rhythm. **Recorded:** ICE-AUDIT-001 and the PULP-001 roll in the master design doc; ICE Corp 1 §5.0 slice table; ICE Rules Bible audit note; Core Rules PULP X row. **Assumptions stated for confirmation:** a roll never goes below PULP 1; −2..+2 equally likely; ±3 sign 50/50; Game RNG. **HANDOFF:** two Codex TO DO rows (ICE-AUDIT-001, PULP-001 roll); new WAITING row PULP-001 display (pre-fire display, curves, lethal-mood threshold). **Code changes:** none.

## 2026-11-17 — PULP-001: rolled PULP is always shown before it fires (Claude)

**Designer:** "the rustler is always going to see what pulp damage the corporation is going to deliver next turn with that subroutine. So there is no surprise for the rustler." Recorded in the master design doc and Core Rules: the roll is made ahead of time (working timing: start of the Rustler turn), shown as an exact number, and that value fires; the lethal mood reads it. HANDOFF build row updated; the WAITING row now only asks about PULP-002 curves, including curve B's "PULP ?". **Code changes:** none.
