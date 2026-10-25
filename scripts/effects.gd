extends Control
const Sigils = preload("res://scripts/sigils.gd")
const Painter = preload("res://scripts/effects_painter.gd")
const MAX_EVENTS: int = 8
const PROFILES = {
	"dawn": {"shape":"solar_cut","color":Color("#e9bd67"),"light":Color("#fff2c6"),"impact":0.38,"duration":0.85},
	"ember": {"shape":"dragon_breath","color":Color("#f07a3f"),"light":Color("#ffd08b"),"impact":0.52,"duration":1.10},
	"oracle": {"shape":"lunar_comet","color":Color("#a5a7ed"),"light":Color("#e3e9ff"),"impact":0.48,"duration":1.05},
	"fenrir": {"shape":"verdant_claws","color":Color("#72bfa0"),"light":Color("#d8f1c3"),"impact":0.34,"duration":0.85},
	"warden": {"shape":"aegis_ram","color":Color("#d6ad63"),"light":Color("#fff0c4"),"impact":0.47,"duration":1.05},
	"sprite": {"shape":"astral_darts","color":Color("#c69cdb"),"light":Color("#f4d9fc"),"impact":0.46,"duration":1.00},
	"storm": {"shape":"forked_lightning","color":Color("#76bfe3"),"light":Color("#d3f1ff"),"impact":0.38,"duration":0.90},
	"sanctuary": {"shape":"sunrise","color":Color("#e1c57f"),"light":Color("#f7e9b3"),"impact":0.48,"duration":1.15},
	"blessing": {"shape":"winged_blade","color":Color("#e8d2a1"),"light":Color("#fff9de"),"impact":0.46,"duration":1.10},
	"eclipse": {"shape":"sky_fracture","color":Color("#ba79b3"),"light":Color("#f5c5e9"),"impact":0.50,"duration":1.10}
}
var events: Array = []
# Compatibility with previous visual reset code.
var bursts: Array = []
var beams: Array = []
var reduced_motion: bool = false
var elapsed: float = 0.0
var last_cue: Dictionary = {}
var painter
var occlusion_check: Callable

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	painter = Painter.new()
	painter.effect_source = self
	painter.z_index = 1
	painter.size = Vector2(1280,720)
	add_child(painter)
	set_process(false)

func impact_delay(card_id: String, action: String) -> float:
	if reduced_motion:
		return 0.08
	if action == "enter":
		return 0.42
	return float(PROFILES.get(card_id,PROFILES["dawn"])["impact"])

func play_card(card_id: String, action: String, source: Vector2, target: Vector2) -> Dictionary:
	if not PROFILES.has(card_id):
		return {}
	var profile: Dictionary = PROFILES[card_id]
	var event := {
		"card_id":card_id,"shape":profile["shape"],"action":action,
		"from":Vector2(clampf(source.x,310,980),clampf(source.y,100,465)),
		"to":Vector2(clampf(target.x,330,964),clampf(target.y,150,460)),
		"time":0.0,"impact":impact_delay(card_id,action),
		"duration":0.32 if reduced_motion else float(profile["duration"]),
		"color":profile["color"],"light":profile["light"],"simple":reduced_motion
	}
	if events.size() >= MAX_EVENTS:
		events.pop_front()
	events.append(event)
	last_cue = event.duplicate(true)
	set_process(true)
	redraw_effects()
	return event

func clear_all() -> void:
	events.clear()
	bursts.clear()
	beams.clear()
	last_cue = {}
	set_process(false)
	redraw_effects()

func burst(point: Vector2, _color: Color) -> void:
	play_card("dawn","enter",point,point)

func strike(source: Vector2, target: Vector2) -> void:
	play_card("dawn","attack",source,target)

func _process(delta: float) -> void:
	elapsed += delta
	for event in events:
		event["time"] += delta
	events = events.filter(func(event): return event["time"] < event["duration"])
	redraw_effects()
	if events.is_empty():
		set_process(false)

func _color(value: Color, alpha: float) -> Color:
	return Color(value.r,value.g,value.b,clampf(alpha,0,1))

func _phase(time: float, start: float, end: float) -> float:
	return clampf((time-start)/maxf(0.01,end-start),0,1)

func _line(points: PackedVector2Array, color: Color, width: float = 2.0) -> void:
	if points.size() >= 2:
		painter.draw_polyline(points,color,width,true)

