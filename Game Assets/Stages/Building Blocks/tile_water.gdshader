shader_type canvas_item;

uniform sampler2D noise0 : repeat_enable;
uniform sampler2D noise1 : repeat_enable;
uniform vec2 scroll0 = vec2(0.2, 0.0);
uniform vec2 scroll1 = vec2(-0.2, 0.0);
uniform float distort_power : hint_range(-1.0, 1.0) = 0.0003;
uniform float color_power : hint_range(0.0, 1.0) = 0.5;
uniform vec4 water_color : source_color;
uniform float top_light_low = 0.5;
uniform float top_light_high = 0.9;
uniform float top_light_power : hint_range(0.0, 1.0) = 0.4;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec2 alteredUV = UV;
	if(alteredUV.y > 0.5) alteredUV.y -= 0.5;
	vec2 noise0UV = alteredUV/(16.0*TEXTURE_PIXEL_SIZE);
	noise0UV += scroll0*TIME;
	
	int max_attempt = 100;
	int attempt = 0;
	while(noise0UV.x > 1.0 && attempt < max_attempt){
		noise0UV.x -= 1.0;
		attempt += 1;
	}
	while(noise0UV.y > 1.0 && attempt < max_attempt){
		noise0UV.y -= 1.0;
		attempt += 1;
	}
	
	vec2 noise1UV = alteredUV/(16.0*TEXTURE_PIXEL_SIZE);
	noise1UV += scroll1*TIME;
	
	attempt = 0;
	while(noise1UV.x > 1.0 && attempt < max_attempt){
		noise1UV.x -= 1.0;
		attempt += 1;
	}
	while(noise1UV.y > 1.0 && attempt < max_attempt){
		noise1UV.y -= 1.0;
		attempt += 1;
	}
	
	vec4 noise0_color = texture(noise0, noise0UV);
	vec4 noise1_color = texture(noise1, noise1UV);
	vec4 mixed_noise_color = mix(noise0_color, noise1_color, 0.5);
	
	vec2 distorted_screen_UV = SCREEN_UV + distort_power*(mixed_noise_color.rr - vec2(0.5, 0.5));
	vec4 distorted_screen_color = texture(SCREEN_TEXTURE, distorted_screen_UV);
	
	float top_light = smoothstep(top_light_low, top_light_high, mixed_noise_color.r);
	vec4 white = vec4(1.0, 1.0, 1.0, 1.0);
	vec4 display_color = mix(distorted_screen_color, white, 0.5*top_light*top_light_power);;
	display_color = mix(display_color, water_color, color_power);
	vec4 gray = vec4(0.5, 0.5, 0.5, 1.0);
	display_color = mix(display_color, gray, -0.5);
	
	vec4 tex_color = texture(TEXTURE, UV);
	
	COLOR = display_color;
	COLOR.a = tex_color.a;
	if(tex_color.r > 0.0) COLOR = mix(COLOR, white, 0.25);
}
