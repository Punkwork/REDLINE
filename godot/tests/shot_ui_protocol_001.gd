extends SceneTree
## UI-PROTOCOL-001 (issue #26) screenshot fixtures, written to SHOT_DIR:
##   protocol_01_empty           no active Protocols
##   protocol_02_multiple        five active Protocols (two copies of one)
##   protocol_03_overflow_top    23 active Protocols, scrolled to the top (scroll bar showing)
##   protocol_03b_overflow_end   the same, scrolled to the end
##   protocol_04_inspect         keyboard focus on an icon: the shared inspector
##   protocol_05_reset           after BREACH and the PARTING SHOT: the note is empty again
## Each full screenshot has a 4× crop of the note (`*_note.png`) beside it.

var out := ""
var shots := 0
var sb: IceEncounterSandbox

func _initialize() -> void:
	call_deferred("run")

func frames(n := 4) -> void:
	for i in n: await process_frame
	await RenderingServer.frame_post_draw

func shot(name: String) -> void:
	await frames()
	if out == "": return
	var img := root.get_texture().get_image()
	img.save_png(out.path_join(name + ".png"))
	var k := sb.stage.scale
	var r := Rect2(sb.stage.position + IceEncounterSandbox.NOTE.position * k, IceEncounterSandbox.NOTE.size * k).grow(6.0 * k.x)
	var crop := img.get_region(Rect2i(r))
	crop.resize(crop.get_width() * 4, crop.get_height() * 4, Image.INTERPOLATE_NEAREST)
	crop.save_png(out.path_join(name + "_note.png"))
	shots += 1
	print("shot ", name)

func deploy(id: String) -> void:
	var g := sb.game
	var c: Dictionary = g._new_inst(id)
	g.hand.append(c)
	g.bw = 99
	sb.ctrl.request_play(int(c.uid))

func run() -> void:
	out = OS.get_environment("SHOT_DIR")
	root.size = Vector2i(1600, 1000)
	sb = load("res://scenes/architecture_v2/IceEncounterSandbox.tscn").instantiate()
	sb.instant = true
	sb.flags_path = "user://shot_ui_protocol_flags.json"
	root.add_child(sb)
	await frames()
	var g := sb.game
	g.bw = 3
	sb.refresh()
	await shot("protocol_01_empty")
	for id in ["REACTIVE_ARMOUR", "COUNTERINTELLIGENCE", "OVERCLOCK", "REACTIVE_ARMOUR", "SURGE_PROTECTOR"]: deploy(id)
	g.bw = 3
	sb.refresh()
	await shot("protocol_02_multiple")
	var ids := ["FEEDBACK_LOOP", "SALVAGE", "ADAPTIVE_DEFENCE", "PROXY_CHAIN", "TOOLBELT", "SPAM_FILTER", "READY_STANCE"]
	for k in 18: deploy(ids[k % ids.size()])
	g.bw = 3
	sb.refresh()
	sb.protocol_note.scroll.scroll_vertical = 0
	await shot("protocol_03_overflow_top")
	sb.protocol_note.scroll.scroll_vertical = 100000
	await shot("protocol_03b_overflow_end")
	sb.protocol_note.scroll.scroll_vertical = 0
	var ic: Control = sb.protocol_note.icons[2]   # OVERCLOCK
	ic.grab_focus()
	sb.inspector.advance(0.5)
	await shot("protocol_04_inspect")
	ic.release_focus()
	sb.inspector.clear()
	# BREACH, END TURN, PARTING SHOT: the encounter ends and the Protocols expire.
	for c in g.hand.duplicate(): g.discard.append(g._take_from(g.hand, c.uid))
	for i in g.enc.ice.size():
		var subs: Array = g.ice_definition(g.enc.ice[i]).subs
		for s in subs.size():
			while not g.enc.ice[i].broken[s]: g._do_break(i, s)
	sb.ctrl.end_turn()
	var guard := 0
	while g.phase == "RESPONSE" and guard < 50:
		if sb.ctrl.response_pending(): sb.ctrl.step_response()
		else: sb.ctrl.finish_response()
		guard += 1
	sb.refresh()
	await shot("protocol_05_reset")
	print("UI-PROTOCOL-001 screenshots: %d written (%d active after the encounter)" % [shots, g.rack.size()])
	quit()
