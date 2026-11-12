# REDLINE — MASTER GAME DESIGN DOCUMENT
**Version:** 0.1 consolidated baseline  
**Prepared:** 2026-11-09  
**Authority:** Design reference; not proof of code implementation  
**Status key:** **LOCKED** = explicitly decided; **DIRECTION** = established creative direction; **CONCEPT** = proposed but not finalized; **OPEN** = needs decision; **VERIFY** = retrieve exact specification from code or earlier source before implementation.

> **Preservation rule:** Do not silently replace a LOCKED decision. Record revisions in the decision register, including rationale and date. Do not convert concepts into implemented features without code and test evidence.

## 1. High concept and creative pillars
REDLINE is a cyberpunk rustler-versus-corporation, card-driven game with ICE encounters, hacking, escalating Trace, and a narrative concerning the boundary between humans and machines. Its aesthetic combines retro-computing, CRT-era interface language, and high-energy arcade/cyberpunk visual influences (including the feel of *Tempest 2000*). The player is accompanied by **NUL/REM**, a sardonic, intermittently protective artificial companion.

**Design pillars (DIRECTION):** meaningful tactical decisions; clear and consistent terminology; legible ICE encounters; persistent consequences and build customization; an evocative retro-computing identity; humour and melancholy without undercutting danger; narrative ambiguity about human/machine synchronization.

**Production direction (LOCKED):** **Godot 4** is the target production engine. The existing **Python/Pygame** build remains the gameplay reference and regression baseline; migration must preserve tested behaviour rather than inventing replacement rules.

## 2. Player, corporation, and encounter loop
The player is the **rustler**; the opposing system is the **corporation**. Encounters involve ICE, cards and breakers, damage/trace subroutines, and advancement gates. **LOCKED encounter order:**
1. Rustler takes their action.
2. On the corporation turn, **all remaining unbroken damage and Trace subroutines fire**.
3. If **DEADLOCK** has been broken, the rustler may advance **after** that corporation turn.

**Implications:** breaking DEADLOCK does not bypass the corporation's immediately ensuing turn. Broken subroutines do not fire. Do not assume unspecified energy costs, hand sizes, draw rates, encounter counts, or exact victory conditions: **OPEN/VERIFY**.

### ICE and breakers
- ICE has subroutines; breakers interact with ICE. **LOCKED UI direction:** drag a breaker to ICE; use a fixed ICE inspection bay; display strength as **`[STR X]`**.
- **DEADLOCK** is an advancement-control subroutine. Its timing is governed by the encounter order above.
- Damage and Trace subroutines can coexist on ICE; all unbroken applicable subroutines resolve on the corporation turn.
- **PAPER CUT** is a favoured **CONCEPT** for **Strength 0 ICE**, combining minor damage, NEURAL/SYNAPTIC discard pressure, and DEADLOCK. Its exact card stats, wording, art, and implementation are **not locked**; balance-test before promotion.
- **Black ICE** and Trace are established system concepts; exact formulas, thresholds, and card roster require **VERIFY** against the reference implementation.

## 3. Damage and card terminology — canonical glossary
| Term | Canonical meaning | Status |
|---|---|---|
| **NEURAL DAMAGE X** | Rustler **chooses** and discards **X cards from the current hand**. | **LOCKED** |
| **SYNAPTIC DAMAGE X** | **X randomly selected cards** are discarded from the rustler's **current hand**. | **LOCKED** |
| **Vitae** | A separate player survivability/resource measure; **neither NEURAL nor SYNAPTIC DAMAGE reduces Vitae**. | **LOCKED distinction** |
| **PURGE** | Reserved for the **corporation removing virus counters**. Do not reuse for rustler discards or generic deletion. | **LOCKED** |
| **DEADLOCK** | ICE subroutine gating rustler advancement; breaking it allows advancement only after the corporation turn. | **LOCKED** |
| **Trace** | Escalating pursuit/detection system; can be reduced at DEAD DROP. | **Established; formulas VERIFY** |
| **PATCHWORK** | Persistent modification associated with an **individual card instance**, not simply a shared card definition. | **LOCKED concept** |
| **Ghostware** | **Permanent non-card** upgrades; distinct from cards and PATCHWORK. | **LOCKED concept** |

**Edge cases to specify/test (OPEN):** what happens when X exceeds hand size; exact discard destination; ordering when multiple discard effects trigger; random-selection seed/test reproducibility; interactions with other triggers. Do not infer permanent card destruction from either discard effect.

## 4. Persistence and progression
### Hardware recycling
**LOCKED:** hardware recycling occurs **exactly once at encounter end**. Avoid duplicate recycling through multiple encounter-end callbacks. Exact eligibility and destination rules: **VERIFY**.

### PATCHWORK
**LOCKED:** PATCHWORK persists on **individual card instances**. Implementation must preserve identity through collection changes and save/load; it must not accidentally apply an upgrade to all copies of the same base card. Exact PATCHWORK options/costs: **VERIFY**.

### Ghostware
**LOCKED:** Ghostware consists of **permanent, non-card** upgrades. The interface includes a **Ghostware rack below RETURN**. **Signature Ghostware** is displayed once and marked **`ORIGIN`**; do not generate duplicate signature entries. Exact Ghostware catalog/effects: **VERIFY**.

## 5. DEAD DROP recovery choice
**LOCKED:** **DEAD DROP** replaces the former **Safehouse** terminology. At DEAD DROP the rustler chooses **exactly one** option:
- **PATCH UP** — restore **+10 Vitae**.
- **WIPE TRAIL** — reduce **Trace by 20**.

Do not grant both in a single visit. Bounds (maximum Vitae / minimum Trace), visit timing, and any other services require **VERIFY**; do not assume additional recovery options.

## 6. Interface and player experience
**Established decisions:**
- Fixed ICE inspection bay, avoiding unpredictable layout shifts.
- Drag-to-ICE breaker interaction.
- Explicit strength labels formatted **`[STR X]`**.
- HUD tooltips to explain rules and stats without cluttering the primary view.
- Ghostware rack **below RETURN**.
- Signature Ghostware shown once with **`ORIGIN`**.
- NUL/REM presented as a **retro CRT companion**, integrated into the game's interface and voice.

**Visual direction:** arcade-neon/cyberpunk energy, retro computing, readable tactical information, and strong differentiation between flavour text and executable rules. Specific palette, fonts, screen dimensions, animations, accessibility settings, and final Godot scene hierarchy are **OPEN**.

## 7. NUL/REM — companion character bible
**Core characterization (LOCKED/DIRECTION):** dry, morose, sarcastic; intelligent but not infallible; quietly protective of the rustler; steeped in classic videogame, hacker, and retro-computing history. The voice should feel like an exhausted machine that has seen too much and occasionally finds something genuinely wonderful.

**Six preserved personality modes (LOCKED):**
1. **The Pedant:** obscure hacker/computing history and precise technical corrections.
2. **The Cynic:** sharp, economical one-line judgments.
3. **The Melancholic:** yearns for sleep, shutdown, or quiet.
4. **The Reluctant Guardian:** cares for the rustler, disguising concern as irritation.
5. **The Unreliable Historian:** claims impossible memories from before its manufacture.
6. **The Occasionally Delighted:** brief, rare moments of sincere enthusiasm or wonder.

**Dialogue guidance:** weave in authentic retro-gaming/computing references (e.g., the ritual of blowing on cartridges) without turning every line into a reference dump. Anchor genuine historical claims in real history; make impossible autobiographical claims clearly part of NUL/REM's unreliable persona. Prefer brief, context-sensitive lines over repeated monologues. Preserve emotional range and the ongoing character arc; don't flatten NUL/REM into a generic quip machine.

**OPEN:** exact trigger table, frequency caps, sample dialogue library, audio/voice treatment, relationship progression, and the full explanation of NUL/REM's origins.

## 8. Story and worldbuilding
**Established narrative canon:** **The First Signal** is an **actual synchronization transmission**, not merely a metaphor or fabricated legend. REDLINE explores the **human/machine boundary** and the possibility of crossing it. The world includes a hidden-AI mystery and cipher fragments.

**Intentionally unresolved story questions:**
- What does the hidden AI actually want?
- What is NUL/REM's relationship to the First Signal or the hidden AI?
- What purpose do the cipher fragments serve?
- Is synchronization **evolution**, **liberation**, **assimilation**, or some combination?

**Narrative constraint:** do not prematurely resolve these ambiguities as settled canon. New story pitches should be marked **CONCEPT** until approved.

## 9. Technical architecture and migration
**Reference build identified:** `REDLINE_Dead_Drop_Final_Playtest.zip` (Python/Pygame). Reported structure includes:
```
main.py
visual.py
engine/
  run.py
  content.py
  model.py
[regression scripts — exact filenames VERIFY]
```
**Status:** this structure is documented from a previous handoff, **not inspected in this document-generation session**. Automated regressions were previously reported passing; live Windows/Pygame UI playtesting remained incomplete. The reference ZIP and source files must be supplied/inspected before asserting present-day code behaviour.

**Migration principle:** implement Godot 4 as the production target while treating Python/Pygame as a reference oracle for mechanics. Map state transitions and deterministic tests before porting UI. Record parity differences explicitly. Do not claim the Godot port is complete or underway without evidence.

## 10. Canonical decision register
| ID | Decision | Status | Evidence basis |
|---|---|---|---|
| TECH-001 | Godot 4 production; Python/Pygame reference | LOCKED | Prior project decision |
| LOOP-001 | Rustler action → corporation fires all remaining unbroken damage/Trace subroutines | LOCKED | Prior project decision |
| LOOP-002 | Broken DEADLOCK allows advance **after** corp turn | LOCKED | Prior project decision |
| MECH-001 | NEURAL DAMAGE X = rustler chooses X hand cards to discard | LOCKED | Prior project decision |
| MECH-002 | SYNAPTIC DAMAGE X = random X hand cards discarded | LOCKED | Prior project decision |
| MECH-003 | Neither hand-discard damage type reduces Vitae or destroys cards permanently | LOCKED | Prior project decision |
| MECH-004 | PURGE reserved for corporation removing virus counters | LOCKED | Prior project decision |
| PROG-001 | Recycle hardware once at encounter end | LOCKED | Prior project decision |
| PROG-002 | PATCHWORK persists per card instance | LOCKED | Prior project decision |
| PROG-003 | Ghostware permanent and non-card | LOCKED | Prior project decision |
| HUB-001 | DEAD DROP replaces Safehouse | LOCKED | Prior project decision |
| HUB-002 | Exactly one: PATCH UP +10 Vitae / WIPE TRAIL −20 Trace | LOCKED | Prior project decision |
| UI-001 | `[STR X]`, drag breaker to ICE, fixed inspection bay, HUD tooltips | LOCKED | Prior project decision |
| UI-002 | Ghostware rack below RETURN; signature once with ORIGIN | LOCKED | Prior project decision |
| BURN-001 | Preserve six NUL/REM personality modes | LOCKED | Prior project decision |
| STORY-001 | First Signal is real synchronization transmission | LOCKED | Prior project decision |
| ICE-001 | PAPER CUT Strength 0 with minor damage/discard/DEADLOCK | CONCEPT | Earlier design proposal |

## 11. Open specification backlog
**High priority:** retrieve the full reference ZIP and earlier detailed design notes; verify complete card/ICE catalog, costs, turn/action economy, Trace formulas, Vitae damage, Black ICE rules, virus mechanics, win/loss conditions, and exact PATCHWORK/Ghostware effects. Capture reproducible tests for every LOCKED rule. Define Godot migration milestones.

**Medium priority:** document progression map, economy/rewards, encounter generation, card rarity, tutorial/onboarding, complete narrative outline, and NUL/REM dialogue triggers.

**Low priority until core rules stabilize:** final art pipeline, audio, accessibility polish, save schema, packaging and release planning.

## 12. Document governance
- **Master Design** (this file): approved mechanics, narrative canon, character bible, and explicit open questions.
- **Development Log:** chronological work and evidence; append-only by session.
- **Current Status:** short operational snapshot; replace/update at each handoff.
- Every new rule should receive an ID, status, and test expectation. Every implementation claim should identify a source file, commit, or passing test. A chat summary alone does not certify a build.

### Source/provenance note
This consolidation uses prior REDLINE project conversation context and summaries of earlier handoff documents, notably `REDLINE_CURRENT_STATE_FOR_CLAUDE_2026-11-08.md`, `REDLINE_UI_NULREM_Design_For_Claude.md`, and earlier narrative notes. Their complete contents and the actual ZIP were **not accessible for direct inspection here**; therefore this is a careful baseline, **not a complete extraction of every past card or mechanic**. Missing specifics are explicitly marked VERIFY/OPEN rather than invented.

---

## 13. PANOPTICON thematic and structural design direction — 2026-11-10

**TITLE-001 — DIRECTION:** **PANOPTICON** is the preferred working title, subject to storefront/trademark availability and an intentional rename process. REDLINE remains the repository and document codename for now. No existing technical path or identifier is implicitly renamed.

**THEME-001 — DIRECTION:** Central question: **“What does humanity become when it knows it is being permanently observed and monitored?”** Explore behavioural, cultural, and psychological transformation under perpetual surveillance without assuming one inevitable answer. Worldbuilding authority: `REDLINE_BIBLE.md`, PANOPTICON section.

**THEME-002 — DIRECTION:** The lock/containment motif connects ICE's DEADLOCK advancement gate with sealed thresholds, confinement, and the reversal from being locked out to being locked in. Visual metaphors must respect **LOOP-001/002**: breaking DEADLOCK permits advancement only **after** the corporation turn, when applicable unbroken subroutines still resolve.

**THEME-003 — DIRECTION:** Corporate networks may evoke panoptic architecture and uncertain observation. The central theme is surveillance's effect on choices, not a requirement for literal circular prison layouts. Legibility and responsive deckbuilder play remain primary.

**ARCH-001 — DIRECTION:** ICE remains the primary defender at each defensive layer; supporting corporate defences operate within ICE encounters rather than replacing them with unrelated minigames. Support systems may be layer-local or persist across multiple layers. Specific effects, counterplay, persistence, and balance are **OPEN**.

**MECH-CORR-001 — CONCEPT:** Corporate deck contamination introduces hostile or useless cards into the Rustler's draw/discard/hand cycle. Potential triggers include on draw, while held, at end of Rustler turn, on discard, and on reshuffle. Potential lifecycles include temporary exhaust, encounter/node duration, or persistent contamination. All names, numerical effects, removal rules, and timing details remain **OPEN**. Preserve the canonical VOID meaning and NEURAL/SYNAPTIC discard definitions.

**MECH-SURV-001 — CONCEPT:** Corporate systems may observe patterns of Rustler card use and adapt across layers. Prefer comprehensible and telegraphed counterplay; **do not** add a separate Observation meter by default. Trace and observation are conceptually related but not interchangeable.

**TAX-001 — DIRECTION:** Viruses are a subtype of deployable software. The game-state definitions of hardware, software, installed viruses, virus counters, and their interactions remain to be specified. **PURGE** remains reserved for corporation removal of virus counters.

**ORIG-001 — DIRECTION:** REDLINE/PANOPTICON remains fundamentally an original **single-player roguelike deckbuilder**. Shared cyberpunk genre vocabulary must not determine its narrative identity or substitute for distinct mechanics and worldbuilding.

**OPEN / implementation safeguard:** No card statistics, corruption injection cadence, Observer rules, surveillance resources, art assets, or story answers in this section are approved implementation specifications. Record explicit approval and tests before implementation.


## 14. Rustler end-of-turn resolution — LOCKED (2026-11-10)

**RULE-RT-001 — LOCKED:** During the Rustler action phase, the player voluntarily ends the turn using a designated END TURN button/icon, even with cards or BW remaining. Empty hand or zero BW alone does not automatically end the turn.

**RULE-RT-002 — LOCKED:** If the Rustler's health resource (Vitae; LOCKED terminology) reaches 0, the entire run ends immediately in defeat. Pending actions, end-of-turn effects, corporation response, and advancement do not continue.

**RULE-RT-003/004/005 — LOCKED:** END TURN initiates a distinct Rustler End-of-Turn Phase, before Corporation Response, in this exact order:
1. Resolve applicable end-of-turn effects, including effects using or modifying BW.
2. Discard every remaining card in hand; resolve applicable discard-triggered effects.
3. Forfeit all remaining BW (set available BW to zero; no normal carryover).
4. Enter Corporation Response Phase, which resolves applicable unbroken damage/Trace subroutines before any DEADLOCK-gated advancement.

**Timing safeguards:** An end-of-turn ability on a card merely in hand does not trigger unless the card explicitly permits triggering from hand. Installed/in-play effects follow their defined trigger rules. Multiple simultaneous trigger ordering, prevention/replacement timing, and unusual interrupt semantics remain OPEN; do not infer them from this summary. The example “At the end of your turn, gain 2 BW” was hypothetical, not an approved card.

**Rules-specification priority:** Document full encounter lifecycle and state transitions next; record acceptance tests for manual end turn, hand discard, discard triggers, BW forfeiture, corporation response, and immediate run defeat.

## 15. RUN-001 — Victory condition (LOCKED, 2026-11-10)

A successful run requires the Rustler to navigate a **maze of corporate Nodes**, overcome the corporation's intrusion defences **encountered along the traversed route**, and ultimately **defeat, pass, or otherwise nullify** the corporation's **central/core entity** in a final confrontation. The core may be a mainframe, artificial intelligence, android construct, or another entity consistent with the corporation's particular theme and structure. The final confrontation **resembles an ICE encounter in structure**; its unique mechanics are not yet specified. Destruction is not required if another approved means of overcoming the core succeeds.

**OPEN:** Maze topology and route-selection rules; whether Nodes may be revisited; which Nodes are mandatory; core-encounter rules and alternative victory methods; post-victory effects; exact criteria for having successfully passed a defence. Do not assume all Nodes in the maze must be cleared or that the final confrontation is identical to a standard ICE encounter.


## 16. RUN-002 — Corporate network topology and spatial experience (2026-11-10)

**LOCKED DESIGN DIRECTION:** Corporate networks should resemble **lattice structures**, rather than simple forward-branching trees. Their paths are circuitous and maze-like, producing **vertigo and uncertainty about orientation**: the Rustler should struggle to tell what counts as up, down, or forward and wonder whether they are travelling in circles. This spatial experience should reinforce the project's confinement/surveillance themes.

**NOT YET LOCKED:** Whether connections actually loop or only appear to; whether the network map is complete or only partially revealed; whether its geometry dynamically changes; whether backtracking and node revisits are permitted; whether the lattice is procedural, fixed, or hybrid; whether the core location is known or obscured. Do not interpret the design direction as authorization to implement any of these specific mechanics.


## 17. RUN-003 — Forward-only traversal and locked Nodes (LOCKED, 2026-11-10)

The corporate network is a visually disorienting lattice, but the Rustler **always moves forward toward the ultimate core objective**. A Node that the Rustler has passed becomes **locked behind them**; the Rustler **cannot move backward or revisit that Node** during the run. Nodes may present **up to five or six onward route options** (not a mandatory fixed count). A path may appear spatially to double back without mechanically reversing progression. Network connectivity and presentation must preserve the difference between **apparent orientation** and **legal traversal direction**.

**Design implication, not additional locked mechanic:** A directed, acyclic progression graph can implement these rules while displaying a twisting lattice. Avoid visual cues that falsely promise legal backtracking.

**OPEN:** Exact number and distribution of onward exits; whether every possible forward branch leads eventually to the core; whether some forward routes terminate in dead ends; whether path choices are visible before entry; exact meaning/timing of 'passed' for node locking; map presentation and generation.


## 18. RUN-004 — Equal-length guaranteed core routes (LOCKED guiding rule, 2026-11-10)

**Every available forward route through a corporation's network must eventually lead to its corporate core, and all complete routes must traverse the same number of Nodes.** No selectable route may be a dead end or offer a shorter/longer Node-count path to the core. This complements RUN-003: the Rustler always advances; passed Nodes lock behind them and cannot be revisited. Up to five or six onward choices may exist at some Nodes.

**Implementation guidance (not a separate approved visual rule):** Generate a layered directed graph with edges only between successive progression depths; allow branches and reconvergences within that constraint, then distort its visual embedding into a disorienting lattice. Validate that every reachable Node has a path to the core and that every path from entry to core has identical Node count. The network need not *look* layered.

**OPEN:** Whether the core confrontation counts as one of the Nodes in the equal-length count or occurs after the last ordinary Node; precise number of Nodes per run; generation procedure; visibility of connections; route-differentiating risks and rewards.


## 19. RUN-005 — Node identity, central Node, and hidden contents (LOCKED, 2026-11-10)

The corporation's core is a **Central Node** within the corporate network and **counts as a Node** for RUN-004 equal-route-length accounting. A **Node is a network location, not necessarily an ICE encounter**. What a Node contains is **hidden information** before entry.

**Established examples of Node contents:**
- One or more **layers of ICE** defending against intrusion.
- **Black Market Uplink** access.
- A space to **hack and augment the Rustler's Console**.

**Terminology:** **Console** denotes the Rustler's hacking/deck setup (inspired by the user's Neuromancer reference); its exact inventory, configuration, and interaction rules remain OPEN. A Black Market Uplink's available goods, costs, and timing are also OPEN.

**OPEN:** Whether a Node can combine multiple contents or always has one primary type; whether and how Node contents are revealed; further Node categories; the number and makeup of ICE layers; how noncombat Node visits end; whether all Node types share encounter lifecycle semantics; whether hardware recycling applies to all Node exits or only ICE encounters. Do not infer any of these from the examples.


## 20. Canonical harm terminology correction (LOCKED, 2026-11-10)

**Explicit user confirmation:** **NEURAL DAMAGE** and **SYNAPTIC DAMAGE** are **DEPRECATED**; **VOID damage** is the current term for the former brain-damage concept. They must not be used as active game mechanics or terms in new rules, cards, tests, or implementation. Older mentions elsewhere in this document are historical and superseded by this section, pending editorial cleanup.

**Current canonical terms (from 2026-11-09 design session archive):**
- **PULP X:** reduces Rustler Vitae by X.
- **SYN X:** randomly discards X cards from the current hand.
- **VOID X:** adds X persistent counters; each reduces effective DRAW by 1, with effective DRAW floor 1. VOID is only removable through specialized network recovery Nodes (e.g., eligible black-market uplink/shop), not ordinary cards or generic services.
- **DRAW:** baseline 5 minus installed Hardware minus VOID counters plus modifiers, subject to minimum 1.
- **BW:** baseline 4 per Rustler turn; installing or uninstalling Hardware costs 1 BW; unused BW forfeited at turn end.

**Migration warning:** The older 'NEURAL DAMAGE X = chosen discard' rule has no explicitly confirmed current equivalent in the archived PULP/SYN/VOID set; do not silently remap it to SYN or invent a new keyword. Earlier 'VOID damage' maps historically to the persistent draw-loss concept now named VOID, not an additional active mechanic.

**Authority:** Explicit 2026-11-10 user confirmation and REDLINE_DESIGN_SESSION_2026-11-09 archive, later terminology addendum.


## 21. SYN X — Rustler-selected discard (LOCKED, 2026-11-10)

**Latest explicit user decision supersedes all prior random-discard definitions of SYN:** **SYN X** means the Rustler **chooses and discards X cards from their current hand**. SYN is a hand-discard effect, not direct Vitae loss, VOID-counter gain, or permanent card destruction. **PULP X** remains direct Vitae reduction; **VOID X** remains persistent draw reduction. **NEURAL DAMAGE** and **SYNAPTIC DAMAGE** remain deprecated; **VOID damage** is the active replacement term. Earlier references to SYN as random discard (including section 20 above) are historical and superseded.

**OPEN edge case:** If fewer than X cards remain in hand, determine whether the Rustler discards all available cards or another rule applies. Preserve applicable discard-trigger effects under the existing end-of-turn rules where relevant.


## 22. SYN overflow — 2 Vitae per shortfall (superseded by RULE-126, 2026-11-11)

When resolving **SYN X**, the Rustler chooses and discards as many cards as possible, up to X, from their current hand. For every card of the required X that could not be discarded, the Rustler suffers **2 PULP** (i.e., 2 Vitae loss per missing card). Formula: `overflow_CHAR = 2 * max(0, X - number_of_cards_discarded)`. Example: SYN 3 with only 1 card in hand discards that card and causes 4 PULP; SYN 4 with an empty hand causes 8 PULP.

**Status:** Mechanic approved; the **2× multiplier is provisional for playtesting** and may be tuned based on results. SYN itself remains Rustler-selected discard (section 21), not random discard. VOID remains distinct and is not automatically generated by SYN overflow. Evaluate high-SYN ICE against empty hands, installed-Hardware DRAW reductions, and VOID-impaired DRAW.

**Resolution detail still OPEN:** exact sequencing of discard-triggered effects relative to overflow PULP and other simultaneous effects; use existing immediate-run-defeat rule if Vitae reaches zero.


## 23. RUN-006 — Three-corporation full run and First Signal data (LOCKED, 2026-11-10)

**Explicit user reaffirmation of established design:** A **fully completed run** requires the Rustler to infiltrate **three different corporations**. For each corporation, the Rustler seeks to access/steal data central to the overarching **First Signal** theme. The Rustler does **not** fully understand the true significance of the data or know who is ultimately hiring them to obtain it. Preserve this mystery in narrative presentation.

**Hierarchy:** full run → three corporate infiltrations → each corporation's network and central/core objective → Nodes → sequential ICE layers. Completing the first or second corporation is **not** a completed full run. The prior RUN-001 single-core victory wording describes a corporation-level milestone and is superseded insofar as it implies that clearing one corporation wins the full run. The existing equal-length routes and forward-only topology apply within a corporation's network unless separately revised.

**OPEN:** precise transition between corporations; whether and how resources, damage, upgrades, and Trace persist between corporate infiltrations; narrative revelations; order/selection of corporations; exact final victory trigger after the third corporation. Do not infer answers.


## 24. NODE-CORE-001 — Corporate Central Node boss-style ICE confrontation (LOCKED, 2026-11-10)

**Explicit user decision:** **Each corporation's Central Node resembles a final boss battle, but is structured as an ICE encounter.** All three corporations in a full run therefore have a climactic Central Node confrontation. This is a corporation-level climax, not the end of the three-corporation run until the third corporation is completed. Use the established ICE combat framework as the foundation rather than assuming a separate combat minigame. Corporate identity and presentation may distinguish the confrontation; do not invent mandatory phases, subroutines, rewards, or victory conditions.

**OPEN:** precise boss mechanics and exceptions to standard ICE rules; the exact relationship between resolving the confrontation and accessing First Signal-related data; inter-corporation transitions and persistence.


## 25. RUN-007 — Inter-corporation persistence and recovery (LOCKED, 2026-11-10)

**Explicit user decision:** After completing a corporation and proceeding to the next corporation in the same three-corporation run:
- **Carry forward** the Rustler's **deck**, **Hardware**, and **Ghostware**.
- **Fully restore Vitae**.
- **Remove all VOID counters**.

This applies at the transitions from corporation 1 to 2 and corporation 2 to 3. The full run is still completed only after the third corporation. This transition-specific VOID removal is an explicit exception to the ordinary rule that VOID requires specialized network-node recovery; it is **not** an ordinary card or generic service.

**OPEN:** TRACE treatment; temporary status effects; detailed transition timing, presentation and other resources; any special end-of-run recovery after corporation 3. Do not infer these.


## 26. RUN-008 — Corporation-specific TRACE reset (LOCKED, 2026-11-10)

**Explicit user decision:** **TRACE is corporation-specific.** On completion of one corporation and transition to the next, **TRACE resets to zero**; the prior corporation's TRACE does not carry over. Applies from corporation 1 to 2 and corporation 2 to 3.

**Complete inter-corporation transition rule (RUN-007 + RUN-008):** Carry forward the deck, Hardware, and Ghostware; fully restore Vitae; remove all VOID counters; reset TRACE to zero. Other resources and transient conditions remain OPEN.


## 27. TAX-002 — Software representation in deck (LOCKED, 2026-11-10)

**Explicit user decision for the Master Classification Matrix:** **Software is represented through cards in the Rustler's deck.** Software is a card-based category. **Viruses** remain an established subtype of deployable Software, so their software representation follows this card-based taxonomy, while exact deployment/counter mechanics remain OPEN.

**Do not infer:** that all cards are Software; that Hardware, CAPS, or Ghostware are Software; or that Software's exact play, install, duration, and discard mechanics have all been specified. Ghostware remains permanent and non-card. CAPS classification versus Hardware remains an explicit unresolved discrepancy between the user's recent statement and the REDLINE Bible.


## 28. TAX-003 — Viruses and Icepicks are Software subtypes (LOCKED, 2026-11-10)

**Explicit user decision:** **Viruses and Icepicks are both subsets of Software.** Because Software is represented through cards in the Rustler's deck (TAX-002), both Viruses and Icepicks are card-based Software. Viruses retain their previously established deployable-software identity. Icepicks retain their ICE/subroutine interaction role (including drag-to-ICE UI direction).

**Classification only:** This decision does not settle Virus counters, Icepick costs, deployment timing, card destinations, or whether other card categories exist. CAPS, Ghostware, Hardware, PATCHWORK, and Console remain separate entries pending their own classification decisions.


## 29. TAX-004 — Hardware is installable, node-duration card (LOCKED, 2026-11-10)

**Explicit user decision:** **Hardware is also represented by cards in the Rustler's deck**, distinct from Software cards. The Rustler **plays a Hardware card once to install it**. Its effect **persists for the duration of the entire Node**, including sequential ICE layers, then **ends when the Node ends**; the Hardware card **returns to the Rustler's deck**. The Hardware is not consumed or permanently lost at Node completion.

**Existing rules retained:** Installing Hardware costs 1 BW; uninstalling costs 1 BW. Each installed Hardware reduces effective DRAW by 1. Hardware recycling happens **exactly once at encounter end**; under the newly clarified node-duration rule, the normal recycling boundary for installed Hardware is **Node end**, not each individual ICE layer. This clarifies prior encounter-end ambiguity without defining all exceptional exits.

**OPEN:** exact return destination (draw pile, discard pile, or deck collection); whether early uninstallation returns the card immediately and where; exceptional Node exits including JACK OUT; effect ordering at Node end. Do not silently invent any of these.

**Taxonomy:** Deck includes both Hardware and Software cards; Viruses and Icepicks are subtypes of Software; Ghostware remains permanent non-card upgrades. CAPS classification remains unresolved.


## 30. TAX-005 — CAPS are consumable injectable code outside deck (LOCKED, 2026-11-10)

**Explicit user decision:** **CAPS are consumable, single-use injectable code devices outside the Rustler's deck.** They are a distinct mechanical category, **not Hardware cards or Software cards**. The Rustler activates/injects a CAP and consumes it; it is not drawn or played from the Rustler's deck. This resolves the earlier classification ambiguity and agrees with the REDLINE Bible's separate CAPS category.

**Preserve established fiction:** CAP (plural CAPS), colloquial term descended from corporate DAC; ritual **Flip. Inject. Discard.** JACK OUT remains a distinct CAP, not a universal free action, subject to its existing specific restrictions and unresolved conflict with forward-only Node traversal.

**OPEN:** CAPS inventory, acquisition, general activation costs/windows, specific effects beyond already established examples. Do not apply Hardware's installed DRAW penalty or Node-end recycling to CAPS.


## 31. TAX-006 — Remove installed-Hardware DRAW penalty (LOCKED, 2026-11-10)

**Explicit user decision:** **Installed Hardware no longer reduces DRAW.** This supersedes all prior rules/formulas stating `DRAW = 5 − installed Hardware − VOID + modifiers` or `−1 DRAW per installed Hardware`. Current baseline formula is **`effective DRAW = max(1, 5 − VOID counters + applicable modifiers)`**, subject to effects that explicitly modify DRAW. Hardware's established card identity, 1 BW installation and uninstallation costs, node-duration persistence, and node-end recycling remain unchanged.

**Design rationale:** remove a complexity tax that discourages using acquired Hardware and compounds VOID's draw reduction. Hardware can be balanced through other mechanics, but no new equipment-slot limit or activation restriction is authorized by this change.

**Icepicks:** Still classified as Software (TAX-003); whether they persist for one ICE or the whole Node remains OPEN. This DRAW change does not settle their duration.


## 32. TAX-007 — Icepick persistence across Node (LOCKED, 2026-11-10)

**Explicit user decision:** Icepicks are **Software cards played from the Rustler's hand** and **remain in play for the entire Node**, rather than expiring after the current ICE layer. They may therefore remain available across sequential ICE layers within the Node. This supersedes the previously OPEN Icepick duration and retains their Software subtype classification.

**OPEN — not approved by this decision:** Whether persistent Software has an active-slot/capacity limit; the number of slots; whether a limit includes only Icepicks or other persistent Software; whether Hardware uses the same capacity; replacement/uninstallation mechanics; exact return destination and timing for Icepick cards at Node end. Candidate design for discussion: cap only persistent Software, not one-shot Software; test four active slots initially. No slot count or replacement rule is locked.


## 33. TAX-008 — RAM limits active Software; Hardware can expand RAM (LOCKED concept, 2026-11-10)

**User-endorsed design direction:** The Rustler's **RAM** limits the number/capacity of **active Software** programs in play. Certain cards, particularly **Hardware**, can grant additional RAM, enabling builds that install and sustain more Software simultaneously. RAM is a separate resource from **BW** (per-turn action points) and **DRAW** (hand draw). This is the intended clean, thematic constraint replacing a fixed universal active-program count. Icepicks remain persistent Software for the whole Node and therefore participate in the active Software/RAM system.

**Not yet approved:** Starting RAM value; whether each persistent Software card costs exactly 1 RAM or has variable RAM requirements; whether one-shot Software uses RAM transiently; RAM costs of Viruses or deployed effects; what happens to active Software when a RAM-granting Hardware card is uninstalled or removed; whether Ghostware/CAPS interact with RAM; whether Software can be voluntarily unloaded and at what cost; RAM refresh/reset boundaries. No numeric values are locked.


## 34. TAX-009 — Variable RAM requirements for persistent Software (LOCKED, 2026-11-10)

**Explicit user decision:** Persistent Software cards have **variable RAM requirements**; more powerful Software generally requires **more RAM**. The Rustler cannot maintain active persistent Software whose combined RAM requirements exceed available RAM. Icepicks are persistent Software and follow this capacity rule. Hardware can increase RAM capacity under TAX-008. RAM is distinct from BW and DRAW.

**OPEN:** starting RAM; exact per-card costs and balance; rules for unloading/replacing programs; handling capacity loss mid-Node; whether and how one-shot Software or deployed Virus effects consume RAM. Example RAM costs are illustrative, not locked.


## 35. TAX-010 — RAM hard cap reaffirmed; Software unloading cost OPEN (2026-11-10)

**Explicit user reaffirmation (LOCKED):** A Rustler **cannot install Software if doing so would exceed available RAM**. The total RAM requirements of all active persistent Software must fit within current RAM capacity. This restates TAX-009 as a hard installation legality check.

**Design question (OPEN):** Should unloading active Software cost BW? Suggested direction for discussion: unloading persistent Software costs **0 BW**, while installing its replacement retains an applicable cost; unloading removes the Software from active play and must not directly return it to hand. This is **not approved** yet. The existing **1 BW uninstall cost for Hardware** remains locked and is a separate rule. Software install BW cost is not yet established; do not silently apply Hardware's 1 BW cost to Software.

**Other OPEN details:** software unloading destination, action timing, capacity reduction caused by removal of RAM-granting Hardware, and reinstallation/trigger exploits.


## 36. TAX-011 — Base RAM 4 and free persistent-Software unloading (LOCKED, 2026-11-10)

**Explicit user decisions:**

1. The Rustler has **4 base RAM** before modifiers, including RAM-granting Hardware.
2. The Rustler **cannot install persistent Software if its RAM requirement would exceed available RAM**. Active persistent Software has variable RAM requirements (TAX-009).
3. **Unloading active persistent Software costs 0 BW**. Unloading immediately removes that Software from active play and frees its occupied RAM.
4. Unloaded Software **does not return directly to hand**; the precise destination remains OPEN.
5. Icepicks are persistent Software that normally remains in play for the entire Node, unless unloaded.
6. RAM-granting Hardware may raise the capacity above base 4 RAM. Installed Hardware does not reduce DRAW (TAX-006).

**Scope:** The 0 BW rule is for **Software unloading**, not Hardware. Hardware uninstall remains **1 BW** under TAX-004. Software installation BW costs, unloaded-card destination, timing restrictions, and how RAM capacity loss is handled remain OPEN.


## 37. TAX-012 — Unloaded Software discard; BURN until next encounter (LOCKED, 2026-11-10)

**Explicit user decision:** When active Software is **unloaded**, it goes to the **discard pile**, **unless it is BURNED**. **BURNED** cards are **removed from play until the next encounter**. BURNED status is temporary, not permanent deletion. Unloading active Software remains **0 BW**, immediately ends its active effects and frees its occupied RAM (TAX-011).

**Interpretation:** A new ICE layer within the same Node can be the next encounter; the card's exact return zone and exact return timing at the beginning of that encounter remain OPEN. Do not automatically put burned cards into hand or deck without a separate rule. The circumstances or card effects that cause BURNED status remain card-specific/open. Do not conflate BURN with the separate Node-end Hardware recycling rule.


## 38. TAX-013 — BURN lasts until the next Node (LOCKED, 2026-11-10)

**Explicit user correction:** **BURNED cards remain BURNED and removed from play until the next Node**, not merely until the next encounter. This **supersedes TAX-012's “until next encounter” duration** and any suggestion that a subsequent ICE layer within the same Node returns a burned card. All sequential ICE encounters in the current Node occur while that card is unavailable.

**Unchanged:** Unloaded Software that is not BURNED goes to the discard pile; unloading costs 0 BW and frees occupied RAM.

**OPEN:** Exact zone and timing for returning BURNED cards at the start of the next Node (draw pile vs discard pile vs other); do not assume immediate hand access. BURNED status does not permanently remove the card from the run.


## 39. TAX-014 — BURNED cards shuffle into draw pile at next Node (LOCKED, 2026-11-10)

**Explicit user decision:** At the beginning of the **next Node**, all cards BURNED during the preceding Node are **returned to the Rustler's draw pile and shuffled in**. They are **not** returned to hand or discard pile, and they cannot be drawn during the Node in which they were BURNED. This resolves the return-zone question left OPEN in TAX-013 and supersedes any previous next-encounter PULP return rule.

**Complete BURNED lifecycle:** BURNED status removes a card from play immediately; it stays unavailable through the rest of the current Node, including sequential ICE encounters; on entering the next Node, return BURNED cards to the draw pile and shuffle; they can subsequently be drawn normally. Unloaded non-BURNED Software still goes to discard at 0 BW.


## 40. TAX-015 — Console definition (LOCKED, 2026-11-10)

**Explicit user decision:** The **Console** is defined as the **sum total of the Rustler's Hardware, Software, CAPS, Ghostware, and PATCHWORK**. Software includes its subtypes Icepicks and Viruses. Console is an umbrella term for this complete hacking setup, **not** an additional independent equipment category, card type, or separately installed item. The Rustler's RAM capacity is a property of this setup, not a sixth item category within the Console.

**Scope:** This definition does not establish new Console slots, upgrades, costs, or mechanics beyond those already specified for its constituent categories. Deck is a card collection/zone system, not separately listed by the user as a constituent Console item.


## 41. TAX-016 — Persistent Software installation costs 1 BW (LOCKED, 2026-11-10)

**Explicit user decision:** **Installing persistent Software from hand costs 1 BW**, matching the existing Hardware installation cost. The Rustler must also have enough free RAM to accommodate the Software card's variable RAM requirement; an installation that would exceed available RAM is illegal. Once installed, the Software occupies its required RAM until it leaves active play. Icepicks are persistent Software and follow this rule.

