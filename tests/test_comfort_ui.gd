extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
const Store = preload("res://scripts/deck_store.gd")
var board
var checks := 0
var failures := 0
func check(ok: bool, why: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(why)
func unit(id: String) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"uid":7,"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"shield":false})
	return c
func _initialize() -> void: call_deferred("run")
func capture(name_value: String) -> void:
	await process_frame
	await process_frame
	if DisplayServer.get_name() == "headless": return
	RenderingServer.force_draw(false)
	root.get_texture().get_image().save_png("C:/Users/Kafka/Documents/Codex/2026-10-25/jadi-kan-aku-mau-buat-game/outputs/"+name_value+".png")
func escape() -> void:
	var key := InputEventKey.new()
	key.keycode = KEY_ESCAPE
	key.pressed = true
	board._unhandled_key_input(key)
func run() -> void:
	var old := Store.new()
	old.path = "user://comfort_old.json"
	var file := FileAccess.open(old.path,FileAccess.WRITE)
	file.store_string(JSON.stringify({"version":1,"music_gain":.33}))
	file.close()
	old.load_data()
	check(is_equal_approx(old.music_gain,.33) and old.animation_speed == 1 and old.sfx_gain == .8,"Older profile migration defaults")
	file = FileAccess.open(old.path,FileAccess.WRITE)
	file.store_string(JSON.stringify({"version":1,"sfx_gain":"bad","animation_speed":999,"reduced_motion":[] }))
	file.close()
	old = Store.new()
	old.path = "user://comfort_old.json"
	old.load_data()
	check(old.animation_speed == 1 and old.sfx_gain == .8 and not old.reduced_motion,"Malformed preference values ignored")
	root.size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	board.collection_store.path = "user://comfort_ui_test.json"
	board.collection_store.music_gain = .7
	board.collection_store.sfx_gain = .8
	board.collection_store.animation_speed = 1
	board.collection_store.reduced_motion = false
	board._apply_comfort_preferences()
	board._open_settings()
	check(board.settings_layer.visible and board.menu_layer.visible,"Settings open from menu")
	board.settings_sfx.value = 0
	check(board.collection_store.music_gain == .7 and board.music.playing,"SFX slider independent of music")
	board._sound("attack")
	check(not board.sfx.any(func(player): return player.playing),"SFX zero is silent")
	board.settings_sfx.value = 35
	board.settings_music.value = 20
	check(is_equal_approx(board.collection_store.sfx_gain,.35) and is_equal_approx(board.music_slider.value,20),"Both music sliders synchronized without affecting effects")
	board._speed_selected(2)
	board.speed_select.select(2)
	check(is_equal_approx(board._pace(1),.5) and Engine.time_scale == 1 and board.music.pitch_scale == 1 and board.urgency_music.pitch_scale == 1,"Animation speed does not alter music or global time")
	board.reduced_check.button_pressed = true
	var reload := Store.new()
	reload.path = board.collection_store.path
	reload.load_data()
	check(reload.animation_speed == 2 and reload.reduced_motion and is_equal_approx(reload.music_gain,.2) and is_equal_approx(reload.sfx_gain,.35),"All preferences persist")
	await capture("eldoria-v15-settings")
	escape()
	check(not board.settings_layer.visible,"Escape closes settings")
	board._open_quick_guide()
	check(board.guide_page == 0 and board.guide_previous.disabled,"Quick guide starts at first step")
	board.guide_next.pressed.emit()
	board.guide_next.pressed.emit()
	check(board.guide_page == 2 and board.guide_next.disabled and board.quick_text.text.contains("Undo"),"Three pages explain response and Undo")
	await capture("eldoria-v15-quick-guide")
	escape()
	check(not board.quick_guide_layer.visible,"Escape closes guide")
	board._begin_duel(0)
	var d = board.duel
	d.turn_number = 3
	d.phase = "BATTLE"
	d.fields = [[unit("ember"),{},{}],[{},{},{}]]
	d.hands = [[],[]]
	d.backrows = [[{},{},{}],[{},{},{}]]
	board._render()
	board._open_settings()
	check(not board._can_input() and not board._can_undo_input(),"Settings prevent background actions")
	escape()
	d.attack(0)
	check(board.duel_summary.state["damage"][0] == 2500 and board.duel_summary.state["best_damage"] == 2500,"Summary tracks actual damage and best hit")
	board._undo_action()
	check(board.duel_summary.state["damage"][0] == 0 and board.duel_summary.state["moments"].is_empty(),"Undo removes cancelled achievements")
	d.lp[1] = 700
	board.duel_summary.state["last_lp"] = d.lp.duplicate()
	d.attack(0)
	check(board.duel_summary.state["damage"][0] == 700 and board.duel_summary.state["best_damage"] == 700,"Overkill summary counts only LP actually removed")
	await create_timer(.65).timeout
	check(board.result_layer.visible and board.result_summary.text.contains("700") and board.result_summary.text.contains("Naga Bara"),"Result displays actual duel highlights")
	await capture("eldoria-v15-result")
	board._undo_action()
	check(not board.result_layer.visible and board.duel_summary.state["damage"][0] == 0,"Result Undo restores statistics")
	board._begin_duel(0)
	check(board.duel_summary.state["damage"] == [0,0] and board.duel_summary.state["moments"].is_empty(),"Restart clears previous duel summary")
	# Counter-chain statistics must reflect resolution and survive repeated Undo.
	d.turn_number = 3
	d.hands = [[Catalog.card("storm")],[]]
	d.fields = [[{},{},{}],[{},{},{}]]
	d.backrows = [[Catalog.card("seal"),{},{}],[Catalog.card("seal"),{},{}]]
	for side in range(2): d.backrows[side][0].merge({"set_turn":1,"faceup":false})
	d.play(0)
	d.respond(1,0)
	d.respond(0,0)
	check(board.duel_summary.state["traps"] == [1,0] and board.duel_summary.state["damage"][0] == 500,"Cancelled enemy trap excluded, countertrap and spell counted")
	board._undo_action()
	board._undo_action()
	check(board.duel_summary.state["traps"] == [0,0] and board.duel_summary.state["moments"].is_empty() and d.lp[1] == 4000,"Undo entire counter-chain restores clean summary")
	await create_timer(.7).timeout
	check(board.duel_summary.state["damage"] == [0,0],"Delayed presentation never duplicates or revives undone statistics")
	board.fx.reduced_motion = false
	board.fx.clear_all()
	board.fx.play_card("solar_lance","cast",Vector2(400,300),Vector2(500,300))
	check(board.fx.events[0]["rate"] == 2 and is_equal_approx(board.fx.impact_delay("solar_lance","cast"),.2),"VFX time and impact share selected speed")
	await create_timer(.58).timeout
	check(board.fx.events.is_empty(),"2x effect expires in half normal duration")
	# Opening settings holds the next AI move without changing its decisions.
	d.turn = 1
	d.turn_number = 4
	board._open_settings()
	var before: String = JSON.stringify([d.hands,d.fields,d.phase,d.lp])
	board._run_ai(board.session)
	await create_timer(.65).timeout
	check(before == JSON.stringify([d.hands,d.fields,d.phase,d.lp]),"AI waits while settings are open")
	board._open_menu()
	board.queue_free()
	await process_frame
	await create_timer(.35).timeout
	print("COMFORT UI: %d checks / %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
