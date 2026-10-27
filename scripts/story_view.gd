extends Control
var Data = preload("res://scripts/story_data.gd")
var book_two_unlocked: bool = false
const Flow = preload("res://scripts/story_flow.gd")
const Art = preload("res://scripts/card_art.gd")
const Catalog = preload("res://scripts/catalog.gd")

const GOLD = Color("#d3bc8d")
const LIGHT = Color("#f3f0e7")
const MUTED = Color("#b3c5c9")
signal play_requested(config: Dictionary)
signal progress_changed(progress: Dictionary)
signal leave_requested
signal book_requested(id: String)
signal settings_requested
var progress: Dictionary = {}
var hub: Control
var dialogue: Control
var journal: Control
var chapter_buttons: Array = []
var chapter_title: Label
var speaker: Label
var body: RichTextLabel
var page_counter: Label
var next_button: Button
var previous_button: Button
var choice_buttons: Array = []
var resume_button: Button
var hub_status: Label
var save_notice: Label
var journal_body: RichTextLabel
var scene_image: TextureRect
func _ready() -> void:
	progress = Flow.initial(Data)
	_build()
	hide()
func _place(node: Control, parent: Node, rect: Rect2) -> void:
	parent.add_child(node)
	node.position = rect.position
	node.size = rect.size
func _label(parent: Node, value: String, rect: Rect2, fs: int = 18, color: Color = LIGHT) -> Label:
	var node := Label.new()
	node.text = value
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.add_theme_font_size_override("font_size",fs)
	node.add_theme_color_override("font_color",color)
	_place(node,parent,rect)
	return node
func _panel(parent: Node, rect: Rect2) -> void:
	var node := Panel.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.025,0.045,0.055,.97)
	style.border_color = Color("#776a51")
	style.set_border_width_all(1)
	style.set_corner_radius_all(3)
	node.add_theme_stylebox_override("panel",style)
	_place(node,parent,rect)
func _button(parent: Node, text: String, rect: Rect2, callback: Callable, primary: bool = false) -> Button:
	var node := Button.new()
	node.text = text
	node.add_theme_font_size_override("font_size",16)
	for entry in ["normal","hover","pressed","disabled"]:
		var box := StyleBoxFlat.new()
		box.bg_color = Color("#b9a47e") if primary else Color("#172e38")
		if entry == "hover": box.bg_color = box.bg_color.lightened(.12)
		if entry == "disabled": box.bg_color = Color("#182127")
		box.border_color = GOLD if primary else Color("#49636b")
		box.set_border_width_all(1)
		box.set_corner_radius_all(3)
		node.add_theme_stylebox_override(entry,box)
	node.add_theme_color_override("font_color",Color("#152024") if primary else LIGHT)
	node.add_theme_color_override("font_disabled_color",Color("#73878c"))
	for entry in ["font_hover_color","font_pressed_color"]: node.add_theme_color_override(entry,Color("#152024") if primary else LIGHT)
	_place(node,parent,rect)
	node.pressed.connect(callback)
	return node
func _rich(parent: Node, rect: Rect2, fs: int) -> RichTextLabel:
	var node := RichTextLabel.new()
	node.add_theme_font_size_override("normal_font_size",fs)
	node.add_theme_color_override("default_color",LIGHT)
	_place(node,parent,rect)
	return node
