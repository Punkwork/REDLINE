# REDLINE — DEVELOPMENT LOG
**Initialized:** 2026-11-09  
**Policy:** append dated entries; distinguish reported outcomes from verified tests.

## Historical reconstruction — through 2026-11-08
*This entry consolidates known milestones; it is not a day-by-day reconstruction.*

### Design work established
- Runner/corporation ICE timing: runner action, then corporation fires remaining unbroken damage/Trace subroutines; broken DEADLOCK permits advancement after corporation turn.
- Damage terminology settled: NEURAL DAMAGE (chosen hand discard), SYNAPTIC DAMAGE (random hand discard); neither affects Vitae or permanently destroys cards. PURGE reserved for corporation virus-counter removal.
- DEAD DROP replaced Safehouse; mandatory choice of PATCH UP (+10 Vitae) **or** WIPE TRAIL (−20 Trace).
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


## 2026-11-11 — RULE-103 approved and locked after conflict check

**Decision:** RULE-103 LOCKED (Option A). A single discrete “for each” instruction snapshots a referenced variable numeric value once at instruction start for all processed objects. Later distinct instructions take fresh snapshots under RULE-102. Ordinary generated triggers do not interrupt the current ability (RULE-014/015), and prevention event granularity (RULE-074–077) is unchanged. Conflict review found no existing locked rule overridden.

**Master Design commit:** `a33b7a95fe3d1bf10dd400498d4a5d9942222204`. **Code changes:** None. **Tests:** None. **Next:** RULE-104, decide eligible-object-set timing in one for-each instruction; not yet approved.


## 2026-11-11 — RULE-104 approved and locked after conflict review

**Decision:** User selected Option A with eligibility protections. A discrete “for each” instruction snapshots its object processing set at instruction start; new objects are excluded and originally selected objects stay on the processing list. Explicit costs, eligibility/installed-status conditions, source-removal mechanics and continuous-effect expiration retain precedence. Ordinary triggered changes remain deferred under RULE-014/015. No override of existing locked rules found.

**Master Design commit:** `5b5e1dbaaf863917f71e31f270689d87c5d45ad5`. **Code changes:** None. **Tests:** None. **Next:** RULE-105, clarify prevention-gain event granularity for a single per-object instruction, subject to RULE-074–077 conflict check; not approved.


## 2026-11-11 — RULE-105 approved and locked

**Decision:** User explicitly approved Option A and exact aggregate-event wording after conflict audit. One “for each” prevention-granting instruction produces one aggregate prevention-gain event when total gain is positive. Per-object repetitions do not multiply triggers; separate gain instructions generate separate events under RULE-076; multiple distinct abilities may each recognize the event under RULE-078; FIFO timing unchanged. RULE-074–079, RULE-014/015, RULE-103/104 checked; no override.

**Master Design commit:** `0a798daeb0f6aa934ccce8e872cc0494215ca08d`. **Code changes:** None. **Tests:** None. **Next:** RULE-106, consider extending aggregate-event granularity to non-prevention “for each” instructions; not approved.


## 2026-11-11 — RULE-106 approved and locked

**Decision:** User explicitly approved the exception-protected general aggregate-event convention. One “for each” instruction making repeated same-type changes generates one aggregate event for generic triggers when a qualifying change occurs; distinct instructions remain distinct. Explicit carve-outs preserve per-card draw events (RULE-032/033), individual would-be-draw replacement handling (RULE-040–043), actual reshuffles (RULE-036), damage mechanics, explicit per-object/per-occurrence triggers, costs/conditions and more-specific text. Other triggered abilities may each recognize the event, with FIFO timing unchanged. No locked rule override.

**Master Design commit:** `7b096f35ce1365793fa287388d88d129fd91a48d`. **Code changes:** None. **Tests:** None. **Next:** RULE-107, clarify the numeric amount exposed by an aggregate event to amount-dependent triggered abilities; not approved.


## 2026-11-11 — RULE-107 approved and locked

**Decision:** User explicitly approved exception-protected Option A after conflict audit. An aggregate event reports the total actual qualifying numerical change from its instruction; partial resolution counts only realized changes, zero qualifying change creates no corresponding change event, and amount-dependent triggered abilities use the reported magnitude subject to their normal restrictions. Individual draw, reshuffle, replacement, damage and explicit per-object events remain unaffected. RULE-002/003, RULE-074–077, RULE-102–106, RULE-014/015 checked; no override.

**Master Design commit:** `7eb582c7dfdaee9ad1be17075e4c0247b721501b`. **Code changes:** None. **Tests:** None. **Next:** RULE-108, consider net versus directional event magnitude if one aggregate instruction produces both positive and negative changes; not approved.


## 2026-11-11 — RULE-109 approved and locked

**Decision:** User explicitly approved exception-protected Option A after conflict audit. Threshold-trigger qualification uses the completed aggregate event's total actual qualifying magnitude (RULE-107) instead of individual per-object contributions, absent more-specific text. Each eligible triggered ability activates at most once per event subject to frequency restrictions. Deferred FIFO timing and draw, reshuffle, replacement, damage, cost and condition protections remain unchanged. No locked-rule overrides.

