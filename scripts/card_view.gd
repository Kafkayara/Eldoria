extends Button
const Art = preload("res://scripts/card_art.gd")
const ATLAS = Art.ATLAS
signal inspect_requested(card_data: Dictionary)
var data: Dictionary = {}
var selected: bool = false
var back: bool = false
var empty_caption: String = "ZONA MONSTER"
var large: bool = false
var font: Font = ThemeDB.fallback_font

func _ready() -> void:
	font = get_theme_font("font")
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_entered.connect(queue_redraw)
	mouse_exited.connect(queue_redraw)
	focus_entered.connect(queue_redraw)
	focus_exited.connect(queue_redraw)
	resized.connect(queue_redraw)
	gui_input.connect(_inspect_input)

func _inspect_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT and not data.is_empty():
		inspect_requested.emit(data.duplicate(true))
		accept_event()

func _box(rect: Rect2, bg: Color, edge: Color, width: int = 1, radius: int = 8) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = edge
	style.set_border_width_all(width)
	style.set_corner_radius_all(radius)
	if selected:
		style.shadow_color = Color(0.9,0.7,0.3,0.13)
		style.shadow_size = 6
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
	var gold := Color("#dfbf81")
	var cyan := Color("#83dfec")
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
		_box(outer,Color(0.07,0.15,0.20,0.85),cyan if selected or hover else Color("#466575"),2 if selected else 1)
		var center: Vector2 = size/2-Vector2(0,9)
		draw_arc(center,22,0,TAU,48,Color("#476573"),1,true)
		draw_colored_polygon(PackedVector2Array([center+Vector2(0,-14),center+Vector2(14,0),center+Vector2(0,14),center+Vector2(-14,0)]),Color("#365362"))
		_text("PILIH ZONA" if selected else empty_caption,size.y-14,12,cyan if selected else Color("#a4bdc7"))
		return
	var spell: bool = data["kind"] == "spell"
	var edge: Color = Color("#79dfc5") if spell else gold
	var spent: bool = data.get("attacked",false)
	var defending: bool = data.get("defending",false)
	if selected:
		_box(Rect2(Vector2(-3,-3),size+Vector2(6,6)),Color(0.8,0.6,0.3,0.1),gold,2,10)
	_box(outer,Color("#112b2a") if spell else Color("#202631"),Color("#fff1c5") if selected or hover else edge,2)
	var title_size: int = (22 if size.x > 260 else 19) if large else 14
	_title(str(data["name"]),title_size,Color("#fff6df"))
	var title_bottom: float = 64 if large else 47
	var tag: String = "SPELL" if spell else "%s / LV.%d" % [data["element"],data["level"]]
	if large:
		_text(tag,title_bottom,14,edge)
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
	draw_texture_rect_region(art_texture,art_rect,region,Color(0.6,0.65,0.7) if spent else Color.WHITE)
	draw_rect(art_rect,edge.darkened(0.4),false,1)
	if spell:
		_text("SPELL / AKTIF",size.y-20,18 if large else 14,edge)
		return
	var stat_y: float = size.y-(45 if large else 15)
	var stat_size: int = 23 if large else 17
	var half: float = size.x/2
	draw_line(Vector2(half,art_bottom+6),Vector2(half,size.y-20),Color("#52616b"),1)
	var left: String = str(data["atk"])
	var right: String = str(data["def"])
	draw_string(font,Vector2(half/2-font.get_string_size(left,HORIZONTAL_ALIGNMENT_LEFT,-1,stat_size).x/2,stat_y),left,HORIZONTAL_ALIGNMENT_LEFT,-1,stat_size,Color("#fff0ce"))
	draw_string(font,Vector2(half+half/2-font.get_string_size(right,HORIZONTAL_ALIGNMENT_LEFT,-1,stat_size).x/2,stat_y),right,HORIZONTAL_ALIGNMENT_LEFT,-1,stat_size,cyan)
	var label_y: float = size.y-(27 if large else 2)
	draw_string(font,Vector2(half/2-11,label_y),"ATK",HORIZONTAL_ALIGNMENT_LEFT,-1,11,Color("#e2c898"))
	draw_string(font,Vector2(half+half/2-11,label_y),"DEF",HORIZONTAL_ALIGNMENT_LEFT,-1,11,Color("#9ed9e4"))
	if data.has("defending"):
		var state: String = "BERTAHAN" if defending else ("SELESAI" if spent else "SERANG")
		var badge_color: Color = cyan if defending else gold
		if large:
			var badge_y: float = art_bottom-22
			draw_rect(Rect2(8,badge_y,size.x-16,22),Color(0.025,0.07,0.10,0.96))
			_text(state+(" / PERISAI" if data.get("shield",false) else ""),badge_y+16,12,badge_color)
		else:
			var badge: String = "DEF" if defending else ("SELESAI" if spent else "ATK")
			var bw: float = font.get_string_size(badge,HORIZONTAL_ALIGNMENT_LEFT,-1,10).x+10
			draw_rect(Rect2(size.x-bw-7,art_top+2,bw,16),Color(0.025,0.07,0.10,0.96))
			draw_string(font,Vector2(size.x-bw-2,art_top+14),badge,HORIZONTAL_ALIGNMENT_LEFT,-1,10,badge_color)
			if data.get("shield",false):
				draw_rect(Rect2(8,art_top+2,38,16),Color(0.025,0.07,0.10,0.96))
				draw_string(font,Vector2(10,art_top+14),"AEGIS",HORIZONTAL_ALIGNMENT_LEFT,-1,10,cyan)
