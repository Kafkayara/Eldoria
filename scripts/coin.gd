extends Control
# Engraved coin: sun emblem (gambar) and Roman numeral I (angka).
var face: int = -1

func _draw() -> void:
	var center := size / 2.0
	var gold := Color("#c6ae7d")
	draw_circle(center,88,Color("#332e24"))
	draw_arc(center,87,0,TAU,96,gold,3,true)
	draw_arc(center,76,0,TAU,96,gold.darkened(0.3),1,true)
	for i in range(32):
		var ray := Vector2.from_angle(i * TAU / 32.0)
		draw_line(center+ray*80,center+ray*84,gold.darkened(0.25),1,true)
	if face == 0:
		draw_circle(center,22,gold)
		for i in range(8):
			var ray := Vector2.from_angle(i * TAU / 8.0)
			draw_line(center+ray*32,center+ray*49,gold,4,true)
	elif face == 1:
		draw_line(center+Vector2(0,-40),center+Vector2(0,40),gold,8,true)
		draw_line(center+Vector2(-24,-40),center+Vector2(24,-40),gold,5,true)
		draw_line(center+Vector2(-24,40),center+Vector2(24,40),gold,5,true)
	else:
		draw_arc(center,28,-PI/2,PI,48,gold,3,true)
