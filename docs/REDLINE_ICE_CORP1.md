# REDLINE — ICE: FIRST CORPORATION
**Version:** 0.1.1 (Phase 3A of the simplified redesign)
**Date:** 2026-11-12
**Status:** **APPROVED 2026-11-12.** All eight Phase 3A decisions (ICE-001 to ICE-008) were approved by the designer (§10). Builds on `REDLINE_CORE_RULES.md` v0.2 and `REDLINE_RUSTLERS.md` v0.1. **v0.1.1:** tier rows and escape encounters updated to match the approved map structure (UPL-007).

**Goal of this phase:** a complete set of ICE for the first corporation, with clear rules for designing ICE in later corporations.

> All numbers are **working values** for playtesting. The Training Node ICE (WHITE PICKET FENCE, TOLLBOOTH, MEATGRINDER, OVERCLOCK, HOTWIRE, WATCHDOG) are unchanged and remain the tutorial's own set.

---

## 1. The first corporation: HALCYON (working name)

**Who they are:** a consumer smart-home company. Doorbells, thermostats, speakers, baby monitors: friendly devices in every home, all quietly recording. HALCYON doesn't need guards with guns; it already knows everything about you.

**Why it fits PANOPTICON:** the first corporation shows the most ordinary form of surveillance, the kind people invite into their homes. Its ICE are named after everyday devices and agreements.

**How it plays:**
- **Lots of TRACE and Bloatware**, light PULP. It teaches the TRACE meter and strikes before damage becomes deadly.
- **SPAM** is HALCYON's signature Bloatware: junk that clogs your hand until you pay to clear it.
- **First VOID appears late** (HOME ASSISTANT), as a warning of what's to come.

### The three-corporation arc
| Corporation | Theme | Main threat | Difficulty |
|---|---|---|---|
| **1. HALCYON** | Consumer surveillance | TRACE, Bloatware | Introductory |
| **2. IRONWATCH** | Private security and enforcement | PULP, aggressive Sentries | Mid |
| **3. LUCIDA** | Neural interfaces | VOID, FORGET (ICE that rewire your deck) | Hard |

IRONWATCH and LUCIDA are designed in `REDLINE_ICE_CORP2.md` and `REDLINE_ICE_CORP3.md` (approved 2026-11-13).

Each corporation teaches and then tests one main threat, ending with VOID, the game's most frightening damage.

---

## 2. ICE design rules (all corporations)

### 2.1 Threat budget
To keep ICE comparable, each effect has a **threat value**. The total threat of an ICE's subroutines is what it costs you if you break nothing.

| Effect | Threat |
|---|---|
| PULP 1 | 1 |
| TRACE 1 | 1 |
| DISCARD 1 | 2 |
| INSERT 1 Bloatware | 2 (3 if into draw pile) |
| VOID 1 | 4 |
| DEADLOCK | 0 (it blocks BREACH but does nothing on its own) |

### 2.2 Tiers
| Tier | Where | STR | Threat per Corporation Response | Reactive abilities |
|---|---|---|---|---|
| **Tier 1** | Infiltration rows 2–5 (MAP-002) | 2–5 | 2–5 | At most 1, mild |
| **Tier 2** | Infiltration rows 6–9 (MAP-002), and the escape | 3–6 | 4–8 | At most 1 |
| **Boss** | Central Node | 6+ | 10–15 (whole encounter) | Yes |

### 2.3 Type identities
- **WALL:** high STR, 1–2 subroutines. Hard to get into, not very dangerous once you're there.
- **CODE GATE:** lower STR, 2–3 subroutines. Easy to reach, more to break.
- **SENTRY:** medium STR, the most dangerous effects and reactive abilities.

### 2.4 Other rules
- Every ICE that can be the **main ICE** has at least one DEADLOCK. **Support ICE** may have none.
- **One reactive ability per ICE at most**, written in one sentence and shown on the ICE.
- Each ICE should **test something specific** (a Rustler, a card type or a habit), noted in the roster.

---

## 3. New ICE effects

