# PANOPTICON — DEVELOPMENT LOG ARCHIVE (2026-11-08 to 2026-11-14)
**Moved here 2026-11-16 (LOG-001)** from `REDLINE_DEVELOPMENT_LOG.md`, word for word, to keep the live log small. Append-only: later moves are added to the end, oldest first.

---

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

## RIOT-004 — RIOT's new values (APPROVED, 2026-11-14)

Profiling RIOT's deaths (27 of 30 runs) showed it was dying from TRACE, not from a lack of breaks: 20 of 27 at strike 2 or more, HOUSE CALL present in 17. SMASH & GRAB's +2 TRACE every turn was the steady source.

**Decisions:**
- **SMASH & GRAB:** extract 8 CRED; **+1 TRACE while your TRACE is under 20** (was +2 every turn). It drives RIOT up to the redline, then goes quiet.
- **SHATTER** stays as RIOT-003: 1 BW, **+3 TRACE**; SLEDGE breaks the chosen ICE of any type this turn, then drops to STR 0 for the rest of the encounter.
- **RIOT's starting deck is the 15-card deck** (RIOT-002): SLEDGE, BRUTE FORCE, SHATTER, OVERLOAD, PROBE ×3, FEEDBACK, ADRENAL SPIKE, PULP Shield ×3, LAY LOW, SMASH & GRAB, Basic Extractor.

**30-run bot test (all Rustlers, same bot):** ECHO 14 / 30 · VECTOR 12 / 30 · GENERALIST 10 / 30 · **RIOT 8 / 30** (was 1–3). SHATTER played 48 times in 21 runs. Variants tried: SMASH & GRAB no TRACE 10 / 30; +2 under 20 only 6 / 30; SHATTER without TRACE 1–3 / 30; SHATTER lasting the whole encounter 3 / 30.

## TEST-001 — 3 BW per turn (test only; BW stays at 4)

30-run bot test with BW_PER_TURN = 3 (everything else current): ECHO 9 / 30 (14 at 4 BW), GENERALIST 8 (10), RIOT 8 (8), VECTOR 7 (12). The Rustlers bunch together at 7–9; RIOT is unaffected because REDLINER restores a 4th BW at TRACE 20+; set-up Rustlers (ECHO, VECTOR) lose most; the CAPTCHA node becomes the main wall. A DETAINER would leave a 2-BW turn. Designer: leave BW at 4 for now; kept for reference.

## NAME-002 — The game is PANOPTICON (APPROVED, 2026-11-14)

Designer: REDLINE was the previous iteration; the game is now called **PANOPTICON** (completing TITLE-001's "intentional rename"). Scope chosen: **text only.**
- Renamed: the game name in every doc's text (including the Bible's rule sections, as an explicit designer decision rather than a silent CANON edit), the Godot project and window title, and the Windows build (`PANOPTICON_HALCYON_slice.exe`).
- Kept: `REDLINE_*.md` file names, code paths and identifiers, the save file, the GitHub repository name (Punkwork/REDLINE; renaming it is the designer's call on GitHub), and earlier dev-log entries, which stay as written.
- Not a game-name use, so unchanged: RIOT's ORIGIN **REDLINER** and the "redline" TRACE band (20–39).
- No NUL/REM dialogue verse mentions REDLINE.
- Still to sync: the project's copies of the docs (`claude/REDLINE_*.md` in the Panopticon project).

## DRAW-001 — DRAW 6 (APPROVED, 2026-11-14)

Playtest: with 4 BW and 5 cards there was little to decide about what not to play. Base **DRAW is now 6** (CORTEX still lowers it, minimum 1). 30-run bot test, DRAW 6 vs 5: GENERALIST 13 / 30 (10), ECHO 15 (14), VECTOR 8 (12), RIOT 1 (8). Cards left unplayed per turn rose from about 2.5–3.2 to 3.3–4.8.
- **RIOT** collapses with the bot because the bot plays every cheap card, and RIOT's cheap cards add TRACE (19 of its 29 deaths at TERMS & CONDITIONS, SHATTER played 82 times). A player choosing what not to play avoids that; RIOT needs re-checking with real play.
- **VECTOR** drops because more virus cards drive more PURGES (86 in 28 runs, up from 60).

## PULP-002 — PULP curves on the harder FORTRESSES (APPROVED, 2026-11-14)

Playtest: still not enough PULP. Designer's curves, one value per Corporation Response (looping after 9):

| Curve | Values | Total over 9 turns |
|---|---|---|
| **A · SEQUENTIAL** | 2, 3, 4, 2, 3, 4, 2, 3, 4 | 27 |
| **B · RANDOM** | 5, 3, 2, 6, 2, 3, 6, 2, 1, shuffled into a random order for each ICE | 30 |
| **C · HAMMER** | 4, 3, 4, 9, 3, 4, 3, 8, 2 | 40 |

- **Placed on the harder FORTRESSES only** (designer): **COOKIE WALL** (STR 5) gains [S3] PULP curve B before its DEADLOCK; **TERMS OF SERVICE** (STR 7, the final node) gains [S3] PULP curve C. AUTO-RENEW keeps its fixed PULP 1, 2, 3. Curve A is defined for later ICE.
- A curve's step counts the Corporation Responses that ICE has been through (a PURGE or BLACKOUT turn doesn't count). SCRAMBLE lowers curve PULP like any PULP.
- **On screen:** A and C show this turn's value (e.g. "PULP 9 · HAMMER"); B shows "PULP ? · RANDOM", and the response preview adds "+ random PULP (1–6)". Hovering a curve chip shows its sequence.

**30-run bot test (DRAW 6, curves on):** GENERALIST 10 / 30 · ECHO 6 · VECTOR 2 · RIOT 1. PULP reaching VITAE per encounter is now 6.7–9.3 (was 5.7–7.8), and survivors finish lower (ECHO 6.3, RIOT 2.0 average end VITAE).

## REEL-001 — TUMBLER slots spin like slot-machine reels (APPROVED, 2026-11-14)

- Each TUMBLER slot is drawn as a reel window: a dark recessed frame with shading at the top and bottom edge, like a drum curving away.
- When a TUMBLER rotates at the start of the Rustler's turn, each slot's strip rolls **downward**: the subroutine that was in the slot, a blur of passing subroutines (random icons, so nothing hidden is revealed), then this turn's subroutine. The reel spins fast, slows, runs slightly past the stop and clunks back with a flash.
- **Staggered stops:** slot 1 stops first and each later slot spins about 0.5 s longer (0.95 s, 1.45 s, 1.95 s…), like real reels. Input is held until every reel has stopped.
- **Slot labels now name the subroutine** ("SLOT 2 · S1"). Playtest confusion: on REJECT ALL, breaking S3's DEADLOCK and then seeing S1's DEADLOCK roll into slot 2 looked like the same DEADLOCK coming back unbroken. It was the second of REJECT ALL's two DEADLOCKs (turn-by-turn replay confirmed broken subroutines stay broken). The suggested follow-ups (show the DEADLOCK total on TUMBLERs; one DEADLOCK on REJECT ALL) are awaiting the designer.

## RUN-001 — END RUN button (APPROVED, 2026-11-14)

An END RUN button (bottom right, red) asks "END THIS RUN?" with YES, END THE RUN / KEEP PLAYING. Yes: the Rustler fails (NUL/REM's run-lost line, EV-35), then the game returns to the start menu (Rustler choice). Not available while the Corporation Response or the reels are playing.

## VECTOR-001 — PATIENT ZERO infects one chosen ICE (APPROVED, 2026-11-14)

VECTOR's ORIGIN Ghostware PATIENT ZERO: **at the start of each encounter, choose an ICE: INFECT 1 ROT on it** (was 1 ROT on every ICE). In the slice, each ICE card shows a "PATIENT ZERO · INFECT 1 ROT HERE" button before VECTOR's first move. 30-run bot test (VECTOR, DRAW 6 + PULP curves; the bot picks the ICE with the most unbroken DEADLOCKs): **5 / 30** cleared (2 before); corporation PURGES fell from 49 to 12, because fewer counters reach the limit. `REDLINE_RUSTLERS.md` §6 and Core Rules amendments updated.

Open: WORM copy vs move (WORMHOLE, COCKTAIL) — currently copy.

## VIRUS-001 — WORM becomes a break (APPROVED, 2026-11-14)

**Was:** each WORM counter copied 1 counter of each strain onto the ICE to the right at the start of your turn.
**Now:** on your turn, at any time, remove 2 WORM from an ICE to break 1 subroutine on that ICE, your choice. Normal break limits apply (active or revealed, BOOTING, SEQUENCED). It needs no Icepick, ignores the ICE's STR, costs no BW (TOLL doesn't apply), and works only on the Rustler's turn (designer-confirmed). A WORM break is still a break, so TRIPWIRE applies.

