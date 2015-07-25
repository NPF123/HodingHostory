//
//  SCityDetailViewController.m
//  HoldingHistory
//
//  Created by qianfeng on 15/7/19.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "SCityDetailViewController.h"
#import "cityModle.h"
#import "cityCell.h"
#import "AFNetworking.h"
#import "UIWebView+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "worldModel.h"
#import "BKZoomView.h"
#import "UMSocial.h"
#import <MAMapKit/MAMapKit.h>
#import "whereViewController.h"
#import "UIImageView+WebCache.h"
#import "MMProgressHUD.h"
@interface SCityDetailViewController ()<UIScrollViewDelegate,UIAlertViewDelegate,UMSocialUIDelegate,MAMapViewDelegate>
{
    
    BOOL isHiddentopBar;
    BOOL isTap;
    NSMutableArray *_picsArr;
    UIScrollView *_scrollView;
    MAMapView *_mapView;
    worldModel *_worldModel;

}

@property (nonatomic,strong)NSMutableArray *picsArr;
@property (nonatomic)UIScrollView *scrollView;
@property (nonatomic)AFHTTPRequestOperationManager *manager;

///  夜间
@property (nonatomic, assign)NSInteger i;
@property (nonatomic, retain)UILabel *NightLabel;

@property(nonatomic, retain)UIView *myView;//  弹出的页面

///  登陆后返回的ID值。。。。。
@property (nonatomic, retain)NSString *userid;

///  登陆的警示款
@property (nonatomic, retain)UIAlertView *alertView;
@property (nonatomic, retain)BKZoomView *zoomView2;

@property (nonatomic, retain)UIButton *buttonRand;
@end

@implementation SCityDetailViewController
static  CGFloat totailHeight;
static CGFloat totailScrollviewHeight;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    _picsArr = [[NSMutableArray alloc] init];
    UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    iamgeView.image =[UIImage imageNamed: @"lishi2.png"];
    [self.view addSubview:iamgeView];

    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden= YES;
    [self loadDataWithCityName];
    
    

    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 250)];
    _mapView.mapType = MAMapTypeStandard;
    _mapView.region = MACoordinateRegionMake(CLLocationCoordinate2DMake(self.latitude, self.longitude),MACoordinateSpanMake(0.01, 0.01));
    _mapView.delegate = self;
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    pointAnnotation.title =self.title;
    pointAnnotation.subtitle = self.address;
    [_mapView addAnnotation:pointAnnotation];
    [self.scrollView addSubview:_mapView];
    
}

- (void)creatUI{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"chengshi"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
    

    NSString *time = [NSString stringWithFormat:@"时间:%@",self.timeValue];
    
    NSString *zhanguan = [NSString stringWithFormat:@"展馆:%@",self.zhanguan];
    NSString *address = [NSString stringWithFormat:@"地址:%@",self.address];
    NSString *money = [NSString stringWithFormat:@"费用:%@",self.money];
    NSString *summary = [NSString stringWithFormat:@"介绍:%@",self.summary];
    NSArray *arr = @[time,zhanguan,address,money,summary];
    for (NSInteger i=0; i<arr.count; i++) {
        CGFloat space = 5;
        CGFloat height =[LZXHelper textHeightFromTextString:arr[i] width:kScreenSize.width-20 fontSize:17.0];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 260+(totailHeight+space), kScreenSize.width-20, height)];
        totailHeight +=height;
        label.numberOfLines = 0;
        label.text = arr[i];
        //label.backgroundColor = [UIColor redColor];
        
        [self.scrollView addSubview:label];
    }
    
    for (NSInteger i =0; i<_picsArr.count; i++) {
        UIImageView * iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, totailHeight+270+251*i, kScreenSize.width, 250)];
        [iamgeView sd_setImageWithURL:[NSURL URLWithString:_picsArr[i]] placeholderImage:[UIImage imageNamed:@"loading"]];
        //iamgeView.image = [UIImage imageNamed:self.pic];
        //iamgeView.backgroundColor = [UIColor redColor];
        totailScrollviewHeight =(totailHeight+270+251*i);
        [self.scrollView addSubview:iamgeView];
    }
    
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width, totailScrollviewHeight);
    _scrollView.bounces = NO;
    
    
    [self.view addSubview:self.scrollView];
    [self creatButton];
    [self creatkongjian];
}

