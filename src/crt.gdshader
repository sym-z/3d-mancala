shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float contrast  = 0.75;
uniform float scanline_frequency = 3.;
uniform float banding_strength = 0.2;
uniform float transparancy = 0.7;
void fragment() {
	// Sample Screen
	COLOR = texture(screen_texture, SCREEN_UV);
	// Static Scanlines
	if (mod(FRAGCOORD.y,scanline_frequency) <= 1.){
		COLOR.rgb *= contrast;
	}
	// Wave of Banding
	float band = abs(cos(FRAGCOORD.y + TIME)) * 1.;
	COLOR.rgb *= clamp(band,0.7,1.);
	COLOR.a *= transparancy;
}
