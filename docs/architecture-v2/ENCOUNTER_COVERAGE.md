# Encounter coverage: prototype → Architecture V2 (ARCH-V2-005)

Every element the Build 12 encounter shows, and where it lives on the V2 encounter screen. Generated from `godot/tests/arch_v2_coverage.json` by `tools/arch_v2_coverage_md.py`; do not edit by hand. `godot/tests/test_arch_v2_coverage.gd` fails if a BUILT or PLACEHOLDER row has no node on the V2 screen, or if this file and the JSON disagree.

**Totals:** BUILT 43 · PLACEHOLDER 1 · BATCH3 12 · BATCH4 5 · OPEN 0 · OUT 2 · 63 rows.

| Status | Meaning |
|---|---|
| BUILT | On the V2 screen and wired to real state |
| PLACEHOLDER | On the V2 screen; content waits on another system |
| BATCH3 | Planned for Batch 3 |
| BATCH4 | Planned for Batch 4 (integration / presentation) |
| OPEN | Needs a designer decision |
| OUT | Outside the encounter slice |

## Header

| ID | Element | Prototype source | V2 node | Status | Next | Note |
|---|---|---|---|---|---|---|
| H01 | Brand mark: all-seeing eye (replaces the PANOPTICON plate) | encounter.gd top bar | `Eye` | BUILT | — | Drawn eye until chassis/V2_EYE.png lands (ARCH-V2-006a). |
| H02 | Turn counter | build_node_plate / TURN plate | `Turn` | BUILT | — |  |
| H03 | Whose turn (phase) | main phase label | `Phase` | BUILT | — | Half width (ARCH-V2-005). |
| H04 | TRACE counter and bar | build_trace_plate | `Trace` | BUILT | — | Half width; 10 cells of 2 TRACE (ARCH-V2-005). |
| H05 | CAPS slots (3) | build_cap_rack | `CapRack` | PLACEHOLDER | CAPS inventory in the rules engine (deferred beyond the slice) | Empty slots; fills from game.caps when it exists (ARCH-V2-005). |
| H06 | PROTOCOL rack | ticker rack text | `ProtocolRack` | BUILT | — | 3 slots, live from game.rack; more shows +n (ARCH-V2-005). |
| H07 | Ghostware rail (any number, ORIGIN first) | build_ghost_rail | `GhostReel` | BUILT | — | One visible, up/down arrows; hover shows text and art (ARCH-V2-006b). |
| H08 | Strike lamps (0-3) and LOCKDOWN | build_strike / strike lamps | `Eye` | BUILT | — | Three lamps under the eye; LOCKDOWN all red with a lock (ARCH-V2-006h). Flyout: R06. |
| H09 | HOSTILE REVEAL (alarm lamp) | reveal_percent / alarm housing | `Eye` | BUILT | — | Eye lens cool green → neon red with the reveal (ARCH-V2-006c). Art reveal: I13/F09. |
| H10 | LAYER count and layer CRED reserve | build_node_plate, RESERVE dial | `LayerMark` | BUILT | — | Ledger at the left end of the rail: LAYER hamburger, CRED, layer CRED (ARCH-V2-006d). |
| H11 | CRED | CRED/RAM row | `CredValue` | BUILT | — | New CRED icon; red marching ants run left on extraction, then the value counts up (ARCH-V2-006d). |
| H12 | Corporation ad plate / sign | CorporateDisplay | `AdPlate` | BUILT | — |  |
| H13 | Graffiti decal (ADP) | DecalPlate, graffiti_label | — | BATCH4 | C06 CorporationPresentation |  |

## ICE

| ID | Element | Prototype source | V2 node | Status | Next | Note |
|---|---|---|---|---|---|---|
| I01 | Avatar with moods | FriendlyMascot | `Ice_*` | BUILT | — |  |
| I02 | Nameplate | console_heading | `Ice_*` | BUILT | — | Drawn by IcePanel. |
| I03 | Type badge (FORTRESS/TUMBLER/VOID) | scan_tag | `Ice_*` | BUILT | — | Drawn by IcePanel; hover per ARCH-V2-003j. |
| I04 | STR medallion | scan_tag | `Ice_*` | BUILT | — | Number only (ARCH-V2-003k). |
| I05 | Subroutine keys and states | IceKey, key_wrapper | `Key_S*` | BUILT | — | Includes DEADLOCK, BOOTING, hidden, broken. |
| I06 | TUMBLER reel / face-down slots | build_key reel | `Reel` | BUILT | — |  |
| I07 | PASSIVE plate | PASSIVE plate | `Ice_*` | BUILT | — | Status strip drawn by IcePanel. |
| I08 | Speech bubble (ADP-2b hesitation) | update_hesitation | `Bubble` | BUILT | — |  |
| I09 | Key tips (HOVER-001) | show_key_tip | `KeyInspector` | BUILT | — |  |
| I10 | Virus counters on ICE (WORM etc.) | scan_tag virus row | — | BATCH3 | C08 add-on: counter chips on the panel | Shown only inside the CULL choice today. |
| I11 | Break feedback (cost spent) | show_break_feedback | — | BATCH3 | C16 / flyouts |  |
| I12 | Strike overlay and lethal flash | build_strike, strike_flash | — | BATCH3 | M06 flyouts from Game.events |  |
| I13 | TRACE pixel steps (PIXEL-TRACE-001) | update_pixel | — | BATCH4 | C06 presentation |  |
| I14 | Corporation console colour | console_tint_material | — | BATCH4 | C06 CorporationPresentation |  |

