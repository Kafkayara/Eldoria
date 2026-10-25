extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
const Duel = preload("res://scripts/duel.gd")
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
		if arg.begins_with("--capture-dir="):
			capture_dir = arg.trim_prefix("--capture-dir=")
	call_deferred("run")
func capture(filename: String) -> void:
	await process_frame
	await process_frame
	if not capture_dir.is_empty() and DisplayServer.get_name() != "headless":
		RenderingServer.force_draw(false)
		root.get_texture().get_image().save_png(capture_dir.path_join(filename+".png"))
func reveal(side: int) -> void:
	if board.coin_tween and board.coin_tween.is_valid():
		board.coin_tween.kill()
	board._reveal_coin(side,board.session)
func run() -> void:
	root.size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	check(board.menu_layer.visible and not board.coin_layer.visible,"Launch retains menu and gallery access")
	board._start_from_menu()
	check(board.coin_layer.visible and board.coin_continue.disabled,"Coin blocks entering before result")
	check(not board._can_input(),"No duel actions during toss")
	await create_timer(1.5).timeout
	check(board.coin_side in [0,1] and not board.coin_continue.disabled,"Animated toss resolves to a valid random result")
	reveal(0)
	check(board.coin_result.text.begins_with("GAMBAR"),"Picture means player first")
	await capture("eldoria-coin-gambar")
	board._confirm_coin()
	check(board.duel.turn == 0 and board.duel.turn_number == 1,"Picture opens actual player turn")
	check(board.duel.hands[0].size() == 4 and board.duel.hands[1].size() == 4,"Four opening cards each")
	check(not board.duel.battle(),"First player cannot attack")
	board._start_from_menu()
	reveal(1)
	check(board.coin_result.text.begins_with("ANGKA"),"Number means bot first")
	await capture("eldoria-coin-angka")
	board._confirm_coin()
	check(board.duel.turn == 1 and board.duel.turn_number == 1,"Number opens actual bot turn")
	check(board.duel.hands[1].size() == 4,"Bot receives no extra first turn draw")
	check(not board.duel.battle(),"First bot cannot attack either")
	await create_timer(10.0).timeout
	check(board.duel.turn == 0 and board.duel.turn_number == 2,"Bot automatically finishes its opening turn")
	check(board.duel.hands[0].size() == 5,"Second player draws on their first turn")
	check(board.duel.battle(),"Second player may enter battle")
	board._start_from_menu()
	var stale: int = board.session
	board._open_menu()
	board._reveal_coin(1,stale)
	check(board.menu_layer.visible and not board.coin_layer.visible,"Leaving cancels pending toss")
	board.fx.reduced_motion = true
	board._start_from_menu()
	await create_timer(0.4).timeout
	check(board.coin_side in [0,1] and not board.coin_continue.disabled,"Reduced effects resolves quickly")
	board._open_menu()
	for id in Catalog.CARDS:
		var card: Dictionary = Catalog.card(id)
		check(not card.get("lore","").is_empty() and not card["text"].is_empty(),"Story and effect exist: "+id)
		board._inspect(card)
		board._open_card_zoom(card)
		board.gallery.select_card(id)
		check(board.detail_desc.text == card["text"] and board.detail_lore.text == card["lore"],"Separate board fields: "+id)
		check(board.zoom_description.text == card["text"] and board.zoom_lore.text == card["lore"],"Separate zoom fields: "+id)
		check(board.gallery.description.text == card["text"] and board.gallery.lore.text == card["lore"],"Separate gallery fields: "+id)
	board._open_menu()
	board._open_gallery()
	board.gallery.select_card("ember")
	await capture("eldoria-card-story-gallery")
	board._open_card_zoom(Catalog.card("ember"))
	await capture("eldoria-card-story-detail")
	board._open_menu()
	board.queue_free()
	await process_frame
	await create_timer(0.35).timeout
	print("COIN AND CARD TEXT: %d checks / %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
