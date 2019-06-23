attribute vec4 position;
attribute vec4 positionColor;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

varying lowp vec4 varyColor;

void main()
{
    varyColor = positionColor;
    vec4 pos ;
    pos = projectionMatrix * modelViewMatrix * position;
    
    gl_Position = pos;
}
