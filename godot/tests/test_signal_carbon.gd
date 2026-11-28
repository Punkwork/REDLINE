extends SceneTree

var checks := 0
var failures := 0

func check(ok: bool, message: String) -> void:
 checks += 1
 if ok: return
 failures += 1
 push_error(message)

func _initialize() -> void:
 var g := Game.new(77)
 g.new_run("ECHO")
 for corp in SignalCards.ORDER:
  g.corporation = corp
  g._award_punch_card()
  g._award_punch_card()
  check(g.punch_cards.count(corp) == 1, "Central Node card is unique: " + corp)
  # SIGNAL-002: one fixed Signal barcode per corporation; its bars fit the strip between the guard bars.
  var spec: Dictionary = SignalCards.DATA[corp]
  check(not spec.bars.is_empty(), "Barcode has bars: " + corp)
  for bar in spec.bars: check(bar[0] >= 4 and bar[0] + bar[1] <= SignalCards.MODULES - 4, "Bar fits inside the guards: " + corp)
 # SIGNAL-002: "the three barcodes overlaid form the Signal". Each holds part of it, none overlap, all three fill it.
 var held := []
 var seen := {}
 for corp in SignalCards.ORDER:
  for bar in SignalCards.DATA[corp].bars:
   check(not seen.has(str(bar)), "Barcodes do not share a bar")
   seen[str(bar)] = true
  held.append(corp)
  var shown: Array = SignalCards.bars_for(held)
  var whole: bool = SignalCards.SIGNAL_BARS.all(func(b): return shown.has(b))
  check(whole == (held.size() == 3), "The Signal is whole only when all three barcodes overlay (%d held)" % held.size())
 check(seen.size() == SignalCards.SIGNAL_BARS.size(), "The three barcodes together hold every Signal bar")
 check(SignalCards.bars_for([]) == SignalCards.GUARDS, "No barcode held: guard bars only")
 var restored := Game.new(77)
 restored.new_run("ECHO")
 restored.restore_presentation(JSON.parse_string(JSON.stringify(g.save_presentation())))
 check(restored.punch_cards == SignalCards.ORDER, "Signal barcodes survive a presentation save round trip")
 # Old saves (SIGNAL-001 punch-card records) still load: same "punch_cards" key and corporation values.
 var old_save := Game.new(77)
 old_save.new_run("ECHO")
 old_save.restore_presentation(JSON.parse_string('{"punch_cards": ["LUCIDA", "HALCYON"], "grafts": {}}'))
 check(old_save.punch_cards == ["HALCYON", "LUCIDA"], "A SIGNAL-001 save loads as Signal barcodes")
 restored.new_run("ECHO")
 check(restored.punch_cards.is_empty(), "New run clears Signal barcodes")
 check(not SignalCards.may_reveal(["HALCYON", "HALCYON", "LUCIDA"]), "Three entries do not substitute for three distinct cards")

 for line in ArchCopy.lines:
  check(ArchCopy.valid_line(line), "Invalid ARCH copy " + line.id)
  if line.tag == "reveal":
   for card_count in range(3):
    check(not ArchCopy.may_show(line, SignalCards.ORDER.slice(0, card_count), true), "Premature reveal " + line.id)
   check(ArchCopy.may_show(line, SignalCards.ORDER, true), "Eligible after third card " + line.id)
 for line in AdpCopy.lines:
  var item: Dictionary = line.duplicate()
  item.voice = "rustler" if item.kind in ["leak", "graffiti", "reply"] else "corporate"
  check(ArchCopy.valid_line(item), "Invalid ADP copy " + line.id)
  if item.has("trigger"):
   check(ArchCopy.valid_line({"text": item.trigger, "voice": "corporate"}), "Invalid corporate graffiti prompt " + line.id)
 for item in JSON.parse_string(FileAccess.get_file_as_string("res://data/nulrem_lines.json")).lines:
  check(ArchCopy.valid_line(item), "Invalid NUL/REM copy " + item.id)
 for corp in SignalCards.ORDER:
  var skin := FriendlyLook.skin(corp)
  for value in [skin.app_name, skin.background_headline, skin.cracking_copy, skin.strike_title, skin.strike_copy]:
   check(ArchCopy.valid_line({"voice": "corporate", "text": value}), "Invalid corporate skin copy")
 for id in CardDB.DEFS:
  check(ArchCopy.valid_line({"voice": "rules", "text": CardDB.def(id).name + " " + g.card_text(id)}), "Invalid card rules " + id)
 for id in IceDB.DEFS:
  check(ArchCopy.valid_line({"voice": "rules", "text": JSON.stringify(IceDB.def(id))}), "Invalid ICE rules " + id)
 for voice in ["corporate", "rules", "rustler"]:
  check(not ArchCopy.valid_line({"voice": voice, "text": "The ARCHIPELAGO"}), "Reject full name on screen")
 for voice in ["corporate", "rules"]:
  for spelling in ["’Pelago", "'Pelago"]:
   check(not ArchCopy.valid_line({"voice": voice, "text": "The " + spelling}), "Reject underworld term in protected copy")
 check(ArchCopy.valid_line({"voice": "rustler", "text": "The ’Pelago"}), "Allow official underworld spelling")
 check(not ArchCopy.valid_line({"voice": "rustler", "text": "The 'Pelago"}), "Reject ASCII spelling on screen")
 check(not ArchCopy.valid_line({"voice": "rustler", "text": "A gulag"}), "Reject banned wording")
 check(not ArchCopy.valid_line({"kind": "island_purpose", "tag": "hint", "text": "Rehearsal."}), "Reject untagged island explanation")
 check(not ArchCopy.valid_line({"tag": "flavour", "text": "SYNCHRONIZATION SCRAMBLER"}), "Reject untagged signal command")
 var premature := {"tag": "reveal", "trigger": "loading", "approval": "approved", "text": "SYNCHRONIZATION SCRAMBLER"}
 check(not ArchCopy.valid_line(premature) and not ArchCopy.may_show(premature, ["HALCYON", "IRONWATCH"]), "Reject an early reveal trigger")
 print("SIGNAL/CARBON: %d checks, %d failures" % [checks, failures])
 quit(int(failures > 0))
