# REDLINE — Godot project

Godot **4.3** (GDScript, Compatibility renderer). Open the `godot/` folder in the Godot editor and press **F5** to play.

## What's playable now

The main menu offers two modes.

**HALCYON heist (economy playtest).** Choose any of the 4 Rustlers.
- A 9-row map: Tier 1 ICE in rows 1–4 and Tier 2 in rows 5–8, Uplinks in rows 3 and 6, and an Uplink or DEAD DROP in row 9. SAFEHOUSEs appear in 1–2 rows.
- SIGNAL UNCLEAR events, Console Labs, and THE HEARTH Central Node with its Ghostware payload. The escape isn't in this build yet.
- **Black Market Uplink:** a reserve shelf, 6 cards with one on sale, 3 CAPS (one may be BOOTLEG), 2–3 Ghostware, Wipe, and a Clinic at about 1 Uplink in 3.
- **CAPS:** all 12 work; JACK OUT follows its timing limits. You get CAPS from the full-clear completion reward and from the 20% drop after a BREACH.
- **Ghostware:** the general pool and the HALCYON set work, apart from SIGNAL BOOSTER, which has no effect yet.
- **Run summary:** CRED earned by source, CRED spent by category, every purchase, cards added (rewards versus bought) and the route you took. **Copy summary to clipboard** lets you paste it into a chat for tuning.

**Training Node:** the Generalist against 3 fixed layers. The reserves are 10/15/25.

How to play an encounter:
- Click a **hand card** to play it.
- **Target** an ICE to aim Scripts and CAPS at it; the right-most ICE is the default.
- Pick an Icepick with **Use**, then click a **subroutine** to boost and break it in one step. The button shows the total BW.
- **END TURN** runs the Corporation Response, or skips it once every DEADLOCK is broken.

On the map you can move to the next row's Nodes that are in the same column or next to it; those are highlighted.

All prices, reserves and odds live in `data/rules.json` (`prices`, `cred_reserves`, `rewards`, `uplink`) and `data/ice.json`. Change them and replay; no code changes are needed.

## Layout

| Path | What |
|---|---|
| `data/` | Game content as JSON. See `data/README.md`. |
| `scripts/data/game_data.gd` | Loads and indexes `data/`. |
| `scripts/core/run_state.gd` | Everything that lasts the whole run: VITAE, TRACE, CRED, deck, Ghostware. |
| `scripts/core/node_run.gd` | The rules engine for one ICE Node: cards, Icepicks, CAPS, Ghostware, rewards. It has no UI code, so it is testable headless. |
| `scripts/core/heist.gd` | One corporation heist: map, Uplink, rooms, events, Central Node and the economy summary. |
| `scripts/ui/main_ui.gd` | The test UI, built in code. |
| `tests/run_tests.gd` | Rules, CAPS and Uplink tests, plus bot playthroughs of the Training Node and of heists with every Rustler. |
| `tests/smoke_ui.gd` | The bot plays the Training Node and 4 heists through the UI, to catch UI script errors. |
| `tests/bot.gd` | A simple bot used by the tests and the simulation. |
| `tests/heist_sim.gd` | Economy simulation: 80 heists per Rustler, with average CRED, cards and Uplink visits for winning runs. |

Scripts use `preload` constants rather than `class_name` so they also run under `--script`.

## Tests

```
GODOT=/path/to/godot tools/run_godot_tests.sh
```

## Not built yet

- The escape, and corporations 2 and 3.
- PATCHWORK and FUSE (SAFEHOUSE and Console Lab show them disabled), and the FRIENDLY RUSTLER trade's choice of card.
- Fixer contracts and Ghostware fragments.
- Discard choices. When ICE forces a discard, the right-most non-CACHED cards go for now.
- Choosing which subroutine a Script or CAP breaks; the best one is picked automatically, DEADLOCKs first.
