//
//  SearchCell.h
//  HoldingHistory
//
//  Created by qianfeng on 15/7/18.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchModel.h"
@interface SearchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageIcon;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *pinyinLabel;

@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleCountLabel;





- (void)showDataWithSearchModel:(searchModel *)model;
@end
