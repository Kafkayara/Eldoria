extends SceneTree
const Catalog = preload("res://scripts/catalog.gd")
const Art = preload("res://scripts/card_art.gd")
var board
var failures: int = 0
var checks: int = 0
var capture_dir: String = ""

func _initialize() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--capture-dir="):
			capture_dir = argument.trim_prefix("--capture-dir=")
	call_deferred("_run")

func check(ok: bool, label: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		push_error("FAIL: "+label)

func capture(name_value: String) -> void:
	await process_frame
	await process_frame
	if capture_dir.is_empty() or DisplayServer.get_name() == "headless":
		return
	RenderingServer.force_draw(false)
	root.get_texture().get_image().save_png(capture_dir.path_join(name_value+".png"))

func signature() -> String:
	return JSON.stringify({"lp":board.duel.lp,"hands":board.duel.hands,"fields":board.duel.fields,"decks":board.duel.decks,"turn":board.duel.turn,"number":board.duel.turn_number})

func button_in(node: Node, text_value: String):
	for child in node.get_children():
		if child is Button and child.text == text_value:
			return child
	return null

func _run() -> void:
	root.size = Vector2i(1280,720)
	root.content_scale_size = Vector2i(1280,720)
	board = load("res://main.tscn").instantiate()
	root.add_child(board)
	await process_frame
	var original: String = signature()
	var sources: Dictionary = {}
	var pixels: Dictionary = {}
	for id in Catalog.CARDS:
		var card: Dictionary = Catalog.card(id)
		var key: String = Art.source_key(card)
		check(not sources.has(key),"Unique art source: "+id)
		sources[key] = true
		var texture: Texture2D = Art.texture_for(card)
		var region: Rect2 = Art.region_for(card)
		check(texture != null and region.size.x > 0 and region.size.y > 0,"Art exists: "+id)
		var image: Image = texture.get_image()
		if image.is_compressed():
			image.decompress()
		var artwork: Image = image.get_region(Rect2i(region))
		artwork.convert(Image.FORMAT_RGBA8)
		var digest := HashingContext.new()
		digest.start(HashingContext.HASH_SHA256)
		digest.update(artwork.get_data())
		var fingerprint: String = digest.finish().hex_encode()
		check(not pixels.has(fingerprint),"Unique image pixels: "+id)
		pixels[fingerprint] = true
	check(sources.size() == Catalog.CARDS.size() and pixels.size() == Catalog.CARDS.size(),"Every card has distinct art")
	await capture("eldoria-v05-menu")
	var gallery_button = button_in(board.menu_layer,"GALERI KARTU")
	check(gallery_button != null,"Gallery button in starting menu")
	gallery_button.pressed.emit()
	var g = board.gallery
	check(g.visible and board.menu_layer.visible,"Gallery opens over menu")
	check(g.visible_ids.size() == Catalog.CARDS.size() and g.tiles.size() == Catalog.CARDS.size(),"All current card types shown")
	check(g.visible_ids[0] == "warden","Cards sorted alphabetically")
	check(g.selected_card["id"] == "warden","First card selected")
	await capture("eldoria-v05-gallery")
	g.filter_buttons["monster"].pressed.emit()
	check(g.visible_ids.size() == 10,"Monster filter")
	for id in g.visible_ids:
		check(Catalog.CARDS[id]["kind"] == "monster","Monster-only results")
	g.select_card("sprite")
	check(g.preview.data["id"] == "sprite" and "ambil" in g.description.text,"Selecting fairy updates art and effect")
	g.filter_buttons["spell"].pressed.emit()
	check(g.visible_ids.size() == 5,"Spell filter")
	for id in g.visible_ids:
		check(Catalog.CARDS[id]["kind"] == "spell","Spell-only results")
	g.filter_buttons["trap"].pressed.emit()
	check(g.visible_ids.size() == 3,"Trap filter")
	for id in g.visible_ids:
		check(Catalog.CARDS[id]["kind"] == "trap","Trap-only results")
	g.filter_buttons["spell"].pressed.emit()
	g.select_card("blessing")
	check(g.preview.data["id"] == "blessing","Spell preview updates")
	await capture("eldoria-v05-spells")
	g.search_box.text = "retakan"
	g.search_box.text_changed.emit("retakan")
	check(g.visible_ids.size() == 1 and g.visible_ids[0] == "eclipse","Search within category")
	g.filter_buttons[""].pressed.emit()
	g.search_box.text = "AEGIS SURYA"
	g.search_box.text_changed.emit("AEGIS SURYA")
	check(g.visible_ids.size() == 1 and g.visible_ids[0] == "warden","Case-insensitive search")
	g.search_box.text = "zzzz-tidak-ada"
	g.search_box.text_changed.emit("zzzz-tidak-ada")
	check(g.visible_ids.is_empty() and g.empty_state.visible and g.detail_button.disabled,"Empty search is handled")
	g.search_box.text = ""
	g.search_box.text_changed.emit("")
	check(g.visible_ids.size() == Catalog.CARDS.size(),"Clearing query restores catalog")
	g.select_card("warden")
	g.detail_button.pressed.emit()
	check(board.zoom_layer.visible and board.zoom_title.text == "Aegis Surya","Gallery detail button")
	check(board.zoom_close_button.text == "KEMBALI KE GALERI","Detail return button matches gallery context")
	check(board.zoom_card.data["art_file"] == "res://assets/art/aegis_surya.png","Detail uses new illustration")
	await capture("eldoria-v05-aegis-detail")
	var cancel := InputEventAction.new()
	cancel.action = "ui_cancel"
	cancel.pressed = true
	board._unhandled_key_input(cancel)
	check(not board.zoom_layer.visible and g.visible,"Esc returns to gallery from detail")
	var key := InputEventKey.new()
	key.keycode = KEY_E
	key.pressed = true
	board._unhandled_key_input(key)
	check(board.zoom_layer.visible,"E opens gallery selection while menu is behind")
	board._unhandled_key_input(cancel)
	g.tiles["warden"]._inspect_input(_right_click())
	check(board.zoom_layer.visible,"Gallery right-click details")
	board._unhandled_key_input(cancel)
	var double_click := InputEventMouseButton.new()
	double_click.button_index = MOUSE_BUTTON_LEFT
	double_click.double_click = true
	double_click.pressed = true
	g._tile_input(double_click,"sprite")
	check(board.zoom_layer.visible and board.zoom_title.text == "Peri Astral","Double-click details")
	board._unhandled_key_input(cancel)
	board._unhandled_key_input(cancel)
	check(not g.visible and board.menu_layer.visible,"Esc closes gallery to starting menu")
	check(signature() == original,"Browsing does not modify duel state")
	gallery_button.pressed.emit()
	check(g.visible_ids.size() == Catalog.CARDS.size() and g.query.is_empty() and g.category.is_empty(),"Reopen resets filters")
	g.closed.emit()
	check(not g.visible,"Back button closes gallery")
	board._begin_duel(0)
	check(not g.visible and not board.menu_layer.visible and board.duel.turn_number == 1,"Duel starts normally after browsing")
	board._open_menu()
	board.queue_free()
	await process_frame
	await create_timer(0.3).timeout
	print("GALLERY CHECKS: %d / FAILURES: %d / UNIQUE ARTWORKS: %d" % [checks,failures,pixels.size()])
	quit(0 if failures == 0 else 1)

func _right_click() -> InputEventMouseButton:
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_RIGHT
	event.pressed = true
	return event

