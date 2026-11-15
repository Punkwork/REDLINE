# PANOPTICON — DECK MANAGEMENT & SYNERGY
**Version:** 1.0 (approved; foundation for Phase 7 pool redesign)
**Date:** 2026-11-15
**Status:** **APPROVED 2026-11-15** (designer: "Approve everything as written"), all decisions DSY-001 to DSY-014, **to be implemented in the next build**. Numbers stay **working values** to tune in playtest. Optional and conditional items stay optional or conditional as written (DSY-001b). Decision record in §12. Builds on the approved Core Rules, Rustlers, Card Pools, ICE (all three corporations), Uplink & CAPS, Upgrades, the Engines doc (ENG-001 to ENG-005) and the Pacing doc (PACE-001 to PACE-010).

**Designer's goal (2026-11-15):** the player should build a **lean, synergistic deck** by drafting carefully and removing weak cards, so key cards come up often and the player is **steering an engine**, not just playing whatever is in hand.

**Deck-size target (designer, 2026-11-15):** **30–35 cards by the end of the third corporation (LUCIDA).** *(v0.1 proposed "ideally under 25"; this replaces it.)*

> All numbers are **working values** for playtesting. This doc should be settled **before** Phase 7 (pool redesign into archetypes), because Phase 7's archetypes should be built from the keywords below.

**v0.3 changes (synced with build 0.2.0-playtest.2 and the 2026-11-14 decisions):** **DRAW 6** (DRAW-001) in the draw-chance table and REBOOT pricing (§1, §4.1); **SIGYL → TUMBLER** (ROT-001) in card and ICE text; **CORE-011** (card rewards only for fully cleared Nodes) and **EXTRACT-002 / CORE-012** (Basic Extractor 3 CRED, no full-extraction bonus) in the reward and economy notes (§3); **RIOT's 15-card starter** (RIOT-004) in §2.1; the HALCYON pushback ICE renamed **FREE TRIAL**, because HALCYON already has an ICE called AUTO-RENEW (§8).
**v0.2 changes:** deck-size targets 18–22 / 24–29 / 30–35; FOOTPRINT cap per corporation; FOOTPRINT-based cards and Ghostware re-pointed to the new bands.

---

## 0. The short version

Without changes, the current design pushes decks **toward about 40 cards or more**. This proposal holds decks at **30–35 by the end of the run**, and makes that size feel like a deliberate build, with three player skills, each supported by rules:

| Skill | What the player does | Rules that support it |
|---|---|---|
| **PRUNE** | Keep the deck at or below the corporation's cap, and strong | FOOTPRINT on screen, the bloat tax, DECOMPILE on every card reward, COMPILE, REFACTOR (§2–§3) |
| **BUILD** | Put together a loop where cards feed each other | REBOOT payoffs, the **currency loop** (UNDERFLOW and OVERKILL, virus cash-outs, AMP, CHARGE) (§4–§5) |
| **STEER** | Choose the order of plays and plan across turns | EXPLOIT CHAIN, HOLD 1, SCAN, in-Node BURN (§4, §6) |

**The main idea:** a leaner deck draws its key cards more often. PANOPTICON should also **show** that, **pay off** for it (REBOOT), make it **cheap to pursue** (DECOMPILE), and make a **bloated deck cost TRACE**. A bigger deck leaves a bigger footprint, and in PANOPTICON that's how they find you.

---

## 1. Diagnosis: why the current design grows decks

1. **The card-count target is about 40.** CORE-010 / UPL-008 aim for about 30 cards added to a 12-card starter (RIOT starts at 15), with only 3–5 removed: about 37–40 at the end of a run, above the 30–35 target.
2. **Removal is scarce and gets more expensive.** Wipe costs 50, then 75, then 100 CRED; the Console Lab competes with PATCHWORK; data purge is a random event.
3. **Skipping a reward gives nothing.** On the reward screen, the only way to keep the deck lean is to give the reward up, so players take cards.
4. **Deck size is invisible.** Nothing on screen shows how often a card comes up, and deck size decides whether a key card shows up in an encounter:

| Deck size | Chance to draw a given card by the end of turn 2 | …turn 4 | …turn 6 |
|---:|---:|---:|---:|
| 15 | 80% | 100% | 100% |
| 20 | 60% | 100% | 100% |
| 25 | 48% | 96% | 100% |
| 30 | 40% | 80% | 100% |
| 35 | 34% | 69% | 100% |
| 40 | 30% | 60% | 90% |

