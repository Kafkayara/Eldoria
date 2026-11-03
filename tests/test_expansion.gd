extends SceneTree
const Duel = preload("res://scripts/duel.gd")
const Catalog = preload("res://scripts/catalog.gd")
var failures := 0
var checks := 0
func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error(label)
func fresh():
	var d = Duel.new()
	d.start(19)
	d.turn_number = 3
	d.hands = [[],[]]
	d.fields = [[{},{},{}],[{},{},{}]]
	d.graves = [[],[]]
	return d
func unit(id: String, uid: int = 100) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"uid":uid,"defending":false,"attacked":false,"switched":false,"summoned_turn":1,"shield":false})
	return c
func _initialize() -> void:
	check(Catalog.CARDS.size() == 34,"Catalog must contain 34 immediately available cards")
	for id in ["cinder","oath","bastion","weaver","mirror_step","archive","tender","roots","trail"]:
		check(Catalog.CARDS.has(id),"Missing new card: "+id)
	if failures:
		quit(1)
		return
	var d = fresh()
	d.fields[0][0] = unit("cinder")
	d.hands[0] = [Catalog.card("ember")]
	check(d.play(0,1) and d.fields[0][1]["atk"] == 2900,"Tribute bonus follows summoned monster into empty zone")
	check(d.undo() and d.fields[0][0]["id"] == "cinder","Tribute Undo")
	d = fresh()
	d.fields[0][0] = unit("dawn")
	d.fields[1][0] = unit("warden",101)
	d.hands[0] = [Catalog.card("oath"),Catalog.card("oath")]
	check(d.play(0,0) and d.fields[0][0]["atk"] == 2400,"Oath temporary buff")
	check(not d.play(0,0),"Oath cannot stack")
	d.phase = "BATTLE"
	d.fields[1][0] = {}
	check(not d.attack(0),"Oath blocks direct attack")
	d.end_turn()
	check(d.fields[0][0]["atk"] == 1700,"Temporary buff expires at turn end")
	d = fresh()
	d.fields[1][0] = unit("dawn")
	d.fields[1][0]["atk"] = 2400
	d.hands[0] = [Catalog.card("mirror_step")]
	check(d.play(0,0) and d.lp[0] == 3500,"Bounce pays 500 LP")
	check(d.fields[1][0].is_empty() and d.hands[1][0]["atk"] == 1700 and d.graves[1].is_empty(),"Bounce resets stats and bypasses Grave")
	check(d.undo() and d.lp[0] == 4000 and d.fields[1][0]["atk"] == 2400,"Bounce cost and target Undo")
	d = fresh()
	d.graves[0] = [Catalog.card("seal")]
	d.hands[0] = [Catalog.card("archive"),Catalog.card("archive")]
	check(d.play(0) and d.hands[0].back()["id"] == "seal","Recover trap")
	d.graves[0].append(Catalog.card("mirror"))
	check(not d.play(0),"Archive once per turn")
	d = fresh()
	d.hands[0] = [Catalog.card("weaver")]
	d.fields[1][0] = unit("ember")
	check(d.play(0,0) and d.fields[1][0]["defending"],"Weaver changes enemy position")
	d = fresh()
	d.graves[0] = [Catalog.card("fenrir")]
	d.hands[0] = [Catalog.card("tender")]
	var n: int = d.decks[0].size()
	check(d.play(0,0) and d.graves[0].is_empty() and d.decks[0].size() == n,"Tender exchanges Grave card for draw")
	d = fresh()
	d.fields[0][0] = unit("fenrir")
	d.graves[0] = [Catalog.card("grove"),Catalog.card("stag")]
	d.hands[0] = [Catalog.card("roots")]
	check(d.play(0,0) and d.fields[0][0]["atk"] == 2600,"Roots counts Grave on resolution")
	d.end_turn()
	check(d.fields[0][0]["atk"] == 1800,"Roots expires")
	print("EXPANSION: %d checks, %d failures" % [checks,failures])
	quit(1 if failures else 0)
