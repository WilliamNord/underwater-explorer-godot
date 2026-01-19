shader_type canvas_item;

uniform bool inverted = false;
uniform float velocity = 0.1;

uniform float speed = 4.0;
uniform float height = 1.0;
uniform float freq = 14.0;

void vertex() {
	VERTEX.y += height * cos((UV.x * freq) * (speed * TIME));
}

void fragment() {
	vec2 newuv = UV;
	if (inverted) {
		newuv.x -= TIME * velocity;
	} else {
		newuv.x += TIME * velocity;
	}

	vec4 c = texture(TEXTURE, newuv);
	COLOR = c;
}