func _leaf(point: Vector2, radius: float, angle: float, color: Color) -> void:
	painter.draw_colored_polygon(Sigils.points([Vector2(0,-1),Vector2(0.5,0),Vector2(0,1),Vector2(-0.32,0)],point,radius,angle),color)

func _rays(point: Vector2, radius: float, color: Color, count: int, rotation_value: float = 0.0) -> void:
	for i in range(count):
		var a: float = i*TAU/count+rotation_value
		painter.draw_line(point+Vector2.from_angle(a)*radius*0.7,point+Vector2.from_angle(a)*radius,color,1.5,true)

func redraw_effects() -> void:
	if is_instance_valid(painter):
		painter.queue_redraw()

func paint_effects() -> void:
	if occlusion_check.is_valid() and occlusion_check.call():
		return
	for event in events:
		_draw_event(event)

func _draw_event(event: Dictionary) -> void:
	var t: float = event["time"]
	var duration: float = event["duration"]
	var impact: float = event["impact"]
	var fade: float = 1.0-_phase(t,duration*0.68,duration)
	var a: Vector2 = event["from"]
	var b: Vector2 = event["to"]
	var color: Color = _color(event["color"],fade)
	var light: Color = _color(event["light"],fade)
	var travel: float = _phase(t,0.10,impact)
	var after: float = _phase(t,impact,duration)
	var hit: bool = t >= impact
	if event["simple"]:
		Sigils.draw(painter,event["card_id"],b,18+_phase(t,0,duration)*5,color,0,2)
		return
	if event["action"] == "enter":
		_draw_entry(event,b,color,light,travel,after,hit)
		return
	if event["action"] == "guard":
		_draw_guard(b,color,light,_phase(t,0,duration),true)
		return
	match event["card_id"]:
		"dawn":
			if travel > 0 and not hit:
				var head: Vector2 = a.lerp(b,travel)
				var direction: Vector2 = (b-a).normalized()
				painter.draw_line(head-direction*42,head,light,4,true)
				painter.draw_line(head-direction.rotated(0.1)*31,head,color,8,true)
			if hit:
				var slash_a: Vector2 = b+Vector2(-37,29)*(0.7+after*0.3)
				var slash_b: Vector2 = b+Vector2(38,-31)*(0.7+after*0.3)
				painter.draw_line(slash_a,slash_b,color,6*(1-after)+1,true)
				painter.draw_line(slash_a,slash_b,light,2,true)
				painter.draw_arc(b,37+after*10,-1.6,0.8,25,color,2,true)
		"ember":
			_draw_flame(a,b,travel,after,hit,color,light,t)
		"oracle":
			var head: Vector2 = a.lerp(b,travel)+Vector2(sin(travel*PI)*24,0)
			if not hit:
				for i in range(6):
					var tail: float = maxf(0,travel-i*0.045)
					var point: Vector2 = a.lerp(b,tail)+Vector2(sin(tail*PI)*24,0)
					painter.draw_circle(point,6-i*0.7,_color(color,(1-i/6.0)*0.5))
				Sigils.draw(painter,"oracle",head,13,light,-0.4,2)
			else:
				Sigils.draw(painter,"oracle",b,24+after*13,color,-0.3,2)
				for i in range(3):
					Sigils.draw(painter,"sprite",b+Vector2.from_angle(i*TAU/3+after)*34,4,light,after)
		"fenrir":
			if not hit:
				var head: Vector2 = a.lerp(b,travel)
				for i in range(3):
					_leaf(head+Vector2((i-1)*8,7*i),5,travel*3+i,color)
			else:
				for i in range(3):
					var shift: Vector2 = Vector2((i-1)*15,0)
					var p0: Vector2 = b+shift+Vector2(-23,-29)
					var p1: Vector2 = b+shift+Vector2(15,-10)
					var p2: Vector2 = b+shift+Vector2(-5,31)
					var path := PackedVector2Array()
					for step in range(19):
						var u: float = step/18.0
						path.append(p0*(1-u)*(1-u)+p1*2*u*(1-u)+p2*u*u)
					_ribbon(path,4.5*(1-after)+0.8,color)
					_line(path,light,1.2)
				for i in range(5):
					_leaf(b+Vector2.from_angle(i*1.2)*after*42,4,after+i,color)
		"warden":
			var head: Vector2 = a.lerp(b,travel)
			if not hit:
				Sigils.draw(painter,"warden",head,22,color,(b-a).angle()+PI/2,3)
				painter.draw_line(head+(a-b).normalized()*27,head+(a-b).normalized()*55,_color(color,0.4),3,true)
			else:
				_draw_guard(b,color,light,after)
		"sprite":
			for i in range(3):
				var p: float = clampf(travel-i*0.09,0,1)
				var head: Vector2 = a.lerp(b,p)+Vector2(sin(p*PI)*(i-1)*34,0)
				if not hit:
					Sigils.draw(painter,"sprite",head,7+i,light,p*2+i)
				else:
					var destination: Vector2 = b+Vector2.from_angle(i*TAU/3+after)*after*36
					Sigils.draw(painter,"sprite",destination,10*(1-after)+2,color,i+after)
		"storm":
			_draw_lightning(a,b,travel,after,hit,color,light,t)
		"sanctuary":
			var growth: float = sin(minf(1,t/impact)*PI/2)
			var radius: float = 32+after*8
			painter.draw_arc(b+Vector2(0,18),radius*growth,PI,TAU,32,color,3,true)
			painter.draw_line(b+Vector2(-43,18),b+Vector2(43,18),light,2,true)
			for i in range(7):
				var angle: float = PI+i*PI/6
				painter.draw_line(b+Vector2(0,18)+Vector2.from_angle(angle)*radius,b+Vector2(0,18)+Vector2.from_angle(angle)*(radius+13*growth),color,2,true)
			for i in range(3):
				var y: float = fmod(t*32+i*17,55)
				painter.draw_line(b+Vector2((i-1)*25,25-y),b+Vector2((i-1)*25,17-y),_color(light,0.45),2,true)
		"blessing":
			var rise: float = sin(travel*PI/2)*20
			var center: Vector2 = b+Vector2(0,17-rise)
			Sigils.draw(painter,"blessing",center,31,_color(Color("#352b22"),fade),0,5.5)
			Sigils.draw(painter,"blessing",center,30,color,0,2.5)
			if hit:
				for side in [-1,1]:
					var wing := PackedVector2Array([center+Vector2(side*8,0),center+Vector2(side*(30+after*9),-20),center+Vector2(side*20,8)])
					_line(wing,light,2)
				_rays(center,43,color,4,PI/4)
		"eclipse":
			var growth: float = sin(travel*PI/2)
			var rift := PackedVector2Array([b+Vector2(-5,-48)*growth,b+Vector2(9,-15)*growth,b+Vector2(-8,4)*growth,b+Vector2(8,48)*growth,b+Vector2(22,15)*growth,b+Vector2(12,-3)*growth,b+Vector2(18,-30)*growth])
			if growth > 0.02:
				painter.draw_colored_polygon(rift,Color(0.025,0.012,0.05,fade))
			_line(rift,_color(color,0.85),2.5)
			if hit:
				for i in range(7):
					var angle: float = i*2.4
					var shard: Vector2 = b+Vector2.from_angle(angle)*(15+after*34)
					painter.draw_colored_polygon(Sigils.points([Vector2(0,-1),Vector2(0.6,0.4),Vector2(-0.5,0.8)],shard,5+sin(i)*2,angle+after),color)
				_line(PackedVector2Array([b+Vector2(-30,-23),b+Vector2(-14,-9),b,b+Vector2(31,18)]),light,1.2)