*(One copy, DRAW 6 (DRAW-001), no CORTEX. Installed Programs and Protocols leave the cycle, so the real deck is thinner still: a rig of 4–5 Programs takes a 35-card deck down to about 30 cycling cards.)*

**Why 30–35 works with the Pacing proposal:** early encounters last 4–5 turns with decks of about 18–22, and late encounters last 6–8 turns with decks of 30–35 (PACE-001). At each stage an on-target deck sees all of its cards once per encounter. Above the target, it doesn't.

5. **Most cards are independent.** Cards change the board (−STR, SHIELD, −TRACE) but few **read** it. So almost any card is playable with almost any other, and play becomes "spend 4 BW on the best cards in hand." DRAW 6 already makes *what not to play* a choice (DRAW-001); synergy needs cards that **produce** a state and cards that **pay off** on it, so the choice has a direction.

---

## 2. PRUNE, part 1: deck size you can see and feel

### 2.1 FOOTPRINT and the corporation cap (DSY-001) [NEW]
- **FOOTPRINT** = the number of cards in your deck (Bloatware not counted). It's shown on the deck icon at all times, with its band colour.
- Each corporation has a **FOOTPRINT cap**, matching the top of its deck-size target (§3.4):

| Corporation | Cap |
|---|---|
| HALCYON | **22** |
| IRONWATCH | **29** |
| LUCIDA | **35** |

| Band | FOOTPRINT | Effect |
|---|---|---|
| **GHOST** | 6 or more below the cap (HALCYON 16 or less, IRONWATCH 23 or less, LUCIDA 29 or less) | *(optional, DSY-001b)* +1 DRAW on the first turn of each encounter. Cards and Ghostware can also check for GHOST (§9). |
| **LEAN** | Up to the cap | None. This is the target band. |
| **HEAVY** | Above the cap | **Bloat tax:** at the start of each ICE Node, gain **TRACE equal to FOOTPRINT − the cap.** |

- **Why a cap per corporation:** decks are meant to grow across the run, so a single cap would be either meaningless early or crushing late. A cap per corporation keeps the same pressure at every stage.
- **Why TRACE:** it fits the theme (your footprint is how the corporation finds you), it already escalates (strikes), and it resets each corporation, so a bloated deck can recover by pruning. The escape doubles TRACE, so the tax hits hardest when you're carrying the payload.
- **Scale:** 5 cards over the cap means +5 TRACE per ICE Node, about 30–35 per corporation, close to a strike on its own. 2 over means +2 per Node, which you'll notice but can live with.
- **Moving to the next corporation:** the new cap applies from the new corporation's first Node, so a deck at 24 leaving HALCYON is comfortably inside IRONWATCH's cap of 29.
- **RIOT starts at 15 cards** (RIOT-004), so it has 3 fewer cards of room under HALCYON's cap than the other Rustlers and starts outside the GHOST band. That fits RIOT's heavier, louder style; check in playtest that it isn't squeezed.
- **RIOT watch (open):** RIOT likes high TRACE (REDLINER), and RIOT-004's profiling showed its runs end at TRACE strikes. The bloat tax adds more TRACE; watch in playtest whether a heavy RIOT deck is a legitimate "loud and heavy" build or a trap.

### 2.2 Screen rules (DSY-002) [NEW]
- **FOOTPRINT and cap:** the deck icon shows *"21 / 22"* in the band colour.
- **Hit rate:** in the deck view and on the reward screen, each card shows **"Draw chance this encounter: X%"**, based on the current FOOTPRINT, DRAW and the stage's typical encounter length (PACE-001). When you consider a reward, the screen shows how the rate changes for **your key cards** if you take it (e.g. *"STINGER: 96% → 92%"*).
- **COVERAGE panel:** FORTRESS / TUMBLER / VOID, each ticked if your deck has a card that can break that type (a matching Icepick, an any-type Icepick or a fallback such as BRUTE FORCE or BORROWED CREDENTIALS). It's shown on the deck view and on every removal screen.
- **Tag density:** the deck view shows how many cards carry each tag (EXPLOIT 7 · CLOAK 5 · VIRUS 4 …). CHAIN (§6.1) makes this number matter.

---

## 3. PRUNE, part 2: every reward can shrink the deck

