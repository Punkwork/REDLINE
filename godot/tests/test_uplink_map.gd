extends SceneTree
## UPLINK-SPEC-001 and MAP-003f: the Black Market Uplink visit and the generated HALCYON map in the
## engine. Expectations are literals from the approved texts:
##   UPLINK-SPEC-001: stock on entry, seeded, no refresh; 8 unique non-basic cards, exactly 5 COMMON /
##     2 UNCOMMON / 1 RARE, 6 shared / 2 from the Rustler's pool; one uniformly random card at half
##     price; 3 unique CAPS; sold slots stay visible and unavailable; atomic transactions (not enough CRED
##     changes nothing); a card goes to the compiled deck, a CAP to the rack, a full rack needs a
##     confirmed replacement and cancelling changes nothing; no combat turn on entry or exit; exit to map.
##   UPL-008: cards 40 / 60 / 90 CRED. CAPS-TEST-001: common CAPS 20 CRED.
##   Core Rules §8.3 / CLINIC-001: the Clinic removes CORTEX only, 30 CRED per counter, 25% off for 2+,
##     rounded up. No WIPE, no VITAE, no card removal.
##   MAP-003f V5: 16 rows; row 1 ICE; row 16 the BOSS; every route ends at the BOSS.

var passed := 0
var failed := 0

func check(ok: bool, what: String) -> void:
	if ok: passed += 1
	else:
		failed += 1
		push_error("FAIL: " + what)

func _initialize() -> void:
	stock_rules()
	purchases()
	caps_and_replacement()
	ghostware_purchase()
	clinic()
	entry_and_exit()
	generated_map()
	print("UPLINK + MAP: %d passed, %d failed" % [passed, failed])
	quit(int(failed > 0))

func visit(seed := 3, who := "GENERALIST") -> UplinkVisit:
	var g := Game.new(seed)
	g.new_run(who)
	g.cred = 1000
	return UplinkVisit.open(g)

func stock_rules() -> void:
	var prices := {"COMMON": 40, "UNCOMMON": 60, "RARE": 90}
	for sd in 25:
		var v := visit(sd)
		var g := v.game
		check(v.error == "", "seed %d: the shelf stocks (%s)" % [sd, v.error])
		var ids := v.cards.map(func(c): return c.id)
		var uniq := {}
		for id in ids: uniq[id] = true
		var count := {"COMMON": 0, "UNCOMMON": 0, "RARE": 0}
		var own := 0
		var sales := 0
		var price_ok := true
		for c in v.cards:
			var r := String(CardDB.def(c.id).rarity)
			count[r] = int(count.get(r, 0)) + 1
			if CardDB.reward_pool(g.rustler, r).has(c.id) and not CardDB.reward_pool("SHARED", r).has(c.id): own += 1
			if c.sale:
				sales += 1
				if int(c.price) != int(round(prices[r] / 2.0)): price_ok = false
			elif int(c.price) != prices[r]: price_ok = false
		check(ids.size() == 8 and uniq.size() == 8, "seed %d: 8 unique cards" % sd)
		check(count == {"COMMON": 5, "UNCOMMON": 2, "RARE": 1}, "seed %d: exactly 5 / 2 / 1 (%s)" % [sd, count])
		check(own == 2, "seed %d: 2 from the Rustler's pool, 6 shared (%d)" % [sd, own])
		check(sales == 1 and price_ok, "seed %d: one card at half price, the rest at 40 / 60 / 90" % sd)
		check(ids.all(func(id): return not CardDB.def(id).rarity == "STARTER" and CardDB.design_status(id) in ["approved", "playtest"]), "seed %d: no starter, basic, pending or experimental card" % sd)
		check(v.caps.size() == 3 and v.caps.map(func(c): return c.id).filter(func(x): return true).size() == 3, "seed %d: 3 CAPS" % sd)
		var cu := {}
		for c in v.caps: cu[c.id] = true
		check(cu.size() == 3 and v.caps.all(func(c): return int(c.price) == 20), "seed %d: 3 unique CAPS at 20 CRED" % sd)
		var gw := v.ghostware.map(func(x): return String(x.id))
		check(gw.size() == mini(3, CardDB.ghostware_for_sale().size()) and gw.all(func(id): return CardDB.ghostware_for_sale().has(id)), "seed %d: up to 3 Ghostware for sale (CSA-07, P5-008)" % sd)
		check(v.ghostware.all(func(x): return int(x.price) == (75 if CardDB.GHOSTWARE[x.id].has("drawback") else 100)), "seed %d: Ghostware 100 CRED, 75 with a drawback (P5-008)" % sd)
	# Seeded: the same run seed, the same stock.
	check(visit(7).cards == visit(7).cards, "the same seed stocks the same shelf")
	check(visit(7).cards != visit(8).cards, "a different seed stocks a different shelf")
	# Developer-only override.
	UplinkVisit.override = ["REPRISE", "SALVAGE"]
	var o := visit(1)
	check(o.cards.map(func(c): return c.id) == ["REPRISE", "SALVAGE"], "the developer override stocks exactly the listed cards")
	UplinkVisit.override = []

