# VAS-ASSET-001 — Painted asset specification for the VAS-001 encounter screen

**Status:** PROPOSED (designer agreed the split 2026-11-26 08:24: painted hero pieces / shader structure / existing art reused; this spec's lists, sizes and prompts need review) · **Author:** Claude Code · **Decision context:** ARCH-V2-003, VAS-001 §9 (this document is the production detail of §9, not a new UI authority)
**Target:** `godot/assets/architecture_v2/references/PANOPTICON_VAS-001_reference_mockup.jpeg` (1536 × 864), the designer-confirmed visual reference for the V2 encounter screen.

The reference is a painted composite. The game reaches it by assembling **separate painted parts** and drawing everything that changes on top: names, numbers, icons on keys, lamp states, glow and focus. The art stays blank; the game writes. Same rule as the ENC-CONCEPT-001 kits (UI Bible Sources 5–7), which worked.

**Design principles that override the reference where they differ (ARCH-V2-003):** preserve negative space (ARCH-V2-003m); icons communicate, numbers quantify, hover panels explain, typography announces. No textual subroutine rows; subroutines are horizontal illuminated keys. ICE type icon on the portrait frame's upper-left corner; STR medallion on the nameplate's upper-right corner (no "FORTRESS • STR 5" plaque). "SENTRY" becomes VOID ICE. One shared NEXT RESPONSE rail. Values and ICE in the reference are illustrative.

---

## 1. Who makes what

| Track | Owner | What |
|---|---|---|
| **A. Painted hero pieces** | ChatGPT image generation, prompted by the designer (§6); Codex may assist with cleanup and fixtures | Chrome bezels, enclosure, plaques and housings, medallions, CRT housings, END TURN dome, ad plate, chassis texture |
| **B. Shader / engine structure** | Claude Code | Chrome and copper bevel shading on stretchable rims, glass glare, CRT scanlines and phosphor bloom, lamp glow, rail step illumination, cyan focus/drag/selection, warning pulses, flyouts. Stays sharp at every size and reacts to state. |
| **C. Existing art, reused now** | Claude Code | §5. Used as stand-ins in the composition pass; replaced part by part as Track A delivers. |

Claude Code wires every delivered PNG through `ice_panel_layout.tres` and the V2 layout resources, so a new image replaces a stand-in by file name, with no code change.

## 2. Technical requirements (every Track A part)

1. **Resolution: 2× the reference.** The reference canvas is 1536 × 864; parts are painted for a 3072 × 1728 screen. Sizes below are the final PNG size.
2. **PNG, RGBA, sRGB, straight alpha.** Transparent outside the part. If the generator cannot do transparency, paint on **flat pure magenta `#FF00FF`** with no magenta in the art; Claude Code keys it out.
3. **Front-on, orthographic, flat.** No perspective, tilt, scene, or cast shadow outside the part. Inner shading and bevels are fine. Light from the top left, matching the reference.
4. **No text, letters, numbers, logos or UI icons** unless the prompt asks for an icon. Plates, screens and labels are blank.
5. **Stretchable parts (nine-slice):** all ornament (rivets, screws, corner flourishes, vents) inside the stated margins; the centre band and edges between corners must be plain and uniform so they stretch without distortion. Margins are given in final pixels.
6. **State variants share identical geometry.** A pressed or lit variant must line up pixel-for-pixel with the normal one; only material, light or colour changes.
7. **Readable grounds.** Any surface the game writes on (plates, glass, paper) stays an even tone, so 4.5:1 text contrast can be guaranteed. Wear and grain stay subtle there.
8. **File names exactly as given.** Deliver to `godot/assets/architecture_v2/<folder>/` (folders per VAS-001 §9) or attach in a Claude session. Keep any layered masters separately; a generated PNG is not an editable source.
9. **Manifest.** For each delivered part Claude Code records VAS-001 §9's manifest fields (asset_id, owner, reference crop, size, nine-slice margins, source/rights, version, approval state) in `godot/assets/architecture_v2/MANIFEST.md`.

**Generators rarely hit exact pixel sizes.** Ask for the stated aspect ratio at the largest size available; Claude Code resizes, trims and checks margins. Wrong aspect ratio or text in the image means a redo.

## 2a. What the game puts inside each part: icon first (UI-BIBLE-001, ARCH-V2-003)

The reference labels its instruments in words. PANOPTICON does not: **icons communicate, numbers quantify, hover panels explain, typography announces.** The resource HUD is icon-first, with values and meters visible and the explanatory label on hover/focus (UI-BIBLE-001, designer 2026-11-24/25). The painted parts are blank housings; this table is what the engine places in them. Words appear only in hover/focus panels, event flyouts, the ICE nameplate (kept by the designer), the game title and diegetic ad copy.

| Part | Shows (persistent) | Hover / focus explains | Never shows |
|---|---|---|---|
| `V2_METER_ROW` ×5 (VITAE, BW, RAM, SHIELD, incoming PULP) | resource **icon** in the socket, **value** (e.g. 30/30) and the segmented **bar** | the resource name and what it does | the word VITAE, BANDWIDTH, RAM, SHIELD or PULP INCOMING |
| `V2_FLIP_COUNTER` (turn) | a small **turn icon** on the brass band, the **number** on the flaps | "Turn n" | the word TURN |
| `V2_GAUGE_HOUSING` (trace) | **TRACE icon**, **value / max**, the **bar** | TRACE and its threshold | the word TRACE |
| `V2_ALARM_HOUSING` (hostile reveal) | its **icon** and the **%** | what the reveal means | the words HOSTILE REVEAL (content still open, designer question 1) |
| `V2_GLASS_PLAQUE` (phase) | an **icon** for whose turn it is (Rustler / Corporation) | the phase name | "PHASE:" or a phase name in words; the change of phase is **announced** by the flyout (RUSTLER TURN / CORP COUNTERMEASURE), which is typography by design |
| `V2_STATUS_STRIP` (ICE passive) | lamp + the passive's **icon** (+ number if it has one, e.g. +1 STR) | the passive's name and rule | the name HARDENING or its rule text |
| `V2_NOTE_CARD` (active effects) | **icon stamps** for each effect in play, with any count | the effect's name and rule | typed rule text |
| `V2_COUNTER_STACK` (deck, discard, burned) | an **icon** per window and its **number** (designer 2026-11-26: "Icon + number is perfect") | the pile's name and count | the words DECK, DISCARD, BURNED |
| `V2_RAIL_CAPSULE` (response step) | the subroutine's **icon + number** | the step's rule | PULP 1 / DEADLOCK in words |
| Medallions | type icon; STR **number** | "FORTRESS" etc.; "ICE STRENGTH: n" (ARCH-V2-003j) | — |
| `V2_NAMEPLATE`, `V2_LOGO_PLATE`, `V2_AD_PLATE_HALCYON` | ICE name; game title; ad copy | — | — |

*Correction (2026-11-26, designer):* earlier text in this spec planned word labels inside these housings ("blank label space", "game writes TURN / TRACE / PHASE", "HARDENING", typed active-effects text). That contradicted UI-BIBLE-001 and ARCH-V2-003 and is withdrawn; this table governs.

## 3. P0 parts list (first faithful slice)

Reference coordinates are approximate (x, y, w, h in the 1536 × 864 reference).

### 3a. ICE well → `godot/assets/architecture_v2/ice/` and `chassis/`

| File | Size (px) | Nine-slice L/T/R/B | Reference | Notes |
|---|---|---|---|---|
| `V2_ENCLOSURE_FRAME.png` | 2520 × 1020 | 96 / 96 / 96 / 96 | 275,100,1260,510 | The big polished-chrome machine window that holds the ICE: thick rounded chrome rim, inner lip, small rivets at corners. **Centre transparent.** |
| `V2_ENCLOSURE_BACK.png` | 512 × 512 | tileable | inside the enclosure | Dark green-black recessed metal behind the ICE windows; seamless tile; very subtle. Opaque. |
| `V2_ICE_WINDOW.png` | 1200 × 720 | 80 / 80 / 80 / 80 | 289,158,586,352 | One ICE window: heavy polished chrome bezel, rounded corners, seafoam enamel field (#78BBA7 family) with a soft centre glow and darker edges. Field plain and even. |
| `V2_ICE_WINDOW_HOVER.png` | 1200 × 720 | same | — | Same, the chrome lit slightly brighter with a faint warm rim light. |
| `V2_PORTRAIT_FRAME.png` | 440 × 440 | 40 / 40 / 40 / 40 | left of window | Slim inset chrome frame, rounded corners, **centre transparent** (the ICE portrait shows through). The type medallion overlaps its upper-left corner. |
| `V2_NAMEPLATE.png` | 600 × 120 | 48 / 30 / 48 / 30 | 615,210,290,58 | Black glass plate with a chrome rim and a small screw at each end. Blank. The STR medallion overlaps its upper-right corner. |
| `V2_MEDALLION_STR.png` | 256 × 256 | — | (new) | Round medallion: chrome rim, **plain dark enamel face**, blank (the game writes the number large in the middle). |
| `V2_MEDALLION_FORTRESS.png` | 256 × 256 | — | (new) | Same medallion style with a **deep red enamel face** and an ivory **castle-tower icon** (crenellated). Icon allowed. |
| `V2_MEDALLION_TUMBLER.png` | 256 × 256 | — | (new) | Same, **teal enamel face**, ivory **rotating-drum icon** (a reel with a curved arrow). |
| `V2_MEDALLION_VOID.png` | 256 × 256 | — | (new) | Same, **near-black violet face**, an ivory **eye opening on darkness** with a red iris. |
| `V2_STATUS_STRIP.png` | 960 × 56 | 40 / 12 / 40 / 12 | 425,500,480,28 | The thin cream enamel strip along the window's foot (the "HARDENING" strip), chrome edge, a round lamp socket at the left end. Blank. |
| `V2_KEY_BED.png` | 900 × 260 | 60 / 60 / 60 / 60 | (new) | A recessed darker-seafoam panel the subroutine keys sit in: inset shadow, chrome lip. Plain centre. |

### 3b. NEXT RESPONSE rail → `controls/`

| File | Size | Nine-slice | Reference | Notes |
|---|---|---|---|---|
| `V2_RAIL_HOUSING.png` | 2470 × 158 | 380 / 40 / 380 / 40 | 285,514,1235,79 | The long chrome-and-brass rail housing with **vent grilles at both ends** (inside the margins) and a black glass channel in the middle. Plain channel. |
| `V2_RAIL_CAPSULE.png` | 200 × 64 | 24 / 16 / 24 / 16 | e.g. "PULP 1" | Small black-glass capsule with a chrome edge for one response step. Blank. |
| `V2_RAIL_CAPSULE_LIT.png` | 200 × 64 | same | — | Same capsule lit amber from behind (the step firing now). |
| `V2_RAIL_ARROW.png` | 40 × 48 | — | ">" between steps | Small brass chevron pointing right. |

### 3c. Header → `chassis/` and `controls/`

| File | Size | Nine-slice | Reference | Notes |
|---|---|---|---|---|
| `V2_HEADER_BAR.png` | 3072 × 200 | 120 / 40 / 120 / 40 | 0,0,1536,100 | The full-width top fascia: brown bakelite and copper with chrome trim along the bottom edge. Plain between ends. |
| `V2_LOGO_PLATE.png` | 820 × 190 | — | 0,0,410,95 | The PANOPTICON logo plate: dark enamel plate with a brass rim and the **starburst** at its left, **no lettering** (the game sets the title). |
| `V2_FLIP_COUNTER.png` | 220 × 130 | — | TURN | Brass housing with two blank split-flap windows. |
| `V2_GLASS_PLAQUE.png` | 520 × 110 | 40 / 24 / 40 / 24 | PHASE | Long black-glass plaque with a chrome rim. Blank (game shows a turn-owner icon; the phase name only on hover, §2a). |
| `V2_GAUGE_HOUSING.png` | 480 × 130 | 40 / 24 / 40 / 24 | TRACE | Brass-rimmed black panel with a blank readout window and a blank horizontal bar-meter slot below it. |
| `V2_ALARM_HOUSING.png` | 360 × 130 | 40 / 24 / 40 / 24 | HOSTILE REVEAL | Dark red-black glass in a brass rim. Blank. |
| `V2_AD_PLATE_HALCYON.png` | 760 × 190 | — | halcyon home | Cream enamel ad plate with a chrome rim; at the **right**, a smiling 1950s pin-up woman (HALCYON's spokeswoman) leaning in. **Left two-thirds blank** for the game's ad copy. |

*Content still open (designer question 1): LAYER pips and EXTRACT plaque. Not requested until the content is decided.*

### 3d. Left rail → `crt/` and `controls/`

| File | Size | Nine-slice | Reference | Notes |
|---|---|---|---|---|
| `V2_CRT_SMALL.png` | 520 × 330 | — | 0,110,260,165 | Square-ish CRT monitor housing: chrome and brown bakelite, three small jewel lamps down the right side. **Screen area transparent.** |
| `V2_CRT_LARGE.png` | 560 × 440 | — | 0,615,279,217 | The larger lower-left CRT in the same style. Screen area transparent. |
| `V2_CRT_GLASS.png` | 400 × 300 | — | — | Curved glass overlay for the screens: soft highlight top left, darker corners, otherwise transparent. (Scanlines and glow are shaders.) |
| `V2_METER_RACK.png` | 540 × 470 | 40 / 40 / 40 / 40 | 30,295,240,235 | Dark bakelite rack holding five meter rows; chrome edges. |
| `V2_METER_ROW.png` | 520 × 84 | 70 / 20 / 30 / 20 | one row | One meter slot: round **icon socket** at left, a small black-glass **value window** at right, and an empty segmented **bar trough** between them. No label space (icon-first, §2a). |
| `V2_NOTE_CARD.png` | 560 × 240 | — | 10,540,270,110 | The active-effects paper card: off-white card, slight curl, a **paperclip** at the top-left. Blank; the game places rubber-stamp effect **icons** on it, never typed text (§2a). |

### 3e. Tray, counters, END TURN → `controls/` and `chassis/`

| File | Size | Nine-slice | Reference | Notes |
|---|---|---|---|---|
| `V2_TRAY.png` | 1860 × 524 | 120 / 60 / 120 / 80 | 279,602,930,262 | The physical card tray: brass and chrome lip along the bottom, dark recessed bed. Cards lie on it. Plain centre. |
| `V2_COUNTER_STACK.png` | 300 × 390 | — | 1325,690,150,195 | Bronze housing with **three** stacked black-glass readout windows (deck, discard, burned), each with a round **icon socket** at the left and a **number window** at the right; no label space (§2a). |
| ~~`V2_END_TURN` (+ states), `V2_LAMP_BAR` (+ off)~~ | — | — | 1490,680,170,170 | **Dropped (ARCH-V2-003m, designer 2026-11-26):** END TURN is an illuminated key from the subroutine-key family (Build 12 key art, larger), icon-first, lit when the turn can end; no dome, no lamp bar. Negative space. |
| `V2_CHASSIS_TILE.png` | 512 × 512 | tileable | everywhere behind | Dark warm bronze machine backplate texture, seamless, subtle wear. Opaque. |
| `V2_PIPE_V.png` | 48 × 512 | tileable vertically | right edge | Vertical chrome pipe segment with a highlight. |
| `V2_PIPE_JOINT.png` | 96 × 96 | — | pipe ends | Chrome pipe joint with a red-capped fitting. |

### 3f. Cards (Batch 2; listed so the family is planned together; prompts follow with Batch 2)

**Card body: CARD-HUCARD-001 (designer, 2026-11-22; reference photo `docs/visual/references/hucard_reference.png`) governs the shape; the VAS-001 mockup governs colour and finish.** Every hand card is a PC Engine HuCard-shaped card: portrait, credit-card proportions (about 54 × 85, **1 : 1.58**), rounded corners, a thin visible edge on the side and bottom in a slightly darker white (as thick as 3–4 stacked credit cards, **not** a chunky cartridge), **gold contacts along the bottom edge**, and a picture area slightly smaller than today's. Ignore the HuCard's black label area. No HuCard, NEC or game branding: shape and finish only. Cards are taller on screen than the prototype's. From the mockup: per-type colour framing around the art window (EXPLOIT red, DEFENSE amber, CLOAK violet, ICEPICK green), a cream rules field, the white cost medallion top-left. Card text follows the card rules already approved; icon-first (§2a) applies to how values are shown.

| File | Size | Notes |
|---|---|---|
| `V2_CARD_BODY.png` | 540 × 854 (1 : 1.58) | Blank HuCard-shaped body: off-white card face, rounded corners, darker-white edge visible on the right side and bottom, row of **gold contacts along the bottom edge**. No art, no frame colour, no text. |
| `V2_CARD_FRAME_<TYPE>.png` | 540 × 854 | Transparent overlay per type (EXPLOIT, DEFENSE, CLOAK, ICEPICK, …): the coloured frame around a slightly smaller art window, and the cream rules field, aligned to `V2_CARD_BODY`. |
| `V2_CARD_COST.png` | 128 × 128 | White cost medallion with a black ring, blank. |
| `V2_CARD_BACK.png` | 540 × 854 | HuCard-shaped back, no branding. |
| Card illustrations | per card | For the playable hand. |

## 4. Built in the engine (Track B, Claude Code)

| Effect | Where | Why engine, not paint |
|---|---|---|
| Chrome/copper bevel shading | any stretchable rim without painted art; tints per corporation (ENC-CONCEPT-001 console colour) | stays crisp at every size; recolours per corporation |
| Glass glare + CRT scanlines, phosphor bloom, gentle sweep | CRT screens, glass plaques | animated; reduced-motion aware (VAS-001 §8) |
| Lamp glow, key "firing" ring, rail step illumination | keys, lamps, rail | follows Game state exactly |
| Cyan focus / drag / selection, red refusal | keys, cards, ICE | interaction state |
| Warning treatments (PULP, DEADLOCK, TRACE) | keys, meters | state-driven, colour plus shape |
| Event flyouts | over the console | UI-TYPO-001 |

## 5. Existing art used now (Track C)

From `godot/assets/concept/ui/` and `godot/assets/concept/mascots/` (painted ENC-CONCEPT-001 kits, already licensed into the repo):

| Use in V2 now | Existing part | Replaced by |
|---|---|---|
| Subroutine keys (kept: Build 12 is the interaction reference) | `UI_KEY_*` (128 px caps, lamps, glow), `ICON_*` | optional 256 px repaint later (P1) |
| ICE portraits | `AUTO_RENEW_*`, `CAPTCHA_*` (1024 px, three moods) | per-ICE art as needed |
| Nameplate | `UI_PLATE_DARK` | `V2_NAMEPLATE` |
| CRT housings | `UI_CRT_MONITOR` | `V2_CRT_SMALL`, `V2_CRT_LARGE` |
| Meter rack | `UI_VITALS_PANEL` | `V2_METER_RACK` / `V2_METER_ROW` |
| Active-effects card | `UI_NOTE_SLIP` | `V2_NOTE_CARD` |
| Tray | `UI_HAND_TRAY` | `V2_TRAY` |
| END TURN | `UI_KEY_*` key art (larger key, icon-first; ARCH-V2-003m) | — (no new art) |
| TURN / TRACE housings | `UI_TURN_PLATE`, `UI_TRACE_COUNTER`, `UI_FLIP_TILE` | `V2_FLIP_COUNTER`, `V2_GAUGE_HOUSING` |
| Hover panel | `UI_TOOLTIP_PLATE` | — |
| Pipes, screws, rivets | `UI_PIPE_*`, `UI_SCREW`, `UI_RIVET` | `V2_PIPE_*` |

## 6. ChatGPT prompts (Track A)

**Yes, ChatGPT needs prompting, and the designer has to do it:** Claude Code cannot reach ChatGPT from its session. Use three conversations (6b ICE well and rail, 6c header and left rail, 6d tray, counters, END TURN and chassis) so each stays consistent. In each one:
1. Attach `PANOPTICON_VAS-001_reference_mockup.jpeg` (the reference).
2. Paste **Message 1** once.
3. Paste one part prompt at a time. Check each result against §7, then download it with the exact file name.
4. Commit the PNGs to the folder given, or attach them in a Claude session. Claude Code does the resizing, keying, nine-slice setup and wiring.

### 6a. Message 1 (paste once per conversation)

> I'm building the interface for a video game called PANOPTICON. The attached image is the target look. I need you to paint parts of that interface as **separate game-UI parts**, one image per request, so a game engine can assemble them and draw live text on top. Rules for every part:
> - Exactly the art style, materials and lighting of the attached image: 1950s atomic-age machine console, polished chrome bezels with rivets, warm brown bakelite, copper and brass, seafoam enamel, cream enamel, black glass, small jewel lamps. Light from the top left. Gentle wear and slight print grain.
> - **Front-on, flat, orthographic.** No perspective, no tilt, no scene around it, no shadow cast outside the part.
> - **Transparent background.** If you can't, use a flat pure magenta (#FF00FF) background and keep magenta out of the art.
> - **No text, letters, numbers, logos or UI icons** unless I ask for an icon. Leave every plate, screen and label **blank**.
> - Stretchable parts: put all ornament (rivets, screws, corner details, vents) near the edges and keep the middle and the straight edges **plain and even**, so the part stretches without distortion.
> - Use the exact aspect ratio I give, at the largest size you can.
> Reply "ready" and wait for the first part.

### 6b. ICE well and rail (conversation 1)

1. **`V2_ENCLOSURE_FRAME`** (2520 × 1020, about 5:2): "The large polished-chrome machine window that holds the two ICE windows in the reference: a thick rounded chrome rim with an inner lip and small rivets at the corners. The **entire centre is transparent**, only the rim is painted."
2. **`V2_ENCLOSURE_BACK`** (512 × 512, seamless tile): "A seamless tileable texture of dark green-black recessed machine metal, the surface visible behind the ICE windows. Very subtle, even, no highlights."
3. **`V2_ICE_WINDOW`** (1200 × 720, 5:3): "One ICE window from the reference (the AUTO-RENEW window), **empty**: heavy polished chrome bezel with rounded corners around a seafoam-mint enamel field with a soft lighter centre and slightly darker edges. No character, no plates, no lamps inside, just the bezel and the plain field."
4. ~~`V2_ICE_WINDOW_HOVER`~~ **Dropped (2026-11-26):** generators don't reproduce a frame pixel-for-pixel, so the hover state is made in the engine by brightening `V2_ICE_WINDOW`'s chrome. Skip this prompt.
5. **`V2_PORTRAIT_FRAME`** (440 × 440, square): "A slim inset chrome picture frame with rounded corners, the kind set into the seafoam panel to hold a portrait. **Centre transparent.**"
6. **`V2_NAMEPLATE`** (600 × 120, 5:1): "The black glass name plate from the reference (the one reading AUTO-RENEW) with its chrome rim and a small screw at each end, **blank**."
7. **`V2_MEDALLION_STR`** (256 × 256): "A round badge medallion: polished chrome rim around a plain dark enamel face. Blank face, no symbol."
8. **`V2_MEDALLION_FORTRESS`** (256 × 256): "The same medallion, deep red enamel face, with a simple ivory **castle-tower icon** (crenellated top, small gate) in the centre."
*Medallions (2026-11-26):* `V2_MEDALLION_FORTRESS` from ChatGPT sets the shared rim. ChatGPT's TUMBLER attempts had artifacts and the wrong symbol, so Claude Code builds `V2_MEDALLION_STR`, `_TUMBLER` (combination-lock dial, designer's choice) and `_VOID` (surveillance-camera lens, designer's direction) on that rim with flat ivory icons. Skip prompts 9 and 10.

9. **`V2_MEDALLION_TUMBLER`** (256 × 256): "The same medallion, teal enamel face, with a simple ivory **rotating drum icon**: a slot-machine reel with a curved arrow around it."
10. **`V2_MEDALLION_VOID`** (256 × 256): "The same medallion, near-black violet face, with a simple ivory **eye icon opening on darkness**, red iris, black pupil."
11. **`V2_STATUS_STRIP`** (960 × 56, about 17:1): "The thin cream enamel strip along the bottom of the ICE window in the reference (where it says HARDENING), with a chrome edge and an empty round lamp socket at the left end. Blank."
12. **`V2_KEY_BED`** (900 × 260, about 7:2): "A recessed panel set into seafoam enamel, slightly darker seafoam with an inset shadow and a thin chrome lip, where a row of buttons will sit. Plain inside."
13. **`V2_RAIL_HOUSING`** (2470 × 158, about 16:1): "The long NEXT RESPONSE rail from the reference: chrome and brass housing with **vent grilles at both ends** and a long black glass channel in the middle. Blank channel, no labels."
14. **`V2_RAIL_CAPSULE`** (200 × 64): "A small rounded black-glass capsule with a chrome edge, like the PULP 1 / PULP 2 capsules on the rail. Blank."
15. ~~`V2_RAIL_CAPSULE_LIT`~~ **Dropped (2026-11-26):** the lit state is an engine amber backlight on `V2_RAIL_CAPSULE`, for exact alignment and so it follows the firing step. Skip this prompt.
16. **`V2_RAIL_ARROW`** (40 × 48): "The small brass chevron arrow between rail capsules, pointing right."

### 6c. Header and left rail (conversation 2)

1. **`V2_HEADER_BAR`** (3072 × 200, about 15:1): "The full-width top fascia of the reference: brown bakelite and copper with a chrome trim along the bottom edge, rivets at the ends. **No plaques, no gauges**, plain between the ends."
2. **`V2_LOGO_PLATE`** (820 × 190): "The PANOPTICON logo plate from the top-left of the reference: dark enamel plate with a brass rim and the white **starburst** at its left. **No lettering at all.**"
3. **`V2_FLIP_COUNTER`** (220 × 130): "The TURN counter housing from the reference: brass housing with two **blank** split-flap number windows."
4. **`V2_GLASS_PLAQUE`** (520 × 110): "A long black-glass plaque with a chrome rim, like the PHASE plaque in the reference. Blank."
5. **`V2_GAUGE_HOUSING`** (480 × 130): "The TRACE housing from the reference: brass-rimmed black panel with an empty readout window and an empty horizontal bar-meter slot below it. No numbers." (Delivered. The game shows the TRACE icon, value and bar; the word only on hover.)
6. **`V2_ALARM_HOUSING`** (360 × 130): "The HOSTILE REVEAL housing: dark red-black glass in a brass rim. Blank."
7. **`V2_AD_PLATE_HALCYON`** (760 × 190): "The halcyon home ad plate from the top right of the reference: cream enamel plate with a chrome rim and, at the **right**, the smiling 1950s woman leaning in. The **left two-thirds are blank**: no words."
8. **`V2_CRT_SMALL`** (520 × 330): "The small CRT monitor at the top-left of the reference: chrome and brown bakelite housing, three small jewel lamps down the right side. The **screen area is transparent**."
9. **`V2_CRT_LARGE`** (560 × 440): "The larger CRT monitor at the bottom-left of the reference, same style. Screen area transparent."
10. **`V2_CRT_GLASS`** (400 × 300): "A transparent curved-glass overlay for an old CRT screen: a soft highlight at the top left and slightly darker corners, everything else transparent."
11. **`V2_METER_RACK`** (540 × 470): "The dark bakelite rack holding the VITAE / BANDWIDTH / RAM / SHIELD / PULP meters in the reference, with chrome edges, **empty**: no meters, no labels."
12. **`V2_METER_ROW`** (520 × 84): "One empty meter slot from that rack, redesigned so it carries no words: a round chrome-ringed icon socket at the left end, a small black-glass number window at the right end, and between them a long empty recessed bar trough with faint segment divisions. No label area, no letters, no numbers, no icons."
13. **`V2_NOTE_CARD`** (560 × 240): "The paper card from the bottom-left of the reference (where it says ACTIVE EFFECTS): off-white card with a slight curl and a paperclip at the top-left. **Completely blank paper**, no lines, no typing." (The game stamps effect icons on it.)

### 6d. Tray, counters, END TURN, chassis (conversation 3)

1. **`V2_TRAY`** (1860 × 524): "The physical tray the cards lie on in the reference: dark recessed bed with a brass and chrome lip along the bottom edge. No cards. Plain in the middle."
2. **`V2_COUNTER_STACK`** (300 × 390): "The bronze housing at the bottom right of the reference, redesigned to carry no words: three stacked rows, each a dark black-glass strip with a small round chrome-ringed **icon socket** at the left end and a small **number window** at the right end. No DECK / DISCARD / BURNED, no letters, no numbers, no icons."
3.–5. ~~END TURN dome, its states and the lamp bar~~ **Dropped (ARCH-V2-003m):** END TURN uses the existing illuminated key art. Skip these prompts.
6. **`V2_CHASSIS_TILE`** (512 × 512, seamless): "A seamless tileable texture of the dark warm bronze machine backplate seen between the panels of the reference. Subtle wear, even, no bright spots."
7. **`V2_PIPE_V`** (48 × 512, tiles vertically): "A vertical polished chrome pipe segment with a highlight, tileable top to bottom."
8. **`V2_PIPE_JOINT`** (96 × 96): "A chrome pipe joint with a red-capped fitting, like the ones on the right edge of the reference."

### 6e. Header slots (conversation 4, ARCH-V2-005, 2026-11-26)

The turn indicator and the TRACE meter are now half their former width, and the freed header holds two slot racks: CAPS (3 slots) and PROTOCOLS (3 slots). Until these files land the game draws placeholders (and nine-slices the old plaque and gauge housing). In a new conversation attach `PANOPTICON_VAS-001_reference_mockup.jpeg` **and** `docs/visual/fixtures/arch-v2-batch2/v2_header_slots_layout.png` (where each part goes), paste Message 1 (§6a), then one prompt at a time. Folders: `controls/` for 1–5, `icons/` for 6–7.

1. **`V2_GLASS_PLAQUE_HALF`** (520 × 260, 2:1): "A short black-glass plaque with a chrome rim, the same material as the PHASE plaque in the reference but **half as long**: nearly square-ended, rounded corners, two tiny screws at the ends. Blank glass, no symbols."
2. **`V2_GAUGE_HOUSING_HALF`** (480 × 310, about 3:2): "The TRACE housing from the reference made **half as wide**: brass-rimmed black panel with a small blank readout window in the upper half and a short, empty horizontal bar-meter slot along the bottom. No numbers, no markings."
3. **`V2_SLOT_RACK`** (840 × 272, about 3:1): "A low horizontal rack plate that holds a row of plug-in slots: warm brown bakelite with a polished copper-and-chrome rim and a small screw at each end. At the **left end**, a small round chrome-ringed **icon socket** (empty). The rest of the plate is a plain, even, slightly recessed bed (the game places three separate slot parts on it). No slots painted, no text."
4. **`V2_CAP_SOCKET`** (230 × 256): "One empty socket for a single-use capsule cartridge: a deep rounded-rectangle recess in dark bakelite with a thin brass collar and a faint inner shadow, like a fuse holder on a 1950s panel. Empty and dark inside, no capsule, no symbols."
5. **`V2_PROTOCOL_SOCKET`** (230 × 256): "One empty card bay for a slim program card: a square-cornered recess in dark bakelite with a thin chrome frame and two tiny guide rails at the top and bottom, like a card slot on a 1950s console. Empty and dark inside, no card, no symbols."
6. **`V2_ICON_CAPS_LIGHT`** (128 × 128): "A flat ivory (#F5E6C4) icon on a transparent background, no outline glow: a small capsule vial standing upright with a flip-off cap on top and a short needle at the bottom, half filled. Simple, bold, readable at 24 px."
7. **`V2_ICON_PROTOCOL_LIGHT`** (128 × 128): "A flat ivory (#F5E6C4) icon on a transparent background: three thin cards stacked in a rack, each with a small round lamp at its right end. Simple, bold, readable at 24 px."

*Icons 6–7 alternative:* the approved deck/discard/burned icons were drawn by Claude Code; it can draw these two the same way if ChatGPT's don't sit with them.

### 6f. Eye, Ghostware reel, speaker grille (conversation 4 continued, ARCH-V2-006)

Same conversation as §6e (or a new one with Message 1 and both attachments). Folders: `chassis/` for 1, `controls/` for 2–3. The game draws the CRED and LAYER icons itself (like the deck icons).

1. **`V2_EYE`** (512 × 512): "A round all-seeing machine eye for the top-left corner of the console: a thick polished chrome and copper bezel with small rivets, around a deep convex glass lens. Inside the lens, a glowing iris that is **pure white to pale grey** (the game tints it from cool green to neon red), fading to black at the edge, with a small bright highlight at the top left. Our own design: no film likeness, no logo, no text. Transparent outside the bezel."
2. **`V2_GHOST_REEL`** (360 × 272, about 4:3): "A small slot-machine reel window for the console header: a bakelite and chrome housing with one **square window** in the middle where a single symbol will show (empty, dark, with a slight curved-drum shading top and bottom, as if a reel turns behind it), and on the **right side** two small stacked chrome **arrow buttons**, one pointing up and one pointing down. No symbols in the window, no text."
3. **`V2_SPEAKER_GRILLE`** (240 × 120, 2:1): "A small 1950s speaker grille: a rounded chrome-rimmed plate with horizontal slots over dark cloth, like a radio speaker. Blank, no text."

## 7. Acceptance check (per part, before committing)

- [ ] Exact file name; aspect ratio as stated; size at least the stated size (Claude Code scales down).
- [ ] Transparent (or flat #FF00FF) outside the part; no cast shadow outside.
- [ ] No text, letters, numbers or logos; plates, screens and paper blank.
- [ ] Front-on and flat; light from the top left; matches the reference's materials.
- [ ] Stretchable parts: ornament only within the stated margins; centre and straight edges plain.
- [ ] State variants line up exactly with the normal image.
- [ ] Surfaces the game writes on are an even tone.

Claude Code then checks the part in the composition pass (side-by-side and overlay against the reference, contrast measured on captures) and records it in the manifest. Only the designer approves the final look (ARCH-V2-003).
