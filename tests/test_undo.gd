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
func signature(d) -> String:
	var data := {}
	for key in Duel.SNAPSHOT_FIELDS: data[key] = d.get(key)
	data["rng_seed"] = d.rng.seed
	data["rng_state"] = d.rng.state
	return JSON.stringify(data)
func fresh():
	var d = Duel.new()
	d.start(42)
	d.turn_number = 3
	d.hands = [[],[]]
	d.fields = [[{},{},{}],[{},{},{}]]
	d.graves = [[],[]]
	return d
func unit(id: String) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"shield":c["effect"]=="shield","uid":9})
	return c
func trap(id: String) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"set_turn":1,"faceup":false})
	return c
func _initialize() -> void: call_deferred("run")
func run() -> void:
	var d = fresh()
	check(not d.can_undo() and not d.undo(),"No undo without a completed or pending player action")
	for id in ["dawn","ember","sprite","oracle","sentinel","noctis","storm","sanctuary","blessing","eclipse","hourglass","mirror"]:
		d = fresh()
		d.hands[0] = [Catalog.card(id)]
		d.lp[0] = 2000
		if id in ["ember","noctis"]: d.fields[0][0] = unit("dawn")
		if id == "blessing": d.fields[0][1] = unit("dawn")
		if id == "eclipse": d.fields[1][1] = unit("fenrir")
		if id == "sentinel": d.decks[0].append(Catalog.card("mirror"))
		var before: String = signature(d)
		var target: int = 1 if Catalog.CARDS[id]["kind"] == "monster" or id in ["blessing","eclipse"] else -1
		check(d.play(0,target),"Action accepted: "+id)
		check(d.undo_stack.size() == 1 and d.can_undo(),"Exactly one checkpoint: "+id)
		check(d.undo() and signature(d) == before,"Exact complete-state restoration: "+id)
		check(d.undo_stack.is_empty(),"Undo consumes checkpoint: "+id)
	# Undo a draw does not reroll the next card or random state.
	d = fresh()
	d.hands[0] = [Catalog.card("sprite")]
	d.play(0,0)
	var drawn: String = d.hands[0][0]["id"]
	var roll: int = d.rng.randi()
	d.undo()
	d.play(0,0)
	check(d.hands[0][0]["id"] == drawn and d.rng.randi() == roll,"Draw order and RNG restored deterministically")
	# Undo may rescue a draw-out before ending the turn.
	d = fresh()
	d.hands[0] = [Catalog.card("hourglass")]
	d.decks[0] = [Catalog.card("dawn")]
	var before: String = signature(d)
	d.play(0)
	check(d.over and d.can_undo(),"Losing action remains undoable within player turn")
	check(d.undo() and signature(d) == before,"Undo restores deck-out loss")
	# Battle phase, positions, skills, shield consumption, and lethal attack.
	d = fresh()
	before = signature(d)
	d.battle()
	check(d.undo() and signature(d) == before,"Undo Battle Phase transition")
	d.fields[0][0] = unit("dawn")
	before = signature(d)
	d.switch_position(0)
	check(d.undo() and signature(d) == before,"Undo position and once-per-turn marker")
	d.lp[0] = 2000
	before = signature(d)
	d.skill()
	check(d.undo() and signature(d) == before,"Undo skill use and healing")
	d.phase = "BATTLE"
	d.fields[0][0] = unit("ember")
	d.fields[1][0] = unit("warden")
	before = signature(d)
	d.attack(0,0)
	check(not d.fields[1][0]["shield"],"Fixture consumes shield")
	check(d.undo() and signature(d) == before,"Undo shield and all combat consequences")
	d.fields[1] = [{},{},{}]
	d.lp[1] = 100
	before = signature(d)
	d.attack(0)
	check(d.over and d.undo() and signature(d) == before,"Undo lethal hit restores live duel")
	# Pending response and the resolved enemy trap belong to the original action.
	for resolve in [false,true]:
		d = fresh()
		d.hands[0] = [Catalog.card("storm")]
		d.backrows[1][0] = trap("seal")
		before = signature(d)
		d.play(0)
		if resolve: d.respond(1,0)
		check(d.undo_stack.size() == 1,"Enemy response does not create player checkpoints")
		check(d.undo() and signature(d) == before,"Undo pending/resolved enemy trap: "+str(resolve))
	# Player response gets its own checkpoint; undo back to the decision window.
	d = fresh()
	d.hands[0] = [Catalog.card("storm")]
	d.backrows[1][0] = trap("seal")
	d.backrows[0][0] = trap("seal")
	before = signature(d)
	d.play(0)
	d.respond(1,0)
	var response_before: String = signature(d)
	d.respond(0,0)
	check(d.undo_stack.size() == 2,"Player response adds independent checkpoint")
	check(d.undo() and signature(d) == response_before and d.priority == 0,"Undo restores response chain and priority")
	check(d.undo() and signature(d) == before,"Undo again restores original spell and both traps")
	# Invalid actions must not pollute history; ending the turn commits it.
	d = fresh()
	d.hands[0] = [Catalog.card("dawn")]
	check(not d.play(0,7) and d.undo_stack.is_empty(),"Rejected action creates no checkpoint")
	d.play(0,0)
	check(d.can_undo(),"History available before ending turn")
	d.end_turn()
	check(not d.can_undo() and d.undo_stack.is_empty() and not d.undo(),"End turn commits and clears history")
	d.end_turn()
	check(d.turn == 0 and not d.can_undo(),"New player turn does not access previous turn history")
	d.turn = 1
	d.hands[1] = [Catalog.card("dawn")]
	d.play(0,0)
	check(d.undo_stack.is_empty(),"Enemy actions do not create player undo history")
	print("UNDO MODEL: %d checks / %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
