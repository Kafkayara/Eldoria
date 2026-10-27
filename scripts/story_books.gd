extends RefCounted
const First = preload("res://scripts/story_data.gd")
const Second = preload("res://scripts/story_rimba_data.gd")
const Flow = preload("res://scripts/story_flow.gd")
static func data(id: String):
	return Second if id == Second.BOOK_ID else First
static func clean(raw, legacy: Dictionary) -> Dictionary:
	var books := {First.BOOK_ID:Flow.clean(legacy),Second.BOOK_ID:Flow.initial(Second)}
	if raw is Dictionary:
		# The legacy Book I field remains authoritative for backward compatibility.
		if raw.has(Second.BOOK_ID): books[Second.BOOK_ID] = Flow.clean(raw[Second.BOOK_ID],Second)
	return books
