//
//  DyanmicViewController.m
//  HoldingHistory
//
//  Created by qianfeng on 15/7/14.
//  Copyright (c) 2015年 牛鹏飞. All rights reserved.
//

#import "DyanmicViewController.h"
#import "AFNetworking.h"


@interface DyanmicViewController ()<UIScrollViewDelegate, UIWebViewDelegate>

@end

@implementation DyanmicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // self.navigationController 设置
    [self.navigationController.navigationBar setBarTintColor:[UIColor groupTableViewBackgroundColor]];
    
    UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    iamgeView.image =[UIImage imageNamed: @"lishi.png"];
    [self.view addSubview:iamgeView];
    
    // 导航栏是否占用位置
    //self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationItem.title = @"微博墙";

    // UIWebView设置
    UIWebView *weiboWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height + 250)];
    weiboWebView.tag = 106;
    NSURL *weiboURL  = [NSURL URLWithString:@"http://s.weibo.com/weibo/%25E5%258D%259A%25E7%2589%25A9%25E9%25A6%2586&Refer=index"];
    NSURLRequest *weiboRequest = [[NSURLRequest alloc] initWithURL:weiboURL];
    [weiboWebView loadRequest:weiboRequest];
    [weiboWebView setUserInteractionEnabled:YES];
    [self.view addSubview:weiboWebView];
    [weiboWebView goBack];
    [weiboWebView goForward];
    [weiboWebView reload];
    weiboWebView.delegate = self;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //创建UIActivityIndicatorView背底半透明View
    
    //    UIWebView *weiboWebView = (UIWebView *)[self.view viewWithTag:106];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view setAlpha:0.4];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kScreenSize.width/2-16,kScreenSize.height/2-16, 32, 32)];
    activityIndicator.tag = 107;
    [activityIndicator setCenter:view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:activityIndicator];
    
    [activityIndicator startAnimating];

}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self.view viewWithTag:107];
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];

    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];

    
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[self.view viewWithTag:107];
    [activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    [activityIndicator removeFromSuperview];
}



@end
