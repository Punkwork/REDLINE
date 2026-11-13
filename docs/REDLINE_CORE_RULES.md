# REDLINE — CORE RULES
**Version:** 0.2 (Phase 1 of the simplified redesign)
**Date:** 2026-11-12
**Status:** **APPROVED 2026-11-12.** All nine Phase 1 decisions were approved by the designer (see §16). This document is now the **rules authority**, replacing the scattered rule entries in `REDLINE_MASTER_DESIGN.md` (see §15).

**Design goals for this version:** a player should be able to learn the rules in one Training Node; every number that matters should be visible on screen; runs should be short enough for "one more run."

**Already approved for this redesign (2026-11-12):** damage is **PULP + VOID only** (SyN removed); one clean Core Rules document becomes the authority; design is approved **per phase**.

> **Reading this draft:** Rules marked **[CHANGED]** differ from the current locked rules. Rules marked **[NEW]** fill something that was OPEN. Everything unmarked carries over from the existing locked design unchanged.

---

## 1. The game in one paragraph

You are a **Rustler**, a hacker for hire, with your AI companion **NUL/REM**. A run takes you through the networks of **three corporations**. Each network is a map of **Nodes**. Most Nodes are guarded by **ICE**, defensive programs you get past by playing cards from your deck and using **Icepicks** to break their **subroutines**. Each corporation is a heist: infiltrate to its **Central Node**, a boss encounter, take the payload, and **escape**. Get out of all three corporations to win the run. Reach 0 **VITAE** and the run is over.

---

## 2. Resources

| Resource | What it is | Start value | Resets |
|---|---|---|---|
| **BW** (bandwidth) | Spent to play cards and use Icepicks | 4 per turn | Refills each of your turns; unused BW is lost |
| **DRAW** | Cards drawn each turn | 5 | — reduced by VOID (§6) |
| **RAM** | Space for installed Programs | 4 | — Hardware can raise it |
| **VITAE** | Your health. 0 = run over | 30 | **[CHANGED]** Max VITAE starts at 30. Healing can't exceed Max VITAE. Cards and Ghostware can raise Max VITAE; raising it also adds the same amount to current VITAE (as in Slay the Spire) |
| **SHIELD** | Blocks incoming PULP | 0 | **[CHANGED]** One pool. Expires at the start of your next turn |
| **TRACE** | How close the corporation is to finding you | 0 of 40 | Resets when you enter a new corporation |
| **CRED** | Money, spent at the Black Market Uplink | 0 | Kept all run |

**Screen rule [NEW]:** BW, VITAE, SHIELD, TRACE and CRED are always visible. RAM appears when you install something. DRAW shows as "Next draw: X" beside the deck.

---

## 3. Cards

### 3.1 Card types [CHANGED — one type per card on screen]

Every card shows **one type** on its frame:

| Type | How it works | Leaves play |
|---|---|---|
| **PROGRAM** | Install it: pay its BW and its **RAM** cost. It stays in play for the rest of the Node. Icepicks and Extractors are Programs. | Returns to your deck at Node end. You can **unload** it for 0 BW at any time in your turn; it goes to your discard pile. **[CHANGED]** This now applies to Hardware too (previously 1 BW to uninstall). |
| **SCRIPT** | Play it for its BW cost; it resolves once. | Goes to your discard pile. |
| **PROTOCOL** | Deploy it to your **RACK** for its BW cost. Uses no RAM. Stays active for the whole Node. | Returns to your deck at Node end. |
| **BLOATWARE** | Junk cards the corporation puts into your deck. Each card says what it does. | Removed at Node end. |

Each card can also carry **tags**, shown under the type:
- **EXPLOIT** — attacks or weakens corporate systems.
- **CLOAK** — protects you or hides you.
- **ICEPICK (WALL / CODE GATE / SENTRY)**, **EXTRACTOR**, **VIRUS** — what the card does.
- **HARDWARE / SOFTWARE** — **[CHANGED]** now a flavour tag only. It has no rules effect unless a card specifically mentions it.

> Mapping from the old classifications: Executable → PROGRAM; Packet → SCRIPT; Protocol → PROTOCOL; Bloatware → BLOATWARE.

### 3.2 Card states

