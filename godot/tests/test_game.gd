extends SceneTree
## Headless rules tests. Run: godot --headless --path godot --script res://tests/test_game.gd

var fails := 0
var passes := 0

func check(cond: bool, label: String) -> void:
	if cond:
		passes += 1
	else:
		fails += 1
		print("FAIL: ", label)

func uid_of(g: Game, arr: Array, id: String) -> int:
	for c in arr:
		if c.id == id:
			return c.uid
	return -1

func put_in_hand(g: Game, id: String) -> int:
	## Move a card with this id from any pile into the hand (or create it) for deterministic tests.
	for a in [g.draw_pile, g.discard]:
		for i in a.size():
			if a[i].id == id:
				var c = a[i]
				a.remove_at(i)
				g.hand.append(c)
				return c.uid
	var inst := g._new_inst(id)
	g.hand.append(inst)
	return inst.uid

func install(g: Game, id: String) -> void:
	var u := put_in_hand(g, id)
	g.bw += CardDB.def(id).bw
	check(g.play_card(u), "install " + id)

func _init() -> void:
	test_opening_node()
	test_shield_and_pulp()
	test_trace_strikes()
	test_captcha_discard()
	test_boost_installed()
	test_void_reveal()
	test_detainer_rules()
	test_passives()
	test_rustlers()
	test_borrowed_credentials()
	test_purge()
	test_shatter()
	test_pulp_curves()
	test_end_run()
	test_patient_zero()
	test_worm()
	test_extraction_reserve_cap()
	test_rainbow_and_toolbelt()
	test_spam_and_filter()
	test_cloak_reactive()
	test_go_deeper_keeps_programs()
	test_smash_and_grab_cache()
	test_node_card_reward_requires_full_clear()
	test_full_slice_path()
	if OS.get_environment("SIM") != "":
		sim_many()
	print("TESTS: %d passed, %d failed" % [passes, fails])
	quit(1 if fails > 0 else 0)

func test_opening_node() -> void:
	var g := Game.new(1)
	g.new_run()
	g.enter_node(0)
	check(g.phase == "READY_RIG", "READY RIG offered")
	g.choose_ready_rig(uid_of(g, g.draw_pile, "TUMBLER_ICEPICK"))
	check(g.phase == "PLAYER", "turn starts")
	check(g.hand.size() == Game.BASE_DRAW, "draw %d" % Game.BASE_DRAW)
	check(g.bw == 4, "4 BW")
	check(g.ram_used() == 1, "rig uses 1 RAM")
	# REJECT-001: one DEADLOCK, 2 rotating slots in a 3-subroutine pool.
	check(IceDB.def("REJECT_ALL").subs.size() == 3, "REJECT-001: three pool entries")
	check(g.active_subs(0) == [0] and g.active_subs(1) == [0, 1], "turn 1 slots")
	check(g.break_info(1, 0).reason.begins_with("LOCKED"), "BOOTING locks turn 1")
	check(g.break_info(1, 2).reason == "HIDDEN", "PULP starts hidden")
	check(g.break_sub(1, 1), "TRACE can be broken on turn 1")
	check(g.bw == 1 and g.pick_str(g.installed[0]) == 4, "boost and break cost unchanged")
	check(g.deadlock_view().unseen == 3, "three hidden subroutines across the opening formation")
	g.end_turn()
	check(g.enc.turn == 2 and g.bw == 3, "DETAINER drains turn 2")
	check(g.active_subs(1) == [1, 2] and not g.enc.breached, "turn 2 rotates DEADLOCK out; no early BREACH")
	check(g.response_preview()[1].skipped, "broken TRACE stays broken")
	g.end_turn()
	check(g.enc.turn == 3 and g.active_subs(1) == [2, 0], "turn 3 reveals the same single DEADLOCK")
	check(g.break_sub(1, 0) and g.enc.breached, "single DEADLOCK permits BREACH on turn 3")
	var t := g.trace
	g.end_turn()
	check(g.trace == t, "response skipped after BREACH")
	check(g.phase == "REWARD" and g.reward_options.size() == 3, "card reward 1 of 3")
	check(g.reward_note != "", "full clear noted")
	var pick: String = g.reward_options[0]
	g.choose_reward(pick)
	check(g.run_deck.size() == 13, "reward added to deck")
	check(g.phase == "MAP" and g.row == 0, "back to map")

func start_node(g: Game, row: int, idx: int, rig: String) -> void:
	g.row = row - 1
	g.available = [idx]
	g.enter_node(idx)
	if g.phase == "READY_RIG":
		g.choose_ready_rig(uid_of(g, g.draw_pile, rig))
	if g.phase == "CHOICE" and g.pending.kind == "discard":
		g.choose(g.hand[0].uid)
	if g.phase == "CHOICE" and g.pending.kind == "patient_zero":
		g.choose_ice(0)

