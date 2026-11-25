# PANOPTICON — NUL/REM Dialogue Architecture Bible

**Decision:** NUL-DIALOGUE-002 | 2026-11-24 | Designer-requested design reference. Architecture PROPOSED; numerical targets provisional. No implementation or new gameplay rules authorized.

## 01 — Design objectives

> The intelligence of NUL/REM resides primarily in when he speaks and what he chooses to say, rather than in his ability to generate new sentences.

> Different players should discover different aspects of the same character, rather than encounter different characters.

Maintain a recognizable companion with warmth, humour, tactical competence, unreliable memories, conflicting protective obligations and desire for rest. Contextual relevance, continuity, replayability, psychological invisibility and meaningful silence outrank sheer volume. Philosophical meaning emerges through character contradiction and experience, not exposition. Preserve viable independence, refusal and indifference; never deliberately induce helplessness or disengagement.

Document responsibilities: [Philosophical Design Bible](PANOPTICON_PHILOSOPHICAL_DESIGN_BIBLE.md) explains why; [NUL/REM foundational design](REDLINE_NULREM_BEHAVIOURAL_LOCK_IN.md) explains who; [Dialogue Compendium](PANOPTICON_NULREM_DIALOGUE_COMPENDIUM.md) holds what he says; this document specifies how and when; [Manifestations Catalogue](PANOPTICON_PHILOSOPHICAL_GAMEPLAY_MANIFESTATIONS.md) records candidate experiences. Master design and approved rules retain precedence.

## 02 — Hybrid dialogue model

| Approach | Storage / processing | Strength | Limitation |
|---|---|---|---|
| Authored library | Very low | Literary precision, consistent voice, easy review | Requires content production |
| Procedural selection and constrained templates | Very low | Contextual variety, factual specificity, offline operation | Requires eligibility and grammar tests |
| Runtime language model | Model-dependent, potentially substantial | Open-ended variety | Unpredictable copy, latency, privacy and QA complexity |

Proposed baseline: authored lines selected procedurally from a local library, with limited deterministic variable substitution for factual observations. No runtime LLM, network dependency or external telemetry. Author emotional, philosophical, lore and consequential intervention lines individually. Selection never invents authority, events, promises or mechanics. Existing BOON and SIGNAL behaviour remains governed by approved rules.

## 03 — Dialogue taxonomy

Use a primary functional category for pacing and separate thematic tags from the compendium for editorial review. Categories are not psychological player types.

| Category | Purpose | Example or scope |
|---|---|---|
| Tactical assistance | Relevant actionable help | Advance ICE intelligence only if available under approved rules |
| Ordinary companionship and humour | Character beyond utility | Encouragement, jokes, ordinary conversation |
| Behavioural observations | Recall fictional actions accurately | “You left some bandwidth again.” |
| Situational reactions | Acknowledge an actual event | Surprise at an unexpected choice |
| Offers and transactions | Explain genuine optional arrangements | Actual costs, scope, benefits and consent |
| Philosophical introspection | Rare personal contradictions | “I sometimes wonder what I'd do if there was nothing I had to do.” |
| Narrative and lore | World and character continuity | Unreliable memories; guarded revelations |
| Behavioural interventions | Explain an actual authorized fictional restriction | “I've retained the program for you.” Only if separately approved and actually retained |

A line may have secondary tags, but count it once in pacing reports. Wording fragments are not automatically playable utterances.

## 04 — Dialogue pacing

Designer planning assumption: full run 70–75 minutes, approximately 150 dialogue instances. Average interval 28–30 seconds, not a timer or mandatory quota. An instance is one delivered utterance, not each sentence within it.

| Category | Illustrative instances per run |
|---|---:|
| Tactical assistance | 35 |
| Ordinary companionship and humour | 30 |
| Behavioural observations | 25 |
| Situational reactions | 20 |
| Offers and transactions | 15 |
| Philosophical introspection | 10 |
| Narrative and lore | 10 |
| Behavioural interventions | 5 |
| Total | 150 |

Introspection is about 7% of the illustrative mix. Interventions and offers occur only if eligible; independent runs may contain none. Never manufacture events to fill quotas. Prefer natural breaks, avoid interrupting card reading or decisions, suppress optional chatter during urgent feedback, and allow silence. Playtest density, readability, fatigue and actual run length. Required transactional information is not optional chatter.

