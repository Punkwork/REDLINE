# PANOPTICON — Static source audit and Claude Code review package
**Decision:** ARCH-V2-001 · **Date:** 2026-11-23 · **Status:** SOURCE-INSPECTED / PROPOSALS NOT APPROVED

## Method and limitations
Inspected source files directly through the GitHub connector on `architecture-v2`, including `godot/project.godot`, `Main.tscn`, the principal UI scripts, `game.gd`, `cards.gd`, `ice.gd`, and `.github/workflows/godot-validation.yml`. This is a **static inspection**, not a Godot import, test run, screenshot review or Windows playtest. File lengths and examples describe the inspected revision; Claude Code must recheck after pulling.

## Verified source observations
| Source | Observed facts | Architectural implication |
|---|---|---|
| `godot/project.godot` | Godot feature flag 4.3, GL Compatibility, entrypoint `res://scenes/Main.tscn`, 1600×1000 viewport with `canvas_items` stretch and `expand` aspect | Keep project settings unchanged during first migration |
| `godot/scenes/Main.tscn` | Single root `Control` with `scripts/ui/main.gd`; no child scene composition in the file | Scene composition will require new authored UI boundaries |
| `godot/scripts/ui/main.gd` | ~2,038 lines; constructs shell, HUD, ICE, hand, overlays and settings; `refresh()` at ~511; response orchestration `_play_response()` at ~399; card and ICE actions at ~467–493; installs `FriendlyEncounter` at ~2014 | High-coupling controller and legacy widgets; do not replace wholesale |
| `godot/scripts/ui/friendly_lie/encounter.gd` | ~1,975 lines; `sync(model: Game)` at ~323; `build_ice()` ~689, `build_hand()` ~750; directly queries Game, calls UI controller methods, and builds presentation | Biggest candidate for staged extraction, but first document existing ownership and state lifecycle |
| `godot/scripts/ui/friendly_lie/card.gd` | ~891 lines; `FriendlyCard` extends `Control`, includes layout, glow, full rules, drag/input, concept face | Reuse behavior after review rather than recreating card interactions |
| `godot/scripts/ui/friendly_lie/hand.gd` | 68 lines; `FriendlyHand` already handles fan, focus and keyboard/wheel browsing | Good candidate for preservation behind a scene wrapper |
| `godot/scripts/ui/friendly_lie/program_bay.gd` | 28 lines; checks `CardDB.def` and `game.can_play`; drop calls controller and refresh | Input is partially componentized already; preserve legality delegation |
| `godot/scripts/ui/friendly_lie/drop_target.gd` | 66 lines; stores ICE dictionary reference, resolves current array index with `enc.ice.find(ice_ref)`, calls `break_info`/`break_sub`, or plays targeted card | Stable ICE reference and exact-once action/refresh are critical |
| `godot/scripts/core/game.gd` | ~2,207 lines; `CORE_LOOP := true`; `new_run`, `enter_node`, `can_play`, `play_card`, `end_turn`, `response_step`, `response_finish`, `choose`, `break_info`, `break_sub` exist | Preserve authoritative state/action semantics; avoid simultaneous core refactor |
| `godot/scripts/core/cards.gd` | CardDB definitions are dictionaries with compiled-card lookup | Do not duplicate gameplay values in presentation Resources |
| `godot/scripts/core/ice.gd` | IceDB includes HALCYON ICE definitions and a four-row route, with TUMBLER rotating subroutine pools | View must reflect active slots/visibility, not just static ICE definitions |
| `.github/workflows/godot-validation.yml` | Pinned Godot 4.3 Linux editor; imports and runs `test_game.gd`, `test_adp.gd`, `test_signal_carbon.gd`; screenshot fixture stage **skips all legacy screenshots when `CORE_LOOP := true`**; Windows export runs only on `release` | Major coverage gap: green CI may not validate current encounter visuals or input. Export ≠ Windows playtest |

## Risk register — source-grounded
| Priority | Risk | Evidence | Recommended mitigation |
|---|---|---|---|
| P0 | Existing screenshot fixtures are skipped in the active core-loop configuration | CI conditional checks `^const CORE_LOOP := true`; Game sets it true | Claude Code must report skipped fixtures and propose a small current-loop smoke/interaction fixture before claiming UI parity |
| P0 | Duplicate or reordered gameplay resolution during animation | `main.gd` orchestrates response; Game has separate `response_step` and `response_finish` | Map exact call sequence and compare deterministic before/after state; no new async resolution path without tests |
| P0 | ICE target identity breaks when arrays mutate | `drop_target.gd` keeps `ice_ref` and uses `enc.ice.find(ice_ref)` | Retain reference-based lookup; explicitly handle stale refs and TRACE insertion |
| P1 | Two large code-built UI controllers complicate migration | `main.gd` and `encounter.gd` together exceed 4,000 lines | Extract one self-contained presentation slice behind existing controller; keep legacy path as fixture |
| P1 | Direct controller and model references are pervasive in widgets | `FriendlyEncounter.ui`, `FriendlyEncounter.game`, `FriendlyHand` calls `card.view.ui._on_card` | Audit actual call sites before proposing signals/adapters; don't introduce global event bus |
| P1 | Runtime content visibility and copy approval could be bypassed by new views | `game.response_preview()`, existing copy filters and hidden subroutine semantics in architecture docs | Test visible-state filtering and reveal guards in new rendering path |
| P1 | Existing visual/layout code has hardcoded dimensions | `HAND_RECT`, `ICE_X`, `ICE_SCALE` and fixed positions in `encounter.gd` | Keep 1600×1000 reference first; test stretch, clipping, hitboxes and input |
| P2 | Premature conversion to `.tres` duplicates card/ICE data | CardDB/IceDB definitions in GDScript | Pilot cosmetic-only corporation profile first |

