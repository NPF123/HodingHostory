//
//  MainViewController.h
//  HoldingHistory
//
//  Created by qianfeng on 15/7/14.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

//刷新
#pragma mark- 子类可以重写
-(void)createRefreshView;
-(void)endRefreshing;
@end
