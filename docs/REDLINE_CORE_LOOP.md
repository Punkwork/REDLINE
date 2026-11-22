# PANOPTICON — CORE LOOP (stripped test build, STRIP-001)
**Date:** 2026-11-21 · **Status:** decisions APPROVED by the designer in a Claude session on 2026-11-21 (quoted in the log). ICE values and the reward pool are working values for this test (Claude).

**Why:** Playtest 7 had no tension: lower STR, install, break the DEADLOCK, end turn, often with BW left over. Too many systems sat on top of a core that isn't fun yet. This build strips the game to **break, defend, build**. Where this doc conflicts with other docs, it wins **for the stripped build only** (`Game.CORE_LOOP = true`). Setting the flag to false restores the full-game rules; the old ICE values are in git history before this change.

## 1. Decisions
| ID | Decision |
|---|---|
| BW-001 | BW refills to **3** each turn (was 4). DRAW stays 6. |
| PROBE-001 | PROBE costs **0 BW** (−2 STR for the encounter). |
| PROBE-003 | Each PROBE on the **same ICE in the same turn** costs 1 BW more than the last (0, 1, 2…). Counts every copy, resets each turn, PROBE only. The starter keeps **3 PROBEs** (PROBE-002 reversed). "The deeper you probe, the costlier it gets." |
| BREACH-001 | **Parting shot:** at END TURN after a BREACH, every unbroken subroutine that is active (TUMBLER slot, FORTRESS) or revealed (VOID) fires once, left to right, top to bottom. Not a Corporation Response: nothing rotates or advances. |
| TURN-001 | End of turn: end-of-turn effects → discard non-CACHED cards → **draw the next hand (6)** → Corporation Response → next turn. |
| BURST-001 | **BURST** 3 BW: gain 5 BW. Each play costs that copy 1 more BW for the rest of the encounter. Per copy; resets each encounter; not BURNED; no BW cap. |
| STR-001 | ICE STR **+2**; starter Icepicks all **STR 2, boost 1 BW → +1**; fallback STR limits +2; DEEP PROBE **−5**. |
| CACHE-001 | CACHE shows a duration in a card corner: ∞ = the encounter, or N turns. |
| STRIP-001 | This build: Generalist only; TUMBLER rotation with no waiting floor (no BOOTING); VOID subroutines start face-down and a **PROBE reveals the top one**; fixed PULP; no passives, curves, rolls, CORTEX, bloat tax, COMPILE, viruses or other Rustlers. Basic Extractor and CORTEX BUFFER stay as inert cards. Card removal: DECOMPILE on the reward screen. |

## 2. ICE in the build (`godot/scripts/core/ice.gd`)
| ICE | Type | STR | Subroutines |
|---|---|---|---|
| ACCEPT ALL (Opening support) | TUMBLER, 1 slot | 6 | PULP 2 · PULP 1 · PULP 2 |
| REJECT ALL (Opening main) | TUMBLER, 1 slot | 6 | PULP 2 · DEADLOCK · PULP 2 |
| AUTO-RENEW | FORTRESS | 7 | PULP 1 · PULP 1 · PULP 2 · DEADLOCK |
| CAPTCHA | TUMBLER, 2 slots | 6 | DISCARD 1 · DEADLOCK · TRACE 2 · DEADLOCK · TRACE 2 |
| COOKIE WALL | FORTRESS | 7 | PULP 1 · TRACE 1 · PULP 2 · DEADLOCK |
| CONSENT FORM | TUMBLER, 2 slots | 6 | TRACE 1 · DEADLOCK · PULP 2 · DEADLOCK |
| DOORBELL CAM | VOID | 5 | PULP 3 · DEADLOCK |
| TERMS OF SERVICE | FORTRESS | 9 | PULP 3 · INSERT 1 SPAM → discard · PULP 3 · DEADLOCK |
| HOUSE CALL (Black) | VOID | 9 | PULP 4 · PULP 4 |

COOKIE BANNER is about PULP, not TRACE (designer). The map is unchanged (one layer per Node, PACE-008).

## 3. Reward pool (`CardDB.CORE_POOL`)
BATTERING RAM, JACKHAMMER, PASSKEY, RAINBOW TABLE, TASER, STUN BATON, SKELETON KEY, MULTITOOL, ADAPTER, DEEP PROBE, STRESS TEST, BALANCED LOAD, HARDENED SHELL, FLINCH, MIRROR, SURGE PROTECTOR, SCRUB, PROXY CHAIN, BURN NOTICE, SPAM FILTER, UNINSTALLER, PATCH KIT, DEFRAG, STIM PATCH, BURST, CO-PROCESSOR, RAM UPGRADE, FIELD KIT, TOOLBELT, READY STANCE. (KEYLOGGER, STASH, QUANTUM CORE, HOT SWAP and JACK OF ALL TRADES are not in the slice's card data yet.)

## 4. Bot sim checks
`SIM=1` prints a `core-loop` line: unspent BW and playable cards left per turn (with and without the inert cards), threat subroutines broken before each BREACH, parting-shot subroutines and VITAE, and the highest BW reached with BURST. Results are in the development log.

The playtest sheet is `docs/REDLINE_CORE_LOOP_CHECKLIST.md` (bundled with the build).
