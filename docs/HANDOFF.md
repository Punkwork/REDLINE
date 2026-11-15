# PANOPTICON — HANDOFF (shared to-do for Codex and Claude)
**Started:** 2026-11-15 · **Owner of decisions:** the designer (John Stevers)

This is the one list of work that has been **decided but not finished**, so Codex and Claude never work from different pictures of the game. The design docs say *what* the game is; the development log says *what happened*; this file says *what's next and who does it*.

---

## How we work

1. **One working branch: `codex/halcyon-playtest-stabilization`** (designer, 2026-11-15). Start every session from its latest commit. Put your changes on a short-lived branch and open a pull request **into this branch**; don't push to it directly. `main` is out of date (last change 2026-11-12) and isn't used until the designer decides to merge.
2. **The repo is the source of truth.** `docs/` here is authoritative. The Claude project "Panopticon" holds copies (`claude/REDLINE_*.md`) for claude.ai chats; Claude refreshes them from this branch.
3. **Who does what.**
   - **Claude:** design docs and proposals, playtest analysis, this file, the project copies.
   - **Codex:** the Godot build (`godot/`), tests, exports, `REDLINE_CURRENT_STATUS.md`.
   - **Either:** small doc fixes that follow a decision already recorded.
   - **Only the designer** marks a decision APPROVED. A proposal stays PROPOSED until the designer says so in a session, and the session's log entry quotes or records that.
4. **Every change has a decision ID** (e.g. REJECT-001) that appears in the design doc, in this file and in the development log.
5. **Session routine.**
   - **Start:** pull the working branch; read this file, then the latest entries of `REDLINE_DEVELOPMENT_LOG.md`.
   - **End:** move finished items to *Done* (with the commit), add new items, and add a dated log entry that says who wrote it (`(Codex)` or `(Claude)`).

**Statuses:** **TO DO** (decided, not started) · **IN PROGRESS** (name who) · **BUILT** (in code, needs a playtest or check) · **DONE** · **WAITING** (needs a designer decision).

---

## To build (approved, not yet in the build)

| ID | What | Docs (done) | Build change | Owner | Status |
|---|---|---|---|---|---|

**Next build: everything in `REDLINE_DECK_SYNERGY.md` (DSY-001 to DSY-014) and `REDLINE_PACING.md` (PACE-001 to PACE-010), approved as written on 2026-11-15.** Suggested order, so each step can be playtested before the next; numbers are working values. Where a system isn't in the slice yet (Uplink, Console Lab, PATCHWORK, Ghostware), build the part that touches it when that system arrives, and say so in the log.

| ID | What to build | Spec | Owner | Status |
|---|---|---|---|---|
| **Pacing — PACE-003, 005, 007, 008** | **DEADLOCK ×N** (counter `1/2`); **ESCALATE ↑** for TRACE / DISCARD / FORGET (shows next value); DRILL / HULL / COVERAGE icon on reward cards; **fewer layers** (Tier 1 = 1 layer, Tier 2 = 1–2), re-based reward odds, CRED reserves +50%. In the slice: CONSENT WALL becomes 1 layer; check DOORBELL and TERMS & CONDITIONS against the Tier rules. | Pacing §3, §4.2, §6, §7 | Codex | TO DO |
| **Checklist v0.2** | New and revised checks (B1, C1, C9–C11, G6–G11, K1) into the Playtest QA Sheet. | `REDLINE_PLAYTEST_CHECKLIST.md` | Claude | TO DO |
| **PACE-004, 010** | Score each slice layer (BREACH WORK, REVEAL FLOOR, VITAE) from playtest 2's turns and VITAE; propose ICE changes. | Pacing §4.1, §9 | Claude | TO DO (needs playtest 2 data) |
| **DSY-014, PACE-007** | Phase 7 pools on the synergy grammar, with 2 HULL engines per Rustler pool; write up RIOT's ZEROED keyword. | Synergy §5.1, Pacing §6 | Claude | TO DO |