func test_borrowed_credentials() -> void:
	var g := Game.new(110)
	g.new_run("ECHO")
	check(g.run_deck.size() == 12 and uid_of(g, g.run_deck, "BORROWED_CREDENTIALS") > 0 and uid_of(g, g.run_deck, "BACKDOOR") < 0, "ECHO-005: BORROWED CREDENTIALS replaces BACKDOOR")
	g.entered_corp = true
	start_node(g, 1, 1, "")
	install(g, "HUSH")
	var card := put_in_hand(g, "BORROWED_CREDENTIALS")
	g.bw = 4
	g.cred = 7
	check(not g.can_play(card).ok and not g.play_card(card, 0) and g.bw == 4 and g.cred == 7, "8 CRED is mandatory; failed payment spends nothing")
	g.cred = 8
	g.bw = 0
	check(not g.play_card(card, 0) and g.cred == 8, "1 BW is also mandatory")
	g.bw = 4
	check(not g.play_card(card) and not g.play_card(card, 99) and g.bw == 4 and g.cred == 8 and not g._find(g.hand, card).is_empty(), "ICE selection is mandatory and invalid targets cost nothing")
	# Distinct ICE references ensure compatibility is target-specific.
	g.enc.ice.append(g._new_ice("AUTO_RENEW"))
	check(g.play_card(card, 0) and g.bw == 3 and g.cred == 0, "successful targeted play pays exactly 1 BW and 8 CRED")
	check(g._find(g.hand, card).is_empty() and not g._find(g.discard, card).is_empty() and g.phase == "PLAYER", "SCRIPT resolves to discard; no automatic break choice")
	check(not g.break_info(0, 0).ok and g.break_info(0, 0).cost == 12, "normal HUSH Strength/boost/break and TOLL costs still apply")
	g.installed[0].boost = 5
	check(g.break_info(0, 3).ok and g.break_info(0, 3).cost == 1, "sufficient HUSH Strength enables its normal 1-BW break")
	check(not g.break_info(1, 0).ok, "another FORTRESS is not implicitly covered")
	var before_bw := g.bw
	check(g.break_sub(0, 0) and g.bw == before_bw - 2, "selected ICE's TOLL remains in effect")
	g.end_turn()
	check(not g.enc.has("borrowed_ice") and not g.break_info(0, 3).ok, "compatibility expires at this Rustler turn end")
	var opening := Game.new(111)
	opening.new_run("ECHO")
	opening.enter_node(0)
	var wrong := put_in_hand(opening, "BORROWED_CREDENTIALS")
	opening.cred = 8
	check(not opening.play_card(wrong, 0) and opening.bw == 4 and opening.cred == 8, "TUMBLER is not a valid off-type target")
	var v := Game.new(112)
	v.new_run("ECHO")
	v.entered_corp = true
	start_node(v, 2, 1, "")
	install(v, "HUSH")
	v.installed[0].boost = 10
	v.cred = 8
	v.bw = 4
	var vc := put_in_hand(v, "BORROWED_CREDENTIALS")
	check(v.play_card(vc, 0), "VOID can be selected")
	check(not v.break_info(0, 0).ok, "compatibility does not reveal or bypass hidden VOID subroutines")
	v.enc.ice[0].responses = 1
	v.enc.ice[0].seen[0] = true
	check(v.break_info(0, 0).ok and v.break_sub(0, 0), "revealed VOID subroutine can be broken by HUSH")
	var after_trace := v.trace
	check(after_trace == 0, "the extra cost is CRED, not TRACE")
	v.end_turn()
	check(v.phase == "DEEPER", "normal voluntary END TURN still completes a breached layer")
	v.go_deeper()
	check(not v.enc.has("borrowed_ice"), "compatibility does not carry into another layer")

func test_shield_and_pulp() -> void:
	var g := Game.new(2)
	g.new_run()
	g.entered_corp = true
	start_node(g, 1, 0, "TUMBLER_ICEPICK")   # CAPTCHA: DISCARD 1, PULP 2, DEADLOCK
	var u := put_in_hand(g, "PULP_SHIELD")
	g.play_card(u)
	check(g.shield == 3, "+3 SHIELD")
	g.take_pulp(2)
	check(g.shield == 1 and g.vitae == 30, "SHIELD absorbs PULP")
	g.take_pulp(4)
	check(g.shield == 0 and g.vitae == 27, "overflow to VITAE")

func test_trace_strikes() -> void:
	var g := Game.new(3)
	g.new_run()
	g.entered_corp = true
	start_node(g, 1, 0, "TUMBLER_ICEPICK")
	g.add_trace(40, false)
	check(g.strikes == 1 and g.trace == 20, "strike 1, TRACE to 20")
	check(uid_of(g, g.draw_pile, "TRACER") > 0, "TRACER in draw pile")
	g.add_trace(20, false)
	check(g.strikes == 2 and g.enc.ice[0].id == "HOUSE_CALL", "strike 2: HOUSE CALL on the left")
	g.add_trace(20, false)
	check(g.strikes == 3 and g.trace == 10 and g.lockdown, "strike 3: LOCKDOWN, TRACE 10")
	var tu := put_in_hand(g, "TRACER")
	var before := g.trace
	g.end_turn()
	check(g.trace >= before + 3, "TRACER in hand adds 3 TRACE")

func test_captcha_discard() -> void:
	var g := Game.new(4)
	g.new_run()
	g.entered_corp = true
	start_node(g, 1, 0, "TUMBLER_ICEPICK")
	g.end_turn()
	check(g.phase == "CHOICE" and g.pending.kind == "discard", "CAPTCHA DISCARD asks at the start of the next turn")
	check(g.hand.size() == Game.BASE_DRAW and g.enc.turn == 2, "the new hand is drawn first")
	g.choose(g.hand[0].uid)
	check(g.phase == "PLAYER" and g.hand.size() == Game.BASE_DRAW - 1, "discard 1, then play")
	check(g.vitae == 24, "AUTO-RENEW PULP 1+2+3 hit on turn 1 (vitae %d); CAPTCHA's PULP 6 was hidden" % g.vitae)
	check(g.is_active(1, 2), "PULP rotated into a slot")

func test_boost_installed() -> void:
	var g := Game.new(11)
	g.new_run()
	g.entered_corp = true
	start_node(g, 1, 0, "TUMBLER_ICEPICK")   # CAPTCHA STR 5
	var p: Dictionary = g.installed[0]
	var c := g.can_boost(p.inst.uid)
	check(c.ok and c.cost == 2, "TUMBLER Icepick boost costs 2 BW")
	check(g.boost_pick(p.inst.uid) and g.bw == 2 and g.pick_str(p) == 4, "boosted to STR 4")
	g.end_turn()
	if g.phase == "CHOICE":
		g.choose(g.hand[0].uid)
	check(g.pick_str(p) == 4, "boost lasts the encounter")

func test_void_reveal() -> void:
	var g := Game.new(12)
	g.new_run()
	g.entered_corp = true
	start_node(g, 2, 1, "VOID_ICEPICK")   # DOORBELL CAM: [TRACE 3 + DEADLOCK]
	check(g.break_info(0, 0).reason == "HIDDEN", "VOID sub hidden on turn 1")
	var pv := g.response_preview()
	check(pv.size() == 1 and pv[0].hidden, "it still fires, unseen")
	g.end_turn()
	check(g.trace == 3 and g.enc.ice[0].seen[0], "fired and revealed (trace %d)" % g.trace)
	check(g.break_info(0, 0).reason != "HIDDEN", "revealed sub breakable on turn 2 (BW permitting)")
	# HOUSE CALL (VOID, 2 subs): response 1 fires sub 1, response 2 fires subs 1 and 2
	var h := g._new_ice("HOUSE_CALL")
	g.enc.ice.push_front(h)
	check(g.active_subs(0) == [0], "black VOID: only sub 1 fires first")
	g.break_sub(1, 0)
	var v0 := g.vitae
	g.end_turn()
	check(g.vitae == v0 - 6 and h.seen[0] and not h.seen[1], "HOUSE CALL sub 1 fired and revealed (vitae %d)" % g.vitae)
	check(g.active_subs(0) == [0, 1], "then subs 1 and 2")

