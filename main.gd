extends Control
const Duel = preload("res://scripts/duel.gd")
const Catalog = preload("res://scripts/catalog.gd")
const AI = preload("res://scripts/ai.gd")
const CardView = preload("res://scripts/card_view.gd")
const Arena = preload("res://scripts/arena.gd")
const Effects = preload("res://scripts/effects.gd")

const GOLD = Color("#d9bc85")
const MUTED = Color("#87a5b3")
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
var detail_desc: Label
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
	node.add_theme_color_override("font_disabled_color",Color("#526776"))
	node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	node.pressed.connect(callback)
	_place(node,parent,rect)
	return node

func _build_ui() -> void:
	var arena := Arena.new()
	_place(arena,self,Rect2(0,0,1600,900))
	_label(self,"E L D O R I A",Rect2(32,17,380,40),30,GOLD)
	_label(self,"CHRONICLES OF THE FIRST LIGHT",Rect2(34,57,470,20),11,MUTED)
	_label(self,"DUEL SOLO  /  ARENA ASTRAL",Rect2(676,28,430,26),13,MUTED)
	_button(self,"Panduan",Rect2(1320,25,110,38),func(): help_layer.show())
	_button(self,"Menu",Rect2(1444,25,120,38),_open_menu)
	_panel(self,Rect2(30,100,280,765))
	_label(self,"A R S I P   K A R T U",Rect2(50,118,240,26),13,GOLD)
	detail_card = CardView.new()
	detail_card.large = true
	detail_card.disabled = true
	detail_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(detail_card,self,Rect2(48,164,244,310))
	detail_type = _label(self,"",Rect2(50,493,238,22),12,CYAN)
	detail_desc = _label(self,"",Rect2(50,528,238,150),17,LIGHT)
	detail_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_label(self,"CARA BERMAIN",Rect2(50,704,238,25),12,GOLD)
	var tip := _label(self,"Pilih kartu di tangan, lalu zona tujuan.\n\nBattle: pilih monstermu, lalu target lawan.\n\nNaga Bara perlu 1 tribute.",Rect2(50,741,238,105),14,MUTED)
	tip.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	# Profil duelist dan indikator LP.
	for side in range(2):
		var x: float = 350 if side == 0 else 974
		_panel(self,Rect2(x,101,282,67),Color("#40505a"))
		_label(self,"KAMU / PENJAGA FAJAR" if side == 0 else "NYX / ORACLE REMBULAN",Rect2(x+14,109,253,17),11,CYAN if side == 0 else GOLD)
		var lp_label := _label(self,"4000 LP",Rect2(x+14,130,128,29),24,LIGHT)
		profile_lp.append(lp_label)
		var bar := ProgressBar.new()
		bar.max_value = 4000
		bar.value = 4000
		bar.show_percentage = false
		bar.add_theme_stylebox_override("background",_style(Color("#182b34"),Color("#182b34"),3))
		bar.add_theme_stylebox_override("fill",_style(CYAN if side == 0 else GOLD,CYAN if side == 0 else GOLD,3))
		_place(bar,self,Rect2(x+141,142,126,6))
		profile_bars.append(bar)
	phase_label = _label(self,"",Rect2(652,107,300,51),19,GOLD)
	phase_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label(self,"MONSTER LAWAN",Rect2(548,180,300,22),11,MUTED)
	_label(self,"MONSTER PEMAIN",Rect2(548,423,300,22),11,CYAN)
	for side in range(2):
		for index in range(3):
			var view := CardView.new()
			view.empty_caption = "ZONA %s" % ["I","II","III"][index]
			_place(view,self,Rect2(548+174*index,210 if side == 1 else 453,144,172))
			view.pressed.connect(_zone_clicked.bind(side,index))
			view.mouse_entered.connect(_zone_hover.bind(side,index))
			zone_views[side].append(view)
	# Tumpukan deck dan graveyard di sisi arena.
	for side in range(2):
		var x: int = 360 if side == 0 else 1130
		var y: int = 475 if side == 0 else 235
		var back := CardView.new()
		back.back = true
		back.disabled = true
		_place(back,self,Rect2(x,y,96,107))
		deck_labels.append(_label(self,"",Rect2(x-10,y+114,119,23),12,GOLD))
		grave_labels.append(_label(self,"",Rect2(x-10,y+140,125,23),11,MUTED))
	enemy_hand = HBoxContainer.new()
	enemy_hand.add_theme_constant_override("separation",5)
	_place(enemy_hand,self,Rect2(844,180,300,22))
	status_label = _label(self,"",Rect2(350,638,900,33),15,CYAN)
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hand_label = _label(self,"",Rect2(350,677,600,22),12,GOLD)
	mode_button = _button(self,"Summon: MENYERANG",Rect2(1031,670,225,30),_toggle_summon_mode)
	mode_button.add_theme_font_size_override("font_size",13)
	hand_scroll = ScrollContainer.new()
	hand_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	hand_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_place(hand_scroll,self,Rect2(346,712,918,176))
	hand_box = HBoxContainer.new()
	hand_box.add_theme_constant_override("separation",12)
	hand_scroll.add_child(hand_box)
	_panel(self,Rect2(1290,100,280,765))
	_label(self,"D U E L   L O G",Rect2(1310,118,240,25),13,GOLD)
	log_view = RichTextLabel.new()
	log_view.add_theme_font_size_override("normal_font_size",14)
	log_view.add_theme_color_override("default_color",MUTED)
	log_view.scroll_following = true
	_place(log_view,self,Rect2(1310,158,240,287))
	_label(self,"KOMANDO",Rect2(1310,472,240,24),12,GOLD)
	battle_button = _button(self,"MASUK BATTLE",Rect2(1310,513,240,44),_battle)
	direct_button = _button(self,"SERANG LANGSUNG",Rect2(1310,513,240,44),_direct)
	end_button = _button(self,"AKHIRI GILIRAN  →",Rect2(1310,572,240,51),_end_turn,true)
	skill_button = _button(self,"✦  Kebangkitan Fajar",Rect2(1310,640,240,44),_skill)
	skill_button.tooltip_text = "Sekali per duel. Pulihkan 800 LP saat LP 2500 atau kurang."
	position_button = _button(self,"UBAH POSISI",Rect2(1310,699,240,38),_change_position)
	var note := _label(self,"1 normal summon / giliran\nSpell dapat dimainkan saat Main.",Rect2(1310,755,240,41),12,MUTED)
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	audio_button = _button(self,"AUDIO: ON",Rect2(1310,813,240,32),_toggle_audio)
	audio_button.add_theme_font_size_override("font_size",12)
	fx = Effects.new()
	_place(fx,self,Rect2(0,0,1600,900))
	_build_menu()
	_build_help()
	_build_result()

