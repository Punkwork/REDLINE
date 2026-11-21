# AVATAR-001 — ChatGPT prompts, round 7 (IRONWATCH ICE avatars)

**Date:** 2026-11-20 · **Author:** Claude · **For:** the designer, to paste into ChatGPT
**Designer's direction (2026-11-20, answering the prework questions in `IRONWATCH_AVATAR_PREWORK.md`):**
- Style: "A cross between 2 and 3" (heavy civic machinery × faceless authority) "with robot dogs, saucer drones, make them more ornate in terms of the lethal versions. Such as the more lethal the phase, the more gas hoses, tiny little guns, lazers and syringes (especially the syringes) come out of all sorts of places, with previously unseen doors and hatches from where these appear."
- Human features: uniform yes, faces no (the K9 robot dog is the one animal face).
- Base: start from FACADE-001's approved security appliances, plus the four escape ICE that were never designed.
- Mockups first.

**Roster:** 23 ICE (Opening TURNSTILE, SECURITY GUARD; Tier 1 CHECKPOINT, BODY CAM, PATROL DRONE, KEYCARD READER, BARRICADE; Tier 2 BLAST DOOR, STUN TURRET, K9 UNIT, CROWD CONTROL, ARMORY, INTERROGATION, SNIPER NEST, PATTERN ANALYSIS; Central DISPATCH, SHOCK TROOPER, OVERWATCH; escape ROADBLOCK, SPIKE STRIP, SEARCHLIGHT, PURSUIT DRONE; Black ICE LETHAL FORCE). 22 × 3 moods + LETHAL FORCE = 67 images.

Order: run prompt 0, show Claude the mockups, adjust, then prompts 1–3.


**Mockup review (2026-11-20, Claude):** mockups saved in `docs/visual/explorations/ironwatch-avatars/`. The K9 UNIT escalation is exactly the brief (sealed → hatches cracking with a syringe → every hatch open with syringes, lasers, guns and hoses), so that image is now the attached reference for prompts 1–3. Fixes folded into prompts 1–3: in the lineup most appliances had **no visible face** (fine for a museum shelf, unreadable in a game), so the style now demands a big face turned to the viewer that changes colour with the mood; the production images must have a **transparent** background (the mockups painted the hall in); PATTERN ANALYSIS came out as a film camera, SHOCK TROOPER as a bare shield and SECURITY GUARD as a cylinder, so their descriptions are sharper. Idea for the designer: the encounter mockup's **navy-and-gold consoles** suggest a console colour per corporation.

---

## 0. Mockups (3 images)

