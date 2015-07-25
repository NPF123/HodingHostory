//
//  LZXHelper.m
//  Connotation
//
//  Created by LZXuan on 14-12-20.
//  Copyright (c) 2014年 LZXuan. All rights reserved.
//

#import "LZXHelper.h"

@implementation LZXHelper

#pragma mark -把一个秒字符串 转化为真正的本地时间
//把一个秒字符串 转化为真正的本地时间
//@"1419055200" -> 转化 日期字符串
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr {
    //转化为Double
    double t = [timerStr doubleValue];
    //计算出距离1970的NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    //转化为 时间格式化字符串
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //转化为 时间字符串
    return [df stringFromDate:date];
}

+ (CGSize)getScreenSize {
    return [[UIScreen mainScreen] bounds].size;
}
//获得当前系统时间到指定时间的时间差字符串,传入目标时间字符串和格式
+(NSString*)stringNowToDate:(NSString*)toDate formater:(NSString*)formatStr
{
    
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    if (formatStr) {
        [formater setDateFormat:formatStr];
    }
    else{
        [formater setDateFormat:[NSString stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
    }
    NSDate *date=[formater dateFromString:toDate];
    
    return [self stringNowToDate:date];
    
}


//获得到指定时间的时间差字符串,格式在此方法内返回前自己根据需要格式化
+(NSString*)stringNowToDate:(NSDate*)toDate
{
    //创建日期 NSCalendar对象
    NSCalendar *cal = [NSCalendar currentCalendar];
    //得到当前时间
    NSDate *today = [NSDate date];
    
    //用来得到具体的时差,位运算
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ;
    
    if (toDate && today) {//不为nil进行转化
        NSDateComponents *d = [cal components:unitFlags fromDate:today toDate:toDate options:0 ];
        
        //NSString *dateStr=[NSString stringWithFormat:@"%d年%d月%d日%d时%d分%d秒",[d year],[d month], [d day], [d hour], [d minute], [d second]];
        NSString *dateStr=[NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)[d hour], (long)[d minute], (long)[d second]];
        return dateStr;
    }
    return @"";
}
// 获取一个文件 在 沙盒Library/Cashes/ 目录下的路径
+ (NSString *)getFullPathWithFile:(NSString *)urlName{
    
    //先获取 沙盒中的Library/Cashes/ 路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *myCacheDirectory = [docPath stringByAppendingPathComponent:@"MyCaches"];
    //检测 MyCaches文件夹是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:myCacheDirectory]) {
        //不存在 那么创建
        [[NSFileManager defaultManager] createDirectoryAtPath:myCacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //用 MD5进行加密 转化为一串16进制的数字 （MD5 加密可以吧一个字符串转化为一串唯一的用16进制表示的数字串）
    NSString *newName = [urlName MD5];
    //拼接路径
    return [myCacheDirectory stringByAppendingPathComponent:newName];
}

//检测 缓存文件 是否超时
+ (BOOL)isTimeOutWithFile:(NSString *)filePath timeOut:(double)timeOut{
    
    //获取文件的 属性 (attributes)
    NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    //获取文件的上次修改时间
    NSDate *lastModfyDate = fileDict.fileModificationDate;
    //算出时间差  获取当前系统时间 和 lastModfyDate时间差
    NSTimeInterval  sub = [[NSDate date] timeIntervalSinceDate:lastModfyDate];
    if (sub <0) {
        sub = -sub;
    }
    //比较是否超时
    if (sub >timeOut) {
        //如果时间差 大于 设置的超时时间  那么就表示超时
        return YES;
    }
    return NO;
}

#pragma mark -动态 计算行高
//动态 计算行高
//根据字符串的实际内容的多少 在固定的宽度和字体的大小，动态的计算出实际的高度
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size{
    if ([LZXHelper getCurrentIOSVersion] >= 7.0) {
        //iOS7之后
        /*
         第一个参数: 预设空间 宽度固定  高度预设 一个最大值
         第二个参数: 行间距
         第三个参数: 属性字典 可以设置字体大小
         */
        //xxxxxxxxxxxxxxxxxx
        //ghjdgkfgsfgskdgfjk
        //sdhgfsdjkhgfjd
        
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
        CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil];
        //返回计算出的行高
        return rect.size.height;
        
    }else {
        //iOS7之前
        /*
         1.第一个参数  设置的字体固定大小
         2.预设 宽度和高度 宽度是固定的 高度一般写成最大值
         3.换行模式 字符换行
         */
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(textWidth, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        return textSize.height;//返回 计算出得行高
    }
}
#pragma mark -获取iOS版本号

//获取iOS版本号
+ (double)getCurrentIOSVersion {
    
    return [[[UIDevice currentDevice] systemVersion] doubleValue];
}

#pragma mark -清除TableView多余线条
/**
 * 功能描述: 清除TableView多余线条
 * 输入参数: N/A
 * 返 回 值: N/A
 */
+ (void)setExtraCellLineHidden: (UITableView *)iTableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [iTableView setTableFooterView:view];
    [view release];
}

#pragma mark -清除ios7 cell 向右多20像素
/**
 * 功能描述: 清除ios7 cell 向右多20像素
 * 输入参数: N/A
 * 返 回 值: N/A
 */
+ (void)setExtraCellPixelExcursion :(UITableView*)iTableView
{
    if([iTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [iTableView setSeparatorInset:UIEdgeInsetsZero];
    }
}
#pragma mark -十六进制转换成color
/**
 * 功能描述: 十六进制转换成color
 * 输入参数: N/A
 * 返 回 值: N/A
 */
+ (UIColor *)colorWithHexString: (NSString *)iStringToConvert
{
    NSString *cString = [[iStringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor yellowColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
#pragma mark -获取本地当前资源文件路径
/**
 * 功能描述: 获取本地当前资源文件路径
 * 输入参数: string 资源名称
 * 返 回 值: 转换成功的本地路径
 */
+ (UIImage*)getImageFileByName:(NSString*)sourceName
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:sourceName ofType:@""];
    return  [UIImage imageWithContentsOfFile:imagePath];
}

#pragma mark -通用按钮设置
/**
 * 功能描述: 通用按钮
 * 输入参数: colorType 颜色(0-绿色 1-橙色) round 是否带椭圆圆角 title 标题
 * 返 回 值: button
 */
+ (UIButton *)getCommonButtonWithColor:(int)colorType isRound:(BOOL)round title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage = nil;
    UIImage *highlightedImage = nil;
    switch (colorType) {
            //绿色按钮(up:#65ca07 on:#53ad00)
        case 0:
        {
            //带圆角
            if(round)
            {
                normalImage = [UIImage imageNamed:@"btn_green_round"];
                highlightedImage = [UIImage imageNamed:@"btn_green_round_on"];
            }
            else
            {
                normalImage = [UIImage imageNamed:@"btn_green"];
                highlightedImage = [UIImage imageNamed:@"btn_green_on"];
            }
            break;
        }
            //橙色按钮(up:#ff6600 on:#ff4f00)
        case 1:
        {
            if(round)
            {
                normalImage = [UIImage imageNamed:@"btn_orange_round"];
                highlightedImage = [UIImage imageNamed:@"btn_orange_round_on"];
            }
            else
            {
                normalImage = [UIImage imageNamed:@"btn_orange"];
                highlightedImage = [UIImage imageNamed:@"btn_orange_on"];
            }
            break;
        }
        default:
            normalImage = [UIImage imageNamed:@"btn_green"];
            highlightedImage = [UIImage imageNamed:@"btn_green_on"];
            break;
    }
    
    normalImage = [normalImage stretchableImageWithLeftCapWidth:floorf(normalImage.size.width/2) topCapHeight:floorf(normalImage.size.height/2)];
    highlightedImage = [highlightedImage stretchableImageWithLeftCapWidth:floorf(highlightedImage.size.width/2) topCapHeight:floorf(highlightedImage.size.height/2)];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}
#pragma mark -返回string中url数组
/**
 * 功能描述: 返回string中url数组
 * 输入参数: string
 * 返 回 值: array
 */
+ (NSArray*)getCorrectUrlString:(NSString*)string
{
    if([NSString isEmpty:string])
    {
        return nil;
    }
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0,[string length])];
    BOOL isMatching = (arrayOfAllMatches == nil || arrayOfAllMatches.count < 1 ? NO:YES);
    if(isMatching)
    {
        return arrayOfAllMatches;
    }
    return nil;
}
#pragma mark -color 转换成UIImage
/**
 * 功能描述: color 转换成UIImage
 * 输入参数: UIColor
 * 返 回 值: UIImage
 */
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark -根据图片大小拉伸按钮大小
/**
 * 功能描述: 根据图片大小拉伸按钮大小
 * 输入参数: 需要拉伸的button 左偏移 右偏移 默认图片 高亮图片
 * 返 回 值: void
 */
