shader_type sky;
uniform float r_spd = 0.593;
uniform float g_spd = 1.03;
uniform float b_spd = 0.683;
uniform float total_spd = 0.18;
uniform float brightness = 0.235;
void sky() {
	// Called for every visible pixel in the sky background, as well as all pixels
	// in the radiance cubemap.
	COLOR = vec3(1.*abs(sin(TIME*r_spd*total_spd)),1.*abs(sin(TIME*g_spd*total_spd)),1.*abs(sin(TIME*b_spd*total_spd))) * brightness;
	
}
