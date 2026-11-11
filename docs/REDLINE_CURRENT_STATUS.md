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
