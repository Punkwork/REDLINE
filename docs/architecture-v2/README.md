# PANOPTICON — Architecture V2 blueprint

**Decision:** ARCH-V2-001 · **Status:** PROPOSED implementation design, not designer-approved · **Branch:** `architecture-v2` · **Date:** 2026-11-23

## Purpose
Design the full game using a hybrid Godot 4.3 (GL Compatibility) architecture: meaningful reusable scenes, typed GDScript components, data-driven presentation/content, and strict separation of authoritative rules from visuals. The existing four-node HALCYON build is a functional reference, not a mandatory UI template.

## Authority and guardrails
Read `AGENTS.md`, `CLAUDE.md`, `docs/REDLINE_MASTER_DESIGN.md`, `docs/HANDOFF.md`, `docs/ARCHITECTURE.md`, and current rules before implementation. Only the **direction and branch policy** of ARCH-V2-001 are approved. The detailed file hierarchy and contracts in this folder are **proposals for designer review**. Do not silently implement them or change rules, balance, copy gates, release policy, or `main`.

## Blueprint contents
- [SCENE_HIERARCHY.md](SCENE_HIERARCHY.md) — proposed screens, widgets, scene ownership.
- [DATA_MODEL.md](DATA_MODEL.md) — content and visual-resource strategy.
- [GAMEPLAY_INTERFACE.md](GAMEPLAY_INTERFACE.md) — state/action boundary and timing.
- [MIGRATION_PLAN.md](MIGRATION_PLAN.md) — milestones, rollback, and approvals.
- [VALIDATION.md](VALIDATION.md) — baseline evidence and acceptance gates.
- [ARCHITECTURE_DECISIONS.md](ARCHITECTURE_DECISIONS.md) — rationale, trade-offs and approval status.
- [COMPLIANCE_CHECKLIST.md](COMPLIANCE_CHECKLIST.md) — evidence-based review gate for architectural changes.
- [STATIC_SOURCE_AUDIT.md](STATIC_SOURCE_AUDIT.md) — read-only code audit, risks, proposed first milestone and Claude Code handoff.

## Current implementation
`godot/scenes/Main.tscn` and `scripts/ui/main.gd` currently construct most UI in code; `scripts/ui/friendly_lie/encounter.gd` renders the encounter. `scripts/core/game.gd`, `cards.gd`, and `ice.gd` are the initial rules reference. Existing `godot/tests/` and CI fixtures must continue to work unless a designer-approved migration changes their entrypoints.

## Decision gate
Claude Code should review these proposals against actual call sites, asset conventions, CI and tests, then provide a focused architecture decision package. **Do not create production scenes until the designer reviews and approves the specific plan.**

- [DEPENDENCY_MAP.md](DEPENDENCY_MAP.md) — source-grounded call paths, coupling analysis, migration seams and validation questions.
- [COMPONENT_ARCHITECTURE_SPEC.md](COMPONENT_ARCHITECTURE_SPEC.md) — CAS-001 formal component contracts, ownership, lifecycle, target dependencies and gated migration.

- [VAS-001.md](VAS-001.md) — designer-confirmed dense mechanical console visual target, proposed layout/asset/component specifications and vertical-slice fidelity acceptance.
