extends Button
const Catalog = preload("res://scripts/catalog.gd")
const Art = preload("res://scripts/card_art.gd")
const Sigils = preload("res://scripts/sigils.gd")
const ATLAS = Art.ATLAS
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
		_text(value,25 if not large else 34,fs,color)
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
	_text(first,18 if not large else 27,fs,color)
	_text(second,35 if not large else 52,fs,color)

func _draw() -> void:
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
		_box(Rect2(Vector2(-3,-3),size+Vector2(6,6)),Color("#d3be91"),Color("#fff0c9"),1,3)
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
