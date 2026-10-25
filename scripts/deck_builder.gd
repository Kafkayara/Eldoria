extends Control
const Catalog = preload("res://scripts/catalog.gd")
const CardView = preload("res://scripts/card_view.gd")
signal closed
signal saved
signal inspect_requested(card: Dictionary)
var store
var editing: String = "fajar"
var draft: Array = []
var chosen: String = "dawn"
var collection: ItemList
var deck_list: ItemList
var search: LineEdit
var title_edit: LineEdit
var counts: Label
var notice: Label
var preview
var text: RichTextLabel
var lore: RichTextLabel
var selector: OptionButton
var save_button: Button
var ids: Array = []
var deck_ids: Array = []
const INK = Color("#eff1ed")
const GOLD = Color("#c6ae7d")
func _place(node: Control, rect: Rect2) -> void:
	node.position = rect.position
	node.size = rect.size
	add_child(node)
func _label(value: String, rect: Rect2, fs: int = 18) -> Label:
	var node := Label.new()
	node.text = value
	node.add_theme_font_size_override("font_size",fs)
	_place(node,rect)
	return node
func _button(value: String, rect: Rect2, callback: Callable) -> Button:
	var node := Button.new()
	node.text = value
	node.pressed.connect(callback)
	_place(node,rect)
	return node
func _ready() -> void:
	var shade := ColorRect.new()
	shade.color = Color("#0b1720")
	_place(shade,Rect2(0,0,1280,720))
	_label("KOLEKSI & DECK BUILDER",Rect2(28,17,1000,43),30)
	_button("Kembali",Rect2(1090,22,160,39),func(): closed.emit())
	_label("Semua kartu terbuka: 3 salinan per jenis. Deck: 20 kartu, minimal 8 monster.",Rect2(28,65,1200,28),17)
	selector = OptionButton.new()
	_place(selector,Rect2(28,110,350,40))
	selector.item_selected.connect(func(index): load_deck(str(selector.get_item_metadata(index))))
	search = LineEdit.new()
	search.placeholder_text = "Cari koleksi / nama / efek..."
	_place(search,Rect2(28,166,350,39))
	search.text_changed.connect(func(_value): refresh())
	collection = ItemList.new()
	collection.add_theme_font_size_override("font_size",17)
	_style_list(collection)
	_place(collection,Rect2(28,217,350,391))
	collection.item_selected.connect(func(index): choose(ids[index]))
	collection.item_activated.connect(func(index): add_card(ids[index]))
	_button("+ Tambahkan kartu",Rect2(28,622,350,43),func(): add_card(chosen))
	preview = CardView.new()
	preview.large = true
	preview.disabled = true
	_place(preview,Rect2(412,112,270,280))
	_label("EFEK KARTU",Rect2(412,403,270,25),15).add_theme_color_override("font_color",Color("#8bb6b9"))
	text = RichTextLabel.new()
	text.bbcode_enabled = false
	text.add_theme_font_size_override("normal_font_size",18)
	_place(text,Rect2(412,433,270,86))
	_label("CERITA",Rect2(412,527,270,23),15).add_theme_color_override("font_color",GOLD)
	lore = RichTextLabel.new()
	lore.add_theme_font_size_override("normal_font_size",16)
	lore.add_theme_color_override("default_color",Color("#b2c7d2"))
	_place(lore,Rect2(412,555,270,55))
	_button("Perbesar kartu",Rect2(412,622,270,43),func(): inspect_requested.emit(Catalog.card(chosen)))
	title_edit = LineEdit.new()
	title_edit.max_length = 32
	_place(title_edit,Rect2(719,110,531,40))
	counts = _label("",Rect2(719,162,531,30),19)
	deck_list = ItemList.new()
	deck_list.add_theme_font_size_override("font_size",18)
	_style_list(deck_list)
	_place(deck_list,Rect2(719,204,531,346))
	deck_list.item_selected.connect(func(index): choose(deck_ids[index]))
	deck_list.item_activated.connect(func(index): remove_card(deck_ids[index]))
	_button("- Kurangi kartu terpilih",Rect2(719,561,531,40),func(): remove_card(chosen))
	save_button = _button("SIMPAN & GUNAKAN DECK",Rect2(719,622,531,43),save_draft)
	notice = _label("",Rect2(28,674,1222,32),16)
	notice.add_theme_color_override("font_color",GOLD)
	hide()
