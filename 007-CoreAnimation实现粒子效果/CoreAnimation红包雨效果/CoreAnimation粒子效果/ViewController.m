//
//  ViewController.m
//  CoreAnimation粒子效果
//
//  Created by denglei on 2019/6/22.
//  Copyright © 2019 soudian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong)CAEmitterLayer *rainLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //粽子雨
    [self rain1];
    //混合雨
   // [self allRain];
}


//粽子雨
-(void)rain1
{
    //1.设置CAEmitterLayer
    CAEmitterLayer *rainLayer = [CAEmitterLayer layer];
    
    //2.在背景图上添加粒子图层
    [self.view.layer addSublayer:rainLayer];
    self.rainLayer = rainLayer;
    
    //3.发射形状--线性
    rainLayer.emitterShape = kCAEmitterLayerLine;
    rainLayer.emitterMode = kCAEmitterLayerSurface;
    rainLayer.emitterSize = self.view.frame.size;
    rainLayer.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, -10);
    
    //4.配置Cell
    CAEmitterCell *snowCell = [CAEmitterCell emitterCell];
    snowCell.contents = (id)[[UIImage imageNamed:@"hongbao.png"] CGImage];
    snowCell.birthRate = 1.0;
    snowCell.lifetime = 30;
    snowCell.speed = 2;
    snowCell.velocity = 10.f;
    snowCell.velocityRange = 10.f;
    snowCell.yAcceleration = 60;
    snowCell.scale = 0.05;
    snowCell.scaleRange = 0.f;
    
    //5.添加到图层上
    rainLayer.emitterCells = @[snowCell];
}

//粽子雨
-(void)allRain
{
    //1.设置CAEmitterLayer
    CAEmitterLayer *rainLayer = [CAEmitterLayer layer];
    
    //2.在背景图上添加粒子图层
    [self.view.layer addSublayer:rainLayer];
    self.rainLayer = rainLayer;
    
    //3.发射形状--线性
    rainLayer.emitterShape = kCAEmitterLayerLine;
    rainLayer.emitterMode = kCAEmitterLayerSurface;
    rainLayer.emitterSize = self.view.frame.size;
    rainLayer.emitterPosition = CGPointMake(self.view.bounds.size.width * 0.5, -10);
    
    //4.配置Cell
    CAEmitterCell *snowCell = [CAEmitterCell emitterCell];
    snowCell.contents = (id)[[UIImage imageNamed:@"zongzi2.jpg"] CGImage];
    snowCell.birthRate = 1.0;
    snowCell.lifetime = 30;
    snowCell.speed = 2;
    snowCell.velocity = 10.f;
    snowCell.velocityRange = 10.f;
    snowCell.yAcceleration = 60;
    snowCell.scale = 0.05;
    snowCell.scaleRange = 0.f;
    
    CAEmitterCell *snowCell2 = [CAEmitterCell emitterCell];
    snowCell2.contents = (id)[[UIImage imageNamed:@"hongbao.png"] CGImage];
    snowCell2.birthRate = 1.0;
    snowCell2.lifetime = 30;
    snowCell2.speed = 2;
    snowCell2.velocity = 10.f;
    snowCell2.velocityRange = 10.f;
    snowCell2.yAcceleration = 60;
    snowCell2.scale = 0.05;
    snowCell2.scaleRange = 0.f;
    
    CAEmitterCell *snowCell3 = [CAEmitterCell emitterCell];
    snowCell3.contents = (id)[[UIImage imageNamed:@"jinbi.png"] CGImage];
    snowCell3.birthRate = 1.0;
    snowCell3.lifetime = 30;
    snowCell3.speed = 2;
    snowCell3.velocity = 10.f;
    snowCell3.velocityRange = 10.f;
    snowCell3.yAcceleration = 60;
    snowCell3.scale = 0.1;
    snowCell3.scaleRange = 0.f;
    
    //5.添加到图层上
    rainLayer.emitterCells = @[snowCell,snowCell2,snowCell3];
}

@end
