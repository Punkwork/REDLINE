# REDLINE — ENGINES (Phase 6 of the simplified redesign)
**Version:** 0.1
**Date:** 2026-11-13
**Status:** **Mechanics APPROVED in principle 2026-11-13** (designer: "work on all 5 new mechanics. Approved"). **The details in this document (names, numbers, example cards) are PROPOSED working values** awaiting approval (decision record in §8). Builds on the approved Core Rules, Rustlers, Card Pools, ICE (NAME-001) and Uplink documents.

**Why this phase:** research into Slay the Spire's Defect (doc: *Why Defect builds get replayed: lessons for REDLINE*) found that its most replayed builds share one engine with several ways to finish, one amplifier that upgrades the whole engine, and real "hold or cash out" decisions. REDLINE already has much of this spread thin (VECTOR's strains, Programs, Extractors, PROTOCOLS). This phase adds the five missing pieces.

**One REDLINE constraint shapes every rule here: ICE have no HP.** Engines can't "deal damage" to ICE. Their jobs are the game's real levers: **−STR**, **SHIELD**, **CRED**, **−TRACE** and **BW**.

> All numbers are **working values** for playtesting. Nothing here changes existing cards; new cards are examples for the Phase 3B-style pool work that follows.

---

## 1. Shared terms (used by ENG-001 to ENG-005)

| Term | Meaning |
|---|---|
| **ENGINE effect** | An effect that resolves on its own, without a card being played: Extractor payouts, PROTOCOL "start/end of your turn" effects, virus strain effects, and PROCESS effects (§4). Cards label them with the **ENGINE** tag. |
| **CHARGE** | Counters a Program or PROCESS stores while it runs. Shown on the card. Lost if the Program returns to your deck at Node end without being unloaded. |
| **FREE RAM** | Your RAM minus the RAM used by installed Programs. Shown beside RAM on the HUD. |

---

## 2. ENG-001 — AMP: one amplifier for every engine (P1)

**AMP** is a player stat, like SHIELD or TRACE. It starts at **0** and lasts **until the end of the Node** (it carries across layers and resets when the next Node begins).

