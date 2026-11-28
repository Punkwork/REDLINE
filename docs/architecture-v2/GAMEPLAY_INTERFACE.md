# Proposed gameplay/presentation contract — ARCH-V2-001

**Status: PROPOSED.** The existing `Game` action API and `FriendlyEncounter.sync()` are the reference until audited.

## One-way authority
```text
Input → EncounterScreen → validated Game action
                                ↓
                         Game state + events
                                ↓
                     View adapter / snapshot
                                ↓
                       Reusable UI scenes
```

- **Game is authoritative** for action legality, turn transitions, RNG, damage, BW/RAM, ICE/subroutine resolution, rewards, and pending choices.
- **UI is authoritative only for presentation**: hover, focus, drag ghost, selection glow, layout, animation, sound and reduced-motion treatment.
- A visual animation may delay *display* of the next step but must not create a second rules resolution or reroll a preview.

## Candidate adapter operations
- `build_visible_snapshot(game)`: derive only visible, approved state, with stable UIDs.
- `get_available_actions(game, selection)`: query current legality using existing rules methods; never recalculate gameplay rules in widgets.
- `dispatch_action(action_id, target_uid, payload)`: translate an input into one existing Game method; verify current phase and validity.
- `consume_events()`: present existing game events without replaying or mutating their effects.
- `request_refresh()`: reconcile widgets with the latest authoritative state.

These are conceptual contracts, **not approved method signatures**.

## Critical cases to test
- Pending DISCARD / choose-one decisions interrupting response or card resolution.
- TRACE-driven ICE insertion and shifting ICE arrays.
- Hidden VOID subroutines and observational previews.
- Free-break limits, boosts, break targeting, and phase changes.
- Drag/drop target previews versus actual actions.
- Response animation ordering and reduced-motion mode.
- SIGNAL-001 third-Signal-barcode reveal, approved copy and ’Pelago restrictions.
- Persistent UID for duplicated card IDs, COMPILED cards, and grafts.

## Acceptance criteria
No presentation component writes authoritative Game fields directly; every player action resolves exactly once; test fixtures can reproduce the same game outcome with effects on or off; hidden data is never displayed prematurely.