func _build() -> void:
	var bg := TextureRect.new()
	bg.texture = load(Data.BACKGROUND)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.modulate = Color(.65,.70,.76)
	_place(bg,self,Rect2(0,0,1280,720))
	hub = Control.new()
	_place(hub,self,Rect2(0,0,1280,720))
	_panel(hub,Rect2(24,24,650,672))
	_label(hub,"BUKU %s / KISAH ELDORIA" % Data.BOOK_NUMBER,Rect2(48,42,600,25),15,GOLD)
	_label(hub,Data.TITLE,Rect2(48,78,600,82),33)
	hub_status = _label(hub,"",Rect2(48,164,600,44),16,MUTED)
	for i in range(Data.CHAPTERS.size()):
		var button := _button(hub,"",Rect2(48,219+i*68,600,57),select_chapter.bind(i))
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		chapter_buttons.append(button)
	resume_button = _button(hub,"LANJUTKAN",Rect2(48,575,600,46),resume_story,true)
	save_notice = _label(hub,"Dialog dan bab tersimpan otomatis. Duel yang terputus dimulai ulang.",Rect2(48,634,600,46),14,MUTED)
	_button(hub,"Menu utama",Rect2(1035,30,220,40),func(): leave_requested.emit())
	_button(hub,"Pengaturan",Rect2(795,30,220,40),func(): settings_requested.emit())
	_button(hub,"Buku I",Rect2(750,320,218,40),func(): book_requested.emit("jendela_pagi"))
	var second := _button(hub,"Buku II / Rimba",Rect2(982,320,248,40),func(): book_requested.emit("akar_esok"))
	second.disabled = not book_two_unlocked
	_label(hub,"Progres setiap buku disimpan terpisah." if book_two_unlocked else "Buku II terbuka setelah lima bab Buku I selesai.",Rect2(750,374,480,28),14,MUTED)
	_button(hub,"Catatan kenangan",Rect2(810,629,420,46),open_journal)
	_panel(hub,Rect2(748,420,482,180))
	_label(hub,"KAMU MEMAINKAN AREN",Rect2(772,441,434,25),16,GOLD)
	_label(hub,Data.PREMISE,Rect2(772,482,434,95),19)
	dialogue = Control.new()
	_place(dialogue,self,Rect2(0,0,1280,720))
	_panel(dialogue,Rect2(24,87,1232,609))
	chapter_title = _label(dialogue,"",Rect2(40,24,900,44),24,GOLD)
	_button(dialogue,"Bab / Jeda",Rect2(1071,25,185,41),show_hub)
	_panel(dialogue,Rect2(46,111,266,555))
	scene_image = TextureRect.new()
	scene_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	scene_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_place(scene_image,dialogue,Rect2(58,125,242,355))
	_label(dialogue,"LAMBANG KENANGAN",Rect2(62,499,234,25),14,GOLD)
	_label(dialogue,"Setiap kartu menyimpan kenangan yang pernah kita bawa.",Rect2(62,540,226,102),17,MUTED)
	speaker = _label(dialogue,"",Rect2(348,121,864,42),27,GOLD)
	body = _rich(dialogue,Rect2(348,181,864,278),25)
	body.selection_enabled = true
	for i in range(2):
		var button := _button(dialogue,"",Rect2(348,477+i*55,864,46),choose.bind(i))
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		choice_buttons.append(button)
	previous_button = _button(dialogue,"Sebelumnya",Rect2(348,610,180,44),previous_page)
	page_counter = _label(dialogue,"",Rect2(548,618,340,28),15,MUTED)
	next_button = _button(dialogue,"LANJUT",Rect2(962,610,250,44),advance,true)
	dialogue.hide()
	journal = Control.new()
	_place(journal,self,Rect2(0,0,1280,720))
	_panel(journal,Rect2(230,64,820,592))
	_label(journal,"Catatan kenangan",Rect2(266,90,748,44),29,GOLD)
	journal_body = _rich(journal,Rect2(266,160,748,387),21)
	_button(journal,"KEMBALI",Rect2(266,579,748,43),func(): journal.hide())
	journal.hide()
func open_book(saved: Dictionary) -> void:
	progress = Flow.clean(saved,Data)
	show()
	show_hub()
func commit() -> void:
	progress = Flow.clean(progress,Data)
	progress_changed.emit(progress.duplicate(true))
func show_hub() -> void:
	journal.hide()
	dialogue.hide()
	hub.show()
	var done: int = progress["cleared"]
	hub_status.text = "%d / %d bab selesai. Kamu bisa membaca ulang bab yang telah terbuka." % [done,Data.CHAPTERS.size()]
	for i in range(chapter_buttons.size()):
		var unlocked: bool = i <= done
		chapter_buttons[i].disabled = not unlocked
		chapter_buttons[i].text = "%02d  %s%s" % [i+1,Data.CHAPTERS[i]["title"] if unlocked else "Belum terbuka","  / SELESAI" if i < done else ""]
	resume_button.text = "BACA EPILOG" if progress["phase"] == "complete" else ("LANJUTKAN KISAH" if progress["started"] else "MULAI KISAH")
func select_chapter(index: int) -> void:
	if index < 0 or index >= Data.CHAPTERS.size() or index > int(progress["cleared"]): return
	progress.merge({"chapter":index,"phase":"intro","line":0,"started":true},true)
	commit()
	show_page()
func resume_story() -> void:
	progress["started"] = true
	if progress["phase"] == "duel":
		request_duel()
		return
	if progress["phase"] == "complete": progress.merge({"phase":"ending","line":0},true)
	commit()
	show_page()
func current_config() -> Dictionary:
	return Data.CHAPTERS[progress["chapter"]].duplicate(true)
