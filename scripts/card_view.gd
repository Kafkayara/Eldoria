extends Button
const Catalog = preload("res://scripts/catalog.gd")
const Art = preload("res://scripts/card_art.gd")
const Sigils = preload("res://scripts/sigils.gd")
const ATLAS = Art.ATLAS
const FIELD_SIZE = Vector2(146,142)
const FIELD_CENTER = Vector2(73,77)
const FIELD_BODY = Vector2(68,94)
var field_mode := false
var field_angle := 0.0:
	set(value):
		field_angle = value
		queue_redraw()
var field_uid: int = -1
var field_target := 0.0
var field_tween: Tween
signal inspect_requested(card_data: Dictionary)
static var allow_art_motion: bool = true
var art_offset := Vector2.ZERO
var data: Dictionary = {}
var action_hint: String = ""
var selected: bool = false
var back: bool = false
var empty_caption: String = "ZONA MONSTER"
var large: bool = false
var font: Font = ThemeDB.fallback_font

func _ready() -> void:
	font = get_theme_font("font")
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_entered.connect(queue_redraw)
	mouse_exited.connect(func(): art_offset = Vector2.ZERO; queue_redraw())
	focus_entered.connect(queue_redraw)
	focus_exited.connect(queue_redraw)
	resized.connect(queue_redraw)
	gui_input.connect(_inspect_input)

