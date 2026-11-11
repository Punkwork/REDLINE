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
- Neither of those two hand-discard effects reduces Integrity or permanently destroys cards.
- **PURGE:** Reserved for corporation removal of virus counters.
- **DEAD DROP:** Replaces Safehouse. Exactly one option: PATCH UP (+10 Integrity) or WIPE TRAIL (−20 Trace).
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
- Game Rules Specification: turn/action economy, ICE/DEADLOCK timing, BW, Trace, Integrity, zones, card lifecycle, win/loss.
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

- Exact action economy, BW rules, Trace formula, Black ICE interactions, Integrity damage, and end-of-run conditions: **VERIFY/OPEN**.
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
