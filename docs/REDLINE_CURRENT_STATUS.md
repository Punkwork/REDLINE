# REDLINE — CURRENT PROJECT STATUS
**As of:** 2026-11-09  
**Purpose:** fast, reliable start-of-day briefing. Update at every session handoff.

## At a glance
- **Project:** REDLINE, cyberpunk runner-versus-corporation card game with ICE and companion NUL/REM.
- **Production engine:** **Godot 4** (chosen).
- **Gameplay reference:** Python/Pygame archive `REDLINE_Dead_Drop_Final_Playtest.zip` (previously identified; not inspected today).
- **Design baseline:** `REDLINE_MASTER_DESIGN.md`.
- **Historical record:** `REDLINE_DEVELOPMENT_LOG.md`.
- **Current confidence:** core decisions are documented; current code and test state require verification against actual source.

## Confirmed design decisions
1. Runner acts; corporation then fires all remaining unbroken damage/Trace subroutines; broken DEADLOCK allows advance after corp turn.
2. SYN X = Runner chooses and discards up to X cards from hand; each undiscarded point causes 2 Vitae damage after discards (RULE-126). NEURAL DAMAGE and SYNAPTIC DAMAGE are deprecated.
3. PURGE = corporation removes virus counters.
4. DEAD DROP (not Safehouse): exactly one of PATCH UP (+10 Vitae) or WIPE TRAIL (−20 Trace).
5. Hardware recycled once per encounter end; PATCHWORK persists per card instance; Ghostware permanent non-card.
6. UI: `[STR X]`, drag breakers to ICE, fixed ICE inspection bay, tooltips, Ghostware rack below RETURN, signature Ghostware once with ORIGIN.
7. NUL/REM's six modes preserved; First Signal is real synchronization transmission.

## Implementation evidence matrix
| Area | Design | Code status | Testing |
|---|---|---|---|
| ICE timing / DEADLOCK | Locked | Previously represented in Python reference; inspect | Prior regressions reportedly passed; re-run |
| SYN chosen discard + 2 Vitae per shortfall (RULE-126) | Locked | Verify against latest files | Five regression cases + sequencing |
| Trace / Black ICE | Partially specified | Verify | Verify |
| DEAD DROP choice | Locked | In named playtest baseline; inspect | Verify |
| Hardware recycling | Locked | Previously reported | Verify exactly-once |
| PATCHWORK instance persistence | Locked | Previously reported | Verify identity/save behavior |
| Ghostware / ORIGIN | Locked | Previously reported | Verify |
| NUL/REM UI/dialogue | Character direction set | Verify | Live UI testing needed |
| PAPER CUT ICE | Concept only | **Not confirmed implemented** | Balance/test pending |
| Godot 4 production build | Target chosen | **Unknown** | Unknown |

## Known outstanding work
- Acquire/inspect latest source archive and regression scripts.
- Run automated tests and conduct live Windows UI playtest.
- Reconcile exact card/ICE stats, resources, win/loss conditions, Trace formulas, virus rules, progression, and upgrade catalogs.
- Define Godot 4 migration plan and parity tests.
- Expand NUL/REM dialogue library and narrative outline after core rules are stable.

## Next-session priority queue
**P0 — Documentation review:** confirm omissions and correct any misclassified LOCKED/CONCEPT decisions.  
**P1 — Code audit:** provide latest ZIP/source; inventory files, features, and tests.  
**P2 — Regression baseline:** run tests, reproduce outstanding UI issues, document results.  
**P3 — Godot migration:** scope first playable vertical slice with rules parity.

## Handoff prompt for tomorrow
> REDLINE: Start today's development session. Use `REDLINE_MASTER_DESIGN.md` as the authority, review `REDLINE_CURRENT_STATUS.md` and the latest `REDLINE_DEVELOPMENT_LOG.md` entry. First summarize yesterday's decisions, unresolved issues, and today's three priorities. Do not assume code exists merely because a feature is designed.

