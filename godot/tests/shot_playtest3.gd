extends SceneTree
## Controlled fixtures for the new UI; these do not change production decks or ICE.
var main: Node
var failures := 0
func _initialize() -> void: call_deferred("_run")
func check(ok: bool, message: String) -> void:
 if not ok:
  failures += 1
  push_error(message)
func snap(name: String, rebuild: bool = true) -> void:
 if rebuild: main.refresh()
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
 check(g.phase == "RESPONSE", "END TURN starts the response without a hand-retention prompt")
 g._continue_response()
 await snap("playtest3_turn_cleanup")
 # SCAN fixture: model choice and UI rendered together.
 g.hand.clear(); g.bw = 30
 var scan := g._new_inst("PORT_SCAN"); g.hand.append(scan); g.play_card(scan.uid)
 check(g.pending.get("kind") == "scan", "SCAN fixture actually opened")
 await snap("playtest3_scan")
 g.finish_scan()
 g.reduce_ice_str(0, 10)
 g.hand.clear()
 var c := g._new_inst("CULL"); g.hand.append(c); g.infect(0, "ROT", 3); g.infect(0, "LEECH", 2); g.play_card(c.uid, 0)
 check(g.pending.get("kind") == "cull", "CULL fixture actually opened")
 await snap("playtest3_cull_zeroed")
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
 # Authorized ZEROED and TUMBLE fixtures.
 main._start_as("RIOT"); g = main.g; g.enter_node(0); g.hand.clear(); g.bw = 40
 g.enc.ice.assign([g._new_ice("CAPTCHA")]); g._mark_seen(); g.reduce_ice_str(0, 3)
 g.installed.append({"inst": g._new_inst("PASSKEY"), "boost": 20, "free_used": false})
 var zero_card := g._new_inst("SECOND_WIND"); g.hand.append(zero_card)
 await snap("zeroed_target_highlight")
 check(g.would_zero(0, 1), "highlight fixture has eligible target")
 g.play_card(zero_card.uid, 0)
 await snap("zeroed_marker")
 check(g.enc.ice[0].zeroed, "ZEROED marker consumed")
 main._on_break(0, 0)
 check(main.find_child("TumbleMotion", true, false) != null, "tumble animation created")
 check(g.active_subs(0) == [1, 2] and g.break_info(0, 2).ok, "new sub immediately active while UI animates")
 await snap("tumble_drop_slide", false)
 for i in 60: await process_frame
 await snap("tumble_after")
 # Generalist READY RIG with deliberately overflowing PROGRAM choices.
 main._start_as("GENERALIST")
 g = main.g
 for i in 10: g.run_deck.append(g._new_inst("BASIC_EXTRACTOR"))
 g.enter_node(0)
 check(g.phase == "READY_RIG", "Generalist READY RIG opens")
 await snap("playtest3_ready_rig_horizontal")
 await check_choice_row("READY RIG")
 print("PLAYTEST 3 UI: %d failures" % failures)
 main.queue_free()
 for i in 15: await process_frame
 quit(1 if failures else 0)

func check_choice_row(label: String) -> void:
 var row: HBoxContainer = main.find_child("ChoiceCardRow", true, false)
 var scroll: ScrollContainer = main.find_child("ChoiceCardScroll", true, false)
 check(row != null and scroll != null, label + " uses a horizontal scroll row")
 if row == null or scroll == null: return
 var cards := row.get_children()
 check(cards.size() > 1, label + " has multiple cards")
 for i in range(1, cards.size()):
  check(is_equal_approx(cards[i].position.y, cards[0].position.y) and cards[i].position.x > cards[i - 1].position.x, label + " cards align horizontally")
  check(cards[i].size.y <= scroll.size.y, label + " full card height fits")
 scroll.scroll_horizontal = int(scroll.get_h_scroll_bar().max_value)
 for i in 3: await process_frame
 var last: Control = cards.back()
 check(scroll.get_global_rect().encloses(last.get_global_rect()), label + " final card accessible by horizontal scrolling")
