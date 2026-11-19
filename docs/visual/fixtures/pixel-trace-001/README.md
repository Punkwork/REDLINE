# PIXEL-TRACE-001 — TRACE pixelates the corporation's picture (APPROVED and built, 2026-11-19)

As TRACE rises, the backdrop and the ICE mascot art drop toward 16-bit. Text never pixelates: plaques, rules, numbers, cards, buttons, speech bubbles, status tags and graffiti all stay sharp.

| State | Cell | Colour levels per channel | Dither |
|---|---|---|---|
| TRACE 0–19 | sharp | — | — |
| TRACE 20–29 | 2 px | 24 | 0.6 |
| TRACE 30–39 | 3 px | 16 | 0.6 |
| Strike | 4 px | 12 | 0.6 |
| Mask off | 5 px | 10 | 0.5 |

**Transitions (PIXEL-TRACE-001a):** each step change spikes for 0.15 s to cells 2 px coarser, with half the colours and full dither, then settles on the new step over 0.35 s. With reduced motion, the change is instant.

These are the working values, kept in `godot/data/atomic_deco_punk.json` under `pixel`.

- `PIXEL-TRACE-001_Four_Levels.jpg`: the full encounter at all four levels.
- `PIXEL-TRACE-001_Four_Levels_1x_Crop.jpg`: the ICE area at 1:1, the pixel size seen in play.
- `PIXEL-TRACE-001_00/20/30/mask-off.jpg`: single full-size frames.
- `PIXEL-TRACE-001_Transition.gif`: the ICE area through the TRACE 19 → 20 and 29 → 30 transitions, at real speed (30 fps).

The fixture `godot/tests/shot_trace_pixel.gd` (in CI) regenerates these.
