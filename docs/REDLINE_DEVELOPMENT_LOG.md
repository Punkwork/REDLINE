# PANOPTICON — DEVELOPMENT LOG
**Initialized:** 2026-11-09  
**Policy:** append dated entries; distinguish reported outcomes from verified tests.

**LOG-001 (2026-11-16):** entries from 2026-11-08 to 2026-11-14 are in `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md`, unchanged. Keep this file under about 60 KB (HANDOFF, "How we work" 6).

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

## 2026-11-17 — PULP-001: curves keep their patterns and show their next value (Claude)

**Designer:** approved Claude's recommendation ("Yes, record it that way."). PULP-002 curves A/B/C do not get the ±2/±3 roll; all curves show their next value before firing, so curve B drops "PULP ?". Recorded in the master design doc and Core Rules §5.2; HANDOFF build row updated, WAITING row closed. **Code changes:** none.

## 2026-11-17 — READ-001 extended to PROTOCOL; PULP-001 swing direction (Claude)

**Designer:** "yes, apply the same contrast fix as script" for PROTOCOL, whose blue-green face measured amber 4.18:1. `card.gd` now applies the soft face shade per type: SCRIPT #2A1C10 at 55%, PROTOCOL #0C1E1C at 45% (fitted to the face measured from `protocol.png`, 14,28,136,182). Measured after: PROTOCOL amber 6.68:1 / ivory 9.62:1; SCRIPT 6.69 / 9.64; PROGRAM unchanged 6.91 / 9.97. Validation: rules 357/0, cartridge UI 625/0, Chrome stages 1–5 0 failures; cards-001 and chrome-001 fixtures refreshed. Committed with [skip ci].
**Designer:** "big swings equally likely up and down is okay" (PULP-001 ±3 sign 50/50), recorded in the master design doc. The start-of-turn roll timing and equal odds within −2..+2 remain working values.

## 2026-11-17 — Archive retired branches (Codex)

At the designer's request, pushed and verified annotated archive tags for `docs/simplified-design` (`c42adc5`), `dev/training-node` (`61c1a8b`), `codex/playtest3-windows-smoke` (`af580e2`) and `backup/pre-authoritative-docs-2026-11-10` (`c87436e`). Verified the other eleven tips were ancestors of `main` before deleting all fifteen remote branches. Only `main` remains. PRs #1 and #3 are closed. Posted the archive link on PR #1 and updated the repository structure reference. LOG-001 moved the oldest whole entries to the archive unchanged.

## 2026-11-17 — FACADE-001: Raygun Gothic facades for IRONWATCH and LUCIDA proposed (Claude)

**Designer instruction:** fit the Raygun Gothic direction to the corporation backgrounds and ICE. Added `REDLINE_CORPORATE_FACADES.md` (PROPOSED): a three-degrees table (HALCYON home / IRONWATCH street / LUCIDA mind: what each asks for, remembers and rewards); a shared Raygun Gothic kit; for IRONWATCH a civic security concourse (searchlight-fan motif) and for LUCIDA a wellness solarium (halo-orbit motif), each with a same-perspective hostile reveal, plaque colours (contrast checked: ink 13.8 / 12.6:1, accent 5.6 / 7.1:1), non-fight interface copy, strike and Mask-off lines, and every main-roster, Opening, Central and Black ICE as an appliance with silhouette, face, DEADLOCK button and cheery/wary/lethal lines; art-generation briefs matching the HALCYON asset format, with prompts to be recorded at generation time. Pointers added to Visual Language §2.3 and ICE Corp 2/3 §1; HANDOFF WAITING row FACADE-001. Nothing approved; master design doc unchanged. **Code changes:** none.

## 2026-11-17 — Playtest checklist v0.3 and the live QA Sheet (Claude)

Closes HANDOFF "Checklist v0.2". The live Sheet (claude.ai artifact "REDLINE Playtest QA Checklist", last changed 2026-11-15) was still on v0.1.1: updated B1/C1/K1 targets to the PACE values and added C9–C11 and G6–G11. `REDLINE_PLAYTEST_CHECKLIST.md` is now v0.3 with checks for today's decisions: C12–C14 (rolled PULP shown and dealt, plannable swings, curves show next value), C15 (TUMBLE-001), C16 (ICE-AUDIT-001), D4 (RIOT-003), L5 (READ-001), L6–L8 (moods, corporation states, visual coherence), M5 (DEPRECATE-001); the Sheet carries the same 82 rows. HANDOFF: PR #1 row closed (archived by Codex in 65a47f2). **Code changes:** none.

## 2026-11-17 — DEPRECATE-001: remove LOGIC BOMB and RELAY (Codex)

Removed the card and passive from runtime. CONSENT FORM retains its STR and subroutines. Updated regression coverage and replaced the rare SCRIPT sample with PAYDAY.

**Interpretations to confirm:** The slice has no persisted run decks, so no legacy LOGIC BOMB runtime definition is needed. PAYDAY is the replacement sample.

## 2026-11-17 — ICE-AUDIT-001: apply HALCYON slice changes (Codex)

Applied the five approved ICE edits. DOORBELL CAM uses the existing VOID reveal progression and keeps WATCHER. Updated regression fixtures for the new values. Rules suite: 357 passed, zero failed.

## 2026-11-17 — PULP-001: publish FORTRESS rolls before the response (Codex)

A seeded roll at the start of the Rustler turn is shared by the ICE, response strip, mood and resolution. PULP-002 curves keep their sequences and publish the next value, including curve B. SCRAMBLE applies after the roll.

**Interpretations to confirm:** Each eligible unbroken subroutine gets an independent roll at turn start, even if the response is later skipped. Revealed effects drive mood; a hidden CORTEX subroutine does not tip off the player.

## 2026-11-17 — Validate HALCYON and refresh fixtures (Codex)

