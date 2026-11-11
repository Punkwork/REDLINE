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
