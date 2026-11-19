# Analog encounter mockups (ENC-ANALOG-001, EXPLORATION, 2026-11-19)

**Not a decision.** The designer saved this direction to return to: "I want to return to this elegant design and interface then incorporate it into the encounter screen." Nothing here is built or approved. The spec is `docs/REDLINE_ENCOUNTER_ANALOG.md`.

| File | What it shows |
|---|---|
| `HALCYON_CAPTCHA_A.png` | HALCYON CAPTCHA node (AUTO-RENEW + CAPTCHA), turn 2, TRACE 12, Friendly. 3200 × 2000 (2× of 1600 × 1000). |
| `HALCYON_CAPTCHA_B.png` | Same node, turn 3, TRACE 30, Cracking: 41% hostile reveal; backdrop and mascot art at PIXEL-TRACE-001's TRACE 30 step (3 px, 16 levels, 4×4 dither). |
| `HALCYON_CAPTCHA_B_ice_closeup.png` | The two ICE consoles from B at 2×. |
| `source/EncounterFriendly.dc.html`, `source/EncounterCracking.dc.html` | The static mockup markup, as published to the Claude Design canvas "Encounter HUD – Analog Gauge Cluster". |
| `source/gen.mjs` | The Node script that generated both mockups and the preview pages. Font and output paths point at the session machine; change them to rerun. Fonts: Barlow Condensed, DM Sans, Space Mono, Poiret One (OFL, not committed). |

The **cards** in these mockups are placeholders, not a card redesign. CARDS-001/004/005 stay as built.

The interactive left-HUD unit (`Main.dc.html`: PROGRAM reel and cockpit instruments) lives on the same canvas.
