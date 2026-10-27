extends RefCounted
static func clean(raw) -> Dictionary:
	var result := {"text_speed":45.0,"font_size":26,"auto_delay":2.0}
	if not raw is Dictionary: return result
	for key in ["text_speed","auto_delay"]:
		var value = raw.get(key,result[key])
		if (value is int or value is float) and is_finite(float(value)): result[key] = clampf(float(value),0 if key == "text_speed" else 1,80 if key == "text_speed" else 8)
	var font = raw.get("font_size",26)
	if (font is int or font is float) and is_finite(float(font)) and float(font) in [26.0,30.0]: result["font_size"] = int(font)
	return result
