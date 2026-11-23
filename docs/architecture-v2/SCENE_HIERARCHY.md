# Proposed scene hierarchy — ARCH-V2-001

**Status: PROPOSED.** Scene names and boundaries are illustrative, not approved implementation files.

```text
Main / AppShell
├── RunMapScreen
├── EncounterScreen
│   ├── CorporationPresentation (theme/background/mascot; visual only)
│   ├── ICELane
│   │   └── ICEPanel × N
│   │       ├── ICEPortrait
│   │       └── SubroutineRow × N
│   ├── PlayerHUD (VITAE, BW, RAM, CRED, TRACE)
│   ├── HandView
│   │   └── CardView × N
│   ├── RigView / ProgramBay
│   ├── ResponseQueueView
│   └── EncounterLogView
├── RewardScreen
├── EventScreen
└── Shared overlays (targeting, discard choice, inspection, settings)
```

## Suggested ownership
| Unit | Responsibility | Does not own |
|---|---|---|
| AppShell | Navigation, screen lifecycle, saved presentation settings | Rules resolution |
| EncounterScreen | Orchestrates state snapshots and UI interaction | Authoritative card/ICE effects |
| ICEPanel | Draws one ICE, visible subs, targets and animations | ICE mutation or RNG |
| CardView / HandView | Card visuals, input affordances, drag previews | Play legality |
| PlayerHUD | Read-only meters and feedback | Resource totals |
| CorporationPresentation | Theme, copy, art, visual effects | Gameplay modifiers |
| ChoiceOverlay | Presents valid choices and returns selected IDs | Resolving the choice |

## Godot conventions to validate
- Reuse `.tscn` for meaningful, visually composed widgets/screens; use typed GDScript and lightweight helpers for behavior that does not need a scene.
- Avoid a separate scene for every icon or trivial element. Prefer composition and shared Theme/resources.
- Do not add global autoloads or a global event bus without a separate decision.
- Use stable instance UIDs and ICE identities; never rely on mutable array position as identity.
- Existing `Main.tscn` may initially remain the entrypoint while the new EncounterScreen is introduced behind a controlled fixture.

## Review questions
1. Which existing overlay and drag/drop responsibilities can be retained?
2. What is the minimum scene set for the first complete playable encounter?
3. How are reduced motion, input methods, screen scaling, and responsive layout handled?
4. Which visual details in the approved mockup are presentation requirements rather than new mechanics?
