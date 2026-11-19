# PANOPTICON — HANDOFF (shared to-do for Codex and Claude)
**Started:** 2026-11-15 · **Owner of decisions:** the designer (John Stevers)

This is the one list of work that has been **decided but not finished**, so Codex and Claude never work from different pictures of the game. The design docs say *what* the game is; the development log says *what happened*; this file says *what's next and who does it*.

---

## How we work

1. **Work on `main`** (designer, 2026-11-17; replaces the 2026-11-15 rule that used `codex/halcyon-playtest-stabilization`). Follow the working agreement in `AGENTS.md` / `CLAUDE.md`: start from the latest `main`, record design decisions in `REDLINE_MASTER_DESIGN.md`, report the commit where finished work lives, and ask the designer before creating a branch. The former working branch was merged into `main` at a523502 and is no longer used.
2. **The repo is the source of truth.** `docs/` here is authoritative. The Claude project "Panopticon" holds copies (`claude/REDLINE_*.md`) for claude.ai chats; Claude refreshes them from `main`.
3. **Who does what (DEV-001, 2026-11-18; details in `CLAUDE.md` / `AGENTS.md`).**
   - **Claude Code:** the Godot build (`godot/`), tests, fixtures, CI, exports, `REDLINE_CURRENT_STATUS.md`.
   - **Claude (Panopticon project):** design docs and proposals, playtest analysis, this file, the project copies.
   - **Codex:** small isolated tasks, only when the designer asks.
   - **Either:** small doc fixes that follow a decision already recorded.
   - **Only the designer** marks a decision APPROVED. A proposal stays PROPOSED until the designer says so in a session, and the session's log entry quotes or records that.
4. **Every change has a decision ID** (e.g. REJECT-001) that appears in the design doc, in this file and in the development log.
5. **Session routine.**
   - **Start:** pull `main`; read this file, then the latest entries of `REDLINE_DEVELOPMENT_LOG.md`.
   - **End:** move finished items to *Done* (with the commit), add new items, and add a dated log entry that says who wrote it (`(Codex)` or `(Claude)`).

6. **Development log size (LOG-001).** Keep `REDLINE_DEVELOPMENT_LOG.md` under about **60 KB** so Claude can rewrite the project copy in one pass. When it grows past that, move the oldest dated entries, whole, to the end of `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md` (oldest first, nothing reworded) and note the move in the log. Entries stay append-only; the archive is never edited except to append.

7. **Builds come from `release`, not `main` (RELEASE-001, 2026-11-18).** Work lands on `main`. To cut a playtest build, fast-forward `release` to `main`, push, and tag the commit `playtest-N`; only `release` exports Windows builds. Nobody commits to `release` directly. A bad build is rebuilt from its tag or `release` is reset to the last good tag.

**Statuses:** **TO DO** (decided, not started) · **IN PROGRESS** (name who) · **BUILT** (in code, needs a playtest or check) · **DONE** · **WAITING** (needs a designer decision).

---

## To build (approved, not yet in the build)

### Start here (Codex): decisions made 2026-11-16
ZEROED-001, its RIOT cards, and TUMBLE-001 are built; see the tagged rows below. ROT-001 documentation sync and LOG-001 split were already completed in PR #8. No remaining Codex TO DO rows from this block. VIS-001 is built on `main`; see Built below for the review tag.

**Next build: everything in `REDLINE_DECK_SYNERGY.md` (DSY-001 to DSY-014) and `REDLINE_PACING.md` (PACE-001 to PACE-010), approved as written on 2026-11-15.** Suggested order, so each step can be playtested before the next; numbers are working values. Where a system isn't in the slice yet (Uplink, Console Lab, PATCHWORK, Ghostware), build the part that touches it when that system arrives, and say so in the log.

