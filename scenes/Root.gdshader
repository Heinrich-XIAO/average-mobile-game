shader_type canvas_item;

const float curvature = 7.0;
const float vignette_multiplier = 1.0;
uniform float color_offset : hint_range(0.0, 0.01) = 0.002;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 centered_uv = SCREEN_UV * 2.0 - 1.0;
    vec2 uv_offset = centered_uv.yx / curvature;
    vec2 warped_uv = centered_uv + centered_uv * uv_offset * uv_offset;
    vec2 base_uv = (warped_uv + 1.0) / 2.0;

    vec3 cutoff = vec3(step(abs(warped_uv.x), 1.0) * step(abs(warped_uv.y), 1.0));
    vec3 scan_lines = vec3(sin(warped_uv.y * 180.0 * 2.0) * 0.05 + 0.95);
    vec3 vignette = vec3(length(pow(abs(centered_uv), vec2(4.0)) / 3.0));

    float r = textureLod(screen_texture, base_uv + vec2(color_offset, 0.0), 0.0).r;
    float g = textureLod(screen_texture, base_uv, 0.0).g;
    float b = textureLod(screen_texture, base_uv - vec2(color_offset, 0.0), 0.0).b;

    vec3 separated_color = vec3(r, g, b);
    vec3 final_color = separated_color * cutoff * scan_lines - vignette * vignette_multiplier;

    COLOR = vec4(final_color, 1.0);
}
