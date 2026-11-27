# Canonical Source Architecture: CSA-01 audit and CSA-02 proposal

**Decisions:** CONSISTENCY-001 (`ad18fb3`), CONSISTENCY-001a (`1b88af2`), PROBE-004a (`39572b6`).
**Author:** Claude Code, 2026-11-27, at `architecture-v2` `c0e4acb`.
**Status:**

| Part | State |
|---|---|
| CSA-01 (authority and dependency mapping) | Delivered for designer review |
| CSA-02 (target architecture and migration plan) | PROPOSED, awaiting designer approval |
| CSA-03 to CSA-07 | Not started |

**Stop point:** stopped at the architecture approval gate. There is no new schema, no engine change and no repository-settings change. The only new files are evidence:
- the read-only scanner `tools/csa/scan_card_drift.py`;
- the PROBE conformance probe `evidence/csa-01/probe_conformance.gd`, not a CI test;
- their outputs in `evidence/csa-01/`.

This document is a technical contract proposal under `docs/architecture-v2/`, the owner of technical contracts per CONSISTENCY-001. It is not a card authority and restates no card values as current. Card values quoted here are evidence of what each source says.

---

## 1. Root-cause analysis

Drift is not an accident of individual commits. The current system has **no path by which a decision reaches its consumers, and no check that notices when it doesn't.** Each cause below has repository evidence.

| # | Root cause | Evidence |
|---|---|---|
| RC1 | **No structured authority for a card.** One card has up to six hand-maintained representations, and none is derived from another (1) | — |
| RC2 | **Decisions spread by copy-paste.** Governance requires it (2) | — |
| RC3 | **Current values must be reconstructed from amendments.** | AGENTS §7: "Later amendments tables win over older text in the same doc, even where that text wasn't edited." Stale rows are therefore legal by rule; the reader is expected to know which later paragraph overrides them. Example: `REDLINE_CARD_POOLS.md:123` still lists DEFRAG as "Draw 1", though DEFRAG-001 changed it (CardDB has the approved "Discard 1 card, then draw 2"). |
| RC4 | **Two current truths with no model.** `Game.CORE_LOOP` switches behaviour, but cards have one text (3) | — |
| RC5 | **Tests pin implementation, not decisions.** The suite is green while the build contradicts an approved rule (4) | — |
| RC6 | **No status for approved but unimplemented, experimental or example.** Card tables mix these with no machine-readable status (5) | — |
| RC7 | **Enforcement runs after the fact and covers only Godot behaviour.** (6) | — |
| RC8 | **Audits produce documents, not checks.** | STATIC_SOURCE_AUDIT.md, DEPENDENCY_MAP.md, the DOCS-MIG-001 gate and UI-BIBLE-001 reconciliation are point-in-time reports. Nothing re-runs them, so their findings decay at the next decision. The one exception proves the remedy: ARCH-V2-005's coverage table (JSON → generated Markdown, checked by `test_arch_v2_coverage.gd`, 548 checks) has not drifted. |

**(1) RC1: the six representations of a card.**

| Representation | Where | Example (PROBE) |
|---|---|---|
| Decision text | Master Design PROBE-004a | — |
| Copies of that decision | Appended to 4 topic docs plus HANDOFF and the log | — |
| Doc card-table rows | Core Rules §13, RUSTLERS (4 tables), ENGINES | — |
| CardDB `text` string | `cards.gd:25` | "…A PROBE on a VOID reveals its top face-down subroutine." Contradicts PROBE-004a |
| Behaviour with literal numbers | `game.gd:700–705` | `reduce_ice_str(target, 2)` plus `_probe_reveal` |
| Per-card text overrides | `game.gd:2261` `card_text()` | e.g. WARM BOOT `5 + amp` restates a number held in `game.gd` behaviour |

