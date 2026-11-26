# Architecture V2 painted asset manifest (VAS-ASSET-001)

Parts for the VAS-001 encounter screen, per [`docs/architecture-v2/VAS-001_ASSET_SPEC.md`](../../../docs/architecture-v2/VAS-001_ASSET_SPEC.md). Generated images are not editable sources. Nine-slice margins are in this file's pixels (L/T/R/B). Approval: only the designer approves the final look (ARCH-V2-003); "accepted" in chat (2026-11-26) means the part passed the spec checks and is in use, not that the look is final.

| File | Size | Nine-slice | Source / provenance | SHA-256 (12) | State |
|---|---|---|---|---|---|
| `chassis/V2_ENCLOSURE_BACK.png` | 1254 × 1254 | tile | ChatGPT (§6b-2) | 455ebf0538eb | PROPOSED |
| `chassis/V2_ENCLOSURE_FRAME.png` | 1971 × 798 | 120/120/120/120 | ChatGPT (designer prompt, VAS-ASSET-001 §6b-1) | 674802666177 | PROPOSED |
| `ice/V2_ICE_WINDOW.png` | 1619 × 971 | 96/96/96/96 | ChatGPT (§6b-3) | 0ed97934af15 | PROPOSED |
| `ice/V2_KEY_BED.png` | 2138 × 506 | 60/60/60/60 | ChatGPT (§6b-12), trimmed; wider than spec (stretches); inset shadow added in engine | 4d33816e13f3 | PROPOSED |
| `ice/V2_MEDALLION_FORTRESS.png` | 1212 × 1214 | — | ChatGPT (§6b-8), trimmed | afb8f586fd48 | PROPOSED |
| `ice/V2_MEDALLION_STR.png` | 1212 × 1214 | — | Claude Code: FORTRESS rim + dark enamel face (ChatGPT STR rim did not match) | 2cf9cf5f7b4d | PROPOSED |
| `ice/V2_MEDALLION_TUMBLER.png` | 1212 × 1214 | — | Claude Code: FORTRESS rim + teal face + drawn combination-dial icon (designer chose dial 2026-11-26) | 15ae92ac4f15 | PROPOSED |
| `ice/V2_MEDALLION_VOID.png` | 1212 × 1214 | — | Claude Code: FORTRESS rim + violet face + drawn surveillance-lens icon (designer 2026-11-26) | 329b7afc8874 | PROPOSED |
| `ice/V2_NAMEPLATE.png` | 2125 × 418 | 200/80/200/80 | ChatGPT (§6b-6), transparent padding trimmed | 17359fe5f8b1 | PROPOSED |
| `ice/V2_PORTRAIT_FRAME.png` | 1254 × 1254 | 80/80/80/80 | ChatGPT (§6b-5) | d5ec93a15771 | PROPOSED |
| `ice/V2_STATUS_STRIP.png` | 1603 × 90 | 90/20/50/20 | ChatGPT (§6b-11), trimmed | b5531f17f49f | PROPOSED |
| `controls/V2_RAIL_ARROW.png` | 813 × 1078 | — | ChatGPT (§6b-16), trimmed | 1ee9bcdfeaa4 | PROPOSED |
| `controls/V2_RAIL_CAPSULE.png` | 2150 × 332 | 170/40/170/40 | ChatGPT (§6b-14), trimmed; longer than spec (round ends stretch) | 70e72938e39b | PROPOSED |
| `controls/V2_RAIL_HOUSING.png` | 1545 × 85 | 260/20/260/20 | ChatGPT (§6b-13), trimmed; below 2× size (sharp at 1600×1000, soft at 4K) — upscale/regenerate later | 45ea00a91fe4 | PROPOSED |

Conversation 1 (§6b) complete: parts 1–3, 5–14 and 16 delivered; part 4 (hover window) and part 15 (lit capsule) are made in the engine for exact alignment; parts 9–10 built by Claude Code. Next: conversation 2 (§6c, header and left rail).
