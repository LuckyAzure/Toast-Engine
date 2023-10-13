shader_type canvas_item;

uniform vec4 color : source_color;
uniform float mixture;

void fragment() 
{
    vec4 tex = texture(TEXTURE, UV);
    COLOR.a = tex.a;
    COLOR.rgb = mix(tex.rgb, color.rgb, mixture);
    COLOR.rgb = mix(tex.rgb, COLOR.rgb, tex.a);
}