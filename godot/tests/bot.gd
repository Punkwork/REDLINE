extends RefCounted
## A simple bot for headless tests and economy simulations. Not a good player, just a consistent one.
## patient = true: keeps DEADLOCKs unbroken while an Extractor is draining the reserve and VITAE is healthy,
## to approximate a player who extracts fully.

var patient := false


func _init(p_patient := false) -> void:
	patient = p_patient


## Plays a NodeRun until it is finished. Returns false if it got stuck.
func play_node(node) -> bool:
	var guard := 0
	while node.phase not in ["node_complete", "defeat"] and guard < 600:
		guard += 1
		if not node.choice.is_empty():
			var opts: Array = node.choice["options"]
			node.resolve_choice([opts[0]["key"]] if int(node.choice["max"]) > 0 else [])
			continue
		match node.phase:
			"ready_rig":
				var rr: Array = node.ready_rig_options()
				var pick = rr.filter(func(i): return node.card_def(i).has("extractor"))
				if pick.is_empty():
					pick = rr
				node.ready_rig_choose(pick[0]["uid"] if not pick.is_empty() else -1)
			"player":
				turn(node)
			"reward":
				node.choose_reward(node.reward_options[0] if not node.reward_options.is_empty() else "")
			"completion":
				node.choose_completion(node.completion_options[0])
			"payload":
				node.choose_payload(node.payload_options[0] if not node.payload_options.is_empty() else "")
			"layer_choice":
				if node.run.vitae > 15 or not node.can_leave():
					node.go_deeper()
				else:
					node.leave_node()
	return guard < 600


func _extracting(node) -> bool:
	if not patient or node.reserve <= 0 or node.run.vitae <= 18 or node.run.trace >= 30:
		return false
	return node.installed.any(func(i): return node.card_def(i).has("extractor"))


func turn(node) -> void:
	var progress := true
	var hold_deadlocks := _extracting(node)
	while progress and node.phase == "player" and node.choice.is_empty():
		progress = false
		var best := []
		for ip in node.installed_icepicks():
			for i in node.ice_list.size():
				var subs: Array = node.ice_list[i]["broken"]
				for s in subs.size():
					var cost: int = node.total_break_cost(ip["uid"], i, s)
					if cost < 0 or cost > node.bw:
						continue
					var is_dl: bool = node.ice_list[i]["def"]["subroutines"][s]["effects"].any(func(e): return e["op"] == "deadlock")
					if is_dl and hold_deadlocks:
						continue
					var score: int = (0 if is_dl else 100) + cost
					if best.is_empty() or score < best[0]:
						best = [score, ip["uid"], i, s]
		if not best.is_empty() and best[0] < 100:
			progress = node.boost_and_break(best[1], best[2], best[3])
			continue
		for inst in node.hand.duplicate():
			if node.can_play(inst)["ok"] and node.card_def(inst)["type"] in ["PROGRAM", "PROTOCOL", "BLOATWARE"]:
				progress = node.play_card(inst["uid"])
				break
		if progress:
			continue
		if not best.is_empty():
			progress = node.boost_and_break(best[1], best[2], best[3])
			if progress:
				continue
		for inst in node.hand.duplicate():
			if node.can_play(inst)["ok"] and node.card_def(inst)["type"] == "SCRIPT":
				progress = node.play_card(inst["uid"], node._strongest_ice())
				break
		if not progress and node.run.vitae < 12 and not node.run.caps.is_empty():
			for slot in node.run.caps.size():
				var id: String = node.run.caps[slot]["id"]
				if id in ["bulwark", "nanosuture", "zero_day", "cracker"]:
					progress = node.use_cap(slot, node._strongest_ice())
					break
	if node.phase == "player" and node.choice.is_empty():
		node.end_turn()


## Plays a whole heist. buy_cards: how many cards to buy per Uplink at most.
func play_heist(h, buy_cards := 2) -> void:
	var guard := 0
	while h.phase != "summary" and guard < 400:
		guard += 1
		match h.phase:
			"map":
				var r: Array = h.reachable()
				h.choose_node(r[h.run.rng.randi_range(0, r.size() - 1)])
			"encounter":
				play_node(h.node)
				h.finish_encounter()
			"room":
				_room(h, buy_cards)
			"pick_card":
				var opts: Array = h.pick_options()
				var basic = opts.filter(func(o): return o["id"] in ["probe", "pulp_shield"])
				h.resolve_pick(basic[0]["uid"] if not basic.is_empty() else opts[0]["uid"])


func _room(h, buy_cards: int) -> void:
	match h.room["type"]:
		"uplink":
			var bought := 0
			var items: Array = h.room["items"]
			var order: Array = range(items.size())
			order.sort_custom(func(a, b): return items[a]["price"] < items[b]["price"])
			for i in order:
				if items[i]["kind"] == "card" and items[i]["shelf"] == "Cards" and bought < buy_cards and h.can_buy(i) == "":
					h.buy(i)
					bought += 1
			for i in order:
				if items[i]["kind"] == "cap" and h.can_buy(i) == "":
					h.buy(i)
					break
			h.leave_room()
		"dead_drop":
			h.room_choice("patch_up" if h.run.vitae < 20 else "wipe_trail")
		"safehouse":
			h.room_choice("heal")
		"console_lab":
			h.room_choice("leave")
		"event":
			var n: int = h.room["event"]["choices"].size()
			for i in n:
				if h.event_choice_allowed(i):
					h.room_choice(str(i))
					break
