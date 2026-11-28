# PANOPTICON architecture

This is the developer map for the Godot 4.3 HALCYON slice in Punkwork/REDLINE. The checkout contains the game under `godot/`. Use [HANDOFF](HANDOFF.md) for active work and [the master design](REDLINE_MASTER_DESIGN.md) and [core rules](REDLINE_CORE_RULES.md) for approved behaviour. The `pre-claude-code` tag marks the DEV-001 baseline.

## Approved target architecture (ARCH-V2-001, 2026-11-23)

The sections below document the **existing four-node prototype**, not the completed full-game architecture. The designer approved a migration on `architecture-v2` toward a hybrid scene-based, component-driven, data-driven Godot 4.3 GL Compatibility architecture. `main` stays the stable prototype; existing rules and test behavior remain the initial reference. Meaningful reusable scenes, typed GDScript components, corporation presentation resources, and explicit rules/presentation boundaries are allowed on the migration branch. Do not assume these are already built. First propose component boundaries and a migration/test plan, then implement one representative playable encounter after review. No approved gameplay changes, automatic release changes, or merge into `main` are implied. See `AGENTS.md` and the ARCH-V2-001 master-design entry.

## Entry point and state flow

`godot/project.godot` starts `res://scenes/Main.tscn` with the GL Compatibility renderer. The root Control runs `scripts/ui/main.gd` and constructs the rest of the UI in code. There are no autoloads. Main owns a `Game` and a `NulRem` picker. It opens at Rustler selection with a fresh model, then starts the selected Rustler's run and refreshes.

```text
Player input → main.gd or FriendlyEncounter → Game action
                    ↑                             |
                    └── refresh / sync ← state, log, events
```

### Rules and state

| Script | Responsibility |
|---|---|
| `scripts/core/game.gd` (`Game`) | RefCounted rules model with an optional seed. Holds the route, Rustler, VITAE, CRED, TRACE, strikes, punch cards and run deck. Also holds the current Node and layer, `enc`, encounter piles, installed PROGRAMs, protocol rack, BW and shield. `phase`, `pending.kind` and `response_queue` drive prompts and continuations. |
| `scripts/core/cards.gd` (`CardDB`) | Definitions keyed by base card ID, starter decks, Rustler definitions, reward pools and role lookups. `CardDB.def()` builds the combined definition for a `COMPILED::a::b` ID when asked. An instance has its own `uid`; two copies of the same ID can have different runtime or presentation state. |
| `scripts/core/ice.gd` (`IceDB`) | ICE definitions, subroutine effect dictionaries, the four-row HALCYON slice map (`IceDB.MAP`, the test default; the app uses the generated map, see Slice boundaries), PULP curves and corporation tuning. Game instantiates mutable ICE state and can use a definition supplied by a fixture. |
| `scripts/core/nulrem.gd` (`NulRem`) | Picks dialogue by event and context, with its own RNG, chance and repeat suppression. Main displays the line and plays matching audio when available. |
| `scripts/core/signal_cards.gd` (`SignalCards`) | Corporation keys and punch-card artwork data. Normalizes saved identifiers and checks whether all three distinct corporation cards are held. |
| `scripts/core/arch_copy.gd` (`ArchCopy`) | Filters relocation, ledger and lore copy by approval, audience and reveal eligibility. Also guards NUL/REM lines. |
| `scripts/core/carbon_record.gd`, `local_record.gd` | Choose relocation copy and append a defeat once per run ID. LocalRecord is the dictionary JSON read/write/erase helper, also used by the UI's PlayProfile. |

Read `new_run()` → `enter_node()` → `_start_ice_node()` → `_start_encounter()` → `_start_turn()` for initialization. Node entry reconstructs temporary cards from `run_deck` while preserving their UIDs. It can pause in READY RIG or SAFEHOUSE. Each encounter populates ICE instances and runtime subroutine state. `can_play()`, `break_info()` and `response_preview()` feed the interface. `play_card()`, `break_sub()`, `choose()` and the other action methods own legality and mutation. `end_turn()` handles end-of-turn effects and advances to response or the BREACH flow. A clear or an early exit goes through the relevant reward/deeper/map transition.

### Controller and encounter view

