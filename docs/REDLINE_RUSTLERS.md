# PANOPTICON — RUSTLERS
**Version:** 0.1 (Phase 2 of the simplified redesign)
**Date:** 2026-11-12
**Status:** **APPROVED 2026-11-12.** All eight Phase 2 decisions (RUSTLER-001 to RUSTLER-008) were approved by the designer (§9). Builds on `REDLINE_CORE_RULES.md` v0.2 (approved).

**Goal of this phase:** four Rustlers who feel different from their first hand, each with a clear way to win and a clear weakness.

---

## 1. The four Rustlers at a glance

| Rustler | Playstyle | Signature Icepick | Weak against | ORIGIN Ghostware | Difficulty |
|---|---|---|---|---|---|
| **THE GENERALIST** | Balanced; an answer for everything | One of each type | Nothing in particular; nothing outstanding | **READY RIG** | ★☆☆ |
| **ECHO** | Quiet. Low TRACE, long encounters, more CRED | **HUSH** (SIGYL) | FORTRESS, VOID | **LOW PROFILE** | ★★☆ |
| **RIOT** | Loud. Gets stronger at high TRACE, flirts with strikes | **SLEDGE** (FORTRESS) | SIGYL, VOID | **REDLINER** | ★★★ |
| **VECTOR** | Viruses. Weakens every ICE over time | **STINGER** (VOID) | FORTRESS, SIGYL (until infected) | **PATIENT ZERO** | ★★☆ |

**Shared starting stats:** 30 VITAE (Max 30), 4 BW, DRAW 6 (DRAW-001), 4 RAM, TRACE 0 of 40. Rustlers differ through their decks and ORIGIN Ghostware, not their base stats, so the core numbers stay easy to learn.

**Fallback rule (from Core Rules §12):** every Rustler except the Generalist has one **fallback** card that can break a subroutine on **any** ICE type, at a cost that fits their style: BW for ECHO, TRACE for RIOT, virus setup for VECTOR.

---

## 2. Virus strains (APPROVED 2026-11-12, RUSTLER-002)

Viruses were an OPEN subtype (TAX-001). This general rule lets different viruses have different effects without special cases.

1. **Every virus has a named strain.** Cards say which strain they place: **INFECT X [STRAIN]** puts X counters of that strain on target ICE. Each strain defines what its counters do.
2. **All strains count as virus counters.** An ICE with 2 ROT and 1 LEECH has 3 virus counters. Cards that refer to "virus counters" count every strain together; cards can also name a specific strain.
3. **Each strain works at one of three fixed timings:**

| Timing | When it applies |
|---|---|
| **Constant** | Always, while the counters are on the ICE |
| **Your turn** | At the start of your turn |
| **When this ICE acts** | During this ICE's part of the Corporation Response |

4. **Effects scale with the number of counters** of that strain on that ICE.
5. **Shared rules:** counters last until the encounter ends. **PURGE** (an ICE subroutine effect, reserved in MECH-004) removes all virus counters of every strain from that ICE. Targeted versions such as **PURGE ROT** may exist on stronger ICE.
6. **On screen:** each strain has its own icon and count on the ICE; tapping it shows the strain's effect.

### Starting strains

| Strain | Timing | Effect per counter |
|---|---|---|
| **ROT** | Constant | −1 STR (minimum 0) |
| **SCRAMBLE** | When this ICE acts | This ICE's PULP subroutines deal 1 less |
| **BLIND** | When this ICE acts | This ICE's TRACE subroutines add 1 less |
| **LEECH** | Your turn | Extract 1 CRED |
| **WORM** | Your turn | Put 1 counter of each strain on this ICE onto the next ICE to its right (if any) |

VECTOR's starter deck uses only **ROT**. The other strains appear as card rewards (Phase 3), so VECTOR players can build toward defence (SCRAMBLE, BLIND), CRED (LEECH) or multi-ICE encounters (WORM).

> PROBE's −2 STR and ROT counters stack. The difference: PROBE is instant and fixed; ROT starts small and grows.

---

## 3. THE GENERALIST

> *"A bit of everything. Enough of nothing."*

**Playstyle:** the tutorial Rustler. Has an Icepick for every ICE type, so no encounter is a dead end, but each Icepick needs boosting to handle stronger ICE. Good at learning the game; outgrown once you know it.

### Starter deck (12) — unchanged from Core Rules §13

