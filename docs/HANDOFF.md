# PANOPTICON — HANDOFF (shared to-do for Codex and Claude)
**Started:** 2026-11-15 · **Owner of decisions:** the designer (John Stevers)

This is the one list of work that has been **decided but not finished**, so Codex and Claude never work from different pictures of the game. The design docs say *what* the game is; the development log says *what happened*; this file says *what's next and who does it*.

---

## How we work

1. **Work on `main`** (designer, 2026-11-17; replaces the 2026-11-15 rule that used `codex/halcyon-playtest-stabilization`). Follow the working agreement in `AGENTS.md` / `CLAUDE.md`: start from the latest `main`, record design decisions in `REDLINE_MASTER_DESIGN.md`, report the commit where finished work lives, and ask the designer before creating a branch. The former working branch was merged into `main` at a523502 and is no longer used.
2. **The repo is the source of truth.** `docs/` here is authoritative. The Claude project "Panopticon" holds copies (`claude/REDLINE_*.md`) for claude.ai chats; Claude refreshes them from `main`.
3. **Who does what.**
   - **Claude:** design docs and proposals, playtest analysis, this file, the project copies.
   - **Codex:** the Godot build (`godot/`), tests, exports, `REDLINE_CURRENT_STATUS.md`.
   - **Either:** small doc fixes that follow a decision already recorded.
   - **Only the designer** marks a decision APPROVED. A proposal stays PROPOSED until the designer says so in a session, and the session's log entry quotes or records that.
4. **Every change has a decision ID** (e.g. REJECT-001) that appears in the design doc, in this file and in the development log.
5. **Session routine.**
   - **Start:** pull `main`; read this file, then the latest entries of `REDLINE_DEVELOPMENT_LOG.md`.
   - **End:** move finished items to *Done* (with the commit), add new items, and add a dated log entry that says who wrote it (`(Codex)` or `(Claude)`).

6. **Development log size (LOG-001).** Keep `REDLINE_DEVELOPMENT_LOG.md` under about **60 KB** so Claude can rewrite the project copy in one pass. When it grows past that, move the oldest dated entries, whole, to the end of `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md` (oldest first, nothing reworded) and note the move in the log. Entries stay append-only; the archive is never edited except to append.

**Statuses:** **TO DO** (decided, not started) · **IN PROGRESS** (name who) · **BUILT** (in code, needs a playtest or check) · **DONE** · **WAITING** (needs a designer decision).

---

## To build (approved, not yet in the build)

### Start here (Codex): decisions made 2026-11-16
ZEROED-001, its RIOT cards, and TUMBLE-001 are built; see the tagged rows below. ROT-001 documentation sync and LOG-001 split were already completed in PR #8. No remaining Codex TO DO rows from this block. VIS-001 is built on `main`; see Built below for the review tag.

**Next build: everything in `REDLINE_DECK_SYNERGY.md` (DSY-001 to DSY-014) and `REDLINE_PACING.md` (PACE-001 to PACE-010), approved as written on 2026-11-15.** Suggested order, so each step can be playtested before the next; numbers are working values. Where a system isn't in the slice yet (Uplink, Console Lab, PATCHWORK, Ghostware), build the part that touches it when that system arrives, and say so in the log.

