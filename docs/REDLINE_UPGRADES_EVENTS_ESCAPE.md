# REDLINE — PATCHWORK, GHOSTWARE, EVENTS & ESCAPE ICE
**Version:** 0.1 DRAFT (Phase 5 of the simplified redesign)
**Date:** 2026-11-12
**Status:** **DRAFT FOR APPROVAL.** Builds on the approved Core Rules, Rustlers, HALCYON ICE, Card Pools, and Uplink & CAPS documents. Nothing here is approved until the designer signs off on this phase (§5).

**Goal of this phase:** everything still missing for a complete HALCYON run: PATCHWORK upgrades, the Ghostware payload, SIGNAL UNCLEAR events, and HALCYON's escape ICE.

**Keeps the existing canon:** PATCHWORK belongs to **one specific copy** of a card, never all copies (PROG-002, RULE-061). Ghostware is **permanent and not a card**, shown on the Ghostware rack with ORIGIN marked once (PROG-003, UI-002). Node-long protection from Ghostware follows GHOST-001.

> All numbers are **working values** for playtesting.

---

## 1. PATCHWORK

### 1.1 Rules
- **One PATCHWORK per card.** A patched card shows its mod name and a marker on the card frame.
- **How you apply it:** choose a card in your deck, then choose **1 of 3 mods** offered for that card. Only mods that make sense for that card are offered.
- **Bloatware can't be patched.**
- A PATCHWORK lasts for the whole run. If the card is removed from your deck, the PATCHWORK goes with it.

### 1.2 Where you get PATCHWORK
| Source | How |
|---|---|
| **Console Lab** | Choose one: **apply 1 PATCHWORK free**, or **remove a card for 40 CRED** (CARD-002). |
| **SAFEHOUSE** | Choose one: **heal 10 VITAE**, or **apply 1 PATCHWORK** (UPL-007). |
| **Node completion reward** | One of the choices is a free PATCHWORK (Core Rules §9.3). |
| **SIGNAL UNCLEAR** | The BLACK CLINIC event (§3). |

### 1.3 The mods (12)

**Any card**
| Mod | Effect |
|---|---|
| **OPTIMIZED** | Costs 1 less BW (minimum 0). *Not offered on 0-BW cards.* |
| **SILENCED** | Adds 2 less TRACE (minimum 0). *Only offered on cards that add TRACE.* |
| **HARDENED** | Also gives +2 SHIELD when played or installed. |
| **LINKED** | Also draws 1 card when played or installed. *Not offered on cards that already draw.* |

**PROGRAMS**
| Mod | Effect |
|---|---|
| **COMPRESSED** | Uses 1 less RAM (minimum 0). |
| **PRELOADED** | At the start of each ICE Node, this Program can be installed for free instead of being shuffled into your deck. *(Stacks with READY RIG: you can preload more than one.)* |

**Icepicks**
| Mod | Effect |
|---|---|
| **TUNED** | +1 base STR. |
| **STREAMLINED** | Each boost gives +1 extra STR. |

**Extractors**
| Mod | Effect |
|---|---|
| **DEEP DIG** | Extracts +2 CRED each time. |

**SCRIPTS**
| Mod | Effect |
|---|---|
| **AMPLIFIED** | The card's main number is increased by half, rounded up: SHIELD, STR reduction, TRACE removal, CRED, or cards drawn. *E.g. PULP Shield +3 → +5; PROBE −2 → −3.* |
| **STICKY** | When drawn, this card is automatically CACHED. |

**VIRUS cards**
| Mod | Effect |
|---|---|
| **VIRULENT** | INFECT 1 more counter of each strain the card places. |

---

## 2. GHOSTWARE

### 2.1 Rules
- Ghostware is **permanent for the run**. There's **no limit** on how many you can have (stacking is supported; see the existing synergy principle).
- **Payload (Central Node):** choose **1 of 3**: **1 from the corporation's own set** + **2 from the general pool**. You **keep it only if you complete the escape** (UPL-007).
- Some Ghostware has a **drawback** alongside its benefit; the drawback is shown in red on the rack.
- **ORIGIN** Ghostware (READY RIG, LOW PROFILE, REDLINER, PATIENT ZERO) is never offered as a payload.

### 2.2 General pool (14)

| Ghostware | Effect |
|---|---|
| **SUBDERMAL PLATING** | At the start of each Node, gain **6 SHIELD that lasts the whole Node** (not just one turn). *(From the approved GHOST-001 example.)* |
| **NEURAL BUFFER** | +6 Max VITAE (and heal 6). |
| **EXPANDED MEMORY** | +1 RAM. |
| **SIXTH SENSE** | Draw 1 extra card on the first turn of each encounter. |
| **OVERCLOCKED BUS** | +1 BW on the first turn of each encounter. |
| **SPARE SOCKET** | +1 CAP slot. Gain a random common CAP at the start of each corporation. |
| **DEAD MAN'S POCKET** | Once per turn, you may CACHE 1 card for free. |
| **MONEY MULE** | Your Extractors extract 25% more CRED (rounded up). |
| **SIGNAL BOOSTER** | You can see what's inside SIGNAL UNCLEAR Nodes before choosing them. |
| **SCRAMBLED ID** | The first TRACE strike in each corporation has no penalty (TRACE still drops to 20). |
| **FIELD MEDIC** | At every SAFEHOUSE and DEAD DROP, heal 5 extra VITAE. |
| **BLACK MIRROR** *(drawback)* | **+1 BW every turn.** ⚠ Start each corporation at **10 TRACE**. |
| **BLEEDING EDGE** *(drawback)* | **+1 DRAW every turn.** ⚠ **−8 Max VITAE.** |
| **BURNOUT CHIP** *(drawback)* | **Your Icepicks have +2 STR.** ⚠ Whenever you take PULP damage, take 1 more. |

