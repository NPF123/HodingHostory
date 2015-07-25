//
//  SCityDetailViewController.h
//  HoldingHistory
//
//  Created by qianfeng on 15/7/19.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCityDetailViewController : UIViewController

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *timeValue;
@property (nonatomic,copy)NSString *zhanguan;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *money;
@property (nonatomic,copy)NSString *summary;
//200020

@property (nonatomic,copy)NSString *pic;
//
@property (nonatomic)float latitude;
@property (nonatomic)float longitude;
@property (nonatomic,copy)NSString *pic_head;
@property (nonatomic,copy)NSString *pic_top;
//附近的 200300





@property (nonatomic,copy)NSString *key;




@property (nonatomic,copy)NSString *pic_map;


@end