| Effect | What happens |
|---|---|
| **INSERT X [card]** | Put X copies of that Bloatware into the stated place: your **draw pile** (shuffled in), **discard pile**, or **hand**. |
| **PURGE** | Remove all virus counters of every strain from this ICE (approved in RUSTLER-002). |
| **PURGE ALL** | Remove all virus counters from **every** ICE in the encounter. Tier 2 or boss only. |
| **+X STR** | This ICE gains X STR for the rest of the encounter. |

---

## 4. Bloatware

| Card | Type | Effect | Source |
|---|---|---|---|
| **SPAM** | BLOATWARE | Can't be played normally. **Pay 1 BW to clear it:** it's BURNED for the rest of the Node. | HALCYON ICE |
| **TRACER** | BLOATWARE | Can't be played. **If TRACER is in your hand at the end of your turn: +3 TRACE.** | 1st TRACE strike (Core Rules §7) |

**Why SPAM works:** clearing it costs BW, and ignoring it shrinks your effective hand. It's a small, constant tax that grows if you let it pile up, like junk mail.

**Why TRACER works:** it pushes you toward the 2nd strike unless you get rid of it fast, which you can't, so you have to play around it.

Both are removed at the end of the Node, as with all Bloatware.

---

## 5. HALCYON ICE roster

### Tier 1 (rows 2–5)

| ICE | Type | STR | Subroutines | Reactive ability | Threat | Tests |
|---|---|---|---|---|---|---|
| **COOKIE WALL** | WALL | 3 | [S1] TRACE 2 · [S2] DEADLOCK | — | 2 | Basic WALL breaking |
| **TERMS OF SERVICE** | WALL | 5 | [S1] INSERT 1 SPAM into your discard pile · [S2] DEADLOCK | — | 2 | PROBE and boosting against high STR |
| **CONSENT FORM** | CODE GATE | 2 | [S1] TRACE 1 · [S2] TRACE 1 · [S3] DEADLOCK | — | 2 | Many small breaks; rewards ECHO's LOW PROFILE |
| **CAPTCHA** | CODE GATE | 3 | [S1] DISCARD 1 · [S2] PULP 2 · [S3] DEADLOCK | — | 4 | Choosing which subroutine to break |
| **DOORBELL CAM** | SENTRY | 2 | [S1] TRACE 3 + DEADLOCK | Whenever you play a CLOAK card: TRACE 1. | 3 | Over-hiding (ECHO) |

### Tier 2 (rows 6–9)

| ICE | Type | STR | Subroutines | Reactive ability | Threat | Tests |
|---|---|---|---|---|---|---|
| **SMART LOCK** | WALL | 6 | [S1] PULP 3 + DEADLOCK | At the end of each Corporation Response: +1 STR. | 3, rising | Long stays; extracting too long |
| **PANIC ROOM** | WALL | 4 | [S1] PULP 4 · [S2] DEADLOCK · [S3] DEADLOCK | — | 4 | Two DEADLOCKs; WALL Icepick's free break |
| **LOYALTY PROGRAM** | CODE GATE | 3 | [S1] INSERT 1 SPAM into your draw pile · [S2] TRACE 2 + DEADLOCK | — | 5 | Bloatware pressure across layers |
| **FIRMWARE UPDATE** | CODE GATE | 4 | [S1] PURGE ALL · [S2] PULP 3 · [S3] DEADLOCK | — | 3 + anti-virus | VECTOR (break [S1] first or lose your counters) |
| **NANNY CAM** | SENTRY | 3 | [S1] PULP 3 · [S2] TRACE 2 + DEADLOCK | Whenever you install a PROGRAM: +1 STR. | 5 | Installing everything at once (Generalist) |
| **HOME ASSISTANT** | SENTRY | 4 | [S1] VOID 1 · [S2] PULP 2 + DEADLOCK | — | 6 | First VOID: break [S1] or lose a card per draw |
| **REPO DRONE** | SENTRY | 3 | [S1] PULP 4 · [S2] PULP 4 + DEADLOCK | While your TRACE is 20 or more, its PULP subroutines deal +2. | 8 | High TRACE (RIOT) |

---

## 6. Black ICE: HOUSE CALL

Joins on the left at the **2nd TRACE strike** (Core Rules §7).

