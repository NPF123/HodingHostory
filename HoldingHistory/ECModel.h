//
//  ECModel.h
//  HoldingHistory
//
//  Created by qianfeng on 15/7/21.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "NPFModel.h"

@interface ECModel : NPFModel
@property (nonatomic,copy)NSString *title;
@property (nonatomic)NSInteger users_count;
@property (nonatomic,copy)NSString *subtitle;
@property (nonatomic,copy)NSString *pretitle;
@property (nonatomic,copy)NSString *pic;

@property (nonatomic,copy)NSString *key;


@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *summary;
@property (nonatomic)float latitude;
@property (nonatomic)float longitude;

@property (nonatomic,copy)NSString *pic_top;
@end