Scanner results (`tools/csa/scan_card_drift.py`, output `evidence/csa-01/card_drift.json`):
- 34 active docs hold 189 card-table rows.
- Of the 124 rows naming a CardDB card, **35 differ in text** and **2 differ in BW**: PROBE 1 BW in `REDLINE_ENGINES.md:111`, BURST 0 BW in `REDLINE_CARD_POOLS.md:126`.
- 9 cards are tabulated in more than one doc; PROBE appears in 6 rows across 3 docs.

**(2) RC2: decisions spread by copy-paste.** AGENTS rule 6 requires each decision ID "in the design doc, HANDOFF and the log". In practice, the decision paragraph is pasted into every doc it touches.
- PROBE-004a (`39572b6`) appended the same paragraph to `REDLINE_CORE_RULES.md`, `REDLINE_CORE_LOOP.md`, `REDLINE_CARD_POOLS.md`, `REDLINE_RUSTLERS.md`, Master Design, HANDOFF and the log. It edited 5 table rows by hand, but not `REDLINE_ENGINES.md:111`, `cards.gd:25`, `game.gd:700` or `test_core_loop.gd:98`.
- SYNERGY-PLAYTEST-002 was written as five single-file commits within one minute: `6f1178d` Master Design, `af104e1` DECK_SYNERGY, `3ab3a9e` HANDOFF, `00d564a` log, `7d4be96` DAILY_PRIORITIES.
- Each copy is a new mutable definition. Completeness depends on whoever pastes remembering every consumer.

**(3) RC4: two current truths, one text.**

| Item | Code | CardDB text | Card Pools doc |
|---|---|---|---|
| DEEP PROBE | `game.gd:795` `5 if CORE_LOOP else 4` | "−5" | "−4" (`REDLINE_CARD_POOLS.md:115`) |
| Starter Icepicks | STR 2 under STR-001 | — | Core Rules §13 and RUSTLERS: STR 1 / 3 / 0 |
| PROBE reveal | Exists only `if CORE_LOOP` (`game.gd:702`) | — | — |

**(4) RC5: tests pin the superseded behaviour.**
- `test_core_loop.gd:98–101` asserts the superseded top-only reveal ("STRIP-001: PROBE reveals the top face-down sub"), run from `test_game.gd:42`.
- Fresh run in this session: `test_game.gd` **430 passed, 0 failed**.
- The conformance probe (§6, `evidence/csa-01/probe_conformance.txt`) checks the same engine against the approved PROBE-004a text: **5 of 7 checks fail**.
- No test references a decision as its requirement source, so nothing fails when a decision changes.

**(5) RC6: no status vocabulary.**
- 56 card names in active doc tables have no CardDB entry.
- 10 of them are the approved SYNERGY-PLAYTEST-002 cards (`REDLINE_DECK_SYNERGY.md:401–410`).
- Others are experimental (`PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md`, e.g. BLACK BUDGET `:232`) or illustrative (`REDLINE_ENGINES.md`, `PANOPTICON_CHAIN_MECHANICS.md`).
- A tool or agent cannot tell "approved, build it" from "example, ignore", so "approved but not built" is invisible.

**(6) RC7: enforcement gaps.**

| Gap | Evidence |
|---|---|
| No protection on the canonical branch | `architecture-v2` has no branch protection (`GET …/branches/architecture-v2/protection` → 404) and no ruleset; the only rulesets are `protect-main` (28076208) and `release` (28104142). Every push lands first, and CI reports later. |
| CI checks behaviour only | `.github/workflows/godot-validation.yml` runs Godot tests only. There is no docs, data, link, decision or Python check; `tests/python/` is not run. |
| Pull requests skip non-Godot changes | The `pull_request` trigger is filtered to `godot/**`, so docs-only PRs get no checks. |
| Intermediate commits never verified | `cancel-in-progress: true` plus per-file commit bursts: of the last 40 runs on `architecture-v2`, 28 were cancelled (read 2026-11-27 ~18:30). |
| Retired terms survive in code | BOOTING (BOOTING-RETIRE-001) still has live logic at `game.gd:1282` and `:1910`; TOLL (TOLL-RETIRE-001) at `game.gd:1289`. No check would flag them. The copy guard (`ArchCopy.valid_line`) is the only term checker, and it covers narrative copy only. |

