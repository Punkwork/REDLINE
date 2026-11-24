# PANOPTICON — DEVELOPMENT LOG
**Initialized:** 2026-11-09  
**Policy:** append dated entries; distinguish reported outcomes from verified tests.

**LOG-001 (2026-11-16):** entries from 2026-11-08 to 2026-11-14 are in `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md`, unchanged. Keep this file under about 60 KB (HANDOFF, "How we work" 6).

## 2026-11-19 — CARDS-004a: BW cost dial top-left (Claude)

**Designer:** "The bw cost could move to top left of card as we are not efficiently using the card space/corners for icons." This reverses the earlier answer to keep it top-right.

**Changed:** in `card.gd`, the cost dial moves from (142, 5) to (−5, 3) on every card type, and the Rustler title panel shifts from x 13 to x 26 at the same 124 px width, clearing the dial and using the freed right side. BLOATWARE's title is unchanged; its face starts below the dial. Checked with a 7-card 1.4× hand mockup: every card's cost now shows; before, all but the last were covered.

**Validation:** rules 361/0, ADP 17/0, SIGNAL/CARBON 671/0; all 14 CI screenshot fixtures clean, including `shot_cards_pcb` (0 failures).

**Open:** what goes in the freed top-right corner. Proposed: a RAM chip on PROGRAMs (29 cards, RAM 0–2, not shown on the card today).

## 2026-11-19 — CARDS-005 corner icons; CARDS-004 overlap and fan (Claude)

**Designer:**
- "I would rather they start to slightly overlap instead of squash them together so the sides aren't visible, and them overlap more as more cards in hand. We need to utilize the top right corner for icons."
- To Claude's suggestions: "Yes i want all of them in the right corner. Gentle fan is perfect."

**Changed (`card.gd`):**
- A `CornerChip` stack down the top-right corner, from `corner_icons(def)`:
  - the Icepick type (FORTRESS tower, TUMBLER arrow, VOID diamond, ANY asterisk);
  - RAM on PROGRAMs;
  - extra TRACE (red) and CRED (gold) costs;
  - a target crosshair.
- `corner_legend()` adds the icons to the tooltip.
- The Rustler title panel narrows from 124 to 114 px.

**Fixture (`shot_cards_pcb`):**
- Checks each captured card's icons and their order, that they stay inside the cartridge and off every text panel, their ink contrast and the tooltip legend.
- Adds FORTRESS, VOID and ANY Icepick captures.
- Sweeps every base and compiled card for at most four icons; the most is 3.

**Validation:** rules 361/0, ADP 17/0, SIGNAL/CARBON 671/0; all 14 CI screenshot fixtures clean.

**CARDS-004 updated (docs):**
- The hand is centred and overlaps from the start, more as it grows: 5% at 1–4 cards, then 10, 15, 22, 29, 36 and 43% at 5–10. These are PROPOSED working values.
- A gentle fan of about 2° per card (approved).

