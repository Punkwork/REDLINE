# PANOPTICON — VISUAL LANGUAGE: THE FRIENDLY LIE
**Version:** 0.1 · **Date:** 2026-11-17 · **Author:** Claude · **Decision ID:** VIS-001
**Status:** Direction **B, "The Friendly Lie", chosen by the designer** on 2026-11-17 (in session: *"I do really like the B option the friendly lie … I think this is a more suitable direction"*). The rules, colors and copy below are **working values for a playtest prototype**; the designer may still change any of them.
**For:** Codex (Godot build, `godot/`). **Assets:** `docs/visual/` (reference images, placeholder backgrounds, mascot SVGs).

This file has two parts:
- **Part 1 — The brief.** The tasks exactly as the designer gave them, in order. Use Part 1 alone to explore the direction on your own.
- **Part 2 — The design produced so far.** What Claude made for each task: the rules, values and copy to build from. Part 3 says what to build in Godot and how to check it.

---

## Part 1 — The brief (tasks as given)

Context: PANOPTICON is a cyberpunk deck-builder. Rustlers (hackers) and their AI NUL/REM break into three corporations: **HALCYON** (smart home), **IRONWATCH** (private security), **LUCIDA** (neural wellness). Each corporation's defences are **ICE**. The rules are in `REDLINE_CORE_RULES.md`; the HALCYON ICE are in `REDLINE_ICE_CORP1.md` §5.0.

Three directions were explored: A *Phosphor* (amber terminal), **B *The Friendly Lie*** (corporations look like soft, pastel consumer apps; the ICE are their UI: cookie banners, consent forms, CAPTCHAs; the Rustler is a photocopied zine taped over it), C *Watchtower* (brutalist). **B was chosen.** Then the designer asked for:

1. **One encounter screen per corporation**, each with an appropriate background with its own personality and color palette.
2. **Correct hand size:** Rustlers draw **6 cards** a turn. A maximum hand size hasn't been decided yet.
3. **Show how the friendly face breaks**, and what full TRACE looks like.
4. **Give the ICE a living, breathing personality.** Animation will go a long way, but even in still images the ICE didn't look distinct from each other, or have a personality that flips from cheery and bright to lethal and angry.
5. **Put that into the encounter screen.**

Each result had to be viewable as images on the designer's phone (PNG), alongside the editable design.

---

## Part 2 — The design produced

Reference images are in `docs/visual/reference/`. They were made at **1600 × 1000** (exported at 1.5×); every px value below uses that frame.

### 2.1 The core idea

| Layer | Who it belongs to | Look |
|---|---|---|
| **The corporation** | Background, ICE mascots, corporate Bloatware | A soft, friendly consumer app: pastel, rounded, **DM Sans**, cheerful wording |
| **The Rustler** | Hand, HUD, TRACE meter, Node tag, NUL/REM, every rules readout | A photocopied zine taped over the app: black toner, off-white paper, highlighter yellow, **Space Mono**, hard shadows, slight rotations |

**Rule 1 — Your side never changes.** The Rustler layer looks the same in every corporation and every state, friendly or hostile. Only the corporation's world changes around you. *(Amended 2026-11-17, RUSTLER-LOOK-001 in the master design doc: the cards are now 1950s salvaged hardware (CARDS-001) while the HUD stays zine, on purpose. The HUD will probably change later; keep it as is until the designer decides.)*
**Rule 2 — The rules are always in zine style.** Every subroutine's effect (PULP 2, DISCARD 1, DEADLOCK, ? HIDDEN) is printed as a black-and-yellow zine chip, however the ICE looks or what it says. The friendly wording is flavour; the chip is the rule.
**Rule 3 — The DEADLOCK is always the corporation's friendly button** ("Keep my plan", "I'm not a robot", "Check in", "Begin"). NUL/REM's line: *"the button is the lock. break it."* While BOOTING applies, the button shows a lock until the 3rd turn.

### 2.2 Colors and type

**Rustler (constant everywhere)**

| Token | Hex | Use |
|---|---|---|
| Toner | `#111111` | Card headers, HUD, tags, borders |
| Paper | `#F7F7F2` | Card body, light text on toner |
| Highlighter | `#E4FF3A` | Costs, BW, END TURN, rule chips, NUL/REM text |
| Strike red | `#E5484D` | TRACE fill, warnings, TRACE costs |
| Rule grey | `#3A3A3A` / `#A9A9A0` | Dividers / small labels on toner |

