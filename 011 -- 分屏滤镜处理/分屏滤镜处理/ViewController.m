//
//  ViewController.m
//  分屏滤镜处理
//
//  Created by denglei on 2019/6/25.
//  Copyright © 2019 soudian. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>
#import "FilterBar.h"

typedef struct {
    GLKVector3 positionCoord;//X,Y,Z
    GLKVector2 textureCoord; //U,V
} SceneVertex;

@interface ViewController ()<FilterBarDelegate>
@property(nonatomic, assign) SceneVertex *vertices;
@property(nonatomic, strong) EAGLContext *context;
//用于刷新屏幕
@property(nonatomic, strong) CADisplayLink *displayLink;
//开始的时间戳
@property(nonatomic, assign) NSTimeInterval startTimeInterval;
//着色器程序
@property(nonatomic, assign) GLuint program;
//顶点缓存
@property(nonatomic, assign) GLuint vertexBuffer;
//纹理ID
@property(nonatomic, assign) GLuint textureID;
@end

@implementation ViewController
//释放
-(void)dealloc{
     //1.上下文释放
     if([EAGLContext currentContext] == self.context){
          [EAGLContext setCurrentContext:nil];
     }
     //2.顶点缓冲区释放
     if(_vertexBuffer){
          glDeleteBuffers(1, &_vertexBuffer);
          _vertexBuffer = 0;
     }
     //3.顶点数组释放
     if(_vertices){
          free(_vertices);
          _vertices = nil;
     }
}

-(void)viewWillDisappear:(BOOL)animated{
     [super viewWillDisappear:animated];
     //移除displayLink
     if(self.displayLink){
          [self.displayLink invalidate];
          self.displayLink = nil;
     }
}

- (void)viewDidLoad {
     [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor blackColor];
     //创建滤镜工具栏
     [self setupFilterBar];
     //滤镜处理初始化
     [self filterInit];
     //开始下一个滤镜动画
     [self startFilterAnimation];
}

//创建滤镜工具栏
- (void)setupFilterBar{
     CGFloat filterBarWidth = [UIScreen mainScreen].bounds.size.width;
     CGFloat filterBarHeight = 100;
     CGFloat filterBarY = [UIScreen mainScreen].bounds.size.height - filterBarHeight;
     FilterBar *filterBar = [[FilterBar alloc] initWithFrame:CGRectMake(0, filterBarY, filterBarWidth, filterBarHeight)];
     filterBar.delegate = self;
     [self.view addSubview:filterBar];
     
     filterBar.itemList = @[@"无",@"分屏-2",@"分屏-3",@"分屏-4",@"分屏-6",@"分屏-9"];
}

//滤镜处理初始化
-(void)filterInit{
       //1. 初始化上下文并设置为当前上下文
     self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
     [EAGLContext setCurrentContext:self.context];
     
     //2.开辟顶点数组内存空间
     self.vertices = malloc(sizeof(SceneVertex) * 4);
     
     //3.初始化顶点的顶点坐标和纹理坐标
     self.vertices[0] = (SceneVertex){{-1, 1, 0},{0, 1}};
     self.vertices[1] = (SceneVertex){{-1, -1, 0},{0, 0}};
     self.vertices[2] = (SceneVertex){{1, 1, 0},{1,1}};
     self.vertices[3] = (SceneVertex){{1, -1, 0},{1,0}};
     
     //4.创建图层
     CAEAGLLayer *layer = [[CAEAGLLayer alloc] init];
     //设置图层frame
     layer.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width);
     //设置图层的scale
     layer.contentsScale = [[UIScreen mainScreen] scale];
     //给view添加layer
     [self.view.layer addSublayer:layer];
     
     //5.绑定渲染缓存区
     [self bindRenderLayer:layer];
     
     //6.获取处理的图片路径
     NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"kunkun.jpg"];
     
     //读取图片
     UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
     //将图片转成纹理图片
     GLuint textrueID = [self createTextureWithImage:image];
     //设置纹理ID
     self.textureID = textrueID;
     
     //7.设置视口
     glViewport(0, 0, self.drawableWidth, self.drawableHeight);
     
     //8.设置顶点缓冲区
     GLuint vertexBuffer;
     glGenBuffers(1, &vertexBuffer);
     glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
     GLsizeiptr bufferSizeBytes = sizeof(SceneVertex) * 4;
     glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, self.vertices, GL_DYNAMIC_DRAW);
     
     //9.设置默认着色器
     [self setupNormalShaderProgram];
     
     //10.将顶点缓冲保存，退出时才释放
     self.vertexBuffer = vertexBuffer;
}