- `main.gd` owns menus, settings, the map, overlays, targeting, inspection and asynchronous responses. `refresh()` samples the local profile, handles defeat, consumes Game events, and decides whether to sync the encounter view or rebuild the shell widgets and overlays. The legacy widgets still participate in the app outside the active encounter.
- `friendly_lie/encounter.gd` (`FriendlyEncounter`) receives the same Game in `sync()`. It displays resources, ICE scans, response preview, hand, rig, log and punch-card holder. It derives the corporation mood and audiovisual bleed from the model. `card.gd`, `hand.gd`, `program_bay.gd` and `drop_target.gd` handle card browsing, drag/drop and target previews. Valid drops delegate to Main or Game actions and refresh. Mascot/face, Chrome frame, cartridge, wear, music and SAMIZINE components draw or play the presentation.
- Main sets `Game.animate` for interactive play. Its response coroutine calls `response_step()` when each subroutine flashes, then `response_finish()`. Tests can let Game resolve synchronously or drive steps explicitly. Main blocks or defers refresh/input around response animations and TUMBLER reels. Reduced motion changes presentation while the response still resolves in order.
- Game appends narrative events to `events`, which Main consumes and clears. The separate `log` is displayed as history. LUCIDA may rewrite a line marked `flavour` in `log_tags`. Rule lines keep their original text.

## Data and approvals

Runtime JSON lives in `godot/data/` and is included by the export preset. **Card data (CSA-03, CONSISTENCY-001a):** `cards.json` is the single source for card records, CAPS, starter decks and reward pools. `CardDB` (`cards.gd`) loads it read-only and keeps its API; edit cards in the JSON. `tools/csa/validate_cards.py` checks it, and `tests/test_csa_cards.gd` checks parity with the pre-migration constants. GDScript definitions still hold ICE and map rules. Corporate themes and assets live in `godot/themes/` and `godot/assets/`.

| File | Consumer and meaning |
|---|---|
| `cards.json` | `CardDB` loads it: card records, CAPS, starter decks, core reward pool and pool extras (CSA-03). The single card source. |
| `atomic_deco_punk.json` | `AtomicDecoPunk` and view components use it for presentation thresholds, timing, wear and sound. It is tuning data. |
| `adp_copy.json` | `AdpCopy` picks approved, non-reveal text by corporation, kind and matching fields such as band or mood. |
| `arch_copy.json` | `ArchCopy` validates lines, then checks `approval` and any reveal trigger. A caller must explicitly opt into proposed working copy. Island names use `approval: proposed` and `copy_status: working_copy`. Relocation lines and programme small print are approved. |
| `nulrem_lines.json` | Exported dialogue keyed by event, with contextual `tags`. The picker uses those tags and the shared copy guard. These lines lack per-line approval fields as a table convention. |

`approval` governs editorial status where the table supports it. `tag` distinguishes flavour/hints from a reveal, and `voice` identifies the audience where present. A reveal requires `trigger: third_card` and all three distinct corporation cards. The copy tests inspect authored data and known corporate/rule strings. A new rendering path must use the same guard. Use the curly apostrophe in **’Pelago** for underworld copy. Keep either name out of corporate and rules strings, the full name and banned wording off screen, and QR codes out of the design.

## Local files

`user://` is Godot's per-user application data location for PANOPTICON. Use `OS.get_user_data_dir()` to confirm the resolved directory on a given machine.

| File | Writer and contents |
|---|---|
| `redline_flags.json` | Main writes first-run acknowledgement and settings for voice, reduced motion, music volume/mute and personalized ads. |
| `redline_stats.json` | `friendly_lie/play_profile.gd` records local totals for card plays, broken ICE, strikes, runs and longest hover. The enabled ad path updates at observed encounter/run boundaries and reads those stats for ad text. Settings can clear the file. |
| `carbon.json` | `CarbonRecord` records defeats, including END RUN, with run ID, Rustler, issue, corporation, Node, date, island and relocation ID. Main retries a failed write on refresh and uses the run ID to avoid duplicate entries. View the ledger in the run menu's DEAD DROP or at the slice SAFEHOUSE. Settings can clear the file. |

LocalRecord writes via a sibling `.tmp` and renames it into place. These records stay local. Full run progress lives in memory.

## Tests and screenshot fixtures

