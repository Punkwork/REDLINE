# PANOPTICON — CORE RULES
**Version:** 0.2 (Phase 1 of the simplified redesign)
**Date:** 2026-11-12
**Status:** **APPROVED 2026-11-12.** All nine Phase 1 decisions were approved by the designer (see §16). This document is now the **rules authority**, replacing the scattered rule entries in `REDLINE_MASTER_DESIGN.md` (see §15).

**Design goals for this version:** a player should be able to learn the rules in one Training Node; every number that matters should be visible on screen; runs should be short enough for "one more run."

**Already approved for this redesign (2026-11-12):** damage is **PULP + CORTEX only** (SyN removed); one clean Core Rules document becomes the authority; design is approved **per phase**.

> **Reading this draft:** Rules marked **[CHANGED]** differ from the current locked rules. Rules marked **[NEW]** fill something that was OPEN. Everything unmarked carries over from the existing locked design unchanged.

---

## 1. The game in one paragraph

You are a **Rustler**, a hacker for hire, with your AI companion **NUL/REM**. A run takes you through the networks of **three corporations**. Each network is a map of **Nodes**. Most Nodes are guarded by **ICE**, defensive programs you get past by playing cards from your deck and using **Icepicks** to break their **subroutines**. Each corporation is a heist: infiltrate to its **Central Node**, a boss encounter, take the payload, and **escape**. Get out of all three corporations to win the run. Reach 0 **VITAE** and the run is over.

---

## 2. Resources

| Resource | What it is | Start value | Resets |
|---|---|---|---|
| **BW** (bandwidth) | Spent to play cards and use Icepicks | 4 per turn | Refills each of your turns; unused BW is lost |
| **DRAW** | Cards drawn each turn | **6** *(DRAW-001: was 5)* | — reduced by CORTEX (§6) |
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
- **ICEPICK (FORTRESS / TUMBLER / VOID)**, **EXTRACTOR**, **VIRUS** — what the card does. *(TUMBLER replaced SIGYL, ROT-001.)*
- **HARDWARE / SOFTWARE** — **[CHANGED]** now a flavour tag only. It has no rules effect unless a card specifically mentions it.

> Mapping from the old classifications: Executable → PROGRAM; Packet → SCRIPT; Protocol → PROTOCOL; Bloatware → BLOATWARE.

### 3.1a Starter cards are the weakest cards [NEW, BASIC-001 — structural rule]
- **Every card in a starter deck is the weakest version of its role** (the shared basics PROBE, PULP Shield, GHOST SIGNAL and Basic Extractor, and each Rustler's own starter cards). Every card a Rustler can earn or buy is slightly or much better.
- **Rustlers are trying to stop drawing their starter cards.** By the end of a good run, the deck should rarely draw an original card: rewards, purchases, Console Lab removal, DECOMPILE and FUSE all serve that goal.
- **Basic and starter cards are never offered** as rewards, at the Black Market Uplink, or by events. Only the reward pools are.
- **Design check:** every starter card must have at least one reward card that's a clear upgrade for the Rustler who starts with it. When one doesn't, weaken the starter card first (or make the ICE stronger), rather than raising rewards. The current audit is in `REDLINE_CARD_POOLS.md` §2.1.

### 3.2 Card states

- **CACHE:** a CACHED card stays in your hand at end of turn instead of being discarded. It stays until played or until the Node ends, **unless its card effect specifies an earlier expiry**. CACHED cards are extra; they don't reduce your DRAW. SMASH & GRAB's paid uninstall (RIOT-005) CACHES another hand card until the end of the Rustler's next turn; see `REDLINE_RUSTLERS.md` for the full approved effect.
- **BURNED:** the card is removed from play for the rest of the **encounter**; when the encounter ends, it goes to your discard pile (BURNED-001, BURNED-001a, designer 2026-11-27; was "the rest of the Node"). At a Node's end everything returns to your deck as usual. **Bloatware** never comes back: cleared SPAM disappears for good (BURNED-001b), and Bloatware BURNED any other way is removed too (interpretation to confirm).

---

## 4. Turn structure

**4.1 Start of your turn**
1. Refill BW to 4, minus any BW a DETAINER drained in the last Corporation Response (§5.5).
2. Your SHIELD from last turn expires.
3. **TUMBLERS rotate** one step (not on your first turn of an encounter; §5.4).
4. Resolve "start of turn" effects (including virus strains, §5.7).
5. Draw cards equal to your DRAW (6).
6. **Resolve any DISCARD** that ICE dealt in the last Corporation Response: choose the cards from your new hand. *(FIX-001: a DISCARD used to hit the old hand just before cleanup discarded it anyway.)*

**4.2 Your turn:** play cards, install Programs, deploy Protocols, use Icepicks, in any order. You can **boost an installed Icepick** at any time on your turn by paying its boost cost; boosts last until the encounter ends *(FIX-002)*. End when you choose by pressing **END TURN**.

**4.3 End of your turn**
1. Resolve "end of turn" effects (for example, Extractors pay out).
2. Unused BW is lost.

**4.4 Corporation Response:**
1. **PURGE check** *(PURGE-001)*: if the virus counters on the encounter's ICE add up to the corporation's PURGE limit or more, it removes them all **instead of taking its turn**, and your turn begins (§5.7).
2. Otherwise each ICE acts in turn, **left to right**. Each unbroken subroutine **that is active** resolves **top to bottom**: on a TUMBLER only the subroutines in its slots (§5.4); on a VOID, subroutines 1 to N on its Nth response, face-down ones included (§5.6). Broken subroutines do nothing.

*Presentation (PLAY-001): the response takes at least 5 seconds; each subroutine flashes in turn, and its effects apply only as it flashes.*

**4.5 Cleanup (HAND-CLEANUP-001):** END TURN gives no free HOLD choice. After the Corporation Response (or when BREACH skips it), discard every non-CACHED card still in your hand. On your next Rustler turn, draw 6 cards at base DRAW in addition to any CACHED cards. Existing DRAW modifiers and card-granted CACHE still apply.

**BREACH:** the moment every **DEADLOCK** subroutine in the encounter is broken, the encounter is **BREACHED**. This includes DEADLOCKs you haven't seen yet: a TUMBLER's hidden DEADLOCKs must each be broken as they rotate into a slot, and a VOID's once they have fired *(ROT-001, VOID-001)*. You can keep playing. When you press END TURN, end-of-turn effects resolve, then **the Corporation Response is skipped**. If more layers remain you choose to go deeper or leave (§8.2); otherwise the Node ends and you get its rewards (§9.1) **[CHANGED by CORE-010]**.

**Defeat:** if VITAE reaches 0 at any moment, the run ends immediately.

> **Engine note:** The detailed timing rules for triggers, queues and snapshots (RULE-001 to RULE-143) remain the engine's specification wherever they don't conflict with this document. Players never need to read them. See §15.

---

## 5. ICE

### 5.1 Reading ICE

ICE is displayed as **NAME — TYPE — STR**, with numbered subroutines:

```
WHITE PICKET FENCE — FORTRESS — STR 3
[S1] PULP 5
[S2] DEADLOCK
```

- **Types** *(ICEBIBLE-001; see the ICE Rules Bible)*:
  - **FORTRESS** — generally the highest STR; few subroutines, almost all PULP (the odd other effect; TRACE rare). Everything is visible and fires every turn.
  - **TUMBLER** — where the quirks and puzzles happen. Its subroutines rotate through a few slots (§5.4). *(Replaced SIGYL, ROT-001.)*
  - **VOID** — where the deadly happens. Its subroutines start face-down (§5.6). VOID ICE are the main source of CORTEX damage, but any ICE can deal it.
  - *(WALL, CODE GATE and SENTRY were renamed by NAME-001.)*
- **STR** is the ICE's strength. Your Icepick needs equal or higher strength to break it.
- The **main ICE** is always the right-most; support ICE sit to its left.
- Every encounter has at least one **DEADLOCK** somewhere.

### 5.2 Subroutine effects

| Effect | What happens |
|---|---|
| **PULP X** | Take X damage (SHIELD first, then VITAE). *(PULP-001, 2026-11-17: on a FORTRESS, X is rolled each time it fires: printed −2..+2, about 30% of rolls ±3 instead, never below 1. The roll is made ahead of time and shown, so the Rustler always knows the exact value before it fires.)* |
| **PULP (curve)** | *(PULP-002)* Take the next value of the subroutine's PULP curve (SHIELD first, then VITAE). The curve moves one step each Corporation Response the ICE goes through (a PURGE or BLACKOUT turn doesn't count) and loops after 9. **A · SEQUENTIAL:** 2, 3, 4, 2, 3, 4, 2, 3, 4 (27). **B · RANDOM:** 5, 3, 2, 6, 2, 3, 6, 2, 1 in a random order for each ICE (30); the ICE card shows its next value *(PULP-001, 2026-11-17: was "PULP ?"; curves do not roll)*. **C · HAMMER:** 4, 3, 4, 9, 3, 4, 3, 8, 2 (40). SCRAMBLE lowers it like any PULP. |
| **CORTEX X** | Gain X CORTEX counters (§6). |
| **−X BW** | You have X less BW on your next turn. The DETAINER's signature (§5.5). |
| **DISCARD X** | Discard X cards of your choice **at the start of your next turn, after you draw** (FIX-001). |
| **TRACE X** | Add X to your TRACE meter (§7). |
| **DEADLOCK** | Blocks BREACH while unbroken. Does nothing on its own. |
| **FORGET X** | X random non-CACHED cards in your hand go to the **bottom of your draw pile**. *(LUCIDA; added by ICE3-002, changed by ICE3-002a.)* |
| Others | Printed on the ICE: strengthen other ICE, insert Bloatware, and so on. |

