# REDLINE — BLACK MARKET UPLINK & CAPS
**Version:** 0.1 (Phase 4 of the simplified redesign)
**Date:** 2026-11-12
**Status:** **APPROVED 2026-11-12.** All seven Phase 4 decisions (UPL-001 to UPL-007) were approved by the designer (§6). Builds on the approved Core Rules, Rustlers, HALCYON ICE and Card Pools documents; UPL-003, UPL-006 and UPL-007 also amend the Core Rules.

**Fills OPEN items:** CAPS inventory, acquisition, activation costs/windows and effects (TAX-005); JACK OUT's TRACE reduction (Bible); Uplink goods, costs and timing (RUN-005).

> All numbers are **working values** for playtesting.

---

## 1. CAPS rules

**Keeps the existing canon:** CAPS are single-use injectable code, **outside your deck**: not cards, not Hardware, not Software (TAX-005). Ritual: **Flip. Inject. Discard.** JACK OUT is a CAP.

| Rule | Proposal |
|---|---|
| **Carrying** | You have **3 CAP slots**. Some Ghostware or Hardware may add more. If your slots are full, you can't take a new CAP without discarding one. |
| **Using** | **0 BW**, at any time **during your turn**. Not during the Corporation Response (no reactive plays, SOFT-011). |
| **After use** | The CAP is gone. |
| **LOCKDOWN** | Only **JACK OUT** stops working under LOCKDOWN (existing canon). Other CAPS work normally. |
| **Getting CAPS** | Buy them at Uplinks; choose one as a Node completion reward (Core Rules §9.3; since CORE-010 the completion choice is a CAP or a PATCHWORK upgrade); and after each BREACH there's a **20% chance** of a random CAP drop, if you have a free slot. |

**On screen:** CAPS sit in a small rack beside your hand. Using one plays the flip–inject–discard animation.

---

## 2. The CAPS (12)

| CAP | Rarity | Price | Effect |
|---|---|---|---|
| **BW SPIKE** | Common | 20 | +2 BW this turn. |
| **BULWARK** | Common | 20 | +8 SHIELD. |
| **FLUSH** | Common | 20 | −8 TRACE. |
| **NANOSUTURE** | Common | 20 | Heal 8 VITAE. |
| **CRACKER** | Common | 20 | Target ICE: −4 STR this encounter. |
| **JACK OUT** | Uncommon | 35 | Leave the encounter now and move **forward** (Core Rules §8.2). You keep banked CRED but get no card reward or Node completion reward. **−5 TRACE.** Doesn't heal or remove VOID. See §2.1 for when it can't be used. |
| **REFRESH** | Uncommon | 35 | Discard your hand, then draw 5. |
| **MEMORY SPIKE** | Uncommon | 35 | +2 RAM until the end of the Node. |
| **STABILIZER** | Uncommon | 35 | Prevent all VOID you would gain this encounter. |
| **ZERO-DAY** | Rare | 55 | Break 1 subroutine on **any** ICE, ignoring type and STR. |
| **SYSTEM RESTORE** | Rare | 55 | Remove all Bloatware from your hand, draw pile and discard pile. |
| **NEW IDENTITY** | Rare | 55 | Remove 1 TRACE strike, and set TRACE to 0. |

**Why these:** each common CAP is a clean emergency button (BW, shields, TRACE, healing, STR). The uncommons solve specific problems (escape, a bad hand, RAM, VOID). The rares are rescues: ZERO-DAY gets you past any subroutine, and NEW IDENTITY undoes a strike.

### 2.1 JACK OUT timing (APPROVED 2026-11-12, UPL-003)

JACK OUT can be used at any time during your turn **between card plays**, including the first turn of an encounter. It **cannot** be used:

1. **During the Corporation Response** (CAPS are your-turn only, UPL-001).
2. **Under LOCKDOWN** (3rd TRACE strike; existing canon).
3. **While a Black ICE has an unbroken subroutine** (2nd TRACE strike). Break the hunter's hold first.
4. **At the Central Node.** There's no fleeing the corporation's core.
5. **After you've BREACHED the current layer.** Leave normally instead (Core Rules §8.2).
6. **During an escape** (added by UPL-007). There's nowhere to jump out to.

