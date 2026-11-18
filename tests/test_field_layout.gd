extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
const CardView = preload("res://scripts/card_view.gd")
var board
var checks := 0
var failures := 0
var clicks := 0
var capture_dir := ""

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(label)

func _initialize() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--capture-dir="): capture_dir = arg.trim_prefix("--capture-dir=")
	call_deferred("run")

func unit(id: String, uid: int, defending: bool = false) -> Dictionary:
	var card: Dictionary = Catalog.card(id)
	card.merge({"uid":uid,"defending":defending,"attacked":false,"switched":false,"summoned_turn":1,"shield":false})
	return card

func capture(label: String) -> void:
	if capture_dir.is_empty() or DisplayServer.get_name() == "headless": return
	board._hide_hover()
	await process_frame
	await process_frame
	RenderingServer.force_draw(false)
	check(root.get_texture().get_image().save_png(capture_dir.path_join(label+".png")) == OK,"Save render "+label)

func click(point: Vector2) -> void:
	var motion := InputEventMouseMotion.new()
	motion.position = point
	root.push_input(motion)
	await process_frame
	for pressed in [true,false]:
		var event := InputEventMouseButton.new()
		event.position = point
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = pressed
		root.push_input(event)
		await process_frame

func fresh() -> void:
	board._begin_duel(0)
	board.duel.turn_number = 3
	board.duel.phase = "MAIN"

func run() -> void:
	root.size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	board.collection_store.path = "user://field_layout_test.json"
	board.collection_store.reduced_motion = false
	board.collection_store.animation_speed = 1.0
	board._apply_comfort_preferences()
	fresh()
	board.duel.fields = [[unit("ember",1),unit("dawn",2,true),unit("verdant",3)], [unit("noctis",4,true),unit("weaver",5),unit("tender",6,true)]]
	board.duel.fields[0][2]["piercing"] = true
	board.duel.fields[1][0]["shield"] = true
	board._render()
	await create_timer(1.2).timeout
	check(board.grave_buttons[0].get_rect().end.x < board.zone_views[0][0].position.x,"Grave button does not cover arena stats or input")
	await capture("arena-positions")
	for side in range(2):
		for zone in range(3):
			var view = board.zone_views[side][zone]
			check(view.rotation == 0 and view.scale == Vector2.ONE,"Upright labels and hit area")
			check(is_equal_approx(view.field_angle,-PI/2 if view.data["defending"] else 0),"Pose on both sides")
			check(board._zone_center(side,zone).is_equal_approx(view.position+CardView.FIELD_CENTER),"Effects match card center")
			view.pressed.connect(func(): clicks += 1)
			for offset in [Vector2(4,4),Vector2(142,138),CardView.FIELD_CENTER]:
				var before: int = clicks
				await click(view.global_position+offset)
				check(clicks == before+1,"Whole zone receives exactly one click")
	# Every corner stays in the zone throughout the rotation, including diagonals.
	for step in range(19):
		var angle: float = -PI/2*step/18
		for x in [-1,1]:
			for y in [-1,1]:
				var corner: Vector2 = CardView.FIELD_CENTER+(CardView.FIELD_BODY*Vector2(x,y)/2).rotated(angle)
				check(Rect2(Vector2.ZERO,CardView.FIELD_SIZE).has_point(corner),"Rotating body fits zone")
	for speed in [1.0,1.5,2.0]:
		fresh()
		board.collection_store.animation_speed = speed
		board._apply_comfort_preferences()
		board.duel.fields[0][0] = unit("dawn",10)
		board._render()
		board.selected_zone = 0
		board._render()
		await click(board.position_button.global_position+board.position_button.size/2)
		check(board.duel.fields[0][0]["defending"],"Position button updates model")
		await create_timer(0.28/speed).timeout
		check(is_equal_approx(board.zone_views[0][0].field_angle,-PI/2),"Rotation completes at selected speed")
		board._undo_action()
		check(is_zero_approx(board.zone_views[0][0].field_angle),"Undo restores pose immediately")
	fresh()
	board.duel.hands[0] = [Catalog.card("weaver")]
	board.duel.fields[1][0] = unit("dawn",20)
	board._render()
	check(board.duel.play(0,0,true),"Defense summon with position effect")
	check(not board.duel.pending_choice.is_empty(),"Weaver requests an explicit target")
	board._choose_target(0)
	await create_timer(0.6).timeout
	check(is_equal_approx(board.zone_views[0][0].field_angle,-PI/2),"Summon lands in defense")
	check(is_equal_approx(board.zone_views[1][0].field_angle,-PI/2),"Weaver effect rotates opponent")
	await capture("arena-defense-summon")
	var snapshot: Dictionary = board.duel.fields[1][0].duplicate(true)
	board._hold_target(snapshot,1,0,1.0)
	board.duel.fields[1][0] = {}
	board._render()
	var ghosts: Array = board.fx.get_children().filter(func(n): return n is CardView and n.get_meta("card_visual",false))
	check(ghosts.size() == 1,"One target snapshot survives model removal")
	if not ghosts.is_empty():
		check(ghosts[0].data == snapshot and is_equal_approx(ghosts[0].field_angle,-PI/2),"Snapshot retains defense and stats")
		check((ghosts[0].position+CardView.FIELD_CENTER).is_equal_approx(board._zone_center(1,0)),"Snapshot stays centered")
	await capture("arena-target-snapshot")
	board._undo_action()
	await create_timer(1.2).timeout
	check(board.zone_views[1][0].self_modulate.a == 1 and is_zero_approx(board.zone_views[1][0].field_angle),"Undo cancels snapshot and stale callbacks")
	fresh()
	board.duel.phase = "BATTLE"
	board.duel.fields = [[unit("ember",41),{},{}],[unit("dawn",42,true),{},{}]]
	board._render()
	check(board.duel.attack(0,0),"Real attack resolves against defense")
	check(board.duel.fields[1][0].is_empty(),"Real attack removes defeated target")
	ghosts = board.fx.get_children().filter(func(n): return n is CardView and n.data.get("uid",-1) == 42)
	check(ghosts.size() == 1 and is_equal_approx(ghosts[0].field_angle,-PI/2),"Combat retains pre-hit defense snapshot")
	await capture("arena-combat-snapshot")
	board._undo_action()
	await create_timer(0.8).timeout
	check(not board.duel.fields[1][0].is_empty() and is_equal_approx(board.zone_views[1][0].field_angle,-PI/2),"Undo real combat restores defending target")
	check(board.zone_views[1][0].self_modulate.a == 1,"Cancelled impact does not hide restored target")
	fresh()
	board.duel.fields[0][0] = unit("dawn",30)
	board._render()
	board.duel.switch_position(0)
	board.collection_store.reduced_motion = true
	board._apply_comfort_preferences()
	check(is_equal_approx(board.zone_views[0][0].field_angle,-PI/2),"Reduced mode finishes in-flight rotation immediately")
	await capture("arena-reduced")
	fresh()
	await create_timer(0.4).timeout
	for side in board.zone_views:
		for view in side:
			check(view.data.is_empty() and is_zero_approx(view.field_angle) and view.self_modulate.a == 1,"Restart clears poses and visibility")
	board._open_menu()
	await create_timer(3.0).timeout
	board.music.stop()
	board.urgency_music.stop()
	board.music.stream = null
	board.urgency_music.stream = null
	await create_timer(0.3).timeout
	board.queue_free()
	await process_frame
	print("FIELD LAYOUT: %d checks / %d failures" % [checks,failures])
	quit(1 if failures else 0)