func purchases() -> void:
	var v := visit(4)
	var g := v.game
	var deck := g.run_deck.size()
	var i := 0
	g.cred = int(v.cards[i].price) - 1
	check(not v.buy_card(i) and g.cred == int(v.cards[i].price) - 1 and g.run_deck.size() == deck and not v.cards[i].sold, "not enough CRED: nothing changes")
	g.cred = 500
	check(v.buy_card(i), "a card can be bought")
	check(g.cred == 500 - int(v.cards[i].price), "CRED goes down by the price")
	check(g.run_deck.size() == deck + 1 and String(g.run_deck[-1].id) == String(v.cards[i].id), "the card joins the compiled deck")
	check(v.cards.size() == 8 and v.cards[i].sold, "the sold slot stays on the shelf, marked sold")
	check(not v.buy_card(i), "a sold slot can't be bought again")

func caps_and_replacement() -> void:
	var v := visit(5)
	var g := v.game
	g.cred = 500
	for k in 3:
		g.caps.append({"uid": g.next_uid, "id": "BULWARK"})
		g.next_uid += 1
	var before := g.caps.duplicate(true)
	check(v.cap_needs_replacement() and not v.buy_cap(0), "full CAP rack: no purchase without choosing a CAP to replace")
	check(g.caps == before and g.cred == 500 and not v.caps[0].sold, "cancelling the replacement changes nothing")
	var old := int(g.caps[1].uid)
	check(v.buy_cap(0, old), "buy with a replacement")
	check(g.caps.size() == 3 and not g.caps.any(func(c): return int(c.uid) == old) and String(g.caps[-1].id) == String(v.caps[0].id), "the chosen CAP is replaced by the new one")
	check(g.cred == 480 and v.caps[0].sold, "20 CRED paid; the CAP slot is sold")
	var w := visit(6)
	w.game.cred = 100
	check(w.buy_cap(1) and w.game.caps.size() == 1, "with a free slot the CAP goes straight to the rack")

func ghostware_purchase() -> void:
	var v := visit(11)
	var g := v.game
	check(not v.ghostware.is_empty(), "Ghostware on the shelf")
	var id := String(v.ghostware[0].id)
	g.cred = int(v.ghostware[0].price) - 1
	check(not v.buy_ghostware(0) and not g.ghostware.has(id), "not enough CRED: nothing changes")
	g.cred = 300
	var price := int(v.ghostware[0].price)
	check(v.buy_ghostware(0) and g.ghostware.has(id) and g.cred == 300 - price and v.ghostware[0].sold, "bought: permanent for the run, CRED paid, slot sold")
	var w := UplinkVisit.open(g)
	check(not w.ghostware.any(func(x): return String(x.id) == id), "an owned Ghostware isn't offered again")
	check(not CardDB.ghostware_for_sale().any(func(x): return String(CardDB.GHOSTWARE[x].set) in ["ORIGIN", "HALCYON", "IRONWATCH", "LUCIDA"]), "ORIGINs and corporation sets are never sold")
	check(CardDB.GHOSTWARE.size() == 41, "41 Ghostware records (20 general incl. DEAD MAN'S POCKET, 4 reserve, 4 synergy, 3 + 3 + 3 corporation, 4 ORIGIN)")

func clinic() -> void:
	var v := visit(2)
	var g := v.game
	check(v.clinic_price(1) == 30 and v.clinic_price(2) == 45 and v.clinic_price(3) == 68, "Clinic: 30 per counter; 2+ counters 25% off, rounded up (30, 45, 68)")
	g.cortex = 3
	g.cred = 44
	check(not v.clinic(2) and g.cortex == 3 and g.cred == 44, "not enough CRED: nothing changes")
	g.cred = 100
	check(v.clinic(2) and g.cortex == 1 and g.cred == 55, "remove 2 CORTEX for 45 CRED")
	check(not v.clinic(2), "can't remove more CORTEX than you have")
	check(UplinkContract.offers("CLINIC") and not UplinkContract.offers("WIPE") and not UplinkContract.offers("VITAE"), "Core Rules §8.3: Clinic yes; no WIPE, no VITAE")

