extends RefCounted
const Data = preload("res://scripts/story_data.gd")
const ALLOWED_CHOICES = {"memory":["care","laughter"],"reply":["honest","uncertain"],"ritual":["lamp","table"]}
static func initial(book = Data) -> Dictionary:
	return {"version":1,"book":book.BOOK_ID,"started":false,"chapter":0,"cleared":0,"phase":"intro","line":0,"choices":{}}
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
	var choices = raw.get("choices",{})
	if choices is Dictionary:
		for key in book.CHOICES:
			if choices.get(key,"") in book.CHOICES[key]: result["choices"][key] = choices[key]
	var lines: Array = pages(result,book)
	result["line"] = mini(result["line"],maxi(0,lines.size()-1))
	return result
static func pages(state: Dictionary, book = Data) -> Array:
	var phase: String = state["phase"]
	if phase == "ending": return book.ENDING
	return book.CHAPTERS[state["chapter"]].get(phase,[])
static func page_text(page: Dictionary, state: Dictionary) -> String:
	if page.has("variant"):
		return page["variants"].get(state["choices"].get(page["variant"],""),page["text"])
	return page["text"]
