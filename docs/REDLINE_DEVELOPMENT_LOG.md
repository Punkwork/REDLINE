# REDLINE — DEVELOPMENT LOG
**Initialized:** 2026-11-09  
**Policy:** append dated entries; distinguish reported outcomes from verified tests.

## Historical reconstruction — through 2026-11-08
*This entry consolidates known milestones; it is not a day-by-day reconstruction.*

### Design work established
- Runner/corporation ICE timing: runner action, then corporation fires remaining unbroken damage/Trace subroutines; broken DEADLOCK permits advancement after corporation turn.
- Damage terminology settled: NEURAL DAMAGE (chosen hand discard), SYNAPTIC DAMAGE (random hand discard); neither affects Integrity or permanently destroys cards. PURGE reserved for corporation virus-counter removal.
- DEAD DROP replaced Safehouse; mandatory choice of PATCH UP (+10 Integrity) **or** WIPE TRAIL (−20 Trace).
- Encounter-end hardware recycling occurs once; PATCHWORK belongs to individual card instances; Ghostware is permanent and non-card.
- UI direction established for ICE inspection, drag breakers, `[STR X]` labels, HUD tooltips, Ghostware rack and ORIGIN display.
- NUL/REM six personality modes and retro-computing voice established; PAPER CUT Strength 0 ICE discussed as a concept, not a shipped card.
- Narrative established that the First Signal is a real synchronization transmission; key hidden-AI/cipher/synchronization questions left unresolved.

### Engineering baseline (reported, not independently retested here)
- Python/Pygame reference archive: `REDLINE_Dead_Drop_Final_Playtest.zip`.
- Known file layout: `main.py`, `visual.py`, `engine/run.py`, `engine/content.py`, `engine/model.py`, and regression scripts.
- Prior handoff reported automated tests passing; Windows/Pygame live UI playtesting incomplete.
- Godot 4 selected as production engine; Python/Pygame retained as reference.

### Historical gaps
Exact dates for individual decisions, complete card lists, test output, commits, and code diffs have not been recovered. Do not backfill invented entries.

## 2026-11-09 — Documentation foundation
**Completed:** Created the three permanent reference documents: Master Design, Development Log, Current Status. Consolidated confirmed rules, narrative, UI, character direction, technical baseline, and unresolved items. Added canonical decision IDs and evidence/status distinctions.

**Code changes:** None.  
**Tests run:** None.  
**New gameplay decisions:** None; documentation only.

**Next:** (1) review Master Design for omissions; (2) obtain and inspect latest source ZIP and any detailed design files; (3) reconcile implementation status and regression coverage; (4) define first Godot 4 migration milestone.

---
## Daily entry template
### YYYY-MM-DD — Session title
**Goal:**  
**Completed:**  
**Decisions (IDs/status):**  
**Files changed / commits:**  
**Tests run and results:**  
**Bugs discovered / resolved:**  
**Open questions:**  
**Handoff for next session:**  

---

## 2026-11-10 — PANOPTICON thematic documentation

**Goal:** Preserve the surveillance/panopticon design conversation as durable project documentation.

**Documented directions:** Preferred working title PANOPTICON (clearance pending); central question of humanity's transformation under permanent observation; lock/DEADLOCK imagery; locked-out versus locked-in tension; panoptic architecture and psychological surveillance; ICE as the primary defender with layer-local or node-persistent supporting defences; deck contamination and behavioural surveillance as unfinalized gameplay concepts; viruses as deployable software subtype.

**Boundaries:** Existing ICE timing, VOID, NEURAL/SYNAPTIC damage, PURGE, First Signal canon, and gameplay architecture remain unchanged. Surveillance mechanics, corruption cards, title clearance, and narrative answers remain open.

**Code changes:** None. **Tests run:** None. **Documentation:** Bible, Master Design, Development Log, and Current Status updated.
