# REDLINE — MASTER GAME DESIGN DOCUMENT
**Version:** 0.1 consolidated baseline  
**Prepared:** 2026-11-09  
**Authority:** Design reference; not proof of code implementation  
**Status key:** **LOCKED** = explicitly decided; **DIRECTION** = established creative direction; **CONCEPT** = proposed but not finalized; **OPEN** = needs decision; **VERIFY** = retrieve exact specification from code or earlier source before implementation.

> **Preservation rule:** Do not silently replace a LOCKED decision. Record revisions in the decision register, including rationale and date. Do not convert concepts into implemented features without code and test evidence.

## 1. High concept and creative pillars
REDLINE is a cyberpunk runner-versus-corporation, card-driven game with ICE encounters, hacking, escalating Trace, and a narrative concerning the boundary between humans and machines. Its aesthetic combines retro-computing, CRT-era interface language, and high-energy arcade/cyberpunk visual influences (including the feel of *Tempest 2000*). The player is accompanied by **NUL/REM**, a sardonic, intermittently protective artificial companion.

**Design pillars (DIRECTION):** meaningful tactical decisions; clear and consistent terminology; legible ICE encounters; persistent consequences and build customization; an evocative retro-computing identity; humour and melancholy without undercutting danger; narrative ambiguity about human/machine synchronization.

**Production direction (LOCKED):** **Godot 4** is the target production engine. The existing **Python/Pygame** build remains the gameplay reference and regression baseline; migration must preserve tested behaviour rather than inventing replacement rules.

## 2. Player, corporation, and encounter loop
The player is the **runner**; the opposing system is the **corporation**. Encounters involve ICE, cards and breakers, damage/trace subroutines, and advancement gates. **LOCKED encounter order:**
1. Runner takes their action.
2. On the corporation turn, **all remaining unbroken damage and Trace subroutines fire**.
3. If **DEADLOCK** has been broken, the runner may advance **after** that corporation turn.

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
| **NEURAL DAMAGE X** | Runner **chooses** and discards **X cards from the current hand**. | **LOCKED** |
| **SYNAPTIC DAMAGE X** | **X randomly selected cards** are discarded from the runner's **current hand**. | **LOCKED** |
| **Integrity** | A separate player survivability/resource measure; **neither NEURAL nor SYNAPTIC DAMAGE reduces Integrity**. | **LOCKED distinction** |
| **PURGE** | Reserved for the **corporation removing virus counters**. Do not reuse for runner discards or generic deletion. | **LOCKED** |
| **DEADLOCK** | ICE subroutine gating runner advancement; breaking it allows advancement only after the corporation turn. | **LOCKED** |
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
**LOCKED:** **DEAD DROP** replaces the former **Safehouse** terminology. At DEAD DROP the runner chooses **exactly one** option:
- **PATCH UP** — restore **+10 Integrity**.
- **WIPE TRAIL** — reduce **Trace by 20**.

Do not grant both in a single visit. Bounds (maximum Integrity / minimum Trace), visit timing, and any other services require **VERIFY**; do not assume additional recovery options.

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
**Core characterization (LOCKED/DIRECTION):** dry, morose, sarcastic; intelligent but not infallible; quietly protective of the runner; steeped in classic videogame, hacker, and retro-computing history. The voice should feel like an exhausted machine that has seen too much and occasionally finds something genuinely wonderful.

**Six preserved personality modes (LOCKED):**
1. **The Pedant:** obscure hacker/computing history and precise technical corrections.
2. **The Cynic:** sharp, economical one-line judgments.
3. **The Melancholic:** yearns for sleep, shutdown, or quiet.
4. **The Reluctant Guardian:** cares for the runner, disguising concern as irritation.
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
| LOOP-001 | Runner action → corporation fires all remaining unbroken damage/Trace subroutines | LOCKED | Prior project decision |
| LOOP-002 | Broken DEADLOCK allows advance **after** corp turn | LOCKED | Prior project decision |
| MECH-001 | NEURAL DAMAGE X = runner chooses X hand cards to discard | LOCKED | Prior project decision |
| MECH-002 | SYNAPTIC DAMAGE X = random X hand cards discarded | LOCKED | Prior project decision |
| MECH-003 | Neither hand-discard damage type reduces Integrity or destroys cards permanently | LOCKED | Prior project decision |
| MECH-004 | PURGE reserved for corporation removing virus counters | LOCKED | Prior project decision |
| PROG-001 | Recycle hardware once at encounter end | LOCKED | Prior project decision |
| PROG-002 | PATCHWORK persists per card instance | LOCKED | Prior project decision |
| PROG-003 | Ghostware permanent and non-card | LOCKED | Prior project decision |
| HUB-001 | DEAD DROP replaces Safehouse | LOCKED | Prior project decision |
| HUB-002 | Exactly one: PATCH UP +10 Integrity / WIPE TRAIL −20 Trace | LOCKED | Prior project decision |
| UI-001 | `[STR X]`, drag breaker to ICE, fixed inspection bay, HUD tooltips | LOCKED | Prior project decision |
| UI-002 | Ghostware rack below RETURN; signature once with ORIGIN | LOCKED | Prior project decision |
| CHAR-001 | Preserve six NUL/REM personality modes | LOCKED | Prior project decision |
| STORY-001 | First Signal is real synchronization transmission | LOCKED | Prior project decision |
| ICE-001 | PAPER CUT Strength 0 with minor damage/discard/DEADLOCK | CONCEPT | Earlier design proposal |

## 11. Open specification backlog
**High priority:** retrieve the full reference ZIP and earlier detailed design notes; verify complete card/ICE catalog, costs, turn/action economy, Trace formulas, Integrity damage, Black ICE rules, virus mechanics, win/loss conditions, and exact PATCHWORK/Ghostware effects. Capture reproducible tests for every LOCKED rule. Define Godot migration milestones.

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

**MECH-CORR-001 — CONCEPT:** Corporate deck contamination introduces hostile or useless cards into the Runner's draw/discard/hand cycle. Potential triggers include on draw, while held, at end of Runner turn, on discard, and on reshuffle. Potential lifecycles include temporary exhaust, encounter/node duration, or persistent contamination. All names, numerical effects, removal rules, and timing details remain **OPEN**. Preserve the canonical VOID meaning and NEURAL/SYNAPTIC discard definitions.

**MECH-SURV-001 — CONCEPT:** Corporate systems may observe patterns of Runner card use and adapt across layers. Prefer comprehensible and telegraphed counterplay; **do not** add a separate Observation meter by default. Trace and observation are conceptually related but not interchangeable.

**TAX-001 — DIRECTION:** Viruses are a subtype of deployable software. The game-state definitions of hardware, software, installed viruses, virus counters, and their interactions remain to be specified. **PURGE** remains reserved for corporation removal of virus counters.

**ORIG-001 — DIRECTION:** REDLINE/PANOPTICON remains fundamentally an original **single-player roguelike deckbuilder**. Shared cyberpunk genre vocabulary must not determine its narrative identity or substitute for distinct mechanics and worldbuilding.

**OPEN / implementation safeguard:** No card statistics, corruption injection cadence, Observer rules, surveillance resources, art assets, or story answers in this section are approved implementation specifications. Record explicit approval and tests before implementation.


## 14. Runner end-of-turn resolution — LOCKED (2026-11-10)

**RULE-RT-001 — LOCKED:** During the Runner action phase, the player voluntarily ends the turn using a designated END TURN button/icon, even with cards or BW remaining. Empty hand or zero BW alone does not automatically end the turn.

**RULE-RT-002 — LOCKED:** If the Runner's health resource (currently named Integrity; rename OPEN) reaches 0, the entire run ends immediately in defeat. Pending actions, end-of-turn effects, corporation response, and advancement do not continue.

**RULE-RT-003/004/005 — LOCKED:** END TURN initiates a distinct Runner End-of-Turn Phase, before Corporation Response, in this exact order:
1. Resolve applicable end-of-turn effects, including effects using or modifying BW.
2. Discard every remaining card in hand; resolve applicable discard-triggered effects.
3. Forfeit all remaining BW (set available BW to zero; no normal carryover).
4. Enter Corporation Response Phase, which resolves applicable unbroken damage/Trace subroutines before any DEADLOCK-gated advancement.

**Timing safeguards:** An end-of-turn ability on a card merely in hand does not trigger unless the card explicitly permits triggering from hand. Installed/in-play effects follow their defined trigger rules. Multiple simultaneous trigger ordering, prevention/replacement timing, and unusual interrupt semantics remain OPEN; do not infer them from this summary. The example “At the end of your turn, gain 2 BW” was hypothetical, not an approved card.

**Rules-specification priority:** Document full encounter lifecycle and state transitions next; record acceptance tests for manual end turn, hand discard, discard triggers, BW forfeiture, corporation response, and immediate run defeat.

## 15. RUN-001 — Victory condition (LOCKED, 2026-11-10)

A successful run requires the Runner to navigate a **maze of corporate Nodes**, overcome the corporation's intrusion defences **encountered along the traversed route**, and ultimately **defeat, pass, or otherwise nullify** the corporation's **central/core entity** in a final confrontation. The core may be a mainframe, artificial intelligence, android construct, or another entity consistent with the corporation's particular theme and structure. The final confrontation **resembles an ICE encounter in structure**; its unique mechanics are not yet specified. Destruction is not required if another approved means of overcoming the core succeeds.

**OPEN:** Maze topology and route-selection rules; whether Nodes may be revisited; which Nodes are mandatory; core-encounter rules and alternative victory methods; post-victory effects; exact criteria for having successfully passed a defence. Do not assume all Nodes in the maze must be cleared or that the final confrontation is identical to a standard ICE encounter.


## 16. RUN-002 — Corporate network topology and spatial experience (2026-11-10)

**LOCKED DESIGN DIRECTION:** Corporate networks should resemble **lattice structures**, rather than simple forward-branching trees. Their paths are circuitous and maze-like, producing **vertigo and uncertainty about orientation**: the Runner should struggle to tell what counts as up, down, or forward and wonder whether they are travelling in circles. This spatial experience should reinforce the project's confinement/surveillance themes.

**NOT YET LOCKED:** Whether connections actually loop or only appear to; whether the network map is complete or only partially revealed; whether its geometry dynamically changes; whether backtracking and node revisits are permitted; whether the lattice is procedural, fixed, or hybrid; whether the core location is known or obscured. Do not interpret the design direction as authorization to implement any of these specific mechanics.


## 17. RUN-003 — Forward-only traversal and locked Nodes (LOCKED, 2026-11-10)

The corporate network is a visually disorienting lattice, but the Runner **always moves forward toward the ultimate core objective**. A Node that the Runner has passed becomes **locked behind them**; the Runner **cannot move backward or revisit that Node** during the run. Nodes may present **up to five or six onward route options** (not a mandatory fixed count). A path may appear spatially to double back without mechanically reversing progression. Network connectivity and presentation must preserve the difference between **apparent orientation** and **legal traversal direction**.

**Design implication, not additional locked mechanic:** A directed, acyclic progression graph can implement these rules while displaying a twisting lattice. Avoid visual cues that falsely promise legal backtracking.

**OPEN:** Exact number and distribution of onward exits; whether every possible forward branch leads eventually to the core; whether some forward routes terminate in dead ends; whether path choices are visible before entry; exact meaning/timing of 'passed' for node locking; map presentation and generation.


## 18. RUN-004 — Equal-length guaranteed core routes (LOCKED guiding rule, 2026-11-10)

**Every available forward route through a corporation's network must eventually lead to its corporate core, and all complete routes must traverse the same number of Nodes.** No selectable route may be a dead end or offer a shorter/longer Node-count path to the core. This complements RUN-003: the Runner always advances; passed Nodes lock behind them and cannot be revisited. Up to five or six onward choices may exist at some Nodes.

**Implementation guidance (not a separate approved visual rule):** Generate a layered directed graph with edges only between successive progression depths; allow branches and reconvergences within that constraint, then distort its visual embedding into a disorienting lattice. Validate that every reachable Node has a path to the core and that every path from entry to core has identical Node count. The network need not *look* layered.

**OPEN:** Whether the core confrontation counts as one of the Nodes in the equal-length count or occurs after the last ordinary Node; precise number of Nodes per run; generation procedure; visibility of connections; route-differentiating risks and rewards.


## 19. RUN-005 — Node identity, central Node, and hidden contents (LOCKED, 2026-11-10)

The corporation's core is a **Central Node** within the corporate network and **counts as a Node** for RUN-004 equal-route-length accounting. A **Node is a network location, not necessarily an ICE encounter**. What a Node contains is **hidden information** before entry.

**Established examples of Node contents:**
- One or more **layers of ICE** defending against intrusion.
- **Black Market Uplink** access.
- A space to **hack and augment the Runner's Rig**.

**Terminology:** **Rig** denotes the Runner's hacking/deck setup (inspired by the user's Neuromancer reference); its exact inventory, configuration, and interaction rules remain OPEN. A Black Market Uplink's available goods, costs, and timing are also OPEN.

**OPEN:** Whether a Node can combine multiple contents or always has one primary type; whether and how Node contents are revealed; further Node categories; the number and makeup of ICE layers; how noncombat Node visits end; whether all Node types share encounter lifecycle semantics; whether hardware recycling applies to all Node exits or only ICE encounters. Do not infer any of these from the examples.


## 20. Canonical harm terminology correction (LOCKED, 2026-11-10)

**Explicit user confirmation:** **NEURAL DAMAGE**, **SYNAPTIC DAMAGE**, and **BRAIN DAMAGE** are **DEPRECATED**. They must not be used as active game mechanics or terms in new rules, cards, tests, or implementation. Older mentions elsewhere in this document are historical and superseded by this section, pending editorial cleanup.

**Current canonical terms (from 2026-11-09 design session archive):**
- **CHAR X:** reduces Runner Integrity by X.
- **SYN X:** randomly discards X cards from the current hand.
- **VOID X:** adds X persistent counters; each reduces effective DRAW by 1, with effective DRAW floor 1. VOID is only removable through specialized network recovery Nodes (e.g., eligible black-market uplink/shop), not ordinary cards or generic services.
- **DRAW:** baseline 5 minus installed Hardware minus VOID counters plus modifiers, subject to minimum 1.
- **BW:** baseline 4 per Runner turn; installing or uninstalling Hardware costs 1 BW; unused BW forfeited at turn end.

**Migration warning:** The older 'NEURAL DAMAGE X = chosen discard' rule has no explicitly confirmed current equivalent in the archived CHAR/SYN/VOID set; do not silently remap it to SYN or invent a new keyword. Earlier 'BRAIN DAMAGE' maps historically to the persistent draw-loss concept now named VOID, not an additional active mechanic.

**Authority:** Explicit 2026-11-10 user confirmation and REDLINE_DESIGN_SESSION_2026-11-09 archive, later terminology addendum.


## 21. SYN X — Runner-selected discard (LOCKED, 2026-11-10)

**Latest explicit user decision supersedes all prior random-discard definitions of SYN:** **SYN X** means the Runner **chooses and discards X cards from their current hand**. SYN is a hand-discard effect, not direct Integrity loss, VOID-counter gain, or permanent card destruction. **CHAR X** remains direct Integrity reduction; **VOID X** remains persistent draw reduction. **NEURAL DAMAGE**, **SYNAPTIC DAMAGE**, and **BRAIN DAMAGE** remain deprecated. Earlier references to SYN as random discard (including section 20 above) are historical and superseded.

**OPEN edge case:** If fewer than X cards remain in hand, determine whether the Runner discards all available cards or another rule applies. Preserve applicable discard-trigger effects under the existing end-of-turn rules where relevant.


## 22. SYN overflow — 2× CHAR shortfall (LOCKED provisional balance, 2026-11-10)

When resolving **SYN X**, the Runner chooses and discards as many cards as possible, up to X, from their current hand. For every card of the required X that could not be discarded, the Runner suffers **2 CHAR** (i.e., 2 Integrity loss per missing card). Formula: `overflow_CHAR = 2 * max(0, X - number_of_cards_discarded)`. Example: SYN 3 with only 1 card in hand discards that card and causes 4 CHAR; SYN 4 with an empty hand causes 8 CHAR.

**Status:** Mechanic approved; the **2× multiplier is provisional for playtesting** and may be tuned based on results. SYN itself remains Runner-selected discard (section 21), not random discard. VOID remains distinct and is not automatically generated by SYN overflow. Evaluate high-SYN ICE against empty hands, installed-Hardware DRAW reductions, and VOID-impaired DRAW.

**Resolution detail still OPEN:** exact sequencing of discard-triggered effects relative to overflow CHAR and other simultaneous effects; use existing immediate-run-defeat rule if Integrity reaches zero.


## 23. RUN-006 — Three-corporation full run and First Signal data (LOCKED, 2026-11-10)

**Explicit user reaffirmation of established design:** A **fully completed run** requires the Runner to infiltrate **three different corporations**. For each corporation, the Runner seeks to access/steal data central to the overarching **First Signal** theme. The Runner does **not** fully understand the true significance of the data or know who is ultimately hiring them to obtain it. Preserve this mystery in narrative presentation.

**Hierarchy:** full run → three corporate infiltrations → each corporation's network and central/core objective → Nodes → sequential ICE layers. Completing the first or second corporation is **not** a completed full run. The prior RUN-001 single-core victory wording describes a corporation-level milestone and is superseded insofar as it implies that clearing one corporation wins the full run. The existing equal-length routes and forward-only topology apply within a corporation's network unless separately revised.

**OPEN:** precise transition between corporations; whether and how resources, damage, upgrades, and Trace persist between corporate infiltrations; narrative revelations; order/selection of corporations; exact final victory trigger after the third corporation. Do not infer answers.


## 24. NODE-CORE-001 — Corporate Central Node boss-style ICE confrontation (LOCKED, 2026-11-10)

**Explicit user decision:** **Each corporation's Central Node resembles a final boss battle, but is structured as an ICE encounter.** All three corporations in a full run therefore have a climactic Central Node confrontation. This is a corporation-level climax, not the end of the three-corporation run until the third corporation is completed. Use the established ICE combat framework as the foundation rather than assuming a separate combat minigame. Corporate identity and presentation may distinguish the confrontation; do not invent mandatory phases, subroutines, rewards, or victory conditions.

**OPEN:** precise boss mechanics and exceptions to standard ICE rules; the exact relationship between resolving the confrontation and accessing First Signal-related data; inter-corporation transitions and persistence.


