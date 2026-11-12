# REDLINE — Godot Training Node

Open this directory in Godot 4.x (Import > project.godot).

## Current status
This is a runnable **project scaffold and encounter inspector**, NOT a playable
Training Node. It does not yet implement turns, deck play, ICE resolution,
rewards or extraction. The manifest intentionally leaves frozen card and ICE
values blank rather than inventing them.

## Layout
- scenes/main.tscn — entry scene
- scripts/main.gd — UI and layer inspection
- scripts/rules_engine.gd — initial pure rules helpers (PULP, SYN, NEURAL, TRACE, BW/RAM)
- data/training_node.json — authoritative values pending import

## Next engineering gates
1. Import and validate every frozen card, ICE and subroutine.
2. Add deterministic phase machine, card actions and ICE encounter resolution.
3. Wire BW/RAM, Icepicks, TRACE, DEADLOCK, damage, extraction and rewards.
4. Add automated regression tests and full-run playtesting.

Design freeze reference: 03fc312. Do not rebalance during implementation.
