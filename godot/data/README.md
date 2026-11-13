# REDLINE game data

Everything the game needs to know about its content: cards, Rustlers, ICE, CAPS, Ghostware, PATCHWORK, events, contracts, virus strains and the rule numbers. The Godot project in `godot/` loads them from `res://data/` (see `godot/README.md`).

**The design documents in `docs/` are the authority.** These files are a faithful copy of the approved values (Phases 1–5, 2026-11-12) in a form the game can load. To change a value: change the design doc first (with a decision ID), then the data, then run the checker.

```
python3 tools/validate_data.py
```

The checker confirms every file parses, every card type, Rustler, corporation, CAP and Ghostware has an icon in `godot/assets/icons/`, ids are unique, every reference points at something real, starter decks have 12 cards, pools have their approved sizes, and every effect uses a known `op`.

---

## Files

| File | Contents | Source doc |
|---|---|---|
| `cards.json` | 96 cards: shared basics, 4 starter decks' cards, 31 shared reward cards, 9 per Rustler, 4 Bloatware (SPAM, TRACER, CITATION, INTRUSIVE THOUGHT). Fused versions sit on their SCRIPT under `fused`. | Rustlers, Card Pools, Upgrades §1.2a |
| `rustlers.json` | Starting stats, the 4 Rustlers, their starter decks, ORIGIN Ghostware, unlocks | Rustlers |
| `ice.json` | Threat values, tiers, the Training Node and the 3 corporations HALCYON, IRONWATCH and LUCIDA (rosters, Black ICE, Central Node, escape layout, Ghostware set), and all 66 ICE | ICE Corp 1–3, Upgrades §4, Core Rules §14 |
| `caps.json` | CAPS rules (slots, JACK OUT limits, Bootleg) and the 12 CAPS | Uplink & CAPS |
| `ghostware.json` | Ghostware rules (payload, fragments, Uplink shelf, contracts) and 37 Ghostware: 4 origin, 20 general, 4 reserve (disabled), 3 each for HALCYON, IRONWATCH and LUCIDA | Rustlers, Upgrades §2 |
| `patchwork.json` | PATCHWORK rules, FUSE rules, the 12 mods | Upgrades §1 |
| `events.json` | 9 SIGNAL UNCLEAR events with choices and weights | Upgrades §3 |
| `contracts.json` | 8 fixer contracts | Upgrades §2.4 |
| `strains.json` | 5 virus strains with timing and per-counter effects | Rustlers §2 |
| `visuals.json` | Placeholder visual identity: icon folders, and colours for card types, card owners (with their card edge style), corporations, rarities and Ghostware sources | — (playtest art, not a design decision) |
| `rules.json` | Numbers the engine needs: turn, damage, TRACE strikes, rewards, prices, Uplink stock, CRED reserves, map, Node services | Core Rules, Card Pools, Uplink & CAPS, HALCYON ICE |

---

## Conventions