func show_builder(value) -> void:
	store = value
	selector.clear()
	var all: Dictionary = store.entries()
	for key in all:
		selector.add_item(all[key]["name"])
		selector.set_item_metadata(selector.item_count-1,key)
		if key == store.active: selector.select(selector.item_count-1)
	search.text = ""
	load_deck(store.active)
	show()
func load_deck(id: String) -> void:
	for i in range(selector.item_count):
		if selector.get_item_metadata(i) == id: selector.select(i)
	editing = id
	draft = store.cards(id)
	title_edit.text = store.entries()[id]["name"]
	refresh()
	choose(draft[0] if not draft.is_empty() else "dawn")
	notice.text = "Klik ganda koleksi untuk menambah; klik ganda isi deck untuk mengurangi."
func choose(id: String) -> void:
	chosen = id
	var card: Dictionary = Catalog.card(id)
	preview.data = card
	preview.queue_redraw()
	text.text = card["text"]
	text.scroll_to_line(0)
	lore.text = card["lore"]
	lore.scroll_to_line(0)
func refresh() -> void:
	ids.clear()
	collection.clear()
	var sorted: Array = Catalog.CARDS.keys()
	sorted.sort_custom(func(a,b): return Catalog.CARDS[a]["name"] < Catalog.CARDS[b]["name"])
	for id in sorted:
		var card: Dictionary = Catalog.card(id)
		if not search.text.is_empty() and not (card["name"]+" "+card["text"]).to_lower().contains(search.text.to_lower()): continue
		ids.append(id)
		collection.add_item("%s  [%d/3]" % [card["name"],draft.count(id)])
	deck_ids.clear()
	deck_list.clear()
	var types := {"monster":0,"spell":0,"trap":0}
	for id in sorted:
		var n: int = draft.count(id)
		if n == 0: continue
		deck_ids.append(id)
		var card: Dictionary = Catalog.card(id)
		types[card["kind"]] += n
		deck_list.add_item("%dx  %s  /  %s" % [n,card["name"],str(card["kind"]).to_upper()])
	counts.text = "%d/20  /  %d monster  /  %d spell  /  %d trap" % [draft.size(),types["monster"],types["spell"],types["trap"]]
	save_button.disabled = not Catalog.validate(draft).is_empty()
func add_card(id: String) -> void:
	if draft.size() >= 20:
		notice.text = "Deck sudah 20 kartu. Kurangi kartu terlebih dahulu."
		return
	if draft.count(id) >= 3:
		notice.text = "Maksimal 3 salinan kartu yang sama."
		return
	draft.append(id)
	refresh()
	choose(id)
	notice.text = Catalog.validate(draft)
func remove_card(id: String) -> void:
	if not draft.has(id):
		notice.text = "Kartu ini tidak ada dalam deck."
		return
	draft.erase(id)
	refresh()
	notice.text = Catalog.validate(draft)
func save_draft() -> void:
	var error: String = store.save_deck(editing,title_edit.text,draft)
	if not error.is_empty():
		notice.text = error
		return
	editing = store.active
	saved.emit()
	show_builder(store)
	notice.text = "Deck tersimpan di perangkat ini dan dipilih untuk duel berikutnya."

func _style_list(list: ItemList) -> void:
	list.add_theme_color_override("font_color",INK)
	list.add_theme_color_override("font_selected_color",Color("#fff0c9"))
	list.add_theme_constant_override("v_separation",8)
	var box := StyleBoxFlat.new()
	box.bg_color = Color("#13252d")
	box.border_color = Color("#435b66")
	box.set_border_width_all(1)
	box.content_margin_left = 9
	box.content_margin_top = 7
	list.add_theme_stylebox_override("panel",box)
	var selected := StyleBoxFlat.new()
	selected.bg_color = Color("#354b56")
	list.add_theme_stylebox_override("selected",selected)
	list.add_theme_stylebox_override("selected_focus",selected)