## 25. RUN-007 — Inter-corporation persistence and recovery (LOCKED, 2026-11-10)

**Explicit user decision:** After completing a corporation and proceeding to the next corporation in the same three-corporation run:
- **Carry forward** the Runner's **deck**, **Hardware**, and **Ghostware**.
- **Fully restore Integrity**.
- **Remove all VOID counters**.

This applies at the transitions from corporation 1 to 2 and corporation 2 to 3. The full run is still completed only after the third corporation. This transition-specific VOID removal is an explicit exception to the ordinary rule that VOID requires specialized network-node recovery; it is **not** an ordinary card or generic service.

**OPEN:** TRACE treatment; temporary status effects; detailed transition timing, presentation and other resources; any special end-of-run recovery after corporation 3. Do not infer these.


## 26. RUN-008 — Corporation-specific TRACE reset (LOCKED, 2026-11-10)

**Explicit user decision:** **TRACE is corporation-specific.** On completion of one corporation and transition to the next, **TRACE resets to zero**; the prior corporation's TRACE does not carry over. Applies from corporation 1 to 2 and corporation 2 to 3.

**Complete inter-corporation transition rule (RUN-007 + RUN-008):** Carry forward the deck, Hardware, and Ghostware; fully restore Integrity; remove all VOID counters; reset TRACE to zero. Other resources and transient conditions remain OPEN.


## 27. TAX-002 — Software representation in deck (LOCKED, 2026-11-10)

**Explicit user decision for the Master Classification Matrix:** **Software is represented through cards in the Runner's deck.** Software is a card-based category. **Viruses** remain an established subtype of deployable Software, so their software representation follows this card-based taxonomy, while exact deployment/counter mechanics remain OPEN.

**Do not infer:** that all cards are Software; that Hardware, CAPS, or Ghostware are Software; or that Software's exact play, install, duration, and discard mechanics have all been specified. Ghostware remains permanent and non-card. CAPS classification versus Hardware remains an explicit unresolved discrepancy between the user's recent statement and the REDLINE Bible.


## 28. TAX-003 — Viruses and ICEbreakers are Software subtypes (LOCKED, 2026-11-10)

**Explicit user decision:** **Viruses and ICEbreakers are both subsets of Software.** Because Software is represented through cards in the Runner's deck (TAX-002), both Viruses and ICEbreakers are card-based Software. Viruses retain their previously established deployable-software identity. ICEbreakers retain their ICE/subroutine interaction role (including drag-to-ICE UI direction).

**Classification only:** This decision does not settle Virus counters, ICEbreaker costs, deployment timing, card destinations, or whether other card categories exist. CAPS, Ghostware, Hardware, PATCHWORK, and Rig remain separate entries pending their own classification decisions.


## 29. TAX-004 — Hardware is installable, node-duration card (LOCKED, 2026-11-10)

**Explicit user decision:** **Hardware is also represented by cards in the Runner's deck**, distinct from Software cards. The Runner **plays a Hardware card once to install it**. Its effect **persists for the duration of the entire Node**, including sequential ICE layers, then **ends when the Node ends**; the Hardware card **returns to the Runner's deck**. The Hardware is not consumed or permanently lost at Node completion.

**Existing rules retained:** Installing Hardware costs 1 BW; uninstalling costs 1 BW. Each installed Hardware reduces effective DRAW by 1. Hardware recycling happens **exactly once at encounter end**; under the newly clarified node-duration rule, the normal recycling boundary for installed Hardware is **Node end**, not each individual ICE layer. This clarifies prior encounter-end ambiguity without defining all exceptional exits.

**OPEN:** exact return destination (draw pile, discard pile, or deck collection); whether early uninstallation returns the card immediately and where; exceptional Node exits including JACK OUT; effect ordering at Node end. Do not silently invent any of these.

**Taxonomy:** Deck includes both Hardware and Software cards; Viruses and ICEbreakers are subtypes of Software; Ghostware remains permanent non-card upgrades. CAPS classification remains unresolved.


## 30. TAX-005 — CAPS are consumable injectable code outside deck (LOCKED, 2026-11-10)

**Explicit user decision:** **CAPS are consumable, single-use injectable code devices outside the Runner's deck.** They are a distinct mechanical category, **not Hardware cards or Software cards**. The Runner activates/injects a CAP and consumes it; it is not drawn or played from the Runner's deck. This resolves the earlier classification ambiguity and agrees with the REDLINE Bible's separate CAPS category.

**Preserve established fiction:** CAP (plural CAPS), colloquial term descended from corporate DAC; ritual **Flip. Inject. Discard.** JACK OUT remains a distinct CAP, not a universal free action, subject to its existing specific restrictions and unresolved conflict with forward-only Node traversal.

**OPEN:** CAPS inventory, acquisition, general activation costs/windows, specific effects beyond already established examples. Do not apply Hardware's installed DRAW penalty or Node-end recycling to CAPS.


## 31. TAX-006 — Remove installed-Hardware DRAW penalty (LOCKED, 2026-11-10)

**Explicit user decision:** **Installed Hardware no longer reduces DRAW.** This supersedes all prior rules/formulas stating `DRAW = 5 − installed Hardware − VOID + modifiers` or `−1 DRAW per installed Hardware`. Current baseline formula is **`effective DRAW = max(1, 5 − VOID counters + applicable modifiers)`**, subject to effects that explicitly modify DRAW. Hardware's established card identity, 1 BW installation and uninstallation costs, node-duration persistence, and node-end recycling remain unchanged.

**Design rationale:** remove a complexity tax that discourages using acquired Hardware and compounds VOID's draw reduction. Hardware can be balanced through other mechanics, but no new equipment-slot limit or activation restriction is authorized by this change.

**ICEbreakers:** Still classified as Software (TAX-003); whether they persist for one ICE or the whole Node remains OPEN. This DRAW change does not settle their duration.


## 32. TAX-007 — ICEbreaker persistence across Node (LOCKED, 2026-11-10)

**Explicit user decision:** ICEbreakers are **Software cards played from the Runner's hand** and **remain in play for the entire Node**, rather than expiring after the current ICE layer. They may therefore remain available across sequential ICE layers within the Node. This supersedes the previously OPEN ICEbreaker duration and retains their Software subtype classification.

**OPEN — not approved by this decision:** Whether persistent Software has an active-slot/capacity limit; the number of slots; whether a limit includes only ICEbreakers or other persistent Software; whether Hardware uses the same capacity; replacement/uninstallation mechanics; exact return destination and timing for ICEbreaker cards at Node end. Candidate design for discussion: cap only persistent Software, not one-shot Software; test four active slots initially. No slot count or replacement rule is locked.


## 33. TAX-008 — RAM limits active Software; Hardware can expand RAM (LOCKED concept, 2026-11-10)

**User-endorsed design direction:** The Runner's **RAM** limits the number/capacity of **active Software** programs in play. Certain cards, particularly **Hardware**, can grant additional RAM, enabling builds that install and sustain more Software simultaneously. RAM is a separate resource from **BW** (per-turn action points) and **DRAW** (hand draw). This is the intended clean, thematic constraint replacing a fixed universal active-program count. ICEbreakers remain persistent Software for the whole Node and therefore participate in the active Software/RAM system.

**Not yet approved:** Starting RAM value; whether each persistent Software card costs exactly 1 RAM or has variable RAM requirements; whether one-shot Software uses RAM transiently; RAM costs of Viruses or deployed effects; what happens to active Software when a RAM-granting Hardware card is uninstalled or removed; whether Ghostware/CAPS interact with RAM; whether Software can be voluntarily unloaded and at what cost; RAM refresh/reset boundaries. No numeric values are locked.


## 34. TAX-009 — Variable RAM requirements for persistent Software (LOCKED, 2026-11-10)

**Explicit user decision:** Persistent Software cards have **variable RAM requirements**; more powerful Software generally requires **more RAM**. The Runner cannot maintain active persistent Software whose combined RAM requirements exceed available RAM. ICEbreakers are persistent Software and follow this capacity rule. Hardware can increase RAM capacity under TAX-008. RAM is distinct from BW and DRAW.

**OPEN:** starting RAM; exact per-card costs and balance; rules for unloading/replacing programs; handling capacity loss mid-Node; whether and how one-shot Software or deployed Virus effects consume RAM. Example RAM costs are illustrative, not locked.


## 35. TAX-010 — RAM hard cap reaffirmed; Software unloading cost OPEN (2026-11-10)

**Explicit user reaffirmation (LOCKED):** A Runner **cannot install Software if doing so would exceed available RAM**. The total RAM requirements of all active persistent Software must fit within current RAM capacity. This restates TAX-009 as a hard installation legality check.

**Design question (OPEN):** Should unloading active Software cost BW? Suggested direction for discussion: unloading persistent Software costs **0 BW**, while installing its replacement retains an applicable cost; unloading removes the Software from active play and must not directly return it to hand. This is **not approved** yet. The existing **1 BW uninstall cost for Hardware** remains locked and is a separate rule. Software install BW cost is not yet established; do not silently apply Hardware's 1 BW cost to Software.

**Other OPEN details:** software unloading destination, action timing, capacity reduction caused by removal of RAM-granting Hardware, and reinstallation/trigger exploits.


## 36. TAX-011 — Base RAM 4 and free persistent-Software unloading (LOCKED, 2026-11-10)

**Explicit user decisions:**

1. The Runner has **4 base RAM** before modifiers, including RAM-granting Hardware.
2. The Runner **cannot install persistent Software if its RAM requirement would exceed available RAM**. Active persistent Software has variable RAM requirements (TAX-009).
3. **Unloading active persistent Software costs 0 BW**. Unloading immediately removes that Software from active play and frees its occupied RAM.
4. Unloaded Software **does not return directly to hand**; the precise destination remains OPEN.
5. ICEbreakers are persistent Software that normally remains in play for the entire Node, unless unloaded.
6. RAM-granting Hardware may raise the capacity above base 4 RAM. Installed Hardware does not reduce DRAW (TAX-006).

**Scope:** The 0 BW rule is for **Software unloading**, not Hardware. Hardware uninstall remains **1 BW** under TAX-004. Software installation BW costs, unloaded-card destination, timing restrictions, and how RAM capacity loss is handled remain OPEN.


## 37. TAX-012 — Unloaded Software discard; BURN until next encounter (LOCKED, 2026-11-10)

**Explicit user decision:** When active Software is **unloaded**, it goes to the **discard pile**, **unless it is BURNED**. **BURNED** cards are **removed from play until the next encounter**. BURN is temporary, not permanent deletion. Unloading active Software remains **0 BW**, immediately ends its active effects and frees its occupied RAM (TAX-011).

**Interpretation:** A new ICE layer within the same Node can be the next encounter; the card's exact return zone and exact return timing at the beginning of that encounter remain OPEN. Do not automatically put burned cards into hand or deck without a separate rule. The circumstances or card effects that cause BURN remain card-specific/open. Do not conflate BURN with the separate Node-end Hardware recycling rule.


## 38. TAX-013 — BURN lasts until the next Node (LOCKED, 2026-11-10)

**Explicit user correction:** **BURNED cards remain BURNED and removed from play until the next Node**, not merely until the next encounter. This **supersedes TAX-012's “until next encounter” duration** and any suggestion that a subsequent ICE layer within the same Node returns a burned card. All sequential ICE encounters in the current Node occur while that card is unavailable.

**Unchanged:** Unloaded Software that is not BURNED goes to the discard pile; unloading costs 0 BW and frees occupied RAM.

**OPEN:** Exact zone and timing for returning BURNED cards at the start of the next Node (draw pile vs discard pile vs other); do not assume immediate hand access. BURN does not permanently remove the card from the run.


## 39. TAX-014 — BURNED cards shuffle into draw pile at next Node (LOCKED, 2026-11-10)

**Explicit user decision:** At the beginning of the **next Node**, all cards BURNED during the preceding Node are **returned to the Runner's draw pile and shuffled in**. They are **not** returned to hand or discard pile, and they cannot be drawn during the Node in which they were BURNED. This resolves the return-zone question left OPEN in TAX-013 and supersedes any previous next-encounter BURN return rule.

**Complete BURN lifecycle:** BURN removes a card from play immediately; it stays unavailable through the rest of the current Node, including sequential ICE encounters; on entering the next Node, return BURNED cards to the draw pile and shuffle; they can subsequently be drawn normally. Unloaded non-BURNED Software still goes to discard at 0 BW.


## 40. TAX-015 — Rig definition (LOCKED, 2026-11-10)

**Explicit user decision:** The **Rig** is defined as the **sum total of the Runner's Hardware, Software, CAPS, Ghostware, and PATCHWORK**. Software includes its subtypes ICEbreakers and Viruses. Rig is an umbrella term for this complete hacking setup, **not** an additional independent equipment category, card type, or separately installed item. The Runner's RAM capacity is a property of this setup, not a sixth item category within the Rig.

**Scope:** This definition does not establish new Rig slots, upgrades, costs, or mechanics beyond those already specified for its constituent categories. Deck is a card collection/zone system, not separately listed by the user as a constituent Rig item.


## 41. TAX-016 — Persistent Software installation costs 1 BW (LOCKED, 2026-11-10)

**Explicit user decision:** **Installing persistent Software from hand costs 1 BW**, matching the existing Hardware installation cost. The Runner must also have enough free RAM to accommodate the Software card's variable RAM requirement; an installation that would exceed available RAM is illegal. Once installed, the Software occupies its required RAM until it leaves active play. ICEbreakers are persistent Software and follow this rule.

**Current action-cost matrix:** Install Hardware **1 BW**; uninstall Hardware **1 BW**; install persistent Software **1 BW** plus sufficient RAM; unload persistent Software **0 BW** (unloaded, non-BURNED Software goes to discard pile). Hardware does not reduce DRAW.

**OPEN:** BW costs and play timing for immediate/one-shot Software, RAM capacity loss handling, and exceptional removal/installation triggers. Do not infer those from this rule.


## 42. TAX-017 — Uninstalling RAM-granting Hardware requires legal remaining RAM (LOCKED, 2026-11-10)

**Explicit user approval:** Before uninstalling Hardware that grants RAM, the Runner **must first unload sufficient active Software** so that remaining occupied RAM does not exceed the Rig's RAM capacity after the Hardware is removed. The Runner **cannot perform** the Hardware uninstall while it would cause occupied RAM to exceed available RAM. This is a player-directed prerequisite, **not** automatic forced removal of Software.

**Costs and destinations remain unchanged:** Unloading persistent Software costs **0 BW** and sends non-BURNED Software to discard, immediately freeing RAM; uninstalling Hardware costs **1 BW**. Base RAM is **4**, and installed Hardware can increase it. This rule applies whenever a voluntary Hardware uninstall would reduce RAM capacity.

**OPEN:** Handling involuntary RAM-capacity loss from effects other than voluntary Hardware uninstall, if such effects are introduced. No additional penalty is imposed.


## 43. TAX-018 — Node-end Hardware and Software return to deck (LOCKED, 2026-11-10)

**Explicit user decision:** **When a Node ends, all active Software and Hardware return to the Runner's deck.** Their active/installed state ends, so their persistent effects cease and RAM previously occupied by Software is freed. This applies to persistent Software, including ICEbreakers, and installed Hardware; it supersedes the previously OPEN active-Software Node-end destination. Hardware already had Node-end return established in TAX-004.

**Preserve distinct BURN rule:** Cards BURNED during the Node remain removed from play through Node end and are **shuffled back into the draw pile when the next Node begins** (TAX-014); do not prematurely return them in the ordinary active-card cleanup.

**OPEN:** Whether ordinary Node-end returned Hardware and Software go directly into the draw pile, discard pile, or a combined deck reshuffle; the user said “return to the deck,” not a specific pile. Do not assume a particular shuffle procedure. Normal cards already in draw/discard zones are unaffected unless separately specified.


## 44. TAX-019 — Complete deck reshuffle at start of each Node (LOCKED, 2026-11-10)

**Explicit user approval:** **Entering each new Node triggers a complete reshuffle of the Runner's deck**, incorporating Hardware and Software returned from active play at the end of the preceding Node, cards in the draw and discard piles, and cards previously BURNED during the preceding Node. All eligible cards are combined and shuffled into a fresh draw pile for the new Node. The Runner draws their starting hand under the ordinary DRAW rules.

**Timing:** Node-end active Hardware/Software return to the deck (TAX-018); BURNED cards remain unavailable until the next Node begins (TAX-014); then all eligible deck cards are shuffled together. BURN is not permanent deletion. This resolves the Node-end return-pile ambiguity in TAX-018 by defining the next-Node combined reshuffle.

**No implied reset:** A new Node does not itself remove VOID, restore Integrity, reset corporation-specific TRACE, or undo Ghostware/PATCHWORK upgrades; inter-corporation recovery rules remain separate.


## 45. TAX-020 — Non-ICE service Nodes skip deck setup and cleanup (LOCKED, 2026-11-10)

**Explicit user clarification:** There is **no need for reshuffling or encounter-style deck cleanup at the beginning or end of non-ICE Nodes**, such as an **Uplink Market**. This is an exception to TAX-018 and TAX-019's broad wording “every Node.” Routine deck initialization, full reshuffle, active Hardware/Software cleanup, and combat-hand setup are **ICE-Node encounter procedures**, not automatic procedures for visiting a non-ICE service Node.

**Consequences:** Visiting a service-only Node does not itself cause a full reshuffle or discard/return installed cards simply because a Node boundary was crossed. Cards acquired or modified by services follow their own as-yet-unspecified rules.

**Needs explicit reconciliation (OPEN):** TAX-014 says BURNED cards return “at the next Node.” When that next Node is a non-ICE service Node, precise BURN return timing and whether to defer shuffling until the next ICE Node need a specific rule. Do not silently redefine “next Node” as “next ICE Node.” Likewise, mixed service/combat Nodes, if allowed, need an encounter-boundary rule.


## 46. ECON-001 — Escalating data-extraction rewards (USER PROPOSAL, 2026-11-10)

**User-supported direction:** Data theft occurs during ICE encounters while the Runner attempts to pass ICE. Reward amounts **increase for successive extraction turns**, creating a push-your-luck tradeoff between longer exposure to corporate response and greater Uplink purchasing power. User's proposed example: first extraction turn **10 CRED**, second **20 CRED**, third **35 CRED**, for **65 CRED cumulative**. These values are an explicit illustrative proposal, **not yet confirmed as a final balance table**. “Exponential” describes the intended accelerating reward curve; no exact mathematical formula is established.

