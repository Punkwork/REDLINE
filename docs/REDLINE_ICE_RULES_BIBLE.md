# ICE Rules Bible
**Date:** 2026-11-13 · John Stevers
**Source:** project copy of the Claude Doc https://claude.ai/artifact/DnSnz3Pfgqqvd7nkwuBsdc (rev 14, copied 2026-11-15). The Doc is the live version; edit it there and re-copy.

> **Since this copy:** REJECT ALL is cut to **one DEADLOCK** (designer, 2026-11-15; see `REDLINE_ICE_CORP1.md` §5.0, REJECT-001). The audit row for REJECT ALL below predates that decision.

A Rustler should know what kind of trouble an ICE is before reading a single subroutine: **FORTRESSES hit hard, TUMBLERS are puzzles, VOIDS kill.** Every new ICE is checked against this bible so the types never blend into each other.

**Status labels:** **APPROVED** = the designer's decision. **PROPOSED** = a working practice awaiting approval. **LOCKED** = already in the rules (Core Rules, development log) and repeated here for reference.

---

## Type identities

Each type owns one kind of threat, and its rules follow from that threat.

### FORTRESS: the wall that hits back
- **APPROVED:** generally the **highest STR** of the three types.
- **APPROVED:** **fewer subroutines**, and they are **almost all PULP**. The odd other effect is allowed; **TRACE is rare**.
- **LOCKED:** subroutines never rotate or hide; everything fires every turn, so the threat is plain and the question is how much you can afford to break.
- **PROPOSED:** PULP values vary from ICE to ICE (1–5 in Tier 1) so no two FORTRESSES feel the same (PULP-001).

### TUMBLER: the puzzle
- **APPROVED:** TUMBLERS are **where the quirks and puzzles happen**.
- **LOCKED (ROT-001):** a pool of 1–8 subroutines turns through fewer slots, one step per Rustler turn (conveyor). Only subroutines in a slot can be broken; BREACH needs every DEADLOCK, and TUMBLERS carry several.
- **APPROVED (TUMBLE-001, 2026-11-16):** a broken subroutine drops out of the pool and the unbroken ones **tumble** into its place: the slots after it slide back and the next unbroken subroutine enters the last slot, active at once. Rotation skips broken subroutines and stops once everything left is showing (Core Rules §5.4). *Design note:* give TUMBLERS a pool at least 2 larger than their slots, or breaking empties them in a turn or two; place DEADLOCKs knowing each break pulls the next subroutine forward.
- **PROPOSED:** most passive abilities live on TUMBLERS (see the Ice Passive Abilities doc).
- **LOCKED (DET-001):** about 1 in 5 TUMBLERS is a **DETAINER** whose S1 is −1 BW next turn; at most 1 DETAINER per encounter.

### VOID: where the deadly happens
- **APPROVED:** VOIDS are **where the deadly happens**.
- **LOCKED (VOID-001):** subroutines start face-down; the Corporation Response fires subroutine 1, then 1–2, then 1–3, revealing each as it first fires. Hidden subroutines can't be broken.
- **LOCKED (NAME-001):** VOIDS are the main source of **CORTEX** damage (−1 DRAW each).
- **PROPOSED:** the biggest single hits in a tier (PULP 5–6, CORTEX), traded for **lower STR**, so a VOID is cheap to break once you can see what it does.

### Black ICE
- **LOCKED:** joins on the left at TRACE strike 2; has **no DEADLOCK**, so it must be survived or broken, never BREACHED around. HOUSE CALL is a VOID.
- **PROPOSED:** Black ICE never carry passive abilities or subtypes.

---

## Personalities: types and subtypes (PROPOSED)

Every subtype has a reason to exist in the world, and its passives come from that reason. DETAINER's rules are LOCKED; the other subtypes, their names and backgrounds are proposals.

### FORTRESS: old money, thick walls
FORTRESSES descend from the first corporate firewalls, built when the threat was crowds at the gate rather than code in the walls. They were never clever, only expensive, and every corporation still keeps a few because the board likes to see something solid. They hit back with plain force.

#### TOLLHOUSE
*Personality: petty, bureaucratic, always counting.*

TOLLHOUSES began as metered gateways for paid services, charging a fraction of a cred for every request that passed through. When intruders started passing through too, the corporations simply kept the meter running. A TOLLHOUSE doesn't care whether you're a customer or a thief, only that you pay.

