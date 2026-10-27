extends SceneTree
const Duel = preload("res://scripts/duel.gd")
const Catalog = preload("res://scripts/catalog.gd")
const AI = preload("res://scripts/ai.gd")
var samples := 60
var offset := 0
func _initialize() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--samples="): samples = int(arg.trim_prefix("--samples="))
		if arg.begins_with("--offset="): offset = int(arg.trim_prefix("--offset="))
	call_deferred("run")
func run() -> void:
	for enemy in ["fajar","gerhana"]:
		var wins := 0
		var total := 0
		var stalled := 0
		var levels := {}
		for level in ["easy","normal","hard"]:
			var level_wins := 0
			for k in range(offset,offset+samples):
				for seat in range(2):
					for first in range(2):
						var d = Duel.new()
						d.difficulty = level
						d.start(100003+k*23,first,Catalog.RIMBA if seat==0 else Catalog.PRESETS[enemy]["cards"],Catalog.PRESETS[enemy]["cards"] if seat==0 else Catalog.RIMBA)
						var steps := 0
						while not d.over and steps < 1000:
							steps += 1
							if not d.chain.is_empty(): d.respond(d.priority,AI.response(d,d.priority))
							else:
								var action: Dictionary = AI.main_action(d) if d.phase == "MAIN" else AI.battle_action(d)
								if not AI.apply(d,action): d.end_turn()
						if not d.over: stalled += 1
						elif d.winner == seat: level_wins += 1
						total += 1
			wins += level_wins
			levels[level] = {"wins":level_wins,"matches":samples*4}
		print(JSON.stringify({"opponent":enemy,"rimba_wins":wins,"matches":total,"stalled":stalled,"levels":levels}))
	quit()
