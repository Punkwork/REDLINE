# PANOPTICON — SAMIZINE: THE UNDERWORLD'S ZINE LOOK
**Version:** 1.0 · **Date:** 2026-11-18 · **Author:** Claude · **Decision ID:** ZINE-003
**Status:** **APPROVED (2026-11-18).** The designer asked for "a unique new look for the zines … a mashup between zines and samizdat. Something never before seen", reviewed it in three rounds (folds and wear, fainter generations, ’Pelago) and accepted it ("Perfect. Save whatever information is necessary, including the artifacts"). No rules change.
**Builds on:** ZINE-001 (the zine as retro-mutated technology) and ZINE-002 (the zine as the underworld's samizdat), `REDLINE_ATOMIC_DECO_PUNK.md` (retired by UI-BIBLE-001; now [UI Design Bible, Source 4](PANOPTICON_UI_DESIGN_BIBLE.md#source-4-docsredline_atomic_deco_punkmd)) §2.1–2.2; ARCH-001, ARCH-NAMES-001, ARCH-SLANG-001 (`REDLINE_ARCHIPELAGO.md`); the Rustler palette in `REDLINE_VISUAL_LANGUAGE.md` (retired by UI-BIBLE-001; now [UI Design Bible, Source 1](PANOPTICON_UI_DESIGN_BIBLE.md#source-1-docsredline_visual_languagemd)) §2.2; RUSTLER-LOOK-001.
**Art:** `docs/visual/samizine/` (PNG boards, review PDF, canvas sources). Live design canvas: https://claude.ai/artifact/G84PwRDUPwMSvAYkBxmudW

---

## 1. The idea

**The punk zine's attitude, made with samizdat's materials.** Typed in carbon, run off on a spirit duplicator, headlines kidnapped from corporate ads, printed over the back of whatever the corporations mailed you, then folded into a pocket and carried until it falls apart.

**Where it applies:** every in-world underworld publication: *THE CARBON*, *NOTES FROM THE ’PELAGO*, lore zines between runs, the *THE CARBON* page on the defeat screen (ARCH-1a) and the lost-Rustler record at DEAD DROP (ARCH-1b).
**Where it doesn't (yet):** the Rustler HUD, Node and TRACE tags, rule chips and NUL/REM notes keep the current photocopied zine look (RUSTLER-LOOK-001). SAMIZINE is the brief for the HUD whenever the designer revisits it.

## 2. The seven ingredients

| # | Ingredient | What it looks like | Why (in the fiction) |
|---|---|---|---|
| 1 | **Carbon body** | All body text typewritten (Special Elite) in carbon blue `#23277A`, with a faint doubled ghost (offset ~0.6–0.9 px, 30–40% opacity). | It's the third carbon under the ribbon: never printed, always typed. |
| 2 | **Ditto purple** | Stamps and section heads in spirit-duplicator violet `#6A2C9A`, set in Stardos Stencil. | The 1950s school-handout machine nobody tracks. |
| 3 | **Kidnapped type** | Headlines are ransom-note letters cut from corporate ads: Poiret One on the corporations' own pastels (HALCYON mint `#7FD8BE`, LUCIDA lilac `#C9B6F2`, IRONWATCH gold `#F2C14E`, peach `#FFE3D3`), each tilted ±2–5°, mixed with stencil and typed letters. | The corporations' voice, cut up and made to say the underworld's words. |
| 4 | **Palimpsest** | Zines are typed over the back (or front) of corporate junk mail; the corporate print shows through faintly, sometimes mirrored (opacity 7–35%). | Paper is scarce and every copier reports. Use what they send you. |
| 5 | **Typed corrections** | Nothing is deleted: lies and mistakes are struck through and answered in red marker (Permanent Marker, `#B3262B`); typos are typed over with `xxxx`. | The record is never edited, only answered. "Sunnyside Manor" → *the ’Pelago*. |
| 6 | **Machine margin** | Punched holes down the spine; a barcode strip on every page. **Never QR codes.** | The zine also talks to machines (ZINE-001). |
| 7 | **Pocket wear** | Folded in quarters: a vertical and a horizontal crease (light ridge, shadow either side), a rubbed spot where they cross, soft frayed edges, grime at the edges and the thumb corner. Creases vary slightly per page. | Samizines are carried on the person, folded into a coat pocket, until they fall apart. |

Plus **copy generations** (§4) and the instruction every zine ends with: ***read it, copy it, pass it on*** ("COPY 5 OF 5 — MAKE 5 MORE").

## 3. Tokens

| Token | Value | Use |
|---|---|---|
| Onionskin | `#EEF0E6` | Page |
| Carbon | `#23277A` | Body ink (passes 4.5:1 on onionskin) |
| Ditto | `#6A2C9A` | Stamps, heads |
| Marker | `#B3262B` | Corrections, dedications |
| Toner | `#111111` | Barcodes, photocopied elements |
| Corporate pastels | HALCYON / IRONWATCH / LUCIDA palettes (Visual Language §2.3) | Kidnapped letters, palimpsest underprint only |

**Fonts:** Special Elite (typewriter body; Apache 2.0), Stardos Stencil (stamps; OFL, already approved for graffiti), Permanent Marker (corrections; Apache 2.0, already approved), Poiret One (kidnapped letters only; OFL, already in the build), Space Mono (small labels; already in the build). **Special Elite is new:** add it under `godot/assets/fonts/` with its licence and a `SOURCES.md` line (source: `google/fonts`, `apache/specialelite/`).

## 4. Copy generations

How far a page has travelled, shown by how worn its print is. **Decoration only.**

| Gen | Name | Treatment |
|---|---|---|
| 1 | The ribbon | Crisp carbon blue. |
| 2 | First carbon | Soft doubled edge. |
| 3 | Ditto run | Ink drifts violet and pales (~80% opacity); the ghost pulls away (~2.5 px). |
| 4 | Rebuilt copier | Badly misregistered on purpose (~4 px ghost, slight skew, ~70% opacity), to defeat the corporate fingerprint. |
| 5 | Many hands | Faint, soft and shifted (~60% opacity, light blur), still readable. |

## 5. Rules

- **Readability (ADP-R1, Visual Language §2.9) is unchanged.** Folds, wear, ghosts, generations and palimpsest are decoration: they never touch rule text, numbers, card names, costs or buttons. In-game, anything the player must read to decide stays crisp.
- **Wording:** the Rustlers and the underworld write **’Pelago** (ARCH-SLANG-001); the full word never appears on screen. Archipelago content follows ARCH-R1 (plain register, never a joke).
- **The kidnapped type is the only place Poiret One appears on the Rustler side**, and only as cut-out letters, never as set text (keeps §3.5 of the ADP doc intact).
- **Reduced motion:** SAMIZINE is static; if pages animate (unfolding, sliding in), use a cut instead.
- **No QR codes.** Barcodes and punched holes only.

## 6. The boards (`docs/visual/samizine/`)

| File | Shows |
|---|---|
| `01-style-sheet.png` | The ingredients, inks and paper |
| `02-the-carbon-cover.png` | *THE CARBON* #14 cover (kidnapped masthead, contents, dedication, copy stamp) |
| `03-the-carbon-ledger.png` | The ledger page: lost Rustlers, care-home names struck through, "the ’Pelago" in marker |
| `04-notes-from-the-pelago.png` | *NOTES FROM THE ’PELAGO*, typed over a Sunnyside Manor brochure |
| `05-copy-generations.png` | Generations 1 → 5 |
| `samizine-review.pdf` | All five boards as a review PDF |
| `canvas/` | The design canvas sources (`.dc.html` boards and `canvas.json`) |

## 7. Build notes for Codex

No new build task is approved by this doc on its own. Use SAMIZINE where approved tasks already draw zine documents:
- **ARCH-1a** (defeat screen): the *THE CARBON* page uses SAMIZINE: carbon body in Special Elite, the island name struck through and "the ’Pelago" in marker, pocket wear, a copy stamp.
- **ARCH-1b** (the record at DEAD DROP): the record is a SAMIZINE ledger page.
- Add Special Elite with its licence (§3). Implement wear and creases as overlay textures or a shader on the page panel, never on glyphs; generations as a per-document setting.
