shader_type canvas_item;

uniform float pix = 32.;
uniform vec4 outline_col : source_color;
uniform bool flash;

void fragment() {
	if (COLOR.a < 0.01) {
		vec2 diff1 = vec2(-1.,0.)*(1.0/pix);
		vec2 diff2 = vec2(0.,1.)*(1.0/pix);
		vec2 diff3 = vec2(1.,0.)*(1.0/pix);
		vec2 diff4 = vec2(0.,-1.)*(1.0/pix);
		if (texture(TEXTURE,UV+diff1).a > 0.01 ||
			texture(TEXTURE,UV+diff2).a > 0.01 ||
			texture(TEXTURE,UV+diff3).a > 0.01 ||
			texture(TEXTURE,UV+diff4).a > 0.01) {
			COLOR = outline_col;
		}
	}
	else if (flash) COLOR.rgb = vec3(1.);
}