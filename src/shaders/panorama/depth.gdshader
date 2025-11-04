shader_type canvas_item;

#include "res://src/shaders/_include/depth_base.gdshaderinc"
#include "res://src/shaders/_include/general_base.gdshaderinc"


void vertex() {
	UV = _depth_vertex(UV, TEXTURE_PIXEL_SIZE);
}

void fragment()
{
	COLOR *= overlay_modulate;
}
	