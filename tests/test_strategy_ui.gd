extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
const Store = preload("res://scripts/deck_store.gd")
var board
var failures := 0
var checks := 0
var capture_dir := ""
func check(ok: bool, why: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(why)
func _initialize() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--capture-dir="): capture_dir = arg.trim_prefix("--capture-dir=")
	call_deferred("run")
func capture(name_value: String) -> void:
	await process_frame
	await process_frame
	if not capture_dir.is_empty() and DisplayServer.get_name() != "headless":
		RenderingServer.force_draw(false)
		root.get_texture().get_image().save_png(capture_dir.path_join(name_value+".png"))
func run() -> void:
	root.size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	board.collection_store.path = "user://eldoria_test_ui_decks.json"
	check(board.deck_select.item_count >= 2 and board.ai_select.item_count == 3,"Deck and difficulty selectors")
	await capture("eldoria-v08-menu")
	board._open_builder()
	var b = board.builder
	check(b.visible and b.draft.size() == 20,"Builder loads active deck")
	b.load_deck("gerhana")
	check(b.draft == Catalog.GERHANA,"Load second archetype")
	await capture("eldoria-v08-deck-builder")
	b.remove_card("owl")
	check(b.save_button.disabled,"Incomplete deck cannot save")
	b.add_card("dawn")
	check(not b.save_button.disabled,"Valid mixed deck may save")
	b.title_edit.text = "Gerhana Eksperimen"
	b.save_draft()
	check(board.collection_store.active.begins_with("custom_"),"Saving selects custom deck")
	var saved_id: String = board.collection_store.active
	var s = Store.new()
	s.path = board.collection_store.path
	s.load_data()
	check(s.active == saved_id and s.cards(saved_id).has("dawn"),"UI save persists exact custom deck")
	check(board.deck_select.item_count == 3,"Custom deck appears in menu choices")
	b.choose("mirror")
	b.inspect_requested.emit(Catalog.card("mirror"))
	check(board.zoom_layer.visible and board.zoom_type.text.contains("TRAP"),"Trap detail displays card type")
	await capture("eldoria-v08-trap-detail")
	board.zoom_layer.hide()
	b.hide()
	board.ai_select.item_selected.emit(2)
	board._begin_duel(0)
	check(board.duel.difficulty == "hard","Chosen difficulty enters actual duel")
	var pool: Array = board.duel.decks[0]+board.duel.hands[0]
	check(pool.size() == 20 and pool.filter(func(c): return c["id"] == "dawn").size() == 1,"Actual duel uses custom composition")
	# Set through the UI, not by direct model-only test.
	board.duel.hands[0] = [Catalog.card("mirror")]
	board._render()
	board._hand_clicked(0)
	board._backrow_clicked(0,1)
	check(board.duel.backrows[0][1].get("id") == "mirror" and board.selected_hand == -1,"UI sets selected trap in chosen zone")
	await capture("eldoria-v08-board")
	# Opponent's face-down card must not disclose its name through labels/tooltips.
	var enemy_trap: Dictionary = Catalog.card("seal")
	enemy_trap.merge({"set_turn":1,"faceup":false})
	board.duel.backrows[1][0] = enemy_trap
	board._render()
	check(board.backrow_views[1][0].text == "TERTUTUP" and not board.backrow_views[1][0].tooltip_text.contains("Segel"),"Opponent hidden trap remains hidden")
	# Four links: attack -> player reflect -> bot negate -> player negate.
	board.duel.turn = 1
	board.duel.turn_number = 4
	board.duel.phase = "BATTLE"
	board.duel.fields = [[{},{},{}],[{},{},{}]]
	var sentinel: Dictionary = Catalog.card("sentinel")
	sentinel.merge({"defending":false,"attacked":false,"switched":false,"summoned_turn":2,"uid":44})
	board.duel.fields[1][0] = sentinel
	for z in range(2):
		var card: Dictionary = Catalog.card("mirror" if z == 0 else "seal")
		card.merge({"set_turn":1,"faceup":false})
		board.duel.backrows[0][z] = card
	board.duel.backrows[0][2] = {}
	board.duel.lp = [4000,4000]
	board.duel.attack(0)
	check(board.response_layer.visible and board.duel.priority == 0 and not board._can_input(),"Human response is shown during bot turn and blocks normal input")
	await capture("eldoria-v08-response")
	board._respond_player(0)
	await create_timer(0.85).timeout
	check(board.response_layer.visible and board.duel.priority == 0 and board.duel.chain.size() == 3,"Bot counter returns priority to human")
	board._respond_player(1)
	check(board.duel.chain.is_empty() and not board.response_layer.visible and board.duel.lp[0] == 4000 and board.duel.lp[1] == 3700,"UI resolves four links correctly")
	board._open_menu()
	board.queue_free()
	await process_frame
	await create_timer(0.35).timeout
	print("STRATEGY UI: %d checks / %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
