shader_type canvas_item;

uniform vec4 flash_color : source_color;
uniform float power : hint_range(0.0, 1.0) = 0.0;
uniform bool active = false;

void fragment() {
	if(active){
		vec4 tex_color = texture(TEXTURE, UV);
		COLOR = mix(tex_color, flash_color, power*tex_color.a);
	}
	
}
