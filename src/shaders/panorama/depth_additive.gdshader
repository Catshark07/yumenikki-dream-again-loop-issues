shader_type canvas_item;
render_mode blend_add;

#include "res://src/shaders/_include/depth_base.gdshaderinc"


void vertex() {UV = _depth_vertex(UV, TEXTURE_PIXEL_SIZE);}