**Master Design commit:** `045a991465a39fb573792560a19a591a09ff70eb`. **RULE-108:** deferred, not locked or committed. **Code changes:** None. **Tests:** None. **Next:** RULE-110, distinguish event-time trigger qualification from resolution-time reevaluation, subject to conflict audit; not approved.


## 2026-11-11 — RULE-110 approved and locked

**Decision:** User explicitly approved exception-protected Option A after conflict audit. Trigger eligibility is evaluated at event time; event facts and aggregate threshold qualification do not retroactively change. Each variable-numeric reward instruction snapshots the applicable value when it begins resolving, not when queued, unless explicit more-specific text requires otherwise. Pending source-removal cancellation (RULE-081/082/085), already-resolving continuation (RULE-083), explicit conditions and installed requirements (RULE-003/088), frequency restrictions, and FIFO remain effective. No locked rule overridden.

**Master Design commit:** `81c4ab95370b57345dcc8a41ba5e8a701d41e9ee`. **RULE-108:** deferred and unlocked. **Code changes:** None. **Tests:** None. **Next:** RULE-111, consider event-time trigger qualification alongside explicit resolution-time conditions; audit for redundancy and conflicts before approval.


## RULE-126 — SYN damage terminology and overflow (LOCKED, 2026-11-11)

**Authoritative decision:** The active damage keyword is **SYN X** (also styled **SYN DAMAGE X** in the approved rule review). Legacy **NEURAL DAMAGE** and **SYNAPTIC DAMAGE** are deprecated; neither is an active separate damage type. SYN is **Runner-chosen** hand discard, never random discard. Historical mentions of the old terms elsewhere are superseded, not additional active mechanics.

Resolve SYN X in this order:
1. The Runner chooses and discards as many cards as possible from their current hand, up to X.
2. Each unfulfilled point of SYN causes **2 Vitae damage**.
3. Apply that Vitae damage **after** discarding the available cards.

| SYN X | Hand | Discarded | Vitae damage |
|---:|---:|---:|---:|
| 3 | 3 | 3 | 0 |
| 3 | 2 | 2 | 2 |
| 3 | 1 | 1 | 4 |
| 3 | 0 | 0 | 6 |
| 5 | 2 | 2 | 6 |

**Priority:** RULE-126 supersedes older no-Vitae-loss statements for hand-discard damage and older random-discard SYN definitions. BURN remains direct Vitae damage; VOID remains persistent draw reduction. The approved overflow outcome is Vitae damage; do not silently reinterpret it as a separate SYN discard or VOID effect. Other prevention and trigger sequencing rules remain subject to their explicit text; do not invent unresolved interactions.

**Source:** `REDLINE_RULE_REVIEW_126.md`, approved and locked 2026-11-11. **Regression:** verify all five table cases and discard-before-Vitae ordering. RULE-127 remains pending.


**Terminology lock (2026-11-11):** **Vitae** is the canonical Runner health resource (abbreviated **VIT** in the World Bible). The former health-resource term is deprecated. **BURN damage** reduces Vitae. This terminology update does not itself change damage-resolution mechanics.


**Damage terminology lock (2026-11-11):** **CHAR** is deprecated and replaced by **BURN damage**. **BURN X reduces Runner Vitae by X**, subject to applicable BURN prevention. Earlier CHAR labels, examples, and prevention-pool references in this document are to be read as BURN. SYN remains mandatory Runner-selected discard with its approved overflow rule; VOID remains distinct. This is a terminology replacement, not an additional damage type.


## RULE-127 — SyN prevention, mandatory discard, and overflow BURN (LOCKED, 2026-11-11)

**Approved resolution order:** When the Runner receives **SyN X**:

1. **Apply SyN prevention:** Deduct available SyN prevention from incoming SyN, consuming no more prevention than the incoming amount.
2. **Determine unprevented SyN:** Resolve only the remaining SyN amount.
3. **Mandatory discard:** The Runner **MUST** choose and discard as many cards as possible from their current hand, up to the unprevented SyN amount. The Runner chooses *which* cards, but **cannot** voluntarily keep eligible cards and take BURN instead.
4. **Calculate overflow:** Each point of unprevented SyN not fulfilled by a card discard generates **2 BURN damage**, per RULE-126.
5. **Resolve BURN:** After mandatory discards, apply any available **BURN prevention** to the generated BURN damage; only unprevented BURN reduces **Vitae (VIT)**.

**Example:** Incoming SyN 5, SyN prevention 2, and 1 card in hand: 3 SyN remains; the Runner must discard that 1 card; 2 SyN overflow generates **4 BURN**. Apply BURN prevention, if any, before reducing Vitae.

**Priority and scope:** RULE-127 specifies the resolution sequence and prevention interaction for RULE-126. **SyN** is Runner-selected *mandatory* discard; **BURN** is the official Vitae-damaging keyword; **CHAR** is only colloquial slang for BURN in the World Bible; **VOID** is distinct. This rule does not invent additional prevention resources or change the previously established prevention-pool duration/stacking rules. Any unspecified simultaneous trigger timing remains open.

**Regression expectations:** Test full/partial/no SyN prevention, full/partial/empty hand, compulsory discard, BURN prevention of overflow, and zero-Vitae defeat. **Status: LOCKED, explicitly approved 2026-11-11.**
