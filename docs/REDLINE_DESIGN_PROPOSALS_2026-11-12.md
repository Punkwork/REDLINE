# REDLINE — Design Proposals from Deckbuilder Mechanics Review
**Date:** 2026-11-12
**Status of every item in this document:** **PROPOSED** — none of these are approved, locked, or implemented. They are offered for one-at-a-time review under the normal governance process (Master Design §12).
**Reviewed against:** `REDLINE_MASTER_DESIGN.md` (through TRAINING-NODE-PLAYTEST-LOCK-001), `REDLINE_CURRENT_STATUS.md`, `REDLINE_BIBLE.md`, `PANOPTICON_CORE_DESIGN_AND_WORLDBUILDING.md`.
**Source of ideas:** A design discussion adapting mechanics from the *Clank!* deckbuilding family (push-your-luck noise, escalating danger, escape timing) to a single-player Icepick-versus-ICE roguelike.

> **Preservation rule:** Nothing here overrides a LOCKED decision. Where a proposal touches a locked rule, the conflict is stated explicitly and the proposal is written to fit around it. TRAINING-NODE-PLAYTEST-LOCK-001 freezes the Training Node for playtesting; proposals that would change Training Node values are deferred until after that playtest.

---

## 0. Summary

REDLINE already contains several of the strongest ideas from that genre — often in a more refined form:

| Idea from the review | Already in REDLINE as | Assessment |
|---|---|---|
| Go deeper for better loot, at more risk | Finite per-layer CRED reserves scaled to difficulty (ECON-002, TRAINING-CRED-SCALE-001), Extractor payout profiles (ECON-003) | **Already present** — keep |
| Loot you keep even if things go wrong later | Immediate CRED banking (EXTRACT-001) | **Already present** |
| Bonus for a complete job | Full-extraction bonus (NODE-EXTRACTION-002) | **Already present** |
| Danger that persists and escalates | TRACE accumulates across Nodes within a Corporation (TRACE-002) | **Already present** |
| Single-use tools outside the deck | CAPS (TAX-005) | **Already present** |
| Corporation-inserted junk cards | Bloatware (§42) | **Already present** |
| A limited rig | RAM 4 (TAX-011) | **Already present** |

The review's best ideas therefore land in places the documents explicitly mark **OPEN**:

| # | Proposal | Fills OPEN item | Priority |
|---|---|---|---|
| P-01 | 100% TRACE **strike ladder** | TRACE-004 | **High** |
| P-02 | **Rustler-side TRACE costs** and TRACE-conditional payoffs | TRACE-001 (card-checked thresholds) | **High** |
| P-03 | **Specialty-plus-fallback** starter decks for non-Generalist Rustlers | PANOPTICON §8 (ECHO, VECTOR, other archetypes) | **High** |
| P-04 | **Layer-boundary decision point** and JACK OUT reconciliation | JACK OUT vs RUN-003 conflict (TAX-005) | **High** |
| P-05 | **Node-wide supporting defences** that persist across layers | ARCH-001, PANOPTICON §6 | Medium |
| P-06 | **Telegraphed adaptive Corporation** that patterns Icepick use | MECH-SURV-001 | Medium |
| P-07 | **Ghostware as Central Node prize**, including Ghostware with drawbacks | Ghostware catalog (VERIFY) | Medium |
| P-08 | **Deck thinning × Bloatware** encounter design | Bloatware specifics (§42 OPEN) | Medium |
| P-09 | **Black Market Uplink** reserve + rotating stock | RUN-005 (Uplink goods OPEN) | Medium |
| P-10 | **Clean BREACH** bonus | — (new, small) | Low |
| P-11 | Terminology consistency and originality cautions | PANOPTICON §10 P0 audit | **Housekeeping** |

Section 12 lists review ideas that **do not fit** REDLINE's locked rules and should not be adopted.

---

