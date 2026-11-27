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

## 12 — TRACE mitigation: Ghostware and Protocols (TRACE-EXP-001, 2026-11-24)

Origin: designer/ChatGPT discussion; designer requested preservation of all five ideas. Objective: diversify TRACE mitigation and conditional deck engines (M04). All PROPOSED, designer-endorsed for exploration, not adopted or authorized for implementation. Names provisional; check collisions. Acquisition, rarity, installation cost, RAM and duration follow applicable canonical type rules once specified; no new type rules adopted.

| ID | Name | Type | Experimental text |
|---|---|---|---|
| EXP-C037 | SIGNAL DAMPENER | GHOSTWARE | Reduce all incoming TRACE gains by 1, to a minimum of 0. |
| EXP-C038 | SILENT RUNNING | PROTOCOL | Reduce the first TRACE gain each turn by 2. |
| EXP-C039 | CLEAN HANDSHAKE | PROTOCOL | Whenever you break a TRACE subroutine, lose 1 TRACE. |
| EXP-C040 | SIGNAL SCRAMBLER | PROTOCOL | Whenever you ZERO an ICE, lose 2 TRACE. |
| EXP-C041 | RADIO SILENCE | PROTOCOL | If you play no EXPLOIT cards during your turn, reduce the next corporate response's total TRACE by 2. |

SIGNAL DAMPENER originally proposed as installed Protocol with permanent reduction of every TRACE source by 1 or 2; designer preferred Ghostware classification and 1 as initial value. Retain 2 as alternative for comparison. Proposed coverage includes self-inflicted TRACE such as FLATLINE, ICE subs and passives; exact coverage, threshold timing and stacking remain open. SIGNAL SCRAMBLER's ZERO wording is provisional: reconcile with canonical ZEROED first positive-to-zero transition and printed-finisher eligibility before implementation; do not silently change existing ZEROED rules.

EXP-M008 (PROPOSED design hypothesis): Ghostware provides persistent fundamental rule modifiers; installed Protocols provide conditional effects responding to circumstances, actions or sequences. This is an exploratory distinction, not a universal type definition or replacement for current rules.

| ID | Scenario | Expected under proposal / open question |
|---|---|---|
| EXP-S022 | SIGNAL DAMPENER: four separate TRACE gains of 4, 2 (card), 1 (passive), 3. | Modified gains 3, 1, 0, 2; total 6 instead of 10 if all sources covered. |
| EXP-S023 | SIGNAL DAMPENER and FLATLINE (+2 TRACE, ZEROED −4 TRACE). | Proposed gain becomes +1; ZEROED relief unchanged, subject to meter floor and timing. |
| EXP-S024 | SILENT RUNNING: first gain 3, second gain 2. | First becomes 1, second remains 2; clarify Rustler/corporate turn boundaries, zero-floor and first-event consumption. |
| EXP-S025 | CLEAN HANDSHAKE: legally break two TRACE subs. | Lose 1 TRACE per break, subject to meter floor; distinguish breaking from suspension/bypass. |
| EXP-S026 | SIGNAL SCRAMBLER: ICE STR3 reduced to 0, then later raised and reduced to 0 again. | First transition candidate for −2 TRACE; repeat trigger and ordinary reduction versus printed ZEROED finisher require explicit decision. |
| EXP-S027 | RADIO SILENCE: no EXPLOIT played; next corporate response has gains 1 and 3. | Total 2 rather than 4 under aggregate interpretation; compare turn with EXPLOIT played (no discount). Clarify sequential application and threshold timing. |

EXP-X006 (PROPOSED, not run): compare persistent per-source reduction (1 vs 2), first-gain reduction, break reward, ZEROED reward and EXPLOIT abstention on representative seeds. Measure TRACE thresholds, source frequency, opportunity cost, synergy with RIOT/FLATLINE, installation timing, duplicate stacking and whether passive reduction trivializes low-value TRACE. Clarify minimum zero, whether reductions apply before threshold checks, aggregate versus sequential corporate response handling, simultaneous triggers, zero-gain events and interaction with existing prevention. No balance evidence or implementation authorization.

## 13 — CRED-powered combat and CAPITAL ENGINE (CRED-EXP-001, 2026-11-24)

Designer-endorsed experimental direction: **BW represents immediate computational capacity. CRED represents accumulated purchasing power.** CRED-powered Icepicks circumvent computational limitations through wealth. Both STR increases and subroutine breaks consume zero BW during activation; installation costs 1 BW for each of EXP-C042–044 (designer-confirmed experimental revision CRED-EXP-001a). Conventional legality, matching ICE type and strength requirements remain applicable. No new shipping rules or implementation authorization.

| ID | Card | Type | Base STR | Activation |
|---|---|---|---|---|
| EXP-C042 | PAYDAY | PROGRAM — ICEPICK (FORTRESS) | 2 | 3 CRED: +1 STR; 5 CRED: break 1 FORTRESS subroutine. |
| EXP-C043 | BRIBE | PROGRAM — ICEPICK (TUMBLER) | 3 | 4 CRED: +1 STR; 4 CRED: break 1 TUMBLER subroutine. |
| EXP-C044 | MERCENARY | PROGRAM — ICEPICK (VOID) | 2 | 3 CRED: +1 STR; 6 CRED: break 1 VOID subroutine. |
| EXP-C045 | BLACK BUDGET | SCRIPT | 0 BW | 5 CRED: gain 1 BW. |
| EXP-C046 | BOUNTY HUNTER | SCRIPT | 0 BW | 4 CRED: target ICE −2 STR this encounter. |
| EXP-C047 | HUSH MONEY | SCRIPT | 0 BW | 5 CRED: lose 3 TRACE. |
| EXP-C048 | INSIDER TRADING | SCRIPT | 0 BW | 3 CRED: draw 1 card. |
| EXP-C049 | RANSOM | SCRIPT | 0 BW | 8 CRED: suspend one non-DEADLOCK subroutine until your next turn. |

