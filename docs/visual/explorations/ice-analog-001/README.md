# ICE-ANALOG-001 — editable encounter visual exploration (2026-11-19)

**Status: PROPOSED / REVIEW REQUIRED.** No gameplay or default encounter integration. The designer explicitly said that all mockup numbers are illustrative; do not reconcile them with the current ICE roster. PANOPTICON is the project name; REDLINE remains the repository name.

## Source and outputs

- `godot/tests/ice_analog_visual.gd`: editable Godot Control drawing source; standalone presentation, no model calls, no changes to cards or the playable scene.
- `godot/tests/shot_ice_analog.gd`: captures six 1600×1000 visual states: friendly (turn 2, TRACE 12), cracking (turn 3, TRACE 30), tooltip, illegal break, VOID face-down, three ICE.
- `godot/tests/shot_ice_analog_animation.gd`: captures 72 frames for an animation review.
- `ice-instrument-keys.svg`: editable vector instrument-key study, seven icon families × six states.
- Earlier baseline mockups: `../encounter-analog-001/HALCYON_CAPTCHA_A.png`, `HALCYON_CAPTCHA_B.png`, `HALCYON_CAPTCHA_B_ice_closeup.png`.
- Additional concept renders produced in ChatGPT are **not yet committed**; this Godot source is a *structural study*, not a pixel-accurate recreation of those painted images.

## Generate review screenshots

Use the pinned Godot 4.3 editor. Import the Godot project before running the fixtures. From repository root, create a temporary output directory and run (with Xvfb on Linux):

```sh
mkdir -p /tmp/ice-analog-review
SHOT_DIR=/tmp/ice-analog-review godot --path godot --script res://tests/shot_ice_analog.gd
SHOT_DIR=/tmp/ice-analog-review godot --path godot --script res://tests/shot_ice_analog_animation.gd
ffmpeg -y -framerate 12 -i /tmp/ice-analog-review/ICE-ANALOG-001_anim_%03d.png -vf scale=800:-1 /tmp/ice-analog-review/ICE-ANALOG-001.gif
```

**Important:** This code has not yet been run in Godot 4.3 or validated with the rules suite in the authoring environment. Screenshots, GIF and tests must be generated/verified by the next build operator before review. Do not treat the frame harness as a completed animation: its current transitions are placeholders.

## Design intent / remaining work

Preserve Claude's mint HALCYON appliances, chrome, bakelite Rustler console, CRT and split-flap styling. Scale the existing mascot art by 25–35% rather than replacing it with new illustrations. Existing fixture mascots are vector *stand-ins*; replace with original approved art when asset loading is available. The instrument keys should use the existing HUD icon language, be 56–64 px at 1600×1000 (never below 44), and carry BW cost and non-colour state marks. The Godot fixture currently uses simple fallback glyphs and text and **does not meet the full visual brief**. It needs accurate artwork, accessibility/keyboard navigation, true legal break logic, TUMBLER reel motion, mascot telegraph/flinch, pixel-step behavior, contrast audit and fixture execution before integration.

## Interpretations to confirm

1. VIS-001 §2.9: icon-only keys move detailed rule wording to tooltip while NEXT RESPONSE and passive strips retain text.
2. Mascot motion is ornamental, never the sole rules signal; reduced motion removes bob/tracking.
3. Three-ICE arrangement shrinks consoles; check minimum key target dimensions.
4. Mockup values and states are illustrative and are not rule proposals.
5. The proposed visual exploration is **not approved** and should not be merged into the default encounter without the designer's explicit approval.

### 2026-11-19 follow-up

The animation harness now drives five **presentation-only** phases (idle, attention, telegraph, break reaction, tumble) with deterministic frame progression. This is a proof-of-concept motion pass, **not** the final mascot animation or authentic TUMBLE-001 reel. It has not been rendered or tested in Godot. The existing vector mascot placeholders remain; do not confuse them with approved mascot artwork.

## Three ChatGPT concept mockups — binary import pending (2026-11-19)

The designer selected three ChatGPT-generated concept PNGs as visual references. **The actual PNG files have not yet been uploaded to GitHub.** They currently exist as conversation downloads. Add the exact PNGs to this directory on the laptop (do not recreate them or substitute stock images), using these target names:

1. `ICE_ANALOG_CONCEPT_01_HALCYON.png` — composite Friendly/Cracking encounter concept and detail.
2. `ICE_ANALOG_CONCEPT_02_INSTRUMENT_KEYS.png` — instrument keys and visual states study.
3. `ICE_ANALOG_CONCEPT_03_ENCOUNTER_TOOLTIP.png` — detailed encounter/tooltip concept.

Source conversation filenames, respectively:
- `a_detailed_highly_stylized_retro_futuristic_turn.png`
- `a_highly_detailed_retro_futuristic_pixel_art_ui_co.png`
- `a_detailed_cinematic_game_ui_illustration_in_a_re.png`

After importing, confirm each PNG opens and update this README with its dimensions and checksum. These are **art-direction references, not authoritative gameplay values or Godot fixture screenshots**. Preserve original Claude mockups in `../encounter-analog-001/`.
