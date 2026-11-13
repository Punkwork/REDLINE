# REDLINE — ICE: THIRD CORPORATION (LUCIDA)
**Version:** 0.1
**Date:** 2026-11-13
**Status:** **APPROVED 2026-11-13** (pre-approved by the designer; decision record in §10). Follows the ICE design rules in `REDLINE_ICE_CORP1.md` §2 (ICE-002) and the encounter structure in §8 of that document, with the CRED reserves from UPL-008.

**Goal:** the final corporation. Its job is to test **VOID**, the game's most frightening damage, and to attack the deck itself with a new effect, **FORGET**.

> All numbers are **working values** for playtesting. Game data: `godot/data/ice.json` (corporation `lucida`), `cards.json` (INTRUSIVE THOUGHT), `ghostware.json` (LUCIDA set).

---

## 1. LUCIDA

**Who they are:** a neural-interface company. Sleep trackers, focus headbands, mood apps and finally the implant: a direct link between your mind and the network. LUCIDA promises clarity. It sells what it learns from your dreams.

**Why it fits PANOPTICON:** the last step of surveillance is inside your head. HALCYON watched your home and IRONWATCH watched the street; LUCIDA watches your thoughts, and edits them. Its ICE are named after wellness products and the mind. This is where the First Signal story should feel closest.

**How it plays:**
- **VOID from Tier 1.** VOID counters stay for the whole corporation (Core Rules §6), so every unbroken VOID subroutine makes the rest of the heist harder.
- **FORGET** removes random cards from your hand for the rest of the Node. Your plan for this turn can vanish.
- **INTRUSIVE THOUGHT** is its signature Bloatware: junk that becomes VOID if you leave it in your hand.
- **Some PULP and TRACE,** at lower amounts than IRONWATCH and HALCYON, so VOID is clearly the threat.

---

## 2. Design rules used

LUCIDA follows the approved ICE design rules (`REDLINE_ICE_CORP1.md` §2): the threat budget, the tier ranges, the type identities, at most one reactive ability per ICE, and a DEADLOCK on every ICE that can be the main ICE. It's the hardest corporation because VOID is the most lasting threat, not because its numbers break the tier ranges.

---

## 3. New ICE effect: FORGET

| Effect | What happens | Threat |
|---|---|---|
| **FORGET X** | X **random** non-CACHED cards in your hand are **BURNED** for the rest of the Node (Core Rules §3.2). If your hand has no such cards, nothing happens. | 3 per card |