One subroutine can have more than one effect (e.g. `[S1] PULP 4 + DEADLOCK`). Breaking it stops all of them.

### 5.3 Breaking subroutines

1. Install an **Icepick** matching the ICE's type.
2. Its **STR must be at least the ICE's current STR.** Boost it if needed: each Icepick lists its boost cost. Boosts last until the encounter ends.
3. Pay the Icepick's **break cost** to break one subroutine.
4. **You can only break what you can see:** a TUMBLER subroutine must be in a slot, and a VOID subroutine must have been revealed. Cards that break subroutines (BRUTE FORCE, RUNTIME ERROR…) follow the same limits.

You can also **lower ICE STR** with cards like PROBE (−2 STR for the rest of the encounter).

**STR floor [ZEROED-001]:** ICE STR **can't go below 0**. A reduction that would take it lower takes it to 0 and the rest is lost, so the STR shown is the real STR. If the ICE gains STR later, it rises from 0. (ROT is the exception: spare ROT counters stay on the ICE and keep holding it at 0, §5.7.)

**ZEROED [ZEROED-001]:** a card that says **ZEROED: [bonus]** gives that bonus if it takes target ICE from above 0 STR to 0. **Each ICE can be ZEROED only once per encounter:** the first time its STR drops to 0, from any cause, uses up its ZEROED, and the bonus happens only if the card that did it prints ZEROED. An ICE that starts at 0, or that can't be reduced below a floor above 0, can't be ZEROED. A ZEROED ICE shows a marker for the rest of the encounter.

**Screen rule [NEW]:** when you drag an Icepick onto an ICE, the game shows the **total BW needed** to break each subroutine from the current state, including boosts and STR reductions. Players should never have to do this sum themselves.

### 5.4 TUMBLER rotation [NEW, ROT-001]

- A TUMBLER has a **pool** of 1–8 subroutines and fewer **slots**. Only the subroutines in its slots are active; the rest are **face-down** (the card shows how many).
- **Conveyor:** at the start of each of your turns after the first, the window moves one step: slots showing S1-S2-S3 then show S2-S3-S4, then S3-S4-S5, wrapping round. The newly revealed set is what fires when you end that turn, so you only learn the response at the start of your turn.
- **TUMBLE [TUMBLE-001]:** a broken subroutine **drops out of the pool** for the rest of the encounter. When you break a subroutine that's in a slot, the unbroken subroutines in the slots after it **slide back one slot** to close the gap, and the **next unbroken subroutine in pool order tumbles into the last slot**, face up (wrapping round the pool, skipping broken ones). A subroutine that tumbles in is **active at once**: you can break it this turn if you can pay, and if you don't, it fires in this turn's Corporation Response. Each turn's conveyor step then moves through the **unbroken subroutines only**.
- **Running out:** once a TUMBLER has no more unbroken subroutines than slots, they all show, rotation stops, and any spare slots stay empty.
- **Edge cases:** card breaks (BRUTE FORCE, RUNTIME ERROR, NULL POINTER…) and WORM breaks tumble the same way. A DEADLOCK ×N only drops out when its last break lands. BOOTING still applies to a DEADLOCK that tumbles in early. A TUMBLER with nothing left to tumble in just shows fewer subroutines.
- *Example:* CAPTCHA (2 slots of 5: DISCARD 1 · DEADLOCK · PULP 6 · DEADLOCK · TRACE 3) shows DISCARD 1 · DEADLOCK on turn 1. Break the DEADLOCK and PULP 6 tumbles into slot 2: break it too, and the second DEADLOCK tumbles in. Every break shows you something new, and sometimes pulls a worse subroutine into this turn's response.
- TUMBLERS carry **several DEADLOCKs**, which must each be broken while in a slot (§4 BREACH).
- *Presentation (REEL-001):* each slot is a slot-machine reel that spins on rotation; slots are labelled with the subroutine they hold ("SLOT 2 · S1").

### 5.5 Subtypes and passive abilities [NEW, DET-001 and PASSIVE-001]

