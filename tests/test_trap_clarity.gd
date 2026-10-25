extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
const Duel = preload("res://scripts/duel.gd")
const AI = preload("res://scripts/ai.gd")
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
		if arg.begins_with("--capture-dir="): capture_dir = arg.trim_prefix("--capture-dir=")
	call_deferred("run")
func capture(name_value: String) -> void:
	await process_frame
	await process_frame
	if not capture_dir.is_empty() and DisplayServer.get_name() != "headless":
		RenderingServer.force_draw(false)
		root.get_texture().get_image().save_png(capture_dir.path_join(name_value+".png"))
func unit(id: String) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"uid":11,"shield":false})
	return c
func armed(id: String) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"set_turn":1,"faceup":false})
	return c
func fresh() -> void:
	board._begin_duel(0)
	board.duel.turn_number = 3
	board.duel.fields = [[{},{},{}],[{},{},{}]]
	board.duel.backrows = [[{},{},{}],[{},{},{}]]
	board.duel.hands = [[],[]]
	board._render()
func run() -> void:
	var traps := 0
	for id in Catalog.GERHANA:
		if Catalog.CARDS[id]["kind"] == "trap": traps += 1
	check(traps == 4 and Catalog.GERHANA.size() == 20,"Gerhana has four traps in twenty cards")
	var d = Duel.new()
	d.start(19,0,Catalog.GERHANA,Catalog.GERHANA)
	d.decks[0] = [Catalog.card("mirror"),Catalog.card("mirror"),Catalog.card("storm")]
	d.hands[0] = [Catalog.card("sentinel")]
	check(d.play(0,0) and d.backrows[0][0].get("id") == "mirror","Sentinel sets mirror from deck on summon")
	check(d.decks[0].size() == 2 and d.backrows[0][0]["set_turn"] == d.turn_number and d.sentinel_used[0],"Setup conserves cards and obeys trap delay")
	d.summoned = false
	d.hands[0] = [Catalog.card("sentinel")]
	d.play(0,1)
	check(d.decks[0].size() == 2 and d.backrows[0][1].is_empty(),"Sentinel effect once per side per duel")
	d.start(20)
	check(not d.sentinel_used[0] and not d.sentinel_used[1],"Restart resets once-per-duel marker")
	d.decks[0] = [Catalog.card("mirror")]
	d.hands[0] = [Catalog.card("sentinel")]
	for z in range(3): d.backrows[0][z] = armed("seal")
	d.play(0,0)
	check(d.decks[0].size() == 1 and not d.sentinel_used[0],"Full backrow does not consume sentinel effect")
	d.start(21)
	d.decks[0] = [Catalog.card("storm")]
	d.hands[0] = [Catalog.card("sentinel")]
	d.play(0,0)
	check(d.decks[0].size() == 1 and not d.sentinel_used[0],"No matching mirror gives no free card or consumed effect")
	root.size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	check(not board.has_method("_open_builder"),"No deck-builder game entry point")
	board.collection_store.customs["custom_legacy"] = {"name":"Old deck","cards":Catalog.GERHANA}
	board.collection_store.active = "custom_legacy"
	board._refresh_deck_choices()
	check(board.deck_select.item_count == 2,"Only two preset decks are selectable")
	board._begin_duel(0)
	var total_pool: Array = board.duel.hands[0]+board.duel.decks[0]
	check(total_pool.filter(func(c): return c["id"] == "dawn").size() == 3,"Legacy custom selection cannot enter duel")
	board._open_menu()
	await capture("eldoria-v09-menu")
	board.collection_store.active = "gerhana"
	fresh()
	board.duel.hands[0] = [Catalog.card("mirror")]
	board._render()
	board._hand_clicked(0)
	for z in range(3):
		check(board.backrow_views[0][z].get_meta("valid_trap_target") and board.backrow_views[0][z].text.contains("PASANG"),"Own empty zone highlighted")
		check(not board.backrow_views[1][z].get_meta("valid_trap_target"),"Enemy zones not highlighted")
	await capture("eldoria-v09-trap-placement")
	# Real pointer event verifies the control receives clicks through the scene tree.
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.position = board.backrow_views[0][1].global_position+Vector2(35,20)
	event.pressed = true
	Input.parse_input_event(event)
	await process_frame
	event = event.duplicate()
	event.pressed = false
	Input.parse_input_event(event)
	await process_frame
	await process_frame
	check(board.duel.backrows[0][1].get("id","") == "mirror","Real click sets trap into highlighted zone")
	check(board.backrow_views[0][1].text.contains("MENUNGGU"),"Newly set trap shows waiting")
	board.duel.turn_number += 1
	board._render()
	check(board.backrow_views[0][1].text.contains("SIAP"),"Trap readiness updates next turn")
	# Each card has a visible reveal, specific effect, and an actual legal trigger.
	for id in ["mirror","seal","thorns"]:
		fresh()
		board.duel.backrows[0][0] = armed(id)
		board.duel.turn = 1
		if id == "seal":
			board.duel.hands[1] = [Catalog.card("storm")]
			board.duel.play(0)
		else:
			board.duel.phase = "BATTLE"
			board.duel.fields[1][0] = unit("sentinel")
			board.duel.attack(0)
		check(board.response_layer.visible,"Player receives legal response: "+id)
		board._respond_player(0)
		check(board.trap_presenting and not board._can_input(),"Trap presentation blocks premature actions: "+id)
		await create_timer(0.5).timeout
		check(board.fx.last_cue.get("card_id") == id,"Distinct visible trap profile: "+id)
		await capture("eldoria-v09-trap-"+id)
		await create_timer(1.2).timeout
		check(not board.trap_presenting and board.duel.chain.is_empty(),"Presentation completes: "+id)
	# An uncancelled spell must wait for both counter-trap reveals.
	fresh()
	board.fx.reduced_motion = true
	board.duel.hands[0] = [Catalog.card("storm")]
	board.duel.backrows[1][0] = armed("seal")
	board.duel.backrows[0][0] = armed("seal")
	board.duel.play(0)
	board.duel.respond(1,0)
	board._respond_player(0)
	await create_timer(1.6).timeout
	check(not board.trap_presenting and board.fx.last_cue.get("card_id") == "storm" and roundi(board.displayed_lp[1]) == 3500,"Spell presentation and LP follow counter-trap reveals")
	# Three trap links reveal sequentially; cancelled trap is still shown.
	fresh()
	board.fx.reduced_motion = true
	board.duel.turn = 1
	board.duel.phase = "BATTLE"
	board.duel.fields[1][0] = unit("sentinel")
	board.duel.backrows[0][0] = armed("mirror")
	board.duel.backrows[0][1] = armed("seal")
	board.duel.backrows[1][0] = armed("seal")
	board.duel.attack(0)
	board._respond_player(0)
	await create_timer(0.85).timeout
	check(board.response_layer.visible and board.duel.chain.size() == 3,"Bot counter allows human counter-response")
	board._respond_player(1)
	await create_timer(1.6).timeout
	check(not board.trap_presenting and board.duel.lp[0] == 4000 and board.duel.lp[1] == 3700,"Reduced mode resolves and shows multiple traps without stuck input")
	fresh()
	board.duel.backrows[0][0] = armed("mirror")
	board.duel.turn = 1
	board.duel.phase = "BATTLE"
	board.duel.fields[1][0] = unit("sentinel")
	board.duel.lp[1] = 200
	board.lp_targets[1] = 200
	board._set_lp_value(200,1)
	board.duel.attack(0)
	board._respond_player(0)
	check(board.duel.over and not board.result_layer.visible,"Lethal trap waits for its reveal")
	await create_timer(1.2).timeout
	check(board.result_layer.visible and roundi(board.displayed_lp[1]) == 0,"Lethal trap finishes LP before victory")
	fresh()
	board.duel.backrows[0][0] = armed("mirror")
	board.duel.turn = 1
	board.duel.phase = "BATTLE"
	board.duel.fields[1][0] = unit("sentinel")
	board.duel.attack(0)
	board._respond_player(0)
	board._begin_duel(0)
	await create_timer(0.5).timeout
	check(not board.trap_presenting and board.trap_visuals.is_empty() and board.duel.lp == [4000,4000],"Restart cancels pending trap reveals and LP changes")
	board._open_menu()
	board.queue_free()
	await process_frame
	await create_timer(0.35).timeout
	print("TRAP CLARITY UI: %d checks / %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
