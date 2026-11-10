extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
var board
var failures := 0
var checks := 0
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(label)
func _initialize() -> void:
	call_deferred("run")
func aces() -> Array:
	return board.fx.get_children().filter(func(n): return n.get_meta("ace_cutin",false) and not n.is_queued_for_deletion())
func unit(id: String) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"uid":11,"shield":false})
	return c
func run() -> void:
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	board.collection_store.path = "user://cinematic_test.json"
	board.collection_store.animation_speed = 1.0
	board.collection_store.reduced_motion = false
	board._apply_comfort_preferences()
	for id in ["ember","noctis","verdant"]:
		board._begin_duel(0)
		board._show_ace_intro(Catalog.card(id),0)
		await create_timer(1.25).timeout
		check(aces().size() == 1 and board._ace_active() and not board._can_input(),"Cinematic holds its reveal beat: "+id)
		await create_timer(.85).timeout
		check(aces().is_empty() and not board._ace_active() and board._can_input(),"Cinematic releases input: "+id)
		board._show_ace_intro(Catalog.card(id),0)
		check(aces().is_empty(),"Repeated ace does not block the duel")
	board._begin_duel(0)
	board.collection_store.animation_speed = 2.0
	board._apply_comfort_preferences()
	board._show_ace_intro(Catalog.card("ember"),1)
	await create_timer(.45).timeout
	check(aces().size() == 1 and board._ace_active(),"2x retains cinematic middle")
	await create_timer(.65).timeout
	check(aces().is_empty() and not board._ace_active(),"2x completes within 1.1 seconds")
	board._begin_duel(0)
	board._show_ace_intro(Catalog.card("noctis"),0)
	board._toggle_effect_mode()
	await process_frame
	check(aces().is_empty() and not board._ace_active(),"Reduced mode clears cinematic immediately")
	board._show_ace_intro(Catalog.card("verdant"),0)
	check(aces().is_empty(),"Reduced mode skips cinematics")
	board._toggle_effect_mode()
	board.collection_store.animation_speed = 1.0
	board._apply_comfort_preferences()
	board._begin_duel(0)
	board.duel.turn_number = 3
	board.duel.phase = "BATTLE"
	board.duel.fields = [[unit("ember"),{},{}],[{},{},{}]]
	board.duel.lp[1] = 100
	board._render()
	board.duel.attack(0)
	check(board.fx.last_cue.get("finisher",false),"Confirmed lethal attack has finisher emphasis")
	board._undo_action()
	await create_timer(1.4).timeout
	check(not board.result_layer.visible and board.fx.events.is_empty(),"Undo cancels finisher and delayed result")
	check(board.duel.lp[1] == 100 and not board.duel.over,"Undo preserves model state")
	# Defense and shield use real model outcomes, not just large attack numbers.
	board._begin_duel(0)
	board.duel.turn_number = 3
	board.duel.phase = "BATTLE"
	var protected_card := unit("dawn")
	protected_card["shield"] = true
	protected_card["defending"] = true
	board.duel.fields = [[unit("ember"),{},{}],[protected_card,{},{}]]
	board.duel.lp[1] = 100
	board._render()
	board.duel.attack(0,0)
	check(not board.fx.last_cue.get("finisher",false) and not board.fx.last_cue.get("shatter",false),"Shielded defense has neither false lethal nor shatter")
	check(board.duel.lp[1] == 100 and not board.duel.fields[1][0].is_empty(),"Defense outcome remains intact")
	# A delayed trap presentation must retain pre-damage LP when replaying combat.
	board._begin_duel(0)
	board.duel.turn_number = 3
	board.duel.phase = "BATTLE"
	board.duel.fields = [[unit("ember"),{},{}],[{},{},{}]]
	board.trap_presenting = true
	board.duel.attack(0)
	check(board.delayed_combats.size() == 1,"Trap queues combat presentation")
	var queued: Dictionary = board.delayed_combats.pop_front()
	board.trap_presenting = false
	board._combat_explained(queued)
	check(not board.fx.last_cue.get("finisher",false),"Delayed nonlethal attack does not become false finisher")
	board._open_menu()
	await create_timer(2.8).timeout
	board.queue_free()
	await process_frame
	await create_timer(0.35).timeout
	print("CINEMATIC: %d checks / %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
