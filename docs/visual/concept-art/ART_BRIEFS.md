# ENC-CONCEPT-001 — Art briefs for ChatGPT (mascots and card illustrations)

**Date:** 2026-11-19 · **Author:** Claude · **For:** the designer, generating in ChatGPT
**Why:** the designer chose the **screenshot-2 mascots and card look** (`docs/visual/explorations/ice-analog-001/ICE_ANALOG_CONCEPT_02_INSTRUMENT_KEYS.png`) and asked to make the art in ChatGPT. Claude builds the interface in code and wires each file in as it lands. Until a file exists, the game keeps the current art in that spot.

Attach `ICE_ANALOG_CONCEPT_02_INSTRUMENT_KEYS.png` to the ChatGPT conversation as the style reference for every request below.

## 1. Rules for every image

- **No text, letters, numbers, logos or speech bubbles in the art.** The game draws all words itself (ADP-R1). No QR codes.
- **No real people, brands or existing characters.**
- **Transparent background (PNG)** for mascots. Card illustrations are full-bleed, with no border and no frame.
- Keep each character **identical across its moods**: generate *cheery* first, then ask ChatGPT to edit that image for the other moods ("same character, same pose and framing, change only the expression and…").
- Hand files over with the **exact file names** below. Put them in `godot/assets/concept/mascots/` and `godot/assets/concept/cards/` (frames too), or attach them in Claude and Claude will commit them.

### Shared style line (paste at the start of every prompt)

> 1950s retro-futurist advertising illustration, friendly comical cartoon character in the style of mid-century appliance mascots, bold confident ink outlines, soft airbrushed shading, subtle halftone print texture and slightly worn offset-print grain, palette of seafoam mint, cream, salmon pink, mustard and brass with deep brown ink, warm studio light, atompunk.

## 2. ICE mascots

**Format:** PNG, transparent, **1024 × 1024**. The character is seen **from the chest up, peeking over a ledge**: both hands rest on (or grip) a horizontal ledge that runs along the **bottom edge of the image**, so the game can sit it on top of the ICE console. Keep the top of the head about 60 px below the top edge. The character faces three-quarters toward the viewer.

**Moods (three files per ICE):**
- `cheery`: delighted, big smile, welcoming gesture.
- `wary`: suspicious or startled, brows down, a sweat drop, the gesture held back.
- `lethal`: cold menace, narrowed glowing red eyes, harsh red rim light, the cheerful details turned sinister. Same character, not a monster.

File names: `<ICE_ID>_cheery.png`, `<ICE_ID>_wary.png`, `<ICE_ID>_lethal.png`.

### Batch 1: the two in screenshot 2 (do these first)

| ICE_ID | Character (from screenshot 2) | Cheery | Wary | Lethal |
|---|---|---|---|---|
| `AUTO_RENEW` | A cheerful little robot whose head is a rounded cream 1950s TV set with a glowing screen face (big grin, rosy cheeks), a brass drill-cone on the left side of the head, two small antennae, a pink polka-dot bow tie, cream mitten hands. A subscription salesman. | Grinning, one hand pointing at the viewer, eyes squeezed happy. | Screen face startled, a sweat drop, bow tie askew, finger pulled back. | Screen face a flat red glare with a thin smile, drill-cone spinning (motion lines), both hands gripping the ledge. |
| `CAPTCHA` | A 1950s pin-up switchboard operator: dark victory-roll hair, a brass radio headset with a small antenna, cream skin with rosy cheeks, long lashes, a mint dress collar. Checks whether you're human. | Big wink, waving hello. | Eyes narrowed sideways, a finger on her chin, unconvinced. | Headset glowing red, eyes flat red slits, a gloved hand raised like a stop sign. |

### Batch 2: the rest of the HALCYON slice (same style; Claude's character proposals, change freely)

| ICE_ID | Character proposal |
|---|---|
| `ACCEPT_ALL` | A beaming bellhop whose head is a big round green push-button, a little pillbox cap, white gloves held open in welcome. |
| `REJECT_ALL` | The same bellhop's twin with a grey push-button head and a "work in progress" bandage. Looks unfinished on purpose (its plate says PAT. PEND.). |
| `COOKIE_WALL` | A plump cookie-jar matron with a lace apron and an oven mitt, offering a cookie. |
| `TERMS_OF_SERVICE` | A rolled parchment scroll with round spectacles and a fountain-pen moustache, the scroll unrolling past the ledge. |
| `CONSENT_FORM` | A clipboard secretary with cat-eye glasses and a pencil behind her ear, a checkbox on her chest. |
| `DOORBELL_CAM` | A round chrome doorbell with one big camera-lens eye, a doorman's cap, small white gloves. Its eye should be clearly a lens. |
| `HOUSE_CALL` | Black ICE. A repairman in overalls and a peaked cap pulled low, face in shadow except two glowing red eyes, a toolbox on the ledge. **One file only:** `HOUSE_CALL_lethal.png`. |