```
STYLE GUIDE: Painted 1950s atompunk / Googie illustration, like a mid-century appliance ad or a pulp sci-fi comic cover. Clean confident ink outlines, soft airbrushed gradients, gentle painted texture and a light halftone print grain. Not photographic, not 3D-rendered, not anime.

IRONWATCH is the street-security corporation: checkpoints, patrol drones, body cameras and armed response, sold to cities, malls and gated estates as "SafeStreets". It is allowed to act on what it sees. Its ICE (security programs) are civic security machines: heavy, armoured street hardware crossed with faceless authority. Robot dogs, saucer drones, turrets, gates, kiosks and lockers. IRONWATCH's look: navy enamel, badge gold and brass, porcelain white, polished chrome, rivets and fins, a gold seven-point badge inside a searchlight-fan sunburst somewhere on every ICE (IRONWATCH's emblem), peaked caps, chevrons and whistles.

THE KEY RULES:
- HEAVY AND FACELESS: weighty armoured machines with menace, never cute. Uniform details are fine (a peaked cap, a badge, a coat), but NO human faces: every face is a visor, lens, lamp, grille, scope or display. The K9 robot dog is the only animal face.
- HIDDEN HATCHES: every ICE hides doors, panels and hatches that are invisible or closed when friendly. As the mood worsens they open, and weapons and instruments come out of all sorts of places: gas hoses, tiny guns, laser emitters, and especially SYRINGES (lots of syringes, on jointed arms). No gore, no blood.
- A BIG, OBVIOUS FACE: every ICE turns its face toward the viewer, and the face is large and clear even at small size: lamps, lenses, visor slits or grilles arranged as eyes and a mouth that glow and change with the mood (calm gold, narrowed amber, glaring red). An appliance with no visible face is wrong. Every ICE gets a DIFFERENT kind of face. Only the K9 UNIT may show metal fangs.
- Its job stays readable: you can tell what security device it is.

Body plan by ICE type: FORTRESS = heavy, wide and planted, a wall, gate, locker or vault with a barrier in front. TUMBLER = round, with something that visibly spins or rotates (a drum, a carousel, a dial, a turnstile). VOID (a sentry) = built around one big sensor (lens, searchlight, scope), on legs, a stalk, treads or hovering fins, with one "stinger" part, leaning toward you.

Each ICE has three moods, one image each, same machine, same framing; the escalation is the point:
- cheery: the polished civic appliance. Every hatch closed and seamless, clean navy and gold, soft daylight, helpful and orderly, maybe a cheerful little salute or wave of a part.
- wary: hatches cracking open. A few panels slide back, one or two syringes, nozzles or gun barrels peek out, a hose uncoils, lenses narrow, a red beacon starts to glow.
- lethal: fully armed and ornate. Every hidden door and hatch is open and bristling: gas hoses hissing, many tiny guns, laser emitters with red beams, and syringes on jointed arms everywhere. Harsh red beacon light, searchlight white, the badge emblem glowing red.

First, three MOCKUPS to settle the look before I order the full set. These are concept art, not game files: text is allowed in mockup 3 only.

1. IRONWATCH_LINEUP.png — 1920 × 1080. A lineup in a grand navy-and-brass civic security concourse (a 1939 transit hall crossed with a precinct house): IRONWATCH's ICE standing in ranks like a parade, all in their calm "cheery" mood with every hatch closed: TURNSTILE, SECURITY GUARD (kiosk in a peaked cap), CHECKPOINT (boom gate), BODY CAM (walking star-badge camera), PATROL DRONE (saucer), KEYCARD READER, BARRICADE (stanchions turning to bollards), BLAST DOOR, STUN TURRET, K9 UNIT (robot dog), CROWD CONTROL (loudspeaker pole), ARMORY (gun locker), INTERROGATION (desk lamp on a table), SNIPER NEST (telescope rifle on a dome), PATTERN ANALYSIS (ticker-tape tripod), DISPATCH (switchboard), SHOCK TROOPER (riot shield with an empty visor), ROADBLOCK (barrier on treads), SPIKE STRIP (spike-chain drum), SEARCHLIGHT (street lamp), PURSUIT DRONE (rocket-bike), with OVERWATCH (the ziggurat tower with a crown of searchlights) looming behind them all and LETHAL FORCE (an empty officer's coat with a red visor) standing apart in shadow.
2. IRONWATCH_K9_MOODS.png — 1920 × 1080. K9 UNIT three times side by side to show the escalation: cheery (sleek and sealed, sitting politely), wary (two panels open on its flanks, a syringe and a nozzle peeking out, a red lamp on its collar), lethal (every hatch open: gas hoses, tiny guns along its spine, laser emitters, syringes on jointed arms from its back and sides, jaws open, red beacon light).
3. IRONWATCH_ENCOUNTER_MOCKUP.png — 1920 × 1080. A game-screen mockup in the style of a 1950s atompunk instrument panel: a copper-and-bakelite top bar with TURN, TRACE and a red HOSTILE REVEAL gauge; a green CRT monitor on the left; two navy-and-gold enamel ICE consoles side by side in the middle, the left holding PATROL DRONE and the right K9 UNIT (each with a black name plate, a STR plate and a row of chrome key-buttons with icons below it); a row of small white playing cards in a copper tray along the bottom with a red mushroom END TURN button. The ICE are in their "wary" mood, hatches cracking open. The concourse visible behind the panels.

Reply "ready" and then make mockup 1.
```

## 1. Opening Node and Tier 1 (8 ICE, 24 images)

