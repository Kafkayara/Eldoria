extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
var destination: String
func _initialize() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--capture-dir="): destination = arg.trim_prefix("--capture-dir=")
	if destination.is_empty():
		push_error("Provide --capture-dir for preview files")
		quit(1)
		return
	call_deferred("run")
func capture(name_value: String) -> void:
	await process_frame
	await process_frame
	RenderingServer.force_draw(false)
	root.get_texture().get_image().save_png(destination.path_join(name_value+".png"))
func run() -> void:
	root.size = Vector2i(1280,720)
	var board = load("res://main.tscn").instantiate()
	root.add_child(board)
	board.collection_store.path = "user://preview_expansion.json"
	await process_frame
	board._open_builder()
	board.builder.choose("cinder")
	await capture("eldoria-deck-builder")
	board.builder.choose("roots")
	await capture("eldoria-jalinan-akar")
	board._close_builder()
	board._begin_duel(0)
	board.duel.turn_number = 3
	board.duel.hands[0] = [Catalog.card("renewal")]
	board.duel.graves[0] = [Catalog.card("grove"),Catalog.card("fenrir"),Catalog.card("tender")]
	board._hand_clicked(0)
	await capture("eldoria-pilih-target")
	board._choose_target(-1)
	board._open_menu()
	await capture("eldoria-menu-baru")
	print("Expansion previews saved")
	quit()
