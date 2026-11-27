# MAP-003f — V5 map generator: implementation and validation report

**Author:** Claude Code, 2026-11-27 · **Decision:** MAP-003f / MINIBOSS-003 (designer-approved 2026-11-27) · **Status of this work:** BUILT (Python prototype), interpretations PROPOSED for designer confirmation.
**Files:** `prototypes/map/map003_generator.py` (V5 section, `--v5`), `prototypes/map/validate_map003_v5.py` (harness), `tests/python/test_map003_v5.py` (unit tests), `prototypes/map/samples/` (sample maps and the 200-map validation record).
**Scope kept:** no change to the Godot encounter engine, Uplink implementation or production map UI. V1–V4 are unchanged (same output, byte for byte; see §6).

## 1. Result in one paragraph

V5 builds maps instead of repairing them. All **200 of 200** candidate seeds were accepted, against V4's **36.3%**, and **all 1,623,047 complete routes** through those maps meet every mandatory constraint. Validation found **no** dead ends, unreachable Nodes or invalid routes. Generation takes **2.7 ms per map on average and 47.5 ms at worst**, against roughly 39 ms per V4 seed. A further 1,000-map run (8,007,197 routes) also passed, and a 10,000-seed scan had no failures. Every seed reproduces exactly, including in fresh interpreters with different hash seeds. Only **7 of V4's 363 accepted maps** would have met MAP-003f.

## 2. Audit of V4

**How V4 works.** `gen()` builds the ICE / non-ICE skeleton row by row. Each Node carries its count of ICE in rows 2–8 and 10–15, and a link joins only matching counts, so every route has exactly 8 ICE by construction. `gen4()` then deals the five non-combat types at random. It repairs one failing route at a time (up to 500 times) by retyping one Node, and finally rejects the map if any route breaks spacing.

| # | Finding | Evidence (1,000 seeds) | Effect |
|---|---|---|---|
| A1 | **Dead ends.** A row's size is `randint(3,4)` even when the previous row holds four different ICE counts, so a Node can have no matching child. The path walker drops such routes silently, so V4's own checks pass these maps. | 95 of 1,000 raw skeletons; **33 of 363 accepted V4 maps** contain dead-end Nodes | Invalid maps were accepted |
| A2 | **Spacing check skips row 1.** `runs_ok` checks rows 2–15, but the row-1 Opening Node is an ICE Node. | 22 accepted maps; 5,640 of 1,482,642 routes have 5 ICE in rows 1–5 | Rule partly unchecked |
| A3 | **The Mini-Boss can be forced.** Nothing stops a row-8 Node from linking only to the Mini-Boss. | 138 of 363 accepted maps | Optionality not guaranteed |
| A4 | **MAP-003f not met.** V4 allows 1 Uplink per route and has no upper bound. | Routes with 1 / 2 / 3 Uplinks: 36% / 51% / 13%; **7 of 363** maps compliant | Needs a new generator |
| A5 | **Repair-and-reject does not suit an upper bound.** A repair changes a Node that many routes share. Raising one route's Uplinks can push another route to 4, and lowering them can drop a third route to 1, so repairs can cycle. Filtering V4 output by MAP-003f would accept about 0.7% of seeds. | 7 / 1,000 | Unsuitable (§3) |
| A6 | The V1 block ran when the file was imported. | — | Now guarded by `__name__ == "__main__"`; the command-line output for `--v2`, `--v4` and no flag is unchanged |

## 3. Approach chosen and why

| Option | Verdict |
|---|---|
| Extend V4's repair-and-reject with MAP-003f repairs | Rejected. Repairs on shared Nodes cycle (A5), acceptance is about 0.7%, and the A1–A3 defects remain. |
| Pure generate-and-test | Rejected. The chance that a random typing satisfies thousands of routes at once is negligible. |
| SAT / ILP solver | Rejected. Exact, but it adds a dependency that does not carry over to the GDScript port. |
| **Construction with exact feasibility checks (chosen)** | Every step keeps the map completable, so no constraint is relaxed and nothing needs repair. It uses only arrays, a small lookup table and a bounded search, so it ports directly to GDScript. |

