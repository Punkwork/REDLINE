# ICE-ANALOG-001 — reference images (APPROVED for integration, 2026-11-19)

ICE-ANALOG-001 and ENC-ANALOG-001 are approved for the default encounters (master design doc, 2026-11-19). These files are **art-direction references**, not rules: every number, card and ICE value in them is illustrative. The rules engine is the authority. Spec: `docs/REDLINE_ENCOUNTER_ANALOG.md` (retired by UI-BIBLE-001; now [UI Design Bible, Source 2](../../../PANOPTICON_UI_DESIGN_BIBLE.md#source-2-docsredline_encounter_analogmd)).

## The three ChatGPT concept images

The designer's screenshots of the three concepts selected in ChatGPT (1334 × 750 each; the full-resolution originals were not available). Each shows a Friendly state, a Cracking state and a close-up.

| File | What it shows | SHA-256 |
|---|---|---|
| `ICE_ANALOG_CONCEPT_01_HALCYON.png` | Mascots peeking over chrome-framed mint consoles; rounded-square icon keys with lamps; TUMBLER reel column; tooltip plate on a stand. | `6c44faa8978abfd6e6d11d28ab6a4fbacc0e570c007ad0b5aa76a646bb80cf29` |
| `ICE_ANALOG_CONCEPT_02_INSTRUMENT_KEYS.png` | Key states and a legend: ready (green lamp), biggest hit (red), broken, hidden (?), tumbled-in (amber), BOOTING (lock + clock). | `9dd31e20cd99b5b097c2db99aa684b58e5c1d1145623afebb75ac549a6a60edf` |
| `ICE_ANALOG_CONCEPT_03_ENCOUNTER_TOOLTIP.png` | Detailed consoles, a vertical TUMBLER reel, and a tooltip plate: icon + name, Rule, Timing, Break, Passive, flavour line. | `8bdb03a939c295cc9e37b3de70a3c278bbf51d3f06d56a0a603676f69b1ec6b8` |

What the build takes from them: keys are **rounded squares** with a glyph and a numeral, a small lamp above each, and chevrons between them in firing order. The DEADLOCK is a red padlock key that turns green and open when broken. STR sits on a dark tile with a green ↑ / red ↓ change badge. TUMBLERs get a reel column showing the pool. The tooltip is a cream plate with labelled rows.

## Other files

- `ice-instrument-keys.svg`: Codex's editable vector key study (exploratory).
- The earlier Claude mockups are in `../encounter-analog-001/`.
- Codex's standalone wireframe fixture (`godot/tests/ice_analog_visual.gd`, `shot_ice_analog.gd`, `shot_ice_analog_animation.gd`) is replaced by the real integration (designer, 2026-11-19: "Replace it").
