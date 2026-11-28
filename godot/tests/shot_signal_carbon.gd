extends "res://tests/shot_adp_phase3.gd"

func run() -> void:
 main = load("res://scenes/Main.tscn").instantiate()
 root.add_child(main)
 main.voice_on = false
 main.personalized_ads = false
 view = main.friendly
 var old_record := LocalRecord.read(CarbonRecord.PATH)
 check(LocalRecord.erase(CarbonRecord.PATH), "start with empty local record")
 var g := start()
 check(view.punch_count.text == "0/3", "empty holder")
 await capture("signal-holder-0")
 g.node = g.node.duplicate(true)
 g.node.central = true
 for i in g.enc.ice.size():
  var ice: Dictionary = g.enc.ice[i]
  var subs: Array = g.ice_definition(ice).subs
  for j in subs.size():
   if Game._has_deadlock(subs[j]): g._do_break(i, j)
 main.refresh()
 check(g.enc.breached and g.punch_cards == ["HALCYON"], "Central Node BREACH awards the card")
 check(view.punch_count.text == "1/3" and main.nr_mode.text.contains("EV-33"), "arrival updates holder and NUL/REM")
 await capture("signal-halcyon-arrival")
 view.arrival_until = 0.0
 g.restore_presentation({"punch_cards": SignalCards.ORDER})
 main.refresh()
 check(view.punch_count.text == "3/3", "full holder")
 await capture("signal-holder-3")
 main.open_punches()
 await capture("signal-barcodes")
 main.punch_open = false
 g.take_pulp(g.vitae + g.shield)
 main.refresh()
 check(g.phase == "DEAD" and CarbonRecord.entries().size() == 1, "true defeat records one Rustler")
 var notice := CarbonRecord.relocation(main.defeat_entry)
 check(main.overlay.find_children("*", "Label", true, false).any(func(label): return label.text == notice), "approved relocation copy on screen")
 var skin := FriendlyLook.skin("HALCYON")
 check(contrast(skin.plaque_ink, skin.plaque_ground) >= 4.5, "relocation notice contrast")
 await capture("arch-relocation")
 main.refresh()
 check(CarbonRecord.entries().size() == 1, "no repeat record on refresh")
 main.carbon_open = true
 main.refresh()
 for ink in [SamizinePaper.CARBON, SamizinePaper.DITTO, SamizinePaper.MARKER]:
  check(contrast(ink, SamizinePaper.PAGE) >= 4.5, "SAMIZINE ink meets 4.5:1 on onionskin")
 for entry: RichTextLabel in main.overlay.find_children("*", "RichTextLabel", true, false):
  check("’Pelago" in entry.get_parsed_text() and "Archipelago" not in entry.get_parsed_text(), "ledger uses the approved term")
 await capture("arch-carbon-page")
 main._new_run()
 main.carbon_open = true
 main.refresh()
 check(CarbonRecord.entries()[0].rustler == "GENERALIST", "record remains readable between runs")
 await capture("arch-dead-drop-ledger")
 check(LocalRecord.erase(CarbonRecord.PATH) and CarbonRecord.entries().is_empty(), "delete clears persistent record")
 if not old_record.is_empty(): LocalRecord.write(CarbonRecord.PATH, old_record)
 main.queue_free()
 await settle()
 print("SIGNAL/CARBON FIXTURE: %d checks, %d failures" % [checks, failures])
 quit(int(failures > 0))
