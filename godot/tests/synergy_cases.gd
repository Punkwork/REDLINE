extends RefCounted
var check: Callable
func game(who: String = "GENERALIST") -> Game:
 var g := Game.new(400)
 g.new_run(who)
 return g
func run() -> void:
 step1()
 step2()
 step3()
 step4()
 step5()
 pacing()
 edge_regressions()
 engine_amp_regressions()
 coverage_and_escalation_regressions()
 ordered_compile_regression()
 null_pointer_strike_regression()
 zeroed_lifecycle()
 zeroed_cards()
 tumbler_removal()
 selected_icepick()
func step1() -> void:
 var g := game()
 check.call(g.footprint() == 12 and g.footprint_cap() == 22 and g.footprint_band() == "GHOST", "DSY footprint baseline")
 g.run_deck.append(g._new_inst("SPAM"))
 check.call(g.footprint() == 12, "Bloatware excluded from FOOTPRINT")
 g.corporation = "IRONWATCH"
 check.call(g.footprint_cap() == 29, "IRONWATCH cap 29")
 g.corporation = "LUCIDA"
 check.call(g.footprint_cap() == 35, "LUCIDA cap 35")
 check.call(g.coverage().values().all(func(x): return x), "starter coverage")
 var pick: Dictionary = g.run_deck.filter(func(c): return c.id == "VOID_ICEPICK")[0]
 check.call(not g.can_decompile(pick.uid).ok, "coverage guard blocks last VOID breaker")
 g.run_deck.append(g._new_inst("BRUTE_FORCE"))
 check.call(g.can_decompile(pick.uid).ok, "fallback preserves coverage")
 g.run_deck.resize(10)
 check.call(not g.can_decompile(g.run_deck[0].uid).ok, "10-card floor")
 var heavy := game("RIOT")
 for i in 10: heavy.run_deck.append(heavy._new_inst("PROBE"))
 heavy.enter_node(0)
 check.call(heavy.bloat_tax_paid == 3 and heavy.trace == 3, "25-card HALCYON deck pays TRACE 3")
 var normal := game("ECHO")
 normal.enter_node(0)
 check.call(normal.hand.size() == 6, "DSY-001b OFF by default")
 var optional := game("ECHO")
 optional.ghost_draw_enabled = true
 optional.enter_node(0)
 check.call(optional.hand.size() == 7, "optional GHOST draw")
 var lean := game()
 check.call(is_equal_approx(lean.draw_chance("PROBE"), 100.0), "duplicate-aware draw chance bounded at 100")
 check.call(lean.tag_density().EXPLOIT == 3, "tag density counts physical copies")
 lean.phase = "REWARD"
 lean.begin_decompile()
 var cut: Dictionary = lean.run_deck.filter(func(c): return c.id == "PROBE")[0]
 lean.node = IceDB.MAP[0][0]
 check.call(lean.decompile(cut.uid) and lean.footprint() == 11 and lean.phase == "MAP", "DECOMPILE takes removal instead of reward")
func step2() -> void:
 var g := game("ECHO")
 g.enter_node(0)
 g.hand.clear(); g.draw_pile.clear(); g.discard.clear()
 g.rack.append(g._new_inst("WARM_BOOT"))
 g.rack.append(g._new_inst("ROLLING_RESTART"))
 g.amp = 2
 var a := g._new_inst("PROBE")
 var b := g._new_inst("PULP_SHIELD")
 g.draw_pile.append(a); g.discard.append(b)
 g.draw_cards(2)
 check.call(g.hand.size() == 2 and g.reboots == 1 and g.shield == 7 and g.amp == 3, "mid-draw REBOOT finishes draw before ENGINE effects; AMP applies")
 g.draw_cards(2)
 check.call(g.reboots == 1, "empty draw and discard do not REBOOT")
 g.discard.append(g._new_inst("PROBE"))
 var f := g._new_inst("FORCE_REBOOT")
 g.hand.append(f)
 check.call(g.play_card(f.uid) and g._find(g.burned, f.uid).id == "FORCE_REBOOT", "FORCE REBOOT burns itself")
 check.call(g.reboots == 2, "explicit forced shuffle is a REBOOT")
 g.hand.clear(); g.draw_pile.clear(); g.discard.clear(); g.rack.clear()
 var top := g._new_inst("PROBE")
 var mid := g._new_inst("PULP_SHIELD")
 var bottom := g._new_inst("DEFRAG")
 g.draw_pile.assign([bottom, mid, top])
 var scan := g._new_inst("PORT_SCAN"); g.hand.append(scan)
 g.play_card(scan.uid)
 check.call(g.phase == "CHOICE" and g.pending.cards[0].uid == top.uid, "SCAN reveals top cards in draw order")
 g.choose(top.uid); g.choose(mid.uid); g.finish_scan()
 check.call(g.hand[0].uid == bottom.uid and g.draw_pile.pop_back().uid == top.uid and g.draw_pile.pop_back().uid == mid.uid, "SCAN chooses any cards and their bottom order, then draws")
 g.hand.clear(); g.draw_pile.clear(); g.discard.clear()
 var burn := g._new_inst("GARBAGE_COLLECT"); g.hand.append(burn)
 check.call(not g.can_play(burn.uid).ok, "GARBAGE COLLECT needs another hand card")
 var victim := g._new_inst("PROBE"); g.hand.append(victim)
 g.play_card(burn.uid); g.choose(victim.uid)
 check.call(not g._find(g.burned, victim.uid).is_empty() and g.run_deck.size() == 12, "in-Node BURN preserves permanent deck")
 var tail := g._new_inst("TAIL_CALL"); g.hand.append(tail)
 var retrieve := g._new_inst("PROBE"); g.discard.append(retrieve)
 g.bw = 4; g.play_card(tail.uid)
 check.call(not g.pending.options.has(tail.uid), "TAIL CALL cannot retrieve itself while resolving")
 g.choose(retrieve.uid)
 check.call(not g._find(g.hand, retrieve.uid).is_empty(), "TAIL CALL retrieves the selected SCRIPT")
 var fresh := game("ECHO"); fresh.enter_node(0)
 check.call(fresh.amp == 0 and fresh.burned.is_empty(), "Node begins with no AMP or burned cards")
