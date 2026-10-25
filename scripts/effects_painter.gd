extends Control
var effect_source

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _draw() -> void:
	if is_instance_valid(effect_source):
		effect_source.paint_effects()

