# PANOPTICON — HALCYON PLAYTEST 11 (0.11.0-playtest.11)

This Windows build is the **core-loop test** (STRIP-001): the Generalist only, HALCYON's first four map rows, and only break, defend and build. The selection screen shows **HALCYON PLAYTEST 11 · CORE LOOP · 0.11.0-playtest.11**. New in 11: TRACE riders (TRACE X ▸ effect: the effect happens only if some of that TRACE lands) and the JAMMER card; CONSENT FORM joins TERMS & CONDITIONS and its AMEND makes TERMS OF SERVICE hit harder; DEFRAG discards 1 then draws 2; the parting shot plays on screen with a sound for each subroutine type. From 10: Icepick boosts last only until the end of your turn (PROBE still lasts the encounter); every ICE has 1–2 more subroutines, one with two effects; new effects HARDEN (ICE +STR), SHIELD BREAK and RETALIATE (PULP per broken subroutine); DOORBELL CAM deals CORTEX. From 9: ICE turn WARY below half STR, and LETHAL (PULP and TRACE double, Black ICE excepted) once they are also half broken; TRACE subroutines +2, PULP +1. Core-loop rules: 3 BW a turn; PROBE costs 0 BW, +1 BW for each extra PROBE on the same ICE that turn, and reveals a VOID's face-down subroutine; BURST costs 3 and gives 5 BW, costing 1 more each time that copy is played; when you BREACH, every unbroken showing subroutine fires once as a parting shot; your next hand is drawn before the corporation acts; ICE are +2 STR, with no passives. Fill in `REDLINE_CORE_LOOP_CHECKLIST.md` (one row per encounter).

The rest of this guide describes the full slice.

Playtest 7 rebuilds the encounter screen in the painted concept interface (ENC-CONCEPT-001): ICE cabinets with the new AUTO-RENEW and CAPTCHA characters, icon keys with rules on hover, white card faces in a copper hand tray, the mushroom END TURN button and a KEY LEGEND card. ICE and cards without painted art yet use the older drawings. Playtest 6 added corporate newsreels and hesitation lines, local personalized ads, and a relocation notice followed by THE CARBON. Open the ledger from DEAD DROP in the run menu. The nine island names are working copy. See the repository fixtures for Central Node punch-card arrival, LUCIDA record edits and PATCHWORK grafts.

## Get the Windows build

Open the successful Playtest 7 build on `release` (Actions run and artifact links are in `docs/HANDOFF.md`). Open the latest build on `release`. Download `PANOPTICON-HALCYON-PLAYTEST-11-0.11.0-playtest.11-Windows-x86_64`, extract it, and run `PANOPTICON_HALCYON_slice.exe`. The executable is unsigned and runs without installing Godot.

Include the source revision from `BUILD_COMMIT.txt` in reports. `SHA256SUMS.txt` contains the executable's SHA-256. Use the bundled **Playtest QA Checklist v0.5** (`REDLINE_PLAYTEST_CHECKLIST.md`). Mark checks for unavailable routes, features, or later mechanics **N/A**.

## Changes since Playtest 4

- **Atomic Deco Punk Phase 1.** TRACE and strikes gradually reveal HALCYON's surveillance backdrop. The Rustler HUD has toner wear and code strips, and the corporation uses Poiret One for display headlines. The prototype music mix follows the encounter state. Card actions have mechanical sound cues. Music volume, mute and reduced motion are available.
- **Turn cleanup.** END TURN has no free HOLD prompt. Remaining non-CACHED cards go to discard after the response. The next Rustler turn draws six at base DRAW. Card-granted CACHE still applies.
- **Encounter controls.** Drag a PROGRAM into the gold connector in the left PROGRAM BAY. Hover or click an installed PROGRAM to inspect it. Icepicks can still be dragged to subroutines.
- **SCRIPTs and inspection.** Drag targeted SCRIPTs onto eligible ICE and untargeted SCRIPTs onto the upper half of the encounter. Enter plays the selected card or starts target selection when browsing by keyboard. Right-click a hand card for a centered 150% preview. Right-click the preview or the same card again, or press Escape, to close it.
- **Display.** The backdrop fills the fullscreen window. ICE avatars and faces are 25% larger.
- **Scope.** HALCYON's four-row route is playable. The IRONWATCH and LUCIDA facades are present in the project and their routes remain outside this build.

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
| Hand cleanup | END TURN has no free HOLD prompt. Discard remaining non-CACHED cards after the response, then draw 6 at base DRAW on the next Rustler turn. Card-granted CACHE persists. |
| TUMBLER TUMBLE | Breaking a slotted subroutine removes it for this encounter. Later slots slide back and the next unbroken pool entry wraps into the last slot, active immediately. It is breakable now and fires this turn if left unbroken. Rotation skips removed entries and stops when all survivors fit; spare slots show EMPTY. Partial DEADLOCK ×N breaks stay put until the last step. BOOTING and TRIPWIRE remain. Try CAPTCHA: break DISCARD or its first DEADLOCK and watch the incoming TRACE 2. Icepick, card and WORM breaks all tumble. |
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
  cap−4), DEAD MAN'S POCKET (deferred). Acquisition is deferred. DEDUPLICATOR
  awaits FUSE.

