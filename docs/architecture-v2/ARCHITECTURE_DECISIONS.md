# PANOPTICON — Architecture decision record

**Governing decision:** ARCH-V2-001 · **Created:** 2026-11-23 · **Status:** Historical record of approved direction plus unapproved design proposals.

This is a curated, durable record of the architectural discussion, **not a verbatim transcript**. It does not supersede the master design document or confer approval on proposals. Record future architectural choices here with date, rationale, alternatives, consequences, decision ID, and explicit designer approval evidence. Preserve superseded entries rather than rewriting history.

## ADR-001 — Evolve beyond the prototype's single-scene UI
**Status:** APPROVED DIRECTION under ARCH-V2-001 (designer, 2026-11-23).
**Context:** The current playable four-node Godot prototype builds much of its UI in code from `Main.tscn`. It is a functional reference, but not necessarily the best long-term architecture for multiple corporations, screens, reusable visual elements and future content.
**Decision:** Move toward a hybrid scene-based, component-driven, data-driven Godot 4.3 GL Compatibility architecture. Meaningful reusable scenes and typed GDScript components are permitted on the migration branch.
**Rationale:** Reuse, maintainability, easier visual iteration, clearer component responsibilities and lower risk of one giant UI script.
**Trade-offs:** Scene proliferation, resource duplication and increased complexity are risks. Prefer meaningful boundaries over scenes for every trivial element.
**Not approved yet:** Exact scene graph, file names, signals, resource types, migration details or production implementation.

## ADR-002 — Keep gameplay rules separate from presentation
**Status:** APPROVED PRINCIPLE under ARCH-V2-001; specific API PROPOSED.
**Decision:** Preserve existing `Game`, `CardDB`, `IceDB` and approved gameplay as the initial behavioral authority. Presentation must not change rules, RNG, card effects, ICE resolution, hidden information or response timing. A view adapter and snapshots are **proposals**, not approved APIs.
**Rationale:** Preserve existing gameplay and testability while replacing the interface.
**Risk:** Duplicate effects if animation callbacks resolve a rules step twice; incorrect targeting if array positions substitute for stable IDs.

## ADR-003 — Branch isolation instead of a repository fork
**Status:** APPROVED under ARCH-V2-001 (designer, 2026-11-23).
**Decision:** Use `architecture-v2` as primary migration branch in `Punkwork/REDLINE`. Preserve `main` as the prototype. Ask before further branches, merging into `main`, changing default branch, or altering release workflow.
**Rationale:** Preserve common history, CI, issues and traceability while isolating an architectural rebuild.
**Not completed:** Verified baseline SHA, passing tests and permanent prototype tag.

## ADR-004 — Incremental migration and evidence gates
**Status:** APPROVED DIRECTION under ARCH-V2-001; milestones PROPOSED.
**Decision:** Review a concrete blueprint first, then migrate one complete playable ICE encounter, compare with the prototype, prove reuse with another corporation presentation, and expand in stages only after validation.
**Rationale:** Avoid a high-risk rewrite of working gameplay and provide rollback checkpoints.
**Open:** First encounter selection, exact acceptance tests, CI and Windows validation, future release/merge policy.

## ADR-005 — GitHub as durable architecture record
**Status:** DOCUMENTATION WORK REQUESTED by designer, 2026-11-23; compliance process documented here.
**Decision:** Preserve architectural rationale and compliance expectations in version-controlled documents under `docs/architecture-v2/`, linked from both agent working agreements. Chat history is useful context, but repo decisions and approved design documents remain authoritative.
**Rationale:** Future Claude Code, Claude and ChatGPT sessions can check architecture without depending on access to this chat.
**Scope:** Documentation and review requirements only. This does not approve the unreviewed blueprint or change gameplay.

## Decision register
| Decision | Status | Authority |
|---|---|---|
| Hybrid architecture direction | APPROVED | ARCH-V2-001 in master design |
| Primary migration branch | APPROVED | ARCH-V2-001 in master design |
| Rules/presentation separation | EXISTING GUARDRAIL | AGENTS.md and architecture docs |
| Specific scene hierarchy | PROPOSED | SCENE_HIERARCHY.md |
| New resource schema | PROPOSED | DATA_MODEL.md |
| Adapter API and signal design | PROPOSED | GAMEPLAY_INTERFACE.md |
| Baseline tag and test results | PENDING VERIFICATION | VALIDATION.md |
| Merge/release changes | NOT APPROVED | AGENTS.md |

## Future decision entry template
```markdown
### ADR-### — Short title
Date:
Related master-design decision ID:
Status: PROPOSED / APPROVED BY DESIGNER / SUPERSEDED
Context and problem:
Options considered:
Decision and exact designer approval evidence:
Why:
Consequences and risks:
Files/tests affected:
Supersedes:
```

**No agent may mark a new proposal approved on its own.** New approvals must also be entered into the master design, HANDOFF and development log using the agreed decision ID.
