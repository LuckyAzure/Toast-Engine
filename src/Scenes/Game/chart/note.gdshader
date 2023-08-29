shader_type canvas_item;

uniform float progress : hint_range(0,1); uniform float clip_height =
0.05;

void fragment(){
    vec4 main_texture = texture(TEXTURE, UV);
    //main_texture.a *= 1.0 - step(1.0 - progress, UV.y);   main_texture.a *= 1.0 - smoothstep(1.0 - progress - clip_height,1.0 - progress + clip_height, UV.y);
    COLOR = main_texture; }