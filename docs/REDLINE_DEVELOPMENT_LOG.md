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

**Priority:** RULE-126 supersedes older no-Vitae-loss statements for hand-discard damage and older random-discard SYN definitions. PULP remains direct Vitae damage; VOID remains persistent draw reduction. The approved overflow outcome is Vitae damage; do not silently reinterpret it as a separate SYN discard or VOID effect. Other prevention and trigger sequencing rules remain subject to their explicit text; do not invent unresolved interactions.

**Source:** `REDLINE_RULE_REVIEW_126.md`, approved and locked 2026-11-11. **Regression:** verify all five table cases and discard-before-Vitae ordering. RULE-127 remains pending.


**Terminology lock (2026-11-11):** **Vitae** is the canonical Runner health resource (abbreviated **VIT** in the World Bible). The former health-resource term is deprecated. **PULP damage** reduces Vitae. This terminology update does not itself change damage-resolution mechanics.


**Damage terminology lock (2026-11-11):** **CHAR** is deprecated and replaced by **PULP damage**. **PULP X reduces Runner Vitae by X**, subject to applicable PULP prevention. Earlier CHAR labels, examples, and prevention-pool references in this document are to be read as PULP. SYN remains mandatory Runner-selected discard with its approved overflow rule; VOID remains distinct. This is a terminology replacement, not an additional damage type.


## RULE-127 — SyN prevention, mandatory discard, and overflow PULP (LOCKED, 2026-11-11)

**Approved resolution order:** When the Runner receives **SyN X**:

1. **Apply SyN prevention:** Deduct available SyN prevention from incoming SyN, consuming no more prevention than the incoming amount.
2. **Determine unprevented SyN:** Resolve only the remaining SyN amount.
3. **Mandatory discard:** The Runner **MUST** choose and discard as many cards as possible from their current hand, up to the unprevented SyN amount. The Runner chooses *which* cards, but **cannot** voluntarily keep eligible cards and take PULP instead.
4. **Calculate overflow:** Each point of unprevented SyN not fulfilled by a card discard generates **2 PULP damage**, per RULE-126.
5. **Resolve PULP:** After mandatory discards, apply any available **PULP prevention** to the generated PULP damage; only unprevented PULP reduces **Vitae (VIT)**.

**Example:** Incoming SyN 5, SyN prevention 2, and 1 card in hand: 3 SyN remains; the Runner must discard that 1 card; 2 SyN overflow generates **4 PULP**. Apply PULP prevention, if any, before reducing Vitae.

**Priority and scope:** RULE-127 specifies the resolution sequence and prevention interaction for RULE-126. **SyN** is Runner-selected *mandatory* discard; **PULP** is the official Vitae-damaging keyword; **CHAR** is only colloquial slang for PULP in the World Bible; **VOID** is distinct. This rule does not invent additional prevention resources or change the previously established prevention-pool duration/stacking rules. Any unspecified simultaneous trigger timing remains open.

**Regression expectations:** Test full/partial/no SyN prevention, full/partial/empty hand, compulsory discard, PULP prevention of overflow, and zero-Vitae defeat. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-128 — SyN overflow PULP classification and triggers (LOCKED, 2026-11-11)

**Explicit user approval:** PULP generated by SyN overflow under RULE-126/127 is **ordinary PULP damage** for all mechanical purposes, not a fourth damage type. After SyN prevention and mandatory Runner-selected discard, each unfulfilled SyN point generates **2 PULP**; resolve that PULP against the shared PULP prevention pool, and reduce **Vitae (VIT)** only by the unprevented remainder.

**Source-neutral application (explicit choice):** PULP prevention and PULP-related effects apply to overflow PULP **regardless of the damage's source**, even where an effect describes a particular source (for example, “prevent PULP from ICE”). For RULE-128 interactions, source descriptors do **not** exclude SyN-overflow PULP. This explicit exception supersedes the source-restriction option in the draft proposal; it does not change the distinction between damage types or permit other damage types to use PULP prevention.

**Trigger rule (explicit choice):** Only **actual PULP suffered**—the positive reduction of Vitae after prevention—counts for PULP-damage triggers. Merely generating, proposing, or fully preventing PULP **does not** trigger PULP-damage abilities. Effects requiring “when you suffer PULP” require **at least 1 VIT lost**. Do not introduce a separate “PULP generated” trigger category under RULE-128. Effects expressly referring to prevention itself are outside this PULP-damage-trigger rule and retain their printed conditions; their general timing remains governed by existing trigger rules.

**Examples:** SyN overflow generates 4 PULP, prevention 3 → suffer 1 PULP, lose 1 VIT, suffered-PULP trigger may fire. Overflow 6, prevention 6 → suffer 0 PULP, lose 0 VIT, no suffered-PULP trigger. Overflow 4, prevention 0 → suffer 4 PULP, lose 4 VIT. A source-described PULP prevention effect is eligible against overflow PULP under this rule.

**Compatibility:** RULE-127's order and compulsory discard remain unchanged. Three independent prevention pools (DMG-002), temporary prevention expiration (SOFT-013), and prohibition on reactive Runner card play during Corporation turns (SOFT-011) remain unchanged. **CHAR** is in-world slang only; **PULP** is the official mechanical term. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-129 — Simultaneous mixed damage resolution (LOCKED, 2026-11-11)

**Explicit user approval:** When **one effect** inflicts two or more of the three damage types, resolve its damage components in the **fixed order PULP → SyN → VOID**, regardless of the effect's controller or the printed order of the listed damage types. Treat the mixed-damage instruction as one uninterrupted resolving effect for trigger-queue timing, with components processed sequentially against the updated game state.

1. **PULP component:** Spend applicable PULP prevention from the existing PULP pool; unprevented PULP reduces **Vitae (VIT)**. If VIT reaches zero, the run **ends immediately in defeat**. Stop; do not process remaining damage components or queued triggers.
2. **SyN component:** Apply SyN prevention, then the Runner **MUST choose and discard** as many cards as possible up to unprevented SyN (RULE-127). Each missing discard generates **2 PULP** (RULE-126); resolve this overflow PULP immediately as part of the SyN component against the then-current PULP prevention pool. Only PULP actually suffered reduces VIT or qualifies for suffered-PULP triggers (RULE-128). If VIT reaches zero, immediately end the run; do not process VOID or queued triggers.
3. **VOID component:** Apply VOID prevention from its separate pool; resolve remaining VOID as persistent DRAW reduction subject to the established DRAW floor. VOID does not retroactively change cards already drawn.

**Triggers:** Damage-, discard-, and prevention-generated triggered effects are **queued as they arise**, not resolved between the mixed-damage components. Finish the entire mixed-damage effect before resolving its queued triggers under **RULE-014/015** (FIFO), with simultaneous enqueue priority under **RULE-011/012/013**. If immediate defeat occurs, the run ends and queued triggers do **not** resolve. Do not confuse this fixed *damage-component* order with the existing controller-selected order for separate simultaneous triggered effects; RULE-011/012 remain in force for those effects. The normal printed-order rule (RULE-010) still applies to other instructions and distinct effects; RULE-129 specifically overrides printed order for mixed damage components within one effect.

**Prevention and source:** PULP, SyN, and VOID retain their independent prevention pools (DMG-002). SyN overflow PULP uses the PULP pool and the source-neutral application and suffered-only trigger conditions of RULE-128. No reactive Runner card plays during the Corporation turn (SOFT-011).

**Example:** One ICE subroutine inflicts PULP 3 + SyN 3 + VOID 2. Runner has 10 VIT, 2 cards in hand, PULP prevention 1, no SyN/VOID prevention. Resolve PULP 3: prevent 1, lose 2 VIT (8 remain). Resolve SyN 3: mandatory discard 2, shortfall 1 generates 2 PULP; no PULP prevention remains, lose 2 VIT (6 remain). Resolve VOID 2: apply 2 persistent VOID counters. Queue generated triggers during these steps; resolve after the mixed-damage effect completes, if the run survives.

**Defeat precedence:** Reaffirms RULE-RT-002's immediate run defeat at zero Vitae; no later damage, advancement, or queued recovery may reverse defeat. **Status: LOCKED, explicitly approved 2026-11-11.**


### RULE-129 amendment — reversed fixed damage order (LOCKED, 2026-11-11)

**Explicit user revision supersedes the original RULE-129 ordering:** When one effect inflicts multiple damage types, the fixed component order is now **VOID → SyN → PULP**, regardless of controller or printed damage-type order. Any earlier RULE-129 statement of **PULP → SyN → VOID** is superseded and must not be used as the current resolution sequence.

1. **VOID first:** Apply VOID prevention and then persistent DRAW reduction under the established DRAW floor; no retroactive change to cards already drawn.
2. **SyN second:** Apply SyN prevention, mandatory Runner-selected discards, and immediately resolve any resulting **overflow PULP** using the current PULP prevention pool (RULE-126/127/128). Check for immediate defeat after any VIT reduction.
3. **Direct PULP last:** Apply remaining PULP prevention to the effect's direct PULP component; unprevented PULP reduces Vitae (VIT). Check immediate defeat.

**Triggers and defeat unchanged:** Queue damage/discard/prevention triggers until the complete mixed-damage effect finishes (RULE-014/015/129), unless VIT reaches zero, which ends the run immediately and cancels unresolved components and queued triggers (RULE-RT-002). This ordering is fixed, not dynamically optimized or re-sorted by outcome. Reversing component order does not intrinsically increase numerical damage: VOID does not reduce the current hand, and PULP prevention is still consumed by eligible damage in resolution order.

**Revised example:** One effect inflicts PULP 3 + SyN 3 + VOID 2; Runner starts at 10 VIT, 2 cards in hand, PULP prevention 1, no SyN/VOID prevention. First apply VOID 2. Next SyN 3 forces discard of both cards and generates 2 overflow PULP; prevent 1, suffer 1 (9 VIT). Finally direct PULP 3 is unprevented (6 VIT). Queue eligible triggers until all components finish.


## VOID damage enhancement — LOCKED (2026-11-11)

**Explicit user approval:** For each point of **unprevented VOID damage**, the Runner **(1) gains one persistent VOID counter** reducing future normal DRAW by 1 (subject to the established effective DRAW floor of 1), and **(2) must choose and discard one card from their current hand if available**. If a required card is unavailable, **each missing discard generates 5 PULP damage**. Apply the existing PULP prevention pool to this overflow PULP; only unprevented PULP reduces Vitae (VIT) and counts as PULP suffered (RULE-128). The Runner cannot elect to keep available cards and take overflow damage instead.

**Both consequences apply:** A VOID counter is gained **even when no card is available to discard and the 5 PULP overflow occurs**. VOID prevention is applied first; only unprevented VOID generates counters, required discards, and overflow. VOID overflow PULP is ordinary PULP under RULE-128, including its source-neutral prevention and suffered-only trigger semantics. Check immediate defeat whenever VIT is reduced to zero; unresolved instructions and pending triggers stop (RULE-RT-002).

**Mixed damage interaction:** RULE-129's current fixed order remains **VOID → SyN → PULP**. Resolve VOID's mandatory discards and overflow PULP within the VOID component before moving to SyN; this may leave fewer cards available for SyN and cause its separate **2 PULP per missing discard** overflow (RULE-126/127). Resolve direct PULP last. Damage/discard-generated triggers queue until the full mixed-damage effect completes, unless immediate defeat ends the run (RULE-014/015/129). Independent VOID, SyN and PULP prevention pools remain in effect.

**Example:** VOID 2 against a hand of 0, with no VOID or PULP prevention: gain 2 VOID counters, generate 10 PULP, and suffer up to 10 VIT loss (or immediate defeat upon reaching 0). VOID 2 against a hand of 1: gain 2 VOID counters, discard the 1 card, generate 5 PULP before prevention. A mixed effect of VOID 2 + SyN 2 against a hand of 2 first discards both cards and gains 2 VOID counters, then SyN 2 has a shortfall of 2 and generates 4 PULP before prevention.

**Priority:** This approved enhancement supersedes older descriptions that define VOID only as persistent DRAW reduction. No new ordinary-card VOID-counter removal is authorized; existing specialized network recovery and inter-corporation clearing remain unchanged.


## RULE-130 — Fatal damage, pending effects, and partial resolution (LOCKED, 2026-11-11)

**Explicit user approval:** Check Runner Vitae (VIT) **immediately after every actual VIT reduction**, including direct PULP and PULP generated by SyN or VOID shortfall. Apply eligible PULP prevention first. If VIT reaches **0**, the run **immediately ends in defeat**; do not wait for the end of the damage component, card, ICE subroutine, mixed-damage effect, turn, or trigger queue.

**Pending recovery cannot reverse defeat:** No already-queued trigger, later instruction, pending recovery/heal, or future action resolves after defeat, even if it could restore Vitae. A recovery effect that **fully resolved before** the lethal VIT reduction counts normally. A damage-suffered trigger does not interrupt its originating effect; it remains queued per RULE-014/015 and cannot rescue the Runner after lethal damage. This rule creates **no last-chance recovery exception**.

**Partial resolution is not rolled back:** Preserve all changes from instructions and components **already completed before defeat**, including spent prevention, mandatory discards, gained VOID counters, and earlier damage. **Cancel all remaining unresolved instructions, damage components, and queued triggered effects**. Do not roll back completed changes or continue resolving effects after defeat. This is a terminal game-state record, not permission to resume the run.

