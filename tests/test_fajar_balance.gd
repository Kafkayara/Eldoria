extends SceneTree
const Duel = preload("res://scripts/duel.gd")
const Catalog = preload("res://scripts/catalog.gd")
var checks := 0
var failures := 0
func check(ok: bool, why: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(why)
func unit(id: String, defending: bool = false) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"defending":defending,"attacked":false,"switched":false,"summoned_turn":1,"shield":c["effect"]=="shield","uid":8})
	return c
func trap(id: String) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"set_turn":1,"faceup":false})
	return c
func matchup():
	var d = Duel.new()
	d.start(27)
	d.turn_number = 3
	d.phase = "BATTLE"
	d.fields = [[unit("ember"),{},{}],[unit("noctis"),{},{}]]
	d.hands = [[],[]]
	return d
func _initialize() -> void: call_deferred("run")
func run() -> void:
	check(Catalog.CARDS["ember"]["atk"] == 2500,"Naga Bara has 2500 ATK")
	check(Catalog.CARDS["dawn"]["atk"] == 1700,"Penjaga Fajar has 1700 ATK")
	check(Catalog.CARDS["noctis"]["atk"] == 2300 and Catalog.CARDS["noctis"]["effect"] == "shield","Noctis retains defensive identity")
	check(Catalog.validate(Catalog.DECK).is_empty() and Catalog.validate(Catalog.GERHANA).is_empty(),"Both presets valid")
	check(Catalog.DECK.count("sprite") == 3 and Catalog.DECK.count("oracle") == 1,"Fajar has more card access")
	check(Catalog.DECK.count("seal") == 1 and Catalog.DECK.count("sanctuary") == 1,"Fajar trades excess healing for counterplay")
	var types := {"monster":0,"spell":0,"trap":0}
	for id in Catalog.DECK: types[Catalog.CARDS[id]["kind"]] += 1
	check(types == {"monster":13,"spell":6,"trap":1},"Exact new Fajar composition")
	var d = matchup()
	check(d.attack(0,0),"Bara can challenge Noctis")
	check(not d.fields[0][0].is_empty() and not d.fields[1][0].is_empty() and not d.fields[1][0]["shield"] and d.lp[1] == 3800,"Bara wins first exchange; Noctis spends shield")
	d.end_turn(); d.end_turn(); d.battle()
	check(d.attack(0,0) and d.fields[1][0].is_empty() and not d.fields[0][0].is_empty(),"Bara defeats unassisted Noctis on following attack")
	d = matchup()
	d.backrows[1][0] = trap("thorns")
	d.attack(0,0)
	d.respond(1,0)
	check(d.fields[0][0].is_empty() and not d.fields[1][0].is_empty() and d.fields[1][0]["shield"],"Gerhana can still defeat an unsupported Bara with Thorns")
	d = matchup()
	d.phase = "MAIN"
	d.hands[0] = [Catalog.card("blessing")]
	d.play(0,0); d.battle()
	d.backrows[1][0] = trap("thorns")
	d.attack(0,0); d.respond(1,0)
	check(d.fields[0][0].get("atk") == 2400 and not d.fields[1][0]["shield"] and d.lp[1] == 3900,"Berkah supports Bara through the 500-ATK trap")
	d = matchup()
	d.backrows[1][0] = trap("mirror")
	d.backrows[0][0] = trap("seal")
	d.attack(0,0); d.respond(1,0)
	check(d.priority == 0 and d.response_options(0).has(0),"Fajar gets a legal counter-trap decision")
	d.respond(0,0)
	check(d.lp[0] == 4000 and d.lp[1] == 3800 and not d.fields[1][0]["shield"],"Seal counters mirror without giving immunity to Bara")
	d = matchup()
	var before: int = d.fields[0][0]["atk"]
	d.attack(0,0); d.undo()
	check(d.fields[0][0]["atk"] == before and d.fields[1][0]["shield"] and not d.fields[0][0]["attacked"],"Undo restores new stats, attack and shield state")
	d = Duel.new(); d.start(35); d.turn_number = 3
	d.hands[0] = [Catalog.card("blessing")]
	d.fields[0][0] = unit("dawn")
	d.fields[1][0] = unit("owl",true)
	d.play(0,0); d.battle(); d.attack(0,0)
	check(d.fields[1][0].is_empty() and d.lp[1] == 4000,"Supported Dawn breaks Owl wall without inventing piercing damage")
	print("FAJAR BALANCE RULES: %d checks / %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