| Qty | Card | Type / tags | Cost | Effect |
|---:|---|---|---|---|
| 1 | FORTRESS Icepick | PROGRAM — ICEPICK (FORTRESS) | 1 BW, 1 RAM | STR 1. Boost: 1 BW → +1 STR. First break each turn free; then 1 BW per break. |
| 1 | SIGYL Icepick | PROGRAM — ICEPICK (SIGYL) | 1 BW, 1 RAM | STR 3. Boost: 2 BW → +1 STR. Break: 1 BW. |
| 1 | VOID Icepick | PROGRAM — ICEPICK (VOID) | 1 BW, 1 RAM | STR 0. Boost: 1 BW → +1 STR. Break: 1 BW. |
| 1 | Basic Extractor | PROGRAM — EXTRACTOR | 1 BW, 1 RAM | End of your turn: extract 5 CRED. |
| 1 | CORTEX BUFFER | PROGRAM | 1 BW, 1 RAM | Once per encounter, prevent 1 CORTEX. |
| 3 | PULP Shield | SCRIPT — CLOAK | 1 BW | +3 SHIELD. |
| 3 | PROBE | SCRIPT — EXPLOIT | 1 BW | Target ICE: −2 STR this encounter. |
| 1 | GHOST SIGNAL | SCRIPT — CLOAK | 2 BW | The first TRACE added in the next Corporation Response becomes 0. BURNED for the rest of the Node. |

### ORIGIN Ghostware — READY RIG
**At the start of each ICE Node, choose one PROGRAM in your deck and install it for free.** It doesn't come from your hand, so your first hand stays full.

**Why:** the Generalist's weakness is setup time; five Programs compete for 4 RAM and 4 BW a turn. READY RIG makes the first turn of every Node feel smooth, which is exactly what a tutorial Rustler needs.

---

## 4. ECHO

> *"If they never notice you, you were never there."*

**Playstyle:** quiet. Avoids TRACE, which lets ECHO stay in encounters longer and extract more CRED than anyone else. Strong against SIGYLS; has to pay heavily in BW to get past other ICE.

**Built-in tension:** most of ECHO's protection is CLOAK cards, and some VOID ICE (like WATCHDOG) get stronger every time a CLOAK card is played. Choosing when *not* to hide is ECHO's skill test.

### Starter deck (12)

| Qty | Card | Type / tags | Cost | Effect |
|---:|---|---|---|---|
| 1 | **HUSH** *(signature)* | PROGRAM — ICEPICK (TUMBLER) | 1 BW, 1 RAM | STR 0. Boost: 2 BW → +1 STR. Break: 1 BW. *(BASIC-001: was STR 4, boost 1 BW. ECHO-002: STR 3 → 1; ECHO-004: → 0. ROT-001: SIGYL → TUMBLER.)* |
| 1 | **BACKDOOR** *(fallback)* | SCRIPT — EXPLOIT | 3 BW | Break 1 subroutine on **any** ICE with STR 3 or less. |
| 1 | Basic Extractor | PROGRAM — EXTRACTOR | 1 BW, 1 RAM | End of your turn: extract 5 CRED. |
| 3 | PROBE | SCRIPT — EXPLOIT | 1 BW | Target ICE: −2 STR this encounter. *(ECHO-001: was 2.)* |
| 3 | PULP Shield | SCRIPT — CLOAK | 1 BW | +3 SHIELD. *(ECHO-001: was 2.)* |
| 1 | **SMOKESCREEN** | SCRIPT — CLOAK | 1 BW | +2 SHIELD. The first TRACE you gain during the next Corporation Response is reduced by 2. *(ECHO-003: was 2.)* |
| 1 | **DEAD AIR** | SCRIPT — CLOAK | 0 BW | CACHE 1 card in your hand. |
| 1 | GHOST SIGNAL | SCRIPT — CLOAK | 2 BW | As Generalist. |

> **ECHO-001 / ECHO-003 (2026-11-14):** SLOW DRIP left the starter deck for ECHO's reward pool (Common), making room for a 3rd PROBE and a 3rd PULP Shield. GHOST SIGNAL stays in the starter deck because it's a shared basic (BASIC-001); one SMOKESCREEN was removed instead.

### ORIGIN Ghostware — LOW PROFILE
**Whenever you would gain TRACE, gain 1 less (minimum 0).**

**Why:** it turns every small TRACE subroutine (TRACE 1–3) into nearly nothing, so ECHO can stay in an encounter turn after turn to fill both Extractors. It rewards ECHO's plan without making TRACE irrelevant: big TRACE hits still land.

**How ECHO wins an encounter:** install HUSH and both Extractors early, Shield and Smokescreen through the Corporation Responses, and BREACH only once the CRED reserve is empty for the full-extraction bonus. Against a FORTRESS or VOID, use PROBE to bring it down to STR 3, then pay 3 BW for BACKDOOR, or CACHE BACKDOOR with DEAD AIR until the moment it's needed.