- **ids** are `snake_case` and never change once used (saves and PATCHWORK refer to them). **names** are what players see.
- **`text`** is the exact player-facing text. **`effects`** is what the engine runs. If they disagree, the design doc decides.
- **`script`** names custom logic for effects too specific for the generic ops (see the list below). The engine looks up a handler by that name.
- **`when`** on an effect means it's a trigger (`start_of_turn`, `start_of_encounter`, `first_turn_of_encounter`, `start_of_node`, `start_of_corporation`, `installed`, `end_of_turn_in_hand`). No `when` means "when played".
- **`duration`**: `turn`, `encounter`, `node`.
- **`limit`**: `once_per_encounter`, `first_each_encounter`, `this_encounter`, `always`.
- **`target`**: `target` (player chooses one ICE), `all` / `each_ice` (every ICE), `choose`, `self`, `broken_ice`, or an ICE id.
- **Costs:** `cost_bw` (null = can't be played), `ram` (PROGRAMs only), `trace` (TRACE the card adds when played).
- **`pool`** on cards: `basic` (shared basics), `starter`, `reward`, `bloatware`. **`owner`**: `shared`, a Rustler id, or `corporation`.

### Card sub-objects
- **`icepick`**: `ice_type` (`WALL`, `CODE GATE`, `SENTRY`, `ANY`), `str`, `boost_bw`, `boost_str`, `break_bw`, optional `free_first_break_each_turn`, `break_trace`, `on_break` (effects), `subroutines_per_break`.
- **`extractor`**: `cred`, optional `cred_if_no_trace_this_encounter`, `trace_per_extract`, `cred_per_cloak_played`.
- **`fused`** (SCRIPTs only): `id`, `name`, `text`, `effects` of the FUSED version.

### ICE
- `subroutines` are listed **top to bottom**; each has `effects`. Several effects on one subroutine (e.g. PULP 4 + DEADLOCK) are broken together.
- `ability` (optional): `text`, `trigger` (`player_plays_tag`, `player_installs`, `end_of_corp_response`, `constant`), and `effects`.
- `tier`: `training`, `1`, `2`, `black_ice`, `boss`, `escape`. Boss ICE have `boss_role` (`main` / `support`).

---

## Effect ops (58)

| Op | Meaning |
|---|---|
| `shield` | +n SHIELD (`duration: node` = Node-long; `n_per_virus_counter`, `max`) |
| `trace` | Add n TRACE (negative removes) |
| `trace_set` / `trace_halve` | Set TRACE to `value` (optional `if_trace_at_least`) / halve it |
| `trace_reduce_next` | Reduce the first TRACE in the next Corporation Response by `amount` (`all` = to 0) |
| `trace_reduce_each` | Reduce every TRACE gain by n (`scope`: `corp_response` or `always`) |
| `trace_block` | TRACE effects add nothing during the next Corporation Response |
| `remove_strike` | Remove n TRACE strikes |
| `draw` / `draw_stat` | Draw n now / permanently +n DRAW |
| `gain_bw` | +n BW (`when` for triggers; `if_trace_at_least`) |
| `ram` | +n RAM (optional `duration: node`) |
| `cache` | CACHE up to n cards in hand |
| `discard` / `discard_hand` | Discard n cards (player's choice) / discard the whole hand |
| `heal` / `max_vitae` | Heal n VITAE (capped at max) / change Max VITAE (raising it also heals) |
| `pulp` / `void` | ICE damage: n PULP (blocked by SHIELD) / n VOID counters (also used by Bloatware with `when: end_of_turn_in_hand`) |
| `forget` | ICE: n random non-CACHED cards in hand go to the bottom of the draw pile (LUCIDA) |
| `deadlock_lock` | ICE ability (Opening Node BOOTING): its DEADLOCKs can't be broken before turn `until_turn` of the encounter |
| `pulp_direct` | Lose n VITAE as a cost (not blocked by SHIELD) |
| `prevent_void` | Prevent n VOID (`all`), with a `limit` |
| `ice_str` | Change ICE STR by n (`target`, `duration`, optional `ice_type`, `n_per_10_trace`) |
| `ice_str_set` | Set ICE STR to `value` for `duration` |
| `ice_gain_str` | ICE ability/subroutine: `target` (`self`, `others` or an ICE id) gains n STR for the encounter |
| `ice_pulp_bonus` | That ICE's PULP subroutines deal +n |
| `str_floor` | That ICE's STR can't go below n |
| `icepick_str` | Your Icepicks have +n STR |
| `break` | Break `count` subroutines (`scope: any_type`, `max_ice_str`, `min_virus_counters`, `ignore_str`, `target: each_ice`) |
| `deadlock` | Blocks BREACH while unbroken |
| `skip_corp_response` | Skip the next Corporation Response |
| `suppress_abilities` | ICE abilities of `ice_type` do nothing for `duration` |
| `infect` | INFECT n counters of `strain` on `target` |
| `double_virus` / `copy_virus` | Double every strain on target / copy target's counters onto every other ICE |
| `spread_virus` | WORM: put 1 of each strain onto the next ICE to the right |
| `reduce_ice_pulp` / `reduce_ice_trace` | SCRAMBLE / BLIND per-counter effects |
| `purge` / `purge_all` | Remove virus counters from this ICE / every ICE |
| `insert` | Corporation puts n copies of a Bloatware `card` into `dest` (`draw_pile`, `discard`, `hand`) |
| `redirect_insert` | INSERTed Bloatware goes to `dest` instead (`limit`) |
| `burn_bloatware` / `remove_all_bloatware` | BURN n Bloatware from hand / remove all Bloatware everywhere |
| `extract` / `extract_multiplier` | Extract n CRED from the encounter reserve / multiply all extraction |
| `gain_cred` | +n CRED (not from a reserve) |
| `tutor` | Search draw pile for a card of `card_type` and put it in hand |
| `add_random_card` / `remove_card` / `trade_up` | Deck changes from events and Ghostware |
| `gain_random_cap` / `cap_slots` | Gain a CAP (optional `rarity`) / +n CAP slots |
| `gain_random_ghostware` | Gain a random Ghostware |
| `patchwork` | Apply n PATCHWORK |
| `reward_choices` | Card rewards offer n choices |
| `jack_out` | Leave the encounter and move forward (CAPS rules apply) |
| `lockdown` / `add_black_ice` | TRACE strike results |
| `start_encounter` | Event: start an ICE encounter (`layers`, `tier`) |

## Custom scripts (24)

Effects that need their own handler, named by `script`:

- **Cards:** `adapter`, `berserk`, `hot_swap`, `incubator`, `jack_of_all_trades`, `long_game`, `patience`, `replicator`, `spam`, `toolbelt`
- **Ghostware:** `burnout_chip`, `chaos_engine`, `cold_storage`, `dead_mans_pocket`, `field_medic`, `first_contact`, `killswitch`, `long_memory`, `patch_cable`, `ready_rig`, `recycler`, `scrambled_id`, `signal_booster`, `voice_mimic`

**VOICE MIMIC** makes a TRACE subroutine **fail**, which is different from reducing it to 0 (design note P5-005). Keep the two distinct in the engine.
