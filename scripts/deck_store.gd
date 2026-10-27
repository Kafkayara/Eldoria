extends RefCounted
const VNPreferences = preload("res://scripts/vn_preferences.gd")
const StoryBooks = preload("res://scripts/story_books.gd")
const StoryFlow = preload("res://scripts/story_flow.gd")
const Catalog = preload("res://scripts/catalog.gd")
const SAVE_PATH = "user://eldoria_collection_v1.json"
var path: String = SAVE_PATH
var customs: Dictionary = {}
var active: String = "fajar"
var enemy: String = "gerhana"
var difficulty: String = "normal"
var load_notice: String = ""
var music_gain: float = 0.70
var sfx_gain: float = 0.80
var animation_speed: float = 1.0
var reduced_motion: bool = false
var story_progress: Dictionary = StoryFlow.initial()
var story_books: Dictionary = {}
var story_active_book: String = "jendela_pagi"
var vn_preferences: Dictionary = VNPreferences.clean({})

func entries() -> Dictionary:
	var result: Dictionary = Catalog.PRESETS.duplicate(true)
	result.merge(customs)
	return result

func cards(id: String) -> Array:
	var all: Dictionary = entries()
	return all.get(id,Catalog.PRESETS["fajar"])["cards"].duplicate()

func load_data() -> void:
	var parsed = null
	if FileAccess.file_exists(path):
		parsed = _read_json(path)
	if not parsed is Dictionary or parsed.get("version",0) != 1:
		if FileAccess.file_exists(path+".bak"):
			parsed = _read_json(path+".bak")
			load_notice = "Simpanan dipulihkan dari cadangan lokal."
		if not parsed is Dictionary or parsed.get("version",0) != 1:
			if FileAccess.file_exists(path): load_notice = "Simpanan tidak terbaca. Deck bawaan tetap tersedia."
			return
	var saved_gain = parsed.get("music_gain",0.70)
	if saved_gain is float or saved_gain is int: music_gain = clampf(float(saved_gain),0,1)
	var saved_sfx = parsed.get("sfx_gain",0.80)
	if (saved_sfx is float or saved_sfx is int) and is_finite(float(saved_sfx)): sfx_gain = clampf(float(saved_sfx),0,1)
	var saved_speed = parsed.get("animation_speed",1.0)
	if (saved_speed is float or saved_speed is int) and float(saved_speed) in [1.0,1.5,2.0]: animation_speed = float(saved_speed)
	var saved_reduced = parsed.get("reduced_motion",false)
	if saved_reduced is bool: reduced_motion = saved_reduced
	story_progress = StoryFlow.clean(parsed.get("story",{}))
	story_books = StoryBooks.clean(parsed.get("story_books",{}),story_progress)
	story_active_book = str(parsed.get("story_active_book","jendela_pagi"))
	if story_active_book not in ["jendela_pagi","akar_esok"] or (story_active_book == "akar_esok" and int(story_progress["cleared"]) < 5): story_active_book = "jendela_pagi"
	vn_preferences = VNPreferences.clean(parsed.get("vn_preferences",{}))
	var saved = parsed.get("decks",{})
	if saved is Dictionary:
		for key in saved:
			var item = saved[key]
			if str(key).begins_with("custom_") and item is Dictionary and item.get("name") is String and item.get("cards") is Array and Catalog.validate(item["cards"]).is_empty():
				customs[key] = {"name":str(item["name"]).left(32),"cards":item["cards"].duplicate()}
	var all := entries()
	active = str(parsed.get("active","fajar"))
	if not all.has(active): active = "fajar"
	enemy = str(parsed.get("enemy","gerhana"))
	if not Catalog.PRESETS.has(enemy): enemy = "gerhana"
	difficulty = str(parsed.get("difficulty","normal"))
	if not difficulty in ["easy","normal","hard"]: difficulty = "normal"

func save_data() -> Error:
	var temporary: String = path+".tmp"
	var file := FileAccess.open(temporary,FileAccess.WRITE)
	if file == null: return FileAccess.get_open_error()
	file.store_string(JSON.stringify({"version":1,"decks":customs,"active":active,"enemy":enemy,"difficulty":difficulty,"music_gain":music_gain,"sfx_gain":sfx_gain,"animation_speed":animation_speed,"reduced_motion":reduced_motion,"story":StoryFlow.clean(story_progress),"story_books":StoryBooks.clean(story_books,story_progress),"story_active_book":story_active_book,"vn_preferences":VNPreferences.clean(vn_preferences)},"  "))
	file.flush()
	file.close()
	# On Windows rename-over-existing is not guaranteed. Preserve a recoverable
	# previous copy, and restore it if replacing the primary file fails.
	var backup: String = path+".bak"
	if FileAccess.file_exists(path):
		var current = _read_json(path)
		if current is Dictionary and current.get("version",0) == 1:
			var copied: Error = DirAccess.copy_absolute(path,backup)
			if copied != OK: return copied
		var removed: Error = DirAccess.remove_absolute(path)
		if removed != OK: return removed
	var result: Error = DirAccess.rename_absolute(temporary,path)
	if result != OK and FileAccess.file_exists(backup):
		DirAccess.copy_absolute(backup,path)
	return result

func save_deck(id: String, title: String, ids: Array) -> String:
	var error: String = Catalog.validate(ids)
	if not error.is_empty(): return error
	if title.strip_edges().is_empty(): return "Beri nama deck terlebih dahulu."
	var key: String = id if id.begins_with("custom_") else "custom_%d" % Time.get_ticks_usec()
	var old := customs.duplicate(true)
	var old_active: String = active
	customs[key] = {"name":title.strip_edges().left(32),"cards":ids.duplicate()}
	active = key
	if save_data() != OK:
		customs = old
		active = old_active
		return "Deck belum tersimpan. Periksa izin folder simpan game."
	return ""

func _read_json(filename: String):
	var document := JSON.new()
	if document.parse(FileAccess.get_file_as_string(filename)) != OK:
		return null
	return document.data
