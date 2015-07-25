//
//  MyCommentViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-4-15.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "MyCommentViewController.h"

@interface MyCommentViewController ()<UIWebViewDelegate>
@property (nonatomic,weak)UIWebView *webView;
@property (nonatomic,weak)UIActivityIndicatorView *indicator;
@end

@implementation MyCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *str = @"http://www.todayonhistory.com";

    // 添加webview
    [self setupWebview];
    // 添加UIActivityIndicatorView
    [self setupActivityIndicator];
    [self loadWebViewUrl:str];
    
}


- (void)Canccel{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setupWebview{
    
    UIWebView *webView= [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    self.webView = webView;
    self.webView.delegate = self;
    [self.view addSubview:webView];
}
- (void)loadWebViewUrl:(NSString *)strUrl{
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - 遵守协议的方法
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [self.indicator startAnimating];
    self.indicator.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;
    
}

- (void)setupActivityIndicator
{
    //初始化:
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    //设置显示样式,见UIActivityIndicatorViewStyle的定义
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    //设置显示位置
    [indicator setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    
    //设置背景色
    indicator.backgroundColor = [UIColor grayColor];
    
    //设置背景透明
    indicator.alpha = 0.5;
    
    //设置背景为圆角矩形
    indicator.layer.cornerRadius = 6;
    indicator.layer.masksToBounds = YES;
    
    [self.view addSubview:indicator];
    self.indicator = indicator;
    self.indicator.hidden = YES;
}

- (void)dealloc
{
    // 释放webview内存
    [self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView stopLoading];
    self.webView.delegate = nil;
    [self.webView removeFromSuperview];
    self.webView = nil;
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
}
@end
