extends Control
var elapsed: float = 0.0
var stars: Array[Vector3] = []

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var rng := RandomNumberGenerator.new()
	rng.seed = 8294
	for i in range(55):
		stars.append(Vector3(rng.randf_range(0,1280),rng.randf_range(0,720),rng.randf_range(0.4,1.6)))

func _process(delta: float) -> void:
	elapsed += delta
	queue_redraw()

func _draw() -> void:
	for i in range(72):
		var t: float = i/72.0
		draw_rect(Rect2(0,i*10,1280,11),Color("#0a1422").lerp(Color("#204051"),sin(t*PI)*0.6))
	for star in stars:
		var a: float = 0.15+sin(elapsed*star.z+star.x)*0.08
		draw_circle(Vector2(star.x,star.y),star.z,Color(0.7,0.86,1,a))
	var center := Vector2(649,308)
	var color := Color(0.45,0.77,0.81,0.13)
	for r in [97,127,204,243]:
		draw_arc(center,r,0,TAU,100,color,1,true)
	for i in range(12):
		var angle: float = i*TAU/12+elapsed*0.015
		draw_line(center+Vector2.from_angle(angle)*127,center+Vector2.from_angle(angle)*242,color,1,true)
	draw_line(Vector2(298,308),Vector2(992,308),Color(0.8,0.7,0.44,0.4),1,true)
	for x in [298,992]:
		draw_line(Vector2(x,142),Vector2(x,473),Color(0.6,0.76,0.8,0.15),1,true)
