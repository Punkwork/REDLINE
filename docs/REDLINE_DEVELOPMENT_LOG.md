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


## RULE-128 — SyN overflow BURN classification and triggers (LOCKED, 2026-11-11)

**Explicit user approval:** BURN generated by SyN overflow under RULE-126/127 is **ordinary BURN damage** for all mechanical purposes, not a fourth damage type. After SyN prevention and mandatory Runner-selected discard, each unfulfilled SyN point generates **2 BURN**; resolve that BURN against the shared BURN prevention pool, and reduce **Vitae (VIT)** only by the unprevented remainder.

**Source-neutral application (explicit choice):** BURN prevention and BURN-related effects apply to overflow BURN **regardless of the damage's source**, even where an effect describes a particular source (for example, “prevent BURN from ICE”). For RULE-128 interactions, source descriptors do **not** exclude SyN-overflow BURN. This explicit exception supersedes the source-restriction option in the draft proposal; it does not change the distinction between damage types or permit other damage types to use BURN prevention.

**Trigger rule (explicit choice):** Only **actual BURN suffered**—the positive reduction of Vitae after prevention—counts for BURN-damage triggers. Merely generating, proposing, or fully preventing BURN **does not** trigger BURN-damage abilities. Effects requiring “when you suffer BURN” require **at least 1 VIT lost**. Do not introduce a separate “BURN generated” trigger category under RULE-128. Effects expressly referring to prevention itself are outside this BURN-damage-trigger rule and retain their printed conditions; their general timing remains governed by existing trigger rules.

**Examples:** SyN overflow generates 4 BURN, prevention 3 → suffer 1 BURN, lose 1 VIT, suffered-BURN trigger may fire. Overflow 6, prevention 6 → suffer 0 BURN, lose 0 VIT, no suffered-BURN trigger. Overflow 4, prevention 0 → suffer 4 BURN, lose 4 VIT. A source-described BURN prevention effect is eligible against overflow BURN under this rule.

**Compatibility:** RULE-127's order and compulsory discard remain unchanged. Three independent prevention pools (DMG-002), temporary prevention expiration (SOFT-013), and prohibition on reactive Runner card play during Corporation turns (SOFT-011) remain unchanged. **CHAR** is in-world slang only; **BURN** is the official mechanical term. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-129 — Simultaneous mixed damage resolution (LOCKED, 2026-11-11)

**Explicit user approval:** When **one effect** inflicts two or more of the three damage types, resolve its damage components in the **fixed order BURN → SyN → VOID**, regardless of the effect's controller or the printed order of the listed damage types. Treat the mixed-damage instruction as one uninterrupted resolving effect for trigger-queue timing, with components processed sequentially against the updated game state.

1. **BURN component:** Spend applicable BURN prevention from the existing BURN pool; unprevented BURN reduces **Vitae (VIT)**. If VIT reaches zero, the run **ends immediately in defeat**. Stop; do not process remaining damage components or queued triggers.
2. **SyN component:** Apply SyN prevention, then the Runner **MUST choose and discard** as many cards as possible up to unprevented SyN (RULE-127). Each missing discard generates **2 BURN** (RULE-126); resolve this overflow BURN immediately as part of the SyN component against the then-current BURN prevention pool. Only BURN actually suffered reduces VIT or qualifies for suffered-BURN triggers (RULE-128). If VIT reaches zero, immediately end the run; do not process VOID or queued triggers.
3. **VOID component:** Apply VOID prevention from its separate pool; resolve remaining VOID as persistent DRAW reduction subject to the established DRAW floor. VOID does not retroactively change cards already drawn.

**Triggers:** Damage-, discard-, and prevention-generated triggered effects are **queued as they arise**, not resolved between the mixed-damage components. Finish the entire mixed-damage effect before resolving its queued triggers under **RULE-014/015** (FIFO), with simultaneous enqueue priority under **RULE-011/012/013**. If immediate defeat occurs, the run ends and queued triggers do **not** resolve. Do not confuse this fixed *damage-component* order with the existing controller-selected order for separate simultaneous triggered effects; RULE-011/012 remain in force for those effects. The normal printed-order rule (RULE-010) still applies to other instructions and distinct effects; RULE-129 specifically overrides printed order for mixed damage components within one effect.

