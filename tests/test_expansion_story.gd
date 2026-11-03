extends SceneTree
const Duel = preload("res://scripts/duel.gd")
const Catalog = preload("res://scripts/catalog.gd")
var failures := 0
func check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		push_error(label)
func trap(id: String) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c["set_turn"] = 1
	return c
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	var d = Duel.new()
	d.start(4)
	d.turn = 0
	d.turn_number = 3
	d.phase = "BATTLE"
	var c: Dictionary = Catalog.card("dawn")
	c.merge({"uid":10,"defending":false,"attacked":false})
	d.fields = [[c,{},{}],[{},{},{}]]
	d.backrows = [[trap("seal"),{},{}],[trap("mirror"),{},{}]]
	d.attack(0)
	d.respond(1,0)
	d.respond(0,0)
	check(d.story_flags.get("aren_breakthrough",false),"Successful attack after countering Nyx trap marks story moment")
	check(d.undo() and not d.story_flags.get("aren_breakthrough",false),"Undo reverses contextual story flags")
	var board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	board.collection_store.path = "user://expansion_story_test.json"
	board._begin_duel(0)
	board.story_mode = true
	board.story_view.progress["chapter"] = 2
	board.duel.turn = 1
	board.duel.turn_number = 3
	board.duel.hands[1] = [Catalog.card("archive")]
	board.duel.graves[1] = [Catalog.card("mirror")]
	board.duel.play(0)
	board.impact_until = 0
	await process_frame
	await process_frame
	check(board.duel.story_flags.get("nyx_archive",false),"Nyx recovery marks contextual story moment")
	check(board.story_comment.visible and board.story_comment.text.begins_with("Nyx:"),"Nyx comment appears without opening VN reader")
	check(not board.story_view.visible and not board.target_layer.visible,"Comment does not open blocking overlay")
	var count: int = board.history.size()
	board._render()
	await process_frame
	check(board.history.size() == count,"Repeated render does not repeat dialogue")
	board._open_menu()
	check(not board.story_comment.visible,"Context comment closes when leaving duel")
	await create_timer(5.2).timeout
	board.music.stop()
	board.urgency_music.stop()
	board.music.stream = null
	board.urgency_music.stream = null
	await create_timer(0.3).timeout
	await process_frame
	board.queue_free()
	await process_frame
	print("EXPANSION STORY: %d failures" % failures)
	quit(1 if failures else 0)
