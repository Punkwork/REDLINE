# Working agreement for AI agents (Claude Code, Claude, Codex)

This repository, Punkwork/REDLINE, with active architecture work on `architecture-v2`, is the shared source of truth for every agent working on PANOPTICON (a Godot 4.3 deck-building roguelike; the repo and file prefix are REDLINE, the game is PANOPTICON).

`AGENTS.md` and `CLAUDE.md` must remain identical. Edit both together, word for word.

## 1. Rules for every agent

1. **Start from the latest `architecture-v2` for the approved architecture migration (ARCH-V2-001).** Pull before beginning work. `main` remains the preserved prototype baseline; do not push migration work to `main`.
2. **Record design decisions in `docs/REDLINE_MASTER_DESIGN.md`.** Other docs and chat transcripts do not count as decisions until they are in the master document.
3. **Report the commit.** When work is finished, tell the user the commit hash where it lives.
4. **Branch policy (ARCH-V2-001):** the designer explicitly approved `architecture-v2` as the primary working branch for the rebuild. Work on this existing branch; ask before creating any further branches, merging into `main`, changing the repository default branch, or cutting a release. `main` remains unchanged until designer-authorized integration.
5. **Only the designer approves.** A proposal stays PROPOSED until the designer approves it in a session. Never mark anything APPROVED yourself.
6. **Every change carries a decision ID** (e.g. ARCH-001) in the design doc, `docs/HANDOFF.md` and `docs/REDLINE_DEVELOPMENT_LOG.md`.

Copies of design docs kept outside this repository, such as Claude Project docs or chat attachments, may be stale. When they disagree with this repository, this repository wins.

## 2. Roles (DEV-001, 2026-11-18)

- **Claude Code** is the main code developer: the Godot build (`godot/`), tests, fixtures, CI, exports, `docs/REDLINE_CURRENT_STATUS.md`.
- **Claude (claude.ai / Cowork, the "Panopticon" project)** owns design: design docs and proposals, playtest analysis, `docs/HANDOFF.md`, and the Claude Project copies of the docs.
- **Codex** takes small, isolated tasks only when the designer asks for one (e.g. a shader tweak or a self-contained helper). It follows this same file.
- **Either** may make small doc fixes that follow a decision already recorded.

## 3. Session routine

- **Start:** pull `main`; read `docs/HANDOFF.md`, then the latest entries of `docs/REDLINE_DEVELOPMENT_LOG.md`, then `docs/ARCHITECTURE.md` before touching code.
- **End:** in `docs/HANDOFF.md`, move finished items to *Done* or *Built* with the commit; add new items. Add a dated log entry tagged `(Claude Code)`, `(Claude)` or `(Codex)`. Note anything you had to decide yourself under **Interpretations to confirm**.
- **Log size (LOG-001):** keep the development log under about 60 KB; move the oldest whole entries, unchanged, to the end of `docs/REDLINE_DEVELOPMENT_LOG_ARCHIVE.md` and note the move.

## 4. The code: guardrails

**Engine and style**
- **Godot 4.3, GL Compatibility renderer.** Do not upgrade the engine or change project settings without the designer's approval.
- **Typed GDScript**, as the existing code does (`var g: Game`, `func _ready() -> void`). Follow the folder layout and naming already in the repo.
- **Existing prototype:** the UI is built in code, with one scene (`godot/scenes/Main.tscn`) and no autoloads. **Approved future direction (ARCH-V2-001):** design a hybrid scene-based, component-driven, data-driven UI. Reusable `.tscn` scenes, typed GDScript components, theme/resources and narrowly scoped signals are permitted on `architecture-v2` where justified by a reviewed architecture plan. Do not introduce global autoloads, a global signal bus, or unrelated refactors automatically. Preserve gameplay/presentation separation. This permission is not approval to implement every proposed scene or to rewrite the rules engine.

**Map (details in `docs/ARCHITECTURE.md`)**
- `godot/scripts/core/`: the rules engine and data (`game.gd`, `cards.gd`, `ice.gd`), NUL/REM, punch cards, THE CARBON record, local JSON helper and copy guards.
- `godot/scripts/ui/main.gd`: app shell, menus, map, settings. `godot/scripts/ui/friendly_lie/`: the encounter presentation (Friendly Lie, Chrome Deco, cartridges, Atomic Deco Punk, SAMIZINE), including the local ad profile in `play_profile.gd`.
- `godot/data/`: copy tables and presentation tuning (JSON). ADP and ARCH copy have per-line approval fields.
- `godot/tests/`: `test_*.gd` (headless checks) and `shot_*.gd` (screenshot fixtures, write to the directory in `SHOT_DIR`).