### 3.1 DECOMPILE on the card reward screen (DSY-003) [CHANGED: amends CORE-010 / CORE-011]
The ICE Node card reward becomes: **take 1 of 3 cards**, **or DECOMPILE** (remove 1 card from your deck), **or skip**.
- **When:** wherever a card reward is offered, which since **CORE-011** means only after a **fully cleared** ICE Node. Leaving early gives neither a card nor a DECOMPILE.
- **Floor:** your deck can't go below **10 cards**.
- **Coverage guard:** you can't remove a card if that would leave an ICE type with no breaker. The COVERAGE panel shows why. *(This keeps ICE3-002a's "never soft-locked" principle.)*
- **Why:** every reward becomes a real **density versus coverage** choice: a better card, or one weak card fewer. Both improve the deck, in different ways. This is the main change in this proposal.
- **Wipe** (Uplink) and **Console Lab removal** stay as they are, but are now extras rather than the main way to prune.

### 3.2 COMPILE: two cards become one (DSY-004) [NEW]
Wherever you can apply a PATCHWORK (Console Lab, SAFEHOUSE, Node completion, BLACK CLINIC, REFACTOR), you may **COMPILE** instead:
- Choose **2 different SCRIPTs that share a tag**. They become **1 COMPILED card**.
- **Cost:** the sum of both BW costs (maximum 4 BW), plus any TRACE or CRED either card costs. **Effect:** both effects, in an order you choose when compiling. **Tags:** both cards' tags.
- Uses the card's one PATCHWORK slot; any existing PATCHWORK on either card is lost (the game warns you first). A compiled card can't be compiled or FUSED again.
- **Name:** both names, e.g. **PROBE ⨯ PULP SHIELD** (−2 STR and +3 SHIELD, 2 BW, EXPLOIT + CLOAK).
- **Why:** COMPILE saves no BW; it saves **draws**. Each draw does two jobs, and the deck shrinks by one. FUSE (same card, ×1.5) stays the better deal per BW; COMPILE is the flexible one. Compiled cards carry both tags, so they're natural CHAIN bridges (§6.1).

### 3.3 REFACTOR, a new Uplink service (DSY-005) [NEW]
**Once per visit: apply 1 PATCHWORK, FUSE or COMPILE for 50 CRED.** It gives CRED somewhere to go that improves the deck without adding to it. **Economy watch:** EXTRACT-002 and CORE-012 lowered CRED income, so 50 CRED may be too expensive; price it from playtest 2's CRED totals.

### 3.4 Deck-size targets (DSY-006) [CHANGED: replaces CORE-010's "about 30 cards added"]
**End-of-run target set by the designer: 30–35 cards.** The stage targets below are proposed to reach it, from a 12-card starter deck (RIOT: 15).

| End of… | Target deck size | FOOTPRINT cap | What a typical corporation looks like |
|---|---|---|---|
| HALCYON | **18–22** | 22 | 6–7 rewards: about 5 taken, 1–2 DECOMPILE; 1–2 bought; 1 Wipe or FUSE |
| IRONWATCH | **24–29** | 29 | About 5–6 taken, 1–2 DECOMPILE; 1–2 bought; a COMPILE or FUSE |
| LUCIDA | **30–35** | 35 | About 6 taken, 1 DECOMPILE; 1–2 bought, to cover CORTEX and FORGET |

- **Net growth:** about **+6 to +10 cards per corporation**: roughly 8 added and 2 removed.
- **Card rewards:** CORE-010 planned about 7–8 per corporation. **CORE-011** (no reward for leaving early) lowers that for players who leave Nodes early, so the real number has to come from playtest 2. If rewards fall short, the targets above lean on Uplink purchases and fewer DECOMPILEs.
- **Card prices:** the **40 / 60 / 90 CRED prices stay** for now. CRED income is lower since EXTRACT-002 and CORE-012, so recheck after playtest 2 whether 2–3 cards per corporation are still affordable.
- **A sloppy run** finishes 5+ cards over each cap and feels the bloat tax every corporation.

---

## 4. BUILD, part 1: lean decks pay off (REBOOT)

### 4.1 REBOOT (DSY-007) [NEW: fills an undefined rule]
The Core Rules don't yet say what happens when the draw pile runs out. Proposal:
- When you need to draw and your draw pile is empty, shuffle your discard pile into it, then keep drawing. **This is a REBOOT.**
- Cards and Ghostware can say **"Whenever you REBOOT: …"**. Those effects resolve after the draw finishes. They're **ENGINE** effects, so AMP applies (ENG-001).
- **HUD:** beside the deck, *"Draw pile 6 · REBOOT in ~1 turn."*
- The draw pile carries across layers in a Node.

