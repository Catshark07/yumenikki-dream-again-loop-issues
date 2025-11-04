shader_type canvas_item;
#include "res://src/shaders/_include/linear_base.gdshaderinc"
#include "res://src/shaders/_include/general_base.gdshaderinc"

void vertex()
{
	UV = _depth_vertex(UV, TEXTURE_PIXEL_SIZE);
}

void fragment()
{
	vec4 frag = _linear_fragment(UV, TEXTURE);
	COLOR = vec4(frag.rgb, frag.a - transparency);
}