func _draw_entry(event: Dictionary, point: Vector2, color: Color, light: Color, growth: float, after: float, hit: bool) -> void:
	var progress: float = growth if not hit else 1.0
	match event["card_id"]:
		"dawn":
			Sigils.draw(painter,"dawn",point,26*progress,light,-0.35,2)
			_rays(point,35*progress,color,8,PI/8)
		"ember":
			for i in range(5):
				var x: float = (i-2)*13
				var height: float = (25+sin(i*2.1)*13)*progress
				var flame := PackedVector2Array([point+Vector2(x-8,24),point+Vector2(x-3,-height),point+Vector2(x+10,24)])
				painter.draw_colored_polygon(flame,_color(color,0.6*(1-after)))
			Sigils.draw(painter,"ember",point,18*progress,light,0,2)
		"oracle":
			Sigils.draw(painter,"oracle",point,27*progress,light,-0.3)
			for i in range(3):
				Sigils.draw(painter,"sprite",point+Vector2.from_angle(i*TAU/3+after)*34*progress,4,color)
		"fenrir":
			for i in range(8):
				var angle: float = i*TAU/8
				_leaf(point+Vector2.from_angle(angle)*28*progress,8,angle+PI/2,color)
			Sigils.draw(painter,"fenrir",point,17*progress,light,0,1.5)
		"warden":
			_draw_guard(point,color,light,1-progress if not hit else after)
		"sprite":
			for i in range(5):
				var angle: float = i*TAU/5+event["time"]*1.7
				Sigils.draw(painter,"sprite",point+Vector2.from_angle(angle)*30*progress,5+i%2,light,angle)
			painter.draw_arc(point,23*progress,-2.7,-0.4,24,color,1.5,true)
		_:
			Sigils.draw(painter,event["card_id"],point,24*progress,color)

