extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
var board
var capture_dir := ""
func _initialize() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--capture-dir="): capture_dir = arg.trim_prefix("--capture-dir=")
	call_deferred("run")
func capture(label: String) -> void:
	await process_frame
	await process_frame
	RenderingServer.force_draw(false)
	if not capture_dir.is_empty():
		root.get_texture().get_image().save_png(capture_dir.path_join(label+".png"))
func run() -> void:
	root.size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	board.collection_store.path = "user://preview_cinematic.json"
	board.collection_store.animation_speed = 1.0
	board.collection_store.reduced_motion = false
	board._apply_comfort_preferences()
	for id in ["ember","noctis","verdant"]:
		board._begin_duel(0)
		board._show_ace_intro(Catalog.card(id),0)
		for child in board.fx.get_children():
			if child.get_meta("ace_cutin",false):
				child.set_process(false)
				child.age = 0.9
				child._update_stage()
		await capture("ace-"+id)
	board._begin_duel(0)
	board.duel.turn_number = 3
	board.duel.phase = "BATTLE"
	var dragon: Dictionary = Catalog.card("ember")
	dragon.merge({"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"uid":1,"shield":false})
	board.duel.fields = [[dragon,{},{}],[{},{},{}]]
	board.duel.lp[1] = 100
	board.displayed_lp[1] = 100.0
	board.lp_targets[1] = 100
	board._render()
	board.duel.attack(0)
	await create_timer(.57).timeout
	await capture("finisher-impact")
	board._open_menu()
	board.queue_free()
	await process_frame
	await create_timer(2.2).timeout
	quit()
