shader_type sky;
uniform float r_spd = 0.593;
uniform float g_spd = 1.03;
uniform float b_spd = 0.683;
uniform float total_spd = 0.18;
uniform float brightness = 0.235;
uniform float min_bright = 0.4;
uniform float max_bright = 1.0;
uniform sampler2D tex;
void sky() {
	// Called for every visible pixel in the sky background, as well as all pixels
	// in the radiance cubemap.
	vec3 tint = vec3(clamp(1.*abs(sin(TIME*r_spd*total_spd)),min_bright, max_bright),1.*clamp(abs(sin(TIME*g_spd*total_spd)),min_bright,max_bright),1.*clamp(abs(sin(TIME*b_spd*total_spd)),min_bright,max_bright)) * brightness;
	vec2 uv = SKY_COORDS;
	uv.x += cos(TIME*0.05);
	COLOR.rgb = texture(tex,uv).rgb * tint;
}
