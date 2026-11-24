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

| EXP-C029 | BACKCHANNEL | SCRIPT | 2 BW; conditional delayed bypass with one non-DEADLOCK suspension; preferred iteration below. |

### EXP-C029 — BACKCHANNEL (designer-endorsed preferred experimental iteration, 2026-11-24)

**SCRIPT · 2 BW · rarity TBD**

> Select a supporting ICE with STR 2 or less. Suspend one of its non-DEADLOCK subroutines.
>
> If all subroutines on the primary ICE are broken by the end of your next turn, BYPASS the selected ICE. Otherwise, end the suspension.

BYPASS-001 applies. Primary ICE means rightmost ICE; supporting ICE means any ICE to its left (proposed terminology for this card, not a global rename). Designer endorsed the single-subroutine version for its variability. This is the preferred experimental design, not shipping rules or implementation authorization. Preserve 2 BW and STR 2 for initial balance evaluation.

Immediate tactical utility: choose damage prevention or TRACE suppression; concentrate resources on primary ICE; successful completion bypasses supporting ICE. Failure retains the benefit of temporary suspension but does not grant bypass. Unlike rapid penetration (EXP-M001), requires all primary ICE subroutines, not only DEADLOCKS, and allows through the following Rustler turn.

Alternatives retained for comparison: A normal supporting response until success; B suspend all supporting subs; C suppress TRACE only; D defer supporting consequences and resolve them on failure; E preferred single non-DEADLOCK suspension. Full suspension risks use solely as defense; deferred consequences add timing complexity.

Open: STR eligibility at selection versus continuous; exact suspension and success timing; passive interactions; TUMBLE and hidden subs; parting shots; multiple targets/copies; early BREACH or encounter exit; whether final-layer play for suspension alone is legal (no final-layer BYPASS under any interpretation). No retroactive cancellation assumed. Check existing card-name collisions before adoption.


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

| EXP-S009 | Eligible non-final layer: supporting FORTRESS STR2 with DEADLOCK, PULP4, TRACE2; primary SIGYL STR3 with DEADLOCK, PULP3, DEADLOCK. Play BACKCHANNEL for 2 BW; select PULP4 or TRACE2; break all three primary subs by end of next Rustler turn. | Selected sub suspended while pending; other supporting subs remain operative until bypass; success bypasses supporting ICE. | Compare tactical choices, actual legal BW and timing. |
| EXP-S010 | Same setup, miss deadline with a primary sub unbroken. | No bypass; suspension ends. | Verify normal subsequent resolution and no retroactive effects. |
| EXP-S011 | Same setup on final layer. | BYPASS prohibited; legality of suspension-only use unresolved. | Confirm card eligibility before implementation. |

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

| EXP-X004 | BACKCHANNEL offers meaningful defensive/stealth choice without dominating direct breaking. | Compare PULP versus TRACE suspension, success/failure, 2 BW opportunity cost, STR reduction synergy and final-layer restriction; test S009–011 and timing edge cases. | Proposed, not run |

Acceptance thresholds and fixtures require designer approval; use existing audit and test gates. Record actual results, build/commit, environment, seed, deviations and limitations; never label a hypothesis verified without evidence.

## 10 — Other design domains and decision register

New non-mechanical ideas use EXP-D IDs and link appropriate canonical domain documents. UI entries are pointers/cross-domain hypotheses only, with proposal details in native issues per UI-WORKFLOW-001. Narrative and philosophical examples link existing compendia; do not migrate their contents during current gate. Candidate cross-domain idea EXP-D001: successful deception through conformity to corporate expectations; “The most successful infiltrator might be the person who most convincingly resembles the ideal prisoner.” Explore as hypothesis, not mandated psychological outcome; preserve psychological invisibility and viable agency. M05/M04.

| Decision | Status | Reference |
|---|---|---|
| EXP-DESIGN-001 | Designer requested creation of shared all-domain experimentation Bible | Master Design |
| BYPASS-001 | Locked eligibility only | Master Design / Core Rules |
| EXP-M001–006, EXP-C001–027, EXP-S001–008, EXP-X001–003, EXP-D001 | Proposed/illustrative; no implementation authorization | This document |
| EXP-C028 | Deferred due to rules conflict | This document |
| EXP-C029 / BACKCHANNEL-001 | Designer-endorsed preferred experimental iteration; timing and balance open | §04, EXP-S009–011, EXP-X004 |