**Conditional (approved, build only if the condition is met):** PACE-003's BOOTING on the 4th turn, if playtest 2 shows the Opening Node breached before turn 4. PACE-006's safety valves (Max VITAE 35–40, full-clear heal 3, a second SAFEHOUSE), if playtests run too hot. PACE-009: watch RIOT's TRACE in longer encounters.

---

## Built — awaiting designer playtest

| IDs | Change | Commit reference |
|---|---|---|
| DSY-004,005,013 | SAFEHOUSE COMPILE with ordered effects, combined costs and tags, interactive continuations, CLEAN BUILD; MINIMALIST and ZERO FOOTPRINT; Ghostware effect hooks; FREE TRIAL on the final HALCYON layer. | **BUILT** — `playtest3-step5` (commit tag) |
| DSY-009,010 | Negative ICE STR, MARGIN previews, SCALPEL, STACK SMASH, INTEGER UNDERFLOW, CULL and HARVEST; AMP on virus effects. | **BUILT** — `playtest3-step4` (commit tag) |
| DSY-011,012 | CHAIN tracks successful card plays; PIVOT, COVER FIRE, HANDOFF and KILL CHAIN; HOLD 1 and DEAD MAN’S POCKET HOLD 2; scrollable choices. | **BUILT** — `playtest3-step3` (commit tag) |
| DSY-007, DSY-008 | REBOOT queues drain only after draws finish; AMP and seven specified cards, SCAN bottom-order choice, in-Node BURN and discard retrieval, HUD reboot estimate, and bot choice handling. | **BUILT** — `playtest3-step2` (commit tag) |
| DSY-001, DSY-002, DSY-003, DSY-006 | FOOTPRINT/caps and bands, per-Node bloat TRACE, optional GHOST draw OFF, duplicate-aware draw estimates and key-card previews, COVERAGE/tag density, and guarded full-clear DECOMPILE. | **BUILT** — `playtest3-step1` (commit tag) |
| REJECT-001 | REJECT ALL has one DEADLOCK in its three-entry pool; BOOTING remains turn 3. Updated opening rules checks and bot timing reporting. | **BUILT** — `playtest3-step0` (commit tag) |

## Waiting on the designer

| ID | Question | Where it came from | Status |
|---|---|---|---|
| ICEBIBLE audit | Apply the ICE Rules Bible audit to the slice (DOORBELL CAM not deadly; CAPTCHA's PULP 6; AUTO-RENEW STR; TUMBLER PULP cap on REJECT ALL and CONSENT FORM)? | `REDLINE_ICE_RULES_BIBLE.md`, audit table | WAITING |
| REEL-001 follow-up | Show the DEADLOCK total on TUMBLER cards? (REJECT-001 fixes REJECT ALL; CONSENT FORM and CAPTCHA still carry two.) | Dev log, REEL-001 | WAITING |
| RIOT-003 | Confirm two readings of SHATTER: "any 1 icebreaker" means any 1 ICE; SLEDGE stays at STR 0 until the encounter ends. | Dev log, RIOT-003 | WAITING |
| PULP-001 | Confirm FORTRESS PULP values are fixed per subroutine, not rolled. | Dev log, PULP-001 | WAITING |
| PR #1 vs this branch | PR #1 (`docs/simplified-design`) has an alternate JSON-backed build that isn't contained in PR #2. Compare before anything merges to `main`. | Dev log, 2026-11-14 (Codex) | WAITING |

---

## Done

| ID | What | Commit / date |
|---|---|---|
| VIRUS-001 copy/move | Closed: WORM counters are **spent to break** (VIRUS-001); they don't spread to other ICE. The earlier copy-or-move question no longer applies (designer, 2026-11-15). | — (no change needed) |
| HANDOFF | This file created; working branch chosen. | 2026-11-15 (Claude), PR #4 |
| DSY / PACE approval | Designer approved both docs as written for the next build; amendments recorded in Core Rules, Card Pools, Uplink & CAPS, Upgrades, Rustlers, Engines and the three ICE docs; checklist v0.2. | 2026-11-15 (Claude) |
