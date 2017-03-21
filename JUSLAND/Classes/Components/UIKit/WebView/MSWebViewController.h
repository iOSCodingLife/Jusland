//
//  MSWebViewController.h
//  MIS
//
//  Created by LIUZHEN on 2016/12/26.
//  Copyright © 2016年 58.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWebView.h"
#import "MSWebViewProgressView.h"
#import "MSWebViewProgress.h"

@class MSWebViewController;
@protocol MSWebViewControllerDelegate <NSObject>

@required
- (void)webViewControllerLoadRequest:(MSWebView *)webView;

@optional
- (void)webViewControllerDidTapOperate:(MSWebViewController *)webViewController;

@end

@interface MSWebViewController : UIViewController <WKUIDelegate, WKNavigationDelegate, UIWebViewDelegate>

// 是否显示操作按钮，默认NO
@property (nonatomic, assign) BOOL displayOper;

// 是否显示进度条，默认YES
@property (nonatomic, assign) BOOL displayProgress;

// MS Web视图，整合UIWebView 和 WKWebView
@property (nonatomic, weak) MSWebView *webView;

// 进度条视图
@property (nonatomic, strong, readonly) MSWebViewProgressView *progressView;
@property (nonatomic, strong, readonly) MSWebViewProgress *progressProxy;

// WebViewController 代理
@property (nonatomic, weak) id <MSWebViewControllerDelegate> delegate;

// block方式加载请求，设置block后不执行代理的加载回调
@property (nonatomic, copy) void (^webViewLoadRequest)(MSWebView *webView);

- (void)setupNavLeftBar;

@end
