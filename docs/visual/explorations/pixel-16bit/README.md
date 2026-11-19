# Pixel look exploration (PARKED, 2026-11-19)

**Not a decision.** The designer asked for an 8-bit/pixel encounter mockup and preferred 16-bit: "16 bit works much better, let's parking lot this for exploration." It is parked as a to-do for review on Saturday 2026-11-21. Nothing here is built or approved, and card size (CARDS-004) was decided independently of it.

- `PANOPTICON_Encounter_16bit.png`: the preferred variant.
- `PANOPTICON_Encounter_8bit.png`: the 8-bit variant.
- `PANOPTICON_Pixel_Closeup_Comparison.png`: close-ups of the two variants.
- `pixelate.py`: the script that made the mockups. It takes a captured encounter (`art.png` with text hidden, `full.png`, and `text.json` with the text rects) and redraws the text in pixel fonts (Pixelify Sans and Press Start 2P, both OFL; not committed here). The inputs came from a one-off capture and are not kept.
