# Working agreement for AI agents (Claude Code, Claude, Codex)

This repository, Punkwork/REDLINE on `main`, is the shared source of truth for every agent working on PANOPTICON (a Godot 4.3 deck-building roguelike; the repo and file prefix are REDLINE, the game is PANOPTICON).

This file and `AGENTS.md` are identical. Edit both together, word for word.

## 1. Rules for every agent

1. **Start from the latest `main`.** Pull before you begin any work.
2. **Record design decisions in `docs/REDLINE_MASTER_DESIGN.md`.** Other docs and chat transcripts do not count as decisions until they are in the master document.
3. **Report the commit.** When work is finished, tell the user the commit hash where it lives.
4. **Ask before creating a branch.** By default, work lands on `main`. The one standing exception is `release` (§5).
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
- **The UI is built in code.** There is one scene (`godot/scenes/Main.tscn`) and no autoload singletons. Don't introduce scenes, autoloads or a signal bus unless the designer asks.

**Map (details in `docs/ARCHITECTURE.md`)**
- `godot/scripts/core/`: the rules engine and data (`game.gd`, `cards.gd`, `ice.gd`), NUL/REM, punch cards, THE CARBON record, local profile, copy guards.
- `godot/scripts/ui/main.gd`: app shell, menus, map, settings. `godot/scripts/ui/friendly_lie/`: the encounter presentation (Friendly Lie, Chrome Deco, cartridges, Atomic Deco Punk, SAMIZINE).
- `godot/data/`: copy tables and tunable presentation values (JSON), each line with its approval status.
- `godot/tests/`: `test_*.gd` (headless checks) and `shot_*.gd` (screenshot fixtures, written to `docs/visual/fixtures/`).

**Do not**
- **Refactor or restructure working code unless the designer asks.** Make the smallest change that does the job. If something should be refactored, propose it in HANDOFF instead.
- **Change rules behaviour** (anything in `game.gd`, `cards.gd`, `ice.gd` that affects play) except to implement an approved rule. The rules docs (`docs/REDLINE_CORE_RULES.md` and the docs it names) are the authority.
- **Let presentation read into rules.** Bleed, mood, wear, voice and ads are presentation only; rules code never reads them.
- **Break the readability rules:** text contrast at least 4.5:1; no effect, wear, graffiti or decoration may cross rule text, numbers, card names, costs or buttons (ADP-R1, `docs/REDLINE_VISUAL_LANGUAGE.md` §2.9).
- **Break the copy guards:** a `reveal` line never shows before the third punch card (SIGNAL-001); the full word "Archipelago" never appears on screen, the underworld writes **’Pelago** (U+2019), and neither form appears in corporate or rules strings (ARCH-SLANG-001); "gulag" never appears on screen; no QR codes anywhere.
- **Send data off the machine.** Play stats, ads and THE CARBON stay in `user://`.

**Tests (run before every commit that touches `godot/`)**
```
GODOT=/path/to/Godot_v4.3-stable
$GODOT --headless --path godot --editor --import --quit
$GODOT --headless --path godot --script res://tests/test_game.gd
$GODOT --headless --path godot --script res://tests/test_adp.gd
$GODOT --headless --path godot --script res://tests/test_signal_carbon.gd
```
Screenshot fixtures (need a display; CI uses `xvfb-run` and `--audio-driver Dummy --rendering-driver opengl3`): `shot_rustlers shot_hand shot_playtest2 shot_playtest3 shot shot_reel shot_friendly_lie shot_chrome shot_cartridges shot_adp shot_adp_phase3 shot_signal_carbon shot_facade`. The list in `.github/workflows/godot-validation.yml` is authoritative. Bot sims: `SIM=1 $GODOT --headless --path godot --script res://tests/test_game.gd`. Report pass/fail counts in the log; any `SCRIPT ERROR`, `Parse Error` or `Assertion failed` is a failure.

## 5. Builds (RELEASE-001)

Work lands on `main`; pushes and PRs to `main` validate only. To cut a playtest build when the designer asks: fast-forward `release` to `main`, push, let the workflow export, verify the artifact (`BUILD_COMMIT.txt`, SHA-256, guide, checklist), and tag the commit `playtest-N`. Nobody commits to `release` directly. A bad build is rebuilt from its tag, or `release` is reset to the last good tag.

## 6. Design docs

Start with `docs/REDLINE_MASTER_DESIGN.md` (decisions and register) and `docs/HANDOFF.md` (what's next). Rules: `docs/REDLINE_CORE_RULES.md`. Look and tone: `docs/REDLINE_VISUAL_LANGUAGE.md`, `docs/REDLINE_ATOMIC_DECO_PUNK.md`, `docs/REDLINE_CORPORATE_FACADES.md`, `docs/REDLINE_SAMIZINE.md`, `docs/REDLINE_ARCHIPELAGO.md`. Implement what the docs say; where they're unclear, make the smallest reasonable choice and list it under Interpretations to confirm.
