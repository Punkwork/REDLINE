# PANOPTICON — HALCYON PLAYTEST 3 (0.3.0-playtest.3)

This development slice covers four Rustlers and HALCYON's first four map rows.
This candidate includes **ZEROED + TUMBLE**; the selection screen says **HALCYON PLAYTEST 3 · ZEROED + TUMBLE**. Record the source commit,
Rustler, Node, turn and cards with feedback.

## Get the Windows build after merge

The designer requested a downloadable ZEROED + TUMBLE candidate before merge.
Open **GitHub → Actions → Godot validation and Windows playtest build**, then the
successful **push** run on `codex/zeroed-tumble-2026-11-16`. Download the Windows
artifact, extract it, and run `PANOPTICON_HALCYON_slice.exe`. Godot is not required.
`BUILD_COMMIT.txt` identifies the exact source revision. This candidate keeps
version `0.3.0-playtest.3`; use the ZEROED + TUMBLE selection label and commit to
distinguish it from older Playtest 3 downloads. The executable is unsigned.

Only the stabilization branch and this specifically requested candidate branch
export Windows on push. Pull-request checks validate code and screenshots.
The candidate remains separate from the stabilization branch until its PR merges.

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
| TUMBLER TUMBLE | Breaking a slotted subroutine removes it for this encounter. Later slots slide back and the next unbroken pool entry wraps into the last slot, active immediately. It is breakable now and fires this turn if left unbroken. Rotation skips removed entries and stops when all survivors fit; spare slots show EMPTY. Partial DEADLOCK ×N breaks stay put until the last step. BOOTING and TRIPWIRE remain. Try CAPTCHA: break DISCARD or its first DEADLOCK and watch the incoming PULP. Icepick, card and WORM breaks all tumble. |
| STR floor / ZEROED | ICE STR bottoms at 0. Excess ordinary reduction is lost; later gains rise from 0. Spare ROT counters remain and keep holding STR at 0. The first drop from positive STR to 0, by any source, consumes that ICE’s one ZEROED for the encounter and shows a ZEROED marker. ICE starting at 0 or protected by a positive STR floor cannot be ZEROED. Only a card printing ZEROED receives a bonus. |
| MARGIN / OVERKILL | Break buttons show effective Icepick STR minus ICE STR after required boosts. SCALPEL's OVERKILL 2 makes its break component free. TOLL and boosts remain additional costs. STACK SMASH counts EXPLOIT plays including itself. Normal reveal, BOOTING and SEQUENCED restrictions remain. |
| RIOT ZEROED cards | FLATLINE: 0 BW, +2 TRACE, −2 target STR; ZEROED −4 TRACE. KNOCKOUT: 1 BW, −3 STR; ZEROED break one visible/active subroutine. SECOND WIND: 0 BW, −1 STR; ZEROED +1 BW. Orange ICE borders identify targets a playable ZEROED card in hand would finish. Rewards label these cards DRILL. Bonuses occur only on the first positive-to-zero transition. |
| NULL POINTER | Replaces INTEGER UNDERFLOW. 2 BW, target ICE at 0 STR, break two subroutines including DEADLOCKs, BURNED. Normal reveal, BOOTING, SEQUENCED and DEADLOCK ×N step limits apply. Invalid positive-STR targets spend nothing. |
| Virus cash-outs | CULL lets you select up to three individual counters, with 2 SHIELD each; Finish stops early. HARVEST removes all target LEECH for 3 CRED each, capped by reserve. WORM continues spending two counters for one break step. |
| COMPILE | At SAFEHOUSE choose COMPILE instead of healing. Select two **different SCRIPT IDs sharing a tag**, first effect then second. They become one permanent card with union tags and both effects; summed BW cost capped at four, plus summed TRACE / CRED costs. Choices resolve in order; targeted halves use the selected ICE. Either half burning burns the combined card. Cannot compile the result again. CLEAN BUILD reduces its BW cost. |
| Lean-deck cards | MINIMALIST gives the first break action each turn free while GHOST. ZERO FOOTPRINT burns for TRACE relief equal to cards below cap, maximum ten. Find these and the other new cards in reward pools; offers are random. |
| Reward needs | Labels above relevant cards show **↯ DRILL**, **▣ HULL**, **◇ COVERAGE** (multiple allowed). One-shot defence alone is not a HULL engine; cards outside those roles have no label. |
| Route and reserves | All current non-opening slice Nodes are Tier 1: one layer each. Their first layer is retained. COOKIE BANNER reserve is 23 (15 ×1.5 rounded up); other retained layers have 15. Extraction pays only actual reserve, without a full-extraction bonus. |

New shared cards: WARM BOOT, ROLLING RESTART, FORCE REBOOT, SHORT LOOP,
PORT SCAN, GARBAGE COLLECT, TAIL CALL, PIVOT, COVER FIRE, KILL CHAIN,
SCALPEL, MINIMALIST, ZERO FOOTPRINT. Rustler additions: HANDOFF (ECHO),
STACK SMASH / NULL POINTER / FLATLINE / KNOCKOUT / SECOND WIND (RIOT), CULL / HARVEST (VECTOR), CLEAN BUILD
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
It renders deck analysis, HOLD, SCAN, CULL/STR floor, reward roles, DECOMPILE,
COMPILE, ZEROED target highlighting/markers, TUMBLE motion and settled slots,
and an explicitly controlled DEADLOCK ×2 / ESCALATE fixture.

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

