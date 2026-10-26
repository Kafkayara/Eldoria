extends Control
const Hints = preload("res://scripts/duel_hints.gd")
const Summary = preload("res://scripts/duel_summary.gd")
const Duel = preload("res://scripts/duel.gd")
const Catalog = preload("res://scripts/catalog.gd")
const AI = preload("res://scripts/ai.gd")
const CardView = preload("res://scripts/card_view.gd")
const Arena = preload("res://scripts/arena.gd")
const AceCutin = preload("res://scripts/ace_cutin.gd")
const Effects = preload("res://scripts/effects.gd")
const DeckStore = preload("res://scripts/deck_store.gd")
const Gallery = preload("res://scripts/gallery.gd")

const GOLD = Color("#c6ae7d")
const MUTED = Color("#b2c7d2")
const LIGHT = Color("#eff1ed")
const CYAN = Color("#8bb6b9")

var duel = Duel.new()
var duel_summary = Summary.new()
var settings_layer: Control
var quick_guide_layer: Control
var settings_music: HSlider
var settings_sfx: HSlider
var music_value: Label
var sfx_value: Label
var speed_select: OptionButton
var reduced_check: CheckBox
var quick_title: Label
var quick_text: Label
var guide_previous: Button
var guide_next: Button
var guide_page: int = 0
var result_summary: RichTextLabel
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
var detail_lore: RichTextLabel
var detail_desc: RichTextLabel
var phase_label: Label
var status_label: Label
var hand_label: Label
var log_view: RichTextLabel
var battle_button: Button
var undo_button: Button
var response_undo_button: Button
var result_undo_button: Button
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
var urgency_music: AudioStreamPlayer
var music_slider: HSlider
var music_tween: Tween
var music_targets: Array = []
var ace_seen: Dictionary = {}
var ace_active_until: float = 0.0
var sfx: Array[AudioStreamPlayer] = []
var sound_streams: Dictionary = {}
var context_label: Label
var log_panel: Panel
var zoom_layer: Control
var zoom_card
var zoom_title: Label
var zoom_type: Label
var zoom_stats: Label
var zoom_lore: RichTextLabel
var zoom_description: RichTextLabel
var zoom_close_button: Button
var zoom_hint: Label
var inspected_card: Dictionary = {}
var hover_card
var hover_serial: int = 0
var combat_serial: int = 0
var combat_notice: Panel
var combat_label: Label
var displayed_lp: Array = [4000.0,4000.0]
var lp_targets: Array = [4000,4000]
var lp_tweens: Array = [null,null]
var gallery
var effects_button: Button
var impact_until: float = 0.0
var collection_store = DeckStore.new()
var deck_select: OptionButton
var enemy_select: OptionButton
var ai_select: OptionButton
var backrow_views: Array = [[],[]]
var response_layer: Control
var response_text: RichTextLabel
var response_buttons: Array = []
var response_pending: bool = false
var trap_presenting: bool = false
var trap_visuals: Array = []
var delayed_combats: Array = []
var delayed_health: Array = []
var delayed_shields: Array = []
var delayed_card_cues: Array = []
var coin_layer: Control
var coin_face
var coin_result: Label
var coin_continue: Button
var coin_side: int = -1
var coin_tween: Tween


func _ready() -> void:
	CardView.allow_art_motion = true
	var app_theme := Theme.new()
	var ui_font := SystemFont.new()
	ui_font.font_names = PackedStringArray(["Segoe UI", "Arial"])
	app_theme.default_font = ui_font
	app_theme.default_font_size = 17
	theme = app_theme
	collection_store.load_data()
	if not Catalog.PRESETS.has(collection_store.active): collection_store.active = "fajar"
	_build_ui()
	_build_audio()
	_apply_comfort_preferences()
	duel_summary.reset()
	duel.combat.connect(func(report): duel_summary.combat(report,duel.turn_number,duel.lp))
	duel.card_cue.connect(func(cue):
		if not duel.over: duel_summary.cue(cue,duel.turn_number))
	duel.visual.connect(func(kind,side,_zone,amount): duel_summary.visual(kind,side,amount,duel.lp))
	duel.checkpoint_created.connect(_capture_undo_ui)
	duel.undone.connect(_restore_undo_ui)
	duel.changed.connect(_render)
	duel.message.connect(_message)
	duel.visual.connect(_visual)
	duel.finished.connect(_finished)
	duel.combat.connect(_combat_explained)
	duel.card_cue.connect(_card_visual)
	_new_duel()
	menu_layer.show()

func _style(bg: Color, edge: Color, radius: int = 3) -> StyleBoxFlat:
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
	node.add_theme_stylebox_override("panel", _style(Color(0.035,0.055,0.061,0.98),edge))
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
	var bg: Color = Color("#b4a078") if primary else Color("#142937")
	node.add_theme_stylebox_override("normal",_style(bg, GOLD if primary else Color("#3c5966"),3))
	node.add_theme_stylebox_override("hover",_style(bg.lightened(0.12),GOLD,3))
	node.add_theme_stylebox_override("pressed",_style(bg.darkened(0.15),GOLD,3))
	node.add_theme_stylebox_override("disabled",_style(Color("#101c27"),Color("#253541"),3))
	node.add_theme_stylebox_override("focus",_style(Color(0,0,0,0),CYAN,3))
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
	var brand := _label(self,"ELDORIA",Rect2(20,11,280,43),32,GOLD)
	var brand_font := SystemFont.new()
	brand_font.font_names = PackedStringArray(["Georgia"])
	brand.add_theme_font_override("font",brand_font)
	_label(self,"ARENA ASTRAL / DUEL SOLO",Rect2(322,25,420,25),15,MUTED)
	effects_button = _button(self,"EFEK: NORMAL",Rect2(726,18,178,38),_toggle_effect_mode)
	effects_button.add_theme_font_size_override("font_size",14)
	_button(self,"Log duel",Rect2(916,18,105,38),_toggle_log)
	_button(self,"Panduan",Rect2(1033,18,105,38),func(): _hide_hover(); help_layer.show())
	_button(self,"Menu",Rect2(1150,18,112,38),_open_menu)
	_panel(self,Rect2(18,80,260,624),Color("#4d6672"))
	_label(self,"DETAIL KARTU",Rect2(34,96,225,26),16,GOLD)
	detail_card = CardView.new()
	detail_card.large = true
	detail_card.disabled = true
	detail_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(detail_card,self,Rect2(32,136,232,230))
	detail_type = _label(self,"",Rect2(34,377,226,23),14,CYAN)
	_label(self,"EFEK KARTU",Rect2(34,409,226,22),14,CYAN)
	detail_desc = RichTextLabel.new()
	detail_desc.add_theme_font_size_override("normal_font_size",17)
	detail_desc.add_theme_color_override("default_color",LIGHT)
	_place(detail_desc,self,Rect2(34,435,226,91))
	_label(self,"CERITA",Rect2(34,530,226,22),14,GOLD)
	detail_lore = _reading_text(self,Rect2(34,558,226,61),15,MUTED)
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
	context_label = _label(self,"",Rect2(1028,133,216,114),14,LIGHT)
	battle_button = _button(self,"MASUK BATTLE",Rect2(1028,257,216,46),_battle)
	direct_button = _button(self,"SERANG LANGSUNG",Rect2(1028,257,216,46),_direct)
	position_button = _button(self,"UBAH POSISI",Rect2(1028,317,216,43),_change_position)
	skill_button = _button(self,"Kebangkitan Fajar",Rect2(1028,375,216,47),_skill)
	skill_button.tooltip_text = "Sekali per duel: pulihkan 800 LP saat LP 2500 atau kurang."
	end_button = _button(self,"AKHIRI GILIRAN",Rect2(1028,438,216,52),_end_turn,true)
	undo_button = _button(self,"UNDO / Ctrl+Z",Rect2(1028,509,216,43),_undo_action)
	undo_button.tooltip_text = "Batalkan langkah pemain. Tersedia sampai Akhiri Giliran ditekan."
	_button(self,"BUKA LOG DUEL",Rect2(1028,570,216,41),_toggle_log)
	audio_button = _button(self,"AUDIO: ON",Rect2(1028,633,216,40),_toggle_audio)
	audio_button.add_theme_font_size_override("font_size",14)
	_label(self,"BGM",Rect2(1028,678,39,22),12,MUTED)
	music_slider = HSlider.new()
	music_slider.min_value = 0
	music_slider.max_value = 100
	music_slider.step = 1
	music_slider.value = collection_store.music_gain*100
	music_slider.tooltip_text = "Volume musik. Efek suara tetap terpisah."
	_place(music_slider,self,Rect2(1075,680,169,20))
	music_slider.value_changed.connect(_music_volume_changed)
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
	fx.occlusion_check = _effects_obscured
	combat_notice = _panel(fx,Rect2(298,480,694,35),GOLD)
	combat_notice.mouse_filter = Control.MOUSE_FILTER_IGNORE
	combat_label = _label(combat_notice,"",Rect2(10,3,674,29),17,LIGHT)
	combat_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	combat_notice.hide()
	hover_card = CardView.new()
	hover_card.large = true
	hover_card.disabled = true
	hover_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hover_card.z_index = 2
	_place(hover_card,self,Rect2(560,215,238,300))
	hover_card.hide()
	_build_menu()
	_build_help()
	_build_result()
	_build_gallery()
	_build_zoom()
	_build_coin()
	_build_strategy_ui()
	_build_comfort_ui()

