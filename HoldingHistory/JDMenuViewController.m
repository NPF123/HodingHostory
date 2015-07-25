//
//  JDMenuViewController.m
//  HoldingHistory
//
//  Created by qianfeng on 15/7/15.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "JDMenuViewController.h"

@interface JDMenuViewController ()

@end

@implementation JDMenuViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.arrimage = @[@"1.png", @"2.png", @"3.png", @"4.png", @"5.png", @"6.png"];
        
        self.arrurl = @[@"beijing", @"beijing&order=latest", @"beijing&order=end_soon", @"beijing&order=coming", @"beijing&category=exhibition", @"fj"];
        
        self.arr = @[@"首页", @"最新", @"即将结束", @"即将开始", @"展览", @"附近"];
        
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor groupTableViewBackgroundColor];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(30, 100, 150, 300) style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(240, 10, 0, 0)];
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchView];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr.count;
}


#pragma mark ---   给cell赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = @"resure";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:[self.arrimage objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self.arr objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    return cell;
}


#pragma mark --- 点击cell后走得路径
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(void)switchAction:(UISwitch *)swi
{
    if (swi.on == YES) {
        //        self.NightLabel.hidden = NO;
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"夜间模式" object:@"0.3"];
    }
    else
    {
        //        self.NightLabel.hidden = YES;
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"夜间模式" object:@"0.0"];
    }
}



@end