func step3() -> void:
 var g := game("ECHO"); g.enter_node(0)
 g.hand.clear(); g.bw = 30
 var shield := g._new_inst("PULP_SHIELD"); g.hand.append(shield); g.play_card(shield.uid)
 var pivot := g._new_inst("PIVOT"); g.hand.append(pivot)
 var before := g.ice_str(0)
 g.play_card(pivot.uid, 0)
 check.call(g.ice_str(0) == maxi(0, before - 1), "PIVOT: −1 STR, no CHAIN bonus after CLOAK (CSA-04d, CHAIN-PARK-001)")
 var tags: Array = g.enc.last_tags.duplicate()
 g.installed.append({"inst": g._new_inst("TUMBLER_ICEPICK"), "boost": 5, "free_used": false})
 g.break_sub(0, 0)
 check.call(g.enc.last_tags == tags, "Icepick use does not change CHAIN")
 var cover := g._new_inst("COVER_FIRE"); g.hand.append(cover)
 var shield_before := g.shield
 g.play_card(cover.uid)
 check.call(g.shield == shield_before + 5, "COVER FIRE CHAIN EXPLOIT")
 var cleanup := game("ECHO"); cleanup.enter_node(0)
 var cached: Dictionary = cleanup.hand[0]
 cached.cached = true
 var old_hand: Array = cleanup.hand.slice(1)
 cleanup.end_turn()
 check.call(cleanup.phase == "PLAYER" and cleanup.enc.turn == 2, "END TURN proceeds directly to the next turn")
 check.call(cleanup.hand.size() == Game.BASE_DRAW + 1, "draw six in addition to a cached card")
 check.call(cleanup._find(cleanup.hand, cached.uid).cached, "genuine CACHE survives")
 check.call(old_hand.all(func(card): return not cleanup._find(cleanup.discard, card.uid).is_empty()), "all uncached cards are discarded")
 var chain := game("ECHO"); chain.enter_node(0); chain.bw = 30
 chain.rack.append(chain._new_inst("KILL_CHAIN"))
 chain.hand.clear(); chain.draw_pile.clear(); chain.discard.clear()
 for i in 6: chain.draw_pile.append(chain._new_inst("PROBE"))
 for i in 4:
  var h := chain._new_inst("HANDOFF"); chain.hand.append(h); chain.play_card(h.uid)
 check.call(chain.enc.chain_draws.values()[0] == 2 and chain.draw_pile.size() == 1, "KILL CHAIN capped at two triggers; HANDOFF has three direct chain draws")
 chain.end_turn()
 check.call(chain.enc.last_tags.is_empty(), "CHAIN resets each Rustler turn")