//绑定渲染缓存区
-(void)bindRenderLayer:(CAEAGLLayer *)layer{
     //1.渲染缓存区，帧缓存区对象
     GLuint renderBUffer;
     GLuint frameBuffer;
     
     //2.获取帧缓存区名称，绑定渲染缓冲区以及将渲染缓冲区与layer建立连接
     glGenRenderbuffers(1, &renderBUffer);
     glBindRenderbuffer(GL_RENDERBUFFER, renderBUffer);
     [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
     
     //3.获取帧缓存区名称，绑定帧缓存区以及将渲染缓存区附着到帧缓存区上
     glGenFramebuffers(1, &frameBuffer);
     glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
     glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderBUffer);
     
}

-(GLuint)createTextureWithImage:(UIImage *)image{
     //1.将UIImage转换为CGImageRef
     CGImageRef cgImageRef = [image CGImage];
     //判断图片是否获取成功
     if(!cgImageRef)
     {
          return 0;
     }
     //2.读取图片的大小和宽高
     GLuint width = (GLuint)CGImageGetWidth(cgImageRef);
     GLuint height = (GLuint)CGImageGetHeight(cgImageRef);
     //获取图片的rect
     CGRect rect = CGRectMake(0, 0, width, height);
     
     //获取图片的颜色空间
     CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
     //3.获取图片字节数 宽*高*4（RGBA）
     void *imageData = malloc(width * height * 4);
     //4.创建上下文
     /*
      参数1：data,指向要渲染的绘制图像的内存地址
      参数2：width,bitmap的宽度，单位为像素
      参数3：height,bitmap的高度，单位为像素
      参数4：bitPerComponent,内存中像素的每个组件的位数，比如32位RGBA，就设置为8
      参数5：bytesPerRow,bitmap的没一行的内存所占的比特数
      参数6：colorSpace,bitmap上使用的颜色空间  kCGImageAlphaPremultipliedLast：RGBA
      */
     CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast);
     
     //翻转图片
     CGContextTranslateCTM(context, 0, height);
     CGContextScaleCTM(context, 1.0f, -1.0f);
     CGColorSpaceRelease(colorSpace);
     CGContextClearRect(context, rect);
     
     //对图片进行重新绘制，得到一张新的解压缩后的位图
     CGContextDrawImage(context, rect, cgImageRef);
     
     //设置图片的纹理属性
     //5.获取纹理ID
     GLuint textureID;
     glGenTextures(1, &textureID);
     glBindTexture(GL_TEXTURE_2D, textureID);
     
     //6.载入纹理2D数据
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
     glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
       //7.设置纹理属性
     glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
     glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
     glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
     glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
     
     
     //8.绑定纹理
     /*
      参数1：纹理维度
      参数2：纹理ID,因为只有一个纹理，给0就可以了。
      */
     glBindTexture(GL_TEXTURE_2D, 0);
     
     //9.释放context,imageData
     CGContextRelease(context);
     free(imageData);
     //返回纹理ID
     return textureID;
}