Initial population covers recent BYPASS discussion, not exhaustive recovery of all historical design ideas. Existing documents remain intact. No consolidation, code changes or playtests performed.

## 11 — RIOT signature cards and ZEROED engine (RIOT-EXP-001, 2026-11-24)

Origin: designer/ChatGPT discussion. Objective: distinguish RIOT through STR reduction, sequencing, direct breaks and temporary resource sacrifice. M01/M04. All new cards experimental, not adopted or authorized for implementation. Names and rarity subject to collision/balance review. Starter candidates are alternatives, not seven mandatory additions.

### Existing baseline (references, not new proposals)

See [Deck Synergy §5.3a and §9.2](REDLINE_DECK_SYNERGY.md), [card database](../godot/scripts/core/cards.gd) and [regression tests](../godot/tests/synergy_cases.gd). FLATLINE (common, 0 BW +2 TRACE): −2 STR, ZEROED −4 TRACE. KNOCKOUT (uncommon, 1 BW): −3 STR, ZEROED break one legal subroutine. SECOND WIND (uncommon, 0 BW): −1 STR, ZEROED gain 1 BW. NULL POINTER (rare, SCRIPT — EXPLOIT, BURNED): target STR 0, break two legal subs on same ICE including DEADLOCK; approved 1 BW under NULL-POINTER-001, runtime synchronization pending. All RIOT SCRIPT — EXPLOIT. STR reductions last encounter. ZEROED first positive-to-zero transition per ICE per encounter, any cause consumes it; only printed ZEROED finisher pays bonus. Excess reduction lost; ROT exception per Core Rules. Starting-zero and positive-floor ICE ineligible. Common bonus working value ~1 BW, uncommon break or BW; TRACE relief particularly useful for RIOT. INTEGER UNDERFLOW withdrawn. Tests inspected, not executed.

### New cards

| ID | Card | Cost | Preferred experimental effect | Status |
|---|---|---|---|---|
| EXP-C030 | STRUCTURAL WEAKNESS | 1 BW | Target FORTRESS −3 STR this encounter. | PROPOSED |
| EXP-C031 | FRACTURE | 1 BW | Target ICE −1 STR this encounter; if it has a broken subroutine, additional −2 STR. | PROPOSED |
| EXP-C032 | FIRST STRIKE | 1 BW | Target ICE −3 STR this encounter. If first card played this turn, reduce this card's cost by 1 BW. | REVISED, designer-endorsed |
| EXP-C033 | EXPOSED CIRCUIT | 1 BW | Target ICE −1 STR per unbroken subroutine, maximum −3. | PROPOSED |
| EXP-C034 | SABOTEUR | 1 BW | Target supporting ICE −3 STR; cannot target rightmost ICE. | PROPOSED |
| EXP-C035 | CRITICAL MASS | 1 BW | Target ICE −1 STR; if current STR ≥5, −3 instead. | PROPOSED |
| EXP-C036 | BREAKER BAR | 0 BW initially | BURN another card in hand as additional cost; break one legal subroutine on target ICE STR ≤3; increase this physical card's BW cost by 1 for remainder of node. | REVISED, designer-endorsed experimental direction |

All are candidate RIOT-exclusive starter SCRIPT — EXPLOIT cards; classification for other candidates provisional. Reduction duration encounter proposed for all. FIRST STRIKE original alternative: −3 if first card, otherwise −1; superseded by unconditional −3 and first-card cost discount (not post-resolution BW gain). Can open at zero available BW if otherwise legal. FRACTURE rewards attack-first sequencing; CRITICAL MASS high-STR targets; EXPOSED CIRCUIT complex ICE (whether hidden subs count open); SABOTEUR BACKCHANNEL preparation; STRUCTURAL WEAKNESS type specialization. CRITICAL MASS can still consume ZEROED on low-STR targets; no automatic protection.

### EXP-C036 — BREAKER BAR signature specification

