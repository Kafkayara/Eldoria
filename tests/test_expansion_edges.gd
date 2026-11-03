extends SceneTree
const Duel = preload("res://scripts/duel.gd")
const Catalog = preload("res://scripts/catalog.gd")
var failures := 0
var checks := 0
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(label)
func fresh():
	var d = Duel.new()
	d.start(31)
	d.turn_number = 3
	d.hands = [[],[]]
	d.graves = [[],[]]
	d.fields = [[{},{},{}],[{},{},{}]]
	return d
func unit(id: String, uid: int = 100) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"uid":uid,"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"shield":false})
	return c
func trap(id: String) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c["set_turn"] = 1
	return c
func _initialize() -> void:
	var d = fresh()
	d.interactive_targets = true
	d.hands[0] = [Catalog.card("renewal")]
	d.graves[0] = [Catalog.card("fenrir"),Catalog.card("grove")]
	check(d.play(0) and not d.pending_choice.is_empty(),"Player explicitly chooses Grave target")
	check(not d.end_turn() and not d.battle() and not d.play(0),"Pending selection blocks actions")
	check(not d.choose_target(0,10) and not d.pending_choice.is_empty(),"Invalid choice preserves selection")
	check(d.choose_target(0,-1) and d.hands[0].size() == 1 and d.graves[0].size() == 2,"Cancel costs nothing")
	d.play(0)
	check(d.choose_target(0,1) and d.hands[0].back()["id"] == "grove","Player can choose lower ATK recovery")
	check(d.undo() and d.pending_choice.is_empty() and d.graves[0].size() == 2,"Undo restores pre-activation state")
	d = fresh()
	d.interactive_targets = true
	d.hands[0] = [Catalog.card("weaver")]
	d.fields[1][0] = unit("dawn")
	d.play(0,0)
	check(d.summoned and not d.pending_choice.is_empty(),"Summon commits before optional choice")
	check(d.choose_target(0,-1) and not d.fields[1][0]["defending"],"Optional summon effect can be skipped")
	check(d.undo() and d.fields[0][0].is_empty() and not d.summoned,"Undo reverses whole summon")
	d = fresh()
	d.lp[0] = 500
	d.fields[1][0] = unit("dawn")
	d.hands[0] = [Catalog.card("mirror_step")]
	check(not d.play(0,0) and d.lp[0] == 500,"Bounce cannot pay last 500 LP")
	d.lp[0] = 4000
	d.backrows[1][0] = trap("seal")
	d.play(0,0)
	check(d.lp[0] == 3500 and d.priority == 1,"Bounce cost paid before response")
	d.respond(1,0)
	check(d.fields[1][0]["id"] == "dawn" and d.lp[0] == 3500,"Negated bounce retains cost")
	check(d.undo() and d.lp[0] == 4000 and not d.backrows[1][0].is_empty(),"Undo restores cost and enemy trap")
	d = fresh()
	d.hands[0] = [Catalog.card("mirror_step")]
	d.fields[1][0] = unit("dawn")
	d.backrows[1][0] = trap("seal")
	d.play(0,0)
	d.fields[1][0] = unit("fenrir",101)
	d.respond(1,-1)
	check(d.fields[1][0]["id"] == "fenrir","Replacement in same zone does not receive old targeted effect")
	d = fresh()
	d.graves[0] = [Catalog.card("mirror"),Catalog.card("seal")]
	d.hands[0] = [Catalog.card("archive")]
	d.backrows[1][0] = trap("seal")
	d.play(0,-1,false,0)
	d.graves[0].pop_at(0)
	d.respond(1,-1)
	check(d.hands[0].is_empty() and d.graves[0][0]["id"] == "seal","Missing Grave target does not redirect recovery")
	d = fresh()
	d.turn = 1
	d.phase = "BATTLE"
	d.interactive_targets = true
	d.fields[1][0] = unit("dawn")
	d.backrows[0][0] = trap("trail")
	d.graves[0] = [Catalog.card("grove"),Catalog.card("fenrir")]
	d.attack(0)
	check(d.response_options(0).has(0),"Trail responds to direct attack")
	d.respond(0,0)
	check(not d.pending_choice.is_empty() and not d.backrows[0][0].is_empty(),"Trail target chosen before trap consumed")
	d.choose_target(0,0)
	check(d.hands[0][0]["id"] == "grove" and d.fields[1][0]["atk"] == 1300 and d.lp[0] == 2700,"Trail recovers chosen card and weakens before direct damage")
	d.end_turn()
	check(d.fields[1][0]["atk"] == 1700,"Trail weakening expires")
	d = fresh()
	d.turn = 1
	d.phase = "BATTLE"
	d.fields[1][0] = unit("ember")
	d.fields[0][0] = unit("warden",101)
	d.fields[0][0]["defending"] = true
	d.backrows[0][0] = trap("bastion")
	d.attack(0,0)
	d.respond(0,0)
	check(not d.fields[0][0].is_empty() and d.lp[1] == 3700,"Bastion modifies defense before damage")
	d.end_turn()
	check(d.fields[0][0]["def"] == 2100 and d.fields[0][0]["atk"] == 900,"Bastion expires on both stats")
	d = fresh()
	d.fields[0][0] = unit("dawn")
	d.fields[0][0]["atk"] = 100
	d.temporary(d.fields[0][0],-400,0)
	check(d.fields[0][0]["atk"] == 0,"Temporary decrease clamps at zero")
	d.end_turn()
	check(d.fields[0][0]["atk"] == 100,"Clamped temporary decrease restores exact previous value")
	for key in Catalog.PRESETS:
		check(Catalog.validate(Catalog.PRESETS[key]["cards"]).is_empty(),"Updated preset valid: "+key)
	print("EXPANSION EDGES: %d checks / %d failures" % [checks,failures])
	quit(1 if failures else 0)
