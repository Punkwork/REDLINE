extends "res://tests/shot_adp.gd"

const FACADE := preload("res://tests/shot_facade.gd")

func capture(name: String) -> void:
 await settle()
 check(root.get_texture().get_image().save_png(OS.get_environment("SHOT_DIR").path_join(name + ".png")) == OK, name)

func run() -> void:
 main = load("res://scenes/Main.tscn").instantiate()
 root.add_child(main)
 main.voice_on = false
 view = main.friendly
 var previous := LocalRecord.read(PlayProfile.PATH)
 check(LocalRecord.write(PlayProfile.PATH, {"plays": {"PULP_SHIELD": 4}, "runs": 3, "hover": 7}), "write local profile")
 check(PlayProfile.ad("HALCYON", true).text.contains("7 seconds"), "ad uses the local record")
 check(PlayProfile.ad("HALCYON", false).is_empty(), "ads switch off")
 main.personalized_ads = true
 main._show_newsreel("GENERALIST")
 await capture("adp-profile-ad")
 var halcyon := main
 root.remove_child(halcyon)
 main = load("res://scenes/Main.tscn").instantiate()
 main.friendly_skin = FriendlyLook.skin("LUCIDA")
 root.add_child(main)
 main.voice_on = false
 main.personalized_ads = false
 var g := start()
 g.corporation = "LUCIDA"
 var opening: Dictionary = FACADE.OPENINGS.LUCIDA
 g.node = {"id": "INTAKE", "name": opening.name, "layers": [{}]}
 g.enc.ice.clear()
 for ice in opening.ice:
  g.enc.ice.append(g._new_ice(ice[0], ice[1]))
 g._mark_seen()
 g._say("Rule 6")
 var rule_index := g.log.size() - 1
 check(not g.rewrite_flavour(rule_index, "Quiet"), "rules are guarded")
 g._do_break(0, 0)
 var flavour_index := g.log.size() - 1
 g._update_lucida_record()
 check(g.log[flavour_index] == "You disturbed the quiet.", "original is visible immediately")
 g.enc.turn += 2
 g._update_lucida_record()
 check(g.log[flavour_index] == "✎ You rested here." and g.log[rule_index] == "Rule 6", "only flavour is edited")
 main.refresh()
 await capture("adp-lucida-record")
 root.remove_child(main)
 main.queue_free()
 main = halcyon
 root.add_child(main)
 view = main.friendly
 g = start()
 g._do_break(1, 0)
 var inst := g._new_inst("PULP_SHIELD")
 var duplicate := g._new_inst("PULP_SHIELD")
 g.run_deck.append_array([inst, duplicate])
 g.hand.append_array([inst, duplicate])
 check(g.attach_patchwork_graft(inst.uid) == "CAPTCHA", "broken ICE supplies a graft")
 var restored: Array = JSON.parse_string(JSON.stringify(g.run_deck))
 check(g._find(restored, inst.uid).get("graft") == "CAPTCHA", "graft survives serialization")
 check(not duplicate.has("graft"), "graft stays on its instance")
 main.refresh()
 var card := FriendlyCard.new()
 card.setup(view, inst.id, inst.uid)
 check(is_instance_valid(card.find_child("CAPTCHA", true, false)), "graft is in the art area")
 card.free()
 main.toggle_card_inspection(inst.id, inst.uid)
 await capture("adp-grafted-card")
 check(LocalRecord.erase(PlayProfile.PATH) and PlayProfile.ad("HALCYON", true).is_empty(), "delete clears ad history")
 if not previous.is_empty(): LocalRecord.write(PlayProfile.PATH, previous)
 main.queue_free()
 await settle()
 print("ADP PHASE 3: %d checks, %d failures" % [checks, failures])
 quit(int(failures > 0))
