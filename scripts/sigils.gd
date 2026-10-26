extends RefCounted

static func points(raw: Array, center: Vector2, scale_value: float, angle: float = 0.0) -> PackedVector2Array:
	var result := PackedVector2Array()
	for value in raw:
		result.append(center + Vector2(value).rotated(angle)*scale_value)
	return result

static func draw(canvas: CanvasItem, id: String, center: Vector2, radius: float, color: Color, angle: float = 0.0, width: float = 1.5) -> void:
	var path: Array = []
	match id:
		"solar_lance":
			canvas.draw_line(center+Vector2(-.7,.7)*radius,center+Vector2(.7,-.7)*radius,color,width,true)
			canvas.draw_polyline(points([Vector2(.1,-.8),Vector2(.8,-.8),Vector2(.8,-.1)],center,radius,angle),color,width,true)
		"lunar_veil":
			draw(canvas,"warden",center,radius*.8,color,angle,width)
			canvas.draw_arc(center,radius,-PI*.85,PI*.1,28,color,width,true)
		"dawn":
			path = [Vector2(0,-1),Vector2(0,0.8)]
			canvas.draw_polyline(points(path,center,radius,angle),color,width,true)
			canvas.draw_polyline(points([Vector2(-0.5,0.25),Vector2(0,0.05),Vector2(0.5,0.25)],center,radius,angle),color,width,true)
			canvas.draw_circle(center+Vector2(0,0.8).rotated(angle)*radius,width,color)
		"ember":
			path = [Vector2(0,1),Vector2(-0.65,0.45),Vector2(-0.6,-0.2),Vector2(-0.25,0.05),Vector2(0,-1),Vector2(0.25,-0.2),Vector2(0.6,0.15),Vector2(0.55,0.65),Vector2(0,1)]
			canvas.draw_polyline(points(path,center,radius,angle),color,width,true)
		"oracle":
			for i in range(28):
				var a0: float = PI/2+i*PI/28+angle
				var a1: float = PI/2+(i+1)*PI/28+angle
				var thickness: float = width+sin((i+0.5)*PI/28)*radius*0.27
				canvas.draw_line(center+Vector2.from_angle(a0)*radius,center+Vector2.from_angle(a1)*radius,color,thickness,true)
		"fenrir":
			for i in range(3):
				var x: float = (i-1)*0.53
				canvas.draw_polyline(points([Vector2(x-0.1,-0.9),Vector2(x+0.12,-0.2),Vector2(x-0.28,0.9)],center,radius,angle-0.25),color,width,true)
		"warden":
			path = [Vector2(0,-0.95),Vector2(0.78,-0.5),Vector2(0.62,0.35),Vector2(0,1),Vector2(-0.62,0.35),Vector2(-0.78,-0.5),Vector2(0,-0.95)]
			canvas.draw_polyline(points(path,center,radius,angle),color,width,true)
			canvas.draw_line(center+Vector2(0,-0.7).rotated(angle)*radius,center+Vector2(0,0.7).rotated(angle)*radius,color,width,true)
		"sprite":
			path = [Vector2(0,-1),Vector2(0.24,-0.24),Vector2(1,0),Vector2(0.24,0.24),Vector2(0,1),Vector2(-0.24,0.24),Vector2(-1,0),Vector2(-0.24,-0.24)]
			canvas.draw_colored_polygon(points(path,center,radius,angle),color)
		"storm":
			path = [Vector2(0.45,-1),Vector2(-0.55,0.1),Vector2(0.05,0.03),Vector2(-0.4,1),Vector2(0.65,-0.25),Vector2(0.0,-0.18),Vector2(0.45,-1)]
			canvas.draw_colored_polygon(points(path,center,radius,angle),color)
		"sanctuary":
			canvas.draw_arc(center+Vector2(0,0.35)*radius,radius*0.6,PI,TAU,24,color,width,true)
			canvas.draw_line(center+Vector2(-1,0.35).rotated(angle)*radius,center+Vector2(1,0.35).rotated(angle)*radius,color,width,true)
			for i in range(5):
				var a: float = PI+i*PI/4
				canvas.draw_line(center+Vector2(0,0.35)*radius+Vector2.from_angle(a)*radius*0.8,center+Vector2(0,0.35)*radius+Vector2.from_angle(a)*radius*1.08,color,width,true)
		"blessing":
			draw(canvas,"dawn",center,radius*0.85,color,angle,width)
			canvas.draw_polyline(points([Vector2(-1,-0.1),Vector2(-0.55,0.55),Vector2(0,0.3),Vector2(0.55,0.55),Vector2(1,-0.1)],center,radius,angle),color,width,true)
		"eclipse":
			path = [Vector2(0.15,-1),Vector2(-0.32,-0.28),Vector2(0.21,0.05),Vector2(-0.15,1)]
			canvas.draw_polyline(points(path,center,radius,angle),color,width*1.6,true)
			canvas.draw_polyline(points([Vector2(-0.7,-0.7),Vector2(-1,0),Vector2(-0.7,0.7)],center,radius,angle),color,width,true)
			canvas.draw_polyline(points([Vector2(0.7,-0.7),Vector2(1,0),Vector2(0.7,0.7)],center,radius,angle),color,width,true)


		"sentinel":
			canvas.draw_line(center-Vector2(0,radius),center+Vector2(0,radius),color,width,true)
			canvas.draw_arc(center+Vector2(radius*0.2,-radius*0.5),radius*0.5,-PI,PI/2,20,color,width,true)
		"owl":
			canvas.draw_polyline(points([Vector2(-1,-0.7),Vector2(-0.6,0.6),Vector2(0,1),Vector2(0.6,0.6),Vector2(1,-0.7),Vector2(0,0),Vector2(-1,-0.7)],center,radius,angle),color,width,true)
		"witch":
			canvas.draw_arc(center,radius,0,TAU,32,color,width,true)
			canvas.draw_line(center-Vector2(radius*0.7,radius*0.7),center+Vector2(radius*0.7,radius*0.7),color,width,true)
		"noctis":
			canvas.draw_arc(center,radius,0.3,TAU-0.3,32,color,width*2,true)
			canvas.draw_polyline(points([Vector2(-1,-1),Vector2(-0.4,0),Vector2(0,0.7),Vector2(0.4,0),Vector2(1,-1)],center,radius,angle),color,width,true)
		"mirror":
			canvas.draw_arc(center,radius*0.8,0,TAU,32,color,width,true)
			canvas.draw_polyline(points([Vector2(-1,0.4),Vector2(0,-0.6),Vector2(1,0.4)],center,radius,angle),color,width,true)
		"seal":
			canvas.draw_rect(Rect2(center-Vector2.ONE*radius*0.65,Vector2.ONE*radius*1.3),color,false,width)
			canvas.draw_line(center-Vector2.ONE*radius,center+Vector2.ONE*radius,color,width,true)
		"thorns":
			for i in range(3):
				canvas.draw_polyline(points([Vector2(-1,-0.8+i*0.7),Vector2(0,-0.2+i*0.7),Vector2(1,-0.8+i*0.7)],center,radius,angle),color,width,true)
		"hourglass":
			canvas.draw_polyline(points([Vector2(-0.8,-1),Vector2(0.8,-1),Vector2(-0.8,1),Vector2(0.8,1),Vector2(-0.8,-1)],center,radius,angle),color,width,true)