## Update discipline
At session end: append a dated Development Log entry; update this Current Status; modify Master Design **only** for approved design changes, with decision IDs and statuses. Record test commands/results and changed filenames wherever possible.

---

## Design handoff — 2026-11-10: PANOPTICON

**Preferred working title:** PANOPTICON; REDLINE remains the development/repository codename until intentional rename and availability checks.

**Foundational thematic direction:** **What does humanity become when it knows it is being permanently observed and monitored?** Explore internalized observation, loss or transformation of privacy, behavioural self-regulation, diverse social adaptations, and the possibility that being unobserved becomes unsettling. Do not predetermine the answer.

**Visual direction:** locks, sealed thresholds, confinement, being locked out/in, panoptic architecture and the uncertainty of observation. DEADLOCK releases must respect corporation-turn timing.

**Structural direction:** original single-player roguelike deckbuilder; ICE primary at each defensive layer; supporting corporate defences can be layer-specific or node-wide. Corporate corruption cards and surveillance-triggered countermeasures are concepts, not implementation-ready rules. Viruses are a deployable software subtype; exact state model open.

**Next design tasks:** define supporting-defence lifecycle and counterplay; specify corruption triggers/destinations/exhaust semantics; explore panoptic visual language without compromising tactical clarity; investigate title availability before repository renaming.

**Implementation:** No new mechanics or code changes verified from this design discussion. Existing gameplay and First Signal canon preserved.


---

## Design-rule session handoff — 2026-11-11

**Authoritative rule source:** `docs/REDLINE_MASTER_DESIGN.md`. **Latest approved and committed rule: RULE-096** (DRAW changes do not retroactively remove cards already drawn). Rules through RULE-096 are saved in the Master Design; do not reopen them without explicit user direction.

**Recent locked scope:** Software source removal and queued vs already-resolving abilities (RULE-081–089); continuous effects tied to installed instances, default stacking and explicit non-stacking, PATCHWORK strength and removal (RULE-090–095); DRAW non-retroactivity (RULE-096). An installed instance ends on removal; reinstallation creates a new installed instance, but does not reset protected activation limits. With explicit non-stacking text, the strongest eligible bonus applies; without it, separate copies stack.

**Next unanswered design question — RULE-097 (NOT LOCKED):** If Runner draws 5 cards at turn start with DRAW 5, then installs +3 DRAW Software mid-turn, should no additional cards be drawn immediately, with DRAW 8 affecting the next applicable normal draw calculation? Assistant recommended yes; user has **not** answered. Ask this one question first when resuming.

**Session boundary:** User requested stopping questions now and resuming tomorrow in a new chat. No code changes or tests were performed as part of this rule-design session. GitHub Master Design commit for RULE-096: `ce1bcbc341b03ca4662d223ba98d88ca34fd1593`. Earlier status and implementation-evidence matrix are not proof of current implementation; verify source separately.

**Handoff prompt:** “Resume REDLINE design questions from RULE-097. Read the GitHub Master Design as authority; RULE-096 is the last locked rule. Ask one question at a time and commit each approved rule. Do not assume an unanswered proposal is locked.”


## Design-rule update — 2026-11-11: RULE-097

**Latest locked and committed:** RULE-097 — increasing DRAW mid-turn grants no immediate extra cards; updated DRAW applies to future applicable draw calculations. This complements RULE-096. Master Design commit: `1cbf10cbda21cc786c0d3e2cc10ad1b05cd288d2`.

**Next:** RULE-098 is OPEN; ask one design question at a time. No code changes or tests verified. The preceding RULE-097 unanswered handoff above is historical and superseded by this update.


## Design-rule update — 2026-11-11: RULE-098

**Latest locked and committed:** RULE-098 — when a draw instruction based on DRAW begins resolving, its target card count is fixed using the effective DRAW at that moment. Subsequent changes to DRAW during the instruction do not change that target. Existing shortfall and draw-trigger timing rules continue to apply. Master Design commit: `d1cf5e9da1622c7e6c0be02bd6883a985844897a`.

