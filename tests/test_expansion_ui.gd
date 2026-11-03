extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
var failures := 0
func check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		push_error(label)
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	root.size = Vector2i(1280,720)
	var board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	board.collection_store.path = "user://expansion_ui_test.json"
	board._open_builder()
	check(board.builder.visible and board.builder.ids.size() == 34,"All 34 cards available immediately in builder")
	board.builder.title_edit.text = "Expansion test"
	board.builder.save_draft()
	var key: String = board.collection_store.active
	check(key.begins_with("custom_"),"Builder saves custom deck")
	board._close_builder()
	check(board.deck_select.item_count >= 4,"Custom deck selectable")
	board._begin_duel(0)
	board.duel.turn_number = 3
	board.duel.hands[0] = [Catalog.card("renewal")]
	board.duel.graves[0] = [Catalog.card("fenrir"),Catalog.card("grove")]
	board._hand_clicked(0)
	check(board.target_layer.visible,"Recovery opens explicit target picker")
	check(not board._can_input(),"Target picker blocks board input")
	check(board.duel.hands[0].size() == 1,"Selection does not consume spell")
	board._choose_target(1)
	check(board.duel.hands[0].back()["id"] == "grove","Chosen Grave target reaches hand")
	check(not board.target_layer.visible,"Picker closes after commit")
	board._undo_action()
	check(board.duel.graves[0].size() == 2 and board.duel.hands[0][0]["id"] == "renewal","UI Undo restores selected recovery")
	print("EXPANSION UI: %d failures" % failures)
	board._open_menu()
	await create_timer(1.5).timeout
	board.music.stop()
	board.urgency_music.stop()
	board.music.stream = null
	board.urgency_music.stream = null
	await create_timer(0.3).timeout
	await process_frame
	board.queue_free()
	await process_frame
	quit(1 if failures else 0)