func _overlay() -> Control:
	var node := Control.new()
	_place(node,self,Rect2(0,0,1280,720))
	var shade := ColorRect.new()
	shade.color = Color(0.018,0.029,0.053,0.99)
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
	_label(menu_layer,"Pilih deck dan tantang Nyx di Arena Astral.",Rect2(99,328,508,29),18,LIGHT)
	_button(menu_layer,"MULAI DUEL",Rect2(99,479,508,58),_start_from_menu,true)
	_button(menu_layer,"GALERI KARTU",Rect2(99,552,246,45),_open_gallery)
	_button(menu_layer,"Cara bermain",Rect2(361,552,246,45),_open_quick_guide)
	_label(menu_layer,"DECK BAWAAN / 20 KARTU / KOLEKSI DI GALERI",Rect2(99,606,508,26),14,MUTED)
	_label(menu_layer,"VERSI 0.15 / KENYAMANAN DUEL",Rect2(65,663,600,29),14,MUTED)

func _build_help() -> void:
	help_layer = _overlay()
	_panel(help_layer,Rect2(222,50,836,620),Color("#ae945e"))
	_label(help_layer,"Panduan Duel Eldoria",Rect2(252,74,570,45),28,GOLD)
	_button(help_layer,"Panduan singkat",Rect2(846,81,182,33),_open_quick_guide)
	var body := RichTextLabel.new()
	body.add_theme_font_size_override("normal_font_size",19)
	body.add_theme_color_override("default_color",LIGHT)
	body.bbcode_enabled = true
	body.text = "[color=#dfbf81]01  MEMBACA KARTU[/color]\nArahkan kursor untuk pratinjau besar. Klik kanan kartu, tekan E, atau pilih Perbesar Kartu untuk membaca efek lengkap. Klik kiri dipakai untuk bermain.\n\n[color=#dfbf81]02  MAIN PHASE[/color]\nPilih monster di tangan, pilih mode menyerang / bertahan, lalu klik zona tujuan yang menyala. Satu normal summon per giliran. Naga Bara perlu satu tribute.\n\n[color=#dfbf81]03  SPELL[/color]\nBadai Aether dan Suaka Surya aktif langsung. Berkah Fajar menargetkan monstermu; Retakan Langit menargetkan monster lawan dengan ATK 1800 atau kurang.\n\n[color=#dfbf81]04  BATTLE PHASE[/color]\nKlik Masuk Battle, pilih monstermu yang bisa menyerang, lalu klik monster lawan yang menyala. Jika papan lawan kosong, pilih Serang Langsung. Satu serangan per monster. Pemain pertama tidak menyerang pada giliran pertama.\n\n[color=#dfbf81]05  DAMAGE & STRATEGI[/color]\nLawan posisi menyerang: selisih ATK mengurangi LP. Lawan bertahan memakai DEF; menang tidak memberi kerusakan LP kecuali penyerang memiliki MENEMBUS. Penjelasan hitungan muncul saat serangan. Ubah posisi mulai giliran setelah summon. Skill memulihkan 800 LP sekali saat LP 2500 atau kurang.\n\n[color=#dfbf81]06  MENANG[/color]\nTurunkan LP lawan ke 0 atau buat lawan kehabisan deck saat draw. Buka Log Duel untuk membaca riwayat. Esc menutup detail / panduan atau membuka menu."
	body.text += "\n\n[color=#dfbf81]07  ZONA SPELL / TRAP[/color]\nMasing-masing pihak punya tiga zona. Pilih trap di tangan, lalu klik zona spell/trap kosong milikmu. Trap dipasang tertutup dan baru dapat merespons mulai giliran berikutnya. Identitas trap lawan tetap tersembunyi. Spell dari tangan memakai satu zona sementara dan masuk grave setelah selesai; jika ketiga zona penuh, spell tidak dapat diaktifkan.\n\n[color=#dfbf81]08  RANTAI RESPONS[/color]\nJendela respons muncul jika ada trap yang sah. Pilih trap atau Lewati, lalu lawan mendapat kesempatan membalas. Dua lewat berturut-turut menyelesaikan rantai dari efek terakhir ke pertama. Cermin membatalkan serangan; Belenggu menurunkan ATK sebelum damage; Segel membatalkan spell/trap terakhir, termasuk Segel lawan. Efek summon dan skill belum bisa dibalas oleh tiga trap ini.\n\n[color=#dfbf81]09  DECK & AI[/color]\nMenu menyediakan deck Fajar (serangan) dan Gerhana (kontrol). Untuk saat ini duel hanya memakai dua deck bawaan. Koleksi tetap dapat dibaca di Galeri Kartu; editor deck dinonaktifkan. Santai memakai pilihan sederhana dan kadang melewatkan respons; Normal memakai heuristik dasar; Sulit menilai tribute, pertahanan awal, dan memilih pembatalan lebih hemat. Nyx tidak membaca identitas jebakan tertutupmu."
	body.text += "\n\n[color=#dfbf81]10  UNDO / Ctrl+Z[/color]\nPada giliranmu, tombol Undo mengembalikan satu langkah beserta seluruh akibatnya: kartu, LP, hasil draw, tribute, skill, dan respons trap. Undo juga dapat dipakai saat menunggu respons Nyx atau sebelum hasil duel dikonfirmasi. Riwayat ditutup setelah Akhiri Giliran; kamu tidak dapat mundur melewati giliran lawan. Tidak ada pengacakan ulang kartu saat undo.\n\n[color=#dfbf81]11  MUSIK[/color]\nJejak Fajar adalah komposisi orisinal 2 menit 40 detik, memakai instrumen berbasis sampel: seruling, senar, koto, piano, dan perkusi lembut. Bagian akhir kembali ke awal tanpa fade-out. Slider BGM mengatur musik tanpa mengubah efek suara."
	body.text += "\n\n[color=#dfbf81]12  FAJAR VS GERHANA[/color]\nFajar memakai 13 monster, 6 spell, dan 1 trap. Naga Bara kini 2500 ATK dan tetap memberi 300 damage saat summon. Penjaga Fajar 1700 ATK. Tiga Peri Astral membantu mengambil kartu; Pasang Segel Hening terlebih dahulu agar mulai giliran berikutnya bisa membalas Cermin atau Belenggu. Naga Noctis tetap 2300 ATK dan bertahan dari kehancuran battle sekali. Bara unggul dalam tekanan serangan; Noctis unggul dalam ketahanan. Perhatikan trap dan gunakan Berkah Fajar sebelum Battle.\n"
	body.text += "\n\n[color=#dfbf81]13  KOMBINASI DECK[/color]\nFAJAR: Tombak Surya memberi +500 ATK, -300 DEF, dan MENEMBUS selama monster di papan. Selisih ATK atas DEF mengurangi LP meskipun target memakai perisai. Contoh: Penjaga Fajar 1700 + Tombak 500 melawan Burung Hantu DEF 2000 memberikan 200 damage. Berkah Fajar dapat ditambahkan; siapkan Segel Hening untuk melawan trap. DEF yang turun membuat perubahan ke posisi bertahan lebih berisiko.\n\nGERHANA: Selubung Gerhana memberi +400 ATK/DEF dan satu perisai. Pakai pada Noctis setelah perisainya habis untuk bertahan lalu menyerang balik. Perisai tidak menumpuk dan tidak melindungi LP atau penghancuran oleh spell. Cermin membatalkan serangan menembus; Belenggu mengurangi ATK sebelum selisih dihitung; Segel dapat membatalkan kedua spell baru.\n\nMasing-masing deck tetap 20 kartu dan memuat satu kartu baru. Lihat ilustrasi, cerita, serta efek lengkap di Galeri Kartu."
	body.text += "\n\n[color=#dfbf81]14  PENGATURAN & HASIL[/color]\nBuka Pengaturan di menu atau kanan papan. Volume musik dan efek suara terpisah. Kecepatan animasi 1x / 1,5x / 2x tidak mengubah tempo musik. Efek ringkas mengurangi gerakan; pilihan tersimpan otomatis. Panduan singkat menjelaskan inti duel dalam tiga halaman. Layar hasil merangkum LP, kerusakan, pemulihan, trap, serangan terbesar, dan momen terakhir. Aksi yang di-Undo ikut dihapus dari ringkasan.\n"
	_place(body,help_layer,Rect2(252,135,776,443))
	_button(help_layer,"MENGERTI",Rect2(252,600,776,45),func(): help_layer.hide(),true)
	help_layer.hide()

