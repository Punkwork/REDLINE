class_name UplinkContract
extends RefCounted
## CSA-04g (CSA-02 element 9; NODE-AUTHORITY-001): what the Black Market Uplink may offer and at which
## base prices, read from the canonical sources only. UplinkVisit (the visit) and UplinkRoom (the screen)
## consume it, as must any future reward or shop code.
##
## * Services and the Clinic: Core Rules §8.3 (#node-uplink) is the single definition. SERVICES, NEVER
##   and the CLINIC_* values below mirror it, and tests/python/test_uplink_contract.py fails if they and
##   §8.3 disagree, so a change is made in §8.3 and here together, never here alone.
## * Cards: the same reward pools as card rewards (BASIC-001: starter and basic cards are never sold;
##   pending, experimental and historical cards never appear), priced by rarity (UPL-008), on a shelf
##   shaped by UPLINK-SPEC-001. All of it from godot/data/cards.json ("uplink", the card records).
## * CAPS: the CAP records and their prices (UPL-002, CAPS-TEST-001).
## * Ghostware: no canonical record yet (CSA-07); ghostware prices are not part of this contract.
## * Not here (approved, awaiting their own confirmation before implementation): market variability,
##   the TRACE premium and Identity Verification (ECON-MARKET-001, ECON-TRACE-001, UPL-IDENTITY-001),
##   seeded stocking and the sale roll (UPLINK-SPEC-001). This contract gives base prices only.

## Core Rules §8.3, Black Market Uplink: what it offers and never offers.
const SERVICES := ["CARDS", "CAPS", "GHOSTWARE", "CLINIC"]
const NEVER := ["VITAE", "CARD_REMOVAL", "REFACTOR", "PATCHWORK", "FUSE"]
## Core Rules §8.3, Clinic (CLINIC-001): CORTEX only; per counter; a bulk discount when removing at
## least CLINIC_BULK_MIN counters in one visit, rounded up.
const CLINIC_REMOVES := "CORTEX"
const CLINIC_PER_COUNTER := 30
const CLINIC_BULK_MIN := 2
const CLINIC_BULK_PERCENT_OFF := 25

static func offers(service: String) -> bool:
	return SERVICES.has(service)

static func _section(data: Dictionary) -> Dictionary:
	return (data if not data.is_empty() else CardDB.DATA).get("uplink", {})

## Base price of a card by its rarity (UPL-008). `data` lets tests use a modified copy of cards.json.
static func card_base_price(id: String, data: Dictionary = {}) -> int:
	var records: Dictionary = (data if not data.is_empty() else CardDB.DATA).get("cards", {})
	var rarity := String(records.get(id, {}).get("rarity", ""))
	return int(_section(data).get("card_prices", {}).get(rarity, -1))

## The shelf's shape (UPLINK-SPEC-001): size, rarity counts, shared / Rustler split, the sale.
static func card_shelf(data: Dictionary = {}) -> Dictionary:
	return _section(data).get("card_shelf", {})

## Cards that may stock the shelf, by rarity: the shared pool and the Rustler's own pool.
static func card_pool(rustler: String, rarity: String) -> Dictionary:
	return {"shared": CardDB.reward_pool("SHARED", rarity), "rustler": CardDB.reward_pool(rustler, rarity)}

## UPLINK-SPEC-001: "Insufficient eligible pool: explicit test configuration error, no silent
## relaxation." Lists every shortfall for this Rustler (empty when the shelf can always be filled).
static func stock_shortfalls(rustler: String) -> Array:
	var shelf := card_shelf()
	var out := []
	var total := {"shared": 0, "rustler": 0}
	for rarity in shelf.get("rarity", {}):
		var pool := card_pool(rustler, rarity)
		var need: int = shelf.rarity[rarity]
		if pool.shared.size() + pool.rustler.size() < need:
			out.append("%s: %d eligible %s cards, the shelf needs %d" % [rustler, pool.shared.size() + pool.rustler.size(), rarity, need])
		total.shared += pool.shared.size()
		total.rustler += pool.rustler.size()
	for side in ["shared", "rustler"]:
		if total[side] < int(shelf.get(side, 0)):
			out.append("%s: %d eligible %s cards, the shelf needs %d" % [rustler, total[side], side, int(shelf.get(side, 0))])
	return out

## CAPS that may stock the CAP shelf, and their base prices (the CAP records).
static func cap_pool(rarity: String) -> Array:
	return CardDB.caps_of(rarity)

static func cap_base_price(id: String) -> int:
	return int(CardDB.CAPS.get(id, {}).get("price", -1))

## Clinic price for removing `counters` CORTEX in one visit (Core Rules §8.3, CLINIC-001).
static func clinic_price(counters: int) -> int:
	if counters <= 0: return 0
	var full := CLINIC_PER_COUNTER * counters
	if counters < CLINIC_BULK_MIN: return full
	return int(ceil(full * (100 - CLINIC_BULK_PERCENT_OFF) / 100.0))
