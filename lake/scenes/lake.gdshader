shader_type canvas_item;

uniform sampler2D water;
uniform int samples = 10;
uniform sampler2D waternoise;

void fragment() {
	int made = 0;
	for (int i=0; i<samples; i++){
		float d = float(i) * 0.02 * 1.0/float(samples);
		float angle = float(i) * PI * 1.618;
		if (texture(TEXTURE,UV+vec2(d*cos(angle),d*-sin(angle))).a > 0.5) {
			made += 1;
		}
		float f = (float(made)/float(samples))*2.-0.9;
		f = pow(f,3.);
		f *= pow(texture(waternoise,UV).r,1.9);
		COLOR.rgb = texture(water,vec2(f)).rgb;
	}
}