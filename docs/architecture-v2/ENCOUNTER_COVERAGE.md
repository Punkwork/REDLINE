# Encounter coverage: prototype → Architecture V2 (ARCH-V2-005)

Every element the Build 12 encounter shows, and where it lives on the V2 encounter screen. Generated from `godot/tests/arch_v2_coverage.json` by `tools/arch_v2_coverage_md.py`; do not edit by hand. `godot/tests/test_arch_v2_coverage.gd` fails if a BUILT or PLACEHOLDER row has no node on the V2 screen, or if this file and the JSON disagree.

**Totals:** BUILT 61 · PLACEHOLDER 0 · BATCH3 0 · BATCH4 0 · OPEN 0 · OUT 3 · 64 rows.

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
| H05 | CAPS slots (3) | build_cap_rack | `CapRack` | BUILT | Uncommon and rare CAPS; Uplink purchase; BREACH drop (UPL-001) | Common CAPS from game.caps with the designer vials; click injects, CRACKER aims (CAPS-TEST-001). |
| H06 | Active PROTOCOLS (paperclip note) | ticker rack text | `ProtocolNote` | BUILT | — | UI-PROTOCOL-001: one icon per card in game.rack, any number, scrolls vertically; hover opens the shared inspector. Supersedes the 3 header slots (ARCH-V2-005). |
| H07 | Ghostware rail (any number, ORIGIN first) | build_ghost_rail | `GhostReel` | BUILT | — | One visible, up/down arrows; hover shows text and art (ARCH-V2-006b). |
| H08 | Strike lamps (0-3) and LOCKDOWN | build_strike / strike lamps | `Eye` | BUILT | — | Three lamps under the eye; LOCKDOWN all red with a lock (ARCH-V2-006h). Flyout: R06. |
| H09 | HOSTILE REVEAL (alarm lamp) | reveal_percent / alarm housing | `Eye` | BUILT | — | Eye lens cool green → neon red with the reveal (ARCH-V2-006c). Art reveal: I13/F09. |
| H10 | LAYER count and layer CRED reserve | build_node_plate, RESERVE dial | `LayerMark` | BUILT | — | Ledger at the left end of the rail: LAYER hamburger, CRED, layer CRED (ARCH-V2-006d). |
| H11 | CRED | CRED/RAM row | `CredValue` | BUILT | — | New CRED icon; red marching ants run left on extraction, then the value counts up (ARCH-V2-006d). |
| H12 | Corporation ad plate / sign | CorporateDisplay | `AdPlate` | BUILT | — |  |
| H13 | Graffiti decal (ADP) | DecalPlate, graffiti_label | — | OUT | Removed for now (designer 2026-11-26 22:12, ARCH-V2-007f) | Code kept behind SHOW_GRAFFITI. |

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
| I10 | Virus counters on ICE (WORM etc.) | scan_tag virus row | `Ice_*` | BUILT | — | Strain chips (initial + count) on the status strip; rule on hover. Checked in test_arch_v2_batch3. |
| I11 | Break feedback (cost spent) | show_break_feedback | `Ice_*` | BUILT | — | "−n BW" rises from the key a paid break used. Checked in test_arch_v2_batch3. |
| I12 | Strike overlay and lethal flash | build_strike, strike_flash | `Flash` | BUILT | — | Red wash on strikes (none under reduced motion); MASK OFF and LOCKDOWN flyouts. No TRACE STRIKE banner (ARCH-V2-006j); LETHAL has no wash or flyout, only its lens on the ICE (UI-TYPO-002). |
| I13 | TRACE pixel steps (PIXEL-TRACE-001) | update_pixel | `Ice_*` | BUILT | — | Room and avatar drop to the step with Build 12 transition; keys, plates, bubble and text stay sharp (ARCH-V2-007b). |
| I14 | Corporation console colour | console_tint_material | `Ice_*` | BUILT | — | console_tint on the window enamel (IRONWATCH navy, LUCIDA lilac); mostly behind the room now (ARCH-V2-007b). |
| I15 | Corporation room behind the ICE (painted backgrounds) | concept_backgrounds, add_backdrop | `Room` | BUILT | — | Through the ICE windows as one continuous room; HOSTILE shows through with the reveal (ARCH-V2-007a). |

## Response

