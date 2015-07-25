//
//  BasicViewController.m
//  HoldingHistory
//
//  Created by qianfeng on 15/7/19.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "BasicViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "MMProgressHUD.h"
#import "LZXHelper.h"

#import "cityModle.h"
#import "cityCell.h"

#import "SCityDetailViewController.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface BasicViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *_scrollView;

}
@property (nonatomic)UITableView *tableView;
@property (nonatomic)NSMutableArray *dataArr;

@end

@implementation BasicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    UIImageView *iamgeView = [[UIImageView alloc] init];
//    iamgeView.image =[UIImage imageNamed: @"long.png"];
//    [self.view addSubview:iamgeView];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self MakeUrl];
    [self creatTableView];
}

- (void)MakeUrl{
    NSArray *arrCity = @[@"geneva",@"beijing",@"london",@"shanghai",@"paris",@"chongqing",@"tianjin",@"guangzhou",@"ningbo",@"sydney",@"xian",@"shenyang",@"hangzhou",@"hongkong",@"suzhou",@"taiwan",@"nanjing",@"shenzhen",@"zurich",@"berlin",@"kyoto-nara",@"chengdu",@"wuhan",@"tokyo",@"washington",@"vancouver",@"newyork"];
    self.city = [NSString stringWithFormat:@"%@",arrCity[1]];
    /// 通知中心接受到城市数据
    //首页
    NSString *all = [NSString stringWithFormat:@"%@", self.city];
    //最新
    NSString *latest =[NSString stringWithFormat:@"%@&order=latest", self.city];
    //即将结束
    NSString *end_soon = [NSString stringWithFormat:@"%@&order=end_soon", self.city];
    //即将开始
    NSString *coming = [NSString stringWithFormat:@"%@&order=coming", self.city];
    //展览
    NSString *exhibition =[NSString stringWithFormat:@"%@&category=exhibition", self.city];
    //附近
    NSString *near =@"fj";
    self.dataUrlArr = [NSMutableArray arrayWithObjects:all, latest, end_soon, coming, exhibition, near, nil];
    
    
}


- (void)creatTableView{
     
    self.dataArr = [[NSMutableArray alloc] init];
    self.automaticallyAdjustsScrollViewInsets = YES;
    _dataArr = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
    _tableView.rowHeight = 100;
   
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = [UIColor lightGrayColor];
    //_tableView.separatorStyle = UITableViewCellAccessoryNone;
//    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
//    _scrollView.delegate = self;
//    _scrollView.showsVerticalScrollIndicator = NO;
//    self.tableView.tableHeaderView = _scrollView;
    
    
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 180)];
//    
//    imageView.backgroundColor = [UIColor redColor];
//Users/qianfeng01/Desktop/HoldingHistory/HoldingHistory.xcodeproj/    self.tableview.tableHeaderView = imageView;
    
    [_tableView registerNib:[UINib nibWithNibName:@"cityCell" bundle:nil] forCellReuseIdentifier:@"cityCell"];
    [self.view addSubview:_tableView];
}

- (void)loadDataMessageWithUrl:(NSString *)commentUrl{

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *path = [LZXHelper getFullPathWithFile:commentUrl];
    BOOL isExist =[[NSFileManager defaultManager] fileExistsAtPath:path];
    //是否超时 一天
    BOOL isTimeOut = [LZXHelper isTimeOutWithFile:commentUrl timeOut:24*60*60];
    if ((isExist == YES)&&(isTimeOut == NO)) {
        //同时成立  走本地缓存数据
        NSData *data = [NSData dataWithContentsOfFile:[LZXHelper getFullPathWithFile:commentUrl]];
        //解析二进制数据
        
            [self.dataArr removeAllObjects];
         __weak typeof(self) weakSelf =self;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *numDict = dict[@"data"][@"200300"] ;
        
        NSArray *arr = [numDict allKeys];
        for (NSString *str in arr) {
            NSDictionary *dict = numDict[str];
            cityModle *model = [[cityModle alloc] init];
            model.title = dict[@"title"];
            model.subtitle = dict[@"subtitle"];
            model.pic = dict[@"pic_head"][@"pic"];
            model.pretitle = dict[@"pretitle"];
            model.users_count =[dict[@"users_count"] intValue];
            
            model.address = dict[@"address"];
            model.summary= dict[@"summary"];
            model.latitude = [dict[@"location"][@"latitude"] floatValue];
            model.longitude = [dict[@"location"][@"longitude"] floatValue];
            model.key = str;
            [weakSelf.dataArr addObject:model];
        }
        [weakSelf.tableView reloadData];
        return;
    }
    __weak typeof(self) weakSelf =self;
    [manager GET:commentUrl parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            
                //清空之前的
                [weakSelf.dataArr removeAllObjects];
                
                // 2.什么时候 保存缓存数据 ？？ 下载完成了
                //缓存第一页  直接写入本地磁盘文件
                NSData *data = (NSData *)responseObject;
                //把二进制数据保存到本地
                //把URL 地址作为缓存文件的名字 （内部用MD5 加密）
                //atomically设置为yes 是否考虑安全 （会创建临时文件）防止退出数据丢失
                [data writeToFile:[LZXHelper getFullPathWithFile:commentUrl] atomically:YES];

            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *numDict = dict[@"data"][@"200300"] ;
            
            NSArray *arr = [numDict allKeys];
            for (NSString *str in arr) {
                NSDictionary *dict = numDict[str];
                cityModle *model = [[cityModle alloc] init];
                model.title = dict[@"title"];
                model.subtitle = dict[@"subtitle"];
                model.pic = dict[@"pic_head"][@"pic"];
                model.pretitle = dict[@"pretitle"];
                model.users_count =[dict[@"users_count"] intValue];

                model.address = dict[@"address"];
                model.summary= dict[@"summary"];
                model.latitude = [dict[@"location"][@"latitude"] floatValue];
                model.longitude = [dict[@"location"][@"longitude"] floatValue];
                model.key = str;
                [weakSelf.dataArr addObject:model];
            }
            [weakSelf.tableView reloadData];
            
     
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载 失败");
   
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cityModle *model = self.dataArr[indexPath.row];
    [cell showdataWithModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SCityDetailViewController *scDetailVC = [[SCityDetailViewController alloc] init];
    [self.navigationController pushViewController:scDetailVC animated:YES];
    cityModle *model = self.dataArr[indexPath.row];
    scDetailVC.address =model.address;
    scDetailVC.title = model.title;
    scDetailVC.summary = model.summary;
    scDetailVC.zhanguan = model.pretitle;
    scDetailVC.latitude = model.latitude;
    scDetailVC.longitude = model.longitude;
    
    scDetailVC.pic_top = model.pic_top;
    scDetailVC.key = model.key;
    
}

- (void)rightBarButtonClick:(UIButton *)button{
}

- (void)buttonAction:(UIButton *)button{
}


- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = NO;
 
}
@end
