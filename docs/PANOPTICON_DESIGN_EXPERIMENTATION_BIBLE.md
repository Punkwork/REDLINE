# PANOPTICON — Design Experimentation Bible

EXP-DESIGN-001 · 2026-11-24 · Living exploratory record, not rules authority.

## 01 — Purpose and boundaries

Capture new design ideas across mechanics, cards, ICE, deck engines, UI, narrative, philosophical manifestations, art, audio, accessibility and player experience. Preserve alternatives, scenarios, assumptions, objections and evidence. The goal is meaningful progress toward OPS-002a, commercial Steam launch, not expansion for its own sake.

Master Design and Core Rules govern approved mechanics; topic bibles govern their domains. This is not a second backlog or a replacement for existing catalogues. UI-WORKFLOW-001 remains binding: native GitHub issues own UI proposals, discussion, mockups, approval and validation; this Bible may index those issues and cross-domain hypotheses without duplicating them. Existing dialogue and philosophical catalogues retain their detailed content. DOCS-MIG-001 blocks consolidation, relocation and retirement until UI-BIBLE-001 passes; this new record captures recent ideas only.

## 02 — Proposal lifecycle and template

Stable IDs EXP-M### (mechanic), EXP-C### (card), EXP-S### (scenario), EXP-X### (experiment), EXP-D### (other design concept). Status: IDEA, PROPOSED, REVISED, TEST AUTHORIZED, TESTED, ADOPTED, REJECTED, DEFERRED. Only designer authorizes tests or adoption; record authoritative decision ID and links on adoption. Preserve rejected alternatives and reasons. No proposed text is shipping copy or an implementation instruction.

For each entry record date, origin, domain, objective, proposed behavior, existing constraints, alternatives, scenario IDs, assumptions, unresolved questions, risks, milestone, evidence and status. Link actionable work to native issues; no parallel task list. Evaluate before implementation, then test only with authorization.

## 03 — Mechanics proposals: BYPASS

Source: designer/ChatGPT discussion 2026-11-24, inspired by Shadowrun's fictional decker approaches. All below PROPOSED except the referenced locked eligibility rule.

**BYPASS-001 (locked in Master/Core Rules):** only non-final encounters of a Node of up to three encounters are eligible. Single encounter: none; two: first only; three: first and second only. No effect overrides final-encounter prohibition. Eligibility is not success.

| ID | Concept | Proposed behavior | Open concern |
|---|---|---|---|
| EXP-M001 | Rapid penetration (designer idea) | In a two-ICE eligible encounter, break all main ICE DEADLOCKS on Rustler turn 1; supporting ICE is bypassed, its DEADLOCK need not be broken and none of its subroutine consequences occur. | Intrinsic versus card-enabled; three ICE, passive timing, extraction, parting shot. |
| EXP-M002 | STR superiority | Matching Icepick exceeds supporting ICE STR by illustrative margin 2. | Activation cost, temporary boosts, cheap bypass. |
| EXP-M003 | Silent penetration | Break all TRACE subroutines on supporting ICE on turn 1 to qualify. | ICE with no TRACE must not qualify vacuously unless explicitly intended. |
| EXP-M004 | Exploiting an opening | Break all non-DEADLOCK subs on supporting ICE to bypass its DEADLOCK. | Empty non-DEADLOCK set, TUMBLE, multiple DEADLOCKS. |
| EXP-M005 | Zero-strength penetration | Reduce supporting ICE STR to zero to qualify. | ZEROED interaction, existing STR floor, repeatability. |
| EXP-M006 | False authorization | Spoof access rather than break security. | Distinction from bypass, duration and cost; no final-layer bypass. |

BREAK neutralizes a security function; BYPASS leaves it intact but irrelevant to immediate access (conceptual distinction, not finalized resolution). Combat, evasion, deception and sabotage are candidate approaches; escape conflicts with current no-escape direction and is not proposed as an approved change. All mechanisms above target M01/M04.

## 04 — Experimental card catalogue

Names, types and effects are provisional; check collisions against actual card pools before adoption. BW, RAM, rarity, timing and target legality unset unless stated. All BYPASS effects subject to BYPASS-001.

