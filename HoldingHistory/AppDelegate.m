//
//  AppDelegate.m
//  HoldingHistory
//
//  Created by qianfeng on 15/7/14.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "AppDelegate.h"
#import "SDWebImageManager.h"

#import "MainViewController.h"

#import "DyanmicViewController.h"
#import "SettingsViewController.h"
#import "JDMenuViewController.h"
#import "JDSideMenu.h"

#import "WMPageController.h"

#import "HomePageViewController.h"
#import "LatestViewController.h"
#import "EndSoonViewController.h"
#import "ComingViewController.h"
#import "ExhibitionViewController.h"
#import "NearViewController.h"

#import "UMSocial.h"
#import <MAMapKit/MAMapKit.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)initUM{

    [UMSocialData setAppKey:@"507fcab25270157b37000010"];

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self initUM];
    [self creatControllers];
    //先 注册 appkey
    //d74129b9d7da339c8782f6677aa978dc
    [MAMapServices sharedServices].apiKey = @"3041b65eeb908e384d229fb06dd7f389";
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)creatControllers{
    
    NSMutableArray *arrVC = [NSMutableArray array];
    UITabBarController *tabbar = [[UITabBarController alloc] initWithNibName:@"MainViewController" bundle:nil];
    self.window.rootViewController = tabbar;
    
    NSArray *viewControllers = @[[HomePageViewController class],[LatestViewController class],[EndSoonViewController class],[ComingViewController class],[ExhibitionViewController class],[NearViewController class]];
    NSArray *titles =@[@"首页",@"最近",@"即将结束",@"即将开始",@"展览",@"最近"];
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
   // pageVC.title = @"博物馆";
    pageVC.menuItemWidth = 120;
    pageVC.titleSizeSelected = 20;
    pageVC.pageAnimatable = YES;
    pageVC.menuViewStyle = WMMenuViewStyleLine;
//    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:[[SameCityViewController alloc] init]];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:pageVC];
//    pageVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"chengshi"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClick:)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 44)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    button.frame = CGRectMake(view.center.x-50, 10, 100, 30);
    [view addSubview:button];
    button.backgroundColor = [UIColor clearColor];
    button.layer.cornerRadius= 5;
    [button setTitle:@"博物馆" forState:UIControlStateNormal];
    button.tintColor = [UIColor blackColor];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    pageVC.navigationItem.titleView = view;
    [arrVC addObject:nav2];
    
    
    JDMenuViewController *secMenuVC = [[JDMenuViewController alloc] init];
    self.sideMenu = [[JDSideMenu alloc] initWithContentController:nav2 menuController:secMenuVC];
    
    nav2.tabBarItem = [[UITabBarItem  alloc] initWithTitle:@"首页" image:[UIImage imageNamed: @"city"] tag:101];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"世界" image:[UIImage imageNamed: @"world"] tag:100];
  [arrVC addObject:nav];
    
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:[[DyanmicViewController  alloc] init]];
    nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"交流" image:[UIImage imageNamed: @"person"] tag:102];
   [arrVC addObject:nav3];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] init]];
    nav4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed: @"seting"] tag:103];
   [arrVC addObject:nav4];
    tabbar.viewControllers = arrVC;
    
}

- (void)buttonAction:(UIButton *)button{

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// 收到内存警告
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 停止下载图片
    [[SDWebImageManager sharedManager] cancelAll];
    
    // 清除内存缓存图片
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}


@end
