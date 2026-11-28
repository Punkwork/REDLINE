# Working agreement for AI agents (Claude Code, Claude, Codex)

This repository, Punkwork/REDLINE, is the shared source of truth for every agent working on PANOPTICON (a Godot 4.3 deck-building roguelike; the repo and file prefix are REDLINE, the game is PANOPTICON).

**Branches (ARCH-V2-002, designer 2026-11-25):** `architecture-v2` is the canonical active branch for all project work: code, design docs, philosophy and narrative, experimental records, governance, operations, tests and reference assets. `main` is the preserved legacy prototype and historical reference (tag `prototype-baseline` = `21922ad`); no new work goes to `main`. `release` holds designer-authorized builds only.

`AGENTS.md` and `CLAUDE.md` must remain identical. Edit both together, word for word.

## 1. Rules for every agent

1. **Start from the latest `architecture-v2` (ARCH-V2-001, ARCH-V2-002).** Pull before beginning work. `main` is the preserved legacy prototype; do not push new work of any kind to `main`.
2. **Record design decisions in `docs/REDLINE_MASTER_DESIGN.md`.** Other docs and chat transcripts do not count as decisions until they are in the master document.
3. **Report the commit.** When work is finished, tell the user the commit hash where it lives.
4. **Branch policy (ARCH-V2-001, ARCH-V2-002):** all work lands on `architecture-v2`, which is also the repository default branch (switched by the designer 2026-11-25). Ask before creating any further branches, merging into `main`, changing the default branch, or cutting a release. `main` was merged into `architecture-v2` once (ARCH-V2-002) and is otherwise left unchanged.
5. **Only the designer approves.** A proposal stays PROPOSED until the designer approves it in a session. Never mark anything APPROVED yourself.
6. **Every change carries a decision ID** (e.g. ARCH-001) in the design doc, `docs/HANDOFF.md` and `docs/REDLINE_DEVELOPMENT_LOG.md`.
7. **Atomic, decision-grouped commits (ARCH-V2-002h).** Wherever practical, put all changes for one decision in one commit (or one small, clearly labelled series), with the decision ID in the message. This applies to all work, not only documentation consolidation. Don't mix unrelated decisions in one commit.
8. **Protect `main` (ARCH-V2-002j).** Never commit, push, merge, rebase, force-push or delete on `main` or the `prototype-baseline` tag. If `main` has moved from `prototype-baseline`, stop and report it to the designer.

Copies of design docs kept outside this repository, such as Claude Project docs or chat attachments, may be stale. When they disagree with this repository, this repository wins.

## 2. Roles (DEV-001, 2026-11-18)

- **Claude Code** is the main code developer: the Godot build (`godot/`), tests, fixtures, CI, exports, `docs/REDLINE_CURRENT_STATUS.md`.
- **Claude (claude.ai / Cowork, the "Panopticon" project)** owns design: design docs and proposals, playtest analysis, `docs/HANDOFF.md`, and the Claude Project copies of the docs.
- **Codex** takes small, isolated tasks only when the designer asks for one (e.g. a shader tweak or a self-contained helper). It follows this same file.
- **Either** may make small doc fixes that follow a decision already recorded.

## 3. Session routine

- **Start:** pull `architecture-v2`; read `docs/HANDOFF.md`, then the latest entries of `docs/REDLINE_DEVELOPMENT_LOG.md`, then `docs/ARCHITECTURE.md` before touching code.
- **End:** in `docs/HANDOFF.md`, move finished items to *Done* or *Built* with the commit; add new items. Add a dated log entry tagged `(Claude Code)`, `(Claude)` or `(Codex)`. Note anything you had to decide yourself under **Interpretations to confirm**.
- **Log size (LOG-001):** keep the development log under about 60 KB; move the oldest whole entries, unchanged, to the end of `docs/REDLINE_DEVELOPMENT_LOG_ARCHIVE.md` and note the move.

## 4. The code: guardrails