All PROPOSED. Names, prices, strengths, rarity, other deployment costs, RAM, boost duration and limits subject to review. Each of PAYDAY, BRIBE and MERCENARY costs 1 BW to install; RAM requirements are 1, 1 and 2 respectively; activation costs remain entirely CRED. Initial Icepick proposal: PAYDAY as above; BRIBE +1 STR for 1 BW, break for 4 CRED; MERCENARY +1 STR for 3 CRED, break for 1 BW. Superseded as preferred experiment by entirely CRED-powered activations. No arbitrary once-per-turn Icepick activation cap initially proposed; economic cost is primary balancing lever. No free activation or installation assumption.

EXP-M009: extend M008 type distinction: SCRIPT immediate single-use; PROGRAM installed utility or ICEPICK (RAM required); PROTOCOL deployed to RACK for BW, no RAM, active for Node, with primarily continuous, recurring, conditional or automatic triggered benefits; manual activation is an exception to explore; GHOSTWARE persistent non-card upgrade; BLOATWARE detrimental card type. Classification corrected against Core Rules §3.1; proposed activation effects remain experimental. Preserve triggered Protocols C038–041.

EXP-M010: CAPITAL ENGINE archetype: extract CRED → activate Protocols/Icepicks → neutralize ICE efficiently → secure further CRED. Renewable BW versus accumulated wealth creates opportunity cost between combat and future purchases. RIOT STR reduction can reduce CRED expenditure; no RIOT exclusivity proposed.

EXP-M011: voluntary fictional surveillance income. Small individually useful incentives can collectively support a CRED-powered deck. Illustrative offers, not approved prices or mechanics:

| Fictional information shared | Benefit |
|---|---|
| Encounter history | +1 CRED per encounter |
| Deck composition | +1 CRED per node |
| Installation history | Reduced activation cost (historical Protocol concept; reassess for revised SCRIPT classification) |
| Route-selection history | Additional extraction income |
| Purchasing history | Personalized discounts |
| Continuous behavioural monitoring | Recurring CRED dividend |

NUL/REM may offer relevant arrangements after genuine CRED shortfalls or repeated use; see NR-076–079 in [Dialogue Compendium](PANOPTICON_NULREM_DIALOGUE_COMPENDIUM.md). See [Philosophical Design Bible](PANOPTICON_PHILOSOPHICAL_DESIGN_BIBLE.md) for economic dependency rationale and safeguards. Fictional data only; intelligible voluntary terms; independent play remains viable. No actual surveillance, compulsory participation or psychological classification.

| ID | Scenario | Expected under proposal / question |
|---|---|---|
| EXP-S028 | Already installed PAYDAY, 3 BW, 30 CRED, FORTRESS STR5 with two legal DEADLOCK subs. | Three boosts cost 9 CRED, two breaks cost 10; 11 CRED and all 3 BW remain, assuming legal activations. |
| EXP-S029 | Same encounter with STR reduction Script first. | Trade BW for reduced CRED boost expenditure; compare resource efficiency and ZEROED interactions. |
| EXP-S030 | CRED-powered Icepick at zero BW, sufficient CRED versus insufficient CRED. | Activation independent of BW; insufficient CRED cannot pay; test legality and no partial payment. |
| EXP-S031 | BLACK BUDGET, extraction and CRED generation combined. | Test conversion loops, caps and net income; no assumed self-financing. |
| EXP-S032 | One CRED short of a useful activation; optional encounter-history offer available. | Small benefit may enable activation; refusal remains viable, no mandatory acceptance or inferred motive. |
| EXP-S033 | Several small income arrangements accumulated over a run versus independent economy. | Compare combat efficiency, purchasing opportunity cost, diversity and viability; no predetermined psychological outcome. |
| EXP-S034 | RANSOM on non-DEADLOCK versus DEADLOCK; HUSH MONEY near zero TRACE; repeated SCRIPT plays after redraw and payment. | Verify timing, floor, frequency and legal targets; suspension not automatically break or BYPASS. |

EXP-X007 (PROPOSED): compare conventional BW Icepicks, fully CRED-powered variants and historical hybrid alternatives on identical seeds; track CRED/BW, break rates, extraction, shop spending, deck synergy, zero-BW activation, insufficient funds, boost duration, stacking, activation limits, loops and run viability. Compare voluntary income arrangements against independent CRED generation; avoid tuning to compel disclosure. Test small marginal benefits, accumulated costs and ability to decline. No tests performed.

CRED-EXP-001a: designer specified 1 BW installation for all three proposed CRED-powered Icepicks. EXP-S035: install PAYDAY with 3 BW and 30 CRED, then perform S028 activations if legal; 2 BW and 11 CRED remain. At zero BW an uninstalled Icepick cannot pay installation, but an already installed one can activate with sufficient CRED. Add these cases to X007. No Protocol installation cost decision.

