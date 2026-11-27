# PANOPTICON — HANDOFF (shared to-do for Codex and Claude)
**Started:** 2026-11-15 · **Owner of decisions:** the designer (John Stevers)

This is the one list of work that has been **decided but not finished**, so Codex and Claude never work from different pictures of the game. The design docs say *what* the game is; the development log says *what happened*; this file says *what's next and who does it*.

---

## Blocking documentation migration — DOCS-MIG-001

**UI-BIBLE-001 batch COMPLETE (2026-11-25, Claude; designer approved the work 11:39).** Seven sources retired, NUL/REM personality section relocated to Dialogue Architecture Appendix A, active references repaired, gate validation passed (evidence: Master Design, UI-BIBLE-001 completion). No batch open. Earlier repair commit 2f1727f.

## How we work

1. **Work on `architecture-v2` (ARCH-V2-001, designer 2026-11-23; ARCH-V2-002, designer 2026-11-25: all project work, and the repository default branch).** `main` is the preserved prototype baseline. Pull the latest `architecture-v2`, record decisions in the master design doc, report commit hashes, and ask before creating another branch or merging into `main`. ARCH-V2-002 supersedes MAIN-001's `main`-first policy **for all active project work**; the former branch history remains unchanged.
2. **The repo is the source of truth.** `docs/` here is authoritative. The Claude project "Panopticon" holds copies (`claude/REDLINE_*.md`) for claude.ai chats; Claude refreshes them from `architecture-v2` (ARCH-V2-002). `main` is the preserved legacy prototype.
3. **Who does what (DEV-001, 2026-11-18; details in `CLAUDE.md` / `AGENTS.md`).**
   - **Claude Code:** the Godot build (`godot/`), tests, fixtures, CI, exports, `REDLINE_CURRENT_STATUS.md`.
   - **Claude (Panopticon project):** design docs and proposals, playtest analysis, this file, the project copies.
   - **Codex:** small isolated tasks, only when the designer asks.
   - **Either:** small doc fixes that follow a decision already recorded.
   - **Only the designer** marks a decision APPROVED. A proposal stays PROPOSED until the designer says so in a session, and the session's log entry quotes or records that.
4. **Every change has a decision ID** (e.g. REJECT-001) that appears in the design doc, in this file and in the development log.
5. **Session routine.**
   - **Start:** pull `architecture-v2`; read this file, then the latest entries of `REDLINE_DEVELOPMENT_LOG.md`.
   - **End:** move finished items to *Done* (with the commit), add new items, and add a dated log entry that says who wrote it (`(Codex)` or `(Claude)`).

6. **Development log size (LOG-001).** Keep `REDLINE_DEVELOPMENT_LOG.md` under about **60 KB** so Claude can rewrite the project copy in one pass. When it grows past that, move the oldest dated entries, whole, to the end of `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md` (oldest first, nothing reworded) and note the move in the log. Entries stay append-only; the archive is never edited except to append.

7. **Builds (RELEASE-002, designer 2026-11-25).** Only when the designer asks: version bump on `architecture-v2` → CI passes → fast-forward `release` → verify the artifact → designer tags `playtest-N` → record. Full procedure: `AGENTS.md` / `CLAUDE.md` §5. The first Architecture V2 build waits for the RELEASE-002c gate. RELEASE-001 is history.

**Statuses:** **TO DO** (decided, not started) · **IN PROGRESS** (name who) · **BUILT** (in code, needs a playtest or check) · **DONE** · **WAITING** (needs a designer decision).

---

## Architecture migration — ARCH-V2-001 (APPROVED direction; implementation NOT STARTED)

