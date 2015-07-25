//
//  MyView.m
//  UIBezierPathDemo_贝塞尔画笔
//
//  Created by LZXuan on 15-7-9.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "MyView.h"
#define kScreenSize [UIScreen mainScreen].bounds.size

@implementation MyView
{
    //贝塞尔 画笔
    UIBezierPath *_penPath;
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //实例化一个画笔  当前 只需要一支画笔
        _penPath = [[UIBezierPath alloc] init];
        [self showUI];
        
    }
    return self;
}
- (void)showUI {
    NSArray *titles = @[@"清除"];
    for (NSInteger i = 0; i < titles.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(kScreenSize.width-100, 100+30*i, 100, 30);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.tag = 101+i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}
- (void)btnClick:(UIButton *)button {
    //清除
    //把画笔 路径上的点全部清除
    [_penPath removeAllPoints];
    //重新渲染
    [self setNeedsDisplay];
    
}
#pragma mark - 手指点击屏幕
//这时开始 把画笔 移动到这个点
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //获取当前触摸 UITouch
    UITouch *touch = [touches anyObject];
    //获取当前触摸的点 相对于当前视图的点 坐标
    CGPoint curPoint = [touch locationInView:self];
    
    //把画笔移动到这个点
    [_penPath moveToPoint:curPoint];
}
//手指在屏幕上移动的时候 调用
//这个方法会一直调用
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //获取当前触摸 UITouch
    UITouch *touch = [touches anyObject];
    //获取当前触摸的点 相对于当前视图的点 坐标
    CGPoint curPoint = [touch locationInView:self];
    
    //把当前点和以前的进行连线
    //连线
    [_penPath addLineToPoint:curPoint];
    
    //重新绘图 /重新渲染 当前视图
    [self setNeedsDisplay];
}
//- setNeedsDisplay  或者 - (void)setNeedsDisplayInRect:(CGRect)rect;
//重新绘制的时候 自动调用 - (void)drawRect:绘图方法 重新绘制视图
//- (void)drawRect: 不能手动调用



//当视图第一次加载的时候 系统会调用- (void)drawRect:
//只要 视图 重新渲染 都会调用
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //NSLog(@"drawRect");
    
    //设置画笔的颜色
    [[UIColor redColor] set];
    //设置 画笔的线条宽度
    _penPath.lineWidth = 5;
    
    //提交 绘制的路径 按照路径进行绘制视图
    [_penPath stroke];//告知系统 按照路径绘制视图
}

@end





