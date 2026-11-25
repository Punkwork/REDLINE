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

## 2026-11-23 — ARCH-V2-001: architecture migration governance (ChatGPT)

**Designer:** Approved a full-game hybrid scene-based, component-driven, data-driven Godot architecture instead of retaining the prototype's one-scene restriction. Explicitly chose `architecture-v2` as primary rebuild branch with `main` preserved as stable four-node prototype. The branch was created from `main`.

**Documentation:** Updated AGENTS.md, CLAUDE.md, master design, HANDOFF, and architecture notes on `architecture-v2` only. No gameplay code changed. No prototype tag created; baseline tests, new scene plan, CI and release migration remain to do. **Interpretations to confirm:** specific scene/data architecture and when/how to merge or release the rebuild require designer review.

## 2026-11-23 — ARCH-V2-001 blueprint folder drafted (ChatGPT)

Created six proposed documents under `docs/architecture-v2/`: README, scene hierarchy, data model, gameplay interface, migration plan and validation. They are architecture proposals, not designer-approved implementation details. No Godot files or rules changed; baseline tests and tag remain pending. HANDOFF updated for designer review.

## 2026-11-23 — ARCH-V2-001 decision history and compliance gate (ChatGPT)

At the designer's request, added `docs/architecture-v2/ARCHITECTURE_DECISIONS.md` (curated rationale and approval boundaries) and `COMPLIANCE_CHECKLIST.md` (evidence-based review checklist). Linked them from the blueprint README and required consultation before significant architecture changes in identical AGENTS.md and CLAUDE.md. No gameplay code changed, no baseline tests run, and no unreviewed implementation details approved.

## 2026-11-23 — ARCH-V2-001 static source audit (ChatGPT)

Inspected GitHub source on `architecture-v2`: project/scene, UI/controller and interaction scripts, Game/CardDB/IceDB, and CI workflow. Added `docs/architecture-v2/STATIC_SOURCE_AUDIT.md` with source-grounded dependency map, proposed file structure, risks and regression matrix. Critical finding: current `CORE_LOOP := true` causes CI to skip legacy screenshot fixtures. No Godot execution, screenshot review, baseline verification or gameplay changes performed. Proposals remain subject to designer approval.

## 2026-11-23 — ARCH-V2-001 dependency map (ChatGPT)

Added `docs/architecture-v2/DEPENDENCY_MAP.md` based on inspected Godot source. Traced click/drag card play, ICE break, targeted card, end-turn response, and UI refresh call paths; identified controller↔view coupling, direct Game dispatch from drop targets, and proposed staged migration seams. No runtime test, scene implementation, gameplay modification or architecture approval claimed.

## 2026-11-23 — ARCH-V2-001 formal component specification (ChatGPT)

Created `docs/architecture-v2/COMPONENT_ARCHITECTURE_SPEC.md` (CAS-001) with 18 proposed component contracts, ownership and lifecycle, command/snapshot boundary, allowed dependencies, migration stages, acceptance matrix and open designer decisions. Based on existing source audit and architecture documents. This is a PROPOSAL only: no Godot execution, production scenes, gameplay changes, or implementation approval.

## 2026-11-23 — ARCH-V2-001 VAS-001 visual architecture specification

Designer confirmed faithful reproduction of the supplied 1536×864 dense mechanical console mockup as the vertical-slice visual target. Created `docs/architecture-v2/VAS-001.md` defining reference regions, approximate geometry, material/type tokens, Godot-native vs art-backed controls, visual states, modular asset inventory, viewport adaptations, screenshot comparison and milestone acceptance. The reference image is not yet confirmed uploaded to GitHub. Documentation only; no graphics or gameplay implementation, tests, or implementation approval.
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

## 2026-11-24 — NUL-DIALOGUE-001: Dialogue compendium (Codex)

Created thematic register of 31 proposed lines (10d0d90), including six paired contradictions. Linked foundational, philosophical, master and HANDOFF docs. Interpretations to confirm: suggested triggers, associations and pairings are editorial; no new canon or approved copy. No code changes; tests not run (docs only).

