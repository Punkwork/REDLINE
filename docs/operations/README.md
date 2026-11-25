# PANOPTICON Development Operations Hub — OPS-001

Single shared source of truth for ChatGPT, Claude, Claude Code and Codex. All agents file operations records on `architecture-v2`, the canonical branch (ARCH-V2-002, 2026-11-25); `main` is the preserved legacy prototype. Existing branch, approval and audit rules remain binding.

**Branch drift check (ARCH-V2-002i), every daily review:** record the heads of `architecture-v2`, `main`, `release` and any other branch. `main` must equal tag `prototype-baseline` (`21922ad`); `release` must equal its last `playtest-N` tag; the GitHub default branch must be `architecture-v2`; ruleset `protect-main` must be active on `main`. Report new branches, unexpected commits on `main` or `release`, and work landing anywhere but `architecture-v2` as surprises, for the designer to decide. Never fix drift by force-pushing.

- [Surprises](SURPRISES.md)
- [Missing tools](MISSING_TOOLS.md)
- [Pull requests — live GitHub register](https://github.com/Punkwork/REDLINE/pulls)
- [To-dos — live GitHub Issues](https://github.com/Punkwork/REDLINE/issues)
- [Daily reports](reports/)
- [Daily priorities](DAILY_PRIORITIES.md)

At each session end, file a report for actual work, surprises and missing capabilities. Use reports/YYYY-MM-DD-AGENT.md (Toronto date; append sessions with time and branch). Use REPORT_TEMPLATE.md. Report no findings explicitly only if observed; absence of report is unknown, not zero. Link existing entries instead of duplicating. Use agent/date/sequence IDs for surprises and tools; check for duplicates before adding. GitHub issue numbers and PR numbers are canonical; do not mirror them into independent lists. Search existing issues before creating actionable tasks. Link originating surprise/tool IDs. Do not create branches, merge PRs, approve design or assign work without applicable authorization.

At 22:00 America/Toronto daily, ChatGPT consolidates reports, both registers, actual open/recently changed PRs and issues, and proposes next working day's agenda. Review missing reports and inaccessible data explicitly. Record dated proposed agenda in DAILY_PRIORITIES.md, preserving prior entries. Designer confirms priorities before execution; record confirmation and carryovers. Claude contributes to the same files, not a parallel review register. Re-read current SHA before writes; on conflict re-fetch and reconcile, never overwrite another agent's changes. No secrets or unrelated private conversation content. No gameplay changes authorized by this workflow.

## Project progress — OPS-002

**Final goal:** commercially release a complete, designer-accepted PANOPTICON on Steam (OPS-002a); validated Windows distribution and creative quality are prerequisites. [Canonical milestone definitions and acceptance gates](../REDLINE_MASTER_DESIGN.md#ops-002--project-goals-milestones-and-progress-measurement-direction-2026-11-24).

**Baseline: 2026-11-24 — provisional, awaiting designer confirmation.** Accepted final milestone gates: **0 evidenced / 9 proposed**. This is not 0% of work completed. Overall effort completion: **not yet measurable** (scope, weights and acceptance baseline pending). Existing substantial implementation is acknowledged below.

| ID | Milestone | Evidence-based stage | Next evidence / blocker |
|---|---|---|---|
| M01 | Core loop | Built, acceptance pending | HANDOFF STRIP-001 and later playtest fixes; validate current build and outstanding playtest items |
| M02 | Architecture + HALCYON slice | In progress | HANDOFF MAP-003 generator prototype; full route integration not verified. Branch reconciliation done (ARCH-V2-002); Architecture V2 code not started |
| M03 | Three-corporation run | Partial design / implementation unverified | RUN-006 defines full run; prove all routes, transitions and ending |
| M04 | Content and balance | In progress | HANDOFF card/ICE and balance follow-ups; approved coverage and full-run tests |
| M05 | Narrative / NUL/REM | Partial build + design | SIGNAL scaffolding in current-status record; dialogue architecture proposed; verify approved integration |
| M06 | Presentation / accessibility | Partial build | Existing VIS/CARDS work and pending UI/audio batch in HANDOFF; full-run validation |
| M07 | Beta / release candidate | Not evidenced | Earlier Windows playtest export is not final release validation; current real Windows tests and defect gates |
| M08 | Final acceptance | Not evidenced | Designer-approved scope and release candidate |
| M09 | Commercial Steam launch | Not evidenced | Steamworks readiness, store/build review, launch authorization and public purchasability |

Sources: [HANDOFF](../HANDOFF.md), [current build status](../REDLINE_CURRENT_STATUS.md) (dated and potentially stale), [master design](../REDLINE_MASTER_DESIGN.md), [dialogue architecture](../PANOPTICON_NULREM_DIALOGUE_ARCHITECTURE.md). No fresh code/test audit performed for this baseline; architecture-v2 and current PR/issue state must be reconciled at review. No gate is asserted accepted without evidence.

**Next proposed milestone focus:** M01 validation and M02 architecture reconciliation; designer selects actual priorities.

**Daily update protocol:** During the existing 22:00 Toronto review, refresh this single snapshot, recording date, evidence links/commit, stage changes, accepted gates count, change from previous review, next gate and blockers. Link daily priorities and native issue/PR IDs to M01–M09. Preserve dated changes in DAILY_PRIORITIES.md rather than duplicating backlog. Missing evidence = unknown, not failure or completion. Only designer confirms acceptance and scope/weight changes. Do not equate gate count with effort percentage. No separate progress register for Claude.

OPS-002a: Steam commercial launch is designer-confirmed; M09 criteria are proposed. Track storefront and launch preparation alongside development, with no publication or spending without authorization. See [ultimate goal and launch gate](../REDLINE_MASTER_DESIGN.md#ops-002a--commercial-steam-release-direction-2026-11-24).


## UI proposal and development register — UI-WORKFLOW-001

**UI-WORKFLOW-001 (designer-approved, 2026-11-24):** GitHub Issues are the single authoritative UI proposal and development register for Claude Code, Claude, Codex and ChatGPT. Use stable component IDs from the UI Design Bible. Keep proposal discussion, mockup links, acceptance criteria, designer approval, implementation links and validation evidence in the issue; do not duplicate the backlog in HANDOFF or separate agent files. Only the designer approves; record approved decisions in Master Design and update the UI Design Bible as applicable. Development Log records actual work and links to the issue. Daily operations review uses the same issues. No code or rules changes.

**Review 2026-11-24, 22:00:** [observed report](reports/2026-11-24-ChatGPT.md) and [proposed agenda](DAILY_PRIORITIES.md). No new accepted gates evidenced; 0/9 unchanged, effort unknown. M01 current-status stale relative to HANDOFF; M02 branch divergence requires checkout verification; M06 migration gate open; M07 real Windows validation not refreshed. Other stages unchanged pending evidence. Next gate focus: M06 documentation prerequisite, then M02/M01 reconciliation and validation. No new tests or designer acceptance.
