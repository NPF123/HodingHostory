//
//  WorldCell.h
//  HoldingHistory
//
//  Created by qianfeng on 15/7/15.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "worldModel.h"
@interface WorldCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *pic_coverImageVeiw;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *pretitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;


- (void)showDataWithModel:(worldModel *)model;
@end