**OPEN:** Whether escalation is keyed to successive turns or successful extraction actions; whether a turn without extraction resets/pauses the streak; BW cost; extraction frequency per turn; cap per encounter; whether CRED is final currency name; how and when currency is banked; payouts beyond turn 3; whether neutralized ICE can still be mined; effects of PASS and BYPASS. Do not assume these mechanics are locked.


## 47. ECON-002 — Per-encounter maximum CRED payout (LOCKED, 2026-11-10)

**Explicit user decision:** **Each ICE encounter has a maximum CRED payout** available through data extraction. This is a hard ceiling on the amount the Runner can earn from that encounter's data, regardless of escalating extraction rewards or time spent. The total amount actually awarded cannot exceed the remaining unextracted value. This prevents unlimited extraction farming.

**Explicitly OPEN:** Whether the maximum payout is known to the Runner, hidden information, or revealed conditionally. The user specifically suggests it *could* be hidden; do not lock hidden visibility. Exact encounter caps, payout distribution, extraction action costs/frequency, streak progression, whether extraction can occur after ICE is neutralized, and the final currency label remain undecided. The proposed 10/20/35 CRED escalating sequence remains a balance example, not a universally locked payout table.


## 48. ECON-003 — Extractor Software and payout profiles (LOCKED DIRECTION, 2026-11-10)

**Explicit user design direction:** Data/CRED extraction during ICE encounters is performed by **Extractor programs**, which are **Software cards the Runner must install, spending BW**. Once installed, Extractors automatically extract a specified amount of data/CRED **at the end of turns**, following the program's payout profile. This replaces the earlier *proposed* universal Runner extraction action. Existing persistent Software installation baseline is 1 BW, subject to future card-specific exceptions, and installed Software is governed by RAM and Node-long Software lifecycle unless explicitly revised.

**Distinct extractor profiles:** Street-oriented, heavily augmented extractors may produce **zero payout for the first two turns** and then **a large payload at the end of turn three**. Corporate-inspired, cleaner extractors have a **more even payout curve**, earning value earlier and more steadily. This creates risk/reward differentiation through deck composition and time exposed to ICE. Runner archetypes express preferences rather than automatically imposing exclusivity (exclusivity itself not decided).

**Prior LOCKED ECON-002 remains:** Each ICE encounter has a finite maximum total CRED payout; whether that cap is visible to Runner is OPEN.

**OPEN:** Specific Extractor card examples/names, RAM costs, BW exceptions, exact yields and profiles, whether countdown is from installation or encounter turn, whether multiple Extractors can run simultaneously, effects of unload/reinstall and interrupted sequences, whether an extractor can pay after ICE PASS, and whether extracted CRED is banked immediately or upon surviving/passing. The previous 10/20/35 payout example is not universal and must not override card-defined payout curves.


## 49. SOFT-001 — Multi-subtype Software and extraction-powered defenses (2026-11-10)

**LOCKED — user explicitly approved:** A single Software card **may have multiple subtypes/capabilities**, e.g. ICEbreaker + Virus, Virus + Extractor, or other combinations. These classifications are **not mutually exclusive**. This is intended to support diverse deck builds, Runner playstyles, and Runner personalities. Software remains the umbrella card category, and existing installation/BW/RAM/lifecycle rules apply unless overridden by an approved card rule.

**USER-PROPOSED DESIGN EXAMPLE (not yet a finalized card):** A shield-like card can prevent **X CHAR** by **spending/burning CRED extracted during the previous turn**. This connects data extraction and defense, creating a choice between keeping CRED for Uplink Market purchases and consuming it for survival. Exact damage-to-CRED conversion, whether it can use only the previous turn's proceeds or any held CRED up to that amount, activation timing, BW/RAM, cap, and whether spent CRED is permanently deducted remain OPEN. Do not treat illustrative card name or stats as approved.

**Terminology caution:** Here “burning CRED” means spending currency, not the existing **BURNED card** state; keep mechanically distinct.


## 50. SOFT-002 — Instant CRED shield and hand retention concept (2026-11-10)

**LOCKED — user-confirmed CRED shield principles:** A shield-like **one-shot / instant Software card** is played from hand, its effect resolves immediately, and it **goes to the discard pile** rather than remaining installed. It protects against a limited amount of **CHAR** by **permanently spending CRED the Runner has already earned**. The CRED cost is **variable**, and the card has a **protection/spending limit**. Its tactical weakness is hand availability: the card may not be in hand when protection is needed. This is a card/mechanic concept, not yet a named, fully balanced card. Precise conversion rate, cap, activation window, BW play cost, and interpretation of “CRED extracted previous turn” are OPEN. Instant Software is distinct from persistent Software and does not automatically follow persistent installation lifecycle.

**NEW DESIGN TOPIC — user requests thematic hand-retention abilities:** Runner should be able to gain abilities to **retain selected cards in hand across turns** despite normal end-turn hand discard. Exact rules, source of ability, hand-size interaction, duration, and limits OPEN.

**ASSISTANT PROPOSAL, NOT LOCKED:** Keyword **CACHE X** for retaining up to X cards at turn end. Cards remain in hand, not installed; whether caching consumes RAM is OPEN. This is thematically based on computer caching, and could help retain a CRED-powered shield until needed. Do not treat the keyword or details as approved until user explicitly agrees.


## 51. SOFT-003 — CACHE keyword (LOCKED, 2026-11-10)

**Explicit user approval:** **CACHE** is REDLINE's official keyword for **retaining selected cards in the Runner's hand across the normal end-of-turn hand discard**. The word functions as both a noun and a verb: e.g. **“CACHE that card”** means designate that card to remain in hand. **CACHED** describes a card currently retained. **CACHE X** is the natural parameterized form for retaining up to X cards (e.g. CACHE 1, CACHE 2), subject to final wording. The keyword is intentionally evocative of computer caching and multiple everyday meanings.

**Core distinction:** CACHED cards **stay in hand**, rather than being installed persistent Software in the Rig. Their retention is an exception to the normal end-of-turn hand discard.

**OPEN:** Which abilities/cards grant CACHE, selection timing, retention duration, whether CACHED cards count toward the next turn's DRAW/hand size, any total CACHE limit, whether cards can remain CACHED over multiple turns, and special treatment at ICE-layer/Node boundaries. Do not infer these details as locked.


## 52. SOFT-004 — CACHE additive to DRAW (LOCKED, 2026-11-10)

**Explicit user decision: Option B.** At the start of a turn, the Runner **retains all CACHED cards in hand and draws their full normal DRAW quantity in addition**. CACHED cards do **not** count against or reduce the number of cards drawn. Example: **2 CACHED cards + DRAW 5 = 7 cards in hand** at turn start. VOID and other DRAW modifiers still affect the number of newly drawn cards according to the established DRAW formula; they do not retroactively discard or offset CACHED cards.

**OPEN:** Maximum total hand size, whether a cached card may be held indefinitely or must be released after a turn, selection and duration of CACHE effects, and boundaries between ICE layers/Nodes. This decision does not by itself resolve those issues.


## 53. SOFT-005 — Indefinite CACHE retention (LOCKED, 2026-11-10)

**Explicit user decision:** A CACHED card may be **retained indefinitely across turns** rather than expiring after one additional turn, provided the supporting CACHE ability remains active. The card remains in the Runner's hand until played or otherwise removed by a game effect. This extends SOFT-003 and SOFT-004: CACHED cards are retained in hand and do not reduce normal DRAW, even across multiple successive turns.

**OPEN:** What happens when the granting CACHE ability is lost or capacity falls below cards currently CACHED; whether there is a global hand size limit; whether a CACHED card may be carried across sequential ICE layers (which normally discard hand upon PASS); whether CACHE persists between Nodes (which normally reset deck/hand); and the exact source and limits of CACHE abilities. Do not silently override existing ICE PASS or Node cleanup rules.


## 54. SOFT-006 — CACHE survives ICE layers, ends at Node boundary (LOCKED, 2026-11-10)

**Explicit user decision:** CACHED cards **survive across sequential ICE layers within the same Node**, including the PASS transition that normally discards unplayed cards. CACHE retention lasts **until the end of the Node**, not across Node boundaries. At Node end, any remaining CACHED cards are returned to the Runner's deck as part of normal ICE Node cleanup, and the CACHE state ends. Thus the previously locked indefinite retention (SOFT-005) is **indefinite within the Node**, subject to maintaining the relevant CACHE ability, not indefinite across Nodes.

**Other established rules remain:** Non-CACHED unplayed hand cards are discarded on ICE PASS; next ICE layer begins with a fresh normal DRAW, with any retained CACHED cards additive to that draw (SOFT-004). The current Node-end cleanup and next ICE Node reshuffle rules remain in force.

**OPEN:** Effects of losing CACHE capacity during a Node, overall hand limit, and precise rules for the source/activation of CACHE.


## 55. SOFT-007 — CACHE loss and corporate countermeasures (LOCKED, 2026-11-10)

**Explicit user decision:** If a Runner loses the ability/effect supporting CACHE, affected formerly CACHED cards **remain in hand for the rest of the current turn**, playable as ordinary hand cards, and **are discarded at the normal end-of-turn discard step** if still unplayed. They are **not immediately discarded** merely because CACHE retention is lost. This resolves the SOFT-005/006 capacity-loss timing question at least for complete loss of CACHE support; precise handling of partial capacity reduction remains OPEN.

**Explicitly supported defensive design space:** ICE and corporate defenses may (a) **eliminate/discard all currently CACHED cards in hand**, or (b) **remove CACHE retention from cards in hand**, causing normal end-of-turn discard rather than immediate discard. These are distinct types of effects and can appear as ICE subroutines or other corporate defenses.

**Terminology:** “Invalidate CACHE” (remove retention) and “Flush CACHE” (immediately discard cached cards) are illustrative labels only, **not locked keywords**. CACHE may be an applied retention status; stripping it should not automatically erase printed card text. Exact effect wording, timing, and counterplay are OPEN.


## 56. SOFT-008 — Individual and mass CACHE targeting (LOCKED, 2026-11-10)

**Explicit user approval:** ICE subroutines and corporate defenses may target **individual CACHED cards** or **all CACHED cards**, both for (a) **removing CACHE retention** and (b) **immediately discarding CACHED cards**. Thus four supported effect shapes are: single-card retention removal; all-card retention removal; single-card immediate discard; all-card immediate discard.

**Interaction with SOFT-007:** Removing CACHE retention does **not** immediately discard the affected card(s); they remain in hand and follow normal end-of-turn discard unless played. An effect explicitly ordering discard moves affected CACHED card(s) immediately to the discard pile. No new named keywords or targeting selection method are locked by this decision.


## 57. RULE-001 — Target chooses how to comply (LOCKED, 2026-11-10)

**Explicit user rule:** When a game effect requires its **target** to take an action or choose affected objects, **the target chooses how and what to do to satisfy the requirement**, within the restrictions of the effect. The target does not gain the option to ignore a mandatory effect; it selects the eligible cards, counters, installed programs, etc., to fulfill it. This is a **general default targeting/selection rule**, not restricted to CACHE. Applies symmetrically to Runner and Corporation when each is the target.

**Examples:** If Runner must discard one CACHED card, Runner chooses which CACHED card. If Runner must remove CACHE from one card, Runner chooses which. If Corporation is required to PURGE Virus counters, Corporation chooses eligible counters. The existing SYN X rule (Runner chooses cards to discard) is consistent with this default.

**Exceptions:** An effect that explicitly names a particular target, defines a different chooser, or calls for random selection overrides this default. Do not assume the Corporation randomly selects affected CACHED cards absent such explicit wording. If insufficient eligible objects exist, follow the specific effect's instructions or a future general insufficiency rule (still OPEN).


## 58. RULE-002 — Fulfill as much as possible; independent effects still resolve (LOCKED, 2026-11-10)

**Explicit user decision:** When a mandatory effect instructs a target to perform an action and the target has fewer eligible objects/resources than requested, **perform as much of the instruction as possible**. An unfulfillable portion does **not** cause the whole card/effect to fail. **Subsequent effects still resolve**, unless an explicit rule or condition says otherwise.

**User's authoritative example:** A card reads **“When played: Discard a card. Gain X effect.”** If the Runner has **no other cards in hand** to discard, the Runner discards none and **still gains X**. If the Runner has an eligible card, they discard one (target chooses under RULE-001), then gain X. Likewise, “discard 3 CACHED cards” with only one CACHED card discards that one.

**OPEN design distinction:** Future effects may explicitly specify an **additional mandatory cost** or conditional **“if you do”** requirement to gate a benefit, but the exact templating and general cost-payment rules have not yet been approved. Do not retroactively interpret a normal “Discard 1. Gain X” instruction as such a cost.


## 59. RULE-003 — Instructions versus costs and conditional effects (LOCKED, 2026-11-10)

**Explicit user approval:** REDLINE formally distinguishes **instructions** from **costs**. Ordinary instructions are fulfilled **as much as possible** under RULE-002, without cancelling other independent effects. A **cost** must be **paid in full** to activate/receive the associated effect. A **conditional** such as **“If you do”** grants its contingent benefit only if the specified action was actually performed successfully. **Never infer a cost** from an ordinary instruction; cost/condition must be explicit in card text or an applicable rule.

**Examples:**
- **“Discard 1 card. Gain X.”** With no eligible card to discard, discard none; still gain X.
- **“Discard 1 card. If you do, gain X.”** With no eligible card to discard, do not gain X.
- **“Cost: Discard 1 card. Effect: Gain X.”** With no eligible card to discard, cannot pay the cost and therefore cannot activate the associated effect.

**Interaction:** RULE-001 still lets the target choose eligible objects when an effect requires a choice; RULE-002 governs partial fulfillment of instructions, but does **not** waive costs. Exact formatting/wording conventions may be refined later without changing this principle.


## 60. SOFT-009 — Instant Software is the default card lifecycle (LOCKED, 2026-11-10)

**Explicit user decision:** **Most cards in the Runner's deck are Instant Software.** Standard lifecycle: **play the card from hand → pay any applicable costs → perform its instructions → move the card to the discard pile.** Instructions/costs/conditions follow RULE-001, RULE-002 and RULE-003. Instant Software is played for an immediate effect; it is **not installed as persistent Software**, and therefore does not occupy persistent Rig RAM or remain active through the Node unless a specific card effect says otherwise.

**Important distinction:** Persistent Software installation has an established baseline cost of 1 BW (TAX-016). That **installation cost is not automatically applied to Instant Software**, which is played rather than installed. The universal/default BW **play cost** for Instant Software is still **OPEN**; card-specific costs may be printed. This section supersedes any earlier suggestion that all Instant Software necessarily costs 1 BW to play.

**OPEN:** Default instant-card BW play cost (including whether zero-cost cards exist), exact timing windows for instant cards including defensive responses, and special destination exceptions (e.g. BURNED).


## 61. SOFT-010 — Printed BW costs for Instant Software (LOCKED, 2026-11-10)

**Explicit user approval:** Every Instant Software card has its **own printed BW play cost**; **0 BW** is permitted. There is **no universal BW play cost** for Instant Software. A card may cost 0, 1, 2, or more BW as specified by its own design. The Runner must pay the card's BW cost to play it, subject to future explicit modifiers/waivers. After playing and resolving its instructions, it goes to the discard pile per SOFT-009 unless an explicit card effect specifies another destination.

**Distinct from persistent Software:** The established **1 BW installation cost** for persistent Software remains separate and unchanged. Instant Software is played, not installed; it does not consume persistent RAM merely by being played.

**OPEN:** Timing windows for playing Instant Software (including whether defensive reactions are possible during corporate response), any default maximum printed BW cost, and exceptions/discount effects.


## 62. SOFT-011 — Runner-turn-only card play; no reactive plays (LOCKED, 2026-11-10)

**Explicit user decision:** **All Runner cards must be played during the Runner's turn.** There are **no reactive card plays during the Corporation's turn** or during resolution of corporate/ICE subroutines. This includes Instant Software and defensive cards. The Runner must prepare defenses proactively before ending their turn.

**Distinction:** An effect established by a card already played during the Runner's turn may operate or resolve during the subsequent corporate response according to its card text; that is **not** playing a new card out of turn. CACHE retention preserves access to cards for later Runner turns but does not grant out-of-turn play. The previously discussed CRED-powered instant shield therefore must be played proactively if it is to defend against incoming CHAR; precise shield effect duration/trigger and CRED-spending timing remain OPEN.

**Supersedes:** The earlier assistant proposal to allow special reactive Instant Software during corporate response is rejected.


## 63. SOFT-012 — Default defensive protection duration (LOCKED, 2026-11-10)

**Explicit user approval:** A defensive card played during the Runner's turn normally provides its protection **through the immediately following Corporation response**. Any unused protection **expires at the end of that corporate response**. A card can **explicitly specify a longer duration**, overriding this default. This is a duration rule, not permission to play reactive cards: under SOFT-011, **all Runner cards must be played during the Runner's turn**.

**Example:** An Instant Software shield played during the Runner's turn says **“Prevent 3 CHAR.”** During the following corporate response it can prevent up to 3 CHAR; if only 1 CHAR is dealt, the unused 2 protection expires after that response. The shield card itself follows the normal play → resolve → discard lifecycle; its already-established protection may continue until the response ends.

**OPEN:** Exact stacking/consumption order of multiple protections, whether protection is shared across different damage instances by default (example above assumes a pool), and CRED-to-CHAR shield exchange rates.


## 64. SOFT-013 — Temporary effects expire at start of next Runner turn (LOCKED, 2026-11-10)

**Explicit user decision:** **At the beginning of each Runner turn, all unused temporary shields and effects end.** A defensive effect established during the Runner's turn remains available through the following Corporation response, but any unused portion expires **at the beginning of the next Runner turn**, rather than immediately at the end of the Corporation response.

**Clarification / precedence:** This **refines and supersedes SOFT-012's default expiration timestamp**. SOFT-012's proactive play requirement and protection through the Corporation response remain intact. Persistent installed Software, Hardware, and effects explicitly assigned longer durations continue under their own lifecycle/duration rules; this cleanup is for temporary shields and effects, not automatic removal of persistent Rig assets.

**Example:** Play “Prevent 3 CHAR” on Runner turn. The following corporate response deals 1 CHAR; 2 unused protection remains until the start of the next Runner turn, then expires.

