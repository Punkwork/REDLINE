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
