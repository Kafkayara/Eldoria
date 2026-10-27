extends Control
const Cast = preload("res://scripts/vn_cast.gd")
const Flow = preload("res://scripts/story_flow.gd")
const Prefs = preload("res://scripts/vn_preferences.gd")
const GOLD = Color("#d6bd8d")
const LIGHT = Color("#f4f1e7")
const LOCATIONS = {"kitchen_night":"Rumah Liora / Malam kepulangan Aren","kitchen_day":"Rumah Liora / Dapur keluarga","archive":"Observatorium / Ruang arsip","tower":"Suaka / Ruang perekam kenangan","tower_dawn":"Suaka / Setelah inti dimatikan","garden":"Kebun utara / Jalan dan saluran air","garden_restored":"Kebun utara / Jembatan yang selesai diperbaiki"}
signal next_requested
signal back_requested
signal choice_requested(index: int)
signal line_revealed
signal hub_requested
signal context_requested
signal preferences_changed(value: Dictionary)
signal modal_closed
var preferences: Dictionary = Prefs.clean({})
var reduced_motion: bool = false
var blocked: Callable
var textures: Dictionary = {}
var scene_id: String = ""
var bg_front: TextureRect
var bg_back: TextureRect
var portraits: Array = []
var stage_ids: Array = []
var hud: Control
var speaker: Label
var role: Label
var body: RichTextLabel
var chapter_title: Label
var location: Label
var next_button: Button
var previous_button: Button
var choice_buttons: Array = []
var auto_button: Button
var skip_button: Button
var stamp: Label
var modal: Control
var page: Dictionary = {}
var state: Dictionary = {}
var known: Array = []
var typing: bool = false
var auto_read: bool = false
var skipping: bool = false
var was_read: bool = false
var at_boundary: bool = false
var chars: float = 0
var elapsed: float = 0
var skip_elapsed: float = 0
var scene_tween: Tween
func _ready() -> void:
	_build()
	visibility_changed.connect(_visibility)
	set_process(false)
func _place(node: Control, parent: Node, rect: Rect2) -> void:
	parent.add_child(node)
	node.position = rect.position
	node.size = rect.size
func _label(parent: Node, text: String, rect: Rect2, fs: int, color: Color = LIGHT) -> Label:
	var n := Label.new()
	n.text = text
	n.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	n.mouse_filter = Control.MOUSE_FILTER_IGNORE
	n.add_theme_font_size_override("font_size",fs)
	n.add_theme_color_override("font_color",color)
	_place(n,parent,rect)
	return n
func _panel(parent: Node, rect: Rect2, alpha: float = .95) -> Panel:
	var n := Panel.new()
	var s := StyleBoxFlat.new()
	s.bg_color = Color(.025,.045,.065,alpha)
	s.border_color = Color("#907a57")
	s.set_border_width_all(1)
	s.set_corner_radius_all(4)
	n.add_theme_stylebox_override("panel",s)
	n.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(n,parent,rect)
	return n
func _button(parent: Node, text: String, rect: Rect2, callback: Callable) -> Button:
	var n := Button.new()
	n.text = text
	n.add_theme_font_size_override("font_size",14)
	for key in ["normal","hover","pressed","disabled"]:
		var s := StyleBoxFlat.new()
		s.bg_color = Color("#213c49") if key == "hover" else Color("#102633")
		s.border_color = GOLD if key == "hover" else Color("#52626b")
		s.set_border_width_all(1)
		s.set_corner_radius_all(3)
		n.add_theme_stylebox_override(key,s)
	n.add_theme_color_override("font_color",LIGHT)
	n.add_theme_color_override("font_hover_color",GOLD)
	n.add_theme_color_override("font_disabled_color",Color("#75858b"))
	n.pressed.connect(callback)
	_place(n,parent,rect)
	return n
func _texture(path: String) -> Texture2D:
	if not textures.has(path): textures[path] = load(path)
	return textures[path]
func _image(parent: Node, rect: Rect2) -> TextureRect:
	var n := TextureRect.new()
	n.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	n.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	n.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(n,parent,rect)
	return n
