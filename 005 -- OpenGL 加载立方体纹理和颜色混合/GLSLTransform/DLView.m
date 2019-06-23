//
//  DLView.m
//  GLSLTransform
//
//  Created by denglei on 2019/6/13.
//  Copyright © 2019 soudian. All rights reserved.
//

#import "DLView.h"
#import "GLESMath.h"
#import "GLESUtils.h"
#import <OpenGLES/ES2/gl.h>

@interface DLView()

@property(nonatomic, strong)CAEAGLLayer *myEagLayer;

@property(nonatomic, strong)EAGLContext *myContext;

@property(nonatomic, assign)GLuint myColorRenderBuffer;
@property(nonatomic, assign)GLuint myColorFrameBuffer;

@property(nonatomic, assign)GLuint myPrograme;
@property(nonatomic, assign)GLuint myVertices;

@end

@implementation DLView
{
    float xDegree;
    float yDegree;
    float zDegree;
    BOOL bx;
    BOOL by;
    BOOL bz;
    NSTimer *myTimer;
    
}

-(void)layoutSubviews{
    //1.设置图层
    [self setupLayer];
    //2.设置上下文
    [self setupContext];
    //3.清空缓存区
    [self deleteBuffer];
    //4.设置renderbuffer
    [self setRenderBuffer];
    //5.设置frameBuffer
    [self setFrameBuffer];
    //6.绘制
    [self render];
    
}

