extends SceneTree
const Duel = preload("res://scripts/duel.gd")
const Catalog = preload("res://scripts/catalog.gd")
const AI = preload("res://scripts/ai.gd")
var checks: int = 0
var failures: int = 0

func check(ok: bool, description: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("FAIL: " + description)

func fresh():
	var d = Duel.new()
	d.start(17)
	d.turn_number = 3
	d.hands = [[],[]]
	d.fields = [[{},{},{}],[{},{},{}]]
	d.graves = [[],[]]
	return d

func unit(id: String, defense: bool = false) -> Dictionary:
	var c: Dictionary = Catalog.card(id)
	c.merge({"defending":defense,"attacked":false,"switched":false,"summoned_turn":1,"shield":id == "warden"})
	return c

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var d = Duel.new()
	d.start(7)
	check(d.hands[0].size() == 4 and d.decks[0].size() == 16,"Opening hands")
	check(not d.battle(),"No first turn attack")
	d = fresh()
	d.hands[0] = [Catalog.card("dawn"),Catalog.card("fenrir")]
	check(not d.play(0,4),"Invalid summon zone")
	check(d.play(0,1),"Normal summon")
	check(not d.play(0,2),"Only one summon per turn")
	check(not d.switch_position(1),"No position change on summon turn")
	d.turn_number += 2
	check(d.switch_position(1),"Change position on later turn")
	check(not d.switch_position(1),"No double position change")
	d = fresh()
	d.hands[0] = [Catalog.card("ember")]
	check(not d.play(0,0),"Dragon requires tribute")
	d.fields[0][1] = unit("dawn")
	check(d.play(0,1),"Tribute onto occupied zone")
	check(d.fields[0][1]["id"] == "ember" and d.graves[0].size() == 1,"Tribute moves old monster to grave")
	check(d.lp[1] == 3700,"Summon burn")
	d = fresh()
	d.lp[0] = 3000
	d.hands[0] = [Catalog.card("oracle")]
	check(d.play(0,0) and d.lp[0] == 3400,"Oracle heal")
	d = fresh()
	d.hands[0] = [Catalog.card("sprite")]
	var before: int = d.decks[0].size()
	check(d.play(0,0) and d.hands[0].size() == 1 and d.decks[0].size() == before-1,"Sprite draw")
	d = fresh()
	d.hands[0] = [Catalog.card("storm"),Catalog.card("sanctuary"),Catalog.card("blessing"),Catalog.card("eclipse")]
	check(d.play(0) and d.lp[1] == 3500,"Damage spell")
	d.lp[0] = 3900
	check(d.play(0) and d.lp[0] == 4000,"Healing caps at 4000")
	check(not d.play(0,-1) and d.hands[0].size() == 2,"Invalid spell does not consume card")
	d.fields[0][0] = unit("dawn")
	check(d.play(0,0) and d.fields[0][0]["atk"] == 2000,"Buff spell")
	d.fields[1][0] = unit("ember")
	check(not d.play(0,0),"Destroy spell target restriction")
	d.fields[1][1] = unit("warden",true)
	check(d.play(0,1) and d.fields[1][1].is_empty(),"Spell bypasses battle shield")
	d = fresh()
	d.phase = "BATTLE"
	d.fields[0][0] = unit("fenrir")
	d.fields[1][0] = unit("dawn")
	check(not d.attack(0),"No direct attack through monsters")
	check(d.attack(0,0),"Monster battle")
	check(d.fields[1][0].is_empty() and d.lp[1] == 3800,"ATK battle damage and destruction")
	check(not d.attack(0),"One attack per monster")
	d = fresh()
	d.phase = "BATTLE"
	d.fields[0][0] = unit("fenrir")
	d.fields[1][0] = unit("oracle",true)
	check(d.attack(0,0) and d.lp[1] == 4000 and d.fields[1][0].is_empty(),"No piercing damage")
	d = fresh()
	d.phase = "BATTLE"
	d.fields[0][0] = unit("dawn")
	d.fields[1][0] = unit("warden",true)
	check(d.attack(0,0) and d.lp[0] == 3500 and not d.fields[0][0].is_empty(),"Losing to DEF does not destroy attacker")
	d = fresh()
	d.phase = "BATTLE"
	d.fields[0][0] = unit("ember")
	d.fields[1][0] = unit("warden",true)
	check(d.attack(0,0) and not d.fields[1][0].is_empty() and not d.fields[1][0]["shield"],"Shield absorbs one destruction")
	d.fields[0][0]["attacked"] = false
	check(d.attack(0,0) and d.fields[1][0].is_empty(),"Shield expires")
	d = fresh()
	d.phase = "BATTLE"
	d.fields[0][0] = unit("dawn")
	d.fields[1][0] = unit("dawn")
	check(d.attack(0,0) and d.fields[0][0].is_empty() and d.fields[1][0].is_empty(),"Equal ATK destroys both")
	d = fresh()
	d.phase = "BATTLE"
	d.fields[0][0] = unit("fenrir",true)
	check(not d.attack(0),"Defenders cannot attack")
	d.fields[0][0]["defending"] = false
	d.lp[1] = 1000
	check(d.attack(0) and d.over and d.winner == 0,"Direct attack victory")
	check(not d.attack(0) and not d.end_turn(),"No actions after victory")
	d = fresh()
	check(not d.skill(),"Skill LP threshold")
	d.lp[0] = 2000
	check(d.skill() and d.lp[0] == 2800,"Skill heals 800")
	d.lp[0] = 1000
	check(not d.skill(),"Skill only once")
	d = fresh()
	d.decks[1] = []
	check(d.end_turn() and d.over and d.winner == 0,"Deck out loss")
	# Exercise complete duels with both sides controlled by the AI policy.
	var total_turns: int = 0
	for seed_value in range(100):
		d = Duel.new()
		d.start(seed_value)
		var actions: int = 0
		while not d.over and actions < 700:
			actions += 1
			var action: Dictionary = AI.main_action(d) if d.phase == "MAIN" else AI.battle_action(d)
			if not AI.apply(d,action):
				d.end_turn()
			for side in range(2):
				var count: int = d.decks[side].size()+d.hands[side].size()+d.graves[side].size()
				for m in d.fields[side]:
					if not m.is_empty():
						count += 1
				check(count == 20,"Card conservation seed %d" % seed_value)
				check(d.lp[side] >= 0 and d.lp[side] <= 4000,"LP bounds")
		check(d.over,"Self-play duel terminates: %d" % seed_value)
		total_turns += d.turn_number
	print("CHECKS: %d / FAILURES: %d / COMPLETE DUELS: 100 / TURNS: %d" % [checks,failures,total_turns])
	quit(0 if failures == 0 else 1)

