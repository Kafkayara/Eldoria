extends Control
const Duel = preload("res://scripts/duel.gd")
const Catalog = preload("res://scripts/catalog.gd")
const AI = preload("res://scripts/ai.gd")
const CardView = preload("res://scripts/card_view.gd")
const Arena = preload("res://scripts/arena.gd")
const Effects = preload("res://scripts/effects.gd")

const GOLD = Color("#d9bc85")
const MUTED = Color("#b2c7d2")
const LIGHT = Color("#eff1ed")
const CYAN = Color("#79d5df")

var duel = Duel.new()
var selected_hand: int = -1
var selected_zone: int = -1
var summon_defense: bool = false
var session: int = 0
var starting: bool = false
var muted: bool = false
var history: Array[String] = []
var zone_views: Array = [[], []]
var profile_lp: Array = []
var profile_bars: Array = []
var deck_labels: Array = []
var grave_labels: Array = []
var hand_box: HBoxContainer
var hand_scroll: ScrollContainer
var enemy_hand: HBoxContainer
var detail_card
var detail_type: Label
var detail_desc: RichTextLabel
var phase_label: Label
var status_label: Label
var hand_label: Label
var log_view: RichTextLabel
var battle_button: Button
var end_button: Button
var direct_button: Button
var position_button: Button
var mode_button: Button
var skill_button: Button
var audio_button: Button
var menu_layer: Control
var help_layer: Control
var result_layer: Control
var result_title: Label
var result_description: Label
var fx
var music: AudioStreamPlayer
var sfx: Array[AudioStreamPlayer] = []
var sound_streams: Dictionary = {}
var context_label: Label
var log_panel: Panel
var zoom_layer: Control
var zoom_card
var zoom_title: Label
var zoom_type: Label
var zoom_stats: Label
var zoom_description: RichTextLabel
var inspected_card: Dictionary = {}
var hover_card
var hover_serial: int = 0
var combat_serial: int = 0
var combat_notice: Panel
var combat_label: Label
var displayed_lp: Array = [4000.0,4000.0]
var lp_targets: Array = [4000,4000]
var lp_tweens: Array = [null,null]


func _ready() -> void:
	var app_theme := Theme.new()
	var ui_font := SystemFont.new()
	ui_font.font_names = PackedStringArray(["Segoe UI", "Arial"])
	app_theme.default_font = ui_font
	app_theme.default_font_size = 17
	theme = app_theme
	_build_ui()
	_build_audio()
	duel.changed.connect(_render)
	duel.message.connect(_message)
	duel.visual.connect(_visual)
	duel.finished.connect(_finished)
	duel.combat.connect(_combat_explained)
	_new_duel()
	menu_layer.show()

func _style(bg: Color, edge: Color, radius: int = 10) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = bg
	box.border_color = edge
	box.set_border_width_all(1)
	box.set_corner_radius_all(radius)
	box.content_margin_left = 14
	box.content_margin_right = 14
	return box

func _place(node: Control, parent: Node, rect: Rect2) -> void:
	parent.add_child(node)
	node.position = rect.position
	node.size = rect.size

func _panel(parent: Node, rect: Rect2, edge: Color = Color("#2a424e")) -> Panel:
	var node := Panel.new()
	node.add_theme_stylebox_override("panel", _style(Color(0.035,0.066,0.105,0.95),edge))
	_place(node,parent,rect)
	return node

func _label(parent: Node, text_value: String, rect: Rect2, font_size: int = 17, color: Color = LIGHT) -> Label:
	var node := Label.new()
	node.text = text_value
	node.add_theme_font_size_override("font_size",font_size)
	node.add_theme_color_override("font_color",color)
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_place(node,parent,rect)
	return node

func _button(parent: Node, title: String, rect: Rect2, callback: Callable, primary: bool = false) -> Button:
	var node := Button.new()
	node.text = title
	var bg: Color = Color("#bd9b5f") if primary else Color("#142937")
	node.add_theme_stylebox_override("normal",_style(bg, GOLD if primary else Color("#3c5966"),7))
	node.add_theme_stylebox_override("hover",_style(bg.lightened(0.12),GOLD,7))
	node.add_theme_stylebox_override("pressed",_style(bg.darkened(0.15),GOLD,7))
	node.add_theme_stylebox_override("disabled",_style(Color("#101c27"),Color("#253541"),7))
	node.add_theme_stylebox_override("focus",_style(Color(0,0,0,0),CYAN,7))
	node.add_theme_color_override("font_color",Color("#121924") if primary else LIGHT)
	node.add_theme_color_override("font_hover_color",Color("#121924") if primary else GOLD)
	node.add_theme_color_override("font_disabled_color",Color("#91a9b5"))
	node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	node.pressed.connect(callback)
	_place(node,parent,rect)
	return node