**Current action-cost matrix:** Install Hardware **1 BW**; uninstall Hardware **1 BW**; install persistent Software **1 BW** plus sufficient RAM; unload persistent Software **0 BW** (unloaded, non-BURNED Software goes to discard pile). Hardware does not reduce DRAW.

**OPEN:** BW costs and play timing for immediate/one-shot Software, RAM capacity loss handling, and exceptional removal/installation triggers. Do not infer those from this rule.


## 42. TAX-017 — Uninstalling RAM-granting Hardware requires legal remaining RAM (LOCKED, 2026-11-10)

**Explicit user approval:** Before uninstalling Hardware that grants RAM, the Rustler **must first unload sufficient active Software** so that remaining occupied RAM does not exceed the Console's RAM capacity after the Hardware is removed. The Rustler **cannot perform** the Hardware uninstall while it would cause occupied RAM to exceed available RAM. This is a player-directed prerequisite, **not** automatic forced removal of Software.

**Costs and destinations remain unchanged:** Unloading persistent Software costs **0 BW** and sends non-BURNED Software to discard, immediately freeing RAM; uninstalling Hardware costs **1 BW**. Base RAM is **4**, and installed Hardware can increase it. This rule applies whenever a voluntary Hardware uninstall would reduce RAM capacity.

**OPEN:** Handling involuntary RAM-capacity loss from effects other than voluntary Hardware uninstall, if such effects are introduced. No additional penalty is imposed.


## 43. TAX-018 — Node-end Hardware and Software return to deck (LOCKED, 2026-11-10)

**Explicit user decision:** **When a Node ends, all active Software and Hardware return to the Rustler's deck.** Their active/installed state ends, so their persistent effects cease and RAM previously occupied by Software is freed. This applies to persistent Software, including Icepicks, and installed Hardware; it supersedes the previously OPEN active-Software Node-end destination. Hardware already had Node-end return established in TAX-004.

**Preserve distinct BURNED rule:** Cards BURNED during the Node remain removed from play through Node end and are **shuffled back into the draw pile when the next Node begins** (TAX-014); do not prematurely return them in the ordinary active-card cleanup.

**OPEN:** Whether ordinary Node-end returned Hardware and Software go directly into the draw pile, discard pile, or a combined deck reshuffle; the user said “return to the deck,” not a specific pile. Do not assume a particular shuffle procedure. Normal cards already in draw/discard zones are unaffected unless separately specified.


## 44. TAX-019 — Complete deck reshuffle at start of each Node (LOCKED, 2026-11-10)

**Explicit user approval:** **Entering each new Node triggers a complete reshuffle of the Rustler's deck**, incorporating Hardware and Software returned from active play at the end of the preceding Node, cards in the draw and discard piles, and cards previously BURNED during the preceding Node. All eligible cards are combined and shuffled into a fresh draw pile for the new Node. The Rustler draws their starting hand under the ordinary DRAW rules.

**Timing:** Node-end active Hardware/Software return to the deck (TAX-018); BURNED cards remain unavailable until the next Node begins (TAX-014); then all eligible deck cards are shuffled together. BURNED status is not permanent deletion. This resolves the Node-end return-pile ambiguity in TAX-018 by defining the next-Node combined reshuffle.

**No implied reset:** A new Node does not itself remove VOID, restore Vitae, reset corporation-specific TRACE, or undo Ghostware/PATCHWORK upgrades; inter-corporation recovery rules remain separate.


## 45. TAX-020 — Non-ICE service Nodes skip deck setup and cleanup (LOCKED, 2026-11-10)

**Explicit user clarification:** There is **no need for reshuffling or encounter-style deck cleanup at the beginning or end of non-ICE Nodes**, such as an **Uplink Market**. This is an exception to TAX-018 and TAX-019's broad wording “every Node.” Routine deck initialization, full reshuffle, active Hardware/Software cleanup, and combat-hand setup are **ICE-Node encounter procedures**, not automatic procedures for visiting a non-ICE service Node.

**Consequences:** Visiting a service-only Node does not itself cause a full reshuffle or discard/return installed cards simply because a Node boundary was crossed. Cards acquired or modified by services follow their own as-yet-unspecified rules.

**Needs explicit reconciliation (OPEN):** TAX-014 says BURNED cards return “at the next Node.” When that next Node is a non-ICE service Node, precise BURNED-card return timing and whether to defer shuffling until the next ICE Node need a specific rule. Do not silently redefine “next Node” as “next ICE Node.” Likewise, mixed service/combat Nodes, if allowed, need an encounter-boundary rule.


## 46. ECON-001 — Escalating data-extraction rewards (USER PROPOSAL, 2026-11-10)

**User-supported direction:** Data theft occurs during ICE encounters while the Rustler attempts to pass ICE. Reward amounts **increase for successive extraction turns**, creating a push-your-luck tradeoff between longer exposure to corporate response and greater Uplink purchasing power. User's proposed example: first extraction turn **10 CRED**, second **20 CRED**, third **35 CRED**, for **65 CRED cumulative**. These values are an explicit illustrative proposal, **not yet confirmed as a final balance table**. “Exponential” describes the intended accelerating reward curve; no exact mathematical formula is established.

**OPEN:** Whether escalation is keyed to successive turns or successful extraction actions; whether a turn without extraction resets/pauses the streak; BW cost; extraction frequency per turn; cap per encounter; whether CRED is final currency name; how and when currency is banked; payouts beyond turn 3; whether neutralized ICE can still be mined; effects of PASS and BYPASS. Do not assume these mechanics are locked.


## 47. ECON-002 — Per-encounter maximum CRED payout (LOCKED, 2026-11-10)

**Explicit user decision:** **Each ICE encounter has a maximum CRED payout** available through data extraction. This is a hard ceiling on the amount the Rustler can earn from that encounter's data, regardless of escalating extraction rewards or time spent. The total amount actually awarded cannot exceed the remaining unextracted value. This prevents unlimited extraction farming.

**Explicitly OPEN:** Whether the maximum payout is known to the Rustler, hidden information, or revealed conditionally. The user specifically suggests it *could* be hidden; do not lock hidden visibility. Exact encounter caps, payout distribution, extraction action costs/frequency, streak progression, whether extraction can occur after ICE is neutralized, and the final currency label remain undecided. The proposed 10/20/35 CRED escalating sequence remains a balance example, not a universally locked payout table.


## 48. ECON-003 — Extractor Software and payout profiles (LOCKED DIRECTION, 2026-11-10)

**Explicit user design direction:** Data/CRED extraction during ICE encounters is performed by **Extractor programs**, which are **Software cards the Rustler must install, spending BW**. Once installed, Extractors automatically extract a specified amount of data/CRED **at the end of turns**, following the program's payout profile. This replaces the earlier *proposed* universal Rustler extraction action. Existing persistent Software installation baseline is 1 BW, subject to future card-specific exceptions, and installed Software is governed by RAM and Node-long Software lifecycle unless explicitly revised.

**Distinct extractor profiles:** Street-oriented, heavily augmented extractors may produce **zero payout for the first two turns** and then **a large payload at the end of turn three**. Corporate-inspired, cleaner extractors have a **more even payout curve**, earning value earlier and more steadily. This creates risk/reward differentiation through deck composition and time exposed to ICE. Rustler archetypes express preferences rather than automatically imposing exclusivity (exclusivity itself not decided).

**Prior LOCKED ECON-002 remains:** Each ICE encounter has a finite maximum total CRED payout; whether that cap is visible to Rustler is OPEN.

**OPEN:** Specific Extractor card examples/names, RAM costs, BW exceptions, exact yields and profiles, whether countdown is from installation or encounter turn, whether multiple Extractors can run simultaneously, effects of unload/reinstall and interrupted sequences, whether an extractor can pay after ICE PASS, and whether extracted CRED is banked immediately or upon surviving/passing. The previous 10/20/35 payout example is not universal and must not override card-defined payout curves.


## 49. SOFT-001 — Multi-subtype Software and extraction-powered defenses (2026-11-10)

**LOCKED — user explicitly approved:** A single Software card **may have multiple subtypes/capabilities**, e.g. Icepick + Virus, Virus + Extractor, or other combinations. These classifications are **not mutually exclusive**. This is intended to support diverse deck builds, Rustler playstyles, and Rustler personalities. Software remains the umbrella card category, and existing installation/BW/RAM/lifecycle rules apply unless overridden by an approved card rule.

**USER-PROPOSED DESIGN EXAMPLE (not yet a finalized card):** A shield-like card can prevent **X PULP** by **spending/burning CRED extracted during the previous turn**. This connects data extraction and defense, creating a choice between keeping CRED for Uplink Market purchases and consuming it for survival. Exact damage-to-CRED conversion, whether it can use only the previous turn's proceeds or any held CRED up to that amount, activation timing, BW/RAM, cap, and whether spent CRED is permanently deducted remain OPEN. Do not treat illustrative card name or stats as approved.

**Terminology caution:** Here “burning CRED” means spending currency, not the existing **BURNED card** state; keep mechanically distinct.


## 50. SOFT-002 — Instant CRED shield and hand retention concept (2026-11-10)

**LOCKED — user-confirmed CRED shield principles:** A shield-like **one-shot / instant Software card** is played from hand, its effect resolves immediately, and it **goes to the discard pile** rather than remaining installed. It protects against a limited amount of **PULP** by **permanently spending CRED the Rustler has already earned**. The CRED cost is **variable**, and the card has a **protection/spending limit**. Its tactical weakness is hand availability: the card may not be in hand when protection is needed. This is a card/mechanic concept, not yet a named, fully balanced card. Precise conversion rate, cap, activation window, BW play cost, and interpretation of “CRED extracted previous turn” are OPEN. Instant Software is distinct from persistent Software and does not automatically follow persistent installation lifecycle.

**NEW DESIGN TOPIC — user requests thematic hand-retention abilities:** Rustler should be able to gain abilities to **retain selected cards in hand across turns** despite normal end-turn hand discard. Exact rules, source of ability, hand-size interaction, duration, and limits OPEN.

**ASSISTANT PROPOSAL, NOT LOCKED:** Keyword **CACHE X** for retaining up to X cards at turn end. Cards remain in hand, not installed; whether caching consumes RAM is OPEN. This is thematically based on computer caching, and could help retain a CRED-powered shield until needed. Do not treat the keyword or details as approved until user explicitly agrees.


## 51. SOFT-003 — CACHE keyword (LOCKED, 2026-11-10)

**Explicit user approval:** **CACHE** is REDLINE's official keyword for **retaining selected cards in the Rustler's hand across the normal end-of-turn hand discard**. The word functions as both a noun and a verb: e.g. **“CACHE that card”** means designate that card to remain in hand. **CACHED** describes a card currently retained. **CACHE X** is the natural parameterized form for retaining up to X cards (e.g. CACHE 1, CACHE 2), subject to final wording. The keyword is intentionally evocative of computer caching and multiple everyday meanings.

**Core distinction:** CACHED cards **stay in hand**, rather than being installed persistent Software in the Console. Their retention is an exception to the normal end-of-turn hand discard.

**OPEN:** Which abilities/cards grant CACHE, selection timing, retention duration, whether CACHED cards count toward the next turn's DRAW/hand size, any total CACHE limit, whether cards can remain CACHED over multiple turns, and special treatment at ICE-layer/Node boundaries. Do not infer these details as locked.


## 52. SOFT-004 — CACHE additive to DRAW (LOCKED, 2026-11-10)

**Explicit user decision: Option B.** At the start of a turn, the Rustler **retains all CACHED cards in hand and draws their full normal DRAW quantity in addition**. CACHED cards do **not** count against or reduce the number of cards drawn. Example: **2 CACHED cards + DRAW 5 = 7 cards in hand** at turn start. VOID and other DRAW modifiers still affect the number of newly drawn cards according to the established DRAW formula; they do not retroactively discard or offset CACHED cards.

**OPEN:** Maximum total hand size, whether a cached card may be held indefinitely or must be released after a turn, selection and duration of CACHE effects, and boundaries between ICE layers/Nodes. This decision does not by itself resolve those issues.


## 53. SOFT-005 — Indefinite CACHE retention (LOCKED, 2026-11-10)

**Explicit user decision:** A CACHED card may be **retained indefinitely across turns** rather than expiring after one additional turn, provided the supporting CACHE ability remains active. The card remains in the Rustler's hand until played or otherwise removed by a game effect. This extends SOFT-003 and SOFT-004: CACHED cards are retained in hand and do not reduce normal DRAW, even across multiple successive turns.

**OPEN:** What happens when the granting CACHE ability is lost or capacity falls below cards currently CACHED; whether there is a global hand size limit; whether a CACHED card may be carried across sequential ICE layers (which normally discard hand upon PASS); whether CACHE persists between Nodes (which normally reset deck/hand); and the exact source and limits of CACHE abilities. Do not silently override existing ICE PASS or Node cleanup rules.


## 54. SOFT-006 — CACHE survives ICE layers, ends at Node boundary (LOCKED, 2026-11-10)

**Explicit user decision:** CACHED cards **survive across sequential ICE layers within the same Node**, including the PASS transition that normally discards unplayed cards. CACHE retention lasts **until the end of the Node**, not across Node boundaries. At Node end, any remaining CACHED cards are returned to the Rustler's deck as part of normal ICE Node cleanup, and the CACHE state ends. Thus the previously locked indefinite retention (SOFT-005) is **indefinite within the Node**, subject to maintaining the relevant CACHE ability, not indefinite across Nodes.

**Other established rules remain:** Non-CACHED unplayed hand cards are discarded on ICE PASS; next ICE layer begins with a fresh normal DRAW, with any retained CACHED cards additive to that draw (SOFT-004). The current Node-end cleanup and next ICE Node reshuffle rules remain in force.

**OPEN:** Effects of losing CACHE capacity during a Node, overall hand limit, and precise rules for the source/activation of CACHE.


## 55. SOFT-007 — CACHE loss and corporate countermeasures (LOCKED, 2026-11-10)

**Explicit user decision:** If a Rustler loses the ability/effect supporting CACHE, affected formerly CACHED cards **remain in hand for the rest of the current turn**, playable as ordinary hand cards, and **are discarded at the normal end-of-turn discard step** if still unplayed. They are **not immediately discarded** merely because CACHE retention is lost. This resolves the SOFT-005/006 capacity-loss timing question at least for complete loss of CACHE support; precise handling of partial capacity reduction remains OPEN.

**Explicitly supported defensive design space:** ICE and corporate defenses may (a) **eliminate/discard all currently CACHED cards in hand**, or (b) **remove CACHE retention from cards in hand**, causing normal end-of-turn discard rather than immediate discard. These are distinct types of effects and can appear as ICE subroutines or other corporate defenses.

**Terminology:** “Invalidate CACHE” (remove retention) and “Flush CACHE” (immediately discard cached cards) are illustrative labels only, **not locked keywords**. CACHE may be an applied retention status; stripping it should not automatically erase printed card text. Exact effect wording, timing, and counterplay are OPEN.


## 56. SOFT-008 — Individual and mass CACHE targeting (LOCKED, 2026-11-10)

**Explicit user approval:** ICE subroutines and corporate defenses may target **individual CACHED cards** or **all CACHED cards**, both for (a) **removing CACHE retention** and (b) **immediately discarding CACHED cards**. Thus four supported effect shapes are: single-card retention removal; all-card retention removal; single-card immediate discard; all-card immediate discard.

**Interaction with SOFT-007:** Removing CACHE retention does **not** immediately discard the affected card(s); they remain in hand and follow normal end-of-turn discard unless played. An effect explicitly ordering discard moves affected CACHED card(s) immediately to the discard pile. No new named keywords or targeting selection method are locked by this decision.


## 57. RULE-001 — Target chooses how to comply (LOCKED, 2026-11-10)

**Explicit user rule:** When a game effect requires its **target** to take an action or choose affected objects, **the target chooses how and what to do to satisfy the requirement**, within the restrictions of the effect. The target does not gain the option to ignore a mandatory effect; it selects the eligible cards, counters, installed programs, etc., to fulfill it. This is a **general default targeting/selection rule**, not restricted to CACHE. Applies symmetrically to Rustler and Corporation when each is the target.

**Examples:** If Rustler must discard one CACHED card, Rustler chooses which CACHED card. If Rustler must remove CACHE from one card, Rustler chooses which. If Corporation is required to PURGE Virus counters, Corporation chooses eligible counters. The existing SYN X rule (Rustler chooses cards to discard) is consistent with this default.

**Exceptions:** An effect that explicitly names a particular target, defines a different chooser, or calls for random selection overrides this default. Do not assume the Corporation randomly selects affected CACHED cards absent such explicit wording. If insufficient eligible objects exist, follow the specific effect's instructions or a future general insufficiency rule (still OPEN).


## 58. RULE-002 — Fulfill as much as possible; independent effects still resolve (LOCKED, 2026-11-10)

**Explicit user decision:** When a mandatory effect instructs a target to perform an action and the target has fewer eligible objects/resources than requested, **perform as much of the instruction as possible**. An unfulfillable portion does **not** cause the whole card/effect to fail. **Subsequent effects still resolve**, unless an explicit rule or condition says otherwise.

**User's authoritative example:** A card reads **“When played: Discard a card. Gain X effect.”** If the Rustler has **no other cards in hand** to discard, the Rustler discards none and **still gains X**. If the Rustler has an eligible card, they discard one (target chooses under RULE-001), then gain X. Likewise, “discard 3 CACHED cards” with only one CACHED card discards that one.

**OPEN design distinction:** Future effects may explicitly specify an **additional mandatory cost** or conditional **“if you do”** requirement to gate a benefit, but the exact templating and general cost-payment rules have not yet been approved. Do not retroactively interpret a normal “Discard 1. Gain X” instruction as such a cost.


## 59. RULE-003 — Instructions versus costs and conditional effects (LOCKED, 2026-11-10)

**Explicit user approval:** REDLINE formally distinguishes **instructions** from **costs**. Ordinary instructions are fulfilled **as much as possible** under RULE-002, without cancelling other independent effects. A **cost** must be **paid in full** to activate/receive the associated effect. A **conditional** such as **“If you do”** grants its contingent benefit only if the specified action was actually performed successfully. **Never infer a cost** from an ordinary instruction; cost/condition must be explicit in card text or an applicable rule.

**Examples:**
- **“Discard 1 card. Gain X.”** With no eligible card to discard, discard none; still gain X.
- **“Discard 1 card. If you do, gain X.”** With no eligible card to discard, do not gain X.
- **“Cost: Discard 1 card. Effect: Gain X.”** With no eligible card to discard, cannot pay the cost and therefore cannot activate the associated effect.

**Interaction:** RULE-001 still lets the target choose eligible objects when an effect requires a choice; RULE-002 governs partial fulfillment of instructions, but does **not** waive costs. Exact formatting/wording conventions may be refined later without changing this principle.


## 60. SOFT-009 — Instant Software is the default card lifecycle (LOCKED, 2026-11-10)

**Explicit user decision:** **Most cards in the Rustler's deck are Instant Software.** Standard lifecycle: **play the card from hand → pay any applicable costs → perform its instructions → move the card to the discard pile.** Instructions/costs/conditions follow RULE-001, RULE-002 and RULE-003. Instant Software is played for an immediate effect; it is **not installed as persistent Software**, and therefore does not occupy persistent Console RAM or remain active through the Node unless a specific card effect says otherwise.

**Important distinction:** Persistent Software installation has an established baseline cost of 1 BW (TAX-016). That **installation cost is not automatically applied to Instant Software**, which is played rather than installed. The universal/default BW **play cost** for Instant Software is still **OPEN**; card-specific costs may be printed. This section supersedes any earlier suggestion that all Instant Software necessarily costs 1 BW to play.

**OPEN:** Default instant-card BW play cost (including whether zero-cost cards exist), exact timing windows for instant cards including defensive responses, and special destination exceptions (e.g. BURNED).


## 61. SOFT-010 — Printed BW costs for Instant Software (LOCKED, 2026-11-10)

**Explicit user approval:** Every Instant Software card has its **own printed BW play cost**; **0 BW** is permitted. There is **no universal BW play cost** for Instant Software. A card may cost 0, 1, 2, or more BW as specified by its own design. The Rustler must pay the card's BW cost to play it, subject to future explicit modifiers/waivers. After playing and resolving its instructions, it goes to the discard pile per SOFT-009 unless an explicit card effect specifies another destination.

**Distinct from persistent Software:** The established **1 BW installation cost** for persistent Software remains separate and unchanged. Instant Software is played, not installed; it does not consume persistent RAM merely by being played.

**OPEN:** Timing windows for playing Instant Software (including whether defensive reactions are possible during corporate response), any default maximum printed BW cost, and exceptions/discount effects.


## 62. SOFT-011 — Rustler-turn-only card play; no reactive plays (LOCKED, 2026-11-10)

**Explicit user decision:** **All Rustler cards must be played during the Rustler's turn.** There are **no reactive card plays during the Corporation's turn** or during resolution of corporate/ICE subroutines. This includes Instant Software and defensive cards. The Rustler must prepare defenses proactively before ending their turn.

**Distinction:** An effect established by a card already played during the Rustler's turn may operate or resolve during the subsequent corporate response according to its card text; that is **not** playing a new card out of turn. CACHE retention preserves access to cards for later Rustler turns but does not grant out-of-turn play. The previously discussed CRED-powered instant shield therefore must be played proactively if it is to defend against incoming PULP; precise shield effect duration/trigger and CRED-spending timing remain OPEN.

**Supersedes:** The earlier assistant proposal to allow special reactive Instant Software during corporate response is rejected.


## 63. SOFT-012 — Default defensive protection duration (LOCKED, 2026-11-10)

**Explicit user approval:** A defensive card played during the Rustler's turn normally provides its protection **through the immediately following Corporation response**. Any unused protection **expires at the end of that corporate response**. A card can **explicitly specify a longer duration**, overriding this default. This is a duration rule, not permission to play reactive cards: under SOFT-011, **all Rustler cards must be played during the Rustler's turn**.

**Example:** An Instant Software shield played during the Rustler's turn says **“Prevent 3 PULP.”** During the following corporate response it can prevent up to 3 PULP; if only 1 PULP is dealt, the unused 2 protection expires after that response. The shield card itself follows the normal play → resolve → discard lifecycle; its already-established protection may continue until the response ends.

**OPEN:** Exact stacking/consumption order of multiple protections, whether protection is shared across different damage instances by default (example above assumes a pool), and CRED-to-PULP shield exchange rates.


## 64. SOFT-013 — Temporary effects expire at start of next Rustler turn (LOCKED, 2026-11-10)

**Explicit user decision:** **At the beginning of each Rustler turn, all unused temporary shields and effects end.** A defensive effect established during the Rustler's turn remains available through the following Corporation response, but any unused portion expires **at the beginning of the next Rustler turn**, rather than immediately at the end of the Corporation response.

**Clarification / precedence:** This **refines and supersedes SOFT-012's default expiration timestamp**. SOFT-012's proactive play requirement and protection through the Corporation response remain intact. Persistent installed Software, Hardware, and effects explicitly assigned longer durations continue under their own lifecycle/duration rules; this cleanup is for temporary shields and effects, not automatic removal of persistent Console assets.

**Example:** Play “Prevent 3 PULP” on Rustler turn. The following corporate response deals 1 PULP; 2 unused protection remains until the start of the next Rustler turn, then expires.

**OPEN:** Whether multiple independent shield effects combine into one pool or remain separately tracked; exact ordering of start-of-turn cleanup relative to other start-of-turn triggers.


## 65. SOFT-014 — Independent defensive effects; cumulative PULP prevention (LOCKED, 2026-11-10)

**Explicit user approval:** Multiple active shields/defensive effects remain **separate, individually tracked effects**, but their PULP prevention **accumulates** against incoming PULP. They are **not merged into a single effect or shield pool**. This allows card-specific modifiers, triggers, and interactions to affect one shield without modifying the others. Any unused temporary protection expires at the beginning of the next Rustler turn per SOFT-013.

**User-provided design example (illustrative, not a finalized card):** A Hardware ability could read: **“The first defensive card you play each Rustler turn prevents twice as much PULP.”** Thus, a first defensive card with **Prevent 3 PULP** instead prevents **6 PULP**; a second card with **Prevent 2 PULP** still prevents 2. Their separately tracked protections **accumulate to 8 total PULP prevention**. The Hardware card's name and final wording are OPEN; this example establishes that a modifier may apply to an individual defensive card while total available prevention accumulates.

**OPEN:** When several separately tracked shields could prevent the same incoming PULP, which shield is consumed first (Rustler choice versus a fixed order); interactions with conditional shields.


## 66. SOFT-015 — Unified PULP prevention pool (LOCKED, 2026-11-10)

**Explicit user correction:** All defensive cards and effects contribute their calculated PULP prevention to **one shared numerical prevention pool**. Apply any modifiers to the individual card/effect's prevention amount **before** adding it to the pool. Once contributed, there are **no separately tracked shield values** and no choice of which shield absorbs incoming damage. Incoming PULP is deducted from this **single prevention pool**; only any excess PULP gets through as Vitae damage. Remaining unused temporary prevention expires at the **beginning of the next Rustler turn** per SOFT-013.

**Example:** First defensive card prevents 3 PULP, doubled by Hardware to 6; second prevents 2. Total prevention pool = 8. Incoming 5 PULP consumes 5 pool points, leaving 3. No shield selection/consumption order exists.

**Precedence:** This **supersedes SOFT-014's assertion that shields remain separately tracked**. SOFT-014's concept of independently calculating card-specific prevention modifiers and cumulative protection remains valid, but the resulting prevention is pooled into **one value**.


## 67. DMG-001 — Three distinct damage types and type-specific protection (LOCKED, 2026-11-10)

**Explicit user approval:** REDLINE's **three damage types are distinct** and defenses do not cross-protect by default:
- **PULP X:** Reduces Rustler Vitae by X; prevented by the shared **PULP prevention pool** under SOFT-015.
- **SYN X:** Rustler chooses and discards X cards from their current hand; this does not reduce Vitae. Requires an effect explicitly protecting against SYN to prevent it.
- **VOID X:** Applies persistent DRAW reduction (subject to minimum DRAW rule). Requires an effect explicitly protecting against VOID to prevent it.

A card may explicitly prevent multiple named damage types, but protection against one does **not** implicitly apply to another. The unified PULP prevention pool is **PULP-only**; it does not prevent SYN or VOID.

**Example:** Rustler has 6 PULP prevention and receives PULP 4 plus SYN 2. Four prevention is spent, leaving 2 in the PULP pool; SYN 2 separately requires the Rustler to choose and discard up to 2 eligible cards under RULE-001 and RULE-002.

**OPEN:** Exact resource/pool mechanics for SYN- or VOID-specific prevention, if such cards are introduced.


## 68. DMG-002 — Three independent damage prevention pools (LOCKED, 2026-11-10)

**Explicit user approval:** REDLINE has **three independent numerical prevention pools**, one each for **PULP**, **SYN**, and **VOID**. Each defensive card/effect contributes its calculated prevention to the pool(s) for the **damage type(s) explicitly named** in its instructions. Contributions from multiple sources **sum within each matching pool**; pools are never interchangeable or cross-applied. On incoming damage of type X, deduct prevention from **that type's pool only**; any excess damage of that type resolves normally under its own rules. No individual shield consumption choice exists after contributions have entered a pool.

**Duration:** Unused **temporary** prevention in each of the three pools expires at the **beginning of the next Rustler turn**, following SOFT-013. Explicit longer-duration effects can follow their printed duration.

**Example:** Rustler has PULP prevention 4, SYN prevention 2, VOID prevention 1. Incoming PULP 3, SYN 3, VOID 2 leaves PULP prevention 1; SYN prevention 0 with SYN 1 resolved (choose and discard 1 eligible card); VOID prevention 0 with VOID 1 applied.

**Relationship to earlier rules:** Extends SOFT-015's single pooled-value approach to each distinct damage type without combining types, and completes DMG-001's previously OPEN question of whether SYN and VOID have prevention pools.


## 69. GHOST-001 — Node-based Origin Ghostware prevention (LOCKED, 2026-11-10)

**Explicit user approval:** Rustler **Origin Ghostware** may grant a fixed quantity of damage-type-specific prevention **once per Node**, supporting distinct Rustler archetypes. **Illustrative synthetic body armor archetype:** At the **beginning of each Node**, grant **6 PULP prevention**. This reserve remains available **across Rustler turns and successive ICE encounters within the Node**, and incoming PULP consumes it normally. At the **next Node**, the Origin Ghostware grants a fresh **6 PULP prevention**. The armor's name, balance and final card presentation remain illustrative rather than finalized.

**Duration and accounting:** Node-long Origin Ghostware prevention **does not expire at the beginning of the next Rustler turn** under SOFT-013; that expiration applies to temporary prevention. For correct accounting alongside DMG-002's shared per-type prevention totals, the game must retain sufficient **duration/source bookkeeping** to expire temporary contributions while preserving any unspent Node-long reserve; this is **not** a return to player-selected shield consumption. Exact internal allocation between temporary and Node-long prevention when both coexist remains **OPEN**.

**Archetype implication:** Other Rustlers may specialize in SYN or VOID prevention using different Origin Ghostware; these are design possibilities, not locked starting abilities.


## 70. RULE-004 — Temporary resources spent before ongoing resources (LOCKED, 2026-11-10)

**Explicit user decision — universal game rule:** Whenever multiple eligible interchangeable resources, prevention reserves, or effects can satisfy the same expenditure, cost, or requirement, **temporary resources are consumed first, before permanent or ongoing resources**. This is a general REDLINE priority rule, not merely a shield rule. Apply automatically without requiring the Rustler to select individual resources. Explicit card text or a more specific rule may override the default priority.

**PULP prevention example:** Rustler has 3 temporary PULP prevention plus 6 Node-long PULP prevention from Origin Ghostware, for a displayed total of 9. Incoming PULP 4 consumes the 3 temporary first, then 1 Node-long, leaving 5 Node-long PULP prevention and 0 temporary. This is consistent with the single displayed pool per damage type (DMG-002) while preserving behind-the-scenes duration bookkeeping (GHOST-001).

**Scope:** The priority applies only when the candidate resources/effects are **eligible and interchangeable for the same requirement**; it does not make a PULP reserve eligible to pay SYN/VOID, bypass a printed cost, or allow an ineligible effect to be spent. Exact priority among multiple resources with equal duration remains OPEN.


## 71. RULE-005 — Earliest-expiring eligible resources consumed first (LOCKED, 2026-11-10)

**Explicit user approval:** Extend RULE-004 to a general priority based on **relative remaining duration**. When two or more **eligible, interchangeable** resources, prevention reserves, or effects could satisfy the same cost, requirement, or expenditure, the game **automatically consumes the one that expires soonest first**. A resource that is more temporary has higher consumption priority than one that lasts longer. This applies beyond damage prevention, subject to eligibility and explicit card/rule overrides.

**Illustration:** A shield expiring at the beginning of the next Rustler turn is spent before Node-long armor; Node-long armor is spent before an otherwise interchangeable reserve with an even longer duration or no expiration. The interface can present the combined available value while the engine tracks source/duration for priority and expiration.

**Relationship:** RULE-005 refines RULE-004's temporary-before-ongoing rule: priority is determined by **earliest expiration**, not merely a binary temporary/permanent distinction. The three damage-type pools remain distinct (DMG-002). No player selection is required.

**OPEN:** Tie-breaking between eligible resources with identical expiration times.


## 72. RULE-006 — Equal-expiration resource priority (LOCKED, 2026-11-10)

**Explicit user approval:** When two or more eligible, interchangeable resources or effects have **identical expiration timing** and are **mechanically equivalent for the expenditure**, the game may consume either automatically, **without prompting the Rustler to choose**. If individual source effects make the distinction **mechanically meaningful**, preserve and resolve that distinction rather than silently treating the resources as equivalent. An explicit card or more-specific rule may govern such a case.

**Priority relationship:** If expiration times differ, RULE-005 still requires consuming the **earliest-expiring eligible** resource first. RULE-004 establishes the overarching temporary-before-ongoing principle. This tie rule does not allow ineligible resources or cross-type prevention.

**OPEN:** A deterministic engine tie-breaker for mechanically distinct same-expiration resources if no specific card text resolves the conflict.


## 73. RULE-007 — Prevention multipliers apply to specified existing pools; encourage stacking (LOCKED, 2026-11-10)

**Explicit user decision:** Card effects **stacking and synergizing is encouraged** as a central deckbuilding feature. Do **not** impose an implicit restriction that multipliers can only affect newly generated prevention. Interpret prevention multiplier wording by its **scope**:
- **“Double your prevention”** doubles **all three current prevention pools**: PULP, SYN, and VOID.
- **“Double your PULP prevention”** doubles the **entire current PULP prevention pool**, including contributions already accumulated from multiple cards. Example: three cards collectively provide **15 PULP prevention**; doubling PULP prevention produces **30 PULP prevention**.
- **“The first defensive card you play each Rustler turn prevents twice as much PULP”** instead modifies **that individual card's contribution**, not the entire accumulated pool, as illustrated under SOFT-014.

**Design intent:** Encourage players to discover powerful interactions among multiple cards and Hardware/Ghostware; stacking effects should be supported, not automatically suppressed as exponential synergy. Wording determines whether a multiplier applies to a single contribution or an already-accumulated pool.

**Accounting:** The engine must preserve source/duration bookkeeping necessary for RULE-004/005/006 and GHOST-001 even when a multiplier affects a displayed pooled total.

**OPEN:** Precise ordering and rounding for multiple simultaneous multipliers, and how pool-wide multipliers distribute across contributions of different expiration durations. Do not assume repeated passive reapplication every frame/turn; timing must be specified.


## 74. RULE-008 — Prevention multipliers compound sequentially (LOCKED, 2026-11-10)

**Explicit user approval:** Multiple effects that multiply a prevention pool **compound sequentially against the pool's current value**, not additively and not just against the initial contributions. For example, if the Rustler has **15 PULP prevention**, resolving **“Double your PULP prevention”** twice yields **15 → 30 → 60**. Two doublings yield **×4**; three yield **×8**, provided each multiplier actually resolves.

**Design intent:** Powerful, potentially exponential stacking synergies are deliberate and encouraged. The exact wording of each card determines whether its multiplier affects a **whole pool** or an **individual card's contribution** (RULE-007).

**Still OPEN:** Ordering of simultaneous triggers/multipliers, mixed-duration contribution bookkeeping when a whole pool is multiplied, and any rounding rules for noninteger modifiers. This rule locks sequential compounding, not an unspecified trigger order.


## 75. RULE-009 — Snapshot-based prevention pool multipliers preserve duration (LOCKED, 2026-11-10)

**Explicit user approval:** A card saying **“Double your [type] prevention”** doubles the **prevention amount currently present when the card's effect resolves**. It is a **one-time snapshot effect**, not an ongoing multiplier applied automatically to prevention granted afterward. When the current pool contains contributions with different durations, the doubling **preserves those durations proportionally** by doubling each existing contribution's remaining amount before recombining the displayed pool.

**Example:** 6 Node-long PULP prevention from Ghostware + 4 temporary PULP prevention from Software = 10 total. A doubling effect resolves, yielding **12 Node-long + 8 temporary = 20 total**. The temporary 8 is consumed before the Node-long 12 under RULE-004/005. If another card later adds 3 PULP prevention, total becomes **23**, not 26. A second subsequent doubling resolves against the then-current **23**, producing **46** (RULE-008), preserving each contribution's duration.

**Scope:** “Double your prevention” applies this snapshot operation to each of PULP, SYN, and VOID; a type-specific multiplier affects only its named pool (RULE-007). No retroactive multiplication of already-spent prevention.


## 76. RULE-010 — Resolve card instructions in printed order (LOCKED, 2026-11-10)

**Explicit user approval:** A card's instructions resolve **sequentially in their printed order, top to bottom**, unless the card or a more-specific rule explicitly says otherwise. Earlier instructions change game state before later instructions resolve. This works with RULE-002 (fulfill as much as possible), RULE-003 (distinguish costs, instructions, and conditional rewards), and RULE-009 (snapshot multipliers evaluate the current pool at the moment of resolution). Required costs are paid before their associated effects resolve.

**Example:** Starting with 10 PULP prevention, **“Gain 5 PULP prevention. Double your PULP prevention.”** resolves **10 → 15 → 30**. The reverse wording, **“Double your PULP prevention. Gain 5 PULP prevention.”**, resolves **10 → 20 → 25**. Printed order therefore matters for synergies and is intentional.

**OPEN:** Ordering of multiple simultaneous triggers from different cards/effects, distinct from instructions printed sequentially on one card.


## 77. RULE-011 — Rustler orders simultaneous Rustler-controlled triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When **multiple Rustler-controlled effects trigger simultaneously**, the **Rustler chooses their resolution order**. Resolve each chosen trigger's effect **completely** before moving to the next; within each effect, printed instructions still resolve in order under RULE-010. This deliberately supports strategic sequencing and powerful card synergies.

**Example:** Rustler currently has **5 PULP prevention**. Two installed Software effects trigger together on playing a defensive card: one **grants 3 PULP prevention**, the other **doubles current PULP prevention**. Rustler may resolve **+3 first, then double** to produce **(5 + 3) × 2 = 16**, instead of **(5 × 2) + 3 = 13**.

**Scope:** This rule specifies the ordering of **simultaneous Rustler-controlled triggers**. It does not yet specify ordering of simultaneous Corporation-controlled triggers or cross-controller triggers, which remain OPEN.


## 78. RULE-012 — Corporation orders simultaneous Corporation-controlled triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When **multiple Corporation-controlled effects trigger simultaneously**, the **Corporation determines their resolution order**. Each chosen triggered effect resolves **completely** before the next begins; instructions within each effect follow printed order under RULE-010. This mirrors RULE-011 for Rustler-controlled simultaneous triggers.

**Scope:** The rule concerns **ordering of already-triggered Corporation effects**, not playing reactive cards during the Corporation turn; SOFT-011's restriction on Rustler card play remains unchanged. The order of simultaneous triggers **controlled by different sides** remains OPEN.


## 79. RULE-013 — Active side resolves opposing simultaneous triggers first (LOCKED, 2026-11-10)

**Explicit user approval:** When Rustler-controlled and Corporation-controlled effects trigger at the same moment, **the active side's triggered effects resolve first**:
- **During the Rustler's turn:** resolve Rustler-controlled triggers first, then Corporation-controlled triggers.
- **During the Corporation's turn:** resolve Corporation-controlled triggers first, then Rustler-controlled triggers.

Within each side's group of simultaneous triggers, that side chooses their order (RULE-011 for Rustler, RULE-012 for Corporation). Each trigger resolves completely before the next, with instructions in printed order (RULE-010). This ordering rule does **not** permit out-of-turn card plays; SOFT-011 remains in force.

**OPEN:** Exact handling of new triggers generated while another trigger is resolving (nested triggers/queue priority), if relevant.


## 80. RULE-014 — Chained triggers queue until current effect finishes (LOCKED, 2026-11-10)

**Explicit user approval:** If resolving an effect causes another effect to trigger, the newly triggered effect **does not interrupt** the currently resolving effect. Instead, it enters a **pending trigger queue**. Finish **all instructions of the current effect in printed order** (RULE-010), then resolve pending triggers according to existing controller and active-side priority rules (RULE-011/012/013). Each triggered effect likewise resolves fully before proceeding to the next. No reactive Rustler card play is permitted during the Corporation turn (SOFT-011).