## 2026-11-24 — NUL-DIALOGUE-001a: Earlier dialogue recovery (Codex)

Added 44 recovered entries (91c06e2), including 18 wording fragments. Interpretations to confirm: contextual labels editorial; transcript recovery partial; all copy proposed. No code changes or tests (docs only).

## 2026-11-24 — NUL-DIALOGUE-002: Dialogue architecture (Codex)

Created complete 13-section Bible (db37cb9), cross-linked four companion documents, master and HANDOFF. Interpretations to confirm: schema, events, pacing, cooldowns, content targets and QA are proposals; no implementation approved. No code changes; tests not run (docs only). LOG-001: moved oldest dated entry unchanged to archive.

## 2026-11-24 — OPS-001: Shared operations hub (Codex)

Created shared registers, report template and agenda; linked native issues/PRs; updated identical agent instructions. Interpretations to confirm: session-end reports, native issues as to-dos, proposed agenda pending designer confirmation. No code or tests (docs only).

## 2026-11-24 — OPS-002: Milestone progress (Codex)

Added proposed release goal, eight milestone gates and evidence-based measurement to master; initial provisional snapshot and daily update protocol in operations dashboard. Interpretations to confirm: release scope, gates, weights and baseline; architecture-v2 not audited. No code changes or tests (docs only).

## 2026-11-24 — OPS-002a: Commercial Steam release (Codex)

Designer confirmed actual Steam commercial launch, not merely release readiness. Master records creative goal, expanded M08 and proposed M09; dashboard and HANDOFF updated. Interpretations to confirm: detailed launch gate, pricing, schedule and weights. No code, tests, account or publication action.
LOG-001: oldest dated entry moved unchanged to archive.


## 2026-11-24 — UI-BIBLE-001 (Codex)