**OPEN:** Whether multiple independent shield effects combine into one pool or remain separately tracked; exact ordering of start-of-turn cleanup relative to other start-of-turn triggers.


## 65. SOFT-014 — Independent defensive effects; cumulative CHAR prevention (LOCKED, 2026-11-10)

**Explicit user approval:** Multiple active shields/defensive effects remain **separate, individually tracked effects**, but their CHAR prevention **accumulates** against incoming CHAR. They are **not merged into a single effect or shield pool**. This allows card-specific modifiers, triggers, and interactions to affect one shield without modifying the others. Any unused temporary protection expires at the beginning of the next Runner turn per SOFT-013.

**User-provided design example (illustrative, not a finalized card):** A Hardware ability could read: **“The first defensive card you play each Runner turn prevents twice as much CHAR.”** Thus, a first defensive card with **Prevent 3 CHAR** instead prevents **6 CHAR**; a second card with **Prevent 2 CHAR** still prevents 2. Their separately tracked protections **accumulate to 8 total CHAR prevention**. The Hardware card's name and final wording are OPEN; this example establishes that a modifier may apply to an individual defensive card while total available prevention accumulates.

**OPEN:** When several separately tracked shields could prevent the same incoming CHAR, which shield is consumed first (Runner choice versus a fixed order); interactions with conditional shields.


## 66. SOFT-015 — Unified CHAR prevention pool (LOCKED, 2026-11-10)

**Explicit user correction:** All defensive cards and effects contribute their calculated CHAR prevention to **one shared numerical prevention pool**. Apply any modifiers to the individual card/effect's prevention amount **before** adding it to the pool. Once contributed, there are **no separately tracked shield values** and no choice of which shield absorbs incoming damage. Incoming CHAR is deducted from this **single prevention pool**; only any excess CHAR gets through as Integrity damage. Remaining unused temporary prevention expires at the **beginning of the next Runner turn** per SOFT-013.

**Example:** First defensive card prevents 3 CHAR, doubled by Hardware to 6; second prevents 2. Total prevention pool = 8. Incoming 5 CHAR consumes 5 pool points, leaving 3. No shield selection/consumption order exists.

**Precedence:** This **supersedes SOFT-014's assertion that shields remain separately tracked**. SOFT-014's concept of independently calculating card-specific prevention modifiers and cumulative protection remains valid, but the resulting prevention is pooled into **one value**.


## 67. DMG-001 — Three distinct damage types and type-specific protection (LOCKED, 2026-11-10)

**Explicit user approval:** REDLINE's **three damage types are distinct** and defenses do not cross-protect by default:
- **CHAR X:** Reduces Runner Integrity by X; prevented by the shared **CHAR prevention pool** under SOFT-015.
- **SYN X:** Runner chooses and discards X cards from their current hand; this does not reduce Integrity. Requires an effect explicitly protecting against SYN to prevent it.
- **VOID X:** Applies persistent DRAW reduction (subject to minimum DRAW rule). Requires an effect explicitly protecting against VOID to prevent it.

A card may explicitly prevent multiple named damage types, but protection against one does **not** implicitly apply to another. The unified CHAR prevention pool is **CHAR-only**; it does not prevent SYN or VOID.

**Example:** Runner has 6 CHAR prevention and receives CHAR 4 plus SYN 2. Four prevention is spent, leaving 2 in the CHAR pool; SYN 2 separately requires the Runner to choose and discard up to 2 eligible cards under RULE-001 and RULE-002.

**OPEN:** Exact resource/pool mechanics for SYN- or VOID-specific prevention, if such cards are introduced.


## 68. DMG-002 — Three independent damage prevention pools (LOCKED, 2026-11-10)

**Explicit user approval:** REDLINE has **three independent numerical prevention pools**, one each for **CHAR**, **SYN**, and **VOID**. Each defensive card/effect contributes its calculated prevention to the pool(s) for the **damage type(s) explicitly named** in its instructions. Contributions from multiple sources **sum within each matching pool**; pools are never interchangeable or cross-applied. On incoming damage of type X, deduct prevention from **that type's pool only**; any excess damage of that type resolves normally under its own rules. No individual shield consumption choice exists after contributions have entered a pool.

**Duration:** Unused **temporary** prevention in each of the three pools expires at the **beginning of the next Runner turn**, following SOFT-013. Explicit longer-duration effects can follow their printed duration.

**Example:** Runner has CHAR prevention 4, SYN prevention 2, VOID prevention 1. Incoming CHAR 3, SYN 3, VOID 2 leaves CHAR prevention 1; SYN prevention 0 with SYN 1 resolved (choose and discard 1 eligible card); VOID prevention 0 with VOID 1 applied.

**Relationship to earlier rules:** Extends SOFT-015's single pooled-value approach to each distinct damage type without combining types, and completes DMG-001's previously OPEN question of whether SYN and VOID have prevention pools.


## 69. GHOST-001 — Node-based Origin Ghostware prevention (LOCKED, 2026-11-10)

**Explicit user approval:** Runner **Origin Ghostware** may grant a fixed quantity of damage-type-specific prevention **once per Node**, supporting distinct Runner archetypes. **Illustrative synthetic body armor archetype:** At the **beginning of each Node**, grant **6 CHAR prevention**. This reserve remains available **across Runner turns and successive ICE encounters within the Node**, and incoming CHAR consumes it normally. At the **next Node**, the Origin Ghostware grants a fresh **6 CHAR prevention**. The armor's name, balance and final card presentation remain illustrative rather than finalized.

**Duration and accounting:** Node-long Origin Ghostware prevention **does not expire at the beginning of the next Runner turn** under SOFT-013; that expiration applies to temporary prevention. For correct accounting alongside DMG-002's shared per-type prevention totals, the game must retain sufficient **duration/source bookkeeping** to expire temporary contributions while preserving any unspent Node-long reserve; this is **not** a return to player-selected shield consumption. Exact internal allocation between temporary and Node-long prevention when both coexist remains **OPEN**.

**Archetype implication:** Other Runners may specialize in SYN or VOID prevention using different Origin Ghostware; these are design possibilities, not locked starting abilities.


## 70. RULE-004 — Temporary resources spent before ongoing resources (LOCKED, 2026-11-10)

**Explicit user decision — universal game rule:** Whenever multiple eligible interchangeable resources, prevention reserves, or effects can satisfy the same expenditure, cost, or requirement, **temporary resources are consumed first, before permanent or ongoing resources**. This is a general REDLINE priority rule, not merely a shield rule. Apply automatically without requiring the Runner to select individual resources. Explicit card text or a more specific rule may override the default priority.

**CHAR prevention example:** Runner has 3 temporary CHAR prevention plus 6 Node-long CHAR prevention from Origin Ghostware, for a displayed total of 9. Incoming CHAR 4 consumes the 3 temporary first, then 1 Node-long, leaving 5 Node-long CHAR prevention and 0 temporary. This is consistent with the single displayed pool per damage type (DMG-002) while preserving behind-the-scenes duration bookkeeping (GHOST-001).

**Scope:** The priority applies only when the candidate resources/effects are **eligible and interchangeable for the same requirement**; it does not make a CHAR reserve eligible to pay SYN/VOID, bypass a printed cost, or allow an ineligible effect to be spent. Exact priority among multiple resources with equal duration remains OPEN.


## 71. RULE-005 — Earliest-expiring eligible resources consumed first (LOCKED, 2026-11-10)

**Explicit user approval:** Extend RULE-004 to a general priority based on **relative remaining duration**. When two or more **eligible, interchangeable** resources, prevention reserves, or effects could satisfy the same cost, requirement, or expenditure, the game **automatically consumes the one that expires soonest first**. A resource that is more temporary has higher consumption priority than one that lasts longer. This applies beyond damage prevention, subject to eligibility and explicit card/rule overrides.

**Illustration:** A shield expiring at the beginning of the next Runner turn is spent before Node-long armor; Node-long armor is spent before an otherwise interchangeable reserve with an even longer duration or no expiration. The interface can present the combined available value while the engine tracks source/duration for priority and expiration.

**Relationship:** RULE-005 refines RULE-004's temporary-before-ongoing rule: priority is determined by **earliest expiration**, not merely a binary temporary/permanent distinction. The three damage-type pools remain distinct (DMG-002). No player selection is required.

**OPEN:** Tie-breaking between eligible resources with identical expiration times.


## 72. RULE-006 — Equal-expiration resource priority (LOCKED, 2026-11-10)

**Explicit user approval:** When two or more eligible, interchangeable resources or effects have **identical expiration timing** and are **mechanically equivalent for the expenditure**, the game may consume either automatically, **without prompting the Runner to choose**. If individual source effects make the distinction **mechanically meaningful**, preserve and resolve that distinction rather than silently treating the resources as equivalent. An explicit card or more-specific rule may govern such a case.

**Priority relationship:** If expiration times differ, RULE-005 still requires consuming the **earliest-expiring eligible** resource first. RULE-004 establishes the overarching temporary-before-ongoing principle. This tie rule does not allow ineligible resources or cross-type prevention.

**OPEN:** A deterministic engine tie-breaker for mechanically distinct same-expiration resources if no specific card text resolves the conflict.


## 73. RULE-007 — Prevention multipliers apply to specified existing pools; encourage stacking (LOCKED, 2026-11-10)

**Explicit user decision:** Card effects **stacking and synergizing is encouraged** as a central deckbuilding feature. Do **not** impose an implicit restriction that multipliers can only affect newly generated prevention. Interpret prevention multiplier wording by its **scope**:
- **“Double your prevention”** doubles **all three current prevention pools**: CHAR, SYN, and VOID.
- **“Double your CHAR prevention”** doubles the **entire current CHAR prevention pool**, including contributions already accumulated from multiple cards. Example: three cards collectively provide **15 CHAR prevention**; doubling CHAR prevention produces **30 CHAR prevention**.
- **“The first defensive card you play each Runner turn prevents twice as much CHAR”** instead modifies **that individual card's contribution**, not the entire accumulated pool, as illustrated under SOFT-014.

**Design intent:** Encourage players to discover powerful interactions among multiple cards and Hardware/Ghostware; stacking effects should be supported, not automatically suppressed as exponential synergy. Wording determines whether a multiplier applies to a single contribution or an already-accumulated pool.

**Accounting:** The engine must preserve source/duration bookkeeping necessary for RULE-004/005/006 and GHOST-001 even when a multiplier affects a displayed pooled total.

**OPEN:** Precise ordering and rounding for multiple simultaneous multipliers, and how pool-wide multipliers distribute across contributions of different expiration durations. Do not assume repeated passive reapplication every frame/turn; timing must be specified.


## 74. RULE-008 — Prevention multipliers compound sequentially (LOCKED, 2026-11-10)

**Explicit user approval:** Multiple effects that multiply a prevention pool **compound sequentially against the pool's current value**, not additively and not just against the initial contributions. For example, if the Runner has **15 CHAR prevention**, resolving **“Double your CHAR prevention”** twice yields **15 → 30 → 60**. Two doublings yield **×4**; three yield **×8**, provided each multiplier actually resolves.

**Design intent:** Powerful, potentially exponential stacking synergies are deliberate and encouraged. The exact wording of each card determines whether its multiplier affects a **whole pool** or an **individual card's contribution** (RULE-007).

**Still OPEN:** Ordering of simultaneous triggers/multipliers, mixed-duration contribution bookkeeping when a whole pool is multiplied, and any rounding rules for noninteger modifiers. This rule locks sequential compounding, not an unspecified trigger order.


## 75. RULE-009 — Snapshot-based prevention pool multipliers preserve duration (LOCKED, 2026-11-10)

**Explicit user approval:** A card saying **“Double your [type] prevention”** doubles the **prevention amount currently present when the card's effect resolves**. It is a **one-time snapshot effect**, not an ongoing multiplier applied automatically to prevention granted afterward. When the current pool contains contributions with different durations, the doubling **preserves those durations proportionally** by doubling each existing contribution's remaining amount before recombining the displayed pool.

**Example:** 6 Node-long CHAR prevention from Ghostware + 4 temporary CHAR prevention from Software = 10 total. A doubling effect resolves, yielding **12 Node-long + 8 temporary = 20 total**. The temporary 8 is consumed before the Node-long 12 under RULE-004/005. If another card later adds 3 CHAR prevention, total becomes **23**, not 26. A second subsequent doubling resolves against the then-current **23**, producing **46** (RULE-008), preserving each contribution's duration.

**Scope:** “Double your prevention” applies this snapshot operation to each of CHAR, SYN, and VOID; a type-specific multiplier affects only its named pool (RULE-007). No retroactive multiplication of already-spent prevention.


## 76. RULE-010 — Resolve card instructions in printed order (LOCKED, 2026-11-10)

**Explicit user approval:** A card's instructions resolve **sequentially in their printed order, top to bottom**, unless the card or a more-specific rule explicitly says otherwise. Earlier instructions change game state before later instructions resolve. This works with RULE-002 (fulfill as much as possible), RULE-003 (distinguish costs, instructions, and conditional rewards), and RULE-009 (snapshot multipliers evaluate the current pool at the moment of resolution). Required costs are paid before their associated effects resolve.

**Example:** Starting with 10 CHAR prevention, **“Gain 5 CHAR prevention. Double your CHAR prevention.”** resolves **10 → 15 → 30**. The reverse wording, **“Double your CHAR prevention. Gain 5 CHAR prevention.”**, resolves **10 → 20 → 25**. Printed order therefore matters for synergies and is intentional.

**OPEN:** Ordering of multiple simultaneous triggers from different cards/effects, distinct from instructions printed sequentially on one card.


## 77. RULE-011 — Runner orders simultaneous Runner-controlled triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When **multiple Runner-controlled effects trigger simultaneously**, the **Runner chooses their resolution order**. Resolve each chosen trigger's effect **completely** before moving to the next; within each effect, printed instructions still resolve in order under RULE-010. This deliberately supports strategic sequencing and powerful card synergies.

**Example:** Runner currently has **5 CHAR prevention**. Two installed Software effects trigger together on playing a defensive card: one **grants 3 CHAR prevention**, the other **doubles current CHAR prevention**. Runner may resolve **+3 first, then double** to produce **(5 + 3) × 2 = 16**, instead of **(5 × 2) + 3 = 13**.

**Scope:** This rule specifies the ordering of **simultaneous Runner-controlled triggers**. It does not yet specify ordering of simultaneous Corporation-controlled triggers or cross-controller triggers, which remain OPEN.


## 78. RULE-012 — Corporation orders simultaneous Corporation-controlled triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When **multiple Corporation-controlled effects trigger simultaneously**, the **Corporation determines their resolution order**. Each chosen triggered effect resolves **completely** before the next begins; instructions within each effect follow printed order under RULE-010. This mirrors RULE-011 for Runner-controlled simultaneous triggers.

**Scope:** The rule concerns **ordering of already-triggered Corporation effects**, not playing reactive cards during the Corporation turn; SOFT-011's restriction on Runner card play remains unchanged. The order of simultaneous triggers **controlled by different sides** remains OPEN.


## 79. RULE-013 — Active side resolves opposing simultaneous triggers first (LOCKED, 2026-11-10)

**Explicit user approval:** When Runner-controlled and Corporation-controlled effects trigger at the same moment, **the active side's triggered effects resolve first**:
- **During the Runner's turn:** resolve Runner-controlled triggers first, then Corporation-controlled triggers.
- **During the Corporation's turn:** resolve Corporation-controlled triggers first, then Runner-controlled triggers.

Within each side's group of simultaneous triggers, that side chooses their order (RULE-011 for Runner, RULE-012 for Corporation). Each trigger resolves completely before the next, with instructions in printed order (RULE-010). This ordering rule does **not** permit out-of-turn card plays; SOFT-011 remains in force.

**OPEN:** Exact handling of new triggers generated while another trigger is resolving (nested triggers/queue priority), if relevant.


## 80. RULE-014 — Chained triggers queue until current effect finishes (LOCKED, 2026-11-10)

**Explicit user approval:** If resolving an effect causes another effect to trigger, the newly triggered effect **does not interrupt** the currently resolving effect. Instead, it enters a **pending trigger queue**. Finish **all instructions of the current effect in printed order** (RULE-010), then resolve pending triggers according to existing controller and active-side priority rules (RULE-011/012/013). Each triggered effect likewise resolves fully before proceeding to the next. No reactive Runner card play is permitted during the Corporation turn (SOFT-011).

**Illustration:** Starting at 0 CHAR prevention, a played card says **“Gain 3 CHAR prevention. Double your CHAR prevention.”** Installed Software triggers on gaining CHAR prevention and grants +2 CHAR prevention. The +2 trigger waits while the played card resolves: **0 → 3 → 6**, then the queued +2 resolves to **8**. It does not interrupt between gaining 3 and doubling, which would have produced 10.

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

**Example:** If a loop generated **10 CHAR prevention** before being detected, that 10 remains; the nonterminating cycle is stopped; unrelated pending triggers continue to resolve.

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

**OPEN:** Precise treatment of per-turn limits across Runner versus Corporation turns when text says only “turn”; timing of counter reset at Node boundaries; whether copies of the same named card track limits independently (unless a card specifies otherwise). Do not assume these details are locked.


## 87. RULE-021 — Independent copies except explicit shared event/outcome limits (LOCKED, 2026-11-10)

**Explicit user approval with qualification:** Multiple installed copies of the same Software card **normally trigger independently**, and each copy tracks its own card-specific trigger frequency limit (RULE-020). For example, two installed copies each reading “Once per turn: When you play a defensive card, gain 2 CHAR prevention” each trigger once, yielding **4 CHAR prevention** in total.

**Explicit shared-limit exception:** If wording establishes an explicit limit on the **same event or outcome**, duplicating that wording must not compound beyond that limit. User's canonical example: two copies of “The first card you play is played twice” mean the first card is **played twice total**, **not twice and then twice more** (not four plays). A second copy cannot apply an additional doubling to that already doubled first play. Interpret “played twice” as an explicitly bounded outcome in this example, not as an unconstrained multiplicative stacking effect.

**Scope:** Do not infer shared caps where card text does not establish them; independent ordinary triggers and intended stacking remain valid. Specific text overrides generic stacking rules. **OPEN:** Exact card text conventions for expressing shared event/outcome caps versus stacking multipliers, and how repeated-play effects interact with other “when played” triggers.


## 88. RULE-022 — Replayed cards resolve each play independently (LOCKED, 2026-11-10)