func _overlay() -> Control:
	var node := Control.new()
	_place(node,self,Rect2(0,0,1600,900))
	var shade := ColorRect.new()
	shade.color = Color(0.018,0.029,0.053,0.96)
	_place(shade,node,Rect2(0,0,1600,900))
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
	art.modulate = Color(0.8,0.83,0.86,0.8)
	_place(art,menu_layer,Rect2(820,0,780,900))
	_panel(menu_layer,Rect2(100,130,630,620),Color("#4b4a43"))
	_label(menu_layer,"O R I G I N A L   C A R D   D U E L",Rect2(144,180,520,30),14,GOLD)
	var title := _label(menu_layer,"ELDORIA",Rect2(138,236,570,105),82,LIGHT)
	var title_font := SystemFont.new()
	title_font.font_names = PackedStringArray(["Georgia"])
	title.add_theme_font_override("font",title_font)
	_label(menu_layer,"CHRONICLES OF THE FIRST LIGHT",Rect2(145,345,530,30),16,GOLD)
	var story := _label(menu_layer,"Cahaya terakhir Eldoria ada di tanganmu.\nBangun barisan monster, kuasai magi,\ndan hadapi Nyx di Arena Astral.",Rect2(145,408,530,116),23,LIGHT)
	story.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_button(menu_layer,"MULAI DUEL  →",Rect2(145,559,520,63),_start_from_menu,true)
	_button(menu_layer,"Pelajari aturan",Rect2(145,642,250,45),func(): help_layer.show())
	_label(menu_layer,"SOLO vs AI   /   20 KARTU   /   4000 LP",Rect2(145,710,520,24),12,MUTED)
	_label(menu_layer,"PROTOTIPE 0.3   •   MADE WITH GODOT",Rect2(110,821,650,30),12,MUTED)