## P-01 — 100% TRACE strike ladder
**Fills:** TRACE-004 (100% countermeasures TBD).
**Respects:** TRACE-001 (100% is *not* automatic defeat; 50% is warning-only), TRACE-002/003 (Corporation-scoped meter), RUSTLER-STARTING-RESOURCES-001 (40-point capacity), Bible JACK OUT/LOCKDOWN canon.

**Problem:** A single fixed 100% consequence either feels toothless or run-ending. Players also need a reason to care about the *second* time they hit 100%.

**Proposal:** Each time TRACE reaches 100% against the current Corporation, the Corporation logs a **STRIKE**. Consequences escalate per strike, and the meter falls back so play continues.

| Strike | Corporation countermeasure (location compromised) | TRACE after |
|---|---|---|
| **1st** | Insert one **tracer Bloatware** card (name OPEN) into the Rustler's draw pile for the rest of the Node. | Set to 50% (20 points) |
| **2nd** | **Black ICE** joins the current encounter (or the next one, if BREACHED) as a supporting ICE in the left-most position, keeping the main ICE right-most (MULTI-ICE-002). | Set to 50% |
| **3rd** | **LOCKDOWN** for the rest of the current Node (JACK OUT CAPS cannot function, per Bible canon), plus the 2nd-strike countermeasure. | Set to 25% (10 points) |

**Why it works:**
- It escalates without ever declaring defeat, which TRACE-001 requires.
- It reuses existing vocabulary (Bloatware, Black ICE, LOCKDOWN) rather than inventing new systems.
- Strikes reset with the Corporation (TRACE-002/003), so each Corporation is a fresh tension arc.
- It gives DEAD DROP's WIPE TRAIL (−20 TRACE) and GHOST SIGNAL more strategic value: avoiding a strike becomes a goal.

**Open questions to decide one at a time:** whether TRACE reduction after 100% is the right reset model (TRACE-001 leaves this OPEN); strike persistence across Nodes within a Corporation (recommended: yes); exact Black ICE profile; the tracer Bloatware's effect; whether Ghostware can mitigate strikes.

---

## P-02 — Rustler-side TRACE costs and TRACE-conditional payoffs
**Fills:** design space explicitly permitted by TRACE-001 ("other explicitly printed effects" may add TRACE; printed effects may check "while TRACE is at or above 50%").
**Respects:** TRACE-001 Option C — no *automatic* threshold effects; only card-printed checks.

**Problem:** Currently TRACE is applied almost entirely by the Corporation. The Rustler's only TRACE decisions are defensive (GHOST SIGNAL, WIPE TRAIL). There is no *loud versus quiet* choice in the Rustler's own card play.

**Proposal:** Give some Rustler cards a printed TRACE cost alongside BW, creating a second cost axis.
- **Loud EXPLOIT cards:** cheaper or stronger, but add TRACE to the Rustler. *Illustrative only:* a PROBE variant that costs 0 BW but adds 3 TRACE.
- **Quiet CLOAK cards:** more BW-expensive, no TRACE.
- **TRACE-conditional payoffs** (permitted by TRACE-001): *illustrative only* — "While TRACE is at or above 50%, this Icepick gains +1 breaking Strength." This creates a deliberate *aggressive* archetype that thrives near the warning mark.

**Why it works:** Every card decision becomes "BW now versus TRACE later." Combined with P-01, players manage a run-long risk budget. It also gives the stealth and aggressive-breaking archetypes in PANOPTICON §8 distinct mechanical identities.

**Interaction to watch:** WATCHDOG already punishes CLOAK plays (CARD-SUBTYPE-001). Quiet play should not be punished from both sides at once — test CLOAK cost curves against CLOAK-reactive ICE.

---

## P-03 — Specialty-plus-fallback starter decks for future Rustlers
**Fills:** PANOPTICON §8 (distinct starting decks; ECHO and VECTOR proposed; stealth, hardware-engineering, aggressive-breaking archetypes brainstormed).
**Respects:** GENERALIST-STARTER-LOCK-001 — **the Generalist keeps one Icepick of each type.** That is correct for a *generalist*.