For a developer screen check, run `godot --path godot --script
res://tests/shot_playtest3.gd` with an existing `SHOT_DIR` directory and display.
It renders deck analysis, hand cleanup, SCAN, CULL/STR floor, reward roles, DECOMPILE,
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

The Friendly Lie encounter is included in Playtest 7. The repository stores its PNG fixtures in `docs/visual/fixtures/vis-001/`.

- Corporate app background and mascot objects sit above the Rustler's paper/toner interface. The black scan tag under each mascot is the rules authority: STR, passive text, subroutine effects, DEADLOCK progress, hidden entries, broken history, viruses and ZEROED. Scroll the encounter area when there are extra rule rows. The white NEXT RESPONSE strip follows the actual upcoming response and scrolls horizontally if needed.
- Cheery faces become wary when something on that ICE is broken or TRACE reaches 20. A shown next-response PULP hit of 5+ or positive CORTEX makes that ICE lethal; the working threshold is tunable in the main scene inspector. Biggest visible PULP and newly tumbled entries receive red chips. Hidden effects remain `? HIDDEN` until the existing reveal rule permits disclosure. BREACH knocks the mascots out while keeping the scans readable.
- At TRACE 20 the background flickers, panels split at the edges, and a one-time corporate toast appears. Strike 1 shows “We see you.” and the TRACER that Game actually inserted; click to dismiss or wait 2.5 seconds. TRACE in the HUD is the real post-strike value. Strike 2 keeps the hostile background and brings in HOUSE CALL; all corporate mascots become lethal. Rustler controls and rule text keep their style.
- Six full-size paper cards fit the hand; seven or more overlap in a fan. Hover a card to raise it, or use the mouse wheel / left and right arrow keys while browsing the hand. Right-click to inspect. No maximum hand size was added. Corporate TRACER/SPAM look deliberately different from Rustler cards.
- Installed Programs and Protocols appear in the taped RIG/RACK strip above the hand. Drag an installed Icepick onto a visible subroutine to use that particular pick. Hover shows legality/cost; illegal drops spend nothing. Click its name for inspection, use `+STR` for manual boosts, and use its existing unload/CACHE actions as appropriate. Normal click-to-break still selects the cheapest legal Icepick.
- Drag a playable hand card onto the encounter/ICE to play it; targeted cards require a compatible ICE. DOORBELL CAM follows the hovered/dragged card with its pupil. Dragging a CLOAK card shows the current WATCHER TRACE consequence. DOORBELL CAM is STR 3. Its PULP 4, CORTEX 1 and DEADLOCK reveal in order as each first fires. BW slits fill from the left as BW is spent; numeric BW remains authoritative for bonuses.
- Toggle REDUCED MOTION on selection or in the encounter. It persists across launches and removes ambient bob/blink, shake, flicker, reels and typing. State changes remain readable, and the Corporation Response still takes at least five seconds. VOICE / M and END RUN keep their existing functions.

Fixed-value FORTRESS PULP rolls at the start of the Rustler turn. The printed value swings by −2 through +2, or by ±3 on 30% of rolls, with a minimum rolled value of 1. The same next-response number appears on the ICE and in the response strip and is applied after SCRAMBLE reductions. PULP-002 curves keep their designed patterns. Curve B now shows the next number from its shuffled bag.

