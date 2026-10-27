extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
const AI = preload("res://scripts/ai.gd")
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
	c.merge({"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"shield":false,"uid":7})
	return c
func _initialize() -> void: call_deferred("run")
func capture(name_value: String) -> void:
	await process_frame
	await process_frame
	if DisplayServer.get_name() == "headless": return
	RenderingServer.force_draw(false)
	root.get_texture().get_image().save_png("C:/Users/Kafka/Documents/Codex/2026-10-25/jadi-kan-aku-mau-buat-game/outputs/"+name_value+".png")
func run() -> void:
	root.size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	board._open_gallery()
	board.gallery.select_card("solar_lance")
	check(board.gallery.tiles.size() == 25 and board.gallery.description.text.contains("MENEMBUS"),"New spell visible in complete gallery")
	board.gallery.inspect_selected()
	check(board.zoom_title.text == "Tombak Surya" and board.zoom_description.text.contains("-300"),"Zoom explains offense drawback")
	await capture("eldoria-v14-tombak-surya")
	board._close_gallery()
	board._begin_duel(0)
	var d = board.duel
	d.turn_number = 3
	d.fields = [[unit("dawn"),{},{}],[unit("owl"),{},{}]]
	d.fields[1][0]["defending"] = true
	d.backrows = [[{},{},{}],[{},{},{}]]
	d.hands = [[Catalog.card("solar_lance")],[]]
	board._render()
	board._hand_clicked(0)
	check(board.zone_views[0][0].selected and not board.zone_views[0][1].selected,"Lance highlights only friendly occupied zones")
	board._zone_clicked(0,0)
	check(d.fields[0][0].get("piercing",false) and board.fx.last_cue.get("card_id","") == "solar_lance","Click applies lance and own effect")
	board._battle()
	board._zone_clicked(0,0)
	board._zone_hover(1,0)
	check(board.context_label.text.contains("200 LP (tembus)"),"Hover forecast accounts for piercing")
	board._inspect(d.fields[0][0])
	check(board.detail_desc.text.contains("STATUS PAPAN: MENEMBUS"),"Current enhancement explained apart from base effect")
	await create_timer(1.25).timeout
	await capture("eldoria-v14-piercing-preview")
	board._zone_clicked(1,0)
	check(d.lp[1] == 3800 and board.combat_label.text.contains("MENEMBUS"),"Actual click damage and report agree")
	board._undo_action()
	check(d.lp[1] == 4000 and not d.fields[1][0].is_empty() and d.fields[0][0]["piercing"],"Undo attack retains prior lance enhancement")
	board._begin_duel(0)
	d.turn_number = 3
	d.fields = [[unit("noctis"),{},{}],[unit("ember"),{},{}]]
	d.backrows = [[{},{},{}],[{},{},{}]]
	d.hands = [[Catalog.card("lunar_veil")],[]]
	board._render()
	board._hand_clicked(0)
	board._zone_clicked(0,0)
	check(d.fields[0][0]["shield"] and d.fields[0][0]["atk"] == 2700 and board.fx.last_cue.get("card_id","") == "lunar_veil","Veil gives comeback power with distinct effect")
	board._inspect(d.fields[0][0])
	check(board.detail_desc.text.contains("PERISAI aktif"),"Active shield status visible")
	board._open_card_zoom(Catalog.card("lunar_veil"))
	await capture("eldoria-v14-selubung-gerhana")
	board.zoom_layer.hide()
	board._undo_action()
	check(not d.fields[0][0]["shield"] and d.fields[0][0]["atk"] == 2300,"Undo restores pre-veil state")
	# Existing AI can play both cards through the established buff action.
	for id in ["solar_lance","lunar_veil"]:
		d.turn = 1
		d.phase = "MAIN"
		d.summoned = true
		d.hands[1] = [Catalog.card(id)]
		var action: Dictionary = AI.main_action(d)
		check(action["type"] == "play" and AI.apply(d,action),"Existing AI action handles "+id)
	board._open_menu()
	board.queue_free()
	await process_frame
	await create_timer(.35).timeout
	print("IDENTITY UI: %d checks / %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