CRED-EXP-001b: designer clarified EXP-C042–044 are PROGRAM cards (ICEPICK specialization), requiring RAM under normal installation rules. RAM requirements (designer-confirmed experimental revision CRED-EXP-001c): PAYDAY 1 RAM, BRIBE 1 RAM, MERCENARY 2 RAM. Installation remains 1 BW, all boosts and breaks CRED-only. Test insufficient RAM and normal unload rules in X007. Other Protocol proposals unchanged.

CRED-EXP-001c: designer specified PAYDAY 1 RAM, BRIBE 1 RAM, MERCENARY 2 RAM. All other experimental values unchanged. EXP-S036: with 4 available RAM, all three occupy 4 RAM; test insufficient RAM, unloading and competition with utility Programs in X007. No implementation authorization.

## 14 — VOID forced Program uninstallation (VOID-EXP-001, 2026-11-24)

EXP-M012 (PROPOSED): Programs reward investment in persistent infrastructure. VOID ICE threatens that investment. Designer brainstorming, not shipping approval. Program economics: initial BW, occupied RAM (foregone utility/coverage), ongoing BW/CRED activation, deck slots, persistence across Node encounters, vulnerability to removal, repeat installation BW and draw delay. Existing voluntary unload is 0 BW to discard (Core Rules §3.1); do not change it.

Candidate VOID-exclusive subroutine **UNLOAD**: The Rustler chooses one installed Program. Uninstall it and place it in the discard pile. RAM immediately released; no BURN. Any installed Program including Icepicks and Extractors eligible. No installed Programs: no effect. Protocols and Ghostware immune. Normal reinstallation cost. Player choice preferred by designer; random selection retained as comparison, not preferred. No additional TRACE, CORTEX or reinstallation surcharge initially. Name provisional. Forced removal occurs during Corporation Response under existing VOID reveal/activation and break legality; no new rules approved. Progressive revelation can surprise on first execution, then allow prioritization; repeated executions threaten persistent infrastructure. Program-heavy versus SCRIPT-heavy deck vulnerability and MERCENARY's 2 RAM investment are hypotheses.

| ID | Scenario | Expected under proposal / question |
|---|---|---|
| EXP-S037 | Four 1-RAM Programs installed: PAYDAY, BRIBE, Extractor, utility; UNLOAD fires. | Choose Extractor to preserve combat or Icepick to preserve income; chosen card discarded, 1 RAM freed. |
| EXP-S038 | MERCENARY occupies 2 RAM; choose it for UNLOAD. | Release 2 RAM; lose VOID breaking access until reinstalled. |
| EXP-S039 | No installed Programs, only Protocols/Ghostware. | No effect; no other target substituted. |
| EXP-S040 | Hidden UNLOAD first fires, then repeats on later responses. | Test reveal, legal break counterplay, repeated selection and progressive loss; no forced random choice. |
| EXP-S041 | Removed Program drawn again or REBOOT occurs. | Normal discard circulation and installation cost; verify boost/state reset and existing unload-trigger interactions before adoption. |
| EXP-S042 | All DEADLOCKs neutralized before response. | Existing BREACH response skip applies; UNLOAD does not fire. |

EXP-X008 (PROPOSED): compare player-selected versus random removal and baseline without UNLOAD on identical seeds; track reinstall BW, RAM occupancy, income lost, Icepick availability, turns, deck diversity, meaningful sacrifice, recovery and frustration. Compare Program-heavy and SCRIPT-heavy decks, frequency/placement of UNLOAD, multiple VOID ICE, no eligible targets, selection UI during response, and interactions with existing paid/voluntary unload triggers (do not assume forced removal qualifies). Preserve viable Program investment and counterplay; no tests performed. 

## 15 — Card-type identity and CRED SCRIPTS (CRED-EXP-001d, 2026-11-24)

Designer-confirmed experimental revision: EXP-C045–049 BLACK BUDGET, BOUNTY HUNTER, HUSH MONEY, INSIDER TRADING and RANSOM are SCRIPT cards, 0 BW, with respective CRED costs 5/4/5/3/8. Effects unchanged; resolve once per play, no RAM, discard after resolution, normal redraw/REBOOT and payment required for reuse. Remove previous once-per-turn/encounter activation caps from preferred experiment; historical installed Protocol versions superseded, not erased from history. No new BURN restriction. Test repeated plays, draw/REBOOT loops, affordability and zero BW, especially BLACK BUDGET and INSIDER TRADING.

EXP-M013 (PROPOSED design guidance, designer-endorsed distinctions):
- SCRIPT purchases an immediate one-time effect; duration of resulting effect may extend beyond resolution. BW or CRED can pay for it.
- PROGRAM invests in a reusable capability; installation BW and finite RAM create opportunity cost, generally a resource or other cost to activate; explore exceptions (including automatic utilities/Extractors). Persists until unloaded/cleared or Node ends; existing voluntary unload rules unchanged. Proposed VOID-only forced UNLOAD in §14 threatens investment.
- PROTOCOL establishes an ongoing benefit or condition, deployed to RACK for BW, no RAM, primarily continuous, recurring, conditional, event-triggered or automatic protection for remainder of Node. Manual activation not default; exceptions exploratory.
- GHOSTWARE permanently modifies capabilities or rules, non-card upgrade; BLOATWARE remains detrimental card type.
- Programs are tools the Rustler operates; Protocols are conditions under which the Rustler operates. Distinction is how effect is accessed, not which resource pays.
- Existing 16 Protocol designs in Card Pools/Deck Synergy and seven experimental automatic Protocols EXP-C009/010/012/038–041 retain classification. No changes to existing cards or canonical rules.

