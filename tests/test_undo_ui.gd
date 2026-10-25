extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
const Duel = preload("res://scripts/duel.gd")
var board
var checks := 0
var failures := 0
var capture_dir := ""
func check(ok: bool, why: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(why)
func signature() -> String:
	var data := {}
	for key in Duel.SNAPSHOT_FIELDS: data[key] = board.duel.get(key)
	return JSON.stringify(data)
func _initialize() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--capture-dir="): capture_dir = arg.trim_prefix("--capture-dir=")
	call_deferred("run")
func capture(name_value: String) -> void:
	await process_frame
	await process_frame
	if not capture_dir.is_empty() and DisplayServer.get_name() != "headless":
		RenderingServer.force_draw(false)
		root.get_texture().get_image().save_png(capture_dir.path_join(name_value+".png"))
func fresh() -> void:
	board._begin_duel(0)
	board.duel.turn_number = 3
	board.duel.hands = [[],[]]
	board.duel.fields = [[{},{},{}],[{},{},{}]]
	board.duel.backrows = [[{},{},{}],[{},{},{}]]
	board._render()
func unit(id: String) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"uid":18,"shield":false})
	return c
func ctrl_z() -> void:
	var key := InputEventKey.new()
	key.keycode = KEY_Z
	key.ctrl_pressed = true
	key.pressed = true
	Input.parse_input_event(key)
	await process_frame
	key = key.duplicate()
	key.pressed = false
	Input.parse_input_event(key)
	await process_frame
func click(node: Control) -> void:
	var event := InputEventMouseButton.new()
	event.position = node.global_position+node.size/2
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	Input.parse_input_event(event)
	await process_frame
	event = event.duplicate()
	event.pressed = false
	Input.parse_input_event(event)
	await process_frame
func run() -> void:
	root.size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	fresh()
	check(board.undo_button.disabled,"Undo starts disabled")
	board.duel.hands[0] = [Catalog.card("storm")]
	board._render()
	var before: String = signature()
	board._hand_clicked(0)
	check(not board.undo_button.disabled and board.duel.lp[1] == 3500,"Player action enables Undo")
	await create_timer(.50).timeout
	await capture("eldoria-v11-before-undo")
	await ctrl_z()
	check(signature() == before and board.duel.undo_stack.is_empty(),"Ctrl+Z restores exact action state")
	await create_timer(.8).timeout
	check(roundi(board.displayed_lp[1]) == 4000 and board.fx.events.is_empty(),"Undo cancels pending LP and visual callbacks")
	await capture("eldoria-v11-after-undo")
	fresh()
	board.duel.hands[0] = [Catalog.card("storm")]
	var seal: Dictionary = Catalog.card("seal")
	seal.merge({"set_turn":1,"faceup":false})
	board.duel.backrows[1][0] = seal
	board._render()
	before = signature()
	board._hand_clicked(0)
	check(board.duel.priority == 1 and not board.undo_button.disabled,"Undo remains available while bot response is pending")
	await click(board.undo_button)
	await create_timer(.9).timeout
	check(signature() == before and board.duel.chain.is_empty(),"Mouse Undo cancels pending bot response without consuming trap")
	fresh()
	board.duel.hands[0] = [Catalog.card("noctis")]
	board.duel.fields[0][0] = unit("dawn")
	board._render()
	before = signature()
	board.duel.play(0,1)
	check(board._ace_active() and board.duel.can_undo(),"Ace summon can be undone during cut-in")
	board._undo_action()
	await create_timer(1.2).timeout
	check(signature() == before and not board._ace_active() and not board.trap_presenting,"Undo removes ace visual and invalidates its timers")
	fresh()
	board.duel.phase = "BATTLE"
	board.duel.fields[0][0] = unit("ember")
	board.duel.lp[1] = 100
	board._render()
	before = signature()
	board.duel.attack(0)
	await create_timer(1.35).timeout
	check(board.result_layer.visible and board.result_undo_button.visible,"Result offers Undo before turn commitment")
	await click(board.result_undo_button)
	check(not board.result_layer.visible and signature() == before,"Result Undo restores playable duel")
	fresh()
	board.duel.hands[0] = [Catalog.card("dawn")]
	board._render()
	board.duel.play(0,0)
	board._end_turn()
	check(board.duel.turn == 1 and board.undo_button.disabled,"End turn disables and commits Undo")
	before = signature()
	board._undo_action()
	check(signature() == before,"Undo cannot cross into opponent turn")
	board._open_menu()
	# Test real Vorbis looping in Godot near the seam.
	check(absf(board.music.stream.get_length()-160.0) < .01,"Full soundtrack lasts 160 seconds")
	board.music.seek(159.85)
	board.urgency_music.seek(159.85)
	await create_timer(.6).timeout
	check(board.music.playing and board.urgency_music.playing and board.music.get_playback_position() < 1.0,"Both soundtrack stems continue through loop boundary")
	check(absf(board.music.get_playback_position()-board.urgency_music.get_playback_position()) < .12,"Sample stems stay aligned across loop")
	board.queue_free()
	await process_frame
	await create_timer(.35).timeout
	print("UNDO UI & SCORE: %d checks / %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
