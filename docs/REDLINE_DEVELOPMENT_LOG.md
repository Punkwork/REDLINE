# PANOPTICON — DEVELOPMENT LOG
**Initialized:** 2026-11-09  
**Policy:** append dated entries; distinguish reported outcomes from verified tests.

**LOG-001 (2026-11-16):** entries from 2026-11-08 to 2026-11-14 are in `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md`, unchanged. Keep this file under about 60 KB (HANDOFF, "How we work" 6).

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


## 2026-11-19 — CARDS-002 Mustard PCB review archive (Codex)

Saved ten review sheets, three final Godot captures and the reproducible prototype for the fifth cartridge design. The designer requested centred rules inside a fixed PCB trace frame and a single top-edge rarity light. The final capture fixture verified all three indicators, frame geometry, alignment and text fit in Godot 4.3. The archive is under `docs/visual/fixtures/cards-002/`.

## 2026-11-19 — CARDS-002 review archive moved to `review/cards-002` (Claude)

**Designer direction:** CARDS-002 mustard review work stays out of `main`: "None of it's to be kept with the main build." The designer approved a review branch.

**Changed:** created `review/cards-002` from `0f4a312` (the Codex review archive) and added the 2026-11-19 review fixes there (`d30b531`). Removed `docs/visual/fixtures/cards-002/` from `main`; the master design entry and HANDOFF now point to the branch. The playable build is unchanged, and the built CARDS-002 PCB palette (`0aa6091`) stays on `main`.

**Interpretations to confirm:** the branch is never merged; the earlier "Mustard PCB review archive" entry is kept as history even though its folder now lives only on the branch.

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — CARDS-001: integrated light faces and printed titles (Codex).

## 2026-11-19 — CARDS-003 PCB glow cartridges in the build (Claude)

**Designer approval:** "Go with this dark panel tint for now it works. Yes i want these stencil designs. Commit these changes to the cards for godot. This is good. Save to all git folder necessary." CARDS-003 is APPROVED and supersedes the CARDS-002 palette.

**Changed:** `card.gd` takes the reviewed patch from `review/cards-002` (`8783b44`), with production names (`pcb_glow`, `PCB_*`, `CircuitStencil`). It gives:
- per-type layout, masks, circuit stencils and rarity lamps;
- ivory glow text with amber bold numbers;
- a single cyan cache glow;
- no printed rarity or CACHED text.

New beyond the review: a grafted card shows its graft art in the stencil slot. Fonts `RoutedGothic.ttf`, `Barlow-SemiBold.ttf` and `Barlow-Bold.ttf` are added with OFL licences and listed in `SOURCES.md`. New fixture `godot/tests/shot_cards_pcb.gd` is added to the CI screenshot list; it prints `Assertion failed` so the CI log grep catches failures. Reference sheets are in `docs/visual/fixtures/cards-003/`.

**Validation:** Godot 4.3. Rules 361/0, ADP 17/0, SIGNAL/CARBON 671/0. All 14 CI screenshot fixtures ran with no `SCRIPT ERROR`, `Parse Error` or `Assertion failed`. `shot_facade` prints one "resources still in use at exit" warning, which also appears on `main` without this change. `shot_cards_pcb` passed with 0 failures, and all 444 rules texts fit at 9 px or larger.

**Interpretations to confirm:**
- Grafted cards replace the stencil with graft art.
- The old non-glow card paths stay in `card.gd` behind `pcb_glow`. They are now unreachable for all four types; removing them is proposed below rather than done (no-refactor rule).

**Proposed (not done):** remove the unreachable pre-CARDS-003 card paths (toner illustration atlas, printed rarity finish, separator, text CACHED tag) from `card.gd`.

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — CARDS-001: selected board colours and Whirlwind Bloatware (Codex).

## 2026-11-19 — CARDS-003 cleanup; CARDS-003a long-text layout (Claude)

**Designer approval:** "I approve code cleanup."

**Cleanup:** `card.gd` setup now has a single CARDS-003 path; every card type uses it. Removed:
- the toner illustration path and `ArtBox`;
- the printed rarity finish (`cartridge_finish.gd` deleted);
- the separator and old title strip;
- the old rules box, its amber markup and the corporate footer label;
- the text CACHED tag;
- the superseded CARDS-002 palette colours (`BOARD_PALETTE` became `BOARD_RECT`) and `PCB_INK`.

The `toner-illustrations.png` asset is kept. In `shot_cartridges`, three checks had been vacuous since CARDS-003 because the nodes they looked for no longer existed: rules fit, art frame and rarity. They now target the rules panel, the stencil or corporate art slot, and the rarity lamp.

**Found during the cleanup:** with its rules-fit check live again, `shot_cartridges` failed on compiled SCRIPT cards (SAFEHOUSE COMPILE). On a display, 107 of 1,008 compiled pairs don't fit the fixed CARDS-003 rules panel at 9 px. The pre-CARDS-003 layout collapsed its art for long text. The CARDS-003 sweep covered only base cards.

**CARDS-003a (PROPOSED, fix applied):** when rules don't fit the standard panel at 9 px, `glow_layout(type, true)` gives a tall layout. It drops the stencil, puts the type plate under the title, and makes the rules panel 138 px wide, filling the freed space. Rules there may shrink to 8 or 7 px as a last resort rather than clip; that applies to 2 texts. A graft on a tall card shows as a small part on the chassis edge, as before CARDS-003. `shot_cards_pcb` now sweeps 1,452 texts (base cards at AMP 0–3 plus every compiled pair) and fails on any clipping. It also captures the longest compiled card (295 characters).