func test_detainer_rules() -> void:
	var total := 0
	for row in IceDB.MAP:
		for n in row:
			for L in n.get("layers", []):
				check(IceDB.detainers_in(L.ice) <= 1, "at most 1 DETAINER in %s" % n.name)
				total += IceDB.detainers_in(L.ice)
	for id in IceDB.DEFS:
		if IceDB.is_detainer(id):
			check(IceDB.is_tumbler(id) and IceDB.def(id).subs[0][0].k == "BW_DRAIN", "%s: DETAINER is a TUMBLER with −1 BW at S1" % id)
	check(total >= 1, "the slice has a DETAINER")

func test_passives() -> void:
	var g := Game.new(13)
	g.new_run()
	g.entered_corp = true
	start_node(g, 1, 1, "FORTRESS_ICEPICK")   # COOKIE WALL: TOLL
	var c := g.break_info(0, 0)
	var dl := g.break_info(0, 3)
	check(c.cost == dl.cost + 1, "TOLL: +1 BW except on the DEADLOCK (%d vs %d)" % [c.cost, dl.cost])
	g = Game.new(14)
	g.new_run()
	g.entered_corp = true
	start_node(g, 3, 0, "FORTRESS_ICEPICK")   # TERMS & CONDITIONS layer 1: TOS SEQUENCED
	check(g.break_info(0, 2).reason == "BREAK S1 FIRST", "SEQUENCED blocks the DEADLOCK")
	g = Game.new(15)
	g.new_run()
	g.entered_corp = true
	start_node(g, 1, 0, "TUMBLER_ICEPICK")   # AUTO-RENEW (HARDENING) + CAPTCHA (TRIPWIRE)
	var s0 := g.ice_str(0)
	g.end_turn()
	if g.phase == "CHOICE":
		g.choose(g.hand[0].uid)
	check(g.ice_str(0) == s0 + 1, "HARDENING +1 STR after a response")
	g.bw = 10
	var t := g.trace
	var sub: int = g.active_subs(1)[0]
	if g.break_sub(1, sub):
		check(g.trace == t + 1, "TRIPWIRE adds TRACE 1 per break")
	g = Game.new(16)
	g.new_run()
	g.entered_corp = true
	start_node(g, 2, 1, "VOID_ICEPICK")
	g.layer = 1
	g._start_encounter()                    # CONSENT FORM (RELAY) + TERMS OF SERVICE
	check(g.ice_str(1) == 9, "RELAY gives the ICE to its right +2 STR")

func test_rustlers() -> void:
	# ECHO: no READY RIG, LOW PROFILE, SLOW DRIP, BORROWED CREDENTIALS
	var g := Game.new(21)
	g.new_run("ECHO")
	check(g.run_deck.size() == 12 and uid_of(g, g.run_deck, "HUSH") > 0, "ECHO starter deck")
	var probes := g.run_deck.filter(func(c): return c.id == "PROBE").size()
	var shields := g.run_deck.filter(func(c): return c.id == "PULP_SHIELD").size()
	check(probes == 3 and shields == 3 and uid_of(g, g.run_deck, "SLOW_DRIP") < 0 and uid_of(g, g.run_deck, "GHOST_SIGNAL") > 0, "ECHO-003: 3 PROBE, 3 PULP Shield, GHOST SIGNAL, no SLOW DRIP")
	var pool := CardDB.reward_pool("ECHO", "COMMON")
	check(pool.has("SLOW_DRIP") and not pool.has("GHOST_SIGNAL"), "SLOW DRIP in ECHO's pool; GHOST SIGNAL (a basic) is not offered")
	check(not CardDB.reward_pool("SHARED", "COMMON").has("GHOST_SIGNAL"), "GHOST SIGNAL is not offered to other Rustlers")
	g.enter_node(0)
	check(g.phase == "PLAYER", "ECHO skips READY RIG")
	g.add_trace(3, false)
	check(g.trace == 2, "LOW PROFILE: TRACE 3 becomes 2")
	g.trace = 0
	g.enc.trace_gained_enc = 0
	install(g, "SLOW_DRIP")
	var c0 := g.cred
	g.end_turn()
	check(g.cred - c0 >= 6, "SLOW DRIP extracts 6 when quiet (got %d)" % (g.cred - c0))
	g = Game.new(22)
	g.new_run("ECHO")
	g.entered_corp = true
	start_node(g, 1, 1, "")   # COOKIE WALL STR 5
	g.enc.ice[0].str_mod = -2
	install(g, "HUSH")
	g.installed[0].boost = 3
	var bd := put_in_hand(g, "BORROWED_CREDENTIALS")
	g.bw = 4
	g.cred = 8
	check(g.play_card(bd, 0) and g.phase == "PLAYER", "BORROWED CREDENTIALS requires an ICE and enables HUSH")
	check(g.break_info(0, 3).ok and g.bw == 3 and g.cred == 0, "HUSH can break the chosen ICE after 1 BW + 8 CRED payment")
	g.break_sub(0, 3)
	check(g.enc.breached and g.phase == "PLAYER", "HUSH breaks the DEADLOCK: BREACH")
	# RIOT: REDLINER, SLEDGE adds TRACE
	g = Game.new(23)
	g.new_run("RIOT")
	g.entered_corp = true
	start_node(g, 1, 1, "")
	install(g, "SLEDGE")
	g.bw = 4
	var t0 := g.trace
	g.break_sub(0, 0)
	check(g.trace == t0 + 1, "SLEDGE: each break +1 TRACE")
	g.trace = 25
	g.end_turn()
	check(g.bw == 5, "REDLINER: 5 BW at TRACE 20+ (got %d)" % g.bw)
	# VECTOR: PATIENT ZERO, INJECT, SCRAMBLE, RUNTIME ERROR
	g = Game.new(24)
	g.new_run("VECTOR")
	g.entered_corp = true
	start_node(g, 1, 1, "")   # COOKIE WALL STR 5
	check(g.enc.ice[0].virus.get("ROT", 0) == 1 and g.ice_str(0) == 4, "PATIENT ZERO: the chosen ICE gets 1 ROT, −1 STR")
	var inj := put_in_hand(g, "INJECT")
	g.bw = 4
	g.play_card(inj, 0)
	check(g.virus_total(0) == 3 and g.ice_str(0) == 2, "INJECT: +2 ROT")
	g.infect(0, "SCRAMBLE", 1)
	check(g.effect_value(g.enc.ice[0], {"k": "PULP", "v": 2}).v == 1, "SCRAMBLE: PULP 2 deals 1")
	var rt := put_in_hand(g, "RUNTIME_ERROR")
	g.bw = 4
	check(g.play_card(rt), "RUNTIME ERROR plays with 2+ virus counters")
	g.choose_sub(0, 3)
	check(g.enc.breached, "RUNTIME ERROR breaks the DEADLOCK")

