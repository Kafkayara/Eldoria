extends Control
signal impact
const Art = preload("res://scripts/card_art.gd")
const Depth = preload("res://scripts/shaders/card_depth.gdshader")
const DURATION: float = 1.90
var card: Dictionary = {}
var accent := Color("#d6ad63")
var owner_text: String = ""
var age: float = 0.0
var impact_played := false
var animation_speed: float = 1.0
var occlusion_check: Callable
var illustration: TextureRect
var foreground: Control
var depth_material: ShaderMaterial

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	illustration = TextureRect.new()
	illustration.mouse_filter = Control.MOUSE_FILTER_IGNORE
	illustration.texture = Art.texture_for(card)
	illustration.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	illustration.size = Vector2(850,490)
	illustration.position = Vector2(280,110)
	depth_material = ShaderMaterial.new()
	depth_material.shader = Depth
	var region: Rect2 = Art.region_for(card)
	var extent: Vector2 = illustration.texture.get_size()
	depth_material.set_shader_parameter("atlas_region",Vector4(region.position.x/extent.x,region.position.y/extent.y,region.size.x/extent.x,region.size.y/extent.y))
	depth_material.set_shader_parameter("accent",accent)
	depth_material.set_shader_parameter("focus",Art.focus_for(card))
	illustration.material = depth_material
	add_child(illustration)
	foreground = Control.new()
	foreground.mouse_filter = Control.MOUSE_FILTER_IGNORE
	foreground.draw.connect(_draw_foreground)
	add_child(foreground)
	_update_stage()

func _process(delta: float) -> void:
	age += delta*animation_speed
	_update_stage()
	if age >= 0.65 and not impact_played:
		impact_played = true
		if visible: impact.emit()
	if age >= DURATION: queue_free()

func _update_stage() -> void:
	visible = not (occlusion_check.is_valid() and occlusion_check.call())
	modulate.a = smoothstep(0.0,0.16,age)*(1.0-smoothstep(DURATION-0.25,DURATION,age))
	var reveal: float = smoothstep(0.08,0.78,age)
	depth_material.set_shader_parameter("tilt",lerpf(-0.65,0.04,reveal))
	depth_material.set_shader_parameter("reveal",reveal)
	depth_material.set_shader_parameter("shine",clampf((age-0.30)/1.1,0,1))
	depth_material.set_shader_parameter("zoom",1.12-age*0.025)
	illustration.position = Vector2(280+(1-reveal)*95,110+sin(age*1.4)*5)
	queue_redraw()
	foreground.queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(0,0,1280,720),Color(0.012,0.023,0.034,0.94))
	# Distant halo, perspective illustration and foreground debris move on separate planes.
	for i in range(12,0,-1):
		draw_circle(Vector2(780,340),75+i*23,Color(accent,0.012))
	for i in range(4):
		var ellipse := PackedVector2Array()
		for j in range(65):
			var angle: float = j*TAU/64+age*0.12
			ellipse.append(Vector2(720,530)+Vector2(cos(angle)*(250+i*29),sin(angle)*(32+i*7)))
		draw_polyline(ellipse,Color(accent,0.10+i*0.02),1.0,true)
	draw_rect(Rect2(0,0,1280,56),Color(0.012,0.019,0.025,0.9))
	draw_rect(Rect2(0,656,1280,64),Color(0.012,0.019,0.025,0.9))

func _draw_foreground() -> void:
	var reveal: float = smoothstep(0.12,0.8,age)
	var center := Vector2(755,355)
	match str(card.get("id","")):
		"ember":
			for i in range(30):
				var depth: float = 0.35+(i%5)*0.20
				var x: float = 290+fmod(i*83.7+age*24*depth,860)
				var y: float = 622-fmod(i*49.1+age*180*depth,480)
				var tip := Vector2(x+sin(i+age*3)*15,y)
				foreground.draw_line(tip+Vector2(-5,14)*depth,tip,Color(accent,0.65*reveal),2.5*depth,true)
				foreground.draw_circle(tip,1.8*depth,Color("#fff0c6"))
			for i in range(5):
				var path := PackedVector2Array()
				for j in range(16):
					var u: float = j/15.0*reveal
					path.append(Vector2(410+i*140,610)+Vector2(sin(u*8+i)*24,-u*(65+i%3*23)))
				foreground.draw_polyline(path,Color(accent,0.4),2.0,true)
		"noctis":
			var radius: float = 125*reveal
			foreground.draw_arc(center+Vector2(50,-130),radius,-PI*0.85,PI*0.8,72,Color(accent,0.8),3,true)
			foreground.draw_arc(center+Vector2(50,-130),radius+9,-PI*0.6,PI*0.65,64,Color(accent,0.25),7,true)
			for i in range(14):
				var angle: float = i*TAU/14+age*0.20
				var p: Vector2 = center+Vector2(cos(angle)*355,sin(angle)*210)
				var shard := PackedVector2Array([p+Vector2(-5,-18),p+Vector2(12,-2),p+Vector2(2,20),p+Vector2(-9,4)])
				foreground.draw_colored_polygon(shard,Color(accent,0.18*reveal))
				foreground.draw_polyline(shard,Color("#c5dcf0",0.55*reveal),1,true)
		"verdant":
			for i in range(7):
				var path := PackedVector2Array()
				for j in range(24):
					var u: float = j/23.0*reveal
					path.append(Vector2(340+i*120,620)+Vector2(sin(u*5+i)*38,-u*(105+i%3*42)))
				foreground.draw_polyline(path,Color(accent,0.65),3,true)
				var tip: Vector2 = path[-1]
				foreground.draw_colored_polygon(PackedVector2Array([tip,tip+Vector2(-17,-20),tip+Vector2(-4,-28),tip+Vector2(6,-13)]),Color("#c4dea3",0.8*reveal))
			for i in range(20):
				var p := Vector2(330+fmod(i*67.0+age*35,800),570-fmod(i*37.0+age*45,400))
				foreground.draw_circle(p,1.4+i%3,Color(accent,0.45*reveal))
	# A quiet scrim preserves type contrast while the illustration moves independently.
	foreground.draw_polygon(PackedVector2Array([Vector2(96,480),Vector2(672,480),Vector2(672,640),Vector2(96,640)]),PackedColorArray([Color(0.016,0.028,0.037,0.92),Color(0.016,0.028,0.037,0),Color(0.016,0.028,0.037,0),Color(0.016,0.028,0.037,0.92)]))
	var font: Font = ThemeDB.fallback_font
	foreground.draw_line(Vector2(112,100),Vector2(224,100),accent,2,true)
	foreground.draw_string(font,Vector2(240,106),owner_text+"  /  MONSTER ANDALAN",HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color("#e5d9bc"))
	foreground.draw_string(font,Vector2(112,520),"AKAR MENJAGA ESOK" if card["id"] == "verdant" else ("CAHAYA TERAKHIR" if card["id"] == "ember" else "GERHANA BANGKIT"),HORIZONTAL_ALIGNMENT_LEFT,-1,17,accent)
	foreground.draw_string(font,Vector2(108,570),str(card["name"]).to_upper(),HORIZONTAL_ALIGNMENT_LEFT,-1,43,Color("#fff3d9"))
	foreground.draw_string(font,Vector2(112,610),"ATK  %d     /     DEF  %d" % [card["atk"],card["def"]],HORIZONTAL_ALIGNMENT_LEFT,-1,21,Color("#d5dedb"))
	foreground.draw_line(Vector2(112,634),Vector2(112+350*reveal,634),Color(accent,0.7),2,true)
