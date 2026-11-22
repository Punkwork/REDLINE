# PANOPTICON — ICE effects and learning order (EFFECTS-001)
**Date:** 2026-11-21 · **Status:** table requested by the designer; the learning order is **PROPOSED** (Claude) for the designer to approve.

Every subroutine effect and ICE mechanic in one place. **Order** is the sequence in which a player meets each one, **one new thing per encounter**, so they learn by playing. With the MAP-003 structure (7–8 ICE Nodes plus a boss per corporation, `REDLINE_MASTER_DESIGN.md`), HALCYON has room to teach the core set, IRONWATCH the advanced set, and LUCIDA the expert set.

**Complexity:** 1 = read once and understood · 2 = needs one encounter to learn · 3 = changes how you plan a turn · 4 = interacts with other rules or other ICE.

## Subroutine effects

| Order | Effect | What it does | Complexity | Primary ICE type | Player's answer | Status |
|---:|---|---|:-:|---|---|---|
| 1 | **PULP X** | Take X damage: SHIELD first, then VITAE. | 1 | FORTRESS | SHIELD cards, breaking it | In build |
| 1 | **DEADLOCK** | Does nothing, but blocks BREACH until broken. Every main ICE has one. | 1 | All | Break it to BREACH | In build |
| 2 | **TRACE X** | Add X to the TRACE meter (strikes at 40). | 1 | TUMBLER | SCRUB, GHOST SIGNAL, PROXY CHAIN, breaking it | In build |
| 3 | **Two effects (⊕)** | One subroutine does two things, e.g. PULP 2 + TRACE 2; one break stops both. | 2 | All | Break it first | In build |
| 4 | **INSERT SPAM** | Put SPAM Bloatware into your draw or discard pile (pay 1 BW to clear it from hand). | 2 | TUMBLER | SPAM FILTER, UNINSTALLER | In build |
| 5 | **DEADLOCK ×2** | A DEADLOCK that needs two breaks (shown 1/2). | 2 | FORTRESS | Plan two breaks | In build |
| 6 | **HARDEN X** | This ICE gains X STR for the encounter. | 2 | FORTRESS | Break it early, or PROBE again | In build |
| 7 | **DISCARD X** | Discard X cards of your choice from the hand you'll play next. | 2 | TUMBLER | Keep spare cards; CACHE | In build |
| 8 | **−X BW** | You have X less BW next turn. | 2 | TUMBLER (DETAINER) | BURST; break it first | In build |
| 9 | **SHIELD BREAK** | Your SHIELD drops to 0 when it fires; PULP after it hits in full. | 3 | FORTRESS | Break it, or break the PULP after it | In build |
| 10 | **CORTEX X** | Gain X CORTEX: −1 DRAW each, until the next corporation. | 3 | VOID | CORTEX BUFFER, FAILSAFE | In build |
| 11 | **TRACE X ▸ effect** | The effect after ▸ happens only if some of that TRACE lands. | 3 | TUMBLER, VOID | JAMMER, GHOST SIGNAL, PROXY CHAIN | In build |
| 12 | **RETALIATE X** | PULP X for each subroutine already broken on this ICE. | 3 | FORTRESS | Break it before chipping; finish the ICE | In build |
| 13 | **AMEND X** | This response, the ICE to its right deals +X on each PULP subroutine. | 4 | TUMBLER (support) | Break AMEND when it shows | In build |
| 14 | **FORGET X** | X random cards in hand go to the bottom of your draw pile. | 3 | LUCIDA ICE | CACHE | Designed, not in the core-loop build |

## ICE mechanics (not subroutines, also taught in order)

| Order | Mechanic | What it does | Complexity | Type | Status |
|---:|---|---|:-:|---|---|
| 1 | **TUMBLER rotation** | Only subroutines in the slots act; the pool rotates each turn; a break tumbles the next one in at once. | 2 | TUMBLER | In build |
| 1 | **Parting shot** | At BREACH, every unbroken showing subroutine fires once. | 2 | All | In build |
| 5 | **FORTRESS** | Everything visible, fires every turn, highest STR. | 1 | FORTRESS | In build |
| 10 | **VOID face-down** | Subroutines hidden until they fire or a PROBE reveals them. | 2 | VOID | In build |
| 8 | **WARY / LETHAL forms** | Below half STR: WARY. Also half its subroutines broken: LETHAL, PULP and TRACE double. | 3 | All (Black ICE: look only) | In build |
| — | **Black ICE** | Joins at the 2nd TRACE strike; no DEADLOCK. | 2 | VOID | In build |

**Teaching rule:** an encounter introduces at most **one** row the player hasn't seen. The core-loop slice breaks this rule today (four rows introduce about ten effects); the MAP-003 corporation map spreads them out.

**Proposed sequence.** HALCYON (Opening + 7 ICE Nodes + boss): 1 Opening: PULP, DEADLOCK, TUMBLER rotation, parting shot (the core set, taught together) → 2 TRACE → 3 two-effect subroutine → 4 INSERT SPAM → 5 FORTRESS with DEADLOCK ×2 → 6 HARDEN → 7 DISCARD → 8 −BW, with a layer built to make the LETHAL form likely → boss THE HEARTH: SHIELD BREAK as its one new effect. IRONWATCH: VOID face-down, CORTEX, TRACE ▸ riders, RETALIATE, AMEND, one per Node. LUCIDA: FORGET, then combinations. A random extra ICE Node (MAP-003) only uses effects already taught.
