//
//  cityModle.h
//  HoldingHistory
//
//  Created by qianfeng on 15/7/19.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "NPFModel.h"

@interface cityModle : NPFModel

@property (nonatomic,copy)NSString *title;
@property (nonatomic)NSInteger users_count;
@property (nonatomic,copy)NSString *subtitle;
@property (nonatomic,copy)NSString *pretitle;
@property (nonatomic,copy)NSString *pic;

@property (nonatomic,copy)NSString *key;


@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *summary;
@property (nonatomic)float latitude;
@property (nonatomic)float longitude;

@property (nonatomic,copy)NSString *pic_top;


@end

/*
 "title": "无上清凉 — 苏州博物馆藏青绿与雪景绘画",
 "subtitle": "11 Jul 2015 - 11 Oct 2015",
 "rec_state": 0,
 "address": "苏州平江区东北街204号",
 "summary": "中国古代文人常常有挂雪景与青绿以销夏的习惯。唐代张彦远《历代名画记》记载：东汉刘褒曾画《云汉图》，人见之觉热；又画《北风图》，人见之觉凉。本期苏州博物馆的展览将从馆藏画作中遴选这两类作品，以助观者销夏。",
 "description": "<link ",
 "expand_detail": true,
 "fields": [
 {
 "key": "时间",
 "value": "2015年7月11日 \b- 10月11日  9:00 - 17:00 \r\n周一闭馆（不包括国家法定假日）\r\n提前1小时停止入馆"
 },
 {
 "key": "展馆",
 "value": "苏州博物馆",
 "type": 1,
 "action": {
 "target": 100,
 "url": "ic://imsm/museums/pcwcjjn",
 "has_nav": false,
 "has_trans_nav": true,
 "has_custom_nav": true
 }
 },
 {
 "key": "地址",
 "value": "苏州平江区东北街204号",
 "action": {
 "url": "ic://imsm/maps?center=31.323003,120.627746&zoom=15&name=%E6%97%A0%E4%B8%8A%E6%B8%85%E5%87%89%20%E2%80%94%20%E8%8B%8F%E5%B7%9E%E5%8D%9A%E7%89%A9%E9%A6%86%E8%97%8F%E9%9D%92%E7%BB%BF%E4%B8%8E%E9%9B%AA%E6%99%AF%E7%BB%98%E7%94%BB",
 "target": 100,
 "ctrl": 1
 }
 },
 {
 "key": "展厅",
 "value": "二楼吴门书画展厅"
 },
 {
 "key": "费用",
 "value": "Free"
 }
 ],
 "stats": {
 "comments_count": 0,
 "checkins_count": 1,
 "calls_count": 0,
 "plans_count": 1,
 "mixed_comments_count": 0,
 "rating_ave": null,
 "queue_mins_ave": null
 },
 "categories": "展览",
 "pic_cover": "http://icity-static.2q10.com/images/uploads/ap/imsm/event/pic_cover/2yacvby/ea77d1e7690326912yacvby.jpg/1436519589",
 "pic_head": {
 "pic": "http://icity-static.2q10.com/images/uploads/ap/imsm/event/pic_head/2yacvby/ea77d1e7690326912yacvby.jpg/1436519589"
 },
 "pic_top": {
 "pic": "http://icity-static.2q10.com/images/uploads/ap/imsm/event/pic_top/2yacvby/ea77d1e7690326912yacvby.jpg/1436519589"
 },
 "location": {
 "type": 2,
 "latitude": 31.323003,
 "longitude": 120.627746,
 "zoom": 0.01
 },
 "opened_at_start": 1436576400,
 "opened_at_end": 1444554000,
 "opened_at_title": null,
 "checked_in": false,
 "users_count": 2.628,
 "pretitle": "苏州博物馆",
 "pic_flag": "http://icity-static.2q10.com/images/uploads/ap/imsm/country/pic_icon/china/30611613e7aae3aechina.png/1401163390"
 }
 */