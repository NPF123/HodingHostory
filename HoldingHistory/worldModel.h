//
//  worldModel.h
//  HoldingHistory
//
//  Created by qianfeng on 15/7/18.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "NPFModel.h"

@interface worldModel : NPFModel
//首cell
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *pic;
@property (nonatomic,copy)NSString *subtitle;
@property (nonatomic,copy)NSString *pretitle;

//详情

@property (nonatomic,copy)NSString *pubdate;
@property (nonatomic,copy)NSString *author;
//用textView
@property (nonatomic,copy)NSString *content;

@end
