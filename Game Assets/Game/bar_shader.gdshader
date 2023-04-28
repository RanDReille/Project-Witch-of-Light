shader_type canvas_item;

uniform vec4 tint_color : source_color;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	COLOR = mix(tex_color, tint_color, min(tint_color.a, tex_color.a));
}