## Proposed minimum first-milestone file structure (NOT APPROVED)
```text
godot/
  scenes/
    Main.tscn                     # keep existing entrypoint initially
    architecture_v2/
      EncounterScreen.tscn        # first isolated scene; may wrap existing controls
      ICEPanel.tscn               # candidate only after owner audit
  scripts/
    core/                         # unchanged in first milestone
    ui/
      main.gd                     # existing controller retained
      friendly_lie/               # preserved legacy implementation
      architecture_v2/
        encounter_screen.gd       # binds view to existing Game/controller
        ice_panel.gd              # presentation only
  resources/
    visual/                       # optional, after schema review
  tests/
    test_arch_v2_parity.gd        # candidate deterministic contract test
    shot_arch_v2_encounter.gd     # candidate current CORE_LOOP interaction fixture
```
This is a **candidate dependency sketch**, not an instruction to create these files. Exact placement, naming and scope require Claude Code review and designer approval.

## First-encounter dependency and action sketch
```text
Main (existing owner of Game and response coroutine)
  └── EncounterScreen (candidate presentation boundary)
        ├── ICEPanel (display; requests action through controller)
        ├── FriendlyCard / FriendlyHand (reuse after audit)
        ├── ProgramBay / DropTarget (reuse legality checks)
        └── Status / choice / log (read-only view)
Game (existing authority) ← controller dispatches one validated action
Game events/state → refresh/sync → presentation
```
The key decision is whether to wrap existing `FriendlyEncounter` first or extract `ICEPanel` first. Source inspection suggests **wrapping and testing the current encounter path before splitting its complex internals**, but this is a recommendation, not an approval.

## Regression coverage matrix (proposed)
| Behavior | Existing evidence | Required additional check |
|---|---|---|
| Game action legality and resources | `test_game.gd` invoked by CI; individual assertions not audited here | Pin exact seeded action sequences and state diffs |
| ADP effects and copy gates | `test_adp.gd` and `test_signal_carbon.gd` invoked | Verify no leak through new UI |
| ICE target drag/drop | Existing `drop_target.gd`; legacy screenshot fixtures conditionally skipped | New active-core-loop drag and click fixture |
| Hand selection / keyboard | `FriendlyHand` implements arrow/enter/wheel | Test after scene wrapping |
| Response step / finish | Game and Main separate functions | Test exact-once and reduced-motion parity |
| ICE insertion/reordering | Existing reference lookup | Stale reference and TRACE insertion fixture |
| Corp visual reuse | Existing `CorporationSkin` path in encounter | Two skins using one encounter scene, later milestone |
| Windows gameplay | Release-only Windows export in CI | Actual Windows interaction playtest, explicitly separate |

## Specific tasks for Claude Code (Phase 0 and 1)
1. Record exact `origin/main` SHA, `architecture-v2` SHA, Godot binary/version, OS and renderer; verify actual test results. Do not infer from source inspection.
2. Review full `Game` response and choice paths, `Main._play_response`, `FriendlyEncounter.sync`, `drop_target` and current test assertions; produce a call graph with real signatures.
3. Report CI screenshot skips in the active CORE_LOOP mode; propose a new current-loop fixture and verify whether any current screenshot tests run.
4. Validate actual scene/component boundaries and resource schema against these proposals; label every design decision PROPOSED pending designer review.
5. Select and justify one representative encounter for parity testing; specify reproducible seed, actions, expected state, and screenshots.
6. Update `VALIDATION.md` with evidence; propose baseline tag only if verification succeeds; report any skipped tests.
7. Commit documentation updates on `architecture-v2`, update HANDOFF and development log, and STOP for designer approval before implementation.

## Unverified or deliberately not claimed
- No tests or Godot binaries were executed in this audit.
- No baseline SHA or tag was established.
- No actual screenshots, exports, or Windows UI runs were reviewed.
- No scene implementation, gameplay refactor or architecture proposal was approved.