func _build_result() -> void:
	result_layer = _overlay()
	_panel(result_layer,Rect2(250,52,780,616),GOLD)
	result_title = _label(result_layer,"VICTORY",Rect2(286,85,708,70),54,LIGHT)
	result_description = _label(result_layer,"",Rect2(286,163,708,58),18,MUTED)
	result_summary = _reading_text(result_layer,Rect2(286,235,708,237),17,LIGHT)
	_button(result_layer,"DUEL LAGI",Rect2(286,493,340,45),_start_from_menu,true)
	_button(result_layer,"Kembali ke menu",Rect2(644,493,350,45),_open_menu)
	result_undo_button = _button(result_layer,"UNDO LANGKAH TERAKHIR",Rect2(286,552,708,42),_undo_action)
	_label(result_layer,"Ringkasan mengikuti aksi yang tetap berlaku setelah Undo.",Rect2(286,617,708,23),13,MUTED)
	result_layer.hide()

func _build_audio() -> void:
	music = AudioStreamPlayer.new()
	add_child(music)
	var stream: AudioStreamOggVorbis = load("res://assets/audio/path_of_dawn.ogg")
	stream.loop = true
	stream.loop_offset = 0.0
	music.stream = stream
	music.volume_db = -20
	urgency_music = AudioStreamPlayer.new()
	add_child(urgency_music)
	var layer: AudioStreamOggVorbis = load("res://assets/audio/path_of_dawn_strings.ogg")
	layer.loop = true
	layer.loop_offset = 0.0
	urgency_music.stream = layer
	urgency_music.volume_db = -80
	music.play()
	urgency_music.play()
	_sync_music(true)
	for i in range(5):
		var player := AudioStreamPlayer.new()
		player.volume_db = -12
		add_child(player)
		sfx.append(player)
	for name_value in ["click","draw","summon","attack","spell","heal","win","lose","ace_summon","heavy_impact","trap_reveal"]:
		sound_streams[name_value] = load("res://assets/audio/%s.wav" % name_value)

func _sound(name_value: String) -> void:
	if muted or starting or collection_store.sfx_gain <= 0 or not sound_streams.has(name_value):
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
	urgency_music.stream_paused = muted
	for player in sfx:
		if muted:
			player.stop()
	audio_button.text = "AUDIO: OFF" if muted else "AUDIO: ON"

func _new_duel(first_side: int = 0) -> void:
	session += 1
	_reset_visuals()
	if is_instance_valid(response_layer): response_layer.hide()
	response_pending = false
	gallery.hide()
	zoom_layer.hide()
	log_panel.hide()
	history.clear()
	duel_summary.reset()
	selected_hand = -1
	selected_zone = -1
	summon_defense = false
	result_layer.hide()
	starting = true
	duel.difficulty = collection_store.difficulty
	duel.start(-1,first_side,Catalog.PRESETS.get(collection_store.active,Catalog.PRESETS["fajar"])["cards"],Catalog.PRESETS.get(collection_store.enemy,Catalog.PRESETS["gerhana"])["cards"])
	starting = false
	_inspect(Catalog.card("dawn"))
	_render()

func _start_from_menu() -> void:
	session += 1
	_reset_visuals()
	_hide_hover()
	for layer in [menu_layer,help_layer,result_layer,zoom_layer,gallery,response_layer,settings_layer,quick_guide_layer]:
		layer.hide()
	coin_side = -1
	coin_face.face = -1
	coin_face.queue_redraw()
	coin_result.text = "Koin sedang dilempar..."
	coin_continue.disabled = true
	coin_layer.show()
	_sync_music()
	if coin_tween and coin_tween.is_valid():
		coin_tween.kill()
	var outcome: int = randi_range(0,1)
	var token: int = session
	coin_face.pivot_offset = coin_face.size / 2.0
	coin_face.scale = Vector2.ONE
	coin_tween = create_tween()
	if not fx.reduced_motion:
		for i in range(7):
			coin_tween.tween_property(coin_face,"scale:x",0.06,_pace(0.08))
			coin_tween.tween_callback(_coin_frame.bind(i % 2))
			coin_tween.tween_property(coin_face,"scale:x",1.0,_pace(0.09))
	else:
		coin_tween.tween_interval(_pace(0.25))
	coin_tween.tween_callback(_reveal_coin.bind(outcome,token))

func _coin_frame(side: int) -> void:
	coin_face.face = side
	coin_face.queue_redraw()

func _reveal_coin(side: int, token: int) -> void:
	if token != session or not coin_layer.visible:
		return
	coin_side = side
	_coin_frame(side)
	coin_result.text = "GAMBAR / KAMU BERGERAK PERTAMA" if side == 0 else "ANGKA / NYX BERGERAK PERTAMA"
	coin_continue.disabled = false
	_sound("summon")

func _confirm_coin() -> void:
	if coin_side < 0 or coin_continue.disabled or not coin_layer.visible:
		return
	_begin_duel(coin_side)

func _begin_duel(first_side: int) -> void:
	settings_layer.hide()
	quick_guide_layer.hide()
	if coin_tween and coin_tween.is_valid():
		coin_tween.kill()
	coin_layer.hide()
	menu_layer.hide()
	help_layer.hide()
	_new_duel(first_side)
	_banner("GILIRANMU" if first_side == 0 else "GILIRAN NYX",GOLD)
	if first_side == 1:
		_run_ai(session)

func _open_menu() -> void:
	settings_layer.hide()
	quick_guide_layer.hide()
	session += 1
	coin_layer.hide()
	response_layer.hide()
	response_pending = false
	if coin_tween and coin_tween.is_valid():
		coin_tween.kill()
	gallery.hide()
	_hide_hover()
	zoom_layer.hide()
	result_layer.hide()
	help_layer.hide()
	menu_layer.show()
	_sync_music()

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
			view.action_hint = Hints.monster_status(duel,view.data) if side == 0 else ""
			view.tooltip_text = Hints.stats(view.data)
			view.selected = side == 0 and index == selected_zone
			if selected_hand >= 0 and selected_hand < duel.hands[0].size() and duel.turn == 0 and duel.phase == "MAIN":
				var chosen: Dictionary = duel.hands[0][selected_hand]
				var effect: String = chosen["effect"]
				if chosen["kind"] == "monster" and side == 0:
					view.selected = (view.data.is_empty() or int(chosen["level"]) > 4) and Hints.hand_reason(duel,chosen).is_empty()
				elif effect == "buff" and side == 0 and Hints.hand_reason(duel,chosen).is_empty():
					view.selected = not view.data.is_empty()
				elif effect == "destroy" and side == 1 and Hints.hand_reason(duel,chosen).is_empty():
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
		var reason: String = Hints.hand_reason(duel,card.data)
		card.action_hint = "BISA DIMAINKAN" if reason.is_empty() else "BELUM BISA"
		card.tooltip_text = reason if not reason.is_empty() else "Klik kiri: pilih / Klik kanan: detail besar"
	_clear_children(enemy_hand)
	for i in range(mini(duel.hands[1].size(),8)):
		var back := CardView.new()
		back.back = true
		back.disabled = true
		back.custom_minimum_size = Vector2(22,14)
		enemy_hand.add_child(back)
	hand_label.text = "TANGAN: %d KARTU / LAWAN: %d" % [duel.hands[0].size(),duel.hands[1].size()]
	var active: bool = duel.turn == 0 and not duel.over and duel.chain.is_empty() and not trap_presenting and not _ace_active()
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
	battle_button.tooltip_text = "Giliran pertama belum boleh menyerang." if duel.turn_number == 1 else "Masuk Battle; kartu tangan tidak bisa dimainkan sesudahnya."
	direct_button.tooltip_text = "Pilih monster siap menyerang dan kosongkan papan lawan."
	position_button.tooltip_text = "Pilih monster. Posisi bisa diubah sekali, mulai giliran setelah summon."
	skill_button.tooltip_text = "Sekali per duel, Main Phase, LP 2500 atau kurang: pulihkan 800 LP."
	_update_context()
	undo_button.disabled = not _can_undo_input()
	undo_button.text = "UNDO (%d) / Ctrl+Z" % duel.undo_stack.size()
	if is_instance_valid(result_undo_button): result_undo_button.visible = duel.can_undo()
	_render_backrows()
	_sync_response()
	_sync_music()

func _inspect(card: Dictionary) -> void:
	if card.is_empty():
		return
	inspected_card = card.duplicate(true)
	detail_card.data = inspected_card
	detail_card.queue_redraw()
	detail_type.text = Catalog.type_text(card)
	detail_type.tooltip_text = Hints.stats(card)
	detail_desc.text = card["text"]
	if card.get("piercing",false): detail_desc.text += "\n\nSTATUS PAPAN: MENEMBUS DEF. Selisih ATK terhadap DEF mengurangi LP lawan."
	if card.get("shield",false): detail_desc.text += "\n\nSTATUS PAPAN: PERISAI aktif (1 kehancuran akibat serangan)."
	detail_desc.scroll_to_line(0)
	detail_lore.text = card.get("lore", "")
	detail_lore.scroll_to_line(0)

