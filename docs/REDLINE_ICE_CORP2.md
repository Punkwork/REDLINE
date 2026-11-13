# REDLINE — ICE: SECOND CORPORATION (IRONWATCH)
**Version:** 0.1
**Date:** 2026-11-13
**Status:** **APPROVED 2026-11-13** (pre-approved by the designer; decision record in §10). Follows the ICE design rules in `REDLINE_ICE_CORP1.md` §2 (ICE-002) and the encounter structure in §8 of that document, with the CRED reserves from UPL-008.

**Goal:** the mid-run corporation. Its job is to teach and then test **PULP**, the damage that ends runs, using **aggressive Sentries** and a Bloatware that hurts while you hold it.

> All numbers are **working values** for playtesting. Game data: `godot/data/ice.json` (corporation `ironwatch`), `cards.json` (CITATION), `ghostware.json` (IRONWATCH set).

---

## 1. IRONWATCH

**Who they are:** a private security contractor. Checkpoints, patrol drones, body cameras and armed response, sold to cities, malls and gated estates. HALCYON watches you at home; IRONWATCH watches the street, and it's allowed to act on what it sees.

**Why it fits PANOPTICON:** the second step of surveillance is enforcement. The friendly devices of HALCYON become the evidence IRONWATCH uses to stop you, search you and hurt you. Its ICE are named after policing hardware and procedures.

**How it plays:**
- **Lots of PULP.** SHIELD matters more than anywhere else. Unbroken subroutines hit hard, and its Black ICE is the most dangerous in the game.
- **Aggressive Sentries** react to what you do: installing (PATROL DRONE), hiding (K9 UNIT), attacking (ROADBLOCK).
- **CITATION** is its signature Bloatware: junk that deals PULP if you leave it in your hand.
- **Little TRACE and only one VOID source** (INTERROGATION, SPIKE STRIP), so the threat is clear: survive the damage.

### The three-corporation arc

| Corporation | Theme | Main threat | Difficulty |
|---|---|---|---|
| **1. HALCYON** | Consumer surveillance | TRACE, Bloatware | Introductory |
| **2. IRONWATCH** | Private security and enforcement | PULP, aggressive Sentries | Mid |
| **3. LUCIDA** | Neural interfaces | VOID, FORGET (ICE that rewire your deck) | Hard |

---

## 2. Design rules used