## 2. Existing canonical source inventory

| Domain | Intended owner (CONSISTENCY-001, AGENTS §7) | Actual runtime authority | Other independent definitions |
|---|---|---|---|
| Decisions and precedence | `REDLINE_MASTER_DESIGN.md` | — | Pasted copies in topic docs, HANDOFF and log (RC2) |
| Card mechanics and text | Core Rules §13; `REDLINE_CARD_POOLS.md`; `REDLINE_RUSTLERS.md` (starters) | `CardDB.DEFS` (`cards.gd`, 112 cards plus 5 CAPS) and `game.gd` behaviour | ENGINES, DECK_SYNERGY, CHAIN_MECHANICS, Experimentation Bible, CORE_LOOP; `card_text()` overrides |
| Starter decks and reward pools | RUSTLERS, CARD_POOLS | `CardDB.STARTER_*`, `CORE_POOL`, `POOL_EXTRA`, `reward_pool()` | CORE_LOOP pool list (`REDLINE_CORE_LOOP.md:61`) |
| ICE and subroutines | `REDLINE_ICE_CORP1–3.md`, ICE Rules Bible, ICE_EFFECTS, ICE_PASSIVES | `IceDB` (`ice.gd`) and `game.gd` | `visible_state_adapter.gd:181` effect words "ported unchanged from Build 12" |
| CAPS and Ghostware | `REDLINE_UPLINK_AND_CAPS.md` | `CardDB.CAPS`; Ghostware in `game.gd` / `cards.gd` | Uplink spec text (UPLINK-SPEC-001) |
| Copy and approval | `godot/data/*.json` | Same (`ArchCopy`, `AdpCopy`) | — (works: data-driven with guards) |
| UI contracts | UI Bible; GitHub Issues (UI-WORKFLOW-001) | V2 components | — |
| Technical contracts | `docs/architecture-v2/` | — | `DATA_MODEL.md` already names CardDB as the initial authority and defers the format decision |
| Map generation | Master Design MAP-003f | `prototypes/map/map003_generator.py` V5 | Core Rules §10 (stale; MAP-003f report §9, D2) |

**Reusable infrastructure.**
- `godot/data/` JSON loaded by static vars (`ArchCopy`), included in the export preset.
- The ARCH-V2-005 pattern: a JSON source, a generator (`tools/arch_v2_coverage_md.py`), and a Godot test that fails on drift.
- `CardDB.def()` / `roles()` / `reward_pool()` as the single code entry point: all 39 card references in `main.gd` and `friendly_lie`, plus `visible_state_adapter.gd:236`, go through `CardDB`.
- The copy guard as the model for a term guard.
- `test_arch_v2_parity.gd` for behaviour-preservation checks: 80 encounters, 4,008 actions.

## 3. Dependency and consumer map (cards)

```text
Designer decision ─► Master Design (text) ─► pasted into topic docs / HANDOFF / log      (manual, RC2)
                                       ╲─► CardDB.DEFS text        (manual, often missed)
                                        ╲─► game.gd match arms     (manual; numbers literal)
                                         ╲─► tests                 (written from the code)

CardDB.def(id) ──► Game (costs, roles, pools, compiled cards)
               ├─► visible_state_adapter.card_model ─► card_view (V2 hand), key_inspector (hover)
               ├─► main.gd / friendly_lie (Build 12 UI, reward screen, deck views)
               └─► Uplink (UPLINK-SPEC-001, not built) and Universal Object Inspector (UI-INSPECTOR-001, not built)
Docs card tables ◄── nobody (no generator)
```