func _build_ui() -> void:
	var arena := Arena.new()
	_place(arena,self,Rect2(0,0,1280,720))
	_label(self,"E L D O R I A",Rect2(20,13,340,40),29,GOLD)
	_label(self,"ARENA ASTRAL / DUEL SOLO",Rect2(322,25,420,25),15,MUTED)
	_button(self,"Log duel",Rect2(916,18,105,38),_toggle_log)
	_button(self,"Panduan",Rect2(1033,18,105,38),func(): _hide_hover(); help_layer.show())
	_button(self,"Menu",Rect2(1150,18,112,38),_open_menu)
	_panel(self,Rect2(18,80,260,624),Color("#4d6672"))
	_label(self,"DETAIL KARTU",Rect2(34,96,225,26),16,GOLD)
	detail_card = CardView.new()
	detail_card.large = true
	detail_card.disabled = true
	detail_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(detail_card,self,Rect2(32,136,232,270))
	detail_type = _label(self,"",Rect2(34,421,226,23),14,CYAN)
	detail_desc = RichTextLabel.new()
	detail_desc.add_theme_font_size_override("normal_font_size",17)
	detail_desc.add_theme_color_override("default_color",LIGHT)
	_place(detail_desc,self,Rect2(34,458,226,151))
	_button(self,"PERBESAR KARTU",Rect2(34,625,226,40),func(): _open_card_zoom(inspected_card))
	_label(self,"Klik kanan / E untuk detail besar.",Rect2(34,674,226,21),12,MUTED)
	for side in range(2):
		var x: float = 298 if side == 0 else 747
		_panel(self,Rect2(x,81,245,58),Color("#486575"))
		_label(self,"KAMU" if side == 0 else "NYX / LAWAN",Rect2(x+12,87,215,20),14,CYAN if side == 0 else GOLD)
		profile_lp.append(_label(self,"4000 LP",Rect2(x+12,108,126,28),24,LIGHT))
		var bar := ProgressBar.new()
		bar.max_value = 4000
		bar.value = 4000
		bar.show_percentage = false
		bar.add_theme_stylebox_override("background",_style(Color("#203a49"),Color("#203a49"),3))
		bar.add_theme_stylebox_override("fill",_style(CYAN if side == 0 else GOLD,CYAN if side == 0 else GOLD,3))
		_place(bar,self,Rect2(x+140,120,92,8))
		profile_bars.append(bar)
	phase_label = _label(self,"",Rect2(551,84,188,52),17,GOLD)
	phase_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label(self,"MONSTER LAWAN",Rect2(415,143,290,21),13,MUTED)
	_label(self,"MONSTERMU",Rect2(415,312,290,21),13,CYAN)
	for side in range(2):
		for index in range(3):
			var view := CardView.new()
			view.empty_caption = "ZONA %s" % ["I","II","III"][index]
			_place(view,self,Rect2(415+158*index,165 if side == 1 else 334,146,142))
			view.pressed.connect(_zone_clicked.bind(side,index))
			view.mouse_entered.connect(_zone_hover.bind(side,index))
			view.mouse_exited.connect(_hide_hover)
			view.inspect_requested.connect(_open_card_zoom)
			zone_views[side].append(view)
	for side in range(2):
		var x: int = 302 if side == 0 else 903
		var y: int = 352 if side == 0 else 183
		var back := CardView.new()
		back.back = true
		back.disabled = true
		_place(back,self,Rect2(x,y,82,82))
		deck_labels.append(_label(self,"",Rect2(x,y+88,93,22),13,GOLD))
		grave_labels.append(_label(self,"",Rect2(x,y+110,100,22),12,MUTED))
	enemy_hand = HBoxContainer.new()
	enemy_hand.add_theme_constant_override("separation",4)
	_place(enemy_hand,self,Rect2(791,145,200,16))
	status_label = _label(self,"",Rect2(298,480,694,34),16,CYAN)
	hand_label = _label(self,"",Rect2(298,522,477,22),14,GOLD)
	mode_button = _button(self,"Summon: MENYERANG",Rect2(779,516,213,31),_toggle_summon_mode)
	mode_button.add_theme_font_size_override("font_size",13)
	hand_scroll = ScrollContainer.new()
	hand_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	hand_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_place(hand_scroll,self,Rect2(297,555,695,154))
	hand_box = HBoxContainer.new()
	hand_box.add_theme_constant_override("separation",12)
	hand_scroll.add_child(hand_box)
	_panel(self,Rect2(1010,80,252,624),Color("#4d6672"))
	_label(self,"KOMANDO DUEL",Rect2(1028,97,216,26),16,GOLD)
	context_label = _label(self,"",Rect2(1028,139,216,101),18,LIGHT)
	battle_button = _button(self,"MASUK BATTLE",Rect2(1028,257,216,46),_battle)
	direct_button = _button(self,"SERANG LANGSUNG",Rect2(1028,257,216,46),_direct)
	position_button = _button(self,"UBAH POSISI",Rect2(1028,317,216,43),_change_position)
	skill_button = _button(self,"Kebangkitan Fajar",Rect2(1028,375,216,47),_skill)
	skill_button.tooltip_text = "Sekali per duel: pulihkan 800 LP saat LP 2500 atau kurang."
	end_button = _button(self,"AKHIRI GILIRAN",Rect2(1028,438,216,52),_end_turn,true)
	_label(self,"Klik monster untuk memilih.\nTarget yang valid akan menyala.",Rect2(1028,509,216,45),14,MUTED)
	_button(self,"BUKA LOG DUEL",Rect2(1028,570,216,41),_toggle_log)
	audio_button = _button(self,"AUDIO: ON",Rect2(1028,633,216,40),_toggle_audio)
	audio_button.add_theme_font_size_override("font_size",14)
	log_panel = _panel(self,Rect2(1010,80,252,624),Color("#9b855a"))
	_label(log_panel,"RIWAYAT DUEL",Rect2(16,16,220,28),17,GOLD)
	log_view = RichTextLabel.new()
	log_view.add_theme_font_size_override("normal_font_size",17)
	log_view.add_theme_color_override("default_color",LIGHT)
	log_view.scroll_following = true
	_place(log_view,log_panel,Rect2(16,61,220,487))
	_button(log_panel,"TUTUP LOG",Rect2(16,566,220,41),_toggle_log)
	log_panel.hide()
	fx = Effects.new()
	_place(fx,self,Rect2(0,0,1280,720))
	combat_notice = _panel(fx,Rect2(298,480,694,35),GOLD)
	combat_notice.mouse_filter = Control.MOUSE_FILTER_IGNORE
	combat_label = _label(combat_notice,"",Rect2(10,3,674,29),17,LIGHT)
	combat_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	combat_notice.hide()
	hover_card = CardView.new()
	hover_card.large = true
	hover_card.disabled = true
	hover_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(hover_card,self,Rect2(560,215,238,300))
	hover_card.hide()
	_build_menu()
	_build_help()
	_build_result()
	_build_zoom()