```
STYLE GUIDE: Painted 1950s atompunk / Googie illustration, like a mid-century appliance ad or a pulp sci-fi comic cover. Clean confident ink outlines, soft airbrushed gradients, gentle painted texture and a light halftone print grain. Not photographic, not 3D-rendered, not anime.

IRONWATCH is the street-security corporation: checkpoints, patrol drones, body cameras and armed response, sold to cities, malls and gated estates as "SafeStreets". It is allowed to act on what it sees. Its ICE (security programs) are civic security machines: heavy, armoured street hardware crossed with faceless authority. Robot dogs, saucer drones, turrets, gates, kiosks and lockers. IRONWATCH's look: navy enamel, badge gold and brass, porcelain white, polished chrome, rivets and fins, a gold seven-point badge inside a searchlight-fan sunburst somewhere on every ICE (IRONWATCH's emblem), peaked caps, chevrons and whistles.

THE KEY RULES:
- HEAVY AND FACELESS: weighty armoured machines with menace, never cute. Uniform details are fine (a peaked cap, a badge, a coat), but NO human faces: every face is a visor, lens, lamp, grille, scope or display. The K9 robot dog is the only animal face.
- HIDDEN HATCHES: every ICE hides doors, panels and hatches that are invisible or closed when friendly. As the mood worsens they open, and weapons and instruments come out of all sorts of places: gas hoses, tiny guns, laser emitters, and especially SYRINGES (lots of syringes, on jointed arms). No gore, no blood.
- A BIG, OBVIOUS FACE: every ICE turns its face toward the viewer, and the face is large and clear even at small size: lamps, lenses, visor slits or grilles arranged as eyes and a mouth that glow and change with the mood (calm gold, narrowed amber, glaring red). An appliance with no visible face is wrong. Every ICE gets a DIFFERENT kind of face. Only the K9 UNIT may show metal fangs.
- Its job stays readable: you can tell what security device it is.

Body plan by ICE type: FORTRESS = heavy, wide and planted, a wall, gate, locker or vault with a barrier in front. TUMBLER = round, with something that visibly spins or rotates (a drum, a carousel, a dial, a turnstile). VOID (a sentry) = built around one big sensor (lens, searchlight, scope), on legs, a stalk, treads or hovering fins, with one "stinger" part, leaning toward you.

Each ICE has three moods, one image each, same machine, same framing; the escalation is the point:
- cheery: the polished civic appliance. Every hatch closed and seamless, clean navy and gold, soft daylight, helpful and orderly, maybe a cheerful little salute or wave of a part.
- wary: hatches cracking open. A few panels slide back, one or two syringes, nozzles or gun barrels peek out, a hose uncoils, lenses narrow, a red beacon starts to glow.
- lethal: fully armed and ornate. Every hidden door and hatch is open and bristling: gas hoses hissing, many tiny guns, laser emitters with red beams, and syringes on jointed arms everywhere. Harsh red beacon light, searchlight white, the badge emblem glowing red.

Use the attached K9 UNIT moods picture as the reference for style, detail and how far the hatches open in each mood. Rules for every image: PNG, TRANSPARENT background (no hall, no floor, no sky; only the machine and the ledge), 1024 × 1024. The ICE stands on, rolls on, or hovers just above a horizontal ledge along the bottom edge of the image, three-quarters view, in the left two-thirds of the image, the top of the machine about 60 px below the top edge. NO text, letters, numbers or logos anywhere (the badge has no writing). Exact file name.

Make these ONE AT A TIME, in this order (cheery, then wary, then lethal for each). After each image, wait until I type "next".

1–3. TURNSTILE_cheery / _wary / _lethal.png — FORTRESS. A heavy brass three-arm turnstile on a navy enamel plinth, the arms braced like a barrier. Face: a porthole display window showing two light-dots and a line.
4–6. SECURITY_GUARD_cheery / _wary / _lethal.png — VOID. A porcelain-and-navy reception desk kiosk (a counter, not a cylinder) wearing a big peaked officer's cap on top; a lens on a jointed periscope stalk peers over the counter. Face: under the cap's visor, a dark band with one round glowing lens and a speaker grille. Stinger: a baton arm from behind the counter.
7–9. CHECKPOINT_cheery / _wary / _lethal.png — FORTRESS. A striped boom-gate arm on a finned navy post, lowered across the way like a wall. Face: a round signal lamp on the post with a grille below it.
10–12. BODY_CAM_cheery / _wary / _lethal.png — VOID. A badge-shaped chest camera (a gold seven-point star with a big lens) walking on short jointed legs. Face: the lens. Stinger: a clamp arm with a cuff.
13–15. PATROL_DRONE_cheery / _wary / _lethal.png — VOID. A finned chrome flying saucer with a porcelain dome and a searchlight underneath, hovering. Face: the searchlight as one eye. Stinger: a net launcher under the rim.
16–18. KEYCARD_READER_cheery / _wary / _lethal.png — TUMBLER. A wall-mounted card reader on a pedestal with an LED strip and a slot; inside, a rotating carousel of keycards turns. Face: the LED strip as eyes and the slot as a mouth.
19–21. BARRICADE_cheery / _wary / _lethal.png — FORTRESS. A row of velvet-rope stanchions whose posts are thickening into steel bollards, gold knobs on top. Face: the knob tops polished like eyes in a row.
22–24. BLAST_DOOR_cheery / _wary / _lethal.png — FORTRESS. A round vault door in a heavy frame with a brass spoked wheel at its centre. Face: the wheel hub, its spokes like a gaze.

Reply "ready" and then make image 1.
```

