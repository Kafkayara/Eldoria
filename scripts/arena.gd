extends Control
var elapsed: float = 0.0
var stars: Array[Vector3] = []

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var rng := RandomNumberGenerator.new()
	rng.seed = 8294
	for i in range(75):
		stars.append(Vector3(rng.randf_range(0,1600),rng.randf_range(0,900),rng.randf_range(0.4,2.0)))

func _process(delta: float) -> void:
	elapsed += delta
	queue_redraw()

func _draw() -> void:
	for i in range(90):
		var t: float = i / 90.0
		draw_rect(Rect2(0,i*10,1600,11), Color("#080f1d").lerp(Color("#152b36"),sin(t*PI)*0.55))
	for star in stars:
		var a: float = 0.14 + sin(elapsed * star.z + star.x) * 0.09
		draw_circle(Vector2(star.x,star.y),star.z,Color(0.7,0.86,1,a))
	var center := Vector2(804,414)
	var color := Color(0.32,0.64,0.68,0.11)
	for r in [110, 145, 230, 270]:
		draw_arc(center,r,0,TAU,120,color,1,true)
	for i in range(12):
		var angle: float = i * TAU / 12.0 + elapsed * 0.015
		draw_line(center+Vector2.from_angle(angle)*145,center+Vector2.from_angle(angle)*267,color,1,true)
	for x in range(340,1280,80):
		draw_line(Vector2(x,180),Vector2(x,650),Color(0.2,0.5,0.6,0.025),1)
	draw_line(Vector2(338,421),Vector2(1262,421),Color(0.7,0.61,0.4,0.25),1,true)
	draw_colored_polygon(PackedVector2Array([Vector2(795,414),Vector2(804,405),Vector2(813,414),Vector2(804,423)]),Color("#bda376"))