- **Subtypes** give ICE a personality and a home for **passive abilities**: rules that apply all encounter without a subroutine firing. The full list, power ranking and guardrails are in the **Ice Passive Abilities** doc; the personalities are in the **ICE Rules Bible**.
- **DETAINER** (TUMBLER subtype, LOCKED): about 1 TUMBLER in 5. Its **S1 is always −1 BW** (you have 1 less BW next turn). **At most 1 DETAINER per encounter.**
- **Passives in the playtest slice:** TOLL (breaks cost +1 BW, except the DEADLOCK), SEQUENCED (break left to right), HARDENING (+1 STR after each response, max +3), ~~RELAY~~ (deprecated 2026-11-17, DEPRECATE-001), TRIPWIRE (each break +1 TRACE), WATCHER (each CLOAK card +1 TRACE), BOOTING (DEADLOCKs unbreakable before your 3rd turn).
- **Guardrails:** at most one passive per ICE, at most two passive ICE per Tier 1 encounter; Black ICE have none.

### 5.6 VOID reveal [NEW, VOID-001]

- A VOID's subroutines start **face-down**. Its 1st Corporation Response fires subroutine 1 (revealed as it fires); the 2nd fires subroutines 1 and 2; and so on until all fire every response.
- A revealed subroutine stays revealed for the encounter; face-down ones can't be broken.
- The response preview shows a face-down firing as "? (hidden)". Black ICE HOUSE CALL is a VOID and follows the same rule from the moment it joins.

### 5.7 Virus counters and the corporation PURGE [NEW, RUSTLER-002 and PURGE-001]

- **Strains** (placed by INFECT): **ROT** −1 STR each (minimum 0; spare ROT keeps the ICE at 0 if it gains STR, §5.3); **SCRAMBLE** this ICE's PULP −1 each when it acts; **BLIND** this ICE's TRACE −1 each when it acts; **LEECH** extract 1 CRED each at the start of your turn; **WORM** on your turn, at any time, remove 2 WORM counters from an ICE to break 1 subroutine on that ICE of your choice (normal break rules apply: it must be active or revealed, not locked by BOOTING, and SEQUENCED order is respected; it needs no Icepick, ignores the ICE's STR, costs no BW (TOLL doesn't apply) and can only be used on your turn) *(VIRUS-001)*.
- **PURGE:** at the start of its turn the corporation counts every virus counter on the encounter's ICE. At or above its **PURGE limit** it removes them all instead of taking its turn. **HALCYON: limit 10, +5 after each purge** (10 → 15 → 20), reset each encounter. The limit is **never shown** to the Rustler.
- A PURGE or BLACKOUT turn isn't a Corporation Response: TUMBLERS still rotate (your turn starts), but VOIDS reveal nothing new, HARDENING doesn't grow and PULP curves don't advance.

---

## 6. Damage [CHANGED — two types]