+ (void)setButtonBackgroundImageSize:(UIButton*)button left:(float)left right:(float)right normalImage:(UIImage*)imageNormal highlightedImage:(UIImage*)imageHighlighted
{
    UIImage *normalImage = imageNormal;
    UIImage *highlightedImage = imageHighlighted;
    if(normalImage)
    {
        normalImage = [normalImage stretchableImageWithLeftCapWidth:floorf(normalImage.size.width/2)+left topCapHeight:floorf(normalImage.size.height/2)+right];
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    }
    else
    {
        highlightedImage = [highlightedImage stretchableImageWithLeftCapWidth:floorf(highlightedImage.size.width/2)+left topCapHeight:floorf(highlightedImage.size.height/2)+right];
        [button setBackgroundImage:highlightedImage forState:UIControlStateNormal];
    }
    
    if(highlightedImage)
    {
        highlightedImage = [highlightedImage stretchableImageWithLeftCapWidth:floorf(highlightedImage.size.width/2)+left topCapHeight:floorf(highlightedImage.size.height/2)+right];
        [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    }
    else
    {
        normalImage = [normalImage stretchableImageWithLeftCapWidth:floorf(normalImage.size.width/2)+left topCapHeight:floorf(normalImage.size.height/2)+right];
        [button setBackgroundImage:normalImage forState:UIControlStateHighlighted];
    }
}


#pragma mark -要创建Label button textField 就可以通过这些方法来创建

+ (UILabel *)creatLabelWithFrame:(CGRect)frame text:(NSString *)text{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    return [label autorelease];
}

+ (UIButton *)creatButtonWithFrame:(CGRect)frame target:(id)target sel:(SEL)sel tag:(NSInteger)tag image:(NSString *)name title:(NSString *)title{
    UIButton *button = nil;
    if (name) {
        //创建图片按钮
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        if (title) {//图片标题按钮
            [button setTitle:title forState:UIControlStateNormal];
        }
        
    }else if (title) {
        //创建标题按钮
        button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    button.frame = frame;
    button.tag = tag;
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIImageView *)creatImageViewWithFrame:(CGRect)frame imageName:(NSString *)name{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image  = [UIImage imageNamed:name];
    return [imageView autorelease];
}
+ (UITextField *)creatTextFieldWithFrame:(CGRect)frame placeHolder:(NSString *)string delegate:(id<UITextFieldDelegate>)delegate tag:(NSInteger)tag{
    
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    //设置风格类型
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = string;
    //设置代理
    textField.delegate = delegate;
    //设置tag值
    textField.tag = tag;
    return [textField autorelease];
    
}

#pragma mark - tabbar and navbar
/**
 * 功能描述: 控制tabbar显示或隐藏
 * 输入参数: hidden 是否隐藏
 * 返 回 值: N/A
 */
- (void)hideTabBar:(BOOL)hidden withTime:(float)time  viewController:(UIViewController *)viewController{
    
    [UIView animateWithDuration:time animations:^{
        for(UIView *view in viewController.tabBarController.view.subviews)
        {
            if([view isKindOfClass:[UITabBar class]])
            {
                if (hidden)
                {
                    [view setFrame:CGRectMake(view.frame.origin.x, [[UIScreen mainScreen] bounds].size.height + 20, view.frame.size.width, view.frame.size.height)];
                }
                else
                {
                    [view setFrame:CGRectMake(view.frame.origin.x, [[UIScreen mainScreen] bounds].size.height + 20-49, view.frame.size.width, view.frame.size.height)];
                }
            }
            else
            {
                if (hidden)
                {
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [[UIScreen mainScreen] bounds].size.height + 20)];
                }
                else
                {
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [[UIScreen mainScreen] bounds].size.height + 20-49)];
                }
            }
        }
    }];
}
/**
 * 功能描述: 控制navbar显示或隐藏
 * 输入参数: hidden 是否隐藏
 * 返 回 值: N/A
 */
- (void) hideNavBar:(BOOL)hidden withTime:(float)time viewController:(UIViewController *)viewController
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:time];
    for(UIView *view in viewController.navigationController.view.subviews)
    {
        if([view isKindOfClass:[UINavigationBar class]])
        {
            if (hidden)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, -44.0f, view.frame.size.width, view.frame.size.height)];
            }
            else
            {
                [view setFrame:CGRectMake(view.frame.origin.x,  20.0f, view.frame.size.width, view.frame.size.height)];
            }
        }
    }
    [UIView commitAnimations];
}




@end


