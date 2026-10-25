extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
const Effects = preload("res://scripts/effects.gd")
var board
var checks: int = 0
var failures: int = 0
var capture_dir: String = ""

func _initialize() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--capture-dir="):
			capture_dir = argument.trim_prefix("--capture-dir=")
	call_deferred("_run")

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("FAIL: "+label)

func unit(id: String) -> Dictionary:
	var card: Dictionary = Catalog.card(id)
	card.merge({"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"shield":id=="warden"})
	return card

func fresh(side: int = 0) -> void:
	board._new_duel()
	board.duel.turn = side
	board.duel.turn_number = 3
	board.duel.phase = "MAIN"
	board.duel.summoned = false
	board.duel.fields = [[{},{},{}],[{},{},{}]]
	board.duel.hands = [[],[]]
	board.duel.lp = [4000,4000]
	board._render()

func capture(name_value: String) -> void:
	await process_frame
	await process_frame
	if capture_dir.is_empty() or DisplayServer.get_name() == "headless":
		return
	RenderingServer.force_draw(false)
	root.get_texture().get_image().save_png(capture_dir.path_join(name_value+".png"))

func samples(id: String, action: String) -> void:
	board.fx.set_process(false)
	var profile: Dictionary = Effects.PROFILES[id]
	for time_value in [0.0,0.04,0.17,float(profile["impact"])-0.03,float(profile["impact"])+0.06,float(profile["duration"])-0.03]:
		for event in board.fx.events:
			event["time"] = maxf(0,time_value)
		board.fx.redraw_effects()
		await process_frame
		await process_frame
		if (id == "ember" and action == "attack" and time_value == float(profile["impact"])-0.03) or (id in ["fenrir","oracle","warden","dawn","sprite"] and action == "attack" and time_value == float(profile["impact"])+0.06) or (action == "cast" and time_value == float(profile["impact"])+0.06):
			await capture("eldoria-v06-"+id+"-"+action)

func _run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	board._start_from_menu()
	var seen: Dictionary = {}
	for id in Catalog.CARDS:
		check(Effects.PROFILES.has(id),"Profile exists: "+id)
		var shape: String = Effects.PROFILES[id]["shape"]
		check(not seen.has(shape),"Unique effect silhouette: "+id)
		seen[shape] = true
		check(float(Effects.PROFILES[id]["duration"]) <= 1.2,"Bounded effect duration")
	# Real model actions on both sides must select the right visual and target.
	for side in range(2):
		for id in Catalog.CARDS:
			fresh(side)
			var card: Dictionary = Catalog.card(id)
			board.duel.hands[side] = [card]
			var target: int = 1
			if card["kind"] == "monster":
				if id == "ember":
					board.duel.fields[side][0] = unit("dawn")
			else:
				match id:
					"blessing": board.duel.fields[side][1] = unit("dawn")
					"eclipse": board.duel.fields[1-side][1] = unit("fenrir")
					"sanctuary":
						board.duel.lp[side] = 2500
						target = -1
					_: target = -1
			board._render()
			check(board.duel.play(0,target),"Valid model action: "+id)
			check(board.fx.last_cue.get("card_id","") == id,"Correct card VFX on play: "+id)
			var expected_side: int = side if card["kind"] == "monster" or id in ["blessing","sanctuary"] else 1-side
			var expected: Vector2 = board._zone_center(expected_side,target) if target >= 0 else board._profile_effect_point(expected_side)
			if id == "sanctuary":
				expected = board._zone_center(side,1)
			check(board.fx.last_cue["to"].distance_to(expected) < 0.01,"Correct owner/target: "+id)
			await process_frame
	fresh()
	board.duel.hands[0] = [Catalog.card("dawn")]
	board.duel.summoned = true
	board.fx.clear_all()
	check(not board.duel.play(0,0) and board.fx.events.is_empty(),"Rejected actions do not play effects")
	# Summon silhouettes must also render at all phases.
	for id in Catalog.CARDS:
		if Catalog.CARDS[id]["kind"] != "monster":
			continue
		fresh()
		board.duel.hands[0] = [Catalog.card(id)]
		if id == "ember":
			board.duel.fields[0][0] = unit("dawn")
		board._render()
		board.selected_hand = 0
		board.duel.play(0,1)
		await create_timer(0.56).timeout
		await samples(id,"enter")
	# Render every attack/cast profile at startup, travel, impact, and fade.
	for id in Catalog.CARDS:
		fresh()
		var card: Dictionary = Catalog.card(id)
		board._inspect(card)
		if card["kind"] == "monster":
			board.duel.fields[0][0] = unit(id)
			board.duel.fields[1][0] = unit("dawn")
			board.duel.phase = "BATTLE"
			board._render()
			check(board.duel.attack(0,0),"Attack accepted: "+id)
			check(board.fx.last_cue["card_id"] == id and board.fx.last_cue["action"] == "attack","Attack uses its own profile: "+id)
			await samples(id,"attack")
		else:
			board.duel.hands[0] = [card]
			board.duel.fields[0][1] = unit("dawn")
			board.duel.fields[1][1] = unit("fenrir")
			board.duel.lp[0] = 2500
			board._render()
			var target: int = 1 if id in ["blessing","eclipse"] else -1
			board.duel.play(0,target)
			await samples(id,"cast")
	fresh()
	board.fx.play_card("storm","cast",Vector2(645,309),Vector2(870,152))
	board._open_card_zoom(Catalog.card("storm"))
	check(board._effects_obscured(),"Detail panel hides high-layer effects")
	await capture("eldoria-v06-effect-occlusion")
	board.zoom_layer.hide()
	check(not board._effects_obscured(),"Effect visibility resumes outside overlays")
	board._toggle_effect_mode()
	check(board.fx.reduced_motion and "RINGKAS" in board.effects_button.text,"Reduced effects control")
	for id in Catalog.CARDS:
		board.fx.clear_all()
		board.fx.play_card(id,"cast",Vector2(488,405),Vector2(646,236))
		check(board.fx.last_cue["simple"] and board.fx.last_cue["duration"] < 0.4,"Reduced mode preserves identity and shortens motion: "+id)
		await process_frame
	for i in range(30):
		board.fx.play_card("storm","cast",Vector2(488,405),Vector2(646,236))
	check(board.fx.events.size() <= Effects.MAX_EVENTS,"Burst cap prevents unbounded visual clutter")
	await create_timer(0.5).timeout
	check(board.fx.events.is_empty() and not board.fx.is_processing(),"Effects expire and renderer sleeps")
	board._toggle_effect_mode()
	fresh()
	check(not board.fx.reduced_motion and board.fx.events.is_empty(),"Normal mode and reset")
	for row in board.zone_views:
		for view in row:
			check(view.self_modulate.a == 1,"Reset restores card visibility")
	# Lethal results wait for their impact and LP counter.
	fresh()
	board.duel.phase = "BATTLE"
	board.duel.fields[0][0] = unit("fenrir")
	board.duel.lp[1] = 1000
	board.lp_targets[1] = 1000
	board._set_lp_value(1000,1)
	board._render()
	board.duel.attack(0)
	await create_timer(0.2).timeout
	check(board.duel.over and not board.result_layer.visible,"Lethal action waits for impact before results")
	await create_timer(0.95).timeout
	check(board.result_layer.visible and roundi(board.displayed_lp[1]) == 0,"LP reaches zero before victory presentation")
	board._start_from_menu()
	# A pending result screen must not survive a restart.
	board.duel.over = true
	board._finished(0)
	board._start_from_menu()
	await create_timer(0.6).timeout
	check(not board.result_layer.visible and not board.duel.over,"Restart cancels pending result presentation")
	board._open_menu()
	await create_timer(0.8).timeout
	board.queue_free()
	await process_frame
	await create_timer(0.35).timeout
	print("VFX CHECKS: %d / FAILURES: %d / UNIQUE PROFILES: %d" % [checks,failures,seen.size()])
	quit(0 if failures == 0 else 1)

