extends RefCounted
var check: Callable
func game(who: String = "GENERALIST") -> Game:
 var g := Game.new(400)
 g.new_run(who)
 return g
func run() -> void:
 step1()
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
