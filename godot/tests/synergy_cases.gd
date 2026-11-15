extends RefCounted
var check: Callable
func game(who: String = "GENERALIST") -> Game:
 var g := Game.new(400)
 g.hold_enabled = false
 g.new_run(who)
 return g
func run() -> void:
 step1()
 step2()
 step3()
 step4()
 step5()
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
 check.call(g.ice_str(0) == before - 3, "PIVOT CHAIN CLOAK grants extra reduction")
 var tags: Array = g.enc.last_tags.duplicate()
 g.installed.append({"inst": g._new_inst("TUMBLER_ICEPICK"), "boost": 5, "free_used": false})
 g.break_sub(0, 0)
 check.call(g.enc.last_tags == tags, "Icepick use does not change CHAIN")
 var cover := g._new_inst("COVER_FIRE"); g.hand.append(cover)
 var shield_before := g.shield
 g.play_card(cover.uid)
 check.call(g.shield == shield_before + 5, "COVER FIRE CHAIN EXPLOIT")
 var hold := game("ECHO"); hold.enter_node(0); hold.hold_enabled = true
 var uid: int = hold.hand[0].uid
 hold.end_turn()
 check.call(hold.phase == "CHOICE" and hold.pending.kind == "hold" and hold.pending.n == 1, "HOLD 1 offered at turn end")
 hold.choose(uid)
 check.call(hold._find(hold.hand, uid).cached and hold.enc.turn == 2, "HOLD survives cleanup and fresh draw")
 hold.end_turn(); hold.choose(-1)
 check.call(hold.enc.turn == 3, "HOLD can be skipped")
 var training := game("ECHO"); training.enter_node(0); training.hold_enabled = true
 training.node = training.node.duplicate(true); training.node.training = true
 training.end_turn()
 check.call(training.enc.turn == 2, "HOLD disabled in Training Node")
 var pocket := game("ECHO"); pocket.enter_node(0); pocket.hold_enabled = true
 pocket.ghostware.append("DEAD_MANS_POCKET")
 pocket.end_turn()
 var one: int = pocket.pending.options[0]; pocket.choose(one)
 check.call(pocket.phase == "CHOICE" and pocket.pending.n == 1, "DEAD MAN'S POCKET offers two choices")
 var two: int = pocket.pending.options[0]; pocket.choose(two)
 check.call(pocket.hand.filter(func(c): return c.cached).size() == 2, "two cards retained")
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
 g.enc.ice[0].str_mod = -10
 check.call(g.ice_str(0) == -6, "UNDERFLOW permits negative STR")
 g.enc.ice[0].str_floor = 3
 check.call(g.ice_str(0) == 3, "explicit STR floor overrides UNDERFLOW")
 g.enc.ice[0].erase("str_floor"); g.enc.ice[0].harden = 2
 check.call(g.ice_str(0) == -4, "HARDENING raises negative STR normally")
 g.enc.ice[0].bomb = true
 check.call(g.ice_str(0) == 0, "LOGIC BOMB sets negative STR to zero")
 g.enc.ice[0].bomb = false
 g.installed.append({"inst": g._new_inst("SCALPEL"), "boost": 0, "free_used": false})
 check.call(g.break_info(0, 0).margin == 6 and g.break_info(0, 0).cost == 0, "SCALPEL OVERKILL uses MARGIN")
 g.amp = 2; g.infect(0, "ROT", 1)
 check.call(g.ice_str(0) == -7, "ROT AMP applied once to strain effect")
 g.infect(0, "LEECH", 4)
 var c := g._new_inst("CULL"); g.hand.append(c); g.play_card(c.uid, 0)
 g.cull_strain("ROT"); g.cull_strain("LEECH"); g.cull_strain("LEECH")
 check.call(g.shield == 6 and g.enc.ice[0].virus.LEECH == 2 and g.phase == "PLAYER", "CULL spends chosen strains, maximum three")
 var h := g._new_inst("HARVEST"); g.hand.append(h)
 var cred := g.cred; g.play_card(h.uid, 0)
 check.call(g.cred == cred + 6 and not g.enc.ice[0].virus.has("LEECH"), "HARVEST spends all LEECH for reserve-limited extraction")
 var u := g._new_inst("INTEGER_UNDERFLOW"); g.hand.append(u); g.play_card(u.uid, 0)
 check.call(g.phase == "CHOICE" and g.pending.n == 3 and not g._find(g.burned, u.uid).is_empty(), "INTEGER UNDERFLOW caps at three and burns")
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
 check.call(g.ice_str(0) == before - 6 and g.discard.size() == 1, "both compiled effects execute, single physical discard")
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