**Stage 1: skeleton (ICE / non-ICE layout and links).** Each Node keeps V4's ICE count, plus the longest ICE run and the longest non-ICE run over **every** route that reaches it. `_v5_feasible(row, count, ice_run, other_run)` is an exact, cached table that says whether such a Node can still be completed: it must reach exactly 6 ICE in rows 2–8 and 10–15 by row 15, with no run above 4. A link is made only when the merged state of the child stays feasible.
- Every parent receives a child it can legally continue into, so there are no dead ends.
- Every child is created from a parent, so there are no unreachable Nodes.
- Rows hold 3–4 Nodes.
- Each Node gets 2–3 links where the rules allow, as in V4.

In row 9, one Node becomes the MINIBOSS only if every row-8 Node linking to it also links to a standard ICE Node. Merging reduces to "longest run per kind" because a route violates spacing exactly when its own run passes 4, and the longest run is the worst case.

**Stage 2: types (non-combat Node types).** This is a backtracking search over non-combat Nodes in row order. Each Node keeps, over all routes reaching it, the minimum count of each type and the maximum Uplink count. A type is placed only if one completion still satisfies every one of those routes. The check (`_v5_types_ok`) is exact for a set of routes because each constraint bounds one type independently: Uplinks between 2 and 3, every other type at least 1. That makes the per-type minimum and the Uplink maximum the binding cases. At row 16 the check becomes the full rule for every route.

**Bounds:** 40 skeleton attempts, 30 tries per row, 4 type-search attempts per skeleton and 5,000 search steps per attempt, all in `V5_LIMITS`. When the limits run out, `gen5` returns `status: "failed"` with the reason and attempt counters. It never relaxes a constraint, and a unit test proves this.

**Determinism:** each seed has one `random.Random("MAP-003f/V5/<seed>")`. The code never iterates over sets, so results don't depend on `PYTHONHASHSEED`.

**Placement bias found and removed (see I3).** With a uniform choice among the five types, early rows got too few Uplinks, and the search then had to add them late: Uplinks averaged row 9.7 against about 7.7 for the other types. Weighting the order of attempts by each type's mean count per route (Uplink 2.2, others 1.2) evens this out to the figures in §4.

## 4. Validation: 200 accepted maps (record: `samples/v5_validation_200.json`)

`python3 prototypes/map/validate_map003_v5.py` independently enumerates every complete route of every map. It cross-checks the route count with dynamic programming and checks reachability forwards and backwards.

| Measure | V5 | V4 (same harness) |
|---|---|---|
| Candidate seeds attempted | 200 | 1,000 |
| Accepted / rejected | **200 / 0 (100%)** | 363 / 637 (36.3%) |
| Generation time | 0.55 s total; 2.7 ms mean, 47.5 ms worst per map | 39.7 s (about 40 ms per seed) |
| Validation time | 9.0 s for 1,623,047 routes | — |
| Maps failing any check | **0** | 356 of 363 accepted maps fail MAP-003f (distribution 314, MINIBOSS forced 138, dead end 33, spacing including row 1: 22; a map can fail several ways) |
| Dead-end / unreachable Nodes | **0 / 0** | 33 maps with dead ends |
| Routes per map | min 160, mean 8,115, max 68,868 | mean about 4,084 |

| Routes by Uplink count | Routes | Share |
|---|---|---|
| 2 Uplinks | 1,110,797 | 68.44% |
| 3 Uplinks | 512,250 | 31.56% |

| Distribution (U-S-D-L-G) | Routes | Share |
|---|---|---|
| 3-1-1-1-1 | 512,250 | 31.56% |
| 2-2-1-1-1 | 267,985 | 16.51% |
| 2-1-2-1-1 | 272,695 | 16.80% |
| 2-1-1-2-1 | 254,253 | 15.67% |
| 2-1-1-1-2 | 315,864 | 19.46% |

- 154 of 200 maps have at least one 3-Uplink route. 2 maps offer all five distributions, and most maps offer 3 or 4.
- **Placement** (mean row, weighted by routes; share of visits in rows 2–8):

| Type | Mean row | Rows 2–8 |
|---|---|---|
| Uplink | 7.9 | 58% |
| SAFEHOUSE | 8.5 | 55% |
| DEAD DROP | 8.7 | 49% |
| Console Lab | 9.1 | 49% |
| SIGNAL UNCLEAR | 8.9 | 51% |