**Next open question:** RULE-099 — determine whether a DRAW change between two distinct draw instructions within the same resolving ability affects the second instruction. No approval yet; ask one question. No code changes or tests verified. Prior RULE-097 and RULE-098 open handoffs are historical and superseded.


## Design-rule update — 2026-11-11: RULE-099

**Latest locked and committed:** RULE-099 — each distinct draw instruction referencing DRAW calculates its target from effective DRAW at the start of that instruction, even if two such instructions occur within one ability. Example: DRAW 5; draw 5; gain +2 DRAW; draw 7. RULE-098 continues to fix each instruction's target once it starts. Master Design commit: `bc056f665eabf62a516956214128a650cba82a89`.

**Next open question:** RULE-100 — if a DRAW-based draw instruction is queued for later resolution, whether its DRAW target is calculated on queueing or when the instruction actually begins. No approval yet. No code changes or tests verified. Prior open-question handoffs are historical and superseded.


## Design-rule update — 2026-11-11: RULE-100

**Latest locked and committed:** RULE-100 (Option B) — a queued triggered Software ability with a single “Draw cards equal to your DRAW” instruction fixes its draw count from effective DRAW when it enters the FIFO queue. Example: queued at DRAW 5, DRAW later increases to 8, ability still draws 5. This is an explicit exception to RULE-098's default instruction-start snapshot; existing source-removal cancellation remains in force. Master Design commit: `17b5c4917290061064b75774fee4dadbc323a0a6`.

**Next open question:** RULE-101 — whether a queued ability containing *two separate* DRAW-based draw instructions snapshots both at queue time or only its first instruction, with the second calculated when reached. Not yet approved. No code changes or tests verified; earlier open-question handoffs are superseded.


## Design-rule correction — 2026-11-11: RULE-100 revised

**Authoritative correction:** At user's explicit direction, RULE-100's queue-time DRAW snapshot has been **replaced**. Queued triggered abilities now calculate each DRAW-based instruction from effective DRAW **when that instruction begins resolving** (RULE-098), not when the ability is queued. Example: queued at DRAW 5, DRAW rises to 8 before resolution, draw 8. RULE-099 continues to recalculate at each separate instruction. Master Design revision commit: `c39a5da2f0746d97662ed525bb35c7c8e1bd62a5`. Prior RULE-100 Option B and pending RULE-101 queue-snapshot question are superseded; retain earlier entries as historical only.

**Next single design question (not locked):** RULE-101 — when a queued ability has multiple DRAW-based instructions and DRAW changes while queued and between instructions, confirm each instruction uses DRAW at its own resolution start. Do not commit RULE-101 without explicit approval. No code changes or tests verified.


## Design-rule update — 2026-11-11: RULE-101

**Latest locked and committed:** RULE-101 (Option A) — for a queued triggered ability with multiple separate DRAW-based draw instructions, each instruction uses effective DRAW when that individual instruction begins. Example: queued at DRAW 5, DRAW rises to 8 before resolution, first draw 8, gain +2 DRAW, second draw 10. **Conflict review:** aligns with RULE-098, RULE-099, and revised RULE-100; no overrides. Master Design commit: `7dafb193b9a86b6f4d2f4683f74d9cc1d439d121`.

**Next open question:** RULE-102 — whether the instruction-start snapshot principle applies to other variable numeric quantities beyond DRAW, or remains specific to DRAW. Not approved. Ask one question and check for conflicts before committing. No code changes or tests verified. Previous open-question handoffs superseded.


## Design-rule update — 2026-11-11: RULE-102

**Latest locked and committed:** RULE-102 — discrete instructions using variable numerical values snapshot those values at the start of **each individual instruction**; separate instructions recalculate. Exception-protected: does not freeze continuous effects (RULE-090–095), override explicit timing, bypass costs/conditions (RULE-003/038/071), or change eligible resource spending priorities (RULE-004–006). More-specific locked rules/card text prevail. Extends DRAW timing (RULE-098–101) consistently; no authorized override. Master Design commit: `98bb8e85d79c999cb218ed27fc9167c78f380699`.