func _hand_hover(index: int) -> void:
	if index >= 0 and index < duel.hands[0].size():
		_inspect(duel.hands[0][index])
		_queue_hover(duel.hands[0][index],true)
		var reason: String = Hints.hand_reason(duel,duel.hands[0][index])
		if not reason.is_empty(): context_label.text = reason

func _zone_hover(side: int, zone: int) -> void:
	var card: Dictionary = duel.fields[side][zone]
	_inspect(card)
	if not card.is_empty():
		if side == 1 and _can_input() and duel.phase == "BATTLE" and _attacker_ready():
			context_label.text = Hints.forecast(duel,duel.fields[0][selected_zone],card)
			context_label.tooltip_text = context_label.text
		else:
			_queue_hover(card)

func _can_input() -> bool:
	return not _ace_active() and not trap_presenting and duel.chain.is_empty() and not coin_layer.visible and duel.turn == 0 and not duel.over and not menu_layer.visible and not help_layer.visible and not zoom_layer.visible and not gallery.visible and not settings_layer.visible and not quick_guide_layer.visible

func _hand_clicked(index: int) -> void:
	if not _can_input() or index < 0 or index >= duel.hands[0].size():
		return
	_hide_hover()
	var card: Dictionary = duel.hands[0][index]
	_inspect(card)
	if duel.phase != "MAIN":
		_message("Kartu dari tangan hanya bisa dimainkan pada Main Phase.")
		return
	var reason: String = Hints.hand_reason(duel,card)
	if not reason.is_empty():
		selected_hand = -1
		_message(reason)
		_render()
		context_label.text = reason
		return
	_sound("click")
	selected_zone = -1
	selected_hand = -1 if selected_hand == index else index
	if selected_hand < 0:
		_message("Pilihan kartu dibatalkan.")
	elif card["kind"] == "trap":
		_message("Klik PASANG DI SINI di kanan papanmu. Aktif mulai giliran berikutnya." if duel.empty_backrow(0) >= 0 else "Ketiga zona spell/trap penuh. Jebakan ini belum dapat dipasang.")
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

		if duel.attack(selected_zone,zone):
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

	if duel.attack(selected_zone):
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
	await get_tree().create_timer(_pace(0.8)).timeout
	var steps: int = 0
	while token == session and duel.turn == 1 and not duel.over and steps < 45:
		if _ace_active() or trap_presenting or not duel.chain.is_empty() or help_layer.visible or zoom_layer.visible or gallery.visible or settings_layer.visible or quick_guide_layer.visible:
			await get_tree().create_timer(0.2).timeout
			continue
		steps += 1
		var action: Dictionary = AI.main_action(duel) if duel.phase == "MAIN" else AI.battle_action(duel)
		if not AI.apply(duel,action):
			duel.end_turn()
		if duel.turn == 1 and not duel.over:
			await get_tree().create_timer(_pace(0.65)).timeout
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
		"trap_set":
			_float_text("TRAP DIPASANG",Vector2(800,400) if side == 0 else Vector2(300,200),GOLD)
		"spell": _sound("spell")
		"attack": _sound("attack")
		"damage": _health_change(side,amount,false)
		"heal": _health_change(side,amount,true)
		"shield": _shield_at_impact(side,zone)
		"draw": _sound("draw")

func _float_text(text_value: String, point: Vector2, color: Color) -> void:
	var node := _label(fx,text_value,Rect2(point,Vector2(190,38)),26,color)
	var tween := node.create_tween().set_parallel(true)
	tween.tween_property(node,"position:y",point.y-37,_pace(0.9))
	tween.tween_property(node,"modulate:a",0.0,_pace(0.65)).set_delay(_pace(0.4))
	tween.chain().tween_callback(node.queue_free)

func _banner(text_value: String, color: Color) -> void:
	var node := _label(fx,text_value,Rect2(411,292,474,37),28,color)
	node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	node.set_meta("phase_banner",true)
	var tween := node.create_tween()
	tween.tween_interval(_pace(0.65))
	tween.tween_property(node,"modulate:a",0.0,_pace(0.45))
	tween.tween_callback(node.queue_free)

func _finished(winning_side: int) -> void:
	_hide_hover()
	zoom_layer.hide()
	selected_hand = -1
	selected_zone = -1
	var token: int = session
	while trap_presenting and token == session:
		await get_tree().create_timer(0.1).timeout
	if token != session: return
	var delay: float = maxf(0.12,impact_until-Time.get_ticks_msec()/1000.0+_pace(0.30 if fx.reduced_motion else 0.65))
	await get_tree().create_timer(delay).timeout
	if token != session:
		return
	result_title.text = "VICTORY" if winning_side == 0 else "DEFEAT"
	result_title.add_theme_color_override("font_color",GOLD if winning_side == 0 else Color("#da919b"))
	result_description.text = "%s\nDuel selesai pada giliran %d." % ["Cahaya Eldoria tetap menyala. Nyx telah dikalahkan." if winning_side == 0 else "Nyx menguasai arena. Susun strategi dan coba lagi.",duel.turn_number]
	result_summary.text = duel_summary.text(duel.lp,duel.turn_number)
	result_summary.scroll_to_line(0)
	_sound("win" if winning_side == 0 else "lose")
	result_layer.show()

func _attacker_ready() -> bool:
	if selected_zone < 0 or selected_zone > 2:
		return false
	var monster: Dictionary = duel.fields[0][selected_zone]
	return not monster.is_empty() and not monster["defending"] and not monster["attacked"]

func _unhandled_key_input(event: InputEvent) -> void:
	if settings_layer.visible or quick_guide_layer.visible:
		if event.is_action_pressed("ui_cancel"):
			if quick_guide_layer.visible: quick_guide_layer.hide()
			else: settings_layer.hide()
		get_viewport().set_input_as_handled()
		return
	if event is InputEventKey and event.pressed and not event.echo and event.ctrl_pressed and event.keycode == KEY_Z:
		_undo_action()
		get_viewport().set_input_as_handled()
		return
	if response_layer.visible and not zoom_layer.visible:
		if event.is_action_pressed("ui_cancel"):
			_message("Pilih jebakan atau Lewati untuk menyelesaikan respons.")
		get_viewport().set_input_as_handled()
		return
	if coin_layer.visible:
		if event.is_action_pressed("ui_cancel"):
			_open_menu()
		get_viewport().set_input_as_handled()
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
		if gallery.visible:
			gallery.inspect_selected()
			get_viewport().set_input_as_handled()
		elif not menu_layer.visible and not help_layer.visible and not result_layer.visible:
			_open_card_zoom(inspected_card)
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_cancel"):
		if zoom_layer.visible:
			zoom_layer.hide()
		elif gallery.visible:
			_close_gallery()
		elif help_layer.visible:
			help_layer.hide()
		elif log_panel.visible:
			log_panel.hide()
		elif not menu_layer.visible:
			_open_menu()

func _exit_tree() -> void:
	session += 1
	if music_tween and music_tween.is_valid(): music_tween.kill()
	if is_instance_valid(urgency_music):
		urgency_music.stop()
		urgency_music.stream = null
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
	_label(zoom_layer,"EFEK KARTU",Rect2(566,318,454,25),16,CYAN)
	zoom_description = RichTextLabel.new()
	zoom_description.add_theme_font_size_override("normal_font_size",20)
	zoom_description.add_theme_color_override("default_color",LIGHT)
	_place(zoom_description,zoom_layer,Rect2(566,350,454,118))
	_label(zoom_layer,"CERITA",Rect2(566,471,454,25),16,GOLD)
	zoom_lore = _reading_text(zoom_layer,Rect2(566,501,454,58),18,MUTED)
	zoom_hint = _label(zoom_layer,"Klik kiri untuk bermain. Klik kanan atau E untuk detail.",Rect2(566,562,454,24),15,MUTED)
	zoom_close_button = _button(zoom_layer,"KEMBALI KE DUEL",Rect2(566,592,454,45),func(): zoom_layer.hide(),true)
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
	zoom_type.text = Catalog.type_text(card)
	zoom_stats.text = "ATK %d   /   DEF %d" % [card["atk"],card["def"]] if card["kind"] == "monster" else str(card["kind"]).to_upper()
	zoom_description.text = card["text"]
	if card.get("piercing",false): zoom_description.text += "\n\nSTATUS PAPAN: MENEMBUS DEF. Selisih ATK terhadap DEF mengurangi LP lawan."
	if card.get("shield",false): zoom_description.text += "\n\nSTATUS PAPAN: PERISAI aktif (1 kehancuran akibat serangan)."
	zoom_description.scroll_to_line(0)
	zoom_lore.text = card.get("lore", "")
	zoom_lore.scroll_to_line(0)
	zoom_close_button.text = "KEMBALI KE GALERI" if gallery.visible else "KEMBALI KE DUEL"
	zoom_hint.text = "Pelajari statistik dan efeknya sebelum memasuki arena." if gallery.visible else "Klik kiri untuk bermain. Klik kanan atau E untuk detail."
	zoom_layer.show()