func test_purge() -> void:
	var g := Game.new(31)
	g.new_run("VECTOR")
	g.entered_corp = true
	start_node(g, 1, 1, "")   # COOKIE WALL; PATIENT ZERO gives 1 ROT
	g.infect(0, "ROT", 9)     # 10 counters: HALCYON's limit
	var v0 := g.vitae
	var t0 := g.trace
	g.end_turn()
	if g.phase == "CHOICE":
		g.choose(g.hand[0].uid)
	check(g.virus_total(0) == 0, "PURGE removes every virus counter")
	check(g.vitae == v0 and g.trace == t0, "PURGE replaces the Corporation Response (no PULP, no TRACE)")
	check(g.enc.purge_limit == 15 and g.enc.purges == 1, "limit rises to 15 after a purge")
	g.infect(0, "ROT", 12)
	g.end_turn()
	if g.phase == "CHOICE":
		g.choose(g.hand[0].uid)
	check(g.virus_total(0) == 12, "12 counters is under the new limit: no purge")
	# INCUBATOR re-infects after a purge
	g = Game.new(32)
	g.new_run("VECTOR")
	g.entered_corp = true
	start_node(g, 1, 1, "")
	install(g, "INCUBATOR")
	g.infect(0, "ROT", 9)
	g.end_turn()
	if g.phase == "CHOICE":
		g.choose(g.hand[0].uid)
	check(g.enc.ice[0].virus.get("ROT", 0) == 2, "INCUBATOR: 2 ROT after the purge")

func test_shatter() -> void:
	var g := Game.new(41)
	g.new_run("RIOT")
	check(g.run_deck.size() == 15, "RIOT-002: 15-card deck")
	g.entered_corp = true
	start_node(g, 1, 0, "")   # AUTO-RENEW (FORTRESS) + CAPTCHA (TUMBLER)
	install(g, "SLEDGE")
	g.bw = 10
	var cap: int = g.active_subs(1)[0]
	check(g.break_info(1, cap).reason.begins_with("NO"), "SLEDGE can't break a TUMBLER")
	var sh := put_in_hand(g, "SHATTER")
	var t := g.trace
	check(g.play_card(sh, 1) and g.trace >= t + 3, "SHATTER on CAPTCHA (+3 TRACE)")
	check(g.break_info(1, cap).ok, "SLEDGE now breaks CAPTCHA")
	check(g.break_info(0, 0).ok, "SLEDGE still breaks FORTRESSES")
	g.break_sub(1, cap)
	g.end_turn()
	if g.phase == "CHOICE":
		g.choose(g.hand[0].uid)
	var sl: Dictionary = g._installed_entry(g.installed.filter(func(p): return p.inst.id == "SLEDGE")[0].inst.uid)
	check(g.pick_str(sl) == 0, "SLEDGE drops to STR 0 after the turn (got %d)" % g.pick_str(sl))
	check(g.break_info(1, g.active_subs(1)[0]).reason.begins_with("NO") or g.enc.ice[1].broken[g.active_subs(1)[0]], "SHATTER lasts one turn")

func test_pulp_curves() -> void:
	var g := Game.new(51)
	g.new_run()
	g.entered_corp = true
	start_node(g, 1, 1, "")   # COOKIE WALL: [S3] curve B
	var a_ice := {"corp_turns": 0, "curves": {"A": IceDB.CURVES.A.seq.duplicate()}, "virus": {}}
	var seen := []
	for t in 6:
		seen.append(g.effect_value(a_ice, {"k": "PULP_CURVE", "curve": "A"}).v)
		a_ice.corp_turns += 1
	check(seen == [2, 3, 4, 2, 3, 4], "curve A: 2, 3, 4 repeating (got %s)" % str(seen))
	var c := g._new_ice("TERMS_OF_SERVICE")
	c.corp_turns = 3
	check(g.effect_value(c, {"k": "PULP_CURVE", "curve": "C"}).v == 9, "curve C hammers 9 on its 4th response")
	var b := g._new_ice("COOKIE_WALL")
	var bs: Array = b.curves.B.duplicate()
	bs.sort()
	check(bs == [1, 2, 2, 2, 3, 3, 5, 6, 6], "curve B: the 9 values, shuffled")
	g.infect(0, "SCRAMBLE", 1)
	var raw: int = int(g.enc.ice[0].curves.B[0])
	check(g.effect_value(g.enc.ice[0], {"k": "PULP_CURVE", "curve": "B"}).v == maxi(0, raw - 1), "SCRAMBLE lowers a curve's PULP too")

func test_end_run() -> void:
	var g := Game.new(61)
	g.new_run("RIOT")
	g.enter_node(0)
	g.abandon()
	check(g.phase == "DEAD", "END RUN: the Rustler fails")

func test_patient_zero() -> void:
	var g := Game.new(71)
	g.new_run("VECTOR")
	g.enter_node(0)
	check(g.phase == "CHOICE" and g.pending.kind == "patient_zero", "VECTOR-001: PATIENT ZERO asks for an ICE")
	g.choose_ice(1)
	check(g.virus_total(0) == 0 and g.enc.ice[1].virus.get("ROT", 0) == 1 and g.phase == "PLAYER", "only the chosen ICE gets 1 ROT")

func test_worm() -> void:
	var g := Game.new(81)
	g.new_run("VECTOR")
	g.entered_corp = true
	start_node(g, 1, 1, "")   # COOKIE WALL
	g.infect(0, "WORM", 1)
	check(not g.worm_ok(0), "1 WORM isn't enough")
	g.infect(0, "WORM", 2)
	var bw0: int = g.bw
	g.installed.clear()   # no Icepick in the rig
	check(g.worm_ok(0) and g.use_worm(0) and g.phase == "CHOICE", "spend 2 WORM: choose a subroutine")
	check(g.enc.ice[0].virus.WORM == 1, "2 WORM removed")
	check(g.card_break_ok(0, 3) and not g.card_break_ok(1, 0) if g.enc.ice.size() > 1 else g.card_break_ok(0, 3), "only subroutines on that ICE")
	g.choose_sub(0, 3)
	check(g.enc.breached and g.phase == "PLAYER", "WORM breaks the chosen DEADLOCK")
	g.infect(0, "WORM", 2)
	var bw1: int = g.bw
	check(bw1 == bw0, "WORM costs no BW, even on a TOLL ICE")
	g.enc.ice[0].broken[0] = false
	check(g.worm_ok(0) and g.use_worm(0), "no Icepick and no STR needed (STR 5 ICE)")
	g.choose_sub(0, 0)
	check(g.bw == bw0 and g.enc.ice[0].broken[0], "TOLL subroutine broken for 0 BW")
	g.infect(0, "WORM", 2)
	g.phase = "RESPONSE"
	check(not g.worm_ok(0), "WORM can't be used outside your turn")