func _overlay() -> Control:
	var node := Control.new()
	_place(node,self,Rect2(0,0,1280,720))
	var shade := ColorRect.new()
	shade.color = Color(0.018,0.029,0.053,0.97)
	_place(shade,node,Rect2(0,0,1280,720))
	return node

func _build_menu() -> void:
	menu_layer = _overlay()
	var art := TextureRect.new()
	var texture := AtlasTexture.new()
	texture.atlas = CardView.ATLAS
	texture.region = Rect2(0,0,CardView.ATLAS.get_width()/3.0,CardView.ATLAS.get_height()/2.0)
	art.texture = texture
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	art.modulate = Color(0.9,0.92,0.95,0.85)
	_place(art,menu_layer,Rect2(700,0,580,720))
	_panel(menu_layer,Rect2(60,88,584,552),Color("#8a7958"))
	_label(menu_layer,"ORIGINAL ANIME CARD DUEL",Rect2(98,120,508,28),16,GOLD)
	var title := _label(menu_layer,"ELDORIA",Rect2(92,173,524,95),76,LIGHT)
	var title_font := SystemFont.new()
	title_font.font_names = PackedStringArray(["Georgia"])
	title.add_theme_font_override("font",title_font)
	_label(menu_layer,"CHRONICLES OF THE FIRST LIGHT",Rect2(99,286,508,28),17,GOLD)
	_label(menu_layer,"Cahaya terakhir Eldoria ada di tanganmu.\nPanggil monster, kuasai magi,\ndan hadapi Nyx di Arena Astral.",Rect2(99,342,508,108),22,LIGHT)
	_button(menu_layer,"MULAI DUEL",Rect2(99,479,508,58),_start_from_menu,true)
	_button(menu_layer,"Pelajari aturan",Rect2(99,552,240,45),func(): help_layer.show())
	_label(menu_layer,"VERSI 0.4 / SOLO vs AI / 20 KARTU",Rect2(65,663,600,29),14,MUTED)

