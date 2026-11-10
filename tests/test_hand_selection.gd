extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
var board
var failures := 0
var capture_dir := ""
func check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		push_error(label)
func _initialize() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--capture-dir="): capture_dir = arg.trim_prefix("--capture-dir=")
	call_deferred("run")
func click(point: Vector2) -> void:
	var motion := InputEventMouseMotion.new()
	motion.position = point
	root.push_input(motion)
	await process_frame
	for pressed in [true,false]:
		var event := InputEventMouseButton.new()
		event.position = point
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = pressed
		root.push_input(event)
		await process_frame
	await create_timer(0.2).timeout
func run() -> void:
	root.size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	board.collection_store.path = "user://hand_selection_test.json"
	board._begin_duel(0)
	board.duel.hands[0] = [Catalog.card("dawn"),Catalog.card("fenrir"),Catalog.card("mirror")]
	board._render()
	await process_frame
	await process_frame
	var baseline: float = board.hand_box.get_child(0).global_position.y
	await click(board.hand_box.get_child(0).global_position+Vector2(60,70))
	var selected = board.hand_box.get_child(0)
	check(board.selected_hand == 0 and selected.selected,"Click selects hand card")
	check(selected.global_position.y <= baseline-20,"Selected card rises above hand")
	check(selected.global_position.y-6 >= board.hand_scroll.global_position.y,"Outline fits inside scroll viewport")
	if not capture_dir.is_empty() and DisplayServer.get_name() != "headless":
		board._hide_hover()
		RenderingServer.force_draw(false)
		root.get_texture().get_image().save_png(capture_dir.path_join("eldoria-kartu-terpilih.png"))
	await click(selected.global_position+Vector2(60,5))
	check(board.selected_hand == -1,"Raised top edge remains clickable to deselect")
	check(is_equal_approx(board.hand_box.get_child(0).global_position.y,baseline),"Deselected card returns to hand")
	await click(board.hand_box.get_child(1).global_position+Vector2(60,70))
	check(board.selected_hand == 1 and board.hand_box.get_child(1).global_position.y < baseline,"Other card can be selected")
	check(not board.hand_box.get_child(0).selected,"Only selected hand card has outline")
	var old_defense: bool = board.summon_defense
	await click(board.mode_button.global_position+board.mode_button.size/2)
	check(board.summon_defense != old_defense,"Summon mode remains clickable above raised hand area")
	board._battle()
	check(board.selected_hand == 1,"First-turn battle rejection preserves selection")
	board.duel.turn_number = 3
	board._battle()
	await process_frame
	check(board.selected_hand == -1,"Entering battle clears hand lift")
	board.duel.phase = "MAIN"
	board.collection_store.reduced_motion = true
	board._apply_comfort_preferences()
	board._hand_clicked(0)
	await process_frame
	await process_frame
	check(board.hand_box.get_child(0).global_position.y < baseline,"Reduced motion retains selected state")
	check(board.duel.hands[0].size() == 3 and not board.duel.summoned,"Visual selection does not play cards")
	board._open_menu()
	await create_timer(0.6).timeout
	board.queue_free()
	await process_frame
	await create_timer(0.3).timeout
	print("HAND SELECTION: %d failures" % failures)
	quit(1 if failures else 0)