func test_extraction_reserve_cap() -> void:
	var g := Game.new(5)
	g.new_run()
	g.entered_corp = true
	start_node(g, 1, 0, "BASIC_EXTRACTOR")   # reserve 10
	# This fixture measures four payouts, independently of encounter damage.
	g.vitae = 100
	g.max_vitae = 100
	check(CardDB.def("BASIC_EXTRACTOR").extract == 3, "EXTRACT-002: Basic Extractor pays 3 CRED per turn")
	g.end_turn()
	if g.phase == "CHOICE":
		g.choose(g.hand[0].uid)
	check(g.cred == 3 and g.enc.reserve == 7, "extract 3 (got %d)" % g.cred)
	g.end_turn()
	if g.phase == "CHOICE":
		g.choose(g.hand[0].uid)
	check(g.cred == 6 and g.enc.reserve == 4, "second turn extracts another 3 CRED")
	g.end_turn()
	if g.phase == "CHOICE":
		g.choose(g.hand[0].uid)
	check(g.cred == 9 and g.enc.reserve == 1, "third turn leaves 1 CRED in the reserve")
	g.end_turn()
	if g.phase == "CHOICE":
		g.choose(g.hand[0].uid)
	check(g.cred == 10 and g.enc.reserve == 0, "final extraction is capped at the remaining 1 CRED, with no bonus")
	for reserve in [10, 15, 25, 40]:
		var capped := Game.new(108)
		capped.new_run("ECHO")
		capped.enter_node(0)
		capped.enc.reserve = reserve
		capped.enc.reserve_start = reserve
		capped.cred = 7
		capped.events.clear()
		capped.extract(5)
		check(capped.cred == 12 and capped.enc.reserve == reserve - 5, "partial extraction transfers only actual CRED")
		capped.extract(100)
		check(capped.cred == 7 + reserve and capped.enc.reserve == 0, "%d reserve pays at most %d, no rounded-up bonus" % [reserve, reserve])
		capped.extract(100)
		capped.extract(0)
		check(capped.cred == 7 + reserve and capped.enc.reserve == 0, "empty reserve never generates more CRED")
		check(capped.events.filter(func(e): return e.t == "EV-09").size() == 1, "full-extraction notification fires once, not on repeated empty extraction")
		check(not capped.log.any(func(line): return "CRED bonus" in line), "extraction no longer logs a CRED bonus")
	var echo := Game.new(109)
	echo.new_run("ECHO")
	echo.enter_node(0)
	install(echo, "BASIC_EXTRACTOR")
	for _i in 5:
		echo.end_turn()
	check(echo.enc.reserve == 0 and echo.cred == 15, "ECHO + Basic Extractor empties COOKIE BANNER in five 3-CRED payouts, not 17 CRED")

func test_rainbow_and_toolbelt() -> void:
	var g := Game.new(6)
	g.new_run()
	g.entered_corp = true
	start_node(g, 2, 1, "TUMBLER_ICEPICK")   # DOORBELL node, layer 1 DOORBELL CAM (VOID)
	g.layer = 1
	g._start_encounter()                    # CONSENT FORM + TERMS OF SERVICE
	install(g, "RAINBOW_TABLE")
	g.bw = 4
	# CONSENT FORM STR 4; RAINBOW TABLE STR 2: 2 boosts + break = 3 BW, second break on same ICE free
	var c1 := g.break_info(0, 0)
	check(c1.ok and c1.cost == 3, "rainbow first break 3 BW (got %s)" % str(c1))
	g.break_sub(0, 0)
	check(g.break_info(0, 1).cost == 0, "rainbow second break free")
	install(g, "TOOLBELT")
	g.bw = 4
	install(g, "FORTRESS_ICEPICK")
	g.bw = 4
	# TERMS OF SERVICE STR 7 vs FORTRESS Icepick STR 1: 6 boosts at 1 BW, first boost free (TOOLBELT), first break free
	var c2 := g.break_info(1, 0)
	check(c2.cost == 7, "TOOLBELT (TOS STR 9 with CONSENT FORM's RELAY) makes the first boost free (got %s)" % str(c2))

func test_spam_and_filter() -> void:
	var g := Game.new(7)
	g.new_run()
	g.enter_node(0)
	g.choose_ready_rig(uid_of(g, g.draw_pile, "TUMBLER_ICEPICK"))
	var sf := put_in_hand(g, "SPAM_FILTER")
	g.play_card(sf)
	g.end_turn()   # turn 1: ACCEPT ALL −1 BW
	g.end_turn()   # turn 2: ACCEPT ALL inserts SPAM into draw pile -> filtered to discard
	check(g.enc.spam_filter_used, "SPAM FILTER sent the SPAM to the discard pile")
	var sp := put_in_hand(g, "SPAM")
	var bw0 := g.bw
	g.play_card(sp)
	check(g.bw == bw0 - 1 and uid_of(g, g.burned, "SPAM") > 0, "SPAM cleared for 1 BW, BURNED")

func test_cloak_reactive() -> void:
	var g := Game.new(8)
	g.new_run()
	g.entered_corp = true
	start_node(g, 2, 1, "VOID_ICEPICK")   # DOORBELL CAM
	var u := put_in_hand(g, "PULP_SHIELD")
	g.play_card(u)
	check(g.trace == 1, "DOORBELL CAM: CLOAK card adds TRACE 1")

func test_go_deeper_keeps_programs() -> void:
	var g := Game.new(9)
	g.new_run()
	g.entered_corp = true
	start_node(g, 1, 1, "FORTRESS_ICEPICK")   # COOKIE WALL (FORTRESS 3) then CONSENT FORM
	# FORTRESS Icepick STR 1 vs COOKIE WALL STR 5 → 4 boosts (4 BW) + free first break
	check(g.break_info(0, 3).cost == 4, "COOKIE WALL DEADLOCK costs 4 BW")
	g.break_sub(0, 3)
	check(g.enc.breached, "COOKIE WALL breached")
	g.end_turn()
	check(g.phase == "DEEPER", "go deeper or leave")
	g.go_deeper()
	check(g.layer == 1 and g.installed.size() == 1 and g.installed[0].boost == 0, "programs stay, boosts reset")
	check(g.enc.ice[0].id == "CONSENT_FORM", "layer 2 ICE")

