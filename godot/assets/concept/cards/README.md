Card illustrations (ENC-CONCEPT-001, CARD-ART-001): full bleed, no text.

- New art: `<CARD_ID>.jpg`, 600x520, JPEG quality 92, 4:4:4 (no chroma subsampling), resized
  with Lanczos from the designer's originals in `PANOPTICON art/Card Images` (1347x1167).
- Older art: `<CARD_ID>.png` (the ten starter cards). `CardDB.art_path(id)` prefers the JPEG.
- `CARD_FRAME_*.png` are the per-type frames.

Brief: docs/visual/concept-art/ART_BRIEFS.md §3. Coverage is checked by tests/test_csa04_consumers.gd.
