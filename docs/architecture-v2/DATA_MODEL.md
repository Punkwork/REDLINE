# Proposed data model — ARCH-V2-001

**Status: PROPOSED.** Preserve existing authoritative definitions until migration is explicitly approved.

## Three layers
1. **Authoritative rules:** `Game`, `CardDB`, `IceDB` in `godot/scripts/core/` remain the initial source of truth for card effects, encounter state, choices, RNG and progression.
2. **Runtime view state:** immutable/read-only snapshots or narrowly scoped adapters expose the *currently allowed to be seen* state to the UI. Do not leak hidden VOID subroutines or gated reveal copy.
3. **Presentation resources:** corporation palettes, materials, art paths, audio cues, animations, display labels, and accessibility settings. These never determine rules outcomes.

## Candidate resource types (not yet implemented)
| Candidate | Example fields | Constraint |
|---|---|---|
| CorporationVisualProfile | corporation ID, palette, Theme, backgrounds, ICE frame style, mascot assets | Cosmetic only; existing copy approval/reveal guards still apply |
| ICEVisualProfile | ICE definition ID, art, animation family, display treatments | Do not duplicate STR/subroutine rule values |
| CardVisualProfile | card ID/art, rarity treatment, approved HuCard styling | Runtime card instance UID remains distinct from base ID |
| EncounterViewSnapshot | phase, visible ICE states, valid actions, visible resources, queue | Derived from Game, not independent mutable game state |
| AccessibilityProfile | reduced motion, contrast, scaling, audio settings | Presentation only |

## Migration strategy
- **Do not immediately rewrite `cards.gd` or `ice.gd` into `.tres` resources.** Compare authoring, validation, serialization and modifiability first.
- Reuse current `godot/data/` JSON approval tables and existing copy guards; do not create a second competing editorial approval system.
- Store visual resources in a consistent location selected during the architecture review (e.g. `godot/resources/visual/`), without moving assets unnecessarily.
- Preserve unique card instance UIDs across piles, compiled cards, grafts and saved state. Preserve existing relocation IDs and copy semantics.
- Any migration of gameplay content requires deterministic comparison tests and explicit approval.

## Open design decisions
Resource format (`.tres`, JSON, or typed definitions), schema/versioning, save compatibility, asset-loading strategy, corporation overrides and localization boundaries.