**Illustration:** Starting at 0 PULP prevention, a played card says **“Gain 3 PULP prevention. Double your PULP prevention.”** Installed Software triggers on gaining PULP prevention and grants +2 PULP prevention. The +2 trigger waits while the played card resolves: **0 → 3 → 6**, then the queued +2 resolves to **8**. It does not interrupt between gaining 3 and doubling, which would have produced 10.

**OPEN:** Detailed queue policy for newly generated triggers while other triggers are queued, especially whether newly generated triggers are inserted ahead of or behind existing pending triggers, subject to RULE-011/012/013.


## 81. RULE-015 — FIFO pending trigger queue (LOCKED, 2026-11-10)

**Explicit user approval:** REDLINE's pending triggered effects resolve in **first-in, first-out (FIFO)** order. When an effect currently resolving generates a new trigger, that new trigger is appended to the **back of the existing pending queue** rather than jumping ahead of triggers already waiting. The current effect must complete before the next queued effect begins (RULE-014).

**Example:** Triggers **A** and **B** are already waiting. Resolving **A** generates trigger **C**. Resolve in order **A → B → C**.

**Compatibility with priority rules:** For triggers generated **simultaneously**, establish their relative enqueue order using controller choice (RULE-011/012) and active-side priority (RULE-013). After insertion, newly generated triggers do not overtake already-queued effects. Within each effect, printed instructions resolve top-to-bottom (RULE-010). This queue rule does not permit reactive card plays (SOFT-011).


## 82. RULE-016 — Detect and terminate infinite trigger loops (LOCKED, 2026-11-10)

**Explicit user approval:** REDLINE must automatically **detect and stop infinite or nonterminating triggered-effect cycles**, rather than allowing the game to hang or crash. Detection and interruption must be **deterministic**. This safeguard must **not** impose an arbitrary general cap on legitimate finite stacking, compounding prevention multipliers, or other intended card synergies (RULE-007/008). It works alongside the noninterrupting FIFO trigger queue (RULE-014/015).

**Design requirement:** Distinguish genuinely nonterminating trigger cycles from finite combinations that legitimately produce very large numerical effects. A repeated trigger name alone is insufficient evidence of an infinite loop.

**OPEN:** Exact cycle-detection algorithm, the precise trigger or effect suppressed when a cycle is detected, whether the player receives a notification, and how resolution continues after interruption. Do not treat these as locked until explicitly decided.


## 83. RULE-017 — Preserve resolved effects when terminating infinite loops (LOCKED, 2026-11-10)

**Explicit user approval:** When REDLINE detects a genuinely infinite/nonterminating trigger cycle under RULE-016, **cancel the repeating cycle** and its perpetuating triggers, **preserve all effects already resolved**, and **continue resolving unrelated pending effects** in the established FIFO trigger queue (RULE-014/015). Termination and continuation must be **deterministic**. Do not roll back legitimately resolved prevention, damage, resources, or other state changes merely because they were generated before loop detection.

**Example:** If a loop generated **10 PULP prevention** before being detected, that 10 remains; the nonterminating cycle is stopped; unrelated pending triggers continue to resolve.

**OPEN implementation detail:** The exact detection algorithm and how the engine identifies the minimal set of cycle-perpetuating queued triggers to cancel remain to be designed. The required observable behavior above is LOCKED.


## 84. RULE-018 — Notify player when infinite trigger loop is terminated (LOCKED, 2026-11-10)

**Explicit user approval:** When REDLINE detects and terminates an infinite trigger cycle under RULE-016/017, show the player a **brief, informative notification** identifying the involved cards or effects and indicating that the repeating interaction was stopped. The notification should not unnecessarily interrupt play. Previously resolved effects remain preserved, and unrelated pending triggers continue normally. Record sufficient diagnostic information to help investigate unexpected card interactions during playtesting.

**Illustrative notification:** “TRIGGER LOOP TERMINATED — Repeating interaction detected between [Card A] and [Card B]. Previously resolved effects preserved; unrelated effects continue.”

**OPEN:** Exact UI presentation, notification duration, and diagnostic log format.


## 85. RULE-019 — Repeated trigger-state detection principle (LOCKED, 2026-11-10)

**Explicit user approval:** REDLINE's infinite-loop detection must be based on **repeated trigger-state/cycle analysis**, accounting for which effects trigger one another, relevant game state, and whether the chain has a genuine termination condition. The system must distinguish **genuinely nonterminating cycles** from **finite but extremely powerful combinations**, even those producing hundreds or thousands of prevention points. **Do not impose an arbitrary numerical cap on legitimate card synergies.**

**Interaction with locked rules:** When a genuine infinite cycle is detected, terminate the perpetuating loop while preserving previously resolved effects and continuing unrelated queued effects (RULE-016/017), and notify the player of involved cards/effects (RULE-018). Respect FIFO queue ordering (RULE-015).

**OPEN for implementation:** Exact state representation, cycle-detection algorithm, proof/heuristics for termination, performance safeguards, and identification of the minimal set of perpetuating triggers. The detection **principle** is LOCKED; no particular algorithm is yet approved.


## 86. RULE-020 — Explicit card-specific trigger frequency limits (LOCKED, 2026-11-10)

**Explicit user approval:** Individual cards and abilities may specify **explicit trigger-frequency limits**, including **“Once per turn,” “Twice per Node,”** and **“The first time each turn.”** Such restrictions apply to the **specified card/ability**, not to REDLINE's trigger system globally. The engine tracks and enforces each ability's applicable count or first-occurrence condition over the printed period.

**Design intent:** These are deliberate **card-level balance and design tools**, not universal caps on stacking, multiplicative synergies, prevention values, or other legitimate interactions (RULE-007/008/016/019). Other cards and effects may still trigger normally, subject to their own text and established queue/ordering rules.

**OPEN:** Precise treatment of per-turn limits across Rustler versus Corporation turns when text says only “turn”; timing of counter reset at Node boundaries; whether copies of the same named card track limits independently (unless a card specifies otherwise). Do not assume these details are locked.


## 87. RULE-021 — Independent copies except explicit shared event/outcome limits (LOCKED, 2026-11-10)

**Explicit user approval with qualification:** Multiple installed copies of the same Software card **normally trigger independently**, and each copy tracks its own card-specific trigger frequency limit (RULE-020). For example, two installed copies each reading “Once per turn: When you play a defensive card, gain 2 PULP prevention” each trigger once, yielding **4 PULP prevention** in total.

**Explicit shared-limit exception:** If wording establishes an explicit limit on the **same event or outcome**, duplicating that wording must not compound beyond that limit. User's canonical example: two copies of “The first card you play is played twice” mean the first card is **played twice total**, **not twice and then twice more** (not four plays). A second copy cannot apply an additional doubling to that already doubled first play. Interpret “played twice” as an explicitly bounded outcome in this example, not as an unconstrained multiplicative stacking effect.

**Scope:** Do not infer shared caps where card text does not establish them; independent ordinary triggers and intended stacking remain valid. Specific text overrides generic stacking rules. **OPEN:** Exact card text conventions for expressing shared event/outcome caps versus stacking multipliers, and how repeated-play effects interact with other “when played” triggers.


## 88. RULE-022 — Replayed cards resolve each play independently (LOCKED, 2026-11-10)

**Explicit user approval:** When a card-play effect causes a card to be **played multiple times**, each actual play **resolves that card's printed instructions and applicable “when played” effects independently**, subject to explicit frequency restrictions and the existing trigger queue. Example: “The first card you play each turn is played twice” applied to “When played, gain 3 PULP prevention” grants **6 PULP prevention total**, from two separate plays.

**Compatibility:** The explicit “played twice” outcome limit remains in force under RULE-021: additional copies of the same replay-granting effect do **not** turn those two plays into four. Other applicable “when played” triggers can occur for each actual play, unless their own explicit limits (RULE-020) prevent them.

**OPEN:** Whether a replay pays the card's BW cost again, whether it counts as a new physical card leaving hand, and the exact timing of replay relative to other queued triggers. No answer is implied by this rule.


## 89. RULE-023 — Replayed cards pay BW only once (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect causes a card to be played more than once, **pay that card's BW cost only for its original play**. Any additional plays granted by the replay effect resolve the card's instructions without paying its BW cost again. For example, a **2 BW** card played twice through a replay effect costs **2 BW total, not 4 BW**, while both plays resolve independently under RULE-022.

**Compatibility:** An explicit “played twice” effect remains capped at two total plays despite duplicate sources (RULE-021). Explicit card-specific trigger-frequency limits still apply (RULE-020).

**OPEN:** Whether any **non-BW costs** must be paid again on replay, and how card-specific costs and “If you do” conditions interact with replay. Do not assume free non-BW costs.


## 90. RULE-024 — Non-BW costs paid for every replayed resolution (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect replays a card, the card's **BW cost is paid only for the original play** (RULE-023), but **each replayed resolution must independently pay any other explicit costs in full** (RULE-003). If the non-BW cost for an additional resolution cannot be paid, that resolution does not occur; any earlier completed resolutions remain valid.

**Example:** “Cost: Discard 1 card. Effect: Gain 5 PULP prevention.” Played twice via replay: discard one card for the original resolution and another card for the second; if both are paid, gain **10 PULP prevention total**. If the second discard cannot be paid, only the first resolution's 5 prevention is gained.

**Compatibility:** Explicit card-level limits (RULE-020), shared outcome limits (RULE-021), and the trigger queue (RULE-014/015) still apply. **OPEN:** Exact replay timing and whether an unpaid replay counts for play-trigger frequency or “first card played” bookkeeping.


## 91. RULE-025 — Uninterrupted replay sequence before queued triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect causes a card to be played multiple times, resolve the **entire replay sequence consecutively**, without interrupting between plays to resolve other pending triggered effects. Finish the first play completely, then the second play (and any additional plays permitted by explicit text); triggers generated during any of these plays are **enqueued** and resolve afterward according to the established FIFO ordering (RULE-014/015). This treats the granted sequence as one uninterrupted replay operation for trigger-processing purposes, while each play still independently resolves the card's instructions (RULE-022).

**Example:** A card grants 3 PULP prevention when played, and an installed Software triggers on gaining PULP prevention. If the card is played twice, the two plays first grant **6 PULP prevention** total; the triggered Software effects then resolve in queue order.

**Costs:** The original BW cost is paid only once (RULE-023); any explicit non-BW costs are independently required for each play (RULE-024). If a later replay's non-BW cost cannot be paid, that resolution fails without reversing earlier completed plays. Explicit shared “played twice” limits remain in force (RULE-021).

**OPEN:** Whether triggers already pending *before* a replay operation began can be delayed by a replay generated during a queued effect; precise event bookkeeping for unsuccessful replay attempts. Do not silently infer these edge cases.


## 92. RULE-026 — Replays do not reset explicit trigger-frequency limits (LOCKED, 2026-11-10)

**Explicit user approval:** Replaying a card does **not** reset or bypass an explicit frequency restriction printed on that card or ability, such as **“Once per turn.”** Each replay is still a separate play for other applicable effects (RULE-022), but an ability whose per-turn allowance has already been used does not activate again merely because its card is replayed.

**Canonical example:** “Once per turn: When played, gain 5 PULP prevention.” If an effect causes this card to be played twice during the same turn, the limited ability activates **once total**, granting **5 PULP prevention**, not 10.

**Compatibility:** RULE-020 (explicit per-card limits), RULE-021 (independent copies except explicit shared outcome limits), RULE-023/024 (replay costs), and RULE-025 (uninterrupted replay sequence) continue to apply. This does not introduce a universal trigger cap.

**OPEN:** Whether failed or unpaid replay attempts count as plays for frequency-limit bookkeeping; exact reset timing of limits phrased only as “per turn.”


## 93. RULE-027 — Per-turn trigger limits reset at every side's turn start (LOCKED, 2026-11-10)

**Explicit user approval:** An ability limited to **“once per turn”** (or another explicit **per-turn** frequency) refreshes its allowance at the **start of every turn**, including **both Rustler turns and Corporation turns**. A persistent ability may therefore trigger once on the Rustler turn and once on the following Corporation turn, provided the relevant trigger condition occurs in each turn.

**Example:** An installed defensive Software with a “once per turn” trigger can activate on the Rustler turn and again on the Corporation turn after its allowance resets. This does **not** permit the Rustler to play cards during the Corporation turn; existing persistent effects can trigger automatically (SOFT-011).

**Compatibility:** Explicit frequency restrictions continue to apply per ability (RULE-020), independent copies follow RULE-021, and replay does not reset a used allowance within the same turn (RULE-026). **OPEN:** Text specifying “once during your turn,” “once during the Rustler's turn,” or other narrower windows follows its explicit wording; exact turn-boundary event ordering relative to start-of-turn triggers is not yet defined.


## 94. RULE-028 — Reset per-turn allowances before start-of-turn triggers (LOCKED, 2026-11-10)

**Explicit user approval:** At the beginning of **every Rustler and Corporation turn**, first **reset all applicable per-turn trigger-frequency allowances** (RULE-027), and **then process abilities triggered at the start of that turn**. Start-of-turn abilities therefore use their freshly refreshed allowance, rather than being blocked by uses during the previous turn.

**Example:** An ability reading “Once per turn: At the start of a turn, [effect]” is eligible to trigger at the beginning of each turn after its allowance refreshes, subject to its other conditions and normal trigger ordering/queue rules.

**Compatibility:** This does not allow out-of-turn Rustler card play (SOFT-011); it concerns triggered abilities already in effect. **OPEN:** Relative ordering among multiple start-of-turn triggers follows existing controller/active-side rules (RULE-011/012/013), but timing relative to other start-of-turn housekeeping such as BW refresh, DRAW, or expiration of temporary prevention requires separate decisions.


## 95. RULE-029 — Temporary expiration before start-of-turn triggers (LOCKED, 2026-11-10)

**Explicit user approval:** At the beginning of the Rustler turn, **expire any temporary effects whose duration ends at that turn boundary before resolving start-of-turn triggered abilities**. This includes unused temporary prevention expiring at the start of the next Rustler turn under SOFT-013 and DMG-002. Such expired prevention is unavailable for start-of-turn doubling or other effects. Persistent and Node-long prevention remain governed by their distinct durations.

**Established start-of-turn ordering:** (1) Reset applicable per-turn trigger limits (RULE-028); (2) remove effects scheduled to expire at this turn start; (3) resolve start-of-turn triggered abilities using the resulting game state.

**Example:** Rustler ends the previous turn with 8 temporary PULP prevention scheduled to expire at the next Rustler turn start. Those 8 expire before a start-of-turn ability doubles current PULP prevention, so they are not doubled.

**OPEN:** Exact placement of BW refresh, DRAW, Node-long prevention refresh, and other turn-start housekeeping relative to these steps. Do not infer their order from this rule.


## 96. RULE-030 — Refresh BW before Rustler start-of-turn triggered abilities (LOCKED, 2026-11-10)

**Explicit user approval:** At the beginning of each **Rustler turn**, refresh BW to the Rustler's **full currently available amount**, including applicable modifiers to the baseline **4 BW**, **before** resolving any start-of-turn triggered abilities. Start-of-turn abilities that spend or modify BW therefore operate on freshly refreshed BW rather than the previous turn's remainder.

**Established Rustler turn-start order:** (1) reset applicable per-turn trigger-frequency allowances (RULE-028); (2) expire temporary effects scheduled to end at that Rustler turn start (RULE-029); (3) refresh BW to its full currently available amount; (4) resolve start-of-turn triggered abilities in the established priority/queue order (RULE-011 through RULE-015).

**Example:** Rustler ended the previous turn at 0 BW and has a current full available BW amount of 4. At the next Rustler turn start, BW becomes **4** before start-of-turn abilities resolve.

**OPEN:** Timing of normal DRAW and other turn-start housekeeping relative to these steps; how effects that alter maximum BW during start-of-turn resolution update available BW.


## 97. RULE-031 — Normal DRAW after start-of-turn abilities (LOCKED, 2026-11-10)

**Explicit user approval:** At the start of each Rustler turn, the Rustler's **normal starting-hand DRAW occurs after start-of-turn triggered abilities and their queued effects have finished resolving**. This allows any start-of-turn abilities that modify DRAW to affect the number of cards drawn on that same turn.

**Established Rustler turn-start sequence:** (1) reset applicable per-turn trigger-frequency allowances (RULE-028); (2) expire temporary effects scheduled to end at that Rustler turn start (RULE-029); (3) refresh BW to its full currently available amount (RULE-030); (4) resolve start-of-turn abilities and their queued triggers in established order; (5) calculate DRAW including VOID and other applicable modifiers, observing the minimum DRAW of 1; (6) draw the normal starting hand.

**Example:** Base/current DRAW is 5; a start-of-turn ability grants +2 DRAW. Once the ability resolves, the Rustler draws **7 cards** that turn.

**Compatibility:** CACHED cards remain additive to normal DRAW (SOFT-004). **OPEN:** Exact timing and handling of any effects that trigger *on drawing* or *after drawing*, and deck exhaustion/reshuffle behavior during normal DRAW.


## 98. RULE-032 — Complete normal DRAW before resolving draw-generated triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When the Rustler performs the **normal start-of-turn DRAW**, draw **all cards in that DRAW operation uninterrupted** before resolving any triggered effects generated by drawing those cards. Enqueue the resulting triggers and resolve them afterward according to established FIFO queue ordering (RULE-014/015). Individual card-draw events can each generate a trigger, but the triggers do not interrupt the ongoing normal DRAW operation.

**Canonical example:** An installed Software says “Whenever you draw a card, gain 1 PULP prevention.” With normal DRAW **5**, the Rustler first draws **all 5 cards**, then resolves **five draw-generated triggers**, gaining **5 PULP prevention total** (assuming no other modifiers or limits).

**Compatibility:** Normal DRAW occurs after start-of-turn abilities (RULE-031). Explicit per-card trigger frequency limits (RULE-020/026) still apply. **OPEN:** Whether other multi-card draw effects beyond the normal DRAW use the same uninterrupted batching convention; exact timing of draw-replacement effects, if introduced.


## 99. RULE-033 — Uninterrupted resolution of all multi-card draw effects (LOCKED, 2026-11-10)

**Explicit user approval:** Extend RULE-032 beyond normal start-of-turn DRAW: **every effect instructing a player to draw multiple cards completes its full draw operation before any triggers generated by those draws resolve**. Individual cards drawn can generate their own triggers, which enter the pending queue and resolve afterward under the existing FIFO rules (RULE-014/015). Applies to normal DRAW, Instant Software “Draw X cards,” and other multi-card draw effects.

**Example:** An Instant Software says “Draw 3 cards,” while an installed Software says “Whenever you draw a card, gain 1 PULP prevention.” Draw **all 3 cards first**, then resolve the **three** draw-generated triggers, gaining **3 PULP prevention** absent other modifiers or limits.

**Compatibility:** Explicit trigger-frequency limits (RULE-020/026) still constrain the number of activations. Effects resolve in printed order (RULE-010), so uninterrupted drawing applies to the specific multi-card draw instruction, not automatically to all instructions on a card.

**OPEN:** Replacement/prevention effects that alter the actual number of cards drawn, and handling of deck exhaustion during multi-card draws.


## 100. RULE-034 — Automatically reshuffle discard pile when draw pile empties (LOCKED, 2026-11-10)

**Explicit user approval:** When resolving a draw instruction and the **draw pile runs out**, automatically **shuffle the discard pile into a new draw pile**, then continue drawing until the instructed number of cards has been drawn or no eligible cards remain. This can occur partway through a multi-card draw. Do not terminate an otherwise fulfillable draw simply because the original draw pile is exhausted.

**Canonical example:** “Draw 3 cards” with **1 card** in the draw pile and **8 cards** in the discard pile: draw the remaining card; shuffle the eight discarded cards into a new draw pile; draw two more cards. Draw-generated triggers wait until the full multi-card draw operation completes (RULE-032/033), then resolve in FIFO order (RULE-014/015).

**No available cards:** If both draw and discard piles have no eligible cards, draw only as many as possible; the unfulfillable remainder is skipped under RULE-002. Any independent subsequent effects still resolve according to their text and existing rules.

**OPEN:** Whether any special card states or restrictions exclude specific cards from reshuffling; timing of shuffle-triggered abilities, if introduced. No additional penalties for an empty draw pile are established by this rule.


## 101. RULE-035 — Reshuffle-generated triggers wait until draw completes (LOCKED, 2026-11-10)

**Explicit user approval:** If the discard pile is automatically shuffled into the draw pile **during an ongoing draw operation** (RULE-034), the **reshuffle itself occurs immediately** to make further drawing possible, but any **triggered abilities generated by that reshuffle are queued and do not resolve until the entire draw operation finishes**. Then process pending triggers under FIFO ordering (RULE-014/015). This extends the uninterrupted draw behavior of RULE-032/033 to shuffle-generated triggers.

**Example:** An installed Software says “Whenever your discard pile is shuffled into your draw pile, gain 2 PULP prevention.” During “Draw 3 cards,” only one card remains in the draw pile: draw that card, shuffle the discard pile to replenish the draw pile, enqueue the shuffle trigger, draw the remaining two cards, then resolve queued effects. The reshuffle-triggered Software grants **2 PULP prevention** afterward.

**Compatibility:** Any card-draw triggers generated during the same draw operation also wait until it completes; FIFO ordering follows the order in which triggers entered the queue, subject to simultaneous-trigger ordering rules (RULE-011/012/013). Explicit trigger frequency limits still apply (RULE-020/026).

**OPEN:** Whether the act of shuffling itself can modify the number of cards still to draw via replacement effects, if such effects are introduced.


## 102. RULE-036 — Each actual reshuffle generates its own trigger (LOCKED, 2026-11-10)

**Explicit user approval:** When a draw operation causes **multiple actual discard-pile reshuffles**, each reshuffle is a **separate event** and independently generates any applicable “whenever you reshuffle” triggers. All reshuffle-generated triggers **wait until the full draw operation finishes** (RULE-035), then resolve according to the FIFO queue (RULE-014/015). Explicit card-specific frequency limits (RULE-020/026) still apply.

**Example:** Installed Software says “Whenever your discard pile is reshuffled into your draw pile, gain 2 PULP prevention.” If **three actual reshuffles** occur during one draw operation, three triggers are queued and later grant **6 PULP prevention total**, absent other modifiers or limits.

**Clarification:** This rule does not cause an extra reshuffle when there are no eligible cards in the discard pile; it only counts reshuffles that actually occur. The precise conditions under which repeated reshuffles can occur during a single draw remain subject to the available card zones and normal draw rules (RULE-034).


## 103. RULE-037 — No automatic penalty when draw and discard piles are empty (LOCKED, 2026-11-10)

**Explicit user approval:** If an instruction requires drawing cards but **both the draw pile and discard pile contain no eligible cards**, draw **zero cards** and **continue resolving any remaining independent instructions**. Do **not** automatically inflict Vitae damage, other damage, or any penalty merely because a draw could not be fulfilled. If some cards are available, draw as many as possible (RULE-002/034).

**Canonical example:** “Draw 3 cards. Gain 2 PULP prevention.” With both draw and discard piles empty, draw **0 cards** and still gain **2 PULP prevention**.

**Compatibility:** Explicit costs and conditional wording such as “If you do” still follow RULE-003; a card may explicitly specify a consequence for an unsuccessful draw, but there is **no universal deck-exhaustion penalty**. Automatic reshuffling applies only when the discard pile has eligible cards (RULE-034).


## 104. RULE-038 — Conditional draw rewards require full completion (LOCKED, 2026-11-10)

**Explicit user approval:** In card text of the form **“Draw X cards. If you do, [reward]”**, the **“If you do” condition is satisfied only if the full specified number X of cards was actually drawn**. If fewer cards are available, draw as many as possible under RULE-002/034/037, but do **not** grant the conditional reward under RULE-003.

**Canonical example:** “Draw 3 cards. If you do, gain 5 PULP prevention.” With only **2 eligible cards** across draw and discard piles, draw both, but **do not gain the 5 PULP prevention**.

**Contrast:** “Draw 3 cards. Gain 5 PULP prevention.” has no “If you do” condition, so the independent prevention instruction resolves even if fewer than 3 cards can be drawn (RULE-002).

**Compatibility:** Multi-card draws and their generated triggers remain uninterrupted (RULE-032/033), with automatic discard reshuffling where possible (RULE-034). This rule addresses conditional success, not a general deck-exhaustion penalty.


## 105. RULE-039 — Conditional rewards resolve before queued draw triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When a card instructs the Rustler to draw cards and then grants a conditional reward, **finish resolving the original card's printed instructions, including the conditional reward if its condition is met, before processing triggered effects generated by those draws**. Draw-generated triggers enter the FIFO queue and wait until the current effect finishes (RULE-010/014/015/033).

**Canonical example:** “Draw 3 cards. If you do, gain 5 PULP prevention.” With three cards available, draw all three uninterrupted, queue any draw-generated triggers, grant **5 PULP prevention** as the card's conditional reward, then resolve queued triggers in FIFO order. If fewer than three cards are drawn, the reward is not granted (RULE-038), but triggers generated by cards actually drawn still resolve after the original card finishes.

**Scope:** This establishes ordering between an original card's subsequent printed instructions and triggers generated during its draw. It does not change the explicit frequency limits or the distinction between unconditional and conditional instructions (RULE-002/003).


## 106. RULE-040 — Draw replacement effects apply before draw events (LOCKED, 2026-11-10)

**Explicit user approval:** Card text such as **“Whenever you would draw a card, you may gain 2 PULP prevention instead”** is a **replacement effect**, not an ordinary after-the-fact trigger. Before the affected draw event occurs, the Rustler chooses whether to **draw that card normally** or **replace that draw with 2 PULP prevention**. If replaced, the card is not drawn, and effects that trigger upon **actually drawing** a card do not trigger from that replaced event.

**Timing:** Replacement choices are made **before each applicable draw event**, including during multi-card draws. They modify whether the event happens, and are therefore distinct from queued triggers. Ordinary draw-generated and reshuffle-generated triggers still wait until the uninterrupted draw operation finishes (RULE-032/033/035); allowing replacement choices does not authorize interrupting the draw operation to resolve queued triggers.

**OPEN:** How multiple simultaneous replacement effects interact or are ordered; whether a replaced draw counts as satisfying “Draw X cards. If you do” (not established here); and the treatment of mandatory rather than optional replacement text. Do not infer those edge cases without approval.


## 107. RULE-041 — Replaced draws do not satisfy conditional draw requirements (LOCKED, 2026-11-10)

**Explicit user approval:** If a **draw replacement effect** substitutes another benefit for one or more instructed draws, the replaced events **do not count as cards actually drawn** when checking whether an instruction such as **“Draw X cards. If you do, [reward]”** was completed. The conditional reward requires **X actual cards drawn**, consistent with RULE-038. Replacement benefits still apply normally (RULE-040).

**Canonical example:** “Draw 3 cards. If you do, gain 5 PULP prevention.” The Rustler replaces one of the three draws with **2 PULP prevention**, and actually draws the other two cards. Result: **2 cards drawn**, **2 PULP prevention** from the replacement, and **no 5 PULP prevention conditional reward**, because the full draw instruction was not satisfied.

**Compatibility:** Draw-generated triggers only arise from cards actually drawn (RULE-040); the multi-card draw operation otherwise remains uninterrupted and its queued triggers resolve afterward (RULE-033/039). **OPEN:** Interaction among multiple competing replacement effects for the same would-be draw event.


## 108. RULE-042 — Choose one competing draw replacement per event (LOCKED, 2026-11-10)

**Explicit user approval:** When **multiple optional replacement effects** could replace the **same would-be card draw**, the Rustler chooses **at most one** of those replacement effects for that draw. The Rustler may instead choose to **draw the card normally**. Applying one replacement consumes/replaces that draw event; the other replacement effects cannot also claim benefits from that same draw.

**Canonical example:** Installed Card A: “Whenever you would draw a card, you may gain 2 PULP prevention instead.” Installed Card B: “Whenever you would draw a card, you may gain 1 BW instead.” For each would-be draw, choose exactly one of: (a) actually draw one card; (b) gain **2 PULP prevention** instead; or (c) gain **1 BW** instead. **Never gain both replacement benefits for the same draw.**

**Multiple-card draws:** Make the replacement choice independently for **each individual would-be draw**, while preserving uninterrupted resolution of the overall draw operation and deferring ordinary triggers until afterward (RULE-033/040).

**Compatibility:** A replaced draw does not count as a card actually drawn for conditional draw rewards (RULE-041). **OPEN:** Mandatory replacement effects and precedence between mandatory and optional replacements, if introduced.


## 109. RULE-043 — Mandatory draw replacements take priority over optional replacements (LOCKED, 2026-11-10)

**Explicit user approval:** When a **mandatory** draw replacement and an **optional** draw replacement are both applicable to the same would-be draw, the **mandatory replacement takes priority**, unless other card text **explicitly overrides** that precedence. A replacement reading **“Whenever you would draw a card, gain 2 PULP prevention instead”** (without “may”) is mandatory. The Rustler cannot elect to draw normally or choose a competing optional replacement while the mandatory replacement applies.

**Canonical example:** Card A (mandatory): “Whenever you would draw a card, gain 2 PULP prevention instead.” Card B (optional): “Whenever you would draw a card, you may gain 1 BW instead.” For the affected draw, apply Card A and gain **2 PULP prevention**; do **not** draw the card or gain Card B's optional **1 BW**, absent explicit override text.

**Compatibility:** Only one replacement benefit applies to a single draw event (RULE-042). Replaced draws do not count as actual cards drawn for conditional rewards (RULE-041). Replacement effects occur before the affected draw rather than as queued post-draw triggers (RULE-040).

**OPEN:** Ordering/selection when **multiple mandatory replacements** compete for the same draw event, and the exact meaning and resolution of explicit priority overrides.


## 110. RULE-044 — Rustler chooses between competing mandatory draw replacements (LOCKED, 2026-11-10)

**Explicit user approval:** If **two or more mandatory draw replacement effects** apply to the **same would-be draw event**, the **Rustler chooses exactly one** of the competing mandatory replacements to apply. The unchosen mandatory replacements do not produce benefits from that draw. Because a mandatory replacement applies, the Rustler cannot choose to perform the original draw normally, absent explicit overriding card text.

**Canonical example:** Installed Card A: “Whenever you would draw a card, gain 2 PULP prevention instead.” Installed Card B: “Whenever you would draw a card, gain 1 BW instead.” For each would-be draw, the Rustler chooses **either 2 PULP prevention or 1 BW**, **not both**, and does not draw the card.

**Compatibility:** Mandatory replacements have priority over optional replacements (RULE-043), only one replacement applies per draw (RULE-042), and replaced draws do not count as actually drawn for conditional rewards (RULE-041). The decision occurs before the affected draw event (RULE-040).

**OPEN:** How an explicit card-text priority override affects selection among multiple mandatory replacements; interaction with replacement effects that change rather than fully substitute a draw.


## 111. RULE-045 — Draw replacements require an available drawable card (LOCKED, 2026-11-10)

**Explicit user decision:** Rejected the proposal that a “whenever you would draw” replacement can grant its substitute benefit when both draw and discard piles have no eligible cards. Approved the interpretation that **only would-be draws for which an eligible card is actually available may be replaced**. A draw instruction that cannot be fulfilled due to lack of eligible cards **does not generate a replacement benefit**.

**Canonical example:** “Draw 3 cards,” with only **2 eligible cards** available across draw and discard piles, and an installed Software allowing each draw to be replaced with **2 PULP prevention**. The Rustler may (a) draw both cards, (b) replace one available draw to draw one card and gain 2 PULP prevention, or (c) replace both available draws to gain 4 PULP prevention and draw zero cards. The **third, unavailable draw cannot be replaced** and generates no prevention.

**Compatibility:** This restriction applies to both mandatory and optional draw replacement effects (RULE-040/042/043/044). A replaced draw is not counted as an actual card drawn for conditional “If you do” rewards (RULE-041). Unavailable draws carry no automatic deck-exhaustion penalty (RULE-037). Normal discard reshuffling may supply available cards (RULE-034). **OPEN:** How to test availability if a replacement itself moves cards among zones or changes deck composition.


## 112. RULE-046 — Draw availability includes discard pile for replacements (LOCKED, 2026-11-10)

**Explicit user approval:** For purposes of checking whether a would-be draw is eligible for a draw replacement (RULE-045), **available drawable cards include eligible cards in both the draw pile and the discard pile**, because the discard pile can normally be reshuffled into the draw pile when needed (RULE-034). A replacement may apply when the draw pile is empty but the discard pile contains eligible cards. If both piles are empty, no replacement benefit can be generated.

**Canonical example:** Replacement Software: “Instead of drawing a card, shuffle one card from your discard pile into your draw pile.” If the draw pile is empty and the discard pile contains at least one eligible card, the replacement **can activate** and move the card as instructed instead of drawing. If both piles are empty, the replacement cannot activate.

**Compatibility:** Replaced draws do not count as actual draws for conditional draw completion or draw triggers (RULE-040/041). This rule establishes the **availability test**, not any new permission to generate benefits from impossible draws.

**OPEN:** Whether checking availability for a replacement with an empty draw pile itself triggers an automatic full-discard reshuffle before the replacement resolves; distinguish that from a replacement that explicitly moves cards from discard.


## 113. RULE-047 — Resolve draw replacement choice before automatic reshuffling (LOCKED, 2026-11-10)

**Explicit user approval:** When the draw pile is empty but the discard pile contains eligible cards, **check draw availability across both piles** (RULE-046), then **resolve applicable draw replacement choices before performing an automatic discard-to-draw reshuffle**. If the Rustler replaces the draw, **do not perform an automatic reshuffle for that replaced event**. If the Rustler proceeds with the actual draw, **reshuffle the discard pile into the draw pile** under RULE-034 and then draw. An explicit replacement effect that itself moves or shuffles cards resolves according to its own text; that is distinct from an automatic reshuffle.

**Canonical example:** Draw pile empty; discard pile contains 5 cards; installed Software reads “Whenever you would draw a card, you may gain 2 PULP prevention instead.” The Rustler may choose **2 PULP prevention** and **no automatic reshuffle occurs**, hence no automatic reshuffle trigger from this draw. Alternatively, the Rustler may draw normally, triggering the automatic reshuffle and then drawing the card.

**Compatibility:** No replacement benefit if both piles lack eligible drawable cards (RULE-045). Replaced draws do not trigger on-draw effects or satisfy conditional draw counts (RULE-040/041). Automatic reshuffle triggers, when an actual reshuffle occurs, are queued according to RULE-035/036.

**OPEN:** Ordering among explicit shuffle/move effects that change availability mid multi-card draw.


## 114. RULE-048 — Recalculate card availability before each draw in multi-card instructions (LOCKED, 2026-11-10)

**Explicit user approval:** During a multi-card draw instruction (such as “Draw 3 cards”), **recalculate the availability of eligible drawable cards before each individual would-be draw**, accounting for changes to draw and discard piles caused by prior replacements in that same instruction. A replacement that returns a card to the draw pile can therefore make that card eligible for a **subsequent draw** in the same instruction, even when the initial pile sizes would not have supported that later draw.

**Canonical example:** The draw pile initially contains **1 card**, the discard pile is empty, and installed Software says “Whenever you would draw a card, you may return 1 card from your hand to the draw pile instead.” The Rustler may replace an eligible first draw by returning a card from hand to the draw pile. The updated draw pile is checked for the next would-be draw, allowing that card to be drawn or otherwise handled according to applicable replacement rules. Reassess availability for each further draw.

**Compatibility:** Draw replacement requires an available drawable card at the time of the individual draw (RULE-045), including eligible cards in discard (RULE-046); replacement choices precede automatic reshuffling (RULE-047). A replaced draw is not an actual draw for draw triggers or conditional full-draw rewards (RULE-040/041). Normal multi-card draw instructions remain uninterrupted by queued ordinary triggers (RULE-033/039).

**OPEN:** Whether cards returned to the draw pile by replacement are placed on top, bottom, or shuffled in, unless specified by card text; how multiple effects modify availability during a single draw event.


## 115. RULE-049 — Draw-pile insertion destination must be explicit (LOCKED, 2026-11-10)

**Explicit user direction:** Every card effect that **returns, moves, or inserts a card into the draw pile** must explicitly state **where** that card goes: **top of the draw pile**, **bottom of the draw pile**, or **shuffled into the draw pile**. **There is no default placement** for card effects.

**Invalid/unfinished wording:** “Instead of drawing a card, return 1 card from your hand to your draw pile.” This does not specify placement and must be corrected during card design rather than silently interpreted by the engine.

**Valid example:** “Instead of drawing a card, return 1 card from your hand to the **top** of your draw pile.” Other effects may explicitly specify the **bottom** or instruct the player to **shuffle** the card into the draw pile.

**Compatibility:** Replacement effects can change draw availability for subsequent individual draws within a multi-card draw instruction (RULE-048). This rule does not alter the separate automatic reshuffle of the discard pile when drawing from an empty draw pile (RULE-034/047).

**Implementation guidance:** Card definitions and validation should reject or flag draw-pile movement effects without an explicit destination.


## 116. RULE-050 — Shuffling into an empty draw pile incorporates the discard pile (REVISED, LOCKED, 2026-11-10)

**Explicit user revision:** When an effect instructs the Rustler to **shuffle one or more specified cards into an empty draw pile**, first include **all cards from the discard pile** together with the incoming specified cards, then shuffle the combined cards into the draw pile **as one shuffle event**. The discard pile becomes empty. This **replaces the original RULE-050** that kept discard cards untouched.

**Canonical example:** “Return 1 card from your hand and shuffle it into your draw pile.” With an empty draw pile and **5 cards in discard**, combine the 5 discarded cards and the 1 returned card, then shuffle them together as **one shuffle event**. The draw pile contains **6 cards**, and discard contains **0**.

**Scope:** This applies specifically when card text explicitly instructs a **shuffle into an empty draw pile**. It does not change the explicit top/bottom/shuffle destination requirement (RULE-049), the automatic reshuffle procedure for actual draws (RULE-034), or the replacement-before-automatic-reshuffle timing (RULE-047). See RULE-051 for trigger accounting.


## 117. RULE-051 — Combined empty-pile shuffle counts as one shuffle event (LOCKED, 2026-11-10)

**Explicit user approval of aligned RULE-050/051:** When shuffling one or more incoming cards into an **empty draw pile** with cards in discard, the discard cards and incoming cards are **combined first**, then shuffled together in **one operation**. This counts as **one shuffle event**, not separate discard-reshuffle and incoming-card-shuffle events.

**Trigger consequences:** An effect that triggers “Whenever you shuffle your draw pile” sees **one shuffle** and triggers once (subject to card-specific limits). A trigger explicitly requiring a **discard-pile reshuffle** must be evaluated according to its wording; do not silently equate all shuffle trigger conditions. Any resulting triggers follow the existing queue and resolution rules (RULE-014/015/035/036).

**Compatibility:** RULE-050 (revised) establishes card movement; RULE-051 establishes single-event accounting. No automatic shuffle is implied when a card is placed explicitly on the top or bottom of the draw pile instead of being shuffled (RULE-049).


## 118. RULE-052 — Combined shuffle qualifies as discard-pile reshuffle trigger (LOCKED, 2026-11-10)

**Explicit user approval:** When the discard pile is incorporated into an empty draw pile as part of the combined shuffle established by revised RULE-050 and RULE-051, the operation **qualifies as a discard-pile reshuffle** for effects reading “Whenever you reshuffle your discard pile into your draw pile.” It produces **one shuffle event** and therefore **one such trigger** per qualifying effect, subject to any explicit card-specific frequency restrictions.

**Canonical example:** Draw pile empty, discard pile has 5 cards; Rustler shuffles 1 card from hand into the draw pile. All 6 cards are combined and shuffled together once; discard becomes empty. Installed Software “Whenever you reshuffle your discard pile into your draw pile, gain 2 PULP prevention” **triggers once**, granting **2 PULP prevention**.

