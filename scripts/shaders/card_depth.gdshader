shader_type canvas_item;
uniform vec4 atlas_region = vec4(0.0, 0.0, 1.0, 1.0);
uniform vec4 accent : source_color = vec4(1.0, 0.7, 0.3, 1.0);
uniform float tilt = 0.0;
uniform float reveal = 1.0;
uniform float shine = 0.5;
uniform float zoom = 1.0;
uniform float focus = 0.45;
varying vec4 item_tint;

void vertex() {
	item_tint = COLOR;
}

void fragment() {
	// Inverse projection samples only the selected atlas cell.
	vec2 p = UV - vec2(0.5);
	p.x /= 1.0 + tilt * p.y;
	p.y += tilt * p.x * 0.10;
	vec2 panel = p + vec2(0.5);
	vec2 sample_uv = p / zoom + vec2(0.5);
	sample_uv.y = sample_uv.y * 0.68 + clamp(focus - 0.34, 0.0, 0.32);
	vec2 safe_uv = clamp(sample_uv, vec2(0.002), vec2(0.998));
	vec4 art = texture(TEXTURE, atlas_region.xy + safe_uv * atlas_region.zw);
	float edge = smoothstep(0.0, 0.045, panel.x) * (1.0 - smoothstep(0.955, 1.0, panel.x));
	edge *= smoothstep(0.0, 0.06, panel.y) * (1.0 - smoothstep(0.88, 1.0, panel.y));
	float sweep = pow(max(0.0, 1.0 - abs(panel.x + panel.y * 0.24 - shine * 1.6) * 7.0), 3.0);
	float vignette = 1.0 - 0.36 * length(p);
	COLOR = vec4(art.rgb * vignette * (0.55 + 0.45 * reveal) + accent.rgb * sweep * 0.19, art.a * edge * reveal) * item_tint;
}