## VIS-001 — The Friendly Lie encounter candidate

The visual candidate is on `codex/vis-001-friendly-lie`, targeting stabilization. It includes ZEROED/TUMBLE first and keeps the existing gameplay/version. The PNG fixtures are embedded in its PR and stored in `docs/visual/fixtures/vis-001/`. A new Windows release has not been exported from this visual branch.

- Corporate app background and mascot objects sit above the Rustler's paper/toner interface. The black scan tag under each mascot is the rules authority: STR, passive text, subroutine effects, DEADLOCK progress, hidden entries, broken history, viruses and ZEROED. Scroll the encounter area when there are extra rule rows. The white NEXT RESPONSE strip follows the actual upcoming response and scrolls horizontally if needed.
- Cheery faces become wary when something on that ICE is broken or TRACE reaches 20. A next-response PULP hit of 5+ or positive CORTEX makes that ICE lethal; the working threshold is tunable in the main scene inspector. Biggest visible PULP and newly tumbled entries receive red chips. Hidden effects remain `? HIDDEN` until the existing reveal rule permits disclosure. BREACH knocks the mascots out while keeping the scans readable.
- At TRACE 20 the background flickers, panels split at the edges, and a one-time corporate toast appears. Strike 1 shows “We see you.” and the TRACER that Game actually inserted; click to dismiss or wait 2.5 seconds. TRACE in the HUD is the real post-strike value. Strike 2 keeps the hostile background and brings in HOUSE CALL; all corporate mascots become lethal. Rustler controls and rule text keep their style.
- Six full-size paper cards fit the hand; seven or more overlap in a fan. Hover a card to raise it, or use the mouse wheel / left and right arrow keys while browsing the hand. Right-click to inspect. No maximum hand size was added. Corporate TRACER/SPAM look deliberately different from Rustler cards.
- Installed Programs and Protocols appear in the taped RIG/RACK strip above the hand. Drag an installed Icepick onto a visible subroutine to use that particular pick. Hover shows legality/cost; illegal drops spend nothing. Click its name for inspection, use `+STR` for manual boosts, and use its existing unload/CACHE actions as appropriate. Normal click-to-break still selects the cheapest legal Icepick.
- Drag a playable hand card onto the encounter/ICE to play it; targeted cards require a compatible ICE. DOORBELL CAM follows the hovered/dragged card with its pupil. Dragging a CLOAK card shows the current WATCHER TRACE consequence. Its hidden subroutine stays hidden. BW slits fill from the left as BW is spent; numeric BW remains authoritative for bonuses.
- Toggle REDUCED MOTION on selection or in the encounter. It persists across launches and removes ambient bob/blink, shake, flicker, reels and typing. State changes remain readable, and the Corporation Response still takes at least five seconds. VOICE / M and END RUN keep their existing functions.

The turn-3 fixture advances two real Corporation Responses and resolves CAPTCHA's discard choice. Actual TUMBLER rotation means PULP 6 occupies slot 1 and TRACE 3 tumbles into slot 2 after the second DEADLOCK is broken. The mockup's alternative slot arrangement is not forced into gameplay. Preparation cards/budgets and the eight-card hand are deterministic test fixtures, not claims about starting decks or balance.


## CHROME-001 — playable Chrome Deco encounter refinement

This candidate is on `codex/chrome-deco-encounter`, targeting stabilization and including the unmerged VIS-001 dependency. No Windows build was exported for this experiment. The ten PNGs in `docs/visual/fixtures/chrome-001/` are captures of the live Godot encounter, not generated UI mockups. The earlier rejected flat/thin-rim samples have been superseded by refreshed samples.

The CAPTCHA fixture uses actual AUTO-RENEW/CAPTCHA stats and Generalist cards. The atrium and pearl/chrome mascot shells are illustration assets; every face, rule, cost and control remains live. ICE rules now sit on pearl-enamel service plaques with slate lettering, silver edges and restrained teal accents. Hidden and broken chips use pale dashed/struck-through states; rules retain a solid backing against the architecture. Card art is a six-motif prototype atlas, reused by role while preserving authored card text. It does not introduce new cards or effects.

At TRACE 20 the same atrium reveals a partial surveillance view. First strike shows hostile lighting and the existing “We see you.” modal; second strike reveals the cameras, processing rails and restraint stations while the paper interface remains unchanged. All thresholds and TRACER/Black ICE effects still come from Game.

For the interaction sample, drag the installed FORTRESS Icepick onto AUTO-RENEW S1. Legal rows have dashed dark-teal outlines; the hovered target has a solid outline and the separate top-center feedback box shows the exact BW cost and MARGIN. In this fixture the initial break costs 3 BW including boosts. Release to break: the rule is struck through, AUTO-RENEW becomes wary, and the feedback confirms the cost. Dragging that FORTRESS pick onto CAPTCHA instead shows a red outline and “NO TUMBLER ICEPICK”; releasing spends nothing. The small drag cursor avoids putting a duplicate card-length label or native tooltip over rules. Card hover/keyboard browsing raises the card with a lime paper edge. Existing reduced-motion and five-second-response behaviour remain.