**Do not**
- **Refactor or restructure working code unless the designer asks.** Make the smallest change that does the job. If something should be refactored, propose it in HANDOFF instead.
- **Change rules behaviour** (anything in `game.gd`, `cards.gd`, `ice.gd` that affects play) except to implement an approved rule. The rules docs (`docs/REDLINE_CORE_RULES.md` and the docs it names) are the authority.
- **Let presentation read into rules.** Bleed, mood, wear, voice and ads are presentation only; rules code never reads them.
- **Break the readability rules:** text contrast at least 4.5:1; no effect, wear, graffiti or decoration may cross rule text, numbers, card names, costs or buttons (ADP-R1, `docs/REDLINE_VISUAL_LANGUAGE.md` §2.9).
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

## 5. Builds (RELEASE-001)

**Existing release workflow is preserved for the prototype:** `main` remains the stable baseline; `release` exports only when the designer authorizes a prototype playtest build using the established procedure. The `architecture-v2` migration does not automatically change the release branch or export workflow. Do not fast-forward `release` from `architecture-v2` or merge migration work into `main` without designer approval. Before a future migration release, explicitly design and approve its validation/export procedure.

## 6. Approved architecture migration (ARCH-V2-001, designer 2026-11-23)

- `architecture-v2` is the primary development branch for the full-game rebuild. `main` is the stable, preserved four-node prototype. No automatic merges between them.
- Target: hybrid Godot 4.3 GL Compatibility architecture using scene composition for meaningful screens/widgets, reusable typed GDScript components, data-driven content and corporation presentation, and independent game rules. Scene boundaries and data formats must be proposed and reviewed before broad implementation.
- Preserve and regression-test the proven rules engine (`game.gd`, `cards.gd`, `ice.gd`) as the initial behavior reference. No gameplay or balancing changes are authorized by this architecture decision.
- First deliverable is an architecture plan and one fully playable representative ICE encounter; compare against existing behavior and tests. Expand only after validation. Prefer small testable modules over giant scripts or excessive tiny scenes.
- Record the exact `main` baseline SHA and passing tests before applying migration code. A permanent prototype tag is recommended but not yet created or verified. Do not claim a baseline was validated merely because this branch exists.
- Keep designer-only approvals, decision IDs, copy guards, readability, privacy, CI and release protections intact. The new branch is not a blanket approval for implementation details.

## 7. Design docs: which are current (DOCS-001)

When docs disagree: **`docs/REDLINE_MASTER_DESIGN.md`** (decisions and register) wins, then **`docs/REDLINE_CORE_RULES.md`**, then the topic docs it names. Within a rules doc, its **"Later amendments"** tables win over older text in the same doc, even where that text wasn't edited.

**Current**
- What's next: `docs/HANDOFF.md`. What the build does now: `docs/ARCHITECTURE.md` ("Slice boundaries") and `docs/REDLINE_CURRENT_STATUS.md`. The HALCYON slice is only four map rows, so the code is not a full picture of the design.
- Rules: `docs/REDLINE_CORE_RULES.md` (the map and Node types are §10).
- Topic docs: `REDLINE_RUSTLERS.md`, `REDLINE_CARD_POOLS.md`, `REDLINE_ICE_CORP1.md`–`3.md`, `REDLINE_ICE_RULES_BIBLE.md`, `REDLINE_ICE_PASSIVES.md`, `REDLINE_UPLINK_AND_CAPS.md`, `REDLINE_UPGRADES_EVENTS_ESCAPE.md`, `REDLINE_ENGINES.md`, `REDLINE_DECK_SYNERGY.md`, `REDLINE_PACING.md`, `REDLINE_PLAYTEST_CHECKLIST.md`.
- Look and tone: `REDLINE_VISUAL_LANGUAGE.md`, `REDLINE_ATOMIC_DECO_PUNK.md`, `REDLINE_ADP_PHASE2_COPY.md`, `REDLINE_CORPORATE_FACADES.md`, `REDLINE_SAMIZINE.md`, `REDLINE_ARCHIPELAGO.md`.

**Not current for rules (history or lore only)**
- `REDLINE_BIBLE.md`, `PANOPTICON_CORE_DESIGN_AND_WORLDBUILDING.md`: world, dialogue and the pre-redesign design. Use for lore, never for rules, Node types or numbers.
- `REDLINE_RULE_REVIEW_126.md`, `HALCYON_PLAYTEST3_IMPLEMENTATION.md`, `REDLINE_DEVELOPMENT_LOG_ARCHIVE.md`: history.
- `REDLINE_UI_NULREM_Design_For_Claude.md`: look replaced by VIS-001; requirements only where Visual Language §2.10 keeps them.
- `godot/CODEX_HANDOFF.md`, `prototypes/python/`: superseded or reference only.

Implement what the current docs say; where they're unclear, make the smallest reasonable choice and list it under Interpretations to confirm.
