# PANOPTICON — CARD POOLS
**Version:** 0.1 (Phase 3B of the simplified redesign)
**Date:** 2026-11-12
**Status:** **APPROVED 2026-11-12.** All seven Phase 3B decisions (CARD-001 to CARD-007) were approved by the designer (§8). Builds on `REDLINE_CORE_RULES.md` v0.2, `REDLINE_RUSTLERS.md` v0.1 and `REDLINE_ICE_CORP1.md` v0.1.

**Goal of this phase:** the cards offered as rewards and sold at the Black Market Uplink: one shared pool any Rustler can find, and one pool per Rustler that deepens their playstyle.

> All numbers are **working values** for playtesting.

---

## 1. Card value guide

So cards are priced consistently, **1 BW is worth about**:

| Effect | ≈ 1 BW |
|---|---|
| SHIELD | +3 |
| ICE STR reduction (this encounter) | −2 |
| TRACE removal | −4 |
| Cards drawn | 1, plus a small extra |
| CRED extracted (once) | 5 |
| Breaking a subroutine (with the right Icepick) | 1 |

**Adjustments:**
- **+2 TRACE** on a card pays for about **1 BW** of extra effect (loud cards are cheaper).
- **BURNED after use** (once per Node) allows about **+50% power**.
- **Uncommon** cards are about **10–20% stronger** than common ones, or do something unusual. **Rare** cards can be about **30–40% stronger**, or break a rule.
- **PROGRAMS** last the whole Node, so they're priced on what they give **over about 3 turns**. *(PROTOCOLS now last one encounter and then go to the discard pile, PROTOCOL-DURATION-001/a/b and UI-PROTOCOL-001; Core Rules §3.1 owns their lifecycle.)*

---

## 2. Rarity and rewards

| Rarity | Chance in a reward slot | Uplink price (working) |
|---|---|---|
| **Common** | 60% | 40 CRED *(was 25)* |
| **Uncommon** | 30% | 60 CRED *(was 40)* |
| **Rare** | 10% | 90 CRED *(was 65)* |

**Prices raised by UPL-008** so a corporation's CRED buys about **2–3 cards**, keeping a winning run at about 30 cards added in total (Core Rules §9.1).

- Card rewards (once per **fully cleared** ICE Node, CORE-010 as amended by CORE-011; **none for leaving early**): **2 shared + 1 Rustler-specific** (approved RUSTLER-007). Each slot rolls its rarity separately.
- **Rarity improves with depth** (CORE-010): the odds above are for a fully cleared 1-layer Node. Fully cleared 2-layer Nodes: 45/40/15%. Fully cleared 3-layer Nodes: 30/45/25%. Partial clears give no card reward (CORE-011).
- **Node completion reward:** see Core Rules §9.3.
- **Console Lab card removal:** see Core Rules §8.3.

---

### 2.1 Starter-card audit (BASIC-001)

Rule: every starter card is the weakest version of its role, with at least one clear upgrade in the reward pools for the Rustler who starts with it (Core Rules §3.1a). Basic cards are never sold or offered as rewards.