Font: **Space Mono** 400/700 (Google Fonts, OFL).

**Corporations (DM Sans 400/500/700, OFL)**

| Corp | App | Ground | Accent | Deep / text accent | Extra | Ink |
|---|---|---|---|---|---|---|
| HALCYON | *halcyon home* | `#EAF4F0` | Mint `#7FD8BE` | `#17785F` | Peach `#FFE3D3`, trust blue `#C9D7FF` | `#1B2230` |
| IRONWATCH | *IRONWATCH SafeStreets* | `#E8EEF6` | Badge gold `#F2C14E` | Navy `#1F3A5F` | Map `#DCE6F2` | `#14243A` |
| LUCIDA | *lucida rest* | `#EFE9FA` | Lilac `#C9B6F2` | `#4B3B7A` | Peach `#FFD9C7` | `#2E2350` |

Muted corporate text `#4A5568` / `#5B6573`; row borders `#D5DCE5`. Corner radius per corp: HALCYON 24, IRONWATCH 14 (with a navy header bar "IRONWATCH · VISITOR SERVICES"), LUCIDA 32.

**Moods (all corporations)**

| Mood | Accent | Ground tint | Text |
|---|---|---|---|
| Cheery | Corp accent | Corp ground | Corp ink |
| Wary | Amber `#E8B04A` | `#F3EEDF` | Corp ink |
| Lethal | Red `#E5484D` | `#140809` (Black ICE `#0B0405`) | `#F6E7E7`, muted `#C9A3A5` |

Hostile HALCYON background ground: `#14070A`.

### 2.3 The corporation backgrounds (task 1)

> **2026-11-17:** HALCYON's blurred-app placeholder was replaced by the Chrome Deco atrium (CHROME-001, approved). The Raygun Gothic facades for IRONWATCH and LUCIDA, with their interface voice and ICE appliances, are in `REDLINE_CORPORATE_FACADES.md` (FACADE-001, APPROVED 2026-11-17). The placeholders below stay until that art is generated and built.

Each background is the corporation's **own cheerful app, blurred** (about 5 px blur, 75% opacity) behind the encounter, so the fight happens inside its product. Placeholders are in `docs/visual/backgrounds/` (2400 × 1500 JPG); final art can replace them later.

| Corp | Headline | Tiles | References |
|---|---|---|---|
| HALCYON | "Good morning." | Living room 21°, front door Locked, doorbell cam "No visitors today", energy bars, lights 6 on, "Everyone is home" | `01` |
| IRONWATCH | "Your block is safe." | Neighbourhood map with patrol route and pins, safety score 98%, officers nearby 4, "See something? Say something." | `02` |
| LUCIDA | "Breathe in." | Breathing circle, sleep score 92, mood Calm, "Tonight's dream: Ocean", thoughts-shared bars, "We remember, so you don't have to." | `03` |
| HALCYON hostile | "We see you." | Same tiles turned hostile: 31° "Do not adjust", front door "Doors will not open", doorbell cam "1 VISITOR: YOU", lights ALL ON "Stay where we can see you", "Someone is home · 1 intruder" | `05`, `06` |

### 2.4 The encounter screen layout (tasks 1–2)

At 1600 × 1000, padding 32 / 40:

| Area | Position | Contents |
|---|---|---|
| Node tag | Top left, rotated −1.5° | Toner box "NODE: CAPTCHA" (Space Mono 28–30 bold) + highlighter strip "HALCYON · TIER 1 · LAYER 1/1 · TURN n" |
| TRACE tag | Top right, rotated +1° | Toner box: TRACE bar (300 px, red fill, white tick at 50%), "n/40", STRIKES pips (3 red squares, filled per strike) or CRED |
| ICE zone | Centre | One block per ICE, left to right as in the rules (main ICE right-most) — see §2.6 |
| Response strip | Under the ICE | Paper box with toner border: "NEXT RESPONSE ▸ PULP 1 · PULP 2 · …" (the biggest hit in a red chip) + a NUL/REM note (toner, highlighter text, rotated −1°) |
| HUD | Bottom left, 200–210 wide | Toner stack: BW (highlighter), VITAE, SHIELD, NEXT DRAW |
| Hand | Bottom centre | **6 cards**, 146 × 218, gap 12, each rotated between −2° and +2°, hard shadow `5px 5px 0 #111111` |
| Deck / END TURN | Bottom right, 200–210 wide | Paper box "DECK n · DISCARD n"; END TURN in highlighter with toner border and hard shadow |

