extends RefCounted
const Catalog = preload("res://scripts/catalog.gd")

signal changed
signal message(text: String)
signal visual(kind: String, side: int, zone: int, amount: int)
signal finished(winner: int)
signal combat(report: Dictionary)
signal card_cue(cue: Dictionary)

var decks: Array = [[], []]
var hands: Array = [[], []]
var fields: Array = [[{}, {}, {}], [{}, {}, {}]]
var graves: Array = [[], []]
var lp: Array = [4000, 4000]
var skill_used: Array = [false, false]
var turn: int = 0
var turn_number: int = 1
var phase: String = "MAIN"
var summoned: bool = false
var over: bool = false
var winner: int = -1
var backrows: Array = [[{},{},{}],[{},{},{}]]
var chain: Array = []
var priority: int = -1
var passes: int = 0
var difficulty: String = "normal"
var next_uid: int = 0
var sentinel_used: Array = [false,false]
var rng := RandomNumberGenerator.new()

func start(seed_value: int = -1, first_side: int = 0, player_ids: Array = Catalog.DECK, enemy_ids: Array = Catalog.DECK) -> void:
	if seed_value < 0:
		rng.randomize()
	else:
		rng.seed = seed_value
	decks = [Catalog.deck(player_ids), Catalog.deck(enemy_ids)]
	backrows = [[{},{},{}],[{},{},{}]]
	chain.clear()
	priority = -1
	passes = 0
	next_uid = 0
	sentinel_used = [false,false]
	hands = [[], []]
	fields = [[{}, {}, {}], [{}, {}, {}]]
	graves = [[], []]
	lp = [4000, 4000]
	skill_used = [false, false]
	turn = clampi(first_side, 0, 1)
	turn_number = 1
	phase = "MAIN"
	summoned = false
	over = false
	winner = -1
	for side in range(2):
		for i in range(decks[side].size() - 1, 0, -1):
			var j: int = rng.randi_range(0, i)
			var temp: Dictionary = decks[side][i]
			decks[side][i] = decks[side][j]
			decks[side][j] = temp
		for i in range(4):
			_draw(side)
	message.emit("Duel dimulai. %s bergerak lebih dulu. Serangan dibuka mulai giliran kedua." % who(turn))
	changed.emit()

func _draw(side: int) -> bool:
	if decks[side].is_empty():
		lp[side] = 0
		message.emit("%s kehabisan deck!" % who(side))
		_check_end()
		return false
	hands[side].append(decks[side].pop_back())
	visual.emit("draw", side, -1, 0)
	return true

func who(side: int) -> String:
	return "Kamu" if side == 0 else "Nyx"

func reject(text: String) -> bool:
	message.emit(text)
	return false

func has_monsters(side: int) -> bool:
	for monster in fields[side]:
		if not monster.is_empty():
			return true
	return false

func empty_zone(side: int) -> int:
	for i in range(3):
		if fields[side][i].is_empty():
			return i
	return -1

func play(index: int, target: int = -1, defending: bool = false) -> bool:
	if over or not chain.is_empty() or phase != "MAIN":
		return reject("Kartu hanya bisa dimainkan pada Main Phase.")
	if index < 0 or index >= hands[turn].size():
		return false
	var card: Dictionary = hands[turn][index]
	if card["kind"] == "trap":
		return set_trap(index,target)
	if card["kind"] == "spell":
		return _spell(index, target)
	if summoned:
		return reject("Normal summon hanya sekali setiap giliran.")
	if target < 0 or target > 2:
		return reject("Pilih salah satu dari tiga zona monstermu.")
	var tribute: int = -1
	if int(card["level"]) > 4:
		for i in range(3):
			if not fields[turn][i].is_empty() and (tribute == -1 or fields[turn][i]["atk"] < fields[turn][tribute]["atk"]):
				tribute = i
		if tribute == -1:
			return reject("Monster level tinggi memerlukan satu monster sebagai tribute.")
		if not fields[turn][target].is_empty():
			tribute = target
	elif not fields[turn][target].is_empty():
		return reject("Zona itu sudah terisi.")
	if tribute >= 0:
		var tribute_name: String = fields[turn][tribute]["name"]
		_remove(turn, tribute)
		message.emit("%s dikorbankan sebagai tribute." % tribute_name)
	var monster: Dictionary = hands[turn].pop_at(index).duplicate(true)
	next_uid += 1
	monster["uid"] = next_uid
	monster["defending"] = defending
	monster["attacked"] = false
	monster["switched"] = false
	monster["summoned_turn"] = turn_number
	monster["shield"] = monster["effect"] == "shield"
	fields[turn][target] = monster
	summoned = true
	message.emit("%s summon %s dalam posisi %s." % [who(turn), monster["name"], "bertahan" if defending else "menyerang"])
	card_cue.emit({"id":monster["id"],"action":"enter","side":turn,"target_side":turn,"target_zone":target})
	visual.emit("summon", turn, target, 0)
	if monster["effect"] == "twilight_setup":
		_sentinel_setup(turn)
	if monster["effect"] in ["burn","heal","draw"]:
		_queue({"action":"summon","side":turn,"card":monster.duplicate(true)})
	_check_end()
	changed.emit()
	return true

