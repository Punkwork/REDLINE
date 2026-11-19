# CARDS-004 — Larger cards and the fanned hand (APPROVED and built, 2026-11-19)

Cards are drawn at **1.4×** (230 × 342) in the hand, reward offers, deck views and inspection. The hand is centred and fanned. The maximum hand is 10 cards (HAND-MAX-001).

| Cards in hand | 1–4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|
| Overlap | 5% | 8% | 10% | 18% | 26% | 35% | 43% |

- **Fan:** 20° in total across the hand, and at most 4° between neighbours. The overlap gathers at the card bottoms, so the top corners (cost dial and corner icons) stay readable.
- **Hover:** the hovered card rises 36 px above its neighbours.
- **CARDS-004a:** the BW cost dial sits in the top-left corner.

## Mockups (design review)

- `CARDS-004_Mockup_Cards_Current_vs_1.4x.jpg`: the size comparison.
- `CARDS-004_Mockup_Encounter_1.4x.jpg`: the size comparison in an encounter.
- `CARDS-004_Mockup_Hand_Overlap.jpg`: the first overlap pass, with no fan.
- `CARDS-004_Mockup_Fan_Tuned.jpg`: the approved fan at 4, 6, 8 and 10 cards.
- `CARDS-004_Mockup_Fan_With_Bloatware.jpg`: the fan with BLOATWARE in hand.
- `CARDS-004a_Dial_Top_Left.jpg`: the cost dial in the top-left corner.

## Build captures (from the fixtures)

- `CARDS-004_Build_Encounter.jpg`: a full encounter with the new layout. The ICE area is scaled to 85%, and the side columns and strips sit 104 px higher.
- `CARDS-004_Build_Hand_6.jpg`, `CARDS-004_Build_Hand_10.jpg` and `CARDS-004_Build_Hand_10_Raised.jpg`: the hand at 6 and 10 cards, and with a card raised.
- `CARDS-004_Build_Reward.jpg`: reward offers at 1.4×.
- `CARDS-004_Build_Inspection.jpg`: inspection at 150% × 1.4.

The fixtures `shot_hand.gd` (6–10 cards, geometry checks) and `shot_cartridges.gd` regenerate these captures.
