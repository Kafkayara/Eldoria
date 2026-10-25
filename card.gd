extends Button

# Ubah data kartu melalui Inspector.
@export var card_name: String = "Penjaga Fajar"
@export var attack: int = 1600
@export var defense: int = 1200
@export_multiline var description: String = "Seorang penjaga yang melindungi gerbang kota saat fajar. Monster biasa tanpa efek khusus."

# Signal memberi tahu papan bahwa kartu telah dipilih.
signal selected(card_data: Dictionary)


func _ready() -> void:
	text = "%s\n\nMONSTER\n\nATK %d\nDEF %d" % [card_name.to_upper(), attack, defense]
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	selected.emit({
		"name": card_name,
		"attack": attack,
		"defense": defense,
		"description": description,
	})