**Also on the encounter screen (existing UI, restyled in the zine look — see §2.10):**

| Element | Working placement |
|---|---|
| **RIG** (installed Programs, Icepicks, Extractors) and **RACK** (Protocols) | A taped zine strip above the hand, left of centre: one toner chip per installed card (name, STR, boost/break cost). Icepick chips stay **draggable onto the ICE** (UI doc §4); the scan-tag chip under the cursor is the drop target and highlights. |
| BW as card-reader slits | The BW row of the HUD shows one highlighter cell per BW (■■■□), filling left to right as BW is spent (UI doc §3). |
| CRED reserve (UI-002) | A small line in the TRACE tag or under the ICE zone: "RESERVE 9/15"; 0 in red. |
| END RUN (RUN-001) | A small red zine button under END TURN, with the existing confirmation. |
| TUMBLER reels (REEL-001) | The slot rows of a TUMBLER mascot spin as reels with the existing timings; the scan tag updates when they stop. |
| Tooltips, next-draw forecast, the event log | Unchanged in function; drawn as paper/toner boxes. |

**Zine card anatomy (146 × 218):** paper body, 3 px toner border; toner header with the name (Space Mono 13 bold) and the cost in a highlighter circle (26 px); a 48 px dashed art box; type line (9 px, letter-spaced); rules text (11 px) with key numbers on a highlighter background. With a 12-card Generalist deck and 6 in hand, the deck count reads 6.

**Hand size (open):** 6 cards fit at this size. If CACHE, HOLD 1 or Bloatware push the hand to 7 or more, **overlap the cards in a fan** rather than shrinking them; above about 8 cards, smaller cards would be needed. Don't hard-code a maximum hand size: the designer hasn't set one.

**Corporate Bloatware looks like the corporation, not the zine.** TRACER and SPAM are drawn as that corporation's rounded app cards (TRACER: white, red header, rule chip "+3 TRACE", footer "We just want to stay in touch."), so junk visibly doesn't belong in your hand (`05`, `06`).

### 2.5 The friendly face breaks (task 3)

The corporation's look follows TRACE and strikes (Core Rules §7):

| State | When | What changes | Reference |
|---|---|---|---|
| **Friendly** | TRACE 0–19, no strikes | Everything as in §2.3–2.4 | `01` |
| **Cracking** | TRACE 20–39 | Thin red glitch bands across the background (rgba(229,72,77,0.16)); ICE panels get a red/blue split edge; ICE wording slips ("We noticed unusual activity on your plan." / "Are you sure you're human?"); a corporate toast appears once when TRACE crosses 20: "Is everything okay? We're just checking on you."; a red tag under the TRACE meter: "PAST 50% · THEY'RE LOOKING". NUL/REM counts down: "14 TRACE to a strike." | `04` |
| **Strike 1** | TRACE reaches 40 the 1st time | The background swaps to the hostile version; a rounded HALCYON-shaped modal in red and black: "TRACE STRIKE 1 OF 3" / **"We see you."** / "HALCYON has located you. We've added something to help us keep in touch." with zine lines "+1 TRACER shuffled into your draw pile", "TRACE drops to 20", "next strike: BLACK ICE joins this encounter", and the TRACER card. Afterwards the screen returns to *Cracking* (TRACE is 20). | `05` |
| **Mask off** | Strike 2 or later (Black ICE present) | Hostile background stays; every ICE loses its rounded corners and pastels (square, dark, red border); wording turns honest ("Your plan cannot be cancelled." / "Prove it."); the DEADLOCK buttons turn solid red; Black ICE joins on the left with a red header "BLACK ICE · JOINED AT STRIKE n". NUL/REM: "the mask is off. one more strike and we can't leave." | `06` |

The Rustler layer and the rule chips stay exactly the same in every state.

