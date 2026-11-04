extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
var board
var failures := 0
var checks := 0
var capture_dir: String = ""
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(label)
func _initialize() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--capture-dir="): capture_dir = arg.trim_prefix("--capture-dir=")
	call_deferred("run")
func wheel(point: Vector2, direction: MouseButton = MOUSE_BUTTON_WHEEL_DOWN, shift: bool = false) -> void:
	var motion := InputEventMouseMotion.new()
	motion.position = point
	root.push_input(motion)
	await process_frame
	var event := InputEventMouseButton.new()
	event.position = point
	event.button_index = direction
	event.shift_pressed = shift
	event.pressed = true
	root.push_input(event)
	await process_frame
	event.pressed = false
	root.push_input(event)
	await process_frame
func run() -> void:
	root.size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	board.collection_store.path = "user://description_scroll_test.json"
	board._begin_duel(0)
	board.duel.hands[0] = [Catalog.card("solar_lance"),Catalog.card("dawn")]
	board._render()
	await process_frame
	board._hand_hover(0)
	await process_frame
	var bar: VScrollBar = board.detail_desc.get_v_scroll_bar()
	check(bar.max_value > bar.page,"Long actual card description overflows")
	await wheel(board.hand_box.get_child(0).global_position+Vector2(50,60))
	check(bar.value > 0,"Wheel over hovered hand card scrolls full left description")
	var saved: float = bar.value
	board._hand_hover(0)
	await process_frame
	check(bar.value == saved,"Reinspecting same card preserves reading position")
	await wheel(board.detail_desc.global_position+Vector2(70,35))
	check(bar.value > saved,"Wheel over description itself works")
	var lower: float = bar.value
	await wheel(board.hand_box.get_child(0).global_position+Vector2(50,60),MOUSE_BUTTON_WHEEL_UP)
	check(bar.value < lower,"Wheel up over card reads earlier lines")
	for i in range(20):
		await wheel(board.hand_box.get_child(0).global_position+Vector2(50,60))
	check(is_equal_approx(bar.value,bar.max_value-bar.page),"Repeated wheel reaches final line")
	if not capture_dir.is_empty() and DisplayServer.get_name() != "headless":
		RenderingServer.force_draw(false)
		root.get_texture().get_image().save_png(capture_dir.path_join("eldoria-deskripsi-gulir.png"))
	var at_bottom: float = bar.value
	board._render()
	await process_frame
	check(is_equal_approx(bar.value,at_bottom),"Board refresh preserves same-card scroll position")
	await wheel(board.hand_box.get_child(0).global_position+Vector2(50,60),MOUSE_BUTTON_WHEEL_UP,true)
	check(is_equal_approx(bar.value,at_bottom),"Shift-wheel remains available for hand navigation")
	await wheel(board.detail_card.global_position+Vector2(90,90),MOUSE_BUTTON_WHEEL_UP)
	check(bar.value < at_bottom,"Large left card image also forwards wheel")
	board.menu_layer.show()
	var blocked: float = bar.value
	await wheel(board.hand_box.get_child(0).global_position+Vector2(50,60))
	check(bar.value == blocked,"Menu blocks background scrolling")
	board.menu_layer.hide()
	board._hand_hover(1)
	await process_frame
	check(bar.value == 0,"Different card starts at top")
	check(board.duel.hands[0].size() == 2 and not board.duel.summoned,"Reading does not play a card")
	var monster: Dictionary = Catalog.card("verdant")
	monster.merge({"uid":101,"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"shield":false})
	board.duel.fields[0][0] = monster
	var enemy: Dictionary = Catalog.card("grove")
	enemy.merge({"uid":102,"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"shield":false})
	board.duel.fields[1][0] = enemy
	board._render()
	await process_frame
	await wheel(board.zone_views[0][0].global_position+Vector2(50,60))
	check(bar.value > 0,"Own field monster forwards wheel")
	await wheel(board.zone_views[1][0].global_position+Vector2(50,60))
	check(bar.value > 0,"Enemy field monster forwards wheel")
	board.duel.backrows[0][0] = Catalog.card("trail")
	board._render()
	await process_frame
	await wheel(board.backrow_views[0][0].global_position+Vector2(25,20))
	check(bar.value > 0,"Own backrow card forwards wheel")
	board._inspect(Catalog.card("verdant"))
	await process_frame
	var lore_bar: VScrollBar = board.detail_lore.get_v_scroll_bar()
	await wheel(board.detail_lore.global_position+Vector2(60,25))
	check(lore_bar.value > 0,"Lore keeps its own native scrolling")
	board._open_menu()
	await create_timer(0.6).timeout
	board.queue_free()
	await process_frame
	await create_timer(0.3).timeout
	print("CARD DESCRIPTION SCROLL: %d checks / %d failures" % [checks,failures])
	quit(1 if failures else 0)