| Item | Owner | Status |
|---|---|---|
| Preserve `main` as prototype; use existing `architecture-v2` for rebuild | Designer / agents | BRANCH CREATED; governance updated |
| Record exact prototype baseline commit, run existing tests, and create permanent baseline tag if approved | Claude Code / designer | **BUILT** (ARCH-V2-002): **DONE**: baseline recorded; tag `prototype-baseline` on `21922ad` created by the designer 2026-11-25 (verified); import 0; test_game 176/0 (also SIM=1); test_adp 17/0; test_signal_carbon 672/0; fixtures skipped (CORE_LOOP), Windows export not run |
| Reconcile `main` into `architecture-v2`; make `architecture-v2` canonical for all work (ARCH-V2-002) | Claude Code | **DONE**: merge `6b1acdd`; governance correction `b03df7f` |
| Switch the GitHub default branch to `architecture-v2` (ARCH-V2-002, approved) | Designer | **DONE** 2026-11-25 (verified via GitHub API) |
| Propose hybrid scene/component/data architecture, component boundaries, signals, resources, migration plan and acceptance tests | Claude Code (design review with Claude) | BLUEPRINT DRAFTED and STATIC SOURCE AUDIT, DEPENDENCY MAP and proposed COMPONENT ARCHITECTURE SPEC (CAS-001) added in `docs/architecture-v2/`; Claude Code runtime verification and designer architecture review required |
| Runtime inventory of CAS-001 C01–C18 and Batch 1 proposal (OPS-001 authorization 2026-11-26) | Claude Code | **DONE**: [report](operations/reports/2026-11-26-Claude-Code.md); baseline re-verified on `architecture-v2` (import 0; 176/0, SIM=1 176/0; 17/0; 672/0); VAS-001 SHA-256 recorded; N2A CAPTCHA proposed; Batch 1 and D1–D3 settled by the designer as ARCH-V2-003 (2026-11-26) |
| ARCH-V2-003 Batch 1: ICE encounter components (C02, C04, C07–C09, C18), shared rail, event flyout, playable N2A sandbox | Claude Code | **BUILT** (approved in principle): `0ae151b` record, `1e07d20` components, `8017aad` tests/CI; `test_arch_v2_ice.gd` 124/0, baseline unchanged; 19 captures, evidence in `docs/visual/fixtures/arch-v2-batch1/`; [#21](https://github.com/Punkwork/REDLINE/issues/21), [#24](https://github.com/Punkwork/REDLINE/issues/24). Geometry, drawn icons and flyout treatment PROVISIONAL until the visual reference is agreed with ChatGPT and Codex. Badge hover wording settled by the designer (ARCH-V2-003j: type only; `ICE STRENGTH: n`). *Interpretations to confirm:* amber ring for the firing key; fired rail steps dim; panels centred vertically at three ICE; Codex art drops in through `ice_panel_layout.tres` |
| VAS-ASSET-001: painted asset spec for the VAS-001 screen (ChatGPT prompts, sizes, nine-slice margins, engine/existing-art tracks) | Claude Code → designer (ChatGPT) | **PROPOSED**: [`architecture-v2/VAS-001_ASSET_SPEC.md`](architecture-v2/VAS-001_ASSET_SPEC.md). Designer runs the three ChatGPT conversations (§6); Claude Code wires delivered PNGs. LAYER/EXTRACT header content still open |
| ARCH-V2-004 Batch 2: HuCard CardView (C11), hand of cards (C10), ICE targeting, ChoiceOverlay (C15), card hover inspector | Claude Code | **BUILT, PROPOSED for visual review**: captures `docs/visual/fixtures/arch-v2-batch2/`. *Interpretations to confirm:* type colours (EXPLOIT red, CLOAK violet, ICEPICK green, EXTRACTOR gold, VIRUS olive, HARDWARE steel); rules field shows three lines, full text on hover; targeting by clicking the ICE panel (✕/Esc/second click cancels); choice wording reused from the prototype overlays; only the ten starter cards have art in the repo so far (93 more in the designer's folder) |
| ARCH-V2-005 before Batch 3: coverage table (`docs/architecture-v2/ENCOUNTER_COVERAGE.md`), `test_arch_v2_coverage.gd`, half-width turn indicator and TRACE meter, CAPS and PROTOCOLS header racks (3 slots each) | Claude Code | **BUILT, PROPOSED for visual review**: captures `docs/visual/fixtures/arch-v2-batch2/v2_18`–`v2_20`. Art: the seven §6e parts delivered and wired (ARCH-V2-005d; slots about 37 × 41 px, to confirm). Gaps for Batch 3 listed in the coverage table |
| ARCH-V2-006 Batch 3: eye/alarm/strike lamps and KEY LEGEND, Ghostware reel, rail ledger with extraction ants, log from the rail, parting shot, event flyouts incl. LOCKDOWN, virus chips, break feedback, drag to play, CACHED icon, SHOW BOARD, pile viewers, NEXT DRAW, NUL/REM speakers and mute, ResponseSequencer (C03) | Claude Code | **BUILT**; interpretations approved 2026-11-26 20:35 (ARCH-V2-006j; TRACE STRIKE banner removed); targeting arrow for targeted cards (006k, approved 20:45); PROGRAMs install by dragging onto the CRT, unplayable cards dim (006l); captures `docs/visual/fixtures/arch-v2-batch3/`. Art for the eye, reel and grilles delivered and wired 2026-11-26 (006m; red pupil pulses). PATIENT ZERO overlay still open |
| ARCH-V2-007 Batch 4: rooms through the ICE windows, corporation look (enamel, ad plate, TRACE pixel steps, mood flicker, music), graffiti, punch cards, low VITAE, PATIENT ZERO, V2 encounter in the app (C05), behaviour comparison | Claude Code | **BUILT, PROPOSED for review**; captures `docs/visual/fixtures/arch-v2-batch4/`; parity 30 encounters / 1,560 actions identical; RELEASE-002c conditions met, playtest build on the designer's word |
| CORE-LOOP-REWARD-GAP [BUG, rules]: with `Game.CORE_LOOP` on, ECHO/RIOT/VECTOR reward pools are empty and `Game._roll_rewards` fails at a full clear (present in `prototype-baseline`; found by `test_arch_v2_parity.gd`). Unreachable while the core-loop build offers only the Generalist | Claude Code (with a designer-approved fix) | **BUILT** (designer approved 2026-11-26 22:12): SHARED-pool fallback; `test_reward_pools_every_rustler` |
| ARCH-V2-003w: CRT program actions (BOOST, UNINSTALL, EJECT); optional row-return arrow mock | Claude Code | **BUILT, PROPOSED for visual review**: `v2_crt_program_actions_2x.jpg`, `v2_15_row_return_arrow_option.jpg`. *Interpretations to confirm:* action keys are drawn glyphs (▲ boost with BW cost, card-out uninstall, ⏏ eject) about 36 px; arrow off unless the designer wants it |
| ARCH-V2-003u/v: 12-card fan; horizontal counters under the meters; HuCard cartridges in the CRT rig (click = show + active); subroutine keys right-aligned, two rows past four | Claude Code | **BUILT, PROPOSED for visual review**: captures `docs/visual/fixtures/arch-v2-composition/` (`v2_14_twelve_card_hand.jpg` new). *Interpretations to confirm:* cartridge click = active program for key clicks; CRT shows name, ICE type, STR, BW break cost (rule on hover); six keys split 3 + 3; no chevron between the rows |
| ARCH-V2-003s/t: full-width ICE enclosure; CRT (rig) + effects note lower left; meters right of the hand; END TURN a small brown power button bottom right; ADP-2b hesitation speech | Claude Code | **BUILT, PROPOSED for visual review**: captures `docs/visual/fixtures/arch-v2-composition/`. *Interpretations to confirm:* the rig chips moved to the remaining CRT (the phosphor trace is dropped); END TURN drawn as a power button rather than a C64 return key; hesitation bubble 2 s; the side pipe removed |
| ARCH-V2-003r: encounter focus on avatars, subroutines, hand: large frameless avatars (≥ half the field), thin bezel, keys float over the avatar's foot, momentary speech bubbles, raised lit-from-within keys | Claude Code | **BUILT, PROPOSED for visual review**: captures `docs/visual/fixtures/arch-v2-composition/` (`v2_02*`, `v2_10*`, `v2_keys_zoom_2x.jpg`). *Interpretations to confirm:* bubble shows 1.6 s then fades 0.2 s (no fade under reduced motion); key state colours (cream-amber ready, red DEADLOCK, bright red hit, amber tumbled, dim amber booting, unlit broken, smoked hidden); the separate key lamp is dropped (the cap's light is the state); keys centred over the avatar's foot; three-ICE avatar centred with the name across the top |
| ARCH-V2-003o/p: fanned hand; three-ICE panel with large revised avatars; speech-bubble zone on every panel | Claude Code | **BUILT, PROPOSED for visual review**: captures `docs/visual/fixtures/arch-v2-composition/` (`v2_02*`, `v2_10*`). *Interpretations to confirm:* fan tilt 3.5°/card (max 10°), 12 px overlap, 14 px arc, 26 px lift; bubble stays empty in play until its trigger is decided (fixtures show approved ADP mood lines); two-ICE portrait kept at its size so five keys stay ≥ 44 px. Missing avatar moods: TERMS_OF_SERVICE wary, HOUSE_CALL cheery and wary |
| ARCH-V2-003 composition pass: encounter composed to VAS-001 with the painted parts; icon-first instruments; END TURN key (ARCH-V2-003m) | Claude Code | **BUILT, PROPOSED for visual review**: captures `docs/visual/fixtures/arch-v2-composition/`; `test_arch_v2_ice.gd` 127/0, baseline unchanged. *Interpretations to confirm:* phase plaque icons (fanned hand = Rustler, lens = Corporation); RAM chip glyph; hourglass beside the turn counter; small CRT shows a quiet phosphor trace (content open); effects card stamps CORTEX and next-turn BW drain only; HOSTILE REVEAL, LAYER and EXTRACT left out (content open); ad plate uses the approved HALCYON programme line; three ICE use a compact panel (narrow portrait) to keep keys ≥ 44 px |
| Build one representative playable ICE encounter without changing approved rules | Claude Code | IN PROGRESS: Batch 1 built (row above); Batches 2–4 (cards/choice, HUD/C03 sequencer, integration) next |
| Compare behavior against prototype; demonstrate second corporation skin without duplicating the encounter UI | Claude Code | TO DO; after first encounter |
| Design and approve a release procedure for builds from `architecture-v2` (RELEASE-001 still covers prototype builds from `main` only) | Designer / Claude Code | **DONE** 2026-11-25: RELEASE-002 APPROVED with (a), (b), (c); procedure in AGENTS/CLAUDE §5; (b) built in the workflow |
| Create a GitHub ruleset on `release` blocking deletion and force-pushes (RELEASE-002a) | Designer | **DONE** 2026-11-25: ruleset `release` (id 28104142), active, target `refs/heads/release`, rules deletion and non_fast_forward, no bypass; fast-forward cuts still allowed; verified via GitHub API |
| Seed GitHub Issues for UI work (UI-WORKFLOW-001): none existed at reconciliation | Claude | **DONE** 2026-11-25: label `ui` plus seven `status:` labels (proposed → complete); issues [#13](https://github.com/Punkwork/REDLINE/issues/13)–[#23](https://github.com/Punkwork/REDLINE/issues/23). The issues are authoritative for those items |
| Update external agent configurations that still name `main` (ChatGPT, Codex, automations) | Designer / ChatGPT | **DONE** 2026-11-25: ChatGPT (reported: Daily Review and Interface Improvement on `architecture-v2`); Codex (alignment check 11:36: cloud checkout at `b1f14e6` from `architecture-v2`, on Codex's usual local branch `work`; AGENTS.md rules confirmed; no instruction or automation points work at `main`). Codex's GitHub authorization had been removed and was reconnected by the designer |
| Designer acceptance of the ARCH-V2-002 reconciliation (Gate F) | Designer | **DONE** 2026-11-25 08:23: "Reconciliation accepted." Untested and outstanding items stay open |
| Enable GitHub protection for `main` (block pushes, force-pushes and deletion), ARCH-V2-002j | Designer | **DONE** 2026-11-25: ruleset `protect-main` (id 28076208), active, target `refs/heads/main`, rules deletion / non_fast_forward / creation / update, no bypass; verified via GitHub API |
| Refresh the Claude Project copies (`claude/*.md`) from `architecture-v2` (designer chose "pointer + core docs", 2026-11-25; the full set no longer fits the 2 MB Project limit) | Claude | **DONE** 2026-11-25: Project holds `claude/README.md` plus current copies of AGENTS_CLAUDE (= CLAUDE.md), HANDOFF, CORE_RULES, CORE_LOOP and ARCHITECTURE_V2_README. The 21 older copies and TODO, MINIBOSSES, ICE_EFFECTS were deleted (designer: "Just archive them"; git history is the archive). The Project's Core Loop v0.2 spec, which had text not in the repo, is preserved at `docs/history/REDLINE_CORE_LOOP_v0.2_PROJECT_SPEC.md` |
| Commit-pin the UI Bible's seven `blob/main/...` source links before retiring the sources (DOCS-MIG-001) | Claude | **DONE** 2026-11-25: pinned to `8ef0bbe`, the last commit with the originals |

Existing gameplay and visual tasks below remain tracked; reassess their target branch and priority during migration planning rather than silently changing rules or treating them as completed.
**Priority 1 companion (UI-TYPO-001 / UI-TYPO-001a, 2026-11-26).** The designer confirmed the typography and motion exploration constraints and the parallel [M06 milestone](REDLINE_MASTER_DESIGN.md#typography--motion-design-system-milestone-m06--priority-1-companion). Carry the event inventory, hierarchy and motion requirements into CAS-001 review alongside [#21](https://github.com/Punkwork/REDLINE/issues/21). Follow [#24](https://github.com/Punkwork/REDLINE/issues/24) for UI work and approval evidence. Implementation and acceptance are pending.


## 2026-11-26 — Representative encounter inventory authorization (ARCH-V2-001 / CAS-001 / VAS-001 / OPS-001)

**Designer-confirmed Priority 1:** Representative playable ICE encounter. Designer approved the development sequence: ICE/subroutine interaction; card-playing interaction; resources/status; turn/response; encounter completion; visual/sensory refinement. VAS-001 canonical [mockup](https://github.com/Punkwork/REDLINE/blob/architecture-v2/godot/assets/architecture_v2/references/PANOPTICON_VAS-001_reference_mockup.jpeg) is central from the first component, not a late skin. Typography and motion (UI-TYPO-001/a, #24), including stage and transition announcements, are required in the representative encounter and developed in parallel. Exact treatments remain for review.

**Explicit authorization:** “the 2 technical inventories are authorized.”
- **Claude Code:** functional/runtime inventory of all CAS-001 C01–C18 contracts, existing source, dependencies, runtime and applicable tests; classify reuse/adapt/complete/build/validate; propose representative encounter and first C07–C09 batch with C02/C04/C18 dependencies, exact file ownership and evidence.
- **Codex:** independent visual/asset inventory against VAS-001 and UI Bible; inspect existing art, fixtures, fonts, controls, typography, motion and announcement capabilities; classify reuse/adapt/create, identify gaps and propose isolated fixture tasks with file ownership.

Both may start immediately on architecture-v2. Read AGENTS.md/CLAUDE.md and canonical specs first. Inventory and non-mutating runtime/test investigation only; no production edits, new branches, merges, release changes, rules changes or overlapping implementation. File actual findings in shared dated operations reports; link evidence and #21/#24, distinguish verified from unverified. Stop for designer review before production implementation. Detailed development prompts follow inventory findings. Other November 26 ranks remain proposed.

**Codex fixture assignments built (VAS-001 / UI-TYPO-001).** The designer approved the two isolated studies. Both can be run from `godot/tests/visual/` with Godot 4.3. Evidence and remaining production decisions are tracked in [#21](https://github.com/Punkwork/REDLINE/issues/21) and [#24](https://github.com/Punkwork/REDLINE/issues/24).

## NUL-PILLAR-001 — foundational design follow-up (WAITING)

**NUL-PILLAR-001a:** Designer-confirmed Psychological Invisibility is a binding design constraint for this work: no player-facing psychological progression disclosure, scores, classifications or announcements, including retrospective records. Internalization is emergent, not a programmed status. Review all future NUL/REM proposals against the expanded design document; no implementation authorized.

Designer-confirmed creative direction, 2026-11-23. Read [REDLINE_NULREM_BEHAVIOURAL_LOCK_IN.md](REDLINE_NULREM_BEHAVIOURAL_LOCK_IN.md), archived in f2b938b. Claude (design): reconcile with BOON-001, current NUL/REM canon, SIGNAL-001, local profile and core-loop rules; develop domain-specific knowledge/confidence/authority and intervention proposals for designer review. No implementation authorized. Claude Code: no build task yet.

## To build (approved, not yet in the build)

### ARCH-V2-008a: next build (designer, 2026-11-27 06:16)

| ID | What | Owner | Status |
|---|---|---|---|
| **ARCH-V2-008a** | Add READY RIG to the Ghostware slot on the encounter screen. Now: the reel already lists READY RIG first as the Generalist's ORIGIN, but there is no `GW_READY_RIG.png`, so the slot shows the initials "RR". Needed: READY RIG art or icon in `godot/assets/concept/ghostware/`, its rules text on hover, and a screenshot fixture. | Claude Code | **BUILT** (`godot/assets/concept/ghostware/`, all 30 designer icons at 256 px; test in `test_arch_v2_batch4.gd`; fixture `docs/visual/fixtures/arch-v2-batch4/v2_02_ready_rig_reel_zoom.jpg`); ships in the next build |
| **RUSTLER-SELECT-001** | The Rustler select screen shows the designer's portrait as the Rustler's button, in place of the name; hovering or focusing it shows the name, difficulty, quote, style and ORIGIN on an opaque panel. Generalist only (STRIP-001). ECHO, RIOT and VECTOR portraits are in the designer's `Rustler Select` folder for when they return. | Claude Code | **BUILT** (`main.gd`, `godot/assets/concept/rustlers/`; `test_arch_v2_app.gd`; fixtures `docs/visual/fixtures/rustler-select/`); ships in the next build |
| **ARCH-V2-008b** | END RUN on the V2 encounter screen: a small, quiet plate centred under END TURN (Build 12's RUN-001 button). It asks for confirmation (YES, END THE RUN / KEEP PLAYING) before the run ends; unavailable during the Corporation Response. Also fixed: the app's dialogs now draw above the V2 screen's raised layers (hand cards showed through, and could be clicked, under the dialogs). | Claude Code | **BUILT** (`hud_widgets.gd` EndRunKey, sandbox, controller, `main.gd`; `test_arch_v2_app.gd`; fixtures `docs/visual/fixtures/end-run/`); ships in the next build |
| **CAPS-TEST-001** | CAPS in the game for testing. Engine: the five common CAPS (BW SPIKE, BULWARK, FLUSH, NANOSUTURE, CRACKER; UPL-002), 3 slots, 0 BW, the Rustler's turn only, single use (UPL-001). The CAPTCHA Node's full clear adds a random common CAP alongside the card reward; the reward screen shows the vial and effect. V2 rack: the designer's vials; click injects; CRACKER aims at an ICE like a targeted card; hover shows the full vial. Not built: uncommon/rare CAPS, Uplink purchase, the 20% BREACH drop, Node-completion CAP choice. | Claude Code | **BUILT** (`cards.gd` CAPS, `game.gd` `use_cap` / `grant_random_cap`, adapter, controller, rack, `main.gd` reward; `test_game.gd` `test_caps`, `test_arch_v2_batch4.gd`; fixtures `docs/visual/fixtures/caps/`); ships in the next build. Full slots: a discard prompt is wanted later (designer, CAPS-TEST-001a), not in the next build. CRACKER confirmed: STR never below 0 or the ICE's minimum; hint "Drag onto an ICE" (CAPS-TEST-001b). *Interpretations to confirm:* CRACKER aims with the arrow, others inject on click; sockets show a close-up of the vial's glass and symbol |

### STRIP-001: core-loop test build (designer, 2026-11-21)
Spec: `REDLINE_CORE_LOOP.md`. Playtest sheet: `REDLINE_CORE_LOOP_CHECKLIST.md`.

| ID | What | Owner | Status |
|---|---|---|---|
| **STRIP-001, BW-001, PROBE-001, PROBE-003, BREACH-001, TURN-001, BURST-001, STR-001** | Rules and data behind `Game.CORE_LOOP` | Claude Code | **BUILT**, see the 2026-11-21 log entry; awaiting Playtest 8 |
| **MAP-003** | 14 Nodes (7 ICE + 7 mixed, one may be ICE) + boss per corporation; multiple paths; full CRED extraction reveals about 3 Nodes ahead; no escape | Claude (design), then Claude Code | WAITING on the open details in the master doc |
| **MAP-003c** | 16-row map generator: row 1 ICE, row 9 one mini-boss + ICE, row 16 boss, 3–4 Nodes per row elsewhere, every path exactly 8 ICE (incl. row 9) + 7 other Nodes. Prototype `prototypes/map/map003_generator.py` (Claude): each Node tracks the ICE count to reach it and links only join matching counts, so every path is valid by construction; 1000/1000 seeds pass. v2 (designer, 2026-11-22): every path has **at least 3 SAFEHOUSE + Uplink combined, at least 1 of each**; loose spacing ("can be a little loose"): at most 4 ICE or 4 non-ICE Nodes in a row on any path. Built by repairing failing paths (an other Node becomes a SAFEHOUSE or Uplink), then rejecting maps that break spacing: 37% of seeds accepted, every path of 200 maps checked. v3 (MAP-003d): every path also has at least one of each Node type 3–8 (Uplink, Clinic, DEAD DROP, Console Lab, SAFEHOUSE, SIGNAL UNCLEAR); 37% of seeds accepted, every path of 200 maps checked. v4 (MAP-003e): Uplink and Clinic merged, five other types, 1+ of each and 3+ SAFEHOUSE + Uplink per path; 37% of seeds accepted. Clinic counter prices: CLINIC-001. To do: port to GDScript with a test (regenerate until valid). | Claude (spec), then Claude Code | PROPOSED |
| **MINIBOSS-002** | Mission statements and the three mini-bosses approved (`REDLINE_MINIBOSSES.md`) | Claude Code (build with the MAP-003 map) | TO DO |
| **MINIBOSS-001, MAP-003a** | Optional mini-boss with a unique ability (off some paths); rewards 1 of 3 rares + Ghostware + CAP + CRED; next-row icons always, 3 Nodes ahead after a full extraction | Claude (design: map spec, three mini-bosses) | WAITING on the two counts in the master doc |
| **BOON-001** | NUL/REM offers 2–3 randomized boons (some with drawbacks) at the start of each corporation; new HARDWIRED card status (HARDWIRED-001, approved; shared with EVENT-004) | Claude (design: boon pools per Rustler, the status) | TO DO |
| **EFFECTS-001** | ICE effect table and learning order (`REDLINE_ICE_EFFECTS.md`) | Claude | PROPOSED |
| **RIDER-001, AMEND-001, DEFRAG-001, PLAY-002** | TRACE riders and JAMMER; CONSENT FORM with AMEND in TERMS & CONDITIONS; DEFRAG discard-then-draw; visible parting shot and per-type sounds (placeholders) | Claude Code | **BUILT**, awaiting Playtest 11 |
| **PLAY-002 polish** | Final sounds, and per-type animations beyond the PULP shake (TRACE pulse, CORTEX static, card tear, ICE swell, glass); new effect icons on the keys | Claude Code | TO DO; tracked in [#18](https://github.com/Punkwork/REDLINE/issues/18) |
| **CARD-HUCARD-001** | Hand cards shaped like a PC Engine HuCard (designer, 2026-11-22; reference photo `docs/visual/references/hucard_reference.png`): portrait, credit-card proportions (about 54 × 85, 1 : 1.58), rounded corners, a thin visible edge on the side and bottom in a slightly darker white: a thick card about as deep as 3–4 credit cards stacked, **not** a chunky cartridge (designer, 2026-11-22), **gold contacts along the bottom edge**, and a picture area slightly smaller than today's. Ignore the HuCard's black label area. Cards get taller on screen than today's small faces. No HuCard, NEC or game branding on our cards: the shape and finish only. Pairs with removing the deck/discard wells to give the hand more room (Playtest 9 sheet). | Claude Code | TO DO (UI batch); tracked in [#13](https://github.com/Punkwork/REDLINE/issues/13) |
| **PT11-BUG-1 [BUG]** | Clicking PROXY CHAIN on the RACK (where the "CHAIN" text is) opened an overlay that stayed on screen through the card reward, the next Node and the next encounter, covering DOORBELL CAM; the game was unplayable (Playtest 11 sheet). **Fixed:** a pinned card now closes on any click on it, a click outside it, or when the screen moves on (reward, map, next encounter). | Claude Code | **BUILT**, Playtest 12 |
| **PT11-UI** | Playtest 11 sheet: (1) show the parting shot's total before END TURN after a BREACH; (2) PULP Shield and other untargeted cards play when dragged anywhere outside the hand, not onto an ICE; (3) key and card hovers explain HARDEN, AMEND, RETALIATE, SHIELD BREAK and riders in words; (4) dim unplayable cards (about 25%) when there isn't enough BW. **Built:** the PULP INCOMING row becomes PARTING SHOT (PULP · TRACE) after a BREACH and END TURN's tooltip states it; untargeted cards play when dropped anywhere above the hand tray; key tips explain HARDEN, SHIELD BREAK, RETALIATE, AMEND and riders; unplayable cards dim to 72%. | Claude Code | **BUILT**, Playtest 12 |
| **[UI] Discard view** | While choosing a discard, let the player toggle back to the board (Playtest 10 sheet) | Claude Code | TO DO (with the UI batch); tracked in [#15](https://github.com/Punkwork/REDLINE/issues/15) |
| **BOOST-001, SUB-001** | Boosts last the turn; new subroutines, HARDEN, SHIELD BREAK, RETALIATE, CORTEX on VOIDs, DEADLOCK ×2 | Claude Code | **BUILT**, awaiting Playtest 10 |
| **Playtest 9 UI list** | The ten [UI] items in the designer's Playtest 9 sheet: hover flicker at card overlaps and hand edges, encounter not centred on the corporation background, installed programs wider than the CRT, select screen says 4 BW, map shows ICE names (show layer count only), speech-bubble text not centred, remove the deck/discard wells to give the hand more room, cards as PC Engine HuCards (thickness, rounded corners, contacts; taller), VOICE / M doesn't mute NUL/REM | Claude Code | TO DO (batch after Playtest 10); tracked in [#14](https://github.com/Punkwork/REDLINE/issues/14) |
| **FORM-001, FORM-002** | ICE forms by STR and breaks (LETHAL doubles PULP and TRACE; Black ICE look only); TRACE +2, PULP +1 | Claude Code | **BUILT**, awaiting Playtest 9 |
| **CACHE-001** | Engine: CACHED cards are discarded between layers (built). **UI: the ∞ / N-turn corner icon** | Claude Code | Engine BUILT; icon TO DO, tracked in [#17](https://github.com/Punkwork/REDLINE/issues/17) |
| **PROBE-004** | PROBE choose-one, same costs: −2 STR **or** reveal all face-down subroutines on a VOID; −2 STR no longer reveals; shared PROBE-003 counter; choice shown only on a VOID; card text, rules tests, bot mode choice, checklist question 8. *Interpretation to confirm:* reveal **all**, not one. | Claude Code | TO DO |
| **PROBE-003 UI** | Show PROBE's cost while it's dragged over an ICE (the hand shows the cheapest cost today) | Claude Code | TO DO; tracked in [#16](https://github.com/Punkwork/REDLINE/issues/16) |
| **STRIP-001 follow-ups** | Threat check after Playtest 8 (bot: CAPTCHA node deadliest); RIOT rethink; dead-card audit; re-baseline the PACE targets for 3 BW | Claude | WAITING on Playtest 8 |
| **Designer UI and interface list** | Bugs and missing Playtest 7 items the designer will list | Designer, then Claude Code | WAITING |

### Start here (Codex): decisions made 2026-11-16
ZEROED-001, its RIOT cards, and TUMBLE-001 are built; see the tagged rows below. ROT-001 documentation sync and LOG-001 split were already completed in PR #8. No remaining Codex TO DO rows from this block. VIS-001 is built on `main`; see Built below for the review tag.

**Next build: everything in `REDLINE_DECK_SYNERGY.md` (DSY-001 to DSY-014) and `REDLINE_PACING.md` (PACE-001 to PACE-010), approved as written on 2026-11-15.** Suggested order, so each step can be playtested before the next; numbers are working values. Where a system isn't in the slice yet (Uplink, Console Lab, PATCHWORK, Ghostware), build the part that touches it when that system arrives, and say so in the log.

| ID | What to build | Spec | Owner | Status |
|---|---|---|---|---|
| **PACE-004, 010** | Score each slice layer (BREACH WORK, REVEAL FLOOR, VITAE) from playtest 2's turns and VITAE; propose ICE changes. | Pacing §4.1, §9 | Claude | WAITING on Playtest 6 results and the bot sims (designer, 2026-11-18) |
| **DSY-014, PACE-007** | Phase 7 pools on the synergy grammar, with 2 HULL engines per Rustler pool. *(RIOT's ZEROED keyword written up: ZEROED-001.)* | Synergy §5.1, Pacing §6 | Claude | WAITING on Playtest 6 results (designer, 2026-11-18) |
| **EVENT-002/003** | SIGNAL UNCLEAR: when the events are built, MAINTENANCE WINDOW is a choice (heal 6 VITAE or −5 TRACE), the new CARE PACKAGE event (+5 Max VITAE, also +5 current, or a random rare card) joins the pool, and odds become AMBUSH 20%, BROKER 5%, the other eight 9.4% each. Every non-AMBUSH event must offer a choice; add a test. | Upgrades §3 | Claude Code | TO DO (with the SIGNAL UNCLEAR build. DEV-001b: the slice map has no SIGNAL UNCLEAR Node yet, only ICE and SAFEHOUSE, so this waits for that Node) |
| **EVENT-004** | Design the "powerful Ghostware with a permanent price" SIGNAL UNCLEAR event. Designer: "a specific ghostware that bestows a negative, a permanent bloatware in their deck that can't be removed through normal means"; "because of how powerful it is, it comes with a negative"; option B, "needs designing". Starting proposal (Claude, not approved): working name COMPLIMENTARY UPGRADE, offered by the corporation; one per corporation: HALCYON PREMIUM MEMBERSHIP™ (+1 BW and +1 DRAW every turn; Bloatware TERMS OF SERVICE), IRONWATCH PRIORITY RESPONSE™ (first break each turn 0 BW, Icepicks +1 STR; WATCHLIST: +2 TRACE if in hand at end of turn), LUCIDA LUCID DREAMING™ (+3 cards at encounter start, CACHE 1 free each turn; RECURRING DREAM: CORTEX 1 if in hand at end of turn). Each Bloatware: pay 1 BW to clear for the Node, returns every Node, immune to Wipe, Console Lab, DATA PURGE, DECOMPILE and FUSE. Decided: **each corporation has its own version** (designer, 2026-11-18). Open: any abnormal way out; counts toward the deck-size cap (default no); odds (default about 5%); powers need sim balancing (about double today's best Ghostware). | Upgrades §2–3; Facades | Claude | TO DO (design; can go with EVENT-001 after Playtest 6) |
| **EVENT-001** | Expand and re-theme the SIGNAL UNCLEAR event pool (designer, 2026-11-18: "those could be a source of great variability for the player"). Today: 9 mechanical events (Upgrades §3) that predate ZINE-002/003, ARCH-001 and the corporate facades, so repeats come fast. Propose more events, and re-theme the existing ones, in the world's voice: *NOTES FROM THE ’PELAGO* drops, another crew's samizine, pirate broadcasts, corporate "wellness checks", care-home postcards; choices that touch TRACE, CRED, cards, CAPS and oblique SIGNAL-001 hints (no reveal before the third card). Use Playtest 6 notes on checklist I3. | Upgrades §3; ADP §2.2; ARCH §4–6 | Claude | WAITING on Playtest 6 results (designer, 2026-11-18) |

**Claude Code migration (DEV-001, approved 2026-11-18):**

| ID | What | Owner | Status |
|---|---|---|---|
DEV-001b is done (see *Done*). Its fixes are below.

**DEV-002: fixes from the DEV-001b audit (PROPOSED, Claude Code, 2026-11-19; b, c and h APPROVED by the designer 2026-11-21, the rest still PROPOSED).** The evidence is in the [DEV-001b log entry](REDLINE_DEVELOPMENT_LOG_ARCHIVE.md#2026-11-19--dev-001b-read-only-audit-of-code-docs-and-architecturemd-claude-code). Rows marked *docs* follow decisions already recorded. The others change code or need a designer choice.

| ID | Proposed fix | Kind | Owner | Status |
|---|---|---|---|---|
| **DEV-002a** | ICE Corp 1: in the §5.0 "Slice route", show one layer per Node (PACE-008); mark §6's HOUSE CALL numbers as replaced by §5.0 (STR 7, PULP 6 + 6, TUNE-001). | docs | Claude | PROPOSED |
| **DEV-002b** | Record the reserve rounding: PACE-008's +50% is rounded up (COOKIE BANNER 23, Tier 1 layer 15). Add notes to Core Rules §10.1a, ICE Corp 1 §8.2/§8.4 and the CORE-012 example (15 → 23). **Designer: "CONFIRMED" (2026-11-21).** The code already rounds up; docs only. | docs | Claude | TO DO |
| **DEV-002c** | Ad and LUCIDA-edit wording: move `PlayProfile.AD` and `Game.LUCIDA_RECORD` from code into `data/adp_copy.json` with `approval` fields set to approved, so the copy test scans them. **Designer: "APPROVED" (2026-11-21): the wording that shipped in `playtest-6` is approved as it is** (closes the ADP-3 interpretation). | code + copy | Claude Code | TO DO |
| **DEV-002d** | Copy-guard coverage: `AdpCopy.pool()` also calls `ArchCopy.valid_line()`, and a test runs every string literal in `godot/scripts/` (mascot lines, `main.gd` text) through the guard. Nothing fails today; this keeps it that way. | code + test | Claude Code | PROPOSED |
| **DEV-002e** | Island names: once ARCH-NAMES-001 settles, relocation lines name their island through a placeholder (e.g. `[HOME]`) filled from the island row, replacing the literal names and `CarbonRecord.ISLAND_INDEX`. Keep the stored `relocation_id`s and the island text in old CARBON records readable. | code + copy | Claude Code (after ARCH-NAMES-001) | PROPOSED |
| **DEV-002f** | Write `redline_flags.json` through `LocalRecord.write()` (temp file, then rename) like the other two records; today `main.gd` `_save_flags()` overwrites the file in place. | code | Claude Code | PROPOSED |
| **DEV-002g** | Correct `ARCHITECTURE.md`: the flags file, `shot.gd` and the fixtures that assert nothing, the missing phases (`SELECT`, `DECOMPILE`, the unused `DEAD_DROP` branch), what the copy guard actually covers, and the unmapped files (`synergy_cases.gd`, `icon.gd`, the voice `.ogg` lookup, the unused `audio/nulrem/manifest.json`, the export `data/*.json` filter). In CLAUDE.md = AGENTS.md §4, change "each `shot_*.gd`" to "each script". | docs | Claude Code | PROPOSED |
| **DEV-002h** | CI: the `paths` filter covers only `pull_request`, so every push runs full validation and every push to `release` exports, docs-only included. That contradicts the RELEASE-001 log note. **Designer: "YES" (2026-11-21): add the same `paths` filter to `push`, so doc-only pushes skip validation and export.** Also make `shot.gd` and `shot_reel.gd` fail when a PNG can't be saved. | CI | Claude Code | TO DO |
| **DEV-002i** | Refresh `REDLINE_CURRENT_STATUS.md`: 361 rules checks (it says 357), DEV-001 ownership, and DEV-001b. | docs | Claude Code | PROPOSED (with the next code commit) |

Hygiene, recorded and left alone under the no-refactor rule: the unused local `odds` in `_roll_rewards()`, the phase comment at `game.gd:21`, and mixed indentation between files. Fix each only when that code is next touched for an approved change.

**Audio (approved direction 2026-11-19; sound chosen 2026-11-21):**

| ID | What to build | Spec | Owner | Status |
|---|---|---|---|---|
| **PIXEL-TRACE-001b** | Bit-crush the corporation's music with the TRACE pixel steps: a crush spike during each 0.5 s step transition, then a light held crush that deepens toward Mask off. Music bus only, so it mutes with music; plays with reduced motion on. The transition sound effect is PIXEL-TRACE-001c, the row below. Add the values to `atomic_deco_punk.json` and an audio capture per step for the designer to tune by ear. | Master PIXEL-TRACE-001b | Claude Code | TO DO |
| **PIXEL-TRACE-001c** | **Neon ballast buzz** on each pixel-step transition (designer, 2026-11-21: "NEON BALLAST BUZZ"), alongside the bit-crushed music. Working proposal: a short buzz and flicker hum the length of the transition, on the effects bus (not music), so it plays with music muted; it plays with reduced motion on. Add it to the per-step audio capture. | Master PIXEL-TRACE-001c | Claude Code | TO DO (build with 001b) |

**Cards and hand (approved 2026-11-19):** CARDS-004 and HAND-MAX-001 are built; see Built below.

**UI items are tracked in GitHub Issues (UI-WORKFLOW-001):** the issue is authoritative for any UI row that links one; ENC-CONCEPT-001 review is [#22](https://github.com/Punkwork/REDLINE/issues/22), the VAS-001 vertical slice [#21](https://github.com/Punkwork/REDLINE/issues/21), Ghostware rail [#19](https://github.com/Punkwork/REDLINE/issues/19), resource indicators [#20](https://github.com/Punkwork/REDLINE/issues/20). New UI work starts as an issue, not a row here. UI-TYPO-001 (typography, physical and virtual worlds; APPROVED 2026-11-25) is [#24](https://github.com/Punkwork/REDLINE/issues/24); its four reference images are in `docs/visual/references/ui-typo-001/` (2026-11-25).

**Encounter redesign (ENC-CONCEPT-001, APPROVED direction 2026-11-19):** the interface follows the three concept screenshots: frame from concept 3, cards and mascots from concept 2, left HUD mixing 2 and 3 with installed Programs in the CRT panel. ICE-ANALOG-001's icon keys and key tips are built (`b3fdd42`) and get restyled to concept 3. ENC-ANALOG-001's flip-clock HUD is superseded. References: `docs/visual/explorations/ice-analog-001/`.

| ID | What to build | Spec | Owner | Status |
|---|---|---|---|---|
| **ENC-CONCEPT-001 interface** | Concept-3 frame built: top bar (PANOPTICON plate, network/node plate, decal plate for graffiti, CONDITION pill, HOSTILE REVEAL %, TURN/TRACE/RESERVE flip tiles, strike lamps); ICE consoles with arched corp tab, power lamp, STR plate, icon keys, reel column, PASSIVE and per-ICE NEXT RESPONSE plates; left CRT with status and installed Programs; vitals with icons (VITAE, BANDWIDTH, SHIELD, PULP INCOMING, NEXT DRAW); NUL/REM note and round red END TURN on the right. The shared response strip is replaced by per-ICE plates. Painted with the ChatGPT UI kit (console 9-slice, key caps, plates, END TURN, tooltip, CRT, vitals). | Master ENC-CONCEPT-001 | Claude Code | BUILT (commit in dev log 2026-11-19), awaiting designer review |
| **ENC-CONCEPT-001 cards** | Smaller white concept-2 cards: ChatGPT card frame per type + picture per card, the game writing the name, BW cost and corner icons; rules on hover (no rules text on the face); a smaller hand that keeps the CARDS-004 fan rules (overlap and tilt grow with the card count); load `godot/assets/concept/cards/<CARD_ID>.png`. Built at `FriendlyCard.DISPLAY_SCALE` 1.0; cards without a picture show a tinted stencil. | same | Claude Code | BUILT, awaiting designer review |
| **ENC-CONCEPT-001 art** | Mascots (batch 1: AUTO_RENEW, CAPTCHA × 3 moods; batch 2: the rest of the slice) and card illustrations (batch 1: Generalist starter + SPAM/TRACER; batch 2: other starters) generated in ChatGPT. Batch 1 delivered and imported (6 mascot moods, 4 frames, 10 pictures). | `docs/visual/concept-art/ART_BRIEFS.md` | Designer | Batch 1 DONE; batch 2 TO DO |
| **ENC-CONCEPT-001 UI kit** | Painted interface parts from ChatGPT (console, key caps, top bar, CRT, vitals, END TURN, tooltip, frame, backdrop, icons) so the screen matches the concept screens. | `docs/PANOPTICON_UI_DESIGN_BIBLE.md` (Source 5) | Designer | DONE (delivered and imported; backdrop unused until the corp-background decision) |
| **ENC-CONCEPT-001 UI kit 2** | The concept-2 parts not in kit 1: brand plate, corp sign, HOSTILE REVEAL alarm, CRT pictures per condition, lamp stack, knob, vent, slot panel, comic speech bubble, TUMBLER drum, hand tray, END TURN box, legend card. Claude wires each as it lands. | `docs/PANOPTICON_UI_DESIGN_BIBLE.md` (Source 6) | Designer (ChatGPT), then Claude Code | DONE (delivered); wired in the concept-2 layout pass, awaiting designer review |
| **ENC-CONCEPT-001 UI kit 3** | Layout parts for concept 2: console with concept-2 inner layout, big key sockets, TURN plate, TRACE counter, dials, strike lamps, NUL/REM slip, deck/discard wells, card back, tray buttons, toggles, pipework, screws, key glow, log ticker, vignette. Then Claude does the concept-2 layout pass. *Interpretation to confirm:* homes for strikes, reserve, CRED/RAM, deck, discard, END RUN and the NUL/REM note. | `docs/PANOPTICON_UI_DESIGN_BIBLE.md` (Source 7) | Designer (ChatGPT), then Claude Code | DONE (delivered); wired in the concept-2 layout pass, awaiting designer review |
| **ENC-CONCEPT-001 concept-2 layout pass** | Full encounter layout rebuilt around kits 1–3 (see master ENC-CONCEPT-001). Unused for now: UI_TUMBLER_DRUM (too tall for the key band at this scale), UI_KEY_BIG_FRAME (concept 2's keys sit straight on the band), UI_SLOT_PANEL, UI_KNOB, UI_LAMP_STACK, UI_CARD_BACK, UI_SPEECH_BUBBLE_ALT. ICE without painted mascots (batch 2) still show the drawn appliance, scaled into the cabinet. | Master ENC-CONCEPT-001 | Claude Code | BUILT, awaiting designer review |
| **ENC-CONCEPT-001 program screen** | CRT shows the active program with ◀ ▶ rotate, +STR, ×, drag-to-break; key clicks use the program on screen (fallback: cheapest Icepick). | Master ENC-CONCEPT-001 | Claude Code | BUILT, awaiting designer review (not yet in a playtest build) |
| **ENC-CONCEPT-001 mascots batch 2a** | ACCEPT ALL and REJECT ALL, three moods each, from the prompt in `ART_BRIEFS.md`. Claude wires them when they're in the art folder (no code change needed: the files are picked up by name). | `docs/visual/concept-art/ART_BRIEFS.md` | Designer (ChatGPT), then Claude Code | DONE: all six imported and showing on COOKIE BANNER |
| **ENC-CONCEPT-001 program cartridges** | Slim cards stick out of the CRT's top, one per installed program; click to put one on screen. | Master ENC-CONCEPT-001 | Claude Code | BUILT, awaiting designer review |
| **MOOD-PIXEL-001** | Avatar mood changes drop into 16-bit and resolve; lethal avatars pulse 2 s 16-bit / 2 s crisp. **Designer, 2026-11-21:** back to normal resolution after each transition, the 2 s / 2 s lethal pulse, and reduced motion skips the pulse are confirmed. *Still to confirm:* the 0.8 s change timing. Not in Playtest 7 (built after it). | Master ENC-CONCEPT-001 | Claude Code | BUILT, awaiting designer playtest |
| **ChatGPT round 3** | Card pictures (18 starters + 65 reward cards in three parts), the six remaining HALCYON avatars under AVATAR-001, and six corporation backgrounds. The game picks all of them up by file name. | `docs/visual/concept-art/CHATGPT_PROMPTS_ROUND3.md` | Designer (ChatGPT), then Claude Code | WAITING on the files |
| **ChatGPT round 4 (Node types and map)** | Backgrounds for Uplink, SAFEHOUSE, DEAD DROP, Console Lab and SIGNAL UNCLEAR; Central Node and escape per corporation; map boards per corporation; 9 map Node badges. Claude Code wires them when they arrive (the non-ICE Node screens and the map don't load painted backgrounds yet). | `docs/visual/concept-art/CHATGPT_PROMPTS_ROUND4.md` | Designer (ChatGPT), then Claude Code | WAITING on the files |
| **ChatGPT round 5 (title screen and Rustler portraits)** | Title background day and night (a World's Fair panopticon whose tower is one giant eye), a letterless emblem, and four Rustler portraits at matching framing. Claude Code wires them when they arrive. | `docs/visual/concept-art/CHATGPT_PROMPTS_ROUND5.md` | Designer (ChatGPT), then Claude Code | WAITING on the files |
| **ChatGPT round 6 (LUCIDA avatars)** | v2: 3 mockups first (creature lineup, ANIMA's three moods, an encounter mockup), then 61 LUCIDA ICE images as mechanical nightmare creatures, (20 ICE × cheery/wary/lethal + EGO DEATH), machine faces with almost no human features. Picked up by file name; LUCIDA's ICE aren't in the build yet, so they show when the LUCIDA slice is built. | `docs/visual/concept-art/CHATGPT_PROMPTS_ROUND6_LUCIDA.md` | Designer (ChatGPT), then Claude Code | WAITING on the files |
| **ChatGPT round 7 (IRONWATCH avatars)** | Prework answered; 3 mockups first (parade lineup, K9 UNIT's escalation, an encounter mockup), then 67 IRONWATCH ICE images with hatches that open on hoses, guns, lasers and syringes. | `docs/visual/concept-art/CHATGPT_PROMPTS_ROUND7_IRONWATCH.md` (prework: `IRONWATCH_AVATAR_PREWORK.md`) | Designer (ChatGPT), then Claude Code | Mockups reviewed 2026-11-20; prompts 1–3 updated; WAITING on the 67 images |
| **CAPS rack and Ghostware rail** | 3 placeholder CAP slots beside the hand; Ghostware badges along the top of the ICE area (any number, hover to read). Icons and the CAP slot come from round 3 §4. | Master ENC-CONCEPT-001 | Claude Code | BUILT (placeholders); positions approved 2026-11-20 |
| **ENC-CONCEPT-001 console colour** | Each corporation's ICE consoles in its own enamel: HALCYON seafoam, IRONWATCH navy, LUCIDA lilac. A shader recolours the seafoam console until ChatGPT's `UI_ICE_CONSOLE_2_IRONWATCH/LUCIDA.png` land (prompt in `CHATGPT_PROMPTS_CONSOLES.md`); console text turns cream on navy. *Interpretation to confirm:* the shader keeps the chrome trims silver (the painted versions will make them gold and rose copper). | Master ENC-CONCEPT-001 | Claude Code; art by Designer (ChatGPT) | BUILT (commit in dev log 2026-11-20), awaiting designer review; art TO DO |
| **HOVER-001** | Built: hand, deck and reward cards show the card drawn large (1.1×, about 1.5× a hand card) beside its rules; subroutine key tips show the key at 2.2×; program cartridges and the CRT program show their card; Ghostware badges show the badge at 128 px; CAP slots show the slot. Every box sits beside the object, never over it, and keyboard focus opens it too. ICE avatars get no extra box (designer approved 2026-11-20); subroutine key tips list every effect with its own icon, plus DEADLOCK steps, BOOTING, TUMBLE and the ICE's passive. Applies to every build from Playtest 8 on. | Master §6, HOVER-001 | Claude Code | BUILT, awaiting designer review |
| **ENC-CONCEPT-001 wiring** | Load each art file as it lands (`godot/assets/concept/`), falling back to the current art. | same | Claude Code | BUILT for batch 1; repeat for batch 2 |
| **ENC-CONCEPT-001 legacy fixtures (PROPOSED)** | `shot_cartridges` and `shot_cards_pcb` still check the old cartridge face via `FriendlyCard.legacy_face`. Proposal: retire them, or rewrite them for the concept face, once the designer approves the new cards. | Master ENC-CONCEPT-001 | Claude Code | PROPOSED; tracked in [#23](https://github.com/Punkwork/REDLINE/issues/23) |

**PIXEL-16BIT-001: no 16-bit look for the whole game (designer, 2026-11-21: "NO").** 16-bit is used only for transitions and the lethal pulse (MOOD-PIXEL-001), alongside the TRACE pixel steps (PIXEL-TRACE-001). The mockups in `docs/visual/explorations/pixel-16bit/` stay as history.

**Integration beyond the HALCYON slice:** connect the presentation hooks to playable LUCIDA, PATCHWORK and run resume when those systems arrive. Tag playable Central Nodes with `central: true`. The slice's run-menu DEAD DROP opens THE CARBON; attach the same reader to the map's DEAD DROP when that Node is built. The reveal sequence and final punch-card art have their own design work.


**Conditional (approved, build only if the condition is met):** PACE-003's BOOTING on the 4th turn, if playtest 2 shows the Opening Node breached before turn 4. PACE-006's safety valves (Max VITAE 35–40, full-clear heal 3, a second SAFEHOUSE), if playtests run too hot. PACE-009: watch RIOT's TRACE in longer encounters.

---

## Built — awaiting designer playtest

| IDs | Change | Commit reference |
|---|---|---|
| PIXEL-TRACE-001 | As TRACE rises, the backdrop and ICE mascot art drop toward 16-bit in steps (sharp below 20; 2 px at 20, 3 px at 30, 4 px on a strike, 5 px at Mask off, with fewer colours and a light dither). Text, plaques, cards and buttons stay sharp. Presentation only. Designer APPROVED 2026-11-19. PIXEL-TRACE-001a: each step change animates (a 0.15 s glitch spike to coarser cells, then a 0.35 s settle); instant with reduced motion. *Interpretations to confirm:* step values, the strike step, the spike and timing. Captures and GIF: `docs/visual/fixtures/pixel-trace-001/`. | **BUILT** — `c063429`, transition `c041496` |
| CARDS-004 | 1.4× cards in the hand, reward offers, ready rig, deck views and inspection. A centred, fanned hand: 5% overlap at 1–4 cards, then 8/10/18/26/35/43% at 5–10, a 20° fan (at most 4° per card), and the hovered card raised 36 px. The layout is reworked: ICE at 85%, the mascot stage 44 px shorter, the strips 104 px higher, and the side columns moved up. *Interpretations to confirm:* the ICE scale, the mascot size, and contact strips running up to ~50 px off-screen at 9–10 cards. Designer APPROVED 2026-11-19. Captures: `docs/visual/fixtures/cards-004/`. | **BUILT** — `02a2056` |
| HAND-MAX-001 | Maximum hand 10. A draw at 10 stops, and the card stays on the draw pile. Retrieve and FIELD KIT into a full hand do nothing. 8 rules tests; bot sims unchanged. Designer APPROVED 2026-11-19. | **BUILT** — `02a2056` |
| CARDS-005a | Corner icons restyled as dial-style steel indicators on a mounting rail. BLOATWARE gets a "can't be played" icon, and TRACER a red +3 penalty lamp; an unplayable card's dial shows "—". Designer APPROVED 2026-11-19. | **BUILT** — `b67dfc8` |
| CARDS-005 | Corner icons down the top-right corner: Icepick type, RAM on PROGRAMs, extra TRACE and CRED costs, and a target crosshair. The tooltip explains them. Designer APPROVED 2026-11-19. | **BUILT** — `d450823` |
| CARDS-003a | Long-text cards (compiled SAFEHOUSE cards that don't fit at 9 px) name their component cards on the face, with a "Hover for full text" line, and show the full rules in a mask panel above the card on hover. Designer direction 2026-11-19; it replaced the proposed tall layout. Interpretations confirmed by the designer ("Great save those changes"). | **BUILT** — `5b195bd` · [reference](visual/fixtures/cards-003/README.md) |
| CARDS-003 | PCB glow cartridges on all four card types: mustard SCRIPT, deeper green PROGRAM, blue-green PROTOCOL and corporate BLOATWARE. Text on dark mask panels, glowing ivory with amber numbers, a circuit stencil per Rustler type, 1/2/3 rarity lamps (none on starters) and a single cyan cache glow. Designer APPROVED 2026-11-19. Supersedes the CARDS-002 palette. | **BUILT** — `9354e2f` · [log entry](REDLINE_DEVELOPMENT_LOG_ARCHIVE.md#2026-11-19--cards-003-pcb-glow-cartridges-in-the-build-claude) · [reference sheets](visual/fixtures/cards-003/README.md) |
| CARDS-002 | PCB laminate, silkscreen traces and contacts on SCRIPT, PROGRAM and PROTOCOL. Corporate BLOATWARE retains its oxide-red Whirlwind art. Palette superseded by CARDS-003. | **BUILT** — [Codex implementation entry](REDLINE_DEVELOPMENT_LOG_ARCHIVE.md#2026-11-19--cards-002-rustler-pcb-palette-codex) |
| HAND-CLEANUP-001, CARD-CONTROLS-001, ENCOUNTER-DISPLAY-001 | Remove free HOLD, install and inspect PROGRAMs in the left bay, drop SCRIPTs on their play zones, toggle 150% card inspection, and fill fullscreen with the backdrop and enlarge ICE avatars by 25%. | **BUILT** — [Codex implementation entry](REDLINE_DEVELOPMENT_LOG_ARCHIVE.md#2026-11-17--hand-cleanup-001-and-card-controls-001-codex) |
| SIGNAL-001 (SIG-5a–d), ARCH-001 (ARCH-1a–c), ARCH-SLANG-001, ZINE-003, ADP-4a | Central-BREACH award hook, punch-card holder and reveal guard. Relocation notice, local SAMIZINE CARBON ledger and DEAD DROP reader. | **BUILT** — [Codex implementation entry](REDLINE_DEVELOPMENT_LOG_ARCHIVE.md#2026-11-18--signal-001-arch-001-and-adp-4a-codex) |
| ADP-001 Phase 3 (ADP-3a–c), ADP-4a | Local ads and settings, guarded LUCIDA record edits, and instance grafts with fixtures. | **BUILT** — `3d767be` · [Codex implementation entry](REDLINE_DEVELOPMENT_LOG_ARCHIVE.md#2026-11-18--adp-001-phase-3-and-adp-4a-codex) |
| ADP-001 Phase 2 (ADP-2a–c), ADP-4a | Approved voice, encounter hesitation, patent plates, and newsreels. | **BUILT** — `1f3fb31` · [Codex implementation entry](REDLINE_DEVELOPMENT_LOG_ARCHIVE.md#2026-11-18--adp-001-phase-2-and-adp-4a-codex) |
| ADP-001 Phase 1 (ADP-1a–f) | Bleed and hostile reveal, zine wear and barcode strips, three-stem prototype mix and mechanical effects, and corporate Poiret One display text. Review PNGs and audio in `docs/visual/fixtures/adp-001/`. | **BUILT** — [Codex implementation entry](REDLINE_DEVELOPMENT_LOG_ARCHIVE.md#2026-11-17--adp-001-phase-1-codex) |
| FACADE-ART-001 | Four backgrounds, fourteen transparent shells, corporate palettes, prompt provenance, and eight Opening Node captures. | **BUILT** — [Codex art and validation entry](REDLINE_DEVELOPMENT_LOG_ARCHIVE.md#2026-11-17--facade-art-001-ironwatch-and-lucida-art-codex) |
| DEPRECATE-001 | Removed LOGIC BOMB and RELAY; replaced the rare SCRIPT specimen with PAYDAY. | **BUILT** — `2bea490` |
| ICE-AUDIT-001 | Applied the approved HALCYON ICE revisions. | **BUILT** — `0ac64c3` |
| PULP-001 roll | Published seeded FORTRESS PULP rolls and exact PULP-002 curve values. | **BUILT** — `b44254c` |
| HALCYON validation and fixtures | Reran the 30-seed simulations and refreshed VIS-001, CHROME-001 and CARDS-001 fixtures. | **BUILT** — [validation commit entry](REDLINE_DEVELOPMENT_LOG_ARCHIVE.md#2026-11-17--validate-halcyon-and-refresh-fixtures-codex) |
| CARDS-001 | Heavy SCRIPT/PROGRAM/PROTOCOL slot-cartridge templates; external BW rating tabs; brown/olive/teal board faces, oxide-red Whirlwind Bloatware and direct-print titles; common/uncommon/rare finish details; protected protrusions; nine close-ups and six/eight-card captures. Types, rarity weights, costs and rules unchanged. | **BUILT** — `cards-001-board-textures` · Art approved 2026-11-17 (VISUAL-APPROVALS-002); playtest pending |
| CHROME-001 | Refine the CAPTCHA encounter in the designer-selected Chrome Deco direction: readable real rules/cards, illustrated mascot shells, atrium, corporate escalation and native interaction feedback. Ten full-screen PNGs refreshed against the current CARDS-001 treatment; pearl-enamel ICE service plaques; type-specific heavy slot cartridges with outside BW tabs and restrained rarity finishes. | **BUILT** — `chrome-001-enamel` (code `chrome-001-step5`) · Art approved 2026-11-17 (VISUAL-APPROVALS-002); playtest pending |
| VIS-001 | The Friendly Lie encounter: fonts/skins, zine hand/HUD, mascot scans and moods, corporation break states, drag/motion/accessibility, seven PNG review fixtures. Visual only; ZEROED/TUMBLE integrated first. | **BUILT** — `vis-001g` (steps `vis-001a`–`vis-001g`) · Art approved 2026-11-17 (VISUAL-APPROVALS-002); playtest pending |
| TUMBLE-001 | Remove broken TUMBLER subs and tumble immediately active replacements | **BUILT** — `zeroed-tumble-step3` |
| ZEROED-001-cards | Replace INTEGER UNDERFLOW with NULL POINTER and add RIOT ZEROED cards | **BUILT** — `zeroed-tumble-step2` |
| ZEROED-001 | Restore STR floor and track once-per-ICE ZEROED | **BUILT** — `zeroed-tumble-step1` |
| UI-004 | HOLD and READY RIG choices use a single horizontal scrolling row; full card height and last-card access verified. | **BUILT** — `codex/horizontal-choice-menus` |
| PACE-003,005,007,008 | DEADLOCK ×N progress for paid/card/WORM breaks; independent ESCALATE counters for TRACE/DISCARD/FORGET; reward need icons and visible draw chance; Tier 1 one-layer route; tier-aware reward odds; +50% reserves; version/label 0.3.0-playtest.3 / HALCYON PLAYTEST 3; post-merge-only Windows export; updated playtest guide and nine new UI fixtures. Final regression review also completed AMP for SILENT PARTNER/PAIN TOLERANCE, amplified card text, compiled fallback coverage, and Node/run state resets. | **BUILT** — `playtest3-pacing` (commit tag) |
| DSY-004,005,013 | SAFEHOUSE COMPILE with ordered effects, combined costs and tags, interactive continuations, CLEAN BUILD; MINIMALIST and ZERO FOOTPRINT; Ghostware effect hooks; corporation pushback ICE definitions and triggers (Tier 2 placement deferred after PACE-008). | **BUILT** — `playtest3-step5` (commit tag) |
| DSY-009,010 | Negative ICE STR *(to revert: ZEROED-001)*, MARGIN previews, SCALPEL, STACK SMASH, INTEGER UNDERFLOW, CULL and HARVEST; AMP on virus effects. | **BUILT** — `playtest3-step4` (commit tag) |
| DSY-011,012 | CHAIN tracks successful card plays; PIVOT, COVER FIRE, HANDOFF and KILL CHAIN; HOLD 1 and DEAD MAN’S POCKET HOLD 2; scrollable choices. | **BUILT** — `playtest3-step3` (commit tag) |
| DSY-007, DSY-008 | REBOOT queues drain only after draws finish; AMP and seven specified cards, SCAN bottom-order choice, in-Node BURN and discard retrieval, HUD reboot estimate, and bot choice handling. | **BUILT** — `playtest3-step2` (commit tag) |
| DSY-001, DSY-002, DSY-003, DSY-006 | FOOTPRINT/caps and bands, per-Node bloat TRACE, optional GHOST draw OFF, duplicate-aware draw estimates and key-card previews, COVERAGE/tag density, and guarded full-clear DECOMPILE. | **BUILT** — `playtest3-step1` (commit tag) |
| REJECT-001 | REJECT ALL has one DEADLOCK in its three-entry pool; BOOTING remains turn 3. Updated opening rules checks and bot timing reporting. | **BUILT** — `playtest3-step0` (commit tag) |

Per-step results and interpretations: [HALCYON_PLAYTEST3_IMPLEMENTATION.md](HALCYON_PLAYTEST3_IMPLEMENTATION.md).

## Deferred beyond this slice (playtest 3)

- DSY-004/005: PATCHWORK/FUSE modifications, Console Lab/BLACK CLINIC/Node completion upgrades, and Uplink REFACTOR (50 CRED, once per visit). SAFEHOUSE COMPILE works now; other service flows do not exist.
- Ghostware acquisition/selection, DEDUPLICATOR with FUSE, and CAPS. HEARTBEAT, MINIMAL INSTALL, ONE-TRICK and DEAD MAN’S POCKET effects have tested state hooks.
- DSY-013: Tier 2 FREE TRIAL placement and other corporation maps. All three pushback definitions/triggers are tested. This four-row map is Tier 1, so the final pacing step removes the temporary Step 5 Tier 2 placement.
- PACE-003/005: notation and engine support tested; no unspecified multipliers or ESCALATE assignments invented for existing ICE. The controlled UI fixture shows both.
- DSY-014/PACE-007 Phase 7 HULL engines, and PACE-004/010 manual scoring remain with their existing owners below.
- Windows export runs on `release`. Designer launch and playtesting of HALCYON PLAYTEST 6 are pending.
- Conditional turn-4 BOOTING and PACE-006 safety valves intentionally excluded.

## Open asset provenance

- CHROME-001 / CARDS-001: recover the original generation records and corrected concept PNG if they become available. The two asset source files now index the recoverable evidence.

## Waiting on the designer

| ID | Question | Where it came from | Status |
|---|---|---|---|
| NAME-002 (PROPOSED) | **Rename VITAE to SPARK?** Designer: VITAE "seems so out of place in this setting"; SPARK "works", to be reviewed later "to see how much it fits before committing it". Parked again on 2026-11-21 ("PARKED FOR NOW"). Why SPARK: the stat is not health but how much of *you* the machine can't have. Every consciousness has a First Signal; the spark is that signal in you, and what the ’Pelago harvests for the synchronization (SIGNAL-001, ARCH-001). Hits dim it; at 0 your spark is taken. Period-true (radio spark gap). Samples: *SPARK 12 / 30*, *PULP 5 · SPARK −5*, NUL/REM "keep your spark low and your head lower." Considered and set aside: NERVE, TICKER, GRIT, PULSE (too close to PULP); runners-up STATIC, SPINE, INK. Optional extra: corporations name the same number in flavour copy only (HALCYON "Comfort Level", IRONWATCH "Wellness Index", LUCIDA "Restfulness"). Scope if approved: about 510 mentions in 21 docs, including LOCKED master entries (Vitae distinction, HUB-002 PATCH UP), and about 80 in code/data; Claude Code renames on screen with a guard test that VITAE never appears; no rule changes. | Designer, 2026-11-18 | WAITING (review later) |
| ARCH-NAMES-001 names | The nine island names are working copy: the designer will check them against real care homes later. Still not confirmed (2026-11-21); DEV-002e waits on this. | ARCH §4.0 | WAITING |

---

## Done

**UI-WORKFLOW-001 (designer-approved, 2026-11-24):** GitHub Issues are the single authoritative UI proposal and development register for Claude Code, Claude, Codex and ChatGPT. Use stable component IDs from the UI Design Bible. Keep proposal discussion, mockup links, acceptance criteria, designer approval, implementation links and validation evidence in the issue; do not duplicate the backlog in HANDOFF or separate agent files. Only the designer approves; record approved decisions in Master Design and update the UI Design Bible as applicable. Development Log records actual work and links to the issue. Daily operations review uses the same issues. No code or rules changes. Component register: `docs/PANOPTICON_UI_DESIGN_BIBLE.md` §1a.

**UI-BIBLE-001 (designer direction, 2026-11-24):** [PANOPTICON UI Design Bible](PANOPTICON_UI_DESIGN_BIBLE.md) is the consolidated UI working specification, opening with “Visually rich but informationally restrained.” Icon-first resource HUD (Vitae, BW, RAM, Shield, incoming PULP), persistent top Ghostware rail and first ORIGIN badge in mockups. Existing decision IDs and rules authority remain unchanged. Source documents retained pending dependency/narrative audit; no parallel new UI briefs. No code changes. Initial consolidation: `16265fb`. Follow-up: reconcile imported historical sections and references before retiring source files; no implementation approval implied.

| ID | What | Commit / date |
|---|---|---|
| RELEASE-002 / HALCYON PLAYTEST 13 (first Architecture V2 build: new encounter screen, reward fix, graffiti removed) | Designer: "Cut the Playtest 13 build: move `release` to `a6f4476`" (2026-11-27 05:49). `release` fast-forwarded 2845ecd → a6f4476; CI passed (all suites, parity 80 encounters / 4,008 actions); export clean; artifact has 6 files (exe, README guide, BUILD_COMMIT, SHA256SUMS, both checklists). This session can't download artifacts (host blocked), so BUILD_COMMIT/SHA256 were checked from the run log, not the zip; the designer's first launch is the hands-on check. Tag: `git tag playtest-13 a6f4476 && git push origin playtest-13` (designer). | `a6f4476`, [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/45985348390), [artifact](https://github.com/Punkwork/REDLINE/actions/runs/45985348390/artifacts/15191118131) |
| RELEASE-001 / HALCYON PLAYTEST 12 (PT11 fixes, TUNE-002) | Exported the Windows build. Tag: `git tag playtest-12 2845ecd && git push origin playtest-12` (designer). | `2845ecd`, [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/45025253088), [artifact](https://github.com/Punkwork/REDLINE/actions/runs/45025253088/artifacts/14754544395) |
| RELEASE-001 / HALCYON PLAYTEST 11 (RIDER-001, AMEND-001, DEFRAG-001, PLAY-002) | Exported the Windows build. Tag: `git tag playtest-11 614e718 && git push origin playtest-11` (designer). | `614e718`, [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/44985021048), [artifact](https://github.com/Punkwork/REDLINE/actions/runs/44985021048/artifacts/14738584132) |
| RELEASE-001 / HALCYON PLAYTEST 10 (BOOST-001, SUB-001) | Exported the Windows build. Tag `playtest-10` to be pushed by the designer: `git tag playtest-10 236fa36 && git push origin playtest-10`. | `236fa36`, [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/44979979788), [artifact](https://github.com/Punkwork/REDLINE/actions/runs/44979979788/artifacts/14737242176) |
| RELEASE-001 / HALCYON PLAYTEST 9 (core loop + FORM-001/002) | Exported the Windows build with ICE forms and the threat increase. Tag `playtest-9` pushed by the designer (2026-11-21). | `a31ac2e`, [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/44972670798), [artifact](https://github.com/Punkwork/REDLINE/actions/runs/44972670798/artifacts/14734431990) |
| RELEASE-001 / HALCYON PLAYTEST 8 (core loop) | Fast-forwarded `release` to `main` and exported the Windows x86-64 build of the STRIP-001 core-loop test, with `REDLINE_CORE_LOOP_CHECKLIST.md` bundled. Rules, ADP and SIGNAL/CARBON suites passed; legacy screenshot fixtures are skipped while `CORE_LOOP` is on (designer approved, 2026-11-21: "option 1"). Tag `playtest-8` pushed by the designer (2026-11-21). | `37a72a4`, [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/44970043672), [artifact](https://github.com/Punkwork/REDLINE/actions/runs/44970043672/artifacts/14733039142) |
| Designer calls 2026-11-21 | DEV-002b confirmed, DEV-002c approved, DEV-002h yes; PIXEL-TRACE-001c neon ballast buzz; PIXEL-16BIT-001 rejected; MOOD-PIXEL-001 behaviour confirmed; NAME-002 parked; ARCH-NAMES-001 still open. Recorded in the master design doc. | 2026-11-21 (designer; recorded by Claude) |
| Checklist v0.7 | `REDLINE_PLAYTEST_CHECKLIST.md` v0.7 for HALCYON PLAYTEST 7 (ENC-CONCEPT-001 encounter): A3 and a Playtest 7 section, plus a fill-in workbook `docs/PANOPTICON_Playtest7_Checklist.xlsx` (3 runs, Run log, Summary) for results. The bundled checklist inside the Playtest 7 download is still v0.6. | 2026-11-21 (Claude) |
| DEV-001, CARDS-003–005a, HAND-MAX-001 | Codex baseline verification on Godot 4.3. See the [validation log](REDLINE_DEVELOPMENT_LOG_ARCHIVE.md#2026-11-19--dev-001-validate-the-card-and-hand-baseline-codex) for results. | Tested `2d5301a` · 2026-11-19 (Codex) |
| CARDS-003 cleanup | Removed the pre-CARDS-003 card paths: the toner illustration path and art box, the printed rarity finish (`cartridge_finish.gd`), the separator and old title strip, the old rules box and footer label, the text CACHED tag and the superseded palette colours. `shot_cartridges` checks now target the CARDS-003 nodes. All 115 existing screenshots are pixel-identical before and after. The toner illustration PNG stays in the assets. | `e66efff` · 2026-11-19 (designer: "I approve code cleanup"; Claude) |
| DEV-001b | Read-only audit, no code changes. Tests pass (361/0 rules, 17/0 bleed, 671/0 SIGNAL/CARBON). The code matches the rules docs on stats, starter decks, HALCYON ICE, strikes, odds and caps. Nine code/doc disagreements and five ARCHITECTURE.md problems are in the [log](REDLINE_DEVELOPMENT_LOG_ARCHIVE.md#2026-11-19--dev-001b-read-only-audit-of-code-docs-and-architecturemd-claude-code); fixes proposed as DEV-002a–i. | 2026-11-19 (Claude Code) |
| DOCS-001 | Agents were reading pre-redesign docs (Codex reported old Node types). `CLAUDE.md` / `AGENTS.md` §6 now lists which docs are current and the authority order; `REDLINE_BIBLE.md`, the 2026-11-10 core design doc, RULE-126, the Playtest 3 record and the old UI doc carry a "not current for rules" note. | 2026-11-18 (designer: "Yes"; Claude) |
| DEV-001a | Tagged baseline, wrote the developer system map, corrected the matching working agreements and retired the old Godot handoff. DEV-001b is next with Claude Code. | `pre-claude-code` at `0a357e7` · [Implementation log](REDLINE_DEVELOPMENT_LOG_ARCHIVE.md#2026-11-18--dev-001a-claude-code-handoff-codex) |
| ZINE-002 / ARCH-001 copy (ARCH-COPY-001) | Approved: the *THE CARBON* title, the *NOTES FROM THE ’PELAGO* column, the defeat framing copy and the polite anti-paper lines. Samizdat history (ADP §2.2.1) checked by the designer. | 2026-11-18 (designer: "All approved"; recorded by Claude) |
| ZINE-003 SAMIZINE | Design canvas built and reviewed in three rounds; spec `REDLINE_SAMIZINE.md`, boards, review PDF and canvas sources in `docs/visual/samizine/`. ARCH-SLANG-001 (’Pelago) and ARCH-NAMES-001 / ARCH-LINES-001 recorded. | 2026-11-18 (designer; recorded by Claude) |
| ADP §1.1 / ZINE-002 / ARCH-001 docs | Atompunk comparison (term stays); the zine as the underworld's samizdat; `REDLINE_ARCHIPELAGO.md` approved (decisions 1–4); ADP v0.8 links §8 to ARCH-001; decisions recorded in the master design doc. | 2026-11-18 (designer; recorded by Claude) |
| RELEASE-001 / HALCYON PLAYTEST 7 | Fast-forwarded `release` to `main` and published the Windows x86-64 artifact with the ENC-CONCEPT-001 encounter. Every workflow step passed, including the rules checks, the screenshot fixtures and the export (the export step fails on any script error and writes `BUILD_COMMIT.txt`, `SHA256SUMS.txt`, the guide and the checklist). Claude could not download the artifact from this session (the artifact host is blocked), so the designer's first launch is the hands-on check. | `5bb7d71`, tag `playtest-7` (pushed by the designer from a local clone, 2026-11-21; this cloud session's proxy refuses tag pushes), [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/44719708503), [artifact](https://github.com/Punkwork/REDLINE/actions/runs/44719708503/artifacts/14620644840) |
| RELEASE-001 / HALCYON PLAYTEST 6 | Published and verified the Windows x86-64 artifact. GitHub denied the branch-protection request with HTTP 403. | `22eb17f`, tag `playtest-6`, [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/44314368001), [artifact](https://github.com/Punkwork/REDLINE/actions/runs/44314368001/artifacts/14431722167) |
| HALCYON PLAYTEST 5 Windows build | Exported and verified the Windows x86-64 package with checklist v0.5. Windows launch and playtest are pending with the designer. | `98bad5f`, tag `playtest-5`, [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/44232607877), [artifact](https://github.com/Punkwork/REDLINE/actions/runs/44232607877/artifacts/14395388972) |
| HALCYON PLAYTEST 4 Windows build | Exported and verified the Windows x86-64 artifact with QA checklist v0.3. Windows launch and playtest are pending with the designer. | `b6b0971`, tag `playtest-4`, [Actions run](https://github.com/Punkwork/REDLINE/actions/runs/44202252857) |
| FACADE-001 HALCYON copy | Designer approved the consent, remembered activity and reward lines for review in playtesting. | 2026-11-17 (designer; recorded by Codex) |
| VIRUS-001 copy/move | Closed: WORM counters are **spent to break** (VIRUS-001); they don't spread to other ICE. The earlier copy-or-move question no longer applies (designer, 2026-11-15). | — (no change needed) |
| HANDOFF | This file created; working branch chosen. | 2026-11-15 (Claude), PR #4 |
| ROT-001 sync | Remaining SIGYL labels → TUMBLER in Card Pools, Rustlers, ICE Corp 1–3, Upgrades, Engines. | 2026-11-16 (Claude) |
| LOG-001 | Development log split: entries up to 2026-11-14 moved to `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md`; the live log keeps 2026-11-15 on. | 2026-11-16 (Claude) |
| ZEROED-001 / TUMBLE-001 readings | Designer confirmed both (2026-11-16): any drop to 0 STR uses up an ICE's one ZEROED; a subroutine that tumbles in is active at once. Build as specified above. | 2026-11-16 (designer) |
| DSY / PACE approval | Designer approved both docs as written for the next build; amendments recorded in Core Rules, Card Pools, Uplink & CAPS, Upgrades, Rustlers, Engines and the three ICE docs; checklist v0.2. | 2026-11-15 (Claude) |
| VISUAL-APPROVALS-002 | Designer approved the CHROME-001 art review, CARDS-001 as a whole, and the VIS-001 details (hand size, lethal threshold, undrawn ICE and wording, motion timings, Cracking after a strike). Recorded in the master design doc. | 2026-11-17 (designer; recorded by Claude) |
| ZEROED-001 interpretation | Closed: LOGIC BOMB and RELAY deprecated (DEPRECATE-001), so their floor/deficit readings no longer apply. | 2026-11-17 (designer; recorded by Claude) |
| RIOT-003 readings | Designer confirmed: SHATTER lets SLEDGE break any one chosen ICE of any type this turn; SLEDGE then stays at STR 0 until the encounter ends. Already built this way. | 2026-11-17 (designer; recorded by Claude) |
| REEL-001 follow-up | Closed: no DEADLOCK total on TUMBLER cards. TUMBLE-001 already removes broken subroutines at once and tumbles in the next unbroken one, so a broken DEADLOCK never reappears (designer reaffirmed). | 2026-11-17 (designer; recorded by Claude) |
| ICEBIBLE audit / PULP-001 | Designer applied the audit to the slice before the playtest (ICE-AUDIT-001) and set the FORTRESS PULP roll (PULP-001). Build rows added above. | 2026-11-17 (designer; recorded by Claude) |
| PULP-001 curves | Decided: curves keep their designed patterns and do not roll; every curve shows its next value (curve B no longer "PULP ?"). | 2026-11-17 (designer; recorded by Claude) |
| PR #1 vs this branch | Closed: PR #1 closed and its work archived at tag `archive/docs/simplified-design` (designer, 2026-11-17; Codex 65a47f2). | 2026-11-17 |
| Checklist v0.2 / v0.3 | `REDLINE_PLAYTEST_CHECKLIST.md` v0.3 adds checks for the 2026-11-17 decisions (C12–C16, D4, L5–L8, M5). The live Sheet "REDLINE Playtest QA Checklist" now matches it: v0.2 targets for B1, C1, K1 and rows C9–C11, G6–G11 added, plus the v0.3 rows (82 rows; Result dropdown extended). | 2026-11-17 (Claude) |
| FACADE-001 | Raygun Gothic facades for IRONWATCH and LUCIDA approved by the designer; recorded in the master design doc. | 2026-11-17 (designer; recorded by Claude) |
| MAIN-001 | Shared working agreement (`AGENTS.md`, `CLAUDE.md`) makes `main` the source of truth for Codex and Claude; `codex/chrome-deco-encounter` (including halcyon-playtest-stabilization and VIS-001) merged into `main`; approved Nov 17 visual decisions recorded in the master design doc. | aea16de, a523502, dd64768 · 2026-11-17 (Claude) |
| CHROME-001 screenshot refresh | Reran all five screenshot stages and replaced the ten PNGs under their original names with the current amber and textured CARDS-001 treatment. | 2026-11-17 (Codex) |
| MAIN-001 status sync | Corrected the working line, merged PR status and Windows export trigger in the current build status. | 2026-11-17 (Codex) |
| CHROME-001 / CARDS-001 source notes | Recorded available source and edit history for nine generated assets and corrected Whirlwind Bloatware. Exact prompts, model IDs and the corrected concept PNG are still missing. | 2026-11-17 (Codex) |
| VIS-001 doc | `REDLINE_VISUAL_LANGUAGE.md` and `docs/visual/` (reference images, placeholder backgrounds, mascot SVGs) added for Codex. | 2026-11-17 (Claude) |

### ARCH-V2-001 — VAS-001 visual target (2026-11-23)
Designer confirmed that the supplied 1536×864 PANOPTICON HALCYON mockup should be reproduced as closely as practical, including its dense mechanical console layout. Formal visual specification: `docs/architecture-v2/VAS-001.md`, cross-referenced with CAS-001. Original reference JPEG is now available at [canonical reference](https://github.com/Punkwork/REDLINE/blob/architecture-v2/godot/assets/architecture_v2/references/PANOPTICON_VAS-001_reference_mockup.jpeg); GitHub blob verified. Visual direction confirmed, but new assets, exact scene files and implementation still require milestone review. No gameplay/rules changes authorized.
### NUL-PILLAR-001b — design follow-up (WAITING)

Preserve designer-confirmed principle: PANOPTICON is not a game about surveillance; it is a game played under surveillance. Perceived observation and delegated authority are distinct. Allow obedience, resistance or no effect without classifying players or requiring an experimental result. Review future proposals against NUL-PILLAR-001a/b in the foundational NUL/REM document. No implementation authorized.

### NUL-PILLAR-001c — Four-Question Design Gate (WAITING)

For every proposed NUL/REM mechanic, document strategic meaning, genuine agency, multiple psychological responses and philosophical significance without explanation. Reconsider failed or unresolved criteria before implementation; existing approval gates remain. See the foundational NUL/REM document and master decision NUL-PILLAR-001c. No implementation authorized.

### PHIL-001 — Philosophical Design Bible (DONE: documentation)

Created `PANOPTICON_PHILOSOPHICAL_DESIGN_BIBLE.md` (c4f815d) at designer request. Consult for all philosophical mechanics, especially surveillance economy and curated card rewards. Apply four-question review; new mechanics remain proposals pending designer approval. No implementation authorized.

### PHIL-001a — Opening epigraph (DONE: documentation)

Placed the designer-selected epigraph and linked design note in the [Philosophical Design Bible](PANOPTICON_PHILOSOPHICAL_DESIGN_BIBLE.md). Recorded in the documentation commit titled `PHIL-001a: Open the Philosophical Design Bible with the Fenigson epigraph`.

### PHIL-006 — Panoptic society (DONE: reference documentation)

Reviewed the Into the Shadows transcript and added timestamped notes and design implications in the [Philosophical Design Bible §12](PANOPTICON_PHILOSOPHICAL_DESIGN_BIBLE.md#12--phil-006-panoptic-society). Commit: `PHIL-006: Document panoptic society as a design reference`.

### PHIL-002 — Algorithmic Reduction (DONE: documentation)

All six explorations preserved in Philosophical Design Bible §09 (b711f53), with priority on recursive self-surveillance and disappearance of surprise. Apply PHIL-001 safeguards and four-question gate. No implementation authorized.

### PHIL-003 — Gameplay Manifestations Catalogue (DONE: documentation)

Created `PANOPTICON_PHILOSOPHICAL_GAMEPLAY_MANIFESTATIONS.md` (e34eebd). Append future philosophical examples with stable IDs and status; no implementation authorized.

### PHIL-003a — Catalogue expansion (DONE: documentation)

Added psychological effect grouping and concrete in-game examples to all 39 proposed entries (1fed957), annotated withdrawn GM-040, and updated maintenance instructions. No implementation authorized.

### PHIL-004 — Demoralization (DONE: documentation; WAITING: design exploration)

Preserved both designer-requested statements and safeguards in Philosophical Design Bible §10 (88ae456). Explore distinct manifestations without deliberately demoralizing players. No implementation authorized.

### NUL-DIALOGUE-001 — Dialogue compendium (DONE: documentation)

Created `PANOPTICON_NULREM_DIALOGUE_COMPENDIUM.md` (10d0d90) with 31 proposed lines and six thematic pairs. Cross-referenced foundational and philosophical design. Copy/canon review pending; no implementation authorized.

### NUL-DIALOGUE-001a — Earlier dialogue recovery (DONE: partial documentation)

Added NR-032–075 (91c06e2), 26 earlier dialogue examples and 18 wording fragments. Full transcript completeness unverified; copy review pending.

### NUL-DIALOGUE-002 — Dialogue architecture (DONE: documentation; WAITING: implementation approval)

Created 13-section `PANOPTICON_NULREM_DIALOGUE_ARCHITECTURE.md` (db37cb9). Review proposed schema, events, pacing and QA before implementation. All existing approval gates apply; no code authorized.

### OPS-001 — Shared operations hub (DONE: repository setup)

Use `docs/operations/README.md` and shared reporting protocol; daily review 22:00 Toronto. Claude scheduling requires separate setup; designer confirms next-day agenda.

### OPS-002 — Milestone progress (DONE: documentation; WAITING: baseline confirmation)

Master defines eight proposed gates; Operations Dashboard owns evidence-based progress. Daily review updates snapshot and links agenda to milestones. Reconcile architecture-v2 and current build evidence; designer confirms scope, weights and gate acceptance.

### OPS-002a — Commercial Steam launch (DIRECTION)

Designer confirmed actual commercial release on Steam as ultimate goal. Master expands M08 and proposes M09 launch gate; dashboard tracks nine gates. Steamworks status, pricing, launch date, weights and detailed acceptance remain to verify/decide. No account or publication action authorized.

### BYPASS-001 — Encounter eligibility (designer decision; WAITING on mechanic specification)

Record non-final encounter restriction; no BYPASS on final layer, including single-layer Nodes. Define triggers and resolution before implementation. No code task authorized.

### EXP-DESIGN-001 — Experimentation Bible (DONE: documentation)

Created [Design Experimentation Bible](PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md) (7e0928f); initial BYPASS proposals, cards, scenarios and tests remain exploratory. Existing UI issue workflow and migration blocker unchanged. No implementation task authorized.

### BACKCHANNEL-001 — Preferred experimental card (DONE: documentation)

EXP-C029 in Experimentation Bible (ddc4793); timing, legality and balance remain open. No implementation authorized.

### NULL-POINTER-001 — Approved cost adjustment (WAITING: Claude Code)

NULL POINTER 1 BW (formerly 2), all other properties unchanged. Deck Synergy §9.2 updated (08b5b6f). Synchronize runtime card definition and affected tests, validate; documentation-only change so far.

## RIOT-EXP-001 — RIOT experimental card catalogue (ChatGPT)

Designer requested preservation in Experimentation Bible §11 (bdc32508a880a9925010b0dde4bdbf0ac7b0fc57). EXP-C030–036, M007, S012–021, X005; revised FIRST STRIKE and one-copy BREAKER BAR with per-copy node escalation and BURN cost. Experimental only; NULL-POINTER-001 remains approved separately. No code or tests; UI migration gate unchanged.

## TRACE-EXP-001 — TRACE mitigation concepts (ChatGPT)

Designer requested preservation of SIGNAL DAMPENER (Ghostware) and four Protocols in Experimentation Bible §12 (bc9938aa034cf6a39c6114472b4688b056e6cf1f); EXP-C037–041, M008, S022–027, X006. Proposed type distinction, self-inflicted TRACE coverage and trigger timing remain experimental. No rules/code changes, tests or consolidation.

## NUL-DIALOGUE-003 — Economic dependency dialogue (ChatGPT)

Designer requested preservation of four lines NR-076–079 in NUL/REM Dialogue Compendium (28cd6dea0d23821902a025414a3333724c4b365c). Verbatim dialogue; contextual triggers and associations proposed. No shipping approval, gameplay changes, tests or consolidation.

## CRED-EXP-001 / PHIL-005 — CRED-powered combat and economic dependency (ChatGPT)

Designer requested preservation of eight cards EXP-C042–049, mechanics M009–011, scenarios S028–034 and experiment X007 in Experimentation Bible §13 (bf8d742d3783d4cdb2a11e17e62d442b7fc8de52), and economic dependency/purchased freedom in Philosophical Design Bible §11 (aaafd9993e811a2a8b1169a9e9f3ed68b97f0bf6). Fully CRED-powered Icepick activations consume no BW; installation costs open. All mechanics experimental; philosophical direction designer-endorsed, not a new formal pillar. NR-076–079 already saved. No rules/code changes, tests or consolidation; UI migration blocker unchanged.

## CRED-EXP-001a — Icepick installation cost (ChatGPT)

Designer specified 1 BW installation for PAYDAY, BRIBE and MERCENARY (EXP-C042–044); all activations remain CRED-only. Experimentation Bible §13 updated (9cfc95fe920dbfd5abfded3bccda06174cabec2b), including S035. Supersedes open installation cost in CRED-EXP-001 for these three cards only. Experimental, no code or tests.

## CRED-EXP-001b — Program classification (ChatGPT)

Designer clarified EXP-C042–044 are RAM-using PROGRAM Icepicks, 1 BW install, CRED-only activation. Exact RAM TBD; 1 RAM suggested only. Experimentation Bible §13 corrected (0045b0d693b7386b6a6a83c83ca194e92005d784); canonical Core Rules §3.1 unchanged. No code or tests.

## CRED-EXP-001c — Icepick RAM requirements (ChatGPT)

Designer specified PAYDAY 1 RAM, BRIBE 1 RAM, MERCENARY 2 RAM. Experimentation Bible §13 (a28329f275b87bd1d163e4e798cf5859b5e96958), EXP-S036; supersedes TBD RAM in CRED-EXP-001b. Other values unchanged. Experimental only; no code or tests.

## VOID-EXP-001 (ChatGPT)

Saved exploratory VOID-only UNLOAD, Rustler-selected Program removal to discard, Program opportunity costs, EXP-M012/S037–042/X008 in Experimentation Bible §14 (171674b7e8b34d0dd4dad805b9861da4e22b0d0b). No rules/code/tests or consolidation.

## CRED-EXP-001d — CRED SCRIPTS and card-type identity (ChatGPT)

Designer confirmed EXP-C045–049 as 0 BW SCRIPTS with existing CRED prices/effects, one resolution per play, normal discard/redraw, prior activation caps removed in preferred experiment. EXP-M013/S043–044, X007 extension in Experimentation Bible §15 (8d75932dad452669d6aefc0864bda40092e118df). Existing Protocols unchanged; experimental guidance only, no rules/code/tests or consolidation.

## ICE-EXP-002 — Encounter-wide effects and subroutine modification (ChatGPT)

Saved 20 proposed cards EXP-C050–069, mechanics M014–015, scenarios S045–052, experiments X009–010 in Experimentation Bible §16 (27d5fb2ea234eaa8b1ebc87dada42b021fee6b17). Designer's targeted -6 PULP this turn/BURN preserved; names/costs provisional, collisions flagged. No rules/code/tests or consolidation.

## CAP-EXP-001 — Infiltration CAPS (ChatGPT)

Saved twelve non-card CAP concepts EXP-CAP001–012, M016, S053–057 and X011 in Experimentation Bible §17 (98bc0b716700ad6aac90a6bc614b46496b5425c0). No CRED prices or rarities assigned; map activation and circumvention experimental. Existing CAPS rules unchanged. No code/tests or consolidation.

## SURV-MEM-001 — Surveillance and memory (ChatGPT)

DIRECTION, designer-confirmed: “As the player learns the game, the game learns the player.” “The system always remembers. It never forgets.” Pervasive fictional surveillance across runs. Five-stage table and proposed memory layers saved in Experimentation Bible §20 (57bfe20002567740e0e91cde85a809df280ce7e2); prior ICE-SURV-EXP-001 / SURV-EXP-001 proposals in §§18–19 (eb335be5b95c05488f3a966f5d90a47280675523). Philosophical Bible cross-reference. No approved mechanical changes, code, tests or consolidation. Interpretation: thematic persistence does not remove real-world local data reset or privacy controls.

## CARBON-SURV-EXP-001 — Collective trust and individual authority

Designer-endorsed philosophical exploration: keep THE CARBON (collective trust) and NUL/REM (personal autonomy) distinct. Corporate appropriation of trusted resistance spaces may erode collective trust and increase reliance on individual authority. “The system creates the conditions that make its own assistance necessary.” Full progression, examples, comparative framework and open questions preserved in [Design Experimentation Bible §21](PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md), commit 02e46011863db27f2ac03ed922aa038358bc8a77. EXP-D003 / EXP-X013 remain proposed; no mandated psychological outcome, approved mechanics, code, tests or consolidation.

## SURV-UNCERT-EXP-001 — The uncertainty of observation

Designer-endorsed exploration: possibility of observation, fictional fear/anxiety/suspicion, ambiguity of coincidence, self-regulation and freedom exhaustion. Designer identified Francis Ford Coppola's The Conversation (1974) as reference. Preserve the “constant low hum anxiety” experiential direction as fictional atmosphere, not deliberate actual distress. Linked to SURV-MEM-001 and CARBON-SURV-EXP-001. Full tables, examples and safeguards in [Design Experimentation Bible §22](PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md), commit 6b36c117b89c4f32edfef77c7241c8fb6db59a28. No approved mechanics, production dialogue, code, tests or consolidation.

## SURV-OBSERVER-EXP-001 — The Internalized Observer

Designer confirmed The Parallax View (1974, Alan J. Pakula) and The Conversation (1974, Francis Ford Coppola) as principal cinematic references. Recorded in Design Experimentation Bible §23, commit 307703473a5a9f3ec8a9fe0a6f34800815d2342b. Reference-only; no new rules, specifications, code or tests.


## SEQUENCE-002 — SEQUENCED revision (designer approved 2026-11-27)
SEQUENCED permits breaks in any order. Each successful out-of-sequence break generates TRACE once if an earlier visible, active subroutine on the same ICE remains unbroken, regardless of how many are skipped. Previously broken, concealed and inactive subroutines do not count. This supersedes mandatory ordered breaking and retires standalone TRIPWIRE. TRACE magnitude remains open for balancing. Design SEQUENCED ICE with low-urgency earlier effects (e.g. INSERT SPAM or DISCARD) and a compelling later target (e.g. PULP 6 or AMEND on supporting ICE, increasing the right-hand ICE's PULP during the response). Examples are design patterns, not approved new ICE profiles. Preview the penalty before committing. Priority 2 representative encounter refinement; implementation and tests pending, no engine changes in this decision.


## TOLL-RETIRE-001 — TOLL retired (designer approved 2026-11-27)
Retire TOLL (additional BW cost for breaking non-DEADLOCK subroutines) from active design, HALCYON expansion and mechanical coverage requirements. It adds resource pressure without sufficient new strategic decisions to justify cognitive load. Preserve historical records; reconsider only with explicit designer approval. Supersedes earlier active TOLL specifications. Priority 2: reconcile rule references and legacy engine support in a controlled implementation batch; no engine changes authorized by this documentation update. Design review principle: mechanical complexity should be earned through strategic depth.


## MINIBOSS-001 — Unique signature abilities / FORTIFY (designer direction 2026-11-27)
Each corporation has one mini-boss encounter, with a signature ability unique to that mini-boss. Reserve FORTIFY (formerly passive HARDENING) for one specific mini-boss as one of three candidate signature abilities; no standard ICE assignment. Existing HARDEN remains a distinct breakable subroutine. FORTIFY candidate retains +1 STR after each Corporation Countermeasure, maximum +3 bonus provisionally; final balance, corporation and ICE identity remain undecided. Signature abilities must justify complexity through strategic depth, agency, synergy, anticipation and cognitive-load value. No production implementation or roster changes in this documentation update.


## MINIBOSS-003 — THE GRID: PROFILE + FORTIFY (designer approved 2026-11-27)
IRONWATCH's mini-boss THE GRID retains its approved PROFILE ability and gains FORTIFY (formerly passive HARDENING), exclusive to THE GRID. FORTIFY grants +1 STR after each Corporation Countermeasure, maximum +3 bonus as a working balance value. PROFILE remains unchanged. Both are unique signature abilities, not breakable or disableable subroutines. Each corporate mini-boss must have at least one unique signature ability; multiple complementary abilities are permitted where strategically justified. Supersedes the single-ability implication of earlier mini-boss records and resolves FORTIFY's assignment. Preserve other mini-boss designs. Implementation and combined balance testing pending; no engine changes in this documentation update.


## WATCHER-EXP-001 — WATCHER removed from standard ICE (designer approved 2026-11-27)
Remove WATCHER from the standard ICE ability pool and HALCYON expansion/representative encounter mechanical coverage. Preserve as an experimental concept: each CLOAK card played generates 1 TRACE. Potential exceptional applications: mini-boss, specialized supporting ICE with meaningful counterplay, or discoverable/circumventable node security condition. None is approved for deployment. Evaluate strategic depth, agency, synergy, anticipation and cognitive load; test defensive deck viability, advance warning and viable counterplay. Design principle: abilities directly penalizing fundamental Rustler actions should be exceptional encounter conditions, not routine obstacles. Detailed experimental ownership: docs/PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md. Supersedes standard WATCHER specifications; preserve historical records. No engine changes or production implementation authorized by this documentation update.


## BOOTING-RETIRE-001 — BOOTING retired (designer approved 2026-11-27)
Retire BOOTING, the passive ability locking DEADLOCK until Rustler turn three, from active design and representative encounter coverage. Mandatory waiting undermines efficient play and agency. Preserve historical records. Designer expressed interest in exploring optional protection of DEADLOCK by another subroutine or ICE, without making its removal mandatory; no replacement mechanic approved. Legacy rule/code reconciliation pending controlled implementation; no engine changes in this documentation update.


## GUARD-001 — Optional DEADLOCK protection (designer approved direction 2026-11-27)
GUARD is a supporting ICE subroutine protecting a linked DEADLOCK on another ICE. Breaking the protected DEADLOCK while GUARD remains unbroken triggers a consequence; breaking GUARD first avoids it. GUARD must never prohibit the DEADLOCK break or become a mandatory breach prerequisite. Exact consequence (candidate PULP or TRACE), magnitude, linking rules, timing and interaction with simultaneous breaks remain open for specification and balance. Supporting ICE need not have their own DEADLOCK. Include GUARD in Priority 2 HALCYON supporting ICE design and representative encounter coverage planning. INTERLOCK and ALARM LINK were unapproved alternatives in the BOOTING review and are not selected for development. No engine changes or final numerical rules authorized by this record.


## REBOOT-SPAM-002 — Breakable reactive subroutine (designer approved 2026-11-27)
Convert REBOOT SPAM from inherent ICE ability to breakable reactive subroutine. Preserve existing effect: each natural or explicitly forced REBOOT inserts one SPAM into the Rustler draw pile while the subroutine is active and unbroken. Breaking it prevents subsequent triggers while broken; it does not independently resolve during ordinary Corporation Countermeasure. No mandatory break prerequisite. Reconcile FREE TRIAL's existing inherent ability with the new subroutine in HALCYON coverage planning; exact TUMBLER slot/pool placement, visibility and rotation interactions require specification before implementation. Preserve historical records. Priority 2; implementation and regression tests pending, no engine changes in this documentation update. Rationale: preserve deck-cycling pressure while giving Rustler direct counterplay.


## REBOOT-SPAM-002a — ICE affinity and activation clarification (designer approved 2026-11-27)
Finalize REBOOT-SPAM-002: VOID is the preferred but not exclusive ICE type; FORTRESS and TUMBLER remain eligible. Each natural or forced REBOOT inserts one SPAM into the draw pile per eligible REBOOT SPAM subroutine. Existing universal subroutine eligibility applies: revealed, active and unbroken; no concealed or inactive triggers, no independent Corporation Countermeasure execution. Apply existing TUMBLER rotation rules without exceptions. Reconcile FREE TRIAL's legacy inherent ability during implementation; exact roster placement and pool composition remain open. Include in Priority 2 mechanical coverage and regression planning. Documentation approval only; engine implementation pending.


## REBOOT-FORGET-001 — LUCIDA-exclusive ability (designer approved 2026-11-27)
Retain REBOOT FORGET as an inherent reactive ICE ability exclusive to LUCIDA: existing REBOOT trigger and FORGET 1 effect retained. Do not convert to a breakable reactive subroutine at this stage. Defer implementation/reconciliation and balance evaluation to LUCIDA development; explicitly exclude from current HALCYON representative encounter milestone. Existing RECURRING DREAM definition and legacy references to be reconciled during appropriate implementation work. No engine changes authorized by this record.


## CHAIN-REP-001 — Representative encounter scope clarification (designer approved 2026-11-27)
Priority 2 representative encounter milestone must fully flesh out, implement and playtest Rustler CHAIN mechanics and their UI. Designer reports current CHAIN operation, activation and effects are effectively invisible. Audit approved rules, current engine and card coverage; identify gaps, specify and validate card sequencing, eligibility, bonuses and feedback; coordinate with UI-TYPO-001/a, M06, CAS-001 and VAS-001. Proposed UI acceptance states: potential, progression where applicable, ready, activated, resolved; icons/hover/focus, pre-action clarity, distinctive motion/audio and reduced-effects support. Exact UI and any new mechanical rules require designer approval; do not invent new CHAIN rules. Include meaningful CHAIN combinations in HALCYON representative encounter and multi-encounter coverage. Separately retain CHAIN PULP (existing 1 PULP per CHAIN bonus) as an IRONWATCH-preferred reactive ability for a future IRONWATCH representative encounter milestone; exclude CHAIN PULP development from current HALCYON milestone, without excluding Rustler CHAIN itself. Existing PATTERN ANALYSIS assignment requires later reconciliation. No engine changes in this documentation update. Preserve current priority ordering and coordinate with Claude Code's ongoing GUARD work.


## CHAIN-002 — Foundational CHAIN revision (designer approved 2026-11-27)
Canonical working specification: [PANOPTICON CHAIN Mechanics](PANOPTICON_CHAIN_MECHANICS.md). Supersedes DSY-011's two-card activation threshold: minimum three cards; third valid card instantiates a CHAIN instance and receives inherent −1 BW play-cost reduction before commitment, plus applicable card-specific bonus. Longer chains permitted; exact eligibility, extension discounts, termination, repeat instances, cost floor/precedence and card balance remain open. CHAIN-REP-001 remains Priority 2; coordinate CHAIN visibility and CHAIN ACTIVATED audiovisual feedback with UI-TYPO-001/a and M06. Existing engine and cards still reflect historical rules until implementation; no production change authorized by this documentation commit. CHAIN PULP remains deferred to IRONWATCH. See canonical specification for examples, audit, questions and acceptance plan.


## CHAIN-002a — Multiple instances per turn (designer approved 2026-11-27)
Multiple independent CHAIN instances may be instantiated within a single Rustler turn, with no once-per-turn activation restriction. Each valid new instance receives its own inherent −1 BW instantiation cost reduction and applicable card-specific bonus. This resolves the repeat-instance eligibility question in CHAIN-002; sequence overlap, reuse of links, termination, extension discounts and any card-specific trigger caps remain unresolved or governed by their existing rules. Illustrative example: two distinct valid three-card sequences in one turn each receive a discount on their third card, subject to affordability and approved eligibility. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.