func _build() -> void:
	bg_back = _image(self,Rect2(0,0,1280,720))
	bg_front = _image(self,Rect2(0,0,1280,720))
	for bg in [bg_back,bg_front]: bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	for i in range(2): portraits.append(_image(self,Rect2(90+i*700,40,400,610)))
	var click := Control.new()
	_place(click,self,Rect2(0,0,1280,720))
	click.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT: request_next(); click.accept_event()
			elif event.button_index == MOUSE_BUTTON_RIGHT: toggle_hud(); click.accept_event())
	hud = Control.new()
	hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(hud,self,Rect2(0,0,1280,720))
	_panel(hud,Rect2(18,10,1244,72),.87)
	chapter_title = _label(hud,"",Rect2(36,18,870,28),19,GOLD)
	location = _label(hud,"",Rect2(36,48,950,24),14)
	_button(hud,"Tujuan bab",Rect2(984,24,124,35),func(): context_requested.emit())
	_button(hud,"Bab / Jeda",Rect2(1120,24,125,35),func(): stop_auto(); hub_requested.emit())
	_panel(hud,Rect2(24,474,1232,193),.95)
	speaker = _label(hud,"",Rect2(52,481,1175,31),25,GOLD)
	role = _label(hud,"",Rect2(52,514,1175,22),14,Color("#b5c7ce"))
	body = RichTextLabel.new()
	body.add_theme_font_size_override("normal_font_size",26)
	body.add_theme_color_override("default_color",LIGHT)
	body.mouse_filter = Control.MOUSE_FILTER_IGNORE
	body.scroll_active = false
	_place(body,hud,Rect2(52,536,1175,128))
	for i in range(2):
		var button := _button(hud,"",Rect2(295,290+i*76,690,64),_choose.bind(i))
		button.add_theme_font_size_override("font_size",19)
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		choice_buttons.append(button)
	previous_button = _button(hud,"Sebelumnya",Rect2(24,679,125,29),func(): stop_auto(); back_requested.emit())
	_button(hud,"Riwayat",Rect2(161,679,125,29),open_history)
	auto_button = _button(hud,"Auto: OFF",Rect2(298,679,120,29),_toggle_auto)
	skip_button = _button(hud,"Lewati dibaca",Rect2(430,679,180,29),_toggle_skip)
	_button(hud,"Tokoh",Rect2(622,679,110,29),func(): open_people(known))
	_button(hud,"Bacaan",Rect2(744,679,110,29),open_preferences)
	stamp = _label(hud,"Tersimpan",Rect2(866,683,105,24),12,Color("#a8c8b5"))
	next_button = _button(hud,"LANJUT",Rect2(978,679,278,29),request_next)
	modal = Control.new()
	_place(modal,self,Rect2(0,0,1280,720))
	modal.hide()
func apply_preferences(value: Dictionary) -> void:
	preferences = Prefs.clean(value)
	body.add_theme_font_size_override("normal_font_size",preferences["font_size"])
	if typing and preferences["text_speed"] == 0: reveal_all()
func show_page(next_page: Dictionary, progress: Dictionary, title: String, next_text: String, people: Array, boundary: bool) -> void:
	page = next_page
	state = progress.duplicate(true)
	known = people.duplicate()
	at_boundary = boundary
	elapsed = 0
	skip_elapsed = 0
	chars = 0
	hud.show()
	close_modal(false)
	chapter_title.text = title
	location.text = page.get("context",LOCATIONS.get(page.get("bg","kitchen_night"),"Eldoria"))
	_set_scene(page.get("bg","kitchen_night"))
	_set_cast()
	var id: String = Cast.id_for(page["speaker"])
	if id.is_empty():
		speaker.add_theme_color_override("font_color",GOLD)
		speaker.text = "Narasi" if page["speaker"] == "Narasi" else page["speaker"]
		role.text = "" if page["speaker"] == "Narasi" else "Pengaman aether / bukan manusia"
	else:
		speaker.text = Cast.PEOPLE[id]["name"] + (" (batin)" if page.get("thought",false) else "")
		role.text = Cast.PEOPLE[id]["role"]
		if page["speaker"] == "Rekaman Liora": speaker.text = "Liora / Rekaman"; role.text = "Rekaman yang dibuat semasa hidup / tidak dapat menjawab percakapan baru"
		elif str(page.get("context","")).begins_with("Kenangan"): role.text = "KENANGAN AREN / "+role.text
		speaker.add_theme_color_override("font_color",Color(Cast.PEOPLE[id]["color"]))
	body.text = Flow.page_text(page,state)
	body.scroll_to_line(0)
	next_button.text = next_text
	previous_button.disabled = state["line"] == 0
	was_read = state["read"].has(Flow.read_key(page,state))
	typing = not was_read and preferences["text_speed"] > 0
	body.visible_characters = 0 if typing else -1
	if at_boundary or page.has("options"): stop_auto()
	if skipping and not was_read: skipping = false
	_sync_choices()
	if not typing:
		was_read = true
		line_revealed.emit()
	_update_buttons()
	_update_processing()
