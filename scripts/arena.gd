extends Control
# Observatory dueling table: stationary engraving, matte slate, restrained brass.
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)

func _draw() -> void:
	draw_rect(Rect2(0,0,1280,720),Color("#0e181d"))
	for y in range(6,720,13):
		for x in range(5,1280,23):
			var offset: float = sin(x*1.37+y*0.17)*3
			draw_line(Vector2(x+offset,y),Vector2(x+8+offset,y+1),Color(0.5,0.57,0.57,0.025),1)
	var board := PackedVector2Array([Vector2(316,74),Vector2(974,74),Vector2(998,98),Vector2(998,488),Vector2(974,512),Vector2(316,512),Vector2(290,488),Vector2(290,98)])
	var shadow := PackedVector2Array()
	for point in board:
		shadow.append(point+Vector2(0,4))
	draw_colored_polygon(shadow,Color("#070f13"))
	draw_colored_polygon(board,Color("#1c2c30"))
	var outline := board.duplicate()
	outline.append(board[0])
	draw_polyline(outline,Color("#665b43"),2,true)
	for y in range(86,505,6):
		draw_line(Vector2(301,y),Vector2(987,y),Color(0.6,0.65,0.6,0.018),1)
	var center := Vector2(645,309)
	for radius in [119,128,188]:
		draw_arc(center,radius,0,TAU,144,Color(0.7,0.65,0.5,0.075),1,true)
	for i in range(48):
		var angle: float = i*TAU/48
		var length: float = 9 if i%4 == 0 else 4
		draw_line(center+Vector2.from_angle(angle)*188,center+Vector2.from_angle(angle)*(188-length),Color(0.76,0.69,0.51,0.12),1,true)
	for y in [153,309,485]:
		draw_line(Vector2(303,y),Vector2(986,y),Color(0.68,0.64,0.5,0.2),1,true)
	for x in [300,989]:
		for y in range(161,478,21):
			var width: float = 7 if y%2 == 0 else 4
			draw_line(Vector2(x,y),Vector2(x+width*(1 if x==300 else -1),y),Color(0.67,0.62,0.46,0.25),1)
	draw_colored_polygon(PackedVector2Array([center+Vector2(0,-8),center+Vector2(6,0),center+Vector2(0,8),center+Vector2(-6,0)]),Color("#756b50"))
	draw_rect(Rect2(290,547,708,166),Color("#101f25"))
	draw_line(Vector2(291,547),Vector2(996,547),Color("#665b43"),1)
	for x in [298,988]:
		draw_line(Vector2(x,553),Vector2(x,704),Color("#344448"),1)