EXP-S043: play each revised SCRIPT at zero BW with sufficient/insufficient CRED; resolve once and discard, no installed activation. EXP-S044: redraw via REBOOT and repay; compare repeated play and potential self-financing/draw loops, normal target legality, TRACE floor, suspension expiry. Extend X007 to compare revised CRED SCRIPTS with historical installed variants; no tests performed. Rarity and balance remain open. No implementation authorization.

## 16 — Encounter-wide effects and subroutine modification (ICE-EXP-002, 2026-11-24)

All PROPOSED; designer requested preservation for experimentation, not adoption. Names, costs, rarity and subtype provisional except designer-specified VOLTAGE REGULATOR effect, target, duration and BURN. BROADCAST is a candidate thematic keyword/subtype, not a new rule. BLACKOUT and CHAIN REACTION collide with EXP-C025 and C015; retain separate IDs, rename before adoption, do not overwrite earlier concepts.

| ID | Working name | Type | BW | Effect |
|---|---|---|---|---|
| EXP-C050 | BROWNOUT | SCRIPT | 2 | All ICE lose 2 STR this encounter. |
| EXP-C051 | POWER SURGE | SCRIPT | 1 | All ICE lose 1 STR this encounter. |
| EXP-C052 | CASCADE FAILURE | SCRIPT | 2 | All ICE with at least one broken subroutine lose 3 STR this encounter. |
| EXP-C053 | SYSTEM SHOCK | SCRIPT | 1 | All ICE with 5 STR or more lose 2 STR this encounter. |
| EXP-C054 | BLACKOUT | SCRIPT | 3 | All ICE lose 4 STR this encounter. BURN. |
| EXP-C055 | CARPET BOMB | SCRIPT | 3 | Break one subroutine on each ICE. |
| EXP-C056 | CHAIN REACTION | SCRIPT | 2 | Break one subroutine on each ICE with 2 STR or less. |
| EXP-C057 | SYSTEM COLLAPSE | SCRIPT | 1 | Break one subroutine on each ICE with 0 STR. |
| EXP-C058 | JAMMER | SCRIPT | 2 | Break one TRACE subroutine on each ICE. |
| EXP-C059 | PRECISION STRIKE | SCRIPT | 2 | Break one subroutine on each ICE that already has a broken subroutine. |
| EXP-C060 | ATTRITION | PROTOCOL | 2 | At start of each Rustler turn, all ICE lose 1 STR this encounter. |
| EXP-C061 | INTERFERENCE | PROTOCOL | 2 | On first turn of each encounter, all ICE lose 1 STR that encounter. |
| EXP-C062 | DOMINO EFFECT | PROTOCOL | 2 | Whenever an ICE reaches 0 STR for the first time this encounter, all other ICE lose 1 STR. |
| EXP-C063 | SYSTEMIC DECAY | PROTOCOL | 2 | Whenever you break the last subroutine on an ICE, all remaining ICE lose 2 STR. |
| EXP-C064 | VOLTAGE REGULATOR | SCRIPT — EXPLOIT | 1 | Reduce PULP damage of all subroutines on target ICE by 6 this turn. BURN. Suggested Uncommon. |
| EXP-C065 | SIGNAL ATTENUATOR | TBD | TBD | Reduce all TRACE subroutines on target ICE by 3 this turn. |
| EXP-C066 | NEURAL INSULATION | TBD | TBD | Reduce all CORTEX subroutines on target ICE by 1 this turn. |
| EXP-C067 | SURGE SUPPRESSOR | TBD | TBD | Reduce all PULP subroutines across all ICE by 2 this turn. |
| EXP-C068 | SABOTAGE | TBD | TBD | Reduce all numerical STR-increasing subroutines on target ICE by 2 this turn. |
| EXP-C069 | CIRCUIT DAMPENER | TBD | TBD | Reduce all PULP subroutines on target ICE by 1 for remainder of encounter. |

EXP-M014: encounter-wide effects scale with ICE count, favor deeper encounters and create early-versus-late deckbuilding tradeoffs. Explore unconditional, STR-threshold, type-specific (FORTRESS/TUMBLER/VOID), state-dependent (broken subroutines/virus counters) and cascading effects. For multi-ICE breaks Rustler chooses one legal subroutine per eligible ICE; respect existing reveal/active restrictions. No implicit bypass, suspension or change to DEADLOCK rules. ZEROED interactions follow existing first positive-to-zero and printed-finisher eligibility; test trigger order, snapshot versus sequential eligibility, recursive cascades, TUMBLE and BREACH timing. No new keyword authorized.

