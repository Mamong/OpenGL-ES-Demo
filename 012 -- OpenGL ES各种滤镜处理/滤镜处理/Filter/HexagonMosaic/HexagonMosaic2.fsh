precision highp float;
uniform sampler2D Texture;
varying vec2 TextureCoordsVarying;

const float mosaicSize = 0.03;

void main(void){
    float length = mosaicSize;
    float TR = 0.866025;//sqrt(3.0)/3.0
    float TB = 2.0/3.0;
    
    float x = TextureCoordsVarying.x;
    float y = TextureCoordsVarying.y;
    
    //马赛克的宽高比
    int wx = int(x / TB  / length);
    int wy = int(y / TR  / length);

    vec2 v1, v2, vn;
    
    //判断奇，偶
    if(wx/2 * 2 == wx){
        if(wy/2 * 2 == wy){
            v1 = vec2(length * 1.5 * float(wx), length * TR * float(wy));
            v2 = vec2(length * 1.5 * float(wx + 1), length * TR * float(wy + 1));
        }else{
            v1 = vec2(length * 1.5 * float(wx), length * TR * float(wy + 1));
            v2 = vec2(length * 1.5 * float(wx + 1), length * TR * float(wy));
        }
    }else{
        if(wy/2 * 2 == wy){
            v1 = vec2(length * 1.5 * float(wx), length * TR * float(wy + 1));
            v2 = vec2(length * 1.5 * float(wx + 1), length * TR * float(wy));
        } else {
            v1 = vec2(length * 1.5 * float(wx), length * TR * float(wy));
            v2 = vec2(length * 1.5 * float(wx + 1), length * TR * float(wy + 1));
        }
    }
    
    //计算要绘制的点到v1和v2的两点间的距离 根号下（X1-X2）^2+(Y1-Y2)^2
    float s1 = sqrt(pow(v1.x - x, 2.0) + pow(v1.y - y, 2.0));
    float s2 = sqrt(pow(v2.x - x, 2.0) + pow(v2.y - y, 2.0));
    //取离的近的颜色值
    if(s1 < s2){
        vn = v1;
    }else{
        vn = v2;
    }
    
    vec4 color = texture2D(Texture , vn);
    
    gl_FragColor = color;
}