## Response

| ID | Element | Prototype source | V2 node | Status | Next | Note |
|---|---|---|---|---|---|---|
| R01 | NEXT RESPONSE | per-ICE plates | `ResponseRail` | BUILT | — | Shared rail, provisional (ARCH-V2-003e). |
| R02 | Step-by-step Corporation Response | main._play_response | `ResponseRail` | BUILT | C03 ResponseSequencer port in Batch 3 | Minimal stand-in today. |
| R03 | PARTING SHOT after BREACH (PT11-UI 1) | PULP INCOMING row | `MeterPULP` | BUILT | — | PULP meter reads PARTING SHOT after BREACH; END TURN hover states it; rail drops DEADLOCKs. |
| R04 | Encounter log | log_text | `RailLog` | BUILT | — | Hover the rail for the latest lines; click pins the full log; Esc closes (ARCH-V2-006i). |
| R05 | Phase flyouts | none | `EventFlyout` | BUILT | — |  |
| R06 | Event flyouts from Game.events (EV-xx) | toasts, punch arrival | `EventFlyout` | BATCH3 | M06: drive from Game.events | Widget exists; only phase announcements wired. |

## Rig

| ID | Element | Prototype source | V2 node | Status | Next | Note |
|---|---|---|---|---|---|---|
| G01 | CRT program screen | build_rig | `RigBay` | BUILT | — |  |
| G02 | Program cartridges | build_cartridges | `RigBay` | BUILT | — |  |
| G03 | BOOST / UNINSTALL / EJECT | BoostButton, SmashGrabCache, UnloadButton | `ProgramScreen` | BUILT | — |  |

## Hand

| ID | Element | Prototype source | V2 node | Status | Next | Note |
|---|---|---|---|---|---|---|
| C01 | Fanned hand | FriendlyHand | `HandFan` | BUILT | — |  |
| C02 | Card inspector (HOVER-001) | big_card | `KeyInspector` | BUILT | — |  |
| C03 | Targeting (CHOOSE AN ICE) | drop on ICE | `TargetPlaque` | BUILT | — |  |
| C04 | Drag cards to play (PT11-UI 2) | FriendlyDropTarget | — | BATCH3 | C10 drag path | Click-to-play is built; drag-to-break from the rig is built. |
| C05 | Dim unplayable cards (PT11-UI 4) | FriendlyCard | `HandFan` | BUILT | — |  |
| C06 | CACHED corner icon (CACHE-001, #17) | cache glow | — | BATCH3 | C11 CardView corner icon |  |
| C07 | Choice overlays | main._overlay_options | `ChoiceOverlay` | BUILT | — | PATIENT ZERO variant not yet mapped. |
| C08 | Toggle back to the board during a discard (#15) | none | — | BATCH3 | C15 |  |
| C09 | Deck and discard viewers | DECK / COVERAGE buttons | — | BATCH3 | C16 inspect |  |

## Vitals

| ID | Element | Prototype source | V2 node | Status | Next | Note |
|---|---|---|---|---|---|---|
| V01 | VITAE | vital_row | `MeterVITAE` | BUILT | — |  |
| V02 | BANDWIDTH | vital_row | `MeterBW` | BUILT | — |  |
| V03 | RAM | CRED/RAM row | `MeterRAM` | BUILT | — |  |
| V04 | SHIELD | vital_row | `MeterSHIELD` | BUILT | — |  |
| V05 | PULP INCOMING | vital_row | `MeterPULP` | BUILT | — |  |
| V06 | NEXT DRAW estimate | vital_row | — | BATCH3 | C13 PlayerHUD |  |
| V07 | CORTEX and BW drain | CRT status | `Effects` | BUILT | — |  |
| V08 | Deck / discard / burned counts | deck/discard wells | `Counters` | BUILT | — |  |

## Flow

| ID | Element | Prototype source | V2 node | Status | Next | Note |
|---|---|---|---|---|---|---|
| F01 | END TURN | END TURN box | `EndTurn` | BUILT | — |  |
| F02 | Leave Node / END RUN | END RUN tray button | — | OUT | Only on the menu of a CAP or card that allows leaving (ARCH-V2-006e) | No permanent button on the encounter screen. |
| F03 | NUL/REM lines | NulRemNote | — | BATCH3 | Voice; text on hover over two speaker grilles: below the left avatar and below the right ICE keys (ARCH-V2-006f) | No ticker; keeps the screen clean. |
| F04 | Reduced motion setting | motion button | — | BATCH3 | C16 settings | Sandbox flag only. |
| F05 | VOICE / M mute | VoiceButton | — | BATCH3 | C16 settings |  |
| F06 | KEY LEGEND | LegendButton | `Eye` | BUILT | — | Legend, tier, Node and layer on the eye hover (ARCH-V2-006g). |
| F07 | Outcome (BREACH, flatline) | main overlays | `Outcome` | BUILT | — | Stand-in banner. |
| F08 | Punch-card holder (SIGNAL-001) | update_punch_holder | — | BATCH4 | C05 integration |  |
| F09 | Bleed and low-VITAE warning (ADP-1) | advance_bleed | — | BATCH4 | C06 presentation |  |
| F10 | Reward, map and event screens | main._overlay_* | — | OUT | C17, outside the encounter slice |  |
