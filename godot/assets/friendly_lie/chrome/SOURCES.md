# Chrome Deco prototype assets

Generated with OpenAI image generation on 2026-11-17 for CHROME-001. The exact model identifier, generation prompts and edit prompts are unavailable for these five assets. The table records the inputs and edit history recoverable from the development log and prior source notes. These prototype illustrations were approved in VISUAL-APPROVALS-002.

| Asset | Recorded source or reference | Recorded generation or edit |
|---|---|---|
| `atrium.png` | Designer-selected corrected Chrome Deco concept PNG (original file unavailable). | Pearl, celadon and chrome atrium derived from the concept, with live UI supplied by Godot. |
| `atrium-hostile.png` | The exact friendly atrium used for `atrium.png`. | Generated edit preserved the architecture while revealing observation galleries, cameras and processing rails. |
| `auto-renew-shell.png` | CHROME-001 appliance-shell direction. Exact input image files unknown. | Empty transparent appliance shell. Separate Godot controls supply the face, text, buttons and rule state. |
| `captcha-shell.png` | CHROME-001 appliance-shell direction. Exact input image files unknown. | Empty transparent appliance shell. Separate Godot controls supply the face, text, buttons and rule state. |
| `toner-illustrations.png` | CHROME-001 Rustler photocopy/collage direction. Exact input image files unknown. | Six-cell monochrome collage atlas sampled by Godot's AtlasTexture. Shared motifs indicate prototype card roles. |

The corrected concept PNG used as the CHROME-001 step 3 benchmark could not be recovered. The [CHROME-001 captures](../../../../docs/visual/fixtures/chrome-001/) show the implementation. See the CHROME-001 entries in the [development log](../../../../docs/REDLINE_DEVELOPMENT_LOG.md) for the recorded benchmark and asset decisions.

## FACADE-ART-001 (2026-11-17)

Tool for every generation and edit below: OpenAI ImageGen (`image_gen.imagegen`). The tool does not expose a versioned model identifier. Background outputs use 1586 × 992 PNG. Shells were generated as transparent 4 × 2 sheets, then split into the cells listed below, cropped to their alpha silhouettes and padded for game use. No text, game UI or separate face sprites were generated into these assets.

### `ironwatch-concourse.png`

- Image input: `atrium.png` in this directory (visual reference).
- Transparent background option: `false`.
- Exact generation prompt

```text
Symmetrical Raygun Gothic civic security concourse, 1939 transit hall meets precinct house, navy enamel and polished brass, fluted gunmetal pylons with brass caps, central stepped ziggurat clock tower over a sealed brass gate, gold seven-point badge inside a searchlight-fan sunburst, terrazzo floor with an inlaid brass street map radiating from the gate, finned porcelain patrol kiosks with porthole windows, brass planters with topiary, glazed coffered ceiling with globe lamps, calm daylight, small distant figures queueing politely, immaculate, no text. Render a landscape game background, aspect ratio 1586:992 (approximately 8:5), edge to edge. Use the reference only for framing and realistic polished architectural rendering. Strict one-point perspective with a sealed door exactly at horizontal center, vanishing point about 40% of image height, bottom 45% kept entirely as open floor for HUD. Keep furnishings and figures distant and above that line. Symmetrical camera and architecture. No text, lettering, interface, cards, signage, or UI.
```

### `lucida-solarium.png`

- Image input: `atrium.png` in this directory (visual reference).
- Transparent background option: `false`.
- Exact generation prompt

```text
Symmetrical Raygun Gothic wellness solarium, 1930s observatory sanatorium, lilac pearl enamel and rose-copper, glass dome with pale dawn sky, ring of streamlined chrome-trimmed sleep pods each with a softly glowing halo ring, slim copper columns, frosted glass screens, still reflecting pool before a sealed door crowned with a concentric orbit-ring emblem, pale terrazzo floor with inlaid concentric rings, peach dawn light, robed figures resting, potted palms, serene, immaculate, no text. Render a landscape game background, aspect ratio 1586:992 (approximately 8:5), edge to edge. Use the reference only for framing and realistic polished architectural rendering. Strict one-point perspective with a sealed door exactly at horizontal center, vanishing point about 40% of image height, bottom 45% kept entirely as open floor for HUD. Keep furnishings and figures distant and above that line. Symmetrical camera and architecture. No text, lettering, interface, cards, signage, or UI.
```

### `ironwatch-shell-sheet`

- Image input: `auto-renew-shell.png` in this directory (visual reference).
- Transparent background option: `true`.
- Exact generation prompt