| ICE | Type | STR | Subroutines | Threat |
|---|---|---|---|---|
| **HOUSE CALL** | SENTRY | 5 | [S1] PULP 4 · [S2] PULP 4 | 8 |

- **No DEADLOCK:** it doesn't block BREACH. You can race to BREACH (skipping the final Corporation Response) instead of fighting it.
- It stays for the rest of the encounter. Broken subroutines stay broken, so breaking both makes it harmless.
- HOUSE CALL is HALCYON's Black ICE. Each corporation will have its own.

---

## 7. Central Node: THE HEARTH

HALCYON's home-assistant AI, the voice in every house. A three-ICE boss encounter, left to right:

| Position | ICE | Type | STR | Subroutines | Reactive ability |
|---|---|---|---|---|---|
| Left (support) | **SMART SPEAKER** | CODE GATE | 2 | [S1] INSERT 1 SPAM into your draw pile · [S2] TRACE 2 | — |
| Middle (support) | **THERMOSTAT** | CODE GATE | 3 | [S1] PULP 2 · [S2] THE HEARTH +1 STR | — |
| Right (main) | **THE HEARTH** | SENTRY | 6 | [S1] PULP 4 · [S2] TRACE 3 · [S3] DEADLOCK · [S4] DEADLOCK | At the end of each Corporation Response: +1 STR. |

- **Threat per Corporation Response:** about 14 if nothing is broken, and THE HEARTH grows each round (from its ability and THERMOSTAT).
- **The fight's question:** break the supports first to slow THE HEARTH's growth, or rush THE HEARTH's two DEADLOCKs before it gets too strong?
- **CRED reserve:** 35 *(was 40; lowered by UPL-008)*.
- **Reward:** choose 1 of 3 Ghostware (Core Rules §10.2).

---

## 8. Building encounters

### 8.1 Composition by Node
| Node | Layers | ICE per layer |
|---|---|---|
| Rows 2–5 (Tier 1) | 1–2 | 1 main; sometimes 1 support in layer 2 |
| Rows 6–9 (Tier 2) | 2–3 | 1–2; layer 3 can have 2 supports + main |
| Central | 1 | THE HEARTH encounter |

Support ICE are drawn from the same roster (a Tier 1 ICE can support a Tier 2 main). ICE always work exactly as printed: a support ICE's DEADLOCKs must also be broken to BREACH. Multi-ICE layers therefore take longer, which is why they have bigger CRED reserves.

### 8.2 CRED reserves (working values) [CHANGED by UPL-008]
| | Layer 1 | Layer 2 | Layer 3 |
|---|---|---|---|
| Tier 1 Node | 10 | 15 | — |
| Tier 2 Node | 15 | 20 | 30 |
| Central Node | 35 | — | — |
| Escape encounter | 10 | — | — |

Lowered about 20% from the ICE-008 values (Tier 1: 15/20, Tier 2: 20/25/35, Central 40) so a corporation's CRED buys about 2–3 cards at the raised prices (UPL-008). The Training Node uses its own 10/15/25 (Master Design, Training Node CRED schedule).

| Opening Node (row 1) | 15 | — | — |

### 8.2a Escape encounters (map structure from UPL-007)
The escape (Core Rules §10.3) has **3 single-layer encounters** built from the corporation's **countermeasure ICE**, with TRACE gains doubled. For HALCYON, the escape uses its dedicated **security response** ICE (ALARM PANEL, MOTION SENSOR, DEADBOLT, PANIC BUTTON) with **HOUSE CALL** in the final encounter: see `REDLINE_UPGRADES_EVENTS_ESCAPE.md` §4 (approved P5-007).

### 8.3 Example encounters
- **Node 2, layer 1:** CAPTCHA alone. Reserve 10.
- **Node 5, layer 2:** CONSENT FORM (support) + NANNY CAM (main). Reserve 20.
- **Node 6, layer 3:** COOKIE WALL (support) + LOYALTY PROGRAM (support) + HOME ASSISTANT (main). Reserve 30.

---

### 8.4 Opening Node: COOKIE BANNER (row 1, OPEN-001)

HALCYON's consent banner: two buttons that look the same. Every route starts here (Core Rules §10.1a).

