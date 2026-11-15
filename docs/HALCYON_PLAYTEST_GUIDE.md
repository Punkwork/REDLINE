# PANOPTICON — HALCYON PLAYTEST 3 (0.3.0-playtest.3)

This development slice covers four Rustlers and HALCYON's first four map rows.
The selection screen must say **HALCYON PLAYTEST 3**. Record the source commit,
Rustler, Node, turn and cards with feedback.

## Get the Windows build after merge

After the playtest-3 PR is merged into `codex/halcyon-playtest-stabilization`, open
**GitHub → Actions → Godot validation and Windows playtest build**, then its
successful **push** run on that branch. Download
**PANOPTICON-HALCYON-PLAYTEST-3-0.3.0-playtest.3-Windows-x86_64** from Artifacts
(sign-in may be required). Extract it and run `PANOPTICON_HALCYON_slice.exe`.
The resources are embedded; Godot is not required. Keep the included checklist.
The executable is unsigned. Windows launch verification remains a manual check.

Feature-branch and PR runs validate rules and screenshots; **they do not export
Windows**. The post-merge run exports version `0.3.0-playtest.3` using Godot 4.3
and matching templates, includes this guide, and writes SHA256SUMS.txt.

## What to try

| Mechanic | Rule and where to see it |
|---|---|
| REJECT ALL | One DEADLOCK, two slots in a three-entry pool. BOOTING still locks it until turn 3. Enter COOKIE BANNER and watch the reel. |
| FOOTPRINT | Permanent cards excluding Bloatware. Bottom-right HUD shows count / corporation cap and band. HALCYON cap 22; GHOST ≤16, LEAN 17–22, HEAVY >22. Later caps are 29 / 35. |
| Bloat tax | At entry to each ICE Node, gain 1 TRACE per card above cap. The log reports it; TRACE-reduction abilities apply normally. The short starter decks may never reach the cap in this slice. |
| Optional GHOST draw | Selection-screen option, OFF by default. When enabled, GHOST decks draw one extra card on each encounter's first turn. |
| Deck analysis | Click **DECK / COVERAGE**. See duplicate-aware key-card draw estimates, tag density, and FORTRESS / TUMBLER / VOID coverage. Estimates use nominal encounter length, not a promise about the next shuffle. |
| Rewards and DECOMPILE | A full-clear reward offers three cards, DECOMPILE, or skip. DECOMPILE removes a permanent card instead; disabled choices explain the 10-card floor or loss of the last type answer. Reward tooltips show projected draw estimates. |
| REBOOT | Drawing from empty draw with nonempty discard reshuffles it. The current draw finishes before triggers resolve. HUD estimates turns until REBOOT and shows AMP. FORCE REBOOT explicitly shuffles discard into draw and burns. |
| AMP | Lasts for this Node. Adds to per-turn output and strain effects: ROT / SCRAMBLE / BLIND / LEECH gain AMP once per active strain, not per counter. Also increases WARM BOOT and SHORT LOOP outputs. ROLLING RESTART adds one AMP per REBOOT. |
| SCAN | Play PORT SCAN. Its choice shows up to three top cards. Click cards to send to the bottom in click order; click again to undo. Finish SCAN, then draw one. Unselected cards retain order. |
| BURN | GARBAGE COLLECT chooses another hand card to burn, then draws one. Burned cards return next Node; the permanent deck is not pruned. TAIL CALL retrieves a chosen SCRIPT from discard. |
| CHAIN | HUD shows last card's tags. PIVOT follows CLOAK for −3 rather than −2 STR; COVER FIRE follows EXPLOIT for 5 rather than 3 SHIELD. HANDOFF follows CLOAK to draw one. KILL CHAIN draws once per bonus, at most twice per turn per copy. Playing Programs / Protocols changes the last card; Icepick actions do not. Resets each turn. |
| HOLD 1 | END TURN opens an optional hand-card choice before end-turn effects. Pick one to CACHE or skip. It stays through cleanup until played or Node end. DEAD AIR and SMASH & GRAB still supply additional CACHE. Training disables HOLD. |
| UNDERFLOW | ICE STR may be negative; the number turns red. Existing explicit floors still prevail, HARDENING and RELAY add normally, LOGIC BOMB sets exactly zero. |
| MARGIN / OVERKILL | Break buttons show effective Icepick STR minus ICE STR after required boosts. SCALPEL's OVERKILL 2 makes its break component free. TOLL and boosts remain additional costs. STACK SMASH counts EXPLOIT plays including itself. INTEGER UNDERFLOW burns to break up to three steps according to negative STR; normal reveal, BOOTING and SEQUENCED restrictions remain. |
| Virus cash-outs | CULL lets you select up to three individual counters, with 2 SHIELD each; Finish stops early. HARVEST removes all target LEECH for 3 CRED each, capped by reserve. WORM continues spending two counters for one break step. |
| COMPILE | At SAFEHOUSE choose COMPILE instead of healing. Select two **different SCRIPT IDs sharing a tag**, first effect then second. They become one permanent card with union tags and both effects; summed BW cost capped at four, plus summed TRACE / CRED costs. Choices resolve in order; targeted halves use the selected ICE. Either half burning burns the combined card. Cannot compile the result again. CLEAN BUILD reduces its BW cost. |
| Lean-deck cards | MINIMALIST gives the first break action each turn free while GHOST. ZERO FOOTPRINT burns for TRACE relief equal to cards below cap, maximum ten. Find these and the other new cards in reward pools; offers are random. |
| Reward needs | Labels above relevant cards show **↯ DRILL**, **▣ HULL**, **◇ COVERAGE** (multiple allowed). One-shot defence alone is not a HULL engine; cards outside those roles have no label. |
| Route and reserves | All current non-opening slice Nodes are Tier 1: one layer each. Their first layer is retained. COOKIE BANNER reserve is 23 (15 ×1.5 rounded up); other retained layers have 15. Extraction pays only actual reserve, without a full-extraction bonus. |

