# PANOPTICON — ENCOUNTER PACING & SCALING
**Version:** 1.0 (approved)
**Date:** 2026-11-15
**Status:** **APPROVED 2026-11-15** (designer: "Approve everything as written"), all decisions PACE-001 to PACE-010, **to be implemented in the next build**. Numbers stay **working values**; conditional items stay conditional as written (PACE-003's BOOTING change, PACE-006's safety valves). Decision record in §10. Builds on the approved Core Rules, ICE (all three corporations), Card Pools and Uplink & CAPS documents, and on `REDLINE_ENGINES.md` and `REDLINE_DECK_SYNERGY.md`.

**Designer's goal (2026-11-15):** encounters should last **4–5 turns in the early game** and **5–8 turns in the mid to late game**. Rustlers shouldn't die because encounters are longer, and their deck builds should scale so they can BREACH stronger ICE.

> All numbers are **working values** for playtesting. **Replaces** the encounter-length targets of 3–4 turns (Core Rules §10.5, checklist C1).

**v0.2 changes (synced with build 0.2.0-playtest.2 and the 2026-11-14 decisions):** "where the game is today" now uses the slice's actual ICE (TUNE-001, ROT-001, VOID-001, PULP-002, PASSIVE-001) and the bot results, which show the slice is **more deadly** than this budget, not too short (§2); TUMBLER rotation and VOID reveal added as the first pacing levers (§3); ESCALATE narrowed, because PULP curves (PULP-002) and HARDENING already do most of its job (§4.2); fallback STR limits updated for BORROWED CREDENTIALS (ECHO-005) (§3); DRAW 6 (DRAW-001) and CORE-011 / EXTRACT-002 noted where they matter (§6.1, §7).
**v0.1.1:** §6.1 updated for the deck-size targets (30–35 cards by the end of LUCIDA, DSY-006).

---

## 1. The pacing model

ICE have no HP, so an encounter doesn't end when something runs out of health. It ends when every DEADLOCK is broken. Its length is roughly:

> **Turns ≈ BREACH WORK ÷ (OUTPUT − DEFENCE)**, but never fewer than the turns the ICE take to **show** their DEADLOCKs (TUMBLER rotation, VOID reveal, BOOTING).

| Term | Meaning |
|---|---|
| **BREACH WORK** | The BW needed to reach and break every DEADLOCK in the layer: STR boosts plus break costs (including TOLL), using the Icepicks a typical deck has at that stage. Installing Icepicks counts once. |
| **OUTPUT** | The BW-equivalent a typical deck produces per turn: 4 BW, plus what engines, AMP, cheaper breaks, CHAIN bonuses and per-turn SHIELD save or add. DRAW 6 (DRAW-001) means more cards than BW, so OUTPUT is limited by BW, not by cards. |
| **DEFENCE** | The BW spent answering threat each turn. With the value guide (CARD-001: 1 BW ≈ 3 SHIELD), that's **threat per Corporation Response ÷ 3**, minus threat already handled by engines or broken subroutines. |
| **REVEAL FLOOR** | The earliest turn the last DEADLOCK can be broken: when a TUMBLER rotates it into a slot (ROT-001), when a VOID first fires it (VOID-001), or BOOTING's turn. |

**Design rule:** pace every ICE layer for an **on-curve deck** at that stage. A stronger deck finishes 1–2 turns faster (the reward for building well). A weaker deck takes longer and bleeds VITAE (the warning that the build is behind).

---

## 2. Pacing targets by stage (PACE-001)

| Stage | Where | Target turns | OUTPUT | Threat per response | DEFENCE | Left for breaking | BREACH WORK |
|---|---|---|---|---|---|---|---|
| **Early** | Opening Node + HALCYON Tier 1 | **4–5** | 4 | ~3 | 1 | 3 | **12–15** |
| **Early–mid** | HALCYON Tier 2 | **5** | 5–6 | 5–6 | ~2 | ~3.75 | **18–20** |
| **Mid** | IRONWATCH | **5–7** | 7–8 | 8–9 | ~3 | ~4.75 | **25–35** |
| **Late** | LUCIDA | **6–8** | 9–10 | 10–12 | ~4 | ~5.5 | **35–45** |
| **Boss** | Central Nodes | **7–8** | stage OUTPUT | stage +3 | — | — | **stage × 1.3** |
| **Escape** | Countermeasure ICE | **4–5** | stage OUTPUT | stage | — | — | **stage × 0.7** |

**Why the escape is shorter:** TRACE is doubled and there's no leaving early, so long escape encounters would stack TRACE strikes. The escape should feel like a sprint.

