extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
const CardView = preload("res://scripts/card_view.gd")
const Store = preload("res://scripts/deck_store.gd")
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
func ace_count() -> int:
	var count := 0
	for child in board.fx.get_children():
		if child.get_meta("ace_cutin",false): count += 1
	return count
func run() -> void:
	root.size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	board.collection_store.path = "user://eldoria_test_presentation.json"
	check(board.music.stream != null and board.urgency_music.stream != null,"Both musical stems loaded")
	check(board.music.stream.loop and board.urgency_music.stream.loop and absf(board.music.stream.get_length()-board.urgency_music.stream.get_length()) < 0.001 and board.music.stream.get_length() >= 159.9,"Music uses aligned full-length 160-second loops")
	check(board.sound_streams.has("ace_summon") and board.sound_streams.has("heavy_impact") and board.sound_streams.has("trap_reveal"),"New action accents loaded")
	check(CardView.allow_art_motion,"Normal mode enables subtle art motion")
	var card_view = CardView.new()
	card_view.size = Vector2(142,144)
	var motion := InputEventMouseMotion.new()
	motion.position = Vector2(120,30)
	card_view._inspect_input(motion)
	check(card_view.art_offset.x > 0 and card_view.art_offset.y < 0,"Card art responds to pointer while text frame stays fixed")
	card_view.free()
	board._begin_duel(0)
	check(is_instance_valid(board.fx.glow_painter) and board.fx.glow_painter.glow_pass,"Glow renderer survives duel reset")
	board.duel.hands[0] = [Catalog.card("noctis")]
	board.duel.fields[0][0] = unit("dawn")
	board._render()
	check(board.duel.play(0,1),"Ace tribute summon accepted")
	check(ace_count() == 1 and board._ace_active() and not board._can_input(),"Signature summon has one short protected cut-in")
	await create_timer(0.27).timeout
	await capture("eldoria-v10-ace-noctis")
	board.help_layer.show()
	await process_frame
	for child in board.fx.get_children():
		if child.get_meta("ace_cutin",false): check(not child.visible,"Cut-in respects help modal")
	board.help_layer.hide()
	await create_timer(1.0).timeout
	check(ace_count() == 0 and not board._ace_active() and board._can_input(),"Cut-in expires and input resumes")
	board._show_ace_intro(Catalog.card("noctis"),0)
	check(ace_count() == 0,"Same ace does not replay repeatedly in one duel")
	board._begin_duel(0)
	check(board.ace_seen.is_empty(),"New duel restores first-summon celebration")
	board.duel.turn_number = 3
	board.duel.phase = "BATTLE"
	board.duel.fields = [[unit("noctis"),{},{}],[unit("dawn"),{},{}]]
	board._render()
	board.duel.attack(0,0)
	check(board.fx.events.back().get("shatter",false),"Lethal monster hit requests shatter geometry")
	await create_timer(0.45).timeout
	await capture("eldoria-v10-noctis-impact")
	await create_timer(0.6).timeout
	board.duel.lp[0] = 1200
	board._render()
	await create_timer(0.8).timeout
	check(board.urgency_music.volume_db > -40 and board.urgency_music.volume_db < board.music.volume_db,"Low LP adds musical urgency layer")
	check(absf(board.music.get_playback_position()-board.urgency_music.get_playback_position()) < 0.12,"Stems stay synchronized")
	board._toggle_audio()
	check(board.music.stream_paused and board.urgency_music.stream_paused,"Mute pauses both stems")
	board._toggle_audio()
	board.music_slider.value = 0
	await create_timer(0.8).timeout
	check(board.music.volume_db < -79 and board.urgency_music.volume_db < -79,"BGM slider zero silences only music")
	board.music_slider.value = 70
	await create_timer(0.8).timeout
	var saved = Store.new()
	saved.path = board.collection_store.path
	saved.load_data()
	check(is_equal_approx(saved.music_gain,0.70),"Music volume persists")
	board._open_menu()
	await create_timer(0.8).timeout
	check(board.urgency_music.volume_db < -79,"Menu quiets urgency layer")
	board._begin_duel(0)
	board._toggle_effect_mode()
	check(not CardView.allow_art_motion,"Reduced mode disables art movement")
	board._show_ace_intro(Catalog.card("ember"),0)
	check(ace_count() == 0 and not board._ace_active(),"Reduced mode skips ace cut-ins")
	board.fx.play_card("ember","enter",Vector2(488,405),Vector2(488,405))
	await create_timer(0.5).timeout
	check(board.fx.events.is_empty() and not board.fx.is_processing(),"Layered renderer goes idle after events")
	board._open_menu()
	board.queue_free()
	await process_frame
	await create_timer(0.35).timeout
	print("PRESENTATION: %d checks / %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