**How often (pricing guide, with DRAW 6 and PACE-001 encounter lengths):** an on-target deck REBOOTs **about 1.5 times per encounter** at every stage: early, about 15–18 cycling cards over 4–5 turns (24–30 draws); late, about 25–30 cycling cards over 6–8 turns (36–48 draws). A deck in the GHOST band REBOOTs **about twice or more**; a HEAVY deck about **once or less**. **Price REBOOT effects for about 1.5 triggers per encounter.**

**This is the lean-deck payoff:** deck size → REBOOT frequency → AMP / BW / SHIELD → engine output. It turns pruning from a defensive habit into an engine.

### 4.2 Shrinking the deck inside a Node (DSY-008) [NEW keyword: SCAN]
- **In-Node BURN:** a few cards BURN other cards for the rest of the Node, so the cycle gets shorter and REBOOTs come sooner. Burned cards come back at the next Node, as usual.
- **SCAN X:** look at the top X cards of your draw pile; put any of them on the bottom, in any order. SCAN lets you steer what's coming. It also works against LUCIDA's FORGET: you know which cards went to the bottom.

---

## 5. BUILD, part 2: the currency loop

### 5.1 The synergy grammar
Every reward card should play **one clear role** for one **currency**:

| Role | What it does | Example |
|---|---|---|
| **SOURCE** | Produces the currency | INJECT (virus counters), OVERLOAD (−STR) |
| **AMPLIFIER** | Multiplies it | REPLICATOR, OUTBREAK, GAIN STAGE |
| **CASH OUT** | Spends it for a burst | HOST TAKEOVER, WORM breaks (VIRUS-001), UNLOAD, KILL |
| **ROUTER** | Moves cards so the loop comes together | SCAN, TAIL CALL, CACHE, FIELD KIT |

**Phase 7 rule:** each archetype is **one currency loop plus one lean-deck payoff**, and every archetype needs at least one CASH OUT card.

### 5.2 The currencies, and how they feed each other

| Currency | Lives on | Source | Amplifier | Cash out | Feeds into |
|---|---|---|---|---|---|
| **−STR / UNDERFLOW** (§5.3) | ICE | PROBE, OVERLOAD, ROT, FUZZER | STACK SMASH, CHAIN EXPLOIT | OVERKILL, INTEGER UNDERFLOW | Cheaper breaks → BW for everything else |
| **Virus counters** | ICE | INJECT, strains | REPLICATOR, OUTBREAK, AMP | HOST TAKEOVER, WORM breaks, CULL, HARVEST (§5.4) | ROT → UNDERFLOW; LEECH → CRED |
| **AMP** | You | GAIN STAGE, ROLLING RESTART | REBOOT frequency | (constant) | Strains, PROCESSES, Extractors |
| **CHARGE** | Programs | SLUSH FUND, BUFFER OVERFLOW, ZOMBIE | Time | UNLOAD, KILL | −STR, CRED, SHIELD |
| **CHAIN** (§6.1) | The turn | Tag density | Compiled cards (two tags) | CHAIN bonuses | Whichever tag you chain |
| **REBOOT** (§4.1) | The deck | Low FOOTPRINT, in-Node BURN | FORCE REBOOT | REBOOT effects | AMP, BW, SHIELD, −TRACE |
| **TRACE** | You | Loud cards | REDLINER | FEEDBACK, NO WITNESSES | RIOT's BW |

The important links are **across** currencies: ROT feeds UNDERFLOW, REBOOT feeds AMP, AMP feeds strains and PROCESSES, OVERKILL refunds BW. This gives two-archetype hybrids (VECTOR ROT + UNDERFLOW, CRON + REBOOT) a real reason to exist. A 30–35-card deck has room for **one main loop plus a second, smaller one**, which a 20-card deck doesn't.

