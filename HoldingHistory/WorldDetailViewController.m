//
//  WorldDetailViewController.m
//  HoldingHistory
//
//  Created by qianfeng on 15/7/15.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "WorldDetailViewController.h"
#import "AFNetworking.h"
#import "UIWebView+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "worldModel.h"
#import "BKZoomView.h"
#import "UMSocial.h"
@interface WorldDetailViewController ()<UIScrollViewDelegate,UIAlertViewDelegate,UMSocialUIDelegate>
{

    BOOL isHiddenView;
    BOOL isHiddentopBar;
}
@property (strong, nonatomic) IBOutlet UIImageView *picImageView;
@property (strong, nonatomic) IBOutlet UILabel *pubdataLabel;
@property (strong, nonatomic) IBOutlet UILabel *pretitlelabel;

@property (strong, nonatomic) IBOutlet UILabel *authorLabel;

@property (strong, nonatomic) IBOutlet UITextView *contentTextView;

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


@end

@implementation WorldDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden= YES;
    [self creatDetailView];
    
}



- (void)creatButton{
    NSArray *typeArr = @[@"分享",@"微调", @"返回"];
    for (int i = 0; i < typeArr.count; i++) {
        UIButton *buttonType1 = [UIButton buttonWithType:UIButtonTypeSystem];
        buttonType1.frame = CGRectMake(10+30 * i, self.view.frame.size.height+30, 30, 30);
        [buttonType1 setTitle:[typeArr objectAtIndex:i] forState:UIControlStateNormal];
        [buttonType1 addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        buttonType1.backgroundColor = [UIColor blackColor];
        buttonType1.alpha = 0.4;
        [buttonType1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonType1.tag = 101 + i;
        //初始button的动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 animations:^{
                UIButton *button = (UIButton *)[self.view viewWithTag:101];
                UIButton *button1 = (UIButton *)[self.view viewWithTag:102];
                UIButton *button2 = (UIButton *)[self.view viewWithTag:103];
                UIButton *button3 = (UIButton *)[self.view viewWithTag:104];
                UIButton *button4 = (UIButton *)[self.view viewWithTag:105];
                button.frame = CGRectMake(10+55 * 0, self.view.frame.size.height - 50, 50, 50);
                button1.frame = CGRectMake(10+55 * 1, self.view.frame.size.height - 50, 50, 50);
                button2.frame = CGRectMake(10+55 * 2, self.view.frame.size.height - 50, 50, 50);
                button3.frame = CGRectMake(10+55 * 3, self.view.frame.size.height - 50,50, 50);
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


- (void)creatkongjian{

#pragma mark --------------- 弹出页面
    _myView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, self.view.frame.size.height - 145, self.view.frame.size.width, 80)];
    _myView.backgroundColor = [UIColor blackColor];
    _myView.alpha = 0.6;
    [self.view addSubview:_myView];
    
    
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
                                        shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToWechatTimeline,UMShareToEmail,UMShareToSms]
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
        _myView.frame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height-145, self.view.frame.size.width, 80);
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
//    if (swi.on == YES) {
//        isDay =YES;
//        
////        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
////        [center postNotificationName:@"夜间模式" object:@"0.3"];
//        
//    }
//    else
//    {
//        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//        [center postNotificationName:@"夜间模式" object:@"0.0"];
//    }
}


- (void)creatDetailView{

    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer  serializer];
    NSString *url = [NSString stringWithFormat:kDetailUrl,self.catagere];
    __weak typeof(self)weakSelf = self;
    [weakSelf.manager GET:url parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *str = [[dict[@"data"] allKeys]lastObject];
            NSDictionary *dict1 = dict[@"data"][str][@"chest"];
            
            [self.picImageView sd_setImageWithURL:[NSURL URLWithString:(dict1[@"pic_top"])[@"pic"]] placeholderImage:nil];
            self.pubdataLabel.text =dict1[@"pubdate"];
            NSLog(@"%@",self.pubdataLabel.text);
            self.pretitlelabel.text =dict1[@"pretitle"];
            self.authorLabel.text =dict1[@"author"];
            self.contentTextView.text = dict1[@"summary"];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载 失败");
    }];
}

- (void)viewWillAppear:(BOOL)animated{

    [self creatButton];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [self creatkongjian];
    
}
- (void)viewWillDisappear:(BOOL)animated{

    for (NSInteger i =0; i<=[self.view.subviews count]; i++) {
        [[self.view.subviews objectAtIndex:i] removeFromSuperview];
    }
}
@end
