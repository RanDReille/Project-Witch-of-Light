shader_type canvas_item;

uniform sampler2D flame_color;
uniform sampler2D noise0;
uniform sampler2D noise1;
uniform vec2 noise0_velocity;
uniform vec2 noise1_velocity;
uniform bool flame_active = false;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	vec2 noise0_UV = UV + noise0_velocity*TIME;
	noise0_UV.x -= floor(noise0_UV.x);
	noise0_UV.y -= floor(noise0_UV.y);
	vec2 noise1_UV = UV + noise1_velocity*TIME;
	noise1_UV.x -= floor(noise1_UV.x);
	noise1_UV.y -= floor(noise1_UV.y);
	vec4 noise0_color = texture(noise0, noise0_UV);
	vec4 noise1_color = texture(noise1, noise1_UV);
	
	if(flame_active){
		vec4 noise_color = mix(noise0_color, noise1_color, 0.5);
		COLOR = texture(flame_color, noise_color.rr);
	}else{
		COLOR = mix(noise0_color, noise1_color, 0.5);
		COLOR = mix(COLOR, vec4(1.0, 1.0, 1.0, 1.0), 0.5);
		COLOR.a = COLOR.r;
	}
	COLOR.a = tex_color.a;
}