### 2.6 ICE personality (task 4)

Each ICE on screen is **two pieces**:

1. **The mascot** — the corporation's face. Its **own silhouette** (the real-world object it's named after), a **face**, a **speech bubble**, and its DEADLOCK button.
2. **The scan tag** — NUL/REM's read of the ICE, taped under the mascot (toner, 300 wide, rotated ±1°, a strip of highlighter tape on top): name, STR (with "↑n" when it has grown), type · subtype · passive, every subroutine as a chip (label on the left: S1, SLOT 1, "the button", "tumbled in"), and a footer with the passive's rule. Chip states: normal (paper), **DEADLOCK** (highlighter), **broken** (grey, dashed, struck through), **hidden** (dashed outline, "? HIDDEN"), **new / biggest hit** (red).

**Silhouettes (HALCYON slice).** COOKIE WALL, CAPTCHA, DOORBELL CAM and AUTO-RENEW are drawn (`07`–`10`); the others are proposals in the same spirit.

| ICE | Silhouette | Face | DEADLOCK button | Status |
|---|---|---|---|---|
| COOKIE WALL | Wide banner strip (400 × ~100), cookie on the left | The cookie is the face | "Accept all" | Drawn |
| CAPTCHA | Small square widget (250 wide) with a 3×3 tile grid | One big eye on top | "I'm not a robot" checkbox (ticked and struck through when broken) | Drawn |
| DOORBELL CAM | Tall pill (210 × 330) | Its lens is its eye; the pupil follows your cards | The bell push | Drawn |
| AUTO-RENEW | Credit card (290 × 180) that tilts; price sticker on the corner | Face on the card | "Keep my plan" | Drawn |
| ACCEPT ALL | A big green "Accept all" pill | Face on the pill | — (support) | Proposal |
| REJECT ALL | A tiny grey "Reject all" link, half hidden; passive-aggressive | Small, sulky face | Itself | Proposal |
| TERMS OF SERVICE | A tall scrolling document with a scroll bar | Face at the top of the page | "I have read and agree" | Proposal |
| CONSENT FORM | A clipboard of toggle switches | Face on the clip | "Submit" | Proposal |
| HOUSE CALL (Black ICE) | A "Your technician is on the way!" map-pin card that turns into a faceless silhouette with red eyes | Always lethal | None (Black ICE has no DEADLOCK) | Proposal |

**Faces.** `docs/visual/mascots/` has the three moods as SVG (100 × 100): `face-*.svg` (general face), `captcha-eye-*.svg`, `doorbell-lens-*.svg`. Build each face from separate parts (eyes, brows, mouth, blush) so they can animate.
- **Cheery:** arc eyes (^ ^), wide smile, pink blush.
- **Wary:** flat, slanted brows, small dot eyes, flat mouth.
- **Lethal:** steep red brows, red eyes, jagged red teeth.

**The mood ladder** (each ICE has its own mood; highest that applies wins):

| Mood | When | Behaviour |
|---|---|---|
| **Cheery** | Default: nothing broken on this ICE, TRACE under 20 | Bounces, blinks, waves; corporate accent colors |
| **Wary** | This ICE has at least 1 broken subroutine this encounter, **or** TRACE is 20+ | Flinches, then goes still and **watches you**; amber; wording turns cold |
| **Lethal** | This ICE's part of the **next Corporation Response** deals **PULP 5 or more, or any CORTEX** *(working threshold; make it a tunable value)*, **or** the corporation is in *Mask off*, **or** it's Black ICE | Red, dark, sharp corners; red glow behind it; wording turns hostile |
| **Knocked out** | The encounter is BREACHED | X-eyes / dizzy face, then it slides away |

Lethal does a gameplay job as well as a dramatic one: **whichever ICE is about to hit hardest is also the one that looks angriest**, so the player sees the biggest threat before reading a number.

**Wording per mood** (speech bubble and ICE subtitle; the rule chips never change):