#### Batch 2a prompt: ACCEPT ALL and REJECT ALL (paste once; 2026-11-20)

Attach `AUTO_RENEW_cheery.png` and `CAPTCHA_cheery.png` as style references, then paste:

```
Two new mascots for my game PANOPTICON, in exactly the same style as the two attached characters (same ink line, shading, halftone grain, palette and light). Rules for every image:
- 1950s retro-futurist advertising illustration, friendly comical cartoon character in the style of mid-century appliance mascots, bold ink outlines, soft airbrushed shading, subtle halftone print texture, palette of seafoam mint, cream, salmon pink, mustard and brass with deep brown ink, atompunk.
- PNG, transparent background, 1024 × 1024. Seen from the chest up, peeking over a ledge: both hands rest on a horizontal ledge along the bottom edge of the image. Top of the head about 60 px below the top edge. Three-quarters view toward the viewer, character on the left two-thirds of the image.
- NO text, letters, numbers, logos or speech bubbles anywhere.
- Keep each character identical across its three moods: same pose and framing, change only the expression and the details I list.

The two are twins on a cookie-consent banner: ACCEPT ALL is the easy, eager one; REJECT ALL looks almost the same but is the one that locks you in.

Make these ONE AT A TIME. After each, wait until I type "next".

1. ACCEPT_ALL_cheery.png — a beaming bellhop whose head is a big round glossy mint-green push-button with a happy face, a little brass pillbox cap, a cream bellhop jacket with brass buttons, white gloves held open in welcome. Delighted, big smile.
2. ACCEPT_ALL_wary.png — same character: startled, brows down, a sweat drop, gloves pulled back toward his chest.
3. ACCEPT_ALL_lethal.png — same character: cold menace, narrowed glowing red eyes, harsh red rim light, the button head now glowing red, both gloves gripping the ledge.
4. REJECT_ALL_cheery.png — his twin: the same bellhop build, but the push-button head is salmon-pink-to-grey and slightly duller, a small brass padlock hanging from the pillbox cap's chin strap, one glove raised politely as if saying "one moment". Polite smile.
5. REJECT_ALL_wary.png — same character: eyes narrowed sideways, unconvinced, the padlock swinging, a finger raised.
6. REJECT_ALL_lethal.png — same character: glowing red eyes, red rim light, the padlock now large and locked shut in front of his chest, both gloves gripping the ledge.

Reply "ready" and then make image 1.
```


## 3. Cards (the screenshot-2 card look)

**What the designer wants (2026-11-19):** "each card is essentially a little bit smaller. They're all white. They have bright colors on them… just essentially the word on the card, the name of the card, a little image that's in the color that the cards in the second screenshot… are." The face shows **the card's name and a small, brightly coloured picture** on a white card. The rules are read on hover (the existing card inspection), not printed on the face. The game draws the name, the BW cost and the corner icons itself, so the art has **no text**.

Two kinds of file make a card: one **blank card frame per type**, and one **picture per card**. Claude puts the picture in the frame's window and writes the name in its band.

### 3.1 Card frames (four files)

**Format:** PNG, transparent outside the card, **600 × 840** (5:7), no text.

> A blank playing card for a 1950s retro-futurist card game, matching the cards in the reference image: clean white card stock with a faint paper grain and very slightly rounded corners, a thin printed border in **[TYPE COLOUR]**. At the top, an empty white title band about 18% of the card height, with a thin coloured rule under it. Below it, an empty rectangular picture window about 62% of the card height with a thin dark keyline. At the bottom, a narrow empty strip. A small empty circle in the top-left corner for a cost. No text, no symbols, no picture inside the window.

| File | [TYPE COLOUR] |
|---|---|
| `CARD_FRAME_PROGRAM.png` | teal blue |
| `CARD_FRAME_SCRIPT.png` | salmon pink |
| `CARD_FRAME_PROTOCOL.png` | mustard yellow |
| `CARD_FRAME_BLOATWARE.png` | oxide red |

