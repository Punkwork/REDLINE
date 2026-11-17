# Ice Passive Abilities
**Date:** 2026-11-13 · John Stevers
**Source:** project copy of the Claude Doc https://claude.ai/artifact/6dDZTwDj8Hv9RkhJbucrd6 (rev 15, copied 2026-11-15). The Doc is the live version; edit it there and re-copy.

All 14 proposed passive abilities are kept for consideration (status: PROPOSED), listed by the ICE type and subtype they belong to. Each one exists to make the Rustler do what they should, not just what they could. The two passives already in the slice, BOOTING and WATCHER (DOORBELL CAM's CLOAK → TRACE), are ranked alongside them for scale.

## How to read the ranking

**Power** is how much the passive helps the corporation in an average encounter, on a 1–5 scale. A negative-feeling passive (RUSTING) still scores 1: it helps the Rustler, but adds a decision.

**Budget cost** is what an ICE gives up to carry the passive, so every ICE of a tier stays roughly equal in threat:

| Power | Budget cost |
|---|---|
| 1 | Nothing, or +1 STR |
| 2 | −1 STR, or a minor subroutine (TRACE 1, PULP 1–2) |
| 3 | One strong subroutine (PULP 4–5, DEADLOCK-adjacent effects) |
| 4 | Two subroutines, or −2 STR and one subroutine |
| 5 | Tier 2 or Black ICE only |

All numbers are working values for playtest.

---

## FORTRESS passives

FORTRESS passives make breaking cost more or change over time; the wall itself stays plain PULP. Subtypes are PROPOSED; their personalities are in the ICE Rules Bible.

### TOLLHOUSE: makes every break cost extra
| Ability | Rule | Power | Watch out for |
|---|---|---|---|
| **TOLL** | Breaking here costs +1 BW, except the DEADLOCK. | 3 | Not with a DETAINER: three BW taxes at once. The DEADLOCK stays exempt. |
| **BACKLASH** | Your first boost against this ICE each turn costs PULP 1. | 2 | Never with HARDENING, which forces a boost every turn. |

### VAULT: must be opened in a set order
| Ability | Rule | Power | Watch out for |
|---|---|---|---|
| **BUNKER** | Can't be broken while the ICE to its left has an unbroken DEADLOCK. | 4 | The left neighbour must show its DEADLOCK from turn 1, or the layer can lock. |
| **SEQUENCED** | Subroutines must be broken left to right; the DEADLOCK comes last. | 3 | FORTRESS or VOID only: on a TUMBLER the next subroutine may be hidden. |

### RATCHET: tightens every turn you stay
| Ability | Rule | Power | Watch out for |
|---|---|---|---|
| **HARDENING** | +1 STR after each Corporation Response (max +3). | 4 | Long encounters. Not with RELAY, BACKLASH or BOOTING. |

### RELIC: an old wall that weakens every turn
| Ability | Rule | Power | Watch out for |
|---|---|---|---|
| **RUSTING** | −1 STR each turn (minimum 0). | 1 | VECTOR's ROT makes it free fast; give a RELIC many PULP subroutines so STR isn't its only threat. |

---

## TUMBLER passives

TUMBLERS hold most of the passives, because they are where the puzzles live. DETAINER is LOCKED (DET-001); the other subtypes are PROPOSED.

### DETAINER: holds you in line by stealing your time
Its S1 is always −1 BW next turn; about 1 TUMBLER in 5; at most 1 per encounter.

| Ability | Rule | Power | Watch out for |
|---|---|---|---|
| **THROTTLE** | Your first card each turn costs +1 BW. | 3 | Stacks with the DETAINER's own −1 BW: on the drained turn you have 3 BW and pay +1 for your first card, so budget it as power 4. Never with TOLL in the encounter. GHOST SIGNAL becomes 3 BW. |

### SWITCHBOARD: routes power to the ICE beside it
| Ability | Rule | Power | Watch out for |
|---|---|---|---|
| **RELAY** *(DEPRECATED 2026-11-17, DEPRECATE-001)* | While this ICE has an unbroken subroutine, the ICE to its right gets +2 STR. | 4 | Two RELAYs stack to +4. Max 1 per encounter; never beside HARDENING. |

### SHELL GAME: hides what it is and what comes next
| Ability | Rule | Power | Watch out for |
|---|---|---|---|
| **SHUFFLE** | The rotation order is random, not a fixed conveyor. | 2 | Removes planning, which works against the design goal. Use rarely, and never with DEADLOCKs hidden in the pool. |
| **CAMOUFLAGE** | STR stays hidden until you hit the ICE with an Icepick or a PROBE. | 2 | Break buttons leak STR through their cost: show "? BW" until revealed. |

### SNARE: touching it is the alarm
| Ability | Rule | Power | Watch out for |
|---|---|---|---|
| **TRIPWIRE** | Breaking any subroutine here adds TRACE 1. | 2 | Helps RIOT, whose cards want high TRACE. Fine, but note it. |

---

## VOID passives

VOID passives make a deadly ICE deadlier when you're careless: noticed, slow, or cornering it. Subtypes are PROPOSED.

### WATCHER: notices you, and gets worse the more it does
| Ability | Rule | Power | Watch out for |
|---|---|---|---|
| **ALARM** | At TRACE 30 or more, this ICE's PULP subroutines deal +2. | 3 | Threshold 30, not 20: strike 1 resets TRACE to 20. Max 1 per encounter. |
| **WATCHER** *(in slice: DOORBELL CAM)* | Whenever you play a CLOAK card: TRACE 1. | 2 | 4 of the Generalist's 12 starter cards are CLOAK, so it taxes their only defence. One per encounter. |

### SIPHON: drains the loot while you're still inside
| Ability | Rule | Power | Watch out for |
|---|---|---|---|
| **SHREDDER** | The CRED reserve loses 3 each turn while this ICE is unbroken. | 2 | Makes the clean-Node bonus near impossible and hits ECHO's extraction builds hardest. Never on a reserve under 10. |

### DEADMAN: fires everything it has left when cornered
| Ability | Rule | Power | Watch out for |
|---|---|---|---|
| **LAST STAND** | When only one unbroken subroutine remains, it fires twice. | 4 | Only on ICE with 3+ subroutines (with 1 it always fires twice). A DEADLOCK firing twice does nothing extra. |

---

## Any type
| Ability | Rule | Power | Watch out for |
|---|---|---|---|
| **BOOTING** *(in slice: REJECT ALL)* | DEADLOCKs can't be broken before your 3rd turn. | 2 | Opening Node main ICE only. With HARDENING or SHREDDER the forced wait becomes a forced loss. |

## Power at a glance
| Power | Abilities |
|---|---|
| 4 | LAST STAND, RELAY, BUNKER, HARDENING |
| 3 | SEQUENCED, TOLL, THROTTLE, ALARM |
| 2 | SHUFFLE, SHREDDER, TRIPWIRE, BACKLASH, CAMOUFLAGE, WATCHER, BOOTING |
| 1 | RUSTING |

---

## Dangerous combinations and design rules

The biggest risk is two passives that both tax BW or both grow over time in the same encounter.

**Never in the same encounter**
- DETAINER with TOLL, or THROTTLE on any ICE other than the DETAINER itself: stacked BW taxes leave turns with almost nothing to do.
- HARDENING with RELAY, BACKLASH or BOOTING: STR runs away faster than boosts can follow.
- BUNKER with a left neighbour whose DEADLOCK is hidden (TUMBLER or VOID): the layer can lock.
- Two of the same passive (two RELAYs, two ALARMs, two WATCHERs).

**Design rules for passives**
1. At most **one passive per ICE**, and at most **two passive ICE per encounter** in Tier 1.
2. Every passive is **visible on the ICE card** from turn 1 with its own icon, even on VOID ICE whose subroutines are hidden.
3. A passive must **create a decision**, not just add damage. If the only answer is "take it", it belongs in a subroutine instead.
4. Pay for it: subtract the **budget cost** from the ICE's STR or subroutines.
5. Black ICE get no passives: they are already the punishment.
6. Check each Rustler: a passive that one Rustler ignores (RUSTING vs VECTOR) or loves (TRIPWIRE vs RIOT) is fine, but note it.

---

## Suggested first playtest set

Four passives, one per slice ICE, so each route through HALCYON meets a different decision. All four pass the guardrails above.

| Slice ICE | Passive | Why it fits |
|---|---|---|
| AUTO-RENEW (FORTRESS) | HARDENING | A subscription that creeps up; its PULP 1-2-3 already escalates. |
| COOKIE WALL (FORTRESS) | TOLL | Cookies cost you something every time you click past them. |
| CONSENT FORM (TUMBLER) | ~~RELAY~~ none (DEPRECATE-001) | It props up TERMS OF SERVICE beside it in the DOORBELL node. |
| TERMS OF SERVICE (FORTRESS) | SEQUENCED | You have to read it in order: PULP 5, then SPAM, then the DEADLOCK. |

Built into the slice on 2026-11-13 (PASSIVE-001), plus CAPTCHA as a SNARE with TRIPWIRE and DOORBELL CAM as a WATCHER. 30-run bot test: 11 of 30 runs cleared (12 before passives); the CAPTCHA node became the main danger spot.
