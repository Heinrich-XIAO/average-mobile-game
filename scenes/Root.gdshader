shader_type canvas_item;

const float curvature = 7.0;
const float vignette_multiplier = 1.0;
uniform float colour_offset : hint_range(0.0, 0.01) = 0.002;

uniform float power_off : hint_range(0.0, 1.0) = 1.0;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 centered_uv = (SCREEN_UV * 2.0 - 1.0) * 1.05;
    vec2 uv_offset = centered_uv.yx / curvature;
    vec2 warped_uv = centered_uv + centered_uv * uv_offset * uv_offset;
    vec2 base_uv = (warped_uv + 1.0) / 2.0;

    vec3 cutoff = vec3(step(abs(warped_uv.x), 1.0) * step(abs(warped_uv.y),
		mix(power_off, max(power_off * 2.0 - 1.0, 0.01), step(0.01, power_off))));
    vec3 scan_lines = vec3(sin(warped_uv.y * 180.0 * 2.0) * 0.025 + 0.975);
    vec3 scan_columns = vec3(sin(warped_uv.x * 180.0 * 2.0) * 0.025 + 0.975);
    vec3 vignette = vec3(length(pow(abs(centered_uv), vec2(4.0)) / 3.0));

    float r = textureLod(screen_texture, base_uv + vec2(colour_offset, colour_offset), 0.0).r;
    float g = textureLod(screen_texture, base_uv, 0.0).g;
    float b = textureLod(screen_texture, base_uv - vec2(colour_offset, colour_offset), 0.0).b;

    vec3 separated_color = vec3(r, g, b);
    vec3 final_color = separated_color * cutoff * scan_lines * scan_columns - vignette * vignette_multiplier;

    float frac = clamp((power_off - 0.1) / (0.4 - 0.1), 0.0, 1.0);
    float dist_x = abs(centered_uv.x);
    float line_mask = step(dist_x, frac);
    float brightness = 1.0 + (1.0 - frac) * 2.0;

    float collapse_mask = mix(line_mask * brightness, 1.0, step(0.4, power_off));

	final_color += collapse_mask - 1.0;
    final_color *= collapse_mask;

    final_color *= cutoff;

    COLOR = vec4(final_color, 1.0);
}
