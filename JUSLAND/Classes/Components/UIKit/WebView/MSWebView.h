//
//  MISWebView.h
//  MIS58
//
//  Created by LIUZHEN on 2016/12/27.
//  Copyright © 2016年 58.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface MSWebView : UIView

// iOS 8 或 以上系统为 WKWebView，iOS 8 以下为 UIWebView
@property (nonatomic, weak, readonly) UIView *webView;

// iOS 8 或 以上的系统，走 UIWebViewDelegate 的协议
@property (nonatomic, weak) id <WKNavigationDelegate> navigationDelegate;
@property (nonatomic, weak) id <WKUIDelegate> UIDelegate;

// iOS 8以下系统，走 UIWebViewDelegate 的协议
@property (nonatomic, weak) id <UIWebViewDelegate> delegate;

// 是否拼接MIS 安全参数，默认为YES
@property (nonatomic, assign) BOOL spliceSecurityParams;

// 是否支持手势返回，默认为YES
@property (nonatomic, assign) BOOL allowsBackForwardNavigationGestures;

// 是否跟随屏幕缩放网页，默认为YES
@property (nonatomic, assign) BOOL scalesPageToFit;

// 是否是WKWebView
@property (nonatomic, assign) BOOL isWKWebView;

// 网页标题
@property (nonatomic, copy, readonly) NSString *title;

// 是否能返回
@property (nonatomic, assign, readonly) BOOL canGoBack;

// 是否能转发
@property (nonatomic, assign, readonly) BOOL canGoForward;

// 设置MIS请求安全数据
@property (nonatomic, copy) NSDictionary * (^setRequestMISData)();

// 加载请求
- (void)loadRequest:(NSURLRequest *)request;

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;

// 返回
- (void)goBack;

// 前进
- (void)goForward;

// 重新加载
- (void)reload;

- (void)reloadFromOrigin;

// 停止加载
- (void)stopLoading;

// 执行js脚本
- (void)evaluateJavaScript:(NSString *)javaScriptString
         completionHandler:(void (^)(id obj, NSError * error))completionHandler;

@end