### 2.1 Where the game is today (playtest slice 0.2.0-playtest.2)
The HALCYON slice ICE are already much heavier than the original roster (`REDLINE_ICE_CORP1.md` §5.0): STR **4–7**, **3–5 subroutines**, and **two DEADLOCKs** on every TUMBLER (REJECT ALL, CONSENT FORM, CAPTCHA), which only become breakable as they rotate into a slot. Passives (TOLL, SEQUENCED, HARDENING) add more work. So the slice is probably **already near 4–5 turns** for BREACH WORK and the reveal floor.

What it isn't near is the **damage budget**. The 30-run bot tests (DRAW 6 + PULP curves, PULP-002) put **PULP reaching VITAE at 6.7–9.3 per encounter**, with clear rates of 1–10 out of 30 depending on the Rustler. The VITAE budget below (§4.1) is **2–3 per early encounter**.

Two things to keep in mind:
- **The bot plays worse than a person** (it plays every cheap card, DRAW-001), so real play will lose less VITAE than the bot did.
- **The designer raised PULP on purpose** ("still not enough PULP", PULP-002). The budget in §4.1 is a working value; settle it against **measured turns and VITAE per encounter in real play** (checklist C1 and C9) before changing either the ICE or the budget.

**For the HALCYON slice, the first job is to measure, not to lengthen:** record turns and VITAE lost per encounter in playtest 2, then score each layer (§9).

---

## 3. Raising BREACH WORK fairly (PACE-002, PACE-003)

Raising STR alone breaks the game: fallback cards have limits (BRUTE FORCE: STR 4 or less; BORROWED CREDENTIALS only lends HUSH to one ICE for one turn and costs 8 CRED; ZOMBIE needs CHARGE equal to the STR), so an off-type ICE becomes a wall. Use these levers, in this order:

0. **Reveal timing (already in the game).** Where a TUMBLER's DEADLOCKs sit in its pool, and how many slots it has, sets the earliest turn you can BREACH (ROT-001). A VOID's DEADLOCK can't be broken until it has fired (VOID-001). These set length **without adding damage**, so they're the first lever to reach for. *(TUMBLE-001, 2026-11-16: breaking a TUMBLER subroutine pulls the next one into a slot at once, so a TUMBLER's REVEAL FLOOR now drops with every break, not only with turns. Score TUMBLER layers counting breaks as reveals.)* Example: REJECT ALL (2 slots of 4: DEADLOCK · TRACE 3 · DEADLOCK · PULP 4) shows its second DEADLOCK on turn 2.

1. **More DEADLOCKs, on more ICE (PACE-002).**

| Stage | ICE per layer | DEADLOCKs per layer |
|---|---|---|
| Early | 2 (support + main) | 2 |
| Early–mid | 2 | 2–3 |
| Mid | 2–3 | 3 |
| Late | 3 | 3–4 |

   Support ICE may carry a DEADLOCK in Tier 2 and later (Opening Node supports still have none, OPEN-001). Spreading DEADLOCKs across ICE types makes **COVERAGE** (DSY-002) a real deckbuilding need. TUMBLERS already carry several DEADLOCKs (ROT-001), so this mostly applies to FORTRESSES and VOIDS.

2. **DEADLOCK ×N (PACE-003) [NEW notation].** `[S2] DEADLOCK ×2` needs **2 breaks** before it counts as broken. Each break is paid separately and shown with a counter (`1/2`). Effects that "break 1 subroutine" (BRUTE FORCE, ZERO-DAY, HOST TAKEOVER, a WORM break) remove one step.
   - Useful mainly on FORTRESSES, where everything is visible and there's no rotation to pace the encounter.
   - Working limits: ×2 from early–mid on, ×3 only in late tiers and on bosses.

3. **STR grows moderately:** about **+1 STR per corporation** on comparable ICE. Icepick upgrades, PATCHWORK (TUNED, STREAMLINED) and STR-stacking builds still matter, without shutting out fallbacks. TUNE-001 already raised the slice by +1 (Opening) and +2 (Tier 1).

4. **BOOTING on the 4th turn** at the Opening Node (amends OPEN-001): the main ICE's DEADLOCK can't be broken before your **4th** turn. **Only if** playtest 2 shows the Opening Node breached before turn 4: REJECT ALL's rotation may already do it.

---

## 4. Keeping Rustlers alive (PACE-004, PACE-005)

Longer encounters mean more Corporation Responses, so the risk is the **total VITAE lost per encounter**, not any single hit.

### 4.1 VITAE budget (PACE-004)
A corporation gives about **30 VITAE + 10–20 healing** (SAFEHOUSE, DEAD DROP, MAINTENANCE WINDOW). The target VITAE at the Central Node is 30–60% (checklist E1). So:

| Encounter | VITAE lost by an on-curve deck | By an under-built deck |
|---|---|---|
| Early / early–mid | **2–3** | 5–8 |
| Mid / late | **3–4** | 6–10 |
| Central Node | **8–12** | 15+ |
| Escape | **3–4** | 6–8 |

**Design check:** simulate each new layer with a stage-typical deck. If it loses more than the on-curve figure, lower the threat before lowering the BREACH WORK. Length is the goal, damage is the cost. **Today's slice is above this budget for the bot** (§2.1); confirm with real play first.

### 4.2 Rising threat (PACE-005)
Long encounters need threat that rises, so early turns are safe for setting up and late turns push you to finish. **The game already has the tools:**
- **PULP curves** (PULP-002): curve A (2, 3, 4 …) rises steadily; curve C (HAMMER) spikes on turns 4 and 8.
- **HARDENING** (+1 STR after each response, max +3), SMART LOCK, THE HEARTH: STR that rises.
- **VOID reveal** (VOID-001): a VOID fires one more subroutine each response.

**ESCALATE ↑** (a subroutine that grows by 1 each time it resolves) is now proposed **only for effects the curves don't cover**: TRACE, DISCARD and FORGET. Example: `[S1] TRACE 1 ↑`. Screen rule: the subroutine shows its next value.

**Budgeting:** a curve or ESCALATE subroutine counts toward the threat budget (ICE-002) at its **average over the stage's target turns**. Curve A over 5 turns averages 2.8; curve C over 5 turns averages 4.6.

### 4.3 Pressure that isn't damage
TRACE, Bloatware, DISCARD, FORGET and −BW (DETAINER) slow you down without killing you. **Early tiers lean on them; heavy VITAE threats come later** (the corporation arc: HALCYON TRACE and Bloatware → IRONWATCH PULP → LUCIDA CORTEX). In early tiers, at most **half** of an ICE's threat should be PULP or CORTEX. *(The slice's FORTRESSES now carry most of HALCYON's PULP (PULP-001); that's where to look first if early encounters are too deadly.)*