EXP-M015: subroutine modification reduces severity rather than breaking or suspending execution. Distinguish STR reduction, break, BYPASS, suspension, numerical modification and encounter-wide scope. For VOLTAGE REGULATOR each PULP subroutine independently loses 6, floor zero; lasts through ensuing Corporation Response, then expires; remains unbroken, other subs unchanged. BURN limits reuse. Test hidden/inactive subroutines, lethal multipliers and reduction order, stacking, duration and restoration, numerical floor, and distinction between modifying damage and SHIELD prevention. Exact timing and eligibility for hidden subs remain open; do not change canonical rules.

| ID | Scenario | Expected / question |
|---|---|---|
| EXP-S045 | BROWNOUT versus 1/2/3 ICE each STR at least 2. | Total STR reduction 2/4/6 for 2 BW; test floor. |
| EXP-S046 | BROWNOUT then SYSTEM COLLAPSE, including ICE already zero. | Break one legal sub per zero-STR ICE; no automatic ZEROED bonus. |
| EXP-S047 | DOMINO EFFECT reduces other ICE to zero. | Test first-zero marker, cascade ordering and termination. |
| EXP-S048 | Multi-ICE break with hidden VOID subs, rotating TUMBLER slots, DEADLOCK and no eligible subs. | Respect existing legality; test choice order, TUMBLE and BREACH. |
| EXP-S049 | VOLTAGE REGULATOR on PULP 8, PULP 4, TRACE 3, DEADLOCK. | PULP 2/0, TRACE 3, DEADLOCK unchanged; no breaks; BURN card. |
| EXP-S050 | Compare targeted -6 PULP BURN, encounter-wide -2 PULP and persistent targeted -1 PULP. | Measure damage avoided, BW, card circulation and encounter length. |
| EXP-S051 | ATTRITION, INTERFERENCE and SYSTEMIC DECAY across encounters. | Test trigger timing, STR restoration, first-turn deployment, last-sub and no-target cases. |
| EXP-S052 | Modified subroutine under lethal form, multiple modifiers and hidden reveal. | Determine order and duration; avoid negative values or unintended permanent changes. |

EXP-X009: compare encounter-wide versus single-target cards on identical seeds and varying ICE counts; track BW, total STR reduced, legal breaks, ZEROED, cascading, deck slots, early dead draws and late efficiency. EXP-X010: compare numerical modification versus break, suspension and SHIELD, tracking damage/TRACE avoided, BURN opportunity cost, counterplay, timing and repeated effects. No tests performed; no implementation authorization.

## 17 — Infiltration CAPS (CAP-EXP-001, 2026-11-24)

Designer requested preservation of all twelve concepts, with no CRED pricing now. All PROPOSED; rarity, prices, exact activation windows, target eligibility and implementation remain open. CAPS are non-card single-use consumables; use distinct EXP-CAP IDs rather than inflating deck-card count. Existing UPL-001/002/004/005 rules and twelve approved CAPS unchanged. Map-level activation is a proposed extension, not an existing rule.

| ID | Working name | Proposed effect |
|---|---|---|
| EXP-CAP001 | PORT SCAN | Reveal all ICE classifications in one accessible Node. |
| EXP-CAP002 | DEEP SCAN | Reveal every encounter layer, ICE identity and base STR in one accessible Node. |
| EXP-CAP003 | WIRETAP | Reveal partial security intelligence on all Nodes two rows ahead. |
| EXP-CAP004 | FALSE IDENTITY | Enter your next eligible Node under an assumed identity, potentially bypassing its outer defences. |
| EXP-CAP005 | GHOST ENTRY | Bypass one eligible supporting ICE in the opening encounter of your next Node. |
| EXP-CAP006 | FALSE ALARM | Divert one supporting ICE from an upcoming Node. |
| EXP-CAP007 | REMOTE EXPLOIT | All ICE in the opening encounter of your next Node start with 2 less STR. |
| EXP-CAP008 | BLIND SPOT | Prevent TRACE gains during the first Corporation Response of your next Node. |
| EXP-CAP009 | BACKDOOR | Skip the outer encounter layer of an eligible Node. |
| EXP-CAP010 | DATA INTERCEPT | Reveal the potential CRED rewards of all immediately accessible Nodes. |
| EXP-CAP011 | CLEAN SLATE | Erase selected corporate surveillance records of the Rustler. |
| EXP-CAP012 | SPOOF | Conceal the Rustler's identity during their next eligible Node entry. |

EXP-M016: CAPS bridge tactical combat and strategic infiltration without a second deck or meter. Existing three-slot inventory creates opportunity cost: carrying reconnaissance, preparatory or circumventive CAPS displaces combat emergency consumables. Explore purchases at Uplinks and existing reward/drop channels, not new acquisition rules. Illustrative loadouts: BULWARK/BW SPIKE/NANOSUTURE versus DEEP SCAN/FALSE IDENTITY/BACKDOOR. Information value depends on deck composition and route choice. Distinguish informational, preparatory and circumventive effects. Working names BACKDOOR and FALSE ALARM overlap earlier card concepts; preserve separate IDs, resolve naming before adoption. CLEAN SLATE concerns fictional records only, not real data; scope and consequences open. No assumed changes to TRACE, identity or authorization systems.

