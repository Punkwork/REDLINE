# ENC-CONCEPT-001 — Art briefs for ChatGPT (mascots and card illustrations)

**Date:** 2026-11-19 · **Author:** Claude · **For:** the designer, generating in ChatGPT
**Why:** the designer chose the **screenshot-2 mascots and card look** (`docs/visual/explorations/ice-analog-001/ICE_ANALOG_CONCEPT_02_INSTRUMENT_KEYS.png`) and asked to make the art in ChatGPT. Claude builds the interface in code and wires each file in as it lands. Until a file exists, the game keeps the current art in that spot.

Attach `ICE_ANALOG_CONCEPT_02_INSTRUMENT_KEYS.png` to the ChatGPT conversation as the style reference for every request below.

## 1. Rules for every image

- **No text, letters, numbers, logos or speech bubbles in the art.** The game draws all words itself (ADP-R1). No QR codes.
- **No real people, brands or existing characters.**
- **Transparent background (PNG)** for mascots. Card illustrations are full-bleed, with no border and no frame.
- Keep each character **identical across its moods**: generate *cheery* first, then ask ChatGPT to edit that image for the other moods ("same character, same pose and framing, change only the expression and…").
- Hand files over with the **exact file names** below. Put them in `godot/assets/concept/mascots/` and `godot/assets/concept/cards/`, or attach them in Claude and Claude will commit them.

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

## 3. Card illustrations

**Format:** PNG, **1024 × 1024**, full bleed, no text, no border. The game puts the title, cost dial and corner icons over the top band and the rules under the image, so keep the subject in the **middle 70%** with calm space at the top. These are the Rustler's side, the underworld's own tools: hand-built, salvaged, a bit punk. Barcodes and punched holes are fine as decoration; QR codes are not.

**Tint by card type** (as in screenshot 2):
- **PROGRAM**: teal-blue ground.
- **SCRIPT**: salmon-pink ground.
- **PROTOCOL**: mustard ground.
- **BLOATWARE**: oxide red, styled as **corporate** junk (HALCYON mint and chrome leaking in).

File name: `<CARD_ID>.png`.

### Batch 1: the Generalist starter deck and Bloatware

| CARD_ID | Type | Subject |
|---|---|---|
| `FORTRESS_ICEPICK` | PROGRAM | A heavy hand-forged ice pick wedged into a riveted steel vault door, sparks. |
| `TUMBLER_ICEPICK` | PROGRAM | A slim lock-pick turning a spinning brass tumbler drum, reels blurring. |
| `VOID_ICEPICK` | PROGRAM | A glowing pick reaching into a black hollow diamond in empty space. |
| `BASIC_EXTRACTOR` | PROGRAM | A rubber hose siphoning glowing coins out of a corporate pipe into a tin can. |
| `CORTEX_BUFFER` | PROGRAM | A foil-lined colander helmet with a little valve on top, held up proudly. |
| `PULP_SHIELD` | SCRIPT | A trash-can-lid shield covered in taped foil, deflecting a bolt. |
| `PROBE` | SCRIPT | A gloved hand pushing a long needle probe into a chrome panel, a crack spreading. |
| `GHOST_SIGNAL` | SCRIPT | A Möbius strip of paper with a foil antenna, a faint ghost silhouette slipping out of a surveillance beam. |
| `SPAM` | BLOATWARE | A cheerful HALCYON envelope bursting with junk-mail coupons, clogging a mail slot. |
| `TRACER` | BLOATWARE | A blinking mint tracking dot stuck to a jacket like a sticker, with a thin red beam leading off-screen. |

### Batch 2: the other Rustlers' starter cards

| CARD_ID | Type | Subject |
|---|---|---|
| `HUSH` | PROGRAM | A finger to masked lips beside a felt-wrapped lock pick. |
| `BORROWED_CREDENTIALS` | SCRIPT | A forged ID badge on a lanyard, the photo replaced with a cut-out. |
| `SLOW_DRIP` | PROGRAM | A dripping tap into a jar slowly filling with coins. |
| `SMOKESCREEN` | SCRIPT | A smoke bomb made from a soup can, pink smoke billowing. |
| `DEAD_AIR` | SCRIPT | A pirate radio with the needle on static, a sock stuffed in its speaker. |
| `SLEDGE` | PROGRAM | A sledgehammer with a taped handle mid-swing into a wall. |
| `BRUTE_FORCE` | SCRIPT | A shoulder slamming through a door, splinters flying. |
| `OVERLOAD` | SCRIPT | A fuse box overflowing with sparks and jury-rigged wires. |
| `FEEDBACK` | SCRIPT | A speaker cone blasting rings of sound back at a camera. |
| `ADRENAL_SPIKE` | SCRIPT | A syringe-shaped battery, lightning in a glass tube. |
| `SHATTER` | SCRIPT | A pane of chrome glass breaking into shards around a fist. |
| `LAY_LOW` | SCRIPT | A figure hiding under a manhole cover, one eye peeking out. |
| `SMASH_AND_GRAB` | PROGRAM | A crowbar and a burlap sack grabbing glowing data capsules from a smashed display case. |
| `STINGER` | PROGRAM | A wasp-shaped lock pick with a needle tail. |
| `RUNTIME_ERROR` | SCRIPT | A corporate gear-machine jamming on a wrench thrown into its cogs. |
| `INJECT` | SCRIPT | A glowing green vial plugged into a chrome port. |
| `REPLICATOR` | PROGRAM | A hand-cranked mimeograph spitting out green virus cells like copies. |
| `OUTBREAK` | SCRIPT | Green virus spores spreading across a chrome panel. |

Reward-pool cards (65) come later, in the same format, once batch 1 is in and the look is confirmed.

## 4. Hand-off checklist

1. Generate batch 1 (`AUTO_RENEW` and `CAPTCHA` × 3 moods; then the 10 cards).
2. Check: transparent background (mascots), no text anywhere, exact file names.
3. Attach in Claude, or commit to the folders above. Claude wires them in and sends screenshots.
