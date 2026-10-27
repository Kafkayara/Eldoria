extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
const Flow = preload("res://scripts/story_flow.gd")
const Books = preload("res://scripts/story_books.gd")
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
	var v = board.story_view
	var phase: String = v.progress["phase"]
	var cap := 0
	while v.dialogue.visible and v.progress["phase"] == phase and cap < 35:
		cap += 1
		await process_frame
		check(v.body.get_content_height() <= v.body.size.y,"Book II page fits reading panel")
		var page: Dictionary = Flow.pages(v.progress,v.Data)[v.progress["line"]]
		if page.has("options"): v.choice_buttons[0].pressed.emit()
		else: v.next_button.pressed.emit()
	check(cap < 35,"Story scene exits")
func run() -> void:
	root.size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	board.collection_store.path = "user://rimba_ui_test.json"
	board.collection_store.story_progress = Flow.initial()
	board.collection_store.story_books = {}
	board.collection_store.animation_speed = 2
	board.collection_store.reduced_motion = true
	board._apply_comfort_preferences()
	check(board.deck_select.item_count == 3 and board.enemy_select.item_count == 3,"Three decks available for player and opponent")
	board._open_story("akar_esok")
	check(board.story_view.Data.BOOK_ID == "jendela_pagi","Book II locked before Book I milestone")
	board._open_menu()
	board.collection_store.active = "rimba"
	board._begin_duel(0)
	var all: Array = []
	for c in board.duel.hands[0]+board.duel.decks[0]: all.append(c["id"])
	all.sort()
	var expected: Array = Catalog.RIMBA.duplicate()
	expected.sort()
	check(all == expected,"Free duel uses actual Rimba deck")
	var d = board.duel
	d.turn_number = 3
	d.hands = [[Catalog.card("renewal")],[]]
	d.fields = [[{},{},{}],[{},{},{}]]
	d.graves[0] = [unit("fenrir")]
	d.backrows = [[{},{},{}],[{},{},{}]]
	board._render()
	board.grave_buttons[0].pressed.emit()
	check(board.grave_layer.visible and board.grave_body.text.contains("Fenrir Zamrud") and not board._can_input(),"Clickable Grave explains automatic recovery target and blocks background input")
	await capture("eldoria-v17-grave")
	board.grave_layer.hide()
	board._hand_clicked(0)
	check(d.hands[0][0]["id"] == "fenrir" and board.fx.last_cue["card_id"] == "renewal","One-click spell recovers correct monster with visual")
	board._undo_action()
	check(d.hands[0][0]["id"] == "renewal" and d.graves[0][0]["id"] == "fenrir","UI Undo restores recovery")
	d.hands[0] = [Catalog.card("verdant")]
	d.fields[0][0] = unit("fenrir")
	d.graves[0] = [Catalog.card("grove"),Catalog.card("stag")]
	d.play(0,0)
	check(d.fields[0][0]["atk"] == 2650,"Tribute and two grave monsters produce capped ace")
	board._inspect(d.fields[0][0])
	check(board.detail_desc.text.contains("Bonus saat summon: +450"),"Ace detail explains fixed bonus")
	board._open_card_zoom(Catalog.card("verdant"))
	await capture("eldoria-v17-naga-akar")
	board.zoom_layer.hide()
	board._open_menu()
	board._open_gallery()
	board.gallery.select_card("grove")
	check(board.gallery.tiles.size() == 25,"Gallery includes all new card types")
	await capture("eldoria-v17-rimba-gallery")
	board._close_gallery()
	var old := Flow.initial()
	old.merge({"cleared":5,"chapter":4,"phase":"complete","choices":{"memory":"care","reply":"honest","ritual":"lamp"}},true)
	board.collection_store.story_progress = old.duplicate(true)
	board._open_story("akar_esok")
	var v = board.story_view
	check(v.Data.BOOK_ID == "akar_esok" and v.chapter_buttons.size() == 3,"New book has three chapters")
	await capture("eldoria-v17-book-two")
	v.resume_story()
	for chapter in range(3):
		await read_scene()
		check(board.story_mode and board.coin_layer.visible,"Book II keeps fair coin flip")
		board._reveal_coin(0,board.session)
		board._confirm_coin()
		check(board.arena_mode_label.text.contains("BUKU II"),"Board identifies active story book")
		d.turn_number = 3
		d.phase = "BATTLE"
		d.fields = [[unit("ember"),{},{}],[{},{},{}]]
		d.hands = [[],[]]
		d.backrows = [[{},{},{}],[{},{},{}]]
		d.lp[1] = 500
		d.attack(0)
		await create_timer(.7).timeout
		check(v.progress["cleared"] == chapter,"Book II victory waits for confirmation")
		board.result_main_button.pressed.emit()
		check(v.progress["cleared"] == chapter+1 and board.collection_store.story_progress == old,"Book II progression never overwrites Book I")
		await read_scene()
	check(v.progress["phase"] == "ending","Book II reaches epilogue")
	await read_scene()
	check(v.progress["phase"] == "complete" and v.progress["choices"].size() == 2,"Book II completed with responsive choices")
	var reload := Store.new()
	reload.path = board.collection_store.path
	reload.load_data()
	check(reload.story_progress == old and reload.story_books["akar_esok"]["phase"] == "complete","Both completed books survive reload")
	board._open_story("jendela_pagi")
	check(board.story_view.progress == old,"Returning to Book I restores original ending and choices")
	board._open_menu()
	board.queue_free()
	await process_frame
	await create_timer(.35).timeout
	print("RIMBA UI: %d checks / %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