## 05 — Contextual selection engine

Proposed read-only event pipeline:

1. Receive an actual gameplay event or eligible quiet presentation opportunity.
2. Build a snapshot of permitted fictional facts: corporation, encounter, recent actions, installed programs, observed history, actual approved delegation, prior delivered dialogue, reveal eligibility.
3. Retrieve candidate entries by event/category.
4. Apply hard eligibility: approved copy, factual predicates, canon/reveal guards, valid variables, actual authorization and scope, context, accessibility and delivery constraints.
5. Apply optional cooldowns, rarity, category balance and continuity preferences. Rank or weighted-sample only among eligible candidates using presentation-local randomness, never the gameplay RNG.
6. Revalidate before display; discard stale optional messages. Record delivery only after display.
7. If no eligible line exists, remain silent. Required factual UI feedback uses its approved path independently.

Example: after a completed encounter with verified repeated unused BW, a neutral observation may be eligible. No inferred player motive is needed. Knowledge/confidence/authority concepts from foundational design are not approved scoring formulas or psychological states. Do not implement unapproved behavioural enforcement through dialogue. Presentation consumes rules facts; rules never consume dialogue selection, ad profile or presentation history.

## 06 — Dialogue generation rules

Constrained templates may substitute typed, verified fictional facts:

| Template | Illustrative output |
|---|---|
| You've retained [PROGRAM] since [CORPORATION]. | You've retained the Extractor since HALCYON. |
| We've saved [VALUE] CRED through that arrangement. | We've saved 47 CRED through that arrangement. |
| You've left [RESOURCE] unused again. | You've left bandwidth unused again. |
| That's the [ORDINAL] time you've chosen that route. | That's the third time you've chosen that route. |
| I thought you'd install [PROGRAM] first. | I thought you'd install the Extractor first. |

The final example requires a genuine prior fictional prediction or an approved context that makes the statement truthful. Verify counts, history, terminology, articles, pluralization, ordinal formatting and rendered copy. Use allowlisted tokens and display names; never interpolate real personal information or arbitrary text. Missing or invalid values suppress the line rather than exposing placeholders. Validate both template and expanded output against copy guards. No free-form sentence assembly for introspection, consent, consequential restrictions or lore. All examples are drafts, not approved copy.

## 07 — Repetition management

Maintain delivered IDs, recent categories, last delivery time/event, and optional per-run occurrence counts in presentation-local state. Propose per-line and category cooldowns, one-shot rare lines, weighted variation, and recent-history exclusion. Exact values remain open. Distinguish repeated required information from optional chatter; never suppress necessary cost or refusal feedback. If a pool is exhausted, silence is preferable to repetitive or irrelevant speech. Cross-run history, if approved, remains local and must not imply NUL/REM remembers previous runs unless canon permits. Test narrow pools and long sessions.

## 08 — Narrative continuity

Use stable NR IDs and optional paired references from the compendium. Example NR-020 “I rather enjoy your unpredictability.” and NR-021 “I'd prefer you didn't do that again.” may occur far apart if both contexts independently qualify. Pairing is an editorial relationship, not a mandatory sequence or a psychological progression. Distinguish optional echoes from genuine prerequisites (a line explicitly recalling an earlier statement requires that statement to have occurred). Do not force contradictions or announce them. Preserve obsolete personality ROM, unreliable memories, protective obligations and existing SIGNAL-001 reveal guard. Avoid claims of off-game observation. Preserve the possibility of a companion who never exercises enforcement.

## 09 — Algorithmic curation

The dialogue system itself may express curated autonomy: different players encounter different facets of one character through eligible fictional events and choices. One may encounter a protective companion, another an observant assistant, another a witty or melancholic friend. These are illustrative experiences, not player classifications or fixed personalities. Do not infer susceptibility, optimize for compliance, or target emotional vulnerabilities. No trust meter, psychological phase, experiment reveal or prescribed outcome. Maintain a shared core voice and ordinary companionship across paths. Discovery rather than disclosure. Apply the four-question gate to any proposed gameplay mechanic; ordinary nonmechanical dialogue need not provide a strategic benefit.

## 10 — Dialogue data architecture

Proposed local JSON resource, loaded and validated once, indexed by event and category. Exact path, integration and schema subject to implementation review; no runtime file created here. Compendium is editorial source, not automatically shipped copy. Example draft record:

```json
{
  "id": "NR-032",
  "kind": "authored",
  "text": "You left some bandwidth again.",
  "status": "PROPOSED",
  "category": "behavioural_observation",
  "themes": ["memory", "perceived_observation"],
  "events": ["encounter_completed"],
  "requires": ["verified_repeated_unused_bw"],
  "variables": [],
  "weight": 1,
  "cooldown": null,
  "max_per_run": null,
  "paired_ids": [],
  "reveal_guard": "none",
  "source": "NUL-DIALOGUE-001a"
}
```

Fields and event names are illustrative, not existing APIs. Use typed validated predicates, not executable expressions in content. Approval status is a hard shipping gate. Separate immutable content from presentation-local delivery state; stable IDs survive revisions, with provenance and revision history. Validate duplicate IDs, dangling pairs, missing fields, invalid tokens and guard failures. Save only permitted fictional state locally under user:// if persistence is approved. No real-world personal data. Existing rules and presentation boundary is binding; any rules-affecting delegation must be separately specified and approved. Dialogue RNG must not change card draws or other gameplay outcomes.

## 11 — Performance and storage

At 150 bytes per line, 1,500 entries occupy about 225 KB raw text; 2,000 about 300 KB; 3,000 about 450 KB; 10,000 about 1.5 MB. UTF-8, metadata, indexes and engine overhead increase these estimates; audio excluded. Text storage is not a reason to prefer runtime generation. Index candidates by event, evaluate only on relevant events, avoid per-frame full-library scans, bound history and optional queues. No runtime model or network. Measure load time, memory and frame impact on target Windows hardware before setting budgets. Voice/audio, localization and delivery presentation remain separate decisions.

## 12 — Content development targets

| Stage | Provisional library size |
|---|---:|
| Current compendium | 75 entries (57 dialogue examples, 18 fragments; partial recovery) |
| Initial prototype | 250 |
| First substantial playtest | 500 |
| Full game | 1,500–2,000 |
| Mature library | 3,000+ |

At 150 distinct deliveries, a 3x library is 450 entries, 5x is 750, 10x is 1,500 and 20x is 3,000. These ratios are planning heuristics, not guarantees of variety: contextual eligibility and repetition matter more than raw totals. At 1,500 entries, a run of 150 distinct lines sees at most 10% of the library. Prioritize recovery of existing dialogue, coverage of common events, ordinary companionship and rare authored introspection. Review each line for voice, context, canon, copy guards and status before shipping. Track eligible pool sizes per event and corporation; do not count fragments as complete playable lines.

## 13 — Quality assurance

Proposed acceptance checks before implementation approval and release:
- Every delivered line is approved, eligible, factually accurate and grammatically complete; no unresolved tokens.
- No reveal before third punch card; existing SIGNAL-001 and all repository copy guards pass, including rendered substitutions.
- No unapproved action, cost, consent, authority or rule change is implied; required feedback remains intelligible.
- Independent, delegated, unusual and repeated-choice scenarios all work; zero eligible optional lines yields silence.
- Paired references resolve; explicit recalls require real prior delivery; no forced psychological progression.
- Cooldowns, category mix, queue bounds, stale-event cancellation and rare-line limits behave as specified.
- Same gameplay seed and actions produce identical rules outcomes regardless of dialogue selection or muting.
- Offline operation, local-only state, no external telemetry; no real personal data or psychological classification.
- Readability, pacing, interruption handling and accessibility verified in actual playtests; no deliberate frustration or helplessness.
- Measure load/memory/frame impact and dialogue coverage; test short and full runs, narrow pools and repeat runs.
- Apply four-question design gate to gameplay proposals; preserve all existing approval and audit gates.

Suggested QA fixtures: repeated unused BW; unexpected card choice; missing template variable; no eligible copy; pre/post reveal; actual delegated action versus mere recommendation; independent run; repeated run; identical rules seed with different dialogue seed. Record expected versus actual, not inferred psychological outcomes. Existing Godot tests remain mandatory for code changes.

## Open decisions and implementation boundary

Designer requested preservation of architecture, not a build. Proposed schema, event names, selection weights, cooldowns, persistence, pacing, content targets and QA fixtures require review. No new canon, approved copy, mechanics, file layout under godot/, or runtime implementation is established here. Claude Code owns implementation and tests under DEV-001 once separately authorized.