//6.绘制
-(void)render{
    //1.清屏颜色
    glClearColor(0, 0, 0, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    //2.设置视口
    glViewport(self.frame.origin.x * scale, self.frame.origin.y * scale, self.frame.size.width * scale, self.frame.size.height * scale);
    
     //3.获取顶点着色程序、片元着色器程序文件位置
    NSString * vertFile = [[NSBundle mainBundle] pathForResource:@"shaderv" ofType:@"vsh"];
    NSString *fragFile = [[NSBundle mainBundle] pathForResource:@"shaderf" ofType:@"fsh"];
    
      //4.判断self.myProgram是否存在，存在则清空其文件
    if(self.myPrograme){
        glDeleteProgram(self.myPrograme);
        self.myPrograme = 0;
    }
    
      //5.加载程序到myProgram中来。
    self.myPrograme = [self loadShader:vertFile frag:fragFile];
   
     //6.链接
    glLinkProgram(self.myPrograme);
    GLint status;
 
    //7.获取链接状态
    glGetProgramiv(self.myPrograme, GL_LINK_STATUS, &status);
    if(status == GL_FALSE){
        GLchar message[256];
        glGetProgramInfoLog(self.myPrograme, sizeof(message), 0, &message[0]);
        NSString *messageString = [NSString stringWithUTF8String:message];
        NSLog(@"error%@", messageString);
        
        return ;
    }else{
        
        NSLog(@"link success!");
        glUseProgram(self.myPrograme);
    }
   
    //8.创建顶点数组 & 索引数组
    //(1)顶点数组 前3顶点值（x,y,z），后3位纹理顶点
    GLfloat attrArr[] =
    {
        -0.5f, 0.5f, 0.0f,      0.0f, 0.0f, 0.5f,       0.0f, 1.0f,//左上
        0.5f, 0.5f, 0.0f,       0.0f, 0.5f, 0.0f,       1.0f, 1.0f,//右上
        -0.5f, -0.5f, 0.0f,     0.5f, 0.0f, 1.0f,       0.0f, 0.0f,//左下
        0.5f, -0.5f, 0.0f,      0.0f, 0.0f, 0.5f,       1.0f, 0.0f,//右下
        
        0.0f, 0.0f, 1.0f,       1.0f, 1.0f, 1.0f,       0.5f, 0.5f,//顶点
    };

    
    //(2).索引数组
    GLuint indices[] =
    {
        0, 3, 2,
        0, 1, 3,
        0, 2, 4,
        0, 4, 1,
        2, 3, 4,
        1, 4, 3,
    };
     //(3).判断顶点缓存区是否为空，如果为空则申请一个缓存区标识符
    if(self.myVertices == 0){
        glGenBuffers(1, &_myVertices);
    }
    //9.-----处理顶点数据-------
    //(1).将_myVertices绑定到GL_ARRAY_BUFFER标识符上
    glBindBuffer(GL_ARRAY_BUFFER, _myVertices);
    //(2).把顶点数据从CPU内存复制到GPU上
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);
    
    //(3).将顶点数据通过myPrograme中的传递到顶点着色程序的position
    //1.glGetAttribLocation,用来获取vertex attribute的入口的.
    //2.告诉OpenGL ES,通过glEnableVertexAttribArray，
    //3.最后数据是通过glVertexAttribPointer传递过去的。
    //注意：第二参数字符串必须和shaderv.vsh中的输入变量：position保持一致
    GLuint position = glGetAttribLocation(self.myPrograme, "position");
     //(4).打开position
    glEnableVertexAttribArray(position);
    //(5).设置读取方式
    //参数1：index,顶点数据的索引
    //参数2：size,每个顶点属性的组件数量，1，2，3，或者4.默认初始值是4.
    //参数3：type,数据中的每个组件的类型，常用的有GL_FLOAT,GL_BYTE,GL_SHORT。默认初始值为GL_FLOAT
    //参数4：normalized,固定点数据值是否应该归一化，或者直接转换为固定值。（GL_FALSE）
    //参数5：stride,连续顶点属性之间的偏移量，默认为0；
    //参数6：指定一个指针，指向数组中的第一个顶点属性的第一个组件。默认为0
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)* 8, NULL);
    
    //----处理颜色数据-------
    GLuint positionColor = glGetAttribLocation(self.myPrograme, "positionColor");
    glEnableVertexAttribArray(positionColor);
    glVertexAttribPointer(positionColor, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 8, (float *)NULL + 3);
    
    //----处理纹理数据-------
    //(1).glGetAttribLocation,用来获取vertex attribute的入口的.
    //注意：第二参数字符串必须和shaderv.vsh中的输入变量：textCoordinate保持一致
    GLuint textCoord = glGetAttribLocation(self.myPrograme, "textCoordinate");
    //(2).设置合适的格式从buffer里面读取数据
    glEnableVertexAttribArray(textCoord);
    glVertexAttribPointer(textCoord, 2, GL_FLOAT, GL_FALSE, sizeof(GL_FLOAT) * 8, (float *)NULL + 6);
    
    //10.加载纹理
    [self setupTexture:@"beauty"];
    
    //11. 设置纹理采样器 sampler2D
    glUniform1i(glGetUniformLocation(self.myPrograme, "colorMap"), 0);
    
     //11.找到myProgram中的projectionMatrix、modelViewMatrix 2个矩阵的地址。如果找到则返回地址，否则返回-1，表示没有找到2个对象。
     GLuint projectionMatrixSlot = glGetUniformLocation(self.myPrograme, "projectionMatrix");
     GLuint modelViewMatrixSlot = glGetUniformLocation(self.myPrograme, "modelViewMatrix");
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
     //12.创建4 * 4投影矩阵
    KSMatrix4 _projectionMatrix;
     //(1)获取单元矩阵
    ksMatrixLoadIdentity(&_projectionMatrix);
     //(2)计算纵横比例 = 长/宽
    float aspect = width / height;
    //(3)获取透视矩阵
    /*
     参数1：矩阵
     参数2：视角，度数为单位
     参数3：纵横比
     参数4：近平面距离
     参数5：远平面距离
     参考PPT
     */
    ksPerspective(&_projectionMatrix, 30.0, aspect, 5.0f, 20.0f);
    
    //(4)将投影矩阵传递到顶点着色器
    /*
     void glUniformMatrix4fv(GLint location,  GLsizei count,  GLboolean transpose,  const GLfloat *value);
     参数列表：
     location:指要更改的uniform变量的位置
     count:更改矩阵的个数
     transpose:是否要转置矩阵，并将它作为uniform变量的值。必须为GL_FALSE
     value:执行count个元素的指针，用来更新指定uniform变量
     */
    glUniformMatrix4fv(projectionMatrixSlot, 1, GL_FALSE, (GLfloat *)&_projectionMatrix.m[0][0]);
    
     //13.创建一个4 * 4 矩阵，模型视图矩阵
     KSMatrix4 _modelViewMatrix;
     //(1)获取单元矩阵
    ksMatrixLoadIdentity(&_modelViewMatrix);
     //(2)平移，z轴平移-10
    ksTranslate(&_modelViewMatrix, 0.0, 0.0, -10.0);
    
     //(3)创建一个4 * 4 矩阵，旋转矩阵
     KSMatrix4 _rotationMatrix;
    
    //(4)初始化为单元矩阵
    ksMatrixLoadIdentity(&_rotationMatrix);
    
     //(5)旋转
    ksRotate(&_rotationMatrix, xDegree, 1.0, 0.0, 0.0);
    ksRotate(&_rotationMatrix, yDegree, 0.0, 1.0, 0.0);
    ksRotate(&_rotationMatrix, zDegree, 0.0, 0.0, 1.0);
    
     //(6)把变换矩阵相乘.将_modelViewMatrix矩阵与_rotationMatrix矩阵相乘，结合到模型视图
    ksMatrixMultiply(&_modelViewMatrix, &_rotationMatrix, &_modelViewMatrix);
    //(7)将模型视图矩阵传递到顶点着色器
    /*
     void glUniformMatrix4fv(GLint location,  GLsizei count,  GLboolean transpose,  const GLfloat *value);
     参数列表：
     location:指要更改的uniform变量的位置
     count:更改矩阵的个数
     transpose:是否要转置矩阵，并将它作为uniform变量的值。必须为GL_FALSE
     value:执行count个元素的指针，用来更新指定uniform变量
     */
    glUniformMatrix4fv(modelViewMatrixSlot, 1, GL_FALSE, (GLfloat *)&_modelViewMatrix.m[0][0] );
    
    //14.开启剔除操作效果
    glEnable(GL_CULL_FACE);
    
    //15.使用索引绘图
    /*
     void glDrawElements(GLenum mode,GLsizei count,GLenum type,const GLvoid * indices);
     参数列表：
     mode:要呈现的画图的模型
     GL_POINTS
     GL_LINES
     GL_LINE_LOOP
     GL_LINE_STRIP
     GL_TRIANGLES
     GL_TRIANGLE_STRIP
     GL_TRIANGLE_FAN
     count:绘图个数
     type:类型
     GL_BYTE
     GL_UNSIGNED_BYTE
     GL_SHORT
     GL_UNSIGNED_SHORT
     GL_INT
     GL_UNSIGNED_INT
     indices：绘制索引数组
     
     */
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_INT, indices);
    [self.myContext presentRenderbuffer:GL_RENDERBUFFER];
}