func step4() -> void:
 var g := game("ECHO"); g.enter_node(0); g.hand.clear(); g.bw = 30
 g.reduce_ice_str(0, 10)
 check.call(g.ice_str(0) == 0 and g.enc.ice[0].str_mod == -4, "ZEROED floor discards excess ordinary reduction")
 check.call(g.enc.ice[0].zeroed, "ordinary reduction consumes first ZEROED")
 g.enc.ice[0].str_floor = 3
 check.call(g.ice_str(0) == 3, "explicit STR floor remains")
 g.enc.ice[0].erase("str_floor"); g.enc.ice[0].harden = 2; g._sync_strengths()
 check.call(g.ice_str(0) == 2, "HARDENING rises from zero without hidden debt")
 g.reduce_ice_str(0, 2)
 g.installed.append({"inst": g._new_inst("SCALPEL"), "boost": 0, "free_used": false})
 check.call(g.break_info(0, 0).margin == 2 and g.break_info(0, 0).cost == 0, "SCALPEL OVERKILL uses nonnegative ICE STR")
 g.amp = 2; g.infect(0, "ROT", 10)
 check.call(g.ice_str(0) == 0 and g.enc.ice[0].virus.ROT == 10, "ROT retains spare counters at minimum zero")
 g.infect(0, "LEECH", 4)
 var c := g._new_inst("CULL"); g.hand.append(c); g.play_card(c.uid, 0)
 g.cull_strain("ROT"); g.cull_strain("LEECH"); g.cull_strain("LEECH")
 check.call(g.shield == 6 and g.enc.ice[0].virus.LEECH == 2 and g.phase == "PLAYER", "CULL spends chosen strains, maximum three")
 var h := g._new_inst("HARVEST"); g.hand.append(h)
 var cred := g.cred; g.play_card(h.uid, 0)
 check.call(g.cred == cred + 6 and not g.enc.ice[0].virus.has("LEECH"), "HARVEST spends all LEECH for reserve-limited extraction")
 var u := g._new_inst("NULL_POINTER"); g.hand.append(u); g.play_card(u.uid, 0)
 check.call(g.phase == "CHOICE" and g.pending.n == 2 and not g._find(g.burned, u.uid).is_empty(), "NULL POINTER breaks two at zero and burns")
func step5() -> void:
 var g := game("ECHO"); g.enter_node(0); g.hand.clear(); g.bw = 20
 var a := g._new_inst("PROBE"); var b := g._new_inst("DEEP_PROBE")
 g.run_deck.append(a); g.run_deck.append(b)
 check.call(g.can_compile(a.uid, b.uid), "COMPILE different scripts sharing EXPLOIT")
 check.call(not g.can_compile(g.run_deck[0].uid, a.uid), "COMPILE rejects non-SCRIPT")
 g.phase = "SAFEHOUSE"
 check.call(g.compile_cards(a.uid, b.uid), "SAFEHOUSE COMPILE consumes its service choice")
 var id := "COMPILED::PROBE::DEEP_PROBE"
 check.call(CardDB.def(id).bw == 3 and CardDB.def(id).tags == ["EXPLOIT"], "compiled summed cost and union tags")
 g.phase = "PLAYER"; g.hand.append(g._new_inst(id))
 var before := g.ice_str(0)
 g.play_card(g.hand[0].uid, 0)
 check.call(g.ice_str(0) == maxi(0, before - 6) and g.discard.size() == 1, "both compiled effects execute, single physical discard")
 g.rack.append(g._new_inst("CLEAN_BUILD"))
 check.call(g.card_cost(id) == 2, "CLEAN BUILD discount")
 g.hand.clear(); g.draw_pile.clear(); g.discard.clear()
 var c := g._new_inst("COMPILED::PORT_SCAN::GARBAGE_COLLECT")
 # Untagged scripts cannot actually be compiled, so use two CLOAK scripts for playable queue instead.
 c.id = "COMPILED::DEAD_AIR::PULP_SHIELD"
 g.hand.append(c); var victim := g._new_inst("PROBE"); g.hand.append(victim)
 var sh := g.shield; g.play_card(c.uid)
 check.call(g.phase == "CHOICE" and g.shield == sh, "compiled second effect waits for first choice")
 g.choose(victim.uid)
 check.call(g.shield == sh + 3 and g.discard.size() == 1 and g.discard[0].id == c.id, "compiled continuation preserves one card identity")
 g.ghostware.append("HEARTBEAT"); g.trace = 6; g.force_reboot()
 check.call(g.trace == 4, "HEARTBEAT REBOOT trace relief")
 var one := game("ECHO"); one.ghostware.append("ONE_TRICK"); one.enter_node(0)
 check.call(one.bw == 5, "ONE-TRICK BW every turn")
 var minimal := game("ECHO"); minimal.ghostware.append("MINIMAL_INSTALL"); minimal.enter_node(0)
 check.call(minimal.amp == 1, "MINIMAL INSTALL starts GHOST Node with AMP")
 minimal.enc.ice.assign([minimal._new_ice("FREE_TRIAL")]); minimal.hand.clear(); minimal.draw_pile.clear(); minimal.discard.clear()
 minimal.force_reboot()
 check.call(minimal.draw_pile.size() == 1 and minimal.draw_pile[0].id == "SPAM", "FREE TRIAL inserts SPAM per REBOOT")
 minimal.enc.ice.assign([minimal._new_ice("PATTERN_ANALYSIS")]); minimal.shield = 0
 var vit := minimal.vitae; minimal._chain_bonus()
 check.call(minimal.vitae == vit - 1, "PATTERN ANALYSIS reacts to CHAIN")
 minimal.enc.ice.assign([minimal._new_ice("RECURRING_DREAM")]); minimal.hand.append(minimal._new_inst("PROBE")); minimal.draw_pile.clear(); minimal.discard.clear(); minimal.force_reboot()
 check.call(minimal.hand.is_empty() and minimal.draw_pile.size() == 1, "RECURRING DREAM FORGETS on REBOOT")