Run the headless commands in [CLAUDE.md §4](../CLAUDE.md#4-the-code-guardrails) from the repository root. Install the pinned **Godot 4.3 editor** and import the project first so Godot registers `class_name` scripts and imports textures, fonts and audio. The three test scripts instantiate their harnesses directly. `test_game.gd` exercises the model and includes the optional seeded bot simulations. Any nonempty `SIM` enables those simulations alongside the checks. `SIM_ONLY` accepts one Rustler ID. `test_adp.gd` checks bleed math. `test_signal_carbon.gd` covers punch-card state and copy guards.

The `shot_*.gd` scripts are display-backed SceneTree harnesses. They instantiate Main, seed or construct controlled states, drive input or Game actions, wait for rendering and capture the viewport. Several assert interactions, geometry, contrast or local-record behaviour in addition to writing PNGs. Set `SHOT_DIR` to an **existing absolute directory**. ADP also writes a WAV. Outputs go there; the committed samples under `docs/visual/fixtures/` are curated separately. CI runs the authoritative script list in [godot-validation.yml](../.github/workflows/godot-validation.yml) and uploads screenshots and logs. `CHROME_STAGE` selects a stage in `shot_chrome.gd`; an unset value runs the default final stage.

Use a working display and GL renderer. On display-less Linux, install Xvfb and xauth and use `xvfb-run` with a 1600×1100 screen like CI. Reserve enough room for the 1600×1000 viewport and run mouse-driven fixtures serially on a shared display. Dummy audio removes the need for a sound server. Inspect logs for script errors as well as exit codes. On Linux, set `XDG_DATA_HOME` to a fresh directory before running fixtures. The harnesses can change first-run settings, ad stats and CARBON records. Use a disposable profile on other platforms too. A stale X socket alone does not mean an X server is running.

## Fragile boundaries

- Preserve UID identity across piles, targeting, installs, CACHE, compilation and grafts. Node entry creates encounter copies, and graft rendering looks up the run-deck instance by UID. Authored definitions and filtered copy rows can be shared dictionary references. Duplicate before fixture edits or mutation.
- Keep phase transitions and continuation order together. DISCARD and other choices may interrupt a response or compiled card. TRACE can insert or schedule Black ICE during an action. The response and targeting code use ICE references across mutations. Avoid treating an array position as durable identity.
- Keep previews observational and gameplay RNG separate from presentation. Active/seen/broken subroutine state drives TUMBLER, ZEROED, hidden VOID text and the response queue. Visual timing or rebuilt controls must never duplicate effects or reroll previews.
- Check both preview and actual action paths when changing drag targets, card effects or subroutines. Preserve the rules log and the copy gates. Maintain at least 4.5:1 text contrast and keep wear, art and graffiti clear of rules, numbers and controls.
- Relocation selection currently indexes five approved lines and three working island names per corporation by order. Keep existing identifiers and account for persisted relocation IDs and the island text already stored in old records before changing pool shape or order.

## Slice boundaries

| Feature | Implemented hook | Outside the playable slice |
|---|---|---|
| Map (MAP-003f) | `Game.use_generated_map(k)` builds `map_rows` from one of the 20 validated V5 maps in `godot/data/maps/map003_v5.json` (written by `tools/map/export_maps.py`, drift-checked in CI): 16 rows, 15 Nodes and the boss on every route, no escape. The app calls it for every new run; `NodeMapScreen` draws it. `IceDB.MAP` (the four-row slice) stays the default for tests. | ICE Nodes and the Mini-Boss reuse the slice's five encounters as stand-ins; the Mini-Boss has no unique ability yet. DEAD DROP, Console Lab and SIGNAL UNCLEAR open a painted room with no services (`NODE_ROOM`). |
| Central Node (boss) | The row-16 BOSS is marked `central: true` (3 layers). Final-layer BREACH awards that corporation's card once. | No payload Ghostware choice or First Signal fragment yet. |
| LUCIDA | Facade art/skin and flavour-log rewrite hooks. The controlled INTAKE fixture exercises them. | There is no playable LUCIDA route. |
| PATCHWORK | `attach_patchwork_graft(uid)` stores the selected broken-ICE graft on a run-deck instance. The fixture calls the hook directly. | There is no playable PATCHWORK upgrade action. SAFEHOUSE COMPILE is a separate feature (as built; superseded in the design, Core Rules §8.3). |
| Run resume | `save_presentation()` and `restore_presentation()` round-trip punch-card IDs and grafts keyed by UID on an already available deck. | There is no on-disk run snapshot or resume screen. |
