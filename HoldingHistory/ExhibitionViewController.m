//
//  ExhibitionViewController.m
//  HoldingHistory
//
//  Created by qianfeng on 15/7/19.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "ExhibitionViewController.h"

@interface ExhibitionViewController ()

@end

@implementation ExhibitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *urlpath = [NSString stringWithFormat:@"http://icity.2q10.com/api/v1/imsm/events?city=%@", self.dataUrlArr[4]];
    [self loadDataMessageWithUrl:urlpath];
    //[self creatTableView];

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

@end
