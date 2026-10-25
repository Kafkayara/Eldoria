extends Control
var bursts: Array = []
var beams: Array = []

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func burst(point: Vector2, color: Color) -> void:
	bursts.append({"pos": point, "color":color, "time":0.0})

func strike(from: Vector2, to: Vector2) -> void:
	beams.append({"from":from, "to":to, "time":0.0})

func _process(delta: float) -> void:
	for item in bursts:
		item["time"] += delta
	for item in beams:
		item["time"] += delta
	bursts = bursts.filter(func(item): return item["time"] < 0.8)
	beams = beams.filter(func(item): return item["time"] < 0.45)
	if not bursts.is_empty() or not beams.is_empty():
		queue_redraw()
	else:
		queue_redraw()

func _draw() -> void:
	for item in bursts:
		var t: float = item["time"] / 0.8
		var color: Color = item["color"]
		color.a = 1.0 - t
		draw_arc(item["pos"], 12 + t*95, 0, TAU, 64, color, 3.0*(1-t)+1,true)
		for i in range(14):
			var angle: float = i * TAU / 14.0
			var p: Vector2 = item["pos"] + Vector2.from_angle(angle) * (10+t*100)
			draw_circle(p,3*(1-t),color)
	for item in beams:
		var t: float = item["time"] / 0.45
		var finish: Vector2 = item["from"].lerp(item["to"],minf(1,t*3))
		draw_line(item["from"],finish,Color(0.9,0.7,0.35,(1-t)*0.2),18,true)
		draw_line(item["from"],finish,Color(1,0.9,0.6,1-t),4,true)