### 2.3 HALCYON set (3) — stolen smart-home tech

| Ghostware | Effect |
|---|---|
| **HEARTH KEY** | At the start of each encounter, every WALL gets −1 STR. *(HALCYON's master key to every door.)* |
| **VOICE MIMIC** | Once per encounter, the first TRACE subroutine that would resolve adds nothing. |
| **AD BLOCKER** | Bloatware the corporation INSERTs always goes to your discard pile, never your hand or draw pile. |

---

## 3. SIGNAL UNCLEAR events (8)

Each SIGNAL UNCLEAR Node holds one random event. Choices are always shown with their full costs.

| Event | What happens |
|---|---|
| **DATA PURGE** *(approved, UPL-006)* | Remove 1 card from your deck. Pay **+5 TRACE** or **−5 VITAE**. |
| **ABANDONED CACHE** | Choose: **+25 CRED**, or a **random CAP** (if you have a free slot). |
| **GHOST IN THE WIRES** | NUL/REM finds something strange. Choose: take a **random rare card** and **+6 TRACE**, or leave it. |
| **FRIENDLY RUSTLER** | Another Rustler offers a trade: give **1 card** from your deck, receive **1 random card one rarity higher** (rare stays rare). Or decline. |
| **HONEYPOT** | Unguarded CRED. Choose: take **40 CRED** and **+10 TRACE**, or leave it. |
| **BLACK CLINIC** | Choose: pay **6 VITAE** to apply **1 PATCHWORK**, or leave. |
| **MAINTENANCE WINDOW** | The corporation's systems are down for a moment: **heal 6 VITAE** and **−5 TRACE**. No choice needed. |
| **AMBUSH** | It was ICE all along: a **single-layer ICE encounter** from the current tier, with normal rewards. |

**Odds (working):** AMBUSH 20%; the other seven share the rest equally.

---

## 4. HALCYON escape ICE — the security response

When you take THE HEARTH's payload, HALCYON stops being a friendly gadget company and starts acting like a security company. Its escape ICE are the **home-security** side of its products.

| ICE | Type | STR | Subroutines | Ability | Threat* |
|---|---|---|---|---|---|
| **ALARM PANEL** | CODE GATE | 3 | [S1] TRACE 3 · [S2] DEADLOCK | — | 3 (6 while escaping) |
| **MOTION SENSOR** | SENTRY | 3 | [S1] PULP 3 + DEADLOCK | Whenever you install a PROGRAM: +2 TRACE. | 3+ |
| **DEADBOLT** | WALL | 6 | [S1] PULP 4 · [S2] DEADLOCK | Its STR can't be reduced below 3. | 4 |
| **PANIC BUTTON** | CODE GATE | 2 | [S1] INSERT 1 TRACER into your hand · [S2] DEADLOCK | — | 2 + TRACER |
| **HOUSE CALL** *(existing Black ICE)* | SENTRY | 5 | [S1] PULP 4 · [S2] PULP 4 | — | 8 |

\*Remember that TRACE gains are **doubled** during the escape (UPL-007).

**Escape layout:**
| Escape encounter | ICE | CRED reserve |
|---|---|---|
| **1** | 1 random escape ICE | 10 |
| **SAFEHOUSE** | (heal 10 VITAE or 1 PATCHWORK) | — |
| **2** | 2 random escape ICE | 10 |
| **3** | 1 random escape ICE + **HOUSE CALL** (support, left) | 10 |

The SAFEHOUSE's position is random (after encounter 1 or after encounter 2), and it's shown on the map.

**Why these ICE:** each punishes a different habit at the worst time. ALARM PANEL and PANIC BUTTON hit TRACE while it's doubled; MOTION SENSOR punishes setting up a big rig; DEADBOLT ignores your PROBE stack. HOUSE CALL in the last encounter means the corporation's hunter is waiting at the door.

This replaces the temporary arrangement in `REDLINE_ICE_CORP1.md` §8.2a once approved.

---

## 5. Decisions for you in this phase

Approve, change or reject each:

1. **PATCHWORK rules:** one per card; choose 1 of 3 mods; Console Lab gives 1 free PATCHWORK *or* a card removal for 40 CRED (§1.1, §1.2).
2. **The 12 PATCHWORK mods** (§1.3).
3. **Ghostware rules:** no limit; payload is 1 corporation-specific + 2 general; some with drawbacks; ORIGIN never offered (§2.1).
4. **The 14 general Ghostware** (§2.2).
5. **The 3 HALCYON Ghostware** (§2.3).
6. **The 8 SIGNAL UNCLEAR events** and their odds (§3).
7. **HALCYON escape ICE** and the escape layout (§4).