- Every code consumer already funnels through `CardDB`. That is the cheap seam: change what feeds `CardDB`, not its callers.
- Docs have no inbound link from the data at all.

## 4. Proposed target architecture (CSA-02)

**Principle:** one structured record per gameplay entity. Code and generated docs **consume** it, independent spec tests **check** it against decisions, and CI **enforces** it.

| # | Element | Proposal |
|---|---|---|
| 1 | Canonical card records | `godot/data/cards.json`: the existing data directory and export path, in the same JSON style as `arch_copy.json`. One record per stable card ID (the current `CardDB.DEFS` keys, e.g. `PROBE`). It holds structured fields plus a rules-text template whose numbers come from the record's parameters (record below). `.tres` resources and GDScript constants were also considered; JSON is diffable, readable by Python CI without Godot, and already used. **Designer decision Q1.** |
| 2 | CardDB becomes a loader | `CardDB.DEFS` is built from `cards.json` at load. `def()`, `roles()` and `reward_pool()` keep their signatures, so the ~40 call sites are unchanged. A parity test asserts that the loaded definitions equal today's `DEFS` for every card before the constant is retired (CSA-03). |
| 3 | Engine reads parameters, keeps handlers | `game.gd` keeps bespoke GDScript per card (complex behaviour stays explicit; no effect DSL). Literal numbers become `CardDB.param(id, path)` calls, e.g. PROBE's `modes.weaken.amount`. Cards that can't yet be parameterised are marked `"params_in_code": true`, so the gap is visible and counted. |
| 4 | Text is generated | Card text, the Inspector and docs read `CardDB.rules_text(id)`, rendered from the template. `game.card_text()`'s per-card number overrides move into the template (AMP as a template variable). |
| 5 | Generated doc views, not sources | Owner docs (Card Pools for pool cards, Rustlers for starter decks) get a marked generated block (`<!-- GENERATED:cards … -->`), built by `tools/csa/gen_card_docs.py`, as ARCH-V2-005 does. Other docs reference `card:PROBE` instead of restating values (RC2). |
| 6 | Current versus historical | Current = the canonical record plus owner prose; history = Master Design and the log. Appended decision copies in topic docs are relabelled *historical decision record* (CSA-06). The AGENTS §7 "later amendments win" rule is retired for any entity that has a canonical record. **Designer decision Q3.** |
| 7 | Status and traceability | Each record carries `decisions` (IDs that must exist in Master Design) and `status.design` / `status.implementation` (below). Approved-but-unbuilt cards (the 10 SYNERGY-PLAYTEST-002 cards) get records with `implementation: pending`, so they can be counted and listed. New decisions add an `Affects: card:ID` line, and CI reports decisions whose entities don't list them. |
| 8 | Independent spec tests | `godot/tests/spec/test_card_spec_probe.gd` and siblings. Expectations are **literals copied from the approved decision**, each tagged with its decision ID, never read from `cards.json` or the code. A data or engine change that contradicts a decision fails until the decision and the test are updated together. |
| 9 | Consumers | The Universal Object Inspector (UI-INSPECTOR-001) gets one content contract, `CardDB.inspector_model(id)` (name, classification, rules text, costs, flavour, art), built from the record and reused by `visible_state_adapter.card_model`. The Uplink (UPLINK-SPEC-001) reads `rarity`, `pool`, `basic` (BASIC-001, never sold) and the price table from the same records; today these are `CORE_POOL`, `POOL_EXTRA` and prose. |
| 10 | Extension (CSA-07) | ICE (`ice.json`: subroutines as structured effects, which already exist as dictionaries in `IceDB`), CAPS and Ghostware follow the same record, loader and spec-test pattern. They share the ID namespace (`ice:`, `cap:`, `ghostware:`) and the reference checker. |

**Element 1 example record** (shape only; values are the approved PROBE-004a values):

