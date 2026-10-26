extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
const Hints = preload("res://scripts/duel_hints.gd")
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
	c.merge({"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"shield":c["effect"]=="shield","uid":7})
	return c
func _initialize() -> void: call_deferred("run")
func run() -> void:
	root.size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	board._begin_duel(0)
	var d = board.duel
	d.turn_number = 3
	d.phase = "MAIN"
	d.fields = [[{},{},{}],[{},{},{}]]
	d.hands = [[Catalog.card("ember"),Catalog.card("blessing"),Catalog.card("eclipse")],[]]
	check(Hints.hand_reason(d,d.hands[0][0]).contains("tribute"),"No tribute explained")
	check(Hints.hand_reason(d,d.hands[0][1]).contains("target"),"No buff target explained")
	check(Hints.hand_reason(d,d.hands[0][2]).contains("1800"),"No destroy target explained")
	d.fields[0][0] = unit("ember")
	d.fields[1][0] = unit("noctis")
	d.summoned = true
	check(Hints.hand_reason(d,d.hands[0][0]).contains("sudah"),"Summon limit explained")
	d.summoned = false
	d.backrows[0] = [Catalog.card("seal"),Catalog.card("seal"),Catalog.card("seal")]
	check(Hints.hand_reason(d,Catalog.card("storm")).contains("penuh"),"Backrow block explained")
	d.backrows = [[{},{},{}],[{},{},{}]]
	d.phase = "BATTLE"
	check(Hints.monster_status(d,d.fields[0][0]) == "SIAP MENYERANG","Ready state")
	var before: String = str(d.fields)
	var forecast: String = Hints.forecast(d,d.fields[0][0],d.fields[1][0])
	check(forecast.contains("200") and forecast.contains("Perisai"),"Forecast accounts for shield and LP")
	check(str(d.fields) == before,"Forecast does not change duel")
	var target: Dictionary = unit("warden")
	target["defending"] = true
	check(Hints.forecast(d,d.fields[0][0],target).contains("LP tetap"),"Defense no piercing")
	d.fields[0][0]["atk"] = 1000
	check(Hints.forecast(d,d.fields[0][0],target).contains("bertahan"),"Losing vs defense keeps attacker")
	target = unit("sprite")
	check(Hints.forecast(d,d.fields[0][0],target).contains("hancur"),"Equal attack destruction")
	d.backrows[1][0] = Catalog.card("seal")
	forecast = Hints.forecast(d,d.fields[0][0],target)
	check(forecast.contains("Trap tertutup") and not forecast.contains("Segel"),"Warning preserves hidden trap identity")
	d.fields[0][0]["atk"] = 2900
	d.fields[0][0]["def"] = 1900
	board.selected_zone = 0
	board._render()
	board._zone_hover(1,0)
	check(board.context_label.text.contains("600") and board.context_label.text.contains("Perisai"),"Hover forecast visible")
	check(board.zone_views[0][0].action_hint == "SIAP MENYERANG","Ready badge rendered")
	board._inspect(d.fields[0][0])
	check(board.detail_type.tooltip_text.contains("+400"),"Stat delta available")
	await process_frame
	await process_frame
	if DisplayServer.get_name() != "headless":
		RenderingServer.force_draw(false)
		root.get_texture().get_image().save_png("C:/Users/Kafka/Documents/Codex/2026-10-25/jadi-kan-aku-mau-buat-game/outputs/eldoria-v13-duel-clarity.png")
	board._open_menu()
	board.queue_free()
	await process_frame
	await create_timer(.35).timeout
	print("DUEL CLARITY: %d checks / %d failures" % [checks,failures])
	quit(0 if failures == 0 else 1)