Godot 4.3 import passed, as did all 363 rules checks and all nine screenshot scripts, including 173 Friendly Lie and 621 cartridge checks and all five Chrome stages. Refreshed VIS-001, CHROME-001 and the three CARDS-001 encounter captures. The rare PAYDAY close-up was replaced in DEPRECATE-001. The other card close-ups matched their committed renders byte-for-byte. Design reference images were preserved.

VIS-001 turn 3 now shows wary AUTO-RENEW and wary CAPTCHA, with TRACE 2 and TRACE 3 on CAPTCHA. CHROME-001 02b shows lethal AUTO-RENEW from its rolled PULP 6 and wary CAPTCHA with those same TRACE slots. CHROME-001 04a/04b start at turn 1 with wary mascots. In 04c, Mask Off still forces all mascots lethal.

Seeds 100–129 per Rustler. Deaths are by Node and exclude 3,000-step guard stalls. No balance changes were made in response.

| Rustler | Clears (baseline → now) | Deaths by Node (baseline → now) | Mean survivor VITAE |
|---|---:|---|---:|
| GENERALIST | 25 → 21 | CAPTCHA 2 → 6; TERMS & CONDITIONS 1 → 1; DOORBELL 0 → 2 | 16.2 → 17.0 |
| ECHO | 17 → 11 | CAPTCHA 3 → 4; TERMS & CONDITIONS 9 → 14; CONSENT WALL 1 → 1 | 9.5 → 11.8 |
| RIOT | 25 → 13 | CAPTCHA 4 → 3; TERMS & CONDITIONS 1 → 6; DOORBELL 0 → 7 | 15.2 → 16.2 |
| VECTOR | 20 → 17 | CAPTCHA 6 → 2; TERMS & CONDITIONS 4 → 10; DOORBELL 0 → 1 | 10.7 → 11.5 |

The baseline had two GENERALIST stalls. This run had one RIOT stall at DOORBELL. Adding rolls to the seeded Game RNG changes which random draws are consumed by other systems, so this comparison measures the combined changes.

**Interpretations to confirm:** Kept the existing chronological PNG filenames even where the named mood now belongs to a different ICE or is absent. The four-type still comparison has no affected card or encounter state. No Windows build was started.

LOG-001 moved the oldest whole live entries to the archive unchanged.

## 2026-11-17 — FACADE-001 approved (Claude)

**Designer:** "Correct. Approved." `REDLINE_CORPORATE_FACADES.md` is approved as written and recorded as FACADE-001 in the master design doc (three degrees of watching; IRONWATCH concourse and LUCIDA solarium with their hostile reveals; plaque colours; interface copy; ICE appliance list; art briefs). Status lines updated in the facades doc, ICE Corp 2/3 and Visual Language §2.3. HANDOFF: FACADE-001 moved to *Done*; its open questions 4–6 (HALCYON copy, when to generate art, escape ICE) remain WAITING. No art generated yet. **Code changes:** none.

## 2026-11-17 — FACADE-001 follow-ups: HALCYON copy, art now, escape ICE later (Claude)

**Designer:** "for number one, yes. For number two, yes. And for number three, wait." Wrote §2a in `REDLINE_CORPORATE_FACADES.md`: HALCYON's motif (sunrise fan) and non-fight copy (consent, remembered, reward proposed; status, cracking, strike and Mask-off lines reuse approved VIS-001 copy). Art for IRONWATCH and LUCIDA is to be generated now: HANDOFF Codex TO DO FACADE-ART-001. Escape ICE deferred. Master design doc FACADE-001 updated; HANDOFF WAITING row for the HALCYON copy review. **Code changes:** none.

## 2026-11-17 — FACADE-ART-001: IRONWATCH and LUCIDA art (Codex)

Generated the 1586 × 992 concourse and solarium pairs from the approved briefs. Both hostile scenes were edited directly from their friendly originals. Cropped fourteen transparent Opening and Tier 1 shells from the two generated sheets. Recorded exact prompts, both hostile edits, the IRONWATCH retry, and references in `godot/assets/friendly_lie/chrome/SOURCES.md`. The skins provide the new art, opaque porcelain and pearl plaques, and approved Cracking and Strike copy. Escape ICE art is deferred.

Validated with Godot 4.3 import, 363 rules checks, and eight `shot_facade.gd` captures in `docs/visual/fixtures/facade-001/`. Lowest measured plaque contrast, including the Strike scrim, was 5.20:1 for IRONWATCH and 5.47:1 for LUCIDA. No plaque contains image textures. HALCYON's existing Friendly Lie regression passed 173 checks. No Windows build.

**Interpretations to confirm:** FRONT DESK and INTAKE are presentation fixtures using their documented Opening ICE. They hold their roster across the four states to review the artwork without implementing a new route or Black ICE. Mask Off previews the hostile environment and mood. The hostile edits maintain visually aligned framing, with small local rendering differences.

## 2026-11-17 — FACADE-001: HALCYON non-fight copy approved (Codex)

Designer approved the consent, remembered activity and reward lines as written in Facades §2a and will review them in playtesting. Recorded the approval in the master design and moved the decision to Done in HANDOFF.

## 2026-11-17 — HALCYON PLAYTEST 4 Windows build (Codex)

Godot 4.3 pre-flight passed 363 rules checks and all ten screenshot scripts (five Chrome stages, 173 Friendly Lie checks, 621 cartridge checks). Seeds 100–129 reproduced 21/11/13/17 clears and 17.0/11.8/16.2/11.5 mean survivor VITAE for GENERALIST/ECHO/RIOT/VECTOR. One RIOT run stalled at DOORBELL.

