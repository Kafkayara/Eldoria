extends RefCounted
# Satu sumber gambar per jenis kartu. Enam gambar awal memakai sel atlas yang berbeda.
const NIGHT = preload("res://assets/art/gerhana_atlas.png")
const ATLAS = preload("res://assets/art/eldoria_atlas.png")
const INDIVIDUAL = {
	"res://assets/art/grove.png": preload("res://assets/art/grove.png"),
	"res://assets/art/stag.png": preload("res://assets/art/stag.png"),
	"res://assets/art/verdant.png": preload("res://assets/art/verdant.png"),
	"res://assets/art/renewal.png": preload("res://assets/art/renewal.png"),
	"res://assets/art/compost.png": preload("res://assets/art/compost.png"),

	"res://assets/art/tombak_surya.png": preload("res://assets/art/tombak_surya.png"),
	"res://assets/art/selubung_gerhana.png": preload("res://assets/art/selubung_gerhana.png"),
	"res://assets/art/aegis_surya.png": preload("res://assets/art/aegis_surya.png"),
	"res://assets/art/peri_astral.png": preload("res://assets/art/peri_astral.png"),
	"res://assets/art/berkah_fajar.png": preload("res://assets/art/berkah_fajar.png"),
	"res://assets/art/retakan_langit.png": preload("res://assets/art/retakan_langit.png")
}

static func texture_for(card: Dictionary) -> Texture2D:
	if card.has("night_art"):
		return NIGHT
	var path: String = str(card.get("art_file",""))
	return INDIVIDUAL[path] if INDIVIDUAL.has(path) else ATLAS

static func region_for(card: Dictionary) -> Rect2:
	if card.has("night_art"):
		var cell := NIGHT.get_size()/Vector2(4,2)
		var i: int = card["night_art"]
		return Rect2(Vector2(i%4,floori(i/4.0))*cell,cell)
	var texture: Texture2D = texture_for(card)
	if str(card.get("art_file","")) in INDIVIDUAL:
		return Rect2(Vector2.ZERO,texture.get_size())
	var cell := Vector2(ATLAS.get_width()/3.0,ATLAS.get_height()/2.0)
	var index: int = int(card["art"])
	return Rect2(Vector2(index%3,floori(index/3.0))*cell,cell)

static func focus_for(card: Dictionary) -> float:
	if card.has("night_art"):
		return 0.45
	if card.has("art_focus"):
		return float(card["art_focus"])
	return float([0.27,0.44,0.34,0.49,0.5,0.43][int(card["art"])])

static func source_key(card: Dictionary) -> String:
	if card.has("night_art"):
		return "res://assets/art/gerhana_atlas.png:cell_%d" % card["night_art"]
	var path: String = str(card.get("art_file",""))
	return path if not path.is_empty() else "res://assets/art/eldoria_atlas.png:cell_%d" % int(card["art"])

