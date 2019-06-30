//
//  ViewController.m
//  GLKit实现光照效果
//
//  Created by denglei on 2019/6/23.
//  Copyright © 2019 soudian. All rights reserved.
//

#import "ViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "sceneUtil.h"
@interface ViewController ()
@property(nonatomic, strong)EAGLContext *mContext;

//基本Effect
@property(nonatomic, strong)GLKBaseEffect *baseEffect;
//额外Effect
@property(nonatomic, strong)GLKBaseEffect *extraEffect;

//顶点缓存区
@property(nonatomic, strong)AGLKVertexAttribArrayBuffer *vertexBuffer;
//法线位置缓存
@property(nonatomic, strong)AGLKVertexAttribArrayBuffer *extraBuffer;

//是否绘制法线
@property(nonatomic, assign)BOOL shouldDrawNormals;
//中心点的高
@property(nonatomic, assign)GLfloat centerVertexHeight;

@end

@implementation ViewController
{
    //三角形-8面
    SceneTriangle triangles[NUM_FACES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //1.
    [self setupES];
    
    //2.
    [self setUpEffect];
    
    //3.
    [self setUpBuffer];
}

-(void)setupES{
    //新建上下文
    self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    //2.设置GLKView
    GLKView *view = (GLKView *)self.view;
    view.context = self.mContext;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.mContext];
}

-(void)setUpEffect{
    //1.金字塔Effect
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.light0.enabled = GL_TRUE;
    
    //光的漫反射部分GLKVector4Make(R,G,B,A)
    self.baseEffect.light0.diffuseColor = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);
    //世界坐标中的光的位置
    self.baseEffect.light0.position = GLKVector4Make(1.0f, 1.0f, 0.5f, 0.0f);
    //2.法线Effect
    self.extraEffect = [[GLKBaseEffect alloc] init];
    self.extraEffect.useConstantColor = GL_TRUE;
    
    //调整模型矩阵，更好的观察
    //可以尝试不执行这段代码，改为false
    if(true){
        //围绕X轴旋转-60度
        //返回一个4X4矩阵进行绕任意矢量旋转
        GLKMatrix4 modelViewMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(-60.f), 1.0f, 0.0f, 0.0f);
        
        //围绕Z轴，旋转-30度
        modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(-30), 0.0f, 0.0f, 1.0f);
        
        //围绕Z方向，移动0.25f
        modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0f, 0.0f, 0.25f);
        
        //设置baseEffect,extraEffect模型矩阵
        self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
        self.extraEffect.transform.modelviewMatrix = modelViewMatrix;
    }
}

-(void)setUpBuffer{
    //确定图形的8个圆
    triangles[0] = SceneTriangleMake(vertexA, vertexB, vertexD);
    triangles[1] = SceneTriangleMake(vertexB, vertexC, vertexF);
    triangles[2] = SceneTriangleMake(vertexD, vertexB, vertexE);
    triangles[3] = SceneTriangleMake(vertexE, vertexB, vertexF);
    triangles[4] = SceneTriangleMake(vertexD, vertexE, vertexH);
    triangles[5] = SceneTriangleMake(vertexE, vertexF, vertexH);
    triangles[6] = SceneTriangleMake(vertexG, vertexD, vertexH);
    triangles[7] = SceneTriangleMake(vertexH, vertexF, vertexI);
    
    //初始化缓存区
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(triangles)/sizeof(SceneVertex) bytes:triangles usage:GL_DYNAMIC_DRAW];
    
    self.extraBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex) numberOfVertices:0 bytes:NULL usage:GL_DYNAMIC_DRAW];
    
    self.centerVertexHeight = 0.0f;
 
}

//绘制法线
-(void)drawNormals{
    GLKVector3 normalLineVertices[NUM_LINE_VERTS];
    //1.以每个顶点的坐标为起点，顶点坐标加上法向量的偏移值作为终点，更新法线显示数组
    //参数1: 三角形数组
    //参数2：光源位置
    //参数3：法线显示的顶点数组
    SceneTrianglesNormalLinesUpdate(triangles, GLKVector3MakeWithArray(self.baseEffect.light0.position.v), normalLineVertices);
    
    //2.为EextraBuffer重新开辟空间
    [self.extraBuffer reinitWithAttribStride:sizeof(GLKVector3) numberOfVertices:NUM_LINE_VERTS bytes:normalLineVertices];
    
    //3.准备绘制数据
    [self.extraBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:0 shouldEnable:YES];
    
    //4.修改extraEffect
    //法线
    /*
     指示是否使用常量颜色的布尔值。
     如果该值设置为gl_true，然后存储在设置属性的值为每个顶点的颜色值。如果该值设置为gl_false，那么你的应用将使glkvertexattribcolor属性提供每顶点颜色数据。默认值是gl_false。
     */
    self.extraEffect.useConstantColor = GL_TRUE;
    //设置光源颜色为绿色，画顶点法线
    self.extraEffect.constantColor = GLKVector4Make(0.0f, 1.0f, 0.0f, 0.0f);
    [self.extraEffect prepareToDraw];
    //绘制线段
    [self.extraBuffer drawArrayWithMode:GL_LINES startVertexIndex:0 numberOfVertices:NUM_NORMAL_LINE_VERTS];
    
    //设置光源颜色为黄色，并且画光源线
    //Red+Green =Yellow
    self.extraEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 0.0f, 0.0f);
    
    //准备绘制黄色光源方向线
    [self.extraEffect prepareToDraw];
    
    //(NUM_LINE_VERTS - NUM_NORMAL_LINE_VERTS) = 2 .2点确定一条线
    [self.extraBuffer drawArrayWithMode:GL_LINES startVertexIndex:NUM_NORMAL_LINE_VERTS numberOfVertices:2];
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    //1.清屏
    glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    //2.准备绘制
    [self.baseEffect prepareToDraw];
    //准备绘制顶点数据
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, position) shouldEnable:YES];
    //准备绘制法线数据
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribNormal numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, normal) shouldEnable:YES];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:sizeof(triangles)/sizeof(SceneVertex)];
    
    //3.是否要绘制光照法线
    if (self.shouldDrawNormals) {
        [self drawNormals];
    }
}

//更新法线向量
-(void)updateNormals{
    //更新每个点的平面法向量
    SceneTrianglesUpdateFaceNormals(triangles);
    
    [self.vertexBuffer reinitWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(triangles)/sizeof(SceneVertex) bytes:triangles];
}

//设置顶点高度
-(void)setCenterVertexHeight:(GLfloat)centerVertexHeight{
    _centerVertexHeight = centerVertexHeight;
    
    //更新顶点E
    SceneVertex newVertexE = vertexE;
    newVertexE.position.z = _centerVertexHeight;
    triangles[2] = SceneTriangleMake(vertexD, vertexB, newVertexE);
    triangles[3] = SceneTriangleMake(newVertexE, vertexB, vertexF);
    triangles[4] = SceneTriangleMake(vertexD, newVertexE, vertexH);
    triangles[5] = SceneTriangleMake(newVertexE, vertexF, vertexH);
    //更新法线
    [self updateNormals];
}

- (IBAction)takeShouldDrawNormals:(UISwitch *)sender {
    
    self.shouldDrawNormals = sender.isOn;
}

- (IBAction)changeCenterVertexHeight:(UISlider *)sender {
    
    self.centerVertexHeight = sender.value;
}

@end