```json
{"id": "PROBE", "name": "PROBE", "type": "SCRIPT", "tags": ["EXPLOIT"], "rarity": "STARTER", "basic": true,
 "cost": {"bw": 0, "escalation": {"per": "same_card_on_target_this_turn", "amount": 1}},
 "modes": [{"id": "weaken", "target": "ICE", "params": {"amount": 2, "duration": "encounter"}},
           {"id": "reveal", "target": "ICE", "requires": {"ice_type": "VOID", "hidden_min": 1}, "params": {"scope": "all"}}],
 "rules_text": "Choose one: Target ICE: −{modes.weaken.amount} STR this encounter. OR Target VOID: Reveal all hidden subroutines. Costs {cost.escalation.amount} additional BW for each PROBE already played on the target ICE this turn.",
 "flavour": "The deeper you probe, the costlier it gets.", "art": "res://assets/concept/cards/PROBE.png",
 "decisions": ["PROBE-001", "PROBE-003", "PROBE-004", "PROBE-004a"],
 "status": {"design": "approved", "implementation": "divergent"}, "variants": {}}
```

**Element 7 status values:**

| Field | Values |
|---|---|
| `status.design` | `approved`, `playtest`, `experimental`, `historical` |
| `status.implementation` | `implemented`, `pending`, `divergent` |

**Build variants (RC4).** `variants: {"core_loop": {…}}` holds explicit per-build overrides, so the docs can show both and the tests check both. **Designer decision Q4:** keep variants, or declare the core-loop values current.

## 5. Migration plan

| Milestone | Work | Depends on | Acceptance criteria | Estimate (agent sessions) |
|---|---|---|---|---|
| CSA-01 | Authority and dependency mapping | — | This document plus evidence | **Done** (for review) |
| CSA-02 | Designer review of §4, decisions Q1–Q9 | CSA-01 | Designer approval recorded in Master Design | 0.5 (revisions) |
| CSA-03 | `cards.json` from `CardDB.DEFS` (112 cards plus 5 CAPS); loader; schema; parity test (loaded equals old `DEFS`, all Godot suites unchanged); records for approved-unbuilt cards with `implementation: pending`. The 35 text and 2 BW conflicts go to the designer as a resolution table; none is chosen silently | Q1, Q2, Q4 | Parity 100%; baseline suites unchanged (430, 17, 672, 202, 548, 110, 76, 29, 4,088 checks) | 1–2 |
| CSA-04 | Consumers: text templates; `param()` in `game.gd` for simple numeric effects; `inspector_model()`; V2 card view and inspector via the contract; pools from data for Uplink and rewards; generated doc blocks. **PROBE-004a implementation** (choose-one in the engine and both UI paths) as the acceptance case | CSA-03 | §6 PROBE tests green; generated blocks match; consumer coverage report | 3–5 |
| CSA-05 | CI: Python job (schema, IDs, references, generated drift, deprecated terms, decision traceability, AGENTS/CLAUDE equality, `tests/python`); spec tests in the Godot job; fix the PR path filter; required-check proposal | CSA-03 (some checks can land earlier) | Each check proven by a negative test; designer decision on the ruleset (Q5) | 1–2, plus designer settings |
| CSA-06 | Retire duplicates: hand card tables in ENGINES, DECK_SYNERGY, RUSTLERS and Core Rules become generated blocks or references; appended decision copies labelled historical; `DEFS` constant deleted; stale tests rewritten as spec tests | CSA-04, CSA-05 | Scanner reports 0 independent active card definitions; all suites green | 1–2, plus Claude editorial review |
| CSA-07 | ICE, then CAPS and Ghostware, same pattern | CSA-06 | Same criteria per entity | 3–5 |

**Order inside CSA-03 and CSA-04:** the loader and parity test first (no behaviour change), then text, then parameters card by card. Each step is an atomic commit tagged CSA-0n. The Representative ICE Encounter stays priority 1: CSA work does not touch the V2 encounter components except through `CardDB` and the adapter contract.

