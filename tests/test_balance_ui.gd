extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
var board
var checks := 0
var failures := 0
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
func capture(filename: String) -> void:
	await process_frame
	await process_frame
	if capture_dir.is_empty() or DisplayServer.get_name() == "headless": return
	RenderingServer.force_draw(false)
	root.get_texture().get_image().save_png(capture_dir.path_join(filename+".png"))
func unit(id: String) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"shield":c["effect"]=="shield","uid":7})
	return c
func run() -> void:
	root.size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	check(board.deck_select.item_count == 3,"Presets remain the only available decks")
	var text: String = board.deck_select.get_popup().get_item_tooltip(0)
	check(text.contains("2500") and text.contains("Segel"),"Menu explains new Fajar support")
	board._begin_duel(0)
	board._toggle_effect_mode()
	board._open_card_zoom(Catalog.card("ember"))
	check(board.zoom_stats.text.contains("2500") and board.zoom_description.text.contains("300"),"Detail shows updated stats and unchanged summon effect")
	await capture("eldoria-v12-naga-bara")
	board.zoom_layer.hide()
	board.duel.turn_number = 3
	board.duel.phase = "BATTLE"
	board.duel.fields = [[unit("ember"),{},{}],[unit("noctis"),{},{}]]
	board.duel.hands = [[],[]]
	board.duel.backrows = [[{},{},{}],[{},{},{}]]
	board._inspect(Catalog.card("ember"))
	board._render()
	check(board.zone_views[0][0].data["atk"] == 2500 and board.zone_views[1][0].data["atk"] == 2300,"Board renders both ace identities correctly")
	board.duel.attack(0,0)
	await create_timer(.4).timeout
	check(board.combat_label.text.contains("= 200 kerusakan LP") and not board.duel.fields[1][0]["shield"],"Combat explanation matches actual balanced exchange")
	await capture("eldoria-v12-dragon-clash")
	board._undo_action()
	await create_timer(.3).timeout
	check(board.duel.fields[1][0]["shield"] and board.duel.lp[1] == 4000 and board.duel.fields[0][0]["atk"] == 2500,"Undo still restores ace exchange")
	board._open_menu()
	board.queue_free()
	await process_frame
	await create_timer(.35).timeout
	print("BALANCE UI: %d checks / %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
