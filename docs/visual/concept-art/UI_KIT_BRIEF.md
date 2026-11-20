# ENC-CONCEPT-001 — UI kit brief for ChatGPT (painted interface parts)

**Date:** 2026-11-19 · **Author:** Claude · **For:** the designer, to give to ChatGPT
**Goal:** the encounter screen should look like the three ChatGPT concept screens. Those are painted, so the interface is built from **painted parts** that the game assembles. The game then draws everything that changes on top: names, numbers, rule text, lamp states and key icons. That keeps the rules exact and every value live.

Mascots and card art have their own brief: `ART_BRIEFS.md`.

---

## How to use this in ChatGPT

1. Start one conversation. Attach the three concept images:
   - `ICE_ANALOG_CONCEPT_03_ENCOUNTER_TOOLTIP.png` (**the main reference**: frame, consoles, keys, tooltip, END TURN)
   - `ICE_ANALOG_CONCEPT_02_INSTRUMENT_KEYS.png` (the left monitor and vitals, the key states)
   - `ICE_ANALOG_CONCEPT_01_HALCYON.png` (extra detail)
2. Paste **Message 1** below once.
3. Then paste the parts one at a time (§2–§8). After each one, check it against the checklist in §9, then download it with the exact file name.
4. Attach the finished PNGs in Claude, or commit them to `godot/assets/concept/ui/`.

### Message 1 (paste once at the start)

> I'm building the interface for a video game called PANOPTICON. The three attached images are the target look; image 3 is the main reference. I need you to paint the interface as **separate game-UI parts**, one image per request, so a game engine can assemble them. Rules for every part:
> - Same art style, materials and lighting as the reference: 1950s–60s atompunk instrument panels: seafoam-mint enamel, polished chrome bezels with rivets, warm brown bakelite and copper, cream enamel plates, black glass, brass details, small jewel lamps. Soft studio light from the top left, gentle wear, slight print grain.
> - **Front-on, flat, orthographic view.** No perspective, no tilt, no scene around it.
> - **Transparent background** unless I say otherwise.
> - **Absolutely no text, letters, numbers, logos or icons** unless I ask for an icon. Leave plates and labels **blank**; the game writes on them.
> - Keep the **middle of stretchable parts plain**, with all ornament (rivets, bevels, corner details) near the edges, so the part can be stretched without distortion.
> - Exact pixel size as I give it.
> Reply "ready" and wait for the first part.

---

## 2. Screen frame and backdrop

| File | Size | Prompt (after Message 1) |
|---|---|---|
| `UI_FRAME.png` | 3200 × 2000 | The outer frame of the whole screen: a border of brown copper pipes, valves, brass fittings and riveted bakelite running around all four edges, about 60 px thick on the sides and bottom and 40 px at the top, like image 3. **The whole centre is transparent.** |
| `UI_BACKDROP_MACHINE.png` | 3200 × 2000 | A dim background of warm brown machinery and copper pipes behind the panels, softly out of focus, darker toward the edges, no bright spots in the middle. Not transparent. *(A placeholder until each corporation gets its own background.)* |

## 3. Top bar

| File | Size | Prompt |
|---|---|---|
| `UI_TOPBAR.png` | 3200 × 200 | The long top bar from image 3: dark brown bakelite with a chrome trim line along the bottom and rivets at the ends. **Plain in the middle** (it stretches). No plates on it. |
| `UI_PLATE_CREAM.png` | 480 × 72 | A blank cream enamel label plate with rounded corners, a thin chrome rim and a tiny screw at each end, like the "HALCYON NETWORK // NODE" plate in image 3. Plain centre. |
| `UI_PLATE_DARK.png` | 480 × 72 | The same plate in **black glass** with a chrome rim, like the ICE name plates ("AUTO-RENEW") in image 3. Plain centre. |
| `UI_PILL_GREEN.png`, `UI_PILL_RED.png`, `UI_PILL_BLACK.png` | 400 × 64 each | A blank glossy enamel pill-shaped status plate with a chrome rim, like "CONDITION: FRIENDLY" in image 3; one image each in green, red and black. |
| `UI_FLIP_TILE.png` | 64 × 96 | One **blank** split-flap card from the TURN/TRACE counters in image 3: dark rounded card, the horizontal split line across the middle, small metal hinge pins at both ends of the split. |
| `UI_LOGO_EMBLEM.png` | 128 × 128 | Just the small round emblem from the PANOPTICON logo in image 3 (the eye/target), brass and red. No lettering. |

