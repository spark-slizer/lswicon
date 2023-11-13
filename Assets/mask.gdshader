shader_type canvas_item;

uniform sampler2D mask;
uniform float scale;
uniform bool enabled = true;

varying vec2 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0, 1.0)).xy/(vec2(512,512)*scale);
}

void fragment() {
	if (enabled) {
		COLOR.a *= texture(mask, world_position).a;
	}
}
