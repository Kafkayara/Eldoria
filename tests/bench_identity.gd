extends SceneTree
const Duel = preload("res://scripts/duel.gd")
const Catalog = preload("res://scripts/catalog.gd")
const AI = preload("res://scripts/ai.gd")
var samples := 40
var seed_start := 0
var outfile := ""
var selected := ""
func _initialize() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--samples="): samples = int(arg.trim_prefix("--samples="))
		if arg.begins_with("--seed-start="): seed_start = int(arg.trim_prefix("--seed-start="))
		if arg.begins_with("--out="): outfile = arg.trim_prefix("--out=")
		if arg.begins_with("--variant="): selected = arg.trim_prefix("--variant=")
	call_deferred("run")
func run() -> void:
	var variants := [{"name":"before"},{"name":"after"}]
	var result := {}
	for variant in variants:
		if not selected.is_empty() and variant["name"] != selected: continue
		var ids: Array = Catalog.DECK.duplicate()
		var enemy_ids: Array = Catalog.GERHANA.duplicate()
		if variant["name"] == "before":
			ids[ids.find("solar_lance")] = "storm"
			enemy_ids[enemy_ids.find("lunar_veil")] = "blessing"
		var report := {"matches":0,"fajar_wins":0,"stalled":0,"by_level":{},"fajar_first":{"matches":0,"wins":0},"gerhana_first":{"matches":0,"wins":0}}
		for level in ["easy","normal","hard"]:
			var totals := {"matches":0,"wins":0}
			for seed_index in range(seed_start,seed_start+samples):
				for seat in range(2):
					for first in range(2):
						var d = Duel.new()
						d.difficulty = level
						d.start(70001+seed_index*17,first,ids if seat==0 else enemy_ids,enemy_ids if seat==0 else ids)
						var actions := 0
						while not d.over and actions < 800:
							actions += 1
							if not d.chain.is_empty(): d.respond(d.priority,AI.response(d,d.priority))
							else:
								var action: Dictionary = AI.main_action(d) if d.phase == "MAIN" else AI.battle_action(d)
								if not AI.apply(d,action): d.end_turn()
						report["matches"] += 1
						totals["matches"] += 1
						var opening: String = "fajar_first" if first == seat else "gerhana_first"
						report[opening]["matches"] += 1
						if not d.over: report["stalled"] += 1
						elif d.winner == seat:
							report["fajar_wins"] += 1
							totals["wins"] += 1
							report[opening]["wins"] += 1
				report["by_level"][level] = totals
		result[variant["name"]] = report
		print(variant["name"],": ",JSON.stringify(report))
	if not outfile.is_empty():
		var file := FileAccess.open(outfile,FileAccess.WRITE)
		file.store_string(JSON.stringify(result,"  "))
	quit()
