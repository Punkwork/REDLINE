# PANOPTICON — ENCOUNTER SCREEN: ANALOG / FLIP-CLOCK / COCKPIT DIRECTION
**Date:** 2026-11-19 · **Author:** Claude · **Decision IDs:** ENC-ANALOG-001 (the direction, EXPLORATION), ICE-ANALOG-001 (the Codex brief, PROPOSED)
**Status:** EXPLORATION. Saved by the designer to return to ("I want to return to this elegant design and interface then incorporate it into the encounter screen. We have many screens to design."). Not approved for build. Nothing in the rules changes.

## 1. Where the mockups are
- **In the repo:** `docs/visual/explorations/encounter-analog-001/` (screenshots, mockup sources, README).
- **Design canvas** "Encounter HUD – Analog Gauge Cluster" (private to the designer): https://claude.ai/artifact/8MQFRD67F6UWSPGNWy8U9J

| Artboard / file | What it shows |
|---|---|
| `Main.dc.html` (canvas only) | The left HUD unit (interactive): PROGRAM reel on split-flap tiles, per-program measure strip, cockpit instruments (TRACE needle meter, BANDWIDTH LED graph, VITAE vial, SHIELD lamp ring, PULP Nixie tubes). |
| `HALCYON_CAPTCHA_A.png` / `EncounterFriendly.dc.html` | HALCYON CAPTCHA node (AUTO-RENEW + CAPTCHA), turn 2, TRACE 12, Friendly. 1600 × 1000. |
| `HALCYON_CAPTCHA_B.png` / `EncounterCracking.dc.html` | Same node, turn 3, TRACE 30, Cracking: 41% hostile reveal; backdrop and mascot art at the PIXEL-TRACE-001 step (3 px, 16 levels, 4×4 dither); text and controls sharp. AUTO-RENEW wary (S1 broken, STR 6 ↑2); CAPTCHA lethal (1 of 2 DEADLOCKs broken, PULP 6 tumbled in, STR 3 ↓2 after PROBE). |
| `HALCYON_CAPTCHA_B_ice_closeup.png` | The two ICE consoles from B at 2×. |

## 2. The look in one line
The Rustler side is a **1960s–70s brown bakelite flip-clock and cockpit**; the corporate side is **mint-enamel HALCYON appliances in chrome bezels**. Both are analog, so the split (ADP-001) reads as two kinds of machine rather than two art styles.

## 3. Design tokens used
| Token | Value |
|---|---|
| Bakelite housing | `#5a3f2a → #3e2b1d → #2e2016` (vertical) |
| Cream controls | `#f4ecda → #dccfb2` |
| Amber label / glow | `#e9963f` labels, `#ffb85a` glow |
| Black glass | `#0a0908`, cream `#e6dcc6` 2 px bezel |
| Chrome | `#fbfcfc → #c9cfd1 → #eef1f1 → #9aa2a4` |
| HALCYON enamel | `#d8efe6 → #b9e0d1 → #a2d3c1`; ink `#2f5d52`; deep `#3f7f70` |
| Signal red | `#d8321f` |
| Type | Barlow Condensed 500–700 (instruments, labels, numerals); DM Sans (corporate body, rule lines); Poiret One (corporate headlines ≥ 28 px only); Space Mono (NUL/REM note) |

## 4. Elements
- **Split-flap tiles** (dark rounded card, split line, metal hinge pins) for every name and number: Node name, program reel, STR, TURN, RESERVE, DECK/DISCARD, the NEXT RESPONSE board.
- **Jewel lamps**: status lights, glow when on; never the only signal (shape or text always accompanies them).
- **ICE console** (490 wide): name tiles + STR tiles with ↑/↓ delta; type · subtype line; SUPPORT/MAIN pill; round porthole holding the mascot; subroutine bank; passive lamp strip; patent plate. TUMBLERs show a reel window (pool entries dimmed above and below the active slots) and a slot-machine lever.
- **DEADLOCK** = chrome-ringed red mushroom push-button with a padlock; broken = green, pressed in.
- **END TURN** = large cream mushroom button in a chrome ring with an amber halo.

## 5. Interpretations to confirm
1. The TRACE lamp lights when TRACE is **high** (≥ 30); the other lamps light when low.
2. The HUD's PULP Nixie shows **incoming** PULP for the next response.
3. Program reel widened to 13 tiles; names shortened (TUMBLER PICK, FORTRESS PICK).
4. END TURN and DECK/DISCARD moved up beside the response board so the 1.4× hand (CARDS-004) has the full width.

