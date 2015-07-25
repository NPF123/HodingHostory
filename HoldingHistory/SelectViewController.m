//
//  SelectViewController.m
//  HoldingHistory
//
//  Created by qianfeng on 15/7/15.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "SelectViewController.h"
#import "searchModel.h"
#import "SearchCell.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#import "EveryCityViewController.h"

#define kScreenSize [UIScreen mainScreen].bounds.size
@interface SelectViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic)NSMutableArray *dataArr;
@property (nonatomic)UITableView *tableView;
@property (nonatomic)AFHTTPRequestOperationManager *manager;
@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.title = @"城市列表";
    [self loadData];
    [self creatTableView];
}
- (void)creatTableView{
    
    self.dataArr = [[NSMutableArray alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-49-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //隐藏 分割线
    // [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //设置分割线的颜色
    [self.tableView setSeparatorColor:[UIColor whiteColor]];
    //_tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"SearchCell"];
    //取消半透明的导航条/tabBar对滚动视图的影响
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    
}
- (void)loadData{
    self.manager= [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url =@"http://icity.2q10.com/api/v1/imsm/cities?select=1&longitude=121.5419348695&latitude=38.8849034142";
    [self.manager GET:url parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject){
        if (responseObject) {
            NSDictionary  *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *dataDict = dict[@"data"];
            NSString *str = [[dataDict allKeys] firstObject];
            
            NSDictionary *numDict = dataDict[str];
           
            NSArray *arr = [numDict allKeys];
         
            for (NSString *city in arr) {
                NSDictionary *dictCity = numDict[city];
              
                searchModel *model = [[searchModel alloc] init];
//                model.title = dictCity[@"title"];
//                model.subtitle = dictCity[@"subtitle"];
//                model.pic_icon = dictCity[@"pic_icon"];
//                model.count = [dictCity[@"count"] integerValue];
//                model.title_count = dictCity[@"title_count"];
                [model setValuesForKeysWithDictionary:dictCity];
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
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
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SearchCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"beijing"]];
    searchModel *model = self.dataArr[indexPath.row];
    [cell showDataWithSearchModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EveryCityViewController *cityVC= [[EveryCityViewController alloc] init];
    searchModel *model = self.dataArr[indexPath.row];
    cityVC.cityName =model.subtitle;

    [self.navigationController pushViewController:cityVC animated:YES];
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.frame = CGRectMake(-320, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    [UIView animateWithDuration:0.7 animations:^{
        cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    } completion:^(BOOL finished) {
        ;
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = NO;
}
@end
