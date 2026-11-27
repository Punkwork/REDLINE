# PANOPTICON — CHAIN Mechanics Design Specification
Decision: CHAIN-002 | 2026-11-27 | architecture-v2
Status: foundational rules designer-approved; remaining specification and implementation pending.
Scope: CHAIN-REP-001, Priority 2 representative encounter; companion UI-TYPO-001/a, M06, CAS-001, VAS-001.

## 1. Design intent
CHAIN rewards deliberate card sequencing, deck construction and bandwidth efficiency. It should feel like manipulating the machine, not an incidental two-card conditional bonus. Mechanical complexity must earn strategic depth. Make opportunity, activation and actual payoff intelligible without consulting a log.

## 2. Approved foundational rules
- Minimum three cards in a valid sequence. Two cards alone cannot instantiate CHAIN. This supersedes the two-card activation threshold in DSY-011.
- Chains may extend beyond three cards; no fixed maximum has been approved.
- A CHAIN instance is instantiated by the third card completing a valid sequence.
- The instantiating card receives an inherent reduction of 1 BW to its play cost, in addition to applicable card-specific CHAIN bonuses. This is a cost reduction calculated before affordability and commitment, never a refund.
- The inherent reward belongs to CHAIN itself, not individual card text.
- Proposed implementation floor: 0 BW; no negative costs or implicit BW generation. Confirm with designer alongside cost-modifier precedence.
- Multiple independent CHAIN instances may be instantiated within one Rustler turn; no once-per-turn activation restriction. Each valid new instance receives the inherent −1 BW instantiation discount.
- CHAIN instances are distinct and non-overlapping. A card play used as a link in one instance cannot be reused in another instance. A new instance requires fresh card plays.
- Exact sequence eligibility, extension rewards and termination remain open. Do not treat illustrative patterns as approved rules.

## 3. Lifecycle and existing baseline
Initiation (first card, ordinary cost) -> formation (second card, ordinary cost) -> eligible third card (preview discount) -> successful play instantiates CHAIN -> card-specific bonus and activation feedback -> active instance eligible for extension under rules still to be specified.
Existing DSY-011 baseline: immediately preceding card's tag in same Rustler turn; Programs and Protocols count as plays; installed Icepick actions and CAPS do not change last played card; tags reset each turn. Engine tracks last_tags, tag_counts, chain_active and chain_draws. Preserve unaffected baseline provisionally; determine how these interact with new instance semantics before implementation. Failed/illegal actions should not instantiate a chain (proposed acceptance requirement).

## 4. Existing cards and implementation audit
Source: REDLINE_DECK_SYNERGY.md §6.1, §9; godot/scripts/core/cards.gd and game.gd (audit 2026-11-27).
| Card | Current cost/type/tag | Existing effect under old DSY-011 |
|---|---|---|
| PIVOT | 1 BW SCRIPT EXPLOIT, common shared | −2 ICE STR; CHAIN CLOAK additional −1 STR |
| COVER FIRE | 1 BW SCRIPT CLOAK, common shared | +3 SHIELD; CHAIN EXPLOIT additional +2 SHIELD |
| HANDOFF | 0 BW SCRIPT CLOAK, common ECHO | −2 TRACE; CHAIN CLOAK draw 1 |
| KILL CHAIN | 2 BW PROTOCOL, rare shared | Draw 1 per CHAIN bonus, max twice per turn per installed copy in current engine |
All four are absent from current CORE_POOL reward list at audit. Existing effects are coded, not independently live-playtested in this audit. Card definitions and reward availability require reconciliation with CHAIN-002. PROXY CHAIN and CHAINSAW are names, not explicit CHAIN bonus cards. STACK SMASH counts EXPLOIT plays but is not explicit CHAIN.
Generalist alternating CLOAK/EXPLOIT; ECHO CLOAK and REBOOT; RIOT EXPLOIT and ZEROED are established design directions. VECTOR/CRON no dedicated CHAIN archetype established here. COMPILE dual-tag bridges are future/full-game context, not current implementation authorization.

