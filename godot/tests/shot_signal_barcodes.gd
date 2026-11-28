extends SceneTree
## SIGNAL-002 screenshot fixture (PROPOSED art, for the designer's UI issue): the three Signal barcodes, how they
## overlay into the Signal, their sizes in the holder and the eye hover, and the V2 eye hover with 0, 1 and 3 held.
## Writes PNGs to $SHOT_DIR (default user://shots).

var out := "user://shots"
var shots := 0
var checks := 0
var failures := 0

func check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	call_deferred("run")

func settle(n := 8) -> void:
	for i in n: await process_frame
	await RenderingServer.frame_post_draw

func shot(name: String) -> void:
	await settle()
	var img := root.get_texture().get_image()
	img.save_png(out.path_join(name + ".png"))
	print("shot %s %dx%d" % [name, img.get_width(), img.get_height()])
	shots += 1

func label(text: String, size := 16) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", FriendlyLook.PAPER)
	return l

func strip(layers: Array, sz: Vector2, stock := true) -> PunchStock:
	var c := PunchStock.new(layers, stock)
	c.custom_minimum_size = sz
	c.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	return c

func run() -> void:
	if OS.get_environment("SHOT_DIR") != "": out = OS.get_environment("SHOT_DIR")
	DirAccess.make_dir_recursive_absolute(out)
	root.size = Vector2i(1600, 1000)
	# 1. The sheet: each barcode, the overlays, and the in-game sizes.
	var bg := ColorRect.new(); bg.color = FriendlyLook.TONER; bg.size = Vector2(1600, 1000); root.add_child(bg)
	var col := VBoxContainer.new(); col.position = Vector2(40, 30); col.add_theme_constant_override("separation", 14)
	root.add_child(col)
	col.add_child(label("SIGNAL-002 — Signal barcodes (PROPOSED art). One per corporation; overlaid, the three form the Signal.", 20))
	var row1 := HBoxContainer.new(); row1.add_theme_constant_override("separation", 24); col.add_child(row1)
	for corp in SignalCards.ORDER:
		var v := VBoxContainer.new(); v.add_child(label(corp)); v.add_child(strip([corp], Vector2(300, 160))); row1.add_child(v)
	var ve := VBoxContainer.new(); ve.add_child(label("empty slot")); ve.add_child(strip([], Vector2(300, 160))); row1.add_child(ve)
	var row2 := HBoxContainer.new(); row2.add_theme_constant_override("separation", 24); col.add_child(row2)
	for set in [["HALCYON", "IRONWATCH"], ["HALCYON", "LUCIDA"], ["IRONWATCH", "LUCIDA"], SignalCards.ORDER]:
		var v := VBoxContainer.new()
		v.add_child(label(" + ".join(set) + ("  = THE SIGNAL" if set.size() == 3 else "")))
		v.add_child(strip(set, Vector2(300, 160), false)); row2.add_child(v)
	col.add_child(label("In-game sizes: legacy holder 32×21, V2 eye hover 46×30, arrival 92×60 / 152×65", 16))
	var row3 := HBoxContainer.new(); row3.add_theme_constant_override("separation", 18); col.add_child(row3)
	for sz in [Vector2(32, 21), Vector2(46, 30), Vector2(92, 60), Vector2(152, 65)]:
		for corp in SignalCards.ORDER: row3.add_child(strip([corp], sz))
		row3.add_child(VSeparator.new())
	await shot("signal_barcodes_sheet")
	check(SignalCards.SIGNAL_BARS.all(func(b): return SignalCards.bars_for(SignalCards.ORDER).has(b)), "the three overlay into the whole Signal")
	bg.queue_free(); col.queue_free()
	await settle()
	# 2. The V2 eye hover: 0, 1 and 3 barcodes held.
	var sb: IceEncounterSandbox = load("res://scenes/architecture_v2/IceEncounterSandbox.tscn").instantiate()
	sb.instant = true
	root.add_child(sb)
	await settle()
	for held in [[], ["HALCYON"], SignalCards.ORDER]:
		sb.game.punch_cards.assign(held)
		sb.refresh()
		sb.flyout.advance(10.0)
		sb.eye._show()
		check(String(sb.eye.lines[1]).begins_with("Signal barcodes %d / 3" % held.size()), "eye hover: Signal barcodes %d / 3" % held.size())
		await shot("signal_barcodes_eye_%d" % held.size())
		sb.eye._hide()
	sb.queue_free()
	await settle()
	print("SIGNAL BARCODES: %d written, %d checks, %d failures" % [shots, checks, failures])
	quit(int(failures > 0))