**Engine and style**
- **Godot 4.3, GL Compatibility renderer.** Do not upgrade the engine or change project settings without the designer's approval.
- **Typed GDScript**, as the existing code does (`var g: Game`, `func _ready() -> void`). Follow the folder layout and naming already in the repo.
- **Existing prototype:** the UI is built in code, with one scene (`godot/scenes/Main.tscn`) and no autoloads. **Approved future direction (ARCH-V2-001):** design a hybrid scene-based, component-driven, data-driven UI. Reusable `.tscn` scenes, typed GDScript components, theme/resources and narrowly scoped signals are permitted on `architecture-v2` where justified by a reviewed architecture plan. Do not introduce global autoloads, a global signal bus, or unrelated refactors automatically. Preserve gameplay/presentation separation. This permission is not approval to implement every proposed scene or to rewrite the rules engine. **Precedence (ARCH-V2-002g):** for new Godot UI on `architecture-v2`, the approved ARCH-V2-001 direction and reviewed `docs/architecture-v2/` plans govern how the UI is built; the prototype's code-built, single-scene conventions describe `main` only and do not bind new work. The prototype stays the behavioural reference.

**Map (details in `docs/ARCHITECTURE.md`)**
- `godot/scripts/core/`: the rules engine and data (`game.gd`, `cards.gd`, `ice.gd`), NUL/REM, punch cards, THE CARBON record, local JSON helper and copy guards.
- `godot/scripts/ui/main.gd`: app shell, menus, map, settings. `godot/scripts/ui/friendly_lie/`: the encounter presentation (Friendly Lie, Chrome Deco, cartridges, Atomic Deco Punk, SAMIZINE), including the local ad profile in `play_profile.gd`.
- `godot/data/`: copy tables and presentation tuning (JSON). ADP and ARCH copy have per-line approval fields.
- `godot/tests/`: `test_*.gd` (headless checks) and `shot_*.gd` (screenshot fixtures, write to the directory in `SHOT_DIR`).

**Do not**
- **Refactor or restructure working code unless the designer asks.** Make the smallest change that does the job. If something should be refactored, propose it in HANDOFF instead.
- **Change rules behaviour** (anything in `game.gd`, `cards.gd`, `ice.gd` that affects play) except to implement an approved rule. The rules docs (`docs/REDLINE_CORE_RULES.md` and the docs it names) are the authority.
- **Let presentation read into rules.** Bleed, mood, wear, voice and ads are presentation only; rules code never reads them.
- **Break the readability rules:** text contrast at least 4.5:1; no effect, wear, graffiti or decoration may cross rule text, numbers, card names, costs or buttons (ADP-R1, `docs/PANOPTICON_UI_DESIGN_BIBLE.md` (VIS-001 accessibility, Source 1 §2.9)). Only exception: UI-TYPO-001 event flyouts may pass over them for at most 1–2 seconds and must not hide anything (UI-TYPO-001a).
- **Break the copy guards:** a `reveal` line never shows before the third punch card (SIGNAL-001); the full word "Archipelago" never appears on screen, the underworld writes **’Pelago** (U+2019), and neither form appears in corporate or rules strings (ARCH-SLANG-001); "gulag" never appears on screen; no QR codes anywhere.
- **Send data off the machine.** Play stats, ads and THE CARBON stay in `user://`.

**Tests (run before every commit that touches `godot/`)**

From the repository root, set `GODOT` to the Godot 4.3 editor executable. Import before running scripts on a fresh checkout.

```bash
GODOT=/path/to/Godot_v4.3-stable_linux.x86_64
"$GODOT" --headless --path godot --editor --import --quit
"$GODOT" --headless --path godot --script res://tests/test_game.gd
"$GODOT" --headless --path godot --script res://tests/test_adp.gd
"$GODOT" --headless --path godot --script res://tests/test_signal_carbon.gd
```

Screenshot fixtures need a display and a writable output directory. On display-less Linux, install Xvfb and xauth. Use a fresh user-data directory to keep fixture writes away from playtest records.

