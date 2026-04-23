#version 440

layout(location = 0) out vec4 fragColor;
layout(location = 0) in vec2 qt_TexCoord0;

layout(std140, binding = 0) uniform buf {
    float time;
    vec4 blobColor;
};

void main()
{
    vec2 uv = qt_TexCoord0 - vec2(0.3,0.4);
    float d = length(uv);

    float wave =
        sin(d*8.0 - time*1.5)*0.03 +
        sin(uv.x*6.0 + time)*0.02 +
        sin(uv.y*6.0 + time*1.3)*0.02;

    float blob = smoothstep(0.44 + wave, 0.45 + wave, d);

    fragColor = vec4(blobColor.rgb, blob * 0.6);
}
