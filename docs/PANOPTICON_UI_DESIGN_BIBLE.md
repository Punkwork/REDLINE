# PANOPTICON — UI Design Bible

**Visually rich but informationally restrained.**

PANOPTICON's interface should express the craftsmanship, personality and material richness of Atomic Deco Punk while presenting gameplay information with clarity, economy and elegance. Artistic complexity must never create unnecessary informational complexity.

**UI-BIBLE-001 — designer direction, 2026-11-24.** Consolidation of existing UI specifications; no gameplay or implementation changes. The Master Design remains the decision register and Core Rules remains the mechanical authority.

## 1. Governing principles
- Iconography before typography where the symbol is recognizable; retain essential values and states.
- Progressive disclosure: essential information at a glance, explanation on hover or focus.
- One visual vocabulary; distinguish by shape as well as colour.
- Diegetic integration: indicators belong to the physical Console.
- Readability is inviolable: contrast at least 4.5:1; no decoration across rules, costs, numbers or controls.
- Design for accumulation without sacrificing legibility.
- Consolidation first: extend this specification rather than creating new permanent UI briefs.

## 1a. UI proposal governance and component register (UI-WORKFLOW-001)

**UI-WORKFLOW-001 (designer-approved, 2026-11-24):** GitHub Issues are the single authoritative UI proposal and development register for Claude Code, Claude, Codex and ChatGPT. Use stable component IDs from the UI Design Bible. Keep proposal discussion, mockup links, acceptance criteria, designer approval, implementation links and validation evidence in the issue; do not duplicate the backlog in HANDOFF or separate agent files. Only the designer approves; record approved decisions in Master Design and update the UI Design Bible as applicable. Development Log records actual work and links to the issue. Daily operations review uses the same issues. No code or rules changes.

### Stable component IDs

| Component ID | Interface component |
|---|---|
| UI-HDR | Header and global indicators |
| UI-GHW | Ghostware rail |
| UI-VIT | Resource indicators |
| UI-PRG | Installed Programs |
| UI-ICE | ICE consoles and mascots |
| UI-SUB | Subroutine instrument keys |
| UI-RSP | Corporation Response |
| UI-CAP | CAP rack |
| UI-CRD | Card design |
| UI-HND | Hand and card arrangement |
| UI-HOV | Hover and inspection |
| UI-CTL | Action controls |
| UI-NUL | NUL/REM presentation |
| UI-MAP | Network map |
| UI-FRM | Interface framing and materials |

IDs identify components, not proposals. Use the native GitHub issue number as the unique proposal identifier; include one or more component IDs in the issue title or body. Example: `[UI-VIT] Icon-first resource indicators`. Reuse IDs across iterations; do not renumber or recycle them. Extend this register when a new component is agreed.