**Compatibility:** This is one event, not a discard reshuffle followed by a separate shuffle (RULE-051). Apply ordinary trigger queuing and timing (RULE-014/015/035/036). The specific discard-reshuffle trigger requires that cards actually be incorporated from discard; merely shuffling a card into an empty draw pile when discard is empty does not meet that wording.


## 119. RULE-053 — General draw-pile shuffle differs from discard-pile reshuffle (LOCKED, 2026-11-10)

**Explicit user approval:** An instruction to **shuffle a card into the draw pile** counts as **one general draw-pile shuffle event** even if the draw pile was empty and the resulting draw pile contains only one card. However, this does **not** qualify as a **discard-pile reshuffle** unless at least one card was actually incorporated from the discard pile.

**Canonical example:** Draw pile **0**, discard pile **0**; card says “Shuffle 1 card from your hand into your draw pile.” The resulting draw pile contains **1 card**. Effects reading “Whenever you shuffle your draw pile” trigger **once**; effects reading “Whenever you reshuffle your discard pile into your draw pile” do **not** trigger.

**Compatibility:** When discard cards actually participate in the combined shuffle under RULE-050/051, discard-reshuffle triggers qualify (RULE-052). One shuffle operation is still only one shuffle event; apply ordinary trigger queue and card-specific frequency limits.


## 120. RULE-054 — One shuffle event may satisfy multiple trigger conditions (LOCKED, 2026-11-10)

**Explicit user approval:** A **single shuffle event** may simultaneously satisfy **multiple distinct trigger conditions**. Each eligible installed ability triggers once for that event, subject to its own card-specific frequency limits. This does **not** multiply the number of shuffle events. If the abilities are Rustler-controlled and simultaneous, the **Rustler chooses their resolution order** (RULE-011), with the existing trigger queue applying (RULE-014/015).

**Canonical example:** Installed Card A: “Whenever you shuffle your draw pile, gain 2 PULP prevention.” Installed Card B: “Whenever you reshuffle your discard pile into your draw pile, gain 1 BW.” The Rustler performs a **combined shuffle under revised RULE-050** incorporating cards from discard. This is **one shuffle event** (RULE-051), qualifying both as a general draw-pile shuffle (RULE-053) and as a discard-pile reshuffle (RULE-052). **Both Card A and Card B trigger once**, granting **2 PULP prevention** and **1 BW** respectively; the Rustler chooses their order of resolution.

**Scope:** This does not imply that an ability can trigger multiple times from the same event merely because its condition is described in multiple ways.


## 121. RULE-055 — Separate abilities on one card independently trigger (LOCKED, 2026-11-10)

**Explicit user approval:** When a **single installed Software card** has **multiple separately written triggered abilities**, evaluate each ability **independently** against a qualifying event. If the event satisfies multiple abilities, **each triggers once** (subject to its own explicitly stated frequency limit), even though they appear on the **same card**. Rustler-controlled simultaneous triggers are ordered by the Rustler (RULE-011) and otherwise follow the established trigger queue (RULE-014/015).

**Canonical example:** One Software card has both “Whenever you shuffle your draw pile, gain 2 PULP prevention” and “Whenever you reshuffle your discard pile into your draw pile, gain 1 BW.” A combined shuffle that incorporates discard cards (RULE-050/051/052/053) satisfies **both** abilities. They each trigger **once**, granting **2 PULP prevention** and **1 BW**, with the Rustler choosing resolution order.

**Compatibility:** A single event can qualify multiple distinct abilities (RULE-054), including when those abilities share a card. This does not allow one individual ability to trigger multiple times from the same single event, and explicit “once per turn” or other card-specific limits still apply (RULE-020).


## 122. RULE-056 — Explicit shared trigger limits override independent abilities (LOCKED, 2026-11-10)

**Explicit user approval:** When a card explicitly groups multiple triggered abilities under a **shared limit** such as **“Once per turn, choose one”**, that shared restriction overrides the default independence of separately written abilities (RULE-055). Even when one event qualifies for multiple listed triggers, the controller may choose **only one qualifying benefit** for that event, and doing so consumes the **shared once-per-turn allowance**. The other grouped benefit does not activate.

**Canonical example:** One installed Software reads: “Once per turn, choose one: (a) Whenever you shuffle your draw pile, gain 2 PULP prevention; (b) Whenever you reshuffle your discard pile into your draw pile, gain 1 BW.” A combined shuffle involving discard cards satisfies both conditions, but the Rustler chooses **either 2 PULP prevention or 1 BW**, **not both**. The shared limit is then used for that turn.

**Compatibility:** Independently written abilities trigger separately by default (RULE-055); explicit shared limits override this (RULE-020). The per-turn shared allowance resets under RULE-027/028. Shuffle event classification remains governed by RULE-050–054.


## 123. RULE-057 — Shared trigger limits tracked independently per installed copy (LOCKED, 2026-11-10)

**Explicit user approval:** Each **installed instance** of a Software card has its **own allowance** for an explicit grouped/shared trigger restriction such as **“Once per turn, choose one”** (RULE-056). Multiple copies may each select one eligible benefit when the same event qualifies, unless the card explicitly imposes a **global/shared-across-copies** limit.

**Canonical example:** The Rustler installs **two copies** of Software reading: “Once per turn, choose one: (a) Whenever you shuffle your draw pile, gain 2 PULP prevention; (b) Whenever you reshuffle your discard pile into your draw pile, gain 1 BW.” A combined shuffle incorporating discard cards qualifies for both options on each copy. Each copy independently chooses **one** option, allowing a total of **4 PULP prevention**, **2 BW**, or **2 PULP prevention plus 1 BW**. Both copies' own once-per-turn allowances are then consumed.

**Compatibility:** Independent per-copy triggers are consistent with RULE-021; shared limits within each copy follow RULE-056; explicit global restrictions override per-copy allowances. Per-turn allowances reset under RULE-027/028, and simultaneous Rustler-controlled triggers follow RULE-011.


## 124. RULE-058 — Explicit global trigger limits shared across all installed copies (LOCKED, 2026-11-10)

**Explicit user approval:** When card text explicitly imposes a **global trigger-frequency restriction across all installed copies of that card**, all those copies share **one allowance**, rather than each copy having an independent activation. The global restriction overrides the default per-copy trigger allowances (RULE-021/057) only when stated explicitly.

**Canonical example:** Software reads: “Once per turn, across all installed copies of this card, whenever you shuffle your draw pile, gain 2 PULP prevention.” The Rustler has **three installed copies** and performs a qualifying shuffle. The effect activates **once total**, granting **2 PULP prevention**, **not 6**. The shared allowance is consumed for all three copies until the per-turn reset.

**Compatibility:** Per-copy trigger limits remain the default (RULE-057); explicit shared limits within a card remain governed by RULE-056. Per-turn reset follows RULE-027/028. Multiple different abilities may still qualify from one event unless limited by explicit text (RULE-054/055).


## 125. RULE-059 — Installing new copies does not reset a consumed global trigger limit (LOCKED, 2026-11-10)

**Explicit user approval:** A globally shared trigger-frequency allowance belongs to the **card's shared ability across all installed copies**, not to any particular installed instance. If the global allowance has already been consumed during the current turn, **installing another copy of that card later in the same turn does not restore or reset the allowance**. The newly installed copy inherits the consumed state until the normal per-turn reset (RULE-027/028).

**Canonical example:** One installed Software has “Once per turn, across all installed copies of this card, whenever you shuffle your draw pile, gain 2 PULP prevention.” A shuffle activates it once for **2 PULP prevention**. The Rustler then installs a second copy and shuffles again during the same turn. **No second activation** occurs, because the shared global allowance remains consumed.

**Compatibility:** Explicit global limits override per-copy limits (RULE-058), while ordinary independent per-copy limits remain the default (RULE-057). The global allowance resets at the beginning of each turn under RULE-027/028.

**OPEN:** Whether a globally consumed limit persists if all copies leave play and another copy is installed later in the same turn.


## 126. RULE-060 — Global trigger limits persist after all copies leave play (LOCKED, 2026-11-10)

**Explicit user approval:** A globally shared trigger-frequency allowance is tracked by **card identity for the full turn**, even if **all installed copies leave play**. Uninstalling every copy and later installing another copy of the same card during that turn **does not reset a consumed global allowance**. The normal turn-start reset remains the only default reset (RULE-027/028), unless explicit card text provides otherwise.

**Canonical example:** A globally once-per-turn shuffle ability triggers once. The Rustler uninstalls all copies of that Software, then installs another copy in the same turn and shuffles again. The ability **does not trigger again** because its global allowance remains consumed.

**Compatibility:** Global limits are shared across copies (RULE-058), and installing a new copy does not reset a consumed allowance (RULE-059). This rule clarifies that the consumed state persists even across a period with zero installed copies.

**OPEN:** How globally limited abilities distinguish separate card identities or upgraded/modified variants when their names match.


## 127. RULE-061 — PATCHWORK modifications preserve card identity for global trigger limits (LOCKED, 2026-11-10)

**Explicit user approval:** A **PATCHWORK modification** changes properties or abilities of an individual card instance but **does not change its underlying card identity** for the purposes of global trigger-frequency restrictions. Standard and PATCHWORK-modified copies of the same original Software card therefore **share the same global activation allowance** for a globally limited ability they retain.

**Canonical example:** Copy A is standard Software; Copy B is a PATCHWORK-modified copy of that same Software with an additional ability. Both retain the same globally once-per-turn shuffle ability. If either copy activates that shared ability, its **global allowance is consumed for both copies** until the ordinary turn-start reset (RULE-027/028), even though one copy is modified. Copy B's additional PATCHWORK ability is governed by its own text and limits.

**Compatibility:** Global limits apply across copies (RULE-058), survive installation changes (RULE-059/060), and track underlying card identity rather than PATCHWORK variant. This does not establish a shared limit for distinct additional abilities unless their text explicitly creates one.

**OPEN:** Identity rules for cards transformed into a different named/base card, if such mechanics are introduced.


## 128. RULE-062 — PATCHWORK augments original abilities and inherits their restrictions (REVISED, LOCKED, 2026-11-10)

**Explicit user correction superseding the original RULE-062:** PATCHWORK is an **augmentation/extension of the card's original ability**, not a separate independent trigger system. **Any restrictions applying to the original ability also apply to its PATCHWORK enhancement**, including once-per-turn, per-card, shared, and global-across-copies activation limits. PATCHWORK cannot circumvent an already-consumed original trigger allowance.

**Canonical example:** Original Software ability: “Once per turn, across all installed copies of this card, whenever you shuffle your draw pile, gain 2 PULP prevention.” PATCHWORK augments that ability with **+1 PULP prevention**. A qualifying shuffle with an available shared global allowance activates the modified card's ability for **3 PULP prevention** (2 original + 1 PATCHWORK). Once the shared global allowance is consumed, neither the original portion nor its PATCHWORK augmentation can activate again during that turn.

**Compatibility:** PATCHWORK preserves original card identity (RULE-061). Global restrictions continue to apply across copies (RULE-058–060). The general independence of separately printed abilities (RULE-055) does **not** exempt PATCHWORK augmentations from restrictions attached to the original ability they modify.

**Design clarification:** If a future PATCHWORK effect is intended to create an entirely new, separately limited ability rather than augment the existing ability, that exception requires explicit design approval; do not infer independence by default.


## 129. RULE-063 — Rustler selects which differently modified copy uses a shared global activation (LOCKED, 2026-11-10)

**Explicit user approval:** When multiple installed copies of the **same underlying Software card** share a **global trigger activation allowance**, but differ in their **PATCHWORK enhancements**, the **Rustler chooses which eligible installed copy's ability resolves** on a qualifying event. Resolve the selected copy's original ability together with its PATCHWORK augmentation, then consume the **single global allowance for all copies**. Other copies do not also resolve that globally restricted ability for the same event.

**Canonical example:** Copy A is unmodified and grants **2 PULP prevention** on a qualifying shuffle; Copy B has PATCHWORK augmenting the same ability to grant **5 PULP prevention**. Both share a global once-per-turn limit. On a qualifying shuffle with the allowance available, the Rustler chooses **either 2 PULP prevention (A) or 5 PULP prevention (B)**, not both. The global allowance is then consumed for all copies until reset.

**Compatibility:** Global restrictions apply across installed copies (RULE-058–060), PATCHWORK preserves identity (RULE-061) and inherits restrictions of the augmented ability (revised RULE-062). The choice of instance determines the modified outcome, not an additional activation.


## 130. RULE-064 — Only eligible installed copies can activate PATCHWORK-enhanced abilities (LOCKED, 2026-11-10)

**Explicit user approval:** When multiple copies of the same Software card share a global activation limit, the Rustler may select **only an eligible installed copy** to resolve the globally limited ability. A PATCHWORK-modified copy in the discard pile or another inactive zone cannot be selected to provide its enhanced effect, **unless explicit card text permits activation from that zone**.

**Canonical example:** Copy A is standard Software, **installed**, and its qualifying shuffle ability grants **2 PULP prevention**. Copy B is PATCHWORK-modified Software, **in the discard pile**, and would grant **5 PULP prevention** if installed. A qualifying shuffle occurs. Only Copy A is eligible to activate, granting **2 PULP prevention** and consuming the shared global allowance. Copy B's enhanced benefit is unavailable while it remains in discard.

**Compatibility:** Rustler chooses among eligible differently modified copies for a shared global activation (RULE-063). PATCHWORK preserves original card identity and inherits original restrictions (RULE-061/062); global limits remain shared across copies (RULE-058–060). Zone-specific exceptions require explicit text.


## 131. RULE-065 — Installing PATCHWORK-enhanced copies does not reset consumed global limits (LOCKED, 2026-11-10)

**Explicit user approval:** Installing a **PATCHWORK-enhanced copy** of Software during a turn does **not** restore an already-consumed **globally shared trigger allowance** for the original ability it augments. The stronger modified benefit is unavailable until the global allowance resets normally, even if the enhanced copy was not installed when the allowance was first consumed.

**Canonical example:** Installed standard Copy A activates a globally once-per-turn shuffle ability for **2 PULP prevention**. Later in the same turn, the Rustler installs PATCHWORK-enhanced Copy B, whose version of that same ability would grant **5 PULP prevention**. A second qualifying shuffle occurs. **Copy B does not activate**; the global allowance was consumed by Copy A. At the normal start-of-turn reset, the allowance becomes available again and the Rustler may select an eligible installed copy.

**Compatibility:** Global limits are shared across copies (RULE-058), persist across later installation (RULE-059) and complete uninstallation (RULE-060), PATCHWORK preserves identity (RULE-061) and inherits original restrictions (revised RULE-062), and only eligible installed copies can be selected (RULE-064). Reset timing follows RULE-027/028.


## 132. RULE-066 — Temporary removal and return does not reset activation limits (LOCKED, 2026-11-10)

**Explicit user approval:** When a PATCHWORK-enhanced Software card **temporarily leaves play and returns during the same turn**, any previously consumed **once-per-turn or applicable shared activation allowance remains consumed**. Temporary removal and re-entry do not create a fresh card identity or refresh activation eligibility. The PATCHWORK augmentation and original ability share the same restriction (RULE-062).

**Canonical example:** An installed Software card has “Once per turn, whenever you shuffle your draw pile, gain 2 PULP prevention,” augmented by PATCHWORK to grant **5 PULP prevention** on activation. It activates once, is temporarily removed from play by ICE, and returns installed in the same turn. On another qualifying shuffle that turn, **it cannot activate again**. Its allowance resets only at the normal turn reset.

**Compatibility:** PATCHWORK preserves underlying identity (RULE-061); restrictions extend to augmentation (RULE-062); installation cannot reset consumed global limits (RULE-059/065). Normal per-turn reset follows RULE-027/028. Explicit card text may define an exception.


## 133. RULE-067 — Full-card temporary copies inherit PATCHWORK enhancements (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect explicitly **copies the entire PATCHWORK-enhanced Software card**, its temporary copy inherits the original card's **modified abilities and PATCHWORK augmentation**. The temporary copy is a distinct card instance and has its **own per-copy once-per-turn activation allowance**. Restrictions attached to the copied ability still apply to its augmentation; an explicitly **global limit across all copies** remains shared rather than becoming independent.

**Canonical example:** Original Software: “Once per turn, whenever you shuffle your draw pile, gain 2 PULP prevention.” PATCHWORK augments that benefit to **5 PULP prevention**. An effect creates a temporary full-card copy. Both original and temporary copy have the **5 PULP prevention** ability, and each may activate **once per turn**, provided each is otherwise eligible. If instead the ability says “once per turn, across all copies,” both share the **single global allowance**.

**Scope:** Copying the card's modified characteristics does not award an additional permanent PATCHWORK upgrade. Duration, disposition and zone of the temporary copy follow the creating effect, to be specified by that effect.

**Compatibility:** PATCHWORK is an extension of the original ability and inherits restrictions (RULE-062); only eligible installed Software copies activate installed abilities (RULE-064); per-copy vs global limits follow RULE-021/058–060.


## 134. RULE-068 — Newly created temporary copies start with unused per-copy activation allowances (LOCKED, 2026-11-10)

**Explicit user approval:** A **new temporary full-card copy** of PATCHWORK-enhanced Software is a **new card instance** with its own **unused per-copy once-per-turn activation allowance**, even if the original Software card already activated that ability earlier in the same turn. The temporary copy inherits the card's PATCHWORK-modified ability but **does not inherit the original instance's activation history**. Explicit **global limits across all copies remain shared** and are not reset by copying.

**Canonical example:** Original PATCHWORK-enhanced Software grants **5 PULP prevention once per turn** when the Rustler shuffles the draw pile. The original activates once. Later in the same turn, an effect creates a new temporary full-card copy. On a further qualifying shuffle, the new eligible temporary copy **may activate for 5 PULP prevention**; the original may not activate again. If the printed ability instead states “once per turn, across all copies,” the already-consumed global allowance prevents the new copy from activating.

**Compatibility:** Full-card copies inherit PATCHWORK enhancements (RULE-067); PATCHWORK enhancements inherit original restrictions (RULE-062); new copies are distinct instances for per-copy limits (RULE-021), but global limits persist across copies and installations (RULE-058–060). Temporary removal and return of the *same* instance does not refresh its allowance (RULE-066).


## 135. RULE-069 — Copied triggered abilities include PATCHWORK modifications (LOCKED, 2026-11-10)

**Explicit user approval:** An effect that says **“Copy the triggered ability of one installed Software card. Resolve the copied ability”** copies the **currently PATCHWORK-modified ability**, not merely the unmodified printed ability. Resolving the copied ability does **not create another Software card**, does **not consume an additional activation of the original ability**, and does **not reset the original card's activation allowance**. The copy effect resolves that copied ability **once** as instructed.

**Canonical example:** An installed Software card's triggered ability normally grants **2 PULP prevention**; PATCHWORK augments that ability to **5 PULP prevention**. An effect copies and resolves that triggered ability. The copied resolution grants **5 PULP prevention**. The original card's activation history is unchanged by the copy effect.

**Distinction:** Copying an **ability** does not create a new card instance or fresh per-copy allowance. Copying an **entire card** creates a new instance with inherited PATCHWORK and its own per-copy allowance (RULE-067/068). PATCHWORK remains an extension of the original ability (revised RULE-062).

**Scope note:** This rule addresses an effect explicitly instructing a copied ability to resolve; it does not establish that copying an ability grants permission to repeatedly activate the original restricted trigger.


## 136. RULE-070 — Explicit copied-ability resolution works after original limit consumed (LOCKED, 2026-11-10)

**Explicit user approval:** An effect that explicitly instructs the Rustler to **copy a triggered ability of an installed Software card and resolve the copied ability** may do so **even when the original card's once-per-turn activation allowance has already been consumed**. The copied resolution uses the **PATCHWORK-enhanced ability** (RULE-069). It is a resolution directed by the copy effect, **not another activation of the original trigger**; the original allowance remains consumed and is not reset.

**Canonical example:** Installed Software has a PATCHWORK-enhanced ability: “Once per turn, whenever you shuffle your draw pile, gain **5 PULP prevention**.” The original ability has already activated this turn. The Rustler plays an effect: “Copy the triggered ability of one installed Software card. Resolve the copied ability.” That copied resolution still grants **5 PULP prevention**, and the original card cannot activate its own once-per-turn ability again until its normal reset.

**Scope:** This permission requires an effect that **explicitly copies and resolves** the ability. Merely creating another qualifying trigger event does not bypass original limits. Copying an ability does not create a new Software card or fresh card-instance allowance (RULE-069), and PATCHWORK otherwise inherits restrictions of the original ability (RULE-062).


## 137. RULE-071 — Copied abilities retain costs (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect explicitly **copies and resolves an installed Software card's triggered ability**, the copied ability retains **all costs required for its benefit**, including costs in its PATCHWORK-enhanced version. The Rustler must pay such costs in full for the copied resolution to grant the associated benefit. If the cost cannot be paid, the associated benefit is not granted. Copying the ability does not waive costs or consume an additional activation of the original ability.

**Canonical example:** PATCHWORK-enhanced Software reads: “Once per turn, when you shuffle your draw pile, you may **discard 1 card** to gain **5 PULP prevention**.” Another card says: “Copy the triggered ability of one installed Software card. Resolve the copied ability.” The Rustler must discard **1 card** to gain **5 PULP prevention** from the copy. If unable or unwilling to pay that cost, the copied resolution grants **no PULP prevention**. The original card's activation allowance is unchanged by the copied resolution.

**Compatibility:** Costs must be fully paid (RULE-003); copied triggered abilities include PATCHWORK enhancements (RULE-069); explicit copied resolutions are permitted even when the original activation allowance is consumed (RULE-070). The copied effect follows its own text without treating the original ability as activated again.


## 138. RULE-072 — Copied abilities resolve complete instructions in original order (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect **copies and resolves a Software triggered ability**, it copies **all instructions of the complete PATCHWORK-enhanced ability** and executes them **in their original printed/modified order**, using the **current game state** at resolution. It does **not** copy only the numerical result of a prior activation.

**Canonical example:** An installed Software ability enhanced through PATCHWORK reads: “When you shuffle your draw pile, **gain 3 PULP prevention. Then double your PULP prevention**.” If the Rustler has **5 PULP prevention** when the copied ability resolves, it first gains 3 (**5 → 8**) and then doubles the current pool (**8 → 16**), ending at **16 PULP prevention**.

**Compatibility:** Instructions resolve in order (RULE-010); copied abilities include PATCHWORK modifications (RULE-069), can resolve when original activation limits are consumed if explicitly directed (RULE-070), and retain costs where applicable (RULE-071). Trigger queue handling remains governed by RULE-014/015.


## 139. RULE-073 — Copied abilities finish before generated triggers resolve (LOCKED, 2026-11-10)

**Explicit user approval:** An effect that **copies and resolves a Software ability** must complete **all instructions of that copied ability** before any triggers generated by those instructions resolve. Generated triggers enter the existing queue and are processed afterward under normal ordering rules; they cannot interrupt the copied ability mid-resolution.

**Canonical example:** The Rustler has installed Software reading “Whenever you gain PULP prevention, gain 1 BW.” A copied PATCHWORK-enhanced ability reads “Gain 3 PULP prevention. Then double your PULP prevention.” The Rustler gains 3 prevention (queuing a BW trigger), then doubles the current prevention (queuing another BW trigger **if the doubling increases prevention and qualifies as a separate gain event**). Only after the copied ability fully finishes do the queued triggers resolve in FIFO order, granting **2 BW** if both events qualified.

**Compatibility:** Chained triggers wait until the current effect completes (RULE-014); queued triggers follow FIFO (RULE-015); copied abilities reproduce full ordered instructions (RULE-072). This rule does not itself establish that every numerical modification is a “gain” event; trigger qualification follows the relevant effect wording and event semantics.


## 140. RULE-074 — Doubling prevention counts as gaining prevention (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect **doubles a prevention pool**, any **positive increase** in that pool counts as **gaining prevention** of that type and therefore qualifies for effects triggered by gaining prevention. A **single doubling instruction** produces **one prevention-gain event** if it increases any prevention, even when it doubles several pools simultaneously. The amounts gained in each affected pool are their respective post-doubling minus pre-doubling differences. See RULE-075. Doubling a zero pool generates **no prevention-gain event**.

**Canonical example:** Rustler has **5 PULP prevention** and installed Software: “Whenever you gain PULP prevention, gain 1 BW.” Rustler plays “Double your PULP prevention.” PULP prevention increases **5 → 10**, so the Rustler **gains 5 PULP prevention** and queues **one** +1 BW trigger. That trigger resolves after the doubling effect finishes under RULE-014/015.

**Other prevention types:** The same principle applies to **SYN** and **VOID** prevention when doubled, subject to the wording of the triggered ability and the actual pool increased. Doubling all three pools in **one instruction** is still **one gain event**, not three (RULE-075).

**Compatibility:** Prevention multipliers compound and apply as snapshot effects (RULE-008/009); triggers generated during effect resolution queue until the effect completes (RULE-014/015); copied abilities obey the same rule (RULE-073).


## 141. RULE-075 — A single multi-pool prevention doubling is one gain event (LOCKED, 2026-11-10)

**Explicit user correction:** “Double all your prevention” is a **singular event**. Even if it increases **PULP, SYN and VOID prevention simultaneously**, an installed ability reading “Whenever you gain prevention, gain 1 BW” triggers **once**, not once per prevention pool. Count the **single resolving gain-producing instruction/event**, not the number of prevention types affected, for an unrestricted “gain prevention” trigger.

**Canonical example:** Rustler has **5 PULP, 3 SYN, 2 VOID prevention** and plays “Double all your prevention.” The pools become **10 PULP, 6 SYN, 4 VOID**. Software reading “Whenever you gain prevention, gain 1 BW” generates **one trigger**, granting **1 BW total**, not 3 BW.

**Type-specific triggers:** The event may involve multiple prevention types, so a distinct “Whenever you gain PULP prevention” ability and a distinct “Whenever you gain SYN prevention” ability can each recognize the same event if their conditions are met; however, the **same** generic ability does not trigger multiple times simply because multiple pools increased.

**Compatibility / clarification of RULE-074:** Doubling counts as gaining prevention if it increases prevention, but a **single multi-pool doubling instruction** generates **one gain event**, not a separate event for each affected pool. Independent sequential gain-producing instructions may produce separate events, subject to their text and ordinary trigger rules.


## 142. RULE-076 — Separate gain instructions generate separate prevention-gain events (LOCKED, 2026-11-10)

**Explicit user approval:** When a card or ability contains **multiple distinct instructions** that grant prevention, **each qualifying instruction generates a separate prevention-gain event**, even when the instructions are printed on the same card. A generic ability reading “Whenever you gain prevention, gain 1 BW” can therefore trigger once for each distinct gain instruction. Triggered effects are queued until the current card/ability finishes resolving.

**Canonical example:** An Instant Software card reads “Gain 3 PULP prevention. Gain 2 SYN prevention.” Another installed Software reads “Whenever you gain prevention, gain 1 BW.” The first instruction gains **3 PULP prevention** and queues one +1 BW trigger. The second instruction gains **2 SYN prevention** and queues a second +1 BW trigger. After the card finishes resolving, both triggers resolve in FIFO order, granting **2 BW total**.

**Distinction:** One instruction that simultaneously doubles or increases several prevention pools generates **one** gain event (RULE-075); **two separate gain instructions** generate **two** events. Printed order and trigger queue rules remain RULE-010/014/015. No event is generated by an instruction that causes no positive prevention gain.


## 143. RULE-077 — One instruction granting multiple prevention types creates one gain event (LOCKED, 2026-11-10)

**Explicit user approval:** A **single instruction** that grants multiple prevention types **simultaneously** produces **one prevention-gain event**, not a separate event per affected pool. A generic trigger such as “Whenever you gain prevention, gain 1 BW” activates **once** for that instruction if it produces any positive prevention gain.

**Canonical example:** A Software card reads “Gain **3 PULP prevention and 2 SYN prevention**.” Another installed Software reads “Whenever you gain prevention, gain 1 BW.” The instruction increases both PULP and SYN pools, but generates **one** qualifying gain event and therefore **one +1 BW trigger**, resolved after the current card/ability completes.

**Distinction:** One multi-pool instruction produces one event (RULE-075), whereas separate instructions “Gain 3 PULP prevention. Gain 2 SYN prevention.” produce two events (RULE-076). Different type-specific abilities can each recognize the same event if their respective type was gained; the same generic trigger does not multiply by the number of pools affected. Instructions that increase no prevention generate no gain event.


## 144. RULE-078 — One gain event can trigger multiple type-specific abilities (LOCKED, 2026-11-10)

**Explicit user approval:** A **single prevention-gain event** that increases multiple prevention types may satisfy **multiple distinct triggered abilities**, each of which triggers **once** if its own condition is met. This does not split the original gain instruction into multiple events. When the qualifying abilities are Rustler-controlled and trigger simultaneously, the **Rustler chooses their resolution order**. The originating card/ability completes before those queued triggers resolve.

**Canonical example:** Installed Software A reads “Whenever you gain PULP prevention, gain 1 BW.” Installed Software B reads “Whenever you gain SYN prevention, draw 1 card.” The Rustler plays “Gain 3 PULP prevention and 2 SYN prevention.” This **single instruction** produces **one gain event** (RULE-077) that satisfies both conditions. Software A queues **+1 BW** and Software B queues **draw 1 card**, each **once**. The Rustler chooses their order, and both resolve after the originating card finishes.

**Compatibility:** Multiple distinct triggered abilities may respond to the same event (RULE-055); Rustler orders simultaneous Rustler-controlled triggers (RULE-011); queued triggers wait until the current effect completes and follow established queue ordering (RULE-014/015); one multi-type prevention instruction is one event (RULE-077).


## 145. RULE-079 — Prevention gained from triggered abilities can generate further triggers (LOCKED, 2026-11-10)

**Explicit user approval:** Prevention granted by a **triggered ability** counts as a new prevention-gain event, just like prevention granted by a played card or other effect. It can trigger further eligible abilities, producing **chained triggers**. Each resolving ability completes before its generated triggers resolve; newly generated triggers enter the existing **FIFO queue**. Genuinely infinite cycles are handled by existing loop detection and termination rules, without capping legitimate finite chains.

**Canonical example:** Installed Software A reads “Whenever you gain PULP prevention, gain 2 SYN prevention.” Installed Software B reads “Whenever you gain SYN prevention, gain 1 BW.” Rustler plays “Gain 3 PULP prevention.” The 3 PULP gain queues A. A resolves, granting 2 SYN prevention and queuing B. B subsequently resolves, granting 1 BW. Final gains: **3 PULP prevention, 2 SYN prevention, 1 BW**, assuming no other effects.

**Compatibility:** Triggered abilities resolve completely before their generated triggers (RULE-014); queue order is FIFO (RULE-015); infinite-loop safeguards follow RULE-016–019; gain-event granularity follows RULE-074–078.


## 146. RULE-080 — Previously queued triggers resolve before newly generated chained triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When multiple triggers are already waiting in the **FIFO queue**, a resolving ability's newly generated trigger is appended **behind all triggers already queued**. It cannot jump ahead of a previously queued trigger. For simultaneous Rustler-controlled triggers, the Rustler chooses their initial ordering; that choice determines their order in the queue.

**Canonical example:** Software A: “Whenever you gain PULP prevention, gain 2 SYN prevention.” Software B: “Whenever you gain PULP prevention, gain 1 BW.” Software C: “Whenever you gain SYN prevention, draw 1 card.” Gaining **3 PULP prevention** triggers A and B simultaneously. The Rustler chooses **A before B**. A resolves and gains **2 SYN prevention**, queuing C **after** B. The resulting resolution order is **A → B → C**, granting 2 SYN prevention, then 1 BW, then drawing 1 card. **A → C → B is not permitted** because B was already queued.

**Compatibility:** Confirms FIFO queue semantics (RULE-015), simultaneous Rustler trigger ordering (RULE-011), and chained triggers from prevention gains (RULE-079). Each ability resolves completely before the next queued trigger (RULE-014).


## 147. RULE-081 — Removing Software cancels its unresolved queued triggers (LOCKED, 2026-11-10)

**Explicit user rejection of the alternative:** A triggered ability queued by **installed Software** does **not** survive removal of its source from play. If that Software is no longer installed **when its pending trigger would resolve**, the queued trigger is **cancelled** rather than resolving. The source must remain in play for its queued ability to resolve, **unless explicit card text provides an exception**.

**Canonical example:** Software A reads “Whenever you gain PULP prevention, gain 2 SYN prevention.” Software B reads “Whenever you gain PULP prevention, gain 1 BW.” Both trigger on a PULP prevention gain; Rustler queues A before B. During A's resolution, another effect removes Software B from play. When B's queued trigger reaches the front of the FIFO queue, **cancel B's trigger**; it grants **no BW**.

**Compatibility:** Triggers otherwise resolve FIFO (RULE-015/080). This cancellation applies to **unresolved** triggers from Software no longer installed, not to benefits already resolved. Treatment of a removed card that returns before its queued trigger would resolve is a separate open edge case.


## 148. RULE-082 — Leaving play immediately invalidates unresolved Software triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When an installed Software card **leaves play**, **all of its unresolved queued triggered abilities are immediately cancelled**. Returning or reinstalling **that same card instance** before the cancelled trigger's former queue position would be processed **does not restore or revive** the cancelled trigger. Reinstallation may permit **new qualifying triggers** while the Software is eligible, but does not undo the cancellation.

**Canonical example:** Software B has a pending triggered ability in the FIFO queue. B is removed from play, immediately cancelling its pending trigger. Another effect reinstalls the **same B card** before the queue reaches that position. The old trigger remains **cancelled** and grants no benefit; B may generate new triggers only on subsequent qualifying events, subject to applicable activation limits.

**Compatibility:** Extends source-removal cancellation (RULE-081), preserves FIFO processing of surviving triggers (RULE-015/080), and does not reset consumed activation allowances through temporary removal/reinstallation (RULE-066). Already resolved effects remain intact.


## 149. RULE-083 — An ability already resolving completes after its source leaves play (LOCKED, 2026-11-10)

**Explicit user approval:** When a Software triggered ability has **already begun resolving**, removing its source Software card from play **does not interrupt or cancel the remaining instructions of that currently resolving ability**. Resolve its full instructions in order, subject to their normal conditions and costs. This differs from unresolved queued triggers, which are immediately cancelled when their source leaves play (RULE-081/082).

**Canonical example:** Software A's triggered ability reads “Gain 3 PULP prevention. Then gain 2 SYN prevention.” The ability begins resolving and grants **3 PULP prevention**. Another effect removes Software A from play before the second instruction. The currently resolving ability still completes, granting **2 SYN prevention**. Any **other unresolved queued triggers** from A are cancelled on removal.

**Compatibility:** Current effects resolve to completion (RULE-010/014); unresolved triggers are cancelled upon source leaving play (RULE-081/082). This rule does not exempt the remaining instructions from explicit conditions or costs.


## 150. RULE-084 — In-progress abilities can generate valid triggers after source removal (LOCKED, 2026-11-10)

**Explicit user approval:** When a Software ability has **already begun resolving** and its source Software card subsequently leaves play, the ability continues under RULE-083. Any **valid game events generated by its remaining instructions** can still trigger **other eligible installed Software**, even though the original ability's source is no longer installed. Removing the source cancels its **other unresolved queued triggers** (RULE-081/082), not the already resolving ability or the validity of events it creates.

**Canonical example:** Software A's ability reads “Gain 3 PULP prevention. Then gain 2 SYN prevention.” Software B, still installed, reads “Whenever you gain SYN prevention, gain 1 BW.” A begins resolving and grants **3 PULP prevention**. A is removed from play. A's current ability continues, granting **2 SYN prevention**. This valid SYN gain triggers B; B's queued trigger resolves after the current ability finishes and grants **1 BW**, assuming B remains eligible.

**Compatibility:** In-progress abilities finish after source removal (RULE-083); other pending triggers from removed Software are cancelled (RULE-081/082); valid prevention-gain events trigger eligible abilities (RULE-078/079); generated triggers queue until current resolution completes (RULE-014/015).


## 151. RULE-085 — Pending triggers require source Software to remain installed until resolution begins (LOCKED, 2026-11-11)

**Explicit user approval:** A valid trigger generated by installed Software remains **pending** until its queued ability **begins resolving**. If its source Software leaves play **before resolution begins**, the pending trigger is **cancelled immediately**, even though the event that originally generated it was valid. No benefit from that cancelled trigger is granted.

**Canonical example:** Software A reads “Whenever you gain PULP prevention, gain 2 SYN prevention.” The Rustler gains PULP prevention and A's trigger enters the queue. Another effect removes A before its trigger begins resolving. **Cancel A's queued trigger; do not grant 2 SYN prevention.**

**Resolution boundary:** A pending queued trigger is cancelled when its source leaves play (RULE-081/082); an ability that **has already begun resolving** continues to completion after source removal (RULE-083), and events it subsequently produces may still trigger other eligible Software (RULE-084). Reinstalling the source does not revive cancelled triggers (RULE-082).


## 152. RULE-086 — Drawing continues after resolving Software source is removed (LOCKED, 2026-11-11)

**Explicit user approval:** Once an installed Software ability has **begun resolving**, removal of its source Software during that resolution **does not interrupt any remaining draw instruction**. The ability finishes normally under the established card-draw rules, including automatic reshuffling and drawing as many cards as possible when insufficient cards are available.

**Canonical example:** Software A's ability reads “Gain 3 PULP prevention. Then draw 2 cards.” After granting **3 PULP prevention**, A is removed from play. Its already resolving ability **still draws 2 cards**, assuming at least 2 cards are available through draw/discard piles; if fewer are available, draw as many as possible under RULE-034/037.

**Compatibility:** Confirms that the in-progress resolution protection of RULE-083 applies to **all remaining instructions**, not only prevention gains. Pending, not-yet-resolving triggers from removed Software are still cancelled (RULE-081/082/085). Draw-generated triggers queue until the current effect completes (RULE-033/039).


## 153. RULE-087 — Conditional rewards remain valid after source removal during resolution (LOCKED, 2026-11-11)

**Explicit user approval:** If an installed Software ability has **already begun resolving**, removing the source Software card during that resolution **does not invalidate a conditional reward** whose requirement is successfully fulfilled. The remaining instructions continue normally and the condition is evaluated based on what actually happened, not on whether the source is still installed.

**Canonical example:** Software A reads “Draw 2 cards. If you do, gain 5 PULP prevention.” During the draw, another effect removes A from play. If **both cards are actually drawn**, the “If you do” requirement is satisfied and the Rustler **gains 5 PULP prevention**. If fewer than two cards are drawn, the conditional reward **does not occur**, regardless of source removal.

**Compatibility:** Conditional draws require full completion (RULE-038); draw-triggered effects wait until the card ability finishes (RULE-033/039); already resolving abilities continue after source removal (RULE-083/086). Other pending triggers from removed Software remain cancelled (RULE-081/082/085).


## 154. RULE-088 — Explicit installed-source conditions override continued resolution (LOCKED, 2026-11-11)

**Explicit user approval:** An installed Software ability that has **already begun resolving** normally continues after its source leaves play (RULE-083), but **explicit conditions requiring that Software to remain installed** must still be satisfied at the point the condition is checked. Continuing resolution does **not** waive or override an expressly stated installed-source requirement.

**Canonical example:** Software A reads “Draw 2 cards. If this Software is still installed, gain 5 PULP prevention.” The ability begins resolving, but A is removed during the draw. The Rustler **still completes the draw of 2 cards** (assuming cards are available). At the conditional instruction, A is **not installed**, so the Rustler gains **0 PULP prevention**. The fact that both cards were drawn does not satisfy the distinct explicit installation condition.