---

## 5. RIOT

> *"Subtle is for people with time."*

**Playstyle:** loud. Most of RIOT's cards are cheap but add TRACE. Above 20 TRACE, RIOT gets an extra BW every turn, and the game becomes managing how close to a strike you dare to get. Fast encounters, low CRED, high risk.

### Starter deck (15 — RIOT-002/004)

| Qty | Card | Type / tags | Cost | Effect |
|---:|---|---|---|---|
| 1 | **SLEDGE** *(signature)* | PROGRAM — ICEPICK (FORTRESS) | 1 BW, 1 RAM | STR 2. Boost: 1 BW → +1 STR. First break each turn free; then 1 BW per break. **Each break: +1 TRACE.** |
| 1 | **BRUTE FORCE** *(fallback)* | SCRIPT — EXPLOIT | 1 BW, **+4 TRACE** | Break 1 subroutine on **any** ICE with STR 4 or less. |
| 1 | **SHATTER** | SCRIPT — EXPLOIT | 1 BW, **+3 TRACE** | This turn, SLEDGE can break subroutines on target ICE of any type. At the end of your turn, SLEDGE drops to STR 0 for the rest of the encounter. *(RIOT-002 new; RIOT-003 redesigned; RIOT-004 kept at +3 TRACE.)* |
| 1 | **OVERLOAD** | SCRIPT — EXPLOIT | 0 BW, **+2 TRACE** | Target ICE: −2 STR this encounter. *(RIOT-002: was 2.)* |
| 3 | PROBE | SCRIPT — EXPLOIT | 1 BW | Target ICE: −2 STR this encounter. *(RIOT-002: was 1.)* |
| 1 | **FEEDBACK** | SCRIPT — EXPLOIT | 2 BW | Target ICE: −1 STR this encounter for every 10 TRACE you have. |
| 1 | **ADRENAL SPIKE** | SCRIPT | 0 BW, **+2 TRACE** | Gain 1 BW. *(BASIC-001: was 2 BW.)* |
| 3 | PULP Shield | SCRIPT — CLOAK | 1 BW | +3 SHIELD. *(RIOT-002: was 2.)* |
| 1 | **LAY LOW** | SCRIPT — CLOAK | 1 BW | −3 TRACE. *(BASIC-001: was −5.)* |
| 1 | **SMASH & GRAB** | PROGRAM — EXTRACTOR | 1 BW, 1 RAM | End of your turn: extract 8 CRED. **+1 TRACE while your TRACE is under 20.** *(RIOT-004: was +2 TRACE every turn.)* |
| 1 | Basic Extractor | PROGRAM — EXTRACTOR | 1 BW, 1 RAM | End of your turn: extract 5 CRED. |

### ORIGIN Ghostware — REDLINER
**At the start of your turn, if your TRACE is 20 or more, gain 1 BW.**

**Why:** RIOT's sweet spot is TRACE 20–39: 5 BW a turn, cheap loud cards, no strike yet. Every decision becomes "how much louder can I afford to be?" The Ghostware is named after the game, and it's the Rustler who lives closest to the red line.

**Balance watch:** a RIOT turn can add 4–8 TRACE. Without LAY LOW, GHOST SIGNAL-style cards or DEAD DROP visits, RIOT will hit its first strike within 2–3 encounters. That's intended, but the Training Node playtest should confirm the pace isn't punishing.

---

## 6. VECTOR

> *"I don't break in. I wait for it to rot."*

**Playstyle:** infects ICE with viruses that lower STR over time, so off-type ICE eventually becomes weak enough to beat. Slow start, strong finish. Long encounters suit VECTOR, but PURGE ICE are its natural enemy.

### Starter deck (12)

| Qty | Card | Type / tags | Cost | Effect |
|---:|---|---|---|---|
| 1 | **STINGER** *(signature)* | PROGRAM — ICEPICK (VOID) | 1 BW, 1 RAM | STR 0 *(BASIC-001: was 2)*. Boost: 1 BW → +1 STR. Break: 1 BW. **Each break also INFECTs 1 ROT on that ICE.** |
| 1 | **RUNTIME ERROR** *(fallback)* | SCRIPT — EXPLOIT, VIRUS | 2 BW, +1 TRACE | Break 1 subroutine on **any** ICE with 2 or more virus counters. |
| 3 | **INJECT** | SCRIPT — EXPLOIT, VIRUS | 1 BW | INFECT 2 ROT. |
| 1 | **REPLICATOR** | PROGRAM — VIRUS | 1 BW, 1 RAM | Start of your turn: on every ICE with virus counters, add 1 counter of each strain already on it. |
| 1 | **OUTBREAK** | SCRIPT — VIRUS | 2 BW | Double the counters of every strain on target ICE. |
| 1 | PROBE | SCRIPT — EXPLOIT | 1 BW | Target ICE: −2 STR this encounter. |
| 2 | PULP Shield | SCRIPT — CLOAK | 1 BW | +3 SHIELD. |
| 1 | Basic Extractor | PROGRAM — EXTRACTOR | 1 BW, 1 RAM | End of your turn: extract 5 CRED. |
| 1 | GHOST SIGNAL | SCRIPT — CLOAK | 2 BW | As Generalist. |

