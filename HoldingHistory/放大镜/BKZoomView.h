//
//  BKZoomView.h
//  BKZoomView
//
//  Created by Bastian Kohlbauer on 29.08.14.
//  Copyright (c) 2014 Bastian Kohlbauer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKZoomView : UIView

/*
 * Sets the scale on how far you want to zoom in to.
 */
- (void)setZoomScale:(CGFloat)scale;

/*
 * Enables/disables dragging of the zoom view.
 */
- (void)setDragingEnabled:(BOOL)enabled;
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
