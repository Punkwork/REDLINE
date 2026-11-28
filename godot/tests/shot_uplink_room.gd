extends SceneTree
## UPLINK-SPEC-001: first captures of the Black Market Uplink room for designer review, to SHOT_DIR:
##   uplink_01_room        stocked shelf, CRED 150, one card already bought (SOLD), 2 CORTEX
##   uplink_02_card_hover  the card inspector on an offer
##   uplink_03_clinic      the Clinic dialog
var out := ""
var shots := 0

func _initialize() -> void:
	call_deferred("run")

func frames(n := 5) -> void:
	for i in n: await process_frame
	await RenderingServer.frame_post_draw

func shot(name: String) -> void:
	await frames()
	if out == "": return
	root.get_texture().get_image().save_png(out.path_join(name + ".png"))
	shots += 1
	print("shot ", name)

func run() -> void:
	out = OS.get_environment("SHOT_DIR")
	root.size = Vector2i(1600, 1000)
	var g := Game.new(21)
	g.new_run("GENERALIST")
	g.use_generated_map(0)
	for ri in g.map_rows.size():
		for i in g.map_rows[ri].size():
			if g.phase == "MAP" and g.map_rows[ri][i].kind == "UPLINK":
				g.row = ri - 1; g.available = [i]; g.enter_node(i)
	g.cred = 190
	g.cortex = 2
	var room := UplinkRoom.new()
	root.add_child(room)
	await frames()
	room.attach(g)
	room._buy_card(2)
	room.flash_t = 0.0; room.register.glow = 0.0
	room.refresh()
	await shot("uplink_01_room")
	var cv: Control = room.card_views[5]
	cv.grab_focus()
	room.inspector.advance(0.5)
	await shot("uplink_02_card_hover")
	cv.release_focus(); room.inspector.clear()
	room._open_clinic()
	await shot("uplink_03_clinic")
	print("UPLINK ROOM screenshots: %d written" % shots)
	quit()
