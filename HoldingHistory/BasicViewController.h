//
//  BasicViewController.h
//  HoldingHistory
//
//  Created by qianfeng on 15/7/19.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "JHRefresh.h"

@interface BasicViewController : UIViewController


@property (nonatomic, assign)NSInteger isHide;

@property (nonatomic,copy)NSString *LastUrl;

@property (nonatomic,copy)NSString *city;

@property(nonatomic)NSInteger currentPage;
///  block的传值
@property (nonatomic, copy)NSString *pinyin;

@property (nonatomic)NSMutableArray *dataUrlArr;

///  自己所在位置
@property  (nonatomic, assign)float latitude1;
@property  (nonatomic, assign)float longitude1;
- (void)creatTableView;
- (void)loadDataMessageWithUrl:(NSString *)commentUrl;
@end
