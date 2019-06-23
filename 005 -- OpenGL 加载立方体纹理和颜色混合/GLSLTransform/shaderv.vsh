attribute vec4 position;
attribute vec4 positionColor;
attribute vec2 textCoordinate;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

varying lowp vec2 varyTextCoord;
varying lowp vec4 varyColor;
void main()
{
    varyColor = positionColor;
    varyTextCoord = textCoordinate;
    vec4 pos ;
    pos = projectionMatrix * modelViewMatrix * position;
    gl_Position = pos;
}
