//
//  ECCell.h
//  HoldingHistory
//
//  Created by qianfeng on 15/7/21.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECModel.h"
@interface ECCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *picImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *pretitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *userCountLabel;
- (void)showdataWithModel:(ECModel *)model;
@end