func pacing() -> void:
 var g := game("ECHO"); g.enter_node(0); g.hand.clear(); g.bw = 50
 check.call(IceDB.MAP[1][1].layers.size() == 1 and IceDB.MAP[2][1].layers.size() == 1 and IceDB.MAP[3][0].layers.size() == 1, "PACE-008 all slice Tier 1 Nodes have one layer")
 check.call(g.enc.reserve == 23 and IceDB.MAP[1][0].layers[0].reserve == 15, "reserves +50%, half CRED rounded up")
 check.call(g.reward_odds(1) == [60, 30, 10], "Tier 1 one-layer reward odds")
 g.node = g.node.duplicate(true); g.node.tier = "T2"
 check.call(g.reward_odds(1) == [45, 40, 15] and g.reward_odds(2) == [30, 45, 25], "Tier 2 rebased reward odds")
 var fixture := {"name": "TEST", "type": "FORTRESS", "str": 0, "subs": [[{"k": "DEADLOCK", "v": 2}], [{"k": "TRACE", "v": 1, "escalate": true}], [{"k": "DISCARD", "v": 1, "escalate": true}], [{"k": "FORGET", "v": 1, "escalate": true}]]}
 g.enc.ice.assign([g._new_ice("AUTO_RENEW", fixture)]); g.enc.ice[0].seen.fill(true)
 g.installed.append({"inst": g._new_inst("FORTRESS_ICEPICK"), "boost": 0, "free_used": false})
 check.call(g.break_sub(0, 0) and not g.enc.ice[0].broken[0] and g.deadlock_count() == Vector2i(1, 2), "DEADLOCK x2 first paid break records 1/2")
 g.infect(0, "WORM", 2); g.use_worm(0); g.choose_sub(0, 0)
 check.call(g.enc.ice[0].broken[0] and g.enc.breached and g.deadlock_count() == Vector2i(2, 2), "WORM removes exactly one DEADLOCK step")
 var h := game("ECHO"); h.enter_node(0); h.hand.clear(); h.bw = 30
 h.enc.ice.assign([h._new_ice("AUTO_RENEW", fixture)]); h.enc.ice[0].seen.fill(true)
 var brute := h._new_inst("BRUTE_FORCE"); h.hand.append(brute); h.play_card(brute.uid); h.choose_sub(0, 0)
 check.call(not h.enc.ice[0].broken[0] and h.enc.ice[0].break_progress[0] == 1, "card break removes one DEADLOCK step")
 h.phase = "PLAYER"; h.pending = {}; h.animate = true; h.end_turn()
 h.response_step() # DEADLOCK
 h.response_step() # TRACE
 check.call(h.effect_value(h.enc.ice[0], fixture.subs[1][0]).v == 2, "ESCALATE grows only after actual resolution, preview is next value")
 h.response_step(); h.response_step()
 check.call(h.effect_value(h.enc.ice[0], fixture.subs[2][0]).v == 2 and h.effect_value(h.enc.ice[0], fixture.subs[3][0]).v == 2, "DISCARD and FORGET escalate independently")
 check.call(CardDB.roles("SCALPEL").has("↯ DRILL") and CardDB.roles("WARM_BOOT").has("▣ HULL") and CardDB.roles("ADAPTER").has("◇ COVERAGE"), "reward need roles")