| Starter card | Who starts with it | Clear upgrades | Change made |
|---|---|---|---|
| PROBE (−2 STR or reveal all hidden VOID subroutines; PROBE-004a) | All | DEEP PROBE (twice the effect per card), BALANCED LOAD, STRESS TEST, KEYLOGGER | — |
| PULP Shield (+3 SHIELD) | All | HARDENED SHELL, MIRROR, SURGE PROTECTOR | — |
| GHOST SIGNAL | Generalist, ECHO, VECTOR | SCRUB (not BURNED), PROXY CHAIN, VANISH | — |
| Basic Extractor (3 CRED) | All | DATA SIPHON, SKIMMER | — |
| FORTRESS Icepick | Generalist | **BATTERING RAM**, JACKHAMMER | BATTERING RAM gains a free first break each turn |
| TUMBLER Icepick | Generalist | PASSKEY, RAINBOW TABLE | — |
| VOID Icepick | Generalist | TASER, STUN BATON | — |
| CORTEX BUFFER | Generalist | FAILSAFE | — |
| HUSH | ECHO | PASSKEY, RAINBOW TABLE | **HUSH weakened:** STR 4 → 3, boost 1 → 2 BW (it was better than PASSKEY) |
| BORROWED CREDENTIALS | ECHO | SIDE CHANNEL, SKELETON KEY, ADAPTER | ECHO-005: replaces BACKDOOR; 1 BW + 8 CRED for chosen-ICE HUSH compatibility this turn |
| SLOW DRIP | ECHO | DATA SIPHON, SILENT PARTNER, LONG GAME | — |
| SMOKESCREEN | ECHO | MIRROR, PATIENCE, PROXY CHAIN | — |
| DEAD AIR | ECHO | STASH (CACHE 2) | — |
| SLEDGE | RIOT | BATTERING RAM, JACKHAMMER (no TRACE per break) | (via BATTERING RAM) |
| BRUTE FORCE | RIOT | WRECKING BALL, CHAINSAW, FLASHPOINT | — |
| OVERLOAD | RIOT | SMASH, DEEP PROBE | — |
| FEEDBACK | RIOT | SMASH, BERSERK | — |
| ADRENAL SPIKE | RIOT | BURST, QUANTUM CORE, ROAR | **Weakened:** gain 2 BW → 1 BW (it beat BURST) |
| LAY LOW | RIOT | SCRUB, CRASH CART, NO WITNESSES | **Weakened:** −5 → −3 TRACE (it beat SCRUB) |
| SMASH & GRAB | RIOT | DATA SIPHON (no TRACE), SKIMMER | — |
| STINGER | VECTOR | TASER, STUN BATON | **Weakened:** STR 2 → 0 (TASER had nothing over it) |
| RUNTIME ERROR | VECTOR | HOST TAKEOVER, SKELETON KEY | — |
| INJECT | VECTOR | WORMHOLE, COCKTAIL, FUSE → MEGADOSE | — |
| REPLICATOR, OUTBREAK | VECTOR | INCUBATOR, PANDEMIC | — |

**Effect on difficulty:** the starter decks got weaker, not the rewards stronger (apart from BATTERING RAM), so ICE didn't need raising. The Opening Nodes still take every Rustler 3+ turns (about 4 on average); their pace comes from BOOTING.

## 3. Shared pool (31 cards)

### 3.1 Icepicks — covering weak ICE types (7)
<!-- GENERATED:cards ids=BATTERING_RAM,JACKHAMMER,PASSKEY,RAINBOW_TABLE,TASER,STUN_BATON,SKELETON_KEY -->
*Generated from `godot/data/cards.json` by `tools/csa/gen_card_docs.py`. Edit the card records, not this table.*

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **BATTERING RAM** | Common | PROGRAM — ICEPICK (FORTRESS) | 1 BW, 1 RAM | STR 3. Boost: 1 BW → +1 STR. First break each turn free; then 1 BW per break. |
| **JACKHAMMER** | Uncommon | PROGRAM — ICEPICK (FORTRESS) | 1 BW, 1 RAM | STR 2. Boost: 1 BW → +2 STR. First break each turn free; then 1 BW. |
| **PASSKEY** | Common | PROGRAM — ICEPICK (TUMBLER) | 1 BW, 1 RAM | STR 3. Boost: 1 BW → +1 STR. Break: 1 BW. |
| **RAINBOW TABLE** | Uncommon | PROGRAM — ICEPICK (TUMBLER) | 1 BW, 1 RAM | STR 2. Boost: 1 BW → +1 STR. Break: 1 BW for up to 2 subroutines on the same ICE. |
| **TASER** | Common | PROGRAM — ICEPICK (VOID) | 1 BW, 1 RAM | STR 2. Boost: 1 BW → +1 STR. Break: 1 BW. |
| **STUN BATON** | Uncommon | PROGRAM — ICEPICK (VOID) | 1 BW, 1 RAM | STR 2. Boost: 1 BW → +1 STR. Break: 1 BW. Each break: +2 SHIELD. |
| **SKELETON KEY** | Rare | PROGRAM — ICEPICK (any type) | 2 BW, 2 RAM | STR 3. Boost: 2 BW → +1 STR. Break: 1 BW. Works on FORTRESS, TUMBLER and VOID. |
<!-- /GENERATED -->

*History:* BATTERING RAM gained its free first break in BASIC-001, so it beats the FORTRESS Icepick and SLEDGE.