func _build_help() -> void:
	help_layer = _overlay()
	_panel(help_layer,Rect2(380,90,840,720),Color("#887451"))
	_label(help_layer,"Panduan Duel Eldoria",Rect2(425,120,750,50),32,GOLD)
	var body := RichTextLabel.new()
	body.add_theme_font_size_override("normal_font_size",18)
	body.add_theme_color_override("default_color",LIGHT)
	body.bbcode_enabled = true
	body.text = "[color=#d9bc85]01   MAIN PHASE[/color]\nPilih monster dari tangan, lalu zona kosong untuk summon. Satu normal summon per giliran. Pilih mode menyerang / bertahan sebelum summon. Naga Bara perlu 1 tribute.\n\n[color=#d9bc85]02   SPELL & EFEK[/color]\nKlik spell: aktifkan langsung atau pilih target sesuai panel detail. Berkah Fajar menargetkan monstermu; Retakan Langit menargetkan monster lawan dengan ATK 1800 atau kurang.\n\n[color=#d9bc85]03   BATTLE PHASE[/color]\nKlik Masuk Battle, pilih monster posisi menyerang, lalu monster lawan. Jika papan lawan kosong, klik Serang Langsung. Setiap monster menyerang sekali. Pemain pertama tidak menyerang pada giliran pertama.\n\n[color=#d9bc85]04   STRATEGI[/color]\nLawan posisi menyerang: selisih ATK menjadi kerusakan LP. Lawan bertahan: gunakan DEF; menang tidak memberi kerusakan LP. Ubah posisi mulai giliran setelah summon. Skill memulihkan 800 LP, sekali saat LP 2500 atau kurang.\n\n[color=#d9bc85]05   MENANG[/color]\nTurunkan LP lawan ke 0. Kehabisan deck saat harus draw juga menyebabkan kalah. Akhiri giliran untuk memberi giliran kepada Nyx."
	_place(body,help_layer,Rect2(425,195,750,500))
	_button(help_layer,"MENGERTI",Rect2(425,731,750,48),func(): help_layer.hide(),true)
	help_layer.hide()

func _build_result() -> void:
	result_layer = _overlay()
	_panel(result_layer,Rect2(510,220,580,460),GOLD)
	_label(result_layer,"A R E N A   A S T R A L",Rect2(555,260,490,30),13,GOLD)
	result_title = _label(result_layer,"VICTORY",Rect2(555,323,490,78),58,LIGHT)
	result_description = _label(result_layer,"",Rect2(555,420,490,80),19,MUTED)
	result_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_button(result_layer,"DUEL LAGI",Rect2(555,527,490,50),_start_from_menu,true)
	_button(result_layer,"Kembali ke menu",Rect2(555,595,490,42),_open_menu)
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
	result_layer.hide()
	help_layer.hide()
	menu_layer.show()