### 4.4 Safety valves (PACE-006, use only if playtests run hot)
In order of preference:
1. **Max VITAE 30 → 35** (then 40).
2. **Full clear heals 3 VITAE** (in addition to the Node completion reward).
3. **A second SAFEHOUSE** guaranteed in the infiltration rows.

---

## 5. The decision long encounters create

In a 3-turn encounter, rushing the DEADLOCKs is almost always right. In a 6-turn encounter, breaking a threat is an investment:

> Breaking a PULP 4 costs 1–2 BW **once**. Leaving it costs about **1.3 BW of SHIELD every turn** for the rest of the encounter. By turn 3 the break has paid for itself.

**Rising threat** (§4.2) makes this sharper: the longer you wait, the more the threat costs. TUMBLERS add a twist: a threat you don't break while it's in a slot rotates away and comes back later. **Every encounter should ask: defend, break the threat, or rush the DEADLOCKs?** This is the same question THE HEARTH already asks (checklist J2), now asked everywhere.

---

## 6. What deckbuilding has to deliver (PACE-007)

As encounters get longer, the deck's OUTPUT has to grow from about 4 to about 10 over the run (§2). Each stage asks the deck for three things, and every reward screen trades between them:

| Need | What it means | Cards and systems that deliver it |
|---|---|---|
| **DRILL** | More BREACH WORK per BW | Better Icepicks (BATTERING RAM, RAINBOW TABLE, JACKHAMMER), STR stacking to 0 and ZEROED (DSY-009, ZEROED-001), virus counters and WORM breaks, FIELD KIT, PATCHWORK TUNED / STREAMLINED |
| **HULL** | Defence that doesn't cost a card every turn | SURGE PROTECTOR, HOT STANDBY, STUN BATON, SANDBOX, WARM BOOT, HEADROOM, SUBDERMAL PLATING, KEVLAR WEAVE |
| **COVERAGE** | An answer for every ICE type, now that DEADLOCKs spread across types | Off-type Icepicks, any-type Icepicks (SKELETON KEY, MULTITOOL), fallback upgrades, ADAPTER |

