extends RefCounted
const Catalog = preload("res://scripts/catalog.gd")
var state: Dictionary = {}
func reset() -> void:
	state = {"damage":[0,0],"healed":[0,0],"traps":[0,0],"last_lp":[4000,4000],"best_damage":0,"best_hit":"Belum ada serangan yang mengurangi LP.","moments":[]}
func snapshot() -> Dictionary: return state.duplicate(true)
func restore(saved: Dictionary) -> void: state = saved.duplicate(true)
func visual(kind: String, side: int, amount: int, lp: Array) -> void:
	if kind == "damage": state["damage"][1-side] += mini(amount,int(state["last_lp"][side]))
	if kind == "heal": state["healed"][side] += amount
	state["last_lp"] = lp.duplicate()
func moment(turn_number: int, text: String) -> void:
	state["moments"].append("G%d  %s" % [turn_number,text])
	if state["moments"].size() > 12: state["moments"].pop_front()
func combat(report: Dictionary, turn_number: int, lp: Array) -> void:
	var side: int = report["side"]
	var delta: int = int(report["difference"])
	var damage: int = int(report["attack"]) if report["direct"] else (maxi(0,delta) if not report["defending"] or report.get("piercing",false) else 0)
	damage = mini(damage,int(lp[1-side]))
	var who: String = "Kamu" if side == 0 else "Nyx"
	if damage > int(state["best_damage"]):
		state["best_damage"] = damage
		state["best_hit"] = "%s / %s: %d LP" % [who,report["card"]["name"],damage]
	if damage > 0: moment(turn_number,"%s: %s memberikan %d kerusakan LP%s." % [who,report["card"]["name"],damage," (menembus)" if report["defending"] and report.get("piercing",false) else ""])
	elif not report["direct"] and delta >= 0:
		moment(turn_number,"%s menyerang %s%s." % [report["card"]["name"],report["target_card"]["name"],"; perisai target menahan kehancuran" if report["target_card"].get("shield",false) and (delta>0 or not report["defending"]) else ""])
func cue(event: Dictionary, turn_number: int) -> void:
	var c: Dictionary = Catalog.card(event["id"])
	var side: int = event["side"]
	var who: String = "Kamu" if side == 0 else "Nyx"
	if c["kind"] == "trap":
		if not event.get("cancelled",false): state["traps"][side] += 1
		moment(turn_number,"%s: %s %s." % [who,c["name"],"dibatalkan" if event.get("cancelled",false) else "aktif"])
	elif c["kind"] == "spell": moment(turn_number,"%s memakai %s." % [who,c["name"]])
	elif int(c["level"]) > 4: moment(turn_number,"%s memanggil %s." % [who,c["name"]])
func text(lp: Array, turns: int) -> String:
	var lines: Array[String] = ["Giliran: %d  |  LP akhir: Kamu %d / Nyx %d" % [turns,lp[0],lp[1]],"Kerusakan LP: Kamu %d / Nyx %d" % state["damage"],"Pemulihan LP: Kamu %d / Nyx %d" % state["healed"],"Trap berhasil aktif: Kamu %d / Nyx %d" % state["traps"],"", "SERANGAN TERBESAR",state["best_hit"],"","MOMEN TERAKHIR"]
	var moments: Array = state["moments"]
	if moments.is_empty(): lines.append("Belum ada momen serangan atau efek.")
	else:
		for entry in moments.slice(maxi(0,moments.size()-5)): lines.append(entry)
	return "\n".join(lines)
