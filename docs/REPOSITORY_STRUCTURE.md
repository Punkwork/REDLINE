# PANOPTICON — Repository Structure

PANOPTICON is a cyberpunk runner-versus-corporation deckbuilder. Godot 4 is the intended production engine; the Python/Pygame prototype is a gameplay reference, not the production build.

## Layout

- [UI Design Bible](PANOPTICON_UI_DESIGN_BIBLE.md) — consolidated UI working specification and component register; UI proposals live in GitHub Issues.

- `docs/` — authoritative design and project-management documents.
  - `REDLINE_MASTER_DESIGN.md` — design authority; preserve LOCKED decisions unless explicitly revised.
  - `REDLINE_BIBLE.md` — world and dialogue reference (lore only; its rules predate the 2026-11-12 redesign, DOCS-001).
  - `REDLINE_CURRENT_STATUS.md` — current handoff and verified implementation status.
  - `REDLINE_DEVELOPMENT_LOG.md` — dated development history and decisions (recent entries; kept under about 60 KB).
  - `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md` — older log entries, moved unchanged (LOG-001).
  - Simplified redesign (2026-11-12 onward; `REDLINE_CORE_RULES.md` is the rules authority where it conflicts with older entries):
    - `REDLINE_CORE_RULES.md` — core rules authority.
    - `REDLINE_RUSTLERS.md`, `REDLINE_CARD_POOLS.md` — Rustlers, starter decks and reward pools.
    - `REDLINE_ICE_CORP1.md`, `REDLINE_ICE_CORP2.md`, `REDLINE_ICE_CORP3.md` — HALCYON, IRONWATCH and LUCIDA ICE.
    - `REDLINE_UPLINK_AND_CAPS.md`, `REDLINE_UPGRADES_EVENTS_ESCAPE.md` — economy, CAPS, PATCHWORK, Ghostware, events, escape.
    - `REDLINE_ENGINES.md` — engine mechanics (ENG-001 to ENG-005).
    - `REDLINE_PLAYTEST_CHECKLIST.md` — playtest QA checklist.
    - `REDLINE_DECK_SYNERGY.md`, `REDLINE_PACING.md` — deck management/synergy and encounter pacing proposals (PROPOSED; DSY-, PACE- IDs).
    - `REDLINE_ICE_RULES_BIBLE.md`, `REDLINE_ICE_PASSIVES.md` — ICE type identities, budgets, subtypes and passive abilities (copies of the designer's Claude Docs).
  - `HANDOFF.md` — shared to-do for Codex and Claude: decided-but-unfinished work, owners, statuses, and the working branch. Read it at the start of every session.
- `godot/` — Godot 4 production project (put `project.godot` here when real source is imported).
- `prototypes/python/` — original Python/Pygame reference implementation and its related source.
- `assets/art/` — visual source and game art.
- `assets/audio/` — original/licensed audio assets.
- `assets/fonts/` — fonts that are legally distributable in the repository.
- `tests/godot/` — Godot-specific regression and integration tests.
- `tests/python/` — Python reference and regression tests.
- `tools/` — development, import, and validation scripts.

## Ground rules

1. These directories are scaffolding only. Their presence does **not** mean code, assets, or tests have been imported or verified.
2. Keep the four authoritative documents intact; document approved changes and their rationale.
3. Preserve the Python/Pygame prototype as reference evidence rather than silently converting or replacing it.
4. Do not mark a feature implemented or tested without source and reproducible test evidence.
5. Use the same repository checkout for VS Code, Codex, and Godot on a development computer; push/pull through GitHub. The working branch (`architecture-v2`, ARCH-V2-002) is named in `docs/HANDOFF.md` (currently `codex/halcyon-playtest-stabilization`); changes arrive as pull requests into it.
6. Store project sources and legitimately redistributable assets, not passwords, credentials, temporary builds, or unlicensed materials.

## Initial repository setup

The structure was initialized on 2026-11-10. At that point, only the root README, .gitignore, and authoritative docs were present; the implementation folders are intentionally empty placeholders. The original pre-documentation commit is preserved by the annotated tag `archive/backup/pre-authoritative-docs-2026-11-10`.
