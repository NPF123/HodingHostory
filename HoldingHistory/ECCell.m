//
//  ECCell.m
//  HoldingHistory
//
//  Created by qianfeng on 15/7/21.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "ECCell.h"
#import "UIImageView+WebCache.h"
@implementation ECCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)showdataWithModel:(ECModel *)model{
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:nil];
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.subtitle;
    self.pretitleLabel.text = model.pretitle;
    self.userCountLabel.text = [NSString stringWithFormat:@"%ld",model.users_count];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