```text
Create an exact regular 4-column by 2-row sprite sheet, landscape, with seven separate isolated front-facing game appliance shells, one centered per cell with a wide transparent gutter and absolutely no overlaps. The eighth cell (rightmost on bottom) is completely empty. Each object's full silhouette fits comfortably inside its cell. True transparent alpha background, no ground plane, no drop shadows, no grid lines, no text, no numbers, no characters or faces, no eyes, no mouths. Any dials, viewports and round lenses are blank smooth insets for placing separate live face sprites in game. Use polished softly realistic Raygun Gothic 1930s/1950s chrome-and-enamel product rendering, crisp distinct symmetrical silhouettes comparable to the reference's rendering finish, but retain each requested appliance shape. Read the cell order left to right across each row. IRONWATCH civic security set, navy enamel #1F3A5F, porcelain, polished chrome with restrained brass and badge gold. Top row: (1) brass three-arm transit turnstile and porthole display enclosure; (2) porcelain desk security kiosk with peaked-cap visor recess; (3) striped boom-gate arm on a finned post with blank lamp housing; (4) seven-point badge-shaped chest camera with blank lens seat. Bottom row: (5) finned flying saucer patrol drone with searchlight housing; (6) wall keycard reader slot in a sturdy chrome housing with a blank indicator strip; (7) two brass-topped velvet-rope security stanchions linked by a taut velvet rope; (8) fully empty.
```

### `lucida-shell-sheet`

- Image input: `auto-renew-shell.png` in this directory (visual reference).
- Transparent background option: `true`.
- Exact generation prompt

```text
Create an exact regular 4-column by 2-row sprite sheet, landscape, with seven separate isolated front-facing game appliance shells, one centered per cell with a wide transparent gutter and absolutely no overlaps. The eighth cell (rightmost on bottom) is completely empty. Each object's full silhouette fits comfortably inside its cell. True transparent alpha background, no ground plane, no drop shadows, no grid lines, no text, no numbers, no characters or faces, no eyes, no mouths. Any dials, viewports and round lenses are blank smooth insets for placing separate live face sprites in game. Use polished softly realistic Raygun Gothic 1930s/1950s chrome-and-enamel product rendering, crisp distinct symmetrical silhouettes comparable to the reference's rendering finish, but retain each requested appliance shape. Read the cell order left to right across each row. LUCIDA luxury wellness appliance set, lilac #C9B6F2 and pearl enamel, polished chrome and rose-copper with peach light. Top row: (1) streamlined headband on a pedestal stand with open halo ring; (2) pearl tablet with blank screen inset and concentric progress halo casing; (3) bedside dome clock with a blank moon-shaped dial inset and no numbers; (4) handheld streamlined scanner wand with a blank category dial. Bottom row: (5) chrome dreamcatcher hoop with glass beads and empty center mount; (6) Art Deco desk lamp with frosted shade and blank adjustment dial; (7) upright glowing ergonomic chrome-and-lilac wellness glove reaching gently forward, palm facing the viewer and blank; (8) fully empty.
```


### Shell sheet outputs

Cell numbering is left to right, top to bottom. No edit prompts were used for the shells. PNG processing was limited to cell extraction, low-alpha cleanup, silhouette cropping, and an eight-pixel transparent border. The eighth cell in each sheet was unused.

| Cell | IRONWATCH output | LUCIDA output |
|---|---|---|
| 1 | `ironwatch-turnstile-shell.png` | `lucida-baseline-scan-shell.png` |
| 2 | `ironwatch-security-guard-shell.png` | `lucida-onboarding-shell.png` |
| 3 | `ironwatch-checkpoint-shell.png` | `lucida-sleep-tracker-shell.png` |
| 4 | `ironwatch-body-cam-shell.png` | `lucida-mood-scanner-shell.png` |
| 5 | `ironwatch-patrol-drone-shell.png` | `lucida-dreamcatcher-shell.png` |
| 6 | `ironwatch-keycard-reader-shell.png` | `lucida-focus-mode-shell.png` |
| 7 | `ironwatch-barricade-shell.png` | `lucida-neural-handshake-shell.png` |

### `ironwatch-concourse-hostile.png` — selected retry

- Image input: the same original generation for `ironwatch-concourse.png`. The first edit put barrier posts too far into the foreground.
- Transparent background option: `false`.
- Exact retry edit prompt

```text
Same concourse and perspective. The brass street map on the floor glows red along a single path to the viewer; decorative grilles between pylons are revealed as holding-cell doors; porthole kiosks open as drone hangars with finned drones unfolding; the sunburst searchlights swing down and converge on the viewer; barrier posts have risen from the floor; red beacon light on brass; still spotless, no text. Edit the supplied original image in place. Lock the exact camera, projection, framing, horizon, vanishing point, architecture outlines, central closed door, columns, ceiling/window ribs, terrazzo map or concentric floor lines and furnishings positions pixel-for-pixel wherever unmodified. Make changes as practical lighting and mechanical transformations fitted to the existing objects, not a new room. Keep the same landscape dimensions and open lowest 45%, no text or game UI. Place every raised barrier post and rope far away, in the same depth band as the kiosk entrances and the foot of the central gate. Their bases end above 55% image height, at the original back edge of the map. Below that boundary leave only clean unobstructed terrazzo and its flat light reflections. No foreground stanchions, posts, rope, hardware, people, or objects. Do not shift the central badge, clock, columns, or kiosk footprints.
```

The friendly images supplied to the hostile edits were the native ImageGen PNGs. Any 1585 × 992 output was resampled by one pixel in width when exported for Godot. The hostile edits preserve the same visual camera and composition, with small local differences typical of generated edits.