func set_field_pose(duration: float = 0.0) -> void:
	field_mode = true
	var uid: int = int(data.get("uid",-1))
	var angle: float = -PI/2 if data.get("defending",false) else 0.0
	if uid == field_uid and angle == field_target and duration > 0:
		return
	if field_tween and field_tween.is_valid(): field_tween.kill()
	if duration > 0 and uid == field_uid and uid >= 0:
		field_tween = create_tween()
		field_tween.tween_property(self,"field_angle",angle,duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	else:
		field_angle = angle
	field_uid = uid
	field_target = angle

func _draw_field() -> void:
	var defending: bool = data.get("defending",false)
	var spent: bool = data.get("attacked",false)
	var accent := Color("#a6d9de") if defending else Color("#f2dca9")
	var focused: bool = selected or has_focus() or (is_hovered() and not disabled)
	if focused:
		_box(Rect2(Vector2.ZERO,size),Color(0.06,0.15,0.20,0.65),Color("#8defff"),2,4)
	# Rotate only the card body; labels and the full zone hit area stay upright.
	draw_set_transform(FIELD_CENTER,field_angle)
	var body := Rect2(-FIELD_BODY/2,FIELD_BODY)
	_box(body,Color("#e7dec7"),accent,2,3)
	var art := body.grow(-4)
	var region: Rect2 = Art.region_for(data)
	var crop_width: float = region.size.y*art.size.x/art.size.y
	region.position.x += (region.size.x-crop_width)/2
	region.size.x = crop_width
	if is_hovered() and allow_art_motion:
		var margin: Vector2 = region.size*0.025
		region.position += margin+art_offset*margin*0.7
		region.size -= margin*2
	draw_texture_rect_region(Art.texture_for(data),art,region,Color(0.65,0.67,0.68) if spent else Color.WHITE)
	draw_set_transform(Vector2.ZERO)
	_title(str(data["name"]),14,Color("#f7eccd"))
	var state: String = "BERTAHAN" if defending else ("SELESAI" if spent else "SERANG")
	if not action_hint.is_empty() and not defending and not spent:
		state += " / "+action_hint
	var badge_width: float = minf(size.x-8,font.get_string_size(state,HORIZONTAL_ALIGNMENT_LEFT,-1,10).x+10)
	draw_rect(Rect2((size.x-badge_width)/2,111,badge_width,14),Color("#102938"))
	_text(state,122,10,accent)
	var base: Dictionary = Catalog.card(data["id"])
	for index in range(2):
		var stat: String = "atk" if index == 0 else "def"
		var value: String = "%s %d" % [stat.to_upper(),data[stat]]
		var color := Color("#9ce3bb") if data[stat] > base[stat] else (Color("#ffa4a4") if data[stat] < base[stat] else Color("#f7eccd"))
		var width: float = font.get_string_size(value,HORIZONTAL_ALIGNMENT_LEFT,-1,13).x
		draw_string(font,Vector2(size.x*(0.25+index*0.5)-width/2,140),value,HORIZONTAL_ALIGNMENT_LEFT,-1,13,color)
	if data.get("shield",false):
		draw_rect(Rect2(43,35,60,15),Color("#102938"))
		_text("PERISAI",47,10,Color("#a6d9de"))
	if data.get("piercing",false):
		draw_rect(Rect2(38,48,70,15),Color("#102938"))
		_text("MENEMBUS",60,10,Color("#f2dca9"))

func _inspect_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and allow_art_motion:
		art_offset = Vector2(clampf(event.position.x/maxf(1,size.x)*2-1,-1,1),clampf(event.position.y/maxf(1,size.y)*2-1,-1,1))
		queue_redraw()
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT and not data.is_empty():
		inspect_requested.emit(data.duplicate(true))
		accept_event()

func _box(rect: Rect2, bg: Color, edge: Color, width: int = 1, radius: int = 2) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = edge
	style.set_border_width_all(width)
	style.set_corner_radius_all(radius)
	style.shadow_color = Color(0,0,0,0.32)
	style.shadow_size = 3
	style.shadow_offset = Vector2(0,2)
	draw_style_box(style, rect)

func _text(value: String, y: float, fs: int, color: Color, centered: bool = true, inset: float = 8.0) -> void:
	var line: String = value
	var available: float = maxf(1.0,size.x-inset*2)
	for length in range(value.length(),-1,-1):
		line = value.left(length) + (String.chr(8230) if length < value.length() else "")
		if font.get_string_size(line,HORIZONTAL_ALIGNMENT_LEFT,-1,fs).x <= available:
			break
	var width: float = font.get_string_size(line,HORIZONTAL_ALIGNMENT_LEFT,-1,fs).x
	draw_string(font,Vector2((size.x-width)/2 if centered else inset,y),line,HORIZONTAL_ALIGNMENT_LEFT,available,fs,color)

func _title(value: String, fs: int, color: Color) -> void:
	var width: float = size.x-16
	if font.get_string_size(value,HORIZONTAL_ALIGNMENT_LEFT,-1,fs).x <= width:
		_text(value,21 if field_mode else (25 if not large else 34),fs,color)
		return
	var first: String = ""
	var second: String = ""
	for word in value.split(" "):
		var candidate: String = word if first.is_empty() else first+" "+word
		if second.is_empty() and font.get_string_size(candidate,HORIZONTAL_ALIGNMENT_LEFT,-1,fs).x <= width:
			first = candidate
		else:
			second = word if second.is_empty() else second+" "+word
	if first.is_empty():
		first = value
	_text(first,13 if field_mode else (18 if not large else 27),fs,color)
	_text(second,28 if field_mode else (35 if not large else 52),fs,color)

func _draw() -> void:
	if field_mode and not data.is_empty():
		_draw_field()
		return
	var gold := Color("#9a8053")
	var cyan := Color("#316d77")
	var hover: bool = is_hovered() and not disabled
	var outer := Rect2(Vector2.ZERO,size)
	if back:
		_box(outer,Color("#102938"),gold.darkened(0.3),1,7)
		var center: Vector2 = size/2
		var radius: float = minf(size.x,size.y)*0.31
		draw_arc(center,radius,0,TAU,48,gold,1.2,true)
		for i in range(4):
			var angle: float = i*PI/2
			draw_line(center+Vector2.from_angle(angle)*radius,center+Vector2.from_angle(angle+PI/2)*radius,gold,1,true)
		if size.y > 70:
			_text("ELDORIA",size.y-10,10,gold)
		return
	if data.is_empty():
		_box(outer,Color(0.07,0.15,0.20,0.85),Color("#dcc18b") if selected or hover else Color("#526265"),2 if selected else 1)
		var center: Vector2 = size/2-Vector2(0,9)
		draw_arc(center,22,0,TAU,48,Color("#476573"),1,true)
		draw_colored_polygon(PackedVector2Array([center+Vector2(0,-14),center+Vector2(14,0),center+Vector2(0,14),center+Vector2(-14,0)]),Color("#365362"))
		_text("PILIH ZONA" if selected else empty_caption,size.y-14,12,Color("#eddbb6") if selected else Color("#b0bdba"))
		return
	var trap: bool = data["kind"] == "trap"
	var spell: bool = data["kind"] != "monster"
	var edge: Color = Color("#946f94") if trap else (Color("#628379") if spell else gold)
	var spent: bool = data.get("attacked",false)
	var defending: bool = data.get("defending",false)
	if selected:
		for margin in [6,4]:
			var glow := StyleBoxFlat.new()
			glow.bg_color = Color.TRANSPARENT
			glow.border_color = Color(0.35,0.88,1.0,0.20 if margin == 6 else 0.45)
			glow.set_border_width_all(2)
			glow.set_corner_radius_all(5)
			draw_style_box(glow,Rect2(Vector2(-margin,-margin),size+Vector2(margin*2,margin*2)))
		_box(Rect2(Vector2(-2,-2),size+Vector2(4,4)),Color("#d3be91"),Color("#8defff"),2,3)
	_box(outer,Color("#ddd0dc") if trap else (Color("#d3dfd4") if spell else Color("#e7dec7")),Color("#f7eccd") if selected or hover else edge,2,2)
	var element_colors: Dictionary = {"CAHAYA":Color("#a28a54"),"API":Color("#b46c4d"),"BULAN":Color("#89819e"),"ALAM":Color("#618774"),"SPELL":Color("#64897b")}
	draw_rect(Rect2(5,4,maxf(1,size.x-10),2),element_colors.get(data["element"],edge))
	var title_size: int = (22 if size.x > 260 else 19) if large else 14
	_title(str(data["name"]),title_size,Color("#1d2b2d"))
	var title_bottom: float = 64 if large else 47
	var tag: String = ("TRAP" if trap else "SPELL") if spell else "%s / LV.%d" % [data["element"],data["level"]]
	if large:
		_text(tag,title_bottom,14,Color("#506458") if spell else Color("#65573c"))
	var art_top: float = title_bottom+8 if large else 39
	var art_bottom: float = size.y-(75 if large else 34)
	var art_rect := Rect2(7,art_top,maxf(1,size.x-14),maxf(1,art_bottom-art_top))
	var art_texture: Texture2D = Art.texture_for(data)
	var region: Rect2 = Art.region_for(data)
	var cell: Vector2 = region.size
	var ratio: float = art_rect.size.x/art_rect.size.y
	if ratio < 1:
		region.position.x += (cell.x-cell.x*ratio)/2
		region.size.x *= ratio
	else:
		var height: float = cell.y/ratio
		var focus: float = Art.focus_for(data)
		region.position.y += clampf(cell.y*focus-height/2,0,cell.y-height)
		region.size.y = height
	if hover and allow_art_motion:
		var margin: Vector2 = region.size*0.025
		region.position += margin+art_offset*margin*0.70
		region.size -= margin*2
	draw_texture_rect_region(art_texture,art_rect,region,Color(0.72,0.73,0.70) if spent else Color(0.96,0.94,0.89))
	if hover and allow_art_motion and not spent:
		# Foil is confined to the illustration, leaving the printed text still and clear.
		var bounds := PackedVector2Array([art_rect.position,Vector2(art_rect.end.x,art_rect.position.y),art_rect.end,Vector2(art_rect.position.x,art_rect.end.y)])
		var sweep: float = art_rect.position.x+art_rect.size.x*(0.5+art_offset.x*0.35)
		for i in range(5):
			var x: float = sweep+(i-2)*6
			var strip := PackedVector2Array([Vector2(x,art_rect.position.y),Vector2(x+7,art_rect.position.y),Vector2(x-18,art_rect.end.y),Vector2(x-25,art_rect.end.y)])
			for clipped in Geometry2D.intersect_polygons(bounds,strip):
				draw_colored_polygon(clipped,Color(0.91,0.95,1.0,0.035*(3-absi(i-2))))
	draw_rect(art_rect,edge.darkened(0.4),false,1)
	if size.x >= 100:
		draw_rect(Rect2(art_rect.position+Vector2(2,2),Vector2(20,20)),Color(0.91,0.88,0.78,0.96))
		Sigils.draw(self,str(data["id"]),art_rect.position+Vector2(12,12),7,Color("#334743"),0,1.2)
	if not action_hint.is_empty() and not large:
		var badge_y: float = art_bottom-17
		draw_rect(Rect2(8,badge_y,size.x-16,17),Color("#132c30"))
		_text(action_hint,badge_y+12,10,Color("#f3e5bb"))
	if spell:
		_text("TRAP / RESPONS" if trap else "SPELL / AKTIF",size.y-20,18 if large else 14,Color("#31584f"))
		return
	var stat_y: float = size.y-(45 if large else 15)
	var stat_size: int = 23 if large else 17
	var half: float = size.x/2
	draw_line(Vector2(half,art_bottom+6),Vector2(half,size.y-20),Color("#52616b"),1)
	var base: Dictionary = Catalog.card(data["id"])
	var da: int = int(data["atk"])-int(base["atk"])
	var dd: int = int(data["def"])-int(base["def"])
	var left: String = str(data["atk"])
	var right: String = str(data["def"])
	draw_string(font,Vector2(half/2-font.get_string_size(left,HORIZONTAL_ALIGNMENT_LEFT,-1,stat_size).x/2,stat_y),left,HORIZONTAL_ALIGNMENT_LEFT,-1,stat_size,Color("#206447") if da > 0 else (Color("#a22f35") if da < 0 else Color("#293237")))
	draw_string(font,Vector2(half+half/2-font.get_string_size(right,HORIZONTAL_ALIGNMENT_LEFT,-1,stat_size).x/2,stat_y),right,HORIZONTAL_ALIGNMENT_LEFT,-1,stat_size,Color("#206447") if dd > 0 else (Color("#a22f35") if dd < 0 else cyan))
	if large and (da != 0 or dd != 0):
		_text("Dari awal: ATK %+d / DEF %+d" % [da,dd],size.y-6,11,Color("#315b61"))
	var label_y: float = size.y-(27 if large else 2)
	draw_string(font,Vector2(half/2-11,label_y),"ATK",HORIZONTAL_ALIGNMENT_LEFT,-1,11,Color("#665841"))
	draw_string(font,Vector2(half+half/2-11,label_y),"DEF",HORIZONTAL_ALIGNMENT_LEFT,-1,11,Color("#315b61"))
	if data.has("defending"):
		var state: String = "BERTAHAN" if defending else ("SELESAI" if spent else "SERANG")
		var badge_color: Color = Color("#a6d9de") if defending else Color("#f2dca9")
		if large:
			var badge_y: float = art_bottom-22
			draw_rect(Rect2(8,badge_y,size.x-16,22),Color(0.025,0.07,0.10,0.96))
			_text(state+(" / PERISAI" if data.get("shield",false) else ""),badge_y+16,12,badge_color)
		else:
			var badge: String = "DEF" if defending else ("SELESAI" if spent else "ATK")
			var bw: float = font.get_string_size(badge,HORIZONTAL_ALIGNMENT_LEFT,-1,10).x+10
			draw_rect(Rect2(size.x-bw-7,art_top+2,bw,16),Color(0.025,0.07,0.10,0.96))
			draw_string(font,Vector2(size.x-bw-2,art_top+14),badge,HORIZONTAL_ALIGNMENT_LEFT,-1,10,badge_color)
			if data.get("piercing",false):
				draw_rect(Rect2(8,art_top+20,60,16),Color(0.025,0.07,0.10,0.96))
				draw_string(font,Vector2(10,art_top+32),"MENEMBUS",HORIZONTAL_ALIGNMENT_LEFT,-1,9,Color("#f5d68e"))
			if data.get("shield",false):
				draw_rect(Rect2(8,art_top+2,52,16),Color(0.025,0.07,0.10,0.96))
				draw_string(font,Vector2(10,art_top+14),"PERISAI",HORIZONTAL_ALIGNMENT_LEFT,-1,10,Color("#abd7da"))