func _build_help() -> void:
	help_layer = _overlay()
	_panel(help_layer,Rect2(222,50,836,620),Color("#ae945e"))
	_label(help_layer,"Panduan Duel Eldoria",Rect2(252,74,776,45),30,GOLD)
	var body := RichTextLabel.new()
	body.add_theme_font_size_override("normal_font_size",19)
	body.add_theme_color_override("default_color",LIGHT)
	body.bbcode_enabled = true
	body.text = "[color=#dfbf81]01  MEMBACA KARTU[/color]\nArahkan kursor untuk pratinjau besar. Klik kanan kartu, tekan E, atau pilih Perbesar Kartu untuk membaca efek lengkap. Klik kiri dipakai untuk bermain.\n\n[color=#dfbf81]02  MAIN PHASE[/color]\nPilih monster di tangan, pilih mode menyerang / bertahan, lalu klik zona tujuan yang menyala. Satu normal summon per giliran. Naga Bara perlu satu tribute.\n\n[color=#dfbf81]03  SPELL[/color]\nBadai Aether dan Suaka Surya aktif langsung. Berkah Fajar menargetkan monstermu; Retakan Langit menargetkan monster lawan dengan ATK 1800 atau kurang.\n\n[color=#dfbf81]04  BATTLE PHASE[/color]\nKlik Masuk Battle, pilih monstermu yang bisa menyerang, lalu klik monster lawan yang menyala. Jika papan lawan kosong, pilih Serang Langsung. Satu serangan per monster. Pemain pertama tidak menyerang pada giliran pertama.\n\n[color=#dfbf81]05  DAMAGE & STRATEGI[/color]\nLawan posisi menyerang: selisih ATK mengurangi LP. Lawan bertahan memakai DEF; menang tidak memberi kerusakan LP. Penjelasan hitungan muncul saat serangan. Ubah posisi mulai giliran setelah summon. Skill memulihkan 800 LP sekali saat LP 2500 atau kurang.\n\n[color=#dfbf81]06  MENANG[/color]\nTurunkan LP lawan ke 0 atau buat lawan kehabisan deck saat draw. Buka Log Duel untuk membaca riwayat. Esc menutup detail / panduan atau membuka menu."
	_place(body,help_layer,Rect2(252,135,776,443))
	_button(help_layer,"MENGERTI",Rect2(252,600,776,45),func(): help_layer.hide(),true)
	help_layer.hide()

func _build_result() -> void:
	result_layer = _overlay()
	_panel(result_layer,Rect2(383,154,514,416),GOLD)
	_label(result_layer,"ARENA ASTRAL",Rect2(415,183,450,27),16,GOLD)
	result_title = _label(result_layer,"VICTORY",Rect2(415,235,450,75),54,LIGHT)
	result_description = _label(result_layer,"",Rect2(415,331,450,74),20,MUTED)
	_button(result_layer,"DUEL LAGI",Rect2(415,432,450,49),_start_from_menu,true)
	_button(result_layer,"Kembali ke menu",Rect2(415,499,450,42),_open_menu)
	result_layer.hide()

func _build_audio() -> void:
	music = AudioStreamPlayer.new()
	add_child(music)
	var stream: AudioStreamWAV = load("res://assets/audio/astral_theme.wav")
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_begin = 0
	stream.loop_end = stream.data.size() / 4
	music.stream = stream
	music.volume_db = -17
	music.play()
	for i in range(5):
		var player := AudioStreamPlayer.new()
		player.volume_db = -12
		add_child(player)
		sfx.append(player)
	for name_value in ["click","draw","summon","attack","spell","heal","win","lose"]:
		sound_streams[name_value] = load("res://assets/audio/%s.wav" % name_value)

func _sound(name_value: String) -> void:
	if muted or starting or not sound_streams.has(name_value):
		return
	for player in sfx:
		if not player.playing:
			player.stream = sound_streams[name_value]
			player.play()
			return
	sfx[0].stream = sound_streams[name_value]
	sfx[0].play()

func _toggle_audio() -> void:
	muted = not muted
	music.stream_paused = muted
	for player in sfx:
		if muted:
			player.stop()
	audio_button.text = "AUDIO: OFF" if muted else "AUDIO: ON"

func _new_duel() -> void:
	session += 1
	_reset_visuals()
	zoom_layer.hide()
	log_panel.hide()
	history.clear()
	selected_hand = -1
	selected_zone = -1
	summon_defense = false
	result_layer.hide()
	starting = true
	duel.start()
	starting = false
	_inspect(Catalog.card("dawn"))
	_render()

func _start_from_menu() -> void:
	help_layer.hide()
	menu_layer.hide()
	result_layer.hide()
	_new_duel()
	_sound("summon")
	_banner("DUEL DIMULAI",GOLD)

func _open_menu() -> void:
	session += 1
	_hide_hover()
	zoom_layer.hide()
	result_layer.hide()
	help_layer.hide()
	menu_layer.show()

