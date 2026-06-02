shader_type canvas_item;
uniform float strength = 5.0;
void vertex() {
	VERTEX.x += strength*sin(VERTEX.x+TIME);
	VERTEX.y += strength*sin(VERTEX.y+TIME);
}

void fragment() {

	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