func _spell(index: int, target: int) -> bool:
	var card: Dictionary = hands[turn][index]
	var effect: String = card["effect"]
	if effect not in ["buff","destroy"]:
		target = -1
	if effect == "buff":
		if target < 0 or target > 2 or fields[turn][target].is_empty():
			return reject("Berkah Fajar: pilih monster milikmu.")
	if effect == "destroy":
		if target < 0 or target > 2 or fields[1 - turn][target].is_empty():
			return reject("Retakan Langit: pilih monster lawan.")
		if int(fields[1 - turn][target]["atk"]) > 1800:
			return reject("Target Retakan Langit harus memiliki ATK 1800 atau kurang.")
	var slot: int = empty_backrow(turn)
	if slot < 0:
		return reject("Ketiga zona spell/trap terisi. Sisakan zona untuk mengaktifkan spell.")
	var played: Dictionary = hands[turn].pop_at(index)
	played["faceup"] = true
	backrows[turn][slot] = played
	message.emit("%s mengaktifkan %s." % [who(turn),card["name"]])
	var target_side: int = turn if effect in ["restore","buff","insight"] else 1-turn
	var target_uid: int = int(fields[target_side][target].get("uid",-1)) if target >= 0 else -1
	_queue({"action":"spell","side":turn,"card":played,"slot":slot,"target":target,"target_side":target_side,"target_uid":target_uid})
	changed.emit()
	return true

func _resolve_spell(event: Dictionary) -> void:
	var card: Dictionary = event["card"]
	var side: int = event["side"]
	var target: int = event["target"]
	var target_side: int = event["target_side"]
	if target >= 0 and (fields[target_side][target].is_empty() or int(fields[target_side][target].get("uid",-1)) != event["target_uid"]):
		message.emit("Target %s sudah tidak ada; efek gagal." % card["name"])
		return
	card_cue.emit({"id":card["id"],"action":"cast","side":side,"target_side":target_side,"target_zone":target,"target_card":fields[target_side][target].duplicate(true) if target >= 0 else {}})
	visual.emit("spell",side,target,0)
	match card["effect"]:
		"damage": _damage(1-side,500)
		"restore": _heal(side,700)
		"insight":
			_draw(side)
			if not over:
				_draw(side)
		"buff":
			fields[side][target]["atk"] += 400
			fields[side][target]["def"] += 400
		"destroy": _remove(1-side,target)


func battle() -> bool:
	if over or not chain.is_empty() or phase != "MAIN":
		return false
	if turn_number == 1:
		return reject("Pemain pertama belum bisa menyerang pada giliran pertama.")
	phase = "BATTLE"
	message.emit("%s memasuki Battle Phase." % who(turn))
	changed.emit()
	return true

func switch_position(zone: int) -> bool:
	if over or not chain.is_empty() or phase != "MAIN" or zone < 0 or zone > 2:
		return false
	var monster: Dictionary = fields[turn][zone]
	if monster.is_empty():
		return false
	if monster["switched"] or monster["summoned_turn"] == turn_number:
		return reject("Posisi hanya bisa diubah sekali, mulai giliran setelah summon.")
	monster["defending"] = not monster["defending"]
	monster["switched"] = true
	message.emit("Posisi %s diubah." % monster["name"])
	changed.emit()
	return true

func _attack_now(attacker: int, target: int = -1) -> bool:
	if over or phase != "BATTLE" or attacker < 0 or attacker > 2:
		return false
	var source: Dictionary = fields[turn][attacker]
	if source.is_empty() or source["defending"] or source["attacked"]:
		return reject("Pilih monster posisi menyerang yang belum menyerang.")
	var other: int = 1 - turn
	if target == -1 and has_monsters(other):
		return reject("Hancurkan monster lawan sebelum menyerang langsung.")
	if target != -1 and (target < 0 or target > 2 or fields[other][target].is_empty()):
		return reject("Pilih monster lawan yang menjadi target.")
	source["attacked"] = true
	visual.emit("attack", turn, attacker, 0)
	if target == -1:
		combat.emit({"attack":source["atk"],"power":0,"difference":source["atk"],"defending":false,"direct":true,"target_card":{},"side":turn,"zone":attacker,"target":target,"card":source.duplicate(true)})
		message.emit("%s menyerang langsung: %d!" % [source["name"], source["atk"]])
		_damage(other, int(source["atk"]))
	else:
		var enemy: Dictionary = fields[other][target]
		var defending: bool = enemy["defending"]
		var power: int = int(enemy["def"]) if defending else int(enemy["atk"])
		var difference: int = int(source["atk"]) - power
		combat.emit({"attack":source["atk"],"power":power,"difference":difference,"defending":defending,"direct":false,"target_card":enemy.duplicate(true),"side":turn,"zone":attacker,"target":target,"card":source.duplicate(true)})
		message.emit("%s menyerang %s." % [source["name"], enemy["name"]])
		if difference > 0:
			_destroy_battle(other, target)
			if not defending:
				_damage(other, difference)
		elif difference < 0:
			_damage(turn, -difference)
			if not defending:
				_destroy_battle(turn, attacker)
		elif not defending:
			_destroy_battle(turn, attacker)
			_destroy_battle(other, target)
	_check_end()
	changed.emit()
	return true

