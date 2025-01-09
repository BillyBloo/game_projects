shader_type canvas_item;

uniform vec4 shadow_col : source_color;
void fragment() {
	if (length(UV-vec2(0.5)) < .5) COLOR = shadow_col;
	else COLOR.a = 0.;
}