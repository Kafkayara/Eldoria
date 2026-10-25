extends Control
const Catalog = preload("res://scripts/catalog.gd")
const CardView = preload("res://scripts/card_view.gd")
const GOLD = Color("#dfbf81")
const LIGHT = Color("#f2f4ee")
const MUTED = Color("#b2c7d2")
const CYAN = Color("#83dfec")

signal closed
signal inspect_requested(card: Dictionary)

var selected_card: Dictionary = {}
var visible_ids: Array[String] = []
var tiles: Dictionary = {}
var query: String = ""
var category: String = ""
var search_box: LineEdit
var filter_buttons: Dictionary = {}
var summary: Label
var preview
var card_type: Label
var description: RichTextLabel
var detail_button: Button
var scroll: ScrollContainer
var grid: GridContainer
var empty_state: Label

func _ready() -> void:
	_build()
	_refresh_cards()

func _draw() -> void:
	draw_rect(Rect2(0,0,1280,720),Color("#0b1725"))
	for i in range(40):
		var a: float = 0.04*(1-i/40.0)
		draw_arc(Vector2(1130,55),60+i*5,0,TAU,64,Color(0.8,0.66,0.4,a),1,true)
	draw_line(Vector2(22,79),Vector2(1258,79),Color("#425563"),1,true)

func _box(bg: Color, edge: Color, radius: int = 8) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = edge
	style.set_border_width_all(1)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 12
	style.content_margin_right = 12
	return style

func _place(node: Control, parent: Node, rect: Rect2) -> void:
	parent.add_child(node)
	node.position = rect.position
	node.size = rect.size

func _label(parent: Node, value: String, rect: Rect2, fs: int = 17, color: Color = LIGHT) -> Label:
	var node := Label.new()
	node.text = value
	node.add_theme_font_size_override("font_size",fs)
	node.add_theme_color_override("font_color",color)
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(node,parent,rect)
	return node

func _button(parent: Node, value: String, rect: Rect2, callback: Callable) -> Button:
	var node := Button.new()
	node.text = value
	node.add_theme_font_size_override("font_size",16)
	node.add_theme_color_override("font_color",LIGHT)
	node.add_theme_color_override("font_hover_color",GOLD)
	node.add_theme_color_override("font_pressed_color",GOLD)
	node.add_theme_stylebox_override("normal",_box(Color("#172d3c"),Color("#526c79")))
	node.add_theme_stylebox_override("hover",_box(Color("#234453"),GOLD))
	node.add_theme_stylebox_override("pressed",_box(Color("#344637"),GOLD))
	node.add_theme_stylebox_override("focus",_box(Color(0,0,0,0),CYAN))
	node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	node.pressed.connect(callback)
	_place(node,parent,rect)
	return node

func _build() -> void:
	_label(self,"GALERI KARTU",Rect2(23,14,580,39),30,GOLD)
	_label(self,"KODEKS ELDORIA / Pelajari kartu sebelum memasuki arena.",Rect2(25,54,880,23),15,MUTED)
	_button(self,"Kembali ke menu",Rect2(1064,22,194,42),func(): closed.emit())
	var panel := Panel.new()
	panel.add_theme_stylebox_override("panel",_box(Color("#101f2c"),Color("#536b74"),10))
	_place(panel,self,Rect2(22,95,280,604))
	_label(self,"KARTU TERPILIH",Rect2(42,111,240,24),15,GOLD)
	preview = CardView.new()
	preview.large = true
	preview.disabled = true
	preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview.empty_caption = "PILIH KARTU"
	_place(preview,self,Rect2(42,151,240,309))
	card_type = _label(self,"",Rect2(42,475,240,28),15,CYAN)
	description = RichTextLabel.new()
	description.add_theme_font_size_override("normal_font_size",18)
	description.add_theme_color_override("default_color",LIGHT)
	_place(description,self,Rect2(42,514,240,114))
	detail_button = _button(self,"BUKA DETAIL / E",Rect2(42,644,240,38),inspect_selected)
	search_box = LineEdit.new()
	search_box.placeholder_text = "Cari nama, elemen, atau efek..."
	search_box.add_theme_font_size_override("font_size",17)
	search_box.add_theme_color_override("font_color",LIGHT)
	search_box.add_theme_color_override("font_placeholder_color",MUTED)
	search_box.add_theme_stylebox_override("normal",_box(Color("#142936"),Color("#526c79")))
	search_box.add_theme_stylebox_override("focus",_box(Color("#1b3442"),CYAN))
	_place(search_box,self,Rect2(324,96,433,42))
	search_box.text_changed.connect(_search_changed)
	var categories: Array = [["","Semua"],["monster","Monster"],["spell","Spell"]]
	for index in range(categories.size()):
		var item: Array = categories[index]
		var button := _button(self,item[1],Rect2(773+164*index,96,152,42),set_category.bind(item[0]))
		button.toggle_mode = true
		filter_buttons[item[0]] = button
	summary = _label(self,"",Rect2(324,150,934,25),16,MUTED)
	scroll = ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	_place(scroll,self,Rect2(322,190,938,502))
	grid = GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation",14)
	grid.add_theme_constant_override("v_separation",18)
	scroll.add_child(grid)
	empty_state = _label(self,"Tidak ada kartu yang cocok.\nCoba kata kunci lain atau pilih Semua.",Rect2(402,304,776,120),23,MUTED)
	empty_state.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	empty_state.hide()