| ID | Element | Prototype source | V2 node | Status | Next | Note |
|---|---|---|---|---|---|---|
| R01 | NEXT RESPONSE | per-ICE plates | `ResponseRail` | BUILT | — | Shared rail, provisional (ARCH-V2-003e). |
| R02 | Step-by-step Corporation Response | main._play_response | `ResponseSequencer` | BUILT | — | C03 ported: Build 12 pacing (5 s shared), holds for strike/LOCKDOWN flyouts, one call per step, cancel-safe; effect sounds and PULP shake. |
| R03 | PARTING SHOT after BREACH (PT11-UI 1) | PULP INCOMING row | `MeterPULP` | BUILT | — | PULP meter reads PARTING SHOT after BREACH; END TURN hover states it; rail drops DEADLOCKs. |
| R04 | Encounter log | log_text | `RailLog` | BUILT | — | Hover the rail for the latest lines; click pins the full log; Esc closes (ARCH-V2-006i). |
| R05 | Phase flyouts | none | `EventFlyout` | BUILT | — |  |
| R06 | Event flyouts from Game.events (EV-xx) | toasts, punch arrival | `EventFlyout` | BUILT | — | RUSTLER TURN, CORP COUNTERMEASURE, DEADLOCK BREACHED, LOCKDOWN, MASK OFF, PARTING SHOT, RESERVE EXTRACTED, each with its UI-TYPO-002 treatment (1.15–1.7 s targets, UI Bible §2b); queued, max 3. LETHAL is a lens on the affected ICE, not a flyout. Wording APPROVED. |

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
| C04 | Drag cards to play (PT11-UI 2) | FriendlyDropTarget | `HandFan` | BUILT | — | Click plays on release; drag: untargeted above the tray, targeted onto an ICE; one call each. |
| C05 | Dim unplayable cards (PT11-UI 4) | FriendlyCard | `HandFan` | BUILT | — |  |
| C06 | CACHED corner icon (CACHE-001, #17) | cache glow | `HandFan` | BUILT | — | Cyan disc on the art frame: ∞ (the encounter) or turns left; hover explains. |
| C07 | Choice overlays | main._overlay_options | `ChoiceOverlay` | BUILT | — | All variants incl. PATIENT ZERO (on the ICE windows, ARCH-V2-007c). |
| C08 | Toggle back to the board during a discard (#15) | none | `ChoiceOverlay` | BUILT | — | SHOW BOARD / BACK TO <choice> on every choice; kept across refreshes. |
| C09 | Deck and discard viewers | DECK / COVERAGE buttons | `PileView` | BUILT | — | Click a counter: deck (sorted by name, order hidden), discard, burned. Esc or Close. |

## Vitals

| ID | Element | Prototype source | V2 node | Status | Next | Note |
|---|---|---|---|---|---|---|
| V01 | VITAE | vital_row | `MeterVITAE` | BUILT | — |  |
| V02 | BANDWIDTH | vital_row | `MeterBW` | BUILT | — |  |
| V03 | RAM | CRED/RAM row | `MeterRAM` | BUILT | — |  |
| V04 | SHIELD | vital_row | `MeterSHIELD` | BUILT | — |  |
| V05 | PULP INCOMING | vital_row | `MeterPULP` | BUILT | — |  |
| V06 | NEXT DRAW estimate | vital_row | `Counters` | BUILT | — | On the deck counter hover. |
| V07 | CORTEX and BW drain | CRT status | `ProtocolNote` | BUILT | — | Stamps pinned at the right end of the Active PROTOCOLS note (UI-PROTOCOL-001). |
| V08 | Deck / discard / burned counts | deck/discard wells | `Counters` | BUILT | — |  |

## Flow

| ID | Element | Prototype source | V2 node | Status | Next | Note |
|---|---|---|---|---|---|---|
| F01 | END TURN | END TURN box | `EndTurn` | BUILT | — |  |
| F02 | Leave Node / END RUN | END RUN tray button | — | OUT | Only on the menu of a CAP or card that allows leaving (ARCH-V2-006e) | No permanent button on the encounter screen. |
| F03 | NUL/REM lines | NulRemNote | `SpeakerL` | BUILT | — | Voice plus two grilles (below the left avatar, below the right ICE); hover shows the last lines (ARCH-V2-006f). |
| F04 | Reduced motion setting | motion button | `Stage` | BUILT | — | Read from the app settings (redline_flags.json); flyouts, ants, wash, shake, fan and eye honour it. The toggle lives in the app settings menu. |
| F05 | VOICE / M mute | VoiceButton | `SpeakerR` | BUILT | — | Click either grille or press M; saved to the app settings. |
| F06 | KEY LEGEND | LegendButton | `Eye` | BUILT | — | Legend, tier, Node and layer on the eye hover (ARCH-V2-006g). |
| F07 | Outcome (BREACH, flatline) | main overlays | `Outcome` | BUILT | — | Stand-in banner. |
| F08 | Signal barcode holder (SIGNAL-001, SIGNAL-002; was the punch-card holder) | update_punch_holder | `Eye` | BUILT | — | On the eye hover (designer), "Signal barcodes n / 3"; a new barcode drops onto the eye (ARCH-V2-007c). Barcode art PROPOSED (SIGNAL-002 UI issue): held barcodes overlay into the Signal. |
| F09 | Bleed and low-VITAE warning (ADP-1) | advance_bleed | `MeterVITAE` | BUILT | — | Bleed drives reveal, music, pixel steps, graffiti; VITAE meter pulses red at a quarter or less (ARCH-V2-007c). |
| F10 | Reward, map and event screens | main._overlay_* | — | OUT | C17, outside the encounter slice |  |