func _destroy_battle(side: int, zone: int) -> void:
	var monster: Dictionary = fields[side][zone]
	if monster.get("shield", false):
		monster["shield"] = false
		message.emit("Perisai %s menahan kehancuran!" % monster["name"])
		visual.emit("shield", side, zone, 0)
	else:
		message.emit("%s dihancurkan." % monster["name"])
		_remove(side, zone)

func _remove(side: int, zone: int) -> void:
	graves[side].append(fields[side][zone].duplicate(true))
	fields[side][zone] = {}

func _damage(side: int, amount: int) -> void:
	lp[side] = maxi(0, int(lp[side]) - amount)
	visual.emit("damage", side, -1, amount)

func _heal(side: int, amount: int) -> void:
	var actual: int = mini(amount, 4000 - int(lp[side]))
	lp[side] += actual
	message.emit("%s memulihkan %d LP." % [who(side), actual])
	visual.emit("heal", side, -1, actual)

func skill() -> bool:
	if over or not chain.is_empty() or phase != "MAIN" or skill_used[turn]:
		return reject("Skill hanya sekali per duel, saat Main Phase.")
	if int(lp[turn]) > 2500:
		return reject("Skill Kebangkitan Fajar terbuka saat LP 2500 atau kurang.")
	skill_used[turn] = true
	_heal(turn, 800)
	message.emit("%s menggunakan Kebangkitan Fajar!" % who(turn))
	_check_end()
	changed.emit()
	return true

func end_turn() -> bool:
	if over or not chain.is_empty():
		return false
	turn = 1 - turn
	turn_number += 1
	phase = "MAIN"
	summoned = false
	for monster in fields[turn]:
		if not monster.is_empty():
			monster["attacked"] = false
			monster["switched"] = false
	_draw(turn)
	message.emit("Giliran %d — %s mengambil kartu." % [turn_number, who(turn)])
	_check_end()
	changed.emit()
	return true

func _check_end() -> void:
	if over:
		return
	if int(lp[0]) <= 0 or int(lp[1]) <= 0:
		over = true
		winner = 0 if int(lp[1]) <= 0 else 1
		message.emit("Kemenangan untuk %s!" % who(winner))
		finished.emit(winner)

func empty_backrow(side: int) -> int:
	for z in range(3):
		if backrows[side][z].is_empty():
			return z
	return -1

func set_trap(index: int, slot: int = -1) -> bool:
	if over or not chain.is_empty() or phase != "MAIN" or index < 0 or index >= hands[turn].size():
		return false
	if hands[turn][index]["kind"] != "trap":
		return false
	if slot < 0:
		slot = empty_backrow(turn)
	if slot < 0 or slot > 2 or not backrows[turn][slot].is_empty():
		return reject("Pilih zona spell/trap yang kosong.")
	var card: Dictionary = hands[turn].pop_at(index)
	card["set_turn"] = turn_number
	card["faceup"] = false
	backrows[turn][slot] = card
	message.emit("%s memasang jebakan tertutup di zona %d." % [who(turn),slot+1])
	changed.emit()
	return true

func attack(attacker: int, target: int = -1) -> bool:
	if over or not chain.is_empty() or phase != "BATTLE" or attacker < 0 or attacker > 2:
		return false
	var source: Dictionary = fields[turn][attacker]
	if source.is_empty() or source["defending"] or source["attacked"]:
		return false
	if target < -1 or target > 2 or (target == -1 and has_monsters(1-turn)) or (target >= 0 and fields[1-turn][target].is_empty()):
		return false
	source["attacked"] = true
	message.emit("%s menyatakan serangan %s." % [who(turn),source["name"]])
	_queue({"action":"attack","side":turn,"card":source.duplicate(true),"zone":attacker,"target":target,"target_uid":int(fields[1-turn][target].get("uid",-1)) if target >= 0 else -1})
	changed.emit()
	return true

