# REDLINE — DEVELOPMENT LOG
**Initialized:** 2026-11-09  
**Policy:** append dated entries; distinguish reported outcomes from verified tests.

## Historical reconstruction — through 2026-11-08
*This entry consolidates known milestones; it is not a day-by-day reconstruction.*

### Design work established
- Runner/corporation ICE timing: runner action, then corporation fires remaining unbroken damage/Trace subroutines; broken DEADLOCK permits advancement after corporation turn.
- Damage terminology settled: NEURAL DAMAGE (chosen hand discard), SYNAPTIC DAMAGE (random hand discard); neither affects Integrity or permanently destroys cards. PURGE reserved for corporation virus-counter removal.
- DEAD DROP replaced Safehouse; mandatory choice of PATCH UP (+10 Integrity) **or** WIPE TRAIL (−20 Trace).
- Encounter-end hardware recycling occurs once; PATCHWORK belongs to individual card instances; Ghostware is permanent and non-card.
- UI direction established for ICE inspection, drag breakers, `[STR X]` labels, HUD tooltips, Ghostware rack and ORIGIN display.
- NUL/REM six personality modes and retro-computing voice established; PAPER CUT Strength 0 ICE discussed as a concept, not a shipped card.
- Narrative established that the First Signal is a real synchronization transmission; key hidden-AI/cipher/synchronization questions left unresolved.

### Engineering baseline (reported, not independently retested here)
- Python/Pygame reference archive: `REDLINE_Dead_Drop_Final_Playtest.zip`.
- Known file layout: `main.py`, `visual.py`, `engine/run.py`, `engine/content.py`, `engine/model.py`, and regression scripts.
- Prior handoff reported automated tests passing; Windows/Pygame live UI playtesting incomplete.
- Godot 4 selected as production engine; Python/Pygame retained as reference.

### Historical gaps
Exact dates for individual decisions, complete card lists, test output, commits, and code diffs have not been recovered. Do not backfill invented entries.

## 2026-11-09 — Documentation foundation
**Completed:** Created the three permanent reference documents: Master Design, Development Log, Current Status. Consolidated confirmed rules, narrative, UI, character direction, technical baseline, and unresolved items. Added canonical decision IDs and evidence/status distinctions.

**Code changes:** None.  
**Tests run:** None.  
**New gameplay decisions:** None; documentation only.

**Next:** (1) review Master Design for omissions; (2) obtain and inspect latest source ZIP and any detailed design files; (3) reconcile implementation status and regression coverage; (4) define first Godot 4 migration milestone.

---
## Daily entry template
### YYYY-MM-DD — Session title
**Goal:**  
**Completed:**  
**Decisions (IDs/status):**  
**Files changed / commits:**  
**Tests run and results:**  
**Bugs discovered / resolved:**  
**Open questions:**  
**Handoff for next session:**  

---

## 2026-11-10 — PANOPTICON thematic documentation

**Goal:** Preserve the surveillance/panopticon design conversation as durable project documentation.

**Documented directions:** Preferred working title PANOPTICON (clearance pending); central question of humanity's transformation under permanent observation; lock/DEADLOCK imagery; locked-out versus locked-in tension; panoptic architecture and psychological surveillance; ICE as the primary defender with layer-local or node-persistent supporting defences; deck contamination and behavioural surveillance as unfinalized gameplay concepts; viruses as deployable software subtype.

**Boundaries:** Existing ICE timing, VOID, NEURAL/SYNAPTIC damage, PURGE, First Signal canon, and gameplay architecture remain unchanged. Surveillance mechanics, corruption cards, title clearance, and narrative answers remain open.

**Code changes:** None. **Tests run:** None. **Documentation:** Bible, Master Design, Development Log, and Current Status updated.


---

## 2026-11-11 — Software lifecycle, continuous bonuses and DRAW rules

**Goal:** Lock fine-grained gameplay semantics in the Master Design, one user-approved question at a time.

**Completed:** Approved and committed RULE-084 through RULE-096 during this session; preceding RULE-081–083 already documented. Clarified queued trigger cancellation versus continuing in-progress abilities; valid trigger events after source removal; conditional installation requirements; reinstall as new installed instance; termination and stacking of continuous effects; explicit non-stacking uses strongest bonus; recomputation after removal; no retroactive card removal when DRAW decreases.

**Decisions:** RULE-084–096 LOCKED. User clarified that PATCHWORK +2 and +4 DRAW bonuses total **+6 without explicit non-stacking text** (RULE-093), but **+4 when non-stacking text is present** (RULE-094). The original installation and a later reinstallation are different installed instances (RULE-089).

**Files changed:** `docs/REDLINE_MASTER_DESIGN.md` (RULE-084–096), and this handoff update to status/log. Last Master Design commit: `ce1bcbc341b03ca4662d223ba98d88ca34fd1593`.

**Code changes:** None. **Tests run:** None. **Implementation claims:** Not verified in this session.

