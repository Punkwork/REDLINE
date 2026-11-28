# PANOPTICON — PATCHWORK, GHOSTWARE, EVENTS & ESCAPE ICE
**Version:** 0.1 (Phase 5 of the simplified redesign)
**Date:** 2026-11-12
**Status:** **APPROVED 2026-11-12.** All nine Phase 5 decisions (P5-001 to P5-009) were approved by the designer (§5). P5-010 (KILLSWITCH clarifications) added and approved 2026-11-13. Builds on the approved Core Rules, Rustlers, HALCYON ICE, Card Pools, and Uplink & CAPS documents.

**Goal of this phase:** everything still missing for a complete HALCYON run: PATCHWORK upgrades, Ghostware (the payload and how to earn more), SIGNAL UNCLEAR events, and HALCYON's escape ICE.

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
| **Console Lab** | The dedicated source of PATCHWORK; services and removal cost: Core Rules §8.3. |
| **SIGNAL UNCLEAR** | The BLACK CLINIC event (§3; incidental overlap, Core Rules §8.3). |

### 1.2a FUSE (APPROVED 2026-11-12, as part of P5-001)

FUSE is a special PATCHWORK that combines **2 copies of the same SCRIPT** into **1 FUSED card** with about **1.5× the effect** and an **enhanced name**.

- **SCRIPTs only.** FUSE can't be used on PROGRAMs (Icepicks, Extractors, Hardware), PROTOCOLs or Bloatware.
- **Both copies are removed** and replaced by **1 fused card**, so your deck shrinks by one card.
- The fused card **costs the same BW** as one copy.
- **The main number(s) are multiplied by 1.5, rounded up:** SHIELD, STR reduction, CRED, TRACE removal, INFECT, cards drawn. **Costs are not multiplied** (BW, or TRACE the card adds).
- **FUSE uses the card's one PATCHWORK slot:** a fused card can't take another mod. If either copy already had a PATCHWORK, it's lost when fused; the game warns you first.
- **A fused card can't be fused again.**
- **Where:** whenever you apply a PATCHWORK (Console Lab, BLACK CLINIC; Core Rules §8.3) and you own 2 copies of a SCRIPT, **FUSE is always offered as an extra option** alongside the usual 3 mods.
- **Enhanced names:** each SCRIPT gets its own fused name, designed alongside the card. Until one is designed, it shows as **"[NAME] MK II"**.

**Fused names for starter-deck duplicates:**
| Card ×2 | Fused name | Fused effect |
|---|---|---|
| PULP Shield | **PULP BULWARK** | +5 SHIELD |
| PROBE | **NEEDLE PROBE** | Target ICE −3 STR |
| SMOKESCREEN (ECHO) | **BLACK FOG** | +3 SHIELD; the first TRACE in the next Corporation Response is reduced by 3 |
| OVERLOAD (RIOT) | **MELTDOWN** | Target ICE −3 STR, +2 TRACE |
| INJECT (VECTOR) | **MEGADOSE** | INFECT 3 ROT |

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

*Single source (CSA-06/07, designer 2026-11-28): every Ghostware is one record in `godot/data/cards.json` (`ghostware`). The tables in this doc, Deck Synergy §9.3, ICE Corp 2 §8, ICE Corp 3 §9 and the Rustlers' ORIGIN sections are generated from those records by `tools/csa/gen_card_docs.py` and checked in CI; change the record, never a table.*

- Ghostware is **permanent for the run**. There's **no limit** on how many you can have (stacking is supported; see the existing synergy principle).
- **Payload (Central Node):** choose **1 of 3**: **1 from the corporation's own set** + **2 from the general pool**. The chosen Ghostware is **active immediately**, including during the escape (P5-009; see §2.5).
- Some Ghostware has a **drawback** alongside its benefit; the drawback is shown in red on the rack.
- **ORIGIN** Ghostware (READY RIG, LOW PROFILE, REDLINER, PATIENT ZERO) is never offered as a payload.

### 2.2 General pool (20)