func _queue_hover(card: Dictionary, from_hand: bool = false) -> void:
	_hide_hover()
	if menu_layer.visible or help_layer.visible or result_layer.visible or zoom_layer.visible or gallery.visible:
		return
	var token: int = hover_serial
	var data_copy: Dictionary = card.duplicate(true)
	await get_tree().create_timer(0.38).timeout
	if token != hover_serial or menu_layer.visible or help_layer.visible or result_layer.visible or zoom_layer.visible or gallery.visible:
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
	if is_instance_valid(context_label): _update_context()

func _toggle_log() -> void:
	_hide_hover()
	log_panel.visible = not log_panel.visible

func _update_context() -> void:
	context_label.tooltip_text = ""
	if duel.over:
		context_label.text = "Duel selesai."
	elif duel.turn == 1:
		context_label.text = "Giliran Nyx.\nAmati kartu dan strategi lawan."
	elif selected_hand >= 0 and selected_hand < duel.hands[0].size():
		var card: Dictionary = duel.hands[0][selected_hand]
		context_label.text = "%s\n%s" % [card["name"],"Pasang di zona emas di kanan papanmu." if card["kind"] == "trap" else "Pilih zona yang menyala."]
	elif duel.phase == "BATTLE":
		if _attacker_ready():
			context_label.text = Hints.forecast(duel,duel.fields[0][selected_zone],{}) if not duel.has_monsters(1) else "Arahkan kursor ke target untuk melihat perkiraan hasil. Klik untuk menyerang."
		elif selected_zone >= 0:
			context_label.text = Hints.monster_status(duel,duel.fields[0][selected_zone]) + "\nPilih monster lain yang siap."
		else:
			context_label.text = "Pilih monster SIAP MENYERANG, lalu arahkan kursor ke target."
		context_label.tooltip_text = context_label.text
	elif duel.turn_number == 1:
		context_label.text = "Main Phase\nPanggil monster, lalu akhiri giliran pertama."
	else:
		context_label.text = "Main Phase\nMainkan kartu, lalu masuk Battle."

func _set_lp_value(value: float, side: int) -> void:
	displayed_lp[side] = value
	profile_lp[side].text = "%d LP" % roundi(value)
	profile_bars[side].value = value

func _update_lp(side: int) -> void:
	if trap_presenting: return
	var target: int = int(duel.lp[side])
	if lp_targets[side] == target:
		return
	lp_targets[side] = target
	if lp_tweens[side] != null and lp_tweens[side].is_valid():
		lp_tweens[side].kill()
	var tween := create_tween()
	lp_tweens[side] = tween
	var delay: float = maxf(0,impact_until-Time.get_ticks_msec()/1000.0)
	if delay > 0:
		tween.tween_interval(delay)
	tween.tween_method(_set_lp_value.bind(side),float(displayed_lp[side]),float(target),_pace(0.18 if fx.reduced_motion else 0.55)).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _reset_visuals() -> void:
	trap_presenting = false
	trap_visuals.clear()
	delayed_combats.clear()
	delayed_health.clear()
	delayed_shields.clear()
	delayed_card_cues.clear()
	impact_until = 0
	ace_seen.clear()
	ace_active_until = 0
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
		if child != combat_notice and child != fx.painter and child != fx.glow_painter:
			fx.remove_child(child)
			child.queue_free()
	fx.clear_all()
	combat_notice.hide()
	status_label.show()
	combat_serial += 1

func _animate_summon(side: int, zone: int) -> void:
	var card: Dictionary = duel.fields[side][zone]
	if not card.is_empty(): _show_ace_intro(card,side)
	if card.is_empty() or fx.reduced_motion:
		return
	var ghost := CardView.new()
	ghost.data = card.duplicate(true)
	ghost.disabled = true
	ghost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ghost.set_meta("card_visual",true)
	var origin := Vector2(800,143) if side == 1 else Vector2(302,352)
	if side == 0 and selected_hand >= 0 and selected_hand < hand_box.get_child_count():
		origin = hand_box.get_child(selected_hand).global_position
	var target: Vector2 = _zone_center(side,zone)-Vector2(73,71)
	_place(ghost,fx,Rect2(origin,Vector2(146,142)))
	var view = zone_views[side][zone]
	view.self_modulate.a = 0.0
	var tween := ghost.create_tween()
	tween.tween_property(ghost,"position",target,_pace(0.42)).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): view.self_modulate = Color.WHITE)
	tween.tween_property(ghost,"modulate:a",0.0,_pace(0.12))
	tween.tween_callback(ghost.queue_free)

func _combat_explained(report: Dictionary) -> void:
	if trap_presenting:
		delayed_combats.append(report.duplicate(true))
		return
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
		text_value = "%d ATK vs %d DEF / %d kerusakan LP%s" % [attack_power,enemy_power,difference if report.get("piercing",false) else 0," / MENEMBUS" if report.get("piercing",false) else ""]
	elif difference < 0:
		text_value = "%d ATK vs %d %s / penyerang -%d LP" % [attack_power,enemy_power,"DEF" if report["defending"] else "ATK",-difference]
	else:
		text_value = "%d ATK - %d ATK = %d kerusakan LP" % [attack_power,enemy_power,difference]
	_message(text_value)
	combat_label.text = text_value
	combat_notice.show()
	status_label.hide()
	_animate_attack(report)
	await get_tree().create_timer(_pace(2.6)).timeout
	if token == combat_serial:
		combat_notice.hide()
		status_label.show()

func _animate_attack(report: Dictionary) -> void:
	var side: int = report["side"]
	var zone: int = report["zone"]
	var card_id: String = report["card"]["id"]
	var source: Vector2 = _zone_center(side,zone)
	var target: Vector2 = _zone_center(1-side,report["target"]) if report["target"] >= 0 else _profile_effect_point(1-side)
	var delay: float = fx.impact_delay(card_id,"attack")
	impact_until = Time.get_ticks_msec()/1000.0+delay
	var shatter: bool = not report["direct"] and not report.get("target_card",{}).get("shield",false) and (int(report["difference"]) > 0 or (int(report["difference"]) == 0 and not report["defending"]))
	fx.play_card(card_id,"attack",source,target,{"shatter":shatter})
	if int(report["attack"]) >= 2000: _delayed_sound("heavy_impact",delay,session)
	if fx.reduced_motion:
		return
	var ghost := CardView.new()
	ghost.data = report["card"].duplicate(true)
	ghost.data["attacked"] = false
	ghost.disabled = true
	ghost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ghost.set_meta("card_visual",true)
	var origin: Vector2 = source-Vector2(73,71)
	_place(ghost,fx,Rect2(origin,Vector2(146,142)))
	var source_view = zone_views[side][zone]
	source_view.self_modulate.a = 0
	var direction: Vector2 = (target-source).normalized()
	var tween := ghost.create_tween()
	tween.tween_property(ghost,"position",origin-direction*4,_pace(0.1))
	tween.tween_property(ghost,"position",origin+direction*10,_pace(0.12)).set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(maxf(0.01,delay-_pace(0.22)))
	tween.tween_property(ghost,"modulate:a",0.0,_pace(0.13))
	tween.tween_callback(func(): source_view.self_modulate = Color.WHITE)
	tween.tween_callback(ghost.queue_free)
	if report["target"] >= 0:
		_hold_target(report.get("target_card",{}),1-side,report["target"],delay)

func _build_gallery() -> void:
	gallery = Gallery.new()
	gallery.hide()
	_place(gallery,self,Rect2(0,0,1280,720))
	gallery.closed.connect(_close_gallery)
	gallery.inspect_requested.connect(_open_card_zoom)

func _open_gallery() -> void:
	_hide_hover()
	zoom_layer.hide()
	_sound("click")
	gallery.show_library()

func _close_gallery() -> void:
	zoom_layer.hide()
	gallery.hide()
	_sound("click")

func _profile_effect_point(side: int) -> Vector2:
	return Vector2(420 if side == 0 else 870,152)

func _card_visual(cue: Dictionary) -> void:
	if starting:
		return
	if Catalog.CARDS[cue["id"]]["kind"] == "trap":
		trap_visuals.append(cue.duplicate(true))
		if not trap_presenting:
			trap_presenting = true
			_play_trap_visuals(session)
		return
	if trap_presenting:
		delayed_card_cues.append(cue.duplicate(true))
		return
	var card_id: String = cue["id"]
	var side: int = cue["side"]
	var action: String = cue["action"]
	var target_side: int = cue["target_side"]
	var target_zone: int = cue["target_zone"]
	var source := Vector2(800,150) if side == 1 else Vector2(345,470)
	if side == 0 and selected_hand >= 0 and selected_hand < hand_box.get_child_count():
		source = hand_box.get_child(selected_hand).global_position+Vector2(71,45)
	if action == "cast":
		source = Vector2(645,309)
	var target: Vector2 = _zone_center(target_side,target_zone) if target_zone >= 0 else _profile_effect_point(target_side)
	if action == "cast" and card_id == "sanctuary":
		target = _zone_center(side,1)
	var delay: float = fx.impact_delay(card_id,action)
	impact_until = Time.get_ticks_msec()/1000.0+delay
	fx.play_card(card_id,action,source,target)
	if action == "cast" and target_zone >= 0 and not fx.reduced_motion:
		_hold_target(cue.get("target_card",{}),target_side,target_zone,delay)

