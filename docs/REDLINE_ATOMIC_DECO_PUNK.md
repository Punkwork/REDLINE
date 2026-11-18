# PANOPTICON — ATOMIC DECO PUNK: MAKING THE SPLIT REALITY FELT
**Version:** 0.1 · **Date:** 2026-11-17 · **Author:** Claude · **Decision ID:** ADP-001
**Status:** **CONCEPT.** The designer asked for this doc and its build tasks (2026-11-17: *"yes save this as a design doc … with build tasks for codex"*). That isn't approval of the proposals. Build each phase in Part 3 only after the designer approves it; the questions in §7 are still open.
**Builds on:** *Atomic Deco Punk — DIRECTION* in `REDLINE_MASTER_DESIGN.md` §1; The Friendly Lie (`REDLINE_VISUAL_LANGUAGE.md`, VIS-001); CHROME-001; CARDS-001; RUSTLER-LOOK-001; FACADE-001 (`REDLINE_CORPORATE_FACADES.md`).
**For:** Codex (Godot build, `godot/`).

**What doesn't change:** every approved decision listed in the master document's VISUAL-DECISIONS-2026-11-17, VISUAL-APPROVALS-002 and FACADE-001. In particular: the Friendly → Cracking → Strike → Mask off states and their triggers, the 20% hostile reveal at Cracking, the mood ladder, the cartridges and their finishes, the zine HUD (kept as is for now), the plaques, and the readability rules (Visual Language §2.9: contrast at least 4.5:1, mood never shown by colour alone, **no effect, glitch band or decoration may cross readable text**). No rules change anywhere in this doc.

---

## 1. The idea

**Atomic Deco Punk** is the umbrella style for the whole world, in the designer's words: the exuberance and faith in progress of the Atomic Age, the streamlined industrial design of Art Deco, and punk's DIY defiance. Engineers build and repair their own elektronix alongside the monolithic buildings and processes of the great corporations.

- **Raygun Gothic is the corporate half:** the chrome facades, enamel appliances and sincere service voice.
- **The punk half is the Rustler's:** salvaged 1950s cartridges and the photocopied zine HUD.

The game should make the player feel what it's like to live in a reality that tells two stories at once. Everything exists twice: as the corporation presents it, and as the Rustlers know it to be. The player never lives fully in either. Most of the proposals below work on **where the two halves touch**, because the unease comes from that friction.

## 2. Two rules

**ADP-R1 — The chrome lies; the zine never does.** This extends Visual Language Rule 2 ("the rules are always in zine style"). Corporate wording, backgrounds, ads and flavour records of the player's own past may be unreliable. Rules readouts (plaques, rule chips, the response strip, every number, card name and cost) are **always true and always readable**. The player can distrust the world without the game ever being unfair, and the Rustler layer becomes the one thing they can trust, which is what makes it feel like home.

**ADP-R2 — One value drives the split: bleed.** Every effect in §3–5 that changes with pressure reads one number, **bleed**, from 0 to 1, computed from TRACE and strikes. The world comes apart in sync, the whole effect can be tuned with one curve, and the reduced-motion and readability rules can cap it in one place.

| Corporation state (Visual Language §2.5) | Bleed (working values) |
|---|---|
| Friendly (TRACE 0–19, no strikes) | 0 |
| Cracking (TRACE 20–39, or strike 1 and below 20; VISUAL-APPROVALS-002) | 0.2 at TRACE 20, rising linearly to 0.6 at TRACE 39; never below 0.2 once strike 1 has happened |
| Strike modal on screen | 0.8 |
| Mask off (strike 2+) | 1.0 |

The 0.2 at the start of Cracking is the approved 20% hostile reveal; the reveal now grows with bleed instead of staying fixed (needs designer approval, §7 Q4). Bleed changes smoothly over about 400 ms (instantly with reduced motion).

## 3. Visual

### 3.1 Salvage flows from the corporation to the rig
CARDS-001 already makes the cartridges out of "salvaged cartridge bodies". This makes the salvage traceable: the Rustler's tools are visibly built from the monolith's own products.

