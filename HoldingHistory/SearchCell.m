//
//  SearchCell.m
//  HoldingHistory
//
//  Created by qianfeng on 15/7/18.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "SearchCell.h"
#import "UIImageView+WebCache.h"
@implementation SearchCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)showDataWithSearchModel:(searchModel *)model{
    [self.imageIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.pic_icon]] placeholderImage:nil];
    self.cityLabel.text = model.title;
 
    self.pinyinLabel.text = model.subtitle;
   
    self.countLabel.text = [NSString stringWithFormat:@"%ld",model.count];
    
    self.titleCountLabel.text = model.title_count;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