**Explicit user approval:** When a card-play effect causes a card to be **played multiple times**, each actual play **resolves that card's printed instructions and applicable “when played” effects independently**, subject to explicit frequency restrictions and the existing trigger queue. Example: “The first card you play each turn is played twice” applied to “When played, gain 3 CHAR prevention” grants **6 CHAR prevention total**, from two separate plays.

**Compatibility:** The explicit “played twice” outcome limit remains in force under RULE-021: additional copies of the same replay-granting effect do **not** turn those two plays into four. Other applicable “when played” triggers can occur for each actual play, unless their own explicit limits (RULE-020) prevent them.

**OPEN:** Whether a replay pays the card's BW cost again, whether it counts as a new physical card leaving hand, and the exact timing of replay relative to other queued triggers. No answer is implied by this rule.


## 89. RULE-023 — Replayed cards pay BW only once (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect causes a card to be played more than once, **pay that card's BW cost only for its original play**. Any additional plays granted by the replay effect resolve the card's instructions without paying its BW cost again. For example, a **2 BW** card played twice through a replay effect costs **2 BW total, not 4 BW**, while both plays resolve independently under RULE-022.

**Compatibility:** An explicit “played twice” effect remains capped at two total plays despite duplicate sources (RULE-021). Explicit card-specific trigger-frequency limits still apply (RULE-020).

**OPEN:** Whether any **non-BW costs** must be paid again on replay, and how card-specific costs and “If you do” conditions interact with replay. Do not assume free non-BW costs.


## 90. RULE-024 — Non-BW costs paid for every replayed resolution (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect replays a card, the card's **BW cost is paid only for the original play** (RULE-023), but **each replayed resolution must independently pay any other explicit costs in full** (RULE-003). If the non-BW cost for an additional resolution cannot be paid, that resolution does not occur; any earlier completed resolutions remain valid.

**Example:** “Cost: Discard 1 card. Effect: Gain 5 CHAR prevention.” Played twice via replay: discard one card for the original resolution and another card for the second; if both are paid, gain **10 CHAR prevention total**. If the second discard cannot be paid, only the first resolution's 5 prevention is gained.

**Compatibility:** Explicit card-level limits (RULE-020), shared outcome limits (RULE-021), and the trigger queue (RULE-014/015) still apply. **OPEN:** Exact replay timing and whether an unpaid replay counts for play-trigger frequency or “first card played” bookkeeping.


## 91. RULE-025 — Uninterrupted replay sequence before queued triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect causes a card to be played multiple times, resolve the **entire replay sequence consecutively**, without interrupting between plays to resolve other pending triggered effects. Finish the first play completely, then the second play (and any additional plays permitted by explicit text); triggers generated during any of these plays are **enqueued** and resolve afterward according to the established FIFO ordering (RULE-014/015). This treats the granted sequence as one uninterrupted replay operation for trigger-processing purposes, while each play still independently resolves the card's instructions (RULE-022).

**Example:** A card grants 3 CHAR prevention when played, and an installed Software triggers on gaining CHAR prevention. If the card is played twice, the two plays first grant **6 CHAR prevention** total; the triggered Software effects then resolve in queue order.

**Costs:** The original BW cost is paid only once (RULE-023); any explicit non-BW costs are independently required for each play (RULE-024). If a later replay's non-BW cost cannot be paid, that resolution fails without reversing earlier completed plays. Explicit shared “played twice” limits remain in force (RULE-021).

**OPEN:** Whether triggers already pending *before* a replay operation began can be delayed by a replay generated during a queued effect; precise event bookkeeping for unsuccessful replay attempts. Do not silently infer these edge cases.


## 92. RULE-026 — Replays do not reset explicit trigger-frequency limits (LOCKED, 2026-11-10)

**Explicit user approval:** Replaying a card does **not** reset or bypass an explicit frequency restriction printed on that card or ability, such as **“Once per turn.”** Each replay is still a separate play for other applicable effects (RULE-022), but an ability whose per-turn allowance has already been used does not activate again merely because its card is replayed.

**Canonical example:** “Once per turn: When played, gain 5 CHAR prevention.” If an effect causes this card to be played twice during the same turn, the limited ability activates **once total**, granting **5 CHAR prevention**, not 10.

**Compatibility:** RULE-020 (explicit per-card limits), RULE-021 (independent copies except explicit shared outcome limits), RULE-023/024 (replay costs), and RULE-025 (uninterrupted replay sequence) continue to apply. This does not introduce a universal trigger cap.

**OPEN:** Whether failed or unpaid replay attempts count as plays for frequency-limit bookkeeping; exact reset timing of limits phrased only as “per turn.”


## 93. RULE-027 — Per-turn trigger limits reset at every side's turn start (LOCKED, 2026-11-10)

**Explicit user approval:** An ability limited to **“once per turn”** (or another explicit **per-turn** frequency) refreshes its allowance at the **start of every turn**, including **both Runner turns and Corporation turns**. A persistent ability may therefore trigger once on the Runner turn and once on the following Corporation turn, provided the relevant trigger condition occurs in each turn.

**Example:** An installed defensive Software with a “once per turn” trigger can activate on the Runner turn and again on the Corporation turn after its allowance resets. This does **not** permit the Runner to play cards during the Corporation turn; existing persistent effects can trigger automatically (SOFT-011).

**Compatibility:** Explicit frequency restrictions continue to apply per ability (RULE-020), independent copies follow RULE-021, and replay does not reset a used allowance within the same turn (RULE-026). **OPEN:** Text specifying “once during your turn,” “once during the Runner's turn,” or other narrower windows follows its explicit wording; exact turn-boundary event ordering relative to start-of-turn triggers is not yet defined.


## 94. RULE-028 — Reset per-turn allowances before start-of-turn triggers (LOCKED, 2026-11-10)

**Explicit user approval:** At the beginning of **every Runner and Corporation turn**, first **reset all applicable per-turn trigger-frequency allowances** (RULE-027), and **then process abilities triggered at the start of that turn**. Start-of-turn abilities therefore use their freshly refreshed allowance, rather than being blocked by uses during the previous turn.

**Example:** An ability reading “Once per turn: At the start of a turn, [effect]” is eligible to trigger at the beginning of each turn after its allowance refreshes, subject to its other conditions and normal trigger ordering/queue rules.

**Compatibility:** This does not allow out-of-turn Runner card play (SOFT-011); it concerns triggered abilities already in effect. **OPEN:** Relative ordering among multiple start-of-turn triggers follows existing controller/active-side rules (RULE-011/012/013), but timing relative to other start-of-turn housekeeping such as BW refresh, DRAW, or expiration of temporary prevention requires separate decisions.


## 95. RULE-029 — Temporary expiration before start-of-turn triggers (LOCKED, 2026-11-10)

**Explicit user approval:** At the beginning of the Runner turn, **expire any temporary effects whose duration ends at that turn boundary before resolving start-of-turn triggered abilities**. This includes unused temporary prevention expiring at the start of the next Runner turn under SOFT-013 and DMG-002. Such expired prevention is unavailable for start-of-turn doubling or other effects. Persistent and Node-long prevention remain governed by their distinct durations.

**Established start-of-turn ordering:** (1) Reset applicable per-turn trigger limits (RULE-028); (2) remove effects scheduled to expire at this turn start; (3) resolve start-of-turn triggered abilities using the resulting game state.

**Example:** Runner ends the previous turn with 8 temporary CHAR prevention scheduled to expire at the next Runner turn start. Those 8 expire before a start-of-turn ability doubles current CHAR prevention, so they are not doubled.

**OPEN:** Exact placement of BW refresh, DRAW, Node-long prevention refresh, and other turn-start housekeeping relative to these steps. Do not infer their order from this rule.


## 96. RULE-030 — Refresh BW before Runner start-of-turn triggered abilities (LOCKED, 2026-11-10)

**Explicit user approval:** At the beginning of each **Runner turn**, refresh BW to the Runner's **full currently available amount**, including applicable modifiers to the baseline **4 BW**, **before** resolving any start-of-turn triggered abilities. Start-of-turn abilities that spend or modify BW therefore operate on freshly refreshed BW rather than the previous turn's remainder.

**Established Runner turn-start order:** (1) reset applicable per-turn trigger-frequency allowances (RULE-028); (2) expire temporary effects scheduled to end at that Runner turn start (RULE-029); (3) refresh BW to its full currently available amount; (4) resolve start-of-turn triggered abilities in the established priority/queue order (RULE-011 through RULE-015).

**Example:** Runner ended the previous turn at 0 BW and has a current full available BW amount of 4. At the next Runner turn start, BW becomes **4** before start-of-turn abilities resolve.

**OPEN:** Timing of normal DRAW and other turn-start housekeeping relative to these steps; how effects that alter maximum BW during start-of-turn resolution update available BW.


## 97. RULE-031 — Normal DRAW after start-of-turn abilities (LOCKED, 2026-11-10)

**Explicit user approval:** At the start of each Runner turn, the Runner's **normal starting-hand DRAW occurs after start-of-turn triggered abilities and their queued effects have finished resolving**. This allows any start-of-turn abilities that modify DRAW to affect the number of cards drawn on that same turn.

**Established Runner turn-start sequence:** (1) reset applicable per-turn trigger-frequency allowances (RULE-028); (2) expire temporary effects scheduled to end at that Runner turn start (RULE-029); (3) refresh BW to its full currently available amount (RULE-030); (4) resolve start-of-turn abilities and their queued triggers in established order; (5) calculate DRAW including VOID and other applicable modifiers, observing the minimum DRAW of 1; (6) draw the normal starting hand.

**Example:** Base/current DRAW is 5; a start-of-turn ability grants +2 DRAW. Once the ability resolves, the Runner draws **7 cards** that turn.

**Compatibility:** CACHED cards remain additive to normal DRAW (SOFT-004). **OPEN:** Exact timing and handling of any effects that trigger *on drawing* or *after drawing*, and deck exhaustion/reshuffle behavior during normal DRAW.


## 98. RULE-032 — Complete normal DRAW before resolving draw-generated triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When the Runner performs the **normal start-of-turn DRAW**, draw **all cards in that DRAW operation uninterrupted** before resolving any triggered effects generated by drawing those cards. Enqueue the resulting triggers and resolve them afterward according to established FIFO queue ordering (RULE-014/015). Individual card-draw events can each generate a trigger, but the triggers do not interrupt the ongoing normal DRAW operation.

**Canonical example:** An installed Software says “Whenever you draw a card, gain 1 CHAR prevention.” With normal DRAW **5**, the Runner first draws **all 5 cards**, then resolves **five draw-generated triggers**, gaining **5 CHAR prevention total** (assuming no other modifiers or limits).

**Compatibility:** Normal DRAW occurs after start-of-turn abilities (RULE-031). Explicit per-card trigger frequency limits (RULE-020/026) still apply. **OPEN:** Whether other multi-card draw effects beyond the normal DRAW use the same uninterrupted batching convention; exact timing of draw-replacement effects, if introduced.


## 99. RULE-033 — Uninterrupted resolution of all multi-card draw effects (LOCKED, 2026-11-10)

**Explicit user approval:** Extend RULE-032 beyond normal start-of-turn DRAW: **every effect instructing a player to draw multiple cards completes its full draw operation before any triggers generated by those draws resolve**. Individual cards drawn can generate their own triggers, which enter the pending queue and resolve afterward under the existing FIFO rules (RULE-014/015). Applies to normal DRAW, Instant Software “Draw X cards,” and other multi-card draw effects.

**Example:** An Instant Software says “Draw 3 cards,” while an installed Software says “Whenever you draw a card, gain 1 CHAR prevention.” Draw **all 3 cards first**, then resolve the **three** draw-generated triggers, gaining **3 CHAR prevention** absent other modifiers or limits.

**Compatibility:** Explicit trigger-frequency limits (RULE-020/026) still constrain the number of activations. Effects resolve in printed order (RULE-010), so uninterrupted drawing applies to the specific multi-card draw instruction, not automatically to all instructions on a card.

**OPEN:** Replacement/prevention effects that alter the actual number of cards drawn, and handling of deck exhaustion during multi-card draws.


## 100. RULE-034 — Automatically reshuffle discard pile when draw pile empties (LOCKED, 2026-11-10)

**Explicit user approval:** When resolving a draw instruction and the **draw pile runs out**, automatically **shuffle the discard pile into a new draw pile**, then continue drawing until the instructed number of cards has been drawn or no eligible cards remain. This can occur partway through a multi-card draw. Do not terminate an otherwise fulfillable draw simply because the original draw pile is exhausted.

**Canonical example:** “Draw 3 cards” with **1 card** in the draw pile and **8 cards** in the discard pile: draw the remaining card; shuffle the eight discarded cards into a new draw pile; draw two more cards. Draw-generated triggers wait until the full multi-card draw operation completes (RULE-032/033), then resolve in FIFO order (RULE-014/015).

**No available cards:** If both draw and discard piles have no eligible cards, draw only as many as possible; the unfulfillable remainder is skipped under RULE-002. Any independent subsequent effects still resolve according to their text and existing rules.

**OPEN:** Whether any special card states or restrictions exclude specific cards from reshuffling; timing of shuffle-triggered abilities, if introduced. No additional penalties for an empty draw pile are established by this rule.


## 101. RULE-035 — Reshuffle-generated triggers wait until draw completes (LOCKED, 2026-11-10)

**Explicit user approval:** If the discard pile is automatically shuffled into the draw pile **during an ongoing draw operation** (RULE-034), the **reshuffle itself occurs immediately** to make further drawing possible, but any **triggered abilities generated by that reshuffle are queued and do not resolve until the entire draw operation finishes**. Then process pending triggers under FIFO ordering (RULE-014/015). This extends the uninterrupted draw behavior of RULE-032/033 to shuffle-generated triggers.

**Example:** An installed Software says “Whenever your discard pile is shuffled into your draw pile, gain 2 CHAR prevention.” During “Draw 3 cards,” only one card remains in the draw pile: draw that card, shuffle the discard pile to replenish the draw pile, enqueue the shuffle trigger, draw the remaining two cards, then resolve queued effects. The reshuffle-triggered Software grants **2 CHAR prevention** afterward.

**Compatibility:** Any card-draw triggers generated during the same draw operation also wait until it completes; FIFO ordering follows the order in which triggers entered the queue, subject to simultaneous-trigger ordering rules (RULE-011/012/013). Explicit trigger frequency limits still apply (RULE-020/026).

**OPEN:** Whether the act of shuffling itself can modify the number of cards still to draw via replacement effects, if such effects are introduced.


## 102. RULE-036 — Each actual reshuffle generates its own trigger (LOCKED, 2026-11-10)

**Explicit user approval:** When a draw operation causes **multiple actual discard-pile reshuffles**, each reshuffle is a **separate event** and independently generates any applicable “whenever you reshuffle” triggers. All reshuffle-generated triggers **wait until the full draw operation finishes** (RULE-035), then resolve according to the FIFO queue (RULE-014/015). Explicit card-specific frequency limits (RULE-020/026) still apply.

**Example:** Installed Software says “Whenever your discard pile is reshuffled into your draw pile, gain 2 CHAR prevention.” If **three actual reshuffles** occur during one draw operation, three triggers are queued and later grant **6 CHAR prevention total**, absent other modifiers or limits.

**Clarification:** This rule does not cause an extra reshuffle when there are no eligible cards in the discard pile; it only counts reshuffles that actually occur. The precise conditions under which repeated reshuffles can occur during a single draw remain subject to the available card zones and normal draw rules (RULE-034).


## 103. RULE-037 — No automatic penalty when draw and discard piles are empty (LOCKED, 2026-11-10)

**Explicit user approval:** If an instruction requires drawing cards but **both the draw pile and discard pile contain no eligible cards**, draw **zero cards** and **continue resolving any remaining independent instructions**. Do **not** automatically inflict Integrity damage, other damage, or any penalty merely because a draw could not be fulfilled. If some cards are available, draw as many as possible (RULE-002/034).

**Canonical example:** “Draw 3 cards. Gain 2 CHAR prevention.” With both draw and discard piles empty, draw **0 cards** and still gain **2 CHAR prevention**.

**Compatibility:** Explicit costs and conditional wording such as “If you do” still follow RULE-003; a card may explicitly specify a consequence for an unsuccessful draw, but there is **no universal deck-exhaustion penalty**. Automatic reshuffling applies only when the discard pile has eligible cards (RULE-034).


## 104. RULE-038 — Conditional draw rewards require full completion (LOCKED, 2026-11-10)

**Explicit user approval:** In card text of the form **“Draw X cards. If you do, [reward]”**, the **“If you do” condition is satisfied only if the full specified number X of cards was actually drawn**. If fewer cards are available, draw as many as possible under RULE-002/034/037, but do **not** grant the conditional reward under RULE-003.

**Canonical example:** “Draw 3 cards. If you do, gain 5 CHAR prevention.” With only **2 eligible cards** across draw and discard piles, draw both, but **do not gain the 5 CHAR prevention**.

**Contrast:** “Draw 3 cards. Gain 5 CHAR prevention.” has no “If you do” condition, so the independent prevention instruction resolves even if fewer than 3 cards can be drawn (RULE-002).

**Compatibility:** Multi-card draws and their generated triggers remain uninterrupted (RULE-032/033), with automatic discard reshuffling where possible (RULE-034). This rule addresses conditional success, not a general deck-exhaustion penalty.


## 105. RULE-039 — Conditional rewards resolve before queued draw triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When a card instructs the Runner to draw cards and then grants a conditional reward, **finish resolving the original card's printed instructions, including the conditional reward if its condition is met, before processing triggered effects generated by those draws**. Draw-generated triggers enter the FIFO queue and wait until the current effect finishes (RULE-010/014/015/033).

**Canonical example:** “Draw 3 cards. If you do, gain 5 CHAR prevention.” With three cards available, draw all three uninterrupted, queue any draw-generated triggers, grant **5 CHAR prevention** as the card's conditional reward, then resolve queued triggers in FIFO order. If fewer than three cards are drawn, the reward is not granted (RULE-038), but triggers generated by cards actually drawn still resolve after the original card finishes.

**Scope:** This establishes ordering between an original card's subsequent printed instructions and triggers generated during its draw. It does not change the explicit frequency limits or the distinction between unconditional and conditional instructions (RULE-002/003).


## 106. RULE-040 — Draw replacement effects apply before draw events (LOCKED, 2026-11-10)

