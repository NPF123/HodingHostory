//
//  MainViewController.m
//  HoldingHistory
//
//  Created by qianfeng on 15/7/14.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "MainViewController.h"
#import "WorldDetailViewController.h"
#import "SelectViewController.h"
#import "AFNetworking.h"
#import "worldModel.h"
#import "WorldCell.h"
#import "JHRefresh.h"
#import "MMProgressHUD.h"
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isRefreshing;
    BOOL _isLoadMore;
}
@property(nonatomic)BOOL isRefreshing;
@property(nonatomic)BOOL isLoadMore;
@property (nonatomic)UITableView *tableView;
@property (nonatomic)NSMutableArray *dataArr;
@property (nonatomic)AFHTTPRequestOperationManager *manager;
@property (nonatomic)NSInteger currentPage;
@property (nonatomic)NSArray *keyArr;
@property (nonatomic)NSArray *keyArr2;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"good"] style:UIBarButtonItemStylePlain target:self action:@selector(btnClick:)];
    self.navigationItem.title = @"世界";
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
    
    [self firstLoadData];
    [self createRefreshView];
    [self creatTableView];
}



- (void)creatTableView{
  
    self.dataArr = [[NSMutableArray alloc] init];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-49-64) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellAccessoryNone;
        //_tableView.separatorColor = [UIColor lightGrayColor];
        [self.view addSubview:self.tableView];
        [self.tableView registerNib:[UINib nibWithNibName:@"WorldCell" bundle:nil] forCellReuseIdentifier:@"WorldCell"];
    [self.tableView reloadData];
    //取消半透明的导航条/tabBar对滚动视图的影响
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark- 子类可以重写
//刷新子类调用
-(void)createRefreshView{
    //block 就需要注意 防止发生死锁  tableview 对 block 强引用 block又对self 强引用 相当于 tableview对self强引用 ，同时tableview作为self的成员变量，self对tableview 是强引用 。两个强引用，就会引起死锁。
    //只用出现了循环引用 必须一强一弱
    //arc 用 __weak   mrc __block
    
    //下拉刷新
    __weak typeof (self) weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //重新下载数据
        if (weakSelf.isRefreshing) {
            return ;
        }
        weakSelf.isRefreshing = YES;//标志正在刷新
        weakSelf.currentPage = 1;
        NSString *url = nil;
        //因为热榜接口和其他接口不一样，所以要判断一下
        url = [NSString stringWithFormat:kMainUrl,(long)weakSelf.currentPage];
        [weakSelf loadDataWithUrl:url isRefresh:YES];
    }];
    //上拉加载更多
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //重新下载数据
        if (weakSelf.isLoadMore) {
            return ;
        }
        weakSelf.isLoadMore= YES;//标志正在刷新
        weakSelf.currentPage ++;
        NSString *url = nil;
        //因为热榜接口和其他接口不一样，所以要判断一下
        url = [NSString stringWithFormat:kMainUrl,weakSelf.currentPage];
        [weakSelf loadDataWithUrl:url isRefresh:YES];
    }];
}

//
////创建 刷新视图
//- (void)createRefreshView{
//
//    __weak typeof (self)weakSelf = self;
//    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
//       //重新 下载数据
//        if (weakSelf.isRefreshing) {
//            return ;
//        }
//        double delayInSeconds = 2.0;
//    
//        dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    
//        //延期 执行
//        dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^{
//            weakSelf.isRefreshing = YES;
//            weakSelf.currentPage = 1;
//            NSString *url = nil;
//            url = [NSString stringWithFormat:kMainUrl,(long)weakSelf.currentPage];
//            [weakSelf loadDataWithUrl:url isRefresh:YES];
//        });
//       
//    }];
//    
//    //上拉 加载 更多
//    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
//       
//        if (weakSelf.isLoadMore) {
//            return ;
//        }
//        //延时隐藏refreshView;
//        double delayInSeconds = 2.0;
//        //创建延期的时间 2S
//        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        //延期执行
//        dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^{
//            weakSelf.isLoadMore = YES;
//            weakSelf.currentPage +=1;
//            NSString *url = nil;
//            url = [NSString stringWithFormat:kMainUrl,weakSelf.currentPage];
//            [weakSelf loadDataWithUrl:url isRefresh:YES];
//        });
//        
//    }];
//}

