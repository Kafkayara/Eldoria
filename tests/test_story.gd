extends SceneTree
const Data = preload("res://scripts/story_data.gd")
const Flow = preload("res://scripts/story_flow.gd")
const Store = preload("res://scripts/deck_store.gd")
const Duel = preload("res://scripts/duel.gd")
const Catalog = preload("res://scripts/catalog.gd")
const AI = preload("res://scripts/ai.gd")
var checks := 0
var failures := 0
func check(ok: bool, why: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(why)
func _initialize() -> void: call_deferred("run")
func run() -> void:
	check(Data.CHAPTERS.size() == 5 and Catalog.PRESETS.size() == 3,"Five Book I duels preserved with three free-duel decks")
	check(Flow.clean(null) == Flow.initial() and Flow.clean({"version":999}) == Flow.initial(),"Invalid story profile falls back safely")
	var bad := Flow.initial()
	bad.merge({"cleared":999,"chapter":999,"phase":"ending","line":999,"choices":{"memory":"cheat","reply":[]}},true)
	var cleaned := Flow.clean(bad)
	check(cleaned["cleared"] == 5 and cleaned["chapter"] == 4 and cleaned["line"] < Data.ENDING.size() and cleaned["choices"].is_empty(),"Corrupt indices and choices sanitized")
	bad = Flow.initial()
	bad.merge({"phase":"win","chapter":4},true)
	check(Flow.clean(bad)["chapter"] == 0 and Flow.clean(bad)["phase"] == "intro","Locked completion cannot bypass chapter gates")
	var choice_counts := {}
	var total_pages := 0
	for chapter in Data.CHAPTERS:
		check(Catalog.validate(Catalog.PRESETS[chapter["player_deck"]]["cards"]).is_empty() and Catalog.validate(Catalog.PRESETS[chapter["enemy_deck"]]["cards"]).is_empty(),"Both story decks legal")
		for phase in ["intro","win","loss"]:
			check(not chapter[phase].is_empty(),"Dialogue for every outcome")
			for page in chapter[phase]:
				total_pages += 1
				check(not page["speaker"].is_empty() and not page["text"].is_empty(),"Readable authored page")
				if page.has("choice"): choice_counts[page["choice"]] = true
	for page in Data.ENDING:
		total_pages += 1
		if page.has("choice"): choice_counts[page["choice"]] = true
	check(total_pages >= 150 and choice_counts.size() == 3,"Complete manuscript and three meaningful dialogue choices")
	var st := Flow.initial()
	st["choices"] = {"memory":"laughter","reply":"uncertain","ritual":"table"}
	var callbacks := 0
	for page in Data.ENDING:
		if page.has("variant"):
			check(Flow.page_text(page,st) == page["variants"][st["choices"][page["variant"]]],"Earlier choice selects authored epilogue callback")
			callbacks += 1
	check(callbacks >= 2,"Epilogue keeps meaningful callbacks")
	var store := Store.new()
	store.path = "user://eldoria_story_model_test.json"
	store.story_progress = st
	store.story_progress.merge({"started":true,"chapter":2,"cleared":2,"phase":"intro","line":4},true)
	store.music_gain = .42
	check(store.save_data() == OK,"Story and preferences save atomically")
	var reload := Store.new()
	reload.path = store.path
	reload.load_data()
	check(reload.story_progress == store.story_progress and is_equal_approx(reload.music_gain,.42),"Exact narrative bookmark and choices reload")
	var complete := 0
	for chapter in Data.CHAPTERS:
		var wins := 0
		for seed_value in range(80):
			var d = Duel.new()
			d.enemy_name = chapter["opponent"]
			d.difficulty = chapter["difficulty"]
			d.start(90001+seed_value*19,seed_value%2,Catalog.PRESETS[chapter["player_deck"]]["cards"],Catalog.PRESETS[chapter["enemy_deck"]]["cards"])
			var actions := 0
			while not d.over and actions < 800:
				actions += 1
				if not d.chain.is_empty(): d.respond(d.priority,AI.response(d,d.priority))
				else:
					var action: Dictionary = AI.main_action(d) if d.phase == "MAIN" else AI.battle_action(d)
					if not AI.apply(d,action): d.end_turn()
			check(d.over,"Story duel terminates")
			if d.over: complete += 1
			if d.winner == 0: wins += 1
			check(d.who(1) == chapter["opponent"],"Correct opponent identity throughout rules")
		check(wins > 0 and wins < 80,"Every story matchup is winnable without forced result")
		print(chapter["id"]," player wins: ",wins,"/80")
	print("STORY MODEL: %d checks / %d failures / %d duels" % [checks,failures,complete])
	quit(0 if failures == 0 else 1)
