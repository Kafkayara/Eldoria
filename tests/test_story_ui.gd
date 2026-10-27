extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
const Flow = preload("res://scripts/story_flow.gd")
const Data = preload("res://scripts/story_data.gd")
const Store = preload("res://scripts/deck_store.gd")
var board
var checks := 0
var failures := 0
func check(ok: bool, why: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(why)
func _initialize() -> void: call_deferred("run")
func capture(name_value: String) -> void:
	if board.story_view.visible and board.story_view.dialogue.visible: board.story_view.reveal_all()
	await process_frame
	await process_frame
	if DisplayServer.get_name() == "headless": return
	RenderingServer.force_draw(false)
	root.get_texture().get_image().save_png("C:/Users/Kafka/Documents/Codex/2026-10-25/jadi-kan-aku-mau-buat-game/outputs/"+name_value+".png")
func unit(id: String) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"uid":7,"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"shield":false})
	return c
func read_scene() -> void:
	var view = board.story_view
	var cap := 0
	var phase: String = view.progress["phase"]
	while view.dialogue.visible and view.progress["phase"] == phase and cap < 100:
		cap += 1
		await process_frame
		view.reveal_all()
		check(view.body.get_content_height() <= view.body.size.y,"Dialogue page fits reading panel")
		var page: Dictionary = Flow.pages(view.progress)[view.progress["line"]]
		if page.has("options"): view.choice_buttons[0].pressed.emit()
		else: view.next_button.pressed.emit()
		await process_frame
	check(cap < 100,"Story scene has an exit")
func fixture_win() -> void:
	var d = board.duel
	d.turn = 0
	d.turn_number = 3
	d.phase = "BATTLE"
	d.hands = [[],[]]
	d.fields = [[unit("ember"),{},{}],[{},{},{}]]
	d.backrows = [[{},{},{}],[{},{},{}]]
	d.lp = [4000,700]
	board.duel_summary.state["last_lp"] = d.lp.duplicate()
	board._render()
	d.attack(0)
	await create_timer(.7).timeout
func run() -> void:
	root.size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	board.collection_store.path = "user://eldoria_story_ui_test.json"
	board.collection_store.story_progress = Flow.initial()
	board.collection_store.active = "gerhana"
	board.collection_store.enemy = "fajar"
	board.collection_store.animation_speed = 2
	board.collection_store.reduced_motion = true
	board._apply_comfort_preferences()
	board._open_story()
	var view = board.story_view
	check(view.visible and not board.menu_layer.visible and view.chapter_buttons[1].disabled,"Story hub opens with future chapters locked")
	view.open_journal()
	check(not view.journal_body.text.contains("sembilan belas"),"Journal does not reveal locked plot")
	view.journal.hide()
	await capture("eldoria-v18-story-book")
	view.resume_button.pressed.emit()
	check(view.body.text.contains("Tiga tahun") and not board._can_input(),"Opening prose and background input lock")
	await capture("eldoria-v18-story-dialogue")
	view.next_button.pressed.emit()
	var mark: int = view.progress["line"]
	board._open_menu()
	board._open_story()
	view.resume_button.pressed.emit()
	check(view.progress["line"] == mark,"Continue restores exact dialogue page")
	for chapter_index in range(5):
		check(view.progress["chapter"] == chapter_index,"Correct chapter sequence")
		if chapter_index > 0:
			await capture("eldoria-v18-chapter-"+str(chapter_index+1))
		await read_scene()
		check(board.coin_layer.visible and board.story_mode and not view.visible,"Story duel uses coin flip")
		check(board.coin_rule.text.contains(Data.CHAPTERS[chapter_index]["opponent"]),"Coin labels use story opponent")
		board._reveal_coin(0,board.session)
		board._confirm_coin()
		check(board.duel.who(1) == Data.CHAPTERS[chapter_index]["opponent"] and board.opponent_label.text.contains(Data.CHAPTERS[chapter_index]["opponent"].to_upper()),"Opponent identity in rules and board")
		check(board.duel.hands[0].size()+board.duel.decks[0].size() == 20 and board.collection_store.active == "gerhana","Story deck override leaves free-duel preference intact")
		if chapter_index == 3:
			var actual: Array = []
			for card in board.duel.hands[0]+board.duel.decks[0]: actual.append(card["id"])
			actual.sort()
			var expected: Array = Catalog.GERHANA.duplicate()
			expected.sort()
			check(actual == expected,"Chapter four perspective uses actual Gerhana preset")
			await capture("eldoria-v18-liora-duel")
		if chapter_index == 1:
			board.duel._damage(0,4000)
			board.duel._check_end()
			await create_timer(.45).timeout
			board.result_main_button.pressed.emit()
			check(view.progress["phase"] == "loss" and view.progress["cleared"] == 1,"Defeat has authored response and preserves progress")
			await read_scene()
			board._reveal_coin(0,board.session)
			board._confirm_coin()
		await fixture_win()
		check(board.result_layer.visible and view.progress["cleared"] == chapter_index,"Victory waits for confirmation before unlocking chapter")
		if chapter_index == 0:
			await capture("eldoria-v18-story-result")
			board._undo_action()
			check(not board.duel.over and view.progress["cleared"] == 0,"Undo victory never grants premature story progress")
			board.duel.attack(0)
			await create_timer(.7).timeout
		board.result_main_button.pressed.emit()
		check(view.progress["phase"] == "win" and view.progress["cleared"] == chapter_index+1,"Confirmed result unlocks exactly one chapter")
		var reload := Store.new()
		reload.path = board.collection_store.path
		reload.load_data()
		check(reload.story_progress == view.progress,"Chapter result survives save/reload")
		await read_scene()
	check(view.progress["phase"] == "ending","Final victory leads to epilogue")
	await read_scene()
	check(view.progress["phase"] == "complete" and view.progress["cleared"] == 5 and view.progress["choices"].size() == 3,"All five chapters and epilogue choices finish")
	view.open_journal()
	check(view.journal_body.text.contains("Suaka bersama"),"Finished journal remembers the journey")
	await capture("eldoria-v18-memory-journal")
	view.journal.hide()
	view.select_chapter(0)
	check(view.progress["cleared"] == 5,"Replay preserves unlocked chapters")
	board._open_menu()
	board._start_free_duel()
	board._reveal_coin(0,board.session)
	board._confirm_coin()
	check(not board.story_mode and board.duel.who(1) == "Nyx" and board.collection_store.active == "gerhana","Free duel restores Nyx and chosen presets")
	board._open_menu()
	board.queue_free()
	await process_frame
	await create_timer(.35).timeout
	print("STORY UI: %d checks / %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
