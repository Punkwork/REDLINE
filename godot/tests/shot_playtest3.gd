extends SceneTree
## Controlled fixtures for the new UI; these do not change production decks or ICE.
var main: Node
var failures := 0
func _initialize() -> void: call_deferred("_run")
func check(ok: bool, message: String) -> void:
 if not ok:
  failures += 1
  push_error(message)
func snap(name: String) -> void:
 main.refresh()
 for i in 15: await process_frame
 await RenderingServer.frame_post_draw
 check(root.get_texture().get_image().save_png(OS.get_environment("SHOT_DIR").path_join(name + ".png")) == OK, "save " + name)
 print("shot ", name)
func _run() -> void:
 main = load("res://scenes/Main.tscn").instantiate(); root.add_child(main)
 await snap("playtest3_select")
 main._start_as("ECHO")
 var g: Game = main.g
 g.enter_node(0)
 main.deck_open = true
 await snap("playtest3_deck_analysis")
 main.deck_open = false
 g.end_turn()
 check(g.pending.get("kind") == "hold", "HOLD UI opens")
 await snap("playtest3_hold")
 g.choose(-1)
 # SCAN fixture: model choice and UI rendered together.
 g.hand.clear(); g.bw = 30
 var scan := g._new_inst("PORT_SCAN"); g.hand.append(scan); g.play_card(scan.uid)
 await snap("playtest3_scan")
 g.finish_scan()
 g.enc.ice[0].str_mod = -10
 g.hand.clear()
 var c := g._new_inst("CULL"); g.hand.append(c); g.infect(0, "ROT", 3); g.infect(0, "LEECH", 2); g.play_card(c.uid, 0)
 await snap("playtest3_cull_underflow")
 g.cull_strain("ROT"); g.cull_strain()
 g.phase = "REWARD"; g.layers_cleared = 1; g.reward_options = ["SCALPEL", "WARM_BOOT", "COVER_FIRE"]
 await snap("playtest3_reward_roles")
 g.begin_decompile()
 await snap("playtest3_decompile")
 g.phase = "SAFEHOUSE"; main.compile_open = true; main.compile_first = -1
 await snap("playtest3_compile")
 main.compile_open = false
 var definition := {"name": "PACE TEST FIXTURE", "tier": "TEST", "type": "FORTRESS", "str": 0, "subs": [[{"k": "DEADLOCK", "v": 2}], [{"k": "TRACE", "v": 1, "escalate": true}]]}
 g.phase = "PLAYER"; g.enc.ice.assign([g._new_ice("COOKIE_WALL", definition)]); g.enc.ice[0].seen.fill(true)
 g._do_break(0, 0)
 await snap("playtest3_deadlock_escalate")
 print("PLAYTEST 3 UI: %d failures" % failures)
 main.queue_free()
 for i in 15: await process_frame
 quit(1 if failures else 0)
