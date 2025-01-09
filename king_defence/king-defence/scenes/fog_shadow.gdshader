shader_type canvas_item;

uniform sampler2D fog_grad;

uniform float tl = 1.;
uniform float tr = 1.;
uniform float bl = 1.;
uniform float br = 1.;

float lerp(float from, float to, float p) {
	return from * (1.-p) + to * p;
}

void fragment() {
	float l = lerp(tl,bl,UV.y);
	float r = lerp(tr,br,UV.y);
	float a = lerp(l,r,UV.x);
	a = pow(a,25.);
	vec2 pos = UV + vec2(1.,1.)*TIME*0.025;
	float w = 1.;
	pos.x = modf(pos.x,w);
	pos.y = modf(pos.y,w);

	COLOR = vec4(texture(fog_grad,vec2(a)));
	COLOR.a = pow(COLOR.a,.8);
}