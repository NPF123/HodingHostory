//
//  Define.h
//  HoldingHistory
//
//  Created by qianfeng on 15/7/14.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#ifndef HoldingHistory_Define_h
#define HoldingHistory_Define_h
#define kScreenSize [UIScreen mainScreen].bounds.size

extern NSString * const kLZXFavorite;
extern NSString * const kLZXDownloads ;
extern NSString * const kLZXBrowses;



//包括 世界界面的接口 以及详情 信息
#define  kMainUrl @"http://icity.2q10.com/api/v1/imsm/world?app_id=imsm&locale=zh-Hans&page=%ld"

//详情  %@ 对应是是 http://icity.2q10.com/api/v1/imsm/entries/vti9xiu

#define  kDetailUrl @"http://icity.2q10.com/api/v1/imsm/entries/%@"

//点击 城市 的按钮 %@ 代表 城市的 拼音
#define kCityUrl @"http://icity.2q10.com/api/v1/imsm/events?city=%@"
//http://icity.2q10.com/api/v1/imsm/events?city=suzhou

//点击 cell的时候 坐标的%@ 表示 城市 拼音    和 经纬 坐标
#define kCellDetailUrl @"http://icity.2q10.com/api/v1/imsm/cities/%@/near?filter=museum&hide_segments=true&longitude=%f&latitude=%f"   
//http://icity.2q10.com/api/v1/imsm/cities/suzhou/near?filter=museum&hide_segments=true&longitude=120.702085&latitude=31.321161




//首页详情
#define kSameCityUrl @"http://icity.2q10.com/api/v1/imsm/events/%@"
//http://icity.2q10.com/api/v1/imsm/events/4ge7kdq

//分享 
#define kShareUrl @"http://m.icity.ly/s/imn/%@"
//http://m.icity.ly/s/imn/vti9xiu  其中vti9xiu 是标题key


#import "NSString+Helper.h"
#import "LZXHelper.h"
#import "UIImageView+WebCache.h"

#ifdef DEBUG
//变参宏
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif
#endif
