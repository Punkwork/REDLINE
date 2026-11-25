# Proposed migration plan — ARCH-V2-001

**Status: PROPOSED.** Each implementation gate requires designer review as specified in governance.

## Phase 0 — Verify baseline
- Record exact `main` SHA, current Godot 4.3 version and renderer.
- Import, run the three existing headless test suites and record pass/fail counts and logs.
- Run relevant screenshot/input fixtures where a display is available; distinguish automated evidence from an actual Windows playtest.
- Propose permanent `prototype-v1-final` tag on the verified `main` commit; do not mislabel incomplete verification. *(ARCH-V2-002, 2026-11-25: created as `prototype-baseline` on `21922ad`.)*
- No changes to `main` or rules.

## Phase 1 — Architecture review
- Audit `main.gd`, `friendly_lie/encounter.gd`, `card.gd`, `hand.gd`, core interfaces, tests, CI, visual requirements and current approvals.
- Resolve proposed scene ownership, state adapter, visual resources, input and animation timing.
- Produce a small dependency graph and exact list of first-milestone files.
- **Stop for designer approval** before substantial new scene implementation.

## Phase 2 — One representative encounter
- Create only the minimum reusable scenes and adapters needed for one playable ICE encounter.
- Retain the existing rules engine and compare deterministic state/actions with the prototype.
- Cover card selection, drag/drop, ICE targets, resource meters, response queue, choice overlay, and completion.
- Keep legacy UI available as a comparison fixture until parity is demonstrated.

## Phase 3 — Scalability proof
- Apply a second corporation visual profile to the same encounter components without duplicating rules/UI.
- Verify hidden information, copy gates, accessibility, animations and resolution/input behavior.
- Profile scene instantiation and asset loading; avoid premature optimization.

## Phase 4 — Controlled migration
- Migrate map, reward, events, settings and remaining screens in approved increments.
- Maintain test coverage and update docs/HANDOFF after each milestone.
- Define CI, Windows playtest, release and merge policy before changing `release` or `main`.

## Rollback
All work remains on `architecture-v2`. `main` is not rewritten; compare against the recorded baseline SHA. Revert individual migration commits rather than rewriting history. Do not force-push shared branches without separate authorization.

## Explicit non-goals
No unapproved balance changes, rules rewrite, engine upgrade, blanket refactor, new global singleton, or premature mass generation of scenes.
