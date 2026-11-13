# REDLINE — Godot project

Godot **4.3** (GDScript, Compatibility renderer). Open the `godot/` folder in the Godot editor and press **F5** to play.

## What's playable now

One Node: **the Generalist against the Training Node**, three layers.

| Layer | ICE | CRED reserve |
|---|---|---|
| 1 | WHITE PICKET FENCE | 15 |
| 2 | TOLLBOOTH, MEATGRINDER | 25 |
| 3 | OVERCLOCK, HOTWIRE, WATCHDOG | 40 |

The full core loop is in:
- READY RIG
- turns with BW, DRAW and RAM
- installing, boosting and breaking with Icepicks (type match and STR, WALL free first break)
- Scripts with a chosen target
- SHIELD, PULP and VOID
- the Corporation Response, left to right and top to bottom
- BREACH, which skips the response
- TRACE strikes and TRACER
- Extractors with the full-extraction bonus
- a 1-of-3 card reward
- the go-deeper or leave choice
- the clean-Node CRED bonus
- defeat and restart

How to play: click a **hand card** to play it. Click **Target** on an ICE to aim Scripts at it (the right-most ICE is the default). Pick an Icepick in your rig with **Use**, then click a **subroutine** to boost and break it in one step; the button shows the total BW. **End Turn** runs the Corporation Response, or skips it once every DEADLOCK is broken.

## Layout

| Path | What |
|---|---|
| `data/` | Game content as JSON. See `data/README.md`. |
| `scripts/data/game_data.gd` | Loads and indexes `data/`. |
| `scripts/core/run_state.gd` | Everything that lasts the whole run: VITAE, TRACE, CRED, deck, Ghostware. |
| `scripts/core/node_run.gd` | The rules engine for one Node. It has no UI code, so it is testable headless. |
| `scripts/ui/main_ui.gd` | The test UI, built in code. |
| `tests/run_tests.gd` | Rules tests, plus a greedy bot that plays the Training Node with 20 seeds. |
| `tests/smoke_ui.gd` | Loads the main scene and clicks through a turn. |

Scripts use `preload` constants rather than `class_name` so they also run under `--script`.

## Tests

```
GODOT=/path/to/godot tools/run_godot_tests.sh
```

## Not built yet

- The heist map, SAFEHOUSE, Uplinks, events and escape.
- CAPS, PATCHWORK and FUSE.
- The Node completion reward. A card reward is given per layer; the completion reward is only logged.
- The other three Rustlers and the HALCYON corporation (the data is already loaded).
- Discard choices. When ICE forces a discard, the right-most non-CACHED cards go for now.
- Card effect ops not implemented yet; they show in the log as "Not yet implemented": `cache`, `tutor`, `trace_reduce_each`, `trace_block`, `redirect_insert`, `burn_bloatware`, `suppress_abilities`, `skip_corp_response`, `copy_virus`. The Generalist's starter deck needs none of them.
