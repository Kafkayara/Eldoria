extends SceneTree
const Flow = preload("res://scripts/story_flow.gd")
const One = preload("res://scripts/story_data.gd")
const Two = preload("res://scripts/story_rimba_data.gd")
const Cast = preload("res://scripts/vn_cast.gd")
const Stage = preload("res://scripts/vn_stage.gd")
const Store = preload("res://scripts/deck_store.gd")
const Prefs = preload("res://scripts/vn_preferences.gd")
var checks := 0
var failures := 0
func check(ok: bool, why: String) -> void:
 checks += 1
 if not ok: failures += 1; push_error(why)
func _initialize() -> void: call_deferred("run")
func shot(name_value: String) -> void:
 await process_frame
 await process_frame
 if DisplayServer.get_name() == "headless": return
 RenderingServer.force_draw(false)
 root.get_texture().get_image().save_png("C:/Users/Kafka/Documents/Codex/2026-10-25/jadi-kan-aku-mau-buat-game/outputs/eldoria-v18-"+name_value+".png")
func run() -> void:
 root.size = Vector2i(1280,720)
 var view = load("res://scripts/story_view.gd").new()
 root.add_child(view)
 view.show()
 view.select_chapter(0)
 var stage = view.reader
 stage.reduced_motion = true
 var index: int = view.progress["line"]
 stage.request_next()
 check(view.progress["line"] == index and not stage.typing,"First click reveals without advancing")
 check(view.progress["history"].size() == 1 and view.progress["read"].size() == 1,"Only completed lines added to history and read marks")
 stage.request_next()
 check(view.progress["line"] == index+1 and stage.typing,"Second click advances")
 stage.blocked = func(): return true
 stage._process(100)
 check(stage.body.visible_characters == 0,"External settings pause text")
 stage.blocked = Callable()
 view.reveal_all()
 stage.open_history()
 check(stage.modal.visible,"History opens")
 stage.request_next()
 check(view.progress["line"] == index+1,"Modal blocks progression")
 stage.close_modal()
 view.progress["line"] = 4
 view.commit()
 view.show_page()
 view.reveal_all()
 await shot("home")
 stage.open_people(view.known_people())
 await shot("characters")
 stage.close_modal()
 var old := {"version":1,"book":One.BOOK_ID,"started":true,"cleared":2,"chapter":2,"phase":"intro","line":5,"choices":{"memory":"laughter"}}
 var migrated := Flow.clean(old)
 check(migrated["cleared"] == 2 and migrated["line"] == 0 and migrated["choices"]["memory"] == "laughter" and migrated["migration"],"Legacy save retains chapter unlocks and choices while restarting rewritten scene")
 var bookmark := Flow.initial()
 bookmark["page_id"] = One.CHAPTERS[0]["intro"][3]["id"]
 check(Flow.clean(bookmark)["line"] == 3,"Stable bookmark survives index mismatch")
 check(Prefs.clean({"font_size":999,"text_speed":-3,"auto_delay":99}) == {"font_size":26,"text_speed":0.0,"auto_delay":8.0},"Invalid reading settings clamped")
 for book in [One,Two]:
  var ids := {}
  for chapter in book.CHAPTERS:
   check(not chapter["goal"].is_empty() and not chapter["why_duel"].is_empty(),"Every chapter explains goal and duel motivation")
  var state: Dictionary = Flow.initial(book)
  for page in Flow.all_pages(book).values():
   check(not ids.has(page["id"]),"Unique page ID")
   ids[page["id"]] = true
   check(Stage.LOCATIONS.has(page["bg"]),"Known scene background")
   for id in page.get("cast",[]): check(Cast.PEOPLE.has(id),"Known cast ID")
   if page["speaker"] == "Rekaman Liora": check(page.get("context","").contains("Rekaman"),"Recorded Liora explicitly distinguished")
   for font_size in [26,30]:
    stage.apply_preferences({"text_speed":0,"font_size":font_size})
    stage.show_page(page,state,"TEST / BUKU "+book.BOOK_NUMBER,"LANJUT",Cast.PEOPLE.keys(),false)
    await process_frame
    check(stage.body.get_content_height() <= stage.body.size.y,"Text fits font %d: %s (%s)" % [font_size,page["id"],stage.body.get_content_height()])
   if page.has("variants"):
    for key in page["variants"]:
     stage.body.text = page["variants"][key]
     await process_frame
     check(stage.body.get_content_height() <= stage.body.size.y,"Variant fits large font: "+page["id"])
  stage.show_page(book.CHAPTERS[0]["intro"][-1],state,"DUEL BOUNDARY","MENUJU DUEL",[],true)
  stage._toggle_auto()
  stage._toggle_skip()
  check(not stage.auto_read and not stage.skipping,"Auto and skip cannot cross duel boundary")
 for id in Cast.PEOPLE:
  var texture: Texture2D = load("res://assets/vn/characters/%s.png" % id)
  check(texture != null and texture.get_image().has_mipmaps() == false,"Portrait loads: "+id)
 stage.apply_preferences({"text_speed":45,"font_size":26})
 var state := Flow.initial()
 var page: Dictionary = One.CHAPTERS[0]["intro"][0]
 stage.show_page(page,state,"UNREAD","LANJUT",[],false)
 stage._toggle_skip()
 check(not stage.skipping,"Unread text cannot be skipped")
 stage.reveal_all()
 stage._toggle_skip()
 check(stage.skipping,"Revealed text can be skipped")
 stage.show_page(One.CHAPTERS[0]["intro"][1],state,"NEW","LANJUT",[],false)
 check(not stage.skipping,"Skip stops on next unread line")
 for page_value in Flow.all_pages(One).values():
  if page_value["speaker"] == "Rekaman Liora":
   stage.show_page(page_value,state,"BUKU I / LATIHAN REKAMAN","LANJUT",["aren","liora","nyx"],false)
   stage.reveal_all()
   await shot("recording")
   check(stage.speaker.text.contains("Rekaman"),"Recording speaker badge")
   break
 var state2 := Flow.initial(Two)
 for page_value in Flow.all_pages(Two).values():
  if page_value.get("cast",[]).has("banyu"):
   stage.show_page(page_value,state2,"BUKU II / AKAR UNTUK ESOK","LANJUT",Cast.PEOPLE.keys(),false)
   stage.reveal_all()
   await shot("garden")
   break
 stage.stop_auto()
 # Exercise timed reading, choice gates, hidden text, variants, profile callbacks and persisted preferences.
 stage.apply_preferences({"text_speed":0,"font_size":30,"auto_delay":1})
 view.select_chapter(0)
 var before: int = view.progress["line"]
 stage._toggle_auto()
 stage._process(100)
 check(view.progress["line"] == before+1,"Auto advances a completed line")
 stage.stop_auto()
 stage.apply_preferences({"text_speed":45})
 view.advance()
 stage.toggle_hud()
 stage._process(100)
 check(stage.typing and stage.body.visible_characters == 0,"Hidden message window pauses typing")
 stage.request_next()
 check(stage.hud.visible and stage.typing,"Click restores hidden window without advancing")
 stage.reveal_all()
 stage.auto_button.grab_focus()
 var key := InputEventKey.new()
 key.keycode = KEY_SPACE
 key.pressed = true
 before = view.progress["line"]
 Input.parse_input_event(key)
 await process_frame
 check(view.progress["line"] == before+1 and not stage.auto_read,"Space advances despite toolbar focus")
 stage.open_people(Cast.PEOPLE.keys())
 var nyx_button: Button
 var detail: RichTextLabel
 var locked := 0
 for child in stage.modal.get_children():
  if child is Button and child.text == "Nyx": nyx_button = child
  if child is RichTextLabel: detail = child
 nyx_button.pressed.emit()
 check(detail.text.begins_with("Nyx"),"Profile callback selects correct character")
 stage.close_modal()
 stage.open_people(["aren"])
 for child in stage.modal.get_children():
  if child is Button and child.text == "Belum dikenal" and child.disabled: locked += 1
 check(locked == 6,"Unknown profiles stay locked")
 stage.close_modal()
 for candidate in Flow.all_pages(One).values():
  if candidate.has("choice"):
   stage.show_page(candidate,Flow.initial(),"CHOICE","LANJUT",[],false)
   stage.reveal_all()
   stage._toggle_auto()
   stage._toggle_skip()
   check(not stage.auto_read and not stage.skipping and stage.next_button.disabled and stage.choice_buttons[0].visible,"Player must select a choice manually")
   break
 for candidate in One.ENDING:
  if candidate.has("variant"):
   var variant_state := Flow.initial()
   var variants: Array = candidate["variants"].keys()
   variant_state["choices"][candidate["variant"]] = variants[0]
   variant_state["read"] = [Flow.read_key(candidate,variant_state)]
   variant_state["choices"][candidate["variant"]] = variants[1]
   stage.show_page(candidate,variant_state,"VARIANT","LANJUT",[],false)
   check(stage.typing,"Previously read alternate response does not skip unseen variant")
   break
 var store := Store.new()
 store.path = "user://vn_preferences_test.json"
 store.vn_preferences = {"text_speed":0.0,"font_size":30,"auto_delay":4.0}
 check(store.save_data() == OK,"Reading preferences save")
 var reload := Store.new()
 reload.path = store.path
 reload.load_data()
 check(reload.vn_preferences == store.vn_preferences,"Reading preferences survive reload")
 stage.stop_auto()
 view.queue_free()
 await process_frame
 print("VISUAL NOVEL: %d checks / %d failures" % [checks,failures])
 quit(0 if failures == 0 else 1)