**Prevention and source:** BURN, SyN, and VOID retain their independent prevention pools (DMG-002). SyN overflow BURN uses the BURN pool and the source-neutral application and suffered-only trigger conditions of RULE-128. No reactive Runner card plays during the Corporation turn (SOFT-011).

**Example:** One ICE subroutine inflicts BURN 3 + SyN 3 + VOID 2. Runner has 10 VIT, 2 cards in hand, BURN prevention 1, no SyN/VOID prevention. Resolve BURN 3: prevent 1, lose 2 VIT (8 remain). Resolve SyN 3: mandatory discard 2, shortfall 1 generates 2 BURN; no BURN prevention remains, lose 2 VIT (6 remain). Resolve VOID 2: apply 2 persistent VOID counters. Queue generated triggers during these steps; resolve after the mixed-damage effect completes, if the run survives.

**Defeat precedence:** Reaffirms RULE-RT-002's immediate run defeat at zero Vitae; no later damage, advancement, or queued recovery may reverse defeat. **Status: LOCKED, explicitly approved 2026-11-11.**


### RULE-129 amendment — reversed fixed damage order (LOCKED, 2026-11-11)

**Explicit user revision supersedes the original RULE-129 ordering:** When one effect inflicts multiple damage types, the fixed component order is now **VOID → SyN → BURN**, regardless of controller or printed damage-type order. Any earlier RULE-129 statement of **BURN → SyN → VOID** is superseded and must not be used as the current resolution sequence.

1. **VOID first:** Apply VOID prevention and then persistent DRAW reduction under the established DRAW floor; no retroactive change to cards already drawn.
2. **SyN second:** Apply SyN prevention, mandatory Runner-selected discards, and immediately resolve any resulting **overflow BURN** using the current BURN prevention pool (RULE-126/127/128). Check for immediate defeat after any VIT reduction.
3. **Direct BURN last:** Apply remaining BURN prevention to the effect's direct BURN component; unprevented BURN reduces Vitae (VIT). Check immediate defeat.

**Triggers and defeat unchanged:** Queue damage/discard/prevention triggers until the complete mixed-damage effect finishes (RULE-014/015/129), unless VIT reaches zero, which ends the run immediately and cancels unresolved components and queued triggers (RULE-RT-002). This ordering is fixed, not dynamically optimized or re-sorted by outcome. Reversing component order does not intrinsically increase numerical damage: VOID does not reduce the current hand, and BURN prevention is still consumed by eligible damage in resolution order.

**Revised example:** One effect inflicts BURN 3 + SyN 3 + VOID 2; Runner starts at 10 VIT, 2 cards in hand, BURN prevention 1, no SyN/VOID prevention. First apply VOID 2. Next SyN 3 forces discard of both cards and generates 2 overflow BURN; prevent 1, suffer 1 (9 VIT). Finally direct BURN 3 is unprevented (6 VIT). Queue eligible triggers until all components finish.


## VOID damage enhancement — LOCKED (2026-11-11)

**Explicit user approval:** For each point of **unprevented VOID damage**, the Runner **(1) gains one persistent VOID counter** reducing future normal DRAW by 1 (subject to the established effective DRAW floor of 1), and **(2) must choose and discard one card from their current hand if available**. If a required card is unavailable, **each missing discard generates 5 BURN damage**. Apply the existing BURN prevention pool to this overflow BURN; only unprevented BURN reduces Vitae (VIT) and counts as BURN suffered (RULE-128). The Runner cannot elect to keep available cards and take overflow damage instead.

**Both consequences apply:** A VOID counter is gained **even when no card is available to discard and the 5 BURN overflow occurs**. VOID prevention is applied first; only unprevented VOID generates counters, required discards, and overflow. VOID overflow BURN is ordinary BURN under RULE-128, including its source-neutral prevention and suffered-only trigger semantics. Check immediate defeat whenever VIT is reduced to zero; unresolved instructions and pending triggers stop (RULE-RT-002).