## 5. Illustrative sequences and economics (not final eligibility or balance)
Candidate patterns: EXPLOIT→EXPLOIT→EXPLOIT; CLOAK→CLOAK→CLOAK; CLOAK→EXPLOIT→EXPLOIT; EXPLOIT→EXPLOIT→CLOAK; CLOAK→EXPLOIT→CLOAK; EXPLOIT→CLOAK→EXPLOIT. These are examples, not exhaustive or approved pattern definitions.
Example A: three eligible 1 BW cards, first two cost 1 each, third costs 0 after inherent discount. Total 2 BW instead of 3; baseline 3 BW leaves 1 BW for other actions. Third card additionally resolves its applicable CHAIN effect.
Example B: if CLOAK→EXPLOIT→CLOAK is valid and COVER FIRE is the third card, it costs 0 BW instead of 1; if its current bonus is retained it grants 5 SHIELD instead of 3. Illustrative only.
Example C: if EXPLOIT→CLOAK→EXPLOIT is valid and PIVOT completes it, it costs 0 BW instead of 1; if current bonus retained it reduces STR by 3 instead of 2.
Example D: HANDOFF as eligible third card already costs 0; proposed floor means no BW generated, but its card-specific draw bonus still applies if eligible.
Example E: KILL CHAIN installed earlier may amplify a qualifying bonus with draw; whether instantiation without a card-specific bonus counts, and extension triggers, remain open.
Earlier two-card PIVOT/COVER FIRE combinations are historical examples only and no longer sufficient to instantiate CHAIN.
Potential revised card bonuses discussed: PIVOT additional −3 STR, COVER FIRE additional +4 SHIELD, HANDOFF draw 2; KILL CHAIN retain pending balance. These are unapproved exploration, not replacements. Candidate catalogue target 8–12 CHAIN-capable cards plus amplifier, not approved quantity. Explore BW, draw, breaks, TRACE and CACHE payoffs. Baseline DRAW 6/BW 3 makes sequencing meaningful; zero-cost cards, CACHE, draw, deck pruning and BW generation influence reliability.

## 6. UI and audiovisual design
Designer-approved objective: make CHAIN obvious and fully implemented in current representative encounter. Designer endorsed CHAIN ACTIVATED typographic/motion moment.
Proposed information states: potential (card has CHAIN effect); progression (first/second cards and relevant tags); ready (eligible third card, actual discounted cost before commitment); activated (successful instantiation); resolved (actual additional effect on card, ICE or resource).
Use existing Architecture V2 components and authoritative visible-state adapter. Icons communicate; numbers quantify; hover/focus explains; typography announces. Candidate chain-link icon, illuminated eligibility indicator, visible original/effective cost where helpful, concise hover explanation of required sequence and bonus. No permanent explanatory text or reliance on colour alone. Do not leak concealed ICE information.
CHAIN ACTIVATED: distinctive Atomic Deco-Punk virtual flyout, satisfying electromechanical audio, brief energy surge and localized effect resolution. Emotional intent: ingenuity and satisfaction. Coordinate event hierarchy, timing, competing events, reduced motion/effects, input non-interference, readability and accessibility with UI-TYPO-001/a and M06. Exact artwork, sound, placement and timing remain proposed. Avoid repetitive celebration for every extension until extension semantics approved.

## 7. Open design questions
1. What defines valid sequence: specific ordered tag patterns, same-tag runs, card-specific requirements, or another grammar? Are all cards eligible links or only CHAIN-tagged cards?
2. How are multi-tag, untagged, Programs, Protocols, compiled cards, forced plays and non-card actions handled?
3. Does an incompatible card terminate the instance, start a new candidate sequence, or both? Does turn end always terminate it? Can CACHE prepare cards but not carry chain state?
4. Does fourth/fifth valid link receive −1 BW again (sustained discount) or only third card (instantiation-only)? Both discussed; only instantiation discount approved.
5. Multiple distinct instances per turn are approved; overlap and reuse of prior links are prohibited. How are instance IDs and extension counts tracked?
6. Which cards get card-specific bonuses, at instantiation only or also extension? How does KILL CHAIN count bonuses/instances? How are existing cards repriced?
7. Cost floor, stacking/precedence with other discounts, legality at 0 remaining BW, cancellation and failed action handling.
8. Infinite/repeating loops, draw and zero-cost chains; safeguards without arbitrary length caps.
9. Exact UI progression indicators, hover/focus content, audio and motion specimens, simultaneous event precedence.
10. Reward pool inclusion, starter/fixture availability, archetype coverage and multi-encounter balance.

