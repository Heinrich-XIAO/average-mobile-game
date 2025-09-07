shader_type canvas_item;

uniform float radius : hint_range(0.0, 0.5) = 0.1; // in UV units (0.5 = max round)
uniform vec2 offset = vec2(0.0, 0.0);

void fragment() {
    // Brighten base color
    vec4 col = vec4(COLOR.rgb * 3.0, 1.0);

    // Centered UV coords (-0.5 .. 0.5)
    vec2 uv = UV - 0.5 + offset;
    vec2 half_size = vec2(0.5);

    // Rounded rectangle SDF
    vec2 d = length(uv) - (half_size - vec2(radius));
    float dist = length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);

    // Hard cutoff (inside = 1, outside = 0)
    float alpha = dist < 0.0 ? 1.0 : 0.0;

    COLOR = vec4(col.rgb, alpha);
}