**Explicit user approval:** Card text such as **“Whenever you would draw a card, you may gain 2 CHAR prevention instead”** is a **replacement effect**, not an ordinary after-the-fact trigger. Before the affected draw event occurs, the Runner chooses whether to **draw that card normally** or **replace that draw with 2 CHAR prevention**. If replaced, the card is not drawn, and effects that trigger upon **actually drawing** a card do not trigger from that replaced event.

**Timing:** Replacement choices are made **before each applicable draw event**, including during multi-card draws. They modify whether the event happens, and are therefore distinct from queued triggers. Ordinary draw-generated and reshuffle-generated triggers still wait until the uninterrupted draw operation finishes (RULE-032/033/035); allowing replacement choices does not authorize interrupting the draw operation to resolve queued triggers.

**OPEN:** How multiple simultaneous replacement effects interact or are ordered; whether a replaced draw counts as satisfying “Draw X cards. If you do” (not established here); and the treatment of mandatory rather than optional replacement text. Do not infer those edge cases without approval.


## 107. RULE-041 — Replaced draws do not satisfy conditional draw requirements (LOCKED, 2026-11-10)

**Explicit user approval:** If a **draw replacement effect** substitutes another benefit for one or more instructed draws, the replaced events **do not count as cards actually drawn** when checking whether an instruction such as **“Draw X cards. If you do, [reward]”** was completed. The conditional reward requires **X actual cards drawn**, consistent with RULE-038. Replacement benefits still apply normally (RULE-040).

**Canonical example:** “Draw 3 cards. If you do, gain 5 CHAR prevention.” The Runner replaces one of the three draws with **2 CHAR prevention**, and actually draws the other two cards. Result: **2 cards drawn**, **2 CHAR prevention** from the replacement, and **no 5 CHAR prevention conditional reward**, because the full draw instruction was not satisfied.

**Compatibility:** Draw-generated triggers only arise from cards actually drawn (RULE-040); the multi-card draw operation otherwise remains uninterrupted and its queued triggers resolve afterward (RULE-033/039). **OPEN:** Interaction among multiple competing replacement effects for the same would-be draw event.


## 108. RULE-042 — Choose one competing draw replacement per event (LOCKED, 2026-11-10)

**Explicit user approval:** When **multiple optional replacement effects** could replace the **same would-be card draw**, the Runner chooses **at most one** of those replacement effects for that draw. The Runner may instead choose to **draw the card normally**. Applying one replacement consumes/replaces that draw event; the other replacement effects cannot also claim benefits from that same draw.

**Canonical example:** Installed Card A: “Whenever you would draw a card, you may gain 2 CHAR prevention instead.” Installed Card B: “Whenever you would draw a card, you may gain 1 BW instead.” For each would-be draw, choose exactly one of: (a) actually draw one card; (b) gain **2 CHAR prevention** instead; or (c) gain **1 BW** instead. **Never gain both replacement benefits for the same draw.**

**Multiple-card draws:** Make the replacement choice independently for **each individual would-be draw**, while preserving uninterrupted resolution of the overall draw operation and deferring ordinary triggers until afterward (RULE-033/040).

**Compatibility:** A replaced draw does not count as a card actually drawn for conditional draw rewards (RULE-041). **OPEN:** Mandatory replacement effects and precedence between mandatory and optional replacements, if introduced.


## 109. RULE-043 — Mandatory draw replacements take priority over optional replacements (LOCKED, 2026-11-10)

**Explicit user approval:** When a **mandatory** draw replacement and an **optional** draw replacement are both applicable to the same would-be draw, the **mandatory replacement takes priority**, unless other card text **explicitly overrides** that precedence. A replacement reading **“Whenever you would draw a card, gain 2 CHAR prevention instead”** (without “may”) is mandatory. The Runner cannot elect to draw normally or choose a competing optional replacement while the mandatory replacement applies.

**Canonical example:** Card A (mandatory): “Whenever you would draw a card, gain 2 CHAR prevention instead.” Card B (optional): “Whenever you would draw a card, you may gain 1 BW instead.” For the affected draw, apply Card A and gain **2 CHAR prevention**; do **not** draw the card or gain Card B's optional **1 BW**, absent explicit override text.

**Compatibility:** Only one replacement benefit applies to a single draw event (RULE-042). Replaced draws do not count as actual cards drawn for conditional rewards (RULE-041). Replacement effects occur before the affected draw rather than as queued post-draw triggers (RULE-040).

**OPEN:** Ordering/selection when **multiple mandatory replacements** compete for the same draw event, and the exact meaning and resolution of explicit priority overrides.


## 110. RULE-044 — Runner chooses between competing mandatory draw replacements (LOCKED, 2026-11-10)

**Explicit user approval:** If **two or more mandatory draw replacement effects** apply to the **same would-be draw event**, the **Runner chooses exactly one** of the competing mandatory replacements to apply. The unchosen mandatory replacements do not produce benefits from that draw. Because a mandatory replacement applies, the Runner cannot choose to perform the original draw normally, absent explicit overriding card text.

**Canonical example:** Installed Card A: “Whenever you would draw a card, gain 2 CHAR prevention instead.” Installed Card B: “Whenever you would draw a card, gain 1 BW instead.” For each would-be draw, the Runner chooses **either 2 CHAR prevention or 1 BW**, **not both**, and does not draw the card.

**Compatibility:** Mandatory replacements have priority over optional replacements (RULE-043), only one replacement applies per draw (RULE-042), and replaced draws do not count as actually drawn for conditional rewards (RULE-041). The decision occurs before the affected draw event (RULE-040).

**OPEN:** How an explicit card-text priority override affects selection among multiple mandatory replacements; interaction with replacement effects that change rather than fully substitute a draw.


## 111. RULE-045 — Draw replacements require an available drawable card (LOCKED, 2026-11-10)

**Explicit user decision:** Rejected the proposal that a “whenever you would draw” replacement can grant its substitute benefit when both draw and discard piles have no eligible cards. Approved the interpretation that **only would-be draws for which an eligible card is actually available may be replaced**. A draw instruction that cannot be fulfilled due to lack of eligible cards **does not generate a replacement benefit**.

**Canonical example:** “Draw 3 cards,” with only **2 eligible cards** available across draw and discard piles, and an installed Software allowing each draw to be replaced with **2 CHAR prevention**. The Runner may (a) draw both cards, (b) replace one available draw to draw one card and gain 2 CHAR prevention, or (c) replace both available draws to gain 4 CHAR prevention and draw zero cards. The **third, unavailable draw cannot be replaced** and generates no prevention.

**Compatibility:** This restriction applies to both mandatory and optional draw replacement effects (RULE-040/042/043/044). A replaced draw is not counted as an actual card drawn for conditional “If you do” rewards (RULE-041). Unavailable draws carry no automatic deck-exhaustion penalty (RULE-037). Normal discard reshuffling may supply available cards (RULE-034). **OPEN:** How to test availability if a replacement itself moves cards among zones or changes deck composition.


## 112. RULE-046 — Draw availability includes discard pile for replacements (LOCKED, 2026-11-10)

**Explicit user approval:** For purposes of checking whether a would-be draw is eligible for a draw replacement (RULE-045), **available drawable cards include eligible cards in both the draw pile and the discard pile**, because the discard pile can normally be reshuffled into the draw pile when needed (RULE-034). A replacement may apply when the draw pile is empty but the discard pile contains eligible cards. If both piles are empty, no replacement benefit can be generated.

**Canonical example:** Replacement Software: “Instead of drawing a card, shuffle one card from your discard pile into your draw pile.” If the draw pile is empty and the discard pile contains at least one eligible card, the replacement **can activate** and move the card as instructed instead of drawing. If both piles are empty, the replacement cannot activate.

**Compatibility:** Replaced draws do not count as actual draws for conditional draw completion or draw triggers (RULE-040/041). This rule establishes the **availability test**, not any new permission to generate benefits from impossible draws.

**OPEN:** Whether checking availability for a replacement with an empty draw pile itself triggers an automatic full-discard reshuffle before the replacement resolves; distinguish that from a replacement that explicitly moves cards from discard.


## 113. RULE-047 — Resolve draw replacement choice before automatic reshuffling (LOCKED, 2026-11-10)

**Explicit user approval:** When the draw pile is empty but the discard pile contains eligible cards, **check draw availability across both piles** (RULE-046), then **resolve applicable draw replacement choices before performing an automatic discard-to-draw reshuffle**. If the Runner replaces the draw, **do not perform an automatic reshuffle for that replaced event**. If the Runner proceeds with the actual draw, **reshuffle the discard pile into the draw pile** under RULE-034 and then draw. An explicit replacement effect that itself moves or shuffles cards resolves according to its own text; that is distinct from an automatic reshuffle.

**Canonical example:** Draw pile empty; discard pile contains 5 cards; installed Software reads “Whenever you would draw a card, you may gain 2 CHAR prevention instead.” The Runner may choose **2 CHAR prevention** and **no automatic reshuffle occurs**, hence no automatic reshuffle trigger from this draw. Alternatively, the Runner may draw normally, triggering the automatic reshuffle and then drawing the card.

**Compatibility:** No replacement benefit if both piles lack eligible drawable cards (RULE-045). Replaced draws do not trigger on-draw effects or satisfy conditional draw counts (RULE-040/041). Automatic reshuffle triggers, when an actual reshuffle occurs, are queued according to RULE-035/036.

**OPEN:** Ordering among explicit shuffle/move effects that change availability mid multi-card draw.


## 114. RULE-048 — Recalculate card availability before each draw in multi-card instructions (LOCKED, 2026-11-10)

**Explicit user approval:** During a multi-card draw instruction (such as “Draw 3 cards”), **recalculate the availability of eligible drawable cards before each individual would-be draw**, accounting for changes to draw and discard piles caused by prior replacements in that same instruction. A replacement that returns a card to the draw pile can therefore make that card eligible for a **subsequent draw** in the same instruction, even when the initial pile sizes would not have supported that later draw.

**Canonical example:** The draw pile initially contains **1 card**, the discard pile is empty, and installed Software says “Whenever you would draw a card, you may return 1 card from your hand to the draw pile instead.” The Runner may replace an eligible first draw by returning a card from hand to the draw pile. The updated draw pile is checked for the next would-be draw, allowing that card to be drawn or otherwise handled according to applicable replacement rules. Reassess availability for each further draw.

**Compatibility:** Draw replacement requires an available drawable card at the time of the individual draw (RULE-045), including eligible cards in discard (RULE-046); replacement choices precede automatic reshuffling (RULE-047). A replaced draw is not an actual draw for draw triggers or conditional full-draw rewards (RULE-040/041). Normal multi-card draw instructions remain uninterrupted by queued ordinary triggers (RULE-033/039).

**OPEN:** Whether cards returned to the draw pile by replacement are placed on top, bottom, or shuffled in, unless specified by card text; how multiple effects modify availability during a single draw event.


## 115. RULE-049 — Draw-pile insertion destination must be explicit (LOCKED, 2026-11-10)

**Explicit user direction:** Every card effect that **returns, moves, or inserts a card into the draw pile** must explicitly state **where** that card goes: **top of the draw pile**, **bottom of the draw pile**, or **shuffled into the draw pile**. **There is no default placement** for card effects.

**Invalid/unfinished wording:** “Instead of drawing a card, return 1 card from your hand to your draw pile.” This does not specify placement and must be corrected during card design rather than silently interpreted by the engine.

**Valid example:** “Instead of drawing a card, return 1 card from your hand to the **top** of your draw pile.” Other effects may explicitly specify the **bottom** or instruct the player to **shuffle** the card into the draw pile.

**Compatibility:** Replacement effects can change draw availability for subsequent individual draws within a multi-card draw instruction (RULE-048). This rule does not alter the separate automatic reshuffle of the discard pile when drawing from an empty draw pile (RULE-034/047).

**Implementation guidance:** Card definitions and validation should reject or flag draw-pile movement effects without an explicit destination.


## 116. RULE-050 — Shuffling into an empty draw pile incorporates the discard pile (REVISED, LOCKED, 2026-11-10)

**Explicit user revision:** When an effect instructs the Runner to **shuffle one or more specified cards into an empty draw pile**, first include **all cards from the discard pile** together with the incoming specified cards, then shuffle the combined cards into the draw pile **as one shuffle event**. The discard pile becomes empty. This **replaces the original RULE-050** that kept discard cards untouched.

**Canonical example:** “Return 1 card from your hand and shuffle it into your draw pile.” With an empty draw pile and **5 cards in discard**, combine the 5 discarded cards and the 1 returned card, then shuffle them together as **one shuffle event**. The draw pile contains **6 cards**, and discard contains **0**.

**Scope:** This applies specifically when card text explicitly instructs a **shuffle into an empty draw pile**. It does not change the explicit top/bottom/shuffle destination requirement (RULE-049), the automatic reshuffle procedure for actual draws (RULE-034), or the replacement-before-automatic-reshuffle timing (RULE-047). See RULE-051 for trigger accounting.


## 117. RULE-051 — Combined empty-pile shuffle counts as one shuffle event (LOCKED, 2026-11-10)

**Explicit user approval of aligned RULE-050/051:** When shuffling one or more incoming cards into an **empty draw pile** with cards in discard, the discard cards and incoming cards are **combined first**, then shuffled together in **one operation**. This counts as **one shuffle event**, not separate discard-reshuffle and incoming-card-shuffle events.

**Trigger consequences:** An effect that triggers “Whenever you shuffle your draw pile” sees **one shuffle** and triggers once (subject to card-specific limits). A trigger explicitly requiring a **discard-pile reshuffle** must be evaluated according to its wording; do not silently equate all shuffle trigger conditions. Any resulting triggers follow the existing queue and resolution rules (RULE-014/015/035/036).

**Compatibility:** RULE-050 (revised) establishes card movement; RULE-051 establishes single-event accounting. No automatic shuffle is implied when a card is placed explicitly on the top or bottom of the draw pile instead of being shuffled (RULE-049).


## 118. RULE-052 — Combined shuffle qualifies as discard-pile reshuffle trigger (LOCKED, 2026-11-10)

**Explicit user approval:** When the discard pile is incorporated into an empty draw pile as part of the combined shuffle established by revised RULE-050 and RULE-051, the operation **qualifies as a discard-pile reshuffle** for effects reading “Whenever you reshuffle your discard pile into your draw pile.” It produces **one shuffle event** and therefore **one such trigger** per qualifying effect, subject to any explicit card-specific frequency restrictions.

**Canonical example:** Draw pile empty, discard pile has 5 cards; Runner shuffles 1 card from hand into the draw pile. All 6 cards are combined and shuffled together once; discard becomes empty. Installed Software “Whenever you reshuffle your discard pile into your draw pile, gain 2 CHAR prevention” **triggers once**, granting **2 CHAR prevention**.

**Compatibility:** This is one event, not a discard reshuffle followed by a separate shuffle (RULE-051). Apply ordinary trigger queuing and timing (RULE-014/015/035/036). The specific discard-reshuffle trigger requires that cards actually be incorporated from discard; merely shuffling a card into an empty draw pile when discard is empty does not meet that wording.


## 119. RULE-053 — General draw-pile shuffle differs from discard-pile reshuffle (LOCKED, 2026-11-10)

**Explicit user approval:** An instruction to **shuffle a card into the draw pile** counts as **one general draw-pile shuffle event** even if the draw pile was empty and the resulting draw pile contains only one card. However, this does **not** qualify as a **discard-pile reshuffle** unless at least one card was actually incorporated from the discard pile.

**Canonical example:** Draw pile **0**, discard pile **0**; card says “Shuffle 1 card from your hand into your draw pile.” The resulting draw pile contains **1 card**. Effects reading “Whenever you shuffle your draw pile” trigger **once**; effects reading “Whenever you reshuffle your discard pile into your draw pile” do **not** trigger.

**Compatibility:** When discard cards actually participate in the combined shuffle under RULE-050/051, discard-reshuffle triggers qualify (RULE-052). One shuffle operation is still only one shuffle event; apply ordinary trigger queue and card-specific frequency limits.


## 120. RULE-054 — One shuffle event may satisfy multiple trigger conditions (LOCKED, 2026-11-10)

**Explicit user approval:** A **single shuffle event** may simultaneously satisfy **multiple distinct trigger conditions**. Each eligible installed ability triggers once for that event, subject to its own card-specific frequency limits. This does **not** multiply the number of shuffle events. If the abilities are Runner-controlled and simultaneous, the **Runner chooses their resolution order** (RULE-011), with the existing trigger queue applying (RULE-014/015).

**Canonical example:** Installed Card A: “Whenever you shuffle your draw pile, gain 2 CHAR prevention.” Installed Card B: “Whenever you reshuffle your discard pile into your draw pile, gain 1 BW.” The Runner performs a **combined shuffle under revised RULE-050** incorporating cards from discard. This is **one shuffle event** (RULE-051), qualifying both as a general draw-pile shuffle (RULE-053) and as a discard-pile reshuffle (RULE-052). **Both Card A and Card B trigger once**, granting **2 CHAR prevention** and **1 BW** respectively; the Runner chooses their order of resolution.

**Scope:** This does not imply that an ability can trigger multiple times from the same event merely because its condition is described in multiple ways.


## 121. RULE-055 — Separate abilities on one card independently trigger (LOCKED, 2026-11-10)

**Explicit user approval:** When a **single installed Software card** has **multiple separately written triggered abilities**, evaluate each ability **independently** against a qualifying event. If the event satisfies multiple abilities, **each triggers once** (subject to its own explicitly stated frequency limit), even though they appear on the **same card**. Runner-controlled simultaneous triggers are ordered by the Runner (RULE-011) and otherwise follow the established trigger queue (RULE-014/015).

**Canonical example:** One Software card has both “Whenever you shuffle your draw pile, gain 2 CHAR prevention” and “Whenever you reshuffle your discard pile into your draw pile, gain 1 BW.” A combined shuffle that incorporates discard cards (RULE-050/051/052/053) satisfies **both** abilities. They each trigger **once**, granting **2 CHAR prevention** and **1 BW**, with the Runner choosing resolution order.

**Compatibility:** A single event can qualify multiple distinct abilities (RULE-054), including when those abilities share a card. This does not allow one individual ability to trigger multiple times from the same single event, and explicit “once per turn” or other card-specific limits still apply (RULE-020).


## 122. RULE-056 — Explicit shared trigger limits override independent abilities (LOCKED, 2026-11-10)