- **Spacing:** longest same-kind run per route over rows 1–15 is 1 / 2 / 3 / 4 Nodes for 1,028 / 359,229 / 800,062 / 462,728 routes; no route exceeds 4. For information, 0.15% of routes have ICE in rows 12–15 followed by the boss (see I1).

**Mini-Boss.**
- Every map has exactly one, in row 9. Its category is kept: the JSON output has `type: "MINIBOSS"` and no identity or ability fields, as MINIBOSS-003 requires.
- 33.2% of routes pass through it, ranging from 0.7% to 64.4% per map.
- On average 2.03 row-8 Nodes lead to it. Every one of them also offers a standard ICE Node.
- From 100% of Nodes in rows 1–8 it can still be avoided, and from 79.6% the Rustler can still choose either way.

**Determinism.** 25 seeds were generated twice in-process and once in each of two fresh interpreters (`PYTHONHASHSEED` 1 and 4242), and their SHA-256 fingerprints were compared. All identical.

**Wider checks.** 1,000 accepted maps from 1,000 seeds: 8,007,197 routes, 0 failures, 3-Uplink routes 29.3%. 10,000 seeds generated: 0 failures; 96.5% needed only one skeleton attempt and the most needed was 4; worst case 94 ms.

**Unit tests:** `python3 -m unittest tests/python/test_map003_v5.py` gives 18 tests passing in about 36 s. They cover:
- 40 seeds, all accepted and fully valid;
- the five distributions derived independently of the table;
- MINIBOSS category without an identity;
- determinism across processes;
- bounded failure reporting;
- V4 output unchanged;
- a negative test for each constraint (dead end, unreachable Node, Uplink count, a missing type, ICE count, MINIBOSS missing or forced, fixed rows, a 5-long run), each confirmed to be reported.

## 5. Sample maps and reproducible seeds (`prototypes/map/samples/`)

Regenerate any sample with `python3 prototypes/map/map003_generator.py --v5 <seed>`.

| Seed | Routes | Uplinks 2 / 3 | Distributions present | Via MINIBOSS | SHA-256 (first 12) |
|---|---|---|---|---|---|
| 0 | 26,400 | 18,168 / 8,232 | 4 | 6,300 | d02ee6146662 |
| 1 | 4,560 | 1,824 / 2,736 | 2 | 480 | d9b2050ef8ac |
| 2 | 13,364 | 6,344 / 7,020 | 3 | 676 | f147e26102e8 |
| 3 | 2,516 | 1,887 / 629 | 4 | 1,248 | bdcfe173faa3 |

## 6. V4 preserved for regression

`gen`, `gen2`, `gen3` and `gen4` for seeds 0–299 hash identically before and after this change (`908bba37…`). The `--v2`, `--v4` and no-flag command-line output is byte-identical, and a unit test pins the `gen4` hash for seeds 0–59.

## 7. Interpretations to confirm (designer)

- **I1 Spacing window.** MAP-003c says "at most 4 ICE or 4 non-ICE Nodes in a row on any path". V5 counts the row-1 Opening Node, which V4 omitted (A2). This is stricter, never looser. The boss is not counted, because it is not one of the eight ICE Nodes; 0.15% of routes run ICE through rows 12–15 into the boss. Should the boss count?
- **I2 What "optional" means for the Mini-Boss.** V5 requires that every row-8 Node leading into the Mini-Boss also offers a standard ICE Node, so no route is forced into it at the last step. V4 did not guarantee this (A3).
- **I3 Type weighting.** The order of attempts is weighted 2.2 for Uplink and 1.2 for the others, so no type is pushed late. The result is about 30% 3-Uplink routes and 15–20% for each 2-Uplink distribution. MAP-003f sets no target frequencies; tell me if any are wanted.
- **I4 Branching.** As in V4, each Node gets 2–3 links where the rules allow. This produces 160 to 68,868 routes per map, and some rows are all ICE (no choice of kind there), as in V4. No rule covers either.
- **I5 Mini-Boss reach** varies per map from 0.7% to 64% of routes. Nothing requires a minimum. Some maps make it hard to reach. Should there be a floor (e.g. at least two row-8 Nodes lead to it)?

## 8. Concerns to settle before the GDScript port

