extends SceneTree
const Duel = preload("res://scripts/duel.gd")
const Catalog = preload("res://scripts/catalog.gd")
const AI = preload("res://scripts/ai.gd")
const Store = preload("res://scripts/deck_store.gd")
var checks := 0
var failures := 0
func check(ok: bool, reason: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(reason)
func unit(id: String) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"uid":8,"shield":false})
	return c
func trap(d,side: int,id: String,z: int = 0) -> void:
	var c: Dictionary = Catalog.card(id)
	c["set_turn"] = 1
	c["faceup"] = false
	d.backrows[side][z] = c
func fresh():
	var d = Duel.new()
	d.start(5)
	d.turn_number = 3
	d.hands = [[],[]]
	d.fields = [[{},{},{}],[{},{},{}]]
	return d
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	check(Catalog.CARDS.size() == 18,"18 unique types")
	for preset in Catalog.PRESETS.values():
		check(Catalog.validate(preset["cards"]).is_empty(),"Valid preset")
	check(not Catalog.validate(["not-a-card"]).is_empty(),"Reject bad deck size")
	var invalid: Array = Catalog.DECK.duplicate()
	invalid[0] = "not-a-card"
	check(not Catalog.validate(invalid).is_empty(),"Reject unknown card")
	check(not Catalog.validate(Array().duplicate()).is_empty(),"Reject empty deck")
	var d = fresh()
	d.hands[0] = [Catalog.card("seal")]
	check(d.set_trap(0,0),"Set trap from hand")
	check(d.backrows[0][0]["set_turn"] == 3 and d.hands[0].is_empty(),"Trap recorded and moved")
	d.turn = 1
	d.hands[1] = [Catalog.card("storm")]
	check(d.play(0) and d.chain.is_empty() and d.lp[0] == 3500,"Cannot use trap on setting turn")
	d = fresh()
	trap(d,1,"seal")
	d.hands[0] = [Catalog.card("storm")]
	check(d.play(0) and d.priority == 1 and d.lp[1] == 4000,"Spell awaits response before damage")
	check(not d.end_turn() and not d.battle() and not d.skill(),"Actions blocked while chain pending")
	check(not d.respond(0,0),"Wrong side cannot respond")
	check(d.respond(1,0) and d.chain.is_empty() and d.lp[1] == 4000,"Seal negates spell")
	check(d.graves[0].size() == 1 and d.graves[1].size() == 1 and d.backrows[0][0].is_empty(),"Spell and trap move to grave")
	d = fresh()
	trap(d,1,"seal")
	trap(d,0,"seal")
	d.hands[0] = [Catalog.card("storm")]
	d.play(0)
	d.respond(1,0)
	check(d.chain.size() == 2 and d.priority == 0,"Counterspell offers counter-response")
	check(d.respond(0,0) and d.chain.is_empty() and d.lp[1] == 3500,"Counter-counter resolves in reverse order")
	d = fresh()
	trap(d,1,"mirror")
	d.phase = "BATTLE"
	d.fields[0][0] = unit("sentinel")
	check(d.attack(0) and d.lp[1] == 4000 and d.priority == 1,"Attack waits for trap")
	d.respond(1,0)
	check(d.lp[0] == 3700 and d.lp[1] == 4000 and d.fields[0][0]["attacked"],"Reflect cancels and consumes attack")
	check(not d.attack(0),"Cancelled attack cannot be repeated")
	d = fresh()
	trap(d,1,"thorns")
	d.phase = "BATTLE"
	d.fields[0][0] = unit("sentinel")
	d.attack(0)
	d.respond(1,0)
	check(d.fields[0][0]["atk"] == 1200 and d.lp[1] == 2800,"Thorns weakens before resolving damage")
	d = fresh()
	trap(d,1,"mirror")
	trap(d,0,"seal")
	d.phase = "BATTLE"
	d.fields[0][0] = unit("sentinel")
	d.attack(0)
	d.respond(1,0)
	d.respond(0,0)
	check(d.lp[1] == 2300 and d.lp[0] == 4000,"Seal negates reflect; original attack proceeds")
	d = fresh()
	trap(d,1,"seal")
	d.hands[0] = [Catalog.card("hourglass")]
	var before: int = d.decks[0].size()
	d.play(0)
	d.respond(1,-1)
	check(d.decks[0].size() == before-2 and d.hands[0].size() == 2,"Pass resolves two-card draw spell")
	d = fresh()
	for z in range(3): trap(d,0,"seal",z)
	d.hands[0] = [Catalog.card("storm"),Catalog.card("mirror")]
	check(not d.play(0) and not d.set_trap(1),"Full backrow rejects spell and trap")
	d = fresh()
	d.hands[0] = [Catalog.card("hourglass")]
	d.decks[0] = [Catalog.card("dawn")]
	check(d.play(0) and d.over and d.winner == 1,"Drawing past empty deck loses")
	# Persistence tests use a separate save file, never the player's profile.
	var store = Store.new()
	store.path = "user://eldoria_test_decks.json"
	check(store.save_deck("fajar","Uji Gerhana",Catalog.GERHANA).is_empty(),"Save custom deck")
	var saved_id: String = store.active
	var reload = Store.new()
	reload.path = store.path
	reload.load_data()
	check(reload.active == saved_id and reload.cards(saved_id) == Catalog.GERHANA,"Reload exact custom deck and active selection")
	check(not reload.save_deck(saved_id,"Invalid",[]).is_empty(),"Invalid draft cannot overwrite saved deck")
	check(reload.cards(saved_id) == Catalog.GERHANA,"Invalid save preserves last good deck")
	check(reload.save_data() == OK,"Create recoverable backup")
	var corrupt := FileAccess.open(reload.path,FileAccess.WRITE)
	corrupt.store_string("broken-json")
	corrupt.close()
	var recovered = Store.new()
	recovered.path = reload.path
	recovered.load_data()
	check(recovered.active == saved_id and recovered.cards(saved_id) == Catalog.GERHANA and not recovered.load_notice.is_empty(),"Recover corrupt primary save from backup")
	check(recovered.save_data() == OK,"Recovered profile can save again")
	# Mix both archetypes, both first players, all three AI settings.
	var complete := 0
	var responses := 0
	var wins := {"fajar":0,"gerhana":0}
	for difficulty in ["easy","normal","hard"]:
		for seed_value in range(80):
			d = Duel.new()
			d.difficulty = difficulty
			d.start(seed_value,floori(seed_value/2.0)%2,Catalog.DECK if seed_value%2 == 0 else Catalog.GERHANA,Catalog.GERHANA if seed_value%2 == 0 else Catalog.DECK)
			var steps := 0
			while not d.over and steps < 1200:
				steps += 1
				if not d.chain.is_empty():
					responses += 1
					check(d.respond(d.priority,AI.response(d,d.priority)),"Legal AI response")
				else:
					var action: Dictionary = AI.main_action(d) if d.phase == "MAIN" else AI.battle_action(d)
					if not AI.apply(d,action):
						d.end_turn()
				for side in range(2):
					var total: int = d.decks[side].size()+d.hands[side].size()+d.graves[side].size()
					for c in d.fields[side]+d.backrows[side]:
						if not c.is_empty(): total += 1
					check(total == 20,"Card conservation with backrow and chains")
					check(d.lp[side] >= 0 and d.lp[side] <= 4000,"Valid LP")
			check(d.over,"Duel terminates: %s %d" % [difficulty,seed_value])
			if d.over:
				complete += 1
				var player_fajar: bool = seed_value%2 == 0
				wins["fajar" if (d.winner == 0) == player_fajar else "gerhana"] += 1
	print("STRATEGY CHECKS: %d / FAILURES: %d / COMPLETE DUELS: %d / RESPONSES: %d" % [checks,failures,complete,responses])
	print("ARCHETYPE WINS (three AI levels, both starting orders): ",wins)
	quit(0 if failures == 0 else 1)