func _draw_guard(point: Vector2, color: Color, light: Color, progress: float, broken: bool = false) -> void:
	Sigils.draw(painter,"warden",point,32+progress*9,color,0,2.5)
	for side in [-1,1]:
		_line(PackedVector2Array([point+Vector2(side*20,-33),point+Vector2(side*37,-17),point+Vector2(side*30,20)]),_color(light,0.65),1.5)
	if broken and progress > 0.4:
		_line(PackedVector2Array([point+Vector2(0,-21),point+Vector2(-6,0),point+Vector2(6,11),point+Vector2(1,28)]),light,1.2)

func _draw_flame(a: Vector2, b: Vector2, travel: float, after: float, hit: bool, color: Color, light: Color, time_value: float) -> void:
	var direction: Vector2 = (b-a).normalized()
	var normal := Vector2(-direction.y,direction.x)
	if not hit and travel < 0.03:
		Sigils.draw(painter,"ember",a,8,color)
		return
	if not hit:
		var head: Vector2 = a.lerp(b,travel)
		var upper: Array[Vector2] = []
		var lower: Array[Vector2] = []
		for i in range(12):
			var p: float = i/11.0
			var point: Vector2 = a.lerp(head,p)
			var width: float = 3+pow(p,1.5)*22
			point += normal*sin(i*2.1-time_value*16)*p*3
			upper.append(point+normal*width)
			lower.push_front(point-normal*width)
		var polygon := PackedVector2Array(upper)
		polygon.append_array(PackedVector2Array(lower))
		painter.draw_colored_polygon(polygon,_color(color,0.82))
		painter.draw_line(a,head,_color(light,0.8),3,true)
		for i in range(4):
			var p: float = clampf(travel-i*0.13,0,1)
			var point: Vector2 = a.lerp(b,p)+normal*sin(time_value*8+i*2)*15*p
			painter.draw_circle(point,2.3-i*0.3,_color(light,0.75-i*0.13))
	else:
		for i in range(7):
			var angle: float = i*TAU/7
			var point: Vector2 = b+Vector2.from_angle(angle)*(6+after*30)
			painter.draw_colored_polygon(Sigils.points([Vector2(0,-1),Vector2(0.6,0.6),Vector2(-0.5,0.5)],point,10*(1-after)+3,angle+time_value),color)
		painter.draw_circle(b,11*(1-after),light)

func _draw_lightning(a: Vector2, b: Vector2, travel: float, after: float, hit: bool, color: Color, light: Color, time_value: float) -> void:
	var end: Vector2 = a.lerp(b,travel)
	var direction: Vector2 = (b-a).normalized()
	var normal := Vector2(-direction.y,direction.x)
	var path := PackedVector2Array()
	for i in range(10):
		var p: float = i/9.0
		var offset: float = 0.0 if i == 0 or i == 9 else sin(i*13.7+floor(time_value*7))*13
		path.append(a.lerp(end,p)+normal*offset)
	_line(path,_color(color,0.28),9)
	_line(path,light,2)
	if path.size() >= 7:
		for index in [4,7]:
			var origin: Vector2 = path[index]
			_line(PackedVector2Array([origin,origin+normal*18-direction*8,origin+normal*27+direction*9]),color,1.4)
	if hit:
		_rays(b,14+after*18,color,6,0.2)


func _ribbon(path: PackedVector2Array, width: float, color: Color) -> void:
	var upper := PackedVector2Array()
	var lower := PackedVector2Array()
	for i in range(path.size()):
		var direction: Vector2 = path[mini(i+1,path.size()-1)]-path[maxi(0,i-1)]
		var normal := Vector2(-direction.y,direction.x).normalized()
		var u: float = float(i)/maxi(1,path.size()-1)
		var radius: float = 0.3+sin(u*PI)*width
		upper.append(path[i]+normal*radius)
		lower.insert(0,path[i]-normal*radius)
	upper.append_array(lower)
	painter.draw_colored_polygon(upper,color)
