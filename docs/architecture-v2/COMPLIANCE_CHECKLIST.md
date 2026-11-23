# PANOPTICON — Architecture V2 compliance checklist

**ARCH-V2-001 · Working review tool · Created 2026-11-23**

Use before significant architecture changes, new reusable scenes, resource/schema migrations and milestone reviews. Mark each item **PASS / FAIL / N/A / NOT VERIFIED**, link concrete evidence (commit, test log, file or screenshot), and record any exception and its designer approval. **A checklist is not a substitute for tests or designer approval.**

## A. Governance and scope
- [ ] Working on latest `architecture-v2`; `main` and `release` untouched unless separately approved.
- [ ] Read identical `AGENTS.md` and `CLAUDE.md`, master design, HANDOFF, current rules and relevant architecture docs.
- [ ] Change has a decision ID in master design, HANDOFF and development log.
- [ ] Approved architectural direction is distinguished from proposed implementation details.
- [ ] Designer approved the specific milestone/structural change before implementation; no new branch, merge or release without approval.

## B. Rules and model isolation
- [ ] Existing `Game` remains authoritative for legality, effects, phase, resources, RNG and rewards.
- [ ] No unapproved gameplay, balance or content-rule changes.
- [ ] UI/theme/animations do not write rules state or influence gameplay RNG.
- [ ] Each player command resolves exactly once, including animation and reduced-motion paths.
- [ ] Card instance UID and ICE identity are stable across targeting, movement, insertion and refresh.
- [ ] Pending choices, response queues and interrupted phases retain their original order and outcome.
- [ ] Hidden VOID subroutines, preview data and gated reveals are not exposed prematurely.

## C. Scenes, components and data
- [ ] Each new scene has a clear responsibility and a documented owner/lifecycle.
- [ ] Reusable visual components are genuinely reusable; trivial widgets are not unnecessarily split into scenes.
- [ ] Typed GDScript and Godot 4.3 GL Compatibility requirements remain intact.
- [ ] No unapproved autoload, global event bus, engine upgrade or unrelated refactor.
- [ ] Presentation profiles contain cosmetics only; corporation skins do not duplicate rules code.
- [ ] No competing copy-approval store or unreviewed conversion of CardDB/IceDB to resources.
- [ ] Any saved-data/schema changes have versioning and compatibility tests.

## D. Safety, presentation and accessibility
- [ ] SIGNAL-001 reveal and all existing copy guards preserved; no prohibited on-screen terms or QR codes.
- [ ] All personal play data remains local under `user://`; no new telemetry/network export.
- [ ] Rule text and interactive controls maintain at least 4.5:1 contrast.
- [ ] Reduced motion, focus/selection, drag/drop and alternate input paths remain usable.
- [ ] Decorations, wear, ads and effects cannot obscure rules, costs or buttons.

## E. Verification and delivery
- [ ] Exact baseline `main` SHA and environment recorded; tag status reported truthfully.
- [ ] Existing headless suites pass or failures are documented with evidence.
- [ ] Relevant display-backed fixtures run with isolated user data; screenshots inspected.
- [ ] New encounter compared against prototype using reproducible seeds/actions.
- [ ] Second corporation skin reuses the same encounter components (when that milestone is reached).
- [ ] Windows artifact creation is distinguished from an actual Windows playtest.
- [ ] HANDOFF, architecture docs and development log reflect implementation status and commit hashes.
- [ ] Any unresolved FAIL / NOT VERIFIED item is disclosed before asking for milestone approval.

## Review record template
```text
Milestone / decision ID:
Branch / commit:
Reviewer / date:
Files changed:
Baseline SHA / tag:
Automated test commands and results:
Display/manual test evidence:
Checklist FAIL / NOT VERIFIED items:
Exceptions and designer approvals:
Recommendation: approve / revise / block
```

## Review gate
Claude Code performs the technical self-review and supplies evidence. Claude may review design alignment. **Only the designer can approve** a proposed architectural decision or progression to a new gated milestone. Do not represent passing this checklist as proof of full gameplay or Windows validation.