func edge_regressions() -> void:
 var g := game("ECHO"); g.enter_node(0); g.hand.clear(); g.bw = 30
 g.enc.ice.assign([g._new_ice("CONSENT_FORM"), g._new_ice("AUTO_RENEW")]); g.reduce_ice_str(1, 10)
 check.call(g.ice_str(1) == 0, "Reduction caps at zero without a passive bonus")
 for floor_value in [3, 4, 3]:
  g.enc.ice[1].str_floor = floor_value
  check.call(g.ice_str(1) == floor_value, "explicit 3/4/3 ICE floors remain authoritative")
 g.enc.ice[1].erase("str_floor")
 g.rack.append(g._new_inst("MINIMALIST")); g.enc.ice[1].seen.fill(true)
 g.installed.append({"inst": g._new_inst("FORTRESS_ICEPICK"), "boost": 0, "free_used": false})
 check.call(g.break_info(1, 0).cost == 0, "MINIMALIST GHOST first break is free")
 g._do_break(1, 0)
 check.call(g.break_info(1, 1).cost == 0, "FORTRESS first-pick-free remains independent until actually used")
 g.trace = 20
 var z := g._new_inst("ZERO_FOOTPRINT"); g.hand.append(z); g.play_card(z.uid)
 check.call(g.trace == 10 and g.burned[0].id == "ZERO_FOOTPRINT", "ZERO FOOTPRINT caps relief at ten and burns")
 check.call(CardDB.def("COMPILED::BLACKOUT::VANISH").bw == 4, "COMPILE BW cost capped at four")
 var compiled := g._new_inst("COMPILED::ZERO_FOOTPRINT::PULP_SHIELD"); g.hand.append(compiled)
 var shield := g.shield; g.play_card(compiled.uid)
 check.call(g.shield == shield + 3 and not g._find(g.burned, compiled.uid).is_empty(), "compiled burn executes both halves then burns combined card")
 g.ghostware.append("ONE_TRICK")
 while g.footprint() < 18: g.run_deck.append(g._new_inst("PROBE"))
 g.phase = "REWARD"; g.reward_options = ["PROBE"]
 var count := g.run_deck.size(); g.choose_reward("PROBE")
 check.call(g.run_deck.size() == count, "ONE-TRICK blocks card reward growth at cap minus four")
 var f := game("ECHO"); f.enter_node(0); f.hand.clear(); f.discard.clear(); f.draw_pile.clear()
 var protected := f._new_inst("PROBE"); protected.cached = true; f.hand.append(protected)
 f._apply_effect({"k": "FORGET", "v": 3})
 check.call(f.hand.size() == 1, "FORGET respects CACHE and insufficient hand")
 f.rack.append(f._new_inst("SHORT_LOOP")); f.rack.append(f._new_inst("ROLLING_RESTART"))
 f.draw_pile.append(f._new_inst("PROBE")); f.draw_pile.append(f._new_inst("PROBE"))
 var bw := f.bw; f.force_reboot()
 check.call(f.hand.size() == 3 and f.bw == bw + 1 and f.amp == 1, "SHORT LOOP draws and adds BW before later rack AMP trigger")

func engine_amp_regressions() -> void:
 var g := game("ECHO"); g.enter_node(0); g.hand.clear(); g.bw = 30; g.amp = 2
 g.installed.append({"inst": g._new_inst("SILENT_PARTNER"), "boost": 0, "free_used": false})
 g.enc.cloak_turn = 2
 var cred := g.cred; g.end_turn()
 check.call(g.cred == cred + 6, "SILENT PARTNER AMP once per payout")
 var r := game("RIOT"); r.enter_node(0); r.amp = 3; r.trace = 20
 r.rack.append(r._new_inst("PAIN_TOLERANCE")); r._start_turn()
 check.call(r.shield == 5, "PAIN TOLERANCE turn ENGINE receives AMP")
 check.call(r.card_text("WARM_BOOT").contains("8 SHIELD"), "amplified card output visible in text")
 r._end_ice_node()
 check.call(r.amp == 0, "AMP expires at Node end")

func coverage_and_escalation_regressions() -> void:
 var g := game("ECHO"); g.enter_node(0)
 var cards := [g._new_inst("COMPILED::BRUTE_FORCE::PROBE")]
 check.call(g.coverage(cards).values().all(func(x): return x), "compiled fallback retains COVERAGE capability")
 var definition := {"name": "ESC", "type": "FORTRESS", "str": 0, "subs": [[{"k": "TRACE", "v": 1, "escalate": true}], [{"k": "DEADLOCK", "v": 3}]]}
 g.enc.ice.assign([g._new_ice("AUTO_RENEW", definition)]); g.enc.ice[0].seen.fill(true)
 g.enc.ice[0].broken[0] = true; g.animate = true
 g.end_turn()
 while not g.response_queue.is_empty(): g.response_step()
 check.call(g.effect_value(g.enc.ice[0], definition.subs[0][0]).v == 1, "broken ESCALATE does not grow")
 g.phase = "PLAYER"; g.enc.ice[0].broken[0] = false; g.enc.blackout = true; g.end_turn()
 check.call(g.effect_value(g.enc.ice[0], definition.subs[0][0]).v == 1, "skipped response does not escalate")
 g.phase = "PLAYER"; g.enc.blackout = false; g.enc.breached = false
 g._do_break(0, 1); g._do_break(0, 1)
 check.call(not g.enc.ice[0].broken[1] and g.enc.ice[0].break_progress[1] == 2, "DEADLOCK x3 needs its third step")
 g._do_break(0, 1)
 check.call(g.enc.breached, "third DEADLOCK step permits BREACH")