func _clear_children(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()

func _render() -> void:
	for side in range(2):
		profile_lp[side].text = "%d LP" % duel.lp[side]
		profile_bars[side].value = duel.lp[side]
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
			view.queue_redraw()
	phase_label.text = "GILIRAN %02d\n%s / %s" % [duel.turn_number,"KAMU" if duel.turn == 0 else "NYX",duel.phase]
	_clear_children(hand_box)
	for index in range(duel.hands[0].size()):
		var card := CardView.new()
		card.data = duel.hands[0][index]
		card.selected = index == selected_hand
		card.custom_minimum_size = Vector2(116,160)
		card.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		hand_box.add_child(card)
		card.pressed.connect(_hand_clicked.bind(index))
		card.mouse_entered.connect(_hand_hover.bind(index))
		card.tooltip_text = card.data["text"]
	_clear_children(enemy_hand)
	for i in range(mini(duel.hands[1].size(),8)):
		var back := CardView.new()
		back.back = true
		back.disabled = true
		back.custom_minimum_size = Vector2(28,20)
		enemy_hand.add_child(back)
	hand_label.text = "TANGAN / %02d KARTU     •     NYX / %02d KARTU" % [duel.hands[0].size(),duel.hands[1].size()]
	var active: bool = duel.turn == 0 and not duel.over
	battle_button.visible = duel.phase == "MAIN"
	battle_button.disabled = not active or duel.turn_number == 1
	direct_button.visible = duel.phase == "BATTLE"
	direct_button.disabled = not active or selected_zone < 0 or duel.has_monsters(1)
	end_button.disabled = not active
	skill_button.disabled = not active or duel.phase != "MAIN" or duel.skill_used[0] or int(duel.lp[0]) > 2500
	skill_button.text = "SKILL SUDAH DIGUNAKAN" if duel.skill_used[0] else "✦  Kebangkitan Fajar"
	position_button.disabled = not active or duel.phase != "MAIN" or selected_zone < 0
	mode_button.disabled = not active or duel.phase != "MAIN"
	mode_button.text = "Summon: BERTAHAN" if summon_defense else "Summon: MENYERANG"

func _inspect(card: Dictionary) -> void:
	if card.is_empty():
		return
	detail_card.data = card
	detail_card.queue_redraw()
	detail_type.text = "SPELL / MAGI AKTIF" if card["kind"] == "spell" else "%s / LEVEL %d" % [card["element"],card["level"]]
	detail_desc.text = card["text"]

func _hand_hover(index: int) -> void:
	if index < duel.hands[0].size():
		_inspect(duel.hands[0][index])

func _zone_hover(side: int, zone: int) -> void:
	_inspect(duel.fields[side][zone])

func _can_input() -> bool:
	return duel.turn == 0 and not duel.over and not menu_layer.visible and not help_layer.visible

func _hand_clicked(index: int) -> void:
	if not _can_input():
		return
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
		fx.strike(from,Vector2(1100,136))
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
	selected_hand = -1
	selected_zone = -1
	duel.end_turn()
	_banner("GILIRAN NYX",GOLD)
	_run_ai(session)

func _run_ai(token: int) -> void:
	await get_tree().create_timer(0.8).timeout
	var steps: int = 0
	while token == session and duel.turn == 1 and not duel.over and steps < 45:
		if help_layer.visible:
			await get_tree().create_timer(0.2).timeout
			continue
		steps += 1
		var action: Dictionary = AI.main_action(duel) if duel.phase == "MAIN" else AI.battle_action(duel)
		if action["type"] == "attack":
			var target: Vector2 = _zone_center(0,action["target"]) if action["target"] >= 0 else Vector2(476,136)
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
	return Vector2(620+174*maxi(zone,0),296 if side == 1 else 539)

func _visual(kind: String, side: int, zone: int, amount: int) -> void:
	if starting:
		return
	match kind:
		"summon":
			fx.burst(_zone_center(side,zone),GOLD)
			_sound("summon")
		"spell":
			fx.burst(Vector2(804,414),CYAN)
			_sound("spell")
		"attack":
			fx.burst(_zone_center(side,zone),GOLD)
			_sound("attack")
		"damage":
			_float_text("−%d LP" % amount,Vector2(460 if side == 0 else 1080,110),Color("#ff8e85"))
		"heal":
			_float_text("+%d LP" % amount,Vector2(460 if side == 0 else 1080,110),CYAN)
			_sound("heal")
		"shield": fx.burst(_zone_center(side,zone),CYAN)
		"draw": _sound("draw")

func _float_text(text_value: String, point: Vector2, color: Color) -> void:
	var node := _label(fx,text_value,Rect2(point,Vector2(200,45)),29,color)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(node,"position:y",point.y-65,1.0)
	tween.tween_property(node,"modulate:a",0.0,1.0).set_delay(0.3)
	tween.chain().tween_callback(node.queue_free)

func _banner(text_value: String, color: Color) -> void:
	var node := _label(fx,text_value,Rect2(510,392,580,52),30,color)
	node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var tween := create_tween()
	tween.tween_interval(0.7)
	tween.tween_property(node,"modulate:a",0.0,0.5)
	tween.tween_callback(node.queue_free)

func _finished(winning_side: int) -> void:
	selected_hand = -1
	selected_zone = -1
	result_title.text = "VICTORY" if winning_side == 0 else "DEFEAT"
	result_title.add_theme_color_override("font_color",GOLD if winning_side == 0 else Color("#da919b"))
	result_description.text = "%s\nDuel selesai pada giliran %d." % ["Cahaya Eldoria tetap menyala. Nyx telah dikalahkan." if winning_side == 0 else "Nyx menguasai arena. Susun strategi dan coba lagi.",duel.turn_number]
	_sound("win" if winning_side == 0 else "lose")
	result_layer.show()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if help_layer.visible:
			help_layer.hide()
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