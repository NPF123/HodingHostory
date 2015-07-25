//
//  MySettingViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-4-15.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "MySettingViewController.h"
#import "SDImageCache.h"

@interface MySettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
}

@end

@implementation MySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self dataInit];
    [self creatTableView];
}
- (void)creatTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-49) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)dataInit {
    _dataArr = [[NSMutableArray alloc] init];
    NSArray *arr1 = @[@"设置",@"开启通知",@"开启关注通知",@"清除缓存"];
    [_dataArr addObject:arr1];
    NSArray *arr2 = @[@"推荐",@"官方推荐",@"官方微博",@"版本2.0",@"联系我们:1342125856@qq.com"];
    [_dataArr addObject:arr2];
    
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArr[section]count];
}
#pragma mark - 获取缓存大小
- (double)getCachesSize {
    //换算为M
    //获取SD 字节大小
    double sdSize = [[SDImageCache sharedImageCache] getSize];
    //获取自定义的缓存
     NSString *myCachePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/MyCaches"];
    //遍历 文件夹 得到一个枚举器
    NSDirectoryEnumerator * enumerator = [[NSFileManager defaultManager] enumeratorAtPath:myCachePath];
    double mySize = 0;
    for (NSString *fileName in enumerator) {
        //获取文件的路径
        NSString *filePath = [myCachePath stringByAppendingPathComponent:fileName];
        //文件属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        //统计大小
        mySize += dict.fileSize;
    }
    //1M = 1024k = 1024*1024Byte
    double totalSize = (mySize+sdSize)/1024/1024;//转化为M
    return totalSize;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 1||indexPath.row == 2 ) {
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenSize.width-80, 4, 100, 30)];
            [sw addTarget:self action:@selector(swClick:) forControlEvents:UIControlEventValueChanged];
            sw.tag = indexPath.row+1001;
            //粘贴到cell 的contentView上
            [cell.contentView addSubview:sw];
        }
    }
    cell.textLabel.text = _dataArr[indexPath.section][indexPath.row];
    return cell;
}
//开关按钮
- (void)swClick:(UISwitch *)sw {
    
}

//cell 选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //第0分区
        if (indexPath.row == 3) {
            //清除缓存
            NSString *title = [NSString stringWithFormat:@"删除缓存文件:%.6fM",[self getCachesSize]];
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除"
                otherButtonTitles:nil];
            [sheet showInView:self.view];
            
        }
        
    }else {
        //第1分区
        switch (indexPath.row) {
            case 0://推荐
            {
               [ [UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.todayonhistory.com"]];
            }
                break;
            case 1://官方推荐
            {
                [ [UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.todayonhistory.com"]];
            }
                break;
            case 2://官方微博
            {
                [ [UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.todayonhistory.com"]];
            }
                break;
                
            default:
                break;
        }
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        //删除(两部分 一个是sdWebImage 的一个是我们自己的)
        //删除sd的
        //清除内存中的图片缓存
        [[SDImageCache sharedImageCache] clearMemory];
        //清除磁盘上的图片缓存
        [[SDImageCache sharedImageCache] clearDisk];
        
        //删除自己的缓存文件夹
        NSString *myCachePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/MyCaches"];
        //删除
        [[NSFileManager defaultManager] removeItemAtPath:myCachePath error:nil];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