## 8. Corporate reactive abilities
CHAIN PULP: existing PATTERN ANALYSIS VOID ability inflicts 1 PULP per CHAIN bonus; IRONWATCH preferred, deferred to future IRONWATCH representative encounter. Do not confuse with current Rustler CHAIN scope. Reconcile trigger semantics with new instance rules later. REBOOT SPAM and GUARD are separate approved reactive subroutine workstreams.

## 9. Delivery and acceptance
1. Audit existing cards, engine, UI and tests; reconcile DSY-011 and current core-loop pool.
2. Resolve open grammar and economics with designer; finalize card catalogue and fixtures.
3. Specify visible state, action legality and event contracts with CAS-001; develop CHAIN ACTIVATED specimen with M06.
4. Implement approved engine rules and UI together; no duplicate rule logic in presentation.
5. Verify two cards never activate; valid third receives exactly −1 BW before affordability; invalid sequences do not; card-specific bonus correct; no duplicate activation; multiple independent instances in one turn, extension/reset cases and prohibition of overlap/reuse; previews match engine; reduced motion same outcomes; no hidden leaks; deterministic regression.
6. Test deliberate combinations in HALCYON one-, two-, three-encounter nodes, actual Windows playtest, capture screenshots and feedback. Evaluate whether players identify opportunities without external explanation, deliberately sequence cards, understand cost and payoff, and find CHAIN satisfying without dominant or infinite loops.
7. Designer acceptance required. No engine implementation or final card balance authorized by this document alone.

## 10. Canonical references
[Deck Synergy](REDLINE_DECK_SYNERGY.md) (DSY-011 historical threshold superseded), [Master Design](REDLINE_MASTER_DESIGN.md), [Handoff](HANDOFF.md), [Development Log](REDLINE_DEVELOPMENT_LOG.md), [Daily Priorities](operations/DAILY_PRIORITIES.md), [UI Design Bible](PANOPTICON_UI_DESIGN_BIBLE.md), [Card DB](../godot/scripts/core/cards.gd), [Game engine](../godot/scripts/core/game.gd).


## CHAIN-002a — Multiple instances per turn (designer approved 2026-11-27)
Multiple independent CHAIN instances may be instantiated within a single Rustler turn, with no once-per-turn activation restriction. Each valid new instance receives its own inherent −1 BW instantiation cost reduction and applicable card-specific bonus. This resolves the repeat-instance eligibility question in CHAIN-002; termination, extension discounts and any card-specific trigger caps remain unresolved or governed by their existing rules. Illustrative example: two distinct valid three-card sequences in one turn each receive a discount on their third card, subject to affordability and approved eligibility. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-002b — Distinct non-overlapping instances (designer approved 2026-11-27)
CHAIN instances are distinct and cannot overlap or reuse previously played cards as links. A card-play event assigned to one CHAIN instance cannot count toward another; a new instance requires a fresh sequence. This resolves the overlap/reuse question in CHAIN-002 and CHAIN-002a. Example: plays A,B,C instantiate one CHAIN; B,C,D cannot instantiate another. After the first instance ends, three fresh eligible plays can instantiate another in the same turn. Exact termination, extension eligibility and discounts remain open; no new rules about replaying a physical card in a separate play event are established here. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-002c — Turn extension and deck manipulation (designer approved 2026-11-27)
CHAIN's distinctive foundational design identity is momentum: extend the Rustler's turn and expand tactical options through card draw, draw/discard pile manipulation and resource efficiency. Successful sequencing should create opportunities beyond those available at turn start, potentially sustaining the current instance or enabling another distinct instance. This is an approved design principle, not a universal additional payout or final card specification. Preserve the inherent −1 BW instantiation cost reduction separately.
Experimental specialized rewards (designer examples, not approved individual effects): draw additional cards; inspect/reorder/select upcoming cards; recover a discard or place a selected discarded card atop the draw pile; play the top draw-pile card for free; generate extra BW in addition to the instantiation discount. Explore combinations and archetype differentiation. STR/SHIELD/TRACE bonuses remain possible but should not define CHAIN's identity alone.
UI: communicate newly available options, actual draw/recovery/free-play/BW outcomes and their causal relationship to CHAIN; integrate with CHAIN ACTIVATED and localized resolution feedback. Maintain player agency and hidden-information boundaries. Open questions: free-play eligibility/targeting/cancellation, pile selection and visibility, whether generated plays count as fresh links, recursion and loop safeguards, reward magnitude/frequency and balance. No arbitrary cap or automatic effect approved. Acceptance: deliberate sequencing visibly expands actionable choices and can extend a turn without dominant or infinite loops; test against baseline BW3/DRAW6 and multi-encounter fixtures. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-002d — Experiential acceptance (designer approved 2026-11-27)
Design mantra: **Extend the turn. Expand the options. Reward ingenuity.** CHAIN creates confidence, momentum and a sense of mastery, as if the Rustler discovered a new level within a level. Contrast with surveillance-induced anxiety and restriction. Experiential acceptance criterion: the player should not merely understand that they executed a clever combination; they should feel clever for having discovered it. Reward discovery through typography, motion, sound and visible card changes, not solely numerical effects or a flyout. Anticipation, activation and momentum are proposed feedback phases; eligible card indicators, effective cost changes, localized payoff and newly available options should be legible. Specific animation, sound, card treatments and timing remain experimental; coordinate UI-TYPO-001/a, M06 and CHAIN-REP-001. Playtest whether players independently recognize opportunities, perceive the payoff and report confidence/momentum/mastery without obscuring tactical information; reduced effects must preserve information. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.

