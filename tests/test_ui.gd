extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
var board
var failures: int = 0
var capture_dir: String = ""


func check(ok: bool, reason: String) -> void:
	if not ok:
		failures += 1
		push_error(reason)

func _initialize() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--capture-dir="):
			capture_dir = argument.trim_prefix("--capture-dir=")
	call_deferred("_run")

func capture(name_value: String) -> void:
	await process_frame
	await process_frame
	if capture_dir.is_empty() or DisplayServer.get_name() == "headless":
		return
	RenderingServer.force_draw(false)
	var image = root.get_texture().get_image()
	var filename: String = name_value.replace("eldoria-","eldoria-v06-")
	image.save_png(capture_dir.path_join(filename+".png"))

func _run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await capture("eldoria-menu")
	check(board.menu_layer.visible, "Menu visible on launch")
	check(root.content_scale_size == Vector2i(1280,720),"Native 1280x720 layout")
	var narrow = load("res://scripts/card_view.gd").new()
	narrow.data = Catalog.card("oracle")
	narrow.data["name"] = "Nama monster yang sangat panjang untuk pengujian"
	narrow.size = Vector2(30,70)
	narrow.position = Vector2(1240,640)
	root.add_child(narrow)
	await process_frame
	narrow.queue_free()
	board._start_from_menu()
	board.duel.hands[0] = [Catalog.card("dawn"),Catalog.card("blessing"),Catalog.card("blessing"),Catalog.card("storm"),Catalog.card("ember")]
	board.duel.hands[1] = [Catalog.card("fenrir"),Catalog.card("oracle"),Catalog.card("sanctuary")]
	board.duel.decks[1] = [Catalog.card("dawn"),Catalog.card("blessing")]
	board.duel.decks[0] = [Catalog.card("fenrir"),Catalog.card("oracle")]
	board._render()
	board._hand_hover(0)
	await create_timer(0.45).timeout
	check(board.hover_card.visible,"Delayed hover preview")
	check(board.hover_card.data["id"] == "dawn","Hover preview data")
	await capture("eldoria-hover")
	board._hide_hover()
	check(not board.hover_card.visible,"Hover exit hides preview")
	var inspect_event := InputEventMouseButton.new()
	inspect_event.button_index = MOUSE_BUTTON_RIGHT
	inspect_event.pressed = true
	board.hand_box.get_child(0)._inspect_input(inspect_event)
	check(board.zoom_layer.visible,"Right-click opens card detail")
	check(board.zoom_title.text == "Penjaga Fajar","Full card name in detail")
	var hand_count: int = board.duel.hands[0].size()
	board._hand_clicked(0)
	check(board.duel.hands[0].size() == hand_count and board.selected_hand == -1,"Card modal blocks play")
	await capture("eldoria-detail")
	var cancel := InputEventAction.new()
	cancel.action = "ui_cancel"
	cancel.pressed = true
	board._unhandled_key_input(cancel)
	check(not board.zoom_layer.visible,"Esc closes card detail")
	var key := InputEventKey.new()
	key.keycode = KEY_E
	key.pressed = true
	board._unhandled_key_input(key)
	check(board.zoom_layer.visible,"E opens card detail")
	board.zoom_layer.hide()
	board._toggle_log()
	check(board.log_panel.visible,"Log drawer opens")
	board._toggle_log()
	check(not board.log_panel.visible,"Log drawer closes")
	board._hand_clicked(0)
	board._zone_clicked(0,0)
	check(board.duel.fields[0][0]["id"] == "dawn", "UI summon")
	check(board.duel.hands[0].size() == 4, "Summon consumes hand card")
	board._hand_clicked(0)
	board._zone_clicked(0,0)
	check(board.duel.fields[0][0]["atk"] == 2000,"UI targeted buff")
	board._hand_clicked(0)
	board._zone_clicked(0,0)
	board._hand_clicked(0)
	check(board.duel.lp[1] == 3500,"UI immediate spell")
	check(board.lp_targets[1] == 3500,"LP tween target")
	await create_timer(1.25).timeout
	check(roundi(board.displayed_lp[1]) == 3500,"LP counter finishes correctly")
	board._hand_clicked(0)
	board._zone_clicked(0,1)
	check(board.duel.fields[0][1].is_empty(),"UI summon limit")
	board._end_turn()
	board._open_card_zoom(Catalog.card("ember"))
	await create_timer(1.0).timeout
	check(board.duel.turn_number == 2 and not board.duel.has_monsters(1),"AI pauses for card inspection")
	board.zoom_layer.hide()
	for i in range(80):
		if board.duel.turn == 0 or board.duel.over:
			break
		await create_timer(0.1).timeout
	check(board.duel.turn == 0 and not board.duel.over,"AI turn returns control")
	check(board.duel.turn_number == 3,"Turn progression")
	await create_timer(1.4).timeout
	await capture("eldoria-duel")
	board._battle()
	board._zone_clicked(0,0)
	board._zone_clicked(1,0)
	check(board.duel.fields[0][0].get("attacked",false),"UI attack")
	check(board.combat_notice.visible and "200" in board.combat_label.text,"Combat calculation is visible")
	await create_timer(0.22).timeout
	await capture("eldoria-combat")
	board.help_layer.show()
	await capture("eldoria-guide")
	board.help_layer.hide()
	board._toggle_audio()
	check(board.muted and board.music.stream_paused,"Mute audio")
	board._toggle_audio()
	check(not board.muted,"Unmute audio")
	board._end_turn()
	board._open_menu()
	var turn_before: int = board.duel.turn_number
	await create_timer(1.1).timeout
	check(board.duel.turn_number == turn_before,"Menu cancels pending AI")
	board._start_from_menu()
	check(board.duel.turn == 0 and board.duel.turn_number == 1,"Restart resets duel")
	board.duel._damage(0,700)
	board._render()
	board._start_from_menu()
	await create_timer(0.85).timeout
	check(roundi(board.displayed_lp[0]) == 4000 and board.duel.lp[0] == 4000,"Restart cancels stale LP tween")
	check(not board.combat_notice.visible and not board.hover_card.visible,"Restart clears previews and combat notice")
	board._open_menu()
	board.menu_layer.hide()
	board._finished(0)
	await create_timer(0.85).timeout
	await capture("eldoria-victory")
	board.queue_free()
	await process_frame
	await process_frame
	await create_timer(0.3).timeout
	print("UI INTEGRATION FAILURES: %d" % failures)
	quit(failures)