**Governing UI principle (ARCH-V2-003, designer 2026-11-26):** *Icons communicate. Numbers quantify. Hover panels explain. Typography announces.* VAS-001 is the compositional reference; V1 Build 12 (ICE-ANALOG-001) is the interaction reference for UI-SUB, whose keys stay horizontal illuminated controls, never text rows. UI-ICE panels have four zones (identity, virtual expression, tactical controls, persistent status), with the type icon on the portrait's upper-left corner and STR on the nameplate's upper-right corner; use **VOID ICE**, never "Sentry". UI-RSP is one shared NEXT RESPONSE rail (provisional). Announcements: **RUSTLER TURN**, **CORP COUNTERMEASURE**. Full record: [Master Design ARCH-V2-003](REDLINE_MASTER_DESIGN.md#arch-v2-003--batch-1-representative-ice-encounter-components-and-ui-alignment-requirements-approved-in-principle-2026-11-26).

### Issue workflow

Proposed → Design exploration → Designer review → Approved → In development → Validation → Complete. Rejected or superseded proposals retain their history and are closed with a reason. Each issue records component IDs, problem, proposed change, relevant Bible sections/decision IDs, mockup links and revisions, acceptance criteria, approval evidence, implementation commit/PR and validation evidence. Search existing issues before opening a new one. No implementation before designer approval. Store mockup assets in the existing visual asset directories and link them from the issue. Use issue comments for revisions; close only after validation or an explicit disposition. GitHub Projects and labels may provide views of the same issues, never a second backlog.

## 2. Current encounter direction and precedence
ENC-CONCEPT-001 supersedes the earlier flip-clock layout; ICE-ANALOG-001 icon keys and HOVER-001 remain applicable. Later Master Design decisions override historical specifications below. The supplied November 24 mockup is illustrative, not a rules source.
- Ghostware: persistent top rail, ORIGIN first with gold rim, acquired badges follow; hover/focus name and effect with high-resolution art. The old below-RETURN placement is superseded. Existing shrink-to-fit rule remains until reviewed; minimum size and overflow behavior are open. Show the first Ghostware in the next design mockup.
- Resource HUD: designer direction today is icon-first Vitae, Bandwidth, RAM, Shield and incoming PULP, with values/meters visible and explanatory labels on hover/focus. Exact glyphs and layout remain open.
- CAPS: three slots beside the hand. No change to mechanics.
- Keep full textual response/passive previews where required by ICE-ANALOG-001.
- No implementation status is inferred from this consolidation.

## 2a. Typography and the dual visual language (UI-TYPO-001, APPROVED 2026-11-25)

Two distinct visual representations (designer, 2026-11-25; full wording in Master Design UI-TYPO-001):
- **Physical world, the UI:** 1950s Deco and Atomic Deco Punk. Bakelite and Formica, panels, knobs and switches, with a small CRT display.
- **Virtual world:** a hyper-kinetic title flourish in the manner of Gaspar Noé's title sequences, full of motion and electric colour.

Readability, reduced motion and the copy guards still govern both. **Flyout exception (UI-TYPO-001a, 2026-11-25):** event flyouts may pass over screen elements, including rule text, numbers and buttons, for no more than 1–2 seconds and without hiding anything: what's underneath stays readable through the flyout (see-through or offset from key values), and nothing is removed while it shows (confirmed 2026-11-25). No other effect gets this exception. Confirmed: the physical style covers the console, HUD, cards and controls; the small CRT is the console's existing CRT. Fonts, glyphs and the boundary between the two on each screen are open: see [#24](https://github.com/Punkwork/REDLINE/issues/24). Reference images: [`visual/references/ui-typo-001/`](visual/references/ui-typo-001/README.md). They show the virtual world as event flyout titles over the unchanged console; the refined treatment (02) suits frequent events. Style only: their SYN, Neural-damage and extraction-bonus labels predate current rules.

### Typography and motion exploration constraints (UI-TYPO-001 / UI-TYPO-001a)

**Designer-approved exploration direction.** Typography is a first-class expressive part of PANOPTICON. Keep the tactile, persistent console visually stable and use transient digital typography for rhythm, tension and emphasis. Use the four existing mockups as the principal style references. Use the refined treatment for frequent events and reserve the aggressive treatment for exceptional moments. Event significance governs scale, composition, motion complexity and duration.

| Tier | Purpose | Treatment |
|---|---|---|
| 1 · Cinematic | Major transitions, critical threats and significant accomplishments | Large, layered title composition, with expressive illustration where useful |
| 2 · Phase | Rustler turn, Corporation Response and recurring encounter transitions | Consistent, immediately recognizable flyouts with a brief readable hold |
| 3 · Mechanical | Damage, resources, program installation and ICE strength or state changes | Localized feedback anchored to the affected component |
| 4 · Micro | Small numerical changes and routine indicator updates | In-place deltas, lamp pulses, icon illumination or counter movement |

- Give event families recognizable movement. Prototype opposing directional sweeps for Rustler and Corporation phase announcements, a compact impact/reveal for breach, and localized motion for component feedback. Explore enter, reveal, hold and exit, with stable legible text during the hold.
- Define semantic colour roles and reinforce them with text, iconography, composition and motion. Candidate roles are cyan for Rustler agency, vermilion for corporate authority, magenta for disruption, gold for achievement, green for restoration or functionality, violet for experimental psychological expression, and warm ivory for primary text.
- Use non-destructive overlays driven by visible engine events. Keep text and numerical values live. Compose typography, illustrations, textures and effects independently. Prioritize or consolidate overlapping events and keep presentation from needlessly delaying play or changing gameplay order.
- Preserve 4.5:1 contrast, copy guards and access to essential information. Apply the UI-TYPO-001a overlap exception only to flyouts and keep underlying information readable and in place throughout. Provide reduced-motion and reduced-flash treatments that preserve the same information and outcomes.
- Explore kinetic announcements, localized feedback, corporate propaganda for introductions, and achievement treatments for extraction, Ghostware and CAPS. Psychological typography for NUL/REM, surveillance and loss of autonomy remains experimental. The study of a progressively institutional typographic voice carries no approved mechanic, progression trigger or production requirement.

**For design and validation:** exact typefaces, glyphs, scale, palette values, motion direction, timing, easing and per-component contracts require review. All example timings and mockup copy are study inputs subject to current rules and the flyout exception. See the [Typography & Motion milestone](REDLINE_MASTER_DESIGN.md#typography--motion-design-system-milestone-m06--priority-1-companion) and [issue #24](https://github.com/Punkwork/REDLINE/issues/24). The approved event treatments are in §2b.

### Physical typography selection (UI-TYPO-001 / M06, 2026-11-27)

**DESIGN-APPROVED — Atomic Deco (option A); Jost selected as the primary physical interface typeface.** Industrial and Hybrid are no longer active exploration candidates. Use geometric lettering, restrained ornament, expanded heading tracking and normal body tracking; lettering should feel manufactured into the console. Preserve icon-first HUD and readability requirements. Jost is distributed under the SIL Open Font License; retain the upstream copyright and license notice with distributed font assets. Proposed starting weights (not final acceptance): panel headings 300, instrument labels and mechanical descriptions 400, resource numerals and inspector titles 500, critical information 600. Exact sizes, tracking, weights and contrast require representative Godot/inspector validation. Virtual-world typography remains a separate design system. This selection supersedes earlier physical typography exploration candidates, not existing corporation-specific display or narrative treatments. Track delivery in [issue #24](https://github.com/Punkwork/REDLINE/issues/24). No font assets or code changed by this decision.

### Bandwidth transition design acceptance (UI-TYPO-001 / M06, 2026-11-27)

**DESIGN-APPROVED — designer confirmed 2026-11-27.** Bandwidth (BW) transitions follow the approved universal motion language. Use symbols, numbers and mathematical notation only in transient resource feedback; no explanatory words (including BLOCKED). The persistent physical BW indicator remains authoritative. No further BW visual exploration before the next build. Expenditure, gain, turn replenishment, rapid successive changes and insufficient-BW rejection are implementation and playtest cases, not open design tasks. Bind presentation to authoritative engine events without changing rules or delaying gameplay; reduced-motion and reduced-flash alternatives must preserve information. Implementation, accessibility validation and playtest acceptance remain pending; exact integration timings are not newly prescribed by this approval. Existing readability guards remain in force. Track delivery in [issue #24](https://github.com/Punkwork/REDLINE/issues/24).

## 2b. Event typography and motion treatments (UI-TYPO-002, M06, APPROVED 2026-11-27)

**Current specification** (components UI-RSP and UI-ICE; [issue #24](https://github.com/Punkwork/REDLINE/issues/24)). The designer approved these eight treatments on 2026-11-27 (decision record: Master Design UI-TYPO-002). This section is their single current definition. It supersedes the provisional single-band treatment, the ≤ 1.5 s flyout timing of ARCH-V2-006f, and LETHAL as a global banner (ARCH-V2-006j). The wording was approved earlier (ARCH-V2-006f/j). Implementation values live once, as presentation tokens in `godot/scripts/ui/architecture_v2/vas_tokens.gd` (`FLYOUT`, `LETHAL_LENS`): timing per phase, type, colour, scale and easing. **Every timing is an initial playtest target.** Tune it there; don't restate it elsewhere.

| Event (trigger) | Treatment | Target |
|---|---|---|
| **RUSTLER TURN** (Rustler turn starts) | **Kinetic Sweep:** condensed, forward-leaning type in warm ivory and cyan. Sweeps left to right with subtle directional momentum. | 1,300 ms |
| **CORP COUNTERMEASURE** (Corporation Response starts) | **Institutional Transmission (B2):** a smaller, widely spaced vermilion CORP above a dominant, heavy, upright ivory COUNTERMEASURE, between horizontal rules. Irregular signal acquisition, a stable readable hold and an electronic fizzle exit. | 1,300 ms |
| **DEADLOCK BREACHED** (EV-07) | **Kinetic Breakthrough:** DEADLOCK enters from the right and BREACHED from the left. Four principal cyan lines accelerate outward towards the screen edges, and contrasting amber and vermilion lines travel inward. | 1,500 ms |
| **LOCKDOWN** (EV-16, third strike) | **Surveillance Convergence (L3):** concentric rectangular red frames contract inward around a deep crimson panel holding heavy, upright ivory type. A stable assertion, then electronic extinguishment. | 1,700 ms |
| **MASK OFF** (EV-15, second strike) | **Masked Revelation:** oversized negative-space type reveals the Corporation's actual artwork through the letterforms. The mask then withdraws to show the complete image briefly before the encounter returns. | 1,700 ms |
| **LETHAL** (an ICE turns LETHAL) | **Cold Recognition:** on the affected ICE only. A red optical lens inspired by HAL 9000, restrained thin uppercase type and unnerving stillness. It stays while the ICE is LETHAL. **No global announcement.** | Persists |
| **PARTING SHOT** (parting shot with at least one subroutine firing) | **Corner Slingshot:** staggered, ascending diagonal type at 85% of the original proposed scale. A curved entry from the screen corner, a readable hold at the apex, then a rapid, accelerating retraction with a simultaneous fade. | 1,150 ms |
| **RESERVE EXTRACTED** (EV-09) | **Atomic Ascension:** turquoise Atomic Age orbital trails swirl around the type and progressively light EXTRACTED in luminous gold, in step with the CRED reward feedback. | 1,700 ms |

**Constraints for every treatment**
- Art Deco and Atomic Age geometry (paired rules, concentric frames, orbits) carries aggressive, modern virtual type. The physical console stays stable underneath.
- Each run stays inside the UI-TYPO-001a flyout exception (1–2 s). Every filled area is translucent and type is outlined, so what's under it stays readable and nothing is removed. Flyouts never take input.
- LETHAL's lens is not a flyout, so ADP-R1 applies in full: it sits in the portrait zone and never crosses keys, plates, numbers or rule text.
- One event at a time: arrivals queue (at most three, oldest first) and duplicates are dropped. The Corporation Response still waits for CORP COUNTERMEASURE, MASK OFF and LOCKDOWN. Presentation never changes gameplay, triggers, resolution order or resource calculations.
- **Reduced motion:** a plain fade in place over the same duration, with the same information and no travel, scale, flicker or orbit. EXTRACTED shows fully gold. MASK OFF fades from its letters to the complete image. The LETHAL lens appears at once.
- **No hazardous flashing:** at most three flashes in any second. CORP COUNTERMEASURE's signal acquisition steps between partial levels, never a full-contrast strobe.
- Existing ICE state-change, card interaction and subroutine animations are kept. On a LETHAL ICE, the MOOD-PIXEL pulse continues alongside the lens.
- Experimental CHAIN feedback is out of scope (CHAIN-PARK-001).

**Implementation choices (UI-TYPO-002a, designer approved as is 2026-11-27 23:36)**
1. MASK OFF's "actual Corporation artwork" is that corporation's HOSTILE room (`BG_<CORP>_HOSTILE.png`, the face behind the friendly mask). To keep the console readable, the veil, the art in the letters and the complete image are at most 55% opaque, so the full image appears see-through, not solid.
2. LOCKDOWN's padlock glyph and DEADLOCK BREACHED's open-lock glyph from the provisional treatment were dropped: L3 and Kinetic Breakthrough don't include them.
3. DEADLOCK BREACHED and RESERVE EXTRACTED sit on a translucent band behind the type, for legibility. The approved descriptions don't mention a band.
4. The LETHAL lens shows for the rules' LETHAL state only, not for Black ICE's look-only LETHAL form, which never deals double. LETHAL also loses its red screen wash, as that is a global announcement too.
5. RESERVE EXTRACTED's gold completes as the CRED readout lands on its new value (the ledger's 0.9 s count-up and 0.45 s settle). If the flyout waits in the queue, a CRED count still in progress restarts with it; one that has already landed isn't replayed.
6. RUSTLER TURN keeps the 76 px provisional scale, and PARTING SHOT is 85% of it (65 px).

## 3. Existing Master Design UI decisions (extract)
**CARDS-003 — PCB glow cartridges (APPROVED, 2026-11-19).** Supersedes the CARDS-002 palette table above and its rarity finishes, ivory print and amber-on-field numbers. Designer: "Go with this dark panel tint for now it works. Yes i want these stencil designs. Commit these changes to the cards for godot." It was reviewed in 17 iterations on the `review/cards-002` branch, which is never merged.

**CARDS-004 — Larger cards (APPROVED, 2026-11-19).** Designer: "The cards in general should be larger, 16 bit or not." After an encounter mockup, the designer chose **1.4×**: cards become 230 × 342, and rules text about 13–15 px. Designer: "Have the cards slightly overlap based on the number of cards." **Hand (designer, 2026-11-19):** "I would rather they start to slightly overlap instead of squash them together so the sides aren't visible, and them overlap more as more cards in hand." "Gentle fan is perfect." The hand is centred and overlaps slightly from the start, with more overlap as it grows. **Fan values (APPROVED, designer 2026-11-19: "Yes to the fanned cards"):** 5% overlap at 1–4 cards, then 8% at 5, 10% at 6, 18% at 7, 26% at 8, 35% at 9 and 43% at 10, the maximum. A **gentle fan** spreads 20° across the whole hand, at most 4° between neighbours, so the overlap gathers at the bottoms and the top corners stay readable. A hovered card rises 36 px above its neighbours. To make room:

**CARDS-005 — Corner icons (APPROVED, 2026-11-19).** Designer: "We need to utilize the top right corner for icons… Yes i want all of them in the right corner." Small dark plates (`#253237`, like the BW dial) stack down the card's top-right corner, most important first:

**CARDS-005a — hardware styling and BLOATWARE (APPROVED, 2026-11-19).** Designer: "make them look like part of the hardware of the card. Right now they look very much out of place." The flat plates become **round indicators in the BW dial's style**: a pale steel bezel, a dark face and a glowing glyph with a glass glint. They are mounted on a brushed-steel rail screwed to the chassis. **BLOATWARE** (designer: "Yes") gets two icons:

**ICE-ANALOG-001 — Iconized ICE subroutine readout and livelier mascots (APPROVED for integration, 2026-11-19).** Designer: redesign the ICE readout, not the mascots; mascots "a little bigger" with "more behavior"; subroutines become icons with a value ("You don't have to use the word deadlock. You can use an image"), with "the text of that subroutine when you roll over the subroutine icon itself"; elegant but "adequately display the information that's necessary". Approved for the default encounters (same approval as ENC-ANALOG-001), **including full subroutine text on hover/focus only** (designer, in session: "Yes, approved, incl. hover text"). This amends VIS-001 §2.9: the ICE shows icon + value; the full rule is in the hover/focus tooltip; the NEXT RESPONSE strip and the passive strip keep full text. Brief: `REDLINE_ENCOUNTER_ANALOG.md` §8. Codex's standalone wireframe fixture (`ice_analog_visual.gd`) is replaced by the real integration (designer: "Replace it"). *Not built yet.*

**ENC-CONCEPT-001 — The encounter interface follows the three concept screenshots (APPROVED direction, 2026-11-19).** Designer: "I want the interface to be based entirely on the mockups / screenshots I gave you. I want those to be the new interface, and we'll figure out the background for each corp." References: `docs/visual/explorations/ice-analog-001/ICE_ANALOG_CONCEPT_01–03`. Which concept supplies what (designer, in session):

- **Interface (frame, top bar, ICE consoles, keys, TUMBLER reel, tooltip, END TURN): concept 3.** "I want you to use the interface look from screenshot 3."

- **Cards: concept 2's look** (clarified by the designer, 2026-11-19: "each card is essentially a little bit smaller. They're all white. They have bright colors on them… just essentially the word on the card, the name of the card, a little image"; "I'd rather ChatGPT create the look"): smaller white cards with the name and a small bright picture; rules on hover. The CARDS-004 **fan** stays as the way a crowded hand fits: more cards overlap more and tilt at a set angle (designer: "Use the fan… to fan out the cards when there are too many cards on the screen, to fan them out at a certain angle and in a certain proximity to each other card"). Frames and pictures from ChatGPT (`ART_BRIEFS.md` §3). Earlier note: "Make a mix of both, use the fan, icons on cards and mix it with this graphic style"; "use the card look from screenshot 2". Changes the CARDS-001 face art; CARDS-004 fan/size and CARDS-005 icons stay.

- **Left HUD: a mix of concepts 2 and 3, closer to 2, with more icons** ("More icons, but more like screenshot 2"). Installed Programs live **inside the left CRT panel** (designer).

- **Painted interface (designer, 2026-11-19: "write a brief for the painted interface parts… I want that design from those 3 screenshots from ChatGPT implemented"):** the console, key caps, top bar, CRT, vitals, END TURN, tooltip, frame and backdrop are painted in ChatGPT as separate parts (`docs/visual/concept-art/UI_KIT_BRIEF.md`) and assembled by the game, which draws all text, numbers and live states on top.

- **CAPS and Ghostware on the encounter screen (2026-11-20; designer: "account for caps… placeholder caps. We need a minimum of 3… space for an unlimited number of ghostware… hovering over the interface… along the very top… roll over them to see what the ghostware is"):** a CAP rack with 3 empty slots sits in the hand tray right of the hand (UPL caps rules: "beside your hand"); the hand area is 80 px narrower. Ghostware hang as round badges from the pipe along the top of the ICE area, ORIGIN first with a gold rim, then the run's other Ghostware, any number, shrinking to fit one row; hover or focus shows the name and effect. Placeholders (initials, glass tubes) until the icons arrive. Positions confirmed by the designer 2026-11-20 ("I like both positions").

**CARD-CONTROLS-001 — PROGRAM bay and card inspection (APPROVED, 2026-11-17):** Install PROGRAM cards by dragging them into the PCI-style bay on the left HUD. Installed Programs appear there for hover and click inspection and retain their controls. Drop a targeted SCRIPT on eligible ICE, or an untargeted SCRIPT on the upper half of the encounter. Right-click enlarges a card to 150% and right-click again closes the preview.

## 4. Consolidated source specifications

### Navigation to imported specifications

- [VIS-001 — Visual language](#source-1-docsredline_visual_languagemd)
- [ENC/ICE-ANALOG-001 — Encounter and ICE](#source-2-docsredline_encounter_analogmd)
- [Legacy UI and NUL/REM](#source-3-docsredline_ui_nulrem_design_for_claudemd)
- [ADP-001 — Atomic Deco Punk](#source-4-docsredline_atomic_deco_punkmd)
- [Painted UI kit 1](#source-5-docsvisualconcept-artui_kit_briefmd)
- [Painted UI kit 2](#source-6-docsvisualconcept-artui_kit_brief_2md)
- [Painted UI kit 3](#source-7-docsvisualconcept-artui_kit_brief_3md)

**Source documents retired (UI-BIBLE-001, DOCS-MIG-001 gate, 2026-11-25).** The seven sources below were imported unchanged and the originals removed from the active tree. Each heading links to the last version of the original file (commit `8ef0bbe`); git history keeps every earlier version. Mentions of the old file names inside the imported text refer to these sections:

| Retired path | Now | Notes |
|---|---|---|
| `docs/REDLINE_VISUAL_LANGUAGE.md` | Source 1 | VIS-001. §2.9 amended by ICE-ANALOG-001. |
| `docs/REDLINE_ENCOUNTER_ANALOG.md` | Source 2 | ENC-ANALOG-001; its flip-clock HUD is superseded by ENC-CONCEPT-001 (§2 above). |
| `docs/REDLINE_UI_NULREM_Design_For_Claude.md` | Source 3 | Pre-redesign; not current for rules (DOCS-001). Atomic Salvage look deprecated by VIS-001. §6 (NUL/REM personality) relocated to [Dialogue Architecture, Appendix A](PANOPTICON_NULREM_DIALOGUE_ARCHITECTURE.md#appendix-a--legacy-nulrem-personality-design-bible-relocated-by-ui-bible-001). |
| `docs/REDLINE_ATOMIC_DECO_PUNK.md` | Source 4 | ADP-001, ZINE-001/002, SIGNAL-001 presentation. |
| `docs/visual/concept-art/UI_KIT_BRIEF.md` | Source 5 | ENC-CONCEPT-001 painted UI kit 1 (ChatGPT prompts; history). |
| `docs/visual/concept-art/UI_KIT_BRIEF_2.md` | Source 6 | Painted UI kit 2. |
| `docs/visual/concept-art/UI_KIT_BRIEF_3.md` | Source 7 | Painted UI kit 3. |

**Editorial reconciliation.** Where an imported section disagrees with a later decision, the later decision wins (§2, §3 and the Master Design). The known supersessions are: Source 3's damage types, terms and screens (PHYSICAL/NEURAL/SYNAPTIC damage, Integrity, VANTABLACK/AEGIS, Pygame) predate the Core Rules redesign; Source 3's look and Source 1's mood table are replaced or amended as noted above; Source 2's HUD by ENC-CONCEPT-001; the old Ghostware placement by the top rail (§2). Codex prompts and "Repo … on main" lines inside imports are historical; current working instructions are in `AGENTS.md`. No genuine design conflict was found that needs a designer decision.

The following imported sections preserve source wording and decision IDs for lossless migration. Historical layouts, proposed values, prompts and implementation notes are not new approvals. Relative links inside them resolve from this file. Do not maintain parallel new UI specifications.


---

## Source 1: [docs/REDLINE_VISUAL_LANGUAGE.md](https://github.com/Punkwork/REDLINE/blob/8ef0bbe15ccd7eb7cf44f3ca8aaf98c910ee41c7/docs/REDLINE_VISUAL_LANGUAGE.md)

# PANOPTICON — VISUAL LANGUAGE: THE FRIENDLY LIE
**Version:** 0.1 · **Date:** 2026-11-17 · **Author:** Claude · **Decision ID:** VIS-001
**Status:** Direction **B, "The Friendly Lie", chosen by the designer** on 2026-11-17 (in session: *"I do really like the B option the friendly lie … I think this is a more suitable direction"*). The rules, colors and copy below are **working values for a playtest prototype**; the designer may still change any of them.
**For:** Codex (Godot build, `godot/`). **Assets:** `docs/visual/` (reference images, placeholder backgrounds, mascot SVGs).

This file has two parts:
- **Part 1 — The brief.** The tasks exactly as the designer gave them, in order. Use Part 1 alone to explore the direction on your own.
- **Part 2 — The design produced so far.** What Claude made for each task: the rules, values and copy to build from. Part 3 says what to build in Godot and how to check it.

---

## Part 1 — The brief (tasks as given)

Context: PANOPTICON is a cyberpunk deck-builder. Rustlers (hackers) and their AI NUL/REM break into three corporations: **HALCYON** (smart home), **IRONWATCH** (private security), **LUCIDA** (neural wellness). Each corporation's defences are **ICE**. The rules are in `REDLINE_CORE_RULES.md`; the HALCYON ICE are in `REDLINE_ICE_CORP1.md` §5.0.

Three directions were explored: A *Phosphor* (amber terminal), **B *The Friendly Lie*** (corporations look like soft, pastel consumer apps; the ICE are their UI: cookie banners, consent forms, CAPTCHAs; the Rustler is a photocopied zine taped over it), C *Watchtower* (brutalist). **B was chosen.** Then the designer asked for:

1. **One encounter screen per corporation**, each with an appropriate background with its own personality and color palette.
2. **Correct hand size:** Rustlers draw **6 cards** a turn. A maximum hand size hasn't been decided yet.
3. **Show how the friendly face breaks**, and what full TRACE looks like.
4. **Give the ICE a living, breathing personality.** Animation will go a long way, but even in still images the ICE didn't look distinct from each other, or have a personality that flips from cheery and bright to lethal and angry.
5. **Put that into the encounter screen.**

Each result had to be viewable as images on the designer's phone (PNG), alongside the editable design.

---

## Part 2 — The design produced

Reference images are in `docs/visual/reference/`. They were made at **1600 × 1000** (exported at 1.5×); every px value below uses that frame.

### 2.1 The core idea

| Layer | Who it belongs to | Look |
|---|---|---|
| **The corporation** | Background, ICE mascots, corporate Bloatware | A soft, friendly consumer app: pastel, rounded, **DM Sans**, cheerful wording |
| **The Rustler** | Hand, HUD, TRACE meter, Node tag, NUL/REM, every rules readout | A photocopied zine taped over the app: black toner, off-white paper, highlighter yellow, **Space Mono**, hard shadows, slight rotations |

**Rule 1 — Your side never changes.** The Rustler layer looks the same in every corporation and every state, friendly or hostile. Only the corporation's world changes around you. *(Amended 2026-11-17, RUSTLER-LOOK-001 in the master design doc: the cards are now 1950s salvaged hardware (CARDS-001) while the HUD stays zine, on purpose. The HUD will probably change later; keep it as is until the designer decides.)*
**Rule 2 — The rules are always in zine style.** Every subroutine's effect (PULP 2, DISCARD 1, DEADLOCK, ? HIDDEN) is printed as a black-and-yellow zine chip, however the ICE looks or what it says. The friendly wording is flavour; the chip is the rule.
**Rule 3 — The DEADLOCK is always the corporation's friendly button** ("Keep my plan", "I'm not a robot", "Check in", "Begin"). NUL/REM's line: *"the button is the lock. break it."* While BOOTING applies, the button shows a lock until the 3rd turn.

### 2.2 Colors and type

**Rustler (constant everywhere)**

| Token | Hex | Use |
|---|---|---|
| Toner | `#111111` | Card headers, HUD, tags, borders |
| Paper | `#F7F7F2` | Card body, light text on toner |
| Highlighter | `#E4FF3A` | Costs, BW, END TURN, rule chips, NUL/REM text |
| Strike red | `#E5484D` | TRACE fill, warnings, TRACE costs |
| Rule grey | `#3A3A3A` / `#A9A9A0` | Dividers / small labels on toner |

Font: **Space Mono** 400/700 (Google Fonts, OFL).

**Corporations (DM Sans 400/500/700, OFL)**

| Corp | App | Ground | Accent | Deep / text accent | Extra | Ink |
|---|---|---|---|---|---|---|
| HALCYON | *halcyon home* | `#EAF4F0` | Mint `#7FD8BE` | `#17785F` | Peach `#FFE3D3`, trust blue `#C9D7FF` | `#1B2230` |
| IRONWATCH | *IRONWATCH SafeStreets* | `#E8EEF6` | Badge gold `#F2C14E` | Navy `#1F3A5F` | Map `#DCE6F2` | `#14243A` |
| LUCIDA | *lucida rest* | `#EFE9FA` | Lilac `#C9B6F2` | `#4B3B7A` | Peach `#FFD9C7` | `#2E2350` |

Muted corporate text `#4A5568` / `#5B6573`; row borders `#D5DCE5`. Corner radius per corp: HALCYON 24, IRONWATCH 14 (with a navy header bar "IRONWATCH · VISITOR SERVICES"), LUCIDA 32.

**Moods (all corporations)**

| Mood | Accent | Ground tint | Text |
|---|---|---|---|
| Cheery | Corp accent | Corp ground | Corp ink |
| Wary | Amber `#E8B04A` | `#F3EEDF` | Corp ink |
| Lethal | Red `#E5484D` | `#140809` (Black ICE `#0B0405`) | `#F6E7E7`, muted `#C9A3A5` |

Hostile HALCYON background ground: `#14070A`.

### 2.3 The corporation backgrounds (task 1)

> **2026-11-17:** HALCYON's blurred-app placeholder was replaced by the Chrome Deco atrium (CHROME-001, approved). The Raygun Gothic facades for IRONWATCH and LUCIDA, with their interface voice and ICE appliances, are in `REDLINE_CORPORATE_FACADES.md` (FACADE-001, APPROVED 2026-11-17). The placeholders below stay until that art is generated and built.

Each background is the corporation's **own cheerful app, blurred** (about 5 px blur, 75% opacity) behind the encounter, so the fight happens inside its product. Placeholders are in `docs/visual/backgrounds/` (2400 × 1500 JPG); final art can replace them later.

| Corp | Headline | Tiles | References |
|---|---|---|---|
| HALCYON | "Good morning." | Living room 21°, front door Locked, doorbell cam "No visitors today", energy bars, lights 6 on, "Everyone is home" | `01` |
| IRONWATCH | "Your block is safe." | Neighbourhood map with patrol route and pins, safety score 98%, officers nearby 4, "See something? Say something." | `02` |
| LUCIDA | "Breathe in." | Breathing circle, sleep score 92, mood Calm, "Tonight's dream: Ocean", thoughts-shared bars, "We remember, so you don't have to." | `03` |
| HALCYON hostile | "We see you." | Same tiles turned hostile: 31° "Do not adjust", front door "Doors will not open", doorbell cam "1 VISITOR: YOU", lights ALL ON "Stay where we can see you", "Someone is home · 1 intruder" | `05`, `06` |

### 2.4 The encounter screen layout (tasks 1–2)

At 1600 × 1000, padding 32 / 40:

| Area | Position | Contents |
|---|---|---|
| Node tag | Top left, rotated −1.5° | Toner box "NODE: CAPTCHA" (Space Mono 28–30 bold) + highlighter strip "HALCYON · TIER 1 · LAYER 1/1 · TURN n" |
| TRACE tag | Top right, rotated +1° | Toner box: TRACE bar (300 px, red fill, white tick at 50%), "n/40", STRIKES pips (3 red squares, filled per strike) or CRED |
| ICE zone | Centre | One block per ICE, left to right as in the rules (main ICE right-most) — see §2.6 |
| Response strip | Under the ICE | Paper box with toner border: "NEXT RESPONSE ▸ PULP 1 · PULP 2 · …" (the biggest hit in a red chip) + a NUL/REM note (toner, highlighter text, rotated −1°) |
| HUD | Bottom left, 200–210 wide | Toner stack: BW (highlighter), VITAE, SHIELD, NEXT DRAW |
| Hand | Bottom centre | **6 cards**, 146 × 218, gap 12, each rotated between −2° and +2°, hard shadow `5px 5px 0 #111111` |
| Deck / END TURN | Bottom right, 200–210 wide | Paper box "DECK n · DISCARD n"; END TURN in highlighter with toner border and hard shadow |

**Also on the encounter screen (existing UI, restyled in the zine look — see §2.10):**

| Element | Working placement |
|---|---|
| **RIG** (installed Programs, Icepicks, Extractors) and **RACK** (Protocols) | A taped zine strip above the hand, left of centre: one toner chip per installed card (name, STR, boost/break cost). Icepick chips stay **draggable onto the ICE** (UI doc §4); the scan-tag chip under the cursor is the drop target and highlights. |
| BW as card-reader slits | The BW row of the HUD shows one highlighter cell per BW (■■■□), filling left to right as BW is spent (UI doc §3). |
| CRED reserve (UI-002) | A small line in the TRACE tag or under the ICE zone: "RESERVE 9/15"; 0 in red. |
| END RUN (RUN-001) | A small red zine button under END TURN, with the existing confirmation. |
| TUMBLER reels (REEL-001) | The slot rows of a TUMBLER mascot spin as reels with the existing timings; the scan tag updates when they stop. |
| Tooltips, next-draw forecast, the event log | Unchanged in function; drawn as paper/toner boxes. |

**Zine card anatomy (146 × 218):** paper body, 3 px toner border; toner header with the name (Space Mono 13 bold) and the cost in a highlighter circle (26 px); a 48 px dashed art box; type line (9 px, letter-spaced); rules text (11 px) with key numbers on a highlighter background. With a 12-card Generalist deck and 6 in hand, the deck count reads 6.

**Hand size (open):** 6 cards fit at this size. If CACHE, HOLD 1 or Bloatware push the hand to 7 or more, **overlap the cards in a fan** rather than shrinking them; above about 8 cards, smaller cards would be needed. Don't hard-code a maximum hand size: the designer hasn't set one.

**Corporate Bloatware looks like the corporation, not the zine.** TRACER and SPAM are drawn as that corporation's rounded app cards (TRACER: white, red header, rule chip "+3 TRACE", footer "We just want to stay in touch."), so junk visibly doesn't belong in your hand (`05`, `06`).

### 2.5 The friendly face breaks (task 3)

The corporation's look follows TRACE and strikes (Core Rules §7):

| State | When | What changes | Reference |
|---|---|---|---|
| **Friendly** | TRACE 0–19, no strikes | Everything as in §2.3–2.4 | `01` |
| **Cracking** | TRACE 20–39 | Thin red glitch bands across the background (rgba(229,72,77,0.16)); ICE panels get a red/blue split edge; ICE wording slips ("We noticed unusual activity on your plan." / "Are you sure you're human?"); a corporate toast appears once when TRACE crosses 20: "Is everything okay? We're just checking on you."; a red tag under the TRACE meter: "PAST 50% · THEY'RE LOOKING". NUL/REM counts down: "14 TRACE to a strike." | `04` |
| **Strike 1** | TRACE reaches 40 the 1st time | The background swaps to the hostile version; a rounded HALCYON-shaped modal in red and black: "TRACE STRIKE 1 OF 3" / **"We see you."** / "HALCYON has located you. We've added something to help us keep in touch." with zine lines "+1 TRACER shuffled into your draw pile", "TRACE drops to 20", "next strike: BLACK ICE joins this encounter", and the TRACER card. Afterwards the screen returns to *Cracking* (TRACE is 20). | `05` |
| **Mask off** | Strike 2 or later (Black ICE present) | Hostile background stays; every ICE loses its rounded corners and pastels (square, dark, red border); wording turns honest ("Your plan cannot be cancelled." / "Prove it."); the DEADLOCK buttons turn solid red; Black ICE joins on the left with a red header "BLACK ICE · JOINED AT STRIKE n". NUL/REM: "the mask is off. one more strike and we can't leave." | `06` |

The Rustler layer and the rule chips stay exactly the same in every state.

### 2.6 ICE personality (task 4)

Each ICE on screen is **two pieces**:

1. **The mascot** — the corporation's face. Its **own silhouette** (the real-world object it's named after), a **face**, a **speech bubble**, and its DEADLOCK button.
2. **The scan tag** — NUL/REM's read of the ICE, taped under the mascot (toner, 300 wide, rotated ±1°, a strip of highlighter tape on top): name, STR (with "↑n" when it has grown), type · subtype · passive, every subroutine as a chip (label on the left: S1, SLOT 1, "the button", "tumbled in"), and a footer with the passive's rule. Chip states: normal (paper), **DEADLOCK** (highlighter), **broken** (grey, dashed, struck through), **hidden** (dashed outline, "? HIDDEN"), **new / biggest hit** (red).

**Silhouettes (HALCYON slice).** COOKIE WALL, CAPTCHA, DOORBELL CAM and AUTO-RENEW are drawn (`07`–`10`); the others are proposals in the same spirit.

| ICE | Silhouette | Face | DEADLOCK button | Status |
|---|---|---|---|---|
| COOKIE WALL | Wide banner strip (400 × ~100), cookie on the left | The cookie is the face | "Accept all" | Drawn |
| CAPTCHA | Small square widget (250 wide) with a 3×3 tile grid | One big eye on top | "I'm not a robot" checkbox (ticked and struck through when broken) | Drawn |
| DOORBELL CAM | Tall pill (210 × 330) | Its lens is its eye; the pupil follows your cards | The bell push | Drawn |
| AUTO-RENEW | Credit card (290 × 180) that tilts; price sticker on the corner | Face on the card | "Keep my plan" | Drawn |
| ACCEPT ALL | A big green "Accept all" pill | Face on the pill | — (support) | Proposal |
| REJECT ALL | A tiny grey "Reject all" link, half hidden; passive-aggressive | Small, sulky face | Itself | Proposal |
| TERMS OF SERVICE | A tall scrolling document with a scroll bar | Face at the top of the page | "I have read and agree" | Proposal |
| CONSENT FORM | A clipboard of toggle switches | Face on the clip | "Submit" | Proposal |
| HOUSE CALL (Black ICE) | A "Your technician is on the way!" map-pin card that turns into a faceless silhouette with red eyes | Always lethal | None (Black ICE has no DEADLOCK) | Proposal |

**Faces.** `docs/visual/mascots/` has the three moods as SVG (100 × 100): `face-*.svg` (general face), `captcha-eye-*.svg`, `doorbell-lens-*.svg`. Build each face from separate parts (eyes, brows, mouth, blush) so they can animate.
- **Cheery:** arc eyes (^ ^), wide smile, pink blush.
- **Wary:** flat, slanted brows, small dot eyes, flat mouth.
- **Lethal:** steep red brows, red eyes, jagged red teeth.

**The mood ladder** (each ICE has its own mood; highest that applies wins):

| Mood | When | Behaviour |
|---|---|---|
| **Cheery** | Default: nothing broken on this ICE, TRACE under 20 | Bounces, blinks, waves; corporate accent colors |
| **Wary** | This ICE has at least 1 broken subroutine this encounter, **or** TRACE is 20+ | Flinches, then goes still and **watches you**; amber; wording turns cold |
| **Lethal** | This ICE's part of the **next Corporation Response** deals **PULP 5 or more, or any CORTEX** *(working threshold; make it a tunable value)*, **or** the corporation is in *Mask off*, **or** it's Black ICE | Red, dark, sharp corners; red glow behind it; wording turns hostile |
| **Knocked out** | The encounter is BREACHED | X-eyes / dizzy face, then it slides away |

Lethal does a gameplay job as well as a dramatic one: **whichever ICE is about to hit hardest is also the one that looks angriest**, so the player sees the biggest threat before reading a number.

**Wording per mood** (speech bubble and ICE subtitle; the rule chips never change):

| ICE | Cheery | Wary | Lethal |
|---|---|---|---|
| COOKIE WALL | "We use cookies to make your visit sweeter!" | "You declined 2 cookies. Interesting." | "COOKIES ARE NOT OPTIONAL." (button "ACCEPT") |
| CAPTCHA | "Let's make sure you're human!" / "Just one quick check!" | "Hmm. Try that again." | "PROVE IT." / "WRONG ANSWER." |
| DOORBELL CAM | "Ding dong! Who's there?" | "Recording, for your safety." / "Oh? What's that you've got there?" | "I SEE YOU." |
| AUTO-RENEW | "Your plan renews automatically!" (sticker "FREE for 30 days!") | "You cancelled Basic? We'll remember that." (sticker "Renews next turn") | "Your plan cannot be cancelled." (sticker "NO REFUNDS") |
| AUTO-RENEW rows | Basic plan · PULP 1 / Plus plan · PULP 2 / Premium plan · PULP 3 | same | same |
| CAPTCHA row | "Select every traffic light" · DISCARD 1 | same | same |

Other slice ICE: write three lines each in the same voice (friendly corporate → cold → honest threat) and log them for the designer to approve.

### 2.7 Mascots in the encounter (task 5)

| Reference | Situation | What it shows |
|---|---|---|
| `08` | CAPTCHA node, turn 1 | Both mascots cheery; both DEADLOCKs are friendly buttons; NUL/REM: "both buttons are locks." |
| `09` | Same fight, turn 3 | AUTO-RENEW **wary** (S1 broken and struck through, HARDENING STR 6 ↑2). CAPTCHA **lethal**: its DEADLOCK was broken, so PULP 6 tumbled into slot 2 (TUMBLE-001); black widget, red glow, slit eye, "WRONG ANSWER."; PULP 6 in red in the response strip. |
| `10` | DOORBELL node, turn 1 | You drag GHOST SIGNAL out of your hand (a dashed gap stays in the hand); the doorbell's pupil follows the card; a red label warns "WATCHER: play this CLOAK card · +1 TRACE"; its S1 stays "? HIDDEN" until it fires (VOID-001). |

### 2.8 Motion (from the explorations; working values)

| Moment | Motion |
|---|---|
| Cheery idle | Bob 4 px on a 2.4 s sine; blink every 3–6 s (random) |
| Per ICE type | **FORTRESS:** slow, heavy bob. **TUMBLER:** fidgets; reels jitter and spin (REEL-001). **VOID:** almost still; **its eye follows the card you hover or drag** |
| Becomes wary | Brows drop over 150 ms; bobbing stops; eyes track your cards |
| Becomes lethal (telegraph) | 2 px shake for 60 ms, then a red glow pulsing once a second |
| Fires in the Corporation Response | Lunges 12 px toward the hand over 120 ms as its chip flashes (keeps PLAY-001's at-least-5-second response) |
| Subroutine broken | Flinch (scale 0.9 for 80 ms, recoil); a strike-through draws across the chip over 150 ms; mood re-evaluated |
| DEADLOCK broken | Its button presses in and ticks; the mascot reacts with a lethal or wary line |
| BREACH | Knocked-out face; the mascot slides down and fades over 400 ms; the scan tag peels off |
| TRACE crosses 20 | Toast slides in once; glitch bands flicker for 2–3 frames every 4–8 s, with an RGB split on the ICE |
| Strike | 300 ms red flash; the background cross-fades to hostile; the "We see you." modal stays 2.5 s or until clicked; the TRACER card flies into the draw pile |
| Mask off | ICE skins peel: rounded corners square off, pastels go dark; Black ICE drops in from the top left |
| **Your cards** | **No easing.** Cards snap or slap into place like paper (about 90 ms, no overshoot), with a small random rotation |
| Reduced motion | An option that swaps states instantly, with no bob, shake or flicker |

### 2.9 Accessibility

> **HOVER-001 (APPROVED 2026-11-20):** every hover/focus box for a game object (card, CAP, Ghostware, program, ICE, subroutine key) shows a large, high-resolution image of the object beside its text. Master design §6 has the full rule.

> **Amended by ICE-ANALOG-001 (APPROVED 2026-11-19):** ICE subroutines show an icon and a value; the full rule text is in a hover/focus tooltip. The NEXT RESPONSE strip and the passive strip keep full text, so every rule stays readable without hovering. See `REDLINE_ENCOUNTER_ANALOG.md` §7.

- Mood is never shown by color alone: the face, the silhouette's corners and the wording change too.
- Text contrast at least 4.5:1 (rule chips are toner/highlighter or paper/toner).
- The rules are always readable as text in the scan tag and response strip; the mascot is never the only place a rule appears.

### 2.10 Relationship to `REDLINE_UI_NULREM_Design_For_Claude.md`

That doc (2026-11-07) set an **"Atomic Salvage"** look, which the designer **deprecated** on 2026-11-17 ("I would deprecate that atomic salvage look"). VIS-001 **replaces its look, not its requirements**:

| UI doc section | Under VIS-001 |
|---|---|
| §1 Visual identity (Atomic Salvage: cream enamel, brass, green phosphor, scanlines) | **Replaced** by The Friendly Lie (§2.1–2.2). |
| §3 Punch cards and card reader | Card look replaced by the zine card (§2.4). **Kept:** text wraps and scales, never clipped; BW slits fill left to right. |
| §4 Installed hardware bay, drag-to-ICE | Look replaced by the RIG strip (§2.4). **Kept:** draggable Icepick chips, per-subroutine highlight on hover, reasons shown for illegal breaks, no resources spent on an invalid drop, tooltips. |
| §5 Combat presentation | **Kept:** independent subroutine rows with active/broken states, full effect text, chronological log, next-draw forecast. Its damage types (PHYSICAL / NEURAL / SYNAPTIC) are out of date: the Core Rules (PULP and CORTEX only) win. The END TURN key becomes the highlighter END TURN. |
| §6 NUL/REM personality | **Unchanged.** |
| §7 NUL/REM terminal (green phosphor) | Look replaced: NUL/REM speaks in taped zine notes (toner, highlighter text). **Kept:** text stationary during typing, wraps, never clipped, nothing drawn over the letters. |
| §8 PAPER CUT concept | Still a proposal; under VIS-001 it would be a shredder mascot with a blinking PAPER JAM light. |
| Playtest additions (REEL-001, PULP curve chips, END RUN, CRED meter) | **Kept**, restyled (§2.4). |

General rule carried over: **no effect, glitch band or decoration may cross readable text.**

---

## Part 3 — Build tasks for Codex

Build in this order and log each step in `REDLINE_DEVELOPMENT_LOG.md` under **VIS-001**. Adapt to the existing UI code; the names below are suggestions.

| Step | What | Done when |
|---|---|---|
| **VIS-001a** | **Theme and fonts.** Add DM Sans and Space Mono (OFL) under `godot/assets/fonts/`; a Rustler theme (§2.2) and a corporation skin resource (palette, radius, background textures, header style) for HALCYON, IRONWATCH and LUCIDA. | The HALCYON slice uses the HALCYON skin; the other two exist as data only. |
| **VIS-001b** | **Encounter layout** (§2.4): Node tag, TRACE tag, response strip, NUL/REM note, HUD, deck/END TURN, **6-card zine hand** with a fan for 7+ cards, Bloatware in corporate style. Backgrounds from `docs/visual/backgrounds/`. | Matches `01` in layout and color at 1600 × 1000 and scales to the playtest window. |
| **VIS-001c** | **ICE = mascot + scan tag** (§2.6) for the slice ICE: drawn silhouettes for COOKIE WALL, CAPTCHA, DOORBELL CAM, AUTO-RENEW; simple versions of the proposals for the rest. Faces from `docs/visual/mascots/`, built from separate parts. DEADLOCK shown as the button. Scan-tag chip states (normal, DEADLOCK, broken, hidden, new/biggest). | Every slice ICE can be told apart by silhouette alone; every rule is readable in its scan tag. |
| **VIS-001d** | **Mood system** (§2.6): cheery / wary / lethal / knocked out per ICE, with the triggers above; the lethal threshold as a tunable value; per-mood wording. | `08` and `09` reproduce from real game state. |
| **VIS-001e** | **Corporation states** (§2.5): Friendly, Cracking (20–39), Strike modal, Mask off (strike 2+), hostile background. | `04`, `05` and `06` reproduce from real game state. |
| **VIS-001f** | **Motion** (§2.8), including the VOID eye following the dragged card (`10`) and the reduced-motion option. | Each row of §2.8 can be seen in play. |
| **VIS-001g** | **UI fixtures and bot.** Add screenshot fixtures for: friendly turn 1, wary + lethal turn 3, Cracking, Strike 1, Mask off, DOORBELL drag, 8-card hand. Re-run the rules suite; nothing in the rules changes. | Fixtures render; tests pass; screenshots attached to the PR as PNGs so the designer can view them on a phone. |

**Out of scope for VIS-001:** final painted backgrounds and mascot art; IRONWATCH and LUCIDA mascots (they aren't in the slice); escape ICE; map, Uplink and reward screens. Note anything you had to invent (wording, proposal silhouettes, timings) in the log as *Interpretations to confirm*.


---

## Source 2: [docs/REDLINE_ENCOUNTER_ANALOG.md](https://github.com/Punkwork/REDLINE/blob/8ef0bbe15ccd7eb7cf44f3ca8aaf98c910ee41c7/docs/REDLINE_ENCOUNTER_ANALOG.md)

# PANOPTICON — ENCOUNTER SCREEN: ANALOG / FLIP-CLOCK / COCKPIT DIRECTION
**Date:** 2026-11-19 · **Author:** Claude · **Decision IDs:** ENC-ANALOG-001 (the whole-screen direction), ICE-ANALOG-001 (the ICE readout); both **APPROVED for integration 2026-11-19**
**Status:** APPROVED for integration into the default encounters (designer, 2026-11-19: approved in ChatGPT, confirmed to Claude in session with scope "Whole encounter screen" and "Yes, approved, incl. hover text"). Not built yet; Claude Code is integrating. Nothing in the rules changes.

## 1. Where the mockups are
- **In the repo:** `docs/visual/explorations/encounter-analog-001/` (screenshots, mockup sources, README).
- **Design canvas** "Encounter HUD – Analog Gauge Cluster" (private to the designer): https://claude.ai/artifact/8MQFRD67F6UWSPGNWy8U9J

| Artboard / file | What it shows |
|---|---|
| `Main.dc.html` (canvas only) | The left HUD unit (interactive): PROGRAM reel on split-flap tiles, per-program measure strip, cockpit instruments (TRACE needle meter, BANDWIDTH LED graph, VITAE vial, SHIELD lamp ring, PULP Nixie tubes). |
| `HALCYON_CAPTCHA_A.png` / `EncounterFriendly.dc.html` | HALCYON CAPTCHA node (AUTO-RENEW + CAPTCHA), turn 2, TRACE 12, Friendly. 1600 × 1000. |
| `HALCYON_CAPTCHA_B.png` / `EncounterCracking.dc.html` | Same node, turn 3, TRACE 30, Cracking: 41% hostile reveal; backdrop and mascot art at the PIXEL-TRACE-001 step (3 px, 16 levels, 4×4 dither); text and controls sharp. AUTO-RENEW wary (S1 broken, STR 6 ↑2); CAPTCHA lethal (1 of 2 DEADLOCKs broken, PULP 6 tumbled in, STR 3 ↓2 after PROBE). |
| `HALCYON_CAPTCHA_B_ice_closeup.png` | The two ICE consoles from B at 2×. |

## 2. The look in one line
The Rustler side is a **1960s–70s brown bakelite flip-clock and cockpit**; the corporate side is **mint-enamel HALCYON appliances in chrome bezels**. Both are analog, so the split (ADP-001) reads as two kinds of machine rather than two art styles.

## 3. Design tokens used
| Token | Value |
|---|---|
| Bakelite housing | `#5a3f2a → #3e2b1d → #2e2016` (vertical) |
| Cream controls | `#f4ecda → #dccfb2` |
| Amber label / glow | `#e9963f` labels, `#ffb85a` glow |
| Black glass | `#0a0908`, cream `#e6dcc6` 2 px bezel |
| Chrome | `#fbfcfc → #c9cfd1 → #eef1f1 → #9aa2a4` |
| HALCYON enamel | `#d8efe6 → #b9e0d1 → #a2d3c1`; ink `#2f5d52`; deep `#3f7f70` |
| Signal red | `#d8321f` |
| Type | Barlow Condensed 500–700 (instruments, labels, numerals); DM Sans (corporate body, rule lines); Poiret One (corporate headlines ≥ 28 px only); Space Mono (NUL/REM note) |

## 4. Elements
- **Split-flap tiles** (dark rounded card, split line, metal hinge pins) for every name and number: Node name, program reel, STR, TURN, RESERVE, DECK/DISCARD, the NEXT RESPONSE board.
- **Jewel lamps**: status lights, glow when on; never the only signal (shape or text always accompanies them).
- **ICE console** (490 wide): name tiles + STR tiles with ↑/↓ delta; type · subtype line; SUPPORT/MAIN pill; round porthole holding the mascot; subroutine bank; passive lamp strip; patent plate. TUMBLERs show a reel window (pool entries dimmed above and below the active slots) and a slot-machine lever.
- **DEADLOCK** = chrome-ringed red mushroom push-button with a padlock; broken = green, pressed in.
- **END TURN** = large cream mushroom button in a chrome ring with an amber halo.

## 5. Interpretations to confirm
1. The TRACE lamp lights when TRACE is **high** (≥ 30); the other lamps light when low.
2. The HUD's PULP Nixie shows **incoming** PULP for the next response.
3. Program reel widened to 13 tiles; names shortened (TUMBLER PICK, FORTRESS PICK).
4. END TURN and DECK/DISCARD moved up beside the response board so the 1.4× hand (CARDS-004) has the full width.

## 6. Cards: not a redesign
The cards in the mockups are **stand-ins** drawn to fill the hand, approximating the CARDS-001 cartridges (brown SCRIPT / olive PROGRAM face, BW dial top-left per CARDS-004a, contact strip). They are not a proposal. Use the real CARDS-001/004/005 cards in any build.

## 7. Next: ICE-ANALOG-001 (designer direction, 2026-11-19)
Designer: redesign the **ICE readout, not the mascots**. Mascots get **a little bigger and more behaviour**. Subroutines become **icons with a value** (DEADLOCK as an image, not the word; same for TRACE, PULP, etc.), easy to see, elegant, fitting a very limited space; **hovering a subroutine icon shows its full text**. Codex takes this as a design-review task (designer's request); the brief is §8.

**Rule to confirm with this change:** VIS-001 §2.9 says rules are always readable as text in the scan tag. Icon-first subroutines move the full text to hover/focus. The NEXT RESPONSE board, the passive strip and the tooltips keep full text, so the player can still read every rule; the designer should confirm this replaces the old line.

## 8. Codex prompt (ICE-ANALOG-001)

```
TASK: ICE-ANALOG-001 — Iconized ICE subroutine readout + larger, livelier mascots (design exploration, HALCYON slice)

CONTEXT
- Repo: Punkwork/REDLINE on main. Follow CLAUDE.md / AGENTS.md. Godot slice under godot/. Read first: docs/REDLINE_ENCOUNTER_ANALOG.md (this direction), docs/REDLINE_VISUAL_LANGUAGE.md (VIS-001 §2.6 ICE = mascot + scan tag, §2.8 motion, §2.9 accessibility), docs/REDLINE_ATOMIC_DECO_PUNK.md (ADP-R1: rules readouts are always true and readable; bleed), docs/REDLINE_ICE_CORP1.md §5.0 (current slice ICE values), docs/HANDOFF.md (PIXEL-TRACE-001, CARDS-004/005).
- Reference mockups (in the repo): docs/visual/explorations/encounter-analog-001/HALCYON_CAPTCHA_A.png (Friendly, turn 2, TRACE 12), HALCYON_CAPTCHA_B.png (Cracking, turn 3, TRACE 30), HALCYON_CAPTCHA_B_ice_closeup.png. They show the analog direction: Rustler side = brown bakelite flip-clock/cockpit; corporate side = mint-enamel HALCYON appliances in chrome bezels; split-flap tiles for names and numbers; jewel lamps; Dymo-tape labels; red mushroom DEADLOCK buttons.
- The cards in those mockups are placeholders. Do NOT redesign cards; keep CARDS-001/004/005 as built.
- Nothing in the rules changes. Presentation only. Re-run the rules suite; it must stay green.

GOAL
Redesign how each ICE shows its subroutines and what will happen, so it is (1) elegant, (2) readable at a glance in a very small space, (3) inviting to touch. Do NOT redesign the mascot art. Make the mascots a little bigger and give them more behaviour.

1. SUBROUTINES BECOME ICON + VALUE "INSTRUMENT KEYS"
- Each subroutine is one round or rounded-square key (target 56–64 px at 1600×1000; never under 44 px): an icon plus a large value numeral (Barlow Condensed 700, at least 22 px). No effect words on the key itself.
- Icon vocabulary (one shape per effect, distinct by silhouette, not colour alone; reuse the HUD instrument glyphs so the player learns one set):
  - DEADLOCK: padlock on the red mushroom push-button. No number. Broken = green, pressed in, open shackle.
  - PULP X: the PULP starburst glyph (as on the HUD's PULP knob) + X.
  - TRACE X: the TRACE orbit/satellite glyph (as on the HUD's TRACE meter) + X.
  - DISCARD X: card with an out-arrow + X; "next turn" timing as a small clock pip.
  - INSERT X SPAM: envelope + X, with a small arrow to draw pile / discard / hand.
  - −1 BW (DETAINER): the BANDWIDTH antenna glyph with a minus.
  - CORTEX X: brain glyph + X.
  - PULP curve (random/hammer): starburst with a small dice or hammer badge; show the current value.
  - Face-down VOID subroutine: "?" key, dashed bezel.
  Design any icon the slice needs that isn't listed, in the same family, and list it.
- States (each must differ by shape or mark as well as colour): ready (lamp on); biggest hit this response (red ring + glow); broken (dimmed, struck through or flipped to a blank flap, lamp off); hidden; just tumbled in (brief flap animation); locked by BOOTING (small padlock-clock badge).
- Break affordance: the key itself is the break target (drag an Icepick onto it, or click/press to break when legal). Show the BW cost as a small chip on the key's edge; TOLL/TRIPWIRE costs appear in that chip (e.g. "1 BW · +1 TRACE"). Illegal break: key shakes once and the reason appears in the tooltip; no resources spent.
- TUMBLER: keep the reel window idea from the mockups. Active slots are full keys; the rest of the pool shows as small dimmed icons above and below. TUMBLE-001 drop-out/slide/tumble-in animates as a reel.
- FORTRESS: keys in a row S1→Sn. SEQUENCED shows the order with small chevrons between keys.

2. HOVER / FOCUS TOOLTIP = THE FULL RULE (ADP-R1)
- Hovering a key, or focusing it by keyboard/controller, opens a small plaque (cream enamel, chrome edge, DM Sans 14–15 px, contrast ≥ 4.5:1) with: the slot label, the full rule text exactly as the rules engine words it (e.g. "PULP 6 — lose 6 VITAE (SHIELD blocks)", "DEADLOCK — blocks BREACH until broken"), timing (this response / next turn), break cost and any passive surcharge, and the corporate flavour line where one exists (AUTO-RENEW "Premium plan").
- Opens within 150 ms, never covers the hovered key or the hand, flips side near screen edges, stays open while the pointer is on it. Instant with reduced motion.
- Full text must also stay available without hover: the NEXT RESPONSE strip keeps text, and the passive strip keeps its one-line rule. Flag in the log that this changes VIS-001 §2.9 ("rules always readable as text in the scan tag") for the designer to confirm.

3. MASCOTS: BIGGER, MORE BEHAVIOUR (same art)
- Scale the mascot about 25–35% larger within the ICE console; the console must still fit two ICE plus a support at 1600×1000 with the CARDS-004 layout (propose the 3-ICE layout too, e.g. THE HEARTH).
- Behaviour (extend VIS-001 §2.8; all flavour, never a rules signal on its own):
  - Idle: bob and blink per type (FORTRESS slow/heavy, TUMBLER fidgety, VOID still).
  - Attention: eyes follow the hovered or dragged card; when you hover one of its subroutine keys, the mascot glances at that key.
  - Telegraph: at the start of the Corporation Response, the mascot looks at / points toward the key that is about to fire, in left-to-right order, as each key's lamp flashes.
  - Reacts to breaks: flinch on a break; a bigger reaction on a DEADLOCK break; mood re-evaluated.
  - Moods (cheery / wary / lethal) per VIS-001 with the approved lines; ADP-2b hesitation lines still work.
  - Pixel steps (PIXEL-TRACE-001) still apply to mascot art and backdrop only; keys, tooltips and numbers stay sharp.
  - Reduced motion: no bob, shake or tracking; state changes are instant.

CONSTRAINTS
- Limited space: at 1600×1000 the whole ICE (mascot + keys + passive strip + name/STR) should fit within ~490 × 410 px per ICE for a 2-ICE layer. Prefer fewer, larger things.
- No effect, glitch or decoration crosses readable text or a numeral. Contrast ≥ 4.5:1. Never colour alone.
- No QR codes. No rules changes. One data file for tunable values (godot/data/atomic_deco_punk.json or a new ice_readout.json).

DELIVERABLES (design review first, integration after approval)
1. Icon sheet: every icon in all states, at 1× and 2×, on mint enamel and on black glass. PNG + source (SVG preferred) in docs/visual/explorations/ice-analog-001/.
2. Godot screenshot fixture (new shot_ice_analog.gd, alongside the existing shot_*.gd) of the HALCYON CAPTCHA node (AUTO-RENEW + CAPTCHA) matching the two reference states: Friendly turn 2 TRACE 12, and Cracking turn 3 TRACE 30 (AUTO-RENEW S1 broken, STR 6 ↑2; CAPTCHA one DEADLOCK broken, PULP 6 tumbled in, STR 3 ↓2). Plus: one tooltip open; one illegal-break state; the DOORBELL CAM node with a face-down VOID key; and a 3-ICE layout.
3. A short GIF or MP4 of the mascot behaviours (idle, attention, telegraph, break reaction) and a TUMBLE.
4. Log the work in docs/REDLINE_DEVELOPMENT_LOG.md under ICE-ANALOG-001 with "Interpretations to confirm", update docs/HANDOFF.md, and report the commit. Do not change rules code. Do not merge into the default encounter until the designer approves.
```


---

## Source 3: [docs/REDLINE_UI_NULREM_Design_For_Claude.md](https://github.com/Punkwork/REDLINE/blob/8ef0bbe15ccd7eb7cf44f3ca8aaf98c910ee41c7/docs/REDLINE_UI_NULREM_Design_For_Claude.md)

# PANOPTICON — UI, Interactions & NUL/REM Character Design

> **Not current for rules (DOCS-001, 2026-11-18).** Its look is replaced by `REDLINE_VISUAL_LANGUAGE.md` (VIS-001); its UI requirements still apply where that doc says so (§2.10). Rules and Node types: `REDLINE_CORE_RULES.md`.
## Claude implementation handoff · 2026-11-07

**Scope:** Visual presentation, controls, selection screens, card readability, dialogue system and character writing. Engine combat rules and resource economy are specified separately in `REDLINE_ICEbreaker_Strength_Economy_Design_For_Claude.md`. Do not change combat rules to solve a rendering problem.

> **DEPRECATED LOOK (VIS-001, designer, 2026-11-17):** "I would deprecate that atomic salvage look." The visual identity in §1 (Atomic Salvage) and the visual styling in §3, §4, §5 and §7 are replaced by `REDLINE_VISUAL_LANGUAGE.md` (The Friendly Lie). The **functional and readability requirements** in this doc still apply (see `REDLINE_VISUAL_LANGUAGE.md` §2.10), and §6 (NUL/REM personality) is unchanged.

## 1. Visual identity — Atomic Salvage *(DEPRECATED — VIS-001)*
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

*Relocated by UI-BIBLE-001 (2026-11-25), unchanged, to [NUL/REM Dialogue Architecture, Appendix A](PANOPTICON_NULREM_DIALOGUE_ARCHITECTURE.md#appendix-a--legacy-nulrem-personality-design-bible-relocated-by-ui-bible-001). It is narrative and character design, not UI.*

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

## Playtest build additions (2026-11-14)

- **TUMBLER reels (REEL-001):** each TUMBLER slot is a slot-machine window (dark recessed frame, shaded top and bottom edges). On rotation each slot rolls downward through the previous subroutine and a blur of random icons (revealing nothing hidden), slows, overshoots slightly and clunks into place with a flash. Slots stop one after another (0.95 s, then +0.5 s per later slot); input is held until all have stopped.
- **Slot labels** name the subroutine in the slot: "SLOT 2 · S1".
- **PULP curve chips (PULP-002):** "PULP 9 · HAMMER" or "PULP 3 · SEQUENTIAL" (this turn's value); "PULP ? · RANDOM" for curve B, with "+ random PULP (1–6)" added to the response preview. Hovering a curve chip shows its sequence.
- **END RUN (RUN-001):** red button bottom right; confirmation "END THIS RUN?" — YES, END THE RUN / KEEP PLAYING. Yes: the Rustler fails, NUL/REM's run-lost line plays, then the start menu (Rustler choice).
- **CRED meter (UI-002):** gold bar "left / total CRED" for the encounter's reserve; 0 shows in red.



---

## Source 4: [docs/REDLINE_ATOMIC_DECO_PUNK.md](https://github.com/Punkwork/REDLINE/blob/8ef0bbe15ccd7eb7cf44f3ca8aaf98c910ee41c7/docs/REDLINE_ATOMIC_DECO_PUNK.md)

# PANOPTICON — ATOMIC DECO PUNK: MAKING THE SPLIT REALITY FELT
**Version:** 0.8 · **Date:** 2026-11-18 · **Author:** Claude · **Decision ID:** ADP-001
**Status:** **Approved (2026-11-17).** The designer approved ADP-R1 with a new definition of the zine (ZINE-001, §2.1), the hostile reveal growing from 20% to 60% (§2), Poiret One for corporate headlines (§3.5), Phases 1, 2, 3 and 5 of the build tasks, and SIGNAL-001, the three First Signal punch cards (§8). Only the "later" ideas are still CONCEPT, with no build tasks. No questions are open (§7). Build order: Phase 1 → 2 → 3 → 5, with Phase 4 fixtures as each lands.
**Changes in 0.6–0.8 (2026-11-18):** added §1.1, how Atomic Deco Punk relates to atompunk (the term stays), and ZINE-002 (§2.2): the zine is how the underworld talks to itself, **in the lineage of Soviet-bloc samizdat**, with the reasons it exists made explicit (§2.2.2). §8 now links to ARCH-001 (`REDLINE_ARCHIPELAGO.md`): the reveal has two parts. The direction is the designer's; the examples are Claude's working interpretation, for approval. No build tasks change.
**Builds on:** *Atomic Deco Punk — DIRECTION* in `REDLINE_MASTER_DESIGN.md` §1; The Friendly Lie (`REDLINE_VISUAL_LANGUAGE.md`, VIS-001); CHROME-001; CARDS-001; RUSTLER-LOOK-001; FACADE-001 (`REDLINE_CORPORATE_FACADES.md`).
**For:** Codex (Godot build, `godot/`).

**What doesn't change:** every approved decision listed in the master document's VISUAL-DECISIONS-2026-11-17, VISUAL-APPROVALS-002 and FACADE-001. In particular: the Friendly → Cracking → Strike → Mask off states and their triggers, the 20% hostile reveal at Cracking, the mood ladder, the cartridges and their finishes, the zine HUD (kept as is for now), the plaques, and the readability rules (Visual Language §2.9: contrast at least 4.5:1, mood never shown by colour alone, **no effect, glitch band or decoration may cross readable text**). No rules change anywhere in this doc.

---

## 1. The idea

**Atomic Deco Punk** is the umbrella style for the whole world, in the designer's words: the exuberance and faith in progress of the Atomic Age, the streamlined industrial design of Art Deco, and punk's DIY defiance. Engineers build and repair their own elektronix alongside the monolithic buildings and processes of the great corporations.

- **Raygun Gothic is the corporate half:** the chrome facades, enamel appliances and sincere service voice.
- **The punk half is the Rustler's: the zine** (§2.1), meaning paper and retro-mutated technology with form stripped bare and function bolted on. Today that's the salvaged 1950s cartridges and the zine HUD. The zine is also the underworld's samizdat: how it talks to itself where nothing is listening (§2.2).

The game should make the player feel what it's like to live in a reality that tells two stories at once. Everything exists twice: as the corporation presents it, and as the Rustlers know it to be. The player never lives fully in either. Most of the proposals below work on **where the two halves touch**, because the unease comes from that friction.

### 1.1 Relation to atompunk (2026-11-18)

The designer asked whether *atompunk* (Wikipedia: a retro-futuristic derivative of cyberpunk set in the pre-digital era, roughly 1945–1969) already names this style. **Answer: it names the corporate half, not the whole.** The term Atomic Deco Punk stays; each of its three words points at a different layer of the game.

| Word | Where it lives in Panopticon | Covered by atompunk? |
|---|---|---|
| **Atomic** | The corporations: Raygun Gothic, Populuxe appliances, Googie signage, mid-century optimism, Cold War surveillance paranoia. | **Yes, fully.** This is atompunk's core look and mood. |
| **Deco** | The monoliths: Art Deco and Streamline Moderne architecture, Deco frames, Poiret One headlines. | **No.** Wikipedia files Art Deco under *decopunk*, a subset of dieselpunk set in an earlier era. Panopticon blends it in deliberately. |
| **Punk** | The Rustlers: real DIY counter-culture, i.e. the zine (§2.1–2.2), whose lineage is samizdat first and punk zines second; retro-mutated tech, barcodes and punch cards. | **No.** In atompunk "punk" is mostly a genre suffix; it has no underground press or DIY counter-culture layer. |

Atompunk also has no equivalent of **the split** (two realities, one surface, driven by bleed), which is the core of this doc.

**How to use the words**
- **Outward pitch:** "an atompunk deckbuilder" is a fine shorthand; players already know it from *Fallout*, *We Happy Few* and *Atomic Heart*, which share the Friendly Lie's cheerful-facade-over-horror.
- **Internal design term:** Atomic Deco Punk = atompunk corporations + Deco monoliths + samizdat-zine Rustlers.
- **Worth borrowing from atompunk:** its Cold War paranoia vocabulary for the corporate side: civil-defence pamphlets, loyalty pledges, "report your neighbour" notices, duck-and-cover drills, informant hotlines. These fit the lore ephemera (§6.4) and the corporate voice (§4.1). Flavour only, for approval. Samizdat (§2.2) is the other side of that same Cold War: what people printed in answer to it.

## 2. Two rules

**ADP-R1 — The chrome lies; the zine never does. (APPROVED, 2026-11-17)** Designer: "yes". This extends Visual Language Rule 2 ("the rules are always in zine style"). Corporate wording, backgrounds, ads and flavour records of the player's own past may be unreliable. Rules readouts (plaques, rule chips, the response strip, every number, card name and cost) are **always true and always readable**. The player can distrust the world without the game ever being unfair, and the Rustler layer becomes the one thing they can trust, which is what makes it feel like home. In the fiction, this is exactly why the zine exists (§2.2.2): it is the record nobody can edit.

### 2.1 What the zine is (ZINE-001, APPROVED 2026-11-17)

The designer redefined the zine for this world. It isn't only photocopied paper:

> "it's zine and retro-mutated technology where form is stripped bare for bolted on function. So a zine could have the paper form a moebius strip in order to rig some foil-based antenna to jam a surveillance signal, using a version of QR codes, but in the form of barcodes and punchcards."

What that means for design (the principles are the designer's; the examples are Claude's working interpretation):

| Principle | Means | Examples |
|---|---|---|
| **Form stripped bare, function bolted on** | The opposite of the corporate shell. Nothing is there for looks; every part visibly does a job, and you can see how it was attached. | Exposed bolts, hose clamps, cable ties, solder blobs, tape; housings cut open; parts mounted on whatever was at hand. |
| **Paper is a working material** | The zine is a device as well as a publication. Paper is folded, cut, twisted, laminated with foil and wired into working parts. | A Möbius strip of paper with a foil antenna that jams a surveillance signal; a folded paper horn as a speaker; a cut-out stencil as a signal mask; a strip of photocopied circuit as a fuse. |
| **Retro-mutated technology** | Period technology (valves, relays, crystal radio, the 1950s cartridges) mutated by hand into something its makers never planned. | A corporate appliance part rewired into a cartridge (grafts, §3.1); a cartridge with a hand-wound coil bolted on. |
| **The machine code is barcodes and punch cards** | This world's equivalent of QR codes. Rustlers write to machines in barcode strips and punched holes; it's how their paper talks to corporate systems. | A barcode strip printed along a zine's edge, punched-hole rows along a cartridge label, a punched-tape tail on a NUL/REM note, a jammer pattern made of punched holes. |

**Rules for using it**
- Barcodes and punched strips in general are **decoration and world-building**, not a second rules channel. They never replace readable rule text (ADP-R1, readability rules). **The exception is the three First Signal punch cards** (SIGNAL-001, §8), which are the run's goal.
- **No QR codes anywhere** in the Rustler layer: barcodes and punch cards only.
- The **cartridges** (CARDS-001) already fit this definition; future card art should show the hack (what was bolted on, and why). For instance, GHOST SIGNAL (a CLOAK card) could be the Möbius-strip foil jammer.
- The **zine HUD stays as it is for now** (RUSTLER-LOOK-001). This definition is the brief for its redesign whenever the designer revisits the HUD, and it shapes the seam (§3.2).

### 2.2 The zine is the underworld's samizdat (ZINE-002, designer direction 2026-11-18)

Designer: the zine is **how those in the underworld, Rustlers included, communicate ideas with each other**, and it belongs **in the lineage of samizdat**, with real emphasis on **why these publications exist at all**. ZINE-001 says what a zine *is* (paper as a working device); ZINE-002 says what it's *for* and *why it has to exist*.

#### 2.2.1 The lineage

**Samizdat** (Russian, roughly "self-publishing") was the underground press of the Soviet bloc from the 1950s to the 1980s. The state owned the presses, the paper supply and the copying machines, and decided what could be printed. So people retyped forbidden or unpublishable texts on home typewriters, several carbon copies at a time, and passed them hand to hand. Each reader was expected to make more copies and pass them on. The later carbons were faint, and a barely legible page showed how far a text had travelled. Owning or copying it could cost you your job or your freedom.

Its cousins matter to Panopticon too:
- **Magnitizdat:** the same thing on tape. Banned songs and speeches copied from reel to reel and cassette to cassette.
- **Roentgenizdat ("bone music"):** records cut into used X-ray film, because vinyl was controlled and hospital waste wasn't. You could see someone's ribs behind the grooves.
- **Tamizdat:** texts smuggled out, printed abroad and smuggled back.
- **The *Chronicle of Current Events*** (1968–1983): a samizdat bulletin that recorded searches, arrests and trials in a deliberately plain, factual voice, so that what the state erased still had a record.

**Punk zines** (1970s on) are the Western cousin: the same DIY copying and hand-to-hand distribution, with far less at stake. **Panopticon's zine looks punk and carries samizdat's stakes.** The cut-and-paste, the photocopy grain and the irreverence are punk; the reason to make it, the danger of holding it and the duty to copy it are samizdat.

*(Inspiration, not a source to match: Panopticon is a made-up world and doesn't have to resemble real history exactly. Designer, 2026-11-18: "Samizdat history all good.")*

#### 2.2.2 Why the zine exists

This is the heart of ZINE-002. In Panopticon, **nothing is banned.** The corporations don't need censors. They own every channel, they listen to all of it, and they are unfailingly polite. Samizdat existed because the state owned the presses; **the zine exists because the corporations own the air.**

| Reason | In Panopticon | Where the game already shows it |
|---|---|---|
| **1. Every channel is owned, and every channel listens.** | Screens, speakers, phones, doorbells, even the public copiers belong to a corporation. Saying something on any of them is saying it to the corporation. Paper passed hand to hand is the only medium with no listener built in. | The Friendly Lie; the surveillance layer behind every background. |
| **2. Whatever you say becomes data.** | Speech on a corporate channel is harvested, profiled and sold back to you as helpfulness. The zine is the one place your words don't become a product. | Ads that know you (§6.1); ICE that notice hesitation (§6.2). |
| **3. The official record can be rewritten.** | Corporate memory is whatever the corporation says happened, and it can change after the fact. Once a zine is in other hands, copies exist that nobody can edit. | LUCIDA edits the record (§6.3); ADP-R1. |
| **4. The traced disappear from the record.** | People who get traced drop out of official history. No news, no notice; their accounts just say "relocated" or "resting". The zine names them and says what happened. This is the *Chronicle*'s job, inherited. Where they go: the Archipelago (ARCH-001, `REDLINE_ARCHIPELAGO.md`). | "for Mags, who got traced" (§4.2). |
| **5. No one else will say it plainly.** | Corporate language is euphemism by design ("Gentle Adjust™", "Courtesy™", "rest"). The zine's job is to call things by their real names. | The corporate voice (§4.1) and the voice leaks (§4.3). |

So the censorship in this world is **censorship by convenience, not prohibition.** You're allowed to say anything; there's just nowhere to say it that isn't listening, recording and politely improving your words. The zine is the underworld's answer: slow, physical, hand to hand, and true.

This also explains ZINE-001's look. Every corporate machine fingerprints what it makes (the real-world equivalent is the hidden tracking dots colour laser printers put on every page). So the underworld can't use corporate copiers. It builds its own from salvage, which is why form is stripped bare and function bolted on: the hack is not a style choice, it's how you print without being traced.

**For the player:** ADP-R1 gives this promise a mechanical form. The zine-styled rules readouts never lie, because in the fiction the zine is the one thing that can't afford to.

#### 2.2.3 How zines are made and passed

| Samizdat practice | Panopticon zine (APPROVED 2026-11-18, ARCH-COPY-001) |
|---|---|
| **Typewriter and carbon copies; later copies are fainter** | Zines are typed, stencilled or hand-lettered, and copied by carbon, hand-cranked mimeograph or salvaged, rewired copiers. **Copy generation is visible:** a crisp zine came straight from its maker; a faded, misregistered one has passed through many hands. (Decoration only; never on rule text.) |
| **The reader's duty to copy** | Every zine ends with the same instruction: *read it, copy it, pass it on.* Mastheads can carry a hand tally: "COPY 5 OF 5 — MAKE 5 MORE." |
| **Traceable typewriters** (in Ceaușescu's Romania typewriters had to be registered with the police) | Corporate machines fingerprint every page, so the underworld uses only salvaged or rebuilt machines, and some printers deliberately misalign their type to defeat fingerprinting. |
| **Magnitizdat** | Cassette dubs of pirate broadcasts, crew messages and music. The Rustler music track (§5.1, 4-track cassette) is literally magnitizdat; pirate radio (§5.3) is its live form. |
| **Roentgenizdat (bone music)** | Records cut into salvaged corporate film: LUCIDA sleep-scan film, HALCYON appliance-display sheets. A natural art piece for DEAD DROP (§6.6). |
| **Tamizdat** | Material that comes in from outside the city. *Could* tie to the Black Market Uplink as a smuggling route; needs a story decision, so not assumed. |
| **The *Chronicle of Current Events*** | **An underworld ledger, *THE CARBON*** (title approved 2026-11-18): a dry, dated, factual bulletin of who got traced, which blocks went dark and which ICE changed. Its voice is deliberately plain, the one Rustler voice that isn't irreverent, because its job is to be believed. ARCH-001 makes it the record of the player's own lost Rustlers. |
| **The danger of possession** | In the fiction, holding a zine is a risk. The corporations never forbid it; they discourage it politely ("Paper can carry germs. Try HALCYON Clean Reader™." / "Unlicensed print may contain misinformation. IRONWATCH is here to help."). Flavour only; no rule penalises the player. (Lines approved 2026-11-18.) |

#### 2.2.4 What the zine carries

| Kind | Working examples (for approval) |
|---|---|
| **Ideas and know-how** | Schematics for rewiring a corporate part; "how to fool a CAPTCHA eye"; a recipe for foil laminate; a manifesto. |
| **The record** | *THE CARBON*'s entries: names, dates, blocks, what happened. |
| **News and warnings** | Which blocks went dark this week; which ICE got a firmware update; "IRONWATCH patrols moved to the east line." |
| **Crew life** | Dedications ("for Mags, who got traced", §4.2), in-jokes, letters columns, missing notices, shout-outs from other crews. |
| **Hidden messages** | Barcode strips and punched rows that say something to another Rustler and look like noise to a corporate scanner; fold-in pages that only read correctly when folded right. |

**Who uses it:** not only Rustlers. The wider underworld (fixers, scavengers, pirate-radio operators, black-market sellers at the Uplink, people who just opted out) publishes, copies and trades zines too. Each source can have its own **issue numbering, masthead and hand** (typewriter, stencil, marker, carbon, photocopy degradation), so the player starts to recognise who's talking.

**Where the player meets it (flavour; ties into existing ideas, no new build tasks yet):**
- **Run framing:** a run is an issue ("ISSUE #14", §4.2).
- **NUL/REM's notes** are the in-run zine voice; between runs, other underworld voices can join.
- **Lore** arrives as corporate ephemera with Rustler marginalia (§6.4) *and* as underworld zines passed along between runs, including *THE CARBON*.
- **DEAD DROP and the radio** (§6.6, §5.3) are natural places to pick up a zine or a tape; small rumours there follow the same rules as the radio's (RUN-005 hidden contents, needs a rules decision first).
- **Hints toward SIGNAL-001** (§8.2) can travel through zines (a stray hole pattern, an article on old speech-synthesis experiments), always oblique, never an explanation before the third card.

**Rules for using it:** same as ZINE-001. Zine communication is **fiction and world-building, not a rules channel**: in-world messages never replace readable rule text, never cover a rule, number or button, and never use QR codes (ADP-R1). "The zine never lies" (ADP-R1) applies to rules readouts; an in-world zine article can be wrong, out of date or argued with in the next issue, because people wrote it. That fallibility is part of its honesty: it's people, not a system.

**ADP-R2 — One value drives the split: bleed.** Every effect in §3–5 that changes with pressure reads one number, **bleed**, from 0 to 1, computed from TRACE and strikes. The world comes apart in sync, the whole effect can be tuned with one curve, and the reduced-motion and readability rules can cap it in one place.

| Corporation state (Visual Language §2.5) | Bleed (working values) |
|---|---|
| Friendly (TRACE 0–19, no strikes) | 0 |
| Cracking (TRACE 20–39, or strike 1 and below 20; VISUAL-APPROVALS-002) | 0.2 at TRACE 20, rising linearly to 0.6 at TRACE 39; never below 0.2 once strike 1 has happened |
| Strike modal on screen | 0.8 |
| Mask off (strike 2+) | 1.0 |

The 0.2 at the start of Cracking is the approved 20% hostile reveal. **The reveal grows with bleed, from 20% at TRACE 20 to 60% at TRACE 39 (APPROVED 2026-11-17).** Designer: "the hostile reveal should grow as trace rises, from 20% to 60%". Bleed changes smoothly over about 400 ms (instantly with reduced motion).

## 3. Visual

### 3.1 Salvage flows from the corporation to the rig
CARDS-001 already makes the cartridges out of "salvaged cartridge bodies". This makes the salvage traceable: the Rustler's tools are visibly built from the monolith's own products.

- **One parts library, two treatments.** Corporate appliances (mascot shells) and cartridges draw from the same set of parts: lenses, dials, fins, grilles, enamel panels, badges, coils. Corporate treatment: pristine chrome and gloss enamel. Rustler treatment: the same part with the logo scratched off, tape, exposed wire, a Dymo-tape or marker label, solder blobs.
- **Grafts.** When a PATCHWORK upgrade is applied to a card instance, the card can carry one **graft**: a part from an ICE the player broke during that run (CAPTCHA's eye, DOORBELL CAM's lens, AUTO-RENEW's chip). Over a run the deck visibly becomes a pile of stolen corporate future. **Art only, no rules.** The graft belongs to the card instance, like PATCHWORK itself (master §4, LOCKED), so it must survive save/load and must not spread to other copies.

### 3.2 The seam (later)
For when the designer revisits the HUD (RUSTLER-LOOK-001 keeps it as is for now): the zine HUD should look clipped onto a corporate machine it was never designed for. Alligator clips biting the chrome bezel, ribbon cable running off-screen, hand-drilled holes. No build task yet.

### 3.3 Industrial scale behind the facades (later, needs art)
The corporations should feel like systems the player is a speck inside, not storefronts: pneumatic tubes carrying data capsules high in the atrium, conveyor lines, mainframe halls glimpsed through the Deco frames. Stolen data could arrive as a physical capsule or punched card on BREACH. This goes into the next round of background briefs (Corporate Facades §5), not into code.

### 3.4 The rig wears under pressure
The Rustler layer shows strain as bleed rises, like a hand-built rig running hot: more toner speckle and slight misregistration of the panel shadows (the paper), tape lifting at panel corners, foil crinkle and a faint flicker on the barcode and punched-hole strips (the bolted-on tech, §2.1). **Only on panel surfaces, borders, shadows and decorative strips, never on glyphs** (readability rule). At bleed 1.0 it should look like a rig held together by hand, still fully readable.

### 3.5 Poiret One for corporate headlines (APPROVED 2026-11-17)
Designer: "I think a deco display face is ideal for corporate headlines, Poiret One suits headlines". DM Sans stays for corporate body copy, buttons and rule text.

**Where Poiret One goes:** corporate wordmarks ("halcyon home", "IRONWATCH SafeStreets", "lucida rest"), background headlines ("Good morning.", "Your block is safe.", "Breathe in."), strike-modal headlines ("We see you.", "Stay where you are.", "Let's rest now."), Node-entry and loading-screen titles, newsreel cards, propaganda and ads (§6.1).

**Where it doesn't:** rules, numbers, plaques' rule lines, buttons, toasts' body text, anything under about 28 px. Poiret One is a thin, hairline face; at small sizes or over busy art it fails the readability rules. Use it large, on a solid enamel or plaque ground, and check 4.5:1 contrast like any other text. It's never used on the Rustler side.

On the Rustler side, stencil and hand lettering could join Space Mono for scrawls and graffiti (§4.3); that's part of Phase 2. Typewriter faces fit the samizdat side (§2.2.3) if a zine-specific face is ever added.

## 4. Tone and language

### 4.1 Corporate voice
Keep FACADE-001's rule: more polite and more certain as the threat grows; never raised before Mask off. Add, as flavour:
- 1950s newsreel narration for loading screens and lore ("Tomorrow's home is here today!").
- Trademarked everyday words: "HALCYON Welcome™", "SafeStreets Courtesy™", "lucida Gentle Adjust™".
- Patent plates on appliances ("PAT. PEND. HALCYON MFG. CO.").
- *Tomorrow* as a quiet threat ("We'll talk about this tomorrow.").
- Cold War civic paranoia, borrowed from atompunk (§1.1): civil-defence notices, loyalty pledges, "report unusual activity" lines, all in the same warm service voice (for approval).
- Polite discouragement of paper (§2.2.3): never a ban, always a helpful alternative.

### 4.2 Rustler voice
Practical, irreverent and specific (master §1). Add:
- Punk respellings, **sparingly**: *elektronix*, *kontrol*. Never in rules text.
- Hand-numbered zine issues: a run could be "ISSUE #14".
- Warmth. Crew messages, in-jokes, zines dedicated "for Mags, who got traced." The paranoia lands harder when the player has people to lose. The zine is where this warmth lives (§2.2).
- One plain register: *THE CARBON* (§2.2.3) reports facts without jokes, because the record has to be believed.

### 4.3 The voices leak as bleed rises
| Bleed | Leak |
|---|---|
| 0 | The two voices stay apart. |
| 0.2–0.6 | Corporate phrasing creeps into NUL/REM's notes: *"let's take a breath together. no. break it."* Rustler graffiti (marker scrawls, stencils) appears on corporate surfaces: on the background, a toast, a mascot's shell. |
| 0.8–1.0 | Both voices argue on the same surface: a corporate toast with a scrawl across its margin answering it. |

Flavour only. A leak line can never replace or cover a rule, a number, or anything the player needs to decide (ADP-R1). Graffiti sits on decorative areas only.

**Sample lines (working, for approval):**

| Corp | NUL/REM note with corporate leak | Graffiti on the corporate surface |
|---|---|---|
| HALCYON | "we'll take care of it. — no we won't. break the button." | "HOME IS WHERE THE CAMERA IS" |
| IRONWATCH | "stay protected. stay — no. keep moving." | "SAFE FROM WHO?" |
| LUCIDA | "breathe in. … who said that. not me." | "YOU DREAMED THIS FIRST" |

## 5. Sound

### 5.1 Two tracks at once
The master direction already asks for period service chimes on the corporate side and relay chatter on the hand-built side. This makes them two layers of the same piece of music, with bleed setting the mix:

- **Corporate track:** lush and reverberant, like a marble hall: exotica, theremin, organ, vibraphone. Each corporation has its own jingle and a **three-note service chime** as its sound logo.
- **Rustler track:** dry and close: 4-track cassette, tube amp, circuit-bent toys, oscillators, relays. In the fiction it's magnitizdat, dubbed tape to tape (§2.2.3).

| Bleed | Mix |
|---|---|
| 0 | Corporate track full; Rustler track barely there. |
| 0.2–0.6 | The corporate track picks up wow and flutter (slow pitch wobble, growing with bleed) and drifts out of tune; the Rustler track rises through it. |
| 0.8 | Strike: the corporate chime plays once, warmly, under the "We see you." modal. |
| 1.0 | The corporate jingle comes back **perfectly in tune and cheerful**, over a low drone stem; the Rustler track is loud and ragged. |

The reassuring chime meaning something else during a reveal is the master direction's idea; the in-tune jingle at Mask off is where it lands hardest.

### 5.2 Card sounds are mechanical
Every Rustler action sounds physical: cartridge seated (heavy click), Icepick dragged (cable scrape), subroutine broken (relay clunk), END TURN (toggle), Bloatware shuffled in (tape tear). Nothing on the Rustler side sounds digital.

### 5.3 The radio (later)
A hand-built radio on the map or DEAD DROP screen, tuning between corporate broadcasts (ads, newsreels, public safety notices) and pirate stations. Pirate stations can carry small useful rumours about upcoming Nodes, so listening pays off. Needs a rules decision about what the rumours may reveal (RUN-005 hidden contents); no build task yet. Pirate radio is the zine network's spoken cousin (§2.2).

## 6. World elements that feed the paranoia

1. **Ads that know you.** Loading and between-run screens show corporate ads written from the player's **real, local** play data: most-played card type, most-broken ICE, the corporation where they get traced most, how long they hesitate. *"We noticed you favour Icepicks. HALCYON Home has a plan for people like you."* Ads get more specific the more runs there are. Data never leaves the machine; a settings toggle turns the ads off.
2. **ICE react to hesitation.** Hovering one card for a long time (working: 4 s) gets a line from the ICE whose mood fits: cheery "Take your time!", wary "Still deciding?", lethal "WE CAN WAIT." Cooldown 20 s; at most one line per turn. Flavour only, never a penalty. The game shows it's watching *how* you play.
3. **LUCIDA edits the record.** In LUCIDA runs, flavour lines in the event log are quietly rewritten a turn or two after they appear ("You broke the THERAPIST." → "You rested here."). **Rules lines are never rewritten:** numbers, card names, damage, TRACE and anything needed for a decision stay exact (ADP-R1). A tiny zine mark (✎) shows where a line was changed, so the player can spot it.
4. **Two voices on one page.** Lore arrives as corporate ephemera (manuals, warranties, safety pamphlets, newsreel stills) with Rustler notes in the margins, and as underworld zines passed between crews (§2.2).
5. **The map is a defaced tourist map.** "Visit the City of Tomorrow!" in corporate print, with marker routes, crossed-out landmarks and warnings scrawled over plazas.
6. **DEAD DROP as a workbench.** *(Open conflict, NODE-AUTHORITY-001: PATCHWORK is a Console Lab service, so the soldering bench belongs to the Console Lab, or the DEAD DROP's bench must not imply a deck-engineering service; designer to choose. Concept only.)* A basement under a corporate tower; PATCHWORK upgrades shown as soldering a cartridge under a stolen HALCYON lamp (and attaching grafts, §3.1). A stack of zines and tapes from other crews on the bench, a rebuilt copier in the corner, maybe a bone-music record on the wall (§2.2.3); *THE CARBON*'s record of lost Rustlers is read here (ARCH-001).
7. **The crowd is too happy.** Small background figures in the corporate halls smile and wave, and now and then turn to follow the player a beat too long. Frequency grows with bleed.

---

## Part 3 — Build tasks for Codex

Build phase by phase, **each only after the designer approves it** (see §7). Log each step in `REDLINE_DEVELOPMENT_LOG.md` under **ADP-001**, note anything you had to invent as *Interpretations to confirm*, and record approved choices in `REDLINE_MASTER_DESIGN.md`. All numbers are tunable presentation values; put them in one data file (suggested `godot/data/atomic_deco_punk.json`). Names below are suggestions; adapt to the existing code. Re-run the rules suite after each task: **nothing in the rules changes**.

### Phase 1 — Bleed and sound (APPROVED 2026-11-17; testable in the HALCYON slice)

Designer: "2 yes".

| Step | What | Where (current code) | Done when |
|---|---|---|---|
| **ADP-1a** | **Bleed value** (ADP-R2): a pure function of TRACE, strikes and whether the strike modal is showing, using the curve in §2. Smooth changes over ~400 ms; instant with `reduced_motion`. Expose the value for every presentation system; never read by rules code. | Computed next to `corporation_state` in `scripts/ui/friendly_lie/encounter.gd` (`update_corporation()`); the curve in the data file. | Unit tests cover each row of the §2 table, the post-strike floor of 0.2, and reduced motion. A debug readout shows bleed in the playtest build. |
| **ADP-1b** | **Reveal follows bleed** (§2, approved): the `surveillance_layer` opacity follows bleed through Cracking, **20% at TRACE 20 to 60% at TRACE 39**, instead of a fixed 20%; Strike and Mask off still swap to the full hostile background as now. Keep the 20% and 60% ends in the data file. | `apply_background()` in `encounter.gd`. | TRACE 20 shows 20%, TRACE 39 shows 60%, values between are linear; Strike and Mask off look exactly as before. |
| **ADP-1c** | **Rig wear** (§3.4, updated for ZINE-001): a CanvasItem shader on zine panel surfaces, borders and shadows (toner speckle, shadow misregistration up to 2 px, edge darkening), scaled by bleed; plus simple overlays for lifting tape corners. Add a thin decorative barcode or punched-hole strip to the Node and TRACE tags (§2.1; no QR codes), which flickers faintly at high bleed. **Never applied to text nodes.** A cap for reduced motion (static speckle, no flicker). | Zine panels built in `encounter.gd` / `look.gd`; shader under `godot/themes/`. | Screenshots at bleed 0, 0.4 and 1.0 show the wear; every label still passes 4.5:1 contrast; no shader touches a glyph. |
| **ADP-1d** | **Two-track music** (§5.1): an `AudioStreamSynchronized` (Godot 4.3+) with stems *corporate*, *rustler* and *drone*. Stem volumes follow bleed. Wow and flutter on the corporate stem: a slow LFO on its pitch (±0 cents at bleed 0, up to about ±35 cents at 0.6), back to exactly in tune at 1.0. The corporate chime on strike. Separate music volume setting. **Placeholder stems:** short loops are fine (generated tones or simple synthesis); final music is out of scope. Record every source in `godot/audio/SOURCES.md`. | New `scripts/ui/friendly_lie/music.gd`; stems under `godot/audio/music/`. | In a scripted run from TRACE 0 to Mask off, the mix and detune audibly follow the §5.1 table; the stems stay in sync; the volume slider and mute work. |
| **ADP-1f** | **Poiret One** (§3.5): add `PoiretOne-Regular.ttf` and its OFL licence under `godot/assets/fonts/` (source: the `google/fonts` repository, `ofl/poiretone/`), recorded in the fonts `SOURCES.md`; add a `display_font` to the corporation skin; use it only in the places §3.5 lists, at 28 px or more. | `corporation_skin.gd`, `encounter.gd`, `assets/fonts/`. | HALCYON's wordmark, background headline and strike-modal headline use Poiret One; nothing under 28 px or on the Rustler side does; contrast passes 4.5:1. |
| **ADP-1e** | **Mechanical card sounds** (§5.2): sound hooks for card seated, Icepick drag, subroutine broken, END TURN, Bloatware shuffled in. Placeholder samples are fine. | `hand.gd`, `drop_target.gd`, `encounter.gd`. | Each action plays its sound once; no sound plays on hover alone. |

### Phase 2 — Voice (flavour text only; APPROVED 2026-11-17)

Designer: "Phase 2 absolutely approved." Build after Phase 1. **The copy for all three tasks is in `REDLINE_ADP_PHASE2_COPY.md`** (for the designer's approval; wire it up as written, with each line's approval status in the data so lines can be swapped or switched off).

| Step | What | Done when |
|---|---|---|
| **ADP-2a** | **Voice leaks** (§4.3): a data table of leak lines per corporation and bleed band; NUL/REM notes pick a leak line at the band's rate; graffiti decals (hand-lettered or stencil text in decorative zones only) appear on the background, toast and mascot shells. Use the §4.3 samples; write more in the same voice and log them for approval. | At bleed 0 nothing leaks; at 0.4 some notes and surfaces show leaks; at 1.0 a toast carries a scrawled reply. No leak or graffiti overlaps a rule, number or button (fixture check). |
| **ADP-2b** | **Hesitation lines** (§6.2): a hover timer per card (threshold 4 s, cooldown 20 s, max one per turn), shown in the speech bubble of the ICE with the highest mood. Disabled while dragging. | Hovering 4 s shows the right mood line; it never repeats within the cooldown; nothing in the game state changes. |
| **ADP-2c** | **Corporate flavour vocabulary** (§4.1): trademarked words in toasts and non-fight copy, patent plates on mascot shells, a newsreel line on the loading screen. | The HALCYON slice shows each at least once; the copy is logged for approval. |

### Phase 3 — Paranoia features (APPROVED 2026-11-17)

Designer: "for #3 yes i want two deliberately unsettling features" (3a, 3b) and "GRAFTS - yes - it's a great extension of the theme to salvage ice parts on upgraded cards" (3c). Build after Phase 1.

| Step | What | Done when |
|---|---|---|
| **ADP-3a** | **Ads that know you** (§6.1): a local stats file (`user://redline_stats.json`) updated at encounter and run end; ad templates per corporation with slots for those stats; shown on loading and between-run screens; an "Ads that know you" toggle in settings next to Reduced motion (`main.gd`), default on. Nothing is sent off the machine. | With seeded stats, ads fill their slots correctly; with the toggle off, no ads show and no stats are read for them; deleting the file resets them. |
| **ADP-3b** | **LUCIDA record edits** (§6.3): event log entries are tagged *rules* or *flavour*; in LUCIDA encounters, flavour entries may be rewritten 1–2 turns later from a table, with a ✎ mark. Rules entries are never touched. | A test proves no rules-tagged entry can be rewritten; a LUCIDA fixture shows a rewritten line with its mark. (The LUCIDA slice doesn't exist yet; build the tagging now and the rewrite when LUCIDA is playable.) |
| **ADP-3c** | **Grafts** (§3.1): record which ICE parts the player broke this run; when PATCHWORK is applied, offer or assign one graft as an art layer on that card instance; save it with the instance. Needs graft overlays for the HALCYON slice parts (CAPTCHA eye, DOORBELL CAM lens, AUTO-RENEW chip) in the Rustler treatment. | A grafted card keeps its graft through save/load and the other copies don't get it; the card's rules text and readability are unchanged. |

### Phase 4 — Fixtures

| Step | What | Done when |
|---|---|---|
| **ADP-4a** | Screenshot fixtures (alongside the existing `godot/tests/shot_*.gd`): bleed 0, 0.4 and 1.0 on the HALCYON CAPTCHA encounter; a leak note and graffiti; a hesitation line; an ad (if Phase 3 is built); a grafted card. A short audio capture of the bleed sweep (ADP-1d). | Fixtures render; tests pass; PNGs (and the audio clip) attached to the PR or commit so the designer can review them on a phone. |

**Out of scope for now (need art, rules or a designer choice first):** the HUD seam (§3.2), industrial background layers (§3.3, goes into the next art briefs), the Deco display face (§3.5), the radio (§5.3), annotated lore ephemera, underworld zines, tapes and *THE CARBON* between runs (§2.2; the defeat-screen CARBON page and record are built under ARCH-001), the defaced tourist map, the DEAD DROP workbench and the crowd (§6.4–6.7), final music and sound design.

---

## 7. Questions for the designer

1. ~~Adopt ADP-R1?~~ **Yes (2026-11-17)**, with the zine redefined (§2.1).
2. ~~Approve Phase 1?~~ **Yes (2026-11-17).**
3. ~~Ads from real play data, LUCIDA rewriting the record, grafts?~~ **Yes to all three (2026-11-17).**
4. ~~Should the hostile reveal grow with bleed?~~ **Yes, 20% to 60% (2026-11-17).**
5. ~~Display face?~~ **Poiret One, for corporate headlines (2026-11-17).**
6. ~~Should punch cards ever mean something in play?~~ **Yes: the three First Signal punch cards (SIGNAL-001, §8), now approved.**
7. ~~Approve Phase 2?~~ **Yes (2026-11-17).**
8. ~~Approve the punch-card presentation and Phase 5? Names?~~ **Yes; names SYNCHRONIZATION SCRAMBLER / SCRAMBLE SYNC and M0'B\*L∞P (2026-11-17).**
9. ~~Is the umbrella AI the hidden AI?~~ **Yes (2026-11-17).**
10. ~~Rename the style to atompunk?~~ **No: Atomic Deco Punk stays; atompunk is the outward shorthand (§1.1, 2026-11-18).** The zine is the underworld's communication network, in samizdat's lineage, and the reasons it exists are explicit (ZINE-002, §2.2). *THE CARBON*, the §2.2.3 practices and the anti-paper lines are approved (ARCH-COPY-001, 2026-11-18); the other §1.1 and §2.2 examples are working ideas, for approval when they reach a build phase.

No questions are open in this doc. Build order: **Phase 1 → Phase 2 → Phase 3 → Phase 5**, with Phase 4 fixtures added as each phase lands.

---

## 8. SIGNAL-001 — The three punch cards (APPROVED, 2026-11-17)

**The designer's direction:**

> "Since this game is about the first signal (as one of the central themes) the player could be collecting 1 of 3 punch cards from each corporation in order to process an uplink signal that jams the umbrella corporation's signal that would finalize the merging of man and machine."

### 8.1 What's decided (designer, 2026-11-17)

| Question | Answer |
|---|---|
| How many cards? | **One per corporation, three in total.** Designer: "Yes." |
| What does the player know, and when? | **The purpose stays hidden until the end.** Designer: "yes." This keeps RUN-006: the Rustler doesn't know what the data means or who's behind it. |
| The umbrella | **"Umbrella" is a description, not a name: it's an AI that controls all three corporations.** Designer: "it really is an AI who controls all corporations, it is unknown until after all 3 cards are attained." |
| Its signal and the First Signal | **The First Signal is the first sign of consciousness in any being, from the cellular level to the macro.** In the game, the First Signal being referred to is the **machines' attempt to reach a higher consciousness by merging with humanity.** There have been many attempts through history. **Speech synthesis** was the machines' main method, which is why NUL/REM keeps referring to it; eventually they decided the way was **synchronization with humans**. Keep it vague until the end. |
| Names | **The jamming signal is the SYNCHRONIZATION SCRAMBLER**, "SCRAMBLE SYNC" for short (the command the Rustler runs). Designer: "more important-sounding names, like Synchroniztion-Scrambler or scramble sync". **The hand-built device that reads the three cards is the M0'B\*L∞P**, pronounced "Mow Bee Loop" (after the Möbius-strip foil antenna, ZINE-001). Designer: "let's call it something punk, like M0'B\*Loop, pronounced Mow Bee Loop. With the oo's in loop looking like an 8 on its side to represent the loop." Neither clashes with the Black Market Uplink. See §8.4 for how to write and render the name. |
| Is jamming right? | **The game leaves doubt.** Designer: "it could be all 3" (evolution, liberation, assimilation). **The Rustler jams it because going against whatever the corporations want is the Rustler's MO**, not because the game says it's right. |
| Can cards be lost or vary? | **No, for now.** Each run is discrete (roguelike), and each corporation always gives the same card: HALCYON's card, IRONWATCH's card, LUCIDA's card. |

**Fit with existing canon:**
- The Bible's guidepost *"Every consciousness has a first signal"* (a recurring threshold where awareness begins or reaches another) is the general idea; the AI's attempt to synchronize with humans is the instance the game is about. STORY-001 (a real synchronization transmission) still holds: it's the AI's.
- NUL/REM's speech-synthesis references (the Speak & Spell lines, the vocoder idle line) are now seeds of the reveal. One approved line already reads, about a decrypted fragment: *"E.T. phoned home with a Speak & Spell, an umbrella and a coffee can."* The word "umbrella" is already planted.
- **The samizdat lineage (§2.2) fits the ending:** a world where every channel listens is the world a synchronizing AI would build, and the jam is sent by a device made from paper, foil and relays, the underworld's own medium.
- **The Archipelago (ARCH-001, APPROVED 2026-11-18, `REDLINE_ARCHIPELAGO.md` §4.1):** the traced are taken to islands where the AI merges people with the machine one at a time; each merge builds the synchronization signal. Secret until the third card.
- **The umbrella AI is the hidden AI** in the master doc's §8 story questions (confirmed by the designer, 2026-11-17: "yes it is.").

### 8.2 Writing rules until the end

- **Before the third card,** nothing on screen names the AI, says it controls the corporations, or explains the cards, the merge or the SYNCHRONIZATION SCRAMBLER. The cards are "the data" or "the job".
- **Hints are allowed** and should be oblique: speech synthesis, machine voices, old transmissions, the holes lining up, corporate copy that sounds a little too similar across all three corporations ("We'll take care of it." / "You're in good hands." / "Rest easy."). Nothing a player could take as an explanation. Underworld zines (§2.2) can carry these hints too.
- **After the third card,** the reveal, in two parts: the three corporations are one AI's faces, and it's about to complete the synchronization; **and** the Archipelago is where it has been rehearsing the merge on the people it took, including the player's lost Rustlers (ARCH-001 §4.1). Even then, the game doesn't say whether that would be evolution, liberation or assimilation. NUL/REM can doubt; the Rustler chooses to jam it anyway, because that's what Rustlers do.
- The unknown employer (RUN-006) stays open; this doesn't decide who hired the Rustler.

### 8.3 Presentation (APPROVED, 2026-11-17)

Designer: "approved".

- **Each card is a corporate artefact:** that corporation's card stock, colour, emblem and patent print (HALCYON mint and silver, IRONWATCH navy and brass, LUCIDA lilac and rose-copper), carrying holes that look older than the print.
- **Arrival:** on BREACH of a corporation's central Node, the card comes out of the core's slot or a pneumatic tube (§3.3) as a physical object, with a NUL/REM line (EV-33 lines fit).
- **The holder:** a three-slot card holder taped to the zine HUD, "1/3", "2/3", "3/3". (RUSTLER-LOOK-001 keeps the HUD as it is; this is a small addition to it, for approval.)
- **The holes line up.** When the cards are shown stacked, their holes start forming one pattern; it's only complete with all three. The player can see they belong together long before knowing why.
- **The end:** after the third card, the reveal (§8.2), then the M0'B\*L∞P is assembled from paper, foil and relays, reads the three cards and sends the SYNCHRONIZATION SCRAMBLER. This sequence needs its own script and storyboard; not part of the first build.

---

### 8.4 Writing and rendering M0'B\*L∞P

- **In docs and code text** write it `M0'B*Loop` (ASCII, so it's searchable); in code identifiers use `moebloop`.
- **On screen** it's a wordmark: capital M, the digit zero, apostrophe, capital B, asterisk, then "L", the **two o's drawn as one sideways 8 (∞)**, then "P": **M0'B\*L∞P**. Rustler style (Space Mono or hand-stencilled), never Poiret One: it's a Rustler device.
- If the font has no ∞ glyph, draw the wordmark as an image or a custom-drawn glyph; don't fall back to a mismatched font.
- **Accessibility:** wherever the wordmark is an image or uses ∞, give screen readers and subtitles the spoken name "Mow Bee Loop"; voice lines say "Mow Bee Loop".

---

## Part 3b — Build tasks for SIGNAL-001 (Phase 5, APPROVED 2026-11-17)

Same rules as Part 3: log under **SIGNAL-001** in `REDLINE_DEVELOPMENT_LOG.md`; nothing in the encounter rules changes.

| Step | What | Done when |
|---|---|---|
| **SIG-5a** | **Card data and run state:** one fixed punch-card definition per corporation (id, corporation, hole pattern, art references); the run records which cards the Rustler holds; a card is awarded on BREACH of that corporation's central Node; a new run starts with none. No loss, no variation (§8.1). | Tests: each corporation awards its own card exactly once per run; cards survive save/load within a run; a new run has none. |
| **SIG-5b** | **Hole patterns:** three 12-column × 8-row hole patterns, designed so each one alone looks like ordinary data and the three stacked form one recognisable figure (placeholder figure is fine; the designer picks the final one). | A fixture shows each card alone and the three stacked. |
| **SIG-5c** | **Card holder and arrival** (§8.3): the three-slot holder on the HUD; the arrival animation and NUL/REM line on BREACH; reduced-motion version. Placeholder card art in each corporation's colours. | Screenshots: holder at 0/3, 1/3 and 3/3; the arrival on a HALCYON central-Node BREACH. |
| **SIG-5d** | **Writing guard** (§8.2): every line that mentions the AI, the merge or the SYNCHRONIZATION SCRAMBLER is tagged `reveal`; a test fails if a `reveal` line can show before the third card. | The test passes, and fails when a `reveal` line is wired to an earlier trigger. |

**Out of scope for now:** the end sequence (reveal, M0'B\*L∞P assembly, SCRAMBLE SYNC), and the final card art and hole figure.


---

## Source 5: [docs/visual/concept-art/UI_KIT_BRIEF.md](https://github.com/Punkwork/REDLINE/blob/8ef0bbe15ccd7eb7cf44f3ca8aaf98c910ee41c7/docs/visual/concept-art/UI_KIT_BRIEF.md)

# ENC-CONCEPT-001 — UI kit brief for ChatGPT (painted interface parts)

**Date:** 2026-11-19 · **Author:** Claude · **For:** the designer, to give to ChatGPT
**Goal:** the encounter screen should look like the three ChatGPT concept screens. Those are painted, so the interface is built from **painted parts** that the game assembles. The game then draws everything that changes on top: names, numbers, rule text, lamp states and key icons. That keeps the rules exact and every value live.

Mascots and card art have their own brief: `ART_BRIEFS.md`.

---

## How to use this in ChatGPT

1. Start one conversation. Attach the three concept images:
   - `ICE_ANALOG_CONCEPT_03_ENCOUNTER_TOOLTIP.png` (**the main reference**: frame, consoles, keys, tooltip, END TURN)
   - `ICE_ANALOG_CONCEPT_02_INSTRUMENT_KEYS.png` (the left monitor and vitals, the key states)
   - `ICE_ANALOG_CONCEPT_01_HALCYON.png` (extra detail)
2. Paste **Message 1** below once.
3. Then paste the parts one at a time (§2–§8). After each one, check it against the checklist in §9, then download it with the exact file name.
4. Attach the finished PNGs in Claude, or commit them to `godot/assets/concept/ui/`.

### Message 1 (paste once at the start)

> I'm building the interface for a video game called PANOPTICON. The three attached images are the target look; image 3 is the main reference. I need you to paint the interface as **separate game-UI parts**, one image per request, so a game engine can assemble them. Rules for every part:
> - Same art style, materials and lighting as the reference: 1950s–60s atompunk instrument panels: seafoam-mint enamel, polished chrome bezels with rivets, warm brown bakelite and copper, cream enamel plates, black glass, brass details, small jewel lamps. Soft studio light from the top left, gentle wear, slight print grain.
> - **Front-on, flat, orthographic view.** No perspective, no tilt, no scene around it.
> - **Transparent background** unless I say otherwise.
> - **Absolutely no text, letters, numbers, logos or icons** unless I ask for an icon. Leave plates and labels **blank**; the game writes on them.
> - Keep the **middle of stretchable parts plain**, with all ornament (rivets, bevels, corner details) near the edges, so the part can be stretched without distortion.
> - Exact pixel size as I give it.
> Reply "ready" and wait for the first part.

---

## 2. Screen frame and backdrop

| File | Size | Prompt (after Message 1) |
|---|---|---|
| `UI_FRAME.png` | 3200 × 2000 | The outer frame of the whole screen: a border of brown copper pipes, valves, brass fittings and riveted bakelite running around all four edges, about 60 px thick on the sides and bottom and 40 px at the top, like image 3. **The whole centre is transparent.** |
| `UI_BACKDROP_MACHINE.png` | 3200 × 2000 | A dim background of warm brown machinery and copper pipes behind the panels, softly out of focus, darker toward the edges, no bright spots in the middle. Not transparent. *(A placeholder until each corporation gets its own background.)* |

## 3. Top bar

| File | Size | Prompt |
|---|---|---|
| `UI_TOPBAR.png` | 3200 × 200 | The long top bar from image 3: dark brown bakelite with a chrome trim line along the bottom and rivets at the ends. **Plain in the middle** (it stretches). No plates on it. |
| `UI_PLATE_CREAM.png` | 480 × 72 | A blank cream enamel label plate with rounded corners, a thin chrome rim and a tiny screw at each end, like the "HALCYON NETWORK // NODE" plate in image 3. Plain centre. |
| `UI_PLATE_DARK.png` | 480 × 72 | The same plate in **black glass** with a chrome rim, like the ICE name plates ("AUTO-RENEW") in image 3. Plain centre. |
| `UI_PILL_GREEN.png`, `UI_PILL_RED.png`, `UI_PILL_BLACK.png` | 400 × 64 each | A blank glossy enamel pill-shaped status plate with a chrome rim, like "CONDITION: FRIENDLY" in image 3; one image each in green, red and black. |
| `UI_FLIP_TILE.png` | 64 × 96 | One **blank** split-flap card from the TURN/TRACE counters in image 3: dark rounded card, the horizontal split line across the middle, small metal hinge pins at both ends of the split. |
| `UI_LOGO_EMBLEM.png` | 128 × 128 | Just the small round emblem from the PANOPTICON logo in image 3 (the eye/target), brass and red. No lettering. |

## 4. ICE console

| File | Size | Prompt |
|---|---|---|
| `UI_ICE_CONSOLE.png` | 960 × 1100 | One empty ICE console from image 3: a seafoam-mint enamel cabinet with a thick polished chrome rim and rivets, rounded top corners, and a small **arched tab** centred on the top edge (blank, for the company name). Inside the top half, a recessed darker-mint **window** where a character will peek out; leave it empty. The bottom half is plain mint panel (the game places keys and plates there). Plain sides so it can stretch vertically. Transparent outside the cabinet. |
| `UI_POWER_LAMP_ON.png`, `UI_POWER_LAMP_OFF.png` | 48 × 48 | The small round green power lamp next to the ICE name in image 3: lit and glowing, then unlit. |
| `UI_STR_PLATE.png` | 200 × 96 | The blank cream plate that holds "STR 6" in image 3, with a chrome rim. |
| `UI_BADGE_UP.png`, `UI_BADGE_DOWN.png` | 72 × 72 | The small rounded badge beside STR: green (for ↑) and red (for ↓). Blank, no arrow. |
| `UI_REEL_WINDOW.png` | 160 × 400 | The vertical slot-machine reel window beside the CAPTCHA keys in image 3: black glass inside a chrome housing, with small up/down arrow bumps top and bottom. Empty glass. |
| `UI_CHEVRON.png` | 32 × 48 | The small brass arrow between keys in image 3, pointing right. |

## 5. Instrument keys (the subroutine buttons)

Each key is a rounded-square button, **128 × 128**, front-on, with its face blank (the game draws the icon and number). Make all of them in one style so they match.

| File | Prompt |
|---|---|
| `UI_KEY_READY.png` | Cream enamel key cap in a chrome bezel, slightly domed, like the "3" key in image 3. Blank face. |
| `UI_KEY_HIT.png` | The same key glowing: warm pink-red face with a soft red glow around the bezel (the "biggest hit" key in image 3). |
| `UI_KEY_DEADLOCK.png` | The same key as a glossy red push-button. Blank face (no padlock). |
| `UI_KEY_DEADLOCK_OPEN.png` | The same key as a green push-button, pressed slightly in. Blank face. |
| `UI_KEY_BROKEN.png` | The same key dull and grey, unlit. |
| `UI_KEY_HIDDEN.png` | The same key in black glass with a dashed outline. |
| `UI_KEY_TUMBLED.png` | The cream key with an amber glowing ring (newly tumbled in). |
| `UI_KEY_LAMP_GREEN.png`, `UI_KEY_LAMP_RED.png`, `UI_KEY_LAMP_AMBER.png`, `UI_KEY_LAMP_OFF.png` | 40 × 40 each: the tiny jewel lamp that sits above each key in image 3, in each colour and unlit. |
| `UI_BW_CHIP.png` | 120 × 44: the small dark rounded tag under each key that shows its cost. Blank. |

### Icons (drawn on the keys and plates)

**Format:** 128 × 128, transparent, **one solid dark-brown ink colour**, bold simple shapes like the key icons in image 2. One icon per file.

`ICON_PULP.png` (starburst), `ICON_TRACE.png` (a small planet with a tilted orbit ring), `ICON_DEADLOCK.png` (closed padlock), `ICON_DEADLOCK_OPEN.png` (open padlock), `ICON_DISCARD.png` (a card with an arrow leaving it), `ICON_INSERT.png` (an envelope), `ICON_BW_DRAIN.png` (a radio antenna with a minus sign), `ICON_CORTEX.png` (a stylised brain), `ICON_FORGET.png` (a card sliding under a deck), `ICON_HIDDEN.png` (a question mark), `ICON_BOOTING.png` (a padlock with a small clock), `ICON_TIMING.png` (hourglass), `ICON_BREAK.png` (wrench), `ICON_PASSIVE.png` (lightning bolt).

## 6. Tooltip

| File | Size | Prompt |
|---|---|---|
| `UI_TOOLTIP_PLATE.png` | 720 × 560 | The rule plate from image 3: a cream enamel plate with a polished chrome rim and screws in the corners, a thin pointer on its left edge. Blank. Plain centre so it stretches. |
| `UI_TOOLTIP_STAND.png` | 200 × 260 | The chrome stand the plate sits on in image 1 (a short chrome post and round foot). |

## 7. Left monitor and vitals (image 2, with image 3 touches)

| File | Size | Prompt |
|---|---|---|
| `UI_CRT_MONITOR.png` | 448 × 520 | The left-hand monitor from image 2: a brown bakelite cabinet with a rounded CRT screen, two knobs and a vertical row of small lamps beside the screen, a speaker grille below. **The screen glass is plain dark green and empty.** |
| `UI_VITALS_PANEL.png` | 448 × 400 | The vitals panel under the monitor in image 2: a dark bakelite plate with chrome trim and rivets, with **five empty horizontal rows** (each a recessed slot for an icon, a label and a gauge). No icons, no text. |
| `UI_GAUGE_TRACK.png` | 340 × 28 | An empty recessed gauge track (black glass in a chrome rim) for a segmented bar. |
| `UI_GAUGE_SEG_RED.png`, `_AMBER.png`, `_BLUE.png`, `_ORANGE.png`, `_OFF.png` | 28 × 20 each | One glowing segment of the bar in each colour, and an unlit segment. |
| `ICON_VITAE.png`, `ICON_BW.png`, `ICON_SHIELD.png`, `ICON_DRAW.png` | 96 × 96 each | Small coloured enamel badge icons like image 2: a red heart, a yellow lightning bolt, a blue shield, two stacked cards. |
| `UI_PUNCH_HOLDER.png` | 448 × 64 | A small bakelite holder with three empty card slots (for the three punch cards). |

## 8. Buttons

| File | Size | Prompt |
|---|---|---|
| `UI_END_TURN.png`, `UI_END_TURN_HOVER.png`, `UI_END_TURN_PRESSED.png`, `UI_END_TURN_DISABLED.png` | 256 × 256 each | The big round red mushroom button from image 3, in a thick chrome ring. **Blank face** (the game writes END TURN). Normal; slightly brighter; pressed in and darker; dull brown-grey. |
| `UI_BUTTON.png`, `UI_BUTTON_HOVER.png`, `UI_BUTTON_PRESSED.png` | 448 × 64 each | A wide bakelite push-button with a chrome edge, for DECK, END RUN and VIEW. Blank. Plain centre. |

---

## 9. Checklist for every file

- Transparent background (except `UI_BACKDROP_MACHINE.png`).
- **No text, letters or numbers anywhere.**
- The exact pixel size and the exact file name.
- Front-on and flat; the same light and materials as the rest.

## 10. Order

Start with the parts that change the look most: `UI_ICE_CONSOLE`, the seven `UI_KEY_*` states, `UI_TOPBAR`, `UI_CRT_MONITOR`, `UI_VITALS_PANEL`, `UI_END_TURN`, `UI_TOOLTIP_PLATE`, `UI_FRAME`, `UI_BACKDROP_MACHINE`. Then the small pieces and icons. Claude wires each file in as it arrives and sends screenshots. Until a part exists, the game keeps drawing that part itself.


---

## Source 6: [docs/visual/concept-art/UI_KIT_BRIEF_2.md](https://github.com/Punkwork/REDLINE/blob/8ef0bbe15ccd7eb7cf44f3ca8aaf98c910ee41c7/docs/visual/concept-art/UI_KIT_BRIEF_2.md)

# ENC-CONCEPT-001 — UI kit brief 2 for ChatGPT (the rest of concept 2)

**Date:** 2026-11-19 · **Author:** Claude · **For:** the designer, to paste into ChatGPT
**Why:** the designer likes how concept 2 (`docs/visual/explorations/ice-analog-001/ICE_ANALOG_CONCEPT_02_INSTRUMENT_KEYS.png`) fills the screen with useful UI in good proportions. Kit 1 (`UI_KIT_BRIEF.md`) is delivered and wired. This kit covers the concept-2 parts we don't have yet. Same rules as kit 1: the game writes every name, number and rule; the art stays blank.

Already delivered in kit 1, so **not** requested again: STR ↑/↓ badges (`UI_BADGE_UP/DOWN`), the green unlocked key (`UI_KEY_DEADLOCK_OPEN`), the hidden key (`UI_KEY_HIDDEN`), the BOOTING icon (`ICON_BOOTING`).

How to use: in the same ChatGPT conversation as kit 1 if you still have it (otherwise a new one), attach concept 2 and paste the prompt below once. Type **next** after each image. Download each one with the exact file name and put them in the `PANOPTICON art` folder.

---

## Prompt (paste once)

```
I'm continuing the painted interface parts for my game PANOPTICON. The attached image (concept 2) is the reference for this batch. Same rules as before for every part:
- Same style, materials and light as the reference: 1950s–60s atompunk instrument panels: seafoam-mint enamel, polished chrome bezels with rivets, warm brown bakelite and copper, cream enamel plates, black glass, brass, small jewel lamps. Soft light from the top left, gentle wear, slight print grain.
- Front-on, flat, orthographic. No perspective, no scene around it.
- Transparent background unless I say otherwise.
- NO text, letters, numbers or logos anywhere. Leave plates blank; the game writes on them.
- Stretchable parts: keep the middle plain and the ornament near the edges.
- Exact pixel size and exact file name.

Make these ONE AT A TIME, in this order. After each, wait until I type "next".

1. UI_BRAND_PLATE.png — 560 × 160. The top-left PANOPTICON plate from the reference: a dark bakelite plate with a chrome rim and a brass starburst emblem on the left end. The rest of the plate is blank for the game to write the name and a small subtitle under it.

2. UI_CORP_PLATE.png — 480 × 160. The top-right corporation sign from the reference (where "HALCYON Computing" sits): a mint-and-cream enamel sign in a chrome frame, with an empty area for a script name. Blank.

3. UI_ALARM_PLATE.png and UI_ALARM_PLATE_HOT.png — 400 × 120 each. The HOSTILE REVEAL warning box from the reference: a red glass alarm panel in a black-and-chrome frame with small corner screws. One calm (dim red), one hot (bright red with a glow). Blank.

4. UI_CRT_SCREEN_FRIENDLY.png, UI_CRT_SCREEN_CRACKING.png, UI_CRT_SCREEN_STRIKE.png, UI_CRT_SCREEN_MASKOFF.png — 344 × 280 each, NOT transparent. The picture inside the left monitor: a glowing green CRT image of a corporate city skyline with tall office towers (Friendly, like the reference left half). Then the same skyline in pink-magenta with scanline glitches (Cracking, like the right half), in amber with a warning-stripe flicker (Strike), and in deep red with heavy static (Mask off). Leave the top third of the screen fairly dark and plain; the game writes status text there.

5. UI_LAMP_STACK.png — 48 × 200. The vertical column of three small jewel lamps beside the monitor (green, amber, red), unlit, in a brass strip.

6. UI_KNOB.png — 96 × 96. One round bakelite control knob with a chrome ring and a pointer line, seen straight on.

7. UI_VENT_GRILLE.png — 240 × 80. A horizontal bakelite speaker/vent grille with chrome slats. Stretchable sideways.

8. UI_SLOT_PANEL.png — 240 × 120. The small "SUPPORT" box from the reference: a dark bakelite mini-panel with a chrome rim, a recessed round well on the left for an icon and a small black window on the right for a counter. Blank.

9. UI_SPEECH_BUBBLE.png — 400 × 240. The hand-drawn comic speech bubble from the reference ("Premium Plan!"): cream paper with a bold ink outline and a short tail at the bottom-left. Blank inside, plain centre so it stretches. Also UI_SPEECH_BUBBLE_ALT.png: the same with the tail at the bottom-right.

10. UI_TUMBLER_DRUM.png — 240 × 480. The slot-machine drum housing around CAPTCHA's keys in the reference: a chrome-and-black-glass housing with a lit window in the middle (for the live key) and dimmed glass above and below it (where the hidden layers show), small brass pointer arrows at the sides of the middle window. Empty.

11. UI_HAND_TRAY.png — 3200 × 360. The recessed copper-and-bakelite rail along the bottom of the reference that the cards sit in: a long tray with a chrome lip along the top edge and rivets at the ends. Plain in the middle (it stretches). The right end has a raised square housing (empty) where the END TURN button sits.

12. UI_END_TURN_BOX.png, UI_END_TURN_BOX_HOVER.png, UI_END_TURN_BOX_PRESSED.png, UI_END_TURN_BOX_DISABLED.png — 320 × 360 each. The END TURN button from the reference: a red mushroom plunger on top of a chunky bakelite box with a blank cream label plate on the front. Normal; plunger slightly brighter; plunger pressed down and darker; plunger dull grey-brown. Blank label.

13. UI_LEGEND_CARD.png — 560 × 480. The key legend panel from the bottom-right of the reference: a dark bakelite card with a chrome rim and corner screws, with SIX empty rows, each with a small recessed spot on the left for a lamp and a blank strip for text. No text, no lamps.

Reply "ready" and then make part 1.
```

---

## Checklist for each file

- Transparent background (except the four CRT screens).
- No text, letters or numbers anywhere.
- Exact size and file name; front-on and flat; same light and materials as kit 1.

## What the game does with them

- **Top bar:** brand plate (game writes PANOPTICON and the tier), corp sign (game writes the corp name), alarm plate (game writes HOSTILE REVEAL and the %; the hot version from 40%).
- **Left:** the CRT shows the picture for the current condition under the status text; lamps, knobs and vent fill the monitor's side; the slot panel holds the punch-card count or installed Programs (SUPPORT is not one of our rules).
- **ICE:** mascot lines use the comic bubble; TUMBLER ICE get the drum housing.
- **Bottom:** the hand sits in the tray and the END TURN box moves into the tray's right end. With the tray in place the empty floor between the ICE and the hand shrinks, closer to concept 2's proportions.
- **Help:** the legend card becomes a toggleable help panel (and could serve a first-encounter tutorial); the game draws the lamps and writes the six meanings.
- Each part falls back to the current drawing until its file exists. Presentation only.


---

## Source 7: [docs/visual/concept-art/UI_KIT_BRIEF_3.md](https://github.com/Punkwork/REDLINE/blob/8ef0bbe15ccd7eb7cf44f3ca8aaf98c910ee41c7/docs/visual/concept-art/UI_KIT_BRIEF_3.md)

# ENC-CONCEPT-001 — UI kit brief 3 for ChatGPT (layout parts for concept 2)

**Date:** 2026-11-19 · **Author:** Claude · **For:** the designer, to paste into ChatGPT after kit 2
**Why:** the designer wants ChatGPT to paint as much of the interface as possible so the encounter matches concept 2 (`ICE_ANALOG_CONCEPT_02_INSTRUMENT_KEYS.png`) as closely as it can, with Claude doing the layout pass once the images are in. Kit 2 (`UI_KIT_BRIEF_2.md`) covers the parts that are visible in concept 2. Kit 3 covers the gaps found in the comparison: a console with concept 2's inner layout, homes for information the rules need but concept 2 leaves out (strikes, reserve, CRED/RAM, deck, discard, END RUN, the NUL/REM note), and the copper pipework that ties the panels together.

*Interpretation to confirm:* where the extra information goes (small dials in the top bar; deck, discard and END RUN in the hand tray; the NUL/REM note as a slip tucked behind the CRT) is Claude's suggestion, not yet approved.

How to use: same conversation as kit 2, with concept 2 still attached. Paste once; type **next** after each image.

---

## Prompt (paste once)

```
Next batch of painted interface parts for PANOPTICON, same reference image and same rules as before: same atompunk style, materials and light; front-on and flat; transparent background unless I say otherwise; NO text, letters, numbers or logos; stretchable parts plain in the middle; exact size and file name.

Make these ONE AT A TIME, in this order. After each, wait until I type "next".

1. UI_ICE_CONSOLE_2.png — 960 × 1000. An ICE console laid out exactly like the consoles in the reference: seafoam-mint enamel cabinet, thick polished chrome rim with rivets, rounded corners. NO window and no arched tab. The top-left 55% is open plain mint panel (a character will stand there and lean over the rim). Top-right: an empty recessed slot for a black name plate, and under it an empty recessed slot for the STR plate. The middle third is a slightly darker recessed mint band (the keys sit there). The bottom is plain mint (the game puts two cream text plates there). Small speaker slots at the left edge of the middle band, like CAPTCHA's console in the reference.

2. UI_KEY_BIG_FRAME.png — 200 × 240. The recessed chrome socket that each big key sits in, with a tiny jewel-lamp hole centred above it and a small dark tag recess below it. Empty socket.

3. UI_TURN_PLATE.png — 360 × 120. The "CORPORATION RESPONSE / TURN" plate from the top of the reference: a small cream label strip on top and a dark window below it for two flip digits, all in one chrome-rimmed brown plate. Blank.

4. UI_TRACE_COUNTER.png — 420 × 120. The big TRACE counter from the reference: a dark bakelite housing with a blank label area on the left and a deep window on the right for two large flip digits plus a small "/max" area. Blank.

5. UI_DIAL.png — 120 × 120. A small round instrument dial: cream face with tick marks around the edge (no numbers), chrome bezel, a black needle pointing straight up. Also UI_DIAL_NEEDLE.png — 120 × 120: just the black needle on its own, centred, pointing up, so the game can rotate it.

6. UI_STRIKE_LAMP_ON.png and UI_STRIKE_LAMP_OFF.png — 56 × 56. A round red warning lamp in a chrome cup: glowing, and unlit dark red.

7. UI_NOTE_SLIP.png — 440 × 360. A small typed paper slip, slightly creased, held by a brass clip at the top-left corner, tilted about 3 degrees, cream paper with a faint coffee ring. Blank (the game types the message). It will look tucked behind the left monitor.

8. UI_DECK_WELL.png and UI_DISCARD_WELL.png — 200 × 260 each. Recessed bakelite card wells that sit in the hand tray: the deck one with a short stack of face-down cards in it, the discard one empty with a small chrome lip. No text.

9. UI_CARD_BACK.png — 328 × 460. The back of a PANOPTICON playing card in the same white-card style as the cards in the reference: cream-white with a bold atompunk starburst-and-eye pattern in mint, coral and brass. No text.

10. UI_TRAY_BUTTON.png, UI_TRAY_BUTTON_HOVER.png, UI_TRAY_BUTTON_PRESSED.png — 280 × 96 each. A small chunky bakelite push-button that sits in the hand tray, with a blank cream label plate on the front. Normal; slightly brighter; pressed in and darker.

11. UI_TOGGLE_ON.png and UI_TOGGLE_OFF.png — 120 × 64. A small chrome toggle switch on a brass plate: flipped up, and flipped down.

12. UI_PIPE_H.png — 400 × 48 (copper pipe, horizontal, plain so it stretches). UI_PIPE_V.png — 48 × 400 (the same, vertical). UI_PIPE_ELBOW.png — 96 × 96 (a 90-degree copper elbow joint, going right and down). UI_PIPE_VALVE.png — 120 × 120 (a brass valve wheel on a pipe joint). UI_PIPE_GAUGE.png — 120 × 120 (a small pressure gauge on a pipe joint, blank face). All like the pipes between the panels in the reference.

13. UI_SCREW.png — 32 × 32 (one chrome panel screw head). UI_RIVET.png — 24 × 24 (one copper rivet).

14. UI_KEY_GLOW.png — 200 × 200. A soft warm-amber halo, brightest at the edges of a rounded-square shape and fading outward, transparent in the middle. It shows behind a key when the player hovers it.

15. UI_TICKER.png — 1600 × 56. A thin black-glass readout strip in a chrome frame with tiny screws at the ends, for one line of scrolling log text. Plain in the middle (it stretches).

16. UI_VIGNETTE.png — 3200 × 2000, transparent in the middle fading to a warm dark brown at all edges and corners, for darkening the screen edges.

Reply "ready" and then make part 1.
```

---

## What the game does with them

- **Console:** `UI_ICE_CONSOLE_2` replaces the windowed console; the mascot stands top-left and leans over the rim, name and STR stack top-right, big keys sit in `UI_KEY_BIG_FRAME` sockets with `UI_KEY_GLOW` on hover, PASSIVE and NEXT RESPONSE plates at the bottom.
- **Top bar:** brand plate · TURN plate · TRACE counter · alarm plate · corp sign, with strikes as `UI_STRIKE_LAMP`s and reserve and CRED/RAM as small dials.
- **Left:** the NUL/REM note is a slip tucked behind the CRT.
- **Bottom:** the hand tray holds the deck well, the hand, the discard well, tray buttons (DECK / COVERAGE, END RUN, VIEW) and the END TURN box. Reduced motion and VOICE become toggles. The log is a one-line ticker.
- **Glue:** pipes, valves, gauges, screws and rivets fill the gaps between panels, and the vignette darkens the edges so the bright parts stand out.
- Each part falls back to the current drawing until its file exists. Presentation only.


## CHAIN-002 — Foundational CHAIN revision (designer approved 2026-11-27)
Canonical working specification: [PANOPTICON CHAIN Mechanics](PANOPTICON_CHAIN_MECHANICS.md). Supersedes DSY-011's two-card activation threshold: minimum three cards; third valid card instantiates a CHAIN instance and receives inherent −1 BW play-cost reduction before commitment, plus applicable card-specific bonus. Longer chains permitted; exact eligibility, extension discounts, termination, repeat instances, cost floor/precedence and card balance remain open. CHAIN-REP-001 remains Priority 2; coordinate CHAIN visibility and CHAIN ACTIVATED audiovisual feedback with UI-TYPO-001/a and M06. Existing engine and cards still reflect historical rules until implementation; no production change authorized by this documentation commit. CHAIN PULP remains deferred to IRONWATCH. See canonical specification for examples, audit, questions and acceptance plan.


## CHAIN-002d — Experiential acceptance (designer approved 2026-11-27)
Design mantra: **Extend the turn. Expand the options. Reward ingenuity.** CHAIN creates confidence, momentum and a sense of mastery, as if the Rustler discovered a new level within a level. Contrast with surveillance-induced anxiety and restriction. Experiential acceptance criterion: the player should not merely understand that they executed a clever combination; they should feel clever for having discovered it. Reward discovery through typography, motion, sound and visible card changes, not solely numerical effects or a flyout. Anticipation, activation and momentum are proposed feedback phases; eligible card indicators, effective cost changes, localized payoff and newly available options should be legible. Specific animation, sound, card treatments and timing remain experimental; coordinate UI-TYPO-001/a, M06 and CHAIN-REP-001. Playtest whether players independently recognize opportunities, perceive the payoff and report confidence/momentum/mastery without obscuring tactical information; reduced effects must preserve information. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-PARK-001 — Designer decision: park explicit CHAIN mechanic (2026-11-27)
Effective immediately, the proposed standalone CHAIN mechanic (CHAIN-002 through CHAIN-010, CHAIN-REP-001 and associated Priority 2E implementation/playtest roadmap) is PARKED / experimental, not an active production requirement or representative encounter acceptance gate. Preserve the complete historical exploration in docs/PANOPTICON_CHAIN_MECHANICS.md as an experimental reference indexed by docs/PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md; do not delete it or treat prior approvals as current implementation authorization. Designer prefers elegant card-local sequencing and emergent synergy, citing Slay the Spire's per-card Block reward as inspiration. Explore existing Protocols as the natural vehicle for persistent conditional/per-card effects; use ordinary card effects for sequencing, draw, BW, pile manipulation and accumulated-action rewards. Preserve momentum, mastery, exceptional rather than routine combinations, resource-loop safeguards and clear audiovisual feedback without a separate CHAIN grammar, catalyst, link tracking or dedicated CHAIN UI requirement. Examples are exploratory, not approved new cards. Representative ICE encounter remains priority; remove standalone CHAIN work from active scope, retain general card synergy as a design exploration. Existing legacy DSY-011 CHAIN code/cards require Claude Code inventory and designer-approved retirement/reconciliation plan before production changes; no engine edits or issue closures in this decision. Future revival requires explicit designer approval.


## Uplink functional UI direction — UPLINK-SPEC-001
Mechanical console with reusable V2 components, contextual hover/flyouts, no new economic meters. Component IDs UPL-UI-001–010 proposed, pending register audit and detailed UI approval. Distinct Mini-Boss map category icon; conceal identity and ability until entry (MINIBOSS-003). See Master Design.


## UI-IDENTITY-001 — Architecture communicates allegiance (approved 2026-11-27)
**Architecture communicates allegiance.** The physical and visual construction of an environment should communicate its relationship to institutional power, surveillance and individual autonomy. Corporate environments express standardization, order and institutional authority; the Underworld expresses salvaged, adapted technology, individualism and clandestine commerce. Distinction extends beyond palette to architecture, materials, lighting, atmosphere and psychological experience. The Underworld is not necessarily safe or beyond surveillance. BG_NODE_UPLINK_UNDERWORLD.png is the principal artistic reference for the Black Market Uplink.

**Shared functionality. Distinct visual identity.** Reuse genuinely shared behavior, data bindings, transaction logic and interaction mechanisms, not necessarily visual presentation. Each Node may have its own artwork, materials, physical controls, animation and sound. Maintain interaction consistency without visual uniformity; never let component reuse dictate artistic direction or force premature abstraction. Apply this principle to Uplink decomposition and future Architecture V2 UI work. No implementation or asset changes authorized by this design record.


## UI-INSPECTOR-001 — Universal Object Inspector (approved direction 2026-11-27)
Game-wide shared hover/rollover inspector. Enlarged object/card image anchored left, preferably top-left; all explanatory text in right-hand column, right-aligned. Name/classification, mechanical effects, supplementary costs/restrictions as applicable; flavor quotation at bottom where applicable, subordinate to mechanical information. Omit irrelevant fields. Support cards, CAPS, Ghostware, ICE, Nodes, services and status effects with contextual content and disclosure restrictions. Shared functionality, environment-specific presentation per UI-IDENTITY-001. This is the first representative component for typography and motion design system development. Next: audit existing hover components and UI issue register, define content contract, prototype typography hierarchy and motion states, review edge avoidance/dismissal/activation timing and input accessibility, obtain designer approval, then implementation and regression validation. Representative ICE Encounter remains priority 1; typography/motion work proceeds alongside it. No final font, animation timing, component register ID or implementation file structure approved yet. No code changes in this documentation commit.


## UI-TYPE-001 — Game-wide typography exploration (approved 2026-11-27)
Three approved exploration directions for the shared UI typography system: A — Atomic Deco (geometric, period-inspired, expressive); B — Industrial Technical (precise, functional, legible); C — Hybrid (Atomic Deco headings with restrained technical body text). These are exploration candidates, not final font selections. Use UI-INSPECTOR-001 as the first representative test component: produce three complete inspector mockups with identical artwork, content, flavor quotation, frame, palette, dimensions, top-left image placement and right-aligned text. Vary only typography, spacing, weight and hierarchy. Evaluate legibility, atmosphere, hierarchy, scanning speed and long-term visual fatigue. Approved results will inform game-wide UI typography, not just the inspector or Uplink; preserve environment-specific visual identity per UI-IDENTITY-001. Next deliverable: three comparable complete mockups, then designer review and motion exploration. Typography/motion milestone proceeds alongside priority-1 Representative ICE Encounter. No final typefaces, motion timings or implementation changes approved by this record.
