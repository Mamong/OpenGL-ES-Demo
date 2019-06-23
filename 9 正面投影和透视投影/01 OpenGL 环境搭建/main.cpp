#define GL_SILENCE_DEPRECATION
//demo演示了OpenGL背面剔除，深度测试，和多边形模式
#include "GLTools.h"	
#include "GLMatrixStack.h"
#include "GLFrame.h"
#include "GLFrustum.h"
#include "GLGeometryTransform.h"

#include <math.h>
#ifdef __APPLE__
#include <glut/glut.h>
#else
#define FREEGLUT_STATIC
#include <GL/glut.h>
#endif

GLFrame             viewFrame;
GLFrustum           viewFrustum;
GLBatch             tubeBatch;
GLBatch             innerBatch;
//GLMatrixStack 堆栈矩阵
GLMatrixStack       modelViewMatix;
GLMatrixStack       projectionMatrix;

//几何变换的管道
GLGeometryTransform transformPipeline;
GLShaderManager     shaderManager;

//右键菜单栏选项
void ProcessMenu(int value)
{
    
}


// 召唤场景
void RenderScene(void)
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //开启深度测试
    glEnable(GL_DEPTH_TEST);
    
    //绘制前压栈,将数据保存进去
    modelViewMatix.PushMatrix(viewFrame);
    
    GLfloat vRed[] = { 1.0f, 0.0f, 0.0f, 1.0f};
    GLfloat vGray[] = { 0.75f, 0.75f, 0.75f, 1.0f};
    
    //默认光源着色器
    shaderManager.UseStockShader(GLT_SHADER_DEFAULT_LIGHT, transformPipeline.GetModelViewMatrix(),transformPipeline.GetProjectionMatrix(),vRed);
    tubeBatch.Draw();
    
    //默认光源着色器
    shaderManager.UseStockShader(GLT_SHADER_DEFAULT_LIGHT, transformPipeline.GetModelViewMatrix(),transformPipeline.GetProjectionMatrix(),vGray);
    innerBatch.Draw();
    
    //出栈
    modelViewMatix.PopMatrix();
    
    glutSwapBuffers();
}

