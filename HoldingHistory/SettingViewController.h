//
//  SettingViewController.h
//  HoldingHistory
//
//  Created by qianfeng on 15/7/14.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController

@property (nonatomic, retain)NSString *avatarIcon;
@property (nonatomic, retain)NSString *avatarName;
@property (nonatomic, retain)UIImageView *avatarImage;
@property (nonatomic, retain)UITableView *userTableView;
@property (nonatomic, assign)NSInteger genderCount;
@property (nonatomic, retain)NSString *userURL;
@property (nonatomic, assign)NSInteger followCount;
@property (nonatomic, assign)NSInteger friendCount;
@property (nonatomic, assign)NSInteger shareCount;
@property (nonatomic, retain)UIImageView *backgroundLabel;

@property (nonatomic, retain)UILabel *nameLabel;
@property (nonatomic, retain)NSString *gender;
@property (nonatomic, retain)UIImageView *genderIamge;
@property (nonatomic, retain)UILabel *followLabel;
@property (nonatomic, retain)UILabel *friendLabel;
@property (nonatomic, retain)UILabel *shareLabel;


@property (nonatomic, retain)UIView *loginview;
@property (nonatomic, retain)UIView *mainview;
@end