## 6. PROBE acceptance test specification

**Baseline evidence (this session).**
- Godot 4.3 stable, pinned hash verified. Command: `godot --headless --path godot --script <abs>/docs/architecture-v2/evidence/csa-01/probe_conformance.gd`.
- `CORE_LOOP=true`, encounter DOORBELL CAM (VOID), 4 hidden subroutines.

| Check | Current engine |
|---|---|
| B1 STR mode does not reveal | **FAIL**: hidden 4 → 3 while STR 5 → 3 |
| B2 reveal mode reveals all, no STR change | **FAIL**: no mode exists; one play reveals 1 of 4 and lowers STR by 2 |
| B5 escalating cost across copies | PASS: 0, then 1 |
| B6 independent counter per ICE | **FAIL** for two copies of the same ICE: the counter is keyed by ICE type ID (`game.gd:704`), not instance. Different ICE types pass (`test_core_loop.gd:38`) |
| B9 insufficient BW prevents the play | PASS |
| A1 engine text equals approved text | **FAIL** (`cards.gd:25`) |
| B8 cancellation | **Not testable**: there is no choose-one step |

**Behavioural spec tests (CSA-04).** File `godot/tests/spec/test_card_spec_probe.gd`; expectations are literal and cite PROBE-004a.

| ID | Test | Expectation |
|---|---|---|
| B1 | STR mode | Target ICE STR −2 for the encounter; hidden-subroutine count unchanged |
| B2 | Reveal mode on VOID | All hidden subroutines seen and breakable; STR unchanged |
| B3 | Targeting | Reveal is offered only for a VOID target with ≥ 1 hidden subroutine. STR mode accepts any ICE. No ICE target, no play |
| B4 | Reveal unavailable | VOID with 0 hidden: only STR mode offered; a forced reveal call is rejected with no state change |
| B5 | Shared escalation | Costs 0, 1, 2 on one target across copies and across both modes in any order |
| B6 | Independent counters | ICE A count does not affect ICE B, including two instances of the same ICE type (Q6) |
| B7 | Reset | Count returns to 0 at the start of the next Rustler turn, not at the response |
| B8 | Cancellation | Cancelling the mode or target choice leaves BW, hand, piles, STR, seen flags and counters identical (deep compare) |
| B9 | Insufficient BW | With BW below the escalated cost, the play is refused and state is identical |

**Architectural tests (CSA-04/05).** Each runs on a **copy** of the data in a temp directory; live balance is never edited.

| ID | Demonstrates | Method |
|---|---|---|
| T1 | A canonical change propagates or fails validation | Copy `cards.json`, set `modes.weaken.amount` to 3. Assert `rules_text` shows −3 and `param()` returns 3. The spec test B1 run against the copy **fails** (approved −2), proving divergence is caught |
| T2 | Generated docs cannot silently diverge | Edit one character inside a generated block in a doc copy; `gen_card_docs.py --check` exits non-zero |
| T3 | The Inspector consumes the authority | `inspector_model("PROBE").rules` equals `rules_text("PROBE")`; with T1's copy loaded, the Inspector text changes |
| T4 | Invalid IDs are detected | A doc reference `card:PR0BE` and a starter-deck entry `PROBEE` each fail the reference check |
| T5 | Deprecated terms are detected | Add "BOOTING" to a card record copy; the term guard (list kept in `godot/data/terms.json` with retiring decision IDs) fails. Active code hits are reported as a baseline register until retired |
| T6 | Retiring a redundant definition breaks nothing | Delete the `CardDB.DEFS` constant on a branch-local run; all suites stay green with the loader, and the scanner reports 0 active hand tables for migrated cards |
| T7 | Behaviour divergence is caught | Run B1/B2 against today's engine: they fail (as in the baseline above). After the PROBE-004a implementation they pass |

## 7. Automated enforcement plan