**Mixed damage interaction:** RULE-129's current fixed order remains **VOID → SyN → BURN**. Resolve VOID's mandatory discards and overflow BURN within the VOID component before moving to SyN; this may leave fewer cards available for SyN and cause its separate **2 BURN per missing discard** overflow (RULE-126/127). Resolve direct BURN last. Damage/discard-generated triggers queue until the full mixed-damage effect completes, unless immediate defeat ends the run (RULE-014/015/129). Independent VOID, SyN and BURN prevention pools remain in effect.

**Example:** VOID 2 against a hand of 0, with no VOID or BURN prevention: gain 2 VOID counters, generate 10 BURN, and suffer up to 10 VIT loss (or immediate defeat upon reaching 0). VOID 2 against a hand of 1: gain 2 VOID counters, discard the 1 card, generate 5 BURN before prevention. A mixed effect of VOID 2 + SyN 2 against a hand of 2 first discards both cards and gains 2 VOID counters, then SyN 2 has a shortfall of 2 and generates 4 BURN before prevention.

**Priority:** This approved enhancement supersedes older descriptions that define VOID only as persistent DRAW reduction. No new ordinary-card VOID-counter removal is authorized; existing specialized network recovery and inter-corporation clearing remain unchanged.


## RULE-130 — Fatal damage, pending effects, and partial resolution (LOCKED, 2026-11-11)

**Explicit user approval:** Check Runner Vitae (VIT) **immediately after every actual VIT reduction**, including direct BURN and BURN generated by SyN or VOID shortfall. Apply eligible BURN prevention first. If VIT reaches **0**, the run **immediately ends in defeat**; do not wait for the end of the damage component, card, ICE subroutine, mixed-damage effect, turn, or trigger queue.

**Pending recovery cannot reverse defeat:** No already-queued trigger, later instruction, pending recovery/heal, or future action resolves after defeat, even if it could restore Vitae. A recovery effect that **fully resolved before** the lethal VIT reduction counts normally. A damage-suffered trigger does not interrupt its originating effect; it remains queued per RULE-014/015 and cannot rescue the Runner after lethal damage. This rule creates **no last-chance recovery exception**.

**Partial resolution is not rolled back:** Preserve all changes from instructions and components **already completed before defeat**, including spent prevention, mandatory discards, gained VOID counters, and earlier damage. **Cancel all remaining unresolved instructions, damage components, and queued triggered effects**. Do not roll back completed changes or continue resolving effects after defeat. This is a terminal game-state record, not permission to resume the run.

