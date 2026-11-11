# REDLINE — CURRENT PROJECT STATUS
**As of:** 2026-11-09  
**Purpose:** fast, reliable start-of-day briefing. Update at every session handoff.

## At a glance
- **Project:** REDLINE, cyberpunk runner-versus-corporation card game with ICE and companion NUL/REM.
- **Production engine:** **Godot 4** (chosen).
- **Gameplay reference:** Python/Pygame archive `REDLINE_Dead_Drop_Final_Playtest.zip` (previously identified; not inspected today).
- **Design baseline:** `REDLINE_MASTER_DESIGN.md`.
- **Historical record:** `REDLINE_DEVELOPMENT_LOG.md`.
- **Current confidence:** core decisions are documented; current code and test state require verification against actual source.

## Confirmed design decisions
1. Runner acts; corporation then fires all remaining unbroken damage/Trace subroutines; broken DEADLOCK allows advance after corp turn.
2. NEURAL DAMAGE X = runner chooses X cards to discard from hand; SYNAPTIC DAMAGE X = X random hand cards discarded. Neither affects Integrity or permanently destroys cards.
3. PURGE = corporation removes virus counters.
4. DEAD DROP (not Safehouse): exactly one of PATCH UP (+10 Integrity) or WIPE TRAIL (−20 Trace).
5. Hardware recycled once per encounter end; PATCHWORK persists per card instance; Ghostware permanent non-card.
6. UI: `[STR X]`, drag breakers to ICE, fixed ICE inspection bay, tooltips, Ghostware rack below RETURN, signature Ghostware once with ORIGIN.
7. NUL/REM's six modes preserved; First Signal is real synchronization transmission.

## Implementation evidence matrix
| Area | Design | Code status | Testing |
|---|---|---|---|
| ICE timing / DEADLOCK | Locked | Previously represented in Python reference; inspect | Prior regressions reportedly passed; re-run |
| NEURAL/SYNAPTIC discard | Locked | Verify against latest files | Test cases needed/verify |
| Trace / Black ICE | Partially specified | Verify | Verify |
| DEAD DROP choice | Locked | In named playtest baseline; inspect | Verify |
| Hardware recycling | Locked | Previously reported | Verify exactly-once |
| PATCHWORK instance persistence | Locked | Previously reported | Verify identity/save behavior |
| Ghostware / ORIGIN | Locked | Previously reported | Verify |
| NUL/REM UI/dialogue | Character direction set | Verify | Live UI testing needed |
| PAPER CUT ICE | Concept only | **Not confirmed implemented** | Balance/test pending |
| Godot 4 production build | Target chosen | **Unknown** | Unknown |

## Known outstanding work
- Acquire/inspect latest source archive and regression scripts.
- Run automated tests and conduct live Windows UI playtest.
- Reconcile exact card/ICE stats, resources, win/loss conditions, Trace formulas, virus rules, progression, and upgrade catalogs.
- Define Godot 4 migration plan and parity tests.
- Expand NUL/REM dialogue library and narrative outline after core rules are stable.

## Next-session priority queue
**P0 — Documentation review:** confirm omissions and correct any misclassified LOCKED/CONCEPT decisions.  
**P1 — Code audit:** provide latest ZIP/source; inventory files, features, and tests.  
**P2 — Regression baseline:** run tests, reproduce outstanding UI issues, document results.  
**P3 — Godot migration:** scope first playable vertical slice with rules parity.

## Handoff prompt for tomorrow
> REDLINE: Start today's development session. Use `REDLINE_MASTER_DESIGN.md` as the authority, review `REDLINE_CURRENT_STATUS.md` and the latest `REDLINE_DEVELOPMENT_LOG.md` entry. First summarize yesterday's decisions, unresolved issues, and today's three priorities. Do not assume code exists merely because a feature is designed.

## Update discipline
At session end: append a dated Development Log entry; update this Current Status; modify Master Design **only** for approved design changes, with decision IDs and statuses. Record test commands/results and changed filenames wherever possible.

---

## Design handoff — 2026-11-10: PANOPTICON

**Preferred working title:** PANOPTICON; REDLINE remains the development/repository codename until intentional rename and availability checks.

**Foundational thematic direction:** **What does humanity become when it knows it is being permanently observed and monitored?** Explore internalized observation, loss or transformation of privacy, behavioural self-regulation, diverse social adaptations, and the possibility that being unobserved becomes unsettling. Do not predetermine the answer.

**Visual direction:** locks, sealed thresholds, confinement, being locked out/in, panoptic architecture and the uncertainty of observation. DEADLOCK releases must respect corporation-turn timing.

**Structural direction:** original single-player roguelike deckbuilder; ICE primary at each defensive layer; supporting corporate defences can be layer-specific or node-wide. Corporate corruption cards and surveillance-triggered countermeasures are concepts, not implementation-ready rules. Viruses are a deployable software subtype; exact state model open.

**Next design tasks:** define supporting-defence lifecycle and counterplay; specify corruption triggers/destinations/exhaust semantics; explore panoptic visual language without compromising tactical clarity; investigate title availability before repository renaming.

**Implementation:** No new mechanics or code changes verified from this design discussion. Existing gameplay and First Signal canon preserved.


---

## Design-rule session handoff — 2026-11-11

**Authoritative rule source:** `docs/REDLINE_MASTER_DESIGN.md`. **Latest approved and committed rule: RULE-096** (DRAW changes do not retroactively remove cards already drawn). Rules through RULE-096 are saved in the Master Design; do not reopen them without explicit user direction.

