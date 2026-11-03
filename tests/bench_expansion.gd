extends SceneTree
const Duel = preload("res://scripts/duel.gd")
const Catalog = preload("res://scripts/catalog.gd")
const AI = preload("res://scripts/ai.gd")
func _initialize() -> void:
	var samples := 100
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--samples="): samples = int(arg.trim_prefix("--samples="))
	var failures := 0
	for pair in [["fajar","gerhana"],["fajar","rimba"],["gerhana","rimba"]]:
		for level in ["easy","normal","hard"]:
			var wins := 0
			var total := 0
			var stalled := 0
			for seed_id in range(samples):
				for seat in range(2):
					for first in range(2):
						var d = Duel.new()
						d.difficulty = level
						d.start(260031+seed_id*37,first,Catalog.PRESETS[pair[seat]]["cards"],Catalog.PRESETS[pair[1-seat]]["cards"])
						var steps := 0
						while not d.over and steps < 600:
							steps += 1
							if not d.chain.is_empty(): d.respond(d.priority,AI.response(d,d.priority))
							else:
								var action: Dictionary = AI.main_action(d) if d.phase == "MAIN" else AI.battle_action(d)
								if not AI.apply(d,action):
									failures += 1
									d.end_turn()
							for side in range(2):
								var count: int = d.hands[side].size()+d.graves[side].size()+d.decks[side].size()
								for c in d.fields[side]+d.backrows[side]:
									if not c.is_empty(): count += 1
								if count != 20: failures += 1
						if not d.over: stalled += 1
						elif d.winner == seat: wins += 1
						total += 1
			failures += stalled
			print(JSON.stringify({"pair":pair,"difficulty":level,"wins_first_deck":wins,"matches":total,"stalled":stalled}))
	print("BENCHMARK FAILURES: ",failures)
	quit(1 if failures else 0)