| ID | What to build | Spec | Owner | Status |
|---|---|---|---|---|
| **PACE-004, 010** | Score each slice layer (BREACH WORK, REVEAL FLOOR, VITAE) from playtest 2's turns and VITAE; propose ICE changes. | Pacing §4.1, §9 | Claude | TO DO (needs playtest 2 data) |
| **DSY-014, PACE-007** | Phase 7 pools on the synergy grammar, with 2 HULL engines per Rustler pool. *(RIOT's ZEROED keyword written up: ZEROED-001.)* | Synergy §5.1, Pacing §6 | Claude | TO DO |

**Atomic Deco Punk and the punch cards (approved 2026-11-17):** build from `REDLINE_ATOMIC_DECO_PUNK.md` (Phase 2 copy, approved in full: `REDLINE_ADP_PHASE2_COPY.md`) in order **Phase 1 (ADP-1a–f) → Phase 2 (ADP-2a–c) → Phase 3 (ADP-3a–c) → Phase 5 (SIG-5a–d)**, adding Phase 4 fixtures (ADP-4a) as each phase lands. Owner: Codex. Phases 1–3 are built for the HALCYON slice. LUCIDA and PATCHWORK integration await their playable systems. Next is Phase 5.

**The Archipelago (ARCH-001, approved 2026-11-18):** build ARCH-1a–c from `REDLINE_ARCHIPELAGO.md` §8 (relocation defeat screen and *THE CARBON* page; local persistent *THE CARBON* record read at DEAD DROP; copy tables with guards: "Archipelago" never in corporate or rules strings, "gulag" never on screen, island-purpose lines tagged `reveal`). Owner: Codex. Order: after ADP Phase 2, alongside Phase 5 (SIG-5d). No rules change.

**Conditional (approved, build only if the condition is met):** PACE-003's BOOTING on the 4th turn, if playtest 2 shows the Opening Node breached before turn 4. PACE-006's safety valves (Max VITAE 35–40, full-clear heal 3, a second SAFEHOUSE), if playtests run too hot. PACE-009: watch RIOT's TRACE in longer encounters.

---

## Built — awaiting designer playtest

| IDs | Change | Commit reference |
|---|---|---|
| HAND-CLEANUP-001, CARD-CONTROLS-001, ENCOUNTER-DISPLAY-001 | Remove free HOLD, install and inspect PROGRAMs in the left bay, drop SCRIPTs on their play zones, toggle 150% card inspection, and fill fullscreen with the backdrop and enlarge ICE avatars by 25%. | **BUILT** — [Codex implementation entry](REDLINE_DEVELOPMENT_LOG.md#2026-11-17--hand-cleanup-001-and-card-controls-001-codex) |
| ADP-001 Phase 3 (ADP-3a–c), ADP-4a | Local ads and settings, guarded LUCIDA record edits, and instance grafts with fixtures. | **BUILT** — [Codex implementation entry](REDLINE_DEVELOPMENT_LOG.md#2026-11-18--adp-001-phase-3-and-adp-4a-codex) |
| ADP-001 Phase 2 (ADP-2a–c), ADP-4a | Approved voice, encounter hesitation, patent plates, and newsreels. | **BUILT** — [Codex implementation entry](REDLINE_DEVELOPMENT_LOG.md#2026-11-18--adp-001-phase-2-and-adp-4a-codex) |
| ADP-001 Phase 1 (ADP-1a–f) | Bleed and hostile reveal, zine wear and barcode strips, three-stem prototype mix and mechanical effects, and corporate Poiret One display text. Review PNGs and audio in `docs/visual/fixtures/adp-001/`. | **BUILT** — [Codex implementation entry](REDLINE_DEVELOPMENT_LOG.md#2026-11-17--adp-001-phase-1-codex) |
| FACADE-ART-001 | Four backgrounds, fourteen transparent shells, corporate palettes, prompt provenance, and eight Opening Node captures. | **BUILT** — [Codex art and validation entry](REDLINE_DEVELOPMENT_LOG.md#2026-11-17--facade-art-001-ironwatch-and-lucida-art-codex) |
| DEPRECATE-001 | Removed LOGIC BOMB and RELAY; replaced the rare SCRIPT specimen with PAYDAY. | **BUILT** — `2bea490` |
| ICE-AUDIT-001 | Applied the approved HALCYON ICE revisions. | **BUILT** — `0ac64c3` |
| PULP-001 roll | Published seeded FORTRESS PULP rolls and exact PULP-002 curve values. | **BUILT** — `b44254c` |
| HALCYON validation and fixtures | Reran the 30-seed simulations and refreshed VIS-001, CHROME-001 and CARDS-001 fixtures. | **BUILT** — [validation commit entry](REDLINE_DEVELOPMENT_LOG.md#2026-11-17--validate-halcyon-and-refresh-fixtures-codex) |
| CARDS-001 | Heavy SCRIPT/PROGRAM/PROTOCOL slot-cartridge templates; external BW rating tabs; brown/olive/teal board faces, oxide-red Whirlwind Bloatware and direct-print titles; common/uncommon/rare finish details; protected protrusions; nine close-ups and six/eight-card captures. Types, rarity weights, costs and rules unchanged. | **BUILT** — `cards-001-board-textures` · Art approved 2026-11-17 (VISUAL-APPROVALS-002); playtest pending |
| CHROME-001 | Refine the CAPTCHA encounter in the designer-selected Chrome Deco direction: readable real rules/cards, illustrated mascot shells, atrium, corporate escalation and native interaction feedback. Ten full-screen PNGs refreshed against the current CARDS-001 treatment; pearl-enamel ICE service plaques; type-specific heavy slot cartridges with outside BW tabs and restrained rarity finishes. | **BUILT** — `chrome-001-enamel` (code `chrome-001-step5`) · Art approved 2026-11-17 (VISUAL-APPROVALS-002); playtest pending |
| VIS-001 | The Friendly Lie encounter: fonts/skins, zine hand/HUD, mascot scans and moods, corporation break states, drag/motion/accessibility, seven PNG review fixtures. Visual only; ZEROED/TUMBLE integrated first. | **BUILT** — `vis-001g` (steps `vis-001a`–`vis-001g`) · Art approved 2026-11-17 (VISUAL-APPROVALS-002); playtest pending |
| TUMBLE-001 | Remove broken TUMBLER subs and tumble immediately active replacements | **BUILT** — `zeroed-tumble-step3` |
| ZEROED-001-cards | Replace INTEGER UNDERFLOW with NULL POINTER and add RIOT ZEROED cards | **BUILT** — `zeroed-tumble-step2` |
| ZEROED-001 | Restore STR floor and track once-per-ICE ZEROED | **BUILT** — `zeroed-tumble-step1` |
| UI-004 | HOLD and READY RIG choices use a single horizontal scrolling row; full card height and last-card access verified. | **BUILT** — `codex/horizontal-choice-menus` |
| PACE-003,005,007,008 | DEADLOCK ×N progress for paid/card/WORM breaks; independent ESCALATE counters for TRACE/DISCARD/FORGET; reward need icons and visible draw chance; Tier 1 one-layer route; tier-aware reward odds; +50% reserves; version/label 0.3.0-playtest.3 / HALCYON PLAYTEST 3; post-merge-only Windows export; updated playtest guide and nine new UI fixtures. Final regression review also completed AMP for SILENT PARTNER/PAIN TOLERANCE, amplified card text, compiled fallback coverage, and Node/run state resets. | **BUILT** — `playtest3-pacing` (commit tag) |
| DSY-004,005,013 | SAFEHOUSE COMPILE with ordered effects, combined costs and tags, interactive continuations, CLEAN BUILD; MINIMALIST and ZERO FOOTPRINT; Ghostware effect hooks; corporation pushback ICE definitions and triggers (Tier 2 placement deferred after PACE-008). | **BUILT** — `playtest3-step5` (commit tag) |
| DSY-009,010 | Negative ICE STR *(to revert: ZEROED-001)*, MARGIN previews, SCALPEL, STACK SMASH, INTEGER UNDERFLOW, CULL and HARVEST; AMP on virus effects. | **BUILT** — `playtest3-step4` (commit tag) |
| DSY-011,012 | CHAIN tracks successful card plays; PIVOT, COVER FIRE, HANDOFF and KILL CHAIN; HOLD 1 and DEAD MAN’S POCKET HOLD 2; scrollable choices. | **BUILT** — `playtest3-step3` (commit tag) |
| DSY-007, DSY-008 | REBOOT queues drain only after draws finish; AMP and seven specified cards, SCAN bottom-order choice, in-Node BURN and discard retrieval, HUD reboot estimate, and bot choice handling. | **BUILT** — `playtest3-step2` (commit tag) |
| DSY-001, DSY-002, DSY-003, DSY-006 | FOOTPRINT/caps and bands, per-Node bloat TRACE, optional GHOST draw OFF, duplicate-aware draw estimates and key-card previews, COVERAGE/tag density, and guarded full-clear DECOMPILE. | **BUILT** — `playtest3-step1` (commit tag) |
| REJECT-001 | REJECT ALL has one DEADLOCK in its three-entry pool; BOOTING remains turn 3. Updated opening rules checks and bot timing reporting. | **BUILT** — `playtest3-step0` (commit tag) |

Per-step results and interpretations: [HALCYON_PLAYTEST3_IMPLEMENTATION.md](HALCYON_PLAYTEST3_IMPLEMENTATION.md).

## Deferred beyond this slice (playtest 3)

- DSY-004/005: PATCHWORK/FUSE modifications, Console Lab/BLACK CLINIC/Node completion upgrades, and Uplink REFACTOR (50 CRED, once per visit). SAFEHOUSE COMPILE works now; other service flows do not exist.
- Ghostware acquisition/selection, DEDUPLICATOR with FUSE, and CAPS. HEARTBEAT, MINIMAL INSTALL, ONE-TRICK and DEAD MAN’S POCKET effects have tested state hooks.
- DSY-013: Tier 2 FREE TRIAL placement and other corporation maps. All three pushback definitions/triggers are tested. This four-row map is Tier 1, so the final pacing step removes the temporary Step 5 Tier 2 placement.
- PACE-003/005: notation and engine support tested; no unspecified multipliers or ESCALATE assignments invented for existing ICE. The controlled UI fixture shows both.
- DSY-014/PACE-007 Phase 7 HULL engines, and PACE-004/010 manual scoring remain with their existing owners below.
- Windows export/launch: export runs on pushes to `main` (MAIN-001). Feature/PR CI verifies code/screenshots only. HALCYON PLAYTEST 4 is available. Windows launch and playtest are pending with the designer.
- Conditional turn-4 BOOTING and PACE-006 safety valves intentionally excluded.

## Open asset provenance

- CHROME-001 / CARDS-001: recover the original generation records and corrected concept PNG if they become available. The two asset source files now index the recoverable evidence.

## Waiting on the designer

| ID | Question | Where it came from | Status |
|---|---|---|---|
| ZINE-002 / ARCH-001 copy | Approve the working copy: the *THE CARBON* title, the *NOTES FROM THE ARCHIPELAGO* column, the island name pool (generic care-home names, ARCH-NAMES-001) and the polite anti-paper lines. (Relocation lines and programme names approved 2026-11-18: ARCH-LINES-001.) Can be decided with the next copy pack. The historical summaries (ADP §2.2.1, ARCH §2) need a fact-check before they inform on-screen text. | ADP §2.2; ARCH §4–6 | WAITING |

---

## Done

| ID | What | Commit / date |
|---|---|---|
| ADP §1.1 / ZINE-002 / ARCH-001 docs | Atompunk comparison (term stays); the zine as the underworld's samizdat; `REDLINE_ARCHIPELAGO.md` approved (decisions 1–4); ADP v0.8 links §8 to ARCH-001; decisions recorded in the master design doc. | 2026-11-18 (designer; recorded by Claude) |
| HALCYON PLAYTEST 5 Windows build | Exported and verified the Windows x86-64 package with checklist v0.5. Windows launch and playtest are pending with the designer. | `98bad5f`, tag `playtest-5`, [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/44232607877), [artifact](https://github.com/Punkwork/REDLINE/actions/runs/44232607877/artifacts/14395388972) |
| HALCYON PLAYTEST 4 Windows build | Exported and verified the Windows x86-64 artifact with QA checklist v0.3. Windows launch and playtest are pending with the designer. | `b6b0971`, tag `playtest-4`, [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/44202252857) |
| FACADE-001 HALCYON copy | Designer approved the consent, remembered activity and reward lines for review in playtesting. | 2026-11-17 (designer; recorded by Codex) |
| VIRUS-001 copy/move | Closed: WORM counters are **spent to break** (VIRUS-001); they don't spread to other ICE. The earlier copy-or-move question no longer applies (designer, 2026-11-15). | — (no change needed) |
| HANDOFF | This file created; working branch chosen. | 2026-11-15 (Claude), PR #4 |
| ROT-001 sync | Remaining SIGYL labels → TUMBLER in Card Pools, Rustlers, ICE Corp 1–3, Upgrades, Engines. | 2026-11-16 (Claude) |
| LOG-001 | Development log split: entries up to 2026-11-14 moved to `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md`; the live log keeps 2026-11-15 on. | 2026-11-16 (Claude) |
| ZEROED-001 / TUMBLE-001 readings | Designer confirmed both (2026-11-16): any drop to 0 STR uses up an ICE's one ZEROED; a subroutine that tumbles in is active at once. Build as specified above. | 2026-11-16 (designer) |
| DSY / PACE approval | Designer approved both docs as written for the next build; amendments recorded in Core Rules, Card Pools, Uplink & CAPS, Upgrades, Rustlers, Engines and the three ICE docs; checklist v0.2. | 2026-11-15 (Claude) |
| VISUAL-APPROVALS-002 | Designer approved the CHROME-001 art review, CARDS-001 as a whole, and the VIS-001 details (hand size, lethal threshold, undrawn ICE and wording, motion timings, Cracking after a strike). Recorded in the master design doc. | 2026-11-17 (designer; recorded by Claude) |
| ZEROED-001 interpretation | Closed: LOGIC BOMB and RELAY deprecated (DEPRECATE-001), so their floor/deficit readings no longer apply. | 2026-11-17 (designer; recorded by Claude) |
| RIOT-003 readings | Designer confirmed: SHATTER lets SLEDGE break any one chosen ICE of any type this turn; SLEDGE then stays at STR 0 until the encounter ends. Already built this way. | 2026-11-17 (designer; recorded by Claude) |
| REEL-001 follow-up | Closed: no DEADLOCK total on TUMBLER cards. TUMBLE-001 already removes broken subroutines at once and tumbles in the next unbroken one, so a broken DEADLOCK never reappears (designer reaffirmed). | 2026-11-17 (designer; recorded by Claude) |
| ICEBIBLE audit / PULP-001 | Designer applied the audit to the slice before the playtest (ICE-AUDIT-001) and set the FORTRESS PULP roll (PULP-001). Build rows added above. | 2026-11-17 (designer; recorded by Claude) |
| PULP-001 curves | Decided: curves keep their designed patterns and do not roll; every curve shows its next value (curve B no longer "PULP ?"). | 2026-11-17 (designer; recorded by Claude) |
| PR #1 vs this branch | Closed: PR #1 closed and its work archived at tag `archive/docs/simplified-design` (designer, 2026-11-17; Codex 65a47f2). | 2026-11-17 |
| Checklist v0.2 / v0.3 | `REDLINE_PLAYTEST_CHECKLIST.md` v0.3 adds checks for the 2026-11-17 decisions (C12–C16, D4, L5–L8, M5). The live Sheet "REDLINE Playtest QA Checklist" now matches it: v0.2 targets for B1, C1, K1 and rows C9–C11, G6–G11 added, plus the v0.3 rows (82 rows; Result dropdown extended). | 2026-11-17 (Claude) |
| FACADE-001 | Raygun Gothic facades for IRONWATCH and LUCIDA approved by the designer; recorded in the master design doc. | 2026-11-17 (designer; recorded by Claude) |
| MAIN-001 | Shared working agreement (`AGENTS.md`, `CLAUDE.md`) makes `main` the source of truth for Codex and Claude; `codex/chrome-deco-encounter` (including halcyon-playtest-stabilization and VIS-001) merged into `main`; approved Nov 17 visual decisions recorded in the master design doc. | aea16de, a523502, dd64768 · 2026-11-17 (Claude) |
| CHROME-001 screenshot refresh | Reran all five screenshot stages and replaced the ten PNGs under their original names with the current amber and textured CARDS-001 treatment. | 2026-11-17 (Codex) |
| MAIN-001 status sync | Corrected the working line, merged PR status and Windows export trigger in the current build status. | 2026-11-17 (Codex) |
| CHROME-001 / CARDS-001 source notes | Recorded available source and edit history for nine generated assets and corrected Whirlwind Bloatware. Exact prompts, model IDs and the corrected concept PNG are still missing. | 2026-11-17 (Codex) |
| VIS-001 doc | `REDLINE_VISUAL_LANGUAGE.md` and `docs/visual/` (reference images, placeholder backgrounds, mascot SVGs) added for Codex. | 2026-11-17 (Claude) |