**Next open question:** RULE-103 — when a discrete numeric instruction explicitly says “for each” and processes individual objects one at a time, whether it uses one instruction-start snapshot or recalculates for each object. Check RULE-102 and more-specific mechanics before committing; not approved. No code changes or tests verified. Prior open-question handoffs superseded.


## Design-rule update — 2026-11-11: RULE-103

**Latest locked and committed:** RULE-103 (Option A) — one discrete “for each” instruction using a variable numeric value snapshots that value once at the instruction's start and reuses it for each eligible object. Separate later instructions independently recalculate under RULE-102. Illustrative Trace 6 across three Software cards stays 6 for all per-card calculations, even if a legally permitted change occurs during processing. This does not authorize queued triggers to interrupt the current ability or change prevention-gain event granularity. Conflict check: compatible with RULE-010, RULE-014/015, RULE-074–077, RULE-098, RULE-102; no override. Master Design commit: `a33b7a95fe3d1bf10dd400498d4a5d9942222204`.

**Next open question:** RULE-104 — when a single “for each” instruction refers to eligible objects, whether the eligible object set is determined at instruction start or reevaluated as objects enter/leave during processing. Check existing rules before approval/commit; not locked. No code changes or tests verified.


## Design-rule update — 2026-11-11: RULE-104

**Latest locked and committed:** RULE-104 (Option A with eligibility protections). A single discrete “for each” instruction fixes its eligible-object processing set at instruction start; newly eligible objects are not added, and original objects are not automatically removed from the list. This **does not** bypass later explicit eligibility, installation, source-dependent conditions, or costs; continuous effects end upon source removal. Ordinary triggers cannot interrupt the current effect (RULE-014/015). Compatible with RULE-010, RULE-083/088/090, RULE-102/103; no locked override. Master Design commit: `5b5e1dbaaf863917f71e31f270689d87c5d45ad5`.

**Next open question:** RULE-105 — whether one “for each” instruction generates one event for its aggregate effect or separate events for each object processed, especially prevention gains. Must reconcile with RULE-074–077 before approval; no commit. No code changes or tests verified.


## Design-rule update — 2026-11-11: RULE-105

**Latest locked and committed:** RULE-105 Option A — a single discrete “for each” instruction that grants prevention generates **one aggregate prevention-gain event** if its total gain is positive, regardless of objects processed. Each eligible triggered ability responds at most once per event subject to frequency restrictions; separately written gain instructions remain separate events (RULE-076), and distinct abilities can each respond (RULE-078). Generated triggers resolve after the originating ability via FIFO (RULE-014/015). Example: 3 Software × 2 BURN = 6 BURN, one gain event, one +1 BW trigger. Conflict audit: RULE-074–079 and RULE-103/104 preserved; no overrides. Master Design commit `0a798daeb0f6aa934ccce8e872cc0494215ca08d`.

**Next open question:** RULE-106 — should this single aggregate-event convention apply to other “for each” instructions producing non-prevention events (e.g., Trace reductions, BW gains), or remain prevention-specific until separately defined? Audit existing event rules before any commit. Not approved. No code changes or tests verified.


## Design-rule update — 2026-11-11: RULE-106

**Latest locked and committed:** RULE-106 — one discrete “for each” instruction producing repeated changes of the same event type generates **one aggregate event for generic triggers**, provided a qualifying change actually occurs. Different instructions produce separate events. Explicit exceptions preserve per-card actual draws (RULE-032/033), per-would-be-draw replacements (RULE-040–043), actual reshuffles (RULE-036), damage-application mechanics, explicit per-object/per-occurrence wording, costs, conditions, and more-specific card text. Multiple distinct eligible abilities can each respond once; FIFO unchanged. Example: 3 Software × −2 Trace = −6 Trace and one generic Trace-reduction event (if actual reduction); 3 Software × +1 BW = +3 BW and one generic BW-gain event (if actual gain), subject to applicable restrictions. Conflict audit found no overrides. Master Design commit: `7b096f35ce1365793fa287388d88d129fd91a48d`.