- Engine: `Game.worm_ok(i)` and `Game.use_worm(i)`; the subroutine is chosen through the card-break choice limited to that ICE. The copy step was removed from `_virus_turn`.
- UI: ICE cards with 2+ WORM show a "WORM · REMOVE 2 TO BREAK A SUBROUTINE" button. WORMHOLE text and the WORM tooltip updated.
- Tests: 134 passed (test_worm covers no Icepick, STR 5 ICE, 0 BW on TOLL, turn only). VECTOR sim: 5/30 cleared (unchanged; WORM is only in VECTOR's reward pool, so it rarely comes up in the starter-deck sim).
- No Windows build yet (the designer asked to wait for the go-ahead).


## 2026-11-14 — QA-HALCYON-001 / UI-003 / CI-001: playtest stabilization (Codex)

**Baseline:** `8a7dad98f97cb8b25950d25fdf4764f01e319e75` on `docs/simplified-redesign-sync`; work isolated on `codex/halcyon-playtest-stabilization`. User authorized screenshot repair, large-hand verification, tests, Windows export, and preparation for live playtest before consolidation.

**Changes:** repaired `godot/tests/shot_rustlers.gd` to resolve PATIENT ZERO before INJECT/SCRAMBLER/RUNTIME ERROR, reject failed plays, verify intended states, and check PNG writes. `godot/scripts/ui/main.gd` now clips and horizontally scrolls the hand at readable card size, refreshes the scrollbar range after deferred card layout, preserves scroll position, and puts pile counts on separate lines. Added `godot/tests/shot_hand.gd`, an Actions verification/export workflow, and `docs/HALCYON_PLAYTEST_GUIDE.md`; refreshed status and this handoff. No gameplay rules or balance edits.

**Executed locally:** official Godot `4.3.stable.official.77dcf97d8`, Linux, isolated Xvfb 1600×900 and software OpenGL:
- `godot --headless --path godot --editor --import --quit` — exit 0.
- `godot --headless --path godot --script res://tests/test_game.gd` — **134 passed, 0 failed**.
- `SIM=1` with the same rules command — **134/134**, GENERALIST 10/30, ECHO 6/30, VECTOR 5/30, RIOT 1/30 (seeds 100–129); unchanged baseline.
- Original `shot_rustlers.gd`, `shot.gd`, `shot_reel.gd` and new `shot_hand.gd` under the virtual display — exit 0, no script/parse/assertion errors. A combined run produced 41 PNGs; the timed animation scripts' frame counts can vary. Large-hand script verifies 6/7/9/10/16 cards, mouse-wheel scrolling, full last-card visibility, mouse-click play, stable refresh position, and separation from END TURN/pile counters.
- `godot --headless --path godot --export-release "Windows Desktop"` — Windows x86_64 release export generated using official matching 4.3 export template. The final export includes the presentation fixes; the artifact workflow exports its checked commit.

**Limits:** Xvfb reports unsupported V-Sync; original screenshot scripts may emit shutdown resource-use warnings. No Windows executable runtime or live designer checklist was performed. No CI success is asserted merely by adding a workflow. Bot termination does not guard balance. No new license, naming, CORTEX/VOID, REJECT ALL, or other open decision was settled.

**Merge review:** PR #1 (`docs/simplified-design`, `c42adc5`) contains an alternate JSON-backed heist implementation, data, icons, and tests; it is not wholly contained in PR #2. Preserve it for deliberate comparison rather than assuming PR #2 is a complete code superset. No merge/rebase/deletion was performed.

**Next dependency:** designer Windows playtest via `HALCYON_PLAYTEST_GUIDE.md`. Record action → actual → expected and source commit, then fix confirmed problems before merging the baseline or changing balance.


## 2026-11-14 — RIOT-005 / CORE-011: designer-requested local gameplay fixes; build held

**RIOT-005 (explicit designer instruction):** SMASH & GRAB installs for 1 BW / 1 RAM, extracts 3 CRED at end turn instead of 8, and retains +1 TRACE only while below 20. Spend 1 BW to uninstall it to discard and choose another card in hand to CACHE. Designer clarified expiry is **the end of the Rustler's next turn**, not the activation turn, and the cached card is another hand card, not the uninstalled Program. Implemented a distinct rig action/choice, immediate cost/RAM release, bounded retention counted across layer boundaries, expiry before the following Corporation Response, and removal of the temporary marker on leaving hand. Ordinary free unload has no CACHE benefit; existing indefinite CACHE is not shortened.

**CORE-011 (explicit designer revision):** leaving a Node before breaching the final ICE layer gives **no card reward**. Early exit clears pending offers, does not roll rewards or emit EV-27, performs normal Node teardown, and advances directly to the map or slice completion. Full clears keep the usual choice; CRED and exit restrictions are unchanged. Updated the leave dialog, Core Rules and Card Pools to supersede the prior early-exit reward rule.

**Verification:** official Godot 4.3 Linux, rules script **181 passed / 0 failed**. New checks cover SMASH & GRAB extraction/TRACE boundaries, cost/target validation, paid uninstall, temporary CACHE timing, layer transition, and independent existing CACHE; early exit after 1/2 and 2/3 layers, no reward RNG/event/stale claim, full-clear reward, last-map-Node exit, cleanup/CRED and LOCKDOWN. RIOT-005 virtual-display checks passed for the actual rig button and chosen hand card; 12 images generated including 6–16 card hands. Known virtual-display/shutdown resource warnings persist. No Windows runtime claim.

**Delivery hold:** user said “don't rebuild just yet.” No export, push, or hosted workflow was triggered for these local changes. The downloadable artifact at 807f003 predates them. Keep fixes together locally until the user is ready to rebuild; do not silently push the auto-building branch.


## 2026-11-14 — CORE-012: full-extraction CRED bonus removed (local, build held)

**Explicit designer instruction:** “let's remove the bonus and remove the bonus rule from the game rules. record this change in the appropriate documentation”. This follows ECHO receiving 17 CRED from COOKIE BANNER's 15-CRED reserve (15 extracted + former rounded-up 10% bonus of 2).

**Implementation:** removed additional CRED payment and `bonus_paid` state from `game.gd`. Full depletion still logs “Reserve fully extracted.” and emits EV-09 on the actual positive-to-zero transfer; repeated attempts on an empty reserve neither pay CRED nor re-emit depletion. Only actual reserve CRED is transferred. No change to other rewards or the separate Clean Node bonus.

**Documentation:** removed the bonus from Core Rules §9.2; recorded CORE-012 superseding NODE-EXTRACTION-001/002; corrected ECHO's strategy text; marked the older extraction-bonus entries in Master Design, World Bible, Core Design/Worldbuilding, Rule Review 126 and Current Status as historical/removed. Their old examples remain only as clearly superseded history. Updated Current Status and Codex handoff; no canon verses were changed.

**Verification:** `godot --headless --path godot --script res://tests/test_game.gd` using official 4.3 Linux: **203 passed, 0 failed**. Regression renamed `test_extraction_reserve_cap`; it covers partial/final/over-sized/repeated-empty transfers for reserves 10/15/25/40, preservation of existing banked CRED, single depletion notification, no bonus log, and an ECHO + Basic Extractor COOKIE BANNER payout of exactly 15 after three end turns. Prior RIOT-005 and CORE-011 checks remain passing.

**Delivery:** still local; no push, export, or CI triggered because the designer requested holding the rebuild. The 807f003 downloadable Windows artifact still has the old bonus until the next authorized build.


## 2026-11-14 — EXTRACT-002: Basic Extractor reduced to 3 CRED (local, build held)

**Designer instruction:** “Revise extractor to extract 3 Creds a turn instead of 5.” Applied to **Basic Extractor**, the shared 5-CRED starter Program; no other named Extractor was changed. Printed extraction and card text now say 3. Installation remains 1 BW / 1 RAM. All four starter tables, Core Rules and Card Pools were synchronized; EXTRACT-002 supersedes EXTRACT-001's former payout amount. Older EXTRACT-001 sections have explicit rate-supersession notes.

**Executed:** official Godot 4.3 Linux rules command, **206 passed / 0 failed**. Tests verify 3/3/3/1 payouts from a 10-CRED reserve and five 3-CRED payouts from COOKIE BANNER's 15, with no full-extraction bonus. The four-turn extraction fixture has extra test-only health to isolate payout checks from combat death; production health was not changed. All earlier local fixes pass.

**Hold remains:** no push, export or hosted CI; user has not requested a new build.


## 2026-11-14 — ECHO-005: BORROWED CREDENTIALS replaces BACKDOOR (local, build held)

**Designer instruction:** revise BACKDOOR to the proposed BORROWED CREDENTIALS SCRIPT, require an ICE choice when playing, and confirmed “1 BW + 8 cred”. Replaced the starter ID/definition with BORROWED_CREDENTIALS. Valid FORTRESS/VOID targeting grants HUSH compatibility with that specific ICE this turn; normal Strength/boost/break costs, reveal rules and passive restrictions remain. Both costs and target are checked before spending; successful plays pay 1 BW + 8 CRED and resolve to discard, not an automatic subroutine break. Compatibility expires at end turn and on new encounters. Existing HUSH/TUMBLER matching is unchanged.

Added CRED-cost display to card frames, revised the original BACKDOOR regression, added coverage for payment failure, missing/invalid ICE, FORTRESS/VOID compatibility, other-target exclusion, hidden VOID restrictions, actual HUSH breaks, expiry and layer boundaries. Updated Core Rules, Rustlers, Card Pools, Current Status and Codex handoff.

**Executed:** official Godot 4.3 Linux rules script **227 passed, 0 failed**. All previous local changes remain included. Bot strategy was not rewritten; earlier ECHO bot win rates do not establish balance of this new card.

**Delivery hold:** no push or build/export/hosted CI triggered. The published 807f003 executable predates these local changes.


## 2026-11-14 — BUILD-PLAYTEST-002: accumulated gameplay fixes released for the next playtest

**Authorization:** designer requested “build the next playtest version”, lifting the explicit delivery hold. Starting point is 807f003 on `codex/halcyon-playtest-stabilization`; latest branch head was checked before publication to preserve other work.

**Included:** RIOT-005, CORE-011, CORE-012, EXTRACT-002 and ECHO-005 as recorded above. No additional card balance or open design decisions are introduced. Set `application/config/version` to **0.2.0-playtest.2** and label Rustler selection **HALCYON PLAYTEST 2**. Updated the bundled guide with all changes, distinguishing the previous executable.

**Validation:** official Godot 4.3 Linux import and rules suite, **227 passed / 0 failed**; five virtual-display screenshot scripts include the new `shot_playtest2.gd` end-to-end UI scenario. That scenario selects BORROWED CREDENTIALS then its target, checks payment of exactly 1 BW and 8 CRED, breaks with HUSH, and presses the early-exit control to verify no reward. Large-hand checks now render the new dual-cost card as well. Added the scenario to the Actions workflow. Existing virtual-display V-Sync/resource-shutdown diagnostics are not Windows-runtime results.

**Delivery:** push the reviewed changes to the stabilization branch with a lease; GitHub Actions verifies and exports a fresh Windows x86_64 package plus guide/checklist/checksums. The actual hosted result and artifact identify the exact release commit. No source merge to main or historical-branch consolidation is performed. Designer Windows playtest remains the next validation step.


## 2026-11-15 — HANDOFF-001 / REJECT-001: shared to-do file, working branch, design sync (Claude)

**Designer decisions (2026-11-15):**
- **HANDOFF-001:** Codex and Claude coordinate through `docs/HANDOFF.md`, a shared list of decided-but-unfinished work with owners and statuses. The repo is the source of truth; the Claude project holds copies. **One working branch: `codex/halcyon-playtest-stabilization`**; changes arrive as pull requests into it. Claude now has write access to the repository.
- **REJECT-001:** REJECT ALL has **one DEADLOCK** (pool DEADLOCK · TRACE 3 · PULP 4, 2 slots), resolving the REEL-001 confusion. Recorded in `REDLINE_ICE_CORP1.md`; **build change not made** (listed for Codex in HANDOFF).
- **VIRUS-001 confirmed:** WORM counters are spent to break; they don't spread. The "copy vs move" note under VECTOR-001 no longer applies.
- **DSY-006 (end-of-run target only):** decks should be **30–35 cards by the end of LUCIDA**.

**Docs added (Claude, written in the Panopticon project 2026-11-15):** `REDLINE_DECK_SYNERGY.md` v0.3 (DSY-001 to DSY-014, PROPOSED), `REDLINE_PACING.md` v0.2 (PACE-001 to PACE-010, PROPOSED), and copies of the designer's `ICE Rules Bible` and `Ice Passive Abilities` Claude Docs as `REDLINE_ICE_RULES_BIBLE.md` and `REDLINE_ICE_PASSIVES.md`. **Docs changed:** `REDLINE_ICE_CORP1.md` (REJECT-001), `REDLINE_PLAYTEST_CHECKLIST.md` v0.1.1 (G1 and G5 targets for 30–35 cards), `REPOSITORY_STRUCTURE.md` (new docs, HANDOFF, working branch).

**Code changes:** none. **Tests run:** none (no Godot in Claude's environment). The proposals' numbers are working values, not tested.

<!-- LOG-001: oldest whole live-log entry appended on 2026-11-17. -->


## 2026-11-15 — DSY-001 to DSY-014 and PACE-001 to PACE-010 approved for the next build (Claude)

**Designer decision:** "Approve everything as written", to be implemented in the next build. `REDLINE_DECK_SYNERGY.md` → v1.0 and `REDLINE_PACING.md` → v1.0, every decision marked **APPROVED 2026-11-15**. Numbers remain working values to tune in playtest. Optional and conditional items stay as written: DSY-001b (GHOST +1 DRAW) optional; PACE-003's BOOTING-on-turn-4 only if playtest 2 shows an Opening Node breach before turn 4; PACE-006's safety valves held in reserve.

**Docs amended** (a "Later amendments (deck synergy and pacing)" table added to each, which wins where it conflicts with older section text): Core Rules, Card Pools, Uplink & CAPS, Upgrades/Events/Escape, Rustlers, Engines, ICE Corp 1–3. `REDLINE_PLAYTEST_CHECKLIST.md` → v0.2 (B1, C1, K1 revised; C9–C11, G6–G11 added). `HANDOFF.md`: build work listed for Codex in five synergy steps plus pacing; Claude tasks for scoring the slice and Phase 7 pools.

**Code changes:** none. **Tests run:** none.


<!-- LOG-001: oldest whole live-log entry appended on 2026-11-17. -->

## 2026-11-15 — REJECT-001: Use one DEADLOCK on REJECT ALL (Codex)

**Commit reference:** `playtest3-step0` (tag on this step commit).

**Changed:** REJECT ALL has one DEADLOCK in its three-entry pool; BOOTING remains turn 3. Updated opening rules checks and bot timing reporting.

**Interpretations to confirm:** The bot now installs/pre-boosts HUSH for BORROWED CREDENTIALS off-type coverage; stalled simulations are reported separately from deaths. These are harness corrections, not balance changes. Earliest observed opening BREACH was turn 3 for all Rustlers.

**Deferred:** Conditional BOOTING-on-turn-4 and safety valves remain excluded.

**Executed:** official Godot 4.3 Linux; full rules suite followed by the 30-seed sim for each Rustler (seeds 100–129), via `SIM=1 godot --headless --path godot --script res://tests/test_game.gd`.

```text
Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org

  bot: phase=SLICE_DONE vitae=10 trace=16 strikes=0 cred=16 deck=15 steps=28
  opening GENERALIST: earliest BREACH 3
  pulp GENERALIST: per encounter 13.2 incoming (1.7 from Black ICE), 5.8 absorbed by SHIELD, 7.4 to VITAE, 3.5 hits
  sim GENERALIST: 3/30 cleared; deaths by node { "CONSENT WALL": 4, "TERMS & CONDITIONS": 10, "DOORBELL": 13 }; survivors' avg end VITAE 18.7; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  opening ECHO: earliest BREACH 3
  pulp ECHO: per encounter 9.8 incoming (0.0 from Black ICE), 3.2 absorbed by SHIELD, 6.7 to VITAE, 3.0 hits
  sim ECHO: 14/30 cleared; deaths by node { "DOORBELL": 6, "CAPTCHA": 4, "TERMS & CONDITIONS": 6 }; survivors' avg end VITAE 12.9; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  opening RIOT: earliest BREACH 3
  pulp RIOT: per encounter 11.1 incoming (1.9 from Black ICE), 4.1 absorbed by SHIELD, 7.0 to VITAE, 2.9 hits
  sim RIOT: 3/30 cleared; deaths by node { "DOORBELL": 15, "TERMS & CONDITIONS": 10, "CAPTCHA": 2 }; survivors' avg end VITAE 14.0; purges 0 in 0 runs; SHATTER played 67 times in 29 runs
  opening VECTOR: earliest BREACH 3
  pulp VECTOR: per encounter 11.3 incoming (0.1 from Black ICE), 3.6 absorbed by SHIELD, 7.8 to VITAE, 3.2 hits
  sim VECTOR: 7/30 cleared; deaths by node { "CAPTCHA": 5, "TERMS & CONDITIONS": 9, "DOORBELL": 9 }; survivors' avg end VITAE 7.0; purges 22 in 17 runs; SHATTER played 0 times in 0 runs
TESTS: 219 passed, 0 failed
```


<!-- LOG-001: oldest whole live-log entry appended on 2026-11-17. -->


## 2026-11-15 — DSY-001, DSY-002, DSY-003, DSY-006: Add footprint pressure, deck analysis and DECOMPILE (Codex)

**Commit reference:** `playtest3-step1` (tag on this step commit).

**Changed:** FOOTPRINT/caps and bands, per-Node bloat TRACE, optional GHOST draw OFF, duplicate-aware draw estimates and key-card previews, COVERAGE/tag density, and guarded full-clear DECOMPILE.

**Interpretations to confirm:** Draw estimates use nominal stage lengths of 5/6/7 Rustler turns for HALCYON/IRONWATCH/LUCIDA. Conditional fallback cards count toward coverage; BORROWED CREDENTIALS requires HUSH and SHATTER requires SLEDGE. Existing TRACE modifiers apply to bloat tax; reported tax is actual TRACE gained. Empty-card reward skips still work.

**Deferred:** Playable IRONWATCH/LUCIDA are outside the slice; their cap values are supported by the analysis API. Deck-editing services outside full-clear rewards are later work.

**Executed:** official Godot 4.3 Linux; full rules suite followed by the 30-seed sim for each Rustler (seeds 100–129), via `SIM=1 godot --headless --path godot --script res://tests/test_game.gd`.

```text
Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org

  bot: phase=SLICE_DONE vitae=10 trace=16 strikes=0 cred=16 deck=15 steps=28
  deck GENERALIST: avg end size 14.07; avg bloat tax paid 0.00 TRACE
  opening GENERALIST: earliest BREACH 3
  pulp GENERALIST: per encounter 13.2 incoming (1.7 from Black ICE), 5.8 absorbed by SHIELD, 7.4 to VITAE, 3.5 hits
  sim GENERALIST: 3/30 cleared; deaths by node { "CONSENT WALL": 4, "TERMS & CONDITIONS": 10, "DOORBELL": 13 }; survivors' avg end VITAE 18.7; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck ECHO: avg end size 14.43; avg bloat tax paid 0.00 TRACE
  opening ECHO: earliest BREACH 3
  pulp ECHO: per encounter 9.8 incoming (0.0 from Black ICE), 3.2 absorbed by SHIELD, 6.7 to VITAE, 3.0 hits
  sim ECHO: 14/30 cleared; deaths by node { "DOORBELL": 6, "CAPTCHA": 4, "TERMS & CONDITIONS": 6 }; survivors' avg end VITAE 12.9; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck RIOT: avg end size 17.20; avg bloat tax paid 0.00 TRACE
  opening RIOT: earliest BREACH 3
  pulp RIOT: per encounter 11.1 incoming (1.9 from Black ICE), 4.1 absorbed by SHIELD, 7.0 to VITAE, 2.9 hits
  sim RIOT: 3/30 cleared; deaths by node { "DOORBELL": 15, "TERMS & CONDITIONS": 10, "CAPTCHA": 2 }; survivors' avg end VITAE 14.0; purges 0 in 0 runs; SHATTER played 67 times in 29 runs
  deck VECTOR: avg end size 14.17; avg bloat tax paid 0.00 TRACE
  opening VECTOR: earliest BREACH 3
  pulp VECTOR: per encounter 11.3 incoming (0.1 from Black ICE), 3.6 absorbed by SHIELD, 7.8 to VITAE, 3.2 hits
  sim VECTOR: 7/30 cleared; deaths by node { "CAPTCHA": 5, "TERMS & CONDITIONS": 9, "DOORBELL": 9 }; survivors' avg end VITAE 7.0; purges 22 in 17 runs; SHATTER played 0 times in 0 runs
TESTS: 233 passed, 0 failed
```

<!-- LOG-001: oldest whole live-log entry appended on 2026-11-17 (Claude). -->

## 2026-11-15 — DSY-007, DSY-008: Add REBOOT engines, SCAN and in-Node card routing (Codex)

**Commit reference:** `playtest3-step2` (tag on this step commit).

**Changed:** REBOOT queues drain only after draws finish; AMP and seven specified cards, SCAN bottom-order choice, in-Node BURN and discard retrieval, HUD reboot estimate, and bot choice handling.

**Interpretations to confirm:** SCAN does not itself reshuffle; selected bottom cards are ordered first-selected-first-drawn when reached. FORCE REBOOT counts even with an empty discard. ROLLING RESTART adds its printed +1 AMP without self-amplification; SHIELD/BW/draw ENGINE outputs gain current AMP. A 128-trigger repeating-chain safeguard prevents unbounded loops. One RIOT bot run stalled at the guard rather than dying; it is reported separately.

**Deferred:** CRON/PROCESS and unbuilt corporation systems remain deferred; AMP support for the existing virus outputs is completed with the UNDERFLOW/virus step.

**Executed:** official Godot 4.3 Linux; full rules suite followed by the 30-seed sim for each Rustler (seeds 100–129), via `SIM=1 godot --headless --path godot --script res://tests/test_game.gd`.

```text
Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org

  bot: phase=SLICE_DONE vitae=10 trace=17 strikes=0 cred=16 deck=15 steps=46
  deck GENERALIST: avg end size 14.23; avg bloat tax paid 0.00 TRACE
  opening GENERALIST: earliest BREACH 3
  pulp GENERALIST: per encounter 14.5 incoming (1.8 from Black ICE), 7.4 absorbed by SHIELD, 7.0 to VITAE, 4.8 hits
  sim GENERALIST: 8/30 cleared; deaths by node { "CONSENT WALL": 3, "TERMS & CONDITIONS": 11, "CAPTCHA": 3, "DOORBELL": 5 }; survivors' avg end VITAE 13.6; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck ECHO: avg end size 14.40; avg bloat tax paid 0.00 TRACE
  opening ECHO: earliest BREACH 3
  pulp ECHO: per encounter 10.7 incoming (0.0 from Black ICE), 3.9 absorbed by SHIELD, 6.8 to VITAE, 3.2 hits
  sim ECHO: 12/30 cleared; deaths by node { "DOORBELL": 11, "TERMS & CONDITIONS": 4, "CAPTCHA": 3 }; survivors' avg end VITAE 10.2; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck RIOT: avg end size 17.30; avg bloat tax paid 0.00 TRACE
  opening RIOT: earliest BREACH 3
  stalled RIOT (3000-step guard, not deaths): { "CAPTCHA": 1 }
  pulp RIOT: per encounter 10.9 incoming (2.2 from Black ICE), 3.9 absorbed by SHIELD, 7.0 to VITAE, 2.8 hits
  sim RIOT: 4/30 cleared; deaths by node { "TERMS & CONDITIONS": 15, "DOORBELL": 8, "CAPTCHA": 2 }; survivors' avg end VITAE 14.5; purges 0 in 0 runs; SHATTER played 81 times in 30 runs
  deck VECTOR: avg end size 14.13; avg bloat tax paid 0.00 TRACE
  opening VECTOR: earliest BREACH 3
  pulp VECTOR: per encounter 11.6 incoming (0.0 from Black ICE), 3.3 absorbed by SHIELD, 8.3 to VITAE, 3.2 hits
  sim VECTOR: 7/30 cleared; deaths by node { "TERMS & CONDITIONS": 10, "DOORBELL": 9, "CAPTCHA": 4 }; survivors' avg end VITAE 7.4; purges 19 in 16 runs; SHATTER played 0 times in 0 runs
TESTS: 244 passed, 0 failed
```


<!-- LOG-001: oldest whole live-log entry appended on 2026-11-17 (Codex). -->

## 2026-11-15 — DSY-011,012: Add CHAIN and HOLD (Codex)

**Commit reference:** `playtest3-step3` (tag on this step commit).

**Changed:** CHAIN tracks successful card plays; PIVOT, COVER FIRE, HANDOFF and KILL CHAIN; HOLD 1 and DEAD MAN’S POCKET HOLD 2; scrollable choices.

**Interpretations to confirm:** HOLD can retain a temporary cached card as ordinary CACHE. CHAIN effects are card-triggered rather than per-turn AMP processes. Bot stalls are reported separately from deaths.

**Deferred:** Ghostware acquisition and CAPS remain absent from the slice; the pocket effect is exercised through the Ghostware state hook.

**Executed:** official Godot 4.3 Linux; full rules suite followed by the 30-seed sim for each Rustler (seeds 100–129), via `SIM=1 godot --headless --path godot --script res://tests/test_game.gd`.

```text
Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org

  bot: phase=SLICE_DONE vitae=2 trace=18 strikes=0 cred=34 deck=15 steps=29
  deck GENERALIST: avg end size 14.50; avg bloat tax paid 0.00 TRACE
  opening GENERALIST: earliest BREACH 3
  stalled GENERALIST (3000-step guard, not deaths): { "DOORBELL": 1 }
  pulp GENERALIST: per encounter 266.4 incoming (259.4 from Black ICE), 260.3 absorbed by SHIELD, 6.1 to VITAE, 45.2 hits
  sim GENERALIST: 12/30 cleared; deaths by node { "TERMS & CONDITIONS": 9, "DOORBELL": 7, "CONSENT WALL": 1 }; survivors' avg end VITAE 15.8; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck ECHO: avg end size 14.23; avg bloat tax paid 0.00 TRACE
  opening ECHO: earliest BREACH 3
  stalled ECHO (3000-step guard, not deaths): { "TERMS & CONDITIONS": 1, "CAPTCHA": 2 }
  pulp ECHO: per encounter 10.4 incoming (0.0 from Black ICE), 3.0 absorbed by SHIELD, 7.3 to VITAE, 3.1 hits
  sim ECHO: 9/30 cleared; deaths by node { "TERMS & CONDITIONS": 5, "CAPTCHA": 4, "DOORBELL": 8, "CONSENT WALL": 1 }; survivors' avg end VITAE 11.4; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck RIOT: avg end size 17.53; avg bloat tax paid 0.00 TRACE
  opening RIOT: earliest BREACH 3
  pulp RIOT: per encounter 10.7 incoming (2.8 from Black ICE), 4.1 absorbed by SHIELD, 6.6 to VITAE, 2.7 hits
  sim RIOT: 12/30 cleared; deaths by node { "TERMS & CONDITIONS": 9, "DOORBELL": 7, "CAPTCHA": 2 }; survivors' avg end VITAE 10.8; purges 0 in 0 runs; SHATTER played 86 times in 30 runs
  deck VECTOR: avg end size 14.20; avg bloat tax paid 0.00 TRACE
  opening VECTOR: earliest BREACH 3
  pulp VECTOR: per encounter 10.0 incoming (0.0 from Black ICE), 2.7 absorbed by SHIELD, 7.3 to VITAE, 2.8 hits
  sim VECTOR: 6/30 cleared; deaths by node { "TERMS & CONDITIONS": 6, "DOORBELL": 14, "CAPTCHA": 4 }; survivors' avg end VITAE 5.7; purges 25 in 23 runs; SHATTER played 0 times in 0 runs
TESTS: 255 passed, 0 failed
```


## 2026-11-15 — DSY-009,010: Add UNDERFLOW OVERKILL and virus cash-outs (Codex)

**Commit reference:** `playtest3-step4` (tag on this step commit).

**Changed:** Negative ICE STR, MARGIN previews, SCALPEL, STACK SMASH, INTEGER UNDERFLOW, CULL and HARVEST; AMP on virus effects.

**Interpretations to confirm:** LOGIC BOMB sets even negative STR to exactly zero. Explicit STR floors prevail. TOLL remains an additional cost when OVERKILL waives the break cost.

**Deferred:** ZEROED has no approved numbers or card definition and remains a later RIOT-pool design. Other-corporation floor ICE are not on this map.

**Executed:** official Godot 4.3 Linux; full rules suite followed by the 30-seed sim for each Rustler (seeds 100–129), via `SIM=1 godot --headless --path godot --script res://tests/test_game.gd`.

```text
Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org

  bot: phase=SLICE_DONE vitae=7 trace=17 strikes=0 cred=16 deck=15 steps=28
  deck GENERALIST: avg end size 14.77; avg bloat tax paid 0.00 TRACE
  opening GENERALIST: earliest BREACH 3
  pulp GENERALIST: per encounter 7.2 incoming (1.1 from Black ICE), 1.6 absorbed by SHIELD, 5.6 to VITAE, 1.9 hits
  sim GENERALIST: 15/30 cleared; deaths by node { "TERMS & CONDITIONS": 11, "DOORBELL": 4 }; survivors' avg end VITAE 16.2; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck ECHO: avg end size 14.33; avg bloat tax paid 0.00 TRACE
  opening ECHO: earliest BREACH 3
  stalled ECHO (3000-step guard, not deaths): { "TERMS & CONDITIONS": 1, "CAPTCHA": 2 }
  pulp ECHO: per encounter 9.8 incoming (0.0 from Black ICE), 2.8 absorbed by SHIELD, 7.0 to VITAE, 3.1 hits
  sim ECHO: 10/30 cleared; deaths by node { "TERMS & CONDITIONS": 6, "CAPTCHA": 5, "DOORBELL": 5, "CONSENT WALL": 1 }; survivors' avg end VITAE 9.1; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck RIOT: avg end size 17.53; avg bloat tax paid 0.00 TRACE
  opening RIOT: earliest BREACH 3
  pulp RIOT: per encounter 10.3 incoming (2.5 from Black ICE), 3.9 absorbed by SHIELD, 6.4 to VITAE, 2.6 hits
  sim RIOT: 12/30 cleared; deaths by node { "TERMS & CONDITIONS": 9, "DOORBELL": 8, "CAPTCHA": 1 }; survivors' avg end VITAE 13.3; purges 0 in 0 runs; SHATTER played 79 times in 30 runs
  deck VECTOR: avg end size 14.30; avg bloat tax paid 0.00 TRACE
  opening VECTOR: earliest BREACH 3
  pulp VECTOR: per encounter 9.3 incoming (0.0 from Black ICE), 2.4 absorbed by SHIELD, 6.9 to VITAE, 2.6 hits
  sim VECTOR: 8/30 cleared; deaths by node { "DOORBELL": 12, "TERMS & CONDITIONS": 6, "CAPTCHA": 4 }; survivors' avg end VITAE 9.0; purges 23 in 20 runs; SHATTER played 0 times in 0 runs
TESTS: 264 passed, 0 failed
```


<!-- LOG-001: oldest whole entries appended on 2026-11-17 (Codex). -->

## 2026-11-15 — DSY-004,005,013: Add SAFEHOUSE COMPILE and corporation pushback hooks (Codex)

**Commit reference:** `playtest3-step5` (tag on this step commit).

**Changed:** SAFEHOUSE COMPILE with ordered effects, combined costs and tags, interactive continuations, CLEAN BUILD; MINIMALIST and ZERO FOOTPRINT; Ghostware effect hooks; FREE TRIAL on the final HALCYON layer.

**Interpretations to confirm:** The explicit shared-tag requirement overrides the contradictory PROBE × PULP SHIELD example. Compilation order is chosen by selecting cards in order. Targeted halves use the selected ICE; costs are prepaid once. SAFEHOUSE compilation replaces healing. Compiled cards burn if either half burns. MINIMALIST waives the full first-break BW action cost. Other-corporation reactive ICE have definitions and tested hooks, not map placement.

**Deferred:** REFACTOR 50-CRED Uplink service, PATCHWORK/FUSE acquisition and modifications, DEDUPLICATOR, Ghostware acquisition, and IRONWATCH/LUCIDA routes are absent from this slice; no acquisition or Uplink flow invented.

**Executed:** official Godot 4.3 Linux; full rules suite followed by the 30-seed sim for each Rustler (seeds 100–129), via `SIM=1 godot --headless --path godot --script res://tests/test_game.gd`.

```text
Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org

  bot: phase=SLICE_DONE vitae=7 trace=13 strikes=0 cred=16 deck=15 steps=28
  deck GENERALIST: avg end size 14.57; avg bloat tax paid 0.00 TRACE
  opening GENERALIST: earliest BREACH 3
  stalled GENERALIST (3000-step guard, not deaths): { "CAPTCHA": 1 }
  pulp GENERALIST: per encounter 137.5 incoming (1.3 from Black ICE), 131.1 absorbed by SHIELD, 6.3 to VITAE, 66.8 hits
  sim GENERALIST: 13/30 cleared; deaths by node { "TERMS & CONDITIONS": 12, "DOORBELL": 4 }; survivors' avg end VITAE 15.8; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck ECHO: avg end size 14.20; avg bloat tax paid 0.00 TRACE
  opening ECHO: earliest BREACH 3
  stalled ECHO (3000-step guard, not deaths): { "TERMS & CONDITIONS": 1, "CAPTCHA": 3 }
  pulp ECHO: per encounter 80.7 incoming (0.0 from Black ICE), 73.5 absorbed by SHIELD, 7.2 to VITAE, 26.7 hits
  sim ECHO: 8/30 cleared; deaths by node { "TERMS & CONDITIONS": 6, "DOORBELL": 7, "CAPTCHA": 4, "CONSENT WALL": 1 }; survivors' avg end VITAE 10.2; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck RIOT: avg end size 17.47; avg bloat tax paid 0.00 TRACE
  opening RIOT: earliest BREACH 3
  pulp RIOT: per encounter 9.9 incoming (2.0 from Black ICE), 3.7 absorbed by SHIELD, 6.2 to VITAE, 2.7 hits
  sim RIOT: 10/30 cleared; deaths by node { "DOORBELL": 8, "TERMS & CONDITIONS": 10, "CAPTCHA": 2 }; survivors' avg end VITAE 16.6; purges 0 in 0 runs; SHATTER played 77 times in 29 runs
  deck VECTOR: avg end size 14.10; avg bloat tax paid 0.00 TRACE
  opening VECTOR: earliest BREACH 3
  stalled VECTOR (3000-step guard, not deaths): { "TERMS & CONDITIONS": 1 }
  pulp VECTOR: per encounter 10.1 incoming (0.0 from Black ICE), 2.8 absorbed by SHIELD, 7.4 to VITAE, 2.9 hits
  sim VECTOR: 5/30 cleared; deaths by node { "TERMS & CONDITIONS": 6, "DOORBELL": 13, "CAPTCHA": 5 }; survivors' avg end VITAE 8.2; purges 23 in 20 runs; SHATTER played 0 times in 0 runs
TESTS: 278 passed, 0 failed
```


## 2026-11-15 — PACE-003,005,007,008: Add pacing mechanics and prepare HALCYON PLAYTEST 3 (Codex)

**Commit reference:** `playtest3-pacing` (tag on this step commit).

**Changed:** DEADLOCK ×N progress for paid/card/WORM breaks; independent ESCALATE counters for TRACE/DISCARD/FORGET; reward need icons and visible draw chance; Tier 1 one-layer route; tier-aware reward odds; +50% reserves; version/label 0.3.0-playtest.3 / HALCYON PLAYTEST 3; post-merge-only Windows export; updated playtest guide and nine new UI fixtures. Final regression review also completed AMP for SILENT PARTNER/PAIN TOLERANCE, amplified card text, compiled fallback coverage, and Node/run state resets.

**Interpretations to confirm:** All four slice rows are Opening/Tier 1 (ICE Corp 1 §5.0 and Pacing §7); retain each Node’s first layer and remove later layers, without rebalance. FREE TRIAL remains Tier 2 data/trigger only after this cut, superseding its temporary Step 5 placement. 15 ×1.5 CRED rounds up to whole 23. No existing ICE receives an unspecified ×N or ESCALATE assignment; controlled fixtures exercise both. Cards outside the DRILL/HULL/COVERAGE definitions have no misleading role label. REBOOT resolves rack effects in installation order; ROLLING RESTART gains a fixed one AMP rather than amplifying its own AMP production. A finite repeating-trigger guard prevents recursive draw loops from hanging the app. Numeric GHOST thresholds override contradictory RIOT starter prose: 15 is in HALCYON GHOST. Compiled effects resolve against the board in order; a conditional break half with no eligible subroutine does nothing, so a preceding STR reduction can enable it.

**Deferred:** No conditional BOOTING/safety-valve changes. Tier 2 map placement, other corporations, Uplink/REFACTOR, PATCHWORK/FUSE, Ghostware acquisition/DEDUPLICATOR and CAPS remain deferred as listed in HANDOFF. Phase 7 HULL pools, ZEROED and manual BREACH WORK scoring retain their existing owners. Windows export happens after merge; Windows launch/human playtest have not been run.

**Executed:** official Godot 4.3 Linux; full rules suite followed by the 30-seed sim for each Rustler (seeds 100–129), via `SIM=1 godot --headless --path godot --script res://tests/test_game.gd`.

```text
Godot Engine v4.3.stable.official.77dcf97d8 - https://godotengine.org

  bot: phase=SLICE_DONE vitae=7 trace=8 strikes=0 cred=26 deck=15 steps=24
  deck GENERALIST: avg end size 15.37; avg bloat tax paid 0.00 TRACE
  opening GENERALIST: earliest BREACH 3
  stalled GENERALIST (3000-step guard, not deaths): { "CAPTCHA": 1 }
  pulp GENERALIST: per encounter 181.2 incoming (0.0 from Black ICE), 175.8 absorbed by SHIELD, 5.4 to VITAE, 89.4 hits
  sim GENERALIST: 29/30 cleared; deaths by node {  }; survivors' avg end VITAE 16.2; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck ECHO: avg end size 14.80; avg bloat tax paid 0.00 TRACE
  opening ECHO: earliest BREACH 3
  pulp ECHO: per encounter 14.5 incoming (0.0 from Black ICE), 5.2 absorbed by SHIELD, 9.3 to VITAE, 4.4 hits
  sim ECHO: 20/30 cleared; deaths by node { "TERMS & CONDITIONS": 5, "CAPTCHA": 4, "CONSENT WALL": 1 }; survivors' avg end VITAE 8.8; purges 0 in 0 runs; SHATTER played 0 times in 0 runs
  deck RIOT: avg end size 18.20; avg bloat tax paid 0.00 TRACE
  opening RIOT: earliest BREACH 3
  pulp RIOT: per encounter 9.6 incoming (0.8 from Black ICE), 4.1 absorbed by SHIELD, 5.6 to VITAE, 2.8 hits
  sim RIOT: 24/30 cleared; deaths by node { "TERMS & CONDITIONS": 3, "CAPTCHA": 2, "DOORBELL": 1 }; survivors' avg end VITAE 18.0; purges 0 in 0 runs; SHATTER played 18 times in 12 runs
  deck VECTOR: avg end size 14.87; avg bloat tax paid 0.00 TRACE
  opening VECTOR: earliest BREACH 3
  pulp VECTOR: per encounter 12.5 incoming (0.0 from Black ICE), 4.2 absorbed by SHIELD, 8.3 to VITAE, 3.6 hits
  sim VECTOR: 20/30 cleared; deaths by node { "CAPTCHA": 5, "TERMS & CONDITIONS": 5 }; survivors' avg end VITAE 11.1; purges 12 in 12 runs; SHATTER played 0 times in 0 runs
TESTS: 310 passed, 0 failed
```


<!-- LOG-001: oldest whole entries appended on 2026-11-17 (Codex). -->

## 2026-11-15 — UI-004: horizontal card-choice menus (Codex)

**Request:** First Windows playtest showed HOLD and Generalist READY RIG cards wrapping vertically, hiding most choices. Display the cards horizontally.

**Changed:** Replaced the shared choice menu's HFlowContainer with an HBoxContainer and explicitly enabled horizontal scrolling. All choice cards remain in one row; the full height fits above the scrollbar. This also fixes other menus using the same helper.

**Verification:** Godot 4.3 full rules suite: 310 passed, 0 failed. The display-backed playtest-3 script passes with zero failures, including horizontal alignment/full-height checks for HOLD and READY RIG, an overflowing READY RIG fixture, and scrolling until its final card is fully visible. Ten fixture screenshots render.

**Delivery:** Feature branch `codex/horizontal-choice-menus`, targeting `codex/halcyon-playtest-stabilization`. The existing Windows ZIP remains unchanged until this fix is merged and the stabilization workflow exports it.


## 2026-11-16 — ZEROED-001: ICE STR floors at 0; ZEROED keyword, once per ICE; ROT-001 doc sync (Claude)

**Designer decisions (2026-11-16):**
- **ZEROED-001 (APPROVED):** "I think 0 str is a good bottom … it results in too much confusion and counting for the player." ICE STR can't go below 0; DSY-009's UNDERFLOW is withdrawn and ROT keeps its "minimum 0". A reduction past 0 is lost; spare ROT counters keep an ICE at 0 if it gains STR. MARGIN and OVERKILL stay (the game shows MARGIN).
- **ZEROED keyword (APPROVED), "once per ICE":** a card's ZEROED bonus triggers if it takes target ICE from above 0 to 0. Each ICE can be ZEROED once per encounter; the first drop to 0 from any cause uses it up, so the ZEROED card has to land last. Floored ICE (DEADBOLT, SYNAPSE BARRIER, AMNESIA) and ICE starting at 0 can't be ZEROED. The "any cause" reading is Claude's write-up for the designer to confirm.
- **Cards (PROPOSED):** NULL POINTER replaces INTEGER UNDERFLOW (target ICE at 0 STR: break 2 subroutines, BURNED); RIOT ZEROED examples FLATLINE (ZEROED: −4 TRACE), KNOCKOUT (ZEROED: break 1), SECOND WIND (ZEROED: +1 BW).
- **ROT-001 sync:** remaining SIGYL labels in Card Pools, Rustlers, ICE Corp 1–3, Upgrades and Engines changed to TUMBLER; non-slice TUMBLERS still need slot counts.

**Docs changed:** `REDLINE_DECK_SYNERGY.md` v1.1 (§0, §5.2, §5.3 rewritten, new §5.3a ZEROED, §7, §9.2, §10, §11, §12); Core Rules §5.3, §5.7 and amendments; Rustlers, Pacing amendments; HANDOFF (build item for Codex: revert negative STR from `playtest3-step4`, add ZEROED flag). **Code changes:** none. **Tests:** none.

<!-- LOG-001: oldest whole entries appended on 2026-11-17 (Codex). -->

## 2026-11-16 — ZEROED-001 cards approved; TUMBLE-001; LOG-001; Codex handoff (Claude)

**Designer decisions (2026-11-16):**
- **ZEROED-001 cards (APPROVED):** "Approved for all those card changes you made." NULL POINTER replaces INTEGER UNDERFLOW; FLATLINE, KNOCKOUT and SECOND WIND join RIOT's pool (`REDLINE_DECK_SYNERGY.md` §9.2).
- **TUMBLE-001 (APPROVED):** "if a subroutine is broken, any unbroken subroutines slide 'tumble' into (its) place." Written up in Core Rules §5.4: a broken TUMBLER subroutine leaves the pool; the slots after it shift back; the next unbroken subroutine tumbles into the last slot, active at once; rotation skips broken subroutines and stops once every unbroken one is showing. Replaces "broken stays broken… rotates out and back in", and removes the REEL-001 confusion at its source. Two readings for the designer to confirm (HANDOFF, Waiting): a tumbled-in subroutine is active at once; and any drop to 0 uses up an ICE's ZEROED.
- **LOG-001:** this log is split. Entries from 2026-11-08 to 2026-11-14 moved unchanged to `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md`; the live log is kept under about 60 KB so the Claude project copy can be rewritten in one pass.

**Docs changed:** Core Rules (§5.4, amendments), ICE Rules Bible (TUMBLER), ICE Corp 1 and Pacing (amendments), Deck Synergy (§9.2, §12), HANDOFF (a "Start here (Codex)" block listing today's build work in order; ZEROED-001, ZEROED-001 cards and TUMBLE-001 rows; two Waiting rows; LOG-001 rule). **Code changes:** none. **Tests:** none.

<!-- LOG-001: oldest whole entries appended on 2026-11-17 (Codex). -->

## 2026-11-16 — ZEROED-001 and TUMBLE-001 readings confirmed (Claude)

**Designer decision:** "Confirmed on both." (1) Any drop to 0 STR, from any source, uses up an ICE's one ZEROED; the bonus only comes from a card that prints ZEROED (Synergy §5.3a rule 2, Core Rules §5.3). (2) A TUMBLER subroutine that tumbles into a slot is active at once: breakable that turn, and it fires in that turn's Corporation Response if unbroken (Core Rules §5.4). Both readings were already written this way; the two WAITING rows in HANDOFF are closed. **Code changes:** none. **Tests:** none.

## 2026-11-17 — VIS-001: visual language "The Friendly Lie" handed to Codex (Claude)

**Designer decision:** direction B chosen from three explorations (A Phosphor, B The Friendly Lie, C Watchtower): "I do really like the B option the friendly lie … I think this is a more suitable direction." Further requests in the same session: one encounter screen per corporation with its own background and palette; Rustlers draw 6 cards (maximum hand size not decided); show how the friendly face breaks and what full TRACE looks like; give ICE a personality that flips from cheery to lethal; put the mascots into the encounter screen; hand it to Codex.

**Docs added:** `REDLINE_VISUAL_LANGUAGE.md` (Part 1 brief, Part 2 design, Part 3 build steps VIS-001a–g); `docs/visual/reference/` (10 PNGs), `docs/visual/backgrounds/` (4 placeholder JPGs), `docs/visual/mascots/` (9 SVGs). **Atomic Salvage deprecated (designer):** "I would deprecate that atomic salvage look." A deprecation note heads `REDLINE_UI_NULREM_Design_For_Claude.md` §1. §2.10 records that VIS-001 replaces the look of `REDLINE_UI_NULREM_Design_For_Claude.md` (Atomic Salvage) but keeps its requirements (drag-to-ICE chips, BW slits, no clipped text, REEL-001, END RUN, CRED meter, NUL/REM personality). **HANDOFF:** VIS-001 row (Codex, TO DO), a WAITING row (hand size, lethal threshold, proposal silhouettes). **Code changes:** none. **Tests:** none.

## 2026-11-17 — ZEROED-001: Restore STR floor and track once-per-ICE ZEROED (Codex)

**Commit tag:** `zeroed-tumble-step1`.

**Changed:** Restore STR floor and track once-per-ICE ZEROED

**Interpretations to confirm:** Positive STR floors also constrain LOGIC BOMB; its displayed STR stays at the floor and it cannot consume ZEROED. Loss of RELAY discards any resulting non-ROT deficit so later gains rise from zero. These readings preserve the explicit floor and no-hidden-debt rules.

**Tests:** Godot 4.3 full rules suite and 30 seeds (100–129) for each Rustler. Turns measure all non-stalled encounters; cleared-run turns measure survivors only. Stalls remain separate from deaths.

```text
sim GENERALIST: 29/30 cleared; deaths by node {  }; survivors' avg end VITAE 16.2; turns per non-stalled encounter 2.84; avg cleared-run turns 9.8
sim ECHO: 20/30 cleared; deaths by node { "TERMS & CONDITIONS": 5, "CAPTCHA": 4, "CONSENT WALL": 1 }; survivors' avg end VITAE 8.8; turns per non-stalled encounter 4.06; avg cleared-run turns 12.9
sim RIOT: 24/30 cleared; deaths by node { "TERMS & CONDITIONS": 3, "CAPTCHA": 2, "DOORBELL": 1 }; survivors' avg end VITAE 18.0; turns per non-stalled encounter 3.19; avg cleared-run turns 10.5
sim VECTOR: 20/30 cleared; deaths by node { "CAPTCHA": 5, "TERMS & CONDITIONS": 5 }; survivors' avg end VITAE 11.1; turns per non-stalled encounter 3.69; avg cleared-run turns 13.1
TESTS: 320 passed, 0 failed
```

## 2026-11-17 — ZEROED-001-cards: Replace INTEGER UNDERFLOW with NULL POINTER and add RIOT ZEROED cards (Codex)

**Commit tag:** `zeroed-tumble-step2`.

**Changed:** Replace INTEGER UNDERFLOW with NULL POINTER and add RIOT ZEROED cards

**Interpretations to confirm:** None.

**Tests:** Godot 4.3 full rules suite and 30 seeds (100–129) for each Rustler. Turns measure all non-stalled encounters; cleared-run turns measure survivors only. Stalls remain separate from deaths.

```text
sim GENERALIST: 29/30 cleared; deaths by node {  }; survivors' avg end VITAE 16.2; turns per non-stalled encounter 2.84; avg cleared-run turns 9.8
sim ECHO: 20/30 cleared; deaths by node { "TERMS & CONDITIONS": 5, "CAPTCHA": 4, "CONSENT WALL": 1 }; survivors' avg end VITAE 8.8; turns per non-stalled encounter 4.06; avg cleared-run turns 12.9
sim RIOT: 24/30 cleared; deaths by node { "TERMS & CONDITIONS": 3, "CAPTCHA": 2, "DOORBELL": 1 }; survivors' avg end VITAE 18.0; turns per non-stalled encounter 3.19; avg cleared-run turns 10.5
sim VECTOR: 20/30 cleared; deaths by node { "CAPTCHA": 5, "TERMS & CONDITIONS": 5 }; survivors' avg end VITAE 11.1; turns per non-stalled encounter 3.69; avg cleared-run turns 13.1
TESTS: 331 passed, 0 failed
```

## 2026-11-17 — TUMBLE-001: Remove broken TUMBLER subs and tumble immediately active replacements (Codex)

**Commit tag:** `zeroed-tumble-step3`.

**Changed:** Remove broken TUMBLER subs and tumble immediately active replacements

**Interpretations to confirm:** None.

**Tests:** Godot 4.3 full rules suite and 30 seeds (100–129) for each Rustler. Turns measure all non-stalled encounters; cleared-run turns measure survivors only. Stalls remain separate from deaths.

```text
sim GENERALIST: 25/30 cleared; deaths by node { "CAPTCHA": 2, "TERMS & CONDITIONS": 1 }; survivors' avg end VITAE 16.2; turns per non-stalled encounter 3.09; avg cleared-run turns 9.2
sim ECHO: 17/30 cleared; deaths by node { "TERMS & CONDITIONS": 9, "CAPTCHA": 3, "CONSENT WALL": 1 }; survivors' avg end VITAE 9.5; turns per non-stalled encounter 3.91; avg cleared-run turns 12.6
sim RIOT: 25/30 cleared; deaths by node { "CAPTCHA": 4, "TERMS & CONDITIONS": 1 }; survivors' avg end VITAE 15.2; turns per non-stalled encounter 3.14; avg cleared-run turns 10.9
sim VECTOR: 20/30 cleared; deaths by node { "CAPTCHA": 6, "TERMS & CONDITIONS": 4 }; survivors' avg end VITAE 10.7; turns per non-stalled encounter 3.61; avg cleared-run turns 12.9
TESTS: 352 passed, 0 failed
```

**TUMBLE comparison with Step 2 (same seeds/policy):** clears GENERALIST 29→25, ECHO 20→17, RIOT 24→25, VECTOR 20→20. Turns per non-stalled encounter: GENERALIST 2.84→3.09, ECHO 4.06→3.91, RIOT 3.19→3.14, VECTOR 3.69→3.61. GENERALIST stalls at the action guard rose from 1 to 2; these are not deaths. The bot takes the first shared reward, so the new RIOT reward cards are exercised by deterministic card tests rather than normally drafted by this policy.

**UI verification:** all six display-backed scripts pass, including actual SCAN/CULL choices, horizontal HOLD/READY RIG access, ZEROED target highlighting and marker, tumble motion, immediate breakability during animation, and settled slots. Existing negative-STR and opening-rotation assertions were updated in place. Stable subroutine IDs remain for labels/history; broken entries are filtered out of the circulating pool.

**Candidate requested by designer:** “give me a build I can download.” The existing CI export gate now also permits this exact feature branch; it still excludes other feature branches and PR events. The candidate remains version 0.3.0-playtest.3 and displays ZEROED + TUMBLE. Its ZIP includes BUILD_COMMIT.txt. No merge or direct push to stabilization is performed.

## 2026-11-17 — VIS-001a: fixed Rustler theme and corporation skin resources (Codex)

**Commit tag:** `vis-001a`. Added DM Sans variable font (400/500/700 UI weights), Space Mono regular/bold, both SIL OFL licenses, fixed toner/paper/highlighter Rustler theme, and HALCYON/IRONWATCH/LUCIDA skin resources. HALCYON is selected for the slice; the other corporations are data only. Runtime copies of the supplied backgrounds and mascot SVGs are packaged under Godot assets so exports do not depend on files outside res://.

**Interpretations to confirm:** only HALCYON has supplied hostile background art; the other two resources leave that texture unset rather than reusing HALCYON art. Corporate fonts and palettes are isolated from the invariant Rustler theme.

**Validation:** Godot 4.3 editor import and script/resource parsing. No gameplay data or values changed. ZEROED/TUMBLE from PR #9 were integrated into this feature branch first; stabilization itself is unchanged.

## 2026-11-17 — VIS-001b: encounter scaffold and paper hand (Codex)

**Commit tag:** `vis-001b`. Added a 1600×1000 encounter presentation inside the existing main controller: corporate app background, node/TRACE tags, reserve and deck data, fixed zine HUD, response strip, stationary NUL/REM note, RIG/RACK strip, END TURN and END RUN. Existing map/reward/choice flows remain with the controller. Six 146×218 paper cards use hard shadows and highlights; 7+ fan without changing deck or hand limits. Hover, wheel and arrow browsing bring each card forward. Bloatware uses the corporate font, rounded white body and red header.

**Interpretations to confirm:** long card rules progressively reduce the art placeholder and font size to retain all rule text; full text also remains available in inspection/tooltips. Extremely large hands keep readable individual cards and use fan browsing, rather than imposing a cap. BW slits represent spending from the left; numeric BW remains authoritative for bonuses.

**Validation:** Godot 4.3 import and display-backed encounter render, including six actual game cards. This step establishes layout; mascot/scan replacement follows in VIS-001c. No gameplay values changed.

## 2026-11-17 — VIS-001c: mascot silhouettes and independent scan tags (Codex)

**Commit tag:** `vis-001c`. Recreated COOKIE WALL banner/cookie, CAPTCHA widget/grid/eye, DOORBELL pill/lens and AUTO-RENEW credit card. Added simple proposed ACCEPT ALL pill, REJECT ALL link, TERMS OF SERVICE document, CONSENT FORM clipboard and HOUSE CALL silhouette. Separate face features trace the supplied SVG coordinates. Primary corporate buttons represent DEADLOCKs; scan tags retain exact rule text, states, progress, hidden pool counts, passive rules and virus actions. Existing reel/tumble presentation is reused. Hidden effects remain hidden rather than being disclosed by decoration.

**Interpretations to confirm — proposed copy (cheery / wary / lethal):** ACCEPT ALL: “Make yourself at home!” / “We noticed you hesitating.” / “YOUR CONSENT IS ASSUMED.” REJECT ALL: “You may change your preferences.” / “Are you absolutely sure?” / “THERE IS NO OPT OUT.” TERMS OF SERVICE: “A few little terms before we begin!” / “You haven't read the fine print.” / “YOU ALREADY AGREED.” CONSENT FORM: “Your choices matter to us!” / “We saved your preferences. All of them.” / “CONSENT IS MANDATORY.” HOUSE CALL: “Your technician is on the way!” / “Please stay where you are.” / “WE KNOW YOU'RE HOME.” FREE TRIAL (fallback for existing test data): “Try us. No strings attached!” / “Your trial is almost over.” / “YOU CANNOT CANCEL.” Proposal shapes follow the spec's table; final illustration remains out of scope.

**Validation:** Godot 4.3 parsing and display-backed render checked against reference 08. Rule chips are independent of the corporate face and wording. Mascot/scan columns scroll only when the rule content needs more space, preserving text. No gameplay changes.

## 2026-11-17 — VIS-001d: per-ICE mood ladder and threat wording (Codex)

**Commit tag:** `vis-001d`. Mood is computed from the actual next-response effects and broken state: cheery, wary, lethal, then knocked out on BREACH. Black ICE and Mask off force lethal. The main scene exposes `lethal_pulp_threshold` (default 5) for tuning. Facial features, panel colors/corners, speech and price-sticker wording follow mood; rule wording and values do not. New tumbled entries are remembered for the current turn; biggest visible PULP is red in both scan and response. Card-choice previews also use the paper card component.

**Interpretations to confirm:** the PULP threshold applies to the largest individual subroutine, not the sum of an ICE's PULP, to reproduce reference 08 (AUTO-RENEW 1+2+3 remains cheery) and 09 (incoming CAPTCHA PULP 6 becomes lethal). Any positive CORTEX qualifies. Hidden rules remain “? HIDDEN”; random curve values remain “PULP ?”, even when the mascot telegraphs danger. Red rule chips use toner text rather than white for 4.5:1 contrast.

**Validation:** code/resource parsing and state-based mood calculations; the final VIS-001g fixtures exercise the real turn-1/turn-3 board. No rules, card stats or corporation values changed.

## 2026-11-17 — VIS-001e: Cracking, strike disclosure and Mask off (Codex)

**Commit tag:** `vis-001e`. TRACE/strike state drives the app background and corporate edges; the Rustler theme stays fixed. Added a one-time checking-on-you toast, background-only glitch bands, the PAST 50% tag and NUL/REM countdown. First strike displays the hostile “We see you.” modal and a corporate TRACER card, then returns to Cracking; strike 2+ keeps the hostile background and square red/black mascots. The reserve meter and actual post-strike TRACE remain visible.

**Interpretations to confirm:** Cracking persists after strike 1 even if TRACE is reduced below 20, since the Friendly definition requires no strikes. The modal shows the real post-strike TRACE of 20 in the HUD rather than faking 40; its copy describes the strike and inserted TRACER. The toast lasts 3 seconds; the modal lasts 2.5 seconds or until dismissed. SPAM's proposed footer is “Recommended for you.” A red rule chip uses toner text for contrast. All distortion stays behind opaque text panels.

**Validation:** Godot 4.3 parser; state changes read Game.trace/strikes and never insert cards or Black ICE themselves. Only the existing game rules cause those changes. Live-state fixture screenshots follow in VIS-001g.

## 2026-11-17 — VIS-001f: live drag targets, mascot motion and reduced motion (Codex)

**Commit tag:** `vis-001f`. Added installed-Icepick drag targets with legality/cost tooltips, card drag previews and dashed hand gaps, VOID pupil tracking, and WATCHER's actual TRACE warning. The existing break API accepts an optional selected Icepick; omitted selection still uses the cheapest legal pick. Added cheery bob/blinks, wary brows, lethal shake/glow, response lunges, break flinch/strike-through, knockout slide and scan peel, background cross-fade, strike-card flight and Mask-off transition. Reduced motion is persistent and available on both selection and encounter screens; it removes ambient/reel motion, flashes and typing without shortening response timing.

**Interpretations to confirm:** FORTRESS bob period is 3.6 s; VOID amplitude is 0.3 px; TUMBLER fidget is ±0.35°. Card snaps are linear 90 ms. The scan's knockout peel moves/tilts without fading its rules, retaining readability. Strike flight is 350 ms and toast entry is 180 ms. Cosmetic blink randomness uses a separate generator, never Game's RNG. WATCHER shows 0 additional TRACE for ECHO or active DECOY SIGNAL. Existing reel glass is omitted over the new scan text. These are presentation choices, not approved rule changes.

**Validation:** Godot 4.3 import, display render, full rules suite **357 passed, 0 failed**. Five new rules regressions cover explicit Icepick selection, unchanged automatic selection/cost, incompatible/missing pick, and insufficient BW; invalid drops spend nothing. No gameplay numbers changed. Display interaction and screenshot fixtures are checked in VIS-001g.

## 2026-11-17 — VIS-001g: live fixtures, readability and interaction regression (Codex)

**Commit tag:** `vis-001g`. Added seven phone-review PNG fixtures: friendly turn 1, wary/lethal turn 3, Cracking, Strike 1, Mask off, DOORBELL CAM card drag and eight-card hand. Updated the existing large-hand test in place for fan browsing and real last-card clicks at 6/7/8/9/10/16 cards. Added native card and selected-Icepick drag checks, actual strike/TRACER/Black ICE checks, tunable moods, hidden VOID rules, reduced-motion timing, BREACH mood and full authored-card text fit. All 112 authored card definitions fit their rule text. Retained ZEROED target borders and paper inspection; response chips flash with the firing rule. CI runs all seven display scripts at a fitting desktop size. The guide/status are updated in place; HANDOFF is the sole task list. Audio was muted during final visual checks at the designer's request; no audio assets or dialogue were changed.

**Interpretations to confirm:** The turn-3 fixture advances two real responses and resolves DISCARD normally. The real conveyor has PULP 6 in slot 1 and a new TRACE 3 in slot 2 after breaking S4; it is not rearranged to force mockup 09's slots. Fixture preparation uses granted cards/BW, and the eight-card hand is deliberately constructed, not a starting-deck claim. Three-mascot boards scale silhouettes to 80% while retaining full-size scans. Longer scans scroll vertically and the response strip scrolls horizontally; hand cards never shrink. Long NUL/REM notes fit by reducing type to a minimum of 8 px. Red buttons/Bloatware headers use toner rather than pale text for contrast. Proposed wording and silhouette choices in VIS-001c remain unapproved.

**Validation:** Godot 4.3 imports; full rules suite **357 passed, 0 failed**. Seven display-backed scripts pass; Friendly Lie has **170 checks, 0 failures**. Large-hand and playtest 2/3 interaction tests report zero failures. Minimum five-second response timing is checked with reduced motion enabled. Thirty seeds per Rustler exactly match the pre-VIS ZEROED/TUMBLE results (including two GENERALIST stalls; not deaths):

```text
sim GENERALIST: 25/30 cleared; deaths by node { "CAPTCHA": 2, "TERMS & CONDITIONS": 1 }; survivors' avg end VITAE 16.2
sim ECHO: 17/30 cleared; deaths by node { "TERMS & CONDITIONS": 9, "CAPTCHA": 3, "CONSENT WALL": 1 }; survivors' avg end VITAE 9.5
sim RIOT: 25/30 cleared; deaths by node { "CAPTCHA": 4, "TERMS & CONDITIONS": 1 }; survivors' avg end VITAE 15.2
sim VECTOR: 20/30 cleared; deaths by node { "CAPTCHA": 6, "TERMS & CONDITIONS": 4 }; survivors' avg end VITAE 10.7
TESTS: 357 passed, 0 failed
```

Average end deck sizes GENERALIST/ECHO/RIOT/VECTOR: 15.03 / 14.83 / 18.27 / 14.87; average bloat tax 0.00 TRACE for each. No gameplay values changed by VIS-001; the optional Icepick-selection API preserves existing default costs/selection. ZEROED/TUMBLE PR #9 was integrated locally before VIS; the visual PR includes that dependency and targets stabilization without pushing to or merging it. Designer visual approval and a Windows playtest remain outstanding.

## 2026-11-17 — CHROME-001 step 1: real encounter layout and readability (Codex)

**Direction:** designer: “I agree with your assessment. Work on those items in that order. Giving samples or examples in png format for each step”. Refine one playable CAPTCHA encounter in Chrome Deco, retaining actual rules and the Rustler paper layer. Working branch is unchanged; this feature locally includes the reviewed VIS-001 PR #11 dependency, which remains open.

**Changed:** larger scan headings, rules and passive text; full-size scan panels; smaller illustration carriers preserve separate actor/flinch transforms. CHAIN tags sit in the rig strip; deck counters use three unclipped lines. Added a per-step screenshot fixture using real Generalist READY RIG, cards, AUTO-RENEW and CAPTCHA. All art/state values remain presentation only.

**Sample:** `01-layout-and-readability.png`. Godot 4.3 stage-1 fixture reports zero failures, including actual card text fit and scan width. **Interpretations to confirm:** two-ICE silhouettes use 82% carriers to give rules more room; three-ICE carriers use 70%. These scales are working presentation values. No gameplay values changed.

## 2026-11-17 — CHROME-001 step 2: chrome/enamel mascot objects (Codex)

**Changed:** layered silver/chrome rims, pearl/mint enamel, restrained Deco ribs and card-corner fan, more substantial speech bubbles and corporate name/wordmark. AUTO-RENEW retains its card/chip silhouette and CAPTCHA its eye/grid widget. Individual face parts and actual mood computations are retained; the Rustler paper layer is unchanged. Speech scales to fit rather than clipping.

**Samples:** `02a-mascots-cheery.png`, `02b-mascots-wary-and-lethal.png`. Godot stage-2 fixture reports zero failures: two actual Corporation Responses produce AUTO-RENEW STR 6 and the actual active CAPTCHA DEADLOCK can be broken to show lethal PULP 6. **Interpretations to confirm:** the six-layer silver rim and small geometric card fan are proposed construction details; the HALCYON wordmark is a placeholder. Background is deliberately still the old placeholder until step 3. No rule values changed.

## 2026-11-17 — CHROME-001 step 3: architectural atrium and illustrated materials (Codex)

**Correction from designer:** “Those dont look anything like Chrome Deco corporate luxury above, photocopied Rustler resistance below”. The first thin-rim samples did not meet the target. A corrected concept PNG established the visual benchmark; this implementation now uses a dedicated pearl/celadon/chrome atrium, illustrated transparent appliance shells and monochrome collage card art. This replaces the blurred app placeholder for HALCYON. Face features, text and controls remain live and separate from artwork; the architecture contains no baked-in game UI. Paper cards and rules retain their own contrast.

**Sample:** `03-welcome-atrium.png`, captured from Godot. Stage 3 reports zero failures for actual rules/cards, scan width and illustration bounds. Fixed TextureRect sizing order so illustrations cannot grow to source-atlas size over rules/neighbouring cards. **Interpretations to confirm:** generated shell art is provisional; six collage motifs are assigned by card role rather than final individual illustrations. Detailed architecture is visible at full opacity; all rule panels remain opaque. This is the revised implementation direction, not a claim of exact pixel identity with the concept. Asset provenance is in the asset folder. No gameplay values changed.

## 2026-11-17 — CHROME-001 step 4: the same atrium reveals its purpose (Codex)

**Changed:** hostile background is an illustrated edit of the same atrium/perspective, revealing clean observation galleries, cameras, processing rails and restraint cradles under controlled red light. Cracking exposes a restrained 20% glimpse beneath the existing warnings; strike 1 switches to the hostile lighting and a sculpted chrome modal; strike 2 keeps the revealed environment. Generated backgrounds contain no game text. The actual Game strike/TRACER/Black ICE transitions still own the state. Paper cards and counters keep their style.

**Samples:** `04a-cracking.png`, `04b-first-strike.png`, `04c-mask-off.png`. Stage-4 Godot fixture reports zero failures, including readable cards/illustration bounds and scan widths in the three-ICE state. **Interpretations to confirm:** 20% Cracking reveal is a working compositing value; scene treatment and generated environment art are provisional. No game rule, TRACE threshold or card insertion behaviour changed.

## 2026-11-17 — CHROME-001 step 5: clear interactions and refreshed five-step review set (Codex)

**Commit tag:** `chrome-001-step5`. Legal subroutine targets get dashed lime outlines and a solid hover border; the separate top-center feedback panel shows the actual selected Icepick, target, BW cost and MARGIN, or the engine's rejection reason. Successful breaks confirm actual BW spent and update the struck rule/mood. The drag cursor is small; duplicate native tooltips are suppressed during drag to avoid covering rules. Raised/targeted hand cards get a lime paper edge. Normal click-to-break, hidden rules, immediate TUMBLE and reduced motion remain. Eight UI scripts run in CI, including native compatible/incompatible Chrome drags and bounded card illustrations. No core Game/CardDB/IceDB files or rule values were changed by CHROME-001.

**Samples:** ten separate full-screen Godot PNGs: 01 layout, 02a cheery / 02b wary-lethal, 03 atrium, 04a Cracking / 04b strike / 04c Mask off, 05a legal target / 05b broken rule / 05c incompatible target. The first two steps were refreshed with the revised art and supersede the rejected flat/thin-rim samples. These are live captures, distinct from the generated concept benchmark. All samples are committed under `docs/visual/fixtures/chrome-001/`; workspace downloads also have a ZIP.

**Validation:** Godot 4.3 imports; **357 rules checks passed, 0 failed**. All eight display-backed scripts exit 0 without script/assertion errors. Friendly Lie remains **170 checks, 0 failures** (including all 112 authored card texts); large-hand/playtest2/playtest3 checks report zero failures. All five per-step Chrome fixtures report zero failures, including native selected-pick cost/confirmation, incompatible-target explanation and no payment on a rejected drop. Render review caught and fixed an atlas TextureRect sizing issue; card illustration bounds are now checked. Thirty seeds per Rustler reproduce the pre-Chrome baseline:

```text
sim GENERALIST: 25/30 cleared; deaths by node { "CAPTCHA": 2, "TERMS & CONDITIONS": 1 }; survivors' avg end VITAE 16.2
sim ECHO: 17/30 cleared; deaths by node { "TERMS & CONDITIONS": 9, "CAPTCHA": 3, "CONSENT WALL": 1 }; survivors' avg end VITAE 9.5
sim RIOT: 25/30 cleared; deaths by node { "CAPTCHA": 4, "TERMS & CONDITIONS": 1 }; survivors' avg end VITAE 15.2
sim VECTOR: 20/30 cleared; deaths by node { "CAPTCHA": 6, "TERMS & CONDITIONS": 4 }; survivors' avg end VITAE 10.7
TESTS: 357 passed, 0 failed
```

GENERALIST also has two stalls, counted separately from deaths. Mean end decks GENERALIST/ECHO/RIOT/VECTOR: 15.03 / 14.83 / 18.27 / 14.87; average bloat tax 0.00 TRACE each.

**Interpretations to confirm:** 2.5-second break confirmation and header placement are working UI choices. Illustrated shells, shared collage motifs and detailed backgrounds remain prototype art; final fidelity to the concept and undrawn ICE/copy await designer review. This implements one encounter direction, not a completed whole-game art collection. Audio development, Windows export and manual Windows playtest are deferred. One feature PR targets stabilization and includes unmerged PR #11/#9 dependencies; nothing was merged or pushed directly to the working branch. The guide/status/HANDOFF are updated in place; design documents and Claude project copies are unchanged.

**Sample delivery:** `chrome-001-review` stores the ten selected PNGs. The download ZIP excludes unrelated regression screenshots; `chrome-001-step5` identifies the implementation commit.

## 2026-11-17 — CHROME-001 plaque revision: pearl enamel instead of black ICE panels (Codex)

**Commit tag:** `chrome-001-enamel`.

**Designer request:** “The black backgrounds on the ice in the images don’t work with the rest of the design. Find an appropriate change … atomic age /art deco / clean friendly corporation design.” Also: “Once approved, commit pr #12 to the shared game branch.” This authorizes the revision and a merge after designer approval of the result; no merge is performed in this revision.

**Changed:** the ICE rule surfaces are now corporate pearl-enamel service plaques with dark slate text, silver edges/soft shadows, a restrained teal service mark and corporate heading font. Hidden/broken chips use pale surfaces while preserving dashed borders and strike-through. Costs remain legible; TUMBLER reel frames match the enamel. Legal target outlines use dark teal instead of lime against the light panels; invalid targets remain red. The Rustler paper/toner hand/HUD remain distinct. Dark hostile mascot shells still communicate Mask off; this removes the large black rule rectangles beneath them without hiding any rules.

**Validation:** Godot 4.3 import and 357 rules checks pass; Friendly Lie 170 checks pass; all five Chrome screenshot stages pass, including actual legal/incompatible native drops and no payment on invalid drops. Refreshed ten full-screen PNGs and the download ZIP. Calculated text contrast: slate/enamel 11.64:1, muted text/enamel 6.25:1, muted text/broken chip 5.51:1, teal/enamel 7.06:1. No rule values changed. The five-step samples in the existing PR are updated in place.

**Interpretations to confirm:** enamel plaques stay clean even in Mask off, reinforcing the corporation's immaculate administrative cruelty. Pearl #EDF4F0, slate #20343B and teal #165B55 are working presentation colors. Final art/fidelity approval remains with the designer. PR #12 remains open targeting `codex/halcyon-playtest-stabilization`; merge is pending that approval.

## 2026-11-17 — CARDS-001: heavy type-specific 1950s slot cartridges (Codex)

**Designer request:** distinct templates for Scripts/other types, subtle common/uncommon/rare differences, vacuum tubes/transistors/exposed wiring/metal/resistors; cards should feel heavy with protruding parts and BW costs mostly outside the white interior. The designer said “Looks good” to the blank carrier art; integrated rules/layout remain for review. No merge authorization for this finished revision is inferred from that art feedback.

**Changed:** SCRIPT stamped steel/Bakelite fuse-and-resistor carrier; PROGRAM cast-aluminum/tube/transistor cassette; PROTOCOL celadon relay/terminal module. Paper labels and live rules sit on the chassis. BW mounts on the upper-right metal tab. Common is plain/single-notch, uncommon has two notches and a brass fitting, rare three notches and fine double-metal detail; full authored rarity labels remain. STARTER and BLOAT classifications remain. Three generated frames are prototype art; Bloatware retains its corporate treatment. Cards are 164×244 with component bounds extending 10 px sideways / 12 px vertically. A shallower hand fan, raised hand/rack spacing and padded choices protect the hardware; protrusions participate in hit-testing. Reward offers and inspection use the same carriers. No card definitions, rarity weights, costs or rules changed.

**Validation:** Godot 4.3 imports; 357 rules pass and 30-seed bot summaries match the pre-card baseline (GENERALIST/ECHO/RIOT/VECTOR clears 25/17/25/20, survivor VITAE 16.2/9.5/15.2/10.7). Nine UI scripts pass. Cartridge fixture: 612 checks / zero failures, including all 112 authored rule texts, the longest legal shared-tag compiled SCRIPT pair, actual rarity, illustration bounds and 6-/8-/16-card protrusion bounds. Existing native hand clicks, HOLD/READY RIG, reward, SCAN/CULL/ZEROED/TUMBLE and five-second reduced-motion response checks remain. Nine individual close-up PNGs plus six/eight-card encounter captures are in `docs/visual/fixtures/cards-001/` and the downloadable ZIP.

**Review:** physical finish details and motif reuse are proposed art choices. Labels/costs remain live data; no gameplay is baked into textures. The revised PR #12 remains open against the shared game branch and awaits designer approval before merge. Audio/Windows export are outside this task. Asset provenance, guide, status and the shared HANDOFF are updated in place.

## 2026-11-17 — CARDS-001: integrated light faces and printed titles (Codex)

**Commit tag:** `cards-001-lightfaces`.

**Designer feedback:** black title backgrounds and dark beige card faces do not fit the chassis. Removed the opaque black title strip; dark titles now print directly on each inset face with a restrained separator. Generated edits preserve the three carriers and change only the blank face: near-white ivory instruction stock for SCRIPT, cool pearl instrument plate for PROGRAM, pale celadon enamel for PROTOCOL. Hardware, protrusions, outside BW tab, rarity details, authored metadata and rules are unchanged. The corporate Bloatware treatment remains separate.

**Validation:** 357 rules checks and 612 cartridge UI checks pass, including authored/compiled text fit and protruding bounds. Five Chrome stages pass; refreshed nine close-ups, six/eight-card captures and ten encounter review PNGs. The earlier dated whole entry was appended unchanged to the archive under LOG-001 to keep this live log below about 60 KB.

**Review:** material tint and direct-print title treatment are proposed visual refinements. PR #12 is updated, not merged; designer approval of the integrated revision is still required under the existing merge instruction. No gameplay data, rarity odds or costs changed.

## 2026-11-17 — CARDS-001: selected board colours and Whirlwind Bloatware (Codex)

**Commit tag:** `cards-001-board-palette`.

**Designer choices:** A/C/D board colours selected for card faces; Whirlwind #3 selected as Bloatware prototype. The pale Bloatware plate was rejected (“No card should have a white background for the text”). Brown Bloatware was then rejected for matching SCRIPT; oxide-red D received “Perfect”. That confirms the D material choice; no approval of the entire PR/merge is inferred.

**Changed:** tobacco-brown SCRIPT, earthy olive PROGRAM, muted blue-green PROTOCOL; direct light printing on real board-style textures. BLOATWARE now has the Whirlwind-inspired protective U-handle, paired tubes, open cage/stacked boards and oxide-red phenolic face. Names, costs and rules are live controls. TRACER/SPAM remain BLOATWARE with unchanged unplayability/clear/TRACE rules; both now use the same component-aware bounds as other cartridges. Cached Bloatware retains full rules and CACHED marker; optional corporate flavour footer yields space when cached. No white card text panels remain. A–D review labels denote the four types; source-reference letters A/C/D remain palette provenance.

**Validation:** Godot 4.3 import, 357 rules checks and 170 Friendly Lie UI checks pass. Extended cartridge fixture passes 625 checks and covers all authored/compiled texts, both Bloatware examples including cached text, component bounds and a mixed-type hand. Selected older log entry appended unchanged to the archive under LOG-001. Asset sources/guide/status/HANDOFF and PNGs are updated. No card definitions, rarity weights, costs or gameplay values changed. PR #12 remains open for integrated review before merge.

## 2026-11-17 — CARDS-001: instrument amber accents (Codex)

**Commit tag:** `cards-001-amber`. Replaced neon yellow-green with warm instrument amber (`#D6B675`) for the shared highlight and printed numeric highlights. The brass/gauge reference fits the selected brown, olive, teal and oxide-red boards. BW badges, selection accents and shared HUD controls inherit the same colour. No rules or costs changed.

**Interpretations to confirm:** exact amber hue is a visual proposal for designer review. PR #12 remains open.

**Validation:** 357 rules checks and 625 cartridge UI checks pass; updated four-type PNG rendered from live Godot controls.

## 2026-11-17 — CARDS-001: glowing text instead of amber blocks (Codex)

**Commit tag:** `cards-001-amber-glow`. Designer requested glowing amber text instead of highlighted backgrounds. Numeric rule text now uses warm amber ink (`#F2CD87`) with a faint translucent amber halo; removed rectangular fills. External BW badges use a dark instrument face and glowing amber numerals. Board textures stay visible.

**Interpretations to confirm:** restrained halo intensity and dark BW instrument face are proposed treatments. No gameplay changes. 625 cartridge UI checks pass; refreshed live-control comparison and card/hand PNGs. PR #12 remains open for review.

## 2026-11-17 — CARDS-001: distinct board surface textures (Codex)

**Commit tag:** `cards-001-board-textures`. Added subtle stationary procedural material grain behind card printing: pressed phenolic fibres for brown SCRIPT, woven laminate for olive PROGRAM, brushed resin for teal PROTOCOL, mottled Bakelite for oxide-red BLOATWARE. Inset feathered bounds protect chassis and contacts; text/illustrations draw above the texture. Existing palette and amber text glow retained.

**Interpretations to confirm:** these four material patterns and their restrained intensity are proposed for review. No gameplay changes. 625 cartridge UI checks pass. Refreshed four-type comparison and card/hand fixtures. Oldest whole log entry appended unchanged to the archive under LOG-001.

## 2026-11-17 — VISUAL-DECISIONS-2026-11-17: approved visual decisions recorded in the master design doc (Claude)

**Designer instruction:** record the approved visual decisions from VIS-001, CHROME-001 and CARDS-001 in `REDLINE_MASTER_DESIGN.md`, leaving out everything still waiting for review. Added the VISUAL-DECISIONS-2026-11-17 table after the Raygun Gothic section: The Friendly Lie, Atomic Salvage deprecated, 6-card draw, Chrome Deco encounter, no black ICE rule panels, type-specific cartridges, A/C/D board colours, no white card text backgrounds, oxide-red Whirlwind Bloatware, glowing amber numbers. Each row quotes the designer and cites its commit. Final art, working values and Interpretations to confirm stay in HANDOFF *Waiting on the designer*. LOG-001: the oldest whole entry (DSY-001/002/003/006, 2026-11-15) moved unchanged to the archive. **Code changes:** none.

## 2026-11-17 — MAIN-001: HANDOFF points to main (Claude)

**Designer instruction:** fix the contradiction between `HANDOFF.md` and the shared working agreement. Rule 1 now says to work on `main` under `AGENTS.md` / `CLAUDE.md` (the former working branch was merged at a523502); rule 2 and the session-start step say `main`. Added a MAIN-001 row to *Done*. **Found, not changed:** `.github/workflows/godot-validation.yml` only runs the Windows export on pushes to `codex/halcyon-playtest-stabilization` or `codex/zeroed-tumble-2026-11-16`, so pushes to `main` never export. CI belongs to Codex; raised with the designer. **Code changes:** none.

## 2026-11-17 — MAIN-001: Windows export runs on main (Claude)

**Designer instruction:** make the Windows export run from `main`. In `.github/workflows/godot-validation.yml`, the three Windows steps (install template, export, upload) now run on pushes to `main` instead of `codex/halcyon-playtest-stabilization` / `codex/zeroed-tumble-2026-11-16`. Validation, rules and screenshot steps are unchanged; the workflow still triggers only on changes under `godot/` or to the workflow file. HANDOFF's deferred Windows line updated to match.

## 2026-11-17 — RUSTLER-LOOK-001: two Rustler styles kept on purpose (Claude)

**Designer decision:** "B Each corp will have a different look. The HUD will probably change in the near future, but I want to keep it this way for now." The CARDS-001 hardware cards and the zine HUD/tags/END TURN/NUL/REM notes stay as they are; this is recorded as a deliberate exception to Visual Language Rule 1. Added RUSTLER-LOOK-001 to the master design doc and an amendment note under Rule 1 in `REDLINE_VISUAL_LANGUAGE.md`. **Code changes:** none.

## 2026-11-17 — VISUAL-APPROVALS-002: prototype art and working values approved (Claude)

**Designer decision:** "Okay, all those changes that you listed are all approved." Covers the CHROME-001 art review, CARDS-001 as a whole, and the VIS-001 details (hand size, lethal threshold, undrawn ICE silhouettes and wording, motion timings, Cracking after a strike). Recorded as VISUAL-APPROVALS-002 in the master design doc with the approved values. HANDOFF: the two matching *Waiting* rows moved to *Done*; the CARDS-001, CHROME-001 and VIS-001 *Built* rows note art approval with playtest still pending. The rules questions in *Waiting* are not covered. **Code changes:** none.

## 2026-11-17 — CHROME-001 / CARDS-001 / MAIN-001 follow-up (Codex)

Refreshed ten CHROME-001 PNGs from `main` with Godot 4.3. All five capture stages passed. Amber numbers on brown SCRIPT faces are harder to read. Synced status and handoff and documented nine assets, including oxide-red Whirlwind Bloatware. Exact prompts/model IDs and the corrected concept PNG were unavailable. No Windows export. LOG-001 moved the oldest whole live entry to the archive unchanged.

## 2026-11-17 — DEPRECATE-001: LOGIC BOMB and RELAY deprecated (Claude)

**Designer decision:** "Let's deprecate logic bomb and relay for now. They don't work in the current rules environment." Recorded DEPRECATE-001 in the master design doc. Marked deprecated, not deleted, in Card Pools (LOGIC BOMB), ICE Passives, Core Rules §passives, Deck Synergy, ICE Corp 1 and the ICE Rules Bible (RELAY). CONSENT FORM and SWITCHBOARD have no passive for now. HANDOFF: ZEROED-001 interpretation closed; new Codex TO DO row to remove both from the build. Note: the approved CARDS-001 fixture `script-rare-logic_bomb.png` still shows LOGIC BOMB as a rarity sample. **Code changes:** none.

## 2026-11-17 — READ-001: darker SCRIPT face for legible printing (Claude)

**Designer instruction:** "make the contrast stronger so that the brown script cards are legible" (after Codex reported amber on brown SCRIPT was hard to read). Measured on the CARDS-001 fixtures: SCRIPT face (127,102,74) gave amber 3.55:1 and ivory 5.12:1 (amber below 4.5:1); PROGRAM amber 6.91:1. **Changed:** `godot/scripts/ui/friendly_lie/card.gd` adds a soft-edged `ScriptFaceShade` (#2A1C10 at 55%) over SCRIPT's face only, below the board grain, fitted to the face bounds measured from `script.png` (11,21,139,188). Result: face about (83,64,44), amber about 6.5:1, ivory about 9.3:1. Brown stays brown; chassis art, textures, colours of other types, rules and costs are unchanged. **Validation:** Godot 4.3 import; rules 357 passed, 0 failed; cartridge UI 625 checks, 0 failures; Chrome stages 1–5, 0 failures. Refreshed SCRIPT and encounter PNGs in `fixtures/cards-001/` and all ten in `fixtures/chrome-001/`; `four-card-types.png` is not produced by a checked-in script and was not refreshed. **Not changed:** PROTOCOL's blue-green face measures amber 4.18:1, also under 4.5:1; raised with the designer. Committed with [skip ci]: no Windows build.

## 2026-11-17 — PULP-001: FORTRESS PULP rolled each time (Claude)

**Designer decision:** "For number 4, they are rolled each time. They should be slightly variable so that the rustler can plan to some degree." Reverses the 2026-11-13 working assumption (fixed per subroutine). Recorded in the master design doc and the ICE Rules Bible. The roll's width, its on-screen display and its relation to PULP-002 curves are open; HANDOFF's PULP-001 row now asks those questions. Nothing to build until they're answered. **Code changes:** none.

## 2026-11-17 — RIOT-003: SHATTER readings confirmed (Claude)

**Designer decision:** "For number 3, that is correct." SHATTER lets SLEDGE break any one chosen ICE of any type this turn; SLEDGE then stays at STR 0 until the encounter ends and returns to STR 2 next encounter. Matches the build, so nothing changes in code. Recorded in the master design doc and Rustlers doc; HANDOFF row moved to *Done*.

## 2026-11-17 — REEL-001 follow-up closed; TUMBLE-001 reaffirmed (Claude)

**Designer:** a broken TUMBLER subroutine disappears at once and the next unbroken subroutine in sequence tumbles in; TUMBLERS still rotate once each turn. This is TUMBLE-001 (approved 2026-11-16, built `zeroed-tumble-step3`), so no DEADLOCK counter is needed. Added TUMBLE-001 to the master design doc (it was only in Core Rules) and closed the REEL-001 follow-up in HANDOFF. **Code changes:** none.

## 2026-11-17 — ICE-AUDIT-001 applied; PULP-001 roll size (Claude)

**Designer decisions:** "apply the changes to the Halcyon ICE now. That is before the playtest." and "the roll should be +2, -2 with once every 3 to 4 turns, a +3 or a -3." In-session choices: CAPTCHA's PULP 6 becomes TRACE 2; CONSENT FORM and REJECT ALL PULP 4 become PULP 3; the ±3 swing is a random ~30% chance, not a fixed rhythm. **Recorded:** ICE-AUDIT-001 and the PULP-001 roll in the master design doc; ICE Corp 1 §5.0 slice table; ICE Rules Bible audit note; Core Rules PULP X row. **Assumptions stated for confirmation:** a roll never goes below PULP 1; −2..+2 equally likely; ±3 sign 50/50; Game RNG. **HANDOFF:** two Codex TO DO rows (ICE-AUDIT-001, PULP-001 roll); new WAITING row PULP-001 display (pre-fire display, curves, lethal-mood threshold). **Code changes:** none.

## 2026-11-17 — PULP-001: rolled PULP is always shown before it fires (Claude)

**Designer:** "the rustler is always going to see what pulp damage the corporation is going to deliver next turn with that subroutine. So there is no surprise for the rustler." Recorded in the master design doc and Core Rules: the roll is made ahead of time (working timing: start of the Rustler turn), shown as an exact number, and that value fires; the lethal mood reads it. HANDOFF build row updated; the WAITING row now only asks about PULP-002 curves, including curve B's "PULP ?". **Code changes:** none.

## 2026-11-17 — PULP-001: curves keep their patterns and show their next value (Claude)

**Designer:** approved Claude's recommendation ("Yes, record it that way."). PULP-002 curves A/B/C do not get the ±2/±3 roll; all curves show their next value before firing, so curve B drops "PULP ?". Recorded in the master design doc and Core Rules §5.2; HANDOFF build row updated, WAITING row closed. **Code changes:** none.

## 2026-11-17 — READ-001 extended to PROTOCOL; PULP-001 swing direction (Claude)

**Designer:** "yes, apply the same contrast fix as script" for PROTOCOL, whose blue-green face measured amber 4.18:1. `card.gd` now applies the soft face shade per type: SCRIPT #2A1C10 at 55%, PROTOCOL #0C1E1C at 45% (fitted to the face measured from `protocol.png`, 14,28,136,182). Measured after: PROTOCOL amber 6.68:1 / ivory 9.62:1; SCRIPT 6.69 / 9.64; PROGRAM unchanged 6.91 / 9.97. Validation: rules 357/0, cartridge UI 625/0, Chrome stages 1–5 0 failures; cards-001 and chrome-001 fixtures refreshed. Committed with [skip ci].
**Designer:** "big swings equally likely up and down is okay" (PULP-001 ±3 sign 50/50), recorded in the master design doc. The start-of-turn roll timing and equal odds within −2..+2 remain working values.

## 2026-11-17 — Archive retired branches (Codex)

At the designer's request, pushed and verified annotated archive tags for `docs/simplified-design` (`c42adc5`), `dev/training-node` (`61c1a8b`), `codex/playtest3-windows-smoke` (`af580e2`) and `backup/pre-authoritative-docs-2026-11-10` (`c87436e`). Verified the other eleven tips were ancestors of `main` before deleting all fifteen remote branches. Only `main` remains. PRs #1 and #3 are closed. Posted the archive link on PR #1 and updated the repository structure reference. LOG-001 moved the oldest whole entries to the archive unchanged.

## 2026-11-17 — FACADE-001: Raygun Gothic facades for IRONWATCH and LUCIDA proposed (Claude)

**Designer instruction:** fit the Raygun Gothic direction to the corporation backgrounds and ICE. Added `REDLINE_CORPORATE_FACADES.md` (PROPOSED): a three-degrees table (HALCYON home / IRONWATCH street / LUCIDA mind: what each asks for, remembers and rewards); a shared Raygun Gothic kit; for IRONWATCH a civic security concourse (searchlight-fan motif) and for LUCIDA a wellness solarium (halo-orbit motif), each with a same-perspective hostile reveal, plaque colours (contrast checked: ink 13.8 / 12.6:1, accent 5.6 / 7.1:1), non-fight interface copy, strike and Mask-off lines, and every main-roster, Opening, Central and Black ICE as an appliance with silhouette, face, DEADLOCK button and cheery/wary/lethal lines; art-generation briefs matching the HALCYON asset format, with prompts to be recorded at generation time. Pointers added to Visual Language §2.3 and ICE Corp 2/3 §1; HANDOFF WAITING row FACADE-001. Nothing approved; master design doc unchanged. **Code changes:** none.

## 2026-11-17 — Playtest checklist v0.3 and the live QA Sheet (Claude)

Closes HANDOFF "Checklist v0.2". The live Sheet (claude.ai artifact "REDLINE Playtest QA Checklist", last changed 2026-11-15) was still on v0.1.1: updated B1/C1/K1 targets to the PACE values and added C9–C11 and G6–G11. `REDLINE_PLAYTEST_CHECKLIST.md` is now v0.3 with checks for today's decisions: C12–C14 (rolled PULP shown and dealt, plannable swings, curves show next value), C15 (TUMBLE-001), C16 (ICE-AUDIT-001), D4 (RIOT-003), L5 (READ-001), L6–L8 (moods, corporation states, visual coherence), M5 (DEPRECATE-001); the Sheet carries the same 82 rows. HANDOFF: PR #1 row closed (archived by Codex in 65a47f2). **Code changes:** none.

## 2026-11-17 — DEPRECATE-001: remove LOGIC BOMB and RELAY (Codex)

Removed the card and passive from runtime. CONSENT FORM retains its STR and subroutines. Updated regression coverage and replaced the rare SCRIPT sample with PAYDAY.

**Interpretations to confirm:** The slice has no persisted run decks, so no legacy LOGIC BOMB runtime definition is needed. PAYDAY is the replacement sample.

## 2026-11-17 — ICE-AUDIT-001: apply HALCYON slice changes (Codex)

Applied the five approved ICE edits. DOORBELL CAM uses the existing VOID reveal progression and keeps WATCHER. Updated regression fixtures for the new values. Rules suite: 357 passed, zero failed.

## 2026-11-17 — PULP-001: publish FORTRESS rolls before the response (Codex)

A seeded roll at the start of the Rustler turn is shared by the ICE, response strip, mood and resolution. PULP-002 curves keep their sequences and publish the next value, including curve B. SCRAMBLE applies after the roll.

**Interpretations to confirm:** Each eligible unbroken subroutine gets an independent roll at turn start, even if the response is later skipped. Revealed effects drive mood; a hidden CORTEX subroutine does not tip off the player.

## 2026-11-17 — Validate HALCYON and refresh fixtures (Codex)

Godot 4.3 import passed, as did all 363 rules checks and all nine screenshot scripts, including 173 Friendly Lie and 621 cartridge checks and all five Chrome stages. Refreshed VIS-001, CHROME-001 and the three CARDS-001 encounter captures. The rare PAYDAY close-up was replaced in DEPRECATE-001. The other card close-ups matched their committed renders byte-for-byte. Design reference images were preserved.

VIS-001 turn 3 now shows wary AUTO-RENEW and wary CAPTCHA, with TRACE 2 and TRACE 3 on CAPTCHA. CHROME-001 02b shows lethal AUTO-RENEW from its rolled PULP 6 and wary CAPTCHA with those same TRACE slots. CHROME-001 04a/04b start at turn 1 with wary mascots. In 04c, Mask Off still forces all mascots lethal.

Seeds 100–129 per Rustler. Deaths are by Node and exclude 3,000-step guard stalls. No balance changes were made in response.

| Rustler | Clears (baseline → now) | Deaths by Node (baseline → now) | Mean survivor VITAE |
|---|---:|---|---:|
| GENERALIST | 25 → 21 | CAPTCHA 2 → 6; TERMS & CONDITIONS 1 → 1; DOORBELL 0 → 2 | 16.2 → 17.0 |
| ECHO | 17 → 11 | CAPTCHA 3 → 4; TERMS & CONDITIONS 9 → 14; CONSENT WALL 1 → 1 | 9.5 → 11.8 |
| RIOT | 25 → 13 | CAPTCHA 4 → 3; TERMS & CONDITIONS 1 → 6; DOORBELL 0 → 7 | 15.2 → 16.2 |
| VECTOR | 20 → 17 | CAPTCHA 6 → 2; TERMS & CONDITIONS 4 → 10; DOORBELL 0 → 1 | 10.7 → 11.5 |

The baseline had two GENERALIST stalls. This run had one RIOT stall at DOORBELL. Adding rolls to the seeded Game RNG changes which random draws are consumed by other systems, so this comparison measures the combined changes.

**Interpretations to confirm:** Kept the existing chronological PNG filenames even where the named mood now belongs to a different ICE or is absent. The four-type still comparison has no affected card or encounter state. No Windows build was started.

LOG-001 moved the oldest whole live entries to the archive unchanged.

## 2026-11-17 — FACADE-001 approved (Claude)

**Designer:** "Correct. Approved." `REDLINE_CORPORATE_FACADES.md` is approved as written and recorded as FACADE-001 in the master design doc (three degrees of watching; IRONWATCH concourse and LUCIDA solarium with their hostile reveals; plaque colours; interface copy; ICE appliance list; art briefs). Status lines updated in the facades doc, ICE Corp 2/3 and Visual Language §2.3. HANDOFF: FACADE-001 moved to *Done*; its open questions 4–6 (HALCYON copy, when to generate art, escape ICE) remain WAITING. No art generated yet. **Code changes:** none.

## 2026-11-17 — FACADE-001 follow-ups: HALCYON copy, art now, escape ICE later (Claude)

**Designer:** "for number one, yes. For number two, yes. And for number three, wait." Wrote §2a in `REDLINE_CORPORATE_FACADES.md`: HALCYON's motif (sunrise fan) and non-fight copy (consent, remembered, reward proposed; status, cracking, strike and Mask-off lines reuse approved VIS-001 copy). Art for IRONWATCH and LUCIDA is to be generated now: HANDOFF Codex TO DO FACADE-ART-001. Escape ICE deferred. Master design doc FACADE-001 updated; HANDOFF WAITING row for the HALCYON copy review. **Code changes:** none.

## 2026-11-17 — FACADE-ART-001: IRONWATCH and LUCIDA art (Codex)

Generated the 1586 × 992 concourse and solarium pairs from the approved briefs. Both hostile scenes were edited directly from their friendly originals. Cropped fourteen transparent Opening and Tier 1 shells from the two generated sheets. Recorded exact prompts, both hostile edits, the IRONWATCH retry, and references in `godot/assets/friendly_lie/chrome/SOURCES.md`. The skins provide the new art, opaque porcelain and pearl plaques, and approved Cracking and Strike copy. Escape ICE art is deferred.

Validated with Godot 4.3 import, 363 rules checks, and eight `shot_facade.gd` captures in `docs/visual/fixtures/facade-001/`. Lowest measured plaque contrast, including the Strike scrim, was 5.20:1 for IRONWATCH and 5.47:1 for LUCIDA. No plaque contains image textures. HALCYON's existing Friendly Lie regression passed 173 checks. No Windows build.

**Interpretations to confirm:** FRONT DESK and INTAKE are presentation fixtures using their documented Opening ICE. They hold their roster across the four states to review the artwork without implementing a new route or Black ICE. Mask Off previews the hostile environment and mood. The hostile edits maintain visually aligned framing, with small local rendering differences.

## 2026-11-17 — FACADE-001: HALCYON non-fight copy approved (Codex)

Designer approved the consent, remembered activity and reward lines as written in Facades §2a and will review them in playtesting. Recorded the approval in the master design and moved the decision to Done in HANDOFF.

## 2026-11-17 — HALCYON PLAYTEST 4 Windows build (Codex)

Godot 4.3 pre-flight passed 363 rules checks and all ten screenshot scripts (five Chrome stages, 173 Friendly Lie checks, 621 cartridge checks). Seeds 100–129 reproduced 21/11/13/17 clears and 17.0/11.8/16.2/11.5 mean survivor VITAE for GENERALIST/ECHO/RIOT/VECTOR. One RIOT run stalled at DOORBELL.

Tagged `b6b0971e017e6e88929ff1a4a6e67cadfaa2f516` as `playtest-4`. [Actions validation and export](https://github.com/Punkwork/REDLINE/actions/runs/44202252857) passed and uploaded `PANOPTICON-HALCYON-PLAYTEST-4-0.4.0-playtest.4-Windows-x86_64`. Verified `BUILD_COMMIT.txt`, the guide and checklist v0.3, and the executable SHA-256 `3736797caa582f92110473758f235397fe16b12373ea6f829d51b8bf8b16d8b2`. Windows launch and playtest are pending with the designer.

## 2026-11-17 — Playtest checklist v0.4 for HALCYON PLAYTEST 4 (Claude)

**Designer instruction:** update the REDLINE Playtest QA Checklist with appropriate changes for the new build. `REDLINE_PLAYTEST_CHECKLIST.md` v0.4 and the live Sheet (now 84 rows) both: tie to build b6b0971 (`playtest-4`); add A3 (confirm build and BUILD_COMMIT; scope is HALCYON's first four rows, so IRONWATCH, LUCIDA, Central Node H3/J1/J2 and whole-corporation totals G5/I2/K2 are N/A) and L9 (Icepick drag feedback, CHROME-001); drop the *(after …)* marks on C12–C14, C16 and M5 now that they're built, with the built details (turn-start roll, SCRAMBLE, DOORBELL CAM reveal order, AUTO-RENEW STR 5 vs CAPTCHA STR 4). Run log gains a Build column. **Code changes:** none.

## 2026-11-17 — Atomic Deco Punk design direction (Codex)

Recorded the designer’s term and brief in the master design document. The direction covers corporate scale alongside hand-built elektronix, with visual design leading the tone, language, sound and emotional experience. Sound examples are directions to explore in playtesting. LOG-001 moved the oldest whole live entries to the archive unchanged.

## 2026-11-17 — ADP-001 Phase 1 (Codex)

- **ADP-1a.** Pure presentation bleed curve, 400 ms ease, instant reduced motion and a TRACE-tag bleed readout. Added table and easing tests.
- **ADP-1b.** Linked the Cracking reveal to bleed, from 20% at TRACE 20 to 60% at TRACE 39. Strike and Mask Off retain the full hostile background.
- **ADP-1c.** Added a perimeter-only wear shader, lifted tape, and decorative barcodes on Node and TRACE. The barcode flicker stops with reduced motion.
- **ADP-1d.** Three synchronized synthesized stems, tempo-preserving corporate pitch DSP, strike chime, and saved music level and mute.
- **ADP-1f.** Added Poiret One and OFL provenance. Only the corporate wordmark (36 px), background line (28 px), and strike headline (68 px) use the face.
- **ADP-1e.** Added mechanical sounds for accepted card play, Icepick drag, completed breaks, END TURN and Bloatware insertion. Hover is silent.

The full Godot 4.3 rules suite passed unchanged after each task (363 checks). The phase added 17 unit checks and 448 capture, contrast, and interaction checks. The four PNGs and 11-second in-engine MP3 are in `docs/visual/fixtures/adp-001/`. No Windows export.

**Interpretations to confirm:**
- The rig shader treats the outer 3 px and a shadow offset up to 2 px. Tape lifts outside the lower corner and the barcode flicker starts above 0.6. The 0.40 still captures the midpoint of the eased 20-to-39 TRACE reveal.
- The short synthesized cues, mix points, LFO rates, and gains are placeholders in `godot/data/atomic_deco_punk.json`. The parallel corporate DSP feed shares the synchronized transport because Godot 4.3 exposes gain only on its synchronized tracks. Reduced motion also disables pitch wobble. Music mute covers the stems and strike chime. Mechanical sounds remain audible.
- The facade headlines use “Good morning.”, “Your block is safe.” and “Breathe in.” on solid corporate displays. The HUD checks verify the new display and readout colours. The inherited noninteractive Strike underlay remains dimmed.
- “Card seated” means an accepted hand play. A relay clunk marks a completed break, and a tape tear marks an insertion batch, including the first strike's TRACER.

LOG-001 moved the oldest whole live entries to the archive unchanged.

## 2026-11-17 — ADP-001 Phase 1 confirmations (Codex)

Designer confirmed all four implementation interpretations from `53b00d7`: rig wear and the midpoint fixture, placeholder mix and reduced-motion audio behavior, Poiret One copy and sizes, and mechanical cue triggers. Recorded the approval in the master design document.

## 2026-11-17 — HAND-CLEANUP-001 and CARD-CONTROLS-001 (Codex)

Removed free HOLD and documented non-CACHED discard and base draw of six. Moved installed PROGRAMs to a left HUD bay with inspection and controls. Added drop zones for PROGRAMs and SCRIPTs and centered right-click inspection at 150%. Preserved existing response order, card-granted CACHE, draw modifiers and keyboard play. Windows export deferred.

**ENCOUNTER-DISPLAY-001:** Anchored all backdrop layers to the viewport. Scaled ICE avatars and faces to 125%, with separate rules plaques.

**Validation:** Godot 4.3 import and 361 rules checks passed. The ADP fixture passed 471 checks, including the wide encounter, backdrop layers and avatar scale.

LOG-001: The oldest entry, ZEROED-001 and TUMBLE-001 readings confirmed (2026-11-16), moved to the archive unchanged.

## 2026-11-17 — HALCYON PLAYTEST 5 Windows build (Codex)

Exported `0.5.0-playtest.5` for Windows x86-64 from `98bad5f411adc9d30f59c4443288f9473a0067b9` (tag `playtest-5`). Local Godot 4.3 import passed, along with 361 rules checks, 17 ADP checks and all 11 screenshot scripts. GitHub Actions validated the push and uploaded the artifact. The downloaded `BUILD_COMMIT.txt`, README and QA checklist v0.5 matched the source, and the executable's SHA-256 verified as `f70ee7a007e564bbe78d5a7546a5756a08bad48a7513d9bfdca479d92221c0dd`. Windows launch and playtest remain pending with the designer. [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/44232607877) · [Windows artifact](https://github.com/Punkwork/REDLINE/actions/runs/44232607877/artifacts/14395388972)

| Rustler | Clears / 30 | Deaths by Node | Survivor mean VITAE | Stalls |
|---|---:|---|---:|---|
| GENERALIST | 19 | CAPTCHA 6, TERMS & CONDITIONS 5 | 13.0 | 0 |
| ECHO | 13 | TERMS & CONDITIONS 14, CAPTCHA 1, DOORBELL 2 | 13.8 | 0 |
| RIOT | 16 | DOORBELL 4, CAPTCHA 3, TERMS & CONDITIONS 5 | 18.4 | 2 at DOORBELL |
| VECTOR | 15 | CAPTCHA 5, TERMS & CONDITIONS 9, CONSENT WALL 1 | 11.2 | 0 |

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — VIS-001: visual language "The Friendly Lie" handed to Codex (Claude).

## 2026-11-18 — ZINE-002, ARCH-001: the zine as samizdat; the Archipelago (Claude)

Design session in claude.ai, synced to the repo the same morning. **Atompunk (ADP §1.1):** the designer asked whether *atompunk* names the style. It covers the corporate half but not Deco or the DIY punk layer; **Atomic Deco Punk stays**, "atompunk" is the outward pitch shorthand. **ZINE-002 (direction):** the zine is how the underworld communicates, in samizdat's lineage, with the reasons it exists made explicit (every channel owned and listening, speech becomes data, the record is rewritable, the traced vanish, nobody speaks plainly): censorship by convenience, not prohibition. **ARCH-001 (APPROVED):** being traced means disappearing to the Archipelago. Designer: ARCH-R1 tone rules "1 y" (horror by absence, never a joke, corporations never name it, "gulag" never on screen); defeat framing and persistent THE CARBON record "2 y"; the islands are for "merging man with the machine one at a time, in order to build the synchronization signal to sync/merge all mankind at once with AI, tie into ending, sync testing"; no one comes back "4 no". **Docs:** `REDLINE_ATOMIC_DECO_PUNK.md` v0.8 (§1.1, §2.2, links in §4–§8); new `REDLINE_ARCHIPELAGO.md` v0.2; master design §1, §8 and §10; HANDOFF (ARCH-001 build note, a WAITING row for the working copy). **Interpretations to confirm:** the island names, *THE CARBON*, *NOTES FROM THE ARCHIPELAGO*; the historical summaries were written from general knowledge. **Code changes:** none. **Tests:** none.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — ZEROED-001: Restore STR floor and track once-per-ICE ZEROED (Codex).

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

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-19 — PIXEL-TRACE-001a: animated pixel step changes (Claude), 2026-11-19 — PIXEL-TRACE-001b: bit-crushed music with the pixel steps (Claude), 2026-11-19 — PIXEL-TRACE-001c: a transition sound effect, to be chosen (Claude), 2026-11-19 — ENC-ANALOG-001 saved; ICE-ANALOG-001 brief for Codex (Claude), 2026-11-19 — ICE-ANALOG-001: editable Godot visual study (Codex), 2026-11-19 — ICE-ANALOG-001 designer approval for default encounter integration, 2026-11-19 — ICE-ANALOG-001 built; ENC-CONCEPT-001 direction and art briefs (Claude) (ARCH-V2-002, 2026-11-25).

## 2026-11-19 — ENC-CONCEPT-001: concept-3 interface in the encounter (Claude)

**Built (presentation only):** the encounter screen re-laid out to concept 3 with a concept-2 left HUD: top bar (PANOPTICON plate, network/node plate, decal plate, CONDITION pill, HOSTILE REVEAL %, TURN/TRACE/RESERVE split-flap tiles, strike lamps, CRED/RAM, bleed); ICE consoles (enamel frame with arched corp tab, power lamp, name and STR plates, ICE-ANALOG-001 keys and reel column, PASSIVE plate, per-ICE NEXT RESPONSE plate, patent plate); left CRT with status and installed Programs (phosphor chips); vitals with icons and segment gauges (VITAE, BANDWIDTH lamps, SHIELD, PULP INCOMING, NEXT DRAW); right column with the NUL/REM note, piles and a round red END TURN with a ready lamp. New `analog.gd` draws tiles, lamps, gauges and icons. The flip-clock HUD pass (ENC-ANALOG-001) stays unbuilt.

**Fixtures:** `shot_ice_analog.gd` added to CI. `shot_friendly_lie` reads the curve-B number from the NEXT RESPONSE plates; `shot_facade` compares the console ground. The note passes drops through so SCRIPTs still play when dropped on it (`shot_hand`).

**Tests:** rules 369/0, ADP 17/0, SIGNAL/CARBON 671/0; all 16 screenshot fixtures pass.

**Interpretations to confirm:** HOSTILE REVEAL = the bleed reveal (0 / 20–60 / 100%); graffiti on the top-bar decal plate; NUL/REM note in the right column; per-ICE NEXT RESPONSE plates replace the shared strip; console enamel = plaque ground tinted toward the corp accent. Card faces and mascots wait for the ChatGPT art.

## 2026-11-19 — ENC-CONCEPT-001: ChatGPT art wired into the encounter (Claude)

Designer: "yes please do" (wire the delivered ChatGPT art into the game). Imported from the designer's folder `PANOPTICON art` into `godot/assets/concept/`:
- `ui/`: painted UI kit (frame, top bar, ICE console 9-slice, key caps and lamps, plates, pills, badges, END TURN states, tooltip plate, flip tile, reel window, CRT, vitals, BW chip) and the icon sheet sliced into single icons with cream `_LIGHT` variants. Seven files arrived under ChatGPT names and were renamed; large plates also have half-size `_S` copies.
- `cards/`: CARD_FRAME_{PROGRAM,SCRIPT,PROTOCOL,BLOATWARE} and 10 card pictures (batch 1).
- `mascots/`: AUTO_RENEW and CAPTCHA, cheery / wary / lethal.

Wiring (presentation only; each part falls back to the drawn version when its file is missing):
- ICE consoles drawn as a NinePatchRect of the painted console; keys use painted caps, lamps and icons; key tips use the painted tooltip plate.
- Top bar, CRT, vitals, plates, buttons and END TURN use the painted parts (StyleBoxTexture). `FriendlyEncounter.style_ground()` gives contrast tests a ground colour for painted styles.
- Mascots: when `<ICE_ID>_<mood>.png` exists, the concept art replaces the drawn mascot (speech bubble and sticker kept), leans toward the focused key, breathes, and trembles when lethal. PIXEL-TRACE-001 still applies.
- Cards: concept face (white frame per type, picture window, name, cost dial, type stamp, corner chips); rules show on hover. `FriendlyCard.DISPLAY_SCALE` 1.4 → 1.0 (smaller cards, per the designer); the CARDS-004 fan rules are unchanged. Cards without a picture show a tinted stencil until batch 2. `shot_cartridges` and `shot_cards_pcb` set `FriendlyCard.legacy_face = true` so they keep checking the cartridge face.

Tests (Godot 4.3, headless): test_game 369 passed, 0 failed; test_adp 17 checks, 0 failures; test_signal_carbon 671 checks, 0 failures. All 16 screenshot fixtures in the workflow list exit 0 with no SCRIPT ERROR, Parse Error or Assertion failed.

Interpretations to confirm: cards at 1.0× (CARDS-004's 1.4× superseded for the concept face); card rules on hover only; UI_BACKDROP_MACHINE delivered but not used until the per-corp background decision.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-19 — ENC-CONCEPT-001: concept-3 interface in the encounter (Claude), 2026-11-19 — ENC-CONCEPT-001: ChatGPT art wired into the encounter (Claude) (ARCH-V2-002 audit corrections, 2026-11-25).

## 2026-11-19 — ENC-CONCEPT-001: UI kit brief 2 (Claude)

Designer: "what other UI elements can we request ChatGPT build based on the screenshot #2… I really like how the examples fill the screen with useful UI, with appealing proportions." Reviewed concept 2 against kit 1 and wrote `docs/visual/concept-art/UI_KIT_BRIEF_2.md`: one paste-once ChatGPT prompt for 13 blank painted parts (brand plate, corp sign, alarm plate, four CRT condition pictures, lamp stack, knob, vent, slot panel, comic bubble, TUMBLER drum, hand tray, END TURN box, legend card). No code changes. Interpretation to confirm: concept 2's SUPPORT box is not a rule, so its panel will hold the punch-card count or installed Programs.

## 2026-11-19 — ENC-CONCEPT-001: UI kit brief 3 (Claude)

Designer: "I want to get ChatGPT generating as many UI images for this as possible to get it as correct as possible… once those sets of images are generated you can do the layout." Wrote `docs/visual/concept-art/UI_KIT_BRIEF_3.md`: 16 more blank painted parts (concept-2 console, big key sockets, TURN plate, TRACE counter, dials, strike lamps, NUL/REM slip, deck/discard wells, card back, tray buttons, toggles, pipework, screws/rivets, key glow, log ticker, vignette). The concept-2 layout pass waits for kits 2 and 3. No code changes. Interpretation to confirm: the homes for information concept 2 leaves out (dials, tray, slip).

## 2026-11-20 — ENC-CONCEPT-001: concept-2 layout pass with UI kits 2 and 3 (Claude)

Designer: "both batches are in the folder now. do the full layout pass and send screenshots." Imported 48 kit-2/kit-3 parts from `PANOPTICON art` into `godot/assets/concept/ui/` (the cabinet arrived as "Empty seafoam chrome cabinet-1.png" and was resized to `UI_ICE_CONSOLE_2` 960×1000; the vignette was reduced to 800×500). Rebuilt the encounter layout around concept 2 (master ENC-CONCEPT-001 has the full list): painted top bar plates and dial; CRT pictures per condition; NUL/REM paper slip; ICE cabinets with the character top-left, name/STR slots, keys scaled with the console (`IceKey.u`), hover glow and comic bubble; ticker; hand tray with wells, tray buttons and the END TURN box; KEY LEGEND card; pipework and vignette. Presentation only; every part falls back to the drawn version when its file is missing.

Test updates: `shot_hand` drops on the left column instead of the old right column, checks the hand against the tray buttons and END TURN, and checks `FriendlyHand.HAND_SCALE`; `shot_adp` checks the cabinet's stage scale; `shot_ice_analog` adds the KEY LEGEND capture.

Tests (Godot 4.3, headless): test_game 369 passed, 0 failed; test_adp 17 checks, 0 failures; test_signal_carbon 671 checks, 0 failures. All 16 workflow screenshot fixtures exit 0 with no SCRIPT ERROR, Parse Error or Assertion failed.

Interpretations to confirm: homes for the information concept 2 leaves out; hand cards at 0.72×; parts not used yet (see HANDOFF).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-19 — ENC-CONCEPT-001: UI kit brief 2 (Claude), 2026-11-19 — ENC-CONCEPT-001: UI kit brief 3 (Claude), 2026-11-20 — ENC-CONCEPT-001: concept-2 layout pass with UI kits 2 and 3 (Claude) (UI-BIBLE-001, 2026-11-25).

## 2026-11-20 — RELEASE-001: HALCYON Playtest 7 (Claude)

Designer asked for a playable build of the concept-2 layout. Bumped the version to 0.7.0-playtest.7 (project version, selection-screen line, workflow artifact name, playtest guide) in `5bb7d71`; ran test_game 369/0, test_adp 17/0 and test_signal_carbon 671/0 before committing. Fast-forwarded `release` to `5bb7d71`; [Actions run 44719708503](https://github.com/Punkwork/REDLINE/actions/runs/44719708503) passed every step and uploaded `PANOPTICON-HALCYON-PLAYTEST-7-0.7.0-playtest.7-Windows-x86_64` (95.8 MB). The `playtest-7` tag on `5bb7d71` still needs to be pushed: GitHub refused the tag push from this session (HTTP 403). The artifact could not be downloaded from this session, so its contents were checked through the workflow's own export checks rather than by hand.

## 2026-11-20 — ENC-CONCEPT-001: program screen; mascot prompt for ACCEPT ALL / REJECT ALL (Claude)

Designer, after Playtest 7: installed programs were unusable. A probe showed +STR did work, but the controls were tiny and crammed into a 66-px scroll over the CRT picture. Rebuilt the CRT readout as one active program (name plate to drag, STR, type, costs, +STR, ×, ◀ n/N ▶, mouse wheel), a dark scrim behind it, the "DROP PROGRAM HERE" plate only when nothing is installed, and key clicks that break with the program on screen first (`main._on_break` passes the pick uid to the existing `break_sub`). `shot_ice_analog` checks the rotate and +STR and captures the program screen. Wrote the batch-2a ChatGPT prompt for ACCEPT ALL and REJECT ALL in `ART_BRIEFS.md`.

Tests: test_game 369/0, test_adp 17/0, test_signal_carbon 671/0; all 16 workflow fixtures pass.

## 2026-11-20 — ENC-CONCEPT-001: ACCEPT ALL and REJECT ALL mascots (Claude)

Imported the designer's six ChatGPT mascots (`ACCEPT_ALL_*`, `REJECT_ALL_*`, cheery/wary/lethal) into `godot/assets/concept/mascots/`; the game picks them up by name, so COOKIE BANNER now shows the painted bellhop twins. No code changes. Tests: test_game 369/0, test_adp 17/0, test_signal_carbon 671/0; all 16 workflow fixtures pass.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-20 — RELEASE-001: HALCYON Playtest 7 (Claude), 2026-11-20 — ENC-CONCEPT-001: program screen; mascot prompt for ACCEPT ALL / REJECT ALL (Claude), 2026-11-20 — ENC-CONCEPT-001: ACCEPT ALL and REJECT ALL mascots (Claude) (RELEASE-002, 2026-11-25).

## 2026-11-20 — MOOD-PIXEL-001, program cartridges, AVATAR-001 and ChatGPT round 3 (Claude)

Designer asked for card pictures, per-corporation backgrounds, avatar families that read by corporation, job and ICE type (sentries fun to build), 16-bit mood transitions with a 2 s on / 2 s off lethal pulse, and slim program cards sticking out of the CRT. Built: `themes/mood_pixel.gdshader` (TRACE-pixel method masked by the avatar's alpha) and `FriendlyMascot.mood_look()` (drop to 16-bit, swap faces at the peak, resolve; lethal pulse, coarser over TRACE pixelation; off under reduced motion); `FriendlyEncounter.build_cartridges()` (one card per installed program on top of the CRT; the active one higher with a lamp; click to switch) with the left column moved down 30 px; `concept_backgrounds()` swaps in `assets/concept/backgrounds/BG_<CORP>_*.png` when delivered. The NUL/REM slip now fits its text by the label's real line height and clips. Wrote `docs/visual/concept-art/CHATGPT_PROMPTS_ROUND3.md` (83 card pictures in four prompts, AVATAR-001 rules with build-a-sentry tables and the six remaining HALCYON avatars, six backgrounds). `shot_ice_analog` checks the pulse timing and captures the 16-bit phase.

Tests: test_game 369/0, test_adp 17/0, test_signal_carbon 671/0; all 16 workflow fixtures pass.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-20 — MOOD-PIXEL-001, program cartridges, AVATAR-001 and ChatGPT round 3 (Claude) (UI-TYPO-001, 2026-11-25).

## 2026-11-20 — CAPS rack and Ghostware rail (Claude)

Designer asked for room for CAPS (3 minimum, more later) and any number of Ghostware, possibly hovering along the top with rollover text. Built `build_cap_rack()` (3 placeholder slots right of the hand; `HAND_RECT` 80 px narrower) and `build_ghost_rail()` (ORIGIN plus `game.ghostware` as round badges hanging from the pipe above the ICE, shrinking to fit; tooltips give name and effect; painted icons picked up from `assets/concept/ghostware/GW_<NAME>.png`). Added §4 to `CHATGPT_PROMPTS_ROUND3.md` (CAP slot, 12 CAP vials, 30 Ghostware badges). Tests: test_game 369/0, test_adp 17/0, test_signal_carbon 671/0; all 16 workflow fixtures pass.

## 2026-11-20 — HOVER-001 recorded (Claude)

Designer: "the hover text box should always include a large/high resolution image of the card or cap or ghostware etc. alongside the text. Commit that mouse over/hover rule." Recorded HOVER-001 as APPROVED in master §6 and the register, with a note in Visual Language §2.9: every hover/focus box for a game object shows a large, high-resolution image of it beside the text (at least 2× its on-screen size, cards at least 1.5×), image first, a stand-in until painted art exists, never covering the hovered object. Implementation is a TO DO in HANDOFF. No code changes.

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-20 — CAPS rack and Ghostware rail (Claude), 2026-11-20 — HOVER-001 recorded (Claude) (RELEASE-002, 2026-11-25).

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