| ID | Card | Type (proposed) | Effect |
|---|---|---|---|
| EXP-C001 | BACKDOOR | SCRIPT | Bypass supporting ICE STR 2 or less. |
| EXP-C002 | PIGGYBACK | SCRIPT | After breaking main ICE DEADLOCK, bypass supporting ICE of same type. Earlier alternative: temporarily bypass one DEADLOCK. |
| EXP-C003 | RACE CONDITION | SCRIPT | Turn 1: breaking all main ICE DEADLOCKS permits one supporting ICE bypass; only if M001 is card-enabled. |
| EXP-C004 | GHOST ROUTE | SCRIPT | Bypass supporting ICE with no remaining unbroken TRACE subs. Earlier alternative: generic bypass with reduced extraction. |
| EXP-C005 | PORT FORWARD | SCRIPT | Bypass supporting FORTRESS if main ICE is SIGYL. |
| EXP-C006 | FALSE CREDENTIALS | SCRIPT | Bypass supporting ICE for additional TRACE. |
| EXP-C007 | TUNNEL | PROGRAM | Once per encounter bypass eligible supporting ICE at STR 0. |
| EXP-C008 | ROOT ACCESS | PROGRAM | Once per encounter bypass supporting ICE when matching Icepick exceeds STR by 2+. |
| EXP-C009 | ZERO FOOTPRINT | PROTOCOL | If no TRACE gained this encounter, bypass one eligible supporting ICE. |
| EXP-C010 | FAST TRACK | PROTOCOL | Extend rapid penetration through turn 2, never final layer. |
| EXP-C011 | WEAK LINK | SCRIPT | Reduce supporting ICE STR by 2. |
| EXP-C012 | SLIPSTREAM | PROTOCOL | Gain 1 BW after bypass, once per encounter. |
| EXP-C013 | RESIDUAL ACCESS | TBD | Draw a card after bypass. |
| EXP-C014 | CLEAN ENTRY | TBD | Prevent next TRACE gain after bypass. |
| EXP-C015 | CHAIN REACTION | TBD | Reduce another ICE STR by 2 after bypass. |
| EXP-C016 | DATA SIPHON | TBD | Gain CRED after bypass. |
| EXP-C017 | OPEN CHANNEL | TBD | Next Icepick activation costs 1 less BW after bypass. |
| EXP-C018 | GHOST SIGNAL | TBD | Prevent TRACE from selected ICE this turn. |
| EXP-C019 | BLIND SPOT | TBD | Suppress next detection-triggered effect. |
| EXP-C020 | WHITELIST | TBD | Selected ICE treats Rustler as authorized for one turn. |
| EXP-C021 | FALSE ALARM | TBD | Redirect security response away from Rustler. |
| EXP-C022 | KILL SWITCH | TBD | Suspend selected ICE passive. |
| EXP-C023 | SHORT CIRCUIT | TBD | Prevent selected non-DEADLOCK sub from executing this turn. |
| EXP-C024 | SYSTEM FREEZE | TBD | Temporarily suspend ICE operations. |
| EXP-C025 | BLACKOUT | TBD | Prevent detection-related effects for a turn. |
| EXP-C026 | DEAD CIRCUIT | TBD | Suspend ICE passive for a turn, subs intact. |
| EXP-C027 | FALSE POSITIVE | TBD | ICE interprets Rustler as authorized process. |
| EXP-C028 | EMERGENCY DISCONNECT | TBD | Withdraw at strategic cost; DEFERRED, conflicts with current no-escape direction. |

Dedicated bypass cards may be dead draws on final layers; dual-purpose alternatives could retain a separate non-bypass effect. Neither category approved. Passive suppression and concealment must not silently grant final-layer bypass.

## 05 — Gameplay scenarios

Illustrative ICE values, not canonical stats; assume legal matching Icepick and sufficient BW where stated, not a claim about actual card costs.

| ID | Setup and actions | Expected under proposal | Question |
|---|---|---|---|
| EXP-S001 | First layer of two-layer Node. Supporting FORTRESS STR4: DEADLOCK, TRACE3, PULP4. Main SIGYL STR3: DEADLOCK, DEADLOCK, PULP3. Turn 1 break both main DEADLOCKS. | Supporting ICE bypassed, no supporting sub consequences. Main ICE resolution follows applicable rules; not specified by proposal. | When is bypass committed? |
| EXP-S002 | Same as S001 but only one main DEADLOCK broken on turn 1. | Rapid penetration condition fails; normal unresolved threats remain. | Does risk justify focusing main ICE? |
| EXP-S003 | Same configuration on final layer, or single-layer Node. | No bypass even if both main DEADLOCKS broken on turn 1. | UI explains restriction; no accidental benefit. |
| EXP-S004 | Eligible layer, supporting STR3; matching Icepick boosted to STR5. | M002 condition met if margin 2 adopted. | Compare BW cost to normal breaking. |
| EXP-S005 | Eligible layer; supporting ICE has two TRACE subs, both broken turn 1. | M003 condition met. | Test no-TRACE and hidden TRACE variants. |
| EXP-S006 | Eligible layer; reduce supporting STR2 to 0 with WEAK LINK; TUNNEL bypass; SLIPSTREAM gains 1 BW if installed/eligible. | Illustrative engine; no assumed free installation or guaranteed net BW gain. | ZEROED, RAM and frequency interactions. |
| EXP-S007 | Three ICE, main DEADLOCKS broken turn 1. | Unresolved: bypass one, both, or neither supporting ICE. | Designer decision required. |
| EXP-S008 | FAST TRACK on final layer, turn 2. | No bypass; locked rule takes precedence. | Test all card-enabled overrides. |