func _clear_children(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()

func _render() -> void:
	for side in range(2):
		_update_lp(side)
		deck_labels[side].text = "DECK / %02d" % duel.decks[side].size()
		grave_labels[side].text = "GRAVE / %02d" % duel.graves[side].size()
		for index in range(3):
			var view = zone_views[side][index]
			view.data = duel.fields[side][index]
			view.selected = side == 0 and index == selected_zone
			if selected_hand >= 0 and selected_hand < duel.hands[0].size() and duel.turn == 0 and duel.phase == "MAIN":
				var chosen: Dictionary = duel.hands[0][selected_hand]
				var effect: String = chosen["effect"]
				if chosen["kind"] == "monster" and side == 0:
					view.selected = (view.data.is_empty() or int(chosen["level"]) > 4) and not duel.summoned
				elif effect == "buff" and side == 0:
					view.selected = not view.data.is_empty()
				elif effect == "destroy" and side == 1:
					view.selected = not view.data.is_empty() and int(view.data.get("atk",9999)) <= 1800
			if side == 1 and duel.turn == 0 and duel.phase == "BATTLE" and _attacker_ready():
				view.selected = not view.data.is_empty()
			view.queue_redraw()
	phase_label.text = "GILIRAN %02d\n%s / %s" % [duel.turn_number,"KAMU" if duel.turn == 0 else "NYX",duel.phase]
	_clear_children(hand_box)
	for index in range(duel.hands[0].size()):
		var card := CardView.new()
		card.data = duel.hands[0][index]
		card.selected = index == selected_hand
		card.custom_minimum_size = Vector2(142,144)
		card.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		hand_box.add_child(card)
		card.pressed.connect(_hand_clicked.bind(index))
		card.mouse_entered.connect(_hand_hover.bind(index))
		card.mouse_exited.connect(_hide_hover)
		card.inspect_requested.connect(_open_card_zoom)
		card.tooltip_text = "Klik kiri: pilih / Klik kanan: detail besar"
	_clear_children(enemy_hand)
	for i in range(mini(duel.hands[1].size(),8)):
		var back := CardView.new()
		back.back = true
		back.disabled = true
		back.custom_minimum_size = Vector2(22,14)
		enemy_hand.add_child(back)
	hand_label.text = "TANGAN: %d KARTU / LAWAN: %d" % [duel.hands[0].size(),duel.hands[1].size()]
	var active: bool = duel.turn == 0 and not duel.over
	battle_button.visible = duel.phase == "MAIN"
	battle_button.disabled = not active or duel.turn_number == 1
	direct_button.visible = duel.phase == "BATTLE"
	direct_button.disabled = not active or not _attacker_ready() or duel.has_monsters(1)
	end_button.disabled = not active
	skill_button.disabled = not active or duel.phase != "MAIN" or duel.skill_used[0] or int(duel.lp[0]) > 2500
	skill_button.text = "SKILL SUDAH DIPAKAI" if duel.skill_used[0] else "Kebangkitan Fajar"
	var can_switch: bool = false
	if selected_zone >= 0 and not duel.fields[0][selected_zone].is_empty():
		var chosen_monster: Dictionary = duel.fields[0][selected_zone]
		can_switch = not chosen_monster["switched"] and chosen_monster["summoned_turn"] != duel.turn_number
	position_button.disabled = not active or duel.phase != "MAIN" or not can_switch
	mode_button.disabled = not active or duel.phase != "MAIN"
	mode_button.text = "Summon: BERTAHAN" if summon_defense else "Summon: MENYERANG"
	_update_context()

func _inspect(card: Dictionary) -> void:
	if card.is_empty():
		return
	inspected_card = card.duplicate(true)
	detail_card.data = inspected_card
	detail_card.queue_redraw()
	detail_type.text = "SPELL / MAGI AKTIF" if card["kind"] == "spell" else "%s / LEVEL %d" % [card["element"],card["level"]]
	detail_desc.text = card["text"]

func _hand_hover(index: int) -> void:
	if index >= 0 and index < duel.hands[0].size():
		_inspect(duel.hands[0][index])
		_queue_hover(duel.hands[0][index],true)

func _zone_hover(side: int, zone: int) -> void:
	var card: Dictionary = duel.fields[side][zone]
	_inspect(card)
	if not card.is_empty():
		_queue_hover(card)

func _can_input() -> bool:
	return duel.turn == 0 and not duel.over and not menu_layer.visible and not help_layer.visible and not zoom_layer.visible

func _hand_clicked(index: int) -> void:
	if not _can_input() or index < 0 or index >= duel.hands[0].size():
		return
	_hide_hover()
	var card: Dictionary = duel.hands[0][index]
	_inspect(card)
	if duel.phase != "MAIN":
		_message("Kartu dari tangan hanya bisa dimainkan pada Main Phase.")
		return
	_sound("click")
	selected_zone = -1
	selected_hand = -1 if selected_hand == index else index
	if selected_hand < 0:
		_message("Pilihan kartu dibatalkan.")
	elif card["kind"] == "spell" and card["effect"] not in ["buff","destroy"]:
		if duel.play(index):
			selected_hand = -1
	elif card["kind"] == "spell":
		_message("Pilih monster %s sebagai target %s." % ["milikmu" if card["effect"] == "buff" else "lawan",card["name"]])
	else:
		_message("Pilih zona milikmu untuk summon %s%s." % [card["name"]," (perlu 1 tribute)" if int(card["level"]) > 4 else ""])
	_render()

func _zone_clicked(side: int, zone: int) -> void:
	if not _can_input():
		return
	_hide_hover()
	_inspect(duel.fields[side][zone])
	if selected_hand >= 0 and selected_hand < duel.hands[0].size() and duel.phase == "MAIN":
		var card: Dictionary = duel.hands[0][selected_hand]
		if (card["kind"] == "monster" and side == 0) or (card["effect"] == "buff" and side == 0) or (card["effect"] == "destroy" and side == 1):
			if duel.play(selected_hand,zone,summon_defense):
				selected_hand = -1
				selected_zone = -1
			_render()
			return
		_message("Pilih zona yang sesuai dengan target kartu.")
		return
	if side == 0 and not duel.fields[0][zone].is_empty():
		selected_zone = zone
		_sound("click")
		_message("Pilih target lawan atau Serang Langsung." if duel.phase == "BATTLE" else "Monster dipilih. Kamu bisa mengubah posisi atau masuk Battle.")
		_render()
	elif side == 1 and duel.phase == "BATTLE" and selected_zone >= 0:
		var from: Vector2 = _zone_center(0,selected_zone)
		if duel.attack(selected_zone,zone):
			fx.strike(from,_zone_center(1,zone))
			selected_zone = -1
		_render()

func _toggle_summon_mode() -> void:
	if not _can_input():
		return
	summon_defense = not summon_defense
	_sound("click")
	_render()

func _battle() -> void:
	if not _can_input():
		return
	if duel.battle():
		selected_hand = -1
		selected_zone = -1
		_banner("BATTLE PHASE",GOLD)
		_render()

func _direct() -> void:
	if not _can_input() or selected_zone < 0:
		return
	var from: Vector2 = _zone_center(0,selected_zone)
	if duel.attack(selected_zone):
		fx.strike(from,Vector2(870,112))
		selected_zone = -1
	_render()

func _change_position() -> void:
	if _can_input() and selected_zone >= 0:
		duel.switch_position(selected_zone)

func _skill() -> void:
	if _can_input():
		duel.skill()

func _end_turn() -> void:
	if not _can_input():
		return
	_hide_hover()
	combat_notice.hide()
	status_label.show()
	combat_serial += 1
	selected_hand = -1
	selected_zone = -1
	duel.end_turn()
	_banner("GILIRAN NYX",GOLD)
	_run_ai(session)

func _run_ai(token: int) -> void:
	await get_tree().create_timer(0.8).timeout
	var steps: int = 0
	while token == session and duel.turn == 1 and not duel.over and steps < 45:
		if help_layer.visible or zoom_layer.visible:
			await get_tree().create_timer(0.2).timeout
			continue
		steps += 1
		var action: Dictionary = AI.main_action(duel) if duel.phase == "MAIN" else AI.battle_action(duel)
		if action["type"] == "attack":
			var target: Vector2 = _zone_center(0,action["target"]) if action["target"] >= 0 else Vector2(420,112)
			fx.strike(_zone_center(1,action["zone"]),target)
		if not AI.apply(duel,action):
			duel.end_turn()
		if duel.turn == 1 and not duel.over:
			await get_tree().create_timer(0.65).timeout
	if token != session:
		return
	if duel.turn == 1 and not duel.over:
		duel.end_turn()
	if not duel.over:
		_banner("GILIRANMU",CYAN)
	_render()

func _message(text_value: String) -> void:
	history.append(text_value)
	if history.size() > 35:
		history.pop_front()
	log_view.text = "\n\n".join(history)
	status_label.text = text_value

func _zone_center(side: int, zone: int) -> Vector2:
	return Vector2(488+158*maxi(zone,0),236 if side == 1 else 405)

func _visual(kind: String, side: int, zone: int, amount: int) -> void:
	if starting:
		return
	if kind in ["summon","spell","attack"]:
		_hide_hover()
		for child in fx.get_children():
			if child.get_meta("phase_banner",false):
				fx.remove_child(child)
				child.queue_free()
	match kind:
		"summon":
			_animate_summon(side,zone)
			_sound("summon")
		"spell":
			fx.burst(Vector2(649,308),CYAN)
			_sound("spell")
		"attack":
			fx.burst(_zone_center(side,zone),GOLD)
			_sound("attack")
		"damage":
			_float_text("−%d LP" % amount,Vector2(354 if side == 0 else 802,137),Color("#ff8e85"))
		"heal":
			_float_text("+%d LP" % amount,Vector2(354 if side == 0 else 802,137),CYAN)
			_sound("heal")
		"shield": fx.burst(_zone_center(side,zone),CYAN)
		"draw": _sound("draw")

func _float_text(text_value: String, point: Vector2, color: Color) -> void:
	var node := _label(fx,text_value,Rect2(point,Vector2(190,38)),26,color)
	var tween := node.create_tween().set_parallel(true)
	tween.tween_property(node,"position:y",point.y-37,0.9)
	tween.tween_property(node,"modulate:a",0.0,0.65).set_delay(0.4)
	tween.chain().tween_callback(node.queue_free)

func _banner(text_value: String, color: Color) -> void:
	var node := _label(fx,text_value,Rect2(411,292,474,37),28,color)
	node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	node.set_meta("phase_banner",true)
	var tween := node.create_tween()
	tween.tween_interval(0.65)
	tween.tween_property(node,"modulate:a",0.0,0.45)
	tween.tween_callback(node.queue_free)

func _finished(winning_side: int) -> void:
	_hide_hover()
	zoom_layer.hide()
	selected_hand = -1
	selected_zone = -1
	result_title.text = "VICTORY" if winning_side == 0 else "DEFEAT"
	result_title.add_theme_color_override("font_color",GOLD if winning_side == 0 else Color("#da919b"))
	result_description.text = "%s\nDuel selesai pada giliran %d." % ["Cahaya Eldoria tetap menyala. Nyx telah dikalahkan." if winning_side == 0 else "Nyx menguasai arena. Susun strategi dan coba lagi.",duel.turn_number]
	_sound("win" if winning_side == 0 else "lose")
	result_layer.show()

func _attacker_ready() -> bool:
	if selected_zone < 0 or selected_zone > 2:
		return false
	var monster: Dictionary = duel.fields[0][selected_zone]
	return not monster.is_empty() and not monster["defending"] and not monster["attacked"]

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
		if not menu_layer.visible and not help_layer.visible and not result_layer.visible:
			_open_card_zoom(inspected_card)
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_cancel"):
		if zoom_layer.visible:
			zoom_layer.hide()
		elif help_layer.visible:
			help_layer.hide()
		elif log_panel.visible:
			log_panel.hide()
		elif not menu_layer.visible:
			_open_menu()

func _exit_tree() -> void:
	session += 1
	if is_instance_valid(music):
		music.stop()
		music.stream = null
	for player in sfx:
		if is_instance_valid(player):
			player.stop()
			player.stream = null
	sound_streams.clear()
func _build_zoom() -> void:
	zoom_layer = _overlay()
	_panel(zoom_layer,Rect2(225,52,830,616),GOLD)
	_label(zoom_layer,"ARSIP KARTU / TAMPILAN BESAR",Rect2(253,73,770,24),15,GOLD)
	zoom_card = CardView.new()
	zoom_card.large = true
	zoom_card.disabled = true
	zoom_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(zoom_card,zoom_layer,Rect2(253,121,280,434))
	zoom_title = _label(zoom_layer,"",Rect2(566,119,454,83),32,LIGHT)
	zoom_type = _label(zoom_layer,"",Rect2(566,210,454,28),17,CYAN)
	zoom_stats = _label(zoom_layer,"",Rect2(566,255,454,44),26,GOLD)
	zoom_description = RichTextLabel.new()
	zoom_description.add_theme_font_size_override("normal_font_size",22)
	zoom_description.add_theme_color_override("default_color",LIGHT)
	_place(zoom_description,zoom_layer,Rect2(566,323,454,181))
	_label(zoom_layer,"Klik kiri untuk bermain. Klik kanan atau E untuk detail.",Rect2(566,523,454,45),15,MUTED)
	_button(zoom_layer,"KEMBALI KE DUEL",Rect2(566,592,454,45),func(): zoom_layer.hide(),true)
	_label(zoom_layer,"Esc menutup tampilan ini.",Rect2(253,586,280,38),15,MUTED)
	zoom_layer.hide()

func _open_card_zoom(card: Dictionary) -> void:
	if card.is_empty():
		return
	_hide_hover()
	_inspect(card)
	zoom_card.data = card.duplicate(true)
	zoom_card.queue_redraw()
	zoom_title.text = card["name"]
	zoom_type.text = "SPELL / MAGI AKTIF" if card["kind"] == "spell" else "%s / LEVEL %d" % [card["element"],card["level"]]
	zoom_stats.text = "ATK %d   /   DEF %d" % [card["atk"],card["def"]] if card["kind"] == "monster" else "KARTU SPELL"
	zoom_description.text = card["text"]
	zoom_layer.show()

func _queue_hover(card: Dictionary, from_hand: bool = false) -> void:
	_hide_hover()
	if menu_layer.visible or help_layer.visible or result_layer.visible or zoom_layer.visible:
		return
	var token: int = hover_serial
	var data_copy: Dictionary = card.duplicate(true)
	await get_tree().create_timer(0.38).timeout
	if token != hover_serial or menu_layer.visible or help_layer.visible or result_layer.visible or zoom_layer.visible:
		return
	var point: Vector2 = get_local_mouse_position()
	hover_card.position = Vector2(clampf(point.x-119,294,1020),238 if from_hand else clampf(point.y-150,85,396))
	hover_card.data = data_copy
	hover_card.queue_redraw()
	hover_card.show()

func _hide_hover() -> void:
	hover_serial += 1
	if is_instance_valid(hover_card):
		hover_card.hide()

func _toggle_log() -> void:
	_hide_hover()
	log_panel.visible = not log_panel.visible

func _update_context() -> void:
	if duel.over:
		context_label.text = "Duel selesai."
	elif duel.turn == 1:
		context_label.text = "Giliran Nyx.\nAmati kartu dan strategi lawan."
	elif selected_hand >= 0 and selected_hand < duel.hands[0].size():
		var card: Dictionary = duel.hands[0][selected_hand]
		context_label.text = "%s\nPilih zona yang menyala." % card["name"]
	elif duel.phase == "BATTLE":
		context_label.text = "Battle Phase\nPilih monstermu, lalu target lawan."
	elif duel.turn_number == 1:
		context_label.text = "Main Phase\nPanggil monster, lalu akhiri giliran pertama."
	else:
		context_label.text = "Main Phase\nMainkan kartu, lalu masuk Battle."

func _set_lp_value(value: float, side: int) -> void:
	displayed_lp[side] = value
	profile_lp[side].text = "%d LP" % roundi(value)
	profile_bars[side].value = value

func _update_lp(side: int) -> void:
	var target: int = int(duel.lp[side])
	if lp_targets[side] == target:
		return
	lp_targets[side] = target
	if lp_tweens[side] != null and lp_tweens[side].is_valid():
		lp_tweens[side].kill()
	var tween := create_tween()
	lp_tweens[side] = tween
	tween.tween_method(_set_lp_value.bind(side),float(displayed_lp[side]),float(target),0.7).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _reset_visuals() -> void:
	_hide_hover()
	for side in range(2):
		if lp_tweens[side] != null and lp_tweens[side].is_valid():
			lp_tweens[side].kill()
		lp_tweens[side] = null
		lp_targets[side] = 4000
		_set_lp_value(4000.0,side)
		for view in zone_views[side]:
			view.self_modulate = Color.WHITE
	for child in fx.get_children():
		if child != combat_notice:
			fx.remove_child(child)
			child.queue_free()
	fx.bursts.clear()
	fx.beams.clear()
	combat_notice.hide()
	status_label.show()
	combat_serial += 1

func _animate_summon(side: int, zone: int) -> void:
	var card: Dictionary = duel.fields[side][zone]
	if card.is_empty():
		return
	var ghost := CardView.new()
	ghost.data = card.duplicate(true)
	ghost.disabled = true
	ghost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var origin := Vector2(800,143) if side == 1 else Vector2(302,352)
	if side == 0 and selected_hand >= 0 and selected_hand < hand_box.get_child_count():
		origin = hand_box.get_child(selected_hand).global_position
	var target: Vector2 = _zone_center(side,zone)-Vector2(73,71)
	_place(ghost,fx,Rect2(origin,Vector2(146,142)))
	var view = zone_views[side][zone]
	view.self_modulate.a = 0.0
	var tween := ghost.create_tween()
	tween.tween_property(ghost,"position",target,0.42).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): view.self_modulate = Color.WHITE; fx.burst(_zone_center(side,zone),GOLD))
	tween.tween_property(ghost,"modulate:a",0.0,0.12)
	tween.tween_callback(ghost.queue_free)