*Passives: TOLL, BACKLASH.*

#### VAULT
*Personality: rigid, ceremonial, older than anyone who works there.*

VAULTS guarded ledgers and backups that had to be opened in a fixed order by several keyholders, each turning a key in sequence. The keyholders retired or died long ago, but the procedure was written into the wall and never removed. Break it out of order and it simply refuses to notice you.

*Passives: SEQUENCED, BUNKER.*

#### RATCHET
*Personality: patient, grudge-holding.*

RATCHETS grew out of rate limiters that tightened a notch after every failed login. Somewhere along the way the corporations stopped resetting them. The longer you stand in front of a RATCHET, the more it remembers you.

*Passive: HARDENING.*

#### RELIC
*Personality: proud, decaying, still wearing its old uniform.*

RELICS are walls from before the mergers, running on hardware nobody can replace and code nobody can read. On paper they're formidable; in practice a little more of them flakes away every cycle. The corporations keep them because removing them would cost more than the breaches do.

*Passive: RUSTING.*

### TUMBLER: the puzzle box
TUMBLERS were built by user-experience and compliance teams, not security engineers: the same people who designed cookie banners and cancellation flows that never quite let you leave. They're named for the pin tumblers in a lock, turning until the right combination lines up. A TUMBLER doesn't want to hurt you; it wants to waste your time until something else does.

#### DETAINER
*Personality: endlessly polite, on permanent hold.*

DETAINERS began as queue managers: "your call is important to us", hold music, an estimated wait that only ever grows. Corporations found that a visitor kept waiting is a visitor who can't act, so they pointed the queue at intruders. A DETAINER never refuses you; it just takes a little of your time, every time it comes round.

*Rule (LOCKED): S1 is always −1 BW next turn; about 1 TUMBLER in 5; at most 1 per encounter. Passive: THROTTLE.*

#### SWITCHBOARD
*Personality: officious operator, always connecting someone else.*

SWITCHBOARDS were load balancers, routing spare capacity to whichever system was under the heaviest strain. Under attack, the heaviest strain is always the ICE you're trying to break, so the SWITCHBOARD feeds it. Silence the operator and the line beside it goes quiet.

*Passive: ~~RELAY~~ none for now (RELAY deprecated 2026-11-17, DEPRECATE-001).*

#### SHELL GAME
*Personality: carnival hustler, all patter and misdirection.*

SHELL GAMES came from ad-tech, rotating offers and prices so no one could ever compare two of them side by side. Turned inward, the same trick hides how strong the ICE is and what it will do next. You can win against a SHELL GAME, but only by watching it more closely than it watches you.

*Passives: SHUFFLE, CAMOUFLAGE.*

#### SNARE
*Personality: smug, silent, already dialling.*

SNARES grew out of tamper seals and honeypot logins, systems whose whole purpose was to be touched by the wrong person. Breaking a SNARE works perfectly well; it's just that someone, somewhere, now knows you did. It's the only ICE that's happy to lose.

*Passive: TRIPWIRE.*

### VOID: the thing in the dark
VOIDS were never meant for the public internet. They began as military and intelligence countermeasures, licensed to corporations after the wars on the condition that nobody asked how they worked. You don't see what a VOID does until it does it, and by then it has done it to you.

#### WATCHER
*Personality: unblinking, patient, never in a hurry.*

WATCHERS descend from surveillance analytics: systems that didn't stop anyone, only noticed them and kept a file. The file is the weapon. Every time you try to hide, a WATCHER notices the hiding, and the more it has noticed, the harder it hits.

*Passives: WATCHER, ALARM.*

#### SIPHON
*Personality: a quiet parasite, polite about it.*

SIPHONS were built to deal with data thieves the cheap way: not by stopping the theft, but by draining the stolen assets while the thief was still inside. A SIPHON doesn't care if you get out. It cares that you get out with nothing.

*Passive: SHREDDER.*

#### DEADMAN
*Personality: spiteful to the very end.*

DEADMEN are dead man's switches from old defence contracts, designed for the moment a facility is overrun. When everything else has been broken, the last circuit fires everything it has left, twice. They are the reason Rustlers say never corner a VOID.

*Passive: LAST STAND.*

---

## Budgets by type and tier (PROPOSED)