func _hold_target(card: Dictionary, side: int, zone: int, delay: float) -> void:
	if card.is_empty():
		return
	var ghost := CardView.new()
	ghost.data = card.duplicate(true)
	ghost.disabled = true
	ghost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ghost.set_meta("card_visual",true)
	_place(ghost,fx,Rect2(_zone_center(side,zone)-Vector2(73,71),Vector2(146,142)))
	var view = zone_views[side][zone]
	view.self_modulate.a = 0
	var tween := ghost.create_tween()
	tween.tween_interval(delay)
	tween.tween_property(ghost,"modulate:a",0.0,_pace(0.14))
	tween.tween_callback(func(): view.self_modulate = Color.WHITE)
	tween.tween_callback(ghost.queue_free)

func _health_change(side: int, amount: int, healing: bool) -> void:
	if trap_presenting:
		delayed_health.append([side,amount,healing])
		return
	var token: int = session
	var delay: float = maxf(0,impact_until-Time.get_ticks_msec()/1000.0)
	if delay > 0:
		await get_tree().create_timer(delay).timeout
	if token != session:
		return
	var prefix: String = "+" if healing else "-"
	_float_text("%s%d LP" % [prefix,amount],Vector2(354 if side == 0 else 802,137),CYAN if healing else Color("#edac95"))
	if healing:
		_sound("heal")

func _shield_at_impact(side: int, zone: int) -> void:
	if trap_presenting:
		delayed_shields.append([side,zone])
		return
	var token: int = session
	var delay: float = maxf(0,impact_until-Time.get_ticks_msec()/1000.0)
	if delay > 0:
		await get_tree().create_timer(delay).timeout
	if token == session:
		var point: Vector2 = _zone_center(side,zone)
		fx.play_card("warden","guard",point,point)

func _toggle_effect_mode() -> void:
	_hide_hover()
	fx.reduced_motion = not fx.reduced_motion
	collection_store.reduced_motion = fx.reduced_motion
	if is_instance_valid(reduced_check): reduced_check.set_pressed_no_signal(fx.reduced_motion)
	_save_preferences()
	CardView.allow_art_motion = not fx.reduced_motion
	ace_active_until = 0
	fx.clear_all()
	for child in fx.get_children():
		if child.get_meta("card_visual",false):
			fx.remove_child(child)
			child.queue_free()
	for side in range(2):
		for view in zone_views[side]:
			view.self_modulate = Color.WHITE
	impact_until = 0
	effects_button.text = "EFEK: RINGKAS" if fx.reduced_motion else "EFEK: NORMAL"
	_render()

func _effects_obscured() -> bool:
	for layer in [menu_layer,help_layer,result_layer,zoom_layer,gallery,coin_layer,response_layer,settings_layer,quick_guide_layer]:
		if is_instance_valid(layer) and layer.visible:
			return true
	return false

func _reading_text(parent: Node, rect: Rect2, fs: int, color: Color) -> RichTextLabel:
	var node := RichTextLabel.new()
	node.add_theme_font_size_override("normal_font_size",fs)
	node.add_theme_color_override("default_color",color)
	_place(node,parent,rect)
	return node

func _build_coin() -> void:
	coin_layer = _overlay()
	_panel(coin_layer,Rect2(330,70,620,580),GOLD)
	var title := _label(coin_layer,"TAKDIR PERTAMA",Rect2(370,98,540,47),32,GOLD)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var rule := _label(coin_layer,"Gambar: kamu mulai  /  Angka: Nyx mulai",Rect2(370,156,540,32),19,LIGHT)
	rule.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	coin_face = preload("res://scripts/coin.gd").new()
	_place(coin_face,coin_layer,Rect2(545,214,190,190))
	coin_result = _label(coin_layer,"",Rect2(360,430,560,56),22,GOLD)
	coin_result.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var note := _label(coin_layer,"Kedua pihak mendapat 4 kartu awal.",Rect2(365,490,550,28),17,MUTED)
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var first_rule := _label(coin_layer,"Giliran pertama: belum boleh menyerang.",Rect2(365,523,550,28),17,MUTED)
	first_rule.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	coin_continue = _button(coin_layer,"MASUK ARENA",Rect2(405,563,470,42),_confirm_coin,true)
	_button(coin_layer,"Kembali",Rect2(405,614,470,27),_open_menu)
	coin_layer.hide()

func _build_strategy_ui() -> void:
	_label(menu_layer,"DECK KAMU",Rect2(99,366,190,22),13,GOLD)
	deck_select = OptionButton.new()
	_place(deck_select,menu_layer,Rect2(99,391,245,34))
	_label(menu_layer,"DECK NYX",Rect2(361,366,230,22),13,GOLD)
	enemy_select = OptionButton.new()
	_place(enemy_select,menu_layer,Rect2(361,391,246,34))
	ai_select = OptionButton.new()
	for title in ["AI: Santai","AI: Normal","AI: Sulit"]: ai_select.add_item(title)
	_place(ai_select,menu_layer,Rect2(99,434,508,34))
	ai_select.select(["easy","normal","hard"].find(collection_store.difficulty))
	ai_select.item_selected.connect(func(index):
		collection_store.difficulty = ["easy","normal","hard"][index]
		_save_preferences())
	deck_select.item_selected.connect(func(index):
		collection_store.active = str(deck_select.get_item_metadata(index))
		_save_preferences())
	enemy_select.item_selected.connect(func(index):
		collection_store.enemy = str(enemy_select.get_item_metadata(index))
		_save_preferences())
	_refresh_deck_choices()
	for side in range(2):
		var x: int = 298 if side == 1 else 903
		var y: int = 165 if side == 1 else 334
		var zone_label := _label(self,"SPELL / TRAP",Rect2(x,y-21,97,19),11,GOLD)
		move_child(zone_label,menu_layer.get_index())
		for z in range(3):
			var button := _button(self,"",Rect2(x,y+z*49,89,43),_backrow_clicked.bind(side,z))
			button.add_theme_font_size_override("font_size",11)
			button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			button.mouse_entered.connect(_backrow_hover.bind(side,z))
			backrow_views[side].append(button)
	# Backrow controls belong below modal layers in the scene tree.
	for side in range(2):
		for button in backrow_views[side]: move_child(button,menu_layer.get_index())
	response_layer = _overlay()
	_panel(response_layer,Rect2(315,105,650,510),GOLD)
	_label(response_layer,"KESEMPATAN MERESPONS",Rect2(350,132,460,40),28,GOLD)
	response_undo_button = _button(response_layer,"UNDO",Rect2(824,136,106,34),_undo_action)
	response_text = _reading_text(response_layer,Rect2(350,190,580,134),19,LIGHT)
	for z in range(3):
		var button := _button(response_layer,"",Rect2(350,337+z*69,580,63),_respond_player.bind(z))
		button.add_theme_font_size_override("font_size",15)
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		response_buttons.append(button)
	_button(response_layer,"LEWATI / BIARKAN RANTAI BERLANJUT",Rect2(350,552,580,42),_respond_player.bind(-1),true)
	response_layer.hide()
	move_child(zoom_layer,get_child_count()-1)

func _save_preferences() -> void:
	if collection_store.save_data() != OK:
		_message("Pilihan berlaku sekarang, tetapi belum tersimpan di perangkat.")

func _refresh_deck_choices() -> void:
	deck_select.clear()
	var all: Dictionary = Catalog.PRESETS
	for key in all:
		deck_select.add_item(all[key]["name"])
		deck_select.set_item_metadata(deck_select.item_count-1,key)
		deck_select.get_popup().set_item_tooltip(deck_select.item_count-1,str(all[key].get("summary","")))
		if key == collection_store.active: deck_select.select(deck_select.item_count-1)
	enemy_select.clear()
	for key in Catalog.PRESETS:
		enemy_select.add_item(Catalog.PRESETS[key]["name"])
		enemy_select.set_item_metadata(enemy_select.item_count-1,key)
		enemy_select.get_popup().set_item_tooltip(enemy_select.item_count-1,str(Catalog.PRESETS[key].get("summary","")))
		if key == collection_store.enemy: enemy_select.select(enemy_select.item_count-1)