| ID | Scenario | Question |
|---|---|---|
| EXP-S053 | PORT SCAN/DEEP SCAN/DATA INTERCEPT on adjacent alternatives; WIRETAP two rows ahead. | Reveal accurate precommitted information; test route value, no reroll or hidden mutation. |
| EXP-S054 | REMOTE EXPLOIT/BLIND SPOT used before choosing next Node. | Test binding to next eligible Node, first encounter/response, expiry and unused effect handling. |
| EXP-S055 | GHOST ENTRY/BACKDOOR/FALSE IDENTITY/FALSE ALARM on eligible and ineligible Nodes. | Preserve mandatory boss engagements, existing BYPASS restrictions and progression/reward integrity; no assumed free rewards or new escape rule. |
| EXP-S056 | Full three-slot inventory, combat versus infiltration CAP choice. | Compare survivability, information value, CRED opportunity cost (prices TBD), consumption and acquisition. |
| EXP-S057 | CLEAN SLATE/SPOOF with different fictional surveillance histories. | Define scope, duration and meaningful effect without exposing psychological profiling or assuming existing identity mechanics. |

EXP-X011: compare combat-only, infiltration-only and mixed CAP loadouts on identical seeds; measure route choices, information usefulness, combat exposure, rewards forgone, slot pressure and recovery. Test invalid targets, cancellation, consumption timing, bootleg applicability, map visibility, progression and no-boss-skip constraints. No pricing or rarity decisions; no tests performed or implementation authorization.


## 18 — Experimental ICE types, subroutines and passives (ICE-SURV-EXP-001, 2026-11-24)

Designer endorsed exploration and requested preservation of the five economic variations. All PROPOSED; no new ICE type, numerical balance, rule or implementation authorized. EXP-M017: surveillance-dependent ICE. Distinguish TRACE from fictional corporate knowledge and voluntary disclosure. Explore new ICE classifications, adaptive existing ICE, subroutine effects, passives and inter-ICE interactions without replacing canonical classifications.

| Working name | Experimental effect |
|---|---|
| ASSET SEIZURE | Lose CRED proportional to voluntary disclosures or relevant corporate knowledge. |
| GARNISHMENT | Lose a percentage of current CRED scaled by corporate knowledge. |
| ACCOUNT FREEZE | Temporarily restrict access to a portion of CRED. |
| RISK PREMIUM | Increase transaction costs with the relevant Corporation. |
| PERSONALIZED PENALTY | Scale financial penalty according to observed in-run economic behaviour. |

Names, formulas, floors, caps, scope, duration, break legality and recovery remain open. No numerical values adopted. Explore corporation-specific versus shared knowledge, deletion/spoofing and privacy-focused counterplay. Cross-reference §13 EXP-M011 and §17 CLEAN SLATE/SPOOF. Do not equate TRACE with knowledge.

## 19 — Adaptive surveillance and the right to remain unpredictable (SURV-EXP-001, 2026-11-24)

EXP-M018 / EXP-D002 (designer-endorsed exploration, PROPOSED): privacy must protect something meaningful to the player, not merely a fictional exchange meter. Explore private objectives, capabilities, intentions and fragmented identity. Use only fictional local in-run events, never actual personal information or psychological classification. Distinguish observed actions from fallible interpretations; no inferred motive treated as fact. Preserve meaningful refusal, independent play, deception and recovery.

Progression hypothesis, not explicit phases or mandatory outcome: generic ads and impersonal encounters → recognition of recent purchases and recurring tactics → useful personalized offers/rewards → NUL/REM anticipation → adaptive ICE → possible player self-regulation. The same fictional knowledge that enables convenience can enable control. Do not announce phase transitions. Preserve presentation/rules separation: any future approved mechanical observation system must be explicitly rules-owned, never read ad or presentation profiles.

Designer specifically extended the concept beyond selecting counter-ICE: familiar ICE itself may change behaviour based on prior observed play. Candidate adaptations (not approved): resistance to repeated STR reduction; UNLOAD against Program-heavy play; CRED seizure against accumulation; changed defensive priorities against DEADLOCK rushing; alternative damage against repeated PULP prevention; additional security against bypass; alternative disruption against TRACE suppression; passives responding to repeated tactical sequences. Explore STR, subroutines, passives, activation conditions and inter-ICE interactions. No live hidden rule mutation, retroactive counter or automatic perfect prediction assumed. Precommit bounded adaptations before encounters, communicate actionable changes and allow counterplay; preserve recognizable ICE identity. Corporate memory, observation permissions, confidence, timing, persistence, false signals and adaptation budget remain open.

EXP-X012 (PROPOSED, not run): compare static ICE, selected counter-ICE and adaptive familiar ICE on matched seeds. Observe recognition, fairness, meaningful privacy choices, tactical diversity, deliberate deception, recovery, viability of specialized decks and whether players experience being known rather than merely punished. Compare generic-to-personal ads and NUL/REM commentary with mechanical adaptations; preserve local-only data, no actual profiling, and no compulsory psychological response. No tests or implementation authorized. Link philosophical and dialogue work to existing canonical domain records; no consolidation or relocation during DOCS-MIG-001.

## 20 — Surveillance and memory: the system always remembers (SURV-MEM-001, 2026-11-24)

Designer-confirmed central philosophical direction:

> As the player learns the game, the game learns the player.
>
> The system always remembers. It never forgets.

The Panopticon is pervasive, persistent and cumulative. The relationship between the player and the system extends beyond a single Rustler or run. This is a thematic commitment, not authorization for actual personal surveillance, irreversible data retention or a new gameplay rule.

### The system learns the Rustler