### 5.3 UNDERFLOW, MARGIN and OVERKILL: payoffs for stacking STR (DSY-009) [CHANGED: STR minimum]
Today, any STR reduction beyond what your Icepick needs is wasted. Proposal:
- **UNDERFLOW:** ICE STR **can go below 0.** It's shown in red as a negative number. ROT's "minimum 0" is removed.
- **MARGIN** = your Icepick's STR − the ICE's STR at the moment you break. Boosting your Icepick and lowering the ICE both raise it, so **one number covers both kinds of STR stacking.** The break preview (Core Rules §5.3 screen rule) shows MARGIN.
- **OVERKILL X:** a keyword on Icepicks and cards: *"If MARGIN is X or more when this breaks, [bonus]."*
- **Existing cards and ICE that need checking:** DEADBOLT / SYNAPSE BARRIER / AMNESIA ("can't go below 3/4/3") still work as written. HARDENING (+1 STR after each response) and RELAY (+2 STR to the ICE on its right) raise an underflowed ICE normally. LOGIC BOMB sets STR to 0, so it **raises** an underflowed ICE; reword it to "−X STR equal to its current STR" or leave it as an intentional anti-synergy. BRUTE FORCE, ZOMBIE and FLASHPOINT ("STR X or less") work naturally.
- **Related idea (RIOT, discussed 2026-11-15):** a **ZEROED** keyword — *"If this card brings target ICE from above 0 STR to 0 or less, [bonus]"* — as RIOT's payoff for driving one ICE down. Not yet written up; to be added with RIOT's Phase 7 pool.

### 5.4 Virus cash-outs (DSY-010) [NEW cards]
Virus counters mostly pile up; WORM (VIRUS-001) is the first strain you spend. More cards that **remove counters for a burst** create VECTOR's hold-or-cash-out decision: spend them now, or let REPLICATOR keep growing them. The corporation **PURGE** (PURGE-001: a hidden, rising limit on total counters) makes this sharper: every counter you cash out lowers the total, so cashing out also delays the next PURGE.

---

## 6. STEER: choosing the order and planning ahead

### 6.1 EXPLOIT CHAIN (DSY-011) [NEW keyword]
- A card can print **CHAIN [TAG]: [bonus]**. You get the bonus if **the last card you played this turn** had that tag.
- **HUD:** *"Last played: EXPLOIT"* next to BW.
- Installing Programs and deploying Protocols count as playing them. Using an Icepick or a CAP doesn't change the last played card.
- **Why:** this is the most direct answer to "not just playing what's in hand." The same cards played in a different order give different results, and **tag density** becomes a deckbuilding stat.
- **Natural counters already in the game:** DOORBELL CAM (WATCHER) and WATCHDOG punish CLOAK chains; EMPATHY ENGINE and ROADBLOCK punish EXPLOIT chains; TRIPWIRE punishes many breaks. Chaining stays a decision, not autopilot.
- **Pricing (CARD-001 addition):** a common's CHAIN bonus is about +50% of its main number; an uncommon's can be a different effect.

### 6.2 HOLD 1 (DSY-012) [CHANGED: base rule]
- **At the end of your turn, you may CACHE 1 card in your hand for free.**
- **Why:** keeping one card lets you plan a combo for next turn deliberately. Spreading LUCIDA's "CACHE protects you" lesson to everyone fits that corporation's teaching role. With 30–35-card decks late in the run, HOLD 1 is what keeps a combo reliable. It also helps against TUMBLERS, whose next set of subroutines you only see at the start of your turn (ROT-001).
- **Knock-on effects:** **DEAD MAN'S POCKET** (Ghostware) becomes "you may CACHE up to 2 cards for free each turn." ECHO's DEAD AIR and SMASH & GRAB's paid uninstall (RIOT-005) still matter (extra CACHE). The Training Node lock stays: HOLD 1 is off there.

---

## 7. Each Rustler's loop

| Rustler | Main loop | Lean-deck hook | The tension |
|---|---|---|---|
| **Generalist** | COMPILE and CHAIN: alternate EXPLOIT and CLOAK; compiled cards bridge both | READY RIG plus a deck at or below the cap makes setup reliable | COVERAGE: it needs all three types, and every cut tests that |
| **ECHO** | REBOOT plus CLOAK CHAIN: small deck, every REBOOT sheds TRACE, long extraction stays | The deck most likely to live in the GHOST band | WATCHER ICE (DOORBELL CAM) punish CLOAK chains; BORROWED CREDENTIALS costs CRED |
| **RIOT** | UNDERFLOW and OVERKILL plus EXPLOIT CHAIN: stack OVERLOAD and PROBE far below 0, then cash out (ZEROED, §5.3) | Starts at 15 cards, so pruning matters early | TRACE from loud cards **and** the bloat tax; EMPATHY ENGINE, ROADBLOCK |
| **VECTOR** | Virus counters → ROT UNDERFLOW → cash out (WORM, CULL, HARVEST, HOST TAKEOVER) | REPLICATOR and OUTBREAK come up every encounter | The corporation PURGE: cash out before it hits |
| **CRON** | AMP via REBOOT (ROLLING RESTART), KILL as the cash-out | REBOOTs pump AMP into every PROCESS | Slow start; THREAD count |

