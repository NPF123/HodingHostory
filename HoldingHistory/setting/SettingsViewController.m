//
//  SettingsViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-6-26.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
{
    NSArray *_classNames;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showUI];
}
- (void)showUI {
    self.title = @"设置";
    //[self addTitleViewWithTitle:@"设置"];
    self.view.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
    _classNames = [[NSArray alloc]initWithObjects:@"MySettingViewController",@"MyAttentionViewController",@"MyFavoriteViewController",@"MyDownloadViewController",@"MyCommentViewController",@"MyHelpViewController",@"CandouViewController",nil];
    
    //NSArray *imageNames = @[@"account_setting",@"account_favorite",@"account_user",@"account_collect",@"account_download",@"account_comment",@"account_help",@"account_candou"];
    //NSArray *titles = @[@"我的设置",@"我的关注",@"我的账户",
                       // @"我的收藏",@"我的下载",@"我的评论",
                        //@"我的帮助",@"应用"];
    NSArray *titles = @[@"我的设置",@"任性一拍",@"涂鸦鸦",@"二维码",@"历史的今天"];
    NSArray *imageNames = @[@"seting",@"paizhao",@"tuya",@"qr",@"historyday"];
    //横向的间隔
    CGFloat wSpace = ([LZXHelper getScreenSize].width - 3*57)/4;
    
    //纵向的间隔
    CGFloat hSpace = ([LZXHelper getScreenSize].height-64-49 - 3*57)/4;
    for (int i = 0; i<titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 101+i;
        [btn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 8;
        //九宫格坐标的小算法:(横坐标:i%横向显示个数的最大值;纵坐标:i/纵向的个数的最大值)
        [btn setFrame:CGRectMake(wSpace +(i%3)*(57+wSpace),100+hSpace +(i/3)*(hSpace+57), 57,57)];
        [self.view addSubview:btn];
        
        //创建label
        UILabel *label = [LZXHelper creatLabelWithFrame:CGRectMake(wSpace+(i%3)*(50+wSpace)-3,100+hSpace+57 + (i/3)*(hSpace+57),70, 20) text:titles[i]];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
}

#pragma mark - 按钮触发的函数
- (void)btnClicked:(UIButton *)button{
    Class vcClass = NSClassFromString(_classNames[button.tag - 101]);
    BaseViewController *vc = [[vcClass alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = NO;
}
@end
