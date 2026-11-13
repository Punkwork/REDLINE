# REDLINE — CARD POOLS
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
- **PROGRAMS** and **PROTOCOLS** last the whole Node, so they're priced on what they give **over about 3 turns**.

---

## 2. Rarity and rewards

| Rarity | Chance in a reward slot | Uplink price (working) |
|---|---|---|
| **Common** | 60% | 40 CRED *(was 25)* |
| **Uncommon** | 30% | 60 CRED *(was 40)* |
| **Rare** | 10% | 90 CRED *(was 65)* |

**Prices raised by UPL-008** so a corporation's CRED buys about **2–3 cards**, keeping a winning run at about 30 cards added in total (Core Rules §9.1).

- Card rewards (once per ICE Node, CORE-010): **2 shared + 1 Rustler-specific** (approved RUSTLER-007). Each slot rolls its rarity separately.
- **Rarity improves with depth** (CORE-010): the odds above are for a Node left after 1 layer. 2 layers cleared: 45/40/15%. 3 layers: 30/45/25%.
- **Node completion reward** (Core Rules §9.3): a CAP or a free PATCHWORK upgrade (no longer a card, since CORE-010).
- **Console Lab card removal:** 40 CRED (working).

---

## 3. Shared pool (31 cards)

### 3.1 Icepicks — covering weak ICE types (7)
| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **BATTERING RAM** | Common | PROGRAM — ICEPICK (WALL) | 1 BW, 1 RAM | STR 3. Boost: 1 BW → +1 STR. Break: 1 BW. |
| **JACKHAMMER** | Uncommon | PROGRAM — ICEPICK (WALL) | 1 BW, 1 RAM | STR 2. Boost: 1 BW → **+2** STR. First break each turn free; then 1 BW. |
| **PASSKEY** | Common | PROGRAM — ICEPICK (CODE GATE) | 1 BW, 1 RAM | STR 3. Boost: 1 BW → +1 STR. Break: 1 BW. |
| **RAINBOW TABLE** | Uncommon | PROGRAM — ICEPICK (CODE GATE) | 1 BW, 1 RAM | STR 2. Boost: 1 BW → +1 STR. **Break: 1 BW for up to 2 subroutines** on the same ICE. |
| **TASER** | Common | PROGRAM — ICEPICK (SENTRY) | 1 BW, 1 RAM | STR 2. Boost: 1 BW → +1 STR. Break: 1 BW. |
| **STUN BATON** | Uncommon | PROGRAM — ICEPICK (SENTRY) | 1 BW, 1 RAM | STR 2. Boost: 1 BW → +1 STR. Break: 1 BW. **Each break: +2 SHIELD.** |
| **SKELETON KEY** | Rare | PROGRAM — ICEPICK (any type) | 2 BW, 2 RAM | STR 3. Boost: 2 BW → +1 STR. Break: 1 BW. Works on WALL, CODE GATE and SENTRY. |

### 3.2 Extractors and CRED (3)
| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **DATA SIPHON** | Common | PROGRAM — EXTRACTOR | 1 BW, 1 RAM | End of your turn: extract 6 CRED. |
| **SKIMMER** | Uncommon | PROGRAM — EXTRACTOR | 0 BW, 1 RAM | When installed: extract 4 CRED. End of your turn: extract 4 CRED. |
| **PAYDAY** | Rare | SCRIPT — EXTRACTOR, EXPLOIT | 1 BW, +2 TRACE | Extract 12 CRED now. |

### 3.3 Defence (5)
| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **HARDENED SHELL** | Common | SCRIPT — CLOAK | 2 BW | +7 SHIELD. |
| **FLINCH** | Common | SCRIPT — CLOAK | 0 BW | +2 SHIELD. BURNED. |
| **MIRROR** | Uncommon | SCRIPT — CLOAK | 1 BW | +3 SHIELD. Draw 1. |
| **SURGE PROTECTOR** | Uncommon | PROTOCOL | 1 BW | Start of each of your turns: +2 SHIELD. |
| **FAILSAFE** | Rare | PROTOCOL | 2 BW | The first time each encounter you would gain VOID, prevent all of it. |