---

## 8. The corporations push back (DSY-013)

Lean decks have natural weaknesses, and the corporations should use them:
- **Bloatware dilutes lean decks more.** 1 SPAM in a 20-card deck is 5% of your draws; in a 40-card deck it's 2.5%. HALCYON's and LUCIDA's INSERT effects already scale against pruning. No change needed.
- **Lean decks resist FORGET and CORTEX** (the bottom of the deck comes round quickly; a smaller hand still cycles). LUCIDA needs an answer to that.
- **One example ICE per corporation** (working names; at most one passive per ICE, PASSIVE-001):

| Corp | ICE | Type / STR | Subroutines | Ability |
|---|---|---|---|---|
| HALCYON (T2) | **FREE TRIAL** *(renamed: HALCYON already has an AUTO-RENEW)* | TUMBLER 4 | 2 slots of 4: TRACE 2 · DEADLOCK · PULP 3 · DEADLOCK | Whenever you REBOOT: INSERT 1 SPAM into your draw pile. |
| IRONWATCH (T2) | **PATTERN ANALYSIS** | VOID 4 | [S1] PULP 3 · [S2] DEADLOCK | Whenever you get a CHAIN bonus: PULP 1. |
| LUCIDA (T2) | **RECURRING DREAM** | TUMBLER 4 | 2 slots of 3: FORGET 1 · TRACE 2 · DEADLOCK | Whenever you REBOOT: FORGET 1. |

---

## 9. Example cards (working values)

Priced with CARD-001 (1 BW ≈ 3 SHIELD ≈ −2 STR ≈ −4 TRACE ≈ 1 card drawn). These are examples for Phase 7, not a finished pool.

### 9.1 Shared pool candidates
| Card | Rarity | Type / tags | Cost | Effect | Role |
|---|---|---|---|---|---|
| **PIVOT** | Common | SCRIPT — EXPLOIT | 1 BW | Target ICE −2 STR this encounter. **CHAIN CLOAK:** −1 more. | CHAIN teaching card |
| **COVER FIRE** | Common | SCRIPT — CLOAK | 1 BW | +3 SHIELD. **CHAIN EXPLOIT:** +2 more. | CHAIN teaching card |
| **PORT SCAN** | Common | SCRIPT | 0 BW | SCAN 3, then draw 1. | ROUTER |
| **GARBAGE COLLECT** | Common | SCRIPT | 0 BW | BURN 1 other card in your hand. Draw 1. | In-Node thinning |
| **WARM BOOT** | Common | PROTOCOL — ENGINE | 1 BW | Whenever you REBOOT: +5 SHIELD. *(v0.3: back to +5, since DRAW 6 makes REBOOTs about 1.5 per encounter.)* | REBOOT payoff |
| **TAIL CALL** | Uncommon | SCRIPT | 1 BW | Put a SCRIPT from your discard pile into your hand. | ROUTER |
| **FORCE REBOOT** | Uncommon | SCRIPT | 0 BW | Shuffle your discard pile into your draw pile (this is a REBOOT). BURNED. | REBOOT enabler |
| **ROLLING RESTART** | Uncommon | PROTOCOL | 1 BW | Whenever you REBOOT: +1 AMP. | REBOOT → AMP bridge |
| **MINIMALIST** | Uncommon | PROTOCOL | 1 BW | While your FOOTPRINT is in the **GHOST** band, your first break each turn costs 0 BW. | FOOTPRINT payoff |
| **SCALPEL** | Uncommon | PROGRAM — ICEPICK (TUMBLER) | 1 BW, 1 RAM | STR 2. Boost: 1 BW → +1 STR. Break: 1 BW. **OVERKILL 2:** the break costs 0 BW. | MARGIN payoff |
| **SHORT LOOP** | Rare | PROTOCOL — ENGINE | 2 BW | Whenever you REBOOT: gain 1 BW and draw 2. | REBOOT payoff |
| **ZERO FOOTPRINT** | Rare | SCRIPT — CLOAK | 1 BW | −1 TRACE for each card your FOOTPRINT is below the corporation's cap (maximum −10). BURNED. | FOOTPRINT payoff |
| **KILL CHAIN** | Rare | PROTOCOL | 2 BW | Whenever you get a CHAIN bonus, draw 1 (maximum 2 per turn). | CHAIN AMPLIFIER |

