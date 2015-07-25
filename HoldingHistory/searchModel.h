//
//  searchModel.h
//  HoldingHistory
//
//  Created by qianfeng on 15/7/18.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface searchModel : NSObject

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *subtitle;
@property (nonatomic,copy)NSString *pic_icon;
@property (nonatomic)NSInteger count;
@property (nonatomic,copy)NSString *title_count;



@end
/*
 {
 "title": "沈阳",
 "subtitle": "Shenyang",
 "pic_icon": "http://icity-static.2q10.com/images/uploads/ap/imsm/city/pic_icon/shenyang/195895f4ebfa4869shenyang.png/1415592602",
 "count": 10,
 "title_count": "展览"
 }
 */