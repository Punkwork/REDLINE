# PANOPTICON — DEVELOPMENT LOG
**Initialized:** 2026-11-09  
**Policy:** append dated entries; distinguish reported outcomes from verified tests.

**LOG-001 (2026-11-16):** entries from 2026-11-08 to 2026-11-14 are in `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md`, unchanged. Keep this file under about 60 KB (HANDOFF, "How we work" 6).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — FACADE-001: HALCYON non-fight copy approved (Codex).
LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — HALCYON PLAYTEST 4 Windows build (Codex).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-17 — Playtest checklist v0.4 for HALCYON PLAYTEST 4 (Claude).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — Atomic Deco Punk design direction (Codex), 2026-11-17 — ADP-001 Phase 1 (Codex).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-17 — ADP-001 Phase 1 confirmations (Codex), 2026-11-17 — HAND-CLEANUP-001 and CARD-CONTROLS-001 (Codex), 2026-11-17 — HALCYON PLAYTEST 5 Windows build (Codex), 2026-11-18 — ZINE-002, ARCH-001: the zine as samizdat; the Archipelago (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-18 — ARCH-NAMES-001: islands named like care homes (Claude).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — ARCH-LINES-001: relocation lines and programme names approved (Claude); 2026-11-18 — ARCH-SLANG-001: the Rustlers say ’Pelago (Claude); 2026-11-18 — ARCH-SLANG-001 confirmed: ’Pelago even at the end (Claude).

LOG-001 moved the oldest dated entry to the archive unchanged: 2026-11-18 — ZINE-003: SAMIZINE, the underworld's zine look (Claude).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — ADP-001 Phase 2 and ADP-4a (Codex); 2026-11-18 — ADP-001 Phase 3 and ADP-4a (Codex).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — SIGNAL-001, ARCH-001 and ADP-4a (Codex).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — ZINE-003 confirmed (Claude); 2026-11-18 — ARCH-COPY-001: remaining working copy approved (Claude).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — ARCH-COPY-001 correction: island names stay working copy (Claude); 2026-11-18 — No history fact-checks (Claude).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-18 — RELEASE-001: builds come from a `release` branch (Claude).

LOG-001 moved the oldest dated entries to the archive unchanged: 2026-11-20 — ChatGPT round 5 prompts: title screen and Rustler portraits (Claude); 2026-11-20 — AVATAR-001 LUCIDA amendment and round 6 prompts (Claude); 2026-11-20 — Round 6 v2: LUCIDA as mechanical nightmares, mockups first (Claude); 2026-11-20 — IRONWATCH avatar prework (Claude); 2026-11-20 — AVATAR-001 IRONWATCH amendment and round 7 prompts (Claude); 2026-11-20 — IRONWATCH mockups reviewed (Claude); 2026-11-20 — ENC-CONCEPT-001 console colour per corporation (Claude Code); 2026-11-21 — Designer calls: DEV-002b/c/h, PIXEL-TRACE-001c, PIXEL-16BIT-001, MOOD-PIXEL-001; checklist v0.7 (Claude).

LOG-001 archived the following oldest entries unchanged: 2026-11-21 — RELEASE-001: `playtest-7` tag pushed (Claude); 2026-11-21 — STRIP-001: core-loop test build (Claude Code).

## 2026-11-22 — Playtest 12: PT11 fixes and TUNE-002 (Claude Code)

**PT11-BUG-1:** the stuck panel was the pinned card inspection (opened by clicking a rack card); it closed only on a right-click or Esc. It now closes on any click on it, a click outside it, or a phase change. **PLAY-002 fix:** the new hit sounds had no entry in the ADP effect volumes, so loading them threw an error and Playtest 11's per-type sounds never played; they now default to 0.8. **PT11-UI:** parting-shot total on the HUD and END TURN tooltip; untargeted cards drop anywhere above the hand tray; plain-word key tips for the new effects and riders; unplayable cards dim. **TUNE-002:** AMEND 1; TERMS OF SERVICE PULP 3.

**Tests:** `test_game.gd` 176/0; headless start-up has no script errors. Screenshot fixtures stay skipped under `CORE_LOOP`.


## 2026-11-22 — PROBE-004: PROBE choose-one (Claude)

**Designer:** PROBE does what it does now OR reveals hidden subroutines on a VOID, same costs. Recorded in the master design, `REDLINE_CORE_LOOP.md` (decision row, STRIP-001 VOID rule), HANDOFF (Claude Code TO DO) and checklist question 8. **Interpretations to confirm:** reveal = all face-down subroutines; the −2 STR mode no longer reveals; reveal unavailable with nothing face-down; the choice is shown only on a VOID. **Code changes:** none.

## 2026-11-23 — ARCH-V2-001: architecture migration governance (ChatGPT)

**Designer:** Approved a full-game hybrid scene-based, component-driven, data-driven Godot architecture instead of retaining the prototype's one-scene restriction. Explicitly chose `architecture-v2` as primary rebuild branch with `main` preserved as stable four-node prototype. The branch was created from `main`.

**Documentation:** Updated AGENTS.md, CLAUDE.md, master design, HANDOFF, and architecture notes on `architecture-v2` only. No gameplay code changed. No prototype tag created; baseline tests, new scene plan, CI and release migration remain to do. **Interpretations to confirm:** specific scene/data architecture and when/how to merge or release the rebuild require designer review.

## 2026-11-23 — ARCH-V2-001 blueprint folder drafted (ChatGPT)

Created six proposed documents under `docs/architecture-v2/`: README, scene hierarchy, data model, gameplay interface, migration plan and validation. They are architecture proposals, not designer-approved implementation details. No Godot files or rules changed; baseline tests and tag remain pending. HANDOFF updated for designer review.

## 2026-11-23 — ARCH-V2-001 decision history and compliance gate (ChatGPT)

At the designer's request, added `docs/architecture-v2/ARCHITECTURE_DECISIONS.md` (curated rationale and approval boundaries) and `COMPLIANCE_CHECKLIST.md` (evidence-based review checklist). Linked them from the blueprint README and required consultation before significant architecture changes in identical AGENTS.md and CLAUDE.md. No gameplay code changed, no baseline tests run, and no unreviewed implementation details approved.

## 2026-11-23 — ARCH-V2-001 static source audit (ChatGPT)

Inspected GitHub source on `architecture-v2`: project/scene, UI/controller and interaction scripts, Game/CardDB/IceDB, and CI workflow. Added `docs/architecture-v2/STATIC_SOURCE_AUDIT.md` with source-grounded dependency map, proposed file structure, risks and regression matrix. Critical finding: current `CORE_LOOP := true` causes CI to skip legacy screenshot fixtures. No Godot execution, screenshot review, baseline verification or gameplay changes performed. Proposals remain subject to designer approval.

## 2026-11-23 — ARCH-V2-001 dependency map (ChatGPT)

Added `docs/architecture-v2/DEPENDENCY_MAP.md` based on inspected Godot source. Traced click/drag card play, ICE break, targeted card, end-turn response, and UI refresh call paths; identified controller↔view coupling, direct Game dispatch from drop targets, and proposed staged migration seams. No runtime test, scene implementation, gameplay modification or architecture approval claimed.

## 2026-11-23 — ARCH-V2-001 formal component specification (ChatGPT)

Created `docs/architecture-v2/COMPONENT_ARCHITECTURE_SPEC.md` (CAS-001) with 18 proposed component contracts, ownership and lifecycle, command/snapshot boundary, allowed dependencies, migration stages, acceptance matrix and open designer decisions. Based on existing source audit and architecture documents. This is a PROPOSAL only: no Godot execution, production scenes, gameplay changes, or implementation approval.

## 2026-11-23 — ARCH-V2-001 VAS-001 visual architecture specification

Designer confirmed faithful reproduction of the supplied 1536×864 dense mechanical console mockup as the vertical-slice visual target. Created `docs/architecture-v2/VAS-001.md` defining reference regions, approximate geometry, material/type tokens, Godot-native vs art-backed controls, visual states, modular asset inventory, viewport adaptations, screenshot comparison and milestone acceptance. The reference image is not yet confirmed uploaded to GitHub. Documentation only; no graphics or gameplay implementation, tests, or implementation approval.
## 2026-11-23 — NUL-PILLAR-001: NUL/REM foundational design direction (Codex)

Designer confirmed NUL/REM as a foundational pillar of PANOPTICON's psychological experiment and requested preservation in GitHub. Recorded the substantive discussion, including the three conditions, implicit/explicit authority, active solicitation, deck-removal denial, safer routes, automated first install and advance ICE intelligence in `REDLINE_NULREM_BEHAVIOURAL_LOCK_IN.md` (f2b938b). Master design and HANDOFF cross-referenced. Individual mechanics remain proposals. **Code changes:** none; tests not run (documentation only). **Interpretations to confirm:** domain-specific authority, thresholds, revocation, intervention feedback, integration with existing canon and rules.

## 2026-11-23 — NUL-PILLAR-001a: Psychological Invisibility (Codex)

Designer explicitly confirmed that the experiment must remain psychologically invisible: no disclosure, classification, quantification or announcement of psychological progression. Expanded the existing NUL/REM design document with internalization as an emergent outcome, proposed silent withdrawal of enforcement and disconnection, and withdrawal of the proposed explicit THE CARBON psychological reveal. Master design and HANDOFF updated. No code changes; tests not run (documentation only).

## 2026-11-23 — NUL-PILLAR-001b: Played under surveillance (Codex)

Recorded designer-confirmed philosophical distinction and paradox of autonomy in the NUL/REM document, master design and HANDOFF. Experience is sufficient; no prescribed psychological outcome or measurement. No code changes; tests not run (documentation only).

## 2026-11-23 — NUL-PILLAR-001c: Four-Question Design Gate (Codex)

Recorded designer-requested NUL/REM mechanic review questions in foundational design, master design and HANDOFF. Failed or unresolved criteria require reconsideration; existing approvals remain. No code changes; tests not run (documentation only).

## 2026-11-23 — PHIL-001: Philosophical Design Bible (Codex)

Created the designer-requested eight-section Bible (c4f815d), including surveillance economy, curated rewards and both autonomy paradoxes. Cross-referenced master design, NUL/REM and HANDOFF. New mechanics remain PROPOSED. No code changes; tests not run (docs only).

## 2026-11-23 — PHIL-002: Algorithmic Reduction (Codex)

Preserved all six designer-requested explorations in Philosophical Design Bible §09 (b711f53), emphasizing recursive self-surveillance and disappearance of surprise. Master and HANDOFF updated. No code changes or tests (docs only).

## 2026-11-24 — PHIL-003: Gameplay Manifestations Catalogue (Codex)

Created living catalogue (e34eebd) with 39 proposed examples and one withdrawn example; stable GM IDs and principle tags. Linked Bible, master and HANDOFF. No code changes; tests not run (docs only). LOG-001: moved oldest two dated entries (CARDS-003a and CARDS-004/HAND-MAX-001) unchanged to archive.

## 2026-11-24 — PHIL-003a: Catalogue expansion (Codex)

Added designer-requested psychological effect and final concrete example columns (1fed957), primary grouping index, and withdrawn example annotation. Interpretations to confirm: grouping labels and illustrative scenarios are editorial hypotheses, not validated effects. No code changes; tests not run (docs only).

## 2026-11-24 — PHIL-004: Demoralization (Codex)

Preserved designer-requested autonomy burden and liberation paradox in Philosophical Design Bible §10 (88ae456), distinguishing two potential responses and prohibiting deliberate helplessness or disengagement. Master and HANDOFF updated. Interpretations to confirm: formal principle status and mechanics remain open. No code changes; tests not run (docs only).

## 2026-11-24 — NUL-DIALOGUE-001: Dialogue compendium (Codex)

Created thematic register of 31 proposed lines (10d0d90), including six paired contradictions. Linked foundational, philosophical, master and HANDOFF docs. Interpretations to confirm: suggested triggers, associations and pairings are editorial; no new canon or approved copy. No code changes; tests not run (docs only).

## 2026-11-24 — NUL-DIALOGUE-001a: Earlier dialogue recovery (Codex)

Added 44 recovered entries (91c06e2), including 18 wording fragments. Interpretations to confirm: contextual labels editorial; transcript recovery partial; all copy proposed. No code changes or tests (docs only).

## 2026-11-24 — NUL-DIALOGUE-002: Dialogue architecture (Codex)

Created complete 13-section Bible (db37cb9), cross-linked four companion documents, master and HANDOFF. Interpretations to confirm: schema, events, pacing, cooldowns, content targets and QA are proposals; no implementation approved. No code changes; tests not run (docs only). LOG-001: moved oldest dated entry unchanged to archive.

## 2026-11-24 — OPS-001: Shared operations hub (Codex)

Created shared registers, report template and agenda; linked native issues/PRs; updated identical agent instructions. Interpretations to confirm: session-end reports, native issues as to-dos, proposed agenda pending designer confirmation. No code or tests (docs only).

## 2026-11-24 — OPS-002: Milestone progress (Codex)

Added proposed release goal, eight milestone gates and evidence-based measurement to master; initial provisional snapshot and daily update protocol in operations dashboard. Interpretations to confirm: release scope, gates, weights and baseline; architecture-v2 not audited. No code changes or tests (docs only).

## 2026-11-24 — OPS-002a: Commercial Steam release (Codex)

Designer confirmed actual Steam commercial launch, not merely release readiness. Master records creative goal, expanded M08 and proposed M09; dashboard and HANDOFF updated. Interpretations to confirm: detailed launch gate, pricing, schedule and weights. No code, tests, account or publication action.
LOG-001: oldest dated entry moved unchanged to archive.


## 2026-11-24 — UI-BIBLE-001 (Codex)

**UI-BIBLE-001 (designer direction, 2026-11-24):** [PANOPTICON UI Design Bible](https://github.com/Punkwork/REDLINE/blob/main/docs/PANOPTICON_UI_DESIGN_BIBLE.md) is the consolidated UI working specification, opening with “Visually rich but informationally restrained.” Icon-first resource HUD (Vitae, BW, RAM, Shield, incoming PULP), persistent top Ghostware rail and first ORIGIN badge in mockups. Existing decision IDs and rules authority remain unchanged. Source documents retained pending dependency/narrative audit; no parallel new UI briefs. No code changes. Initial consolidation commit `16265fb`. Documentation only; Godot tests not run. Interpretations to confirm: overflow behavior and exact glyphs remain open; source retirement deferred.


## 2026-11-24 — UI-WORKFLOW-001 (Codex)

**UI-WORKFLOW-001 (designer-approved, 2026-11-24):** GitHub Issues are the single authoritative UI proposal and development register for Claude Code, Claude, Codex and ChatGPT. Use stable component IDs from the UI Design Bible. Keep proposal discussion, mockup links, acceptance criteria, designer approval, implementation links and validation evidence in the issue; do not duplicate the backlog in HANDOFF or separate agent files. Only the designer approves; record approved decisions in Master Design and update the UI Design Bible as applicable. Development Log records actual work and links to the issue. Daily operations review uses the same issues. No code or rules changes. Registered 15 stable component IDs in the UI Design Bible §1a. Documentation only; no Godot tests run. Native issue numbers selected to avoid duplicate proposal numbering. No labels, board or individual issues created in this change.


## 2026-11-24 — DOCS-MIG-001 (ChatGPT)

Designer authorized mandatory documentation migration gate and next-session UI completion priority. Identical agent instructions, Master Design, HANDOFF and shared daily priorities updated. UI reference repair 2f1727f remains partial; full dependency validation, editorial reconciliation and retirement outstanding. Documentation only; no Godot tests run.

## 2026-11-24 — BYPASS-001 (ChatGPT)

Recorded designer rule restricting BYPASS to non-final encounters of Nodes of up to three encounters in master, core rules and HANDOFF. Specific mechanics remain open. No code or tests; no documentation consolidation performed.

## 2026-11-24 — EXP-DESIGN-001 (ChatGPT)

Created all-domain experimentation Bible (7e0928f) with initial BYPASS proposals, experimental cards, scenarios and viability/test framework. Interpretations to confirm: stable ID scheme and editorial organization; all specific mechanics remain proposed. UI issue authority preserved; no consolidation, code or tests.

## 2026-11-24 — BACKCHANNEL-001 (ChatGPT)

Saved designer-endorsed single-subroutine BACKCHANNEL iteration as EXP-C029, alternative versions, EXP-S009–011 and EXP-X004 in Experimentation Bible (ddc4793). Proposed terminology and timing questions retained. No rules, code, tests or consolidation.

## 2026-11-24 — NULL-POINTER-001 (ChatGPT)

Designer approved 1 BW instead of 2 for NULL POINTER; updated Deck Synergy §9.2 (08b5b6f), Master and HANDOFF. Runtime unchanged; no tests run.

## 2026-11-24 — RIOT-EXP-001 — RIOT experimental card catalogue (ChatGPT)

Designer requested preservation in Experimentation Bible §11 (bdc32508a880a9925010b0dde4bdbf0ac7b0fc57). EXP-C030–036, M007, S012–021, X005; revised FIRST STRIKE and one-copy BREAKER BAR with per-copy node escalation and BURN cost. Experimental only; NULL-POINTER-001 remains approved separately. No code or tests; UI migration gate unchanged.

LOG-001 archived oldest dated entry unchanged: ## 2026-11-19 — CARDS-004 and HAND-MAX-001 built: 1.4× cards, fanned hand, hand limit 10 (Claude)

## 2026-11-24 — TRACE-EXP-001 — TRACE mitigation concepts (ChatGPT)

Designer requested preservation of SIGNAL DAMPENER (Ghostware) and four Protocols in Experimentation Bible §12 (bc9938aa034cf6a39c6114472b4688b056e6cf1f); EXP-C037–041, M008, S022–027, X006. Proposed type distinction, self-inflicted TRACE coverage and trigger timing remain experimental. No rules/code changes, tests or consolidation.

## 2026-11-24 — NUL-DIALOGUE-003 — Economic dependency dialogue (ChatGPT)

Designer requested preservation of four lines NR-076–079 in NUL/REM Dialogue Compendium (28cd6dea0d23821902a025414a3333724c4b365c). Verbatim dialogue; contextual triggers and associations proposed. No shipping approval, gameplay changes, tests or consolidation.

## 2026-11-24 — CRED-EXP-001 / PHIL-005 — CRED-powered combat and economic dependency (ChatGPT)

Designer requested preservation of eight cards EXP-C042–049, mechanics M009–011, scenarios S028–034 and experiment X007 in Experimentation Bible §13 (bf8d742d3783d4cdb2a11e17e62d442b7fc8de52), and economic dependency/purchased freedom in Philosophical Design Bible §11 (aaafd9993e811a2a8b1169a9e9f3ed68b97f0bf6). Fully CRED-powered Icepick activations consume no BW; installation costs open. All mechanics experimental; philosophical direction designer-endorsed, not a new formal pillar. NR-076–079 already saved. No rules/code changes, tests or consolidation; UI migration blocker unchanged.

## 2026-11-24 — CRED-EXP-001a — Icepick installation cost (ChatGPT)

Designer specified 1 BW installation for PAYDAY, BRIBE and MERCENARY (EXP-C042–044); all activations remain CRED-only. Experimentation Bible §13 updated (9cfc95fe920dbfd5abfded3bccda06174cabec2b), including S035. Supersedes open installation cost in CRED-EXP-001 for these three cards only. Experimental, no code or tests.

## 2026-11-24 — CRED-EXP-001b — Program classification (ChatGPT)

Designer clarified EXP-C042–044 are RAM-using PROGRAM Icepicks, 1 BW install, CRED-only activation. Exact RAM TBD; 1 RAM suggested only. Experimentation Bible §13 corrected (0045b0d693b7386b6a6a83c83ca194e92005d784); canonical Core Rules §3.1 unchanged. No code or tests.

## 2026-11-24 — CRED-EXP-001c — Icepick RAM requirements (ChatGPT)

Designer specified PAYDAY 1 RAM, BRIBE 1 RAM, MERCENARY 2 RAM. Experimentation Bible §13 (a28329f275b87bd1d163e4e798cf5859b5e96958), EXP-S036; supersedes TBD RAM in CRED-EXP-001b. Other values unchanged. Experimental only; no code or tests.

## 2026-11-24 — VOID-EXP-001 (ChatGPT)

Saved exploratory VOID-only UNLOAD, Rustler-selected Program removal to discard, Program opportunity costs, EXP-M012/S037–042/X008 in Experimentation Bible §14 (171674b7e8b34d0dd4dad805b9861da4e22b0d0b). No rules/code/tests or consolidation.


## 2026-11-24 — CRED-EXP-001d — CRED SCRIPTS and card-type identity (ChatGPT)

Designer confirmed EXP-C045–049 as 0 BW SCRIPTS with existing CRED prices/effects, one resolution per play, normal discard/redraw, prior activation caps removed in preferred experiment. EXP-M013/S043–044, X007 extension in Experimentation Bible §15 (8d75932dad452669d6aefc0864bda40092e118df). Existing Protocols unchanged; experimental guidance only, no rules/code/tests or consolidation.

LOG-001 moved oldest dated entry to archive unchanged: 2026-11-19 — DEV-001: validate the card and hand baseline (Codex).

## 2026-11-24 — ICE-EXP-002 — Encounter-wide effects and subroutine modification (ChatGPT)

Saved 20 proposed cards EXP-C050–069, mechanics M014–015, scenarios S045–052, experiments X009–010 in Experimentation Bible §16 (27d5fb2ea234eaa8b1ebc87dada42b021fee6b17). Designer's targeted -6 PULP this turn/BURN preserved; names/costs provisional, collisions flagged. No rules/code/tests or consolidation.

## 2026-11-24 — CAP-EXP-001 — Infiltration CAPS (ChatGPT)

Saved twelve non-card CAP concepts EXP-CAP001–012, M016, S053–057 and X011 in Experimentation Bible §17 (98bc0b716700ad6aac90a6bc614b46496b5425c0). No CRED prices or rarities assigned; map activation and circumvention experimental. Existing CAPS rules unchanged. No code/tests or consolidation.

LOG-001 moved oldest dated entry to archive unchanged: 2026-11-19 — PIXEL-TRACE-001: TRACE pixelates the corporation's picture (Claude).

## 2026-11-24 — SURV-MEM-001 — Surveillance and memory (ChatGPT)

DIRECTION, designer-confirmed: “As the player learns the game, the game learns the player.” “The system always remembers. It never forgets.” Pervasive fictional surveillance across runs. Five-stage table and proposed memory layers saved in Experimentation Bible §20 (57bfe20002567740e0e91cde85a809df280ce7e2); prior ICE-SURV-EXP-001 / SURV-EXP-001 proposals in §§18–19 (eb335be5b95c05488f3a966f5d90a47280675523). Philosophical Bible cross-reference. No approved mechanical changes, code, tests or consolidation. Interpretation: thematic persistence does not remove real-world local data reset or privacy controls.

## 2026-11-24 — CARBON-SURV-EXP-001 — Collective trust and individual authority

Designer-endorsed philosophical exploration: keep THE CARBON (collective trust) and NUL/REM (personal autonomy) distinct. Corporate appropriation of trusted resistance spaces may erode collective trust and increase reliance on individual authority. “The system creates the conditions that make its own assistance necessary.” Full progression, examples, comparative framework and open questions preserved in [Design Experimentation Bible §21](PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md), commit 02e46011863db27f2ac03ed922aa038358bc8a77. EXP-D003 / EXP-X013 remain proposed; no mandated psychological outcome, approved mechanics, code, tests or consolidation.

## 2026-11-24 — SURV-UNCERT-EXP-001 — The uncertainty of observation

Designer-endorsed exploration: possibility of observation, fictional fear/anxiety/suspicion, ambiguity of coincidence, self-regulation and freedom exhaustion. Designer identified Francis Ford Coppola's The Conversation (1974) as reference. Preserve the “constant low hum anxiety” experiential direction as fictional atmosphere, not deliberate actual distress. Linked to SURV-MEM-001 and CARBON-SURV-EXP-001. Full tables, examples and safeguards in [Design Experimentation Bible §22](PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md), commit 6b36c117b89c4f32edfef77c7241c8fb6db59a28. No approved mechanics, production dialogue, code, tests or consolidation.

## 2026-11-24 — SURV-OBSERVER-EXP-001 — The Internalized Observer

Designer confirmed The Parallax View (1974, Alan J. Pakula) and The Conversation (1974, Francis Ford Coppola) as principal cinematic references. Recorded in Design Experimentation Bible §23, commit 307703473a5a9f3ec8a9fe0a6f34800815d2342b. Reference-only; no new rules, specifications, code or tests.


## 2026-11-25 — ARCH-V2-002: branch reconciliation; `architecture-v2` canonical (Claude)

**Designer approval (2026-11-25):** `architecture-v2` is the main branch moving forward, to be recorded in Master Design; tag the baseline; delete the duplicate image; make the new branch the default. Recorded as ARCH-V2-002.

- **Audit (Gate A):** `main` `21922ad`, `architecture-v2` `6cb5ed1`, common ancestor `f168046`; 182 main-only commits (about 40 decision IDs, 22 files, docs and agent files only) and 43 v2-only commits (ARCH-V2-001 governance, `docs/architecture-v2/`, VAS-001 image). Neither side changed Godot code, tests or CI. No open PRs; no GitHub Issues exist.
- **Merge `6b1acdd`:** `git merge --no-ff` of `main` into `architecture-v2`. Conflicts in Master Design, HANDOFF and this log were additive; both sides kept, unreworded. A line check confirmed every line of both parents is present (lines missing from v2's log are LOG-001 moves already in the archive; HANDOFF rows edited on `main` keep `main`'s wording).
- **Governance correction:** `AGENTS.md` and `CLAUDE.md` (still identical) now name `architecture-v2` in the header, §1, §3 session start, §8 operations and §9 migration gate (sections renumbered; HANDOFF and DAILY_PRIORITIES references updated). HANDOFF "How we work", `operations/README.md`, `REDLINE_CURRENT_STATUS.md` and `REPOSITORY_STRUCTURE.md` updated. Master Design entry ARCH-V2-002 added. Duplicate `PANOPTICON_VAS-001_reference_mockup (1).jpeg` removed (SHA-256 identical to the canonical file, `513af903…df25e`).
- **Baseline and validation:** Godot 4.3.stable.official.77dcf97d8, headless, fresh `XDG_DATA_HOME`. On `main` `21922ad`: import exit 0; `test_game.gd` 176 passed / 0 failed (also with `SIM=1`); `test_adp.gd` 17 / 0; `test_signal_carbon.gd` 672 / 0. Same results on the merged tree. Relative Markdown links: 0 broken. Not run: screenshot fixtures (CI skips them while `Game.CORE_LOOP` is true), Windows export, any Windows playtest. The approved tag `prototype-baseline` on `21922ad` and the default-branch switch were refused by GitHub through the agent proxy (HTTP 403 on tag push; "Repository settings writes are not permitted"); both are left to the designer. Commits: merge `6b1acdd`, correction `b03df7f`, this status fix.
- **Still open:** DOCS-MIG-001 / UI-BIBLE-001 (seven imported sources still in the tree; the UI Bible links them through `blob/main/...` URLs, which should become commit-pinned before retirement); a release procedure for `architecture-v2`; seeding GitHub Issues; external agent configurations that name `main`.
- **Interpretations to confirm:** "main branch for the rebuild" is recorded as covering all project work, per the reconciliation brief.
- **LOG-001:** moved the oldest dated entries to the archive unchanged: 2026-11-19 — PIXEL-TRACE-001a: animated pixel step changes (Claude), 2026-11-19 — PIXEL-TRACE-001b: bit-crushed music with the pixel steps (Claude), 2026-11-19 — PIXEL-TRACE-001c: a transition sound effect, to be chosen (Claude), 2026-11-19 — ENC-ANALOG-001 saved; ICE-ANALOG-001 brief for Codex (Claude), 2026-11-19 — ICE-ANALOG-001: editable Godot visual study (Codex), 2026-11-19 — ICE-ANALOG-001 designer approval for default encounter integration, 2026-11-19 — ICE-ANALOG-001 built; ENC-CONCEPT-001 direction and art briefs (Claude).
- **Update 07:40:** the designer switched the GitHub default branch to `architecture-v2`; verified via the GitHub API. Tag `prototype-baseline` still pending.
- **Update 07:42:** the designer published tag `prototype-baseline` on `21922ad` (GitHub pre-release); verified with `git ls-remote`. ARCH-V2-002 items complete.

## 2026-11-25 — ARCH-V2-002: audit corrections (Claude)

ChatGPT's independent audit (designer-relayed, 07:44) found three governance defects; all confirmed and corrected:
- **AUDIT-001:** HANDOFF session routine said "pull `main`"; now `architecture-v2`.
- **AUDIT-002:** HANDOFF said ARCH-V2-001 superseded MAIN-001 "for migration work only"; now ARCH-V2-002, all active work. HANDOFF item 7 (builds) likewise.
- **AUDIT-003:** Master Design DOCS-MIG-001 said "batches on main"; now `architecture-v2`, with the original wording and the 2026-11-24 authorization kept in the text.
- **Repo-wide scan:** every reference to `main` checked by hand (186 candidate lines). Also corrected: the UI Design Bible links in HANDOFF and Master Design pointed to the frozen copy on `main` (`blob/main/...`), now relative; ARCH-V2-001's stale status note; MIGRATION_PLAN's proposed tag name annotated. Left as history: RELEASE-001/MAIN-001 records, playtest build records, log and archive, legacy-source Codex prompts ("Repo: Punkwork/REDLINE on main" in ENCOUNTER_ANALOG and the UI Bible import), the UI Bible's seven `blob/main/...` source links (DOCS-MIG-001 work), third-party `blob/main` URLs (Google Fonts, gitignore). Scripts and CI contain no branch-specific `main` (CI validates every branch; exports only on `release`).
- **ARCH-V2-002 items operationalized:** h atomic decision-grouped commits (AGENTS/CLAUDE §1.7), i daily branch-drift check (operations README, report template), j `main` protection (AGENTS/CLAUDE §1.8; GitHub protection verified **off**, designer TO DO), g Architecture V2 precedence for UI construction (AGENTS/CLAUDE §4, §7). Master Design lists items a–j with sources.
- **Validation:** test_game 176/0, test_adp 17/0, test_signal_carbon 672/0; 0 broken relative links; AGENTS = CLAUDE; no files from either branch tip lost except the approved duplicate image; no decision ID from either tip's Master Design, Experimentation Bible, Manifestations, UI Bible, Core Rules or HANDOFF lost; no status line changed except the annotated ARCH-V2-001 status; `godot/`, tests, tools, CI and prototypes unchanged vs `prototype-baseline` except the VAS-001 image and its README.
- **Interpretations to confirm:** the audit mentions eight ARCH-V2-002 decisions without listing them; Master Design records ten items (a–j) found in the designer's messages and the brief.

- **LOG-001:** moved the oldest dated entries to the archive unchanged: 2026-11-19 — ENC-CONCEPT-001: concept-3 interface in the encounter (Claude), 2026-11-19 — ENC-CONCEPT-001: ChatGPT art wired into the encounter (Claude).
- **Update 07:53 (ARCH-V2-002j):** the designer created GitHub ruleset `protect-main` (active, target `refs/heads/main`, rules deletion, non_fast_forward, creation, update; no bypass). Verified: `rules/branches/main` returns all four; `architecture-v2` has none. A first save targeted `Main` (case mismatch) and was corrected.
- **Update 08:00 — ChatGPT re-audit (designer-relayed):** AUDIT-001/002/003 verified corrected; eight decisions mapped to a–j (recorded in Master Design); ChatGPT automations reported aligned. Claude added the evidence ChatGPT listed as missing: local work (fresh clone, nothing uncommitted, stashed or unpushed) and a rollback rehearsal in a discarded worktree (reverting the seven ARCH-V2-002 commits restores a tree identical to `6cb5ed1`). Acceptance record added to Master Design; status awaiting designer acceptance.
- **Update 08:23 — designer acceptance:** "Reconciliation accepted." Recorded in Master Design and HANDOFF. Still open: fixtures, Windows export and playtest untested; Claude Project copy refresh; Codex alignment; deferred workstreams (UI-BIBLE-001 / DOCS-MIG-001, GitHub Issues for UI, Architecture V2 release procedure, UI-TYPO-001).
- **Update 08:30 — Project copies (DEV-001):** designer chose "pointer + core docs" (full set is about 2.1 MB, over the 2 MB Project limit). Added `claude/README.md`; refreshed HANDOFF and CORE_RULES; added AGENTS_CLAUDE and ARCHITECTURE_V2_README; deleted TODO, MINIBOSSES and ICE_EFFECTS after checking the repo covers them, and the superseded reconciliation plan. Found: the Project's CORE_LOOP v0.2 spec contains text not in any repo version (ICE notes, bot-sim targets, playtest sheet, build prompt); kept, designer to decide. 21 older snapshots still to check before removal.
- **Update 08:35 — Project copies done (DEV-001):** designer: "I don't think it's necessary to check those project copies. Just archive them. We have a whole new direction going forward." Then chose deletion (git history is the archive) and saving the Core Loop v0.2 spec to the repo. Added `docs/history/REDLINE_CORE_LOOP_v0.2_PROJECT_SPEC.md` (Project text unchanged under a history note); replaced the Project's CORE_LOOP with the repo version; deleted the 21 older Project copies. The Project now holds the README pointer and five current copies.
- **Update 11:40 — Codex aligned (ARCH-V2-002):** Codex couldn't see the repo: its GitHub authorization had disappeared from GitHub's Authorized OAuth Apps (cause unknown; possibly the GitHub re-authorization this morning). The designer reconnected GitHub through Codex's plugins, created a REDLINE environment and ran a read-only check: `b1f14e6` from `architecture-v2` (Codex's local branch is named `work`, as usual for its cloud checkouts), AGENTS.md rules confirmed, `main` = `prototype-baseline` = `21922ad`, no Codex instruction or automation points work at `main`. External agent alignment is complete.

## 2026-11-25 — UI-BIBLE-001 complete: documentation migration gate passed (Claude)

Designer, 11:39: "approved for all 4. Continue." First batch: UI-BIBLE-001 under DOCS-MIG-001.
- **Retired** the seven UI Bible sources (VISUAL_LANGUAGE, ENCOUNTER_ANALOG, UI_NULREM_Design_For_Claude, ATOMIC_DECO_PUNK, UI_KIT_BRIEF 1–3) after confirming each import matched its original line for line; 0 of 1,124 lines missing afterwards. Bible source headings now link to `8ef0bbe` (last commit with the originals) instead of `blob/main`.
- **Relocated** Source 3 §6 (NUL/REM personality design bible) unchanged to Dialogue Architecture Appendix A.
- **Reconciled:** Bible §4 maps retired paths to sections and lists known supersessions; no new design conflict found.
- **Repaired** active references in Archipelago, SAMIZINE, ADP Phase 2 copy, Corporate Facades, Master Design, two exploration READMEs, the painted-UI asset README and an `encounter.gd` comment; repointed 12 log anchors moved earlier by LOG-001 to the archive. History records left as written.
- **Validation:** 142 relative links, 0 broken files or anchors; Godot 4.3 import 0, test_game 176/0, test_adp 17/0, test_signal_carbon 672/0.
- AGENTS/CLAUDE §7 and §9, HANDOFF and Master Design record the gate as passed. No batch open.

- **LOG-001:** moved the oldest dated entries to the archive unchanged: 2026-11-19 — ENC-CONCEPT-001: UI kit brief 2 (Claude), 2026-11-19 — ENC-CONCEPT-001: UI kit brief 3 (Claude), 2026-11-20 — ENC-CONCEPT-001: concept-2 layout pass with UI kits 2 and 3 (Claude).

## 2026-11-25 — UI-WORKFLOW-001: GitHub Issues seeded for UI work (Claude)

Designer approved at 11:39. No UI issues existed. Created label `ui` and seven status labels matching the Bible's workflow (`status: proposed`, `design exploration`, `designer review`, `approved`, `in development`, `validation`, `complete`). Seeded 11 issues from HANDOFF and the UI Design Bible, each with component IDs, decision IDs, source, approval evidence and acceptance criteria: #13 HuCard cards (CARD-HUCARD-001), #14 Playtest 9 UI list, #15 discard view, #16 PROBE-003 drag cost, #17 CACHE-001 icon, #18 PLAY-002 polish, #19 Ghostware rail size/overflow, #20 resource indicator glyphs, #21 VAS-001 vertical slice, #22 ENC-CONCEPT-001 review, #23 legacy cartridge fixtures. Statuses copied from HANDOFF; none newly approved. HANDOFF rows now link their issue instead of repeating the backlog. *Interpretation to confirm:* the Playtest 9 list is one issue with a checklist rather than ten issues.

## 2026-11-25 — RELEASE-002 drafted: playtest builds from architecture-v2 (Claude)

Designer approved drafting at 11:39. Recorded RELEASE-002 in Master Design as **PROPOSED**; RELEASE-001 stays in force. Finding: `release` (`2845ecd`, Playtest 12) is an ancestor of `architecture-v2`, so builds can come from `architecture-v2` by fast-forward alone; the workflow already exports only on `release`, and `release` has no ruleset. The proposal covers version bump → CI → fast-forward cut → artifact check → designer tag → records, fix-forward recovery, and three separate options: (a) a `release` ruleset, (b) artifact name from the version, (c) an entry gate for the first V2 build. No workflow or branch changes made.
- **LOG-001:** moved the oldest dated entries to the archive unchanged: 2026-11-20 — RELEASE-001: HALCYON Playtest 7 (Claude), 2026-11-20 — ENC-CONCEPT-001: program screen; mascot prompt for ACCEPT ALL / REJECT ALL (Claude), 2026-11-20 — ENC-CONCEPT-001: ACCEPT ALL and REJECT ALL mascots (Claude).

## 2026-11-25 — UI-TYPO-001: typography and the dual visual language (Claude)

Designer, 13:17–13:19: two distinct visual representations, the physical world (the UI: 1950s Deco and Atomic Deco Punk, Bakelite, Formica, panels, knobs, switches and a small CRT) and the virtual world (a hyper-kinetic, Gaspar Noé-style title flourish full of motion and electric colour). Recorded as APPROVED in Master Design, added as UI Design Bible §2a, and opened issue #24. The four reference images are still to come (`docs/visual/references/ui-typo-001/`). *Interpretations to confirm:* which elements belong to each world, the CRT as the existing console CRT, and the flourish staying off rules text under reduced motion.
- **LOG-001:** moved the oldest dated entries to the archive unchanged: 2026-11-20 — MOOD-PIXEL-001, program cartridges, AVATAR-001 and ChatGPT round 3 (Claude).
- **Update 13:30 — UI-TYPO-001 images:** the designer's four reference images added to `docs/visual/references/ui-typo-001/` with a README (aggressive flyouts, refined flyouts, title announcements, event typography catalogue; 640 × 360 and 640 × 427 as received). They show the virtual world as event flyout titles over the unchanged console. Flagged: SYN, Neural damage, the full-extraction bonus and "Runner" predate current rules (style reference only). Master Design, UI Bible §2a, HANDOFF and #24 updated.
- **Update 13:38 — UI-TYPO-001 images:** replaced with the designer's 1280 × 720 originals (catalogue 1280 × 853), same names and content.

## 2026-11-25 — RELEASE-002 approved; RELEASE-002b built (Claude)

Designer, 13:48: "commit the release-002. 3 add-ons: a - yes b - yes c - yes". RELEASE-002 replaces RELEASE-001 for every new build; AGENTS/CLAUDE §5 and HANDOFF "How we work" now carry the procedure. **RELEASE-002b built:** a workflow step reads `config/version` from `godot/project.godot` (must end in `-playtest.N`, or the export fails) and names the artifact from it, replacing the hand-edited name. Checked locally: the workflow YAML parses and the step produces `PANOPTICON-HALCYON-PLAYTEST-12-0.12.0-playtest.12-Windows-x86_64`, the same name as before. The export only runs on `release`, so the step itself runs at the next cut. RELEASE-002a (ruleset on `release`) is the designer's to create; RELEASE-002c is the gate for the first Architecture V2 build.
- **LOG-001:** moved the oldest dated entries to the archive unchanged: 2026-11-20 — CAPS rack and Ghostware rail (Claude), 2026-11-20 — HOVER-001 recorded (Claude).

## 2026-11-25 — UI-TYPO-001 readings confirmed; UI-TYPO-001a flyout exception (Claude)

Designer, 13:48: "#24 - 1 yes; 2 - Yes; 3 - sort of - i Imagine the flyouts would cover elements on screen but A - not for more than 1 -2 seconds B - would not hide anything". Readings 1 (event flyouts are the virtual world) and 2 (the console's existing CRT) confirmed. Reading 3 amended as **UI-TYPO-001a**: flyouts may pass over screen elements, including rule text, numbers and buttons, for at most 1–2 seconds and without hiding anything. This is the only exception to ADP-R1, now written into AGENTS/CLAUDE §4, the UI Bible §2a and Master Design. *Interpretation to confirm:* "would not hide anything" = what's underneath stays readable through the flyout and nothing is removed while it shows. Issue #24 updated.
- **Update 14:26 — UI-TYPO-001a confirmed:** designer: "yes that is what i meant". "Without hiding anything" = what's underneath stays readable through the flyout (see-through or offset from key values) and nothing is removed while it shows. Master Design and UI Bible §2a updated; #24 updated. No open UI-TYPO-001 interpretations remain.
- **Update 14:45 — RELEASE-002a done:** the designer created ruleset `release` (id 28104142): active, target `refs/heads/release`, rules deletion and non_fast_forward, no bypass. Verified: `rules/branches/release` returns both; `architecture-v2` has none. The first save had no target and was disabled; corrected. Daily drift check now includes it.

## 2026-11-26 — UI-TYPO-001 / UI-TYPO-001a: Typography & Motion Design System milestone (Codex)

Designer approved the visual exploration constraints in *UI Prototype Exploration* and directed the milestone to run alongside Priority 1 Representative ICE Encounter & Component Architecture. Recorded constraints in UI Bible §2a, the M06 checkpoint and acceptance steps in Master Design, and presentation dependencies in CAS-001. See [#24](https://github.com/Punkwork/REDLINE/issues/24) and [#21](https://github.com/Punkwork/REDLINE/issues/21). Psychological typography remains experimental. Documentation only. No gameplay, architecture implementation, release or migration-gate changes. Verified affected paths and anchors against the GitHub tree and document content. Godot tests were outside this documentation-only check. Implementation and acceptance evidence are pending.

**Interpretations to confirm.** The named milestone sits within M06 and leaves the existing nine final gate definitions in place. The roadmap uses ordered steps and existing decision, component and issue IDs.

**LOG-001:** moved the oldest dated entries to the archive unchanged: 2026-11-20 — HOVER-001 built (Claude); 2026-11-20 — HOVER-001: subroutine tips list every effect (Claude); 2026-11-20 — ChatGPT round 4 prompts: the other Node types and the map (Claude).

## 2026-11-26 — ARCH-V2-001 / CAS-001 / VAS-001 / OPS-001 inventory authorization (ChatGPT)

Designer confirmed representative encounter as Priority 1, approved six-stage sequence and mockup-first component development; typography/motion including stage and transition announcements required. Explicitly authorized Claude Code functional/runtime inventory and Codex visual/asset inventory, not production implementation. Scope and stopping gate in HANDOFF and DAILY_PRIORITIES (6db9bb0, 6d55a24). No gameplay, branch or release changes; no Godot tests run for this documentation update.

## 2026-11-26 — ARCH-V2-001 / CAS-001 / VAS-001: representative encounter runtime inventory (Claude Code)

Authorized inventory only; no production code changed. Godot 4.3-stable `77dcf97d8`, Linux, GL Compatibility on Mesa llvmpipe. At `fc2923b`: import exit 0; `test_game.gd` 176 passed / 0 failed (also `SIM=1`); `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; no SCRIPT ERROR, Parse Error or Assertion failed. Matches `prototype-baseline`. Live N2A run under Xvfb (seed 711): response resolved once per step, CAPTCHA rotated, DISCARD choice opened; captures in `docs/visual/fixtures/arch-v2-inv-001/`. VAS-001 reference SHA-256 `513af903…df25e` recorded. Findings: two break dispatch paths (click via `main._on_break`, drag direct to `Game.break_sub`); `response_preview()` carries hidden effects; CI skips every screenshot fixture under CORE_LOOP. C01–C18 classification, proposed N2A encounter, Batch 1 file list and ownership, and designer decisions D1–D3 in [the report](operations/reports/2026-11-26-Claude-Code.md); [#21](https://github.com/Punkwork/REDLINE/issues/21), [#24](https://github.com/Punkwork/REDLINE/issues/24). Stopped for designer approval.

## 2026-11-26 — ARCH-V2-003: Batch 1 ICE encounter components built (Claude Code)

Designer approved Batch 1 in principle with UI alignment requirements (recorded in Master Design ARCH-V2-003, `0ae151b`). Built on `architecture-v2` (`1e07d20`, `8017aad`): EncounterController (C02), VisibleStateAdapter (C04), VasTokens + replaceable IcePanelLayout (C18), IceLane (C07), four-zone IcePanel (C08), SubroutineKey reusing Build 12's IceKey (C09), KeyInspector, provisional shared ResponseRail, EventFlyout (RUSTLER TURN / CORP COUNTERMEASURE) and a playable N2A sandbox (`scenes/architecture_v2/IceEncounterSandbox.tscn`). No rules, `Main.tscn`, legacy UI or project-setting changes. Tests (Godot 4.3, Linux): import 0; `test_game.gd` 176/0 (also SIM=1); `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; new `test_arch_v2_ice.gd` 124/0 (click/Enter/drop parity with direct Game across two responses, one Game call per intent, stale refs, hidden-info stripping, reconcile identity, flyout ≤ 1.5 s). `shot_arch_v2_ice.gd`: 19 captures incl. 1366×768, 1920×1080, 2560×1080 and a VAS-001 side-by-side; selection in `docs/visual/fixtures/arch-v2-batch1/`. Found and worked around a Godot 4.3 crash when a coroutine method returns without awaiting, and a teardown crash from focus signals during free. [#21](https://github.com/Punkwork/REDLINE/issues/21), [#24](https://github.com/Punkwork/REDLINE/issues/24).

## 2026-11-26 — VAS-001 / UI-TYPO-001: approved visual fixtures (Codex)

Built the standalone ICE and event typography scenes in `godot/tests/visual/`. Windows Godot 4.3 GL Compatibility capture checks passed for both. Baseline suites passed 176/0, 17/0 and 672/0. Rechecked the fixture captures on Batch 1 at `f7ad521`. Batch 1's automated suite passed 124/0 with CanvasItem/ObjectDB teardown warnings. The ICE study reads seeded N2A state. The typography study uses scripted payloads and compares full, reduced-motion and reduced-flash playback. Production wiring and review remain in [#21](https://github.com/Punkwork/REDLINE/issues/21) and [#24](https://github.com/Punkwork/REDLINE/issues/24).

## 2026-11-26 — ARCH-V2-003j: ICE type and STR hover wording (Claude Code)

Designer set the badge hover wording: the type badge shows only FORTRESS, TUMBLER or VOID; the STR badge shows only `ICE STRENGTH: n` (current STR). Implemented in `IcePanel._inspect_badge`; the self-written type explanations were removed from the adapter; one-line hover plates size to their words. `test_arch_v2_ice.gd` 125/0 (new STR check); baseline 176/17/672 unchanged; capture `docs/visual/fixtures/arch-v2-batch1/v2_11_void_type_inspector.jpg` refreshed. [#21](https://github.com/Punkwork/REDLINE/issues/21).

## 2026-11-26 — ARCH-V2-003k/l: STR medallion number only; VAS-ASSET-001 asset spec (Claude Code)

Designer asked to remove the drawn glyph above the STR value (it obscured it): removed from `IceBadge`; the number is centred and slightly larger; captures refreshed. Designer agreed the asset split; wrote `docs/architecture-v2/VAS-001_ASSET_SPEC.md` (VAS-ASSET-001, PROPOSED): 2× reference sizes, nine-slice margins, P0 parts for ICE well, rail, header, left rail, tray/END TURN/chassis, engine-built effects, existing art reused now, three ready-to-paste ChatGPT conversations and an acceptance checklist. `test_arch_v2_ice.gd` 125/0. [#21](https://github.com/Punkwork/REDLINE/issues/21).

## 2026-11-26 — VAS-ASSET-001: icon-first correction to the asset spec; painted parts delivered (Claude Code)

Designer flagged that the spec planned word labels inside instrument housings (meter-row label space; TURN, TRACE, PHASE, HOSTILE REVEAL, HARDENING and typed active-effects text), contradicting the icon-first resource HUD (UI-BIBLE-001) and ARCH-V2-003. Added spec §2a (what each housing shows: icon + number; words only in hover/focus, flyouts, nameplate, title, ad copy), withdrew the label plans, rewrote the meter-row and note-card prompts. Painted parts are blank, so none needed redoing. Delivered so far (ChatGPT via designer, checked by Claude Code): conversation 1 complete (14 parts; TUMBLER/VOID/STR medallions built in-house on the FORTRESS rim), conversation 2 parts 1–10. Manifest `godot/assets/architecture_v2/MANIFEST.md`. [#21](https://github.com/Punkwork/REDLINE/issues/21).

## 2026-11-26 — PHIL-001a: Philosophical Design Bible opening epigraph (Codex)

The designer confirmed the placement and supplied the interview. Added the exact passage as the opening epigraph and linked its relevance to existing design sections. The interview transcript supports attribution to Fenigson as speaker. Original authorship is unverified. Checked the wording, heading links, and documentation scope. Godot tests were outside this documentation change.

## 2026-11-26 — ARCH-V2-003: composition pass to the VAS-001 reference (Claude Code)

Designer confirmed the VAS-001 image as the target and asked to start the composition pass. The sandbox is now laid out to the reference's coordinates with the 34 VAS-ASSET-001 painted parts: `V2Art` loads them pre-scaled (Lanczos) so they stay crisp; the ICE panel is the painted window with portrait left, nameplate + STR medallion top right, type medallion on the portrait corner, a key bed sized to the keys and the status strip (compact variant at three ICE keeps keys ≥ 44 px); the response rail is painted capsules with icon + number; meters, turn, phase, TRACE and the deck/discard/burned stack are icon + number with names on hover (VAS-ASSET-001 §2a); END TURN is an illuminated key (ARCH-V2-003m). No rules, `Main.tscn` or project-setting changes. Tests: import 0; `test_game.gd` 176/0; `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; `test_arch_v2_ice.gd` 127/0; `shot_arch_v2_ice.gd` 19 captures. Captures `docs/visual/fixtures/arch-v2-composition/`. Interpretations to confirm in HANDOFF. [#21](https://github.com/Punkwork/REDLINE/issues/21).

## 2026-11-26 — PHIL-006: Panoptic society (Codex)

Reviewed the full English auto-caption transcript linked by the designer. Added a timestamped design reference in Philosophical Design Bible §12 on self-discipline, institutional and peer oversight, language and collective agency. Checked dates, links and documentation scope. Godot tests were outside this edit.

## 2026-11-26 — ARCH-V2-003o/p: fanned hand, large ICE avatars, speech-bubble room, revised avatar art (Claude Code)

Designer answers to the composition-pass questions recorded as ARCH-V2-003q. Designer asked for the hand to be fanned as in VAS-001 (ARCH-V2-003o): new `HandFan` (cards spread, tilt from centre, arc, focus/hover lift; reduced motion snaps). Designer said three-ICE avatars were far too small and needed room for comic bubbles (ARCH-V2-003p): three ICE now use a taller nine-sliced panel (avatar ~160 px on screen, nameplate and bubble beside it, keys below); every panel reserves a `SpeechBubble` zone using the painted cream balloon. Reviewed the designer's local ChatGPT art folder (585 files: 55 ICE × 3 moods, ~100 card illustrations, Ghostware, CAPs, backgrounds, UI parts); imported the 30 revised avatars for the 11 HALCYON ICE (576 px, `godot/assets/architecture_v2/avatars/`; TERMS_OF_SERVICE wary and HOUSE_CALL cheery/wary are not in the folder and fall back). Tests: import 0; `test_game.gd` 176/0; `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; `test_arch_v2_ice.gd` 138/0; 21 captures. (LOG-001: moved "2026-11-21 — RELEASE-001: HALCYON PLAYTEST 8 (core loop) exported (Claude Code)" to the archive.)

## 2026-11-26 — ARCH-V2-003r: avatars, subroutines and hand take the focus (Claude Code)

Designer: avatars as large as VAS-001 (at least half the field), bubbles momentary (1–2 s, covering what is under them), keys may overlay the avatar's foot with a drop shadow, six subroutines must work at three ICE, keys should be thick raised panel buttons lit from within with a slight glow. Built: `IcePanelLayout` reworked (frameless avatar 304 px of 586 at two ICE, 400 px centred at three ICE; thin nine-sliced bezel; keys float over the avatar's foot, no bed; status strip under the keys); `IcePanel.say(text, seconds)` shows the bubble on top for 1.6 s; new `LitKey` (extends Build 12's `IceKey`, which stays unchanged for `main`) draws socket, glow, cap side, lit face, specular band, drop shadow; the inspector uses it too. New checks: avatar ≥ half the window and above the keys; six keys ≥ 44 px inside a three-ICE panel. Tests: import 0; `test_game.gd` 176/0; `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; `test_arch_v2_ice.gd` 144/0; 21 captures.

## 2026-11-26 — ARCH-V2-003s/t: full-width encounter layout, power-button END TURN, ADP-2b speech (Claude Code)

Designer layout change: the ICE enclosure spans the screen (panels 700 × 352; three ICE 720 × 550), CRT with the rig and the effects note lower left, meters right of the hand, second CRT and side pipe removed, END TURN a small round brown power button in the bottom-right corner. Speech: `HesitationVoice` implements ADP-2b (4 s hover, highest mood, 20 s cooldown, once per turn, not while dragging) with the approved Copy Pack lines; 10 new checks. Tests: import 0; `test_game.gd` 176/0; `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; `test_arch_v2_ice.gd` 154/0; 21 captures.

## 2026-11-26 — ARCH-V2-003u/v: 12-card hand, cartridge rig, right-side keys (Claude Code)

Designer: counters horizontal and narrower under the meters, hand tray widened for up to 12 cards (left half of each visible), installed programs as HuCard cartridges sticking out of the CRT (click shows the program and activates it), subroutine keys right-aligned with a second row past four (5 = 2 over 3). Built `RigBay` (cartridges, program screen; selection sets `EncounterController.active_program`, no Game call), horizontal `CounterStack`, card size 140 × 221, `IcePanel.row_split`. New checks: 12-card half-visibility, counters under meters, cartridge selection, five-key row order and right alignment, six keys in two rows. Tests: import 0; `test_game.gd` 176/0; `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; `test_arch_v2_ice.gd` 167/0; 22 captures (CI count updated). (LOG-001: moved "2026-11-21 — FORM-001 and FORM-002: ICE forms and more threat (Claude Code)" to the archive.)

## 2026-11-26 — ARCH-V2-003w: program actions on the CRT (Claude Code)

Designer: effects such as Icepick BOOST are chosen from the CRT; six keys 3 + 3 approved; no row arrow needed (mock drawn). Added `EncounterController.request_boost / request_uninstall_cache / request_unload` (one Game call each) and CRT action keys in `RigBay.ProgramScreen`. New checks: BOOST from the CRT (+STR, BW spent, one call), EJECT removes the cartridge. Tests: import 0; `test_game.gd` 176/0; `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; `test_arch_v2_ice.gd` 170/0; 23 captures (CI count updated).

## 2026-11-26 — ARCH-V2-004: Batch 2 cards, hand, targeting, choices (Claude Code)

Designer started Batch 2. Built `CardView` (HuCard body drawn in the engine, type frame, cost medallion, rules field, gold contacts; states), the hand of CardViews in the fan, the card inspector (HOVER-001), ICE targeting (`IcePanel.set_targetable`, `IceLane.target_chosen`, CHOOSE AN ICE plaque), `ChoiceOverlay` (all current choice variants with the prototype's wording), controller choice intents. The DEV stand-in buttons are gone. New checks: hand UIDs and playability, click-to-play parity, targeting on/cancel/play parity, DISCARD overlay open/choose parity. Tests: import 0; `test_game.gd` 176/0; `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; `test_arch_v2_ice.gd` 182/0; 25 captures (CI count updated). Captures `docs/visual/fixtures/arch-v2-batch2/`. (LOG-001: moved "2026-11-21 — BOOST-001 and SUB-001 after Playtest 9 (Claude Code)" to the archive.)

## 2026-11-26 — ARCH-V2-005: coverage table, coverage test, header CAPS and PROTOCOLS slots (Claude Code)

Designer (18:22): build the coverage table, the test and the placeholders before Batch 3; CAPS and PROTOCOLS slots, 3 each, in the header; turn indicator and TRACE meter at half width; ChatGPT prompts and a layout image. Built `ENCOUNTER_COVERAGE.md` from `godot/tests/arch_v2_coverage.json` (63 rows; `tools/arch_v2_coverage_md.py`), `test_arch_v2_coverage.gd` (in CI), `HudWidgets.SlotRack/RackSlot/RackIcon`, `VisibleStateAdapter.protocol_models/cap_models`; phase plaque and TRACE gauge use half-width art when it lands and nine-slice the old parts meanwhile. ChatGPT prompts: VAS-ASSET-001 §6e; layout image `docs/visual/fixtures/arch-v2-batch2/v2_header_slots_layout.png`. Tests (Godot 4.3, headless): `test_game.gd` 176/0; `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; `test_arch_v2_ice.gd` 182/0; `test_arch_v2_coverage.gd` 506/0; screenshots 28 (CI count updated). No rules change. (LOG-001: moved "2026-11-21 — RIDER-001, AMEND-001, DEFRAG-001, PLAY-002 after Playtest 10 (Claude Code)" to the archive.)

## 2026-11-26 — ARCH-V2-005d: header slot art wired (Claude Code)

Designer uploaded the seven ChatGPT parts from VAS-ASSET-001 §6e. Trimmed (already transparent), icons squared to 256 px, added to `controls/` and `icons/` with manifest rows. Wired: half plaque and slot rack as nine-slices (both wider than asked), TRACE lights the half housing's ten baked cells, sockets frame the slot contents in their windows, group icons sit in the rack's round socket. Racks 219 px wide (x 748 and 973); slots about 37 × 41 px; the coverage test's slot-size check follows the art (≥ 34 × 38). Tests: `test_arch_v2_ice.gd` 182/0; `test_arch_v2_coverage.gd` 506/0; screenshots 28. No rules change.

## 2026-11-26 — ARCH-V2-006: homes for the remaining encounter UI recorded (Claude Code)

Designer answered the coverage table's open rows (19:12, follow-ups 19:20). Recorded in Master Design ARCH-V2-006 (a)–(g); coverage JSON and `ENCOUNTER_COVERAGE.md` updated (OPEN 0, BATCH3 20); ChatGPT prompts for the eye, Ghostware reel housing and speaker grille added as VAS-ASSET-001 §6f. 19:21: strike lamps under the eye and a LOCKDOWN flyout approved (006h); no log ticker, the log opens from the NEXT RESPONSE rail (006i). No code change.

## 2026-11-26 — ARCH-V2-006: Batch 3 built (Claude Code)

Designer: "start batch 3" (19:22). Built in five commits (3a header, 3b rail, 3c events, 3d cards, 3e speakers/settings/sequencer); every BATCH3 row of the coverage table is BUILT. Details and interpretations: Master ARCH-V2-006 (Batch 3 built). New `test_arch_v2_batch3.gd` in CI. Tests (Godot 4.3 headless): `test_game.gd` 176/0; `test_arch_v2_ice.gd` 204/0; `test_arch_v2_coverage.gd` 535/0; `test_arch_v2_batch3.gd` 94/0; screenshots 36. No rules change. (LOG-001: moved "2026-11-22 — Playtest 11 results (Claude)" to the archive.)

## 2026-11-26 — ARCH-V2-006j: TRACE STRIKE banner removed; Batch 3 interpretations approved (Claude Code)

Designer (20:35): remove the TRACE STRIKE banner, keep the rest under the typography rules; the other Batch 3 choices approved. Removed the banner and its token; the response no longer waits on it. Tests: `test_arch_v2_batch3.gd` 94/0, `test_arch_v2_ice.gd` 201/0. No rules change.

