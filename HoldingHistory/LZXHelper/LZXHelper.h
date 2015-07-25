//
//  LZXHelper.h
//  Connotation
//
//  Created by LZXuan on 14-12-20.
//  Copyright (c) 2014年 LZXuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LZXHelper : NSObject
//把一个秒字符串 转化为真正的本地时间
//@"1419055200" -> 转化 日期字符串
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr;
//根据字符串内容的多少  在固定宽度 下计算出实际的行高
/**
 @method 获取指定宽度情况下，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;
//获取 当前设备版本
+ (double)getCurrentIOSVersion;

//获取当前设备屏幕的大小
+ (CGSize)getScreenSize;

//获得当前系统时间到指定时间的时间差字符串,传入目标时间字符串和格式
+(NSString*)stringNowToDate:(NSString*)toDate formater:(NSString*)formatStr;

// 获取一个文件 在 沙盒Library/Cashes/ 目录下的路径
+ (NSString *)getFullPathWithFile:(NSString *)urlName;
//检测 缓存文件 是否超时
+ (BOOL)isTimeOutWithFile:(NSString *)filePath timeOut:(double)timeOut;

/**
 * 功能描述: 清除ios7 cell 向右多20像素
 * 输入参数: N/A
 * 返 回 值: N/A
 */
+ (void)setExtraCellPixelExcursion :(UITableView*)iTableView;



/**
 * 功能描述: 获取本地当前资源文件路径
 * 输入参数: string 资源名称
 * 返 回 值: 转换成功的本地路径
 */
+ (UIImage*)getImageFileByName:(NSString*)sourceName;

/**
 * 功能描述: 判断网络状况
 * 输入参数: N/A
 * 输出参数: N/A
 * 返 回 值: YES-网络连接正常，NO-无网络
 */
+ (BOOL)connectedToNetwork;



/**
 * 功能描述: 清除TableView多余线条
 * 输入参数: N/A
 * 返 回 值: N/A
 */
+ (void)setExtraCellLineHidden: (UITableView *)iTableView;

/**
 * 功能描述: 根据图片大小拉伸按钮大小
 * 输入参数: 需要拉伸的button 左偏移 右偏移 默认图片 高亮图片
 * 返 回 值: void
 */
+ (void)setButtonBackgroundImageSize:(UIButton*)button left:(float)left right:(float)right normalImage:(UIImage*)imageNormal highlightedImage:(UIImage*)imageHighlighted;


/**
 * 功能描述: 十六进制转换成color
 * 输入参数: N/A
 * 返 回 值: N/A
 */
+ (UIColor *)colorWithHexString: (NSString *)iStringToConvert;

/**
 * 功能描述: color 转换成UIImage
 * 输入参数: UIColor
 * 返 回 值: UIImage
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
 * 功能描述: 通用按钮
 * 输入参数: colorType 颜色(0-绿色 1-橙色) round 是否带椭圆圆角 title 标题
 * 返 回 值: button
 */
+ (UIButton *)getCommonButtonWithColor:(int)colorType isRound:(BOOL)round title:(NSString *)title;

/**
 * 功能描述: 返回string中url数组
 * 输入参数: string
 * 返 回 值: array
 */
+ (NSArray*)getCorrectUrlString:(NSString*)string;

/*
 可以为我们专门来创建一些基本的控件，那么如果要创建Label button textField 就可以通过这个类来创建
 这个类好像一个工厂一样专门生产一些基本控件
 类似于工厂设计模式
 */

//这个类的功能就是创建label 和button
+ (UILabel *)creatLabelWithFrame:(CGRect)frame
                            text:(NSString *)text ;
//创建button可以创建 标题按钮和 图片按钮
+ (UIButton *)creatButtonWithFrame:(CGRect)frame
                            target:(id)target
                               sel:(SEL)sel
                               tag:(NSInteger)tag
                             image:(NSString *)name
                             title:(NSString *)title;
//创建UIImageView
+ (UIImageView *)creatImageViewWithFrame:(CGRect)frame
                               imageName:(NSString *)name;
//创建UITextField
+ (UITextField *)creatTextFieldWithFrame:(CGRect)frame
                             placeHolder:(NSString *)string
                                delegate:(id <UITextFieldDelegate>)delegate
                                     tag:(NSInteger)tag;


/**
 * 功能描述: 控制tabbar显示或隐藏
 * 输入参数: hidden 是否隐藏
 * 返 回 值: N/A
 */

- (void)hideTabBar:(BOOL)hidden withTime:(float)time  viewController:(UIViewController *)viewController;

/**
 * 功能描述: 控制navbar显示或隐藏
 * 输入参数: hidden 是否隐藏
 * 返 回 值: N/A
 */
- (void) hideNavBar:(BOOL)hidden withTime:(float)time viewController:(UIViewController *)viewController;





@end