**Next open question:** RULE-107 — should one aggregate event report the total amount changed (e.g., −6 Trace) to triggers referring to “the amount reduced,” or should each object's change be individually visible to such amount-based abilities? Audit for conflicts before any commit; not approved. No code changes or tests verified.


## Design-rule update — 2026-11-11: RULE-107

**Latest locked and committed:** RULE-107 — aggregate events under RULE-105/106 report the **total actual qualifying change** made by their instruction, rather than attempted or per-object amounts. Partial fulfillment reports only realized change; zero qualifying change generates no corresponding event. Amount-dependent triggers use that actual aggregate magnitude subject to costs, conditions, limits, timing and frequency rules. Individual draw/reshuffle/replacement events, damage application and explicit per-object/per-occurrence effects retain precedence. Illustrative: attempt −6 Trace starting at 4, where a zero floor applies, reports −4 actual and one event; does not itself establish a Trace floor or BW cap. No locked overrides. Master Design commit `7eb582c7dfdaee9ad1be17075e4c0247b721501b`.

**Next open question:** RULE-108 — when an aggregate event contains both positive and negative changes of the same resource across its processed objects, should amount-based triggers use the net change or the total qualifying directional changes? Check whether this is possible under existing mechanics and audit conflicts before locking. Not approved. No code changes or tests verified.


## Design-rule update — 2026-11-11: RULE-109

**Latest locked and committed:** RULE-109 — numeric threshold conditions on aggregate events under RULE-105/106 use the **completed event's total actual qualifying change** (RULE-107), not each per-object contribution, unless more-specific card text requires otherwise. Each eligible ability qualifies at most once per event subject to frequency limits; triggers wait for the originating ability to finish and resolve FIFO. Existing draw, reshuffle, replacement, damage, cost and condition rules are preserved. Example: three eligible Software × +2 BURN prevention = one +6 BURN event, meeting “at least 5 BURN prevention in a single event” once; only +4 actual does not meet threshold. No locked-rule override. Master Design commit `045a991465a39fb573792560a19a591a09ff70eb`.

**RULE-108 remains DEFERRED and NOT LOCKED:** mixed-direction accounting awaits a concrete card/mechanic; no RULE-108 commit. **Next open question:** RULE-110 — whether amount/threshold trigger eligibility is fixed when an event is generated, or may be reevaluated when the queued trigger resolves if the game state changes. Audit conflicts before approval; not locked. No code changes or tests verified.


## Design-rule update — 2026-11-11: RULE-110

**Latest locked and committed:** RULE-110 — event-time trigger qualification and resolution-time variable calculations. Determine eligibility against the event and applicable trigger conditions when the event occurs; aggregate event magnitudes and threshold results remain fixed (RULE-107/109). Variable numerical quantities in queued triggered abilities are calculated when each discrete instruction begins resolving (RULE-102), not at queue entry, unless explicit more-specific text directs otherwise. Preserve FIFO, explicit resolution-time conditions, frequency limits, installed-source requirements and pending Software-trigger cancellation under RULE-081/082/085; already resolving abilities retain RULE-083 protections. Example: +6 BURN qualifies threshold 5 at Trace 8; Trace becomes 3 before reward instruction, so attempt +3 BW, if trigger survives. No locked override. Master Design commit `81c4ab95370b57345dcc8a41ba5e8a701d41e9ee`.

**RULE-108 remains DEFERRED and NOT LOCKED.** **Next open question:** RULE-111 — when a trigger explicitly requires a condition both at event time and at resolution time, should its event qualification persist while its resolution-time condition is separately checked? Audit for existing rule coverage before approval. Not locked. No code changes or tests verified.


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


## RULE-136 — Damage resolution boundaries and trigger queue checkpoints (LOCKED, 2026-11-11)