**Problem:** One Icepick per ICE type works for the Generalist but would make every Rustler play the same way. Analysis of a 12-card deck with DRAW 5:
- Chance a *specific* card is in the opening hand: 5/12 ≈ **42%**.
- Chance of *at least one* of three Icepicks: ≈ **84%** — but often the *wrong type* for the ICE present.
- Three 1-BW installs plus boosts consume much of a 4-BW turn, and three installs leave the draw cycle, thinning the deck faster (see P-08).

**Proposal:** For non-Generalist Rustlers, use:
1. **One signature Icepick** for the Rustler's specialty type, stronger than the Generalist's.
2. **One fallback Packet** that can break a subroutine on **any** ICE type at a premium cost — BW plus TRACE (ties into P-02). *Illustrative only:* "1 BW, +3 TRACE: break one subroutine on any ICE whose current Strength is 2 or less."
3. The remaining ICE types are the Rustler's **weakness**, to be covered by acquisitions during the run.

**Why it works:**
- Each Rustler feels different from the first draw.
- No dead ends: the fallback means a run never becomes unwinnable against an off-type ICE.
- Finding an off-type Icepick at a Black Market Uplink becomes an exciting moment.
- If Node ICE types are ever revealed on the map (RUN-005 currently makes contents hidden), weaknesses would make route choice matter. That visibility question remains OPEN.

**Archetype sketch (illustrative, not a roster):**

| Archetype | Signature Icepick | Weakness | Identity |
|---|---|---|---|
| Stealth (CLOAK) | CODE GATE | SENTRY | Low TRACE, expensive quiet cards |
| Aggressive breaker (EXPLOIT) | WALL | CODE GATE | Loud cards, TRACE-conditional payoffs (P-02) |
| Hardware engineer | One multi-type Executable at higher break cost | None, but slow | RAM-granting Hardware (TAX-008) |
| VECTOR (viruses) | SENTRY | WALL | Virus subtype (rules OPEN) |

**Timing:** Defer until after the Training Node playtest; it does not affect the Generalist or Training Node values.

---

## P-04 — Layer-boundary decision point and JACK OUT reconciliation
**Fills:** the documented "unresolved conflict" between JACK OUT (retreats to the preceding junction) and RUN-003 forward-only traversal (TAX-005, Bible §4).
**Respects:** EXTRACT-001 immediate banking; RUN-003/004; Bible JACK OUT canon (consumes the CAP, no BW, no node-completion rewards, reduces TRACE, no Vitae or VOID recovery).

**Observation:** Because Extractor CRED is banked immediately, REDLINE already has half of a push-your-luck loop: CRED earned in Layer 1 is safe. What is missing is an explicit **"stop here"** choice between layers.

**Proposal:** After each BREACHED layer except the last, present a decision: **continue to the next layer**, or **use a JACK OUT CAP**. Resolve the backward-movement conflict with one of two options for the designer to choose:
- **Option A (forward exit):** JACK OUT exits the Node *forward* to its onward junction choices, forfeiting Node-completion rewards. Preserves RUN-003 exactly.
- **Option B (keep retreat, mark exception):** retain the canonical retreat to the preceding junction as an explicitly approved, CAP-specific exception to RUN-003, and specify how a "fully reset" abandoned Node is presented when its route is chosen again.

**Recommended: Option A.** It keeps forward-only intact and makes JACK OUT a *push-your-luck* tool ("take my banked CRED and leave") rather than a rewind.

**Why it works:** Layers 2 and 3 offer larger reserves (10 / 15 / 25 in Training), and installed Icepicks persist through the Node (TAX-007), so pushing on is attractive. But TRACE, VOID and Vitae damage also carry forward. The player weighs sunk setup against accumulated risk at every boundary.

---

## P-05 — Node-wide supporting defences that persist across layers
**Fills:** ARCH-001 (support systems may be layer-local or node-wide; lifecycle OPEN), PANOPTICON §6 examples (repair daemon, bandwidth throttler, corruption injector).