func _set_scene(id: String) -> void:
	if scene_id == id: return
	if scene_tween and scene_tween.is_valid(): scene_tween.kill()
	bg_back.texture = bg_front.texture
	var path: String = "res://assets/story/window_morning.png" if id == "kitchen_day" else "res://assets/vn/backgrounds/%s.png" % id
	bg_front.texture = _texture(path)
	bg_front.modulate = Color.WHITE
	if not scene_id.is_empty() and not reduced_motion:
		bg_front.modulate.a = 0
		scene_tween = create_tween()
		scene_tween.tween_property(bg_front,"modulate:a",1.0,.24)
	scene_id = id
func _set_cast() -> void:
	stage_ids = page.get("cast",[]).duplicate()
	var talking: String = Cast.id_for(page["speaker"])
	if not talking.is_empty() and not stage_ids.has(talking):
		if stage_ids.size() >= 2: stage_ids[1] = talking
		else: stage_ids.append(talking)
	for i in range(2):
		var view: TextureRect = portraits[i]
		view.visible = i < stage_ids.size()
		if not view.visible: continue
		var id: String = stage_ids[i]
		view.texture = _texture("res://assets/vn/characters/%s.png" % id)
		var active: bool = talking.is_empty() or talking == id
		view.modulate = Color(1,1,1,1) if active else Color(.64,.68,.75,1)
		if id == "liora": view.modulate *= Color(.92,.95,1,.82)
func _sync_choices() -> void:
	for i in range(2):
		choice_buttons[i].visible = page.has("options") and i < page.get("options",[]).size() and not typing
		if choice_buttons[i].visible: choice_buttons[i].text = page["options"][i]["text"]
	next_button.disabled = page.has("options") and not typing
func reveal_all() -> void:
	if not typing: return
	typing = false
	was_read = true
	body.visible_characters = -1
	elapsed = 0
	_sync_choices()
	line_revealed.emit()
	_update_processing()
func request_next() -> void:
	if modal.visible: return
	if not hud.visible: hud.show(); return
	if typing: reveal_all(); return
	if page.has("options"): return
	next_requested.emit()
func _choose(index: int) -> void:
	if modal.visible or typing: return
	stop_auto()
	choice_requested.emit(index)
func stop_auto() -> void:
	auto_read = false
	skipping = false
	_update_buttons()
	_update_processing()
func _toggle_auto() -> void:
	skipping = false
	auto_read = not auto_read and not at_boundary and not page.has("options")
	_update_buttons()
	_update_processing()
func _toggle_skip() -> void:
	auto_read = false
	skipping = not skipping and was_read and not at_boundary and not page.has("options")
	_update_buttons()
	_update_processing()
func _update_buttons() -> void:
	if is_instance_valid(auto_button): auto_button.text = "Auto: ON" if auto_read else "Auto: OFF"
	if is_instance_valid(skip_button): skip_button.text = "Berhenti lewati" if skipping else "Lewati dibaca"
func _update_processing() -> void:
	set_process(is_visible_in_tree() and (typing or auto_read or skipping))
func _visibility() -> void:
	if not is_visible_in_tree(): auto_read = false; skipping = false
	_update_buttons()
	_update_processing()
func _process(delta: float) -> void:
	if not hud.visible or modal.visible or (blocked.is_valid() and blocked.call()): return
	if typing:
		chars += delta*float(preferences["text_speed"])
		body.visible_characters = mini(int(chars),body.get_total_character_count())
		if body.visible_characters >= body.get_total_character_count(): reveal_all()
		return
	if at_boundary or page.has("options"): stop_auto(); return
	if skipping:
		if not was_read: stop_auto(); return
		skip_elapsed += delta
		if skip_elapsed >= .09: next_requested.emit()
	elif auto_read:
		elapsed += delta
		if elapsed >= float(preferences["auto_delay"])+body.text.length()/70.0: next_requested.emit()
func toggle_hud() -> void:
	stop_auto()
	hud.visible = not hud.visible
