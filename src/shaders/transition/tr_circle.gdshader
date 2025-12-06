shader_type canvas_item;
render_mode unshaded;
#include "res://src/shaders/_include/transition_base.gdshaderinc"
// https://godotshaders.com/shader/simple-circle-transition-2/

uniform float screen_width;
uniform float screen_height;

void fragment() {
	float ratio = screen_width / screen_height;
	float dist = distance(vec2(0.5, 0.5), vec2(mix(0.5, UV.x, ratio - .1), UV.y));
	COLOR.a = step(1. - progress, dist);
}