//5.设置frameBuffer
-(void)setFrameBuffer{
    GLuint buffer;
    glGenFramebuffers(1, &buffer);
    self.myColorFrameBuffer = buffer;
    glBindFramebuffer(GL_FRAMEBUFFER, self.myColorFrameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, self.myColorRenderBuffer);
}

//4.设置renderbuffer
-(void)setRenderBuffer{
    GLuint buffer;
    glGenRenderbuffers(1, &buffer);
    self.myColorRenderBuffer = buffer;
    glBindRenderbuffer(GL_RENDERBUFFER, self.myColorRenderBuffer);
    [self.myContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.myEagLayer];
}

//3.清空缓存区
-(void)deleteBuffer{
    glDeleteBuffers(1, &_myColorFrameBuffer);
    self.myColorRenderBuffer = 0;
    
    glDeleteBuffers(1, &_myColorRenderBuffer);
    self.myColorFrameBuffer = 0;
}

//2.设置上下文
-(void)setupContext{
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:api];
    if (!context) {
        NSLog(@"Create Context Failed");
        return;
    }
    if (![EAGLContext setCurrentContext:context]) {
        NSLog(@"Set Current Context Failed");
        return;
    }
    self.myContext = context;
}

//1.设置图层
-(void)setupLayer{
    self.myEagLayer = (CAEAGLLayer *)self.layer;
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
    [self.myEagLayer setOpaque:YES];
    self.myEagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:@0,kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat,nil];
}

+(Class)layerClass{
    return [CAEAGLLayer class];
}

