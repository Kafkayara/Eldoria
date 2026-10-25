extends RefCounted

# Pilih satu langkah; UI memberi jeda agar giliran lawan bisa diikuti.
static func main_action(duel) -> Dictionary:
	var side: int = duel.turn
	if not duel.skill_used[side] and int(duel.lp[side]) <= 2500:
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
			return {"type":"play", "index":best, "target":target, "defending":int(c["atk"]) < 1300}
	for i in range(duel.hands[side].size()):
		var card: Dictionary = duel.hands[side][i]
		if card["kind"] != "spell":
			continue
		match card["effect"]:
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
