//
//  BaseViewController.h
//  LimitFree
//
//  Created by LZXuan on 15-6-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//增加 titleView
- (void)addTitleViewWithTitle:(NSString *)title;
//增加 左右按钮
- (void)addBarButtonItemWithTitle:(NSString *)title
                           target:(id)target
                           action:(SEL)action
                           isLeft:(BOOL)isLeft;
@end