**Compatibility and priority:** Reaffirms **RULE-RT-002** (immediate defeat), **RULE-014/015** (deferred FIFO triggers), **RULE-127/128** (SyN shortfall and actual BURN suffered), and **RULE-129** (current fixed mixed-damage order **VOID → SyN → BURN**, with VOID's mandatory discard and **5 BURN per missing discard** enhancement). Each type's prevention remains separate, with overflow BURN consuming eligible BURN prevention. Defeat takes priority over queued recovery and over the instruction to complete the mixed-damage event before processing queued triggers. This clarification does not alter controller ordering of simultaneous triggers (RULE-011/012/013) or permit reactive Runner card plays (SOFT-011).

**Example:** Runner has **6 VIT**, **0 cards** in hand, and **no prevention**. VOID 2 first grants **2 persistent VOID counters**, requires 2 discards, and generates **10 BURN** for the 2 missing cards. Upon lethal VIT loss, defeat is immediate. The completed VOID counters and other completed changes remain recorded; subsequent SyN or direct BURN components, later instructions, and queued recovery triggers never resolve.

**Status: LOCKED — explicitly approved 2026-11-11.**


## RULE-131 — Mandatory prevention consumption, immediate overflow, and detailed accounting (LOCKED, 2026-11-11)

**Explicit user approval:** Eligible damage prevention is **automatic and mandatory**. At each actual damage application, the engine consumes applicable prevention immediately; the Runner cannot decline or withhold eligible prevention to save it for a later component or source. BURN, SyN, and VOID have **independent type-specific numerical pools** (DMG-002); only prevention eligible for the incoming damage type may be spent. The displayed pooled value is backed by source/duration accounting.

**Consumption order (RULE-004/005/006):** Within a type-specific pool, consume eligible contributions in the priority already established by RULE-004/005 (earliest expiration first), with the existing RULE-006 equal-expiration tie-breaker. RULE-131 creates **no new source priority**, no player-selected prevention withholding, and no cross-type spending. Record each source contribution consumed and its remaining value.

**Overflow timing and order:** Under the current RULE-129 fixed mixed-damage order **VOID → SyN → BURN**, complete each component before proceeding to the next. For unprevented VOID, apply its persistent counters and mandatory Runner-selected hand discards; each missing discard generates **5 ordinary BURN**. **Immediately resolve that overflow BURN within the VOID component**, automatically consuming then-eligible BURN prevention. Next, for unprevented SyN, perform mandatory Runner-selected discards; each missing discard generates **2 ordinary BURN**, likewise immediately resolved within the SyN component using the BURN pool remaining at that moment (RULE-126/127). Finally, apply any direct BURN component against the remaining BURN prevention. The Runner cannot defer or pool overflow BURN until the final direct BURN component. VOID and SyN prevention are applied before determining their respective unprevented damage and overflow. Source-neutral BURN prevention and suffered-only BURN triggers remain as locked by RULE-128.

**Defeat and triggers:** After prevention, if an actual BURN application reduces Vitae (VIT) to zero, defeat is immediate (RULE-RT-002/RULE-130). Preserve completed changes, cancel unresolved damage components/instructions and pending triggers; no queued recovery can reverse defeat. Otherwise, triggers generated by damage, discards, or prevention are enqueued during resolution and resolve only after the containing mixed-damage effect completes, under RULE-014/015 and RULE-129. This rule does not authorize reactive Runner card plays during the Corporation turn (SOFT-011).

**Mandatory UI and log accounting:** For each damage application, show the **damage source and type**, incoming amount, prevention consumed **broken down by contributing source and duration**, each type-specific pool's remaining amount, unprevented VOID/SyN, mandatory discards completed and shortfalls, **overflow BURN generated and immediately prevented**, **actual BURN suffered**, resulting VIT change, and persistent VOID counters gained. Preserve the step-by-step order in the action log; show when lethal defeat truncates further resolution. These are interface/reporting requirements, not new trigger events.

**Canonical example:** One effect inflicts VOID 2 + SyN 2 + direct BURN 3 against a Runner with **10 VIT, 1 card in hand, 4 BURN prevention, and no VOID or SyN prevention**. VOID 2 adds two counters, discards the one card, and generates 5 BURN for the one missing discard; automatically spend 4 BURN prevention and suffer 1 BURN (VIT 9). SyN 2 has no cards to discard, generates 4 BURN and suffers 4 (VIT 5). Direct BURN 3 suffers 3 (VIT 2). All generated triggers queue until the effect completes unless defeat intervenes.

**Status: LOCKED — explicitly approved 2026-11-11.**


## RULE-132 — Post-Corporation hand cleanup and defensive hand retention (LOCKED, 2026-11-11)

**Explicit user approval:** Ordinary unplayed cards **remain in the Runner's hand through the Corporation Response Phase** and are available for mandatory damage discards. Move routine non-CACHED hand cleanup **after the entire Corporation response and its queued triggers**, before beginning the next Runner turn or transitioning to another ICE layer. This **supersedes only the pre-Corporation hand-discard timing** in RULE-RT-003/004/005; retain the established end-of-turn effects, BW forfeiture, and Corporation response sequencing.

**Revised turn order:** (1) Runner voluntarily selects END TURN (RULE-RT-001); (2) resolve Runner end-of-turn effects, including applicable BW effects and their triggered consequences; (3) **forfeit all remaining BW** (set available BW to zero); (4) enter and fully resolve Corporation Response, including ICE subroutines, damage and all applicable queued triggers; (5) if the run survives, perform **one post-response cleanup**, discarding all remaining non-CACHED cards from hand and resolving resulting discard triggers under RULE-014/015; (6) only after cleanup and its triggers finish, proceed to the next Runner turn, ICE PASS, or Node/ICE transition as applicable. **No routine hand discard takes place between steps 2 and 4.**

**End-of-turn versus cleanup triggers:** Abilities explicitly triggered by **end of Runner turn** still trigger at the existing end-turn window, before BW forfeiture and Corporation response. Abilities triggered by **actually discarding a card** trigger when that discard occurs: damage-induced discards during Corporation response occur then and queue per RULE-014/015/129; routine cleanup discards occur after the response and their triggers resolve before transition. A cleanup discard is **not retroactively an end-of-turn discard** for effects requiring that timing. Resolve the post-response cleanup discard batch and its generated triggers before advancing; follow existing simultaneous-trigger priority and FIFO queue rules. This relocation may change whether discard-generated prevention can affect the current Corporation response; do not backdate it.

**CACHE reconciliation (SOFT-003 through SOFT-008):** CACHE continues to protect selected cards from **routine cleanup**, not from damage. **CACHED cards are eligible for mandatory VOID and SyN discards** under the normal Runner-selection rule (RULE-001), unless an effect expressly provides protection. If discarded by damage, they leave hand and cannot be retained by CACHE. CACHED cards remaining after response survive cleanup, persist across ICE layers within the same Node while supported, and remain **additive to normal DRAW** (SOFT-004/005/006). Loss of CACHE support (SOFT-007) causes affected cards to be treated as ordinary cards at the next applicable cleanup, not discarded immediately merely for losing retention; explicit corporate discard and CACHE-targeting effects (SOFT-008) still work. CACHE does not survive the Node boundary (SOFT-006).

**ICE PASS:** If an ICE PASS or advancement occurs after a Corporation response, use the **single post-response cleanup** for the ordinary non-CACHED hand; do **not** run an additional routine PASS hand discard for those same cards. Finish cleanup-generated triggers before PASS transition. Other PASS-specific effects and triggers remain governed by their actual printed trigger conditions and existing rules; do not invent a second discard event. The next ICE layer retains the established fresh normal DRAW and additive surviving CACHE, subject to existing Node/ICE setup rules.

**DRAW remains unchanged:** No defensive DRAW is added during Corporation response. Preserve RULE-028/029/030/031 start-of-turn sequencing (refresh BW, resolve start-of-turn triggers, calculate DRAW, then normal DRAW) and current effective DRAW formula **max(1, 5 − VOID counters + applicable modifiers)**. Installed Hardware does not inherently reduce DRAW. CACHED cards are additive and do not reduce the number of new cards drawn; VOID counters gained during the response affect future DRAW only.

**Damage and defeat unchanged:** During Corporation response, retained ordinary and CACHED cards are available for mandatory damage discards. Apply the fixed mixed-damage order **VOID → SyN → BURN** (RULE-129). Each unprevented VOID grants its persistent counter and requires one discard; each missing discard generates **5 ordinary BURN**. Each unprevented SyN requires one discard; each missing discard generates **2 ordinary BURN** (RULE-126/127). Apply type-specific prevention automatically and immediately, including BURN prevention against overflow within the originating component (RULE-128/131). Damage-generated triggers remain queued until their containing effect completes (RULE-014/015/129). If Vitae reaches zero, immediate defeat (RULE-RT-002/RULE-130) cancels remaining instructions, pending triggers and post-response cleanup, preserving completed changes.

**Canonical example:** Runner starts with five cards, plays two, and ends the turn holding three. End-turn effects resolve; unused BW is forfeited; the hand is **not** discarded. Corporation inflicts VOID 2 + SyN 2, with no prevention: VOID adds two counters and discards two cards; SyN discards the final card and generates **2 BURN** for one missing discard, reducing Vitae by two if unprevented. No ordinary cards remain at post-response cleanup. At the next normal DRAW, absent other modifiers, the two VOID counters reduce DRAW from five to three.

**Priority:** RULE-132 explicitly supersedes the earlier pre-response routine discard instruction of RULE-RT-003/004/005 and the related older end-turn discard timing in SOFT-003/007, while preserving the underlying CACHE, BW, trigger, damage, defeat, ICE PASS and DRAW mechanics as reconciled above. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-133 — Discard-trigger timing and nonretroactive prevention (LOCKED, 2026-11-11)

**Explicit user approval:** When VOID, SyN, or another effect causes one or more cards to be discarded, discard-triggered abilities generated by those discards **queue as they arise** and **do not interrupt the originating effect**. Finish the entire originating effect (including its remaining mixed-damage components in the fixed **VOID → SyN → BURN** order, immediate overflow BURN, and any other instructions) before resolving its queued triggers. Use existing RULE-011/012/013 simultaneous-trigger ordering and RULE-014/015 FIFO queue semantics; do not create a new priority or interrupt window.

**Prevention gained by discard triggers:** Prevention from a triggered ability becomes available **only when that ability actually resolves**. It applies to eligible **subsequent damage** within its permitted duration, including a later ICE subroutine in the same Corporation response if applicable. It **never retroactively prevents** BURN, SyN, or VOID already resolved, and cannot be spent before it has been gained. Once gained, prevention follows DMG-002 and RULE-004/005/006 (type-specific pools and earliest-expiration consumption) and RULE-131 (automatic mandatory consumption). Damage overflow from missing VOID/SyN discards resolves immediately within its originating component under RULE-127/128/129/131, without waiting for discard-triggered prevention.

**Post-Corporation cleanup:** Following RULE-132, after the Corporation response and its pending triggers have finished, discard all remaining non-CACHED cards in the **single post-response cleanup**. Abilities triggered by those actual cleanup discards queue during cleanup and **resolve before the next Runner turn, ICE PASS, or Node/ICE transition**. Do not defer them to the next turn and do not add a second ordinary PASS discard. These triggers cannot retroactively change damage or prevention from the already-completed Corporation response. End-of-turn triggered abilities retain their earlier end-of-turn window; cleanup discards do not retroactively count as discards during that window.

**CACHE:** CACHED cards are exempt from routine cleanup but remain eligible for mandatory VOID/SyN damage discards unless explicitly protected (RULE-132 and SOFT-003–008). Discarding a CACHED card by damage generates applicable discard triggers under the same deferred timing; CACHE does not create an interrupt or retroactive prevention exception.

**Defeat and cancellation:** Check VIT immediately after each actual VIT reduction following prevention. At zero VIT, defeat is immediate and unresolved instructions and pending triggers are cancelled, with completed state changes preserved (RULE-RT-002/RULE-130). A queued discard-triggered prevention or recovery effect cannot rescue the Runner after fatal damage. SOFT-011 still prohibits reactive Runner card plays during Corporation turn; already-established triggered abilities may resolve when their queued turn arrives.

**Canonical example:** Runner has 10 VIT, three cards in hand, no prevention, and installed Software reading *“Whenever you discard a card, gain 2 BURN prevention.”* One Corporation subroutine inflicts **SyN 2 + direct BURN 4**. SyN discards two Runner-chosen cards, queuing two prevention-gain triggers; the triggers do **not** resolve yet. Direct BURN 4 is unprevented, reducing VIT to **6**. Once the subroutine's full effect finishes, the two queued triggers resolve under FIFO and grant **4 BURN prevention** in total (subject to applicable ability limits and source validity). That prevention may protect against a later subroutine but cannot prevent the earlier 4 BURN. If the Runner had been defeated during the subroutine, the queued triggers would instead be cancelled.

**Priority and reconciliation:** RULE-133 **clarifies, rather than overrides**, RULE-014/015 deferred-trigger resolution; RULE-127/128/129/130/131 damage ordering, prevention, overflow, and fatal damage; RULE-132 post-response cleanup and ICE PASS; and SOFT-003–008 CACHE. It introduces **no retroactive protection, extra DRAW, out-of-turn Runner card-play window, or new discard event**. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-134 — Discard event granularity, trigger frequency, and separate overflow BURN events (LOCKED, 2026-11-11)

**Approved design:** Use the existing instruction-level event model and deferred trigger queue; no new timing or interrupt system. Each **discrete discard instruction or damage component** produces **one grouped discard event** containing a separately recorded occurrence for **each card actually discarded**. Discard zero cards means zero actual card-discard occurrences; do not generate an actual-discard trigger for a shortfall. Distinct instructions are distinct groups even within one card effect. For a mixed damage effect, VOID and SyN are distinct damage components and thus distinct discard groups, even when one ICE subroutine generates both. One ordinary post-Corporation cleanup (RULE-132) is one grouped event containing its individual actual discards, and ICE PASS does not add a second routine cleanup group.

**Trigger wording controls counting:** “Whenever you discard **a card**” recognizes each individual actual card discard (three cards = three qualifying occurrences, subject to existing once-per-turn/activation limits). “Whenever you discard **one or more cards**” recognizes each grouped discard event with at least one actual discard (three cards in one instruction = one qualifying group). “For each card discarded” within a single group uses the group's actual card count as the magnitude of the relevant instruction, not separate events unless its printed trigger explicitly says per card. “The first time ... each turn” retains its existing per-turn allowance; a multi-card discard does not reset or bypass it. Card-specific qualifiers and source validity still apply. Preserve RULE-054/055, RULE-074–079, RULE-105/106 aggregate event identity, RULE-107 actual-vs-attempted magnitude, and existing per-turn limits.

**Separate overflow BURN events (explicit user decision):** For **each missing mandatory VOID discard**, generate a **separate ordinary BURN 5 damage event**; for **each missing mandatory SyN discard**, generate a **separate ordinary BURN 2 damage event**. Never aggregate multiple missing discards into one BURN event for damage-event trigger counting, even when they arise from the same damage component or ICE subroutine. Resolve each generated BURN event **immediately in sequence inside its originating VOID or SyN component**, applying available mandatory BURN prevention afresh against that event under RULE-128/131 and recording actual BURN suffered separately. Triggered effects recognizing a BURN damage event or actual BURN suffered count each qualifying separate event under their exact wording and applicable limits, but **remain queued** until the entire originating effect completes (RULE-014/015/129/133); they cannot create retroactive prevention or interrupt the next overflow event. After resolving all overflow events in VOID, proceed to SyN, then direct BURN, under RULE-129's fixed **VOID → SyN → BURN** order. A direct BURN component remains its own damage event under existing instruction-level rules. Check Vitae after every actual reduction: at VIT zero, RULE-130 immediately ends the run, cancels further overflow events, remaining instructions and queued triggers, preserving completed changes.

**Sequencing and bookkeeping:** For each component, first apply type-specific VOID/SyN prevention; apply each unprevented point's counter/discard consequences as established in RULE-127/129/131, recording actual card discards in the component's grouped discard event and resolving any missing-discard overflow BURN immediately as individual damage events. Preserve mandatory earliest-expiration prevention consumption (RULE-004/005/006/131). Each separate overflow BURN event records its source, originating damage type, amount (5 or 2), BURN prevention consumed by source/duration, actual VIT loss, and associated pending triggers. Discard-trigger occurrences record each card, grouping identifier, source, and reason. Trigger ordering for simultaneously recognized occurrences follows existing controller-order and FIFO rules; no new interrupt window is created.

**Examples:** (A) “Discard 3 cards” actually discards three: one grouped discard event, three per-card discard occurrences; a “whenever you discard a card” ability can queue three triggers, while “whenever you discard one or more cards” queues one. (B) VOID 2 + SyN 2 with four cards in hand: two grouped discard events (VOID discards two, SyN discards two), four individual card discards; per-card trigger count four, per-group trigger count two, before limits. (C) VOID 3 against an empty hand, with no prevention: gain three VOID counters; the three missing discards generate **three separate BURN 5 events**, in sequence, each with independent prevention and trigger-event accounting, stopping immediately on lethal VIT loss. (D) SyN 2 against an empty hand generates **two separate BURN 2 events**, not one BURN 4 event; aggregate VIT loss can equal four if unprevented and nonlethal, but event count remains two.

**Reconciliation and priority:** This rule clarifies RULE-010 instruction boundaries, RULE-014/015 deferred FIFO triggers, RULE-105/106 grouping, RULE-126–131 damage/overflow and prevention, RULE-132 single cleanup and CACHE timing, and RULE-133 deferred discard triggers and nonretroactive prevention. **It explicitly specifies separate overflow BURN event granularity**, superseding any inference that all shortfall BURN in one component forms a single event; numeric BURN amounts and existing prevention mechanics are unchanged. No reactive Runner card plays or extra DRAW are created. **Status: LOCKED, approved 2026-11-11.**


## RULE-135 — Damage-event identity, trigger eligibility, and prevention accounting (LOCKED, 2026-11-11)

**Explicit approval:** Each separate BURN damage application is an independent damage event for trigger eligibility and accounting, including each individual overflow BURN 5 from a missing VOID discard and each individual overflow BURN 2 from a missing SyN discard (RULE-134). Do not merge them into one event merely because they arise from the same ICE subroutine, damage component, or effect. Distinguish **damage applied** (an attempted BURN application, even when fully prevented), **damage prevented** (amount actually absorbed by eligible BURN prevention), and **damage suffered** (unprevented BURN actually reducing Vitae). Abilities recognize only the event their printed conditions name; do not conflate these categories.

**BURN-suffered eligibility:** “Whenever you suffer BURN damage” triggers only on a BURN event that **actually reduces VIT**, and once per qualifying event unless printed wording or an existing activation limit says otherwise. A fully prevented BURN event does **not** qualify as BURN suffered. Event magnitude for “BURN suffered” equals actual VIT reduction, not incoming BURN; prevention amount equals actual prevention consumed, not incoming BURN or unused pool capacity. Preserve RULE-107–109 actual-versus-attempted magnitude and threshold handling, as well as existing per-turn and per-source trigger limits.

**Prevention-event eligibility:** “Whenever you prevent damage” and comparable prevention-consumption triggers recognize only **actual positive prevention consumed**; a zero-consumption event does not qualify. Count prevention separately for each damage application and by the applicable prevention source/duration contribution under RULE-004/005/006 and RULE-131; do not invent a gain or consumption when none occurred. If one damage application consumes several prevention sources, apply existing RULE-074–079, RULE-105/106 and exact card wording to determine per-event versus per-source qualification; this rule does not automatically multiply a single event into one trigger per contributing source. Type-specific VOID and SyN prevention remain separate from BURN prevention; their consumption is accounted for when the respective type is applied.

**Timing:** All damage-, discard-, prevention-, and related triggers are queued as generated, following existing simultaneous-controller ordering and FIFO rules (RULE-011–015). They **do not interrupt their originating effect**, including between separate overflow BURN events within one VOID/SyN component. Resolve the entire originating effect before its queued triggers. Prevention granted by a queued trigger can apply only to **later** eligible damage after it actually resolves, never retroactively or to an earlier overflow event (RULE-133). Resolve each overflow event immediately within its originating component, with mandatory BURN prevention consumed under RULE-131, and preserve fixed mixed-damage order **VOID → SyN → direct BURN** (RULE-129). If VIT reaches zero, defeat is immediate; cancel unresolved damage events, instructions, and queued triggers without reversing completed changes (RULE-130).

**Worked example:** Runner begins at **20 VIT**, with no hand cards, **6 BURN prevention**, and no VOID prevention. Corporation inflicts VOID 3: gain 3 VOID counters and encounter 3 missing mandatory discards. Generate and resolve **three distinct BURN 5 events**, in order. Event 1: prevent 5, suffer 0, VIT 20. Event 2: prevent 1, suffer 4, VIT 16. Event 3: prevent 0, suffer 5, VIT 11. Thus there are **3 BURN applications**, **2 BURN-suffered events**, **2 events with positive BURN prevention**, **6 total BURN prevented**, and **9 total BURN suffered**. A “whenever you suffer BURN damage” ability recognizes two events, subject to its limits; its triggers wait until the full originating VOID effect completes. If the Runner is defeated during any event, remaining events and queued triggers are cancelled.

**Reconciliation and priority:** RULE-135 clarifies, without overriding, RULE-004–006 mandatory source/expiration consumption, RULE-014/015 FIFO deferred triggers, RULE-074–079 prevention-event granularity, RULE-105–109 aggregate events and actual magnitudes, RULE-126–131 damage/overflow and fatal defeat, RULE-132 post-Corporation cleanup, RULE-133 nonretroactive trigger timing, and RULE-134 separate overflow BURN event identity. No new interrupt window, defensive DRAW, retroactive prevention, or extra routine discard is created. **Status: LOCKED, explicitly approved 2026-11-11.**
