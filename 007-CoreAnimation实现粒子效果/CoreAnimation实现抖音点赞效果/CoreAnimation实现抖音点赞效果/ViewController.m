//
//  ViewController.m
//  CoreAnimation实现抖音点赞效果
//
//  Created by denglei on 2019/6/22.
//  Copyright © 2019 soudian. All rights reserved.
//

#import "ViewController.h"
#import "DLLikeButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加点赞按钮
    DLLikeButton * btn = [DLLikeButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(200, 150, 30, 130);
    [self.view addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"like_orange"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)button{
    
    if (!button.selected) { // 点赞
        button.selected = !button.selected;
        NSLog(@"点赞");
    }else{ // 取消点赞
        button.selected = !button.selected;
        NSLog(@"取消赞");
    }
}
@end