**Validation:**
- Rules 361/0, ADP 17/0, SIGNAL/CARBON 671/0.
- All 14 CI screenshot fixtures clean; `shot_cartridges` 601/0 and `shot_cards_pcb` 0 failures.
- All 115 existing screenshots are pixel-identical to the pre-cleanup run; one new capture was added.
- `shot_facade` still prints only its pre-existing "resources still in use at exit" warning.
- Headless Godot measures text differently from a display (384 pairs against 107). The sweep runs on a display, as players do.

**Interpretations to confirm:** CARDS-003a as a whole; the 7 px last resort; dropping the stencil on long cards.

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — CARDS-001: instrument amber accents (Codex).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — CARDS-001: glowing text instead of amber blocks (Codex).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — CARDS-001: distinct board surface textures (Codex).

## 2026-11-19 — CARDS-003a: card names on the face, full text on hover (Claude)

**Designer direction:** "I prefer the full text to show on a hover, as the solution. And on the card while it's in your hand, where the card text is, place the card names." It replaces the tall layout proposed in the previous entry.

**Changed:**
- `card.gd`: the tall layout is removed, so every card uses the standard panels.
- When a card's rules don't fit at 9 px (`summary_rules`), the rules panel names the component cards in effect order, joined by a small THEN, with a "Hover for full text" footer.
- Hovering shows `FullRulesPanel`: the full rules in a mask panel 220 px wide, sized to the text. It is placed above the card in screen space, so a scrolling reward row cannot clip it, and kept inside the window.
- The tooltip drops the rules line for these cards.
- The footer band in a rules panel is now 15 px and its line is centred in it, so it clears the plated pads on the panel edge; this applies to BLOATWARE's corporate line too.
- `shot_cards_pcb`:
  - sweeps 444 base texts, all of which must fit;
  - sweeps the 1,008 compiled pairs: 901 fit on the face, and 107 show names with hover, where the names must fit at 9 px;
  - checks the names and hint on a summary card;
  - checks the footer's clearance from the pads;
  - adds a hand-size hover capture, checking that the panel is visible, holds the full text, fits, stays on screen and doesn't cover the card.

**Validation:**
- Rules 361/0, ADP 17/0, SIGNAL/CARBON 671/0.
- All 14 CI screenshot fixtures clean; `shot_cards_pcb` 0 failures at 3× and 1×.
- The other CI fixtures' screenshots are unchanged.

**Interpretations to confirm:** the THEN joiner; the hint line; only cards that don't fit use names and hover; the panel opens below the card if there is no room above.

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — VISUAL-DECISIONS-2026-11-17: approved visual decisions recorded in the master design doc (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — MAIN-001: HANDOFF points to main (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — MAIN-001: Windows export runs on main (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — RUSTLER-LOOK-001: two Rustler styles kept on purpose (Claude).

## 2026-11-19 — CARDS-003a confirmed (Claude)

**Designer:** "Great save those changes." This confirms the CARDS-003a interpretations: the THEN joiner, the "Hover for full text" hint, names and hover only for cards whose text doesn't fit, and the panel opening below the card when there is no room above. Master design and HANDOFF updated. **Code changes:** none.

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — VISUAL-APPROVALS-002: prototype art and working values approved (Claude).

## 2026-11-19 — CARDS-004 larger cards; HAND-MAX-001 maximum hand of 10 (Claude)

**Designer:** "The cards in general should be larger, 16 bit or not." The designer chose 1.4× and a mockup first. After the mockup: "Have the cards slightly overlap based on the number of cards. We should determine a maximum hand size." Answers: maximum **10**; a draw past the maximum **stops, and the card stays on the draw pile**; the BW cost dial **stays top-right**.

**Mockups (session only, not committed):**
- Godot renders of the COOKIE BANNER encounter with 1.4× cards in a full-width hand, the side columns moved up, the strips moved up 104 px and the ICE area scaled to 77%.
- A hover capture.
- Hands of 6, 7, 8 and 10 cards. Overlap at those counts: none, about 15%, about 28% and about 43%.

**Evidence (30-seed bot runs, HALCYON slice, hand size at the start of each player turn):**
- GENERALIST, RIOT and VECTOR peak at 6. RIOT's many 1-card turns are its known DOORBELL guard stalls.
- ECHO: 6 cards on 204 turns, 7 on 110, 8 on 12, 9 on 6, and 10 on 1 (of 426).

**Recorded:** CARDS-004 and HAND-MAX-001 as APPROVED in the master design doc, with a note on VIS-001's old hand-size line. HAND-MAX-001 goes in a new Core Rules amendments table. HANDOFF has two Claude Code TO DO rows. **Code changes:** none yet.

**Interpretations to confirm:** any non-draw effect that would move a card into a full hand (for example retrieval from discard) does nothing.

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — CHROME-001 / CARDS-001 / MAIN-001 follow-up (Codex).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — DEPRECATE-001: LOGIC BOMB and RELAY deprecated (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — READ-001: darker SCRIPT face for legible printing (Claude).

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
