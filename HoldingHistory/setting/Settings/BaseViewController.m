//
//  BaseViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-6-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

////增加 titleView
//- (void)addTitleViewWithTitle:(NSString *)title {
//    UILabel *titleLabel = [MyControl creatLabelWithFrame:CGRectMake(0, 0, 200, 30) text:title];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    
//    titleLabel.textColor = [UIColor colorWithRed:30/255.f green:160/255.f blue:230/255.f alpha:1];
//    titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:22];
//    
//    //设置titleView
//    self.navigationItem.titleView = titleLabel;
//    
//}
////增加 左右按钮
//- (void)addBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action isLeft:(BOOL)isLeft {
//    
//    UIButton *button = [MyControl creatButtonWithFrame:CGRectMake(0, 0, 50, 30) target:target sel:action tag:0 image:@"buttonbar_action" title:title];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
//    if (isLeft) {
//        self.navigationItem.leftBarButtonItem = item;
//    }else {
//        self.navigationItem.rightBarButtonItem = item;
//    }
//}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