**Compatibility:** Already resolving abilities finish after source removal (RULE-083/086); successfully completed conditional draws remain valid when their conditions are met (RULE-087); however, explicit conditions are independently enforced (RULE-003/038). Pending queued abilities from removed Software are cancelled (RULE-081/082/085).


## 155. RULE-089 — Reinstalled Software is a new installed instance for source-specific conditions (LOCKED, 2026-11-11)

**Explicit user decision:** **No**—removing Software A and then reinstalling it means it is considered a **new installation/card instance**, not the still-installed source of the old ability. Reinstallation cannot retroactively satisfy an explicit condition referring to the original source instance.

**Canonical example:** Software A reads “Draw 2 cards. If this Software is still installed, gain 5 PULP prevention.” A's ability begins resolving; during the draw, A is removed and then reinstalled before the condition is checked. The already-started ability completes its draw under RULE-083/086, but the original installed instance has left play. The newly installed instance does **not** count as “this Software” still being installed for that original ability. **No 5 PULP prevention is granted.**

**Identity clarification:** Reinstallation creates a new **installed instance**, not a new physical card or card copy. It does not restore cancelled pending triggers (RULE-082), reset consumed global limits (RULE-059/060/065), or contradict the rule that temporarily removing/reinstalling the same Software card does not reset consumed activation limits (RULE-066). The current-resolution protection (RULE-083) does not preserve source identity for explicit installation conditions (RULE-088).


## 156. RULE-090 — Continuous Software effects belong to their installed instance (LOCKED, 2026-11-11)

**Explicit user approval:** A continuous Software effect that applies **while its source Software is installed** belongs to that particular **installed instance**. When that instance leaves play, its continuous effect **ends immediately**. Reinstalling the same physical card creates a **new installed instance** that establishes its own continuous effect, rather than reviving or stacking the original effect.

**Canonical example:** Software A reads “While this Software is installed, gain +2 DRAW.” Removing A ends the original installed instance's **+2 DRAW** immediately. Reinstalling A establishes a new **+2 DRAW** effect. The two instances' effects do not overlap or stack: **+2 DRAW, not +4 DRAW**.

**Compatibility:** Reinstallation is a new installed instance (RULE-089), but does not create a second physical card, restore cancelled pending triggers (RULE-082), or reset activation limits protected by RULE-066 and global-limit rules. Distinguish continuous effects, which require an installed source, from discrete abilities that have already begun resolving and therefore finish under RULE-083.


## 157. RULE-091 — Continuous effects stack across separate installed Software copies (LOCKED, 2026-11-11)

**Explicit user approval:** Multiple **separately installed Software instances** each contribute their own continuous effects. Identical continuous bonuses **stack additively by default**, unless card text or another explicit restriction states otherwise.

**Canonical example:** Two distinct installed copies of Software A each read “While this Software is installed, gain +2 DRAW.” Both apply simultaneously, granting **+4 DRAW total**. If one instance leaves play, its contribution ends immediately under RULE-090, leaving **+2 DRAW** from the remaining instance.

**Compatibility:** Each installed instance independently maintains its continuous effects (RULE-090). Reinstalling a removed physical card does not preserve the old installed instance or double-count its bonus (RULE-089/090). This stacking rule does not override explicit non-stacking or global restrictions.


## 158. RULE-092 — Explicit non-stacking text overrides default continuous-effect stacking (LOCKED, 2026-11-11)

**Explicit user approval:** Continuous effects from separately installed Software instances normally stack (RULE-091), but **explicit non-stacking restrictions on a card override that default**. Multiple copies of the same Software with an expressly non-stacking continuous bonus do not add their bonuses together.

**Canonical example:** Two installed copies of Software A each read “While this Software is installed, gain +2 DRAW. This effect does not stack with other copies of this Software.” Together they grant **+2 DRAW total**, **not +4 DRAW**, regardless of the number of such installed copies. If one copy leaves play, the other still grants **+2 DRAW**.

**Compatibility:** Each installed instance maintains its own continuous effect while present (RULE-090), but contributions are combined subject to explicit restrictions (RULE-091). Removal of an instance ends its effect; no departed-instance bonus persists.


## 159. RULE-093 — PATCHWORK-enhanced continuous bonuses stack unless explicitly restricted (LOCKED, 2026-11-11)

**Explicit user correction:** Different PATCHWORK enhancements do **not** inherently impose any non-stacking restriction. Continuous bonuses from separately installed Software copies **add together**, including when their PATCHWORK modifications give different numerical strengths, unless the actual card text expressly prohibits stacking.

**Canonical example:** Installed Software Copy A grants **+2 DRAW**, while separately installed PATCHWORK-enhanced Copy B grants **+4 DRAW**. With **no explicit non-stacking restriction on either copy**, the Rustler receives **+6 DRAW total**, not +4. Do not infer a non-stacking clause from a hypothetical example or from the fact that the cards are copies of the same Software.

**Compatibility:** Default additive stacking across installed instances (RULE-091) remains in force. RULE-092 applies **only when an explicit non-stacking restriction is present** in the relevant card text. Each instance's contribution ends when it leaves play (RULE-090).


## 160. RULE-094 — Strongest bonus applies among explicitly non-stacking continuous effects (LOCKED, 2026-11-11)

**Explicit user clarification:** When separately installed Software copies have **explicit non-stacking restrictions** and different continuous bonus strengths, apply the **strongest eligible bonus only**, rather than adding them or choosing the weaker bonus.

**Canonical example:** Installed Copy A grants **+2 DRAW**, while PATCHWORK-enhanced installed Copy B grants **+4 DRAW**. **If these effects explicitly do not stack**, the Rustler receives **+4 DRAW total**, not +6. The non-stacking clause is essential to this result.

**Distinction:** When there is **no explicit non-stacking restriction**, the same +2 and +4 contributions **do stack to +6 DRAW** under RULE-091/093. RULE-092 governs whether a non-stacking restriction applies at all; this rule determines the value when it does.


## 161. RULE-095 — Removing strongest non-stacking Software recalculates remaining bonus (LOCKED, 2026-11-11)

**Explicit user approval:** When multiple installed Software copies grant continuous bonuses that **explicitly do not stack**, the strongest eligible bonus applies (RULE-094). If the source of that strongest bonus leaves play, its continuous contribution ends immediately and the effective bonus is **recalculated from the remaining eligible installed instances**. The remaining Software's continuous effect is already active; it need not trigger or activate again.

**Canonical example:** Installed Copy A grants **+2 DRAW**, while PATCHWORK-enhanced Copy B grants **+4 DRAW**, and both effects explicitly prohibit stacking. With both installed, the Rustler has **+4 DRAW**. When Copy B leaves play, its bonus ends and the Rustler immediately has **+2 DRAW** from Copy A.

**Compatibility:** Installed-instance continuous effects end on removal (RULE-090); explicit non-stacking overrides default additive stacking (RULE-092); strongest eligible non-stacking bonus applies (RULE-094). Without explicit non-stacking text, additive stacking still applies (RULE-091/093).


## 162. RULE-096 — DRAW changes do not retroactively affect cards already drawn (LOCKED, 2026-11-11)

**Explicit user approval:** Changes to the Rustler's current DRAW value, including changes caused by removing installed Software that grants a continuous DRAW bonus, affect **future draw calculations only**. They do **not** retroactively undo completed draws, discard cards already drawn, or otherwise reduce the Rustler's current hand merely because DRAW has decreased.

**Canonical example:** Base DRAW is **5**. Two installed Software copies grant explicitly non-stacking continuous bonuses: Copy A **+2 DRAW** and PATCHWORK-enhanced Copy B **+4 DRAW**. The stronger bonus applies, giving **DRAW 9**, and the Rustler draws **9 cards** at the start of the turn. Later in that turn, Copy B leaves play. The effective DRAW value becomes **7** (base 5 + remaining bonus 2), but the Rustler **keeps all 9 cards already drawn**. DRAW 7 applies to later calculations that reference DRAW, not to the completed draw.

**Compatibility:** Explicitly non-stacking effects use the strongest eligible bonus (RULE-094); removing that source recalculates the active bonus (RULE-095); completed draws are not reversed. This rule does not itself grant an additional draw when DRAW increases mid-turn.


## 163. RULE-097 — Mid-turn DRAW increases do not draw extra cards (LOCKED, 2026-11-11)

**Explicit user approval — Option A:** An increase to the Rustler's effective DRAW during a turn does **not** immediately draw additional cards. The increased DRAW applies to **future applicable draw calculations** only; a completed draw is not retroactively topped up.

**Canonical example:** Rustler starts the turn at DRAW 5 and draws 5 cards. Mid-turn, installed Software grants +3 DRAW, increasing effective DRAW to 8. **No 3-card immediate draw occurs.** DRAW 8 applies to the next applicable draw calculation that references DRAW.

**Compatibility:** Complements RULE-096: neither increases nor decreases in DRAW retroactively alter completed draws. Explicit instructions to draw cards remain governed by their own wording. No new normal draw timing is established.


## 164. RULE-098 — Snapshot DRAW when a draw instruction begins resolving (LOCKED, 2026-11-11)

**Explicit user approval — Option A:** When an ability instructs the Rustler to draw cards equal to their **DRAW**, determine the number of cards from the effective DRAW value **when that draw instruction begins resolving**. Changes to DRAW during the instruction do **not** increase or decrease the number of cards instructed to be drawn. Later applicable draw calculations use the then-current DRAW value.

**Canonical example:** The Rustler has DRAW 5. Software instructs “Draw cards equal to your DRAW.” The instruction begins with a target of **5 cards**. After 2 cards have been drawn, another effect raises effective DRAW to 8. The original instruction still draws **5 cards total**, not 8, subject to existing rules for drawing as many as possible if the deck cannot supply enough cards.

**Compatibility:** RULE-096/097 prevent retroactive changes to completed draws; RULE-098 fixes the quantity for a draw instruction already underway. Existing draw-trigger timing and draw-shortfall rules remain unchanged. This does not specify how other variable numerical effects snapshot their values.


## 165. RULE-099 — Each distinct DRAW-based draw instruction recalculates DRAW (LOCKED, 2026-11-11)

**Explicit user approval — Option A:** Within a single resolving ability, **each separate instruction** to draw cards equal to DRAW uses the Rustler's effective **DRAW when that particular instruction begins**. The DRAW value is not snapshotted once for the entire ability. Once an individual instruction begins, its target number remains fixed during that instruction under RULE-098.

**Canonical example:** Software ability reads “Draw cards equal to your DRAW. Gain +2 DRAW. Then draw cards equal to your DRAW again.” Starting at DRAW 5, the first instruction draws **5 cards**. The intervening bonus increases effective DRAW to **7**. The second, distinct draw instruction then draws **7 cards**, subject to existing draw-shortfall rules.

**Compatibility:** RULE-098 snapshots each individual draw instruction at its start; RULE-096/097 bar retroactive hand changes or automatic extra draws. Draw-trigger timing and the resolution of other effects remain governed by their existing locked rules. This rule does not imply that a single instruction recalculates its target between cards.


## 166. RULE-100 — Queued DRAW-based abilities use DRAW at instruction resolution (REVISED AND LOCKED, 2026-11-11)

**Explicit user-directed revision (supersedes original Option B):** A queued triggered ability that instructs “Draw cards equal to your DRAW” does **not** snapshot DRAW when it enters the FIFO trigger queue. Determine the card count from the effective DRAW **when that individual draw instruction begins resolving**, as established by RULE-098. Changes to DRAW while the ability waits in the queue therefore affect the card count.

**Canonical example:** Effective DRAW is **5** when the triggered ability enters the queue. Before it resolves, another effect grants **+3 DRAW**, raising DRAW to **8**. When the queued draw instruction begins resolving, it draws **8 cards**, subject to existing draw-shortfall rules. Later changes during that same instruction do not alter its fixed target (RULE-098).

**Compatibility:** RULE-100 now explicitly aligns with RULE-098; it creates **no queue-time exception**. Under RULE-099, separate DRAW-based instructions within the same ability each calculate DRAW when their own instruction begins. FIFO trigger order, source-removal cancellation, and existing trigger timing remain unchanged.

**Revision history:** RULE-100 was originally approved as Option B (snapshot at queue time) and committed in `17b5c4917290061064b75774fee4dadbc323a0a6`. After reviewing its conflict with RULE-098, the user explicitly instructed: “Change rule 100 to align with rule 98. Then proceed.” This revised text supersedes the prior RULE-100 wording.


## 167. RULE-101 — Separate DRAW instructions in queued abilities each use current DRAW (LOCKED, 2026-11-11)

**Explicit user approval — Option A (after conflict review):** When a triggered ability has been queued and later resolves with multiple separate instructions to “Draw cards equal to your DRAW,” **each instruction independently determines its target from effective DRAW when that instruction begins**. The ability's queue-entry DRAW value and the value at the start of the overall ability do not lock the later instructions. Each individual instruction's target remains fixed while it resolves.

**Canonical example:** Ability text: “Draw cards equal to your DRAW. Gain +2 DRAW. Then draw cards equal to your DRAW again.” It enters the FIFO queue at DRAW **5**. Before resolution, DRAW rises to **8**. The first instruction draws **8**; the intervening +2 raises DRAW to **10**; the second instruction draws **10**, subject to existing draw-shortfall rules.

**Conflict check:** Consistent with RULE-098 (snapshot each instruction at its start), RULE-099 (separate instructions recalculate), and revised RULE-100 (no queue-time snapshot). **No existing locked rule is overridden.** Existing trigger ordering, source-removal cancellation, and draw-shortfall handling are unchanged.


## 168. RULE-102 — Snapshot variable numeric quantities per discrete instruction, with explicit protections (LOCKED, 2026-11-11)

**Explicit user approval — exception-protected Option A following conflict audit:** When a **discrete instruction** calculates an effect using a **variable numerical value**, determine that value **when the instruction begins resolving**. Keep the calculated quantity fixed for **that instruction**. Each later, separate instruction independently calculates its variable quantity using the game state when **that later instruction** begins resolving.

**Scope and precedence:** This general rule **does not freeze continuous effects**, override **explicit card or rule timing instructions**, bypass **costs or conditions**, or change **resource expenditure and consumption priorities**. More-specific locked rules and explicit applicable card text take precedence. In particular, continuous Software effects continue updating under RULE-090–095; costs and conditions remain governed by RULE-003/038/071; and eligible resource consumption continues under RULE-004–006. Existing trigger ordering and FIFO resolution are unchanged.

**Illustrative example (not a finalized card):** An ability reads “Gain PULP prevention equal to your current Trace. Reduce Trace by 2. Gain PULP prevention equal to your current Trace.” If Trace is 6 when the first instruction begins, the first gain is **6**; after Trace falls to 4, the second distinct gain is **4**, unless more-specific rules or card text direct otherwise. Changing Trace during an individual instruction does not retroactively change that instruction's already calculated amount.

**Conflict review:** Extends RULE-098–101's per-instruction snapshot model beyond DRAW while preserving RULE-010 (printed order), RULE-008/009 (sequential snapshot prevention multipliers), and RULE-072 (copied abilities use current state). **No override of the cited locked mechanics is authorized by this rule.** Future edge cases with more-specific instructions must be evaluated against those rules rather than silently generalized.


## 169. RULE-103 — One variable-value snapshot across per-object processing in a single instruction (LOCKED, 2026-11-11)

**Explicit user approval — Option A, after conflict check:** When **one discrete instruction** says to perform a variable-numeric calculation **for each** eligible object, snapshot the referenced variable numeric value **once, when that instruction begins resolving**, and use that same value for every object processed under that instruction. Do **not** recalculate the variable between objects merely because processing is sequential. A subsequent **separate instruction** takes its own snapshot under RULE-102.

**Illustrative example (not finalized card text):** “For each installed Software card, gain PULP prevention equal to your current Trace.” With three eligible Software cards and Trace **6** at instruction start, each per-card calculation uses **6**. If an otherwise legally permitted effect changes Trace to **4** during processing, the remaining calculations under this **same instruction** still use **6**. This example does **not** authorize ordinary queued triggers to interrupt the current instruction or ability; under RULE-014/015, such triggers wait until the current effect completes.

**Compatibility / conflict check:** Clarifies RULE-102's instruction-level snapshot; preserves RULE-010 printed order, RULE-014/015 uninterrupted effect resolution and FIFO queue, and RULE-098's fixed per-instruction draw target. It does **not** change event counting or trigger granularity for prevention gains under RULE-074–077, nor alter eligibility, costs, conditions, continuous-effect updates, or resource expenditure priority. **No existing locked rule is overridden.**


## 170. RULE-104 — Snapshot eligible objects for a single “for each” instruction, with eligibility protections (LOCKED, 2026-11-11)

**Explicit user approval — Option A with eligibility protections, following conflict review:** When a **discrete “for each” instruction** refers to eligible objects, determine its **processing set once, when the instruction begins resolving**. Process that fixed set: objects that become eligible later are **not added**, and objects originally included are **not automatically removed from the processing list** merely because their state changes during processing.

**Eligibility protections and precedence:** Membership in the initial processing set **does not establish or preserve eligibility for any separate explicit condition, cost, requirement to remain installed/in play, or source-dependent effect** checked later. Evaluate those requirements at their applicable times under existing rules. In particular, explicit installed-status conditions remain enforceable (RULE-088), continuous effects from departed installed instances end immediately (RULE-090), and source-removal/cancellation boundaries remain RULE-081–089. If a required action becomes impossible, apply existing partial-fulfillment and cost/condition rules (RULE-002/003); do not create benefits from ineligible or nonexistent sources. More-specific rules or card text take precedence.

**Illustrative example (not finalized card text):** “For each installed Software card, gain 2 PULP prevention.” If A, B, and C are installed when the instruction starts, the processing set is **{A, B, C}**. An ordinary triggered removal of C generated during resolution waits until the current ability completes (RULE-014/015), so all three contribute normally. If an otherwise legally permitted mid-instruction event removes C, C remains in the original processing list, **but** any explicitly required installed-status condition or source-dependent effect must still be satisfied when checked; this rule alone does not guarantee its benefit.

**Conflict check:** Compatible with RULE-010, RULE-014/015, RULE-083/088, RULE-090, and RULE-102/103. The fixed **object set** is distinct from RULE-103's fixed **numeric value**. Does not alter event counting, trigger timing, continuous-effect recalculation, or costs. **No existing locked rule is overridden.**


## 171. RULE-105 — Aggregate prevention-gain event for a single “for each” instruction (LOCKED, 2026-11-11)

**Explicit user approval — Option A, following conflict audit:** When a single discrete instruction grants prevention for each eligible object, the instruction produces **one aggregate prevention-gain event**, provided the total prevention gained is positive.

The number of objects processed does not multiply the number of events. Each eligible triggered ability responds at most once to that event, subject to its own frequency restrictions.

Multiple separately written prevention-gain instructions continue to produce separate events under RULE-076. Different triggered abilities may each respond to the same event under RULE-078.

Generated triggers wait until the originating ability finishes and resolve under the established FIFO queue.

**Illustrative application (not finalized card text):** “For each installed Software card, gain 2 PULP prevention.” With three eligible installed Software cards, gain **6 PULP prevention** and produce **one** prevention-gain event. An installed “Whenever you gain PULP prevention, gain 1 BW” ability triggers **once** and grants **1 BW** when it resolves, subject to its limits. Two separate qualifying “for each” instructions instead generate **two** events under RULE-076.

**Conflict check:** Consistent with RULE-074/075/077 (one qualifying gain-producing instruction/event), RULE-076 (distinct instructions are distinct events), RULE-078/055 (distinct abilities independently recognize one event), RULE-079 (chained prevention-gain triggers), and RULE-014/015 (deferred FIFO triggers). RULE-103/104 continue to govern the instruction's numerical snapshot and eligible-object set. **No existing locked rule is overridden.**


## 172. RULE-106 — General aggregate-event convention for “for each” instructions (LOCKED, 2026-11-11)

**Explicit user approval — exception-protected Option A following conflict audit:** When a single discrete “for each” instruction produces repeated changes of the same event type across eligible objects, treat those changes as **one aggregate event** for generic triggers, provided a qualifying change actually occurs.

The number of objects processed does not independently multiply generic trigger activations. Multiple separately written instructions remain separate event-producing instructions.

**Exceptions:** This rule does **not** combine events that existing locked rules explicitly count individually, including **actual card draws**, **individual would-be draw replacements**, and **actual reshuffles**. It does not override **damage-application mechanics**, **explicit per-object or per-occurrence trigger wording**, **costs**, **conditions**, or **more-specific card text**.

Distinct eligible triggered abilities may each respond **once** to the aggregate event, subject to their frequency restrictions. Generated triggers follow existing **FIFO timing**.

**Illustrative examples (not finalized card text):** “For each installed Software card, reduce Trace by 2” with three eligible cards reduces Trace by **6** (to the extent permitted by applicable rules) and produces **one** qualifying Trace-reduction event if Trace actually decreases. “For each installed Software card, gain 1 BW” with three eligible cards grants **3 BW** (subject to applicable restrictions) and produces **one** qualifying BW-gain event if BW actually increases. RULE-105 already establishes the analogous single prevention-gain event. In contrast, “Draw 3 cards” continues to produce **three individual actual draw events** when three cards are actually drawn (RULE-032/033); separate actual reshuffles remain distinct (RULE-036).

**Conflict check:** Compatible with RULE-014/015, RULE-054/055, RULE-074–079, and RULE-102–105. Explicitly preserves individual draw events (RULE-032/033), actual reshuffles (RULE-036), and per-would-be-draw replacement decisions (RULE-040–043). Damage-specific event and application boundaries remain governed by their more-specific rules; this rule does not resolve new damage edge cases. **No existing locked rule is overridden.**


## 173. RULE-107 — Aggregate events report actual total change (LOCKED, 2026-11-11)

**Explicit user approval — exception-protected Option A following conflict audit:** When an aggregate event is generated under RULE-105 or RULE-106, its reported numerical magnitude equals the **total actual qualifying change** produced by that instruction, **not** the nominal amount per object or the amount originally attempted.

If an instruction is only partially fulfilled, count only changes that actually occur. If **no qualifying change** occurs, **no corresponding change event** is generated.

An amount-dependent triggered ability uses the aggregate event's reported magnitude, subject to the ability's own conditions, costs, timing, and frequency restrictions.

This rule does **not** combine events that existing rules count individually, override **damage-application mechanics**, or alter explicit **per-object or per-occurrence effects**. More-specific locked rules and card text take precedence.

**Illustrative example (not finalized card text):** “For each of 3 installed Software cards, reduce Trace by 2.” If starting Trace is **4** and applicable rules prevent it falling below zero, the attempted reduction is **6**, but actual reduction is **4**; the instruction generates **one** Trace-reduction event reporting magnitude **4**. An eligible “Whenever you reduce Trace, gain BW equal to the amount of Trace reduced” trigger attempts to grant **4 BW**, subject to applicable restrictions. This example **does not establish** a new Trace floor, BW cap, or other previously unspecified resource limit.

**Conflict check:** Compatible with RULE-002/003 (partial fulfillment and costs), RULE-074/075 (actual prevention gain), RULE-076/077 (instruction boundaries), RULE-102/103 (numeric snapshots), RULE-104 (eligible-object set), RULE-105/106 (aggregate-event count), and RULE-014/015 (FIFO triggers). Individual draw/reshuffle/replacement events remain governed by RULE-032/033/036/040–043; damage mechanics and more-specific card text retain precedence. **No existing locked rule is overridden.**


## 174. RULE-109 — Threshold triggers evaluate completed aggregate-event magnitude (LOCKED, 2026-11-11)

**Explicit user approval — exception-protected Option A following conflict audit:** When a triggered ability requires an event to meet a numerical threshold, and that event is an aggregate event under RULE-105 or RULE-106, evaluate the threshold against the event's **total actual qualifying change**, as defined by RULE-107.

Do **not** evaluate the threshold separately against each per-object contribution unless more-specific card text explicitly requires that treatment.

An eligible triggered ability activates **at most once** for the qualifying aggregate event, subject to its own frequency restrictions.

Threshold qualification does **not interrupt** the resolving instruction or ability. Generated triggers wait until the originating ability completes and resolve according to established **FIFO** rules.

This rule does **not** override individual draw events, reshuffles, draw replacements, damage-application mechanics, explicit per-object triggers, costs, conditions, or more-specific locked rules.

**Illustrative example (not finalized card text):** “For each installed Software card, gain 2 PULP prevention.” With three eligible cards, the instruction actually gains **6 PULP prevention** and generates **one aggregate event**. An eligible “Whenever you gain at least 5 PULP prevention in a single event, gain 2 BW” ability qualifies **once**, granting **2 BW** when it resolves (subject to applicable restrictions). If the instruction actually gains only **4 PULP prevention**, the threshold is not met, regardless of any higher attempted amount.

**Conflict check:** Consistent with RULE-102/103 (numeric snapshots), RULE-104 (eligible-object set), RULE-105/106 (aggregate-event identity), RULE-107 (actual reported magnitude), RULE-014/015 (deferred FIFO timing), RULE-054/055/078 (independent triggered abilities), and RULE-020/026 (frequency limits). Specific draw, reshuffle, replacement, damage, cost and condition rules retain precedence. **No existing locked rule is overridden.**

**Open question preserved:** RULE-108 mixed-direction aggregate-event accounting remains **deferred and not locked**, pending a concrete REDLINE card or mechanic requiring it.


## 175. RULE-110 — Event-time trigger qualification; resolution-time variable calculations (LOCKED, 2026-11-11)

**Explicit user approval — exception-protected Option A following conflict audit:** When an event occurs, determine whether a triggered ability qualifies using the **event's properties** and the applicable trigger conditions **at that time**.

For aggregate events, the event's reported actual magnitude and threshold qualification are established under RULE-107/109. Later game-state changes do **not** retroactively alter that event or its qualification.

When the queued triggered ability begins resolving, calculate any **variable numerical quantity** referenced by each discrete instruction using the applicable game state **when that instruction begins resolving**, following RULE-102.

Do **not** snapshot variable reward quantities when the trigger enters the queue unless explicit card text or a more-specific locked rule requires it.

**Protections:** Qualifying does not guarantee resolution. Pending triggers from Software that leaves play are cancelled under RULE-081/082/085. Explicit costs, conditions, installed-status requirements, frequency limits, and more-specific card text remain enforceable. Already resolving abilities retain RULE-083's protections. An explicit condition such as “If your Trace is at least 5 when this ability resolves” is still evaluated at its stated resolution time; event-time qualification does not convert it into an event-time condition.

Triggered abilities continue to resolve under the established **FIFO queue**. This rule does **not** change event identity, event counting, or the existing individual-event exceptions.

**Illustrative example (not finalized card text):** Installed Software reads “Whenever you gain at least 5 PULP prevention in a single event, gain BW equal to your current Trace.” The Rustler gains **6 PULP prevention** while Trace is **8**: the event qualifies and the trigger is queued. Before the trigger resolves, another effect reduces Trace to **3**. If the trigger survives all applicable source and condition checks, its BW-gain instruction uses Trace **3** and attempts to grant **3 BW**, subject to applicable restrictions. The original event's +6 PULP magnitude and qualification remain unchanged.

**Conflict check:** Compatible with RULE-014/015 (FIFO timing), RULE-054/055 (independent triggers), RULE-081/082/085 (source-removal cancellation), RULE-083/088 (resolving abilities and explicit installed conditions), RULE-098–103 (instruction-time numerical snapshots), RULE-107/109 (aggregate event magnitude and thresholds), and RULE-020/026 (frequency limits). **No existing locked rule is overridden.** RULE-108 mixed-direction event accounting remains **deferred and unlocked**.


## 176. RULE-111 — Event-referenced rewards use the original event's recorded magnitude (LOCKED, 2026-11-11)

**Explicit user approval:** When a triggered ability's reward explicitly refers to **the amount gained in the event that triggered it**, use that event's **recorded actual magnitude**, even if the relevant current resource pool changes before the queued trigger resolves. The event's magnitude is established when the event occurs under RULE-107/109 and is not recalculated from the current pool. This is distinct from a reward expressly referring to a **current** game-state quantity, which is evaluated at instruction resolution under RULE-110.

**Canonical example:** Installed Software A reads “Whenever you gain at least 5 PULP prevention in a single event, gain BW equal to the amount of PULP prevention gained in that event.” The Rustler gains **6 PULP prevention**, qualifying the event and queuing A's trigger. Before that trigger resolves, the current PULP prevention pool falls to **2**. If the queued trigger remains eligible to resolve, its reward attempts to grant **6 BW** (subject to applicable BW restrictions), **not 2 BW**, because the instruction references the recorded original event's gain.

**Compatibility:** RULE-107 fixes the actual magnitude of an aggregate event; RULE-109 checks thresholds against that magnitude; RULE-110 fixes event-time qualification but evaluates current-state variables at instruction time. Explicit event-referenced quantities are event properties, not current-state variables. Source-removal cancellation (RULE-081/082/085), costs, conditions, frequency limits, and FIFO timing remain unchanged. This rule does not resolve deferred RULE-108.


## 177. RULE-112 — Calculated event-based rewards use the original recorded event magnitude (LOCKED, 2026-11-11)

**Explicit user approval:** When a triggered ability calculates a numerical reward from **the amount gained in its triggering event**, use the event's **original recorded actual gain**, even if the current resource pool has changed before the trigger resolves. Mathematical transformations of that event-referenced amount (including division and explicitly stated rounding) operate on the original event magnitude, not the remaining pool.

**Canonical example:** Software A reads “Whenever you gain PULP prevention, gain BW equal to half the PULP prevention gained in that event, rounded down.” The Rustler gains **7 PULP prevention** and A's trigger is queued. Before resolution, **5 PULP prevention** is lost, leaving **2**. If A's trigger remains eligible to resolve, it attempts to grant **floor(7 / 2) = 3 BW**, not floor(2 / 2) = 1 BW, subject to applicable BW restrictions.

**Compatibility:** Extends RULE-111's event-referenced quantities; preserves RULE-107's recorded actual magnitude, RULE-110's distinction between event properties and current-state variables, and existing source-removal cancellation, costs, conditions, and FIFO timing. No general rounding convention beyond the card's explicit “rounded down” text is established.


## 178. RULE-113 — Explicit reward maximum applies to original event-referenced magnitude (LOCKED, 2026-11-11)

**Explicit user approval:** When a triggered ability computes a reward using the **original recorded magnitude of the triggering event**, any **explicit maximum on that reward** is applied to the result. Changes to the current resource pool after the triggering event do not alter the recorded event magnitude or the reward calculation. This card-specific maximum does not establish a universal BW cap.

**Canonical example:** Installed Software A reads “Whenever you gain PULP prevention, gain BW equal to the amount gained in that event, to a maximum of 5 BW.” The Rustler gains **8 PULP prevention**, triggering A. Before A's queued trigger resolves, the Rustler's current PULP prevention pool falls to **3**. If the trigger remains eligible to resolve, the reward is **min(8, 5) = 5 BW**, subject to other applicable resource restrictions, **not 3 or 8 BW**.

**Compatibility:** RULE-111 preserves the triggering event's original actual magnitude for event-referenced rewards; RULE-112 applies arithmetic to that recorded magnitude; RULE-110 distinguishes event properties from current-state variables. Trigger eligibility, source-removal cancellation, conditions, costs and FIFO timing remain unchanged. RULE-108 remains deferred.


## 179. RULE-114 — Explicit reward minimum applies to original event-referenced magnitude (LOCKED, 2026-11-11)

**Explicit user approval:** When a triggered ability computes a reward using the **original recorded magnitude of the triggering event**, any **explicit minimum on that reward** applies after the event-referenced amount is determined. Subsequent changes to the current resource pool do not alter the triggering event's recorded magnitude or the resulting minimum-adjusted reward. A card-specific minimum does not establish a universal minimum BW gain.

**Canonical example:** Installed Software A reads “Whenever you gain PULP prevention, gain BW equal to the amount gained in that event, to a minimum of 3 BW.” The Rustler gains **1 PULP prevention**, triggering A. Before A's queued trigger resolves, the current PULP prevention pool rises to **6** through another effect. If A's trigger remains eligible to resolve, it attempts to grant **max(1, 3) = 3 BW**, subject to applicable resource restrictions, **not 1 or 6 BW**.

**Compatibility:** RULE-111 preserves the original recorded event magnitude; RULE-112 permits arithmetic using that magnitude; RULE-113 applies explicit maximums. RULE-110 continues to govern distinct current-state variables. Existing trigger timing, eligibility, source-removal cancellation, costs and conditions remain unchanged. RULE-108 remains deferred.


## 180. RULE-115 — Event-referenced rewards obey explicit minimum and maximum (LOCKED, 2026-11-11)

**Explicit user approval:** When a triggered ability bases its reward on the **original recorded actual magnitude of its triggering event** and states both a **minimum and maximum** reward, compute the event-based reward and then constrain it to the stated inclusive range. This combines RULE-113 and RULE-114; it does not change the event's recorded magnitude or establish general resource caps.

**Canonical example:** Software A reads “Whenever you gain PULP prevention, gain BW equal to the amount gained in that event, to a minimum of 2 BW and a maximum of 5 BW.” If the triggering event actually gained **1 PULP prevention**, attempt to grant **2 BW**; if **3 PULP**, grant **3 BW**; if **8 PULP**, grant **5 BW**. Formula: **min(5, max(2, original event PULP gain))**, subject to applicable resource restrictions.

**Compatibility:** RULE-107/111 preserve recorded actual event magnitude; RULE-112 permits arithmetic based on that magnitude; RULE-113 and RULE-114 establish explicit maxima and minima. RULE-110 continues to govern separately referenced current-state variables. Trigger eligibility, cancellation, costs, conditions, FIFO timing and the deferred status of RULE-108 remain unchanged.


## 181. RULE-116 — Combine fixed triggering-event magnitude with resolution-time current resources (LOCKED, 2026-11-11)

**Explicit user approval:** When a triggered ability calculates a reward by combining an **event-referenced magnitude** with an explicitly **current game-state quantity**, each input follows its own timing rule: use the **original recorded actual magnitude** of the triggering event (RULE-107/111), but evaluate the **current** quantity at the **start of the discrete reward instruction** (RULE-102/110). Apply the printed arithmetic to those values. Later resource changes do not rewrite the triggering event; earlier values of current-state variables are not snapshotted at trigger time.

**Canonical example:** Installed Software A reads “Whenever you gain PULP prevention, gain BW equal to the amount gained in that event multiplied by your current Trace.” Rustler gains **3 PULP prevention** at **Trace 4**, triggering A. Before its queued trigger resolves, Trace rises to **6**. If the trigger remains eligible, the reward attempts to grant **3 × 6 = 18 BW**, not 12 BW, subject to applicable resource restrictions.

**Compatibility:** Preserves RULE-110's resolution-time current-value evaluation, RULE-111/112's original event-referenced magnitude, RULE-102/103's per-instruction value snapshot, and existing FIFO, eligibility, costs, conditions, source-removal cancellation. RULE-108 remains deferred.


## 182. RULE-117 — Distinct qualifying events create distinct event-referenced triggers (LOCKED, 2026-11-11)

**Explicit user approval:** When a Software ability triggers “whenever” a qualifying event occurs, **each distinct qualifying event** generates its **own trigger instance** and retains its **own recorded actual event magnitude**, provided the source remains eligible and no applicable frequency limit or other restriction prevents the trigger. Do not merge separate events merely because their queued triggers have not yet resolved. Each queued trigger resolves independently in the existing FIFO order.

**Canonical example:** Installed Software A reads “Whenever you gain PULP prevention, gain BW equal to the amount gained in that event.” The Rustler gains **3 PULP prevention**, creating a qualifying event and a queued trigger for **3 BW**. Before it resolves, another effect grants **5 PULP prevention**, a distinct qualifying event queuing another trigger for **5 BW**. If both triggers remain eligible, they separately attempt to grant **3 BW then 5 BW** in FIFO order, subject to applicable BW restrictions, **not one merged 8 BW trigger**.

**Compatibility:** RULE-076 distinguishes separate gain instructions/events; RULE-105/106 aggregate gains that form a single instruction's event; RULE-107/109 establish actual event magnitudes and threshold qualification; RULE-111/112 preserve event-referenced quantities; RULE-014/015/080 govern FIFO, and RULE-020–027 and RULE-081/082/085 govern limits and cancellation. RULE-108 remains deferred.


## 183. RULE-118 — Distinct queued triggers independently evaluate current-state operands (LOCKED, 2026-11-11)

**Explicit user approval:** When distinct qualifying events queue separate instances of a triggered ability whose reward combines **the magnitude of that specific triggering event** with a **current game-state variable**, each trigger retains its **own event's original recorded actual magnitude** and evaluates the current-state operand **independently at the start of its own discrete reward instruction**. A change in the current variable between resolutions affects later triggers but does not retroactively change earlier rewards or event magnitudes.

**Canonical example:** Software A reads “Whenever you gain PULP prevention, gain BW equal to the amount gained in that event plus your current Trace.” Event 1 gains **3 PULP prevention** and event 2 gains **5 PULP prevention**, queuing two separate triggers. At the first reward instruction, Trace is **4**, so that trigger attempts to grant **3 + 4 = 7 BW**. Before the second reward instruction, Trace increases to **6**, so the second attempts to grant **5 + 6 = 11 BW**. Total attempted BW gain is **18 BW**, if both resolve and applicable resource restrictions permit it.

**Compatibility:** RULE-102/103 govern per-instruction snapshots; RULE-107/111 fix event-referenced actual magnitudes; RULE-110/116 evaluate current-state operands at resolution; RULE-117 retains separate triggers for separate events. FIFO ordering, eligibility, costs, conditions, frequency limits, source-removal cancellation and the deferred status of RULE-108 remain unchanged.


## 184. RULE-119 — Multi-instruction triggered abilities recalculate current values per instruction (LOCKED, 2026-11-11)

**Explicit user approval:** When a triggered ability contains multiple **discrete instructions** that each reference a **current game-state variable**, evaluate that variable independently **at the start of each instruction**, under RULE-102/103. Do not snapshot the variable once for the whole ability. If an intervening change is legally permitted under the existing resolution/timing rules, the later instruction uses the updated value. This rule **does not create an interruption window** between instructions.

**Canonical example:** Software A reads “Whenever you gain PULP prevention, gain BW equal to your current Trace. Then gain PULP prevention equal to your current Trace.” After the qualifying event, the first reward instruction begins at **Trace 4**, so it attempts to grant **4 BW**. Assuming a legally permitted intervening effect changes Trace to **6** before the second instruction begins, the second instruction attempts to grant **6 PULP prevention**, not 4. All applicable resource restrictions and existing timing rules still apply.

**Compatibility:** Clarifies RULE-102/103 and RULE-110's per-discrete-instruction resolution-time evaluation. Does not alter RULE-010 printed instruction order, RULE-014/015 FIFO timing, eligibility, costs, conditions, source-removal cancellation, or deferred RULE-108.


## 185. RULE-120 — No automatic interruption window between ordinary instructions (LOCKED, 2026-11-11)

**Explicit user approval:** Resolve a card or ability's discrete instructions in their printed order **without an automatic interruption window between them**. An intervening effect may occur only where an existing timing rule or explicit card text permits it. Newly generated triggered abilities remain queued until the current ability finishes resolving, following the existing FIFO rules. RULE-102/103/119 still require current-state quantities to be evaluated independently at the start of each discrete instruction; those rules **do not themselves permit an interruption**.

**Canonical example:** Software A reads “Gain 4 BW. Then gain PULP prevention equal to your current Trace.” Trace is **4** when A starts resolving. The first instruction attempts to grant **4 BW**. With no legally permitted intervening effect that changes Trace, the next instruction immediately uses **Trace 4** and attempts to grant **4 PULP prevention**. Any triggers created during either instruction wait until A finishes, subject to existing timing, eligibility and resource restrictions.