Starting ranges for playtest; the type ordering (FORTRESS STR highest) is the approved part.

| | FORTRESS | TUMBLER | VOID |
|---|---|---|---|
| STR, Opening | 5 | 3–4 | 2–3 |
| STR, Tier 1 | 5–7 | 3–5 | 2–4 |
| STR, Tier 2 | 8–10 | 5–7 | 4–6 |
| Subroutines | 2–3 (max 4) | pool 2–8, slots 1–3 | 2–4 |
| DEADLOCKs | 1 | 2–3 in the pool | 1, never first |
| PULP | Most subs; 1–5 each | At most 1, ≤ 3 | Biggest in tier: 4–6 |
| TRACE | Rare (about 1 FORTRESS in 5) | Common, 1–3 | Occasional |
| Other effects | At most 1 (e.g. SPAM) | Hand/deck tricks: DISCARD, INSERT, −1 BW | CORTEX |
| Passive abilities | Occasional | Most of them | Occasional (WATCHER-style) |
| Subtypes | TOLLHOUSE, VAULT, RATCHET, RELIC | DETAINER (about 20%), SWITCHBOARD, SHELL GAME, SNARE | WATCHER, SIPHON, DEADMAN |

A passive or subtype is paid for out of this budget (see the budget cost scale in Ice Passive Abilities).

---

## General practices for all ICE (PROPOSED unless marked)

The common thread: every encounter should offer more good breaks than the Rustler can afford.

1. **Should, not could.** Each encounter needs at least one turn where the Rustler must choose between two good breaks (the DEADLOCK vs the big PULP, this ICE vs its neighbour). If there's an obvious best line every turn, change the ICE.
2. **Read the type at a glance.** Type icon, frame for role and chip colours carry the type (LOCKED, ICE Design doc). A FORTRESS should look heavy; a TUMBLER should show its hidden pool; a VOID shows face-down subroutines.
3. **One identity per ICE.** Pick the one thing it does (hits, rotates, hides, taxes) and keep everything else plain.
4. **One passive at most per ICE**, two passive ICE at most per Tier 1 encounter.
5. **One DETAINER at most per encounter** (LOCKED, DET-001).
6. **Every BREACH must be reachable** with the starter deck plus one reward, within about 5 turns, without Black ICE. Test it with the bot.
7. **Mix types inside an encounter.** Two ICE of the same type in one layer should be rare; the layer's puzzle comes from types meeting.
8. **Names are jokes; numbers are not.** Corporation-flavoured names (COOKIE WALL, AUTO-RENEW), but the subroutines read plainly.
9. **Every new ICE gets a line in the audit table** below until it fits the bible.

---

## Audit of the HALCYON slice ICE

Four of the nine slice ICE already fit; the biggest gap is DOORBELL CAM, a VOID that isn't deadly. Nothing below has been changed in the build yet.

| ICE | Type, STR | Fits? | Change to fit the bible |
|---|---|---|---|
| ACCEPT ALL | TUMBLER (DETAINER), 4 | Yes | — |
| COOKIE WALL | FORTRESS, 5 | Yes | Its TRACE 2 is the rare FORTRESS TRACE; keep it as the only one. |
| TERMS OF SERVICE | FORTRESS, 7 | Yes | — |
| REJECT ALL | TUMBLER, 4 | Nearly | PULP 4 is above the TUMBLER cap: make it PULP 3 or a DISCARD. |
| CONSENT FORM | TUMBLER, 4 | Nearly | PULP 4 above the cap: make it PULP 3 or an INSERT SPAM. |
| AUTO-RENEW | FORTRESS, 4 | No | STR below CAPTCHA beside it: raise to 5. |
| CAPTCHA | TUMBLER, 5 | No | PULP 6 is VOID-sized: replace with TRACE 2 or INSERT. Lower STR to 4 so the FORTRESS beside it is stronger. |
| DOORBELL CAM | VOID, 4 | No | Not deadly: one TRACE 3 + DEADLOCK sub. Suggest STR 3 with [S1] PULP 4, [S2] CORTEX 1, [S3] DEADLOCK, keeping WATCHER. |
| HOUSE CALL | Black VOID, 7 | Yes | Two PULP 6 is the deadliest thing in the slice. Black ICE may exceed the VOID STR range. |

Open question: apply these changes to the slice now, or playtest the passives first?