| Damage | Effect | Blocked by |
|---|---|---|
| **PULP X** | Lose X VITAE. | SHIELD, point for point. |
| **CORTEX X** | Gain X **CORTEX counters**. Each counter is −1 DRAW (DRAW can't go below 1). | Only cards that specifically say they prevent CORTEX. |

**Removing CORTEX:** all CORTEX counters are removed when you move to the next corporation. The Uplink Clinic (§8.3) removes them earlier, for CRED; nothing else restores CORTEX at a Node. Ordinary cards cannot remove CORTEX; it should stay frightening.

**[CHANGED]** SyN damage is removed. CORTEX no longer forces discards or causes overflow damage. CORTEX already hurts by shrinking every future hand, so the extra rules weren't needed. Effects that make you discard now say so directly, like "DISCARD 2," with no overflow.

**If one effect deals both:** apply CORTEX first, then PULP.

**[NAME-001]** CORTEX is the damage formerly named VOID: the same counters and rules, renamed. It is **not** the removed SyN, and the SyN overflow rules (RULE-126 to RULE-128) stay void.

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
- **Go deeper:** take on the next layer and its CRED reserve. You must BREACH the final layer to earn the Node's card reward (§9.1; CORE-011).
- **Leave the Node:** keep banked CRED, but receive **no card reward** and no Node completion reward. Perform normal Node cleanup and move forward to choose your next Node. **CORE-011 supersedes the former early-exit card reward.**

You can't leave under LOCKDOWN.

**JACK OUT CAP [CHANGED]:** use it **during** an encounter to escape immediately, as if you'd left after BREACH. You **move forward**, not back. This keeps the run strictly forward-only and fixes the old conflict with JACK OUT retreating. JACK OUT gives −5 TRACE and has timing limits (not during the Corporation Response, under LOCKDOWN, while a Black ICE has an unbroken subroutine, at the Central Node, or after BREACH): see `REDLINE_UPLINK_AND_CAPS.md` §2.1 (UPL-003).

### 8.3 Other Nodes: the Node authority (NODE-AUTHORITY-001)

<a id="node-authority"></a>**This section is the single current definition** of Node categories and identities, primary Node purposes, functional boundaries, permitted and prohibited Node services, which services belong to which Node, the exceptions to Node specialization and how Node functions relate (NODE-AUTHORITY-001, designer 2026-11-27; AGENTS.md / CLAUDE.md §7). Other docs refer here; they don't restate it. Change Node purposes here and nowhere else, and record the decision in Master Design. Where the map puts each Node is §10 (MAP-003e, MAP-003f), not this section.

**Functional sovereignty.** Each Node has one distinct primary function and strategic identity. A service belongs to a Node by its **mechanical purpose**, not by how it is paid for, how it looks or how the story justifies it. No Node may offer predictable access to a function that belongs exclusively to another Node without explicit designer approval.

<a id="node-table"></a>
| Node | Exclusive primary function | Services (current) | Never offers |
|---|---|---|---|
| <a id="node-uplink"></a>**Black Market Uplink** | **Commerce** | Buy cards, CAPS and Ghostware with CRED (stock, prices and transactions: `REDLINE_UPLINK_AND_CAPS.md`, UPLINK-SPEC-001). Every Uplink has a **Clinic** counter: specialized neurological repair that removes **CORTEX only**, 30 CRED per counter, 25% off the total when removing 2 or more in one visit, rounded up (2 = 45, 3 = 68, 4 = 90; CLINIC-001). The Uplink pricing layers (market variability, TRACE premium, Identity Verification; ECON-TRACE-001, ECON-MARKET-001, UPL-IDENTITY-001) apply to Uplink transactions only. | VITAE restoration (the Clinic never restores VITAE); standalone card removal (no WIPE); REFACTOR, PATCHWORK, FUSE or any other deck engineering; dedicated TRACE reduction |
| <a id="node-console-lab"></a>**Console Lab** | **Deck engineering** | Choose one per visit: **a PATCHWORK upgrade** (free; FUSE offered where eligible: `REDLINE_UPGRADES_EVENTS_ESCAPE.md` §1), or **permanently remove 1 card** from your deck: 50 CRED the first time in a run, +25 each further use that run (50, 75, 100…), once per visit. **HARDWIRED** cards can't be removed. The Uplink pricing layers don't apply to Console Lab services. REFACTOR is the collective name for the Lab's modification services. Modification eligibility, repeat limits, recursive fusion, cross-modification, scaling and costs await their own review (NODE-PURPOSE-001). | Card purchases; VITAE or CORTEX recovery; TRACE reduction |
| <a id="node-safehouse"></a>**SAFEHOUSE** | **Physical recovery** | Choose one free service per visit: **PATCH UP** restores 30% of maximum VITAE, capped at maximum; **FORTIFY** raises maximum VITAE by 6% and current VITAE by the same amount, cumulative for the run, no further cap. Both round to the nearest whole number. The FIELD MEDIC Ghostware adds its healing here. | Card upgrades or other deck engineering; TRACE reduction |
| <a id="node-dead-drop"></a>**DEAD DROP** | **Surveillance evasion** | Choose one free service per visit: **WIPE TRAIL** lowers current TRACE by 20 (not below 0); **GHOST TRAIL** halves incoming TRACE throughout the next ICE Node, all its encounters included; it persists through non-combat Nodes in between and ends when you leave that ICE Node. Fractional TRACE rounding, stacking and edge cases are still open. | VITAE recovery or other physical healing; card services |
| <a id="node-signal-unclear"></a>**SIGNAL UNCLEAR** | **Discovery** | An unknown event: uncertainty, unexpected opportunities, decisions and risks (catalogue: `REDLINE_UPGRADES_EVENTS_ESCAPE.md` §3). Events may overlap other Nodes' functions **incidentally**, e.g. DATA PURGE (remove 1 card for +7 TRACE or −5 VITAE; UPL-006a) or BLACK CLINIC. Event balance is reviewed separately. | Predictable substitutes for another Node's dedicated service |
| **Central Node** | Boss encounter | The corporation's boss encounter (§10). | — |

<a id="node-boundaries"></a>**Boundaries and exceptions**
- **Specialization governs dedicated Node services, not every source of an effect.** The Console Lab is the only non-combat Node with dedicated, predictable standalone card removal. That doesn't remove DECOMPILE (DSY-003, on the card reward; its mechanics, eligibility and timing are unchanged), incidental removal in approved SIGNAL UNCLEAR events, or removal inherent in approved modification mechanics such as FUSE. Card and Ghostware effects are not Node services.
- **CORTEX repair and VITAE recovery are different functions:** CORTEX belongs to the Uplink Clinic (§6), VITAE recovery to the SAFEHOUSE.
- **Rewards for clearing ICE Nodes** offer no deck-engineering service (§9.3).
- **Environmental features** carry no service unless approved. The Uplink's CRT terminal artwork is decoration; its future interactive purpose hasn't been approved.
- **Structured Node records** (a data file for Nodes) are not part of this decision; they're a candidate for review after CSA-07.

Non-ICE Nodes don't shuffle or reset your deck.

---

## 9. Rewards and economy

### 9.1 Card reward at the end of each ICE Node [CHANGED by CORE-010]
1. CRED your Extractors earned is banked the moment it's paid, layer by layer.
2. **Once per fully cleared ICE Node**, after you **BREACH the final ICE layer** and complete the encounter: **choose 1 of 3 cards** to add to your deck, or skip. **Leaving early gives no card reward**, even if earlier layers were breached (CORE-011). There is **no** card reward after individual layers, and **none in the escape** (§10.3).
3. **Deeper is better.** For a fully cleared Node, the rarity odds of each choice depend on its total number of cleared layers. These odds do not grant rewards for partial clears:

| Layers cleared | Common | Uncommon | Rare |
|---|---|---|---|
| 1 | 60% | 30% | 10% |
| 2 | 45% | 40% | 15% |
| 3 | 30% | 45% | 25% |

4. **JACK OUT** forfeits the Node's card reward (UPL-003 is unchanged).

**Why [CORE-010]:** the target is **about 30 cards added in a winning run, in total**, of which **2–3 per corporation are bought** at Uplinks (UPL-008). A card after every BREACH gave about 45 card rewards per run. One per ICE Node on the way in gives 6–7 + the Central Node = **7–8 per corporation, about 22 per run** (MAP-002); with 6–9 cards bought, that's **28–31 cards**. Fewer, better choices keep decks lean and make each pick matter. The odds table keeps going deeper worth the risk now that the extra reward per layer is gone.

### 9.2 Extraction (CORE-012: reserve-only payouts)
- Each encounter has a **CRED reserve**, larger in deeper layers.
- **Extractors** (Programs) pay CRED from that reserve at the end of your turn.
- Extraction transfers only CRED actually remaining in the reserve. **There is no full-extraction bonus.** A 15-CRED reserve pays at most **15 CRED through extraction**, not 17; once empty, further extraction pays 0 (CORE-012).
- Staying in an encounter longer to extract more is a risk you choose.

### 9.3 Node completion [NEW]
Clearing **every** layer of an ICE Node gives one extra reward: a CAP. **[CHANGED by NODE-AUTHORITY-001]** The free PATCHWORK option is removed: deck engineering belongs to the Console Lab (§8.3). **[CHANGED by CORE-010]** The rare card option is removed; a full clear already gets the best card odds (§9.1), and this keeps card rewards at about 30 per run.

### 9.4 Clean Node bonus [NEW]
Complete a Node without gaining any TRACE during it: **+5 CRED** (working value).

---

## 10. Corporations and the run

### 10.1 A corporation's network
- A layered map of Nodes. You always move forward, and every route has the same number of Nodes.
- Node icons on the map show **what probably lies ahead**: ICE, Uplink, DEAD DROP, Console Lab, SAFEHOUSE, or **SIGNAL UNCLEAR** (unknown). **[CHANGED]** Previously Nodes were fully hidden. Showing likely contents fits the surveillance theme (you're watching the corporation too) and makes route choice a real decision.
- **Structure [CHANGED by UPL-007]:** a heist in three parts. Every route has **15 Nodes**: **10 infiltration rows → the Central Node → a 4-Node escape** **[CHANGED by MAP-002: was 9 rows]**. This replaces the earlier working size of 6 Nodes per route (CORE-009).

**Infiltration rows** (each row has 3–4 Nodes; each Node links forward to 2–3 Nodes in the next row). **Row 1 is always the corporation's Opening Node** **[NEW, OPEN-001]**: a single fixed Node that every route starts from (§10.1a).

| Rows | Possible Nodes |
|---|---|
| 1 | The **Opening Node** only (§10.1a) |
| 2–5 (Tier 1 ICE) | ICE (80%), SIGNAL UNCLEAR, SAFEHOUSE; **Uplink** in row 4 |
| 6–9 (Tier 2 ICE) | ICE (70%), Console Lab, SIGNAL UNCLEAR, SAFEHOUSE; **Uplink** in row 7 |
| 10 | **Uplink or DEAD DROP only:** the last chance to prepare |

**Why 10 rows [MAP-002]:** about **6–7 ICE Nodes per route** (measured: 6.2 on a random route plus about 0.2 AMBUSH events; up to about 9 on a route chosen for ICE), so about 7–8 card rewards per corporation with the Central Node. The ICE odds per row are in `rules.json` (`map.node_odds`).

- **SAFEHOUSEs** appear in **1–2** of the 10 infiltration rows (never row 1, an Uplink row or row 10).

### 10.1a The Opening Node [NEW, OPEN-001]
Every corporation starts with the same designed encounter, so every run gets **one guaranteed card reward per corporation** and every corporation teaches its main lesson before the random rows begin.
- **One layer, two ICE:** a **support** ICE with no DEADLOCK that supplies the pressure, and a **main** ICE that holds the only DEADLOCK.
- **BOOTING:** the main ICE's DEADLOCK **can't be broken before your 3rd turn** of the encounter. Every Rustler needs **at least 3 turns**; turns 1–2 are for decisions: set up, extract (reserve **15 CRED**), defend, or break the support's subroutines.
- **Low STR (3)** on both ICE, so every Rustler's fallback card can reach the DEADLOCK. Measured with the starter decks: **3 turns minimum, about 4 on average** across the four Rustlers.
- Normal rewards: the Node's card reward (1-layer odds) and, as a full clear, the completion reward.

| Corporation | Opening Node | Lesson |
|---|---|---|
| HALCYON | **COOKIE BANNER** (ACCEPT ALL + REJECT ALL) | Only DEADLOCKs block BREACH: read every ICE. |
| IRONWATCH | **FRONT DESK** (TURNSTILE + SECURITY GUARD) | SHIELD blocks PULP and expires every turn: block it or break it. |
| LUCIDA | **INTAKE** (BASELINE SCAN + ONBOARDING) | FORGET takes random cards, and CACHED cards are safe. |

Details: `REDLINE_ICE_CORP1.md` §8.4, `REDLINE_ICE_CORP2.md` §6a, `REDLINE_ICE_CORP3.md` §7a.
- Every route can reach **at least 1 Uplink** (row 10 always offers one). Every Uplink has a Clinic (§8.3).

### 10.2 Central Node and the payload [CHANGED by UPL-007]
A boss-style ICE encounter. Defeating it gives you the corporation's **payload**, an **encrypted data core**: choose **1 of 3 Ghostware**, **active immediately** (usable during the escape). The rest of the core stays encrypted until you escape, when NUL/REM decrypts it into a **First Signal fragment** **[CHANGED by P5-009]**. See `REDLINE_UPGRADES_EVENTS_ESCAPE.md` §2.5.

### 10.3 Escape [NEW, UPL-007]
After the Central Node, you have to get out:
- **4 Nodes:** **3 single-layer ICE encounters** using that corporation's **countermeasure ICE**, plus **exactly 1 SAFEHOUSE**.
- **TRACE gains are doubled** throughout the escape.
- **No leaving early.** JACK OUT still works here, with its other limits (UPL-009): it moves you on to the next escape Node.
- **No card rewards** in escape encounters (CORE-010). Extractors still earn CRED, which you spend at the next corporation's Uplinks.
- No Uplinks, Console Labs or other upgrade Nodes, apart from the one SAFEHOUSE.
- **TRACE is doubled because the corporation is tracking its own data core.**
- Complete the escape to decrypt the core (a First Signal fragment) and move on. If VITAE reaches 0 during the escape, the run ends as normal.

### 10.4 Moving to the next corporation
Keep your deck, PATCHWORK and Ghostware (including the payload). Restore VITAE to max. Remove all CORTEX counters. Reset TRACE and strikes to 0.

### 10.5 Run length target [CHANGED by UPL-007]
**75–100 minutes** for a full run (previously 45–75). Roughly: about 6–7 ICE Nodes on the way in (≈12 encounters with layers) + the boss + 3 escape encounters ≈ **16 encounters per corporation**, **about 48 per run**, at 3–4 turns each (MAP-002 adds about one encounter per corporation). The Training Node playtest should measure real minutes per encounter before these numbers are fixed.

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
| 1 | FORTRESS Icepick | PROGRAM — ICEPICK (FORTRESS) | 1 BW, 1 RAM | STR 1. Boost: 1 BW +1 STR. First break each turn free, then 1 BW per break. |
| 1 | TUMBLER Icepick | PROGRAM — ICEPICK (TUMBLER) | 1 BW, 1 RAM | STR 3. Boost: 2 BW +1 STR. Break: 1 BW. *(Was the SIGYL Icepick; ROT-001.)* |
| 1 | VOID Icepick | PROGRAM — ICEPICK (VOID) | 1 BW, 1 RAM | STR 0. Boost: 1 BW +1 STR. Break: 1 BW. |
| 1 | Basic Extractor | PROGRAM — EXTRACTOR | 1 BW, 1 RAM | End of your turn: extract 3 CRED. |
| 1 | **CORTEX BUFFER** **[CHANGED]** | PROGRAM | 1 BW, 1 RAM | Once per encounter, prevent 1 CORTEX. *(Replaces SYN BUFFER, since SyN is removed. Deliberately not tagged CLOAK, so installing it doesn't power up WATCHDOG.)* |
| 3 | PULP Shield | SCRIPT — CLOAK | 1 BW | +3 SHIELD. |
| 3 | PROBE | SCRIPT — EXPLOIT | 0 BW base | Choose one: Target ICE: −2 STR this encounter. OR Target VOID: Reveal all hidden subroutines. Costs 1 additional BW for each PROBE already played on the target ICE this turn. |
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
| RULE-129 + amendment (CORTEX → SyN → PULP order) | §6 — CORTEX then PULP |
| CORTEX damage enhancement (discard + 5 PULP overflow) | §6 — CORTEX is counters only |
| DMG-001, DMG-002 (three damage types, three pools) | §6 — two types, one SHIELD pool |
| SOFT-014, SOFT-015 (PULP prevention pools) | §2, §6 — SHIELD |
| VITAE-CAPACITY-001 (no defined maximum) | §2 — Max VITAE 30, can be raised |
| TRACE-004 (100% TBD) | §7 — strike ladder |
| JACK OUT retreat (Bible canon) and its RUN-003 conflict | §8.2 — JACK OUT moves forward |
| RUN-005 (Node contents fully hidden) | §10.1 — likely contents shown |
| SYN BUFFER (GENERALIST-STARTER-LOCK-001) | §13 — CORTEX BUFFER |
| TAX-004 / TAX-017 Hardware uninstall cost (1 BW) | §3.1 — all Programs unload for 0 BW |
| Executable / Packet card-frame naming (§41) | §3.1 — PROGRAM / SCRIPT on the card |

**Still in force as engine specification:** RULE-001 to RULE-124 and RULE-130 to RULE-143, except where they refer to SyN, separate prevention pools, or the old damage order. Those parts are void. Implementers use them for exact timing; players never see them.

**Unchanged and still authoritative:** Icepick profiles, CRED reserves and extraction, BREACH, left-to-right Corporation Response, CACHE, BURNED, RACK, Bloatware, DEAD DROP, three-corporation structure, forward-only map, NUL/REM and all World Bible canon.

---

## 16. Phase 1 decision record (all APPROVED, 2026-11-12)

| ID | Decision | Result |
|---|---|---|
| CORE-001 | **CORTEX BUFFER** replaces SYN BUFFER in the Generalist deck (§13). | Approved |
| CORE-002 | **WATCHDOG `[S2]`** becomes DISCARD 1 (§14). | Approved |
| CORE-003 | **Max VITAE 30** at start; healing capped at Max VITAE; raising Max VITAE also raises current VITAE by the same amount (§2). Supersedes VITAE-CAPACITY-001. | Approved |
| CORE-004 | **TRACE strike ladder** as written (§7). Fills TRACE-004. | Approved |
| CORE-005 | **Leaving a Node early** between layers, and **JACK OUT moving forward** (§8.2). | Approved |
| CORE-006 | **Card reward (1 of 3, or skip) after every BREACH** (§9.1). | Approved; **superseded by CORE-010** |
| CORE-007 | **Map shows likely Node contents**, with some SIGNAL UNCLEAR (§10.1). Supersedes RUN-005 hidden contents. | Approved |
| CORE-008 | **Card frame shows one type** (PROGRAM / SCRIPT / PROTOCOL / BLOATWARE) with HARDWARE/SOFTWARE as tags; all Programs unload for 0 BW (§3.1). | Approved |
| CORE-009 | **Working values:** Clean Node bonus +5 CRED; 6 Nodes per corporation route. Retune after playtesting. | Approved (working values); Node count **superseded by UPL-007** |

Earlier decisions for this redesign (also 2026-11-12): damage is PULP + CORTEX only; this document is the single rules authority; design is approved per phase.

**Next phase:** Phase 2 — Rustlers: 3–4 playable Rustlers with starter decks, signature Icepicks, fallback cards and ORIGIN Ghostware.

### Later amendments (Phase 4, `REDLINE_UPLINK_AND_CAPS.md`)

| ID | Change to this document |
|---|---|
| UPL-003 | JACK OUT gives −5 TRACE and has timing limits (§8.2). |
| UPL-006 | Uplink services (Wipe, Clinic) and the SIGNAL UNCLEAR data purge (§8.3). *Historical: Node services are now defined only in §8.3 (NODE-AUTHORITY-001); Wipe moved to the Console Lab.* |
| UPL-006a | Data purge's TRACE cost raised from +5 to **+7**; the −5 VITAE option is unchanged (designer, 2026-11-18). |
| UPL-007 | Heist structure: 9 infiltration rows → Central Node → 4-Node escape; SAFEHOUSE Nodes; payload kept only on escape (*later changed by P5-009: the payload Ghostware is active immediately*); run length target 75–100 minutes (§1, §8.3, §10). Supersedes CORE-009's 6 Nodes per route. |
| P5-009 | The payload is an encrypted data core: its Ghostware is active immediately; the core is decrypted into a First Signal fragment after the escape (§10.2, §10.3). |

### Later amendments (Training Node playtest, 2026-11-12)

| ID | Change to this document |
|---|---|
| CORE-010 | Card reward **once per ICE Node** at the end of the Node, not after every BREACH, and none in the escape; about 21 card rewards per winning run, about 30 cards added with Uplink purchases (UPL-008). Rarity odds improve with layers cleared (60/30/10, 45/40/15, 30/45/25). Early-exit reward provision superseded by **CORE-011**: neither leaving early nor JACK OUT grants a card reward. Node completion reward is now a CAP or a PATCHWORK upgrade (no rare card) (§4, §8.2, §9.1, §9.3). Supersedes CORE-006. |

### Later amendments (corporations 2 and 3, 2026-11-13)

| ID | Change to this document |
|---|---|
| ICE3-002 | New subroutine effect **FORGET X** (§5.2), introduced by LUCIDA (`REDLINE_ICE_CORP3.md` §3). |
| ICE3-002a | FORGET sends cards to the **bottom of your draw pile** instead of BURNING them: BURNING could remove a Rustler's only fallback breaker and leave an encounter impossible to BREACH (found in simulation). |
| BASIC-001 | **Structural rule: starter cards are the weakest cards** (§3.1a). Basic cards are no longer sold at the Uplink (amends UPL-005). Starter changes: HUSH STR 3 and boost 2 BW; STINGER STR 0; ADRENAL SPIKE gain 1 BW; LAY LOW −3 TRACE. BATTERING RAM gains a free first break each turn. |
| MAP-002 | **10 infiltration rows** (was 9): row 1 Opening Node, rows 2–5 Tier 1 (Uplink in row 4), rows 6–9 Tier 2 (Uplink in row 7), row 10 Uplink or DEAD DROP. ICE odds 80% (Tier 1 rows) and 70% (Tier 2 rows), for about 6–7 ICE Nodes per route (§10.1, §10.5). Amends UPL-007. |
| OPEN-001 | **Row 1 is the corporation's Opening Node** (§10.1, §10.1a): a fixed one-layer encounter with a BOOTING main ICE (DEADLOCK unbreakable before your 3rd turn). Guarantees 1 card reward per corporation. |

### Later amendments (naming, 2026-11-13)

| ID | Change to this document |
|---|---|
| NAME-001 | **ICE types and a damage type renamed, no rules changed.** ICE types: WALL → **FORTRESS**, CODE GATE → **SIGYL**, SENTRY → **VOID**. Damage: VOID → **CORTEX** (same counters: −1 DRAW each). VOID ICE are the main source of CORTEX damage, but any ICE can deal it. Card and tag names follow (e.g. VOID BUFFER → CORTEX BUFFER; ICEPICK (WALL) → ICEPICK (FORTRESS)); ICE names such as COOKIE WALL are unchanged. Applied across all PANOPTICON docs; earlier decision records that say WALL, CODE GATE, SENTRY or VOID now read with the new names. Moves away from Netrunner's ICE vocabulary. — **APPROVED 2026-11-13** |

### Later amendments (JACK OUT, 2026-11-13)

| ID | Change to this document |
|---|---|
| UPL-009 | **JACK OUT works during the escape** (§8.2, §10.3). The "not during an escape" limit added by UPL-007 is removed as unnecessary. Its other limits still apply, so it can't be used in escape encounter 3 while the Black ICE (HOUSE CALL, LETHAL FORCE, EGO DEATH) has an unbroken subroutine. — **APPROVED 2026-11-13** |

### Later amendments (2026-11-14)

| ID | Change to this document |
|---|---|
| DRAW-001 | **DRAW is 6** (was 5), still reduced by CORTEX (§2). With 4 BW, choosing what *not* to play becomes a decision every turn. — **APPROVED 2026-11-14** |
| PULP-002 | **PULP curves** (§5.2): a subroutine can deal a sequence of PULP values instead of a fixed number (A sequential, B random, C hammer). — **APPROVED 2026-11-14** |
| RUN-001 | **END RUN:** the player may end the run at any time outside the Corporation Response (with a confirmation). The Rustler fails and the game returns to the start menu. — **APPROVED 2026-11-14** |

| ROT-001 | **TUMBLER replaces SIGYL**; subroutines rotate through slots on a conveyor; only slotted subroutines can be broken; broken stays broken; BREACH needs every DEADLOCK (§4, §5.4). — **APPROVED 2026-11-13** |
| FIX-001 | **DISCARD** from a subroutine resolves at the start of your next turn, after the draw (§4.1, §5.2). — **APPROVED 2026-11-13** |
| FIX-002 | **Boost installed Icepicks** at any time on your turn; boosts last the encounter (§4.2). — **APPROVED 2026-11-13** |
| TUNE-001 | ICE **STR +1** (Opening) / **+2** (Tier 1, Black ICE) and **PULP ×4/3** rounded up (values in `REDLINE_ICE_CORP1.md` §5.0). — **APPROVED 2026-11-13** |
| DET-001 | **DETAINER** TUMBLER subtype: S1 −1 BW next turn; ~20% of TUMBLERS; max 1 per encounter (§5.5). — **APPROVED 2026-11-13** |
| VOID-001 | **VOID reveal**: face-down subroutines fire progressively and are revealed as they fire (§5.6). — **APPROVED 2026-11-13** |
| PLAY-001 | The Corporation Response **plays out over at least 5 seconds**, one subroutine at a time (§4.4). — **APPROVED 2026-11-13** |
| ICEBIBLE-001 | **Type identities**: FORTRESS hits hard (highest STR, mostly PULP), TUMBLER is the puzzle, VOID is deadly (§5.1). — **APPROVED 2026-11-13** |
| PASSIVE-001 | **Subtypes and passive abilities** on the slice ICE (§5.5). — **BUILT for playtest 2026-11-13** |
| PURGE-001 | **Corporation PURGE** at a hidden, rising virus-counter limit (§4.4, §5.7). — **APPROVED 2026-11-14** |
| VIRUS-001 | **WORM** (was: copy counters to the ICE on the right at turn start): on your turn, at any time, remove 2 WORM counters from an ICE to break 1 subroutine on that ICE of your choice (normal break rules apply: it must be active or revealed, not locked by BOOTING, and SEQUENCED order is respected; it needs no Icepick, ignores the ICE's STR, costs no BW (TOLL doesn't apply) and can only be used on your turn). — **APPROVED 2026-11-14** |
| VECTOR-001 | **PATIENT ZERO** (VECTOR's ORIGIN): at the start of each encounter, **choose an ICE** and INFECT 1 ROT on it (was every ICE). — **APPROVED 2026-11-14** |
| REEL-001 | TUMBLER slots shown as **slot-machine reels**, labelled with their subroutine (§5.4). — **APPROVED 2026-11-14** |


## CORE-011 — Card reward requires final-layer BREACH (APPROVED, 2026-11-14)

The designer explicitly revises early-exit rewards: **if the Rustler leaves a Node before breaching its final ICE layer, no end-of-Node card reward is awarded**. Breaching one or more earlier layers is insufficient. Leaving early bypasses the card-reward screen and reward generation, performs normal Node-end cleanup, and moves forward to the next map choice (or slice completion when appropriate). Banked CRED, existing extraction/clean-node CRED rules, LOCKDOWN exit restrictions, and normal route progression are unchanged. A full clear still offers its usual three-card choice, of which the Rustler may take one or skip. No new per-layer card reward is introduced.

This supersedes CORE-010 **only where it granted a card reward for leaving early**, including its earlier §8.2/§9.1 wording and examples in supporting documents. Final-layer breach and the established voluntary END TURN/completion sequence remain required. Escape encounters still grant no card rewards. Card-count/economy projections from the earlier early-reward model are historical targets to re-evaluate in playtesting, not a reason to restore the removed reward.


## CORE-012 — Remove the full-extraction CRED bonus (APPROVED, 2026-11-14)

The designer explicitly removes the **10% rounded-up full-extraction bonus** from both the game and its rules. Extraction pays only what is actually transferred from the remaining finite reserve: `payout = min(extraction amount, remaining reserve)`. Depleting a reserve does not create or refill CRED and does not award any additional CRED. Empty reserves pay 0 on subsequent attempts. Example: COOKIE BANNER's **15-CRED** reserve contributes exactly **15 CRED** when fully extracted, not 17.

This **removes/supersedes NODE-EXTRACTION-001 and NODE-EXTRACTION-002** and all historical training/economy examples that added the bonus. Reserve sizes, printed extraction amounts, banked CRED, full-extraction notifications, and unrelated explicitly defined rewards are unchanged. In particular, the separate §9.4 Clean Node rule is not a full-extraction bonus and is unchanged by this instruction. The earlier full-extraction bonus is not an alternative active rule.


## EXTRACT-002 — Basic Extractor pays 3 CRED per turn (APPROVED, 2026-11-14)

The designer reduces **Basic Extractor** from 5 to **3 CRED at the end of each eligible Rustler turn**. This is the shared Basic Extractor card in all four starter decks. Installation remains **1 BW / 1 RAM**, and normal eligible end-turn timing, including the final BREACHED turn, is unchanged. Payout remains capped by the current encounter's remaining reserve, banked immediately, and grants **no full-extraction bonus** (CORE-012). A reserve of 15 takes five unmodified 3-CRED payouts to empty; if only 1 CRED remains, the final payout is 1.

This supersedes the **5-CRED amount only** in EXTRACT-001 and older starter tables/examples. It does not change other named Extractors' printed rates or SMASH & GRAB's separate paid uninstall/CACHE ability.


## ECHO-005 — BORROWED CREDENTIALS targeted dual-cost SCRIPT (APPROVED, 2026-11-14)

ECHO's BACKDOOR is replaced by **BORROWED CREDENTIALS**: **1 BW + 8 CRED**, SCRIPT — EXPLOIT. Select a FORTRESS or VOID when playing it; HUSH may break that selected ICE for this Rustler turn using normal Strength, boosts and break costs. The SCRIPT does not break anything by itself. Validate the target and availability of both resources before payment; a rejected play spends neither and leaves the card in hand. On success discard the SCRIPT normally. The target-specific compatibility expires at Rustler turn end. See `REDLINE_RUSTLERS.md` ECHO-005 for the complete card revision. This supersedes BACKDOOR's earlier direct-break profile only; other Icepicks and costs are unchanged.

### Later amendments (deck synergy and pacing, APPROVED 2026-11-15)

The designer approved `REDLINE_DECK_SYNERGY.md` (DSY-001 to DSY-014) and `REDLINE_PACING.md` (PACE-001 to PACE-010) as written, for the next build. **Where these amendments conflict with the text above, the amendments win;** the full rules are in those two docs.

| ID | Change to this document |
|---|---|
| DSY-001 | **FOOTPRINT** (cards in your deck, Bloatware not counted) shown at all times with a **cap per corporation**: HALCYON 22, IRONWATCH 29, LUCIDA 35 (§2 screen rule, §10.1). **Bloat tax:** at the start of each ICE Node, gain TRACE equal to FOOTPRINT − the cap (§8.1). GHOST band (6+ below the cap): +1 DRAW on the first turn of each encounter is optional (DSY-001b). — **APPROVED 2026-11-15** |
| DSY-002 | Screen rules: FOOTPRINT / cap, draw chance per card this encounter, COVERAGE panel (a breaker for each ICE type), tag density (§2). — **APPROVED 2026-11-15** |
| DSY-003 | **DECOMPILE:** the full-clear card reward (§9.1) also offers removing 1 card from your deck. Floor 10 cards; can't leave an ICE type with no breaker. — **APPROVED 2026-11-15** |
| DSY-006 | Deck-size targets **18–22 / 24–29 / 30–35** at the end of HALCYON / IRONWATCH / LUCIDA replace §9.1's "about 30 cards added". — **APPROVED 2026-11-15** |
| DSY-007 | **REBOOT** (§3.2, §4.1): when you need to draw and your draw pile is empty, shuffle your discard pile into it, then keep drawing. "Whenever you REBOOT" effects are ENGINE effects. — **APPROVED 2026-11-15** |
| DSY-009 | **MARGIN** (Icepick STR − ICE STR) shown in the break preview; **OVERKILL X** keyword. *(Its UNDERFLOW part, STR below 0 and ROT's minimum removed, is withdrawn by ZEROED-001.)* — **APPROVED 2026-11-15; amended 2026-11-16** |
| DSY-011 | **CHAIN [TAG]** keyword: a bonus if the last card you played this turn had that tag. HUD shows "Last played". — **APPROVED 2026-11-15** |
| DSY-012 | **HOLD 1** was approved 2026-11-15 and superseded by **HAND-CLEANUP-001**. |
| HAND-CLEANUP-001 | No free HOLD between turns. Discard remaining non-CACHED cards in cleanup and draw 6 at base DRAW on the next Rustler turn. — **APPROVED 2026-11-17** |
| PACE-001 | Encounter length targets **4–5 turns early, 5–8 mid–late**, boss 7–8, escape 4–5, replace §10.5's 3–4 turns. — **APPROVED 2026-11-15** |
| PACE-003 | **DEADLOCK ×N** subroutines need N breaks (§5.2). BOOTING moves to the 4th turn **only if** playtest 2 shows the Opening Node breached before turn 4 (would amend §10.1a). — **APPROVED 2026-11-15** |
| PACE-005 | **ESCALATE ↑:** a TRACE, DISCARD or FORGET subroutine that grows by 1 each time it resolves (§5.2). — **APPROVED 2026-11-15** |
| PACE-008 | **Fewer layers:** Tier 1 Nodes 1 layer, Tier 2 Nodes 1–2 (§8.1). Card reward odds re-based (§9.1): Tier 1 1-layer = 60/30/10; Tier 2 1-layer = 45/40/15; Tier 2 2-layer = 30/45/25. Run length assumes 10–11 encounters per corporation (§10.5). — **APPROVED 2026-11-15** |
| ZEROED-001 | **ICE STR can't go below 0**; reductions past 0 are lost; ROT keeps its minimum 0 (§5.3, §5.7). **ZEROED** keyword, **once per ICE per encounter** (§5.3). Replaces DSY-009's UNDERFLOW: too much confusion and counting for the player. — **APPROVED 2026-11-16** (designer) |
| TUMBLE-001 | **TUMBLE:** a broken TUMBLER subroutine drops out of the pool; the unbroken ones slide into its place and the next unbroken one tumbles into the last slot, active at once; the conveyor skips broken subroutines; rotation stops when every unbroken subroutine is showing (§5.4). Replaces "broken stays broken… rotates out and back in". — **APPROVED 2026-11-16** (designer) |

### Later amendments (hand size, 2026-11-19)

| ID | Change to this document |
|---|---|
| HAND-MAX-001 | **Maximum hand size 10.** Every card in hand counts, CACHED cards and Bloatware included. A draw that would take the hand past 10 stops, and the card stays on the draw pile (§4, draw step). *Interpretation to confirm:* any other effect that would move a card into a full hand does nothing. — **APPROVED 2026-11-19** |

### Later amendment — BYPASS-001 (2026-11-24)

Designer rule: BYPASS is permitted only in non-final encounters (ICE layers) of a Node, which has up to three encounters. It is prohibited in the final encounter, including a single-encounter Node. Eligibility is not automatic success; specific BYPASS effects and resolution remain open. See Master Design BYPASS-001.

## TRACE-DEF-001 — TRACE definition (designer approved 2026-11-27)
TRACE represents the extent of a corporation's actionable knowledge of the Rustler's whereabouts and activities. As TRACE increases, the corporation becomes increasingly capable of locating the Rustler and determining and deploying effective countermeasures. TRACE is not merely an alarm meter. Existing numerical thresholds, strikes, reset and countermeasure rules remain unchanged. Commercial identity disclosure and NUL/REM behavioural intelligence are distinct; no automatic TRACE linkage is authorized.


## NODE-PURPOSE-001 — Non-combat Node service redesign (APPROVED 2026-11-27)

*Reference only (NODE-AUTHORITY-001): current Node purposes and services are defined in Core Rules §8.3 ([Node authority](REDLINE_CORE_RULES.md#node-authority)); the decision and its history are in Master Design. The copy that stood here was retired (git history keeps it).*

## MAP-003f / MINIBOSS-003 — Approved 2026-11-27
Every complete route must contain 2–3 Uplinks, at least one each SAFEHOUSE, DEAD DROP, Console Lab, SIGNAL UNCLEAR, exactly seven noncombat Nodes. All other MAP-003e constraints remain. Valid distributions in that order: (3,1,1,1,1), (2,2,1,1,1), (2,1,2,1,1), (2,1,1,2,1), (2,1,1,1,2). Distinct Mini-Boss icon identifies category only; identity and unique ability concealed until entry; fight mandatory on entry. Supersedes pre-entry ability disclosure. Claude Code assignment: audit Python prototypes/map/map003_generator.py V4, implement V5 retaining V4 comparison, deterministic seeds, bounded attempts, validate every route of at least 200 accepted maps, no unreachable nodes/dead ends, report acceptance rate, performance, route counts, distribution frequencies, miniboss accessibility/bypass and reproducibility. GDScript port and UI integration subsequent tasks; no engine changes in this assignment. Representative ICE Encounter remains priority 1.


## UPLINK-SPEC-001 — Approved functional development specification (2026-11-27)

*Reference only: the Uplink functional specification (UPLINK-SPEC-001) is kept in `REDLINE_UPLINK_AND_CAPS.md`, with Node services in Core Rules §8.3 (NODE-AUTHORITY-001). The copy that stood here was retired (git history keeps it).*

## PROBE-004a — Canonical PROBE wording and scope (APPROVED, 2026-11-27)
Confirms PROBE-004 and extends its authoritative wording across Architecture V2, not only the Core Loop build. PROBE is a STARTER SCRIPT — EXPLOIT, base cost 0 BW. Printed rules: **Choose one: Target ICE: −2 STR this encounter. OR Target VOID: Reveal all hidden subroutines. Costs 1 additional BW for each PROBE already played on the target ICE this turn.** Both modes share the same per-target, per-turn count across copies (0, 1, 2… BW); reset each turn. Reveal is available only on VOID with hidden subroutines; STR reduction does not reveal anything. Flavour: “The deeper you probe, the costlier it gets.” Supersedes conflicting older PROBE costs, automatic/top-only reveal and effect descriptions. Historical decisions remain historical. Claude Code follow-up: audit existing mode selection, engine, CardDB text, both UI paths and tests; reconcile discrepancies, verify both modes, shared cost, reset, invalid targets, cancellation and insufficient BW; run required Godot validation before committing code. Until validated, the existing CardDB description is known stale; no claim of runtime correction. Use approved wording in UI mockups.
