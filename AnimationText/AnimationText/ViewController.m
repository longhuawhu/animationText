//
//  ViewController.m
//  AnimationText
//
//  Created by lh on 16/6/1.
//  Copyright © 2016年 Lh. All rights reserved.
//

#import "ViewController.h"
#import "LHAnimationText.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 100)];
    [self.view addSubview:view];
    
    LHAnimationText *aText = [[LHAnimationText alloc] initWithReferenceView:view];
    aText.textToAnimate = @"hello world!";
    
    [aText startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