- (void)rightBarButtonClick:(UIButton *)button{
    whereViewController *whereVC = [[whereViewController alloc] init];
    whereVC.latitude = self.latitude;
    whereVC.longitude = self.longitude;
    whereVC.title = self.title;
    whereVC.address = self.address;
    [self.navigationController pushViewController:whereVC animated:YES];
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
- (void)creatButton{
    
    ///  回到顶部的按钮
    self.buttonRand = [UIButton buttonWithType:UIButtonTypeSystem];
    _buttonRand.frame = CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height - 100, 40, 40);
    [self.view addSubview:_buttonRand];
    _buttonRand.backgroundColor = [UIColor whiteColor];
    //_buttonRand.alpha = 0.5;
    _buttonRand.layer.cornerRadius = 20;
    [_buttonRand setImage:[UIImage imageNamed:@"ridge"] forState:UIControlStateNormal];
    [_buttonRand addTarget:self action:@selector(buttonRandAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonRand];
    NSArray *typeArr = @[@"分享",@"微调", @"返回"];
    for (int i = 0; i < typeArr.count; i++) {
        UIButton *buttonType1 = [UIButton buttonWithType:UIButtonTypeSystem];
        buttonType1.frame = CGRectMake(10+30 * i, self.view.frame.size.height+30, 50, 50);
        [buttonType1 setTitle:[typeArr objectAtIndex:i] forState:UIControlStateNormal];
        [buttonType1 addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        buttonType1.backgroundColor = [UIColor blackColor];
        buttonType1.alpha = 0.4;
        [buttonType1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonType1.tag = 101 + i;
        //初始button的动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 animations:^{
                UIButton *button  = (UIButton *)[self.view viewWithTag:101];
                UIButton *button1 = (UIButton *)[self.view viewWithTag:102];
                UIButton *button2 = (UIButton *)[self.view viewWithTag:103];
                UIButton *button3 = (UIButton *)[self.view viewWithTag:104];
                UIButton *button4 = (UIButton *)[self.view viewWithTag:105];
                button.frame = CGRectMake(10+55 * 0, self.view.frame.size.height - 50, 50, 50);
                button1.frame = CGRectMake(10+55 * 1, self.view.frame.size.height - 50, 50, 50);
                button2.frame = CGRectMake(10+55 * 2, self.view.frame.size.height - 50, 50, 50);
                button3.frame = CGRectMake(10+55* 3, self.view.frame.size.height - 50,50, 50);
                button4.frame = CGRectMake(10+55 * 4, self.view.frame.size.height - 50, 50,50);
            }];
        });
        [self.view addSubview:buttonType1];
        
#pragma mark ===  给view一个手势
        UITapGestureRecognizer *tapSet = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSet)];
        [self.view addGestureRecognizer:tapSet];
        
    }
    
    ///  给一面一个手势向右滑动返回上一页
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    [self.view addGestureRecognizer:swipe];
    ///  设置手势方向
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    
}

//回到顶部
- (void)buttonRandAction{
    [UIView animateWithDuration:1.0 animations:^{
        self.scrollView.frame = self.view.bounds;
        self.scrollView.contentOffset =CGPointMake(0, 0);
    }];
}

