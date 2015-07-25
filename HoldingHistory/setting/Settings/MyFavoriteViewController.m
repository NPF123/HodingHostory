//
//  MyFavoriteViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-4-15.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "MyView.h"



@interface MyFavoriteViewController ()

@end

@implementation MyFavoriteViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //实例化MyView  在MyView上绘图
    MyView *myView = [[MyView alloc] initWithFrame:self.view.bounds];
    myView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:myView];

}

@end