## 06 — Archetypes and engines

Combat: direct STR and breaks. Stealth: TRACE control. Deception: authorization manipulation. Sabotage: passive and subroutine suppression. Infiltration: conditional bypass. Hybrid: retains final-layer combat capability. Candidate engine WEAK LINK → TUNNEL → SLIPSTREAM; alternative payoffs draw, CRED, STR reduction or cheaper activation. Explore FORTRESS STR weakness, SIGYL logical manipulation, VOID TRACE suppression as hypotheses, not type rules.

## 07 — Rules interactions and edge cases

Before formal specification reconcile current Core Rules and Core Loop, BREACH timing, END TURN, parting shots, TUMBLE, hidden subs, ZEROED, passive timing, extraction/full-clear rewards, multiple supporting ICE, main ICE identification, turn counting, once-per-encounter limits, card copies and trigger ordering. Define whether bypass is permanent for layer or temporary, whether it counts as broken for other triggers (default not assumed), whether prior consequences remain, and whether later effects can invalidate eligibility. No retroactive damage cancellation assumed. Final-layer prohibition is invariant. Check bosses, no-DEADLOCK supporting ICE, empty condition sets, multiple bypasses, resource loops and dead cards. Do not conflate bypass with escape.

## 08 — Viability assessment

Evaluate strategic depth, mechanical distinctiveness, deckbuilding potential, opportunity cost, counterplay, replayability, learnability, rules compatibility, thematic relevance, implementation/QA cost. Record qualitative judgment separately from evidence. Rapid penetration: promising low conceptual overhead, risk of dominant first-turn burst. STR superiority and zero STR: promising synergy, risk of trivialization. Silent penetration: alternative priorities, risk of vacuous conditions. Unconditional bypass: low decision depth unless cost meaningful. No measured scores or balance claims. Possible trade-offs: TRACE, CRED, reduced extraction, RAM, cards, timing, STR investment; no universal penalty decided.

## 09 — Playtest experiments

| ID | Hypothesis | Method and observations | Status |
|---|---|---|---|
| EXP-X001 | Rapid penetration adds meaningful target prioritization. | Compare baseline and proposal on same representative seeds and Rustlers; log first-turn success, BW, damage, TRACE, extraction, decisions and final-layer viability. | Proposed, not run |
| EXP-X002 | Dedicated versus dual-purpose cards create distinct deckbuilding choices. | Compare draw usefulness, dead draws on final layers, deck composition and player explanations. | Proposed, not run |
| EXP-X003 | Bypass engine is not dominant or infinite. | Test STR reduction, repeated activations, resource payoffs and three-ICE cases; check final-layer invariant. | Proposed, not run |

Acceptance thresholds and fixtures require designer approval; use existing audit and test gates. Record actual results, build/commit, environment, seed, deviations and limitations; never label a hypothesis verified without evidence.

## 10 — Other design domains and decision register

New non-mechanical ideas use EXP-D IDs and link appropriate canonical domain documents. UI entries are pointers/cross-domain hypotheses only, with proposal details in native issues per UI-WORKFLOW-001. Narrative and philosophical examples link existing compendia; do not migrate their contents during current gate. Candidate cross-domain idea EXP-D001: successful deception through conformity to corporate expectations; “The most successful infiltrator might be the person who most convincingly resembles the ideal prisoner.” Explore as hypothesis, not mandated psychological outcome; preserve psychological invisibility and viable agency. M05/M04.

| Decision | Status | Reference |
|---|---|---|
| EXP-DESIGN-001 | Designer requested creation of shared all-domain experimentation Bible | Master Design |
| BYPASS-001 | Locked eligibility only | Master Design / Core Rules |
| EXP-M001–006, EXP-C001–027, EXP-S001–008, EXP-X001–003, EXP-D001 | Proposed/illustrative; no implementation authorization | This document |
| EXP-C028 | Deferred due to rules conflict | This document |

Initial population covers recent BYPASS discussion, not exhaustive recovery of all historical design ideas. Existing documents remain intact. No consolidation, code changes or playtests performed.
