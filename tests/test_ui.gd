extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
var board
var failures: int = 0


func check(ok: bool, reason: String) -> void:
	if not ok:
		failures += 1
		push_error(reason)

func _initialize() -> void:
	call_deferred("_run")

func capture(_name_value: String) -> void:
	await process_frame
	await process_frame

func _run() -> void:
	root.size = Vector2i(1600,900)
	root.content_scale_size = Vector2i(1600,900)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	pass
	await capture("eldoria-menu")
	pass
	check(board.menu_layer.visible, "Menu visible on launch")
	var narrow = load("res://scripts/card_view.gd").new()
	narrow.data = Catalog.card("oracle")
	narrow.data["name"] = "Nama monster yang sangat panjang untuk pengujian"
	narrow.size = Vector2(30,70)
	narrow.position = Vector2(1550,800)
	root.add_child(narrow)
	await process_frame
	narrow.queue_free()
	board._start_from_menu()
	board.duel.hands[0] = [Catalog.card("dawn"),Catalog.card("blessing"),Catalog.card("blessing"),Catalog.card("storm"),Catalog.card("ember")]
	board.duel.hands[1] = [Catalog.card("fenrir"),Catalog.card("oracle"),Catalog.card("sanctuary")]
	board.duel.decks[1] = [Catalog.card("dawn"),Catalog.card("blessing")]
	board.duel.decks[0] = [Catalog.card("fenrir"),Catalog.card("oracle")]
	board._render()
	pass
	board._hand_clicked(0)
	board._zone_clicked(0,0)
	check(board.duel.fields[0][0]["id"] == "dawn", "UI summon")
	check(board.duel.hands[0].size() == 4, "Summon consumes hand card")
	pass
	board._hand_clicked(0)
	board._zone_clicked(0,0)
	check(board.duel.fields[0][0]["atk"] == 2000,"UI targeted buff")
	pass
	board._hand_clicked(0)
	board._zone_clicked(0,0)
	pass
	board._hand_clicked(0)
	check(board.duel.lp[1] == 3500,"UI immediate spell")
	pass
	board._hand_clicked(0)
	board._zone_clicked(0,1)
	check(board.duel.fields[0][1].is_empty(),"UI summon limit")
	pass
	board._end_turn()
	pass
	for i in range(80):
		if board.duel.turn == 0 or board.duel.over:
			break
		pass
		await create_timer(0.1).timeout
	check(board.duel.turn == 0 and not board.duel.over,"AI turn returns control")
	check(board.duel.turn_number == 3,"Turn progression")
	await create_timer(1.4).timeout
	await capture("eldoria-duel")
	board._battle()
	board._zone_clicked(0,0)
	board._zone_clicked(1,0)
	check(board.duel.fields[0][0].get("attacked",false),"UI attack")
	board.help_layer.show()
	await capture("eldoria-guide")
	board.help_layer.hide()
	board._toggle_audio()
	check(board.muted and board.music.stream_paused,"Mute audio")
	board._toggle_audio()
	check(not board.muted,"Unmute audio")
	pass
	board._end_turn()
	pass
	board._open_menu()
	var turn_before: int = board.duel.turn_number
	await create_timer(1.1).timeout
	check(board.duel.turn_number == turn_before,"Menu cancels pending AI")
	board._start_from_menu()
	check(board.duel.turn == 0 and board.duel.turn_number == 1,"Restart resets duel")
	board._open_menu()
	board.menu_layer.hide()
	board._finished(0)
	await capture("eldoria-victory")
	board.queue_free()
	await process_frame
	await process_frame
	await create_timer(0.3).timeout
	print("UI INTEGRATION FAILURES: %d" % failures)
	quit(failures)