**Problem:** The Rustler's setup persists across layers (Icepicks, Hardware, CACHE), but the Corporation's defences reset per encounter. Only one side builds up.

**Proposal:** Define a **node-wide support** lifecycle: a support effect that is not neutralized in one layer **carries into the next layer of the same Node**, visibly displayed. Neutralizing it ends it for the whole Node.
- *Illustrative only:* a **repair daemon** that restores 1 STR to one ICE each Corporation turn until broken; if it survives Layer 1, it is present in Layer 2.
- Mirrors existing Rustler persistence, so both sides escalate within a Node.
- Creates a real decision: break the support now (costly) or push for BREACH and inherit it.

**Constraints:** Must be telegraphed (PANOPTICON §3: "legible and fair"); must not alter MULTI-ICE-002 ordering for ICE subroutines; must end at Node end, like Bloatware.

---

## P-06 — Telegraphed adaptive Corporation
**Fills:** MECH-SURV-001 (systems may observe Rustler patterns and adapt; prefer telegraphed counterplay; **no separate Observation meter**).

**Proposal:** The Corporation logs which **Icepick type** the Rustler breaks with most in the current Node. Once a threshold is reached, later layers' ICE of that type gain a small, visible adjustment.
- *Illustrative only:* after 3 subroutine breaks with WALL Icepicks in a Node, subsequent WALL ICE in that Node gain +1 STR. UI shows a "PATTERN LOGGED" marker on the relevant ICE type.
- No meter — a simple per-Node counter shown on the ICE inspection bay, satisfying MECH-SURV-001.
- Resets at Node end.

**Why it works:** It expresses the PANOPTICON theme (being watched changes your behaviour) mechanically and rewards varied Icepick use without punishing it arbitrarily.

---

## P-07 — Ghostware as the Central Node prize, with cost-bearing Ghostware
**Fills:** Ghostware catalog (VERIFY); NODE-CORE-001 rewards (OPEN).

**Proposal:**
1. Make **Ghostware the signature reward of a Corporation's Central Node**, so each Corporation climax yields a permanent, run-defining upgrade.
2. Include some **Ghostware with drawbacks**, so a choice between Ghostware is a real decision. *Illustrative only:* "+1 BW on the first turn of every ICE encounter; TRACE starts at 10 points against each new Corporation."
3. Optionally, **taking Ghostware raises TRACE** against the current Corporation, echoing how stealing treasure angers the guardian. This only matters if Ghostware can be found *before* the Central Node.

**Respects:** Ghostware remains permanent and non-card (PROG-003); ORIGIN signature display (UI-002); RUN-007 carry-forward.

---

## P-08 — Deck thinning × Bloatware encounter design
**Fills:** Bloatware specifics (§42 OPEN).
**Respects:** TAX-018/019 (installed cards leave the draw cycle until Node end); TAX-011/012 (unloaded Software goes to discard, **never directly to hand**).

**Observation:** Installed Executables leave the draw cycle for the whole Node. A Rustler with four Executables installed draws from a deck of eight. Any Bloatware inserted early in a Node therefore appears *more often* in later layers.

**Proposal:** Treat this as a deliberate design lever rather than a side effect.
- Layer 1 ICE that insert Bloatware become a long-term threat in Layers 2–3.
- Rustler cards can reward or exploit thinning. *Illustrative only:* an Executable that grants a bonus "while your draw pile has 6 or fewer cards."
- Do **not** design "return an installed card to hand" effects; that conflicts with TAX-011/012.

---

## P-09 — Black Market Uplink: fixed reserve stock plus rotating stock
**Fills:** RUN-005 (Uplink goods, costs and timing OPEN).

