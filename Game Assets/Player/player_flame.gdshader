shader_type canvas_item;

uniform sampler2D flame_color;
uniform sampler2D noise0;
uniform sampler2D noise1;
uniform vec2 noise0_velocity;
uniform vec2 noise1_velocity;

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
	
	vec4 noise_color = mix(noise0_color, noise1_color, 0.5);
	noise_color.rgb *= UV.yyy;
	COLOR = texture(flame_color, noise_color.rr);
	COLOR.a *= 0.75;
	COLOR.a *= 1.0+4.0*(0.5-UV.x)*(UV.x-0.5);
	/*if(UV.y > 0.5){
		float multiplier = 8.5+(4.0*(-UV.y-(1.0 - (0.5-UV.x)*(UV.x-0.5) )));
		multiplier = clamp(multiplier, 0.0, 1.0);
		COLOR.a *= multiplier;
	}*/
}
