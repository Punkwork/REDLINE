# PANOPTICON — ATOMIC DECO PUNK: MAKING THE SPLIT REALITY FELT
**Version:** 0.5 · **Date:** 2026-11-17 · **Author:** Claude · **Decision ID:** ADP-001
**Status:** **Approved (2026-11-17)**, except the "later" ideas, which have no build tasks yet. Approval history: Approved: **ADP-R1** with the designer's new definition of the zine (§2, §2.1); the **hostile reveal growing with bleed** from 20% to 60% (§2); **Poiret One** for corporate headlines (§3.5); **Phase 1** and **Phase 3** (Part 3: bleed and sound; ads that know you, LUCIDA record edits, grafts). The designer also approved **SIGNAL-001: three First Signal punch cards** (§8); its presentation (§8.3) and build tasks (Phase 5) wait for approval. Still CONCEPT: Phase 2 and the "later" ideas. Open questions are in §7. Build only approved tasks.
**Builds on:** *Atomic Deco Punk — DIRECTION* in `REDLINE_MASTER_DESIGN.md` §1; The Friendly Lie (`REDLINE_VISUAL_LANGUAGE.md`, VIS-001); CHROME-001; CARDS-001; RUSTLER-LOOK-001; FACADE-001 (`REDLINE_CORPORATE_FACADES.md`).
**For:** Codex (Godot build, `godot/`).

**What doesn't change:** every approved decision listed in the master document's VISUAL-DECISIONS-2026-11-17, VISUAL-APPROVALS-002 and FACADE-001. In particular: the Friendly → Cracking → Strike → Mask off states and their triggers, the 20% hostile reveal at Cracking, the mood ladder, the cartridges and their finishes, the zine HUD (kept as is for now), the plaques, and the readability rules (Visual Language §2.9: contrast at least 4.5:1, mood never shown by colour alone, **no effect, glitch band or decoration may cross readable text**). No rules change anywhere in this doc.

---

## 1. The idea

**Atomic Deco Punk** is the umbrella style for the whole world, in the designer's words: the exuberance and faith in progress of the Atomic Age, the streamlined industrial design of Art Deco, and punk's DIY defiance. Engineers build and repair their own elektronix alongside the monolithic buildings and processes of the great corporations.

- **Raygun Gothic is the corporate half:** the chrome facades, enamel appliances and sincere service voice.
- **The punk half is the Rustler's: the zine** (§2.1), meaning paper and retro-mutated technology with form stripped bare and function bolted on. Today that's the salvaged 1950s cartridges and the zine HUD.

The game should make the player feel what it's like to live in a reality that tells two stories at once. Everything exists twice: as the corporation presents it, and as the Rustlers know it to be. The player never lives fully in either. Most of the proposals below work on **where the two halves touch**, because the unease comes from that friction.

## 2. Two rules

**ADP-R1 — The chrome lies; the zine never does. (APPROVED, 2026-11-17)** Designer: "yes". This extends Visual Language Rule 2 ("the rules are always in zine style"). Corporate wording, backgrounds, ads and flavour records of the player's own past may be unreliable. Rules readouts (plaques, rule chips, the response strip, every number, card name and cost) are **always true and always readable**. The player can distrust the world without the game ever being unfair, and the Rustler layer becomes the one thing they can trust, which is what makes it feel like home.

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

On the Rustler side, stencil and hand lettering could join Space Mono for scrawls and graffiti (§4.3); that's part of Phase 2.

## 4. Tone and language

### 4.1 Corporate voice
Keep FACADE-001's rule: more polite and more certain as the threat grows; never raised before Mask off. Add, as flavour:
- 1950s newsreel narration for loading screens and lore ("Tomorrow's home is here today!").
- Trademarked everyday words: "HALCYON Welcome™", "SafeStreets Courtesy™", "lucida Gentle Adjust™".
- Patent plates on appliances ("PAT. PEND. HALCYON MFG. CO.").
- *Tomorrow* as a quiet threat ("We'll talk about this tomorrow.").