func smash_fixture() -> Game:
	var g := Game.new(105)
	g.new_run("RIOT")
	g.enter_node(0)
	install(g, "SMASH_AND_GRAB")
	g.bw = 4
	return g

func test_smash_and_grab_cache() -> void:
	var d := CardDB.def("SMASH_AND_GRAB")
	check(d.bw == 1 and d.ram == 1 and d.extract == 3, "RIOT-005: install 1 BW / 1 RAM, extract 3 CRED")
	for start_trace in [19, 20]:
		var payout := smash_fixture()
		payout.trace = start_trace
		payout.enc.breached = true
		payout.end_turn()
		check(payout.enc.reserve == 12, "SMASH & GRAB extracts 3 from the reserve")
		check(payout.trace == (20 if start_trace == 19 else 20), "SMASH & GRAB adds 1 TRACE only below 20")
	var g := smash_fixture()
	var program: int = g.installed[0].inst.uid
	var target := put_in_hand(g, "PULP_SHIELD")
	var before_ram := g.ram_used()
	g.bw = 0
	check(not g.uninstall_cache(program) and g.installed.size() == 1, "paid CACHE requires 1 BW without uninstalling on failure")
	g.bw = 4
	check(not g.uninstall_cache(-1) and g.bw == 4, "paid CACHE rejects an invalid source without spending BW")
	check(g.uninstall_cache(program), "paid CACHE opens the hand choice")
	check(g.bw == 3 and g.ram_used() == before_ram - 1 and uid_of(g, g.discard, "SMASH_AND_GRAB") == program, "paid uninstall costs 1 BW, frees RAM, and discards the Program")
	check(g.pending.kind == "cache" and g.pending.options.has(target) and not g.pending.options.has(program), "another hand card is selected, not SMASH & GRAB")
	g.choose(program)
	check(g.phase == "CHOICE", "discarded Program cannot be chosen for CACHE")
	g.choose(target)
	var chosen := g._find(g.hand, target)
	check(g.phase == "PLAYER" and chosen.cached and chosen.cache_turns == 2, "chosen hand card is CACHED until next turn ends")
	# Ensure cleanup, rather than a possible immediate redraw, controls visibility.
	g.draw_pile.clear()
	for _i in 30:
		g.draw_pile.append(g._new_inst("PROBE"))
	var reserve: int = g.enc.reserve
	g.end_turn()
	check(not g._find(g.hand, target).is_empty() and chosen.cached and chosen.cache_turns == 1, "CACHE survives the activation turn cleanup and next normal draw")
	check(g.enc.reserve == reserve, "uninstalled SMASH & GRAB no longer extracts")
	g.animate = true
	g.end_turn()
	check(g.phase == "RESPONSE" and not chosen.cached and not chosen.has("cache_turns"), "CACHE expires at the END of next Rustler turn, before the response")
	g._continue_response()
	check(g._find(g.hand, target).is_empty() and uid_of(g, g.discard, "PULP_SHIELD") > 0, "expired card follows normal post-response cleanup")
	var layers := Game.new(106)
	layers.new_run("RIOT")
	layers.row = 0
	layers.available = [1]
	layers.enter_node(1)
	install(layers, "SMASH_AND_GRAB")
	var across := put_in_hand(layers, "PULP_SHIELD")
	layers.uninstall_cache(layers.installed[0].inst.uid)
	layers.choose(across)
	var retained := layers._find(layers.hand, across)
	layers.enc.breached = true
	layers.end_turn()
	check(layers.phase == "DEEPER" and retained.cached and retained.cache_turns == 1, "CACHE survives a breached layer's cleanup")
	layers.go_deeper()
	check(layers.enc.turn == 1 and retained.cached and retained.cache_turns == 1, "layer transition does not consume or reset the duration")
	layers.animate = true
	layers.end_turn()
	check(not retained.cached, "CACHE expires next Rustler turn even though layer turn counter reset")
	var played := smash_fixture()
	var play_target := put_in_hand(played, "PULP_SHIELD")
	played.uninstall_cache(played.installed[0].inst.uid)
	played.choose(play_target)
	check(played.play_card(play_target), "temporarily CACHED card is playable")
	var played_card := played._find(played.discard, play_target)
	check(not played_card.cached and not played_card.has("cache_turns"), "playing a card removes temporary CACHE before a future redraw")
	var ordinary := smash_fixture()
	var permanent := put_in_hand(ordinary, "PROBE")
	ordinary._find(ordinary.hand, permanent).cached = true
	ordinary.uninstall_cache(ordinary.installed[0].inst.uid)
	ordinary.choose(permanent)
	ordinary.end_turn()
	ordinary.end_turn()
	check(ordinary._find(ordinary.hand, permanent).cached and not ordinary._find(ordinary.hand, permanent).has("cache_turns"), "existing indefinite CACHE is not shortened")
	var empty := smash_fixture()
	empty.hand.clear()
	check(not empty.uninstall_cache(empty.installed[0].inst.uid) and empty.bw == 4 and empty.installed.size() == 1, "no hand target: no BW spent and no uninstall")
	var free := smash_fixture()
	free.unload(free.installed[0].inst.uid)
	check(free.bw == 4 and free.phase == "PLAYER" and free.pending.is_empty(), "ordinary free unload does not grant CACHE")

func reward_fixture(map_row: int = 1, map_index: int = 1) -> Game:
	var g := Game.new(107)
	g.new_run()
	g.entered_corp = true
	start_node(g, map_row, map_index, "BASIC_EXTRACTOR")
	g.installed.clear()
	g.trace = 5
	g.trace_gained_node = 5
	g.cred = 17
	return g