**Rule:** every **ENGINE** number you control gets **+AMP**:
- **Extractors:** +AMP CRED per payout (still limited by the layer's CRED reserve).
- **PROTOCOLS with turn triggers:** +AMP to their number (SURGE PROTECTOR: +2 SHIELD becomes +2+AMP).
- **Virus strains:** on each ICE, each strain with at least 1 counter adds +AMP to its total effect (ROT: −STR; SCRAMBLE: PULP prevented; BLIND: TRACE prevented; LEECH: CRED). **WORM is not affected.**
- **PROCESSES** (§4): +AMP to both their RUN and KILL numbers, except MINER and ZOMBIE.
- **Not affected:** Icepick STR and costs, card effects you play, Ghostware, CAPS.

AMP can't go below 0. **Screen rule:** AMP appears on the HUD beside RAM once it's above 0; affected numbers on cards show their amplified value.

**Why:** one card that upgrades the whole engine makes every reward screen tense (Defect's Focus). Because REDLINE's engines feed CRED, SHIELD and −STR rather than damage, AMP scales the economy and the defence, which the playtest must watch (CRED targets in UPL-008).

**Example cards (pool work, working values):**

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **GAIN STAGE** | Uncommon | PROTOCOL | 1 BW | +1 AMP. |
| **OVERDRIVE** | Uncommon | SCRIPT | 1 BW | +3 AMP. At the start of each of your turns this Node, lose 1 AMP. |
| **SIGNAL CHAIN** | Rare | PROTOCOL | 2 BW | +1 AMP. Whenever you install an ENGINE Program, +1 AMP (once per turn). |

**Value guide addition (CARD-001):** 1 AMP ≈ **1.5 BW** of value per Node for a deck with 2 ENGINE sources; tune in playtest.

---

## 3. ENG-002 — UNLOAD effects: cashing out a Program (P2)

**Rule:** some Programs print an **UNLOAD:** effect. When you **unload** that Program during your turn (0 BW, Core Rules §3.1), the UNLOAD effect resolves, then the Program goes to your discard pile as usual.
- UNLOAD effects **don't** trigger when Programs return to your deck at Node end.
- Many UNLOAD Programs store **CHARGE** while they run, and their UNLOAD effect scales with it. Holding grows the payoff; unloading frees the RAM now.
- Unloading is still not allowed during the Corporation Response (your turn only).

**Why:** Defect's best moments are "hold the Dark orb or fire it now". Today unloading a Program does nothing, so REDLINE has no cash-out decision. This adds one without new resources, and it pairs with FREE RAM cards (ENG-005): unloading frees RAM mid-turn.

**Example cards:**

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **SLUSH FUND** | Common | PROGRAM — EXTRACTOR, ENGINE | 1 BW, 1 RAM | End of your turn: extract 2 CRED and gain 1 CHARGE. **UNLOAD:** extract 3 CRED per CHARGE. |
| **BUFFER OVERFLOW** | Uncommon | PROGRAM — EXPLOIT | 1 BW, 1 RAM | End of your turn: gain 1 CHARGE. **UNLOAD:** target ICE −1 STR per CHARGE this encounter. |
| **HOT STANDBY** | Common | PROGRAM — CLOAK, ENGINE | 1 BW, 1 RAM | Start of your turn: +2 SHIELD. **UNLOAD:** +6 SHIELD. |

**Note:** BUFFER OVERFLOW is EXPLOIT, so unloading it doesn't trigger EXPLOIT reactions (ROADBLOCK, EMPATHY ENGINE): those trigger on **playing** cards, and unloading isn't playing.

---

## 4. ENG-003 — CRON, the fifth Rustler: background PROCESSES (P3)

> *"I don't hack the system. I schedule it."*

**Playstyle:** CRON runs **PROCESSES**, small background jobs that work every turn on their own, then KILLs them for a burst at the right moment. Slow first turns, strong once the queue is full. CRON is REDLINE's version of Defect: the engine lives on the player, where PURGE can't touch it (VECTOR's lives on the ICE).

### 4.1 PROCESS rules
1. **THREADS:** CRON has **3 THREADS** (slots), shown in a row beside the RACK. Maximum 6.
2. **SPAWN X [PROCESS]:** put X copies of that PROCESS into the leftmost free THREADS. If every THREAD is full, the **rightmost** PROCESS is KILLed first to make room (its KILL effect resolves).
3. **RUN:** at the end of your turn, after Extractors pay out, each PROCESS resolves its **RUN** effect, **left to right**. RUN effects are ENGINE effects (AMP applies, §2).
4. **KILL:** card effects KILL your **rightmost** PROCESS unless they say otherwise. Its KILL effect resolves, then it's gone.
5. **Duration:** PROCESSES last until the end of the **encounter** (like boosts). They aren't Programs: they use no RAM, aren't cards, and don't trigger "whenever you install a PROGRAM" ICE abilities (NANNY CAM, PATROL DRONE, MOTION SENSOR, SLEEP PARALYSIS).
6. **ICE can't target PROCESSES** in this version. (A future ICE effect could; it would need its own approval.)
7. **Screen rule:** each PROCESS shows its RUN and KILL numbers (amplified) and any CHARGE. The Corporation Response preview shows RUN effects as the first steps after your turn ends.

### 4.2 The PROCESSES

| PROCESS | RUN (end of your turn) | KILL | Role (Defect parallel) |
|---|---|---|---|
| **SANDBOX** | +2 SHIELD | +5 SHIELD | Defence (Frost) |
| **FUZZER** | A random ICE: −1 STR this encounter | Target ICE: −3 STR this encounter | Break-through (Lightning) |
| **SCRAPER** | Extract 2 CRED | Extract 5 CRED | Economy |
| **SHREDDER** | −2 TRACE | −5 TRACE | Stealth |
| **MINER** *(rewards only)* | +1 BW at the start of your next turn | +2 BW now | Energy (Plasma); not affected by AMP |
| **ZOMBIE** *(starter fallback)* | +1 CHARGE | Break 1 subroutine on **any** ICE with STR equal to or less than its CHARGE | Charged breaker (Dark); not affected by AMP |

SHIELD from SANDBOX's RUN lands at the end of your turn, so it protects during the Corporation Response and expires at the start of your next turn like all SHIELD.

### 4.3 Starter deck (12)

| Qty | Card | Type / tags | Cost | Effect |
|---:|---|---|---|---|
| 1 | **PIPE** *(signature)* | PROGRAM — ICEPICK (FORTRESS) | 1 BW, 1 RAM | STR 1. Boost: 1 BW → +1 STR. Break: 1 BW. **+1 STR for each PROCESS you're running.** |
| 1 | **ORPHAN** *(fallback)* | SCRIPT | 1 BW | SPAWN 1 ZOMBIE. |
| 2 | **SANDBOX** | SCRIPT — CLOAK | 1 BW | SPAWN 1 SANDBOX. |
| 2 | **FUZZ** | SCRIPT — EXPLOIT | 1 BW | SPAWN 1 FUZZER. |
| 1 | **SIGKILL** | SCRIPT | 0 BW | KILL your rightmost PROCESS. |
| 1 | Basic Extractor | PROGRAM — EXTRACTOR | 1 BW, 1 RAM | End of your turn: extract 5 CRED. |
| 2 | PULP Shield | SCRIPT — CLOAK | 1 BW | +3 SHIELD. |
| 1 | PROBE | SCRIPT — EXPLOIT | 1 BW | Target ICE: −2 STR this encounter. |
| 1 | GHOST SIGNAL | SCRIPT — CLOAK | 2 BW | As Generalist. |

**Fallback check (Core Rules §12, OPEN-001):** ZOMBIE gains 1 CHARGE per turn, so a ZOMBIE spawned on turn 1 can break an STR 3 DEADLOCK on turn 3 or 4. That fits BOOTING's 3-turn Opening Nodes. Simulate before approval.

**Weak against:** SIGYL and VOID ICE (PIPE is a FORTRESS Icepick), fast encounters, and K9 UNIT / DOORBELL CAM (SANDBOX is CLOAK). **Strong in:** long multi-ICE layers and Opening Nodes.

### 4.4 ORIGIN Ghostware — CRONTAB
**At the start of each encounter, SPAWN 1 SANDBOX.** *(CRON's Cracked Core: the engine is running before your first card.)*

### 4.5 Open items for CRON
- **Unlock:** proposed after winning any full run (CRON is the most complex Rustler).
- **Pool:** 20–25 cards in 3–4 archetypes (ENG-004), e.g. **SANDBOX wall**, **FUZZER grind**, **SCRAPER bank**, **ZOMBIE horde**, designed in the next pool phase.
- **Name:** CRON (alternatives: KERNEL, FORK).

---

## 5. ENG-004 — More Rustler cards in rewards (P4)

**Rule:** card rewards change from **2 shared + 1 Rustler** (RUSTLER-007) to **1 shared + 2 Rustler**. The Uplink card shelf changes from **4 shared + 2 Rustler** to **3 shared + 3 Rustler**.

**Gate:** switch only when **every** Rustler pool has **at least 20 cards in 3–4 archetypes** (each with an enabler, an engine, a payoff and 2–3 bridge cards). Until then, rewards stay 2 + 1.

**Why:** with 9-card Rustler pools and 1 Rustler card per reward, a run sees about 7 Rustler cards in ~22 rewards: too few for archetypes to form. At 2 per reward, a run sees about 14, enough to build one of several plans.

**Pool targets:** Generalist, ECHO, RIOT, VECTOR and CRON each 20–25 cards; the shared pool stays at 31 (+ the ENG-001/002/005 examples as candidates).

---

## 6. ENG-005 — Cards that care about RAM (P5)

**Rule:** cards may refer to **FREE RAM** (§1) or to your **RAM being full** (FREE RAM 0). Both are checked when the effect resolves.

**Why:** Defect's orb-slot count is a dial (few slots for fast Evokes, many for Frost). RAM can be REDLINE's dial: a few big Programs, or a full rig. With ENG-002, unloading a Program mid-turn changes FREE RAM, which creates combos.

**Example cards:**

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **HEADROOM** | Common | PROTOCOL — ENGINE | 1 BW | Start of your turn: +1 SHIELD per FREE RAM. |
| **SWAP FILE** | Common | SCRIPT | 0 BW | Draw 1 card per FREE RAM (maximum 3). |
| **MAXED OUT** | Uncommon | PROTOCOL | 1 BW | While your RAM is full, your Icepicks have +1 STR. |
| **PAGE OUT** | Uncommon | SCRIPT | 1 BW | −1 RAM for the rest of the Node. +1 THREAD for the rest of the Node. *(CRON pool.)* |
| **RAM DISK** | Rare | PROTOCOL — ENGINE | 2 BW | While your RAM is full: +1 AMP. |

---

## 7. How the five fit together

- **AMP** (ENG-001) multiplies **ENGINE** effects: Extractors, PROTOCOLS, strains, PROCESSES.
- **UNLOAD** (ENG-002) and **KILL** (ENG-003) are the same decision in two forms: let the engine keep running, or cash it out now.
- **FREE RAM** (ENG-005) turns rig size into a dial, and unloading changes it mid-turn.
- **ENG-004** makes sure enough Rustler cards appear for these engines to assemble in a run.
- **VECTOR** gains most from AMP (strains) and is the first pool to redesign into archetypes; **CRON** is built on all five.

---

## 8. Decision record (mechanics APPROVED in principle 2026-11-13; details PROPOSED)

| ID | Decision | Status |
|---|---|---|
| ENG-001 | **AMP**: player stat, 0 at start, lasts the Node, can't go below 0; +AMP to every ENGINE number (Extractors, PROTOCOL turn effects, strains except WORM, PROCESSES except MINER and ZOMBIE). Example cards GAIN STAGE, OVERDRIVE, SIGNAL CHAIN (§2). | Mechanic approved; details proposed |
| ENG-002 | **UNLOAD effects** resolve when you unload a Program during your turn, not at Node end; **CHARGE** counters (§1, §3). Example cards SLUSH FUND, BUFFER OVERFLOW, HOT STANDBY. | Mechanic approved; details proposed |
| ENG-003 | **CRON**, fifth Rustler: 3 THREADS (max 6), SPAWN / RUN / KILL, PROCESSES last the encounter and aren't Programs; six PROCESSES; starter deck with PIPE and ORPHAN; ORIGIN Ghostware CRONTAB (§4). | Mechanic approved; details proposed |
| ENG-004 | **Rewards 1 shared + 2 Rustler; Uplink 3 + 3**, switched on only when every Rustler pool has 20+ cards in 3–4 archetypes. Amends RUSTLER-007 and UPL-005 when switched on (§5). | Mechanic approved; gate and numbers proposed |
| ENG-005 | **FREE RAM** and **RAM full** conditions on cards. Example cards HEADROOM, SWAP FILE, MAXED OUT, PAGE OUT, RAM DISK (§6). | Mechanic approved; details proposed |

**Before final approval:** simulate CRON's Opening Node turns (target 3–4, like OPEN-001), AMP's effect on CRED per corporation (target 130–220, UPL-008), and SANDBOX + CRONTAB against IRONWATCH's PULP.

**Next:** Phase 7 — pool redesign into archetypes (VECTOR first, then CRON), using these mechanics.