func show_library() -> void:
	query = ""
	category = ""
	search_box.text = ""
	_refresh_cards()
	show()

func _search_changed(value: String) -> void:
	query = value.strip_edges().to_lower()
	_refresh_cards()

func set_category(value: String) -> void:
	category = value
	_refresh_cards()

func _refresh_cards() -> void:
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()
	visible_ids.clear()
	tiles.clear()
	var sorted_ids: Array = Catalog.CARDS.keys()
	sorted_ids.sort_custom(func(a,b): return str(Catalog.CARDS[a]["name"]).nocasecmp_to(str(Catalog.CARDS[b]["name"])) < 0)
	for id in sorted_ids:
		var card: Dictionary = Catalog.card(id)
		if not category.is_empty() and card["kind"] != category:
			continue
		var searchable: String = "%s %s %s %s %s" % [card["id"],card["name"],card["element"],card["kind"],card["text"]]
		if not query.is_empty() and not searchable.to_lower().contains(query):
			continue
		visible_ids.append(id)
		var view := CardView.new()
		view.large = true
		view.data = card
		view.custom_minimum_size = Vector2(218,280)
		view.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		view.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		grid.add_child(view)
		view.pressed.connect(select_card.bind(id))
		view.inspect_requested.connect(func(data): inspect_requested.emit(data))
		view.gui_input.connect(_tile_input.bind(id))
		tiles[id] = view
	for key in filter_buttons:
		filter_buttons[key].set_pressed_no_signal(key == category)
	var monster_count: int = 0
	var spell_count: int = 0
	for card in Catalog.CARDS.values():
		if card["kind"] == "monster":
			monster_count += 1
		else:
			spell_count += 1
	summary.text = "%d dari %d kartu / %d monster + %d spell / Klik kartu untuk detail." % [visible_ids.size(),Catalog.CARDS.size(),monster_count,spell_count]
	empty_state.visible = visible_ids.is_empty()
	scroll.visible = not visible_ids.is_empty()
	scroll.set_deferred("scroll_vertical",0)
	if visible_ids.is_empty():
		selected_card = {}
		preview.data = {}
		preview.queue_redraw()
		card_type.text = "TIDAK ADA HASIL"
		description.text = "Coba kata kunci lain, atau pilih kategori Semua."
		detail_button.disabled = true
		return
	var chosen_id: String = str(selected_card.get("id",""))
	select_card(chosen_id if visible_ids.has(chosen_id) else visible_ids[0])

func select_card(id: String) -> void:
	if not visible_ids.has(id):
		return
	selected_card = Catalog.card(id)
	preview.data = selected_card
	preview.queue_redraw()
	card_type.text = "SPELL / MAGI AKTIF" if selected_card["kind"] == "spell" else "%s / LEVEL %d" % [selected_card["element"],selected_card["level"]]
	description.text = selected_card["text"]
	detail_button.disabled = false
	for key in tiles:
		tiles[key].selected = key == id
		tiles[key].queue_redraw()

func inspect_selected() -> void:
	if not selected_card.is_empty():
		inspect_requested.emit(selected_card.duplicate(true))

func _tile_input(event: InputEvent, id: String) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
		select_card(id)
		inspect_selected()
		accept_event()