<!-- GENERATED:ghostware ids=SUBDERMAL_PLATING,NEURAL_BUFFER,EXPANDED_MEMORY,OVERCLOCKED_BUS,SPARE_SOCKET,DEAD_MANS_POCKET,MONEY_MULE,SIGNAL_BOOSTER,SCRAMBLED_ID,BLACK_MIRROR,BLEEDING_EDGE,BURNOUT_CHIP,KILLSWITCH,COLD_STORAGE,RECYCLER,CHAOS_ENGINE,LUCKY_STRIKE,FIRST_CONTACT,SLEEPER_AGENT,LONG_MEMORY -->
*Generated from `godot/data/cards.json` (`ghostware`) by `tools/csa/gen_card_docs.py`. Edit the Ghostware records, not this table.*

| Ghostware | Effect | Price |
|---|---|---|
| **SUBDERMAL PLATING** | At the start of each Node, gain 6 SHIELD that lasts the whole Node (not just one turn). *(From the approved GHOST-001 example.)* | 100 CRED |
| **NEURAL BUFFER** | +6 Max VITAE (and heal 6). | 100 CRED |
| **EXPANDED MEMORY** | +1 RAM. | 100 CRED |
| **OVERCLOCKED BUS** | +1 BW on the first turn of each encounter. | 100 CRED |
| **SPARE SOCKET** | +1 CAP slot. Gain a random common CAP at the start of each corporation. | 100 CRED |
| **DEAD MAN'S POCKET** | Deferred: its HOLD enhancement is inactive under HAND-CLEANUP-001. | payload only |
| **MONEY MULE** | Your Extractors extract 25% more CRED (rounded up). | 100 CRED |
| **SIGNAL BOOSTER** | You can see what's inside SIGNAL UNCLEAR Nodes before choosing them. | 100 CRED |
| **SCRAMBLED ID** | Ignore the first TRACE in each turn. You cannot reduce your TRACE. | 100 CRED |
| **BLACK MIRROR** *(drawback)* | **+1 BW every turn.** ⚠ **Start each corporation at 10 TRACE.** | 75 CRED |
| **BLEEDING EDGE** *(drawback)* | **+1 DRAW every turn.** ⚠ **−8 Max VITAE.** | 75 CRED |
| **BURNOUT CHIP** *(drawback)* | **Your Icepicks have +2 STR.** ⚠ **Whenever you take PULP damage, take 2 more.** *(GHOST-011: was 1 more.)* | 75 CRED |
| **KILLSWITCH** | Once per Node, if damage would drop your VITAE to 0, it drops to 1 instead. *(Full rules: §2.2a.)* | 100 CRED |
| **COLD STORAGE** | CACHED cards cost 1 less BW. | 100 CRED |
| **RECYCLER** | Whenever a card is BURNED, gain 1 BW (once per turn). | 100 CRED |
| **CHAOS ENGINE** | Whenever you play your 4th card in a turn, draw 1. | 100 CRED |
| **LUCKY STRIKE** | Card rewards offer 4 cards instead of 3. | 100 CRED |
| **FIRST CONTACT** | The first ICE you meet in each Node gets −2 STR. | 100 CRED |
| **SLEEPER AGENT** | At the start of each corporation, add a random rare card to your deck. | 100 CRED |
| **LONG MEMORY** *(drawback)* | **+2 RAM.** ⚠ **Your first card each turn costs 1 more BW.** | 75 CRED |
<!-- /GENERATED -->

**Reserve (not in the starting game; can be added later):**

<!-- GENERATED:ghostware ids=SIXTH_SENSE,FIELD_MEDIC,STREET_CRED,PATCH_CABLE -->
*Generated from `godot/data/cards.json` (`ghostware`) by `tools/csa/gen_card_docs.py`. Edit the Ghostware records, not this table.*

| Ghostware | Effect | Price |
|---|---|---|
| **SIXTH SENSE** | Draw 1 extra card on the first turn of each encounter. | 100 CRED |
| **FIELD MEDIC** | At every SAFEHOUSE, heal 5 extra VITAE. *(NODE-AUTHORITY-001: no longer at the DEAD DROP.)* | 100 CRED |
| **STREET CRED** | Start each corporation with 30 CRED. | 100 CRED |
| **PATCH CABLE** | Whenever you apply a PATCHWORK, heal 4 VITAE. | 100 CRED |
<!-- /GENERATED -->

