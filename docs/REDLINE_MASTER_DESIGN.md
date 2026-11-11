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
