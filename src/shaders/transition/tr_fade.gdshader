shader_type canvas_item;

#include "res://src/shaders/_include/general_base.gdshaderinc"
#include "res://src/shaders/_include/transition_base.gdshaderinc"

void fragment()
{
	COLOR.rgb = colour.rgb;
	COLOR.a = (progress);
}