//开始下一个滤镜动画
-(void)startFilterAnimation{
     //1.判断displayLink是否为空
     //CADispalyLink定时器
     if(self.displayLink){
          [self.displayLink invalidate];
          self.displayLink = nil;
     }
     //2.设置displayLink的方法
     self.startTimeInterval = 0;
     self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeAction)];
     
     //3.将displayLink 添加到runloop运行循环
     [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

//2. 动画
- (void)timeAction {
     //DisplayLink的时间戳
     if(self.startTimeInterval == 0){
          self.startTimeInterval = self.displayLink.timestamp;
     }
     //使用program
     glUseProgram(self.program);
     //绑定buffer
     glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
     
     //传入时间
     CGFloat currentTime = self.displayLink.timestamp - self.startTimeInterval;
     GLuint time = glGetUniformLocation(self.program, "Time");
     glUniform1f(time, currentTime);
     
     //清除画布
     glClear(GL_COLOR_BUFFER_BIT);
     glClearColor(1, 1, 1, 1);
     
     //重绘
     glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
     
     //渲染到屏幕上
     [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - FilterBarDelegate

- (void)filterBar:(FilterBar *)filterBar didScrollToIndex:(NSUInteger)index {
     //1. 选择默认shader
     if (index == 0) {
          [self setupNormalShaderProgram];
     }else if(index == 1){
          [self setupSplitScreen2ShaderProgram];
     }else if(index == 2){
          [self setupSplitScreen3ShaderProgram];
     }else if(index == 3){
          [self setupSplitScreen4ShaderProgram];
     }else if(index == 4){
          [self setupSplitScreen6ShaderProgram];
     }else if(index == 5){
          [self setupSplitScreen9ShaderProgram];
     }
     
     // 重新开始滤镜动画
     // [self startFilerAnimation];
     
     //渲染
     [self render];
}

-(void)render{
     //清除画布
     glClear(GL_COLOR_BUFFER_BIT);
     glClearColor(1, 1, 1 ,1);
     
     //使用program
     glUseProgram(self.program);
     //绑定buffer
     glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
     
     //重绘
     glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
     //渲染到屏幕上
     [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

//默认着色器
-(void)setupNormalShaderProgram{
     //设置着色器程序
     [self setupShaderProgramWithName:@"Normal"];
}

//二分屏色器
-(void)setupSplitScreen2ShaderProgram{
     //设置着色器程序
     [self setupShaderProgramWithName:@"SplitScreen_2"];
}

//三分屏色器
-(void)setupSplitScreen3ShaderProgram{
     //设置着色器程序
     [self setupShaderProgramWithName:@"SplitScreen_3"];
}

//四分屏色器
-(void)setupSplitScreen4ShaderProgram{
     //设置着色器程序
     [self setupShaderProgramWithName:@"SplitScreen_4"];
}

//六分屏色器
-(void)setupSplitScreen6ShaderProgram{
     //设置着色器程序
     [self setupShaderProgramWithName:@"SplitScreen_6"];
}

//九分屏色器
-(void)setupSplitScreen9ShaderProgram{
     //设置着色器程序
     [self setupShaderProgramWithName:@"SplitScreen_9"];
}



// 初始化着色器程序
- (void)setupShaderProgramWithName:(NSString *)name {
     //1.获取着色器program
     GLuint program = [self programWithShaderName:name];
     
     //2.use Program
     glUseProgram(program);
     
     //3.获取索引位置
     GLuint positionSlot = glGetAttribLocation(program, "Position");
     GLuint textureSlot = glGetAttribLocation(program, "Texture");
     GLuint textureCoordsSlot = glGetAttribLocation(program, "TextureCoords");
     
     //4.激活纹理，绑定纹理ID
     glActiveTexture(GL_TEXTURE0);
     glBindTexture(GL_TEXTURE_2D, self.textureID);
     
     //5.纹理sampler
     glUniform1i(textureSlot, 0);
     
     //6.打开positionSlot 属性并且传递数据到positionSlot中(顶点坐标)
     glEnableVertexAttribArray(positionSlot);
     glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, positionCoord));
     
     //7.打开textureCoordsSlot 属性并传递数据到textureCoordsSlot(纹理坐标)
     glEnableVertexAttribArray(textureCoordsSlot);
     glVertexAttribPointer(textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, textureCoord));
     
     //保存programe,界面销毁则释放
     self.program = program;
}

//link Program
-(GLuint)programWithShaderName:(NSString *)shaderName{
     //1.编译顶点着色器/片元着色器
     GLuint vertexShader = [self compileShaderWithName:shaderName type:GL_VERTEX_SHADER];
     GLuint fragmentShader = [self compileShaderWithName:shaderName type:GL_FRAGMENT_SHADER];
     
     //2.将顶点/片元附着到program
     GLuint program = glCreateProgram();
     glAttachShader(program, vertexShader);
     glAttachShader(program, fragmentShader);
     
     //3.linkProgram
     glLinkProgram(program);
     
     //4.检查Link是否成功
     GLint linkSuccess;
     glGetProgramiv(program, GL_LINK_STATUS, &linkSuccess);
     if(linkSuccess == GL_FALSE){
          GLchar messages[256];
          glGetShaderInfoLog(program, sizeof(messages), 0, &messages[0]);
          NSString * message = [NSString stringWithUTF8String:messages];
          NSAssert(NO, @"program链接失败：%@", message);
          return 0;
     }
     
     return program;
}

//编译着色器
-(GLuint)compileShaderWithName:(NSString *)shaderName type:(GLenum)type{
     //1.获取shader路径
     NSString *shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:type == GL_VERTEX_SHADER ? @"vsh" : @"fsh"];
     NSError *error;
     NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
     if (!shaderString) {
          NSAssert(NO, @"读取shader失败");
          exit(1);
     }
     
     //2.创建shader -> 根据shaderType
     GLuint shader = glCreateShader(type);
     
     //3.获取shader source
     const char *shaderStringUTF8 = [shaderString UTF8String];
     int shaderStringLength = (int)[shaderString length];
     glShaderSource(shader, 1, &shaderStringUTF8, &shaderStringLength);
     
     //4.编译shader
     glCompileShader(shader);
     
     //5.查看编译是否成功
     GLint compileSuccess;
     glGetShaderiv(shader, GL_COMPILE_STATUS, &compileSuccess);
     if(compileSuccess == GL_FALSE){
          GLchar message[256];
          glGetShaderInfoLog(shader, sizeof(message), 0, &message[0]);
          NSString *messageString = [NSString stringWithUTF8String:message];
          NSAssert(NO, @"shader编译失败：%@", messageString);
          return 0 ;
     }
     
     //6.返回shader
     return shader;
}

//获取渲染缓存区的宽
- (GLint)drawableWidth {
     GLint backingWidh;
     glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidh);
     return backingWidh;
}

//获取渲染缓存区的高
- (GLint)drawableHeight{
     GLint backingHeight;
     glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
     return backingHeight;
}

@end
