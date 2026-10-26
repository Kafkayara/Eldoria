extends RefCounted
const Catalog = preload("res://scripts/catalog.gd")

static func hand_reason(d, card: Dictionary) -> String:
	if d.over: return "Duel sudah selesai."
	if d.turn != 0: return "Tunggu giliranmu."
	if not d.chain.is_empty(): return "Selesaikan respons terlebih dahulu."
	if d.phase != "MAIN": return "Kartu tangan hanya dimainkan pada Main Phase."
	if card["kind"] == "monster":
		if d.summoned: return "Normal summon giliran ini sudah dipakai."
		if int(card["level"]) > 4 and not d.has_monsters(0): return "Butuh 1 monster di papan sebagai tribute."
		if int(card["level"]) <= 4 and d.empty_zone(0) < 0: return "Ketiga zona monster terisi."
	else:
		if d.empty_backrow(0) < 0: return "Zona spell/trap penuh. Sisakan 1 zona kosong."
		if card["effect"] == "buff" and not d.has_monsters(0): return "Butuh monster milikmu sebagai target."
		if card["effect"] == "destroy":
			var found := false
			for c in d.fields[1]:
				if not c.is_empty() and int(c["atk"]) <= 1800: found = true
			if not found: return "Tidak ada target lawan dengan ATK 1800 atau kurang."
	return ""

static func monster_status(d, c: Dictionary) -> String:
	if c.is_empty(): return ""
	if d.over: return "DUEL SELESAI"
	if not d.chain.is_empty(): return "TUNGGU RESPONS"
	if c.get("defending",false): return "BERTAHAN"
	if c.get("attacked",false): return "SUDAH MENYERANG"
	if d.turn_number == 1: return "BELUM BISA SERANG"
	if d.turn != 0: return "TUNGGU GILIRAN"
	if d.phase != "BATTLE": return "SIAP DI BATTLE"
	return "SIAP MENYERANG"

static func stats(c: Dictionary) -> String:
	if c.is_empty() or c["kind"] != "monster": return ""
	var base: Dictionary = Catalog.card(c["id"])
	return "ATK %d (%+d) / DEF %d (%+d) dari awal" % [c["atk"],int(c["atk"])-int(base["atk"]),c["def"],int(c["def"])-int(base["def"])]

static func forecast(d, source: Dictionary, target: Dictionary) -> String:
	var result := ""
	if target.is_empty():
		result = "Langsung: Nyx kehilangan %d LP." % source["atk"]
	else:
		var defending: bool = target.get("defending",false)
		var power: int = int(target["def"] if defending else target["atk"])
		var delta: int = int(source["atk"]) - power
		result = "%d ATK vs %d %s\n" % [source["atk"],power,"DEF" if defending else "ATK"]
		if delta > 0:
			result += ("Perisai lawan habis." if target.get("shield",false) else "Target hancur.") + (" LP tetap." if defending and not source.get("piercing",false) else " Nyx -%d LP%s." % [delta," (tembus)" if defending else ""])
		elif delta < 0:
			result += "Kamu -%d LP. " % -delta
			result += "Monstermu bertahan." if defending else ("Perisaimu habis." if source.get("shield",false) else "Monstermu hancur.")
		else:
			result += "Keduanya bertahan. LP tetap." if defending else "LP tetap. Kamu: %s; lawan: %s." % ["perisai habis" if source.get("shield",false) else "hancur","perisai habis" if target.get("shield",false) else "hancur"]
	var hidden := false
	for c in d.backrows[1]:
		if not c.is_empty() and not c.get("faceup",false): hidden = true
	return (result + ("\nTrap tertutup bisa mengubah hasil." if hidden else "")).replace("Nyx",d.who(1))