- **CACHED cards are safe from FORGET.** CACHE (DEAD AIR, STASH, DEAD MAN'S POCKET) becomes a real defence against LUCIDA.
- Unlike DISCARD, the card doesn't come back this Node, and you don't choose it.
- FORGET is a **corporation effect**: no player card uses it.

---

## 4. Bloatware: INTRUSIVE THOUGHT

| Card | Type | Effect | Source |
|---|---|---|---|
| **INTRUSIVE THOUGHT** | BLOATWARE | **Pay 1 BW to clear it:** it's BURNED for the rest of the Node. **If INTRUSIVE THOUGHT is in your hand at the end of your turn: VOID 1.** | LUCIDA ICE |

**Why it works:** ignoring SPAM costs a card slot; ignoring INTRUSIVE THOUGHT costs a card from every future hand this corporation. Players learn to clear it first, and that costs BW they wanted for breaking.

---

## 5. LUCIDA ICE roster

### Tier 1 (rows 1–4)

| ICE | Type | STR | Subroutines | Reactive ability | Threat | Tests |
|---|---|---|---|---|---|---|
| **SLEEP TRACKER** | CODE GATE | 2 | [S1] TRACE 1 · [S2] FORGET 1 · [S3] DEADLOCK | — | 4 | Learning FORGET |
| **MOOD SCANNER** | SENTRY | 3 | [S1] VOID 1 + DEADLOCK | — | 4 | Early VOID: break it or lose a card per draw |
| **DREAMCATCHER** | WALL | 4 | [S1] INSERT 1 INTRUSIVE THOUGHT into your discard pile · [S2] DEADLOCK | — | 2 | The INTRUSIVE THOUGHT tax |
| **FOCUS MODE** | WALL | 5 | [S1] DISCARD 1 · [S2] DEADLOCK | — | 2 | PROBE and boosting against high STR |
| **NEURAL HANDSHAKE** | CODE GATE | 3 | [S1] PULP 2 · [S2] FORGET 1 · [S3] DEADLOCK | — | 5 | Which loss hurts more: VITAE or a card |

### Tier 2 (rows 5–8)

| ICE | Type | STR | Subroutines | Reactive ability | Threat | Tests |
|---|---|---|---|---|---|---|
| **MEMORY PALACE** | WALL | 6 | [S1] FORGET 1 + PULP 2 · [S2] DEADLOCK · [S3] DEADLOCK | — | 5 | Two DEADLOCKs; FORGET while you boost |
| **DREAM AD** | CODE GATE | 4 | [S1] INSERT 2 INTRUSIVE THOUGHT into your draw pile · [S2] DEADLOCK | — | 6 | Bloatware that turns into VOID |
| **EMPATHY ENGINE** | SENTRY | 4 | [S1] VOID 1 · [S2] PULP 3 + DEADLOCK | Whenever you play an EXPLOIT card: TRACE 2. | 7+ | Weakening ICE with EXPLOIT cards (RIOT, VECTOR) |
| **NEUROLINK** | SENTRY | 5 | [S1] VOID 1 · [S2] VOID 1 + DEADLOCK | — | 8 | Heavy VOID: VOID prevention or a fast BREACH |
| **THERAPIST** | CODE GATE | 3 | [S1] PURGE ALL · [S2] FORGET 1 · [S3] DEADLOCK | — | 3 + anti-virus | VECTOR (break [S1] first or lose your counters) |
| **SYNAPSE BARRIER** | WALL | 5 | [S1] PULP 3 + DEADLOCK | Its STR can't be reduced below 4. | 3 | Boosting instead of PROBE |
| **RECALL** | CODE GATE | 4 | [S1] DISCARD 2 · [S2] TRACE 2 + DEADLOCK | — | 6 | Hand disruption; CACHE |

---

## 6. Black ICE: EGO DEATH

Joins on the left at the **2nd TRACE strike** (Core Rules §7).

| ICE | Type | STR | Subroutines | Threat |
|---|---|---|---|---|
| **EGO DEATH** | SENTRY | 6 | [S1] VOID 1 · [S2] PULP 4 | 8 |

- **No DEADLOCK**: you can race to BREACH instead of fighting it.
- Its VOID lasts the rest of the corporation, so an unanswered EGO DEATH shrinks your hand from then on, not just this encounter.

---

## 7. Central Node: ANIMA

LUCIDA's central model, trained on millions of sleeping minds. A three-ICE boss encounter, left to right:

| Position | ICE | Type | STR | Subroutines | Reactive ability |
|---|---|---|---|---|---|
| Left (support) | **MEMORY BANK** | CODE GATE | 3 | [S1] FORGET 1 · [S2] ANIMA +1 STR | — |
| Middle (support) | **LIMBIC LOOP** | SENTRY | 4 | [S1] PULP 2 · [S2] INSERT 1 INTRUSIVE THOUGHT into your hand | — |
| Right (main) | **ANIMA** | SENTRY | 7 | [S1] VOID 1 · [S2] PULP 3 · [S3] DEADLOCK · [S4] DEADLOCK | At the end of each Corporation Response: FORGET 1. |

- **Threat per Corporation Response:** about 15 if nothing is broken (MEMORY BANK 3 + STR, LIMBIC LOOP 4, ANIMA 4 + 3, plus FORGET 1 from its ability).
- **The fight's question:** every round costs cards. CACHE your key Icepick and Scripts, break MEMORY BANK to stop ANIMA growing, and clear INTRUSIVE THOUGHT before it becomes VOID?
- **CRED reserve:** 35 (UPL-008).
- **Reward:** choose 1 of 3 Ghostware (1 from the LUCIDA set + 2 general), active immediately (P5-009). This is the last encrypted core: decrypting it after the escape completes the First Signal (story content left OPEN for the designer).

---

## 8. Escape ICE: waking up

When you take ANIMA's core, LUCIDA tries to wake you before you can leave.

| ICE | Type | STR | Subroutines | Ability | Threat* |
|---|---|---|---|---|---|
| **WAKE SIGNAL** | CODE GATE | 3 | [S1] TRACE 3 · [S2] DEADLOCK | — | 3 (6 while escaping) |
| **DÉJÀ VU** | SENTRY | 3 | [S1] INSERT 1 INTRUSIVE THOUGHT into your hand · [S2] PULP 2 + DEADLOCK | — | 4 |
| **AMNESIA** | WALL | 5 | [S1] FORGET 1 · [S2] DEADLOCK | Its STR can't be reduced below 3. | 3 |
| **SLEEP PARALYSIS** | SENTRY | 4 | [S1] VOID 1 + DEADLOCK | Whenever you install a PROGRAM: +2 TRACE. | 4+ |
| **EGO DEATH** *(Black ICE)* | SENTRY | 6 | [S1] VOID 1 · [S2] PULP 4 | — | 8 |

\*TRACE gains are **doubled** during the escape (UPL-007).

**Escape layout:** as HALCYON's (P5-007): encounter 1 has 1 random escape ICE, encounter 2 has 2, and encounter 3 has 1 random escape ICE + **EGO DEATH** (support, left). Each reserve is 10 CRED. There's 1 SAFEHOUSE, after encounter 1 or 2.

---

## 9. LUCIDA Ghostware set (3): stolen neural tech

| Ghostware | Effect |
|---|---|
| **LUCID DREAM** | VOID can't reduce your DRAW below 3. |
| **MEMORY BACKUP** | Cards an ICE would FORGET go to your discard pile instead of being BURNED. |
| **NEURAL FIREWALL** | The first VOID you would gain each encounter is prevented. |

One of these is always among the 3 payload choices at ANIMA (P5-003).

---

## 10. Every Rustler has a way through

| Rustler | Easy against | Hard against | Their answer |
|---|---|---|---|
| **Generalist** | SLEEP TRACKER, FOCUS MODE | NEUROLINK, MOOD SCANNER (VOID) | VOID BUFFER blocks the first VOID each encounter; the SENTRY Icepick is cheap to boost |
| **ECHO** | SLEEP TRACKER, NEURAL HANDSHAKE, RECALL (HUSH) | MOOD SCANNER, NEUROLINK, the WALLs | DEAD AIR CACHEs BACKDOOR safe from FORGET; LOW PROFILE shrugs off TRACE 1–2 |
| **RIOT** | FOCUS MODE, MEMORY PALACE, SYNAPSE BARRIER (SLEDGE boosts past the STR floor) | EMPATHY ENGINE (EXPLOIT → TRACE), the CODE GATES | BRUTE FORCE early, before TRACE builds; LAY LOW before Tier 2 |
| **VECTOR** | Multi-ICE layers, ANIMA's supports | THERAPIST (PURGE ALL), SYNAPSE BARRIER (STR floor 4 limits ROT) | RUNTIME ERROR on THERAPIST's [S1] first; STINGER for the Sentries |

---

## 11. Decision record (APPROVED 2026-11-13, pre-approved by the designer)

1. **LUCIDA** as the third corporation: neural interfaces; VOID and FORGET (§1). — **ICE3-001**
2. **FORGET X:** X random non-CACHED cards in hand are BURNED for the Node; CACHED cards are safe; threat 3 per card (§3). — **ICE3-002**
3. **INTRUSIVE THOUGHT** Bloatware: pay 1 BW to clear; VOID 1 if held at end of turn (§4). — **ICE3-003**
4. **The 12-ICE LUCIDA roster** (§5). — **ICE3-004**
5. **Black ICE: EGO DEATH** (§6). — **ICE3-005**
6. **Central Node: ANIMA** with MEMORY BANK and LIMBIC LOOP (§7). — **ICE3-006**
7. **Escape ICE:** WAKE SIGNAL, DÉJÀ VU, AMNESIA, SLEEP PARALYSIS, with EGO DEATH in encounter 3 (§8). — **ICE3-007**
8. **LUCIDA Ghostware set:** LUCID DREAM, MEMORY BACKUP, NEURAL FIREWALL (§9). — **ICE3-008**