- **One parts library, two treatments.** Corporate appliances (mascot shells) and cartridges draw from the same set of parts: lenses, dials, fins, grilles, enamel panels, badges, coils. Corporate treatment: pristine chrome and gloss enamel. Rustler treatment: the same part with the logo scratched off, tape, exposed wire, a Dymo-tape or marker label, solder blobs.
- **Grafts.** When a PATCHWORK upgrade is applied to a card instance, the card can carry one **graft**: a part from an ICE the player broke during that run (CAPTCHA's eye, DOORBELL CAM's lens, AUTO-RENEW's chip). Over a run the deck visibly becomes a pile of stolen corporate future. **Art only, no rules.** The graft belongs to the card instance, like PATCHWORK itself (master §4, LOCKED), so it must survive save/load and must not spread to other copies.

### 3.2 The seam (later)
For when the designer revisits the HUD (RUSTLER-LOOK-001 keeps it as is for now): the zine HUD should look clipped onto a corporate machine it was never designed for. Alligator clips biting the chrome bezel, ribbon cable running off-screen, hand-drilled holes. No build task yet.

### 3.3 Industrial scale behind the facades (later, needs art)
The corporations should feel like systems the player is a speck inside, not storefronts: pneumatic tubes carrying data capsules high in the atrium, conveyor lines, mainframe halls glimpsed through the Deco frames. Stolen data could arrive as a physical capsule or punched card on BREACH. This goes into the next round of background briefs (Corporate Facades §5), not into code.

### 3.4 The photocopy wears under pressure
The Rustler layer's photocopy look degrades with bleed: more toner speckle, slight misregistration of the panel shadows, darker edges. **Only on panel surfaces, borders and shadows, never on glyphs** (readability rule). At bleed 1.0 it should look like a 5th-generation copy, still fully readable.

### 3.5 A Deco display face (needs a designer choice)
DM Sans stays for corporate body copy. Corporate wordmarks, plaque titles, strike modals and propaganda could use one open-licence Deco display face, so the corporations read as monumental. Candidates: **Limelight**, **Poiret One** (both OFL, Google Fonts). On the Rustler side, stencil and hand lettering could join Space Mono for scrawls and graffiti (§4.3). No build task until the designer picks.

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

### Phase 1 — Bleed and sound (testable in the HALCYON slice)

| Step | What | Where (current code) | Done when |
|---|---|---|---|
| **ADP-1a** | **Bleed value** (ADP-R2): a pure function of TRACE, strikes and whether the strike modal is showing, using the curve in §2. Smooth changes over ~400 ms; instant with `reduced_motion`. Expose the value for every presentation system; never read by rules code. | Computed next to `corporation_state` in `scripts/ui/friendly_lie/encounter.gd` (`update_corporation()`); the curve in the data file. | Unit tests cover each row of the §2 table, the post-strike floor of 0.2, and reduced motion. A debug readout shows bleed in the playtest build. |
| **ADP-1b** | **Reveal follows bleed** (§2, needs §7 Q4): the `surveillance_layer` opacity follows bleed instead of switching on at Cracking; Strike and Mask off still swap to the full hostile background as now. | `apply_background()` in `encounter.gd`. | At TRACE 20 the reveal matches the approved 20%; it grows to the TRACE-39 value; Strike and Mask off look exactly as before. |
| **ADP-1c** | **Photocopy wear** (§3.4): a CanvasItem shader on zine panel surfaces, borders and shadows (toner speckle, shadow misregistration up to 2 px, edge darkening), scaled by bleed. **Never applied to text nodes.** A cap for reduced motion (static speckle, no flicker). | Zine panels built in `encounter.gd` / `look.gd`; shader under `godot/themes/`. | Screenshots at bleed 0, 0.4 and 1.0 show the wear; every label still passes 4.5:1 contrast; no shader touches a glyph. |
| **ADP-1d** | **Two-track music** (§5.1): an `AudioStreamSynchronized` (Godot 4.3+) with stems *corporate*, *rustler* and *drone*. Stem volumes follow bleed. Wow and flutter on the corporate stem: a slow LFO on its pitch (±0 cents at bleed 0, up to about ±35 cents at 0.6), back to exactly in tune at 1.0. The corporate chime on strike. Separate music volume setting. **Placeholder stems:** short loops are fine (generated tones or simple synthesis); final music is out of scope. Record every source in `godot/audio/SOURCES.md`. | New `scripts/ui/friendly_lie/music.gd`; stems under `godot/audio/music/`. | In a scripted run from TRACE 0 to Mask off, the mix and detune audibly follow the §5.1 table; the stems stay in sync; the volume slider and mute work. |
| **ADP-1e** | **Mechanical card sounds** (§5.2): sound hooks for card seated, Icepick drag, subroutine broken, END TURN, Bloatware shuffled in. Placeholder samples are fine. | `hand.gd`, `drop_target.gd`, `encounter.gd`. | Each action plays its sound once; no sound plays on hover alone. |

### Phase 2 — Voice (flavour text only)

| Step | What | Done when |
|---|---|---|
| **ADP-2a** | **Voice leaks** (§4.3): a data table of leak lines per corporation and bleed band; NUL/REM notes pick a leak line at the band's rate; graffiti decals (hand-lettered or stencil text in decorative zones only) appear on the background, toast and mascot shells. Use the §4.3 samples; write more in the same voice and log them for approval. | At bleed 0 nothing leaks; at 0.4 some notes and surfaces show leaks; at 1.0 a toast carries a scrawled reply. No leak or graffiti overlaps a rule, number or button (fixture check). |
| **ADP-2b** | **Hesitation lines** (§6.2): a hover timer per card (threshold 4 s, cooldown 20 s, max one per turn), shown in the speech bubble of the ICE with the highest mood. Disabled while dragging. | Hovering 4 s shows the right mood line; it never repeats within the cooldown; nothing in the game state changes. |
| **ADP-2c** | **Corporate flavour vocabulary** (§4.1): trademarked words in toasts and non-fight copy, patent plates on mascot shells, a newsreel line on the loading screen. | The HALCYON slice shows each at least once; the copy is logged for approval. |

### Phase 3 — Paranoia features (only after the designer answers §7 Q3)

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

1. Adopt **ADP-R1, "the chrome lies; the zine never does"**, as a rule?
2. Approve **Phase 1** (bleed, photocopy wear, two-track music, card sounds) for the HALCYON slice?
3. Are the deliberately unsettling features wanted: **ads from real play data** (§6.1) and **LUCIDA rewriting the record** (§6.3)? And grafts (§3.1)?
4. Should the hostile reveal **grow with bleed** through Cracking (from the approved 20% at TRACE 20 to about 60% at TRACE 39), or stay fixed at 20%?
5. Display face for corporate headlines: Limelight, Poiret One, another, or none?
