extends RefCounted
const Data = preload("res://scripts/story_data.gd")
const Cast = preload("res://scripts/vn_cast.gd")
const ALLOWED_CHOICES = {"memory":["care","laughter"],"reply":["honest","uncertain"],"ritual":["lamp","table"]}
static func initial(book = Data) -> Dictionary:
	return {"version":1,"book":book.BOOK_ID,"started":false,"chapter":0,"cleared":0,"phase":"intro","line":0,"choices":{},"vn_revision":2,"page_id":"","known":["aren"],"read":[],"history":[],"migration":false}
static func all_pages(book = Data) -> Dictionary:
	var result := {}
	for chapter in book.CHAPTERS:
		for phase in ["intro","win","loss"]:
			for page in chapter[phase]: result[page["id"]] = page
	for page in book.ENDING: result[page["id"]] = page
	return result
static func clean(raw, book = Data) -> Dictionary:
	var result := initial(book)
	if not raw is Dictionary or raw.get("version",0) != 1 or raw.get("book","") != book.BOOK_ID: return result
	for key in ["cleared","chapter","line"]:
		var value = raw.get(key,0)
		if (value is int or value is float) and is_finite(float(value)): result[key] = maxi(0,int(value))
	result["cleared"] = mini(result["cleared"],book.CHAPTERS.size())
	result["chapter"] = mini(result["chapter"],mini(result["cleared"],book.CHAPTERS.size()-1))
	var phase: String = str(raw.get("phase","intro"))
	if phase in ["intro","duel","win","loss","ending","complete"]: result["phase"] = phase
	if phase == "win" and result["cleared"] <= result["chapter"]: result["phase"] = "intro"
	if phase in ["ending","complete"] and result["cleared"] < book.CHAPTERS.size(): result["phase"] = "intro"
	if result["phase"] in ["ending","complete"]: result["chapter"] = book.CHAPTERS.size()-1
	result["started"] = raw.get("started",false) == true
	result["migration"] = raw.get("migration",false) == true
	if raw.get("vn_revision",0) != 2:
		result["line"] = 0
		result["migration"] = result["started"] or result["cleared"] > 0
	var choices = raw.get("choices",{})
	if choices is Dictionary:
		for key in book.CHOICES:
			if choices.get(key,"") in book.CHOICES[key]: result["choices"][key] = choices[key]
	var lines: Array = pages(result,book)
	result["line"] = mini(result["line"],maxi(0,lines.size()-1))
	var page_id = raw.get("page_id","")
	if page_id is String:
		for i in range(lines.size()):
			if lines[i]["id"] == page_id:
				result["line"] = i
				result["page_id"] = page_id
	var people = raw.get("known",[])
	if people is Array:
		for id in people:
			if id is String and Cast.PEOPLE.has(id) and not result["known"].has(id): result["known"].append(id)
	# Preserve knowledge at unlocked chapters for profiles saved before the VN rewrite.
	if result["migration"]:
		for i in range(mini(result["cleared"]+1,book.CHAPTERS.size())):
			if i == result["cleared"] and result["phase"] != "duel": break
			for page in book.CHAPTERS[i]["intro"]:
				for id in page.get("cast",[]):
					if Cast.PEOPLE.has(id) and not result["known"].has(id): result["known"].append(id)
	var index: Dictionary = all_pages(book)
	var read = raw.get("read",[])
	if read is Array:
		for key in read:
			if not key is String or result["read"].has(key): continue
			var pieces: PackedStringArray = key.split(":")
			if not index.has(pieces[0]): continue
			if pieces.size() == 1 or (pieces.size() == 2 and index[pieces[0]].get("variants",{}).has(pieces[1])): result["read"].append(key)
	var history = raw.get("history",[])
	if history is Array:
		for item in history.slice(maxi(0,history.size()-80)):
			if item is Dictionary and item.get("page") is String and index.has(item["page"]) and item.get("who") is String and item.get("text") is String:
				result["history"].append({"page":item["page"],"who":item["who"].left(60),"text":item["text"].left(600)})
	return result
static func pages(state: Dictionary, book = Data) -> Array:
	if state["phase"] == "ending": return book.ENDING
	return book.CHAPTERS[state["chapter"]].get(state["phase"],[])
static func page_text(page: Dictionary, state: Dictionary) -> String:
	if page.has("variant"): return page["variants"].get(state["choices"].get(page["variant"],""),page["text"])
	return page["text"]
static func read_key(page: Dictionary, state: Dictionary) -> String:
	if page.has("variant") and state["choices"].has(page["variant"]):
		return page["id"]+":"+str(state["choices"][page["variant"]])
	return page["id"]
