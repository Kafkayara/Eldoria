extends SceneTree
const Duel = preload("res://scripts/duel.gd")
const Catalog = preload("res://scripts/catalog.gd")
const Hints = preload("res://scripts/duel_hints.gd")
var checks := 0
var failures := 0
func check(ok: bool, why: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(why)
func unit(id: String, shield: bool = false) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"uid":7,"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"shield":shield})
	return c
func fresh():
	var d = Duel.new()
	d.start(77,0,Catalog.DECK,Catalog.GERHANA)
	d.turn_number = 3
	d.fields = [[unit("dawn"),{},{}],[{}, {}, {}]]
	d.hands = [[Catalog.card("solar_lance")],[]]
	d.backrows = [[{},{},{}],[{},{},{}]]
	return d
func ready_trap(d, side: int, id: String) -> void:
	d.backrows[side][0] = Catalog.card(id)
	d.backrows[side][0].merge({"set_turn":1,"faceup":false})
func _initialize() -> void: call_deferred("run")
func run() -> void:
	check(Catalog.validate(Catalog.DECK).is_empty() and Catalog.validate(Catalog.GERHANA).is_empty(),"Both 20-card presets legal")
	check(Catalog.DECK.count("solar_lance") == 1 and Catalog.GERHANA.count("lunar_veil") == 1,"One thematic card per deck")
	var d = fresh()
	check(d.play(0,0),"Lance targets friendly monster")
	check(d.fields[0][0]["atk"] == 2200 and d.fields[0][0]["def"] == 900 and d.fields[0][0]["piercing"],"Lance power, drawback, piercing")
	check(d.undo() and not d.fields[0][0].has("piercing") and d.hands[0][0]["id"] == "solar_lance","Undo removes lance status and restores hand")
	check(not d.play(0,1) and d.hands[0].size() == 1,"Empty target rejected without consuming card")
	d.play(0,0)
	d.phase = "BATTLE"
	d.fields[1][0] = unit("owl",true)
	d.fields[1][0]["defending"] = true
	check(Hints.forecast(d,d.fields[0][0],d.fields[1][0]).contains("200 LP (tembus)"),"Forecast piercing damage even through shield")
	check(d.attack(0,0) and d.lp[1] == 3800,"Piercing deals excess LP")
	check(not d.fields[1][0].is_empty() and not d.fields[1][0]["shield"],"Shield saves monster, not LP")
	check(d.undo() and d.lp[1] == 4000 and d.fields[1][0]["shield"],"Undo restores attack damage and shield")
	d.fields[1][0]["def"] = 2200
	d.attack(0,0)
	check(d.lp[1] == 4000 and d.fields[1][0]["shield"],"Equal defense neither pierces nor consumes shield")
	d = fresh()
	d.fields[0][0]["def"] = 100
	d.play(0,0)
	check(d.fields[0][0]["def"] == 0,"DEF drawback clamps at zero")
	d = fresh()
	ready_trap(d,1,"seal")
	d.play(0,0)
	check(d.priority == 1,"New spell opens response")
	d.respond(1,0)
	check(d.fields[0][0]["atk"] == 1700 and not d.fields[0][0].has("piercing"),"Seal negates entire lance effect")
	d = fresh()
	d.play(0,0)
	d.phase = "BATTLE"
	d.fields[1][0] = unit("owl")
	d.fields[1][0]["defending"] = true
	ready_trap(d,1,"thorns")
	d.attack(0,0)
	d.respond(1,0)
	check(d.fields[0][0]["atk"] == 1700 and d.lp[0] == 3700 and d.lp[1] == 4000,"Thorns defeats a piercing attack using updated ATK")
	d = fresh()
	d.play(0,0)
	d.phase = "BATTLE"
	ready_trap(d,1,"mirror")
	d.attack(0)
	d.respond(1,0)
	check(d.lp[1] == 4000 and d.lp[0] == 3700,"Mirror cancels a piercing attacker")
	d = fresh()
	d.hands[0] = [Catalog.card("lunar_veil")]
	d.fields[0][0] = unit("noctis")
	d.play(0,0)
	check(d.fields[0][0]["def"] == 2300 and d.fields[0][0]["shield"] and d.fields[0][0]["atk"] == 2700,"Veil restores shield and prepares counterattack")
	check(d.undo() and not d.fields[0][0]["shield"] and d.fields[0][0]["def"] == 1900,"Undo restores spent shield")
	d.play(0,0)
	d.hands[0] = [Catalog.card("lunar_veil")]
	d.play(0,0)
	d._destroy_battle(0,0)
	check(not d.fields[0][0].is_empty() and not d.fields[0][0]["shield"],"Repeated veil cannot stack shields")
	d._destroy_battle(0,0)
	check(d.fields[0][0].is_empty(),"Next destruction removes monster")
	d = fresh()
	d.hands[0] = [Catalog.card("lunar_veil")]
	ready_trap(d,1,"seal")
	d.play(0,0)
	d.respond(1,0)
	check(not d.fields[0][0]["shield"] and d.fields[0][0]["def"] == 1200,"Seal negates veil")
	d = fresh()
	d.hands[0] = [Catalog.card("lunar_veil")]
	d.fields[0][0] = unit("sprite")
	d.play(0,0)
	d.turn = 1
	d.hands[1] = [Catalog.card("eclipse")]
	d.play(0,0)
	check(d.fields[0][0].is_empty(),"Destroy spell bypasses veil shield")
	d = fresh()
	d.hands[0] = [Catalog.card("blessing")]
	d.play(0,0)
	check(d.fields[0][0]["atk"] == 2100 and d.fields[0][0]["def"] == 1600 and not d.fields[0][0].has("piercing"),"Existing Blessing unchanged")
	print("DECK IDENTITY: %d checks / %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