```bash
fixture_dir="$(mktemp -d)"
export SHOT_DIR="$fixture_dir/screenshots"
export XDG_DATA_HOME="$fixture_dir/user-data"
mkdir -p "$SHOT_DIR" "$XDG_DATA_HOME"

xvfb-run -a -s '-screen 0 1600x1100x24' "$GODOT" \
  --audio-driver Dummy --rendering-driver opengl3 --path godot \
  --script res://tests/shot_signal_carbon.gd
```

On a desktop with a working display, run the Godot command directly. Use a disposable profile for fixtures on platforms that do not honor `XDG_DATA_HOME`. Substitute each `shot_*.gd` in the authoritative list in `.github/workflows/godot-validation.yml`. Run mouse-driven fixtures serially on a shared display.

Use `SIM=1 "$GODOT" --headless --path godot --script res://tests/test_game.gd` to add bot simulations. `SIM_ONLY` can select one Rustler. Check both exit codes and logs. Any `SCRIPT ERROR`, `Parse Error` or `Assertion failed` is a failure. Report pass/fail counts in the log.

## 5. Builds (RELEASE-002, designer 2026-11-25; replaces RELEASE-001)

Only when the designer asks for a playtest build:
1. **Prepare** one commit on `architecture-v2`: bump `config/version` in `godot/project.godot` (it must end in `-playtest.N`; the workflow names the build from it, RELEASE-002b) and update the bundled playtest guide and checklists.
2. **Check:** CI passes on that commit.
3. **Cut:** fast-forward `release` to that commit and push. Never commit to `release` directly, and never move it backwards.
4. **Verify the artifact:** `BUILD_COMMIT.txt` matches, `SHA256SUMS.txt` matches the `.exe`, and the guide and checklists are present. An export is not a playtest; the designer's first launch is the hands-on check.
5. **Tag:** the designer tags `playtest-N` (agent sessions can't push tags); the agent verifies it.
6. **Record:** HANDOFF, development log and operations report, with commit, Actions run and artifact links.

A bad build is fixed forward (new commit, new cut); an earlier build is rebuilt from its tag. Moving `release` backwards needs explicit designer approval each time. **First Architecture V2 build (RELEASE-002c):** only after the representative ICE encounter exists, its component tests and screenshot fixtures are in the CI list, and its behaviour matches the `prototype-baseline` results. `main` gets no new builds while it is frozen.

## 6. Approved architecture migration (ARCH-V2-001, designer 2026-11-23)

- `architecture-v2` is the primary development branch for the full-game rebuild and, under ARCH-V2-002, for all other project work. `main` is the stable, preserved four-node prototype. No automatic merges between them.
- Target: hybrid Godot 4.3 GL Compatibility architecture using scene composition for meaningful screens/widgets, reusable typed GDScript components, data-driven content and corporation presentation, and independent game rules. Scene boundaries and data formats must be proposed and reviewed before broad implementation.
- Preserve and regression-test the proven rules engine (`game.gd`, `cards.gd`, `ice.gd`) as the initial behavior reference. No gameplay or balancing changes are authorized by this architecture decision.
- First deliverable is an architecture plan and one fully playable representative ICE encounter; compare against existing behavior and tests. Expand only after validation. Prefer small testable modules over giant scripts or excessive tiny scenes.
- Prototype baseline: `main` at `21922ad`, tagged `prototype-baseline` (ARCH-V2-002, 2026-11-25; created by the designer as a GitHub pre-release). Recorded results: import exit 0; `test_game.gd` 176 passed / 0 failed (also with `SIM=1`); `test_adp.gd` 17 / 0; `test_signal_carbon.gd` 672 / 0. Screenshot fixtures are skipped while `Game.CORE_LOOP` is true; the Windows export was not run. Compare migration code against this baseline.
- Keep designer-only approvals, decision IDs, copy guards, readability, privacy, CI and release protections intact. The new branch is not a blanket approval for implementation details.

### Architecture documentation review (ARCH-V2-001)

Before proposing or implementing a significant architecture change on `architecture-v2`, read `docs/architecture-v2/ARCHITECTURE_DECISIONS.md` and `docs/architecture-v2/COMPLIANCE_CHECKLIST.md` alongside the blueprint and authoritative rules. Document the relevant checklist results, evidence, exceptions, and designer review in the change handoff. A proposed scene hierarchy or resource contract is **not** automatically approved. This documentation review requirement does not authorize any gameplay or structural change by itself.

## 7. Design docs: which are current (DOCS-001)

When docs disagree: **`docs/REDLINE_MASTER_DESIGN.md`** (decisions and register) wins, then **`docs/REDLINE_CORE_RULES.md`**, then the topic docs it names. Within a rules doc, its **"Later amendments"** tables win over older text in the same doc, even where that text wasn't edited.

**Node authority (NODE-AUTHORITY-001, designer 2026-11-27):** for Node categories and identities, primary Node purposes, functional boundaries, permitted and prohibited Node services, the assignment of services to Node types, exceptions to Node specialization and the relationships between Node functions, **`docs/REDLINE_CORE_RULES.md` §8.3 is the single current definition**. It wins over every other doc on these points, including Master Design decision copies and "Later amendments" tables. Master Design records the approval and history only. Every other active doc, agent instruction, handoff and log refers to Core Rules §8.3 instead of restating it; do not create a Node design bible, Node register or second Node table. A future change to a Node's purpose or services is made in Core Rules §8.3 and nowhere else, with its decision record in Master Design. Map generation stays with Core Rules §10 and MAP-003e/MAP-003f; balance values for a service stay where §8.3 points to them.

**UI construction vs UI design:** how the UI is built follows ARCH-V2-001 and `docs/architecture-v2/` (§4, §6); what it looks like and says follows Master Design and the UI Design Bible.

**Current**
- UI working specification: `docs/PANOPTICON_UI_DESIGN_BIBLE.md` (UI-BIBLE-001). Master Design decisions prevail; imported historical material is not a new approval. Extend the Bible instead of creating parallel UI briefs. Its seven legacy sources were retired by UI-BIBLE-001 (2026-11-25); the Bible's §4 maps each old path to its section.
- What's next: `docs/HANDOFF.md`. What the build does now: `docs/ARCHITECTURE.md` ("Slice boundaries") and `docs/REDLINE_CURRENT_STATUS.md`. The HALCYON slice is only four map rows, so the code is not a full picture of the design.
- Rules: `docs/REDLINE_CORE_RULES.md` (Node purposes and services are §8.3, NODE-AUTHORITY-001; the map is §10).
- Topic docs: `REDLINE_RUSTLERS.md`, `REDLINE_CARD_POOLS.md`, `REDLINE_ICE_CORP1.md`–`3.md`, `REDLINE_ICE_RULES_BIBLE.md`, `REDLINE_ICE_PASSIVES.md`, `REDLINE_UPLINK_AND_CAPS.md`, `REDLINE_UPGRADES_EVENTS_ESCAPE.md`, `REDLINE_ENGINES.md`, `REDLINE_DECK_SYNERGY.md`, `REDLINE_PACING.md`, `REDLINE_PLAYTEST_CHECKLIST.md`.
- Look and tone: `PANOPTICON_UI_DESIGN_BIBLE.md` (VIS-001 and ADP-001), `REDLINE_ADP_PHASE2_COPY.md`, `REDLINE_CORPORATE_FACADES.md`, `REDLINE_SAMIZINE.md`, `REDLINE_ARCHIPELAGO.md`.

**Not current for rules (history or lore only)**
- `REDLINE_BIBLE.md`, `PANOPTICON_CORE_DESIGN_AND_WORLDBUILDING.md`: world, dialogue and the pre-redesign design. Use for lore, never for rules, Node types or numbers.
- `REDLINE_RULE_REVIEW_126.md`, `HALCYON_PLAYTEST3_IMPLEMENTATION.md`, `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md`: history.
- Legacy UI/NUL/REM brief: `PANOPTICON_UI_DESIGN_BIBLE.md`, Source 3 (history); its NUL/REM personality section is now Appendix A of `PANOPTICON_NULREM_DIALOGUE_ARCHITECTURE.md`.
- `godot/CODEX_HANDOFF.md`, `prototypes/python/`: superseded or reference only.

Implement what the current docs say; where they're unclear, make the smallest reasonable choice and list it under Interpretations to confirm.

## 8. Shared development operations (OPS-001)

**UI-WORKFLOW-001 (designer-approved, 2026-11-24):** GitHub Issues are the single authoritative UI proposal and development register for Claude Code, Claude, Codex and ChatGPT. Use stable component IDs from the UI Design Bible. Keep proposal discussion, mockup links, acceptance criteria, designer approval, implementation links and validation evidence in the issue; do not duplicate the backlog in HANDOFF or separate agent files. Only the designer approves; record approved decisions in Master Design and update the UI Design Bible as applicable. Development Log records actual work and links to the issue. Daily operations review uses the same issues. No code or rules changes.

Read `docs/operations/README.md` at session start. At session end, file actual findings in the shared reports and registers on `architecture-v2`, using the report template; link native GitHub issues and PRs rather than duplicating them. Daily review is 22:00 America/Toronto; next-day priorities require designer confirmation. No separate agent backlogs. Preserve existing approval and branch rules.


## 9. Documentation migration gate (DOCS-MIG-001)

Designer-authorized 2026-11-24. Consolidation must reduce clutter, not create parallel authorities. Work in controlled batches on `architecture-v2`, with one atomic completion commit per batch. No subsequent consolidation batch may begin until the preceding batch passes this gate.

Before declaring a batch complete:
- Inventory source content and dependencies; preserve unique material, decision IDs, approval status, provenance and historical records. Relocate narrative or other out-of-scope material to its appropriate canonical destination before retirement.
- Reconcile duplicates and superseded specifications against Master Design; do not silently resolve genuine design conflicts or change gameplay rules.
- Repair active references across the entire tracked repository, including relative links, anchors, source code, tests, CI, packaging and asset manifests. Preserve historical records accurately; use immutable historical links where needed.
- Validate all affected paths and anchors, and run applicable build/test checks if dependencies warrant them. Record commands, results, coverage and any unresolved failures. A partial scan or inaccessible files cannot count as a pass.
- Retire superseded documents from the active tree once their content and dependencies are verified. Git history preserves originals; temporary redirects are exceptions, not permanent duplicate documentation.
- Verify the final diff and canonical destinations, record the decision ID, evidence and completion commit in Master Design, HANDOFF and Development Log. Never mark an incomplete gate complete.

Claude Code should perform full-checkout dependency scans and validation; ChatGPT/Claude reconcile editorial content and design intent. Use the same repository records, not parallel backlogs. Escalate only genuine design conflicts or blockers to the designer. No new branch or rules changes authorized.

**UI-BIBLE-001 batch: COMPLETE (2026-11-25).** Gate passed with the evidence recorded in Master Design (UI-BIBLE-001 completion). Seven sources retired, NUL/REM narrative relocated, references repaired and validated. No consolidation batch is open; the next one may begin when the designer chooses it.


## Canonical ownership and reconciliation gate (CONSISTENCY-001, approved 2026-11-27)
Before asserting current mechanics or producing mockups, read the latest architecture-v2 authoritative specification and check applicable approved amendments; memory and implementation are not design authority. Every mechanic/entity has exactly one designated current definition. Master Design records approval and precedence; Core Rules and designated specialist specifications own current mechanics; UI Bible owns presentation; architecture specifications own technical contracts. Historical decisions are not current definitions. Other active documents reference owners rather than independently restating mutable values. Audit existing owners before creating new catalogues; do not create parallel authorities.
For every approved change: identify owner and decision ID; search repository-wide for dependencies, old terminology and conflicting values; reconcile active documentation, data, UI, implementation and tests; explicitly label historical/superseded material; run relevant validation; record evidence and outstanding work in HANDOFF and log. Distinguish design approved, documentation reconciled, implementation pending, and validated/closed. Never mark fully reconciled while dependencies remain. Escalate genuine design conflicts to designer; do not silently choose. Preserve historical archives. Keep AGENTS.md and CLAUDE.md identical.
Immediate cross-cutting milestone alongside Representative ICE Encounter (priority 1): Claude Code conducts repository-wide audit, inventories existing canonical owners and consumers, and produces discrepancy register with file/line evidence, severity, decision IDs, proposed correction, owner and status. Audit cards/decks/rewards, ICE/subroutines, terminology/resources, CAPS/Ghostware/Protocols, encounter timing, nodes/economy, UI and tests. PROBE-004a is a known open implementation reconciliation. First deliver audit and ownership register; then reconcile unambiguous approved rules in atomic batches; seek designer approval for ambiguous rules and architecture changes. Propose structured canonical card data using existing infrastructure where feasible, generated/linked documentation and inspector consumption; extend to ICE/CAPS/Ghostware after review. Add CI checks for deprecated active terms, identifiers, duplicated values/text where machine-checkable, links, decision status and agent-file equality; behavioural tests for semantic rules. Exclude explicitly historical material, not active code. Report audit coverage, exceptions and test results. No engine refactor or new schema is authorized without reviewed architecture plan. This milestone is not complete until audit and reconciliation evidence exist.


## CONSISTENCY-001a — Structural prevention, not repeat cleanup (APPROVED, 2026-11-27)
Amends CONSISTENCY-001: retain its reconciliation gate, but supersede the general discrepancy audit as the primary deliverable. Previous audits and manual reconciliation have not prevented recurrence. Claude Code must conduct a Canonical Source Architecture Audit before proposing migration: map existing authorities, duplicate mutable definitions, consumers, generation paths, tests and CI/branch enforcement; identify why drift is possible and reuse existing infrastructure rather than create competing sources. Separate current specifications from historical decision records; preserve Master Design approval/precedence and history without requiring agents to reconstruct current mechanics from amendments.
Milestone acceptance sequence (cross-cutting alongside Representative ICE Encounter, which remains priority 1): CSA-01 map existing owners and consumers with evidence; CSA-02 obtain designer approval of canonical data architecture and migration plan; CSA-03 migrate card definitions to one authoritative structured record per ID; CSA-04 connect engine parameters, Universal Object Inspector, Uplink and generated/linked documentation to that source, with explicit handling of complex behaviour; CSA-05 implement CI checks for schema, IDs, deprecated active terminology, generated-output drift, decision traceability and independent behavioural regression tests; investigate required checks and branch protection, report permission constraints and obtain approval before changing repository settings; CSA-06 retire redundant active definitions after dependency validation, preserving history; CSA-07 extend reviewed pattern to ICE, CAPS and Ghostware. Do not hand-maintain generated outputs or derive test expectations solely from the implementation under test. No new schema, engine refactor, or branch protection change before reviewed plan and authorization.
PROBE-004a is the first end-to-end acceptance case: demonstrate in a controlled test that a canonical definition change propagates to consumers or causes validation failure; demonstrate rejection of stale generated text, invalid IDs and deprecated active terms; independently verify selectable STR reduction versus reveal-all on eligible VOID, shared escalating cost, reset and cancellation. Do not alter approved live balance merely to demonstrate propagation. Report exact commands, results, consumer coverage, remaining manual/semantic checks and enforcement gaps. A clean audit report alone is not completion; structural prevention, retirement of duplicates and verified enforcement are required. Keep pending work explicitly open. Claude Code owns execution; no claim of audit or migration completion from this documentation commit.
