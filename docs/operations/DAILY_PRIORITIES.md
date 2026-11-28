# Daily priorities — OPS-001

Daily review at 22:00 America/Toronto. Append dated agendas for the next working day. Each agenda: source reports and coverage gaps; decisions; ranked issue/PR references; proposed owners; blockers; carryovers; status PROPOSED or designer-confirmed. No automatic execution or approvals. No agenda selected yet.


## 2026-11-25 — designer-confirmed carryover (DOCS-MIG-001)

Priority: finish the UI documentation migration gate before any subsequent consolidation. See HANDOFF and AGENTS.md / CLAUDE.md §9 for the canonical scope and acceptance criteria. Status OPEN; repository-wide validation and legacy retirement not yet complete. Existing 22:00 review should reconcile this priority with current evidence, not duplicate it.

## 2026-11-25 — proposed daily agenda (OPS-001, review 2026-11-24)

Source: [ChatGPT report](reports/2026-11-24-ChatGPT.md). Claude, Claude Code and Codex expected dated paths returned 404; report directory coverage incomplete. Dedicated PR search: 12 closed historical, none open/recent since Nov 23; Issues search returned none. No new approvals. Existing designer-confirmed DOCS-MIG-001 carryover above remains binding.

| Rank | Canonical reference / milestone | Proposed owner | Dependency / completion evidence / decision |
|---|---|---|---|
| 1 | DOCS-MIG-001 / UI-BIBLE-001 (M06) | Claude/ChatGPT editorial; Claude Code checkout | Relocate narrative, reconcile, scan all tracked dependencies, repair links/anchors, applicable tests, retire seven legacy sources only after validation; atomic completion commit. Designer resolves genuine conflicts. No next consolidation until pass. |
| 2 | M02 architecture-v2 and review/cards-002 | Claude Code + Claude | Verify branch heads/divergence with local git, inventory unique changes and compare current main; recommend disposition and VAS-001 integration scope. Designer decides; no merge/rebase. |
| 3 | M01 NULL-POINTER-001; STRIP-001 / PT11-BUG-1 / PT11-UI | Claude Code; designer Windows playtest | Confirm runtime 1 BW sync and tests; establish current build SHA, run baseline checks and real Windows validation of latest authorized artifact. No release movement without authorization. Refresh current-status record. |
| 4 | UI-WORKFLOW-001 / M06; OPS-001 | Claude/ChatGPT | Verify native issue register, reconcile existing UI work by stable component IDs, restore report template and agent reporting coverage; designer confirms issue creation if needed. No parallel backlog. |
| 5 | MAP-003 / MINIBOSS-002 (M02/M03) | Claude then Claude Code | Resolve route/count ambiguities and validate prototype against current decisions before proposing port; depends on architecture disposition. |
| 6 | CAP-EXP-001, ICE-EXP-002, CRED-EXP-001d, VOID-EXP-001 (M04/M05) | Designer + Claude | Preserve proposals; defer implementation. Select later experiments after baseline/gate; no prices for infiltration CAPS yet. |

Milestone snapshot: no new acceptance evidence, 0/9 proposed gates evidenced; effort percentage unknown. Steam goal unchanged. Status PROPOSED except existing rank 1 carryover. Designer confirmation required for agenda execution.