- **CACHE:** a CACHED card stays in your hand at end of turn instead of being discarded. It stays until played or until the Node ends. CACHED cards are extra; they don't reduce your DRAW.
- **BURNED:** the card is removed from play for the rest of the Node and shuffled back into your deck when the next Node begins.

---

## 4. Turn structure

**4.1 Start of your turn**
1. Refill BW to 4.
2. Your SHIELD from last turn expires.
3. Resolve "start of turn" effects.
4. Draw cards equal to your DRAW.

**4.2 Your turn:** play cards, install Programs, deploy Protocols, use Icepicks, in any order. End when you choose by pressing **END TURN**.

**4.3 End of your turn**
1. Resolve "end of turn" effects (for example, Extractors pay out).
2. Unused BW is lost.

**4.4 Corporation Response:** each ICE acts in turn, **left to right**. Each unbroken subroutine on that ICE resolves **top to bottom**. Broken subroutines do nothing.

**4.5 Cleanup:** discard every card in your hand that isn't CACHED.

**BREACH:** the moment every **DEADLOCK** subroutine in the encounter is broken, the encounter is **BREACHED**. You can keep playing. When you press END TURN, end-of-turn effects resolve, then **the Corporation Response is skipped**. If more layers remain you choose to go deeper or leave (§8.2); otherwise the Node ends and you get its rewards (§9.1) **[CHANGED by CORE-010]**.

**Defeat:** if VITAE reaches 0 at any moment, the run ends immediately.

> **Engine note:** The detailed timing rules for triggers, queues and snapshots (RULE-001 to RULE-143) remain the engine's specification wherever they don't conflict with this document. Players never need to read them. See §15.

---

## 5. ICE

### 5.1 Reading ICE

ICE is displayed as **NAME — TYPE — STR**, with numbered subroutines:

```
WHITE PICKET FENCE — WALL — STR 3
[S1] PULP 5
[S2] DEADLOCK
```

- **Types:** **WALL** (high STR, few subroutines, blocks progress), **CODE GATE** (lower STR, more subroutines), **SENTRY** (most dangerous, varied).
- **STR** is the ICE's strength. Your Icepick needs equal or higher strength to break it.
- The **main ICE** is always the right-most; support ICE sit to its left.
- Every encounter has at least one **DEADLOCK** somewhere.

### 5.2 Subroutine effects

| Effect | What happens |
|---|---|
| **PULP X** | Take X damage (SHIELD first, then VITAE). |
| **VOID X** | Gain X VOID counters (§6). |
| **TRACE X** | Add X to your TRACE meter (§7). |
| **DEADLOCK** | Blocks BREACH while unbroken. Does nothing on its own. |
| Others | Printed on the ICE: strengthen other ICE, insert Bloatware, and so on. |

One subroutine can have more than one effect (e.g. `[S1] PULP 4 + DEADLOCK`). Breaking it stops all of them.

### 5.3 Breaking subroutines

1. Install an **Icepick** matching the ICE's type.
2. Its **STR must be at least the ICE's current STR.** Boost it if needed: each Icepick lists its boost cost. Boosts last until the encounter ends.
3. Pay the Icepick's **break cost** to break one subroutine.

You can also **lower ICE STR** with cards like PROBE (−2 STR for the rest of the encounter).

**Screen rule [NEW]:** when you drag an Icepick onto an ICE, the game shows the **total BW needed** to break each subroutine from the current state, including boosts and STR reductions. Players should never have to do this sum themselves.

---

## 6. Damage [CHANGED — two types]