## CHAIN-003 — Experimental combination catalogue and playtest shortlist (2026-11-27)
Designer authorized recording the exploration and selecting promising playtest candidates. All names, signatures, card statistics and specialized effects below are experimental, not final balance or production rules. Proposed grammar: ordered preceding fresh card plays satisfy a catalyst's signature; ordinary cards can be links; catalyst playable normally without activation. TAG and TYPE first; ACTION (actual resolved effect) and COST (printed versus effective unresolved) later. Preserve CHAIN-002/a/b/c/d: minimum three, distinct non-overlapping instances, third card −1 BW before commitment, turn extension identity and experiential acceptance.
All catalysts below have illustrative base cost 1 BW, reduced to 0 on valid instantiation. Signature lists the first two links; third is named catalyst.
| Catalyst | Ordered signature | Base effect | Additional CHAIN effect | Stage |
|---|---|---|---|---|
| OVERCLOCK | CLOAK → EXPLOIT | Draw 2 | None beyond inherent discount | First |
| FEEDBACK LOOP | EXPLOIT → EXPLOIT | Draw 1 | Draw 1 more | Later |
| SLIPSTREAM | CLOAK → CLOAK | Reduce TRACE 2 | Gain 1 BW | First |
| RELAY | EXPLOIT → CLOAK | Draw 1 | Selected discard to hand | First |
| BOOTSTRAP | PROGRAM → SCRIPT | Draw 1 | Gain 1 BW | First |
| HANDSHAKE | SCRIPT → PROTOCOL | Draw 1 | Selected discard atop draw pile | First |
| DAISY CHAIN | SCRIPT → SCRIPT | Draw 1 | Optionally play top draw card for 0 BW | First |
| RECURSION | DRAW → DRAW | Draw 1 | Selected discard to hand | Later |
| BROWNOUT | REDUCE STR → REDUCE STR | Reduce ICE STR 1 | Draw 2 | Later |
| GHOST SIGNAL | REDUCE TRACE → GAIN SHIELD | Reduce TRACE 1 | Inspect top 3, draw one, reorder rest | Later |
| BACKDOOR | REDUCE STR → BREAK SUB | Draw 1 | Gain 1 BW | Later |
| LOW VOLTAGE | 0 BW card → 1+ BW card | Draw 1 | Draw 1 more | Later |
| POWER SURGE | SPEND BW → GENERATE BW | Draw 1 | Gain 1 BW | Later |
| COLD START | 0 BW card → 0 BW card | Draw 1 | Selected discard atop draw pile | Later |
| ROOT ACCESS | PROGRAM → REDUCE STR | Draw 1 | Selected discard atop draw pile, optionally execute for 0 BW | Later |
Action signatures require card plays, not standalone Icepick activations. Example: BW3/DRAW6; CLOAK 1BW, EXPLOIT 1BW, OVERCLOCK 0BW draws2; after first instance ends, hypothetical draw card A 0BW draws1, draw card B 1BW draws1, RECURSION 0BW draws1 and recovers discard. Six plays, five draws, two BW saved; no overlap. Illustrative later-stage scenario, not proof of available cards.
First experimental shortlist: OVERCLOCK, SLIPSTREAM, RELAY, BOOTSTRAP, HANDSHAKE, DAISY CHAIN. RELAY replaces RECURSION in first cohort to keep grammar TAG/TYPE only. DAISY CHAIN requires explicit free-play legality, targeting, cancellation, pile visibility and recursion rules before implementation; stage it after simpler effects if necessary. Verify actual card costs and available BW, RAM, protocol slots, draw/discard availability, reward pool/fixtures, no self-recovery loops, and existing card name collisions. Resolve extension/termination and cost precedence before engine work. Test each independently, then combinations in representative HALCYON encounters; UI previews, CHAIN ACTIVATED, visible hand changes and localized reward feedback; measure agency, confidence, momentum, mastery and absence of dominant/infinite loops. No production implementation or final card balance authorized by this catalogue.