**UI-BIBLE-001 (designer direction, 2026-11-24):** [PANOPTICON UI Design Bible](https://github.com/Punkwork/REDLINE/blob/main/docs/PANOPTICON_UI_DESIGN_BIBLE.md) is the consolidated UI working specification, opening with “Visually rich but informationally restrained.” Icon-first resource HUD (Vitae, BW, RAM, Shield, incoming PULP), persistent top Ghostware rail and first ORIGIN badge in mockups. Existing decision IDs and rules authority remain unchanged. Source documents retained pending dependency/narrative audit; no parallel new UI briefs. No code changes. Initial consolidation commit `16265fb`. Documentation only; Godot tests not run. Interpretations to confirm: overflow behavior and exact glyphs remain open; source retirement deferred.


## 2026-11-24 — UI-WORKFLOW-001 (Codex)

**UI-WORKFLOW-001 (designer-approved, 2026-11-24):** GitHub Issues are the single authoritative UI proposal and development register for Claude Code, Claude, Codex and ChatGPT. Use stable component IDs from the UI Design Bible. Keep proposal discussion, mockup links, acceptance criteria, designer approval, implementation links and validation evidence in the issue; do not duplicate the backlog in HANDOFF or separate agent files. Only the designer approves; record approved decisions in Master Design and update the UI Design Bible as applicable. Development Log records actual work and links to the issue. Daily operations review uses the same issues. No code or rules changes. Registered 15 stable component IDs in the UI Design Bible §1a. Documentation only; no Godot tests run. Native issue numbers selected to avoid duplicate proposal numbering. No labels, board or individual issues created in this change.


## 2026-11-24 — DOCS-MIG-001 (ChatGPT)

Designer authorized mandatory documentation migration gate and next-session UI completion priority. Identical agent instructions, Master Design, HANDOFF and shared daily priorities updated. UI reference repair 2f1727f remains partial; full dependency validation, editorial reconciliation and retirement outstanding. Documentation only; no Godot tests run.

## 2026-11-24 — BYPASS-001 (ChatGPT)

Recorded designer rule restricting BYPASS to non-final encounters of Nodes of up to three encounters in master, core rules and HANDOFF. Specific mechanics remain open. No code or tests; no documentation consolidation performed.

## 2026-11-24 — EXP-DESIGN-001 (ChatGPT)

Created all-domain experimentation Bible (7e0928f) with initial BYPASS proposals, experimental cards, scenarios and viability/test framework. Interpretations to confirm: stable ID scheme and editorial organization; all specific mechanics remain proposed. UI issue authority preserved; no consolidation, code or tests.

## 2026-11-24 — BACKCHANNEL-001 (ChatGPT)

Saved designer-endorsed single-subroutine BACKCHANNEL iteration as EXP-C029, alternative versions, EXP-S009–011 and EXP-X004 in Experimentation Bible (ddc4793). Proposed terminology and timing questions retained. No rules, code, tests or consolidation.

## 2026-11-24 — NULL-POINTER-001 (ChatGPT)

Designer approved 1 BW instead of 2 for NULL POINTER; updated Deck Synergy §9.2 (08b5b6f), Master and HANDOFF. Runtime unchanged; no tests run.

## 2026-11-24 — RIOT-EXP-001 — RIOT experimental card catalogue (ChatGPT)

Designer requested preservation in Experimentation Bible §11 (bdc32508a880a9925010b0dde4bdbf0ac7b0fc57). EXP-C030–036, M007, S012–021, X005; revised FIRST STRIKE and one-copy BREAKER BAR with per-copy node escalation and BURN cost. Experimental only; NULL-POINTER-001 remains approved separately. No code or tests; UI migration gate unchanged.

LOG-001 archived oldest dated entry unchanged: ## 2026-11-19 — CARDS-004 and HAND-MAX-001 built: 1.4× cards, fanned hand, hand limit 10 (Claude)

## 2026-11-24 — TRACE-EXP-001 — TRACE mitigation concepts (ChatGPT)

Designer requested preservation of SIGNAL DAMPENER (Ghostware) and four Protocols in Experimentation Bible §12 (bc9938aa034cf6a39c6114472b4688b056e6cf1f); EXP-C037–041, M008, S022–027, X006. Proposed type distinction, self-inflicted TRACE coverage and trigger timing remain experimental. No rules/code changes, tests or consolidation.

## 2026-11-24 — NUL-DIALOGUE-003 — Economic dependency dialogue (ChatGPT)

Designer requested preservation of four lines NR-076–079 in NUL/REM Dialogue Compendium (28cd6dea0d23821902a025414a3333724c4b365c). Verbatim dialogue; contextual triggers and associations proposed. No shipping approval, gameplay changes, tests or consolidation.

## 2026-11-24 — CRED-EXP-001 / PHIL-005 — CRED-powered combat and economic dependency (ChatGPT)

Designer requested preservation of eight cards EXP-C042–049, mechanics M009–011, scenarios S028–034 and experiment X007 in Experimentation Bible §13 (bf8d742d3783d4cdb2a11e17e62d442b7fc8de52), and economic dependency/purchased freedom in Philosophical Design Bible §11 (aaafd9993e811a2a8b1169a9e9f3ed68b97f0bf6). Fully CRED-powered Icepick activations consume no BW; installation costs open. All mechanics experimental; philosophical direction designer-endorsed, not a new formal pillar. NR-076–079 already saved. No rules/code changes, tests or consolidation; UI migration blocker unchanged.

## 2026-11-24 — CRED-EXP-001a — Icepick installation cost (ChatGPT)

Designer specified 1 BW installation for PAYDAY, BRIBE and MERCENARY (EXP-C042–044); all activations remain CRED-only. Experimentation Bible §13 updated (9cfc95fe920dbfd5abfded3bccda06174cabec2b), including S035. Supersedes open installation cost in CRED-EXP-001 for these three cards only. Experimental, no code or tests.

## 2026-11-24 — CRED-EXP-001b — Program classification (ChatGPT)

Designer clarified EXP-C042–044 are RAM-using PROGRAM Icepicks, 1 BW install, CRED-only activation. Exact RAM TBD; 1 RAM suggested only. Experimentation Bible §13 corrected (0045b0d693b7386b6a6a83c83ca194e92005d784); canonical Core Rules §3.1 unchanged. No code or tests.

## 2026-11-24 — CRED-EXP-001c — Icepick RAM requirements (ChatGPT)

Designer specified PAYDAY 1 RAM, BRIBE 1 RAM, MERCENARY 2 RAM. Experimentation Bible §13 (a28329f275b87bd1d163e4e798cf5859b5e96958), EXP-S036; supersedes TBD RAM in CRED-EXP-001b. Other values unchanged. Experimental only; no code or tests.

## 2026-11-24 — VOID-EXP-001 (ChatGPT)

Saved exploratory VOID-only UNLOAD, Rustler-selected Program removal to discard, Program opportunity costs, EXP-M012/S037–042/X008 in Experimentation Bible §14 (171674b7e8b34d0dd4dad805b9861da4e22b0d0b). No rules/code/tests or consolidation.


## 2026-11-24 — CRED-EXP-001d — CRED SCRIPTS and card-type identity (ChatGPT)

Designer confirmed EXP-C045–049 as 0 BW SCRIPTS with existing CRED prices/effects, one resolution per play, normal discard/redraw, prior activation caps removed in preferred experiment. EXP-M013/S043–044, X007 extension in Experimentation Bible §15 (8d75932dad452669d6aefc0864bda40092e118df). Existing Protocols unchanged; experimental guidance only, no rules/code/tests or consolidation.

LOG-001 moved oldest dated entry to archive unchanged: 2026-11-19 — DEV-001: validate the card and hand baseline (Codex).

## 2026-11-24 — ICE-EXP-002 — Encounter-wide effects and subroutine modification (ChatGPT)

Saved 20 proposed cards EXP-C050–069, mechanics M014–015, scenarios S045–052, experiments X009–010 in Experimentation Bible §16 (27d5fb2ea234eaa8b1ebc87dada42b021fee6b17). Designer's targeted -6 PULP this turn/BURN preserved; names/costs provisional, collisions flagged. No rules/code/tests or consolidation.

## 2026-11-24 — CAP-EXP-001 — Infiltration CAPS (ChatGPT)

Saved twelve non-card CAP concepts EXP-CAP001–012, M016, S053–057 and X011 in Experimentation Bible §17 (98bc0b716700ad6aac90a6bc614b46496b5425c0). No CRED prices or rarities assigned; map activation and circumvention experimental. Existing CAPS rules unchanged. No code/tests or consolidation.

LOG-001 moved oldest dated entry to archive unchanged: 2026-11-19 — PIXEL-TRACE-001: TRACE pixelates the corporation's picture (Claude).

## 2026-11-24 — SURV-MEM-001 — Surveillance and memory (ChatGPT)

DIRECTION, designer-confirmed: “As the player learns the game, the game learns the player.” “The system always remembers. It never forgets.” Pervasive fictional surveillance across runs. Five-stage table and proposed memory layers saved in Experimentation Bible §20 (57bfe20002567740e0e91cde85a809df280ce7e2); prior ICE-SURV-EXP-001 / SURV-EXP-001 proposals in §§18–19 (eb335be5b95c05488f3a966f5d90a47280675523). Philosophical Bible cross-reference. No approved mechanical changes, code, tests or consolidation. Interpretation: thematic persistence does not remove real-world local data reset or privacy controls.

## 2026-11-24 — CARBON-SURV-EXP-001 — Collective trust and individual authority

Designer-endorsed philosophical exploration: keep THE CARBON (collective trust) and NUL/REM (personal autonomy) distinct. Corporate appropriation of trusted resistance spaces may erode collective trust and increase reliance on individual authority. “The system creates the conditions that make its own assistance necessary.” Full progression, examples, comparative framework and open questions preserved in [Design Experimentation Bible §21](PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md), commit 02e46011863db27f2ac03ed922aa038358bc8a77. EXP-D003 / EXP-X013 remain proposed; no mandated psychological outcome, approved mechanics, code, tests or consolidation.

## 2026-11-24 — SURV-UNCERT-EXP-001 — The uncertainty of observation

Designer-endorsed exploration: possibility of observation, fictional fear/anxiety/suspicion, ambiguity of coincidence, self-regulation and freedom exhaustion. Designer identified Francis Ford Coppola's The Conversation (1974) as reference. Preserve the “constant low hum anxiety” experiential direction as fictional atmosphere, not deliberate actual distress. Linked to SURV-MEM-001 and CARBON-SURV-EXP-001. Full tables, examples and safeguards in [Design Experimentation Bible §22](PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md), commit 6b36c117b89c4f32edfef77c7241c8fb6db59a28. No approved mechanics, production dialogue, code, tests or consolidation.

## 2026-11-24 — SURV-OBSERVER-EXP-001 — The Internalized Observer

Designer confirmed The Parallax View (1974, Alan J. Pakula) and The Conversation (1974, Francis Ford Coppola) as principal cinematic references. Recorded in Design Experimentation Bible §23, commit 307703473a5a9f3ec8a9fe0a6f34800815d2342b. Reference-only; no new rules, specifications, code or tests.


## 2026-11-25 — ARCH-V2-002: branch reconciliation; `architecture-v2` canonical (Claude)

**Designer approval (2026-11-25):** `architecture-v2` is the main branch moving forward, to be recorded in Master Design; tag the baseline; delete the duplicate image; make the new branch the default. Recorded as ARCH-V2-002.

- **Audit (Gate A):** `main` `21922ad`, `architecture-v2` `6cb5ed1`, common ancestor `f168046`; 182 main-only commits (about 40 decision IDs, 22 files, docs and agent files only) and 43 v2-only commits (ARCH-V2-001 governance, `docs/architecture-v2/`, VAS-001 image). Neither side changed Godot code, tests or CI. No open PRs; no GitHub Issues exist.
- **Merge `6b1acdd`:** `git merge --no-ff` of `main` into `architecture-v2`. Conflicts in Master Design, HANDOFF and this log were additive; both sides kept, unreworded. A line check confirmed every line of both parents is present (lines missing from v2's log are LOG-001 moves already in the archive; HANDOFF rows edited on `main` keep `main`'s wording).
- **Governance correction:** `AGENTS.md` and `CLAUDE.md` (still identical) now name `architecture-v2` in the header, §1, §3 session start, §8 operations and §9 migration gate (sections renumbered; HANDOFF and DAILY_PRIORITIES references updated). HANDOFF "How we work", `operations/README.md`, `REDLINE_CURRENT_STATUS.md` and `REPOSITORY_STRUCTURE.md` updated. Master Design entry ARCH-V2-002 added. Duplicate `PANOPTICON_VAS-001_reference_mockup (1).jpeg` removed (SHA-256 identical to the canonical file, `513af903…df25e`).
- **Baseline and validation:** Godot 4.3.stable.official.77dcf97d8, headless, fresh `XDG_DATA_HOME`. On `main` `21922ad`: import exit 0; `test_game.gd` 176 passed / 0 failed (also with `SIM=1`); `test_adp.gd` 17 / 0; `test_signal_carbon.gd` 672 / 0. Same results on the merged tree. Relative Markdown links: 0 broken. Not run: screenshot fixtures (CI skips them while `Game.CORE_LOOP` is true), Windows export, any Windows playtest. The approved tag `prototype-baseline` on `21922ad` and the default-branch switch were refused by GitHub through the agent proxy (HTTP 403 on tag push; "Repository settings writes are not permitted"); both are left to the designer. Commits: merge `6b1acdd`, correction `b03df7f`, this status fix.
- **Still open:** DOCS-MIG-001 / UI-BIBLE-001 (seven imported sources still in the tree; the UI Bible links them through `blob/main/...` URLs, which should become commit-pinned before retirement); a release procedure for `architecture-v2`; seeding GitHub Issues; external agent configurations that name `main`.
- **Interpretations to confirm:** "main branch for the rebuild" is recorded as covering all project work, per the reconciliation brief.
- **LOG-001:** moved the oldest dated entries to the archive unchanged: 2026-11-19 — PIXEL-TRACE-001a: animated pixel step changes (Claude), 2026-11-19 — PIXEL-TRACE-001b: bit-crushed music with the pixel steps (Claude), 2026-11-19 — PIXEL-TRACE-001c: a transition sound effect, to be chosen (Claude), 2026-11-19 — ENC-ANALOG-001 saved; ICE-ANALOG-001 brief for Codex (Claude), 2026-11-19 — ICE-ANALOG-001: editable Godot visual study (Codex), 2026-11-19 — ICE-ANALOG-001 designer approval for default encounter integration, 2026-11-19 — ICE-ANALOG-001 built; ENC-CONCEPT-001 direction and art briefs (Claude).
- **Update 07:40:** the designer switched the GitHub default branch to `architecture-v2`; verified via the GitHub API. Tag `prototype-baseline` still pending.
- **Update 07:42:** the designer published tag `prototype-baseline` on `21922ad` (GitHub pre-release); verified with `git ls-remote`. ARCH-V2-002 items complete.

## 2026-11-25 — ARCH-V2-002: audit corrections (Claude)

ChatGPT's independent audit (designer-relayed, 07:44) found three governance defects; all confirmed and corrected:
- **AUDIT-001:** HANDOFF session routine said "pull `main`"; now `architecture-v2`.
- **AUDIT-002:** HANDOFF said ARCH-V2-001 superseded MAIN-001 "for migration work only"; now ARCH-V2-002, all active work. HANDOFF item 7 (builds) likewise.
- **AUDIT-003:** Master Design DOCS-MIG-001 said "batches on main"; now `architecture-v2`, with the original wording and the 2026-11-24 authorization kept in the text.
- **Repo-wide scan:** every reference to `main` checked by hand (186 candidate lines). Also corrected: the UI Design Bible links in HANDOFF and Master Design pointed to the frozen copy on `main` (`blob/main/...`), now relative; ARCH-V2-001's stale status note; MIGRATION_PLAN's proposed tag name annotated. Left as history: RELEASE-001/MAIN-001 records, playtest build records, log and archive, legacy-source Codex prompts ("Repo: Punkwork/REDLINE on main" in ENCOUNTER_ANALOG and the UI Bible import), the UI Bible's seven `blob/main/...` source links (DOCS-MIG-001 work), third-party `blob/main` URLs (Google Fonts, gitignore). Scripts and CI contain no branch-specific `main` (CI validates every branch; exports only on `release`).
- **ARCH-V2-002 items operationalized:** h atomic decision-grouped commits (AGENTS/CLAUDE §1.7), i daily branch-drift check (operations README, report template), j `main` protection (AGENTS/CLAUDE §1.8; GitHub protection verified **off**, designer TO DO), g Architecture V2 precedence for UI construction (AGENTS/CLAUDE §4, §7). Master Design lists items a–j with sources.
- **Validation:** test_game 176/0, test_adp 17/0, test_signal_carbon 672/0; 0 broken relative links; AGENTS = CLAUDE; no files from either branch tip lost except the approved duplicate image; no decision ID from either tip's Master Design, Experimentation Bible, Manifestations, UI Bible, Core Rules or HANDOFF lost; no status line changed except the annotated ARCH-V2-001 status; `godot/`, tests, tools, CI and prototypes unchanged vs `prototype-baseline` except the VAS-001 image and its README.
- **Interpretations to confirm:** the audit mentions eight ARCH-V2-002 decisions without listing them; Master Design records ten items (a–j) found in the designer's messages and the brief.

- **LOG-001:** moved the oldest dated entries to the archive unchanged: 2026-11-19 — ENC-CONCEPT-001: concept-3 interface in the encounter (Claude), 2026-11-19 — ENC-CONCEPT-001: ChatGPT art wired into the encounter (Claude).