**Explicit approval:** Each **independently resolving ICE subroutine** is a distinct effect boundary. Resolve the subroutine's full effect to completion before processing triggers generated by it. This includes all its discrete instructions, mandatory type-specific prevention, VOID counters and required discards, SyN discards, separate overflow BURN events for each missing discard (RULE-134), direct BURN, and resulting VIT changes, in the fixed **VOID → SyN → BURN** component order where mixed damage applies (RULE-129). Do **not** insert a trigger-resolution checkpoint between individual damage components, overflow BURN events, or instructions inside that still-resolving effect. The same principle applies to other independently resolving effects: finish the current effect before its generated triggers.

**Mandatory checkpoint between effects:** After the current independently resolving effect completes, **fully drain all eligible queued triggers** before beginning the next independent ICE subroutine or other effect. Use the existing simultaneous-trigger/controller ordering, FIFO queue, and complete-one-effect-before-generated-triggers semantics (RULE-010–015). A trigger that generates further triggers places them on the existing queue; continue resolving eligible chained triggers until the queue is empty, subject to RULE-016–019 infinite-loop and recursion safeguards and existing trigger eligibility, per-turn activation limits, source-removal cancellation, and explicit exceptions. Do not resolve only the first generation or carry eligible chained triggers into the next effect. An individual queued triggered ability is itself resolved completely before its newly generated triggers are processed under the established queue discipline.

**Updated state between subroutines:** At the next subroutine boundary, apply the game state after the preceding effect and its drained triggers, including new prevention pools, changed VIT, resource changes, discarded cards, VOID counters, installed/removed sources, and temporary effect durations. Prevention gained when a trigger actually resolves may protect against a **later** subroutine if eligible and still active; it **cannot** prevent damage from the completed originating subroutine or any earlier overflow BURN event (RULE-133/135). No new reactive Runner card-play window or out-of-turn DRAW is created (SOFT-011; RULE-132).

**Corporation response and cleanup:** Finish **all** Corporation response effects and their full trigger checkpoints before performing the **single** post-Corporation hand cleanup required by RULE-132. Routine cleanup discards all remaining non-CACHED cards in one grouped discard event (RULE-134), while eligible CACHED cards survive routine cleanup but remain eligible for mandatory VOID/SyN damage discards. Cleanup-generated triggers resolve and drain completely before the next Runner turn, ICE PASS, or Node/ICE transition (RULE-132/133). Never start cleanup with eligible Corporation-generated triggers pending, and never create a second routine ICE PASS cleanup event.

**Immediate defeat overrides checkpoints:** Check VIT after each actual reduction, including each separately resolved overflow BURN event. At VIT 0, defeat immediately ends the run (RULE-RT-002/RULE-130); preserve completed changes but cancel remaining instructions, unresolved damage events, queued triggers and post-response cleanup. No pending heal, recovery, or prevention trigger can rescue the defeated Runner. Mandatory prevention consumption, source expiration priorities, and applied/prevented/suffered event distinctions remain RULE-004–006/131/135.

**Canonical example:** Runner begins at **12 VIT**, with no BURN prevention, and has installed Software: *“Whenever you suffer BURN damage, gain 3 BURN prevention.”* Corporation resolves two independent unbroken ICE subroutines. Subroutine 1 inflicts **BURN 4**; Runner suffers 4, dropping to **8 VIT**, and queues the Software trigger. Subroutine 1 finishes; at its checkpoint the queued trigger resolves, granting **3 BURN prevention**. Subroutine 2 inflicts **BURN 5**; mandatory prevention absorbs 3, Runner suffers 2 and drops to **6 VIT**. The second suffered-damage trigger queues for the checkpoint **after subroutine 2**, not during it. If both BURN instructions were within one independently resolving effect, no checkpoint would occur between them and the new prevention would not apply until afterward.

