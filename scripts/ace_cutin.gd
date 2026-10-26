extends Control
const Art = preload("res://scripts/card_art.gd")
var card: Dictionary = {}
var accent := Color("#d6ad63")
var owner_text: String = ""
var age: float = 0.0
var animation_speed: float = 1.0
var occlusion_check: Callable
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
func _process(delta: float) -> void:
	age += delta*animation_speed
	visible = not (occlusion_check.is_valid() and occlusion_check.call())
	modulate.a = minf(1.0,age/0.10)*clampf((1.05-age)/0.18,0,1)
	position.x = 296-(1-pow(minf(1,age/0.18),0.4))*130
	queue_redraw()
	if age >= 1.05: queue_free()
func _draw() -> void:
	if card.is_empty(): return
	var font: Font = ThemeDB.fallback_font
	draw_rect(Rect2(0,0,696,240),Color(0.025,0.045,0.06,0.97))
	draw_line(Vector2(0,0),Vector2(696,0),accent,3,true)
	draw_line(Vector2(0,239),Vector2(696,239),accent,2,true)
	var region: Rect2 = Art.region_for(card)
	var wanted: float = region.size.x/1.55
	region.position.y += maxf(0,(region.size.y-wanted)*0.33)
	region.size.y = minf(region.size.y,wanted)
	var margin: Vector2 = region.size*0.025
	region.position += margin+Vector2(sin(age*2.0)*margin.x,0)
	region.size -= margin*2
	draw_texture_rect_region(Art.texture_for(card),Rect2(12,18,320,205),region)
	for i in range(8):
		draw_line(Vector2(340+i*5,25),Vector2(300+i*5,213),Color(accent,0.09+i*0.02),2,true)
	draw_string(font,Vector2(359,45),owner_text+" / ACE SUMMON",HORIZONTAL_ALIGNMENT_LEFT,-1,15,accent)
	draw_string(font,Vector2(357,112),card["name"],HORIZONTAL_ALIGNMENT_LEFT,-1,37,Color("#fff4d9"))
	draw_string(font,Vector2(360,155),"ATK %d     DEF %d" % [card["atk"],card["def"]],HORIZONTAL_ALIGNMENT_LEFT,-1,21,accent)
	draw_string(font,Vector2(360,199),"CAHAYA TERAKHIR" if card["id"] == "ember" else "GERHANA BANGKIT",HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color("#aabec8"))
