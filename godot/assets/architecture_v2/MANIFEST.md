# Architecture V2 painted asset manifest (VAS-ASSET-001)

Parts for the VAS-001 encounter screen, per [`docs/architecture-v2/VAS-001_ASSET_SPEC.md`](../../../docs/architecture-v2/VAS-001_ASSET_SPEC.md). Generated images are not editable sources. Nine-slice margins are in this file's pixels (L/T/R/B). Approval: only the designer approves the final look (ARCH-V2-003); "accepted" in chat (2026-11-26) means the part passed the spec checks and is in use, not that the look is final.

| File | Size | Nine-slice | Source / provenance | SHA-256 (12) | State |
|---|---|---|---|---|---|
| `chassis/V2_AD_PLATE_HALCYON.png` | 2148 × 659 | 140/80/760/80 | ChatGPT (§6c-7), trimmed; blank left side stretches | 668161af6359 | PROPOSED |
| `chassis/V2_ENCLOSURE_BACK.png` | 1254 × 1254 | tile | ChatGPT (§6b-2) | 455ebf0538eb | PROPOSED |
| `chassis/V2_ENCLOSURE_FRAME.png` | 1971 × 798 | 120/120/120/120 | ChatGPT (designer prompt, VAS-ASSET-001 §6b-1) | 674802666177 | PROPOSED |
| `chassis/V2_HEADER_BAR.png` | 1553 × 95 | 80/20/80/20 | ChatGPT (§6c-1), trimmed; half 2× size, uneven middle (mostly covered by plaques) — engine fills middle from cleanest stretch | 6a5b449c4b5e | PROPOSED |
| `chassis/V2_LOGO_PLATE.png` | 2140 × 634 | 560/80/260/80 | ChatGPT (§6c-2), trimmed; taller than spec (middle stretches) | c374ded6de08 | PROPOSED |
| `ice/V2_ICE_WINDOW.png` | 1619 × 971 | 96/96/96/96 | ChatGPT (§6b-3) | 0ed97934af15 | PROPOSED |
| `ice/V2_KEY_BED.png` | 2138 × 506 | 60/60/60/60 | ChatGPT (§6b-12), trimmed; wider than spec (stretches); inset shadow added in engine | 4d33816e13f3 | PROPOSED |
| `ice/V2_MEDALLION_FORTRESS.png` | 1212 × 1214 | — | ChatGPT (§6b-8), trimmed | afb8f586fd48 | PROPOSED |
| `ice/V2_MEDALLION_STR.png` | 1212 × 1214 | — | Claude Code: FORTRESS rim + dark enamel face (ChatGPT STR rim did not match) | 2cf9cf5f7b4d | PROPOSED |
| `ice/V2_MEDALLION_TUMBLER.png` | 1212 × 1214 | — | Claude Code: FORTRESS rim + teal face + drawn combination-dial icon (designer chose dial 2026-11-26) | 15ae92ac4f15 | PROPOSED |
| `ice/V2_MEDALLION_VOID.png` | 1212 × 1214 | — | Claude Code: FORTRESS rim + violet face + drawn surveillance-lens icon (designer 2026-11-26) | 329b7afc8874 | PROPOSED |
| `ice/V2_NAMEPLATE.png` | 2125 × 418 | 200/80/200/80 | ChatGPT (§6b-6), transparent padding trimmed | 17359fe5f8b1 | PROPOSED |
| `ice/V2_PORTRAIT_FRAME.png` | 1254 × 1254 | 80/80/80/80 | ChatGPT (§6b-5) | d5ec93a15771 | PROPOSED |
| `ice/V2_STATUS_STRIP.png` | 1603 × 90 | 90/20/50/20 | ChatGPT (§6b-11), trimmed | b5531f17f49f | PROPOSED |
| `controls/V2_ALARM_HOUSING.png` | 2081 × 733 | 130/80/130/80 | ChatGPT (§6c-6), trimmed | f6b0fa6062d8 | PROPOSED |
| `controls/V2_FLIP_COUNTER.png` | 1512 × 934 | — | ChatGPT (§6c-3), trimmed | 05ccfa69184f | PROPOSED |
| `controls/V2_GAUGE_HOUSING.png` | 2157 × 695 | 130/80/130/80 | ChatGPT (§6c-5), trimmed | 508503d43498 | PROPOSED |
| `controls/V2_GLASS_PLAQUE.png` | 2152 × 536 | 140/60/140/60 | ChatGPT (§6c-4), trimmed | 9d424822e51e | PROPOSED |
| `controls/V2_RAIL_ARROW.png` | 813 × 1078 | — | ChatGPT (§6b-16), trimmed | 1ee9bcdfeaa4 | PROPOSED |
| `controls/V2_RAIL_CAPSULE.png` | 2150 × 332 | 170/40/170/40 | ChatGPT (§6b-14), trimmed; longer than spec (round ends stretch) | 70e72938e39b | PROPOSED |
| `controls/V2_RAIL_HOUSING.png` | 1545 × 85 | 260/20/260/20 | ChatGPT (§6b-13), trimmed; below 2× size (sharp at 1600×1000, soft at 4K) — upscale/regenerate later | 45ea00a91fe4 | PROPOSED |
| `crt/V2_CRT_GLASS.png` | 1448 × 1086 | — | ChatGPT (§6c-10); centre fully transparent overlay | ed89e5dd21e9 | PROPOSED |
| `crt/V2_CRT_LARGE.png` | 1415 × 1112 | — | ChatGPT (§6c-9); screen transparent | f9a3c33bf1a8 | PROPOSED |
| `crt/V2_CRT_SMALL.png` | 1535 × 990 | — | ChatGPT (§6c-8), trimmed; screen transparent, dark inner shadow | 735d83e5d0d7 | PROPOSED |
| `controls/V2_METER_RACK.png` | 1334 × 1161 | — | ChatGPT (§6c-11), trimmed | e2825186225b | PROPOSED |
| `controls/V2_METER_ROW.png` | 2145 × 367 | 100/30/330/30 | ChatGPT (§6c-12, icon-first prompt), trimmed; baked 11-segment dividers removed by Claude Code so the engine draws per-meter segment counts | 322da8ebf468 | PROPOSED |
| `controls/V2_NOTE_CARD.png` | 1823 × 799 | — | ChatGPT (§6c-13), trimmed; blank paper for stamped effect icons | 3d9e45d9ed17 | PROPOSED |
| `controls/V2_TRAY.png` | 2159 × 617 | 140/120/140/150 | ChatGPT (§6d-1), trimmed; plain felt bed, brass lip and end caps | eccb431519ae | PROPOSED |
| `controls/V2_COUNTER_STACK.png` | 1036 × 1303 | — | ChatGPT (§6d-2, icon-first prompt), trimmed; three rows of icon socket + number window | 78be5faea35b | PROPOSED |
| `icons/V2_ICON_DECK_LIGHT.png` | 128 × 128 | — | Claude Code: flat ivory stack of three cards with HuCard contact ticks; designer approved 2026-11-26 | 89e2537895f5 | APPROVED (icon design) |
| `icons/V2_ICON_DISCARD_LIGHT.png` | 128 × 128 | — | Claude Code: flat ivory card dropping into a tray; designer approved 2026-11-26 | b18e60fdec0a | APPROVED (icon design) |
| `icons/V2_ICON_BURNED_LIGHT.png` | 128 × 128 | — | Claude Code: flat ivory card with top-right corner burned away and flames along the edge; designer approved 2026-11-26 | 033fe1d51341 | APPROVED (icon design) |
| `chassis/V2_CHASSIS_TILE.png` | 1254 × 1254 | tile | ChatGPT (§6d-6); seamless (seams checked) | d2637555254d | PROPOSED |
| `controls/V2_PIPE_V.png` | 112 × 664 | tile (vertical) | ChatGPT (§6d-7); trimmed, re-cut to a repeating section and cross-faded by Claude Code (original top/bottom did not match) | 2d49842742af | PROPOSED |

Conversation 1 (§6b) complete. Conversation 2 (§6c) complete (13 parts). Conversation 3 (§6d): part 1 (tray) delivered; counter stack housing delivered (icons: V2_ICON_DECK_LIGHT, V2_ICON_DISCARD_LIGHT, V2_ICON_BURNED_LIGHT), chassis tile and pipes to come. END TURN dome and lamp bar dropped (ARCH-V2-003m). All housings are blank; what the game places in them is icon-first per spec §2a (UI-BIBLE-001, ARCH-V2-003).