func response_options(side: int) -> Array:
	var options: Array = []
	if side not in [0,1] or over or chain.is_empty() or side != priority:
		return options
	var last: Dictionary = chain.back()
	for z in range(3):
		var card: Dictionary = backrows[side][z]
		if card.is_empty() or card["kind"] != "trap" or card.get("set_turn",turn_number) >= turn_number:
			continue
		var legal: bool = false
		if card["effect"] == "negate":
			legal = last["side"] != side and last["action"] in ["spell","trap"]
		elif card["effect"] in ["reflect","weaken"]:
			legal = last["action"] == "attack" and last["side"] != side
		if legal:
			options.append(z)
	return options

func _queue(event: Dictionary) -> void:
	chain.append(event)
	passes = 0
	priority = 1-int(event["side"])
	_advance_response()

func _advance_response() -> void:
	# Skip priority only when that side has no legal response. A human with
	# a legal trap always gets an explicit decision; there is no timer.
	while not chain.is_empty() and response_options(priority).is_empty():
		passes += 1
		priority = 1-priority
		if passes >= 2:
			_resolve_chain()
			break

func respond(side: int, slot: int = -1) -> bool:
	if side not in [0,1] or over or chain.is_empty() or side != priority:
		return false
	if slot == -1:
		passes += 1
	else:
		if not response_options(side).has(slot):
			return false
		var card: Dictionary = backrows[side][slot]
		backrows[side][slot] = {}
		graves[side].append(card)
		message.emit("Respons %s: %s (rantai %d)." % [who(side),card["name"],chain.size()+1])
		chain.append({"action":"trap","side":side,"card":card,"source_slot":slot,"negates":chain.size()-1})
		passes = 0
	priority = 1-side
	if passes >= 2:
		_resolve_chain()
	else:
		_advance_response()
	changed.emit()
	return true

func _resolve_chain() -> void:
	priority = -1
	for i in range(chain.size()-1,-1,-1):
		var event: Dictionary = chain[i]
		var action: String = event["action"]
		var card: Dictionary = event["card"]
		var side: int = event["side"]
		if action == "trap":
			var original: Dictionary = chain[event["negates"]]
			var target_zone: int = int(original.get("zone",-1)) if original["action"] == "attack" else -1
			card_cue.emit({"id":card["id"],"action":"cast","side":side,"source_slot":event.get("source_slot",0),"target_side":1-side,"target_zone":target_zone,"target_card":fields[1-side][target_zone].duplicate(true) if target_zone >= 0 else {},"cancelled":event.get("cancelled",false)})
		if not event.get("cancelled",false) and not over:
			message.emit("Selesaikan: %s." % card["name"])
			match action:
				"spell": _resolve_spell(event)
				"summon":
					match card["effect"]:
						"burn": _damage(1-side,300)
						"heal": _heal(side,400)
						"draw": _draw(side)
				"trap":
					var previous: Dictionary = chain[event["negates"]]
					match card["effect"]:
						"negate": previous["cancelled"] = true
						"reflect":
							previous["cancelled"] = true
							_damage(1-side,300)
						"weaken":
							var z: int = previous["zone"]
							if not fields[1-side][z].is_empty():
								fields[1-side][z]["atk"] = maxi(0,int(fields[1-side][z]["atk"])-500)
				"attack":
					var z: int = event["zone"]
					var t: int = event["target"]
					if not fields[side][z].is_empty() and (t < 0 or (not fields[1-side][t].is_empty() and int(fields[1-side][t].get("uid",-1)) == event["target_uid"])):
						fields[side][z]["attacked"] = false
						_attack_now(z,t)
		else:
			if event.get("cancelled",false):
				message.emit("Efek/serangan %s dibatalkan." % card["name"])
		if action == "spell":
			graves[side].append(backrows[side][event["slot"]])
			backrows[side][event["slot"]] = {}
		_check_end()
	chain.clear()
	passes = 0

func _sentinel_setup(side: int) -> void:
	if sentinel_used[side]:
		message.emit("Penjaga Senja: efek pemasangan sudah dipakai pada duel ini.")
		return
	var slot: int = empty_backrow(side)
	if slot < 0:
		message.emit("Penjaga Senja: zona spell/trap penuh; efek tidak terpakai.")
		return
	for index in range(decks[side].size()):
		if decks[side][index]["id"] != "mirror": continue
		var card: Dictionary = decks[side].pop_at(index)
		card["set_turn"] = turn_number
		card["faceup"] = false
		backrows[side][slot] = card
		sentinel_used[side] = true
		message.emit("Penjaga Senja memasang Cermin Pembalasan dari deck di zona %d. Aktif mulai giliran berikutnya." % (slot+1))
		visual.emit("trap_set",side,slot,0)
		return
	message.emit("Penjaga Senja: tidak ada Cermin Pembalasan di deck; efek tidak terpakai.")