func ordered_compile_regression() -> void:
 var g := game("RIOT"); g.enter_node(0); g.hand.clear(); g.bw = 30
 check.call(g.footprint_band() == "GHOST", "numeric GHOST threshold includes RIOT starter 15")
 g.enc.ice.assign([g._new_ice("COOKIE_WALL")]); g.enc.ice[0].seen.fill(true)
 var c := g._new_inst("COMPILED::PROBE::BRUTE_FORCE"); g.hand.append(c)
 check.call(g.play_card(c.uid, 0) and g.ice_str(0) == 3 and g.phase == "CHOICE", "compiled STR reduction enables subsequent conditional breaker")
 g.choose_sub(0, 3)
 check.call(g.enc.breached and g.discard[0].id == c.id, "compiled fallback finishes with one physical card")

func null_pointer_strike_regression() -> void:
 var g := game("RIOT"); g.enter_node(0); g.hand.clear(); g.bw = 30
 g.enc.ice.assign([g._new_ice("CAPTCHA")]); g.enc.ice[0].seen.fill(true)
 g.reduce_ice_str(0, 8); g.trace = 39; g.strikes = 1
 var c := g._new_inst("NULL_POINTER"); g.hand.append(c); g.play_card(c.uid, 0)
 var target: Dictionary = g.enc.ice[0]
 g.choose_sub(0, 1)
 check.call(g.pending.ice == 1 and is_same(g.enc.ice[1], target) and g.card_break_ok(1, 0), "NULL POINTER keeps target through TRIPWIRE strike")

func zeroed_lifecycle() -> void:
 var g := game("RIOT"); g.enter_node(0)
 g.enc.ice.assign([g._new_ice("AUTO_RENEW")])
 check.call(g.would_zero(0, 5), "fresh positive ICE eligible")
 g.infect(0, "ROT", 8)
 check.call(g.enc.ice[0].zeroed and g.ice_str(0) == 0, "ROT consumes ZEROED")
 g.enc.ice[0].harden = 3; g._sync_strengths()
 check.call(g.ice_str(0) == 0, "spare ROT holds HARDENING at zero")
 g.enc.ice[0].virus.clear(); g._sync_strengths()
 check.call(g.ice_str(0) == 8 and not g.reduce_ice_str(0, 20), "recovery and second zero grant no second chance")
 var fresh := g._new_ice("AUTO_RENEW")
 check.call(not fresh.zeroed, "new encounter has fresh ZEROED state")
 var floor_def := {"name": "FLOOR", "type": "FORTRESS", "str": 4, "str_floor": 3, "subs": [[{"k": "DEADLOCK"}]]}
 g.enc.ice.assign([g._new_ice("AUTO_RENEW", floor_def)])
 g.reduce_ice_str(0, 20); g.infect(0, "ROT", 20)
 check.call(g.ice_str(0) == 3 and not g.enc.ice[0].zeroed, "positive floor never ZEROED")
 var zero_def := {"name": "ZERO", "type": "FORTRESS", "str": 0, "subs": [[{"k": "DEADLOCK"}]]}
 g.enc.ice.assign([g._new_ice("AUTO_RENEW", zero_def)])
 g.enc.ice[0].harden = 2; g._sync_strengths(); g.reduce_ice_str(0, 2)
 check.call(not g.enc.ice[0].zeroed, "starts-at-zero ICE stays ineligible after gaining STR")
 g.enc.ice.assign([g._new_ice("CONSENT_FORM"), g._new_ice("AUTO_RENEW")])
 g.reduce_ice_str(1, 10)
 check.call(g.ice_str(1) == 0 and g.enc.ice[1].zeroed, "Excess reduction consumes ZEROED and excess loss is discarded")
 g.enc.ice[1].harden = 1; g._sync_strengths()
 check.call(g.ice_str(1) == 1, "STR gains rise from zero after excess reduction")

