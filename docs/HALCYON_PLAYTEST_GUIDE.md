# PANOPTICON — HALCYON slice playtest

This is a development playtest build, not the complete three-corporation game.

## Get and run the Windows build

On GitHub, open **Actions → Godot validation and Windows playtest build**, open a
successful **push** run for the stabilization branch, and download the artifact
**PANOPTICON-HALCYON-Windows-x86_64** at the bottom of the run page (sign-in may be
required). Extract the ZIP, then run `PANOPTICON_HALCYON_slice.exe`. The resources
are embedded; keep this guide and the checklist for recording results. No Godot
editor installation is needed. The build is unsigned; a Windows launch has not
been validated in the Linux build environment.

The run's source revision is shown on its Actions page. Record that commit with
your feedback. Local export: use Godot 4.3 with its matching export templates,
then `godot --headless --path godot --export-release "Windows Desktop"` from the
repository root. The configured output is `build/PANOPTICON_HALCYON_slice.exe`.

## First checks

1. Select VECTOR, enter COOKIE BANNER, and choose an ICE for PATIENT ZERO.
   Only then should normal card actions be available.
2. Read card effects, target ICE, play cards, and end a turn. Look for readable
   response order, accurate costs, and an explanation of BOOTING restrictions.
3. When a hand exceeds the visible row, scroll over the cards or drag the
   horizontal scrollbar. Every card should remain reachable and clickable;
   END TURN, END RUN, and the pile counters must stay unobstructed.
4. Try GENERALIST, ECHO, and RIOT as well. Record confusing behavior, blocked
   progress, crashes, and mismatches with card text before suggesting balance.
5. Complete the applicable entries in `REDLINE_PLAYTEST_CHECKLIST.md`.

## Checklist scope

The existing checklist describes the full planned game. This slice implements
HALCYON, four Rustlers, four map rows, card rewards, Safehouse healing, and the
encounter rules in the current code. It does **not** implement other corporations,
a complete Central Node/escape heist, Uplinks/shop purchases, CAPS, PATCHWORK,
Signal Unclear events, payload Ghostware selection, or Copy summary to clipboard.
Mark checks for those features **N/A — outside this slice**, not passed or failed.
The long-run economy and corporation-duration targets cannot be judged from this
short slice. Keep the original checklist unchanged as the full-game reference.

For each issue record:
- Branch/commit, Rustler, Node/layer/turn, and cards or ICE involved.
- Action taken, actual result, expected result, and a screenshot if useful.
- Whether it reproduced after restarting; include the seed if one is available.

## Verification boundary

Automated rule checks and screenshot scripts are evidence of those specific
checks, not completion of the 61-item live checklist or proof of balance. A bot
that dies can still satisfy the current full-run termination check. Balance and
open design choices remain the designer's decisions. Windows runtime, audio,
readability, usability, and subjective difficulty require a live playtest.