- (void)creatkongjian{
    
#pragma mark --------------- 弹出页面
    _myView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, self.view.frame.size.height - 120, self.view.frame.size.width, 80)];
    _myView.backgroundColor = [UIColor blackColor];
    _myView.alpha = 0.6;
    
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 140 /3)];
    label2.text = @"  夜间模式";
    label2.textColor = [UIColor whiteColor];
    [_myView addSubview:label2];
    
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(240, 10, 0, 0)];
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_myView addSubview:switchView];
    
    
    ///  放大镜
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 140/3, 160, 140/3)];
    label3.text = @"  放大镜";
    label3.textColor = [UIColor whiteColor];
    [_myView addSubview:label3];
    
    
    _zoomView2 = [[BKZoomView alloc] initWithFrame:CGRectMake(100, -180, 150, 150)];
    [_zoomView2 setZoomScale:2.0];
    [_zoomView2 setDragingEnabled:YES];
    _zoomView2.backgroundColor = [UIColor blackColor];
    [_zoomView2.layer setBorderColor:[UIColor blackColor].CGColor];
    [_zoomView2.layer setBorderWidth:1.0];
    [_zoomView2.layer setCornerRadius:75];
    [self.view addSubview:_zoomView2];
    
    
    UISwitch *switchBig = [[UISwitch alloc] initWithFrame:CGRectMake(240, 50, 0, 0)];
    [switchBig addTarget:self action:@selector(switchBig:) forControlEvents:UIControlEventValueChanged];
    [_myView addSubview:switchBig];
    
    ///  夜间模式用
    _NightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    _NightLabel.backgroundColor = [UIColor blackColor];
    _NightLabel.alpha = 0.5;
    [self.view addSubview:_NightLabel];
    _NightLabel.hidden =  YES;
    
    [self.view addSubview:_myView];
    
}
//按钮的控制
- (void)changeButtonClick:(UIButton *)button{
    switch (button.tag) {
        case 101://分享
        {
            NSString *text = [NSString stringWithFormat:@"博物馆%@",@"https://itunes.apple.com/cn/app/id897422059?mt=8"];
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"507fcab25270157b37000010"
                                              shareText:text
                                             shareImage:[UIImage imageNamed:@"account_candou"]
                                        shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToEmail,UMShareToSms]
                                               delegate:self];
            
        }
            break;
   
        case 102://微调
        {
                [UIView animateWithDuration:1.0 animations:^{
                    _myView.frame = CGRectMake(0, self.view.frame.size.height - 145, self.view.frame.size.width, 80);
                    
                }];
            }
            break;
        case 103://返回
            {
                self.navigationController.navigationBarHidden = NO;
                //[self dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
            
        default:
            break;
        }
            
    
}
//友盟
//弹出列表方法presentSnsIconSheetView需要设置delegate为self
- (BOOL)isDirectShareInIconActionSheet
{
    return YES;
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


///  手势回到上一页
- (void)swipeAction:(UISwipeGestureRecognizer *)swipe
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


///  放大镜出来效果
- (void)switchBig:(UISwitch *)switc{
    
    if (switc.on == YES) {
        
        [UIView animateWithDuration:1.0 animations:^{
            self.zoomView2.frame = CGRectMake(100, 120, 150, 150);
        }];
    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            self.zoomView2.frame = CGRectMake(100, -180, 150, 150);
        }];
    }
}


///  点击屏幕后的方法。隐藏设置条

- (void)tapSet{
    
    [UIView animateWithDuration:0.5 animations:^{
        _myView.frame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height-120, self.view.frame.size.width, 80);
        self.i =0;
    }];
    [UIView animateWithDuration:0.5 animations:^{
        
        _zoomView2.frame = CGRectMake(100, -180, 150, 150);
    }];
    
    if (isHiddentopBar ==YES) {
        self.navigationController.navigationBarHidden = NO;
        isHiddentopBar = NO;
    }else if (isHiddentopBar ==NO){
        self.navigationController.navigationBarHidden = YES;
        isHiddentopBar = YES;
    }
}

///  亮度调节
-(void)switchAction:(UISwitch *)swi
{
    
    (swi.on==YES)?(_NightLabel.hidden = NO):(_NightLabel.hidden = YES);
}





- (void)loadDataWithCityName{
    //设置下载特效
    //设置 风格
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
//    //设置特效标题
//    [MMProgressHUD showWithTitle:@"欢迎下载"  status:@"loading..."];
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:kSameCityUrl,self.key];
    [_manager GET:url  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dictData = dict[@"data"];
            NSArray *arr = [dictData allKeys];
            for (NSInteger i=0; i<arr.count; i++) {
                
                
                if (i==2) {
                    NSDictionary *dict = dictData[arr[2]];
                
                    NSArray *numarr =dict[@"event_entry_info"][@"fields"];
                    
                    for (NSInteger i=0; i<numarr.count; i++) {
                        if (i==0) {
                            NSDictionary *dict = numarr[0];
                            self.timeValue = dict[@"value"];
                           
                        }
                        if (i==3) {
                            NSDictionary *dict = numarr[3];
                            self.money = dict[@"value"];
                        
                        }
                    }
                }
                
                if (i==3) {
                    NSDictionary *dict = dictData[arr[3]];
                    NSArray *numarr =dict[@"album"][@"photos"];
                    for (NSDictionary *picDict in numarr) {
                        NSString *str = picDict[@"pic"];
                        self.pic = str;;
                        [_picsArr addObject:str];
                    }
                }
            }
//            //关闭下载特效
//            [MMProgressHUD dismissWithSuccess:@"成功" title:@"网络数据下载成功"];
        }
        [self creatUI];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"下载失败");
//        //下载失败也要关闭
//        [MMProgressHUD dismissWithError:@"失败" title:@"网络出现异常"];
    }];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self creatkongjian];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    
//    for (NSInteger i =0; i<=[self.view.subviews count]; i++) {
//        [[self.view.subviews objectAtIndex:i] removeFromSuperview];
//    }
    totailHeight = 0;
    totailScrollviewHeight=0;
}

@end