**Compatibility:** Preserves RULE-010's printed order, RULE-014/015's queued-trigger timing and FIFO, RULE-102/103/119's per-instruction value evaluation, and all existing explicit exceptions. Does not create or remove any otherwise permitted interruption, nor resolve deferred RULE-108.


## 186. RULE-121 — Earlier instructions update current values for later calculations (LOCKED, 2026-11-11)

**Explicit user approval:** When one discrete instruction changes a game-state variable, a subsequent discrete instruction in the same resolving ability that refers to the **current** value of that variable uses the **updated game state** as it exists when that later instruction begins. Evaluate instructions in printed order; do not freeze the variable at ability start. This does not create an interruption window between ordinary instructions.

**Canonical example:** Software A reads “Increase your Trace by 2. Then gain PULP prevention equal to your current Trace.” The Rustler begins at **Trace 3**. The first instruction increases Trace to **5**. The second instruction then attempts to grant **5 PULP prevention**, using Trace 5 at the start of that instruction, subject to applicable restrictions.

**Compatibility:** RULE-010 governs printed instruction order; RULE-102/103/119 govern per-discrete-instruction current-value snapshots; RULE-120 forbids automatic interruption windows. Trigger timing, eligibility, resource limits, costs, conditions, source-removal cancellation and deferred RULE-108 remain unchanged.


## 187. RULE-122 — Earlier decreases update current values for later instructions (LOCKED, 2026-11-11)

**Explicit user approval:** When an earlier discrete instruction **reduces** a game-state variable, a subsequent discrete instruction in the same resolving ability that refers to that variable's **current** value uses the **actual reduced value** as it exists at the start of the later instruction. Apply the same per-instruction current-state evaluation to decreases as to increases under RULE-121; do not snapshot the variable at ability start.

**Canonical example:** Software A reads “Reduce your Trace by 2. Then gain PULP prevention equal to your current Trace.” The Rustler begins at **Trace 5**. The first instruction reduces Trace to **3**. The second instruction then attempts to grant **3 PULP prevention**, not 5, subject to applicable restrictions.

**Compatibility:** Preserves RULE-010 printed instruction order, RULE-102/103/119 per-instruction current-value snapshots, RULE-120 no automatic interruption, and RULE-121 updated values from earlier instructions. Existing resource floors/caps, trigger timing, costs, conditions, eligibility, source-removal cancellation and deferred RULE-108 remain unchanged.


## 188. RULE-123 — Later instructions use actual prior resource changes, not attempted amounts (LOCKED, 2026-11-11)

**Explicit user approval:** When a later discrete instruction refers to **the amount of a resource actually changed by an earlier instruction**, use the **actual change that occurred**, after applying applicable resource floors, caps, prevention, and other restrictions—not the printed or attempted change amount. The recorded actual change from that earlier instruction remains the referent even when the attempted amount exceeds what can occur.

**Canonical example:** Software A reads “Reduce your Trace by 5. Then gain PULP prevention equal to the amount of Trace actually reduced.” The Rustler begins at **Trace 3**, and Trace cannot fall below **0**. The first instruction attempts to reduce Trace by 5 but actually reduces it by **3**, leaving Trace **0**. The second instruction attempts to grant **3 PULP prevention**, not 5, subject to applicable restrictions.

**Compatibility:** RULE-107 distinguishes actual from attempted event magnitudes; RULE-010 preserves printed instruction order; RULE-102/103/119 evaluate numerical quantities at each discrete instruction; RULE-121/122 apply updated game state to later instructions. Existing trigger timing, costs, conditions, eligibility, resource limits, source-removal cancellation, and deferred RULE-108 remain unchanged.


## 189. RULE-124 — Conditional “if you reduced” requires a positive actual reduction (LOCKED, 2026-11-11)

**Explicit user approval:** A condition reading **“If you reduced [resource] this way”** is satisfied only if the referenced instruction **actually reduced that resource by a positive amount**. An attempted reduction that produces **zero actual change** does not satisfy the condition and grants no conditional reward. This rule addresses an effect condition, not whether an explicitly designated cost was fully paid; RULE-003 continues to govern costs.

**Canonical example:** Software A reads “Reduce your Trace by 3. If you reduced Trace this way, gain 2 BW.” The Rustler begins at **Trace 0**, and Trace cannot fall below 0. The attempted reduction of 3 produces **0 actual Trace reduction**, so the “if you reduced” condition fails and the Rustler gains **0 BW** from the conditional reward.

**Compatibility:** RULE-003's cost and conditional success principles remain intact; RULE-107/123 distinguish attempted from actual resource changes; RULE-010 governs printed order. Does not change trigger timing, eligibility, source-removal cancellation, resource limits, or deferred RULE-108.


## RULE-126 — SYN damage terminology and overflow (LOCKED, 2026-11-11)

**Authoritative decision:** The active damage keyword is **SYN X** (also styled **SYN DAMAGE X** in the approved rule review). Legacy **NEURAL DAMAGE** and **SYNAPTIC DAMAGE** are deprecated; neither is an active separate damage type. SYN is **Rustler-chosen** hand discard, never random discard. Historical mentions of the old terms elsewhere are superseded, not additional active mechanics.

Resolve SYN X in this order:
1. The Rustler chooses and discards as many cards as possible from their current hand, up to X.
2. Each unfulfilled point of SYN causes **2 Vitae damage**.
3. Apply that Vitae damage **after** discarding the available cards.

| SYN X | Hand | Discarded | Vitae damage |
|---:|---:|---:|---:|
| 3 | 3 | 3 | 0 |
| 3 | 2 | 2 | 2 |
| 3 | 1 | 1 | 4 |
| 3 | 0 | 0 | 6 |
| 5 | 2 | 2 | 6 |

**Priority:** RULE-126 supersedes older no-Vitae-loss statements for hand-discard damage and older random-discard SYN definitions. PULP remains direct Vitae damage; VOID remains persistent draw reduction. The approved overflow outcome is Vitae damage; do not silently reinterpret it as a separate SYN discard or VOID effect. Other prevention and trigger sequencing rules remain subject to their explicit text; do not invent unresolved interactions.

**Source:** `REDLINE_RULE_REVIEW_126.md`, approved and locked 2026-11-11. **Regression:** verify all five table cases and discard-before-Vitae ordering. RULE-127 remains pending.


**Terminology lock (2026-11-11):** **Vitae** is the canonical Rustler health resource (abbreviated **VIT** in the World Bible). The former health-resource term is deprecated. **PULP damage** reduces Vitae. This terminology update does not itself change damage-resolution mechanics.


**Damage terminology lock (2026-11-11):** **CHAR** is deprecated and replaced by **PULP damage**. **PULP X reduces Rustler Vitae by X**, subject to applicable PULP prevention. Earlier CHAR labels, examples, and prevention-pool references in this document are to be read as PULP. SYN remains mandatory Rustler-selected discard with its approved overflow rule; VOID remains distinct. This is a terminology replacement, not an additional damage type.


## RULE-127 — SyN prevention, mandatory discard, and overflow PULP (LOCKED, 2026-11-11)

**Approved resolution order:** When the Rustler receives **SyN X**:

1. **Apply SyN prevention:** Deduct available SyN prevention from incoming SyN, consuming no more prevention than the incoming amount.
2. **Determine unprevented SyN:** Resolve only the remaining SyN amount.
3. **Mandatory discard:** The Rustler **MUST** choose and discard as many cards as possible from their current hand, up to the unprevented SyN amount. The Rustler chooses *which* cards, but **cannot** voluntarily keep eligible cards and take PULP instead.
4. **Calculate overflow:** Each point of unprevented SyN not fulfilled by a card discard generates **2 PULP damage**, per RULE-126.
5. **Resolve PULP:** After mandatory discards, apply any available **PULP prevention** to the generated PULP damage; only unprevented PULP reduces **Vitae (VIT)**.

**Example:** Incoming SyN 5, SyN prevention 2, and 1 card in hand: 3 SyN remains; the Rustler must discard that 1 card; 2 SyN overflow generates **4 PULP**. Apply PULP prevention, if any, before reducing Vitae.

**Priority and scope:** RULE-127 specifies the resolution sequence and prevention interaction for RULE-126. **SyN** is Rustler-selected *mandatory* discard; **PULP** is the official Vitae-damaging keyword; **CHAR** is only colloquial slang for PULP in the World Bible; **VOID** is distinct. This rule does not invent additional prevention resources or change the previously established prevention-pool duration/stacking rules. Any unspecified simultaneous trigger timing remains open.

**Regression expectations:** Test full/partial/no SyN prevention, full/partial/empty hand, compulsory discard, PULP prevention of overflow, and zero-Vitae defeat. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-128 — SyN overflow PULP classification and triggers (LOCKED, 2026-11-11)

**Explicit user approval:** PULP generated by SyN overflow under RULE-126/127 is **ordinary PULP damage** for all mechanical purposes, not a fourth damage type. After SyN prevention and mandatory Rustler-selected discard, each unfulfilled SyN point generates **2 PULP**; resolve that PULP against the shared PULP prevention pool, and reduce **Vitae (VIT)** only by the unprevented remainder.

**Source-neutral application (explicit choice):** PULP prevention and PULP-related effects apply to overflow PULP **regardless of the damage's source**, even where an effect describes a particular source (for example, “prevent PULP from ICE”). For RULE-128 interactions, source descriptors do **not** exclude SyN-overflow PULP. This explicit exception supersedes the source-restriction option in the draft proposal; it does not change the distinction between damage types or permit other damage types to use PULP prevention.

**Trigger rule (explicit choice):** Only **actual PULP suffered**—the positive reduction of Vitae after prevention—counts for PULP-damage triggers. Merely generating, proposing, or fully preventing PULP **does not** trigger PULP-damage abilities. Effects requiring “when you suffer PULP” require **at least 1 VIT lost**. Do not introduce a separate “PULP generated” trigger category under RULE-128. Effects expressly referring to prevention itself are outside this PULP-damage-trigger rule and retain their printed conditions; their general timing remains governed by existing trigger rules.

**Examples:** SyN overflow generates 4 PULP, prevention 3 → suffer 1 PULP, lose 1 VIT, suffered-PULP trigger may fire. Overflow 6, prevention 6 → suffer 0 PULP, lose 0 VIT, no suffered-PULP trigger. Overflow 4, prevention 0 → suffer 4 PULP, lose 4 VIT. A source-described PULP prevention effect is eligible against overflow PULP under this rule.

**Compatibility:** RULE-127's order and compulsory discard remain unchanged. Three independent prevention pools (DMG-002), temporary prevention expiration (SOFT-013), and prohibition on reactive Rustler card play during Corporation turns (SOFT-011) remain unchanged. **CHAR** is in-world slang only; **PULP** is the official mechanical term. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-129 — Simultaneous mixed damage resolution (LOCKED, 2026-11-11)

**Explicit user approval:** When **one effect** inflicts two or more of the three damage types, resolve its damage components in the **fixed order PULP → SyN → VOID**, regardless of the effect's controller or the printed order of the listed damage types. Treat the mixed-damage instruction as one uninterrupted resolving effect for trigger-queue timing, with components processed sequentially against the updated game state.

1. **PULP component:** Spend applicable PULP prevention from the existing PULP pool; unprevented PULP reduces **Vitae (VIT)**. If VIT reaches zero, the run **ends immediately in defeat**. Stop; do not process remaining damage components or queued triggers.
2. **SyN component:** Apply SyN prevention, then the Rustler **MUST choose and discard** as many cards as possible up to unprevented SyN (RULE-127). Each missing discard generates **2 PULP** (RULE-126); resolve this overflow PULP immediately as part of the SyN component against the then-current PULP prevention pool. Only PULP actually suffered reduces VIT or qualifies for suffered-PULP triggers (RULE-128). If VIT reaches zero, immediately end the run; do not process VOID or queued triggers.
3. **VOID component:** Apply VOID prevention from its separate pool; resolve remaining VOID as persistent DRAW reduction subject to the established DRAW floor. VOID does not retroactively change cards already drawn.

**Triggers:** Damage-, discard-, and prevention-generated triggered effects are **queued as they arise**, not resolved between the mixed-damage components. Finish the entire mixed-damage effect before resolving its queued triggers under **RULE-014/015** (FIFO), with simultaneous enqueue priority under **RULE-011/012/013**. If immediate defeat occurs, the run ends and queued triggers do **not** resolve. Do not confuse this fixed *damage-component* order with the existing controller-selected order for separate simultaneous triggered effects; RULE-011/012 remain in force for those effects. The normal printed-order rule (RULE-010) still applies to other instructions and distinct effects; RULE-129 specifically overrides printed order for mixed damage components within one effect.

**Prevention and source:** PULP, SyN, and VOID retain their independent prevention pools (DMG-002). SyN overflow PULP uses the PULP pool and the source-neutral application and suffered-only trigger conditions of RULE-128. No reactive Rustler card plays during the Corporation turn (SOFT-011).

**Example:** One ICE subroutine inflicts PULP 3 + SyN 3 + VOID 2. Rustler has 10 VIT, 2 cards in hand, PULP prevention 1, no SyN/VOID prevention. Resolve PULP 3: prevent 1, lose 2 VIT (8 remain). Resolve SyN 3: mandatory discard 2, shortfall 1 generates 2 PULP; no PULP prevention remains, lose 2 VIT (6 remain). Resolve VOID 2: apply 2 persistent VOID counters. Queue generated triggers during these steps; resolve after the mixed-damage effect completes, if the run survives.

**Defeat precedence:** Reaffirms RULE-RT-002's immediate run defeat at zero Vitae; no later damage, advancement, or queued recovery may reverse defeat. **Status: LOCKED, explicitly approved 2026-11-11.**


### RULE-129 amendment — reversed fixed damage order (LOCKED, 2026-11-11)

**Explicit user revision supersedes the original RULE-129 ordering:** When one effect inflicts multiple damage types, the fixed component order is now **VOID → SyN → PULP**, regardless of controller or printed damage-type order. Any earlier RULE-129 statement of **PULP → SyN → VOID** is superseded and must not be used as the current resolution sequence.

1. **VOID first:** Apply VOID prevention and then persistent DRAW reduction under the established DRAW floor; no retroactive change to cards already drawn.
2. **SyN second:** Apply SyN prevention, mandatory Rustler-selected discards, and immediately resolve any resulting **overflow PULP** using the current PULP prevention pool (RULE-126/127/128). Check for immediate defeat after any VIT reduction.
3. **Direct PULP last:** Apply remaining PULP prevention to the effect's direct PULP component; unprevented PULP reduces Vitae (VIT). Check immediate defeat.

**Triggers and defeat unchanged:** Queue damage/discard/prevention triggers until the complete mixed-damage effect finishes (RULE-014/015/129), unless VIT reaches zero, which ends the run immediately and cancels unresolved components and queued triggers (RULE-RT-002). This ordering is fixed, not dynamically optimized or re-sorted by outcome. Reversing component order does not intrinsically increase numerical damage: VOID does not reduce the current hand, and PULP prevention is still consumed by eligible damage in resolution order.

**Revised example:** One effect inflicts PULP 3 + SyN 3 + VOID 2; Rustler starts at 10 VIT, 2 cards in hand, PULP prevention 1, no SyN/VOID prevention. First apply VOID 2. Next SyN 3 forces discard of both cards and generates 2 overflow PULP; prevent 1, suffer 1 (9 VIT). Finally direct PULP 3 is unprevented (6 VIT). Queue eligible triggers until all components finish.


## VOID damage enhancement — LOCKED (2026-11-11)

**Explicit user approval:** For each point of **unprevented VOID damage**, the Rustler **(1) gains one persistent VOID counter** reducing future normal DRAW by 1 (subject to the established effective DRAW floor of 1), and **(2) must choose and discard one card from their current hand if available**. If a required card is unavailable, **each missing discard generates 5 PULP damage**. Apply the existing PULP prevention pool to this overflow PULP; only unprevented PULP reduces Vitae (VIT) and counts as PULP suffered (RULE-128). The Rustler cannot elect to keep available cards and take overflow damage instead.

**Both consequences apply:** A VOID counter is gained **even when no card is available to discard and the 5 PULP overflow occurs**. VOID prevention is applied first; only unprevented VOID generates counters, required discards, and overflow. VOID overflow PULP is ordinary PULP under RULE-128, including its source-neutral prevention and suffered-only trigger semantics. Check immediate defeat whenever VIT is reduced to zero; unresolved instructions and pending triggers stop (RULE-RT-002).

**Mixed damage interaction:** RULE-129's current fixed order remains **VOID → SyN → PULP**. Resolve VOID's mandatory discards and overflow PULP within the VOID component before moving to SyN; this may leave fewer cards available for SyN and cause its separate **2 PULP per missing discard** overflow (RULE-126/127). Resolve direct PULP last. Damage/discard-generated triggers queue until the full mixed-damage effect completes, unless immediate defeat ends the run (RULE-014/015/129). Independent VOID, SyN and PULP prevention pools remain in effect.

**Example:** VOID 2 against a hand of 0, with no VOID or PULP prevention: gain 2 VOID counters, generate 10 PULP, and suffer up to 10 VIT loss (or immediate defeat upon reaching 0). VOID 2 against a hand of 1: gain 2 VOID counters, discard the 1 card, generate 5 PULP before prevention. A mixed effect of VOID 2 + SyN 2 against a hand of 2 first discards both cards and gains 2 VOID counters, then SyN 2 has a shortfall of 2 and generates 4 PULP before prevention.

**Priority:** This approved enhancement supersedes older descriptions that define VOID only as persistent DRAW reduction. No new ordinary-card VOID-counter removal is authorized; existing specialized network recovery and inter-corporation clearing remain unchanged.


## RULE-130 — Fatal damage, pending effects, and partial resolution (LOCKED, 2026-11-11)

**Explicit user approval:** Check Rustler Vitae (VIT) **immediately after every actual VIT reduction**, including direct PULP and PULP generated by SyN or VOID shortfall. Apply eligible PULP prevention first. If VIT reaches **0**, the run **immediately ends in defeat**; do not wait for the end of the damage component, card, ICE subroutine, mixed-damage effect, turn, or trigger queue.

**Pending recovery cannot reverse defeat:** No already-queued trigger, later instruction, pending recovery/heal, or future action resolves after defeat, even if it could restore Vitae. A recovery effect that **fully resolved before** the lethal VIT reduction counts normally. A damage-suffered trigger does not interrupt its originating effect; it remains queued per RULE-014/015 and cannot rescue the Rustler after lethal damage. This rule creates **no last-chance recovery exception**.

**Partial resolution is not rolled back:** Preserve all changes from instructions and components **already completed before defeat**, including spent prevention, mandatory discards, gained VOID counters, and earlier damage. **Cancel all remaining unresolved instructions, damage components, and queued triggered effects**. Do not roll back completed changes or continue resolving effects after defeat. This is a terminal game-state record, not permission to resume the run.