Tagged `b6b0971e017e6e88929ff1a4a6e67cadfaa2f516` as `playtest-4`. [Actions validation and export](https://github.com/Punkwork/REDLINE/actions/runs/44202252857) passed and uploaded `PANOPTICON-HALCYON-PLAYTEST-4-0.4.0-playtest.4-Windows-x86_64`. Verified `BUILD_COMMIT.txt`, the guide and checklist v0.3, and the executable SHA-256 `3736797caa582f92110473758f235397fe16b12373ea6f829d51b8bf8b16d8b2`. Windows launch and playtest are pending with the designer.

## 2026-11-17 — Playtest checklist v0.4 for HALCYON PLAYTEST 4 (Claude)

**Designer instruction:** update the REDLINE Playtest QA Checklist with appropriate changes for the new build. `REDLINE_PLAYTEST_CHECKLIST.md` v0.4 and the live Sheet (now 84 rows) both: tie to build b6b0971 (`playtest-4`); add A3 (confirm build and BUILD_COMMIT; scope is HALCYON's first four rows, so IRONWATCH, LUCIDA, Central Node H3/J1/J2 and whole-corporation totals G5/I2/K2 are N/A) and L9 (Icepick drag feedback, CHROME-001); drop the *(after …)* marks on C12–C14, C16 and M5 now that they're built, with the built details (turn-start roll, SCRAMBLE, DOORBELL CAM reveal order, AUTO-RENEW STR 5 vs CAPTCHA STR 4). Run log gains a Build column. **Code changes:** none.

## 2026-11-17 — Atomic Deco Punk design direction (Codex)

Recorded the designer’s term and brief in the master design document. The direction covers corporate scale alongside hand-built elektronix, with visual design leading the tone, language, sound and emotional experience. Sound examples are directions to explore in playtesting. LOG-001 moved the oldest whole live entries to the archive unchanged.

## 2026-11-17 — ADP-001 Phase 1 (Codex)

- **ADP-1a.** Pure presentation bleed curve, 400 ms ease, instant reduced motion and a TRACE-tag bleed readout. Added table and easing tests.
- **ADP-1b.** Linked the Cracking reveal to bleed, from 20% at TRACE 20 to 60% at TRACE 39. Strike and Mask Off retain the full hostile background.
- **ADP-1c.** Added a perimeter-only wear shader, lifted tape, and decorative barcodes on Node and TRACE. The barcode flicker stops with reduced motion.
- **ADP-1d.** Three synchronized synthesized stems, tempo-preserving corporate pitch DSP, strike chime, and saved music level and mute.
- **ADP-1f.** Added Poiret One and OFL provenance. Only the corporate wordmark (36 px), background line (28 px), and strike headline (68 px) use the face.
- **ADP-1e.** Added mechanical sounds for accepted card play, Icepick drag, completed breaks, END TURN and Bloatware insertion. Hover is silent.

The full Godot 4.3 rules suite passed unchanged after each task (363 checks). The phase added 17 unit checks and 448 capture, contrast, and interaction checks. The four PNGs and 11-second in-engine MP3 are in `docs/visual/fixtures/adp-001/`. No Windows export.

**Interpretations to confirm:**
- The rig shader treats the outer 3 px and a shadow offset up to 2 px. Tape lifts outside the lower corner and the barcode flicker starts above 0.6. The 0.40 still captures the midpoint of the eased 20-to-39 TRACE reveal.
- The short synthesized cues, mix points, LFO rates, and gains are placeholders in `godot/data/atomic_deco_punk.json`. The parallel corporate DSP feed shares the synchronized transport because Godot 4.3 exposes gain only on its synchronized tracks. Reduced motion also disables pitch wobble. Music mute covers the stems and strike chime. Mechanical sounds remain audible.
- The facade headlines use “Good morning.”, “Your block is safe.” and “Breathe in.” on solid corporate displays. The HUD checks verify the new display and readout colours. The inherited noninteractive Strike underlay remains dimmed.
- “Card seated” means an accepted hand play. A relay clunk marks a completed break, and a tape tear marks an insertion batch, including the first strike's TRACER.

LOG-001 moved the oldest whole live entries to the archive unchanged.

## 2026-11-17 — ADP-001 Phase 1 confirmations (Codex)

Designer confirmed all four implementation interpretations from `53b00d7`: rig wear and the midpoint fixture, placeholder mix and reduced-motion audio behavior, Poiret One copy and sizes, and mechanical cue triggers. Recorded the approval in the master design document.

## 2026-11-17 — HAND-CLEANUP-001 and CARD-CONTROLS-001 (Codex)

Removed free HOLD and documented non-CACHED discard and base draw of six. Moved installed PROGRAMs to a left HUD bay with inspection and controls. Added drop zones for PROGRAMs and SCRIPTs and centered right-click inspection at 150%. Preserved existing response order, card-granted CACHE, draw modifiers and keyboard play. Windows export deferred.

**ENCOUNTER-DISPLAY-001:** Anchored all backdrop layers to the viewport. Scaled ICE avatars and faces to 125%, with separate rules plaques.

**Validation:** Godot 4.3 import and 361 rules checks passed. The ADP fixture passed 471 checks, including the wide encounter, backdrop layers and avatar scale.

LOG-001: The oldest entry, ZEROED-001 and TUMBLE-001 readings confirmed (2026-11-16), moved to the archive unchanged.

## 2026-11-17 — HALCYON PLAYTEST 5 Windows build (Codex)

Exported `0.5.0-playtest.5` for Windows x86-64 from `98bad5f411adc9d30f59c4443288f9473a0067b9` (tag `playtest-5`). Local Godot 4.3 import passed, along with 361 rules checks, 17 ADP checks and all 11 screenshot scripts. GitHub Actions validated the push and uploaded the artifact. The downloaded `BUILD_COMMIT.txt`, README and QA checklist v0.5 matched the source, and the executable's SHA-256 verified as `f70ee7a007e564bbe78d5a7546a5756a08bad48a7513d9bfdca479d92221c0dd`. Windows launch and playtest remain pending with the designer. [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/44232607877) · [Windows artifact](https://github.com/Punkwork/REDLINE/actions/runs/44232607877/artifacts/14395388972)

| Rustler | Clears / 30 | Deaths by Node | Survivor mean VITAE | Stalls |
|---|---:|---|---:|---|
| GENERALIST | 19 | CAPTCHA 6, TERMS & CONDITIONS 5 | 13.0 | 0 |
| ECHO | 13 | TERMS & CONDITIONS 14, CAPTCHA 1, DOORBELL 2 | 13.8 | 0 |
| RIOT | 16 | DOORBELL 4, CAPTCHA 3, TERMS & CONDITIONS 5 | 18.4 | 2 at DOORBELL |
| VECTOR | 15 | CAPTCHA 5, TERMS & CONDITIONS 9, CONSENT WALL 1 | 11.2 | 0 |

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — VIS-001: visual language "The Friendly Lie" handed to Codex (Claude).

## 2026-11-18 — ZINE-002, ARCH-001: the zine as samizdat; the Archipelago (Claude)

Design session in claude.ai, synced to the repo the same morning. **Atompunk (ADP §1.1):** the designer asked whether *atompunk* names the style. It covers the corporate half but not Deco or the DIY punk layer; **Atomic Deco Punk stays**, "atompunk" is the outward pitch shorthand. **ZINE-002 (direction):** the zine is how the underworld communicates, in samizdat's lineage, with the reasons it exists made explicit (every channel owned and listening, speech becomes data, the record is rewritable, the traced vanish, nobody speaks plainly): censorship by convenience, not prohibition. **ARCH-001 (APPROVED):** being traced means disappearing to the Archipelago. Designer: ARCH-R1 tone rules "1 y" (horror by absence, never a joke, corporations never name it, "gulag" never on screen); defeat framing and persistent THE CARBON record "2 y"; the islands are for "merging man with the machine one at a time, in order to build the synchronization signal to sync/merge all mankind at once with AI, tie into ending, sync testing"; no one comes back "4 no". **Docs:** `REDLINE_ATOMIC_DECO_PUNK.md` v0.8 (§1.1, §2.2, links in §4–§8); new `REDLINE_ARCHIPELAGO.md` v0.2; master design §1, §8 and §10; HANDOFF (ARCH-001 build note, a WAITING row for the working copy). **Interpretations to confirm:** the island names, *THE CARBON*, *NOTES FROM THE ARCHIPELAGO*; the historical summaries were written from general knowledge. **Code changes:** none. **Tests:** none.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — ZEROED-001: Restore STR floor and track once-per-ICE ZEROED (Codex).

## 2026-11-18 — ARCH-NAMES-001: islands named like care homes (Claude)

Designer: "The island names should resemble names of long-term care residences and the more generic the name the better." `REDLINE_ARCHIPELAGO.md` v0.3 §4.0: generic nature-word + residence-word names, no ™ or brand in the name, the corporation only in small print; a working pool of nine names (Sunnyside Manor, Pine Ridge Residence, Willow Creek Lodge and others) and revised relocation lines; the defeat notice names the island. Master design ARCH-001 and the HANDOFF copy row updated. **Interpretations to confirm:** the name pool, the small-print lines, and checking final names against well-known real care chains. **Code changes:** none. **Tests:** none.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — ZEROED-001-cards: Replace INTEGER UNDERFLOW with NULL POINTER and add RIOT ZEROED cards (Codex).

## 2026-11-18 — ARCH-LINES-001: relocation lines and programme names approved (Claude)

Designer left the relocation lines to Claude's discretion ("generate a number of them, let's say 10 or 15, and I will review and approve"), then approved all 15 and the proposal to keep the first-draft names as programme small print ("Perfect- add them"). `REDLINE_ARCHIPELAGO.md` v0.4 §4.0: 15 numbered lines, five per corporation; small print *Halcyon Homesteads™*, *SafeHarbor Residences™*, *Long Rest Retreats™* under the generic island names; the defeat notice uses one approved line. Master design and HANDOFF updated (commit 7eeb5a7); the island name pool and anti-paper lines are still waiting. **Interpretations to confirm:** "Perfect- add them" read as approving both the 15 lines and the programme names; the small-print wording (community / property / home). **Code changes:** none. **Tests:** none.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — TUMBLE-001: Remove broken TUMBLER subs and tumble immediately active replacements (Codex).

## 2026-11-18 — ARCH-SLANG-001: the Rustlers say ’Pelago (Claude)

Designer: "In all Rustler references to the archipelago should be written as pelago with an apostrophe before the P." `REDLINE_ARCHIPELAGO.md` v0.5: tone rule 6; every on-screen Rustler/underworld reference (THE CARBON, *NOTES FROM THE ’PELAGO*, NUL/REM, graffiti, map, reveal) uses ’Pelago with U+2019; the full word stays in docs only; ARCH-1c guards updated (no "Archipelago" on screen; no "’Pelago" in corporate or rules strings). Master design and HANDOFF updated; the SAMIZINE design canvas updated to match. **Interpretations to confirm:** the full word never appears on screen, the reveal included. **Code changes:** none. **Tests:** none.

## 2026-11-18 — ARCH-SLANG-001 confirmed: ’Pelago even at the end (Claude)

Designer: "Don't use the term archipelago, except in game documents. Pelago is the official in-game terminology to be used even at the very end." Closes the interpretation from the previous entry: the reveal says ’Pelago too. `REDLINE_ARCHIPELAGO.md` rule 6 and §6, and the master design, updated. **Code changes:** none. **Tests:** none.

## 2026-11-18 — ZINE-003: SAMIZINE, the underworld's zine look (Claude)

Designer: "Let's build a unique new look for the zines in this game, a mashup between zines and samizdat. Something never before seen." Built as a design canvas (https://claude.ai/artifact/G84PwRDUPwMSvAYkBxmudW) with five boards: style sheet, THE CARBON #14 cover, the ledger page, NOTES FROM THE ’PELAGO over a Sunnyside Manor brochure, copy generations 1–5. Review rounds: (1) the rumour now reads "The lights and the walls, both. They're talking to each other. About you."; generations 3–5 more faded and offset; pocket wear (quarter folds, creases, frayed and grimy edges); (2) ’Pelago throughout (ARCH-SLANG-001). Accepted: "Perfect. Save whatever information is necessary, including the artifacts." **Docs:** new `REDLINE_SAMIZINE.md` (ZINE-003); `docs/visual/samizine/` (five PNG boards, review PDF v3, canvas sources, README); master design §1 and register; HANDOFF note and Done row. **Interpretations to confirm:** "Perfect" read as approving the SAMIZINE look; it applies to in-world publications and the defeat/DEAD DROP CARBON pages, not the HUD (RUSTLER-LOOK-001). New font: Special Elite (Apache 2.0). **Code changes:** none. **Tests:** none.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — VIS-001a: fixed Rustler theme and corporation skin resources (Codex).

## 2026-11-18 — ADP-001 Phase 2 and ADP-4a (Codex)

Loaded the approved HALCYON, IRONWATCH and LUCIDA Phase 2 pack. The encounter uses cosmetic randomness for nonrepeating NUL/REM leaks, holds graffiti in reserved margins, shows approved status and Tomorrow toasts, and adds patent plates below the mascot illustrations. Hesitation changes only the live speech bubble. The run entry shows a corporate newsreel.

**Interpretations to confirm:** status toast starts on turn two, temporary speech lasts three seconds, and the newsreel advances with Continue. The current HALCYON map offers the first corporation only, so the shared graffiti hint is reserved for future corporation progression.

**Validation:** 361 rules checks passed. ADP-4a adds the hesitation capture and updates the bleed and strike frames.

## 2026-11-18 — ADP-001 Phase 3 and ADP-4a (Codex)

Added a local, clearable play profile and the Ads that know you switch. Loading and end screens use local card plays, broken ICE, strikes and hesitation when the switch is on. The LUCIDA edit path tags log entries and only rewrites flavour. Graft assignment records fully broken ICE parts and stores the chosen part on the individual deck instance. ADP-4a adds the ad, edit and graft frames.

**Interpretations to confirm:** the ad and record-edit wording is working copy, detailed ads start after two runs, and graft selection uses the first available part in the authored order. The LUCIDA fixture uses a controlled HALCYON encounter with the corporation flag set to LUCIDA, pending a playable route. PATCHWORK and in-progress run saves are absent from this slice. The graft fixture calls the upgrade hook directly and round-trips its deck data.

**Validation:** 361 rules checks, 14 Phase 3 fixture checks and 607 Phase 2 fixture checks passed.

## 2026-11-18 — SIGNAL-001, ARCH-001 and ADP-4a (Codex)

Added fixed 12 × 8 punch-card patterns, the taped holder and stacked-card viewer. A final-layer BREACH on a tagged Central Node awards its corporation's card once per run and plays the arrival with NUL/REM's EV-33. The presentation snapshot round-trips punch cards and instance grafts. The copy guard requires all three distinct cards for reveal-tagged lines.

The defeat screen holds on an empty workstation with the approved relocation copy and programme. THE CARBON follows with the Rustler, issue, corporation, Node, date and struck-out island name. The record stays local and is clearable from settings. DEAD DROP in the run menu opens the same ledger, which is also accessible from the slice's SAFEHOUSE.

Synced ARCH-SLANG-001 and ZINE-003 from main during the build. Underworld copy uses ’Pelago. The guard rejects the full word and banned wording on screen, either spelling of the shortened name in corporate or rules copy, and untagged island-purpose lines. THE CARBON uses Special Elite, marker corrections, cut-out type and pocket wear confined to the paper margins. ADP-4a adds the punch cards, relocation, defeat page and DEAD DROP ledger captures and refreshes the Phase 2–3 fixtures. The bleed sweep audio is in the Phase 1 fixture set.

**Interpretations to confirm:** the stacked holes make a temporary diamond, `central: true` marks a Central Node, and the arrival slides the card past a slot in a reserved HUD panel. The relocation notice advances with a button in either motion mode. END RUN counts as a defeat, as it does in Game. Working island names and the CARBON title remain marked proposed. SAMIZINE uses copy 2 for the defeat page and copy 4 for the archive, with static decorations. The LUCIDA edit fixture now uses the controlled INTAKE scene from the facade fixture. The HALCYON route ends before a playable Central Node and has no full in-progress save/resume. The arrival fixture appoints a stand-in Node without altering the map.

**Validation:** Godot 4.3 passed 361 rules checks, 17 bleed math checks, 671 SIGNAL/CARBON and copy guard checks, 615 ADP fixture checks, 14 Phase 3 fixture checks, 22 SIGNAL/CARBON fixture checks, and 173 Friendly Lie checks. Chrome and facade display fixtures passed.

LOG-001 moved the oldest dated entries to the archive unchanged. 2026-11-17 — VIS-001b: encounter scaffold and paper hand (Codex), 2026-11-17 — VIS-001c: mascot silhouettes and independent scan tags (Codex), 2026-11-17 — VIS-001d: per-ICE mood ladder and threat wording (Codex), 2026-11-17 — VIS-001e: Cracking, strike disclosure and Mask off (Codex).
## 2026-11-18 — ZINE-003 confirmed (Claude)

Designer: "Yes all approved." Closes the interpretations in the ZINE-003 entry: the SAMIZINE look is approved, and it applies to in-world underworld publications and the THE CARBON pages (defeat screen, DEAD DROP record), not the HUD (RUSTLER-LOOK-001). **Code changes:** none. **Tests:** none.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — VIS-001b: encounter scaffold and paper hand (Codex).

## 2026-11-18 — ARCH-COPY-001: remaining working copy approved (Claude)

Designer: "All approved" (asked about the HANDOFF WAITING row). Approved: the *THE CARBON* title, the *NOTES FROM THE ’PELAGO* column, the nine island names, the defeat framing copy, the on-screen ’Pelago uses, and the polite anti-paper lines. `REDLINE_ARCHIPELAGO.md` v0.7, ADP §2.2.3, master design and HANDOFF updated (WAITING row moved to Done). Still to do before on-screen use: fact-check the historical summaries and check island names against well-known real care chains. **Code changes:** none. **Tests:** none.

## 2026-11-18 — ARCH-COPY-001 correction: island names stay working copy (Claude)

Designer: "These are working copy names - will fact check later on care-home names. Samizdat history all good." The nine island names are working copy again (ARCH §4.0); a WAITING row in HANDOFF tracks the check. The samizdat history in ADP §2.2.1 is checked. The gulag summary (ARCH §2) still carries its fact-check note. **Code changes:** none. **Tests:** none.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — VIS-001c: mascot silhouettes and independent scan tags (Codex).

## 2026-11-18 — No history fact-checks (Claude)

Designer: "Don't verify history. This is a made-up world. It doesn't have to perfectly resemble the real world." Historical background (ADP §2.2.1, ARCH §2) is marked as inspiration, not a source to match; the fact-check notes and the HANDOFF item are removed. The island names remain working copy (care-home check). **Code changes:** none. **Tests:** none.

## 2026-11-18 — RELEASE-001: builds come from a `release` branch (Claude)

Designer wants builds produced off `main` "just in case any products are corrupted"; approved the proposal ("Go"). Decision in master §12 and the register: work stays on `main`; a `release` branch, fast-forwarded from `main` when a build is wanted, is the only branch that exports Windows builds; each build is tagged `playtest-N`; recovery is by tag. Replaces MAIN-001's export-on-`main` rule. HANDOFF: "How we work" item 7 and a Codex TO DO row (create `release`, move the three export conditions in `godot-validation.yml` from `refs/heads/main` to `refs/heads/release`, tagging, branch protection, prove it with the next build). Note: the workflow's path filter already means doc-only pushes don't trigger exports. **Code changes:** none (workflow change is Codex's). **Tests:** none.

## 2026-11-18 — RELEASE-001: HALCYON PLAYTEST 6 (Codex)

Merged the designer's changes through `bf0f05c` at `721303c`. Playtest 6 leaves all nine island names marked as working copy. All 15 relocation lines and the three programme bylines carry approved status. Godot 4.3 passed 361 rules checks, 17 bleed checks, 671 SIGNAL/CARBON guards and the 13 display scripts.

Published `22eb17f7c283ebca140e2a3e908908c0c6c1165a` to `main` and created `release` at that revision. Windows export is gated to `release`. Verified the downloaded Windows x86-64 executable, `BUILD_COMMIT.txt`, README and checklist v0.6, and pushed `playtest-6` at the build revision. Executable SHA-256 is `63bc5013254b0bd656d89e60dd46cbc8264c361b3228733ba9690b922eb329ae`. GitHub denied the branch-protection request with HTTP 403. Designer Windows launch and playtesting are pending. [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/44314368001) · [Windows artifact](https://github.com/Punkwork/REDLINE/actions/runs/44314368001/artifacts/14431722167)

LOG-001 moved the oldest dated entries to the archive unchanged. 2026-11-17 — VIS-001f: live drag targets, mascot motion and reduced motion (Codex), 2026-11-17 — VIS-001g: live fixtures, readability and interaction regression (Codex).

## 2026-11-18 — DEV-001: Claude Code takes over code development (Claude)

Designer: "I want to migrate codex code development for the redline/panopticon project to Claude Code"; Claude (project) stays on design, Codex keeps isolated tasks. Approved Claude's adapted plan ("Go ahead, yes"): a `pre-claude-code` tag instead of a migration branch (MAIN-001/RELEASE-001); `.godot/` was already ignored; Codex writes the system map; the design spec stays in the existing docs. **Changed:** `CLAUDE.md` and `AGENTS.md` (identical) expanded with roles, session routine, Godot 4.3 / typed GDScript / UI-in-code conventions (one scene, no autoloads), the no-refactor guardrail, presentation never read by rules, readability and copy guards, test commands from the CI workflow, and the RELEASE-001 build flow. Master design: DEV-001 and register row. HANDOFF: roles updated; DEV-001a (Codex: checkpoint tag, `docs/ARCHITECTURE.md`, correct the test commands) and DEV-001b (Claude Code: read-only audit). **Interpretations to confirm:** `godot/CODEX_HANDOFF.md` to be marked superseded by ARCHITECTURE.md. **Code changes:** none. **Tests:** none.

## 2026-11-18 — DEV-001a: Claude Code handoff (Codex)

Published `pre-claude-code` at `0a357e7`. Added [ARCHITECTURE.md](ARCHITECTURE.md) with the model/UI boundary, runtime data and approvals, local files, fixture setup, fragile dependencies and slice hooks. Corrected §4 in the identical working agreements, superseded the old Godot handoff and moved DEV-001a to Done. Claude Code takes DEV-001b next. No game code changed.

**Validation:** Fresh Godot 4.3 import in a temporary checkout. Headless suites passed 361 rules checks, 17 bleed checks and 671 SIGNAL/CARBON checks. A display-backed SIGNAL/CARBON smoke test passed 22 checks and wrote seven PNGs to an isolated `SHOT_DIR` with temporary user data. The working agreements match byte for byte.

LOG-001 moved the oldest dated entries to the archive unchanged. 2026-11-17 — CHROME-001 step 1: real encounter layout and readability (Codex).

## 2026-11-18 — DOCS-001: which docs are current (Claude)

Codex answered a question about Node types from outdated docs. Designer approved marking current versus outdated docs ("Yes"). `CLAUDE.md` = `AGENTS.md` §6 now gives the authority order (master design → Core Rules → topic docs; "Later amendments" tables win) and lists current docs and history/lore-only docs. One-line "not current for rules" notes added at the top of `REDLINE_BIBLE.md`, `PANOPTICON_CORE_DESIGN_AND_WORLDBUILDING.md`, `REDLINE_RULE_REVIEW_126.md`, `HALCYON_PLAYTEST3_IMPLEMENTATION.md` and `REDLINE_UI_NULREM_Design_For_Claude.md`; `REPOSITORY_STRUCTURE.md` updated. Master register and HANDOFF Done row. **Code changes:** none. **Tests:** none.

## 2026-11-18 — NAME-002 proposed: VITAE → SPARK, parked for review (Claude)

Designer: VITAE "seems so out of place in this setting". After two rounds of options (NERVE, TICKER, GRIT, PULSE; then SPARK, STATIC, SPINE, INK), the designer chose SPARK as the candidate but wants to review it later "to see how much it fits before committing it". Recorded as a WAITING row in HANDOFF with the rationale, samples, alternatives and rename scope. Not a decision: nothing renamed, master design unchanged. **Code changes:** none. **Tests:** none.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — CHROME-001 step 2: chrome/enamel mascot objects (Codex).

## 2026-11-18 — EVENT-001: expand the SIGNAL UNCLEAR events, after Playtest 6 (Claude)

Designer sees the random events as "a source of great variability for the player" and approved adding the task. HANDOFF row EVENT-001 (Claude): expand and re-theme the 9 SIGNAL UNCLEAR events in the world's current voice (zine, ’Pelago, corporate facades), waiting on Playtest 6 notes. Clarified in session: the 9 random events are SIGNAL UNCLEAR's; Console Lab is a fixed choice. **Code changes:** none. **Tests:** none.

## 2026-11-18 — UPL-006a: DATA PURGE costs +7 TRACE (Claude)

Designer: "Data purge cost should be +7 trace or -5 vitae." Updated Upgrades §3, Core Rules (Node table and amendments), Uplink & CAPS §3.2, and the master register. DATA PURGE isn't in the HALCYON slice code yet, so there's nothing to rebuild; it lands with the SIGNAL UNCLEAR events (see EVENT-001). The historical UPL-006 approval line in Uplink & CAPS still quotes +5. **Code changes:** none. **Tests:** none.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — CHROME-001 step 3: architectural atrium and illustrated materials (Codex).

## 2026-11-18 — EVENT-002/003: choices in every event; a 10th event (Claude)

Designer: one random room should give "+5 max vitae or choose a random rare card", and "Giving the rustler choices in each of these random rooms helps to make them feel less unfair." Answers: add it as a 10th event; MAINTENANCE WINDOW gets a choice; the rule covers every event except AMBUSH. Upgrades §3 now lists 10 events: EVENT-002 rule, MAINTENANCE WINDOW = heal 6 VITAE or −5 TRACE, new CARE PACKAGE, odds AMBUSH 20% / BROKER 5% / eight others about 9.4% each. Master register; HANDOFF row for Claude Code. **Interpretations to confirm:** the name CARE PACKAGE; +5 Max VITAE also raises current VITAE by 5 and lasts the run; MAINTENANCE WINDOW is either/or (it used to give both). **Code changes:** none. **Tests:** none.

## 2026-11-18 — EVENT-004 direction: powerful Ghostware, permanent Bloatware (Claude)

Designer: a random event offering "a specific ghostware that bestows a negative, a permanent bloatware in their deck that can't be removed through normal means"; it's "a benefit to the rustler, but because of how powerful it is, it comes with a negative"; a dedicated Ghostware (option B) that "needs designing". Recorded as DIRECTION in the master register, a "planned, in design" note in Upgrades §3, and a HANDOFF design task (Claude) carrying Claude's first-draft proposal (one Ghostware and Bloatware per corporation) and the open questions. Nothing approved beyond the direction. **Code changes:** none. **Tests:** none.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — CHROME-001 step 4: the same atrium reveals its purpose (Codex).

## 2026-11-18 — EVENT-004: one version per corporation (Claude)

Designer: "each corp should have their own version of this 'reward'". Recorded in the master register, Upgrades §3 note and the HANDOFF design task (moved from open to decided). **Code changes:** none. **Tests:** none.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — CHROME-001 step 5: clear interactions and refreshed five-step review set (Codex).

## 2026-11-19 — DEV-001b: read-only audit of code, docs and ARCHITECTURE.md (Claude Code)

First Claude Code session (DEV-001, step 2). Pulled `main` at `83524d5`, read HANDOFF, this log, ARCHITECTURE.md, Core Rules, ICE Corp 1, Rustlers, the ADP Phase 3 spec and the CI workflow, then compared them with `godot/`. **Code changes:** none. The 312 modified `.import` files in the Windows checkout differ only in line endings (`core.autocrlf=true`), not in content. Fixes are proposed in HANDOFF as **DEV-002a–i** (PROPOSED).

**Validation:** Godot 4.3 stable (Windows console build). The import was clean. `test_game.gd` **361 passed, 0 failed**; `test_adp.gd` **17 checks, 0 failures**; `test_signal_carbon.gd` **671 checks, 0 failures**. All three exited 0 with no `SCRIPT ERROR`, `Parse Error` or `Assertion failed`. Bot simulations (`SIM=1`) and the display fixtures were not run, since the audit was headless.

**Confirmed to match the docs:** the shared stats (30 VITAE, 4 BW, DRAW 6, 4 RAM, TRACE 40, SAFEHOUSE heal 10, clean-Node bonus 5); all four starter decks and their card values (Rustlers §3–6, ECHO-005, RIOT-002/005, EXTRACT-002); every HALCYON ICE against ICE Corp 1 §5.0 and ICE-AUDIT-001; the TRACE strike ladder (Core Rules §7); the reward odds and the Tier 2 shift (PACE-008); the FOOTPRINT caps 22/29/35 (DSY-001); reserves 23/15 (PACE-008, as the playtest guide says). Engine guardrails also hold: one scene, no autoloads, GL Compatibility. Rules code never branches on grafts, LUCIDA edits, ads or bleed. A search of `godot/` code and data finds no "Archipelago", "gulag", QR or ASCII 'Pelago outside the guard and its tests. Every function and field that ARCHITECTURE names exists, and all 13 CI fixture scripts exist.

**Where code and docs disagree:**
1. **ICE Corp 1 §5.0 "Slice route"** still lists two-layer Nodes (CONSENT WALL, DOORBELL, TERMS & CONDITIONS). The code has one layer per Node, as PACE-008 requires. The doc is stale.
2. **ICE Corp 1 §6** gives HOUSE CALL STR 5 and PULP 4 + 4. §5.0 and the code give STR 7 and PULP 6 + 6 (TUNE-001), but §5.0 only says it supersedes the Tier 1 table and §8.4.
3. **The COOKIE BANNER reserve** is 15 in Core Rules §10.1a, ICE Corp 1 §8.2/§8.4 and the CORE-012 example. The code uses 23 (PACE-008 +50%, with 22.5 rounded up). Only the playtest guide records the rounding; the master doesn't.
4. **The ad and LUCIDA-edit copy is hard-coded:** `PlayProfile.AD` (`play_profile.gd:5`) and `Game.LUCIDA_RECORD` (`game.gd:1574`). Neither has an approval field, neither is in `data/`, and the copy-guard test doesn't scan either. Codex's ADP-3 interpretation ("working copy") was never closed, and this copy shipped in `playtest-6`. CLAUDE.md §4's "ADP … copy have per-line approval fields" holds only for `adp_copy.json`.
5. **The 15 approved relocation lines name the island homes** (Sunnyside Manor, Pine Ridge …), but those names are still working copy (ARCH-NAMES-001). Renaming an island means editing approved lines too. `CarbonRecord.ISLAND_INDEX` hard-codes which island each line names.
6. **EVENT-002/003 (HANDOFF, Claude Code)** and UPL-006a's DATA PURGE have nothing to attach to: the slice map has only ICE and SAFEHOUSE Nodes, with no SIGNAL UNCLEAR.
7. **The RELEASE-001 entry (2026-11-18) says the path filter stops doc-only pushes from exporting.** In `godot-validation.yml`, `paths` applies to `pull_request` only. Every push to any branch runs full validation, and every push to `release` exports, including doc-only fast-forwards.
8. **CURRENT_STATUS** still quotes "357 rules checks" (now 361) and doesn't mention DEV-001.
9. Nit: the GHOST SIGNAL card text says "BURNED." where Rustlers §3 says "BURNED for the rest of the Node."

**What ARCHITECTURE.md gets wrong or leaves out:**
1. **Local files:** it reads as if every record is written through LocalRecord's `.tmp` and rename. `redline_flags.json` is written directly by `main.gd` `_save_flags()` with no temp file and no LocalRecord.
2. **Fixtures:** "the `shot_*.gd` scripts" misses `shot.gd`, which is in the CI list (CLAUDE.md §4 says the same). `shot.gd` and `shot_reel.gd` assert nothing and always exit 0, so CI catches only script errors in them. `shot.gd`'s header comment says it writes to `user://`, but it writes to `SHOT_DIR`.
3. **Phases:** neither ARCHITECTURE nor the `game.gd:21` comment lists `SELECT` (set by `main.gd:309`) or `DECOMPILE`. `main.gd:1582` checks a `DEAD_DROP` phase that nothing sets: a dormant branch for the future DEAD DROP Node.
4. **Copy guard:** it says new rendering paths use the shared guard. `AdpCopy.pool()` doesn't call `ArchCopy.valid_line()`; the data is covered only by the static test. In-code strings (`mascot.gd` lines, `PlayProfile.AD`, `LUCIDA_RECORD`, `main.gd` literals) aren't checked at all. No NUL/REM line has a `tag`, so the picker's reveal branch never fires; SIGNAL-001 rests on `valid_line()`'s secret-phrase check.
5. **Not mapped:** `tests/synergy_cases.gd` (loaded by `test_game.gd`), `scripts/ui/icon.gd` (`RIcon`), the voice lookup `res://audio/nulrem/<line id>.ogg` (`main.gd:576`), `audio/nulrem/manifest.json` (no script reads it), and the export preset's `include_filter="data/*.json"` (runtime JSON outside `data/` won't ship).

**Hygiene, recorded only (no change without the designer):** an unused local `odds` in `_roll_rewards()` (`game.gd:1357`); mixed indentation between files (tabs in `game.gd`, `cards.gd`, `ice.gd`; one space in `arch_copy.gd`, `carbon_record.gd`, `local_record.gd`, `signal_cards.gd` and most `friendly_lie/`).

**Interpretations to confirm:** added a PROPOSED DEV-002 row to the master register so the proposals carry an ID (rule 6). On Windows, run tests with the `_console.exe` build so output reaches the shell.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — CHROME-001 plaque revision: pearl enamel instead of black ICE panels (Codex), 2026-11-17 — CARDS-001: heavy type-specific 1950s slot cartridges (Codex).

## 2026-11-19 — CARDS-002 Rustler PCB palette (Codex)

**Designer direction:** adapt the supplied PCB photo for the Rustler cards and show all four card types, including corporate BLOATWARE. Added a presentation-only board layer to SCRIPT, PROGRAM and PROTOCOL.

**Validation:** Godot 4.3 import passed. Rules 361/0, ADP 17/0, SIGNAL/CARBON 671/0 and cartridge fixture 621/0. TRACER and SPAM captures match the baseline pixel for pixel.

**Interpretations to confirm:** mustard SCRIPT, olive PROGRAM and blue-green PROTOCOL use darker print fields and share ivory perimeter traces and dark contacts. These exact palette values and trace layout await the designer's visual review.
