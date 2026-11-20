# ENC-CONCEPT-001 — ChatGPT prompts, round 5 (title screen and Rustler portraits)

**Date:** 2026-11-20 · **Author:** Claude · **For:** the designer, to paste into ChatGPT
**Why:** the designer asked for the title-screen art ("the background of the panopticon might as well be either a large architectural building like a prison or just like one big eye") and portraits of the four Rustlers for the character-select screen, in the look built so far. No reference images needed: each prompt carries the written style guide.

Wiring is a Claude Code task once the files arrive (the title and character-select screens don't load painted art yet).

---

## 1. Title screen

```
STYLE GUIDE: Painted 1950s atompunk / Googie advertising illustration, like a World's Fair poster or a mid-century appliance ad brought to life. Clean confident ink outlines, soft airbrushed gradients, gentle painted texture and a light halftone print grain. Not photographic, not 3D-rendered, not anime. Materials: polished chrome, glossy bakelite, seafoam-mint and celadon enamel, cream, brass and copper, rivets, porthole windows, starburst and sunrise-fan motifs. Palette: seafoam mint, cream, salmon pink, mustard, brass and copper with deep brown ink lines; night and alarm versions shift to deep blue, red and violet. Never any text, letters, numbers or logos in the image.

Title-screen art for my game PANOPTICON, a deck-building game about hackers ("Rustlers") breaking into cheerful corporations that watch everyone. The PANOPTICON is the idea of a prison where one guard in a central tower can see every cell, and the tower is also one giant eye. Rules for every image: exact size and file name; NO text, letters, numbers or logos (the game writes the title and the menu itself).

Make these ONE AT A TIME, in this order. After each, wait until I type "next".

1. TITLE_BG.png — 1920 × 1080, NOT transparent. A colossal round building seen from slightly below at golden-hour dawn, like a 1950s World's Fair pavilion that is secretly a prison: a ring of hundreds of identical cheerful apartment-cells with porthole windows, each lit warmly, stacked in tiers around a central chrome tower. The top of the tower is ONE GIANT EYE: a polished chrome-and-brass iris with a glowing pupil, framed by a sunrise-fan of brass rays, gazing straight at the viewer. Tiny figures in the windows. Searchlight beams sweep softly from the eye like friendly sunbeams. A neat suburban town and corporate billboards (no text) spread around the base. The upper-middle third (above the eye) and the left third of the image are calm sky with gentle clouds, so the game's title and menu can sit there.
2. TITLE_BG_NIGHT.png — the SAME view, composition and perspective at night, mask off: the cell windows are cold, the eye's pupil glows red, the searchlights are harsh white beams scanning the town, the sky deep blue with red haze. Same calm areas for the title and menu.
3. TITLE_EMBLEM.png — 1024 × 1024, transparent background. The game's emblem with no letters: a chrome-and-brass eye inside a brass starburst/sunrise fan, in a round enamel badge with a seafoam ring, polished and slightly menacing. Centred, front-on.

Reply "ready" and then make image 1.
```

---

## 2. Rustler portraits

```
STYLE GUIDE: Painted 1950s atompunk / Googie advertising illustration, the same style as a mid-century appliance ad or comic-book cover. Clean confident ink outlines, soft airbrushed gradients, gentle painted texture and a light halftone print grain. Not photographic, not 3D-rendered, not anime. Warm light from the upper left with a coloured rim light from behind. Never any text, letters, numbers or logos in the image.

Four character portraits for my game PANOPTICON's character-select screen. The Rustlers are hackers from the underworld beneath the cheerful corporations: salvaged 1950s gear, patched leather, chrome gadgets, tape, rivets, a bit punk. They are people, not mascots; each must look completely different (face, age, build, silhouette) and be readable at a glance from their signature colour and prop. Rules for every image:
- PNG, transparent background, 1024 × 1280 (portrait). Waist-up, three-quarters view, the head about 120 px below the top edge, the figure centred. Same framing and scale for all four so they line up side by side.
- Each has a signature colour used for their rim light and one clothing accent.
- NO text, letters, numbers or logos anywhere (no writing on clothes or tools).

Make these ONE AT A TIME, in this order. After each, wait until I type "next".

1. RUSTLER_GENERALIST.png — THE GENERALIST ("A bit of everything. Enough of nothing."), signature colour teal. A steady, practical all-rounder in their thirties: a utility jacket with many pockets and a tool roll, a chrome multitool in one hand, and a deck of punch cards fanned in the other showing three different coloured icepick symbols (one for each kind of lock). Calm, capable half-smile.
2. RUSTLER_ECHO.png — ECHO ("If they never notice you, you were never there."), signature colour deep indigo-violet. A slight, watchful young hacker in a dark hooded coat with the hood up, padded headphones round the neck, one finger raised to the lips, a lock pick wrapped in felt in the other hand. Face half in shadow, eyes sharp and calm. Muted, quiet, still.
3. RUSTLER_RIOT.png — RIOT ("Subtle is for people with time."), signature colour hot red-orange. A big, loud, grinning bruiser with a tall mohawk, a sleeveless patched leather vest, taped knuckles and a bandage across the nose, a taped sledgehammer over one shoulder with sparks around its head. Mid-laugh, fearless.
4. RUSTLER_VECTOR.png — VECTOR ("I don't break in. I wait for it to rot."), signature colour toxic green. A patient, unsettling older hacker in a stained lab coat over street clothes, a 1950s gas mask pushed up onto the forehead, round goggles, a bandolier of glowing green vials, holding a wasp-shaped lock pick with a needle tail. A thin knowing smile.

Reply "ready" and then make image 1.
```
