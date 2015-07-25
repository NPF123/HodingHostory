//
//  WorldCell.m
//  HoldingHistory
//
//  Created by qianfeng on 15/7/15.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "WorldCell.h"
#import "worldModel.h"
@implementation WorldCell

- (void)awakeFromNib {
    
    
    
}

- (void)showDataWithModel:(worldModel *)model{
    [self.pic_coverImageVeiw sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:nil];
    self.titleLabel.text = model.title;
    self.pretitleLabel.text = model.pretitle;
    self.subtitleLabel.text = model.subtitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}






@end