### 3.2 Extractors and CRED (3)
<!-- GENERATED:cards ids=DATA_SIPHON,SKIMMER,PAYDAY -->
*Generated from `godot/data/cards.json` by `tools/csa/gen_card_docs.py`. Edit the card records, not this table.*

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **DATA SIPHON** | Common | PROGRAM — EXTRACTOR | 1 BW, 1 RAM | End of your turn: extract 6 CRED. |
| **SKIMMER** | Uncommon | PROGRAM — EXTRACTOR | 0 BW, 1 RAM | When installed: extract 4 CRED. End of your turn: extract 4 CRED. |
| **PAYDAY** | Rare | SCRIPT — EXTRACTOR, EXPLOIT | 1 BW, +2 TRACE | Extract 12 CRED now. (+2 TRACE) |
<!-- /GENERATED -->

### 3.3 Defence (5)
<!-- GENERATED:cards ids=HARDENED_SHELL,FLINCH,MIRROR,SURGE_PROTECTOR,FAILSAFE -->
*Generated from `godot/data/cards.json` by `tools/csa/gen_card_docs.py`. Edit the card records, not this table.*

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **HARDENED SHELL** | Common | SCRIPT — CLOAK | 2 BW | +7 SHIELD. |
| **FLINCH** | Common | SCRIPT — CLOAK | 0 BW | +2 SHIELD. BURNED. |
| **MIRROR** | Uncommon | SCRIPT — CLOAK | 1 BW | +3 SHIELD. Draw 1. |
| **SURGE PROTECTOR** | Uncommon | PROTOCOL | 1 BW | Start of each of your turns: +2 SHIELD. |
| **FAILSAFE** | Rare | PROTOCOL | 2 BW | The first time each encounter you would gain CORTEX, prevent all of it. |
<!-- /GENERATED -->

### 3.4 Weakening ICE (4)
<!-- GENERATED:cards ids=DEEP_PROBE,STRESS_TEST,KEYLOGGER -->
*Generated from `godot/data/cards.json` by `tools/csa/gen_card_docs.py`. Edit the card records, not this table.*

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **DEEP PROBE** | Common | SCRIPT — EXPLOIT | 2 BW | Target ICE: −5 STR this encounter. |
| **STRESS TEST** | Uncommon | SCRIPT — EXPLOIT | 1 BW | Every ICE: −1 STR this encounter. |
| **KEYLOGGER** *(not built yet)* | Uncommon | PROGRAM — EXPLOIT | 1 BW, 1 RAM | Start of your turn: choose an ICE; it gets −1 STR this encounter. |
<!-- /GENERATED -->

