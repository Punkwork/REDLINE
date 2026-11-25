> **History (DEV-001, 2026-11-25).** This is the designer-approved Core Loop spec v0.2 (2026-11-22) as kept in the Claude Project "Panopticon", copied here unchanged below the line so its text isn't lost when the Project copies were retired. The current version is [`docs/REDLINE_CORE_LOOP.md`](../REDLINE_CORE_LOOP.md), which wins where they differ (it adds FORM-001/002, BOOST-001, SUB-001, RIDER-001 and later changes). Not a rules authority.

---

# PANOPTICON — CORE LOOP (stripped test build)
**Version:** 0.2 · **Date:** 2026-11-22
**Status:** **APPROVED 2026-11-21** by the designer in chat: decisions BW-001, PROBE-001, PROBE-003, BREACH-001, TURN-001, BURST-001, STR-001, CACHE-001 and STRIP-001. **PROBE-004** requested by the designer 2026-11-22. The ICE values in §3 and the card-pool rules in §4 are Claude's working values for this test (designer asked for "the first encounter to focus on PULP, not TRACE").

**Why:** in Playtest 7 the core turn had no tension. You lowered STR, installed the Icepick, broke the DEADLOCK and ended your turn, often with BW left over. Too many systems sat on top of a core that isn't fun yet. This build strips the game to **break, defend, build** and tests only that.

> Where this conflicts with other docs, **this doc wins for the stripped build only**. The full-game docs stay as they are until the core loop passes a playtest.

---

## 1. Decisions

