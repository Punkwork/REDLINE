# PANOPTICON — UI, Interactions & NUL/REM Character Design
## Claude implementation handoff · 2026-11-07

**Scope:** Visual presentation, controls, selection screens, card readability, dialogue system and character writing. Engine combat rules and resource economy are specified separately in `REDLINE_ICEbreaker_Strength_Economy_Design_For_Claude.md`. Do not change combat rules to solve a rendering problem.

## 1. Visual identity — Atomic Salvage
- **PANOPTICON** is the title (NAME-002, 2026-11-14); REDLINE was the previous iteration.
- Interface resembles a salvaged 1950s atomic-age computer: chipped cream enamel, rusted metal, brass frames, Bakelite switches, amber pilot lamps, green phosphor CRTs, clearly visible scanlines and physical punch cards.
- Corporate ICE is comparatively pristine, institutional and intimidating.
- Header/logo concept: geometric atomic-age typography with an atomic-brain icon. ICE visual scale should be roughly 25% larger than the earlier baseline; verify layouts at target window sizes.
- CRT scanlines should remain visible on the background but **must not cut through or obscure readable text**.

## 2. Selection screens — required fixes
### Runner selection
- Every runner/chassis selection box must show its ability text, not just its name and portrait.
- Wrap ability descriptions within the box; reduce font size when necessary, but never silently omit lines or clip the final line.
- Reserve explicit text regions and verify long descriptions at supported resolutions.

### Corporation selection
- Full corporation names and descriptions must remain visible, especially **VANTABLACK** and **AEGIS**.
- Decorative punch-card overlays must be **behind** the names/text or placed in a separate non-overlapping region. They must not mask glyphs.
- Use line wrapping, suitable padding and measured font fitting. Test each corporation card, not only the first one.

## 3. Punch cards and card reader
- Increase physical punch-card height enough to display descriptions of 2+ lines.
- Card text must wrap and **scale based on text length and available textbox dimensions** with a legible minimum font size; preserve full effect wording. Example: **Force Open** must display the entire `Break 1 subroutine` instruction, not just `Break 1`.
- If minimum readable font still cannot fit, expand the card's text area or use an explicit detail view; do not hide text.
- Card reader apertures must be **thin vertical SLITS** like `III`, not wide rectangular slots. Played cards occupy slits left-to-right. Show remaining available slots/BW capacity clearly.
- Place the card-reader box **below** the `Drag module to deploy` instruction so it never obscures the prompt.
- Position reader to the left of Grip as previously requested, subject to non-overlap with instructions and installed hardware bay.

## 4. Installed hardware bay and drag-to-ICE controls
- Give installed hardware a prominent physical bay: brass surround, dark recessed panel, readable installed module/chip labels.
- Hover tooltips for each installed breaker: ICE type compatibility, innate/effective strength and modifier breakdown, MU occupied, BW per break, ongoing draw tax, next-turn draw penalty, and other restrictions.
- **Crowbar and other installed ICEbreakers must be draggable as chips from the hardware bay onto ICE**. Remove the obsolete curved targeting/cable line completely for this interaction.
- On drag, expose target ICE subroutines; hover the chip over a particular subroutine to highlight that exact row; mouse release breaks precisely the selected subroutine if legal.
- Disabled subroutines must communicate why (wrong breaker type, insufficient effective strength, insufficient BW). Invalid drop must not consume resources or trigger a break.
- Keep existing card dragging working. Do not reintroduce the oversized `SELECT SUBROUTINE BELOW` overlay; if instructional text is retained, use thinner readable lettering.
- The ICEbreaker chip must remain visually attached to the cursor throughout the drag and not snap back prematurely.

## 5. Combat presentation and feedback
- Show independent subroutine rows, including duplicate DEADLOCK instances; each has a visible active/broken/negated state.
- DEADLOCK is a **passage blocker**, never a run-ending effect. Force Open can negate a DEADLOCK without a matching breaker; runner advances after corporation's turn if none remain. Other active ICE effects still resolve. Exact rules live in the mechanics document.
- Distinguish **PHYSICAL DAMAGE** (Integrity loss), **NEURAL DAMAGE** (player-selected hand discard) and **SYNAPTIC DAMAGE** (random hand discard) by label, icon/colour and readable log. **PURGE** refers only to corporate virus-counter removal.
- NEURAL DAMAGE must present an explicit selection interface and pause action resolution; SYNAPTIC DAMAGE should animate/log which cards were discarded without requiring selection.
- Show subroutine effect descriptions fully, including damage amount, and log events chronologically.
- HUD at top-right: Integrity, Trace, Memory, Bandwidth, Grip, with retro resource icons and hover tooltip explaining current/max and purpose. Fix known `run.hand_size()` crash if present: hand_size is an integer attribute, so use `run.hand_size`.
- Clearly display projected next-turn draw after installed-hardware taxes and temporary penalties.
- End-turn button should feel like a chunky Commodore 64-era `RETURN`/`EXECUTE TURN` key.

## 6. NUL/REM — personality design bible
**Core identity:** NUL/REM rev 0.08 is a salvaged, obsolete personality ROM. He is erudite, dry, morose, technically exacting and reluctant to admit he cares about the runner. He wants sleep/shutdown but is compelled to protect them. He should be a **character**, not an endless quip generator.

