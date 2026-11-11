# REDLINE Rule Review — RULE-126

**Status:** APPROVED AND LOCKED in the rule review
**Title:** SyN DAMAGE Overflow
**Decision:** User explicitly approved on 2026-11-11.

## Approved wording
When SyN DAMAGE X exceeds the number of cards in the Runner's hand:
1. The Runner chooses and discards all available cards, up to X.
2. Each unfulfilled point of SyN DAMAGE causes 2 Vitae damage.
3. Apply that Vitae damage after discarding the available cards.

## Regression examples
| SyN DAMAGE | Hand size | Cards discarded | Vitae damage |
|---:|---:|---:|---:|
|3|3|3|0|
|3|2|2|2|
|3|1|1|4|
|3|0|0|6|
|5|2|2|6|

## Terminology
Use **SyN DAMAGE** for the runner-chosen hand-discard damage in this rule. Do not substitute the legacy terms NEURAL DAMAGE or SYNAPTIC DAMAGE in new review wording.

## Source reconciliation needed
The supplied REDLINE_MASTER_DESIGN(2).md and REDLINE_CURRENT_STATUS(2).md still contain older terminology and a no-Vitae-damage distinction. This decision supersedes that distinction for SyN DAMAGE overflow, but those source files were **not** silently edited. Update authoritative documents through the project's normal reconciliation process.

## Next
RULE-127: pending review; not approved.


**Terminology lock (2026-11-11):** **Vitae** is the canonical Runner health resource (abbreviated **VIT** in the World Bible). The former health-resource term is deprecated. **BURN damage** reduces Vitae. This terminology update does not itself change damage-resolution mechanics.
