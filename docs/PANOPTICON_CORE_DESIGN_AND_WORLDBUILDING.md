# PANOPTICON — Core Design & Worldbuilding

**Date:** 2026-11-10  
**Project:** PANOPTICON (preferred working title); REDLINE remains the GitHub repository and development codename.  
**Document status:** Structured design-session consolidation, not a verbatim transcript or a replacement for the Master Design and World Bible.  
**Sources:** REDLINE design discussions, `docs/REDLINE_MASTER_DESIGN.md`, `docs/REDLINE_BIBLE.md`, `docs/REDLINE_CURRENT_STATUS.md`, `docs/REDLINE_DEVELOPMENT_LOG.md`, and the design-session archive dated 2026-11-10.  
**Evidence boundary:** No new implementation, test results, or title clearance is asserted.

## 1. Purpose and governing principle

This document consolidates the project's game identity, central theme, established mechanics, proposed systems, and development-documentation strategy. It is intended to preserve creative intent for human designers and AI coding assistants without converting unapproved concepts into binding implementation requirements.

**Central question:** **What does humanity become when it knows it is being permanently observed and monitored?**

This is an open inquiry, not a predetermined claim that humanity necessarily becomes less human. The world should explore changes to behaviour, identity, culture, privacy, authenticity, intimacy, creativity, and consciousness across different people and generations.

## 2. Project identity and originality

**DECIDED:** An original, **single-player cyberpunk roguelike deckbuilder**. Its play identity is tactical card combat, evolving decks, resource constraints, synergistic builds, procedural variation, and Runner identities. It is not a Netrunner adaptation. Shared genre terminology and mechanical resemblance require a targeted originality audit, not indiscriminate removal of effective systems.

**DIRECTION:** PANOPTICON is the preferred working title, subject to clearance. Retain REDLINE paths and identifiers until a deliberate rename.

**Production:** Godot 4 is the chosen engine. Python/Pygame is historical reference and regression evidence, not the authority for future design.

## 3. Worldbuilding: observation changes the observed

**DIRECTION — internalized observer:** When scrutiny is possible but uncertain, people may regulate themselves without direct intervention. Surveillance becomes part of how choices are made, not simply a camera to avoid.

**DIRECTION — generational transformation:** In a society habituated to observation, privacy might be unfamiliar, suspicious, liberating, or frightening. Reactions can include accommodation, performance, creativity, withdrawal, resistance, dependence, and unexpected new social forms. Do not flatten the population into one response.

**DIRECTION — power beyond detection:** Observation may classify, predict, condition, constrain, and shape institutional incentives. Thematically, ask what monitoring *changes in people*, rather than only what a device sees.

**DIRECTION — lock and confinement motif:** Sealed thresholds, deadbolts, airlocks, vaults, inaccessible chambers, and oppressive observation architecture connect the Runner's movement from being **locked out** of a network to potentially being **locked in**. Panoptic architecture can inspire corporate network spaces without demanding literal circular prisons.

**DIRECTION — thematic gameplay:** Systems may notice patterns of Runner actions and influence the player's own behaviour. Effects must remain legible and fair; surveillance is not permission for arbitrary punishment. No independent Observation meter has been approved.

## 4. Narrative foundations and NUL/REM

**LOCKED:** The First Signal is an actual synchronization transmission in the story. The deeper mystery is not resolved. The World Bible also establishes the cosmological guidepost **“Every consciousness has a first signal”**: a recurring threshold of awareness or communication, not a finalized metaphysical explanation. Preserve both ideas without collapsing them into a single asserted answer.

**LOCKED:** NUL/REM is a companion whose humour is dry, sarcastic, and morose, enriched by retro-computing and classic video-game references. Preserve six modes: **The Pedant, The Cynic, The Melancholic, The Reluctant Guardian, The Unreliable Historian, and The Occasionally Delighted**. The contrast between a companion's sometimes protective attention and institutional surveillance is an open narrative opportunity.

**OPEN:** Identity of any ultimate observer; social consequences of true solitude; relationship between the First Signal and the surveillance theme; ultimate resolution of the mystery.

## 5. Locked encounter mechanics

- **ICE is the primary defender** at each defensive layer of a corporate node.
- **Turn order:** Runner acts; corporation then resolves remaining unbroken damage/Trace subroutines; breaking DEADLOCK permits advancement **after** the corporation turn. Do not skip retaliation or advance immediately when a DEADLOCK breaks.
- **NEURAL DAMAGE X:** Runner chooses X cards from their current hand and discards them.
- **SYNAPTIC DAMAGE X:** X randomly selected cards from the Runner's current hand are discarded.
- Neither of those two hand-discard effects reduces Vitae or permanently destroys cards.
- **PURGE:** Reserved for corporation removal of virus counters.
- **DEAD DROP:** Replaces Safehouse. Exactly one option: PATCH UP (+10 Vitae) or WIPE TRAIL (−20 Trace).
- **Hardware:** Recycled once at encounter end.
- **PATCHWORK:** Persists on individual card instances.
- **Ghostware:** Permanent and non-card.
- **UI directions:** `[STR X]` display, drag breakers to ICE, fixed ICE inspection bay, HUD tooltips, Ghostware rack below RETURN, signature Ghostware once with ORIGIN.
- **PAPER CUT:** Strength 0 ICE with minor damage/discard/DEADLOCK remains a **concept**, not an implemented or finalized card.

The exact formulas and edge-case ordering for several systems are still **OPEN/VERIFY**. Do not infer them from the summary above.

## 6. Node architecture and supporting defences

**DECIDED/DIRECTION:** A corporate node can contain multiple ICE defensive layers. Corporate support systems modify ICE encounters rather than replacing them with unrelated minigames. They may be **layer-local** or **node-wide** across multiple layers. The Runner need not defeat every support system to advance unless a specific approved rule says so.