// 这个函数不需要初始化渲染
// context. 图像上下文
void SetupRC()
{
    //顶点不一样。透视投影和正交投影
    glClearColor(0.0f, 0.0f, 0.75f, 1.0f );
    
    
    glEnable(GL_DEPTH_TEST);
    
    shaderManager.InitializeStockShaders();
    viewFrame.MoveForward(450.0f);
    
    
    tubeBatch.Begin(GL_QUADS, 200);
    
    float fZ = 100.0f;
    float bZ = -100.0f;
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-50.0f, 50.0f, 100.0f);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-50.0f, -50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f, -50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f,50.0f,fZ);
    
    // Right Panel
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(50.0f, 50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(35.0f, 50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(35.0f, -50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(50.0f,-50.0f,fZ);
    
    // Top Panel
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f, 50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f, 35.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(35.0f, 35.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(35.0f, 50.0f,fZ);
    
    // Bottom Panel
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f, -35.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f, -50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(35.0f, -50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(35.0f, -35.0f,fZ);
    
    // Top length section ////////////////////////////
    // Normal points up Y axis
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 1.0f, 0.0f);
    tubeBatch.Vertex3f(-50.0f, 50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 1.0f, 0.0f);
    tubeBatch.Vertex3f(50.0f, 50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 1.0f, 0.0f);
    tubeBatch.Vertex3f(50.0f, 50.0f, bZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 1.0f, 0.0f);
    tubeBatch.Vertex3f(-50.0f,50.0f,bZ);
    
    // Bottom section
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, -1.0f, 0.0f);
    tubeBatch.Vertex3f(-50.0f, -50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, -1.0f, 0.0f);
    tubeBatch.Vertex3f(-50.0f, -50.0f, bZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, -1.0f, 0.0f);
    tubeBatch.Vertex3f(50.0f, -50.0f, bZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, -1.0f, 0.0f);
    tubeBatch.Vertex3f(50.0f, -50.0f, fZ);
    
    // Left section
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(1.0f, 0.0f, 0.0f);
    tubeBatch.Vertex3f(50.0f, 50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(1.0f, 0.0f, 0.0f);
    tubeBatch.Vertex3f(50.0f, -50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(1.0f, 0.0f, 0.0f);
    tubeBatch.Vertex3f(50.0f, -50.0f, bZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(1.0f, 0.0f, 0.0f);
    tubeBatch.Vertex3f(50.0f, 50.0f, bZ);
    
    // Right Section
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(-1.0f, 0.0f, 0.0f);
    tubeBatch.Vertex3f(-50.0f, 50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(-1.0f, 0.0f, 0.0f);
    tubeBatch.Vertex3f(-50.0f, 50.0f, bZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(-1.0f, 0.0f, 0.0f);
    tubeBatch.Vertex3f(-50.0f, -50.0f, bZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(-1.0f, 0.0f, 0.0f);
    tubeBatch.Vertex3f(-50.0f, -50.0f, fZ);
    
    
    // Pointing straight out Z
    // Left Panel
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-50.0f, 50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-50.0f, -50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f, -50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f,50.0f,fZ);
    
    // Right Panel
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(50.0f, 50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(35.0f, 50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(35.0f, -50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(50.0f,-50.0f,fZ);
    
    // Top Panel
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f, 50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f, 35.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(35.0f, 35.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(35.0f, 50.0f,fZ);
    
    // Bottom Panel
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f, -35.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f, -50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(35.0f, -50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(35.0f, -35.0f,fZ);
    
    // Top length section ////////////////////////////
    // Normal points up Y axis
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 1.0f, 0.0f);
    tubeBatch.Vertex3f(-50.0f, 50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 1.0f, 0.0f);
    tubeBatch.Vertex3f(50.0f, 50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 1.0f, 0.0f);
    tubeBatch.Vertex3f(50.0f, 50.0f, bZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, 1.0f, 0.0f);
    tubeBatch.Vertex3f(-50.0f,50.0f,bZ);
    
    // Bottom section
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, -1.0f, 0.0f);
    tubeBatch.Vertex3f(-50.0f, -50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, -1.0f, 0.0f);
    tubeBatch.Vertex3f(-50.0f, -50.0f, bZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, -1.0f, 0.0f);
    tubeBatch.Vertex3f(50.0f, -50.0f, bZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(0.0f, -1.0f, 0.0f);
    tubeBatch.Vertex3f(50.0f, -50.0f, fZ);
    
    // Left section
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(1.0f, 0.0f, 0.0f);
    tubeBatch.Vertex3f(50.0f, 50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(1.0f, 0.0f, 0.0f);
    tubeBatch.Vertex3f(50.0f, -50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(1.0f, 0.0f, 0.0f);
    tubeBatch.Vertex3f(50.0f, -50.0f, bZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(1.0f, 0.0f, 0.0f);
    tubeBatch.Vertex3f(50.0f, 50.0f, bZ);
    
    // Right Section
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(-1.0f, 0.0f, 0.0f);
    tubeBatch.Vertex3f(-50.0f, 50.0f, fZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(-1.0f, 0.0f, 0.0f);
    tubeBatch.Vertex3f(-50.0f, 50.0f, bZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(-1.0f, 0.0f, 0.0f);
    tubeBatch.Vertex3f(-50.0f, -50.0f, bZ);
    
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Normal3f(-1.0f, 0.0f, 0.0f);
    tubeBatch.Vertex3f(-50.0f, -50.0f, fZ);
    
    
    
    // Left Panel
    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f,50.0f,bZ);
    
    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f, -50.0f, bZ);
    
    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-50.0f, -50.0f, bZ);
    
    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-50.0f, 50.0f, bZ);
    
    // Right Panel
    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    
    tubeBatch.Vertex3f(50.0f,-50.0f,bZ);
    
    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    
    tubeBatch.Vertex3f(35.0f, -50.0f, bZ);
    
    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    
    tubeBatch.Vertex3f(35.0f, 50.0f, bZ);
    
    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    
    tubeBatch.Vertex3f(50.0f, 50.0f, bZ);
    
    // Top Panel
    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(35.0f, 50.0f, bZ);
    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(35.0f, 35.0f, bZ);
    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f, 35.0f, bZ);
    
    
    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f, 50.0f, bZ);
    
    // Bottom Panel
    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(35.0f, -35.0f,bZ);
    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(35.0f, -50.0f, bZ);
    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f, -50.0f, bZ);
    
    
    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
    tubeBatch.Vertex3f(-35.0f, -35.0f, bZ);
    
    tubeBatch.End();
    
    
    innerBatch.Begin(GL_QUADS, 40);
    
    
    
    // Insides /////////////////////////////
    // Normal points up Y axis
    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
    innerBatch.Normal3f(0.0f, 1.0f, 0.0f);
    innerBatch.Vertex3f(-35.0f, 35.0f, fZ);
    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
    innerBatch.Normal3f(0.0f, 1.0f, 0.0f);
    innerBatch.Vertex3f(35.0f, 35.0f, fZ);
    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
    innerBatch.Normal3f(0.0f, 1.0f, 0.0f);
    innerBatch.Vertex3f(35.0f, 35.0f, bZ);
    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
    innerBatch.Normal3f(0.0f, 1.0f, 0.0f);
    innerBatch.Vertex3f(-35.0f,35.0f,bZ);
    
    // Bottom section
    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
    innerBatch.Normal3f(0.0f, 1.0f, 0.0f);
    innerBatch.Vertex3f(-35.0f, -35.0f, fZ);
    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
    innerBatch.Normal3f(0.0f, 1.0f, 0.0f);
    innerBatch.Vertex3f(-35.0f, -35.0f, bZ);
    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
    innerBatch.Normal3f(0.0f, 1.0f, 0.0f);
    innerBatch.Vertex3f(35.0f, -35.0f, bZ);
    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
    innerBatch.Normal3f(0.0f, 1.0f, 0.0f);
    innerBatch.Vertex3f(35.0f, -35.0f, fZ);
    
    // Left section
    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
    innerBatch.Normal3f(1.0f, 0.0f, 0.0f);
    innerBatch.Vertex3f(-35.0f, 35.0f, fZ);
    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
    innerBatch.Normal3f(1.0f, 0.0f, 0.0f);
    innerBatch.Vertex3f(-35.0f, 35.0f, bZ);
    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
    innerBatch.Normal3f(1.0f, 0.0f, 0.0f);
    innerBatch.Vertex3f(-35.0f, -35.0f, bZ);
    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
    innerBatch.Normal3f(1.0f, 0.0f, 0.0f);
    innerBatch.Vertex3f(-35.0f, -35.0f, fZ);
    
    // Right Section
    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
    innerBatch.Normal3f(-1.0f, 0.0f, 0.0f);
    innerBatch.Vertex3f(35.0f, 35.0f, fZ);
    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
    innerBatch.Normal3f(-1.0f, 0.0f, 0.0f);
    innerBatch.Vertex3f(35.0f, -35.0f, fZ);
    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
    innerBatch.Normal3f(-1.0f, 0.0f, 0.0f);
    innerBatch.Vertex3f(35.0f, -35.0f, bZ);
    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
    innerBatch.Normal3f(-1.0f, 0.0f, 0.0f);
    innerBatch.Vertex3f(35.0f, 35.0f, bZ);
    
    innerBatch.End();
//    //设置清屏颜色
//    glClearColor(0.0f, 0.0f, 0.75f, 1.0f );
//
//    //    glEnable(GL_CULL_FACE);
//    glEnable(GL_DEPTH_TEST);
//
//    //初始化着色器管理器
//    shaderManager.InitializeStockShaders();
//
//
//    tubeBatch.Begin(GL_QUADS, 200);
//
//    float fZ = 100.0f;
//    float bZ = -100.0f;
//
//    //左面板的颜色、顶点、光照数据
//    //颜色值
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    //光照法线
//    //接受3个表示坐标的值，指定一条垂直于三角形表面的法线向量
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    //顶点数据
//    tubeBatch.Vertex3f(-50.0f, 50.0f, 100.0f);
//
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-50.0f, -50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f, -50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f,50.0f,fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(50.0f, 50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(35.0f, 50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(35.0f, -50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(50.0f,-50.0f,fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f, 50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f, 35.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(35.0f, 35.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(35.0f, 50.0f,fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f, -35.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f, -50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(35.0f, -50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(35.0f, -35.0f,fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 1.0f, 0.0f);
//    tubeBatch.Vertex3f(-50.0f, 50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 1.0f, 0.0f);
//    tubeBatch.Vertex3f(50.0f, 50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 1.0f, 0.0f);
//    tubeBatch.Vertex3f(50.0f, 50.0f, bZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 1.0f, 0.0f);
//    tubeBatch.Vertex3f(-50.0f,50.0f,bZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, -1.0f, 0.0f);
//    tubeBatch.Vertex3f(-50.0f, -50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, -1.0f, 0.0f);
//    tubeBatch.Vertex3f(-50.0f, -50.0f, bZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, -1.0f, 0.0f);
//    tubeBatch.Vertex3f(50.0f, -50.0f, bZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, -1.0f, 0.0f);
//    tubeBatch.Vertex3f(50.0f, -50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(1.0f, 0.0f, 0.0f);
//    tubeBatch.Vertex3f(50.0f, 50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(1.0f, 0.0f, 0.0f);
//    tubeBatch.Vertex3f(50.0f, -50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(1.0f, 0.0f, 0.0f);
//    tubeBatch.Vertex3f(50.0f, -50.0f, bZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(1.0f, 0.0f, 0.0f);
//    tubeBatch.Vertex3f(50.0f, 50.0f, bZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(-1.0f, 0.0f, 0.0f);
//    tubeBatch.Vertex3f(-50.0f, 50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(-1.0f, 0.0f, 0.0f);
//    tubeBatch.Vertex3f(-50.0f, 50.0f, bZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(-1.0f, 0.0f, 0.0f);
//    tubeBatch.Vertex3f(-50.0f, -50.0f, bZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(-1.0f, 0.0f, 0.0f);
//    tubeBatch.Vertex3f(-50.0f, -50.0f, fZ);
//
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-50.0f, 50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-50.0f, -50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f, -50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f,50.0f,fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(50.0f, 50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(35.0f, 50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(35.0f, -50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(50.0f,-50.0f,fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f, 50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f, 35.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(35.0f, 35.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(35.0f, 50.0f,fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f, -35.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f, -50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(35.0f, -50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(35.0f, -35.0f,fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 1.0f, 0.0f);
//    tubeBatch.Vertex3f(-50.0f, 50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 1.0f, 0.0f);
//    tubeBatch.Vertex3f(50.0f, 50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 1.0f, 0.0f);
//    tubeBatch.Vertex3f(50.0f, 50.0f, bZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, 1.0f, 0.0f);
//    tubeBatch.Vertex3f(-50.0f,50.0f,bZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, -1.0f, 0.0f);
//    tubeBatch.Vertex3f(-50.0f, -50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, -1.0f, 0.0f);
//    tubeBatch.Vertex3f(-50.0f, -50.0f, bZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, -1.0f, 0.0f);
//    tubeBatch.Vertex3f(50.0f, -50.0f, bZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(0.0f, -1.0f, 0.0f);
//    tubeBatch.Vertex3f(50.0f, -50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(1.0f, 0.0f, 0.0f);
//    tubeBatch.Vertex3f(50.0f, 50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(1.0f, 0.0f, 0.0f);
//    tubeBatch.Vertex3f(50.0f, -50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(1.0f, 0.0f, 0.0f);
//    tubeBatch.Vertex3f(50.0f, -50.0f, bZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(1.0f, 0.0f, 0.0f);
//    tubeBatch.Vertex3f(50.0f, 50.0f, bZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(-1.0f, 0.0f, 0.0f);
//    tubeBatch.Vertex3f(-50.0f, 50.0f, fZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(-1.0f, 0.0f, 0.0f);
//    tubeBatch.Vertex3f(-50.0f, 50.0f, bZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(-1.0f, 0.0f, 0.0f);
//    tubeBatch.Vertex3f(-50.0f, -50.0f, bZ);
//
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Normal3f(-1.0f, 0.0f, 0.0f);
//    tubeBatch.Vertex3f(-50.0f, -50.0f, fZ);
//
//    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f,50.0f,bZ);
//
//    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f, -50.0f, bZ);
//
//    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-50.0f, -50.0f, bZ);
//
//    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-50.0f, 50.0f, bZ);
//
//
//    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//
//    tubeBatch.Vertex3f(50.0f,-50.0f,bZ);
//
//    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//
//    tubeBatch.Vertex3f(35.0f, -50.0f, bZ);
//
//    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//
//    tubeBatch.Vertex3f(35.0f, 50.0f, bZ);
//
//    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//
//    tubeBatch.Vertex3f(50.0f, 50.0f, bZ);
//
//    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(35.0f, 50.0f, bZ);
//    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(35.0f, 35.0f, bZ);
//    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f, 35.0f, bZ);
//
//
//    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f, 50.0f, bZ);
//
//
//    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(35.0f, -35.0f,bZ);
//    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(35.0f, -50.0f, bZ);
//    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f, -50.0f, bZ);
//
//
//    tubeBatch.Normal3f(0.0f, 0.0f, -1.0f);
//    tubeBatch.Color4f(1.0f, 0.0f, 0.0f, 1.0f);
//    tubeBatch.Vertex3f(-35.0f, -35.0f, bZ);
//
//    tubeBatch.End();
//
//    //内壁
//    innerBatch.Begin(GL_QUADS, 40);
//
//    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
//    innerBatch.Normal3f(0.0f, 1.0f, 0.0f);
//    innerBatch.Vertex3f(-35.0f, 35.0f, fZ);
//    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
//    innerBatch.Normal3f(0.0f, 1.0f, 0.0f);
//    innerBatch.Vertex3f(35.0f, 35.0f, fZ);
//    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
//    innerBatch.Normal3f(0.0f, 1.0f, 0.0f);
//    innerBatch.Vertex3f(35.0f, 35.0f, bZ);
//    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
//    innerBatch.Normal3f(0.0f, 1.0f, 0.0f);
//    innerBatch.Vertex3f(-35.0f,35.0f,bZ);
//
//
//    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
//    innerBatch.Normal3f(0.0f, 1.0f, 0.0f);
//    innerBatch.Vertex3f(-35.0f, -35.0f, fZ);
//    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
//    innerBatch.Normal3f(0.0f, 1.0f, 0.0f);
//    innerBatch.Vertex3f(-35.0f, -35.0f, bZ);
//    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
//    innerBatch.Normal3f(0.0f, 1.0f, 0.0f);
//    innerBatch.Vertex3f(35.0f, -35.0f, bZ);
//    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
//    innerBatch.Normal3f(0.0f, 1.0f, 0.0f);
//    innerBatch.Vertex3f(35.0f, -35.0f, fZ);
//
//
//    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
//    innerBatch.Normal3f(1.0f, 0.0f, 0.0f);
//    innerBatch.Vertex3f(-35.0f, 35.0f, fZ);
//    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
//    innerBatch.Normal3f(1.0f, 0.0f, 0.0f);
//    innerBatch.Vertex3f(-35.0f, 35.0f, bZ);
//    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
//    innerBatch.Normal3f(1.0f, 0.0f, 0.0f);
//    innerBatch.Vertex3f(-35.0f, -35.0f, bZ);
//    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
//    innerBatch.Normal3f(1.0f, 0.0f, 0.0f);
//    innerBatch.Vertex3f(-35.0f, -35.0f, fZ);
//
//
//    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
//    innerBatch.Normal3f(-1.0f, 0.0f, 0.0f);
//    innerBatch.Vertex3f(35.0f, 35.0f, fZ);
//    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
//    innerBatch.Normal3f(-1.0f, 0.0f, 0.0f);
//    innerBatch.Vertex3f(35.0f, -35.0f, fZ);
//    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
//    innerBatch.Normal3f(-1.0f, 0.0f, 0.0f);
//    innerBatch.Vertex3f(35.0f, -35.0f, bZ);
//    innerBatch.Color4f(0.75f, 0.75f, 0.75f, 1.0f);
//    innerBatch.Normal3f(-1.0f, 0.0f, 0.0f);
//    innerBatch.Vertex3f(35.0f, 35.0f, bZ);
//
//    innerBatch.End();
}

//键位设置，通过不同的键位对其进行设置
//控制Camera的移动，从而改变视口
void SpecialKeys(int key, int x, int y)
{
    if(key == GLUT_KEY_UP)
        viewFrame.RotateWorld(m3dDegToRad(-5.0), 1.0f, 0.0f, 0.0f);
    
    if(key == GLUT_KEY_DOWN)
        viewFrame.RotateWorld(m3dDegToRad(5.0), 1.0f, 0.0f, 0.0f);
    
    if(key == GLUT_KEY_LEFT)
        viewFrame.RotateWorld(m3dDegToRad(-5.0), 0.0f, 1.0f, 0.0f);
    
    if(key == GLUT_KEY_RIGHT)
        viewFrame.RotateWorld(m3dDegToRad(5.0), 0.0f, 1.0f, 0.0f);
    
    //重新刷新window
    glutPostRedisplay();
}


void ChangeSize(int w, int h)
{
    //防止h变为0
    if(h == 0)
        h = 1;
    
    //设置视口窗口尺寸
    glViewport(0, 0, w, h);
    
    //setPerspective函数的参数是一个从顶点方向看去的视场角度（用角度值表示）
    // 设置透视模式，初始化其透视矩阵
    viewFrustum.SetPerspective(35.0f, float(w)/float(h), 1.0f, 1000.0f);
    //正投影举证
  //  viewFrustum.SetOrthographic(-130.f, 130.f, -130.f, 130.f, -130.0f, 130.0f);
    
    //把透视矩阵加载到透视矩阵对阵中
    projectionMatrix.LoadMatrix(viewFrustum.GetProjectionMatrix());
    // 初始化渲染管线
    transformPipeline.SetMatrixStacks(modelViewMatix, projectionMatrix);
}


int main(int argc, char* argv[])
{
    gltSetWorkingDirectory(argv[0]);
    
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH | GLUT_STENCIL);
    glutInitWindowSize(800, 600);
    glutCreateWindow("Geometry Test Program");
    glutReshapeFunc(ChangeSize);
    glutSpecialFunc(SpecialKeys);
    glutDisplayFunc(RenderScene);
    
    
    
    GLenum err = glewInit();
    if (GLEW_OK != err) {
        fprintf(stderr, "GLEW Error: %s\n", glewGetErrorString(err));
        return 1;
    }
    
    SetupRC();
    
    glutMainLoop();
    return 0;
}