**Proposal:** Each Uplink has two parts:
- **Reserve stock**, always available: basic cards every Rustler can rely on (e.g., a PROBE-like Packet, a PULP Shield-like Packet) and CAPS including JACK OUT. This guarantees no Uplink visit is wasted.
- **Rotating stock:** a random selection of stronger cards, off-type Icepicks (important for P-03) and Hardware.
- *Optional:* refreshing the rotating stock costs CRED, adds TRACE, or both, so shopping is not risk-free.

**Respects:** TAX-020 (no deck reshuffle at service Nodes); CAPS outside the deck (TAX-005). Bible WL-002's dealer dialogue fits this space.

---

## P-10 — Clean BREACH bonus
**Complements:** NODE-EXTRACTION-002.

**Proposal:** If a Node is completed with **no TRACE gained** during it, award a small bonus (CRED, or a TRACE reduction carried forward). This gives quiet play a reward that is visible at Node end, balancing P-02's loud payoffs.

---

## P-11 — Housekeeping: terminology consistency and originality
**Supports:** PANOPTICON §10 P0 (documentation audit), ORIG-001 (originality review).

1. **Inconsistent rules terminology across documents.** The Master Design's rules use **Rustler** and **Icepick**, but the copied rule sections in `REDLINE_BIBLE.md`, `REDLINE_CURRENT_STATUS.md` and `PANOPTICON_CORE_DESIGN_AND_WORLDBUILDING.md` say **Runner** and **ICEbreaker** (e.g., their GENERALIST-001 copies). "Runner" also appears as world/slang vocabulary in the Bible, which may be intentional. Recommend confirming the canonical *rules* terms and doing one pass over the copied rule sections, so implementation agents do not treat Icepick and ICEbreaker as different card types.
2. **Avoid importing Android: Netrunner breaker names.** Do not adopt *Fracter*, *Decoder* or *Killer* as Icepick classes; keep WALL / CODE GATE / SENTRY Icepicks. This supports ORIG-001.
3. **Generic genre mechanics are fine; names are not.** Push-your-luck extraction, escalating danger and escape timing are common to the genre. Do not borrow names or terms from *Clank!* (e.g., "Mastery," "Dragon Attack," "Rage Track").

---

## 12. Review ideas that do NOT fit REDLINE

| Idea | Conflict | Recommendation |
|---|---|---|
| A shared noise **bag** drawn at random | REDLINE uses a deterministic TRACE meter (TRACE-001). | Do not adopt. P-01 and P-02 deliver the same tension through the meter. |
| Automatic effects at 25% / 75% TRACE | TRACE-001 Option C: thresholds cause **no automatic effects**; only printed card checks. | Recast as card-printed conditions (P-02). |
| "Play every card, no energy" | BW 4 per turn is locked; END TURN is voluntary (RULE-RT-001). | Do not adopt. |
| Breakers returning to hand mid-Node | Unloaded Software goes to discard (TAX-011/012). | Do not adopt; see P-08. |
| Rustler-built "glitch" cards in starter decks | Bloatware is defined as Corporation-inserted and Node-limited (§42); the Generalist deck is locked with 0 Bloatware. | Only consider as a separate, non-Bloatware card category for future Rustlers, if at all. |
| Changing Training Node values | TRAINING-NODE-PLAYTEST-LOCK-001 | Defer all balance changes until after the playtest. |

---

## 13. Suggested review order

Following the project's one-question-at-a-time process:

1. **P-01** (TRACE strike ladder) — fills TRACE-004, the most impactful open item.
2. **P-04** (JACK OUT forward exit) — resolves a documented canon conflict.
3. **P-02** (Rustler TRACE costs) — needed before designing non-Generalist decks.
4. **P-03** (specialty-plus-fallback Rustlers) — after the Training Node playtest.
5. **P-05** and **P-06** (node-wide supports; adaptive Corporation) — together, as Corporation-side systems.
6. **P-07**, **P-08**, **P-09**, **P-10** — content and economy, after the core systems above.
7. **P-11** — terminology pass at any time; no design approval needed beyond confirming canonical terms.

Each approved item should receive a permanent decision ID, status, rationale and test expectation in the Master Design, per §12.