func _render_backrows() -> void:
	if not is_instance_valid(response_layer): return
	var choosing: bool = selected_hand >= 0 and selected_hand < duel.hands[0].size() and duel.hands[0][selected_hand]["kind"] == "trap" and _can_input() and duel.phase == "MAIN"
	for side in range(2):
		for z in range(3):
			var card: Dictionary = duel.backrows[side][z]
			var button: Button = backrow_views[side][z]
			var legal: bool = choosing and side == 0 and card.is_empty()
			button.set_meta("valid_trap_target",legal)
			button.add_theme_stylebox_override("normal",_style(Color("#374738") if legal else Color("#142937"),GOLD if legal else Color("#3c5966")))
			button.add_theme_color_override("font_color",Color("#fff0c9") if legal else LIGHT)
			button.disabled = choosing and not legal
			if card.is_empty():
				button.text = "PASANG\nDI SINI" if legal else "S/T %d\nKOSONG" % (z+1)
				button.tooltip_text = "Klik untuk memasang jebakan yang dipilih."
			elif side == 1 and not card.get("faceup",false):
				button.text = "TERTUTUP"
				button.tooltip_text = "Kartu tertutup Nyx. Identitas tidak terlihat."
			elif card["kind"] == "spell":
				button.text = card["name"]+"\nAKTIF"
				button.tooltip_text = card["text"]
			else:
				var ready: bool = int(card.get("set_turn",duel.turn_number)) < duel.turn_number
				button.text = card["name"]+ ("\nSIAP" if ready else "\nMENUNGGU")
				button.tooltip_text = card["text"]+ (" Respons akan muncul otomatis saat syaratnya terpenuhi." if ready else " Belum aktif pada giliran dipasang. Aktif mulai giliran berikutnya.")

func _backrow_hover(side: int, z: int) -> void:
	var card: Dictionary = duel.backrows[side][z]
	if not card.is_empty() and (side == 0 or card.get("faceup",false)):
		_inspect(card)

func _backrow_clicked(side: int, z: int) -> void:
	if not _can_input(): return
	var card: Dictionary = duel.backrows[side][z]
	if side == 0 and selected_hand >= 0 and selected_hand < duel.hands[0].size() and duel.hands[0][selected_hand]["kind"] == "trap":
		if duel.set_trap(selected_hand,z): selected_hand = -1
		_render()
	elif not card.is_empty() and (side == 0 or card.get("faceup",false)):
		_open_card_zoom(card)

func _sync_response() -> void:
	if not is_instance_valid(response_layer): return
	if duel.chain.is_empty() or duel.priority < 0 or menu_layer.visible or coin_layer.visible:
		response_layer.hide()
		return
	response_undo_button.visible = duel.can_undo()
	if duel.priority == 0:
		_hide_hover()
		var lines: Array[String] = ["Efek terakhir diselesaikan lebih dulu. LP Kamu %d / Nyx %d" % [duel.lp[0],duel.lp[1]],""]
		for i in range(duel.chain.size()):
			var event: Dictionary = duel.chain[i]
			lines.append("%d. %s: %s / %s" % [i+1,duel.who(event["side"]),event["card"]["name"],"SERANGAN" if event["action"] == "attack" else "EFEK"])
			if event["action"] == "attack":
				var target: int = event["target"]
				var detail: String = "LP langsung"
				if target >= 0:
					var defender: Dictionary = duel.fields[1-int(event["side"])][target]
					if not defender.is_empty():
						var stat: String = "def" if defender.get("defending",false) else "atk"
						detail = "%s (%s %d)" % [defender["name"],stat.to_upper(),defender[stat]]
				lines.append("   ATK %d → %s" % [event["card"]["atk"],detail])
		response_text.text = "\n".join(lines)
		var options: Array = duel.response_options(0)
		for z in range(3):
			response_buttons[z].visible = options.has(z)
			if options.has(z):
				var card: Dictionary = duel.backrows[0][z]
				response_buttons[z].text = card["name"]+" / AKTIFKAN\n"+card["text"]
				response_buttons[z].tooltip_text = card["text"]
		response_layer.show()
	else:
		response_layer.hide()
		if not response_pending:
			response_pending = true
			_bot_response(session)

func _respond_player(slot: int) -> void:
	if duel.priority == 0 and not duel.chain.is_empty():
		response_layer.hide()
		duel.respond(0,slot)

func _bot_response(token: int) -> void:
	await get_tree().create_timer(_pace(0.65)).timeout
	while token == session and (help_layer.visible or zoom_layer.visible or gallery.visible or settings_layer.visible or quick_guide_layer.visible):
		await get_tree().create_timer(0.2).timeout
	if token != session: return
	response_pending = false
	if duel.priority == 1 and not duel.chain.is_empty():
		duel.respond(1,AI.response(duel,1))

func _play_trap_visuals(token: int) -> void:
	# Let the response overlay close before presenting each revealed card.
	await get_tree().process_frame
	while token == session and not trap_visuals.is_empty():
		var cue: Dictionary = trap_visuals.pop_front()
		var card: Dictionary = Catalog.card(cue["id"])
		var side: int = cue["side"]
		var cancelled: bool = cue.get("cancelled",false)
		var ghost := CardView.new()
		ghost.data = card
		ghost.disabled = true
		ghost.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ghost.set_meta("card_visual",true)
		_place(ghost,fx,Rect2(412,538,132,169))
		ghost.pivot_offset = ghost.size/2.0
		if not fx.reduced_motion:
			ghost.scale.x = 0.05
			ghost.create_tween().tween_property(ghost,"scale:x",1.0,_pace(0.18))
		var note := _panel(fx,Rect2(555,548,436,145),GOLD)
		note.set_meta("card_visual",true)
		_label(note,("DIBATALKAN / " if cancelled else "TRAP AKTIF / ")+duel.who(side),Rect2(12,8,410,23),15,GOLD)
		_label(note,card["name"],Rect2(12,34,410,28),22,LIGHT)
		_label(note,"Efek dibatalkan oleh respons lawan." if cancelled else card["text"],Rect2(12,69,410,67),16,MUTED)
		var slot: int = cue.get("source_slot",0)
		var source := Vector2(948,355+49*slot) if side == 0 else Vector2(342,186+49*slot)
		var target := Vector2(645,309) if cue["id"] == "seal" else _zone_center(cue["target_side"],maxi(0,int(cue["target_zone"])))
		fx.play_card(cue["id"],"cancel" if cancelled else "cast",source,target)
		_sound("trap_reveal")
		await get_tree().create_timer(_pace(0.38 if fx.reduced_motion else 1.15)).timeout
		if token != session: return
		if is_instance_valid(ghost): ghost.queue_free()
		if is_instance_valid(note): note.queue_free()
	if token != session: return
	trap_presenting = false
	impact_until = Time.get_ticks_msec()/1000.0
	var cues: Array = delayed_card_cues.duplicate(true)
	delayed_card_cues.clear()
	for cue in cues: _card_visual(cue)
	var combats: Array = delayed_combats.duplicate(true)
	delayed_combats.clear()
	for report in combats: _combat_explained(report)
	var health: Array = delayed_health.duplicate(true)
	delayed_health.clear()
	for change in health: _health_change(change[0],change[1],change[2])
	var shields: Array = delayed_shields.duplicate(true)
	delayed_shields.clear()
	for shield in shields: _shield_at_impact(shield[0],shield[1])
	_render()

func _show_ace_intro(card: Dictionary, side: int) -> void:
	if fx.reduced_motion or int(card["level"]) <= 4: return
	var key: String = "%d:%s" % [side,card["id"]]
	if ace_seen.has(key): return
	ace_seen[key] = true
	ace_active_until = Time.get_ticks_msec()/1000.0+_pace(1.05)
	_finish_ace(session)
	var cutin := AceCutin.new()
	cutin.animation_speed = collection_store.animation_speed
	cutin.card = card.duplicate(true)
	cutin.owner_text = "KAMU" if side == 0 else "NYX"
	cutin.accent = Effects.PROFILES[card["id"]]["color"]
	cutin.occlusion_check = _effects_obscured
	cutin.z_index = 3
	cutin.set_meta("card_visual",true)
	cutin.set_meta("ace_cutin",true)
	_place(cutin,fx,Rect2(296,174,696,240))
	_sound("ace_summon")

func _delayed_sound(name_value: String, delay: float, token: int) -> void:
	await get_tree().create_timer(delay).timeout
	if token == session: _sound(name_value)

func _music_volume_changed(value: float) -> void:
	collection_store.music_gain = value/100.0
	music_slider.set_value_no_signal(value)
	if is_instance_valid(settings_music):
		settings_music.set_value_no_signal(value)
		music_value.text = "%d%%" % roundi(value)
	_sync_music()
	_save_preferences()

func _sync_music(immediate: bool = false) -> void:
	if not is_instance_valid(music) or not is_instance_valid(urgency_music): return
	var duel_active: bool = not menu_layer.visible and not coin_layer.visible and not duel.over
	var gain: float = collection_store.music_gain
	var offset: float = linear_to_db(maxf(gain,0.0001))
	var main_db: float = (-8.0 if duel_active else -18.0)+offset if gain > 0 else -80.0
	var urgency_db: float = -80.0
	if duel_active and gain > 0:
		if mini(duel.lp[0],duel.lp[1]) <= 1500: urgency_db = -28.0+offset
		elif duel.phase == "BATTLE": urgency_db = -36.0+offset
	var targets: Array = [main_db,urgency_db]
	if targets == music_targets and not immediate: return
	music_targets = targets
	if music_tween and music_tween.is_valid(): music_tween.kill()
	if immediate:
		music.volume_db = main_db
		urgency_music.volume_db = urgency_db
	else:
		music_tween = create_tween().set_parallel(true)
		music_tween.tween_property(music,"volume_db",main_db,0.7)
		music_tween.tween_property(urgency_music,"volume_db",urgency_db,0.7)

