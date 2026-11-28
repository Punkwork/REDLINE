extends SceneTree
## CRED-COST-001 (designer 2026-11-27): the V2 card face shows a CRED chip beside the BW medallion on
## cards with a CRED cost. Writes cred_cost_cards.png to SHOT_DIR (BORROWED CREDENTIALS beside PROBE,
## 2x, through the real VisibleStateAdapter) and checks the models.

var passed := 0
var failed := 0

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	root.size = Vector2i(1600, 1000)   # the V2 fixtures' size; the image is cropped to the cards below
	var bg := ColorRect.new(); bg.color = Color("#1E2A2A"); bg.size = Vector2(1600, 1000); root.add_child(bg)
	var g := Game.new(1)
	g.new_run("ECHO")
	var x := 30.0
	for id in ["BORROWED_CREDENTIALS", "PROBE"]:
		var inst: Dictionary = g._new_inst(id)
		var m: Dictionary = VisibleStateAdapter.card_model(g, inst, "pick")
		check(int(m.cred) == (8 if id == "BORROWED_CREDENTIALS" else 0), "%s model CRED cost %d" % [id, int(m.cred)])
		check(not String(m.text).contains("CRED"), "%s text does not repeat a CRED cost" % id)
		var cv := CardView.new()
		cv.position = Vector2(x, 30)
		root.add_child(cv)
		cv.size = CardView.BASE
		cv.scale = Vector2(2, 2)
		cv.set_model(m)
		x += CardView.BASE.x * 2.0 + 40
	for i in 6: await process_frame
	var dir := OS.get_environment("SHOT_DIR")
	if dir != "":
		var img := root.get_texture().get_image()
		var sx := float(img.get_width()) / 1600.0
		img = img.get_region(Rect2i(0, 0, int(660 * sx), int(510 * sx)))
		img.save_png(dir.path_join("cred_cost_cards.png"))
		print("CRED-COST-001: 1 screenshot written to ", dir)
	print("CRED COST: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))