### 2.2a KILLSWITCH rules (APPROVED 2026-11-13, P5-010)

1. **What it does:** when **damage** would bring your VITAE to 0 or below, your VITAE becomes **1** instead. Any damage beyond that is ignored: a PULP 20 hit at 4 VITAE leaves you at 1.
2. **Damage only:** KILLSWITCH triggers on **PULP** from ICE subroutines, Bloatware (e.g. CITATION) and reactive ICE abilities, and on any other effect that deals damage. It **does not** trigger on VITAE you choose to **pay**: BLACK MARKET BROKER (15 VITAE), BLACK CLINIC (6 VITAE), DATA PURGE (5 VITAE) or any other cost. **You can't pay a VITAE cost you can't afford:** a cost that would bring your VITAE to 0 or below can't be chosen.
3. **Once per Node:** after it triggers, KILLSWITCH is **spent** until you enter the next Node. A second lethal hit in the same Node ends the run as normal. Multi-layer ICE Nodes count as one Node.
4. **The escape:** each escape encounter is its own Node (UPL-007: a 4-Node escape), so KILLSWITCH **recharges between escape encounters**.
5. **Max VITAE:** a drop in Max VITAE (e.g. BLEEDING EDGE) is not damage. Max VITAE can't fall below 1.
6. **On screen:** the Ghostware rack shows KILLSWITCH as **READY** or **SPENT (this Node)**. When it triggers, the log shows a highlighted line, e.g. *"KILLSWITCH: lethal damage stopped at 1 VITAE."*

**Why:** KILLSWITCH is meant to turn a fatal turn into one last turn (to BREACH, JACK OUT, or use a healing CAP), not to pay for VITAE costs for free. Recharging every Node makes it a strong, steady safety net for high-risk builds (RIOT, BLEEDING EDGE, BURNOUT CHIP), without making any single encounter unlosable.

### 2.3 HALCYON set (3) — stolen smart-home tech

<!-- GENERATED:ghostware ids=HEARTH_KEY,VOICE_MIMIC,AD_BLOCKER -->
*Generated from `godot/data/cards.json` (`ghostware`) by `tools/csa/gen_card_docs.py`. Edit the Ghostware records, not this table.*