## 6. Cards: not a redesign
The cards in the mockups are **stand-ins** drawn to fill the hand, approximating the CARDS-001 cartridges (brown SCRIPT / olive PROGRAM face, BW dial top-left per CARDS-004a, contact strip). They are not a proposal. Use the real CARDS-001/004/005 cards in any build.

## 7. Next: ICE-ANALOG-001 (designer direction, 2026-11-19)
Designer: redesign the **ICE readout, not the mascots**. Mascots get **a little bigger and more behaviour**. Subroutines become **icons with a value** (DEADLOCK as an image, not the word; same for TRACE, PULP, etc.), easy to see, elegant, fitting a very limited space; **hovering a subroutine icon shows its full text**. Codex takes this as a design-review task (designer's request); the brief is §8.

**Rule to confirm with this change:** VIS-001 §2.9 says rules are always readable as text in the scan tag. Icon-first subroutines move the full text to hover/focus. The NEXT RESPONSE board, the passive strip and the tooltips keep full text, so the player can still read every rule; the designer should confirm this replaces the old line.

## 8. Codex prompt (ICE-ANALOG-001)

```
TASK: ICE-ANALOG-001 — Iconized ICE subroutine readout + larger, livelier mascots (design exploration, HALCYON slice)

CONTEXT
- Repo: Punkwork/REDLINE on main. Follow CLAUDE.md / AGENTS.md. Godot slice under godot/. Read first: docs/REDLINE_ENCOUNTER_ANALOG.md (this direction), docs/REDLINE_VISUAL_LANGUAGE.md (VIS-001 §2.6 ICE = mascot + scan tag, §2.8 motion, §2.9 accessibility), docs/REDLINE_ATOMIC_DECO_PUNK.md (ADP-R1: rules readouts are always true and readable; bleed), docs/REDLINE_ICE_CORP1.md §5.0 (current slice ICE values), docs/HANDOFF.md (PIXEL-TRACE-001, CARDS-004/005).
- Reference mockups (in the repo): docs/visual/explorations/encounter-analog-001/HALCYON_CAPTCHA_A.png (Friendly, turn 2, TRACE 12), HALCYON_CAPTCHA_B.png (Cracking, turn 3, TRACE 30), HALCYON_CAPTCHA_B_ice_closeup.png. They show the analog direction: Rustler side = brown bakelite flip-clock/cockpit; corporate side = mint-enamel HALCYON appliances in chrome bezels; split-flap tiles for names and numbers; jewel lamps; Dymo-tape labels; red mushroom DEADLOCK buttons.
- The cards in those mockups are placeholders. Do NOT redesign cards; keep CARDS-001/004/005 as built.
- Nothing in the rules changes. Presentation only. Re-run the rules suite; it must stay green.

GOAL
Redesign how each ICE shows its subroutines and what will happen, so it is (1) elegant, (2) readable at a glance in a very small space, (3) inviting to touch. Do NOT redesign the mascot art. Make the mascots a little bigger and give them more behaviour.

1. SUBROUTINES BECOME ICON + VALUE "INSTRUMENT KEYS"
- Each subroutine is one round or rounded-square key (target 56–64 px at 1600×1000; never under 44 px): an icon plus a large value numeral (Barlow Condensed 700, at least 22 px). No effect words on the key itself.
- Icon vocabulary (one shape per effect, distinct by silhouette, not colour alone; reuse the HUD instrument glyphs so the player learns one set):
  - DEADLOCK: padlock on the red mushroom push-button. No number. Broken = green, pressed in, open shackle.
  - PULP X: the PULP starburst glyph (as on the HUD's PULP knob) + X.
  - TRACE X: the TRACE orbit/satellite glyph (as on the HUD's TRACE meter) + X.
  - DISCARD X: card with an out-arrow + X; "next turn" timing as a small clock pip.
  - INSERT X SPAM: envelope + X, with a small arrow to draw pile / discard / hand.
  - −1 BW (DETAINER): the BANDWIDTH antenna glyph with a minus.
  - CORTEX X: brain glyph + X.
  - PULP curve (random/hammer): starburst with a small dice or hammer badge; show the current value.
  - Face-down VOID subroutine: "?" key, dashed bezel.
  Design any icon the slice needs that isn't listed, in the same family, and list it.
- States (each must differ by shape or mark as well as colour): ready (lamp on); biggest hit this response (red ring + glow); broken (dimmed, struck through or flipped to a blank flap, lamp off); hidden; just tumbled in (brief flap animation); locked by BOOTING (small padlock-clock badge).
- Break affordance: the key itself is the break target (drag an Icepick onto it, or click/press to break when legal). Show the BW cost as a small chip on the key's edge; TOLL/TRIPWIRE costs appear in that chip (e.g. "1 BW · +1 TRACE"). Illegal break: key shakes once and the reason appears in the tooltip; no resources spent.
- TUMBLER: keep the reel window idea from the mockups. Active slots are full keys; the rest of the pool shows as small dimmed icons above and below. TUMBLE-001 drop-out/slide/tumble-in animates as a reel.
- FORTRESS: keys in a row S1→Sn. SEQUENCED shows the order with small chevrons between keys.

2. HOVER / FOCUS TOOLTIP = THE FULL RULE (ADP-R1)
- Hovering a key, or focusing it by keyboard/controller, opens a small plaque (cream enamel, chrome edge, DM Sans 14–15 px, contrast ≥ 4.5:1) with: the slot label, the full rule text exactly as the rules engine words it (e.g. "PULP 6 — lose 6 VITAE (SHIELD blocks)", "DEADLOCK — blocks BREACH until broken"), timing (this response / next turn), break cost and any passive surcharge, and the corporate flavour line where one exists (AUTO-RENEW "Premium plan").
- Opens within 150 ms, never covers the hovered key or the hand, flips side near screen edges, stays open while the pointer is on it. Instant with reduced motion.
- Full text must also stay available without hover: the NEXT RESPONSE strip keeps text, and the passive strip keeps its one-line rule. Flag in the log that this changes VIS-001 §2.9 ("rules always readable as text in the scan tag") for the designer to confirm.

3. MASCOTS: BIGGER, MORE BEHAVIOUR (same art)
- Scale the mascot about 25–35% larger within the ICE console; the console must still fit two ICE plus a support at 1600×1000 with the CARDS-004 layout (propose the 3-ICE layout too, e.g. THE HEARTH).
- Behaviour (extend VIS-001 §2.8; all flavour, never a rules signal on its own):
  - Idle: bob and blink per type (FORTRESS slow/heavy, TUMBLER fidgety, VOID still).
  - Attention: eyes follow the hovered or dragged card; when you hover one of its subroutine keys, the mascot glances at that key.
  - Telegraph: at the start of the Corporation Response, the mascot looks at / points toward the key that is about to fire, in left-to-right order, as each key's lamp flashes.
  - Reacts to breaks: flinch on a break; a bigger reaction on a DEADLOCK break; mood re-evaluated.
  - Moods (cheery / wary / lethal) per VIS-001 with the approved lines; ADP-2b hesitation lines still work.
  - Pixel steps (PIXEL-TRACE-001) still apply to mascot art and backdrop only; keys, tooltips and numbers stay sharp.
  - Reduced motion: no bob, shake or tracking; state changes are instant.

CONSTRAINTS
- Limited space: at 1600×1000 the whole ICE (mascot + keys + passive strip + name/STR) should fit within ~490 × 410 px per ICE for a 2-ICE layer. Prefer fewer, larger things.
- No effect, glitch or decoration crosses readable text or a numeral. Contrast ≥ 4.5:1. Never colour alone.
- No QR codes. No rules changes. One data file for tunable values (godot/data/atomic_deco_punk.json or a new ice_readout.json).

DELIVERABLES (design review first, integration after approval)
1. Icon sheet: every icon in all states, at 1× and 2×, on mint enamel and on black glass. PNG + source (SVG preferred) in docs/visual/explorations/ice-analog-001/.
2. Godot screenshot fixture (new shot_ice_analog.gd, alongside the existing shot_*.gd) of the HALCYON CAPTCHA node (AUTO-RENEW + CAPTCHA) matching the two reference states: Friendly turn 2 TRACE 12, and Cracking turn 3 TRACE 30 (AUTO-RENEW S1 broken, STR 6 ↑2; CAPTCHA one DEADLOCK broken, PULP 6 tumbled in, STR 3 ↓2). Plus: one tooltip open; one illegal-break state; the DOORBELL CAM node with a face-down VOID key; and a 3-ICE layout.
3. A short GIF or MP4 of the mascot behaviours (idle, attention, telegraph, break reaction) and a TUMBLE.
4. Log the work in docs/REDLINE_DEVELOPMENT_LOG.md under ICE-ANALOG-001 with "Interpretations to confirm", update docs/HANDOFF.md, and report the commit. Do not change rules code. Do not merge into the default encounter until the designer approves.
```