| Damage | Effect | Blocked by |
|---|---|---|
| **PULP X** | Lose X VITAE. | SHIELD, point for point. |
| **VOID X** | Gain X **VOID counters**. Each counter is −1 DRAW (DRAW can't go below 1). | Only cards that specifically say they prevent VOID. |

**Removing VOID:** all VOID counters are removed when you move to the next corporation. Specialized recovery Nodes (such as some Uplinks) can remove them earlier. Ordinary cards cannot remove VOID; it should stay frightening.

**[CHANGED]** SyN damage is removed. VOID no longer forces discards or causes overflow damage. VOID already hurts by shrinking every future hand, so the extra rules weren't needed. Effects that make you discard now say so directly, like "DISCARD 2," with no overflow.

**If one effect deals both:** apply VOID first, then PULP.

---

## 7. TRACE [NEW at 100%]

- TRACE is a meter from **0 to 40**. ICE, Bloatware and some of your own cards add TRACE.
- **50% (20 TRACE):** a warning mark. Nothing happens automatically, but some cards check "while TRACE is 20 or more."
- **100% (40 TRACE): STRIKE.** The corporation locates you. Each strike is worse than the last:

| Strike | What the corporation does | TRACE drops to |
|---|---|---|
| **1st** | Puts 1 **Tracer** Bloatware into your draw pile for the rest of the Node. | 20 |
| **2nd** | **Black ICE** joins the current encounter on the left (or the next encounter, if you've already BREACHED). | 20 |
| **3rd** | **LOCKDOWN** for the rest of the Node: you can't leave a Node early, and JACK OUT CAPS don't work. Black ICE joins as well. | 10 |

- Strikes and TRACE stay with you through the whole corporation and reset when you enter the next one.
- Further strikes after the 3rd repeat the 3rd strike.
- **DEAD DROP's WIPE TRAIL** (−20 TRACE) and cards like GHOST SIGNAL help you avoid strikes.

> Tracer card and Black ICE profiles are designed in Phase 3 (cards and ICE).

---

## 8. Nodes and encounters

### 8.1 ICE Nodes

- An ICE Node has **1 to 3 encounters** ("layers"), each with its own ICE.
- **At the start of the Node:** shuffle your whole deck and draw.
- **Between layers:** Programs, Protocols and CACHED cards stay; everything else in hand is discarded; draw a fresh hand.
- **At the end of the Node:** everything returns to your deck.

### 8.2 Leaving early [NEW]

After you BREACH a layer that isn't the last, choose:
- **Go deeper:** next layer, bigger CRED reserve, and better odds on the Node's card reward (§9.1).
- **Leave the Node:** keep everything you've earned so far, take the Node's card reward at the odds you've reached, skip the Node's completion reward, and move forward to choose your next Node.

You can't leave under LOCKDOWN.

**JACK OUT CAP [CHANGED]:** use it **during** an encounter to escape immediately, as if you'd left after BREACH. You **move forward**, not back. This keeps the run strictly forward-only and fixes the old conflict with JACK OUT retreating. JACK OUT gives −5 TRACE and has timing limits (not during the Corporation Response, under LOCKDOWN, while a Black ICE has an unbroken subroutine, at the Central Node, after BREACH, or during an escape): see `REDLINE_UPLINK_AND_CAPS.md` §2.1 (UPL-003).

### 8.3 Other Nodes

| Node | What you can do |
|---|---|
| **Black Market Uplink** | Buy cards and CAPS with CRED; remove a card (Wipe); some have a Clinic to remove VOID. Full details: `REDLINE_UPLINK_AND_CAPS.md`. |
| **DEAD DROP** | Choose one: PATCH UP (+10 VITAE) or WIPE TRAIL (−20 TRACE). |
| **Console Lab** | Apply PATCHWORK upgrades to a card, or remove a card from your deck. |
| **SAFEHOUSE** **[NEW]** | Choose one: heal 10 VITAE, or apply 1 PATCHWORK upgrade to a card. |
| **SIGNAL UNCLEAR** | An unknown Node: an event, which may include a data purge (remove 1 card for +5 TRACE or −5 VITAE). |
| **Central Node** | The corporation's boss encounter (§10). |

Non-ICE Nodes don't shuffle or reset your deck.

---

## 9. Rewards and economy

### 9.1 Card reward at the end of each ICE Node [CHANGED by CORE-010]
1. CRED your Extractors earned is banked the moment it's paid, layer by layer.
2. **Once per ICE Node**, when you finish it (by clearing every layer, or by leaving early): **choose 1 of 3 cards** to add to your deck, or skip. There is **no** card reward after the individual layers.
3. **Deeper is better.** The rarity odds of each choice depend on how many layers you cleared in that Node:

| Layers cleared | Common | Uncommon | Rare |
|---|---|---|---|
| 1 | 60% | 30% | 10% |
| 2 | 45% | 40% | 15% |
| 3 | 30% | 45% | 25% |

4. **JACK OUT** forfeits the Node's card reward (UPL-003 is unchanged).

**Why [CORE-010]:** a card after every BREACH gave about 45 card rewards per run. One per Node gives about **30 per winning run**: 6 ICE Nodes on the way in + the Central Node + 3 escape encounters (each its own Node) = 10 per corporation × 3. Fewer, better choices keep decks lean and make each pick matter. The odds table keeps going deeper worth the risk now that the extra reward per layer is gone.

### 9.2 Extraction (unchanged)
- Each encounter has a **CRED reserve**, larger in deeper layers.
- **Extractors** (Programs) pay CRED from that reserve at the end of your turn.
- Empty a layer's reserve completely and get a **bonus of 10% of it, rounded up**.
- Staying in an encounter longer to extract more is a risk you choose.

### 9.3 Node completion [NEW]
Clearing **every** layer of an ICE Node gives one extra reward: choose a CAP or a free PATCHWORK upgrade. **[CHANGED by CORE-010]** The rare card option is removed; a full clear already gets the best card odds (§9.1), and this keeps card rewards at about 30 per run.

### 9.4 Clean Node bonus [NEW]
Complete a Node without gaining any TRACE during it: **+5 CRED** (working value).

---

## 10. Corporations and the run

### 10.1 A corporation's network
- A layered map of Nodes. You always move forward, and every route has the same number of Nodes.
- Node icons on the map show **what probably lies ahead**: ICE, Uplink, DEAD DROP, Console Lab, SAFEHOUSE, or **SIGNAL UNCLEAR** (unknown). **[CHANGED]** Previously Nodes were fully hidden. Showing likely contents fits the surveillance theme (you're watching the corporation too) and makes route choice a real decision.
- **Structure [CHANGED by UPL-007]:** a heist in three parts. Every route has **14 Nodes**: **9 infiltration rows → the Central Node → a 4-Node escape**. This replaces the earlier working size of 6 Nodes per route (CORE-009).

**Infiltration rows** (each row has 3–4 Nodes; each Node links forward to 2–3 Nodes in the next row):

| Rows | Possible Nodes |
|---|---|
| 1–4 (Tier 1 ICE) | ICE, SIGNAL UNCLEAR, SAFEHOUSE; **Uplink** possible in row 3 |
| 5–8 (Tier 2 ICE) | ICE, Console Lab, SIGNAL UNCLEAR, SAFEHOUSE; **Uplink** possible in row 6 |
| 9 | **Uplink or DEAD DROP only:** the last chance to prepare |

- **SAFEHOUSEs** appear in **1–2** of the 9 infiltration rows.
- Every route can reach **at least 1 Uplink** (row 9 always offers one). About **1 Uplink in 3 has a Clinic**, shown on the map.

### 10.2 Central Node and the payload [CHANGED by UPL-007]
A boss-style ICE encounter. Defeating it gives you the corporation's **payload**, an **encrypted data core**: choose **1 of 3 Ghostware**, **active immediately** (usable during the escape). The rest of the core stays encrypted until you escape, when NUL/REM decrypts it into a **First Signal fragment** **[CHANGED by P5-009]**. See `REDLINE_UPGRADES_EVENTS_ESCAPE.md` §2.5.

### 10.3 Escape [NEW, UPL-007]
After the Central Node, you have to get out:
- **4 Nodes:** **3 single-layer ICE encounters** using that corporation's **countermeasure ICE**, plus **exactly 1 SAFEHOUSE**.
- **TRACE gains are doubled** throughout the escape.
- **No leaving early**, and **JACK OUT doesn't work**.
- No Uplinks, Console Labs or other upgrade Nodes, apart from the one SAFEHOUSE.
- **TRACE is doubled because the corporation is tracking its own data core.**
- Complete the escape to decrypt the core (a First Signal fragment) and move on. If VITAE reaches 0 during the escape, the run ends as normal.

### 10.4 Moving to the next corporation
Keep your deck, PATCHWORK and Ghostware (including the payload). Restore VITAE to max. Remove all VOID. Reset TRACE and strikes to 0.

### 10.5 Run length target [CHANGED by UPL-007]
**75–100 minutes** for a full run (previously 45–75). Roughly: about 6 ICE Nodes on the way in (≈11 encounters with layers) + the boss + 3 escape encounters ≈ **15 encounters per corporation**, **about 45 per run**, at 3–4 turns each. The Training Node playtest should measure real minutes per encounter before these numbers are fixed.

---

## 11. Permanent upgrades

- **Ghostware:** permanent upgrades that are not cards, shown on the Ghostware rack. Each Rustler has one signature Ghostware marked **ORIGIN**. Some Ghostware has a drawback alongside its benefit.
- **PATCHWORK:** a permanent upgrade to one specific copy of a card.
- **CAPS:** single-use items outside your deck. Flip. Inject. Discard. They cost no BW.

---

## 12. Rustlers [NEW structure]

- Each Rustler has a **12-card starter deck**, a signature Ghostware, and a playstyle.
- **The Generalist** keeps one Icepick of each type. It covers everything, but specializes in nothing.
- **Other Rustlers** start with **one strong signature Icepick** plus a **fallback card** that can break any ICE type at a high cost. Their weak ICE types are covered by cards found during the run.
- Rustlers are designed in Phase 2.

---

## 13. The Generalist starter deck (current, adjusted)

| Qty | Card | Type | Cost | Effect |
|---:|---|---|---|---|
| 1 | WALL Icepick | PROGRAM — ICEPICK (WALL) | 1 BW, 1 RAM | STR 1. Boost: 1 BW +1 STR. First break each turn free, then 1 BW per break. |
| 1 | CODE GATE Icepick | PROGRAM — ICEPICK (CODE GATE) | 1 BW, 1 RAM | STR 3. Boost: 2 BW +1 STR. Break: 1 BW. |
| 1 | SENTRY Icepick | PROGRAM — ICEPICK (SENTRY) | 1 BW, 1 RAM | STR 0. Boost: 1 BW +1 STR. Break: 1 BW. |
| 1 | Basic Extractor | PROGRAM — EXTRACTOR | 1 BW, 1 RAM | End of your turn: extract 5 CRED. |
| 1 | **VOID BUFFER** **[CHANGED]** | PROGRAM | 1 BW, 1 RAM | Once per encounter, prevent 1 VOID. *(Replaces SYN BUFFER, since SyN is removed. Deliberately not tagged CLOAK, so installing it doesn't power up WATCHDOG.)* |
| 3 | PULP Shield | SCRIPT — CLOAK | 1 BW | +3 SHIELD. |
| 3 | PROBE | SCRIPT — EXPLOIT | 1 BW | Target ICE gets −2 STR for this encounter. |
| 1 | GHOST SIGNAL | SCRIPT — CLOAK | 2 BW | The first TRACE added during the next Corporation Response is reduced to 0. BURNED for the rest of the Node. |

---

## 14. Training Node — required adjustments

The Training Node values were frozen for playtesting (TRAINING-NODE-PLAYTEST-LOCK-001). Removing SyN requires one change:

- **WATCHDOG `[S2] SyN 1`** → **`[S2] DISCARD 1`** (approved): the Rustler discards 1 card of their choice from hand. If the hand is empty, nothing happens.

Everything else in the Training Node stays exactly as locked.

---

## 15. What this replaces

When approved, this document **supersedes** the following. They stay in the Master Design as history.

| Old rule | Replaced by |
|---|---|
| RULE-126, RULE-127, RULE-128 (SyN and overflow) | §6 — SyN removed |
| RULE-129 + amendment (VOID → SyN → PULP order) | §6 — VOID then PULP |
| VOID damage enhancement (discard + 5 PULP overflow) | §6 — VOID is counters only |
| DMG-001, DMG-002 (three damage types, three pools) | §6 — two types, one SHIELD pool |
| SOFT-014, SOFT-015 (PULP prevention pools) | §2, §6 — SHIELD |
| VITAE-CAPACITY-001 (no defined maximum) | §2 — Max VITAE 30, can be raised |
| TRACE-004 (100% TBD) | §7 — strike ladder |
| JACK OUT retreat (Bible canon) and its RUN-003 conflict | §8.2 — JACK OUT moves forward |
| RUN-005 (Node contents fully hidden) | §10.1 — likely contents shown |
| SYN BUFFER (GENERALIST-STARTER-LOCK-001) | §13 — VOID BUFFER |
| TAX-004 / TAX-017 Hardware uninstall cost (1 BW) | §3.1 — all Programs unload for 0 BW |
| Executable / Packet card-frame naming (§41) | §3.1 — PROGRAM / SCRIPT on the card |

**Still in force as engine specification:** RULE-001 to RULE-124 and RULE-130 to RULE-143, except where they refer to SyN, separate prevention pools, or the old damage order. Those parts are void. Implementers use them for exact timing; players never see them.

**Unchanged and still authoritative:** Icepick profiles, CRED reserves and extraction, BREACH, left-to-right Corporation Response, CACHE, BURNED, RACK, Bloatware, DEAD DROP, three-corporation structure, forward-only map, NUL/REM and all World Bible canon.

---

## 16. Phase 1 decision record (all APPROVED, 2026-11-12)

| ID | Decision | Result |
|---|---|---|
| CORE-001 | **VOID BUFFER** replaces SYN BUFFER in the Generalist deck (§13). | Approved |
| CORE-002 | **WATCHDOG `[S2]`** becomes DISCARD 1 (§14). | Approved |
| CORE-003 | **Max VITAE 30** at start; healing capped at Max VITAE; raising Max VITAE also raises current VITAE by the same amount (§2). Supersedes VITAE-CAPACITY-001. | Approved |
| CORE-004 | **TRACE strike ladder** as written (§7). Fills TRACE-004. | Approved |
| CORE-005 | **Leaving a Node early** between layers, and **JACK OUT moving forward** (§8.2). | Approved |
| CORE-006 | **Card reward (1 of 3, or skip) after every BREACH** (§9.1). | Approved; **superseded by CORE-010** |
| CORE-007 | **Map shows likely Node contents**, with some SIGNAL UNCLEAR (§10.1). Supersedes RUN-005 hidden contents. | Approved |
| CORE-008 | **Card frame shows one type** (PROGRAM / SCRIPT / PROTOCOL / BLOATWARE) with HARDWARE/SOFTWARE as tags; all Programs unload for 0 BW (§3.1). | Approved |
| CORE-009 | **Working values:** Clean Node bonus +5 CRED; 6 Nodes per corporation route. Retune after playtesting. | Approved (working values); Node count **superseded by UPL-007** |

Earlier decisions for this redesign (also 2026-11-12): damage is PULP + VOID only; this document is the single rules authority; design is approved per phase.

**Next phase:** Phase 2 — Rustlers: 3–4 playable Rustlers with starter decks, signature Icepicks, fallback cards and ORIGIN Ghostware.

### Later amendments (Phase 4, `REDLINE_UPLINK_AND_CAPS.md`)

| ID | Change to this document |
|---|---|
| UPL-003 | JACK OUT gives −5 TRACE and has timing limits (§8.2). |
| UPL-006 | Uplink services (Wipe, Clinic) and the SIGNAL UNCLEAR data purge (§8.3). |
| UPL-007 | Heist structure: 9 infiltration rows → Central Node → 4-Node escape; SAFEHOUSE Nodes; payload kept only on escape (*later changed by P5-009: the payload Ghostware is active immediately*); run length target 75–100 minutes (§1, §8.3, §10). Supersedes CORE-009's 6 Nodes per route. |
| P5-009 | The payload is an encrypted data core: its Ghostware is active immediately; the core is decrypted into a First Signal fragment after the escape (§10.2, §10.3). |

### Later amendments (Training Node playtest, 2026-11-12)

| ID | Change to this document |
|---|---|
| CORE-010 | Card reward **once per ICE Node** at the end of the Node, not after every BREACH; about 30 card rewards per winning run. Rarity odds improve with layers cleared (60/30/10, 45/40/15, 30/45/25). Leaving early still gets the card reward; JACK OUT doesn't. Node completion reward is now a CAP or a PATCHWORK upgrade (no rare card) (§4, §8.2, §9.1, §9.3). Supersedes CORE-006. |