func test_node_card_reward_requires_full_clear() -> void:
	var early := reward_fixture()
	var deck_size := early.run_deck.size()
	early.enc.breached = true
	early.end_turn()
	check(early.phase == "DEEPER" and early.reward_options.is_empty(), "CORE-011: first layer offers deeper/leave, not cards")
	# Stale offers must not survive the early-exit path or be claimable later.
	early.reward_options = ["DEEP_PROBE"]
	early.reward_note = "stale reward"
	early.events.clear()
	var rng_before: int = early.rng.state
	early.leave_node()
	check(early.phase == "MAP" and early.row == 1 and early.available == [0, 1], "early exit advances directly to the next map choices")
	check(early.reward_options.is_empty() and early.reward_note == "", "early exit clears reward offers and text")
	check(not early.events.any(func(e): return e.t == "EV-27"), "early exit does not emit a card-reward event")
	check(early.rng.state == rng_before, "early exit does not roll card rewards")
	check(early.cred == 17 and early.run_deck.size() == deck_size, "early exit preserves banked CRED without adding cards")
	check(early.enc.is_empty() and early.hand.is_empty() and early.installed.is_empty(), "early exit performs normal Node cleanup")
	early.choose_reward("DEEP_PROBE")
	check(early.run_deck.size() == deck_size, "no reward can be claimed after early exit")
	var three := reward_fixture()
	three.node = three.node.duplicate(true)
	three.node.layers.append(three.node.layers[1].duplicate(true))
	three.enc.breached = true
	three.end_turn()
	three.go_deeper()
	three.enc.breached = true
	three.end_turn()
	check(three.phase == "DEEPER" and three.layers_cleared == 2, "three-layer fixture has two breached layers")
	three.leave_node()
	check(three.phase == "MAP" and three.reward_options.is_empty(), "two of three layers cleared still earns no card reward")
	var full := reward_fixture()
	full.enc.breached = true
	full.end_turn()
	full.go_deeper()
	full.enc.breached = true
	full.end_turn()
	check(full.phase == "REWARD" and full.reward_options.size() == 3 and full.layers_cleared == 2, "breaching the final layer still offers three cards")
	full.choose_reward(full.reward_options[0])
	check(full.run_deck.size() == deck_size + 1 and full.phase == "MAP", "full-clear card reward remains claimable")
	var final_map := reward_fixture(3, 0)
	final_map.enc.breached = true
	final_map.end_turn()
	final_map.leave_node()
	check(final_map.phase == "SLICE_DONE" and final_map.reward_options.is_empty(), "early exit from the last map Node ends the slice without a card reward")
	var locked := reward_fixture()
	locked.enc.breached = true
	locked.end_turn()
	locked.lockdown = true
	locked.leave_node()
	check(locked.phase == "DEEPER", "LOCKDOWN still prohibits early exit")
	var clean := reward_fixture()
	clean.trace_gained_node = 0
	clean.enc.breached = true
	clean.end_turn()
	clean.leave_node()
	check(clean.cred == 17 + Game.CLEAN_NODE_BONUS and clean.reward_options.is_empty(), "existing clean-node CRED bonus is unchanged; no card is awarded")

func test_full_slice_path() -> void:
	## A simple bot plays the whole slice: break the cheapest subroutines, prioritising DEADLOCKs.
	var g := Game.new(10)
	g.new_run()
	var guard := 0
	while g.phase != "SLICE_DONE" and g.phase != "DEAD" and guard < 2000:
		guard += 1
		match g.phase:
			"MAP": g.enter_node(g.available[0])
			"READY_RIG": g.choose_ready_rig(bot_rig(g))
			"SAFEHOUSE": g.safehouse_heal()
			"DEEPER": g.go_deeper()
			"REWARD": g.choose_reward(g.reward_options[0])
			"CHOICE": g.choose(g.pending.get("options", [g.hand[0].uid if not g.hand.is_empty() else -1])[0])
			"PLAYER": bot_turn(g)
	check(g.phase == "SLICE_DONE" or g.phase == "DEAD", "bot finishes the slice (phase %s, row %d)" % [g.phase, g.row])
	print("  bot: phase=%s vitae=%d trace=%d strikes=%d cred=%d deck=%d steps=%d" % [g.phase, g.vitae, g.trace, g.strikes, g.cred, g.run_deck.size(), guard])

func sim_many() -> void:
	for who in ["GENERALIST", "ECHO", "RIOT", "VECTOR"]:
		if OS.get_environment("SIM_ONLY") == "" or OS.get_environment("SIM_ONLY") == who:
			sim_rustler(who)

func sim_rustler(who: String) -> void:
	var done := 0
	var ps := {"incoming": 0, "absorbed": 0, "hits": 0, "black": 0, "encounters": 0}
	var purges := 0
	var purge_runs := 0
	var shat := 0
	var shat_runs := 0
	var rows := {}
	var stalled := {}
	var vit := []
	var opener_turns := []
	for seed in range(100, 130):
		var g := Game.new(seed)
		g.new_run(who)
		var guard := 0
		while g.phase != "SLICE_DONE" and g.phase != "DEAD" and guard < 3000:
			guard += 1
			match g.phase:
				"MAP": g.enter_node(g.available[g.rng.randi_range(0, g.available.size() - 1)])
				"READY_RIG": g.choose_ready_rig(bot_rig(g))
				"SAFEHOUSE": g.safehouse_heal()
				"DEEPER": g.go_deeper()
				"REWARD": g.choose_reward(g.reward_options[0])
				"CHOICE":
					if g.pending.kind == "card_break":
						bot_choose_sub(g)
					elif g.pending.kind == "patient_zero":
						g.choose_ice(main_ice(g))
					else:
						g.choose(g.pending.get("options", [g.hand[0].uid if not g.hand.is_empty() else -1])[0])
				"PLAYER":
					bot_turn(g)
					if g.node.get("opening", false) and g.enc.get("breached", false):
						opener_turns.append(g.enc.turn)
		purges += g.purges_run
		for k in ps:
			ps[k] += g.pulp_stats[k]
		shat += int(g.played.get("SHATTER", 0))
		if g.played.has("SHATTER"):
			shat_runs += 1
		if g.purges_run > 0:
			purge_runs += 1
		if g.phase == "SLICE_DONE":
			done += 1
			vit.append(g.vitae)
		elif g.phase == "DEAD":
			rows[g.node.get("name", "?")] = rows.get(g.node.get("name", "?"), 0) + 1
		else:
			stalled[g.node.get("name", "?")] = stalled.get(g.node.get("name", "?"), 0) + 1
	if not opener_turns.is_empty():
		print("  opening %s: earliest BREACH %s" % [who, opener_turns.min()])
	if not stalled.is_empty():
		print("  stalled %s (3000-step guard, not deaths): %s" % [who, str(stalled)])
	var avg := 0.0
	for x in vit:
		avg += x
	var en: float = max(1, ps.encounters)
	print("  pulp %s: per encounter %.1f incoming (%.1f from Black ICE), %.1f absorbed by SHIELD, %.1f to VITAE, %.1f hits" % [who, ps.incoming / en, ps.black / en, ps.absorbed / en, (ps.incoming - ps.absorbed) / en, ps.hits / en])
	print("  sim %s: %d/30 cleared; deaths by node %s; survivors' avg end VITAE %.1f; purges %d in %d runs; SHATTER played %d times in %d runs" % [who, done, str(rows), avg / max(1, vit.size()), purges, purge_runs, shat, shat_runs])

func needed_types(g: Game) -> Array:
	var t := ["TUMBLER"] if g.rustler == "ECHO" else []
	for L in g.node.layers:
		for id in L.ice:
			t.append(IceDB.def(id).type)
	return t