**Compatibility and priority:** Reaffirms **RULE-RT-002** (immediate defeat), **RULE-014/015** (deferred FIFO triggers), **RULE-127/128** (SyN shortfall and actual PULP suffered), and **RULE-129** (current fixed mixed-damage order **VOID → SyN → PULP**, with VOID's mandatory discard and **5 PULP per missing discard** enhancement). Each type's prevention remains separate, with overflow PULP consuming eligible PULP prevention. Defeat takes priority over queued recovery and over the instruction to complete the mixed-damage event before processing queued triggers. This clarification does not alter controller ordering of simultaneous triggers (RULE-011/012/013) or permit reactive Rustler card plays (SOFT-011).

**Example:** Rustler has **6 VIT**, **0 cards** in hand, and **no prevention**. VOID 2 first grants **2 persistent VOID counters**, requires 2 discards, and generates **10 PULP** for the 2 missing cards. Upon lethal VIT loss, defeat is immediate. The completed VOID counters and other completed changes remain recorded; subsequent SyN or direct PULP components, later instructions, and queued recovery triggers never resolve.

**Status: LOCKED — explicitly approved 2026-11-11.**


## RULE-131 — Mandatory prevention consumption, immediate overflow, and detailed accounting (LOCKED, 2026-11-11)

**Explicit user approval:** Eligible damage prevention is **automatic and mandatory**. At each actual damage application, the engine consumes applicable prevention immediately; the Rustler cannot decline or withhold eligible prevention to save it for a later component or source. PULP, SyN, and VOID have **independent type-specific numerical pools** (DMG-002); only prevention eligible for the incoming damage type may be spent. The displayed pooled value is backed by source/duration accounting.

**Consumption order (RULE-004/005/006):** Within a type-specific pool, consume eligible contributions in the priority already established by RULE-004/005 (earliest expiration first), with the existing RULE-006 equal-expiration tie-breaker. RULE-131 creates **no new source priority**, no player-selected prevention withholding, and no cross-type spending. Record each source contribution consumed and its remaining value.

**Overflow timing and order:** Under the current RULE-129 fixed mixed-damage order **VOID → SyN → PULP**, complete each component before proceeding to the next. For unprevented VOID, apply its persistent counters and mandatory Rustler-selected hand discards; each missing discard generates **5 ordinary PULP**. **Immediately resolve that overflow PULP within the VOID component**, automatically consuming then-eligible PULP prevention. Next, for unprevented SyN, perform mandatory Rustler-selected discards; each missing discard generates **2 ordinary PULP**, likewise immediately resolved within the SyN component using the PULP pool remaining at that moment (RULE-126/127). Finally, apply any direct PULP component against the remaining PULP prevention. The Rustler cannot defer or pool overflow PULP until the final direct PULP component. VOID and SyN prevention are applied before determining their respective unprevented damage and overflow. Source-neutral PULP prevention and suffered-only PULP triggers remain as locked by RULE-128.

**Defeat and triggers:** After prevention, if an actual PULP application reduces Vitae (VIT) to zero, defeat is immediate (RULE-RT-002/RULE-130). Preserve completed changes, cancel unresolved damage components/instructions and pending triggers; no queued recovery can reverse defeat. Otherwise, triggers generated by damage, discards, or prevention are enqueued during resolution and resolve only after the containing mixed-damage effect completes, under RULE-014/015 and RULE-129. This rule does not authorize reactive Rustler card plays during the Corporation turn (SOFT-011).

**Mandatory UI and log accounting:** For each damage application, show the **damage source and type**, incoming amount, prevention consumed **broken down by contributing source and duration**, each type-specific pool's remaining amount, unprevented VOID/SyN, mandatory discards completed and shortfalls, **overflow PULP generated and immediately prevented**, **actual PULP suffered**, resulting VIT change, and persistent VOID counters gained. Preserve the step-by-step order in the action log; show when lethal defeat truncates further resolution. These are interface/reporting requirements, not new trigger events.

**Canonical example:** One effect inflicts VOID 2 + SyN 2 + direct PULP 3 against a Rustler with **10 VIT, 1 card in hand, 4 PULP prevention, and no VOID or SyN prevention**. VOID 2 adds two counters, discards the one card, and generates 5 PULP for the one missing discard; automatically spend 4 PULP prevention and suffer 1 PULP (VIT 9). SyN 2 has no cards to discard, generates 4 PULP and suffers 4 (VIT 5). Direct PULP 3 suffers 3 (VIT 2). All generated triggers queue until the effect completes unless defeat intervenes.

**Status: LOCKED — explicitly approved 2026-11-11.**


## RULE-132 — Post-Corporation hand cleanup and defensive hand retention (LOCKED, 2026-11-11)

**Explicit user approval:** Ordinary unplayed cards **remain in the Rustler's hand through the Corporation Response Phase** and are available for mandatory damage discards. Move routine non-CACHED hand cleanup **after the entire Corporation response and its queued triggers**, before beginning the next Rustler turn or transitioning to another ICE layer. This **supersedes only the pre-Corporation hand-discard timing** in RULE-RT-003/004/005; retain the established end-of-turn effects, BW forfeiture, and Corporation response sequencing.

**Revised turn order:** (1) Rustler voluntarily selects END TURN (RULE-RT-001); (2) resolve Rustler end-of-turn effects, including applicable BW effects and their triggered consequences; (3) **forfeit all remaining BW** (set available BW to zero); (4) enter and fully resolve Corporation Response, including ICE subroutines, damage and all applicable queued triggers; (5) if the run survives, perform **one post-response cleanup**, discarding all remaining non-CACHED cards from hand and resolving resulting discard triggers under RULE-014/015; (6) only after cleanup and its triggers finish, proceed to the next Rustler turn, ICE PASS, or Node/ICE transition as applicable. **No routine hand discard takes place between steps 2 and 4.**

**End-of-turn versus cleanup triggers:** Abilities explicitly triggered by **end of Rustler turn** still trigger at the existing end-turn window, before BW forfeiture and Corporation response. Abilities triggered by **actually discarding a card** trigger when that discard occurs: damage-induced discards during Corporation response occur then and queue per RULE-014/015/129; routine cleanup discards occur after the response and their triggers resolve before transition. A cleanup discard is **not retroactively an end-of-turn discard** for effects requiring that timing. Resolve the post-response cleanup discard batch and its generated triggers before advancing; follow existing simultaneous-trigger priority and FIFO queue rules. This relocation may change whether discard-generated prevention can affect the current Corporation response; do not backdate it.

**CACHE reconciliation (SOFT-003 through SOFT-008):** CACHE continues to protect selected cards from **routine cleanup**, not from damage. **CACHED cards are eligible for mandatory VOID and SyN discards** under the normal Rustler-selection rule (RULE-001), unless an effect expressly provides protection. If discarded by damage, they leave hand and cannot be retained by CACHE. CACHED cards remaining after response survive cleanup, persist across ICE layers within the same Node while supported, and remain **additive to normal DRAW** (SOFT-004/005/006). Loss of CACHE support (SOFT-007) causes affected cards to be treated as ordinary cards at the next applicable cleanup, not discarded immediately merely for losing retention; explicit corporate discard and CACHE-targeting effects (SOFT-008) still work. CACHE does not survive the Node boundary (SOFT-006).

**ICE PASS:** If an ICE PASS or advancement occurs after a Corporation response, use the **single post-response cleanup** for the ordinary non-CACHED hand; do **not** run an additional routine PASS hand discard for those same cards. Finish cleanup-generated triggers before PASS transition. Other PASS-specific effects and triggers remain governed by their actual printed trigger conditions and existing rules; do not invent a second discard event. The next ICE layer retains the established fresh normal DRAW and additive surviving CACHE, subject to existing Node/ICE setup rules.

**DRAW remains unchanged:** No defensive DRAW is added during Corporation response. Preserve RULE-028/029/030/031 start-of-turn sequencing (refresh BW, resolve start-of-turn triggers, calculate DRAW, then normal DRAW) and current effective DRAW formula **max(1, 5 − VOID counters + applicable modifiers)**. Installed Hardware does not inherently reduce DRAW. CACHED cards are additive and do not reduce the number of new cards drawn; VOID counters gained during the response affect future DRAW only.

**Damage and defeat unchanged:** During Corporation response, retained ordinary and CACHED cards are available for mandatory damage discards. Apply the fixed mixed-damage order **VOID → SyN → PULP** (RULE-129). Each unprevented VOID grants its persistent counter and requires one discard; each missing discard generates **5 ordinary PULP**. Each unprevented SyN requires one discard; each missing discard generates **2 ordinary PULP** (RULE-126/127). Apply type-specific prevention automatically and immediately, including PULP prevention against overflow within the originating component (RULE-128/131). Damage-generated triggers remain queued until their containing effect completes (RULE-014/015/129). If Vitae reaches zero, immediate defeat (RULE-RT-002/RULE-130) cancels remaining instructions, pending triggers and post-response cleanup, preserving completed changes.

**Canonical example:** Rustler starts with five cards, plays two, and ends the turn holding three. End-turn effects resolve; unused BW is forfeited; the hand is **not** discarded. Corporation inflicts VOID 2 + SyN 2, with no prevention: VOID adds two counters and discards two cards; SyN discards the final card and generates **2 PULP** for one missing discard, reducing Vitae by two if unprevented. No ordinary cards remain at post-response cleanup. At the next normal DRAW, absent other modifiers, the two VOID counters reduce DRAW from five to three.

**Priority:** RULE-132 explicitly supersedes the earlier pre-response routine discard instruction of RULE-RT-003/004/005 and the related older end-turn discard timing in SOFT-003/007, while preserving the underlying CACHE, BW, trigger, damage, defeat, ICE PASS and DRAW mechanics as reconciled above. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-133 — Discard-trigger timing and nonretroactive prevention (LOCKED, 2026-11-11)

**Explicit user approval:** When VOID, SyN, or another effect causes one or more cards to be discarded, discard-triggered abilities generated by those discards **queue as they arise** and **do not interrupt the originating effect**. Finish the entire originating effect (including its remaining mixed-damage components in the fixed **VOID → SyN → PULP** order, immediate overflow PULP, and any other instructions) before resolving its queued triggers. Use existing RULE-011/012/013 simultaneous-trigger ordering and RULE-014/015 FIFO queue semantics; do not create a new priority or interrupt window.

**Prevention gained by discard triggers:** Prevention from a triggered ability becomes available **only when that ability actually resolves**. It applies to eligible **subsequent damage** within its permitted duration, including a later ICE subroutine in the same Corporation response if applicable. It **never retroactively prevents** PULP, SyN, or VOID already resolved, and cannot be spent before it has been gained. Once gained, prevention follows DMG-002 and RULE-004/005/006 (type-specific pools and earliest-expiration consumption) and RULE-131 (automatic mandatory consumption). Damage overflow from missing VOID/SyN discards resolves immediately within its originating component under RULE-127/128/129/131, without waiting for discard-triggered prevention.

**Post-Corporation cleanup:** Following RULE-132, after the Corporation response and its pending triggers have finished, discard all remaining non-CACHED cards in the **single post-response cleanup**. Abilities triggered by those actual cleanup discards queue during cleanup and **resolve before the next Rustler turn, ICE PASS, or Node/ICE transition**. Do not defer them to the next turn and do not add a second ordinary PASS discard. These triggers cannot retroactively change damage or prevention from the already-completed Corporation response. End-of-turn triggered abilities retain their earlier end-of-turn window; cleanup discards do not retroactively count as discards during that window.

**CACHE:** CACHED cards are exempt from routine cleanup but remain eligible for mandatory VOID/SyN damage discards unless explicitly protected (RULE-132 and SOFT-003–008). Discarding a CACHED card by damage generates applicable discard triggers under the same deferred timing; CACHE does not create an interrupt or retroactive prevention exception.

**Defeat and cancellation:** Check VIT immediately after each actual VIT reduction following prevention. At zero VIT, defeat is immediate and unresolved instructions and pending triggers are cancelled, with completed state changes preserved (RULE-RT-002/RULE-130). A queued discard-triggered prevention or recovery effect cannot rescue the Rustler after fatal damage. SOFT-011 still prohibits reactive Rustler card plays during Corporation turn; already-established triggered abilities may resolve when their queued turn arrives.

**Canonical example:** Rustler has 10 VIT, three cards in hand, no prevention, and installed Software reading *“Whenever you discard a card, gain 2 PULP prevention.”* One Corporation subroutine inflicts **SyN 2 + direct PULP 4**. SyN discards two Rustler-chosen cards, queuing two prevention-gain triggers; the triggers do **not** resolve yet. Direct PULP 4 is unprevented, reducing VIT to **6**. Once the subroutine's full effect finishes, the two queued triggers resolve under FIFO and grant **4 PULP prevention** in total (subject to applicable ability limits and source validity). That prevention may protect against a later subroutine but cannot prevent the earlier 4 PULP. If the Rustler had been defeated during the subroutine, the queued triggers would instead be cancelled.

**Priority and reconciliation:** RULE-133 **clarifies, rather than overrides**, RULE-014/015 deferred-trigger resolution; RULE-127/128/129/130/131 damage ordering, prevention, overflow, and fatal damage; RULE-132 post-response cleanup and ICE PASS; and SOFT-003–008 CACHE. It introduces **no retroactive protection, extra DRAW, out-of-turn Rustler card-play window, or new discard event**. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-134 — Discard event granularity, trigger frequency, and separate overflow PULP events (LOCKED, 2026-11-11)

**Approved design:** Use the existing instruction-level event model and deferred trigger queue; no new timing or interrupt system. Each **discrete discard instruction or damage component** produces **one grouped discard event** containing a separately recorded occurrence for **each card actually discarded**. Discard zero cards means zero actual card-discard occurrences; do not generate an actual-discard trigger for a shortfall. Distinct instructions are distinct groups even within one card effect. For a mixed damage effect, VOID and SyN are distinct damage components and thus distinct discard groups, even when one ICE subroutine generates both. One ordinary post-Corporation cleanup (RULE-132) is one grouped event containing its individual actual discards, and ICE PASS does not add a second routine cleanup group.

**Trigger wording controls counting:** “Whenever you discard **a card**” recognizes each individual actual card discard (three cards = three qualifying occurrences, subject to existing once-per-turn/activation limits). “Whenever you discard **one or more cards**” recognizes each grouped discard event with at least one actual discard (three cards in one instruction = one qualifying group). “For each card discarded” within a single group uses the group's actual card count as the magnitude of the relevant instruction, not separate events unless its printed trigger explicitly says per card. “The first time ... each turn” retains its existing per-turn allowance; a multi-card discard does not reset or bypass it. Card-specific qualifiers and source validity still apply. Preserve RULE-054/055, RULE-074–079, RULE-105/106 aggregate event identity, RULE-107 actual-vs-attempted magnitude, and existing per-turn limits.

**Separate overflow PULP events (explicit user decision):** For **each missing mandatory VOID discard**, generate a **separate ordinary PULP 5 damage event**; for **each missing mandatory SyN discard**, generate a **separate ordinary PULP 2 damage event**. Never aggregate multiple missing discards into one PULP event for damage-event trigger counting, even when they arise from the same damage component or ICE subroutine. Resolve each generated PULP event **immediately in sequence inside its originating VOID or SyN component**, applying available mandatory PULP prevention afresh against that event under RULE-128/131 and recording actual PULP suffered separately. Triggered effects recognizing a PULP damage event or actual PULP suffered count each qualifying separate event under their exact wording and applicable limits, but **remain queued** until the entire originating effect completes (RULE-014/015/129/133); they cannot create retroactive prevention or interrupt the next overflow event. After resolving all overflow events in VOID, proceed to SyN, then direct PULP, under RULE-129's fixed **VOID → SyN → PULP** order. A direct PULP component remains its own damage event under existing instruction-level rules. Check Vitae after every actual reduction: at VIT zero, RULE-130 immediately ends the run, cancels further overflow events, remaining instructions and queued triggers, preserving completed changes.

**Sequencing and bookkeeping:** For each component, first apply type-specific VOID/SyN prevention; apply each unprevented point's counter/discard consequences as established in RULE-127/129/131, recording actual card discards in the component's grouped discard event and resolving any missing-discard overflow PULP immediately as individual damage events. Preserve mandatory earliest-expiration prevention consumption (RULE-004/005/006/131). Each separate overflow PULP event records its source, originating damage type, amount (5 or 2), PULP prevention consumed by source/duration, actual VIT loss, and associated pending triggers. Discard-trigger occurrences record each card, grouping identifier, source, and reason. Trigger ordering for simultaneously recognized occurrences follows existing controller-order and FIFO rules; no new interrupt window is created.

**Examples:** (A) “Discard 3 cards” actually discards three: one grouped discard event, three per-card discard occurrences; a “whenever you discard a card” ability can queue three triggers, while “whenever you discard one or more cards” queues one. (B) VOID 2 + SyN 2 with four cards in hand: two grouped discard events (VOID discards two, SyN discards two), four individual card discards; per-card trigger count four, per-group trigger count two, before limits. (C) VOID 3 against an empty hand, with no prevention: gain three VOID counters; the three missing discards generate **three separate PULP 5 events**, in sequence, each with independent prevention and trigger-event accounting, stopping immediately on lethal VIT loss. (D) SyN 2 against an empty hand generates **two separate PULP 2 events**, not one PULP 4 event; aggregate VIT loss can equal four if unprevented and nonlethal, but event count remains two.

**Reconciliation and priority:** This rule clarifies RULE-010 instruction boundaries, RULE-014/015 deferred FIFO triggers, RULE-105/106 grouping, RULE-126–131 damage/overflow and prevention, RULE-132 single cleanup and CACHE timing, and RULE-133 deferred discard triggers and nonretroactive prevention. **It explicitly specifies separate overflow PULP event granularity**, superseding any inference that all shortfall PULP in one component forms a single event; numeric PULP amounts and existing prevention mechanics are unchanged. No reactive Rustler card plays or extra DRAW are created. **Status: LOCKED, approved 2026-11-11.**


## RULE-135 — Damage-event identity, trigger eligibility, and prevention accounting (LOCKED, 2026-11-11)

**Explicit approval:** Each separate PULP damage application is an independent damage event for trigger eligibility and accounting, including each individual overflow PULP 5 from a missing VOID discard and each individual overflow PULP 2 from a missing SyN discard (RULE-134). Do not merge them into one event merely because they arise from the same ICE subroutine, damage component, or effect. Distinguish **damage applied** (an attempted PULP application, even when fully prevented), **damage prevented** (amount actually absorbed by eligible PULP prevention), and **damage suffered** (unprevented PULP actually reducing Vitae). Abilities recognize only the event their printed conditions name; do not conflate these categories.

**PULP-suffered eligibility:** “Whenever you suffer PULP damage” triggers only on a PULP event that **actually reduces VIT**, and once per qualifying event unless printed wording or an existing activation limit says otherwise. A fully prevented PULP event does **not** qualify as PULP suffered. Event magnitude for “PULP suffered” equals actual VIT reduction, not incoming PULP; prevention amount equals actual prevention consumed, not incoming PULP or unused pool capacity. Preserve RULE-107–109 actual-versus-attempted magnitude and threshold handling, as well as existing per-turn and per-source trigger limits.

**Prevention-event eligibility:** “Whenever you prevent damage” and comparable prevention-consumption triggers recognize only **actual positive prevention consumed**; a zero-consumption event does not qualify. Count prevention separately for each damage application and by the applicable prevention source/duration contribution under RULE-004/005/006 and RULE-131; do not invent a gain or consumption when none occurred. If one damage application consumes several prevention sources, apply existing RULE-074–079, RULE-105/106 and exact card wording to determine per-event versus per-source qualification; this rule does not automatically multiply a single event into one trigger per contributing source. Type-specific VOID and SyN prevention remain separate from PULP prevention; their consumption is accounted for when the respective type is applied.

**Timing:** All damage-, discard-, prevention-, and related triggers are queued as generated, following existing simultaneous-controller ordering and FIFO rules (RULE-011–015). They **do not interrupt their originating effect**, including between separate overflow PULP events within one VOID/SyN component. Resolve the entire originating effect before its queued triggers. Prevention granted by a queued trigger can apply only to **later** eligible damage after it actually resolves, never retroactively or to an earlier overflow event (RULE-133). Resolve each overflow event immediately within its originating component, with mandatory PULP prevention consumed under RULE-131, and preserve fixed mixed-damage order **VOID → SyN → direct PULP** (RULE-129). If VIT reaches zero, defeat is immediate; cancel unresolved damage events, instructions, and queued triggers without reversing completed changes (RULE-130).

**Worked example:** Rustler begins at **20 VIT**, with no hand cards, **6 PULP prevention**, and no VOID prevention. Corporation inflicts VOID 3: gain 3 VOID counters and encounter 3 missing mandatory discards. Generate and resolve **three distinct PULP 5 events**, in order. Event 1: prevent 5, suffer 0, VIT 20. Event 2: prevent 1, suffer 4, VIT 16. Event 3: prevent 0, suffer 5, VIT 11. Thus there are **3 PULP applications**, **2 PULP-suffered events**, **2 events with positive PULP prevention**, **6 total PULP prevented**, and **9 total PULP suffered**. A “whenever you suffer PULP damage” ability recognizes two events, subject to its limits; its triggers wait until the full originating VOID effect completes. If the Rustler is defeated during any event, remaining events and queued triggers are cancelled.

**Reconciliation and priority:** RULE-135 clarifies, without overriding, RULE-004–006 mandatory source/expiration consumption, RULE-014/015 FIFO deferred triggers, RULE-074–079 prevention-event granularity, RULE-105–109 aggregate events and actual magnitudes, RULE-126–131 damage/overflow and fatal defeat, RULE-132 post-Corporation cleanup, RULE-133 nonretroactive trigger timing, and RULE-134 separate overflow PULP event identity. No new interrupt window, defensive DRAW, retroactive prevention, or extra routine discard is created. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-136 — Damage resolution boundaries and trigger queue checkpoints (LOCKED, 2026-11-11)

**Explicit approval:** Each **independently resolving ICE subroutine** is a distinct effect boundary. Resolve the subroutine's full effect to completion before processing triggers generated by it. This includes all its discrete instructions, mandatory type-specific prevention, VOID counters and required discards, SyN discards, separate overflow PULP events for each missing discard (RULE-134), direct PULP, and resulting VIT changes, in the fixed **VOID → SyN → PULP** component order where mixed damage applies (RULE-129). Do **not** insert a trigger-resolution checkpoint between individual damage components, overflow PULP events, or instructions inside that still-resolving effect. The same principle applies to other independently resolving effects: finish the current effect before its generated triggers.

**Mandatory checkpoint between effects:** After the current independently resolving effect completes, **fully drain all eligible queued triggers** before beginning the next independent ICE subroutine or other effect. Use the existing simultaneous-trigger/controller ordering, FIFO queue, and complete-one-effect-before-generated-triggers semantics (RULE-010–015). A trigger that generates further triggers places them on the existing queue; continue resolving eligible chained triggers until the queue is empty, subject to RULE-016–019 infinite-loop and recursion safeguards and existing trigger eligibility, per-turn activation limits, source-removal cancellation, and explicit exceptions. Do not resolve only the first generation or carry eligible chained triggers into the next effect. An individual queued triggered ability is itself resolved completely before its newly generated triggers are processed under the established queue discipline.

**Updated state between subroutines:** At the next subroutine boundary, apply the game state after the preceding effect and its drained triggers, including new prevention pools, changed VIT, resource changes, discarded cards, VOID counters, installed/removed sources, and temporary effect durations. Prevention gained when a trigger actually resolves may protect against a **later** subroutine if eligible and still active; it **cannot** prevent damage from the completed originating subroutine or any earlier overflow PULP event (RULE-133/135). No new reactive Rustler card-play window or out-of-turn DRAW is created (SOFT-011; RULE-132).

**Corporation response and cleanup:** Finish **all** Corporation response effects and their full trigger checkpoints before performing the **single** post-Corporation hand cleanup required by RULE-132. Routine cleanup discards all remaining non-CACHED cards in one grouped discard event (RULE-134), while eligible CACHED cards survive routine cleanup but remain eligible for mandatory VOID/SyN damage discards. Cleanup-generated triggers resolve and drain completely before the next Rustler turn, ICE PASS, or Node/ICE transition (RULE-132/133). Never start cleanup with eligible Corporation-generated triggers pending, and never create a second routine ICE PASS cleanup event.

**Immediate defeat overrides checkpoints:** Check VIT after each actual reduction, including each separately resolved overflow PULP event. At VIT 0, defeat immediately ends the run (RULE-RT-002/RULE-130); preserve completed changes but cancel remaining instructions, unresolved damage events, queued triggers and post-response cleanup. No pending heal, recovery, or prevention trigger can rescue the defeated Rustler. Mandatory prevention consumption, source expiration priorities, and applied/prevented/suffered event distinctions remain RULE-004–006/131/135.

**Canonical example:** Rustler begins at **12 VIT**, with no PULP prevention, and has installed Software: *“Whenever you suffer PULP damage, gain 3 PULP prevention.”* Corporation resolves two independent unbroken ICE subroutines. Subroutine 1 inflicts **PULP 4**; Rustler suffers 4, dropping to **8 VIT**, and queues the Software trigger. Subroutine 1 finishes; at its checkpoint the queued trigger resolves, granting **3 PULP prevention**. Subroutine 2 inflicts **PULP 5**; mandatory prevention absorbs 3, Rustler suffers 2 and drops to **6 VIT**. The second suffered-damage trigger queues for the checkpoint **after subroutine 2**, not during it. If both PULP instructions were within one independently resolving effect, no checkpoint would occur between them and the new prevention would not apply until afterward.

**Compatibility and priority:** RULE-136 establishes explicit checkpoints **without changing** RULE-010 printed instruction order, RULE-011–015 trigger ordering/FIFO/complete-effect semantics, RULE-016–019 loop safeguards, RULE-126–131 damage types, prevention, overflow and immediate defeat, RULE-132 post-response cleanup and DRAW/CACHE timing, RULE-133 nonretroactive prevention, RULE-134 grouped discard events and separate overflow PULP event identity, or RULE-135 actual-versus-attempted event eligibility. A subroutine is an effect boundary only when it is independently resolving; explicit text defining a single combined effect or existing exceptions retains its established effect boundary. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-137 — Routine post-Corporation cleanup is non-triggering housekeeping (LOCKED, 2026-11-11)

**Explicit approval and precedence:** Routine post-Corporation hand cleanup is a **non-triggering housekeeping operation outside all effect-triggering windows**. Once the entire Corporation response and **all eligible queued/chained triggers** have finished (RULE-132/136), perform the single routine cleanup: discard every remaining **non-CACHED** card from the Rustler's hand. These routine cleanup discards **do not generate, queue, or resolve discard-related triggered abilities or any other effect solely because cleanup discarded cards**. They cannot activate installed Software, card abilities, per-card/per-group discard triggers, prevention gains, DRAW, resource gains, or chained effects based on those housekeeping discards. Cleanup is not an effect-triggering checkpoint; once the cleanup action and its bookkeeping finish, advance directly to the next established phase or ICE/Node transition. Do not repeat cleanup or create an additional ICE PASS cleanup.

**Normal effect-caused discards unchanged:** This exception applies **only to routine cleanup discards**. Discards caused by VOID or SyN damage, ICE subroutines, Corporation instructions, Rustler card abilities, or other resolving effects remain ordinary effect-caused discards, with their existing individual occurrences, grouped event granularity, eligibility, and deferred FIFO trigger timing under RULE-014/015/127/129/133/134/135/136. A discard that happens **during Corporation response** is not routine cleanup merely because it occurs near the end of the response. All pending effect-generated triggers drain before housekeeping cleanup begins. Explicit card effects are not silently reclassified as housekeeping cleanup.

**CACHE, logging, and accounting:** CACHED cards survive routine cleanup under SOFT-003–008 and RULE-132, unless some separate effect explicitly discards them. Routine cleanup discards are still real cards moved out of hand and **must be recorded** in the game log with card identities, number discarded, phase, and reason marked **ROUTINE CLEANUP / NON-TRIGGERING**. They are not qualifying discard occurrences for trigger activation or trigger-frequency accounting, despite being recorded as a single housekeeping cleanup batch. Do not count them toward effects that ask whether a card was discarded via a triggering event. No defensive DRAW or other benefit is created by cleanup itself.

**Example:** Rustler finishes Corporation response with three non-CACHED cards and installed Software reading *“Whenever you discard a card, gain 2 PULP prevention.”* After all response-generated triggers have drained, routine cleanup discards the three cards and logs the batch. **Zero Software triggers** are generated and **zero PULP prevention** is gained from those housekeeping discards. The same Software still recognizes qualifying cards discarded earlier by VOID/SyN or another effect, subject to its normal limits.

**Explicit supersession and reconciliation:** RULE-137 **supersedes only conflicting statements that routine post-Corporation cleanup discards generate or resolve triggers** in RULE-132 (cleanup-generated triggers), RULE-133 (cleanup discard-trigger timing and cleanup-generated effects), RULE-134 (any inference that routine cleanup's grouped discard event generates per-card/per-group discard triggers), and RULE-136 (cleanup-generated/chained trigger checkpoint). All other provisions of RULE-132–136 remain LOCKED and operative: hand retention through Corporation response, full response trigger draining, single post-response cleanup, CACHE survival, separate overflow PULP events, prevention accounting, FIFO effect boundaries, and immediate defeat. Under RULE-010–019, this is a specific housekeeping exception to ordinary effect-trigger eligibility, **not** a new trigger window, queue behavior, or loop rule. Existing rules governing genuine effect-caused discards continue unchanged. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-138 — Discard classification by originating cause and phase-boundary trigger completion (LOCKED, 2026-11-11)

**Explicit approval:** Classify each discard by its **originating cause**, not by how close it occurs to a phase boundary, Corporation response ending, ICE PASS, Node transition, or routine cleanup. A discard expressly caused by an ICE subroutine, Corporation instruction, VOID/SyN damage, Rustler card ability, queued triggered ability, or other independently resolving game effect is an **effect-caused discard**, including when it happens immediately before routine cleanup. Such actual discards retain their normal individual-card occurrences and grouped-event identities (RULE-134), eligible triggers and activation limits, and deferred FIFO resolution (RULE-010–015/133–136). Do not silently reclassify effect-caused discards as housekeeping merely because they happen late in the Corporation response.

**Non-triggering cleanup exception:** A discard is **routine housekeeping cleanup** only when it is performed by the single mandatory post-Corporation hand cleanup operation itself. Under RULE-137, those cleanup discards are logged but do **not** generate, queue, or resolve triggered effects based on being discarded. All remaining non-CACHED cards are discarded in that single housekeeping batch; CACHED cards retain their existing exemption. This exception does not suppress triggers from an effect that actually resolves before cleanup or otherwise change damage-caused discards.

**Strict transition checkpoint:** Complete the entire final Corporation effect, then **fully drain all eligible effect-generated triggers and any chained triggers** under RULE-014–019 and RULE-136 **before** routine cleanup begins. If an effect-generated discard causes a trigger that draws or otherwise adds non-CACHED cards to hand, those cards are present when routine cleanup starts and are discarded as part of its non-triggering housekeeping batch unless separately CACHED or otherwise explicitly protected. No eligible Corporation-generated trigger carries into or across cleanup. After the non-triggering cleanup and its bookkeeping, proceed directly to the established next phase, ICE PASS, or Node transition; no additional routine cleanup or cleanup trigger checkpoint is created.

**Logging and auditability:** Record **effect-caused** and **housekeeping** discards as distinct cause classifications. For effect-caused discards, log the originating effect/source, phase, individual card identities and count, grouped discard event identifier, actual qualifying occurrences, and queued/resolved/cancelled triggers as appropriate. For housekeeping discards, log the phase, card identities and count, reason **ROUTINE CLEANUP / NON-TRIGGERING**, and zero generated triggers. Keep the physical discard record even though housekeeping discards are ineligible for discard-trigger frequency or event counting under RULE-137. Preserve existing source eligibility, card-text limits, and mandatory event bookkeeping; do not invent a new interrupt or reaction window.

**Canonical example:** At the last independent Corporation ICE subroutine, the Rustler has three non-CACHED cards and installed Software: *“Whenever you discard a card, gain 1 CRED.”* The subroutine reads *“Discard 2 cards from your hand. Then gain 2 PULP prevention.”* Two actual effect-caused discards form one grouped discard event and queue two per-card triggers (subject to limits). The subroutine finishes its printed instructions and grants 2 PULP prevention; only at the checkpoint do the two queued triggers resolve, gaining 2 CRED. Routine cleanup then discards the remaining non-CACHED card, records it as **ROUTINE CLEANUP / NON-TRIGGERING**, and generates **no CRED trigger**. If the checkpoint instead draws two new non-CACHED cards, they are also discarded in the same non-triggering cleanup batch.

**Reconciliation and priority:** RULE-138 reinforces RULE-010 printed instruction ordering; RULE-011–015 complete-effect/FIFO trigger ordering; RULE-016–019 loop safeguards; RULE-132 retained defensive hand and single post-response cleanup; RULE-133 nonretroactive effect-generated discard triggers; RULE-134 per-card and grouped event identity; RULE-135 actual damage/prevention trigger eligibility; RULE-136 effect boundaries and complete trigger checkpoints; and RULE-137's explicit non-triggering housekeeping exception. **RULE-137 remains controlling for cleanup-generated non-trigger eligibility.** This rule clarifies classification and logging without restoring superseded cleanup-trigger language in RULE-132–136 or altering established VOID/SyN/PULP damage, CACHE, prevention, DRAW, or immediate defeat mechanics. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-139 — Source-removal eligibility during trigger checkpoints (LOCKED, 2026-11-11)

**Explicit approval:** If an installed Software source leaves play **before its queued triggered ability begins resolving**, cancel that source's unresolved queued triggers immediately under RULE-081/082/085, regardless of their earlier event-time qualification. **Reinstalling the same physical Software card does not revive those cancelled triggers** and does not reset previously consumed activation allowances under RULE-066/089. A new installed instance is not a retroactive continuation of the departed source. This rule creates no exception to existing event-time eligibility, trigger frequency limits, or explicit source-validity requirements.

**Already-resolving abilities:** Once a triggered ability **has begun resolving**, removal of its Software source does **not** interrupt or cancel that currently resolving ability. Finish its remaining instructions in the established order under RULE-010/014 and RULE-083/086, while enforcing all explicit conditions, costs, required installed status, and other legal requirements at their specified check times (RULE-003/088). Source removal ends source-dependent continuous effects as already established (RULE-090). Events legally generated by the remaining instructions may still qualify other eligible Software for triggers (RULE-084). Other queued, not-yet-resolving triggers from the removed source are cancelled.

**Checkpoint continuation and FIFO:** During RULE-136's mandatory between-effect checkpoint, cancelling a removed source's pending triggers **does not end the checkpoint** or cancel unrelated triggers from other valid sources. Continue processing the existing FIFO queue, skipping/cancelling ineligible entries, resolving each eligible ability fully before processing triggers it generates, and fully draining eligible chained triggers before advancing to the next independently resolving ICE subroutine, other effect, or phase boundary. Retain simultaneous-trigger ordering (RULE-011–013), FIFO (RULE-014/015), and deterministic infinite-loop detection/termination with preservation of completed effects and unrelated queued triggers (RULE-016–019). The rule creates no reactive Rustler card-play window or new trigger timing window.

**Corporation response and housekeeping:** The same source-removal checks apply to Corporation-response effect-generated trigger checkpoints. Complete all eligible effect-generated triggers before post-Corporation routine cleanup (RULE-136/138). Routine cleanup discards remain **non-triggering housekeeping** outside effect-triggering windows under RULE-137; RULE-139 does not restore any cleanup-generated triggers or add a cleanup checkpoint. Classify and log effect-caused versus housekeeping discards by originating cause under RULE-138.

**Example:** Two installed Software cards, A and B, each qualify from a PULP-suffered event. Their triggers queue in established order. A's trigger begins resolving; a legal effect during its instructions removes A. A's **currently resolving** ability finishes subject to its remaining conditions/costs, but all **other unresolved queued triggers from A** are cancelled. B's unrelated eligible queued trigger remains and resolves in FIFO order; any further eligible chained triggers are fully drained before the next independent subroutine. Reinstalling A later cannot revive its cancelled entries or reset protected usage limits. If A instead leaves play **before its trigger begins**, that pending A trigger is cancelled.

**Reconciliation and priority:** RULE-139 clarifies the interaction of RULE-014/015 completed-effect and FIFO semantics, RULE-016–019 loop safeguards, RULE-066 activation persistence, RULE-081/082/085 queued-source cancellation, RULE-083/084/086 already-resolving effects and generated events, RULE-088/089/090 explicit installed conditions, new installed instances, and continuous effects, and RULE-136–138 checkpoints, non-triggering housekeeping cleanup, and cause-based discard classification. It **does not override** those locked rules; existing card-specific conditions, costs, source identity, timing, and fatal defeat cancellation (RULE-130) remain controlling. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-140 — Historical trigger-event snapshots and current-state resolution checks (LOCKED, 2026-11-11)

**Explicit approval — historical event facts:** When an event occurs, determine which triggered abilities qualify from that event and the applicable game state **at event time**. Preserve an immutable historical record for each queued trigger: originating event identity/type and source, actual qualifying magnitude (not an attempted or nominal amount), affected card/object identities and relevant event-time facts, trigger source/installed-instance identity, and applicable event-time thresholds or limitations. Subsequent changes in VIT, DRAW, resources, prevention, hand, installed Software, or other state **do not retroactively change the original event, its magnitude, or whether the event qualified**. Event grouping and actual-versus-attempted magnitude continue to follow RULE-105–109 and RULE-134/135, including distinct damage and overflow PULP events and individual discard occurrences.

**Explicit conditions and current-state instructions:** Historical qualification **does not freeze the entire future game state**. At the time a queued triggered ability begins resolving, check source validity and any expressly applicable resolution-time conditions, costs, required installed status, activation limits, or other prerequisites against the **then-current** game state. Evaluate later instruction-specific requirements at their specified instruction times. If a discrete instruction computes a variable numeric value such as DRAW or Trace, take the **instruction-start snapshot** required by RULE-098–104, not a queue-entry or event-time snapshot, unless explicit card text or a more-specific rule says otherwise. Preserve any expressly historical value (e.g., “equal to the PULP damage you suffered in that event”) from the original event record; do not recalculate it from current VIT or prevention. Once an instruction starts, keep its applicable snapshot fixed for that instruction. For “for each” instructions, preserve the instruction-start object set and numeric snapshot with existing eligibility protections (RULE-103/104). Continuous effects still update under RULE-090–095; previously completed draws are not retroactively changed (RULE-096/097).

**Previously qualified triggers and cancellation:** An event-qualified trigger remains historically qualified even if the current game state later changes; **mere state change does not cancel it**. Nevertheless, a pending trigger is cancelled if its Software source leaves play before resolution begins under RULE-081/082/085/139; reinstalling the card does not revive cancelled triggers or reset protected activation allowances (RULE-066/089/139). Explicit conditions and costs may cause a previously qualified ability or instruction to fail or be only partially fulfilled under RULE-002/003/088, without rewriting the event history. Once a valid ability begins resolving, its source leaving play does not cancel its already-resolving instructions, subject to explicit requirements (RULE-083/084/086–088/139). At VIT 0, immediate defeat cancels unresolved instructions and queued triggers under RULE-130; the event snapshot does not protect them from defeat.

**Ordering and checkpoints:** Resolve the current independently resolving effect fully before any generated triggers, then process qualified and still-eligible triggers in established simultaneous/controller order and FIFO (RULE-010–015/136). Continue fully draining eligible chained triggers before the next independent effect, subject to RULE-016–019 loop safeguards; source removal only cancels that source's unresolved entries, not unrelated eligible entries (RULE-139). Trigger snapshots do not create an interrupt, reactive Rustler play, or new checkpoint. Before post-Corporation routine cleanup, drain all effect-generated triggers (RULE-136/138); cleanup discards are non-triggering housekeeping outside effect-triggering windows (RULE-137), classified and logged separately (RULE-138).

**Canonical example:** Rustler at 10 VIT suffers an unprevented **PULP 3** event, reaching 7 VIT. Software A reads “Whenever you suffer PULP damage, gain 2 PULP prevention.” Software B reads “Whenever you suffer PULP damage, if your VIT is 10 or less **when this resolves**, gain 1 CRED.” Both qualify at event time and enter the FIFO queue with the historical **PULP 3 suffered** event recorded. A resolves first, gaining 2 prevention; this cannot retroactively reduce the original PULP 3. When B begins resolving, check its explicitly resolution-time VIT threshold against **current** VIT: at 7 it gains 1 CRED; if an intervening legal effect instead raised VIT above 10, that condition fails without undoing B's historical event qualification. If B's source left play before B began, its pending trigger would instead be cancelled under RULE-139. A queued “Draw cards equal to your DRAW” instruction similarly uses current DRAW **when that instruction begins**, not DRAW from the triggering event (RULE-098–101).

**Reconciliation and precedence:** This rule clarifies RULE-010–019 (printed order, simultaneous/controller order, FIFO, complete-effect boundaries, chained triggers, loop safeguards); RULE-081–095 (pending versus resolving source validity, instance identity, explicit conditions, continuous effects); RULE-096–104 (DRAW and variable-value instruction-start snapshots and eligible object sets); RULE-105–109 (aggregate event identity, actual magnitude, threshold qualification); and RULE-134–139 (discard/damage event identity, deferred trigger checkpoints, housekeeping exception, cause-based logging, and source removal). It **does not override** more-specific card text, source-removal cancellation, explicit conditions/costs, existing event granularity, prevention timing, mandatory cleanup, or immediate defeat. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-141 — Target selection, historical object identity, and invalid-target fulfillment (LOCKED, 2026-11-11)

**Explicit approval — instruction-time target selection:** Unless explicit card text or a more-specific locked rule directs otherwise, select the target(s) for a queued triggered ability **when each relevant targeting instruction begins resolving**, **not** when the triggering event occurs or the ability enters the FIFO queue. Determine the eligible target set using the **current game state** at that instruction's start. A newly installed or newly eligible object may be chosen if it meets all current requirements; an object that has left play or become ineligible cannot be chosen merely because it was available at queue entry. Preserve the established RULE-001 authority of the affected player/target to choose how to comply when applicable; this rule does not silently transfer choice to the trigger controller. Respect printed instruction order (RULE-010) and explicit targeting restrictions.

**Historical references are fixed:** If an ability refers to **“that card,” “that Software,” “the card discarded,”** or another object identified by the original triggering event, preserve that object's **historical identity** in the immutable RULE-140 event snapshot. Do not substitute another object automatically if the original moves zones, leaves play, changes status, or becomes unavailable. An ability may affect that historical object only when its instructions and applicable zone, identity, cost, and eligibility requirements legally permit it at resolution time. Historical identity does not guarantee continued target eligibility, return rights, or presence in any particular zone. If card text expressly permits a new or replacement selection, follow that text.

**Invalid targets, costs, and partial fulfillment:** When a required target is missing or ineligible at its instruction's applicable check time, apply RULE-002's **fulfill-as-much-as-possible** and independent-instruction principles, together with RULE-003's distinction between instructions, costs, and conditional effects. Do not automatically cancel an entire already-qualified ability solely because one target or one instruction cannot be fulfilled; continue independent legal instructions in printed order, unless explicit conditions, costs, or more-specific text require otherwise. Do not waive a mandatory cost, fabricate a target, retarget a historical reference, or grant a conditional reward whose required condition fails. If the trigger source leaves play before resolution, cancel its pending triggers under RULE-081–085/139; if already resolving, finish as legally possible under RULE-083–088/139. Previously qualified event-time trigger eligibility remains historical under RULE-140, subject to these validity checks.

**Separate instructions versus one “for each” instruction:** Each **separate targeting instruction** selects eligible targets independently at its own instruction start, unless an earlier instruction explicitly fixes an object that later instructions refer back to. This does **not** alter RULE-104: one discrete “for each” instruction snapshots its eligible processing set **once at that instruction's start**, with existing later-condition, cost, and installed-status protections; do not dynamically add objects during that same instruction. Instruction-start variable numeric snapshots remain RULE-098–103, and separate instructions can use changed current state. Historical event snapshots (RULE-140) and instruction-start target/object-set snapshots are distinct concepts.

**Queue and phase compatibility:** Trigger qualification, controller/simultaneous ordering, FIFO queue discipline, full effect boundaries, and chained-trigger checkpoints remain RULE-010–019/136. Target selection does not create a new interruption or reactive Rustler card-play window. Source-removal and continuous-effect behavior remain RULE-081–095/139. Effect-generated triggers fully drain before routine post-Corporation cleanup (RULE-136/138); housekeeping cleanup remains non-triggering (RULE-137), with cause-based discard logging (RULE-138). Immediate defeat still cancels unresolved effects/triggers under RULE-130.

**Canonical example:** Rustler has Software A, B, and C installed. Two independently eligible queued triggered abilities will resolve in FIFO order. The first instructs removal of an installed Software card, and the applicable chooser removes C. The second reads “Choose an installed Software card. Grant it +2 strength until end of turn.” **Assuming the second trigger's source remains valid**, when its targeting instruction begins only A and B remain eligible; C is not a legal selection. If instead the second ability says “Grant **that discarded Software card** +2 strength,” its event-linked historical card identity remains fixed and no different Software may be substituted; whether the instruction can legally affect the original depends on current zone and explicit card requirements. If the instruction is impossible, independent remaining instructions still resolve to the extent permitted by RULE-002/003.

**Reconciliation and priority:** RULE-141 establishes the default instruction-time targeting convention while preserving RULE-001–003 (chooser, partial fulfillment, conditions/costs); RULE-010–019 (printed order, FIFO and loop safeguards); RULE-081–095 (pending/resolving Software source, installed instances, and continuous effects); RULE-096–104 (instruction-start variable and eligible-object snapshots); and RULE-136–140 (effect checkpoints, non-triggering housekeeping, cause-based discards, source cancellation, immutable event facts and current-state requirements). Explicit card text and more-specific locked rules override this general default where they establish a different target selection or validity timing. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-142 — Physical card identity versus installed-instance identity across zone changes (LOCKED, 2026-11-11)

**Explicit approval — persistent card identity, new installed instance:** Each physical card retains its underlying card identity as it moves between hand, deck, discard, installed play, and other legal zones. **Every installation creates a new installed instance**, even when the same physical Software card is reinstalled. The previous installed instance ends immediately upon leaving play (RULE-089/090). Preserve a stable physical-card identifier separately from an installed-instance identifier and its entry/exit history. A zone change does not by itself make a newly installed instance a continuation of the previous one.

**Historical references distinguish the two identities:** Under RULE-140/141, “that card,” “the card discarded,” and other references to a physical card preserve the original physical-card identity, subject to the instruction's permitted zone, location, costs, conditions, and current eligibility. A reference specifically to “that installed Software,” its prior installation, or an effect tied to that **installed instance** does **not** automatically transfer to a later installation of the same physical card. Do not substitute a different physical card or a new installed instance for a historical target merely because the former target is unavailable. Explicit card text or a more-specific locked rule may authorize a different result. An ability returning an identified card from a specified zone can do so only if that same physical card is legally in the required zone when the instruction resolves; historical identity alone neither moves it nor guarantees eligibility.

**Instance-specific state and no revival:** On departure, the prior installed instance's continuous effects end under RULE-090–095; installation-specific bonuses, modifiers, counters, and other effects attached solely to that instance do not automatically attach to the new installation. Reinstallation **never revives cancelled unresolved triggers** from the departed source (RULE-081/082/085/139), resurrects expired instance-specific continuous effects, or resets protected/consumed activation allowances (RULE-066/089/139). Preserve any effects or counters explicitly defined by their own rules to persist on the physical card across zones; this general rule does not silently erase independently persistent state or create a blanket zone-change reset. A new instance may generate new triggers only from new qualifying events, within existing limits and validity requirements.

**Queued effects, target validity, and resolving abilities:** If an otherwise valid queued instruction references a **specific former installed instance**, removing and reinstalling its physical card does not make the new instance a legal substitute. Apply RULE-141's instruction-time target validity and RULE-001–003 impossibility, costs, and partial-fulfillment rules. If the queued triggered ability's **own source** leaves play before resolution begins, cancel it under RULE-139; reinstallation cannot revive it. An ability already resolving continues as legally possible despite source removal, subject to explicit installed-status conditions and costs (RULE-083/088/139). This rule does not change RULE-102–104's instruction-start variable-value snapshots or fixed “for each” processing sets, nor RULE-140's immutable event facts.

**Canonical example:** A valid separate Software effect queues an instruction “Grant **that installed Software** +2 strength,” referencing installed instance A-1. A legal intervening effect removes A-1, and the same physical card A is later reinstalled as instance A-2. A-2 is **not** A-1; the queued instruction cannot silently apply its +2 to A-2. If the instruction instead references “**that card**” and explicitly permits its present zone and status, it continues to identify physical card A, though it must still meet all current legal requirements when the instruction resolves. Unresolved triggers originating from A-1 were cancelled on removal; no reinstall restores them. This example presupposes the separate effect's source remains valid and all intervening actions are legally permitted by existing timing rules.

**Reconciliation and priority:** RULE-142 confirms RULE-066 (activation allowances), RULE-081–089 (source-removal, already-resolving abilities, and new installed-instance identity), RULE-090–095 (continuous-effect lifecycle and stacking), RULE-102–104 (instruction-time values and eligible processing sets), and RULE-139–141 (pending-source cancellation, historical event snapshots, historical object identity, instruction-time target selection, and invalid-target partial fulfillment). It does not create a reactive play window, alter FIFO checkpoints, restore cleanup-generated triggers under RULE-137, or supersede explicit persistence, zone, target, or card-specific requirements. Immediate defeat and other more-specific cancellation rules remain controlling. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-143 — Historical card references cannot bypass specified-zone requirements (LOCKED CLARIFICATION, 2026-11-11)

**Explicit user approval — specified zone is mandatory:** When an ability refers to a historically identified physical card and instructs an action **from a specified zone**, the identified card must actually occupy that specified zone **when the relevant instruction begins resolving and at any later check explicitly required by the instruction**. If the card has moved to another zone, the specified-zone instruction cannot be fulfilled. Historical card identity (RULE-140–142) does not grant permission to retrieve, move, reveal, or otherwise affect the card from a different zone. **Do not substitute another card or a newly installed instance** unless explicit card text or a more-specific rule authorizes substitution. Apply RULE-002/003 and RULE-141: an impossible instruction fails without automatically cancelling other independent legal instructions; required costs and conditions remain binding.

**Canonical example:** An otherwise valid triggered ability reads, “Whenever you discard a Software card, return **that card from your discard pile to your hand**.” Software A is discarded, qualifying the trigger and fixing A's historical physical-card identity. Before that trigger resolves, a legal intervening effect shuffles A from the discard pile into the deck. On resolution, A is **not in the discard pile**. The return instruction **fails**; A **remains in the deck**, and the player may **not** retrieve A from the deck or select another Software card instead. The original discard event and qualification remain historically recorded; inability to fulfill the later instruction does not retroactively undo them.

**Reconciliation and scope:** This clarification preserves RULE-001–003 (choice, partial fulfillment, costs and conditions), RULE-010–019 (instruction order and trigger queue), RULE-081–104 (source validity, installed-instance identity and instruction-time snapshots), RULE-137–140 (cleanup classification, event identity and historical qualification), RULE-141 (instruction-time target validity), and RULE-142 (physical-card versus installed-instance identity). The clarification **does not approve or lock the other proposed RULE-143 policies** on tracking through hidden zones, information disclosure, or player-visible log redaction; those remain open for separate review. Explicit card text and more-specific locked rules retain precedence. **Status: LOCKED clarification, explicitly approved 2026-11-11.**

## EXTRACT-001 — Basic Extractor payout timing, cap, and banking (LOCKED, approved 2026-11-11)

**Explicit user approval:** An installed **Basic Extractor** is persistent Software, requiring **1 RAM** and **1 BW to install** under TAX-016. Its printed ability is: **“At the end of your Rustler turn, extract 5 CRED from the current ICE encounter's remaining CRED reserve.”** The 5 CRED is a fixed printed payout, not a universal payout for other Extractor profiles.

**Timing:** When the Rustler selects END TURN, enter the established Rustler End-of-Turn Phase. The installed Basic Extractor's end-of-Rustler-turn ability qualifies in that existing window, alongside other eligible end-of-turn abilities, and is ordered and resolved under RULE-010–019, including controller/simultaneous ordering, FIFO, complete-effect and trigger-drain checkpoints, and loop safeguards. It is **not** a newly inserted priority phase or a payout automatically placed ahead of other end-turn effects. Finish eligible end-turn effects and generated triggers, then forfeit remaining BW, then resolve Corporation Response, then perform the single non-triggering post-Corporation hand cleanup under RULE-132/137/138. This reconciles RULE-RT-001–005 with RULE-132's superseding cleanup relocation. The payout occurs **before Corporation Response**, not after survival of it.

**Installation-turn eligibility:** Basic Extractor installed during the current Rustler turn qualifies for payout at that turn's end, provided it remains installed and eligible when the end-turn trigger is generated. No default startup delay applies. If it is unloaded before END TURN, no trigger qualifies. If its source leaves play after qualification but **before** the queued ability begins resolving, cancel that pending trigger; reinstalling the same physical card does not revive it (RULE-081–090, RULE-139/142). Once an ability has begun resolving, apply the existing source-removal continuation rule subject to explicit requirements, costs, and resolution-time conditions; do not invent an unconditional cancellation or revival (RULE-083/088/139–142).

**Finite encounter reserve:** ECON-002's hard **per-ICE-encounter CRED cap** governs every extraction payout. On resolving Basic Extractor's payout, award **min(5 CRED, the current encounter's unextracted CRED reserve)**, never a negative amount. Reduce that reserve by the actual awarded amount; when it is empty, award 0. Multiple legally installed Extractors, if present, use the reserve remaining at their respective resolution times and follow existing trigger ordering; their combined payouts cannot exceed the cap. The encounter cap's exact numerical size and whether it is visible or hidden remain OPEN. Do not impose a new universal limit on installed Extractors or override other Extractor payout profiles.

**Immediate banking:** CRED actually awarded by a resolving Extractor is **banked immediately upon resolution**, with no survival-or-ICE-PASS condition. Subsequent Corporation retaliation does not retroactively revoke already banked CRED. If VIT reaches 0, immediate defeat ends the run and cancels unresolved effects/triggers under RULE-RT-002/RULE-130; no later pending payout resolves. Existing event snapshots, trigger eligibility, resolution-time conditions, and source/target identity restrictions (RULE-136–142) apply without exception.

**Encounter transitions:** Each ICE encounter has its own finite reserve. An installed Extractor that remains legally in play may qualify in a later ICE encounter under its printed ability and the established Node Software lifecycle; no payout occurs outside an eligible current ICE encounter or beyond that encounter's reserve. Whether extraction is possible after ICE PASS, specific reserve sizes, visibility, and more complex Extractor timing profiles remain open except as expressly fixed here. No new out-of-turn Rustler card-play window is created.

**Status:** LOCKED — explicitly approved. Reconciles ECON-002/003; TAX-009/016; RULE-RT-001–005; RULE-010–019; RULE-132; RULE-136–142. All other previously locked rules remain in force.

## GENERALIST-001 — Ten-card starter deck, SYN BUFFER, and Instant PULP shields (LOCKED direction, 2026-11-11)

**Explicit user approval:** The Generalist starts with exactly **10 cards**: (1) WALL Icepick, (2) SENTRY Icepick, (3) CODE GATE Icepick, (4) Basic Extractor, (5) SYN BUFFER, (6–7) two Instant PULP shield cards, and (8–10) three Instant ICE-strength-reduction cards. The first five are persistent installed Software requiring **1 RAM each** and the established **1 BW installation cost**. The Generalist starts with **4 RAM**, so all five cannot be installed simultaneously. The three distinct type-specific Icepicks have no finalized individual strength/break-cost profiles yet. Basic Extractor retains **EXTRACT-001**: 5 CRED at end of each eligible Rustler turn before Corporation Response, eligible on installation turn, hard encounter cap, immediate banking.

**SYN BUFFER — card wording:** **“Once per ICE encounter, when you would suffer SyN damage, this program automatically prevents 1 SyN damage from that damage event.”** It is installed Software (1 BW installation; 1 RAM). Its automatic prevention applies **during damage resolution before the affected SyN is suffered**, before mandatory SyN discards or overflow PULP; it is not a queued after-damage trigger. It prevents neither PULP nor VOID. **Each installed copy has its own independent once-per-ICE-encounter allowance**, so multiple eligible copies can each prevent 1 SyN, up to the incoming damage amount. An allowance refreshes **on entering the next ICE encounter**, not on either player's turn start (RULE-027/028 do not reset this encounter-specific allowance). An eligible copy's allowance is consumed only when it actually prevents a point of SyN. An installed copy that remains in play between ICE encounters refreshes for the next encounter, consistent with the Node-long Software lifecycle.

**SYN BUFFER reinstall safeguard:** To prevent unloading and reinstalling the **same physical card** from bypassing its once-per-encounter limit, track the used allowance by physical card identity and encounter identity. A card already used during that encounter remains spent if unloaded and reinstalled; a distinct unused physical copy has its own allowance. This is a **card-specific exception** to otherwise fresh installed-instance identity under RULE-089/142, not a general rule that reinstalled Software retains all instance-specific state. An uninstalled copy cannot prevent damage. All existing eligibility, prevention, source-removal and resolution-time rules remain applicable (RULE-001/004–006, RULE-010–019, RULE-081–090, RULE-127–142).

**Instant PULP shields:** Both remaining Generalist Instant shield cards grant a printed amount of **PULP prevention to the Rustler's existing shared PULP prevention pool** when played during the Rustler turn. They are **not installed**, occupy **0 persistent RAM**, and go to discard after resolving under SOFT-009/010. When the Rustler would suffer PULP, **consume eligible PULP prevention from that pool first**, point-for-point; only the unprevented remainder reduces **Vitae (VIT)**. This restates the already locked unified prevention-pool and prevention-before-damage mechanics (SOFT-013/015, DMG-002, RULE-004–006, RULE-127–136), not a new second shield pool. PULP prevention cannot prevent SyN or VOID; those use their own pools. Apply existing expiration at beginning of next Rustler turn and existing earliest-expiring eligible prevention priority. Card-specific shield amounts and printed BW costs are **OPEN**, not implicitly fixed here.

**Unfinalized Generalist card details:** The two PULP shield names, amounts and BW costs; the three ICE-strength-reduction Instants' names, magnitude, duration, and BW costs; and individual Icepick statistics are working concepts only. Earlier illustrative names Fracture, Erode, and Destabilize are **not locked card identities**. This entry locks deck structure, lifecycle classifications, SYN BUFFER timing/independent-copy handling, and PULP-pool behavior without inventing numerical card balance.

**Status:** Approved and recorded. Reconcile with TAX-009/016, ECON-002/003, EXTRACT-001, SOFT-009–015, DMG-002, RULE-004–006, RULE-010–019, RULE-027/028, RULE-081–090, RULE-127–142. Preserve more-specific existing rules and no out-of-turn Rustler card plays.

## ICE-DESIGN-001 / MULTI-ICE-001 — ICE roles, multi-ICE encounters and DEADLOCK gating (APPROVED, 2026-11-11)

**Design direction approved by user:** ICE encounters can contain **one or multiple ICE**. An encounter must have **at least one DEADLOCK subroutine across its ICE**, but **not every ICE needs DEADLOCK**. An individual ICE may have only offensive subroutines (e.g., one PULP or TRACE), only DEADLOCK subroutines, or a mixture. **One ICE may have three separate DEADLOCK subroutines and no damage subroutines**; each is a distinct subroutine to neutralize. There is no fixed one-DEADLOCK-per-ICE or mandatory one-offense-per-ICE rule. A multi-ICE formation can combine a pure blocking ICE with several weaker offensive/support ICE. All active DEADLOCK subroutines in the encounter must be broken, bypassed, or otherwise legally neutralized to qualify for advancement.

**LOOP-002 timing — superseded in part by LOOP-002-SUPERSESSION-001:** Earlier final-response wording in this paragraph is historical and no longer operative. See the later locked BREACHED rule: after the final DEADLOCK is neutralized, the Rustler voluntarily ends the current turn and proceeds to rewards without a final Corporation Response. Historical wording formerly stated: Breaking/neutralizing the last DEADLOCK **does not immediately end the encounter or skip the Corporation's ensuing response**. The Rustler must survive the normal Corporation Response before advancement; applicable **unbroken** offensive subroutines can still fire during that response, while broken subroutines do not fire. After response and required post-response cleanup under RULE-132, advancement is allowed only if no active DEADLOCK remains and the Rustler has survived. No extra Corporation Response is added solely for leaving. If the Rustler remains engaged across turns, active offensive subroutines provide recurring threat during applicable Corporation Responses; use existing subroutine ordering, complete-effect checkpoints, damage/prevention and immediate-defeat rules (RULE-010–019, RULE-RT-001–005, RULE-127–142). Exact ordering of subroutines **across multiple simultaneously engaged ICE**, and any additional encounter-wide sequencing not already specified, remain OPEN; do not silently invent it.

**ICE design identities — tendencies, not absolutes:** **WALLS** generally have the highest strength and comparatively few subroutines, emphasizing PULP and TRACE and/or DEADLOCK; they can instead be pure multi-DEADLOCK blockers. **CODE GATES** generally have lower strength than WALLS and more subroutines, emphasizing SyN, plus PULP and DEADLOCK. **SENTRIES** are generally the deadliest, with highly variable strength and subroutine count and combinations of PULP, SyN, VOID, TRACE and/or DEADLOCK. **PULP is a common baseline offensive threat across all three ICE types**, not Sentry-exclusive, ensuring Instant PULP shields are routinely useful. Not every ICE needs to deal damage individually, provided encounter formations create meaningful pressure. TRACE should have meaningful consequences when successful; its exact per-card effects are not decided here.

**Weak-ICE design:** Low-strength ICE, including potential **Strength 0** ICE, can remain threatening through offensive subroutines or useful through DEADLOCK. Illustrative, **not finalized**, examples include a weak Paper Cut with PULP, a low-strength TRACE support ICE, a Training Wall with PULP and DEADLOCK, and a pure triple-DEADLOCK WALL. Names, strength numbers, damage numbers, number of ICE per encounter, exact TRACE consequences, and individual card balance remain OPEN. The suggested Strength 2 Training Wall and Strength 3 Triple Lock are examples only, not locked card values. Avoid treating an illustrative subroutine ordering as a universal type template.

**GENERALIST-001 card refinement (approved):** The two Generalist Instant PULP shields are **two copies of the same card**, each costing **1 BW** and adding **3 PULP prevention** to the Rustler's existing unified PULP pool. On incoming PULP, consume eligible prevention before reducing VIT; temporary prevention follows established expiration and duration-priority rules. Generalist cards 8–10 are **three copies of the same Instant ICE-strength-reduction card**, each costing **1 BW**, with printed effect **“Permanently reduce a target ICE's strength by 2.”** Permanent means the reduction does not expire at end of turn or encounter; it persists for that ICE's existing lifecycle, subject to existing ICE-strength floor and modifier rules. Do not treat the former illustrative Fracture/Erode/Destabilize names as three distinct finalized cards. **All 10 Generalist starter cards uniformly cost 1 BW to play/install**: three unique 1-RAM installed type-specific Icepicks, one 1-RAM installed Basic Extractor, one 1-RAM installed SYN BUFFER, two identical PULP-shield Instants, and three identical permanent −2 strength-reduction Instants. The three Icepicks' activation/break costs and printed names, and final names of the two Instant card designs, remain OPEN. Installed Software costs 1 BW to install; Icepick activation is a separate mechanic. SYN BUFFER remains once-per-ICE-encounter prevention of 1 SyN, per independently installed copy, with same-physical-card reinstall not resetting the used encounter allowance (GENERALIST-001). Basic Extractor retains EXTRACT-001.

**Status:** User explicitly requested recording and committing these approved design principles. Preserve existing locked LOOP-002, RULE-132, EXTRACT-001, GENERALIST-001 and other rules; do not interpret examples as approved numerical ICE cards.

## LOOP-002-SUPERSESSION-001 — BREACHED encounter skips final Corporation Response (LOCKED, approved 2026-11-11)

**Explicit supersession:** This decision replaces only the portion of LOOP-002 and related MULTI-ICE-001 text requiring a final Corporation Response after all active DEADLOCK subroutines across every ICE in the current encounter have been neutralized. Earlier statements that the Rustler must survive an ensuing Corporation Response *after* clearing the last DEADLOCK are superseded by this later locked rule. All other existing Corporation Responses during an uncleared encounter remain in force.

**BREACHED state:** Immediately when all active DEADLOCK subroutines across all ICE in an encounter are broken, bypassed, or otherwise legally neutralized, the encounter becomes **BREACHED** (eligible to finish). This does **not** automatically end the Rustler turn or transition to rewards. The Rustler retains control and may continue legal Rustler-turn actions, including playing cards, spending BW, and using installed programs, until voluntarily selecting **END TURN**.

**Completion sequence:** On END TURN while BREACHED, resolve normal eligible Rustler end-of-turn effects (including applicable Basic Extractor payout) and the established BW-forfeiture/end-turn procedures. **Skip the ordinary Corporation Response for this cleared encounter**: no remaining unbroken offensive ICE subroutines execute as a final routine response. Perform the applicable post-turn/encounter housekeeping without manufacturing a response or triggering cleanup effects, then complete the encounter and proceed to the **Reward Step**. No extra Rustler turn, exit action, or final Corporation Response is required. The Rustler must still be alive and all DEADLOCKs neutralized at completion.

**Scope:** This is a universal encounter-clearance rule, not a change to normal offensive subroutine behavior on earlier turns while DEADLOCK remains. It does not authorize automatic victory at the instant the final DEADLOCK breaks, erase damage already resolved, or create an implicit final retaliation. Any exceptional printed on-breach/on-exit card ability would require its own explicit approved wording and timing; none is established here. Preserve RULE-132's non-triggering housekeeping principle, other existing trigger/prevention rules, and voluntary END TURN. Where older documents conflict, this later specific supersession controls.

**Not decided here:** Icepick activation/BW costs, White Picket Fence's finalized card statistics, and any special breach-triggered abilities remain uncommitted proposals.

## TRAINING-001 / ICEBREAK-OPTION-C / BREACH-REWARD-001 — Opening encounter balance and end-turn clarification (2026-11-11)

**Training Node structure — DESIGN DIRECTION, not finalized roster:** Build an introductory Node of three progressively larger encounters: first **one ICE**, second **two ICE**, third **three ICE**. Establish an ICE-strength scale by testing the starter Generalist deck against these encounters before locking a larger ICE roster. Preliminary strengths and ICE names for encounters 2 and 3 remain OPEN.

**First encounter — WHITE PICKET FENCE, PROPOSED card pending final approval:** Generic **WALL**, printed **Strength 3**, with two separate subroutines: **PULP 5** and **DEADLOCK**. It is intended to teach strength reduction, PULP prevention, breaker installation, and breach completion. Two of the Generalist's already-approved 1-BW permanent −2 ICE-strength Instants reduce its current strength from 3 to the applicable floor (provisionally 0), motivating the Strength 3 choice. Do not mislabel this proposed individual ICE as a locked card specification; the user's discussion endorses it as the working first encounter, with balance testing still underway.

**Icepick activation — OPTION C, EXPERIMENTAL / NOT LOCKED:** For a generic installed type-compatible Icepick such as the provisional WALL breaker **Crowbar**, pay the starter card's established **1 BW to install** and occupy **1 RAM**. Proposed activation: **one eligible subroutine break free per installed Icepick per Rustler turn**; **each further eligible break using that same breaker in that same turn costs 3 BW**. Allowance resets on the next Rustler turn. Multiple installed copies would have independent allowances if otherwise legal. Normal subtype and strength requirements apply. The test assumption that Crowbar can break a WALL only when its current Strength is **0** is likewise **PROPOSED**, not a previously locked universal breaker rule. The user's wording about 'first three break' was ambiguous, and this once-free-then-3-BW interpretation was used for costing; retain OPEN status until explicit confirmation. Do not infer that every Icepick has the same activation profile.

**Three-Rustler-turn opening target — BALANCE GOAL:** Generalist starts with 10 cards, normal **DRAW 5**, baseline **4 BW refreshed at each Rustler turn start**, and **4 RAM**. With no DRAW modifiers, the first two draws can expose all 10 starting cards; a third turn draws from the normal discard reshuffle as needed, accounting for installed cards no longer in the draw/discard cycle. Aim for the first encounter to be normally beatable **by the end of Rustler Turn 3**, across varied draw orders, rather than requiring an exact scripted hand. Under the provisional Crowbar rules, two −2 Instants (2 BW), Crowbar installation (1 BW), and two optional PULP shields (2 BW) total **3–5 BW across turns**, plus any optional programs. Free breaks on separate turns can clear PULP and DEADLOCK; the extra 3-BW break is a costly way to accelerate. Starting Vitae and all draw-order survival cases have not been validated, so the three-turn goal is a target, **not a proven guarantee**. PULP prevention is temporary and must be timed to the response it protects against. Optional Basic Extractor (1 BW, 1 RAM) can earn CRED under EXTRACT-001 while competing with defensive setup for BW/RAM.

**BREACH-REWARD-001 — explicit clarification of the LOCKED BREACHED rule:** BREACHED is the **state** entered immediately upon neutralizing **all active DEADLOCK subroutines across every ICE** in the encounter; **BREACH** is the transition event. A BREACH **forces the current Rustler turn to be the encounter's final turn** in the sense that, when the Rustler voluntarily chooses END TURN, the game **automatically proceeds to the Reward Stage after eligible Rustler end-of-turn effects and required non-triggering cleanup**, without a Corporation Response, an additional Rustler turn, an extra exit action, or another confirmation. BREACH **does not forcibly end the Rustler turn at the moment of the last break**: legal Rustler actions may continue until the player selects END TURN. This is the controlling interpretation of LOOP-002-SUPERSESSION-001 and preserves voluntary END TURN. The Rustler must remain alive and the encounter must remain eligible for completion.

**BREACH effect design space — CONCEPT ONLY:** Effects may eventually be worded 'On BREACH', 'While BREACHED', or 'On END TURN while BREACHED'. Distinguish the one-time transition event from the ongoing state. No specific bonus, triggered timing exception, additional BW, CRED, or card text has been approved by this note. In the White Picket Fence test, clearing DEADLOCK on the final Rustler turn suppresses its otherwise unbroken **PULP 5** from firing in a final normal Corporation Response.

**Precedence and scope:** LOOP-002-SUPERSESSION-001 governs over the older LOOP-002 and MULTI-ICE-001 final-response passages; earlier turns with active DEADLOCK still receive normal Corporation Responses. Preserve RULE-132's non-triggering post-response cleanup principle, established Rustler end-turn effects and BW forfeiture, normal deck reshuffling and installation persistence. This note documents approved BREACHED clarification and provisional training/Icepick balance separately; it does **not** silently lock experimental Crowbar stats, three-turn guarantee, or encounter card values.

## GENERALIST-012 / GHOST-SIGNAL-001 — Twelve-card starter deck and anticipatory TRACE defense (APPROVED, 2026-11-11)

**Starter deck size:** Increase the Generalist starting deck from **10 to 12 cards**. Preserve the ten existing card identities, quantities, and approved effects from GENERALIST-001 and MULTI-ICE-001. Add **one unique TRACE-defense Instant** as card 11. **Historical planning note (superseded by GENERALIST-012-FINAL):** Card 12 was initially unassigned; it is now the third identical PULP Shield. Previous descriptions calling the starting deck exactly ten cards are superseded as to total size, but not the existing ten-card composition. This is a deck-design decision, not a declaration that a final 12-card list is complete.

**GHOST SIGNAL (working name; unique Generalist card):** **Instant; 2 BW to play; 0 RAM; one copy in the Generalist starter deck.** Proposed printed effect approved in this discussion: **“Reduce the first TRACE attempt during the Corporation's next turn to 0.”** The Rustler plays it proactively during their own turn under normal timing rules. It affects **only the first TRACE attempt** on the immediately following Corporation turn, regardless of that attempt's printed value; it does not negate subsequent TRACE attempts, remove existing accumulated TRACE, or permanently modify an ICE. If no TRACE attempt occurs during that Corporation turn, the protection expires unused. If the Rustler enters BREACHED and ends the encounter without a Corporation Response, no TRACE attempt occurs and the protection provides no benefit. The TRACE meter's precise 40-point maximum consequence remains OPEN; do not conflate TRACE 4 on an ICE with reaching TRACE 40.

**Temporary card removal — BURNED:** After playing/resolving GHOST SIGNAL, place that physical card in the **BURNED** state for the remainder of the current Node, returning it under the established next-Node card-return procedure; BURNED is the approved state, not a provisional EXILE keyword. The card is usable **once per Node**, not once per encounter; it is not permanently destroyed.

**Training Encounter 2 — WORKING TEST SCENARIO, not a finalized ICE roster:** Two simultaneously engaged ICE, each with one DEADLOCK: **WALL Strength 5, TRACE 4 and DEADLOCK**; **CODE GATE Strength 3, two separate PULP 3 subroutines and DEADLOCK**. ICE subroutines are **generally fixed and visible**, permitting the Rustler to plan turns against known threats. Both DEADLOCKs must be neutralized to BREACH; the locked BREACHED end-turn rule then skips the final Corporation Response. The Rustler enters Encounter 2 with potentially **1–4 Software cards already installed** from Encounter 1; those cards persist in play and no longer circulate in the deck, without reducing baseline DRAW. TRACE 4 is intended to be meaningful pressure; the exact TRACE meter interaction and consequence at TRACE 40 are reserved for later definition. Multi-ICE response sequencing remains OPEN; do not assume simultaneous damage or a new ordering rule.

**Icepick strength — DESIGN PRINCIPLE APPROVED; costs and individual stats OPEN:** Each Icepick has its **own breaking-strength rating**, and the compatible ICE's current Strength is compared against that rating to determine eligibility to break its subroutines. Higher breaking strength (e.g., 1 or 2 instead of 0) should generally involve a compensating cost, such as **2 RAM occupied**, greater **BW installation cost**, and/or **1+ BW per subroutine break**. These are possible tradeoffs, not universal tier rules or approved individual starter breaker stat changes. The Generalist's existing starter breaker install cost and RAM usage remain as previously approved unless explicitly revised. The previously discussed free-first-break/3-BW-additional-break model and Crowbar Strength 0 remain **experimental**, not locked by this entry.

**Balance status:** Twelve cards, the one unique 2-BW TRACE-defense Instant, its next-Corporation-turn/first-attempt-only effect, and its once-per-Node removal are approved for documentation. The twelfth card, GHOST SIGNAL's final name, precise keyword naming, Encounter 2's final ICE statistics, Icepick individual strength/costs, TRACE-40 consequence, and encounter pacing are not yet finalized. Do not present provisional scenario data as locked balance outcomes.

## GENERALIST-012-FINAL / TRAINING-CRED-SCALE-001 — Completed starter deck and difficulty-scaled encounter reserves (APPROVED, 2026-11-11)

**Completed Generalist starter deck — 12 cards (APPROVED):** 1 WALL Icepick, 1 CODE GATE Icepick, 1 SENTRY Icepick, 1 Basic Extractor, 1 SYN BUFFER, **3 identical 1-BW Instant PULP Shields (+3 temporary PULP prevention each)**, **3 identical 1-BW Instant permanent −2 ICE Strength reductions**, and **1 unique 2-BW GHOST SIGNAL (working name)**. Total: **5 persistent Software + 6 basic Instants + 1 unique TRACE-defense Instant = 12 cards**. The third PULP Shield fills the previously unassigned twelfth slot; it is an additional copy of the existing card, not a new effect. All other printed costs, RAM, timing and card lifecycle rules remain as previously established. The older GENERALIST-012 statement that the twelfth card is unassigned is now superseded. The older ten-card starter-deck total is also superseded; preserve its original ten card identities and effects.

**Training Node extraction economy — approved scaling principle:** The introductory ICE Node contains **three encounters/layers**. Each encounter has its **own finite maximum extractable CRED reserve**, as already required by ECON-002. **As a general design rule, increase the encounter's maximum extractable CRED with the difficulty of its ICE layer**; the second layer should offer more than the first, and the third more than the second, reflecting escalating danger, required setup, and time under Corporation pressure. This is an approved balancing principle, **not yet a locked numeric reserve table or a universal mathematical formula**. Exact reserves for Training Layers 1–3 remain to be tested/approved. Do not conflate reserve cap with guaranteed payout or grant the entire reserve automatically on BREACH.

**Extractor compatibility:** Preserve EXTRACT-001: Basic Extractor costs 1 BW to install, occupies 1 RAM, and extracts **up to 5 CRED** from the current encounter's remaining reserve at the end of each eligible Rustler turn (including its installation turn and the final Rustler turn while BREACHED), immediately banking only the actual extracted amount. Unextracted reserve is not automatically awarded. The BREACHED completion rule still skips the final Corporation Response. More valuable encounters may invite deliberately extending exposure for extraction; any numeric reserve should be evaluated against actual encounter duration and risk. No change is made to previously established extraction frequency, triggers, or banking.

**Status:** Starter deck composition and general difficulty-scaled per-encounter reserve direction approved and committed. Exact CRED maximums and remaining ICE/breaker balance are OPEN until further discussion.

## TRAINING-NODE-LESSONS-001 — Intent-first tutorial design and first ICE Node (APPROVED DIRECTION, 2026-11-11)

**Design method:** Define what the encounter must teach **before** finalizing its ICE layout. Each training encounter has one primary lesson, supported by readable consequences and a chance for the Rustler to apply the learning. Teaching a rule is not the same as merely requiring the player to use it. The first ICE Node has three increasingly complex ICE encounters: (1) understand ICE Strength, breaker eligibility, DEADLOCK and BREACH; (2) understand installed Software, deck thinning/cycling, multiple ICE and managing BW/RAM; (3) assess the full formation, prioritize mandatory obstacles over optional damage prevention, prepare across turns, and choose a timely BREACH over reflexively shielding or farming CRED. NUL/REM may deliver contextual hints rather than pre-solving the encounter. These are design objectives, not mandatory tutorial dialogue.

**Training encounter CRED reserves (APPROVED FOR THIS TEST NODE):** Encounter 1 **15 CRED**, Encounter 2 **25 CRED**, Encounter 3 **40 CRED**, each an independent finite maximum; 80 CRED total potentially extractable. Preserve ECON-002 and EXTRACT-001: Basic Extractor awards up to 5 CRED per eligible Rustler end turn from the current encounter's remaining reserve, including the final BREACHED turn; unextracted CRED is not awarded on BREACH. These numerical caps are **test-node settings**, not a universal difficulty-to-CRED formula. The general direction is higher difficulty => larger reserve, with extraction balanced against additional exposure.

## TRAINING-ICE3-001 — Three-ICE teaching encounter (WORKING TEST CONFIGURATION, 2026-11-11)

**Primary lesson:** Prioritize disabling the support ICE's strengthening effect, preparing a compatible breaker over multiple Rustler turns, and neutralizing the Sentry's **two** DEADLOCKs. Not every offensive subroutine needs to be broken. Repeated defensive card plays can worsen the true obstacle; sometimes accepting incoming PULP and foregoing CRED is strategically safer than prolonging exposure. This is an intended teaching outcome to validate in playtests, not a claim that every draw order has a guaranteed low-VIT-loss solution.

**ICE 1 — SENTRY (working Strength 3, not finalized):** [S1] DEADLOCK; [S2] PULP 5, DEADLOCK. These are **two separate subroutines each containing DEADLOCK**; both must be broken/neutralized to BREACH. Breaking S2 also prevents its PULP 5 when it would resolve. Proposed reactive ability: **gain +1 or +2 Strength whenever the Rustler plays a card of a designated defensive/Hardware umbrella type**; exact magnitude, whether the bonus is permanent for this encounter, and precise qualifying card taxonomy are **OPEN**. The earlier illustrative +2 per Shield was not locked.

**ICE 2 — CODE GATE (working Strength 5):** [S1] increase the Sentry's Strength by **2**. Rustler's intended first step is to break this support subroutine with a CODE GATE Icepick, preventing later applications. **Duration and timing** of the +2 Sentry modifier, whether repeated applications stack, and Corp Response ordering are OPEN; do not silently make this modifier temporary or permanent. This ICE has **no DEADLOCK in the working layout**.

**ICE 3 — CODE GATE (working Strength 3):** [S1] PULP 3; [S2] TRACE 3. Neither is a DEADLOCK in this working layout. Exact TRACE accumulation/consequences remain as previously open. Multi-ICE response ordering remains OPEN.

**Intended route, subject to verification:** (1) weaken ICE 2 or boost its breaker sufficiently to break the +2-Strength support subroutine; (2) lower Sentry Strength with permanent −2 ICE Strength cards and/or boost the Sentry breaker over successive Rustler turns until eligible; (3) spend 1 BW per Sentry subroutine to neutralize both DEADLOCKs, then END TURN while BREACHED and skip the final normal Corporation Response. Optional PULP/TRACE subroutines on other ICE may remain unbroken. Test against actual card draws, existing installations, BW refresh, persistent ICE Strength reductions, remaining RAM, and damage before calling it optimal.

## BREAKER-STARTER-001 — Generalist Sentry and Code Gate breaker profiles (APPROVED, 2026-11-11)

**Sentry Icepick:** Persistent installed Software, **1 BW install, 1 RAM**, **base breaking Strength 0**. **Spend 1 BW: increase this Icepick's breaking Strength by 1** for the remainder of the **current ICE encounter**. **Spend 1 BW: break one subroutine** of a compatible Sentry whose current Strength is no greater than this breaker's current breaking Strength. Each subroutine break is a separate 1-BW use. The breaker may be boosted over multiple turns; its accumulated boosts expire at the end of the current ICE encounter, while the Software remains installed for the Node.

**Code Gate Icepick:** Persistent installed Software, **1 BW install, 1 RAM**, **base breaking Strength 3**. **Spend 2 BW: increase this Icepick's breaking Strength by 1** for the remainder of the **current ICE encounter**. **Spend 1 BW: break one subroutine** of a compatible Code Gate whose current Strength is no greater than this breaker's current breaking Strength. Boosts accumulate across Rustler turns during the same encounter and expire at encounter end; installation persists through the Node.

**Interaction and supersession:** These two approved individual breaker profiles supersede any incompatible *experimental* free-first-break/3-BW-subsequent-break pricing **for these two breakers**. They do not set WALL breaker stats or universal breaker pricing. Boosted breaking Strength belongs to the installed breaker, not to ICE Strength, and does not alter the ICE's own Strength or permanently carry to the next encounter. No free first break is assumed for either approved breaker. Normal BW refresh (4 per Rustler turn), RAM limits, card-play timing and BREACHED end-turn rules continue to apply.

**Example BW budget, conditional on working STR 3 Sentry and STR 5 support Gate:** 1 BW to install each of two breakers (2), 1 BW for one −2 Strength card on support Gate, 1 BW to break its support subroutine, 1 BW for one −2 Strength card on Sentry, 1 BW to boost Sentry breaker from 0 to 1, and 2 BW to break both Sentry subroutines = **8 BW total across turns**. This excludes optional cards, the third ICE, existing installations and all Corporation Responses. It demonstrates feasibility in aggregate, **not** guaranteed turn-by-turn reachability or low damage.

## CARD-TAXONOMY-TRAINING-001 — One-shot shield umbrella type (OPEN DESIGN CHOICE, 2026-11-11)

**User proposal, not yet approved as a universal rule:** Give the existing +3 PULP Shield Instants and potentially similar cards a shared **card type**, possibly **Hardware that is not persistent**. The Encounter 3 Sentry would then react to each **Hardware** card played rather than to an arbitrary card name. A +1 STR per qualifying Hardware played or +2 STR per qualifying Hardware played trigger are both under consideration; neither magnitude is finalized. Specify whether the trigger counts card plays, installations, or both; whether Hardware is a type versus a subtype/tag; whether it includes installed persistent Hardware; whether strength gains last until encounter end; and whether the effect triggers only while Sentry is active. Do not reclassify all Instants as Hardware, equate Instant timing with a card type, or change existing persistent Hardware rules without a further decision.

**Remaining OPEN items before a rigorous Encounter 3 simulation:** WALL Icepick profile; final Sentry initial Strength and reactive bonus magnitude/duration; precise Hardware/defense umbrella taxonomy; support Code Gate +2 modifier duration/stacking; multi-ICE Corp Response ordering; third ICE TRACE 3 resolution and TRACE 40 consequence; starting VIT baseline; full draw/reshuffle and opening installed Software state; and numerical viability of the intended low-damage route. Preserve the distinction between approved breaker costs/boost duration, approved 15/25/40 test-node reserves, and provisional ICE numbers.

## TAX-REFORM-001 — Card nature, lifecycle, subtype; Hardware need not persist (APPROVED, 2026-11-11)

**User-approved classification principle:** A card's **type** describes what it is and generally what it does; **lifecycle** describes how it behaves in play; **subtype** describes its more specific role or capability. These dimensions must not be conflated. **Hardware is a card type, not a synonym for installed or persistent equipment.** Both Hardware and Software can be **persistent** or **nonpersistent/Instant**. Do not assume that an Instant is Software, that all Hardware must be installed, or that all Software must persist. A subtype (Icepick, Virus, Extractor, Shield, etc.) does not itself define the lifecycle. Multiple applicable subtypes remain possible under SOFT-001.

**Precedence over TAX-004/TAX-016 and related older shorthand:** Existing **persistent installed Hardware** still costs 1 BW to install and 1 BW to uninstall, remains in play through the Node, returns to the deck at Node end, and does not reduce DRAW. These installation, uninstall, and persistence rules are **specific to persistent Hardware**, not universal to every card with Hardware type. **Instant Hardware** is played from hand, pays its printed play cost, resolves its effect, and goes to discard unless a card explicitly specifies another destination; it is not installed, occupies no persistent RAM by default, and is not subject to the 1 BW Hardware installation/uninstallation charge. Preserve effect-specific expiration rules. Existing persistent Software installation, RAM and unloading rules remain in effect for persistent Software, while Instant Software retains its instant-play lifecycle.

**New Generalist classifications (APPROVED):** SYN BUFFER is **Persistent Hardware**, subtype defensive utility/defense, not persistent Software. The three identical +3 PULP-prevention Shields are **Instant Hardware**, subtype Shield/Defense, not Instant Software. The three identical -2 ICE Strength Instants are now named **PROBE**, **Instant Software**, subtype reconnaissance/intelligence; printed effect remains **1 BW: reduce target ICE Strength by 2**, stacking with other PROBE reductions, with the already-established lasting reduction on that ICE for the current encounter. PROBE is a card name; it does not automatically create a universal SCAN keyword or reveal-hidden-information rule. The other Generalist cards retain their existing classification unless explicitly changed.

**SYN BUFFER resource-cost caution:** Reclassification does not itself decide whether SYN BUFFER's former **1 RAM** requirement is removed or retained as an exception. **RAM requirement is OPEN for rebalancing**; preserve the previously printed 1 RAM provision provisionally until a specific decision is made. Do not silently give the Rustler an additional RAM slot. SYN BUFFER still costs 1 BW to install and automatically prevents 1 SyN from one damage event once per ICE encounter per physical card; its once-per-encounter use does not reset by reinstalling it.

**PULP Shield:** Three copies; **Instant Hardware**; each costs **1 BW** to play and adds **3 temporary PULP prevention** to the shared prevention pool; the existing prevention consumption, expiry and discard rules remain unchanged. A shield is not installed merely because its type is Hardware.

**Approved 12-card Generalist starter deck (revised classification):** 1 WALL Icepick (Persistent Software); 1 CODE GATE Icepick (Persistent Software); 1 SENTRY Icepick (Persistent Software); 1 Basic Extractor (Persistent Software); 1 SYN BUFFER (Persistent Hardware); 3 identical PULP Shields (Instant Hardware); 3 identical PROBE cards (Instant Software); 1 GHOST SIGNAL (Instant Software, unique, existing once-per-Node removal from draw cycle). Total **12 physical cards**. This replaces older 10-card and outdated classification descriptions, not the approved individual card effects or costs.

**Open taxonomy redesign, not yet a rule:** The user is considering a second, function-first classification comparable to Slay the Spire's Attack / Skill / Power / Status / Curse. Do not presume REDLINE has only two total card types: Hardware and Software are currently the two established **Rustler-deck nature types**, while CAPS, Ghostware, PATCHWORK, and special/reward cards have distinct rules; the classification of Corporation-inserted negative cards (e.g. transient Status versus persistent Curse) has **not yet been approved or comprehensively defined**. Future functional classes, card-frame shapes, interaction with Hardware/Software, and whether hostile cards are a third nature type are OPEN. The user-proposed Sentry trigger referencing **Hardware played** remains an encounter-design proposal; whether +1 or +2 STR, duration, and trigger timing are still OPEN. Reclassifying Shields/SYN BUFFER does not silently finalize that trigger.


## 41. Operating behaviour taxonomy — Executable / Protocol / Packet / Bloatware (APPROVED, 2026-11-11)

**Terminology and scope:** These four names are approved operating-behaviour classifications for cards. They are distinct from the established Hardware/Software nature classification and from functional subtypes. Use **Rustler**, **Console**, and **Icepick** terminology. This section supersedes the older, expressly open taxonomy discussion at the end of the preceding section; it does not silently change the existing individual card costs or effects.

- **Executable:** A card installed into the Console that occupies RAM. It may have manually activated, passive, automatic, or triggered abilities; activation style does not determine its operating type. **Icepicks, Basic Extractor, and SYN BUFFER are Executables.** In particular, SYN BUFFER's automatic protective effect does not make it a Protocol. Executables may be Hardware or Software.
- **Protocol:** A card deployed from hand into the **RACK**, the dedicated visible area for active Protocols. It occupies **no RAM** and has a BW deployment cost as printed. **Under current mechanics, deployed Protocols remain active throughout the Node; there is no existing way to deactivate, suspend, remove, or expire them during that Node.** At the **end of the Node, all deployed Protocols return to the Rustler's deck** for the next Node, without passing through the discard pile. **Deployed Protocols never enter the discard pile.** Card text may eventually specify a different duration, but no such Protocol currently exists; its handling would require explicit future rules rather than an assumed expiration zone.
- **Packet:** A single-use deck card played from hand without installation; it resolves its instructions and then leaves play under its applicable card rules. Its effects may persist beyond the card's resolution. Current examples: **PROBE, PULP Shield, GHOST SIGNAL**. This classification does not automatically apply to CAPS, which are outside the Rustler deck.
- **Bloatware:** The approved name for **Corporation-inserted hostile cards** that contaminate or interfere with the Rustler's deck/card cycle. Specific insertion, triggering, and early-removal rules remain **OPEN**; Bloatware persists no longer than its current Node and all remaining copies are removed at Node end. Do not assume every Bloatware card has the same triggers or effects.

**Protocol lifecycle (currently):** Hand → **RACK** (deployed, visible, active, zero RAM throughout the Node) → **Rustler deck at Node end**. No discard step after deployment and **no separate expired-Protocol zone** under current rules. All Protocols in the RACK are visible and inspectable. The RACK is specifically the Protocol deployment area; distinguish it from the existing Ghostware rack.

**Classification examples:** Icepicks = Executable; Basic Extractor = Executable despite automatic earnings; SYN BUFFER = Executable despite passive/automatic protection; PROBE / PULP Shield / GHOST SIGNAL = Packet. No existing card has yet been specifically approved as a Protocol.

**Preserve unresolved design questions:** The exact physical placement/size of the **RACK**, Bloatware's individual card triggers and early removal, possible future exceptions to Protocol duration and their handling, and interactions with future card effects remain to be designed.


## 42. Bloatware — ICE delivery, card-specific triggers, and persistence (APPROVED, 2026-11-11)

**Bloatware** is the approved operating-type name for hostile Corporation-inserted cards that contaminate or interfere with the Rustler's deck and operations.

- **Primary delivery:** Bloatware enters the Rustler's deck primarily through **ICE abilities and subroutines**. Other sources are possible but not yet defined.
- **Insertion location:** The delivering ICE ability or subroutine determines the destination or placement of the inserted Bloatware card; there is no universal insertion location.
- **Activation:** Triggers are **card-specific**, not universal. Possible printed triggers include **on draw, while held in hand, on discard, at end of turn, and on reshuffle**. A card may have multiple triggers or effects if printed.
- **Hand-based effects:** Some Bloatware may impose **continuous effects while in the Rustler's hand**, without needing to be played or manually activated. In particular, some Bloatware **enhances the Corporation's ICE while held in the Rustler's hand**. The specific ICE enhancement, scope, timing, and numerical strength are defined by each card, not globally.
- **Removal and persistence:** Both are **card-specific**. Some Bloatware can disappear after triggering, while others can remain through subsequent draws or reshuffles. Bloatware never carries into another Node: remaining copies are removed at Node completion. Card-specific effects can remove individual copies earlier, including by moving them to the BURNED state.
- **Stacking (APPROVED):** **Bloatware effects stack per physical copy by default**, including continuous ICE-enhancing effects and triggered effects. Each copy independently applies its full effect when its own conditions are met. For example, if a Bloatware card says **“At the end of the Rustler's turn, if this card is still in the Rustler's hand, deal 2 PULP to the Rustler,”** then three copies held in hand deal **6 PULP total** (2 PULP per copy). Likewise, three copies each granting Corporation ICE +1 STR while held grant **+3 STR** in total. Explicit card text may override default stacking. These examples illustrate the rule; they do not approve specific new cards.
- **Illustrative only:** A hypothetical card that gives Corporation ICE +1 STR while held is an **example, not an approved card or balance value**.

**Still open:** Exact early-removal mechanics for individual cards, per-card insertion and triggers, and concrete Bloatware designs. **Node-end removal is mandatory** for all Bloatware; there is no cross-Node carryover.


## 43. PULP damage terminology (LOCKED, 2026-11-11)

**User decision:** Rename the Rustler's physical/Vitae damage type **BURN** to **PULP** throughout current damage rules, examples, protection pools, and damage-specific card wording. E.g. **5 PULP** reduces Vitae by 5 before applicable PULP prevention; a Rustler may be described as **pulp'd**. **BURNED** remains the distinct card state for temporarily removing a card from the draw/discard cycle. The **BURNED** state and its next-Node return rules are not renamed or mechanically altered. Historical rule identifiers such as **BURN-001** are unchanged. Prior references to BURN as a damage type should be read as PULP; do not conflate PULP damage with BURNED cards. This terminology rename does not change damage calculations or shield functionality.


## RULES-CONSISTENCY-AUDIT-2026-11-11 — Current implementation precedence (LOCKED reconciliation)

This section reconciles earlier dated design entries; older locked decisions remain historical records, but the later approved revisions below govern implementation. This is a consistency correction, not approval of new card mechanics.

1. **Damage:** PULP is the Vitae-reducing physical damage keyword, including SyN/VOID overflow damage, shields, prevention, damage events, and triggers. SyN and VOID retain their existing effects, prevention, overflow rates, and fixed resolution order **VOID → SyN → PULP**. BURNED is exclusively a card-removal state, not a damage type. Do not convert ordinary narrative verbs such as “burn a CAP” into damage terminology.
2. **BREACHED:** Neutralizing every active DEADLOCK across the encounter enters BREACHED immediately; the Rustler may continue legal actions and voluntarily END TURN. Resolve eligible end-turn effects and housekeeping, **skip the final ordinary Corporation Response**, and proceed to rewards. Earlier LOOP-002 / MULTI-ICE-001 final-retaliation wording is superseded.
3. **Generalist starter deck:** The current approved **12 cards** are one WALL Icepick, one CODE GATE Icepick, one SENTRY Icepick, one Basic Extractor, one SYN BUFFER, **three identical PULP Shields**, **three identical PROBE**, and one unique GHOST SIGNAL (working name). This supersedes the former 10-card starter and two-shield quantities. All three Shields are **1-BW Instant Hardware Packets** granting **3 temporary PULP prevention** each; all three PROBE are **1-BW Instant Software Packets** permanently reducing a target ICE's strength by 2 for that ICE's lifecycle. GHOST SIGNAL is a **2-BW Instant Software Packet** that reduces the first TRACE attempt on the immediately following Corporation turn to zero; its temporary removal is **BURNED** for the remainder of that Node, with return at the next Node under existing BURNED rules. Do not use provisional EXILE as a separate state.
4. **SYN BUFFER:** Persistent **Hardware**, operating type **Executable**, costs 1 BW to install; its existing **1 RAM** cost remains provisional until explicitly changed. Its automatic once-per-ICE-encounter 1 SyN prevention, independent-copy handling, and same-physical-card reinstall safeguard are unchanged. It is not a Protocol or Instant Software. Icepicks and Basic Extractor are Persistent Software Executables; Protocols use the RACK, no RAM, and persist through the Node unless future approved rules say otherwise.
5. **Bloatware:** Hostile Corporation-inserted Bloatware is **Node-specific**, may persist across ICE encounters/layers within that Node, and **does not persist into another Node**. At Node completion, remove all remaining Bloatware copies from the Rustler's card cycle; earlier statements that Node carryover is undecided are superseded. Delivery destination, printed triggers, card-specific earlier removal, and numerical effects remain card-specific. Multiple physical copies stack independently by default, including hand-held ICE buffs and end-turn PULP. If printed to start in discard, insert there; if printed to become BURNED after its hand/end-turn effect, apply that card-specific instruction, and do not return it to the current Node's draw/discard cycle. Do not mistake Bloatware removal for PULP damage.
6. **Economy and timing:** Each ICE encounter has its own finite extractable CRED reserve; Basic Extractor pays up to 5 CRED from that remaining reserve on each eligible Rustler end turn, including the final BREACHED turn, and banks the payout immediately. Training Node test reserves are 15 / 25 / 40 CRED across its three encounters. End-of-turn effects resolve before BREACHED completion; no routine Corporation Response is inserted after BREACH.
7. **Scope and open items:** The approved Sentry and Code Gate Icepick profiles in BREAKER-STARTER-001 supersede older experimental pricing for those breakers only. WALL Icepick statistics, GHOST SIGNAL's final name, and explicitly marked working ICE/test-balance figures remain open. Historical paragraphs describing prior proposals are not alternative live rules; follow this reconciliation and the later approved sections it cites.


## MULTI-ICE-002 — Left-to-right Corporation Response execution (LOCKED, approved 2026-11-11)

**ICE placement:** The **main ICE is always the right-most ICE** in each encounter. Any supporting/secondary ICE occupy positions to its left. This is the encounter's displayed ICE order.

**Normal Corporation Response:** Begin with the **left-most ICE** and move **one ICE at a time from left to right**. For the current ICE, resolve each **unbroken, otherwise eligible subroutine individually from top to bottom**, in its printed/displayed order. Skip broken or otherwise neutralized subroutines. Complete that ICE's subroutine sequence before advancing to the ICE immediately to its right. Continue through the **right-most main ICE**, which resolves last. Effects from an earlier resolved subroutine apply according to their normal timing and duration, and may affect later subroutines or ICE; do not execute all ICE simultaneously or allow either player to freely reorder them.

**Preserved rules:** Apply the established per-subroutine timing, prevention, trigger queues, resolution-time validity, and immediate defeat rules as normal. This ordering does **not** invent a new modifier duration, stacking rule, TRACE consequence, or special DEADLOCK effect. All active DEADLOCKs across all ICE still must be neutralized to BREACH. If the encounter is already **BREACHED** when the Rustler ends the turn, the locked LOOP-002-SUPERSESSION-001 exception **skips the entire ordinary Corporation Response**; do not run this left-to-right sequence after BREACH. Earlier descriptions marking multi-ICE Corporation Response ordering OPEN are superseded by MULTI-ICE-002.