func show_page() -> void:
	hub.hide()
	journal.hide()
	dialogue.show()
	var chapter: Dictionary = current_config()
	var lines: Array = Flow.pages(progress,Data)
	if lines.is_empty(): show_hub(); return
	var page: Dictionary = lines[progress["line"]]
	chapter_title.text = "EPILOG / %s" % Data.TITLE if progress["phase"] == "ending" else "BAB %d / %s" % [progress["chapter"]+1,chapter["title"]]
	speaker.text = page["speaker"]
	body.text = Flow.page_text(page,progress)
	body.scroll_to_line(0)
	page_counter.text = "%d / %d  •  baca sesuai waktumu" % [progress["line"]+1,lines.size()]
	previous_button.disabled = progress["line"] == 0
	for i in range(choice_buttons.size()):
		choice_buttons[i].visible = page.has("options") and i < page.get("options",[]).size()
		if choice_buttons[i].visible: choice_buttons[i].text = page["options"][i]["text"]
	next_button.disabled = page.has("options")
	next_button.text = "LANJUT"
	if progress["line"] == lines.size()-1:
		match progress["phase"]:
			"intro": next_button.text = "MENUJU DUEL"
			"loss": next_button.text = "COBA LAGI"
			"win": next_button.text = "BACA EPILOG" if progress["chapter"] == Data.CHAPTERS.size()-1 else "BAB BERIKUTNYA"
			"ending": next_button.text = "BUKU %s TAMAT" % Data.BOOK_NUMBER
	var ids: Array = Data.SCENE_CARDS
	var c: Dictionary = Catalog.card(ids[progress["chapter"]])
	var texture := AtlasTexture.new()
	texture.atlas = Art.texture_for(c)
	texture.region = Art.region_for(c)
	scene_image.texture = texture
func previous_page() -> void:
	if not dialogue.visible or progress["line"] <= 0: return
	progress["line"] -= 1
	commit()
	show_page()
func choose(index: int) -> void:
	var lines: Array = Flow.pages(progress,Data)
	if lines.is_empty(): return
	var page: Dictionary = lines[progress["line"]]
	if not page.has("options") or index < 0 or index >= page["options"].size(): return
	progress["choices"][page["choice"]] = page["options"][index]["value"]
	advance(true)
func advance(chosen: bool = false) -> void:
	if not dialogue.visible or journal.visible: return
	var lines: Array = Flow.pages(progress,Data)
	if lines.is_empty(): return
	if lines[progress["line"]].has("options") and not chosen: return
	if progress["line"] < lines.size()-1:
		progress["line"] += 1
		commit()
		show_page()
		return
	match progress["phase"]:
		"intro","loss": request_duel()
		"win":
			if progress["chapter"] < Data.CHAPTERS.size()-1: progress.merge({"chapter":progress["chapter"]+1,"phase":"intro","line":0},true)
			else: progress.merge({"phase":"ending","line":0},true)
			commit()
			show_page()
		"ending":
			progress.merge({"phase":"complete","line":0},true)
			commit()
			show_hub()
func request_duel() -> void:
	progress.merge({"phase":"duel","line":0,"started":true},true)
	commit()
	play_requested.emit(current_config())
func finish_duel(won: bool) -> void:
	if progress["phase"] != "duel": return
	if won: progress["cleared"] = maxi(progress["cleared"],progress["chapter"]+1)
	progress.merge({"phase":"win" if won else "loss","line":0},true)
	commit()
	show()
	show_page()
func open_journal() -> void:
	var text: String = "Kenangan dibuka setelah bab selesai.\n\n"
	for i in range(progress["cleared"]): text += "%02d / %s\n%s\n\n" % [i+1,Data.CHAPTERS[i]["title"],Data.CHAPTERS[i]["memory"]]
	if progress["cleared"] == 0: text += "Belum ada catatan. Mulai kisah dari bab pertama."
	journal_body.text = text
	journal_body.scroll_to_line(0)
	journal.show()
func handle_key(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if journal.visible: journal.hide()
		elif dialogue.visible: show_hub()
		else: leave_requested.emit()
	elif event is InputEventKey and event.pressed and not event.echo and event.keycode in [KEY_ENTER,KEY_SPACE] and dialogue.visible:
		advance()

func configure_book(book, unlocked: bool) -> void:
	Data = book
	book_two_unlocked = unlocked
	for child in get_children():
		remove_child(child)
		child.queue_free()
	chapter_buttons.clear()
	choice_buttons.clear()
	_build()
