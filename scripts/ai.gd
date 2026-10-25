extends RefCounted

# Pilih satu langkah; UI memberi jeda agar giliran lawan bisa diikuti.
static func main_action(duel) -> Dictionary:
	var side: int = duel.turn
	if duel.difficulty != "easy" and not duel.skill_used[side] and int(duel.lp[side]) <= 2500:
		return {"type":"skill"}
	if not duel.summoned:
		var best: int = -1
		var score: int = -1
		for i in range(duel.hands[side].size()):
			var c: Dictionary = duel.hands[side][i]
			if c["kind"] != "monster":
				continue
			if int(c["level"]) > 4 and not duel.has_monsters(side):
				continue
			if int(c["level"]) <= 4 and duel.empty_zone(side) < 0:
				continue
			var value: int = int(c["atk"])
			if duel.difficulty == "easy":
				value = 10000-i
			elif duel.difficulty == "hard":
				if duel.turn_number == 1:
					value = maxi(int(c["atk"]),int(c["def"]))
				if c["effect"] == "shield":
					value += 250
				if int(c["level"]) > 4:
					var weakest: int = 9999
					for m in duel.fields[side]:
						if not m.is_empty(): weakest = mini(weakest,int(m["atk"]))
					value -= weakest / 2
			if c["effect"] == "draw":
				value += 350
			if value > score:
				score = value
				best = i
		if best >= 0:
			var c: Dictionary = duel.hands[side][best]
			var target: int = duel.empty_zone(side)
			if target < 0:
				target = 0
				for z in range(1,3):
					if int(duel.fields[side][z]["atk"]) < int(duel.fields[side][target]["atk"]): target = z
			return {"type":"play", "index":best, "target":target, "defending":int(c["def"]) > int(c["atk"]) and duel.difficulty != "easy"}
	for i in range(duel.hands[side].size()):
		if duel.hands[side][i]["kind"] == "trap" and duel.empty_backrow(side) >= 0:
			return {"type":"play","index":i,"target":duel.empty_backrow(side)}
	for i in range(duel.hands[side].size()):
		var card: Dictionary = duel.hands[side][i]
		if card["kind"] != "spell" or duel.empty_backrow(side) < 0:
			continue
		match card["effect"]:
			"insight":
				if duel.decks[side].size() >= 2:
					return {"type":"play","index":i,"target":-1}
			"damage": return {"type":"play", "index":i, "target":-1}
			"restore":
				if int(duel.lp[side]) <= 3300:
					return {"type":"play", "index":i, "target":-1}
			"buff":
				var best: int = -1
				for z in range(3):
					if not duel.fields[side][z].is_empty() and (best < 0 or duel.fields[side][z]["atk"] > duel.fields[side][best]["atk"]):
						best = z
				if best >= 0:
					return {"type":"play", "index":i, "target":best}
			"destroy":
				var best: int = -1
				for z in range(3):
					var enemy: Dictionary = duel.fields[1-side][z]
					if not enemy.is_empty() and int(enemy["atk"]) <= 1800 and (best < 0 or enemy["atk"] > duel.fields[1-side][best]["atk"]):
						best = z
				if best >= 0:
					return {"type":"play", "index":i, "target":best}
	for z in range(3):
		var monster: Dictionary = duel.fields[side][z]
		if monster.is_empty() or not monster["defending"] or monster["switched"] or monster["summoned_turn"] == duel.turn_number:
			continue
		var safe: bool = true
		for enemy in duel.fields[1-side]:
			if not enemy.is_empty() and int(enemy["atk"]) >= int(monster["atk"]):
				safe = false
		if safe:
			return {"type":"position", "zone":z}
	return {"type":"battle"}

static func battle_action(duel) -> Dictionary:
	var side: int = duel.turn
	for z in range(3):
		var source: Dictionary = duel.fields[side][z]
		if source.is_empty() or source["defending"] or source["attacked"]:
			continue
		if not duel.has_monsters(1-side):
			return {"type":"attack", "zone":z, "target":-1}
		var best: int = -1
		var best_score: int = -100000
		for t in range(3):
			var enemy: Dictionary = duel.fields[1-side][t]
			if enemy.is_empty():
				continue
			var power: int = int(enemy["def"]) if enemy["defending"] else int(enemy["atk"])
			var difference: int = int(source["atk"]) - power
			if difference < 0 or (difference == 0 and enemy["defending"]):
				continue
			var score: int = difference + int(enemy["atk"]) / 4
			if enemy.get("shield", false):
				score -= 400
			if score > best_score:
				best_score = score
				best = t
		if best >= 0:
			return {"type":"attack", "zone":z, "target":best}
	return {"type":"end"}

static func apply(duel, action: Dictionary) -> bool:
	match action["type"]:
		"skill": return duel.skill()
		"play": return duel.play(action["index"], action.get("target",-1), action.get("defending",false))
		"position": return duel.switch_position(action["zone"])
		"battle": return duel.battle()
		"attack": return duel.attack(action["zone"], action["target"])
		"end": return duel.end_turn()
	return false

static func response(duel, side: int) -> int:
	var options: Array = duel.response_options(side)
	if options.is_empty():
		return -1
	# Easy bot sometimes lets an opportunity pass; hard bot preserves scarce
	# counters against harmless healing and uses reflect before weakening.
	if duel.difficulty == "easy":
		return options[0] if duel.rng.randf() < 0.45 else -1
	if duel.difficulty == "hard":
		var last: Dictionary = duel.chain.back()
		if last["action"] == "spell" and last["card"]["effect"] == "restore" and duel.lp[side] > 1000:
			return -1
		for z in options:
			if duel.backrows[side][z]["effect"] == "reflect":
				return z
	return options[0]