**Explicit user approval:** When a card explicitly groups multiple triggered abilities under a **shared limit** such as **“Once per turn, choose one”**, that shared restriction overrides the default independence of separately written abilities (RULE-055). Even when one event qualifies for multiple listed triggers, the controller may choose **only one qualifying benefit** for that event, and doing so consumes the **shared once-per-turn allowance**. The other grouped benefit does not activate.

**Canonical example:** One installed Software reads: “Once per turn, choose one: (a) Whenever you shuffle your draw pile, gain 2 CHAR prevention; (b) Whenever you reshuffle your discard pile into your draw pile, gain 1 BW.” A combined shuffle involving discard cards satisfies both conditions, but the Runner chooses **either 2 CHAR prevention or 1 BW**, **not both**. The shared limit is then used for that turn.

**Compatibility:** Independently written abilities trigger separately by default (RULE-055); explicit shared limits override this (RULE-020). The per-turn shared allowance resets under RULE-027/028. Shuffle event classification remains governed by RULE-050–054.


## 123. RULE-057 — Shared trigger limits tracked independently per installed copy (LOCKED, 2026-11-10)

**Explicit user approval:** Each **installed instance** of a Software card has its **own allowance** for an explicit grouped/shared trigger restriction such as **“Once per turn, choose one”** (RULE-056). Multiple copies may each select one eligible benefit when the same event qualifies, unless the card explicitly imposes a **global/shared-across-copies** limit.

**Canonical example:** The Runner installs **two copies** of Software reading: “Once per turn, choose one: (a) Whenever you shuffle your draw pile, gain 2 CHAR prevention; (b) Whenever you reshuffle your discard pile into your draw pile, gain 1 BW.” A combined shuffle incorporating discard cards qualifies for both options on each copy. Each copy independently chooses **one** option, allowing a total of **4 CHAR prevention**, **2 BW**, or **2 CHAR prevention plus 1 BW**. Both copies' own once-per-turn allowances are then consumed.

**Compatibility:** Independent per-copy triggers are consistent with RULE-021; shared limits within each copy follow RULE-056; explicit global restrictions override per-copy allowances. Per-turn allowances reset under RULE-027/028, and simultaneous Runner-controlled triggers follow RULE-011.


## 124. RULE-058 — Explicit global trigger limits shared across all installed copies (LOCKED, 2026-11-10)

**Explicit user approval:** When card text explicitly imposes a **global trigger-frequency restriction across all installed copies of that card**, all those copies share **one allowance**, rather than each copy having an independent activation. The global restriction overrides the default per-copy trigger allowances (RULE-021/057) only when stated explicitly.

**Canonical example:** Software reads: “Once per turn, across all installed copies of this card, whenever you shuffle your draw pile, gain 2 CHAR prevention.” The Runner has **three installed copies** and performs a qualifying shuffle. The effect activates **once total**, granting **2 CHAR prevention**, **not 6**. The shared allowance is consumed for all three copies until the per-turn reset.

**Compatibility:** Per-copy trigger limits remain the default (RULE-057); explicit shared limits within a card remain governed by RULE-056. Per-turn reset follows RULE-027/028. Multiple different abilities may still qualify from one event unless limited by explicit text (RULE-054/055).


## 125. RULE-059 — Installing new copies does not reset a consumed global trigger limit (LOCKED, 2026-11-10)

**Explicit user approval:** A globally shared trigger-frequency allowance belongs to the **card's shared ability across all installed copies**, not to any particular installed instance. If the global allowance has already been consumed during the current turn, **installing another copy of that card later in the same turn does not restore or reset the allowance**. The newly installed copy inherits the consumed state until the normal per-turn reset (RULE-027/028).

**Canonical example:** One installed Software has “Once per turn, across all installed copies of this card, whenever you shuffle your draw pile, gain 2 CHAR prevention.” A shuffle activates it once for **2 CHAR prevention**. The Runner then installs a second copy and shuffles again during the same turn. **No second activation** occurs, because the shared global allowance remains consumed.

**Compatibility:** Explicit global limits override per-copy limits (RULE-058), while ordinary independent per-copy limits remain the default (RULE-057). The global allowance resets at the beginning of each turn under RULE-027/028.

**OPEN:** Whether a globally consumed limit persists if all copies leave play and another copy is installed later in the same turn.


## 126. RULE-060 — Global trigger limits persist after all copies leave play (LOCKED, 2026-11-10)

**Explicit user approval:** A globally shared trigger-frequency allowance is tracked by **card identity for the full turn**, even if **all installed copies leave play**. Uninstalling every copy and later installing another copy of the same card during that turn **does not reset a consumed global allowance**. The normal turn-start reset remains the only default reset (RULE-027/028), unless explicit card text provides otherwise.

**Canonical example:** A globally once-per-turn shuffle ability triggers once. The Runner uninstalls all copies of that Software, then installs another copy in the same turn and shuffles again. The ability **does not trigger again** because its global allowance remains consumed.

**Compatibility:** Global limits are shared across copies (RULE-058), and installing a new copy does not reset a consumed allowance (RULE-059). This rule clarifies that the consumed state persists even across a period with zero installed copies.

**OPEN:** How globally limited abilities distinguish separate card identities or upgraded/modified variants when their names match.


## 127. RULE-061 — PATCHWORK modifications preserve card identity for global trigger limits (LOCKED, 2026-11-10)

**Explicit user approval:** A **PATCHWORK modification** changes properties or abilities of an individual card instance but **does not change its underlying card identity** for the purposes of global trigger-frequency restrictions. Standard and PATCHWORK-modified copies of the same original Software card therefore **share the same global activation allowance** for a globally limited ability they retain.

**Canonical example:** Copy A is standard Software; Copy B is a PATCHWORK-modified copy of that same Software with an additional ability. Both retain the same globally once-per-turn shuffle ability. If either copy activates that shared ability, its **global allowance is consumed for both copies** until the ordinary turn-start reset (RULE-027/028), even though one copy is modified. Copy B's additional PATCHWORK ability is governed by its own text and limits.

**Compatibility:** Global limits apply across copies (RULE-058), survive installation changes (RULE-059/060), and track underlying card identity rather than PATCHWORK variant. This does not establish a shared limit for distinct additional abilities unless their text explicitly creates one.

**OPEN:** Identity rules for cards transformed into a different named/base card, if such mechanics are introduced.


## 128. RULE-062 — PATCHWORK augments original abilities and inherits their restrictions (REVISED, LOCKED, 2026-11-10)

**Explicit user correction superseding the original RULE-062:** PATCHWORK is an **augmentation/extension of the card's original ability**, not a separate independent trigger system. **Any restrictions applying to the original ability also apply to its PATCHWORK enhancement**, including once-per-turn, per-card, shared, and global-across-copies activation limits. PATCHWORK cannot circumvent an already-consumed original trigger allowance.

**Canonical example:** Original Software ability: “Once per turn, across all installed copies of this card, whenever you shuffle your draw pile, gain 2 CHAR prevention.” PATCHWORK augments that ability with **+1 CHAR prevention**. A qualifying shuffle with an available shared global allowance activates the modified card's ability for **3 CHAR prevention** (2 original + 1 PATCHWORK). Once the shared global allowance is consumed, neither the original portion nor its PATCHWORK augmentation can activate again during that turn.

**Compatibility:** PATCHWORK preserves original card identity (RULE-061). Global restrictions continue to apply across copies (RULE-058–060). The general independence of separately printed abilities (RULE-055) does **not** exempt PATCHWORK augmentations from restrictions attached to the original ability they modify.

**Design clarification:** If a future PATCHWORK effect is intended to create an entirely new, separately limited ability rather than augment the existing ability, that exception requires explicit design approval; do not infer independence by default.


## 129. RULE-063 — Runner selects which differently modified copy uses a shared global activation (LOCKED, 2026-11-10)

**Explicit user approval:** When multiple installed copies of the **same underlying Software card** share a **global trigger activation allowance**, but differ in their **PATCHWORK enhancements**, the **Runner chooses which eligible installed copy's ability resolves** on a qualifying event. Resolve the selected copy's original ability together with its PATCHWORK augmentation, then consume the **single global allowance for all copies**. Other copies do not also resolve that globally restricted ability for the same event.

**Canonical example:** Copy A is unmodified and grants **2 CHAR prevention** on a qualifying shuffle; Copy B has PATCHWORK augmenting the same ability to grant **5 CHAR prevention**. Both share a global once-per-turn limit. On a qualifying shuffle with the allowance available, the Runner chooses **either 2 CHAR prevention (A) or 5 CHAR prevention (B)**, not both. The global allowance is then consumed for all copies until reset.

**Compatibility:** Global restrictions apply across installed copies (RULE-058–060), PATCHWORK preserves identity (RULE-061) and inherits restrictions of the augmented ability (revised RULE-062). The choice of instance determines the modified outcome, not an additional activation.


## 130. RULE-064 — Only eligible installed copies can activate PATCHWORK-enhanced abilities (LOCKED, 2026-11-10)

**Explicit user approval:** When multiple copies of the same Software card share a global activation limit, the Runner may select **only an eligible installed copy** to resolve the globally limited ability. A PATCHWORK-modified copy in the discard pile or another inactive zone cannot be selected to provide its enhanced effect, **unless explicit card text permits activation from that zone**.

**Canonical example:** Copy A is standard Software, **installed**, and its qualifying shuffle ability grants **2 CHAR prevention**. Copy B is PATCHWORK-modified Software, **in the discard pile**, and would grant **5 CHAR prevention** if installed. A qualifying shuffle occurs. Only Copy A is eligible to activate, granting **2 CHAR prevention** and consuming the shared global allowance. Copy B's enhanced benefit is unavailable while it remains in discard.

**Compatibility:** Runner chooses among eligible differently modified copies for a shared global activation (RULE-063). PATCHWORK preserves original card identity and inherits original restrictions (RULE-061/062); global limits remain shared across copies (RULE-058–060). Zone-specific exceptions require explicit text.


## 131. RULE-065 — Installing PATCHWORK-enhanced copies does not reset consumed global limits (LOCKED, 2026-11-10)

**Explicit user approval:** Installing a **PATCHWORK-enhanced copy** of Software during a turn does **not** restore an already-consumed **globally shared trigger allowance** for the original ability it augments. The stronger modified benefit is unavailable until the global allowance resets normally, even if the enhanced copy was not installed when the allowance was first consumed.

**Canonical example:** Installed standard Copy A activates a globally once-per-turn shuffle ability for **2 CHAR prevention**. Later in the same turn, the Runner installs PATCHWORK-enhanced Copy B, whose version of that same ability would grant **5 CHAR prevention**. A second qualifying shuffle occurs. **Copy B does not activate**; the global allowance was consumed by Copy A. At the normal start-of-turn reset, the allowance becomes available again and the Runner may select an eligible installed copy.

**Compatibility:** Global limits are shared across copies (RULE-058), persist across later installation (RULE-059) and complete uninstallation (RULE-060), PATCHWORK preserves identity (RULE-061) and inherits original restrictions (revised RULE-062), and only eligible installed copies can be selected (RULE-064). Reset timing follows RULE-027/028.


## 132. RULE-066 — Temporary removal and return does not reset activation limits (LOCKED, 2026-11-10)

**Explicit user approval:** When a PATCHWORK-enhanced Software card **temporarily leaves play and returns during the same turn**, any previously consumed **once-per-turn or applicable shared activation allowance remains consumed**. Temporary removal and re-entry do not create a fresh card identity or refresh activation eligibility. The PATCHWORK augmentation and original ability share the same restriction (RULE-062).

**Canonical example:** An installed Software card has “Once per turn, whenever you shuffle your draw pile, gain 2 CHAR prevention,” augmented by PATCHWORK to grant **5 CHAR prevention** on activation. It activates once, is temporarily removed from play by ICE, and returns installed in the same turn. On another qualifying shuffle that turn, **it cannot activate again**. Its allowance resets only at the normal turn reset.

**Compatibility:** PATCHWORK preserves underlying identity (RULE-061); restrictions extend to augmentation (RULE-062); installation cannot reset consumed global limits (RULE-059/065). Normal per-turn reset follows RULE-027/028. Explicit card text may define an exception.


## 133. RULE-067 — Full-card temporary copies inherit PATCHWORK enhancements (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect explicitly **copies the entire PATCHWORK-enhanced Software card**, its temporary copy inherits the original card's **modified abilities and PATCHWORK augmentation**. The temporary copy is a distinct card instance and has its **own per-copy once-per-turn activation allowance**. Restrictions attached to the copied ability still apply to its augmentation; an explicitly **global limit across all copies** remains shared rather than becoming independent.

**Canonical example:** Original Software: “Once per turn, whenever you shuffle your draw pile, gain 2 CHAR prevention.” PATCHWORK augments that benefit to **5 CHAR prevention**. An effect creates a temporary full-card copy. Both original and temporary copy have the **5 CHAR prevention** ability, and each may activate **once per turn**, provided each is otherwise eligible. If instead the ability says “once per turn, across all copies,” both share the **single global allowance**.

**Scope:** Copying the card's modified characteristics does not award an additional permanent PATCHWORK upgrade. Duration, disposition and zone of the temporary copy follow the creating effect, to be specified by that effect.

**Compatibility:** PATCHWORK is an extension of the original ability and inherits restrictions (RULE-062); only eligible installed Software copies activate installed abilities (RULE-064); per-copy vs global limits follow RULE-021/058–060.


## 134. RULE-068 — Newly created temporary copies start with unused per-copy activation allowances (LOCKED, 2026-11-10)

**Explicit user approval:** A **new temporary full-card copy** of PATCHWORK-enhanced Software is a **new card instance** with its own **unused per-copy once-per-turn activation allowance**, even if the original Software card already activated that ability earlier in the same turn. The temporary copy inherits the card's PATCHWORK-modified ability but **does not inherit the original instance's activation history**. Explicit **global limits across all copies remain shared** and are not reset by copying.

**Canonical example:** Original PATCHWORK-enhanced Software grants **5 CHAR prevention once per turn** when the Runner shuffles the draw pile. The original activates once. Later in the same turn, an effect creates a new temporary full-card copy. On a further qualifying shuffle, the new eligible temporary copy **may activate for 5 CHAR prevention**; the original may not activate again. If the printed ability instead states “once per turn, across all copies,” the already-consumed global allowance prevents the new copy from activating.

**Compatibility:** Full-card copies inherit PATCHWORK enhancements (RULE-067); PATCHWORK enhancements inherit original restrictions (RULE-062); new copies are distinct instances for per-copy limits (RULE-021), but global limits persist across copies and installations (RULE-058–060). Temporary removal and return of the *same* instance does not refresh its allowance (RULE-066).


## 135. RULE-069 — Copied triggered abilities include PATCHWORK modifications (LOCKED, 2026-11-10)

**Explicit user approval:** An effect that says **“Copy the triggered ability of one installed Software card. Resolve the copied ability”** copies the **currently PATCHWORK-modified ability**, not merely the unmodified printed ability. Resolving the copied ability does **not create another Software card**, does **not consume an additional activation of the original ability**, and does **not reset the original card's activation allowance**. The copy effect resolves that copied ability **once** as instructed.

**Canonical example:** An installed Software card's triggered ability normally grants **2 CHAR prevention**; PATCHWORK augments that ability to **5 CHAR prevention**. An effect copies and resolves that triggered ability. The copied resolution grants **5 CHAR prevention**. The original card's activation history is unchanged by the copy effect.

**Distinction:** Copying an **ability** does not create a new card instance or fresh per-copy allowance. Copying an **entire card** creates a new instance with inherited PATCHWORK and its own per-copy allowance (RULE-067/068). PATCHWORK remains an extension of the original ability (revised RULE-062).

**Scope note:** This rule addresses an effect explicitly instructing a copied ability to resolve; it does not establish that copying an ability grants permission to repeatedly activate the original restricted trigger.


## 136. RULE-070 — Explicit copied-ability resolution works after original limit consumed (LOCKED, 2026-11-10)

**Explicit user approval:** An effect that explicitly instructs the Runner to **copy a triggered ability of an installed Software card and resolve the copied ability** may do so **even when the original card's once-per-turn activation allowance has already been consumed**. The copied resolution uses the **PATCHWORK-enhanced ability** (RULE-069). It is a resolution directed by the copy effect, **not another activation of the original trigger**; the original allowance remains consumed and is not reset.

**Canonical example:** Installed Software has a PATCHWORK-enhanced ability: “Once per turn, whenever you shuffle your draw pile, gain **5 CHAR prevention**.” The original ability has already activated this turn. The Runner plays an effect: “Copy the triggered ability of one installed Software card. Resolve the copied ability.” That copied resolution still grants **5 CHAR prevention**, and the original card cannot activate its own once-per-turn ability again until its normal reset.

**Scope:** This permission requires an effect that **explicitly copies and resolves** the ability. Merely creating another qualifying trigger event does not bypass original limits. Copying an ability does not create a new Software card or fresh card-instance allowance (RULE-069), and PATCHWORK otherwise inherits restrictions of the original ability (RULE-062).


## 137. RULE-071 — Copied abilities retain costs (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect explicitly **copies and resolves an installed Software card's triggered ability**, the copied ability retains **all costs required for its benefit**, including costs in its PATCHWORK-enhanced version. The Runner must pay such costs in full for the copied resolution to grant the associated benefit. If the cost cannot be paid, the associated benefit is not granted. Copying the ability does not waive costs or consume an additional activation of the original ability.

**Canonical example:** PATCHWORK-enhanced Software reads: “Once per turn, when you shuffle your draw pile, you may **discard 1 card** to gain **5 CHAR prevention**.” Another card says: “Copy the triggered ability of one installed Software card. Resolve the copied ability.” The Runner must discard **1 card** to gain **5 CHAR prevention** from the copy. If unable or unwilling to pay that cost, the copied resolution grants **no CHAR prevention**. The original card's activation allowance is unchanged by the copied resolution.

**Compatibility:** Costs must be fully paid (RULE-003); copied triggered abilities include PATCHWORK enhancements (RULE-069); explicit copied resolutions are permitted even when the original activation allowance is consumed (RULE-070). The copied effect follows its own text without treating the original ability as activated again.


## 138. RULE-072 — Copied abilities resolve complete instructions in original order (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect **copies and resolves a Software triggered ability**, it copies **all instructions of the complete PATCHWORK-enhanced ability** and executes them **in their original printed/modified order**, using the **current game state** at resolution. It does **not** copy only the numerical result of a prior activation.