| ID | What to build | Spec | Owner | Status |
|---|---|---|---|---|
| **PACE-004, 010** | Score each slice layer (BREACH WORK, REVEAL FLOOR, VITAE) from playtest 2's turns and VITAE; propose ICE changes. | Pacing §4.1, §9 | Claude | WAITING on Playtest 6 results and the bot sims (designer, 2026-11-18) |
| **DSY-014, PACE-007** | Phase 7 pools on the synergy grammar, with 2 HULL engines per Rustler pool. *(RIOT's ZEROED keyword written up: ZEROED-001.)* | Synergy §5.1, Pacing §6 | Claude | WAITING on Playtest 6 results (designer, 2026-11-18) |
| **EVENT-002/003** | SIGNAL UNCLEAR: when the events are built, MAINTENANCE WINDOW is a choice (heal 6 VITAE or −5 TRACE), the new CARE PACKAGE event (+5 Max VITAE, also +5 current, or a random rare card) joins the pool, and odds become AMBUSH 20%, BROKER 5%, the other eight 9.4% each. Every non-AMBUSH event must offer a choice; add a test. | Upgrades §3 | Claude Code | TO DO (with the SIGNAL UNCLEAR build. DEV-001b: the slice map has no SIGNAL UNCLEAR Node yet, only ICE and SAFEHOUSE, so this waits for that Node) |
| **EVENT-004** | Design the "powerful Ghostware with a permanent price" SIGNAL UNCLEAR event. Designer: "a specific ghostware that bestows a negative, a permanent bloatware in their deck that can't be removed through normal means"; "because of how powerful it is, it comes with a negative"; option B, "needs designing". Starting proposal (Claude, not approved): working name COMPLIMENTARY UPGRADE, offered by the corporation; one per corporation: HALCYON PREMIUM MEMBERSHIP™ (+1 BW and +1 DRAW every turn; Bloatware TERMS OF SERVICE), IRONWATCH PRIORITY RESPONSE™ (first break each turn 0 BW, Icepicks +1 STR; WATCHLIST: +2 TRACE if in hand at end of turn), LUCIDA LUCID DREAMING™ (+3 cards at encounter start, CACHE 1 free each turn; RECURRING DREAM: CORTEX 1 if in hand at end of turn). Each Bloatware: pay 1 BW to clear for the Node, returns every Node, immune to Wipe, Console Lab, DATA PURGE, DECOMPILE and FUSE. Decided: **each corporation has its own version** (designer, 2026-11-18). Open: any abnormal way out; counts toward the deck-size cap (default no); odds (default about 5%); powers need sim balancing (about double today's best Ghostware). | Upgrades §2–3; Facades | Claude | TO DO (design; can go with EVENT-001 after Playtest 6) |
| **EVENT-001** | Expand and re-theme the SIGNAL UNCLEAR event pool (designer, 2026-11-18: "those could be a source of great variability for the player"). Today: 9 mechanical events (Upgrades §3) that predate ZINE-002/003, ARCH-001 and the corporate facades, so repeats come fast. Propose more events, and re-theme the existing ones, in the world's voice: *NOTES FROM THE ’PELAGO* drops, another crew's samizine, pirate broadcasts, corporate "wellness checks", care-home postcards; choices that touch TRACE, CRED, cards, CAPS and oblique SIGNAL-001 hints (no reveal before the third card). Use Playtest 6 notes on checklist I3. | Upgrades §3; ADP §2.2; ARCH §4–6 | Claude | WAITING on Playtest 6 results (designer, 2026-11-18) |

**Claude Code migration (DEV-001, approved 2026-11-18):**

| ID | What | Owner | Status |
|---|---|---|---|
DEV-001b is done (see *Done*). Its fixes are below.

**DEV-002: fixes from the DEV-001b audit (PROPOSED, Claude Code, 2026-11-19; nothing here is approved).** The evidence is in the [DEV-001b log entry](REDLINE_DEVELOPMENT_LOG.md#2026-11-19--dev-001b-read-only-audit-of-code-docs-and-architecturemd-claude-code). Rows marked *docs* follow decisions already recorded. The others change code or need a designer choice.

| ID | Proposed fix | Kind | Owner | Status |
|---|---|---|---|---|
| **DEV-002a** | ICE Corp 1: in the §5.0 "Slice route", show one layer per Node (PACE-008); mark §6's HOUSE CALL numbers as replaced by §5.0 (STR 7, PULP 6 + 6, TUNE-001). | docs | Claude | PROPOSED |
| **DEV-002b** | Record the reserve rounding: PACE-008's +50% is rounded up (COOKIE BANNER 23, Tier 1 layer 15). Add notes to Core Rules §10.1a, ICE Corp 1 §8.2/§8.4 and the CORE-012 example (15 → 23). **Designer:** confirm rounding up. | docs + decision | Claude | PROPOSED |
| **DEV-002c** | Ad and LUCIDA-edit wording: move `PlayProfile.AD` and `Game.LUCIDA_RECORD` from code into `data/adp_copy.json` with `approval` fields, so the copy test scans them. **Designer:** approve or rewrite the working wording that shipped in `playtest-6` (closes the open ADP-3 interpretation). | code + copy | Claude Code (after the designer's call on the wording) | PROPOSED |
| **DEV-002d** | Copy-guard coverage: `AdpCopy.pool()` also calls `ArchCopy.valid_line()`, and a test runs every string literal in `godot/scripts/` (mascot lines, `main.gd` text) through the guard. Nothing fails today; this keeps it that way. | code + test | Claude Code | PROPOSED |
| **DEV-002e** | Island names: once ARCH-NAMES-001 settles, relocation lines name their island through a placeholder (e.g. `[HOME]`) filled from the island row, replacing the literal names and `CarbonRecord.ISLAND_INDEX`. Keep the stored `relocation_id`s and the island text in old CARBON records readable. | code + copy | Claude Code (after ARCH-NAMES-001) | PROPOSED |
| **DEV-002f** | Write `redline_flags.json` through `LocalRecord.write()` (temp file, then rename) like the other two records; today `main.gd` `_save_flags()` overwrites the file in place. | code | Claude Code | PROPOSED |
| **DEV-002g** | Correct `ARCHITECTURE.md`: the flags file, `shot.gd` and the fixtures that assert nothing, the missing phases (`SELECT`, `DECOMPILE`, the unused `DEAD_DROP` branch), what the copy guard actually covers, and the unmapped files (`synergy_cases.gd`, `icon.gd`, the voice `.ogg` lookup, the unused `audio/nulrem/manifest.json`, the export `data/*.json` filter). In CLAUDE.md = AGENTS.md §4, change "each `shot_*.gd`" to "each script". | docs | Claude Code | PROPOSED |
| **DEV-002h** | CI: the `paths` filter covers only `pull_request`, so every push runs full validation and every push to `release` exports, docs-only included. That contradicts the RELEASE-001 log note. **Designer:** add the same `paths` filter to `push` (doc-only pushes skip validation and export), or keep it as it is and correct the note. Also make `shot.gd` and `shot_reel.gd` fail when a PNG can't be saved. | CI + decision | Claude Code | PROPOSED |
| **DEV-002i** | Refresh `REDLINE_CURRENT_STATUS.md`: 361 rules checks (it says 357), DEV-001 ownership, and DEV-001b. | docs | Claude Code | PROPOSED (with the next code commit) |

Hygiene, recorded and left alone under the no-refactor rule: the unused local `odds` in `_roll_rewards()`, the phase comment at `game.gd:21`, and mixed indentation between files. Fix each only when that code is next touched for an approved change.

**Integration beyond the HALCYON slice:** connect the presentation hooks to playable LUCIDA, PATCHWORK and run resume when those systems arrive. Tag playable Central Nodes with `central: true`. The slice's run-menu DEAD DROP opens THE CARBON; attach the same reader to the map's DEAD DROP when that Node is built. The reveal sequence and final punch-card art have their own design work.


**Conditional (approved, build only if the condition is met):** PACE-003's BOOTING on the 4th turn, if playtest 2 shows the Opening Node breached before turn 4. PACE-006's safety valves (Max VITAE 35–40, full-clear heal 3, a second SAFEHOUSE), if playtests run too hot. PACE-009: watch RIOT's TRACE in longer encounters.

---

## Built — awaiting designer playtest

| IDs | Change | Commit reference |
|---|---|---|
| CARDS-002 | PCB laminate, silkscreen traces and contacts on SCRIPT, PROGRAM and PROTOCOL. Corporate BLOATWARE retains its oxide-red Whirlwind art. Palette values await visual review. | **BUILT** — [Codex implementation entry](REDLINE_DEVELOPMENT_LOG.md#2026-11-19--cards-002-rustler-pcb-palette-codex) |
| HAND-CLEANUP-001, CARD-CONTROLS-001, ENCOUNTER-DISPLAY-001 | Remove free HOLD, install and inspect PROGRAMs in the left bay, drop SCRIPTs on their play zones, toggle 150% card inspection, and fill fullscreen with the backdrop and enlarge ICE avatars by 25%. | **BUILT** — [Codex implementation entry](REDLINE_DEVELOPMENT_LOG.md#2026-11-17--hand-cleanup-001-and-card-controls-001-codex) |
| SIGNAL-001 (SIG-5a–d), ARCH-001 (ARCH-1a–c), ARCH-SLANG-001, ZINE-003, ADP-4a | Central-BREACH award hook, punch-card holder and reveal guard. Relocation notice, local SAMIZINE CARBON ledger and DEAD DROP reader. | **BUILT** — [Codex implementation entry](REDLINE_DEVELOPMENT_LOG.md#2026-11-18--signal-001-arch-001-and-adp-4a-codex) |
| ADP-001 Phase 3 (ADP-3a–c), ADP-4a | Local ads and settings, guarded LUCIDA record edits, and instance grafts with fixtures. | **BUILT** — `3d767be` · [Codex implementation entry](REDLINE_DEVELOPMENT_LOG.md#2026-11-18--adp-001-phase-3-and-adp-4a-codex) |
| ADP-001 Phase 2 (ADP-2a–c), ADP-4a | Approved voice, encounter hesitation, patent plates, and newsreels. | **BUILT** — `1f3fb31` · [Codex implementation entry](REDLINE_DEVELOPMENT_LOG.md#2026-11-18--adp-001-phase-2-and-adp-4a-codex) |
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
- Windows export runs on `release`. Designer launch and playtesting of HALCYON PLAYTEST 6 are pending.
- Conditional turn-4 BOOTING and PACE-006 safety valves intentionally excluded.

## Open asset provenance

- CHROME-001 / CARDS-001: recover the original generation records and corrected concept PNG if they become available. The two asset source files now index the recoverable evidence.

## Waiting on the designer

| ID | Question | Where it came from | Status |
|---|---|---|---|
| NAME-002 (PROPOSED) | **Rename VITAE to SPARK?** Designer: VITAE "seems so out of place in this setting"; SPARK "works", to be reviewed later "to see how much it fits before committing it". Why SPARK: the stat is not health but how much of *you* the machine can't have. Every consciousness has a First Signal; the spark is that signal in you, and what the ’Pelago harvests for the synchronization (SIGNAL-001, ARCH-001). Hits dim it; at 0 your spark is taken. Period-true (radio spark gap). Samples: *SPARK 12 / 30*, *PULP 5 · SPARK −5*, NUL/REM "keep your spark low and your head lower." Considered and set aside: NERVE, TICKER, GRIT, PULSE (too close to PULP); runners-up STATIC, SPINE, INK. Optional extra: corporations name the same number in flavour copy only (HALCYON "Comfort Level", IRONWATCH "Wellness Index", LUCIDA "Restfulness"). Scope if approved: about 510 mentions in 21 docs, including LOCKED master entries (Vitae distinction, HUB-002 PATCH UP), and about 80 in code/data; Claude Code renames on screen with a guard test that VITAE never appears; no rule changes. | Designer, 2026-11-18 | WAITING (review later) |
| CARDS-002 mustard cartridge | Review-only on `review/cards-002`. Latest: glow study (ivory text and amber numbers on dark solder-mask panels) and a single cached state, one solid cyan edge glow with no padlock (designer direction); also 1/2/3 rarity cells and an 84 px rules frame with a 9 px floor. **Interpretations to confirm:** mask colour and shapes, halo strength, amber numbers, "(temporary)" in the tooltip. | [Review archive](visual/fixtures/cards-002/README.md) | **WAITING** for designer review; PROPOSED |
| ARCH-NAMES-001 names | The nine island names are working copy: the designer will check them against real care homes later. | ARCH §4.0 | WAITING |

---

## Done

| ID | What | Commit / date |
|---|---|---|
| DEV-001b | Read-only audit, no code changes. Tests pass (361/0 rules, 17/0 bleed, 671/0 SIGNAL/CARBON). The code matches the rules docs on stats, starter decks, HALCYON ICE, strikes, odds and caps. Nine code/doc disagreements and five ARCHITECTURE.md problems are in the [log](REDLINE_DEVELOPMENT_LOG.md#2026-11-19--dev-001b-read-only-audit-of-code-docs-and-architecturemd-claude-code); fixes proposed as DEV-002a–i. | 2026-11-19 (Claude Code) |
| DOCS-001 | Agents were reading pre-redesign docs (Codex reported old Node types). `CLAUDE.md` / `AGENTS.md` §6 now lists which docs are current and the authority order; `REDLINE_BIBLE.md`, the 2026-11-10 core design doc, RULE-126, the Playtest 3 record and the old UI doc carry a "not current for rules" note. | 2026-11-18 (designer: "Yes"; Claude) |
| DEV-001a | Tagged baseline, wrote the developer system map, corrected the matching working agreements and retired the old Godot handoff. DEV-001b is next with Claude Code. | `pre-claude-code` at `0a357e7` · [Implementation log](REDLINE_DEVELOPMENT_LOG.md#2026-11-18--dev-001a-claude-code-handoff-codex) |
| ZINE-002 / ARCH-001 copy (ARCH-COPY-001) | Approved: the *THE CARBON* title, the *NOTES FROM THE ’PELAGO* column, the defeat framing copy and the polite anti-paper lines. Samizdat history (ADP §2.2.1) checked by the designer. | 2026-11-18 (designer: "All approved"; recorded by Claude) |
| ZINE-003 SAMIZINE | Design canvas built and reviewed in three rounds; spec `REDLINE_SAMIZINE.md`, boards, review PDF and canvas sources in `docs/visual/samizine/`. ARCH-SLANG-001 (’Pelago) and ARCH-NAMES-001 / ARCH-LINES-001 recorded. | 2026-11-18 (designer; recorded by Claude) |
| ADP §1.1 / ZINE-002 / ARCH-001 docs | Atompunk comparison (term stays); the zine as the underworld's samizdat; `REDLINE_ARCHIPELAGO.md` approved (decisions 1–4); ADP v0.8 links §8 to ARCH-001; decisions recorded in the master design doc. | 2026-11-18 (designer; recorded by Claude) |
| RELEASE-001 / HALCYON PLAYTEST 6 | Published and verified the Windows x86-64 artifact. GitHub denied the branch-protection request with HTTP 403. | `22eb17f`, tag `playtest-6`, [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/44314368001), [artifact](https://github.com/Punkwork/REDLINE/actions/runs/44314368001/artifacts/14431722167) |
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