| ICE | Cheery | Wary | Lethal |
|---|---|---|---|
| COOKIE WALL | "We use cookies to make your visit sweeter!" | "You declined 2 cookies. Interesting." | "COOKIES ARE NOT OPTIONAL." (button "ACCEPT") |
| CAPTCHA | "Let's make sure you're human!" / "Just one quick check!" | "Hmm. Try that again." | "PROVE IT." / "WRONG ANSWER." |
| DOORBELL CAM | "Ding dong! Who's there?" | "Recording, for your safety." / "Oh? What's that you've got there?" | "I SEE YOU." |
| AUTO-RENEW | "Your plan renews automatically!" (sticker "FREE for 30 days!") | "You cancelled Basic? We'll remember that." (sticker "Renews next turn") | "Your plan cannot be cancelled." (sticker "NO REFUNDS") |
| AUTO-RENEW rows | Basic plan · PULP 1 / Plus plan · PULP 2 / Premium plan · PULP 3 | same | same |
| CAPTCHA row | "Select every traffic light" · DISCARD 1 | same | same |

Other slice ICE: write three lines each in the same voice (friendly corporate → cold → honest threat) and log them for the designer to approve.

### 2.7 Mascots in the encounter (task 5)

| Reference | Situation | What it shows |
|---|---|---|
| `08` | CAPTCHA node, turn 1 | Both mascots cheery; both DEADLOCKs are friendly buttons; NUL/REM: "both buttons are locks." |
| `09` | Same fight, turn 3 | AUTO-RENEW **wary** (S1 broken and struck through, HARDENING STR 6 ↑2). CAPTCHA **lethal**: its DEADLOCK was broken, so PULP 6 tumbled into slot 2 (TUMBLE-001); black widget, red glow, slit eye, "WRONG ANSWER."; PULP 6 in red in the response strip. |
| `10` | DOORBELL node, turn 1 | You drag GHOST SIGNAL out of your hand (a dashed gap stays in the hand); the doorbell's pupil follows the card; a red label warns "WATCHER: play this CLOAK card · +1 TRACE"; its S1 stays "? HIDDEN" until it fires (VOID-001). |

### 2.8 Motion (from the explorations; working values)

