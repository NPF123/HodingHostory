//
//  whereViewController.m
//  HoldingHistory
//
//  Created by qianfeng on 15/7/20.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "whereViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchAPI.h>
@interface whereViewController ()<UITextFieldDelegate,MAMapViewDelegate,AMapSearchDelegate>
{
    CLLocationManager *_manager;
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    UITextField *_textField1;
    UITextField *_textField2;
    
}
@property (nonatomic,strong) CLLocationManager *manager;
@property (nonatomic,copy)NSString *result;
@end

@implementation whereViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _search = [[AMapSearchAPI alloc] initWithSearchKey:@"3041b65eeb908e384d229fb06dd7f389" Delegate:self];
    
    [self creatUI];
}

- (void)creatUI{
    

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, kScreenSize.width-80, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"查你想去的地方";
    [self.view addSubview:label];
    _textField1 = [[UITextField alloc] initWithFrame:CGRectMake(40, 65,kScreenSize.width-80,30)];
    _textField1.borderStyle = UITextBorderStyleLine;
    _textField1.placeholder = @"请输入地址";
    _textField1.clearsOnBeginEditing = YES;
    _textField1.tag = 1;
    _textField1.delegate = self;
    [self.view addSubview:_textField1];
    
    _textField2 = [[UITextField alloc] initWithFrame:CGRectMake(40, 100,kScreenSize.width-80,30)];
    _textField2.borderStyle = UITextBorderStyleLine;
    _textField2.placeholder = @"请输入城市";
    _textField2.tag = 2;
    _textField2.delegate = self;
    
    [self.view addSubview:_textField2];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(kScreenSize.width/2-30, 135, 60, 30);
    [button setTitle:@"查找" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.manager = [[CLLocationManager alloc] init];
    CGFloat v = [[[UIDevice currentDevice] systemVersion] doubleValue];
    if (v >= 8.0) {
        //申请验证
        [self.manager requestAlwaysAuthorization];
    }
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 170, kScreenSize.width, kScreenSize.height-170)];
    _mapView.mapType = MAMapTypeStandard;
    _mapView.region = MACoordinateRegionMake(CLLocationCoordinate2DMake(self.latitude, self.longitude),MACoordinateSpanMake(0.01, 0.01));
    _mapView.delegate = self;
    
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    pointAnnotation.title =self.title;
    pointAnnotation.subtitle = self.address;
    [_mapView addAnnotation:pointAnnotation];
    [self.view addSubview:_mapView];
    
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.searchType = AMapSearchType_InputTips;
    tipsRequest.keywords = _textField1.text;
    tipsRequest.city = @[_textField2.text];
    [_search AMapInputTipsSearch:tipsRequest];
    

}
- (void)btnClick:(UIButton *)button{
    //if ((_textField1.text !=nil) && (_textField2.text !=nil)) {
        AMapPlaceSearchRequest *poiRequest =[[AMapPlaceSearchRequest alloc]init];

        poiRequest.searchType =AMapSearchType_PlaceKeyword;
        poiRequest.keywords =_textField1.text;
       // NSLog(@"%@",poiRequest.keywords);
        poiRequest.city = @[_textField2.text];
        //NSLog(@"%@",poiRequest.city);
        poiRequest.requireExtension = YES;
        [_search AMapPlaceSearch:poiRequest];
    //}

}

#pragma mark - POI协议
//实现 POI 搜索对应的回调函数
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    if(response.pois.count == 0) {
        return;
    }
    //处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@",response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
//self.result = result;
    
    
     NSString * totailStr = nil;
    NSMutableArray *totailArr = [NSMutableArray array];
    NSArray* arr= [result componentsSeparatedByString:@"\n"];
    for (NSInteger i=3; i<arr.count; i++) {
        NSString *str = arr[i];
         NSLog(@"%@",str);
        NSArray *arr2 = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ{:.,}() -;[]_"]];
        NSString *str2 = [arr2 componentsJoinedByString:@""];
        NSArray *arr3 = [str2 componentsSeparatedByString:@" "];
        NSLog(@"%@",arr3);
        NSString *str3 = [arr3 componentsJoinedByString:@"\n"];
        NSLog(@"%@",str3);
        [totailArr addObject:str3];
        
    }
    totailStr = [totailArr componentsJoinedByString:@"\n"];
   // NSLog(@"%@",totailStr);
    self.result = totailStr;
