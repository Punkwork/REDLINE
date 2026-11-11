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