| Check | Implementation | Job |
|---|---|---|
| Schema | `tools/csa/validate.py` against a JSON Schema in `tools/csa/` | New Python job, no Godot needed, under 10 s |
| Unique and valid IDs; referential integrity | Starter decks, pools, compiled IDs, `card:` references in docs, test references | Python |
| Generated-output drift | `gen_card_docs.py --check`; the existing coverage check pattern | Python and Godot |
| Deprecated active terms | `terms.json`, applied to active data, code and docs; history excluded by the AGENTS §7 list | Python |
| Decision traceability | Every `decisions` ID exists in Master Design; `Affects:` lines against records; status values valid | Python |
| Gameplay regression | Existing suites plus `tests/spec/*` | Godot job (fix: include `tests/spec`) |
| AGENTS = CLAUDE | `cmp AGENTS.md CLAUDE.md` | Python job |
| `tests/python` | `python3 -m unittest discover tests/python` (map generator today) | Python job |

**Can required checks prevent bad changes from entering `architecture-v2`? Yes, with conditions.**
- The repository is public, so branch rulesets with required status checks are available.
- **Today nothing is enforced on `architecture-v2`** (§1, RC7).

Requiring checks has consequences:
- **Direct pushes would be refused** unless the pusher is on the bypass list. The designer's and ChatGPT's web/API doc commits would move to pull requests, or the designer would be a bypass actor, which keeps the gap open for those commits.
- **The PR path filter (`godot/**`) must be removed first.** Otherwise docs-only PRs wait forever for a required check that never runs.
- **The one-commit-per-file habit (RC2) becomes one PR per decision.** That is the atomic unit CONSISTENCY-001 already asks for.

**Limitations.**
- This session's token can read rulesets but was not tested for admin rights, and I changed nothing (CONSISTENCY-001a).
- The local `gh auth status` reports the token as invalid, although API reads succeed.
- Agent sessions cannot push tags (AGENTS §5).
- The designer must create or approve any ruleset (**Q5**).

**Semantic checks no machine can do.** Whether a decision's prose and its record mean the same thing, and whether a rules-text template reads well, stay human review points. The PR (or the daily review) is where they are seen.

## 8. Risks, unresolved questions and designer decisions

**Decisions requested**

| # | Decision | Recommendation |
|---|---|---|
| Q1 | Canonical format | `godot/data/cards.json` (JSON) |
| Q2 | Which docs hold generated card views | Card Pools (pool cards), Rustlers (starters); others reference `card:ID` |
| Q3 | Governance: replace "paste the decision into each doc" (rule 6 practice) and "later amendments win" (§7) for entities with records | Decision text only in Master Design; HANDOFF and log reference the ID; records list the ID |
| Q4 | Build variants (DEEP PROBE −5 / −4, Icepick STR) | Explicit `variants.core_loop`; or declare the core-loop values current |
| Q5 | Ruleset on `architecture-v2` requiring the Python and Godot checks; PR workflow or bypass actors | Require checks; designer as the sole bypass, used rarely |
| Q6 | PROBE counter per ICE **instance** (approved text says "the target ICE") | Per instance |
| Q7 | Resolving the 35 text and 2 BW conflicts during CSA-03 | Designer resolution table; where a later approved decision exists, it wins |
| Q8 | Records for approved-unbuilt and experimental cards | Approved: yes (`pending`). Experimental: stay in the Experimentation Bible, outside `cards.json` |
| Q9 | Retired mechanics still in code (BOOTING, TOLL) | Retire in a controlled rules commit under their decision IDs, after spec tests exist |

**Risks**
- **Migration churn on the priority-1 encounter.** Mitigated: the `CardDB` API is unchanged, and the parity test runs before any consumer change.
- **Template text drifting from approved wording.** Mitigated: spec test A1 compares the rendered text with the approved literal.
- **Over-abstraction.** No effect DSL; handlers stay in GDScript.
- **Agents editing generated blocks.** CI drift check, and the blocks carry a "generated, do not edit" banner.
- **Multi-agent writes during migration.** One CSA batch at a time, each atomic, with the scanner run before and after.

