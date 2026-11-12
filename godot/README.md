# REDLINE — Godot Training Node (Build 01)

Open this directory in Godot 4.x using project.godot.

## Imported from authoritative frozen design
- Source commit: 03fc312e635abb34dbca8be2f610c737ffedce90
- data/training_node.json: 12-card Generalist deck, 6 named ICE with ordered subroutines, 3 layers, CRED reserves 10/15/25 and full-extraction bonuses 1/2/3.
- Current WALL Icepick base STR 1 supersedes older STR 0 references.
- rules_engine.gd: initial helpers for PULP, SyN chosen discard with overflow Vitae damage, BW/RAM spending and CRED extraction.

## NOT YET PLAYABLE
The main scene currently inspects the encounter manifest. It is not a combat simulation.
Do not interpret stepping through ICE as BREACH or successful extraction.

## Missing runtime systems (engineering work, not requests to rebalance)
1. Game state, seeded deck shuffle/draw/discard/burn and persistent installed card slots.
2. Complete Rustler and Corporation turn phases, including end-turn triggers and BW reset.
3. Card installation and actions, BW/RAM capacity, ICE-specific Icepick boosts and subroutine breaking.
4. ICE strength modifiers, PROBE, CLOAK WATCHDOG reactions, OVERCLOCK buff, and duration resets.
5. PULP prevention, SyN selection UI, SYN BUFFER, TRACE, DEADLOCK and BREACH.
6. Encounter-to-layer transitions, reward payout, extraction and node completion.
7. UI card selection, targeting, drag controls, status display and detailed log.
8. Automated tests and real Godot execution/playtesting.

## Design details to verify against complete authoritative rule text
- Exact initial Rustler BW/RAM/Vitae/TRACE/hand-size values and refill timings.
- TRACE resolution thresholds and DEADLOCK/BREACH resolution sequencing.
- SYN BUFFER RAM requirement is explicitly provisional in the design freeze.
- GHOST SIGNAL is a working name, not a gameplay blocker.
- All edge-case triggers, discard/burn recycling and post-encounter cleanup.

Do not invent values or rebalance before playtesting.