### 9.2 Rustler pool candidates
| Card | Pool | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|---|
| **HANDOFF** | ECHO | Common | SCRIPT — CLOAK | 0 BW | −2 TRACE. **CHAIN CLOAK:** draw 1. |
| **STACK SMASH** | RIOT | Uncommon | SCRIPT — EXPLOIT | 1 BW | Target ICE −1 STR for each EXPLOIT card you've played this turn (including this one). |
| **INTEGER UNDERFLOW** | RIOT | Rare | SCRIPT — EXPLOIT | 2 BW | Break 1 subroutine on target ICE (DEADLOCKs included) for each point its STR is below 0 (maximum 3). Normal limits apply: only active or revealed subroutines, BOOTING and SEQUENCED respected. BURNED. |
| **CULL** | VECTOR | Common | SCRIPT — VIRUS | 1 BW | Remove up to 3 virus counters from target ICE: +2 SHIELD for each one removed. |
| **HARVEST** | VECTOR | Uncommon | SCRIPT — VIRUS | 0 BW | Remove all LEECH from target ICE: extract 3 CRED for each one removed. |
| **CLEAN BUILD** | Generalist | Uncommon | PROTOCOL | 1 BW | Your COMPILED cards cost 1 less BW. |

### 9.3 Ghostware candidates
| Ghostware | Effect |
|---|---|
| **HEARTBEAT** | Whenever you REBOOT, −2 TRACE. |
| **MINIMAL INSTALL** | At the start of each ICE Node, if your FOOTPRINT is in the GHOST band, +1 AMP. |
| **DEDUPLICATOR** | FUSE works on any card type, not only SCRIPTs. |
| **ONE-TRICK** *(drawback)* | **+1 BW every turn.** ⚠ Your deck can't grow past the corporation's cap minus 4 (HALCYON 18, IRONWATCH 25, LUCIDA 31): at that size, the card reward screen offers only DECOMPILE or skip. |

---

## 10. Changes to existing documents (approved 2026-11-15; recorded as amendments in each doc)

| Document | Section | Change |
|---|---|---|
| Core Rules | §2 screen rule | FOOTPRINT and cap, REBOOT countdown, "Last played" tag (DSY-001/002/007/011) |
| Core Rules | §3.2 | Add REBOOT; add HOLD 1 (DSY-007, DSY-012) |
| Core Rules | §5.3 | STR may go below 0 (UNDERFLOW); MARGIN shown in the break preview (DSY-009) |
| Core Rules | §8.1 | Bloat tax at ICE Node start, against the corporation's cap (DSY-001) |
| Core Rules | §9.1 | DECOMPILE option on full-clear rewards; deck-size targets 18–22 / 24–29 / 30–35 replace "about 30 cards added" (DSY-003, DSY-006) |
| Core Rules | §10.1 | FOOTPRINT cap per corporation (22 / 29 / 35) (DSY-001) |
| Core Rules | §5.7 | ROT: "minimum 0" removed (DSY-009) |
| Card Pools | §1 | Value guide: CHAIN bonus ≈ +50%; REBOOT effects priced at about 1.5 triggers per encounter (DSY-007) |
| Upgrades | §1.2 | COMPILE alongside FUSE (DSY-004); DEAD MAN'S POCKET → CACHE 2 (DSY-012) |
| Uplink & CAPS | §3.1 | REFACTOR service (DSY-005) |
| Engines | §1 | REBOOT effects are ENGINE effects (DSY-007) |
| Playtest checklist | G1, G5 + new | New targets and checks (§11) |

---

## 11. Rollout and playtest

**Order (each step can be played before the next):**
1. **Economy and UI only, no new cards:** FOOTPRINT + cap + hit rate + COVERAGE, DECOMPILE, bloat tax, new targets (DSY-001/002/003/006). Uses today's pools. This alone answers "do decks land at 30–35, and do players feel the cap?"
2. **REBOOT + SCAN + in-Node BURN** (DSY-007/008) with 4–6 example cards.
3. **CHAIN + HOLD 1** (DSY-011/012).
4. **UNDERFLOW / OVERKILL / ZEROED + virus cash-outs** (DSY-009/010).
5. **COMPILE, REFACTOR, Ghostware, corporation pushback ICE** (DSY-004/005/013).
6. **Phase 7** pools, built on the grammar in §5.1.