**Why:** the TRACE strikes now escalate in steps: the 1st makes playing harder, the 2nd makes escaping harder, the 3rd makes escaping impossible. JACK OUT stays a real emergency button everywhere else, and its cost (the CAP, the card reward and the Node reward) keeps it from becoming a cheap way to skip encounters.

### 2.2 Bootleg CAPS (optional)
The Bible says black-market CAPS "aren't certified." To bring that in:
- Some Uplink CAPS are marked **BOOTLEG**: **half price**, but each has a **25% chance to fizzle** when used. If it fizzles, it does nothing and you gain **+3 TRACE**.
- The chance is shown on the CAP. Players choose whether the discount is worth the risk.
- **Bootleg CAPS are only sold at the Black Market Uplink.** They are never given as rewards: not from Node completion, not from the random drop after BREACH, and not from any other reward source.

---

## 3. Black Market Uplink stock

An Uplink always offers the same layout, so players learn it quickly:

| Shelf | What's on it | Notes |
|---|---|---|
| **Card shelf** (random) | **6 cards:** 4 shared + 2 from your Rustler's pool | Rarity rolled 60/30/10. **One random card is on sale at 50% off.** |
| **CAP shelf** (random) | **3 CAPS** | Rarity rolled 60/30/10. One may be BOOTLEG (if §2.2 is approved). |

**No basic cards are sold here** (BASIC-001, Core Rules §3.1a). The old reserve shelf (PROBE, PULP Shield, SCRUB) is removed: starter cards are the weakest cards, and Rustlers come to the Uplink to replace them, not to add more.

- Each item can be bought once per visit. Buy as many as you can afford.
- **No reroll** for now: what an Uplink offers is what you get. Revisit after playtesting if Uplinks feel too random.
- **Prices** follow the card prices in `REDLINE_CARD_POOLS.md` §2: **40 / 60 / 90 CRED** (raised from 25 / 40 / 65 by UPL-008).

### 3.1 Uplink services (APPROVED 2026-11-12, UPL-006)
- **Wipe (every Uplink):** permanently remove **1 card** from your deck, once per visit. Costs **50 CRED** the first time in a run, then **+25 each further use** that run (50, 75, 100…).
- **Clinic (about 1 Uplink in 3):** **remove all VOID counters for 50 CRED.** This is the "specialized recovery Node" the Core Rules mention (§6): the only way to clear VOID before the corporation ends. It's shown on the map icon, so players can plan a route to it.

### 3.2 Card removal elsewhere
- **Console Lab:** remove a card for **40 CRED** (flat; CARD-002). Cheaper than Wipe, but rarer.
- **Data purge (some SIGNAL UNCLEAR Nodes):** an event that lets you remove **1 card for free**, at a cost of **+5 TRACE or −5 VITAE** (your choice).

### 3.3 How often Uplinks appear
Uplinks follow the corporation map structure in Core Rules §10.1 (APPROVED 2026-11-12, UPL-007):
- An **Uplink** can appear in **row 3** and **row 6** of the 9 infiltration rows.
- **Row 9** (just before the Central Node) offers **only Uplinks or DEAD DROPs**, so every route can reach at least one Uplink right before the boss.
- **No Uplinks during the escape.**
- About **1 Uplink in 3** has a Clinic.

---

## 4. Economy check

**[CHANGED by UPL-008]** Target: a winning run adds **about 30 cards in total**: about 21 Node card rewards (Core Rules §9.1, CORE-010) plus **2–3 cards bought per corporation**. So reserves are lower and cards cost more.

Rough CRED per corporation, for balance:
- **ICE Nodes on the way in:** about 6 per route, paying about **15–30 CRED each** with reasonable extraction (was 20–35).
- **Central Node:** up to **35** (was 40).
- **Escape encounters:** 10 each, spent at the next corporation.
- **Clean Node bonus:** about **+5–10**.
- **Total:** roughly **130–220 CRED per corporation** (was 160–250).

