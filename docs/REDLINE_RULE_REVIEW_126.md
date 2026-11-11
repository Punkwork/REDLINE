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


## RULE-127 — SyN prevention, mandatory discard, and overflow BURN (LOCKED, 2026-11-11)

**Approved resolution order:** When the Runner receives **SyN X**:

1. **Apply SyN prevention:** Deduct available SyN prevention from incoming SyN, consuming no more prevention than the incoming amount.
2. **Determine unprevented SyN:** Resolve only the remaining SyN amount.
3. **Mandatory discard:** The Runner **MUST** choose and discard as many cards as possible from their current hand, up to the unprevented SyN amount. The Runner chooses *which* cards, but **cannot** voluntarily keep eligible cards and take BURN instead.
4. **Calculate overflow:** Each point of unprevented SyN not fulfilled by a card discard generates **2 BURN damage**, per RULE-126.
5. **Resolve BURN:** After mandatory discards, apply any available **BURN prevention** to the generated BURN damage; only unprevented BURN reduces **Vitae (VIT)**.

**Example:** Incoming SyN 5, SyN prevention 2, and 1 card in hand: 3 SyN remains; the Runner must discard that 1 card; 2 SyN overflow generates **4 BURN**. Apply BURN prevention, if any, before reducing Vitae.

**Priority and scope:** RULE-127 specifies the resolution sequence and prevention interaction for RULE-126. **SyN** is Runner-selected *mandatory* discard; **BURN** is the official Vitae-damaging keyword; **CHAR** is only colloquial slang for BURN in the World Bible; **VOID** is distinct. This rule does not invent additional prevention resources or change the previously established prevention-pool duration/stacking rules. Any unspecified simultaneous trigger timing remains open.

**Regression expectations:** Test full/partial/no SyN prevention, full/partial/empty hand, compulsory discard, BURN prevention of overflow, and zero-Vitae defeat. **Status: LOCKED, explicitly approved 2026-11-11.**