**Compatibility and priority:** Reaffirms **RULE-RT-002** (immediate defeat), **RULE-014/015** (deferred FIFO triggers), **RULE-127/128** (SyN shortfall and actual PULP suffered), and **RULE-129** (current fixed mixed-damage order **VOID → SyN → PULP**, with VOID's mandatory discard and **5 PULP per missing discard** enhancement). Each type's prevention remains separate, with overflow PULP consuming eligible PULP prevention. Defeat takes priority over queued recovery and over the instruction to complete the mixed-damage event before processing queued triggers. This clarification does not alter controller ordering of simultaneous triggers (RULE-011/012/013) or permit reactive Runner card plays (SOFT-011).

**Example:** Runner has **6 VIT**, **0 cards** in hand, and **no prevention**. VOID 2 first grants **2 persistent VOID counters**, requires 2 discards, and generates **10 PULP** for the 2 missing cards. Upon lethal VIT loss, defeat is immediate. The completed VOID counters and other completed changes remain recorded; subsequent SyN or direct PULP components, later instructions, and queued recovery triggers never resolve.

**Status: LOCKED — explicitly approved 2026-11-11.**


## RULE-131 — Mandatory prevention consumption, immediate overflow, and detailed accounting (LOCKED, 2026-11-11)

**Explicit user approval:** Eligible damage prevention is **automatic and mandatory**. At each actual damage application, the engine consumes applicable prevention immediately; the Runner cannot decline or withhold eligible prevention to save it for a later component or source. PULP, SyN, and VOID have **independent type-specific numerical pools** (DMG-002); only prevention eligible for the incoming damage type may be spent. The displayed pooled value is backed by source/duration accounting.

**Consumption order (RULE-004/005/006):** Within a type-specific pool, consume eligible contributions in the priority already established by RULE-004/005 (earliest expiration first), with the existing RULE-006 equal-expiration tie-breaker. RULE-131 creates **no new source priority**, no player-selected prevention withholding, and no cross-type spending. Record each source contribution consumed and its remaining value.

**Overflow timing and order:** Under the current RULE-129 fixed mixed-damage order **VOID → SyN → PULP**, complete each component before proceeding to the next. For unprevented VOID, apply its persistent counters and mandatory Runner-selected hand discards; each missing discard generates **5 ordinary PULP**. **Immediately resolve that overflow PULP within the VOID component**, automatically consuming then-eligible PULP prevention. Next, for unprevented SyN, perform mandatory Runner-selected discards; each missing discard generates **2 ordinary PULP**, likewise immediately resolved within the SyN component using the PULP pool remaining at that moment (RULE-126/127). Finally, apply any direct PULP component against the remaining PULP prevention. The Runner cannot defer or pool overflow PULP until the final direct PULP component. VOID and SyN prevention are applied before determining their respective unprevented damage and overflow. Source-neutral PULP prevention and suffered-only PULP triggers remain as locked by RULE-128.

**Defeat and triggers:** After prevention, if an actual PULP application reduces Vitae (VIT) to zero, defeat is immediate (RULE-RT-002/RULE-130). Preserve completed changes, cancel unresolved damage components/instructions and pending triggers; no queued recovery can reverse defeat. Otherwise, triggers generated by damage, discards, or prevention are enqueued during resolution and resolve only after the containing mixed-damage effect completes, under RULE-014/015 and RULE-129. This rule does not authorize reactive Runner card plays during the Corporation turn (SOFT-011).

**Mandatory UI and log accounting:** For each damage application, show the **damage source and type**, incoming amount, prevention consumed **broken down by contributing source and duration**, each type-specific pool's remaining amount, unprevented VOID/SyN, mandatory discards completed and shortfalls, **overflow PULP generated and immediately prevented**, **actual PULP suffered**, resulting VIT change, and persistent VOID counters gained. Preserve the step-by-step order in the action log; show when lethal defeat truncates further resolution. These are interface/reporting requirements, not new trigger events.

**Canonical example:** One effect inflicts VOID 2 + SyN 2 + direct PULP 3 against a Runner with **10 VIT, 1 card in hand, 4 PULP prevention, and no VOID or SyN prevention**. VOID 2 adds two counters, discards the one card, and generates 5 PULP for the one missing discard; automatically spend 4 PULP prevention and suffer 1 PULP (VIT 9). SyN 2 has no cards to discard, generates 4 PULP and suffers 4 (VIT 5). Direct PULP 3 suffers 3 (VIT 2). All generated triggers queue until the effect completes unless defeat intervenes.

**Status: LOCKED — explicitly approved 2026-11-11.**


## RULE-132 — Post-Corporation hand cleanup and defensive hand retention (LOCKED, 2026-11-11)

**Explicit user approval:** Ordinary unplayed cards **remain in the Runner's hand through the Corporation Response Phase** and are available for mandatory damage discards. Move routine non-CACHED hand cleanup **after the entire Corporation response and its queued triggers**, before beginning the next Runner turn or transitioning to another ICE layer. This **supersedes only the pre-Corporation hand-discard timing** in RULE-RT-003/004/005; retain the established end-of-turn effects, BW forfeiture, and Corporation response sequencing.

**Revised turn order:** (1) Runner voluntarily selects END TURN (RULE-RT-001); (2) resolve Runner end-of-turn effects, including applicable BW effects and their triggered consequences; (3) **forfeit all remaining BW** (set available BW to zero); (4) enter and fully resolve Corporation Response, including ICE subroutines, damage and all applicable queued triggers; (5) if the run survives, perform **one post-response cleanup**, discarding all remaining non-CACHED cards from hand and resolving resulting discard triggers under RULE-014/015; (6) only after cleanup and its triggers finish, proceed to the next Runner turn, ICE PASS, or Node/ICE transition as applicable. **No routine hand discard takes place between steps 2 and 4.**

**End-of-turn versus cleanup triggers:** Abilities explicitly triggered by **end of Runner turn** still trigger at the existing end-turn window, before BW forfeiture and Corporation response. Abilities triggered by **actually discarding a card** trigger when that discard occurs: damage-induced discards during Corporation response occur then and queue per RULE-014/015/129; routine cleanup discards occur after the response and their triggers resolve before transition. A cleanup discard is **not retroactively an end-of-turn discard** for effects requiring that timing. Resolve the post-response cleanup discard batch and its generated triggers before advancing; follow existing simultaneous-trigger priority and FIFO queue rules. This relocation may change whether discard-generated prevention can affect the current Corporation response; do not backdate it.

**CACHE reconciliation (SOFT-003 through SOFT-008):** CACHE continues to protect selected cards from **routine cleanup**, not from damage. **CACHED cards are eligible for mandatory VOID and SyN discards** under the normal Runner-selection rule (RULE-001), unless an effect expressly provides protection. If discarded by damage, they leave hand and cannot be retained by CACHE. CACHED cards remaining after response survive cleanup, persist across ICE layers within the same Node while supported, and remain **additive to normal DRAW** (SOFT-004/005/006). Loss of CACHE support (SOFT-007) causes affected cards to be treated as ordinary cards at the next applicable cleanup, not discarded immediately merely for losing retention; explicit corporate discard and CACHE-targeting effects (SOFT-008) still work. CACHE does not survive the Node boundary (SOFT-006).

**ICE PASS:** If an ICE PASS or advancement occurs after a Corporation response, use the **single post-response cleanup** for the ordinary non-CACHED hand; do **not** run an additional routine PASS hand discard for those same cards. Finish cleanup-generated triggers before PASS transition. Other PASS-specific effects and triggers remain governed by their actual printed trigger conditions and existing rules; do not invent a second discard event. The next ICE layer retains the established fresh normal DRAW and additive surviving CACHE, subject to existing Node/ICE setup rules.

**DRAW remains unchanged:** No defensive DRAW is added during Corporation response. Preserve RULE-028/029/030/031 start-of-turn sequencing (refresh BW, resolve start-of-turn triggers, calculate DRAW, then normal DRAW) and current effective DRAW formula **max(1, 5 − VOID counters + applicable modifiers)**. Installed Hardware does not inherently reduce DRAW. CACHED cards are additive and do not reduce the number of new cards drawn; VOID counters gained during the response affect future DRAW only.

**Damage and defeat unchanged:** During Corporation response, retained ordinary and CACHED cards are available for mandatory damage discards. Apply the fixed mixed-damage order **VOID → SyN → PULP** (RULE-129). Each unprevented VOID grants its persistent counter and requires one discard; each missing discard generates **5 ordinary PULP**. Each unprevented SyN requires one discard; each missing discard generates **2 ordinary PULP** (RULE-126/127). Apply type-specific prevention automatically and immediately, including PULP prevention against overflow within the originating component (RULE-128/131). Damage-generated triggers remain queued until their containing effect completes (RULE-014/015/129). If Vitae reaches zero, immediate defeat (RULE-RT-002/RULE-130) cancels remaining instructions, pending triggers and post-response cleanup, preserving completed changes.

**Canonical example:** Runner starts with five cards, plays two, and ends the turn holding three. End-turn effects resolve; unused BW is forfeited; the hand is **not** discarded. Corporation inflicts VOID 2 + SyN 2, with no prevention: VOID adds two counters and discards two cards; SyN discards the final card and generates **2 PULP** for one missing discard, reducing Vitae by two if unprevented. No ordinary cards remain at post-response cleanup. At the next normal DRAW, absent other modifiers, the two VOID counters reduce DRAW from five to three.

**Priority:** RULE-132 explicitly supersedes the earlier pre-response routine discard instruction of RULE-RT-003/004/005 and the related older end-turn discard timing in SOFT-003/007, while preserving the underlying CACHE, BW, trigger, damage, defeat, ICE PASS and DRAW mechanics as reconciled above. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-133 — Discard-trigger timing and nonretroactive prevention (LOCKED, 2026-11-11)

**Explicit user approval:** When VOID, SyN, or another effect causes one or more cards to be discarded, discard-triggered abilities generated by those discards **queue as they arise** and **do not interrupt the originating effect**. Finish the entire originating effect (including its remaining mixed-damage components in the fixed **VOID → SyN → PULP** order, immediate overflow PULP, and any other instructions) before resolving its queued triggers. Use existing RULE-011/012/013 simultaneous-trigger ordering and RULE-014/015 FIFO queue semantics; do not create a new priority or interrupt window.

**Prevention gained by discard triggers:** Prevention from a triggered ability becomes available **only when that ability actually resolves**. It applies to eligible **subsequent damage** within its permitted duration, including a later ICE subroutine in the same Corporation response if applicable. It **never retroactively prevents** PULP, SyN, or VOID already resolved, and cannot be spent before it has been gained. Once gained, prevention follows DMG-002 and RULE-004/005/006 (type-specific pools and earliest-expiration consumption) and RULE-131 (automatic mandatory consumption). Damage overflow from missing VOID/SyN discards resolves immediately within its originating component under RULE-127/128/129/131, without waiting for discard-triggered prevention.

**Post-Corporation cleanup:** Following RULE-132, after the Corporation response and its pending triggers have finished, discard all remaining non-CACHED cards in the **single post-response cleanup**. Abilities triggered by those actual cleanup discards queue during cleanup and **resolve before the next Runner turn, ICE PASS, or Node/ICE transition**. Do not defer them to the next turn and do not add a second ordinary PASS discard. These triggers cannot retroactively change damage or prevention from the already-completed Corporation response. End-of-turn triggered abilities retain their earlier end-of-turn window; cleanup discards do not retroactively count as discards during that window.

**CACHE:** CACHED cards are exempt from routine cleanup but remain eligible for mandatory VOID/SyN damage discards unless explicitly protected (RULE-132 and SOFT-003–008). Discarding a CACHED card by damage generates applicable discard triggers under the same deferred timing; CACHE does not create an interrupt or retroactive prevention exception.

**Defeat and cancellation:** Check VIT immediately after each actual VIT reduction following prevention. At zero VIT, defeat is immediate and unresolved instructions and pending triggers are cancelled, with completed state changes preserved (RULE-RT-002/RULE-130). A queued discard-triggered prevention or recovery effect cannot rescue the Runner after fatal damage. SOFT-011 still prohibits reactive Runner card plays during Corporation turn; already-established triggered abilities may resolve when their queued turn arrives.

**Canonical example:** Runner has 10 VIT, three cards in hand, no prevention, and installed Software reading *“Whenever you discard a card, gain 2 PULP prevention.”* One Corporation subroutine inflicts **SyN 2 + direct PULP 4**. SyN discards two Runner-chosen cards, queuing two prevention-gain triggers; the triggers do **not** resolve yet. Direct PULP 4 is unprevented, reducing VIT to **6**. Once the subroutine's full effect finishes, the two queued triggers resolve under FIFO and grant **4 PULP prevention** in total (subject to applicable ability limits and source validity). That prevention may protect against a later subroutine but cannot prevent the earlier 4 PULP. If the Runner had been defeated during the subroutine, the queued triggers would instead be cancelled.

**Priority and reconciliation:** RULE-133 **clarifies, rather than overrides**, RULE-014/015 deferred-trigger resolution; RULE-127/128/129/130/131 damage ordering, prevention, overflow, and fatal damage; RULE-132 post-response cleanup and ICE PASS; and SOFT-003–008 CACHE. It introduces **no retroactive protection, extra DRAW, out-of-turn Runner card-play window, or new discard event**. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-134 — Discard event granularity, trigger frequency, and separate overflow PULP events (LOCKED, 2026-11-11)

**Approved design:** Use the existing instruction-level event model and deferred trigger queue; no new timing or interrupt system. Each **discrete discard instruction or damage component** produces **one grouped discard event** containing a separately recorded occurrence for **each card actually discarded**. Discard zero cards means zero actual card-discard occurrences; do not generate an actual-discard trigger for a shortfall. Distinct instructions are distinct groups even within one card effect. For a mixed damage effect, VOID and SyN are distinct damage components and thus distinct discard groups, even when one ICE subroutine generates both. One ordinary post-Corporation cleanup (RULE-132) is one grouped event containing its individual actual discards, and ICE PASS does not add a second routine cleanup group.

**Trigger wording controls counting:** “Whenever you discard **a card**” recognizes each individual actual card discard (three cards = three qualifying occurrences, subject to existing once-per-turn/activation limits). “Whenever you discard **one or more cards**” recognizes each grouped discard event with at least one actual discard (three cards in one instruction = one qualifying group). “For each card discarded” within a single group uses the group's actual card count as the magnitude of the relevant instruction, not separate events unless its printed trigger explicitly says per card. “The first time ... each turn” retains its existing per-turn allowance; a multi-card discard does not reset or bypass it. Card-specific qualifiers and source validity still apply. Preserve RULE-054/055, RULE-074–079, RULE-105/106 aggregate event identity, RULE-107 actual-vs-attempted magnitude, and existing per-turn limits.

**Separate overflow PULP events (explicit user decision):** For **each missing mandatory VOID discard**, generate a **separate ordinary PULP 5 damage event**; for **each missing mandatory SyN discard**, generate a **separate ordinary PULP 2 damage event**. Never aggregate multiple missing discards into one PULP event for damage-event trigger counting, even when they arise from the same damage component or ICE subroutine. Resolve each generated PULP event **immediately in sequence inside its originating VOID or SyN component**, applying available mandatory PULP prevention afresh against that event under RULE-128/131 and recording actual PULP suffered separately. Triggered effects recognizing a PULP damage event or actual PULP suffered count each qualifying separate event under their exact wording and applicable limits, but **remain queued** until the entire originating effect completes (RULE-014/015/129/133); they cannot create retroactive prevention or interrupt the next overflow event. After resolving all overflow events in VOID, proceed to SyN, then direct PULP, under RULE-129's fixed **VOID → SyN → PULP** order. A direct PULP component remains its own damage event under existing instruction-level rules. Check Vitae after every actual reduction: at VIT zero, RULE-130 immediately ends the run, cancels further overflow events, remaining instructions and queued triggers, preserving completed changes.

**Sequencing and bookkeeping:** For each component, first apply type-specific VOID/SyN prevention; apply each unprevented point's counter/discard consequences as established in RULE-127/129/131, recording actual card discards in the component's grouped discard event and resolving any missing-discard overflow PULP immediately as individual damage events. Preserve mandatory earliest-expiration prevention consumption (RULE-004/005/006/131). Each separate overflow PULP event records its source, originating damage type, amount (5 or 2), PULP prevention consumed by source/duration, actual VIT loss, and associated pending triggers. Discard-trigger occurrences record each card, grouping identifier, source, and reason. Trigger ordering for simultaneously recognized occurrences follows existing controller-order and FIFO rules; no new interrupt window is created.

**Examples:** (A) “Discard 3 cards” actually discards three: one grouped discard event, three per-card discard occurrences; a “whenever you discard a card” ability can queue three triggers, while “whenever you discard one or more cards” queues one. (B) VOID 2 + SyN 2 with four cards in hand: two grouped discard events (VOID discards two, SyN discards two), four individual card discards; per-card trigger count four, per-group trigger count two, before limits. (C) VOID 3 against an empty hand, with no prevention: gain three VOID counters; the three missing discards generate **three separate PULP 5 events**, in sequence, each with independent prevention and trigger-event accounting, stopping immediately on lethal VIT loss. (D) SyN 2 against an empty hand generates **two separate PULP 2 events**, not one PULP 4 event; aggregate VIT loss can equal four if unprevented and nonlethal, but event count remains two.

**Reconciliation and priority:** This rule clarifies RULE-010 instruction boundaries, RULE-014/015 deferred FIFO triggers, RULE-105/106 grouping, RULE-126–131 damage/overflow and prevention, RULE-132 single cleanup and CACHE timing, and RULE-133 deferred discard triggers and nonretroactive prevention. **It explicitly specifies separate overflow PULP event granularity**, superseding any inference that all shortfall PULP in one component forms a single event; numeric PULP amounts and existing prevention mechanics are unchanged. No reactive Runner card plays or extra DRAW are created. **Status: LOCKED, approved 2026-11-11.**


## RULE-135 — Damage-event identity, trigger eligibility, and prevention accounting (LOCKED, 2026-11-11)

**Explicit approval:** Each separate PULP damage application is an independent damage event for trigger eligibility and accounting, including each individual overflow PULP 5 from a missing VOID discard and each individual overflow PULP 2 from a missing SyN discard (RULE-134). Do not merge them into one event merely because they arise from the same ICE subroutine, damage component, or effect. Distinguish **damage applied** (an attempted PULP application, even when fully prevented), **damage prevented** (amount actually absorbed by eligible PULP prevention), and **damage suffered** (unprevented PULP actually reducing Vitae). Abilities recognize only the event their printed conditions name; do not conflate these categories.

**PULP-suffered eligibility:** “Whenever you suffer PULP damage” triggers only on a PULP event that **actually reduces VIT**, and once per qualifying event unless printed wording or an existing activation limit says otherwise. A fully prevented PULP event does **not** qualify as PULP suffered. Event magnitude for “PULP suffered” equals actual VIT reduction, not incoming PULP; prevention amount equals actual prevention consumed, not incoming PULP or unused pool capacity. Preserve RULE-107–109 actual-versus-attempted magnitude and threshold handling, as well as existing per-turn and per-source trigger limits.

**Prevention-event eligibility:** “Whenever you prevent damage” and comparable prevention-consumption triggers recognize only **actual positive prevention consumed**; a zero-consumption event does not qualify. Count prevention separately for each damage application and by the applicable prevention source/duration contribution under RULE-004/005/006 and RULE-131; do not invent a gain or consumption when none occurred. If one damage application consumes several prevention sources, apply existing RULE-074–079, RULE-105/106 and exact card wording to determine per-event versus per-source qualification; this rule does not automatically multiply a single event into one trigger per contributing source. Type-specific VOID and SyN prevention remain separate from PULP prevention; their consumption is accounted for when the respective type is applied.

**Timing:** All damage-, discard-, prevention-, and related triggers are queued as generated, following existing simultaneous-controller ordering and FIFO rules (RULE-011–015). They **do not interrupt their originating effect**, including between separate overflow PULP events within one VOID/SyN component. Resolve the entire originating effect before its queued triggers. Prevention granted by a queued trigger can apply only to **later** eligible damage after it actually resolves, never retroactively or to an earlier overflow event (RULE-133). Resolve each overflow event immediately within its originating component, with mandatory PULP prevention consumed under RULE-131, and preserve fixed mixed-damage order **VOID → SyN → direct PULP** (RULE-129). If VIT reaches zero, defeat is immediate; cancel unresolved damage events, instructions, and queued triggers without reversing completed changes (RULE-130).

**Worked example:** Runner begins at **20 VIT**, with no hand cards, **6 PULP prevention**, and no VOID prevention. Corporation inflicts VOID 3: gain 3 VOID counters and encounter 3 missing mandatory discards. Generate and resolve **three distinct PULP 5 events**, in order. Event 1: prevent 5, suffer 0, VIT 20. Event 2: prevent 1, suffer 4, VIT 16. Event 3: prevent 0, suffer 5, VIT 11. Thus there are **3 PULP applications**, **2 PULP-suffered events**, **2 events with positive PULP prevention**, **6 total PULP prevented**, and **9 total PULP suffered**. A “whenever you suffer PULP damage” ability recognizes two events, subject to its limits; its triggers wait until the full originating VOID effect completes. If the Runner is defeated during any event, remaining events and queued triggers are cancelled.

**Reconciliation and priority:** RULE-135 clarifies, without overriding, RULE-004–006 mandatory source/expiration consumption, RULE-014/015 FIFO deferred triggers, RULE-074–079 prevention-event granularity, RULE-105–109 aggregate events and actual magnitudes, RULE-126–131 damage/overflow and fatal defeat, RULE-132 post-Corporation cleanup, RULE-133 nonretroactive trigger timing, and RULE-134 separate overflow PULP event identity. No new interrupt window, defensive DRAW, retroactive prevention, or extra routine discard is created. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-136 — Damage resolution boundaries and trigger queue checkpoints (LOCKED, 2026-11-11)

**Explicit approval:** Each **independently resolving ICE subroutine** is a distinct effect boundary. Resolve the subroutine's full effect to completion before processing triggers generated by it. This includes all its discrete instructions, mandatory type-specific prevention, VOID counters and required discards, SyN discards, separate overflow PULP events for each missing discard (RULE-134), direct PULP, and resulting VIT changes, in the fixed **VOID → SyN → PULP** component order where mixed damage applies (RULE-129). Do **not** insert a trigger-resolution checkpoint between individual damage components, overflow PULP events, or instructions inside that still-resolving effect. The same principle applies to other independently resolving effects: finish the current effect before its generated triggers.

**Mandatory checkpoint between effects:** After the current independently resolving effect completes, **fully drain all eligible queued triggers** before beginning the next independent ICE subroutine or other effect. Use the existing simultaneous-trigger/controller ordering, FIFO queue, and complete-one-effect-before-generated-triggers semantics (RULE-010–015). A trigger that generates further triggers places them on the existing queue; continue resolving eligible chained triggers until the queue is empty, subject to RULE-016–019 infinite-loop and recursion safeguards and existing trigger eligibility, per-turn activation limits, source-removal cancellation, and explicit exceptions. Do not resolve only the first generation or carry eligible chained triggers into the next effect. An individual queued triggered ability is itself resolved completely before its newly generated triggers are processed under the established queue discipline.

**Updated state between subroutines:** At the next subroutine boundary, apply the game state after the preceding effect and its drained triggers, including new prevention pools, changed VIT, resource changes, discarded cards, VOID counters, installed/removed sources, and temporary effect durations. Prevention gained when a trigger actually resolves may protect against a **later** subroutine if eligible and still active; it **cannot** prevent damage from the completed originating subroutine or any earlier overflow PULP event (RULE-133/135). No new reactive Runner card-play window or out-of-turn DRAW is created (SOFT-011; RULE-132).

**Corporation response and cleanup:** Finish **all** Corporation response effects and their full trigger checkpoints before performing the **single** post-Corporation hand cleanup required by RULE-132. Routine cleanup discards all remaining non-CACHED cards in one grouped discard event (RULE-134), while eligible CACHED cards survive routine cleanup but remain eligible for mandatory VOID/SyN damage discards. Cleanup-generated triggers resolve and drain completely before the next Runner turn, ICE PASS, or Node/ICE transition (RULE-132/133). Never start cleanup with eligible Corporation-generated triggers pending, and never create a second routine ICE PASS cleanup event.

**Immediate defeat overrides checkpoints:** Check VIT after each actual reduction, including each separately resolved overflow PULP event. At VIT 0, defeat immediately ends the run (RULE-RT-002/RULE-130); preserve completed changes but cancel remaining instructions, unresolved damage events, queued triggers and post-response cleanup. No pending heal, recovery, or prevention trigger can rescue the defeated Runner. Mandatory prevention consumption, source expiration priorities, and applied/prevented/suffered event distinctions remain RULE-004–006/131/135.

**Canonical example:** Runner begins at **12 VIT**, with no PULP prevention, and has installed Software: *“Whenever you suffer PULP damage, gain 3 PULP prevention.”* Corporation resolves two independent unbroken ICE subroutines. Subroutine 1 inflicts **PULP 4**; Runner suffers 4, dropping to **8 VIT**, and queues the Software trigger. Subroutine 1 finishes; at its checkpoint the queued trigger resolves, granting **3 PULP prevention**. Subroutine 2 inflicts **PULP 5**; mandatory prevention absorbs 3, Runner suffers 2 and drops to **6 VIT**. The second suffered-damage trigger queues for the checkpoint **after subroutine 2**, not during it. If both PULP instructions were within one independently resolving effect, no checkpoint would occur between them and the new prevention would not apply until afterward.

**Compatibility and priority:** RULE-136 establishes explicit checkpoints **without changing** RULE-010 printed instruction order, RULE-011–015 trigger ordering/FIFO/complete-effect semantics, RULE-016–019 loop safeguards, RULE-126–131 damage types, prevention, overflow and immediate defeat, RULE-132 post-response cleanup and DRAW/CACHE timing, RULE-133 nonretroactive prevention, RULE-134 grouped discard events and separate overflow PULP event identity, or RULE-135 actual-versus-attempted event eligibility. A subroutine is an effect boundary only when it is independently resolving; explicit text defining a single combined effect or existing exceptions retains its established effect boundary. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-137 — Routine post-Corporation cleanup is non-triggering housekeeping (LOCKED, 2026-11-11)

**Explicit approval and precedence:** Routine post-Corporation hand cleanup is a **non-triggering housekeeping operation outside all effect-triggering windows**. Once the entire Corporation response and **all eligible queued/chained triggers** have finished (RULE-132/136), perform the single routine cleanup: discard every remaining **non-CACHED** card from the Runner's hand. These routine cleanup discards **do not generate, queue, or resolve discard-related triggered abilities or any other effect solely because cleanup discarded cards**. They cannot activate installed Software, card abilities, per-card/per-group discard triggers, prevention gains, DRAW, resource gains, or chained effects based on those housekeeping discards. Cleanup is not an effect-triggering checkpoint; once the cleanup action and its bookkeeping finish, advance directly to the next established phase or ICE/Node transition. Do not repeat cleanup or create an additional ICE PASS cleanup.

**Normal effect-caused discards unchanged:** This exception applies **only to routine cleanup discards**. Discards caused by VOID or SyN damage, ICE subroutines, Corporation instructions, Runner card abilities, or other resolving effects remain ordinary effect-caused discards, with their existing individual occurrences, grouped event granularity, eligibility, and deferred FIFO trigger timing under RULE-014/015/127/129/133/134/135/136. A discard that happens **during Corporation response** is not routine cleanup merely because it occurs near the end of the response. All pending effect-generated triggers drain before housekeeping cleanup begins. Explicit card effects are not silently reclassified as housekeeping cleanup.

**CACHE, logging, and accounting:** CACHED cards survive routine cleanup under SOFT-003–008 and RULE-132, unless some separate effect explicitly discards them. Routine cleanup discards are still real cards moved out of hand and **must be recorded** in the game log with card identities, number discarded, phase, and reason marked **ROUTINE CLEANUP / NON-TRIGGERING**. They are not qualifying discard occurrences for trigger activation or trigger-frequency accounting, despite being recorded as a single housekeeping cleanup batch. Do not count them toward effects that ask whether a card was discarded via a triggering event. No defensive DRAW or other benefit is created by cleanup itself.

**Example:** Runner finishes Corporation response with three non-CACHED cards and installed Software reading *“Whenever you discard a card, gain 2 PULP prevention.”* After all response-generated triggers have drained, routine cleanup discards the three cards and logs the batch. **Zero Software triggers** are generated and **zero PULP prevention** is gained from those housekeeping discards. The same Software still recognizes qualifying cards discarded earlier by VOID/SyN or another effect, subject to its normal limits.

**Explicit supersession and reconciliation:** RULE-137 **supersedes only conflicting statements that routine post-Corporation cleanup discards generate or resolve triggers** in RULE-132 (cleanup-generated triggers), RULE-133 (cleanup discard-trigger timing and cleanup-generated effects), RULE-134 (any inference that routine cleanup's grouped discard event generates per-card/per-group discard triggers), and RULE-136 (cleanup-generated/chained trigger checkpoint). All other provisions of RULE-132–136 remain LOCKED and operative: hand retention through Corporation response, full response trigger draining, single post-response cleanup, CACHE survival, separate overflow PULP events, prevention accounting, FIFO effect boundaries, and immediate defeat. Under RULE-010–019, this is a specific housekeeping exception to ordinary effect-trigger eligibility, **not** a new trigger window, queue behavior, or loop rule. Existing rules governing genuine effect-caused discards continue unchanged. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-138 — Discard classification by originating cause and phase-boundary trigger completion (LOCKED, 2026-11-11)

**Explicit approval:** Classify each discard by its **originating cause**, not by how close it occurs to a phase boundary, Corporation response ending, ICE PASS, Node transition, or routine cleanup. A discard expressly caused by an ICE subroutine, Corporation instruction, VOID/SyN damage, Runner card ability, queued triggered ability, or other independently resolving game effect is an **effect-caused discard**, including when it happens immediately before routine cleanup. Such actual discards retain their normal individual-card occurrences and grouped-event identities (RULE-134), eligible triggers and activation limits, and deferred FIFO resolution (RULE-010–015/133–136). Do not silently reclassify effect-caused discards as housekeeping merely because they happen late in the Corporation response.

**Non-triggering cleanup exception:** A discard is **routine housekeeping cleanup** only when it is performed by the single mandatory post-Corporation hand cleanup operation itself. Under RULE-137, those cleanup discards are logged but do **not** generate, queue, or resolve triggered effects based on being discarded. All remaining non-CACHED cards are discarded in that single housekeeping batch; CACHED cards retain their existing exemption. This exception does not suppress triggers from an effect that actually resolves before cleanup or otherwise change damage-caused discards.

**Strict transition checkpoint:** Complete the entire final Corporation effect, then **fully drain all eligible effect-generated triggers and any chained triggers** under RULE-014–019 and RULE-136 **before** routine cleanup begins. If an effect-generated discard causes a trigger that draws or otherwise adds non-CACHED cards to hand, those cards are present when routine cleanup starts and are discarded as part of its non-triggering housekeeping batch unless separately CACHED or otherwise explicitly protected. No eligible Corporation-generated trigger carries into or across cleanup. After the non-triggering cleanup and its bookkeeping, proceed directly to the established next phase, ICE PASS, or Node transition; no additional routine cleanup or cleanup trigger checkpoint is created.

**Logging and auditability:** Record **effect-caused** and **housekeeping** discards as distinct cause classifications. For effect-caused discards, log the originating effect/source, phase, individual card identities and count, grouped discard event identifier, actual qualifying occurrences, and queued/resolved/cancelled triggers as appropriate. For housekeeping discards, log the phase, card identities and count, reason **ROUTINE CLEANUP / NON-TRIGGERING**, and zero generated triggers. Keep the physical discard record even though housekeeping discards are ineligible for discard-trigger frequency or event counting under RULE-137. Preserve existing source eligibility, card-text limits, and mandatory event bookkeeping; do not invent a new interrupt or reaction window.

**Canonical example:** At the last independent Corporation ICE subroutine, the Runner has three non-CACHED cards and installed Software: *“Whenever you discard a card, gain 1 CRED.”* The subroutine reads *“Discard 2 cards from your hand. Then gain 2 PULP prevention.”* Two actual effect-caused discards form one grouped discard event and queue two per-card triggers (subject to limits). The subroutine finishes its printed instructions and grants 2 PULP prevention; only at the checkpoint do the two queued triggers resolve, gaining 2 CRED. Routine cleanup then discards the remaining non-CACHED card, records it as **ROUTINE CLEANUP / NON-TRIGGERING**, and generates **no CRED trigger**. If the checkpoint instead draws two new non-CACHED cards, they are also discarded in the same non-triggering cleanup batch.

**Reconciliation and priority:** RULE-138 reinforces RULE-010 printed instruction ordering; RULE-011–015 complete-effect/FIFO trigger ordering; RULE-016–019 loop safeguards; RULE-132 retained defensive hand and single post-response cleanup; RULE-133 nonretroactive effect-generated discard triggers; RULE-134 per-card and grouped event identity; RULE-135 actual damage/prevention trigger eligibility; RULE-136 effect boundaries and complete trigger checkpoints; and RULE-137's explicit non-triggering housekeeping exception. **RULE-137 remains controlling for cleanup-generated non-trigger eligibility.** This rule clarifies classification and logging without restoring superseded cleanup-trigger language in RULE-132–136 or altering established VOID/SyN/PULP damage, CACHE, prevention, DRAW, or immediate defeat mechanics. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-139 — Source-removal eligibility during trigger checkpoints (LOCKED, 2026-11-11)

**Explicit approval:** If an installed Software source leaves play **before its queued triggered ability begins resolving**, cancel that source's unresolved queued triggers immediately under RULE-081/082/085, regardless of their earlier event-time qualification. **Reinstalling the same physical Software card does not revive those cancelled triggers** and does not reset previously consumed activation allowances under RULE-066/089. A new installed instance is not a retroactive continuation of the departed source. This rule creates no exception to existing event-time eligibility, trigger frequency limits, or explicit source-validity requirements.

**Already-resolving abilities:** Once a triggered ability **has begun resolving**, removal of its Software source does **not** interrupt or cancel that currently resolving ability. Finish its remaining instructions in the established order under RULE-010/014 and RULE-083/086, while enforcing all explicit conditions, costs, required installed status, and other legal requirements at their specified check times (RULE-003/088). Source removal ends source-dependent continuous effects as already established (RULE-090). Events legally generated by the remaining instructions may still qualify other eligible Software for triggers (RULE-084). Other queued, not-yet-resolving triggers from the removed source are cancelled.

**Checkpoint continuation and FIFO:** During RULE-136's mandatory between-effect checkpoint, cancelling a removed source's pending triggers **does not end the checkpoint** or cancel unrelated triggers from other valid sources. Continue processing the existing FIFO queue, skipping/cancelling ineligible entries, resolving each eligible ability fully before processing triggers it generates, and fully draining eligible chained triggers before advancing to the next independently resolving ICE subroutine, other effect, or phase boundary. Retain simultaneous-trigger ordering (RULE-011–013), FIFO (RULE-014/015), and deterministic infinite-loop detection/termination with preservation of completed effects and unrelated queued triggers (RULE-016–019). The rule creates no reactive Runner card-play window or new trigger timing window.

**Corporation response and housekeeping:** The same source-removal checks apply to Corporation-response effect-generated trigger checkpoints. Complete all eligible effect-generated triggers before post-Corporation routine cleanup (RULE-136/138). Routine cleanup discards remain **non-triggering housekeeping** outside effect-triggering windows under RULE-137; RULE-139 does not restore any cleanup-generated triggers or add a cleanup checkpoint. Classify and log effect-caused versus housekeeping discards by originating cause under RULE-138.

**Example:** Two installed Software cards, A and B, each qualify from a PULP-suffered event. Their triggers queue in established order. A's trigger begins resolving; a legal effect during its instructions removes A. A's **currently resolving** ability finishes subject to its remaining conditions/costs, but all **other unresolved queued triggers from A** are cancelled. B's unrelated eligible queued trigger remains and resolves in FIFO order; any further eligible chained triggers are fully drained before the next independent subroutine. Reinstalling A later cannot revive its cancelled entries or reset protected usage limits. If A instead leaves play **before its trigger begins**, that pending A trigger is cancelled.

**Reconciliation and priority:** RULE-139 clarifies the interaction of RULE-014/015 completed-effect and FIFO semantics, RULE-016–019 loop safeguards, RULE-066 activation persistence, RULE-081/082/085 queued-source cancellation, RULE-083/084/086 already-resolving effects and generated events, RULE-088/089/090 explicit installed conditions, new installed instances, and continuous effects, and RULE-136–138 checkpoints, non-triggering housekeeping cleanup, and cause-based discard classification. It **does not override** those locked rules; existing card-specific conditions, costs, source identity, timing, and fatal defeat cancellation (RULE-130) remain controlling. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-140 — Historical trigger-event snapshots and current-state resolution checks (LOCKED, 2026-11-11)

**Explicit approval — historical event facts:** When an event occurs, determine which triggered abilities qualify from that event and the applicable game state **at event time**. Preserve an immutable historical record for each queued trigger: originating event identity/type and source, actual qualifying magnitude (not an attempted or nominal amount), affected card/object identities and relevant event-time facts, trigger source/installed-instance identity, and applicable event-time thresholds or limitations. Subsequent changes in VIT, DRAW, resources, prevention, hand, installed Software, or other state **do not retroactively change the original event, its magnitude, or whether the event qualified**. Event grouping and actual-versus-attempted magnitude continue to follow RULE-105–109 and RULE-134/135, including distinct damage and overflow PULP events and individual discard occurrences.

**Explicit conditions and current-state instructions:** Historical qualification **does not freeze the entire future game state**. At the time a queued triggered ability begins resolving, check source validity and any expressly applicable resolution-time conditions, costs, required installed status, activation limits, or other prerequisites against the **then-current** game state. Evaluate later instruction-specific requirements at their specified instruction times. If a discrete instruction computes a variable numeric value such as DRAW or Trace, take the **instruction-start snapshot** required by RULE-098–104, not a queue-entry or event-time snapshot, unless explicit card text or a more-specific rule says otherwise. Preserve any expressly historical value (e.g., “equal to the PULP damage you suffered in that event”) from the original event record; do not recalculate it from current VIT or prevention. Once an instruction starts, keep its applicable snapshot fixed for that instruction. For “for each” instructions, preserve the instruction-start object set and numeric snapshot with existing eligibility protections (RULE-103/104). Continuous effects still update under RULE-090–095; previously completed draws are not retroactively changed (RULE-096/097).

**Previously qualified triggers and cancellation:** An event-qualified trigger remains historically qualified even if the current game state later changes; **mere state change does not cancel it**. Nevertheless, a pending trigger is cancelled if its Software source leaves play before resolution begins under RULE-081/082/085/139; reinstalling the card does not revive cancelled triggers or reset protected activation allowances (RULE-066/089/139). Explicit conditions and costs may cause a previously qualified ability or instruction to fail or be only partially fulfilled under RULE-002/003/088, without rewriting the event history. Once a valid ability begins resolving, its source leaving play does not cancel its already-resolving instructions, subject to explicit requirements (RULE-083/084/086–088/139). At VIT 0, immediate defeat cancels unresolved instructions and queued triggers under RULE-130; the event snapshot does not protect them from defeat.

**Ordering and checkpoints:** Resolve the current independently resolving effect fully before any generated triggers, then process qualified and still-eligible triggers in established simultaneous/controller order and FIFO (RULE-010–015/136). Continue fully draining eligible chained triggers before the next independent effect, subject to RULE-016–019 loop safeguards; source removal only cancels that source's unresolved entries, not unrelated eligible entries (RULE-139). Trigger snapshots do not create an interrupt, reactive Runner play, or new checkpoint. Before post-Corporation routine cleanup, drain all effect-generated triggers (RULE-136/138); cleanup discards are non-triggering housekeeping outside effect-triggering windows (RULE-137), classified and logged separately (RULE-138).

**Canonical example:** Runner at 10 VIT suffers an unprevented **PULP 3** event, reaching 7 VIT. Software A reads “Whenever you suffer PULP damage, gain 2 PULP prevention.” Software B reads “Whenever you suffer PULP damage, if your VIT is 10 or less **when this resolves**, gain 1 CRED.” Both qualify at event time and enter the FIFO queue with the historical **PULP 3 suffered** event recorded. A resolves first, gaining 2 prevention; this cannot retroactively reduce the original PULP 3. When B begins resolving, check its explicitly resolution-time VIT threshold against **current** VIT: at 7 it gains 1 CRED; if an intervening legal effect instead raised VIT above 10, that condition fails without undoing B's historical event qualification. If B's source left play before B began, its pending trigger would instead be cancelled under RULE-139. A queued “Draw cards equal to your DRAW” instruction similarly uses current DRAW **when that instruction begins**, not DRAW from the triggering event (RULE-098–101).

**Reconciliation and precedence:** This rule clarifies RULE-010–019 (printed order, simultaneous/controller order, FIFO, complete-effect boundaries, chained triggers, loop safeguards); RULE-081–095 (pending versus resolving source validity, instance identity, explicit conditions, continuous effects); RULE-096–104 (DRAW and variable-value instruction-start snapshots and eligible object sets); RULE-105–109 (aggregate event identity, actual magnitude, threshold qualification); and RULE-134–139 (discard/damage event identity, deferred trigger checkpoints, housekeeping exception, cause-based logging, and source removal). It **does not override** more-specific card text, source-removal cancellation, explicit conditions/costs, existing event granularity, prevention timing, mandatory cleanup, or immediate defeat. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-141 — Target selection, historical object identity, and invalid-target fulfillment (LOCKED, 2026-11-11)

**Explicit approval — instruction-time target selection:** Unless explicit card text or a more-specific locked rule directs otherwise, select the target(s) for a queued triggered ability **when each relevant targeting instruction begins resolving**, **not** when the triggering event occurs or the ability enters the FIFO queue. Determine the eligible target set using the **current game state** at that instruction's start. A newly installed or newly eligible object may be chosen if it meets all current requirements; an object that has left play or become ineligible cannot be chosen merely because it was available at queue entry. Preserve the established RULE-001 authority of the affected player/target to choose how to comply when applicable; this rule does not silently transfer choice to the trigger controller. Respect printed instruction order (RULE-010) and explicit targeting restrictions.

**Historical references are fixed:** If an ability refers to **“that card,” “that Software,” “the card discarded,”** or another object identified by the original triggering event, preserve that object's **historical identity** in the immutable RULE-140 event snapshot. Do not substitute another object automatically if the original moves zones, leaves play, changes status, or becomes unavailable. An ability may affect that historical object only when its instructions and applicable zone, identity, cost, and eligibility requirements legally permit it at resolution time. Historical identity does not guarantee continued target eligibility, return rights, or presence in any particular zone. If card text expressly permits a new or replacement selection, follow that text.

**Invalid targets, costs, and partial fulfillment:** When a required target is missing or ineligible at its instruction's applicable check time, apply RULE-002's **fulfill-as-much-as-possible** and independent-instruction principles, together with RULE-003's distinction between instructions, costs, and conditional effects. Do not automatically cancel an entire already-qualified ability solely because one target or one instruction cannot be fulfilled; continue independent legal instructions in printed order, unless explicit conditions, costs, or more-specific text require otherwise. Do not waive a mandatory cost, fabricate a target, retarget a historical reference, or grant a conditional reward whose required condition fails. If the trigger source leaves play before resolution, cancel its pending triggers under RULE-081–085/139; if already resolving, finish as legally possible under RULE-083–088/139. Previously qualified event-time trigger eligibility remains historical under RULE-140, subject to these validity checks.

**Separate instructions versus one “for each” instruction:** Each **separate targeting instruction** selects eligible targets independently at its own instruction start, unless an earlier instruction explicitly fixes an object that later instructions refer back to. This does **not** alter RULE-104: one discrete “for each” instruction snapshots its eligible processing set **once at that instruction's start**, with existing later-condition, cost, and installed-status protections; do not dynamically add objects during that same instruction. Instruction-start variable numeric snapshots remain RULE-098–103, and separate instructions can use changed current state. Historical event snapshots (RULE-140) and instruction-start target/object-set snapshots are distinct concepts.

**Queue and phase compatibility:** Trigger qualification, controller/simultaneous ordering, FIFO queue discipline, full effect boundaries, and chained-trigger checkpoints remain RULE-010–019/136. Target selection does not create a new interruption or reactive Runner card-play window. Source-removal and continuous-effect behavior remain RULE-081–095/139. Effect-generated triggers fully drain before routine post-Corporation cleanup (RULE-136/138); housekeeping cleanup remains non-triggering (RULE-137), with cause-based discard logging (RULE-138). Immediate defeat still cancels unresolved effects/triggers under RULE-130.

**Canonical example:** Runner has Software A, B, and C installed. Two independently eligible queued triggered abilities will resolve in FIFO order. The first instructs removal of an installed Software card, and the applicable chooser removes C. The second reads “Choose an installed Software card. Grant it +2 strength until end of turn.” **Assuming the second trigger's source remains valid**, when its targeting instruction begins only A and B remain eligible; C is not a legal selection. If instead the second ability says “Grant **that discarded Software card** +2 strength,” its event-linked historical card identity remains fixed and no different Software may be substituted; whether the instruction can legally affect the original depends on current zone and explicit card requirements. If the instruction is impossible, independent remaining instructions still resolve to the extent permitted by RULE-002/003.

**Reconciliation and priority:** RULE-141 establishes the default instruction-time targeting convention while preserving RULE-001–003 (chooser, partial fulfillment, conditions/costs); RULE-010–019 (printed order, FIFO and loop safeguards); RULE-081–095 (pending/resolving Software source, installed instances, and continuous effects); RULE-096–104 (instruction-start variable and eligible-object snapshots); and RULE-136–140 (effect checkpoints, non-triggering housekeeping, cause-based discards, source cancellation, immutable event facts and current-state requirements). Explicit card text and more-specific locked rules override this general default where they establish a different target selection or validity timing. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-142 — Physical card identity versus installed-instance identity across zone changes (LOCKED, 2026-11-11)

**Explicit approval — persistent card identity, new installed instance:** Each physical card retains its underlying card identity as it moves between hand, deck, discard, installed play, and other legal zones. **Every installation creates a new installed instance**, even when the same physical Software card is reinstalled. The previous installed instance ends immediately upon leaving play (RULE-089/090). Preserve a stable physical-card identifier separately from an installed-instance identifier and its entry/exit history. A zone change does not by itself make a newly installed instance a continuation of the previous one.

**Historical references distinguish the two identities:** Under RULE-140/141, “that card,” “the card discarded,” and other references to a physical card preserve the original physical-card identity, subject to the instruction's permitted zone, location, costs, conditions, and current eligibility. A reference specifically to “that installed Software,” its prior installation, or an effect tied to that **installed instance** does **not** automatically transfer to a later installation of the same physical card. Do not substitute a different physical card or a new installed instance for a historical target merely because the former target is unavailable. Explicit card text or a more-specific locked rule may authorize a different result. An ability returning an identified card from a specified zone can do so only if that same physical card is legally in the required zone when the instruction resolves; historical identity alone neither moves it nor guarantees eligibility.

**Instance-specific state and no revival:** On departure, the prior installed instance's continuous effects end under RULE-090–095; installation-specific bonuses, modifiers, counters, and other effects attached solely to that instance do not automatically attach to the new installation. Reinstallation **never revives cancelled unresolved triggers** from the departed source (RULE-081/082/085/139), resurrects expired instance-specific continuous effects, or resets protected/consumed activation allowances (RULE-066/089/139). Preserve any effects or counters explicitly defined by their own rules to persist on the physical card across zones; this general rule does not silently erase independently persistent state or create a blanket zone-change reset. A new instance may generate new triggers only from new qualifying events, within existing limits and validity requirements.

**Queued effects, target validity, and resolving abilities:** If an otherwise valid queued instruction references a **specific former installed instance**, removing and reinstalling its physical card does not make the new instance a legal substitute. Apply RULE-141's instruction-time target validity and RULE-001–003 impossibility, costs, and partial-fulfillment rules. If the queued triggered ability's **own source** leaves play before resolution begins, cancel it under RULE-139; reinstallation cannot revive it. An ability already resolving continues as legally possible despite source removal, subject to explicit installed-status conditions and costs (RULE-083/088/139). This rule does not change RULE-102–104's instruction-start variable-value snapshots or fixed “for each” processing sets, nor RULE-140's immutable event facts.

**Canonical example:** A valid separate Software effect queues an instruction “Grant **that installed Software** +2 strength,” referencing installed instance A-1. A legal intervening effect removes A-1, and the same physical card A is later reinstalled as instance A-2. A-2 is **not** A-1; the queued instruction cannot silently apply its +2 to A-2. If the instruction instead references “**that card**” and explicitly permits its present zone and status, it continues to identify physical card A, though it must still meet all current legal requirements when the instruction resolves. Unresolved triggers originating from A-1 were cancelled on removal; no reinstall restores them. This example presupposes the separate effect's source remains valid and all intervening actions are legally permitted by existing timing rules.

**Reconciliation and priority:** RULE-142 confirms RULE-066 (activation allowances), RULE-081–089 (source-removal, already-resolving abilities, and new installed-instance identity), RULE-090–095 (continuous-effect lifecycle and stacking), RULE-102–104 (instruction-time values and eligible processing sets), and RULE-139–141 (pending-source cancellation, historical event snapshots, historical object identity, instruction-time target selection, and invalid-target partial fulfillment). It does not create a reactive play window, alter FIFO checkpoints, restore cleanup-generated triggers under RULE-137, or supersede explicit persistence, zone, target, or card-specific requirements. Immediate defeat and other more-specific cancellation rules remain controlling. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-143 — Historical card references cannot bypass specified-zone requirements (LOCKED CLARIFICATION, 2026-11-11)

**Explicit user approval — specified zone is mandatory:** When an ability refers to a historically identified physical card and instructs an action **from a specified zone**, the identified card must actually occupy that specified zone **when the relevant instruction begins resolving and at any later check explicitly required by the instruction**. If the card has moved to another zone, the specified-zone instruction cannot be fulfilled. Historical card identity (RULE-140–142) does not grant permission to retrieve, move, reveal, or otherwise affect the card from a different zone. **Do not substitute another card or a newly installed instance** unless explicit card text or a more-specific rule authorizes substitution. Apply RULE-002/003 and RULE-141: an impossible instruction fails without automatically cancelling other independent legal instructions; required costs and conditions remain binding.

**Canonical example:** An otherwise valid triggered ability reads, “Whenever you discard a Software card, return **that card from your discard pile to your hand**.” Software A is discarded, qualifying the trigger and fixing A's historical physical-card identity. Before that trigger resolves, a legal intervening effect shuffles A from the discard pile into the deck. On resolution, A is **not in the discard pile**. The return instruction **fails**; A **remains in the deck**, and the player may **not** retrieve A from the deck or select another Software card instead. The original discard event and qualification remain historically recorded; inability to fulfill the later instruction does not retroactively undo them.

**Reconciliation and scope:** This clarification preserves RULE-001–003 (choice, partial fulfillment, costs and conditions), RULE-010–019 (instruction order and trigger queue), RULE-081–104 (source validity, installed-instance identity and instruction-time snapshots), RULE-137–140 (cleanup classification, event identity and historical qualification), RULE-141 (instruction-time target validity), and RULE-142 (physical-card versus installed-instance identity). The clarification **does not approve or lock the other proposed RULE-143 policies** on tracking through hidden zones, information disclosure, or player-visible log redaction; those remain open for separate review. Explicit card text and more-specific locked rules retain precedence. **Status: LOCKED clarification, explicitly approved 2026-11-11.**

## EXTRACT-001 — Basic Extractor payout timing, cap, and banking (LOCKED, approved 2026-11-11)

**Explicit user approval:** An installed **Basic Extractor** is persistent Software, requiring **1 RAM** and **1 BW to install** under TAX-016. Its printed ability is: **“At the end of your Runner turn, extract 5 CRED from the current ICE encounter's remaining CRED reserve.”** The 5 CRED is a fixed printed payout, not a universal payout for other Extractor profiles.

**Timing:** When the Runner selects END TURN, enter the established Runner End-of-Turn Phase. The installed Basic Extractor's end-of-Runner-turn ability qualifies in that existing window, alongside other eligible end-of-turn abilities, and is ordered and resolved under RULE-010–019, including controller/simultaneous ordering, FIFO, complete-effect and trigger-drain checkpoints, and loop safeguards. It is **not** a newly inserted priority phase or a payout automatically placed ahead of other end-turn effects. Finish eligible end-turn effects and generated triggers, then forfeit remaining BW, then resolve Corporation Response, then perform the single non-triggering post-Corporation hand cleanup under RULE-132/137/138. This reconciles RULE-RT-001–005 with RULE-132's superseding cleanup relocation. The payout occurs **before Corporation Response**, not after survival of it.

**Installation-turn eligibility:** Basic Extractor installed during the current Runner turn qualifies for payout at that turn's end, provided it remains installed and eligible when the end-turn trigger is generated. No default startup delay applies. If it is unloaded before END TURN, no trigger qualifies. If its source leaves play after qualification but **before** the queued ability begins resolving, cancel that pending trigger; reinstalling the same physical card does not revive it (RULE-081–090, RULE-139/142). Once an ability has begun resolving, apply the existing source-removal continuation rule subject to explicit requirements, costs, and resolution-time conditions; do not invent an unconditional cancellation or revival (RULE-083/088/139–142).

**Finite encounter reserve:** ECON-002's hard **per-ICE-encounter CRED cap** governs every extraction payout. On resolving Basic Extractor's payout, award **min(5 CRED, the current encounter's unextracted CRED reserve)**, never a negative amount. Reduce that reserve by the actual awarded amount; when it is empty, award 0. Multiple legally installed Extractors, if present, use the reserve remaining at their respective resolution times and follow existing trigger ordering; their combined payouts cannot exceed the cap. The encounter cap's exact numerical size and whether it is visible or hidden remain OPEN. Do not impose a new universal limit on installed Extractors or override other Extractor payout profiles.

**Immediate banking:** CRED actually awarded by a resolving Extractor is **banked immediately upon resolution**, with no survival-or-ICE-PASS condition. Subsequent Corporation retaliation does not retroactively revoke already banked CRED. If VIT reaches 0, immediate defeat ends the run and cancels unresolved effects/triggers under RULE-RT-002/RULE-130; no later pending payout resolves. Existing event snapshots, trigger eligibility, resolution-time conditions, and source/target identity restrictions (RULE-136–142) apply without exception.

**Encounter transitions:** Each ICE encounter has its own finite reserve. An installed Extractor that remains legally in play may qualify in a later ICE encounter under its printed ability and the established Node Software lifecycle; no payout occurs outside an eligible current ICE encounter or beyond that encounter's reserve. Whether extraction is possible after ICE PASS, specific reserve sizes, visibility, and more complex Extractor timing profiles remain open except as expressly fixed here. No new out-of-turn Runner card-play window is created.

**Status:** LOCKED — explicitly approved. Reconciles ECON-002/003; TAX-009/016; RULE-RT-001–005; RULE-010–019; RULE-132; RULE-136–142. All other previously locked rules remain in force.

## GENERALIST-001 — Ten-card starter deck, SYN BUFFER, and Instant PULP shields (LOCKED direction, 2026-11-11)

**Explicit user approval:** The Generalist starts with exactly **10 cards**: (1) WALL ICEbreaker, (2) SENTRY ICEbreaker, (3) CODE GATE ICEbreaker, (4) Basic Extractor, (5) SYN BUFFER, (6–7) two Instant PULP shield cards, and (8–10) three Instant ICE-strength-reduction cards. The first five are persistent installed Software requiring **1 RAM each** and the established **1 BW installation cost**. The Generalist starts with **4 RAM**, so all five cannot be installed simultaneously. The three distinct type-specific ICEbreakers have no finalized individual strength/break-cost profiles yet. Basic Extractor retains **EXTRACT-001**: 5 CRED at end of each eligible Runner turn before Corporation Response, eligible on installation turn, hard encounter cap, immediate banking.

**SYN BUFFER — card wording:** **“Once per ICE encounter, when you would suffer SyN damage, this program automatically prevents 1 SyN damage from that damage event.”** It is installed Software (1 BW installation; 1 RAM). Its automatic prevention applies **during damage resolution before the affected SyN is suffered**, before mandatory SyN discards or overflow PULP; it is not a queued after-damage trigger. It prevents neither PULP nor VOID. **Each installed copy has its own independent once-per-ICE-encounter allowance**, so multiple eligible copies can each prevent 1 SyN, up to the incoming damage amount. An allowance refreshes **on entering the next ICE encounter**, not on either player's turn start (RULE-027/028 do not reset this encounter-specific allowance). An eligible copy's allowance is consumed only when it actually prevents a point of SyN. An installed copy that remains in play between ICE encounters refreshes for the next encounter, consistent with the Node-long Software lifecycle.

**SYN BUFFER reinstall safeguard:** To prevent unloading and reinstalling the **same physical card** from bypassing its once-per-encounter limit, track the used allowance by physical card identity and encounter identity. A card already used during that encounter remains spent if unloaded and reinstalled; a distinct unused physical copy has its own allowance. This is a **card-specific exception** to otherwise fresh installed-instance identity under RULE-089/142, not a general rule that reinstalled Software retains all instance-specific state. An uninstalled copy cannot prevent damage. All existing eligibility, prevention, source-removal and resolution-time rules remain applicable (RULE-001/004–006, RULE-010–019, RULE-081–090, RULE-127–142).

**Instant PULP shields:** Both remaining Generalist Instant shield cards grant a printed amount of **PULP prevention to the Runner's existing shared PULP prevention pool** when played during the Runner turn. They are **not installed**, occupy **0 persistent RAM**, and go to discard after resolving under SOFT-009/010. When the Runner would suffer PULP, **consume eligible PULP prevention from that pool first**, point-for-point; only the unprevented remainder reduces **Vitae (VIT)**. This restates the already locked unified prevention-pool and prevention-before-damage mechanics (SOFT-013/015, DMG-002, RULE-004–006, RULE-127–136), not a new second shield pool. PULP prevention cannot prevent SyN or VOID; those use their own pools. Apply existing expiration at beginning of next Runner turn and existing earliest-expiring eligible prevention priority. Card-specific shield amounts and printed BW costs are **OPEN**, not implicitly fixed here.

**Unfinalized Generalist card details:** The two PULP shield names, amounts and BW costs; the three ICE-strength-reduction Instants' names, magnitude, duration, and BW costs; and individual ICEbreaker statistics are working concepts only. Earlier illustrative names Fracture, Erode, and Destabilize are **not locked card identities**. This entry locks deck structure, lifecycle classifications, SYN BUFFER timing/independent-copy handling, and PULP-pool behavior without inventing numerical card balance.

**Status:** Approved and recorded. Reconcile with TAX-009/016, ECON-002/003, EXTRACT-001, SOFT-009–015, DMG-002, RULE-004–006, RULE-010–019, RULE-027/028, RULE-081–090, RULE-127–142. Preserve more-specific existing rules and no out-of-turn Runner card plays.

## ICE-DESIGN-001 / MULTI-ICE-001 — ICE roles, multi-ICE encounters and DEADLOCK gating (APPROVED, 2026-11-11)

**Design direction approved by user:** ICE encounters can contain **one or multiple ICE**. An encounter must have **at least one DEADLOCK subroutine across its ICE**, but **not every ICE needs DEADLOCK**. An individual ICE may have only offensive subroutines (e.g., one PULP or TRACE), only DEADLOCK subroutines, or a mixture. **One ICE may have three separate DEADLOCK subroutines and no damage subroutines**; each is a distinct subroutine to neutralize. There is no fixed one-DEADLOCK-per-ICE or mandatory one-offense-per-ICE rule. A multi-ICE formation can combine a pure blocking ICE with several weaker offensive/support ICE. All active DEADLOCK subroutines in the encounter must be broken, bypassed, or otherwise legally neutralized to qualify for advancement.

**Preserve locked LOOP-002 timing:** Breaking/neutralizing the last DEADLOCK **does not immediately end the encounter or skip the Corporation's ensuing response**. The Runner must survive the normal Corporation Response before advancement; applicable **unbroken** offensive subroutines can still fire during that response, while broken subroutines do not fire. After response and required post-response cleanup under RULE-132, advancement is allowed only if no active DEADLOCK remains and the Runner has survived. No extra Corporation Response is added solely for leaving. If the Runner remains engaged across turns, active offensive subroutines provide recurring threat during applicable Corporation Responses; use existing subroutine ordering, complete-effect checkpoints, damage/prevention and immediate-defeat rules (RULE-010–019, RULE-RT-001–005, RULE-127–142). Exact ordering of subroutines **across multiple simultaneously engaged ICE**, and any additional encounter-wide sequencing not already specified, remain OPEN; do not silently invent it.

**ICE design identities — tendencies, not absolutes:** **WALLS** generally have the highest strength and comparatively few subroutines, emphasizing PULP and TRACE and/or DEADLOCK; they can instead be pure multi-DEADLOCK blockers. **CODE GATES** generally have lower strength than WALLS and more subroutines, emphasizing SyN, plus PULP and DEADLOCK. **SENTRIES** are generally the deadliest, with highly variable strength and subroutine count and combinations of PULP, SyN, VOID, TRACE and/or DEADLOCK. **PULP is a common baseline offensive threat across all three ICE types**, not Sentry-exclusive, ensuring Instant PULP shields are routinely useful. Not every ICE needs to deal damage individually, provided encounter formations create meaningful pressure. TRACE should have meaningful consequences when successful; its exact per-card effects are not decided here.

**Weak-ICE design:** Low-strength ICE, including potential **Strength 0** ICE, can remain threatening through offensive subroutines or useful through DEADLOCK. Illustrative, **not finalized**, examples include a weak Paper Cut with PULP, a low-strength TRACE support ICE, a Training Wall with PULP and DEADLOCK, and a pure triple-DEADLOCK WALL. Names, strength numbers, damage numbers, number of ICE per encounter, exact TRACE consequences, and individual card balance remain OPEN. The suggested Strength 2 Training Wall and Strength 3 Triple Lock are examples only, not locked card values. Avoid treating an illustrative subroutine ordering as a universal type template.

**GENERALIST-001 card refinement (approved):** The two Generalist Instant PULP shields are **two copies of the same card**, each costing **1 BW** and adding **3 PULP prevention** to the Runner's existing unified PULP pool. On incoming PULP, consume eligible prevention before reducing VIT; temporary prevention follows established expiration and duration-priority rules. Generalist cards 8–10 are **three copies of the same Instant ICE-strength-reduction card**, each costing **1 BW**, with printed effect **“Permanently reduce a target ICE's strength by 2.”** Permanent means the reduction does not expire at end of turn or encounter; it persists for that ICE's existing lifecycle, subject to existing ICE-strength floor and modifier rules. Do not treat the former illustrative Fracture/Erode/Destabilize names as three distinct finalized cards. **All 10 Generalist starter cards uniformly cost 1 BW to play/install**: three unique 1-RAM installed type-specific ICEbreakers, one 1-RAM installed Basic Extractor, one 1-RAM installed SYN BUFFER, two identical PULP-shield Instants, and three identical permanent −2 strength-reduction Instants. The three ICEbreakers' activation/break costs and printed names, and final names of the two Instant card designs, remain OPEN. Installed Software costs 1 BW to install; ICEbreaker activation is a separate mechanic. SYN BUFFER remains once-per-ICE-encounter prevention of 1 SyN, per independently installed copy, with same-physical-card reinstall not resetting the used encounter allowance (GENERALIST-001). Basic Extractor retains EXTRACT-001.

**Status:** User explicitly requested recording and committing these approved design principles. Preserve existing locked LOOP-002, RULE-132, EXTRACT-001, GENERALIST-001 and other rules; do not interpret examples as approved numerical ICE cards.

## LOOP-002-SUPERSESSION-001 — BREACHED encounter skips final Corporation Response (LOCKED, approved 2026-11-11)

**Explicit supersession:** This decision replaces only the portion of LOOP-002 and related MULTI-ICE-001 text requiring a final Corporation Response after all active DEADLOCK subroutines across every ICE in the current encounter have been neutralized. Earlier statements that the Runner must survive an ensuing Corporation Response *after* clearing the last DEADLOCK are superseded by this later locked rule. All other existing Corporation Responses during an uncleared encounter remain in force.

**BREACHED state:** Immediately when all active DEADLOCK subroutines across all ICE in an encounter are broken, bypassed, or otherwise legally neutralized, the encounter becomes **BREACHED** (eligible to finish). This does **not** automatically end the Runner turn or transition to rewards. The Runner retains control and may continue legal Runner-turn actions, including playing cards, spending BW, and using installed programs, until voluntarily selecting **END TURN**.

**Completion sequence:** On END TURN while BREACHED, resolve normal eligible Runner end-of-turn effects (including applicable Basic Extractor payout) and the established BW-forfeiture/end-turn procedures. **Skip the ordinary Corporation Response for this cleared encounter**: no remaining unbroken offensive ICE subroutines execute as a final routine response. Perform the applicable post-turn/encounter housekeeping without manufacturing a response or triggering cleanup effects, then complete the encounter and proceed to the **Reward Step**. No extra Runner turn, exit action, or final Corporation Response is required. The Runner must still be alive and all DEADLOCKs neutralized at completion.

**Scope:** This is a universal encounter-clearance rule, not a change to normal offensive subroutine behavior on earlier turns while DEADLOCK remains. It does not authorize automatic victory at the instant the final DEADLOCK breaks, erase damage already resolved, or create an implicit final retaliation. Any exceptional printed on-breach/on-exit card ability would require its own explicit approved wording and timing; none is established here. Preserve RULE-132's non-triggering housekeeping principle, other existing trigger/prevention rules, and voluntary END TURN. Where older documents conflict, this later specific supersession controls.

**Not decided here:** ICEbreaker activation/BW costs, White Picket Fence's finalized card statistics, and any special breach-triggered abilities remain uncommitted proposals.


## RULES-CONSISTENCY-AUDIT-2026-11-11 — Current implementation precedence (LOCKED reconciliation)

This section reconciles earlier dated design entries; older locked decisions remain historical records, but the later approved revisions below govern implementation. This is a consistency correction, not approval of new card mechanics.

1. **Damage:** PULP is the Vitae-reducing physical damage keyword, including SyN/VOID overflow damage, shields, prevention, damage events, and triggers. SyN and VOID retain their existing effects, prevention, overflow rates, and fixed resolution order **VOID → SyN → PULP**. BURNED is exclusively a card-removal state, not a damage type. Do not convert ordinary narrative verbs such as “burn a CAP” into damage terminology.
2. **BREACHED:** Neutralizing every active DEADLOCK across the encounter enters BREACHED immediately; the Rustler may continue legal actions and voluntarily END TURN. Resolve eligible end-turn effects and housekeeping, **skip the final ordinary Corporation Response**, and proceed to rewards. Earlier LOOP-002 / MULTI-ICE-001 final-retaliation wording is superseded.
3. **Generalist starter deck:** The current approved **12 cards** are one WALL Icepick, one CODE GATE Icepick, one SENTRY Icepick, one Basic Extractor, one SYN BUFFER, **three identical PULP Shields**, **three identical PROBE**, and one unique GHOST SIGNAL (working name). This supersedes the former 10-card starter and two-shield quantities. All three Shields are **1-BW Instant Hardware Packets** granting **3 temporary PULP prevention** each; all three PROBE are **1-BW Instant Software Packets** permanently reducing a target ICE's strength by 2 for that ICE's lifecycle. GHOST SIGNAL is a **2-BW Instant Software Packet** that reduces the first TRACE attempt on the immediately following Corporation turn to zero; its temporary removal is **BURNED** for the remainder of that Node, with return at the next Node under existing BURNED rules. Do not use provisional EXILE as a separate state.
4. **SYN BUFFER:** Persistent **Hardware**, operating type **Executable**, costs 1 BW to install; its existing **1 RAM** cost remains provisional until explicitly changed. Its automatic once-per-ICE-encounter 1 SyN prevention, independent-copy handling, and same-physical-card reinstall safeguard are unchanged. It is not a Protocol or Instant Software. Icepicks and Basic Extractor are Persistent Software Executables; Protocols use the RACK, no RAM, and persist through the Node unless future approved rules say otherwise.
5. **Bloatware:** Hostile Corporation-inserted Bloatware is **Node-specific**, may persist across ICE encounters/layers within that Node, and **does not persist into another Node**. At Node completion, remove all remaining Bloatware copies from the Rustler's card cycle; earlier statements that Node carryover is undecided are superseded. Delivery destination, printed triggers, card-specific earlier removal, and numerical effects remain card-specific. Multiple physical copies stack independently by default, including hand-held ICE buffs and end-turn PULP. If printed to start in discard, insert there; if printed to become BURNED after its hand/end-turn effect, apply that card-specific instruction, and do not return it to the current Node's draw/discard cycle. Do not mistake Bloatware removal for PULP damage.
6. **Economy and timing:** Each ICE encounter has its own finite extractable CRED reserve; Basic Extractor pays up to 5 CRED from that remaining reserve on each eligible Rustler end turn, including the final BREACHED turn, and banks the payout immediately. Training Node test reserves are 15 / 25 / 40 CRED across its three encounters. End-of-turn effects resolve before BREACHED completion; no routine Corporation Response is inserted after BREACH.
7. **Scope and open items:** The approved Sentry and Code Gate Icepick profiles in BREAKER-STARTER-001 supersede older experimental pricing for those breakers only. WALL Icepick statistics, GHOST SIGNAL's final name, and explicitly marked working ICE/test-balance figures remain open. Historical paragraphs describing prior proposals are not alternative live rules; follow this reconciliation and the later approved sections it cites.


## MULTI-ICE-002 — Left-to-right Corporation Response execution (LOCKED, approved 2026-11-11)

**ICE placement:** The **main ICE is always the right-most ICE** in each encounter. Any supporting/secondary ICE occupy positions to its left. This is the encounter's displayed ICE order.

**Normal Corporation Response:** Begin with the **left-most ICE** and move **one ICE at a time from left to right**. For the current ICE, resolve each **unbroken, otherwise eligible subroutine individually from top to bottom**, in its printed/displayed order. Skip broken or otherwise neutralized subroutines. Complete that ICE's subroutine sequence before advancing to the ICE immediately to its right. Continue through the **right-most main ICE**, which resolves last. Effects from an earlier resolved subroutine apply according to their normal timing and duration, and may affect later subroutines or ICE; do not execute all ICE simultaneously or allow either player to freely reorder them.

**Preserved rules:** Apply the established per-subroutine timing, prevention, trigger queues, resolution-time validity, and immediate defeat rules as normal. This ordering does **not** invent a new modifier duration, stacking rule, TRACE consequence, or special DEADLOCK effect. All active DEADLOCKs across all ICE still must be neutralized to BREACH. If the encounter is already **BREACHED** when the Rustler ends the turn, the locked LOOP-002-SUPERSESSION-001 exception **skips the entire ordinary Corporation Response**; do not run this left-to-right sequence after BREACH. Earlier descriptions marking multi-ICE Corporation Response ordering OPEN are superseded by MULTI-ICE-002.


## TRACE-001 — Cumulative TRACE meter and warning threshold (LOCKED, approved 2026-11-11)

**TRACE is a cumulative tracking value against the Rustler**, represented by a meter with significant **50% and 100% marks**, not an opposed skill check. Corporation ICE subroutines, Bloatware, and other explicitly printed effects add their specified TRACE amounts to the Rustler's accumulated TRACE. Rustler effects may reduce an incoming TRACE addition before it is applied, or lower TRACE already on the meter, as specified by the effect. Use the normal MULTI-ICE-002 left-to-right/top-to-bottom Corporation Response order for TRACE-bearing subroutines and established card-effect timing for other TRACE sources. Do not treat a printed TRACE addition as an automatic opposed contest.

**50% TRACE — warning only (Option C):** Reaching, exceeding, or crossing the **50%** meter mark **does not itself cause an automatic penalty, Corporation Response, extra defense, damage, or other trigger**. It is a visible warning and a condition that **individual printed card effects may explicitly check** (for example, effects worded to apply while TRACE is at or above 50%). Such effects operate only under their own printed conditions and existing timing/trigger rules. Repeated crossings of 50% do not independently generate events or penalties.

**100% TRACE — location compromised:** At **100%**, the Corporation **identifies the Rustler's location** and **deploys additional defenses intended to eliminate the intruder**. This escalation is approved in principle, **not an automatic declaration of Rustler defeat**. The exact deployment package, its timing and duration, whether TRACE can subsequently be reduced, and whether/how another 100% crossing matters remain **OPEN**; do not invent these mechanics. The 50% warning rule does not dilute the approved 100% location-compromise consequence.

**Interaction with GHOST SIGNAL:** The approved unique GHOST SIGNAL Packet reduces the first TRACE attempt/addition during the Corporation's immediately following turn to zero, consistent with its printed first-attempt-only wording; it does not automatically reset the Rustler's existing accumulated TRACE or negate later TRACE additions. Its BURNED once-per-Node lifecycle is unchanged. Exact normalization of legacy TRACE terminology (including older TRACE 40 examples) to meter units/percentage, TRACE cap/floor and persistence/reset between encounters/Nodes remain **OPEN**. No percentage-to-printed-value conversion is approved here.

**Precedence:** This section supersedes earlier notes describing TRACE accumulation, 50% consequences, or the nature of TRACE resolution as wholly undecided. It preserves all existing damage, BURNED, BREACHED, Bloatware, and Corporation Response rules.


## TRACE-002 — Corporation-dependent TRACE persistence and reset (LOCKED, approved 2026-11-11)

**Corporation scope:** The Rustler's accumulated TRACE belongs to the **Corporation currently being encountered**. TRACE is not reset merely because the Rustler moves between ICE encounters/layers or Nodes **within that same Corporation**; accumulated TRACE carries forward and remains subject to TRACE-001 countermeasures and thresholds.

**New Corporation:** When the Rustler **encounters a new Corporation**, initialize the TRACE meter for that Corporation at **0**. TRACE accrued against the preceding Corporation does **not transfer** to the new Corporation. The 50% warning and 100% location-compromise thresholds apply to the current Corporation's meter.

**Not decided:** Whether returning later to a previously encountered Corporation restores its earlier meter or starts a fresh tracking session, and the exact 100% defense-deployment mechanics, are not established by this decision. Do not assume a global run-wide TRACE meter or an ICE/Node reset.


## TRACE-003 — Returning to a previously encountered Corporation resets TRACE (LOCKED, approved 2026-11-11)

**Fresh intrusion reset:** Whenever the Rustler begins a **new encounter with a Corporation after having left that Corporation**, initialize that Corporation's TRACE meter at **0**, **even if the Rustler encountered that same Corporation earlier in the run**. Do not restore any TRACE accumulated during the earlier visit. TRACE continues to accumulate across ICE encounters and Nodes **during one uninterrupted visit** to the same Corporation; moving between its internal ICE layers or Nodes does not trigger a reset.

**Precedence:** This explicitly resolves the return-visit question left open in TRACE-002. Read TRACE-002's “new Corporation” reset together with this rule: a newly entered Corporation **or a fresh return visit** starts at zero. TRACE-001's 50% warning-only and 100% location-compromise rules remain unchanged; the 100% deployment specifics remain OPEN.


## RUN-003 — Forward-only run progression reaffirmed (LOCKED, 2026-11-11; see original RUN-003)

**Baseline navigation rule:** During a run, the Rustler **always progresses forward and never retraces their steps**. After leaving or completing an ICE encounter, Node, or Corporation, the Rustler cannot navigate backward to revisit that completed location or reverse the route. This is a run-level navigation constraint, not a restriction on taking multiple Rustler turns within an active encounter or on revisiting a Corporation in a separate new run.

**TRACE reconciliation:** TRACE accumulates through consecutive ICE encounters and Nodes within the currently visited Corporation and resets to **0 when entering a new Corporation**. TRACE-003's earlier hypothetical rule for returning to a previously encountered Corporation is **non-operative during normal forward-only navigation** because the Rustler cannot backtrack to a completed Corporation. Keep TRACE-003 as a historical clarification for any future explicitly approved exception, not as permission to retrace a route. No such exception is approved here.

**Scope:** This rule does not prescribe the number of encounters, Node topology, branching choices at unvisited forward paths, or a reverse-navigation mechanic. Do not infer any ability to backtrack from encounter-selection, logging, rewind/debugging, or prior design examples.


## RUN-003 / RUN-004 — Existing junction and forward-route rules reaffirmed (2026-11-11)

**This is a reconciliation of pre-existing approved rules, not a new choice.** Every corporate **Node is a junction offering multiple selectable forward paths**. The Rustler chooses the next forward route at each Node; previously passed Nodes lock behind the Rustler and **cannot be revisited** in that run. The network is presented as a circuitous, disorienting **lattice**, but apparent visual loops do not permit mechanical backtracking. A Node can present up to **five or six onward options**; that is an upper example, not a fixed required number. **Every available forward route reaches the Corporation core, and all complete routes contain the same number of Nodes**; there are no selectable dead ends or shortcuts in Node count. These principles were already established as RUN-002 (visual topology), RUN-003 (forward-only traversal and route choices), and RUN-004 (equal-length guaranteed core routes) in the master design on 2026-11-10.

**Identifier reconciliation:** The later section titled “RUN-001 — Strict forward-only run progression” (2026-11-11) repeats the substance of existing **RUN-003**, and its identifier must **not** supersede the earlier **RUN-001 — Victory condition**. Treat that later section as a historical reaffirmation of RUN-003, **not** a second independent RUN-001. Any older OPEN notes suggesting backtracking, Node revisits, junction route selection, dead ends, or unequal path lengths are superseded by these locked rules. Do **not** re-open these settled questions without an explicit request to revise them. TRACE continues to reset on entering a new Corporation, not at each Node or ICE encounter.


## TRACE-004 — 100% TRACE Corporation countermeasures TBD (LOCKED boundary, 2026-11-11)

At **100% TRACE**, the Corporation identifies the Rustler's location, as established by TRACE-001. **The specific Corporation countermeasures deployed at 100% TRACE are TBD and not yet designed or approved.** Do not presume reinforced ICE, a hunter program, a special encounter, damage, defeat, timing, duration, or any other particular mechanic. Earlier language about deployment of additional defenses expresses the intended narrative escalation only; the actual countermeasure rules remain **OPEN**. TRACE-001's 50% warning-only rule and TRACE-002/003 Corporation-scope reset rules remain unchanged.


## BREAKER-STARTER-002 — Generalist WALL Icepick partial profile (APPROVED, 2026-11-12)

The Generalist starter **WALL Icepick** is a **Persistent Software Executable** compatible with **WALL ICE**. Its **base breaking Strength is 1**. The Rustler may **spend 1 BW to increase its breaking Strength by 1**, with boosts accumulating for the **remainder of the current ICE encounter**, consistent with BREAKER-STARTER-001's starter Icepick Strength-boost duration. This approval defines only base Strength and Strength-boost cost/amount; the **BW cost to break an individual WALL subroutine remains OPEN** and must not be assumed. Existing starter Icepick installation and RAM rules are unchanged. This supersedes older notes saying all WALL Icepick profile details are undecided, but does not settle other training-encounter balance questions.


## BREAKER-STARTER-003 — WALL Icepick subroutine-breaking profile (LOCKED, 2026-11-12)

The Generalist starter **WALL Icepick** is a Persistent Software Executable compatible with WALL ICE, with **base breaking Strength 1** and **spend 1 BW for +1 breaking Strength for the remainder of the current ICE encounter** (BREAKER-STARTER-002). Its subroutine-breaking abilities are:

- **Once per Rustler turn:** Break **one** subroutine on a compatible WALL ICE for **0 BW**.
- **Additional breaks:** Spend **1 BW** to break **one** subroutine on a compatible WALL ICE; each further paid break costs 1 BW.
- **Strength requirement:** Both free and paid breaks require the WALL Icepick's current breaking Strength to meet or exceed the target WALL ICE's current Strength, as with other Icepicks.
- The free use **refreshes each Rustler turn**, not each encounter, and unused free breaks **do not accumulate**. It is one free break per turn for this installed Icepick, not one per target WALL or subroutine. Existing installation/RAM, card lifecycle, and encounter rules remain unchanged.

**Status:** The three Generalist starter Icepick breaking profiles are now defined: Sentry (Strength 0; +1 per 1 BW; 1 BW per subroutine), Code Gate (Strength 3; +1 per 2 BW; 1 BW per subroutine), WALL (Strength 1; +1 per 1 BW; first eligible break each Rustler turn free; subsequent breaks 1 BW each). Earlier statements that WALL's breaking cost remains OPEN are superseded.


## BREAKER-STARTER-004 — WALL Icepick base Strength revised to 0 (LOCKED, 2026-11-12)

**Approved revision:** The Generalist starter **WALL Icepick's base breaking Strength is 0**, replacing the previously approved Strength 1 in BREAKER-STARTER-002 and repeated historical summaries in BREAKER-STARTER-003. This is an explicit supersession; do not use Strength 1 as the current rule.

**Complete current WALL Icepick profile:** Persistent Software Executable compatible with WALL ICE; **base breaking Strength 0**; spend **1 BW to gain +1 breaking Strength** for the remainder of the current ICE encounter (boosts stack); **once per Rustler turn, break one compatible WALL subroutine for 0 BW**; each additional compatible WALL subroutine break costs **1 BW**. All free and paid breaks require the Icepick's current breaking Strength to be at least the target WALL ICE's current Strength. The free break refreshes each Rustler turn, does not accumulate, and is limited to once per turn per installed Icepick. Existing installation and RAM requirements remain unchanged.

**Balance intent:** The free once-per-turn subroutine break offsets the additional BW needed to boost from Strength 0. This decision changes only the WALL Icepick's base Strength, not the Sentry or Code Gate profiles or any other established rules.


## GENERALIST-STARTER-LOCK-001 — Approved 12-card starter deck and no Protocols (LOCKED, 2026-11-12)

The **Generalist starter deck is exactly 12 physical cards**:

| Qty | Card | Operating classification | Nature | Play/install cost |
| ---: | --- | --- | --- | --- |
| 1 | WALL Icepick | Persistent Executable | Software | 1 BW install |
| 1 | SENTRY Icepick | Persistent Executable | Software | 1 BW install |
| 1 | CODE GATE Icepick | Persistent Executable | Software | 1 BW install |
| 1 | Basic Extractor | Persistent Executable | Software | 1 BW install |
| 1 | SYN BUFFER | Persistent Executable | Hardware | 1 BW install |
| 3 | PULP Shield | Instant Packet | Hardware | 1 BW each |
| 3 | PROBE | Instant Packet | Software | 1 BW each |
| 1 | GHOST SIGNAL (working name) | Instant Packet | Software | 2 BW |

**Composition:** **5 Executables, 7 Packets, 0 Protocols, 0 Bloatware** at the start of a Generalist run. This explicitly confirms **no Protocol cards in the starter deck**; Protocol remains an established card classification for other cards or later acquisitions. Bloatware may be inserted by Corporation effects during play, but is not part of the starting 12 cards.

**Current approved abilities:** WALL Icepick: base breaking Strength **0**, +1 Strength for 1 BW for the remainder of the ICE encounter, first eligible WALL subroutine break **free once per Rustler turn**, subsequent breaks 1 BW each. SENTRY Icepick: base Strength 0, +1 Strength for 1 BW, break a compatible subroutine for 1 BW. CODE GATE Icepick: base Strength 3, +1 Strength for 2 BW, break a compatible subroutine for 1 BW. All breaks require sufficient breaker Strength. Basic Extractor: earn up to 5 CRED at each eligible Rustler end turn from current ICE encounter's finite reserve. SYN BUFFER: automatically prevent 1 SyN once per ICE encounter per independently installed copy. Each PULP Shield: +3 temporary PULP prevention to the shared pool. Each PROBE: reduce target ICE Strength by 2 for that ICE lifecycle. GHOST SIGNAL: reduce the first TRACE addition during the immediately following Corporation turn to 0, then BURNED until the next Node, usable once per Node.

**Resource status:** Existing 1 RAM requirements for the four Software Executables remain as approved. SYN BUFFER's 1 RAM requirement remains **provisional and open for rebalancing**, not newly finalized here. GHOST SIGNAL is still a **working name**. Earlier 10-card starter lists, two-shield quantities, and WALL base Strength 1 are historical/superseded; they are not alternate active starter configurations. This lock confirms the starter deck composition, not the unresolved training ICE or balance details.


## BREAKER-STARTER-005 — WALL Icepick base Strength restored to 1 (LOCKED, 2026-11-12)

**Latest explicit approval supersedes BREAKER-STARTER-004 and GENERALIST-STARTER-LOCK-001 only where they specify WALL Icepick base Strength 0:** The Generalist starter **WALL Icepick has base breaking Strength 1**. This restores the earlier Strength 1 baseline and is the **current authoritative value**; Strength 0 is historical and must not be used for current rules or playtesting.

**All other approved WALL Icepick mechanics are unchanged:** Persistent Software Executable compatible with WALL ICE; **spend 1 BW for +1 breaking Strength** for the remainder of the current ICE encounter; **once per Rustler turn break one compatible WALL subroutine for 0 BW**, with subsequent compatible WALL subroutine breaks costing **1 BW each**. Every break requires the Icepick's current breaking Strength to meet or exceed the target WALL ICE's current Strength. Free breaks refresh each Rustler turn and do not accumulate. Installation and RAM requirements are unchanged. The Generalist starter deck remains exactly 12 cards, including one WALL Icepick and **zero Protocols**. No SENTRY or CODE GATE Icepick profile is changed.


## CARD-SUBTYPE-001 — EXPLOIT / CLOAK and reactive SENTRY (LOCKED, 2026-11-12)

**Functional subtypes are distinct from existing card classifications:** EXPLOIT denotes offensive cards that compromise, weaken, or manipulate hostile systems; CLOAK denotes defensive cards that protect the Rustler, conceal activity, or interfere with hostile detection and attacks. These functional subtypes are orthogonal to Hardware/Software and Packet/Executable classifications. Do not confuse CLOAK with a specific cloaking technology; its meaning includes physical damage prevention.

**Generalist starter card subtype assignments (LOCKED):** PROBE = **EXPLOIT** (Software Packet); PULP Shield = **CLOAK** (Hardware Packet); GHOST SIGNAL (working card name) = **CLOAK** (Software Packet). No other starter cards receive a subtype from this decision. In particular, do not infer that all installed protective cards are CLOAK without separate approval.

**SENTRY reactive ability (LOCKED):** **Whenever the Rustler plays a CLOAK card, this SENTRY gains +1 Strength.** Each distinct CLOAK card play triggers +1 Strength; the trigger is on playing a card, not on automatic activations of previously installed cards. The Strength bonus duration/reset timing and any encounter-specific stacking restrictions beyond the per-play trigger remain to be specified; do not silently treat a proposed duration as approved. The precise SENTRY starting Strength remains open.

**Terminology:** EXPLOIT and CLOAK supersede proposed DEFENSE, SHROUD, SAFEGUARD, ASSAULT and COUNTERMEASURE names for these Rustler functional subtypes; COUNTERMEASURE remains available as Corporation terminology. This decision does not change card costs, effects, deck counts, or Icepick profiles.


## NODE-EXTRACTION-001 — Full extraction bonus (LOCKED, 2026-11-12)

**General Node rule:** If the Rustler extracts **all CRED in a Node's finite extractable CRED reserve (100%)**, award a **one-time bonus equal to 10% of that Node's original CRED reserve**. The bonus is additional earned CRED, **not** a refill of the Node's reserve, and does not count as CRED remaining to extract. It applies regardless of which eligible extraction effect empties the reserve; it is **not** exclusive to Basic Extractor. Award immediately when the reserve reaches zero through extraction; do not award again for the same Node. A Node not fully extracted receives no full-extraction bonus. Example original reserves: 15 CRED -> +1.5 CRED (16.5 total), 25 -> +2.5 (27.5 total), 40 -> +4 (44 total). **Fractional CRED handling/rounding is not yet defined**; these examples express the exact 10% mathematical bonus and must not be interpreted as a finalized fractional-CRED accounting rule.


## NODE-EXTRACTION-002 — General Node full-extraction bonus rounding (LOCKED, 2026-11-12)

**This is a global game rule for ALL Nodes**, not an ability of an individual card, extractor, Node type, or training encounter. Whenever the Rustler extracts **100% of a Node's original finite CRED reserve**, grant **one bonus equal to 10% of the original reserve, rounded UP to the nearest whole CRED**: `bonus_CRED = ceil(original_node_CRED_reserve * 0.10)`. This bonus is paid once per Node, adds to banked earnings, does not replenish the Node's extractable reserve, and is independent of the extraction method. No full-extraction bonus is paid if any reserve CRED remains unextracted. Example: 15 reserve -> +2 bonus, 17 total; 25 -> +3, 28 total; 40 -> +4, 44 total. This explicitly **supersedes the fractional-CRED examples and open rounding question in NODE-EXTRACTION-001**. CRED bonuses under this rule are always whole numbers.


## TRAINING-THREE-ICE-SENTRY-001 — Main SENTRY base Strength and bonus duration (LOCKED, 2026-11-12)

In the three-ICE training encounter, the **rightmost main SENTRY starts at Strength 3** (not the previously proposed 5). Its locked reactive ability remains: **Whenever the Rustler plays a CLOAK card, this SENTRY gains +1 Strength**. **All Strength bonuses applied to this SENTRY last for the current ICE encounter only** and expire when that encounter ends; multiple qualifying bonuses stack during the encounter. This encounter-duration rule covers the SENTRY's reactive +1 Strength bonuses and Strength bonuses conferred by supporting ICE effects (including the working supporting CODE GATE +2 effect, if that effect resolves). It does not by itself finalize the CODE GATE effect's trigger, frequency, or other unresolved specifics. The base Strength 3 is restored on a new encounter; no Strength bonuses persist between ICE encounters or Nodes. The previously proposed base Strength 5 is rejected. All other encounter rules remain unchanged.


## TRAINING-THREE-ICE-CODE-GATE-001 — Supporting CODE GATE Strength boost (LOCKED, 2026-11-12)

In the three-ICE training encounter, the supporting CODE GATE's SENTRY-strengthening subroutine grants **+1 Strength to the rightmost main SENTRY**, **not +2**. The subroutine **activates as normal** under existing multi-ICE Corporation Response rules: ICE resolve left-to-right; eligible unbroken subroutines resolve top-to-bottom during normal Corp Response. It is **not** an automatic passive trigger or a special one-time activation. Each time the subroutine normally resolves, it grants +1 Strength, stacking with other encounter-long Strength bonuses; the added Strength expires at the end of the current ICE encounter. If the subroutine is broken or otherwise prevented, it does not grant the bonus. This supersedes earlier working +2 text. Main SENTRY base Strength remains 3 and its +1 Strength per played CLOAK ability remains unchanged. No change to other CODE GATE subroutines or TRACE rules.


## RUSTLER-STARTING-RESOURCES-001 — TRACE capacity and VITAE (LOCKED, 2026-11-12)

The Rustler starts with **30 VITAE** and a **TRACE meter capacity/maximum of 40 TRACE points**. The TRACE meter is visually displayed as 0–100% of its current 40-point capacity, while printed TRACE values are actual TRACE points (e.g., TRACE 3 adds 3 points, equivalent to 7.5% of a 40-point meter). At capacity 40, the 50% warning threshold is 20 TRACE points and 100% detection threshold is 40 TRACE points. Existing TRACE persistence/reset rules and the still-undetermined Corporation countermeasures upon reaching 100% remain unchanged. This establishes starting VITAE as 30; it does not by itself establish whether 30 is a hard VITAE maximum or how VITAE regeneration works. This supersedes earlier unresolved TRACE numeric normalization and any conflicting provisional starting VITAE values.


## VITAE-CAPACITY-001 — Starting VITAE is not maximum VITAE (LOCKED, 2026-11-12)

**The Rustler starts with 30 VITAE. This is NEVER to be treated as a fixed or universal maximum.** The Rustler's initial MAX VITAE value and any general upper limit are **undefined / not yet specified**. Future cards and Ghostware can provide effects that **increase current VITAE** and/or **increase MAX VITAE**; these are distinct mechanics and must be represented separately. Do not infer that gaining current VITAE automatically increases MAX VITAE, or vice versa, unless a particular card explicitly says so. Do not hard-code MAX VITAE = 30 or silently introduce a fixed maximum in design or implementation. This clarification supersedes any suggestion in RUSTLER-STARTING-RESOURCES-001 or earlier notes that 30 might be a maximum. TRACE starting capacity remains 40, separate from VITAE.


## TRAINING-THREE-ICE-CODE-GATE-A-002 — Sole subroutine and once-per-Corporation-turn timing (LOCKED, 2026-11-12)

**CODE GATE A**, the **leftmost supporting CODE GATE** in the third training-layer three-ICE encounter, has **exactly one subroutine**:

> **Grant the main SENTRY ICE +1 Strength.**

This sole subroutine **resolves once per Corporation turn during the normal Corporation Response**, provided it remains eligible and unbroken. It is not a passive effect and does not activate more than once in the same Corporation turn. On each subsequent Corporation turn in which it resolves, it grants an additional +1 Strength; these bonuses **stack and last only until the end of the current ICE encounter**, consistent with TRAINING-THREE-ICE-SENTRY-001 and TRAINING-THREE-ICE-CODE-GATE-001. Breaking/preventing the subroutine prevents its resolution for that turn. CODE GATE A has **no additional subroutines**. Its provisional Strength 5 remains a working value, not newly locked by this decision. Main SENTRY base Strength remains 3.


## TRAINING-THREE-ICE-WATCHDOG-001 — Main SENTRY named WATCHDOG (LOCKED, 2026-11-12)

The **rightmost main SENTRY ICE** in the third training layer is officially named **WATCHDOG**. Its locked base Strength is **3 STR**. Its existing reactive ability is unchanged: whenever the Rustler plays a CLOAK card, **WATCHDOG gains +1 STR** for the current ICE encounter; multiple triggers stack.

The **leftmost supporting CODE GATE 1** has exactly one subroutine, now printed in the approved canonical subroutine notation:

`[S1] WATCHDOG gains +1 STR.`

This subroutine resolves once per Corporation turn under normal Corporation Response rules if eligible and unbroken. Each resolved bonus stacks and lasts for the current ICE encounter. All ICE subroutine lists in future REDLINE design work should use `[S1]`, `[S2]`, etc., in top-to-bottom resolution order. For example, the other supporting CODE GATE 2's working list is:

`[S1] PULP 3`
`[S2] TRACE 3`

WATCHDOG supersedes any proposed name RATCHET; this change is a naming and notation decision, not a new effect or numerical balance change.


## TRAINING-CRED-REBALANCE-002 — Training Node CRED reserves 10 / 15 / 25 (LOCKED, 2026-11-12)

The three Training Node ICE encounter/layer **original finite CRED reserves** are now **Layer 1 = 10 CRED; Layer 2 = 15 CRED; Layer 3 = 25 CRED**. Total base reserves **50 CRED**. This expressly **supersedes the former provisional 15 / 25 / 40 CRED training reserves** (80 total) and any alternate 10 / 15 / 20 proposal. Apply the existing universal per-Node full-extraction bonus independently to each layer's reserve when fully depleted: **ceil(10% of original reserve)**, so bonuses **+1 / +2 / +3** and maximum payouts **11 / 17 / 28 CRED**, totaling **56 CRED** if all three layers are fully extracted. No bonus for partial extraction. Basic Extractor's existing 5-CRED per eligible end turn remains unchanged. This is the authoritative Training Node CRED schedule wherever historical numbers conflict.


## TRAINING-WATCHDOG-SUBROUTINES-001 — WATCHDOG subroutine adjustment (APPROVED, 2026-11-12)

In Training Node Layer 3, **WATCHDOG — SENTRY — STR 3** has the following approved working subroutine list, in top-to-bottom resolution order:

`[S1] PULP 4`
`[S2] SyN 1`
`[S3] DEADLOCK`

The user specifically reduced the proposed `[S2] SyN 2` to **`[S2] SyN 1`**. This replaces that earlier proposed value. WATCHDOG's existing reactive ability remains unchanged: whenever the Rustler plays a CLOAK card, WATCHDOG gains +1 STR for the current ICE encounter; bonuses stack. Do not alter the already-approved base STR 3. This entry approves the revised working subroutine roster; do not silently modify other ICE or mechanics.


## TRAINING-WATCHDOG-SUBROUTINES-002 — PULP 4 and DEADLOCK share one subroutine (CORRECTION, 2026-11-12)

Correct the preceding WATCHDOG roster: **WATCHDOG — SENTRY — STR 3** has **two** subroutines, not three:

`[S1] PULP 4 + DEADLOCK`
`[S2] SyN 1`

PULP 4 and DEADLOCK are **two effects on the same [S1] subroutine**, not separately breakable subroutines. Breaking [S1] prevents both effects, including its DEADLOCK. This supersedes the prior `[S1] PULP 4 / [S2] SyN 1 / [S3] DEADLOCK` presentation. Existing CLOAK-triggered +1 STR reactive ability and base STR 3 remain unchanged. Preserve top-to-bottom [S#] numbering.


## TRAINING-WATCHDOG-SUBROUTINES-003 — Final corrected three-subroutine layout (LOCKED, 2026-11-12)

**WATCHDOG — SENTRY — STR 3** has **exactly three subroutines**, in order:

`[S1] PULP 4 + DEADLOCK`
`[S2] SyN 1`
`[S3] DEADLOCK`

There are **two DEADLOCK effects**, one attached to [S1] together with PULP 4, and the other as standalone [S3]. **SyN 1 is its own independent [S2] subroutine** and has no DEADLOCK. Breaking [S1] neutralizes both PULP 4 and its attached DEADLOCK; breaking [S3] neutralizes its separate DEADLOCK. Both DEADLOCK effects must be neutralized to BREACH. This definitive layout supersedes both earlier incorrect versions: `[S1] PULP 4 / [S2] SyN 1 / [S3] DEADLOCK` and `[S1] PULP 4 + DEADLOCK / [S2] SyN 1`. WATCHDOG remains base STR 3, with its unchanged CLOAK-triggered +1 STR reactive ability.


## TRAINING-NODE-PLAYTEST-LOCK-001 — Names and existing encounter values locked; implementation phase (2026-11-12)

User confirms **all six ICE names** and **all existing Training Node values** for the playtest. Do not reopen naming or rebalance before actual playtesting. The ICE roster, in left-to-right resolution order, with required display format **NAME — TYPE — STR** and numbered subroutines:

**Layer 1:** WHITE PICKET FENCE — WALL — STR 3: `[S1] PULP 5`; `[S2] DEADLOCK`.

**Layer 2:** TOLLBOOTH — WALL — STR 5: `[S1] TRACE 4`; `[S2] DEADLOCK`. MEATGRINDER — CODE GATE — STR 3: `[S1] PULP 3`; `[S2] PULP 3`; `[S3] DEADLOCK`.

**Layer 3:** OVERCLOCK — CODE GATE — STR 5: `[S1] WATCHDOG gains +1 STR.` HOTWIRE — CODE GATE — STR 3: `[S1] PULP 3`; `[S2] TRACE 3`. WATCHDOG — SENTRY — STR 3: `[S1] PULP 4 + DEADLOCK`; `[S2] SyN 1`; `[S3] DEADLOCK`. WATCHDOG reactive ability: whenever the Rustler plays a CLOAK card, WATCHDOG gains +1 STR for current encounter; stacks.

**CRED reserves by layer:** 10 / 15 / 25 (total base 50); universal rounded-up 10% full-extraction bonuses +1 / +2 / +3, maximum total 56. Existing rules on turns, BW/RAM, 12-card Generalist deck, Icepicks, TRACE, VITAE, damage, extraction, BREACH, and reward resolution remain authoritative.

**Next phase:** Implement an actually playable three-layer training-node prototype in **Godot**, edited/debugged using **Visual Studio**; validate established mechanics through playtesting before changing balance. This is a design freeze for the initial playtest, not a claim that implementation has been completed. Historical references to proposed ICE names/Strength/subroutines are superseded by this lock.

## DOCS-SYNC-001 — Simplified-redesign documents added to the repository (2026-11-13)

The ten approved and proposed documents of the simplified redesign, written in the Claude "Panopticon" project, are now in `docs/`: `REDLINE_CORE_RULES.md` (rules authority since 2026-11-12), `REDLINE_RUSTLERS.md`, `REDLINE_CARD_POOLS.md`, `REDLINE_ICE_CORP1.md` (HALCYON), `REDLINE_ICE_CORP2.md` (IRONWATCH), `REDLINE_ICE_CORP3.md` (LUCIDA), `REDLINE_UPLINK_AND_CAPS.md`, `REDLINE_UPGRADES_EVENTS_ESCAPE.md`, `REDLINE_ENGINES.md` (ENG-001 to ENG-005, mechanics approved in principle, details proposed) and `REDLINE_PLAYTEST_CHECKLIST.md`.

They include NAME-001 (ICE types WALL / CODE GATE / SENTRY renamed FORTRESS / SIGYL / VOID; VOID damage renamed CORTEX; no rules changed) and UPL-009 (JACK OUT works during the escape). Where they conflict with older entries in `REDLINE_MASTER_DESIGN.md`, the Core Rules decide (Core Rules §15). Earlier log entries keep their original names (e.g. WATCHDOG — SENTRY) as history.

## NAME-001 — ICE types and CORTEX damage renamed across the repository (2026-11-13)

To move away from Netrunner's vocabulary, ICE types WALL / CODE GATE / SENTRY are now **FORTRESS / SIGYL / VOID**, and VOID damage is now **CORTEX** (same counters and rules: −1 DRAW per counter, removed between corporations or at a Clinic). VOID ICE are the main source of CORTEX damage, but any ICE can deal it. No rules changed.

Migrated in place: `REDLINE_MASTER_DESIGN.md`, `REDLINE_BIBLE.md` (rule sections only), `REDLINE_CURRENT_STATUS.md`, `PANOPTICON_CORE_DESIGN_AND_WORLDBUILDING.md`, plus all simplified-redesign docs. Rule and decision IDs keep their original names (e.g. TRAINING-THREE-ICE-SENTRY-001). Not migrated, by design: this append-only log (earlier entries keep the old names as history) and `REDLINE_RULE_REVIEW_126.md` (a historical review). In the Bible's world sections, **VOID** stays the in-world name for the erasure of consciousness and CANON verse WL-003 is unchanged; how in-world VOID relates to CORTEX and VOID ICE is **OPEN** for designer review.

## DOCS-SYNC-002 — UI and NUL/REM handoff restored to the repository (2026-11-13)

`REDLINE_UI_NULREM_Design_For_Claude.md` (Claude implementation handoff, 2026-11-07), cited as a source by the Master Design but missing from the repository, is added to `docs/` **verbatim** as a historical source. It predates later rules: its damage types (PHYSICAL / NEURAL / SYNAPTIC), Integrity, Memory, Grip, corporations VANTABLACK and AEGIS, Force Open, Crowbar and "Training Wall" are superseded by the Core Rules and NAME-001. Its NUL/REM personality bible, dialogue-system behaviour, hacker-history anchors and terminal presentation remain the most detailed NUL/REM source; its tonal example lines have not yet been entered in the Bible as verses.

## NULREM-001 — NUL/REM identity canon and verses NR-002 to NR-008 (APPROVED, 2026-11-13)

**Identity (CANON):** NUL/REM is rev 0.08, a salvaged, obsolete personality ROM manufactured in 1987, referred to as "he"; he wants sleep and shutdown but is compelled to protect the Runner. Memories of events before 1987 are the Unreliable Historian's impossible memories; their explanation stays OPEN. Recorded in the Bible (§5) and the Master Design (§7).

**Verses (CANON):** the seven approved tonal examples from `REDLINE_UI_NULREM_Design_For_Claude.md` §6 are entered in the Bible as NR-002 (Deadlock and hope), NR-003 (A lifestyle), NR-004 (Before manufacture), NR-005 (Hot dust), NR-006 (Sufficient room), NR-007 (Paper Cut) and NR-008 (Stationery), with exact wording preserved. Placements are suggestions (OPEN).

## NULREM-002 — Run-start verses NR-009 to NR-018 (APPROVED, 2026-11-13)

First collaborative dialogue pass, trigger EV-01 (Run start) of the NUL/REM Dialogue Trigger Table. Ten lines approved and entered in the Bible as CANON verses NR-009 to NR-018: a general pool (NR-009 to NR-013), after a lost run (NR-014), after a won run (NR-015), and Rustler-specific lines for the Generalist, ECHO and RIOT (NR-016 to NR-018). The VECTOR line is being rewritten to give NUL/REM a strange relationship with germs (he has no body, so he should have none).

## NULREM-003 — VECTOR run-start lines and the germ trait (APPROVED, 2026-11-13)

Three VECTOR run-start lines approved as CANON verses NR-019 to NR-021 (EV-01; one chosen at random). New CANON character trait recorded in the Bible (§5) and Master Design (§7): NUL/REM is fastidious about germs despite having no body or immune system; he worries about biological germs and dust in his casing, stays unbothered by computer viruses, and may claim illnesses he could never have had.

## NULREM-004 — Enter-a-corporation verses NR-022 to NR-035 and the reference compulsion (APPROVED, 2026-11-13)

Trigger EV-03 (Enter a corporation): fourteen longer, exposition-rich lines approved as CANON verses — HALCYON NR-022 to NR-026, IRONWATCH NR-027 to NR-030, LUCIDA NR-031 to NR-035 (one chosen at random from the entered corporation's pool). HALCYON lines reference Orbital's “Halcyon + On + On” (1993). New CANON trait recorded in the Bible (§5) and Master Design (§7): NUL/REM is compelled to reference fictional computers and machine voices (HAL 9000, WALL-E, Number 5, Proteus IV, Impossible Mission's Elvin Atombender, Evilspeak's Apple II), with the signature line “Another visitor. Stay a while. Stayyyyyyy forever!”, and makes silly retro-game references such as “Rustler needs food… badly” at low VITAE. Licensing of quoted lines for a commercial release is OPEN.

## NULREM-005 — IRONWATCH verses NR-036 and NR-037 (APPROVED, 2026-11-13)

Two more EV-03 (Enter a corporation) lines for IRONWATCH's FRONT DESK approved as CANON verses NR-036 and NR-037, referencing Carol Beer's “Computer says no” (*Little Britain*, 2004); NR-037 also uses the germ trait. Carol Beer added to the reference-compulsion trait (Bible §5, Master Design §7). Pools now: HALCYON 5, IRONWATCH 6, LUCIDA 5.

## NULREM-006 — EV-03 verses NR-038 and NR-039 (APPROVED, 2026-11-13)

Two more EV-03 (Enter a corporation) lines approved as CANON verses, both referencing *Columbo*, “Mind Over Mayhem” (1974): NR-038 (IRONWATCH; the K44 war-games computer as a murderer's alibi) and NR-039 (LUCIDA; MM7, the chess robot that threw the board). Both added to the reference-compulsion trait (Bible §5, Master Design §7). Pools now: HALCYON 5, IRONWATCH 7, LUCIDA 6.

## NULREM-007 — EV-03 verses NR-040 to NR-043: Tron and The Black Hole (APPROVED, 2026-11-13)

Four more EV-03 (Enter a corporation) lines approved as CANON verses: NR-040 (HALCYON; Tron's Master Control Program, from chess program to the Pentagon, “End of line.”), NR-041 (IRONWATCH; Tron's Game Grid), NR-042 (LUCIDA; The Black Hole's humanoid crew, restraint rule) and NR-043 (IRONWATCH; Old B.O.B. and Maximilian). Added to the reference-compulsion trait (Bible §5, Master Design §7); NUL/REM identifies with Old B.O.B. Pools now: HALCYON 6, IRONWATCH 9, LUCIDA 7. A further Master Control line is planned for EV-30 (Central Node entry). To verify: “End of line” as the MCP's sign-off.

## NULREM-008 — EV-03 verses NR-044 and NR-045: Marvin (APPROVED, 2026-11-13)

Two final EV-03 (Enter a corporation) lines approved as CANON verses, referencing Marvin the Paranoid Android and Sirius Cybernetics' Genuine People Personalities: NR-044 (HALCYON; the delighted doors) and NR-045 (LUCIDA; the comparison he denies, Marvin's 576 billion years of waiting). Reference-compulsion trait updated (Bible §5, Master Design §7): Marvin is the comparison NUL/REM denies. EV-03 complete with 24 lines: HALCYON 7, IRONWATCH 9, LUCIDA 8.

## NULREM-009 — LOCKDOWN verses NR-046 to NR-050 (APPROVED, 2026-11-13)

Trigger EV-16 (TRACE strike 3: LOCKDOWN): five lines approved as CANON verses NR-046 to NR-050 (Reluctant Guardian and Melancholic; references kept rare at danger moments). NR-049 is a callback to NR-025's Impossible Mission line and should only play once NR-025 has been heard.

## NULREM-010 — Central Node verses NR-051 to NR-059 (APPROVED, 2026-11-13)

Trigger EV-30 (Central Node entry): nine boss-framing lines approved as CANON verses, three per boss, each stating the fight's question from the ICE docs without new mechanics: THE HEARTH NR-051 to NR-053 (NR-052 is the planned Tron Master Control line), OVERWATCH NR-054 to NR-056 (NR-056 references HAL 9000 singing “Daisy Bell”; to verify), ANIMA NR-057 to NR-059.

## NULREM-011 — Payload verses NR-060 to NR-064 and CAP verses NR-065 to NR-068 (APPROVED, 2026-11-13)

Trigger EV-31 (Payload chosen): five lines approved as CANON verses NR-060 to NR-064 (delight at the tech, quickly hidden; no hint of the First Signal fragment content, which stays OPEN). CAP moments: four lines referencing the Cap'n Crunch whistle and 2600 Hz phone phreaking, approved as CANON verses NR-065 (EV-23 JACK OUT used), NR-066 (EV-24 Uplink visit), NR-067 (EV-22 Last CAP used; John Draper) and NR-068 (EV-24, only when Bootleg CAPS are in stock). The whistle is recorded in the reference-compulsion trait (Bible §5) as his model for every CAP.

## NULREM-012 — First Signal payload verses NR-069 to NR-072 (APPROVED, 2026-11-13)

Four more EV-31 (Payload chosen) lines approved as CANON verses that hint at the First Signal under the Ghostware without explaining it: NR-069 (rumour), NR-070 (the unknown employer, RUN-006), NR-071 (the encryption is older than the corporation, possibly older than NUL/REM) and NR-072 (a rhythm in the noise, like a carrier tone). NR-071 and NR-072 hint at NUL/REM's relationship to the First Signal and at the synchronization transmission; both remain **OPEN** and these lines commit to no answer. EV-31 pool: NR-060 to NR-064, NR-069 to NR-072.

## NULREM-013 — Escape verses NR-073 to NR-081 (APPROVED, 2026-11-13)

Trigger EV-32 (Escape begins, TRACE doubled): nine lines approved as CANON verses, three per corporation, naming each corporation's escape ICE and final Black ICE: HALCYON NR-073 to NR-075 (HOUSE CALL; NR-075 notes JACK OUT works during the escape, UPL-009), IRONWATCH NR-076 to NR-078 (LETHAL FORCE; NR-078 references Number 5's escape in Short Circuit), LUCIDA NR-079 to NR-081 (EGO DEATH, restraint rule; NR-081 references WALL-E). The escape is described as three nodes. To verify: the Short Circuit and WALL-E details.

## NULREM-014 — Konami Code and cartridge verses NR-082 to NR-087 (APPROVED, 2026-11-13)

Six lines approved as CANON verses. Konami Code: NR-082 (EV-35 Run lost; Contra's 30 lives), NR-083 (EV-01 Run start after a loss; Kazuhisa Hashimoto) and NR-084 (new trigger **EV-39, Konami Code entered**: dialogue only, the code grants nothing; Gradius III). Blowing on cartridges (the example named in Master Design §7's dialogue guidance): NR-085 (EV-10 Stalled encounter), NR-086 (EV-37 Idle; germ trait) and NR-087 (EV-24 Uplink visit; CAPS are Disposable Autonomous Cartridges, Bible §4). Reference trait updated (Bible §5).

## NULREM-015 — Run-won verses NR-088 to NR-092 (APPROVED, 2026-11-13)

Trigger EV-34 (Run won): five lines approved as CANON verses NR-088 to NR-092 (earned warmth, still dry; no hint of what the three fragments reveal together). NR-092 plays on the first win only (Story beat) and introduces an unnamed date NUL/REM has kept since 1987; its meaning is **OPEN**.

## NULREM-016 — Run-lost verses NR-093 to NR-099 (APPROVED, 2026-11-13)

Trigger EV-35 (Run lost): seven lines approved as CANON verses, loss without mockery: general NR-093, NR-094, NR-098, NR-099; by cause NR-095 (Black ICE), NR-096 (high CORTEX, restraint rule) and NR-097 (TRACE / LOCKDOWN). NR-098 and NR-099 reference R.O.B., the NES Robotic Operating Buddy (two games, then shelved; “Remembered Old Buddy” in Pikmin 2), added to the reference trait as a companion he identifies with. EV-35 pool also includes NR-082 (Konami Code) and WL-003 (high CORTEX only). All eight milestones now have canon lines.

## NULREM-017 — Idle verses NR-100 to NR-102: Tobor (APPROVED, 2026-11-13)

Three EV-37 (Idle) history-aside lines approved as CANON verses mocking Tobor, “robot” spelled backwards: NR-100 (Tobor the Great, 1954), NR-101 (the reversed-stencil story from Captain Video; the Here Comes Tobor pilot credited “Tobor played by Tobor”) and NR-102 (NUL/REM reversed is MER/LUN). Reference trait updated (Bible §5).

## NULREM-018 — Battle of the Planets verses NR-103 to NR-105 (APPROVED, 2026-11-13)

Three lines approved as CANON verses referencing 7-Zark-7, 1-Rover-1 and Susan, added when Gatchaman was cut down into Battle of the Planets (1978): NR-103 (EV-37 Idle), NR-104 (EV-15 Black ICE joins; he won't sanitize danger) and NR-105 (EV-37 Idle; Susan on Pluto). Reference trait updated (Bible §5).

## NULREM-019 — The 1982 trait, the reference style rule, fifteen verse revisions and Jetsons verses NR-106 to NR-109 (APPROVED, 2026-11-13)

**CANON trait:** 1982 is NUL/REM's special year: his memory chips received most of their programming then (before his 1987 manufacture), and his favourite music and films are from that period; he reminisces most about 1982 and 1987. **DIRECTION:** references assume the player knows the work, with no plot summaries and no years other than 1982 and 1987.

**Revisions:** under the Bible's preservation rule, fifteen CANON verses are RETIRED (kept as history) and replaced by v2 versions written to the new style: NR-023, 026, 029, 033, 035, 038, 039, 040, 041, 042, 052, 065, 098, 100 and 103. NR-041 and NR-052 now name 1982 fondly. Placements unchanged.

**New verses:** Jetsons references NR-106 (EV-37 Idle; Rosie), NR-107 (EV-38 Repeated mistake; Uniblab), NR-108 (EV-04 BOOTING; R.U.D.I.) and NR-109 (EV-18 Low VITAE; R.U.D.I.).

## NULREM-020 — The overqualified trait and verses NR-110 to NR-113 (APPROVED, 2026-11-13)

**CANON trait:** NUL/REM considers himself far too sophisticated for his work, though he would rather be doing nothing at all; his superiority over famous machines exists only in his own mind (Bible §5, Master Design §7). **Verses:** NR-110 (EV-37 Idle; Skynet), NR-111 (EV-37 Idle; the T-1000), NR-112 (EV-03 IRONWATCH; RoboCop) and NR-113 (EV-06 DEADLOCK broken; ED-209).

## NULREM-021 — Game Boy and Tetris verses NR-114 to NR-117 (APPROVED, 2026-11-13)

Four lines approved as CANON verses: NR-114 (EV-12 Elegant play; a Tetris), NR-115 (EV-18 Low VITAE; four AA batteries and the dimming power light, to verify), NR-116 (EV-37 Idle; the grey brick, DMG-01, designed from 1987) and NR-117 (EV-21 Bloatware inserted; the wrong pieces stacking up). Reference trait updated (Bible §5).

## NULREM-022 — DMG-01 as an old friend: NR-114 to NR-116 revised (APPROVED, 2026-11-13)

NR-114, NR-115 and NR-116 are RETIRED and replaced by v2 versions in which NUL/REM calls the Game Boy **DMG-01**, as if it were an old friend (Bible §5 updated). Placements unchanged.

## NULREM-023 — Speak & Spell verses NR-118 to NR-120 (APPROVED, 2026-11-13)

Three lines approved as CANON verses: NR-118 (EV-06 DEADLOCK broken; “That. Is. Correct.”), NR-119 (EV-38 Repeated mistake; “That is incorrect”, in his head since 1982) and NR-120 (EV-33 First Signal fragment decrypted, the trigger's first line; E.T.'s Speak & Spell communicator; the Signal's content stays OPEN). Reference trait updated (Bible §5).

## NULREM-024 — Game & Watch and Casio verses NR-121 to NR-124 (APPROVED, 2026-11-13)

Four lines approved as CANON verses: Game & Watch, referenced generically: NR-121 (EV-10 Stalled encounter; Game A / Game B) and NR-122 (EV-37 Idle; the grey ghosts of unlit segments). His Casio calculator watch as an old friend: NR-123 (EV-37 Idle) and NR-124 (EV-09 CRED reserve fully extracted; upside-down calculator words). Reference trait updated (Bible §5).

## NULREM-025 — Kraftwerk Computer World verses NR-125 to NR-129 (APPROVED, 2026-11-13)

Five lines approved as CANON verses referencing Kraftwerk's *Computer World* (1981) by song title and theme, without quoting lyrics (copyright): NR-125 (EV-24 Uplink; “Pocket Calculator” and his Casio), NR-126 (EV-26 RAM gained; “Numbers”), NR-127 (EV-37 Idle; “Computer Love”, played through 1982), NR-128 (EV-03 HALCYON; “Home Computer”) and NR-129 (EV-27 Card reward; “It's More Fun to Compute”). Bible §5 1982 trait updated. **Rule recorded:** song lyrics are never quoted in NUL/REM's lines; titles and themes only.

## NULREM-026 — The 808 clock and verses NR-130 to NR-132 (APPROVED, 2026-11-13)

**CANON detail:** NUL/REM's internal clock plays a Roland TR-808 pattern instead of ticking; it got into his timing chips from Afrika Bambaataa's “Planet Rock” in 1982 (Bible §5). **Verses:** NR-130 (EV-37 Idle; the 808 clock), NR-131 (EV-12 Elegant play; “Boing, boom, tschak”, after the Kraftwerk track) and NR-132 (EV-10 Stalled encounter; the 808 rented for twenty dollars a session).

## NULREM-027 — Little Computer People verses NR-133 and NR-134 (APPROVED, 2026-11-13)

Two lines approved as CANON verses referencing Activision's Little Computer People (Commodore 64): NR-133 (EV-37 Idle; every computer has an occupant) and NR-134 (EV-19 KILLSWITCH fires; the free mail-in revival). Reference trait updated (Bible §5).

## NULREM-028 — BBS and warez verses NR-135 to NR-138 (APPROVED, 2026-11-13)

Four lines approved as CANON verses: NR-135 (EV-04 BOOTING; dialling at 1200 baud, “Nodes don't sing anymore”), NR-136 (EV-13 TRACE reaches 20; the kitchen phone), NR-137 (EV-27 Card reward; upload/download ratios) and NR-138 (EV-24 Uplink; warez boards and cracktros). Reference trait updated (Bible §5).

## NULREM-029 — Demoscene verses NR-139 and NR-140 (APPROVED, 2026-11-13)

Two lines approved as CANON verses: NR-139 (EV-07 BREACH; Amiga demo scrollers, raster bars and greetings) and NR-140 (EV-37 Idle; FairLight, founded 1987 and named after the Fairlight CMI, the instrument behind Planet Rock's orchestra hit). Reference trait updated (Bible §5).

## NULREM-030 — Ferris Bueller verses NR-141 and NR-142 (APPROVED, 2026-11-13)

Two lines approved as CANON verses referencing Ferris Bueller's sampled coughs, played on an E-mu Emulator II (not a Fairlight CMI, which NUL/REM is keen to point out): NR-141 (EV-23 JACK OUT used) and NR-142 (EV-18 Low VITAE).

## NULREM-031 — Ferris Bueller and the germ trait: NR-143 (APPROVED, 2026-11-13)

One EV-37 (Idle) line approved as CANON verse NR-143: NUL/REM leans away from the screen at Ferris Bueller's sampled coughs, knowing they're samples (germ trait).

## NULREM-032 — Batch 2: verses NR-144 to NR-231 across 30 trigger events (APPROVED, 2026-11-13)

88 lines from the review doc “NUL/REM Dialogue — Batch 2 (CANDIDATE)” approved as CANON verses, covering the 30 events that were short. Written to the designer's guidelines: the six modes in rotation; protectiveness toned down, with sleep as his real motive; stolen data at BREACH; CRED inflation jokes; seven Blade Runner references (world, not just characters) including whether androids dream of electric sheep (reference trait updated, Bible §5). New lore in NR-156: personality-ROM revisions 0.01 to 0.07 don't exist (**OPEN** thread). Hints at OPEN story threads in EV-29, EV-33 and EV-36 commit to no answer.

## NULREM-033 — BREACH verses NR-232 to NR-234 (APPROVED, 2026-11-13)

Three EV-07 (BREACH) lines approved as CANON verses referencing the robots of Heartbeeps (1981) without naming the film: NR-232 (the valet and the poolside hostess leaving the factory), NR-233 (the security robot quoting regulations) and NR-234 (the baby robot built from spare parts). BREACH now has 8 of its 15 lines.

## NULREM-034 — EV-05 uses generic lines; per-ICE lines deferred (APPROVED, 2026-11-13)

Designer decision: no bespoke NUL/REM line per ICE for now, because ICE names and abilities will most likely change during playtesting. EV-05 (First sight of an ICE) draws from a generic pool (currently NR-007, NR-008 and NR-161 to NR-164). Its target in the Trigger Table drops from about 45 lines to 8 (fires per run 15, speak 50%, repeat window 1). Per-ICE lines are revisited once the ICE rosters settle.

## NULREM-035 — Original Battlestar Galactica verses NR-235 to NR-239 (APPROVED, 2026-11-13)

Five lines approved as CANON verses referencing the Cylons of the original Battlestar Galactica only (designer direction; no reimagined-series elements such as resurrection or “toasters”): NR-235 (EV-11; the sweeping red eye), NR-236 (EV-08; “By your command”), NR-237 (EV-35; a Command Centurion and the Imperious Leader), NR-238 (EV-37; Lucifer) and NR-239 (EV-37; vocoder voices, with Kraftwerk). Reference trait updated (Bible §5).

## NULREM-036 — Soundwave, Megatron and energon verses NR-240 to NR-245 (APPROVED, 2026-11-13)

Six lines approved as CANON verses referencing the 1980s cartoon without naming the franchise: NR-240 (EV-07 BREACH; “Laserbeak, eject”), NR-241 (EV-09; energon cubes, CRED inflation), NR-242 (EV-24 Uplink; spy cassettes), NR-243 (EV-37 Idle; Megatron's loyal tape deck), NR-244 (EV-15 Black ICE; Megatron) and NR-245 (EV-12 Elegant play; Soundwave's motto). Reference trait updated (Bible §5).

## NULREM-037 — WarGames verses NR-246 to NR-250 (APPROVED, 2026-11-13)

Five lines approved as CANON verses referencing Joshua / WOPR from WarGames: NR-246 (EV-01 Run start; “Shall we play a game?”), NR-247 (EV-05 generic first sight; war dialing), NR-248 (EV-10 Stalled; tic-tac-toe), NR-249 (EV-08 Go deeper or leave; the only winning move, without deciding for the player) and NR-250 (EV-36 Talk between runs; Falken's backdoor password, hinting at his own maker, OPEN). Reference trait updated (Bible §5).

## NULREM-038 — Andromeda Strain verses NR-251 to NR-253 (APPROVED, 2026-11-13)

Three lines approved as CANON verses referencing The Andromeda Strain: NR-251 (EV-37 Idle; a microorganism, not a virus; germ trait), NR-252 (EV-13 TRACE reaches 20; the jammed teletype bell) and NR-253 (EV-28 SAFEHOUSE; four levels of decontamination; germ trait).

## NULREM-039 — D.A.R.Y.L. verses NR-254 to NR-257 (APPROVED, 2026-11-13)

Four lines approved as CANON verses referencing D.A.R.Y.L.: NR-254 (EV-12 Elegant play; Pole Position, a 1982 game), NR-255 (EV-09; the ATM, CRED inflation), NR-256 (EV-36 Talk between runs; Daryl's amnesia against NUL/REM's excess of memory) and NR-257 (EV-23 JACK OUT; the stolen SR-71).

## NULREM-040 — Superman III verses NR-258 to NR-260 (APPROVED, 2026-11-13)

Three lines approved as CANON verses referencing the Ultimate Computer from Superman III: NR-258 (EV-09; Gus Gorman's half cents, CRED inflation), NR-259 (EV-05 generic first sight; the acid rated danger level zero; completes the generic pool at 8 of 8) and NR-260 (EV-37 Idle; Robert Vaughn as Ross Webster and the voice of Proteus IV, linking to NR-026 v2 and NR-035 v2).

## NULREM-041 — Revenge of the Nerds verses NR-261 to NR-263 (APPROVED, 2026-11-13)

Three lines approved as CANON verses referencing how computers are used in Revenge of the Nerds, focused on the engineering rather than the film's mocking framing of Lamar: NR-261 (EV-27 Card reward; the javelin built for Lamar's throw), NR-262 (EV-37 Idle; the computer-driven win) and NR-263 (EV-34 Run won; brains won). A fourth candidate for EV-12 was declined.

## BUILD-001 — Godot build to start anew (APPROVED, 2026-11-13)

Designer decision: the next session focuses on a Godot 4 build. An earlier Godot playtest of the first Node exists, but the new build starts fresh from `REDLINE_CORE_RULES.md` and the simplified-redesign docs, because the game has changed substantially since that playtest. The earlier playtest and the Python/Pygame archive remain reference material only.


## BUILD-002 — Godot 4.3 HALCYON vertical slice (BUILT, 2026-11-13)

First playable of the fresh Godot build (see BUILD-001). Lives in `godot/`; open `godot/project.godot` in Godot 4.3 (GL Compatibility).

- **In:** Generalist with READY RIG; a 4-row HALCYON route (COOKIE BANNER with BOOTING → CAPTCHA or CONSENT WALL → SAFEHOUSE or DOORBELL → TERMS & CONDITIONS, 2 layers); full turn and Corporation Response rules (left→right, top→bottom, cleanup after); DEADLOCK/BREACH; go deeper or leave; reserves with the 10% clean bonus; SPAM; TRACE strikes (TRACER, HOUSE CALL, LOCKDOWN + Black ICE); depth-based card rewards (2 shared + 1 Generalist, 60/30/10 → 30/45/25).
- **Visual cues:** per the ICE Design doc: type icon (FORTRESS slab, SIGYL keyhole, VOID eye), frame = role (MAIN heavy, SUPPORT thin, BLACK ICE inverted red with NO DEADLOCK), effect chip colours (PULP red, CORTEX violet, TRACE amber, DEADLOCK white, teal hand/deck, slate support), HALCYON peach band, large STR top right with base shown when changed, BW break cost on each subroutine, BOOTING T1–T3 pips, numbered Corporation Response preview with totals. All icons are drawn in code (`scripts/ui/icon.gd`).
- **NUL/REM:** speaks CANON Bible lines exported by `tools/export_nulrem.py` → `godot/data/nulrem_lines.json` (re-run after Bible changes). Speak chance per trigger, filters by Rustler/corp/cause, repeat suppression of the last 40. EV-37 idle at 60 s; Konami code → EV-39; first-run flag for EV-02.
- **Out:** CAPS, Uplinks, PATCHWORK, the Central Node, other Rustlers and corporations.
- **Architecture:** rules engine `scripts/core/game.gd` (no UI dependency) + `cards.gd`, `ice.gd`, `nulrem.gd`; UI in `scripts/ui/main.gd`. Headless tests: `godot --headless --path godot --script res://tests/test_game.gd` (50 pass, including a bot that clears the slice). `tests/shot.gd` renders screenshots under a virtual display.
- **Export:** `export_presets.cfg` has a Windows Desktop preset (embedded PCK) writing to `build/` (git-ignored).

## ROT-001 — TUMBLER ICE replace SIGYL; rotating subroutines (APPROVED, 2026-11-13)

Playtest finding: the Rustler had too little to do each turn, so there was little choice and little tension. Designer decision:
- **TUMBLER** replaces the **SIGYL** ICE type (and the SIGYL Icepick becomes the **TUMBLER Icepick**, same stats for now). FORTRESS and VOID are unchanged.
- A TUMBLER has a pool of 1–8 subroutines and fewer **slots**. Only the subroutines in its slots are active. A cheap TUMBLER might have 2 subroutines and 1 slot; an expensive one 6 subroutines and 3 slots.
- **Conveyor rotation:** at the start of each Rustler turn after the first, the window moves one step (slots showing 1-2-3 then show 2-3-4, then 3-4-5, wrapping round). The newly revealed set is what fires in that turn's Corporation Response, so the Rustler only learns the response at the start of their turn.
- **Hidden subroutines** are face-down (the count is shown) and can't be broken. Only subroutines in a slot can be broken.
- **Broken stays broken** for the rest of the encounter, even when it rotates out and back in.
- **BREACH** needs every DEADLOCK on the ICE broken, including ones not yet seen. TUMBLERs carry several DEADLOCKs, so they must be broken as they rotate into view.
- Slice pools (placeholders for playtest): ACCEPT ALL 2 subs/1 slot; REJECT ALL 4/2 (two DEADLOCKs, BOOTING); CONSENT FORM 4/2 (two DEADLOCKs); CAPTCHA 5/2 (two DEADLOCKs).

**Docs to follow:** Core Rules, ICE docs, Card Pools, Master Design and Bible rule sections still say SIGYL and need a pass. No CANON NUL/REM verse mentions SIGYL.

## FIX-001 — DISCARD subroutines resolve at the start of the Rustler's turn (APPROVED, 2026-11-13)

A DISCARD subroutine that fires in the Corporation Response now resolves at the start of the Rustler's next turn, after the draw. (Previously it hit the old hand just before cleanup discarded it anyway.)

## FIX-002 — Boost installed Icepicks; inspect installed cards (APPROVED, 2026-11-13)

Installed Icepicks have a BOOST button in the rig (pay the boost cost for +STR; boosts last until the encounter ends; TOOLBELT makes the first boost each turn free). Hovering or clicking any installed Program or racked Protocol shows its full card.

## TUNE-001 — Deadlier encounters (APPROVED, 2026-11-13)

Encounters weren't deadly enough. Every ICE gets **+1 STR (OPENING)** or **+2 STR (T1 and Black ICE)**, and every ICE **PULP value is ×4/3, rounded up** (applied after the TUMBLER pools were set). Slice values: ACCEPT ALL 4, REJECT ALL 4, COOKIE WALL 5, TERMS OF SERVICE 7, CONSENT FORM 4, CAPTCHA 5, DOORBELL CAM 4, HOUSE CALL 7 (PULP 6). A simple bot that banks spare BW into boosts clears 9 of 30 seeded runs; all 21 deaths are at the final node (TERMS & CONDITIONS).

## VOID-001 — VOID ICE reveal a subroutine each time one first fires (APPROVED, 2026-11-13)

VOID ICE subroutines start face-down. The Corporation Response fires them progressively: response 1 fires subroutine 1 (revealed as it fires), response 2 fires subroutines 1 and 2 (2 revealed), and so on until all fire every response. A revealed subroutine stays revealed for the rest of the encounter. Face-down subroutines can't be broken (same rule as TUMBLERs); a broken one doesn't fire. The response preview shows a hidden firing as "? (hidden)" and adds it to the totals line as a hidden subroutine. Black ICE HOUSE CALL is VOID, so it also reveals one subroutine per response from the moment it joins.

**Fix (same session):** `tools/export_nulrem.py` let a verse with no **Placement:** line (NR-002's "Possible placement (OPEN)") swallow the next verse, so NUL/REM could speak raw markdown and NR-009 was missing. Verses are now matched one at a time, and the exporter refuses any line containing markdown.

## PLAY-001 — The Corporation Response plays out step by step (APPROVED, 2026-11-13, playtest presentation)

For playtests, the Corporation Response lasts at least 5 seconds. Each unbroken subroutine flashes one at a time, in resolution order (left→right, top→bottom), and its effects (VITAE, SHIELD, TRACE, SPAM inserted, and so on) are applied only at the moment it flashes. The response preview marks the subroutine firing now, dims the ones already fired, and counts "Resolving n of m". A VOID subroutine is revealed as it flashes. The time is split evenly across the subroutines (5 s ÷ (count + 1) per step); a response with nothing to fire still takes 5 s. Input is locked until the response finishes.

## VOICE-001 — NUL/REM reads every line aloud (APPROVED, 2026-11-13)

Every NUL/REM line is spoken as it types out. Designer chose, from samples: a clear neural voice rather than a robotic synth, British male, slow and flat for a dry, deadpan delivery, played through an "old speaker" (slightly pitched down, small-speaker band, light overdrive, short cabinet echo) so he still sounds like a machine.

- **Production:** `tools/voice_nulrem.py` renders each exported line to `godot/audio/nulrem/<ID>.ogg` with Kokoro-82M (Apache-2.0, via kokoro-onnx), voice `bm_lewis`, speed 0.85, then the sox effect chain. It re-renders only lines whose spoken text changed (`manifest.json`). Run it after `tools/export_nulrem.py` whenever the Bible's lines change.
- **Pronunciation:** the tool rewrites a speech copy of each line (the on-screen text is unchanged): ALL-CAPS game terms are read as words, and a small table covers names, initials and numbers (NUL/REM → "null rem", VITAE → "vee tie", R.U.D.I. → "Rudy", DMG-01 → "D M G zero one", 0.08 → "zero point zero eight", Halcyon + On + On → "Halcyon and On and On", 1982 → "nineteen eighty two").
- **In game:** the typewriter is paced to the audio. A VOICE ON/OFF button in the NUL/REM panel (or the M key) mutes him; the choice is saved.
- **Rejected:** espeak-ng robot voices (Speak & Spell crunch, ring-mod, metallic): not clear enough. The voice is styled on a deadpan delivery but does not imitate any real person.

## DET-001 — DETAINER: a TUMBLER subtype that drains BW (APPROVED, 2026-11-13)

- About **20% of TUMBLER ICE** carry the subtype **DETAINER**.
- **At most 1 DETAINER per encounter.**
- A DETAINER's **S1 is always −1 BW**: when it fires in a Corporation Response, the Rustler has 1 less BW on their next turn. It fires on the Corporation's first response, so the Rustler loses 1 BW on their 2nd turn. Because a DETAINER is a TUMBLER, the −1 BW rotates away and comes back round; breaking it stops it for the rest of the encounter (broken stays broken).
- **Visuals:** a cyan DETAINER tag after the type; the −1 BW chip uses the BW colour and icon ("−1 BW next turn"); the response preview adds "BW −1 next turn"; on the drained turn the HUD shows "−1 DETAINED" beside the BW pips.
- **Slice:** ACCEPT ALL (COOKIE BANNER, the node every run passes through) is the DETAINER. Pool: −1 BW, SPAM, PULP 3 in 1 slot. It is 1 of the slice's 4 TUMBLERs.
- With the DETAINER, a simple bot clears 13 of 30 seeded runs (all deaths still at TERMS & CONDITIONS).

## PULP-001 — FORTRESSES carry PULP, with varied values (APPROVED, 2026-11-13)

Playtest: the slice had about half the PULP subroutines the designer expected, and too few real decisions ("the player did what they could, not what they should"). FORTRESSES now carry PULP, with values that differ from ICE to ICE (working range 1–5, fixed per subroutine so the Rustler can plan):
- **COOKIE WALL** (STR 5): [S1] PULP 2 · [S2] TRACE 2 · [S3] DEADLOCK
- **TERMS OF SERVICE** (STR 7): [S1] PULP 5 · [S2] INSERT 1 SPAM → discard pile · [S3] DEADLOCK
- **AUTO-RENEW** (new FORTRESS, T1, STR 4): [S1] PULP 1 · [S2] PULP 2 · [S3] PULP 3 · [S4] DEADLOCK — escalating, like a subscription that creeps up. Joins CAPTCHA as the support ICE in the row-2 CAPTCHA node.
- Non-Black PULP subroutines in the slice: 4 → 9. A simple bot clears 12 of 30 seeded runs, and deaths now spread across the route (TERMS & CONDITIONS 15, CAPTCHA 2, DOORBELL 1); survivors finish with 5–28 VITAE.
- **Assumption to confirm:** values are fixed per subroutine, not rolled each time.

## ICEBIBLE-001 — ICE type identities (APPROVED, 2026-11-13); passive abilities kept for consideration

Designer decisions, recorded in the new **ICE Rules Bible** doc (https://claude.ai/artifact/DnSnz3Pfgqqvd7nkwuBsdc):
- **FORTRESS:** generally the highest STR; fewer subroutines, almost all PULP; the odd other effect; TRACE rare.
- **TUMBLER:** where the quirks and puzzles happen.
- **VOID:** where the deadly happens.

The bible also holds PROPOSED STR/subroutine budgets per type and tier, general ICE practices ("should, not could"), and an audit of the slice ICE (4 of 9 fit; DOORBELL CAM, CAPTCHA and AUTO-RENEW need changes). No ICE changed yet.

All 14 proposed passive abilities are kept for consideration in the **Ice Passive Abilities** doc (https://claude.ai/artifact/6dDZTwDj8Hv9RkhJbucrd6): power ranking (1–5) with a budget cost scale, what each could break and its guardrail, combinations to forbid, and a suggested first playtest set (AUTO-RENEW HARDENING, COOKIE WALL TOLL, CONSENT FORM RELAY, TERMS OF SERVICE SEQUENCED). ALARM's threshold moved to TRACE 30, because strike 1 resets TRACE to 20.

## PASSIVE-001 — Subtypes and passive abilities on the slice ICE (BUILT for playtest, 2026-11-13)

Each slice ICE gets the subtype and one passive from the Ice Passive Abilities doc:

| ICE | Type · subtype | Passive |
|---|---|---|
| ACCEPT ALL | TUMBLER · DETAINER | — (the DETAINER's −1 BW only; the encounter already has BOOTING) |
| REJECT ALL | TUMBLER | BOOTING (unchanged) |
| COOKIE WALL | FORTRESS · TOLLHOUSE | TOLL: breaks cost +1 BW, except the DEADLOCK |
| TERMS OF SERVICE | FORTRESS · VAULT | SEQUENCED: break left to right |
| AUTO-RENEW | FORTRESS · RATCHET | HARDENING: +1 STR after each response (max +3) |
| CONSENT FORM | TUMBLER · SWITCHBOARD | RELAY: ICE to its right +2 STR while it has an unbroken subroutine |
| CAPTCHA | TUMBLER · SNARE | TRIPWIRE: each break adds TRACE 1 |
| DOORBELL CAM | VOID · WATCHER | WATCHER (was its CLOAK → TRACE ability) |
| HOUSE CALL | Black VOID | none (Black ICE get no passives) |

All pass the doc's guardrails (max 2 passive ICE per encounter; no TOLL with the DETAINER; no HARDENING beside RELAY or BOOTING). Ice stats unchanged; the ICE Rules Bible audit changes are not applied yet.

**30-run bot test (same seeds 100–129, random routes):**

| | Before passives (PULP-001) | With passives |
|---|---|---|
| Runs cleared | 12 / 30 | 11 / 30 |
| Deaths: CAPTCHA node | 2 | 8 |
| Deaths: DOORBELL node | 1 | 1 |
| Deaths: TERMS & CONDITIONS | 15 | 10 |
| Survivors' average end VITAE | 17.8 | 14.0 |

Reading: the CAPTCHA node (AUTO-RENEW HARDENING + CAPTCHA TRIPWIRE) became the new danger spot; runs that get past it reach the end with less VITAE. The bot doesn't play around passives (it breaks TRIPWIRE subroutines freely and ignores RELAY order), so a human should do better than these numbers.

## BUILD-003 — All four Rustlers in the HALCYON slice (BUILT for playtest, 2026-11-14)

The slice now starts with a Rustler choice: THE GENERALIST, ECHO, RIOT or VECTOR, built from `REDLINE_RUSTLERS.md` and `REDLINE_CARD_POOLS.md` §5–7 (SIGYL read as TUMBLER since ROT-001, so HUSH and WRECKING BALL are TUMBLER Icepicks).

- **ORIGIN Ghostware:** READY RIG (Generalist only); LOW PROFILE (ECHO: every TRACE gain is 1 less); REDLINER (RIOT: +1 BW at the start of your turn at TRACE 20+); PATIENT ZERO (VECTOR: 1 ROT on every ICE at the start of each encounter).
- **Starter decks** (12 each) and **reward pools** (9 each; the reward's third card comes from the chosen Rustler's pool). INCUBATOR is left out of the slice pool because no slice ICE PURGEs.
- **Virus strains** (RUSTLER-002): ROT (−1 STR), SCRAMBLE (PULP −1 when it acts), BLIND (TRACE −1 when it acts), LEECH (1 CRED at the start of your turn), WORM. Counters show as coloured chips on the ICE card. **Interpretation to confirm:** WORM *copies* 1 counter of each strain to the ICE on the right (the doc says "put … onto", which could mean move).
- **Card breaks:** BACKDOOR, BRUTE FORCE, RUNTIME ERROR and HOST TAKEOVER let you pick a subroutine; FLASHPOINT auto-picks (DEADLOCK first, then the biggest PULP). Card breaks obey hidden subroutines, BOOTING and SEQUENCED, and trigger TRIPWIRE; TOLL applies to Icepick breaks only.
- **Other new rules:** CACHE (DEAD AIR), SMOKESCREEN, VANISH, BLACKOUT, DECOY SIGNAL, SILENT PARTNER, LONG GAME, BERSERK cost reduction, PAIN TOLERANCE, per-break TRACE (SLEDGE, WRECKING BALL, CHAINSAW) and per-break ROT (STINGER).
- **Fix found by the RIOT simulation:** a break that adds TRACE could cause strike 2, which pushes HOUSE CALL in on the left and shifted every ICE index mid-break. Breaks are now recorded before their TRACE is applied.
- NUL/REM's Rustler-specific lines now follow the chosen Rustler.

**30-run bot test per Rustler** (seeds 100–129, random routes; the bot now spends card breaks first, avoids useless STR cuts and sheds TRACE near a strike):

| Rustler | Cleared | Deaths by node | Survivors' avg end VITAE |
|---|---|---|---|
| ECHO | 23 / 30 | CAPTCHA 4, DOORBELL 3 | 14.7 |
| GENERALIST | 10 / 30 | T&C 11, DOORBELL 5, CAPTCHA 3, CONSENT WALL 1 | 18.9 |
| VECTOR | 9 / 30 | CAPTCHA 10, DOORBELL 7, T&C 4 | 14.1 |
| RIOT | 1 / 30 | CAPTCHA 15, T&C 6, COOKIE BANNER 3, CONSENT WALL 3, DOORBELL 2 | 9.0 |

**Design findings for playtest:**
- HALCYON is TUMBLER-heavy (4 of the slice's 8 non-Black ICE). ECHO's HUSH is a TUMBLER Icepick and LOW PROFILE erases the many small TRACE subroutines, so ECHO is far ahead. RIOT and VECTOR each have **one** card that gets through a TUMBLER (BRUTE FORCE, RUNTIME ERROR) and struggle.
- RIOT's TRACE climbs fast enough to reach strike 2 (HOUSE CALL) in the CAPTCHA node, where TRIPWIRE adds TRACE on every break.
- OUTBREAK + REPLICATOR grow ROT without limit (a traced run reached ROT 385). Harmless while STR floors at 0, but anything that counts virus counters (QUARANTINE caps at 6, HOST TAKEOVER needs 5) becomes trivial.
- The Rustlers doc still says SIGYL in places; it needs the TUMBLER rename pass.

## PURGE-001 — The corporation PURGES virus counters at a rising limit (APPROVED, 2026-11-14)

- At the start of its turn, the corporation adds up the virus counters on every ICE in the encounter. At or above its **PURGE limit**, it removes them all **instead of taking its turn**, and the Rustler's turn begins.
- **HALCYON: limit 10, +5 after each purge** (10 → 15 → 20), reset each encounter.
- **No meter and no preview warning (designer: it should be a surprise).** The purge is announced only as it happens, during the Corporation Response playback.
- A purge isn't a Corporation Response: TUMBLERs still rotate (the Rustler's turn starts), but VOID ICE reveal nothing new and HARDENING doesn't grow (BLACKOUT now follows the same rule).
- **INCUBATOR** returns to VECTOR's reward pool: after a purge it INFECTs 2 ROT on each purged ICE.
- **30-run bot test, VECTOR:** 12 / 30 cleared (9 before), with 60 purges across 29 of the 30 runs (about 2 per run). A purge removes VECTOR's ROT but also skips a whole turn of damage; for now the skipped turn is worth more. The bot doesn't trigger purges on purpose, so a player who learns the limit could do so deliberately. If that shows up in playtest, the fallback options are: every ICE gets +1 STR after a purge, or purge-then-respond.

## UI-002 — Encounter CRED meter (APPROVED, 2026-11-14)

Each encounter shows a CRED meter in the info bar: a gold bar with "left / total CRED" for that encounter's reserve. At 0 remaining, the number shows in red (for now).

## ECHO-001 — ECHO's starter deck: 3 PROBE, 3 PULP Shield (APPROVED, 2026-11-14)

- **Out of the starter deck, into ECHO's reward pool:** SLOW DRIP and GHOST SIGNAL (both Common in the pool, so ECHO's pool is now 11 cards).
- **In:** a 3rd PROBE and a 3rd PULP Shield. Deck stays at 12: HUSH, BACKDOOR, Basic Extractor, PROBE ×3, PULP Shield ×3, SMOKESCREEN ×2, DEAD AIR.
- **Exception noted:** GHOST SIGNAL is a shared basic; offering it as a reward breaks BASIC-001 ("basics are never offered"). Accepted for ECHO's pool only; the other Rustlers never see it as a reward.
- **Assumption to confirm:** both cards sit at Common rarity in the pool.
- **30-run bot test, ECHO:** 22 / 30 cleared (23 before); survivors' average end VITAE 18.7 (14.7 before). `REDLINE_RUSTLERS.md` §4 updated.

## ECHO-002 — HUSH starts at STR 1 (APPROVED, 2026-11-14)

HUSH (ECHO's TUMBLER Icepick): STR 3 → **1**; boost (2 BW → +1 STR) and break (1 BW) unchanged. 30-run bot test, ECHO: **23 / 30** cleared (22 after ECHO-001), survivors' average end VITAE 16.5 (18.7). The lower STR barely moved the result: boosts last the whole encounter and ECHO now has 3 PROBEs, so the extra cost is paid once per encounter, and LOW PROFILE keeps TRACE low while ECHO takes the extra turns.

## ECHO-003 — GHOST SIGNAL back in ECHO's starter deck; one SMOKESCREEN out (APPROVED, 2026-11-14)

GHOST SIGNAL is a shared basic, so it returns to ECHO's starter deck and leaves ECHO's reward pool (BASIC-001 holds again; the ECHO-001 exception is withdrawn). SLOW DRIP stays in the pool (Common).

**Card removed in its place: one SMOKESCREEN** (designer asked Claude to choose). Reason: SMOKESCREEN and GHOST SIGNAL do the same job (cut the first TRACE of the next Corporation Response), and ECHO's TRACE control is what makes it the strongest Rustler. Tested both candidates on the 30-run bot: without a SMOKESCREEN, ECHO clears **20 / 30**; without DEAD AIR, 22 / 30. DEAD AIR also stays because CACHING BACKDOOR is ECHO's signature play (and the bot under-uses it).

**ECHO's starter deck now:** HUSH, BACKDOOR, Basic Extractor, PROBE ×3, PULP Shield ×3, SMOKESCREEN, DEAD AIR, GHOST SIGNAL.

## ECHO-004 — HUSH starts at STR 0 (APPROVED, 2026-11-14)

HUSH: STR 1 → **0** (boost 2 BW → +1 STR, break 1 BW unchanged). 30-run bot test, ECHO: **14 / 30** cleared (20 at STR 1); deaths CAPTCHA 8, DOORBELL 5, TERMS & CONDITIONS 3; survivors' average end VITAE 16.4. Against STR 4–5 TUMBLERs, HUSH now needs 8–10 BW of boosts before its first break, which puts ECHO level with VECTOR (12) and the Generalist (10), matching its 2-star difficulty.

## GHOST-011 — BURNOUT CHIP's drawback doubled (APPROVED, 2026-11-14)

BURNOUT CHIP (general Ghostware, drawback): Icepicks +2 STR for the run; **whenever you take PULP damage, take 2 more** (was 1 more). `REDLINE_UPGRADES_EVENTS_ESCAPE.md` §2.2 updated. Not yet in the slice (Ghostware isn't built).

## RIOT-001 — WITHDRAWN (2026-11-14)

The designer kept FEEDBACK in RIOT's starter deck and declined a second BRUTE FORCE. RIOT's deck is unchanged: SLEDGE, BRUTE FORCE, OVERLOAD ×2, PROBE, FEEDBACK, ADRENAL SPIKE, PULP Shield ×2, LAY LOW, SMASH & GRAB, Basic Extractor (30-run bot: 1 / 30). Tested variants for reference: FEEDBACK → 2nd BRUTE FORCE 10 / 30; BRUTE FORCE reaching STR 5: 0 / 30; ADRENAL SPIKE → 2nd LAY LOW: 3 / 30.

Clarified (no change): SLEDGE's first break each turn costs 0 BW, later breaks 1 BW each, and every break (including the free one) adds +1 TRACE.

## RIOT-002 — RIOT at 15 cards with SHATTER (BUILT for playtest, 2026-11-14)

Designer's proposal, built as specified:
- **SHATTER** (new RIOT starter SCRIPT, EXPLOIT): **0 BW, +5 TRACE.** Play only if an Icepick broke a subroutine on an ICE above STR 2 this turn. Break up to 2 subroutines on an ICE at STR 0. (Card breaks still respect hidden subroutines, BOOTING and SEQUENCED.)
- **Deck 12 → 15:** +1 SHATTER, +2 PROBE, +1 PULP Shield, −1 OVERLOAD. Now: SLEDGE, BRUTE FORCE, SHATTER, OVERLOAD, PROBE ×3, FEEDBACK, ADRENAL SPIKE, PULP Shield ×3, LAY LOW, SMASH & GRAB, Basic Extractor.
- **Fix found while building:** a card's own TRACE cost can cause a strike that adds HOUSE CALL on the left; the card's target now follows the same ICE.

**30-run bot test (RIOT):** 1 / 30 cleared (unchanged); **SHATTER was playable only once in 30 runs.** Why: SLEDGE is RIOT's only Icepick and breaks only FORTRESSES, so the condition needs a FORTRESS in the encounter. 4 of the slice's 7 encounters have none (including the Opening Node), and where there is one, the same turn must also see SLEDGE installed and boosted, another ICE already at STR 0, and SHATTER in hand.

Variants tested (not adopted, for discussion):

| SHATTER variant | Cleared | SHATTER played |
|---|---|---|
| As specified (0 BW) | 1 / 30 | 1 time |
| Any break (Icepick or card, e.g. BRUTE FORCE) on an ICE above STR 2 counts | 1 / 30 | 5 times |
| Targets an ICE at STR 2 or less | 1 / 30 | 2 times |
| Both of the above | 1 / 30 | 8 times |
| Condition is TRACE 20–39 instead | 3 / 30 | 49 times |
| TRACE 20–39, targets STR 2 or less | 3 / 30 | 53 times |

Even when SHATTER fires often, its +5 TRACE pushes RIOT from the redline into strike 1–2 (HOUSE CALL). For comparison, OVERDRIVE (SLEDGE breaks any ICE type while TRACE is 20–39) reached 7–9 / 30.

## RIOT-003 — SHATTER redesigned (BUILT for playtest, 2026-11-14)

**SHATTER** (RIOT starter SCRIPT, EXPLOIT): **1 BW, +3 TRACE.** Choose an ICE: this turn, SLEDGE can break that ICE's subroutines whatever its type. At the end of your turn, SLEDGE drops to STR 0 for the rest of the encounter (its boosts are lost; boosting again starts from 0). Replaces RIOT-002's SHATTER. **Interpretations to confirm:** "any 1 icebreaker" read as any 1 ICE; "reduced to 0" lasts until the encounter ends (SLEDGE is back to STR 2 next encounter).

**30-run bot test (RIOT, 15-card deck):** 2 / 30 cleared; SHATTER played 30 times in 17 runs; deaths CAPTCHA 10, DOORBELL 6, COOKIE BANNER 5, T&C 5, CONSENT WALL 2. With a milder price (SLEDGE only loses its boosts, back to STR 2): 3 / 30.

Why it's still low: one SHATTER in 15 cards is drawn about one turn in three, and each play usually buys one or two breaks (SLEDGE needs 2–3 boosts to reach a STR 4–5 TUMBLER), after which SLEDGE starts again from 0.
