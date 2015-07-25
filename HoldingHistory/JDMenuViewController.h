//
//  JDMenuViewController.h
//  HoldingHistory
//
//  Created by qianfeng on 15/7/15.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain)UITableView *tableview;

@property (nonatomic, retain)NSArray *arr;

@property (nonatomic, retain)NSArray *arrurl;

@property (nonatomic, retain)NSArray *arrimage;///  图片数组

@property (nonatomic, copy)NSString *city;
@end
