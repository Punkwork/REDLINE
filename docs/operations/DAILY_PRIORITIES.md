# Daily priorities — OPS-001

Daily review at 22:00 America/Toronto. Append dated agendas for the next working day. Each agenda: source reports and coverage gaps; decisions; ranked issue/PR references; proposed owners; blockers; carryovers; status PROPOSED or designer-confirmed. No automatic execution or approvals. No agenda selected yet.


## 2026-11-25 — designer-confirmed carryover (DOCS-MIG-001)

Priority: finish the UI documentation migration gate before any subsequent consolidation. See HANDOFF and AGENTS.md / CLAUDE.md §8 for the canonical scope and acceptance criteria. Status OPEN; repository-wide validation and legacy retirement not yet complete. Existing 22:00 review should reconcile this priority with current evidence, not duplicate it.

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