1. **Seeds across languages.** Python's `random` and Godot's `RandomNumberGenerator` differ, so a seed will not give the same map in both. I recommend a small shared PRNG (e.g. PCG32) implemented in both, so Python fixtures can verify the GDScript port map by map. Otherwise the port can only be checked against properties, not exact maps.
2. **Runtime validation cost.** Up to about 69k routes per map makes full enumeration a test-time tool. In game, use the same per-Node checks (cheap), and keep enumeration in the headless tests.
3. **Map layout.** Links join Nodes by index, so drawn links may cross. Ordering Nodes to reduce crossings is a map-UI task (out of scope here), and it must not change the graph.
4. **CI.** `.github/workflows/godot-validation.yml` runs only Godot tests, so the Python tests do not run in CI. Adding a Python step is a CI change I have not made without authorization.
5. **Docs.** `REDLINE_CORE_RULES.md` §10 still describes the older UPL-007 / MAP-002 map. Master Design wins under DOCS-001, but the rules doc should be reconciled in a design pass.

## 9. Reconciliation record (CONSISTENCY-001)

**Owners.**
- **Approval and precedence:** Master Design, MAP-003f / MINIBOSS-003.
- **Current map definition:** `REDLINE_CORE_RULES.md` §10, with the MAP-003f text appended at its end.
- **Mini-Boss:** `REDLINE_MINIBOSSES.md`.
- **Technical contract:** this generator and report.

**Status.**

| Stage | State |
|---|---|
| Design | Approved (designer, 2026-11-27) |
| Implementation (Python prototype) | Built and validated (§4) |
| Documentation | Partly reconciled (table below) |
| GDScript implementation and map UI | Pending |

**Not fully reconciled:** D2, D3 and D4 remain open.

**Search.** I ran `git grep` across all tracked files, excluding historical material (the log archive, `docs/history/`, and the lore-only documents named in AGENTS §7). Terms covered:
- Uplink counts: "3+ SAFEHOUSE", "SAFEHOUSE + Uplink", "1 Uplink in 3", "at least 1 Uplink";
- Mini-Boss disclosure: "explained on the map", "before the player commits";
- generator references: `map003`, `--v4`, "MAP-003e remains";
- Mini-Boss and route terms under `godot/`.

**Godot consumers: none.** `godot/` has no map generator and no Mini-Boss code. The build's map is the hand-built four-row HALCYON slice in `game.gd`.

| ID | Where (file:line at commit) | Discrepancy | Severity | Action |
|---|---|---|---|---|
| D1 | `REDLINE_MINIBOSSES.md:10`; `REDLINE_ICE_EFFECTS.md:30` | Said the Mini-Boss ability is explained on the map, which MINIBOSS-003 explicitly supersedes | High (contradicts an approved rule) | **Fixed** in this commit (small doc fix that follows a recorded decision) |
| D1a | `REDLINE_MASTER_DESIGN.md` MINIBOSS-001/MAP-003a and MAP-003e paragraphs | Historical text without a superseded marker | Low | **Labelled** superseded / amended in this commit; the decision text itself is unchanged |
| D2 | `REDLINE_CORE_RULES.md:291–322` (§10) | Still describes the UPL-007 / MAP-002 map (15 Nodes, 10 infiltration rows, Central Node, escape, "at least 1 Uplink", "1 Uplink in 3 has a Clinic"). Superseded by MAP-003 to MAP-003f, but the owner section was never rewritten | High (the owner of current mechanics is stale) | **Open.** It spans several decisions, so it needs a design pass (Claude), designer review, and the CONSISTENCY-001 audit |
| D3 | `REDLINE_UPLINK_AND_CAPS.md:86, 97, 135` | "Clinic about 1 Uplink in 3", "50 CRED". Superseded by MAP-003d/e (every Uplink has the Clinic counter) and CLINIC-001 (30 CRED, 25% bulk discount). Predates MAP-003f | Medium | **Open**, for the CONSISTENCY-001 audit |
| D4 | Master Design, HANDOFF, development log, `REDLINE_MINIBOSSES.md` | Decision ID MINIBOSS-003 names two decisions (THE GRID's PROFILE + FORTIFY, and the Mini-Boss disclosure in MAP-003f) | Medium (ambiguous references) | **Open**: designer to re-ID one (surprise CLAUDECODE-20261127-S01) |
| D5 | `docs/HANDOFF.md` MAP-003c row | V4 described as the current generator | Low | **Labelled** superseded for route composition |
