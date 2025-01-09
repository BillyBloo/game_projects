shader_type canvas_item;

uniform sampler2D grass_noise;
uniform sampler2D grass_col_noise;
uniform sampler2D grass_grad;

uniform float pix = 540.;

void fragment() {
	vec2 pos = UV;
	pos.x = floor(pos.x*pix)/pix;
	pos.y = floor(pos.y*pix)/pix;
	COLOR = texture(grass_grad,vec2(0.));
	for (int i=0;i<5;i++) {
		float x = 0.0025*sin(float(i)+pos.x*13.+pos.y*7.)*float(i);
		x = round(x*pix)/pix;
		vec2 samp_pos = pos + vec2(x,(1.0/pix)*float(i));
		float sample = texture(grass_noise,samp_pos).r;
		if (sample > 0.01) {
			COLOR = texture(grass_grad,vec2(sample/texture(grass_col_noise,samp_pos).r));
		}
	}
}