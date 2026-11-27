# PANOPTICON — DEVELOPMENT LOG
**Initialized:** 2026-11-09  
**Policy:** append dated entries; distinguish reported outcomes from verified tests.

**LOG-001 (2026-11-16):** entries from 2026-11-08 to 2026-11-14 are in `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md`, unchanged. Keep this file under about 60 KB (HANDOFF, "How we work" 6).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — FACADE-001: HALCYON non-fight copy approved (Codex).
LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — HALCYON PLAYTEST 4 Windows build (Codex).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — Playtest checklist v0.4 for HALCYON PLAYTEST 4 (Claude).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — Atomic Deco Punk design direction (Codex), 2026-11-17 — ADP-001 Phase 1 (Codex).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — ADP-001 Phase 1 confirmations (Codex), 2026-11-17 — HAND-CLEANUP-001 and CARD-CONTROLS-001 (Codex), 2026-11-17 — HALCYON PLAYTEST 5 Windows build (Codex), 2026-11-18 — ZINE-002, ARCH-001: the zine as samizdat; the Archipelago (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-18 — ARCH-NAMES-001: islands named like care homes (Claude).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — ARCH-LINES-001: relocation lines and programme names approved (Claude); 2026-11-18 — ARCH-SLANG-001: the Rustlers say ’Pelago (Claude); 2026-11-18 — ARCH-SLANG-001 confirmed: ’Pelago even at the end (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-18 — ZINE-003: SAMIZINE, the underworld's zine look (Claude).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — ADP-001 Phase 2 and ADP-4a (Codex); 2026-11-18 — ADP-001 Phase 3 and ADP-4a (Codex).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — SIGNAL-001, ARCH-001 and ADP-4a (Codex).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — ZINE-003 confirmed (Claude); 2026-11-18 — ARCH-COPY-001: remaining working copy approved (Claude).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — ARCH-COPY-001 correction: island names stay working copy (Claude); 2026-11-18 — No history fact-checks (Claude).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — RELEASE-001: builds come from a `release` branch (Claude).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-20 — ChatGPT round 5 prompts: title screen and Rustler portraits (Claude); 2026-11-20 — AVATAR-001 LUCIDA amendment and round 6 prompts (Claude); 2026-11-20 — Round 6 v2: LUCIDA as mechanical nightmares, mockups first (Claude); 2026-11-20 — IRONWATCH avatar prework (Claude); 2026-11-20 — AVATAR-001 IRONWATCH amendment and round 7 prompts (Claude); 2026-11-20 — IRONWATCH mockups reviewed (Claude); 2026-11-20 — ENC-CONCEPT-001 console colour per corporation (Claude Code); 2026-11-21 — Designer calls: DEV-002b/c/h, PIXEL-TRACE-001c, PIXEL-16BIT-001, MOOD-PIXEL-001; checklist v0.7 (Claude).

LOG-001 archived the following oldest entries unchanged: 2026-11-21 — RELEASE-001: `playtest-7` tag pushed (Claude); 2026-11-21 — STRIP-001: core-loop test build (Claude Code).

## 2026-11-26 — ARCH-V2-003w: program actions on the CRT (Claude Code)

Designer: effects such as Icepick BOOST are chosen from the CRT; six keys 3 + 3 approved; no row arrow needed (mock drawn). Added `EncounterController.request_boost / request_uninstall_cache / request_unload` (one Game call each) and CRT action keys in `RigBay.ProgramScreen`. New checks: BOOST from the CRT (+STR, BW spent, one call), EJECT removes the cartridge. Tests: import 0; `test_game.gd` 176/0; `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; `test_arch_v2_ice.gd` 170/0; 23 captures (CI count updated).

## 2026-11-26 — ARCH-V2-004: Batch 2 cards, hand, targeting, choices (Claude Code)

Designer started Batch 2. Built `CardView` (HuCard body drawn in the engine, type frame, cost medallion, rules field, gold contacts; states), the hand of CardViews in the fan, the card inspector (HOVER-001), ICE targeting (`IcePanel.set_targetable`, `IceLane.target_chosen`, CHOOSE AN ICE plaque), `ChoiceOverlay` (all current choice variants with the prototype's wording), controller choice intents. The DEV stand-in buttons are gone. New checks: hand UIDs and playability, click-to-play parity, targeting on/cancel/play parity, DISCARD overlay open/choose parity. Tests: import 0; `test_game.gd` 176/0; `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; `test_arch_v2_ice.gd` 182/0; 25 captures (CI count updated). Captures `docs/visual/fixtures/arch-v2-batch2/`. (LOG-001: moved "2026-11-21 — BOOST-001 and SUB-001 after Playtest 9 (Claude Code)" to the archive.)

## 2026-11-26 — ARCH-V2-005: coverage table, coverage test, header CAPS and PROTOCOLS slots (Claude Code)

Designer (18:22): build the coverage table, the test and the placeholders before Batch 3; CAPS and PROTOCOLS slots, 3 each, in the header; turn indicator and TRACE meter at half width; ChatGPT prompts and a layout image. Built `ENCOUNTER_COVERAGE.md` from `godot/tests/arch_v2_coverage.json` (63 rows; `tools/arch_v2_coverage_md.py`), `test_arch_v2_coverage.gd` (in CI), `HudWidgets.SlotRack/RackSlot/RackIcon`, `VisibleStateAdapter.protocol_models/cap_models`; phase plaque and TRACE gauge use half-width art when it lands and nine-slice the old parts meanwhile. ChatGPT prompts: VAS-ASSET-001 §6e; layout image `docs/visual/fixtures/arch-v2-batch2/v2_header_slots_layout.png`. Tests (Godot 4.3, headless): `test_game.gd` 176/0; `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; `test_arch_v2_ice.gd` 182/0; `test_arch_v2_coverage.gd` 506/0; screenshots 28 (CI count updated). No rules change. (LOG-001: moved "2026-11-21 — RIDER-001, AMEND-001, DEFRAG-001, PLAY-002 after Playtest 10 (Claude Code)" to the archive.)

## 2026-11-26 — ARCH-V2-005d: header slot art wired (Claude Code)

Designer uploaded the seven ChatGPT parts from VAS-ASSET-001 §6e. Trimmed (already transparent), icons squared to 256 px, added to `controls/` and `icons/` with manifest rows. Wired: half plaque and slot rack as nine-slices (both wider than asked), TRACE lights the half housing's ten baked cells, sockets frame the slot contents in their windows, group icons sit in the rack's round socket. Racks 219 px wide (x 748 and 973); slots about 37 × 41 px; the coverage test's slot-size check follows the art (≥ 34 × 38). Tests: `test_arch_v2_ice.gd` 182/0; `test_arch_v2_coverage.gd` 506/0; screenshots 28. No rules change.

## 2026-11-26 — ARCH-V2-006: homes for the remaining encounter UI recorded (Claude Code)

Designer answered the coverage table's open rows (19:12, follow-ups 19:20). Recorded in Master Design ARCH-V2-006 (a)–(g); coverage JSON and `ENCOUNTER_COVERAGE.md` updated (OPEN 0, BATCH3 20); ChatGPT prompts for the eye, Ghostware reel housing and speaker grille added as VAS-ASSET-001 §6f. 19:21: strike lamps under the eye and a LOCKDOWN flyout approved (006h); no log ticker, the log opens from the NEXT RESPONSE rail (006i). No code change.

## 2026-11-26 — ARCH-V2-006: Batch 3 built (Claude Code)

Designer: "start batch 3" (19:22). Built in five commits (3a header, 3b rail, 3c events, 3d cards, 3e speakers/settings/sequencer); every BATCH3 row of the coverage table is BUILT. Details and interpretations: Master ARCH-V2-006 (Batch 3 built). New `test_arch_v2_batch3.gd` in CI. Tests (Godot 4.3 headless): `test_game.gd` 176/0; `test_arch_v2_ice.gd` 204/0; `test_arch_v2_coverage.gd` 535/0; `test_arch_v2_batch3.gd` 94/0; screenshots 36. No rules change. (LOG-001: moved "2026-11-22 — Playtest 11 results (Claude)" to the archive.)

## 2026-11-26 — ARCH-V2-006j: TRACE STRIKE banner removed; Batch 3 interpretations approved (Claude Code)

Designer (20:35): remove the TRACE STRIKE banner, keep the rest under the typography rules; the other Batch 3 choices approved. Removed the banner and its token; the response no longer waits on it. Tests: `test_arch_v2_batch3.gd` 94/0, `test_arch_v2_ice.gd` 201/0. No rules change.

## 2026-11-26 — ARCH-V2-006k: targeting arrow (Claude Code)

Designer (20:37): aim targeted cards with an arrow instead of clicking an ICE. Built `HudWidgets.TargetArrow` and the aim flow in the sandbox (press and hold, arrow to the pointer, ring on the ICE under it, release to play; click mode and Esc/right-click cancel); targeted cards no longer start a plain drag. Tests: `test_arch_v2_batch3.gd` 103/0, `test_arch_v2_ice.gd` 201/0; screenshots 37. No rules change. (LOG-001: moved "2026-11-22 — Playtest 12: PT11 fixes and TUNE-002 (Claude Code)" to the archive.)

## 2026-11-26 — ARCH-V2-006l: PROGRAMs install on the CRT; unplayable cards dim (Claude Code)

Designer (20:47). Built `HudWidgets.CrtDropGlow` and the CRT drop rule (PROGRAMs install only when dropped on the CRT; click still installs); unplayable cards dim more (55 percent), driven by `Game.can_play` after every action. Commit `6f7f208`. Tests: `test_arch_v2_batch3.gd` 110/0; screenshots 38. No rules change. (LOG-001: moved "2026-11-22 — PROBE-004: PROBE choose-one (Claude)" to the archive.)

## 2026-11-26 — ARCH-V2-006m: eye, Ghostware reel and speaker grille art wired; red pupil (Claude Code)

Designer uploaded the three §6f parts. Trimmed, added with manifest rows, wired (eye iris tinted as a ring, pulsing red pupil dot; reel window and arrows on the painted buttons; grilles 96 × 48). Tests: `test_arch_v2_batch3.gd` 110/0, `test_arch_v2_ice.gd` 201/0, `test_arch_v2_coverage.gd` 538/0; screenshots 38. No rules change.

## 2026-11-26 — ARCH-V2-007a: Batch 4 started; corporation rooms through the ICE windows (Claude Code)

Designer supplied 22 `BG_` backgrounds from the art folder (staged from the designer's PC) and chose "Inside the ICE windows". Imported unchanged; built `CorporationLook` (C06), `corp_room.gdshader`, `IcePanel.set_room`, `IceLane.set_room` (one continuous room; HOSTILE blends in with the reveal). New `test_arch_v2_batch4.gd` in CI; coverage row I15. Tests: batch4 23/0, batch3 110/0, ice 202/0, coverage 545/0, test_game 176/0; screenshots 38. No rules change. (LOG-001: moved "2026-11-23 — ARCH-V2-001: architecture migration governance (ChatGPT)" to the archive.)

## 2026-11-26 — ARCH-V2-007b: corporation look on the V2 encounter (Claude Code)

Window enamel and ad plate per corporation (`CorporationLook`), PIXEL-TRACE-001 and MOOD-PIXEL-001 in the V2 windows (`IcePanel.set_trace_pixel`, `apply_mood_look`; Build 12 shaders and timings reused), Build 12's music (`FriendlyMusic`) driven by bleed with the strike chime and effect sounds. Room crop biased to the floor (designer 21:41). Coverage I13, I14 BUILT. Tests: batch4 40/0, batch3 110/0, ice 202/0, coverage 545/0; screenshots 41. No rules change. (LOG-001: moved "2026-11-23 — ARCH-V2-001 blueprint folder drafted (ChatGPT)" to the archive.)

## 2026-11-26 — ARCH-V2-007c: graffiti, punch cards, low VITAE, PATIENT ZERO (Claude Code)

Designer chose the header gap for graffiti and the eye hover for punch cards. Built the graffiti stickers (max two, wrapped), punch cards on the eye hover with an arrival drop, the VITAE warning pulse, and PATIENT ZERO on the ICE windows (`EncounterController.request_choose_ice`). Coverage: every BATCH4 row BUILT except integration. Tests: batch4 53/0, batch3 110/0, ice 202/0, coverage 547/0; screenshots 43. No rules change. (LOG-001: moved "2026-11-23 — ARCH-V2-001 decision history and compliance gate (ChatGPT)" to the archive.)

## 2026-11-26 — ARCH-V2-007d: V2 encounter integrated into the app (Claude Code)

`main.gd` routes ICE encounters to the V2 screen (embedded `IceEncounterSandbox.attach`, `app_phase_changed`, `voice_toggled`); app overlays stay for map, READY RIG before the encounter, DEEPER, reward, SAFEHOUSE, run end; `"legacy_encounter": true` brings back Build 12's encounter. New `test_arch_v2_app.gd` (in CI) 13/0 and `shot_arch_v2_app.gd` (local captures). All suites pass: test_game 176/0, adp 17/0, signal/carbon 672/0, ice 202/0, coverage 550/0, batch3 110/0, batch4 53/0. No rules change. (LOG-001: moved "2026-11-23 — ARCH-V2-001 static source audit (ChatGPT)" to the archive.)

## 2026-11-26 — ARCH-V2-007e: behaviour comparison; Batch 4 complete (Claude Code)

Rules engine and data identical to `prototype-baseline` (git diff empty). New `test_arch_v2_parity.gd` (CI): 30 encounters, 1,560 actions, V2 screen vs Build 12 direct path identical after every action. Fixed: the ResponseSequencer left a response with nothing to fire unfinished. Reported: CORE-LOOP-REWARD-GAP (rules, baseline). Batch 4 tests made timing-independent. Results: test_game 176/0 (SIM=1 too), adp 17/0, signal/carbon 672/0, ice 202/0, coverage 550/0, batch3 110/0, batch4 53/0, app 13/0, parity 1590/0; screenshots 43. RELEASE-002c conditions met. No rules change. (LOG-001: moved "2026-11-23 — ARCH-V2-001 dependency map (ChatGPT)" to the archive.)

## 2026-11-26 — ARCH-V2-007f, CORE-LOOP-REWARD-GAP, Playtest 13 prepared (Claude Code)

Designer (22:12): graffiti removed for now; reward fix approved; prepare Playtest 13. `Game._roll_rewards` falls back to SHARED when a Rustler pool is empty (new rules test: 60 checks; fails 30 without the fix). Parity: 4 Rustlers, 80 encounters, 4,008 actions identical. Flaky timing in the Batch 4 lethal-pulse check fixed (fixed clock). Version 0.13.0-playtest.13; guide and core-loop checklist updated. Tests: test_game 236/0 (SIM=1 too), adp 17/0, signal/carbon 672/0, ice 202/0, coverage, batch3 110/0, batch4 50/0, app 13/0, parity 4088/0. (LOG-001: moved "2026-11-23 — ARCH-V2-001 formal component specification (ChatGPT)" to the archive.)

## 2026-11-27 — RELEASE-002: HALCYON PLAYTEST 13 cut (Claude Code)

Designer (05:49): "Cut the Playtest 13 build: move `release` to `a6f4476`." Fast-forwarded `release` 2845ecd → a6f4476. [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/45985348390) passed: test_game 236/0, adp 17/0, signal/carbon 672/0, ice 202/0, coverage 549/0, batch3 110/0, batch4 50/0, app 13/0, parity 4088/0 (80 encounters, 4,008 actions); 42 screenshots; export with no errors; [artifact](https://github.com/Punkwork/REDLINE/actions/runs/45985348390/artifacts/15191118131) `PANOPTICON-HALCYON-PLAYTEST-13-0.13.0-playtest.13-Windows-x86_64` (6 files, 206.6 MB). Artifact download is blocked from this session; contents verified from the log. Tag `playtest-13` waits on the designer. (LOG-001: moved "2026-11-23 — ARCH-V2-001 VAS-001 visual architecture specification" to the archive.)

## 2026-11-27 — ARCH-V2-008a recorded (Claude Code)

Designer note: add READY RIG to the Ghostware slot for the next build. Recorded in Master Design and HANDOFF (To build). Found: the reel already shows READY RIG first, but as "RR" initials, because `GW_READY_RIG.png` doesn't exist. Not built yet. No code changes, no tests run.

## 2026-11-27 — ARCH-V2-008a built: Ghostware icons in the reel (Claude Code)

Imported the designer's 30 Ghostware icons from `PANOPTICON art/Ghostware Icons` (1254 px → 256 px, 2.5 MB) into `godot/assets/concept/ghostware/`. The reel now shows READY RIG and the other ORIGINs as icons instead of initials. No code change: the reel already loaded `GW_<NAME>.png` by name. Added `test_origin_art` to `test_arch_v2_batch4.gd`. Tests: import 0; `test_arch_v2_batch4.gd` 62/0; `test_arch_v2_ice.gd` 202/0; `test_arch_v2_batch3.gd` 110/0; `shot_arch_v2_ice.gd` 42 captures, 0 script errors. Fixture: `docs/visual/fixtures/arch-v2-batch4/v2_02_ready_rig_reel_zoom.jpg`.

## 2026-11-27 — RUSTLER-SELECT-001: Generalist portrait on the select screen (Claude Code)

Imported `RUSTLER_GENERALIST.png` (1122 × 1402 → 561 × 701) to `godot/assets/concept/rustlers/`. `main.gd` `_overlay_select`: the portrait fills the select button (320 × 400); name, difficulty, quote, style and ORIGIN show on an opaque panel on hover or focus. Tests: import 0; `test_game.gd` 236/0; `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; `test_arch_v2_ice.gd` 202/0; coverage 549/0; batch3 110/0; batch4 62/0; `test_arch_v2_app.gd` 21/0 (6 new checks); parity 4088/0; `shot_arch_v2_app.gd` 5 captures, 0 script errors. Fixtures: `docs/visual/fixtures/rustler-select/`. Note: `shot_arch_v2_app.gd` is not in the CI screenshot list.

## 2026-11-27 — ARCH-V2-008b: END RUN on the V2 encounter screen (Claude Code)

`HudWidgets.EndRunKey` (88 × 24) under END TURN; the sandbox emits `end_run_requested`, which `main.gd` connects to Build 12's confirmation (`_confirm_end_run`); standalone, `EncounterController.end_run()` calls `Game.abandon()`. Found while testing: the V2 hand (z 100), log (150) and inspector (200) drew above the app's dialogs (and the hand could take clicks under them); `main.gd` overlay is now z 300 and its inspector z 310. Tests: import 0; `test_game.gd` 236/0; `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; `test_arch_v2_ice.gd` 202/0; coverage 549/0; batch3 110/0; batch4 62/0; `test_arch_v2_app.gd` 29/0 (8 new END RUN checks); parity 4088/0. Fixtures: `docs/visual/fixtures/end-run/`.

## 2026-11-27 — CAPS-TEST-001: CAPS in the game; CAPTCHA bonus CAP (Claude Code)

Rules: `CardDB.CAPS` (5 commons), `Game.caps` (3 slots), `Game.use_cap` (PLAYER phase only, 0 BW, consumed), `Game.grant_random_cap`; `_finish_node` adds a random common CAP at the CAPTCHA Node's full clear, with a `reward_note` line. V2: `cap_models` reads `Game.caps`; `EncounterController.request_use_cap`; `RackSlot.inject` (click); CRACKER uses the aiming arrow; sockets show a close-up of the vial, hover the full vial (HOVER-001). App: the reward screen shows "CAP ADDED" with the vial. Art: the designer's 12 vials (`PANOPTICON art/CAPS`) at 240 × 720. Coverage H05 PLACEHOLDER → BUILT. Tests: import 0; `test_game.gd` 428/0 (192 new CAPS checks: each effect, consumed, 0 BW, not in the response, CAPTCHA grant over 40 seeds with all five commons seen, full slots, no CAP at CONSENT WALL); `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; `test_arch_v2_ice.gd` 202/0; coverage 548/0 (one fewer placeholder check); batch3 110/0; batch4 75/0 (13 new rack checks); `test_arch_v2_app.gd` 29/0; parity 4088/0; `shot_arch_v2_app.gd` 8 captures, 0 script errors. Fixtures: `docs/visual/fixtures/caps/`.



## SEQUENCE-002 — SEQUENCED revision (designer approved 2026-11-27)
SEQUENCED permits breaks in any order. Each successful out-of-sequence break generates TRACE once if an earlier visible, active subroutine on the same ICE remains unbroken, regardless of how many are skipped. Previously broken, concealed and inactive subroutines do not count. This supersedes mandatory ordered breaking and retires standalone TRIPWIRE. TRACE magnitude remains open for balancing. Design SEQUENCED ICE with low-urgency earlier effects (e.g. INSERT SPAM or DISCARD) and a compelling later target (e.g. PULP 6 or AMEND on supporting ICE, increasing the right-hand ICE's PULP during the response). Examples are design patterns, not approved new ICE profiles. Preview the penalty before committing. Priority 2 representative encounter refinement; implementation and tests pending, no engine changes in this decision.


## TOLL-RETIRE-001 — TOLL retired (designer approved 2026-11-27)
Retire TOLL (additional BW cost for breaking non-DEADLOCK subroutines) from active design, HALCYON expansion and mechanical coverage requirements. It adds resource pressure without sufficient new strategic decisions to justify cognitive load. Preserve historical records; reconsider only with explicit designer approval. Supersedes earlier active TOLL specifications. Priority 2: reconcile rule references and legacy engine support in a controlled implementation batch; no engine changes authorized by this documentation update. Design review principle: mechanical complexity should be earned through strategic depth.


## MINIBOSS-001 — Unique signature abilities / FORTIFY (designer direction 2026-11-27)
Each corporation has one mini-boss encounter, with a signature ability unique to that mini-boss. Reserve FORTIFY (formerly passive HARDENING) for one specific mini-boss as one of three candidate signature abilities; no standard ICE assignment. Existing HARDEN remains a distinct breakable subroutine. FORTIFY candidate retains +1 STR after each Corporation Countermeasure, maximum +3 bonus provisionally; final balance, corporation and ICE identity remain undecided. Signature abilities must justify complexity through strategic depth, agency, synergy, anticipation and cognitive-load value. No production implementation or roster changes in this documentation update.


## MINIBOSS-003 — THE GRID: PROFILE + FORTIFY (designer approved 2026-11-27)
IRONWATCH's mini-boss THE GRID retains its approved PROFILE ability and gains FORTIFY (formerly passive HARDENING), exclusive to THE GRID. FORTIFY grants +1 STR after each Corporation Countermeasure, maximum +3 bonus as a working balance value. PROFILE remains unchanged. Both are unique signature abilities, not breakable or disableable subroutines. Each corporate mini-boss must have at least one unique signature ability; multiple complementary abilities are permitted where strategically justified. Supersedes the single-ability implication of earlier mini-boss records and resolves FORTIFY's assignment. Preserve other mini-boss designs. Implementation and combined balance testing pending; no engine changes in this documentation update.


## WATCHER-EXP-001 — WATCHER removed from standard ICE (designer approved 2026-11-27)
Remove WATCHER from the standard ICE ability pool and HALCYON expansion/representative encounter mechanical coverage. Preserve as an experimental concept: each CLOAK card played generates 1 TRACE. Potential exceptional applications: mini-boss, specialized supporting ICE with meaningful counterplay, or discoverable/circumventable node security condition. None is approved for deployment. Evaluate strategic depth, agency, synergy, anticipation and cognitive load; test defensive deck viability, advance warning and viable counterplay. Design principle: abilities directly penalizing fundamental Rustler actions should be exceptional encounter conditions, not routine obstacles. Detailed experimental ownership: docs/PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md. Supersedes standard WATCHER specifications; preserve historical records. No engine changes or production implementation authorized by this documentation update.


## BOOTING-RETIRE-001 — BOOTING retired (designer approved 2026-11-27)
Retire BOOTING, the passive ability locking DEADLOCK until Rustler turn three, from active design and representative encounter coverage. Mandatory waiting undermines efficient play and agency. Preserve historical records. Designer expressed interest in exploring optional protection of DEADLOCK by another subroutine or ICE, without making its removal mandatory; no replacement mechanic approved. Legacy rule/code reconciliation pending controlled implementation; no engine changes in this documentation update.


## GUARD-001 — Optional DEADLOCK protection (designer approved direction 2026-11-27)
GUARD is a supporting ICE subroutine protecting a linked DEADLOCK on another ICE. Breaking the protected DEADLOCK while GUARD remains unbroken triggers a consequence; breaking GUARD first avoids it. GUARD must never prohibit the DEADLOCK break or become a mandatory breach prerequisite. Exact consequence (candidate PULP or TRACE), magnitude, linking rules, timing and interaction with simultaneous breaks remain open for specification and balance. Supporting ICE need not have their own DEADLOCK. Include GUARD in Priority 2 HALCYON supporting ICE design and representative encounter coverage planning. INTERLOCK and ALARM LINK were unapproved alternatives in the BOOTING review and are not selected for development. No engine changes or final numerical rules authorized by this record.

## 2026-11-27 — CAPS-TEST-001a recorded (Claude Code)

Designer: a full CAP rack should prompt the player to discard one; not needed in the next build. Recorded in Master Design and HANDOFF. No code changes.

## 2026-11-27 — CAPS-TEST-001b: CRACKER hint wording; STR limits tested (Claude Code)

Hint changed to "Drag onto an ICE to inject (0 BW, your turn)." Added checks that CRACKER stops at STR 0 and at an ICE's minimum STR (behaviour unchanged). Tests: `test_game.gd` 430/0; `test_arch_v2_batch4.gd` 76/0.



## REBOOT-SPAM-002 — Breakable reactive subroutine (designer approved 2026-11-27)
Convert REBOOT SPAM from inherent ICE ability to breakable reactive subroutine. Preserve existing effect: each natural or explicitly forced REBOOT inserts one SPAM into the Rustler draw pile while the subroutine is active and unbroken. Breaking it prevents subsequent triggers while broken; it does not independently resolve during ordinary Corporation Countermeasure. No mandatory break prerequisite. Reconcile FREE TRIAL's existing inherent ability with the new subroutine in HALCYON coverage planning; exact TUMBLER slot/pool placement, visibility and rotation interactions require specification before implementation. Preserve historical records. Priority 2; implementation and regression tests pending, no engine changes in this documentation update. Rationale: preserve deck-cycling pressure while giving Rustler direct counterplay.


## REBOOT-SPAM-002a — ICE affinity and activation clarification (designer approved 2026-11-27)
Finalize REBOOT-SPAM-002: VOID is the preferred but not exclusive ICE type; FORTRESS and TUMBLER remain eligible. Each natural or forced REBOOT inserts one SPAM into the draw pile per eligible REBOOT SPAM subroutine. Existing universal subroutine eligibility applies: revealed, active and unbroken; no concealed or inactive triggers, no independent Corporation Countermeasure execution. Apply existing TUMBLER rotation rules without exceptions. Reconcile FREE TRIAL's legacy inherent ability during implementation; exact roster placement and pool composition remain open. Include in Priority 2 mechanical coverage and regression planning. Documentation approval only; engine implementation pending.


## REBOOT-FORGET-001 — LUCIDA-exclusive ability (designer approved 2026-11-27)
Retain REBOOT FORGET as an inherent reactive ICE ability exclusive to LUCIDA: existing REBOOT trigger and FORGET 1 effect retained. Do not convert to a breakable reactive subroutine at this stage. Defer implementation/reconciliation and balance evaluation to LUCIDA development; explicitly exclude from current HALCYON representative encounter milestone. Existing RECURRING DREAM definition and legacy references to be reconciled during appropriate implementation work. No engine changes authorized by this record.


## CHAIN-REP-001 — Representative encounter scope clarification (designer approved 2026-11-27)
Priority 2 representative encounter milestone must fully flesh out, implement and playtest Rustler CHAIN mechanics and their UI. Designer reports current CHAIN operation, activation and effects are effectively invisible. Audit approved rules, current engine and card coverage; identify gaps, specify and validate card sequencing, eligibility, bonuses and feedback; coordinate with UI-TYPO-001/a, M06, CAS-001 and VAS-001. Proposed UI acceptance states: potential, progression where applicable, ready, activated, resolved; icons/hover/focus, pre-action clarity, distinctive motion/audio and reduced-effects support. Exact UI and any new mechanical rules require designer approval; do not invent new CHAIN rules. Include meaningful CHAIN combinations in HALCYON representative encounter and multi-encounter coverage. Separately retain CHAIN PULP (existing 1 PULP per CHAIN bonus) as an IRONWATCH-preferred reactive ability for a future IRONWATCH representative encounter milestone; exclude CHAIN PULP development from current HALCYON milestone, without excluding Rustler CHAIN itself. Existing PATTERN ANALYSIS assignment requires later reconciliation. No engine changes in this documentation update. Preserve current priority ordering and coordinate with Claude Code's ongoing GUARD work.


## CHAIN-002 — Foundational CHAIN revision (designer approved 2026-11-27)
Canonical working specification: [PANOPTICON CHAIN Mechanics](PANOPTICON_CHAIN_MECHANICS.md). Supersedes DSY-011's two-card activation threshold: minimum three cards; third valid card instantiates a CHAIN instance and receives inherent −1 BW play-cost reduction before commitment, plus applicable card-specific bonus. Longer chains permitted; exact eligibility, extension discounts, termination, repeat instances, cost floor/precedence and card balance remain open. CHAIN-REP-001 remains Priority 2; coordinate CHAIN visibility and CHAIN ACTIVATED audiovisual feedback with UI-TYPO-001/a and M06. Existing engine and cards still reflect historical rules until implementation; no production change authorized by this documentation commit. CHAIN PULP remains deferred to IRONWATCH. See canonical specification for examples, audit, questions and acceptance plan.


## CHAIN-002a — Multiple instances per turn (designer approved 2026-11-27)
Multiple independent CHAIN instances may be instantiated within a single Rustler turn, with no once-per-turn activation restriction. Each valid new instance receives its own inherent −1 BW instantiation cost reduction and applicable card-specific bonus. This resolves the repeat-instance eligibility question in CHAIN-002; sequence overlap, reuse of links, termination, extension discounts and any card-specific trigger caps remain unresolved or governed by their existing rules. Illustrative example: two distinct valid three-card sequences in one turn each receive a discount on their third card, subject to affordability and approved eligibility. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-002b — Distinct non-overlapping instances (designer approved 2026-11-27)
CHAIN instances are distinct and cannot overlap or reuse previously played cards as links. A card-play event assigned to one CHAIN instance cannot count toward another; a new instance requires a fresh sequence. This resolves the overlap/reuse question in CHAIN-002 and CHAIN-002a. Example: plays A,B,C instantiate one CHAIN; B,C,D cannot instantiate another. After the first instance ends, three fresh eligible plays can instantiate another in the same turn. Exact termination, extension eligibility and discounts remain open; no new rules about replaying a physical card in a separate play event are established here. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-002c — Turn extension and deck manipulation (designer approved 2026-11-27)
CHAIN's distinctive foundational design identity is momentum: extend the Rustler's turn and expand tactical options through card draw, draw/discard pile manipulation and resource efficiency. Successful sequencing should create opportunities beyond those available at turn start, potentially sustaining the current instance or enabling another distinct instance. This is an approved design principle, not a universal additional payout or final card specification. Preserve the inherent −1 BW instantiation cost reduction separately.
Experimental specialized rewards (designer examples, not approved individual effects): draw additional cards; inspect/reorder/select upcoming cards; recover a discard or place a selected discarded card atop the draw pile; play the top draw-pile card for free; generate extra BW in addition to the instantiation discount. Explore combinations and archetype differentiation. STR/SHIELD/TRACE bonuses remain possible but should not define CHAIN's identity alone.
UI: communicate newly available options, actual draw/recovery/free-play/BW outcomes and their causal relationship to CHAIN; integrate with CHAIN ACTIVATED and localized resolution feedback. Maintain player agency and hidden-information boundaries. Open questions: free-play eligibility/targeting/cancellation, pile selection and visibility, whether generated plays count as fresh links, recursion and loop safeguards, reward magnitude/frequency and balance. No arbitrary cap or automatic effect approved. Acceptance: deliberate sequencing visibly expands actionable choices and can extend a turn without dominant or infinite loops; test against baseline BW3/DRAW6 and multi-encounter fixtures. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-002d — Experiential acceptance (designer approved 2026-11-27)
Design mantra: **Extend the turn. Expand the options. Reward ingenuity.** CHAIN creates confidence, momentum and a sense of mastery, as if the Rustler discovered a new level within a level. Contrast with surveillance-induced anxiety and restriction. Experiential acceptance criterion: the player should not merely understand that they executed a clever combination; they should feel clever for having discovered it. Reward discovery through typography, motion, sound and visible card changes, not solely numerical effects or a flyout. Anticipation, activation and momentum are proposed feedback phases; eligible card indicators, effective cost changes, localized payoff and newly available options should be legible. Specific animation, sound, card treatments and timing remain experimental; coordinate UI-TYPO-001/a, M06 and CHAIN-REP-001. Playtest whether players independently recognize opportunities, perceive the payoff and report confidence/momentum/mastery without obscuring tactical information; reduced effects must preserve information. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-003 — Experimental catalogue and first playtest candidates (2026-11-27)
See [canonical CHAIN specification](PANOPTICON_CHAIN_MECHANICS.md) for all 15 experimental combinations and proposed TAG/TYPE/ACTION/COST grammar. First experimental cohort: OVERCLOCK, SLIPSTREAM, RELAY, BOOTSTRAP, HANDSHAKE, DAISY CHAIN (TAG/TYPE only; free execution requires additional rule review). Priority 2E / CHAIN-REP-001; coordinate M06 and UI-TYPO-001/a. Designer authorized recording and candidate selection, not final card balance or production implementation. Resolve grammar, extension/termination and free-play safety before implementation; later ACTION/COST/mixed signatures retained for exploration. No engine changes.


## CHAIN-003a — Experimental playtest development sequence (designer approved 2026-11-27)
Proceed with the CHAIN-003 six-card experimental programme under Priority 2E / CHAIN-REP-001: (1) OVERCLOCK foundational activation and free draw, (2) SLIPSTREAM and BOOTSTRAP BW generation, (3) RELAY and HANDSHAKE pile manipulation, (4) DAISY CHAIN free execution after legality/recursion review, (5) integrated six-card interactions and multiple distinct instances. Finalize baseline activation, termination and extension rules with designer before implementation. First deliverable: OVERCLOCK mechanically, visually and audibly realized, coordinated with CAS-001 and UI-TYPO-001/a/M06. TAG/TYPE first, ACTION/COST/mixed deferred. Experimental card values and signatures remain subject to playtest; no production implementation in this commit. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md.


## CHAIN-004 — Consecutive card-play eligibility (designer approved 2026-11-27)
Only consecutive card plays determine CHAIN eligibility. Non-card encounter actions leave candidate and active CHAIN state unaffected: Icepick activation/boost, PROBE, CAP activation, inspection and cancelled plays do not insert links or interrupt the sequence. Successful Program installation and Protocol deployment count as card plays, consistent with existing baseline. Example: CLOAK card → PROBE → EXPLOIT card → Icepick activation → OVERCLOCK is consecutive in card-play history and eligible if its proposed signature is approved and satisfied. Existing no-overlap/no-reuse rule remains. Exact catalyst signature grammar, extension eligibility and discounts, incompatible-card termination/new candidate handling, turn/encounter boundary rules remain for explicit review. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-005 — Termination rules (designer approved 2026-11-27)
1. Playing a card that cannot extend an active CHAIN terminates that instance.
2. That card can immediately become the first link of a new CHAIN, without reusing any prior instance links.
3. Ending the Rustler turn or leaving/completing the encounter clears all candidate and active CHAIN state.
4. Termination never reverses previously earned CHAIN bonuses (ordinary effect durations still apply).
Non-card encounter actions remain neutral per CHAIN-004, except explicit turn/encounter boundaries. Termination is automatic; no separate termination action required. These approved rules supersede earlier open termination questions. Extension eligibility, extension discounts and exact catalyst signature grammar remain open. Acceptance: incompatible successful play ends active instance and seeds new candidate; no overlap; turn/encounter boundary clears state; prior rewards retained; non-card actions preserve state. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-006 — Persistent cumulative reward direction (designer endorsed 2026-11-27)
Preferred design direction: sustaining an instantiated CHAIN produces persistent cumulative rewards, encouraging the Rustler to discover an opportunity and rethink their intended turn strategy. Preserve escalating rewards explicitly for experimentation. Compare immediate fixed, banked fixed, immediate escalating and banked escalating delivery. Illustrative per-extension reward schedules: fixed 1,1,1 versus escalating 1,2,3; at six links totals 3 versus 6, assuming rewards begin at link four. Explore draw, BW, pile manipulation and tactical effects. Banked rewards require explicit settlement timing at incompatible play, turn end and encounter completion; cannot retroactively fund the terminating card without a separate rule. Test runaway draw/BW loops, player agency, opportunity cost, feedback and strategic redirection. Exact continuation eligibility, reward amounts, trigger on third link versus fourth, extension discount, settlement ordering and limits remain unresolved. No production mechanics or card values approved by this direction. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md.


## CHAIN-007 / CHAIN-008 — Balance constraints, extension economics and playtest roadmap (designer approved 2026-11-27)
CHAIN-007: Exceptional, not routine. CHAIN complements normal encounter play; powerful extended instances must be earned through sequencing, availability, BW and preparation. Non-CHAIN decks remain competitive. Evaluate rewards against actual ICE threat; test escalating rewards and recursive/self-sustaining draw/BW/recovery loops. No universal length cap unless evidence warrants reconsideration. Track activation frequency, extension length, reward magnitude/efficiency, sustainability, opportunity cost, strategic redirection, encounter relevance and experiential mastery. Numerical thresholds remain experimental.
CHAIN-008: Third card receives inherent −1 BW instantiation discount. Each subsequent eligible card receives the persistent effect defined by the instantiating card, but no automatic BW discount. Explicit card-specific cost effects remain possible. Persistent extension rewards start at link four; separate activation bonuses remain possible. Exact continuation eligibility and activation grammar, cost precedence/zero floor, reward amounts and banked settlement remain open for designer review. Existing CHAIN-004/005 neutrality and termination and no-overlap rules apply.
Approved development roadmap under Priority 2E / CHAIN-REP-001: (1) balance principles; (2) finalize ordered TAG/TYPE activation grammar and cost handling; (3) finalize continuation grammar; (4) concrete card economics using existing cards where possible, actual BW/DRAW, ICE STR/subroutines and incoming damage; (5) implement OVERCLOCK first after rule approval; (6) parallel audiovisual feedback with UI-TYPO-001/a and M06; (7) controlled expansion into BW, pile manipulation, banked and escalating rewards; (8) integrated balance/experience testing across single and multi-encounter nodes. Required scenarios: no CHAIN, three-link, five-link, exceptional eight-link, two independent instances; verify feasibility rather than assume all lengths attainable. Designer/ChatGPT own design and acceptance; Claude Code owns engine/tests/fixtures. No production implementation in this documentation commit; do not implement unresolved rules by assumption. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md.


## CHAIN-009 — Extension precedence for CHAIN-capable cards (designer approved 2026-11-27)
When a CHAIN-capable card is successfully played during an active CHAIN and satisfies that instance's continuation requirements, it extends the existing instance as an ordinary link. Resolve its normal base effect and the active instance's persistent reward; do not instantiate its own CHAIN, grant its own activation bonus or inherent third-link BW discount, replace the active instance, or stack persistent effects. The original catalyst retains ownership of continuation and rewards. If ineligible, apply CHAIN-005 termination and seed a fresh candidate with that play; no prior links may be reused. Exact continuation predicates remain open. Test eligible and ineligible catalyst plays, base effect resolution, no duplicate rewards/discounts, and fresh independent activation. Designer also requested at least three interacting CHAIN-capable cards for the economics playtest; OVERCLOCK, SLIPSTREAM and RELAY are proposed candidates, with specific effects and signatures still experimental. No engine changes.


## CHAIN-010 — Governing design principle (designer approved 2026-11-27)
**Easy to understand. Difficult to assemble. Rewarding to sustain.**
CHAIN rarity should arise from strategic sequencing, card availability, preparation and resource constraints, not opaque rules. Evaluate activation and continuation signatures, card design and UI feedback against this principle, alongside CHAIN-007 and the established momentum/mastery intent. This approval does not finalize any proposed signatures or card values. No engine changes.


## CHAIN-PARK-001 — Designer decision: park explicit CHAIN mechanic (2026-11-27)
Effective immediately, the proposed standalone CHAIN mechanic (CHAIN-002 through CHAIN-010, CHAIN-REP-001 and associated Priority 2E implementation/playtest roadmap) is PARKED / experimental, not an active production requirement or representative encounter acceptance gate. Preserve the complete historical exploration in docs/PANOPTICON_CHAIN_MECHANICS.md as an experimental reference indexed by docs/PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md; do not delete it or treat prior approvals as current implementation authorization. Designer prefers elegant card-local sequencing and emergent synergy, citing Slay the Spire's per-card Block reward as inspiration. Explore existing Protocols as the natural vehicle for persistent conditional/per-card effects; use ordinary card effects for sequencing, draw, BW, pile manipulation and accumulated-action rewards. Preserve momentum, mastery, exceptional rather than routine combinations, resource-loop safeguards and clear audiovisual feedback without a separate CHAIN grammar, catalyst, link tracking or dedicated CHAIN UI requirement. Examples are exploratory, not approved new cards. Representative ICE encounter remains priority; remove standalone CHAIN work from active scope, retain general card synergy as a design exploration. Existing legacy DSY-011 CHAIN code/cards require Claude Code inventory and designer-approved retirement/reconciliation plan before production changes; no engine edits or issue closures in this decision. Future revival requires explicit designer approval.


## SYNERGY-PLAYTEST-001 — Card-local synergy candidates (designer approved for playtest 2026-11-27)
Preserve all ten candidates in the active representative ICE encounter playtest backlog, replacing the parked standalone CHAIN workstream within Priority 2E. Candidate effects below are experimental; costs, rarity, duration, targeting, stacking and balance remain to be finalized. No standalone CHAIN grammar required.

| Card | Type | Candidate effect |
|---|---|---|
| REACTIVE ARMOUR | PROTOCOL | Whenever you play a card, gain 1 SHIELD. |
| COUNTERINTELLIGENCE | PROTOCOL | Whenever you play a CLOAK, reduce TRACE by 1. |
| OVERCLOCK | PROTOCOL | Whenever you play your third card each turn, draw 2 cards. |
| FEEDBACK LOOP | PROTOCOL | Whenever you ZERO an ICE, gain 1 BW. |
| SALVAGE | PROTOCOL | First time each turn you break a DEADLOCK, return a discarded card to your hand. |
| ADAPTIVE DEFENCE | PROTOCOL | Whenever you install a PROGRAM, gain 3 SHIELD. |
| FOLLOW THROUGH | SCRIPT | Reduce ICE STR by 2; reduce by 2 more if previous card played was an EXPLOIT. |
| ESCALATION | SCRIPT | Reduce ICE STR by 1 for every EXPLOIT played this turn. |
| AFTERBURN | SCRIPT | Gain 4 SHIELD if at least three cards have been played this turn. |
| REPRISE | SCRIPT | Repeat the last SCRIPT played this turn, subject to restrictions. |

Playtest individually and in combinations using controlled fixtures; include display/hover readability, Protocol rack status, trigger feedback, card order, resource economics, loop prevention and encounter relevance. Clarify whether the current card counts toward thresholds, trigger timing, replay legality and recursion before implementation. Check existing card names/IDs for collisions. Claude Code to prepare implementation/test plan; no production changes in this documentation batch. Canonical candidate register: docs/REDLINE_DECK_SYNERGY.md. CHAIN-PARK-001 remains in force.


## PROTOCOL-DURATION-001 — Designer-approved lifecycle distinction (2026-11-27)
Deployed PROTOCOLS last the current encounter only; installed PROGRAMS persist across encounters within the current node, subject to existing removal rules. This supersedes earlier node-duration assumptions for Protocols, including SYNERGY-PLAYTEST-001 proposals. Validate encounter completion/transition cleanup, Protocol rack reset and cessation of expired triggers, Program/RAM persistence across two- and three-encounter nodes, and node-exit cleanup. Exact destination of expired Protocol cards and cleanup ordering relative to breach/reward triggers require review against existing lifecycle rules before implementation. Claude Code to audit existing engine, tests, UI and documentation for affected assumptions and include reconciliation in the representative encounter plan. No production code changes authorized by this documentation batch. Other proposed card costs and conventions remain pending review.


## PROTOCOL-DURATION-001a — Expiry destination (designer approved 2026-11-27)
At encounter completion, deployed Protocols expire and return to the discard pile, not BURNED. They remain part of the compiled deck and may be drawn and redeployed through normal card circulation. Installed Programs persist for the node. At the beginning of the next node the Rustler draws a new hand from their compiled deck. This resolves the expiry destination question in PROTOCOL-DURATION-001; exact cleanup ordering relative to breach/reward triggers remains subject to lifecycle review. Test discard destination, no duplicate/lost cards, cessation of expired triggers, Program persistence, and next-node hand initialization. Documentation only; no engine changes.


## PROTOCOL-DURATION-001b — Encounter cleanup timing (designer approved 2026-11-27)
Protocols remain active through final DEADLOCK action and qualifying triggers, BREACH, remaining permitted Runner actions, END TURN and PARTING SHOT, including all associated triggered effects. After resolution and survival confirmation, expire deployed Protocols to discard exactly once, before encounter progression or node completion rewards. Fatal PARTING SHOT grants no successful completion rewards. Installed Programs and RAM allocation persist across encounters in the node. Apply cleanup consistently on normal progression, forced LOCKDOWN progression and early exit; next node draws a new hand from compiled deck. Existing game.gd go_deeper() retains Protocols between layers, a confirmed discrepancy requiring reconciliation. Claude Code to validate trigger ordering, pending choices, fatal response, card conservation, rack reset, Program persistence and next-node initialization with deterministic multi-encounter tests. Existing BREACH-001 parting-shot behavior remains intact. Documentation only; no engine changes or authorization to implement the ten candidate cards before specification review.


## SYNERGY-PLAYTEST-002 — Approved ten-card playtest catalogue (2026-11-27)
Designer approves all ten SYNERGY-PLAYTEST-001 candidates for playtest, with REACTIVE ARMOUR reduced to 1 BW; remaining proposed costs unchanged. No CRED deployment costs. Values are playtest baseline, not final balance.
| Card | Type | BW | Effect |
|---|---|---:|---|
| REACTIVE ARMOUR | PROTOCOL | 1 | Whenever you play a card, gain 1 SHIELD. |
| COUNTERINTELLIGENCE | PROTOCOL | 1 | Whenever you play a CLOAK, reduce TRACE by 1. |
| OVERCLOCK | PROTOCOL | 2 | Upon playing your third card each turn, draw 2 cards. |
| FEEDBACK LOOP | PROTOCOL | 1 | Whenever you ZERO an ICE, gain 1 BW. |
| SALVAGE | PROTOCOL | 2 | First DEADLOCK broken each turn: return a selected discarded card to hand. |
| ADAPTIVE DEFENCE | PROTOCOL | 1 | Whenever you install a PROGRAM, gain 3 SHIELD. |
| FOLLOW THROUGH | SCRIPT | 1 | Target ICE -2 STR, additional -2 if previous card played was EXPLOIT. |
| ESCALATION | SCRIPT | 1 | Target ICE -1 STR per EXPLOIT played this turn including itself. |
| AFTERBURN | SCRIPT | 0 | Gain 4 SHIELD if at least three other cards played this turn. |
| REPRISE | SCRIPT | 2 | Repeat effect of previous SCRIPT played this turn. |
Protocol lifecycle PROTOCOL-DURATION-001/a/b mandatory. Successful card plays count, not Icepick or CAP activations; no Protocol self-trigger on deployment; independent copies, no additional trigger cap initially except printed limits. REPRISE repeats effect, not card-play event, cannot repeat itself; Claude Code must audit targeting, recursion, pending choices and legality, flag unresolved semantics rather than silently inventing rules. STR reductions encounter duration. No standalone CHAIN mechanic.
All ten must be obtainable through normal node completion card rewards in the representative playtest (audit CORE_POOL/reward eligibility and rarity configuration). Designer also proposes UPLINK node to ensure specific cards are accessible for testing; recommended test-only fixed inventory of all ten, affordable CRED purchase prices, placement before subsequent combat, exact prices/placement and existing UPLINK architecture audit pending. Do not treat temporary inventory/prices as final economy. Preserve organic reward acquisition alongside deterministic fixtures and targeted purchase access. Include two-/three-encounter nodes, card display/hover, rack, trigger feedback, acquisition, deck persistence, lifecycle, loop prevention and regression tests. Priority 2E Card Synergy and Protocol Development; coordinate with representative encounter and typography/motion. Claude Code owns implementation and validation; this commit approves playtest content and reward inclusion, records UPLINK proposal for implementation planning, does not itself modify engine or authorize unrelated map expansion.


## SYNERGY-PLAYTEST-002a — OVERCLOCK revision (2026-11-27)
Designer adds +1 BW to OVERCLOCK's approved effect: upon playing your third card each turn, draw 2 cards and gain 1 BW. Retain 2 BW deployment cost, encounter duration, once per turn per deployed copy, and all other SYNERGY-PLAYTEST-002 conventions. Supersedes the draw-only effect. Include immediate BW availability, trigger frequency and resource-loop tests. Documentation only; no engine changes.

## 2026-11-27 — PHIL-SURV-001 / TRACE-DEF-001 / UPL-IDENTITY-001 / PHIL-CONSENT-001 (ChatGPT)
Designer explicitly approved the four linked design decisions. Updated Philosophy, Core Rules, Uplink, Experimentation, Master Design and Handoff. Documentation only; no gameplay changes or engine tests. LOG-001: moved 60 oldest whole dated entries unchanged to the end of the archive.
Interpretations to confirm: exact pricing and disclosure mechanics remain experimental.

## 2026-11-27 — ECON-TRACE-001 / ECON-MARKET-001 (ChatGPT)
Designer approved proportional TRACE premiums, independent random market variation and Identity Verification incentives. Updated Uplink, Experimentation, Philosophy, Master and Handoff. Documentation only; no engine tests.


## NODE-PURPOSE-001 — Non-combat Node service redesign (APPROVED 2026-11-27)

Designer-approved amendment; supersedes conflicting earlier service descriptions, not MAP-003e route composition.

- Uplink (commerce): eight cards, exactly five common, two uncommon, one rare; six shared and two Rustler-specific across those eight. Base prices 40/60/90 CRED; one random card 50% off. No basic cards, rerolls or repeat purchase of a slot. Three random CAPS, existing 60/30/10 rarity probabilities, no guaranteed rarity; existing prices and bootleg rules retained. WIPE and Clinic unchanged; existing market variability, TRACE premium and voluntary Identity Verification direction retained. REFACTOR removed from Uplink.
- Console Lab (deck engineering): PATCHWORK and FUSE retained; REFACTOR is the collective modification concept. Standalone card removal belongs to Uplink WIPE. Detailed modification eligibility, repeat limits, recursive fusion, cross-modification, scaling, costs and per-visit limits deferred to dedicated review; do not infer new rules. COMPILE moved to experimentation, excluded from active development/gameplay; preserve prototype work and audit dependencies before disabling.
- SAFEHOUSE (physical recovery): choose one free service per visit: PATCH UP restores 30% of maximum VITAE, capped at maximum; FORTIFY increases maximum VITAE by 6% and current VITAE by the same increment. Both round to nearest whole integer; FORTIFY cumulative for the run, no additional cap currently. No card upgrades or TRACE reduction.
- DEAD DROP (surveillance evasion): choose one free service per visit: WIPE TRAIL reduces current TRACE by 20, floor zero; GHOST TRAIL reduces incoming TRACE by 50% throughout the next ICE Node, all encounters included, persists through intervening noncombat Nodes and expires on ICE Node exit. Active-effect icon direction. Fractional TRACE rounding, stacking and edge cases remain open; no physical healing.
- SIGNAL UNCLEAR (discovery): retain ten-event catalogue provisionally; specific event unknown on entry approach, choices except AMBUSH, communicate costs and consequences before commitment. Separate event design review deferred; existing reveal exceptions remain subject to review. Incidental overlap is permissible, not a predictable substitute for dedicated services.

Map redesign deferred to Claude Code/Codex review; MAP-003e remains baseline. Representative ICE encounter remains priority 1. Uplink implementation specification still requires transaction/inventory edge cases and UI review. No engine implementation authorized by this documentation amendment.


## MAP-003f / MINIBOSS-003 — Approved 2026-11-27
Every complete route must contain 2–3 Uplinks, at least one each SAFEHOUSE, DEAD DROP, Console Lab, SIGNAL UNCLEAR, exactly seven noncombat Nodes. All other MAP-003e constraints remain. Valid distributions in that order: (3,1,1,1,1), (2,2,1,1,1), (2,1,2,1,1), (2,1,1,2,1), (2,1,1,1,2). Distinct Mini-Boss icon identifies category only; identity and unique ability concealed until entry; fight mandatory on entry. Supersedes pre-entry ability disclosure. Claude Code assignment: audit Python prototypes/map/map003_generator.py V4, implement V5 retaining V4 comparison, deterministic seeds, bounded attempts, validate every route of at least 200 accepted maps, no unreachable nodes/dead ends, report acceptance rate, performance, route counts, distribution frequencies, miniboss accessibility/bypass and reproducibility. GDScript port and UI integration subsequent tasks; no engine changes in this assignment. Representative ICE Encounter remains priority 1.


## UPLINK-SPEC-001 — Approved functional development specification (2026-11-27)
Build on NODE-PURPOSE-001. Generate inventory on entry, seeded, no refresh, eight unique nonbasic cards exactly 5 common/2 uncommon/1 rare and 6 shared/2 current Rustler-specific; one uniformly random half-price card. Three unique CAPS, including no standard/bootleg equivalent duplication, existing rarity probabilities and bootleg rules; no guaranteed rarity. Insufficient eligible pool: explicit test configuration error, no silent relaxation. Sold slots remain visible and unavailable. Developer-only inventory override for approved Protocol/Script playtest. Base prices and WIPE escalation/Clinic bulk discount unchanged. Independent per-item/service market variability ±5% and TRACE premium additive to base; apply discounts afterward, round final price nearest whole CRED except Clinic retains round-up convention. All commercial transactions affected; lock modifiers/prices on entry (Clinic quantity determines total). Identity Verification modifier extension point only; gameplay deferred. Atomic transactions: insufficient funds disable purchase; card goes to compiled deck, CAP to rack; full rack offers confirmed replacement, cancellation changes nothing. WIPE eligible non-HARDWIRED card selection and confirmation, once per visit; Clinic quantity selection and confirmation. No combat turn or reshuffle on entry/exit; exit to map. UI mechanical console reusing V2 components, hover/contextual details, no new market meters; proposed UPL-UI-001 through 010 roles: chassis, card inventory, CAPS inventory, service counter, CRED, deck inspector, price indicator, transaction flyout, CAP replacement, exit. IDs/layout subject to register audit and UI approval. Separate presentation/controller/inventory/pricing from existing run state; no duplicate state or unnecessary encounter changes. Playtest uses MAP-003f generator, not bespoke five-node route; validate inventory, pricing, sold state, cancellation, purchases, full rack, WIPE escalation, Clinic, persistence across visits and subsequent encounters, regression and Windows playtest. Technical dependency audit pending; no code changed by documentation commit.


## UI-IDENTITY-001 — Architecture communicates allegiance (approved 2026-11-27)
**Architecture communicates allegiance.** The physical and visual construction of an environment should communicate its relationship to institutional power, surveillance and individual autonomy. Corporate environments express standardization, order and institutional authority; the Underworld expresses salvaged, adapted technology, individualism and clandestine commerce. Distinction extends beyond palette to architecture, materials, lighting, atmosphere and psychological experience. The Underworld is not necessarily safe or beyond surveillance. BG_NODE_UPLINK_UNDERWORLD.png is the principal artistic reference for the Black Market Uplink.

**Shared functionality. Distinct visual identity.** Reuse genuinely shared behavior, data bindings, transaction logic and interaction mechanisms, not necessarily visual presentation. Each Node may have its own artwork, materials, physical controls, animation and sound. Maintain interaction consistency without visual uniformity; never let component reuse dictate artistic direction or force premature abstraction. Apply this principle to Uplink decomposition and future Architecture V2 UI work. No implementation or asset changes authorized by this design record.


## UI-INSPECTOR-001 — Universal Object Inspector (approved direction 2026-11-27)
Game-wide shared hover/rollover inspector. Enlarged object/card image anchored left, preferably top-left; all explanatory text in right-hand column, right-aligned. Name/classification, mechanical effects, supplementary costs/restrictions as applicable; flavor quotation at bottom where applicable, subordinate to mechanical information. Omit irrelevant fields. Support cards, CAPS, Ghostware, ICE, Nodes, services and status effects with contextual content and disclosure restrictions. Shared functionality, environment-specific presentation per UI-IDENTITY-001. This is the first representative component for typography and motion design system development. Next: audit existing hover components and UI issue register, define content contract, prototype typography hierarchy and motion states, review edge avoidance/dismissal/activation timing and input accessibility, obtain designer approval, then implementation and regression validation. Representative ICE Encounter remains priority 1; typography/motion work proceeds alongside it. No final font, animation timing, component register ID or implementation file structure approved yet. No code changes in this documentation commit.
