shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float power : hint_range(0.0, 10.0, 1.0) = 8.0;
const float power_multiplier = 0.001;
uniform float time_frequency = 2.0;
const float vertical_frequency = 8.0;

void fragment() {
	vec2 modified_uv = SCREEN_UV + vec2(power_multiplier*power*sin(2.0*vertical_frequency*PI*SCREEN_UV.y - 2.0*PI*time_frequency*TIME), 0.0);
	COLOR = texture(SCREEN_TEXTURE, modified_uv);
}