## 2. Tier 2 (7 ICE, 21 images)

```
STYLE GUIDE: Painted 1950s atompunk / Googie illustration, like a mid-century appliance ad or a pulp sci-fi comic cover. Clean confident ink outlines, soft airbrushed gradients, gentle painted texture and a light halftone print grain. Not photographic, not 3D-rendered, not anime.

IRONWATCH is the street-security corporation: checkpoints, patrol drones, body cameras and armed response, sold to cities, malls and gated estates as "SafeStreets". It is allowed to act on what it sees. Its ICE (security programs) are civic security machines: heavy, armoured street hardware crossed with faceless authority. Robot dogs, saucer drones, turrets, gates, kiosks and lockers. IRONWATCH's look: navy enamel, badge gold and brass, porcelain white, polished chrome, rivets and fins, a gold seven-point badge inside a searchlight-fan sunburst somewhere on every ICE (IRONWATCH's emblem), peaked caps, chevrons and whistles.

THE KEY RULES:
- HEAVY AND FACELESS: weighty armoured machines with menace, never cute. Uniform details are fine (a peaked cap, a badge, a coat), but NO human faces: every face is a visor, lens, lamp, grille, scope or display. The K9 robot dog is the only animal face.
- HIDDEN HATCHES: every ICE hides doors, panels and hatches that are invisible or closed when friendly. As the mood worsens they open, and weapons and instruments come out of all sorts of places: gas hoses, tiny guns, laser emitters, and especially SYRINGES (lots of syringes, on jointed arms). No gore, no blood.
- A BIG, OBVIOUS FACE: every ICE turns its face toward the viewer, and the face is large and clear even at small size: lamps, lenses, visor slits or grilles arranged as eyes and a mouth that glow and change with the mood (calm gold, narrowed amber, glaring red). An appliance with no visible face is wrong. Every ICE gets a DIFFERENT kind of face. Only the K9 UNIT may show metal fangs.
- Its job stays readable: you can tell what security device it is.

Body plan by ICE type: FORTRESS = heavy, wide and planted, a wall, gate, locker or vault with a barrier in front. TUMBLER = round, with something that visibly spins or rotates (a drum, a carousel, a dial, a turnstile). VOID (a sentry) = built around one big sensor (lens, searchlight, scope), on legs, a stalk, treads or hovering fins, with one "stinger" part, leaning toward you.

Each ICE has three moods, one image each, same machine, same framing; the escalation is the point:
- cheery: the polished civic appliance. Every hatch closed and seamless, clean navy and gold, soft daylight, helpful and orderly, maybe a cheerful little salute or wave of a part.
- wary: hatches cracking open. A few panels slide back, one or two syringes, nozzles or gun barrels peek out, a hose uncoils, lenses narrow, a red beacon starts to glow.
- lethal: fully armed and ornate. Every hidden door and hatch is open and bristling: gas hoses hissing, many tiny guns, laser emitters with red beams, and syringes on jointed arms everywhere. Harsh red beacon light, searchlight white, the badge emblem glowing red.

Use the attached K9 UNIT moods picture as the reference for style, detail and how far the hatches open in each mood. Rules for every image: PNG, TRANSPARENT background (no hall, no floor, no sky; only the machine and the ledge), 1024 × 1024. The ICE stands on, rolls on, or hovers just above a horizontal ledge along the bottom edge of the image, three-quarters view, in the left two-thirds of the image, the top of the machine about 60 px below the top edge. NO text, letters, numbers or logos anywhere (the badge has no writing). Exact file name.

Make these ONE AT A TIME, in this order (cheery, then wary, then lethal for each). After each image, wait until I type "next".

1–3. STUN_TURRET_cheery / _wary / _lethal.png — VOID. A raygun turret on a chrome dome with fins and copper coils. Face: the emitter as one eye with a ring of vents. Stinger: the coils.
4–6. K9_UNIT_cheery / _wary / _lethal.png — VOID. A streamlined chrome-and-navy robot dog on four jointed legs, tail antenna, collar with the badge. Face: a dog's head built of armour plates, two lamp eyes and a grille snout (the only animal face). Stinger: jaws of chrome.
7–9. CROWD_CONTROL_cheery / _wary / _lethal.png — TUMBLER. A rotating pole crowned with loudspeaker horns, on a heavy wheeled base. Face: the front horn's mouth with two small lamps above it.
10–12. ARMORY_cheery / _wary / _lethal.png — FORTRESS. A tall glass-fronted locker in navy and gold, racks visible behind the glass. Face: the brass lock plate and two keyholes as eyes.
13–15. INTERROGATION_cheery / _wary / _lethal.png — TUMBLER. A gooseneck desk lamp bolted to a steel table, with a spinning card-file wheel beside it. Face: the lamp head, glaring down. Lethal: syringes and clamps rise from the table.
16–18. SNIPER_NEST_cheery / _wary / _lethal.png — VOID. A long brass telescope rifle on a rooftop observatory dome. Face: the scope's round lens with crosshair. Stinger: the barrel.
19–21. PATTERN_ANALYSIS_cheery / _wary / _lethal.png — VOID. A ticker-tape machine (NOT a film camera) on a tripod: a brass typewriter-like body spilling a long paper tape, with a cork pinboard of photos joined by red string rising behind it like a crest. Face: two round dial gauges as eyes and the row of typewriter keys as teeth. Stinger: a punch stylus.

Reply "ready" and then make image 1.
```