func zeroed_cards() -> void:
 var g := game("RIOT"); g.enter_node(0); g.hand.clear(); g.bw = 20; g.trace = 10
 g.enc.ice.assign([g._new_ice("AUTO_RENEW")]); g.enc.ice[0].seen.fill(true)
 g.reduce_ice_str(0, 3)
 var flat := g._new_inst("FLATLINE"); g.hand.append(flat); g.play_card(flat.uid, 0)
 check.call(g.ice_str(0) == 0 and g.enc.ice[0].zeroed and g.trace == 8, "FLATLINE pays +2 TRACE then ZEROED relieves four")
 var again := g._new_inst("FLATLINE"); g.hand.append(again); g.play_card(again.uid, 0)
 check.call(g.trace == 10, "FLATLINE at already-zero ICE gives no bonus")
 g.enc.ice.assign([g._new_ice("AUTO_RENEW")]); g.enc.ice[0].seen.fill(true)
 g.reduce_ice_str(0, 2)
 var k := g._new_inst("KNOCKOUT"); g.hand.append(k); g.play_card(k.uid, 0)
 check.call(g.phase == "CHOICE" and g.pending.n == 1 and g.card_break_ok(0, 3), "KNOCKOUT ZEROED opens normal break choice including DEADLOCK")
 g.choose_sub(0, 3)
 check.call(g.enc.breached and not g._find(g.discard, k.uid).is_empty(), "KNOCKOUT choice discards once")
 g.enc.ice.assign([g._new_ice("AUTO_RENEW")]); g.enc.breached = false
 g.reduce_ice_str(0, 4)
 var w := g._new_inst("SECOND_WIND"); g.hand.append(w); var before := g.bw; g.play_card(w.uid, 0)
 check.call(g.bw == before + 1, "SECOND WIND costs zero and gains one BW on ZEROED")
 var b := game("RIOT"); b.enter_node(0); b.hand.clear(); b.bw = 20
 b.enc.ice.assign([b._new_ice("REJECT_ALL")]); b.enc.ice[0].seen.fill(true)
 b.reduce_ice_str(0, 4)
 var n := b._new_inst("NULL_POINTER"); b.hand.append(n)
 check.call(b.play_card(n.uid, 0) and not b.card_break_ok(0, 0), "NULL POINTER respects BOOTING")
 b.choose_sub(0, 1)
 check.call(b.card_break_ok(0, 2), "NULL POINTER can take immediately tumbled PULP")
 b.choose_sub(0, 2)
 check.call(b.phase == "PLAYER" and not b._find(b.burned, n.uid).is_empty(), "NULL POINTER finishes when no legal breaks remain")
 var positive := game("RIOT"); positive.enter_node(0); positive.hand.clear()
 var bad := positive._new_inst("NULL_POINTER"); positive.hand.append(bad); var bw := positive.bw
 check.call(not positive.play_card(bad.uid, 0) and positive.bw == bw, "NULL POINTER rejects positive STR before payment")
 var ordinary := game("RIOT"); ordinary.enter_node(0); ordinary.hand.clear(); ordinary.bw = 20
 ordinary.enc.ice.assign([ordinary._new_ice("AUTO_RENEW")]); ordinary.reduce_ice_str(0, 5)
 ordinary.enc.ice[0].harden = 1; ordinary._sync_strengths()
 var no_bonus := ordinary._new_inst("SECOND_WIND"); ordinary.hand.append(no_bonus); bw = ordinary.bw; ordinary.play_card(no_bonus.uid, 0)
 check.call(ordinary.bw == bw, "ordinary first zero consumes future printed-card bonus")
 check.call(CardDB.roles("FLATLINE").has("↯ DRILL") and CardDB.roles("KNOCKOUT").has("↯ DRILL") and CardDB.roles("SECOND_WIND").has("↯ DRILL"), "all ZEROED cards labelled DRILL")
 var compile := game("RIOT"); compile.enter_node(0); compile.hand.clear(); compile.bw = 20
 compile.enc.ice.assign([compile._new_ice("AUTO_RENEW")])
 compile.reduce_ice_str(0, 1)
 var combo := compile._new_inst("COMPILED::PROBE::FLATLINE"); compile.hand.append(combo); compile.trace = 10; compile.play_card(combo.uid, 0)
 check.call(compile.enc.ice[0].zeroed and compile.trace == 8 and compile.discard[0].id == combo.id, "compiled ordinary reduction then printed ZEROED resolves in order")

func tumble_game() -> Game:
 var g := game("RIOT"); g.enter_node(0); g.hand.clear(); g.bw = 100
 g.enc.ice.assign([g._new_ice("CAPTCHA")]); g._mark_seen()
 g.installed.append({"inst": g._new_inst("PASSKEY"), "boost": 20, "free_used": false})
 return g