With cards at 40 / 60 / 90 CRED (about 50 on average), that buys **2–3 cards plus a CAP or a Wipe**, or 3–4 cards and nothing else. A Ghostware (100 CRED) is a big decision that costs about two cards. Enough to shape a deck, but not to buy everything, so choices matter. A careful ECHO with LONG GAME and SLOW DRIP should earn noticeably more; a fast RIOT noticeably less.

---

## 5. Changes to existing rules

| Rule | Change |
|---|---|
| Bible: JACK OUT "reduces TRACE by an amount not yet specified" | **−5 TRACE** |
| Bible: JACK OUT "precise activation window" OPEN | §2.1 timing rules |
| Bible: JACK OUT "retreats to the preceding junction" | Already replaced by **moving forward** (CORE-005) |
| TAX-005: CAPS inventory, acquisition, activation OPEN | Filled by §1 |
| RUN-005: Uplink goods, costs and timing OPEN | Filled by §3 |

---

## 6. Phase 4 decision record (all APPROVED, 2026-11-12)

1. **CAPS rules:** 3 slots; 0 BW during your turn only; gone after use; only JACK OUT blocked by LOCKDOWN; bought, chosen as Node rewards, or a 20% drop after BREACH (§1). — **APPROVED 2026-11-12 (UPL-001)**
2. **The 12 CAPS** and their prices (20 / 35 / 55 CRED) (§2). — **APPROVED 2026-11-12 (UPL-002)**
3. **JACK OUT gives −5 TRACE**, and can't be used during the Corporation Response, under LOCKDOWN, while a Black ICE has an unbroken subroutine, at the Central Node, or after BREACH; only between card plays (§2, §2.1, §5). — **APPROVED 2026-11-12 (UPL-003)**
4. **Bootleg CAPS:** half price, 25% chance to fizzle for +3 TRACE; sold only at the Black Market Uplink, never given as rewards (§2.2). — **APPROVED 2026-11-12 (UPL-004)**
5. **Uplink layout:** ~~reserve shelf with 2 of PROBE / PULP Shield / SCRUB~~ (removed by BASIC-001, 2026-11-13: basic cards are never sold), 6 random cards (4 shared + 2 Rustler) with one on sale, 3 CAPS (§3). — **APPROVED 2026-11-12 (UPL-005)**
6. **Uplink services and card removal:** no reroll for now; **Clinic** at about 1 Uplink in 3 (remove all VOID for 50 CRED); **Wipe** at every Uplink (remove 1 card per visit, 50 CRED, +25 each use per run); **data purge** event at some SIGNAL UNCLEAR Nodes (remove 1 card for +5 TRACE or −5 VITAE) (§3, §3.1, §3.2). — **APPROVED 2026-11-12 (UPL-006)**
7. **Corporation map structure and Uplink frequency:** 9 infiltration rows → Central Node → 4-Node escape (3 countermeasure ICE + 1 SAFEHOUSE, TRACE doubled, no leaving early, no JACK OUT); payload kept only on escape (*later changed by P5-009: the payload Ghostware is active immediately*); SAFEHOUSEs (heal 10 VITAE or 1 PATCHWORK) in 1–2 infiltration rows and once per escape; Uplinks possible in rows 3 and 6, row 9 is Uplink or DEAD DROP only; run length target 75–100 minutes (§3.3; Core Rules §10). — **APPROVED 2026-11-12 (UPL-007)**

### Later amendments (Training Node playtest, 2026-11-12)

| ID | Change |
|---|---|
| BASIC-001 | **No basic cards at the Uplink:** the reserve shelf is removed (amends UPL-005). See Core Rules §3.1a. |
| UPL-008 | **Leaner economy:** a winning run adds about 30 cards in total, including **2–3 bought per corporation**. Card prices raised to **40 / 60 / 90 CRED** (from 25 / 40 / 65); CRED reserves lowered about 20% (Tier 1: 10/15; Tier 2: 15/20/30; Central 35; escape 10 unchanged), for about 130–220 CRED per corporation (§3, §4; `REDLINE_CARD_POOLS.md` §2; `REDLINE_ICE_CORP1.md` §8.2). Pairs with CORE-010. |