func _combat_explained(report: Dictionary) -> void:
	_hide_hover()
	combat_serial += 1
	var token: int = combat_serial
	var attack_power: int = int(report["attack"])
	var enemy_power: int = int(report["power"])
	var difference: int = int(report["difference"])
	var text_value: String
	if report["direct"]:
		text_value = "SERANG LANGSUNG / %d kerusakan LP" % attack_power
	elif report["defending"] and difference >= 0:
		text_value = "%d ATK vs %d DEF / 0 kerusakan LP" % [attack_power,enemy_power]
	elif difference < 0:
		text_value = "%d ATK vs %d %s / penyerang -%d LP" % [attack_power,enemy_power,"DEF" if report["defending"] else "ATK",-difference]
	else:
		text_value = "%d ATK - %d ATK = %d kerusakan LP" % [attack_power,enemy_power,difference]
	_message(text_value)
	combat_label.text = text_value
	combat_notice.show()
	status_label.hide()
	_animate_attack(report)
	await get_tree().create_timer(2.6).timeout
	if token == combat_serial:
		combat_notice.hide()
		status_label.show()

func _animate_attack(report: Dictionary) -> void:
	var side: int = report["side"]
	var zone: int = report["zone"]
	var source: Vector2 = _zone_center(side,zone)
	var target: Vector2 = _zone_center(1-side,report["target"]) if report["target"] >= 0 else Vector2(870 if side == 0 else 420,112)
	var ghost := CardView.new()
	ghost.data = report["card"].duplicate(true)
	ghost.data["attacked"] = false
	ghost.disabled = true
	ghost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var origin: Vector2 = source-Vector2(73,71)
	_place(ghost,fx,Rect2(origin,Vector2(146,142)))
	var tween := ghost.create_tween()
	tween.tween_property(ghost,"position",origin.lerp(target-Vector2(73,71),0.48),0.17).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(func(): fx.strike(source,target); fx.burst(target,Color("#f4b485")))
	tween.tween_property(ghost,"position",origin,0.23)
	tween.tween_property(ghost,"modulate:a",0.0,0.12)
	tween.tween_callback(ghost.queue_free)