### 4.2 Rustler voice
Practical, irreverent and specific (master §1). Add:
- Punk respellings, **sparingly**: *elektronix*, *kontrol*. Never in rules text.
- Hand-numbered zine issues: a run could be "ISSUE #14".
- Warmth. Crew messages, in-jokes, zines dedicated "for Mags, who got traced." The paranoia lands harder when the player has people to lose.

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
- **Rustler track:** dry and close: 4-track cassette, tube amp, circuit-bent toys, oscillators, relays.

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
A hand-built radio on the map or DEAD DROP screen, tuning between corporate broadcasts (ads, newsreels, public safety notices) and pirate stations. Pirate stations can carry small useful rumours about upcoming Nodes, so listening pays off. Needs a rules decision about what the rumours may reveal (RUN-005 hidden contents); no build task yet.

## 6. World elements that feed the paranoia

1. **Ads that know you.** Loading and between-run screens show corporate ads written from the player's **real, local** play data: most-played card type, most-broken ICE, the corporation where they get traced most, how long they hesitate. *"We noticed you favour Icepicks. HALCYON Home has a plan for people like you."* Ads get more specific the more runs there are. Data never leaves the machine; a settings toggle turns the ads off.
2. **ICE react to hesitation.** Hovering one card for a long time (working: 4 s) gets a line from the ICE whose mood fits: cheery "Take your time!", wary "Still deciding?", lethal "WE CAN WAIT." Cooldown 20 s; at most one line per turn. Flavour only, never a penalty. The game shows it's watching *how* you play.
3. **LUCIDA edits the record.** In LUCIDA runs, flavour lines in the event log are quietly rewritten a turn or two after they appear ("You broke the THERAPIST." → "You rested here."). **Rules lines are never rewritten:** numbers, card names, damage, TRACE and anything needed for a decision stay exact (ADP-R1). A tiny zine mark (✎) shows where a line was changed, so the player can spot it.
4. **Two voices on one page.** Lore arrives as corporate ephemera (manuals, warranties, safety pamphlets, newsreel stills) with Rustler notes in the margins.
5. **The map is a defaced tourist map.** "Visit the City of Tomorrow!" in corporate print, with marker routes, crossed-out landmarks and warnings scrawled over plazas.
6. **DEAD DROP as a workbench.** A basement under a corporate tower; PATCHWORK upgrades shown as soldering a cartridge under a stolen HALCYON lamp (and attaching grafts, §3.1).
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

Designer: "Phase 2 absolutely approved." Build after Phase 1.

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

**Out of scope for now (need art, rules or a designer choice first):** the HUD seam (§3.2), industrial background layers (§3.3, goes into the next art briefs), the Deco display face (§3.5), the radio (§5.3), annotated lore ephemera, the defaced tourist map, the DEAD DROP workbench and the crowd (§6.4–6.7), final music and sound design.

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
- **The umbrella AI is the hidden AI** in the master doc's §8 story questions (confirmed by the designer, 2026-11-17: "yes it is.").

### 8.2 Writing rules until the end

- **Before the third card,** nothing on screen names the AI, says it controls the corporations, or explains the cards, the merge or the SYNCHRONIZATION SCRAMBLER. The cards are "the data" or "the job".
- **Hints are allowed** and should be oblique: speech synthesis, machine voices, old transmissions, the holes lining up, corporate copy that sounds a little too similar across all three corporations ("We'll take care of it." / "You're in good hands." / "Rest easy."). Nothing a player could take as an explanation.
- **After the third card,** the reveal: the three corporations are one AI's faces, and it's about to complete the synchronization. Even then, the game doesn't say whether that would be evolution, liberation or assimilation. NUL/REM can doubt; the Rustler chooses to jam it anyway, because that's what Rustlers do.
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