**Compatibility and priority:** RULE-136 establishes explicit checkpoints **without changing** RULE-010 printed instruction order, RULE-011–015 trigger ordering/FIFO/complete-effect semantics, RULE-016–019 loop safeguards, RULE-126–131 damage types, prevention, overflow and immediate defeat, RULE-132 post-response cleanup and DRAW/CACHE timing, RULE-133 nonretroactive prevention, RULE-134 grouped discard events and separate overflow BURN event identity, or RULE-135 actual-versus-attempted event eligibility. A subroutine is an effect boundary only when it is independently resolving; explicit text defining a single combined effect or existing exceptions retains its established effect boundary. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-137 — Routine post-Corporation cleanup is non-triggering housekeeping (LOCKED, 2026-11-11)

**Explicit approval and precedence:** Routine post-Corporation hand cleanup is a **non-triggering housekeeping operation outside all effect-triggering windows**. Once the entire Corporation response and **all eligible queued/chained triggers** have finished (RULE-132/136), perform the single routine cleanup: discard every remaining **non-CACHED** card from the Runner's hand. These routine cleanup discards **do not generate, queue, or resolve discard-related triggered abilities or any other effect solely because cleanup discarded cards**. They cannot activate installed Software, card abilities, per-card/per-group discard triggers, prevention gains, DRAW, resource gains, or chained effects based on those housekeeping discards. Cleanup is not an effect-triggering checkpoint; once the cleanup action and its bookkeeping finish, advance directly to the next established phase or ICE/Node transition. Do not repeat cleanup or create an additional ICE PASS cleanup.

**Normal effect-caused discards unchanged:** This exception applies **only to routine cleanup discards**. Discards caused by VOID or SyN damage, ICE subroutines, Corporation instructions, Runner card abilities, or other resolving effects remain ordinary effect-caused discards, with their existing individual occurrences, grouped event granularity, eligibility, and deferred FIFO trigger timing under RULE-014/015/127/129/133/134/135/136. A discard that happens **during Corporation response** is not routine cleanup merely because it occurs near the end of the response. All pending effect-generated triggers drain before housekeeping cleanup begins. Explicit card effects are not silently reclassified as housekeeping cleanup.

**CACHE, logging, and accounting:** CACHED cards survive routine cleanup under SOFT-003–008 and RULE-132, unless some separate effect explicitly discards them. Routine cleanup discards are still real cards moved out of hand and **must be recorded** in the game log with card identities, number discarded, phase, and reason marked **ROUTINE CLEANUP / NON-TRIGGERING**. They are not qualifying discard occurrences for trigger activation or trigger-frequency accounting, despite being recorded as a single housekeeping cleanup batch. Do not count them toward effects that ask whether a card was discarded via a triggering event. No defensive DRAW or other benefit is created by cleanup itself.

**Example:** Runner finishes Corporation response with three non-CACHED cards and installed Software reading *“Whenever you discard a card, gain 2 BURN prevention.”* After all response-generated triggers have drained, routine cleanup discards the three cards and logs the batch. **Zero Software triggers** are generated and **zero BURN prevention** is gained from those housekeeping discards. The same Software still recognizes qualifying cards discarded earlier by VOID/SyN or another effect, subject to its normal limits.