#pragma mark -- Shader
-(GLuint)loadShader:(NSString *)vert frag:(NSString *)frag
{
    GLuint vShader,fShader;
    GLuint program = glCreateProgram();
    
    //编译文件g
    //编译顶点着色程序、片元着色器程序
    //参数1：编译完存储的底层地址
    //参数2：编译的类型，GL_VERTEX_SHADER（顶点）、GL_FRAGMENT_SHADER(片元)
    //参数3：文件路径
    [self compileShader:&vShader type:GL_VERTEX_SHADER file:vert];
    [self compileShader:&fShader type:GL_FRAGMENT_SHADER file:frag];
    
      //创建最终的程序
    glAttachShader(program, vShader);
    glAttachShader(program, fShader);
    
    glDeleteProgram(vShader);
    glDeleteProgram(fShader);
    return program;
}

-(void)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file{
    //读取文件字符串
    NSString *content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
     //获取文件路径字符串，C语言字符串
    const GLchar *source = (GLchar *)[content UTF8String];
    
    //创建一个shader（根据type类型）
    *shader = glCreateShader(type);
    
    //将顶点着色器源码附加到着色器对象上。
    //参数1：shader,要编译的着色器对象 *shader
    //参数2：numOfStrings,传递的源码字符串数量 1个
    //参数3：strings,着色器程序的源码（真正的着色器程序源码）
    //参数4：lenOfStrings,长度，具有每个字符串长度的数组，或NULL，这意味着字符串是NULL终止的
    glShaderSource(*shader, 1, &source, NULL);
    
    glCompileShader(*shader);
    
}
- (IBAction)xClick:(id)sender {
    if(!myTimer){
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(reDegree) userInfo:nil repeats:YES];
    }
    bx = !bx;
}

- (IBAction)yClick:(id)sender {
    if(!myTimer){
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(reDegree) userInfo:nil repeats:YES];
    }
    by = !by;
}

- (IBAction)zClick:(id)sender {
    if(!myTimer){
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(reDegree) userInfo:nil repeats:YES];
    }
    bz = !bz;
}


-(void)reDegree
{
    //如果停止X轴旋转，X = 0则度数就停留在暂停前的度数.
    //更新度数
    xDegree += bx * 5;
    yDegree += by * 5;
    zDegree += bz * 5;
    [self render];
}

//从图片中加载纹理
- (GLuint)setupTexture:(NSString *)fileName {
     //1、将 UIImage 转换为 CGImageRef
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    //判断图片是否获取成功
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    //2、读取图片的大小，宽和高
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    //3.获取图片字节数 宽*高*4（RGBA）
    GLubyte *spriteData = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte));
    
    //4.创建上下文
    /*
     参数1：data,指向要渲染的绘制图像的内存地址
     参数2：width,bitmap的宽度，单位为像素
     参数3：height,bitmap的高度，单位为像素
     参数4：bitPerComponent,内存中像素的每个组件的位数，比如32位RGBA，就设置为8
     参数5：bytesPerRow,bitmap的没一行的内存所占的比特数
     参数6：colorSpace,bitmap上使用的颜色空间  kCGImageAlphaPremultipliedLast：RGBA
     */
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    //5、在CGContextRef上--> 将图片绘制出来
    /*
     CGContextDrawImage 使用的是Core Graphics框架，坐标系与UIKit 不一样。UIKit框架的原点在屏幕的左上角，Core Graphics框架的原点在屏幕的左下角。
     CGContextDrawImage
     参数1：绘图上下文
     参数2：rect坐标
     参数3：绘制的图片
     */
    CGRect rect = CGRectMake(0, 0, width, height);
    
    //6.使用默认方式绘制
    CGContextDrawImage(spriteContext, rect, spriteImage);
    
    //7、画图完毕就释放上下文
    CGContextRelease(spriteContext);
     //8、绑定纹理到默认的纹理ID
    glBindTexture(GL_TEXTURE_2D, 0);
    //9.设置纹理属性
    /*
     参数1：纹理维度
     参数2：线性过滤、为s,t坐标设置模式
     参数3：wrapMode,环绕模式
     */
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    float fw = width, fh = height;
    //10.载入纹理2D数据
    /*
     参数1：纹理模式，GL_TEXTURE_1D、GL_TEXTURE_2D、GL_TEXTURE_3D
     参数2：加载的层次，一般设置为0
     参数3：纹理的颜色值GL_RGBA
     参数4：宽
     参数5：高
     参数6：border，边界宽度
     参数7：format
     参数8：type
     参数9：纹理数据
     */
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    //11.释放
    free(spriteData);
    return 0;
}

@end
