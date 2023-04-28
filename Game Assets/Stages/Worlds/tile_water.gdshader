shader_type canvas_item;

uniform vec4 water_color = vec4(0.2, 0.5, 0.8, 1.0);
uniform float color_strength = 0.5;
uniform float distort_power = 0.01;
uniform float oscillate_speed = 2.0;
uniform float oscillate_power = 0.01;

uniform sampler2D noisex;
uniform sampler2D noisey;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
//const float PI = 3.14159;

vec4 noise_curl_check(float ncx, float ncy){
	float a = sqrt(ncx*ncx + ncy*ncy);
	float hue = atan(ncy, ncx)*3.0/PI;
	float rm, gm, bm;
	if (hue <= -2.0){
		rm = 0.0;
		gm = -hue-2.0;
		bm = 1.0;
	}else if(hue <= 1.0){
		rm = hue+2.0;
		gm = 0.0;
		bm = 1.0;
	}else if(hue <= 0.0){
		rm = 1.0;
		gm = 0.0;
		bm = -hue;
	}else if(hue <= 1.0){
		rm = 1.0;
		gm = hue;
		bm = 0.0;
	}else if(hue <= 2.0){
		rm = -hue+2.0;
		gm = 1.0;
		bm = 0.0;
	}else{
		rm = 0.0;
		gm = 1.0;
		bm = hue-2.0;
	}
	return vec4(rm, gm, bm, 1.0);
}

void fragment(){
	vec2 tile_size = 16.0*TEXTURE_PIXEL_SIZE;
	
	vec2 oscillation = vec2(oscillate_power*sin(oscillate_speed*TIME), 0.0);
	vec2 tex_UV = UV + oscillation;
	if(oscillation.x + UV.x-floor(UV.x/tile_size.x)*tile_size.x > tile_size.x){
		//tex_UV.x -= tile_size.x;
	}
	if(oscillation.x + UV.x-floor(UV.x/tile_size.x)*tile_size.x < 0.0){
		//tex_UV.x += tile_size.x;
	}
	
	vec4 tex_color = texture(TEXTURE, tex_UV).bbba;
	
	float rt_offset = oscillate_power*sin(oscillate_speed*TIME);
	vec4 real_tex_color = texture(TEXTURE, UV+rt_offset);
	
	vec2 noise_UV = UV/tile_size;
	vec2 noise_UV_offset = vec2(oscillate_power*sin(oscillate_speed*TIME), 0.0);
	vec4 noise_colorx = texture(noisex, noise_UV + 50.0*noise_UV_offset);
	vec4 noise_colory = texture(noisey, noise_UV + 50.0*noise_UV_offset);
	
	vec2 distorted_UV = SCREEN_UV;
	//distorted_UV.x += distort_power*(sin(2.0*PI*UV.y/(16.0*TEXTURE_PIXEL_SIZE.y)+oscillate_speed*TIME))*tex_color.a;
	//distorted_UV += distort_power*vec2(noise_colorx.b-0.5, noise_colory.b-0.5)*tex_color.a;
	//distorted_UV.x += oscillate_power*sin(oscillate_speed*TIME)*tex_color.a;
	
	vec4 screen_color = texture(SCREEN_TEXTURE, distorted_UV);
	//screen_color = mix(screen_color, 1.0-tex_color, (-1.0+1.0*tex_color.b)*tex_color.a);
	screen_color = mix(screen_color, vec4(1.0,1.0,1.0,1.0)-tex_color, -0.5*tex_color.a);
	//screen_color = mix(screen_color, vec4(1.0, 1.0, 1.0, 1.0), 0.4*step(0.3, real_tex_color.b - real_tex_color.r)*tex_color.a);
	
	COLOR = mix(screen_color, water_color, color_strength*tex_color.a);
	COLOR = tex_color;
	//COLOR = vec4(0.5 + 0.8*drtc.x, 0.5, 0.5 + 0.8*drtc.y, 1.0);
	//COLOR = tex_color;
	//COLOR = real_tex_color;
	//COLOR = noise_colory;
	//COLOR = noise_curl_check(noise_colorx.b - 0.5, noise_colory.b - 0.5);
	
}