New shared cards: WARM BOOT, ROLLING RESTART, FORCE REBOOT, SHORT LOOP,
PORT SCAN, GARBAGE COLLECT, TAIL CALL, PIVOT, COVER FIRE, KILL CHAIN,
SCALPEL, MINIMALIST, ZERO FOOTPRINT. Rustler additions: HANDOFF (ECHO),
STACK SMASH / INTEGER UNDERFLOW (RIOT), CULL / HARVEST (VECTOR), CLEAN BUILD
(GENERALIST).

## Implemented hooks, outside the natural route

These are verified in rules tests and controlled UI fixtures, with no invented
acquisition flow or changed ICE numbers:

- **DEADLOCK ×N:** one break removes one step; partial progress appears as `1/2`.
  Card breaks and WORM follow the same rule. No existing roster entry was assigned
  an unspecified multiplier.
- **ESCALATE ↑:** TRACE, DISCARD and FORGET increase by one after each actual
  resolution; the chip shows its next value. Broken/skipped effects do not grow.
  No existing ICE was assigned an unspecified ESCALATE effect.
- **Tier 2 odds:** one layer 45/40/15; two layers 30/45/25. Tier 1 uses 60/30/10.
  The production slice has no Tier 2 Nodes.
- **FREE TRIAL:** HALCYON Tier 2 data and REBOOT → INSERT SPAM trigger; its
  placement is deferred with Tier 2. PATTERN ANALYSIS (IRONWATCH CHAIN → PULP 1)
  and RECURRING DREAM (LUCIDA REBOOT → FORGET 1) likewise await their routes.
- **Ghostware effect hooks:** HEARTBEAT (REBOOT −2 TRACE), MINIMAL INSTALL
  (GHOST Node starts with +1 AMP), ONE-TRICK (+1 BW/turn, no reward growth at
  cap−4), DEAD MAN'S POCKET (HOLD 2). Acquisition is deferred. DEDUPLICATOR
  awaits FUSE.

For a developer screen check, run `godot --path godot --script
res://tests/shot_playtest3.gd` with an existing `SHOT_DIR` directory and display.
It renders deck analysis, HOLD, SCAN, CULL/UNDERFLOW, reward roles, DECOMPILE,
COMPILE, and an explicitly controlled DEADLOCK ×2 / ESCALATE fixture.

## Existing mechanics and scope

BASIC EXTRACTOR remains 3 CRED/turn. BORROWED CREDENTIALS remains 1 BW + 8 CRED,
selecting a FORTRESS or VOID for HUSH this turn. SMASH & GRAB's paid uninstall
still CACHES another hand card until the end of the next Rustler turn; ordinary
free unload does not. Early exits in any future multilayer Node give no card or
DECOMPILE reward. The separate Clean Node CRED reward remains.

Choose VECTOR's PATIENT ZERO target before playing cards. Scroll large hands;
all cards and the END TURN button should remain accessible. Try all four Rustlers
and record unclear choices, incorrect costs, crashes, turns per encounter and
VITAE loss before proposing balance changes.

Uplink/REFACTOR (50 CRED once per visit), PATCHWORK/FUSE, CAPS, other corporation
routes, Central Nodes, escape, Ghostware acquisition and the Phase 7 pool redesign
remain outside this slice. Conditional turn-4 BOOTING and PACE-006 safety valves
were not implemented. Mark applicable full-game checklist items **N/A — outside
this slice**. Bot results measure this simple policy, including reported stalls;
they do not establish human balance or full-run deck-size targets.