**Open (not blocking CSA-02)**
- The Experimentation Bible's card IDs (EXP-C045 etc.) versus stable card IDs at promotion.
- Localisation of templates (out of scope).
- `PANOPTICON_CHAIN_MECHANICS.md:125` lists "PROBE" among non-card actions. Either the term means something else there, or it is a conflict. Designer or Claude to clarify.

## 9. Remaining enforcement gaps (explicit)

Until CSA-05 and Q5:
1. Nothing blocks a push to `architecture-v2`.
2. No check runs on docs or data.
3. Python tests don't run in CI.
4. Spec tests don't exist; the green suite includes a test of superseded PROBE behaviour.
5. Retired terms are unchecked in code.
6. Approved-unbuilt cards are unlisted.

None of these is closed by this document.

## Reproduce

```bash
python3 tools/csa/scan_card_drift.py --json docs/architecture-v2/evidence/csa-01/card_drift.json
GODOT=/path/to/Godot_v4.3-stable_linux.x86_64
"$GODOT" --headless --path godot --editor --import --quit
"$GODOT" --headless --path godot --script "$PWD/docs/architecture-v2/evidence/csa-01/probe_conformance.gd"
gh api repos/Punkwork/REDLINE/rulesets; gh api repos/Punkwork/REDLINE/branches/architecture-v2/protection
gh api "repos/Punkwork/REDLINE/actions/runs?branch=architecture-v2&per_page=40" --jq '.workflow_runs[].conclusion'
```

Baseline suites run in this session at `c0e4acb` (all exit 0, no `SCRIPT ERROR`):

| Suite | Passed / failed |
|---|---|
| import | exit 0 |
| test_game | 430 / 0 |
| test_adp | 17 / 0 |
| test_signal_carbon | 672 / 0 |
| test_arch_v2_ice | 202 / 0 |
| test_arch_v2_coverage | 548 / 0 |
| test_arch_v2_batch3 | 110 / 0 |
| test_arch_v2_batch4 | 76 / 0 |
| test_arch_v2_app | 29 / 0 |
| test_arch_v2_parity | 4,088 / 0 (80 encounters, 4,008 actions) |

## Compliance review record (`COMPLIANCE_CHECKLIST.md`)

**Record header.**

| Field | Entry |
|---|---|
| Milestone / decision ID | CSA-01 / CSA-02 (CONSISTENCY-001a) |
| Branch / commit | `architecture-v2`, audited at `c0e4acb` |
| Reviewer | Claude Code self-review; the designer approves |
| Baseline | `main` = `prototype-baseline` = `21922ad` (verified via `git ls-remote`) |
| Automated tests | Baseline suites above, all pass |
| Display fixtures | Not run (no UI change) |

**Checklist results.**

| Section | Item | Result |
|---|---|---|
| A. Governance and scope | Latest branch; `main` and `release` untouched | PASS |
| | Decision ID in Master Design, HANDOFF and log | PASS |
| | Proposal distinguished from approval | PASS |
| | Designer approval before implementation | NOT YET: this is the request |
| B. Rules and model isolation | No behaviour change; `Game` stays authoritative; the proposal keeps the `CardDB` API | PASS |
| C. Scenes, components and data | "No unreviewed conversion of CardDB/IceDB": only proposed, not done | PASS |
| | Schema versioning for the future `cards.json` | Proposed (`schema` field plus parity test) |
| D. Safety, presentation and accessibility | No UI or copy change | N/A |
| E. Verification and delivery | Suites pass | PASS |
| | Display fixtures | N/A |

**Exceptions:** none.
**Recommendation:** approve CSA-02 with decisions Q1–Q9, or revise.
