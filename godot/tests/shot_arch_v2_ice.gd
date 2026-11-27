extends SceneTree
## ARCH-V2-003 Batch 1 screenshot fixture: the Architecture V2 ICE encounter sandbox in real states,
## at the VAS-001 reference size and the responsive sizes VAS-001 §4 lists, plus a side-by-side and
## a 50% overlay against the reference mockup. Writes PNGs to $SHOT_DIR (default user://shots).
## Not skipped under CORE_LOOP: it stages only the core-loop N2A encounter.
## Needs a display at least 2560×1440 (xvfb-run -s '-screen 0 2600x1500x24').

const REFERENCE := "res://assets/architecture_v2/references/PANOPTICON_VAS-001_reference_mockup.jpeg"
var out := ""
var sb: IceEncounterSandbox
var shots := 0

func _initialize() -> void:
	call_deferred("run")

func settle(n := 8) -> void:
	for i in n: await process_frame
	await RenderingServer.frame_post_draw

func size_to(w: int, h: int) -> void:
	root.size = Vector2i(w, h)
	await settle(6)

func shot(name: String) -> Image:
	await settle()
	var img := root.get_texture().get_image()
	img.save_png(out.path_join(name + ".png"))
	print("shot %s %dx%d" % [name, img.get_width(), img.get_height()])
	shots += 1
	return img

func fresh(reduced := false) -> void:
	if is_instance_valid(sb): sb.queue_free(); await process_frame
	sb = load("res://scenes/architecture_v2/IceEncounterSandbox.tscn").instantiate()
	sb.reduced_motion = reduced
	sb.instant = true
	root.add_child(sb)
	await settle()

func quiet() -> void:
	sb.flyout.advance(10.0)
	sb.inspector.close()

func prime() -> void:
	## Fixture only: BW to break with, and the TUMBLER Icepick installed (same as test_arch_v2_ice.gd).
	sb.game.bw = 30
	var tp := sb.game.hand.filter(func(c): return c.id == "TUMBLER_ICEPICK")
	if not tp.is_empty(): sb.ctrl.request_play(tp[0].uid)
	sb.game.bw = 30
	sb.refresh()

func speak_all() -> void:
	## Fixture only: an approved line per ICE and mood from data/adp_copy.json.
	var lines: Array = []
	var f := FileAccess.open("res://data/adp_copy.json", FileAccess.READ)
	if f:
		var d = JSON.parse_string(f.get_as_text())
		if d is Dictionary: lines = d.get("lines", [])
		elif d is Array: lines = d
	for p in sb.lane.panels():
		var said := ""
		for l in lines:
			if l is Dictionary and String(l.get("ice", "")) == String(p.model.id) and String(l.get("approval", "")) == "approved" and String(l.get("mood", "")) == String(p.model.mood):
				said = String(l.text); break
		p.say(said if said != "" else "…")

func key(i: int, s: int) -> SubroutineKey:
	return sb.lane.panel_for(sb.game.enc.ice[i]).key(s)

