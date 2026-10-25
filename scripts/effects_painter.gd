extends Control
var glow_pass: bool = false
var effect_source

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _draw() -> void:
	if is_instance_valid(effect_source):
		if glow_pass:
			effect_source.paint_glow()
		else:
			effect_source.paint_effects()

