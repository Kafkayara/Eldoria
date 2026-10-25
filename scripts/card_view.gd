extends Button
const ATLAS = preload("res://assets/art/eldoria_atlas.png")
var data: Dictionary = {}
var selected: bool = false
var back: bool = false
var empty_caption: String = "ZONA MONSTER"
var large: bool = false
var font: Font = ThemeDB.fallback_font

func _ready() -> void:
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	mouse_entered.connect(queue_redraw)
	mouse_exited.connect(queue_redraw)
	focus_entered.connect(queue_redraw)
	focus_exited.connect(queue_redraw)
	resized.connect(queue_redraw)

func _box(rect: Rect2, bg: Color, edge: Color, width: int = 1, radius: int = 8) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = edge
	style.set_border_width_all(width)
	style.set_corner_radius_all(radius)
	draw_style_box(style, rect)

func _text(value: String, y: float, fs: int, color: Color, centered: bool = true) -> void:
	var line: String = value
	var available: float = maxf(1.0, size.x - 16)
	# Bounded loop: text fitting must always terminate, even for narrow cards.
	for length in range(value.length(), -1, -1):
		line = value.left(length) + (String.chr(8230) if length < value.length() else "")
		if font.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x <= available:
			break
	var width: float = font.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
	draw_string(font, Vector2((size.x - width) / 2.0 if centered else 8.0, y), line, HORIZONTAL_ALIGNMENT_LEFT, available, fs, color)

func _draw() -> void:
	var gold := Color("#caaa70")
	var accent := Color("#72d7df")
	var hover: bool = is_hovered() and not disabled
	var outer := Rect2(Vector2.ZERO, size)
	if back:
		_box(outer, Color("#101e34"), gold.darkened(0.4), 1, 5)
		var center: Vector2 = size / 2
		draw_arc(center, minf(size.x, size.y) * 0.32, 0, TAU, 32, gold, 1.0, true)
		draw_line(center - Vector2(10, 0), center + Vector2(10, 0), gold, 1.0)
		draw_line(center - Vector2(0, 10), center + Vector2(0, 10), gold, 1.0)
		return
	if data.is_empty():
		_box(outer, Color(0.05, 0.11, 0.16, 0.8), accent if selected or hover else Color("#294451"), 2 if selected else 1)
		var center: Vector2 = size / 2
		draw_arc(center - Vector2(0, 8), 23, 0, TAU, 32, Color("#36505a"), 1.0, true)
		draw_colored_polygon(PackedVector2Array([center + Vector2(0,-25), center + Vector2(17,-8), center + Vector2(0,9), center + Vector2(-17,-8)]), Color("#263e48"))
		_text(empty_caption, size.y - 20, 11, Color("#72919e"))
		return
	var spell: bool = data["kind"] == "spell"
	var edge: Color = Color("#68cdb6") if spell else gold
	if selected:
		_box(Rect2(Vector2(-4,-4), size + Vector2(8,8)), Color(0.7,0.55,0.25,0.15), Color("#f4d59d"), 2, 10)
	_box(outer, Color("#101c29") if spell else Color("#211f25"), Color("#fff0cb") if hover else edge, 2)
	var fs: int = 19 if large else 12
	_text(str(data["name"]), size.y * 0.11 + 3, fs, Color("#fff2da"))
	var tag: String = "SPELL / MAGI" if spell else "%s / LV.%d" % [data["element"], data["level"]]
	_text(tag, size.y * 0.19, 11 if not large else 13, edge)
	var art_rect := Rect2(7, size.y * 0.23, size.x - 14, size.y * 0.53)
	var index: int = int(data["art"])
	var cell := Vector2(ATLAS.get_width() / 3.0, ATLAS.get_height() / 2.0)
	var region := Rect2(Vector2(index % 3, floori(index / 3.0)) * cell, cell)
	# Crop texture coordinates to keep the illustration proportions intact.
	var ratio: float = art_rect.size.x / art_rect.size.y
	if ratio < 1.0:
		region.position.x += (cell.x - cell.x * ratio) / 2.0
		region.size.x *= ratio
	else:
		region.position.y += (cell.y - cell.y / ratio) / 2.0
		region.size.y /= ratio
	draw_texture_rect_region(ATLAS, art_rect, region)
	draw_rect(art_rect, edge.darkened(0.35), false, 1.0)
	if spell:
		_text("AKTIFKAN", size.y * 0.89, 15 if large else 12, edge)
	else:
		var stats: String = "%d ATK   %d DEF" % [data["atk"], data["def"]] if size.x >= 140 else "%d / %d" % [data["atk"], data["def"]]
		_text(stats, size.y * 0.87, 16 if large else 11, Color("#f6e2be"))
		var state: String = "MONSTER"
		if data.has("defending"):
			state = "BERTAHAN" if data["defending"] else ("SUDAH MENYERANG" if data["attacked"] else "MENYERANG")
			if data.get("shield", false):
				state += " / AEGIS"
		_text(state, size.y * 0.96, 12 if large else 9, accent if data.get("defending", false) else edge)
