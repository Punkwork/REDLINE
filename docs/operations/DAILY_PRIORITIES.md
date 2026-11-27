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
