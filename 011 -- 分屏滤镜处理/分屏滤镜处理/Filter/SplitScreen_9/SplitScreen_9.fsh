precision highp float;
uniform sampler2D Texture;
varying vec2 TextureCoordsVarying;

void main(void){
    vec2 uv = TextureCoordsVarying.xy;
     if(uv.y >= 0.0 && uv.y <= 1.0/3.0){
        uv.y = uv.y * 3.0;
    }else if(uv.y > 2.0 /3.0){
        uv.y = (uv.y - 2.0 / 3.0) * 3.0 ;
    }else{
        uv.y = (uv.y - 1.0 / 3.0) * 3.0 ;
    }
    if(uv.x >= 0.0 && uv.x <= 1.0/3.0){
        uv.x = uv.x * 3.0;
    }else if(uv.x > 2.0 /3.0){
        uv.x = (uv.x - 2.0 / 3.0) * 3.0 ;
    }else{
        uv.x = (uv.x - 1.0 / 3.0) * 3.0 ;
    }
    
    gl_FragColor = texture2D(Texture,uv);
}