func entry_and_exit() -> void:
	var g := Game.new(9)
	g.new_run("GENERALIST")
	g.use_generated_map(0)
	var r := -1
	var col := -1
	for ri in g.map_rows.size():
		for i in g.map_rows[ri].size():
			if r < 0 and g.map_rows[ri][i].kind == "UPLINK":
				r = ri; col = i
	check(r > 0, "the generated map has an Uplink")
	g.row = r - 1
	g.available = [col]
	g.phase = "MAP"
	var deck := g.run_deck.size()
	g.enter_node(col)
	check(g.phase == "UPLINK" and g.uplink != null and g.enc.is_empty(), "entering an Uplink opens the visit; no combat turn")
	check(g.run_deck.size() == deck and g.hand.is_empty() and g.draw_pile.is_empty(), "no draw or reshuffle on entry")
	g.cred = 200
	g.uplink.buy_card(0)
	var bought := String(g.run_deck[-1].id)
	g.leave_uplink()
	check(g.phase == "MAP" and g.row == r and g.uplink == null, "leaving goes back to the map, one row on")
	check(g.run_deck.any(func(c): return String(c.id) == bought), "the bought card stays in the deck after leaving")

func generated_map() -> void:
	var g := Game.new(1)
	g.new_run("GENERALIST")
	g.use_generated_map(3)
	check(g.map_rows.size() == 16, "16 rows (MAP-003f)")
	check(g.map_rows[0].size() == 1 and g.map_rows[0][0].kind == "ICE" and g.map_rows[0][0].name == "COOKIE BANNER", "row 1: the Opening Node")
	check(g.map_rows[15].size() == 1 and g.map_rows[15][0].get("central", false), "row 16: the BOSS, the central Node")
	var bad := []
	for ri in 15:
		for n in g.map_rows[ri]:
			for j in n.next:
				if j < 0 or j >= g.map_rows[ri + 1].size(): bad.append(n.id)
			if n.next.is_empty(): bad.append(n.id + " (dead end)")
	check(bad.is_empty(), "every Node links forward (%s)" % [bad])
	check(g.map_rows.all(func(row): return row.all(func(n): return n.kind != "ICE" or not n.layers.is_empty())), "every ICE Node has an encounter")
	# Layers (designer 2026-11-28): row 9's ICE Nodes have 2 layers, the BOSS 3, the rest 1.
	var two := 0
	var wrong := []
	for ri in g.map_rows.size():
		for n in g.map_rows[ri]:
			if n.kind != "ICE": continue
			var want := 3 if n.get("central", false) else (2 if ri == 8 else 1)
			if n.layers.size() != want: wrong.append(n.id)
			if n.layers.size() == 2: two += 1
	check(wrong.is_empty() and two >= 1 and g.map_rows[15][0].layers.size() == 3, "at least one 2-layer Node and the 3-layer BOSS (%s)" % [wrong])
	# DEAD DROP, CONSOLE LAB, SIGNAL: their room, then back to the map.
	var room_at := []
	for ri in g.map_rows.size():
		for i in g.map_rows[ri].size():
			if room_at.is_empty() and g.map_rows[ri][i].get("unbuilt", false): room_at = [ri, i]
	g.row = room_at[0] - 1; g.available = [room_at[1]]; g.phase = "MAP"
	g.enter_node(room_at[1])
	check(g.phase == "NODE_ROOM", "an unbuilt Node opens its room")
	g.leave_room()
	check(g.phase == "MAP" and g.row == room_at[0], "leaving the room goes back to the map")
	# Walk a route: unbuilt Nodes pass through, Uplinks open and close, ICE Nodes start encounters.
	g.row = -1
	g.available = [0]
	g.phase = "MAP"
	var kinds := {}
	var guard := 0
	while g.phase == "MAP" and guard < 40:
		guard += 1
		var idx: int = g.available[0]
		var n: Dictionary = g.map_rows[g.row + 1][idx]
		kinds[n.kind] = true
		g.enter_node(idx)
		match g.phase:
			"UPLINK": g.leave_uplink()
			"SAFEHOUSE": g.safehouse_heal()
			"NODE_ROOM": g.leave_room()
			"MAP": pass
			_:
				# An ICE encounter: finish it as a clear (the encounter itself is covered elsewhere).
				if g.phase == "READY_RIG": g.skip_ready_rig()
				g._end_ice_node()
				g._complete_map_step()
	check(g.phase == "SLICE_DONE", "a full route reaches the end of the map (%s)" % g.phase)
	check(kinds.has("ICE"), "the route met ICE Nodes")