| Position | ICE | Type | STR | Subroutines | Ability |
|---|---|---|---|---|---|
| Left (support) | **ACCEPT ALL** | CODE GATE | 3 | [S1] INSERT 1 SPAM into your draw pile · [S2] TRACE 1 | — |
| Right (main) | **REJECT ALL** | CODE GATE | 3 | [S1] TRACE 2 · [S2] DEADLOCK | **BOOTING:** its DEADLOCK can't be broken before your 3rd turn of the encounter. |

**BOOTING** (Opening Node main ICE only, OPEN-001): *its DEADLOCK can't be broken before your 3rd turn of the encounter.* This is the main ICE's one ability. Support ICE in an Opening Node have no DEADLOCK.

- **The lesson:** the twins are almost identical. The one difference is that **only REJECT ALL has a DEADLOCK**: accepting is easy, rejecting is what gets you through. Only DEADLOCKs block BREACH, so read every ICE.
- **The decisions (turns 1–2):** break ACCEPT ALL's SPAM before it clogs your deck, or spend the BW on an Extractor (reserve 15), PULP Shields or GHOST SIGNAL? Turn 3: break REJECT ALL's DEADLOCK, or stay to extract the rest?
- **CRED reserve:** 15. Rewards as a normal 1-layer Node.
- **Measured** (starter decks, rushing test bot): Generalist and ECHO 3 turns; RIOT about 4; VECTOR about 6.5 (no CODE GATE Icepick; RUNTIME ERROR needs INJECT first). Average about 4.

## 9. Every Rustler has a way through

| Rustler | Easy against | Hard against | Their answer |
|---|---|---|---|
| **Generalist** | Everything Tier 1 | NANNY CAM (punishes installing many Programs) | READY RIG installs one Program before the encounter starts |
| **ECHO** | CONSENT FORM, DOORBELL CAM (LOW PROFILE cancels TRACE 1) | WALLs, SMART LOCK, REPO DRONE | PROBE + BACKDOOR; SLOW DRIP rewards quiet layers |
| **RIOT** | WALLs (SLEDGE), SMART LOCK (fast breaks) | REPO DRONE at high TRACE, CODE GATES | LAY LOW to drop under 20 TRACE; BRUTE FORCE |
| **VECTOR** | Multi-ICE layers, THE HEARTH's supports | FIRMWARE UPDATE (PURGE ALL) | Break FIRMWARE UPDATE's [S1] first with RUNTIME ERROR |

---

## 10. Phase 3A decision record (all APPROVED, 2026-11-12)

1. **HALCYON** as the first corporation (consumer smart-home surveillance), and the three-corporation arc: TRACE → PULP → VOID (§1). — **APPROVED 2026-11-12 (ICE-001)**
2. **ICE design rules:** threat budget, tiers, type identities, one reactive ability maximum (§2). — **APPROVED 2026-11-12 (ICE-002)**
3. **New effects:** INSERT, PURGE ALL, +X STR (§3). — **APPROVED 2026-11-12 (ICE-003)**
4. **Bloatware:** SPAM (pay 1 BW to clear) and TRACER (+3 TRACE if held at end of turn) (§4). — **APPROVED 2026-11-12 (ICE-004)**
5. **The 12-ICE HALCYON roster** (§5). — **APPROVED 2026-11-12 (ICE-005)**
6. **Black ICE: HOUSE CALL** (no DEADLOCK) (§6). — **APPROVED 2026-11-12 (ICE-006)**
7. **Central Node: THE HEARTH** with SMART SPEAKER and THERMOSTAT (§7). — **APPROVED 2026-11-12 (ICE-007)**
8. **Encounter composition and CRED reserves** (working values) (§8). — **APPROVED 2026-11-12 (ICE-008)**; reserves **lowered by UPL-008**
9. **Opening Node: COOKIE BANNER** (ACCEPT ALL + REJECT ALL, BOOTING) (§8.4). — **APPROVED 2026-11-13 (OPEN-002)**

**Next:** Phase 3B — card pools: shared reward cards and Rustler-specific cards, including cards for the virus strains SCRAMBLE, BLIND, LEECH and WORM.
