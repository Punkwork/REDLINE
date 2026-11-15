# HALCYON PLAYTEST 3 implementation and verification

Target: `codex/halcyon-playtest-stabilization`; feature branch `codex/playtest3-synergy-pacing`, based on `8a2cbc8` (merged PRs #4 and #5). Seven ordered commits; no merge to main. Windows export is gated to the post-merge stabilization-branch push.

All simulations use Godot 4.3, seeds 100–129, 30 runs per Rustler **per step**. Stalls at the 3000-action guard are not deaths or clears. End deck size includes permanent physical cards; bloat tax paid is actual TRACE after Rustler modifiers. Step 0 predates deck/tax instrumentation. Bot results are policy checks, not human balance evidence.

## step0: REJECT-001

Commit: `playtest3-step0`. **Full rules suite: 219 passed, 0 failed.**

**Changed / tests added:** REJECT ALL has one DEADLOCK in its three-entry pool; BOOTING remains turn 3. Updated opening rules checks and bot timing reporting.

**Tests added:** Opening pool/rotation, turn-3 BOOTING and earliest-breach assertions; bot distinguishes stalls from deaths and chooses legal fallback targets.

**Interpretations to confirm:** The bot now installs/pre-boosts HUSH for BORROWED CREDENTIALS off-type coverage; stalled simulations are reported separately from deaths. These are harness corrections, not balance changes. Earliest observed opening BREACH was turn 3 for all Rustlers.

**Deferred:** Conditional BOOTING-on-turn-4 and safety valves remain excluded.

| Rustler | Cleared | Deaths by Node | Survivors’ average end VITAE | Average end deck | Average bloat TRACE paid |
|---|---:|---|---:|---:|---:|
| GENERALIST | 3/30 | { "CONSENT WALL": 4, "TERMS & CONDITIONS": 10, "DOORBELL": 13 } | 18.7 | — | — |
| ECHO | 14/30 | { "DOORBELL": 6, "CAPTCHA": 4, "TERMS & CONDITIONS": 6 } | 12.9 | — | — |
| RIOT | 3/30 | { "DOORBELL": 15, "TERMS & CONDITIONS": 10, "CAPTCHA": 2 } | 14.0 | — | — |
| VECTOR | 7/30 | { "CAPTCHA": 5, "TERMS & CONDITIONS": 9, "DOORBELL": 9 } | 7.0 | — | — |

**Stalls:** none.

## step1: DSY-001/002/003/006

Commit: `playtest3-step1`. **Full rules suite: 233 passed, 0 failed.**

**Changed / tests added:** FOOTPRINT/caps and bands, per-Node bloat TRACE, optional GHOST draw OFF, duplicate-aware draw estimates and key-card previews, COVERAGE/tag density, and guarded full-clear DECOMPILE.

**Tests added:** 14 checks: caps/bands, Bloatware exclusion, all-type coverage/fallbacks, last-breaker guard, 10-card floor, heavy-Node tax, default-off/optional draw, hit-rate/tag counts and DECOMPILE transition.

**Interpretations to confirm:** Draw estimates use nominal stage lengths of 5/6/7 Rustler turns for HALCYON/IRONWATCH/LUCIDA. Conditional fallback cards count toward coverage; BORROWED CREDENTIALS requires HUSH and SHATTER requires SLEDGE. Existing TRACE modifiers apply to bloat tax; reported tax is actual TRACE gained. Empty-card reward skips still work.

**Deferred:** Playable IRONWATCH/LUCIDA are outside the slice; their cap values are supported by the analysis API. Deck-editing services outside full-clear rewards are later work.

| Rustler | Cleared | Deaths by Node | Survivors’ average end VITAE | Average end deck | Average bloat TRACE paid |
|---|---:|---|---:|---:|---:|
| GENERALIST | 3/30 | { "CONSENT WALL": 4, "TERMS & CONDITIONS": 10, "DOORBELL": 13 } | 18.7 | 14.07 | 0.00 |
| ECHO | 14/30 | { "DOORBELL": 6, "CAPTCHA": 4, "TERMS & CONDITIONS": 6 } | 12.9 | 14.43 | 0.00 |
| RIOT | 3/30 | { "DOORBELL": 15, "TERMS & CONDITIONS": 10, "CAPTCHA": 2 } | 14.0 | 17.20 | 0.00 |
| VECTOR | 7/30 | { "CAPTCHA": 5, "TERMS & CONDITIONS": 9, "DOORBELL": 9 } | 7.0 | 14.17 | 0.00 |

**Stalls:** none.

## step2: DSY-007/008

Commit: `playtest3-step2`. **Full rules suite: 244 passed, 0 failed.**

**Changed / tests added:** REBOOT queues drain only after draws finish; AMP and seven specified cards, SCAN bottom-order choice, in-Node BURN and discard retrieval, HUD reboot estimate, and bot choice handling.

**Tests added:** 11 checks: mid-draw/empty-pile REBOOT, AMP/rack ordering, forced shuffle/self-BURN, SCAN bottom order, other-card BURN requirement/persistence, TAIL CALL self-exclusion/retrieval and fresh Node state.

**Interpretations to confirm:** SCAN does not itself reshuffle; selected bottom cards are ordered first-selected-first-drawn when reached. FORCE REBOOT counts even with an empty discard. ROLLING RESTART adds its printed +1 AMP without self-amplification; SHIELD/BW/draw ENGINE outputs gain current AMP. A 128-trigger repeating-chain safeguard prevents unbounded loops. One RIOT bot run stalled at the guard rather than dying; it is reported separately.

**Deferred:** CRON/PROCESS and unbuilt corporation systems remain deferred; AMP support for the existing virus outputs is completed with the UNDERFLOW/virus step.

| Rustler | Cleared | Deaths by Node | Survivors’ average end VITAE | Average end deck | Average bloat TRACE paid |
|---|---:|---|---:|---:|---:|
| GENERALIST | 8/30 | { "CONSENT WALL": 3, "TERMS & CONDITIONS": 11, "CAPTCHA": 3, "DOORBELL": 5 } | 13.6 | 14.23 | 0.00 |
| ECHO | 12/30 | { "DOORBELL": 11, "TERMS & CONDITIONS": 4, "CAPTCHA": 3 } | 10.2 | 14.40 | 0.00 |
| RIOT | 4/30 | { "TERMS & CONDITIONS": 15, "DOORBELL": 8, "CAPTCHA": 2 } | 14.5 | 17.30 | 0.00 |
| VECTOR | 7/30 | { "TERMS & CONDITIONS": 10, "DOORBELL": 9, "CAPTCHA": 4 } | 7.4 | 14.13 | 0.00 |

**Stalls:** stalled RIOT (3000-step guard, not deaths): { "CAPTCHA": 1 }

## step3: DSY-011/012

Commit: `playtest3-step3`. **Full rules suite: 255 passed, 0 failed.**

**Changed / tests added:** CHAIN tracks successful card plays; PIVOT, COVER FIRE, HANDOFF and KILL CHAIN; HOLD 1 and DEAD MAN’S POCKET HOLD 2; scrollable choices.

**Tests added:** 11 checks: CHAIN bonuses and Icepick independence; HOLD choose/skip, Training exclusion, two pocket choices, KILL CHAIN cap and turn reset. CAPS remain absent.

**Interpretations to confirm:** HOLD can retain a temporary cached card as ordinary CACHE. CHAIN effects are card-triggered rather than per-turn AMP processes. Bot stalls are reported separately from deaths.

**Deferred:** Ghostware acquisition and CAPS remain absent from the slice; the pocket effect is exercised through the Ghostware state hook.

| Rustler | Cleared | Deaths by Node | Survivors’ average end VITAE | Average end deck | Average bloat TRACE paid |
|---|---:|---|---:|---:|---:|
| GENERALIST | 12/30 | { "TERMS & CONDITIONS": 9, "DOORBELL": 7, "CONSENT WALL": 1 } | 15.8 | 14.50 | 0.00 |
| ECHO | 9/30 | { "TERMS & CONDITIONS": 5, "CAPTCHA": 4, "DOORBELL": 8, "CONSENT WALL": 1 } | 11.4 | 14.23 | 0.00 |
| RIOT | 12/30 | { "TERMS & CONDITIONS": 9, "DOORBELL": 7, "CAPTCHA": 2 } | 10.8 | 17.53 | 0.00 |
| VECTOR | 6/30 | { "TERMS & CONDITIONS": 6, "DOORBELL": 14, "CAPTCHA": 4 } | 5.7 | 14.20 | 0.00 |

**Stalls:** stalled GENERALIST (3000-step guard, not deaths): { "DOORBELL": 1 }; stalled ECHO (3000-step guard, not deaths): { "TERMS & CONDITIONS": 1, "CAPTCHA": 2 }

## step4: DSY-009/010

Commit: `playtest3-step4`. **Full rules suite: 264 passed, 0 failed.**

**Changed / tests added:** Negative ICE STR, MARGIN previews, SCALPEL, STACK SMASH, INTEGER UNDERFLOW, CULL and HARVEST; AMP on virus effects.

**Tests added:** 9 checks: negative STR, explicit floor, HARDENING, LOGIC BOMB, SCALPEL margin/free break, virus AMP, CULL selections/cap, HARVEST payout and INTEGER UNDERFLOW cap/BURN. Existing break-limit tests continue passing.

**Interpretations to confirm:** LOGIC BOMB sets even negative STR to exactly zero. Explicit STR floors prevail. TOLL remains an additional cost when OVERKILL waives the break cost.

**Deferred:** ZEROED has no approved numbers or card definition and remains a later RIOT-pool design. Other-corporation floor ICE are not on this map.

| Rustler | Cleared | Deaths by Node | Survivors’ average end VITAE | Average end deck | Average bloat TRACE paid |
|---|---:|---|---:|---:|---:|
| GENERALIST | 15/30 | { "TERMS & CONDITIONS": 11, "DOORBELL": 4 } | 16.2 | 14.77 | 0.00 |
| ECHO | 10/30 | { "TERMS & CONDITIONS": 6, "CAPTCHA": 5, "DOORBELL": 5, "CONSENT WALL": 1 } | 9.1 | 14.33 | 0.00 |
| RIOT | 12/30 | { "TERMS & CONDITIONS": 9, "DOORBELL": 8, "CAPTCHA": 1 } | 13.3 | 17.53 | 0.00 |
| VECTOR | 8/30 | { "DOORBELL": 12, "TERMS & CONDITIONS": 6, "CAPTCHA": 4 } | 9.0 | 14.30 | 0.00 |

**Stalls:** stalled ECHO (3000-step guard, not deaths): { "TERMS & CONDITIONS": 1, "CAPTCHA": 2 }

## step5: DSY-004/005/013

Commit: `playtest3-step5`. **Full rules suite: 278 passed, 0 failed.**

**Changed / tests added:** SAFEHOUSE COMPILE with ordered effects, combined costs and tags, interactive continuations, CLEAN BUILD; MINIMALIST and ZERO FOOTPRINT; Ghostware effect hooks; FREE TRIAL on the final HALCYON layer.

**Tests added:** 14 checks: compile eligibility, summed costs/tags, ordered effects and physical-card ownership, interactive continuation, CLEAN BUILD, Ghostware effects and all three corporation pushback triggers.

**Interpretations to confirm:** The explicit shared-tag requirement overrides the contradictory PROBE × PULP SHIELD example. Compilation order is chosen by selecting cards in order. Targeted halves use the selected ICE; costs are prepaid once. SAFEHOUSE compilation replaces healing. Compiled cards burn if either half burns. MINIMALIST waives the full first-break BW action cost. Other-corporation reactive ICE have definitions and tested hooks, not map placement.

**Deferred:** REFACTOR 50-CRED Uplink service, PATCHWORK/FUSE acquisition and modifications, DEDUPLICATOR, Ghostware acquisition, and IRONWATCH/LUCIDA routes are absent from this slice; no acquisition or Uplink flow invented.

| Rustler | Cleared | Deaths by Node | Survivors’ average end VITAE | Average end deck | Average bloat TRACE paid |
|---|---:|---|---:|---:|---:|
| GENERALIST | 13/30 | { "TERMS & CONDITIONS": 12, "DOORBELL": 4 } | 15.8 | 14.57 | 0.00 |
| ECHO | 8/30 | { "TERMS & CONDITIONS": 6, "DOORBELL": 7, "CAPTCHA": 4, "CONSENT WALL": 1 } | 10.2 | 14.20 | 0.00 |
| RIOT | 10/30 | { "DOORBELL": 8, "TERMS & CONDITIONS": 10, "CAPTCHA": 2 } | 16.6 | 17.47 | 0.00 |
| VECTOR | 5/30 | { "TERMS & CONDITIONS": 6, "DOORBELL": 13, "CAPTCHA": 5 } | 8.2 | 14.10 | 0.00 |

**Stalls:** stalled GENERALIST (3000-step guard, not deaths): { "CAPTCHA": 1 }; stalled ECHO (3000-step guard, not deaths): { "TERMS & CONDITIONS": 1, "CAPTCHA": 3 }; stalled VECTOR (3000-step guard, not deaths): { "TERMS & CONDITIONS": 1 }

## pacing: PACE-003,005,007,008

Commit: `playtest3-pacing`. **Full rules suite: 310 passed, 0 failed.**

**Changed / tests added:** DEADLOCK ×N progress for paid/card/WORM breaks; independent ESCALATE counters for TRACE/DISCARD/FORGET; reward need icons and visible draw chance; Tier 1 one-layer route; tier-aware reward odds; +50% reserves; version/label 0.3.0-playtest.3 / HALCYON PLAYTEST 3; post-merge-only Windows export; updated playtest guide and nine new UI fixtures. Final regression review also completed AMP for SILENT PARTNER/PAIN TOLERANCE, amplified card text, compiled fallback coverage, and Node/run state resets.

**Tests added:** 32 additional checks: one-layer map and reserve rounding, Tier 2 odds, DEADLOCK paid/card/WORM progress and ×3, ESCALATE next values/broken/skipped effects, role labels, RELAY and 3/4/3 floors, MINIMALIST/ZERO FOOTPRINT, compiled cost cap/BURN/fallback coverage, ONE-TRICK cap, CACHE-protected FORGET, SHORT LOOP order and AMP output/lifecycle. Nine new UI fixture screenshots.

**Interpretations to confirm:** All four slice rows are Opening/Tier 1 (ICE Corp 1 §5.0 and Pacing §7); retain each Node’s first layer and remove later layers, without rebalance. FREE TRIAL remains Tier 2 data/trigger only after this cut, superseding its temporary Step 5 placement. 15 ×1.5 CRED rounds up to whole 23. No existing ICE receives an unspecified ×N or ESCALATE assignment; controlled fixtures exercise both. Cards outside the DRILL/HULL/COVERAGE definitions have no misleading role label. REBOOT resolves rack effects in installation order; ROLLING RESTART gains a fixed one AMP rather than amplifying its own AMP production. A finite repeating-trigger guard prevents recursive draw loops from hanging the app. Numeric GHOST thresholds override contradictory RIOT starter prose (15 is GHOST at cap 22). Compiled effects read the board in order: a reduction can enable a following fallback; a break half without eligible targets does nothing.

**Deferred:** No conditional BOOTING/safety-valve changes. Tier 2 map placement, other corporations, Uplink/REFACTOR, PATCHWORK/FUSE, Ghostware acquisition/DEDUPLICATOR and CAPS remain deferred as listed in HANDOFF. Phase 7 HULL pools, ZEROED and manual BREACH WORK scoring retain their existing owners. Windows export happens after merge; Windows launch/human playtest have not been run.

| Rustler | Cleared | Deaths by Node | Survivors’ average end VITAE | Average end deck | Average bloat TRACE paid |
|---|---:|---|---:|---:|---:|
| GENERALIST | 29/30 | {  } | 16.2 | 15.37 | 0.00 |
| ECHO | 20/30 | { "TERMS & CONDITIONS": 5, "CAPTCHA": 4, "CONSENT WALL": 1 } | 8.8 | 14.80 | 0.00 |
| RIOT | 24/30 | { "TERMS & CONDITIONS": 3, "CAPTCHA": 2, "DOORBELL": 1 } | 18.0 | 18.20 | 0.00 |
| VECTOR | 20/30 | { "CAPTCHA": 5, "TERMS & CONDITIONS": 5 } | 11.1 | 14.87 | 0.00 |

**Stalls:** stalled GENERALIST (3000-step guard, not deaths): { "CAPTCHA": 1 }

## Additional verification

- Godot 4.3 editor import: no script/parse errors.
- Six display-backed screenshot scripts, including the new nine-screen playtest-3 fixture; 45 screenshots total. Choice-state checks, VECTOR virus setup, large-hand scrolling/clicking, and early-exit UI regressions pass. The legacy early-exit fixture is explicitly multilayer and does not mutate the production map.
- Rules cover the DECOMPILE floor/coverage guard, REBOOT mid-draw/empty piles, SCAN order, BURN persistence, CHAIN/Icepick independence, HOLD/Training/pocket, negative STR/floors/HARDENING/RELAY/LOGIC BOMB, cash-outs, COMPILE costs/interactive continuation/BURN, Ghostware hooks, DEADLOCK paid/card/WORM steps, skipped/broken ESCALATE, AMP lifecycle and display.
- CAPS independence cannot be executed because CAPS are absent; last-played state is changed only by successful card plays. Ghostware acquisition and full-run deck-size targets cannot be assessed in this short slice.
- Some older screenshot scripts report Godot shutdown resource-in-use warnings; no script, parse or assertion failures. New playtest-3 UI fixture exits cleanly.

Exact per-step execution logs are retained in `REDLINE_DEVELOPMENT_LOG.md`. The user-facing mechanics and on-screen checks are in `HALCYON_PLAYTEST_GUIDE.md`.