| ID | Decision |
|---|---|
| **BW-001** | BW refills to **3** each turn (was 4). DRAW stays **6**. |
| **PROBE-001** | PROBE costs **0 BW** (−2 STR to target ICE for the encounter). |
| **PROBE-003** | Each PROBE played on the **same ICE in the same turn** costs 1 BW more than the last: 0, then 1, then 2… Counts every PROBE copy; resets each turn; PROBE only (DEEP PROBE and other STR cards keep their cost). The cost shows **when the card is dragged over an ICE**; in hand it shows the cheapest. The starter keeps **3 PROBEs** (PROBE-002's cut to 2 was reversed). Flavour: *"The deeper you probe, the costlier it gets."* |
| **PROBE-004** | PROBE becomes a **choose-one** card. **PROBE** · SCRIPT — EXPLOIT · **0 BW** (PROBE-003 escalation) · *Choose one: • Target ICE: −2 STR this encounter. • Target VOID: reveal all its face-down subroutines.* **Costs unchanged:** both modes use the same PROBE-003 count (0, 1, 2… per ICE per turn, whichever mode was played). The −2 STR mode **no longer reveals** anything on a VOID; revealing is now the other mode. Revealing a VOID with nothing face-down is not allowed (the mode is greyed out). The mode is chosen **when the card is dropped on the ICE** (two-option pop-up on a VOID; on a FORTRESS or TUMBLER only −2 STR applies, so there's no pop-up). Replaces the old "PROBE reveals the top face-down one" rider in §2. |
| **BREACH-001** | **Parting shot:** when the encounter is BREACHED, at END TURN every unbroken subroutine that is **active** (in a TUMBLER slot, or on a FORTRESS) or **revealed** (VOID) fires once, left to right, top to bottom. Then the encounter ends. It doesn't count as a Corporation Response (TUMBLERs don't rotate, VOIDs reveal nothing new). |
| **TURN-001** | End of your turn: end-of-turn effects → **discard every non-CACHED card → draw your next hand (6)** → Corporation Response → your next turn (BW refill, SHIELD expires, TUMBLERs rotate, start-of-turn effects). A DISCARD from ICE applies to the hand you already hold, and resolves at once. Replaces HAND-CLEANUP-001's order and FIX-001's delay. |
| **BURST-001** | **BURST** · Uncommon · SCRIPT · **3 BW** · *Gain 5 BW. Each time you play this card this encounter, this card costs 1 more BW for the rest of the encounter.* Each copy keeps its own count; it resets each encounter; the card shows its current cost. No BURNED. No cap on BW. |
| **STR-001** | ICE STR **+2** across the board (values in §3). Fallback STR limits +2 (BRUTE FORCE 6 or less, FLASHPOINT 5 or less, ZOMBIE unchanged in rule). Starter Icepicks are all **STR 2, boost 1 BW → +1 STR**. DEEP PROBE becomes **−5 STR** so it stays worth taking. |
| **CACHE-001** | Every CACHE effect states a duration, shown in a card corner: **∞** = until the encounter ends (lost between layers), or a **number** = that many turns (1 = until the end of your next turn). |
| **STRIP-001** | The stripped core-loop build (§2). |

## 2. The stripped build (STRIP-001)

**In:** 3 BW, DRAW 6, TURN-001; Icepicks, boosts, breaks, DEADLOCK, BREACH with parting shot; PROBE (0 BW, PROBE-003, choose-one by PROBE-004); PULP and SHIELD at **fixed** values; TRACE with the three strikes (Tracer, HOUSE CALL, LOCKDOWN); SPAM Bloatware; a card reward after each Node; card removal at the SAFEHOUSE (in place of PATCHWORK); CACHE with durations; BURST. **Generalist only**, with READY RIG. All presentation (art, mascots, pixel steps, bleed, NUL/REM) stays.

**Simplified ICE types:**
- **FORTRESS:** everything visible, fires every turn.
- **TUMBLER:** rotation stays, **no waiting floor**: a DEADLOCK never starts more than one rotation (or one break, by TUMBLE-001) from a slot. No BOOTING.
- **VOID:** subroutines start face-down. A face-down subroutine is revealed when it fires **or when you play a PROBE on that ICE in its reveal mode** (PROBE-004: reveals **all** its face-down subroutines). Revealed subroutines can be broken at once.

**Out until the core passes a playtest** (switch off with a build flag; don't delete code): FOOTPRINT, caps and the bloat tax; REBOOT and AMP; CHAIN; ZEROED, MARGIN, OVERKILL; PULP curves and FORTRESS rolls; all ICE passives (TOLL, SEQUENCED, HARDENING, RELAY, TRIPWIRE, WATCHER, DETAINER, BOOTING); ESCALATE; DEADLOCK ×N; viruses and PURGE; ECHO, RIOT, VECTOR; DECOMPILE, COMPILE, PATCHWORK; HOLD; Ghostware other than READY RIG.

**Kept as inert cards:** the Basic Extractor (CRED is still counted but has nothing to buy) and CORTEX BUFFER (no ICE deals CORTEX in this build). Both stay in the starter so the deck is unchanged; they get no reward-pool copies.

**Generalist starter (12):** FORTRESS, TUMBLER and VOID Icepicks (all STR 2, boost 1 BW → +1, break 1 BW; FORTRESS keeps its free first break each turn), Basic Extractor, CORTEX BUFFER, 3 PULP Shield (1 BW, +3 SHIELD), 3 PROBE, GHOST SIGNAL.

## 3. Stripped HALCYON slice ICE (working values)

How they were made: start from ICE Corp 1 §5.0 with the ICE Rules Bible audit applied, **+2 STR**, passives removed, curves fixed at their average, and threat cut by about **a third** (because 3 BW leaves less for defence and +2 STR means more responses). CORTEX is removed. Route unchanged.

| Node | ICE | Type | STR | Subroutines |
|---|---|---|---|---|
| **COOKIE BANNER** (opening) | ACCEPT ALL *(support)* | TUMBLER | 6 | 1 slot of 3: PULP 2 · PULP 1 · PULP 2 |
| | REJECT ALL *(main)* | TUMBLER | 6 | 1 slot of 3: PULP 2 · DEADLOCK · PULP 2 |
| **CAPTCHA** | AUTO-RENEW | FORTRESS | 7 | PULP 1 · PULP 1 · PULP 2 · DEADLOCK |
| | CAPTCHA | TUMBLER | 6 | 2 slots of 5: DISCARD 1 · DEADLOCK · TRACE 2 · DEADLOCK · TRACE 2 |
| **CONSENT WALL** | COOKIE WALL (layer 1) | FORTRESS | 7 | PULP 1 · TRACE 1 · PULP 2 · DEADLOCK |
| | CONSENT FORM (layer 2) | TUMBLER | 6 | 2 slots of 4: TRACE 1 · DEADLOCK · PULP 2 · DEADLOCK |
| **DOORBELL** | DOORBELL CAM (layer 1) | VOID | 5 | PULP 3 · DEADLOCK (face-down) |
| | CONSENT FORM + TERMS OF SERVICE (layer 2) | TUMBLER / FORTRESS | 6 / 9 | as above / PULP 3 · INSERT 1 SPAM → discard · PULP 3 · DEADLOCK |
| **TERMS & CONDITIONS** | TERMS OF SERVICE, then CAPTCHA + DOORBELL CAM | — | as above | as above |
| Black ICE | HOUSE CALL | VOID | 9 | PULP 4 · PULP 4 (face-down) |

**COOKIE BANNER is about PULP, not TRACE** (designer). It teaches that PULP has to be answered: about 3 PULP per response from turn 1. Its guard sits in front of the DEADLOCK: break REJECT ALL's first PULP 2 and the DEADLOCK tumbles into the slot at once. If you rush, parting shot makes you take whatever's still showing.

**Starting check (Generalist, COOKIE BANNER, TUMBLER Icepick via READY RIG):** STR 6 vs 2. With one PROBE, that's a 2 BW boost and a 1 BW break: a full turn for one subroutine. With two PROBEs, it's 1 BW for the second PROBE, 0 BW of boost, then 1 BW per break: you can break the guard and the DEADLOCK in one turn. With none, it takes two turns to build up. Target: BREACH on turn 3–4, about 2–4 VITAE lost.

**DOORBELL CAM check (PROBE-004):** STR 5 vs a VOID Icepick at 2. The first PROBE (0 BW) now forces a choice: reveal both subroutines (so the DEADLOCK can be broken this turn) **or** take −2 STR. Doing both costs the second PROBE at 1 BW, then 1 BW boost and 1 BW break: the whole turn's 3 BW for the DEADLOCK alone. Skipping the reveal means waiting for a face-down subroutine to fire before it can be broken. This is the intended tension; the bot sims should confirm DOORBELL CAM still lands at 4–5 turns.

## 4. Card pool for rewards

Shared pool + Generalist pool, **excluding** every card whose text uses a switched-off system: CHAIN, AMP, REBOOT, ZEROED, OVERKILL/MARGIN, virus strains, CORTEX (FAILSAFE), CRED spending or extraction (DATA SIPHON, SKIMMER, PAYDAY), Ghostware hooks, HOLD; plus deprecated cards (LOGIC BOMB, RELAY). Claude Code lists the resulting pool in the log. Keep at least: BATTERING RAM, JACKHAMMER, PASSKEY, RAINBOW TABLE, TASER, STUN BATON, SKELETON KEY, MULTITOOL, ADAPTER, DEEP PROBE (−5), STRESS TEST, KEYLOGGER, BALANCED LOAD, HARDENED SHELL, FLINCH, MIRROR, SURGE PROTECTOR, SCRUB, PROXY CHAIN, BURN NOTICE, SPAM FILTER, UNINSTALLER, PATCH KIT, DEFRAG, STASH, STIM PATCH, BURST, CO-PROCESSOR, RAM UPGRADE, QUANTUM CORE, FIELD KIT, TOOLBELT, HOT SWAP, READY STANCE, JACK OF ALL TRADES. Reward Icepicks: STR −0 (their printed STR stays; the starter ones were raised to 2).

## 5. Bot sim checks (before the build goes to the designer)

Run 30 Generalist runs and report per encounter: **turns**, **VITAE lost**, **unspent BW per turn**, **cards left unplayed per turn**, **threat subroutines broken before BREACH**, and **parting-shot damage**. Report unspent BW and unplayed cards **with and without** the inert Basic Extractor and CORTEX BUFFER. Targets: early encounters 4–5 turns (COOKIE BANNER 3–4), 2–4 VITAE lost, unspent BW near 0 most turns, and threat breaks happening in most encounters. If VITAE runs high, cut PULP before touching STR. Also note how far BW goes in a deck with several BURSTs. **PROBE-004:** on VOID encounters (DOORBELL CAM, HOUSE CALL) report how often the bot picks each PROBE mode; the bot should choose reveal when a face-down subroutine is likely the DEADLOCK and −2 STR otherwise.

## 6. Playtest sheet (Playtest 8, core loop)

One row per encounter. Keep it quick.

| Run | Node / layer | Turns | VITAE lost | TRACE gained | Spare BW most turns? (Y/N) | Broke a threat before the DEADLOCK? (Y/N) | Took a parting shot? (how much) | One-line note |
|---|---|---|---|---|---|---|---|---|
| 1 | COOKIE BANNER | | | | | | | |
| 1 | | | | | | | | |

**After each run (answer 1–5, 5 = yes, strongly):**
1. Most turns I had more good plays than BW.
2. Choosing what to break (threat or DEADLOCK) was a real decision.
3. PROBE felt worth a card, and the rising cost made me think.
4. BURST created a big-turn decision.
5. PULP mattered and I had to defend.
6. Card rewards made my deck noticeably better.
7. I wanted to play another run.
8. On a VOID, choosing between PROBE's reveal and −2 STR was a real decision.

**Bugs found:** one line each, with the screen and what you did.

## 7. Prompt for Claude Code

> Pull `main`. Read `docs/HANDOFF.md`, then this spec (copy it to `docs/REDLINE_CORE_LOOP.md`). Build the stripped core-loop playtest (STRIP-001) behind a build flag, with the decisions in §1 and the ICE in §3. Do not refactor beyond what this needs. Update the rules tests for the new values, run the bot sims in §5 and log the results. Add HANDOFF rows, record the decisions in `REDLINE_MASTER_DESIGN.md`, add a dated log entry, and tell me the commit. Then cut `playtest-8` from `release` per RELEASE-001, bundling §6 as the checklist.

> **PROBE-004 delta (if the build already exists):** make PROBE a choose-one card per §1 PROBE-004. Remove the automatic reveal from the −2 STR mode; add the reveal-all mode on VOID (greyed out if nothing is face-down); show a two-option pop-up only when dropped on a VOID; both modes share the PROBE-003 cost counter. Update the card text, rules tests (cost counter across modes, no reveal from −2 STR, reveal-all), the bot's mode choice, and add question 8 to the playtest checklist.