### 3.2 Card pictures

**Format:** PNG, **600 × 520**, full bleed (it fills the frame's window), no text, no border.

> Small bright illustration for a playing card, matching the card pictures in the reference image: flat bold screen-print colours with a few tones, simple strong silhouettes, a little halftone, cheerful 1950s retro-futurist feel. Background in **[TYPE COLOUR]** tones. Subject: **[SUBJECT]**. No text.

Tint by type: **PROGRAM** teal-blue, **SCRIPT** salmon-pink, **PROTOCOL** mustard, **BLOATWARE** oxide red with HALCYON mint leaking in (it's corporate junk). These are the Rustler's tools: hand-built, salvaged, a bit punk. Barcodes and punched holes are fine; QR codes are not.

File name: `<CARD_ID>.png`.

#### Batch 1: the Generalist starter deck and Bloatware

| CARD_ID | Type | Subject |
|---|---|---|
| `FORTRESS_ICEPICK` | PROGRAM | A heavy ice pick wedged into a riveted vault door, sparks. |
| `TUMBLER_ICEPICK` | PROGRAM | A slim lock-pick turning a spinning brass tumbler drum. |
| `VOID_ICEPICK` | PROGRAM | A glowing pick reaching into a black hollow diamond. |
| `BASIC_EXTRACTOR` | PROGRAM | A hose siphoning glowing coins out of a pipe into a tin can. |
| `CORTEX_BUFFER` | PROGRAM | A foil-lined colander helmet with a little valve on top. |
| `PULP_SHIELD` | SCRIPT | A trash-can-lid shield covered in taped foil, deflecting a bolt. |
| `PROBE` | SCRIPT | A gloved hand pushing a long needle probe into a chrome panel. |
| `GHOST_SIGNAL` | SCRIPT | A ghost silhouette slipping out of a surveillance beam, a paper Möbius-strip antenna. |
| `SPAM` | BLOATWARE | A cheerful envelope bursting with junk-mail coupons. |
| `TRACER` | BLOATWARE | A blinking tracking dot stuck on a jacket, a thin red beam leading away. |

#### Batch 2: the other Rustlers' starter cards

| CARD_ID | Type | Subject |
|---|---|---|
| `HUSH` | PROGRAM | A finger to masked lips beside a felt-wrapped lock pick. |
| `BORROWED_CREDENTIALS` | SCRIPT | A forged ID badge on a lanyard, the photo a cut-out. |
| `SLOW_DRIP` | PROGRAM | A dripping tap filling a jar with coins. |
| `SMOKESCREEN` | SCRIPT | A soup-can smoke bomb, pink smoke billowing. |
| `DEAD_AIR` | SCRIPT | A pirate radio with a sock stuffed in its speaker. |
| `SLEDGE` | PROGRAM | A taped sledgehammer mid-swing. |
| `BRUTE_FORCE` | SCRIPT | A shoulder slamming through a door, splinters. |
| `OVERLOAD` | SCRIPT | A fuse box overflowing with sparks. |
| `FEEDBACK` | SCRIPT | A speaker blasting rings of sound back at a camera. |
| `ADRENAL_SPIKE` | SCRIPT | A syringe-shaped battery with lightning inside. |
| `SHATTER` | SCRIPT | A chrome pane breaking around a fist. |
| `LAY_LOW` | SCRIPT | One eye peeking out from under a manhole cover. |
| `SMASH_AND_GRAB` | PROGRAM | A crowbar and a sack grabbing glowing capsules from a smashed case. |
| `STINGER` | PROGRAM | A wasp-shaped lock pick with a needle tail. |
| `RUNTIME_ERROR` | SCRIPT | A wrench jammed in the cogs of a corporate machine. |
| `INJECT` | SCRIPT | A glowing green vial plugged into a chrome port. |
| `REPLICATOR` | PROGRAM | A hand-cranked copier spitting out green virus cells. |
| `OUTBREAK` | SCRIPT | Green spores spreading across a chrome panel. |

Reward-pool cards come later in the same format, once batch 1 is in and the look is confirmed.

## 4. Hand-off checklist

1. Generate batch 1: `AUTO_RENEW` and `CAPTCHA` × 3 moods, the four card frames, then the 10 card pictures.
2. Check: transparent background (mascots), no text anywhere, exact file names.
3. Attach in Claude, or commit to the folders above. Claude wires them in and sends screenshots.