| Stage | Manifestation |
|---|---|
| Observation | Generic advertisements, impersonal encounters and observation of tactical decisions. |
| Recognition | Personalized advertisements and commentary on recurring behaviours. |
| Accommodation | Helpful recommendations, tailored rewards and economic incentives. |
| Adaptation | ICE modifies its behaviour in response to previously observed tactics. |
| Anticipation | The system predicts decisions and prepares the environment accordingly. |

Organic progression, not announced phases or fixed timings. EXP-M019 (PROPOSED): distinguish encounter memory (immediate tactics), Rustler memory (current run capabilities and disclosures), and operator memory (fictional gameplay patterns across runs). Within-run mechanical adaptation and cross-run recognition/personalization are candidates, not adopted rules. Avoid escalating difficulty merely for repeated play. Local-only gameplay records, accessible real-world reset, no personal data or psychological profiling; fictional persistence does not override player control. Explore THE CARBON and NUL/REM relationships without assuming new authority or data access. See §19 and Philosophical Design Bible. No implementation or tests authorized.


## 21 — THE CARBON: appropriation of resistance (CARBON-SURV-EXP-001, 2026-11-24)

EXP-D003 (designer-endorsed philosophical exploration; mechanics PROPOSED). THE CARBON begins as a trusted channel for Rustlers to exchange warnings, discoveries, rumours and tactical advice, apparently outside corporate authority. As the player voluntarily relinquishes fictional privacy, corporations gradually appropriate this channel to communicate with and influence the player. The familiar space remains; its ownership becomes uncertain. Link SURV-MEM-001 and §§18–20.

| Stage | Content | Intended possible psychological effect |
|---|---|---|
| Independent | Genuine Rustler warnings, advice, discoveries and rumours. | Solidarity and belonging. |
| Contaminated | Occasional suspicious messages among genuine communications. | Uncertainty. |
| Infiltrated | Anonymous messages offering unusually relevant advice. | Convenience and misplaced trust. |
| Compromised | Messages reference purchases, routes and previous encounters. | Exposure and unease. |
| Appropriated | Corporations communicate directly through THE CARBON. | Violation of a trusted space. |
| Assimilated | Corporate and Rustler communications become difficult to distinguish. | Erosion of trust and shared identity. |

Preserve familiar visual identity; no dramatic rebranding or announced compromise phases. Retain genuine messages throughout: corporate propaganda disguised as resistance, selectively amplified authentic messages, personalized recommendations and fictional route-influencing misinformation are alternatives to explore. Not all messages become false. Origin alone ceases to guarantee trustworthiness. Illustrative non-shipping messages: early “Watch the second layer. Cost me two Programs getting through.” Later “You might want to keep some RAM available. You've been relying heavily on installed Programs lately.” Compromised “Your current configuration suggests you would benefit from our enhanced protection service.” Subsequent run “Welcome back. We have retained your preferences.” Dialogue examples are exploratory pointers, not additions to the canonical dialogue catalogue.

### Collective privacy and distinct surveillance manifestations

Privacy is collective as well as individual. THE CARBON represents a community's ability to communicate outside institutional observation. Individual disclosure may inadvertently help corporations penetrate shared resistance spaces; the player loses more than personal anonymity. Resistance itself can become another corporate interface.

| System | What is gradually compromised |
|---|---|
| NUL/REM | Personal autonomy |
| THE CARBON | Collective trust |
| Adaptive ICE | Tactical unpredictability |
| Personalized rewards | Freedom of choice |
| Persistent surveillance | Anonymity across time |

Designer explicitly emphasized keeping THE CARBON and NUL/REM philosophically distinct: two different statements about pervasive surveillance, not interchangeable delivery channels. Their interaction is central: erosion of collective trust can produce greater dependence on an individual authority. A player uncertain whether THE CARBON messages are genuine may turn to NUL/REM to interpret or authenticate them. **The system creates the conditions that make its own assistance necessary.** This is a possible emergent feedback loop, not a mandated player response or automatic grant of authority. Preserve refusal, independent verification, genuine solidarity and viable alternatives; NUL/REM is not assumed to cause the compromise.

Open questions: disclosure triggers and thresholds, corporation-specific access, message provenance and verification, scope of collective consequences, persistence across runs, recovery and deception, whether and how NUL/REM offers assistance, and how to preserve useful independent communication. No single privacy meter assumed. Fictional local gameplay information only; no actual user surveillance, network interception or real player messaging assumed. EXP-X013 (PROPOSED, not run): compare independent, mixed and increasingly appropriated message streams; assess recognition, trust, usefulness, perceived agency, voluntary reliance on NUL/REM and alternative responses. No approved mechanics, shipping dialogue, implementation or tests. Cross-reference Philosophical Design Bible and existing NUL/REM dialogue records without consolidation during DOCS-MIG-001.

## 22 — The uncertainty of observation (SURV-UNCERT-EXP-001, 2026-11-24)

Designer-endorsed philosophical exploration, mechanics PROPOSED. Reference: Francis Ford Coppola's The Conversation (1974), explicitly identified by the designer. Surveillance expertise does not necessarily confer security; incomplete information, ambiguity and suspicion can undermine trust. The designer describes a “constant low hum anxiety” and pervasive fear, especially paranoia. Explore this as fictional atmosphere and thematic critique, not an objective to cause actual sustained distress. The possibility of observation can influence behaviour without continuous observation. Link SURV-MEM-001 (§20), collective trust and appropriation of resistance (CARBON-SURV-EXP-001, §21), freedom exhaustion and NUL/REM.

