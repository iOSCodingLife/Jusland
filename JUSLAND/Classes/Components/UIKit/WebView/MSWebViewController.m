//
//  MSWebViewController.m
//  MIS
//
//  Created by LIUZHEN on 2016/12/26.
//  Copyright © 2016年 58.com. All rights reserved.
//

#import "MSWebViewController.h"

@interface MSWebViewController () <MSWebViewProgressDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *closeItems;
@property (nonatomic, strong) MSWebViewProgressView *progressView;
@property (nonatomic, strong) MSWebViewProgress *progressProxy;
@property (nonatomic, assign) BOOL didMakePostRequest;

@end

@implementation MSWebViewController

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _displayOper = NO;
        _displayProgress = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavbar];
    [self setupSubviews];
    [self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
    [_progressView removeFromSuperview];
}

- (void)dealloc {
    if (self.webView.isWKWebView) {
        [self.webView.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

#pragma mark - Setup navbar

- (void)setupNavbar {
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImageName:@"Common_Back_Gray02"
                                                     highImageName:nil
                                                            target:self action:@selector(didTapBack:)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    if (_displayOper) {
        UIBarButtonItem *operItem = [UIBarButtonItem itemWithImageName:@"Navigationbar_More"
                                                         highImageName:nil
                                                                target:self action:@selector(didTapOper:)];
        self.navigationItem.rightBarButtonItem = operItem;
    }
}

- (void)setupNavLeftBar {
    NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithObject:self.navigationItem.leftBarButtonItem];
    if ([self.webView canGoBack]) {
        [leftBarButtonItems addObjectsFromArray:self.closeItems];
    }
    self.navigationItem.leftBarButtonItems = leftBarButtonItems;
}

#pragma mark - Setup subViews

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4"];
    
    MSWebView *webView = [[MSWebView alloc] init];
    webView.spliceSecurityParams = YES;
    if (webView.isWKWebView) {
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        [webView.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        // 解决WKWebView POST请求丢失参数的问题
        NSString *path = [[NSBundle mainBundle] pathForResource:@"POSTRequestJS" ofType:@"html"];
        NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
    } else {
        if (self.displayProgress) {
            _progressProxy = [[MSWebViewProgress alloc] init];
            _progressProxy.webViewProxyDelegate = self;
            _progressProxy.progressDelegate = self;
            webView.delegate = _progressProxy;
        } else {
            webView.delegate = self;
        }
    }
    
    if (self.displayProgress) {
        CGFloat height = 2.0f;
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        CGRect progressBarFrame = CGRectMake(0, navigationBar.ms_height - height, navigationBar.ms_width, height);
        _progressView = [[MSWebViewProgressView alloc] initWithFrame:progressBarFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    
    self.webView = webView;
    [self.view addSubview:webView];
    
    if (self.webViewLoadRequest) {
        self.webViewLoadRequest(webView);
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(webViewControllerLoadRequest:)]) {
        [self.delegate webViewControllerLoadRequest:webView];
    }
}

- (void)setupConstraints {
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - observe

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (self.webView.isWKWebView) {
            WKWebView *webView = (WKWebView *)self.webView.webView;
            self.progressView.progress = webView.estimatedProgress;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (!_didMakePostRequest) {
        [self makePostRequest];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        if (self.webView.spliceSecurityParams) { // 需要拼接安全参数
            NSString *result = [[NSString alloc] initWithData:navigationAction.request.HTTPBody encoding:NSUTF8StringEncoding];
            if ([result containsString:@"msKey="]) { // 已经拼接过安全参数，直接请求
                decisionHandler(WKNavigationActionPolicyAllow);
            } else { // 未拼接过安全参数、拼接安全参数重新请求
                decisionHandler(WKNavigationActionPolicyCancel);
                [self.webView loadRequest:navigationAction.request];
            }
        } else {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.title = self.webView.title;
    [self setupNavLeftBar];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error.code != 102 && error.code != -999) {
        [MSHUDManager showToast:error.localizedDescription inView:self.view];
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL security = YES;
    if (self.webView.spliceSecurityParams) { // 需要拼接安全参数
        NSString *result = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        if ([result containsString:@"msKey="]) {
            security = YES;
        } else {
            [self.webView loadRequest:request];
            security = NO;
        }
    }
    return security;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = self.webView.title;
    [self setupNavLeftBar];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error.code != 102 && error.code != -999) {
        [MSHUDManager showToast:error.localizedDescription inView:self.view];
    }
}

#pragma mark - NJKWebViewProgressDelegate

- (void)webViewProgress:(MSWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
    self.title = self.webView.title;
}

#pragma mark - Action

- (void)didTapBack:(UIButton *)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didTapClose:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didTapOper:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewControllerDidTapOperate:)]) {
        [self.delegate webViewControllerDidTapOperate:self];
    }
}

// 解决WKWebView POST请求丢失参数的问题
- (void)makePostRequest {
    NSString *postData = [NSString stringWithFormat: @"account=%@&password=%@", @"ms", @"ms123"];
    NSString *urlString = @"http://ms.com/post";
    NSString *jscript = [NSString stringWithFormat:@"MS_POST('%@', {%@});", urlString, postData];
    [self.webView evaluateJavaScript:jscript completionHandler:^(id obj, NSError *error) {
        NSLog(@"%@ \n%@::完成...", obj, error);
    }];
    _didMakePostRequest = YES;
}

#pragma mark - Getter

- (NSArray *)closeItems {
    if (_closeItems == nil) {
        UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                target:nil action:nil];
        spacer.width = 30;
        
        UIBarButtonItem *closeItem = [UIBarButtonItem itemWithImageName:@"Common_Close_Gray"
                                                          highImageName:nil
                                                                 target:self action:@selector(didTapClose:)];
        _closeItems = @[spacer, closeItem];
    }
    return _closeItems;
}

@end