**Open question:** RULE-097 — whether a mid-turn DRAW increase automatically draws extra cards; proposal made, **not answered or locked**.

**Handoff:** User requested a new chat tomorrow. Begin at RULE-097, ask one question at a time, commit only explicit approvals. Master Design is authoritative; do not infer that approved rules have been implemented in game code.


## 2026-11-11 — RULE-097 approved and locked

**Decision:** RULE-097 LOCKED. A mid-turn increase in DRAW does not grant immediate extra cards; the new value applies to future applicable draw calculations. Complements RULE-096.

**Files:** Master Design commit `1cbf10cbda21cc786c0d3e2cc10ad1b05cd288d2`; Current Status and Development Log handoff updates.

**Code changes:** None. **Tests:** None. **Next:** Ask RULE-098 as a single open design question; commit only after approval.


## 2026-11-11 — RULE-098 approved and locked

**Decision:** RULE-098 LOCKED (user-approved Option A). A draw instruction referencing DRAW snapshots its target card count when that instruction begins resolving; changing DRAW mid-instruction does not change that target. Existing insufficient-card and trigger-order rules remain intact.

**Files:** Master Design commit `d1cf5e9da1622c7e6c0be02bd6883a985844897a`; status/log updated for handoff.

**Code changes:** None. **Tests run:** None. **Next:** RULE-099, distinguish two separate draw instructions within one ability; not yet approved.


## 2026-11-11 — RULE-099 approved and locked

**Decision:** RULE-099 LOCKED (user-approved Option A). Each distinct DRAW-based draw instruction within a single ability recalculates its card count at that instruction's start; the target remains fixed during that instruction under RULE-098. Example: draw 5, gain +2 DRAW, then draw 7.

**Files:** Master Design commit `bc056f665eabf62a516956214128a650cba82a89`; status/log updated for handoff.

**Code changes:** None. **Tests run:** None. **Next:** Ask RULE-100 as one open design question about queued DRAW-based draw instructions; commit only after approval.


## 2026-11-11 — RULE-100 approved and locked

**Decision:** RULE-100 LOCKED (user-approved Option B). For a queued triggered Software ability instructing “Draw cards equal to your DRAW,” the card count is fixed when the ability enters the FIFO queue, not when it starts resolving. DRAW 5 at queueing remains a 5-card draw even if DRAW rises to 8 before resolution. Explicit exception to RULE-098; cancellation rules remain unchanged.

**Files:** Master Design commit `17b5c4917290061064b75774fee4dadbc323a0a6`; Current Status and Development Log updated for handoff.

**Code changes:** None. **Tests run:** None. **Next:** RULE-101 asks how queue-time snapshots apply to multiple separate DRAW instructions in one queued ability; no decision yet.


## 2026-11-11 — RULE-100 revised to remove conflict with RULE-098

**User-directed correction:** User requested “Change rule 100 to align with rule 98. Then proceed.” Original RULE-100 Option B (queue-time DRAW snapshot) was replaced in canonical Master Design. Revised RULE-100 uses effective DRAW when the draw instruction begins resolving, even if its ability was queued earlier. RULE-098 and RULE-099 remain unchanged. Prior RULE-100 approval and commit `17b5c4917290061064b75774fee4dadbc323a0a6` remain in this log for audit history, **not** as active canon.

**Master Design correction commit:** `c39a5da2f0746d97662ed525bb35c7c8e1bd62a5`. **Code changes:** None. **Tests:** None. **Next:** Ask one RULE-101 design question consistent with revised RULE-100; no automatic approval.


## 2026-11-11 — RULE-101 approved and locked

**Decision:** RULE-101 LOCKED (Option A). A queued ability's separate DRAW-based instructions independently recalculate effective DRAW when each instruction starts resolving: queued at DRAW 5, increased to 8 before resolution, draw 8, gain +2 DRAW, draw 10. Conflict review found no override of RULE-098, RULE-099, or revised RULE-100.

**Master Design commit:** `7dafb193b9a86b6f4d2f4683f74d9cc1d439d121`. Status/log updated. **Code changes:** None. **Tests:** None. **Next:** RULE-102, whether snapshot timing generalizes to non-DRAW numeric instructions; not approved.


## 2026-11-11 — RULE-102 approved and locked after conflict audit

**Decision:** User approved the exception-protected Option A. Each discrete variable-numeric instruction fixes its calculated quantity when that instruction starts; later distinct instructions independently recalculate. Preserves continuous-effect recalculation, explicit timing, costs/conditions, and resource spending priorities. Conflict audit considered RULE-003–010, RULE-038, RULE-071–072, RULE-090–095, and RULE-098–101; no blanket override was approved.

**Master Design commit:** `98bb8e85d79c999cb218ed27fc9167c78f380699`. **Code changes:** None. **Tests:** None. **Next:** RULE-103, clarify per-object processing inside one discrete instruction, subject to conflict review; not approved.
