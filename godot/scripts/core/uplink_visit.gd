class_name UplinkVisit
extends RefCounted
## UPLINK-SPEC-001 (approved 2026-11-27) and Core Rules §8.3: one visit to a Black Market Uplink. Owns the
## visit's inventory and transactions only; run state (CRED, the compiled deck, CAPS, CORTEX) stays on
## Game, and every rule and price comes from UplinkContract (canonical data). No combat state is touched.
##
## * Stock is generated on entry from the run's RNG (seeded, no refresh): 8 unique non-basic cards,
##   exactly 5 COMMON / 2 UNCOMMON / 1 RARE, 6 from the shared pool and 2 from the Rustler's pool; one
##   card, uniformly at random, at half price. 3 unique CAPS. An impossible shelf is an explicit
##   configuration error (`error`), never a silently smaller shelf.
## * Ghostware (CSA-07 records, P5-008): up to 3 random Ghostware you don't own, from those for sale
##   (general pool, approved and built), at their record price (100 CRED, 75 with a drawback).
## * Prices: base prices (UPL-008, CAP records) and the sale. Market variability and the TRACE premium
##   (ECON-MARKET-001, ECON-TRACE-001) await their own confirmation (UplinkContract); prices are locked
##   for the visit.
## * Transactions are atomic: not enough CRED changes nothing; a card goes to the compiled deck; a CAP to
##   the CAP rack, and a full rack needs a CAP chosen for replacement (cancel changes nothing); the Clinic
##   removes CORTEX only, for CLINIC price (Core Rules §8.3).
## * Developer-only inventory override (UPLINK-SPEC-001, approved Protocol/Script playtest): `override`.

var game: Game
var cards: Array = []       # [{id, base, price, sale, sold}]
var caps: Array = []        # [{id, price, sold}]
var ghostware: Array = []   # [{id, price, sold}]
var error := ""             # a stock configuration error, or ""
var sold_log: Array = []    # [{kind, id, price}], this visit

## Developer-only: if not empty, the card shelf is exactly these IDs (prices from canonical data).
static var override: Array = []

static func open(g: Game) -> UplinkVisit:
	var v := UplinkVisit.new()
	v.game = g
	v._stock()
	return v

func _stock() -> void:
	var shelf := UplinkContract.card_shelf()
	var ids: Array = []
	if not override.is_empty():
		ids = override.duplicate()
	else:
		ids = _pick_cards(shelf)
		if ids.is_empty():
			error = "Uplink stock: %s" % "; ".join(UplinkContract.stock_shortfalls(game.rustler))
	var sale_index := game.rng.randi_range(0, ids.size() - 1) if int(shelf.get("on_sale", 0)) > 0 and not ids.is_empty() else -1
	for k in ids.size():
		var base := UplinkContract.card_base_price(String(ids[k]))
		var price := base
		if k == sale_index:
			price = int(round(base * (100 - int(shelf.get("sale_percent_off", 0))) / 100.0))
		cards.append({"id": String(ids[k]), "base": base, "price": price, "sale": k == sale_index, "sold": false})
	var cap_ids: Array = []
	for r in ["COMMON", "UNCOMMON", "RARE"]: cap_ids += UplinkContract.cap_pool(r)
	var n: int = int(CardDB.DATA.get("uplink", {}).get("cap_shelf", {}).get("size", 3))
	for k in mini(n, cap_ids.size()):
		var id: String = cap_ids.pop_at(game.rng.randi_range(0, cap_ids.size() - 1))
		caps.append({"id": id, "price": UplinkContract.cap_base_price(id), "sold": false})
	var gw: Array = CardDB.ghostware_for_sale().filter(func(id): return not game.ghostware.has(id))
	for k in mini(3, gw.size()):
		var id: String = gw.pop_at(game.rng.randi_range(0, gw.size() - 1))
		ghostware.append({"id": id, "price": int(CardDB.GHOSTWARE[id].price), "sold": false})

