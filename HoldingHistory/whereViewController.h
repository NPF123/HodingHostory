//
//  whereViewController.h
//  HoldingHistory
//
//  Created by qianfeng on 15/7/20.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface whereViewController : UIViewController
@property (nonatomic)float latitude;
@property (nonatomic)float longitude;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *address;
@end