One copy in RIOT starter deck (designer confirmed); additional acquisition during run open. Any ICE type, DEADLOCK eligible subject to normal restrictions. Not itself BURNED. Player chooses another card to BURN; cannot pay without another eligible card. Base cost 0 BW preferred experimental variant, mandatory sacrifice; each successful play increases cost of that physical copy by 1 BW, independently, for current node, resets at next node. Costs 0/1/2/3/4 on first five plays plus sacrifice each time. Earlier alternatives retained: flat 1 BW, escalating from 1 BW, encounter or run duration (node chosen), two starter copies (superseded by one). Confirm precise payment/choice cancellation, COMPILE interaction, copied cards, BURN eligibility and persistence, REBOOT timing, UI cost display, and whether zero-cost first use is balanced. No implementation approval. Deck slot replacement not decided.

### Additional BYPASS concepts

EXP-M007 (PROPOSED): distinguish a printed ZEROED-triggered conditional BYPASS from a card that exploits already-zero supporting ICE (NULL POINTER-style payoff; overlaps EXP-M005/EXP-C007). No exact new card cost or text agreed. BYPASS-001 final-layer prohibition remains binding; no automatic bypass.

### Scenarios

| ID | Setup/actions | Expected under proposal / question |
|---|---|---|
| EXP-S012 | ICE STR5; illustrative PROBE −2 → STR3; KNOCKOUT −3. | ZEROED free legal break; compare alternatives below. |
| EXP-S013 | Same STR3 after PROBE; SECOND WIND then FLATLINE. | STR2 then 0; FLATLINE bonus −4 TRACE, +2 TRACE cost, net −2 if sufficient TRACE. |
| EXP-S014 | Same STR3; FLATLINE then SECOND WIND. | STR1 then 0; gain 1 BW, pay +2 TRACE; no FLATLINE bonus. |
| EXP-S015 | Same STR3; ordinary reductions to 0 (e.g. two PROBEs). | No printed bonus; ZEROED spent. Later printed ZEROED cannot trigger; NULL POINTER still eligible. PROBE values illustrative, verify actual card definition. |
| EXP-S016 | FIRST STRIKE first card against STR5 supporting ICE. | 0 BW, STR2, BACKCHANNEL eligible only where legal; BACKCHANNEL costs 2 BW and its own conditions apply. Later FIRST STRIKE costs 1 BW. |
| EXP-S017 | Original BREAKER BAR variant: STR6 → FIRST STRIKE (0 BW) → BREAKER BAR (1 BW) → KNOCKOUT (1 BW) → NULL POINTER (1 BW). | Four legal breaks for 3 BW if all cards and four legal subs available. Historical scenario, superseded cost variant retained. |
| EXP-S018 | Revised BREAKER BAR first use: same sequence as S017, plus another eligible card to BURN. | Four legal breaks for 2 BW plus one BURN; BREAKER BAR next cost 1. If no sacrifice or legal sub, cannot assume play succeeds. |
| EXP-S019 | Repeated BREAKER BAR across encounters in same node; REBOOT with smaller available deck. | Cost increases per physical copy, BURN may accelerate circulation but sacrifices useful cards; new node resets cost. Test two copies independently if acquired. |
| EXP-S020 | FRACTURE before vs after legal break; CRITICAL MASS on STR4 vs STR5; EXPOSED CIRCUIT on one vs three subs; SABOTEUR on supporting vs primary. | Compare threshold/ordering value, hidden subs, target legality and risk of consuming ZEROED. |
| EXP-S021 | Supporting ICE STR3/2/0 on eligible vs final layer. | BREAKER BAR ≤3, BACKCHANNEL ≤2 subject to open final-layer suspension legality, ZEROED transition and NULL POINTER at 0 distinct; no final-layer BYPASS. |

### EXP-X005 — RIOT starter engine viability (PROPOSED, not run)

Compare baseline RIOT and candidate starter replacements on identical seeds. Measure first-turn legal breaks, BW, TRACE, BURN choices, deck circulation/REBOOT, ZEROED finishers, Icepick use, dead draws, multi-encounter cost escalation and final-layer performance. Compare flat 1 BW, escalating 1 BW and preferred escalating 0 BW + BURN; one copy preferred, additional copies only experimental. Test no sacrifice, no legal sub, positive STR floor, already-zero, TUMBLE/BOOTING/SEQUENCED, multiple copies, node reset and early BREACH. Risks: free opening burst, deck thinning too strong, redundant Icepicks, escalating cost makes signature card dead, excessive starter size. No measured balance claims or test authorization. 