func _clear_modal(title: String) -> void:
	stop_auto()
	for child in modal.get_children(): modal.remove_child(child); child.queue_free()
	_panel(modal,Rect2(0,0,1280,720),.94)
	_panel(modal,Rect2(105,70,1070,580),.99)
	_label(modal,title,Rect2(135,91,850,41),27,GOLD)
	_button(modal,"Tutup",Rect2(1011,94,132,33),close_modal)
	modal.show()
func close_modal(emit_signal: bool = true) -> void:
	modal.hide()
	_update_processing()
	if emit_signal: modal_closed.emit()
func show_info(title: String, value: String) -> void:
	_clear_modal(title)
	var rich := RichTextLabel.new()
	rich.add_theme_font_size_override("normal_font_size",23)
	_place(rich,modal,Rect2(143,157,995,447))
	rich.text = value
func open_history() -> void:
	var lines: Array[String] = []
	for item in state.get("history",[]): lines.append(item["who"]+"\n"+item["text"])
	show_info("Riwayat percakapan", "\n\n".join(lines) if not lines.is_empty() else "Percakapan muncul di sini setelah teks selesai ditampilkan.")
func open_people(people: Array) -> void:
	known = people.duplicate()
	_clear_modal("Tokoh dan hubungan")
	var image := _image(modal,Rect2(350,149,260,455))
	var detail := RichTextLabel.new()
	detail.add_theme_font_size_override("normal_font_size",21)
	_place(detail,modal,Rect2(637,158,498,434))
	var i := 0
	for id in Cast.PEOPLE:
		var person: Dictionary = Cast.PEOPLE[id]
		var select := func():
			image.texture = _texture("res://assets/vn/characters/%s.png" % id)
			detail.text = person["name"]+"\n"+person["role"]+"\n\n"+person["about"]+"\n\nHUBUNGAN\n"+person["relation"]
		var button := _button(modal,person["name"] if people.has(id) else "Belum dikenal",Rect2(135,158+i*59,185,47),select)
		button.disabled = not people.has(id)
		if id == "aren": select.call()
		i += 1
func open_preferences() -> void:
	_clear_modal("Pengaturan bacaan")
	_label(modal,"Kecepatan teks / 0 = tampil langsung",Rect2(180,176,830,31),22)
	var speed := HSlider.new()
	speed.max_value = 80
	speed.step = 5
	speed.value = preferences["text_speed"]
	_place(speed,modal,Rect2(180,230,880,35))
	var value := _label(modal,"%d huruf/detik" % preferences["text_speed"],Rect2(180,274,880,28),17)
	speed.value_changed.connect(func(v): preferences["text_speed"] = v; value.text = "%d huruf/detik" % v; preferences_changed.emit(preferences.duplicate()); apply_preferences(preferences))
	_label(modal,"Ukuran teks",Rect2(180,335,390,34),22)
	var font_size := OptionButton.new()
	font_size.add_item("Standar / 26")
	font_size.add_item("Besar / 30")
	font_size.select(1 if preferences["font_size"] == 30 else 0)
	_place(font_size,modal,Rect2(620,330,440,42))
	font_size.item_selected.connect(func(index): preferences["font_size"] = 30 if index == 1 else 26; apply_preferences(preferences); preferences_changed.emit(preferences.duplicate()))
	_label(modal,"Jeda tambahan Auto",Rect2(180,417,390,34),22)
	var delay := HSlider.new()
	delay.min_value = 1
	delay.max_value = 8
	delay.value = preferences["auto_delay"]
	_place(delay,modal,Rect2(620,417,440,35))
	delay.value_changed.connect(func(v): preferences["auto_delay"] = v; preferences_changed.emit(preferences.duplicate()))
	_label(modal,"Auto dan Lewati berhenti pada pilihan jawaban dan akhir adegan. Masuk duel selalu membutuhkan konfirmasi.",Rect2(180,503,880,75),19)
func handle_key(event: InputEvent) -> bool:
	if event.is_action_pressed("ui_cancel"):
		if modal.visible: close_modal(); return true
		if not hud.visible: hud.show(); return true
		return false
	if modal.visible: return true
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode in [KEY_ENTER,KEY_SPACE]: request_next(); return true
		if event.keycode == KEY_H: toggle_hud(); return true
	return false

func _input(event: InputEvent) -> void:
	if not is_visible_in_tree() or modal.visible or (blocked.is_valid() and blocked.call()): return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode in [KEY_ENTER,KEY_SPACE] and not page.has("options"):
			request_next()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_H:
			toggle_hud()
			get_viewport().set_input_as_handled()