func tumbler_removal() -> void:
 var g := tumble_game()
 check.call(g.active_subs(0) == [0, 1], "CAPTCHA initial slots")
 g.break_sub(0, 0)
 check.call(g.active_subs(0) == [1, 2] and g.enc.ice[0].seen[2] and g.break_info(0, 2).ok, "break slot one slides slot two and reveals immediately breakable PULP")
 check.call(g.trace == 1 and g.response_preview().any(func(st): return st.sub == 2 and not st.skipped), "TRIPWIRE fires and response includes incoming sub this turn")
 check.call(not g.response_preview().any(func(st): return st.sub == 0), "removed sub absent from response")
 var second := tumble_game(); second.break_sub(0, 1)
 check.call(second.active_subs(0) == [0, 2] and second.break_info(0, 2).ok, "break slot two keeps slot one and tumbles next sub")
 second.break_sub(0, 2)
 check.call(second.active_subs(0) == [0, 3] and second.enc.ice[0].seen[3], "second break reveals next DEADLOCK this turn")
 var wrap := tumble_game(); wrap.enc.ice[0].rot = 4; wrap._mark_seen(); wrap.break_sub(0, 0)
 check.call(wrap.active_subs(0) == [4, 1], "tumble wraps and skips removed sub")
 wrap.break_sub(0, 4)
 check.call(wrap.active_subs(0) == [1, 2], "breaking first wrapped slot preserves following slot")
 wrap._rotate_tumblers()
 check.call(wrap.active_subs(0) == [2, 3], "rotation steps through only unbroken pool")
 wrap.break_sub(0, 2)
 check.call(wrap.active_subs(0) == [3, 1], "unbroken equals slots retains cyclic order")
 var frozen := wrap.active_subs(0); wrap._rotate_tumblers()
 check.call(wrap.active_subs(0) == frozen, "rotation stops when all remaining subs show")
 wrap.break_sub(0, 3)
 check.call(wrap.active_subs(0) == [1] and wrap.hidden_count(0) == 0, "pool smaller than slots shows only one and no hidden broken subs")
 wrap.break_sub(0, 1)
 check.call(wrap.active_subs(0).is_empty() and wrap.hidden_count(0) == 0, "empty pool has empty slots")
 var worm := tumble_game(); worm.infect(0, "WORM", 2); worm.use_worm(0); worm.choose_sub(0, 0)
 check.call(worm.active_subs(0) == [1, 2] and worm.trace == 1, "WORM break tumbles and pays TRIPWIRE")
 var card := tumble_game(); card.reduce_ice_str(0, 5)
 var n := card._new_inst("NULL_POINTER"); card.hand.append(n); card.play_card(n.uid, 0); card.choose_sub(0, 1)
 check.call(card.card_break_ok(0, 2), "card's second break can choose new incoming sub")
 card.choose_sub(0, 2)
 check.call(card.active_subs(0) == [0, 3] and card.trace == 2, "NULL POINTER removes exactly two steps, both tumble")
 var multi := tumble_game()
 var definition := {"name": "DOUBLE", "type": "TUMBLER", "str": 0, "slots": 1, "subs": [[{"k": "DEADLOCK", "v": 2}], [{"k": "TRACE", "v": 1}]]}
 multi.enc.ice.assign([multi._new_ice("CAPTCHA", definition)]); multi._mark_seen()
 multi.break_sub(0, 0)
 check.call(multi.active_subs(0) == [0] and not multi.enc.ice[0].broken[0], "DEADLOCK x2 first step does not tumble")
 multi.break_sub(0, 0)
 check.call(multi.active_subs(0) == [1] and multi.enc.ice[0].seen[1], "DEADLOCK x2 final step tumbles")
 var boot := tumble_game(); boot.enc.ice.assign([boot._new_ice("REJECT_ALL")]); boot.enc.ice[0].rot = 1; boot._mark_seen()
 boot.break_sub(0, 1)
 check.call(boot.active_subs(0) == [2, 0] and boot.break_info(0, 0).reason.begins_with("LOCKED"), "BOOTING applies while other subs tumble")
 boot.enc.turn = 3
 check.call(boot.break_info(0, 0).ok, "BOOTING unlocks on turn three with shrunk pool")

func selected_icepick() -> void:
 var g := tumble_game()
 var cheap: int = g.installed[0].inst.uid
 var chosen := {"inst":g._new_inst("TUMBLER_ICEPICK"),"boost":5,"free_used":false}
 g.installed.append(chosen)
 var auto := g.break_info(0,0)
 var info := g.break_info(0,0,chosen.inst.uid)
 check.call(auto.uid==cheap and info.uid==chosen.inst.uid, "dragged Icepick is selected without changing automatic cheapest break")
 var before := g.bw
 check.call(g.break_sub(0,0,chosen.inst.uid) and g.bw==before-info.cost and g.enc.ice[0].broken[0], "selected Icepick pays its normal cost and breaks the target")
 var wrong := {"inst":g._new_inst("VOID_ICEPICK"),"boost":20,"free_used":false}; g.installed.append(wrong)
 before=g.bw
 check.call(not g.break_sub(0,1,wrong.inst.uid) and g.bw==before and not g.enc.ice[0].broken[1], "incompatible dragged Icepick spends nothing")
 check.call(not g.break_sub(0,1,999999) and g.bw==before, "missing dragged Icepick cannot fall back to another one")
 g.bw=0
 check.call(not g.break_sub(0,1,chosen.inst.uid) and g.bw==0 and not g.enc.ice[0].broken[1], "unaffordable selected Icepick spends nothing")
