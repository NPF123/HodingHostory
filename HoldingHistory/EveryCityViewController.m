//
//  EveryCityViewController.m
//  HoldingHistory
//
//  Created by qianfeng on 15/7/21.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "EveryCityViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#import "ECModel.h"
#import "ECCell.h"

#import "SCityDetailViewController.h"
@interface EveryCityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    AFHTTPRequestOperationManager *_manager;
    UITableView *_tableView;
    NSMutableArray *_dataArr;
}
@property (nonatomic)AFHTTPRequestOperationManager *manager;
@property (nonatomic)UITableView *tableView;
@property (nonatomic)NSMutableArray *dataArr;
@end

@implementation EveryCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray array];
    [self creatTableView];
    [self loadEveryCityData];
}

- (void)creatTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
    _tableView.rowHeight = 100;
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = [UIColor whiteColor];
    [_tableView registerNib:[UINib nibWithNibName:@"ECCell" bundle:nil] forCellReuseIdentifier:@"ECCell"];
    [self.view addSubview:_tableView];
}

- (void)loadEveryCityData{
    if ([self.cityName isEqualToString:@"New York"]) {
        self.cityName = @"NewYork";
    }
    if ([self.cityName isEqualToString:@"Kyoto·Nara"]) {
        self.cityName = @"KyotoNara";
    }
    if ([self.cityName isEqualToString:@"Hong Kong"]) {
        self.cityName = @"HongKong";
    }
    NSString *url = [NSString stringWithFormat:kCityUrl,self.cityName];
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __weak typeof(self) weakSelf = self;
    [_manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *numDict = dict[@"data"][@"200300"];
            NSArray *arr = [numDict allKeys];
            for (NSString *str in arr) {
                NSDictionary *dict = numDict[str];
                ECModel *model = [[ECModel alloc] init];
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
        NSLog(@"下载失败");
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ECCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor brownColor];
    ECModel *model = self.dataArr[indexPath.row];
    [cell showdataWithModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SCityDetailViewController *scDetailVC = [[SCityDetailViewController alloc] init];
    ECModel *model = self.dataArr[indexPath.row];
    scDetailVC.address =model.address;
    scDetailVC.title = model.title;
    scDetailVC.summary = model.summary;
    scDetailVC.zhanguan = model.pretitle;
    scDetailVC.latitude = model.latitude;
    scDetailVC.longitude = model.longitude;
    scDetailVC.pic_top = model.pic_top;
    scDetailVC.key = model.key;
    [self.navigationController pushViewController:scDetailVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

@end