- **Reward screens should show the need.** On the reward screen, each card shows a small DRILL / HULL / COVERAGE icon, so players can see what their deck is short of. *(UI; proposed alongside DSY-002.)*
- **Pool rule for Phase 7:** every Rustler pool needs at least **2 HULL engines** (Programs or Protocols that defend each turn) by uncommon rarity. Without them, turns 6–8 can't be survived without spending a card every turn.

### 6.1 Why this supports the deck-synergy proposal
Encounter length and deck size grow together. Early encounters (4–5 turns, 24–30 cards drawn at DRAW 6) meet decks of about **18–22**; late encounters (6–8 turns, 36–48 cards drawn) meet decks of about **30–35** (DSY-006). At every stage, an on-target deck sees all of its cards and REBOOTs **about 1.5 times per encounter** (DSY-007), and AMP, CHARGE and PROCESSES have time to pay off (ENG-001 to ENG-003). Short encounters made engines a trap; longer ones make them the way to win.

---

## 7. Run length (PACE-008)

At 4–8 turns per encounter and the current ~16 encounters per corporation, a run would take about **2–2.5 hours**. To stay near the **75–100 minute** target (Core Rules §10.5), **cut layers, not Nodes**:

| Node | Layers now (ICE-008) | Proposed |
|---|---|---|
| Tier 1 (rows 2–5) | 1–2 | **1** |
| Tier 2 (rows 6–9) | 2–3 | **1–2** |

- Encounters per corporation: about **16 → 10–11** (about 6–7 ICE Nodes, the Central Node and 3 escape encounters). Total turns per corporation stay about the same (~56 → ~60).
- **Card rewards:** still one per **fully cleared** ICE Node (CORE-010, CORE-011). Fewer layers make a full clear easier, so fewer rewards are lost to leaving early. Card reward odds by layers cleared are re-based: **Tier 1, 1 layer** uses today's 1-layer odds; **Tier 2, 1 layer** uses today's 2-layer odds; **Tier 2, 2 layers** uses today's 3-layer odds.
- **CRED reserves** per layer go up about **50%**, so CRED per corporation stays near 130–220 (UPL-008) with fewer layers. Longer layers also give Extractors more turns: at 3 CRED a turn (EXTRACT-002), a Basic Extractor empties a 15-CRED reserve in 5 turns, which matches the early target.
- **Minutes per encounter** (checklist K1) rise to about **3–6**; the Corporation Response alone takes at least 5 seconds (PLAY-001). The playtest has to confirm the total.

---

## 8. Rustler balance (PACE-009)

| Rustler | Effect of longer encounters | Watch |
|---|---|---|
| **Generalist** | Neutral: covers every type, but each Icepick needs boosting. | COVERAGE is easy; DRILL is its weak point. |
| **ECHO** | Good: more turns to extract; LOW PROFILE handles small TRACE each turn. | WATCHER ICE (DOORBELL CAM) trigger more often; BORROWED CREDENTIALS needs 8 CRED, which takes longer to earn at 3 CRED a turn. |
| **RIOT** | Risky: its loud cards add TRACE every turn. RIOT-004's profiling found RIOT dying from TRACE strikes (20 of 27 deaths at strike 2 or more), not from a lack of breaks. | Give RIOT more TRACE relief, or let FEEDBACK / NO WITNESSES / ZEROED pay off sooner. Track checklist E2. |
| **VECTOR** | Strong: viruses grow every turn. | The corporation PURGE (PURGE-001) fires more often in long encounters; WORM breaks and cash-outs (DSY-010) matter more. |
| **CRON** | Strong: PROCESSES RUN every turn and need time to fill. | Make sure its slow start still fits 4–5-turn early encounters. |

---

## 9. Applying this to the ICE rosters

Every ICE layer gets a **BREACH WORK score** and a **REVEAL FLOOR** next to its threat score:
1. For each DEADLOCK, take the cheapest stage-typical way to break it: boost from the typical Icepick's STR to the ICE's STR, plus the break cost (and TOLL). Count DEADLOCK ×N as N breaks.
2. Add one install cost for each Icepick type the layer needs.
3. Note the REVEAL FLOOR: the turn the last DEADLOCK first becomes breakable.
4. Compare to the stage's targets (§2) and adjust, in this order: move a TUMBLER DEADLOCK in its pool, add or remove a DEADLOCK, add ×2, or move STR by 1. Check the VITAE budget (§4.1) last.

**Stage-typical Icepicks (working):** early: starter Icepick, STR as printed; early–mid: +1 STR or a common upgrade (BATTERING RAM, PASSKEY, TASER); mid: an uncommon upgrade, boost 1 BW → +1 STR; late: an upgraded uncommon or rare, about +2 STR over today's printed values.