**New playtest checks (added to `REDLINE_PLAYTEST_CHECKLIST.md` v0.2):**

| ID | Check | Target |
|---|---|---|
| G1 (revised) | Cards added vs removed this corporation | About 8 added, about 2 removed |
| G5 (revised) | Deck size at the end of the corporation | HALCYON 18–22 · IRONWATCH 24–29 · LUCIDA 30–35 |
| G6 | Times you chose DECOMPILE over a card you liked | At least once per corporation: it was a real choice |
| G7 | REBOOTs per encounter | About 1.5 on target; 2 or more in the GHOST band |
| G8 | A turn where the order of plays mattered (CHAIN) | Most encounters |
| G9 | Held a card (HOLD 1) for a planned combo | Most encounters |
| G10 | Bloat tax: did you ever pay it? Did it feel fair? | Rare in good runs; a clear warning in bad ones |
| G11 | Could you name your deck's loop in one sentence at the Central Node? | Yes |

---

## 12. Decision record

| ID | Decision | Status |
|---|---|---|
| DSY-001 | **FOOTPRINT** shown at all times; **FOOTPRINT cap per corporation** (HALCYON 22, IRONWATCH 29, LUCIDA 35); **bloat tax:** TRACE equal to FOOTPRINT − the cap at the start of each ICE Node. (DSY-001b, optional: GHOST band, 6 or more below the cap, +1 DRAW on the first turn of each encounter.) | **APPROVED 2026-11-15** |
| DSY-002 | **Screen rules:** FOOTPRINT / cap, draw chance per card this encounter, COVERAGE panel, tag density. | **APPROVED 2026-11-15** |
| DSY-003 | **DECOMPILE** on the card reward screen (full clears only, CORE-011): remove 1 card instead of taking one; 10-card floor; coverage guard. | **APPROVED 2026-11-15** |
| DSY-004 | **COMPILE:** 2 different SCRIPTs sharing a tag → 1 card, summed cost (max 4 BW), both effects and tags; uses the PATCHWORK slot. | **APPROVED 2026-11-15** |
| DSY-005 | **REFACTOR** Uplink service: 1 PATCHWORK / FUSE / COMPILE, once per visit; 50 CRED working, priced after playtest 2. | **APPROVED 2026-11-15** |
| DSY-006 | **Deck size 30–35 by the end of LUCIDA** (designer, 2026-11-15). Stage targets **18–22 / 24–29 / 30–35** replace "about 30 cards added"; card prices stay at 40 / 60 / 90 pending playtest 2's CRED totals. | **APPROVED 2026-11-15** |
| DSY-007 | **REBOOT** defined (empty draw pile → shuffle discard pile in); "Whenever you REBOOT" effects are ENGINE effects, priced at about 1.5 triggers per encounter (DRAW 6). | **APPROVED 2026-11-15** |
| DSY-008 | **SCAN X** keyword; in-Node BURN cards. | **APPROVED 2026-11-15** |
| DSY-009 | **UNDERFLOW** (ICE STR can go below 0; ROT minimum removed), **MARGIN**, **OVERKILL X**; **ZEROED** noted for RIOT's pool. | **APPROVED 2026-11-15** |
| DSY-010 | **Virus cash-out** cards (CULL, HARVEST pattern), alongside WORM. | **APPROVED 2026-11-15** |
| DSY-011 | **CHAIN [TAG]** keyword, based on the last card played this turn. | **APPROVED 2026-11-15** |
| DSY-012 | **HOLD 1:** CACHE 1 card free at the end of each turn; DEAD MAN'S POCKET → 2. Off in the Training Node. | **APPROVED 2026-11-15** |
| DSY-013 | **Corporation pushback:** FREE TRIAL, PATTERN ANALYSIS, RECURRING DREAM (working). | **APPROVED 2026-11-15** |
| DSY-014 | **Synergy grammar for Phase 7:** each archetype is one currency loop (SOURCE / AMPLIFIER / CASH OUT / ROUTER) plus one lean-deck payoff, with at least one CASH OUT card. | **APPROVED 2026-11-15** |

**Deliberately not proposed:** a hard deck-size cap (except the ONE-TRICK Ghostware), HP on ICE, or new damage types. The ENG-001 to ENG-005 engines are kept and connected to this system rather than replaced.