| Effect | Fictional condition | Illustrative question |
|---|---|---|
| Fear | Recognizable threat | What is going to happen to me? |
| Anxiety | Uncertain future threat | What might happen to me? |
| Paranoia / suspicion | Uncertainty about intentions behind events | Is this happening because of me? |

These are narrative distinctions, not clinical definitions or player classifications.

| Psychological progression hypothesis | Illustrative question |
|---|---|
| Observation | Am I being watched? |
| Recognition | What do they know about me? |
| Anticipation | What do they expect me to do? |
| Suspicion | Was this situation deliberately created for me? |
| Paranoia | Can I trust anything around me? |
| Internalization | Should I change my behaviour, just in case? |

Complement, do not replace, §20's five-stage system progression. No fixed timing, compulsory response or psychological meter. The cheerful retro advertising, mascots and familiar interfaces may remain visually reassuring while their fictional significance changes. Examples: difficult ICE versus adaptive ICE; a random useful Uplink reward versus a personalized offer; authentic versus appropriated CARBON messages; helpful versus authority-expanding NUL/REM advice. Not every coincidence is intervention. Maintain fair, discoverable mechanical rules, genuine randomness, reliable information and meaningful independent choices. Do not manufacture real-world distress or obscure actual privacy controls.

Constant vigilance can be burdensome in the fiction; NUL/REM may offer relief, linking freedom exhaustion to voluntary reliance on authority. Illustrative dialogue only: “You don't have to question everything.” “I can take care of that for you.” “You've been through enough.” Preserve genuine relief, refusal and viable alternatives; no mandatory surrender. The Panopticon becomes internalized when the possibility of observation influences self-regulation. Its ultimate expression may be when the system no longer needs to watch. No approved mechanics, production dialogue, implementation or tests. Cross-reference philosophical records without consolidation during DOCS-MIG-001.

## 23 — The Internalized Observer (SURV-OBSERVER-EXP-001, 2026-11-24)

Designer-confirmed principal cinematic references for this exploration:
- The Parallax View (1974), directed by Alan J. Pakula — visual composition, institutional scale, isolation and the viewer's participation in the protagonist's suspicion.
- The Conversation (1974), directed by Francis Ford Coppola — surveillance, ambiguous information, sound, repetition and deteriorating certainty.

Reference focus: “watching themselves being watched”; the observer becomes internalized. See §22 SURV-UNCERT-EXP-001. Cinematic references only; no new mechanics, audiovisual specifications or implementation authorized.

### Additional cinematic references — SURV-OBSERVER-EXP-001a

Designer requested three additional visual, stylistic and psychological references for The Internalized Observer:
- Rosemary's Baby (1968, Roman Polanski): disappearance of refuge; intimate relationships, neighbours and trusted institutions implicated in a conspiracy; familiar domestic spaces become oppressive. Relate to collective trust and compromised sources of assistance.
- Diabolique / Les Diaboliques (1955, Henri-Georges Clouzot; assumed original, edition to confirm): ambiguity, absence, anticipation and destabilization of certainty; distinguish observed events from interpretations. 
- Invasion of the Body Snatchers (adaptation unspecified; 1956 Don Siegel and 1978 Philip Kaufman versions are candidate references): primarily psychological rather than visual; familiar outward identities conceal fundamental change, erosion of authentic identity and collective trust. Relate to THE CARBON retaining its familiar appearance while its ownership and communications change.

These supplement, not replace, The Parallax View and The Conversation as principal references. Reference-only; no approved audiovisual specifications, mechanics or implementation. See §§21–23.


## WATCHER-EXP-001 — WATCHER removed from standard ICE (designer approved 2026-11-27)
Remove WATCHER from the standard ICE ability pool and HALCYON expansion/representative encounter mechanical coverage. Preserve as an experimental concept: each CLOAK card played generates 1 TRACE. Potential exceptional applications: mini-boss, specialized supporting ICE with meaningful counterplay, or discoverable/circumventable node security condition. None is approved for deployment. Evaluate strategic depth, agency, synergy, anticipation and cognitive load; test defensive deck viability, advance warning and viable counterplay. Design principle: abilities directly penalizing fundamental Rustler actions should be exceptional encounter conditions, not routine obstacles. Detailed experimental ownership: docs/PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md. Supersedes standard WATCHER specifications; preserve historical records. No engine changes or production implementation authorized by this documentation update.


## CHAIN-003 — Experimental catalogue and first playtest candidates (2026-11-27)
See [canonical CHAIN specification](PANOPTICON_CHAIN_MECHANICS.md) for all 15 experimental combinations and proposed TAG/TYPE/ACTION/COST grammar. First experimental cohort: OVERCLOCK, SLIPSTREAM, RELAY, BOOTSTRAP, HANDSHAKE, DAISY CHAIN (TAG/TYPE only; free execution requires additional rule review). Priority 2E / CHAIN-REP-001; coordinate M06 and UI-TYPO-001/a. Designer authorized recording and candidate selection, not final card balance or production implementation. Resolve grammar, extension/termination and free-play safety before implementation; later ACTION/COST/mixed signatures retained for exploration. No engine changes.