### 3.4 Weakening ICE (4)
| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **DEEP PROBE** | Common | SCRIPT — EXPLOIT | 2 BW | Target ICE: −4 STR this encounter. |
| **STRESS TEST** | Uncommon | SCRIPT — EXPLOIT | 1 BW | Every ICE: −1 STR this encounter. |
| **KEYLOGGER** | Uncommon | PROGRAM — EXPLOIT | 1 BW, 1 RAM | Start of your turn: choose an ICE; it gets −1 STR this encounter. |
| **LOGIC BOMB** | Rare | SCRIPT — EXPLOIT | 3 BW | Target ICE's STR becomes 0 until the end of your turn. BURNED. |

### 3.5 Cards, BW and RAM (6)
| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **DEFRAG** | Common | SCRIPT | 0 BW | Draw 1. |
| **STASH** | Common | SCRIPT — CLOAK | 1 BW | CACHE up to 2 cards in your hand. |
| **STIM PATCH** | Uncommon | SCRIPT | 0 BW, +2 TRACE | Draw 2. |
| **BURST** | Uncommon | SCRIPT | 0 BW | Gain 1 BW. BURNED. |
| **CO-PROCESSOR** | Uncommon | PROGRAM — HARDWARE | 2 BW, 0 RAM | +1 RAM. |
| **QUANTUM CORE** | Rare | PROGRAM — HARDWARE | 2 BW, 1 RAM | Start of your turn: gain 1 BW. |

### 3.6 TRACE control (3)
| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **SCRUB** | Common | SCRIPT — CLOAK | 1 BW | −4 TRACE. |
| **PROXY CHAIN** | Uncommon | PROTOCOL | 1 BW | Whenever you would gain TRACE during a Corporation Response, gain 1 less. |
| **BURN NOTICE** | Rare | SCRIPT — CLOAK | 2 BW | Halve your TRACE (round down). BURNED. |

### 3.7 Bloatware and recovery (3)
| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **SPAM FILTER** | Common | PROTOCOL | 1 BW | The first Bloatware the corporation would INSERT each encounter goes to your discard pile instead. |
| **UNINSTALLER** | Uncommon | SCRIPT | 1 BW | Choose a Bloatware in your hand: it's BURNED. Draw 1. |
| **PATCH KIT** | Uncommon | SCRIPT | 1 BW | Heal 4 VITAE. BURNED. |

---

## 4. THE GENERALIST's pool (9) — "a tool for every job"

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **FIELD KIT** | Common | SCRIPT | 1 BW | Search your draw pile for a PROGRAM and put it in your hand. |
| **TOOLBELT** | Common | PROTOCOL | 1 BW | Your first Icepick boost each turn costs 0 BW. |
| **BALANCED LOAD** | Common | SCRIPT — CLOAK, EXPLOIT | 1 BW | +2 SHIELD. Target ICE: −1 STR this encounter. |
| **HOT SWAP** | Common | SCRIPT | 0 BW | Unload one of your PROGRAMS, then install a PROGRAM from your hand for 0 BW. |
| **ADAPTER** | Uncommon | PROGRAM | 1 BW, 1 RAM | Your Icepicks can break subroutines on any ICE type, for +1 BW per break. |
| **RAM UPGRADE** | Uncommon | PROGRAM — HARDWARE | 1 BW, 0 RAM | +1 RAM. |
| **READY STANCE** | Uncommon | PROTOCOL | 2 BW | On the first turn of each encounter, draw 1 extra card. |
| **MULTITOOL** | Rare | PROGRAM — ICEPICK (any type) | 1 BW, 1 RAM | STR 2. Boost: 1 BW → +1 STR. Break: 2 BW. |
| **JACK OF ALL TRADES** | Rare | SCRIPT — EXPLOIT | 2 BW | If you have a WALL, a CODE GATE and a SENTRY Icepick installed: on every ICE, break 1 subroutine for 0 BW using your matching Icepick. Each Icepick still needs enough STR. |

---