## CHAIN-003a — Experimental playtest development sequence (designer approved 2026-11-27)
Proceed with the CHAIN-003 six-card experimental programme under Priority 2E / CHAIN-REP-001: (1) OVERCLOCK foundational activation and free draw, (2) SLIPSTREAM and BOOTSTRAP BW generation, (3) RELAY and HANDSHAKE pile manipulation, (4) DAISY CHAIN free execution after legality/recursion review, (5) integrated six-card interactions and multiple distinct instances. Finalize baseline activation, termination and extension rules with designer before implementation. First deliverable: OVERCLOCK mechanically, visually and audibly realized, coordinated with CAS-001 and UI-TYPO-001/a/M06. TAG/TYPE first, ACTION/COST/mixed deferred. Experimental card values and signatures remain subject to playtest; no production implementation in this commit. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md.


## CHAIN-004 — Consecutive card-play eligibility (designer approved 2026-11-27)
Only consecutive card plays determine CHAIN eligibility. Non-card encounter actions leave candidate and active CHAIN state unaffected: Icepick activation/boost, PROBE, CAP activation, inspection and cancelled plays do not insert links or interrupt the sequence. Successful Program installation and Protocol deployment count as card plays, consistent with existing baseline. Example: CLOAK card → PROBE → EXPLOIT card → Icepick activation → OVERCLOCK is consecutive in card-play history and eligible if its proposed signature is approved and satisfied. Existing no-overlap/no-reuse rule remains. Exact catalyst signature grammar, extension eligibility and discounts, incompatible-card termination/new candidate handling, turn/encounter boundary rules remain for explicit review. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-005 — Termination rules (designer approved 2026-11-27)
1. Playing a card that cannot extend an active CHAIN terminates that instance.
2. That card can immediately become the first link of a new CHAIN, without reusing any prior instance links.
3. Ending the Rustler turn or leaving/completing the encounter clears all candidate and active CHAIN state.
4. Termination never reverses previously earned CHAIN bonuses (ordinary effect durations still apply).
Non-card encounter actions remain neutral per CHAIN-004, except explicit turn/encounter boundaries. Termination is automatic; no separate termination action required. These approved rules supersede earlier open termination questions. Extension eligibility, extension discounts and exact catalyst signature grammar remain open. Acceptance: incompatible successful play ends active instance and seeds new candidate; no overlap; turn/encounter boundary clears state; prior rewards retained; non-card actions preserve state. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-006 — Persistent cumulative reward direction (designer endorsed 2026-11-27)
Preferred design direction: sustaining an instantiated CHAIN produces persistent cumulative rewards, encouraging the Rustler to discover an opportunity and rethink their intended turn strategy. Preserve escalating rewards explicitly for experimentation. Compare immediate fixed, banked fixed, immediate escalating and banked escalating delivery. Illustrative per-extension reward schedules: fixed 1,1,1 versus escalating 1,2,3; at six links totals 3 versus 6, assuming rewards begin at link four. Explore draw, BW, pile manipulation and tactical effects. Banked rewards require explicit settlement timing at incompatible play, turn end and encounter completion; cannot retroactively fund the terminating card without a separate rule. Test runaway draw/BW loops, player agency, opportunity cost, feedback and strategic redirection. Exact continuation eligibility, reward amounts, trigger on third link versus fourth, extension discount, settlement ordering and limits remain unresolved. No production mechanics or card values approved by this direction. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md.