## 8 unique cards: the rarity counts exactly, and exactly `rustler` of them from the Rustler's own pool.
func _pick_cards(shelf: Dictionary) -> Array:
	var slots := []
	for r in ["COMMON", "UNCOMMON", "RARE"]:
		for k in int(shelf.get("rarity", {}).get(r, 0)): slots.append(r)
	for attempt in 64:
		var own := {}
		var order := range(slots.size())
		for k in range(order.size() - 1, 0, -1):
			var j := game.rng.randi_range(0, k)
			var t = order[k]; order[k] = order[j]; order[j] = t
		for k in int(shelf.get("rustler", 0)): own[order[k]] = true
		var taken := {}
		var out := []
		var ok := true
		for k in slots.size():
			var pool := UplinkContract.card_pool(game.rustler, slots[k])
			var cands: Array = (pool.rustler if own.has(k) else pool.shared).filter(func(id): return not taken.has(id))
			if cands.is_empty():
				ok = false
				break
			var id: String = cands[game.rng.randi_range(0, cands.size() - 1)]
			taken[id] = true
			out.append(id)
		if ok: return out
	return []

func can_buy_card(i: int) -> bool:
	return i >= 0 and i < cards.size() and not cards[i].sold and game.cred >= int(cards[i].price)

func buy_card(i: int) -> bool:
	if not can_buy_card(i): return false
	var c: Dictionary = cards[i]
	game.cred -= int(c.price)
	game.run_deck.append(game._new_inst(c.id))
	c.sold = true
	sold_log.append({"kind": "CARD", "id": c.id, "price": c.price})
	game._say("Bought %s for %d CRED: added to your deck." % [CardDB.def(c.id).name, c.price])
	return true

## A CAP purchase. With a full CAP rack, pass the uid of the CAP to replace (the old one is discarded);
## without it the purchase is refused and nothing changes.
func can_buy_cap(i: int) -> bool:
	return i >= 0 and i < caps.size() and not caps[i].sold and game.cred >= int(caps[i].price)

func cap_needs_replacement() -> bool:
	return game.caps.size() >= Game.CAP_SLOTS

func buy_cap(i: int, replace_uid: int = -1) -> bool:
	if not can_buy_cap(i): return false
	if cap_needs_replacement():
		var k := -1
		for j in game.caps.size():
			if int(game.caps[j].uid) == replace_uid: k = j
		if k < 0: return false
		game.caps.remove_at(k)
	var c: Dictionary = caps[i]
	game.cred -= int(c.price)
	game.caps.append({"uid": game.next_uid, "id": c.id})
	game.next_uid += 1
	c.sold = true
	sold_log.append({"kind": "CAP", "id": c.id, "price": c.price})
	game._say("Bought %s for %d CRED." % [CardDB.CAPS[c.id].name, c.price])
	return true

func can_buy_ghostware(i: int) -> bool:
	return i >= 0 and i < ghostware.size() and not ghostware[i].sold and game.cred >= int(ghostware[i].price)

## Ghostware is permanent for the run and active at once (P5-003).
func buy_ghostware(i: int) -> bool:
	if not can_buy_ghostware(i): return false
	var c: Dictionary = ghostware[i]
	game.cred -= int(c.price)
	game.ghostware.append(String(c.id))
	c.sold = true
	sold_log.append({"kind": "GHOSTWARE", "id": c.id, "price": c.price})
	game._say("Bought %s for %d CRED." % [CardDB.GHOSTWARE[c.id].name, c.price])
	return true

## The Clinic (Core Rules §8.3): CORTEX removal only, priced per visit quantity (CLINIC-001).
func clinic_price(n: int) -> int:
	return UplinkContract.clinic_price(n)

func can_clinic(n: int) -> bool:
	return n >= 1 and n <= game.cortex and game.cred >= clinic_price(n)

func clinic(n: int) -> bool:
	if not can_clinic(n): return false
	var p := clinic_price(n)
	game.cred -= p
	game.cortex -= n
	sold_log.append({"kind": "CLINIC", "id": "CORTEX", "price": p, "n": n})
	game._say("Clinic: %d CORTEX removed for %d CRED." % [n, p])
	return true
