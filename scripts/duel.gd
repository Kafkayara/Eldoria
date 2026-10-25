extends RefCounted
const Catalog = preload("res://scripts/catalog.gd")

signal changed
signal message(text: String)
signal visual(kind: String, side: int, zone: int, amount: int)
signal finished(winner: int)
signal combat(report: Dictionary)

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
var rng := RandomNumberGenerator.new()

func start(seed_value: int = -1) -> void:
	if seed_value < 0:
		rng.randomize()
	else:
		rng.seed = seed_value
	decks = [Catalog.deck(), Catalog.deck()]
	hands = [[], []]
	fields = [[{}, {}, {}], [{}, {}, {}]]
	graves = [[], []]
	lp = [4000, 4000]
	skill_used = [false, false]
	turn = 0
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
	message.emit("Duel dimulai. Kamu bergerak lebih dulu. Serangan dibuka mulai giliran kedua.")
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
	if over or phase != "MAIN":
		return reject("Kartu hanya bisa dimainkan pada Main Phase.")
	if index < 0 or index >= hands[turn].size():
		return false
	var card: Dictionary = hands[turn][index]
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
			return reject("Naga Bara memerlukan satu monster sebagai tribute.")
		if not fields[turn][target].is_empty():
			tribute = target
	elif not fields[turn][target].is_empty():
		return reject("Zona itu sudah terisi.")
	if tribute >= 0:
		var tribute_name: String = fields[turn][tribute]["name"]
		_remove(turn, tribute)
		message.emit("%s dikorbankan sebagai tribute." % tribute_name)
	var monster: Dictionary = hands[turn].pop_at(index).duplicate(true)
	monster["defending"] = defending
	monster["attacked"] = false
	monster["switched"] = false
	monster["summoned_turn"] = turn_number
	monster["shield"] = monster["effect"] == "shield"
	fields[turn][target] = monster
	summoned = true
	message.emit("%s summon %s dalam posisi %s." % [who(turn), monster["name"], "bertahan" if defending else "menyerang"])
	visual.emit("summon", turn, target, 0)
	match monster["effect"]:
		"burn":
			_damage(1 - turn, 300)
			message.emit("Efek Naga Bara: 300 kerusakan!")
		"heal":
			_heal(turn, 400)
		"draw":
			_draw(turn)
			message.emit("Efek Peri Astral: ambil satu kartu.")
	_check_end()
	changed.emit()
	return true

func _spell(index: int, target: int) -> bool:
	var card: Dictionary = hands[turn][index]
	var effect: String = card["effect"]
	if effect == "buff":
		if target < 0 or target > 2 or fields[turn][target].is_empty():
			return reject("Berkah Fajar: pilih monster milikmu.")
	if effect == "destroy":
		if target < 0 or target > 2 or fields[1 - turn][target].is_empty():
			return reject("Retakan Langit: pilih monster lawan.")
		if int(fields[1 - turn][target]["atk"]) > 1800:
			return reject("Target Retakan Langit harus memiliki ATK 1800 atau kurang.")
	var played: Dictionary = hands[turn].pop_at(index)
	graves[turn].append(played)
	message.emit("%s mengaktifkan %s." % [who(turn), card["name"]])
	visual.emit("spell", turn, target, 0)
	match effect:
		"damage": _damage(1 - turn, 500)
		"restore": _heal(turn, 700)
		"buff":
			fields[turn][target]["atk"] += 400
			fields[turn][target]["def"] += 400
			message.emit("Berkah Fajar: +400 ATK / DEF.")
		"destroy":
			message.emit("%s dihancurkan Retakan Langit." % fields[1 - turn][target]["name"])
			_remove(1 - turn, target)
	_check_end()
	changed.emit()
	return true

func battle() -> bool:
	if over or phase != "MAIN":
		return false
	if turn_number == 1:
		return reject("Pemain pertama belum bisa menyerang pada giliran pertama.")
	phase = "BATTLE"
	message.emit("%s memasuki Battle Phase." % who(turn))
	changed.emit()
	return true

func switch_position(zone: int) -> bool:
	if over or phase != "MAIN" or zone < 0 or zone > 2:
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

func attack(attacker: int, target: int = -1) -> bool:
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
		combat.emit({"attack":source["atk"],"power":0,"difference":source["atk"],"defending":false,"direct":true,"side":turn,"zone":attacker,"target":target,"card":source.duplicate(true)})
		message.emit("%s menyerang langsung: %d!" % [source["name"], source["atk"]])
		_damage(other, int(source["atk"]))
	else:
		var enemy: Dictionary = fields[other][target]
		var defending: bool = enemy["defending"]
		var power: int = int(enemy["def"]) if defending else int(enemy["atk"])
		var difference: int = int(source["atk"]) - power
		combat.emit({"attack":source["atk"],"power":power,"difference":difference,"defending":defending,"direct":false,"side":turn,"zone":attacker,"target":target,"card":source.duplicate(true)})
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
		message.emit("Perisai Aegis menahan kehancuran!")
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
	if over or phase != "MAIN" or skill_used[turn]:
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
	if over:
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