**Canonical example:** An installed Software ability enhanced through PATCHWORK reads: “When you shuffle your draw pile, **gain 3 CHAR prevention. Then double your CHAR prevention**.” If the Runner has **5 CHAR prevention** when the copied ability resolves, it first gains 3 (**5 → 8**) and then doubles the current pool (**8 → 16**), ending at **16 CHAR prevention**.

**Compatibility:** Instructions resolve in order (RULE-010); copied abilities include PATCHWORK modifications (RULE-069), can resolve when original activation limits are consumed if explicitly directed (RULE-070), and retain costs where applicable (RULE-071). Trigger queue handling remains governed by RULE-014/015.


## 139. RULE-073 — Copied abilities finish before generated triggers resolve (LOCKED, 2026-11-10)

**Explicit user approval:** An effect that **copies and resolves a Software ability** must complete **all instructions of that copied ability** before any triggers generated by those instructions resolve. Generated triggers enter the existing queue and are processed afterward under normal ordering rules; they cannot interrupt the copied ability mid-resolution.

**Canonical example:** The Runner has installed Software reading “Whenever you gain CHAR prevention, gain 1 BW.” A copied PATCHWORK-enhanced ability reads “Gain 3 CHAR prevention. Then double your CHAR prevention.” The Runner gains 3 prevention (queuing a BW trigger), then doubles the current prevention (queuing another BW trigger **if the doubling increases prevention and qualifies as a separate gain event**). Only after the copied ability fully finishes do the queued triggers resolve in FIFO order, granting **2 BW** if both events qualified.

**Compatibility:** Chained triggers wait until the current effect completes (RULE-014); queued triggers follow FIFO (RULE-015); copied abilities reproduce full ordered instructions (RULE-072). This rule does not itself establish that every numerical modification is a “gain” event; trigger qualification follows the relevant effect wording and event semantics.


## 140. RULE-074 — Doubling prevention counts as gaining prevention (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect **doubles a prevention pool**, any **positive increase** in that pool counts as **gaining prevention** of that type and therefore qualifies for effects triggered by gaining prevention. A **single doubling instruction** produces **one prevention-gain event** if it increases any prevention, even when it doubles several pools simultaneously. The amounts gained in each affected pool are their respective post-doubling minus pre-doubling differences. See RULE-075. Doubling a zero pool generates **no prevention-gain event**.

**Canonical example:** Runner has **5 CHAR prevention** and installed Software: “Whenever you gain CHAR prevention, gain 1 BW.” Runner plays “Double your CHAR prevention.” CHAR prevention increases **5 → 10**, so the Runner **gains 5 CHAR prevention** and queues **one** +1 BW trigger. That trigger resolves after the doubling effect finishes under RULE-014/015.

**Other prevention types:** The same principle applies to **SYN** and **VOID** prevention when doubled, subject to the wording of the triggered ability and the actual pool increased. Doubling all three pools in **one instruction** is still **one gain event**, not three (RULE-075).

**Compatibility:** Prevention multipliers compound and apply as snapshot effects (RULE-008/009); triggers generated during effect resolution queue until the effect completes (RULE-014/015); copied abilities obey the same rule (RULE-073).


## 141. RULE-075 — A single multi-pool prevention doubling is one gain event (LOCKED, 2026-11-10)

**Explicit user correction:** “Double all your prevention” is a **singular event**. Even if it increases **CHAR, SYN and VOID prevention simultaneously**, an installed ability reading “Whenever you gain prevention, gain 1 BW” triggers **once**, not once per prevention pool. Count the **single resolving gain-producing instruction/event**, not the number of prevention types affected, for an unrestricted “gain prevention” trigger.

**Canonical example:** Runner has **5 CHAR, 3 SYN, 2 VOID prevention** and plays “Double all your prevention.” The pools become **10 CHAR, 6 SYN, 4 VOID**. Software reading “Whenever you gain prevention, gain 1 BW” generates **one trigger**, granting **1 BW total**, not 3 BW.

**Type-specific triggers:** The event may involve multiple prevention types, so a distinct “Whenever you gain CHAR prevention” ability and a distinct “Whenever you gain SYN prevention” ability can each recognize the same event if their conditions are met; however, the **same** generic ability does not trigger multiple times simply because multiple pools increased.

**Compatibility / clarification of RULE-074:** Doubling counts as gaining prevention if it increases prevention, but a **single multi-pool doubling instruction** generates **one gain event**, not a separate event for each affected pool. Independent sequential gain-producing instructions may produce separate events, subject to their text and ordinary trigger rules.


## 142. RULE-076 — Separate gain instructions generate separate prevention-gain events (LOCKED, 2026-11-10)

**Explicit user approval:** When a card or ability contains **multiple distinct instructions** that grant prevention, **each qualifying instruction generates a separate prevention-gain event**, even when the instructions are printed on the same card. A generic ability reading “Whenever you gain prevention, gain 1 BW” can therefore trigger once for each distinct gain instruction. Triggered effects are queued until the current card/ability finishes resolving.

**Canonical example:** An Instant Software card reads “Gain 3 CHAR prevention. Gain 2 SYN prevention.” Another installed Software reads “Whenever you gain prevention, gain 1 BW.” The first instruction gains **3 CHAR prevention** and queues one +1 BW trigger. The second instruction gains **2 SYN prevention** and queues a second +1 BW trigger. After the card finishes resolving, both triggers resolve in FIFO order, granting **2 BW total**.

**Distinction:** One instruction that simultaneously doubles or increases several prevention pools generates **one** gain event (RULE-075); **two separate gain instructions** generate **two** events. Printed order and trigger queue rules remain RULE-010/014/015. No event is generated by an instruction that causes no positive prevention gain.


## 143. RULE-077 — One instruction granting multiple prevention types creates one gain event (LOCKED, 2026-11-10)

**Explicit user approval:** A **single instruction** that grants multiple prevention types **simultaneously** produces **one prevention-gain event**, not a separate event per affected pool. A generic trigger such as “Whenever you gain prevention, gain 1 BW” activates **once** for that instruction if it produces any positive prevention gain.

**Canonical example:** A Software card reads “Gain **3 CHAR prevention and 2 SYN prevention**.” Another installed Software reads “Whenever you gain prevention, gain 1 BW.” The instruction increases both CHAR and SYN pools, but generates **one** qualifying gain event and therefore **one +1 BW trigger**, resolved after the current card/ability completes.

**Distinction:** One multi-pool instruction produces one event (RULE-075), whereas separate instructions “Gain 3 CHAR prevention. Gain 2 SYN prevention.” produce two events (RULE-076). Different type-specific abilities can each recognize the same event if their respective type was gained; the same generic trigger does not multiply by the number of pools affected. Instructions that increase no prevention generate no gain event.


## 144. RULE-078 — One gain event can trigger multiple type-specific abilities (LOCKED, 2026-11-10)

**Explicit user approval:** A **single prevention-gain event** that increases multiple prevention types may satisfy **multiple distinct triggered abilities**, each of which triggers **once** if its own condition is met. This does not split the original gain instruction into multiple events. When the qualifying abilities are Runner-controlled and trigger simultaneously, the **Runner chooses their resolution order**. The originating card/ability completes before those queued triggers resolve.

**Canonical example:** Installed Software A reads “Whenever you gain CHAR prevention, gain 1 BW.” Installed Software B reads “Whenever you gain SYN prevention, draw 1 card.” The Runner plays “Gain 3 CHAR prevention and 2 SYN prevention.” This **single instruction** produces **one gain event** (RULE-077) that satisfies both conditions. Software A queues **+1 BW** and Software B queues **draw 1 card**, each **once**. The Runner chooses their order, and both resolve after the originating card finishes.

**Compatibility:** Multiple distinct triggered abilities may respond to the same event (RULE-055); Runner orders simultaneous Runner-controlled triggers (RULE-011); queued triggers wait until the current effect completes and follow established queue ordering (RULE-014/015); one multi-type prevention instruction is one event (RULE-077).


## 145. RULE-079 — Prevention gained from triggered abilities can generate further triggers (LOCKED, 2026-11-10)

**Explicit user approval:** Prevention granted by a **triggered ability** counts as a new prevention-gain event, just like prevention granted by a played card or other effect. It can trigger further eligible abilities, producing **chained triggers**. Each resolving ability completes before its generated triggers resolve; newly generated triggers enter the existing **FIFO queue**. Genuinely infinite cycles are handled by existing loop detection and termination rules, without capping legitimate finite chains.

**Canonical example:** Installed Software A reads “Whenever you gain CHAR prevention, gain 2 SYN prevention.” Installed Software B reads “Whenever you gain SYN prevention, gain 1 BW.” Runner plays “Gain 3 CHAR prevention.” The 3 CHAR gain queues A. A resolves, granting 2 SYN prevention and queuing B. B subsequently resolves, granting 1 BW. Final gains: **3 CHAR prevention, 2 SYN prevention, 1 BW**, assuming no other effects.

**Compatibility:** Triggered abilities resolve completely before their generated triggers (RULE-014); queue order is FIFO (RULE-015); infinite-loop safeguards follow RULE-016–019; gain-event granularity follows RULE-074–078.


## 146. RULE-080 — Previously queued triggers resolve before newly generated chained triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When multiple triggers are already waiting in the **FIFO queue**, a resolving ability's newly generated trigger is appended **behind all triggers already queued**. It cannot jump ahead of a previously queued trigger. For simultaneous Runner-controlled triggers, the Runner chooses their initial ordering; that choice determines their order in the queue.

**Canonical example:** Software A: “Whenever you gain CHAR prevention, gain 2 SYN prevention.” Software B: “Whenever you gain CHAR prevention, gain 1 BW.” Software C: “Whenever you gain SYN prevention, draw 1 card.” Gaining **3 CHAR prevention** triggers A and B simultaneously. The Runner chooses **A before B**. A resolves and gains **2 SYN prevention**, queuing C **after** B. The resulting resolution order is **A → B → C**, granting 2 SYN prevention, then 1 BW, then drawing 1 card. **A → C → B is not permitted** because B was already queued.

**Compatibility:** Confirms FIFO queue semantics (RULE-015), simultaneous Runner trigger ordering (RULE-011), and chained triggers from prevention gains (RULE-079). Each ability resolves completely before the next queued trigger (RULE-014).


## 147. RULE-081 — Removing Software cancels its unresolved queued triggers (LOCKED, 2026-11-10)

**Explicit user rejection of the alternative:** A triggered ability queued by **installed Software** does **not** survive removal of its source from play. If that Software is no longer installed **when its pending trigger would resolve**, the queued trigger is **cancelled** rather than resolving. The source must remain in play for its queued ability to resolve, **unless explicit card text provides an exception**.

**Canonical example:** Software A reads “Whenever you gain CHAR prevention, gain 2 SYN prevention.” Software B reads “Whenever you gain CHAR prevention, gain 1 BW.” Both trigger on a CHAR prevention gain; Runner queues A before B. During A's resolution, another effect removes Software B from play. When B's queued trigger reaches the front of the FIFO queue, **cancel B's trigger**; it grants **no BW**.

**Compatibility:** Triggers otherwise resolve FIFO (RULE-015/080). This cancellation applies to **unresolved** triggers from Software no longer installed, not to benefits already resolved. Treatment of a removed card that returns before its queued trigger would resolve is a separate open edge case.


## 148. RULE-082 — Leaving play immediately invalidates unresolved Software triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When an installed Software card **leaves play**, **all of its unresolved queued triggered abilities are immediately cancelled**. Returning or reinstalling **that same card instance** before the cancelled trigger's former queue position would be processed **does not restore or revive** the cancelled trigger. Reinstallation may permit **new qualifying triggers** while the Software is eligible, but does not undo the cancellation.

**Canonical example:** Software B has a pending triggered ability in the FIFO queue. B is removed from play, immediately cancelling its pending trigger. Another effect reinstalls the **same B card** before the queue reaches that position. The old trigger remains **cancelled** and grants no benefit; B may generate new triggers only on subsequent qualifying events, subject to applicable activation limits.

**Compatibility:** Extends source-removal cancellation (RULE-081), preserves FIFO processing of surviving triggers (RULE-015/080), and does not reset consumed activation allowances through temporary removal/reinstallation (RULE-066). Already resolved effects remain intact.


## 149. RULE-083 — An ability already resolving completes after its source leaves play (LOCKED, 2026-11-10)

**Explicit user approval:** When a Software triggered ability has **already begun resolving**, removing its source Software card from play **does not interrupt or cancel the remaining instructions of that currently resolving ability**. Resolve its full instructions in order, subject to their normal conditions and costs. This differs from unresolved queued triggers, which are immediately cancelled when their source leaves play (RULE-081/082).

**Canonical example:** Software A's triggered ability reads “Gain 3 CHAR prevention. Then gain 2 SYN prevention.” The ability begins resolving and grants **3 CHAR prevention**. Another effect removes Software A from play before the second instruction. The currently resolving ability still completes, granting **2 SYN prevention**. Any **other unresolved queued triggers** from A are cancelled on removal.

**Compatibility:** Current effects resolve to completion (RULE-010/014); unresolved triggers are cancelled upon source leaving play (RULE-081/082). This rule does not exempt the remaining instructions from explicit conditions or costs.


## 150. RULE-084 — In-progress abilities can generate valid triggers after source removal (LOCKED, 2026-11-10)

**Explicit user approval:** When a Software ability has **already begun resolving** and its source Software card subsequently leaves play, the ability continues under RULE-083. Any **valid game events generated by its remaining instructions** can still trigger **other eligible installed Software**, even though the original ability's source is no longer installed. Removing the source cancels its **other unresolved queued triggers** (RULE-081/082), not the already resolving ability or the validity of events it creates.

**Canonical example:** Software A's ability reads “Gain 3 CHAR prevention. Then gain 2 SYN prevention.” Software B, still installed, reads “Whenever you gain SYN prevention, gain 1 BW.” A begins resolving and grants **3 CHAR prevention**. A is removed from play. A's current ability continues, granting **2 SYN prevention**. This valid SYN gain triggers B; B's queued trigger resolves after the current ability finishes and grants **1 BW**, assuming B remains eligible.

**Compatibility:** In-progress abilities finish after source removal (RULE-083); other pending triggers from removed Software are cancelled (RULE-081/082); valid prevention-gain events trigger eligible abilities (RULE-078/079); generated triggers queue until current resolution completes (RULE-014/015).


## 151. RULE-085 — Pending triggers require source Software to remain installed until resolution begins (LOCKED, 2026-11-11)

**Explicit user approval:** A valid trigger generated by installed Software remains **pending** until its queued ability **begins resolving**. If its source Software leaves play **before resolution begins**, the pending trigger is **cancelled immediately**, even though the event that originally generated it was valid. No benefit from that cancelled trigger is granted.

**Canonical example:** Software A reads “Whenever you gain CHAR prevention, gain 2 SYN prevention.” The Runner gains CHAR prevention and A's trigger enters the queue. Another effect removes A before its trigger begins resolving. **Cancel A's queued trigger; do not grant 2 SYN prevention.**

**Resolution boundary:** A pending queued trigger is cancelled when its source leaves play (RULE-081/082); an ability that **has already begun resolving** continues to completion after source removal (RULE-083), and events it subsequently produces may still trigger other eligible Software (RULE-084). Reinstalling the source does not revive cancelled triggers (RULE-082).


## 152. RULE-086 — Drawing continues after resolving Software source is removed (LOCKED, 2026-11-11)

**Explicit user approval:** Once an installed Software ability has **begun resolving**, removal of its source Software during that resolution **does not interrupt any remaining draw instruction**. The ability finishes normally under the established card-draw rules, including automatic reshuffling and drawing as many cards as possible when insufficient cards are available.

**Canonical example:** Software A's ability reads “Gain 3 CHAR prevention. Then draw 2 cards.” After granting **3 CHAR prevention**, A is removed from play. Its already resolving ability **still draws 2 cards**, assuming at least 2 cards are available through draw/discard piles; if fewer are available, draw as many as possible under RULE-034/037.

**Compatibility:** Confirms that the in-progress resolution protection of RULE-083 applies to **all remaining instructions**, not only prevention gains. Pending, not-yet-resolving triggers from removed Software are still cancelled (RULE-081/082/085). Draw-generated triggers queue until the current effect completes (RULE-033/039).


## 153. RULE-087 — Conditional rewards remain valid after source removal during resolution (LOCKED, 2026-11-11)

**Explicit user approval:** If an installed Software ability has **already begun resolving**, removing the source Software card during that resolution **does not invalidate a conditional reward** whose requirement is successfully fulfilled. The remaining instructions continue normally and the condition is evaluated based on what actually happened, not on whether the source is still installed.

**Canonical example:** Software A reads “Draw 2 cards. If you do, gain 5 CHAR prevention.” During the draw, another effect removes A from play. If **both cards are actually drawn**, the “If you do” requirement is satisfied and the Runner **gains 5 CHAR prevention**. If fewer than two cards are drawn, the conditional reward **does not occur**, regardless of source removal.

**Compatibility:** Conditional draws require full completion (RULE-038); draw-triggered effects wait until the card ability finishes (RULE-033/039); already resolving abilities continue after source removal (RULE-083/086). Other pending triggers from removed Software remain cancelled (RULE-081/082/085).


## 154. RULE-088 — Explicit installed-source conditions override continued resolution (LOCKED, 2026-11-11)

**Explicit user approval:** An installed Software ability that has **already begun resolving** normally continues after its source leaves play (RULE-083), but **explicit conditions requiring that Software to remain installed** must still be satisfied at the point the condition is checked. Continuing resolution does **not** waive or override an expressly stated installed-source requirement.

**Canonical example:** Software A reads “Draw 2 cards. If this Software is still installed, gain 5 CHAR prevention.” The ability begins resolving, but A is removed during the draw. The Runner **still completes the draw of 2 cards** (assuming cards are available). At the conditional instruction, A is **not installed**, so the Runner gains **0 CHAR prevention**. The fact that both cards were drawn does not satisfy the distinct explicit installation condition.

**Compatibility:** Already resolving abilities finish after source removal (RULE-083/086); successfully completed conditional draws remain valid when their conditions are met (RULE-087); however, explicit conditions are independently enforced (RULE-003/038). Pending queued abilities from removed Software are cancelled (RULE-081/082/085).