## 4. ICE console

| File | Size | Prompt |
|---|---|---|
| `UI_ICE_CONSOLE.png` | 960 × 1100 | One empty ICE console from image 3: a seafoam-mint enamel cabinet with a thick polished chrome rim and rivets, rounded top corners, and a small **arched tab** centred on the top edge (blank, for the company name). Inside the top half, a recessed darker-mint **window** where a character will peek out; leave it empty. The bottom half is plain mint panel (the game places keys and plates there). Plain sides so it can stretch vertically. Transparent outside the cabinet. |
| `UI_POWER_LAMP_ON.png`, `UI_POWER_LAMP_OFF.png` | 48 × 48 | The small round green power lamp next to the ICE name in image 3: lit and glowing, then unlit. |
| `UI_STR_PLATE.png` | 200 × 96 | The blank cream plate that holds "STR 6" in image 3, with a chrome rim. |
| `UI_BADGE_UP.png`, `UI_BADGE_DOWN.png` | 72 × 72 | The small rounded badge beside STR: green (for ↑) and red (for ↓). Blank, no arrow. |
| `UI_REEL_WINDOW.png` | 160 × 400 | The vertical slot-machine reel window beside the CAPTCHA keys in image 3: black glass inside a chrome housing, with small up/down arrow bumps top and bottom. Empty glass. |
| `UI_CHEVRON.png` | 32 × 48 | The small brass arrow between keys in image 3, pointing right. |

## 5. Instrument keys (the subroutine buttons)

Each key is a rounded-square button, **128 × 128**, front-on, with its face blank (the game draws the icon and number). Make all of them in one style so they match.

| File | Prompt |
|---|---|
| `UI_KEY_READY.png` | Cream enamel key cap in a chrome bezel, slightly domed, like the "3" key in image 3. Blank face. |
| `UI_KEY_HIT.png` | The same key glowing: warm pink-red face with a soft red glow around the bezel (the "biggest hit" key in image 3). |
| `UI_KEY_DEADLOCK.png` | The same key as a glossy red push-button. Blank face (no padlock). |
| `UI_KEY_DEADLOCK_OPEN.png` | The same key as a green push-button, pressed slightly in. Blank face. |
| `UI_KEY_BROKEN.png` | The same key dull and grey, unlit. |
| `UI_KEY_HIDDEN.png` | The same key in black glass with a dashed outline. |
| `UI_KEY_TUMBLED.png` | The cream key with an amber glowing ring (newly tumbled in). |
| `UI_KEY_LAMP_GREEN.png`, `UI_KEY_LAMP_RED.png`, `UI_KEY_LAMP_AMBER.png`, `UI_KEY_LAMP_OFF.png` | 40 × 40 each: the tiny jewel lamp that sits above each key in image 3, in each colour and unlit. |
| `UI_BW_CHIP.png` | 120 × 44: the small dark rounded tag under each key that shows its cost. Blank. |

### Icons (drawn on the keys and plates)

**Format:** 128 × 128, transparent, **one solid dark-brown ink colour**, bold simple shapes like the key icons in image 2. One icon per file.

