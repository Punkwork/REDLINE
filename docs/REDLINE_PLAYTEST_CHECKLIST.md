# PANOPTICON — Playtest QA checklist
**Version:** 0.7 · **Date:** 2026-11-21 · **For build:** HALCYON PLAYTEST 7, `0.7.0-playtest.7` (`5bb7d71`; tag `playtest-7` pending)

Build source `5bb7d71`. [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/44719708503) · [Windows artifact](https://github.com/Punkwork/REDLINE/actions/runs/44719708503/artifacts/14620644840) · Fill-in workbook for results: `docs/PANOPTICON_Playtest7_Checklist.xlsx` (upload it back to Claude).

Use one copy per playtest run. The live, fill-in version is the **REDLINE Playtest QA Checklist** Sheet ([link](https://claude.ai/artifact/1ARG6jjW9cp34EGq23drFk)) (a column per run, with OK / Issue / Fail / N/A, plus a Run log tab). This file is the reference copy that lives with the design docs.

**For every run:** choose a Rustler and play the available HALCYON route. Record the route, cards, CRED and result manually. Mark summary export and whole-heist checks N/A for this slice.

Targets come from the approved design: Opening Node (OPEN-001), card rewards (CORE-010), economy (UPL-008), map (MAP-002), starter cards (BASIC-001) and run length (Core Rules §10.5). **v0.1.1:** G1 and G5 use the deck-size targets set by the designer on 2026-11-15 (30–35 cards by the end of LUCIDA; stage targets from `REDLINE_DECK_SYNERGY.md` DSY-006). **v0.2:** pacing (PACE-001) and deck-synergy (DSY) checks added, approved 2026-11-15. Checks marked *(after DSY-xxx)* apply once that mechanic is in the build; mark them N/A until then. **v0.3 (2026-11-17):** checks for the designer decisions of 2026-11-17: rolled FORTRESS PULP and visible next values (PULP-001), TUMBLE-001, the HALCYON ICE audit (ICE-AUDIT-001), SHATTER (RIOT-003), card readability (READ-001), the encounter visuals (VIS-001 / CHROME-001 / CARDS-001) and the LOGIC BOMB / RELAY removal (DEPRECATE-001). Checks marked *(after X)* apply once X is in the build. **v0.4 (2026-11-17):** for HALCYON PLAYTEST 4. The v0.3 checks are all in this build, so their *(after …)* marks are removed; A3 (confirm the build) and L9 (Icepick drag feedback) added; the Run log gains a Build column. **v0.7 (2026-11-21):** for HALCYON PLAYTEST 7, the ENC-CONCEPT-001 encounter. A3 updated; new section *Playtest 7 encounter* (PT7-1 to PT7-10); C2, L5, L8 and L10 reworded for the new screen. MOOD-PIXEL-001, HOVER-001, the CAPS rack and the rebuilt program screen came after this build, so they aren't checked here. **Scope of this build:** HALCYON's first four map rows only. Mark IRONWATCH and LUCIDA checks, the Central Node (H3, J1, J2) and whole-corporation totals (G5, I2, K2) **N/A**.


## Setup

| ID | Check | Target / what good looks like | Result | Notes |
|---|---|---|---|---|
| A1 | Log the run on the Run log tab (corporation, Rustler, result, minutes). | Every run logged | | |
| A2 | Record the available run details manually. | Rustler, Node, result and relevant cards logged | | |
| A3 | Confirm the build: the selection screen shows HALCYON PLAYTEST 7 · ATOMIC DECO PUNK · 0.7.0-playtest.7. Copy `BUILD_COMMIT.txt` into the Run log. Mark out-of-scope checks N/A (see above). | Source revision from `BUILD_COMMIT.txt` | | |

## Playtest 7 encounter

| ID | Check | Target / what good looks like | Result | Notes |
|---|---|---|---|---|
| PT7-1 | Top bar: PANOPTICON plate, network/Node plate, CONDITION pill, HOSTILE REVEAL %, TURN / TRACE / RESERVE tiles and strike lamps (ENC-CONCEPT-001). | You could find every number you needed without hunting | | |
| PT7-2 | ICE cabinets: AUTO-RENEW and CAPTCHA show their painted characters and change mood (cheery / wary / lethal); other ICE use the older drawings, scaled into the cabinet. | Painted ICE read clearly; mood matches the threat | | |
| PT7-3 | Icon keys: each subroutine shows an icon and value; hover or focus shows the full rule; the KEY LEGEND card explains the icons (ICE-ANALOG-001). | You could read every subroutine; note any icon you had to look up twice | | |
| PT7-4 | Each ICE has its own NEXT RESPONSE plate, replacing the shared response strip. | You could predict what each ICE would do next | | |
| PT7-5 | White concept card faces: name, BW cost and corner icons on the face, rules on hover only. Cards without a painted picture show a tinted stencil. | You could play without hovering every card; note cards you kept hovering | | |
| PT7-6 | Hand: smaller cards in the copper tray; overlap and fan grow with the card count; a draw at 10 cards stops and leaves the card on the draw pile (CARDS-004 fan, HAND-MAX-001). | Readable at 6–10 cards; no card lost at 10 | | |
| PT7-7 | CONFIRM: hand cards at 0.72× are big enough, and the homes for strikes, reserve, CRED/RAM, deck, discard, END RUN and the NUL/REM note work. | Yes, or note what to move | | |
| PT7-8 | Mushroom END TURN button, deck/discard wells and tray buttons. | Always clear what each does | | |
| PT7-9 | Installed programs in the CRT. Known issue: the controls in this build are tiny (rebuilt after Playtest 7). Note anything else. | Record what got in your way | | |
| PT7-10 | CONFIRM: TRACE pixel steps (sharp below 20; 2 px at 20, 3 px at 30, 4 px on a strike, 5 px at Mask off) and the short glitch on each change; instant with reduced motion (PIXEL-TRACE-001/001a). Text, keys and cards stay sharp. | Steps and timing feel right, or note values | | |

## Playtest 6 presentation

| ID | Check | Target / what good looks like | Result | Notes |
|---|---|---|---|---|
| PT6-1 | Review a newsreel and hover a card for four seconds. | Corporate copy appears in its own space. Hesitation never covers rules or controls. | | |
| PT6-2 | End a run, read the relocation notice, then reopen THE CARBON at DEAD DROP after restarting. | One loss persists locally. The nine island names are working copy. Settings can clear the ledger. | | |
| PT6-3 | Disable Ads that know you and return to the run menu. | Personalized ads are absent. | | |

Mark playable Central Node punch cards, LUCIDA record edits, PATCHWORK grafts and run resume N/A in this slice. Review their applicable screenshots separately.


## Opening Node

| ID | Check | Target / what good looks like | Result | Notes |
|---|---|---|---|---|
| B1 | Turn you BREACHED the Opening Node. | 4–5 turns; never under 3 (PACE-001; under 4 triggers PACE-003's BOOTING change) | | |
| B2 | Turns 1–2 had a real decision: extract, defend, break the support ICE, or CACHE. | Yes, and you weren't just waiting | | |
| B3 | BOOTING was clear on screen: you knew why the DEADLOCK couldn't be broken yet. | Understood without reading the log | | |
| B4 | The corporation's lesson landed (HALCYON: only DEADLOCKs block BREACH; IRONWATCH: SHIELD expires each turn; LUCIDA: FORGET and CACHE). | You could say the lesson afterwards | | |

## Encounters

| ID | Check | Target / what good looks like | Result | Notes |
|---|---|---|---|---|
| C1 | Typical encounter length. | Early 4–5 · mid–late 5–8 (PACE-001) | | |
| C2 | The Corporation Response order (left to right, top to bottom) was readable in the log and on each ICE's NEXT RESPONSE plate. | You could predict the next response | | |
| C3 | The break cost on each subroutine button matched what you actually paid. | Always matched | | |
| C4 | Reactive ICE abilities (WATCHDOG, PATROL DRONE, K9 UNIT…) were noticed before they hurt. | No surprises after the first time | | |
| C5 | Go deeper or leave felt like a real choice. Note how often you left early. | Both choices taken sometimes | | |
| C6 | In multi-ICE layers, choosing which ICE to break first mattered. | Yes | | |
| C7 | Off-type ICE (no matching Icepick) felt hard but not hopeless; the fallback card was reachable. | Hard, never stuck | | |
| C8 | Any ICE that felt unfair, trivial or confusing (name it in Notes). | None | | |
| C9 | VITAE lost per encounter (note each). | Early 2–3 · mid–late 3–4 for an on-curve deck (PACE-004) | | |
| C10 | You broke a threat subroutine instead of rushing the DEADLOCKs, and it was worth it. | Most encounters past the Opening Node | | |
| C11 | Rising threat (PULP curves, HARDENING, ESCALATE ↑) was noticed and planned around. | Yes | | |
| C12 | Rolled FORTRESS PULP: the number shown on the ICE and in the response strip at the start of your turn was the number dealt, after SCRAMBLE and other reductions (PULP-001). | Always matched; no surprise | | |
| C13 | Rolled PULP felt plannable: you saw a big swing (±3) a turn ahead and planned SHIELD or a break around it (PULP-001). | Yes; name any roll that felt unfair | | |
| C14 | Every PULP curve showed its next value; COOKIE WALL showed a number, never "PULP ?" (PULP-001). | Always | | |
| C15 | Breaking a TUMBLER subroutine removed it at once and the next unbroken one tumbled in; a broken DEADLOCK never reappeared (TUMBLE-001). | Always | | |
| C16 | HALCYON after the audit: DOORBELL CAM felt deadly (PULP 4, CORTEX 1, DEADLOCK, each revealed as it first fires), CAPTCHA felt like a puzzle rather than a damage spike, and AUTO-RENEW (STR 5) was the stronger ICE beside CAPTCHA (STR 4) (ICE-AUDIT-001). | Yes | | |

## Rustler

| ID | Check | Target / what good looks like | Result | Notes |
|---|---|---|---|---|
| D1 | The Rustler's playstyle came through (Generalist balanced, ECHO quiet, RIOT loud, VECTOR viruses). | Clearly | | |
| D2 | The ORIGIN Ghostware mattered in most encounters. | Yes | | |
| D3 | Starter cards were being replaced (BASIC-001): by the Central Node you drew mostly earned cards. | Few starter cards drawn late | | |
| D4 | RIOT: SHATTER let SLEDGE break the chosen ICE whatever its type, and SLEDGE then stayed at STR 0 for the rest of the encounter (RIOT-003). | As described | | |

## Damage & risk

| ID | Check | Target / what good looks like | Result | Notes |
|---|---|---|---|---|
| E1 | VITAE left at the Central Node. | 30–60% in a winning run | | |
| E2 | TRACE strikes this corporation. | 0–1 (RIOT 1–2) | | |
| E3 | CORTEX at the end of the corporation, and whether it felt scary but fair. | 0–2, fair | | |
| E4 | FORGET (LUCIDA) was annoying but fair, and CACHE felt useful against it. | Yes | | |
| E5 | Clearing Bloatware (SPAM, CITATION, INTRUSIVE THOUGHT, TRACER) was a real BW decision. | Yes | | |
| E6 | A Black ICE (2nd strike) felt like an emergency, not a death sentence. | Survivable with effort | | |

## Economy

| ID | Check | Target / what good looks like | Result | Notes |
|---|---|---|---|---|
| F1 | CRED earned this corporation (from the summary). | 130–220 | | |
| F2 | You stayed in encounters to extract; note how often you emptied a reserve. | Extraction was a real temptation | | |
| F3 | Uplink visits this corporation. | About 2 (rows 4, 7, 10) | | |
| F4 | What you bought. Note anything you wanted but couldn't afford. | 2–3 cards, or 1 Ghostware + CAPS | | |
| F5 | Card prices (40 / 60 / 90 CRED) felt right. | Choices, not auto-buys | | |
| F6 | CAP prices (20 / 35 / 55) and the BOOTLEG risk felt right. | Sometimes worth it | | |
| F7 | Ghostware at 100 (75 with a drawback) was worth considering. | A real trade-off against cards | | |
| F8 | Wipe (50, +25 each use) was used, and worth it. | Used at least once in a good run | | |
| F9 | The Clinic (50 CRED to clear CORTEX) was worth it when you had CORTEX. | Yes | | |
| F10 | Unspent CRED at the end of the corporation. | Little left over | | |

## Deck & rewards

| ID | Check | Target / what good looks like | Result | Notes |
|---|---|---|---|---|
| G1 | Cards added vs removed this corporation (rewards + bought; removals by Wipe, Console Lab, data purge, FUSE). | About 8 added, about 2 removed (net +6 to +10) | | |
| G2 | Reward choices were interesting; note how often you skipped. | At least 1 of 3 worth taking | | |
| G3 | Going deeper gave noticeably better card choices. | Yes | | |
| G4 | The full-clear completion CAP was worth going deeper for. | Sometimes | | |
| G5 | Deck size at the end of the corporation. | HALCYON 18–22 · IRONWATCH 24–29 · LUCIDA 30–35 | | |
| G6 | Times you chose DECOMPILE over a card you liked *(after DSY-003)*. | At least once per corporation: a real choice | | |
| G7 | REBOOTs per encounter *(after DSY-007)*. | About 1.5 on target; 2+ in the GHOST band | | |
| G8 | A turn where the order of plays mattered *(after DSY-011, CHAIN)*. | Most encounters | | |
| G9 | END TURN advances without a HOLD prompt. Cleanup discards non-CACHED cards and the next turn draws six at base DRAW. | Every turn | | |
| G10 | Bloat tax: did you pay it, and was it fair? *(after DSY-001)* | Rare in good runs; a clear warning in bad ones | | |
| G11 | At the Central Node, you could name your deck's loop in one sentence. | Yes | | |

## CAPS & Ghostware

| ID | Check | Target / what good looks like | Result | Notes |
|---|---|---|---|---|
| H1 | CAPS used at good moments; 3 slots were enough. | Yes | | |
| H2 | JACK OUT: used? Were its limits clear? | Clear | | |
| H3 | The payload choice (1 of 3 Ghostware) had more than one tempting option. | Yes | | |
| H4 | Any Ghostware that felt too strong, too weak or unclear (name it). | None | | |

## Map & route

| ID | Check | Target / what good looks like | Result | Notes |
|---|---|---|---|---|
| I1 | Route choice was meaningful: you planned around Node types. | Yes | | |
| I2 | ICE Nodes on your route this corporation. | 6–7 | | |
| I3 | SIGNAL UNCLEAR events were fun and fair; name any that felt pointless. | Yes | | |
| I4 | SAFEHOUSE, DEAD DROP and Console Lab came at useful moments. | Yes | | |

## Central Node

| ID | Check | Target / what good looks like | Result | Notes |
|---|---|---|---|---|
| J1 | The Central Node felt like a climax. Note turns taken and VITAE lost. | Hard, about 4–6 turns | | |
| J2 | The boss's question (break the supports or rush the DEADLOCKs) was a real choice. | Yes | | |

## Pace

| ID | Check | Target / what good looks like | Result | Notes |
|---|---|---|---|---|
| K1 | Minutes per encounter. | 3–6 (PACE-008) | | |
| K2 | Minutes for the whole corporation. | 25–33 (75–100 per 3-corporation run) | | |
| K3 | Any stretch that felt like a grind (where?). | None | | |

## UI & clarity

| ID | Check | Target / what good looks like | Result | Notes |
|---|---|---|---|---|
| L1 | You could always tell what a card, ICE, CAP or Ghostware does. | Yes | | |
| L2 | The log was readable and key events stood out. | Yes | | |
| L3 | On the map, it was clear which Nodes you could reach. | Yes | | |
| L4 | The Uplink was clear: prices, and why you couldn't buy something. | Yes | | |
| L5 | Card names, costs and hover rules were readable on every card type (READ-001; in this build, the concept card faces). | Readable at normal distance | | |
| L6 | The angriest-looking ICE was the one about to hit hardest; mood matched the shown numbers (VIS-001, PULP-001). | Yes, before reading numbers | | |
| L7 | Corporation states were clear: Cracking, Strike and Mask off looked different, and your cards and HUD never changed (VIS-001, RUSTLER-LOOK-001). | Yes | | |
| L8 | The encounter looked like one product: top bar, ICE cabinets, CRT, cards and hand tray sat well together (ENC-CONCEPT-001). Note anything that looked out of place. | Yes | | |
| L9 | Dragging an Icepick onto an ICE outlined the legal rows, showed the exact BW cost and MARGIN before release, explained a refused target, and charged nothing for a refused drop (CHROME-001). | Always | | |
| L10 | Install a PROGRAM in the CRT panel, hover and click it, and play each kind of SCRIPT in its drop zone. | Invalid drops spend nothing | | |
| L11 | Right-click a hand card twice, then switch to fullscreen and check the backdrop and ICE faces. | 150% preview toggles and backdrop fills the window | | |
| L12 | Watch and listen as TRACE rises. Try music volume, mute and reduced motion. | Art and mix follow the corporation state and settings | | |

## Bugs

| ID | Check | Target / what good looks like | Result | Notes |
|---|---|---|---|---|
| M1 | Crash, freeze or stuck state (what were you doing?). | None | | |
| M2 | "(Not yet implemented…)" lines in the log: copy them into Notes. | None | | |
| M3 | A number or text that didn't match what a card or ICE says. | None | | |
| M4 | Anything that blocked progress. | None | | |
| M5 | LOGIC BOMB or RELAY appeared anywhere: rewards, decks, or a passive on CONSENT FORM (DEPRECATE-001). | Never | | |

## Overall

| ID | Check | Target / what good looks like | Result | Notes |
|---|---|---|---|---|
| N1 | Fun, 1–5, and did you want one more run? | 4+ and yes | | |
| N2 | Best moment and worst moment (Notes). | — | | |

## Run log fields

Run · Date · Build (BUILD_COMMIT) · Corporation · Rustler · Result (Cracked / Flatlined / Stopped) · Row reached · Minutes · Opener turns · CRED earned · CRED spent · Card rewards · Cards bought · Deck at end · Starter cards left · TRACE strikes · VITAE left · Fun (1–5) · Best moment · Worst moment · Run summary (paste)