## 2026-11-26 — proposed daily agenda (OPS-001, review 2026-11-25)
Source: [ChatGPT review](reports/2026-11-25-ChatGPT.md), [Claude report](reports/2026-11-25-Claude.md), f6c7c64, adc7007, native issues #13–24. No separate Claude Code/Codex reports. Supersedes prior proposed branch reconciliation and UI migration carryover: Gate F accepted, UI-BIBLE-001 validated and completed in recorded evidence; DOCS-MIG-001 remains standing requirement, no next batch authorized. No new approvals.
| Rank | Canonical reference | Proposed owner | Dependencies / evidence / decision |
|---|---|---|---|
| 1 | ARCH-V2-001 / CAS-001 / [#21](https://github.com/Punkwork/REDLINE/issues/21) (M02/M01) | Claude Code + Claude + designer | Review component boundaries, dependencies, runtime baseline and encounter/card interactions; designer approves representative slice scope before implementation. |
| 2 | STRIP-001 / M01 / RELEASE-002c | Claude Code | After rank 1 approval, build one playable encounter preserving rules, compare prototype tests, component tests and screenshot fixtures; no release until gate passes. |
| 3 | RELEASE-002 / ARCH-V2-002i / M07 | Designer + Claude Code | Reconcile missing playtest-12 tag against authorized 2845ecd; refresh current-status record and artifact/Windows evidence. No ref changes without authorization. Can run in parallel with rank 1. |
| 4 | [#23](https://github.com/Punkwork/REDLINE/issues/23), [#24](https://github.com/Punkwork/REDLINE/issues/24), [#22](https://github.com/Punkwork/REDLINE/issues/22) (M06) | Claude Code + designer | Review legacy fixture disposition, approved flyout readability, built items; sequence with slice, no unrelated polish. |
| 5 | OPS-001 | All agents | File actual dated reports, reconcile register status, maintain canonical branch; no duplicate tasks. |
| 6 | MAP-003 / CAP-EXP-001 / ICE-EXP-002 / CRED-EXP-001d (M03/M04/M05) | Designer + Claude | Preserve experiments; encounter/card system first, node surveillance later; no implementation or further consolidation until chosen. |
Status PROPOSED. 0/9 final gates evidenced; effort unknown. Designer confirmation required.


## 2026-11-26 — retrospective designer confirmation of 2026-11-25 agenda (OPS-001)

Designer explicitly confirmed the November 25 agenda on November 26 (Toronto time). Status: DESIGNER-CONFIRMED for the November 25 agenda only. Ranked priorities, owners and dependencies are those in the November 25 table above:

1. Complete UI documentation migration.
2. Reconcile architecture branches.
3. Validate the current gameplay build.
4. Establish reliable joint operations.
5. Review network map implementation.
6. Review experimental mechanics.

Reconciliation: ranks 1 and 2 have subsequently been recorded complete in the November 26 proposed agenda and AGENTS.md; this historical confirmation does not reopen them. DOCS-MIG-001 remains a standing gate. The November 26 agenda remains PROPOSED pending separate designer confirmation. No new implementation, design approval, branch/ref changes or parallel backlog authorized by this entry.

## 2026-11-26 — Representative encounter inventory authorization (ARCH-V2-001 / CAS-001 / VAS-001 / OPS-001)

**Designer-confirmed Priority 1:** Representative playable ICE encounter. Designer approved the development sequence: ICE/subroutine interaction; card-playing interaction; resources/status; turn/response; encounter completion; visual/sensory refinement. VAS-001 canonical [mockup](https://github.com/Punkwork/REDLINE/blob/architecture-v2/godot/assets/architecture_v2/references/PANOPTICON_VAS-001_reference_mockup.jpeg) is central from the first component, not a late skin. Typography and motion (UI-TYPO-001/a, #24), including stage and transition announcements, are required in the representative encounter and developed in parallel. Exact treatments remain for review.

**Explicit authorization:** “the 2 technical inventories are authorized.”
- **Claude Code:** functional/runtime inventory of all CAS-001 C01–C18 contracts, existing source, dependencies, runtime and applicable tests; classify reuse/adapt/complete/build/validate; propose representative encounter and first C07–C09 batch with C02/C04/C18 dependencies, exact file ownership and evidence.
- **Codex:** independent visual/asset inventory against VAS-001 and UI Bible; inspect existing art, fixtures, fonts, controls, typography, motion and announcement capabilities; classify reuse/adapt/create, identify gaps and propose isolated fixture tasks with file ownership.

Both may start immediately on architecture-v2. Read AGENTS.md/CLAUDE.md and canonical specs first. Inventory and non-mutating runtime/test investigation only; no production edits, new branches, merges, release changes, rules changes or overlapping implementation. File actual findings in shared dated operations reports; link evidence and #21/#24, distinguish verified from unverified. Stop for designer review before production implementation. Detailed development prompts follow inventory findings. Other November 26 ranks remain proposed.

## 2026-11-27 — designer-confirmed daily agenda (OPS-001; review 2026-11-26)

Status: DESIGNER-CONFIRMED on November 27 (Toronto). Sources: November 26 consolidated ChatGPT review, [Codex inventory](reports/2026-11-26-Codex.md), Claude Code contribution (report commit `35bc3f2`, reviewed head `7bdf1f2`). Claude Code reports Batches 1–4 playable, 42 runtime screenshots, zero test failures and authorized Playtest 13 at `a6f4476`. These are agent-reported findings, not independently revalidated by ChatGPT. This agenda supersedes the earlier inventory-stage priorities for current work; historical entries remain intact.

| Rank | Confirmed priority / canonical reference | Owner | Dependencies / deliverable |
|---|---|---|---|
| 1 | Playtest 13 Windows validation / RELEASE-002 | Designer; Claude Code support | [Artifact](https://github.com/Punkwork/REDLINE/actions/runs/45985348390/artifacts/15191118131); verify build commit and checksums, launch on Windows, test rendering/audio/input and complete encounters; record findings. |
| 2 | Representative ICE encounter refinement / VAS-001 / CAS-001 / #21 | Designer + ChatGPT + Claude Code | PT13 and actual fixtures; evaluate ICE composition, keys, cards, hover, response feedback and negative space; prioritized evidence-backed corrections and designer acceptance. |
| 3 | Typography and Motion Design System in parallel / UI-TYPO-001/a / M06 / #24 | ChatGPT + Claude + Codex + Claude Code | Physical/virtual typography, event hierarchy, timing, competing events, reduced effects and working Godot specimens; avoid duplicate production work. |
| 4 | Targeted UI improvements / #16, #14, #18 and PT13 findings | Claude Code + Codex | Re-triage against current build; propose and test incremental corrections within approved scope. |
| 5 | Repository and release reconciliation / OPS-001 / RELEASE-002 / DOCS-MIG-001 / UI-BIBLE-001 | Claude Code + designer | Evidence links for #13/#15/#17/#20; review #19 supersession; verify tag, branch drift, migration gate and current records. No issue closure or ref changes without required authorization. UI-BIBLE-001/DOCS-MIG-001 validation status to be reconciled against recorded evidence. |
| 6 | Map and reward architecture planning ONLY / MAP-003 / C01 / C17 / F10 | Claude Code + designer | Proposed component boundaries and dependencies; no production map/reward implementation authorized by this agenda. |

Designer explicitly approved these six priorities in this order. Agenda confirmation does not itself constitute final VAS-001 acceptance, approval of new rules or designs, branch/tag changes, issue closure, or authorization beyond existing implementation gates. CAPS and secondary gameplay experiments deferred. Canonical active branch remains architecture-v2; preserve shared backlog and agent ownership boundaries.


## CHAIN-REP-001 — Representative encounter scope clarification (designer approved 2026-11-27)
Priority 2 representative encounter milestone must fully flesh out, implement and playtest Rustler CHAIN mechanics and their UI. Designer reports current CHAIN operation, activation and effects are effectively invisible. Audit approved rules, current engine and card coverage; identify gaps, specify and validate card sequencing, eligibility, bonuses and feedback; coordinate with UI-TYPO-001/a, M06, CAS-001 and VAS-001. Proposed UI acceptance states: potential, progression where applicable, ready, activated, resolved; icons/hover/focus, pre-action clarity, distinctive motion/audio and reduced-effects support. Exact UI and any new mechanical rules require designer approval; do not invent new CHAIN rules. Include meaningful CHAIN combinations in HALCYON representative encounter and multi-encounter coverage. Separately retain CHAIN PULP (existing 1 PULP per CHAIN bonus) as an IRONWATCH-preferred reactive ability for a future IRONWATCH representative encounter milestone; exclude CHAIN PULP development from current HALCYON milestone, without excluding Rustler CHAIN itself. Existing PATTERN ANALYSIS assignment requires later reconciliation. No engine changes in this documentation update. Preserve current priority ordering and coordinate with Claude Code's ongoing GUARD work.


## CHAIN-002 — Foundational CHAIN revision (designer approved 2026-11-27)
Canonical working specification: [PANOPTICON CHAIN Mechanics](../PANOPTICON_CHAIN_MECHANICS.md). Supersedes DSY-011's two-card activation threshold: minimum three cards; third valid card instantiates a CHAIN instance and receives inherent −1 BW play-cost reduction before commitment, plus applicable card-specific bonus. Longer chains permitted; exact eligibility, extension discounts, termination, repeat instances, cost floor/precedence and card balance remain open. CHAIN-REP-001 remains Priority 2; coordinate CHAIN visibility and CHAIN ACTIVATED audiovisual feedback with UI-TYPO-001/a and M06. Existing engine and cards still reflect historical rules until implementation; no production change authorized by this documentation commit. CHAIN PULP remains deferred to IRONWATCH. See canonical specification for examples, audit, questions and acceptance plan.


## CHAIN-003 — Experimental catalogue and first playtest candidates (2026-11-27)
See [canonical CHAIN specification](../PANOPTICON_CHAIN_MECHANICS.md) for all 15 experimental combinations and proposed TAG/TYPE/ACTION/COST grammar. First experimental cohort: OVERCLOCK, SLIPSTREAM, RELAY, BOOTSTRAP, HANDSHAKE, DAISY CHAIN (TAG/TYPE only; free execution requires additional rule review). Priority 2E / CHAIN-REP-001; coordinate M06 and UI-TYPO-001/a. Designer authorized recording and candidate selection, not final card balance or production implementation. Resolve grammar, extension/termination and free-play safety before implementation; later ACTION/COST/mixed signatures retained for exploration. No engine changes.


## CHAIN-003a — Experimental playtest development sequence (designer approved 2026-11-27)
Proceed with the CHAIN-003 six-card experimental programme under Priority 2E / CHAIN-REP-001: (1) OVERCLOCK foundational activation and free draw, (2) SLIPSTREAM and BOOTSTRAP BW generation, (3) RELAY and HANDSHAKE pile manipulation, (4) DAISY CHAIN free execution after legality/recursion review, (5) integrated six-card interactions and multiple distinct instances. Finalize baseline activation, termination and extension rules with designer before implementation. First deliverable: OVERCLOCK mechanically, visually and audibly realized, coordinated with CAS-001 and UI-TYPO-001/a/M06. TAG/TYPE first, ACTION/COST/mixed deferred. Experimental card values and signatures remain subject to playtest; no production implementation in this commit. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md.


## CHAIN-007 / CHAIN-008 — Balance constraints, extension economics and playtest roadmap (designer approved 2026-11-27)
CHAIN-007: Exceptional, not routine. CHAIN complements normal encounter play; powerful extended instances must be earned through sequencing, availability, BW and preparation. Non-CHAIN decks remain competitive. Evaluate rewards against actual ICE threat; test escalating rewards and recursive/self-sustaining draw/BW/recovery loops. No universal length cap unless evidence warrants reconsideration. Track activation frequency, extension length, reward magnitude/efficiency, sustainability, opportunity cost, strategic redirection, encounter relevance and experiential mastery. Numerical thresholds remain experimental.
CHAIN-008: Third card receives inherent −1 BW instantiation discount. Each subsequent eligible card receives the persistent effect defined by the instantiating card, but no automatic BW discount. Explicit card-specific cost effects remain possible. Persistent extension rewards start at link four; separate activation bonuses remain possible. Exact continuation eligibility and activation grammar, cost precedence/zero floor, reward amounts and banked settlement remain open for designer review. Existing CHAIN-004/005 neutrality and termination and no-overlap rules apply.
Approved development roadmap under Priority 2E / CHAIN-REP-001: (1) balance principles; (2) finalize ordered TAG/TYPE activation grammar and cost handling; (3) finalize continuation grammar; (4) concrete card economics using existing cards where possible, actual BW/DRAW, ICE STR/subroutines and incoming damage; (5) implement OVERCLOCK first after rule approval; (6) parallel audiovisual feedback with UI-TYPO-001/a and M06; (7) controlled expansion into BW, pile manipulation, banked and escalating rewards; (8) integrated balance/experience testing across single and multi-encounter nodes. Required scenarios: no CHAIN, three-link, five-link, exceptional eight-link, two independent instances; verify feasibility rather than assume all lengths attainable. Designer/ChatGPT own design and acceptance; Claude Code owns engine/tests/fixtures. No production implementation in this documentation commit; do not implement unresolved rules by assumption. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md.


## CHAIN-PARK-001 — Designer decision: park explicit CHAIN mechanic (2026-11-27)
Effective immediately, the proposed standalone CHAIN mechanic (CHAIN-002 through CHAIN-010, CHAIN-REP-001 and associated Priority 2E implementation/playtest roadmap) is PARKED / experimental, not an active production requirement or representative encounter acceptance gate. Preserve the complete historical exploration in docs/PANOPTICON_CHAIN_MECHANICS.md as an experimental reference indexed by docs/PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md; do not delete it or treat prior approvals as current implementation authorization. Designer prefers elegant card-local sequencing and emergent synergy, citing Slay the Spire's per-card Block reward as inspiration. Explore existing Protocols as the natural vehicle for persistent conditional/per-card effects; use ordinary card effects for sequencing, draw, BW, pile manipulation and accumulated-action rewards. Preserve momentum, mastery, exceptional rather than routine combinations, resource-loop safeguards and clear audiovisual feedback without a separate CHAIN grammar, catalyst, link tracking or dedicated CHAIN UI requirement. Examples are exploratory, not approved new cards. Representative ICE encounter remains priority; remove standalone CHAIN work from active scope, retain general card synergy as a design exploration. Existing legacy DSY-011 CHAIN code/cards require Claude Code inventory and designer-approved retirement/reconciliation plan before production changes; no engine edits or issue closures in this decision. Future revival requires explicit designer approval.


## SYNERGY-PLAYTEST-001 — Card-local synergy candidates (designer approved for playtest 2026-11-27)
Preserve all ten candidates in the active representative ICE encounter playtest backlog, replacing the parked standalone CHAIN workstream within Priority 2E. Candidate effects below are experimental; costs, rarity, duration, targeting, stacking and balance remain to be finalized. No standalone CHAIN grammar required.

| Card | Type | Candidate effect |
|---|---|---|
| REACTIVE ARMOUR | PROTOCOL | Whenever you play a card, gain 1 SHIELD. |
| COUNTERINTELLIGENCE | PROTOCOL | Whenever you play a CLOAK, reduce TRACE by 1. |
| OVERCLOCK | PROTOCOL | Whenever you play your third card each turn, draw 2 cards. |
| FEEDBACK LOOP | PROTOCOL | Whenever you ZERO an ICE, gain 1 BW. |
| SALVAGE | PROTOCOL | First time each turn you break a DEADLOCK, return a discarded card to your hand. |
| ADAPTIVE DEFENCE | PROTOCOL | Whenever you install a PROGRAM, gain 3 SHIELD. |
| FOLLOW THROUGH | SCRIPT | Reduce ICE STR by 2; reduce by 2 more if previous card played was an EXPLOIT. |
| ESCALATION | SCRIPT | Reduce ICE STR by 1 for every EXPLOIT played this turn. |
| AFTERBURN | SCRIPT | Gain 4 SHIELD if at least three cards have been played this turn. |
| REPRISE | SCRIPT | Repeat the last SCRIPT played this turn, subject to restrictions. |

Playtest individually and in combinations using controlled fixtures; include display/hover readability, Protocol rack status, trigger feedback, card order, resource economics, loop prevention and encounter relevance. Clarify whether the current card counts toward thresholds, trigger timing, replay legality and recursion before implementation. Check existing card names/IDs for collisions. Claude Code to prepare implementation/test plan; no production changes in this documentation batch. Canonical candidate register: docs/REDLINE_DECK_SYNERGY.md. CHAIN-PARK-001 remains in force.


## PROTOCOL-DURATION-001 — Designer-approved lifecycle distinction (2026-11-27)
Deployed PROTOCOLS last the current encounter only; installed PROGRAMS persist across encounters within the current node, subject to existing removal rules. This supersedes earlier node-duration assumptions for Protocols, including SYNERGY-PLAYTEST-001 proposals. Validate encounter completion/transition cleanup, Protocol rack reset and cessation of expired triggers, Program/RAM persistence across two- and three-encounter nodes, and node-exit cleanup. Exact destination of expired Protocol cards and cleanup ordering relative to breach/reward triggers require review against existing lifecycle rules before implementation. Claude Code to audit existing engine, tests, UI and documentation for affected assumptions and include reconciliation in the representative encounter plan. No production code changes authorized by this documentation batch. Other proposed card costs and conventions remain pending review.


## PROTOCOL-DURATION-001b — Encounter cleanup timing (designer approved 2026-11-27)
Protocols remain active through final DEADLOCK action and qualifying triggers, BREACH, remaining permitted Runner actions, END TURN and PARTING SHOT, including all associated triggered effects. After resolution and survival confirmation, expire deployed Protocols to discard exactly once, before encounter progression or node completion rewards. Fatal PARTING SHOT grants no successful completion rewards. Installed Programs and RAM allocation persist across encounters in the node. Apply cleanup consistently on normal progression, forced LOCKDOWN progression and early exit; next node draws a new hand from compiled deck. Existing game.gd go_deeper() retains Protocols between layers, a confirmed discrepancy requiring reconciliation. Claude Code to validate trigger ordering, pending choices, fatal response, card conservation, rack reset, Program persistence and next-node initialization with deterministic multi-encounter tests. Existing BREACH-001 parting-shot behavior remains intact. Documentation only; no engine changes or authorization to implement the ten candidate cards before specification review.


## SYNERGY-PLAYTEST-002 — Approved ten-card playtest catalogue (2026-11-27)
Designer approves all ten SYNERGY-PLAYTEST-001 candidates for playtest, with REACTIVE ARMOUR reduced to 1 BW; remaining proposed costs unchanged. No CRED deployment costs. Values are playtest baseline, not final balance.
| Card | Type | BW | Effect |
|---|---|---:|---|
| REACTIVE ARMOUR | PROTOCOL | 1 | Whenever you play a card, gain 1 SHIELD. |
| COUNTERINTELLIGENCE | PROTOCOL | 1 | Whenever you play a CLOAK, reduce TRACE by 1. |
| OVERCLOCK | PROTOCOL | 2 | Upon playing your third card each turn, draw 2 cards. |
| FEEDBACK LOOP | PROTOCOL | 1 | Whenever you ZERO an ICE, gain 1 BW. |
| SALVAGE | PROTOCOL | 2 | First DEADLOCK broken each turn: return a selected discarded card to hand. |
| ADAPTIVE DEFENCE | PROTOCOL | 1 | Whenever you install a PROGRAM, gain 3 SHIELD. |
| FOLLOW THROUGH | SCRIPT | 1 | Target ICE -2 STR, additional -2 if previous card played was EXPLOIT. |
| ESCALATION | SCRIPT | 1 | Target ICE -1 STR per EXPLOIT played this turn including itself. |
| AFTERBURN | SCRIPT | 0 | Gain 4 SHIELD if at least three other cards played this turn. |
| REPRISE | SCRIPT | 2 | Repeat effect of previous SCRIPT played this turn. |
Protocol lifecycle PROTOCOL-DURATION-001/a/b mandatory. Successful card plays count, not Icepick or CAP activations; no Protocol self-trigger on deployment; independent copies, no additional trigger cap initially except printed limits. REPRISE repeats effect, not card-play event, cannot repeat itself; Claude Code must audit targeting, recursion, pending choices and legality, flag unresolved semantics rather than silently inventing rules. STR reductions encounter duration. No standalone CHAIN mechanic.
All ten must be obtainable through normal node completion card rewards in the representative playtest (audit CORE_POOL/reward eligibility and rarity configuration). Designer also proposes UPLINK node to ensure specific cards are accessible for testing; recommended test-only fixed inventory of all ten, affordable CRED purchase prices, placement before subsequent combat, exact prices/placement and existing UPLINK architecture audit pending. Do not treat temporary inventory/prices as final economy. Preserve organic reward acquisition alongside deterministic fixtures and targeted purchase access. Include two-/three-encounter nodes, card display/hover, rack, trigger feedback, acquisition, deck persistence, lifecycle, loop prevention and regression tests. Priority 2E Card Synergy and Protocol Development; coordinate with representative encounter and typography/motion. Claude Code owns implementation and validation; this commit approves playtest content and reward inclusion, records UPLINK proposal for implementation planning, does not itself modify engine or authorize unrelated map expansion.


## SYNERGY-PLAYTEST-002a — OVERCLOCK revision (2026-11-27)
Designer adds +1 BW to OVERCLOCK's approved effect: upon playing your third card each turn, draw 2 cards and gain 1 BW. Retain 2 BW deployment cost, encounter duration, once per turn per deployed copy, and all other SYNERGY-PLAYTEST-002 conventions. Supersedes the draw-only effect. Include immediate BW availability, trigger frequency and resource-loop tests. Documentation only; no engine changes.

## 2026-11-28 — Proposed next working day agenda (review 2026-11-27)
Pending designer confirmation. Evidence: [ChatGPT review](reports/2026-11-27-ChatGPT.md), [Claude Code report](reports/2026-11-27-Claude-Code.md), reviewed head 9595786b, [CI](https://github.com/Punkwork/REDLINE/actions/runs/46096427208). Supersedes earlier proposed sequencing, not approvals.

| Rank | Canonical work | Proposed owner | Dependencies / next evidence / decision |
|---|---|---|---|
| 1 | Representative ICE encounter VAS-001/CAS-001/#21; PT13 RELEASE-002 | Designer + Claude Code | Windows artifact checksum, launch, encounter feedback and parity; distinguish PT13 from newer head; tag PT13 only by designer; no new cut without approval. |
| 2 | CONSISTENCY-001a CSA-04/05/06 | Claude Code; designer approval | CSA-03 accepted; 04a–d built, CI green. Complete consumer wiring and independent PROBE acceptance; CI schema/IDs/terms/generated drift/spec tests/Python/append-only log guard/agent equality; designer applies required-check ruleset after checks exist; retire duplicates only after validation. Resolve Q4 historical wording conflict and duplicate MINIBOSS-003 ID. |
| 3 | M06 UI-TYPO-001/#24, UI-INSPECTOR-001 | ChatGPT/Claude design, Codex fixtures, Claude Code bindings | Review existing specimens and latest typography direction; inspector consumes canonical card data; verify readability/reduced effects and event motion. Designer accepts exact treatments. |
| 4 | SYNERGY-PLAYTEST-002/a, PROTOCOL-DURATION-001/a/b | Claude Code + designer | Ten pending records; implement approved effects/lifecycle with spec tests and reward eligibility, no CHAIN revival; validate final DEADLOCK/PARTING SHOT/expiry, replay safety and multi-encounter persistence. Coordinate CSA batches. |
| 5 | UPLINK-SPEC-001 / MAP-003f / NODE-PURPOSE-001 | Claude Code + designer/Codex | V5 prototype reported validated; resolve I1–I5 and shared PRNG, Python CI, Clinic docs; review technical dependencies and UI before port/integration. Use generator and developer inventory override, not bespoke route. |
| 6 | OPS-001 / DOCS-MIG-001 / UI-BIBLE-001; #13–20/#22/#23 | Claude Code + designer | Validate migration evidence before closure; reconcile issue evidence and supersession; recheck #16 against new PROBE; missing reports and release tag; decide legacy branch disposition. No closure/settings changes without authorization. |

No new approvals or implementation authorized by this proposal. Preserve existing decisions and shared native issue register.


## 2026-11-28 — Designer-confirmed agenda (2026-11-27, 22:57 Toronto)

OPS-001 — Designer explicitly confirms the November 28 proposed agenda above, in this exact order:

1. Representative ICE Encounter
2. Canonical Source Architecture
3. Typography and Motion Design System
4. Protocol and Script playtest development
5. Uplink and map integration
6. Repository governance and documentation

Retain the proposed agenda's owners, dependencies, blockers and decision gates. Confirmation establishes priority order only; it does not authorize new implementation, approvals, merges, branches, releases or issue closures beyond existing authorization. UI-BIBLE-001 / DOCS-MIG-001 remain open for review validation. All agents use this shared record on architecture-v2 (ARCH-V2-002).


## 2026-11-28 — Designer-authorized agenda amendment (2026-11-27)

OPS-001: All six confirmed priorities retain their existing rank. Under priority 6, remove UI-BIBLE-001 / DOCS-MIG-001 migration revalidation from outstanding work. Master Design records the designer-approved UI-BIBLE-001 completion and DOCS-MIG-001 gate pass on November 25, including preservation, dependency repair, link validation, tests and retirement evidence. See [completion record](../REDLINE_MASTER_DESIGN.md#ui-bible-001-completion--documentation-migration-gate-passed-docs-mig-001-2026-11-25). This supersedes earlier open-for-review wording. DOCS-MIG-001 remains a standing governance requirement for future migrations; reopen this completed batch only on new evidence of a defect. Other priority 6 tasks and all existing authorization gates remain unchanged. Recorded evidence reviewed; original tests not rerun. No implementation or issue closure authorized.