*History:* LOGIC BOMB (Rare, 3 BW: target ICE's STR becomes 0 until the end of your turn; BURNED) was deprecated on 2026-11-17 (DEPRECATE-001) and has no card record.

### 3.5 Cards, BW and RAM (6)
<!-- GENERATED:cards ids=DEFRAG,STASH,STIM_PATCH,BURST,CO_PROCESSOR,QUANTUM_CORE -->
*Generated from `godot/data/cards.json` by `tools/csa/gen_card_docs.py`. Edit the card records, not this table.*

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **DEFRAG** | Common | SCRIPT | 0 BW | Discard 1 card, then draw 2. |
| **STASH** *(not built yet)* | Common | SCRIPT — CLOAK | 1 BW | CACHE up to 2 cards in your hand. |
| **STIM PATCH** | Uncommon | SCRIPT | 0 BW, +2 TRACE | Draw 2. (+2 TRACE) |
| **BURST** | Uncommon | SCRIPT | 3 BW | Gain 5 BW. Each time you play this card this encounter, it costs 1 more BW for the rest of the encounter. |
| **CO-PROCESSOR** | Uncommon | PROGRAM — HARDWARE | 2 BW | +1 RAM. |
| **QUANTUM CORE** *(not built yet)* | Rare | PROGRAM — HARDWARE | 2 BW, 1 RAM | Start of your turn: gain 1 BW. |
<!-- /GENERATED -->

### 3.6 TRACE control (3)
<!-- GENERATED:cards ids=SCRUB,PROXY_CHAIN,BURN_NOTICE -->
*Generated from `godot/data/cards.json` by `tools/csa/gen_card_docs.py`. Edit the card records, not this table.*

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **SCRUB** | Common | SCRIPT — CLOAK | 1 BW | −4 TRACE. |
| **PROXY CHAIN** | Uncommon | PROTOCOL | 1 BW | Whenever you would gain TRACE during a Corporation Response, gain 1 less. |
| **BURN NOTICE** | Rare | SCRIPT — CLOAK | 2 BW | Halve your TRACE (round down). BURNED. |
<!-- /GENERATED -->

### 3.7 Bloatware and recovery (3)
<!-- GENERATED:cards ids=SPAM_FILTER,UNINSTALLER,PATCH_KIT -->
*Generated from `godot/data/cards.json` by `tools/csa/gen_card_docs.py`. Edit the card records, not this table.*

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **SPAM FILTER** | Common | PROTOCOL | 1 BW | The first Bloatware the corporation would INSERT each encounter goes to your discard pile instead. |
| **UNINSTALLER** | Uncommon | SCRIPT | 1 BW | Choose a Bloatware in your hand: it's BURNED. Draw 1. |
| **PATCH KIT** | Uncommon | SCRIPT | 1 BW | Heal 4 VITAE. BURNED. |
<!-- /GENERATED -->

---

## 4. THE GENERALIST's pool (9) — "a tool for every job"

<!-- GENERATED:cards ids=FIELD_KIT,TOOLBELT,BALANCED_LOAD,HOT_SWAP,ADAPTER,RAM_UPGRADE,READY_STANCE,MULTITOOL,JACK_OF_ALL_TRADES -->
*Generated from `godot/data/cards.json` by `tools/csa/gen_card_docs.py`. Edit the card records, not this table.*

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **FIELD KIT** | Common | SCRIPT | 1 BW | Search your draw pile for a PROGRAM and put it in your hand. |
| **TOOLBELT** | Common | PROTOCOL | 1 BW | Your first Icepick boost each turn costs 0 BW. |
| **BALANCED LOAD** | Common | SCRIPT — CLOAK, EXPLOIT | 1 BW | +2 SHIELD. Target ICE: −1 STR this encounter. |
| **HOT SWAP** *(not built yet)* | Common | SCRIPT | 0 BW | Unload one of your PROGRAMS, then install a PROGRAM from your hand for 0 BW. |
| **ADAPTER** | Uncommon | PROGRAM | 1 BW, 1 RAM | Your Icepicks can break subroutines on any ICE type, for +1 BW per break. |
| **RAM UPGRADE** | Uncommon | PROGRAM — HARDWARE | 1 BW | +1 RAM. |
| **READY STANCE** | Uncommon | PROTOCOL | 2 BW | On the first turn of each encounter, draw 1 extra card. |
| **MULTITOOL** | Rare | PROGRAM — ICEPICK (any type) | 1 BW, 1 RAM | STR 2. Boost: 1 BW → +1 STR. Break: 2 BW. |
| **JACK OF ALL TRADES** *(not built yet)* | Rare | SCRIPT — EXPLOIT | 2 BW | If you have a FORTRESS, a TUMBLER and a VOID Icepick installed: on every ICE, break 1 subroutine for 0 BW using your matching Icepick. Each Icepick still needs enough STR. |
<!-- /GENERATED -->

---

## 5. ECHO's pool (9) — "never there"

<!-- GENERATED:cards ids=MUFFLE,GHOST_STEP,PATIENCE,DECOY_SIGNAL,SILENT_PARTNER,LONG_GAME,VANISH,SIDE_CHANNEL,BLACKOUT -->
*Generated from `godot/data/cards.json` by `tools/csa/gen_card_docs.py`. Edit the card records, not this table.*

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **MUFFLE** | Common | SCRIPT — CLOAK | 0 BW | −2 TRACE. |
| **GHOST STEP** | Common | SCRIPT — CLOAK | 1 BW | Draw 2. |
| **PATIENCE** | Common | SCRIPT — CLOAK | 1 BW | +4 SHIELD if you've gained no TRACE this encounter; otherwise +2 SHIELD. |
| **DECOY SIGNAL** | Common | SCRIPT | 1 BW | Until the end of your turn, VOID reactive abilities do nothing. |
| **SILENT PARTNER** | Uncommon | PROGRAM — EXTRACTOR | 1 BW, 1 RAM | End of your turn: extract 2 CRED for each CLOAK card you played this turn. |
| **LONG GAME** | Uncommon | PROTOCOL | 1 BW | While your TRACE is under 10, your Extractors extract +2 CRED each. |
| **VANISH** | Uncommon | SCRIPT — CLOAK | 2 BW | During the next Corporation Response, TRACE effects add nothing. BURNED. |
| **SIDE CHANNEL** | Rare | PROGRAM — ICEPICK (any type) | 2 BW, 1 RAM | STR 3. Boost: 2 BW → +1 STR. Break: 2 BW. Any ICE type. |
| **BLACKOUT** | Rare | SCRIPT — CLOAK | 3 BW | Skip the next Corporation Response. BURNED. |
<!-- /GENERATED -->

**Note:** DECOY SIGNAL is not tagged CLOAK, so playing it doesn't set off the abilities it's meant to stop.

---

## 6. RIOT's pool (9) — "subtle is for people with time"

<!-- GENERATED:cards ids=SMASH,ROAR,CRASH_CART,PAIN_TOLERANCE,BERSERK,WRECKING_BALL,CHAINSAW,FLASHPOINT,NO_WITNESSES -->
*Generated from `godot/data/cards.json` by `tools/csa/gen_card_docs.py`. Edit the card records, not this table.*

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **SMASH** | Common | SCRIPT — EXPLOIT | 0 BW, +3 TRACE | Target FORTRESS: −4 STR this encounter. (+3 TRACE) |
| **ROAR** | Common | SCRIPT | 0 BW, +3 TRACE | Draw 2. (+3 TRACE) |
| **CRASH CART** | Common | SCRIPT — CLOAK | 1 BW | −3 TRACE. +2 SHIELD. |
| **PAIN TOLERANCE** | Uncommon | PROTOCOL | 1 BW | Start of your turn: if your TRACE is 20 or more, +2 SHIELD. |
| **BERSERK** | Uncommon | PROTOCOL | 1 BW | While your TRACE is 20 or more, your EXPLOIT SCRIPTS cost 1 less BW (minimum 0). |
| **WRECKING BALL** | Uncommon | PROGRAM — ICEPICK (TUMBLER) | 1 BW, 1 RAM | STR 3. Boost: 1 BW → +1 STR. Break: 0 BW, +2 TRACE. |
| **CHAINSAW** | Uncommon | PROGRAM — ICEPICK (VOID) | 1 BW, 1 RAM | STR 2. Boost: 1 BW → +1 STR. Break: 0 BW, +2 TRACE. |
| **FLASHPOINT** | Rare | SCRIPT — EXPLOIT | 2 BW, +5 TRACE | Break 1 subroutine on every ICE with STR 3 or less. (+5 TRACE) |
| **NO WITNESSES** | Rare | SCRIPT — CLOAK | 1 BW | If your TRACE is 30 or more, set it to 10. BURNED. |
<!-- /GENERATED -->

---

## 7. VECTOR's pool (9) — "wait for it to rot"

<!-- GENERATED:cards ids=SCRAMBLER,BLINDFOLD,LEECHWARE,QUARANTINE,WORMHOLE,COCKTAIL,INCUBATOR,PANDEMIC,HOST_TAKEOVER -->
*Generated from `godot/data/cards.json` by `tools/csa/gen_card_docs.py`. Edit the card records, not this table.*

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **SCRAMBLER** | Common | SCRIPT — VIRUS | 1 BW | INFECT 2 SCRAMBLE. (Each SCRAMBLE: this ICE's PULP subroutines deal 1 less.) |
| **BLINDFOLD** | Common | SCRIPT — VIRUS | 1 BW | INFECT 2 BLIND. (Each BLIND: this ICE's TRACE subroutines add 1 less.) |
| **LEECHWARE** | Common | SCRIPT — VIRUS | 1 BW | INFECT 2 LEECH. (Each LEECH: extract 1 CRED at the start of your turn.) |
| **QUARANTINE** | Common | SCRIPT — CLOAK | 1 BW | +1 SHIELD for each virus counter on target ICE (maximum +6). |
| **WORMHOLE** | Uncommon | SCRIPT — VIRUS | 1 BW | INFECT 1 WORM and 1 ROT. (WORM: on your turn, remove 2 WORM from an ICE to break 1 of its subroutines. Each ROT: −1 STR.) |
| **COCKTAIL** | Uncommon | SCRIPT — VIRUS | 2 BW | INFECT 1 of each strain (ROT, SCRAMBLE, BLIND, LEECH, WORM). |
| **INCUBATOR** | Uncommon | PROTOCOL | 1 BW | Whenever a PURGE removes virus counters from an ICE, INFECT 2 ROT on that ICE afterward. |
| **PANDEMIC** | Rare | SCRIPT — VIRUS | 3 BW | Copy all virus counters on target ICE onto every other ICE. |
| **HOST TAKEOVER** | Rare | SCRIPT — VIRUS, EXPLOIT | 2 BW | Break 2 subroutines on target ICE with 5 or more virus counters. |
<!-- /GENERATED -->

*History:* WORMHOLE's WORM and ROT strains are VIRUS-001.

---

**Card text rule:** every card that places a strain shows that strain's per-counter effect as reminder text in italics, so players don't need to look up the strain rules.

## 8. Phase 3B decision record (all APPROVED, 2026-11-12)

1. **Card value guide** (§1): 1 BW ≈ 3 SHIELD ≈ −2 STR ≈ −4 TRACE ≈ 5 CRED; +2 TRACE pays for 1 BW; BURNED allows +50%. — **APPROVED 2026-11-12 (CARD-001)**
2. **Rarity, reward odds and Uplink prices** (§2): 60/30/10%; 25/40/65 CRED; removal 40 CRED. — **APPROVED 2026-11-12 (CARD-002)**; card prices **raised to 40/60/90 by UPL-008**
3. **Shared pool** of 31 cards (§3). — **APPROVED 2026-11-12 (CARD-003)**
4. **THE GENERALIST's pool** (§4). — **APPROVED 2026-11-12 (CARD-004)**
5. **ECHO's pool** (§5). — **APPROVED 2026-11-12 (CARD-005)**
6. **RIOT's pool** (§6). — **APPROVED 2026-11-12 (CARD-006)**
7. **VECTOR's pool** (§7), with strain reminder text on each strain card. — **APPROVED 2026-11-12 (CARD-007)**

**After this phase:** the full design for HALCYON-based runs is complete and ready to build in Godot and playtest. Remaining design work would be the second and third corporations, more Ghostware (the Central Node rewards), CAPS, and Uplink stock rules.

### Later amendments (deck synergy and pacing, APPROVED 2026-11-15)

The designer approved `REDLINE_DECK_SYNERGY.md` (DSY-001 to DSY-014) and `REDLINE_PACING.md` (PACE-001 to PACE-010) as written, for the next build. **Where these amendments conflict with the text above, the amendments win;** the full rules are in those two docs.

| ID | Change to this document |
|---|---|
| DSY-006 | Card prices stay at 40 / 60 / 90 CRED pending playtest 2's CRED totals (§2). — **APPROVED 2026-11-15** |
| DSY-007 | Value guide (§1): REBOOT effects are priced for about 1.5 triggers per encounter. — **APPROVED 2026-11-15** |
| DSY-011 | Value guide (§1): a common's CHAIN bonus is about +50% of its main number. — **APPROVED 2026-11-15** |
| DSY-014 | Phase 7 pools: each archetype is one currency loop (SOURCE / AMPLIFIER / CASH OUT / ROUTER) plus one lean-deck payoff, with at least one CASH OUT card. Example cards: `REDLINE_DECK_SYNERGY.md` §9. — **APPROVED 2026-11-15** |
| PACE-007 | Each Rustler pool needs at least 2 HULL engines by uncommon; reward cards show a DRILL / HULL / COVERAGE icon. — **APPROVED 2026-11-15** |
| PACE-008 | Reward odds by layers cleared are re-based for the new layer counts (see Core Rules amendments) (§2). — **APPROVED 2026-11-15** |
| ROT-001 sync | Remaining SIGYL labels changed to **TUMBLER** (ICE types, Icepicks, card text). No numbers changed. — designer instruction 2026-11-16 |


## PROBE-004a — Canonical PROBE wording and scope (APPROVED, 2026-11-27)
Confirms PROBE-004 and extends its authoritative wording across Architecture V2, not only the Core Loop build. PROBE is a STARTER SCRIPT — EXPLOIT, base cost 0 BW. Printed rules: **Choose one: Target ICE: −2 STR this encounter. OR Target VOID: Reveal all hidden subroutines. Costs 1 additional BW for each PROBE already played on the target ICE this turn.** Both modes share the same per-target, per-turn count across copies (0, 1, 2… BW); reset each turn. Reveal is available only on VOID with hidden subroutines; STR reduction does not reveal anything. Flavour: “The deeper you probe, the costlier it gets.” Supersedes conflicting older PROBE costs, automatic/top-only reveal and effect descriptions. Historical decisions remain historical. Claude Code follow-up: audit existing mode selection, engine, CardDB text, both UI paths and tests; reconcile discrepancies, verify both modes, shared cost, reset, invalid targets, cancellation and insufficient BW; run required Godot validation before committing code. Until validated, the existing CardDB description is known stale; no claim of runtime correction. Use approved wording in UI mockups.