**Explicit supersession and reconciliation:** RULE-137 **supersedes only conflicting statements that routine post-Corporation cleanup discards generate or resolve triggers** in RULE-132 (cleanup-generated triggers), RULE-133 (cleanup discard-trigger timing and cleanup-generated effects), RULE-134 (any inference that routine cleanup's grouped discard event generates per-card/per-group discard triggers), and RULE-136 (cleanup-generated/chained trigger checkpoint). All other provisions of RULE-132–136 remain LOCKED and operative: hand retention through Corporation response, full response trigger draining, single post-response cleanup, CACHE survival, separate overflow BURN events, prevention accounting, FIFO effect boundaries, and immediate defeat. Under RULE-010–019, this is a specific housekeeping exception to ordinary effect-trigger eligibility, **not** a new trigger window, queue behavior, or loop rule. Existing rules governing genuine effect-caused discards continue unchanged. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-138 — Discard classification by originating cause and phase-boundary trigger completion (LOCKED, 2026-11-11)

**Explicit approval:** Classify each discard by its **originating cause**, not by how close it occurs to a phase boundary, Corporation response ending, ICE PASS, Node transition, or routine cleanup. A discard expressly caused by an ICE subroutine, Corporation instruction, VOID/SyN damage, Runner card ability, queued triggered ability, or other independently resolving game effect is an **effect-caused discard**, including when it happens immediately before routine cleanup. Such actual discards retain their normal individual-card occurrences and grouped-event identities (RULE-134), eligible triggers and activation limits, and deferred FIFO resolution (RULE-010–015/133–136). Do not silently reclassify effect-caused discards as housekeeping merely because they happen late in the Corporation response.

**Non-triggering cleanup exception:** A discard is **routine housekeeping cleanup** only when it is performed by the single mandatory post-Corporation hand cleanup operation itself. Under RULE-137, those cleanup discards are logged but do **not** generate, queue, or resolve triggered effects based on being discarded. All remaining non-CACHED cards are discarded in that single housekeeping batch; CACHED cards retain their existing exemption. This exception does not suppress triggers from an effect that actually resolves before cleanup or otherwise change damage-caused discards.

**Strict transition checkpoint:** Complete the entire final Corporation effect, then **fully drain all eligible effect-generated triggers and any chained triggers** under RULE-014–019 and RULE-136 **before** routine cleanup begins. If an effect-generated discard causes a trigger that draws or otherwise adds non-CACHED cards to hand, those cards are present when routine cleanup starts and are discarded as part of its non-triggering housekeeping batch unless separately CACHED or otherwise explicitly protected. No eligible Corporation-generated trigger carries into or across cleanup. After the non-triggering cleanup and its bookkeeping, proceed directly to the established next phase, ICE PASS, or Node transition; no additional routine cleanup or cleanup trigger checkpoint is created.

**Logging and auditability:** Record **effect-caused** and **housekeeping** discards as distinct cause classifications. For effect-caused discards, log the originating effect/source, phase, individual card identities and count, grouped discard event identifier, actual qualifying occurrences, and queued/resolved/cancelled triggers as appropriate. For housekeeping discards, log the phase, card identities and count, reason **ROUTINE CLEANUP / NON-TRIGGERING**, and zero generated triggers. Keep the physical discard record even though housekeeping discards are ineligible for discard-trigger frequency or event counting under RULE-137. Preserve existing source eligibility, card-text limits, and mandatory event bookkeeping; do not invent a new interrupt or reaction window.

**Canonical example:** At the last independent Corporation ICE subroutine, the Runner has three non-CACHED cards and installed Software: *“Whenever you discard a card, gain 1 CRED.”* The subroutine reads *“Discard 2 cards from your hand. Then gain 2 BURN prevention.”* Two actual effect-caused discards form one grouped discard event and queue two per-card triggers (subject to limits). The subroutine finishes its printed instructions and grants 2 BURN prevention; only at the checkpoint do the two queued triggers resolve, gaining 2 CRED. Routine cleanup then discards the remaining non-CACHED card, records it as **ROUTINE CLEANUP / NON-TRIGGERING**, and generates **no CRED trigger**. If the checkpoint instead draws two new non-CACHED cards, they are also discarded in the same non-triggering cleanup batch.

**Reconciliation and priority:** RULE-138 reinforces RULE-010 printed instruction ordering; RULE-011–015 complete-effect/FIFO trigger ordering; RULE-016–019 loop safeguards; RULE-132 retained defensive hand and single post-response cleanup; RULE-133 nonretroactive effect-generated discard triggers; RULE-134 per-card and grouped event identity; RULE-135 actual damage/prevention trigger eligibility; RULE-136 effect boundaries and complete trigger checkpoints; and RULE-137's explicit non-triggering housekeeping exception. **RULE-137 remains controlling for cleanup-generated non-trigger eligibility.** This rule clarifies classification and logging without restoring superseded cleanup-trigger language in RULE-132–136 or altering established VOID/SyN/BURN damage, CACHE, prevention, DRAW, or immediate defeat mechanics. **Status: LOCKED, explicitly approved 2026-11-11.**