| Ghostware | Effect | Price |
|---|---|---|
| **HEARTH KEY** | At the start of each encounter, every FORTRESS gets −1 STR. *(HALCYON's master key to every door.)* | payload only |
| **VOICE MIMIC** | Once per encounter, the first TRACE subroutine that would resolve fails. | payload only |
| **AD BLOCKER** | Bloatware the corporation INSERTs always goes to your discard pile, never your hand or draw pile. | payload only |
<!-- /GENERATED -->

**Other corporations' sets:** IRONWATCH (KEVLAR WEAVE, BADGE CLONE, DASHCAM FEED) in `REDLINE_ICE_CORP2.md` §8; LUCIDA (LUCID DREAM, MEMORY BACKUP, NEURAL FIREWALL) in `REDLINE_ICE_CORP3.md` §9.

---

### 2.4 Earning Ghostware during infiltration (APPROVED 2026-11-12, P5-008)

Besides the payload, there are three ways to earn Ghostware in the 10 infiltration rows (MAP-002; was 9). Ghostware earned this way is **kept immediately**.

**1. Ghostware FRAGMENTS.** Collect **3 fragments** → choose **1 of 3 Ghostware** right away. Earn a fragment for:
- **fully extracting** an ICE layer's CRED reserve;
- a **Clean Node** (completing a Node with no TRACE gained);
- **clearing every layer** of a 3-layer ICE Node.

Fragments carry over between corporations. The fragment counter is shown beside the Ghostware rack.

**2. FIXER CONTRACTS.** At the start of each corporation, a fixer offers **2 contracts**; both can be completed. Completing one during infiltration earns **1 Ghostware** (choose 1 of 2). Contracts expire at the Central Node. Examples (working):
| Contract | Goal |
|---|---|
| **QUIET JOB** | Finish 3 ICE Nodes without TRACE reaching 20. |
| **BIG SCORE** | Extract 100 CRED before the Central Node. |
| **EXTERMINATOR** | Break 8 VOID subroutines. |
| **DEMOLITION** | Break 8 FORTRESS subroutines. |
| **CODEBREAKER** | Break 8 TUMBLER subroutines. |
| **NO LOOSE ENDS** | Clear every layer of 2 ICE Nodes. |
| **CLEAN HANDS** | Reach the Central Node without a TRACE strike. |
| **SHOPPING LIST** | Apply 2 PATCHWORK (including FUSE). |

**3. Purchase and events.**
- **Every Black Market Uplink** has a **Ghostware shelf** with **2–3 random Ghostware** for sale at **100 CRED** each (**75 CRED** for Ghostware with a drawback). This adds a fourth shelf to the Uplink layout (amends UPL-005).
- **BLACK MARKET BROKER** event (§3): a random Ghostware for **15 VITAE**, or decline.

**Expected total:** roughly **10–15 Ghostware per run** across payloads, fragments, contracts and purchases.

*LOCKBOXES (an optional extra subroutine that gives a Ghostware) were considered and set aside for now; they can be revisited after playtesting.*

### 2.5 What the payload is (APPROVED 2026-11-12, P5-009)

> **Amended by MAP-003 and SIGNAL-002 (2026-11-28):** there is no escape. Part 1 stands; part 2's doubled TRACE during the escape no longer applies. Part 3: the First Signal fragment is the corporation's **Signal barcode**, an extra item you get on beating the boss; the three barcodes overlaid form the Signal (Core Rules §10.2, SIGNAL-001/002).

Each corporation's payload is an **encrypted data core** taken from its Central Node. It has three parts:

1. **The usable part:** cracking the Central Node lets you pull usable tech out of the core: **choose 1 of 3 Ghostware**, **active immediately**, including for the escape.
2. **The unknown part:** the rest of the core stays **encrypted**. You carry it out without knowing what it holds. HALCYON is tracking its own core, which is why **TRACE gains are doubled during the escape**.
3. **The reveal:** once you've escaped, NUL/REM decrypts the core. It contains a **fragment of the First Signal**. After all three corporations, the fragments come together.

**OPEN (story):** what each Signal fragment says, how NUL/REM reacts, and what the three fragments reveal together. These belong to the World Bible and are left to the designer.

## 3. SIGNAL UNCLEAR events (10)

Each SIGNAL UNCLEAR Node holds one random event. Choices are always shown with their full costs.

**EVENT-002 — every event offers a choice, except AMBUSH (APPROVED 2026-11-18).** Designer: "Giving the rustler choices in each of these random rooms helps to make them feel less unfair." Every SIGNAL UNCLEAR event, current and future, gives the Rustler at least two options (declining counts). AMBUSH is the one exception: it stays a surprise fight.

| Event | What happens |
|---|---|
| **DATA PURGE** *(approved, UPL-006; cost changed by UPL-006a)* | Remove 1 card from your deck. Pay **+7 TRACE** or **−5 VITAE**. |
| **ABANDONED CACHE** | Choose: **+25 CRED**, or a **random CAP** (if you have a free slot). |
| **GHOST IN THE WIRES** | NUL/REM finds something strange. Choose: take a **random rare card** and **+6 TRACE**, or leave it. |
| **FRIENDLY RUSTLER** | Another Rustler offers a trade: give **1 card** from your deck, receive **1 random card one rarity higher** (rare stays rare). Or decline. |
| **HONEYPOT** | Unguarded CRED. Choose: take **40 CRED** and **+10 TRACE**, or leave it. |
| **BLACK CLINIC** | Choose: pay **6 VITAE** to apply **1 PATCHWORK**, or leave. |
| **MAINTENANCE WINDOW** *(changed by EVENT-002)* | The corporation's systems are down for a moment. Choose: **heal 6 VITAE**, or **−5 TRACE**. |
| **AMBUSH** | It was ICE all along: a **single-layer ICE encounter** from the current tier, with normal rewards. |
| **BLACK MARKET BROKER** | A dealer with something special. Choose: pay **15 VITAE** for a **random Ghostware**, or decline. |
| **CARE PACKAGE** *(new, EVENT-003; working name)* | Another crew left supplies. Choose: **+5 Max VITAE** for the rest of the run (current VITAE also rises by 5), or a **random rare card**. |

**Odds (working):** AMBUSH 20%; BLACK MARKET BROKER 5%; the other eight share the rest equally (about 9.4% each).

**Planned, in design (EVENT-004, DIRECTION 2026-11-18):** an 11th event offering a **dedicated, unusually powerful Ghostware** whose price is a **permanent Bloatware** card that can't be removed by normal means. **Each corporation has its own version.** Details are a design task in HANDOFF; not in the pool until approved.

**VITAE costs** (DATA PURGE, BLACK CLINIC, BLACK MARKET BROKER) can only be chosen if you'd be left with at least 1 VITAE. KILLSWITCH doesn't cover them (P5-010).

---

## 4. HALCYON escape ICE — the security response

> **ESCAPE-ICE-001 (designer, 2026-11-28):** with the escape retired (MAP-003), these ICE are now **regular Tier 2 ICE** for this corporation, used after the Mini-Boss (MAP-TIER-001, Core Rules §10.1). The escape layout, the doubled-TRACE notes and the 10-CRED escape reserves no longer apply; Tier 2 layers and reserves do. HOUSE CALL stays Black ICE.

When you take THE HEARTH's payload, HALCYON stops being a friendly gadget company and starts acting like a security company. Its escape ICE are the **home-security** side of its products.

| ICE | Type | STR | Subroutines | Ability | Threat* |
|---|---|---|---|---|---|
| **ALARM PANEL** | TUMBLER | 3 | [S1] TRACE 3 · [S2] DEADLOCK | — | 3 (6 while escaping) |
| **MOTION SENSOR** | VOID | 3 | [S1] PULP 3 + DEADLOCK | Whenever you install a PROGRAM: +2 TRACE. | 3+ |
| **DEADBOLT** | FORTRESS | 6 | [S1] PULP 4 · [S2] DEADLOCK | Its STR can't be reduced below 3. | 4 |
| **PANIC BUTTON** | TUMBLER | 2 | [S1] INSERT 1 TRACER into your hand · [S2] DEADLOCK | — | 2 + TRACER |
| **HOUSE CALL** *(existing Black ICE)* | VOID | 5 | [S1] PULP 4 · [S2] PULP 4 | — | 8 |

\*Remember that TRACE gains are **doubled** during the escape (UPL-007).

**Escape layout:**
| Escape encounter | ICE | CRED reserve |
|---|---|---|
| **1** | 1 random escape ICE | 10 |
| **SAFEHOUSE** | (services: Core Rules §8.3) | — |
| **2** | 2 random escape ICE | 10 |
| **3** | 1 random escape ICE + **HOUSE CALL** (support, left) | 10 |

The SAFEHOUSE's position is random (after encounter 1 or after encounter 2), and it's shown on the map. Escape encounters pay CRED but give **no card reward** (CORE-010). Each escape encounter is its own Node (UPL-007), so once-per-Node effects such as KILLSWITCH recharge between them.

**Why these ICE:** each punishes a different habit at the worst time. ALARM PANEL and PANIC BUTTON hit TRACE while it's doubled; MOTION SENSOR punishes setting up a big rig; DEADBOLT ignores your PROBE stack. HOUSE CALL in the last encounter means the corporation's hunter is waiting at the door.

This replaces the temporary arrangement in `REDLINE_ICE_CORP1.md` §8.2a.

---

## 5. Phase 5 decision record (all APPROVED, 2026-11-12)

1. **PATCHWORK rules:** one per card; choose 1 of 3 mods; Console Lab gives 1 free PATCHWORK *or* a card removal for 40 CRED *(removal cost superseded by NODE-AUTHORITY-001: Core Rules §8.3)*; plus **FUSE** (2 copies of a SCRIPT → 1 fused card at 1.5×, with an enhanced name; SCRIPTs only) (§1.1, §1.2, §1.2a). — **APPROVED 2026-11-12 (P5-001)**
2. **The 12 PATCHWORK mods** (§1.3). — **APPROVED 2026-11-12 (P5-002)**
3. **Ghostware rules:** no limit; payload is 1 corporation-specific + 2 general; some with drawbacks; ORIGIN never offered (§2.1). — **APPROVED 2026-11-12 (P5-003)**
4. **The 20 general Ghostware** (§2.2), with 4 more held in reserve. — **APPROVED 2026-11-12 (P5-004)**
5. **The 3 HALCYON Ghostware** (§2.3), with VOICE MIMIC worded as "fails". — **APPROVED 2026-11-12 (P5-005)**

   **Design note (P5-005):** TRACE subroutines may later be able to **succeed or fail** as a mechanic in their own right. A trace reduced to 0 is not the same as a trace that **fails**: effects that say "fails" stop the trace entirely, while effects that reduce TRACE only change the amount. Future card wording should keep the two distinct.
6. **The 9 SIGNAL UNCLEAR events** and their odds (§3). — **APPROVED 2026-11-12 (P5-006)**; now 10 (EVENT-003) with a choice in every event but AMBUSH (EVENT-002), 2026-11-18
7. **HALCYON escape ICE** and the escape layout (§4). — **APPROVED 2026-11-12 (P5-007)**
8. **Earning Ghostware during infiltration:** fragments, fixer contracts, and 2–3 Ghostware for sale at every Uplink (100 / 75 CRED) plus the BLACK MARKET BROKER event (§2.4). — **APPROVED 2026-11-12 (P5-008)**
9. **The payload is an encrypted data core:** 1 of 3 Ghostware active immediately (usable during the escape); the rest stays encrypted until you escape and is then decrypted as a First Signal fragment; fragment content left OPEN (§2.5). Supersedes "keep the payload only if you escape" (UPL-007). — **APPROVED 2026-11-12 (P5-009)**

### Later amendments (2026-11-13)

| ID | Change to this document |
|---|---|
| P5-010 | **KILLSWITCH clarified** (§2.2a): triggers on damage only, never on VITAE you pay; VITAE costs can't be chosen if they'd leave you below 1 VITAE; once per Node (a multi-layer Node counts as one); recharges between escape encounters (each is a Node); Max VITAE loss isn't damage; READY / SPENT shown on the rack, highlighted log line when it triggers. — **APPROVED 2026-11-13** |

### Later amendments (deck synergy and pacing, APPROVED 2026-11-15)

The designer approved `REDLINE_DECK_SYNERGY.md` (DSY-001 to DSY-014) and `REDLINE_PACING.md` (PACE-001 to PACE-010) as written, for the next build. **Where these amendments conflict with the text above, the amendments win;** the full rules are in those two docs.

| ID | Change to this document |
|---|---|
| DSY-004 | **COMPILE** (alongside FUSE, §1.2a): 2 different SCRIPTs that share a tag become 1 card; summed cost (max 4 BW), both effects and tags; uses the PATCHWORK slot. — **APPROVED 2026-11-15** |
| DSY-012 | **DEAD MAN'S POCKET** becomes "you may CACHE up to 2 cards for free each turn" (§2.2), since HOLD 1 gave everyone 1. — **SUPERSEDED by HAND-CLEANUP-001** |
| DSY-001 / DSY-007 | New Ghostware candidates for the general pool: HEARTBEAT, MINIMAL INSTALL, DEDUPLICATOR, ONE-TRICK (`REDLINE_DECK_SYNERGY.md` §9.3). — **APPROVED 2026-11-15** |
| PACE-006 | Safety valves held in reserve: Max VITAE 35 → 40, full-clear heal 3, a second SAFEHOUSE; used only if playtests run hot. — **APPROVED 2026-11-15** |
| ROT-001 sync | Remaining SIGYL labels changed to **TUMBLER** (ICE types, Icepicks, card text). No numbers changed. — designer instruction 2026-11-16 |


## NODE-PURPOSE-001 — Non-combat Node service redesign (APPROVED 2026-11-27)

*Reference only (NODE-AUTHORITY-001): current Node purposes and services are defined in Core Rules §8.3 ([Node authority](REDLINE_CORE_RULES.md#node-authority)); the decision and its history are in Master Design. The copy that stood here was retired (git history keeps it).*
