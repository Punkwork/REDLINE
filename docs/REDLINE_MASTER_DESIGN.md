# PANOPTICON — MASTER GAME DESIGN DOCUMENT
**Version:** 0.1 consolidated baseline  
**Prepared:** 2026-11-09  
**Authority:** Design reference; not proof of code implementation  
**Status key:** **LOCKED** = explicitly decided; **DIRECTION** = established creative direction; **CONCEPT** = proposed but not finalized; **OPEN** = needs decision; **VERIFY** = retrieve exact specification from code or earlier source before implementation.

> **NAME-001 (2026-11-13):** ICE types WALL / CODE GATE / SENTRY are now **FORTRESS / SIGYL / VOID**, and VOID damage is now **CORTEX** (same counters and rules). Terms in this document were updated to match; rule and decision IDs keep their original names (e.g. TRAINING-THREE-ICE-SENTRY-001). See `REDLINE_CORE_RULES.md` (NAME-001).

> **Preservation rule:** Do not silently replace a LOCKED decision. Record revisions in the decision register, including rationale and date. Do not convert concepts into implemented features without code and test evidence.

## 1. High concept and creative pillars
PANOPTICON is a cyberpunk rustler-versus-corporation, card-driven game with ICE encounters, hacking, escalating Trace, and a narrative concerning the boundary between humans and machines. Its aesthetic combines retro-computing, CRT-era interface language, and high-energy arcade/cyberpunk visual influences (including the feel of *Tempest 2000*). The player is accompanied by **NUL/REM**, a sardonic, intermittently protective artificial companion.

**Design pillars (DIRECTION):** meaningful tactical decisions; clear and consistent terminology; legible ICE encounters; persistent consequences and build customization; an evocative retro-computing identity; humour and melancholy without undercutting danger; narrative ambiguity about human/machine synchronization.

**Production direction (LOCKED):** **Godot 4** is the target production engine. The existing **Python/Pygame** build remains the gameplay reference and regression baseline; migration must preserve tested behaviour rather than inventing replacement rules.

### Atomic Deco Punk — DIRECTION (2026-11-17)

**Atomic Deco Punk** is the designer’s term for PANOPTICON’s artistic language. Raygun Gothic is a visual reference for the corporate world. Atomic Deco Punk brings together the exuberance and faith in progress of the Atomic Age, the streamlined industrial design of Art Deco, and punk’s defiance and do-it-yourself craft. Engineers build and repair their own elektronix alongside the monolithic buildings and standardized processes of the great industrial corporations. Both groups inherit the same technological optimism and put it to different uses.

**Visual design leads.** On the corporate side, make mass production and institutional scale visible in the repeated geometry, polished finishes and coordinated appliances. On the Rustler side, let the player see how a person built or repaired the thing they’re handling. Salvaged cartridge bodies, exposed wiring, hand-applied markings and photocopied controls belong to the same technological world as the seamless corporate products. Carry that relationship through environments, interfaces, props and cards.

**Tone and language.** The three corporations sell access to home, street and mind in the language of comfort, public safety and care. Their product voices stay solicitous as routine interactions reveal how much they have observed. The Rustler’s language can be practical, irreverent and specific, with room for humour and unease.

**Sound.** Explore period-inflected service chimes, well-damped mechanical clicks and reassuring voices on the corporate side. On the hand-built side, explore relay chatter, switch noise and irregular electronic hum. A familiar reassurance cue can acquire a different meaning when it plays during a surveillance reveal. Use these as sound directions to try in playtesting.

**Player experience.** Let the player feel the appeal of the corporate promise before they realize what it costs. Then let the convenience become unnerving through specific details such as a service remembering an unreported trip or a polite appliance refusing to let them leave. Keep the corporate presentation composed as the situation turns threatening. The Rustler’s tools should feel like things people made to retain some agency in that world.

This is a primary design principle for the game’s world, writing, and entire interface. Carry the same visual language through navigation, menus, account screens, consent prompts, dashboards, and status messages as well as the cards. Use stepped frames and symmetrical layouts, polished metal, and bright Atomic Age motifs. Let each corporation’s surveillance model shape what its interfaces ask for, what they remember, and what they present as a reward. Players should be able to feel the differences between the corporations in routine interactions.

The surrealism comes from the sincerity of the sales pitch. A cheerful orbit animation celebrates a newly linked data source. A pastel settings screen promises, “Fewer interruptions. We’ll recognize you automatically.” A service dashboard remembers places the player never disclosed. As the implications grow darker, the design stays immaculate and the corporate voice stays warm. The player should understand both why someone would welcome the service and what the corporation gains when they do.

#### Visual precedents

- [Five Ton Crane’s Raygun Gothic Rocketship](https://fivetoncrane.org/project-item/the-raygun-gothic-rocketship/) combines a polished, finned exterior with a tactile cockpit drawn from 1930s through early 1950s science fiction.
- [Starship Titanic](https://store.steampowered.com/app/467290/Starship_Titanic/) puts Deco luxury, retrofuturist consoles, and robot attendants inside a single passenger experience.
- [Dr. Grordbort’s](https://www.gregbroadmore.com/portfolio/dr-grordborts) gives imagined space-age technology the heft and finish of fabricated objects.
- [BioShock’s Rapture](https://irrationalgames.ghoststorygames.com/insider/from-the-vault-evolution/) carries Deco styling from its architecture into the machines people use.

#### ADP-001 — Making the split reality felt (APPROVED, 2026-11-17)

Claude's response to the direction above, saved as **`docs/REDLINE_ATOMIC_DECO_PUNK.md`** (retired by UI-BIBLE-001; now [UI Design Bible, Source 4](PANOPTICON_UI_DESIGN_BIBLE.md#source-4-docsredline_atomic_deco_punkmd)) at the designer's request, with build tasks for Codex. It builds on The Friendly Lie, CHROME-001, CARDS-001, RUSTLER-LOOK-001 and FACADE-001 and changes none of them or any rule.

**Approved by the designer (2026-11-17):**
- **ADP-R1 — The chrome lies; the zine never does.** Corporate wording, backgrounds, ads and flavour records of the player's past may be unreliable; rules readouts (plaques, rule chips, the response strip, every number, card name and cost) are always true and always readable. Designer: "yes".
- **ZINE-001 — The zine is redefined.** In this world the zine isn't only photocopied paper: "it's zine and retro-mutated technology where form is stripped bare for bolted on function. So a zine could have the paper form a moebius strip in order to rig some foil-based antenna to jam a surveillance signal, using a version of QR codes, but in the form of barcodes and punchcards." So: nothing on the Rustler side is there for looks; paper is a working material (folded, wired, foil-laminated into devices); period technology is mutated by hand; and the Rustlers' machine code is **barcodes and punch cards, never QR codes**. Barcodes and punched strips in general are decoration and world-building, not a second rules channel; the exception is the three First Signal punch cards (SIGNAL-001). The cartridges already fit; the zine HUD stays as is for now (RUSTLER-LOOK-001), and this definition is the brief for its eventual redesign. Detail: doc §2.1.
- **The hostile reveal grows with TRACE** through Cracking, from the approved 20% at TRACE 20 to **60% at TRACE 39** (replaces the fixed 20% in VISUAL-APPROVALS-002). Designer: "the hostile reveal should grow as trace rises, from 20% to 60%".
- **Poiret One** is the display face for corporate headlines (wordmarks, background headlines, strike-modal headlines, titles, ads), large and on solid grounds only; DM Sans stays for body copy and rules. Designer: "Poiret One suits headlines".
- **Phase 1 build tasks (ADP-1a–f):** the bleed value (ADP-R2), the growing reveal, rig wear on the zine panels, two-track music, Poiret One, mechanical card sounds. Designer: "2 yes".
- **Phase 1 implementation confirmations (APPROVED, 2026-11-17):** The designer confirmed all four interpretations from `53b00d7`.
  - **Wear and reveal.** Treat the outer 3 px, with shadow offset up to 2 px. Tape lifts outside the lower corner, and barcode flicker starts above bleed 0.6. The 0.40 fixture shows the midpoint of the eased TRACE 20-to-39 transition.
  - **Audio.** Keep the synthesized cues, mix points and LFO rates as working placeholders. The corporate pitch-processing feed shares the synchronized transport. Reduced motion disables pitch wobble. Music mute covers the stems and strike chime, and mechanical cues stay audible.
  - **Corporate typography.** Use Poiret One at 36 px for wordmarks, 28 px for “Good morning.”, “Your block is safe.” and “Breathe in.”, and 68 px for Strike headlines.
  - **Mechanical cues.** Play a seating click on accepted hand play, a relay clunk on completed breaks, and one tape tear per Bloatware insertion batch, including the first strike’s TRACER.
- **Phase 3 build tasks (ADP-3a–c):** **ads that know you** (written from local play data, with an off switch), **LUCIDA rewriting flavour lines in the event log** (never rules lines), and **grafts** (salvaged ICE parts as art on PATCHWORK-upgraded card instances; no rules effect). Designer: "for #3 yes i want two deliberately unsettling features"; "GRAFTS - yes - it's a great extension of the theme to salvage ice parts on upgraded cards". Build after Phase 1.

- **Phase 2 build tasks (ADP-2a–c):** voice leaks and graffiti, ICE hesitation lines, corporate flavour vocabulary. Designer: "Phase 2 absolutely approved."
- **Phase 2 copy pack approved in full** (`REDLINE_ADP_PHASE2_COPY.md`): all voice-leak lines, graffiti and replies, hesitation lines, trademarks, toasts, patent plates and newsreels, including the [hint] lines (NUL/REM's letter-spaced speech-synthesizer slips, the shared "SAME SMILE, DIFFERENT BADGE" tag, and the "Tomorrow, together." sign-off on every corporation's newsreels); the graffiti faces **Stardos Stencil** (stencil) and **Permanent Marker** (marker), with punched-hole letters drawn in code; and NUL/REM's Carol Beer and Kraftwerk references. Designer: "1,2 & 3 are approved in full."

**Recorded 2026-11-18 (claude.ai session):**
- **Atompunk (ADP §1.1).** The designer asked whether *atompunk* names the style. It covers the corporate half (Raygun Gothic, Populuxe, Googie, Cold War paranoia) but not Deco (filed under decopunk) or the DIY punk layer. **Atomic Deco Punk stays as the internal term; "atompunk" is the outward pitch shorthand.**
- **ZINE-002 — The zine is the underworld's samizdat (designer direction, 2026-11-18).** The zine is "a way for those in the underworld, that is to say, rustlers included, to communicate ideas with each other", situated "more along the same lineage as the samizdat", with emphasis on "why these publications existed in the first place". In Panopticon nothing is banned: the corporations own every channel and listen to all of it, speech becomes data, the record can be rewritten, the traced vanish from it, and nobody says things plainly. Censorship by convenience, not prohibition: "the zine exists because the corporations own the air." Zine communication is fiction, never a rules channel. Examples (*THE CARBON* ledger, copy generations, magnitizdat, bone music, polite corporate discouragement of paper) are working copy, for approval. Detail: `REDLINE_ATOMIC_DECO_PUNK.md` (retired by UI-BIBLE-001; now [UI Design Bible, Source 4](PANOPTICON_UI_DESIGN_BIBLE.md#source-4-docsredline_atomic_deco_punkmd)) §2.2.
- **ZINE-003 — SAMIZINE, the underworld's zine look (APPROVED, 2026-11-18).** Designer asked for "a mashup between zines and samizdat. Something never before seen"; after three review rounds: "Perfect. Save whatever information is necessary, including the artifacts". The punk zine's attitude with samizdat's materials: typewritten carbon-blue body with a doubled ghost, spirit-duplicator violet stamps, headlines kidnapped from corporate ads (Poiret One letters on corporate pastels), typed over the back of corporate junk mail (palimpsest), lies struck through and answered in red marker, punched spine and barcode margin (no QR), pocket wear (folded in quarters, creases, frayed and grimy edges) and copy generations 1–5. Applies to in-world underworld publications (*THE CARBON*, *NOTES FROM THE ’PELAGO*, lore zines, the defeat-screen CARBON page); the HUD keeps its current look for now (RUSTLER-LOOK-001). Decoration never touches rule text. New font: Special Elite. Detail: `REDLINE_SAMIZINE.md`; boards in `docs/visual/samizine/`.

**Still CONCEPT (no build tasks yet):** the later ideas (HUD seam, industrial background layers, radio, defaced tourist map, DEAD DROP workbench, watching crowd).

### VISUAL-DECISIONS-2026-11-17 — Approved visual decisions from VIS-001, CHROME-001 and CARDS-001 (APPROVED, 2026-11-17)

Only choices the designer explicitly made on 2026-11-17 are recorded here. Everything else in that work (final art, working values, and Codex's "Interpretations to confirm") remains under review; see `docs/HANDOFF.md`, *Waiting on the designer*. Detail: `docs/REDLINE_VISUAL_LANGUAGE.md` (retired by UI-BIBLE-001; now [UI Design Bible, Source 1](PANOPTICON_UI_DESIGN_BIBLE.md#source-1-docsredline_visual_languagemd)), `docs/REDLINE_DEVELOPMENT_LOG.md` (2026-11-17 entries), and `docs/visual/`.

| Decision | Designer's words | Commit |
|---|---|---|
| **The Friendly Lie (direction B)** is the visual direction: the corporations present as friendly consumer products and their ICE as that product's interface; the Rustler layer is visibly separate. Chosen over A *Phosphor* and C *Watchtower*. | “I do really like the B option the friendly lie … I think this is a more suitable direction” | 100a2aa |
| **Atomic Salvage is deprecated.** It no longer sets the look; the requirements in `REDLINE_UI_NULREM_Design_For_Claude.md` (retired by UI-BIBLE-001; now [UI Design Bible, Source 3](PANOPTICON_UI_DESIGN_BIBLE.md#source-3-docsredline_ui_nulrem_design_for_claudemd)) still apply (see Visual Language §2.10). | “I would deprecate that atomic salvage look” | 100a2aa |
| **Rustlers draw 6 cards a turn.** | VIS-001 brief: “Rustlers draw 6 cards a turn” | 100a2aa |
| **Chrome Deco encounter:** corporate luxury above, the Rustler's photocopied resistance below. HALCYON's CAPTCHA encounter is the first implementation. | “Chrome Deco corporate luxury above, photocopied Rustler resistance below” | 15ae99e |
| **No black panels behind ICE rules.** ICE rule surfaces follow the corporation's Atomic Age / Art Deco service look; the prototype uses pearl-enamel plaques. | “The black backgrounds on the ice in the images don’t work with the rest of the design … atomic age /art deco / clean friendly corporation design” | 4c2135e |
| **Cards are heavy, type-specific 1950s slot cartridges** with protruding parts and the BW cost mostly outside the text area. | Blank carrier art: “Looks good” | 083df86 |
| **Card board colours:** tobacco brown for SCRIPT, olive for PROGRAM, blue-green for PROTOCOL (review options A, C and D). | A/C/D selected | 744f3dc |
| **No white text backgrounds on any card.** | “No card should have a white background for the text” | 744f3dc |
| **Bloatware uses the Whirlwind design on an oxide-red board,** distinct from SCRIPT's brown. | Whirlwind #3 selected; oxide red: “Perfect” | 744f3dc |
| **Highlighted numbers on cards glow as amber text** instead of sitting on highlighted blocks. | Requested glowing amber text instead of highlighted backgrounds | 29c660c |

**RUSTLER-LOOK-001 — Two Rustler styles kept on purpose (APPROVED, 2026-11-17).** The Rustler's cards are 1950s salvaged hardware (CARDS-001), while the Rustler HUD, Node and TRACE tags, END TURN and NUL/REM notes stay in the photocopied zine style. This is a deliberate exception to Visual Language Rule 1 ("Your side never changes"), not a mismatch to fix. Each corporation will have a different look. The HUD will probably change in the near future; until the designer decides that change, keep the HUD as it is. Designer: "B Each corp will have a different look. The HUD will probably change in the near future, but I want to keep it this way for now."

**CARDS-002 — Rustler PCB palette (designer direction, 2026-11-19).** Use the designer's TV Typewriter PCB reference for the three Rustler cartridges. Place ivory silkscreen traces, pin headers and dark drilled contacts around the board perimeter. Corporate BLOATWARE retains its oxide-red Whirlwind board. The prototype palette below was reviewed and is superseded by CARDS-003. Current cartridge silhouettes, rarity finishes, ivory text and amber numbers carry forward.

| Rustler card | Laminate edge | Print field |
|---|---|---|
| SCRIPT | Mustard `#BD9547` | `#6C4A1D` |
| PROGRAM | Olive `#90934F` | `#4C522C` |
| PROTOCOL | Blue-green `#60938A` | `#30574F` |

Shared silkscreen `#F2E5C2` and contact holes `#24231C` stay outside names, illustrations and rules. Cap the light grain on the print fields to meet the 4.5:1 contrast floor for rule text and amber numbers.

**CARDS-003 — PCB glow cartridges (APPROVED, 2026-11-19).** Supersedes the CARDS-002 palette table above and its rarity finishes, ivory print and amber-on-field numbers. Designer: "Go with this dark panel tint for now it works. Yes i want these stencil designs. Commit these changes to the cards for godot." It was reviewed in 17 iterations on the `review/cards-002` branch, which is never merged.

| Type | Board | Dark mask | Circuit stencil |
|---|---|---|---|
| SCRIPT | Mustard `#AE924D` | `#2E2712` | Edge connector |
| PROGRAM | Deeper green `#5A8048` | `#172312` | DIP chip |
| PROTOCOL | Blue-green `#60938A` | `#14272A` | TO-5 can between two coils |
| BLOATWARE | Corporate oxide-red face and Whirlwind art | `#2A1411` | None |

- **Text never sits on the bare board.** The title, type plate and rules each sit on a dark solder-mask panel in the type's own tint. Text is ivory `#FFF3D0` with a soft halo, and numbers are Barlow Bold amber `#FFC861`; every ink is at least 4.5:1 on its mask (in practice 9.6:1 to 15.7:1).
- **Fonts:** Rustler titles use Chrome Deco bold, the type plate Routed Gothic, and the rules Barlow SemiBold and Bold. BLOATWARE keeps its corporate fonts (designer).
- **Layout:** each type's rules panel is placed from its own board. Rules fit between 11 px and a 9 px floor, and all 444 card texts (AMP 0–3) fit.
- **Rarity:** a recessed lamp in the top exterior with 1, 2 or 3 lit cells (amber `#F5CA76`, green `#94D98C`, violet `#BF9EF6`). Starters have no rarity (designer). On PROTOCOL the lamp sits on the relay rail (designer). No printed rarity remains on any card.
- **Cached:** never printed on the card (designer). One solid icy-cyan `#7FE3F0` glow sits just inside the board edge, beneath the cost and every text panel, and is the same for a temporary cache (designer). The tooltip reads `CACHED`, or `CACHED (temporary)` for a timed cache, kept for now (designer).
- **Grafts:** a grafted card shows its graft art in the stencil slot.
- **CARDS-003a — long text (designer direction, 2026-11-19).** Designer: "I prefer the full text to show on a hover, as the solution. And on the card while it's in your hand, where the card text is, place the card names." When a card's full rules don't fit its panel at 9 px, the rules panel names the component cards instead, and hovering shows the full rules in a mask panel above the card. This replaces Claude's proposed tall layout. Only compiled SAFEHOUSE cards are affected: 107 of 1,008 pairs. Confirmed by the designer ("Great save those changes", 2026-11-19): the names are joined by a small THEN; there is a "Hover for full text" hint line; only cards whose text doesn't fit use names and hover; and the panel opens below the card when there is no room above.
- Fixture: `godot/tests/shot_cards_pcb.gd`, in CI. Reference sheets: `docs/visual/fixtures/cards-003/`.

**CARDS-004 — Larger cards (APPROVED, 2026-11-19).** Designer: "The cards in general should be larger, 16 bit or not." After an encounter mockup, the designer chose **1.4×**: cards become 230 × 342, and rules text about 13–15 px. Designer: "Have the cards slightly overlap based on the number of cards." **Hand (designer, 2026-11-19):** "I would rather they start to slightly overlap instead of squash them together so the sides aren't visible, and them overlap more as more cards in hand." "Gentle fan is perfect." The hand is centred and overlaps slightly from the start, with more overlap as it grows. **Fan values (APPROVED, designer 2026-11-19: "Yes to the fanned cards"):** 5% overlap at 1–4 cards, then 8% at 5, 10% at 6, 18% at 7, 26% at 8, 35% at 9 and 43% at 10, the maximum. A **gentle fan** spreads 20° across the whole hand, at most 4° between neighbours, so the overlap gathers at the bottoms and the top corners stay readable. A hovered card rises 36 px above its neighbours. To make room:
- the stats column moves up under a shorter Program Bay;
- END TURN and the deck buttons move up under the TRACE panel;
- the response strip, NUL/REM bar and rack move up 104 px;
- the ICE area is laid out again for the smaller height.

**Built (2026-11-19, commit 02a2056).** Hand area `Rect2(16, 622, 1568, 378)`. The ICE row is drawn at 85% and the mascot stage is 44 px shorter (194 px), so mascots are about 70% of their ENCOUNTER-DISPLAY-001 size. The response strip, NUL/REM bar and rack sit 104 px higher. The stats column sits under a 200 px Program Bay. END TURN, the pile counters and END RUN sit under the TRACE panel. Graffiti uses four fixed spots clear of rules text. The ready-rig and reward rows hold 1.4× cards in fixed-size holders. Inspection is 1.4× (2.1× when pinned). *Interpretations to confirm:* the 85% ICE scale and the shorter mascot stage; in a fanned hand of 9–10, the cards' bottom contact strips may run up to about 50 px past the bottom edge of the window. Rules text and the hover panel always stay on screen. Mockups and build captures: `docs/visual/fixtures/cards-004/`.

**BW cost dial moves to the top-left corner** (designer, 2026-11-19: "The bw cost could move to top left of card as we are not efficiently using the card space/corners for icons"; this reverses the earlier "keep it top-right"). In an overlapping hand each card's cost stays visible, because the next card covers the right side. The Rustler title panel shifts right to clear it and takes over the freed width. **Built:** the dial move (CARDS-004a). *Open:* what goes in the freed top-right corner. Claude suggests a RAM chip on PROGRAMs, whose RAM cost is not shown on the card today. Reward offers, deck views and inspection use the same card size. **Status:** built with CARDS-004. The top-right corner went to CARDS-005.

**CARDS-005 — Corner icons (APPROVED, 2026-11-19).** Designer: "We need to utilize the top right corner for icons… Yes i want all of them in the right corner." Small dark plates (`#253237`, like the BW dial) stack down the card's top-right corner, most important first:
1. **Icepick type:** a FORTRESS tower, a TUMBLER turning arrow, a VOID hollow diamond, or an asterisk for picks that break ANY type.
2. **RAM** on every PROGRAM: the number on a memory chip with pin marks. RAM was not shown on cards before.
3. **Extra TRACE cost:** red `#FF8A7A` +N.
4. **Extra CRED cost:** gold `#FFC861` N.
5. **Target:** a crosshair on cards that need a target ICE.

Compiled cards combine their parts' costs and target.

**CARDS-005a — hardware styling and BLOATWARE (APPROVED, 2026-11-19).** Designer: "make them look like part of the hardware of the card. Right now they look very much out of place." The flat plates become **round indicators in the BW dial's style**: a pale steel bezel, a dark face and a glowing glyph with a glass glint. They are mounted on a brushed-steel rail screwed to the chassis. **BLOATWARE** (designer: "Yes") gets two icons:
- a **"can't be played"** indicator (a slashed circle) on both TRACER and SPAM;
- on TRACER, a **penalty lamp**: a lit red indicator with a dark "+3" for the TRACE added if it is held at the end of the turn. The number is read from the card's own rules text.

An unplayable card's BW dial shows **"—"** instead of 0. The hover tooltip spells the icons out, for example "breaks TUMBLER · RAM 1". The Rustler title panel narrows to 114 px to make room. No card carries more than three icons; four would still clear every text panel. Every ink is at least 5.7:1 on the plate. **Built.**

**HAND-MAX-001 — Maximum hand size 10 (APPROVED, 2026-11-19).** Replaces VIS-001's "no maximum for now". Designer: "We should determine a maximum hand size"; chose **10**. When a draw would take the hand past 10, **the draw stops and the card stays on the draw pile** (designer). Every card in hand counts toward 10, CACHED cards and Bloatware included. Evidence from 30-seed bot runs of the HALCYON slice: GENERALIST, RIOT and VECTOR never start a turn above 6. ECHO starts with 7 on 26% of its turns, 8 on 3%, 9 on 1.4% and 10 once, so today's play is never capped. *Interpretation to confirm:* any other effect that would move a card into a full hand (for example retrieving one from the discard pile) does nothing, and the card stays where it was. **Built (2026-11-19, commit 02a2056):** `Game.MAX_HAND = 10`. A draw at 10 stops before any reshuffle or REBOOT. Retrieve and FIELD KIT into a full hand leave the card where it was, and the log says "Hand full". The rules tests in `test_hand_max` cover all of this. The bot sims are unchanged.

**PIXEL-TRACE-001 — The corporation's picture drops toward 16-bit as TRACE rises (APPROVED, 2026-11-19).** Designer: "the more trace and the madder/meaner the corporation gets, the more 16-bit the background and ice look. Or the reverse." Claude recommended more TRACE → more pixelated: the Friendly Lie is an expensive front, and as the corporation stops being nice it stops paying for looking nice; the world turns to data around a Rustler drifting toward the ’Pelago. Mockup at four levels approved: "Looks good. Commit to the build."
- **What pixelates:** only the backdrop (friendly and hostile layers) and the ICE mascot art. Plaques, rules text, numbers, cards, buttons, speech bubbles, status tags and graffiti always stay sharp (ADP-R1).
- **Steps, not a slider** (working values in `godot/data/atomic_deco_punk.json` → `pixel`): TRACE 0–19 sharp; TRACE 20–29 2 px cells, 24 colour levels per channel; TRACE 30–39 3 px, 16 levels; a strike 4 px, 12 levels; Mask off 5 px, 10 levels. A light 4×4 ordered dither gives the 16-bit banding. Cells sit on a single screen grid, so backdrop and mascots line up.
- Works with the existing bleed: the hostile background that bleeds through from TRACE 20 is pixelated with the rest.
- **Transitions (PIXEL-TRACE-001a, designer 2026-11-19: "Commit the transitions to the next build"; chose "Animate the step changes"):** each step change spikes for 0.15 s to cells 2 px coarser than either step, with half the colour levels and full dither, then settles on the new step over 0.35 s. Cells stay whole pixels. With reduced motion, and when an encounter starts, the step changes at once. Values in `atomic_deco_punk.json` → `pixel_transition`.
- **Sound (PIXEL-TRACE-001b, APPROVED direction, not built; designer 2026-11-19: "Bit crushing the music or bgm is perfect"):** the corporation's music is bit-crushed (lower sample rate and bit depth, for example Godot's lo-fi distortion on the music bus). During each 0.5 s transition the crush spikes with the picture, then settles. *Working proposal:* a light crush stays on at each step and deepens toward Mask off, so the music degrades as the picture does. Because it is on the music bus, muting music also silences it. It plays with reduced motion on, since that setting stops animation, not sound. On a strike it sits under the existing strike chime. Values to be set by ear; presentation only. **A transition sound effect will also play (designer, 2026-11-19: "There will be a sound as well for the transition but i have not yet determined").** **PIXEL-TRACE-001c (APPROVED, 2026-11-21; designer: "NEON BALLAST BUZZ"):** the transition sound is a neon ballast buzz, chosen over a TV detune and a teletype burst. *Working proposal:* a short buzz and flicker hum the length of the transition, on the effects bus, so it plays with music muted and with reduced motion on.
- **Presentation only.** Rules code never reads it.
- **PIXEL-16BIT-001 — no 16-bit look for the whole game (REJECTED, 2026-11-21; designer: "NO. ONLY FOR TRANSITION from regular game images to each stage - on lethal - the ICE PULSE transitions in and out of 16-bit - 2 seconds each state").** 16-bit stays an effect, not a style: the avatar mood transitions and lethal pulse (MOOD-PIXEL-001) and the TRACE steps above. The mockups in `docs/visual/explorations/pixel-16bit/` stay as history.
**Built (2026-11-19, commit c063429):** shader `godot/themes/trace_pixel.gdshader`; `AtomicDecoPunk.pixel_step()`; one full-screen layer after the backdrops and one per mascot placed before its first text, in `encounter.gd`. Fixture `shot_trace_pixel.gd` (in CI) captures the four levels and checks no text sits under a pixel layer. Captures: `docs/visual/fixtures/pixel-trace-001/`. *Interpretations to confirm:* the step values; the strike step; mascot detail drawn after a status tag stays sharp; the transition spike and timing. **Transition built:** commit c041496.

**ENC-ANALOG-001 — Analog / flip-clock / cockpit encounter screen (APPROVED for integration, 2026-11-19).** Saved first as an exploration (designer: "I want to return to this elegant design and interface then incorporate it into the encounter screen"). Integration approved in ChatGPT ("Okay, well then I approve all of these changes to be integrated into the default encounters") and confirmed to Claude in session, choosing **"Whole encounter screen"**: the Rustler side as a 1960s–70s brown bakelite flip-clock and cockpit (split-flap PROGRAM reel; TRACE needle meter, BANDWIDTH LED graph, VITAE vial, SHIELD lamp ring, PULP Nixie tubes; split-flap NODE, TURN, STRIKES, RESERVE and DECK/DISCARD; a cream END TURN button), the corporate side as mint-enamel HALCYON appliances in chrome bezels. Spec: `REDLINE_ENCOUNTER_ANALOG.md` (retired by UI-BIBLE-001; now [UI Design Bible, Source 2](PANOPTICON_UI_DESIGN_BIBLE.md#source-2-docsredline_encounter_analogmd)). References: `docs/visual/explorations/encounter-analog-001/` and `ice-analog-001/`. The cards in the mockups are placeholders; **CARDS-001/004/005 are unchanged**. Presentation only. *Not built yet.*

**ICE-ANALOG-001 — Iconized ICE subroutine readout and livelier mascots (APPROVED for integration, 2026-11-19).** Designer: redesign the ICE readout, not the mascots; mascots "a little bigger" with "more behavior"; subroutines become icons with a value ("You don't have to use the word deadlock. You can use an image"), with "the text of that subroutine when you roll over the subroutine icon itself"; elegant but "adequately display the information that's necessary". Approved for the default encounters (same approval as ENC-ANALOG-001), **including full subroutine text on hover/focus only** (designer, in session: "Yes, approved, incl. hover text"). This amends VIS-001 §2.9: the ICE shows icon + value; the full rule is in the hover/focus tooltip; the NEXT RESPONSE strip and the passive strip keep full text. Brief: `REDLINE_ENCOUNTER_ANALOG.md` (retired by UI-BIBLE-001; now [UI Design Bible, Source 2](PANOPTICON_UI_DESIGN_BIBLE.md#source-2-docsredline_encounter_analogmd)) §8. Codex's standalone wireframe fixture (`ice_analog_visual.gd`) is replaced by the real integration (designer: "Replace it"). *Not built yet.*

**ENC-CONCEPT-001 — The encounter interface follows the three concept screenshots (APPROVED direction, 2026-11-19).** Designer: "I want the interface to be based entirely on the mockups / screenshots I gave you. I want those to be the new interface, and we'll figure out the background for each corp." References: `docs/visual/explorations/ice-analog-001/ICE_ANALOG_CONCEPT_01–03`. Which concept supplies what (designer, in session):
- **Interface (frame, top bar, ICE consoles, keys, TUMBLER reel, tooltip, END TURN): concept 3.** "I want you to use the interface look from screenshot 3."
- **Cards: concept 2's look** (clarified by the designer, 2026-11-19: "each card is essentially a little bit smaller. They're all white. They have bright colors on them… just essentially the word on the card, the name of the card, a little image"; "I'd rather ChatGPT create the look"): smaller white cards with the name and a small bright picture; rules on hover. The CARDS-004 **fan** stays as the way a crowded hand fits: more cards overlap more and tilt at a set angle (designer: "Use the fan… to fan out the cards when there are too many cards on the screen, to fan them out at a certain angle and in a certain proximity to each other card"). Frames and pictures from ChatGPT (`ART_BRIEFS.md` §3). Earlier note: "Make a mix of both, use the fan, icons on cards and mix it with this graphic style"; "use the card look from screenshot 2". Changes the CARDS-001 face art; CARDS-004 fan/size and CARDS-005 icons stay.
- **ICE mascots: concept 2's characters** (AUTO-RENEW a TV-head robot, CAPTCHA a pin-up switchboard operator). "Redraw like the concepts"; "with more friendly, comical-looking avatars. I want you to go with this specific direction." Replaces the VIS-001 mascot art; moods and lines stay.
- **Left HUD: a mix of concepts 2 and 3, closer to 2, with more icons** ("More icons, but more like screenshot 2"). Installed Programs live **inside the left CRT panel** (designer).
- **Art:** the designer generates mascots and card illustrations in ChatGPT from Claude's briefs (`docs/visual/concept-art/ART_BRIEFS.md`); until a file lands, the current art stays in place.
- **Painted interface (designer, 2026-11-19: "write a brief for the painted interface parts… I want that design from those 3 screenshots from ChatGPT implemented"):** the console, key caps, top bar, CRT, vitals, END TURN, tooltip, frame and backdrop are painted in ChatGPT as separate parts (`docs/visual/concept-art/UI_KIT_BRIEF.md` (retired by UI-BIBLE-001; now [UI Design Bible, Source 5](PANOPTICON_UI_DESIGN_BIBLE.md#source-5-docsvisualconcept-artui_kit_briefmd))) and assembled by the game, which draws all text, numbers and live states on top.
- Backgrounds per corporation: to be decided later (designer).
- **Program cartridges (2026-11-20; designer: "it should be visible how many programs are installed by looking at how many card notches are… like an 8-track… Let's make them slim like the cards"):** each installed program is a slim card (its type's card frame and picture) sticking out of a slot on top of the CRT; the one on screen sticks out further and has a green lamp; clicking a card puts it on screen. The left column moved down 30 px to make room.
- **MOOD-PIXEL-001 (2026-11-20; designer: "the transition from one avatar state to another should look 16-bit then go back to normal resolution; then if deadly… pulse in and out of 16-bit… 2 seconds on, 2 seconds off"):** when an avatar's mood changes, the old face drops into 16-bit (0.25 s), swaps to the new face at the 16-bit peak, holds (0.2 s) and resolves to full resolution (0.35 s). While lethal, the avatar is 16-bit for 2 s, then crisp for 2 s, repeating (0.18 s slides between). 16-bit = 4-px cells, 24 colour levels per channel, ordered dither; when TRACE has already pixelated the screen (PIXEL-TRACE-001) the pulse goes to twice the TRACE cell size so it still shows. Masked to the avatar, presentation only, off under REDUCED MOTION. **Designer, 2026-11-21:** confirmed the avatar returns to normal resolution after each transition, the 2 s / 2 s lethal pulse, and that reduced motion skips the pulse ("skip the pulse"). *Still to confirm:* the 0.8 s change timing.
- **AVATAR-001 (2026-11-20; designer: "the type of avatars should be different, so that the faces don't all look the same… one person should be able to look at an avatar and instantly know which corporation it's from and generally what it does. And even what kind of ice it is… Sentries should be fun to build"):** corporation = palette, materials and one emblem (HALCYON sunrise fan, IRONWATCH searchlight-fan badge, LUCIDA halo ring); what it does = the character is a product or staff member of that corporation's service; ICE type = body plan (FORTRESS the wall, TUMBLER the spinner, VOID the watcher). No two ICE of a corporation share a face type. Sentries (VOID, formerly SENTRY per NAME-001) are built from a body, a sensor and a stinger from the corporation's catalogue. Full rules and prompts: `docs/visual/concept-art/CHATGPT_PROMPTS_ROUND3.md` §2.
- **CAPS and Ghostware on the encounter screen (2026-11-20; designer: "account for caps… placeholder caps. We need a minimum of 3… space for an unlimited number of ghostware… hovering over the interface… along the very top… roll over them to see what the ghostware is"):** a CAP rack with 3 empty slots sits in the hand tray right of the hand (UPL caps rules: "beside your hand"); the hand area is 80 px narrower. Ghostware hang as round badges from the pipe along the top of the ICE area, ORIGIN first with a gold rim, then the run's other Ghostware, any number, shrinking to fit one row; hover or focus shows the name and effect. Placeholders (initials, glass tubes) until the icons arrive. Positions confirmed by the designer 2026-11-20 ("I like both positions").
- **Console colour (2026-11-20; designer: "yes add console colour", on Claude's idea from ChatGPT's IRONWATCH encounter mockup):** each corporation's ICE consoles are painted in its own enamel. HALCYON keeps seafoam; IRONWATCH is navy (#1F3A5F); LUCIDA is lilac (#C9B6F2), the FACADE-001 enamels. Painted art (`UI_ICE_CONSOLE_2_<CORP>.png`) wins; until it exists a shader repaints the seafoam enamel and leaves chrome, brass and dark slots alone. Text straight on the console switches to cream on dark enamel (contrast checked at 4.5:1 for every corporation). Prompt: `docs/visual/concept-art/CHATGPT_PROMPTS_CONSOLES.md`. Presentation only.
- **AVATAR-001 amendment, LUCIDA (2026-11-20; designer: "completely different avatars for ICE that have very little resemblance to human features, although you can still make out their faces… for Lucida"):** LUCIDA's ICE are machines and objects with faces made from their own parts (lenses, dials, lights, slots, screens, reflections); no skin, hair, noses, ears, human hands or human body shapes. **Same day, v2** (designer: "creepy, stuff of nightmares ice avatars, no human features. Some can have mechanical tentacles, jellyfish-like, giant slug, but all very mechanical"): LUCIDA's ICE are mechanical nightmare creatures (chrome tentacles, glass-belled jellyfish, giant slugs, centipedes, crabs, eels) dressed as wellness products; uncanny even when cheery; no gore; still a readable face made of machine parts. Mockups first, then the full set. Prompts: `docs/visual/concept-art/CHATGPT_PROMPTS_ROUND6_LUCIDA.md`.
- **AVATAR-001 amendment, IRONWATCH (2026-11-20; designer, answering the prework questions):** IRONWATCH's ICE are "a cross between" heavy civic machinery and faceless authority, "with robot dogs, saucer drones", built on FACADE-001's appliances (plus designs for the four escape ICE). Uniform details yes, human faces no (the K9 robot dog is the one animal face). Escalation by mood through hidden hatches: "the more lethal the phase, the more gas hoses, tiny little guns, lazers and syringes (especially the syringes) come out of all sorts of places, with previously unseen doors and hatches". Mockups first. Prompts: `docs/visual/concept-art/CHATGPT_PROMPTS_ROUND7_IRONWATCH.md`.
- **Corporation backgrounds (2026-11-20):** painted friendly and hostile backgrounds per corporation (`BG_<CORP>_FRIENDLY/HOSTILE.png`, 1600 × 1000), detail along the edges and centre line where the interface leaves gaps; the game uses them in place of the atrium when present. Prompts: same doc §3.
- **Program screen (2026-11-20; designer: "I cannot do anything with programs once they are installed… One needs to be able to rotate between installed programs to use the active one… The player drags the program onto the target"):** the CRT shows one installed program at a time in big type: its name plate (an Icepick's plate is dragged onto a key to break it), STR and the ICE type it breaks, BREAK and BOOST costs, a full-width **+STR** button, × to unload, and ◀ PROGRAM n/N ▶ (or the mouse wheel) to rotate. A newly installed program comes to the front. Clicking or pressing Enter on a key breaks with the program on screen; if it can't, the cheapest Icepick that can, and that one comes to the front. The key tip says which program and how many boosts. Presentation only: it uses the existing break and boost rules. *Interpretation to confirm:* the click fallback to another Icepick.
- **Concept-2 layout pass (2026-11-20; designer: "both batches are in the folder now. do the full layout pass"):** UI kits 2 and 3 wired. Top bar: brand plate, graffiti decal, TURN plate, TRACE counter, HOSTILE REVEAL alarm (hot from 40%), RESERVE dial, corp sign; strikes, CONDITION and CRED/RAM on a second row. Left column: CRT with a picture per condition, punch cards, the NUL/REM note as a clipped paper slip, REDUCED MOTION / VOICE / KEY LEGEND buttons, vent and valve trim. Middle: two ICE cabinets (concept 2) fill the band; the character stands top-left, name and STR in the top-right slots, bigger keys in the recessed band, comic speech bubble, PASSIVE and NEXT RESPONSE plates below. A black-glass ticker carries the rack and log. Bottom: vitals beside a copper hand tray with deck and discard wells, DECK / COVERAGE and END RUN tray buttons, and END TURN as the mushroom-button box in the tray housing. Hand cards drawn at 0.72× (`FriendlyHand.HAND_SCALE`) so they sit in the tray; other card views stay 1.0×. A KEY LEGEND card toggles over the right console. *Interpretations to confirm:* the homes for information concept 2 leaves out; hand cards at 0.72×; NUL/REM moved to the left column; the corp sign at top right; unused parts (TUMBLER drum, big key socket, slot panel, knob, lamp stack, card back) wait for a use.
- **Art wired (2026-11-19):** the ChatGPT UI kit, card frames, batch-1 card pictures and the AUTO-RENEW / CAPTCHA mascots are loaded from `godot/assets/concept/` with a fallback to the drawn versions. Cards show at 1.0× (`FriendlyCard.DISPLAY_SCALE`; CARDS-004's 1.4× size superseded for the concept face, its fan rules kept). *Interpretations to confirm:* 1.0× cards; rules on hover only; the delivered backdrop waits for the corp-background decision.
Supersedes ENC-ANALOG-001's flip-clock HUD and split-flap plates (not built; set aside). **Interface built (2026-11-19):** see HANDOFF ENC-CONCEPT-001; the shared NEXT RESPONSE strip is replaced by a NEXT RESPONSE plate on each ICE (each ICE's part of the response in full words), which now carries the always-visible rule text that ICE-ANALOG-001 relies on. *Interpretations to confirm:* HOSTILE REVEAL shows the bleed reveal (0% Friendly, 20–60% Cracking, 100% on a strike or Mask off); graffiti moves to a decal plate in the top bar; the NUL/REM note moves to the right column; consoles use the plaque ground tinted toward the corp accent. ICE-ANALOG-001's icon keys and key tips stay and are restyled to concept 3. Mockup numbers, cards and ICE values are illustrative; the rules engine is the authority. Presentation only.

**Baseline verification (Codex, 2026-11-19).** The [DEV-001 validation entry](REDLINE_DEVELOPMENT_LOG_ARCHIVE.md#2026-11-19--dev-001-validate-the-card-and-hand-baseline-codex) records a Godot 4.3 rerun for CARDS-003 through CARDS-005a and HAND-MAX-001 at `2d5301a`.

**VISUAL-APPROVALS-002 — Prototype art and working values approved (APPROVED, 2026-11-17).** The designer approved every item below, which had been waiting for review. Designer: "Okay, all those changes that you listed are all approved." Numbers stay tunable presentation values; approval means build from them, not that they can never change. Sources: the 2026-11-17 VIS-001, CHROME-001 and CARDS-001 entries in `REDLINE_DEVELOPMENT_LOG.md`.

- **CHROME-001 (HALCYON encounter), commits 15ae99e–4c2135e:** the generated calm and hostile atrium art and the CAPTCHA/AUTO-RENEW appliance shells; six shared collage illustrations assigned by card role (no per-card art yet); a 20% reveal of the hostile atrium during Cracking; pearl-enamel ICE plaques (pearl `#EDF4F0`, slate `#20343B`, teal `#165B55`) that stay clean in Mask off; the layered silver rim, small Deco fan and placeholder HALCYON wordmark on mascots; mascot carriers at 82% with two ICE and 70% with three; a 2.5-second break confirmation in a header at the top of the screen.
- **CARDS-001 (cartridges), commits 083df86–b7e3747:** the integrated set; rarity finishes (common plain, uncommon two notches and a brass fitting, rare three notches and finer metalwork, with full rarity labels); instrument amber `#D6B675`, glowing amber numbers `#F2CD87` with a faint halo, and a dark BW badge with amber numerals; the four board surface textures.
- **VIS-001 (all corporations), commits a66a630–c96e522:**
  - **Hand size:** no maximum for now; hands of 7 or more fan out instead of shrinking. *(Replaced by HAND-MAX-001 and CARDS-004, 2026-11-19.)*
  - **Lethal mood:** an ICE turns lethal when a single subroutine in its next response deals PULP 5 or more, or any CORTEX (tunable `lethal_pulp_threshold`, default 5); Mask off and Black ICE are always lethal.
  - **Undrawn ICE:** the placeholder silhouettes for ACCEPT ALL, REJECT ALL, TERMS OF SERVICE, CONSENT FORM and HOUSE CALL, and their cheery / wary / lethal wording as logged in VIS-001c (FREE TRIAL's fallback lines included).
  - **Motion:** FORTRESS bob 3.6 s, VOID 0.3 px, TUMBLER ±0.35° fidget, linear 90 ms card snaps, 350 ms strike-card flight, 180 ms toast entry, toast 3 s, strike modal 2.5 s or until dismissed.
  - **Cracking after a strike:** the corporation stays in Cracking after strike 1, even if TRACE drops below 20.

Not covered by this approval: the rules questions still listed in `HANDOFF.md` (ZEROED-001 interpretation, ICE Rules Bible audit, REEL-001, RIOT-003, PULP-001) and PR #1.

**DEPRECATE-001 — LOGIC BOMB and RELAY deprecated for now (APPROVED, 2026-11-17).** The rare SCRIPT **LOGIC BOMB** ("Target ICE's STR becomes 0 until the end of your turn. BURNED.") and the ICE passive **RELAY** ("While this ICE has an unbroken subroutine, the ICE to its right gets +2 STR.") are removed from play. Reason: they don't work in the current rules (the STR floor and ZEROED rules, DSY-009/010 and ZEROED-001). This closes the ZEROED-001 interpretation question about them. Their definitions stay in the docs, marked deprecated, so they can be revised and brought back later. **Effects:** LOGIC BOMB leaves the reward pool; CONSENT FORM (the slice's only RELAY ICE) keeps its subroutines and STR and has **no passive** until the designer gives it one; SWITCHBOARD, whose passive was RELAY, has no passive for now. Designer: "Let's deprecate logic bomb and relay for now. They don't work in the current rules environment."

**PULP-001 — FORTRESS PULP is rolled each time, with slight variation (APPROVED, 2026-11-17).** A FORTRESS PULP subroutine does **not** deal the same fixed amount every time; its value is rolled each time it fires. The variation is **slight**, so the Rustler can still plan to some degree. This answers the open PULP-001 question ("fixed per subroutine, not rolled?") the other way: rolled. Designer: "For number 4, they are rolled each time. They should be slightly variable so that the rustler can plan to some degree." **OPEN:** how wide the roll is for each printed value, how it's shown before it fires, and how it relates to PULP-002 curves (curve B is already random). Don't build a range until those are decided.

**RIOT-003 — SHATTER readings confirmed (APPROVED, 2026-11-17).** SHATTER (RIOT starter SCRIPT, EXPLOIT; 1 BW, +3 TRACE): "any 1 icebreaker" means SLEDGE can break the subroutines of **any one chosen ICE, whatever its type**, this turn. At the end of that turn SLEDGE drops to **STR 0 for the rest of the encounter** (boosts lost; boosting again starts from 0) and is back to its normal STR 2 at the next encounter. Designer: "For number 3, that is correct."

**TUMBLE-001 / REEL-001 — Broken TUMBLER subroutines tumble out at once; no DEADLOCK counter (APPROVED, 2026-11-17).** Reaffirms TUMBLE-001 (designer, 2026-11-16; Core Rules §5.4): as soon as a TUMBLER subroutine is broken it **disappears**, and the **next unbroken subroutine in sequence** tumbles in to take its place, active at once. Broken subroutines never come back into view. TUMBLERS still rotate once each turn as normal. Because a broken DEADLOCK can no longer reappear, the REEL-001 follow-up (show a DEADLOCK total on TUMBLER cards) is **not needed** and is closed. Built and tested (`zeroed-tumble-step3`). Designer: "as soon as a subroutine is broken on a tumbler, the broken sub disappears to reveal the next subroutine in sequence, which needs to be an unbroken subroutine … Tumblers still tumble once each turn as normal."

**ICE-AUDIT-001 — ICE Rules Bible audit applied to the HALCYON slice before the playtest (APPROVED, 2026-11-17).** Designer: "apply the changes to the Halcyon ICE now. That is before the playtest." Choices for the either/or rows made by the designer in session (CAPTCHA: TRACE 2; CONSENT FORM and REJECT ALL: PULP 3).

| ICE | Was | Now |
|---|---|---|
| CAPTCHA (TUMBLER · SNARE) | STR 5; 2 slots of 5: DISCARD 1 · DEADLOCK · **PULP 6** · DEADLOCK · TRACE 3 | **STR 4**; 2 slots of 5: DISCARD 1 · DEADLOCK · **TRACE 2** · DEADLOCK · TRACE 3 |
| AUTO-RENEW (FORTRESS · RATCHET) | STR 4 | **STR 5** (subroutines unchanged) |
| DOORBELL CAM (VOID · WATCHER) | STR 4; [S1] TRACE 3 + DEADLOCK | **STR 3; [S1] PULP 4 · [S2] CORTEX 1 · [S3] DEADLOCK**; WATCHER kept |
| CONSENT FORM (TUMBLER · SWITCHBOARD) | PULP 4 | **PULP 3** (rest unchanged; no passive per DEPRECATE-001) |
| REJECT ALL (TUMBLER) | PULP 4 | **PULP 3** (rest unchanged, one DEADLOCK per REJECT-001) |

COOKIE WALL keeps its TRACE 2 as the only FORTRESS TRACE. ACCEPT ALL, TERMS OF SERVICE and HOUSE CALL are unchanged. *Side effect:* CAPTCHA no longer carries PULP 6, so it won't turn lethal the way the approved VIS-001/CHROME-001 screenshots show; those images need refreshing once this is built.

**PULP-001 — Roll size (APPROVED, 2026-11-17).** Each time a FORTRESS fixed-value PULP subroutine fires, roll its value around the printed number: usually **printed −2 to +2**; on about **30% of rolls** (about once every 3–4) the swing is instead **printed −3 or +3**. It is random, not on a schedule. **A roll never goes below PULP 1.** Designer: "the roll should be +2, -2 with once every 3 to 4 turns, a +3 or a -3", and chose a random chance over a fixed rhythm. *Big swings are equally likely up or down (+3 or −3), confirmed by the designer 2026-11-17.* *Working values still to confirm:* each value in −2..+2 equally likely; the roll uses the Game RNG (seeded, reproducible). **No surprise (APPROVED, 2026-11-17):** the Rustler always sees exactly what PULP that subroutine will deal in the next Corporation Response. The value is rolled ahead of time (working timing: at the start of the Rustler's turn), shown on the ICE and in the response strip as a plain number, and that exact value is what fires (less any SCRAMBLE or other reductions the Rustler applies). The variation is between turns, not hidden inside one. Designer: "the rustler is always going to see what pulp damage the corporation is going to deliver next turn with that subroutine. So there is no surprise for the rustler." Consequently the VIS-001 lethal mood reads the shown rolled value (PULP 5+). **PULP-002 curves keep their designed patterns and do not roll (APPROVED, 2026-11-17).** Curves A (SEQUENTIAL), B (RANDOM) and C (HAMMER) are unchanged; the ±2/±3 roll applies only to fixed-value FORTRESS PULP. Under the no-surprise rule, every curve shows its **next value** before it fires; curve B no longer shows "PULP ?". Rationale: HAMMER's spikes are meant to be seen and planned for, and a roll could push its 9 to 12; RANDOM already works like a fair bag (always 30 over nine hits, no streaks); SEQUENTIAL is the learnable pattern; PACE-005 counts each curve at its designed average. Designer approved the recommendation: "Yes, record it that way."


**FACADE-001 — Raygun Gothic facades for IRONWATCH and LUCIDA (APPROVED, 2026-11-17).** The designer approved `REDLINE_CORPORATE_FACADES.md` as written. Designer: "Correct. Approved." This makes the following decisions:
- **Three degrees of watching** set every corporation's voice in all interfaces: HALCYON watches the home and sells comfort; IRONWATCH watches the street and who you're with, and sells safety and status; LUCIDA watches the mind and sells peace of mind. Each one's interfaces ask for, remember and reward differently (§1). The corporate voice never rises before *Mask off*.
- **IRONWATCH "SafeStreets":** a Raygun Gothic civic security concourse in navy enamel and brass; signature motif the searchlight fan; hostile reveal at the same perspective (your path lit on the floor map, holding cells behind the grilles, drones in the kiosks, converging searchlights, risen barriers) (§3).
- **LUCIDA "lucida rest":** a domed wellness solarium in lilac pearl and rose-copper; signature motif the halo orbit; hostile reveal at the same perspective (halo rings as cranial scanners, restraint cradles, one-way glass, a dome of lenses) (§4).
- **Plaque colours** (contrast checked), non-fight interface copy, strike and Mask-off lines, the **ICE appliance list** with silhouettes, faces, DEADLOCK buttons and mood lines, and Bloatware footers as written (§3–4). Copy and numbers stay working values.
- **Art briefs** (§5) are the basis for generating the backgrounds and mascot shells; prompts must be recorded in `SOURCES.md` at generation time.
- **Follow-ups decided (2026-11-17):** HALCYON gets matching non-fight copy (written in §2a); the IRONWATCH and LUCIDA art is generated **now**, before the HALCYON playtest; the escape ICE of both corporations **wait**. Designer: "for number one, yes. For number two, yes. And for number three, wait."
- **HALCYON non-fight copy (APPROVED, 2026-11-17):** The designer approved the consent, remembered activity and reward copy in §2a and will review it in playtesting.
## 2. Player, corporation, and encounter loop

**HAND-CLEANUP-001 (APPROVED, 2026-11-17):** DSY-012’s free HOLD choice is removed. END TURN proceeds through the existing response and cleanup. Remaining non-CACHED cards go to discard, and the next Rustler turn draws 6 at base DRAW in addition to already CACHED cards. Existing draw modifiers and card-granted CACHE continue to apply. DEAD MAN’S POCKET’s old HOLD 2 hook is inactive pending an independent effect.

**CARD-CONTROLS-001 — PROGRAM bay and card inspection (APPROVED, 2026-11-17):** Install PROGRAM cards by dragging them into the PCI-style bay on the left HUD. Installed Programs appear there for hover and click inspection and retain their controls. Drop a targeted SCRIPT on eligible ICE, or an untargeted SCRIPT on the upper half of the encounter. Right-click enlarges a card to 150% and right-click again closes the preview.
**ENCOUNTER-DISPLAY-001 (APPROVED, 2026-11-17):** Fill the fullscreen viewport with the encounter background in every corporation state. Enlarge ICE faces and animated avatars by 25% without scaling their rules plaques.

The player is the **rustler**; the opposing system is the **corporation**. Encounters involve ICE, cards and breakers, damage/trace subroutines, and advancement gates. **LOCKED encounter order:**
1. Rustler takes their action.
2. On the corporation turn, **all remaining unbroken damage and Trace subroutines fire**.
3. If **DEADLOCK** has been broken, the rustler may advance **after** that corporation turn.

**Implications:** breaking DEADLOCK does not bypass the corporation's immediately ensuing turn. Broken subroutines do not fire. Do not assume unspecified energy costs, hand sizes, draw rates, encounter counts, or exact victory conditions: **OPEN/VERIFY**.

### ICE and breakers
- ICE has subroutines; breakers interact with ICE. **LOCKED UI direction:** drag a breaker to ICE; use a fixed ICE inspection bay; display strength as **`[STR X]`**.
- **DEADLOCK** is an advancement-control subroutine. Its timing is governed by the encounter order above.
- Damage and Trace subroutines can coexist on ICE; all unbroken applicable subroutines resolve on the corporation turn.
- **PAPER CUT** is a favoured **CONCEPT** for **Strength 0 ICE**, combining minor damage, NEURAL/SYNAPTIC discard pressure, and DEADLOCK. Its exact card stats, wording, art, and implementation are **not locked**; balance-test before promotion.
- **Black ICE** and Trace are established system concepts; exact formulas, thresholds, and card roster require **VERIFY** against the reference implementation.

## 3. Damage and card terminology — canonical glossary
| Term | Canonical meaning | Status |
|---|---|---|
| **NEURAL DAMAGE X** | Rustler **chooses** and discards **X cards from the current hand**. | **LOCKED** |
| **SYNAPTIC DAMAGE X** | **X randomly selected cards** are discarded from the rustler's **current hand**. | **LOCKED** |
| **Vitae** | A separate player survivability/resource measure; **neither NEURAL nor SYNAPTIC DAMAGE reduces Vitae**. | **LOCKED distinction** |
| **PURGE** | Reserved for the **corporation removing virus counters**. Do not reuse for rustler discards or generic deletion. | **LOCKED** |
| **DEADLOCK** | ICE subroutine gating rustler advancement; breaking it allows advancement only after the corporation turn. | **LOCKED** |
| **Trace** | Escalating pursuit/detection system; can be reduced at DEAD DROP. | **Established; formulas VERIFY** |
| **PATCHWORK** | Persistent modification associated with an **individual card instance**, not simply a shared card definition. | **LOCKED concept** |
| **Ghostware** | **Permanent non-card** upgrades; distinct from cards and PATCHWORK. | **LOCKED concept** |

**Edge cases to specify/test (OPEN):** what happens when X exceeds hand size; exact discard destination; ordering when multiple discard effects trigger; random-selection seed/test reproducibility; interactions with other triggers. Do not infer permanent card destruction from either discard effect.

## 4. Persistence and progression
### Hardware recycling
**LOCKED:** hardware recycling occurs **exactly once at encounter end**. Avoid duplicate recycling through multiple encounter-end callbacks. Exact eligibility and destination rules: **VERIFY**.

### PATCHWORK
**LOCKED:** PATCHWORK persists on **individual card instances**. Implementation must preserve identity through collection changes and save/load; it must not accidentally apply an upgrade to all copies of the same base card. Exact PATCHWORK options/costs: **VERIFY**.

### Ghostware
**LOCKED:** Ghostware consists of **permanent, non-card** upgrades. The interface includes a **Ghostware rack below RETURN**. **Signature Ghostware** is displayed once and marked **`ORIGIN`**; do not generate duplicate signature entries. Exact Ghostware catalog/effects: **VERIFY**.

## 5. DEAD DROP recovery choice
**LOCKED:** **DEAD DROP** replaces the former **Safehouse** terminology. At DEAD DROP the rustler chooses **exactly one** option:
- **PATCH UP** — restore **+10 Vitae**.
- **WIPE TRAIL** — reduce **Trace by 20**.

Do not grant both in a single visit. Bounds (maximum Vitae / minimum Trace), visit timing, and any other services require **VERIFY**; do not assume additional recovery options.

## 6. Interface and player experience

**UI-WORKFLOW-001 (designer-approved, 2026-11-24):** GitHub Issues are the single authoritative UI proposal and development register for Claude Code, Claude, Codex and ChatGPT. Use stable component IDs from the UI Design Bible. Keep proposal discussion, mockup links, acceptance criteria, designer approval, implementation links and validation evidence in the issue; do not duplicate the backlog in HANDOFF or separate agent files. Only the designer approves; record approved decisions in Master Design and update the UI Design Bible as applicable. Development Log records actual work and links to the issue. Daily operations review uses the same issues. No code or rules changes.

**UI-BIBLE-001 (designer direction, 2026-11-24):** [PANOPTICON UI Design Bible](PANOPTICON_UI_DESIGN_BIBLE.md) is the consolidated UI working specification, opening with “Visually rich but informationally restrained.” Icon-first resource HUD (Vitae, BW, RAM, Shield, incoming PULP), persistent top Ghostware rail and first ORIGIN badge in mockups. Existing decision IDs and rules authority remain unchanged. Source documents retained pending dependency/narrative audit; no parallel new UI briefs. No code changes.
**Established decisions:**
- Fixed ICE inspection bay, avoiding unpredictable layout shifts.
- Drag-to-ICE breaker interaction.
- Explicit strength labels formatted **`[STR X]`**.
- HUD tooltips to explain rules and stats without cluttering the primary view.
- **HOVER-001 (APPROVED 2026-11-20, designer: "the hover text box should always include a large/high resolution image of the card or cap or ghostware etc. alongside the text"):** every hover or keyboard-focus box for a game object shows a **large, high-resolution image of that object beside its text**: cards (the full card face), CAPS (the vial), Ghostware (the badge), installed programs (their card), ICE (the avatar in its current mood) and subroutine keys (the key with its icon). The image comes from the full-resolution source art, never an upscaled thumbnail, and is at least twice the size the object has on screen (cards at least 1.5× their hand size). Image first (left, or top when there's no room), text beside it. Until an object's painted art exists, the box shows the best available stand-in (the drawn face or the placeholder), never an empty frame. The box must not cover the object being hovered, and the readability rules still apply (contrast at least 4.5:1, nothing crosses the text). Built 2026-11-20 and part of every build from Playtest 8 on (designer: "Include that rule in the next build going forward"). ICE avatars get no extra box, because they are already drawn large (designer 2026-11-20: "Ok for ice - except for subroutines. They might have effects beyond their icon(s)"). **Subroutine keys** therefore list **every** effect of the subroutine, one row each with its own icon, plus anything else that touches it: multi-step DEADLOCK progress, BOOTING locks, TUMBLE, and the ICE's passive.
- Ghostware rack **below RETURN**.
- Signature Ghostware shown once with **`ORIGIN`**.
- NUL/REM presented as a **retro CRT companion**, integrated into the game's interface and voice.

**Visual direction:** arcade-neon/cyberpunk energy, retro computing, readable tactical information, and strong differentiation between flavour text and executable rules. Specific palette, fonts, screen dimensions, animations, accessibility settings, and final Godot scene hierarchy are **OPEN**.

## 7. NUL/REM — companion character bible

**NUL-PILLAR-001 (2026-11-23, designer-confirmed direction):** NUL/REM is a foundational design pillar and the intimate expression of PANOPTICON's fictional psychological experiment. See [NUL/REM and the self-built prison](REDLINE_NULREM_BEHAVIOURAL_LOCK_IN.md).
**Core characterization (LOCKED/DIRECTION):** dry, morose, sarcastic; intelligent but not infallible; quietly protective of the rustler; steeped in classic videogame, hacker, and retro-computing history. The voice should feel like an exhausted machine that has seen too much and occasionally finds something genuinely wonderful.

**CANON (2026-11-13) — Identity:** NUL/REM is **rev 0.08**, a salvaged, obsolete **personality ROM**, **manufactured in 1987**, referred to as **he**. He wants sleep and shutdown but is compelled to protect the Runner. Memories of events before 1987 (e.g. ARPANET going online in 1969) are the Unreliable Historian's impossible memories; their explanation stays OPEN. Source: `REDLINE_UI_NULREM_Design_For_Claude.md` §6 (retired by UI-BIBLE-001; §6 now [Dialogue Architecture, Appendix A](PANOPTICON_NULREM_DIALOGUE_ARCHITECTURE.md#appendix-a--legacy-nulrem-personality-design-bible-relocated-by-ui-bible-001)). Approved example lines are Bible verses NR-002 to NR-008. **CANON trait (2026-11-13):** fastidious about germs despite having no body or immune system (Bible §5). **CANON trait (2026-11-13):** compelled to reference fictional computers from film and games (HAL 9000, WALL-E, Number 5, Proteus IV, Impossible Mission's “Stay a while. Stayyyyyyy forever!”, Evilspeak's Apple II, Little Britain's “Computer says no”, Columbo's K44 and MM7, Tron's Master Control Program, The Black Hole's robots, and Marvin, whom he insists he is nothing like) **CANON trait (2026-11-13):** 1982 is his special year (most of his memory chips' programming; his favourite music and films); he reminisces most about 1982 and 1987. **CANON trait (2026-11-13):** he considers himself too sophisticated for his work, though he'd rather do nothing at all. **DIRECTION:** his references assume the player knows the work, with no plot summaries or years other than 1982 and 1987 (Bible §5). and to make silly retro-game references (Bible §5).

**Six preserved personality modes (LOCKED):**
1. **The Pedant:** obscure hacker/computing history and precise technical corrections.
2. **The Cynic:** sharp, economical one-line judgments.
3. **The Melancholic:** yearns for sleep, shutdown, or quiet.
4. **The Reluctant Guardian:** cares for the rustler, disguising concern as irritation.
5. **The Unreliable Historian:** claims impossible memories from before its manufacture.
6. **The Occasionally Delighted:** brief, rare moments of sincere enthusiasm or wonder.

**Dialogue guidance:** weave in authentic retro-gaming/computing references (e.g., the ritual of blowing on cartridges) without turning every line into a reference dump. Anchor genuine historical claims in real history; make impossible autobiographical claims clearly part of NUL/REM's unreliable persona. Prefer brief, context-sensitive lines over repeated monologues. Preserve emotional range and the ongoing character arc; don't flatten NUL/REM into a generic quip machine.

**OPEN:** exact trigger table, frequency caps, sample dialogue library, audio/voice treatment, relationship progression, and the full explanation of NUL/REM's origins.

## 8. Story and worldbuilding
**Established narrative canon:** **The First Signal** is an **actual synchronization transmission**, not merely a metaphor or fabricated legend. PANOPTICON explores the **human/machine boundary** and the possibility of crossing it. The world includes a hidden-AI mystery and cipher fragments.

**Intentionally unresolved story questions:**
- What does the hidden AI actually want? *(Designer-level answer, SIGNAL-001: a higher consciousness through synchronization with humans; it is the umbrella AI behind all three corporations. Unrevealed in the game until the end.)*
- What is NUL/REM's relationship to the First Signal or the hidden AI?
- What purpose do the cipher fragments serve?
- Is synchronization **evolution**, **liberation**, **assimilation**, or some combination?

**Narrative constraint:** do not prematurely resolve these ambiguities as settled canon. New story pitches should be marked **CONCEPT** until approved.

**SIGNAL-001 — The three First Signal punch cards (APPROVED, 2026-11-17).** Designer: "Since this game is about the first signal (as one of the central themes) the player could be collecting 1 of 3 punch cards from each corporation in order to process an uplink signal that jams the umbrella corporation's signal that would finalize the merging of man and machine." Decided in follow-up answers the same day:
- **One card per corporation, three in total.** Each corporation always gives the same card; cards can't be lost or vary between runs for now (each run is discrete). The card is the First Signal data the Rustler steals there (RUN-006), and processing all three is the full run's final act (answers RUN-006's open "final victory trigger after the third corporation"; the end sequence itself is still to be designed).
- **The umbrella is an AI that controls all three corporations.** "Umbrella" is a description, not a name. It stays unknown until all three cards are taken. Designer: "it really is an AI who controls all corporations, it is unknown until after all 3 cards are attained."
- **What the First Signal is.** Generally, the first sign of consciousness in any being, from the cellular level to the macro (consistent with the Bible guidepost "Every consciousness has a first signal"). In the game, the First Signal is the **machines' attempt to reach a higher consciousness by merging with humanity**. There have been many attempts through history; **speech synthesis** was the machines' main method (hence NUL/REM's references to it), until they decided the way was **synchronization with humans**. STORY-001 holds: the transmission is real, and it's the AI's. **Keep it vague in the game until the end.**
- **The purpose stays hidden** until after the third card (RUN-006 kept: the Rustler doesn't know the data's significance). The unknown employer remains OPEN.
- **Doubt stays.** Synchronization "could be all 3" of evolution, liberation and assimilation; the game doesn't settle it. **The Rustler jams it because going against whatever the corporations want is the Rustler's MO.**
- **Names:** the jamming signal is the **SYNCHRONIZATION SCRAMBLER**, "SCRAMBLE SYNC" for short. The hand-built zine device that reads the three cards is the **M0'B\*Loop**, pronounced "Mow Bee Loop", with the two o's drawn as one sideways 8 (∞) on screen: M0'B\*L∞P. Designer: "more important-sounding names, like Synchroniztion-Scrambler or scramble sync, and as for moebius - let's call it something punk, like M0'B\*Loop, pronounced Mow Bee Loop. With the oo's in loop looking like an 8 on its side to represent the loop." Neither clashes with the Black Market Uplink.
- **The umbrella AI is the hidden AI** in the questions above. Designer: "yes it is." So "What does the hidden AI actually want?" has a designer-level answer (a higher consciousness through synchronization with humans), which stays unrevealed in the game until the end.
- **Presentation and Phase 5 build tasks approved** (corporate card stock per corporation, arrival on BREACH of the central Node, a three-slot holder on the HUD, holes that only complete a pattern when stacked; SIG-5a–d). Designer: "approved".

Detail, writing rules until the end, presentation, how to render the M0'B\*Loop name, and build tasks (Phase 5): `REDLINE_ATOMIC_DECO_PUNK.md` (retired by UI-BIBLE-001; now [UI Design Bible, Source 4](PANOPTICON_UI_DESIGN_BIBLE.md#source-4-docsredline_atomic_deco_punkmd)) §8 and Part 3b. The end sequence (reveal, assembling the M0'B\*Loop, SCRAMBLE SYNC) is still to be designed.

**ARCH-001 — The Archipelago: being traced means disappearing (APPROVED, 2026-11-18).** Designer: the game should have "analogies to being traced and disappearing, analogous to the Soviet gulags where people were disappeared", and "we could even use the word archipelago at some place in the game." Decided the same day:
- **ARCH-R1 tone rules** ("1 y"): horror by absence (the islands are never shown); never a joke; the corporations never name it (people are "relocated", "resting"); "Archipelago" is the underworld's word; **the word *gulag* is never used on screen**.
- **Defeat framing** ("2 y"): no death animation; a calm corporate relocation notice, then a page of the zine ledger *THE CARBON* ("Taken to the ’Pelago."); a persistent, local-only record of every lost Rustler, read at DEAD DROP. Presentation only; no rule changes.
- **What the islands are for** (designer-level answer, secret until the third card): "merging man with the machine one at a time, in order to build the synchronization signal to sync/merge all mankind at once with AI, tie into ending, sync testing." The reveal therefore has two parts: the corporations are one AI, and the Archipelago is where it rehearsed the merge on the people it took. Synchronization stays ambiguous (SIGNAL-001).
- **No one comes back** ("4 no"): no rescue, return or escape, in rules or story.
- **ARCH-NAMES-001 — island names** (designer direction, 2026-11-18): "The island names should resemble names of long-term care residences and the more generic the name the better." Generic nature-word + residence-word names (Sunnyside Manor, Pine Ridge Residence, Willow Creek Lodge); no ™ or brand in the name; the corporation only in small print ("A HALCYON Care Community"). Specific names are working copy, for approval. **Programme names approved (2026-11-18)** as the small print under each island: *Halcyon Homesteads™*, *SafeHarbor Residences™*, *Long Rest Retreats™*.
- **ARCH-SLANG-001 — ’Pelago (APPROVED, 2026-11-18):** "In all Rustler references to the archipelago should be written as pelago with an apostrophe before the P. Rustlers wouldn't use a 5-syllable word without shortening it." On screen the Rustlers and the underworld always write **’Pelago** (’PELAGO in caps); the full word stays in design docs only and never appears on screen. Confirmed: "Pelago is the official in-game terminology to be used even at the very end."
- **ARCH-COPY-001 — working copy approved (2026-11-18):** designer: "All approved". The *THE CARBON* title, the *NOTES FROM THE ’PELAGO* column, the defeat framing copy and the polite anti-paper lines (ADP §2.2.3) are approved. The nine island names stay **working copy** until the designer checks them against real care homes. Historical background in the docs (samizdat, the Gulag) is inspiration, not a source to match, and needs no fact-check: "Don't verify history. This is a made-up world. It doesn't have to perfectly resemble the real world." (designer, 2026-11-18).
- **ARCH-LINES-001 — relocation lines (APPROVED, 2026-11-18):** the designer left them to Claude's discretion, then approved all 15 ("Perfect- add them"); five per corporation, listed in `REDLINE_ARCHIPELAGO.md` §4.0.
- **Build tasks ARCH-1a–c approved.** Working names and lines remain copy for approval.

Detail: `REDLINE_ARCHIPELAGO.md`.

## 9. Technical architecture and migration
**Reference build identified:** `REDLINE_Dead_Drop_Final_Playtest.zip` (Python/Pygame). Reported structure includes:
```
main.py
visual.py
engine/
  run.py
  content.py
  model.py
[regression scripts — exact filenames VERIFY]
```
**Status:** this structure is documented from a previous handoff, **not inspected in this document-generation session**. Automated regressions were previously reported passing; live Windows/Pygame UI playtesting remained incomplete. The reference ZIP and source files must be supplied/inspected before asserting present-day code behaviour.

**Migration principle:** implement Godot 4 as the production target while treating Python/Pygame as a reference oracle for mechanics. Map state transitions and deterministic tests before porting UI. Record parity differences explicitly. Do not claim the Godot port is complete or underway without evidence.

## 10. Canonical decision register
| ID | Decision | Status | Evidence basis |
|---|---|---|---|
| TECH-001 | Godot 4 production; Python/Pygame reference | LOCKED | Prior project decision |
| LOOP-001 | Rustler action → corporation fires all remaining unbroken damage/Trace subroutines | LOCKED | Prior project decision |
| LOOP-002 | Broken DEADLOCK allows advance **after** corp turn | LOCKED | Prior project decision |
| MECH-001 | NEURAL DAMAGE X = rustler chooses X hand cards to discard | LOCKED | Prior project decision |
| MECH-002 | SYNAPTIC DAMAGE X = random X hand cards discarded | LOCKED | Prior project decision |
| MECH-003 | Neither hand-discard damage type reduces Vitae or destroys cards permanently | LOCKED | Prior project decision |
| MECH-004 | PURGE reserved for corporation removing virus counters | LOCKED | Prior project decision |
| PROG-001 | Recycle hardware once at encounter end | LOCKED | Prior project decision |
| PROG-002 | PATCHWORK persists per card instance | LOCKED | Prior project decision |
| PROG-003 | Ghostware permanent and non-card | LOCKED | Prior project decision |
| HUB-001 | DEAD DROP replaces Safehouse | LOCKED | Prior project decision |
| HUB-002 | Exactly one: PATCH UP +10 Vitae / WIPE TRAIL −20 Trace | LOCKED | Prior project decision |
| UI-001 | `[STR X]`, drag breaker to ICE, fixed inspection bay, HUD tooltips | LOCKED | Prior project decision |
| UI-002 | Ghostware rack below RETURN; signature once with ORIGIN | LOCKED | Prior project decision |
| BURN-001 | Preserve six NUL/REM personality modes | LOCKED | Prior project decision |
| STORY-001 | First Signal is real synchronization transmission | LOCKED | Prior project decision |
| ADP-R1 | The chrome lies; the zine never does (rules readouts always true) | APPROVED | Designer, 2026-11-17 |
| ZINE-001 | The zine is paper plus retro-mutated technology; barcodes and punch cards, no QR codes | APPROVED | Designer, 2026-11-17 |
| SIGNAL-001 | Three First Signal punch cards, one fixed card per corporation; with all three the Rustler jams the umbrella AI's synchronization signal; purpose and AI hidden until the end; synchronization left ambiguous | APPROVED | Designer, 2026-11-17 |
| ZINE-002 | The zine is the underworld's samizdat: how it communicates where every corporate channel listens; censorship by convenience, not prohibition | DIRECTION (examples for approval) | Designer, 2026-11-18 |
| ZINE-003 | SAMIZINE: the underworld's zine look (carbon, ditto, kidnapped corporate type, palimpsest, pocket wear, copy generations) | APPROVED | Designer, 2026-11-18 |
| ARCH-001 | Being traced means disappearing to the Archipelago; ARCH-R1 tone rules; relocation defeat framing and persistent THE CARBON record; islands merge people one at a time to build the sync signal (secret until the third card); no one comes back | APPROVED | Designer, 2026-11-18 |
| RELEASE-001 | Builds come only from a `release` branch fast-forwarded from `main`; each build tagged `playtest-N`; export no longer runs on pushes to `main` | APPROVED | Designer, 2026-11-18 |
| EVENT-002 | Every SIGNAL UNCLEAR event offers a choice, except AMBUSH; MAINTENANCE WINDOW becomes heal 6 VITAE **or** −5 TRACE | APPROVED | Designer, 2026-11-18 |
| EVENT-003 | New 10th SIGNAL UNCLEAR event (working name CARE PACKAGE): +5 Max VITAE or a random rare card; odds: AMBUSH 20%, BROKER 5%, the other eight share 75% | APPROVED | Designer, 2026-11-18 |
| EVENT-004 | Random event offering a specific, dedicated Ghostware, powerful enough that it comes with a negative: a permanent Bloatware in the deck that can't be removed by normal means (option B: needs designing). **Each corporation has its own version** (designer, 2026-11-18: "each corp should have their own version of this 'reward'") | DIRECTION | Designer, 2026-11-18 |
| UPL-006a | DATA PURGE (SIGNAL UNCLEAR): remove 1 card for **+7 TRACE** (was +5) or −5 VITAE | APPROVED | Designer, 2026-11-18 |
| DOCS-001 | Which docs are current: authority order (master design → Core Rules → topic docs; amendment tables win) and a list of current vs history/lore-only docs in CLAUDE.md = AGENTS.md §6; older docs carry a "not current for rules" note | APPROVED | Designer, 2026-11-18 |
| DEV-001 | Claude Code is the main code developer; Claude (project) owns design; Codex takes isolated tasks on request; shared rules in CLAUDE.md = AGENTS.md | APPROVED | Designer, 2026-11-18 |
| DEV-002 | Fixes from the DEV-001b audit (HANDOFF DEV-002a–i): doc syncs for slice route, HOUSE CALL and reserve rounding; ad/LUCIDA copy into approval-tracked data; wider copy-guard coverage; island-name placeholders; atomic flags write; ARCHITECTURE corrections; CI push path filter | PROPOSED; **b, c, h APPROVED** (designer, 2026-11-21: reserve rounding up "CONFIRMED"; Playtest 6 ad and LUCIDA-edit wording "APPROVED"; doc-only pushes skip CI "YES") | Claude Code, 2026-11-19 |
| ICE-001 | PAPER CUT Strength 0 with minor damage/discard/DEADLOCK | CONCEPT | Earlier design proposal |
| ENC-ANALOG-001 | Analog / flip-clock / cockpit encounter screen (whole screen) | APPROVED | Designer, 2026-11-19 (ChatGPT, confirmed in session); `REDLINE_ENCOUNTER_ANALOG.md` (retired by UI-BIBLE-001; now [UI Design Bible, Source 2](PANOPTICON_UI_DESIGN_BIBLE.md#source-2-docsredline_encounter_analogmd)) |
| ICE-ANALOG-001 | Iconized ICE subroutine readout (icon + value; full text on hover/focus, amends VIS-001 §2.9) and larger, livelier mascots | APPROVED | Designer, 2026-11-19 (ChatGPT, confirmed in session); `REDLINE_ENCOUNTER_ANALOG.md` (retired by UI-BIBLE-001; now [UI Design Bible, Source 2](PANOPTICON_UI_DESIGN_BIBLE.md#source-2-docsredline_encounter_analogmd)) §7–8 |
| ENC-CONCEPT-001 | Encounter interface from the concept screenshots: frame from concept 3, cards and mascots from concept 2, left HUD mixing 2 and 3; art from ChatGPT per Claude's briefs | APPROVED | Designer, 2026-11-19; `docs/visual/concept-art/ART_BRIEFS.md` |
| HOVER-001 | Every hover/focus box for a game object shows a large, high-resolution image of the object beside its text (cards, CAPS, Ghostware, programs, ICE, keys) | APPROVED | Designer, 2026-11-20 (in session); §6 |
| PIXEL-TRACE-001c | Neon ballast buzz on each pixel-step transition, with the bit-crushed music (PIXEL-TRACE-001b) | APPROVED | Designer, 2026-11-21 |
| PIXEL-16BIT-001 | 16-bit look for the whole game | REJECTED (16-bit only for transitions and the lethal pulse) | Designer, 2026-11-21 |

## 11. Open specification backlog
**High priority:** retrieve the full reference ZIP and earlier detailed design notes; verify complete card/ICE catalog, costs, turn/action economy, Trace formulas, Vitae damage, Black ICE rules, virus mechanics, win/loss conditions, and exact PATCHWORK/Ghostware effects. Capture reproducible tests for every LOCKED rule. Define Godot migration milestones.

**Medium priority:** document progression map, economy/rewards, encounter generation, card rarity, tutorial/onboarding, complete narrative outline, and NUL/REM dialogue triggers.

**Low priority until core rules stabilize:** final art pipeline, audio, accessibility polish, save schema, packaging and release planning.

## 12. Document governance
- **Master Design** (this file): approved mechanics, narrative canon, character bible, and explicit open questions.
- **Development Log:** chronological work and evidence; append-only by session.
- **Current Status:** short operational snapshot; replace/update at each handoff.
- Every new rule should receive an ID, status, and test expectation. Every implementation claim should identify a source file, commit, or passing test. A chat summary alone does not certify a build.

### RELEASE-001 — Builds come from a `release` branch, tagged (APPROVED, 2026-11-18)
Designer: "when we produce a build, I want to produce them off the main, just in case any products are corrupted"; approved the proposal ("Go").
- **`main` stays the working branch.** All work lands there (MAIN-001 unchanged).
- **A `release` branch is the only branch that produces builds.** When the designer asks for a playtest build, `main` is fast-forwarded into `release` (no new changes made on `release`; nobody commits to it directly).
- **The Windows export runs only on pushes to `release`** (and on manual dispatch against `release`), not on pushes to `main`. Pushes and PRs to `main` still run validation (tests, screenshots).
- **Every build is tagged** (`playtest-N`) on the exact commit it was built from, and the artifact records that commit (`BUILD_COMMIT.txt`, as now).
- **Recovery:** a bad or corrupted build is rebuilt from its tag, or `release` is reset to the previous good tag. `main` is never touched by a build.
- Replaces MAIN-001's rule that Windows exports run on pushes to `main`.

### DEV-001 — Claude Code takes over code development (APPROVED, 2026-11-18)
Designer: "I want to migrate codex code development for the redline/panopticon project to Claude Code", keeping Claude (Cowork / claude.ai) for design and Codex for isolated tasks; approved Claude's plan ("Go ahead, yes").
- **Roles:** Claude Code is the main code developer (Godot build, tests, fixtures, CI, exports, current status). Claude in the "Panopticon" project owns design, playtest analysis, HANDOFF and the project doc copies. Codex takes small isolated tasks only when the designer asks.
- **Shared rules** live in `CLAUDE.md` and `AGENTS.md`, kept identical: the working agreement, roles, session routine, Godot 4.3 / typed GDScript / UI-in-code conventions, a no-refactor-unless-asked guardrail, presentation never read by rules, readability and copy guards, test commands, and the RELEASE-001 build flow.
- **Handoff sequence:** (1) Codex tags the checkpoint `pre-claude-code` on `main`, writes `docs/ARCHITECTURE.md` (system map), confirms the test commands, then steps back; (2) Claude Code's first session is a read-only audit comparing the code with `ARCHITECTURE.md` and the design docs, reporting mismatches before any new code; (3) normal development resumes from HANDOFF.
- No branch for the migration: the `pre-claude-code` tag and the `playtest-6` build are the restore points (MAIN-001, RELEASE-001).

### Source/provenance note
This consolidation uses prior PANOPTICON project conversation context and summaries of earlier handoff documents, notably `REDLINE_CURRENT_STATE_FOR_CLAUDE_2026-11-08.md`, `REDLINE_UI_NULREM_Design_For_Claude.md`, and earlier narrative notes. Their complete contents and the actual ZIP were **not accessible for direct inspection here**; therefore this is a careful baseline, **not a complete extraction of every past card or mechanic**. Missing specifics are explicitly marked VERIFY/OPEN rather than invented.

---

## 13. PANOPTICON thematic and structural design direction — 2026-11-10

**TITLE-001 — DIRECTION:** **PANOPTICON** is the preferred working title, subject to storefront/trademark availability and an intentional rename process. REDLINE remains the repository and document codename for now. *(NAME-002, 2026-11-14: the game is now **PANOPTICON**; REDLINE was the previous iteration and survives only in file names, code paths and the repository name.)* No existing technical path or identifier is implicitly renamed.

**THEME-001 — DIRECTION:** Central question: **“What does humanity become when it knows it is being permanently observed and monitored?”** Explore behavioural, cultural, and psychological transformation under perpetual surveillance without assuming one inevitable answer. Worldbuilding authority: `REDLINE_BIBLE.md`, PANOPTICON section.

**THEME-002 — DIRECTION:** The lock/containment motif connects ICE's DEADLOCK advancement gate with sealed thresholds, confinement, and the reversal from being locked out to being locked in. Visual metaphors must respect **LOOP-001/002**: breaking DEADLOCK permits advancement only **after** the corporation turn, when applicable unbroken subroutines still resolve.

**THEME-003 — DIRECTION:** Corporate networks may evoke panoptic architecture and uncertain observation. The central theme is surveillance's effect on choices, not a requirement for literal circular prison layouts. Legibility and responsive deckbuilder play remain primary.

**ARCH-001 — DIRECTION:** ICE remains the primary defender at each defensive layer; supporting corporate defences operate within ICE encounters rather than replacing them with unrelated minigames. Support systems may be layer-local or persist across multiple layers. Specific effects, counterplay, persistence, and balance are **OPEN**.

**MECH-CORR-001 — CONCEPT:** Corporate deck contamination introduces hostile or useless cards into the Rustler's draw/discard/hand cycle. Potential triggers include on draw, while held, at end of Rustler turn, on discard, and on reshuffle. Potential lifecycles include temporary exhaust, encounter/node duration, or persistent contamination. All names, numerical effects, removal rules, and timing details remain **OPEN**. Preserve the canonical CORTEX meaning and NEURAL/SYNAPTIC discard definitions.

**MECH-SURV-001 — CONCEPT:** Corporate systems may observe patterns of Rustler card use and adapt across layers. Prefer comprehensible and telegraphed counterplay; **do not** add a separate Observation meter by default. Trace and observation are conceptually related but not interchangeable.

**TAX-001 — DIRECTION:** Viruses are a subtype of deployable software. The game-state definitions of hardware, software, installed viruses, virus counters, and their interactions remain to be specified. **PURGE** remains reserved for corporation removal of virus counters.

**ORIG-001 — DIRECTION:** PANOPTICON remains fundamentally an original **single-player roguelike deckbuilder**. Shared cyberpunk genre vocabulary must not determine its narrative identity or substitute for distinct mechanics and worldbuilding.

**OPEN / implementation safeguard:** No card statistics, corruption injection cadence, Observer rules, surveillance resources, art assets, or story answers in this section are approved implementation specifications. Record explicit approval and tests before implementation.


## 14. Rustler end-of-turn resolution — LOCKED (2026-11-10)

**RULE-RT-001 — LOCKED:** During the Rustler action phase, the player voluntarily ends the turn using a designated END TURN button/icon, even with cards or BW remaining. Empty hand or zero BW alone does not automatically end the turn.

**RULE-RT-002 — LOCKED:** If the Rustler's health resource (Vitae; LOCKED terminology) reaches 0, the entire run ends immediately in defeat. Pending actions, end-of-turn effects, corporation response, and advancement do not continue.

**RULE-RT-003/004/005 — LOCKED:** END TURN initiates a distinct Rustler End-of-Turn Phase, before Corporation Response, in this exact order:
1. Resolve applicable end-of-turn effects, including effects using or modifying BW.
2. Discard every remaining card in hand; resolve applicable discard-triggered effects.
3. Forfeit all remaining BW (set available BW to zero; no normal carryover).
4. Enter Corporation Response Phase, which resolves applicable unbroken damage/Trace subroutines before any DEADLOCK-gated advancement.

**Timing safeguards:** An end-of-turn ability on a card merely in hand does not trigger unless the card explicitly permits triggering from hand. Installed/in-play effects follow their defined trigger rules. Multiple simultaneous trigger ordering, prevention/replacement timing, and unusual interrupt semantics remain OPEN; do not infer them from this summary. The example “At the end of your turn, gain 2 BW” was hypothetical, not an approved card.

**Rules-specification priority:** Document full encounter lifecycle and state transitions next; record acceptance tests for manual end turn, hand discard, discard triggers, BW forfeiture, corporation response, and immediate run defeat.

## 15. RUN-001 — Victory condition (LOCKED, 2026-11-10)

A successful run requires the Rustler to navigate a **maze of corporate Nodes**, overcome the corporation's intrusion defences **encountered along the traversed route**, and ultimately **defeat, pass, or otherwise nullify** the corporation's **central/core entity** in a final confrontation. The core may be a mainframe, artificial intelligence, android construct, or another entity consistent with the corporation's particular theme and structure. The final confrontation **resembles an ICE encounter in structure**; its unique mechanics are not yet specified. Destruction is not required if another approved means of overcoming the core succeeds.

**OPEN:** Maze topology and route-selection rules; whether Nodes may be revisited; which Nodes are mandatory; core-encounter rules and alternative victory methods; post-victory effects; exact criteria for having successfully passed a defence. Do not assume all Nodes in the maze must be cleared or that the final confrontation is identical to a standard ICE encounter.


## 16. RUN-002 — Corporate network topology and spatial experience (2026-11-10)

**LOCKED DESIGN DIRECTION:** Corporate networks should resemble **lattice structures**, rather than simple forward-branching trees. Their paths are circuitous and maze-like, producing **vertigo and uncertainty about orientation**: the Rustler should struggle to tell what counts as up, down, or forward and wonder whether they are travelling in circles. This spatial experience should reinforce the project's confinement/surveillance themes.

**NOT YET LOCKED:** Whether connections actually loop or only appear to; whether the network map is complete or only partially revealed; whether its geometry dynamically changes; whether backtracking and node revisits are permitted; whether the lattice is procedural, fixed, or hybrid; whether the core location is known or obscured. Do not interpret the design direction as authorization to implement any of these specific mechanics.


## 17. RUN-003 — Forward-only traversal and locked Nodes (LOCKED, 2026-11-10)

The corporate network is a visually disorienting lattice, but the Rustler **always moves forward toward the ultimate core objective**. A Node that the Rustler has passed becomes **locked behind them**; the Rustler **cannot move backward or revisit that Node** during the run. Nodes may present **up to five or six onward route options** (not a mandatory fixed count). A path may appear spatially to double back without mechanically reversing progression. Network connectivity and presentation must preserve the difference between **apparent orientation** and **legal traversal direction**.

**Design implication, not additional locked mechanic:** A directed, acyclic progression graph can implement these rules while displaying a twisting lattice. Avoid visual cues that falsely promise legal backtracking.

**OPEN:** Exact number and distribution of onward exits; whether every possible forward branch leads eventually to the core; whether some forward routes terminate in dead ends; whether path choices are visible before entry; exact meaning/timing of 'passed' for node locking; map presentation and generation.


## 18. RUN-004 — Equal-length guaranteed core routes (LOCKED guiding rule, 2026-11-10)

**Every available forward route through a corporation's network must eventually lead to its corporate core, and all complete routes must traverse the same number of Nodes.** No selectable route may be a dead end or offer a shorter/longer Node-count path to the core. This complements RUN-003: the Rustler always advances; passed Nodes lock behind them and cannot be revisited. Up to five or six onward choices may exist at some Nodes.

**Implementation guidance (not a separate approved visual rule):** Generate a layered directed graph with edges only between successive progression depths; allow branches and reconvergences within that constraint, then distort its visual embedding into a disorienting lattice. Validate that every reachable Node has a path to the core and that every path from entry to core has identical Node count. The network need not *look* layered.

**OPEN:** Whether the core confrontation counts as one of the Nodes in the equal-length count or occurs after the last ordinary Node; precise number of Nodes per run; generation procedure; visibility of connections; route-differentiating risks and rewards.


## 19. RUN-005 — Node identity, central Node, and hidden contents (LOCKED, 2026-11-10)

The corporation's core is a **Central Node** within the corporate network and **counts as a Node** for RUN-004 equal-route-length accounting. A **Node is a network location, not necessarily an ICE encounter**. What a Node contains is **hidden information** before entry.

**Established examples of Node contents:**
- One or more **layers of ICE** defending against intrusion.
- **Black Market Uplink** access.
- A space to **hack and augment the Rustler's Console**.

**Terminology:** **Console** denotes the Rustler's hacking/deck setup (inspired by the user's Neuromancer reference); its exact inventory, configuration, and interaction rules remain OPEN. A Black Market Uplink's available goods, costs, and timing are also OPEN.

**OPEN:** Whether a Node can combine multiple contents or always has one primary type; whether and how Node contents are revealed; further Node categories; the number and makeup of ICE layers; how noncombat Node visits end; whether all Node types share encounter lifecycle semantics; whether hardware recycling applies to all Node exits or only ICE encounters. Do not infer any of these from the examples.


## 20. Canonical harm terminology correction (LOCKED, 2026-11-10)

**Explicit user confirmation:** **NEURAL DAMAGE** and **SYNAPTIC DAMAGE** are **DEPRECATED**; **CORTEX damage** is the current term for the former brain-damage concept. They must not be used as active game mechanics or terms in new rules, cards, tests, or implementation. Older mentions elsewhere in this document are historical and superseded by this section, pending editorial cleanup.

**Current canonical terms (from 2026-11-09 design session archive):**
- **PULP X:** reduces Rustler Vitae by X.
- **SYN X:** randomly discards X cards from the current hand.
- **CORTEX X:** adds X persistent counters; each reduces effective DRAW by 1, with effective DRAW floor 1. CORTEX is only removable through specialized network recovery Nodes (e.g., eligible black-market uplink/shop), not ordinary cards or generic services.
- **DRAW:** baseline 5 minus installed Hardware minus CORTEX counters plus modifiers, subject to minimum 1.
- **BW:** baseline 4 per Rustler turn; installing or uninstalling Hardware costs 1 BW; unused BW forfeited at turn end.

**Migration warning:** The older 'NEURAL DAMAGE X = chosen discard' rule has no explicitly confirmed current equivalent in the archived PULP/SYN/CORTEX set; do not silently remap it to SYN or invent a new keyword. Earlier 'CORTEX damage' maps historically to the persistent draw-loss concept now named CORTEX, not an additional active mechanic.

**Authority:** Explicit 2026-11-10 user confirmation and REDLINE_DESIGN_SESSION_2026-11-09 archive, later terminology addendum.


## 21. SYN X — Rustler-selected discard (LOCKED, 2026-11-10)

**Latest explicit user decision supersedes all prior random-discard definitions of SYN:** **SYN X** means the Rustler **chooses and discards X cards from their current hand**. SYN is a hand-discard effect, not direct Vitae loss, CORTEX-counter gain, or permanent card destruction. **PULP X** remains direct Vitae reduction; **CORTEX X** remains persistent draw reduction. **NEURAL DAMAGE** and **SYNAPTIC DAMAGE** remain deprecated; **CORTEX damage** is the active replacement term. Earlier references to SYN as random discard (including section 20 above) are historical and superseded.

**OPEN edge case:** If fewer than X cards remain in hand, determine whether the Rustler discards all available cards or another rule applies. Preserve applicable discard-trigger effects under the existing end-of-turn rules where relevant.


## 22. SYN overflow — 2 Vitae per shortfall (superseded by RULE-126, 2026-11-11)

When resolving **SYN X**, the Rustler chooses and discards as many cards as possible, up to X, from their current hand. For every card of the required X that could not be discarded, the Rustler suffers **2 PULP** (i.e., 2 Vitae loss per missing card). Formula: `overflow_CHAR = 2 * max(0, X - number_of_cards_discarded)`. Example: SYN 3 with only 1 card in hand discards that card and causes 4 PULP; SYN 4 with an empty hand causes 8 PULP.

**Status:** Mechanic approved; the **2× multiplier is provisional for playtesting** and may be tuned based on results. SYN itself remains Rustler-selected discard (section 21), not random discard. CORTEX remains distinct and is not automatically generated by SYN overflow. Evaluate high-SYN ICE against empty hands, installed-Hardware DRAW reductions, and CORTEX-impaired DRAW.

**Resolution detail still OPEN:** exact sequencing of discard-triggered effects relative to overflow PULP and other simultaneous effects; use existing immediate-run-defeat rule if Vitae reaches zero.


## 23. RUN-006 — Three-corporation full run and First Signal data (LOCKED, 2026-11-10)

**Explicit user reaffirmation of established design:** A **fully completed run** requires the Rustler to infiltrate **three different corporations**. For each corporation, the Rustler seeks to access/steal data central to the overarching **First Signal** theme. The Rustler does **not** fully understand the true significance of the data or know who is ultimately hiring them to obtain it. Preserve this mystery in narrative presentation.

**Hierarchy:** full run → three corporate infiltrations → each corporation's network and central/core objective → Nodes → sequential ICE layers. Completing the first or second corporation is **not** a completed full run. The prior RUN-001 single-core victory wording describes a corporation-level milestone and is superseded insofar as it implies that clearing one corporation wins the full run. The existing equal-length routes and forward-only topology apply within a corporation's network unless separately revised.

**OPEN:** precise transition between corporations; whether and how resources, damage, upgrades, and Trace persist between corporate infiltrations; narrative revelations; order/selection of corporations; exact final victory trigger after the third corporation. Do not infer answers.


## 24. NODE-CORE-001 — Corporate Central Node boss-style ICE confrontation (LOCKED, 2026-11-10)

**Explicit user decision:** **Each corporation's Central Node resembles a final boss battle, but is structured as an ICE encounter.** All three corporations in a full run therefore have a climactic Central Node confrontation. This is a corporation-level climax, not the end of the three-corporation run until the third corporation is completed. Use the established ICE combat framework as the foundation rather than assuming a separate combat minigame. Corporate identity and presentation may distinguish the confrontation; do not invent mandatory phases, subroutines, rewards, or victory conditions.

**OPEN:** precise boss mechanics and exceptions to standard ICE rules; the exact relationship between resolving the confrontation and accessing First Signal-related data; inter-corporation transitions and persistence.


## 25. RUN-007 — Inter-corporation persistence and recovery (LOCKED, 2026-11-10)

**Explicit user decision:** After completing a corporation and proceeding to the next corporation in the same three-corporation run:
- **Carry forward** the Rustler's **deck**, **Hardware**, and **Ghostware**.
- **Fully restore Vitae**.
- **Remove all CORTEX counters**.

This applies at the transitions from corporation 1 to 2 and corporation 2 to 3. The full run is still completed only after the third corporation. This transition-specific CORTEX removal is an explicit exception to the ordinary rule that CORTEX requires specialized network-node recovery; it is **not** an ordinary card or generic service.

**OPEN:** TRACE treatment; temporary status effects; detailed transition timing, presentation and other resources; any special end-of-run recovery after corporation 3. Do not infer these.


## 26. RUN-008 — Corporation-specific TRACE reset (LOCKED, 2026-11-10)

**Explicit user decision:** **TRACE is corporation-specific.** On completion of one corporation and transition to the next, **TRACE resets to zero**; the prior corporation's TRACE does not carry over. Applies from corporation 1 to 2 and corporation 2 to 3.

**Complete inter-corporation transition rule (RUN-007 + RUN-008):** Carry forward the deck, Hardware, and Ghostware; fully restore Vitae; remove all CORTEX counters; reset TRACE to zero. Other resources and transient conditions remain OPEN.


## 27. TAX-002 — Software representation in deck (LOCKED, 2026-11-10)

**Explicit user decision for the Master Classification Matrix:** **Software is represented through cards in the Rustler's deck.** Software is a card-based category. **Viruses** remain an established subtype of deployable Software, so their software representation follows this card-based taxonomy, while exact deployment/counter mechanics remain OPEN.

**Do not infer:** that all cards are Software; that Hardware, CAPS, or Ghostware are Software; or that Software's exact play, install, duration, and discard mechanics have all been specified. Ghostware remains permanent and non-card. CAPS classification versus Hardware remains an explicit unresolved discrepancy between the user's recent statement and the PANOPTICON Bible.


## 28. TAX-003 — Viruses and Icepicks are Software subtypes (LOCKED, 2026-11-10)

**Explicit user decision:** **Viruses and Icepicks are both subsets of Software.** Because Software is represented through cards in the Rustler's deck (TAX-002), both Viruses and Icepicks are card-based Software. Viruses retain their previously established deployable-software identity. Icepicks retain their ICE/subroutine interaction role (including drag-to-ICE UI direction).

**Classification only:** This decision does not settle Virus counters, Icepick costs, deployment timing, card destinations, or whether other card categories exist. CAPS, Ghostware, Hardware, PATCHWORK, and Console remain separate entries pending their own classification decisions.


## 29. TAX-004 — Hardware is installable, node-duration card (LOCKED, 2026-11-10)

**Explicit user decision:** **Hardware is also represented by cards in the Rustler's deck**, distinct from Software cards. The Rustler **plays a Hardware card once to install it**. Its effect **persists for the duration of the entire Node**, including sequential ICE layers, then **ends when the Node ends**; the Hardware card **returns to the Rustler's deck**. The Hardware is not consumed or permanently lost at Node completion.

**Existing rules retained:** Installing Hardware costs 1 BW; uninstalling costs 1 BW. Each installed Hardware reduces effective DRAW by 1. Hardware recycling happens **exactly once at encounter end**; under the newly clarified node-duration rule, the normal recycling boundary for installed Hardware is **Node end**, not each individual ICE layer. This clarifies prior encounter-end ambiguity without defining all exceptional exits.

**OPEN:** exact return destination (draw pile, discard pile, or deck collection); whether early uninstallation returns the card immediately and where; exceptional Node exits including JACK OUT; effect ordering at Node end. Do not silently invent any of these.

**Taxonomy:** Deck includes both Hardware and Software cards; Viruses and Icepicks are subtypes of Software; Ghostware remains permanent non-card upgrades. CAPS classification remains unresolved.


## 30. TAX-005 — CAPS are consumable injectable code outside deck (LOCKED, 2026-11-10)

**Explicit user decision:** **CAPS are consumable, single-use injectable code devices outside the Rustler's deck.** They are a distinct mechanical category, **not Hardware cards or Software cards**. The Rustler activates/injects a CAP and consumes it; it is not drawn or played from the Rustler's deck. This resolves the earlier classification ambiguity and agrees with the PANOPTICON Bible's separate CAPS category.

**Preserve established fiction:** CAP (plural CAPS), colloquial term descended from corporate DAC; ritual **Flip. Inject. Discard.** JACK OUT remains a distinct CAP, not a universal free action, subject to its existing specific restrictions and unresolved conflict with forward-only Node traversal.

**OPEN:** CAPS inventory, acquisition, general activation costs/windows, specific effects beyond already established examples. Do not apply Hardware's installed DRAW penalty or Node-end recycling to CAPS.


## 31. TAX-006 — Remove installed-Hardware DRAW penalty (LOCKED, 2026-11-10)

**Explicit user decision:** **Installed Hardware no longer reduces DRAW.** This supersedes all prior rules/formulas stating `DRAW = 5 − installed Hardware − CORTEX + modifiers` or `−1 DRAW per installed Hardware`. Current baseline formula is **`effective DRAW = max(1, 5 − CORTEX counters + applicable modifiers)`**, subject to effects that explicitly modify DRAW. Hardware's established card identity, 1 BW installation and uninstallation costs, node-duration persistence, and node-end recycling remain unchanged.

**Design rationale:** remove a complexity tax that discourages using acquired Hardware and compounds CORTEX's draw reduction. Hardware can be balanced through other mechanics, but no new equipment-slot limit or activation restriction is authorized by this change.

**Icepicks:** Still classified as Software (TAX-003); whether they persist for one ICE or the whole Node remains OPEN. This DRAW change does not settle their duration.


## 32. TAX-007 — Icepick persistence across Node (LOCKED, 2026-11-10)

**Explicit user decision:** Icepicks are **Software cards played from the Rustler's hand** and **remain in play for the entire Node**, rather than expiring after the current ICE layer. They may therefore remain available across sequential ICE layers within the Node. This supersedes the previously OPEN Icepick duration and retains their Software subtype classification.

**OPEN — not approved by this decision:** Whether persistent Software has an active-slot/capacity limit; the number of slots; whether a limit includes only Icepicks or other persistent Software; whether Hardware uses the same capacity; replacement/uninstallation mechanics; exact return destination and timing for Icepick cards at Node end. Candidate design for discussion: cap only persistent Software, not one-shot Software; test four active slots initially. No slot count or replacement rule is locked.


## 33. TAX-008 — RAM limits active Software; Hardware can expand RAM (LOCKED concept, 2026-11-10)

**User-endorsed design direction:** The Rustler's **RAM** limits the number/capacity of **active Software** programs in play. Certain cards, particularly **Hardware**, can grant additional RAM, enabling builds that install and sustain more Software simultaneously. RAM is a separate resource from **BW** (per-turn action points) and **DRAW** (hand draw). This is the intended clean, thematic constraint replacing a fixed universal active-program count. Icepicks remain persistent Software for the whole Node and therefore participate in the active Software/RAM system.

**Not yet approved:** Starting RAM value; whether each persistent Software card costs exactly 1 RAM or has variable RAM requirements; whether one-shot Software uses RAM transiently; RAM costs of Viruses or deployed effects; what happens to active Software when a RAM-granting Hardware card is uninstalled or removed; whether Ghostware/CAPS interact with RAM; whether Software can be voluntarily unloaded and at what cost; RAM refresh/reset boundaries. No numeric values are locked.


## 34. TAX-009 — Variable RAM requirements for persistent Software (LOCKED, 2026-11-10)

**Explicit user decision:** Persistent Software cards have **variable RAM requirements**; more powerful Software generally requires **more RAM**. The Rustler cannot maintain active persistent Software whose combined RAM requirements exceed available RAM. Icepicks are persistent Software and follow this capacity rule. Hardware can increase RAM capacity under TAX-008. RAM is distinct from BW and DRAW.

**OPEN:** starting RAM; exact per-card costs and balance; rules for unloading/replacing programs; handling capacity loss mid-Node; whether and how one-shot Software or deployed Virus effects consume RAM. Example RAM costs are illustrative, not locked.


## 35. TAX-010 — RAM hard cap reaffirmed; Software unloading cost OPEN (2026-11-10)

**Explicit user reaffirmation (LOCKED):** A Rustler **cannot install Software if doing so would exceed available RAM**. The total RAM requirements of all active persistent Software must fit within current RAM capacity. This restates TAX-009 as a hard installation legality check.

**Design question (OPEN):** Should unloading active Software cost BW? Suggested direction for discussion: unloading persistent Software costs **0 BW**, while installing its replacement retains an applicable cost; unloading removes the Software from active play and must not directly return it to hand. This is **not approved** yet. The existing **1 BW uninstall cost for Hardware** remains locked and is a separate rule. Software install BW cost is not yet established; do not silently apply Hardware's 1 BW cost to Software.

**Other OPEN details:** software unloading destination, action timing, capacity reduction caused by removal of RAM-granting Hardware, and reinstallation/trigger exploits.


## 36. TAX-011 — Base RAM 4 and free persistent-Software unloading (LOCKED, 2026-11-10)

**Explicit user decisions:**

1. The Rustler has **4 base RAM** before modifiers, including RAM-granting Hardware.
2. The Rustler **cannot install persistent Software if its RAM requirement would exceed available RAM**. Active persistent Software has variable RAM requirements (TAX-009).
3. **Unloading active persistent Software costs 0 BW**. Unloading immediately removes that Software from active play and frees its occupied RAM.
4. Unloaded Software **does not return directly to hand**; the precise destination remains OPEN.
5. Icepicks are persistent Software that normally remains in play for the entire Node, unless unloaded.
6. RAM-granting Hardware may raise the capacity above base 4 RAM. Installed Hardware does not reduce DRAW (TAX-006).

**Scope:** The 0 BW rule is for **Software unloading**, not Hardware. Hardware uninstall remains **1 BW** under TAX-004. Software installation BW costs, unloaded-card destination, timing restrictions, and how RAM capacity loss is handled remain OPEN.


## 37. TAX-012 — Unloaded Software discard; BURN until next encounter (LOCKED, 2026-11-10)

**Explicit user decision:** When active Software is **unloaded**, it goes to the **discard pile**, **unless it is BURNED**. **BURNED** cards are **removed from play until the next encounter**. BURNED status is temporary, not permanent deletion. Unloading active Software remains **0 BW**, immediately ends its active effects and frees its occupied RAM (TAX-011).

**Interpretation:** A new ICE layer within the same Node can be the next encounter; the card's exact return zone and exact return timing at the beginning of that encounter remain OPEN. Do not automatically put burned cards into hand or deck without a separate rule. The circumstances or card effects that cause BURNED status remain card-specific/open. Do not conflate BURN with the separate Node-end Hardware recycling rule.


## 38. TAX-013 — BURN lasts until the next Node (LOCKED, 2026-11-10)

**Explicit user correction:** **BURNED cards remain BURNED and removed from play until the next Node**, not merely until the next encounter. This **supersedes TAX-012's “until next encounter” duration** and any suggestion that a subsequent ICE layer within the same Node returns a burned card. All sequential ICE encounters in the current Node occur while that card is unavailable.

**Unchanged:** Unloaded Software that is not BURNED goes to the discard pile; unloading costs 0 BW and frees occupied RAM.

**OPEN:** Exact zone and timing for returning BURNED cards at the start of the next Node (draw pile vs discard pile vs other); do not assume immediate hand access. BURNED status does not permanently remove the card from the run.


## 39. TAX-014 — BURNED cards shuffle into draw pile at next Node (LOCKED, 2026-11-10)

**Explicit user decision:** At the beginning of the **next Node**, all cards BURNED during the preceding Node are **returned to the Rustler's draw pile and shuffled in**. They are **not** returned to hand or discard pile, and they cannot be drawn during the Node in which they were BURNED. This resolves the return-zone question left OPEN in TAX-013 and supersedes any previous next-encounter PULP return rule.

**Complete BURNED lifecycle:** BURNED status removes a card from play immediately; it stays unavailable through the rest of the current Node, including sequential ICE encounters; on entering the next Node, return BURNED cards to the draw pile and shuffle; they can subsequently be drawn normally. Unloaded non-BURNED Software still goes to discard at 0 BW.


## 40. TAX-015 — Console definition (LOCKED, 2026-11-10)

**Explicit user decision:** The **Console** is defined as the **sum total of the Rustler's Hardware, Software, CAPS, Ghostware, and PATCHWORK**. Software includes its subtypes Icepicks and Viruses. Console is an umbrella term for this complete hacking setup, **not** an additional independent equipment category, card type, or separately installed item. The Rustler's RAM capacity is a property of this setup, not a sixth item category within the Console.

**Scope:** This definition does not establish new Console slots, upgrades, costs, or mechanics beyond those already specified for its constituent categories. Deck is a card collection/zone system, not separately listed by the user as a constituent Console item.


## 41. TAX-016 — Persistent Software installation costs 1 BW (LOCKED, 2026-11-10)

**Explicit user decision:** **Installing persistent Software from hand costs 1 BW**, matching the existing Hardware installation cost. The Rustler must also have enough free RAM to accommodate the Software card's variable RAM requirement; an installation that would exceed available RAM is illegal. Once installed, the Software occupies its required RAM until it leaves active play. Icepicks are persistent Software and follow this rule.

**Current action-cost matrix:** Install Hardware **1 BW**; uninstall Hardware **1 BW**; install persistent Software **1 BW** plus sufficient RAM; unload persistent Software **0 BW** (unloaded, non-BURNED Software goes to discard pile). Hardware does not reduce DRAW.

**OPEN:** BW costs and play timing for immediate/one-shot Software, RAM capacity loss handling, and exceptional removal/installation triggers. Do not infer those from this rule.


## 42. TAX-017 — Uninstalling RAM-granting Hardware requires legal remaining RAM (LOCKED, 2026-11-10)

**Explicit user approval:** Before uninstalling Hardware that grants RAM, the Rustler **must first unload sufficient active Software** so that remaining occupied RAM does not exceed the Console's RAM capacity after the Hardware is removed. The Rustler **cannot perform** the Hardware uninstall while it would cause occupied RAM to exceed available RAM. This is a player-directed prerequisite, **not** automatic forced removal of Software.

**Costs and destinations remain unchanged:** Unloading persistent Software costs **0 BW** and sends non-BURNED Software to discard, immediately freeing RAM; uninstalling Hardware costs **1 BW**. Base RAM is **4**, and installed Hardware can increase it. This rule applies whenever a voluntary Hardware uninstall would reduce RAM capacity.

**OPEN:** Handling involuntary RAM-capacity loss from effects other than voluntary Hardware uninstall, if such effects are introduced. No additional penalty is imposed.


## 43. TAX-018 — Node-end Hardware and Software return to deck (LOCKED, 2026-11-10)

**Explicit user decision:** **When a Node ends, all active Software and Hardware return to the Rustler's deck.** Their active/installed state ends, so their persistent effects cease and RAM previously occupied by Software is freed. This applies to persistent Software, including Icepicks, and installed Hardware; it supersedes the previously OPEN active-Software Node-end destination. Hardware already had Node-end return established in TAX-004.

**Preserve distinct BURNED rule:** Cards BURNED during the Node remain removed from play through Node end and are **shuffled back into the draw pile when the next Node begins** (TAX-014); do not prematurely return them in the ordinary active-card cleanup.

**OPEN:** Whether ordinary Node-end returned Hardware and Software go directly into the draw pile, discard pile, or a combined deck reshuffle; the user said “return to the deck,” not a specific pile. Do not assume a particular shuffle procedure. Normal cards already in draw/discard zones are unaffected unless separately specified.


## 44. TAX-019 — Complete deck reshuffle at start of each Node (LOCKED, 2026-11-10)

**Explicit user approval:** **Entering each new Node triggers a complete reshuffle of the Rustler's deck**, incorporating Hardware and Software returned from active play at the end of the preceding Node, cards in the draw and discard piles, and cards previously BURNED during the preceding Node. All eligible cards are combined and shuffled into a fresh draw pile for the new Node. The Rustler draws their starting hand under the ordinary DRAW rules.

**Timing:** Node-end active Hardware/Software return to the deck (TAX-018); BURNED cards remain unavailable until the next Node begins (TAX-014); then all eligible deck cards are shuffled together. BURNED status is not permanent deletion. This resolves the Node-end return-pile ambiguity in TAX-018 by defining the next-Node combined reshuffle.

**No implied reset:** A new Node does not itself remove CORTEX, restore Vitae, reset corporation-specific TRACE, or undo Ghostware/PATCHWORK upgrades; inter-corporation recovery rules remain separate.


## 45. TAX-020 — Non-ICE service Nodes skip deck setup and cleanup (LOCKED, 2026-11-10)

**Explicit user clarification:** There is **no need for reshuffling or encounter-style deck cleanup at the beginning or end of non-ICE Nodes**, such as an **Uplink Market**. This is an exception to TAX-018 and TAX-019's broad wording “every Node.” Routine deck initialization, full reshuffle, active Hardware/Software cleanup, and combat-hand setup are **ICE-Node encounter procedures**, not automatic procedures for visiting a non-ICE service Node.

**Consequences:** Visiting a service-only Node does not itself cause a full reshuffle or discard/return installed cards simply because a Node boundary was crossed. Cards acquired or modified by services follow their own as-yet-unspecified rules.

**Needs explicit reconciliation (OPEN):** TAX-014 says BURNED cards return “at the next Node.” When that next Node is a non-ICE service Node, precise BURNED-card return timing and whether to defer shuffling until the next ICE Node need a specific rule. Do not silently redefine “next Node” as “next ICE Node.” Likewise, mixed service/combat Nodes, if allowed, need an encounter-boundary rule.


## 46. ECON-001 — Escalating data-extraction rewards (USER PROPOSAL, 2026-11-10)

**User-supported direction:** Data theft occurs during ICE encounters while the Rustler attempts to pass ICE. Reward amounts **increase for successive extraction turns**, creating a push-your-luck tradeoff between longer exposure to corporate response and greater Uplink purchasing power. User's proposed example: first extraction turn **10 CRED**, second **20 CRED**, third **35 CRED**, for **65 CRED cumulative**. These values are an explicit illustrative proposal, **not yet confirmed as a final balance table**. “Exponential” describes the intended accelerating reward curve; no exact mathematical formula is established.

**OPEN:** Whether escalation is keyed to successive turns or successful extraction actions; whether a turn without extraction resets/pauses the streak; BW cost; extraction frequency per turn; cap per encounter; whether CRED is final currency name; how and when currency is banked; payouts beyond turn 3; whether neutralized ICE can still be mined; effects of PASS and BYPASS. Do not assume these mechanics are locked.


## 47. ECON-002 — Per-encounter maximum CRED payout (LOCKED, 2026-11-10)

**Explicit user decision:** **Each ICE encounter has a maximum CRED payout** available through data extraction. This is a hard ceiling on the amount the Rustler can earn from that encounter's data, regardless of escalating extraction rewards or time spent. The total amount actually awarded cannot exceed the remaining unextracted value. This prevents unlimited extraction farming.

**Explicitly OPEN:** Whether the maximum payout is known to the Rustler, hidden information, or revealed conditionally. The user specifically suggests it *could* be hidden; do not lock hidden visibility. Exact encounter caps, payout distribution, extraction action costs/frequency, streak progression, whether extraction can occur after ICE is neutralized, and the final currency label remain undecided. The proposed 10/20/35 CRED escalating sequence remains a balance example, not a universally locked payout table.


## 48. ECON-003 — Extractor Software and payout profiles (LOCKED DIRECTION, 2026-11-10)

**Explicit user design direction:** Data/CRED extraction during ICE encounters is performed by **Extractor programs**, which are **Software cards the Rustler must install, spending BW**. Once installed, Extractors automatically extract a specified amount of data/CRED **at the end of turns**, following the program's payout profile. This replaces the earlier *proposed* universal Rustler extraction action. Existing persistent Software installation baseline is 1 BW, subject to future card-specific exceptions, and installed Software is governed by RAM and Node-long Software lifecycle unless explicitly revised.

**Distinct extractor profiles:** Street-oriented, heavily augmented extractors may produce **zero payout for the first two turns** and then **a large payload at the end of turn three**. Corporate-inspired, cleaner extractors have a **more even payout curve**, earning value earlier and more steadily. This creates risk/reward differentiation through deck composition and time exposed to ICE. Rustler archetypes express preferences rather than automatically imposing exclusivity (exclusivity itself not decided).

**Prior LOCKED ECON-002 remains:** Each ICE encounter has a finite maximum total CRED payout; whether that cap is visible to Rustler is OPEN.

**OPEN:** Specific Extractor card examples/names, RAM costs, BW exceptions, exact yields and profiles, whether countdown is from installation or encounter turn, whether multiple Extractors can run simultaneously, effects of unload/reinstall and interrupted sequences, whether an extractor can pay after ICE PASS, and whether extracted CRED is banked immediately or upon surviving/passing. The previous 10/20/35 payout example is not universal and must not override card-defined payout curves.


## 49. SOFT-001 — Multi-subtype Software and extraction-powered defenses (2026-11-10)

**LOCKED — user explicitly approved:** A single Software card **may have multiple subtypes/capabilities**, e.g. Icepick + Virus, Virus + Extractor, or other combinations. These classifications are **not mutually exclusive**. This is intended to support diverse deck builds, Rustler playstyles, and Rustler personalities. Software remains the umbrella card category, and existing installation/BW/RAM/lifecycle rules apply unless overridden by an approved card rule.

**USER-PROPOSED DESIGN EXAMPLE (not yet a finalized card):** A shield-like card can prevent **X PULP** by **spending/burning CRED extracted during the previous turn**. This connects data extraction and defense, creating a choice between keeping CRED for Uplink Market purchases and consuming it for survival. Exact damage-to-CRED conversion, whether it can use only the previous turn's proceeds or any held CRED up to that amount, activation timing, BW/RAM, cap, and whether spent CRED is permanently deducted remain OPEN. Do not treat illustrative card name or stats as approved.

**Terminology caution:** Here “burning CRED” means spending currency, not the existing **BURNED card** state; keep mechanically distinct.


## 50. SOFT-002 — Instant CRED shield and hand retention concept (2026-11-10)

**LOCKED — user-confirmed CRED shield principles:** A shield-like **one-shot / instant Software card** is played from hand, its effect resolves immediately, and it **goes to the discard pile** rather than remaining installed. It protects against a limited amount of **PULP** by **permanently spending CRED the Rustler has already earned**. The CRED cost is **variable**, and the card has a **protection/spending limit**. Its tactical weakness is hand availability: the card may not be in hand when protection is needed. This is a card/mechanic concept, not yet a named, fully balanced card. Precise conversion rate, cap, activation window, BW play cost, and interpretation of “CRED extracted previous turn” are OPEN. Instant Software is distinct from persistent Software and does not automatically follow persistent installation lifecycle.

**NEW DESIGN TOPIC — user requests thematic hand-retention abilities:** Rustler should be able to gain abilities to **retain selected cards in hand across turns** despite normal end-turn hand discard. Exact rules, source of ability, hand-size interaction, duration, and limits OPEN.

**ASSISTANT PROPOSAL, NOT LOCKED:** Keyword **CACHE X** for retaining up to X cards at turn end. Cards remain in hand, not installed; whether caching consumes RAM is OPEN. This is thematically based on computer caching, and could help retain a CRED-powered shield until needed. Do not treat the keyword or details as approved until user explicitly agrees.


## 51. SOFT-003 — CACHE keyword (LOCKED, 2026-11-10)

**Explicit user approval:** **CACHE** is PANOPTICON's official keyword for **retaining selected cards in the Rustler's hand across the normal end-of-turn hand discard**. The word functions as both a noun and a verb: e.g. **“CACHE that card”** means designate that card to remain in hand. **CACHED** describes a card currently retained. **CACHE X** is the natural parameterized form for retaining up to X cards (e.g. CACHE 1, CACHE 2), subject to final wording. The keyword is intentionally evocative of computer caching and multiple everyday meanings.

**Core distinction:** CACHED cards **stay in hand**, rather than being installed persistent Software in the Console. Their retention is an exception to the normal end-of-turn hand discard.

**OPEN:** Which abilities/cards grant CACHE, selection timing, retention duration, whether CACHED cards count toward the next turn's DRAW/hand size, any total CACHE limit, whether cards can remain CACHED over multiple turns, and special treatment at ICE-layer/Node boundaries. Do not infer these details as locked.


## 52. SOFT-004 — CACHE additive to DRAW (LOCKED, 2026-11-10)

**Explicit user decision: Option B.** At the start of a turn, the Rustler **retains all CACHED cards in hand and draws their full normal DRAW quantity in addition**. CACHED cards do **not** count against or reduce the number of cards drawn. Example: **2 CACHED cards + DRAW 5 = 7 cards in hand** at turn start. CORTEX and other DRAW modifiers still affect the number of newly drawn cards according to the established DRAW formula; they do not retroactively discard or offset CACHED cards.

**OPEN:** Maximum total hand size, whether a cached card may be held indefinitely or must be released after a turn, selection and duration of CACHE effects, and boundaries between ICE layers/Nodes. This decision does not by itself resolve those issues.


## 53. SOFT-005 — Indefinite CACHE retention (LOCKED, 2026-11-10)

**Explicit user decision:** A CACHED card may be **retained indefinitely across turns** rather than expiring after one additional turn, provided the supporting CACHE ability remains active. The card remains in the Rustler's hand until played or otherwise removed by a game effect. This extends SOFT-003 and SOFT-004: CACHED cards are retained in hand and do not reduce normal DRAW, even across multiple successive turns.

**OPEN:** What happens when the granting CACHE ability is lost or capacity falls below cards currently CACHED; whether there is a global hand size limit; whether a CACHED card may be carried across sequential ICE layers (which normally discard hand upon PASS); whether CACHE persists between Nodes (which normally reset deck/hand); and the exact source and limits of CACHE abilities. Do not silently override existing ICE PASS or Node cleanup rules.


## 54. SOFT-006 — CACHE survives ICE layers, ends at Node boundary (LOCKED, 2026-11-10)

**Explicit user decision:** CACHED cards **survive across sequential ICE layers within the same Node**, including the PASS transition that normally discards unplayed cards. CACHE retention lasts **until the end of the Node**, not across Node boundaries. At Node end, any remaining CACHED cards are returned to the Rustler's deck as part of normal ICE Node cleanup, and the CACHE state ends. Thus the previously locked indefinite retention (SOFT-005) is **indefinite within the Node**, subject to maintaining the relevant CACHE ability, not indefinite across Nodes.

**Other established rules remain:** Non-CACHED unplayed hand cards are discarded on ICE PASS; next ICE layer begins with a fresh normal DRAW, with any retained CACHED cards additive to that draw (SOFT-004). The current Node-end cleanup and next ICE Node reshuffle rules remain in force.

**OPEN:** Effects of losing CACHE capacity during a Node, overall hand limit, and precise rules for the source/activation of CACHE.


## 55. SOFT-007 — CACHE loss and corporate countermeasures (LOCKED, 2026-11-10)

**Explicit user decision:** If a Rustler loses the ability/effect supporting CACHE, affected formerly CACHED cards **remain in hand for the rest of the current turn**, playable as ordinary hand cards, and **are discarded at the normal end-of-turn discard step** if still unplayed. They are **not immediately discarded** merely because CACHE retention is lost. This resolves the SOFT-005/006 capacity-loss timing question at least for complete loss of CACHE support; precise handling of partial capacity reduction remains OPEN.

**Explicitly supported defensive design space:** ICE and corporate defenses may (a) **eliminate/discard all currently CACHED cards in hand**, or (b) **remove CACHE retention from cards in hand**, causing normal end-of-turn discard rather than immediate discard. These are distinct types of effects and can appear as ICE subroutines or other corporate defenses.

**Terminology:** “Invalidate CACHE” (remove retention) and “Flush CACHE” (immediately discard cached cards) are illustrative labels only, **not locked keywords**. CACHE may be an applied retention status; stripping it should not automatically erase printed card text. Exact effect wording, timing, and counterplay are OPEN.


## 56. SOFT-008 — Individual and mass CACHE targeting (LOCKED, 2026-11-10)

**Explicit user approval:** ICE subroutines and corporate defenses may target **individual CACHED cards** or **all CACHED cards**, both for (a) **removing CACHE retention** and (b) **immediately discarding CACHED cards**. Thus four supported effect shapes are: single-card retention removal; all-card retention removal; single-card immediate discard; all-card immediate discard.

**Interaction with SOFT-007:** Removing CACHE retention does **not** immediately discard the affected card(s); they remain in hand and follow normal end-of-turn discard unless played. An effect explicitly ordering discard moves affected CACHED card(s) immediately to the discard pile. No new named keywords or targeting selection method are locked by this decision.


## 57. RULE-001 — Target chooses how to comply (LOCKED, 2026-11-10)

**Explicit user rule:** When a game effect requires its **target** to take an action or choose affected objects, **the target chooses how and what to do to satisfy the requirement**, within the restrictions of the effect. The target does not gain the option to ignore a mandatory effect; it selects the eligible cards, counters, installed programs, etc., to fulfill it. This is a **general default targeting/selection rule**, not restricted to CACHE. Applies symmetrically to Rustler and Corporation when each is the target.

**Examples:** If Rustler must discard one CACHED card, Rustler chooses which CACHED card. If Rustler must remove CACHE from one card, Rustler chooses which. If Corporation is required to PURGE Virus counters, Corporation chooses eligible counters. The existing SYN X rule (Rustler chooses cards to discard) is consistent with this default.

**Exceptions:** An effect that explicitly names a particular target, defines a different chooser, or calls for random selection overrides this default. Do not assume the Corporation randomly selects affected CACHED cards absent such explicit wording. If insufficient eligible objects exist, follow the specific effect's instructions or a future general insufficiency rule (still OPEN).


## 58. RULE-002 — Fulfill as much as possible; independent effects still resolve (LOCKED, 2026-11-10)

**Explicit user decision:** When a mandatory effect instructs a target to perform an action and the target has fewer eligible objects/resources than requested, **perform as much of the instruction as possible**. An unfulfillable portion does **not** cause the whole card/effect to fail. **Subsequent effects still resolve**, unless an explicit rule or condition says otherwise.

**User's authoritative example:** A card reads **“When played: Discard a card. Gain X effect.”** If the Rustler has **no other cards in hand** to discard, the Rustler discards none and **still gains X**. If the Rustler has an eligible card, they discard one (target chooses under RULE-001), then gain X. Likewise, “discard 3 CACHED cards” with only one CACHED card discards that one.

**OPEN design distinction:** Future effects may explicitly specify an **additional mandatory cost** or conditional **“if you do”** requirement to gate a benefit, but the exact templating and general cost-payment rules have not yet been approved. Do not retroactively interpret a normal “Discard 1. Gain X” instruction as such a cost.


## 59. RULE-003 — Instructions versus costs and conditional effects (LOCKED, 2026-11-10)

**Explicit user approval:** PANOPTICON formally distinguishes **instructions** from **costs**. Ordinary instructions are fulfilled **as much as possible** under RULE-002, without cancelling other independent effects. A **cost** must be **paid in full** to activate/receive the associated effect. A **conditional** such as **“If you do”** grants its contingent benefit only if the specified action was actually performed successfully. **Never infer a cost** from an ordinary instruction; cost/condition must be explicit in card text or an applicable rule.

**Examples:**
- **“Discard 1 card. Gain X.”** With no eligible card to discard, discard none; still gain X.
- **“Discard 1 card. If you do, gain X.”** With no eligible card to discard, do not gain X.
- **“Cost: Discard 1 card. Effect: Gain X.”** With no eligible card to discard, cannot pay the cost and therefore cannot activate the associated effect.

**Interaction:** RULE-001 still lets the target choose eligible objects when an effect requires a choice; RULE-002 governs partial fulfillment of instructions, but does **not** waive costs. Exact formatting/wording conventions may be refined later without changing this principle.


## 60. SOFT-009 — Instant Software is the default card lifecycle (LOCKED, 2026-11-10)

**Explicit user decision:** **Most cards in the Rustler's deck are Instant Software.** Standard lifecycle: **play the card from hand → pay any applicable costs → perform its instructions → move the card to the discard pile.** Instructions/costs/conditions follow RULE-001, RULE-002 and RULE-003. Instant Software is played for an immediate effect; it is **not installed as persistent Software**, and therefore does not occupy persistent Console RAM or remain active through the Node unless a specific card effect says otherwise.

**Important distinction:** Persistent Software installation has an established baseline cost of 1 BW (TAX-016). That **installation cost is not automatically applied to Instant Software**, which is played rather than installed. The universal/default BW **play cost** for Instant Software is still **OPEN**; card-specific costs may be printed. This section supersedes any earlier suggestion that all Instant Software necessarily costs 1 BW to play.

**OPEN:** Default instant-card BW play cost (including whether zero-cost cards exist), exact timing windows for instant cards including defensive responses, and special destination exceptions (e.g. BURNED).


## 61. SOFT-010 — Printed BW costs for Instant Software (LOCKED, 2026-11-10)

**Explicit user approval:** Every Instant Software card has its **own printed BW play cost**; **0 BW** is permitted. There is **no universal BW play cost** for Instant Software. A card may cost 0, 1, 2, or more BW as specified by its own design. The Rustler must pay the card's BW cost to play it, subject to future explicit modifiers/waivers. After playing and resolving its instructions, it goes to the discard pile per SOFT-009 unless an explicit card effect specifies another destination.

**Distinct from persistent Software:** The established **1 BW installation cost** for persistent Software remains separate and unchanged. Instant Software is played, not installed; it does not consume persistent RAM merely by being played.

**OPEN:** Timing windows for playing Instant Software (including whether defensive reactions are possible during corporate response), any default maximum printed BW cost, and exceptions/discount effects.


## 62. SOFT-011 — Rustler-turn-only card play; no reactive plays (LOCKED, 2026-11-10)

**Explicit user decision:** **All Rustler cards must be played during the Rustler's turn.** There are **no reactive card plays during the Corporation's turn** or during resolution of corporate/ICE subroutines. This includes Instant Software and defensive cards. The Rustler must prepare defenses proactively before ending their turn.

**Distinction:** An effect established by a card already played during the Rustler's turn may operate or resolve during the subsequent corporate response according to its card text; that is **not** playing a new card out of turn. CACHE retention preserves access to cards for later Rustler turns but does not grant out-of-turn play. The previously discussed CRED-powered instant shield therefore must be played proactively if it is to defend against incoming PULP; precise shield effect duration/trigger and CRED-spending timing remain OPEN.

**Supersedes:** The earlier assistant proposal to allow special reactive Instant Software during corporate response is rejected.


## 63. SOFT-012 — Default defensive protection duration (LOCKED, 2026-11-10)

**Explicit user approval:** A defensive card played during the Rustler's turn normally provides its protection **through the immediately following Corporation response**. Any unused protection **expires at the end of that corporate response**. A card can **explicitly specify a longer duration**, overriding this default. This is a duration rule, not permission to play reactive cards: under SOFT-011, **all Rustler cards must be played during the Rustler's turn**.

**Example:** An Instant Software shield played during the Rustler's turn says **“Prevent 3 PULP.”** During the following corporate response it can prevent up to 3 PULP; if only 1 PULP is dealt, the unused 2 protection expires after that response. The shield card itself follows the normal play → resolve → discard lifecycle; its already-established protection may continue until the response ends.

**OPEN:** Exact stacking/consumption order of multiple protections, whether protection is shared across different damage instances by default (example above assumes a pool), and CRED-to-PULP shield exchange rates.


## 64. SOFT-013 — Temporary effects expire at start of next Rustler turn (LOCKED, 2026-11-10)

**Explicit user decision:** **At the beginning of each Rustler turn, all unused temporary shields and effects end.** A defensive effect established during the Rustler's turn remains available through the following Corporation response, but any unused portion expires **at the beginning of the next Rustler turn**, rather than immediately at the end of the Corporation response.

**Clarification / precedence:** This **refines and supersedes SOFT-012's default expiration timestamp**. SOFT-012's proactive play requirement and protection through the Corporation response remain intact. Persistent installed Software, Hardware, and effects explicitly assigned longer durations continue under their own lifecycle/duration rules; this cleanup is for temporary shields and effects, not automatic removal of persistent Console assets.

**Example:** Play “Prevent 3 PULP” on Rustler turn. The following corporate response deals 1 PULP; 2 unused protection remains until the start of the next Rustler turn, then expires.

**OPEN:** Whether multiple independent shield effects combine into one pool or remain separately tracked; exact ordering of start-of-turn cleanup relative to other start-of-turn triggers.


## 65. SOFT-014 — Independent defensive effects; cumulative PULP prevention (LOCKED, 2026-11-10)

**Explicit user approval:** Multiple active shields/defensive effects remain **separate, individually tracked effects**, but their PULP prevention **accumulates** against incoming PULP. They are **not merged into a single effect or shield pool**. This allows card-specific modifiers, triggers, and interactions to affect one shield without modifying the others. Any unused temporary protection expires at the beginning of the next Rustler turn per SOFT-013.

**User-provided design example (illustrative, not a finalized card):** A Hardware ability could read: **“The first defensive card you play each Rustler turn prevents twice as much PULP.”** Thus, a first defensive card with **Prevent 3 PULP** instead prevents **6 PULP**; a second card with **Prevent 2 PULP** still prevents 2. Their separately tracked protections **accumulate to 8 total PULP prevention**. The Hardware card's name and final wording are OPEN; this example establishes that a modifier may apply to an individual defensive card while total available prevention accumulates.

**OPEN:** When several separately tracked shields could prevent the same incoming PULP, which shield is consumed first (Rustler choice versus a fixed order); interactions with conditional shields.


## 66. SOFT-015 — Unified PULP prevention pool (LOCKED, 2026-11-10)

**Explicit user correction:** All defensive cards and effects contribute their calculated PULP prevention to **one shared numerical prevention pool**. Apply any modifiers to the individual card/effect's prevention amount **before** adding it to the pool. Once contributed, there are **no separately tracked shield values** and no choice of which shield absorbs incoming damage. Incoming PULP is deducted from this **single prevention pool**; only any excess PULP gets through as Vitae damage. Remaining unused temporary prevention expires at the **beginning of the next Rustler turn** per SOFT-013.

**Example:** First defensive card prevents 3 PULP, doubled by Hardware to 6; second prevents 2. Total prevention pool = 8. Incoming 5 PULP consumes 5 pool points, leaving 3. No shield selection/consumption order exists.

**Precedence:** This **supersedes SOFT-014's assertion that shields remain separately tracked**. SOFT-014's concept of independently calculating card-specific prevention modifiers and cumulative protection remains valid, but the resulting prevention is pooled into **one value**.


## 67. DMG-001 — Three distinct damage types and type-specific protection (LOCKED, 2026-11-10)

**Explicit user approval:** PANOPTICON's **three damage types are distinct** and defenses do not cross-protect by default:
- **PULP X:** Reduces Rustler Vitae by X; prevented by the shared **PULP prevention pool** under SOFT-015.
- **SYN X:** Rustler chooses and discards X cards from their current hand; this does not reduce Vitae. Requires an effect explicitly protecting against SYN to prevent it.
- **CORTEX X:** Applies persistent DRAW reduction (subject to minimum DRAW rule). Requires an effect explicitly protecting against CORTEX to prevent it.

A card may explicitly prevent multiple named damage types, but protection against one does **not** implicitly apply to another. The unified PULP prevention pool is **PULP-only**; it does not prevent SYN or CORTEX.

**Example:** Rustler has 6 PULP prevention and receives PULP 4 plus SYN 2. Four prevention is spent, leaving 2 in the PULP pool; SYN 2 separately requires the Rustler to choose and discard up to 2 eligible cards under RULE-001 and RULE-002.

**OPEN:** Exact resource/pool mechanics for SYN- or CORTEX-specific prevention, if such cards are introduced.


## 68. DMG-002 — Three independent damage prevention pools (LOCKED, 2026-11-10)

**Explicit user approval:** PANOPTICON has **three independent numerical prevention pools**, one each for **PULP**, **SYN**, and **CORTEX**. Each defensive card/effect contributes its calculated prevention to the pool(s) for the **damage type(s) explicitly named** in its instructions. Contributions from multiple sources **sum within each matching pool**; pools are never interchangeable or cross-applied. On incoming damage of type X, deduct prevention from **that type's pool only**; any excess damage of that type resolves normally under its own rules. No individual shield consumption choice exists after contributions have entered a pool.

**Duration:** Unused **temporary** prevention in each of the three pools expires at the **beginning of the next Rustler turn**, following SOFT-013. Explicit longer-duration effects can follow their printed duration.

**Example:** Rustler has PULP prevention 4, SYN prevention 2, CORTEX prevention 1. Incoming PULP 3, SYN 3, CORTEX 2 leaves PULP prevention 1; SYN prevention 0 with SYN 1 resolved (choose and discard 1 eligible card); CORTEX prevention 0 with CORTEX 1 applied.

**Relationship to earlier rules:** Extends SOFT-015's single pooled-value approach to each distinct damage type without combining types, and completes DMG-001's previously OPEN question of whether SYN and CORTEX have prevention pools.


## 69. GHOST-001 — Node-based Origin Ghostware prevention (LOCKED, 2026-11-10)

**Explicit user approval:** Rustler **Origin Ghostware** may grant a fixed quantity of damage-type-specific prevention **once per Node**, supporting distinct Rustler archetypes. **Illustrative synthetic body armor archetype:** At the **beginning of each Node**, grant **6 PULP prevention**. This reserve remains available **across Rustler turns and successive ICE encounters within the Node**, and incoming PULP consumes it normally. At the **next Node**, the Origin Ghostware grants a fresh **6 PULP prevention**. The armor's name, balance and final card presentation remain illustrative rather than finalized.

**Duration and accounting:** Node-long Origin Ghostware prevention **does not expire at the beginning of the next Rustler turn** under SOFT-013; that expiration applies to temporary prevention. For correct accounting alongside DMG-002's shared per-type prevention totals, the game must retain sufficient **duration/source bookkeeping** to expire temporary contributions while preserving any unspent Node-long reserve; this is **not** a return to player-selected shield consumption. Exact internal allocation between temporary and Node-long prevention when both coexist remains **OPEN**.

**Archetype implication:** Other Rustlers may specialize in SYN or CORTEX prevention using different Origin Ghostware; these are design possibilities, not locked starting abilities.


## 70. RULE-004 — Temporary resources spent before ongoing resources (LOCKED, 2026-11-10)

**Explicit user decision — universal game rule:** Whenever multiple eligible interchangeable resources, prevention reserves, or effects can satisfy the same expenditure, cost, or requirement, **temporary resources are consumed first, before permanent or ongoing resources**. This is a general PANOPTICON priority rule, not merely a shield rule. Apply automatically without requiring the Rustler to select individual resources. Explicit card text or a more specific rule may override the default priority.

**PULP prevention example:** Rustler has 3 temporary PULP prevention plus 6 Node-long PULP prevention from Origin Ghostware, for a displayed total of 9. Incoming PULP 4 consumes the 3 temporary first, then 1 Node-long, leaving 5 Node-long PULP prevention and 0 temporary. This is consistent with the single displayed pool per damage type (DMG-002) while preserving behind-the-scenes duration bookkeeping (GHOST-001).

**Scope:** The priority applies only when the candidate resources/effects are **eligible and interchangeable for the same requirement**; it does not make a PULP reserve eligible to pay SYN/CORTEX, bypass a printed cost, or allow an ineligible effect to be spent. Exact priority among multiple resources with equal duration remains OPEN.


## 71. RULE-005 — Earliest-expiring eligible resources consumed first (LOCKED, 2026-11-10)

**Explicit user approval:** Extend RULE-004 to a general priority based on **relative remaining duration**. When two or more **eligible, interchangeable** resources, prevention reserves, or effects could satisfy the same cost, requirement, or expenditure, the game **automatically consumes the one that expires soonest first**. A resource that is more temporary has higher consumption priority than one that lasts longer. This applies beyond damage prevention, subject to eligibility and explicit card/rule overrides.

**Illustration:** A shield expiring at the beginning of the next Rustler turn is spent before Node-long armor; Node-long armor is spent before an otherwise interchangeable reserve with an even longer duration or no expiration. The interface can present the combined available value while the engine tracks source/duration for priority and expiration.

**Relationship:** RULE-005 refines RULE-004's temporary-before-ongoing rule: priority is determined by **earliest expiration**, not merely a binary temporary/permanent distinction. The three damage-type pools remain distinct (DMG-002). No player selection is required.

**OPEN:** Tie-breaking between eligible resources with identical expiration times.


## 72. RULE-006 — Equal-expiration resource priority (LOCKED, 2026-11-10)

**Explicit user approval:** When two or more eligible, interchangeable resources or effects have **identical expiration timing** and are **mechanically equivalent for the expenditure**, the game may consume either automatically, **without prompting the Rustler to choose**. If individual source effects make the distinction **mechanically meaningful**, preserve and resolve that distinction rather than silently treating the resources as equivalent. An explicit card or more-specific rule may govern such a case.

**Priority relationship:** If expiration times differ, RULE-005 still requires consuming the **earliest-expiring eligible** resource first. RULE-004 establishes the overarching temporary-before-ongoing principle. This tie rule does not allow ineligible resources or cross-type prevention.

**OPEN:** A deterministic engine tie-breaker for mechanically distinct same-expiration resources if no specific card text resolves the conflict.


## 73. RULE-007 — Prevention multipliers apply to specified existing pools; encourage stacking (LOCKED, 2026-11-10)

**Explicit user decision:** Card effects **stacking and synergizing is encouraged** as a central deckbuilding feature. Do **not** impose an implicit restriction that multipliers can only affect newly generated prevention. Interpret prevention multiplier wording by its **scope**:
- **“Double your prevention”** doubles **all three current prevention pools**: PULP, SYN, and CORTEX.
- **“Double your PULP prevention”** doubles the **entire current PULP prevention pool**, including contributions already accumulated from multiple cards. Example: three cards collectively provide **15 PULP prevention**; doubling PULP prevention produces **30 PULP prevention**.
- **“The first defensive card you play each Rustler turn prevents twice as much PULP”** instead modifies **that individual card's contribution**, not the entire accumulated pool, as illustrated under SOFT-014.

**Design intent:** Encourage players to discover powerful interactions among multiple cards and Hardware/Ghostware; stacking effects should be supported, not automatically suppressed as exponential synergy. Wording determines whether a multiplier applies to a single contribution or an already-accumulated pool.

**Accounting:** The engine must preserve source/duration bookkeeping necessary for RULE-004/005/006 and GHOST-001 even when a multiplier affects a displayed pooled total.

**OPEN:** Precise ordering and rounding for multiple simultaneous multipliers, and how pool-wide multipliers distribute across contributions of different expiration durations. Do not assume repeated passive reapplication every frame/turn; timing must be specified.


## 74. RULE-008 — Prevention multipliers compound sequentially (LOCKED, 2026-11-10)

**Explicit user approval:** Multiple effects that multiply a prevention pool **compound sequentially against the pool's current value**, not additively and not just against the initial contributions. For example, if the Rustler has **15 PULP prevention**, resolving **“Double your PULP prevention”** twice yields **15 → 30 → 60**. Two doublings yield **×4**; three yield **×8**, provided each multiplier actually resolves.

**Design intent:** Powerful, potentially exponential stacking synergies are deliberate and encouraged. The exact wording of each card determines whether its multiplier affects a **whole pool** or an **individual card's contribution** (RULE-007).

**Still OPEN:** Ordering of simultaneous triggers/multipliers, mixed-duration contribution bookkeeping when a whole pool is multiplied, and any rounding rules for noninteger modifiers. This rule locks sequential compounding, not an unspecified trigger order.


## 75. RULE-009 — Snapshot-based prevention pool multipliers preserve duration (LOCKED, 2026-11-10)

**Explicit user approval:** A card saying **“Double your [type] prevention”** doubles the **prevention amount currently present when the card's effect resolves**. It is a **one-time snapshot effect**, not an ongoing multiplier applied automatically to prevention granted afterward. When the current pool contains contributions with different durations, the doubling **preserves those durations proportionally** by doubling each existing contribution's remaining amount before recombining the displayed pool.

**Example:** 6 Node-long PULP prevention from Ghostware + 4 temporary PULP prevention from Software = 10 total. A doubling effect resolves, yielding **12 Node-long + 8 temporary = 20 total**. The temporary 8 is consumed before the Node-long 12 under RULE-004/005. If another card later adds 3 PULP prevention, total becomes **23**, not 26. A second subsequent doubling resolves against the then-current **23**, producing **46** (RULE-008), preserving each contribution's duration.

**Scope:** “Double your prevention” applies this snapshot operation to each of PULP, SYN, and CORTEX; a type-specific multiplier affects only its named pool (RULE-007). No retroactive multiplication of already-spent prevention.


## 76. RULE-010 — Resolve card instructions in printed order (LOCKED, 2026-11-10)

**Explicit user approval:** A card's instructions resolve **sequentially in their printed order, top to bottom**, unless the card or a more-specific rule explicitly says otherwise. Earlier instructions change game state before later instructions resolve. This works with RULE-002 (fulfill as much as possible), RULE-003 (distinguish costs, instructions, and conditional rewards), and RULE-009 (snapshot multipliers evaluate the current pool at the moment of resolution). Required costs are paid before their associated effects resolve.

**Example:** Starting with 10 PULP prevention, **“Gain 5 PULP prevention. Double your PULP prevention.”** resolves **10 → 15 → 30**. The reverse wording, **“Double your PULP prevention. Gain 5 PULP prevention.”**, resolves **10 → 20 → 25**. Printed order therefore matters for synergies and is intentional.

**OPEN:** Ordering of multiple simultaneous triggers from different cards/effects, distinct from instructions printed sequentially on one card.


## 77. RULE-011 — Rustler orders simultaneous Rustler-controlled triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When **multiple Rustler-controlled effects trigger simultaneously**, the **Rustler chooses their resolution order**. Resolve each chosen trigger's effect **completely** before moving to the next; within each effect, printed instructions still resolve in order under RULE-010. This deliberately supports strategic sequencing and powerful card synergies.

**Example:** Rustler currently has **5 PULP prevention**. Two installed Software effects trigger together on playing a defensive card: one **grants 3 PULP prevention**, the other **doubles current PULP prevention**. Rustler may resolve **+3 first, then double** to produce **(5 + 3) × 2 = 16**, instead of **(5 × 2) + 3 = 13**.

**Scope:** This rule specifies the ordering of **simultaneous Rustler-controlled triggers**. It does not yet specify ordering of simultaneous Corporation-controlled triggers or cross-controller triggers, which remain OPEN.


## 78. RULE-012 — Corporation orders simultaneous Corporation-controlled triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When **multiple Corporation-controlled effects trigger simultaneously**, the **Corporation determines their resolution order**. Each chosen triggered effect resolves **completely** before the next begins; instructions within each effect follow printed order under RULE-010. This mirrors RULE-011 for Rustler-controlled simultaneous triggers.

**Scope:** The rule concerns **ordering of already-triggered Corporation effects**, not playing reactive cards during the Corporation turn; SOFT-011's restriction on Rustler card play remains unchanged. The order of simultaneous triggers **controlled by different sides** remains OPEN.


## 79. RULE-013 — Active side resolves opposing simultaneous triggers first (LOCKED, 2026-11-10)

**Explicit user approval:** When Rustler-controlled and Corporation-controlled effects trigger at the same moment, **the active side's triggered effects resolve first**:
- **During the Rustler's turn:** resolve Rustler-controlled triggers first, then Corporation-controlled triggers.
- **During the Corporation's turn:** resolve Corporation-controlled triggers first, then Rustler-controlled triggers.

Within each side's group of simultaneous triggers, that side chooses their order (RULE-011 for Rustler, RULE-012 for Corporation). Each trigger resolves completely before the next, with instructions in printed order (RULE-010). This ordering rule does **not** permit out-of-turn card plays; SOFT-011 remains in force.

**OPEN:** Exact handling of new triggers generated while another trigger is resolving (nested triggers/queue priority), if relevant.


## 80. RULE-014 — Chained triggers queue until current effect finishes (LOCKED, 2026-11-10)

**Explicit user approval:** If resolving an effect causes another effect to trigger, the newly triggered effect **does not interrupt** the currently resolving effect. Instead, it enters a **pending trigger queue**. Finish **all instructions of the current effect in printed order** (RULE-010), then resolve pending triggers according to existing controller and active-side priority rules (RULE-011/012/013). Each triggered effect likewise resolves fully before proceeding to the next. No reactive Rustler card play is permitted during the Corporation turn (SOFT-011).

**Illustration:** Starting at 0 PULP prevention, a played card says **“Gain 3 PULP prevention. Double your PULP prevention.”** Installed Software triggers on gaining PULP prevention and grants +2 PULP prevention. The +2 trigger waits while the played card resolves: **0 → 3 → 6**, then the queued +2 resolves to **8**. It does not interrupt between gaining 3 and doubling, which would have produced 10.

**OPEN:** Detailed queue policy for newly generated triggers while other triggers are queued, especially whether newly generated triggers are inserted ahead of or behind existing pending triggers, subject to RULE-011/012/013.


## 81. RULE-015 — FIFO pending trigger queue (LOCKED, 2026-11-10)

**Explicit user approval:** PANOPTICON's pending triggered effects resolve in **first-in, first-out (FIFO)** order. When an effect currently resolving generates a new trigger, that new trigger is appended to the **back of the existing pending queue** rather than jumping ahead of triggers already waiting. The current effect must complete before the next queued effect begins (RULE-014).

**Example:** Triggers **A** and **B** are already waiting. Resolving **A** generates trigger **C**. Resolve in order **A → B → C**.

**Compatibility with priority rules:** For triggers generated **simultaneously**, establish their relative enqueue order using controller choice (RULE-011/012) and active-side priority (RULE-013). After insertion, newly generated triggers do not overtake already-queued effects. Within each effect, printed instructions resolve top-to-bottom (RULE-010). This queue rule does not permit reactive card plays (SOFT-011).


## 82. RULE-016 — Detect and terminate infinite trigger loops (LOCKED, 2026-11-10)

**Explicit user approval:** PANOPTICON must automatically **detect and stop infinite or nonterminating triggered-effect cycles**, rather than allowing the game to hang or crash. Detection and interruption must be **deterministic**. This safeguard must **not** impose an arbitrary general cap on legitimate finite stacking, compounding prevention multipliers, or other intended card synergies (RULE-007/008). It works alongside the noninterrupting FIFO trigger queue (RULE-014/015).

**Design requirement:** Distinguish genuinely nonterminating trigger cycles from finite combinations that legitimately produce very large numerical effects. A repeated trigger name alone is insufficient evidence of an infinite loop.

**OPEN:** Exact cycle-detection algorithm, the precise trigger or effect suppressed when a cycle is detected, whether the player receives a notification, and how resolution continues after interruption. Do not treat these as locked until explicitly decided.


## 83. RULE-017 — Preserve resolved effects when terminating infinite loops (LOCKED, 2026-11-10)

**Explicit user approval:** When PANOPTICON detects a genuinely infinite/nonterminating trigger cycle under RULE-016, **cancel the repeating cycle** and its perpetuating triggers, **preserve all effects already resolved**, and **continue resolving unrelated pending effects** in the established FIFO trigger queue (RULE-014/015). Termination and continuation must be **deterministic**. Do not roll back legitimately resolved prevention, damage, resources, or other state changes merely because they were generated before loop detection.

**Example:** If a loop generated **10 PULP prevention** before being detected, that 10 remains; the nonterminating cycle is stopped; unrelated pending triggers continue to resolve.

**OPEN implementation detail:** The exact detection algorithm and how the engine identifies the minimal set of cycle-perpetuating queued triggers to cancel remain to be designed. The required observable behavior above is LOCKED.


## 84. RULE-018 — Notify player when infinite trigger loop is terminated (LOCKED, 2026-11-10)

**Explicit user approval:** When PANOPTICON detects and terminates an infinite trigger cycle under RULE-016/017, show the player a **brief, informative notification** identifying the involved cards or effects and indicating that the repeating interaction was stopped. The notification should not unnecessarily interrupt play. Previously resolved effects remain preserved, and unrelated pending triggers continue normally. Record sufficient diagnostic information to help investigate unexpected card interactions during playtesting.

**Illustrative notification:** “TRIGGER LOOP TERMINATED — Repeating interaction detected between [Card A] and [Card B]. Previously resolved effects preserved; unrelated effects continue.”

**OPEN:** Exact UI presentation, notification duration, and diagnostic log format.


## 85. RULE-019 — Repeated trigger-state detection principle (LOCKED, 2026-11-10)

**Explicit user approval:** PANOPTICON's infinite-loop detection must be based on **repeated trigger-state/cycle analysis**, accounting for which effects trigger one another, relevant game state, and whether the chain has a genuine termination condition. The system must distinguish **genuinely nonterminating cycles** from **finite but extremely powerful combinations**, even those producing hundreds or thousands of prevention points. **Do not impose an arbitrary numerical cap on legitimate card synergies.**

**Interaction with locked rules:** When a genuine infinite cycle is detected, terminate the perpetuating loop while preserving previously resolved effects and continuing unrelated queued effects (RULE-016/017), and notify the player of involved cards/effects (RULE-018). Respect FIFO queue ordering (RULE-015).

**OPEN for implementation:** Exact state representation, cycle-detection algorithm, proof/heuristics for termination, performance safeguards, and identification of the minimal set of perpetuating triggers. The detection **principle** is LOCKED; no particular algorithm is yet approved.


## 86. RULE-020 — Explicit card-specific trigger frequency limits (LOCKED, 2026-11-10)

**Explicit user approval:** Individual cards and abilities may specify **explicit trigger-frequency limits**, including **“Once per turn,” “Twice per Node,”** and **“The first time each turn.”** Such restrictions apply to the **specified card/ability**, not to PANOPTICON's trigger system globally. The engine tracks and enforces each ability's applicable count or first-occurrence condition over the printed period.

**Design intent:** These are deliberate **card-level balance and design tools**, not universal caps on stacking, multiplicative synergies, prevention values, or other legitimate interactions (RULE-007/008/016/019). Other cards and effects may still trigger normally, subject to their own text and established queue/ordering rules.

**OPEN:** Precise treatment of per-turn limits across Rustler versus Corporation turns when text says only “turn”; timing of counter reset at Node boundaries; whether copies of the same named card track limits independently (unless a card specifies otherwise). Do not assume these details are locked.


## 87. RULE-021 — Independent copies except explicit shared event/outcome limits (LOCKED, 2026-11-10)

**Explicit user approval with qualification:** Multiple installed copies of the same Software card **normally trigger independently**, and each copy tracks its own card-specific trigger frequency limit (RULE-020). For example, two installed copies each reading “Once per turn: When you play a defensive card, gain 2 PULP prevention” each trigger once, yielding **4 PULP prevention** in total.

**Explicit shared-limit exception:** If wording establishes an explicit limit on the **same event or outcome**, duplicating that wording must not compound beyond that limit. User's canonical example: two copies of “The first card you play is played twice” mean the first card is **played twice total**, **not twice and then twice more** (not four plays). A second copy cannot apply an additional doubling to that already doubled first play. Interpret “played twice” as an explicitly bounded outcome in this example, not as an unconstrained multiplicative stacking effect.

**Scope:** Do not infer shared caps where card text does not establish them; independent ordinary triggers and intended stacking remain valid. Specific text overrides generic stacking rules. **OPEN:** Exact card text conventions for expressing shared event/outcome caps versus stacking multipliers, and how repeated-play effects interact with other “when played” triggers.


## 88. RULE-022 — Replayed cards resolve each play independently (LOCKED, 2026-11-10)

**Explicit user approval:** When a card-play effect causes a card to be **played multiple times**, each actual play **resolves that card's printed instructions and applicable “when played” effects independently**, subject to explicit frequency restrictions and the existing trigger queue. Example: “The first card you play each turn is played twice” applied to “When played, gain 3 PULP prevention” grants **6 PULP prevention total**, from two separate plays.

**Compatibility:** The explicit “played twice” outcome limit remains in force under RULE-021: additional copies of the same replay-granting effect do **not** turn those two plays into four. Other applicable “when played” triggers can occur for each actual play, unless their own explicit limits (RULE-020) prevent them.

**OPEN:** Whether a replay pays the card's BW cost again, whether it counts as a new physical card leaving hand, and the exact timing of replay relative to other queued triggers. No answer is implied by this rule.


## 89. RULE-023 — Replayed cards pay BW only once (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect causes a card to be played more than once, **pay that card's BW cost only for its original play**. Any additional plays granted by the replay effect resolve the card's instructions without paying its BW cost again. For example, a **2 BW** card played twice through a replay effect costs **2 BW total, not 4 BW**, while both plays resolve independently under RULE-022.

**Compatibility:** An explicit “played twice” effect remains capped at two total plays despite duplicate sources (RULE-021). Explicit card-specific trigger-frequency limits still apply (RULE-020).

**OPEN:** Whether any **non-BW costs** must be paid again on replay, and how card-specific costs and “If you do” conditions interact with replay. Do not assume free non-BW costs.


## 90. RULE-024 — Non-BW costs paid for every replayed resolution (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect replays a card, the card's **BW cost is paid only for the original play** (RULE-023), but **each replayed resolution must independently pay any other explicit costs in full** (RULE-003). If the non-BW cost for an additional resolution cannot be paid, that resolution does not occur; any earlier completed resolutions remain valid.

**Example:** “Cost: Discard 1 card. Effect: Gain 5 PULP prevention.” Played twice via replay: discard one card for the original resolution and another card for the second; if both are paid, gain **10 PULP prevention total**. If the second discard cannot be paid, only the first resolution's 5 prevention is gained.

**Compatibility:** Explicit card-level limits (RULE-020), shared outcome limits (RULE-021), and the trigger queue (RULE-014/015) still apply. **OPEN:** Exact replay timing and whether an unpaid replay counts for play-trigger frequency or “first card played” bookkeeping.


## 91. RULE-025 — Uninterrupted replay sequence before queued triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect causes a card to be played multiple times, resolve the **entire replay sequence consecutively**, without interrupting between plays to resolve other pending triggered effects. Finish the first play completely, then the second play (and any additional plays permitted by explicit text); triggers generated during any of these plays are **enqueued** and resolve afterward according to the established FIFO ordering (RULE-014/015). This treats the granted sequence as one uninterrupted replay operation for trigger-processing purposes, while each play still independently resolves the card's instructions (RULE-022).

**Example:** A card grants 3 PULP prevention when played, and an installed Software triggers on gaining PULP prevention. If the card is played twice, the two plays first grant **6 PULP prevention** total; the triggered Software effects then resolve in queue order.

**Costs:** The original BW cost is paid only once (RULE-023); any explicit non-BW costs are independently required for each play (RULE-024). If a later replay's non-BW cost cannot be paid, that resolution fails without reversing earlier completed plays. Explicit shared “played twice” limits remain in force (RULE-021).

**OPEN:** Whether triggers already pending *before* a replay operation began can be delayed by a replay generated during a queued effect; precise event bookkeeping for unsuccessful replay attempts. Do not silently infer these edge cases.


## 92. RULE-026 — Replays do not reset explicit trigger-frequency limits (LOCKED, 2026-11-10)

**Explicit user approval:** Replaying a card does **not** reset or bypass an explicit frequency restriction printed on that card or ability, such as **“Once per turn.”** Each replay is still a separate play for other applicable effects (RULE-022), but an ability whose per-turn allowance has already been used does not activate again merely because its card is replayed.

**Canonical example:** “Once per turn: When played, gain 5 PULP prevention.” If an effect causes this card to be played twice during the same turn, the limited ability activates **once total**, granting **5 PULP prevention**, not 10.

**Compatibility:** RULE-020 (explicit per-card limits), RULE-021 (independent copies except explicit shared outcome limits), RULE-023/024 (replay costs), and RULE-025 (uninterrupted replay sequence) continue to apply. This does not introduce a universal trigger cap.

**OPEN:** Whether failed or unpaid replay attempts count as plays for frequency-limit bookkeeping; exact reset timing of limits phrased only as “per turn.”


## 93. RULE-027 — Per-turn trigger limits reset at every side's turn start (LOCKED, 2026-11-10)

**Explicit user approval:** An ability limited to **“once per turn”** (or another explicit **per-turn** frequency) refreshes its allowance at the **start of every turn**, including **both Rustler turns and Corporation turns**. A persistent ability may therefore trigger once on the Rustler turn and once on the following Corporation turn, provided the relevant trigger condition occurs in each turn.

**Example:** An installed defensive Software with a “once per turn” trigger can activate on the Rustler turn and again on the Corporation turn after its allowance resets. This does **not** permit the Rustler to play cards during the Corporation turn; existing persistent effects can trigger automatically (SOFT-011).

**Compatibility:** Explicit frequency restrictions continue to apply per ability (RULE-020), independent copies follow RULE-021, and replay does not reset a used allowance within the same turn (RULE-026). **OPEN:** Text specifying “once during your turn,” “once during the Rustler's turn,” or other narrower windows follows its explicit wording; exact turn-boundary event ordering relative to start-of-turn triggers is not yet defined.


## 94. RULE-028 — Reset per-turn allowances before start-of-turn triggers (LOCKED, 2026-11-10)

**Explicit user approval:** At the beginning of **every Rustler and Corporation turn**, first **reset all applicable per-turn trigger-frequency allowances** (RULE-027), and **then process abilities triggered at the start of that turn**. Start-of-turn abilities therefore use their freshly refreshed allowance, rather than being blocked by uses during the previous turn.

**Example:** An ability reading “Once per turn: At the start of a turn, [effect]” is eligible to trigger at the beginning of each turn after its allowance refreshes, subject to its other conditions and normal trigger ordering/queue rules.

**Compatibility:** This does not allow out-of-turn Rustler card play (SOFT-011); it concerns triggered abilities already in effect. **OPEN:** Relative ordering among multiple start-of-turn triggers follows existing controller/active-side rules (RULE-011/012/013), but timing relative to other start-of-turn housekeeping such as BW refresh, DRAW, or expiration of temporary prevention requires separate decisions.


## 95. RULE-029 — Temporary expiration before start-of-turn triggers (LOCKED, 2026-11-10)

**Explicit user approval:** At the beginning of the Rustler turn, **expire any temporary effects whose duration ends at that turn boundary before resolving start-of-turn triggered abilities**. This includes unused temporary prevention expiring at the start of the next Rustler turn under SOFT-013 and DMG-002. Such expired prevention is unavailable for start-of-turn doubling or other effects. Persistent and Node-long prevention remain governed by their distinct durations.

**Established start-of-turn ordering:** (1) Reset applicable per-turn trigger limits (RULE-028); (2) remove effects scheduled to expire at this turn start; (3) resolve start-of-turn triggered abilities using the resulting game state.

**Example:** Rustler ends the previous turn with 8 temporary PULP prevention scheduled to expire at the next Rustler turn start. Those 8 expire before a start-of-turn ability doubles current PULP prevention, so they are not doubled.

**OPEN:** Exact placement of BW refresh, DRAW, Node-long prevention refresh, and other turn-start housekeeping relative to these steps. Do not infer their order from this rule.


## 96. RULE-030 — Refresh BW before Rustler start-of-turn triggered abilities (LOCKED, 2026-11-10)

**Explicit user approval:** At the beginning of each **Rustler turn**, refresh BW to the Rustler's **full currently available amount**, including applicable modifiers to the baseline **4 BW**, **before** resolving any start-of-turn triggered abilities. Start-of-turn abilities that spend or modify BW therefore operate on freshly refreshed BW rather than the previous turn's remainder.

**Established Rustler turn-start order:** (1) reset applicable per-turn trigger-frequency allowances (RULE-028); (2) expire temporary effects scheduled to end at that Rustler turn start (RULE-029); (3) refresh BW to its full currently available amount; (4) resolve start-of-turn triggered abilities in the established priority/queue order (RULE-011 through RULE-015).

**Example:** Rustler ended the previous turn at 0 BW and has a current full available BW amount of 4. At the next Rustler turn start, BW becomes **4** before start-of-turn abilities resolve.

**OPEN:** Timing of normal DRAW and other turn-start housekeeping relative to these steps; how effects that alter maximum BW during start-of-turn resolution update available BW.


## 97. RULE-031 — Normal DRAW after start-of-turn abilities (LOCKED, 2026-11-10)

**Explicit user approval:** At the start of each Rustler turn, the Rustler's **normal starting-hand DRAW occurs after start-of-turn triggered abilities and their queued effects have finished resolving**. This allows any start-of-turn abilities that modify DRAW to affect the number of cards drawn on that same turn.

**Established Rustler turn-start sequence:** (1) reset applicable per-turn trigger-frequency allowances (RULE-028); (2) expire temporary effects scheduled to end at that Rustler turn start (RULE-029); (3) refresh BW to its full currently available amount (RULE-030); (4) resolve start-of-turn abilities and their queued triggers in established order; (5) calculate DRAW including CORTEX and other applicable modifiers, observing the minimum DRAW of 1; (6) draw the normal starting hand.

**Example:** Base/current DRAW is 5; a start-of-turn ability grants +2 DRAW. Once the ability resolves, the Rustler draws **7 cards** that turn.

**Compatibility:** CACHED cards remain additive to normal DRAW (SOFT-004). **OPEN:** Exact timing and handling of any effects that trigger *on drawing* or *after drawing*, and deck exhaustion/reshuffle behavior during normal DRAW.


## 98. RULE-032 — Complete normal DRAW before resolving draw-generated triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When the Rustler performs the **normal start-of-turn DRAW**, draw **all cards in that DRAW operation uninterrupted** before resolving any triggered effects generated by drawing those cards. Enqueue the resulting triggers and resolve them afterward according to established FIFO queue ordering (RULE-014/015). Individual card-draw events can each generate a trigger, but the triggers do not interrupt the ongoing normal DRAW operation.

**Canonical example:** An installed Software says “Whenever you draw a card, gain 1 PULP prevention.” With normal DRAW **5**, the Rustler first draws **all 5 cards**, then resolves **five draw-generated triggers**, gaining **5 PULP prevention total** (assuming no other modifiers or limits).

**Compatibility:** Normal DRAW occurs after start-of-turn abilities (RULE-031). Explicit per-card trigger frequency limits (RULE-020/026) still apply. **OPEN:** Whether other multi-card draw effects beyond the normal DRAW use the same uninterrupted batching convention; exact timing of draw-replacement effects, if introduced.


## 99. RULE-033 — Uninterrupted resolution of all multi-card draw effects (LOCKED, 2026-11-10)

**Explicit user approval:** Extend RULE-032 beyond normal start-of-turn DRAW: **every effect instructing a player to draw multiple cards completes its full draw operation before any triggers generated by those draws resolve**. Individual cards drawn can generate their own triggers, which enter the pending queue and resolve afterward under the existing FIFO rules (RULE-014/015). Applies to normal DRAW, Instant Software “Draw X cards,” and other multi-card draw effects.

**Example:** An Instant Software says “Draw 3 cards,” while an installed Software says “Whenever you draw a card, gain 1 PULP prevention.” Draw **all 3 cards first**, then resolve the **three** draw-generated triggers, gaining **3 PULP prevention** absent other modifiers or limits.

**Compatibility:** Explicit trigger-frequency limits (RULE-020/026) still constrain the number of activations. Effects resolve in printed order (RULE-010), so uninterrupted drawing applies to the specific multi-card draw instruction, not automatically to all instructions on a card.

**OPEN:** Replacement/prevention effects that alter the actual number of cards drawn, and handling of deck exhaustion during multi-card draws.


## 100. RULE-034 — Automatically reshuffle discard pile when draw pile empties (LOCKED, 2026-11-10)

**Explicit user approval:** When resolving a draw instruction and the **draw pile runs out**, automatically **shuffle the discard pile into a new draw pile**, then continue drawing until the instructed number of cards has been drawn or no eligible cards remain. This can occur partway through a multi-card draw. Do not terminate an otherwise fulfillable draw simply because the original draw pile is exhausted.

**Canonical example:** “Draw 3 cards” with **1 card** in the draw pile and **8 cards** in the discard pile: draw the remaining card; shuffle the eight discarded cards into a new draw pile; draw two more cards. Draw-generated triggers wait until the full multi-card draw operation completes (RULE-032/033), then resolve in FIFO order (RULE-014/015).

**No available cards:** If both draw and discard piles have no eligible cards, draw only as many as possible; the unfulfillable remainder is skipped under RULE-002. Any independent subsequent effects still resolve according to their text and existing rules.

**OPEN:** Whether any special card states or restrictions exclude specific cards from reshuffling; timing of shuffle-triggered abilities, if introduced. No additional penalties for an empty draw pile are established by this rule.


## 101. RULE-035 — Reshuffle-generated triggers wait until draw completes (LOCKED, 2026-11-10)

**Explicit user approval:** If the discard pile is automatically shuffled into the draw pile **during an ongoing draw operation** (RULE-034), the **reshuffle itself occurs immediately** to make further drawing possible, but any **triggered abilities generated by that reshuffle are queued and do not resolve until the entire draw operation finishes**. Then process pending triggers under FIFO ordering (RULE-014/015). This extends the uninterrupted draw behavior of RULE-032/033 to shuffle-generated triggers.

**Example:** An installed Software says “Whenever your discard pile is shuffled into your draw pile, gain 2 PULP prevention.” During “Draw 3 cards,” only one card remains in the draw pile: draw that card, shuffle the discard pile to replenish the draw pile, enqueue the shuffle trigger, draw the remaining two cards, then resolve queued effects. The reshuffle-triggered Software grants **2 PULP prevention** afterward.

**Compatibility:** Any card-draw triggers generated during the same draw operation also wait until it completes; FIFO ordering follows the order in which triggers entered the queue, subject to simultaneous-trigger ordering rules (RULE-011/012/013). Explicit trigger frequency limits still apply (RULE-020/026).

**OPEN:** Whether the act of shuffling itself can modify the number of cards still to draw via replacement effects, if such effects are introduced.


## 102. RULE-036 — Each actual reshuffle generates its own trigger (LOCKED, 2026-11-10)

**Explicit user approval:** When a draw operation causes **multiple actual discard-pile reshuffles**, each reshuffle is a **separate event** and independently generates any applicable “whenever you reshuffle” triggers. All reshuffle-generated triggers **wait until the full draw operation finishes** (RULE-035), then resolve according to the FIFO queue (RULE-014/015). Explicit card-specific frequency limits (RULE-020/026) still apply.

**Example:** Installed Software says “Whenever your discard pile is reshuffled into your draw pile, gain 2 PULP prevention.” If **three actual reshuffles** occur during one draw operation, three triggers are queued and later grant **6 PULP prevention total**, absent other modifiers or limits.

**Clarification:** This rule does not cause an extra reshuffle when there are no eligible cards in the discard pile; it only counts reshuffles that actually occur. The precise conditions under which repeated reshuffles can occur during a single draw remain subject to the available card zones and normal draw rules (RULE-034).


## 103. RULE-037 — No automatic penalty when draw and discard piles are empty (LOCKED, 2026-11-10)

**Explicit user approval:** If an instruction requires drawing cards but **both the draw pile and discard pile contain no eligible cards**, draw **zero cards** and **continue resolving any remaining independent instructions**. Do **not** automatically inflict Vitae damage, other damage, or any penalty merely because a draw could not be fulfilled. If some cards are available, draw as many as possible (RULE-002/034).

**Canonical example:** “Draw 3 cards. Gain 2 PULP prevention.” With both draw and discard piles empty, draw **0 cards** and still gain **2 PULP prevention**.

**Compatibility:** Explicit costs and conditional wording such as “If you do” still follow RULE-003; a card may explicitly specify a consequence for an unsuccessful draw, but there is **no universal deck-exhaustion penalty**. Automatic reshuffling applies only when the discard pile has eligible cards (RULE-034).


## 104. RULE-038 — Conditional draw rewards require full completion (LOCKED, 2026-11-10)

**Explicit user approval:** In card text of the form **“Draw X cards. If you do, [reward]”**, the **“If you do” condition is satisfied only if the full specified number X of cards was actually drawn**. If fewer cards are available, draw as many as possible under RULE-002/034/037, but do **not** grant the conditional reward under RULE-003.

**Canonical example:** “Draw 3 cards. If you do, gain 5 PULP prevention.” With only **2 eligible cards** across draw and discard piles, draw both, but **do not gain the 5 PULP prevention**.

**Contrast:** “Draw 3 cards. Gain 5 PULP prevention.” has no “If you do” condition, so the independent prevention instruction resolves even if fewer than 3 cards can be drawn (RULE-002).

**Compatibility:** Multi-card draws and their generated triggers remain uninterrupted (RULE-032/033), with automatic discard reshuffling where possible (RULE-034). This rule addresses conditional success, not a general deck-exhaustion penalty.


## 105. RULE-039 — Conditional rewards resolve before queued draw triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When a card instructs the Rustler to draw cards and then grants a conditional reward, **finish resolving the original card's printed instructions, including the conditional reward if its condition is met, before processing triggered effects generated by those draws**. Draw-generated triggers enter the FIFO queue and wait until the current effect finishes (RULE-010/014/015/033).

**Canonical example:** “Draw 3 cards. If you do, gain 5 PULP prevention.” With three cards available, draw all three uninterrupted, queue any draw-generated triggers, grant **5 PULP prevention** as the card's conditional reward, then resolve queued triggers in FIFO order. If fewer than three cards are drawn, the reward is not granted (RULE-038), but triggers generated by cards actually drawn still resolve after the original card finishes.

**Scope:** This establishes ordering between an original card's subsequent printed instructions and triggers generated during its draw. It does not change the explicit frequency limits or the distinction between unconditional and conditional instructions (RULE-002/003).


## 106. RULE-040 — Draw replacement effects apply before draw events (LOCKED, 2026-11-10)

**Explicit user approval:** Card text such as **“Whenever you would draw a card, you may gain 2 PULP prevention instead”** is a **replacement effect**, not an ordinary after-the-fact trigger. Before the affected draw event occurs, the Rustler chooses whether to **draw that card normally** or **replace that draw with 2 PULP prevention**. If replaced, the card is not drawn, and effects that trigger upon **actually drawing** a card do not trigger from that replaced event.

**Timing:** Replacement choices are made **before each applicable draw event**, including during multi-card draws. They modify whether the event happens, and are therefore distinct from queued triggers. Ordinary draw-generated and reshuffle-generated triggers still wait until the uninterrupted draw operation finishes (RULE-032/033/035); allowing replacement choices does not authorize interrupting the draw operation to resolve queued triggers.

**OPEN:** How multiple simultaneous replacement effects interact or are ordered; whether a replaced draw counts as satisfying “Draw X cards. If you do” (not established here); and the treatment of mandatory rather than optional replacement text. Do not infer those edge cases without approval.


## 107. RULE-041 — Replaced draws do not satisfy conditional draw requirements (LOCKED, 2026-11-10)

**Explicit user approval:** If a **draw replacement effect** substitutes another benefit for one or more instructed draws, the replaced events **do not count as cards actually drawn** when checking whether an instruction such as **“Draw X cards. If you do, [reward]”** was completed. The conditional reward requires **X actual cards drawn**, consistent with RULE-038. Replacement benefits still apply normally (RULE-040).

**Canonical example:** “Draw 3 cards. If you do, gain 5 PULP prevention.” The Rustler replaces one of the three draws with **2 PULP prevention**, and actually draws the other two cards. Result: **2 cards drawn**, **2 PULP prevention** from the replacement, and **no 5 PULP prevention conditional reward**, because the full draw instruction was not satisfied.

**Compatibility:** Draw-generated triggers only arise from cards actually drawn (RULE-040); the multi-card draw operation otherwise remains uninterrupted and its queued triggers resolve afterward (RULE-033/039). **OPEN:** Interaction among multiple competing replacement effects for the same would-be draw event.


## 108. RULE-042 — Choose one competing draw replacement per event (LOCKED, 2026-11-10)

**Explicit user approval:** When **multiple optional replacement effects** could replace the **same would-be card draw**, the Rustler chooses **at most one** of those replacement effects for that draw. The Rustler may instead choose to **draw the card normally**. Applying one replacement consumes/replaces that draw event; the other replacement effects cannot also claim benefits from that same draw.

**Canonical example:** Installed Card A: “Whenever you would draw a card, you may gain 2 PULP prevention instead.” Installed Card B: “Whenever you would draw a card, you may gain 1 BW instead.” For each would-be draw, choose exactly one of: (a) actually draw one card; (b) gain **2 PULP prevention** instead; or (c) gain **1 BW** instead. **Never gain both replacement benefits for the same draw.**

**Multiple-card draws:** Make the replacement choice independently for **each individual would-be draw**, while preserving uninterrupted resolution of the overall draw operation and deferring ordinary triggers until afterward (RULE-033/040).

**Compatibility:** A replaced draw does not count as a card actually drawn for conditional draw rewards (RULE-041). **OPEN:** Mandatory replacement effects and precedence between mandatory and optional replacements, if introduced.


## 109. RULE-043 — Mandatory draw replacements take priority over optional replacements (LOCKED, 2026-11-10)

**Explicit user approval:** When a **mandatory** draw replacement and an **optional** draw replacement are both applicable to the same would-be draw, the **mandatory replacement takes priority**, unless other card text **explicitly overrides** that precedence. A replacement reading **“Whenever you would draw a card, gain 2 PULP prevention instead”** (without “may”) is mandatory. The Rustler cannot elect to draw normally or choose a competing optional replacement while the mandatory replacement applies.

**Canonical example:** Card A (mandatory): “Whenever you would draw a card, gain 2 PULP prevention instead.” Card B (optional): “Whenever you would draw a card, you may gain 1 BW instead.” For the affected draw, apply Card A and gain **2 PULP prevention**; do **not** draw the card or gain Card B's optional **1 BW**, absent explicit override text.

**Compatibility:** Only one replacement benefit applies to a single draw event (RULE-042). Replaced draws do not count as actual cards drawn for conditional rewards (RULE-041). Replacement effects occur before the affected draw rather than as queued post-draw triggers (RULE-040).

**OPEN:** Ordering/selection when **multiple mandatory replacements** compete for the same draw event, and the exact meaning and resolution of explicit priority overrides.


## 110. RULE-044 — Rustler chooses between competing mandatory draw replacements (LOCKED, 2026-11-10)

**Explicit user approval:** If **two or more mandatory draw replacement effects** apply to the **same would-be draw event**, the **Rustler chooses exactly one** of the competing mandatory replacements to apply. The unchosen mandatory replacements do not produce benefits from that draw. Because a mandatory replacement applies, the Rustler cannot choose to perform the original draw normally, absent explicit overriding card text.

**Canonical example:** Installed Card A: “Whenever you would draw a card, gain 2 PULP prevention instead.” Installed Card B: “Whenever you would draw a card, gain 1 BW instead.” For each would-be draw, the Rustler chooses **either 2 PULP prevention or 1 BW**, **not both**, and does not draw the card.

**Compatibility:** Mandatory replacements have priority over optional replacements (RULE-043), only one replacement applies per draw (RULE-042), and replaced draws do not count as actually drawn for conditional rewards (RULE-041). The decision occurs before the affected draw event (RULE-040).

**OPEN:** How an explicit card-text priority override affects selection among multiple mandatory replacements; interaction with replacement effects that change rather than fully substitute a draw.


## 111. RULE-045 — Draw replacements require an available drawable card (LOCKED, 2026-11-10)

**Explicit user decision:** Rejected the proposal that a “whenever you would draw” replacement can grant its substitute benefit when both draw and discard piles have no eligible cards. Approved the interpretation that **only would-be draws for which an eligible card is actually available may be replaced**. A draw instruction that cannot be fulfilled due to lack of eligible cards **does not generate a replacement benefit**.

**Canonical example:** “Draw 3 cards,” with only **2 eligible cards** available across draw and discard piles, and an installed Software allowing each draw to be replaced with **2 PULP prevention**. The Rustler may (a) draw both cards, (b) replace one available draw to draw one card and gain 2 PULP prevention, or (c) replace both available draws to gain 4 PULP prevention and draw zero cards. The **third, unavailable draw cannot be replaced** and generates no prevention.

**Compatibility:** This restriction applies to both mandatory and optional draw replacement effects (RULE-040/042/043/044). A replaced draw is not counted as an actual card drawn for conditional “If you do” rewards (RULE-041). Unavailable draws carry no automatic deck-exhaustion penalty (RULE-037). Normal discard reshuffling may supply available cards (RULE-034). **OPEN:** How to test availability if a replacement itself moves cards among zones or changes deck composition.


## 112. RULE-046 — Draw availability includes discard pile for replacements (LOCKED, 2026-11-10)

**Explicit user approval:** For purposes of checking whether a would-be draw is eligible for a draw replacement (RULE-045), **available drawable cards include eligible cards in both the draw pile and the discard pile**, because the discard pile can normally be reshuffled into the draw pile when needed (RULE-034). A replacement may apply when the draw pile is empty but the discard pile contains eligible cards. If both piles are empty, no replacement benefit can be generated.

**Canonical example:** Replacement Software: “Instead of drawing a card, shuffle one card from your discard pile into your draw pile.” If the draw pile is empty and the discard pile contains at least one eligible card, the replacement **can activate** and move the card as instructed instead of drawing. If both piles are empty, the replacement cannot activate.

**Compatibility:** Replaced draws do not count as actual draws for conditional draw completion or draw triggers (RULE-040/041). This rule establishes the **availability test**, not any new permission to generate benefits from impossible draws.

**OPEN:** Whether checking availability for a replacement with an empty draw pile itself triggers an automatic full-discard reshuffle before the replacement resolves; distinguish that from a replacement that explicitly moves cards from discard.


## 113. RULE-047 — Resolve draw replacement choice before automatic reshuffling (LOCKED, 2026-11-10)

**Explicit user approval:** When the draw pile is empty but the discard pile contains eligible cards, **check draw availability across both piles** (RULE-046), then **resolve applicable draw replacement choices before performing an automatic discard-to-draw reshuffle**. If the Rustler replaces the draw, **do not perform an automatic reshuffle for that replaced event**. If the Rustler proceeds with the actual draw, **reshuffle the discard pile into the draw pile** under RULE-034 and then draw. An explicit replacement effect that itself moves or shuffles cards resolves according to its own text; that is distinct from an automatic reshuffle.

**Canonical example:** Draw pile empty; discard pile contains 5 cards; installed Software reads “Whenever you would draw a card, you may gain 2 PULP prevention instead.” The Rustler may choose **2 PULP prevention** and **no automatic reshuffle occurs**, hence no automatic reshuffle trigger from this draw. Alternatively, the Rustler may draw normally, triggering the automatic reshuffle and then drawing the card.

**Compatibility:** No replacement benefit if both piles lack eligible drawable cards (RULE-045). Replaced draws do not trigger on-draw effects or satisfy conditional draw counts (RULE-040/041). Automatic reshuffle triggers, when an actual reshuffle occurs, are queued according to RULE-035/036.

**OPEN:** Ordering among explicit shuffle/move effects that change availability mid multi-card draw.


## 114. RULE-048 — Recalculate card availability before each draw in multi-card instructions (LOCKED, 2026-11-10)

**Explicit user approval:** During a multi-card draw instruction (such as “Draw 3 cards”), **recalculate the availability of eligible drawable cards before each individual would-be draw**, accounting for changes to draw and discard piles caused by prior replacements in that same instruction. A replacement that returns a card to the draw pile can therefore make that card eligible for a **subsequent draw** in the same instruction, even when the initial pile sizes would not have supported that later draw.

**Canonical example:** The draw pile initially contains **1 card**, the discard pile is empty, and installed Software says “Whenever you would draw a card, you may return 1 card from your hand to the draw pile instead.” The Rustler may replace an eligible first draw by returning a card from hand to the draw pile. The updated draw pile is checked for the next would-be draw, allowing that card to be drawn or otherwise handled according to applicable replacement rules. Reassess availability for each further draw.

**Compatibility:** Draw replacement requires an available drawable card at the time of the individual draw (RULE-045), including eligible cards in discard (RULE-046); replacement choices precede automatic reshuffling (RULE-047). A replaced draw is not an actual draw for draw triggers or conditional full-draw rewards (RULE-040/041). Normal multi-card draw instructions remain uninterrupted by queued ordinary triggers (RULE-033/039).

**OPEN:** Whether cards returned to the draw pile by replacement are placed on top, bottom, or shuffled in, unless specified by card text; how multiple effects modify availability during a single draw event.


## 115. RULE-049 — Draw-pile insertion destination must be explicit (LOCKED, 2026-11-10)

**Explicit user direction:** Every card effect that **returns, moves, or inserts a card into the draw pile** must explicitly state **where** that card goes: **top of the draw pile**, **bottom of the draw pile**, or **shuffled into the draw pile**. **There is no default placement** for card effects.

**Invalid/unfinished wording:** “Instead of drawing a card, return 1 card from your hand to your draw pile.” This does not specify placement and must be corrected during card design rather than silently interpreted by the engine.

**Valid example:** “Instead of drawing a card, return 1 card from your hand to the **top** of your draw pile.” Other effects may explicitly specify the **bottom** or instruct the player to **shuffle** the card into the draw pile.

**Compatibility:** Replacement effects can change draw availability for subsequent individual draws within a multi-card draw instruction (RULE-048). This rule does not alter the separate automatic reshuffle of the discard pile when drawing from an empty draw pile (RULE-034/047).

**Implementation guidance:** Card definitions and validation should reject or flag draw-pile movement effects without an explicit destination.


## 116. RULE-050 — Shuffling into an empty draw pile incorporates the discard pile (REVISED, LOCKED, 2026-11-10)

**Explicit user revision:** When an effect instructs the Rustler to **shuffle one or more specified cards into an empty draw pile**, first include **all cards from the discard pile** together with the incoming specified cards, then shuffle the combined cards into the draw pile **as one shuffle event**. The discard pile becomes empty. This **replaces the original RULE-050** that kept discard cards untouched.

**Canonical example:** “Return 1 card from your hand and shuffle it into your draw pile.” With an empty draw pile and **5 cards in discard**, combine the 5 discarded cards and the 1 returned card, then shuffle them together as **one shuffle event**. The draw pile contains **6 cards**, and discard contains **0**.

**Scope:** This applies specifically when card text explicitly instructs a **shuffle into an empty draw pile**. It does not change the explicit top/bottom/shuffle destination requirement (RULE-049), the automatic reshuffle procedure for actual draws (RULE-034), or the replacement-before-automatic-reshuffle timing (RULE-047). See RULE-051 for trigger accounting.


## 117. RULE-051 — Combined empty-pile shuffle counts as one shuffle event (LOCKED, 2026-11-10)

**Explicit user approval of aligned RULE-050/051:** When shuffling one or more incoming cards into an **empty draw pile** with cards in discard, the discard cards and incoming cards are **combined first**, then shuffled together in **one operation**. This counts as **one shuffle event**, not separate discard-reshuffle and incoming-card-shuffle events.

**Trigger consequences:** An effect that triggers “Whenever you shuffle your draw pile” sees **one shuffle** and triggers once (subject to card-specific limits). A trigger explicitly requiring a **discard-pile reshuffle** must be evaluated according to its wording; do not silently equate all shuffle trigger conditions. Any resulting triggers follow the existing queue and resolution rules (RULE-014/015/035/036).

**Compatibility:** RULE-050 (revised) establishes card movement; RULE-051 establishes single-event accounting. No automatic shuffle is implied when a card is placed explicitly on the top or bottom of the draw pile instead of being shuffled (RULE-049).


## 118. RULE-052 — Combined shuffle qualifies as discard-pile reshuffle trigger (LOCKED, 2026-11-10)

**Explicit user approval:** When the discard pile is incorporated into an empty draw pile as part of the combined shuffle established by revised RULE-050 and RULE-051, the operation **qualifies as a discard-pile reshuffle** for effects reading “Whenever you reshuffle your discard pile into your draw pile.” It produces **one shuffle event** and therefore **one such trigger** per qualifying effect, subject to any explicit card-specific frequency restrictions.

**Canonical example:** Draw pile empty, discard pile has 5 cards; Rustler shuffles 1 card from hand into the draw pile. All 6 cards are combined and shuffled together once; discard becomes empty. Installed Software “Whenever you reshuffle your discard pile into your draw pile, gain 2 PULP prevention” **triggers once**, granting **2 PULP prevention**.

**Compatibility:** This is one event, not a discard reshuffle followed by a separate shuffle (RULE-051). Apply ordinary trigger queuing and timing (RULE-014/015/035/036). The specific discard-reshuffle trigger requires that cards actually be incorporated from discard; merely shuffling a card into an empty draw pile when discard is empty does not meet that wording.


## 119. RULE-053 — General draw-pile shuffle differs from discard-pile reshuffle (LOCKED, 2026-11-10)

**Explicit user approval:** An instruction to **shuffle a card into the draw pile** counts as **one general draw-pile shuffle event** even if the draw pile was empty and the resulting draw pile contains only one card. However, this does **not** qualify as a **discard-pile reshuffle** unless at least one card was actually incorporated from the discard pile.

**Canonical example:** Draw pile **0**, discard pile **0**; card says “Shuffle 1 card from your hand into your draw pile.” The resulting draw pile contains **1 card**. Effects reading “Whenever you shuffle your draw pile” trigger **once**; effects reading “Whenever you reshuffle your discard pile into your draw pile” do **not** trigger.

**Compatibility:** When discard cards actually participate in the combined shuffle under RULE-050/051, discard-reshuffle triggers qualify (RULE-052). One shuffle operation is still only one shuffle event; apply ordinary trigger queue and card-specific frequency limits.


## 120. RULE-054 — One shuffle event may satisfy multiple trigger conditions (LOCKED, 2026-11-10)

**Explicit user approval:** A **single shuffle event** may simultaneously satisfy **multiple distinct trigger conditions**. Each eligible installed ability triggers once for that event, subject to its own card-specific frequency limits. This does **not** multiply the number of shuffle events. If the abilities are Rustler-controlled and simultaneous, the **Rustler chooses their resolution order** (RULE-011), with the existing trigger queue applying (RULE-014/015).

**Canonical example:** Installed Card A: “Whenever you shuffle your draw pile, gain 2 PULP prevention.” Installed Card B: “Whenever you reshuffle your discard pile into your draw pile, gain 1 BW.” The Rustler performs a **combined shuffle under revised RULE-050** incorporating cards from discard. This is **one shuffle event** (RULE-051), qualifying both as a general draw-pile shuffle (RULE-053) and as a discard-pile reshuffle (RULE-052). **Both Card A and Card B trigger once**, granting **2 PULP prevention** and **1 BW** respectively; the Rustler chooses their order of resolution.

**Scope:** This does not imply that an ability can trigger multiple times from the same event merely because its condition is described in multiple ways.


## 121. RULE-055 — Separate abilities on one card independently trigger (LOCKED, 2026-11-10)

**Explicit user approval:** When a **single installed Software card** has **multiple separately written triggered abilities**, evaluate each ability **independently** against a qualifying event. If the event satisfies multiple abilities, **each triggers once** (subject to its own explicitly stated frequency limit), even though they appear on the **same card**. Rustler-controlled simultaneous triggers are ordered by the Rustler (RULE-011) and otherwise follow the established trigger queue (RULE-014/015).

**Canonical example:** One Software card has both “Whenever you shuffle your draw pile, gain 2 PULP prevention” and “Whenever you reshuffle your discard pile into your draw pile, gain 1 BW.” A combined shuffle that incorporates discard cards (RULE-050/051/052/053) satisfies **both** abilities. They each trigger **once**, granting **2 PULP prevention** and **1 BW**, with the Rustler choosing resolution order.

**Compatibility:** A single event can qualify multiple distinct abilities (RULE-054), including when those abilities share a card. This does not allow one individual ability to trigger multiple times from the same single event, and explicit “once per turn” or other card-specific limits still apply (RULE-020).


## 122. RULE-056 — Explicit shared trigger limits override independent abilities (LOCKED, 2026-11-10)

**Explicit user approval:** When a card explicitly groups multiple triggered abilities under a **shared limit** such as **“Once per turn, choose one”**, that shared restriction overrides the default independence of separately written abilities (RULE-055). Even when one event qualifies for multiple listed triggers, the controller may choose **only one qualifying benefit** for that event, and doing so consumes the **shared once-per-turn allowance**. The other grouped benefit does not activate.

**Canonical example:** One installed Software reads: “Once per turn, choose one: (a) Whenever you shuffle your draw pile, gain 2 PULP prevention; (b) Whenever you reshuffle your discard pile into your draw pile, gain 1 BW.” A combined shuffle involving discard cards satisfies both conditions, but the Rustler chooses **either 2 PULP prevention or 1 BW**, **not both**. The shared limit is then used for that turn.

**Compatibility:** Independently written abilities trigger separately by default (RULE-055); explicit shared limits override this (RULE-020). The per-turn shared allowance resets under RULE-027/028. Shuffle event classification remains governed by RULE-050–054.


## 123. RULE-057 — Shared trigger limits tracked independently per installed copy (LOCKED, 2026-11-10)

**Explicit user approval:** Each **installed instance** of a Software card has its **own allowance** for an explicit grouped/shared trigger restriction such as **“Once per turn, choose one”** (RULE-056). Multiple copies may each select one eligible benefit when the same event qualifies, unless the card explicitly imposes a **global/shared-across-copies** limit.

**Canonical example:** The Rustler installs **two copies** of Software reading: “Once per turn, choose one: (a) Whenever you shuffle your draw pile, gain 2 PULP prevention; (b) Whenever you reshuffle your discard pile into your draw pile, gain 1 BW.” A combined shuffle incorporating discard cards qualifies for both options on each copy. Each copy independently chooses **one** option, allowing a total of **4 PULP prevention**, **2 BW**, or **2 PULP prevention plus 1 BW**. Both copies' own once-per-turn allowances are then consumed.

**Compatibility:** Independent per-copy triggers are consistent with RULE-021; shared limits within each copy follow RULE-056; explicit global restrictions override per-copy allowances. Per-turn allowances reset under RULE-027/028, and simultaneous Rustler-controlled triggers follow RULE-011.


## 124. RULE-058 — Explicit global trigger limits shared across all installed copies (LOCKED, 2026-11-10)

**Explicit user approval:** When card text explicitly imposes a **global trigger-frequency restriction across all installed copies of that card**, all those copies share **one allowance**, rather than each copy having an independent activation. The global restriction overrides the default per-copy trigger allowances (RULE-021/057) only when stated explicitly.

**Canonical example:** Software reads: “Once per turn, across all installed copies of this card, whenever you shuffle your draw pile, gain 2 PULP prevention.” The Rustler has **three installed copies** and performs a qualifying shuffle. The effect activates **once total**, granting **2 PULP prevention**, **not 6**. The shared allowance is consumed for all three copies until the per-turn reset.

**Compatibility:** Per-copy trigger limits remain the default (RULE-057); explicit shared limits within a card remain governed by RULE-056. Per-turn reset follows RULE-027/028. Multiple different abilities may still qualify from one event unless limited by explicit text (RULE-054/055).


## 125. RULE-059 — Installing new copies does not reset a consumed global trigger limit (LOCKED, 2026-11-10)

**Explicit user approval:** A globally shared trigger-frequency allowance belongs to the **card's shared ability across all installed copies**, not to any particular installed instance. If the global allowance has already been consumed during the current turn, **installing another copy of that card later in the same turn does not restore or reset the allowance**. The newly installed copy inherits the consumed state until the normal per-turn reset (RULE-027/028).

**Canonical example:** One installed Software has “Once per turn, across all installed copies of this card, whenever you shuffle your draw pile, gain 2 PULP prevention.” A shuffle activates it once for **2 PULP prevention**. The Rustler then installs a second copy and shuffles again during the same turn. **No second activation** occurs, because the shared global allowance remains consumed.

**Compatibility:** Explicit global limits override per-copy limits (RULE-058), while ordinary independent per-copy limits remain the default (RULE-057). The global allowance resets at the beginning of each turn under RULE-027/028.

**OPEN:** Whether a globally consumed limit persists if all copies leave play and another copy is installed later in the same turn.


## 126. RULE-060 — Global trigger limits persist after all copies leave play (LOCKED, 2026-11-10)

**Explicit user approval:** A globally shared trigger-frequency allowance is tracked by **card identity for the full turn**, even if **all installed copies leave play**. Uninstalling every copy and later installing another copy of the same card during that turn **does not reset a consumed global allowance**. The normal turn-start reset remains the only default reset (RULE-027/028), unless explicit card text provides otherwise.

**Canonical example:** A globally once-per-turn shuffle ability triggers once. The Rustler uninstalls all copies of that Software, then installs another copy in the same turn and shuffles again. The ability **does not trigger again** because its global allowance remains consumed.

**Compatibility:** Global limits are shared across copies (RULE-058), and installing a new copy does not reset a consumed allowance (RULE-059). This rule clarifies that the consumed state persists even across a period with zero installed copies.

**OPEN:** How globally limited abilities distinguish separate card identities or upgraded/modified variants when their names match.


## 127. RULE-061 — PATCHWORK modifications preserve card identity for global trigger limits (LOCKED, 2026-11-10)

**Explicit user approval:** A **PATCHWORK modification** changes properties or abilities of an individual card instance but **does not change its underlying card identity** for the purposes of global trigger-frequency restrictions. Standard and PATCHWORK-modified copies of the same original Software card therefore **share the same global activation allowance** for a globally limited ability they retain.

**Canonical example:** Copy A is standard Software; Copy B is a PATCHWORK-modified copy of that same Software with an additional ability. Both retain the same globally once-per-turn shuffle ability. If either copy activates that shared ability, its **global allowance is consumed for both copies** until the ordinary turn-start reset (RULE-027/028), even though one copy is modified. Copy B's additional PATCHWORK ability is governed by its own text and limits.

**Compatibility:** Global limits apply across copies (RULE-058), survive installation changes (RULE-059/060), and track underlying card identity rather than PATCHWORK variant. This does not establish a shared limit for distinct additional abilities unless their text explicitly creates one.

**OPEN:** Identity rules for cards transformed into a different named/base card, if such mechanics are introduced.


## 128. RULE-062 — PATCHWORK augments original abilities and inherits their restrictions (REVISED, LOCKED, 2026-11-10)

**Explicit user correction superseding the original RULE-062:** PATCHWORK is an **augmentation/extension of the card's original ability**, not a separate independent trigger system. **Any restrictions applying to the original ability also apply to its PATCHWORK enhancement**, including once-per-turn, per-card, shared, and global-across-copies activation limits. PATCHWORK cannot circumvent an already-consumed original trigger allowance.

**Canonical example:** Original Software ability: “Once per turn, across all installed copies of this card, whenever you shuffle your draw pile, gain 2 PULP prevention.” PATCHWORK augments that ability with **+1 PULP prevention**. A qualifying shuffle with an available shared global allowance activates the modified card's ability for **3 PULP prevention** (2 original + 1 PATCHWORK). Once the shared global allowance is consumed, neither the original portion nor its PATCHWORK augmentation can activate again during that turn.

**Compatibility:** PATCHWORK preserves original card identity (RULE-061). Global restrictions continue to apply across copies (RULE-058–060). The general independence of separately printed abilities (RULE-055) does **not** exempt PATCHWORK augmentations from restrictions attached to the original ability they modify.

**Design clarification:** If a future PATCHWORK effect is intended to create an entirely new, separately limited ability rather than augment the existing ability, that exception requires explicit design approval; do not infer independence by default.


## 129. RULE-063 — Rustler selects which differently modified copy uses a shared global activation (LOCKED, 2026-11-10)

**Explicit user approval:** When multiple installed copies of the **same underlying Software card** share a **global trigger activation allowance**, but differ in their **PATCHWORK enhancements**, the **Rustler chooses which eligible installed copy's ability resolves** on a qualifying event. Resolve the selected copy's original ability together with its PATCHWORK augmentation, then consume the **single global allowance for all copies**. Other copies do not also resolve that globally restricted ability for the same event.

**Canonical example:** Copy A is unmodified and grants **2 PULP prevention** on a qualifying shuffle; Copy B has PATCHWORK augmenting the same ability to grant **5 PULP prevention**. Both share a global once-per-turn limit. On a qualifying shuffle with the allowance available, the Rustler chooses **either 2 PULP prevention (A) or 5 PULP prevention (B)**, not both. The global allowance is then consumed for all copies until reset.

**Compatibility:** Global restrictions apply across installed copies (RULE-058–060), PATCHWORK preserves identity (RULE-061) and inherits restrictions of the augmented ability (revised RULE-062). The choice of instance determines the modified outcome, not an additional activation.


## 130. RULE-064 — Only eligible installed copies can activate PATCHWORK-enhanced abilities (LOCKED, 2026-11-10)

**Explicit user approval:** When multiple copies of the same Software card share a global activation limit, the Rustler may select **only an eligible installed copy** to resolve the globally limited ability. A PATCHWORK-modified copy in the discard pile or another inactive zone cannot be selected to provide its enhanced effect, **unless explicit card text permits activation from that zone**.

**Canonical example:** Copy A is standard Software, **installed**, and its qualifying shuffle ability grants **2 PULP prevention**. Copy B is PATCHWORK-modified Software, **in the discard pile**, and would grant **5 PULP prevention** if installed. A qualifying shuffle occurs. Only Copy A is eligible to activate, granting **2 PULP prevention** and consuming the shared global allowance. Copy B's enhanced benefit is unavailable while it remains in discard.

**Compatibility:** Rustler chooses among eligible differently modified copies for a shared global activation (RULE-063). PATCHWORK preserves original card identity and inherits original restrictions (RULE-061/062); global limits remain shared across copies (RULE-058–060). Zone-specific exceptions require explicit text.


## 131. RULE-065 — Installing PATCHWORK-enhanced copies does not reset consumed global limits (LOCKED, 2026-11-10)

**Explicit user approval:** Installing a **PATCHWORK-enhanced copy** of Software during a turn does **not** restore an already-consumed **globally shared trigger allowance** for the original ability it augments. The stronger modified benefit is unavailable until the global allowance resets normally, even if the enhanced copy was not installed when the allowance was first consumed.

**Canonical example:** Installed standard Copy A activates a globally once-per-turn shuffle ability for **2 PULP prevention**. Later in the same turn, the Rustler installs PATCHWORK-enhanced Copy B, whose version of that same ability would grant **5 PULP prevention**. A second qualifying shuffle occurs. **Copy B does not activate**; the global allowance was consumed by Copy A. At the normal start-of-turn reset, the allowance becomes available again and the Rustler may select an eligible installed copy.

**Compatibility:** Global limits are shared across copies (RULE-058), persist across later installation (RULE-059) and complete uninstallation (RULE-060), PATCHWORK preserves identity (RULE-061) and inherits original restrictions (revised RULE-062), and only eligible installed copies can be selected (RULE-064). Reset timing follows RULE-027/028.


## 132. RULE-066 — Temporary removal and return does not reset activation limits (LOCKED, 2026-11-10)

**Explicit user approval:** When a PATCHWORK-enhanced Software card **temporarily leaves play and returns during the same turn**, any previously consumed **once-per-turn or applicable shared activation allowance remains consumed**. Temporary removal and re-entry do not create a fresh card identity or refresh activation eligibility. The PATCHWORK augmentation and original ability share the same restriction (RULE-062).

**Canonical example:** An installed Software card has “Once per turn, whenever you shuffle your draw pile, gain 2 PULP prevention,” augmented by PATCHWORK to grant **5 PULP prevention** on activation. It activates once, is temporarily removed from play by ICE, and returns installed in the same turn. On another qualifying shuffle that turn, **it cannot activate again**. Its allowance resets only at the normal turn reset.

**Compatibility:** PATCHWORK preserves underlying identity (RULE-061); restrictions extend to augmentation (RULE-062); installation cannot reset consumed global limits (RULE-059/065). Normal per-turn reset follows RULE-027/028. Explicit card text may define an exception.


## 133. RULE-067 — Full-card temporary copies inherit PATCHWORK enhancements (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect explicitly **copies the entire PATCHWORK-enhanced Software card**, its temporary copy inherits the original card's **modified abilities and PATCHWORK augmentation**. The temporary copy is a distinct card instance and has its **own per-copy once-per-turn activation allowance**. Restrictions attached to the copied ability still apply to its augmentation; an explicitly **global limit across all copies** remains shared rather than becoming independent.

**Canonical example:** Original Software: “Once per turn, whenever you shuffle your draw pile, gain 2 PULP prevention.” PATCHWORK augments that benefit to **5 PULP prevention**. An effect creates a temporary full-card copy. Both original and temporary copy have the **5 PULP prevention** ability, and each may activate **once per turn**, provided each is otherwise eligible. If instead the ability says “once per turn, across all copies,” both share the **single global allowance**.

**Scope:** Copying the card's modified characteristics does not award an additional permanent PATCHWORK upgrade. Duration, disposition and zone of the temporary copy follow the creating effect, to be specified by that effect.

**Compatibility:** PATCHWORK is an extension of the original ability and inherits restrictions (RULE-062); only eligible installed Software copies activate installed abilities (RULE-064); per-copy vs global limits follow RULE-021/058–060.


## 134. RULE-068 — Newly created temporary copies start with unused per-copy activation allowances (LOCKED, 2026-11-10)

**Explicit user approval:** A **new temporary full-card copy** of PATCHWORK-enhanced Software is a **new card instance** with its own **unused per-copy once-per-turn activation allowance**, even if the original Software card already activated that ability earlier in the same turn. The temporary copy inherits the card's PATCHWORK-modified ability but **does not inherit the original instance's activation history**. Explicit **global limits across all copies remain shared** and are not reset by copying.

**Canonical example:** Original PATCHWORK-enhanced Software grants **5 PULP prevention once per turn** when the Rustler shuffles the draw pile. The original activates once. Later in the same turn, an effect creates a new temporary full-card copy. On a further qualifying shuffle, the new eligible temporary copy **may activate for 5 PULP prevention**; the original may not activate again. If the printed ability instead states “once per turn, across all copies,” the already-consumed global allowance prevents the new copy from activating.

**Compatibility:** Full-card copies inherit PATCHWORK enhancements (RULE-067); PATCHWORK enhancements inherit original restrictions (RULE-062); new copies are distinct instances for per-copy limits (RULE-021), but global limits persist across copies and installations (RULE-058–060). Temporary removal and return of the *same* instance does not refresh its allowance (RULE-066).


## 135. RULE-069 — Copied triggered abilities include PATCHWORK modifications (LOCKED, 2026-11-10)

**Explicit user approval:** An effect that says **“Copy the triggered ability of one installed Software card. Resolve the copied ability”** copies the **currently PATCHWORK-modified ability**, not merely the unmodified printed ability. Resolving the copied ability does **not create another Software card**, does **not consume an additional activation of the original ability**, and does **not reset the original card's activation allowance**. The copy effect resolves that copied ability **once** as instructed.

**Canonical example:** An installed Software card's triggered ability normally grants **2 PULP prevention**; PATCHWORK augments that ability to **5 PULP prevention**. An effect copies and resolves that triggered ability. The copied resolution grants **5 PULP prevention**. The original card's activation history is unchanged by the copy effect.

**Distinction:** Copying an **ability** does not create a new card instance or fresh per-copy allowance. Copying an **entire card** creates a new instance with inherited PATCHWORK and its own per-copy allowance (RULE-067/068). PATCHWORK remains an extension of the original ability (revised RULE-062).

**Scope note:** This rule addresses an effect explicitly instructing a copied ability to resolve; it does not establish that copying an ability grants permission to repeatedly activate the original restricted trigger.


## 136. RULE-070 — Explicit copied-ability resolution works after original limit consumed (LOCKED, 2026-11-10)

**Explicit user approval:** An effect that explicitly instructs the Rustler to **copy a triggered ability of an installed Software card and resolve the copied ability** may do so **even when the original card's once-per-turn activation allowance has already been consumed**. The copied resolution uses the **PATCHWORK-enhanced ability** (RULE-069). It is a resolution directed by the copy effect, **not another activation of the original trigger**; the original allowance remains consumed and is not reset.

**Canonical example:** Installed Software has a PATCHWORK-enhanced ability: “Once per turn, whenever you shuffle your draw pile, gain **5 PULP prevention**.” The original ability has already activated this turn. The Rustler plays an effect: “Copy the triggered ability of one installed Software card. Resolve the copied ability.” That copied resolution still grants **5 PULP prevention**, and the original card cannot activate its own once-per-turn ability again until its normal reset.

**Scope:** This permission requires an effect that **explicitly copies and resolves** the ability. Merely creating another qualifying trigger event does not bypass original limits. Copying an ability does not create a new Software card or fresh card-instance allowance (RULE-069), and PATCHWORK otherwise inherits restrictions of the original ability (RULE-062).


## 137. RULE-071 — Copied abilities retain costs (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect explicitly **copies and resolves an installed Software card's triggered ability**, the copied ability retains **all costs required for its benefit**, including costs in its PATCHWORK-enhanced version. The Rustler must pay such costs in full for the copied resolution to grant the associated benefit. If the cost cannot be paid, the associated benefit is not granted. Copying the ability does not waive costs or consume an additional activation of the original ability.

**Canonical example:** PATCHWORK-enhanced Software reads: “Once per turn, when you shuffle your draw pile, you may **discard 1 card** to gain **5 PULP prevention**.” Another card says: “Copy the triggered ability of one installed Software card. Resolve the copied ability.” The Rustler must discard **1 card** to gain **5 PULP prevention** from the copy. If unable or unwilling to pay that cost, the copied resolution grants **no PULP prevention**. The original card's activation allowance is unchanged by the copied resolution.

**Compatibility:** Costs must be fully paid (RULE-003); copied triggered abilities include PATCHWORK enhancements (RULE-069); explicit copied resolutions are permitted even when the original activation allowance is consumed (RULE-070). The copied effect follows its own text without treating the original ability as activated again.


## 138. RULE-072 — Copied abilities resolve complete instructions in original order (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect **copies and resolves a Software triggered ability**, it copies **all instructions of the complete PATCHWORK-enhanced ability** and executes them **in their original printed/modified order**, using the **current game state** at resolution. It does **not** copy only the numerical result of a prior activation.

**Canonical example:** An installed Software ability enhanced through PATCHWORK reads: “When you shuffle your draw pile, **gain 3 PULP prevention. Then double your PULP prevention**.” If the Rustler has **5 PULP prevention** when the copied ability resolves, it first gains 3 (**5 → 8**) and then doubles the current pool (**8 → 16**), ending at **16 PULP prevention**.

**Compatibility:** Instructions resolve in order (RULE-010); copied abilities include PATCHWORK modifications (RULE-069), can resolve when original activation limits are consumed if explicitly directed (RULE-070), and retain costs where applicable (RULE-071). Trigger queue handling remains governed by RULE-014/015.


## 139. RULE-073 — Copied abilities finish before generated triggers resolve (LOCKED, 2026-11-10)

**Explicit user approval:** An effect that **copies and resolves a Software ability** must complete **all instructions of that copied ability** before any triggers generated by those instructions resolve. Generated triggers enter the existing queue and are processed afterward under normal ordering rules; they cannot interrupt the copied ability mid-resolution.

**Canonical example:** The Rustler has installed Software reading “Whenever you gain PULP prevention, gain 1 BW.” A copied PATCHWORK-enhanced ability reads “Gain 3 PULP prevention. Then double your PULP prevention.” The Rustler gains 3 prevention (queuing a BW trigger), then doubles the current prevention (queuing another BW trigger **if the doubling increases prevention and qualifies as a separate gain event**). Only after the copied ability fully finishes do the queued triggers resolve in FIFO order, granting **2 BW** if both events qualified.

**Compatibility:** Chained triggers wait until the current effect completes (RULE-014); queued triggers follow FIFO (RULE-015); copied abilities reproduce full ordered instructions (RULE-072). This rule does not itself establish that every numerical modification is a “gain” event; trigger qualification follows the relevant effect wording and event semantics.


## 140. RULE-074 — Doubling prevention counts as gaining prevention (LOCKED, 2026-11-10)

**Explicit user approval:** When an effect **doubles a prevention pool**, any **positive increase** in that pool counts as **gaining prevention** of that type and therefore qualifies for effects triggered by gaining prevention. A **single doubling instruction** produces **one prevention-gain event** if it increases any prevention, even when it doubles several pools simultaneously. The amounts gained in each affected pool are their respective post-doubling minus pre-doubling differences. See RULE-075. Doubling a zero pool generates **no prevention-gain event**.

**Canonical example:** Rustler has **5 PULP prevention** and installed Software: “Whenever you gain PULP prevention, gain 1 BW.” Rustler plays “Double your PULP prevention.” PULP prevention increases **5 → 10**, so the Rustler **gains 5 PULP prevention** and queues **one** +1 BW trigger. That trigger resolves after the doubling effect finishes under RULE-014/015.

**Other prevention types:** The same principle applies to **SYN** and **CORTEX** prevention when doubled, subject to the wording of the triggered ability and the actual pool increased. Doubling all three pools in **one instruction** is still **one gain event**, not three (RULE-075).

**Compatibility:** Prevention multipliers compound and apply as snapshot effects (RULE-008/009); triggers generated during effect resolution queue until the effect completes (RULE-014/015); copied abilities obey the same rule (RULE-073).


## 141. RULE-075 — A single multi-pool prevention doubling is one gain event (LOCKED, 2026-11-10)

**Explicit user correction:** “Double all your prevention” is a **singular event**. Even if it increases **PULP, SYN and CORTEX prevention simultaneously**, an installed ability reading “Whenever you gain prevention, gain 1 BW” triggers **once**, not once per prevention pool. Count the **single resolving gain-producing instruction/event**, not the number of prevention types affected, for an unrestricted “gain prevention” trigger.

**Canonical example:** Rustler has **5 PULP, 3 SYN, 2 CORTEX prevention** and plays “Double all your prevention.” The pools become **10 PULP, 6 SYN, 4 CORTEX**. Software reading “Whenever you gain prevention, gain 1 BW” generates **one trigger**, granting **1 BW total**, not 3 BW.

**Type-specific triggers:** The event may involve multiple prevention types, so a distinct “Whenever you gain PULP prevention” ability and a distinct “Whenever you gain SYN prevention” ability can each recognize the same event if their conditions are met; however, the **same** generic ability does not trigger multiple times simply because multiple pools increased.

**Compatibility / clarification of RULE-074:** Doubling counts as gaining prevention if it increases prevention, but a **single multi-pool doubling instruction** generates **one gain event**, not a separate event for each affected pool. Independent sequential gain-producing instructions may produce separate events, subject to their text and ordinary trigger rules.


## 142. RULE-076 — Separate gain instructions generate separate prevention-gain events (LOCKED, 2026-11-10)

**Explicit user approval:** When a card or ability contains **multiple distinct instructions** that grant prevention, **each qualifying instruction generates a separate prevention-gain event**, even when the instructions are printed on the same card. A generic ability reading “Whenever you gain prevention, gain 1 BW” can therefore trigger once for each distinct gain instruction. Triggered effects are queued until the current card/ability finishes resolving.

**Canonical example:** An Instant Software card reads “Gain 3 PULP prevention. Gain 2 SYN prevention.” Another installed Software reads “Whenever you gain prevention, gain 1 BW.” The first instruction gains **3 PULP prevention** and queues one +1 BW trigger. The second instruction gains **2 SYN prevention** and queues a second +1 BW trigger. After the card finishes resolving, both triggers resolve in FIFO order, granting **2 BW total**.

**Distinction:** One instruction that simultaneously doubles or increases several prevention pools generates **one** gain event (RULE-075); **two separate gain instructions** generate **two** events. Printed order and trigger queue rules remain RULE-010/014/015. No event is generated by an instruction that causes no positive prevention gain.


## 143. RULE-077 — One instruction granting multiple prevention types creates one gain event (LOCKED, 2026-11-10)

**Explicit user approval:** A **single instruction** that grants multiple prevention types **simultaneously** produces **one prevention-gain event**, not a separate event per affected pool. A generic trigger such as “Whenever you gain prevention, gain 1 BW” activates **once** for that instruction if it produces any positive prevention gain.

**Canonical example:** A Software card reads “Gain **3 PULP prevention and 2 SYN prevention**.” Another installed Software reads “Whenever you gain prevention, gain 1 BW.” The instruction increases both PULP and SYN pools, but generates **one** qualifying gain event and therefore **one +1 BW trigger**, resolved after the current card/ability completes.

**Distinction:** One multi-pool instruction produces one event (RULE-075), whereas separate instructions “Gain 3 PULP prevention. Gain 2 SYN prevention.” produce two events (RULE-076). Different type-specific abilities can each recognize the same event if their respective type was gained; the same generic trigger does not multiply by the number of pools affected. Instructions that increase no prevention generate no gain event.


## 144. RULE-078 — One gain event can trigger multiple type-specific abilities (LOCKED, 2026-11-10)

**Explicit user approval:** A **single prevention-gain event** that increases multiple prevention types may satisfy **multiple distinct triggered abilities**, each of which triggers **once** if its own condition is met. This does not split the original gain instruction into multiple events. When the qualifying abilities are Rustler-controlled and trigger simultaneously, the **Rustler chooses their resolution order**. The originating card/ability completes before those queued triggers resolve.

**Canonical example:** Installed Software A reads “Whenever you gain PULP prevention, gain 1 BW.” Installed Software B reads “Whenever you gain SYN prevention, draw 1 card.” The Rustler plays “Gain 3 PULP prevention and 2 SYN prevention.” This **single instruction** produces **one gain event** (RULE-077) that satisfies both conditions. Software A queues **+1 BW** and Software B queues **draw 1 card**, each **once**. The Rustler chooses their order, and both resolve after the originating card finishes.

**Compatibility:** Multiple distinct triggered abilities may respond to the same event (RULE-055); Rustler orders simultaneous Rustler-controlled triggers (RULE-011); queued triggers wait until the current effect completes and follow established queue ordering (RULE-014/015); one multi-type prevention instruction is one event (RULE-077).


## 145. RULE-079 — Prevention gained from triggered abilities can generate further triggers (LOCKED, 2026-11-10)

**Explicit user approval:** Prevention granted by a **triggered ability** counts as a new prevention-gain event, just like prevention granted by a played card or other effect. It can trigger further eligible abilities, producing **chained triggers**. Each resolving ability completes before its generated triggers resolve; newly generated triggers enter the existing **FIFO queue**. Genuinely infinite cycles are handled by existing loop detection and termination rules, without capping legitimate finite chains.

**Canonical example:** Installed Software A reads “Whenever you gain PULP prevention, gain 2 SYN prevention.” Installed Software B reads “Whenever you gain SYN prevention, gain 1 BW.” Rustler plays “Gain 3 PULP prevention.” The 3 PULP gain queues A. A resolves, granting 2 SYN prevention and queuing B. B subsequently resolves, granting 1 BW. Final gains: **3 PULP prevention, 2 SYN prevention, 1 BW**, assuming no other effects.

**Compatibility:** Triggered abilities resolve completely before their generated triggers (RULE-014); queue order is FIFO (RULE-015); infinite-loop safeguards follow RULE-016–019; gain-event granularity follows RULE-074–078.


## 146. RULE-080 — Previously queued triggers resolve before newly generated chained triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When multiple triggers are already waiting in the **FIFO queue**, a resolving ability's newly generated trigger is appended **behind all triggers already queued**. It cannot jump ahead of a previously queued trigger. For simultaneous Rustler-controlled triggers, the Rustler chooses their initial ordering; that choice determines their order in the queue.

**Canonical example:** Software A: “Whenever you gain PULP prevention, gain 2 SYN prevention.” Software B: “Whenever you gain PULP prevention, gain 1 BW.” Software C: “Whenever you gain SYN prevention, draw 1 card.” Gaining **3 PULP prevention** triggers A and B simultaneously. The Rustler chooses **A before B**. A resolves and gains **2 SYN prevention**, queuing C **after** B. The resulting resolution order is **A → B → C**, granting 2 SYN prevention, then 1 BW, then drawing 1 card. **A → C → B is not permitted** because B was already queued.

**Compatibility:** Confirms FIFO queue semantics (RULE-015), simultaneous Rustler trigger ordering (RULE-011), and chained triggers from prevention gains (RULE-079). Each ability resolves completely before the next queued trigger (RULE-014).


## 147. RULE-081 — Removing Software cancels its unresolved queued triggers (LOCKED, 2026-11-10)

**Explicit user rejection of the alternative:** A triggered ability queued by **installed Software** does **not** survive removal of its source from play. If that Software is no longer installed **when its pending trigger would resolve**, the queued trigger is **cancelled** rather than resolving. The source must remain in play for its queued ability to resolve, **unless explicit card text provides an exception**.

**Canonical example:** Software A reads “Whenever you gain PULP prevention, gain 2 SYN prevention.” Software B reads “Whenever you gain PULP prevention, gain 1 BW.” Both trigger on a PULP prevention gain; Rustler queues A before B. During A's resolution, another effect removes Software B from play. When B's queued trigger reaches the front of the FIFO queue, **cancel B's trigger**; it grants **no BW**.

**Compatibility:** Triggers otherwise resolve FIFO (RULE-015/080). This cancellation applies to **unresolved** triggers from Software no longer installed, not to benefits already resolved. Treatment of a removed card that returns before its queued trigger would resolve is a separate open edge case.


## 148. RULE-082 — Leaving play immediately invalidates unresolved Software triggers (LOCKED, 2026-11-10)

**Explicit user approval:** When an installed Software card **leaves play**, **all of its unresolved queued triggered abilities are immediately cancelled**. Returning or reinstalling **that same card instance** before the cancelled trigger's former queue position would be processed **does not restore or revive** the cancelled trigger. Reinstallation may permit **new qualifying triggers** while the Software is eligible, but does not undo the cancellation.

**Canonical example:** Software B has a pending triggered ability in the FIFO queue. B is removed from play, immediately cancelling its pending trigger. Another effect reinstalls the **same B card** before the queue reaches that position. The old trigger remains **cancelled** and grants no benefit; B may generate new triggers only on subsequent qualifying events, subject to applicable activation limits.

**Compatibility:** Extends source-removal cancellation (RULE-081), preserves FIFO processing of surviving triggers (RULE-015/080), and does not reset consumed activation allowances through temporary removal/reinstallation (RULE-066). Already resolved effects remain intact.


## 149. RULE-083 — An ability already resolving completes after its source leaves play (LOCKED, 2026-11-10)

**Explicit user approval:** When a Software triggered ability has **already begun resolving**, removing its source Software card from play **does not interrupt or cancel the remaining instructions of that currently resolving ability**. Resolve its full instructions in order, subject to their normal conditions and costs. This differs from unresolved queued triggers, which are immediately cancelled when their source leaves play (RULE-081/082).

**Canonical example:** Software A's triggered ability reads “Gain 3 PULP prevention. Then gain 2 SYN prevention.” The ability begins resolving and grants **3 PULP prevention**. Another effect removes Software A from play before the second instruction. The currently resolving ability still completes, granting **2 SYN prevention**. Any **other unresolved queued triggers** from A are cancelled on removal.

**Compatibility:** Current effects resolve to completion (RULE-010/014); unresolved triggers are cancelled upon source leaving play (RULE-081/082). This rule does not exempt the remaining instructions from explicit conditions or costs.


## 150. RULE-084 — In-progress abilities can generate valid triggers after source removal (LOCKED, 2026-11-10)

**Explicit user approval:** When a Software ability has **already begun resolving** and its source Software card subsequently leaves play, the ability continues under RULE-083. Any **valid game events generated by its remaining instructions** can still trigger **other eligible installed Software**, even though the original ability's source is no longer installed. Removing the source cancels its **other unresolved queued triggers** (RULE-081/082), not the already resolving ability or the validity of events it creates.

**Canonical example:** Software A's ability reads “Gain 3 PULP prevention. Then gain 2 SYN prevention.” Software B, still installed, reads “Whenever you gain SYN prevention, gain 1 BW.” A begins resolving and grants **3 PULP prevention**. A is removed from play. A's current ability continues, granting **2 SYN prevention**. This valid SYN gain triggers B; B's queued trigger resolves after the current ability finishes and grants **1 BW**, assuming B remains eligible.

**Compatibility:** In-progress abilities finish after source removal (RULE-083); other pending triggers from removed Software are cancelled (RULE-081/082); valid prevention-gain events trigger eligible abilities (RULE-078/079); generated triggers queue until current resolution completes (RULE-014/015).


## 151. RULE-085 — Pending triggers require source Software to remain installed until resolution begins (LOCKED, 2026-11-11)

**Explicit user approval:** A valid trigger generated by installed Software remains **pending** until its queued ability **begins resolving**. If its source Software leaves play **before resolution begins**, the pending trigger is **cancelled immediately**, even though the event that originally generated it was valid. No benefit from that cancelled trigger is granted.

**Canonical example:** Software A reads “Whenever you gain PULP prevention, gain 2 SYN prevention.” The Rustler gains PULP prevention and A's trigger enters the queue. Another effect removes A before its trigger begins resolving. **Cancel A's queued trigger; do not grant 2 SYN prevention.**

**Resolution boundary:** A pending queued trigger is cancelled when its source leaves play (RULE-081/082); an ability that **has already begun resolving** continues to completion after source removal (RULE-083), and events it subsequently produces may still trigger other eligible Software (RULE-084). Reinstalling the source does not revive cancelled triggers (RULE-082).


## 152. RULE-086 — Drawing continues after resolving Software source is removed (LOCKED, 2026-11-11)

**Explicit user approval:** Once an installed Software ability has **begun resolving**, removal of its source Software during that resolution **does not interrupt any remaining draw instruction**. The ability finishes normally under the established card-draw rules, including automatic reshuffling and drawing as many cards as possible when insufficient cards are available.

**Canonical example:** Software A's ability reads “Gain 3 PULP prevention. Then draw 2 cards.” After granting **3 PULP prevention**, A is removed from play. Its already resolving ability **still draws 2 cards**, assuming at least 2 cards are available through draw/discard piles; if fewer are available, draw as many as possible under RULE-034/037.

**Compatibility:** Confirms that the in-progress resolution protection of RULE-083 applies to **all remaining instructions**, not only prevention gains. Pending, not-yet-resolving triggers from removed Software are still cancelled (RULE-081/082/085). Draw-generated triggers queue until the current effect completes (RULE-033/039).


## 153. RULE-087 — Conditional rewards remain valid after source removal during resolution (LOCKED, 2026-11-11)

**Explicit user approval:** If an installed Software ability has **already begun resolving**, removing the source Software card during that resolution **does not invalidate a conditional reward** whose requirement is successfully fulfilled. The remaining instructions continue normally and the condition is evaluated based on what actually happened, not on whether the source is still installed.

**Canonical example:** Software A reads “Draw 2 cards. If you do, gain 5 PULP prevention.” During the draw, another effect removes A from play. If **both cards are actually drawn**, the “If you do” requirement is satisfied and the Rustler **gains 5 PULP prevention**. If fewer than two cards are drawn, the conditional reward **does not occur**, regardless of source removal.

**Compatibility:** Conditional draws require full completion (RULE-038); draw-triggered effects wait until the card ability finishes (RULE-033/039); already resolving abilities continue after source removal (RULE-083/086). Other pending triggers from removed Software remain cancelled (RULE-081/082/085).


## 154. RULE-088 — Explicit installed-source conditions override continued resolution (LOCKED, 2026-11-11)

**Explicit user approval:** An installed Software ability that has **already begun resolving** normally continues after its source leaves play (RULE-083), but **explicit conditions requiring that Software to remain installed** must still be satisfied at the point the condition is checked. Continuing resolution does **not** waive or override an expressly stated installed-source requirement.

**Canonical example:** Software A reads “Draw 2 cards. If this Software is still installed, gain 5 PULP prevention.” The ability begins resolving, but A is removed during the draw. The Rustler **still completes the draw of 2 cards** (assuming cards are available). At the conditional instruction, A is **not installed**, so the Rustler gains **0 PULP prevention**. The fact that both cards were drawn does not satisfy the distinct explicit installation condition.

**Compatibility:** Already resolving abilities finish after source removal (RULE-083/086); successfully completed conditional draws remain valid when their conditions are met (RULE-087); however, explicit conditions are independently enforced (RULE-003/038). Pending queued abilities from removed Software are cancelled (RULE-081/082/085).


## 155. RULE-089 — Reinstalled Software is a new installed instance for source-specific conditions (LOCKED, 2026-11-11)

**Explicit user decision:** **No**—removing Software A and then reinstalling it means it is considered a **new installation/card instance**, not the still-installed source of the old ability. Reinstallation cannot retroactively satisfy an explicit condition referring to the original source instance.

**Canonical example:** Software A reads “Draw 2 cards. If this Software is still installed, gain 5 PULP prevention.” A's ability begins resolving; during the draw, A is removed and then reinstalled before the condition is checked. The already-started ability completes its draw under RULE-083/086, but the original installed instance has left play. The newly installed instance does **not** count as “this Software” still being installed for that original ability. **No 5 PULP prevention is granted.**

**Identity clarification:** Reinstallation creates a new **installed instance**, not a new physical card or card copy. It does not restore cancelled pending triggers (RULE-082), reset consumed global limits (RULE-059/060/065), or contradict the rule that temporarily removing/reinstalling the same Software card does not reset consumed activation limits (RULE-066). The current-resolution protection (RULE-083) does not preserve source identity for explicit installation conditions (RULE-088).


## 156. RULE-090 — Continuous Software effects belong to their installed instance (LOCKED, 2026-11-11)

**Explicit user approval:** A continuous Software effect that applies **while its source Software is installed** belongs to that particular **installed instance**. When that instance leaves play, its continuous effect **ends immediately**. Reinstalling the same physical card creates a **new installed instance** that establishes its own continuous effect, rather than reviving or stacking the original effect.

**Canonical example:** Software A reads “While this Software is installed, gain +2 DRAW.” Removing A ends the original installed instance's **+2 DRAW** immediately. Reinstalling A establishes a new **+2 DRAW** effect. The two instances' effects do not overlap or stack: **+2 DRAW, not +4 DRAW**.

**Compatibility:** Reinstallation is a new installed instance (RULE-089), but does not create a second physical card, restore cancelled pending triggers (RULE-082), or reset activation limits protected by RULE-066 and global-limit rules. Distinguish continuous effects, which require an installed source, from discrete abilities that have already begun resolving and therefore finish under RULE-083.


## 157. RULE-091 — Continuous effects stack across separate installed Software copies (LOCKED, 2026-11-11)

**Explicit user approval:** Multiple **separately installed Software instances** each contribute their own continuous effects. Identical continuous bonuses **stack additively by default**, unless card text or another explicit restriction states otherwise.

**Canonical example:** Two distinct installed copies of Software A each read “While this Software is installed, gain +2 DRAW.” Both apply simultaneously, granting **+4 DRAW total**. If one instance leaves play, its contribution ends immediately under RULE-090, leaving **+2 DRAW** from the remaining instance.

**Compatibility:** Each installed instance independently maintains its continuous effects (RULE-090). Reinstalling a removed physical card does not preserve the old installed instance or double-count its bonus (RULE-089/090). This stacking rule does not override explicit non-stacking or global restrictions.


## 158. RULE-092 — Explicit non-stacking text overrides default continuous-effect stacking (LOCKED, 2026-11-11)

**Explicit user approval:** Continuous effects from separately installed Software instances normally stack (RULE-091), but **explicit non-stacking restrictions on a card override that default**. Multiple copies of the same Software with an expressly non-stacking continuous bonus do not add their bonuses together.

**Canonical example:** Two installed copies of Software A each read “While this Software is installed, gain +2 DRAW. This effect does not stack with other copies of this Software.” Together they grant **+2 DRAW total**, **not +4 DRAW**, regardless of the number of such installed copies. If one copy leaves play, the other still grants **+2 DRAW**.

**Compatibility:** Each installed instance maintains its own continuous effect while present (RULE-090), but contributions are combined subject to explicit restrictions (RULE-091). Removal of an instance ends its effect; no departed-instance bonus persists.


## 159. RULE-093 — PATCHWORK-enhanced continuous bonuses stack unless explicitly restricted (LOCKED, 2026-11-11)

**Explicit user correction:** Different PATCHWORK enhancements do **not** inherently impose any non-stacking restriction. Continuous bonuses from separately installed Software copies **add together**, including when their PATCHWORK modifications give different numerical strengths, unless the actual card text expressly prohibits stacking.

**Canonical example:** Installed Software Copy A grants **+2 DRAW**, while separately installed PATCHWORK-enhanced Copy B grants **+4 DRAW**. With **no explicit non-stacking restriction on either copy**, the Rustler receives **+6 DRAW total**, not +4. Do not infer a non-stacking clause from a hypothetical example or from the fact that the cards are copies of the same Software.

**Compatibility:** Default additive stacking across installed instances (RULE-091) remains in force. RULE-092 applies **only when an explicit non-stacking restriction is present** in the relevant card text. Each instance's contribution ends when it leaves play (RULE-090).


## 160. RULE-094 — Strongest bonus applies among explicitly non-stacking continuous effects (LOCKED, 2026-11-11)

**Explicit user clarification:** When separately installed Software copies have **explicit non-stacking restrictions** and different continuous bonus strengths, apply the **strongest eligible bonus only**, rather than adding them or choosing the weaker bonus.

**Canonical example:** Installed Copy A grants **+2 DRAW**, while PATCHWORK-enhanced installed Copy B grants **+4 DRAW**. **If these effects explicitly do not stack**, the Rustler receives **+4 DRAW total**, not +6. The non-stacking clause is essential to this result.

**Distinction:** When there is **no explicit non-stacking restriction**, the same +2 and +4 contributions **do stack to +6 DRAW** under RULE-091/093. RULE-092 governs whether a non-stacking restriction applies at all; this rule determines the value when it does.


## 161. RULE-095 — Removing strongest non-stacking Software recalculates remaining bonus (LOCKED, 2026-11-11)

**Explicit user approval:** When multiple installed Software copies grant continuous bonuses that **explicitly do not stack**, the strongest eligible bonus applies (RULE-094). If the source of that strongest bonus leaves play, its continuous contribution ends immediately and the effective bonus is **recalculated from the remaining eligible installed instances**. The remaining Software's continuous effect is already active; it need not trigger or activate again.

**Canonical example:** Installed Copy A grants **+2 DRAW**, while PATCHWORK-enhanced Copy B grants **+4 DRAW**, and both effects explicitly prohibit stacking. With both installed, the Rustler has **+4 DRAW**. When Copy B leaves play, its bonus ends and the Rustler immediately has **+2 DRAW** from Copy A.

**Compatibility:** Installed-instance continuous effects end on removal (RULE-090); explicit non-stacking overrides default additive stacking (RULE-092); strongest eligible non-stacking bonus applies (RULE-094). Without explicit non-stacking text, additive stacking still applies (RULE-091/093).


## 162. RULE-096 — DRAW changes do not retroactively affect cards already drawn (LOCKED, 2026-11-11)

**Explicit user approval:** Changes to the Rustler's current DRAW value, including changes caused by removing installed Software that grants a continuous DRAW bonus, affect **future draw calculations only**. They do **not** retroactively undo completed draws, discard cards already drawn, or otherwise reduce the Rustler's current hand merely because DRAW has decreased.

**Canonical example:** Base DRAW is **5**. Two installed Software copies grant explicitly non-stacking continuous bonuses: Copy A **+2 DRAW** and PATCHWORK-enhanced Copy B **+4 DRAW**. The stronger bonus applies, giving **DRAW 9**, and the Rustler draws **9 cards** at the start of the turn. Later in that turn, Copy B leaves play. The effective DRAW value becomes **7** (base 5 + remaining bonus 2), but the Rustler **keeps all 9 cards already drawn**. DRAW 7 applies to later calculations that reference DRAW, not to the completed draw.

**Compatibility:** Explicitly non-stacking effects use the strongest eligible bonus (RULE-094); removing that source recalculates the active bonus (RULE-095); completed draws are not reversed. This rule does not itself grant an additional draw when DRAW increases mid-turn.


## 163. RULE-097 — Mid-turn DRAW increases do not draw extra cards (LOCKED, 2026-11-11)

**Explicit user approval — Option A:** An increase to the Rustler's effective DRAW during a turn does **not** immediately draw additional cards. The increased DRAW applies to **future applicable draw calculations** only; a completed draw is not retroactively topped up.

**Canonical example:** Rustler starts the turn at DRAW 5 and draws 5 cards. Mid-turn, installed Software grants +3 DRAW, increasing effective DRAW to 8. **No 3-card immediate draw occurs.** DRAW 8 applies to the next applicable draw calculation that references DRAW.

**Compatibility:** Complements RULE-096: neither increases nor decreases in DRAW retroactively alter completed draws. Explicit instructions to draw cards remain governed by their own wording. No new normal draw timing is established.


## 164. RULE-098 — Snapshot DRAW when a draw instruction begins resolving (LOCKED, 2026-11-11)

**Explicit user approval — Option A:** When an ability instructs the Rustler to draw cards equal to their **DRAW**, determine the number of cards from the effective DRAW value **when that draw instruction begins resolving**. Changes to DRAW during the instruction do **not** increase or decrease the number of cards instructed to be drawn. Later applicable draw calculations use the then-current DRAW value.

**Canonical example:** The Rustler has DRAW 5. Software instructs “Draw cards equal to your DRAW.” The instruction begins with a target of **5 cards**. After 2 cards have been drawn, another effect raises effective DRAW to 8. The original instruction still draws **5 cards total**, not 8, subject to existing rules for drawing as many as possible if the deck cannot supply enough cards.

**Compatibility:** RULE-096/097 prevent retroactive changes to completed draws; RULE-098 fixes the quantity for a draw instruction already underway. Existing draw-trigger timing and draw-shortfall rules remain unchanged. This does not specify how other variable numerical effects snapshot their values.


## 165. RULE-099 — Each distinct DRAW-based draw instruction recalculates DRAW (LOCKED, 2026-11-11)

**Explicit user approval — Option A:** Within a single resolving ability, **each separate instruction** to draw cards equal to DRAW uses the Rustler's effective **DRAW when that particular instruction begins**. The DRAW value is not snapshotted once for the entire ability. Once an individual instruction begins, its target number remains fixed during that instruction under RULE-098.

**Canonical example:** Software ability reads “Draw cards equal to your DRAW. Gain +2 DRAW. Then draw cards equal to your DRAW again.” Starting at DRAW 5, the first instruction draws **5 cards**. The intervening bonus increases effective DRAW to **7**. The second, distinct draw instruction then draws **7 cards**, subject to existing draw-shortfall rules.

**Compatibility:** RULE-098 snapshots each individual draw instruction at its start; RULE-096/097 bar retroactive hand changes or automatic extra draws. Draw-trigger timing and the resolution of other effects remain governed by their existing locked rules. This rule does not imply that a single instruction recalculates its target between cards.


## 166. RULE-100 — Queued DRAW-based abilities use DRAW at instruction resolution (REVISED AND LOCKED, 2026-11-11)

**Explicit user-directed revision (supersedes original Option B):** A queued triggered ability that instructs “Draw cards equal to your DRAW” does **not** snapshot DRAW when it enters the FIFO trigger queue. Determine the card count from the effective DRAW **when that individual draw instruction begins resolving**, as established by RULE-098. Changes to DRAW while the ability waits in the queue therefore affect the card count.

**Canonical example:** Effective DRAW is **5** when the triggered ability enters the queue. Before it resolves, another effect grants **+3 DRAW**, raising DRAW to **8**. When the queued draw instruction begins resolving, it draws **8 cards**, subject to existing draw-shortfall rules. Later changes during that same instruction do not alter its fixed target (RULE-098).

**Compatibility:** RULE-100 now explicitly aligns with RULE-098; it creates **no queue-time exception**. Under RULE-099, separate DRAW-based instructions within the same ability each calculate DRAW when their own instruction begins. FIFO trigger order, source-removal cancellation, and existing trigger timing remain unchanged.

**Revision history:** RULE-100 was originally approved as Option B (snapshot at queue time) and committed in `17b5c4917290061064b75774fee4dadbc323a0a6`. After reviewing its conflict with RULE-098, the user explicitly instructed: “Change rule 100 to align with rule 98. Then proceed.” This revised text supersedes the prior RULE-100 wording.


## 167. RULE-101 — Separate DRAW instructions in queued abilities each use current DRAW (LOCKED, 2026-11-11)

**Explicit user approval — Option A (after conflict review):** When a triggered ability has been queued and later resolves with multiple separate instructions to “Draw cards equal to your DRAW,” **each instruction independently determines its target from effective DRAW when that instruction begins**. The ability's queue-entry DRAW value and the value at the start of the overall ability do not lock the later instructions. Each individual instruction's target remains fixed while it resolves.

**Canonical example:** Ability text: “Draw cards equal to your DRAW. Gain +2 DRAW. Then draw cards equal to your DRAW again.” It enters the FIFO queue at DRAW **5**. Before resolution, DRAW rises to **8**. The first instruction draws **8**; the intervening +2 raises DRAW to **10**; the second instruction draws **10**, subject to existing draw-shortfall rules.

**Conflict check:** Consistent with RULE-098 (snapshot each instruction at its start), RULE-099 (separate instructions recalculate), and revised RULE-100 (no queue-time snapshot). **No existing locked rule is overridden.** Existing trigger ordering, source-removal cancellation, and draw-shortfall handling are unchanged.


## 168. RULE-102 — Snapshot variable numeric quantities per discrete instruction, with explicit protections (LOCKED, 2026-11-11)

**Explicit user approval — exception-protected Option A following conflict audit:** When a **discrete instruction** calculates an effect using a **variable numerical value**, determine that value **when the instruction begins resolving**. Keep the calculated quantity fixed for **that instruction**. Each later, separate instruction independently calculates its variable quantity using the game state when **that later instruction** begins resolving.

**Scope and precedence:** This general rule **does not freeze continuous effects**, override **explicit card or rule timing instructions**, bypass **costs or conditions**, or change **resource expenditure and consumption priorities**. More-specific locked rules and explicit applicable card text take precedence. In particular, continuous Software effects continue updating under RULE-090–095; costs and conditions remain governed by RULE-003/038/071; and eligible resource consumption continues under RULE-004–006. Existing trigger ordering and FIFO resolution are unchanged.

**Illustrative example (not a finalized card):** An ability reads “Gain PULP prevention equal to your current Trace. Reduce Trace by 2. Gain PULP prevention equal to your current Trace.” If Trace is 6 when the first instruction begins, the first gain is **6**; after Trace falls to 4, the second distinct gain is **4**, unless more-specific rules or card text direct otherwise. Changing Trace during an individual instruction does not retroactively change that instruction's already calculated amount.

**Conflict review:** Extends RULE-098–101's per-instruction snapshot model beyond DRAW while preserving RULE-010 (printed order), RULE-008/009 (sequential snapshot prevention multipliers), and RULE-072 (copied abilities use current state). **No override of the cited locked mechanics is authorized by this rule.** Future edge cases with more-specific instructions must be evaluated against those rules rather than silently generalized.


## 169. RULE-103 — One variable-value snapshot across per-object processing in a single instruction (LOCKED, 2026-11-11)

**Explicit user approval — Option A, after conflict check:** When **one discrete instruction** says to perform a variable-numeric calculation **for each** eligible object, snapshot the referenced variable numeric value **once, when that instruction begins resolving**, and use that same value for every object processed under that instruction. Do **not** recalculate the variable between objects merely because processing is sequential. A subsequent **separate instruction** takes its own snapshot under RULE-102.

**Illustrative example (not finalized card text):** “For each installed Software card, gain PULP prevention equal to your current Trace.” With three eligible Software cards and Trace **6** at instruction start, each per-card calculation uses **6**. If an otherwise legally permitted effect changes Trace to **4** during processing, the remaining calculations under this **same instruction** still use **6**. This example does **not** authorize ordinary queued triggers to interrupt the current instruction or ability; under RULE-014/015, such triggers wait until the current effect completes.

**Compatibility / conflict check:** Clarifies RULE-102's instruction-level snapshot; preserves RULE-010 printed order, RULE-014/015 uninterrupted effect resolution and FIFO queue, and RULE-098's fixed per-instruction draw target. It does **not** change event counting or trigger granularity for prevention gains under RULE-074–077, nor alter eligibility, costs, conditions, continuous-effect updates, or resource expenditure priority. **No existing locked rule is overridden.**


## 170. RULE-104 — Snapshot eligible objects for a single “for each” instruction, with eligibility protections (LOCKED, 2026-11-11)

**Explicit user approval — Option A with eligibility protections, following conflict review:** When a **discrete “for each” instruction** refers to eligible objects, determine its **processing set once, when the instruction begins resolving**. Process that fixed set: objects that become eligible later are **not added**, and objects originally included are **not automatically removed from the processing list** merely because their state changes during processing.

**Eligibility protections and precedence:** Membership in the initial processing set **does not establish or preserve eligibility for any separate explicit condition, cost, requirement to remain installed/in play, or source-dependent effect** checked later. Evaluate those requirements at their applicable times under existing rules. In particular, explicit installed-status conditions remain enforceable (RULE-088), continuous effects from departed installed instances end immediately (RULE-090), and source-removal/cancellation boundaries remain RULE-081–089. If a required action becomes impossible, apply existing partial-fulfillment and cost/condition rules (RULE-002/003); do not create benefits from ineligible or nonexistent sources. More-specific rules or card text take precedence.

**Illustrative example (not finalized card text):** “For each installed Software card, gain 2 PULP prevention.” If A, B, and C are installed when the instruction starts, the processing set is **{A, B, C}**. An ordinary triggered removal of C generated during resolution waits until the current ability completes (RULE-014/015), so all three contribute normally. If an otherwise legally permitted mid-instruction event removes C, C remains in the original processing list, **but** any explicitly required installed-status condition or source-dependent effect must still be satisfied when checked; this rule alone does not guarantee its benefit.

**Conflict check:** Compatible with RULE-010, RULE-014/015, RULE-083/088, RULE-090, and RULE-102/103. The fixed **object set** is distinct from RULE-103's fixed **numeric value**. Does not alter event counting, trigger timing, continuous-effect recalculation, or costs. **No existing locked rule is overridden.**


## 171. RULE-105 — Aggregate prevention-gain event for a single “for each” instruction (LOCKED, 2026-11-11)

**Explicit user approval — Option A, following conflict audit:** When a single discrete instruction grants prevention for each eligible object, the instruction produces **one aggregate prevention-gain event**, provided the total prevention gained is positive.

The number of objects processed does not multiply the number of events. Each eligible triggered ability responds at most once to that event, subject to its own frequency restrictions.

Multiple separately written prevention-gain instructions continue to produce separate events under RULE-076. Different triggered abilities may each respond to the same event under RULE-078.

Generated triggers wait until the originating ability finishes and resolve under the established FIFO queue.

**Illustrative application (not finalized card text):** “For each installed Software card, gain 2 PULP prevention.” With three eligible installed Software cards, gain **6 PULP prevention** and produce **one** prevention-gain event. An installed “Whenever you gain PULP prevention, gain 1 BW” ability triggers **once** and grants **1 BW** when it resolves, subject to its limits. Two separate qualifying “for each” instructions instead generate **two** events under RULE-076.

**Conflict check:** Consistent with RULE-074/075/077 (one qualifying gain-producing instruction/event), RULE-076 (distinct instructions are distinct events), RULE-078/055 (distinct abilities independently recognize one event), RULE-079 (chained prevention-gain triggers), and RULE-014/015 (deferred FIFO triggers). RULE-103/104 continue to govern the instruction's numerical snapshot and eligible-object set. **No existing locked rule is overridden.**


## 172. RULE-106 — General aggregate-event convention for “for each” instructions (LOCKED, 2026-11-11)

**Explicit user approval — exception-protected Option A following conflict audit:** When a single discrete “for each” instruction produces repeated changes of the same event type across eligible objects, treat those changes as **one aggregate event** for generic triggers, provided a qualifying change actually occurs.

The number of objects processed does not independently multiply generic trigger activations. Multiple separately written instructions remain separate event-producing instructions.

**Exceptions:** This rule does **not** combine events that existing locked rules explicitly count individually, including **actual card draws**, **individual would-be draw replacements**, and **actual reshuffles**. It does not override **damage-application mechanics**, **explicit per-object or per-occurrence trigger wording**, **costs**, **conditions**, or **more-specific card text**.

Distinct eligible triggered abilities may each respond **once** to the aggregate event, subject to their frequency restrictions. Generated triggers follow existing **FIFO timing**.

**Illustrative examples (not finalized card text):** “For each installed Software card, reduce Trace by 2” with three eligible cards reduces Trace by **6** (to the extent permitted by applicable rules) and produces **one** qualifying Trace-reduction event if Trace actually decreases. “For each installed Software card, gain 1 BW” with three eligible cards grants **3 BW** (subject to applicable restrictions) and produces **one** qualifying BW-gain event if BW actually increases. RULE-105 already establishes the analogous single prevention-gain event. In contrast, “Draw 3 cards” continues to produce **three individual actual draw events** when three cards are actually drawn (RULE-032/033); separate actual reshuffles remain distinct (RULE-036).

**Conflict check:** Compatible with RULE-014/015, RULE-054/055, RULE-074–079, and RULE-102–105. Explicitly preserves individual draw events (RULE-032/033), actual reshuffles (RULE-036), and per-would-be-draw replacement decisions (RULE-040–043). Damage-specific event and application boundaries remain governed by their more-specific rules; this rule does not resolve new damage edge cases. **No existing locked rule is overridden.**


## 173. RULE-107 — Aggregate events report actual total change (LOCKED, 2026-11-11)

**Explicit user approval — exception-protected Option A following conflict audit:** When an aggregate event is generated under RULE-105 or RULE-106, its reported numerical magnitude equals the **total actual qualifying change** produced by that instruction, **not** the nominal amount per object or the amount originally attempted.

If an instruction is only partially fulfilled, count only changes that actually occur. If **no qualifying change** occurs, **no corresponding change event** is generated.

An amount-dependent triggered ability uses the aggregate event's reported magnitude, subject to the ability's own conditions, costs, timing, and frequency restrictions.

This rule does **not** combine events that existing rules count individually, override **damage-application mechanics**, or alter explicit **per-object or per-occurrence effects**. More-specific locked rules and card text take precedence.

**Illustrative example (not finalized card text):** “For each of 3 installed Software cards, reduce Trace by 2.” If starting Trace is **4** and applicable rules prevent it falling below zero, the attempted reduction is **6**, but actual reduction is **4**; the instruction generates **one** Trace-reduction event reporting magnitude **4**. An eligible “Whenever you reduce Trace, gain BW equal to the amount of Trace reduced” trigger attempts to grant **4 BW**, subject to applicable restrictions. This example **does not establish** a new Trace floor, BW cap, or other previously unspecified resource limit.

**Conflict check:** Compatible with RULE-002/003 (partial fulfillment and costs), RULE-074/075 (actual prevention gain), RULE-076/077 (instruction boundaries), RULE-102/103 (numeric snapshots), RULE-104 (eligible-object set), RULE-105/106 (aggregate-event count), and RULE-014/015 (FIFO triggers). Individual draw/reshuffle/replacement events remain governed by RULE-032/033/036/040–043; damage mechanics and more-specific card text retain precedence. **No existing locked rule is overridden.**


## 174. RULE-109 — Threshold triggers evaluate completed aggregate-event magnitude (LOCKED, 2026-11-11)

**Explicit user approval — exception-protected Option A following conflict audit:** When a triggered ability requires an event to meet a numerical threshold, and that event is an aggregate event under RULE-105 or RULE-106, evaluate the threshold against the event's **total actual qualifying change**, as defined by RULE-107.

Do **not** evaluate the threshold separately against each per-object contribution unless more-specific card text explicitly requires that treatment.

An eligible triggered ability activates **at most once** for the qualifying aggregate event, subject to its own frequency restrictions.

Threshold qualification does **not interrupt** the resolving instruction or ability. Generated triggers wait until the originating ability completes and resolve according to established **FIFO** rules.

This rule does **not** override individual draw events, reshuffles, draw replacements, damage-application mechanics, explicit per-object triggers, costs, conditions, or more-specific locked rules.

**Illustrative example (not finalized card text):** “For each installed Software card, gain 2 PULP prevention.” With three eligible cards, the instruction actually gains **6 PULP prevention** and generates **one aggregate event**. An eligible “Whenever you gain at least 5 PULP prevention in a single event, gain 2 BW” ability qualifies **once**, granting **2 BW** when it resolves (subject to applicable restrictions). If the instruction actually gains only **4 PULP prevention**, the threshold is not met, regardless of any higher attempted amount.

**Conflict check:** Consistent with RULE-102/103 (numeric snapshots), RULE-104 (eligible-object set), RULE-105/106 (aggregate-event identity), RULE-107 (actual reported magnitude), RULE-014/015 (deferred FIFO timing), RULE-054/055/078 (independent triggered abilities), and RULE-020/026 (frequency limits). Specific draw, reshuffle, replacement, damage, cost and condition rules retain precedence. **No existing locked rule is overridden.**

**Open question preserved:** RULE-108 mixed-direction aggregate-event accounting remains **deferred and not locked**, pending a concrete PANOPTICON card or mechanic requiring it.


## 175. RULE-110 — Event-time trigger qualification; resolution-time variable calculations (LOCKED, 2026-11-11)

**Explicit user approval — exception-protected Option A following conflict audit:** When an event occurs, determine whether a triggered ability qualifies using the **event's properties** and the applicable trigger conditions **at that time**.

For aggregate events, the event's reported actual magnitude and threshold qualification are established under RULE-107/109. Later game-state changes do **not** retroactively alter that event or its qualification.

When the queued triggered ability begins resolving, calculate any **variable numerical quantity** referenced by each discrete instruction using the applicable game state **when that instruction begins resolving**, following RULE-102.

Do **not** snapshot variable reward quantities when the trigger enters the queue unless explicit card text or a more-specific locked rule requires it.

**Protections:** Qualifying does not guarantee resolution. Pending triggers from Software that leaves play are cancelled under RULE-081/082/085. Explicit costs, conditions, installed-status requirements, frequency limits, and more-specific card text remain enforceable. Already resolving abilities retain RULE-083's protections. An explicit condition such as “If your Trace is at least 5 when this ability resolves” is still evaluated at its stated resolution time; event-time qualification does not convert it into an event-time condition.

Triggered abilities continue to resolve under the established **FIFO queue**. This rule does **not** change event identity, event counting, or the existing individual-event exceptions.

**Illustrative example (not finalized card text):** Installed Software reads “Whenever you gain at least 5 PULP prevention in a single event, gain BW equal to your current Trace.” The Rustler gains **6 PULP prevention** while Trace is **8**: the event qualifies and the trigger is queued. Before the trigger resolves, another effect reduces Trace to **3**. If the trigger survives all applicable source and condition checks, its BW-gain instruction uses Trace **3** and attempts to grant **3 BW**, subject to applicable restrictions. The original event's +6 PULP magnitude and qualification remain unchanged.

**Conflict check:** Compatible with RULE-014/015 (FIFO timing), RULE-054/055 (independent triggers), RULE-081/082/085 (source-removal cancellation), RULE-083/088 (resolving abilities and explicit installed conditions), RULE-098–103 (instruction-time numerical snapshots), RULE-107/109 (aggregate event magnitude and thresholds), and RULE-020/026 (frequency limits). **No existing locked rule is overridden.** RULE-108 mixed-direction event accounting remains **deferred and unlocked**.


## 176. RULE-111 — Event-referenced rewards use the original event's recorded magnitude (LOCKED, 2026-11-11)

**Explicit user approval:** When a triggered ability's reward explicitly refers to **the amount gained in the event that triggered it**, use that event's **recorded actual magnitude**, even if the relevant current resource pool changes before the queued trigger resolves. The event's magnitude is established when the event occurs under RULE-107/109 and is not recalculated from the current pool. This is distinct from a reward expressly referring to a **current** game-state quantity, which is evaluated at instruction resolution under RULE-110.

**Canonical example:** Installed Software A reads “Whenever you gain at least 5 PULP prevention in a single event, gain BW equal to the amount of PULP prevention gained in that event.” The Rustler gains **6 PULP prevention**, qualifying the event and queuing A's trigger. Before that trigger resolves, the current PULP prevention pool falls to **2**. If the queued trigger remains eligible to resolve, its reward attempts to grant **6 BW** (subject to applicable BW restrictions), **not 2 BW**, because the instruction references the recorded original event's gain.

**Compatibility:** RULE-107 fixes the actual magnitude of an aggregate event; RULE-109 checks thresholds against that magnitude; RULE-110 fixes event-time qualification but evaluates current-state variables at instruction time. Explicit event-referenced quantities are event properties, not current-state variables. Source-removal cancellation (RULE-081/082/085), costs, conditions, frequency limits, and FIFO timing remain unchanged. This rule does not resolve deferred RULE-108.


## 177. RULE-112 — Calculated event-based rewards use the original recorded event magnitude (LOCKED, 2026-11-11)

**Explicit user approval:** When a triggered ability calculates a numerical reward from **the amount gained in its triggering event**, use the event's **original recorded actual gain**, even if the current resource pool has changed before the trigger resolves. Mathematical transformations of that event-referenced amount (including division and explicitly stated rounding) operate on the original event magnitude, not the remaining pool.

**Canonical example:** Software A reads “Whenever you gain PULP prevention, gain BW equal to half the PULP prevention gained in that event, rounded down.” The Rustler gains **7 PULP prevention** and A's trigger is queued. Before resolution, **5 PULP prevention** is lost, leaving **2**. If A's trigger remains eligible to resolve, it attempts to grant **floor(7 / 2) = 3 BW**, not floor(2 / 2) = 1 BW, subject to applicable BW restrictions.

**Compatibility:** Extends RULE-111's event-referenced quantities; preserves RULE-107's recorded actual magnitude, RULE-110's distinction between event properties and current-state variables, and existing source-removal cancellation, costs, conditions, and FIFO timing. No general rounding convention beyond the card's explicit “rounded down” text is established.


## 178. RULE-113 — Explicit reward maximum applies to original event-referenced magnitude (LOCKED, 2026-11-11)

**Explicit user approval:** When a triggered ability computes a reward using the **original recorded magnitude of the triggering event**, any **explicit maximum on that reward** is applied to the result. Changes to the current resource pool after the triggering event do not alter the recorded event magnitude or the reward calculation. This card-specific maximum does not establish a universal BW cap.

**Canonical example:** Installed Software A reads “Whenever you gain PULP prevention, gain BW equal to the amount gained in that event, to a maximum of 5 BW.” The Rustler gains **8 PULP prevention**, triggering A. Before A's queued trigger resolves, the Rustler's current PULP prevention pool falls to **3**. If the trigger remains eligible to resolve, the reward is **min(8, 5) = 5 BW**, subject to other applicable resource restrictions, **not 3 or 8 BW**.

**Compatibility:** RULE-111 preserves the triggering event's original actual magnitude for event-referenced rewards; RULE-112 applies arithmetic to that recorded magnitude; RULE-110 distinguishes event properties from current-state variables. Trigger eligibility, source-removal cancellation, conditions, costs and FIFO timing remain unchanged. RULE-108 remains deferred.


## 179. RULE-114 — Explicit reward minimum applies to original event-referenced magnitude (LOCKED, 2026-11-11)

**Explicit user approval:** When a triggered ability computes a reward using the **original recorded magnitude of the triggering event**, any **explicit minimum on that reward** applies after the event-referenced amount is determined. Subsequent changes to the current resource pool do not alter the triggering event's recorded magnitude or the resulting minimum-adjusted reward. A card-specific minimum does not establish a universal minimum BW gain.

**Canonical example:** Installed Software A reads “Whenever you gain PULP prevention, gain BW equal to the amount gained in that event, to a minimum of 3 BW.” The Rustler gains **1 PULP prevention**, triggering A. Before A's queued trigger resolves, the current PULP prevention pool rises to **6** through another effect. If A's trigger remains eligible to resolve, it attempts to grant **max(1, 3) = 3 BW**, subject to applicable resource restrictions, **not 1 or 6 BW**.

**Compatibility:** RULE-111 preserves the original recorded event magnitude; RULE-112 permits arithmetic using that magnitude; RULE-113 applies explicit maximums. RULE-110 continues to govern distinct current-state variables. Existing trigger timing, eligibility, source-removal cancellation, costs and conditions remain unchanged. RULE-108 remains deferred.


## 180. RULE-115 — Event-referenced rewards obey explicit minimum and maximum (LOCKED, 2026-11-11)

**Explicit user approval:** When a triggered ability bases its reward on the **original recorded actual magnitude of its triggering event** and states both a **minimum and maximum** reward, compute the event-based reward and then constrain it to the stated inclusive range. This combines RULE-113 and RULE-114; it does not change the event's recorded magnitude or establish general resource caps.

**Canonical example:** Software A reads “Whenever you gain PULP prevention, gain BW equal to the amount gained in that event, to a minimum of 2 BW and a maximum of 5 BW.” If the triggering event actually gained **1 PULP prevention**, attempt to grant **2 BW**; if **3 PULP**, grant **3 BW**; if **8 PULP**, grant **5 BW**. Formula: **min(5, max(2, original event PULP gain))**, subject to applicable resource restrictions.

**Compatibility:** RULE-107/111 preserve recorded actual event magnitude; RULE-112 permits arithmetic based on that magnitude; RULE-113 and RULE-114 establish explicit maxima and minima. RULE-110 continues to govern separately referenced current-state variables. Trigger eligibility, cancellation, costs, conditions, FIFO timing and the deferred status of RULE-108 remain unchanged.


## 181. RULE-116 — Combine fixed triggering-event magnitude with resolution-time current resources (LOCKED, 2026-11-11)

**Explicit user approval:** When a triggered ability calculates a reward by combining an **event-referenced magnitude** with an explicitly **current game-state quantity**, each input follows its own timing rule: use the **original recorded actual magnitude** of the triggering event (RULE-107/111), but evaluate the **current** quantity at the **start of the discrete reward instruction** (RULE-102/110). Apply the printed arithmetic to those values. Later resource changes do not rewrite the triggering event; earlier values of current-state variables are not snapshotted at trigger time.

**Canonical example:** Installed Software A reads “Whenever you gain PULP prevention, gain BW equal to the amount gained in that event multiplied by your current Trace.” Rustler gains **3 PULP prevention** at **Trace 4**, triggering A. Before its queued trigger resolves, Trace rises to **6**. If the trigger remains eligible, the reward attempts to grant **3 × 6 = 18 BW**, not 12 BW, subject to applicable resource restrictions.

**Compatibility:** Preserves RULE-110's resolution-time current-value evaluation, RULE-111/112's original event-referenced magnitude, RULE-102/103's per-instruction value snapshot, and existing FIFO, eligibility, costs, conditions, source-removal cancellation. RULE-108 remains deferred.


## 182. RULE-117 — Distinct qualifying events create distinct event-referenced triggers (LOCKED, 2026-11-11)

**Explicit user approval:** When a Software ability triggers “whenever” a qualifying event occurs, **each distinct qualifying event** generates its **own trigger instance** and retains its **own recorded actual event magnitude**, provided the source remains eligible and no applicable frequency limit or other restriction prevents the trigger. Do not merge separate events merely because their queued triggers have not yet resolved. Each queued trigger resolves independently in the existing FIFO order.

**Canonical example:** Installed Software A reads “Whenever you gain PULP prevention, gain BW equal to the amount gained in that event.” The Rustler gains **3 PULP prevention**, creating a qualifying event and a queued trigger for **3 BW**. Before it resolves, another effect grants **5 PULP prevention**, a distinct qualifying event queuing another trigger for **5 BW**. If both triggers remain eligible, they separately attempt to grant **3 BW then 5 BW** in FIFO order, subject to applicable BW restrictions, **not one merged 8 BW trigger**.

**Compatibility:** RULE-076 distinguishes separate gain instructions/events; RULE-105/106 aggregate gains that form a single instruction's event; RULE-107/109 establish actual event magnitudes and threshold qualification; RULE-111/112 preserve event-referenced quantities; RULE-014/015/080 govern FIFO, and RULE-020–027 and RULE-081/082/085 govern limits and cancellation. RULE-108 remains deferred.


## 183. RULE-118 — Distinct queued triggers independently evaluate current-state operands (LOCKED, 2026-11-11)

**Explicit user approval:** When distinct qualifying events queue separate instances of a triggered ability whose reward combines **the magnitude of that specific triggering event** with a **current game-state variable**, each trigger retains its **own event's original recorded actual magnitude** and evaluates the current-state operand **independently at the start of its own discrete reward instruction**. A change in the current variable between resolutions affects later triggers but does not retroactively change earlier rewards or event magnitudes.

**Canonical example:** Software A reads “Whenever you gain PULP prevention, gain BW equal to the amount gained in that event plus your current Trace.” Event 1 gains **3 PULP prevention** and event 2 gains **5 PULP prevention**, queuing two separate triggers. At the first reward instruction, Trace is **4**, so that trigger attempts to grant **3 + 4 = 7 BW**. Before the second reward instruction, Trace increases to **6**, so the second attempts to grant **5 + 6 = 11 BW**. Total attempted BW gain is **18 BW**, if both resolve and applicable resource restrictions permit it.

**Compatibility:** RULE-102/103 govern per-instruction snapshots; RULE-107/111 fix event-referenced actual magnitudes; RULE-110/116 evaluate current-state operands at resolution; RULE-117 retains separate triggers for separate events. FIFO ordering, eligibility, costs, conditions, frequency limits, source-removal cancellation and the deferred status of RULE-108 remain unchanged.


## 184. RULE-119 — Multi-instruction triggered abilities recalculate current values per instruction (LOCKED, 2026-11-11)

**Explicit user approval:** When a triggered ability contains multiple **discrete instructions** that each reference a **current game-state variable**, evaluate that variable independently **at the start of each instruction**, under RULE-102/103. Do not snapshot the variable once for the whole ability. If an intervening change is legally permitted under the existing resolution/timing rules, the later instruction uses the updated value. This rule **does not create an interruption window** between instructions.

**Canonical example:** Software A reads “Whenever you gain PULP prevention, gain BW equal to your current Trace. Then gain PULP prevention equal to your current Trace.” After the qualifying event, the first reward instruction begins at **Trace 4**, so it attempts to grant **4 BW**. Assuming a legally permitted intervening effect changes Trace to **6** before the second instruction begins, the second instruction attempts to grant **6 PULP prevention**, not 4. All applicable resource restrictions and existing timing rules still apply.

**Compatibility:** Clarifies RULE-102/103 and RULE-110's per-discrete-instruction resolution-time evaluation. Does not alter RULE-010 printed instruction order, RULE-014/015 FIFO timing, eligibility, costs, conditions, source-removal cancellation, or deferred RULE-108.


## 185. RULE-120 — No automatic interruption window between ordinary instructions (LOCKED, 2026-11-11)

**Explicit user approval:** Resolve a card or ability's discrete instructions in their printed order **without an automatic interruption window between them**. An intervening effect may occur only where an existing timing rule or explicit card text permits it. Newly generated triggered abilities remain queued until the current ability finishes resolving, following the existing FIFO rules. RULE-102/103/119 still require current-state quantities to be evaluated independently at the start of each discrete instruction; those rules **do not themselves permit an interruption**.

**Canonical example:** Software A reads “Gain 4 BW. Then gain PULP prevention equal to your current Trace.” Trace is **4** when A starts resolving. The first instruction attempts to grant **4 BW**. With no legally permitted intervening effect that changes Trace, the next instruction immediately uses **Trace 4** and attempts to grant **4 PULP prevention**. Any triggers created during either instruction wait until A finishes, subject to existing timing, eligibility and resource restrictions.

**Compatibility:** Preserves RULE-010's printed order, RULE-014/015's queued-trigger timing and FIFO, RULE-102/103/119's per-instruction value evaluation, and all existing explicit exceptions. Does not create or remove any otherwise permitted interruption, nor resolve deferred RULE-108.


## 186. RULE-121 — Earlier instructions update current values for later calculations (LOCKED, 2026-11-11)

**Explicit user approval:** When one discrete instruction changes a game-state variable, a subsequent discrete instruction in the same resolving ability that refers to the **current** value of that variable uses the **updated game state** as it exists when that later instruction begins. Evaluate instructions in printed order; do not freeze the variable at ability start. This does not create an interruption window between ordinary instructions.

**Canonical example:** Software A reads “Increase your Trace by 2. Then gain PULP prevention equal to your current Trace.” The Rustler begins at **Trace 3**. The first instruction increases Trace to **5**. The second instruction then attempts to grant **5 PULP prevention**, using Trace 5 at the start of that instruction, subject to applicable restrictions.

**Compatibility:** RULE-010 governs printed instruction order; RULE-102/103/119 govern per-discrete-instruction current-value snapshots; RULE-120 forbids automatic interruption windows. Trigger timing, eligibility, resource limits, costs, conditions, source-removal cancellation and deferred RULE-108 remain unchanged.


## 187. RULE-122 — Earlier decreases update current values for later instructions (LOCKED, 2026-11-11)

**Explicit user approval:** When an earlier discrete instruction **reduces** a game-state variable, a subsequent discrete instruction in the same resolving ability that refers to that variable's **current** value uses the **actual reduced value** as it exists at the start of the later instruction. Apply the same per-instruction current-state evaluation to decreases as to increases under RULE-121; do not snapshot the variable at ability start.

**Canonical example:** Software A reads “Reduce your Trace by 2. Then gain PULP prevention equal to your current Trace.” The Rustler begins at **Trace 5**. The first instruction reduces Trace to **3**. The second instruction then attempts to grant **3 PULP prevention**, not 5, subject to applicable restrictions.

**Compatibility:** Preserves RULE-010 printed instruction order, RULE-102/103/119 per-instruction current-value snapshots, RULE-120 no automatic interruption, and RULE-121 updated values from earlier instructions. Existing resource floors/caps, trigger timing, costs, conditions, eligibility, source-removal cancellation and deferred RULE-108 remain unchanged.


## 188. RULE-123 — Later instructions use actual prior resource changes, not attempted amounts (LOCKED, 2026-11-11)

**Explicit user approval:** When a later discrete instruction refers to **the amount of a resource actually changed by an earlier instruction**, use the **actual change that occurred**, after applying applicable resource floors, caps, prevention, and other restrictions—not the printed or attempted change amount. The recorded actual change from that earlier instruction remains the referent even when the attempted amount exceeds what can occur.

**Canonical example:** Software A reads “Reduce your Trace by 5. Then gain PULP prevention equal to the amount of Trace actually reduced.” The Rustler begins at **Trace 3**, and Trace cannot fall below **0**. The first instruction attempts to reduce Trace by 5 but actually reduces it by **3**, leaving Trace **0**. The second instruction attempts to grant **3 PULP prevention**, not 5, subject to applicable restrictions.

**Compatibility:** RULE-107 distinguishes actual from attempted event magnitudes; RULE-010 preserves printed instruction order; RULE-102/103/119 evaluate numerical quantities at each discrete instruction; RULE-121/122 apply updated game state to later instructions. Existing trigger timing, costs, conditions, eligibility, resource limits, source-removal cancellation, and deferred RULE-108 remain unchanged.


## 189. RULE-124 — Conditional “if you reduced” requires a positive actual reduction (LOCKED, 2026-11-11)

**Explicit user approval:** A condition reading **“If you reduced [resource] this way”** is satisfied only if the referenced instruction **actually reduced that resource by a positive amount**. An attempted reduction that produces **zero actual change** does not satisfy the condition and grants no conditional reward. This rule addresses an effect condition, not whether an explicitly designated cost was fully paid; RULE-003 continues to govern costs.

**Canonical example:** Software A reads “Reduce your Trace by 3. If you reduced Trace this way, gain 2 BW.” The Rustler begins at **Trace 0**, and Trace cannot fall below 0. The attempted reduction of 3 produces **0 actual Trace reduction**, so the “if you reduced” condition fails and the Rustler gains **0 BW** from the conditional reward.

**Compatibility:** RULE-003's cost and conditional success principles remain intact; RULE-107/123 distinguish attempted from actual resource changes; RULE-010 governs printed order. Does not change trigger timing, eligibility, source-removal cancellation, resource limits, or deferred RULE-108.


## RULE-126 — SYN damage terminology and overflow (LOCKED, 2026-11-11)

**Authoritative decision:** The active damage keyword is **SYN X** (also styled **SYN DAMAGE X** in the approved rule review). Legacy **NEURAL DAMAGE** and **SYNAPTIC DAMAGE** are deprecated; neither is an active separate damage type. SYN is **Rustler-chosen** hand discard, never random discard. Historical mentions of the old terms elsewhere are superseded, not additional active mechanics.

Resolve SYN X in this order:
1. The Rustler chooses and discards as many cards as possible from their current hand, up to X.
2. Each unfulfilled point of SYN causes **2 Vitae damage**.
3. Apply that Vitae damage **after** discarding the available cards.

| SYN X | Hand | Discarded | Vitae damage |
|---:|---:|---:|---:|
| 3 | 3 | 3 | 0 |
| 3 | 2 | 2 | 2 |
| 3 | 1 | 1 | 4 |
| 3 | 0 | 0 | 6 |
| 5 | 2 | 2 | 6 |

**Priority:** RULE-126 supersedes older no-Vitae-loss statements for hand-discard damage and older random-discard SYN definitions. PULP remains direct Vitae damage; CORTEX remains persistent draw reduction. The approved overflow outcome is Vitae damage; do not silently reinterpret it as a separate SYN discard or CORTEX effect. Other prevention and trigger sequencing rules remain subject to their explicit text; do not invent unresolved interactions.

**Source:** `REDLINE_RULE_REVIEW_126.md`, approved and locked 2026-11-11. **Regression:** verify all five table cases and discard-before-Vitae ordering. RULE-127 remains pending.


**Terminology lock (2026-11-11):** **Vitae** is the canonical Rustler health resource (abbreviated **VIT** in the World Bible). The former health-resource term is deprecated. **PULP damage** reduces Vitae. This terminology update does not itself change damage-resolution mechanics.


**Damage terminology lock (2026-11-11):** **CHAR** is deprecated and replaced by **PULP damage**. **PULP X reduces Rustler Vitae by X**, subject to applicable PULP prevention. Earlier CHAR labels, examples, and prevention-pool references in this document are to be read as PULP. SYN remains mandatory Rustler-selected discard with its approved overflow rule; CORTEX remains distinct. This is a terminology replacement, not an additional damage type.


## RULE-127 — SyN prevention, mandatory discard, and overflow PULP (LOCKED, 2026-11-11)

**Approved resolution order:** When the Rustler receives **SyN X**:

1. **Apply SyN prevention:** Deduct available SyN prevention from incoming SyN, consuming no more prevention than the incoming amount.
2. **Determine unprevented SyN:** Resolve only the remaining SyN amount.
3. **Mandatory discard:** The Rustler **MUST** choose and discard as many cards as possible from their current hand, up to the unprevented SyN amount. The Rustler chooses *which* cards, but **cannot** voluntarily keep eligible cards and take PULP instead.
4. **Calculate overflow:** Each point of unprevented SyN not fulfilled by a card discard generates **2 PULP damage**, per RULE-126.
5. **Resolve PULP:** After mandatory discards, apply any available **PULP prevention** to the generated PULP damage; only unprevented PULP reduces **Vitae (VIT)**.

**Example:** Incoming SyN 5, SyN prevention 2, and 1 card in hand: 3 SyN remains; the Rustler must discard that 1 card; 2 SyN overflow generates **4 PULP**. Apply PULP prevention, if any, before reducing Vitae.

**Priority and scope:** RULE-127 specifies the resolution sequence and prevention interaction for RULE-126. **SyN** is Rustler-selected *mandatory* discard; **PULP** is the official Vitae-damaging keyword; **CHAR** is only colloquial slang for PULP in the World Bible; **CORTEX** is distinct. This rule does not invent additional prevention resources or change the previously established prevention-pool duration/stacking rules. Any unspecified simultaneous trigger timing remains open.

**Regression expectations:** Test full/partial/no SyN prevention, full/partial/empty hand, compulsory discard, PULP prevention of overflow, and zero-Vitae defeat. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-128 — SyN overflow PULP classification and triggers (LOCKED, 2026-11-11)

**Explicit user approval:** PULP generated by SyN overflow under RULE-126/127 is **ordinary PULP damage** for all mechanical purposes, not a fourth damage type. After SyN prevention and mandatory Rustler-selected discard, each unfulfilled SyN point generates **2 PULP**; resolve that PULP against the shared PULP prevention pool, and reduce **Vitae (VIT)** only by the unprevented remainder.

**Source-neutral application (explicit choice):** PULP prevention and PULP-related effects apply to overflow PULP **regardless of the damage's source**, even where an effect describes a particular source (for example, “prevent PULP from ICE”). For RULE-128 interactions, source descriptors do **not** exclude SyN-overflow PULP. This explicit exception supersedes the source-restriction option in the draft proposal; it does not change the distinction between damage types or permit other damage types to use PULP prevention.

**Trigger rule (explicit choice):** Only **actual PULP suffered**—the positive reduction of Vitae after prevention—counts for PULP-damage triggers. Merely generating, proposing, or fully preventing PULP **does not** trigger PULP-damage abilities. Effects requiring “when you suffer PULP” require **at least 1 VIT lost**. Do not introduce a separate “PULP generated” trigger category under RULE-128. Effects expressly referring to prevention itself are outside this PULP-damage-trigger rule and retain their printed conditions; their general timing remains governed by existing trigger rules.

**Examples:** SyN overflow generates 4 PULP, prevention 3 → suffer 1 PULP, lose 1 VIT, suffered-PULP trigger may fire. Overflow 6, prevention 6 → suffer 0 PULP, lose 0 VIT, no suffered-PULP trigger. Overflow 4, prevention 0 → suffer 4 PULP, lose 4 VIT. A source-described PULP prevention effect is eligible against overflow PULP under this rule.

**Compatibility:** RULE-127's order and compulsory discard remain unchanged. Three independent prevention pools (DMG-002), temporary prevention expiration (SOFT-013), and prohibition on reactive Rustler card play during Corporation turns (SOFT-011) remain unchanged. **CHAR** is in-world slang only; **PULP** is the official mechanical term. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-129 — Simultaneous mixed damage resolution (LOCKED, 2026-11-11)

**Explicit user approval:** When **one effect** inflicts two or more of the three damage types, resolve its damage components in the **fixed order PULP → SyN → CORTEX**, regardless of the effect's controller or the printed order of the listed damage types. Treat the mixed-damage instruction as one uninterrupted resolving effect for trigger-queue timing, with components processed sequentially against the updated game state.

1. **PULP component:** Spend applicable PULP prevention from the existing PULP pool; unprevented PULP reduces **Vitae (VIT)**. If VIT reaches zero, the run **ends immediately in defeat**. Stop; do not process remaining damage components or queued triggers.
2. **SyN component:** Apply SyN prevention, then the Rustler **MUST choose and discard** as many cards as possible up to unprevented SyN (RULE-127). Each missing discard generates **2 PULP** (RULE-126); resolve this overflow PULP immediately as part of the SyN component against the then-current PULP prevention pool. Only PULP actually suffered reduces VIT or qualifies for suffered-PULP triggers (RULE-128). If VIT reaches zero, immediately end the run; do not process CORTEX or queued triggers.
3. **CORTEX component:** Apply CORTEX prevention from its separate pool; resolve remaining CORTEX as persistent DRAW reduction subject to the established DRAW floor. CORTEX does not retroactively change cards already drawn.

**Triggers:** Damage-, discard-, and prevention-generated triggered effects are **queued as they arise**, not resolved between the mixed-damage components. Finish the entire mixed-damage effect before resolving its queued triggers under **RULE-014/015** (FIFO), with simultaneous enqueue priority under **RULE-011/012/013**. If immediate defeat occurs, the run ends and queued triggers do **not** resolve. Do not confuse this fixed *damage-component* order with the existing controller-selected order for separate simultaneous triggered effects; RULE-011/012 remain in force for those effects. The normal printed-order rule (RULE-010) still applies to other instructions and distinct effects; RULE-129 specifically overrides printed order for mixed damage components within one effect.

**Prevention and source:** PULP, SyN, and CORTEX retain their independent prevention pools (DMG-002). SyN overflow PULP uses the PULP pool and the source-neutral application and suffered-only trigger conditions of RULE-128. No reactive Rustler card plays during the Corporation turn (SOFT-011).

**Example:** One ICE subroutine inflicts PULP 3 + SyN 3 + CORTEX 2. Rustler has 10 VIT, 2 cards in hand, PULP prevention 1, no SyN/CORTEX prevention. Resolve PULP 3: prevent 1, lose 2 VIT (8 remain). Resolve SyN 3: mandatory discard 2, shortfall 1 generates 2 PULP; no PULP prevention remains, lose 2 VIT (6 remain). Resolve CORTEX 2: apply 2 persistent CORTEX counters. Queue generated triggers during these steps; resolve after the mixed-damage effect completes, if the run survives.

**Defeat precedence:** Reaffirms RULE-RT-002's immediate run defeat at zero Vitae; no later damage, advancement, or queued recovery may reverse defeat. **Status: LOCKED, explicitly approved 2026-11-11.**


### RULE-129 amendment — reversed fixed damage order (LOCKED, 2026-11-11)

**Explicit user revision supersedes the original RULE-129 ordering:** When one effect inflicts multiple damage types, the fixed component order is now **CORTEX → SyN → PULP**, regardless of controller or printed damage-type order. Any earlier RULE-129 statement of **PULP → SyN → CORTEX** is superseded and must not be used as the current resolution sequence.

1. **CORTEX first:** Apply CORTEX prevention and then persistent DRAW reduction under the established DRAW floor; no retroactive change to cards already drawn.
2. **SyN second:** Apply SyN prevention, mandatory Rustler-selected discards, and immediately resolve any resulting **overflow PULP** using the current PULP prevention pool (RULE-126/127/128). Check for immediate defeat after any VIT reduction.
3. **Direct PULP last:** Apply remaining PULP prevention to the effect's direct PULP component; unprevented PULP reduces Vitae (VIT). Check immediate defeat.

**Triggers and defeat unchanged:** Queue damage/discard/prevention triggers until the complete mixed-damage effect finishes (RULE-014/015/129), unless VIT reaches zero, which ends the run immediately and cancels unresolved components and queued triggers (RULE-RT-002). This ordering is fixed, not dynamically optimized or re-sorted by outcome. Reversing component order does not intrinsically increase numerical damage: CORTEX does not reduce the current hand, and PULP prevention is still consumed by eligible damage in resolution order.

**Revised example:** One effect inflicts PULP 3 + SyN 3 + CORTEX 2; Rustler starts at 10 VIT, 2 cards in hand, PULP prevention 1, no SyN/CORTEX prevention. First apply CORTEX 2. Next SyN 3 forces discard of both cards and generates 2 overflow PULP; prevent 1, suffer 1 (9 VIT). Finally direct PULP 3 is unprevented (6 VIT). Queue eligible triggers until all components finish.


## CORTEX damage enhancement — LOCKED (2026-11-11)

**Explicit user approval:** For each point of **unprevented CORTEX damage**, the Rustler **(1) gains one persistent CORTEX counter** reducing future normal DRAW by 1 (subject to the established effective DRAW floor of 1), and **(2) must choose and discard one card from their current hand if available**. If a required card is unavailable, **each missing discard generates 5 PULP damage**. Apply the existing PULP prevention pool to this overflow PULP; only unprevented PULP reduces Vitae (VIT) and counts as PULP suffered (RULE-128). The Rustler cannot elect to keep available cards and take overflow damage instead.

**Both consequences apply:** A CORTEX counter is gained **even when no card is available to discard and the 5 PULP overflow occurs**. CORTEX prevention is applied first; only unprevented CORTEX generates counters, required discards, and overflow. CORTEX overflow PULP is ordinary PULP under RULE-128, including its source-neutral prevention and suffered-only trigger semantics. Check immediate defeat whenever VIT is reduced to zero; unresolved instructions and pending triggers stop (RULE-RT-002).

**Mixed damage interaction:** RULE-129's current fixed order remains **CORTEX → SyN → PULP**. Resolve CORTEX's mandatory discards and overflow PULP within the CORTEX component before moving to SyN; this may leave fewer cards available for SyN and cause its separate **2 PULP per missing discard** overflow (RULE-126/127). Resolve direct PULP last. Damage/discard-generated triggers queue until the full mixed-damage effect completes, unless immediate defeat ends the run (RULE-014/015/129). Independent CORTEX, SyN and PULP prevention pools remain in effect.

**Example:** CORTEX 2 against a hand of 0, with no CORTEX or PULP prevention: gain 2 CORTEX counters, generate 10 PULP, and suffer up to 10 VIT loss (or immediate defeat upon reaching 0). CORTEX 2 against a hand of 1: gain 2 CORTEX counters, discard the 1 card, generate 5 PULP before prevention. A mixed effect of CORTEX 2 + SyN 2 against a hand of 2 first discards both cards and gains 2 CORTEX counters, then SyN 2 has a shortfall of 2 and generates 4 PULP before prevention.

**Priority:** This approved enhancement supersedes older descriptions that define CORTEX only as persistent DRAW reduction. No new ordinary-card CORTEX-counter removal is authorized; existing specialized network recovery and inter-corporation clearing remain unchanged.


## RULE-130 — Fatal damage, pending effects, and partial resolution (LOCKED, 2026-11-11)

**Explicit user approval:** Check Rustler Vitae (VIT) **immediately after every actual VIT reduction**, including direct PULP and PULP generated by SyN or CORTEX shortfall. Apply eligible PULP prevention first. If VIT reaches **0**, the run **immediately ends in defeat**; do not wait for the end of the damage component, card, ICE subroutine, mixed-damage effect, turn, or trigger queue.

**Pending recovery cannot reverse defeat:** No already-queued trigger, later instruction, pending recovery/heal, or future action resolves after defeat, even if it could restore Vitae. A recovery effect that **fully resolved before** the lethal VIT reduction counts normally. A damage-suffered trigger does not interrupt its originating effect; it remains queued per RULE-014/015 and cannot rescue the Rustler after lethal damage. This rule creates **no last-chance recovery exception**.

**Partial resolution is not rolled back:** Preserve all changes from instructions and components **already completed before defeat**, including spent prevention, mandatory discards, gained CORTEX counters, and earlier damage. **Cancel all remaining unresolved instructions, damage components, and queued triggered effects**. Do not roll back completed changes or continue resolving effects after defeat. This is a terminal game-state record, not permission to resume the run.

**Compatibility and priority:** Reaffirms **RULE-RT-002** (immediate defeat), **RULE-014/015** (deferred FIFO triggers), **RULE-127/128** (SyN shortfall and actual PULP suffered), and **RULE-129** (current fixed mixed-damage order **CORTEX → SyN → PULP**, with CORTEX's mandatory discard and **5 PULP per missing discard** enhancement). Each type's prevention remains separate, with overflow PULP consuming eligible PULP prevention. Defeat takes priority over queued recovery and over the instruction to complete the mixed-damage event before processing queued triggers. This clarification does not alter controller ordering of simultaneous triggers (RULE-011/012/013) or permit reactive Rustler card plays (SOFT-011).

**Example:** Rustler has **6 VIT**, **0 cards** in hand, and **no prevention**. CORTEX 2 first grants **2 persistent CORTEX counters**, requires 2 discards, and generates **10 PULP** for the 2 missing cards. Upon lethal VIT loss, defeat is immediate. The completed CORTEX counters and other completed changes remain recorded; subsequent SyN or direct PULP components, later instructions, and queued recovery triggers never resolve.

**Status: LOCKED — explicitly approved 2026-11-11.**


## RULE-131 — Mandatory prevention consumption, immediate overflow, and detailed accounting (LOCKED, 2026-11-11)

**Explicit user approval:** Eligible damage prevention is **automatic and mandatory**. At each actual damage application, the engine consumes applicable prevention immediately; the Rustler cannot decline or withhold eligible prevention to save it for a later component or source. PULP, SyN, and CORTEX have **independent type-specific numerical pools** (DMG-002); only prevention eligible for the incoming damage type may be spent. The displayed pooled value is backed by source/duration accounting.

**Consumption order (RULE-004/005/006):** Within a type-specific pool, consume eligible contributions in the priority already established by RULE-004/005 (earliest expiration first), with the existing RULE-006 equal-expiration tie-breaker. RULE-131 creates **no new source priority**, no player-selected prevention withholding, and no cross-type spending. Record each source contribution consumed and its remaining value.

**Overflow timing and order:** Under the current RULE-129 fixed mixed-damage order **CORTEX → SyN → PULP**, complete each component before proceeding to the next. For unprevented CORTEX, apply its persistent counters and mandatory Rustler-selected hand discards; each missing discard generates **5 ordinary PULP**. **Immediately resolve that overflow PULP within the CORTEX component**, automatically consuming then-eligible PULP prevention. Next, for unprevented SyN, perform mandatory Rustler-selected discards; each missing discard generates **2 ordinary PULP**, likewise immediately resolved within the SyN component using the PULP pool remaining at that moment (RULE-126/127). Finally, apply any direct PULP component against the remaining PULP prevention. The Rustler cannot defer or pool overflow PULP until the final direct PULP component. CORTEX and SyN prevention are applied before determining their respective unprevented damage and overflow. Source-neutral PULP prevention and suffered-only PULP triggers remain as locked by RULE-128.

**Defeat and triggers:** After prevention, if an actual PULP application reduces Vitae (VIT) to zero, defeat is immediate (RULE-RT-002/RULE-130). Preserve completed changes, cancel unresolved damage components/instructions and pending triggers; no queued recovery can reverse defeat. Otherwise, triggers generated by damage, discards, or prevention are enqueued during resolution and resolve only after the containing mixed-damage effect completes, under RULE-014/015 and RULE-129. This rule does not authorize reactive Rustler card plays during the Corporation turn (SOFT-011).

**Mandatory UI and log accounting:** For each damage application, show the **damage source and type**, incoming amount, prevention consumed **broken down by contributing source and duration**, each type-specific pool's remaining amount, unprevented CORTEX/SyN, mandatory discards completed and shortfalls, **overflow PULP generated and immediately prevented**, **actual PULP suffered**, resulting VIT change, and persistent CORTEX counters gained. Preserve the step-by-step order in the action log; show when lethal defeat truncates further resolution. These are interface/reporting requirements, not new trigger events.

**Canonical example:** One effect inflicts CORTEX 2 + SyN 2 + direct PULP 3 against a Rustler with **10 VIT, 1 card in hand, 4 PULP prevention, and no CORTEX or SyN prevention**. CORTEX 2 adds two counters, discards the one card, and generates 5 PULP for the one missing discard; automatically spend 4 PULP prevention and suffer 1 PULP (VIT 9). SyN 2 has no cards to discard, generates 4 PULP and suffers 4 (VIT 5). Direct PULP 3 suffers 3 (VIT 2). All generated triggers queue until the effect completes unless defeat intervenes.

**Status: LOCKED — explicitly approved 2026-11-11.**


## RULE-132 — Post-Corporation hand cleanup and defensive hand retention (LOCKED, 2026-11-11)

**Explicit user approval:** Ordinary unplayed cards **remain in the Rustler's hand through the Corporation Response Phase** and are available for mandatory damage discards. Move routine non-CACHED hand cleanup **after the entire Corporation response and its queued triggers**, before beginning the next Rustler turn or transitioning to another ICE layer. This **supersedes only the pre-Corporation hand-discard timing** in RULE-RT-003/004/005; retain the established end-of-turn effects, BW forfeiture, and Corporation response sequencing.

**Revised turn order:** (1) Rustler voluntarily selects END TURN (RULE-RT-001); (2) resolve Rustler end-of-turn effects, including applicable BW effects and their triggered consequences; (3) **forfeit all remaining BW** (set available BW to zero); (4) enter and fully resolve Corporation Response, including ICE subroutines, damage and all applicable queued triggers; (5) if the run survives, perform **one post-response cleanup**, discarding all remaining non-CACHED cards from hand and resolving resulting discard triggers under RULE-014/015; (6) only after cleanup and its triggers finish, proceed to the next Rustler turn, ICE PASS, or Node/ICE transition as applicable. **No routine hand discard takes place between steps 2 and 4.**

**End-of-turn versus cleanup triggers:** Abilities explicitly triggered by **end of Rustler turn** still trigger at the existing end-turn window, before BW forfeiture and Corporation response. Abilities triggered by **actually discarding a card** trigger when that discard occurs: damage-induced discards during Corporation response occur then and queue per RULE-014/015/129; routine cleanup discards occur after the response and their triggers resolve before transition. A cleanup discard is **not retroactively an end-of-turn discard** for effects requiring that timing. Resolve the post-response cleanup discard batch and its generated triggers before advancing; follow existing simultaneous-trigger priority and FIFO queue rules. This relocation may change whether discard-generated prevention can affect the current Corporation response; do not backdate it.

**CACHE reconciliation (SOFT-003 through SOFT-008):** CACHE continues to protect selected cards from **routine cleanup**, not from damage. **CACHED cards are eligible for mandatory CORTEX and SyN discards** under the normal Rustler-selection rule (RULE-001), unless an effect expressly provides protection. If discarded by damage, they leave hand and cannot be retained by CACHE. CACHED cards remaining after response survive cleanup, persist across ICE layers within the same Node while supported, and remain **additive to normal DRAW** (SOFT-004/005/006). Loss of CACHE support (SOFT-007) causes affected cards to be treated as ordinary cards at the next applicable cleanup, not discarded immediately merely for losing retention; explicit corporate discard and CACHE-targeting effects (SOFT-008) still work. CACHE does not survive the Node boundary (SOFT-006).

**ICE PASS:** If an ICE PASS or advancement occurs after a Corporation response, use the **single post-response cleanup** for the ordinary non-CACHED hand; do **not** run an additional routine PASS hand discard for those same cards. Finish cleanup-generated triggers before PASS transition. Other PASS-specific effects and triggers remain governed by their actual printed trigger conditions and existing rules; do not invent a second discard event. The next ICE layer retains the established fresh normal DRAW and additive surviving CACHE, subject to existing Node/ICE setup rules.

**DRAW remains unchanged:** No defensive DRAW is added during Corporation response. Preserve RULE-028/029/030/031 start-of-turn sequencing (refresh BW, resolve start-of-turn triggers, calculate DRAW, then normal DRAW) and current effective DRAW formula **max(1, 5 − CORTEX counters + applicable modifiers)**. Installed Hardware does not inherently reduce DRAW. CACHED cards are additive and do not reduce the number of new cards drawn; CORTEX counters gained during the response affect future DRAW only.

**Damage and defeat unchanged:** During Corporation response, retained ordinary and CACHED cards are available for mandatory damage discards. Apply the fixed mixed-damage order **CORTEX → SyN → PULP** (RULE-129). Each unprevented CORTEX grants its persistent counter and requires one discard; each missing discard generates **5 ordinary PULP**. Each unprevented SyN requires one discard; each missing discard generates **2 ordinary PULP** (RULE-126/127). Apply type-specific prevention automatically and immediately, including PULP prevention against overflow within the originating component (RULE-128/131). Damage-generated triggers remain queued until their containing effect completes (RULE-014/015/129). If Vitae reaches zero, immediate defeat (RULE-RT-002/RULE-130) cancels remaining instructions, pending triggers and post-response cleanup, preserving completed changes.

**Canonical example:** Rustler starts with five cards, plays two, and ends the turn holding three. End-turn effects resolve; unused BW is forfeited; the hand is **not** discarded. Corporation inflicts CORTEX 2 + SyN 2, with no prevention: CORTEX adds two counters and discards two cards; SyN discards the final card and generates **2 PULP** for one missing discard, reducing Vitae by two if unprevented. No ordinary cards remain at post-response cleanup. At the next normal DRAW, absent other modifiers, the two CORTEX counters reduce DRAW from five to three.

**Priority:** RULE-132 explicitly supersedes the earlier pre-response routine discard instruction of RULE-RT-003/004/005 and the related older end-turn discard timing in SOFT-003/007, while preserving the underlying CACHE, BW, trigger, damage, defeat, ICE PASS and DRAW mechanics as reconciled above. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-133 — Discard-trigger timing and nonretroactive prevention (LOCKED, 2026-11-11)

**Explicit user approval:** When CORTEX, SyN, or another effect causes one or more cards to be discarded, discard-triggered abilities generated by those discards **queue as they arise** and **do not interrupt the originating effect**. Finish the entire originating effect (including its remaining mixed-damage components in the fixed **CORTEX → SyN → PULP** order, immediate overflow PULP, and any other instructions) before resolving its queued triggers. Use existing RULE-011/012/013 simultaneous-trigger ordering and RULE-014/015 FIFO queue semantics; do not create a new priority or interrupt window.

**Prevention gained by discard triggers:** Prevention from a triggered ability becomes available **only when that ability actually resolves**. It applies to eligible **subsequent damage** within its permitted duration, including a later ICE subroutine in the same Corporation response if applicable. It **never retroactively prevents** PULP, SyN, or CORTEX already resolved, and cannot be spent before it has been gained. Once gained, prevention follows DMG-002 and RULE-004/005/006 (type-specific pools and earliest-expiration consumption) and RULE-131 (automatic mandatory consumption). Damage overflow from missing CORTEX/SyN discards resolves immediately within its originating component under RULE-127/128/129/131, without waiting for discard-triggered prevention.

**Post-Corporation cleanup:** Following RULE-132, after the Corporation response and its pending triggers have finished, discard all remaining non-CACHED cards in the **single post-response cleanup**. Abilities triggered by those actual cleanup discards queue during cleanup and **resolve before the next Rustler turn, ICE PASS, or Node/ICE transition**. Do not defer them to the next turn and do not add a second ordinary PASS discard. These triggers cannot retroactively change damage or prevention from the already-completed Corporation response. End-of-turn triggered abilities retain their earlier end-of-turn window; cleanup discards do not retroactively count as discards during that window.

**CACHE:** CACHED cards are exempt from routine cleanup but remain eligible for mandatory CORTEX/SyN damage discards unless explicitly protected (RULE-132 and SOFT-003–008). Discarding a CACHED card by damage generates applicable discard triggers under the same deferred timing; CACHE does not create an interrupt or retroactive prevention exception.

**Defeat and cancellation:** Check VIT immediately after each actual VIT reduction following prevention. At zero VIT, defeat is immediate and unresolved instructions and pending triggers are cancelled, with completed state changes preserved (RULE-RT-002/RULE-130). A queued discard-triggered prevention or recovery effect cannot rescue the Rustler after fatal damage. SOFT-011 still prohibits reactive Rustler card plays during Corporation turn; already-established triggered abilities may resolve when their queued turn arrives.

**Canonical example:** Rustler has 10 VIT, three cards in hand, no prevention, and installed Software reading *“Whenever you discard a card, gain 2 PULP prevention.”* One Corporation subroutine inflicts **SyN 2 + direct PULP 4**. SyN discards two Rustler-chosen cards, queuing two prevention-gain triggers; the triggers do **not** resolve yet. Direct PULP 4 is unprevented, reducing VIT to **6**. Once the subroutine's full effect finishes, the two queued triggers resolve under FIFO and grant **4 PULP prevention** in total (subject to applicable ability limits and source validity). That prevention may protect against a later subroutine but cannot prevent the earlier 4 PULP. If the Rustler had been defeated during the subroutine, the queued triggers would instead be cancelled.

**Priority and reconciliation:** RULE-133 **clarifies, rather than overrides**, RULE-014/015 deferred-trigger resolution; RULE-127/128/129/130/131 damage ordering, prevention, overflow, and fatal damage; RULE-132 post-response cleanup and ICE PASS; and SOFT-003–008 CACHE. It introduces **no retroactive protection, extra DRAW, out-of-turn Rustler card-play window, or new discard event**. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-134 — Discard event granularity, trigger frequency, and separate overflow PULP events (LOCKED, 2026-11-11)

**Approved design:** Use the existing instruction-level event model and deferred trigger queue; no new timing or interrupt system. Each **discrete discard instruction or damage component** produces **one grouped discard event** containing a separately recorded occurrence for **each card actually discarded**. Discard zero cards means zero actual card-discard occurrences; do not generate an actual-discard trigger for a shortfall. Distinct instructions are distinct groups even within one card effect. For a mixed damage effect, CORTEX and SyN are distinct damage components and thus distinct discard groups, even when one ICE subroutine generates both. One ordinary post-Corporation cleanup (RULE-132) is one grouped event containing its individual actual discards, and ICE PASS does not add a second routine cleanup group.

**Trigger wording controls counting:** “Whenever you discard **a card**” recognizes each individual actual card discard (three cards = three qualifying occurrences, subject to existing once-per-turn/activation limits). “Whenever you discard **one or more cards**” recognizes each grouped discard event with at least one actual discard (three cards in one instruction = one qualifying group). “For each card discarded” within a single group uses the group's actual card count as the magnitude of the relevant instruction, not separate events unless its printed trigger explicitly says per card. “The first time ... each turn” retains its existing per-turn allowance; a multi-card discard does not reset or bypass it. Card-specific qualifiers and source validity still apply. Preserve RULE-054/055, RULE-074–079, RULE-105/106 aggregate event identity, RULE-107 actual-vs-attempted magnitude, and existing per-turn limits.

**Separate overflow PULP events (explicit user decision):** For **each missing mandatory CORTEX discard**, generate a **separate ordinary PULP 5 damage event**; for **each missing mandatory SyN discard**, generate a **separate ordinary PULP 2 damage event**. Never aggregate multiple missing discards into one PULP event for damage-event trigger counting, even when they arise from the same damage component or ICE subroutine. Resolve each generated PULP event **immediately in sequence inside its originating CORTEX or SyN component**, applying available mandatory PULP prevention afresh against that event under RULE-128/131 and recording actual PULP suffered separately. Triggered effects recognizing a PULP damage event or actual PULP suffered count each qualifying separate event under their exact wording and applicable limits, but **remain queued** until the entire originating effect completes (RULE-014/015/129/133); they cannot create retroactive prevention or interrupt the next overflow event. After resolving all overflow events in CORTEX, proceed to SyN, then direct PULP, under RULE-129's fixed **CORTEX → SyN → PULP** order. A direct PULP component remains its own damage event under existing instruction-level rules. Check Vitae after every actual reduction: at VIT zero, RULE-130 immediately ends the run, cancels further overflow events, remaining instructions and queued triggers, preserving completed changes.

**Sequencing and bookkeeping:** For each component, first apply type-specific CORTEX/SyN prevention; apply each unprevented point's counter/discard consequences as established in RULE-127/129/131, recording actual card discards in the component's grouped discard event and resolving any missing-discard overflow PULP immediately as individual damage events. Preserve mandatory earliest-expiration prevention consumption (RULE-004/005/006/131). Each separate overflow PULP event records its source, originating damage type, amount (5 or 2), PULP prevention consumed by source/duration, actual VIT loss, and associated pending triggers. Discard-trigger occurrences record each card, grouping identifier, source, and reason. Trigger ordering for simultaneously recognized occurrences follows existing controller-order and FIFO rules; no new interrupt window is created.

**Examples:** (A) “Discard 3 cards” actually discards three: one grouped discard event, three per-card discard occurrences; a “whenever you discard a card” ability can queue three triggers, while “whenever you discard one or more cards” queues one. (B) CORTEX 2 + SyN 2 with four cards in hand: two grouped discard events (CORTEX discards two, SyN discards two), four individual card discards; per-card trigger count four, per-group trigger count two, before limits. (C) CORTEX 3 against an empty hand, with no prevention: gain three CORTEX counters; the three missing discards generate **three separate PULP 5 events**, in sequence, each with independent prevention and trigger-event accounting, stopping immediately on lethal VIT loss. (D) SyN 2 against an empty hand generates **two separate PULP 2 events**, not one PULP 4 event; aggregate VIT loss can equal four if unprevented and nonlethal, but event count remains two.

**Reconciliation and priority:** This rule clarifies RULE-010 instruction boundaries, RULE-014/015 deferred FIFO triggers, RULE-105/106 grouping, RULE-126–131 damage/overflow and prevention, RULE-132 single cleanup and CACHE timing, and RULE-133 deferred discard triggers and nonretroactive prevention. **It explicitly specifies separate overflow PULP event granularity**, superseding any inference that all shortfall PULP in one component forms a single event; numeric PULP amounts and existing prevention mechanics are unchanged. No reactive Rustler card plays or extra DRAW are created. **Status: LOCKED, approved 2026-11-11.**


## RULE-135 — Damage-event identity, trigger eligibility, and prevention accounting (LOCKED, 2026-11-11)

**Explicit approval:** Each separate PULP damage application is an independent damage event for trigger eligibility and accounting, including each individual overflow PULP 5 from a missing CORTEX discard and each individual overflow PULP 2 from a missing SyN discard (RULE-134). Do not merge them into one event merely because they arise from the same ICE subroutine, damage component, or effect. Distinguish **damage applied** (an attempted PULP application, even when fully prevented), **damage prevented** (amount actually absorbed by eligible PULP prevention), and **damage suffered** (unprevented PULP actually reducing Vitae). Abilities recognize only the event their printed conditions name; do not conflate these categories.

**PULP-suffered eligibility:** “Whenever you suffer PULP damage” triggers only on a PULP event that **actually reduces VIT**, and once per qualifying event unless printed wording or an existing activation limit says otherwise. A fully prevented PULP event does **not** qualify as PULP suffered. Event magnitude for “PULP suffered” equals actual VIT reduction, not incoming PULP; prevention amount equals actual prevention consumed, not incoming PULP or unused pool capacity. Preserve RULE-107–109 actual-versus-attempted magnitude and threshold handling, as well as existing per-turn and per-source trigger limits.

**Prevention-event eligibility:** “Whenever you prevent damage” and comparable prevention-consumption triggers recognize only **actual positive prevention consumed**; a zero-consumption event does not qualify. Count prevention separately for each damage application and by the applicable prevention source/duration contribution under RULE-004/005/006 and RULE-131; do not invent a gain or consumption when none occurred. If one damage application consumes several prevention sources, apply existing RULE-074–079, RULE-105/106 and exact card wording to determine per-event versus per-source qualification; this rule does not automatically multiply a single event into one trigger per contributing source. Type-specific CORTEX and SyN prevention remain separate from PULP prevention; their consumption is accounted for when the respective type is applied.

**Timing:** All damage-, discard-, prevention-, and related triggers are queued as generated, following existing simultaneous-controller ordering and FIFO rules (RULE-011–015). They **do not interrupt their originating effect**, including between separate overflow PULP events within one CORTEX/SyN component. Resolve the entire originating effect before its queued triggers. Prevention granted by a queued trigger can apply only to **later** eligible damage after it actually resolves, never retroactively or to an earlier overflow event (RULE-133). Resolve each overflow event immediately within its originating component, with mandatory PULP prevention consumed under RULE-131, and preserve fixed mixed-damage order **CORTEX → SyN → direct PULP** (RULE-129). If VIT reaches zero, defeat is immediate; cancel unresolved damage events, instructions, and queued triggers without reversing completed changes (RULE-130).

**Worked example:** Rustler begins at **20 VIT**, with no hand cards, **6 PULP prevention**, and no CORTEX prevention. Corporation inflicts CORTEX 3: gain 3 CORTEX counters and encounter 3 missing mandatory discards. Generate and resolve **three distinct PULP 5 events**, in order. Event 1: prevent 5, suffer 0, VIT 20. Event 2: prevent 1, suffer 4, VIT 16. Event 3: prevent 0, suffer 5, VIT 11. Thus there are **3 PULP applications**, **2 PULP-suffered events**, **2 events with positive PULP prevention**, **6 total PULP prevented**, and **9 total PULP suffered**. A “whenever you suffer PULP damage” ability recognizes two events, subject to its limits; its triggers wait until the full originating CORTEX effect completes. If the Rustler is defeated during any event, remaining events and queued triggers are cancelled.

**Reconciliation and priority:** RULE-135 clarifies, without overriding, RULE-004–006 mandatory source/expiration consumption, RULE-014/015 FIFO deferred triggers, RULE-074–079 prevention-event granularity, RULE-105–109 aggregate events and actual magnitudes, RULE-126–131 damage/overflow and fatal defeat, RULE-132 post-Corporation cleanup, RULE-133 nonretroactive trigger timing, and RULE-134 separate overflow PULP event identity. No new interrupt window, defensive DRAW, retroactive prevention, or extra routine discard is created. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-136 — Damage resolution boundaries and trigger queue checkpoints (LOCKED, 2026-11-11)

**Explicit approval:** Each **independently resolving ICE subroutine** is a distinct effect boundary. Resolve the subroutine's full effect to completion before processing triggers generated by it. This includes all its discrete instructions, mandatory type-specific prevention, CORTEX counters and required discards, SyN discards, separate overflow PULP events for each missing discard (RULE-134), direct PULP, and resulting VIT changes, in the fixed **CORTEX → SyN → PULP** component order where mixed damage applies (RULE-129). Do **not** insert a trigger-resolution checkpoint between individual damage components, overflow PULP events, or instructions inside that still-resolving effect. The same principle applies to other independently resolving effects: finish the current effect before its generated triggers.

**Mandatory checkpoint between effects:** After the current independently resolving effect completes, **fully drain all eligible queued triggers** before beginning the next independent ICE subroutine or other effect. Use the existing simultaneous-trigger/controller ordering, FIFO queue, and complete-one-effect-before-generated-triggers semantics (RULE-010–015). A trigger that generates further triggers places them on the existing queue; continue resolving eligible chained triggers until the queue is empty, subject to RULE-016–019 infinite-loop and recursion safeguards and existing trigger eligibility, per-turn activation limits, source-removal cancellation, and explicit exceptions. Do not resolve only the first generation or carry eligible chained triggers into the next effect. An individual queued triggered ability is itself resolved completely before its newly generated triggers are processed under the established queue discipline.

**Updated state between subroutines:** At the next subroutine boundary, apply the game state after the preceding effect and its drained triggers, including new prevention pools, changed VIT, resource changes, discarded cards, CORTEX counters, installed/removed sources, and temporary effect durations. Prevention gained when a trigger actually resolves may protect against a **later** subroutine if eligible and still active; it **cannot** prevent damage from the completed originating subroutine or any earlier overflow PULP event (RULE-133/135). No new reactive Rustler card-play window or out-of-turn DRAW is created (SOFT-011; RULE-132).

**Corporation response and cleanup:** Finish **all** Corporation response effects and their full trigger checkpoints before performing the **single** post-Corporation hand cleanup required by RULE-132. Routine cleanup discards all remaining non-CACHED cards in one grouped discard event (RULE-134), while eligible CACHED cards survive routine cleanup but remain eligible for mandatory CORTEX/SyN damage discards. Cleanup-generated triggers resolve and drain completely before the next Rustler turn, ICE PASS, or Node/ICE transition (RULE-132/133). Never start cleanup with eligible Corporation-generated triggers pending, and never create a second routine ICE PASS cleanup event.

**Immediate defeat overrides checkpoints:** Check VIT after each actual reduction, including each separately resolved overflow PULP event. At VIT 0, defeat immediately ends the run (RULE-RT-002/RULE-130); preserve completed changes but cancel remaining instructions, unresolved damage events, queued triggers and post-response cleanup. No pending heal, recovery, or prevention trigger can rescue the defeated Rustler. Mandatory prevention consumption, source expiration priorities, and applied/prevented/suffered event distinctions remain RULE-004–006/131/135.

**Canonical example:** Rustler begins at **12 VIT**, with no PULP prevention, and has installed Software: *“Whenever you suffer PULP damage, gain 3 PULP prevention.”* Corporation resolves two independent unbroken ICE subroutines. Subroutine 1 inflicts **PULP 4**; Rustler suffers 4, dropping to **8 VIT**, and queues the Software trigger. Subroutine 1 finishes; at its checkpoint the queued trigger resolves, granting **3 PULP prevention**. Subroutine 2 inflicts **PULP 5**; mandatory prevention absorbs 3, Rustler suffers 2 and drops to **6 VIT**. The second suffered-damage trigger queues for the checkpoint **after subroutine 2**, not during it. If both PULP instructions were within one independently resolving effect, no checkpoint would occur between them and the new prevention would not apply until afterward.

**Compatibility and priority:** RULE-136 establishes explicit checkpoints **without changing** RULE-010 printed instruction order, RULE-011–015 trigger ordering/FIFO/complete-effect semantics, RULE-016–019 loop safeguards, RULE-126–131 damage types, prevention, overflow and immediate defeat, RULE-132 post-response cleanup and DRAW/CACHE timing, RULE-133 nonretroactive prevention, RULE-134 grouped discard events and separate overflow PULP event identity, or RULE-135 actual-versus-attempted event eligibility. A subroutine is an effect boundary only when it is independently resolving; explicit text defining a single combined effect or existing exceptions retains its established effect boundary. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-137 — Routine post-Corporation cleanup is non-triggering housekeeping (LOCKED, 2026-11-11)

**Explicit approval and precedence:** Routine post-Corporation hand cleanup is a **non-triggering housekeeping operation outside all effect-triggering windows**. Once the entire Corporation response and **all eligible queued/chained triggers** have finished (RULE-132/136), perform the single routine cleanup: discard every remaining **non-CACHED** card from the Rustler's hand. These routine cleanup discards **do not generate, queue, or resolve discard-related triggered abilities or any other effect solely because cleanup discarded cards**. They cannot activate installed Software, card abilities, per-card/per-group discard triggers, prevention gains, DRAW, resource gains, or chained effects based on those housekeeping discards. Cleanup is not an effect-triggering checkpoint; once the cleanup action and its bookkeeping finish, advance directly to the next established phase or ICE/Node transition. Do not repeat cleanup or create an additional ICE PASS cleanup.

**Normal effect-caused discards unchanged:** This exception applies **only to routine cleanup discards**. Discards caused by CORTEX or SyN damage, ICE subroutines, Corporation instructions, Rustler card abilities, or other resolving effects remain ordinary effect-caused discards, with their existing individual occurrences, grouped event granularity, eligibility, and deferred FIFO trigger timing under RULE-014/015/127/129/133/134/135/136. A discard that happens **during Corporation response** is not routine cleanup merely because it occurs near the end of the response. All pending effect-generated triggers drain before housekeeping cleanup begins. Explicit card effects are not silently reclassified as housekeeping cleanup.

**CACHE, logging, and accounting:** CACHED cards survive routine cleanup under SOFT-003–008 and RULE-132, unless some separate effect explicitly discards them. Routine cleanup discards are still real cards moved out of hand and **must be recorded** in the game log with card identities, number discarded, phase, and reason marked **ROUTINE CLEANUP / NON-TRIGGERING**. They are not qualifying discard occurrences for trigger activation or trigger-frequency accounting, despite being recorded as a single housekeeping cleanup batch. Do not count them toward effects that ask whether a card was discarded via a triggering event. No defensive DRAW or other benefit is created by cleanup itself.

**Example:** Rustler finishes Corporation response with three non-CACHED cards and installed Software reading *“Whenever you discard a card, gain 2 PULP prevention.”* After all response-generated triggers have drained, routine cleanup discards the three cards and logs the batch. **Zero Software triggers** are generated and **zero PULP prevention** is gained from those housekeeping discards. The same Software still recognizes qualifying cards discarded earlier by CORTEX/SyN or another effect, subject to its normal limits.

**Explicit supersession and reconciliation:** RULE-137 **supersedes only conflicting statements that routine post-Corporation cleanup discards generate or resolve triggers** in RULE-132 (cleanup-generated triggers), RULE-133 (cleanup discard-trigger timing and cleanup-generated effects), RULE-134 (any inference that routine cleanup's grouped discard event generates per-card/per-group discard triggers), and RULE-136 (cleanup-generated/chained trigger checkpoint). All other provisions of RULE-132–136 remain LOCKED and operative: hand retention through Corporation response, full response trigger draining, single post-response cleanup, CACHE survival, separate overflow PULP events, prevention accounting, FIFO effect boundaries, and immediate defeat. Under RULE-010–019, this is a specific housekeeping exception to ordinary effect-trigger eligibility, **not** a new trigger window, queue behavior, or loop rule. Existing rules governing genuine effect-caused discards continue unchanged. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-138 — Discard classification by originating cause and phase-boundary trigger completion (LOCKED, 2026-11-11)

**Explicit approval:** Classify each discard by its **originating cause**, not by how close it occurs to a phase boundary, Corporation response ending, ICE PASS, Node transition, or routine cleanup. A discard expressly caused by an ICE subroutine, Corporation instruction, CORTEX/SyN damage, Rustler card ability, queued triggered ability, or other independently resolving game effect is an **effect-caused discard**, including when it happens immediately before routine cleanup. Such actual discards retain their normal individual-card occurrences and grouped-event identities (RULE-134), eligible triggers and activation limits, and deferred FIFO resolution (RULE-010–015/133–136). Do not silently reclassify effect-caused discards as housekeeping merely because they happen late in the Corporation response.

**Non-triggering cleanup exception:** A discard is **routine housekeeping cleanup** only when it is performed by the single mandatory post-Corporation hand cleanup operation itself. Under RULE-137, those cleanup discards are logged but do **not** generate, queue, or resolve triggered effects based on being discarded. All remaining non-CACHED cards are discarded in that single housekeeping batch; CACHED cards retain their existing exemption. This exception does not suppress triggers from an effect that actually resolves before cleanup or otherwise change damage-caused discards.

**Strict transition checkpoint:** Complete the entire final Corporation effect, then **fully drain all eligible effect-generated triggers and any chained triggers** under RULE-014–019 and RULE-136 **before** routine cleanup begins. If an effect-generated discard causes a trigger that draws or otherwise adds non-CACHED cards to hand, those cards are present when routine cleanup starts and are discarded as part of its non-triggering housekeeping batch unless separately CACHED or otherwise explicitly protected. No eligible Corporation-generated trigger carries into or across cleanup. After the non-triggering cleanup and its bookkeeping, proceed directly to the established next phase, ICE PASS, or Node transition; no additional routine cleanup or cleanup trigger checkpoint is created.

**Logging and auditability:** Record **effect-caused** and **housekeeping** discards as distinct cause classifications. For effect-caused discards, log the originating effect/source, phase, individual card identities and count, grouped discard event identifier, actual qualifying occurrences, and queued/resolved/cancelled triggers as appropriate. For housekeeping discards, log the phase, card identities and count, reason **ROUTINE CLEANUP / NON-TRIGGERING**, and zero generated triggers. Keep the physical discard record even though housekeeping discards are ineligible for discard-trigger frequency or event counting under RULE-137. Preserve existing source eligibility, card-text limits, and mandatory event bookkeeping; do not invent a new interrupt or reaction window.

**Canonical example:** At the last independent Corporation ICE subroutine, the Rustler has three non-CACHED cards and installed Software: *“Whenever you discard a card, gain 1 CRED.”* The subroutine reads *“Discard 2 cards from your hand. Then gain 2 PULP prevention.”* Two actual effect-caused discards form one grouped discard event and queue two per-card triggers (subject to limits). The subroutine finishes its printed instructions and grants 2 PULP prevention; only at the checkpoint do the two queued triggers resolve, gaining 2 CRED. Routine cleanup then discards the remaining non-CACHED card, records it as **ROUTINE CLEANUP / NON-TRIGGERING**, and generates **no CRED trigger**. If the checkpoint instead draws two new non-CACHED cards, they are also discarded in the same non-triggering cleanup batch.

**Reconciliation and priority:** RULE-138 reinforces RULE-010 printed instruction ordering; RULE-011–015 complete-effect/FIFO trigger ordering; RULE-016–019 loop safeguards; RULE-132 retained defensive hand and single post-response cleanup; RULE-133 nonretroactive effect-generated discard triggers; RULE-134 per-card and grouped event identity; RULE-135 actual damage/prevention trigger eligibility; RULE-136 effect boundaries and complete trigger checkpoints; and RULE-137's explicit non-triggering housekeeping exception. **RULE-137 remains controlling for cleanup-generated non-trigger eligibility.** This rule clarifies classification and logging without restoring superseded cleanup-trigger language in RULE-132–136 or altering established CORTEX/SyN/PULP damage, CACHE, prevention, DRAW, or immediate defeat mechanics. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-139 — Source-removal eligibility during trigger checkpoints (LOCKED, 2026-11-11)

**Explicit approval:** If an installed Software source leaves play **before its queued triggered ability begins resolving**, cancel that source's unresolved queued triggers immediately under RULE-081/082/085, regardless of their earlier event-time qualification. **Reinstalling the same physical Software card does not revive those cancelled triggers** and does not reset previously consumed activation allowances under RULE-066/089. A new installed instance is not a retroactive continuation of the departed source. This rule creates no exception to existing event-time eligibility, trigger frequency limits, or explicit source-validity requirements.

**Already-resolving abilities:** Once a triggered ability **has begun resolving**, removal of its Software source does **not** interrupt or cancel that currently resolving ability. Finish its remaining instructions in the established order under RULE-010/014 and RULE-083/086, while enforcing all explicit conditions, costs, required installed status, and other legal requirements at their specified check times (RULE-003/088). Source removal ends source-dependent continuous effects as already established (RULE-090). Events legally generated by the remaining instructions may still qualify other eligible Software for triggers (RULE-084). Other queued, not-yet-resolving triggers from the removed source are cancelled.

**Checkpoint continuation and FIFO:** During RULE-136's mandatory between-effect checkpoint, cancelling a removed source's pending triggers **does not end the checkpoint** or cancel unrelated triggers from other valid sources. Continue processing the existing FIFO queue, skipping/cancelling ineligible entries, resolving each eligible ability fully before processing triggers it generates, and fully draining eligible chained triggers before advancing to the next independently resolving ICE subroutine, other effect, or phase boundary. Retain simultaneous-trigger ordering (RULE-011–013), FIFO (RULE-014/015), and deterministic infinite-loop detection/termination with preservation of completed effects and unrelated queued triggers (RULE-016–019). The rule creates no reactive Rustler card-play window or new trigger timing window.

**Corporation response and housekeeping:** The same source-removal checks apply to Corporation-response effect-generated trigger checkpoints. Complete all eligible effect-generated triggers before post-Corporation routine cleanup (RULE-136/138). Routine cleanup discards remain **non-triggering housekeeping** outside effect-triggering windows under RULE-137; RULE-139 does not restore any cleanup-generated triggers or add a cleanup checkpoint. Classify and log effect-caused versus housekeeping discards by originating cause under RULE-138.

**Example:** Two installed Software cards, A and B, each qualify from a PULP-suffered event. Their triggers queue in established order. A's trigger begins resolving; a legal effect during its instructions removes A. A's **currently resolving** ability finishes subject to its remaining conditions/costs, but all **other unresolved queued triggers from A** are cancelled. B's unrelated eligible queued trigger remains and resolves in FIFO order; any further eligible chained triggers are fully drained before the next independent subroutine. Reinstalling A later cannot revive its cancelled entries or reset protected usage limits. If A instead leaves play **before its trigger begins**, that pending A trigger is cancelled.

**Reconciliation and priority:** RULE-139 clarifies the interaction of RULE-014/015 completed-effect and FIFO semantics, RULE-016–019 loop safeguards, RULE-066 activation persistence, RULE-081/082/085 queued-source cancellation, RULE-083/084/086 already-resolving effects and generated events, RULE-088/089/090 explicit installed conditions, new installed instances, and continuous effects, and RULE-136–138 checkpoints, non-triggering housekeeping cleanup, and cause-based discard classification. It **does not override** those locked rules; existing card-specific conditions, costs, source identity, timing, and fatal defeat cancellation (RULE-130) remain controlling. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-140 — Historical trigger-event snapshots and current-state resolution checks (LOCKED, 2026-11-11)

**Explicit approval — historical event facts:** When an event occurs, determine which triggered abilities qualify from that event and the applicable game state **at event time**. Preserve an immutable historical record for each queued trigger: originating event identity/type and source, actual qualifying magnitude (not an attempted or nominal amount), affected card/object identities and relevant event-time facts, trigger source/installed-instance identity, and applicable event-time thresholds or limitations. Subsequent changes in VIT, DRAW, resources, prevention, hand, installed Software, or other state **do not retroactively change the original event, its magnitude, or whether the event qualified**. Event grouping and actual-versus-attempted magnitude continue to follow RULE-105–109 and RULE-134/135, including distinct damage and overflow PULP events and individual discard occurrences.

**Explicit conditions and current-state instructions:** Historical qualification **does not freeze the entire future game state**. At the time a queued triggered ability begins resolving, check source validity and any expressly applicable resolution-time conditions, costs, required installed status, activation limits, or other prerequisites against the **then-current** game state. Evaluate later instruction-specific requirements at their specified instruction times. If a discrete instruction computes a variable numeric value such as DRAW or Trace, take the **instruction-start snapshot** required by RULE-098–104, not a queue-entry or event-time snapshot, unless explicit card text or a more-specific rule says otherwise. Preserve any expressly historical value (e.g., “equal to the PULP damage you suffered in that event”) from the original event record; do not recalculate it from current VIT or prevention. Once an instruction starts, keep its applicable snapshot fixed for that instruction. For “for each” instructions, preserve the instruction-start object set and numeric snapshot with existing eligibility protections (RULE-103/104). Continuous effects still update under RULE-090–095; previously completed draws are not retroactively changed (RULE-096/097).

**Previously qualified triggers and cancellation:** An event-qualified trigger remains historically qualified even if the current game state later changes; **mere state change does not cancel it**. Nevertheless, a pending trigger is cancelled if its Software source leaves play before resolution begins under RULE-081/082/085/139; reinstalling the card does not revive cancelled triggers or reset protected activation allowances (RULE-066/089/139). Explicit conditions and costs may cause a previously qualified ability or instruction to fail or be only partially fulfilled under RULE-002/003/088, without rewriting the event history. Once a valid ability begins resolving, its source leaving play does not cancel its already-resolving instructions, subject to explicit requirements (RULE-083/084/086–088/139). At VIT 0, immediate defeat cancels unresolved instructions and queued triggers under RULE-130; the event snapshot does not protect them from defeat.

**Ordering and checkpoints:** Resolve the current independently resolving effect fully before any generated triggers, then process qualified and still-eligible triggers in established simultaneous/controller order and FIFO (RULE-010–015/136). Continue fully draining eligible chained triggers before the next independent effect, subject to RULE-016–019 loop safeguards; source removal only cancels that source's unresolved entries, not unrelated eligible entries (RULE-139). Trigger snapshots do not create an interrupt, reactive Rustler play, or new checkpoint. Before post-Corporation routine cleanup, drain all effect-generated triggers (RULE-136/138); cleanup discards are non-triggering housekeeping outside effect-triggering windows (RULE-137), classified and logged separately (RULE-138).

**Canonical example:** Rustler at 10 VIT suffers an unprevented **PULP 3** event, reaching 7 VIT. Software A reads “Whenever you suffer PULP damage, gain 2 PULP prevention.” Software B reads “Whenever you suffer PULP damage, if your VIT is 10 or less **when this resolves**, gain 1 CRED.” Both qualify at event time and enter the FIFO queue with the historical **PULP 3 suffered** event recorded. A resolves first, gaining 2 prevention; this cannot retroactively reduce the original PULP 3. When B begins resolving, check its explicitly resolution-time VIT threshold against **current** VIT: at 7 it gains 1 CRED; if an intervening legal effect instead raised VIT above 10, that condition fails without undoing B's historical event qualification. If B's source left play before B began, its pending trigger would instead be cancelled under RULE-139. A queued “Draw cards equal to your DRAW” instruction similarly uses current DRAW **when that instruction begins**, not DRAW from the triggering event (RULE-098–101).

**Reconciliation and precedence:** This rule clarifies RULE-010–019 (printed order, simultaneous/controller order, FIFO, complete-effect boundaries, chained triggers, loop safeguards); RULE-081–095 (pending versus resolving source validity, instance identity, explicit conditions, continuous effects); RULE-096–104 (DRAW and variable-value instruction-start snapshots and eligible object sets); RULE-105–109 (aggregate event identity, actual magnitude, threshold qualification); and RULE-134–139 (discard/damage event identity, deferred trigger checkpoints, housekeeping exception, cause-based logging, and source removal). It **does not override** more-specific card text, source-removal cancellation, explicit conditions/costs, existing event granularity, prevention timing, mandatory cleanup, or immediate defeat. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-141 — Target selection, historical object identity, and invalid-target fulfillment (LOCKED, 2026-11-11)

**Explicit approval — instruction-time target selection:** Unless explicit card text or a more-specific locked rule directs otherwise, select the target(s) for a queued triggered ability **when each relevant targeting instruction begins resolving**, **not** when the triggering event occurs or the ability enters the FIFO queue. Determine the eligible target set using the **current game state** at that instruction's start. A newly installed or newly eligible object may be chosen if it meets all current requirements; an object that has left play or become ineligible cannot be chosen merely because it was available at queue entry. Preserve the established RULE-001 authority of the affected player/target to choose how to comply when applicable; this rule does not silently transfer choice to the trigger controller. Respect printed instruction order (RULE-010) and explicit targeting restrictions.

**Historical references are fixed:** If an ability refers to **“that card,” “that Software,” “the card discarded,”** or another object identified by the original triggering event, preserve that object's **historical identity** in the immutable RULE-140 event snapshot. Do not substitute another object automatically if the original moves zones, leaves play, changes status, or becomes unavailable. An ability may affect that historical object only when its instructions and applicable zone, identity, cost, and eligibility requirements legally permit it at resolution time. Historical identity does not guarantee continued target eligibility, return rights, or presence in any particular zone. If card text expressly permits a new or replacement selection, follow that text.

**Invalid targets, costs, and partial fulfillment:** When a required target is missing or ineligible at its instruction's applicable check time, apply RULE-002's **fulfill-as-much-as-possible** and independent-instruction principles, together with RULE-003's distinction between instructions, costs, and conditional effects. Do not automatically cancel an entire already-qualified ability solely because one target or one instruction cannot be fulfilled; continue independent legal instructions in printed order, unless explicit conditions, costs, or more-specific text require otherwise. Do not waive a mandatory cost, fabricate a target, retarget a historical reference, or grant a conditional reward whose required condition fails. If the trigger source leaves play before resolution, cancel its pending triggers under RULE-081–085/139; if already resolving, finish as legally possible under RULE-083–088/139. Previously qualified event-time trigger eligibility remains historical under RULE-140, subject to these validity checks.

**Separate instructions versus one “for each” instruction:** Each **separate targeting instruction** selects eligible targets independently at its own instruction start, unless an earlier instruction explicitly fixes an object that later instructions refer back to. This does **not** alter RULE-104: one discrete “for each” instruction snapshots its eligible processing set **once at that instruction's start**, with existing later-condition, cost, and installed-status protections; do not dynamically add objects during that same instruction. Instruction-start variable numeric snapshots remain RULE-098–103, and separate instructions can use changed current state. Historical event snapshots (RULE-140) and instruction-start target/object-set snapshots are distinct concepts.

**Queue and phase compatibility:** Trigger qualification, controller/simultaneous ordering, FIFO queue discipline, full effect boundaries, and chained-trigger checkpoints remain RULE-010–019/136. Target selection does not create a new interruption or reactive Rustler card-play window. Source-removal and continuous-effect behavior remain RULE-081–095/139. Effect-generated triggers fully drain before routine post-Corporation cleanup (RULE-136/138); housekeeping cleanup remains non-triggering (RULE-137), with cause-based discard logging (RULE-138). Immediate defeat still cancels unresolved effects/triggers under RULE-130.

**Canonical example:** Rustler has Software A, B, and C installed. Two independently eligible queued triggered abilities will resolve in FIFO order. The first instructs removal of an installed Software card, and the applicable chooser removes C. The second reads “Choose an installed Software card. Grant it +2 strength until end of turn.” **Assuming the second trigger's source remains valid**, when its targeting instruction begins only A and B remain eligible; C is not a legal selection. If instead the second ability says “Grant **that discarded Software card** +2 strength,” its event-linked historical card identity remains fixed and no different Software may be substituted; whether the instruction can legally affect the original depends on current zone and explicit card requirements. If the instruction is impossible, independent remaining instructions still resolve to the extent permitted by RULE-002/003.

**Reconciliation and priority:** RULE-141 establishes the default instruction-time targeting convention while preserving RULE-001–003 (chooser, partial fulfillment, conditions/costs); RULE-010–019 (printed order, FIFO and loop safeguards); RULE-081–095 (pending/resolving Software source, installed instances, and continuous effects); RULE-096–104 (instruction-start variable and eligible-object snapshots); and RULE-136–140 (effect checkpoints, non-triggering housekeeping, cause-based discards, source cancellation, immutable event facts and current-state requirements). Explicit card text and more-specific locked rules override this general default where they establish a different target selection or validity timing. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-142 — Physical card identity versus installed-instance identity across zone changes (LOCKED, 2026-11-11)

**Explicit approval — persistent card identity, new installed instance:** Each physical card retains its underlying card identity as it moves between hand, deck, discard, installed play, and other legal zones. **Every installation creates a new installed instance**, even when the same physical Software card is reinstalled. The previous installed instance ends immediately upon leaving play (RULE-089/090). Preserve a stable physical-card identifier separately from an installed-instance identifier and its entry/exit history. A zone change does not by itself make a newly installed instance a continuation of the previous one.

**Historical references distinguish the two identities:** Under RULE-140/141, “that card,” “the card discarded,” and other references to a physical card preserve the original physical-card identity, subject to the instruction's permitted zone, location, costs, conditions, and current eligibility. A reference specifically to “that installed Software,” its prior installation, or an effect tied to that **installed instance** does **not** automatically transfer to a later installation of the same physical card. Do not substitute a different physical card or a new installed instance for a historical target merely because the former target is unavailable. Explicit card text or a more-specific locked rule may authorize a different result. An ability returning an identified card from a specified zone can do so only if that same physical card is legally in the required zone when the instruction resolves; historical identity alone neither moves it nor guarantees eligibility.

**Instance-specific state and no revival:** On departure, the prior installed instance's continuous effects end under RULE-090–095; installation-specific bonuses, modifiers, counters, and other effects attached solely to that instance do not automatically attach to the new installation. Reinstallation **never revives cancelled unresolved triggers** from the departed source (RULE-081/082/085/139), resurrects expired instance-specific continuous effects, or resets protected/consumed activation allowances (RULE-066/089/139). Preserve any effects or counters explicitly defined by their own rules to persist on the physical card across zones; this general rule does not silently erase independently persistent state or create a blanket zone-change reset. A new instance may generate new triggers only from new qualifying events, within existing limits and validity requirements.

**Queued effects, target validity, and resolving abilities:** If an otherwise valid queued instruction references a **specific former installed instance**, removing and reinstalling its physical card does not make the new instance a legal substitute. Apply RULE-141's instruction-time target validity and RULE-001–003 impossibility, costs, and partial-fulfillment rules. If the queued triggered ability's **own source** leaves play before resolution begins, cancel it under RULE-139; reinstallation cannot revive it. An ability already resolving continues as legally possible despite source removal, subject to explicit installed-status conditions and costs (RULE-083/088/139). This rule does not change RULE-102–104's instruction-start variable-value snapshots or fixed “for each” processing sets, nor RULE-140's immutable event facts.

**Canonical example:** A valid separate Software effect queues an instruction “Grant **that installed Software** +2 strength,” referencing installed instance A-1. A legal intervening effect removes A-1, and the same physical card A is later reinstalled as instance A-2. A-2 is **not** A-1; the queued instruction cannot silently apply its +2 to A-2. If the instruction instead references “**that card**” and explicitly permits its present zone and status, it continues to identify physical card A, though it must still meet all current legal requirements when the instruction resolves. Unresolved triggers originating from A-1 were cancelled on removal; no reinstall restores them. This example presupposes the separate effect's source remains valid and all intervening actions are legally permitted by existing timing rules.

**Reconciliation and priority:** RULE-142 confirms RULE-066 (activation allowances), RULE-081–089 (source-removal, already-resolving abilities, and new installed-instance identity), RULE-090–095 (continuous-effect lifecycle and stacking), RULE-102–104 (instruction-time values and eligible processing sets), and RULE-139–141 (pending-source cancellation, historical event snapshots, historical object identity, instruction-time target selection, and invalid-target partial fulfillment). It does not create a reactive play window, alter FIFO checkpoints, restore cleanup-generated triggers under RULE-137, or supersede explicit persistence, zone, target, or card-specific requirements. Immediate defeat and other more-specific cancellation rules remain controlling. **Status: LOCKED, explicitly approved 2026-11-11.**


## RULE-143 — Historical card references cannot bypass specified-zone requirements (LOCKED CLARIFICATION, 2026-11-11)

**Explicit user approval — specified zone is mandatory:** When an ability refers to a historically identified physical card and instructs an action **from a specified zone**, the identified card must actually occupy that specified zone **when the relevant instruction begins resolving and at any later check explicitly required by the instruction**. If the card has moved to another zone, the specified-zone instruction cannot be fulfilled. Historical card identity (RULE-140–142) does not grant permission to retrieve, move, reveal, or otherwise affect the card from a different zone. **Do not substitute another card or a newly installed instance** unless explicit card text or a more-specific rule authorizes substitution. Apply RULE-002/003 and RULE-141: an impossible instruction fails without automatically cancelling other independent legal instructions; required costs and conditions remain binding.

**Canonical example:** An otherwise valid triggered ability reads, “Whenever you discard a Software card, return **that card from your discard pile to your hand**.” Software A is discarded, qualifying the trigger and fixing A's historical physical-card identity. Before that trigger resolves, a legal intervening effect shuffles A from the discard pile into the deck. On resolution, A is **not in the discard pile**. The return instruction **fails**; A **remains in the deck**, and the player may **not** retrieve A from the deck or select another Software card instead. The original discard event and qualification remain historically recorded; inability to fulfill the later instruction does not retroactively undo them.

**Reconciliation and scope:** This clarification preserves RULE-001–003 (choice, partial fulfillment, costs and conditions), RULE-010–019 (instruction order and trigger queue), RULE-081–104 (source validity, installed-instance identity and instruction-time snapshots), RULE-137–140 (cleanup classification, event identity and historical qualification), RULE-141 (instruction-time target validity), and RULE-142 (physical-card versus installed-instance identity). The clarification **does not approve or lock the other proposed RULE-143 policies** on tracking through hidden zones, information disclosure, or player-visible log redaction; those remain open for separate review. Explicit card text and more-specific locked rules retain precedence. **Status: LOCKED clarification, explicitly approved 2026-11-11.**

## EXTRACT-001 — Basic Extractor payout timing, cap, and banking (LOCKED, approved 2026-11-11)

> **Rate superseded by EXTRACT-002 (2026-11-14): Basic Extractor now pays 3 CRED per eligible end turn, not 5.** Timing/capping/banking remain as applicable under the current Core Rules. Original rate examples below are historical.

**Explicit user approval:** An installed **Basic Extractor** is persistent Software, requiring **1 RAM** and **1 BW to install** under TAX-016. Its printed ability is: **“At the end of your Rustler turn, extract 5 CRED from the current ICE encounter's remaining CRED reserve.”** The 5 CRED is a fixed printed payout, not a universal payout for other Extractor profiles.

**Timing:** When the Rustler selects END TURN, enter the established Rustler End-of-Turn Phase. The installed Basic Extractor's end-of-Rustler-turn ability qualifies in that existing window, alongside other eligible end-of-turn abilities, and is ordered and resolved under RULE-010–019, including controller/simultaneous ordering, FIFO, complete-effect and trigger-drain checkpoints, and loop safeguards. It is **not** a newly inserted priority phase or a payout automatically placed ahead of other end-turn effects. Finish eligible end-turn effects and generated triggers, then forfeit remaining BW, then resolve Corporation Response, then perform the single non-triggering post-Corporation hand cleanup under RULE-132/137/138. This reconciles RULE-RT-001–005 with RULE-132's superseding cleanup relocation. The payout occurs **before Corporation Response**, not after survival of it.

**Installation-turn eligibility:** Basic Extractor installed during the current Rustler turn qualifies for payout at that turn's end, provided it remains installed and eligible when the end-turn trigger is generated. No default startup delay applies. If it is unloaded before END TURN, no trigger qualifies. If its source leaves play after qualification but **before** the queued ability begins resolving, cancel that pending trigger; reinstalling the same physical card does not revive it (RULE-081–090, RULE-139/142). Once an ability has begun resolving, apply the existing source-removal continuation rule subject to explicit requirements, costs, and resolution-time conditions; do not invent an unconditional cancellation or revival (RULE-083/088/139–142).

**Finite encounter reserve:** ECON-002's hard **per-ICE-encounter CRED cap** governs every extraction payout. On resolving Basic Extractor's payout, award **min(5 CRED, the current encounter's unextracted CRED reserve)**, never a negative amount. Reduce that reserve by the actual awarded amount; when it is empty, award 0. Multiple legally installed Extractors, if present, use the reserve remaining at their respective resolution times and follow existing trigger ordering; their combined payouts cannot exceed the cap. The encounter cap's exact numerical size and whether it is visible or hidden remain OPEN. Do not impose a new universal limit on installed Extractors or override other Extractor payout profiles.

**Immediate banking:** CRED actually awarded by a resolving Extractor is **banked immediately upon resolution**, with no survival-or-ICE-PASS condition. Subsequent Corporation retaliation does not retroactively revoke already banked CRED. If VIT reaches 0, immediate defeat ends the run and cancels unresolved effects/triggers under RULE-RT-002/RULE-130; no later pending payout resolves. Existing event snapshots, trigger eligibility, resolution-time conditions, and source/target identity restrictions (RULE-136–142) apply without exception.

**Encounter transitions:** Each ICE encounter has its own finite reserve. An installed Extractor that remains legally in play may qualify in a later ICE encounter under its printed ability and the established Node Software lifecycle; no payout occurs outside an eligible current ICE encounter or beyond that encounter's reserve. Whether extraction is possible after ICE PASS, specific reserve sizes, visibility, and more complex Extractor timing profiles remain open except as expressly fixed here. No new out-of-turn Rustler card-play window is created.

**Status:** LOCKED — explicitly approved. Reconciles ECON-002/003; TAX-009/016; RULE-RT-001–005; RULE-010–019; RULE-132; RULE-136–142. All other previously locked rules remain in force.

## GENERALIST-001 — Ten-card starter deck, SYN BUFFER, and Instant PULP shields (LOCKED direction, 2026-11-11)

**Explicit user approval:** The Generalist starts with exactly **10 cards**: (1) FORTRESS Icepick, (2) VOID Icepick, (3) SIGYL Icepick, (4) Basic Extractor, (5) SYN BUFFER, (6–7) two Instant PULP shield cards, and (8–10) three Instant ICE-strength-reduction cards. The first five are persistent installed Software requiring **1 RAM each** and the established **1 BW installation cost**. The Generalist starts with **4 RAM**, so all five cannot be installed simultaneously. The three distinct type-specific Icepicks have no finalized individual strength/break-cost profiles yet. Basic Extractor retains **EXTRACT-001**: 5 CRED at end of each eligible Rustler turn before Corporation Response, eligible on installation turn, hard encounter cap, immediate banking.

**SYN BUFFER — card wording:** **“Once per ICE encounter, when you would suffer SyN damage, this program automatically prevents 1 SyN damage from that damage event.”** It is installed Software (1 BW installation; 1 RAM). Its automatic prevention applies **during damage resolution before the affected SyN is suffered**, before mandatory SyN discards or overflow PULP; it is not a queued after-damage trigger. It prevents neither PULP nor CORTEX. **Each installed copy has its own independent once-per-ICE-encounter allowance**, so multiple eligible copies can each prevent 1 SyN, up to the incoming damage amount. An allowance refreshes **on entering the next ICE encounter**, not on either player's turn start (RULE-027/028 do not reset this encounter-specific allowance). An eligible copy's allowance is consumed only when it actually prevents a point of SyN. An installed copy that remains in play between ICE encounters refreshes for the next encounter, consistent with the Node-long Software lifecycle.

**SYN BUFFER reinstall safeguard:** To prevent unloading and reinstalling the **same physical card** from bypassing its once-per-encounter limit, track the used allowance by physical card identity and encounter identity. A card already used during that encounter remains spent if unloaded and reinstalled; a distinct unused physical copy has its own allowance. This is a **card-specific exception** to otherwise fresh installed-instance identity under RULE-089/142, not a general rule that reinstalled Software retains all instance-specific state. An uninstalled copy cannot prevent damage. All existing eligibility, prevention, source-removal and resolution-time rules remain applicable (RULE-001/004–006, RULE-010–019, RULE-081–090, RULE-127–142).

**Instant PULP shields:** Both remaining Generalist Instant shield cards grant a printed amount of **PULP prevention to the Rustler's existing shared PULP prevention pool** when played during the Rustler turn. They are **not installed**, occupy **0 persistent RAM**, and go to discard after resolving under SOFT-009/010. When the Rustler would suffer PULP, **consume eligible PULP prevention from that pool first**, point-for-point; only the unprevented remainder reduces **Vitae (VIT)**. This restates the already locked unified prevention-pool and prevention-before-damage mechanics (SOFT-013/015, DMG-002, RULE-004–006, RULE-127–136), not a new second shield pool. PULP prevention cannot prevent SyN or CORTEX; those use their own pools. Apply existing expiration at beginning of next Rustler turn and existing earliest-expiring eligible prevention priority. Card-specific shield amounts and printed BW costs are **OPEN**, not implicitly fixed here.

**Unfinalized Generalist card details:** The two PULP shield names, amounts and BW costs; the three ICE-strength-reduction Instants' names, magnitude, duration, and BW costs; and individual Icepick statistics are working concepts only. Earlier illustrative names Fracture, Erode, and Destabilize are **not locked card identities**. This entry locks deck structure, lifecycle classifications, SYN BUFFER timing/independent-copy handling, and PULP-pool behavior without inventing numerical card balance.

**Status:** Approved and recorded. Reconcile with TAX-009/016, ECON-002/003, EXTRACT-001, SOFT-009–015, DMG-002, RULE-004–006, RULE-010–019, RULE-027/028, RULE-081–090, RULE-127–142. Preserve more-specific existing rules and no out-of-turn Rustler card plays.

## ICE-DESIGN-001 / MULTI-ICE-001 — ICE roles, multi-ICE encounters and DEADLOCK gating (APPROVED, 2026-11-11)

**Design direction approved by user:** ICE encounters can contain **one or multiple ICE**. An encounter must have **at least one DEADLOCK subroutine across its ICE**, but **not every ICE needs DEADLOCK**. An individual ICE may have only offensive subroutines (e.g., one PULP or TRACE), only DEADLOCK subroutines, or a mixture. **One ICE may have three separate DEADLOCK subroutines and no damage subroutines**; each is a distinct subroutine to neutralize. There is no fixed one-DEADLOCK-per-ICE or mandatory one-offense-per-ICE rule. A multi-ICE formation can combine a pure blocking ICE with several weaker offensive/support ICE. All active DEADLOCK subroutines in the encounter must be broken, bypassed, or otherwise legally neutralized to qualify for advancement.

**LOOP-002 timing — superseded in part by LOOP-002-SUPERSESSION-001:** Earlier final-response wording in this paragraph is historical and no longer operative. See the later locked BREACHED rule: after the final DEADLOCK is neutralized, the Rustler voluntarily ends the current turn and proceeds to rewards without a final Corporation Response. Historical wording formerly stated: Breaking/neutralizing the last DEADLOCK **does not immediately end the encounter or skip the Corporation's ensuing response**. The Rustler must survive the normal Corporation Response before advancement; applicable **unbroken** offensive subroutines can still fire during that response, while broken subroutines do not fire. After response and required post-response cleanup under RULE-132, advancement is allowed only if no active DEADLOCK remains and the Rustler has survived. No extra Corporation Response is added solely for leaving. If the Rustler remains engaged across turns, active offensive subroutines provide recurring threat during applicable Corporation Responses; use existing subroutine ordering, complete-effect checkpoints, damage/prevention and immediate-defeat rules (RULE-010–019, RULE-RT-001–005, RULE-127–142). Exact ordering of subroutines **across multiple simultaneously engaged ICE**, and any additional encounter-wide sequencing not already specified, remain OPEN; do not silently invent it.

**ICE design identities — tendencies, not absolutes:** **FORTRESSES** generally have the highest strength and comparatively few subroutines, emphasizing PULP and TRACE and/or DEADLOCK; they can instead be pure multi-DEADLOCK blockers. **SIGYLS** generally have lower strength than FORTRESSES and more subroutines, emphasizing SyN, plus PULP and DEADLOCK. **VOID ICE** are generally the deadliest, with highly variable strength and subroutine count and combinations of PULP, SyN, CORTEX, TRACE and/or DEADLOCK. **PULP is a common baseline offensive threat across all three ICE types**, not VOID-exclusive, ensuring Instant PULP shields are routinely useful. Not every ICE needs to deal damage individually, provided encounter formations create meaningful pressure. TRACE should have meaningful consequences when successful; its exact per-card effects are not decided here.

**Weak-ICE design:** Low-strength ICE, including potential **Strength 0** ICE, can remain threatening through offensive subroutines or useful through DEADLOCK. Illustrative, **not finalized**, examples include a weak Paper Cut with PULP, a low-strength TRACE support ICE, a Training Wall with PULP and DEADLOCK, and a pure triple-DEADLOCK FORTRESS. Names, strength numbers, damage numbers, number of ICE per encounter, exact TRACE consequences, and individual card balance remain OPEN. The suggested Strength 2 Training Wall and Strength 3 Triple Lock are examples only, not locked card values. Avoid treating an illustrative subroutine ordering as a universal type template.

**GENERALIST-001 card refinement (approved):** The two Generalist Instant PULP shields are **two copies of the same card**, each costing **1 BW** and adding **3 PULP prevention** to the Rustler's existing unified PULP pool. On incoming PULP, consume eligible prevention before reducing VIT; temporary prevention follows established expiration and duration-priority rules. Generalist cards 8–10 are **three copies of the same Instant ICE-strength-reduction card**, each costing **1 BW**, with printed effect **“Permanently reduce a target ICE's strength by 2.”** Permanent means the reduction does not expire at end of turn or encounter; it persists for that ICE's existing lifecycle, subject to existing ICE-strength floor and modifier rules. Do not treat the former illustrative Fracture/Erode/Destabilize names as three distinct finalized cards. **All 10 Generalist starter cards uniformly cost 1 BW to play/install**: three unique 1-RAM installed type-specific Icepicks, one 1-RAM installed Basic Extractor, one 1-RAM installed SYN BUFFER, two identical PULP-shield Instants, and three identical permanent −2 strength-reduction Instants. The three Icepicks' activation/break costs and printed names, and final names of the two Instant card designs, remain OPEN. Installed Software costs 1 BW to install; Icepick activation is a separate mechanic. SYN BUFFER remains once-per-ICE-encounter prevention of 1 SyN, per independently installed copy, with same-physical-card reinstall not resetting the used encounter allowance (GENERALIST-001). Basic Extractor retains EXTRACT-001.

**Status:** User explicitly requested recording and committing these approved design principles. Preserve existing locked LOOP-002, RULE-132, EXTRACT-001, GENERALIST-001 and other rules; do not interpret examples as approved numerical ICE cards.

## LOOP-002-SUPERSESSION-001 — BREACHED encounter skips final Corporation Response (LOCKED, approved 2026-11-11)

**Explicit supersession:** This decision replaces only the portion of LOOP-002 and related MULTI-ICE-001 text requiring a final Corporation Response after all active DEADLOCK subroutines across every ICE in the current encounter have been neutralized. Earlier statements that the Rustler must survive an ensuing Corporation Response *after* clearing the last DEADLOCK are superseded by this later locked rule. All other existing Corporation Responses during an uncleared encounter remain in force.

**BREACHED state:** Immediately when all active DEADLOCK subroutines across all ICE in an encounter are broken, bypassed, or otherwise legally neutralized, the encounter becomes **BREACHED** (eligible to finish). This does **not** automatically end the Rustler turn or transition to rewards. The Rustler retains control and may continue legal Rustler-turn actions, including playing cards, spending BW, and using installed programs, until voluntarily selecting **END TURN**.

**Completion sequence:** On END TURN while BREACHED, resolve normal eligible Rustler end-of-turn effects (including applicable Basic Extractor payout) and the established BW-forfeiture/end-turn procedures. **Skip the ordinary Corporation Response for this cleared encounter**: no remaining unbroken offensive ICE subroutines execute as a final routine response. Perform the applicable post-turn/encounter housekeeping without manufacturing a response or triggering cleanup effects, then complete the encounter and proceed to the **Reward Step**. No extra Rustler turn, exit action, or final Corporation Response is required. The Rustler must still be alive and all DEADLOCKs neutralized at completion.

**Scope:** This is a universal encounter-clearance rule, not a change to normal offensive subroutine behavior on earlier turns while DEADLOCK remains. It does not authorize automatic victory at the instant the final DEADLOCK breaks, erase damage already resolved, or create an implicit final retaliation. Any exceptional printed on-breach/on-exit card ability would require its own explicit approved wording and timing; none is established here. Preserve RULE-132's non-triggering housekeeping principle, other existing trigger/prevention rules, and voluntary END TURN. Where older documents conflict, this later specific supersession controls.

**Not decided here:** Icepick activation/BW costs, White Picket Fence's finalized card statistics, and any special breach-triggered abilities remain uncommitted proposals.

## TRAINING-001 / ICEBREAK-OPTION-C / BREACH-REWARD-001 — Opening encounter balance and end-turn clarification (2026-11-11)

**Training Node structure — DESIGN DIRECTION, not finalized roster:** Build an introductory Node of three progressively larger encounters: first **one ICE**, second **two ICE**, third **three ICE**. Establish an ICE-strength scale by testing the starter Generalist deck against these encounters before locking a larger ICE roster. Preliminary strengths and ICE names for encounters 2 and 3 remain OPEN.

**First encounter — WHITE PICKET FENCE, PROPOSED card pending final approval:** Generic **FORTRESS**, printed **Strength 3**, with two separate subroutines: **PULP 5** and **DEADLOCK**. It is intended to teach strength reduction, PULP prevention, breaker installation, and breach completion. Two of the Generalist's already-approved 1-BW permanent −2 ICE-strength Instants reduce its current strength from 3 to the applicable floor (provisionally 0), motivating the Strength 3 choice. Do not mislabel this proposed individual ICE as a locked card specification; the user's discussion endorses it as the working first encounter, with balance testing still underway.

**Icepick activation — OPTION C, EXPERIMENTAL / NOT LOCKED:** For a generic installed type-compatible Icepick such as the provisional FORTRESS breaker **Crowbar**, pay the starter card's established **1 BW to install** and occupy **1 RAM**. Proposed activation: **one eligible subroutine break free per installed Icepick per Rustler turn**; **each further eligible break using that same breaker in that same turn costs 3 BW**. Allowance resets on the next Rustler turn. Multiple installed copies would have independent allowances if otherwise legal. Normal subtype and strength requirements apply. The test assumption that Crowbar can break a FORTRESS only when its current Strength is **0** is likewise **PROPOSED**, not a previously locked universal breaker rule. The user's wording about 'first three break' was ambiguous, and this once-free-then-3-BW interpretation was used for costing; retain OPEN status until explicit confirmation. Do not infer that every Icepick has the same activation profile.

**Three-Rustler-turn opening target — BALANCE GOAL:** Generalist starts with 10 cards, normal **DRAW 5**, baseline **4 BW refreshed at each Rustler turn start**, and **4 RAM**. With no DRAW modifiers, the first two draws can expose all 10 starting cards; a third turn draws from the normal discard reshuffle as needed, accounting for installed cards no longer in the draw/discard cycle. Aim for the first encounter to be normally beatable **by the end of Rustler Turn 3**, across varied draw orders, rather than requiring an exact scripted hand. Under the provisional Crowbar rules, two −2 Instants (2 BW), Crowbar installation (1 BW), and two optional PULP shields (2 BW) total **3–5 BW across turns**, plus any optional programs. Free breaks on separate turns can clear PULP and DEADLOCK; the extra 3-BW break is a costly way to accelerate. Starting Vitae and all draw-order survival cases have not been validated, so the three-turn goal is a target, **not a proven guarantee**. PULP prevention is temporary and must be timed to the response it protects against. Optional Basic Extractor (1 BW, 1 RAM) can earn CRED under EXTRACT-001 while competing with defensive setup for BW/RAM.

**BREACH-REWARD-001 — explicit clarification of the LOCKED BREACHED rule:** BREACHED is the **state** entered immediately upon neutralizing **all active DEADLOCK subroutines across every ICE** in the encounter; **BREACH** is the transition event. A BREACH **forces the current Rustler turn to be the encounter's final turn** in the sense that, when the Rustler voluntarily chooses END TURN, the game **automatically proceeds to the Reward Stage after eligible Rustler end-of-turn effects and required non-triggering cleanup**, without a Corporation Response, an additional Rustler turn, an extra exit action, or another confirmation. BREACH **does not forcibly end the Rustler turn at the moment of the last break**: legal Rustler actions may continue until the player selects END TURN. This is the controlling interpretation of LOOP-002-SUPERSESSION-001 and preserves voluntary END TURN. The Rustler must remain alive and the encounter must remain eligible for completion.

**BREACH effect design space — CONCEPT ONLY:** Effects may eventually be worded 'On BREACH', 'While BREACHED', or 'On END TURN while BREACHED'. Distinguish the one-time transition event from the ongoing state. No specific bonus, triggered timing exception, additional BW, CRED, or card text has been approved by this note. In the White Picket Fence test, clearing DEADLOCK on the final Rustler turn suppresses its otherwise unbroken **PULP 5** from firing in a final normal Corporation Response.

**Precedence and scope:** LOOP-002-SUPERSESSION-001 governs over the older LOOP-002 and MULTI-ICE-001 final-response passages; earlier turns with active DEADLOCK still receive normal Corporation Responses. Preserve RULE-132's non-triggering post-response cleanup principle, established Rustler end-turn effects and BW forfeiture, normal deck reshuffling and installation persistence. This note documents approved BREACHED clarification and provisional training/Icepick balance separately; it does **not** silently lock experimental Crowbar stats, three-turn guarantee, or encounter card values.

## GENERALIST-012 / GHOST-SIGNAL-001 — Twelve-card starter deck and anticipatory TRACE defense (APPROVED, 2026-11-11)

**Starter deck size:** Increase the Generalist starting deck from **10 to 12 cards**. Preserve the ten existing card identities, quantities, and approved effects from GENERALIST-001 and MULTI-ICE-001. Add **one unique TRACE-defense Instant** as card 11. **Historical planning note (superseded by GENERALIST-012-FINAL):** Card 12 was initially unassigned; it is now the third identical PULP Shield. Previous descriptions calling the starting deck exactly ten cards are superseded as to total size, but not the existing ten-card composition. This is a deck-design decision, not a declaration that a final 12-card list is complete.

**GHOST SIGNAL (working name; unique Generalist card):** **Instant; 2 BW to play; 0 RAM; one copy in the Generalist starter deck.** Proposed printed effect approved in this discussion: **“Reduce the first TRACE attempt during the Corporation's next turn to 0.”** The Rustler plays it proactively during their own turn under normal timing rules. It affects **only the first TRACE attempt** on the immediately following Corporation turn, regardless of that attempt's printed value; it does not negate subsequent TRACE attempts, remove existing accumulated TRACE, or permanently modify an ICE. If no TRACE attempt occurs during that Corporation turn, the protection expires unused. If the Rustler enters BREACHED and ends the encounter without a Corporation Response, no TRACE attempt occurs and the protection provides no benefit. The TRACE meter's precise 40-point maximum consequence remains OPEN; do not conflate TRACE 4 on an ICE with reaching TRACE 40.

**Temporary card removal — BURNED:** After playing/resolving GHOST SIGNAL, place that physical card in the **BURNED** state for the remainder of the current Node, returning it under the established next-Node card-return procedure; BURNED is the approved state, not a provisional EXILE keyword. The card is usable **once per Node**, not once per encounter; it is not permanently destroyed.

**Training Encounter 2 — WORKING TEST SCENARIO, not a finalized ICE roster:** Two simultaneously engaged ICE, each with one DEADLOCK: **FORTRESS Strength 5, TRACE 4 and DEADLOCK**; **SIGYL Strength 3, two separate PULP 3 subroutines and DEADLOCK**. ICE subroutines are **generally fixed and visible**, permitting the Rustler to plan turns against known threats. Both DEADLOCKs must be neutralized to BREACH; the locked BREACHED end-turn rule then skips the final Corporation Response. The Rustler enters Encounter 2 with potentially **1–4 Software cards already installed** from Encounter 1; those cards persist in play and no longer circulate in the deck, without reducing baseline DRAW. TRACE 4 is intended to be meaningful pressure; the exact TRACE meter interaction and consequence at TRACE 40 are reserved for later definition. Multi-ICE response sequencing remains OPEN; do not assume simultaneous damage or a new ordering rule.

**Icepick strength — DESIGN PRINCIPLE APPROVED; costs and individual stats OPEN:** Each Icepick has its **own breaking-strength rating**, and the compatible ICE's current Strength is compared against that rating to determine eligibility to break its subroutines. Higher breaking strength (e.g., 1 or 2 instead of 0) should generally involve a compensating cost, such as **2 RAM occupied**, greater **BW installation cost**, and/or **1+ BW per subroutine break**. These are possible tradeoffs, not universal tier rules or approved individual starter breaker stat changes. The Generalist's existing starter breaker install cost and RAM usage remain as previously approved unless explicitly revised. The previously discussed free-first-break/3-BW-additional-break model and Crowbar Strength 0 remain **experimental**, not locked by this entry.

**Balance status:** Twelve cards, the one unique 2-BW TRACE-defense Instant, its next-Corporation-turn/first-attempt-only effect, and its once-per-Node removal are approved for documentation. The twelfth card, GHOST SIGNAL's final name, precise keyword naming, Encounter 2's final ICE statistics, Icepick individual strength/costs, TRACE-40 consequence, and encounter pacing are not yet finalized. Do not present provisional scenario data as locked balance outcomes.

## GENERALIST-012-FINAL / TRAINING-CRED-SCALE-001 — Completed starter deck and difficulty-scaled encounter reserves (APPROVED, 2026-11-11)

**Completed Generalist starter deck — 12 cards (APPROVED):** 1 FORTRESS Icepick, 1 SIGYL Icepick, 1 VOID Icepick, 1 Basic Extractor, 1 SYN BUFFER, **3 identical 1-BW Instant PULP Shields (+3 temporary PULP prevention each)**, **3 identical 1-BW Instant permanent −2 ICE Strength reductions**, and **1 unique 2-BW GHOST SIGNAL (working name)**. Total: **5 persistent Software + 6 basic Instants + 1 unique TRACE-defense Instant = 12 cards**. The third PULP Shield fills the previously unassigned twelfth slot; it is an additional copy of the existing card, not a new effect. All other printed costs, RAM, timing and card lifecycle rules remain as previously established. The older GENERALIST-012 statement that the twelfth card is unassigned is now superseded. The older ten-card starter-deck total is also superseded; preserve its original ten card identities and effects.

**Training Node extraction economy — approved scaling principle:** The introductory ICE Node contains **three encounters/layers**. Each encounter has its **own finite maximum extractable CRED reserve**, as already required by ECON-002. **As a general design rule, increase the encounter's maximum extractable CRED with the difficulty of its ICE layer**; the second layer should offer more than the first, and the third more than the second, reflecting escalating danger, required setup, and time under Corporation pressure. This is an approved balancing principle, **not yet a locked numeric reserve table or a universal mathematical formula**. Exact reserves for Training Layers 1–3 remain to be tested/approved. Do not conflate reserve cap with guaranteed payout or grant the entire reserve automatically on BREACH.

**Extractor compatibility:** Preserve EXTRACT-001: Basic Extractor costs 1 BW to install, occupies 1 RAM, and extracts **up to 5 CRED** from the current encounter's remaining reserve at the end of each eligible Rustler turn (including its installation turn and the final Rustler turn while BREACHED), immediately banking only the actual extracted amount. Unextracted reserve is not automatically awarded. The BREACHED completion rule still skips the final Corporation Response. More valuable encounters may invite deliberately extending exposure for extraction; any numeric reserve should be evaluated against actual encounter duration and risk. No change is made to previously established extraction frequency, triggers, or banking.

**Status:** Starter deck composition and general difficulty-scaled per-encounter reserve direction approved and committed. Exact CRED maximums and remaining ICE/breaker balance are OPEN until further discussion.

## TRAINING-NODE-LESSONS-001 — Intent-first tutorial design and first ICE Node (APPROVED DIRECTION, 2026-11-11)

**Design method:** Define what the encounter must teach **before** finalizing its ICE layout. Each training encounter has one primary lesson, supported by readable consequences and a chance for the Rustler to apply the learning. Teaching a rule is not the same as merely requiring the player to use it. The first ICE Node has three increasingly complex ICE encounters: (1) understand ICE Strength, breaker eligibility, DEADLOCK and BREACH; (2) understand installed Software, deck thinning/cycling, multiple ICE and managing BW/RAM; (3) assess the full formation, prioritize mandatory obstacles over optional damage prevention, prepare across turns, and choose a timely BREACH over reflexively shielding or farming CRED. NUL/REM may deliver contextual hints rather than pre-solving the encounter. These are design objectives, not mandatory tutorial dialogue.

**Training encounter CRED reserves (APPROVED FOR THIS TEST NODE):** Encounter 1 **15 CRED**, Encounter 2 **25 CRED**, Encounter 3 **40 CRED**, each an independent finite maximum; 80 CRED total potentially extractable. Preserve ECON-002 and EXTRACT-001: Basic Extractor awards up to 5 CRED per eligible Rustler end turn from the current encounter's remaining reserve, including the final BREACHED turn; unextracted CRED is not awarded on BREACH. These numerical caps are **test-node settings**, not a universal difficulty-to-CRED formula. The general direction is higher difficulty => larger reserve, with extraction balanced against additional exposure.

## TRAINING-ICE3-001 — Three-ICE teaching encounter (WORKING TEST CONFIGURATION, 2026-11-11)

**Primary lesson:** Prioritize disabling the support ICE's strengthening effect, preparing a compatible breaker over multiple Rustler turns, and neutralizing the VOID's **two** DEADLOCKs. Not every offensive subroutine needs to be broken. Repeated defensive card plays can worsen the true obstacle; sometimes accepting incoming PULP and foregoing CRED is strategically safer than prolonging exposure. This is an intended teaching outcome to validate in playtests, not a claim that every draw order has a guaranteed low-VIT-loss solution.

**ICE 1 — VOID (working Strength 3, not finalized):** [S1] DEADLOCK; [S2] PULP 5, DEADLOCK. These are **two separate subroutines each containing DEADLOCK**; both must be broken/neutralized to BREACH. Breaking S2 also prevents its PULP 5 when it would resolve. Proposed reactive ability: **gain +1 or +2 Strength whenever the Rustler plays a card of a designated defensive/Hardware umbrella type**; exact magnitude, whether the bonus is permanent for this encounter, and precise qualifying card taxonomy are **OPEN**. The earlier illustrative +2 per Shield was not locked.

**ICE 2 — SIGYL (working Strength 5):** [S1] increase the VOID's Strength by **2**. Rustler's intended first step is to break this support subroutine with a SIGYL Icepick, preventing later applications. **Duration and timing** of the +2 VOID modifier, whether repeated applications stack, and Corp Response ordering are OPEN; do not silently make this modifier temporary or permanent. This ICE has **no DEADLOCK in the working layout**.

**ICE 3 — SIGYL (working Strength 3):** [S1] PULP 3; [S2] TRACE 3. Neither is a DEADLOCK in this working layout. Exact TRACE accumulation/consequences remain as previously open. Multi-ICE response ordering remains OPEN.

**Intended route, subject to verification:** (1) weaken ICE 2 or boost its breaker sufficiently to break the +2-Strength support subroutine; (2) lower VOID Strength with permanent −2 ICE Strength cards and/or boost the VOID breaker over successive Rustler turns until eligible; (3) spend 1 BW per VOID subroutine to neutralize both DEADLOCKs, then END TURN while BREACHED and skip the final normal Corporation Response. Optional PULP/TRACE subroutines on other ICE may remain unbroken. Test against actual card draws, existing installations, BW refresh, persistent ICE Strength reductions, remaining RAM, and damage before calling it optimal.

## BREAKER-STARTER-001 — Generalist VOID and SIGYL breaker profiles (APPROVED, 2026-11-11)

**VOID Icepick:** Persistent installed Software, **1 BW install, 1 RAM**, **base breaking Strength 0**. **Spend 1 BW: increase this Icepick's breaking Strength by 1** for the remainder of the **current ICE encounter**. **Spend 1 BW: break one subroutine** of a compatible VOID whose current Strength is no greater than this breaker's current breaking Strength. Each subroutine break is a separate 1-BW use. The breaker may be boosted over multiple turns; its accumulated boosts expire at the end of the current ICE encounter, while the Software remains installed for the Node.

**SIGYL Icepick:** Persistent installed Software, **1 BW install, 1 RAM**, **base breaking Strength 3**. **Spend 2 BW: increase this Icepick's breaking Strength by 1** for the remainder of the **current ICE encounter**. **Spend 1 BW: break one subroutine** of a compatible SIGYL whose current Strength is no greater than this breaker's current breaking Strength. Boosts accumulate across Rustler turns during the same encounter and expire at encounter end; installation persists through the Node.

**Interaction and supersession:** These two approved individual breaker profiles supersede any incompatible *experimental* free-first-break/3-BW-subsequent-break pricing **for these two breakers**. They do not set FORTRESS breaker stats or universal breaker pricing. Boosted breaking Strength belongs to the installed breaker, not to ICE Strength, and does not alter the ICE's own Strength or permanently carry to the next encounter. No free first break is assumed for either approved breaker. Normal BW refresh (4 per Rustler turn), RAM limits, card-play timing and BREACHED end-turn rules continue to apply.

**Example BW budget, conditional on working STR 3 VOID and STR 5 support Gate:** 1 BW to install each of two breakers (2), 1 BW for one −2 Strength card on support Gate, 1 BW to break its support subroutine, 1 BW for one −2 Strength card on VOID, 1 BW to boost VOID breaker from 0 to 1, and 2 BW to break both VOID subroutines = **8 BW total across turns**. This excludes optional cards, the third ICE, existing installations and all Corporation Responses. It demonstrates feasibility in aggregate, **not** guaranteed turn-by-turn reachability or low damage.

## CARD-TAXONOMY-TRAINING-001 — One-shot shield umbrella type (OPEN DESIGN CHOICE, 2026-11-11)

**User proposal, not yet approved as a universal rule:** Give the existing +3 PULP Shield Instants and potentially similar cards a shared **card type**, possibly **Hardware that is not persistent**. The Encounter 3 VOID would then react to each **Hardware** card played rather than to an arbitrary card name. A +1 STR per qualifying Hardware played or +2 STR per qualifying Hardware played trigger are both under consideration; neither magnitude is finalized. Specify whether the trigger counts card plays, installations, or both; whether Hardware is a type versus a subtype/tag; whether it includes installed persistent Hardware; whether strength gains last until encounter end; and whether the effect triggers only while VOID is active. Do not reclassify all Instants as Hardware, equate Instant timing with a card type, or change existing persistent Hardware rules without a further decision.

**Remaining OPEN items before a rigorous Encounter 3 simulation:** FORTRESS Icepick profile; final VOID initial Strength and reactive bonus magnitude/duration; precise Hardware/defense umbrella taxonomy; support SIGYL +2 modifier duration/stacking; multi-ICE Corp Response ordering; third ICE TRACE 3 resolution and TRACE 40 consequence; starting VIT baseline; full draw/reshuffle and opening installed Software state; and numerical viability of the intended low-damage route. Preserve the distinction between approved breaker costs/boost duration, approved 15/25/40 test-node reserves, and provisional ICE numbers.

## TAX-REFORM-001 — Card nature, lifecycle, subtype; Hardware need not persist (APPROVED, 2026-11-11)

**User-approved classification principle:** A card's **type** describes what it is and generally what it does; **lifecycle** describes how it behaves in play; **subtype** describes its more specific role or capability. These dimensions must not be conflated. **Hardware is a card type, not a synonym for installed or persistent equipment.** Both Hardware and Software can be **persistent** or **nonpersistent/Instant**. Do not assume that an Instant is Software, that all Hardware must be installed, or that all Software must persist. A subtype (Icepick, Virus, Extractor, Shield, etc.) does not itself define the lifecycle. Multiple applicable subtypes remain possible under SOFT-001.

**Precedence over TAX-004/TAX-016 and related older shorthand:** Existing **persistent installed Hardware** still costs 1 BW to install and 1 BW to uninstall, remains in play through the Node, returns to the deck at Node end, and does not reduce DRAW. These installation, uninstall, and persistence rules are **specific to persistent Hardware**, not universal to every card with Hardware type. **Instant Hardware** is played from hand, pays its printed play cost, resolves its effect, and goes to discard unless a card explicitly specifies another destination; it is not installed, occupies no persistent RAM by default, and is not subject to the 1 BW Hardware installation/uninstallation charge. Preserve effect-specific expiration rules. Existing persistent Software installation, RAM and unloading rules remain in effect for persistent Software, while Instant Software retains its instant-play lifecycle.

**New Generalist classifications (APPROVED):** SYN BUFFER is **Persistent Hardware**, subtype defensive utility/defense, not persistent Software. The three identical +3 PULP-prevention Shields are **Instant Hardware**, subtype Shield/Defense, not Instant Software. The three identical -2 ICE Strength Instants are now named **PROBE**, **Instant Software**, subtype reconnaissance/intelligence; printed effect remains **1 BW: reduce target ICE Strength by 2**, stacking with other PROBE reductions, with the already-established lasting reduction on that ICE for the current encounter. PROBE is a card name; it does not automatically create a universal SCAN keyword or reveal-hidden-information rule. The other Generalist cards retain their existing classification unless explicitly changed.

**SYN BUFFER resource-cost caution:** Reclassification does not itself decide whether SYN BUFFER's former **1 RAM** requirement is removed or retained as an exception. **RAM requirement is OPEN for rebalancing**; preserve the previously printed 1 RAM provision provisionally until a specific decision is made. Do not silently give the Rustler an additional RAM slot. SYN BUFFER still costs 1 BW to install and automatically prevents 1 SyN from one damage event once per ICE encounter per physical card; its once-per-encounter use does not reset by reinstalling it.

**PULP Shield:** Three copies; **Instant Hardware**; each costs **1 BW** to play and adds **3 temporary PULP prevention** to the shared prevention pool; the existing prevention consumption, expiry and discard rules remain unchanged. A shield is not installed merely because its type is Hardware.

**Approved 12-card Generalist starter deck (revised classification):** 1 FORTRESS Icepick (Persistent Software); 1 SIGYL Icepick (Persistent Software); 1 VOID Icepick (Persistent Software); 1 Basic Extractor (Persistent Software); 1 SYN BUFFER (Persistent Hardware); 3 identical PULP Shields (Instant Hardware); 3 identical PROBE cards (Instant Software); 1 GHOST SIGNAL (Instant Software, unique, existing once-per-Node removal from draw cycle). Total **12 physical cards**. This replaces older 10-card and outdated classification descriptions, not the approved individual card effects or costs.

**Open taxonomy redesign, not yet a rule:** The user is considering a second, function-first classification comparable to Slay the Spire's Attack / Skill / Power / Status / Curse. Do not presume PANOPTICON has only two total card types: Hardware and Software are currently the two established **Rustler-deck nature types**, while CAPS, Ghostware, PATCHWORK, and special/reward cards have distinct rules; the classification of Corporation-inserted negative cards (e.g. transient Status versus persistent Curse) has **not yet been approved or comprehensively defined**. Future functional classes, card-frame shapes, interaction with Hardware/Software, and whether hostile cards are a third nature type are OPEN. The user-proposed VOID trigger referencing **Hardware played** remains an encounter-design proposal; whether +1 or +2 STR, duration, and trigger timing are still OPEN. Reclassifying Shields/SYN BUFFER does not silently finalize that trigger.


## 41. Operating behaviour taxonomy — Executable / Protocol / Packet / Bloatware (APPROVED, 2026-11-11)

**Terminology and scope:** These four names are approved operating-behaviour classifications for cards. They are distinct from the established Hardware/Software nature classification and from functional subtypes. Use **Rustler**, **Console**, and **Icepick** terminology. This section supersedes the older, expressly open taxonomy discussion at the end of the preceding section; it does not silently change the existing individual card costs or effects.

- **Executable:** A card installed into the Console that occupies RAM. It may have manually activated, passive, automatic, or triggered abilities; activation style does not determine its operating type. **Icepicks, Basic Extractor, and SYN BUFFER are Executables.** In particular, SYN BUFFER's automatic protective effect does not make it a Protocol. Executables may be Hardware or Software.
- **Protocol:** A card deployed from hand into the **RACK**, the dedicated visible area for active Protocols. It occupies **no RAM** and has a BW deployment cost as printed. **Under current mechanics, deployed Protocols remain active throughout the Node; there is no existing way to deactivate, suspend, remove, or expire them during that Node.** At the **end of the Node, all deployed Protocols return to the Rustler's deck** for the next Node, without passing through the discard pile. **Deployed Protocols never enter the discard pile.** Card text may eventually specify a different duration, but no such Protocol currently exists; its handling would require explicit future rules rather than an assumed expiration zone.
- **Packet:** A single-use deck card played from hand without installation; it resolves its instructions and then leaves play under its applicable card rules. Its effects may persist beyond the card's resolution. Current examples: **PROBE, PULP Shield, GHOST SIGNAL**. This classification does not automatically apply to CAPS, which are outside the Rustler deck.
- **Bloatware:** The approved name for **Corporation-inserted hostile cards** that contaminate or interfere with the Rustler's deck/card cycle. Specific insertion, triggering, and early-removal rules remain **OPEN**; Bloatware persists no longer than its current Node and all remaining copies are removed at Node end. Do not assume every Bloatware card has the same triggers or effects.

**Protocol lifecycle (currently):** Hand → **RACK** (deployed, visible, active, zero RAM throughout the Node) → **Rustler deck at Node end**. No discard step after deployment and **no separate expired-Protocol zone** under current rules. All Protocols in the RACK are visible and inspectable. The RACK is specifically the Protocol deployment area; distinguish it from the existing Ghostware rack.

**Classification examples:** Icepicks = Executable; Basic Extractor = Executable despite automatic earnings; SYN BUFFER = Executable despite passive/automatic protection; PROBE / PULP Shield / GHOST SIGNAL = Packet. No existing card has yet been specifically approved as a Protocol.

**Preserve unresolved design questions:** The exact physical placement/size of the **RACK**, Bloatware's individual card triggers and early removal, possible future exceptions to Protocol duration and their handling, and interactions with future card effects remain to be designed.


## 42. Bloatware — ICE delivery, card-specific triggers, and persistence (APPROVED, 2026-11-11)

**Bloatware** is the approved operating-type name for hostile Corporation-inserted cards that contaminate or interfere with the Rustler's deck and operations.

- **Primary delivery:** Bloatware enters the Rustler's deck primarily through **ICE abilities and subroutines**. Other sources are possible but not yet defined.
- **Insertion location:** The delivering ICE ability or subroutine determines the destination or placement of the inserted Bloatware card; there is no universal insertion location.
- **Activation:** Triggers are **card-specific**, not universal. Possible printed triggers include **on draw, while held in hand, on discard, at end of turn, and on reshuffle**. A card may have multiple triggers or effects if printed.
- **Hand-based effects:** Some Bloatware may impose **continuous effects while in the Rustler's hand**, without needing to be played or manually activated. In particular, some Bloatware **enhances the Corporation's ICE while held in the Rustler's hand**. The specific ICE enhancement, scope, timing, and numerical strength are defined by each card, not globally.
- **Removal and persistence:** Both are **card-specific**. Some Bloatware can disappear after triggering, while others can remain through subsequent draws or reshuffles. Bloatware never carries into another Node: remaining copies are removed at Node completion. Card-specific effects can remove individual copies earlier, including by moving them to the BURNED state.
- **Stacking (APPROVED):** **Bloatware effects stack per physical copy by default**, including continuous ICE-enhancing effects and triggered effects. Each copy independently applies its full effect when its own conditions are met. For example, if a Bloatware card says **“At the end of the Rustler's turn, if this card is still in the Rustler's hand, deal 2 PULP to the Rustler,”** then three copies held in hand deal **6 PULP total** (2 PULP per copy). Likewise, three copies each granting Corporation ICE +1 STR while held grant **+3 STR** in total. Explicit card text may override default stacking. These examples illustrate the rule; they do not approve specific new cards.
- **Illustrative only:** A hypothetical card that gives Corporation ICE +1 STR while held is an **example, not an approved card or balance value**.

**Still open:** Exact early-removal mechanics for individual cards, per-card insertion and triggers, and concrete Bloatware designs. **Node-end removal is mandatory** for all Bloatware; there is no cross-Node carryover.


## 43. PULP damage terminology (LOCKED, 2026-11-11)

**User decision:** Rename the Rustler's physical/Vitae damage type **BURN** to **PULP** throughout current damage rules, examples, protection pools, and damage-specific card wording. E.g. **5 PULP** reduces Vitae by 5 before applicable PULP prevention; a Rustler may be described as **pulp'd**. **BURNED** remains the distinct card state for temporarily removing a card from the draw/discard cycle. The **BURNED** state and its next-Node return rules are not renamed or mechanically altered. Historical rule identifiers such as **BURN-001** are unchanged. Prior references to BURN as a damage type should be read as PULP; do not conflate PULP damage with BURNED cards. This terminology rename does not change damage calculations or shield functionality.


## RULES-CONSISTENCY-AUDIT-2026-11-11 — Current implementation precedence (LOCKED reconciliation)

This section reconciles earlier dated design entries; older locked decisions remain historical records, but the later approved revisions below govern implementation. This is a consistency correction, not approval of new card mechanics.

1. **Damage:** PULP is the Vitae-reducing physical damage keyword, including SyN/CORTEX overflow damage, shields, prevention, damage events, and triggers. SyN and CORTEX retain their existing effects, prevention, overflow rates, and fixed resolution order **CORTEX → SyN → PULP**. BURNED is exclusively a card-removal state, not a damage type. Do not convert ordinary narrative verbs such as “burn a CAP” into damage terminology.
2. **BREACHED:** Neutralizing every active DEADLOCK across the encounter enters BREACHED immediately; the Rustler may continue legal actions and voluntarily END TURN. Resolve eligible end-turn effects and housekeeping, **skip the final ordinary Corporation Response**, and proceed to rewards. Earlier LOOP-002 / MULTI-ICE-001 final-retaliation wording is superseded.
3. **Generalist starter deck:** The current approved **12 cards** are one FORTRESS Icepick, one SIGYL Icepick, one VOID Icepick, one Basic Extractor, one SYN BUFFER, **three identical PULP Shields**, **three identical PROBE**, and one unique GHOST SIGNAL (working name). This supersedes the former 10-card starter and two-shield quantities. All three Shields are **1-BW Instant Hardware Packets** granting **3 temporary PULP prevention** each; all three PROBE are **1-BW Instant Software Packets** permanently reducing a target ICE's strength by 2 for that ICE's lifecycle. GHOST SIGNAL is a **2-BW Instant Software Packet** that reduces the first TRACE attempt on the immediately following Corporation turn to zero; its temporary removal is **BURNED** for the remainder of that Node, with return at the next Node under existing BURNED rules. Do not use provisional EXILE as a separate state.
4. **SYN BUFFER:** Persistent **Hardware**, operating type **Executable**, costs 1 BW to install; its existing **1 RAM** cost remains provisional until explicitly changed. Its automatic once-per-ICE-encounter 1 SyN prevention, independent-copy handling, and same-physical-card reinstall safeguard are unchanged. It is not a Protocol or Instant Software. Icepicks and Basic Extractor are Persistent Software Executables; Protocols use the RACK, no RAM, and persist through the Node unless future approved rules say otherwise.
5. **Bloatware:** Hostile Corporation-inserted Bloatware is **Node-specific**, may persist across ICE encounters/layers within that Node, and **does not persist into another Node**. At Node completion, remove all remaining Bloatware copies from the Rustler's card cycle; earlier statements that Node carryover is undecided are superseded. Delivery destination, printed triggers, card-specific earlier removal, and numerical effects remain card-specific. Multiple physical copies stack independently by default, including hand-held ICE buffs and end-turn PULP. If printed to start in discard, insert there; if printed to become BURNED after its hand/end-turn effect, apply that card-specific instruction, and do not return it to the current Node's draw/discard cycle. Do not mistake Bloatware removal for PULP damage.
6. **Economy and timing:** Each ICE encounter has its own finite extractable CRED reserve; Basic Extractor pays up to 5 CRED from that remaining reserve on each eligible Rustler end turn, including the final BREACHED turn, and banks the payout immediately. Training Node test reserves are 15 / 25 / 40 CRED across its three encounters. End-of-turn effects resolve before BREACHED completion; no routine Corporation Response is inserted after BREACH.
7. **Scope and open items:** The approved VOID and SIGYL Icepick profiles in BREAKER-STARTER-001 supersede older experimental pricing for those breakers only. FORTRESS Icepick statistics, GHOST SIGNAL's final name, and explicitly marked working ICE/test-balance figures remain open. Historical paragraphs describing prior proposals are not alternative live rules; follow this reconciliation and the later approved sections it cites.


## MULTI-ICE-002 — Left-to-right Corporation Response execution (LOCKED, approved 2026-11-11)

**ICE placement:** The **main ICE is always the right-most ICE** in each encounter. Any supporting/secondary ICE occupy positions to its left. This is the encounter's displayed ICE order.

**Normal Corporation Response:** Begin with the **left-most ICE** and move **one ICE at a time from left to right**. For the current ICE, resolve each **unbroken, otherwise eligible subroutine individually from top to bottom**, in its printed/displayed order. Skip broken or otherwise neutralized subroutines. Complete that ICE's subroutine sequence before advancing to the ICE immediately to its right. Continue through the **right-most main ICE**, which resolves last. Effects from an earlier resolved subroutine apply according to their normal timing and duration, and may affect later subroutines or ICE; do not execute all ICE simultaneously or allow either player to freely reorder them.

**Preserved rules:** Apply the established per-subroutine timing, prevention, trigger queues, resolution-time validity, and immediate defeat rules as normal. This ordering does **not** invent a new modifier duration, stacking rule, TRACE consequence, or special DEADLOCK effect. All active DEADLOCKs across all ICE still must be neutralized to BREACH. If the encounter is already **BREACHED** when the Rustler ends the turn, the locked LOOP-002-SUPERSESSION-001 exception **skips the entire ordinary Corporation Response**; do not run this left-to-right sequence after BREACH. Earlier descriptions marking multi-ICE Corporation Response ordering OPEN are superseded by MULTI-ICE-002.


## TRACE-001 — Cumulative TRACE meter and warning threshold (LOCKED, approved 2026-11-11)

**TRACE is a cumulative tracking value against the Rustler**, represented by a meter with significant **50% and 100% marks**, not an opposed skill check. Corporation ICE subroutines, Bloatware, and other explicitly printed effects add their specified TRACE amounts to the Rustler's accumulated TRACE. Rustler effects may reduce an incoming TRACE addition before it is applied, or lower TRACE already on the meter, as specified by the effect. Use the normal MULTI-ICE-002 left-to-right/top-to-bottom Corporation Response order for TRACE-bearing subroutines and established card-effect timing for other TRACE sources. Do not treat a printed TRACE addition as an automatic opposed contest.

**50% TRACE — warning only (Option C):** Reaching, exceeding, or crossing the **50%** meter mark **does not itself cause an automatic penalty, Corporation Response, extra defense, damage, or other trigger**. It is a visible warning and a condition that **individual printed card effects may explicitly check** (for example, effects worded to apply while TRACE is at or above 50%). Such effects operate only under their own printed conditions and existing timing/trigger rules. Repeated crossings of 50% do not independently generate events or penalties.

**100% TRACE — location compromised:** At **100%**, the Corporation **identifies the Rustler's location** and **deploys additional defenses intended to eliminate the intruder**. This escalation is approved in principle, **not an automatic declaration of Rustler defeat**. The exact deployment package, its timing and duration, whether TRACE can subsequently be reduced, and whether/how another 100% crossing matters remain **OPEN**; do not invent these mechanics. The 50% warning rule does not dilute the approved 100% location-compromise consequence.

**Interaction with GHOST SIGNAL:** The approved unique GHOST SIGNAL Packet reduces the first TRACE attempt/addition during the Corporation's immediately following turn to zero, consistent with its printed first-attempt-only wording; it does not automatically reset the Rustler's existing accumulated TRACE or negate later TRACE additions. Its BURNED once-per-Node lifecycle is unchanged. Exact normalization of legacy TRACE terminology (including older TRACE 40 examples) to meter units/percentage, TRACE cap/floor and persistence/reset between encounters/Nodes remain **OPEN**. No percentage-to-printed-value conversion is approved here.

**Precedence:** This section supersedes earlier notes describing TRACE accumulation, 50% consequences, or the nature of TRACE resolution as wholly undecided. It preserves all existing damage, BURNED, BREACHED, Bloatware, and Corporation Response rules.


## TRACE-002 — Corporation-dependent TRACE persistence and reset (LOCKED, approved 2026-11-11)

**Corporation scope:** The Rustler's accumulated TRACE belongs to the **Corporation currently being encountered**. TRACE is not reset merely because the Rustler moves between ICE encounters/layers or Nodes **within that same Corporation**; accumulated TRACE carries forward and remains subject to TRACE-001 countermeasures and thresholds.

**New Corporation:** When the Rustler **encounters a new Corporation**, initialize the TRACE meter for that Corporation at **0**. TRACE accrued against the preceding Corporation does **not transfer** to the new Corporation. The 50% warning and 100% location-compromise thresholds apply to the current Corporation's meter.

**Not decided:** Whether returning later to a previously encountered Corporation restores its earlier meter or starts a fresh tracking session, and the exact 100% defense-deployment mechanics, are not established by this decision. Do not assume a global run-wide TRACE meter or an ICE/Node reset.


## TRACE-003 — Returning to a previously encountered Corporation resets TRACE (LOCKED, approved 2026-11-11)

**Fresh intrusion reset:** Whenever the Rustler begins a **new encounter with a Corporation after having left that Corporation**, initialize that Corporation's TRACE meter at **0**, **even if the Rustler encountered that same Corporation earlier in the run**. Do not restore any TRACE accumulated during the earlier visit. TRACE continues to accumulate across ICE encounters and Nodes **during one uninterrupted visit** to the same Corporation; moving between its internal ICE layers or Nodes does not trigger a reset.

**Precedence:** This explicitly resolves the return-visit question left open in TRACE-002. Read TRACE-002's “new Corporation” reset together with this rule: a newly entered Corporation **or a fresh return visit** starts at zero. TRACE-001's 50% warning-only and 100% location-compromise rules remain unchanged; the 100% deployment specifics remain OPEN.


## RUN-003 — Forward-only run progression reaffirmed (LOCKED, 2026-11-11; see original RUN-003)

**Baseline navigation rule:** During a run, the Rustler **always progresses forward and never retraces their steps**. After leaving or completing an ICE encounter, Node, or Corporation, the Rustler cannot navigate backward to revisit that completed location or reverse the route. This is a run-level navigation constraint, not a restriction on taking multiple Rustler turns within an active encounter or on revisiting a Corporation in a separate new run.

**TRACE reconciliation:** TRACE accumulates through consecutive ICE encounters and Nodes within the currently visited Corporation and resets to **0 when entering a new Corporation**. TRACE-003's earlier hypothetical rule for returning to a previously encountered Corporation is **non-operative during normal forward-only navigation** because the Rustler cannot backtrack to a completed Corporation. Keep TRACE-003 as a historical clarification for any future explicitly approved exception, not as permission to retrace a route. No such exception is approved here.

**Scope:** This rule does not prescribe the number of encounters, Node topology, branching choices at unvisited forward paths, or a reverse-navigation mechanic. Do not infer any ability to backtrack from encounter-selection, logging, rewind/debugging, or prior design examples.


## RUN-003 / RUN-004 — Existing junction and forward-route rules reaffirmed (2026-11-11)

**This is a reconciliation of pre-existing approved rules, not a new choice.** Every corporate **Node is a junction offering multiple selectable forward paths**. The Rustler chooses the next forward route at each Node; previously passed Nodes lock behind the Rustler and **cannot be revisited** in that run. The network is presented as a circuitous, disorienting **lattice**, but apparent visual loops do not permit mechanical backtracking. A Node can present up to **five or six onward options**; that is an upper example, not a fixed required number. **Every available forward route reaches the Corporation core, and all complete routes contain the same number of Nodes**; there are no selectable dead ends or shortcuts in Node count. These principles were already established as RUN-002 (visual topology), RUN-003 (forward-only traversal and route choices), and RUN-004 (equal-length guaranteed core routes) in the master design on 2026-11-10.

**Identifier reconciliation:** The later section titled “RUN-001 — Strict forward-only run progression” (2026-11-11) repeats the substance of existing **RUN-003**, and its identifier must **not** supersede the earlier **RUN-001 — Victory condition**. Treat that later section as a historical reaffirmation of RUN-003, **not** a second independent RUN-001. Any older OPEN notes suggesting backtracking, Node revisits, junction route selection, dead ends, or unequal path lengths are superseded by these locked rules. Do **not** re-open these settled questions without an explicit request to revise them. TRACE continues to reset on entering a new Corporation, not at each Node or ICE encounter.


## TRACE-004 — 100% TRACE Corporation countermeasures TBD (LOCKED boundary, 2026-11-11)

At **100% TRACE**, the Corporation identifies the Rustler's location, as established by TRACE-001. **The specific Corporation countermeasures deployed at 100% TRACE are TBD and not yet designed or approved.** Do not presume reinforced ICE, a hunter program, a special encounter, damage, defeat, timing, duration, or any other particular mechanic. Earlier language about deployment of additional defenses expresses the intended narrative escalation only; the actual countermeasure rules remain **OPEN**. TRACE-001's 50% warning-only rule and TRACE-002/003 Corporation-scope reset rules remain unchanged.


## BREAKER-STARTER-002 — Generalist FORTRESS Icepick partial profile (APPROVED, 2026-11-12)

The Generalist starter **FORTRESS Icepick** is a **Persistent Software Executable** compatible with **FORTRESS ICE**. Its **base breaking Strength is 1**. The Rustler may **spend 1 BW to increase its breaking Strength by 1**, with boosts accumulating for the **remainder of the current ICE encounter**, consistent with BREAKER-STARTER-001's starter Icepick Strength-boost duration. This approval defines only base Strength and Strength-boost cost/amount; the **BW cost to break an individual FORTRESS subroutine remains OPEN** and must not be assumed. Existing starter Icepick installation and RAM rules are unchanged. This supersedes older notes saying all FORTRESS Icepick profile details are undecided, but does not settle other training-encounter balance questions.


## BREAKER-STARTER-003 — FORTRESS Icepick subroutine-breaking profile (LOCKED, 2026-11-12)

The Generalist starter **FORTRESS Icepick** is a Persistent Software Executable compatible with FORTRESS ICE, with **base breaking Strength 1** and **spend 1 BW for +1 breaking Strength for the remainder of the current ICE encounter** (BREAKER-STARTER-002). Its subroutine-breaking abilities are:

- **Once per Rustler turn:** Break **one** subroutine on a compatible FORTRESS ICE for **0 BW**.
- **Additional breaks:** Spend **1 BW** to break **one** subroutine on a compatible FORTRESS ICE; each further paid break costs 1 BW.
- **Strength requirement:** Both free and paid breaks require the FORTRESS Icepick's current breaking Strength to meet or exceed the target FORTRESS ICE's current Strength, as with other Icepicks.
- The free use **refreshes each Rustler turn**, not each encounter, and unused free breaks **do not accumulate**. It is one free break per turn for this installed Icepick, not one per target FORTRESS or subroutine. Existing installation/RAM, card lifecycle, and encounter rules remain unchanged.

**Status:** The three Generalist starter Icepick breaking profiles are now defined: VOID (Strength 0; +1 per 1 BW; 1 BW per subroutine), SIGYL (Strength 3; +1 per 2 BW; 1 BW per subroutine), FORTRESS (Strength 1; +1 per 1 BW; first eligible break each Rustler turn free; subsequent breaks 1 BW each). Earlier statements that FORTRESS's breaking cost remains OPEN are superseded.


## BREAKER-STARTER-004 — FORTRESS Icepick base Strength revised to 0 (LOCKED, 2026-11-12)

**Approved revision:** The Generalist starter **FORTRESS Icepick's base breaking Strength is 0**, replacing the previously approved Strength 1 in BREAKER-STARTER-002 and repeated historical summaries in BREAKER-STARTER-003. This is an explicit supersession; do not use Strength 1 as the current rule.

**Complete current FORTRESS Icepick profile:** Persistent Software Executable compatible with FORTRESS ICE; **base breaking Strength 0**; spend **1 BW to gain +1 breaking Strength** for the remainder of the current ICE encounter (boosts stack); **once per Rustler turn, break one compatible FORTRESS subroutine for 0 BW**; each additional compatible FORTRESS subroutine break costs **1 BW**. All free and paid breaks require the Icepick's current breaking Strength to be at least the target FORTRESS ICE's current Strength. The free break refreshes each Rustler turn, does not accumulate, and is limited to once per turn per installed Icepick. Existing installation and RAM requirements remain unchanged.

**Balance intent:** The free once-per-turn subroutine break offsets the additional BW needed to boost from Strength 0. This decision changes only the FORTRESS Icepick's base Strength, not the VOID or SIGYL profiles or any other established rules.


## GENERALIST-STARTER-LOCK-001 — Approved 12-card starter deck and no Protocols (LOCKED, 2026-11-12)

The **Generalist starter deck is exactly 12 physical cards**:

| Qty | Card | Operating classification | Nature | Play/install cost |
| ---: | --- | --- | --- | --- |
| 1 | FORTRESS Icepick | Persistent Executable | Software | 1 BW install |
| 1 | VOID Icepick | Persistent Executable | Software | 1 BW install |
| 1 | SIGYL Icepick | Persistent Executable | Software | 1 BW install |
| 1 | Basic Extractor | Persistent Executable | Software | 1 BW install |
| 1 | SYN BUFFER | Persistent Executable | Hardware | 1 BW install |
| 3 | PULP Shield | Instant Packet | Hardware | 1 BW each |
| 3 | PROBE | Instant Packet | Software | 1 BW each |
| 1 | GHOST SIGNAL (working name) | Instant Packet | Software | 2 BW |

**Composition:** **5 Executables, 7 Packets, 0 Protocols, 0 Bloatware** at the start of a Generalist run. This explicitly confirms **no Protocol cards in the starter deck**; Protocol remains an established card classification for other cards or later acquisitions. Bloatware may be inserted by Corporation effects during play, but is not part of the starting 12 cards.

**Current approved abilities:** FORTRESS Icepick: base breaking Strength **0**, +1 Strength for 1 BW for the remainder of the ICE encounter, first eligible FORTRESS subroutine break **free once per Rustler turn**, subsequent breaks 1 BW each. VOID Icepick: base Strength 0, +1 Strength for 1 BW, break a compatible subroutine for 1 BW. SIGYL Icepick: base Strength 3, +1 Strength for 2 BW, break a compatible subroutine for 1 BW. All breaks require sufficient breaker Strength. Basic Extractor: earn up to 5 CRED at each eligible Rustler end turn from current ICE encounter's finite reserve. SYN BUFFER: automatically prevent 1 SyN once per ICE encounter per independently installed copy. Each PULP Shield: +3 temporary PULP prevention to the shared pool. Each PROBE: reduce target ICE Strength by 2 for that ICE lifecycle. GHOST SIGNAL: reduce the first TRACE addition during the immediately following Corporation turn to 0, then BURNED until the next Node, usable once per Node.

**Resource status:** Existing 1 RAM requirements for the four Software Executables remain as approved. SYN BUFFER's 1 RAM requirement remains **provisional and open for rebalancing**, not newly finalized here. GHOST SIGNAL is still a **working name**. Earlier 10-card starter lists, two-shield quantities, and FORTRESS base Strength 1 are historical/superseded; they are not alternate active starter configurations. This lock confirms the starter deck composition, not the unresolved training ICE or balance details.


## BREAKER-STARTER-005 — FORTRESS Icepick base Strength restored to 1 (LOCKED, 2026-11-12)

**Latest explicit approval supersedes BREAKER-STARTER-004 and GENERALIST-STARTER-LOCK-001 only where they specify FORTRESS Icepick base Strength 0:** The Generalist starter **FORTRESS Icepick has base breaking Strength 1**. This restores the earlier Strength 1 baseline and is the **current authoritative value**; Strength 0 is historical and must not be used for current rules or playtesting.

**All other approved FORTRESS Icepick mechanics are unchanged:** Persistent Software Executable compatible with FORTRESS ICE; **spend 1 BW for +1 breaking Strength** for the remainder of the current ICE encounter; **once per Rustler turn break one compatible FORTRESS subroutine for 0 BW**, with subsequent compatible FORTRESS subroutine breaks costing **1 BW each**. Every break requires the Icepick's current breaking Strength to meet or exceed the target FORTRESS ICE's current Strength. Free breaks refresh each Rustler turn and do not accumulate. Installation and RAM requirements are unchanged. The Generalist starter deck remains exactly 12 cards, including one FORTRESS Icepick and **zero Protocols**. No VOID or SIGYL Icepick profile is changed.


## CARD-SUBTYPE-001 — EXPLOIT / CLOAK and reactive VOID (LOCKED, 2026-11-12)

**Functional subtypes are distinct from existing card classifications:** EXPLOIT denotes offensive cards that compromise, weaken, or manipulate hostile systems; CLOAK denotes defensive cards that protect the Rustler, conceal activity, or interfere with hostile detection and attacks. These functional subtypes are orthogonal to Hardware/Software and Packet/Executable classifications. Do not confuse CLOAK with a specific cloaking technology; its meaning includes physical damage prevention.

**Generalist starter card subtype assignments (LOCKED):** PROBE = **EXPLOIT** (Software Packet); PULP Shield = **CLOAK** (Hardware Packet); GHOST SIGNAL (working card name) = **CLOAK** (Software Packet). No other starter cards receive a subtype from this decision. In particular, do not infer that all installed protective cards are CLOAK without separate approval.

**VOID reactive ability (LOCKED):** **Whenever the Rustler plays a CLOAK card, this VOID gains +1 Strength.** Each distinct CLOAK card play triggers +1 Strength; the trigger is on playing a card, not on automatic activations of previously installed cards. The Strength bonus duration/reset timing and any encounter-specific stacking restrictions beyond the per-play trigger remain to be specified; do not silently treat a proposed duration as approved. The precise VOID starting Strength remains open.

**Terminology:** EXPLOIT and CLOAK supersede proposed DEFENSE, SHROUD, SAFEGUARD, ASSAULT and COUNTERMEASURE names for these Rustler functional subtypes; COUNTERMEASURE remains available as Corporation terminology. This decision does not change card costs, effects, deck counts, or Icepick profiles.


## NODE-EXTRACTION-001 — Full extraction bonus (HISTORICAL — REMOVED by CORE-012, 2026-11-14)

> **Not an active rule.** The designer removed this extraction bonus on 2026-11-14. Current extraction is reserve-only under `REDLINE_CORE_RULES.md` §9.2 / CORE-012. The original text below is retained as decision history, including superseded payout examples.

**General Node rule:** If the Rustler extracts **all CRED in a Node's finite extractable CRED reserve (100%)**, award a **one-time bonus equal to 10% of that Node's original CRED reserve**. The bonus is additional earned CRED, **not** a refill of the Node's reserve, and does not count as CRED remaining to extract. It applies regardless of which eligible extraction effect empties the reserve; it is **not** exclusive to Basic Extractor. Award immediately when the reserve reaches zero through extraction; do not award again for the same Node. A Node not fully extracted receives no full-extraction bonus. Example original reserves: 15 CRED -> +1.5 CRED (16.5 total), 25 -> +2.5 (27.5 total), 40 -> +4 (44 total). **Fractional CRED handling/rounding is not yet defined**; these examples express the exact 10% mathematical bonus and must not be interpreted as a finalized fractional-CRED accounting rule.


## NODE-EXTRACTION-002 — General Node full-extraction bonus rounding (HISTORICAL — REMOVED by CORE-012, 2026-11-14)

> **Not an active rule.** The designer removed this extraction bonus on 2026-11-14. Current extraction is reserve-only under `REDLINE_CORE_RULES.md` §9.2 / CORE-012. The original text below is retained as decision history, including superseded payout examples.

**This is a global game rule for ALL Nodes**, not an ability of an individual card, extractor, Node type, or training encounter. Whenever the Rustler extracts **100% of a Node's original finite CRED reserve**, grant **one bonus equal to 10% of the original reserve, rounded UP to the nearest whole CRED**: `bonus_CRED = ceil(original_node_CRED_reserve * 0.10)`. This bonus is paid once per Node, adds to banked earnings, does not replenish the Node's extractable reserve, and is independent of the extraction method. No full-extraction bonus is paid if any reserve CRED remains unextracted. Example: 15 reserve -> +2 bonus, 17 total; 25 -> +3, 28 total; 40 -> +4, 44 total. This explicitly **supersedes the fractional-CRED examples and open rounding question in NODE-EXTRACTION-001**. CRED bonuses under this rule are always whole numbers.


## TRAINING-THREE-ICE-SENTRY-001 — Main VOID base Strength and bonus duration (LOCKED, 2026-11-12)

In the three-ICE training encounter, the **rightmost main VOID starts at Strength 3** (not the previously proposed 5). Its locked reactive ability remains: **Whenever the Rustler plays a CLOAK card, this VOID gains +1 Strength**. **All Strength bonuses applied to this VOID last for the current ICE encounter only** and expire when that encounter ends; multiple qualifying bonuses stack during the encounter. This encounter-duration rule covers the VOID's reactive +1 Strength bonuses and Strength bonuses conferred by supporting ICE effects (including the working supporting SIGYL +2 effect, if that effect resolves). It does not by itself finalize the SIGYL effect's trigger, frequency, or other unresolved specifics. The base Strength 3 is restored on a new encounter; no Strength bonuses persist between ICE encounters or Nodes. The previously proposed base Strength 5 is rejected. All other encounter rules remain unchanged.


## TRAINING-THREE-ICE-CODE-GATE-001 — Supporting SIGYL Strength boost (LOCKED, 2026-11-12)

In the three-ICE training encounter, the supporting SIGYL's VOID-strengthening subroutine grants **+1 Strength to the rightmost main VOID**, **not +2**. The subroutine **activates as normal** under existing multi-ICE Corporation Response rules: ICE resolve left-to-right; eligible unbroken subroutines resolve top-to-bottom during normal Corp Response. It is **not** an automatic passive trigger or a special one-time activation. Each time the subroutine normally resolves, it grants +1 Strength, stacking with other encounter-long Strength bonuses; the added Strength expires at the end of the current ICE encounter. If the subroutine is broken or otherwise prevented, it does not grant the bonus. This supersedes earlier working +2 text. Main VOID base Strength remains 3 and its +1 Strength per played CLOAK ability remains unchanged. No change to other SIGYL subroutines or TRACE rules.


## RUSTLER-STARTING-RESOURCES-001 — TRACE capacity and VITAE (LOCKED, 2026-11-12)

The Rustler starts with **30 VITAE** and a **TRACE meter capacity/maximum of 40 TRACE points**. The TRACE meter is visually displayed as 0–100% of its current 40-point capacity, while printed TRACE values are actual TRACE points (e.g., TRACE 3 adds 3 points, equivalent to 7.5% of a 40-point meter). At capacity 40, the 50% warning threshold is 20 TRACE points and 100% detection threshold is 40 TRACE points. Existing TRACE persistence/reset rules and the still-undetermined Corporation countermeasures upon reaching 100% remain unchanged. This establishes starting VITAE as 30; it does not by itself establish whether 30 is a hard VITAE maximum or how VITAE regeneration works. This supersedes earlier unresolved TRACE numeric normalization and any conflicting provisional starting VITAE values.


## VITAE-CAPACITY-001 — Starting VITAE is not maximum VITAE (LOCKED, 2026-11-12)

**The Rustler starts with 30 VITAE. This is NEVER to be treated as a fixed or universal maximum.** The Rustler's initial MAX VITAE value and any general upper limit are **undefined / not yet specified**. Future cards and Ghostware can provide effects that **increase current VITAE** and/or **increase MAX VITAE**; these are distinct mechanics and must be represented separately. Do not infer that gaining current VITAE automatically increases MAX VITAE, or vice versa, unless a particular card explicitly says so. Do not hard-code MAX VITAE = 30 or silently introduce a fixed maximum in design or implementation. This clarification supersedes any suggestion in RUSTLER-STARTING-RESOURCES-001 or earlier notes that 30 might be a maximum. TRACE starting capacity remains 40, separate from VITAE.


## TRAINING-THREE-ICE-CODE-GATE-A-002 — Sole subroutine and once-per-Corporation-turn timing (LOCKED, 2026-11-12)

**SIGYL A**, the **leftmost supporting SIGYL** in the third training-layer three-ICE encounter, has **exactly one subroutine**:

> **Grant the main VOID ICE +1 Strength.**

This sole subroutine **resolves once per Corporation turn during the normal Corporation Response**, provided it remains eligible and unbroken. It is not a passive effect and does not activate more than once in the same Corporation turn. On each subsequent Corporation turn in which it resolves, it grants an additional +1 Strength; these bonuses **stack and last only until the end of the current ICE encounter**, consistent with TRAINING-THREE-ICE-SENTRY-001 and TRAINING-THREE-ICE-CODE-GATE-001. Breaking/preventing the subroutine prevents its resolution for that turn. SIGYL A has **no additional subroutines**. Its provisional Strength 5 remains a working value, not newly locked by this decision. Main VOID base Strength remains 3.


## TRAINING-THREE-ICE-WATCHDOG-001 — Main VOID named WATCHDOG (LOCKED, 2026-11-12)

The **rightmost main VOID ICE** in the third training layer is officially named **WATCHDOG**. Its locked base Strength is **3 STR**. Its existing reactive ability is unchanged: whenever the Rustler plays a CLOAK card, **WATCHDOG gains +1 STR** for the current ICE encounter; multiple triggers stack.

The **leftmost supporting SIGYL 1** has exactly one subroutine, now printed in the approved canonical subroutine notation:

`[S1] WATCHDOG gains +1 STR.`

This subroutine resolves once per Corporation turn under normal Corporation Response rules if eligible and unbroken. Each resolved bonus stacks and lasts for the current ICE encounter. All ICE subroutine lists in future PANOPTICON design work should use `[S1]`, `[S2]`, etc., in top-to-bottom resolution order. For example, the other supporting SIGYL 2's working list is:

`[S1] PULP 3`
`[S2] TRACE 3`

WATCHDOG supersedes any proposed name RATCHET; this change is a naming and notation decision, not a new effect or numerical balance change.


## TRAINING-CRED-REBALANCE-002 — Training Node CRED reserves 10 / 15 / 25 (LOCKED, 2026-11-12)

The three Training Node ICE encounter/layer **original finite CRED reserves** are now **Layer 1 = 10 CRED; Layer 2 = 15 CRED; Layer 3 = 25 CRED**. Total base reserves **50 CRED**. This expressly **supersedes the former provisional 15 / 25 / 40 CRED training reserves** (80 total) and any alternate 10 / 15 / 20 proposal. Apply the existing universal per-Node full-extraction bonus independently to each layer's reserve when fully depleted: **ceil(10% of original reserve)**, so bonuses **+1 / +2 / +3** and maximum payouts **11 / 17 / 28 CRED**, totaling **56 CRED** if all three layers are fully extracted. No bonus for partial extraction. Basic Extractor's existing 5-CRED per eligible end turn remains unchanged. This is the authoritative Training Node CRED schedule wherever historical numbers conflict.


## TRAINING-WATCHDOG-SUBROUTINES-001 — WATCHDOG subroutine adjustment (APPROVED, 2026-11-12)

In Training Node Layer 3, **WATCHDOG — VOID — STR 3** has the following approved working subroutine list, in top-to-bottom resolution order:

`[S1] PULP 4`
`[S2] SyN 1`
`[S3] DEADLOCK`

The user specifically reduced the proposed `[S2] SyN 2` to **`[S2] SyN 1`**. This replaces that earlier proposed value. WATCHDOG's existing reactive ability remains unchanged: whenever the Rustler plays a CLOAK card, WATCHDOG gains +1 STR for the current ICE encounter; bonuses stack. Do not alter the already-approved base STR 3. This entry approves the revised working subroutine roster; do not silently modify other ICE or mechanics.


## TRAINING-WATCHDOG-SUBROUTINES-002 — PULP 4 and DEADLOCK share one subroutine (CORRECTION, 2026-11-12)

Correct the preceding WATCHDOG roster: **WATCHDOG — VOID — STR 3** has **two** subroutines, not three:

`[S1] PULP 4 + DEADLOCK`
`[S2] SyN 1`

PULP 4 and DEADLOCK are **two effects on the same [S1] subroutine**, not separately breakable subroutines. Breaking [S1] prevents both effects, including its DEADLOCK. This supersedes the prior `[S1] PULP 4 / [S2] SyN 1 / [S3] DEADLOCK` presentation. Existing CLOAK-triggered +1 STR reactive ability and base STR 3 remain unchanged. Preserve top-to-bottom [S#] numbering.


## TRAINING-WATCHDOG-SUBROUTINES-003 — Final corrected three-subroutine layout (LOCKED, 2026-11-12)

**WATCHDOG — VOID — STR 3** has **exactly three subroutines**, in order:

`[S1] PULP 4 + DEADLOCK`
`[S2] SyN 1`
`[S3] DEADLOCK`

There are **two DEADLOCK effects**, one attached to [S1] together with PULP 4, and the other as standalone [S3]. **SyN 1 is its own independent [S2] subroutine** and has no DEADLOCK. Breaking [S1] neutralizes both PULP 4 and its attached DEADLOCK; breaking [S3] neutralizes its separate DEADLOCK. Both DEADLOCK effects must be neutralized to BREACH. This definitive layout supersedes both earlier incorrect versions: `[S1] PULP 4 / [S2] SyN 1 / [S3] DEADLOCK` and `[S1] PULP 4 + DEADLOCK / [S2] SyN 1`. WATCHDOG remains base STR 3, with its unchanged CLOAK-triggered +1 STR reactive ability.


## TRAINING-NODE-PLAYTEST-LOCK-001 — Names and existing encounter values locked; implementation phase (2026-11-12)

User confirms **all six ICE names** and **all existing Training Node values** for the playtest. Do not reopen naming or rebalance before actual playtesting. The ICE roster, in left-to-right resolution order, with required display format **NAME — TYPE — STR** and numbered subroutines:

**Layer 1:** WHITE PICKET FENCE — FORTRESS — STR 3: `[S1] PULP 5`; `[S2] DEADLOCK`.

**Layer 2:** TOLLBOOTH — FORTRESS — STR 5: `[S1] TRACE 4`; `[S2] DEADLOCK`. MEATGRINDER — SIGYL — STR 3: `[S1] PULP 3`; `[S2] PULP 3`; `[S3] DEADLOCK`.

**Layer 3:** OVERCLOCK — SIGYL — STR 5: `[S1] WATCHDOG gains +1 STR.` HOTWIRE — SIGYL — STR 3: `[S1] PULP 3`; `[S2] TRACE 3`. WATCHDOG — VOID — STR 3: `[S1] PULP 4 + DEADLOCK`; `[S2] SyN 1`; `[S3] DEADLOCK`. WATCHDOG reactive ability: whenever the Rustler plays a CLOAK card, WATCHDOG gains +1 STR for current encounter; stacks.

**CRED reserves by layer:** 10 / 15 / 25 (total base 50); universal rounded-up 10% full-extraction bonuses +1 / +2 / +3, maximum total 56. Existing rules on turns, BW/RAM, 12-card Generalist deck, Icepicks, TRACE, VITAE, damage, extraction, BREACH, and reward resolution remain authoritative.

**Next phase:** Implement an actually playable three-layer training-node prototype in **Godot**, edited/debugged using **Visual Studio**; validate established mechanics through playtesting before changing balance. This is a design freeze for the initial playtest, not a claim that implementation has been completed. Historical references to proposed ICE names/Strength/subroutines are superseded by this lock.


## STRIP-001 — Core-loop test build and its rules (APPROVED, 2026-11-21)

Designer, in a Claude session on 2026-11-21: "Let's build a stripped down test build with the extras stripped off and just focus on break, defend, and build." Approved in the same session: **BW-001** (3 BW per turn: "ok let's change to 3 BW a turn, probe at 0 BW, and parting shot"), **PROBE-001** (PROBE 0 BW), **BREACH-001** (parting shot), **TURN-001** (discard and draw the next hand before the Corporation Response: "the rustler needs to discard their remaining cards at the end of their turn AND draw their next hand (6 cards) before the corp starts their turn"), **BURST-001** (3 BW: gain 5 BW, +1 cost per play per copy for the encounter; "there should be no limit to the amount of BW one gains"), **STR-001** ("+2 strength sounds right"), **PROBE-003** ("Perfect lets do it"; PROBE-002's cut to two copies reversed), **CACHE-001** (∞ = the encounter) and the STRIP-001 scope (TUMBLER with no waiting floor; Extractors and CORTEX BUFFER kept as inert cards). Full rules, ICE values and reward pool: `docs/REDLINE_CORE_LOOP.md`. These apply when `Game.CORE_LOOP` is true and win over other docs for that build only.

## FORM-001, FORM-002 — ICE forms by STR and breaks; threat up (APPROVED, 2026-11-21)

After Playtest 8 the designer reported "this build is a whole lot more fun to play. Just like night and day", winning "with minimal damage and especially trace". **FORM-002:** every TRACE subroutine +2 ("add +2 trace immediately to all trace subroutines") and every PULP subroutine **+1** ("+1 because of doubling"). **FORM-001:** an ICE's form follows the encounter, not TRACE, so every player sees it: **WARY** when its STR is below half its printed STR; **LETHAL** when its STR is below half **and** at least half its subroutines are broken, rounded up ("I like 1/2 rounded up"); LETHAL lasts the encounter ("yes"). A LETHAL ICE's PULP and TRACE subroutines deal **double**, including the parting shot. **Black ICE** show WARY and LETHAL but never deal double (designer: "Black ice should turn wary and lethal - however, it shouldn't double"; "perfect"). Core-loop build (`Game.CORE_LOOP`) only.

## BOOST-001, SUB-001 — Boosts last the turn; richer subroutines (APPROVED, 2026-11-21)

From the Playtest 9 sheet: encounters of 2–3 turns were "too short, i barely got through my deck", and spare BW went into Icepick boosts "with my remaining BW", not as a choice. **BOOST-001** (designer: "BOOST-001 is approved. It makes so much sense."): Icepick boosts last **until the end of your turn**; PROBE still lasts the encounter. **SUB-001** (designer: "lets go with this for now it looks really fun"): 1–2 more subroutines per ICE, with one subroutine per ICE carrying two effects; new effects **HARDEN X** (this ICE +X STR for the encounter), **SHIELD BREAK** (your SHIELD drops to 0), **RETALIATE X** (PULP X per subroutine already broken on this ICE; LETHAL doubles it); **CORTEX** back on VOIDs; DEADLOCK ×2 on AUTO-RENEW and TERMS OF SERVICE. Values: `docs/REDLINE_CORE_LOOP.md` §1b. Core-loop build only.

## RIDER-001, AMEND-001, DEFRAG-001, PLAY-002 — After Playtest 10 (APPROVED, 2026-11-21)

Designer after Playtest 10: "These are fun puzzles. The game is turning into a puzzle deck builder." **RIDER-001** (designer: "i really like the trace riders. we should add them to this build"): `TRACE X ▸ effect`: the effect happens only if some of that subroutine's TRACE lands after reductions; new common **JAMMER** (1 BW: the first 2 TRACE subroutines in the next Corporation Response add 0). **AMEND-001** ("I really like amend. Let's build it"): CONSENT FORM joins TERMS & CONDITIONS as the support ICE; **AMEND X**: this response, the ICE to its right deals +X on each PULP subroutine (doubled when that ICE is LETHAL). **DEFRAG-001:** DEFRAG becomes 0 BW, discard 1 card, then draw 2. **PLAY-002** (designer: "there should be animations and sound for each subroutine type"): the parting shot plays on screen like a response, and each subroutine type has its own sound (PULP also shakes the screen). Values: `docs/REDLINE_CORE_LOOP.md` §1c.

## MAP-003 — Corporation structure: 14 Nodes and a boss, no escape (APPROVED direction, 2026-11-21)

Designer, 2026-11-21: "The Rustler will encounter 14 nodes and then a final corporation BOSS node. 7 of the 14 nodes are encounters, the other 7 will be an even but random mix safehouses, and the rest. There will be multiple paths so that the rustler can decide which way they want to go. But there should be a way for them to be able to see mostly full paths up to 3 nodes ahead of them if they extract all the creds from a node... for each corporation a rustler will usually encounter 7 or 8 ice nodes (as one of the other 7 may randomly be another ice node), and then a boss. There is no escape, once they beat the boss, they escape with their rewards as well as barcode for the signal." Replaces UPL-007's 10 infiltration rows + Central Node + 4-Node escape. **Open details** (designer to confirm): the non-ICE Node mix; what the map shows without a full extraction; whether "14 Nodes" means 14 rows per path. Effects are taught one per encounter along this map (EFFECTS-001, `REDLINE_ICE_EFFECTS.md`, PROPOSED).

## MINIBOSS-001 and MAP-003a — Optional mini-boss; map details (APPROVED direction, 2026-11-21)

**MAP-003a** (designer): the map always shows the next row's icons; extracting every CRED from a Node unlocks fuller paths **3 Nodes ahead**. "14 Nodes" is the number on every path (confirmed "Correct."). **MINIBOSS-001** (designer): one mini-boss per corporation, "having an ability unique to itself and itself only"; "Every path does not go through it. So some players if they see it ahead, may wish to stay away or run towards it, as they may want the rewards." It is **extra** to the 7 ICE Nodes; on paths without it, that slot is a regular ICE Node. Its unique ability is explained on the map before the player commits *(superseded by MINIBOSS-003 / MAP-003f, 2026-11-27: category shown, identity and ability hidden until entry)*. **Rewards:** choose 1 of 3 rare cards **and** 1 Ghostware **and** 1 CAP **and** some CRED. Corporation length per path (designer): "7+1 (mini boss optional, else regular ice node) + 8 (Node type 3 through 8) + 1 (final boss)": 7 ICE + 1 mini-boss-or-ICE + 8 non-ICE Nodes (Uplink, Uplink with Clinic, DEAD DROP, Console Lab, SAFEHOUSE, SIGNAL UNCLEAR) + the boss. *To confirm:* whether the count is 16 Nodes then the boss (17 in all), and whether the Opening Node is one of the 7 ICE Nodes.

## MAP-003b, BOON-001 — 16 Nodes per corporation; NUL/REM's boons (APPROVED direction, 2026-11-21)

**MAP-003b** (designer): "15 total nodes + 1 Boss for 16 total": **7 ICE Nodes + 1 mini-boss or another ICE Node + 7 other Nodes + the boss**. The first Node of every corporation is always an ICE Node: the Opening Node is the first of the 7. Supersedes the counts in MINIBOSS-001 and MAP-003.

**BOON-001** (designer's idea, details to design): at the start of each corporation, NUL/REM offers the Rustler **2 or 3 randomized boons**, chosen from that Rustler's pool, that last the run. Some are pure bonuses, some carry a drawback. Designer's examples: start with a special card in the deck; remove one card from the deck; exchange the ORIGIN Ghostware for a random Ghostware; +5 Max VITAE but start with +8 TRACE; +2 BW on the first turn of each encounter but a permanent Bloatware in the deck (e.g. +4 TRACE if it's in hand at the end of your turn). Needs a new card status for cards that can't be removed by any means (working name in HANDOFF; shared with EVENT-004's permanent Bloatware).

## HARDWIRED-001 — Cards that can't be removed (APPROVED, 2026-11-22)

Designer: "yes hardwired is perfect." A **HARDWIRED** card can never leave the deck: Wipe, the Console Lab, DATA PURGE, DECOMPILE and FUSE can't remove it. It shows a small solder-joint marker on its face. Used by BOON-001's drawback boons and EVENT-004's permanent Bloatware.

**BOON-001 details (designer, 2026-11-22):** the player may decline every boon offered ("For now yes"), and boons from different corporations **stack** for the rest of the run ("yes").

## MINIBOSS-002 — Mission statements and the three mini-bosses (APPROVED, 2026-11-22)

Designer: "very good. commit all those to the repo." Approved: the three corporate mission statements (IRONWATCH revised so every surface is a sensor that knows why you are there), and the mini-bosses **MEMORY LANE** (HALCYON; FOND MEMORIES: every other response, 2 MEMORY Bloatware into the draw pile, each in hand at end of turn costs 2 SHIELD; designer's mechanic, not a subroutine, can't be disabled), **THE GRID** (IRONWATCH; PROFILE) and **REVERIE** (LUCIDA; NIGHTMARES). Full text: `docs/REDLINE_MINIBOSSES.md`.

## MAP-003c — Map generation rules (APPROVED, 2026-11-22)

Designer: row 1 is an encounter, row 16 the boss, row 9 holds the mini-boss Node (other row-9 Nodes are ICE), 3–4 Nodes per row elsewhere, and every path has 8 encounters (including row 9) and 7 other Nodes. Every path guarantees **at least 3 SAFEHOUSE + Uplink combined, with at least 1 of each** ("it could be 2 safehouses and 1 uplink or 2 uplinks and 1 safehouse"). Spacing rules stay loose (working value: at most 4 ICE or 4 non-ICE Nodes in a row). Prototype: `prototypes/map/map003_generator.py`.

## MAP-003d — Every path has one of each Node type (APPROVED, 2026-11-22)

Designer: "we want each path to have at minimum 1 each of #3 through #8 node type": Black Market Uplink, Uplink with Clinic, DEAD DROP, Console Lab, SAFEHOUSE, SIGNAL UNCLEAR. With 7 other Nodes per path that leaves one free slot. The Uplink with Clinic counts as an Uplink, so MAP-003c (3+ SAFEHOUSE + Uplink, 1+ each) is always met. This replaces "about 1 Uplink in 3 has a Clinic": every path now reaches a Clinic. Prototype v3: `prototypes/map/map003_generator.py --v3`.

## MAP-003e, CLINIC-001 — Uplink and Clinic merged; Clinic pricing (APPROVED, 2026-11-22)

Designer: "I AGREE" to merging the Black Market Uplink and the Uplink with Clinic into one **Uplink**: buy cards and CAPS, Wipe, REFACTOR, and a **Clinic counter** that removes CORTEX for CRED. Map: five other Node types (Uplink, DEAD DROP, Console Lab, SAFEHOUSE, SIGNAL UNCLEAR); every path has at least one of each and at least 3 SAFEHOUSE + Uplink combined (two free slots). Supersedes MAP-003d's six types. *(Route composition amended by MAP-003f, 2026-11-27: 2–3 Uplinks per route; other MAP-003e rules kept.)* **CLINIC-001** (designer): "30 creds per, with a discount of 25% if they want to remove more. So around 50 cred to remove 2." Working rule: 30 CRED for one CORTEX; removing 2 or more in one visit costs 25% less in total, rounded up (2 = 45, 3 = 68, 4 = 90). Prototype v4: `prototypes/map/map003_generator.py --v4`.

## TUNE-002 — TERMS & CONDITIONS eased (APPROVED, 2026-11-22)

Playtest 11: the designer died at TERMS & CONDITIONS, losing 10 + 13 + 6 VITAE in 3 turns. Designer: "fix all including conditions tuning". **AMEND 2 → 1** on CONSENT FORM, and TERMS OF SERVICE's two PULP 4 subroutines → **PULP 3**. Everything else on the Node stays.


## PROBE-004 — PROBE is choose-one (APPROVED, 2026-11-22)

Designer: "the card should do what it currently does OR reveal hidden subroutines on a VOID ice. Same costs". Core-loop build: PROBE reads *Choose one: target ICE −2 STR this encounter; or target VOID: reveal all its face-down subroutines.* Both modes share the PROBE-003 cost count; the −2 STR mode no longer reveals (replaces STRIP-001's "a PROBE reveals the top one"). *Interpretation to confirm:* "reveal hidden subroutines" = all of them.


## ARCH-V2-001 — Full-game architecture and development branch (APPROVED, 2026-11-23)

**Designer decisions:** The current Godot build is a playable four-node prototype, not the required architecture for the full game. The designer approved moving toward a hybrid scene-based, component-driven, data-driven Godot architecture, and explicitly approved `architecture-v2` as the primary development branch while `main` remains the stable prototype baseline. This supersedes the single-scene/no-new-scenes constraint **for the migration branch** and the earlier default-to-`main` development rule for architecture work. Existing prototype/release procedures remain intact unless separately approved for change.

**Scope:** Meaningful reusable Godot scenes, typed GDScript components, data-driven corporation presentation/content, and strong rules/presentation separation. Preserve the existing validated rules and their tests as the initial behavioral reference; do not change card effects, balance, approved rules, copy guards or gameplay solely because the architecture changes. Start with a reviewed architecture plan and one complete playable ICE encounter, then verify behavior and scalability before broader migration. Exact scene layout, data schema, use of signals, migration steps, and future release/merge gate are **not yet approved**. No fork or new repository is required. Do not merge into `main` without explicit designer approval.

**Status:** Architectural direction and branch policy APPROVED by designer; implementation not started. `architecture-v2` branch created from `main`; prototype tag and validation results not yet recorded. *Update (ARCH-V2-002, 2026-11-25): baseline recorded and tagged `prototype-baseline` on `21922ad`; see ARCH-V2-002.*
## NUL-PILLAR-001 — NUL/REM and the self-built prison (DIRECTION, 2026-11-23)

Designer explicitly confirmed NUL/REM as a foundational design pillar and endorsed knowledge, confidence and authority (explicit or assumed through repeated compliance) as the three conditions for behavioural intervention. NUL/REM actively solicits authority by offering real benefits in response to experienced difficulty. Pivotal designer example: near the end of corporation two, a habitual card retainer attempts to slim the deck and NUL/REM denies removal. Other designer examples: following safer route advice, delegating initial program installation for +1 first-turn BW, and advance ICE-type intelligence. Preserve the complete substantive discussion in [REDLINE_NULREM_BEHAVIOURAL_LOCK_IN.md](REDLINE_NULREM_BEHAVIOURAL_LOCK_IN.md). Individual mechanics, thresholds, copy and implementation remain PROPOSED; no existing rules or reveal guards changed.

## NUL-PILLAR-001a — Psychological Invisibility (DIRECTION, designer-confirmed 2026-11-23)

The psychological experiment must remain invisible: never disclose, classify, quantify or announce player progression through the psychological framework, including retrospective summaries, dialogue, achievements or THE CARBON. Internalization is emergent player behaviour, not a programmed phase or status. Immediate transactions and real gameplay consequences remain understandable. See [NUL/REM and the self-built prison](REDLINE_NULREM_BEHAVIOURAL_LOCK_IN.md#nul-pillar-001a--psychological-invisibility-designer-confirmed-foundational-constraint-2026-11-23). This is a foundational design constraint; proposed enforcement withdrawal, silence and disconnection mechanics are not authorized for implementation.

## NUL-PILLAR-001b — Played under surveillance (DIRECTION, designer-confirmed 2026-11-23)

**PANOPTICON is not a game about surveillance. It is a game played under surveillance.** Within fiction, perceived observation may shape obedience or resistance without delegated authority; it may also have no effect. The paradox of autonomy remains open: what does it mean to act freely? Experience is sufficient; no prescribed interpretation, psychological result or measurement is required. Preserve NUL-PILLAR-001a and local-only data safeguards. See [foundational NUL/REM design](REDLINE_NULREM_BEHAVIOURAL_LOCK_IN.md). No mechanics authorized.

## NUL-PILLAR-001c — Four-Question Design Gate (DIRECTION, 2026-11-23)

Designer requested preservation of the four questions as the NUL/REM mechanic review standard: Is it strategically meaningful? Does it preserve genuine player agency? Does it allow for multiple psychological responses? Can it communicate its philosophical significance without explaining it? Answer all four before implementation; reconsider any failed or unresolved criterion. Passing does not replace designer approval or existing development gates. See [NUL/REM foundational design](REDLINE_NULREM_BEHAVIOURAL_LOCK_IN.md). Designer-facing only; no gameplay changes authorized.

## PHIL-001 — PANOPTICON Philosophical Design Bible (DIRECTION, designer-confirmed 2026-11-23)

Established [PANOPTICON_PHILOSOPHICAL_DESIGN_BIBLE.md](PANOPTICON_PHILOSOPHICAL_DESIGN_BIBLE.md) as the cross-system philosophical reference. Consolidates participatory imprisonment, psychological invisibility, paradox of autonomy, commodification of autonomy and curated autonomy; preserves surveillance economy and three-card reward filtering explorations. Extend the four-question design review to mechanics expressing these principles. Existing rules, lore and approval gates remain authoritative; all new mechanics, values and algorithms remain PROPOSED.

## PHIL-001a — Opening epigraph (DIRECTION, designer-confirmed 2026-11-26)

The designer placed the Efrat Fenigson passage as the opening epigraph of the [Philosophical Design Bible](PANOPTICON_PHILOSOPHICAL_DESIGN_BIBLE.md). Its design note links participatory confinement, the Internalized Observer, NUL/REM’s consent and authority, and the burden of autonomy. Scope is designer-facing editorial framing.

## PHIL-006 — Panoptic society (DESIGN REFERENCE, 2026-11-26)

Designer requested a transcript review. The [Philosophical Design Bible §12](PANOPTICON_PHILOSOPHICAL_DESIGN_BIBLE.md#12--phil-006-panoptic-society) records source observations on self-regulation, institutions, oversight of supervisors, peer discipline, language and collective agency. Applications are interpretive worldbuilding notes subject to existing PHIL-001 safeguards.

## PHIL-002 — Algorithmic Reduction (DIRECTION, designer-confirmed 2026-11-23)

Preserve six explorations in the [Philosophical Design Bible](PANOPTICON_PHILOSOPHICAL_DESIGN_BIBLE.md): reduction of identity, curiosity displaced by conformity, performance metrics, performance of identity, recursive self-surveillance and disappearance of surprise. Designer emphasizes the last two. Algorithmic Reduction concerns representation and self-perception; no psychological classification or predetermined outcome. All mechanics remain PROPOSED.

## PHIL-003 — Gameplay Manifestations Catalogue (DIRECTION, 2026-11-24)

Designer requested a living [catalogue](PANOPTICON_PHILOSOPHICAL_GAMEPLAY_MANIFESTATIONS.md) of philosophical gameplay examples. Initial 39 proposed examples and one withdrawn example; stable GM IDs, principle tags and status. No mechanics authorized; existing approval gates remain.

## PHIL-003a — Catalogue psychological effects and concrete examples (DIRECTION, 2026-11-24)

Designer requested Psychological Effect grouping and Concrete In-Game Example as the final column of the [catalogue](PANOPTICON_PHILOSOPHICAL_GAMEPLAY_MANIFESTATIONS.md). Primary grouping plus secondary associations; hypothetical designer-facing labels, not measured outcomes. All examples remain proposals.

## PHIL-004 — Demoralization and burden of autonomy (DIRECTION, 2026-11-24)

Preserve designer-confirmed statements in Philosophical Design Bible §10: demoralization introduces surrender of autonomy for relief from its burden; if freedom becomes sufficiently exhausting, can surrendering it begin to feel like liberation? Distinguish perceived futility of resistance and declining confidence in independence. Explore without deliberately inducing helplessness, disengagement or frustration; preserve viable independent play. Manifestations unresolved; no mechanics authorized.

## NUL-DIALOGUE-001 — Dialogue compendium (DIRECTION, 2026-11-24)

Designer requested thematic dialogue catalogue. Created [NUL/REM Dialogue Compendium](PANOPTICON_NULREM_DIALOGUE_COMPENDIUM.md) with 31 draft lines, grouped by contradiction, suggested contexts, psychological associations and paired references. All copy and triggers remain PROPOSED; no new canon or mechanics authorized.

## NUL-DIALOGUE-001a — Earlier dialogue recovery (2026-11-24)

Expanded compendium to 75 entries (57 dialogue examples and 18 wording fragments) from earlier discussion and design records. Partial recovery, not exhaustive. All proposed; no implementation authorized.

## NUL-DIALOGUE-002 — Dialogue architecture (DIRECTION, 2026-11-24)

Designer requested completed [NUL/REM Dialogue Architecture Bible](PANOPTICON_NULREM_DIALOGUE_ARCHITECTURE.md), 13 sections covering authored/procedural/template model, pacing, contextual selection, continuity, curation, schema, performance, content and QA. 150 instances per 70–75-minute run is provisional. Architecture and copy remain proposed; no runtime LLM, no rules or code changes authorized.

## OPS-001 — Shared development operations (DIRECTION, 2026-11-24)

Designer requested one shared operations hub for agents, native issues/PRs, daily reports, surprises and missing tools, 22:00 Toronto review and next-day agenda. See [Operations Hub](operations/README.md). No gameplay or approval changes.

## OPS-002 — Project goals, milestones and progress measurement (DIRECTION, 2026-11-24)

Designer requested an indicator of distance to the final goal. Proposed release goal: a complete, coherent, stable and designer-accepted PANOPTICON game, with a playable three-corporation run (RUN-006), approved rules/content, distinctive presentation and NUL/REM narrative, validated Windows distribution. Commercial release/store scope was initially OPEN; superseded by OPS-002a below. Dates and quantitative quality thresholds remain OPEN.

### Proposed milestone gates

| ID | Milestone | Completion evidence |
|---|---|---|
| M01 | Validated core loop | Approved encounter rules and representative cards implemented; regression tests and designer playtest pass on identified build. |
| M02 | Architecture and full corporation vertical slice | Designer confirms architecture migration disposition; complete HALCYON route, approved node types, rewards, services and boss flow integrated and tested; designer accepts slice. |
| M03 | Full three-corporation run | HALCYON, IRONWATCH and LUCIDA playable end to end; transitions, bosses, run ending and approved First Signal guard validated. |
| M04 | Gameplay content and balance | Approved Rustlers, cards, ICE, progression and economy content complete; representative seeds and human runs meet designer-approved balance criteria. |
| M05 | Narrative and NUL/REM | Approved dialogue architecture and content, lore, boons and any separately approved philosophical mechanics integrated and tested; reveal, privacy and agency safeguards pass. |
| M06 | Presentation and accessibility | Approved visual/audio direction, readable UI, input, settings and accessibility checks pass across the full run. |
| M07 | Beta / release candidate | End-to-end regression, real Windows playtests, packaging, save/config and performance checks pass; release-blocking defects resolved. |
| M08 | Final release acceptance | Designer accepts release scope and candidate; reproducible versioned artifact, checksum, documentation and distribution readiness verified. |

Milestones may overlap; M04–M06 are parallel workstreams, not a mandatory serial order. M07–M09 depend on earlier gates (M09 added by OPS-002a). No completion without linked evidence and designer acceptance where required. Current architecture-v2 branch is not assumed merged; reconcile its scope and evidence before baselining M02.

### Typography & Motion Design System milestone (M06) — Priority 1 companion

**Designer-directed workstream (2026-11-26, UI-TYPO-001 / UI-TYPO-001a).** Priority 1 remains the **Representative ICE Encounter & Component Architecture** (M02, ARCH-V2-001 / CAS-001 / VAS-001). Develop typography and motion concurrently as a significant M06 milestone. The encounter supplies the visible event inventory, component seams and playable test surface. Typography and motion supply the hierarchy, tokens, feedback, accessibility and presentation requirements those components need. This checkpoint feeds the existing M06 full-run gate under OPS-002.

**Designer approval (2026-11-26, VAS-001 / UI-TYPO-001).** Codex may build and verify the isolated C07–C09 ICE fixture and event typography and motion fixture under `godot/tests/visual/`. Claude Code retains production components, live event binding, response sequencing and CI. Specific visual treatments and production integration still require review. Track verification in [#21](https://github.com/Punkwork/REDLINE/issues/21) and [#24](https://github.com/Punkwork/REDLINE/issues/24).

| Step | Deliverable and dependency |
|---|---|
| 1 · Establish direction | Use the approved [UI Bible constraints](PANOPTICON_UI_DESIGN_BIBLE.md#typography-and-motion-exploration-constraints-ui-typo-001--ui-typo-001a) and the four canonical mockups. |
| 2 · Inventory and specify | Start alongside CAS-001 review. Map visible encounter events to importance, component, text/value source, display priority and accessible fallback. Draft type specimens, semantic colour tokens and motion grammar (direction, enter/reveal/hold/exit, timing and easing). |
| 3 · Prototype and review | Prototype cinematic and phase flyouts and localized damage, resource and ICE feedback, including reduced-motion and reduced-flash variants. Review readability on the VAS-001 console and route exact design and implementation choices for designer approval. |
| 4 · Agree component contracts | Pair the event inventory with CAS-001 and the [gameplay/presentation contract](architecture-v2/GAMEPLAY_INTERFACE.md). Review the visible payload, placement, ownership, priority, consolidation, interruption and fallback for each binding before substantial scene implementation. |
| 5 · Build and integrate | After the applicable design and architecture reviews, build reusable Godot 4.3 GL Compatibility presentation components and bind them to actual visible events in one playable representative encounter. Keep authoritative game state and action resolution isolated. |
| 6 · Verify, playtest and finalize | Record reproducible parity checks, component and screenshot evidence, competing-event and accessibility checks, and repeated playtests. Resolve findings, publish final specifications in the UI Bible and record designer acceptance in [issue #24](https://github.com/Punkwork/REDLINE/issues/24) and Master Design. |

**Component dependencies:** flyout overlay and encounter transition presentation (hierarchy and sequencing), ICE console/subroutine keys and strength readouts (state and outcome feedback), card/hand and installed programs (selection, targeting, installation and resolution), TRACE, Vitae, Bandwidth, RAM and Shield (thresholds and deltas), extraction and Ghostware display (reward and acquisition). Only bind events available in the approved slice. NUL/REM psychological typography remains a separate experiment outside milestone acceptance.

**Acceptance evidence**

- [ ] All core slice events have a reviewed treatment and data source. Documented type, colour, motion and reduced-effect specs use the four style references and current approved copy.
- [ ] Reusable Godot components demonstrate real events in the playable representative encounter. Overlapping events resolve to a consistent presentation priority or consolidation, with no lost essential information.
- [ ] Contrast meets 4.5:1, the flyout-only overlap rule holds, and reduced-motion and reduced-flash modes preserve readability, input and outcomes.
- [ ] Reproducible comparisons against `prototype-baseline` confirm unchanged rules outcomes, ordering, choices and copy/reveal guards with effects enabled or reduced. Component tests and display-backed fixtures are recorded under the existing migration validation.
- [ ] Repeated playtests demonstrate readability, pacing and acceptable visual fatigue. The designer accepts the final system against linked evidence.

Use [#24](https://github.com/Punkwork/REDLINE/issues/24) for UI work and [#21](https://github.com/Punkwork/REDLINE/issues/21) for the representative slice. Existing ARCH-V2-001 review and parity gates, DOCS-MIG-001 and RELEASE-002c remain in force. Design exploration can begin alongside architecture review. Scoped production implementation and milestone acceptance require the established approvals.

### Progress measurement

The [Operations Dashboard](operations/README.md#project-progress--ops-002) owns the live snapshot, not a duplicate roadmap. Report milestone gates accepted / total, plus per-gate stage (not started, design, built, verified, accepted, or unknown), blockers, next evidence and dated source/commit. Built is not verified; verified is not accepted. Gate count is a readiness indicator, not percentage of effort or time. Do not infer percent complete from commits, lines of code, documents or issue counts. Overall effort-weighted percentage remains unknown until designer confirms scope, milestone weights and measurable acceptance checklists; if adopted, calculate accepted weighted checklist items / total approved weight, show unknown coverage and record scope changes separately. Never silently inflate progress. Reopened gates reduce readiness. At 22:00 Toronto daily review, update snapshot from actual evidence, show change since last review, identify next gate and link proposed next-day priorities to milestone IDs. If no evidence changes, record no verified change. Existing governance and audit gates remain binding.

## OPS-002a — Commercial Steam release (DIRECTION, 2026-11-24)

Designer explicitly confirmed: “Panopticon needs to go to market. This is part of the intention of this project from the beginning. Steam is the intended platform.” This supersedes the earlier releasable-only goal.

**Ultimate goal:** To develop and commercially release PANOPTICON on Steam as a complete, distinctive cyberpunk deckbuilding roguelike that combines strategically rewarding gameplay, meaningful replayability, a cohesive Atomic Deco Punk aesthetic and an emotionally compelling relationship between the Rustler and NUL/REM. Through mechanics, narrative and presentation, PANOPTICON explores surveillance, autonomy, voluntary imprisonment and the contradictions of protection, allowing players to discover these themes through experience rather than explicit explanation.

**M08 — Final release acceptance (expanded proposed criteria):** all three corporations playable end to end; approved mechanics and content implemented, balanced and tested; approved NUL/REM dialogue, character and narrative integrated; philosophical ambitions expressed through experience; visual design, animation, sound and interface meet established artistic standards; replayability, pacing and strategic depth demonstrated through playtesting; release-blocking defects resolved; designer accepts final release candidate. Retain OPS-002 artifact, checksum, documentation and distribution evidence requirements.

**M09 — Commercial Steam launch (new proposed gate):** Steamworks onboarding and applicable store/build review requirements satisfied; rights, licensing, store assets, pricing, launch configuration and support arrangements confirmed; designer authorizes launch; approved production build is publicly available for purchase on Steam, with store URL and release/build evidence recorded. Store preparation may proceed in parallel subject to authorization. Verify current Steam requirements before implementation. No actual publication, spending, pricing, launch date or account action authorized by this decision. Post-launch support scope remains open.

Progress is measured not simply by how much of PANOPTICON has been built, but by how much closer it has come to fulfilling its intended player experience and reaching commercial launch. Nine gates now proposed; weights and acceptance thresholds remain open.


## 8. Documentation migration gate (DOCS-MIG-001)

Designer-authorized 2026-11-24. Consolidation must reduce clutter, not create parallel authorities. Work in controlled batches on `architecture-v2` (originally "on main" when authorized 2026-11-24; branch corrected by ARCH-V2-002, 2026-11-25, intent unchanged), with one atomic completion commit per batch. No subsequent consolidation batch may begin until the preceding batch passes this gate.

Before declaring a batch complete:
- Inventory source content and dependencies; preserve unique material, decision IDs, approval status, provenance and historical records. Relocate narrative or other out-of-scope material to its appropriate canonical destination before retirement.
- Reconcile duplicates and superseded specifications against Master Design; do not silently resolve genuine design conflicts or change gameplay rules.
- Repair active references across the entire tracked repository, including relative links, anchors, source code, tests, CI, packaging and asset manifests. Preserve historical records accurately; use immutable historical links where needed.
- Validate all affected paths and anchors, and run applicable build/test checks if dependencies warrant them. Record commands, results, coverage and any unresolved failures. A partial scan or inaccessible files cannot count as a pass.
- Retire superseded documents from the active tree once their content and dependencies are verified. Git history preserves originals; temporary redirects are exceptions, not permanent duplicate documentation.
- Verify the final diff and canonical destinations, record the decision ID, evidence and completion commit in Master Design, HANDOFF and Development Log. Never mark an incomplete gate complete.

Claude Code should perform full-checkout dependency scans and validation; ChatGPT/Claude reconcile editorial content and design intent. Use the same repository records, not parallel backlogs. Escalate only genuine design conflicts or blockers to the designer. No new branch or rules changes authorized.

**Current blocking batch: UI-BIBLE-001.** Resume on 2026-11-25. Finish editorial reconciliation, narrative relocation, repository-wide dependency repair and validation, and legacy source retirement before starting any other documentation consolidation. Reference repair commit: 2f1727f698b4e5c084c5e3f12c280b68475565fa. Seven imported sources remain in the active tree; full validation has not passed. The existing daily review must carry this blocker into the next agenda until resolved.

## BYPASS-001 — Non-final encounter eligibility (LOCKED, 2026-11-24)

Designer explicitly established: BYPASS is possible only in encounters that are not the final encounter of a Node. A Node has up to three encounters. In a one-encounter Node BYPASS is prohibited; in a two-encounter Node only encounter 1 is eligible; in a three-encounter Node encounters 1 and 2 are eligible. No BYPASS on the final encounter. Eligibility alone does not grant a bypass. Specific triggers, targets, costs, consequences, passives, extraction and parting-shot interactions remain OPEN; earlier rapid-penetration and card ideas are proposals only. No implementation authorized by this record.

## EXP-DESIGN-001 — Design Experimentation Bible (DIRECTION, 2026-11-24)

Designer requested one all-domain [Design Experimentation Bible](PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md) for new ideas, scenarios, experimental cards and viability analysis. Initial BYPASS exploration recorded at 7e0928f42582a1faac5f552c4b98fa1e62509abe. Proposals are not rules; UI-WORKFLOW-001 native issue authority and existing topic catalogues remain. New document creation only; no consolidation or retirement while DOCS-MIG-001 gate open. No implementation authorized.

## BACKCHANNEL-001 — Preferred experimental iteration (2026-11-24)

Designer endorsed EXP-C029 BACKCHANNEL, 2 BW SCRIPT, supporting ICE STR <=2, suspend one non-DEADLOCK sub; bypass if all primary ICE subs broken by end of next Rustler turn, otherwise end suspension. [Experimentation Bible](PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md) (ddc4793ce6d41b500c1086c9d209fe61e07f64c7) owns detailed alternatives, scenarios and open questions. BYPASS-001 unchanged; no formal rule adoption or implementation authorized.

## NULL-POINTER-001 — Cost adjustment (APPROVED, 2026-11-24)

Designer explicitly approved reducing NULL POINTER from 2 BW to 1 BW. All other properties unchanged. Deck Synergy §9.2 updated (08b5b6f6e0ea3b43d46924849fecb889d9a18955). Runtime card database remains at 2 BW pending Claude Code synchronization and tests; this request is documentation only.

## RIOT-EXP-001 — RIOT experimental card catalogue (ChatGPT)

Designer requested preservation in Experimentation Bible §11 (bdc32508a880a9925010b0dde4bdbf0ac7b0fc57). EXP-C030–036, M007, S012–021, X005; revised FIRST STRIKE and one-copy BREAKER BAR with per-copy node escalation and BURN cost. Experimental only; NULL-POINTER-001 remains approved separately. No code or tests; UI migration gate unchanged.

## TRACE-EXP-001 — TRACE mitigation concepts (ChatGPT)

Designer requested preservation of SIGNAL DAMPENER (Ghostware) and four Protocols in Experimentation Bible §12 (bc9938aa034cf6a39c6114472b4688b056e6cf1f); EXP-C037–041, M008, S022–027, X006. Proposed type distinction, self-inflicted TRACE coverage and trigger timing remain experimental. No rules/code changes, tests or consolidation.

## NUL-DIALOGUE-003 — Economic dependency dialogue (ChatGPT)

Designer requested preservation of four lines NR-076–079 in NUL/REM Dialogue Compendium (28cd6dea0d23821902a025414a3333724c4b365c). Verbatim dialogue; contextual triggers and associations proposed. No shipping approval, gameplay changes, tests or consolidation.

## CRED-EXP-001 / PHIL-005 — CRED-powered combat and economic dependency (ChatGPT)

Designer requested preservation of eight cards EXP-C042–049, mechanics M009–011, scenarios S028–034 and experiment X007 in Experimentation Bible §13 (bf8d742d3783d4cdb2a11e17e62d442b7fc8de52), and economic dependency/purchased freedom in Philosophical Design Bible §11 (aaafd9993e811a2a8b1169a9e9f3ed68b97f0bf6). Fully CRED-powered Icepick activations consume no BW; installation costs open. All mechanics experimental; philosophical direction designer-endorsed, not a new formal pillar. NR-076–079 already saved. No rules/code changes, tests or consolidation; UI migration blocker unchanged.

## CRED-EXP-001a — Icepick installation cost (ChatGPT)

Designer specified 1 BW installation for PAYDAY, BRIBE and MERCENARY (EXP-C042–044); all activations remain CRED-only. Experimentation Bible §13 updated (9cfc95fe920dbfd5abfded3bccda06174cabec2b), including S035. Supersedes open installation cost in CRED-EXP-001 for these three cards only. Experimental, no code or tests.

## CRED-EXP-001b — Program classification (ChatGPT)

Designer clarified EXP-C042–044 are RAM-using PROGRAM Icepicks, 1 BW install, CRED-only activation. Exact RAM TBD; 1 RAM suggested only. Experimentation Bible §13 corrected (0045b0d693b7386b6a6a83c83ca194e92005d784); canonical Core Rules §3.1 unchanged. No code or tests.

## CRED-EXP-001c — Icepick RAM requirements (ChatGPT)

Designer specified PAYDAY 1 RAM, BRIBE 1 RAM, MERCENARY 2 RAM. Experimentation Bible §13 (a28329f275b87bd1d163e4e798cf5859b5e96958), EXP-S036; supersedes TBD RAM in CRED-EXP-001b. Other values unchanged. Experimental only; no code or tests.

## VOID-EXP-001 (ChatGPT)

Saved exploratory VOID-only UNLOAD, Rustler-selected Program removal to discard, Program opportunity costs, EXP-M012/S037–042/X008 in Experimentation Bible §14 (171674b7e8b34d0dd4dad805b9861da4e22b0d0b). No rules/code/tests or consolidation.

## CRED-EXP-001d — CRED SCRIPTS and card-type identity (ChatGPT)

Designer confirmed EXP-C045–049 as 0 BW SCRIPTS with existing CRED prices/effects, one resolution per play, normal discard/redraw, prior activation caps removed in preferred experiment. EXP-M013/S043–044, X007 extension in Experimentation Bible §15 (8d75932dad452669d6aefc0864bda40092e118df). Existing Protocols unchanged; experimental guidance only, no rules/code/tests or consolidation.

## ICE-EXP-002 — Encounter-wide effects and subroutine modification (ChatGPT)

Saved 20 proposed cards EXP-C050–069, mechanics M014–015, scenarios S045–052, experiments X009–010 in Experimentation Bible §16 (27d5fb2ea234eaa8b1ebc87dada42b021fee6b17). Designer's targeted -6 PULP this turn/BURN preserved; names/costs provisional, collisions flagged. No rules/code/tests or consolidation.

## CAP-EXP-001 — Infiltration CAPS (ChatGPT)

Saved twelve non-card CAP concepts EXP-CAP001–012, M016, S053–057 and X011 in Experimentation Bible §17 (98bc0b716700ad6aac90a6bc614b46496b5425c0). No CRED prices or rarities assigned; map activation and circumvention experimental. Existing CAPS rules unchanged. No code/tests or consolidation.

## SURV-MEM-001 — Surveillance and memory (ChatGPT)

DIRECTION, designer-confirmed: “As the player learns the game, the game learns the player.” “The system always remembers. It never forgets.” Pervasive fictional surveillance across runs. Five-stage table and proposed memory layers saved in Experimentation Bible §20 (57bfe20002567740e0e91cde85a809df280ce7e2); prior ICE-SURV-EXP-001 / SURV-EXP-001 proposals in §§18–19 (eb335be5b95c05488f3a966f5d90a47280675523). Philosophical Bible cross-reference. No approved mechanical changes, code, tests or consolidation. Interpretation: thematic persistence does not remove real-world local data reset or privacy controls.

## CARBON-SURV-EXP-001 — Collective trust and individual authority

Designer-endorsed philosophical exploration: keep THE CARBON (collective trust) and NUL/REM (personal autonomy) distinct. Corporate appropriation of trusted resistance spaces may erode collective trust and increase reliance on individual authority. “The system creates the conditions that make its own assistance necessary.” Full progression, examples, comparative framework and open questions preserved in [Design Experimentation Bible §21](PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md), commit 02e46011863db27f2ac03ed922aa038358bc8a77. EXP-D003 / EXP-X013 remain proposed; no mandated psychological outcome, approved mechanics, code, tests or consolidation.

## SURV-UNCERT-EXP-001 — The uncertainty of observation

Designer-endorsed exploration: possibility of observation, fictional fear/anxiety/suspicion, ambiguity of coincidence, self-regulation and freedom exhaustion. Designer identified Francis Ford Coppola's The Conversation (1974) as reference. Preserve the “constant low hum anxiety” experiential direction as fictional atmosphere, not deliberate actual distress. Linked to SURV-MEM-001 and CARBON-SURV-EXP-001. Full tables, examples and safeguards in [Design Experimentation Bible §22](PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md), commit 6b36c117b89c4f32edfef77c7241c8fb6db59a28. No approved mechanics, production dialogue, code, tests or consolidation.

## SURV-OBSERVER-EXP-001 — The Internalized Observer

Designer confirmed The Parallax View (1974, Alan J. Pakula) and The Conversation (1974, Francis Ford Coppola) as principal cinematic references. Recorded in Design Experimentation Bible §23, commit 307703473a5a9f3ec8a9fe0a6f34800815d2342b. Reference-only; no new rules, specifications, code or tests.

## ARCH-V2-002 — `architecture-v2` is the canonical branch; `main` reconciled and preserved (APPROVED, 2026-11-25)

**Designer, 2026-11-25:** "For number 1, yes, Architecture V2 is the main branch for the rebuild. This is the current direction moving forward, and so record that in master design. For the baseline tag, yes. Duplicate images, yes. Please delete the 1 copy. I do want the new branch as the default."

**Decision:** `architecture-v2` is the canonical active branch moving forward and is approved as the GitHub default branch. `main` is the preserved legacy prototype and historical reference; its tip `21922ad` is tagged `prototype-baseline`. `main` was merged into `architecture-v2` once, with both histories preserved (merge `6b1acdd`), so the 182 documentation commits from `main` (UI-BIBLE-001, UI-WORKFLOW-001, DOCS-MIG-001, OPS-001/002, NUL-PILLAR-001, PHIL-001–005, NUL-DIALOGUE-*, experimental records) and the 43 ARCH-V2-001 commits now live together. Agent instructions (`AGENTS.md`, `CLAUDE.md`), HANDOFF, operations and status docs point to `architecture-v2`. The byte-identical duplicate VAS-001 reference image was removed.

**Supersedes for branch choice only:** MAIN-001 (`main` as working branch) and the `main`-default wording in RELEASE-001. RELEASE-001's procedure still governs prototype builds from `main`; a release procedure for `architecture-v2` is not yet designed or approved. Everything else in ARCH-V2-001 is unchanged: the blueprint, CAS-001, scene hierarchy and VAS-001 implementation details remain PROPOSED, and no gameplay, balance or rules change is implied. Experimental records keep their status. DOCS-MIG-001 / UI-BIBLE-001 remains OPEN.

**Completed by the designer (2026-11-25):** the agent session could not push tags or write repository settings, so the designer created tag `prototype-baseline` on `21922ad` (GitHub pre-release) and made the default-branch switch to `architecture-v2` was made by the designer on 2026-11-25 and verified via the GitHub API.

**Recorded ARCH-V2-002 items and how each is put into practice:**

| # | Item | Source | Where it is put into practice |
|---|---|---|---|
| a | `architecture-v2` is the canonical active branch for all project work | Designer, 2026-11-25 (quoted above) | AGENTS/CLAUDE header and §1; HANDOFF "How we work"; operations README |
| b | `main` is the preserved legacy prototype; no new work goes to it | Designer, reconciliation brief 2026-11-25 | AGENTS/CLAUDE §1; daily branch-drift check (OPS-001) |
| c | Reconcile by a history-preserving merge of `main` into `architecture-v2` | Designer, brief §7 and Gate B approval | Merge `6b1acdd` |
| d | Tag the baseline `prototype-baseline` on `21922ad` | Designer, 2026-11-25 | Tag created by the designer; AGENTS/CLAUDE §6 |
| e | Remove the duplicate VAS-001 reference image | Designer, 2026-11-25 | Commit `b03df7f` |
| f | `architecture-v2` is the GitHub default branch | Designer, 2026-11-25 | Switched by the designer; AGENTS/CLAUDE §1 |
| g | Architecture V2 takes precedence over legacy UI implementation conventions for future Godot UI | Designer, brief §6; restated in the 07:44 audit | AGENTS/CLAUDE §4 and §7 |
| h | Atomic, decision-grouped commits wherever practical, not only for doc consolidation | Designer-relayed ChatGPT audit, 2026-11-25 07:44 | AGENTS/CLAUDE §1 rule 7 |
| i | Branch drift monitoring in the daily operations review | Designer-relayed ChatGPT audit, 2026-11-25 07:44 | operations README; REPORT_TEMPLATE |
| j | Protect `main` against unintended changes | Designer-relayed ChatGPT audit, 2026-11-25 07:44 | AGENTS/CLAUDE §1; daily drift check. GitHub ruleset `protect-main` created by the designer 2026-11-25 (active; blocks deletion, force-push, updates and creation on `main`; no bypass), verified via the GitHub API |

**Mapping of the eight decisions (ChatGPT re-audit, 2026-11-25 07:56):** 1 canonical branch = a; 2 history-preserving merge = c; 3 preserve and freeze `main` = b and j; 4 Architecture V2 precedence = g; 5 default branch = f; 6 atomic decision-grouped commits = h; 7 daily branch-drift monitoring = i; 8 formal decision ID = ARCH-V2-002 itself. Items d (baseline tag) and e (duplicate image) are separately authorized. The a–j register stands; no renumbering.

**Acceptance record (2026-11-25):**

| Requirement | Status | Evidence |
|---|---|---|
| Both Git histories preserved | Verified (Claude) | `21922ad` and `6cb5ed1` are ancestors of `847de9b`; no `main` commit unreachable |
| Approved decisions and experimental statuses preserved | Verified (Claude) | No decision ID lost from Master Design, Experimentation Bible, Manifestations, UI Bible, Core Rules or HANDOFF at either tip; only status-line change is the annotated ARCH-V2-001 note |
| Architecture V2 specifications preserved | Verified (Claude) | Only change in `docs/architecture-v2/`: one-line tag annotation in MIGRATION_PLAN |
| No unintended source-code changes | Verified (Claude) | `godot/`, tests, tools, CI, prototypes identical to `prototype-baseline` except the VAS-001 image and its README |
| Local work preserved | Verified (Claude) | Session clone was fresh: no uncommitted, stashed or unpushed work; the trial-merge branch stayed local and was deleted; local and remote `architecture-v2` both `847de9b` |
| Recovery points and rollback | Verified (Claude) | Recovery points: tag `prototype-baseline` (`21922ad`), `release` `2845ecd` and `playtest-N` tags, pre-merge v2 tip `6cb5ed1`. Rollback rehearsed in a discarded worktree: `git revert` of `847de9b 3ddbad9 89533e1 771636d dcdbeca b03df7f`, then `git revert -m 1 6b1acdd`, gives a tree identical to `6cb5ed1`. Never force-push |
| Regression tests | Verified (Claude, recorded execution) | Godot 4.3 headless: import 0; test_game 176/0 (also SIM=1 on baseline); test_adp 17/0; test_signal_carbon 672/0, on baseline, merge and `3ddbad9` |
| Baseline tag target | Verified (Claude, API/git) | `refs/tags/prototype-baseline` → `21922ad` |
| `main` protection | Verified (Claude, API) | Ruleset `protect-main` (28076208): active, `refs/heads/main`, deletion / non_fast_forward / creation / update, no bypass |
| Agent instructions consistent | Verified (Claude and ChatGPT) | AUDIT-001/002/003 corrected; AGENTS = CLAUDE |
| ChatGPT automations aligned | Reported (ChatGPT) | Daily Review and Interface Improvement updated to `architecture-v2` |
| Screenshot fixtures, Windows export, Windows playtest | Untested | Fixtures skipped while `Game.CORE_LOOP` is true; export and playtest not run |
| Claude Project copies aligned | Outstanding | Copies predate ARCH-V2-001 (HANDOFF TO DO) |
| Codex configuration aligned | Outstanding | Not accessible to Claude or ChatGPT |

ChatGPT's independent check of `main` references covered the principal governance documents, not an exhaustive repository-wide scan; Claude's scan was repository-wide. Tag, ruleset and test evidence come from Claude's execution and API checks.

**Status:** reconciliation recommended for acceptance by ChatGPT (re-audit 2026-11-25) and **ACCEPTED by the designer, 2026-11-25 08:23** ("Reconciliation accepted."). The untested and outstanding items in the table above stay open and are not covered by this acceptance. Full operational closure waits on the Claude Project copy refresh and Codex alignment.

**Interpretation to confirm:** the designer said "main branch for the rebuild" and "the current direction moving forward"; this is recorded as covering all project work (design, philosophy, operations and code), as in the 2026-11-25 reconciliation brief.

## UI-BIBLE-001 completion — documentation migration gate passed (DOCS-MIG-001, 2026-11-25)

**Designer, 2026-11-25 11:39:** "approved for all 4. Continue" (UI-BIBLE-001 completion, GitHub Issues for UI, Architecture V2 release procedure, UI-TYPO-001).

**Batch result:** the UI Design Bible is the single UI specification. Its seven imported sources are retired from the active tree: `REDLINE_VISUAL_LANGUAGE.md`, `REDLINE_ENCOUNTER_ANALOG.md`, `REDLINE_UI_NULREM_Design_For_Claude.md`, `REDLINE_ATOMIC_DECO_PUNK.md` and `visual/concept-art/UI_KIT_BRIEF.md`, `_2.md`, `_3.md`. Git history keeps them; the Bible's source headings link to their last version (`8ef0bbe`).

**Gate evidence:**

| Gate step | Result |
|---|---|
| Inventory and preservation | Each source's import was compared line by line with the original: all seven identical (only separator lines added). After retirement, every non-blank line of every original is present in the Bible or the Dialogue Architecture appendix (0 missing of 1,124 lines). Decision IDs, approval statuses and provenance unchanged. |
| Narrative relocation | Source 3 §6 (NUL/REM personality design bible: six modes, dialogue behaviour, hacker-history anchors, approved tonal examples) moved unchanged to `PANOPTICON_NULREM_DIALOGUE_ARCHITECTURE.md` Appendix A, with a pointer left in the Bible. |
| Editorial reconciliation | Bible §4 now maps each retired path to its section and lists the already-recorded supersessions affecting imported text. No genuine design conflict found; nothing resolved silently; no gameplay rule changed. |
| Reference repair | Active references repaired across the full checkout: Archipelago, SAMIZINE, ADP Phase 2 copy, Corporate Facades, Master Design (11 pointers), two exploration READMEs, `godot/assets/concept/ui/README.md` and one code comment in `encounter.gd`. Historical records (development log and archive, HANDOFF *Done* rows, `REDLINE_BIBLE.md` verse provenance, the Master Design provenance note) kept as written. CI and packaging use none of the retired files. 12 log anchors broken by earlier LOG-001 moves repointed to the archive. |
| Validation | Relative links: 142 checked, 0 broken files, 0 broken anchors (GitHub heading slugs). Godot 4.3 headless: import 0; test_game 176/0; test_adp 17/0; test_signal_carbon 672/0. |
| Retirement | Seven files removed; `AGENTS.md` / `CLAUDE.md` §7 and §9 updated; no redirects left behind. |

**Completion commit:** the commit that adds this entry (see the development log). The gate's next batch may begin when the designer chooses it.

## RELEASE-002 — Playtest builds from `architecture-v2` (APPROVED with (a), (b) and (c), 2026-11-25)

**Designer, 2026-11-25 11:39:** approved drafting the Architecture V2 release procedure ("approved for all 4"). **The procedure below is a proposal.** RELEASE-001 stays in force until the designer approves it.

**Why:** RELEASE-001 cuts builds by fast-forwarding `release` to `main`, but `main` is now frozen (ARCH-V2-002). `release` (`2845ecd`, Playtest 12) is an ancestor of `architecture-v2`, so `release` can follow `architecture-v2` by fast-forward alone, with no history rewrite and no workflow trigger change. Exports already run only on `release` (`.github/workflows/godot-validation.yml`).

**Proposed procedure (each build only when the designer asks for it):**
1. **Prepare on `architecture-v2`:** one ARCH-V2-002h-style commit that bumps `config/version` in `godot/project.godot` and the artifact name in the workflow to the new playtest number, and updates the playtest guide and checklist bundled with the build.
2. **Check:** CI on that commit passes (import, rules, ADP, SIGNAL/CARBON and any Architecture V2 component tests and fixtures in the workflow's list).
3. **Cut:** fast-forward `release` to that commit and push. No commits are made on `release`, and it never moves backwards.
4. **Verify the artifact:** `BUILD_COMMIT.txt` matches the commit, `SHA256SUMS.txt` matches the `.exe`, and the guide and checklists are present. A successful export is not a Windows playtest; the designer's first launch is the hands-on check.
5. **Tag:** the designer tags the commit `playtest-N` (agent sessions can't push tags), then the agent verifies the tag.
6. **Record:** HANDOFF *Done* row, development log entry and operations report, with the commit, Actions run and artifact links.

**Recovery:** a bad build is fixed forward: a new commit on `architecture-v2`, then a new fast-forward cut. An earlier build is rebuilt by re-running the workflow on its tag. Resetting `release` backwards (a force-push) needs explicit designer approval each time.

**Prototype builds:** none are planned while `main` is frozen. `prototype-baseline` and the `playtest-4`…`playtest-12` tags stay as recovery points.

**Proposed alongside (each needs its own yes):**
- **(a)** Add `release` to a ruleset blocking deletion and force-pushes, so it can only fast-forward. The designer creates it in GitHub, as with `protect-main`.
- **(b)** Name the artifact from the version in `project.godot` instead of a hand-edited string, so step 1 can't leave a stale name. This is a CI change.
- **(c)** Before the first Architecture V2 build: the representative ICE encounter exists (ARCH-V2-001), its component tests and screenshot fixtures are in the CI list, and its behaviour matches the `prototype-baseline` test results.

**Designer, 2026-11-25 13:48:** "commit the release-002. 3 add-ons: a - yes b - yes c - yes"

**Status:** the procedure and (a)–(c) are **APPROVED**. RELEASE-002 replaces RELEASE-001 for every new build; RELEASE-001 stays as the record of prototype builds 4–12. (a) was created by the designer on 2026-11-25 (ruleset `release`, id 28104142: active, blocks deletion and force-pushes on `release`; fast-forward cuts still allowed; verified via the GitHub API); (b) is built in the workflow (RELEASE-002b: the artifact name comes from `config/version`, which must end in `-playtest.N`; it produces the same name as before for Playtest 12); (c) is the entry gate for the first Architecture V2 build.

## UI-TYPO-001 — Typography and the dual visual language: physical world and virtual world (APPROVED, 2026-11-25)

**Designer, 2026-11-25 (13:17–13:19):** "On typography there needs to be 2 distinct visual representations. The physical world, represented by the UI - 50's deco and atomic punk aesthetic, bakelite and formica and panels and knobs and switches, with a small crt display. THe second representation is the virtual world, governed by a hyper-kinetic gaspar noe-like title flourish, full of motion and electric colour."

**Decision:** PANOPTICON's typography and look have **two distinct visual representations**:

| | **Physical world** | **Virtual world** |
|---|---|---|
| Where | The UI: the Rustler's console and everything they touch | The virtual world |
| Look | 1950s Deco and Atomic Deco Punk: Bakelite and Formica, panels, knobs and switches, with a small CRT display | Governed by a hyper-kinetic title flourish in the manner of Gaspar Noé's title sequences: full of motion and electric colour |

**Unchanged:** readability rules (contrast ≥ 4.5:1; nothing crosses rule text, numbers, names, costs or buttons; ADP-R1), reduced-motion settings, the copy guards and the rules engine. No gameplay change. Glyph choices, fonts and where exactly the boundary falls on each screen are open and go through the UI-TYPO-001 GitHub issue ([#24](https://github.com/Punkwork/REDLINE/issues/24)).

**Reference images (added 2026-11-25 13:28; 1280 × 720 originals 13:36):** four images in [`visual/references/ui-typo-001/`](visual/references/ui-typo-001/README.md): 01 aggressive flyouts, 02 refined flyouts, 03 title announcements, 04 event typography catalogue. They show the virtual world as **event flyout titles** (RUNNER TURN, CORPORATION RESPONSE, DEADLOCK BREACHED…) sweeping across the unchanged physical console, credited to Atomic Deco Punk with Gaspar Noé and Tom Kan influences. Style references only: labels such as SYN, Neural damage and the full-extraction bonus predate current rules and are not to be built (README).

**Readings confirmed (designer, 2026-11-25 13:48):** "#24 - 1 yes; 2 - Yes; 3 - sort of - i Imagine the flyouts would cover elements on screen but A - not for more than 1 -2 seconds B - would not hide anything"
1. **Confirmed:** the physical style covers the console UI, HUD, cards and controls; the virtual style is the event flyout titles over the console (about 1.3–1.5 s: enter, reveal, hold, exit), with the refined treatment for frequent events.
2. **Confirmed:** the "small CRT display" is the console's existing CRT, the physical world's window onto the virtual one.
3. **Amended (UI-TYPO-001a):** event flyouts **may pass over on-screen elements**, including rule text, numbers and buttons, but (A) **for no more than 1–2 seconds** and (B) **without hiding anything**. This is a narrow exception to ADP-R1 for flyouts only; every other effect still may not cross rule text, numbers, names, costs or buttons. Reduced motion still applies. **Confirmed (designer, 2026-11-25 14:26: "yes that is what i meant"):** "would not hide anything" means what's underneath stays readable through the flyout (for example, see-through or offset from key values) and nothing is removed or replaced while it shows.

**Designer follow-up (2026-11-26, UI-TYPO-001 / UI-TYPO-001a):** Approved the visual exploration direction in *UI Prototype Exploration* and directed the Typography & Motion Design System milestone to run alongside Priority 1. The [UI Bible](PANOPTICON_UI_DESIGN_BIBLE.md#typography-and-motion-exploration-constraints-ui-typo-001--ui-typo-001a) carries the event hierarchy, refined and aggressive reference treatments, event-specific motion, stable console, dynamic engine-driven overlays, competition handling and reduced-effect constraints. Exact specifications and architecture bindings are for review. Psychological typography remains experimental. See the [project plan](#typography--motion-design-system-milestone-m06--priority-1-companion) and [issue #24](https://github.com/Punkwork/REDLINE/issues/24).

## ARCH-V2-003 — Batch 1: representative ICE encounter components and UI alignment requirements (APPROVED IN PRINCIPLE, 2026-11-26)

**Designer, 2026-11-26 07:47 (Toronto), approving the Batch 1 proposal in the [2026-11-26 Claude Code inventory](operations/reports/2026-11-26-Claude-Code.md):** "Batch 1 is approved in principle, subject to the following UI alignment requirements before production implementation. Visual authority: VAS-001 remains the overarching visual and compositional reference. However, V1 Build 12 remains the functional interaction reference for subroutine controls. Combine the strengths of both; do not reproduce the textual subroutine rows in VAS-001." … "The governing UI principle is: Icons communicate. Numbers quantify. Hover panels explain. Typography announces."

**Decisions recorded:**
- **(a) Visual authority.** VAS-001 is the overarching visual and compositional reference; V1 Build 12 (ICE-ANALOG-001) is the functional interaction reference for subroutine controls. VAS-001's textual subroutine rows are **not** reproduced. Settles inventory question D1.
- **(b) C08 ICE panel: four functional zones:** identity, virtual expression, tactical controls, persistent status. Keep the ICE nameplate. The ICE type icon overlaps the portrait frame's upper-left corner; the STR icon and number overlap the nameplate's upper-right corner. Preserve negative space; no filler instruments or information.
- **(c) Terminology.** "Sentry" is deprecated; use **VOID ICE** and its icon. (The rules engine already uses VOID; VAS-001's mockup label is illustrative.)
- **(d) C09 subroutine controls:** horizontally sequenced, illuminated electromechanical keys, not numbered text rows. Effect type, magnitude, execution order, current BW break cost, modifiers, visibility and interaction state are carried by icons, numbers and spatial arrangement. Build 12's TUMBLER attributes, hidden-subroutine behaviour and multi-effect representation are preserved. Controls large enough for comfortable recognition and interaction. Full rules belong in hover panels with equivalent keyboard access and no disclosure of hidden information.
- **(e) Response display:** the shared NEXT RESPONSE rail, **provisionally**; no duplicated persistent information under individual ICE panels. Final presentation subject to visual review. Settles D2 provisionally.
- **(f) Announcement wording APPROVED:** **RUSTLER TURN** and **CORP COUNTERMEASURE**. The reusable flyout architecture, proposed timing (≤ 1.5 s) and reduced-motion constraints are approved; final typography and motion treatments remain under active design development (UI-TYPO-001).
- **(g) Screen size APPROVED:** 1536 × 864 reference composition within the existing 1600 × 1000 environment; project settings unchanged; responsive layout testing kept. Settles D3.
- **(h) Engineering approved in principle:** the sandbox, controller (C02), adapter (C04), testing strategy, production file ownership (Claude Code) and separation from Codex's visual fixtures (`godot/tests/visual/`).
- **(i) Coordination.** Agree the latest visual reference with ChatGPT and Codex before locking component geometry or icon treatments; keep presentation assets and layout parameters replaceable so visual exploration needs no architectural rework. Confirm alignment before finalizing visual components.

- **(j) Badge hover wording (designer, 2026-11-26 08:20):** "For ice Types display the type of ice [Fortress, Tumbler, Void] for STR display the word 'ICE STRENGTH: [str value]' where the str value is the current STR of the ice." The type badge's hover panel shows only the type (FORTRESS, TUMBLER or VOID); the STR badge's shows only `ICE STRENGTH: n`, n being the ICE's current STR. No explanatory rule text.

- **(k) STR medallion shows the number only (designer, 2026-11-26 08:24):** "there is a small icon like a circle just above the ice strength in your UI build, - it should be removed … it obscures the ICE STR value." The drawn strength glyph is removed; the medallion carries only the current STR, centred.
- **(l) Asset production split (designer, 2026-11-26 08:24, "Yes that split works for me"):** painted hero pieces from ChatGPT image generation (prompted by the designer), stretchable structure and live effects built in the engine by Claude Code, existing painted ENC-CONCEPT-001 art reused as stand-ins. The parts list, sizes and prompts are in [`architecture-v2/VAS-001_ASSET_SPEC.md`](architecture-v2/VAS-001_ASSET_SPEC.md) (VAS-ASSET-001, **PROPOSED**).

- **(m) END TURN is a key, not a dome (designer, 2026-11-26 14:22):** "remember we are trying to preserve as much negative space to adhere to good design principles. So i think the end turn button could/should be a smaller different type of button such as the buttons we were discussing for the subroutine icons." END TURN uses the illuminated electromechanical key family of the subroutine controls (Build 12 key art), larger than a subroutine key, icon-first (handover icon; "End turn" and its shortcut on hover/focus), lit when the turn can end. The mockup's domed button and the red lamp bar above it are dropped. **Negative space** is a standing priority for every V2 component.
- **(n) Counter stack is icon + number (designer, 2026-11-26 14:17):** "Icon + number is perfect." Deck, discard and burned show an icon and a number; names on hover.
- **(o) The hand is splayed and fanned (designer, 2026-11-26 14:57):** "The cards in hand need to be splayed out and fanned as in the reference image." Cards spread across the tray in hand order, tilt away from the centre, sit slightly lower at the edges and rise above the tray's top edge as in VAS-001; hover or keyboard focus lifts a card to the front. Fan parameters (tilt, overlap, arc, lift) are PROPOSED and live in `hand_fan.gd`.
- **(p) ICE avatars stay large, with room for speech bubbles (designer, 2026-11-26 15:00):** "the ice avatars are way too small in this 3 ice void mockup. There should be room for their text / comic bubbles as well." Three ICE use a taller panel: avatar top left (about 160 px on screen at 1600 × 1000), nameplate and speech bubble beside it, keys in a full-width bed below. Every panel reserves a speech-bubble zone (superseded by (r): bubbles are momentary overlays). The avatars are the designer's revised ChatGPT set (three moods per ICE; mood follows FORM-001, transitions per MOOD-PIXEL-001). Geometry PROPOSED. *Open:* what drives the bubble's line and when (working: none in play yet; fixtures show approved ADP mood lines).
- **(q) Composition-pass interpretations confirmed (designer, 2026-11-26 14:57):** APPROVED: the phase plaque icons (fanned hand = Rustler turn, lens = Corporation turn); the RAM chip icon; the hourglass beside the turn counter; the small CRT's quiet phosphor trace; the ad plate's HALCYON line. "For now": the effects card shows only the CORTEX stamp and the next-turn BW drain. Still open: HOSTILE REVEAL, LAYER and EXTRACT (left out of the header).
- **(r) Encounter focus: avatars, subroutines, cards in hand (designer, 2026-11-26 15:25):** "For encounters in general the focus should be on: Avatars, Subroutines, Cards in hand … they should stand out." Supersedes the geometry in (p):
  - **Avatars** are as large as in VAS-001 and take at least half of the window's field, frameless; the panel bezel is drawn thin so the field gets the pixels.
  - **Speech bubbles are momentary** ("the comic text bubbles are momentary speech and should cover everything else under it for a moment (1-2 seconds)"): no layout room; the bubble overlays the panel for 1.6 s (working value) then goes.
  - **Subroutine keys may overlay the avatar's lower edge**, separated by a drop shadow ("As long as there is a drop shadow or some layer differentiation … it should be fine"). Six subroutines must not look awkward with three ICE (tested: six keys ≥ 44 px inside the panel).
  - **Keys are thick raised panel buttons lit from within, with a slight glow** ("thick raised buttons that light up on old panels … Even a slight glow around each subroutine button … makes a lot of difference"). Built as a drawn renderer (`lit_key.gd`); the cap's light carries the state (cream-amber ready, red DEADLOCK, bright red hit, amber tumbled/booting, unlit broken, smoked glass hidden). PROPOSED; the designer offered reference images if needed.
- **(s) Screen layout change (designer, 2026-11-26 15:34 and 15:37):** "stretch the main window [with] all 3 avatars across the entire screen, pushing the TOP LEFT CRT … down, the 5 icons to be moved to the right of the hand of cards, the paperclip and paper just below the crt now in the bottom left corner, eliminate the second crt … get rid of that funny looking end of turn button … It can look like something that slightly resembles a power on / off button. Circular with a notch in it. or … a return carriage button like on the commodore 64, and just as brown"; then "Move that end turn button to the very bottom right corner of the UI". Built: the ICE enclosure spans the full width (panels widened to 700 × 352, three ICE 720 × 550); the CRT is lower left and holds the rig chips (the second CRT is gone, so its job moved here; the phosphor trace from (q) is dropped with it); the effects note sits below it; the five meters are right of the hand, then deck/discard/burned; END TURN is a small round C64-brown power button (circle-with-notch symbol, amber lamp ring when the turn can end) in the bottom-right corner. The side pipe is removed.
- **(t) ICE speech follows ADP-2b (designer, 2026-11-26 15:37, pointing to the UI Design Bible Phase 2 and Copy Pack §2):** hovering one card for 4 s makes the ICE with the highest mood say an approved hesitation line; 20 s cooldown; at most once per turn; disabled while dragging; flavour only. Built as `HesitationVoice` (ported from Build 12); the bubble shows 2 s (working value inside the designer's 1–2 s). Mechanical ICE responses stay per Core Loop §1.
- **(u) Hand, counters and rig (designer, 2026-11-26 15:45):** the deck/discard/burned counters lose a third of their width and turn horizontal under the five meters, so the hand tray widens; the hand holds **up to 12 cards**, fanned so at least the left half of each card shows (hover panels describe each card). The CRT is the rig: each installed program is a **HuCard cartridge** with a sliver sticking out of the top of the CRT (PC Engine / TurboGrafx-16); clicking a cartridge shows the program on the CRT and makes it active. Built: cards 140 × 221 in the fan; the CRT shows the program's name, the ICE type it breaks, STR and break cost in BW (icon + number; full rule on the cartridge's hover); the active cartridge sits raised with a phosphor glow and becomes `EncounterController.active_program`, the program a key click uses (Build 12's "program last used"); no Game call. *Interpretation to confirm:* "activate its effects" read as making it the active program for breaks; dragging a cartridge onto a key still works.
- **(v) Subroutine keys on the right side, two rows past four (designer, 2026-11-26 15:51):** "orient / align the subroutine icons to the right side of the ice panel. if more than 4, start a second row with 3 on the bottom and the first 2 on the top row. Subroutine order matters." Keys are right-aligned in the panel's right half; up to four in one row; five = S1 S2 on top, S3 S4 S5 below; six = 3 + 3 (approved, (w)); the TUMBLER reel follows the last row. Order reads left to right, top row first.
- **(w) Designer answers, 2026-11-26 16:00–16:02:** (1) "there are multiple effects such as boost icepick that will be selected from the CRT": the CRT carries the selected program's actions as phosphor keys: BOOST (Icepicks; +STR for its BW cost, until the end of the turn, `Game.boost_pick`), UNINSTALL (cache programs such as SMASH & GRAB, `Game.uninstall_cache`) and EJECT (unload, 0 BW, `Game.unload`), the Build 12 rig actions, one Game call each through `EncounterController`. Clicking a cartridge still selects it and makes it the program key clicks use. (2) **Six keys split 3 + 3: APPROVED.** (3) No arrow between key rows needed; an optional brass carriage-return mark was drawn for comparison (`v2_15_row_return_arrow_option.jpg`), off by default.

**Status:** Batch 1 **APPROVED IN PRINCIPLE**. Implemented as reversible technical foundations (see HANDOFF and the development log for commits). Component geometry, the drawn type/STR icons and the flyout treatment are **PROVISIONAL** and held in replaceable resources (`godot/themes/architecture_v2/ice_panel_layout.tres`, `VasTokens`) until the visual reference is agreed. No gameplay, rules or project-setting change.

## ARCH-V2-004 — Batch 2: cards, hand, targeting and choices (STARTED by the designer, 2026-11-26 16:09; implementation PROPOSED)

**Designer, 2026-11-26 16:09:** "Fine at this size. Start batch 2" (CRT action keys accepted at about 36 px).

**Built (PROPOSED for visual review):**
- **(a) C11 CardView: the HuCard card (CARD-HUCARD-001, VAS-ASSET-001 §3f).** Portrait 1 : 1.58, rounded corners, darker-white edge on the right and bottom, nine gold contacts along the bottom edge; type-coloured frame round the art window (EXPLOIT red, CLOAK violet, ICEPICK green, EXTRACTOR gold, VIRUS olive, HARDWARE steel; otherwise by card type), white BW cost medallion with a black ring top left, name and type line left-aligned (the left half of a fanned card identifies it), cream rules field (three lines; the full text is on hover). Drawn in the engine; a painted body can replace it later. States: playable, unplayable (dimmed; reason on hover), hover/focus (cyan edge), selected (thick cyan with glow). Card art: the existing illustrations in `godot/assets/concept/cards/` (the ten starter cards); the designer's folder holds 93 more for later imports.
- **(b) HOVER-001 for cards:** hovering or focusing a card opens the inspector with the card at 1.6× beside its name, type, full rules and cost (and why it can't be played now).
- **(c) C10 HandView:** the fan holds CardViews bound by instance UID; one click plays a card (one controller call).
- **(d) Targeting:** a targeted card (e.g. PROBE) lights every ICE panel with a cyan ring and shows a CHOOSE AN ICE plaque with ✕; clicking a panel plays the card on that ICE; clicking the card again, ✕ or Esc cancels.
- **(e) C15 ChoiceOverlay:** dims the console and shows a plaque with the choice's name, its existing wording (from the prototype overlays) and the candidates as cards: READY RIG (Skip), DISCARD, GARBAGE COLLECT, TAIL CALL, UNINSTALLER, FIELD KIT, CACHE, SCAN (selected cards cyan; Finish), CULL (strain buttons; Finish). card_break stays on the keys. Focus starts on the first card without popping the inspector.
- Engineering: `EncounterController` gains `request_skip_ready_rig`, `request_finish_scan`, `request_cull`; every intent is one Game call; `VisibleStateAdapter.card_model` is read-only. No rules changes.

**Status:** Batch 2 implementation PROPOSED; geometry, colours and the drawn card body await designer review.

## ARCH-V2-005 — Before Batch 3: coverage table, coverage test, header slots (designer, 2026-11-26 18:22; implementation PROPOSED)

**Designer, 2026-11-26 18:22:** "Yes build the coverage table, the test and these placeholders now. Before batch 3. I want CAPS slots on the ui as well start with 3. Protocols slots same. Now there is AMPLE room along the top. The turn indicator with runner and corp alternating icons can be 1/2 in width and the trace meter can be reduced to 1/2 size in width. CAps and protocol slots can easily be put there. give me the prompts and image for chatgpt and i'll get those built."

**Built (PROPOSED for visual review):**
- **(a) Coverage table** [`architecture-v2/ENCOUNTER_COVERAGE.md`](architecture-v2/ENCOUNTER_COVERAGE.md), generated from `godot/tests/arch_v2_coverage.json` by `tools/arch_v2_coverage_md.py`: 63 elements of the Build 12 encounter, each with its prototype source, its V2 node and a status (BUILT 35, PLACEHOLDER 1, BATCH3 15, BATCH4 5, OPEN 6, OUT 1). Gaps it surfaced: strikes and LOCKDOWN, CRED, virus counters on ICE, the CACHED icon, PARTING SHOT, NEXT DRAW, the log, PATIENT ZERO choice (Batch 3); Ghostware rail home, HOSTILE REVEAL, LAYER/EXTRACT, leave-Node control, NUL/REM note, KEY LEGEND (open).
- **(b) Test** `godot/tests/test_arch_v2_coverage.gd` (in CI): every BUILT/PLACEHOLDER row's node is on the V2 screen; every other row says what is next; the Markdown matches the JSON; the header parts sit inside the header bar without overlapping; the PROTOCOL slots follow `game.rack` through real plays; drawing never changes Game.
- **(c) Header:** turn indicator 252 → 126 px and TRACE meter 230 → 115 px (reference pixels); TRACE bar now 10 cells of 2 TRACE. In the freed space, left to right: **CAPS rack** (3 slots) and **PROTOCOLS rack** (3 slots), each with a group icon; names and rules on hover/focus. PROTOCOL slots are live (deployed PROTOCOLs, in order; more than three shows "+n" on the last slot, named on hover). CAP slots are empty placeholders: the CAPS inventory is not in the rules engine yet (UPL-001: 3 slots), and they fill from it when it is. Drawn placeholders until the ChatGPT parts land (VAS-ASSET-001 §6e).

*Interpretations to confirm:* CAPS left of PROTOCOLS; "+n" overflow when more than three PROTOCOLs are deployed (the rules don't cap the RACK); TRACE bar at 2 TRACE per cell. No gameplay or rules change.
- **(d) Art delivered (designer, 2026-11-26 18:49):** the seven §6e parts are in `godot/assets/architecture_v2/controls/` and `icons/` and wired. Two came back wider than asked (half plaque 3:1, slot rack 5.3:1); both are drawn as nine-slices so their ends keep their shape. To fit, the racks grew to 219 px each (CAPS at x 748, PROTOCOLS at 973) and each slot is about 37 × 41 px. *Interpretation to confirm:* that slot size is acceptable, or ChatGPT redoes `V2_SLOT_RACK` at 3:1 with a smaller icon socket.

## ARCH-V2-006 — Homes for the remaining encounter UI before Batch 3 (designer, 2026-11-26 19:12–19:20; implementation TO DO in Batch 3)

**Designer, 2026-11-26 19:12**, answering the open rows of the coverage table (ARCH-V2-005): "smaller slots are very fine" (closes ARCH-V2-005d), then the answers below. Follow-ups chosen 19:20.

- **(a) Brand mark:** "Panopticon the TERM can be removed and replaced with an all seeing eye like HAL 9000. Place that in the very left corner." The PANOPTICON plate is replaced by a round all-seeing eye in the top-left corner (own design; no film likeness). The freed width goes to the Ghostware reel.
- **(b) Ghostware reel:** "it should go in that top panel to the left of the CAPS … an iconized 'slot machine' type of roller where you would see one of the Ghostware visible, and then either click up or down on the arrows beside it to bring into view the next Ghostware. Same rollover/hover rules apply with full text and full icon image visible on rollover/hover." Header, left of the CAPS rack; one Ghostware visible; up/down arrows beside it roll to the next. ORIGIN first (as before).
- **(c) HOSTILE REVEAL:** "the trace will reveal it, the avatars will mask off and fluctuate between normal resolution and 16-bit effect when trace rises past 50% I would like to see a retro alarm lamp go from cool green to almost neon red … it can be subtle. We should use the EYE LOGO of the panopticon itself." No % plate: the eye from (a) is the alarm lamp, cool green at no reveal to near-neon red at full reveal, subtle. The reveal itself (art showing through, avatar mask-off and the resolution flicker) is presentation per ADP and MOOD-PIXEL-001. *Interpretation to confirm:* "past 50%" read as 50% hostile reveal (the reveal runs 20%–60% through Cracking, 100% at a strike or Mask off).
- **(d) LAYER and CRED:** "a place for # of encounter layers (for the node - between 1 and 3) … one icon that resembled a HAMBURGER MENU with between 1-3 of them lit up … a value for how much CRED is available for extraction in the layer and how much cred the player currently has … start [with a CRED icon] … THE Layer cred should be to the right of the player's CRED Value so that when the player extracts CRED from the corp we can display red marching ants moving LEFT towards the Rustler's CRED Value and then see it increase." Home (19:20): the **left end of the NEXT RESPONSE rail** (replacing the left vent grille): LAYER icon (three bars, the Node's layers drawn, the current one lit), then the Rustler's CRED (new CRED icon + value), then the layer's CRED reserve; on extraction red marching ants run left from the reserve to the Rustler's CRED, which then counts up. *Interpretation to confirm:* bars = the Node's layer count, the current layer lit brighter, cleared layers dim.
- **(e) Leave Node:** "a very corner case situation and should only appear on the menu of a CAP or card that would allow it." No permanent button on the encounter screen.
- **(f) NUL/REM:** "those should be voices / audio and a player that wants to see the text can rollover the speakers (just below the avatar on the left and just below the right ice's subroutine icons on the right) … i prefer to keep the UI clean." Two small speaker grilles; hovering one shows the current line's text. No ticker.
- **(g) KEY LEGEND:** "that can be a rollover on the top left panopticon title & level and node indicator." The legend opens on hover/focus of the top-left eye, together with the tier/level and Node.

- **(h) Strikes and LOCKDOWN (designer, 2026-11-26 19:21: "yes for strikes and lockdown. WE would need a text flyout for lockdown as in the typography examples from the weekend"):** three small lamps under the eye light as strikes land; at LOCKDOWN all three turn red with a lock mark. LOCKDOWN also gets an event flyout in the UI-TYPO-001 family (references `docs/visual/references/ui-typo-001/`, catalogue 04: the hot red/orange band of CORPORATION RESPONSE and DEADLOCK BREACHED, with a lock motif), within the UI-TYPO-001a limits (≤ 1.5 s, see-through, static under reduced motion). Wording proposed: **LOCKDOWN**.
- **(i) No log ticker (designer, 2026-11-26 19:21: "yes no log ticker. opening the log on hover or click of next response rail is elegant solution"):** the encounter log opens on hover or click (and keyboard focus) of the NEXT RESPONSE rail; there is no scrolling ticker.

Coverage table updated: no OPEN rows remain (`docs/architecture-v2/ENCOUNTER_COVERAGE.md`). New art: VAS-ASSET-001 §6f.

## ARCH-V2-006 — Batch 3 built (designer: "start batch 3", 2026-11-26 19:22; implementation PROPOSED for review)

Built on the V2 encounter screen, in five commits (see the development log). Every row of the coverage table that was BATCH3 is now BUILT (`docs/architecture-v2/ENCOUNTER_COVERAGE.md`: BUILT 55, PLACEHOLDER 1 (CAPS: no CAPS inventory in the engine), BATCH4 5, OUT 2). Captures: `docs/visual/fixtures/arch-v2-batch3/`. Tests: `godot/tests/test_arch_v2_batch3.gd` (in CI). No rules change.

- **Header (006a/b/c/g/h):** the eye in the top-left corner (drawn until `V2_EYE` lands) with its lens as the hostile-reveal lamp and three strike lamps (LOCKDOWN: all red with a lock); hover: corporation, tier, Node, layer, reveal, strikes and the KEY LEGEND. Ghostware reel left of CAPS. Header shifted left; negative space before the ad plate.
- **Rail (006d/i, PT11-UI 1):** ledger at the rail's left end (LAYER hamburger, CRED with a new CRED icon, layer CRED; red ants run left on extraction, then CRED counts up); log from the rail (hover: latest lines; click: full log; Esc closes); parting shot on the PULP meter and END TURN after a BREACH, rail without DEADLOCKs.
- **Events:** flyouts from the Game's events: TRACE STRIKE, MASK OFF, LOCKDOWN, DEADLOCK BREACHED, LETHAL, PARTING SHOT, RESERVE EXTRACTED (queued, max 3, ≤ 1.5 s each); a short red wash on strikes and lethal ICE; "−n BW" at the key of a paid break; virus strain chips on each ICE.
- **Cards:** click plays on release; drag to play (untargeted above the tray, targeted onto an ICE); CACHED corner icon (∞ or turns left); SHOW BOARD / BACK TO … on every choice (#15); deck (sorted by name), discard and burned viewers from the counters; NEXT DRAW on the deck hover.
- **NUL/REM and settings (006f):** two speaker grilles (below the left avatar, below the right ICE); NUL/REM picks a line per batch of events (Build 12's priority list) and speaks it; hover shows the text; click or M mutes (saved). Reduced motion and voice come from the app settings file.
- **C03 ResponseSequencer:** ported from Build 12: steps share 5 s, the response waits for CORP COUNTERMEASURE and strike/LOCKDOWN flyouts (max 3 s), one controller call per step, finish once, safe to cancel or leave mid-response; each step sounds its effect type (PLAY-002) and PULP shakes the console.

*Interpretations to confirm:* flyout wording TRACE STRIKE, MASK OFF, LETHAL, PARTING SHOT, RESERVE EXTRACTED (DEADLOCK BREACHED and LOCKDOWN follow the catalogue); the KEY LEGEND wording; the response waiting for flyouts; deck viewer sorted by name (keeps draw order hidden); the speakers' click-to-mute; reduced motion toggled only from the app settings. Open from the table: PATIENT ZERO choice (VECTOR) still has no V2 overlay.
- **(j) Batch 3 review (designer, 2026-11-26 20:35):** "for banner wording: Remove trace strike keep the rest with typographical rules … the rest is all good". No TRACE STRIKE banner (the first strike shows on the eye's lamps, with the red wash and NUL/REM). **APPROVED:** the banner wording MASK OFF, LOCKDOWN, DEADLOCK BREACHED, LETHAL, PARTING SHOT, RESERVE EXTRACTED, under the UI-TYPO-001 typography rules; and the other Batch 3 interpretations (KEY LEGEND wording, the response waiting for banners, the deck viewer sorted by name, click-to-mute on the grilles, reduced motion set from the app settings).
- **(k) Targeting arrow (designer, 2026-11-26 20:37: "instead of clicking an ice, make the user click and hold the card, and drag an arrow to ice like this example"):** a targeted card (e.g. PROBE) is aimed, not dragged: press and hold it and a curved arrow runs from the card to the pointer; the ICE light up and the one under the pointer is ringed; release over an ICE plays the card on it (one controller call); release elsewhere cancels; right-click or Esc cancels. **APPROVED (designer, 2026-11-26 20:45: "those 2 choices are good"):** a plain click on the card keeps the arrow up until the next click (on an ICE: play; elsewhere: cancel); keyboard play keeps the CHOOSE AN ICE plaque. Capture `docs/visual/fixtures/arch-v2-batch3/v2_29_targeting_arrow.jpg`.
- **(l) Installing programs and lit cards (designer, 2026-11-26 20:47: "I prefer the way you describe it. Also, for each rustler turn, cards that the player CAN play in that turn should be lit normally. When they cannot play a card any longer the card dims to indicate it cannot be played (for whatever reason. i.e. not enough BW)"):** a PROGRAM installs by dragging it onto the CRT: while it is dragged the CRT glows phosphor with a slot arrow above it, brighter when the pointer is over it; let go there to install; let go anywhere else and it returns to the hand. Clicking a PROGRAM still installs it (shortcut, as proposed). Cards the Rustler can play right now are lit normally; any card that can't be played now (not enough BW or RAM, wrong phase, during the Corporation Response...) dims, rechecked after every action; the reason is on hover.
- **(m) Eye, reel and grille art delivered; red pupil (designer, 2026-11-26 21:17: "with regard to the V2_EYE file, if there is not going to be a pulsing red dot in the center of the eye, please place one there"):** the three §6f parts are in the art folders and wired. The eye's pupil carries a red dot drawn by the game that always pulses slowly (faster as the hostile reveal grows; steady under reduced motion); the white iris is tinted green → red around it.

## ARCH-V2-007 — Batch 4: integration and corporation look (STARTED, designer 2026-11-26 21:25; implementation PROPOSED)

**Designer, 2026-11-26 21:25:** "Ok i have background images for each corporation. those should help with the corporation look. the are prefixed with BG in file name." Placement chosen 21:3x: **"Inside the ICE windows"**.

- **(a) Corporation rooms through the ICE windows:** the 22 `BG_` images imported to `godot/assets/concept/backgrounds/` (unchanged). On the V2 encounter the corporation's room replaces the seafoam field inside each ICE window's bezel, behind the avatar and keys, with a light seafoam wash and vignette for readability. The windows show **one continuous room** (each window shows the part of the image behind it). The HOSTILE room shows through with the hostile reveal (same composition, blended). Central Node: CENTRAL room; escape: ESCAPE room. Driven by `CorporationLook` (C06), so IRONWATCH and LUCIDA use the same screen. Crop (designer, 2026-11-26 21:41: "would rather see more floor"): the room is fitted to cover the windows and cropped toward its bottom (`IceLane.room_v_align` 0.85), so the floor shows. *Interpretation to confirm:* the wash (12%) and vignette strength. `BG_MAP_HALCYON` carries hand-drawn circles and arrows on its islands: keep or remove? Map and Node backgrounds are not wired yet (outside the encounter).
- **(b) The rest of the corporation look (built, PROPOSED for review):** `CorporationLook` now also gives the window enamel (Build 12's IRONWATCH navy / LUCIDA lilac through `console_tint`; HALCYON keeps seafoam; mostly behind the room now) and the header ad plate with its approved line (HALCYON only: IRONWATCH and LUCIDA show no plate until their art and approved copy exist). **PIXEL-TRACE-001** in the V2 windows: the room and the avatar drop to the TRACE step with Build 12's spike-and-settle transition; keys, plates, bubble and text stay sharp. **MOOD-PIXEL-001:** each avatar drops into 16-bit on a mood change and pulses 2 s / 2 s while lethal (Build 12's timings, shared code), masked to the avatar; off under reduced motion. **Music:** Build 12's ADP stems mixed by bleed, the strike chime, and the PLAY-002 effect sounds, at the volume and mute from the app settings.
- **(c) Graffiti, punch cards, low VITAE, PATIENT ZERO (designer, 2026-11-26: graffiti "Header gap before ad"; punch cards "Hover on the eye only"):** ADP graffiti stickers (approved lines, Build 12's band rules) sit in the header gap between PROTOCOLS and the ad plate. *Interpretation to confirm:* the gap holds **two** readable stickers, so it shows at most two (the newest two at band C, where Build 12 shows four); widening the gap would mean narrowing the ad plate. Punch cards: counted and drawn in the eye's hover; a newly earned card drops onto the eye for a moment. Low VITAE (a quarter or less): the VITAE meter pulses red (steady under reduced motion). PATIENT ZERO (VECTOR): the ICE windows light with a "PATIENT ZERO: CHOOSE AN ICE TO INFECT (1 ROT)" plaque (no cancel); clicking a window infects it, one controller call.
- **(d) The V2 encounter is the game's encounter (C05, built, PROPOSED for review):** `main.gd` shows ICE encounters on the V2 screen (`EncounterV2`, embedded mode) instead of Build 12's FriendlyEncounter. The app keeps the run flow: Rustler select, map, READY RIG before the encounter exists, DEEPER, reward, SAFEHOUSE, run end and THE CARBON stay the app's overlays (outside the encounter slice, C17). Inside an encounter the V2 screen handles choices, events, NUL/REM, music and the response; settings (reduced motion, voice, music) flow both ways. Build 12's encounter stays available for comparison: set `"legacy_encounter": true` in `user://redline_flags.json`. Tested end to end (`test_arch_v2_app.gd`: map → ICE Node on V2 → turns → BREACH → reward → map → next Node; run end). *Interpretation to confirm:* END RUN has no button on the encounter screen (F02: leaving only through a CAP/card menu); the app's other screens keep their Build 12 look until their own batch.
- **(e) Behaviour comparison for RELEASE-002c:** the rules engine and data (`godot/scripts/core`, `godot/data`) are byte-identical to `prototype-baseline` (21922ad; `git diff` empty). Rules suites match the baseline: `test_game.gd` 176/0 (also with SIM=1), `test_adp.gd` 17/0, `test_signal_carbon.gd` 672/0. New `test_arch_v2_parity.gd` (in CI): a deterministic bot plays every ICE Node of the slice map with six seeds through the whole V2 screen (card clicks, aiming, CRT drops, key clicks, choice overlay, END TURN with the ResponseSequencer) and, on twin games, through Build 12's direct calls: **30 encounters, 1,560 actions, identical after every action.** The comparison found and fixed one V2 bug: a Corporation Response with nothing left to fire never finished (the sequencer now finishes it at once, as Build 12 does). It also found a **rules-engine gap present in the baseline**: with CORE_LOOP on, ECHO, RIOT and VECTOR have empty reward pools, so `Game._roll_rewards` fails at a full clear. The core-loop build offers only the Generalist, so players can't reach it; it needs fixing before the other Rustlers return (not changed: rules code).
- **Status:** Batch 4 BUILT. RELEASE-002c entry conditions are met: the representative ICE encounter exists and is the game's encounter; its component tests and screenshot fixtures run in CI; its behaviour matches the `prototype-baseline` results. A playtest build is cut only when the designer asks (RELEASE-002).
- **(f) Designer decisions, 2026-11-26 22:12:** "the graffiti isn't even necessary. i would remove it for now" (graffiti off; code kept behind `SHOW_GRAFFITI`); "Rewards bug, yes" (**CORE-LOOP-REWARD-GAP fixed**: a Rustler pool with no cards in the build falls back to the SHARED pool, same rarity, then COMMON; rules test added to `test_game.gd`; parity test back to all four Rustlers); "yes prepare playtest 13" (RELEASE-002 step 1: `config/version` 0.13.0-playtest.13, guide and core-loop checklist updated).

## ARCH-V2-008a — READY RIG in the Ghostware slot (designer, 2026-11-27 06:16; TO DO for the next build)

Designer: "for the next build add ready rig to the ghostware slot on the encounter screen". The Ghostware reel (ARCH-V2-006b) already lists the Generalist's ORIGIN, READY RIG (RUSTLER-003), first, but shows only the initials "RR" because there is no reel art. The next build gives the slot READY RIG art and its rules text on hover. Presentation only: no rules change.

**Built (2026-11-27, Claude Code; PROPOSED for review):** the designer's 30 Ghostware icons (`PANOPTICON art/Ghostware Icons`) imported to `godot/assets/concept/ghostware/` at 256 × 256. The reel shows READY RIG's icon, with its rules text on hover; LOW PROFILE, REDLINER and PATIENT ZERO also get their icons, and so does any other Ghostware the run picks up.

## RUSTLER-SELECT-001 — Rustler portrait on the select screen (designer, 2026-11-27 06:33–06:34; implementation PROPOSED for review)

Designer: "add the generalist rustler image to the rustler select screen for the user to click on when selecting a rustler" and "i would use the image in place of the name. when the player rolls over the image they can see the text of what the generalist stats are, a quote, etc." Built: the portrait (`PANOPTICON art/Rustler Select/RUSTLER_GENERALIST.png`, imported at 561 × 701) fills the Generalist's select button, without the name. Hover or keyboard focus shows the name, difficulty, quote, style and ORIGIN on an opaque panel over the card (no picture behind the text; ADP-R1). Any Rustler with a `RUSTLER_<ID>.png` file gets the same treatment; the others keep the text card.

## ARCH-V2-008b — END RUN on the encounter screen (designer, 2026-11-27 06:39; implementation PROPOSED for review)

Designer: "add a general end the run button to the encounter screen. preferably below the end turn button. Something that the player will rarely use but should have. it existed in build 12." Built: a small, low-contrast-frame (text at least 4.5:1) END RUN plate centred under END TURN. It opens Build 12's existing confirmation (RUN-001; `Game.abandon()`), and is unavailable during the Corporation Response. The app's dialog layer now draws above the V2 screen, so nothing from the encounter shows through or takes clicks while a dialog is open.

## CAPS-TEST-001 — CAPS in the game: common CAPS and a CAPTCHA bonus (designer, 2026-11-27 06:39; implementation PROPOSED for review)

Designer: "Next we need to test caps in the game. in this next BUild, i want you to add a random common CAPS to the reward in addition to a card, in the CAPCHA node." This is a designer-directed rules addition for testing. It uses the approved CAPS rules (UPL-001: 3 slots, 0 BW, your turn only, single use; UPL-002: the five common CAPS and their effects) and adds a **test-only acquisition route**: a full clear of the CAPTCHA Node adds one random common CAP alongside the usual card reward. The other approved routes (Uplink purchase, the Node-completion CAP choice, the 20% BREACH drop) and the uncommon and rare CAPS are not built yet.

**Interpretations to confirm:** (1) if all 3 slots are full, no CAP is given (UPL-001 says you must discard one to take a new one; there is no discard prompt yet, and the slice has one CAPTCHA Node, so it can't happen in play); (2) CRACKER's −4 STR uses the same STR floor as card STR reductions; (3) in the rack, CRACKER is aimed with the arrow like a targeted card, and the others inject on click.



## SEQUENCE-002 — SEQUENCED revision (designer approved 2026-11-27)
SEQUENCED permits breaks in any order. Each successful out-of-sequence break generates TRACE once if an earlier visible, active subroutine on the same ICE remains unbroken, regardless of how many are skipped. Previously broken, concealed and inactive subroutines do not count. This supersedes mandatory ordered breaking and retires standalone TRIPWIRE. TRACE magnitude remains open for balancing. Design SEQUENCED ICE with low-urgency earlier effects (e.g. INSERT SPAM or DISCARD) and a compelling later target (e.g. PULP 6 or AMEND on supporting ICE, increasing the right-hand ICE's PULP during the response). Examples are design patterns, not approved new ICE profiles. Preview the penalty before committing. Priority 2 representative encounter refinement; implementation and tests pending, no engine changes in this decision.


## TOLL-RETIRE-001 — TOLL retired (designer approved 2026-11-27)
Retire TOLL (additional BW cost for breaking non-DEADLOCK subroutines) from active design, HALCYON expansion and mechanical coverage requirements. It adds resource pressure without sufficient new strategic decisions to justify cognitive load. Preserve historical records; reconsider only with explicit designer approval. Supersedes earlier active TOLL specifications. Priority 2: reconcile rule references and legacy engine support in a controlled implementation batch; no engine changes authorized by this documentation update. Design review principle: mechanical complexity should be earned through strategic depth.


## MINIBOSS-001 — Unique signature abilities / FORTIFY (designer direction 2026-11-27)
Each corporation has one mini-boss encounter, with a signature ability unique to that mini-boss. Reserve FORTIFY (formerly passive HARDENING) for one specific mini-boss as one of three candidate signature abilities; no standard ICE assignment. Existing HARDEN remains a distinct breakable subroutine. FORTIFY candidate retains +1 STR after each Corporation Countermeasure, maximum +3 bonus provisionally; final balance, corporation and ICE identity remain undecided. Signature abilities must justify complexity through strategic depth, agency, synergy, anticipation and cognitive-load value. No production implementation or roster changes in this documentation update.


## MINIBOSS-003 — THE GRID: PROFILE + FORTIFY (designer approved 2026-11-27)
IRONWATCH's mini-boss THE GRID retains its approved PROFILE ability and gains FORTIFY (formerly passive HARDENING), exclusive to THE GRID. FORTIFY grants +1 STR after each Corporation Countermeasure, maximum +3 bonus as a working balance value. PROFILE remains unchanged. Both are unique signature abilities, not breakable or disableable subroutines. Each corporate mini-boss must have at least one unique signature ability; multiple complementary abilities are permitted where strategically justified. Supersedes the single-ability implication of earlier mini-boss records and resolves FORTIFY's assignment. Preserve other mini-boss designs. Implementation and combined balance testing pending; no engine changes in this documentation update.


## WATCHER-EXP-001 — WATCHER removed from standard ICE (designer approved 2026-11-27)
Remove WATCHER from the standard ICE ability pool and HALCYON expansion/representative encounter mechanical coverage. Preserve as an experimental concept: each CLOAK card played generates 1 TRACE. Potential exceptional applications: mini-boss, specialized supporting ICE with meaningful counterplay, or discoverable/circumventable node security condition. None is approved for deployment. Evaluate strategic depth, agency, synergy, anticipation and cognitive load; test defensive deck viability, advance warning and viable counterplay. Design principle: abilities directly penalizing fundamental Rustler actions should be exceptional encounter conditions, not routine obstacles. Detailed experimental ownership: docs/PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md. Supersedes standard WATCHER specifications; preserve historical records. No engine changes or production implementation authorized by this documentation update.


## BOOTING-RETIRE-001 — BOOTING retired (designer approved 2026-11-27)
Retire BOOTING, the passive ability locking DEADLOCK until Rustler turn three, from active design and representative encounter coverage. Mandatory waiting undermines efficient play and agency. Preserve historical records. Designer expressed interest in exploring optional protection of DEADLOCK by another subroutine or ICE, without making its removal mandatory; no replacement mechanic approved. Legacy rule/code reconciliation pending controlled implementation; no engine changes in this documentation update.


## GUARD-001 — Optional DEADLOCK protection (designer approved direction 2026-11-27)
GUARD is a supporting ICE subroutine protecting a linked DEADLOCK on another ICE. Breaking the protected DEADLOCK while GUARD remains unbroken triggers a consequence; breaking GUARD first avoids it. GUARD must never prohibit the DEADLOCK break or become a mandatory breach prerequisite. Exact consequence (candidate PULP or TRACE), magnitude, linking rules, timing and interaction with simultaneous breaks remain open for specification and balance. Supporting ICE need not have their own DEADLOCK. Include GUARD in Priority 2 HALCYON supporting ICE design and representative encounter coverage planning. INTERLOCK and ALARM LINK were unapproved alternatives in the BOOTING review and are not selected for development. No engine changes or final numerical rules authorized by this record.

**Designer follow-up (2026-11-27 07:43, CAPS-TEST-001a):** "The player should get a prompt to discard one. But yes, we don't need it in this build." When a CAP is gained with all slots full, the player is prompted to discard one (UPL-001). Not in the next build; until then a full rack takes no CAP.

**Designer follow-up (2026-11-27 07:44, CAPS-TEST-001b):** CRACKER's hover hint reads "Drag onto an ICE to inject (0 BW, your turn)." CRACKER's behaviour is confirmed: ICE STR never drops below 0, and never below an ICE's minimum STR where it has one. This settles interpretation (2) above.



## REBOOT-SPAM-002 — Breakable reactive subroutine (designer approved 2026-11-27)
Convert REBOOT SPAM from inherent ICE ability to breakable reactive subroutine. Preserve existing effect: each natural or explicitly forced REBOOT inserts one SPAM into the Rustler draw pile while the subroutine is active and unbroken. Breaking it prevents subsequent triggers while broken; it does not independently resolve during ordinary Corporation Countermeasure. No mandatory break prerequisite. Reconcile FREE TRIAL's existing inherent ability with the new subroutine in HALCYON coverage planning; exact TUMBLER slot/pool placement, visibility and rotation interactions require specification before implementation. Preserve historical records. Priority 2; implementation and regression tests pending, no engine changes in this documentation update. Rationale: preserve deck-cycling pressure while giving Rustler direct counterplay.


## REBOOT-SPAM-002a — ICE affinity and activation clarification (designer approved 2026-11-27)
Finalize REBOOT-SPAM-002: VOID is the preferred but not exclusive ICE type; FORTRESS and TUMBLER remain eligible. Each natural or forced REBOOT inserts one SPAM into the draw pile per eligible REBOOT SPAM subroutine. Existing universal subroutine eligibility applies: revealed, active and unbroken; no concealed or inactive triggers, no independent Corporation Countermeasure execution. Apply existing TUMBLER rotation rules without exceptions. Reconcile FREE TRIAL's legacy inherent ability during implementation; exact roster placement and pool composition remain open. Include in Priority 2 mechanical coverage and regression planning. Documentation approval only; engine implementation pending.


## REBOOT-FORGET-001 — LUCIDA-exclusive ability (designer approved 2026-11-27)
Retain REBOOT FORGET as an inherent reactive ICE ability exclusive to LUCIDA: existing REBOOT trigger and FORGET 1 effect retained. Do not convert to a breakable reactive subroutine at this stage. Defer implementation/reconciliation and balance evaluation to LUCIDA development; explicitly exclude from current HALCYON representative encounter milestone. Existing RECURRING DREAM definition and legacy references to be reconciled during appropriate implementation work. No engine changes authorized by this record.


## CHAIN-REP-001 — Representative encounter scope clarification (designer approved 2026-11-27)
Priority 2 representative encounter milestone must fully flesh out, implement and playtest Rustler CHAIN mechanics and their UI. Designer reports current CHAIN operation, activation and effects are effectively invisible. Audit approved rules, current engine and card coverage; identify gaps, specify and validate card sequencing, eligibility, bonuses and feedback; coordinate with UI-TYPO-001/a, M06, CAS-001 and VAS-001. Proposed UI acceptance states: potential, progression where applicable, ready, activated, resolved; icons/hover/focus, pre-action clarity, distinctive motion/audio and reduced-effects support. Exact UI and any new mechanical rules require designer approval; do not invent new CHAIN rules. Include meaningful CHAIN combinations in HALCYON representative encounter and multi-encounter coverage. Separately retain CHAIN PULP (existing 1 PULP per CHAIN bonus) as an IRONWATCH-preferred reactive ability for a future IRONWATCH representative encounter milestone; exclude CHAIN PULP development from current HALCYON milestone, without excluding Rustler CHAIN itself. Existing PATTERN ANALYSIS assignment requires later reconciliation. No engine changes in this documentation update. Preserve current priority ordering and coordinate with Claude Code's ongoing GUARD work.


## CHAIN-002 — Foundational CHAIN revision (designer approved 2026-11-27)
Canonical working specification: [PANOPTICON CHAIN Mechanics](PANOPTICON_CHAIN_MECHANICS.md). Supersedes DSY-011's two-card activation threshold: minimum three cards; third valid card instantiates a CHAIN instance and receives inherent −1 BW play-cost reduction before commitment, plus applicable card-specific bonus. Longer chains permitted; exact eligibility, extension discounts, termination, repeat instances, cost floor/precedence and card balance remain open. CHAIN-REP-001 remains Priority 2; coordinate CHAIN visibility and CHAIN ACTIVATED audiovisual feedback with UI-TYPO-001/a and M06. Existing engine and cards still reflect historical rules until implementation; no production change authorized by this documentation commit. CHAIN PULP remains deferred to IRONWATCH. See canonical specification for examples, audit, questions and acceptance plan.


## CHAIN-002a — Multiple instances per turn (designer approved 2026-11-27)
Multiple independent CHAIN instances may be instantiated within a single Rustler turn, with no once-per-turn activation restriction. Each valid new instance receives its own inherent −1 BW instantiation cost reduction and applicable card-specific bonus. This resolves the repeat-instance eligibility question in CHAIN-002; sequence overlap, reuse of links, termination, extension discounts and any card-specific trigger caps remain unresolved or governed by their existing rules. Illustrative example: two distinct valid three-card sequences in one turn each receive a discount on their third card, subject to affordability and approved eligibility. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-002b — Distinct non-overlapping instances (designer approved 2026-11-27)
CHAIN instances are distinct and cannot overlap or reuse previously played cards as links. A card-play event assigned to one CHAIN instance cannot count toward another; a new instance requires a fresh sequence. This resolves the overlap/reuse question in CHAIN-002 and CHAIN-002a. Example: plays A,B,C instantiate one CHAIN; B,C,D cannot instantiate another. After the first instance ends, three fresh eligible plays can instantiate another in the same turn. Exact termination, extension eligibility and discounts remain open; no new rules about replaying a physical card in a separate play event are established here. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-002c — Turn extension and deck manipulation (designer approved 2026-11-27)
CHAIN's distinctive foundational design identity is momentum: extend the Rustler's turn and expand tactical options through card draw, draw/discard pile manipulation and resource efficiency. Successful sequencing should create opportunities beyond those available at turn start, potentially sustaining the current instance or enabling another distinct instance. This is an approved design principle, not a universal additional payout or final card specification. Preserve the inherent −1 BW instantiation cost reduction separately.
Experimental specialized rewards (designer examples, not approved individual effects): draw additional cards; inspect/reorder/select upcoming cards; recover a discard or place a selected discarded card atop the draw pile; play the top draw-pile card for free; generate extra BW in addition to the instantiation discount. Explore combinations and archetype differentiation. STR/SHIELD/TRACE bonuses remain possible but should not define CHAIN's identity alone.
UI: communicate newly available options, actual draw/recovery/free-play/BW outcomes and their causal relationship to CHAIN; integrate with CHAIN ACTIVATED and localized resolution feedback. Maintain player agency and hidden-information boundaries. Open questions: free-play eligibility/targeting/cancellation, pile selection and visibility, whether generated plays count as fresh links, recursion and loop safeguards, reward magnitude/frequency and balance. No arbitrary cap or automatic effect approved. Acceptance: deliberate sequencing visibly expands actionable choices and can extend a turn without dominant or infinite loops; test against baseline BW3/DRAW6 and multi-encounter fixtures. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-002d — Experiential acceptance (designer approved 2026-11-27)
Design mantra: **Extend the turn. Expand the options. Reward ingenuity.** CHAIN creates confidence, momentum and a sense of mastery, as if the Rustler discovered a new level within a level. Contrast with surveillance-induced anxiety and restriction. Experiential acceptance criterion: the player should not merely understand that they executed a clever combination; they should feel clever for having discovered it. Reward discovery through typography, motion, sound and visible card changes, not solely numerical effects or a flyout. Anticipation, activation and momentum are proposed feedback phases; eligible card indicators, effective cost changes, localized payoff and newly available options should be legible. Specific animation, sound, card treatments and timing remain experimental; coordinate UI-TYPO-001/a, M06 and CHAIN-REP-001. Playtest whether players independently recognize opportunities, perceive the payoff and report confidence/momentum/mastery without obscuring tactical information; reduced effects must preserve information. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-003 — Experimental catalogue and first playtest candidates (2026-11-27)
See [canonical CHAIN specification](PANOPTICON_CHAIN_MECHANICS.md) for all 15 experimental combinations and proposed TAG/TYPE/ACTION/COST grammar. First experimental cohort: OVERCLOCK, SLIPSTREAM, RELAY, BOOTSTRAP, HANDSHAKE, DAISY CHAIN (TAG/TYPE only; free execution requires additional rule review). Priority 2E / CHAIN-REP-001; coordinate M06 and UI-TYPO-001/a. Designer authorized recording and candidate selection, not final card balance or production implementation. Resolve grammar, extension/termination and free-play safety before implementation; later ACTION/COST/mixed signatures retained for exploration. No engine changes.


## CHAIN-003a — Experimental playtest development sequence (designer approved 2026-11-27)
Proceed with the CHAIN-003 six-card experimental programme under Priority 2E / CHAIN-REP-001: (1) OVERCLOCK foundational activation and free draw, (2) SLIPSTREAM and BOOTSTRAP BW generation, (3) RELAY and HANDSHAKE pile manipulation, (4) DAISY CHAIN free execution after legality/recursion review, (5) integrated six-card interactions and multiple distinct instances. Finalize baseline activation, termination and extension rules with designer before implementation. First deliverable: OVERCLOCK mechanically, visually and audibly realized, coordinated with CAS-001 and UI-TYPO-001/a/M06. TAG/TYPE first, ACTION/COST/mixed deferred. Experimental card values and signatures remain subject to playtest; no production implementation in this commit. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md.


## CHAIN-004 — Consecutive card-play eligibility (designer approved 2026-11-27)
Only consecutive card plays determine CHAIN eligibility. Non-card encounter actions leave candidate and active CHAIN state unaffected: Icepick activation/boost, PROBE, CAP activation, inspection and cancelled plays do not insert links or interrupt the sequence. Successful Program installation and Protocol deployment count as card plays, consistent with existing baseline. Example: CLOAK card → PROBE → EXPLOIT card → Icepick activation → OVERCLOCK is consecutive in card-play history and eligible if its proposed signature is approved and satisfied. Existing no-overlap/no-reuse rule remains. Exact catalyst signature grammar, extension eligibility and discounts, incompatible-card termination/new candidate handling, turn/encounter boundary rules remain for explicit review. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-005 — Termination rules (designer approved 2026-11-27)
1. Playing a card that cannot extend an active CHAIN terminates that instance.
2. That card can immediately become the first link of a new CHAIN, without reusing any prior instance links.
3. Ending the Rustler turn or leaving/completing the encounter clears all candidate and active CHAIN state.
4. Termination never reverses previously earned CHAIN bonuses (ordinary effect durations still apply).
Non-card encounter actions remain neutral per CHAIN-004, except explicit turn/encounter boundaries. Termination is automatic; no separate termination action required. These approved rules supersede earlier open termination questions. Extension eligibility, extension discounts and exact catalyst signature grammar remain open. Acceptance: incompatible successful play ends active instance and seeds new candidate; no overlap; turn/encounter boundary clears state; prior rewards retained; non-card actions preserve state. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md. No engine changes.


## CHAIN-006 — Persistent cumulative reward direction (designer endorsed 2026-11-27)
Preferred design direction: sustaining an instantiated CHAIN produces persistent cumulative rewards, encouraging the Rustler to discover an opportunity and rethink their intended turn strategy. Preserve escalating rewards explicitly for experimentation. Compare immediate fixed, banked fixed, immediate escalating and banked escalating delivery. Illustrative per-extension reward schedules: fixed 1,1,1 versus escalating 1,2,3; at six links totals 3 versus 6, assuming rewards begin at link four. Explore draw, BW, pile manipulation and tactical effects. Banked rewards require explicit settlement timing at incompatible play, turn end and encounter completion; cannot retroactively fund the terminating card without a separate rule. Test runaway draw/BW loops, player agency, opportunity cost, feedback and strategic redirection. Exact continuation eligibility, reward amounts, trigger on third link versus fourth, extension discount, settlement ordering and limits remain unresolved. No production mechanics or card values approved by this direction. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md.


## CHAIN-007 / CHAIN-008 — Balance constraints, extension economics and playtest roadmap (designer approved 2026-11-27)
CHAIN-007: Exceptional, not routine. CHAIN complements normal encounter play; powerful extended instances must be earned through sequencing, availability, BW and preparation. Non-CHAIN decks remain competitive. Evaluate rewards against actual ICE threat; test escalating rewards and recursive/self-sustaining draw/BW/recovery loops. No universal length cap unless evidence warrants reconsideration. Track activation frequency, extension length, reward magnitude/efficiency, sustainability, opportunity cost, strategic redirection, encounter relevance and experiential mastery. Numerical thresholds remain experimental.
CHAIN-008: Third card receives inherent −1 BW instantiation discount. Each subsequent eligible card receives the persistent effect defined by the instantiating card, but no automatic BW discount. Explicit card-specific cost effects remain possible. Persistent extension rewards start at link four; separate activation bonuses remain possible. Exact continuation eligibility and activation grammar, cost precedence/zero floor, reward amounts and banked settlement remain open for designer review. Existing CHAIN-004/005 neutrality and termination and no-overlap rules apply.
Approved development roadmap under Priority 2E / CHAIN-REP-001: (1) balance principles; (2) finalize ordered TAG/TYPE activation grammar and cost handling; (3) finalize continuation grammar; (4) concrete card economics using existing cards where possible, actual BW/DRAW, ICE STR/subroutines and incoming damage; (5) implement OVERCLOCK first after rule approval; (6) parallel audiovisual feedback with UI-TYPO-001/a and M06; (7) controlled expansion into BW, pile manipulation, banked and escalating rewards; (8) integrated balance/experience testing across single and multi-encounter nodes. Required scenarios: no CHAIN, three-link, five-link, exceptional eight-link, two independent instances; verify feasibility rather than assume all lengths attainable. Designer/ChatGPT own design and acceptance; Claude Code owns engine/tests/fixtures. No production implementation in this documentation commit; do not implement unresolved rules by assumption. Canonical specification: docs/PANOPTICON_CHAIN_MECHANICS.md.


## CHAIN-009 — Extension precedence for CHAIN-capable cards (designer approved 2026-11-27)
When a CHAIN-capable card is successfully played during an active CHAIN and satisfies that instance's continuation requirements, it extends the existing instance as an ordinary link. Resolve its normal base effect and the active instance's persistent reward; do not instantiate its own CHAIN, grant its own activation bonus or inherent third-link BW discount, replace the active instance, or stack persistent effects. The original catalyst retains ownership of continuation and rewards. If ineligible, apply CHAIN-005 termination and seed a fresh candidate with that play; no prior links may be reused. Exact continuation predicates remain open. Test eligible and ineligible catalyst plays, base effect resolution, no duplicate rewards/discounts, and fresh independent activation. Designer also requested at least three interacting CHAIN-capable cards for the economics playtest; OVERCLOCK, SLIPSTREAM and RELAY are proposed candidates, with specific effects and signatures still experimental. No engine changes.


## CHAIN-010 — Governing design principle (designer approved 2026-11-27)
**Easy to understand. Difficult to assemble. Rewarding to sustain.**
CHAIN rarity should arise from strategic sequencing, card availability, preparation and resource constraints, not opaque rules. Evaluate activation and continuation signatures, card design and UI feedback against this principle, alongside CHAIN-007 and the established momentum/mastery intent. This approval does not finalize any proposed signatures or card values. No engine changes.


## CHAIN-PARK-001 — Designer decision: park explicit CHAIN mechanic (2026-11-27)
Effective immediately, the proposed standalone CHAIN mechanic (CHAIN-002 through CHAIN-010, CHAIN-REP-001 and associated Priority 2E implementation/playtest roadmap) is PARKED / experimental, not an active production requirement or representative encounter acceptance gate. Preserve the complete historical exploration in docs/PANOPTICON_CHAIN_MECHANICS.md as an experimental reference indexed by docs/PANOPTICON_DESIGN_EXPERIMENTATION_BIBLE.md; do not delete it or treat prior approvals as current implementation authorization. Designer prefers elegant card-local sequencing and emergent synergy, citing Slay the Spire's per-card Block reward as inspiration. Explore existing Protocols as the natural vehicle for persistent conditional/per-card effects; use ordinary card effects for sequencing, draw, BW, pile manipulation and accumulated-action rewards. Preserve momentum, mastery, exceptional rather than routine combinations, resource-loop safeguards and clear audiovisual feedback without a separate CHAIN grammar, catalyst, link tracking or dedicated CHAIN UI requirement. Examples are exploratory, not approved new cards. Representative ICE encounter remains priority; remove standalone CHAIN work from active scope, retain general card synergy as a design exploration. Existing legacy DSY-011 CHAIN code/cards require Claude Code inventory and designer-approved retirement/reconciliation plan before production changes; no engine edits or issue closures in this decision. Future revival requires explicit designer approval.


## PROTOCOL-DURATION-001 — Designer-approved lifecycle distinction (2026-11-27)
Deployed PROTOCOLS last the current encounter only; installed PROGRAMS persist across encounters within the current node, subject to existing removal rules. This supersedes earlier node-duration assumptions for Protocols, including SYNERGY-PLAYTEST-001 proposals. Validate encounter completion/transition cleanup, Protocol rack reset and cessation of expired triggers, Program/RAM persistence across two- and three-encounter nodes, and node-exit cleanup. Exact destination of expired Protocol cards and cleanup ordering relative to breach/reward triggers require review against existing lifecycle rules before implementation. Claude Code to audit existing engine, tests, UI and documentation for affected assumptions and include reconciliation in the representative encounter plan. No production code changes authorized by this documentation batch. Other proposed card costs and conventions remain pending review.


## PROTOCOL-DURATION-001a — Expiry destination (designer approved 2026-11-27)
At encounter completion, deployed Protocols expire and return to the discard pile, not BURNED. They remain part of the compiled deck and may be drawn and redeployed through normal card circulation. Installed Programs persist for the node. At the beginning of the next node the Rustler draws a new hand from their compiled deck. This resolves the expiry destination question in PROTOCOL-DURATION-001; exact cleanup ordering relative to breach/reward triggers remains subject to lifecycle review. Test discard destination, no duplicate/lost cards, cessation of expired triggers, Program persistence, and next-node hand initialization. Documentation only; no engine changes.


## PROTOCOL-DURATION-001b — Encounter cleanup timing (designer approved 2026-11-27)
Protocols remain active through final DEADLOCK action and qualifying triggers, BREACH, remaining permitted Runner actions, END TURN and PARTING SHOT, including all associated triggered effects. After resolution and survival confirmation, expire deployed Protocols to discard exactly once, before encounter progression or node completion rewards. Fatal PARTING SHOT grants no successful completion rewards. Installed Programs and RAM allocation persist across encounters in the node. Apply cleanup consistently on normal progression, forced LOCKDOWN progression and early exit; next node draws a new hand from compiled deck. Existing game.gd go_deeper() retains Protocols between layers, a confirmed discrepancy requiring reconciliation. Claude Code to validate trigger ordering, pending choices, fatal response, card conservation, rack reset, Program persistence and next-node initialization with deterministic multi-encounter tests. Existing BREACH-001 parting-shot behavior remains intact. Documentation only; no engine changes or authorization to implement the ten candidate cards before specification review.


## SYNERGY-PLAYTEST-002 — Approved ten-card playtest catalogue (2026-11-27)
Designer approves all ten SYNERGY-PLAYTEST-001 candidates for playtest, with REACTIVE ARMOUR reduced to 1 BW; remaining proposed costs unchanged. No CRED deployment costs. Values are playtest baseline, not final balance.
| Card | Type | BW | Effect |
|---|---|---:|---|
| REACTIVE ARMOUR | PROTOCOL | 1 | Whenever you play a card, gain 1 SHIELD. |
| COUNTERINTELLIGENCE | PROTOCOL | 1 | Whenever you play a CLOAK, reduce TRACE by 1. |
| OVERCLOCK | PROTOCOL | 2 | Upon playing your third card each turn, draw 2 cards. |
| FEEDBACK LOOP | PROTOCOL | 1 | Whenever you ZERO an ICE, gain 1 BW. |
| SALVAGE | PROTOCOL | 2 | First DEADLOCK broken each turn: return a selected discarded card to hand. |
| ADAPTIVE DEFENCE | PROTOCOL | 1 | Whenever you install a PROGRAM, gain 3 SHIELD. |
| FOLLOW THROUGH | SCRIPT | 1 | Target ICE -2 STR, additional -2 if previous card played was EXPLOIT. |
| ESCALATION | SCRIPT | 1 | Target ICE -1 STR per EXPLOIT played this turn including itself. |
| AFTERBURN | SCRIPT | 0 | Gain 4 SHIELD if at least three other cards played this turn. |
| REPRISE | SCRIPT | 2 | Repeat effect of previous SCRIPT played this turn. |
Protocol lifecycle PROTOCOL-DURATION-001/a/b mandatory. Successful card plays count, not Icepick or CAP activations; no Protocol self-trigger on deployment; independent copies, no additional trigger cap initially except printed limits. REPRISE repeats effect, not card-play event, cannot repeat itself; Claude Code must audit targeting, recursion, pending choices and legality, flag unresolved semantics rather than silently inventing rules. STR reductions encounter duration. No standalone CHAIN mechanic.
All ten must be obtainable through normal node completion card rewards in the representative playtest (audit CORE_POOL/reward eligibility and rarity configuration). Designer also proposes UPLINK node to ensure specific cards are accessible for testing; recommended test-only fixed inventory of all ten, affordable CRED purchase prices, placement before subsequent combat, exact prices/placement and existing UPLINK architecture audit pending. Do not treat temporary inventory/prices as final economy. Preserve organic reward acquisition alongside deterministic fixtures and targeted purchase access. Include two-/three-encounter nodes, card display/hover, rack, trigger feedback, acquisition, deck persistence, lifecycle, loop prevention and regression tests. Priority 2E Card Synergy and Protocol Development; coordinate with representative encounter and typography/motion. Claude Code owns implementation and validation; this commit approves playtest content and reward inclusion, records UPLINK proposal for implementation planning, does not itself modify engine or authorize unrelated map expansion.


## SYNERGY-PLAYTEST-002a — OVERCLOCK revision (2026-11-27)
Designer adds +1 BW to OVERCLOCK's approved effect: upon playing your third card each turn, draw 2 cards and gain 1 BW. Retain 2 BW deployment cost, encounter duration, once per turn per deployed copy, and all other SYNERGY-PLAYTEST-002 conventions. Supersedes the draw-only effect. Include immediate BW availability, trigger frequency and resource-loop tests. Documentation only; no engine changes.


## EFFECT-HIERARCHY-001 — Strategic roles and effect lifetimes (designer approved 2026-11-27)
Ghostware defines how the Rustler operates. Programs establish what the Rustler can do. Protocols determine how the Rustler approaches an encounter. Scripts execute individual actions.

| Category | Lifetime | Strategic role |
|---|---|---|
| GHOSTWARE | Entire run | Strategic identity and persistent build specialization |
| PROGRAM | Current node | Installed infrastructure and sustained operational capabilities |
| PROTOCOL | Current encounter | Tactical specialization and persistent conditional effects |
| SCRIPT | Immediate execution | Individual actions and tactical interventions; resulting effects follow their specified durations |

Protocols are encounter-duration analogues of Ghostware, but occupy deck space, require drawing and BW deployment, and must be redeployed in subsequent encounters. Ghostware does not require these steps. Protocols expire to discard after PARTING SHOT and associated effects resolve, before progression or rewards (PROTOCOL-DURATION-001/a/b). Programs persist across encounters within the node. Use the Ghostware catalogue as inspiration for Protocol design, balancing shorter duration, deployment opportunity cost and synergy; avoid introducing unnecessary mechanics. This is a design principle, not authorization to duplicate every Ghostware effect or change existing card rules.

## PHIL-SURV-001 — Three dimensions of surveillance (designer approved 2026-11-27)

| Dimension | Knowledge | Purpose |
|---|---|---|
| TRACE | Operational intelligence: the corporation's understanding of the Rustler's whereabouts and activities | Locate and deploy effective countermeasures |
| Identity Verification | Commercial intelligence: identity, needs and disclosed information | Personalize offers and monetize knowledge |
| NUL/REM | Behavioural intelligence: patterns, preferences and likely choices | Anticipate and influence decisions |

These dimensions are distinct, not a shared meter. Information exchange is a candidate mechanic, not automatic. Operational invisibility does not necessarily constitute freedom. Preserve psychological invisibility and player agency.

## PHIL-CONSENT-001 — The Economics of Consent (designer approved 2026-11-27)
Privacy has economic value; surrendering it can yield genuine immediate advantages and longer-term vulnerability. Consent is incentivized rather than compelled. Accumulated knowledge creates asymmetry of power; personalization may become control. Preserving anonymity must remain a viable strategic choice. Identity Verification is an approved Uplink design direction (UPL-IDENTITY-001), not a morality mechanic or mandatory progression. Specific mechanics remain experimental.

## TRACE-DEF-001 — TRACE definition (designer approved 2026-11-27)
TRACE represents the extent of a corporation's actionable knowledge of the Rustler's whereabouts and activities. As TRACE increases, the corporation becomes increasingly capable of locating the Rustler and determining and deploying effective countermeasures. TRACE is not merely an alarm meter. Existing numerical thresholds, strikes, reset and countermeasure rules remain unchanged. Commercial identity disclosure and NUL/REM behavioural intelligence are distinct; no automatic TRACE linkage is authorized.

## UPL-IDENTITY-001 — Identity Verification (designer approved 2026-11-27)
Uplinks may offer voluntary Identity Verification: disclose information in exchange for genuine commercial advantages, with anonymous transactions remaining viable. This is an approved market design direction under PHIL-CONSENT-001. Candidate benefits include preferential pricing, exclusive inventory, restricted services, loyalty incentives and node information; candidate risks include targeted pricing, dependency and information sharing. Exact disclosures, prices, persistence, consequences and implementation remain unapproved. No mandatory verification, real-world data collection or automatic TRACE increase. The proposed bounded ±5% market variance is a separate pricing experiment, not a finalized formula.

## ECON-TRACE-001 / ECON-MARKET-001 — Three independent Uplink pricing layers (designer approved 2026-11-27)

1. Market variability: independent random variation within ±5% of base price, representing changing supply, demand and black-market conditions. Prices remain stable during a visit; reopening the interface must not reroll them. Seeded reproducibility is the proposed implementation approach.
2. TRACE risk premium: 0–10 = 0%; 11–20 = +2% to +3% linearly; 21–40 = +4% to +5% linearly. For T in 11–20 use 2+(T−11)/9 percent; for T in 21–40 use 4+(T−21)/19 percent. Integer TRACE bands are authoritative. Merchants charge more because corporate knowledge of the Rustler's activities and connections jeopardizes black-market operations and requires additional precautions. This does not imply merchant cooperation with corporations.
3. Identity Verification incentives: voluntary disclosure may earn genuine commercial advantages because information has economic value (UPL-IDENTITY-001, PHIL-CONSENT-001). Anonymous commerce remains viable. Exact discounts and disclosure consequences require further design.

The layers are independent, each with its own economic rationale, and may interact with other gameplay systems without new player-facing meters. Market variability is separate from TRACE; a higher-TRACE visit can still be cheaper than a lower-TRACE visit. Do not impose a shared ±5% cap that suppresses independent layers. Illustrative additive calculation before verification: 100 CRED, TRACE 40, market +2% = 107 CRED. Exact stacking with sales and verification, integer rounding, random distribution, and scope of affected services require confirmation before implementation. No engine changes authorized.


## NODE-PURPOSE-001 — Non-combat Node service redesign (APPROVED 2026-11-27)

Designer-approved amendment; supersedes conflicting earlier service descriptions, not MAP-003e route composition.

- Uplink (commerce): eight cards, exactly five common, two uncommon, one rare; six shared and two Rustler-specific across those eight. Base prices 40/60/90 CRED; one random card 50% off. No basic cards, rerolls or repeat purchase of a slot. Three random CAPS, existing 60/30/10 rarity probabilities, no guaranteed rarity; existing prices and bootleg rules retained. WIPE and Clinic unchanged; existing market variability, TRACE premium and voluntary Identity Verification direction retained. REFACTOR removed from Uplink.
- Console Lab (deck engineering): PATCHWORK and FUSE retained; REFACTOR is the collective modification concept. Standalone card removal belongs to Uplink WIPE. Detailed modification eligibility, repeat limits, recursive fusion, cross-modification, scaling, costs and per-visit limits deferred to dedicated review; do not infer new rules. COMPILE moved to experimentation, excluded from active development/gameplay; preserve prototype work and audit dependencies before disabling.
- SAFEHOUSE (physical recovery): choose one free service per visit: PATCH UP restores 30% of maximum VITAE, capped at maximum; FORTIFY increases maximum VITAE by 6% and current VITAE by the same increment. Both round to nearest whole integer; FORTIFY cumulative for the run, no additional cap currently. No card upgrades or TRACE reduction.
- DEAD DROP (surveillance evasion): choose one free service per visit: WIPE TRAIL reduces current TRACE by 20, floor zero; GHOST TRAIL reduces incoming TRACE by 50% throughout the next ICE Node, all encounters included, persists through intervening noncombat Nodes and expires on ICE Node exit. Active-effect icon direction. Fractional TRACE rounding, stacking and edge cases remain open; no physical healing.
- SIGNAL UNCLEAR (discovery): retain ten-event catalogue provisionally; specific event unknown on entry approach, choices except AMBUSH, communicate costs and consequences before commitment. Separate event design review deferred; existing reveal exceptions remain subject to review. Incidental overlap is permissible, not a predictable substitute for dedicated services.

Map redesign deferred to Claude Code/Codex review; MAP-003e remains baseline. Representative ICE encounter remains priority 1. Uplink implementation specification still requires transaction/inventory edge cases and UI review. No engine implementation authorized by this documentation amendment.


## MAP-003f / MINIBOSS-003 — Approved 2026-11-27
Every complete route must contain 2–3 Uplinks, at least one each SAFEHOUSE, DEAD DROP, Console Lab, SIGNAL UNCLEAR, exactly seven noncombat Nodes. All other MAP-003e constraints remain. Valid distributions in that order: (3,1,1,1,1), (2,2,1,1,1), (2,1,2,1,1), (2,1,1,2,1), (2,1,1,1,2). Distinct Mini-Boss icon identifies category only; identity and unique ability concealed until entry; fight mandatory on entry. Supersedes pre-entry ability disclosure. Claude Code assignment: audit Python prototypes/map/map003_generator.py V4, implement V5 retaining V4 comparison, deterministic seeds, bounded attempts, validate every route of at least 200 accepted maps, no unreachable nodes/dead ends, report acceptance rate, performance, route counts, distribution frequencies, miniboss accessibility/bypass and reproducibility. GDScript port and UI integration subsequent tasks; no engine changes in this assignment. Representative ICE Encounter remains priority 1.

**MAP-003f implementation (Claude Code, 2026-11-27; BUILT as a Python prototype; interpretations PROPOSED, not approved).** V5 in `prototypes/map/map003_generator.py --v5` builds maps constructively rather than by V4's repair-and-reject: an exact feasibility table for ICE count and spacing, then an exact search for the non-combat types. 200/200 seeds accepted (V4 36.3%); all 1,623,047 routes of the 200 maps validated, 0 dead-end or unreachable Nodes; V4 kept unchanged for comparison. The V4 audit found accepted maps with dead-end Nodes (33 of 363), a spacing check that skipped row 1, and Mini-Boss links with no alternative; only 7 of 363 V4 maps meet MAP-003f. Report: `prototypes/map/MAP003F_V5_REPORT.md`. *Interpretations to confirm:* (I1) spacing counts the row-1 Opening Node, the boss does not count; (I2) every row-8 Node leading into the Mini-Boss also offers a standard ICE Node; (I3) type attempts weighted Uplink 2.2 / others 1.2 to avoid pushing Uplinks late (result: about 30% of routes have 3 Uplinks); (I4) 2–3 links per Node, as in V4; (I5) no minimum Mini-Boss reach. Decision-ID note: MINIBOSS-003 also names THE GRID's PROFILE + FORTIFY decision; designer to choose an ID for one of them. CONSISTENCY-001 status: documentation partly reconciled (report §9).


## UPLINK-SPEC-001 — Approved functional development specification (2026-11-27)
Build on NODE-PURPOSE-001. Generate inventory on entry, seeded, no refresh, eight unique nonbasic cards exactly 5 common/2 uncommon/1 rare and 6 shared/2 current Rustler-specific; one uniformly random half-price card. Three unique CAPS, including no standard/bootleg equivalent duplication, existing rarity probabilities and bootleg rules; no guaranteed rarity. Insufficient eligible pool: explicit test configuration error, no silent relaxation. Sold slots remain visible and unavailable. Developer-only inventory override for approved Protocol/Script playtest. Base prices and WIPE escalation/Clinic bulk discount unchanged. Independent per-item/service market variability ±5% and TRACE premium additive to base; apply discounts afterward, round final price nearest whole CRED except Clinic retains round-up convention. All commercial transactions affected; lock modifiers/prices on entry (Clinic quantity determines total). Identity Verification modifier extension point only; gameplay deferred. Atomic transactions: insufficient funds disable purchase; card goes to compiled deck, CAP to rack; full rack offers confirmed replacement, cancellation changes nothing. WIPE eligible non-HARDWIRED card selection and confirmation, once per visit; Clinic quantity selection and confirmation. No combat turn or reshuffle on entry/exit; exit to map. UI mechanical console reusing V2 components, hover/contextual details, no new market meters; proposed UPL-UI-001 through 010 roles: chassis, card inventory, CAPS inventory, service counter, CRED, deck inspector, price indicator, transaction flyout, CAP replacement, exit. IDs/layout subject to register audit and UI approval. Separate presentation/controller/inventory/pricing from existing run state; no duplicate state or unnecessary encounter changes. Playtest uses MAP-003f generator, not bespoke five-node route; validate inventory, pricing, sold state, cancellation, purchases, full rack, WIPE escalation, Clinic, persistence across visits and subsequent encounters, regression and Windows playtest. Technical dependency audit pending; no code changed by documentation commit.


## UI-IDENTITY-001 — Architecture communicates allegiance (approved 2026-11-27)
**Architecture communicates allegiance.** The physical and visual construction of an environment should communicate its relationship to institutional power, surveillance and individual autonomy. Corporate environments express standardization, order and institutional authority; the Underworld expresses salvaged, adapted technology, individualism and clandestine commerce. Distinction extends beyond palette to architecture, materials, lighting, atmosphere and psychological experience. The Underworld is not necessarily safe or beyond surveillance. BG_NODE_UPLINK_UNDERWORLD.png is the principal artistic reference for the Black Market Uplink.

**Shared functionality. Distinct visual identity.** Reuse genuinely shared behavior, data bindings, transaction logic and interaction mechanisms, not necessarily visual presentation. Each Node may have its own artwork, materials, physical controls, animation and sound. Maintain interaction consistency without visual uniformity; never let component reuse dictate artistic direction or force premature abstraction. Apply this principle to Uplink decomposition and future Architecture V2 UI work. No implementation or asset changes authorized by this design record.


## UI-INSPECTOR-001 — Universal Object Inspector (approved direction 2026-11-27)
Game-wide shared hover/rollover inspector. Enlarged object/card image anchored left, preferably top-left; all explanatory text in right-hand column, right-aligned. Name/classification, mechanical effects, supplementary costs/restrictions as applicable; flavor quotation at bottom where applicable, subordinate to mechanical information. Omit irrelevant fields. Support cards, CAPS, Ghostware, ICE, Nodes, services and status effects with contextual content and disclosure restrictions. Shared functionality, environment-specific presentation per UI-IDENTITY-001. This is the first representative component for typography and motion design system development. Next: audit existing hover components and UI issue register, define content contract, prototype typography hierarchy and motion states, review edge avoidance/dismissal/activation timing and input accessibility, obtain designer approval, then implementation and regression validation. Representative ICE Encounter remains priority 1; typography/motion work proceeds alongside it. No final font, animation timing, component register ID or implementation file structure approved yet. No code changes in this documentation commit.


## UI-TYPE-001 — Game-wide typography exploration (approved 2026-11-27)
Three approved exploration directions for the shared UI typography system: A — Atomic Deco (geometric, period-inspired, expressive); B — Industrial Technical (precise, functional, legible); C — Hybrid (Atomic Deco headings with restrained technical body text). These are exploration candidates, not final font selections. Use UI-INSPECTOR-001 as the first representative test component: produce three complete inspector mockups with identical artwork, content, flavor quotation, frame, palette, dimensions, top-left image placement and right-aligned text. Vary only typography, spacing, weight and hierarchy. Evaluate legibility, atmosphere, hierarchy, scanning speed and long-term visual fatigue. Approved results will inform game-wide UI typography, not just the inspector or Uplink; preserve environment-specific visual identity per UI-IDENTITY-001. Next deliverable: three comparable complete mockups, then designer review and motion exploration. Typography/motion milestone proceeds alongside priority-1 Representative ICE Encounter. No final typefaces, motion timings or implementation changes approved by this record.


## PROBE-004a — Canonical PROBE wording and scope (APPROVED, 2026-11-27)
Confirms PROBE-004 and extends its authoritative wording across Architecture V2, not only the Core Loop build. PROBE is a STARTER SCRIPT — EXPLOIT, base cost 0 BW. Printed rules: **Choose one: Target ICE: −2 STR this encounter. OR Target VOID: Reveal all hidden subroutines. Costs 1 additional BW for each PROBE already played on the target ICE this turn.** Both modes share the same per-target, per-turn count across copies (0, 1, 2… BW); reset each turn. Reveal is available only on VOID with hidden subroutines; STR reduction does not reveal anything. Flavour: “The deeper you probe, the costlier it gets.” Supersedes conflicting older PROBE costs, automatic/top-only reveal and effect descriptions. Historical decisions remain historical. Claude Code follow-up: audit existing mode selection, engine, CardDB text, both UI paths and tests; reconcile discrepancies, verify both modes, shared cost, reset, invalid targets, cancellation and insufficient BW; run required Godot validation before committing code. Until validated, the existing CardDB description is known stale; no claim of runtime correction. Use approved wording in UI mockups.


## Canonical ownership and reconciliation gate (CONSISTENCY-001, approved 2026-11-27)
Before asserting current mechanics or producing mockups, read the latest architecture-v2 authoritative specification and check applicable approved amendments; memory and implementation are not design authority. Every mechanic/entity has exactly one designated current definition. Master Design records approval and precedence; Core Rules and designated specialist specifications own current mechanics; UI Bible owns presentation; architecture specifications own technical contracts. Historical decisions are not current definitions. Other active documents reference owners rather than independently restating mutable values. Audit existing owners before creating new catalogues; do not create parallel authorities.
For every approved change: identify owner and decision ID; search repository-wide for dependencies, old terminology and conflicting values; reconcile active documentation, data, UI, implementation and tests; explicitly label historical/superseded material; run relevant validation; record evidence and outstanding work in HANDOFF and log. Distinguish design approved, documentation reconciled, implementation pending, and validated/closed. Never mark fully reconciled while dependencies remain. Escalate genuine design conflicts to designer; do not silently choose. Preserve historical archives. Keep AGENTS.md and CLAUDE.md identical.
Immediate cross-cutting milestone alongside Representative ICE Encounter (priority 1): Claude Code conducts repository-wide audit, inventories existing canonical owners and consumers, and produces discrepancy register with file/line evidence, severity, decision IDs, proposed correction, owner and status. Audit cards/decks/rewards, ICE/subroutines, terminology/resources, CAPS/Ghostware/Protocols, encounter timing, nodes/economy, UI and tests. PROBE-004a is a known open implementation reconciliation. First deliver audit and ownership register; then reconcile unambiguous approved rules in atomic batches; seek designer approval for ambiguous rules and architecture changes. Propose structured canonical card data using existing infrastructure where feasible, generated/linked documentation and inspector consumption; extend to ICE/CAPS/Ghostware after review. Add CI checks for deprecated active terms, identifiers, duplicated values/text where machine-checkable, links, decision status and agent-file equality; behavioural tests for semantic rules. Exclude explicitly historical material, not active code. Report audit coverage, exceptions and test results. No engine refactor or new schema is authorized without reviewed architecture plan. This milestone is not complete until audit and reconciliation evidence exist.


## CONSISTENCY-001a — Structural prevention, not repeat cleanup (APPROVED, 2026-11-27)
Amends CONSISTENCY-001: retain its reconciliation gate, but supersede the general discrepancy audit as the primary deliverable. Previous audits and manual reconciliation have not prevented recurrence. Claude Code must conduct a Canonical Source Architecture Audit before proposing migration: map existing authorities, duplicate mutable definitions, consumers, generation paths, tests and CI/branch enforcement; identify why drift is possible and reuse existing infrastructure rather than create competing sources. Separate current specifications from historical decision records; preserve Master Design approval/precedence and history without requiring agents to reconstruct current mechanics from amendments.
Milestone acceptance sequence (cross-cutting alongside Representative ICE Encounter, which remains priority 1): CSA-01 map existing owners and consumers with evidence; CSA-02 obtain designer approval of canonical data architecture and migration plan; CSA-03 migrate card definitions to one authoritative structured record per ID; CSA-04 connect engine parameters, Universal Object Inspector, Uplink and generated/linked documentation to that source, with explicit handling of complex behaviour; CSA-05 implement CI checks for schema, IDs, deprecated active terminology, generated-output drift, decision traceability and independent behavioural regression tests; investigate required checks and branch protection, report permission constraints and obtain approval before changing repository settings; CSA-06 retire redundant active definitions after dependency validation, preserving history; CSA-07 extend reviewed pattern to ICE, CAPS and Ghostware. Do not hand-maintain generated outputs or derive test expectations solely from the implementation under test. No new schema, engine refactor, or branch protection change before reviewed plan and authorization.
PROBE-004a is the first end-to-end acceptance case: demonstrate in a controlled test that a canonical definition change propagates to consumers or causes validation failure; demonstrate rejection of stale generated text, invalid IDs and deprecated active terms; independently verify selectable STR reduction versus reveal-all on eligible VOID, shared escalating cost, reset and cancellation. Do not alter approved live balance merely to demonstrate propagation. Report exact commands, results, consumer coverage, remaining manual/semantic checks and enforcement gaps. A clean audit report alone is not completion; structural prevention, retirement of duplicates and verified enforcement are required. Keep pending work explicitly open. Claude Code owns execution; no claim of audit or migration completion from this documentation commit.

**CSA-01 delivered; CSA-02 PROPOSED (Claude Code, 2026-11-27; not approved).** Audit and proposal: `docs/architecture-v2/CANONICAL_SOURCE_ARCHITECTURE.md`. Root causes with evidence:
- RC1: up to six independent hand-kept definitions per card.
- RC2: decisions copied into each doc.
- RC3: "later amendments win".
- RC4: `CORE_LOOP` variants with one text.
- RC5: tests pin implementation; `test_core_loop.gd:98` asserts superseded PROBE behaviour while the suite is green.
- RC6: no implementation or design status.
- RC7: no branch protection or ruleset on `architecture-v2`; CI is Godot-only.
- RC8: audits produce reports, not checks.

Scanner: 35 of 124 doc card rows differ from CardDB in text and 2 in BW; 56 tabulated names have no CardDB entry (10 are approved SYNERGY-PLAYTEST-002 cards). PROBE-004a conformance on the live engine: 5 of 7 checks fail. Proposed: `godot/data/cards.json` as the one record per card ID, loaded by CardDB (API unchanged), with engine parameters, generated text and doc views, Inspector and Uplink contracts, literal decision-tagged spec tests, a Python CI job and an optional ruleset. Designer decisions requested: Q1–Q9 (document §8). CSA-03 to CSA-07 not started; no schema, engine or settings change made.

**CSA-02 designer answers (2026-11-27 18:24):**

| Question | Designer's answer | Status |
|---|---|---|
| Q1 canonical format `godot/data/cards.json` | "yes. perfect" | **APPROVED** |
| Q3 decision text only in Master Design; other docs reference the ID | "that works for me" | **APPROVED** |
| Q5 enforcement | "whatever works best to ensure one Single source of truth for each element, and I can be the approver" | **APPROVED** in direction: a ruleset on `architecture-v2` requiring the CSA checks to pass, changes through pull requests, the designer as approver. The designer applies it once the CSA-05 checks exist |
| Q6 PROBE cost counter per ICE instance | "yes per individual ice, correct" | **APPROVED** |
| Q7 conflicts | "agreed. a later approved decision wins" | **APPROVED**; the designer reconciles the conflict table ([Sheet](https://claude.ai/artifact/1Cw8TYzdiTscPtYLAXfsnF)). Resolutions are recorded here when returned |
| Q8 status format (approved-unbuilt cards in records as `pending`; experimental cards stay in the Experimentation Bible) | "that format is approved" | **APPROVED** |
| Q9 retired mechanics (BOOTING, TOLL) | "approved for this process to retire in a controlled rules commit under their decision IDs" | **APPROVED** |
| Q2 generated doc views (Card Pools, Rustlers) | not yet answered | OPEN |
| Q4 build variants | asked where variant values would live; answered in session | OPEN |

CSA-03 may start once Q2, Q4 and the conflict table are settled.

**CSA-02 Q2/Q4/Q5 and CSA-03 conflict resolutions (designer, 2026-11-27 18:59; table: [Sheet](https://claude.ai/artifact/1Cw8TYzdiTscPtYLAXfsnF) revision 63).**
- **Q4 (APPROVED):** "I choose the core-loop values become the only current ones." Core-loop values are current. Full-game values superseded by STR-001 and the core-loop build are historical, and cards get no `variants` block. This covers DEEP PROBE −4, starter Icepick STR 1 / 3 / 0 and boost 2 BW (BREAKER-STARTER-001/002, ROT-001 values).
- **Q2 (APPROVED):** generated card views in `REDLINE_CARD_POOLS.md` (pool cards) and `REDLINE_RUSTLERS.md` (starter decks); other docs reference card IDs.
- **Q5 (APPROVED, unchanged):** the designer applies the ruleset once the CSA-05 checks exist.

**Resolutions (APPROVED):**

| # | Card | Resolution |
|---|---|---|
| 1–3 | PAYDAY, BLACKOUT, JAMMER (Experimentation Bible) | Rename the experimental cards; live cards unchanged |
| 4 | DEEP PROBE | −5 STR (engine) |
| 5 | DEFRAG | "Discard 1 card, then draw 2." (DEFRAG-001) |
| 6 | BURST | 3 BW, gain 5 BW, +1 BW per play this encounter (BURST-001) |
| 7 | SIDE CHANNEL | Breaks any ICE type (engine) |
| 9, 11, 13 | Starter Icepicks | STR 2, boost 1 BW → +1 STR (STR-001) |
| 15 | BASIC EXTRACTOR | 3 CRED (EXTRACT-002) |
| 16 | PROBE | PROBE-004a text |
| 28–30 | GARBAGE COLLECT, TAIL CALL, FORCE REBOOT | Approved doc wording |
| 34 | BORROWED CREDENTIALS | Doc wording (boost costs included); 8 CRED in the cost field |

**Same card repeated in another doc** (rows 10, 12, 14, 17–21, 23–26: designer "duplicate … Delete this card"): the doc's hand-written copy is retired. These docs reference or generate from the single record (CSA-06, per Q2/Q3); the cards themselves stay in the game. *Interpretation to confirm.*

**PIVOT (CHAIN-PARK-001 follow-up, APPROVED):** "Chain mechanic is moved to Experimental. CHAIN should be removed from all current cards." New PIVOT text: **[1 BW] Target ICE −1 STR this encounter. If this reduces target ICE STR to 0, break one of the target ICE subroutines for no cost.** (Designer's "taget" read as "target".) This is a rules change, implemented in a controlled rules commit with spec tests.

**Follow-up answers (designer, 2026-11-27, APPROVED):**
- **BURNED-001 (rules change; ID assigned by Claude Code):** BURNED lasts **the rest of the encounter**, replacing "the rest of the Node" (Core Rules §3). Affects the 12 BURNED cards: GHOST SIGNAL, FLINCH, BURN NOTICE, UNINSTALLER, PATCH KIT, VANISH, BLACKOUT, NO WITNESSES, SPAM, FORCE REBOOT, NULL POINTER, ZERO FOOTPRINT. Core Rules, engine (`game.gd` `burned` reset at Node start/end) and tests change in a controlled rules commit with spec tests. GHOST SIGNAL prints "BURNED."
- **Row 8 HOST TAKEOVER:** doc wording ("target ICE").
- **Rows 31, 32, 33, 35:** MINIMALIST, SCALPEL, ZERO FOOTPRINT and SMASH & GRAB move to experimental (out of current cards).
- **CHAIN cards:** COVER FIRE, KILL CHAIN and HANDOFF move to experimental. PIVOT stays, with its new text.

**Consequence to note:** SMASH & GRAB is one of RIOT's 15 starter cards (`STARTER_RIOT`, RIOT-005), so RIOT's starter deck is one card short until it is redesigned. RIOT is not in the current core-loop build. ZERO FOOTPRINT is also a BURNED card, so it leaves the BURNED-001 list.

**Designer, 2026-11-27 19:30 (APPROVED):**
- **RIOT-006 (ID assigned by Claude Code):** RIOT's starter deck replaces SMASH & GRAB with a 4th PROBE: "give riot +1 Probe. That brings the deck to 15 cards." The deck is SLEDGE, BRUTE FORCE, SHATTER, OVERLOAD, PROBE ×4, FEEDBACK, ADRENAL SPIKE, PULP Shield ×3, LAY LOW, Basic Extractor. Implemented in a controlled data commit (CSA-03 C2).
- **Repeated card text in other docs:** confirmed. The extra copies are retired, all docs refer to the single record, and the cards stay in the game using the single record's text (CSA-06).
- **Divergent text (CSA-03):** where the engine does not yet match an approved card (PROBE, PIVOT, the BURNED-001 cards), the record stores the approved text, and cards show the current engine text in a field marked temporary until the behaviour is fixed. The validator lists every such card.
- **SYNERGY-PLAYTEST-002 rarity and pool (playtest values, not final balance):**
  - Common: REACTIVE ARMOUR, COUNTERINTELLIGENCE, FEEDBACK LOOP, ADAPTIVE DEFENCE, FOLLOW THROUGH, ESCALATION, AFTERBURN.
  - Uncommon: OVERCLOCK, SALVAGE.
  - Rare: REPRISE.
  - All shared, and added to the current reward pool. They become reward-eligible as each handler is implemented; until then they are `pending` and excluded.
- **PATTERN ANALYSIS (ICE):** marked experimental. CHAIN_PULP has no trigger while CHAIN is parked; the definition is kept and stays out of maps until redesigned.

**CSA-03 C1 built (Claude Code, 2026-11-27):** `godot/data/cards.json` is now the card source CardDB loads (API unchanged). Parity with the old constants is proven by `test_csa_cards.gd`; no behaviour change.

**CSA-03 C2 built (Claude Code, 2026-11-27):** every card and CAP record carries `status` (design / implementation) and `decisions`. Decision coverage is 43 of 122 records; the backfill is open. RIOT-006 is applied. The ten SYNERGY-PLAYTEST-002 cards are recorded as `playtest` / `pending`: the engine does not load them, and they are listed in `core_pool`, joining the live pool once built. Seven cards are experimental: kept for their handlers, never rewards or starter cards. PATTERN ANALYSIS is marked experimental. Divergent records (PROBE, PIVOT, 11 BURNED-001 cards) show the engine text and store the approved text and reason. The behaviour comparison baseline is now 3,938 actions / 4,018 checks (was 4,008 / 4,088); the whole change is RIOT-006, verified by reverting it.

**CSA-03 C3 built (Claude Code, 2026-11-27):** the approved wording is now shown for TAIL CALL, HOST TAKEOVER and FORCE REBOOT (the engine already matched) and for BORROWED CREDENTIALS ("boosts", verified in `break_info`). Its approved text, without "Costs 8 CRED.", is stored as divergent until the V2 card view draws `cred_cost`. GARBAGE COLLECT is divergent under BURNED-001, because the card it BURNs goes to the same `burned` pile. **Confirmed by the designer (20:20):** GARBAGE COLLECT's card goes to the burned pile, so BURNED-001 applies. **CSA-03 BUILT**, awaiting designer acceptance.

**Designer, 2026-11-27 20:20 (APPROVED):**
- **SYNERGY-PLAYTEST-002 tags:** FOLLOW THROUGH EXPLOIT; ESCALATION EXPLOIT; AFTERBURN CLOAK; REPRISE none; the six Protocols none.
- **CRED-COST-001 (ID assigned by Claude Code; UI):** the V2 card face shows a CRED cost chip with the number inside, beside the BW cost, only on cards with a CRED cost. BORROWED CREDENTIALS then drops "Costs 8 CRED." from its text. Built in CSA-04 with a screenshot for visual review.

**Designer, 2026-11-27 20:27 (APPROVED), CSA-04 alignment:**
- **PROBE (PROBE-004a, restated):** "0 BW; choose one: −2 STR on the target ICE or reveal (all) hidden subroutines on a target VOID (ICE). Probe costs +1BW for each Probe already played on target ICE this turn."
- **BURNED-001a:** at the end of an encounter, that encounter's BURNED cards go to the **discard pile**, as expired Protocols do (PROTOCOL-DURATION-001a).
- **BURNED-001b:** cleared SPAM (Bloatware, pay 1 BW) does not return: "it disappears forever." Clearing removes the card; it is not BURNED.
- **PIVOT:** when its −1 STR brings the ICE to 0, the Rustler chooses which subroutine breaks free. Any subroutine they could normally break is eligible (visible, unbroken, usual order rules); there is no prompt when only one qualifies.

**CSA-03 accepted** by the designer (2026-11-27 20:36). **CSA-04a built:** CRED-COST-001 chip on the V2 card face; BORROWED CREDENTIALS aligned. **CSA-04b built:** PROBE matches PROBE-004a in the engine and both UIs (spec test `test_spec_probe.gd`). **CSA-04c built:** BURNED-001/001a/001b in the engine (BURNED cards return to discard at encounter end; cleared SPAM is removed), GARBAGE COLLECT and SPAM text, Core Rules §3 BURNED definition (spec test `test_spec_burned.gd`). **CSA-04d built:** PIVOT plays its approved text (−1 STR this encounter; reaching 0 breaks one target subroutine for no cost, chosen by the Rustler, no prompt when only one qualifies) and has no CHAIN field (spec test `test_spec_pivot.gd`). No card record is divergent.
