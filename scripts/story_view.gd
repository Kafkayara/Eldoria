extends Control
var Data = preload("res://scripts/story_data.gd")
var book_two_unlocked: bool = false
const Stage = preload("res://scripts/vn_stage.gd")
const Cast = preload("res://scripts/vn_cast.gd")
const Prefs = preload("res://scripts/vn_preferences.gd")
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
signal reader_preferences_changed(value: Dictionary)
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
var reader
var reader_preferences: Dictionary = Prefs.clean({})
var external_known: Array = []
var reader_blocked: Callable
var reduced_motion: bool = false
var roster_from_hub: bool = false
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
	_button(hub,"Tokoh dan hubungan",Rect2(795,98,460,40),open_people)
	_button(hub,"Buku I",Rect2(750,320,218,40),func(): book_requested.emit("jendela_pagi"))
	var second := _button(hub,"Buku II / Rimba",Rect2(982,320,248,40),func(): book_requested.emit("akar_esok"))
	second.disabled = not book_two_unlocked
	_label(hub,"Progres setiap buku disimpan terpisah." if book_two_unlocked else "Buku II terbuka setelah lima bab Buku I selesai.",Rect2(750,374,480,28),14,MUTED)
	_button(hub,"Catatan kenangan",Rect2(810,629,420,46),open_journal)
	_panel(hub,Rect2(748,420,482,180))
	_label(hub,"KAMU MEMAINKAN AREN",Rect2(772,441,434,25),16,GOLD)
	_label(hub,Data.PREMISE,Rect2(772,482,434,95),19)
	dialogue = Stage.new()
	_place(dialogue,self,Rect2(0,0,1280,720))
	reader = dialogue
	reader.apply_preferences(reader_preferences)
	reader.blocked = reader_blocked
	reader.reduced_motion = reduced_motion
	speaker = reader.speaker
	body = reader.body
	chapter_title = reader.chapter_title
	next_button = reader.next_button
	previous_button = reader.previous_button
	choice_buttons.assign(reader.choice_buttons)
	reader.next_requested.connect(advance)
	reader.back_requested.connect(previous_page)
	reader.choice_requested.connect(choose)
	reader.hub_requested.connect(show_hub)
	reader.line_revealed.connect(_remember_line)
	reader.context_requested.connect(open_context)
	reader.preferences_changed.connect(func(value): reader_preferences = value.duplicate(); reader_preferences_changed.emit(value))
	reader.modal_closed.connect(func():
		if roster_from_hub: roster_from_hub = false; dialogue.hide())
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
	var lines: Array = Flow.pages(progress,Data)
	progress["page_id"] = lines[progress["line"]]["id"] if not lines.is_empty() else ""
	progress = Flow.clean(progress,Data)
	progress_changed.emit(progress.duplicate(true))
func show_hub() -> void:
	if is_instance_valid(reader): reader.stop_auto()
	journal.hide()
	dialogue.hide()
	hub.show()
	var done: int = progress["cleared"]
	hub_status.text = "%d / %d bab selesai. Kamu bisa membaca ulang bab yang telah terbuka." % [done,Data.CHAPTERS.size()]
	for i in range(chapter_buttons.size()):
		var unlocked: bool = i <= done
		chapter_buttons[i].disabled = not unlocked
		chapter_buttons[i].text = "%02d  %s%s" % [i+1,Data.CHAPTERS[i]["title"] if unlocked else "Belum terbuka","  / SELESAI" if i < done else ""]
	if progress.get("migration",false): save_notice.text = "Naskah diperbarui. Bab dan pilihan tetap; adegan lama dibuka dari awal. Baca ulang Bab 1 untuk pengantar baru."
	resume_button.text = "BACA EPILOG" if progress["phase"] == "complete" else ("LANJUTKAN KISAH" if progress["started"] else "MULAI KISAH")
func select_chapter(index: int) -> void:
	if index < 0 or index >= Data.CHAPTERS.size() or index > int(progress["cleared"]): return
	progress.merge({"chapter":index,"phase":"intro","line":0,"started":true},true)
	commit()
	show_page()