**Order of work:** score the HALCYON slice first (COOKIE BANNER, CAPTCHA, CONSENT WALL, DOORBELL, TERMS & CONDITIONS), using playtest 2's measured turns and VITAE; then IRONWATCH and LUCIDA, then the Central Nodes and the escape ICE.

**Playtest checks (added to `REDLINE_PLAYTEST_CHECKLIST.md` v0.2):**

| ID | Check | Target |
|---|---|---|
| B1 (revised) | Turn you BREACHED the Opening Node | 4–5; never under 4 |
| C1 (revised) | Typical encounter length | Early 4–5 · mid–late 5–8 |
| C9 | VITAE lost per encounter | Early 2–3 · mid–late 3–4 (on-curve) |
| C10 | Did you break a threat subroutine instead of rushing, and was it worth it? | Most encounters past the Opening Node |
| C11 | Rising threat (PULP curves, HARDENING, ESCALATE) was noticed and planned around | Yes |
| K1 (revised) | Minutes per encounter | 3–6 |

---

## 10. Decision record (all APPROVED, 2026-11-15)

| ID | Decision | Status |
|---|---|---|
| PACE-001 | **Pacing model and targets:** turns ≈ BREACH WORK ÷ (OUTPUT − DEFENCE), never below the REVEAL FLOOR; targets early 4–5, early–mid 5, mid 5–7, late 6–8, boss 7–8, escape 4–5 turns, with the BREACH WORK and threat values in §2. Replaces the 3–4-turn target. | **APPROVED 2026-11-15** |
| PACE-002 | **Reveal timing first, then more DEADLOCKs on more ICE:** 2 ICE / 2 DEADLOCKs per layer early, rising to 3 ICE / 3–4 late; support ICE may carry a DEADLOCK from Tier 2 on. | **APPROVED 2026-11-15** |
| PACE-003 | **DEADLOCK ×N** (needs N breaks; ×2 from early–mid, ×3 late and bosses; mainly for FORTRESSES); STR grows about +1 per corporation; **BOOTING on the 4th turn** only if playtest 2 shows the Opening Node breached before turn 4 (would amend OPEN-001). | **APPROVED 2026-11-15** |
| PACE-004 | **VITAE budget per encounter** (§4.1) as a design check for every layer, settled against playtest 2's measured VITAE loss. | **APPROVED 2026-11-15** |
| PACE-005 | **Rising threat:** use PULP curves (PULP-002), HARDENING and VOID reveal first; **ESCALATE ↑** only for TRACE, DISCARD and FORGET; budgeted at their average value. Early tiers: at most half of an ICE's threat is PULP or CORTEX. | **APPROVED 2026-11-15** |
| PACE-006 | **Safety valves**, used only if playtests run hot: Max VITAE 35 → 40, full-clear heal 3, a second SAFEHOUSE. | **APPROVED 2026-11-15** (held in reserve) |
| PACE-007 | **DRILL / HULL / COVERAGE** as the deckbuilding needs, shown on reward cards; each Rustler pool has at least 2 HULL engines by uncommon. | **APPROVED 2026-11-15** |
| PACE-008 | **Fewer layers:** Tier 1 Nodes 1 layer, Tier 2 Nodes 1–2; card reward odds re-based; CRED reserves per layer +50%; minutes per encounter 3–6. Amends ICE-008, CORE-010 odds table, UPL-008 reserves, Core Rules §10.5. | **APPROVED 2026-11-15** |
| PACE-009 | **Rustler watch list** (§8), especially RIOT's TRACE over longer encounters. | **APPROVED 2026-11-15** |
| PACE-010 | **BREACH WORK score and REVEAL FLOOR** for every ICE layer, with stage-typical Icepicks (§9); score the HALCYON slice first, from playtest 2's measurements. | **APPROVED 2026-11-15** |

**Next:** in playtest 2, record turns and VITAE lost for each slice encounter; then score them (PACE-010) and decide whether to change the ICE, the budget, or both.

### Later amendments (2026-11-16)

| ID | Change to this document |
|---|---|
| ZEROED-001 | ICE STR stops at 0; DRILL now reads "STR stacking to 0 and ZEROED" (§6). — **APPROVED 2026-11-16** |
| TUMBLE-001 | Broken TUMBLER subroutines drop out and the rest tumble forward, so breaks reveal subroutines sooner (§3 lever 0). Rescore TUMBLER layers for PACE-010 with this rule. — **APPROVED 2026-11-16** |
