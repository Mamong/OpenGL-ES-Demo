
//demo OpenGL裁剪
#include "GLTools.h"	

#include <math.h>
#ifdef __APPLE__
#include <glut/glut.h>
#else
#define FREEGLUT_STATIC
#include <GL/glut.h>
#endif

// 召唤场景
void RenderScene(void)
{
    //设置清屏颜色为蓝色
    glClearColor(0.0f, 0.0f, 1.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    //1.现在剪成小红色分区
    //(1)设置裁剪区颜色为红色
    glClearColor(1.0f, 0.0f, 0.0f, 0.0f);
      //(2)设置裁剪尺寸
    glScissor(100, 100, 600, 400);
      //(3)开启裁剪测试
    glEnable(GL_SCISSOR_TEST);
      //(4)开启清屏，执行裁剪
    glClear(GL_COLOR_BUFFER_BIT);
    
    // 2.裁剪一个绿色的小矩形
    //(1).设置清屏颜色为绿色
    glClearColor(0.0f, 1.0f, 0.0f, 0.0f);
    //(2).设置裁剪尺寸
    glScissor(200, 200, 400, 200);
    //(3).开始清屏执行裁剪
    glClear(GL_COLOR_BUFFER_BIT);
    
    //关闭裁剪测试
    glDisable(GL_SCISSOR_TEST);
    
    glutSwapBuffers();
    
    
}


void ChangeSize(int w, int h)
{
    //防止h变为0
    if(h == 0)
        h = 1;
    
    //设置视口窗口尺寸
    glViewport(0, 0, w, h);

}


int main(int argc, char* argv[])
{
    gltSetWorkingDirectory(argv[0]);
    
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE| GLUT_RGB);
    glutInitWindowSize(800, 600);
    glutCreateWindow("OpenGL Scissor");
    glutReshapeFunc(ChangeSize);
    glutDisplayFunc(RenderScene);

    
    GLenum err = glewInit();
    if (GLEW_OK != err) {
        fprintf(stderr, "GLEW Error: %s\n", glewGetErrorString(err));
        return 1;
    }
    
  //  SetupRC();
    
    glutMainLoop();
    return 0;
}
