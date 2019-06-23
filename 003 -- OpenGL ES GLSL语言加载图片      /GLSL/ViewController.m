//
//  ViewController.m
//  GLSL
//
//  Created by denglei on 2019/6/9.
//  Copyright © 2019 soudian. All rights reserved.
//

#import "ViewController.h"
#import "DLView.h"
@interface ViewController ()
@property(nonnull,strong)DLView *myView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myView = (DLView*) self.view;
    
}


@end
