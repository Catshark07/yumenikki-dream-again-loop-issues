shader_type canvas_item;

uniform float strength : hint_range(0.0, 1.0) = 0.4;
uniform float speed : hint_range(0.0, 2.0) = 0.333;
uniform float size : hint_range(1, 6) = 6;
uniform vec4 colour_overlay : source_color;

void fragment() {
  float t = TIME * speed;

  vec3 col = vec3(0.0);

  vec2 res=1.0/SCREEN_PIXEL_SIZE;

  // Convert SCREEN_UV to range [-1, 1], centering it
  vec2 pos = SCREEN_UV * 1.6 - 1.0;

  // Preserve aspect ratio manually using the screen resolution uniform
  pos.y *= (res.y / res.x);

  pos *= size; // Scale up for a larger effect

  for (float k = 1.; k < 7.0; k += 1.2) {
    pos.x += strength * sin(2.0 * t + k * 1.5 * pos.y) + t * 0.5;
    pos.y += strength * cos(2.0 * t + k * 1.5 * pos.x);
  }

  // Color calculation using time and position
  col += 0.45 + 0.45 * sin(TIME + pos.xyx + vec3(0.0, .0, 4.0));

  // Gamma correction
  col = pow(col, vec3(0.4545));

  // Set final output
  COLOR.rgb = col + colour_overlay.rgb;

}