func _ace_active() -> bool:
	return Time.get_ticks_msec()/1000.0 < ace_active_until

func _finish_ace(token: int) -> void:
	await get_tree().create_timer(_pace(1.08)).timeout
	if token == session: _render()

func _can_undo_input() -> bool:
	return duel.can_undo() and not menu_layer.visible and not coin_layer.visible and not help_layer.visible and not zoom_layer.visible and not gallery.visible and not settings_layer.visible and not quick_guide_layer.visible

func _undo_action() -> void:
	if _can_undo_input(): duel.undo()

func _capture_undo_ui(snapshot: Dictionary) -> void:
	snapshot["ui"] = {"history":history.duplicate(),"inspected":inspected_card.duplicate(true),"aces":ace_seen.duplicate(true),"summon_defense":summon_defense,"summary":duel_summary.snapshot()}

func _restore_undo_ui(snapshot: Dictionary) -> void:
	# Invalidate pending AI replies, impacts, LP tweens, and victory timers.
	session += 1
	combat_serial += 1
	response_pending = false
	_reset_visuals()
	result_layer.hide()
	response_layer.hide()
	combat_notice.hide()
	status_label.show()
	selected_hand = -1
	selected_zone = -1
	var ui: Dictionary = snapshot.get("ui",{})
	if ui.has("summary"): duel_summary.restore(ui["summary"])
	history.assign(ui.get("history",[]))
	log_view.text = "\n\n".join(history)
	ace_seen = ui.get("aces",{}).duplicate(true)
	summon_defense = ui.get("summon_defense",false)
	for side in range(2):
		lp_targets[side] = int(duel.lp[side])
		_set_lp_value(float(duel.lp[side]),side)
	_inspect(ui.get("inspected",Catalog.card("dawn")))

func _pace(seconds: float) -> float:
	return seconds/collection_store.animation_speed

func _build_comfort_ui() -> void:
	_button(menu_layer,"PENGATURAN",Rect2(700,643,260,42),_open_settings)
	var settings_button := _button(self,"PENGATURAN",Rect2(1028,611,216,21),_open_settings)
	settings_button.add_theme_font_size_override("font_size",12)
	move_child(settings_button,menu_layer.get_index())
	settings_layer = _overlay()
	_panel(settings_layer,Rect2(320,65,640,590),GOLD)
	_label(settings_layer,"Pengaturan permainan",Rect2(354,90,572,43),29,GOLD)
	_label(settings_layer,"Musik",Rect2(354,158,400,25),18,LIGHT)
	music_value = _label(settings_layer,"",Rect2(852,158,74,25),17,CYAN)
	settings_music = HSlider.new()
	settings_music.max_value = 100
	_place(settings_music,settings_layer,Rect2(354,199,572,27))
	settings_music.value_changed.connect(_music_volume_changed)
	_label(settings_layer,"Efek suara",Rect2(354,248,400,25),18,LIGHT)
	sfx_value = _label(settings_layer,"",Rect2(852,248,74,25),17,CYAN)
	settings_sfx = HSlider.new()
	settings_sfx.max_value = 100
	_place(settings_sfx,settings_layer,Rect2(354,289,572,27))
	settings_sfx.value_changed.connect(_sfx_volume_changed)
	_label(settings_layer,"Kecepatan animasi",Rect2(354,337,270,26),18,LIGHT)
	speed_select = OptionButton.new()
	for title in ["Normal / 1x","Cepat / 1,5x","Sangat Cepat / 2x"]: speed_select.add_item(title)
	_place(speed_select,settings_layer,Rect2(650,330,276,40))
	speed_select.item_selected.connect(_speed_selected)
	reduced_check = CheckBox.new()
	reduced_check.text = "Efek ringkas (kurangi gerakan dan kilatan)"
	_place(reduced_check,settings_layer,Rect2(354,390,572,40))
	reduced_check.toggled.connect(func(value):
		if fx.reduced_motion != value: _toggle_effect_mode())
	_label(settings_layer,"Kecepatan mengatur animasi dan jeda duel. Musik tetap pada tempo asli. Respons pemain menunggu pilihanmu.",Rect2(354,448,572,60),16,MUTED)
	_button(settings_layer,"Panduan singkat",Rect2(354,534,272,43),_open_quick_guide)
	_button(settings_layer,"SELESAI",Rect2(644,534,282,43),func(): settings_layer.hide(),true)
	_label(settings_layer,"Pilihan disimpan otomatis di perangkat ini.",Rect2(354,599,572,25),14,MUTED)
	settings_layer.hide()
	quick_guide_layer = _overlay()
	_panel(quick_guide_layer,Rect2(300,90,680,540),GOLD)
	quick_title = _label(quick_guide_layer,"",Rect2(338,120,604,54),29,GOLD)
	quick_text = _label(quick_guide_layer,"",Rect2(338,198,604,275),21,LIGHT)
	guide_previous = _button(quick_guide_layer,"Kembali",Rect2(338,492,175,43),func(): _guide_page(-1))
	guide_next = _button(quick_guide_layer,"Lanjut",Rect2(531,492,175,43),func(): _guide_page(1),true)
	_button(quick_guide_layer,"Tutup",Rect2(724,492,218,43),func(): quick_guide_layer.hide())
	_button(quick_guide_layer,"Baca aturan lengkap",Rect2(338,558,604,36),func(): quick_guide_layer.hide(); settings_layer.hide(); help_layer.show())
	quick_guide_layer.hide()

func _apply_comfort_preferences() -> void:
	fx.animation_speed = collection_store.animation_speed
	fx.reduced_motion = collection_store.reduced_motion
	CardView.allow_art_motion = not fx.reduced_motion
	effects_button.text = "EFEK: RINGKAS" if fx.reduced_motion else "EFEK: NORMAL"
	settings_music.set_value_no_signal(collection_store.music_gain*100)
	music_value.text = "%d%%" % roundi(collection_store.music_gain*100)
	settings_sfx.set_value_no_signal(collection_store.sfx_gain*100)
	sfx_value.text = "%d%%" % roundi(collection_store.sfx_gain*100)
	speed_select.select([1.0,1.5,2.0].find(collection_store.animation_speed))
	reduced_check.set_pressed_no_signal(fx.reduced_motion)
	_sync_sfx()

func _open_settings() -> void:
	_hide_hover()
	_apply_comfort_preferences()
	settings_layer.show()

func _sync_sfx() -> void:
	for player in sfx:
		player.volume_db = -12+linear_to_db(maxf(collection_store.sfx_gain,0.0001))
		if collection_store.sfx_gain <= 0: player.stop()

func _sfx_volume_changed(value: float) -> void:
	collection_store.sfx_gain = value/100.0
	sfx_value.text = "%d%%" % roundi(value)
	_sync_sfx()
	_save_preferences()

func _speed_selected(index: int) -> void:
	collection_store.animation_speed = [1.0,1.5,2.0][index]
	fx.animation_speed = collection_store.animation_speed
	_save_preferences()

func _open_quick_guide() -> void:
	_hide_hover()
	guide_page = 0
	_guide_page(0)
	quick_guide_layer.show()

func _guide_page(step: int) -> void:
	guide_page = clampi(guide_page+step,0,2)
	var titles := ["1 / 3 — Siapkan papan", "2 / 3 — Serang dengan rencana", "3 / 3 — Respons dan perbaiki"]
	var pages := ["Pada Main Phase, klik kartu tangan lalu zona yang menyala. Satu normal summon per giliran; naga perlu satu monster sebagai tribute.\n\nSpell penguatan menargetkan monstermu. Trap dipasang di kanan papan dan baru siap mulai giliran berikutnya.","Masuk Battle, pilih monster SIAP MENYERANG, lalu arahkan kursor ke target untuk melihat perkiraan. Klik target untuk menyerang.\n\nTombak Surya menembus DEF. Selubung Gerhana menguatkan monster dan memulihkan perisai. Giliran pertama belum boleh menyerang.","Saat jendela respons muncul, pilih trap atau Lewati. Efek terakhir diselesaikan lebih dulu. Jebakan tertutup bisa mengubah perkiraan serangan.\n\nSalah langkah? Undo atau Ctrl+Z tersedia sampai Akhiri Giliran. Atur volume dan kecepatan lewat Pengaturan."]
	quick_title.text = titles[guide_page]
	quick_text.text = pages[guide_page]
	guide_previous.disabled = guide_page == 0
	guide_next.disabled = guide_page == 2