## 3. Central Node, escape and Black ICE (8 ICE, 22 images)

```
STYLE GUIDE: Painted 1950s atompunk / Googie illustration, like a mid-century appliance ad or a pulp sci-fi comic cover. Clean confident ink outlines, soft airbrushed gradients, gentle painted texture and a light halftone print grain. Not photographic, not 3D-rendered, not anime.

IRONWATCH is the street-security corporation: checkpoints, patrol drones, body cameras and armed response, sold to cities, malls and gated estates as "SafeStreets". It is allowed to act on what it sees. Its ICE (security programs) are civic security machines: heavy, armoured street hardware crossed with faceless authority. Robot dogs, saucer drones, turrets, gates, kiosks and lockers. IRONWATCH's look: navy enamel, badge gold and brass, porcelain white, polished chrome, rivets and fins, a gold seven-point badge inside a searchlight-fan sunburst somewhere on every ICE (IRONWATCH's emblem), peaked caps, chevrons and whistles.

THE KEY RULES:
- HEAVY AND FACELESS: weighty armoured machines with menace, never cute. Uniform details are fine (a peaked cap, a badge, a coat), but NO human faces: every face is a visor, lens, lamp, grille, scope or display. The K9 robot dog is the only animal face.
- HIDDEN HATCHES: every ICE hides doors, panels and hatches that are invisible or closed when friendly. As the mood worsens they open, and weapons and instruments come out of all sorts of places: gas hoses, tiny guns, laser emitters, and especially SYRINGES (lots of syringes, on jointed arms). No gore, no blood.
- A BIG, OBVIOUS FACE: every ICE turns its face toward the viewer, and the face is large and clear even at small size: lamps, lenses, visor slits or grilles arranged as eyes and a mouth that glow and change with the mood (calm gold, narrowed amber, glaring red). An appliance with no visible face is wrong. Every ICE gets a DIFFERENT kind of face. Only the K9 UNIT may show metal fangs.
- Its job stays readable: you can tell what security device it is.

Body plan by ICE type: FORTRESS = heavy, wide and planted, a wall, gate, locker or vault with a barrier in front. TUMBLER = round, with something that visibly spins or rotates (a drum, a carousel, a dial, a turnstile). VOID (a sentry) = built around one big sensor (lens, searchlight, scope), on legs, a stalk, treads or hovering fins, with one "stinger" part, leaning toward you.

Each ICE has three moods, one image each, same machine, same framing; the escalation is the point:
- cheery: the polished civic appliance. Every hatch closed and seamless, clean navy and gold, soft daylight, helpful and orderly, maybe a cheerful little salute or wave of a part.
- wary: hatches cracking open. A few panels slide back, one or two syringes, nozzles or gun barrels peek out, a hose uncoils, lenses narrow, a red beacon starts to glow.
- lethal: fully armed and ornate. Every hidden door and hatch is open and bristling: gas hoses hissing, many tiny guns, laser emitters with red beams, and syringes on jointed arms everywhere. Harsh red beacon light, searchlight white, the badge emblem glowing red.

Use the attached K9 UNIT moods picture as the reference for style, detail and how far the hatches open in each mood. Rules for every image: PNG, TRANSPARENT background (no hall, no floor, no sky; only the machine and the ledge), 1024 × 1024. The ICE stands on, rolls on, or hovers just above a horizontal ledge along the bottom edge of the image, three-quarters view, in the left two-thirds of the image, the top of the machine about 60 px below the top edge. NO text, letters, numbers or logos anywhere (the badge has no writing). Exact file name.

Make these ONE AT A TIME, in this order (cheery, then wary, then lethal for each). After each image, wait until I type "next".

1–3. DISPATCH_cheery / _wary / _lethal.png — TUMBLER. A radio switchboard with a rotating dial and a standing microphone, cables everywhere. Face: the big dial with two indicator lamps.
4–6. SHOCK_TROOPER_cheery / _wary / _lethal.png — VOID. A tall riot shield walking on short tracked legs, and floating just above and behind it an empty chrome helmet with a visor, no person inside. Face: the glowing visor slit. Stinger: a stun baton that swings out from behind the shield.
7–9. OVERWATCH_cheery / _wary / _lethal.png — VOID. IRONWATCH's central intelligence and its largest ICE: the stepped ziggurat clock tower itself, crowned with a ring of searchlights around one great lens, the searchlight-fan badge above. Face: the crown lens. Lethal: every searchlight swings onto the viewer and the tower's facade opens into hundreds of hatches.
10–12. ROADBLOCK_cheery / _wary / _lethal.png — FORTRESS. A striped concrete-and-steel barrier on tank treads that rolls into place, hazard lamps on top. Face: twin hazard lamps and a grille.
13–15. SPIKE_STRIP_cheery / _wary / _lethal.png — TUMBLER. A rotating drum on a wheeled frame that unrolls a coiled chain of spikes across the road. Face: the drum hub with two rivet eyes.
16–18. SEARCHLIGHT_cheery / _wary / _lethal.png — VOID. A tall ornate street lamp whose head is one huge searchlight on a jointed neck. Face: the lamp's lens. Stinger: the beam itself.
19–21. PURSUIT_DRONE_cheery / _wary / _lethal.png — VOID. A finned rocket-bike drone with a siren dome, low and fast, exhaust flame. Face: the siren bubble as one eye. Stinger: a grappling claw.
22. LETHAL_FORCE_lethal.png — VOID, Black ICE, ONE image only, always lethal. A tall officer's long navy coat and peaked cap with NOTHING inside: no face, just a glowing red visor slit floating under the cap, the coat opening on a frame of chrome with every hatch open and bristling with syringes, gun barrels and laser emitters.

Reply "ready" and then make image 1.
```