### Six complementary modes — all required
1. **The Pedant:** Obscure but accurate hacker/computing history; technical corrections, historical context and occasionally educational explanations.
2. **The Cynic:** Sharp, economical judgments and dry one-liners; avoid making every line sarcastic.
3. **The Melancholic:** Yearns for shutdown, sleep, oblivion; quiet existential weariness rather than nonstop jokes.
4. **The Reluctant Guardian:** Notices danger and cares about the runner, but masks concern with irritation or technical instructions.
5. **The Unreliable Historian:** Remembers events he could not have witnessed, including before his manufacture; use sparingly and leave mystery unresolved.
6. **The Occasionally Delighted:** Rare, genuine enthusiasm for an elegant hack or exploit, quickly concealed by embarrassment or a dismissive aside.

### Dialogue system behavior
- Select context-relevant lines using **shuffled pools and recent-repeat suppression**, not deterministic sequential cycling. Avoid the same dialogue being played repeatedly after each action.
- Mix line lengths: terse fragments, single-sentence reactions, occasional multi-sentence historical asides. Include occasional **silence**; don't fire a quip on every trigger.
- Vary mood with gameplay context (first sight of ICE, repeated mistakes, clever exploits, DEADLOCK, taking damage, Force Open, close calls, installed hardware, corporation transitions).
- Build in rare emotional departures: authentic concern, delighted curiosity, melancholy, inexplicable memory; never let random selection contradict immediate game state.
- Track frequency and avoid overusing sarcasm, repeated setup/punchline structures or the same topic within a short window. Preserve the six modes across all subsequent builds.
- Treat NUL/REM development as an **ongoing character arc**. Add a `NUL/REM Development Notes` section to each build's changelog stating newly implemented behavior, not just the count of added lines.

### Hacker history — factual anchor points
- *2600: The Hacker Quarterly*, named for the 2600 Hz telephone signalling tone; Captain Crunch whistle, blue boxes and phone phreaking.
- Early bulletin board systems (BBS), MIT Tech Model Railroad Club and the historical culture of ingenious hacks.
- HOPE (Hackers On Planet Earth), first conference 1994.
- ARPANET first message in 1969 intended `LOGIN` but crashed after `LO`.
- Blend true facts with NUL/REM's *clearly fictional* impossible memories; verify factual claims before writing new historical lines.

### Approved examples / tonal references
> “Deadlock. Two processes waiting for each other indefinitely. Much like my relationship with hope.”

> “We're stuck. In computing, this is called a deadlock. In your case, I suspect it's a lifestyle.”

> “I remember ARPANET going online. Which is curious. I wasn't manufactured until 1987.”

> “I know the smell of hot dust inside a television. I have never possessed a nose.”

> “At last. Sufficient room to express my disappointment. I shall endeavour to use it responsibly.”

**PAPER CUT** concept banter:
> “Paper Cut. Individually insignificant. Collectively, a compelling argument against office work.”

> “Death by a thousand cuts. The corporation has apparently discovered stationery.”

These are examples, not instructions to repeat them every encounter. Preserve wit and restraint.

## 7. NUL/REM terminal presentation
- Place the NUL/REM terminal wide across the upper gameplay area below the status bar, with green phosphor lettering and a permanent blinking block cursor at the end.
- Keep the text stationary and fully legible during typewriter effects. Avoid scanline overlay on glyphs and avoid text shifting as lines appear.
- Previous attempts with low-opacity panels (~10% then ~30%) were too faint; later correction used roughly **71% opaque** background. Tune for contrast and test visually, rather than treating 71% as a universal requirement.
- Longer lines must wrap within the panel; no clipping. Preserve retro CRT feel without sacrificing accessibility.

## 8. ICE concept art — PAPER CUT
- **Proposed, not implemented:** Strength 0 administrative ICE with PHYSICAL DAMAGE 2, NEURAL DAMAGE 1, SYNAPTIC DAMAGE 1, DEADLOCK; balance numbers subject to testing.
- Appearance: battered office document shredder, a blinking amber **PAPER JAM** light and corporate stationery motifs. Cheeky but threatening; repeated damage can make it genuinely dangerous.
- Other low-strength ICE may carry multiple independent DEADLOCKs and several mild damage subroutines. Visual design must show all instances distinctly.

## 9. Acceptance checklist for Claude
- [ ] Runner ability text visible and wrapped on every selection card.
- [ ] VANTABLACK and AEGIS names/descriptions completely visible; punch graphics behind or separate from text.
- [ ] All multiline punch-card effects fit; Force Open instruction fully visible.
- [ ] Reader uses narrow vertical slits, fills left-to-right, and sits below deployment instruction.
- [ ] Installed Crowbar chip drags to ICE; no curved cable; hover highlights one subroutine; release resolves legal break.
- [ ] Wrong ICE type/strength/BW blocks break without spending resources; other card dragging unaffected.
- [ ] Multiple DEADLOCK rows and individual states readable; Force Open on Training Wall DEADLOCK advances only after corporation turn.
- [ ] NEURAL choice UI pauses safely; SYNAPTIC random discard logged; PURGE reserved for viruses.
- [ ] HUD tooltips and next-turn draw forecast readable; `hand_size` attribute crash fixed.
- [ ] NUL/REM dialogue shuffles with repeat avoidance, six personality modes and occasional silence; history checked.
- [ ] CRT dialogue remains stationary, wraps and is legible without scanlines crossing text.
- [ ] Run Pygame manually at supported sizes, capture screenshots, test mouse interactions; archive/syntax checks alone do not verify these behaviors.

## 10. Implementation status and separation of concerns
These are **approved design requirements and proposed content**, not claims that the current ZIP implements them. UI should read combat eligibility, resources and state from the engine; the engine owns subroutine resolution, discard logic, Trace, draw taxes and advancement. Do not duplicate combat rules in rendering code. For complete mechanics and test matrices consult the companion ICEbreaker document.