## 5. ECHO's pool (9) — "never there"

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **MUFFLE** | Common | SCRIPT — CLOAK | 0 BW | −2 TRACE. |
| **GHOST STEP** | Common | SCRIPT — CLOAK | 1 BW | Draw 2. |
| **PATIENCE** | Common | SCRIPT — CLOAK | 1 BW | +4 SHIELD if you've gained no TRACE this encounter; otherwise +2 SHIELD. |
| **DECOY SIGNAL** | Common | SCRIPT | 1 BW | Until the end of your turn, SENTRY reactive abilities do nothing. |
| **SILENT PARTNER** | Uncommon | PROGRAM — EXTRACTOR | 1 BW, 1 RAM | End of your turn: extract 2 CRED for each CLOAK card you played this turn. |
| **LONG GAME** | Uncommon | PROTOCOL | 1 BW | While your TRACE is under 10, your Extractors extract +2 CRED each. |
| **VANISH** | Uncommon | SCRIPT — CLOAK | 2 BW | During the next Corporation Response, TRACE effects add nothing. BURNED. |
| **SIDE CHANNEL** | Rare | PROGRAM — ICEPICK (any type) | 2 BW, 1 RAM | STR 3. Boost: 2 BW → +1 STR. Break: 2 BW. |
| **BLACKOUT** | Rare | SCRIPT — CLOAK | 3 BW | Skip the next Corporation Response. BURNED. |

**Note:** DECOY SIGNAL is not tagged CLOAK, so playing it doesn't set off the abilities it's meant to stop.

---

## 6. RIOT's pool (9) — "subtle is for people with time"

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **SMASH** | Common | SCRIPT — EXPLOIT | 0 BW, +3 TRACE | Target WALL: −4 STR this encounter. |
| **ROAR** | Common | SCRIPT | 0 BW, +3 TRACE | Draw 2. |
| **CRASH CART** | Common | SCRIPT — CLOAK | 1 BW | −3 TRACE. +2 SHIELD. |
| **PAIN TOLERANCE** | Uncommon | PROTOCOL | 1 BW | Start of your turn: if your TRACE is 20 or more, +2 SHIELD. |
| **BERSERK** | Uncommon | PROTOCOL | 1 BW | While your TRACE is 20 or more, your EXPLOIT SCRIPTS cost 1 less BW (minimum 0). |
| **WRECKING BALL** | Uncommon | PROGRAM — ICEPICK (CODE GATE) | 1 BW, 1 RAM | STR 3. Boost: 1 BW → +1 STR. **Break: 0 BW, +2 TRACE.** |
| **CHAINSAW** | Uncommon | PROGRAM — ICEPICK (SENTRY) | 1 BW, 1 RAM | STR 2. Boost: 1 BW → +1 STR. **Break: 0 BW, +2 TRACE.** |
| **FLASHPOINT** | Rare | SCRIPT — EXPLOIT | 2 BW, +5 TRACE | Break 1 subroutine on every ICE with STR 3 or less. |
| **NO WITNESSES** | Rare | SCRIPT — CLOAK | 1 BW | If your TRACE is 30 or more, set it to 10. BURNED. |

---

## 7. VECTOR's pool (9) — "wait for it to rot"

| Card | Rarity | Type / tags | Cost | Effect |
|---|---|---|---|---|
| **SCRAMBLER** | Common | SCRIPT — VIRUS | 1 BW | INFECT 2 SCRAMBLE. *(Each SCRAMBLE counter: this ICE's PULP subroutines deal 1 less.)* |
| **BLINDFOLD** | Common | SCRIPT — VIRUS | 1 BW | INFECT 2 BLIND. *(Each BLIND counter: this ICE's TRACE subroutines add 1 less.)* |
| **LEECHWARE** | Common | SCRIPT — VIRUS | 1 BW | INFECT 2 LEECH. *(Each LEECH counter: extract 1 CRED at the start of your turn.)* |
| **QUARANTINE** | Common | SCRIPT — CLOAK | 1 BW | +1 SHIELD for each virus counter on target ICE (maximum +6). |
| **WORMHOLE** | Uncommon | SCRIPT — VIRUS | 1 BW | INFECT 1 WORM and 1 ROT. *(Each WORM counter: at the start of your turn, put 1 counter of each strain on this ICE onto the next ICE to its right. Each ROT counter: −1 STR.)* |
| **COCKTAIL** | Uncommon | SCRIPT — VIRUS | 2 BW | INFECT 1 of each strain (ROT, SCRAMBLE, BLIND, LEECH, WORM). |
| **INCUBATOR** | Uncommon | PROTOCOL | 1 BW | Whenever a PURGE removes virus counters from an ICE, INFECT 2 ROT on that ICE afterward. |
| **PANDEMIC** | Rare | SCRIPT — VIRUS | 3 BW | Copy all virus counters on target ICE onto every other ICE. |
| **HOST TAKEOVER** | Rare | SCRIPT — VIRUS, EXPLOIT | 2 BW | Break 2 subroutines on target ICE with 5 or more virus counters. |

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
