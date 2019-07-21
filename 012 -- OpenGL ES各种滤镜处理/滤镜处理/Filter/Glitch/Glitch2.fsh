//毛刺滤镜: 撕裂 + 微弱的颜色偏移
//具体的思路是，我们让每一行像素随机偏移 -1 ~ 1 的距离（这里的 -1 ~ 1 是对于纹理坐标来说的），但是如果整个画面都偏移比较大的值，那我们可能都看不出原来图像的样子。所以我们的逻辑是，设定一个阈值，小于这个阈值才进行偏移，超过这个阈值则乘上一个缩小系数。则最终呈现的效果是：绝大部分的行都会进行微小的偏移，只有少量的行会进行较大偏移
precision highp float;
//纹理
uniform sampler2D Texture;
//纹理坐标
varying vec2 TextureCoordsVarying;
//时间撮
uniform float Time;
//PI
const float PI = 3.1415926;

//随机数
float rand(float n) {
    //fract(x),返回x的小数部分数据
    return fract(sin(n) * 43758.5453123);
}

void main (void) {
    
    //最大抖动
    float maxJitter = 0.06;
    //一次毛刺滤镜的时长
    float duration = 0.3;
    //红色颜色偏移量
    float colorROffset = 0.01;
    //绿色颜色偏移量
    float colorBOffset = -0.025;
    
    //时间周期[0.0,0.6];
    float time = mod(Time, duration * 2.0);
    //振幅:[0,1];
    float amplitude = max(sin(time * (PI / duration)), 0.0);
    
    //像素随机偏移[-1,1]
    float jitter = rand(TextureCoordsVarying.y) * 2.0 - 1.0; // -1~1
    
    //是否要做偏移.
    bool needOffset = abs(jitter) < maxJitter * amplitude;
    
    //获取纹理X值.根据needOffset,来计算它X撕裂.
    //needOffset = YES ,撕裂较大;
    //needOffset = NO,撕裂较小.
    float textureX = TextureCoordsVarying.x + (needOffset ? jitter : (jitter * amplitude * 0.006));
    
    //撕裂后的纹理坐标x,y
    vec2 textureCoords = vec2(textureX, TextureCoordsVarying.y);
    
    //颜色偏移3组颜色
    //根据撕裂后获取的纹理颜色值
    vec4 mask = texture2D(Texture, textureCoords);
    //撕裂后的纹理颜色偏移
    vec4 maskR = texture2D(Texture, textureCoords + vec2(colorROffset * amplitude, 0.0));
    //撕裂后的纹理颜色偏移
    vec4 maskB = texture2D(Texture, textureCoords + vec2(colorBOffset * amplitude, 0.0));
    
    //红色/蓝色部分发生撕裂.
    gl_FragColor = vec4(maskR.r, mask.g, maskB.b, mask.a);
}