The turn-3 fixture advances two real Corporation Responses and resolves CAPTCHA's discard choice. Actual TUMBLER rotation means TRACE 2 occupies slot 1 and TRACE 3 tumbles into slot 2 after the second DEADLOCK is broken. CAPTCHA is wary after the break. VIS-001 turn 3 shows both mascots wary. In CHROME-001 02b, AUTO-RENEW turns lethal from its rolled PULP 6. The CHROME-001 04 Cracking sequence starts from turn 1 and shows both wary until Mask Off, when all mascots turn lethal. Preparation cards/budgets and the eight-card hand are deterministic test fixtures, not claims about starting decks or balance.


## CHROME-001 — playable Chrome Deco encounter refinement

The ten PNGs in `docs/visual/fixtures/chrome-001/` show the live Godot encounter included in Playtest 7.

The CAPTCHA fixture uses actual AUTO-RENEW/CAPTCHA stats and Generalist cards. AUTO-RENEW starts at STR 5 and CAPTCHA at STR 4. CONSENT FORM and REJECT ALL now show PULP 3, and CONSENT FORM has no passive. The atrium and pearl/chrome mascot shells are illustration assets; every face, rule, cost and control remains live. ICE rules now sit on pearl-enamel service plaques with slate lettering, silver edges and restrained teal accents. Hidden and broken chips use pale dashed/struck-through states; rules retain a solid backing against the architecture. Card art is a six-motif prototype atlas, reused by role while preserving authored card text. It does not introduce new cards or effects.

At TRACE 20 the same atrium reveals a partial surveillance view. First strike shows hostile lighting and the existing “We see you.” modal; second strike reveals the cameras, processing rails and restraint stations while the paper interface remains unchanged. All thresholds and TRACER/Black ICE effects still come from Game.

For the interaction sample, drag the installed FORTRESS Icepick onto AUTO-RENEW S1. Legal rows have dashed dark-teal outlines; the hovered target has a solid outline and the separate top-center feedback box shows the exact BW cost and MARGIN. In this fixture the initial break costs 4 BW including boosts. Release to break: the rule is struck through, the feedback confirms the cost, and AUTO-RENEW’s remaining rolls determine whether its mood is wary or lethal. Dragging that FORTRESS pick onto CAPTCHA instead shows a red outline and “NO TUMBLER ICEPICK”; releasing spends nothing. The small drag cursor avoids putting a duplicate card-length label or native tooltip over rules. Card hover/keyboard browsing raises the card with a warm instrument-amber edge. Existing reduced-motion and five-second-response behaviour remain.


## CARDS-001 — vintage slot cartridges

Rustler card types now have distinct physical constructions: SCRIPT instructions in stamped steel/Bakelite with fuse/resistor hardware; PROGRAM devices in cast aluminum with vacuum tubes and metal-can transistors; PROTOCOL relay carriers in celadon enamel with terminal blocks/wiring. Contacts and insertion rails make them read as heavy plug-in cartridges. Live rules print directly on the board faces alongside photocopied collage illustrations.

BW is printed on a raised rating tab at the upper-right chassis edge, largely outside the white label. Common cards have a plain single-notch finish; uncommon cards add two indexing notches and a small brass fitting; rares use three notches and fine double-metal detail. Full rarity labels remain visible, so color alone is not required. STARTER stays STARTER; rarity/reward odds and costs are unchanged. The new frames are used in the hand, READY RIG choices, reward offers and inspection. Protruding parts are included in hit-testing and choice-scroll padding. The shallower hand fan makes room for the hardware without a hand-size cap.

Card titles now print directly on each light face instead of a black strip: ivory instruction stock (SCRIPT), cool pearl instrument plate (PROGRAM), pale celadon enamel (PROTOCOL). The frames, external BW tabs and rarity details are unchanged.

The selected board palette supersedes the pale label studies: SCRIPT uses A-family tobacco/khaki brown, PROGRAM C-family earthy olive, PROTOCOL D-family muted blue-green. BLOATWARE now uses the Whirlwind reference's handle/paired tubes/cage/plug-in board construction, with a distinct oxide-red phenolic face selected by the designer (“Perfect”). All text prints directly on board material; no card has a white text panel. Bloatware's authored type, unplayability and clear/TRACE rules are unchanged.