- (void)endRefreshing{

    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.tableView footerEndRefreshing];
    }
}
- (void)firstLoadData{
    self.currentPage = 1;
    NSString *url ;
    url = [NSString stringWithFormat:kMainUrl,self.currentPage];
    [self loadDataWithUrl:url isRefresh:NO];
    
}
- (void)loadDataWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh{
//    //设置下载特效
//    //设置 风格
//    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
//    //设置特效标题
//    [MMProgressHUD showWithTitle:@"欢迎下载"  status:@"loading..."];
    self.manager= [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSString *path = [LZXHelper getFullPathWithFile:url];
    BOOL isExist =[[NSFileManager defaultManager] fileExistsAtPath:path];
    //是否超时 一天
    BOOL isTimeOut = [LZXHelper isTimeOutWithFile:url timeOut:24*60*60];
    if ((isRefresh ==NO)&&(isExist == YES)&&(isTimeOut == NO)) {
        //同时成立  走本地缓存数据
        NSData *data = [NSData dataWithContentsOfFile:[LZXHelper getFullPathWithFile:url]];
        //解析二进制数据
        
        [self.dataArr removeAllObjects];
        __weak typeof(self) weakSelf =self;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *dataDict = dict[@"data"];
        
        NSArray *arr = @[@"200900",@"200300"];
        for (NSInteger i =0; i<arr.count-1; i++) {
            NSDictionary *numDict = dataDict[arr[i]];
            _keyArr = [[NSArray alloc] init];
            _keyArr = [numDict allKeys];
            for (NSString *str  in _keyArr) {
                NSDictionary *dict = numDict[str];
                worldModel *model = [[worldModel alloc] init];
                model.title = dict[@"title"];
                model.subtitle = dict[@"subtitle"];
                model.pic = (dict[@"pic_cover"])[@"pic"];
                model.pretitle = dict[@"pretitle"];
                [self.dataArr addObject:model];
            }
        }
        for (NSInteger i=1; i<arr.count; i++) {
            NSDictionary *numDict = dataDict[arr[i]];
            _keyArr2 = [[NSArray alloc] init];
            _keyArr2 = [numDict allKeys];
            for (NSString *str  in _keyArr2) {
                NSDictionary *dict = numDict[str];
                worldModel *model = [[worldModel alloc] init];
                model.title =dict[@"title"];
                model.subtitle = dict[@"subtitle"];
                model.pic = dict[@"pic_cover"];
                model.pretitle = dict[@"pretitle"];
                [self.dataArr addObject:model];
            }
        }
        [weakSelf.tableView reloadData];
//        //关闭特效
//        [MMProgressHUD dismissWithSuccess:@"成功" title:@"本地数据下载完成"];
        return;
    }

    __weak typeof(self) weakself = self;
    [self.manager GET:url parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (weakself.currentPage ==1) {
                [weakself.dataArr removeAllObjects];
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *dataDict = dict[@"data"];
            
            NSArray *arr = @[@"200900",@"200300"];
            for (NSInteger i =0; i<arr.count-1; i++) {
                NSDictionary *numDict = dataDict[arr[i]];
               _keyArr = [[NSArray alloc] init];
                _keyArr = [numDict allKeys];
                for (NSString *str  in _keyArr) {
                    NSDictionary *dict = numDict[str];
                    worldModel *model = [[worldModel alloc] init];
                    model.title = dict[@"title"];
                    model.subtitle = dict[@"subtitle"];
                    model.pic = (dict[@"pic_cover"])[@"pic"];
                    model.pretitle = dict[@"pretitle"];
                    [self.dataArr addObject:model];
                }
            }
            for (NSInteger i=1; i<arr.count; i++) {
                NSDictionary *numDict = dataDict[arr[i]];
                _keyArr2 = [[NSArray alloc] init];
                _keyArr2 = [numDict allKeys];
                for (NSString *str  in _keyArr2) {
                    NSDictionary *dict = numDict[str];
                    worldModel *model = [[worldModel alloc] init];
                    model.title =dict[@"title"];
                    model.subtitle = dict[@"subtitle"];
                    model.pic = dict[@"pic_cover"];
                    model.pretitle = dict[@"pretitle"];
                    [self.dataArr addObject:model];
                }
            }
            [weakself.tableView reloadData];
            //下载失败也要关闭
//            //关闭下载特效
//            [MMProgressHUD dismissWithSuccess:@"成功" title:@"网络数据下载成功"];
            [weakself endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakself endRefreshing];
//        //下载失败也要关闭
//        [MMProgressHUD dismissWithError:@"失败" title:@"网络出现异常"];
        NSLog(@"下载失败");
    }];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    //[self setHidesBottomBarWhenPushed:YES];
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
    UIImageView *iamgeView = [[UIImageView alloc] init];
    iamgeView.image =[UIImage imageNamed: @"lishi.png"];
    [self.view addSubview:iamgeView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorldCell" forIndexPath:indexPath];
    worldModel *model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 120;
}
//选中cell的时候 调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WorldDetailViewController *worldDetailVC = [[WorldDetailViewController alloc] init];
    worldDetailVC.catagere = self.keyArr[indexPath.row];
    [self.navigationController pushViewController:worldDetailVC animated:YES];
    
}
- (void)btnClick:(UIButton *)button{
    SelectViewController *SelectVC = [[SelectViewController alloc] init];
    
    [self.navigationController pushViewController:SelectVC animated:YES];
}



@end
