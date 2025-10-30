shader_type canvas_item;

// ---- controls
uniform float horizon : hint_range(0.0,1.0);            // base waterline (0 = top, 1 = bottom)
uniform sampler2D noise;  // grayscale noise texture (repeatable)
uniform sampler2D noise2;  // second noise

uniform float wave_frequency : hint_range(0.0, 100.0);     // spatial frequency of waves
uniform float wave_magnitude : hint_range(0.0, .3);     // amplitude of waves (in UV units)
uniform float tides_magnitude : hint_range(0.0, .3);    // slow tide amplitude
uniform float noise_wave : hint_range(0.0, 3.0);          // noise influence
uniform float tides_speed : hint_range(0.0, 20.0);       // tide speed (set to 0 for static)
uniform float wave_speed : hint_range(0.0, 20.0);          // wave animation speed (set to 0 for static)

uniform vec4 water_color : source_color = vec4(0.16, 0.45, 0.75, 0.9);
uniform vec4 shine_color : source_color = vec4(1.0, 0.95, 0.8, 1.0);
uniform float shine_position = 0.5;      // X position (0..1) of the highlight stripe
uniform float shine_width = 0.12;        // width of the highlight stripe (0..1)
uniform float shine_intensity = 0.5;     // how strong the highlight is

// optional tuning for noise sampling scale
uniform float noise_scale = 2.0;
uniform float noise2_scale = 1.0;

void fragment() {
    vec2 uv = UV;               // 0..1 inside the sprite area
    float t = TIME;

    // --- compute base wave level (in UV space)
    float wave = horizon;
    // horizontal waves
    wave += sin(uv.x * wave_frequency + t * wave_speed) * wave_magnitude;
    // slow tide
    wave += sin(t * tides_speed) * tides_magnitude;

    // noise contribution (UV-space noise, repeatable)
    float n1 = texture(noise, uv * noise_scale + vec2(t * 0.02, 0.0)).r;
    float n2 = texture(noise2, uv * noise2_scale).r;
    float noise_val = n1 * n2;
    wave -= noise_val * 0.02 * noise_wave; // small random displacement

    // --- determine how far below the surface this fragment is
    // smoothstep gives a soft edge near the surface; tweak the thickness as needed
    float surface_thickness = 0.02; // thickness (in UV) over which the edge blends
    float below = smoothstep(wave, wave + surface_thickness, uv.y); // 0 at surface, 1 deeper

    // If you want totally hard edge: uncomment next line and comment the smoothstep line above
    // float below = step(wave, uv.y);

    // --- base water color and simple vertical gradient by depth
    vec4 col = water_color;
    float depth_darkening = mix(1.0, 0.7, clamp((uv.y - wave) * 2.0, 0.0, 1.0)); // deeper = darker
    col.rgb *= depth_darkening;

    // --- add a simple highlight (shine) concentrated near the surface and at X = shine_position
    // a gaussian-like falloff in X and a tight falloff in Y near the surface
    float x_falloff = exp(-pow((uv.x - shine_position) / max(0.0001, shine_width), 2.0));
    float y_falloff = exp(-pow((uv.y - wave) * 200.0, 2.0)); // very tight in Y around the surface
    float shine = x_falloff * y_falloff * shine_intensity;
    col = mix(col, shine_color, clamp(shine, 0.0, 1.0));

    // --- final alpha: visible only where below > 0
    col.a *= below;

    COLOR = col;
}
