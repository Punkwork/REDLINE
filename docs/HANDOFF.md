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
| **REJECT-001** | REJECT ALL has **one DEADLOCK**: pool DEADLOCK · TRACE 3 · PULP 4, 2 slots. Earliest BREACH stays turn 3 with BOOTING. | `REDLINE_ICE_CORP1.md` §5.0, §10 item 10 | `godot/scripts/core/ice.gd` → `REJECT_ALL.subs`: remove the third entry (the second DEADLOCK). Update any test that expects two DEADLOCKs on REJECT ALL. Re-run the Opening Node bot turns (target: never before turn 3). | Codex | TO DO |

---

## Waiting on the designer

| ID | Question | Where it came from | Status |
|---|---|---|---|
| **DSY-001 to DSY-014** | Deck management & synergy proposal (FOOTPRINT, DECOMPILE, REBOOT, CHAIN, HOLD 1, UNDERFLOW…). Only DSY-006's end-of-run target (30–35 cards) is decided. | `REDLINE_DECK_SYNERGY.md` v0.3 | WAITING |
| **PACE-001 to PACE-010** | Encounter pacing proposal (4–5 turns early, 5–8 later; VITAE budget; fewer layers). Measure turns and VITAE per encounter in playtest 2 first. | `REDLINE_PACING.md` v0.2 | WAITING |
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
| HANDOFF | This file created; working branch chosen. | 2026-11-15 (Claude) |