| Moment | Motion |
|---|---|
| Cheery idle | Bob 4 px on a 2.4 s sine; blink every 3–6 s (random) |
| Per ICE type | **FORTRESS:** slow, heavy bob. **TUMBLER:** fidgets; reels jitter and spin (REEL-001). **VOID:** almost still; **its eye follows the card you hover or drag** |
| Becomes wary | Brows drop over 150 ms; bobbing stops; eyes track your cards |
| Becomes lethal (telegraph) | 2 px shake for 60 ms, then a red glow pulsing once a second |
| Fires in the Corporation Response | Lunges 12 px toward the hand over 120 ms as its chip flashes (keeps PLAY-001's at-least-5-second response) |
| Subroutine broken | Flinch (scale 0.9 for 80 ms, recoil); a strike-through draws across the chip over 150 ms; mood re-evaluated |
| DEADLOCK broken | Its button presses in and ticks; the mascot reacts with a lethal or wary line |
| BREACH | Knocked-out face; the mascot slides down and fades over 400 ms; the scan tag peels off |
| TRACE crosses 20 | Toast slides in once; glitch bands flicker for 2–3 frames every 4–8 s, with an RGB split on the ICE |
| Strike | 300 ms red flash; the background cross-fades to hostile; the "We see you." modal stays 2.5 s or until clicked; the TRACER card flies into the draw pile |
| Mask off | ICE skins peel: rounded corners square off, pastels go dark; Black ICE drops in from the top left |
| **Your cards** | **No easing.** Cards snap or slap into place like paper (about 90 ms, no overshoot), with a small random rotation |
| Reduced motion | An option that swaps states instantly, with no bob, shake or flicker |

### 2.9 Accessibility

- Mood is never shown by color alone: the face, the silhouette's corners and the wording change too.
- Text contrast at least 4.5:1 (rule chips are toner/highlighter or paper/toner).
- The rules are always readable as text in the scan tag and response strip; the mascot is never the only place a rule appears.

### 2.10 Relationship to `REDLINE_UI_NULREM_Design_For_Claude.md`

That doc (2026-11-07) set an **"Atomic Salvage"** look, which the designer **deprecated** on 2026-11-17 ("I would deprecate that atomic salvage look"). VIS-001 **replaces its look, not its requirements**:

| UI doc section | Under VIS-001 |
|---|---|
| §1 Visual identity (Atomic Salvage: cream enamel, brass, green phosphor, scanlines) | **Replaced** by The Friendly Lie (§2.1–2.2). |
| §3 Punch cards and card reader | Card look replaced by the zine card (§2.4). **Kept:** text wraps and scales, never clipped; BW slits fill left to right. |
| §4 Installed hardware bay, drag-to-ICE | Look replaced by the RIG strip (§2.4). **Kept:** draggable Icepick chips, per-subroutine highlight on hover, reasons shown for illegal breaks, no resources spent on an invalid drop, tooltips. |
| §5 Combat presentation | **Kept:** independent subroutine rows with active/broken states, full effect text, chronological log, next-draw forecast. Its damage types (PHYSICAL / NEURAL / SYNAPTIC) are out of date: the Core Rules (PULP and CORTEX only) win. The END TURN key becomes the highlighter END TURN. |
| §6 NUL/REM personality | **Unchanged.** |
| §7 NUL/REM terminal (green phosphor) | Look replaced: NUL/REM speaks in taped zine notes (toner, highlighter text). **Kept:** text stationary during typing, wraps, never clipped, nothing drawn over the letters. |
| §8 PAPER CUT concept | Still a proposal; under VIS-001 it would be a shredder mascot with a blinking PAPER JAM light. |
| Playtest additions (REEL-001, PULP curve chips, END RUN, CRED meter) | **Kept**, restyled (§2.4). |

General rule carried over: **no effect, glitch band or decoration may cross readable text.**

---

## Part 3 — Build tasks for Codex

Build in this order and log each step in `REDLINE_DEVELOPMENT_LOG.md` under **VIS-001**. Adapt to the existing UI code; the names below are suggestions.

| Step | What | Done when |
|---|---|---|
| **VIS-001a** | **Theme and fonts.** Add DM Sans and Space Mono (OFL) under `godot/assets/fonts/`; a Rustler theme (§2.2) and a corporation skin resource (palette, radius, background textures, header style) for HALCYON, IRONWATCH and LUCIDA. | The HALCYON slice uses the HALCYON skin; the other two exist as data only. |
| **VIS-001b** | **Encounter layout** (§2.4): Node tag, TRACE tag, response strip, NUL/REM note, HUD, deck/END TURN, **6-card zine hand** with a fan for 7+ cards, Bloatware in corporate style. Backgrounds from `docs/visual/backgrounds/`. | Matches `01` in layout and color at 1600 × 1000 and scales to the playtest window. |
| **VIS-001c** | **ICE = mascot + scan tag** (§2.6) for the slice ICE: drawn silhouettes for COOKIE WALL, CAPTCHA, DOORBELL CAM, AUTO-RENEW; simple versions of the proposals for the rest. Faces from `docs/visual/mascots/`, built from separate parts. DEADLOCK shown as the button. Scan-tag chip states (normal, DEADLOCK, broken, hidden, new/biggest). | Every slice ICE can be told apart by silhouette alone; every rule is readable in its scan tag. |
| **VIS-001d** | **Mood system** (§2.6): cheery / wary / lethal / knocked out per ICE, with the triggers above; the lethal threshold as a tunable value; per-mood wording. | `08` and `09` reproduce from real game state. |
| **VIS-001e** | **Corporation states** (§2.5): Friendly, Cracking (20–39), Strike modal, Mask off (strike 2+), hostile background. | `04`, `05` and `06` reproduce from real game state. |
| **VIS-001f** | **Motion** (§2.8), including the VOID eye following the dragged card (`10`) and the reduced-motion option. | Each row of §2.8 can be seen in play. |
| **VIS-001g** | **UI fixtures and bot.** Add screenshot fixtures for: friendly turn 1, wary + lethal turn 3, Cracking, Strike 1, Mask off, DOORBELL drag, 8-card hand. Re-run the rules suite; nothing in the rules changes. | Fixtures render; tests pass; screenshots attached to the PR as PNGs so the designer can view them on a phone. |

**Out of scope for VIS-001:** final painted backgrounds and mascot art; IRONWATCH and LUCIDA mascots (they aren't in the slice); escape ICE; map, Uplink and reward screens. Note anything you had to invent (wording, proposal silhouettes, timings) in the log as *Interpretations to confirm*.