### ORIGIN Ghostware — PATIENT ZERO
**At the start of each encounter, choose an ICE: INFECT 1 ROT on it.** *(VECTOR-001, 2026-11-14: was "on every ICE".)*

**Why:** every ICE starts at −1 STR and is already a valid target for REPLICATOR, so VECTOR's engine starts on turn 1 instead of turn 2–3. It's especially strong against multi-ICE encounters, which is where VECTOR should shine.

**VECTOR-001:** VECTOR now picks where the infection starts (usually the main ICE, or a support ICE it wants to WORM rightward from), so PATIENT ZERO is a decision rather than a blanket effect, and the encounter's virus count grows more slowly (fewer corporation PURGES).

**How VECTOR wins an encounter:** turn 1, INJECT the most dangerous ICE and install REPLICATOR. Each turn, counters grow by 1 per infected ICE. Once an ICE has 2+ counters, RUNTIME ERROR breaks any of its subroutines; once its STR is low enough, even STINGER can be boosted cheaply. OUTBREAK turns a slow infection into a sudden collapse.

---

## 7. Starter cards and the card pool

- **Starter cards are Rustler-specific:** HUSH, BACKDOOR, SLEDGE, BRUTE FORCE, STINGER and the others never appear for other Rustlers.
- **Shared basics:** PROBE, PULP Shield, GHOST SIGNAL and Basic Extractor appear in several starter decks. They are never sold or offered as rewards (BASIC-001).
- **Starter cards are the weakest cards** (Core Rules §3.1a, BASIC-001): every starter card has a clear upgrade in the reward pools, and Rustlers aim to stop drawing their original cards by the end of a run.
- **Card rewards (1 of 3; once per ICE Node since CORE-010):** proposed mix of **2 cards from the shared pool + 1 from the Rustler's own pool**, so every Rustler can branch out while staying recognizable. The pools themselves are Phase 3.

---

## 8. Unlocks and the Training Node

- **The Generalist is available from the start.** The Training Node is a Generalist-only tutorial, and its locked values were designed and frozen around the Generalist's deck.
- **Proposed unlock order:** ECHO after completing the Training Node; VECTOR after defeating the first corporation's Central Node; RIOT after defeating the second (RIOT is the hardest).
- Other Rustlers start runs at the first corporation, not the Training Node.

---

## 9. Phase 2 decision record (all APPROVED, 2026-11-12)

1. **The four Rustlers** and their identities: Generalist (balanced), ECHO (quiet), RIOT (loud), VECTOR (viruses) (§1). — **APPROVED 2026-11-12 (RUSTLER-001)**
2. **Virus rules:** named strains (ROT, SCRAMBLE, BLIND, LEECH, WORM), three timings, all strains count as virus counters, PURGE removes them (§2). — **APPROVED 2026-11-12 (RUSTLER-002)**
3. **Generalist ORIGIN — READY RIG:** start each ICE Node with one Program of your choice installed for free (§3). — **APPROVED 2026-11-12 (RUSTLER-003)**
4. **ECHO's deck and LOW PROFILE** (gain 1 less TRACE each time) (§4). — **APPROVED 2026-11-12 (RUSTLER-004)**
5. **RIOT's deck and REDLINER** (+1 BW per turn while TRACE is 20 or more) (§5). — **APPROVED 2026-11-12 (RUSTLER-005)**
6. **VECTOR's deck and PATIENT ZERO** (INFECT 1 ROT on every ICE at the start of each encounter) (§6). — **APPROVED 2026-11-12 (RUSTLER-006)**
7. **Rustler-specific starter cards**, and card rewards drawn **2 shared + 1 Rustler-specific** (§7). — **APPROVED 2026-11-12 (RUSTLER-007)**
8. **Training Node is Generalist-only**; unlock order ECHO → VECTOR → RIOT (§8). — **APPROVED 2026-11-12 (RUSTLER-008)**

**Next phase:** Phase 3 — Cards and ICE: the shared and Rustler card pools, the ICE roster for the first corporation (including PURGE ICE, Black ICE and the Tracer Bloatware), and the first Central Node.
