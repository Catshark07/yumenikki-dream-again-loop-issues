render_mode world_vertex_coords;

global uniform vec2 uv_offset;

group_uniforms depth;
uniform vec2 initial_uv_offset;

uniform float offset_strength;
uniform vec2 offset_strength_influence = vec2(1.);

vec2 _depth_vertex(vec2 uv, vec2 _pixel_size)
{
	vec2 uv_offset_snapped = ((uv_offset * offset_strength * offset_strength_influence) + initial_uv_offset);

	float depth_x = (vec4(uv, _pixel_size).xy + (uv_offset_snapped / 1.2)).x;
	float depth_y = (vec4(uv, _pixel_size).xy + (uv_offset_snapped / 1.6)).y;



	uv.x = depth_x;
	uv.y = depth_y;

	return uv;
}