`ICON_PULP.png` (starburst), `ICON_TRACE.png` (a small planet with a tilted orbit ring), `ICON_DEADLOCK.png` (closed padlock), `ICON_DEADLOCK_OPEN.png` (open padlock), `ICON_DISCARD.png` (a card with an arrow leaving it), `ICON_INSERT.png` (an envelope), `ICON_BW_DRAIN.png` (a radio antenna with a minus sign), `ICON_CORTEX.png` (a stylised brain), `ICON_FORGET.png` (a card sliding under a deck), `ICON_HIDDEN.png` (a question mark), `ICON_BOOTING.png` (a padlock with a small clock), `ICON_TIMING.png` (hourglass), `ICON_BREAK.png` (wrench), `ICON_PASSIVE.png` (lightning bolt).

## 6. Tooltip

| File | Size | Prompt |
|---|---|---|
| `UI_TOOLTIP_PLATE.png` | 720 × 560 | The rule plate from image 3: a cream enamel plate with a polished chrome rim and screws in the corners, a thin pointer on its left edge. Blank. Plain centre so it stretches. |
| `UI_TOOLTIP_STAND.png` | 200 × 260 | The chrome stand the plate sits on in image 1 (a short chrome post and round foot). |

## 7. Left monitor and vitals (image 2, with image 3 touches)

| File | Size | Prompt |
|---|---|---|
| `UI_CRT_MONITOR.png` | 448 × 520 | The left-hand monitor from image 2: a brown bakelite cabinet with a rounded CRT screen, two knobs and a vertical row of small lamps beside the screen, a speaker grille below. **The screen glass is plain dark green and empty.** |
| `UI_VITALS_PANEL.png` | 448 × 400 | The vitals panel under the monitor in image 2: a dark bakelite plate with chrome trim and rivets, with **five empty horizontal rows** (each a recessed slot for an icon, a label and a gauge). No icons, no text. |
| `UI_GAUGE_TRACK.png` | 340 × 28 | An empty recessed gauge track (black glass in a chrome rim) for a segmented bar. |
| `UI_GAUGE_SEG_RED.png`, `_AMBER.png`, `_BLUE.png`, `_ORANGE.png`, `_OFF.png` | 28 × 20 each | One glowing segment of the bar in each colour, and an unlit segment. |
| `ICON_VITAE.png`, `ICON_BW.png`, `ICON_SHIELD.png`, `ICON_DRAW.png` | 96 × 96 each | Small coloured enamel badge icons like image 2: a red heart, a yellow lightning bolt, a blue shield, two stacked cards. |
| `UI_PUNCH_HOLDER.png` | 448 × 64 | A small bakelite holder with three empty card slots (for the three punch cards). |

## 8. Buttons

| File | Size | Prompt |
|---|---|---|
| `UI_END_TURN.png`, `UI_END_TURN_HOVER.png`, `UI_END_TURN_PRESSED.png`, `UI_END_TURN_DISABLED.png` | 256 × 256 each | The big round red mushroom button from image 3, in a thick chrome ring. **Blank face** (the game writes END TURN). Normal; slightly brighter; pressed in and darker; dull brown-grey. |
| `UI_BUTTON.png`, `UI_BUTTON_HOVER.png`, `UI_BUTTON_PRESSED.png` | 448 × 64 each | A wide bakelite push-button with a chrome edge, for DECK, END RUN and VIEW. Blank. Plain centre. |

---

## 9. Checklist for every file

- Transparent background (except `UI_BACKDROP_MACHINE.png`).
- **No text, letters or numbers anywhere.**
- The exact pixel size and the exact file name.
- Front-on and flat; the same light and materials as the rest.

## 10. Order

Start with the parts that change the look most: `UI_ICE_CONSOLE`, the seven `UI_KEY_*` states, `UI_TOPBAR`, `UI_CRT_MONITOR`, `UI_VITALS_PANEL`, `UI_END_TURN`, `UI_TOOLTIP_PLATE`, `UI_FRAME`, `UI_BACKDROP_MACHINE`. Then the small pieces and icons. Claude wires each file in as it arrives and sends screenshots. Until a part exists, the game keeps drawing that part itself.