func resume_story() -> void:
	progress["migration"] = false
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
	roster_from_hub = false
	hub.hide()
	journal.hide()
	dialogue.show()
	var chapter: Dictionary = current_config()
	var lines: Array = Flow.pages(progress,Data)
	if lines.is_empty(): show_hub(); return
	var page: Dictionary = lines[progress["line"]]
	for id in page.get("cast",[]):
		if not progress["known"].has(id): progress["known"].append(id)
	var who: String = Cast.id_for(page["speaker"])
	if not who.is_empty() and not progress["known"].has(who): progress["known"].append(who)
	commit()
	var title: String = "EPILOG / %s" % Data.TITLE if progress["phase"] == "ending" else "BUKU %s / BAB %d / %s" % [Data.BOOK_NUMBER,progress["chapter"]+1,chapter["title"]]
	var next_text := "LANJUT"
	var boundary: bool = progress["line"] == lines.size()-1
	if boundary:
		match progress["phase"]:
			"intro": next_text = "MENUJU DUEL"
			"loss": next_text = "COBA LAGI"
			"win": next_text = "BACA EPILOG" if progress["chapter"] == Data.CHAPTERS.size()-1 else "BAB BERIKUTNYA"
			"ending": next_text = "BUKU %s TAMAT" % Data.BOOK_NUMBER
	reader.show_page(page,progress,title,next_text,known_people(),boundary)

func known_people() -> Array:
	var result: Array = progress.get("known",["aren"]).duplicate()
	for id in external_known:
		if Cast.PEOPLE.has(id) and not result.has(id): result.append(id)
	return result

func _remember_line() -> void:
	var lines: Array = Flow.pages(progress,Data)
	if lines.is_empty(): return
	var page: Dictionary = lines[progress["line"]]
	var key: String = Flow.read_key(page,progress)
	if not progress["read"].has(key): progress["read"].append(key)
	var entry := {"page":page["id"],"who":reader.speaker.text,"text":Flow.page_text(page,progress)}
	if progress["history"].is_empty() or progress["history"].back() != entry:
		progress["history"].append(entry)
		if progress["history"].size() > 80: progress["history"].pop_front()
	commit()
	reader.state = progress.duplicate(true)

func open_people() -> void:
	roster_from_hub = hub.visible
	dialogue.show()
	reader.open_people(known_people())

func open_context() -> void:
	var cfg: Dictionary = current_config()
	reader.show_info("Tujuan dan konteks bab", "TEMPAT\n"+cfg["place"]+"\n\nTUJUAN AREN\n"+cfg["goal"]+"\n\nMENGAPA ADA DUEL\n"+cfg["why_duel"]+"\n\nDECK\n"+cfg["player_deck"].to_upper()+" melawan "+cfg["enemy_deck"].to_upper())

func reveal_all() -> void:
	reader.reveal_all()

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
	if dialogue.visible and reader.handle_key(event): return
	if event.is_action_pressed("ui_cancel"):
		if journal.visible: journal.hide()
		elif dialogue.visible: show_hub()
		else: leave_requested.emit()

func configure_book(book, unlocked: bool) -> void:
	Data = book
	book_two_unlocked = unlocked
	for child in get_children():
		remove_child(child)
		child.queue_free()
	chapter_buttons.clear()
	choice_buttons.clear()
	_build()

func apply_reader_preferences(value: Dictionary, reduced: bool) -> void:
	reader_preferences = Prefs.clean(value)
	reduced_motion = reduced
	if is_instance_valid(reader):
		reader.apply_preferences(reader_preferences)
		reader.reduced_motion = reduced

func set_save_status(ok: bool) -> void:
	if is_instance_valid(reader):
		reader.stamp.text = "Tersimpan" if ok else "Belum tersimpan"
		reader.stamp.add_theme_color_override("font_color",Color("#a8c8b5") if ok else Color("#edb3a5"))