**Interpretations to confirm:** the overlap values; the icon order; the glyph shapes.

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — PULP-001: FORTRESS PULP rolled each time (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — RIOT-003: SHATTER readings confirmed (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — REEL-001 follow-up closed; TUMBLE-001 reaffirmed (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — ICE-AUDIT-001 applied; PULP-001 roll size (Claude).

## 2026-11-19 — CARDS-005a: hardware-style corner indicators; BLOATWARE icons (Claude)

**Designer:**
- "Yes" to the BLOATWARE icons and the dash on TRACER's dial.
- "As for the icons on the top right corner, make them look like part of the hardware of the card. Right now they look very much out of place."

**Changed (`card.gd`):**
- `CornerChip` now draws a round indicator matching the BW dial: a drop shadow, a steel bezel `#D3DEDB` with a shaded lower arc, a face `#29352F`, a glyph with a soft glow, and a glass glint.
- A new `CornerRail` (brushed steel with two screws) sits behind the stack.
- BLOATWARE gets an `UNPLAYABLE` icon, and a `PENALTY` lamp (red face `#F07A5E`, dark number) whenever the rules text says "in your hand at the end of your turn: +N TRACE". That is TRACER's +3.
- Unplayable cards show "—" on the BW dial.
- The tooltip legend covers the new icons.

**Fixture:** ink contrast is checked against each indicator's own face, so the penalty lamp is covered. Unplayable cards must show "—". There is a new SPAM capture.

**Validation:** rules 361/0, ADP 17/0, SIGNAL/CARBON 671/0; all 14 CI screenshot fixtures clean.

**Interpretations to confirm:** the penalty lamp's red; reading the penalty from the rules text (the rules code hard-codes TRACER's +3); the rail's look.

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — PULP-001: rolled PULP is always shown before it fires (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — PULP-001: curves keep their patterns and show their next value (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — READ-001 extended to PROTOCOL; PULP-001 swing direction (Claude).

## 2026-11-19 — CARDS-004 and HAND-MAX-001 built: 1.4× cards, fanned hand, hand limit 10 (Claude)

**Designer:** "Yes to the fanned cards. Commit. Commit these icon and card changes to the next Build." The tuned fan values are approved.

**Built:**
- **HAND-MAX-001 (`game.gd`).** `MAX_HAND := 10`. `draw_cards` stops at 10 before any reshuffle or REBOOT. Retrieve and FIELD KIT into a full hand log "Hand full" and leave the card where it was.
- **CARDS-004, cards (`card.gd`).** `DISPLAY_SCALE := 1.4`. `FriendlyCard.framed()` puts a card in a fixed-size holder, because containers ignore `scale`. The ready rig, reward offers, drag preview and inspection use it. Inspection is 1.4×, and 2.1× when pinned.
- **CARDS-004, hand (`hand.gd`).** A centred fan. Overlap is 5% at 1–4 cards, then 8/10/18/26/35/43% at 5–10. The fan spans 20° in total, at most 4° per card. Each card pivots about its bottom centre, and the hovered card rises 36 px.
- **CARDS-004, layout (`encounter.gd`).** The hand area is `Rect2(16, 622, 1568, 378)`. The ICE row is drawn at 85%, and the mascot stage is 194 px (was 238). The strips, NUL/REM bar and rack sit 104 px higher. The left and right columns are re-stacked. Graffiti uses four fixed spots, and the TRACER flight targets the new pile position.

**Tests:**
- `test_hand_max`: 8 rules checks.
- `shot_hand`: hands of 6–10, with geometry checks: the hand stays clear of END RUN, the pile counters and the bottom HUD; the hover panel stays on screen; and contacts end at y ≤ 1050.
- `shot_cartridges`: 6, 8 and 10 cards.
- `shot_adp`: expectations updated for the new avatar scale.

**Validation:**
- Rules 369/0, ADP 17/0, SIGNAL/CARBON 671/0.
- All 14 CI screenshot fixtures clean.
- 30-seed bots unchanged: 19/13/16/15.

**Images saved:**
- `docs/visual/fixtures/cards-004/`: mockups and build captures.
- `docs/visual/fixtures/cards-005/`: the corner icons and BLOATWARE.
- `docs/visual/explorations/pixel-16bit/`: the parked pixel mockups and script. Not a decision; review Saturday 2026-11-21.

**Interpretations to confirm:**
- the ICE row at 85% and the shorter mascot stage (mascots about 70% of their ENCOUNTER-DISPLAY-001 size);
- at 9–10 cards, contact strips may run up to ~50 px past the bottom of the window (rules text and the hover panel always stay on screen);
- the pre-existing BOOTING line that clips at the bottom of the ICE plaque is left as it was.

**Release:** `release` was not cut. These changes go into the next playtest build when the designer asks for it.

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — Archive retired branches (Codex).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — FACADE-001: Raygun Gothic facades for IRONWATCH and LUCIDA proposed (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — Playtest checklist v0.3 and the live QA Sheet (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — DEPRECATE-001: remove LOGIC BOMB and RELAY (Codex).

## 2026-11-19 — DEV-001: validate the card and hand baseline (Codex)

Pulled `main` at `2d5301a` and verified that `AGENTS.md` and `CLAUDE.md` match. Reviewed HANDOFF, the day's development log, ARCHITECTURE and the master design for CARDS-003 through CARDS-005a and HAND-MAX-001.

**Validation:** Godot 4.3 import passed. Rules 369 passed, ADP 17 passed and SIGNAL/CARBON 671 passed, with zero failures. Bot clears from 30 seeds per Rustler were GENERALIST 19, ECHO 13, RIOT 16 and VECTOR 15. The RIOT bot hit the existing DOORBELL step guard twice. All 14 CI screenshot fixtures passed on Xvfb with the GL Compatibility renderer. The hand fixture reported zero geometry failures for hands of 6–10, and the PCB fixture reported zero failures across 444 base texts and 1,008 compiled pairs. Of the compiled pairs, 107 used the names and hover panel.

**Interpretations to confirm:** None from this verification. The open designer checks in HANDOFF are still pending. This verification adds no design decisions.

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — ICE-AUDIT-001: apply HALCYON slice changes (Codex).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — PULP-001: publish FORTRESS rolls before the response (Codex).

## 2026-11-19 — PIXEL-TRACE-001: TRACE pixelates the corporation's picture (Claude)

**Designer:** "the more trace and the madder/meaner the corporation gets, the more 16-bit the background and ice look. Or the reverse." Claude recommended more TRACE → more pixelated. The designer asked for a mockup at four levels, then approved it: "Looks good. Commit to the build."

**Built:**
- `godot/themes/trace_pixel.gdshader` reads the screen behind it and redraws it in square cells on one screen-aligned grid. It uses fewer colour levels and a 4×4 ordered dither, and samples at LOD 0 (stepped UVs otherwise pick a blurred mip and draw dark grid lines).
- `AtomicDecoPunk.pixel_step()` picks the step from `atomic_deco_punk.json` → `pixel`:
  - sharp below TRACE 20;
  - 2 px / 24 levels at 20;
  - 3 px / 16 at 30;
  - 4 px / 12 on a strike;
  - 5 px / 10 at Mask off.
- `encounter.gd` adds one full-screen layer after the backdrops, and one per mascot inserted before the mascot's first child with text. Speech bubbles, status tags and graffiti therefore draw on top, sharp. All layers share one material.
- New fixture `shot_trace_pixel.gd`, added to CI. It captures the four levels and checks that each layer is on only when active and that no text is drawn under a pixel layer.

**Validation:**
- Rules 369/0, ADP 17/0, SIGNAL/CARBON 671/0.
- All 15 CI screenshot fixtures clean.
- A first local run reused one user-data folder after `shot_trace_pixel` had saved reduced motion. That made `shot_playtest3` miss its tumble animation and `shot_reel` wait forever for a spin. Both pass in a fresh folder, and in CI the new fixture runs last.

**Images:** `docs/visual/fixtures/pixel-trace-001/`.

**Interpretations to confirm:**
- the step values;
- a strike uses its own step (between TRACE 30 and Mask off);
- mascot details drawn after a status tag stay sharp;
- step changes are instant (no transition animation).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — Validate HALCYON and refresh fixtures (Codex).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — FACADE-001 approved (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — FACADE-001 follow-ups: HALCYON copy, art now, escape ICE later (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — FACADE-ART-001: IRONWATCH and LUCIDA art (Codex).

## 2026-11-19 — PIXEL-TRACE-001a: animated pixel step changes (Claude)

**Designer:** "Commit the transitions to the next build." Asked whether that meant animating the step changes or cutting playtest-7, the designer chose "Animate the step changes".

**Built (`encounter.gd`, `atomic_deco_punk.json` → `pixel_transition`):**
- When the TRACE state asks for a new step, a tween spikes for 0.15 s to cells 2 px coarser than either step, with half the colour levels (at least 4) and full dither, then settles on the new step over 0.35 s.
- Cells are rounded to whole pixels throughout.
- With reduced motion, and on a new encounter, the step changes at once.
- A rebuilt ICE row takes the look currently on screen.

**Fixture (`shot_trace_pixel`):** new checks:
- a transition starts with motion on;
- the transition spikes past the new step and settles on TRACE 20's 2 px;
- reduced motion changes the step at once.

A spike frame is captured, and `PIXEL-TRACE-001_Transition.gif` is in `docs/visual/fixtures/pixel-trace-001/`.

**Validation:** rules 369/0, ADP 17/0, SIGNAL/CARBON 671/0; all 15 CI screenshot fixtures clean.

**Interpretations to confirm:**
- the spike size and timing;
- a step down (dismissing a strike) uses the same spike;
- no sound with the transition.

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — FACADE-001: HALCYON non-fight copy approved (Codex).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — HALCYON PLAYTEST 4 Windows build (Codex).

## 2026-11-19 — PIXEL-TRACE-001b: bit-crushed music with the pixel steps (Claude)

**Designer:** asked what a transition sound could be. Of Claude's options, the designer chose bit-crushing the music: "Bit crushing the music or bgm is perfect. Save that idea somewhere appropriate."

**Recorded:**
- PIXEL-TRACE-001b in the master design doc, as an APPROVED direction that is not yet built. There is no separate sound effect. The corporation's music crushes with each pixel transition, and a held crush deepens toward Mask off (working proposal).
- A Claude Code TO DO row in HANDOFF.

**Code changes:** none.

**Interpretations to confirm:**
- the held crush per step (the designer approved the crush on the transition; holding it between steps is Claude's proposal);
- the crush is on the music bus only, so the mechanical sounds stay clean.

## 2026-11-19 — PIXEL-TRACE-001c: a transition sound effect, to be chosen (Claude)

**Designer:** "There will be a sound as well for the transition but i have not yet determined." This corrects the previous entry: a pixel-step transition gets a sound effect as well as the bit-crushed music. The master design doc no longer says "no separate sound effect". HANDOFF has a WAITING row, PIXEL-TRACE-001c, listing the options discussed (TV detune, teletype burst, neon ballast buzz). **Code changes:** none.

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — Playtest checklist v0.4 for HALCYON PLAYTEST 4 (Claude).

## 2026-11-19 — ENC-ANALOG-001 saved; ICE-ANALOG-001 brief for Codex (Claude)

**Designer:** asked for a full HALCYON encounter mockup built on the analog left-HUD unit (flip-clock PROGRAM reel, cockpit instruments), with the ICE redesigned to match and the 8-bit/16-bit work applied; asked for it to be elegant and "beautiful and inviting". Then: "save these mockups as I want to return to this elegant design and interface then incorporate it into the encounter screen", and a Codex prompt: redesign the ICE readout (not the mascots, which get a little bigger and more behaviour), subroutines as icons with a value, full text on rollover.

**Recorded:**
- ENC-ANALOG-001 (EXPLORATION) and ICE-ANALOG-001 (PROPOSED) in the master design doc and register.
- New spec `docs/REDLINE_ENCOUNTER_ANALOG.md`, with the Codex prompt in §8.
- Mockups in `docs/visual/explorations/encounter-analog-001/`: the CAPTCHA node Friendly (turn 2, TRACE 12) and Cracking (turn 3, TRACE 30, PIXEL-TRACE-001's 3 px step and 41% reveal), an ICE close-up, and the mockup sources.
- HANDOFF: a Codex TO DO row for ICE-ANALOG-001 (design review only).

**Code changes:** none. **Tests:** none.

**Interpretations to confirm:**
- The TRACE lamp lights when TRACE is high (≥ 30); the others light when low.
- The HUD's PULP Nixie shows incoming PULP.
- Program reel at 13 tiles with shortened names.
- END TURN and DECK/DISCARD moved beside the response board to free the hand's width.
- The cards in the mockups are placeholders, not a redesign.
- ICE-ANALOG-001 moves full rule text to hover/focus (VIS-001 §2.9 to be revisited).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — Atomic Deco Punk design direction (Codex), 2026-11-17 — ADP-001 Phase 1 (Codex).

## 2026-11-19 — ICE-ANALOG-001: editable Godot visual study (Codex)

**Designer:** requested the artistic direction from the three new PANOPTICON analog encounter concept renders be translated into an editable Godot fixture and committed for the next build. Designer clarified that all displayed numbers are illustrative mockup data, not proposed rule changes.

**Committed:** isolated `godot/tests/ice_analog_visual.gd`, six-state `shot_ice_analog.gd`, animation-frame `shot_ice_analog_animation.gd`, editable vector key source and exploration README under `docs/visual/explorations/ice-analog-001/`. The files are source studies and do not alter gameplay, card assets or the default encounter.

**Validation:** Godot 4.3 executable unavailable in this authoring environment; fixture has **not been run**, screenshots and GIF have **not been rendered**, rules suite has **not been rerun**. The mascot stand-ins, glyphs and animation are incomplete relative to §8. No approval claimed.

**Interpretations to confirm:** (1) icon-only keys with full tooltip plus NEXT RESPONSE/passive text require VIS-001 §2.9 review; (2) 3-ICE key sizes must pass 44 px; (3) existing mascot artwork must replace the vector stand-ins; (4) mockup values are illustrative only; (5) animation/tooltip interactions need Godot validation before designer review.

### ICE-ANALOG-001 follow-up — motion scaffolding (2026-11-19)

Added deterministic animation phases to the isolated visual fixture: idle, attention, telegraph, break reaction and tumble, plus animation-frame driver. These are illustrative presentation effects, not gameplay events. **Godot execution, rendered GIF, screenshot review and rules validation remain pending.** Existing mascots remain placeholders. Status remains PROPOSED.


## 2026-11-19 — ICE-ANALOG-001 designer approval for default encounter integration

**Designer approval (verbatim):** “Okay, well then I approve all of these changes to be integrated into the default encounters.”

**Decision:** ICE-ANALOG-001's analog visual direction and proposed interface behaviors are **APPROVED for integration** into default encounters. This changes the earlier design-review-only restriction. The existing standalone Godot fixture is still incomplete and untested; **no default encounter integration has been performed in this entry**. All mockup numbers are illustrative, not rules amendments.

**Next build:** Godot 4.3 execution, screenshot and GIF generation, existing mascot asset integration, accurate TUMBLER motion, accessibility and contrast verification, regression suite, then default encounter presentation integration. Do not change gameplay rules.

**Interpretations to confirm:** whether any specific animation timings or sound cues require separate designer sign-off; final pixel fidelity to the saved HALCYON reference mockups.

## 2026-11-19 — ICE-ANALOG-001 built; ENC-CONCEPT-001 direction and art briefs (Claude)

**Codex review:** Codex's 18 commits added a standalone wireframe (`ice_analog_visual.gd`) not connected to the game, and recorded the designer's approval three times with contradictory statuses. Claude ran it in Godot 4.3 (it ran, but placeholder art and fake cards/stats). The designer confirmed the approval in session ("Yes, approved, incl. hover text"; scope "Whole encounter screen"; "Replace it" for the wireframe). Docs deduplicated (`c8cef09`); the three concept screenshots committed (`3eadd23`).

**Built (ICE-ANALOG-001, `b3fdd42`):** analog ICE consoles in the real encounter: icon keys (`ice_key.gd`) with lamp, value and BW chip; key tip on hover/focus with the full rule, timing and break cost; Enter breaks a focused key; TUMBLER reel column; mascots +18%, peeking over the console, glancing at the hovered key and at each key as it fires. Barlow Condensed (OFL) added. Real fixture `shot_ice_analog.gd` replaces the wireframe.

**Tests:** rules 369/0, ADP 17/0, SIGNAL/CARBON 671/0; all 16 screenshot fixtures pass (`shot_adp`'s stage-scale check now includes `MASCOT_GROWTH`).

**Designer direction (ENC-CONCEPT-001):** the interface follows the concept screenshots: frame from concept 3, cards and mascots from concept 2, left HUD mixing 2 and 3 with installed Programs in the CRT panel; art made in ChatGPT. Recorded in the master design doc; art briefs in `docs/visual/concept-art/ART_BRIEFS.md`; asset folders `godot/assets/concept/`. ENC-ANALOG-001's flip-clock HUD pass was set aside uncommitted.

**Interpretations to confirm:**
- Mascot growth stops at 18% (column width); the console overlaps the mascot stage by 14 px.
- The patent plate moves to the foot of the console and is left off with three ICE.
- Key tip opens above the key (over the mascot art); to the side only when there's no room.
- Character proposals for the batch-2 ICE mascots and all card subjects are Claude's.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — ADP-001 Phase 1 confirmations (Codex), 2026-11-17 — HAND-CLEANUP-001 and CARD-CONTROLS-001 (Codex), 2026-11-17 — HALCYON PLAYTEST 5 Windows build (Codex), 2026-11-18 — ZINE-002, ARCH-001: the zine as samizdat; the Archipelago (Claude).

## 2026-11-19 — ENC-CONCEPT-001: concept-3 interface in the encounter (Claude)

**Built (presentation only):** the encounter screen re-laid out to concept 3 with a concept-2 left HUD: top bar (PANOPTICON plate, network/node plate, decal plate, CONDITION pill, HOSTILE REVEAL %, TURN/TRACE/RESERVE split-flap tiles, strike lamps, CRED/RAM, bleed); ICE consoles (enamel frame with arched corp tab, power lamp, name and STR plates, ICE-ANALOG-001 keys and reel column, PASSIVE plate, per-ICE NEXT RESPONSE plate, patent plate); left CRT with status and installed Programs (phosphor chips); vitals with icons and segment gauges (VITAE, BANDWIDTH lamps, SHIELD, PULP INCOMING, NEXT DRAW); right column with the NUL/REM note, piles and a round red END TURN with a ready lamp. New `analog.gd` draws tiles, lamps, gauges and icons. The flip-clock HUD pass (ENC-ANALOG-001) stays unbuilt.

**Fixtures:** `shot_ice_analog.gd` added to CI. `shot_friendly_lie` reads the curve-B number from the NEXT RESPONSE plates; `shot_facade` compares the console ground. The note passes drops through so SCRIPTs still play when dropped on it (`shot_hand`).

**Tests:** rules 369/0, ADP 17/0, SIGNAL/CARBON 671/0; all 16 screenshot fixtures pass.

**Interpretations to confirm:** HOSTILE REVEAL = the bleed reveal (0 / 20–60 / 100%); graffiti on the top-bar decal plate; NUL/REM note in the right column; per-ICE NEXT RESPONSE plates replace the shared strip; console enamel = plaque ground tinted toward the corp accent. Card faces and mascots wait for the ChatGPT art.

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-18 — ARCH-NAMES-001: islands named like care homes (Claude).

## 2026-11-19 — ENC-CONCEPT-001: ChatGPT art wired into the encounter (Claude)

Designer: "yes please do" (wire the delivered ChatGPT art into the game). Imported from the designer's folder `PANOPTICON art` into `godot/assets/concept/`:
- `ui/`: painted UI kit (frame, top bar, ICE console 9-slice, key caps and lamps, plates, pills, badges, END TURN states, tooltip plate, flip tile, reel window, CRT, vitals, BW chip) and the icon sheet sliced into single icons with cream `_LIGHT` variants. Seven files arrived under ChatGPT names and were renamed; large plates also have half-size `_S` copies.
- `cards/`: CARD_FRAME_{PROGRAM,SCRIPT,PROTOCOL,BLOATWARE} and 10 card pictures (batch 1).
- `mascots/`: AUTO_RENEW and CAPTCHA, cheery / wary / lethal.

Wiring (presentation only; each part falls back to the drawn version when its file is missing):
- ICE consoles drawn as a NinePatchRect of the painted console; keys use painted caps, lamps and icons; key tips use the painted tooltip plate.
- Top bar, CRT, vitals, plates, buttons and END TURN use the painted parts (StyleBoxTexture). `FriendlyEncounter.style_ground()` gives contrast tests a ground colour for painted styles.
- Mascots: when `<ICE_ID>_<mood>.png` exists, the concept art replaces the drawn mascot (speech bubble and sticker kept), leans toward the focused key, breathes, and trembles when lethal. PIXEL-TRACE-001 still applies.
- Cards: concept face (white frame per type, picture window, name, cost dial, type stamp, corner chips); rules show on hover. `FriendlyCard.DISPLAY_SCALE` 1.4 → 1.0 (smaller cards, per the designer); the CARDS-004 fan rules are unchanged. Cards without a picture show a tinted stencil until batch 2. `shot_cartridges` and `shot_cards_pcb` set `FriendlyCard.legacy_face = true` so they keep checking the cartridge face.

Tests (Godot 4.3, headless): test_game 369 passed, 0 failed; test_adp 17 checks, 0 failures; test_signal_carbon 671 checks, 0 failures. All 16 screenshot fixtures in the workflow list exit 0 with no SCRIPT ERROR, Parse Error or Assertion failed.

Interpretations to confirm: cards at 1.0× (CARDS-004's 1.4× superseded for the concept face); card rules on hover only; UI_BACKDROP_MACHINE delivered but not used until the per-corp background decision.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — ARCH-LINES-001: relocation lines and programme names approved (Claude); 2026-11-18 — ARCH-SLANG-001: the Rustlers say ’Pelago (Claude); 2026-11-18 — ARCH-SLANG-001 confirmed: ’Pelago even at the end (Claude).

## 2026-11-19 — ENC-CONCEPT-001: UI kit brief 2 (Claude)

Designer: "what other UI elements can we request ChatGPT build based on the screenshot #2… I really like how the examples fill the screen with useful UI, with appealing proportions." Reviewed concept 2 against kit 1 and wrote `docs/visual/concept-art/UI_KIT_BRIEF_2.md`: one paste-once ChatGPT prompt for 13 blank painted parts (brand plate, corp sign, alarm plate, four CRT condition pictures, lamp stack, knob, vent, slot panel, comic bubble, TUMBLER drum, hand tray, END TURN box, legend card). No code changes. Interpretation to confirm: concept 2's SUPPORT box is not a rule, so its panel will hold the punch-card count or installed Programs.

## 2026-11-19 — ENC-CONCEPT-001: UI kit brief 3 (Claude)

Designer: "I want to get ChatGPT generating as many UI images for this as possible to get it as correct as possible… once those sets of images are generated you can do the layout." Wrote `docs/visual/concept-art/UI_KIT_BRIEF_3.md`: 16 more blank painted parts (concept-2 console, big key sockets, TURN plate, TRACE counter, dials, strike lamps, NUL/REM slip, deck/discard wells, card back, tray buttons, toggles, pipework, screws/rivets, key glow, log ticker, vignette). The concept-2 layout pass waits for kits 2 and 3. No code changes. Interpretation to confirm: the homes for information concept 2 leaves out (dials, tray, slip).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-18 — ZINE-003: SAMIZINE, the underworld's zine look (Claude).

## 2026-11-20 — ENC-CONCEPT-001: concept-2 layout pass with UI kits 2 and 3 (Claude)

Designer: "both batches are in the folder now. do the full layout pass and send screenshots." Imported 48 kit-2/kit-3 parts from `PANOPTICON art` into `godot/assets/concept/ui/` (the cabinet arrived as "Empty seafoam chrome cabinet-1.png" and was resized to `UI_ICE_CONSOLE_2` 960×1000; the vignette was reduced to 800×500). Rebuilt the encounter layout around concept 2 (master ENC-CONCEPT-001 has the full list): painted top bar plates and dial; CRT pictures per condition; NUL/REM paper slip; ICE cabinets with the character top-left, name/STR slots, keys scaled with the console (`IceKey.u`), hover glow and comic bubble; ticker; hand tray with wells, tray buttons and the END TURN box; KEY LEGEND card; pipework and vignette. Presentation only; every part falls back to the drawn version when its file is missing.

Test updates: `shot_hand` drops on the left column instead of the old right column, checks the hand against the tray buttons and END TURN, and checks `FriendlyHand.HAND_SCALE`; `shot_adp` checks the cabinet's stage scale; `shot_ice_analog` adds the KEY LEGEND capture.

Tests (Godot 4.3, headless): test_game 369 passed, 0 failed; test_adp 17 checks, 0 failures; test_signal_carbon 671 checks, 0 failures. All 16 workflow screenshot fixtures exit 0 with no SCRIPT ERROR, Parse Error or Assertion failed.

Interpretations to confirm: homes for the information concept 2 leaves out; hand cards at 0.72×; parts not used yet (see HANDOFF).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — ADP-001 Phase 2 and ADP-4a (Codex); 2026-11-18 — ADP-001 Phase 3 and ADP-4a (Codex).

## 2026-11-20 — RELEASE-001: HALCYON Playtest 7 (Claude)

Designer asked for a playable build of the concept-2 layout. Bumped the version to 0.7.0-playtest.7 (project version, selection-screen line, workflow artifact name, playtest guide) in `5bb7d71`; ran test_game 369/0, test_adp 17/0 and test_signal_carbon 671/0 before committing. Fast-forwarded `release` to `5bb7d71`; [Actions run 44719708503](https://github.com/Punkwork/REDLINE/actions/runs/44719708503) passed every step and uploaded `PANOPTICON-HALCYON-PLAYTEST-7-0.7.0-playtest.7-Windows-x86_64` (95.8 MB). The `playtest-7` tag on `5bb7d71` still needs to be pushed: GitHub refused the tag push from this session (HTTP 403). The artifact could not be downloaded from this session, so its contents were checked through the workflow's own export checks rather than by hand.

## 2026-11-20 — ENC-CONCEPT-001: program screen; mascot prompt for ACCEPT ALL / REJECT ALL (Claude)

Designer, after Playtest 7: installed programs were unusable. A probe showed +STR did work, but the controls were tiny and crammed into a 66-px scroll over the CRT picture. Rebuilt the CRT readout as one active program (name plate to drag, STR, type, costs, +STR, ×, ◀ n/N ▶, mouse wheel), a dark scrim behind it, the "DROP PROGRAM HERE" plate only when nothing is installed, and key clicks that break with the program on screen first (`main._on_break` passes the pick uid to the existing `break_sub`). `shot_ice_analog` checks the rotate and +STR and captures the program screen. Wrote the batch-2a ChatGPT prompt for ACCEPT ALL and REJECT ALL in `ART_BRIEFS.md`.

Tests: test_game 369/0, test_adp 17/0, test_signal_carbon 671/0; all 16 workflow fixtures pass.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — SIGNAL-001, ARCH-001 and ADP-4a (Codex).

## 2026-11-20 — ENC-CONCEPT-001: ACCEPT ALL and REJECT ALL mascots (Claude)

Imported the designer's six ChatGPT mascots (`ACCEPT_ALL_*`, `REJECT_ALL_*`, cheery/wary/lethal) into `godot/assets/concept/mascots/`; the game picks them up by name, so COOKIE BANNER now shows the painted bellhop twins. No code changes. Tests: test_game 369/0, test_adp 17/0, test_signal_carbon 671/0; all 16 workflow fixtures pass.

## 2026-11-20 — MOOD-PIXEL-001, program cartridges, AVATAR-001 and ChatGPT round 3 (Claude)

Designer asked for card pictures, per-corporation backgrounds, avatar families that read by corporation, job and ICE type (sentries fun to build), 16-bit mood transitions with a 2 s on / 2 s off lethal pulse, and slim program cards sticking out of the CRT. Built: `themes/mood_pixel.gdshader` (TRACE-pixel method masked by the avatar's alpha) and `FriendlyMascot.mood_look()` (drop to 16-bit, swap faces at the peak, resolve; lethal pulse, coarser over TRACE pixelation; off under reduced motion); `FriendlyEncounter.build_cartridges()` (one card per installed program on top of the CRT; the active one higher with a lamp; click to switch) with the left column moved down 30 px; `concept_backgrounds()` swaps in `assets/concept/backgrounds/BG_<CORP>_*.png` when delivered. The NUL/REM slip now fits its text by the label's real line height and clips. Wrote `docs/visual/concept-art/CHATGPT_PROMPTS_ROUND3.md` (83 card pictures in four prompts, AVATAR-001 rules with build-a-sentry tables and the six remaining HALCYON avatars, six backgrounds). `shot_ice_analog` checks the pulse timing and captures the 16-bit phase.

Tests: test_game 369/0, test_adp 17/0, test_signal_carbon 671/0; all 16 workflow fixtures pass.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — ZINE-003 confirmed (Claude); 2026-11-18 — ARCH-COPY-001: remaining working copy approved (Claude).

## 2026-11-20 — CAPS rack and Ghostware rail (Claude)

Designer asked for room for CAPS (3 minimum, more later) and any number of Ghostware, possibly hovering along the top with rollover text. Built `build_cap_rack()` (3 placeholder slots right of the hand; `HAND_RECT` 80 px narrower) and `build_ghost_rail()` (ORIGIN plus `game.ghostware` as round badges hanging from the pipe above the ICE, shrinking to fit; tooltips give name and effect; painted icons picked up from `assets/concept/ghostware/GW_<NAME>.png`). Added §4 to `CHATGPT_PROMPTS_ROUND3.md` (CAP slot, 12 CAP vials, 30 Ghostware badges). Tests: test_game 369/0, test_adp 17/0, test_signal_carbon 671/0; all 16 workflow fixtures pass.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — ARCH-COPY-001 correction: island names stay working copy (Claude); 2026-11-18 — No history fact-checks (Claude).

## 2026-11-20 — HOVER-001 recorded (Claude)

Designer: "the hover text box should always include a large/high resolution image of the card or cap or ghostware etc. alongside the text. Commit that mouse over/hover rule." Recorded HOVER-001 as APPROVED in master §6 and the register, with a note in Visual Language §2.9: every hover/focus box for a game object shows a large, high-resolution image of it beside the text (at least 2× its on-screen size, cards at least 1.5×), image first, a stand-in until painted art exists, never covering the hovered object. Implementation is a TO DO in HANDOFF. No code changes.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — RELEASE-001: builds come from a `release` branch (Claude).

## 2026-11-20 — HOVER-001 built (Claude)

Designer: "Yes build it now. Include that rule in the next build going forward." Cards: the concept face's hover box is now the card drawn large (`FriendlyCard.HOVER_SCALE` 1.1, a display-only copy) beside the rules panel. Keys: the key tip draws the key at 2.2× beside its text (`key_tip_image`). New shared box `FriendlyEncounter.show_object_tip()` / `tip_on_hover()` (large picture plus name, rule and note, placed beside the object and kept on screen; opens on hover and keyboard focus) for program cartridges, the CRT program, Ghostware badges and CAP slots. `shot_ice_analog` checks each box and that none covers its object, and captures them. Interpretation to confirm: no extra box for ICE avatars.

Tests: test_game 369/0, test_adp 17/0, test_signal_carbon 671/0; all 16 workflow fixtures pass.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — RELEASE-001: HALCYON PLAYTEST 6 (Codex).

## 2026-11-20 — HOVER-001: subroutine tips list every effect (Claude)

Designer: "Ok for ice - except for subroutines. They might have effects beyond their icon(s)." ICE avatars keep no extra hover box. The key tip now lists every effect of the subroutine as its own row with its icon (a key shows only its main icon), then what else touches it: DEADLOCK steps and progress, BOOTING locks, TUMBLE on TUMBLERS, and the ICE's passive. Tests: test_game 369/0, test_adp 17/0, test_signal_carbon 671/0; all 16 workflow fixtures pass.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — DEV-001: Claude Code takes over code development (Claude).

## 2026-11-20 — ChatGPT round 4 prompts: the other Node types and the map (Claude)

Designer asked what else ChatGPT could make, "at least for the other node types". Wrote `docs/visual/concept-art/CHATGPT_PROMPTS_ROUND4.md`: five underworld scenes (Uplink, SAFEHOUSE, DEAD DROP, Console Lab, SIGNAL UNCLEAR), Central Node and escape backgrounds for each corporation, a defaced tourist-map board per corporation and nine map Node badges. No code changes; wiring is a HANDOFF item. Interpretation to confirm: Rustler places share one underworld look rather than one per corporation.

## 2026-11-20 — ChatGPT round 5 prompts: title screen and Rustler portraits (Claude)

Designer asked for the title-screen art (a panopticon prison building or one big eye) and character-select portraits. Wrote `docs/visual/concept-art/CHATGPT_PROMPTS_ROUND5.md` with the written style guide built in (the designer had no reference images to hand): a day and a night title background combining both ideas (a round World's Fair prison whose central tower is a giant eye), a letterless emblem, and portraits of the GENERALIST, ECHO, RIOT and VECTOR with signature colours and props from REDLINE_RUSTLERS. No code changes.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — DEV-001a: Claude Code handoff (Codex).

## 2026-11-20 — AVATAR-001 LUCIDA amendment and round 6 prompts (Claude)

Designer asked for ICE avatars with very little resemblance to human features, for LUCIDA, each in the three trace-level moods. Recorded the amendment under AVATAR-001 in the master doc and wrote `docs/visual/concept-art/CHATGPT_PROMPTS_ROUND6_LUCIDA.md`: three paste-once prompts covering all 21 LUCIDA ICE from REDLINE_ICE_CORP3 (61 images), with the written style guide built in. No code changes.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — DOCS-001: which docs are current (Claude).

## 2026-11-20 — Round 6 v2: LUCIDA as mechanical nightmares, mockups first (Claude)

Designer: creepy, nightmare LUCIDA avatars with no human features, some with mechanical tentacles, jellyfish-like or giant slugs, all very mechanical; build mockups. Rewrote `CHATGPT_PROMPTS_ROUND6_LUCIDA.md`: a shared style block with the nightmare rules (no gore, a face built from machine parts, the job still readable, uncanny even when cheery), a new prompt 0 for three mockups (lineup of all 21, ANIMA's three moods, an encounter-screen mockup), and all 21 creatures redesigned. Amendment recorded under AVATAR-001. No code changes.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — NAME-002 proposed: VITAE → SPARK, parked for review (Claude).

## 2026-11-20 — IRONWATCH avatar prework (Claude)

Designer asked for prework on the IRONWATCH prompts and the corporation's history and guides. Gathered ICE_CORP2, FACADE-001 (including its per-ICE appliance table), ADP copy, the Archipelago programme, NUL/REM intros, AVATAR-001 and the existing (pre-concept, photoreal) IRONWATCH shells into `docs/visual/concept-art/IRONWATCH_AVATAR_PREWORK.md`, with a 23-ICE roster, draft concepts (the four escape ICE are new), three creature languages and four questions. No decisions made.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — EVENT-001: expand the SIGNAL UNCLEAR events, after Playtest 6 (Claude).

## 2026-11-20 — AVATAR-001 IRONWATCH amendment and round 7 prompts (Claude)

Designer answered the IRONWATCH prework: heavy civic machinery crossed with faceless authority, robot dogs and saucer drones, hidden hatches that open on gas hoses, tiny guns, lasers and especially syringes as the mood worsens; uniforms yes, faces no; FACADE-001 appliances as the base; mockups first. Recorded under AVATAR-001 and wrote `CHATGPT_PROMPTS_ROUND7_IRONWATCH.md` (3 mockups, then 67 images in three prompts, the four escape ICE newly designed). No code changes.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — UPL-006a: DATA PURGE costs +7 TRACE (Claude).

## 2026-11-20 — IRONWATCH mockups reviewed (Claude)

The designer sent ChatGPT's three IRONWATCH mockups (saved in `docs/visual/explorations/ironwatch-avatars/`). K9 UNIT's escalation matches the brief and becomes the reference image for the production prompts. Updated round 7 prompts 1–3: a large mood-coloured face turned to the viewer on every ICE (most lineup appliances had none), transparent backgrounds, and sharper PATTERN ANALYSIS, SHOCK TROOPER and SECURITY GUARD. Raised a per-corporation console colour as an idea.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — EVENT-002/003: choices in every event; a 10th event (Claude).

## 2026-11-20 — ENC-CONCEPT-001 console colour per corporation (Claude Code)

Designer: "yes add console colour". ICE consoles now take the corporation's enamel: HALCYON seafoam (unchanged), IRONWATCH navy #1F3A5F, LUCIDA lilac #C9B6F2. `encounter.gd` loads `UI_ICE_CONSOLE_2_<CORP>.png` when present; otherwise the new `themes/console_tint.gdshader` repaints only the seafoam enamel (chrome, brass and dark slots keep their colour). `console_ground()` returns the corporation's enamel and `console_ink()` picks cream on dark enamel for the meta, ZEROED and patent labels. `shot_facade` now checks console ink contrast for every corporation. ChatGPT prompt for painted versions: `docs/visual/concept-art/CHATGPT_PROMPTS_CONSOLES.md`. Presentation only. **Tests:** test_game 369/0, test_adp 17/0, test_signal_carbon 671/0; all 16 fixtures exit 0 with no script errors (shot_facade 0 failures, 8 captures).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — EVENT-004 direction: powerful Ghostware, permanent Bloatware (Claude).

## 2026-11-21 — Designer calls: DEV-002b/c/h, PIXEL-TRACE-001c, PIXEL-16BIT-001, MOOD-PIXEL-001; checklist v0.7 (Claude)

Designer answered the open HANDOFF calls in a claude.ai session:
- **DEV-002b** "CONFIRMED": PACE-008's +50% reserve rounds up (COOKIE BANNER 23, Tier 1 layer 15). Docs only; the code already rounds up.
- **DEV-002c** "APPROVED": the ad and LUCIDA-edit wording that shipped in `playtest-6` is approved as it is. Closes the ADP-3 working-copy interpretation. Claude Code moves it into `data/adp_copy.json` with approval fields.
- **DEV-002h** "YES": the `paths` filter also applies to `push`, so doc-only pushes skip validation and export. `shot.gd` and `shot_reel.gd` should fail when a PNG can't be saved.
- **PIXEL-TRACE-001c** "NEON BALLAST BUZZ": the pixel-step transition sound. It's built with PIXEL-TRACE-001b.
- **PIXEL-16BIT-001** "NO" to a 16-bit look for the whole game: "ONLY FOR TRANSITION from regular game images to each stage - on lethal - the ICE PULSE transitions in and out of 16-bit - 2 seconds each state". This matches MOOD-PIXEL-001 as built. Follow-ups: "back to normal after each transition" and, under reduced motion, "skip the pulse". Both confirm MOOD-PIXEL-001's behaviour; only its 0.8 s change timing is still open.
- **NAME-002** "PARKED FOR NOW". **ARCH-NAMES-001** "STILL NOT YET CONFIRMED"; DEV-002e keeps waiting.

Master design (PIXEL-TRACE-001c, PIXEL-16BIT-001, MOOD-PIXEL-001, register rows) and HANDOFF are updated.

**Checklist v0.7** is for HALCYON PLAYTEST 7 (`5bb7d71`, the ENC-CONCEPT-001 encounter). It updates A3, adds a Playtest 7 encounter section (PT7-1 to PT7-10) and rewords C2, L5, L8 and L10 for the new screen. A fill-in workbook, `docs/PANOPTICON_Playtest7_Checklist.xlsx`, has 99 checks with 3 run columns, a Run log and a Summary of counts per run. It's generated from the markdown, and the designer uploads it back with results. Before the repo was connected, the claude.ai project briefly had a v0.7 and HANDOFF copy written for the pre-concept card build. The project copies are refreshed from this commit.

**Tag:** `playtest-7` on `5bb7d71` is still missing. The git push and the GitHub API both refused the tag from this session (proxy policy, HTTP 403).

**Interpretations to confirm:** the PIXEL-TRACE-001c buzz goes on the effects bus, so it plays with music muted and with reduced motion on.

**Code changes:** none. **Tests:** none (docs and the checklist workbook only).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — EVENT-004: one version per corporation (Claude); 2026-11-19 — DEV-001b: read-only audit of code, docs and ARCHITECTURE.md (Claude Code).

## 2026-11-21 — RELEASE-001: `playtest-7` tag pushed (Claude)

The designer pushed `playtest-7` on `5bb7d71` from the local clone (`git -C … tag playtest-7 5bb7d71`, then push). Cloud Claude sessions can push branches but not tags: the session proxy refuses tag refs and the GitHub API tag path (HTTP 403). Future `playtest-N` tags go the same way, from the designer's machine. HANDOFF and checklist v0.7 updated. **Code changes:** none. **Tests:** none.

## 2026-11-21 — STRIP-001: core-loop test build (Claude Code)

**Designer, 2026-11-21:** "Let's build a stripped down test build with the extras stripped off and just focus on break, defend, and build." Decisions BW-001, PROBE-001, PROBE-003, BREACH-001, TURN-001, BURST-001, STR-001, CACHE-001 and STRIP-001 approved in the same session (quotes in the master design doc). Spec: `REDLINE_CORE_LOOP.md`.

**Built** behind `Game.CORE_LOOP` (true): 3 BW; PROBE 0 BW with +1 BW per extra PROBE on the same ICE per turn; PROBE reveals a VOID's top face-down subroutine; DEEP PROBE −5; BURST 3 → 5 BW with a per-copy rising cost; parting shot on BREACH; discard and draw before the Corporation Response; CACHED cards discarded between layers; no bloat tax or FORTRESS rolls; starter Icepicks STR 2 / 1 BW boost; the slice ICE rewritten (STR +2, no passives, fixed PULP, no CORTEX, no BOOTING, COOKIE BANNER all PULP); reward pool limited to `CardDB.CORE_POOL`; Generalist-only select screen; no COMPILE at the SAFEHOUSE. The export bundles `REDLINE_CORE_LOOP_CHECKLIST.md`.

**Tests:** `test_game.gd` 138 passed, 0 failed (new `test_core_loop.gd`; the legacy suite runs only when `CORE_LOOP` is false); `test_adp.gd` 17/0; `test_signal_carbon.gd` 671/0. Screenshot fixtures were not run locally (stopped for time); CI runs them on push.

**Bot sims (30 Generalist runs):** 24/30 cleared; 5 deaths, all at the CAPTCHA node (AUTO-RENEW STR 7 + CAPTCHA); 1 stalled run at CAPTCHA. 6.7 turns per encounter; 6.5 PULP reaching VITAE per encounter (target 2–4); 0.00 unspent BW per turn; 2.38 playable cards left per turn (the inert cards were already installed, so the figure is the same without them); 2.57 threat subroutines broken before each BREACH; parting shot 0.52 subroutines and 0.34 VITAE per BREACH; earliest Opening BREACH turn 2. The bot plays every cheap card, so treat VITAE as an upper bound.

**Interpretations to confirm**
- A PROBE on a VOID reveals its top face-down subroutine and that subroutine becomes **active**, so it also fires in the next response. ("The deeper you probe, the riskier.")
- Card removal uses the existing DECOMPILE option on the reward screen rather than a new SAFEHOUSE option; the SAFEHOUSE offers healing only.
- The legacy rules suite is skipped while `CORE_LOOP` is true, because it asserts the full-game values.
- Not yet done: the CACHE ∞ / N corner icon, and PROBE's cost shown while dragging over an ICE (HANDOFF rows).
- The CAPTCHA node is the bot's danger spot (AUTO-RENEW's FORTRESS STR 7 against a STR 2 FORTRESS Icepick). Left as specified for the designer's playtest.

**Log size (LOG-001):** moved the three oldest 2026-11-19 entries (CARDS-002) unchanged to the archive.

## 2026-11-21 — RELEASE-001: HALCYON PLAYTEST 8 (core loop) exported (Claude Code)

Designer chose "option 1": skip the legacy screenshot fixtures in CI while `Game.CORE_LOOP` is true, since they stage full-game states the stripped build switches off (the first failure was `shot_rustlers` expecting VECTOR's card-break choice). `release` fast-forwarded to `37a72a4`; workflow [44970043672](https://github.com/Punkwork/REDLINE/actions/runs/44970043672) passed and exported `PANOPTICON-HALCYON-PLAYTEST-8-0.8.0-playtest.8-Windows-x86_64` (BUILD_COMMIT, SHA256SUMS, guide, both checklists). The `playtest-8` tag could not be pushed from this session (proxy); the designer pushes it from a local clone. **To restore the fixtures:** set `CORE_LOOP` to false, or update the fixtures for the core-loop build (HANDOFF).

## 2026-11-21 — FORM-001 and FORM-002: ICE forms and more threat (Claude Code)

Designer after Playtest 8: "a whole lot more fun to play", but too little damage and TRACE. Built in the core-loop build: TRACE subroutines +2, PULP subroutines +1 (FORM-002); `Game.ice_form()` gives CHEERY / WARY / LETHAL from STR and breaks, LETHAL is stored for the encounter and doubles PULP and TRACE in `effect_value` (so the keys, the response and the parting shot all show and deal the doubled value); Black ICE get the look only (FORM-001). The encounter's `mood_for()` follows the form when `CORE_LOOP` is on.

**Tests:** `test_game.gd` 148 passed, 0 failed; ADP 17/0; SIGNAL/CARBON 671/0.
**Bot sims (30 Generalist runs, before the Black ICE look change):** 15/30 cleared; deaths at CAPTCHA 11, TERMS & CONDITIONS 4; 3.3 turns per encounter; 10.1 PULP to VITAE per encounter; 0.00 unspent BW; 2.5 threat subs broken first per BREACH; parting shot 0.6 subs and 0.9 VITAE. The bot doesn't plan around LETHAL, so this is a worst case.

**Interpretations to confirm:** "half its printed STR" uses the ICE's base STR, and "below half" is strict (STR 6 → WARY at 2 or less). A LETHAL ICE's mood stays lethal after its STR rises again.

## 2026-11-21 — BOOST-001 and SUB-001 after Playtest 9 (Claude Code)

Playtest 9 sheet (designer): the core loop is fun (PULP, PROBE, rewards and "wanted another run" all 5/5), but encounters took 2–3 turns, DOORBELL CAM was over in 2 and needed CORTEX, and spare BW went into boosts without a choice. Lethal came up once. Ten [UI] items recorded in HANDOFF.

**Built** (core-loop build): boosts reset at the start of each turn (BOOST-001); new effects HARDEN, SHIELD_BREAK, RETALIATE (X × broken subs, doubled when LETHAL), CORTEX back on DOORBELL CAM; the SUB-001 ICE table (`REDLINE_CORE_LOOP.md` §1b). The UI labels the new effects; their key icons use the generic glyph for now.

**Tests:** `test_game.gd` 168 passed, 0 failed; ADP 17/0; SIGNAL/CARBON 671/0.
**Bot sims (30 Generalist runs):** 8/30 cleared; deaths at CAPTCHA 16, TERMS & CONDITIONS 6; 3.2 turns per encounter; 12.6 PULP to VITAE per encounter; 3.1 threat subs broken before each BREACH; parting shot 1.0 subs and 1.1 VITAE. The bot doesn't plan around HARDEN, SHIELD BREAK or lethal forms and lost far more than the designer in Playtest 9: a worst case.

**Interpretations to confirm:** HARDEN stacks each time it fires; SHIELD BREAK removes all SHIELD when it fires, so PULP before it is still blocked; RETALIATE counts DEADLOCK breaks.

**Log size (LOG-001):** the two oldest entries were moved unchanged to the archive with the BOOST-001 commit. Playtest 10 exported from `236fa36` ([run](https://github.com/Punkwork/REDLINE/actions/runs/44979979788)).

## 2026-11-21 — RIDER-001, AMEND-001, DEFRAG-001, PLAY-002 after Playtest 10 (Claude Code)

Playtest 10 sheet: every question 5/5 (BURST not drawn); encounters 4–6 turns except TERMS & CONDITIONS (3, 2); discards mattered for the first time; parting shot on the final Node seemed missing. Checked: the engine fired it (TERMS OF SERVICE with only its DEADLOCK broken deals 12), but it landed instantly under the reward screen with a "Corporation Response is skipped" message. Now it plays through the response queue with a corrected message.

**Built:** RIDER-001 (`"then"` riders on TRACE effects, applied only when `trace_gained_node` rises; JAMMER), AMEND-001 (CONSENT FORM support, AMEND bonus on the ICE to the right, cleared after each response), DEFRAG-001, PLAY-002 (parting shot via `response_queue`, `_effect_feedback()` sounds and PULP shake).

**Tests:** `test_game.gd` 176 passed, 0 failed; ADP 17/0; SIGNAL/CARBON 672/0.
**Bot sims (30 Generalist runs):** **0/30 cleared**; deaths CAPTCHA 16, TERMS & CONDITIONS 14; 3.0 turns per encounter; 12.3 PULP to VITAE per encounter. The bot ignores riders, AMEND and lethal forms and lost far more than the designer in Playtest 10 (2–14 VITAE per encounter), so this is a worst case, but TERMS & CONDITIONS is now the hardest Node: watch it.

**Interpretations to confirm:** a rider fires once per TRACE subroutine if any TRACE lands (even 1 after PROXY CHAIN); JAMMER blocks whole TRACE subroutines, including ones combined with PULP (their PULP still hits); the placeholder sounds are synthesized, not final.

**Log size (LOG-001):** older entries moved unchanged to the archive with this commit.

## 2026-11-22 — Playtest 11 results (Claude)

Designer's sheet: run 1 died at TERMS & CONDITIONS (CONSENT FORM + TERMS OF SERVICE) on turn 3 after losing 10 + 13 + 6 VITAE; COOKIE WALL cost 9 VITAE in 2 turns (6 from the parting shot, whose size couldn't be read beforehand); AUTO-RENEW + CAPTCHA took 7 turns and 15 VITAE. Run 2 stopped at Node 3: the PROXY CHAIN rack overlay stayed on screen and covered the encounter (PT11-BUG-1). Scores: more plays than BW 4, threat-or-DEADLOCK 4, PROBE 5, BURST 3, PULP 5, rewards 5, another run 5. Bugs and UI items in HANDOFF (PT11-BUG-1, PT11-UI).

## 2026-11-22 — Playtest 12: PT11 fixes and TUNE-002 (Claude Code)

**PT11-BUG-1:** the stuck panel was the pinned card inspection (opened by clicking a rack card); it closed only on a right-click or Esc. It now closes on any click on it, a click outside it, or a phase change. **PLAY-002 fix:** the new hit sounds had no entry in the ADP effect volumes, so loading them threw an error and Playtest 11's per-type sounds never played; they now default to 0.8. **PT11-UI:** parting-shot total on the HUD and END TURN tooltip; untargeted cards drop anywhere above the hand tray; plain-word key tips for the new effects and riders; unplayable cards dim. **TUNE-002:** AMEND 1; TERMS OF SERVICE PULP 3.

**Tests:** `test_game.gd` 176/0; headless start-up has no script errors. Screenshot fixtures stay skipped under `CORE_LOOP`.


## 2026-11-22 — PROBE-004: PROBE choose-one (Claude)

**Designer:** PROBE does what it does now OR reveals hidden subroutines on a VOID, same costs. Recorded in the master design, `REDLINE_CORE_LOOP.md` (decision row, STRIP-001 VOID rule), HANDOFF (Claude Code TO DO) and checklist question 8. **Interpretations to confirm:** reveal = all face-down subroutines; the −2 STR mode no longer reveals; reveal unavailable with nothing face-down; the choice is shown only on a VOID. **Code changes:** none.

## 2026-11-23 — NUL-PILLAR-001: NUL/REM foundational design direction (Codex)

Designer confirmed NUL/REM as a foundational pillar of PANOPTICON's psychological experiment and requested preservation in GitHub. Recorded the substantive discussion, including the three conditions, implicit/explicit authority, active solicitation, deck-removal denial, safer routes, automated first install and advance ICE intelligence in `REDLINE_NULREM_BEHAVIOURAL_LOCK_IN.md` (f2b938b). Master design and HANDOFF cross-referenced. Individual mechanics remain proposals. **Code changes:** none; tests not run (documentation only). **Interpretations to confirm:** domain-specific authority, thresholds, revocation, intervention feedback, integration with existing canon and rules.

## 2026-11-23 — NUL-PILLAR-001a: Psychological Invisibility (Codex)

Designer explicitly confirmed that the experiment must remain psychologically invisible: no disclosure, classification, quantification or announcement of psychological progression. Expanded the existing NUL/REM design document with internalization as an emergent outcome, proposed silent withdrawal of enforcement and disconnection, and withdrawal of the proposed explicit THE CARBON psychological reveal. Master design and HANDOFF updated. No code changes; tests not run (documentation only).

## 2026-11-23 — NUL-PILLAR-001b: Played under surveillance (Codex)

Recorded designer-confirmed philosophical distinction and paradox of autonomy in the NUL/REM document, master design and HANDOFF. Experience is sufficient; no prescribed psychological outcome or measurement. No code changes; tests not run (documentation only).

## 2026-11-23 — NUL-PILLAR-001c: Four-Question Design Gate (Codex)

Recorded designer-requested NUL/REM mechanic review questions in foundational design, master design and HANDOFF. Failed or unresolved criteria require reconsideration; existing approvals remain. No code changes; tests not run (documentation only).

## 2026-11-23 — PHIL-001: Philosophical Design Bible (Codex)

Created the designer-requested eight-section Bible (c4f815d), including surveillance economy, curated rewards and both autonomy paradoxes. Cross-referenced master design, NUL/REM and HANDOFF. New mechanics remain PROPOSED. No code changes; tests not run (docs only).

## 2026-11-23 — PHIL-002: Algorithmic Reduction (Codex)

Preserved all six designer-requested explorations in Philosophical Design Bible §09 (b711f53), emphasizing recursive self-surveillance and disappearance of surprise. Master and HANDOFF updated. No code changes or tests (docs only).

## 2026-11-24 — PHIL-003: Gameplay Manifestations Catalogue (Codex)

Created living catalogue (e34eebd) with 39 proposed examples and one withdrawn example; stable GM IDs and principle tags. Linked Bible, master and HANDOFF. No code changes; tests not run (docs only). LOG-001: moved oldest two dated entries (CARDS-003a and CARDS-004/HAND-MAX-001) unchanged to archive.

## 2026-11-24 — PHIL-003a: Catalogue expansion (Codex)

Added designer-requested psychological effect and final concrete example columns (1fed957), primary grouping index, and withdrawn example annotation. Interpretations to confirm: grouping labels and illustrative scenarios are editorial hypotheses, not validated effects. No code changes; tests not run (docs only).

## 2026-11-24 — PHIL-004: Demoralization (Codex)

Preserved designer-requested autonomy burden and liberation paradox in Philosophical Design Bible §10 (88ae456), distinguishing two potential responses and prohibiting deliberate helplessness or disengagement. Master and HANDOFF updated. Interpretations to confirm: formal principle status and mechanics remain open. No code changes; tests not run (docs only).
