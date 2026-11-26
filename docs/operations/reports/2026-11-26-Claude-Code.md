# Daily agent report

Date (Toronto): 2026-11-26
Agent: Claude Code
Session time: 11:11–11:30 UTC
Branch / commit: `architecture-v2`, inventory taken at `fc2923b` (this report travels in the next commit).
Branch drift (heads of architecture-v2, main, release; main = prototype-baseline?): `architecture-v2` `fc2923b`; `main` `21922ad` = `prototype-baseline` `21922ad` (unchanged); `release` `2845ecd` (unchanged).
Work completed: Authorized functional/runtime inventory for the representative ICE encounter (ARCH-V2-001 / CAS-001 / VAS-001 / OPS-001; [#21](https://github.com/Punkwork/REDLINE/issues/21), [#24](https://github.com/Punkwork/REDLINE/issues/24)). Baseline tests rerun on `architecture-v2`, live encounter run and captured, C01–C18 classified, first implementation batch proposed below. **No production code changed.**
Surprises: (1) `Game.response_preview()` returns full `effects` for steps flagged `hidden`; the legacy UI only hides them visually, so the new adapter must strip them. (2) CI's whole screenshot stage exits early while `CORE_LOOP` is true, so **no** current encounter visual or input is validated by CI. (3) Two genuine visual-direction conflicts between VAS-001 and earlier approved decisions (see "Designer decisions").
Missing tools: none. Godot 4.3-stable (`77dcf97d8`) Linux editor, Xvfb + Mesa llvmpipe (GL Compatibility, opengl3) available in the session.
PR activity: none.
To-dos: [#21](https://github.com/Punkwork/REDLINE/issues/21) representative encounter; [#24](https://github.com/Punkwork/REDLINE/issues/24) typography and motion.
Blockers / unverified results: Batch 1 waits on designer approval and the three decisions below. Not verified: Windows runtime, real-GPU rendering (captures are software GL), audio, and response interruption semantics (CAS-001 C03; not exercised).
Recommended priorities: Approve Batch 1 (C07–C09 + C02/C04/C18 slices + phase flyout), resolve D1–D3; Codex's visual inventory supplies the ICE window frame decision and asset gaps.

---

## 1. Verified runtime evidence (this session)

| Check | Command | Result |
|---|---|---|
| Import | `--headless --editor --import --quit` | exit 0 |
| Rules | `test_game.gd` | **176 passed / 0 failed** (runs `test_core_loop.gd` inside; that file is a module, not a standalone script) |
| Rules + bots | `SIM=1 test_game.gd` | 176 / 0, exit 0; GENERALIST 1/30 cleared, deaths CAPTCHA 16, TERMS & CONDITIONS 13 |
| ADP | `test_adp.gd` | 17 checks / 0 failures |
| SIGNAL / CARBON | `test_signal_carbon.gd` | 672 checks / 0 failures |
| Error scan | grep `SCRIPT ERROR|Parse Error|Assertion failed` over all logs | 0 |
| Live encounter | scratch script (not committed), Xvfb 1600×1100, seed 711, N2A, READY RIG = first PROGRAM | `PLAYER`, ICE `[AUTO_RENEW, CAPTCHA]`, STR 7 / 6, CAPTCHA active `[0,1]`, hidden 4; END TURN → response resolved, VITAE 30→23, CAPTCHA rotated to `[1,2]`, phase `CHOICE` (DISCARD 1) |
| VAS-001 reference | PIL + `sha256sum` + `git hash-object` | 1536×864 RGB; blob `c58828b9…` matches VAS-001 §0; **SHA-256 `513af903705b6810e3de86e14674e0be19387866432c76e9b3e3d366bb0df25e`** (was pending) |

Matches the `prototype-baseline` record exactly. Captures of the current prototype path: [`proto_n2a_turn1.jpg`](../../visual/fixtures/arch-v2-inv-001/proto_n2a_turn1.jpg), [`proto_n2a_turn2.jpg`](../../visual/fixtures/arch-v2-inv-001/proto_n2a_turn2.jpg) (the generic dark DISCARD modal is the clearest current gap against VAS-001).

## 2. Verified call graph (real signatures)

- **Break, click / keyboard:** `IceKey` (draw only) ← `FriendlyDropTarget._gui_input` → `FriendlyEncounter.break_action(i, sub)` → `break_info` picks the CRT program, else cheapest Icepick → `main._on_break(i, s, pick_uid)` → `Game.break_sub(i, s, pick_uid) -> bool` → `main.refresh()`.
- **Break, drag:** `FriendlyDropTarget._drop_data` → `Game.break_sub(i, sub, data.uid)` **directly** → `view.ui.refresh()`. Two dispatch paths, one Game call each (CAS-001 C02 concern confirmed). Both resolve the ICE index via `enc.ice.find(ice_ref)` (`is_same` dictionary identity) at drop time and reject `-1`.
- **Card on ICE:** click `main._on_card` → targeting → `_on_ice_clicked` → `play_seated_card(uid, i)` → `Game.play_card(uid, target) -> bool`; drop on ICE goes through the same `play_seated_card`.
- **CARD_BREAK / PATIENT_ZERO choices** route through the same key/ICE clicks (`Game.choose_sub`, `Game.choose_ice`).
- **Response:** `main._on_end_turn` → `Game.end_turn()`; if phase `RESPONSE`, `main._play_response()` awaits timers and calls `Game.response_step()` once per queued step, then `Game.response_finish()` once. With reduced motion only the reel spin is skipped; the step timers still run.
- **Visible events:** `Game.events` (`[{t: "EV-xx", …}]`) is drained by `main._handle_events()` each refresh; 26 emitters in `game.gd` (EV-01…EV-35, `ICE_LETHAL`, `PARTING_SHOT`, `PUNCH_CARD`, `SLICE_DONE`). This is the existing, rules-owned source for flyouts; no new rules hooks are needed for phase/break/strike/breach announcements, but `main` currently **consumes and clears** them, so a second consumer must read before the clear.
- **ICE identity:** no persistent ICE ID; identity is the `enc.ice[i]` dictionary reference. TUMBLER rotation mutates `ice.rot` in place (identity survives); `_add_black_ice` appends; new encounter replaces `enc` (epoch = `is_same(enc, last_enc)`).
- **Pending choice variants (C15 scope):** `discard`, `card_break`, `cache`, `burn_hand`, `cull`, `field_kit`, `retrieve`, `scan`, `uninstaller`, `patient_zero`, `ready_rig`.

## 3. CAS-001 C01–C18 inventory

Classification: **Reuse** as is · **Adapt** wrap or move existing code · **Complete** partial today · **Build** new · **Validate** needs evidence only.

| ID | Existing source | Status today | Class | Notes |
|---|---|---|---|---|
| C01 AppShell | `Main.tscn`, `main.gd` (2,037 lines) | Works; also owns response timing, HUD and overlays | **Reuse** (untouched in first batches) | Mounting point only, later |
| C02 EncounterController | split across `main._on_card/_on_break/_on_end_turn`, `encounter.break_action/click_ice`, `drop_target._drop_data` | Two break paths, one Game call each | **Build** (thin typed class) | One intent → one Game call; epoch and `is_same` stale check |
| C03 ResponseSequencer | `main._play_response` | Correct exactly-once; interruption untested | **Adapt** (batch 3) | Port the loop, keep the step/finish contract |
| C04 VisibleStateAdapter | none (widgets query Game) | — | **Build** (ICE slice first) | Must drop `effects` of hidden steps; display model only |
| C05 EncounterScreen | `FriendlyEncounter` (1,974 lines) | Works; monolith | **Build** (batch 4 integration); sandbox in batch 1 | Legacy stays as comparison path |
| C06 CorporationPresentation | `CorporationSkin` (28 lines), `themes/*.tres`, console tint shader | Works | **Adapt** (batch 4) | Second skin later |
| C07 ICELane | `encounter.build_ice` (rebuilds all every refresh) | Rebuild, not reconcile | **Build** | Reconcile children by ICE ref; 1/2/3 ICE |
| C08 ICEPanel | inline in `build_ice`, `scan_tag`, `console_heading`; `FriendlyMascot` (370 lines) | Works, entangled | **Build** + **Reuse** mascot | Mascot + painted console reused as layers |
| C09 SubroutineRow | `IceKey` (296 lines, draw-only, 0 Game reads) + `key_wrapper` + `FriendlyDropTarget` | Leaf is clean | **Adapt** (wrap `IceKey`) | States: enabled/blocked/breakable/broken/selected/hidden/deadlock |
| C10 HandView | `FriendlyHand` (67 lines, 0 Game reads) | Clean | **Reuse** (batch 2) | |
| C11 CardView | `FriendlyCard` (890 lines, 12 Game reads) | Works | **Adapt** (batch 2) | Inject legality instead of reading Game |
| C12 RigView | `FriendlyProgramBay` (27 lines), `build_rig`, cartridges | Works | **Adapt** (batch 2) | |
| C13 PlayerHUD | `build_instruments`, `vital_row`, `build_trace_plate`, `build_node_plate` | Works | **Adapt** (batch 3) | |
| C14 ResponseQueue/Log | per-ICE NEXT RESPONSE plate, `log_text` | Works; differs from VAS-001 rail | **Build** (batch 3) after D2 | |
| C15 ChoiceOverlay | `main._overlay_options` | Works; generic dark modal (not VAS) | **Build** (batch 2) | All 11 variants |
| C16 Target/Inspect/Settings | `key_tip`, `obj_tip`, `_show_inspect`, motion button | Works | **Adapt** (batches 1–3) | Key tip moves with C09 |
| C17 Map/Reward/Event | `main._overlay_*` | Works | **Out of slice** | |
| C18 PresentationResources | `FriendlyLook`, `analog.gd`, fonts, `assets/concept/ui/*` (UI kit 1–3) | Tokens scattered in constants | **Build** (VAS tokens + Theme) / **Reuse** assets | 13 licensed families incl. Barlow Condensed, Poiret One, Special Elite, Stardos Stencil |
| M06 flyouts | none (only strike overlay, toasts, punch arrival) | — | **Build** | Driven by `Game.events` + phase changes |
| Tests | `test_game/adp/signal_carbon`; 16 `shot_*.gd` | Rules covered; **all fixtures skipped in CI** | **Build** arch-v2 tests outside the skip | |

## 4. Representative encounter (proposed)

**N2A "CAPTCHA": AUTO-RENEW (FORTRESS, STR 7, 5 subs) + CAPTCHA (TUMBLER, STR 6, 2 slots of 6), reserve 15.** Same pairing as the left of the VAS-001 mockup, painted mascots for both already in `assets/concept/mascots/`, and the bots' deadliest node (16/30 deaths). It exercises DEADLOCK ×2, HARDEN, a two-effect subroutine (PULP 2 + BW_DRAIN), TRACE→DISCARD riders, TUMBLER rotation with face-down subs, CHOICE (discard) after the response, BREACH and parting shot. Not covered: VOID reveal (DOORBELL CAM), and that's acceptable for a first slice. Parity fixture: seed 711, GENERALIST, READY RIG FORTRESS ICEPICK, scripted action list compared against direct `Game` calls on a twin seeded instance.

## 5. Proposed Batch 1: ICE/subroutine interaction (C07–C09 + essential C02/C04/C18 + phase flyout)

**Goal:** a launchable sandbox scene, at the VAS-001 1536×864 reference composition, with the real N2A encounter in a VAS-styled ICE well, where a player can click, keyboard-activate and drag-break subroutines, end the turn and watch the response resolve on the same panels, with a Tier 2 phase flyout. Cards, HUD rail and choice modal follow in batches 2–3 per the approved sequence.

| File (new unless noted) | CAS | Owner |
|---|---|---|
| `godot/scripts/ui/architecture_v2/encounter_controller.gd` | C02: `break_sub`, `end_turn`, step/finish passthrough; stale-epoch/ref rejection | Claude Code |
| `godot/scripts/ui/architecture_v2/visible_state_adapter.gd` | C04: ICE display models (name, type, STR, active slots, per-row state, hidden rows carry no effects) | Claude Code |
| `godot/scenes/architecture_v2/ICELane.tscn` + `scripts/…/ice_lane.gd` | C07: reconcile by ICE ref; 1/2/3 ICE | Claude Code |
| `godot/scenes/architecture_v2/ICEPanel.tscn` + `scripts/…/ice_panel.gd` | C08: seafoam window, mascot layer (`FriendlyMascot` reused), name/class/STR plaques, rows | Claude Code |
| `godot/scenes/architecture_v2/SubroutineRow.tscn` + `scripts/…/subroutine_row.gd` | C09: slot no., lamp, label face (`IceKey` reused), hover/focus tip; one intent signal for click, Enter, drop | Claude Code |
| `godot/scenes/architecture_v2/PhaseFlyout.tscn` + `scripts/…/phase_flyout.gd` | M06 Tier 2: RUSTLER TURN / CORPORATION RESPONSE, refined treatment, see-through, ≤1.5 s, reduced-motion static variant | Claude Code (treatment for review) |
| `godot/themes/architecture_v2/vas001.tres` + `scripts/…/vas_tokens.gd` | C18: VAS-001 §5 palette, type scale, semantic colour roles | Claude Code |
| `godot/scenes/architecture_v2/IceEncounterSandbox.tscn` + script | Dev harness: real `Game`, N2A, ICE well + END TURN; not the app entry | Claude Code |
| `godot/tests/test_arch_v2_ice.gd` | Click/Enter/drop vs direct-Game parity (state + log + BW), stale ref, TUMBLER rotation identity, hidden-effect stripping, response exactly-once with reduced motion on/off | Claude Code |
| `godot/tests/shot_arch_v2_ice.gd` | 1536×864, 1600×1000, 1366×768, 1920×1080; normal/hover/focus/drag-valid/drag-invalid/broken/deadlock/hidden; flyout mid-hold; side-by-side with the VAS reference | Claude Code |
| `.github/workflows/godot-validation.yml` (edit) | Run both arch-v2 scripts **before** the CORE_LOOP skip | Claude Code |

**Not touched:** `core/*`, `main.gd`, `friendly_lie/*`, `Main.tscn`, `project.godot`. **Codex (per its visual inventory):** new modular art in `godot/assets/architecture_v2/{ice,chassis,fx}/` and isolated visual fixture tasks; batch 1 uses existing `UI_ICE_CONSOLE_2` and mascot PNGs until Codex art lands, swapped by file name only.

**Acceptance:** all existing suites unchanged (176/17/672); new tests pass in CI; parity identical for every scripted action; no hidden effect text reachable in the adapter output; screenshots at four sizes with the VAS side-by-side; flyout never longer than 1.5 s, text underneath remains readable (UI-TYPO-001a), static under reduced motion; ≥4.5:1 contrast on row labels measured from captures.

**Later batches (for planning only):** 2 cards/hand/rig/choice (C10–C12, C15), 3 HUD rail, response rail, sequencer (C13, C14, C03), 4 completion + EncounterScreen integration + corporation profile (C05, C06), then RELEASE-002c comparison.

## 6. Designer decisions

- **D1 · Subroutine face.** VAS-001 shows text enamel rows (`S1 ● PULP 1`); ICE-ANALOG-001 (approved) made subroutines icon + value with full text on hover. *Proposal:* the VAS row layout (slot number, lamp, enamel strip) with the ICE-ANALOG icon + value as the strip face and full text on hover/focus. Keeps both approvals; needs a yes.
- **D2 · Response display.** VAS-001 shows one shared NEXT RESPONSE rail under the ICE; ENC-CONCEPT-001 replaced the shared strip with per-ICE plates. *Proposal:* the VAS-001 shared rail (later direction). Affects batch 3 and the ICE panel's bottom edge in batch 1.
- **D3 · Reference canvas.** Author at 1536×864 inside a scaled container in the existing 1600×1000 project, with no project-setting change. Confirm, or approve a resolution change separately.

**Interpretations to confirm (I'll proceed on these unless told otherwise):** flyout copy "RUSTLER TURN" (game term; the mockup's "RUNNER TURN" predates it) and "CORPORATION RESPONSE"; the sandbox scene is a dev harness reachable only from tests and the editor.

---

## Session 2: ARCH-V2-003 Batch 1 built (Claude Code)

Date (Toronto): 2026-11-26 07:47 onward
Branch / commit: `architecture-v2`; `0ae151b` (decision record), `1e07d20` (components), `8017aad` (tests, CI), plus the evidence/records commit carrying this entry.
Branch drift: `main` = `prototype-baseline` = `21922ad`; `release` = `2845ecd`; no upstream commits arrived during the session.
Work completed: Designer approved Batch 1 in principle with UI alignment requirements (Master Design ARCH-V2-003). Built C02, C04, C07, C08, C09, C18, KeyInspector, the provisional shared NEXT RESPONSE rail, the reusable EventFlyout and a playable N2A sandbox (`godot/scenes/architecture_v2/IceEncounterSandbox.tscn`; open in the editor with F6). Main.tscn, the rules engine, the legacy encounter and project settings are untouched.
Test evidence: import 0; `test_game.gd` 176/0 (SIM=1 176/0); `test_adp.gd` 17/0; `test_signal_carbon.gd` 672/0; `test_arch_v2_ice.gd` **124/0**; `shot_arch_v2_ice.gd` 19 captures, 0 script errors. Selected captures: [`docs/visual/fixtures/arch-v2-batch1/`](../../visual/fixtures/arch-v2-batch1/README.md).
Surprises: (1) Godot 4.3 segfaults when a method containing `await` returns without awaiting in some call paths (`IcePanel.set_model`); the await was removed. (2) Freeing a panel together with its inspector crashed through focus-exit signals during teardown; guarded. (3) Under software GL the real-time flyout finished before the first capture; fixtures now use `EventFlyout.hold_at()`.
Missing tools: none. CI's new screenshot step installs Xvfb if the runner lacks it; the first CI run on these commits is the check.
Blockers / unverified: Windows runtime; real-GPU rendering; CI run result pending at commit time. Cards, choice overlay, HUD and response interruption (C03) are Batches 2–3; the sandbox's hand/rig/choice widgets are labelled DEV stand-ins.
Decisions genuinely needing the designer: none blocking. Interpretations to confirm are in HANDOFF (hover wording for type/STR, amber firing ring, dimmed fired rail steps, vertical centring at three ICE).
Coordination (ARCH-V2-003 i): geometry and icons are provisional in `godot/themes/architecture_v2/ice_panel_layout.tres` (zones, sizes, `type_icons`, `str_icon`, `console_texture`, `portrait_frame_texture`) and `VasTokens` (palette, flyout colours/timing). Codex art lands by assigning textures there, with no code change; ChatGPT/Codex reference updates should be posted on [#21](https://github.com/Punkwork/REDLINE/issues/21) before geometry is locked.
Recommended priorities: designer review of the captures against VAS-001; Codex visual fixture work against these components; then Batch 2 (C10–C12 hand/cards/rig, C15 choice overlay).