func bot_rig(g: Game) -> int:
	var t := needed_types(g)
	for u in g.pending.options:
		var d := CardDB.def(g._find(g.draw_pile, u).id)
		if d.has("pick") and (t.has(d.pick.itype) or d.pick.itype == "ANY"):
			return u
	return g.pending.options[0]

func main_ice(g: Game) -> int:
	## The ICE the bot pushes on: the one with the most unbroken DEADLOCKs, rightmost on ties.
	var best: int = g.enc.ice.size() - 1
	var most := -1
	for i in g.enc.ice.size():
		var d := IceDB.def(g.enc.ice[i].id)
		var n := 0
		for s in d.subs.size():
			if Game._has_deadlock(d.subs[s]) and not g.enc.ice[i].broken[s]:
				n += 1
		if n >= most:
			most = n
			best = i
	return best

func trace_safe(g: Game, d: Dictionary) -> bool:
	return g.trace + int(d.get("trace_cost", 0)) < 38

func bot_choose_sub(g: Game) -> void:
	var targets: Array = g._breaker_targets(g.pending.breaker, g.pending.ice)
	var pick: Vector2i = targets[0]
	for t in targets:
		if Game._has_deadlock(IceDB.def(g.enc.ice[t.x].id).subs[t.y]):
			pick = t
	g.choose_sub(pick.x, pick.y)

func bot_turn(g: Game) -> void:
	# install what this Node needs, weaken the main ICE, break what it can, then defend.
	var t := needed_types(g)
	t.append("VOID")  # HOUSE CALL
	for c in g.hand.duplicate():
		var d := CardDB.def(c.id)
		if d.type == "PROGRAM" and g.can_play(c.uid).ok:
			if not d.has("pick") or t.has(d.pick.itype) or d.pick.itype == "ANY":
				g.play_card(c.uid)
	# TRACE sense: shed TRACE when close to a strike before spending BW elsewhere.
	if g.trace >= 28:
		for c in g.hand.duplicate():
			if c.id in ["LAY_LOW", "CRASH_CART", "SCRUB", "MUFFLE", "NO_WITNESSES", "BURN_NOTICE"] and g.can_play(c.uid).ok:
				g.play_card(c.uid)
	var m := main_ice(g)
	var progress := true
	var guard := 0
	while progress and guard < 40 and g.phase == "PLAYER" and not g.enc.breached:
		guard += 1
		progress = false
		m = main_ice(g)
		# 1. card breaks first (they are the scarce way through off-type ICE)
		for c in g.hand.duplicate():
			var d := CardDB.def(c.id)
			if (d.has("breaker") or c.id == "FLASHPOINT") and g.can_play(c.uid).ok and trace_safe(g, d):
				var tgt := m
				if d.has("breaker") and d.breaker.get("same_ice", false):
					for i in g.enc.ice.size():
						if not g._breaker_targets(d.breaker, i).is_empty():
							tgt = i
				if g.play_card(c.uid, tgt):
					while g.phase == "CHOICE" and g.pending.get("kind", "") == "card_break":
						bot_choose_sub(g)
					progress = true
					break
		if progress:
			continue
		# 1b. RIOT: SHATTER the main ICE so SLEDGE can break it this turn
		if g.enc.get("shatter_ice") == null and g.installed.any(func(p): return p.inst.id == "SLEDGE") and IceDB.def(g.enc.ice[m].id).type != "FORTRESS":
			for c in g.hand.duplicate():
				if c.id == "SHATTER" and g.can_play(c.uid).ok and trace_safe(g, CardDB.def(c.id)):
					g.play_card(c.uid, m)
					progress = true
					break
		if progress:
			continue
		# 1c. VECTOR: spend WORM to break
		for i in g.enc.ice.size():
			if g.worm_ok(i) and g.use_worm(i):
				bot_choose_sub(g)
				progress = true
				break
		if progress:
			continue
		# 2. Icepick breaks (rescan after each: a break can add Black ICE on the left)
		for i in g.enc.ice.size():
			if progress:
				break
			for s in IceDB.def(g.enc.ice[i].id).subs.size():
				if g.phase == "PLAYER" and g.break_info(i, s).ok:
					g.break_sub(i, s)
					progress = true
					break
		if progress:
			continue
		# 3. one useful targeted script: weaken or infect the main ICE while that still matters
		for c in g.hand.duplicate():
			var d := CardDB.def(c.id)
			if d.type != "SCRIPT" or not d.get("target", false) or d.has("breaker") or c.id in ["QUARANTINE", "SHATTER"] or not g.can_play(c.uid).ok or not trace_safe(g, d):
				continue
			if d.has("target_type") and IceDB.def(g.enc.ice[m].id).type != d.target_type:
				continue
			var useful: bool = g.ice_str(m) > 0 or (d.has("infect") and g.virus_total(m) < 2)
			if c.id == "PANDEMIC" or c.id == "OUTBREAK":
				useful = g.virus_total(m) >= 2 and g.ice_str(m) > 0
			if c.id == "BORROWED_CREDENTIALS":
				useful = false
				for p in g.installed:
					if p.inst.id == "HUSH" and IceDB.def(g.enc.ice[m].id).type in ["FORTRESS", "VOID"]:
						var need := maxi(0, g.ice_str(m) - g.pick_str(p))
						useful = g.bw >= 2 + need * 2 and not g.enc.get("borrowed_ice", []).any(func(x): return is_same(x, g.enc.ice[m]))
			if useful and g.play_card(c.uid, m):
				progress = true
				break
	for c in g.hand.duplicate():
		var d := CardDB.def(c.id)
		if g.phase != "PLAYER" or d.type != "SCRIPT" or d.get("target", false) and c.id != "QUARANTINE" or d.has("breaker"):
			continue
		if c.id in ["NO_WITNESSES", "BURN_NOTICE"] and g.trace < 30:
			continue
		if g.can_play(c.uid).ok and trace_safe(g, d):
			g.play_card(c.uid, m)
			if g.phase == "CHOICE" and g.pending.get("kind", "") == "cache":
				g.choose(g.pending.options[0])
	# bank leftover BW into boosts (they last the encounter)
	for p in g.installed:
		if g.bw > 0 and CardDB.def(p.inst.id).has("pick") and t.has(CardDB.def(p.inst.id).pick.itype):
			while g.can_boost(p.inst.uid).ok and g.can_boost(p.inst.uid).cost > 0:
				g.boost_pick(p.inst.uid)
	if g.phase == "PLAYER":
		g.end_turn()
