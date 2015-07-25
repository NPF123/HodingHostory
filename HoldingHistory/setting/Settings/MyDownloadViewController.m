//
//  MyDownloadViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-4-15.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

//生成二维码
#import "MyDownloadViewController.h"
#import "QRCodeGenerator.h"

@interface MyDownloadViewController ()
@property(nonatomic)UIImageView *imageView;
@end

@implementation MyDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenSize.width/2-100, kScreenSize.height/2-100, 200, 200)];
    [self.view addSubview:self.imageView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    UIImage *image = [QRCodeGenerator qrImageForString:@"每天都要有非常具体的小目标" imageSize:200];
    self.imageView.image = image;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
