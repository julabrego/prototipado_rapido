shader_type canvas_item;

uniform vec3 ORIGINAL_COLOR : source_color = vec3(0.0, 0.0, 0.0);

uniform float THRESHOLD = 0.3;

uniform vec3 NEW_COLOR: source_color = vec3(0.8, 0.0, 0.0);

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    vec3 current_color = texture_color.rgb;

    float color_distance = length(current_color - ORIGINAL_COLOR);
    float color_factor = step(color_distance, THRESHOLD);
    vec3 modified_color = mix(current_color, NEW_COLOR, color_factor);

    COLOR = vec4(modified_color, texture_color.a);
}
