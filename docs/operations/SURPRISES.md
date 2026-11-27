# Surprises — OPS-001

| ID | Date | Agent | Observation and evidence | Impact | Status | Linked issue/PR |
|---|---|---|---|---|---|---|

Append actual unexpected findings; distinguish observation from interpretation. Status: open, investigating, resolved, deferred. No fabricated entries.

| CHATGPT-20261124-S01 | 2026-11-24 | ChatGPT | Branch compare divergence and inconsistent behind counts for same reported base; see dated report | Verify local git before integration | investigating | — |
| CHATGPT-20261124-S02 | 2026-11-24 | ChatGPT | Dedicated issue searches returned none despite UI-WORKFLOW-001 and HANDOFF UI work | Register coverage needs reconciliation | investigating | — |
| CHATGPT-20261124-S03 | 2026-11-24 | ChatGPT | Report template and expected dated reports returned 404 | Joint review coverage incomplete | open | — |
| CLAUDECODE-20261127-S01 | 2026-11-27 | Claude Code | Decision ID MINIBOSS-003 names two approved decisions: "THE GRID: PROFILE + FORTIFY" (Master Design, HANDOFF, `REDLINE_MINIBOSSES.md`) and "MAP-003f / MINIBOSS-003" (Mini-Boss category shown, identity hidden until entry) | References to MINIBOSS-003 are ambiguous; designer to assign a new ID to one | open | — |
| CLAUDECODE-20261127-S02 | 2026-11-27 | Claude Code | The V4 map generator accepted maps with dead-end Nodes (33 of 363 accepted, seeds 0–999) that its own route check could not see | V4 figures overstated validity; V5 checks reachability and dead ends explicitly | resolved (V5) | — |
| CLAUDECODE-20261127-S03 | 2026-11-27 | Claude Code | `test_core_loop.gd:98–101` asserts the superseded top-only PROBE reveal. `test_game.gd` is 430/0 while the live engine fails 5 of 7 PROBE-004a checks ([evidence](../architecture-v2/evidence/csa-01/probe_conformance.txt)) | Green CI does not mean conformance to approved rules | open (CSA-04) | — |
| CLAUDECODE-20261127-S04 | 2026-11-27 | Claude Code | `architecture-v2` (the default and canonical branch) has no branch protection and no ruleset (API 404; only `protect-main` and `release` rulesets exist) | Inconsistent changes cannot be blocked, only detected later | open (CSA-05, Q5) | — |