**Recent locked scope:** Software source removal and queued vs already-resolving abilities (RULE-081–089); continuous effects tied to installed instances, default stacking and explicit non-stacking, PATCHWORK strength and removal (RULE-090–095); DRAW non-retroactivity (RULE-096). An installed instance ends on removal; reinstallation creates a new installed instance, but does not reset protected activation limits. With explicit non-stacking text, the strongest eligible bonus applies; without it, separate copies stack.

**Next unanswered design question — RULE-097 (NOT LOCKED):** If Runner draws 5 cards at turn start with DRAW 5, then installs +3 DRAW Software mid-turn, should no additional cards be drawn immediately, with DRAW 8 affecting the next applicable normal draw calculation? Assistant recommended yes; user has **not** answered. Ask this one question first when resuming.

**Session boundary:** User requested stopping questions now and resuming tomorrow in a new chat. No code changes or tests were performed as part of this rule-design session. GitHub Master Design commit for RULE-096: `ce1bcbc341b03ca4662d223ba98d88ca34fd1593`. Earlier status and implementation-evidence matrix are not proof of current implementation; verify source separately.

**Handoff prompt:** “Resume REDLINE design questions from RULE-097. Read the GitHub Master Design as authority; RULE-096 is the last locked rule. Ask one question at a time and commit each approved rule. Do not assume an unanswered proposal is locked.”


## Design-rule update — 2026-11-11: RULE-097

**Latest locked and committed:** RULE-097 — increasing DRAW mid-turn grants no immediate extra cards; updated DRAW applies to future applicable draw calculations. This complements RULE-096. Master Design commit: `1cbf10cbda21cc786c0d3e2cc10ad1b05cd288d2`.

**Next:** RULE-098 is OPEN; ask one design question at a time. No code changes or tests verified. The preceding RULE-097 unanswered handoff above is historical and superseded by this update.


## Design-rule update — 2026-11-11: RULE-098

**Latest locked and committed:** RULE-098 — when a draw instruction based on DRAW begins resolving, its target card count is fixed using the effective DRAW at that moment. Subsequent changes to DRAW during the instruction do not change that target. Existing shortfall and draw-trigger timing rules continue to apply. Master Design commit: `d1cf5e9da1622c7e6c0be02bd6883a985844897a`.

**Next open question:** RULE-099 — determine whether a DRAW change between two distinct draw instructions within the same resolving ability affects the second instruction. No approval yet; ask one question. No code changes or tests verified. Prior RULE-097 and RULE-098 open handoffs are historical and superseded.


## Design-rule update — 2026-11-11: RULE-099

**Latest locked and committed:** RULE-099 — each distinct draw instruction referencing DRAW calculates its target from effective DRAW at the start of that instruction, even if two such instructions occur within one ability. Example: DRAW 5; draw 5; gain +2 DRAW; draw 7. RULE-098 continues to fix each instruction's target once it starts. Master Design commit: `bc056f665eabf62a516956214128a650cba82a89`.

**Next open question:** RULE-100 — if a DRAW-based draw instruction is queued for later resolution, whether its DRAW target is calculated on queueing or when the instruction actually begins. No approval yet. No code changes or tests verified. Prior open-question handoffs are historical and superseded.


## Design-rule update — 2026-11-11: RULE-100

**Latest locked and committed:** RULE-100 (Option B) — a queued triggered Software ability with a single “Draw cards equal to your DRAW” instruction fixes its draw count from effective DRAW when it enters the FIFO queue. Example: queued at DRAW 5, DRAW later increases to 8, ability still draws 5. This is an explicit exception to RULE-098's default instruction-start snapshot; existing source-removal cancellation remains in force. Master Design commit: `17b5c4917290061064b75774fee4dadbc323a0a6`.

**Next open question:** RULE-101 — whether a queued ability containing *two separate* DRAW-based draw instructions snapshots both at queue time or only its first instruction, with the second calculated when reached. Not yet approved. No code changes or tests verified; earlier open-question handoffs are superseded.


## Design-rule correction — 2026-11-11: RULE-100 revised

**Authoritative correction:** At user's explicit direction, RULE-100's queue-time DRAW snapshot has been **replaced**. Queued triggered abilities now calculate each DRAW-based instruction from effective DRAW **when that instruction begins resolving** (RULE-098), not when the ability is queued. Example: queued at DRAW 5, DRAW rises to 8 before resolution, draw 8. RULE-099 continues to recalculate at each separate instruction. Master Design revision commit: `c39a5da2f0746d97662ed525bb35c7c8e1bd62a5`. Prior RULE-100 Option B and pending RULE-101 queue-snapshot question are superseded; retain earlier entries as historical only.

**Next single design question (not locked):** RULE-101 — when a queued ability has multiple DRAW-based instructions and DRAW changes while queued and between instructions, confirm each instruction uses DRAW at its own resolution start. Do not commit RULE-101 without explicit approval. No code changes or tests verified.


## Design-rule update — 2026-11-11: RULE-101

**Latest locked and committed:** RULE-101 (Option A) — for a queued triggered ability with multiple separate DRAW-based draw instructions, each instruction uses effective DRAW when that individual instruction begins. Example: queued at DRAW 5, DRAW rises to 8 before resolution, first draw 8, gain +2 DRAW, second draw 10. **Conflict review:** aligns with RULE-098, RULE-099, and revised RULE-100; no overrides. Master Design commit: `7dafb193b9a86b6f4d2f4683f74d9cc1d439d121`.

**Next open question:** RULE-102 — whether the instruction-start snapshot principle applies to other variable numeric quantities beyond DRAW, or remains specific to DRAW. Not approved. Ask one question and check for conflicts before committing. No code changes or tests verified. Previous open-question handoffs superseded.