//    for (NSInteger i=3; i<arr.count; i++) {
//         NSString *pjResult = [NSString stringWithFormat:@"{%@}",arr[i]];
//        NSLog(@"%@",pjResult);
//        NSData *jsonData = [pjResult dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dict);
//          NSString *count = [NSString stringWithFormat:@"%@",dict[@"count"]];
//          NSLog(@"%@",count);
//        self.result = [NSString stringWithFormat:@"%@\n",count];
//    }
//    NSString *pjResult = [NSString stringWithFormat:@"{%@}",result];
//    NSData *jsonData = [pjResult dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"%@",dict);
//    NSString *count = [NSString stringWithFormat:@"%@",dict[@"count"]];
//    NSLog(@"%@",count);
//    
//    NSDictionary *POIDict = dict[@"POI"];
//    NSLog(@"%@",POIDict);
    
    
    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"查找结果" message:self.result preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    //继续增加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
    
}
#pragma mark - 地图协议
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            annotationView.canShowCallout= YES; //设置气泡可以弹出,默认为 NO
            annotationView.animatesDrop = YES; //设置标注动画显示,默认为 NO￼￼
            annotationView.draggable = YES; //设置标注可以拖动,默认为 NO
            annotationView.pinColor = MAPinAnnotationColorPurple;
            return annotationView;
        }
    }
    return nil;
}

//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
    {
        return;
    }
    
    //通过AMapInputTipsSearchResponse对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld", (long)response.count];
    NSString *strtips = @"";
    for (AMapTip *p in response.tips) {
        strtips = [NSString stringWithFormat:@"%@\nTip: %@", strtips, p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@", strCount, strtips];
    NSLog(@"InputTips: %@", result);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
{
 count: 1
 Suggestion: {keywords:[], cities:[]}
 
 POI: {uid: B000A7POZQ, name: 景福宫, 
     type: 餐饮服务;中餐厅;中餐厅,
     location: {40.358573, 116.008463}, 
     address: G6京藏高速58号出口八达岭长城, 
     tel: , 
     distance: 0,
     postcode: ,
     website: ,
     email: ,
     province: 北京市, 
     pcode: 110000,
     city: 北京市, 
     citycode: 010, 
     district: 延庆县, 
     adcode: 110229, 
     gridcode: 6016403002, 
     navipoiid: K50F044017_123,
     enterLocation: {40.357791, 116.007473}, 
     exitLocation: {0.000000, 0.000000},
     weight: 0.40, 
     match: 0.00,
     recommend: 0, 
     timestamp: , direction: , 
     hasIndoorMap: 0, 
     indoorMapProvider: ,
     businessArea: 八达岭,
     bizExtension: {rating: 2.90, cost: 0.00, starForHotel: 0, 
                     lowestPriceForHotel: 0.00, mealOrderingForDining: 0,
                     seatOrderingForCinema: 0, 
                     ticketOrderingScenic: 0,
                     hasGroupbuy: 0, hasDiscount: 0
                    }, 
     richContent: {groupbuys:[], discounts:[]}, 
     deepContent: (null)}
     2015-07-20 17:02:54.930 HoldingHistory[5925:245114] 景福宫
     2015-07-20 17:02:54.930 HoldingHistory[5925:245114] (
     "\U5317\U4eac"
     )
     2015-07-20 17:02:55.014 HoldingHistory[5925:245114] 2323count: 1
     Suggestion: {keywords:[], cities:[]
 }
 
 POI: {uid: B000A7POZQ, 
         name: 景福宫,
         type: 餐饮服务,
         中餐厅;中餐厅, 
         location: {40.358573, 116.008463},
         address: G6京藏高速58号出口八达岭长城, 
         tel: , 
         distance: 0, 
         postcode: , 
         website: , 
         email: , 
         province: 北京市, 
         pcode: 110000, 
         city: 北京市, 
         citycode: 010, 
         district: 延庆县, 
         adcode: 110229,
         gridcode: 6016403002, 
         navipoiid: K50F044017_123,
         enterLocation: {40.357791, 116.007473}, 
         exitLocation: {0.000000, 0.000000}, 
         weight: 0.40, 
         match: 0.00, 
         recommend: 0, 
         timestamp: , 
         direction: , 
         hasIndoorMap: 0, 
         indoorMapProvider: ,
         businessArea: 八达岭, 
         bizExtension: {rating: 2.90,
                             cost: 0.00,
                             starForHotel: 0,
                             lowestPriceForHotel: 0.00,
                             mealOrderingForDining: 0,
                             seatOrderingForCinema: 0,
                            ticketOrderingScenic: 0, 
                            hasGroupbuy: 0, hasDiscount: 0
                            },
         richContent: {groupbuys:[], discounts:[]}, 
         deepContent: (null)
  }
 }
 */

@end
