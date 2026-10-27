extends SceneTree
const Duel = preload("res://scripts/duel.gd")
const Catalog = preload("res://scripts/catalog.gd")
const AI = preload("res://scripts/ai.gd")
const Hints = preload("res://scripts/duel_hints.gd")
const Store = preload("res://scripts/deck_store.gd")
const Flow = preload("res://scripts/story_flow.gd")
const Books = preload("res://scripts/story_books.gd")
var checks := 0
var failures := 0
func check(ok: bool, why: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(why)
func unit(id: String) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"uid":7,"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"shield":false})
	return c
func fresh():
	var d = Duel.new()
	d.start(55,0,Catalog.RIMBA,Catalog.DECK)
	d.turn_number = 3
	d.hands = [[],[]]
	d.fields = [[{},{},{}],[{},{},{}]]
	d.backrows = [[{},{},{}],[{},{},{}]]
	return d
func trap(d):
	d.backrows[1][0] = Catalog.card("seal")
	d.backrows[1][0].merge({"set_turn":1,"faceup":false})
func _initialize() -> void: call_deferred("run")
func run() -> void:
	check(Catalog.CARDS.size() == 25 and Catalog.PRESETS.size() == 3,"Five new cards and third deck")
	check(Catalog.validate(Catalog.RIMBA).is_empty(),"20-card Rimba preset legal")
	var d = fresh()
	d.hands[0] = [Catalog.card("renewal")]
	check(not d.play(0) and d.hands[0].size() == 1 and d.undo_stack.is_empty(),"No Grave target rejects without consuming spell or Undo")
	check(not Hints.hand_reason(d,d.hands[0][0]).is_empty(),"Hand explains missing Grave target")
	d.graves[0] = [Catalog.card("dawn"),Catalog.card("verdant"),unit("fenrir"),Catalog.card("grove")]
	d.graves[0][2]["atk"] = 100
	d.graves[0][2]["piercing"] = true
	check(d.recover_index(0) == 2,"Recovery uses base ATK, excludes non-ALAM and high level")
	d.play(0)
	check(d.hands[0][0]["id"] == "fenrir" and d.hands[0][0]["atk"] == 1800 and not d.hands[0][0].has("uid") and not d.hands[0][0].has("piercing"),"Recovery removes prior field buffs and identity")
	check(d.graves[0].size() == 4 and d.backrows[0][0].is_empty(),"Spell replaces recovered grave card; no duplication")
	check(d.undo() and d.graves[0][2]["atk"] == 100 and d.hands[0][0]["id"] == "renewal","Undo restores exact prior grave and hand")
	d = fresh()
	d.hands[0] = [Catalog.card("renewal")]
	d.graves[0] = [Catalog.card("grove"),Catalog.card("grove")]
	check(d.recover_index(0) == 1,"Equal recovery chooses latest Grave card")
	trap(d)
	d.play(0)
	d.respond(1,0)
	check(d.hands[0].is_empty() and d.graves[0].size() == 3,"Seal cancels recovery")
	d = fresh()
	d.hands[0] = [Catalog.card("grove")]
	d.play(0,0)
	check(not d.grove_used[0],"Empty Grave does not spend once-per-duel recovery")
	d.summoned = false
	d.hands[0] = [Catalog.card("grove")]
	d.graves[0] = [Catalog.card("fenrir")]
	d.play(0,1)
	check(d.grove_used[0] and d.hands[0][0]["id"] == "fenrir","Grove recovery triggers and marks shared limit")
	check(d.undo() and not d.grove_used[0] and d.graves[0][0]["id"] == "fenrir","Undo restores shared recovery limit")
	d.play(0,1)
	d.summoned = false
	d.graves[0] = [Catalog.card("stag")]
	d.hands[0] = [Catalog.card("grove")]
	d.play(0,2)
	check(d.hands[0].is_empty() and d.graves[0].size() == 1,"Other Grove copies cannot bypass duel limit")
	d = fresh()
	d.hands[0] = [Catalog.card("verdant")]
	d.fields[0][0] = unit("fenrir")
	d.graves[0] = [Catalog.card("grove"),Catalog.card("stag"),Catalog.card("fenrir")]
	d.play(0,0)
	check(d.fields[0][0]["atk"] == 2650 and d.fields[0][0]["root_bonus"] == 450,"Root bonus includes tribute, caps at three")
	d.graves[0].clear()
	check(d.fields[0][0]["atk"] == 2650,"Root bonus remains fixed after Grave changes")
	check(d.undo() and d.fields[0][0]["id"] == "fenrir" and d.graves[0].size() == 3,"Undo restores tribute and pre-summon resources")
	d = fresh()
	d.hands[0] = [Catalog.card("compost")]
	d.graves[0] = [unit("fenrir")]
	d.decks[0] = [Catalog.card("dawn")]
	d.lp[0] = 3700
	d.play(0)
	check(d.hands[0][0]["id"] == "dawn" and d.decks[0][0]["id"] == "fenrir" and d.lp[0] == 4000,"Compost inserts at deck bottom, draws top, caps healing")
	check(d.undo() and d.graves[0][0].has("uid") and d.lp[0] == 3700,"Undo restores compost draw, heal and exact Grave")
	d = fresh()
	d.hands[0] = [Catalog.card("compost")]
	d.graves[0] = [Catalog.card("stag")]
	d.decks[0] = []
	d.play(0)
	check(not d.over and d.hands[0][0]["id"] == "stag" and d.decks[0].is_empty(),"Compost draws recovered card if deck was empty, no infinite generation")
	d = fresh()
	d.hands[0] = [Catalog.card("renewal")]
	d.graves[0] = [Catalog.card("fenrir")]
	d.summoned = true
	d.play(0)
	check(not d.play(0,0),"Recovery does not grant additional normal summon")
	var old := Flow.initial()
	old.merge({"cleared":5,"chapter":4,"phase":"complete","choices":{"memory":"laughter","reply":"honest","ritual":"table"}},true)
	var store := Store.new()
	store.path = "user://rimba_books_test.json"
	store.story_progress = old.duplicate(true)
	var second := Flow.initial(Books.Second)
	second.merge({"cleared":1,"chapter":1,"line":3,"started":true,"choices":{"seed":"share"}},true)
	store.story_books[Books.Second.BOOK_ID] = second
	store.story_active_book = Books.Second.BOOK_ID
	check(store.save_data() == OK,"Book registry saves")
	var reload := Store.new()
	reload.path = store.path
	reload.load_data()
	check(reload.story_progress == old and reload.story_books[Books.Second.BOOK_ID] == second,"Both books, choices and exact cursor survive reload")
	check(reload.story_active_book == Books.Second.BOOK_ID,"Active book persists")
	check(Flow.clean(old,Books.Second) == Flow.initial(Books.Second),"Book I data cannot be mistaken for Book II")
	var complete := 0
	for chapter in Books.Second.CHAPTERS:
		var wins := 0
		for seed_value in range(40):
			d = Duel.new()
			d.difficulty = chapter["difficulty"]
			d.start(80001+seed_value*19,seed_value%2,Catalog.PRESETS[chapter["player_deck"]]["cards"],Catalog.PRESETS[chapter["enemy_deck"]]["cards"])
			var steps := 0
			while not d.over and steps < 1000:
				steps += 1
				if not d.chain.is_empty(): d.respond(d.priority,AI.response(d,d.priority))
				else:
					var action: Dictionary = AI.main_action(d) if d.phase == "MAIN" else AI.battle_action(d)
					if not AI.apply(d,action): d.end_turn()
				for side in range(2):
					var total: int = d.hands[side].size()+d.decks[side].size()+d.graves[side].size()
					for c in d.fields[side]+d.backrows[side]:
						if not c.is_empty(): total += 1
					check(total == 20,"Recovery and recycling conserve exact twenty cards")
			check(d.over,"Book II duel terminates, including Rimba mirror")
			if d.over: complete += 1
			if d.winner == 0: wins += 1
		check(wins > 0 and wins < 40,"Book II chapter has no forced result")
	print("Book II simulated duels completed: ",complete)
	print("RIMBA MODEL: %d checks / %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