**EXPLORATORY EXAMPLES — not card definitions:**
- A watchdog may respond to patterns of software use.
- A repair daemon may restore disabled defensive functionality.
- A bandwidth throttler may constrain certain plays.
- A corruption injector may contaminate the Runner's card cycle.

**OPEN:** Activation windows, duration, persistence, suppression, targeting, stacking, telegraphing, counterplay, cleanup, and exact interaction with ICE timing. No numerical values or card implementations are approved by these examples.

## 7. Card taxonomy and deck contamination

**DECIDED:** Viruses are a subtype of **deployable software**. Hardware and Software must be formally distinguished in fiction and game state. Do not automatically merge CAPS, Ghostware, or other existing objects into Software.

**ENDORSED DIRECTION:** Corporate defences may insert useless or harmful cards into the Runner's deck/hand/discard cycle, restricting choice and occupying draws. This expresses confinement through the deckbuilder's central resource.

**CONCEPTS ONLY:** Hostile cards might trigger on draw, while held at turn end, on discard, or on reshuffle; they might exhaust temporarily or persist through a layer, node, or longer. Their destinations, cleanup, interactions with NEURAL/SYNAPTIC damage, and numeric effects are not locked. Preserve the established VOID terminology and card-zone rules once fully recovered.

**OPEN:** Installed virus object model, host eligibility, counters, lifecycle, purge timing, deck-injection limits, and corruption removal.

## 8. Runner identities and build variety

**DIRECTION:** Runner identities should have distinct starting decks and strategic biases without permanent class restrictions; cross-archetype card acquisition should remain possible.

**PROPOSED — THE ECHO:** A larger 12-card starter and 6-card draw were discussed to create combination options, but exact values and roster require confirmation. More cards in hand must not imply extra BW or free plays.

**PROPOSED — THE VECTOR:** A virus/deployable-software specialist, with starter details and virus rules still open.

Other archetypes (stealth, hardware engineering, aggressive breaking) remain brainstorming, not approved roster.

## 9. Documentation-first development strategy

**RECOMMENDED WORKFLOW (not a new gameplay rule):** Treat GitHub design documentation as the primary authority for *what should be built*. Treat Python/Pygame as historical evidence of *what was previously built*. Do not silently promote implementation quirks to canon.

**Documentation hierarchy:**
1. **World Bible:** World, characters, themes, cosmology, and narrative boundaries.
2. **Master Design and formal rules specifications:** Approved gameplay rules, timings, state changes, terminology, and cross-system interactions.
3. **Decision register:** Each rule's ID, status, rationale, provenance, and test expectation.
4. **Current Status:** Verified operational state and next priorities.
5. **Development Log:** Dated record of decisions, code changes, and tests.
6. **Prototype and tests:** Reference implementation and evidence, subordinate to approved design.

**Priority specifications to prepare:**
- Game Rules Specification: turn/action economy, ICE/DEADLOCK timing, BW, Trace, Vitae, zones, card lifecycle, win/loss.
- Card & System Taxonomy: software, hardware, viruses, CAPS, Ghostware, PATCHWORK, corruption.
- Encounter & Corporate AI: layers, node-wide systems, triggers, counterplay, timing.
- Progression & Economy: Runner identities, decks, rewards, map, upgrades, run structure.
- Content Schema: machine-readable cards, ICE, subroutines, effects, statuses.
- Acceptance Tests: precise expected outcomes for every locked rule, including edge cases.

**Implementation rule:** An agent must not invent answers to unspecified mechanics. Mark gaps OPEN, propose alternatives, obtain explicit approval, then write acceptance tests and code.

## 10. Immediate design backlog

**P0:** Audit existing documentation for contradictions, omissions, and misclassified approvals. Define a complete ICE/node turn-state diagram without changing locked timing. Recover exact resource, zone, Trace, and win/loss definitions.

**P0:** Define software/hardware/virus/CAPS/Ghostware as distinct game-state entities and identify lifecycle boundaries.

**P1:** Resolve support-system timing and persistence. Specify corruption insertion, triggers, exhaustion, removal, and telegraphing. Prototype only after approval.

**P1:** Reconcile Runner starting decks, BW and draw constraints, card/ICE catalog, progression, and NUL/REM trigger design.

**P1:** Conduct a targeted originality review; do not confuse a proposed rename or mechanic with a completed clearance or implementation.

**P2:** Plan a Godot 4 vertical slice and parity tests, consulting Python selectively when documentation omits historical behaviour.

## 11. Unresolved questions and explicit safeguards

- Exact action economy, BW rules, Trace formula, Black ICE interactions, Vitae damage, and end-of-run conditions: **VERIFY/OPEN**.
- Complete catalog of cards, ICE, upgrades, status effects, and numeric balance: **VERIFY/OPEN**.
- Supporting defence lifecycle and behavioural-surveillance rules: **OPEN**.
- Corruption injection and card-zone semantics: **OPEN**.
- Virus deployment/counter/purge model: **OPEN**.
- Narrative truth behind the observer and First Signal: **OPEN**.
- Title clearance and repository rename: **OPEN**.

**Never interpret a conceptual example as an approved implementation. Never mark tests passing without reproducible evidence. Never overwrite locked rules based on prototype behaviour without explicit design approval.**

## 12. Provenance and maintenance

This is a **comprehensive design synopsis**, not a word-for-word transcript. It synthesizes established REDLINE project materials and the November 10 design discussion. Where source materials did not establish exact mechanics, the document labels them OPEN rather than filling them in. The four existing authoritative documents remain in force. Future changes should carry a decision ID, status, source, and test expectation.

**Suggested ChatGPT archive title:** PANOPTICON — Core Design & Worldbuilding.


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