func run() -> void:
	out = OS.get_environment("SHOT_DIR")
	if out == "": out = ProjectSettings.globalize_path("user://shots")
	DirAccess.make_dir_recursive_absolute(out)
	await size_to(1600, 1000)
	await fresh()

	# 1. Opening: RUSTLER TURN mid-hold over the console (UI-TYPO-001a: see-through).
	sb.flyout.hold_at("rustler_turn", 0.6)
	await shot("v2_01_open_rustler_turn_1600x1000")
	# 2. Opening at rest.
	quiet()
	await shot("v2_02_open_1600x1000")
	speak_all()
	await shot("v2_02b_open_bubbles")
	for p in sb.lane.panels(): p.say("")
	# 3. Hover: AUTO-RENEW S3, a two-effect subroutine (PULP 2 + BW drain), full rule in the inspector.
	key(0, 2).mouse_entered.emit()
	await shot("v2_03_hover_multi_effect")
	sb.inspector.close()
	# 4. Keyboard focus: CAPTCHA's DEADLOCK key; the same inspector opens from focus.
	var cap: int = sb.game.active_subs(1)[1]
	key(1, cap).grab_focus()
	await shot("v2_04_focus_keyboard")
	key(1, cap).release_focus(); sb.inspector.close()
	# 5. Drag feedback: a TUMBLER Icepick held over a CAPTCHA key (legal) and over AUTO-RENEW (refused).
	prime()
	var tp: int = sb.game.installed.filter(func(p): return p.inst.id == "TUMBLER_ICEPICK")[0].inst.uid
	var payload := {"kind": "pick", "uid": tp}
	key(1, sb.game.active_subs(1)[0])._can_drop_data(Vector2.ZERO, payload)
	key(0, 0)._can_drop_data(Vector2.ZERO, payload)
	await shot("v2_05_drag_legal_and_refused")
	for p in sb.lane.panels():
		for k in p.keys(): k._drop_state = ""; k.queue_redraw()
	# 6. Breaks landed: click S4 (PULP 3), Enter on S1, drop on CAPTCHA, click DEADLOCK ×2 once.
	sb.ctrl.request_break(sb.game.enc.ice[0], 3)
	key(0, 0).grab_focus()
	var e := InputEventKey.new(); e.keycode = KEY_ENTER; e.physical_keycode = KEY_ENTER; e.pressed = true
	key(0, 0)._gui_input(e)
	key(1, sb.game.active_subs(1)[0])._drop_data(Vector2.ZERO, payload)
	sb.ctrl.request_break(sb.game.enc.ice[0], 4)
	key(0, 0).release_focus(); sb.inspector.close()
	await shot("v2_06_after_breaks")
	# 7. Corporation Response mid-step: CORP COUNTERMEASURE, the firing key lit, the rail stepping.
	sb.instant = false
	sb.step_seconds = 30.0
	sb.end_turn()   # runs until its first wait
	await settle(4)
	sb.ctrl.peek_response()
	sb.flyout.hold_at("corp_countermeasure", 0.6)
	await shot("v2_07_response_countermeasure")
	sb.flyout.advance(10.0)
	sb.ctrl.peek_response(); sb.ctrl.step_response(); sb.ctrl.peek_response()
	await shot("v2_08_response_stepping")
	# Finish the response the rest of the way (the sandbox's own loop is parked on a long timer).
	while sb.ctrl.response_pending(): sb.ctrl.step_response()
	sb.ctrl.finish_response()
	await create_timer(1.0).timeout   # let the parked sandbox loop wake and see nothing left to do
	sb.responding = false
	sb.refresh()
	sb.flyout.advance(10.0)
	# 8. Next turn: CAPTCHA rotated (new key amber), DISCARD choice from its rider.
	await shot("v2_09_next_turn_rotated")

	# 9. Three ICE: a VOID (DOORBELL CAM) with face-down keys; type badge explained.
	await fresh()
	quiet()
	sb.game.enc.ice.append(sb.game._new_ice("DOORBELL_CAM"))
	sb.refresh()
	await shot("v2_10_three_ice_void_hidden")
	# 9b. Speech bubbles (ARCH-V2-003p): approved ADP mood lines, one per ICE, in the reserved room.
	speak_all()
	await shot("v2_10b_three_ice_bubbles")
	for p in sb.lane.panels(): p.say("")
	var vpanel: IcePanel = sb.lane.panels()[2]
	vpanel.type_badge.grab_focus()
	await shot("v2_11_void_type_inspector")
	vpanel.type_badge.release_focus()
	var hidden_key: SubroutineKey = vpanel.keys().filter(func(k): return k.model.state == "hidden")[0]
	hidden_key.grab_focus()
	await shot("v2_12_hidden_key_inspector")

	# 10. Reduced motion: the flyout is a plain translucent fade in place.
	await fresh(true)
	sb.flyout.hold_at("rustler_turn", 0.6)
	await shot("v2_13_reduced_motion_flyout")

	# 10b. ARCH-V2-003u: a twelve-card hand (fixture-only stand-ins cycling the real hand), one lifted.
	await fresh()
	quiet()
	sb.hand_fan.clear()
	for k in 12:
		var c: Dictionary = sb.game.hand[k % sb.game.hand.size()]
		sb.hand_fan.add_card(sb._card_view(VisibleStateAdapter.card_model(sb.game, c, "hand")))
	sb.hand_fan.cards()[5].grab_focus()
	await shot("v2_14_twelve_card_hand")
	sb.hand_fan.cards()[5].release_focus()

	# 10d. ARCH-V2-004: hover a card (inspector shows the large card, HOVER-001), then targeting.
	await fresh()
	quiet()
	var hc: CardView = sb.hand_fan.cards()[1]
	hc.grab_focus()
	await shot("v2_16_card_hover_inspector")
	hc.release_focus()
	for cv in sb.hand_fan.cards():
		if bool(cv.model.target) and bool(cv.model.playable):
			cv.pressed.emit(cv.uid()); break
	await shot("v2_17_targeting_choose_an_ice")
	sb._pending_target = -1
	sb.refresh()

	# 10c. Optional carriage-return arrow between key rows (designer asked to see one; off by default).
	await fresh()
	quiet()
	for p in sb.lane.panels(): p.layout.row_return_arrow = true; p.set_compact(true); p.set_compact(false)
	sb.refresh()
	await shot("v2_15_row_return_arrow_option")
	for p in sb.lane.panels(): p.layout.row_return_arrow = false; p.set_compact(true); p.set_compact(false)
	sb.refresh()

	# 10d. ARCH-V2-005 header: half-width turn indicator and TRACE meter, CAPS and PROTOCOLS racks
	# (3 slots each). Empty, then four PROTOCOLs deployed through the controller (the fourth shows
	# as "+1"), with the hover panel on a filled slot. Plus a header crop for the art prompts.
	await fresh()
	quiet()
	await shot("v2_18_header_slots_empty")
	for id in ["SPAM_FILTER", "PROXY_CHAIN", "TOOLBELT", "SURGE_PROTECTOR"]:
		var c := {"uid": sb.game.next_uid, "id": id}
		sb.game.next_uid += 1
		sb.game.hand.append(c)
		sb.game.bw = 30
		sb.ctrl.request_play(int(c.uid))
	sb.game.bw = 3
	sb.refresh()
	var ps: Control = sb.protocol_rack.slots[0]
	ps.grab_focus()
	var full := await shot("v2_19_header_protocols_deployed")
	sb.inspector.close(); ps.release_focus()
	if full:
		var hdr := full.get_region(Rect2i(Vector2i.ZERO, Vector2i(full.get_width(), mini(full.get_height(), int(sb.stage.position.y + 100.0 * sb.stage.scale.y)))))
		hdr.save_png(out.path_join("v2_20_header_crop.png"))
		print("shot v2_20_header_crop")
		shots += 1

	# 10e. ARCH-V2-006 Batch 3: extraction ants on the rail ledger (frozen mid-run), the log pinned
	# from the rail, and the parting shot after a BREACH (PULP meter and END TURN hover).
	await fresh()
	quiet()
	sb.game.extract(5); sb.refresh()
	sb.ledger.set_process(false); sb.ledger.ants = 0.45; sb.ledger.queue_redraw()
	await shot("v2_21_ledger_extraction_ants")
	sb.ledger.finish()
	sb.game.log.append_array(["AUTO-RENEW renews your subscription.", "You break S1 with FORTRESS ICEPICK (1 BW)."])
	sb.toggle_log()
	await shot("v2_22_log_from_rail")
	sb.toggle_log()
	sb.game.enc.breached = true; sb.refresh()
	sb.end_key.grab_focus()
	await shot("v2_23_parting_shot")
	sb.end_key.release_focus(); sb.inspector.close()

	# 11. Responsive sizes (VAS-001 §4) and the reference comparison.
	await fresh()
	quiet()
	for s in [Vector2i(1920, 1080), Vector2i(1366, 768), Vector2i(2560, 1080)]:
		await size_to(s.x, s.y)
		await shot("v2_size_%dx%d" % [s.x, s.y])
	await size_to(1536, 864)
	var mine := await shot("v2_size_1536x864_reference")
	var ref := Image.load_from_file(ProjectSettings.globalize_path(REFERENCE))
	if ref and mine:
		mine.convert(Image.FORMAT_RGB8); ref.convert(Image.FORMAT_RGB8)
		mine.resize(ref.get_width(), ref.get_height())
		var pair := Image.create(ref.get_width() * 2, ref.get_height(), false, Image.FORMAT_RGB8)
		pair.blit_rect(ref, Rect2i(Vector2i.ZERO, ref.get_size()), Vector2i.ZERO)
		pair.blit_rect(mine, Rect2i(Vector2i.ZERO, mine.get_size()), Vector2i(ref.get_width(), 0))
		pair.save_png(out.path_join("v2_vas001_side_by_side.png"))
		var mix := ref.duplicate() as Image
		for y in mix.get_height():
			for x in mix.get_width():
				mix.set_pixel(x, y, ref.get_pixel(x, y).lerp(mine.get_pixel(x, y), 0.5))
		mix.save_png(out.path_join("v2_vas001_overlay_50.png"))
		print("shot v2_vas001_side_by_side, v2_vas001_overlay_50")
		shots += 2
	await size_to(1600, 1000)
	print("ARCH-V2 ICE screenshots: %d written to %s" % [shots, out])
	quit(0)