IRONWATCH follows the approved ICE design rules (`REDLINE_ICE_CORP1.md` §2): the threat budget, the Tier 1 and Tier 2 STR and threat ranges, the type identities, at most one reactive ability per ICE, and a DEADLOCK on every ICE that can be the main ICE. Difficulty rises over HALCYON through **what** the threat is (PULP ends runs, TRACE doesn't), and IRONWATCH ICE sit at the **upper end** of each tier's ranges.

**One new ICE effect target:** `EVERY OTHER ICE +X STR` (ARMORY). Uses the existing +X STR effect (ICE-003).

---

## 3. Bloatware: CITATION

| Card | Type | Effect | Source |
|---|---|---|---|
| **CITATION** | BLOATWARE | **Pay 1 BW to clear it:** it's BURNED for the rest of the Node. **If CITATION is in your hand at the end of your turn: PULP 2.** | IRONWATCH ICE |

**Why it works:** SPAM taxes your BW; CITATION taxes your BW *or* your VITAE. Ignoring it is a real choice, and it's worse when your SHIELD is already spent. Removed at Node end, like all Bloatware.

---

## 4. IRONWATCH ICE roster

### Tier 1 (rows 1–4)

| ICE | Type | STR | Subroutines | Reactive ability | Threat | Tests |
|---|---|---|---|---|---|---|
| **CHECKPOINT** | WALL | 4 | [S1] PULP 3 · [S2] DEADLOCK | — | 3 | Basic WALL breaking under PULP pressure |
| **BODY CAM** | SENTRY | 2 | [S1] TRACE 2 · [S2] PULP 2 + DEADLOCK | — | 4 | Choosing between TRACE and PULP |
| **PATROL DRONE** | SENTRY | 3 | [S1] PULP 3 + DEADLOCK | Whenever you install a PROGRAM: PULP 1. | 3+ | Setting up a big rig (Generalist) |
| **KEYCARD READER** | CODE GATE | 3 | [S1] DISCARD 1 · [S2] TRACE 1 · [S3] DEADLOCK | — | 3 | Many small breaks; rewards CODE GATE Icepicks |
| **BARRICADE** | WALL | 5 | [S1] INSERT 1 CITATION into your discard pile · [S2] DEADLOCK | — | 2 | PROBE and boosting against high STR; the CITATION tax |

### Tier 2 (rows 5–8)

| ICE | Type | STR | Subroutines | Reactive ability | Threat | Tests |
|---|---|---|---|---|---|---|
| **BLAST DOOR** | WALL | 6 | [S1] PULP 4 · [S2] DEADLOCK · [S3] DEADLOCK | — | 4 | Two DEADLOCKs behind high STR |
| **STUN TURRET** | SENTRY | 4 | [S1] PULP 3 · [S2] PULP 3 + DEADLOCK | — | 6 | Stacking SHIELD against double PULP |
| **K9 UNIT** | SENTRY | 3 | [S1] PULP 2 · [S2] PULP 2 · [S3] TRACE 2 + DEADLOCK | Whenever you play a CLOAK card: +1 STR (this encounter; stacks). | 6 | Over-hiding (ECHO) |
| **CROWD CONTROL** | CODE GATE | 4 | [S1] DISCARD 2 · [S2] PULP 2 + DEADLOCK | — | 6 | Hand disruption; CACHE |
| **ARMORY** | WALL | 5 | [S1] EVERY OTHER ICE +1 STR · [S2] PULP 3 + DEADLOCK | — | 3 + support | A support that arms the others: break it first or race |
| **INTERROGATION** | CODE GATE | 3 | [S1] INSERT 1 CITATION into your hand · [S2] VOID 1 · [S3] DEADLOCK | — | 6 | Bloatware in hand plus VOID; VOID BUFFER |
| **SNIPER NEST** | SENTRY | 5 | [S1] PULP 6 + DEADLOCK | While your TRACE is 20 or more, its PULP subroutines deal +2. | 6 (8) | High TRACE (RIOT) |

---

## 5. Black ICE: LETHAL FORCE

Joins on the left at the **2nd TRACE strike** (Core Rules §7).

| ICE | Type | STR | Subroutines | Threat |
|---|---|---|---|---|
| **LETHAL FORCE** | SENTRY | 6 | [S1] PULP 5 · [S2] PULP 5 | 10 |

- **No DEADLOCK**, like every Black ICE: you can race to BREACH instead of fighting it.
- It's the most dangerous Black ICE yet. In IRONWATCH, the 2nd strike is a VITAE emergency, not just a nuisance.

---

## 6. Central Node: OVERWATCH

IRONWATCH's command AI: every camera, drone and officer, coordinated. A three-ICE boss encounter, left to right:

| Position | ICE | Type | STR | Subroutines | Reactive ability |
|---|---|---|---|---|---|
| Left (support) | **DISPATCH** | CODE GATE | 3 | [S1] TRACE 2 · [S2] OVERWATCH +1 STR | — |
| Middle (support) | **SHOCK TROOPER** | SENTRY | 4 | [S1] PULP 3 · [S2] DISCARD 1 | — |
| Right (main) | **OVERWATCH** | SENTRY | 7 | [S1] PULP 4 · [S2] TRACE 2 · [S3] DEADLOCK · [S4] DEADLOCK | At the end of each Corporation Response: PULP 2. |

- **Threat per Corporation Response:** about 15 if nothing is broken (2 + 1 STR, 3 + 2, 4 + 2, plus 2 from OVERWATCH's ability).
- **The fight's question:** OVERWATCH's ability can't be broken. Every Corporation Response costs at least 2 VITAE, so the fight is a race. Break DISPATCH to stop OVERWATCH growing, or go straight for the two DEADLOCKs?
- **CRED reserve:** 35 (UPL-008).
- **Reward:** choose 1 of 3 Ghostware (1 from the IRONWATCH set + 2 general), active immediately (P5-009).

---

## 7. Escape ICE: the manhunt

When you take OVERWATCH's data core, IRONWATCH closes the district.

| ICE | Type | STR | Subroutines | Ability | Threat* |
|---|---|---|---|---|---|
| **ROADBLOCK** | WALL | 5 | [S1] PULP 3 · [S2] DEADLOCK | Whenever you play an EXPLOIT card: PULP 1. | 3+ |
| **SPIKE STRIP** | CODE GATE | 3 | [S1] VOID 1 · [S2] DEADLOCK | — | 4 |
| **SEARCHLIGHT** | SENTRY | 3 | [S1] TRACE 3 · [S2] PULP 2 + DEADLOCK | — | 5 (8 while escaping) |
| **PURSUIT DRONE** | SENTRY | 4 | [S1] PULP 4 + DEADLOCK | At the end of each Corporation Response: +1 STR. | 4, rising |
| **LETHAL FORCE** *(Black ICE)* | SENTRY | 6 | [S1] PULP 5 · [S2] PULP 5 | — | 10 |

\*TRACE gains are **doubled** during the escape (UPL-007).

**Escape layout:** as HALCYON's (P5-007): encounter 1 has 1 random escape ICE, encounter 2 has 2, and encounter 3 has 1 random escape ICE + **LETHAL FORCE** (support, left). Each reserve is 10 CRED. There's 1 SAFEHOUSE, after encounter 1 or 2.

**Why these:** ROADBLOCK punishes weakening ICE in a hurry; SPIKE STRIP adds VOID that lasts the rest of the corporation; SEARCHLIGHT hits TRACE while it's doubled; PURSUIT DRONE punishes slow escapes.

---

## 8. IRONWATCH Ghostware set (3): confiscated gear

| Ghostware | Effect |
|---|---|
| **KEVLAR WEAVE** | PULP from ICE subroutines deals 1 less to you (minimum 0). |
| **BADGE CLONE** | At the start of each encounter, every SENTRY gets −1 STR. *(An officer's ID, cloned.)* |
| **DASHCAM FEED** | Whenever you BREACH a layer, heal 3 VITAE. |

One of these is always among the 3 payload choices at OVERWATCH (P5-003).

---

## 9. Every Rustler has a way through

| Rustler | Easy against | Hard against | Their answer |
|---|---|---|---|
| **Generalist** | CHECKPOINT, KEYCARD READER | PATROL DRONE (PULP per install), STUN TURRET | READY RIG installs one Program before the encounter starts, without triggering PATROL DRONE |
| **ECHO** | KEYCARD READER, CROWD CONTROL (HUSH) | K9 UNIT (CLOAK), SNIPER NEST, the WALLs | PROBE + BACKDOOR; PULP Shield over SMOKESCREEN against K9 UNIT |
| **RIOT** | CHECKPOINT, BARRICADE, BLAST DOOR (SLEDGE) | SNIPER NEST at high TRACE, ROADBLOCK (EXPLOIT) | LAY LOW under 20 TRACE before Tier 2; save OVERLOAD for non-ROADBLOCK encounters |
| **VECTOR** | Sentry-heavy layers (STINGER), ARMORY multi-ICE layers | BLAST DOOR, BARRICADE (high-STR WALLs) | INJECT ROT, then RUNTIME ERROR; WORM spreads from a support to the main ICE |

---

## 10. Decision record (APPROVED 2026-11-13, pre-approved by the designer)

1. **IRONWATCH** as the second corporation: private security and enforcement; PULP and aggressive Sentries (§1). — **ICE2-001**
2. **CITATION** Bloatware: pay 1 BW to clear; PULP 2 if held at end of turn (§3). — **ICE2-002**
3. **The 12-ICE IRONWATCH roster**, including the ARMORY effect `EVERY OTHER ICE +X STR` (§2, §4). — **ICE2-003**
4. **Black ICE: LETHAL FORCE** (§5). — **ICE2-004**
5. **Central Node: OVERWATCH** with DISPATCH and SHOCK TROOPER (§6). — **ICE2-005**
6. **Escape ICE:** ROADBLOCK, SPIKE STRIP, SEARCHLIGHT, PURSUIT DRONE, with LETHAL FORCE in encounter 3 (§7). — **ICE2-006**
7. **IRONWATCH Ghostware set:** KEVLAR WEAVE, BADGE CLONE, DASHCAM FEED (§8). — **ICE2-007**
