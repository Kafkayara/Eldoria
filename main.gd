extends Control

@onready var card_name_label: Label = $CardDetails/CardName
@onready var stats_label: Label = $CardDetails/Stats
@onready var description_label: Label = $CardDetails/Description
@onready var status_label: Label = $Status

# Data permainan terpisah dari teks yang tampil pada tombol.
var selected_card: Dictionary = {}
var player_field: Array[Dictionary] = [{}, {}, {}]
var card_in_hand: bool = true


func _ready() -> void:
	$ExampleCard.selected.connect(_on_card_selected)
	for index in range(3):
		var zone: Button = $PlayerMonsterZones.get_child(index)
		# bind menyertakan nomor zona saat tombol ditekan.
		zone.pressed.connect(_on_player_zone_pressed.bind(index))
	for zone in $OpponentMonsterZones.get_children():
		zone.pressed.connect(_on_opponent_zone_pressed)
	$ResetPractice.pressed.connect(_reset_practice)
	_reset_practice()


func _show_card_details(card_data: Dictionary) -> void:
	card_name_label.text = str(card_data["name"])
	stats_label.text = "ATK %d / DEF %d" % [card_data["attack"], card_data["defense"]]
	description_label.text = str(card_data["description"])


func _on_card_selected(card_data: Dictionary) -> void:
	if not card_in_hand:
		return
	selected_card = card_data.duplicate(true)
	_show_card_details(selected_card)
	$HandTitle.text = "TANGAN PEMAIN — KARTU DIPILIH"
	_update_zone_hints()
	status_label.text = "Penjaga Fajar dipilih. Klik salah satu zona monstermu yang kosong untuk summon."


func _on_player_zone_pressed(index: int) -> void:
	if not player_field[index].is_empty():
		_show_card_details(player_field[index])
		status_label.text = "Monster ini sudah berada di papan dalam posisi menyerang."
		return
	if selected_card.is_empty() or not card_in_hand:
		status_label.text = "Pilih kartu di tangan terlebih dahulu. Untuk mencoba lagi, klik Ulang Latihan."
		return

	# Simpan kartu ke zona, lalu keluarkan kartu tersebut dari tangan.
	player_field[index] = selected_card.duplicate(true)
	selected_card.clear()
	card_in_hand = false
	$ExampleCard.hide()
	$HandTitle.text = "TANGAN PEMAIN — KOSONG"
	_update_zone_hints()
	status_label.text = "Summon berhasil! Penjaga Fajar berada di zona %d. Klik monsternya untuk melihat detail." % (index + 1)


func _update_zone_hints() -> void:
	for index in range(3):
		var zone: Button = $PlayerMonsterZones.get_child(index)
		var monster: Dictionary = player_field[index]
		if not monster.is_empty():
			zone.text = "%s\n\nATK %d\nDEF %d\n\nMENYERANG" % [monster["name"], monster["attack"], monster["defense"]]
			zone.add_theme_font_size_override("font_size", 15)
			zone.modulate = Color(1.0, 0.86, 0.55)
		else:
			zone.text = "Summon di sini" if not selected_card.is_empty() else "Monster %d" % (index + 1)
			zone.remove_theme_font_size_override("font_size")
			zone.modulate = Color(0.55, 1.0, 0.9) if not selected_card.is_empty() else Color.WHITE


func _on_opponent_zone_pressed() -> void:
	status_label.text = "Itu zona lawan. Kamu hanya bisa summon ke zona monstermu sendiri."


func _reset_practice() -> void:
	selected_card.clear()
	player_field = [{}, {}, {}]
	card_in_hand = true
	$ExampleCard.show()
	$HandTitle.text = "TANGAN PEMAIN — KLIK KARTU"
	card_name_label.text = "Pilih sebuah kartu"
	stats_label.text = "ATK — / DEF —"
	description_label.text = "Klik kartu di tangan, lalu klik zona monstermu untuk summon."
	status_label.text = "Latihan summon: pilih Penjaga Fajar di tanganmu."
	_update_zone_hints()
