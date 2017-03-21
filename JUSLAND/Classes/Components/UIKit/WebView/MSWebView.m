//
//  MISWebView.m
//  MIS58
//
//  Created by LIUZHEN on 2016/12/27.
//  Copyright © 2016年 58.com. All rights reserved.
//

#import "MSWebView.h"
#import "MJExtension.h"
#import "MSSecurity.h"
#import "MSServerTimeHelper.h"

#define mis_isWKWebView [self.webView isKindOfClass:NSClassFromString(@"WKWebView")]

@interface MSWebView () <WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate>

@property (nonatomic, weak, readwrite) UIView *webView;

@end

@implementation MSWebView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //        self.spliceSecurityParams = YES;
        self.allowsBackForwardNavigationGestures = YES;
        self.scalesPageToFit = YES;
        [self setupSubviews];
    }
    return self;
}

- (void)dealloc {
    if(mis_isWKWebView) {
        WKWebView *webView = (WKWebView *)self.webView;
        webView.UIDelegate = nil;
        webView.navigationDelegate = nil;
        [webView stopLoading];
        [webView removeFromSuperview];
        webView = nil;
    } else {
        UIWebView *webView = (UIWebView *)self.webView;
        webView.delegate = nil;
        [webView stopLoading];
        [webView removeFromSuperview];
        webView = nil;
    }
}

#pragma mark - Setup subViews

- (void)setupSubviews {
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= MAXFLOAT) { // 8.0f) {
        WKWebView *webView = [[WKWebView alloc] init];
        webView.UIDelegate = self;
        webView.navigationDelegate = self;
        webView.allowsBackForwardNavigationGestures = self.allowsBackForwardNavigationGestures;
        webView.backgroundColor = [UIColor clearColor];
        webView.opaque = NO;
        self.webView = webView;
        [self addSubview:self.webView];
    } else {
        UIWebView *webView = [[UIWebView alloc] init];
        webView.delegate = self;
        webView.backgroundColor = [UIColor clearColor];
        webView.opaque = NO;
        webView.scalesPageToFit = self.scalesPageToFit;
        self.webView = webView;
        [self addSubview:self.webView];
    }
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - Setter

- (void)setSpliceSecurityParams:(BOOL)spliceSecurityParams {
    _spliceSecurityParams = spliceSecurityParams;
}

- (void)setNavigationDelegate:(id <WKNavigationDelegate>)navigationDelegate {
    if (mis_isWKWebView) {
        _navigationDelegate = navigationDelegate;
        WKWebView *webView = (WKWebView *)self.webView;
        webView.navigationDelegate = navigationDelegate;
    }
}

- (void)setUIDelegate:(id <WKUIDelegate>)UIDelegate {
    if (mis_isWKWebView) {
        _UIDelegate = UIDelegate;
        WKWebView *webView = (WKWebView *)self.webView;
        webView.UIDelegate = UIDelegate;
    }
}

- (void)setDelegate:(id <UIWebViewDelegate>)delegate {
    if (!mis_isWKWebView) {
        _delegate = delegate;
        UIWebView *webView = (UIWebView *)self.webView;
        webView.delegate = delegate;
    }
}

- (void)setAllowsBackForwardNavigationGestures:(BOOL)allowsBackForwardNavigationGestures {
    if (mis_isWKWebView) {
        _allowsBackForwardNavigationGestures = allowsBackForwardNavigationGestures;
        WKWebView *webView = (WKWebView *)self.webView;
        webView.allowsBackForwardNavigationGestures = allowsBackForwardNavigationGestures;
    }
}

- (void)setScalesPageToFit:(BOOL)scalesPageToFit {
    if (!mis_isWKWebView) {
        _scalesPageToFit = scalesPageToFit;
        UIWebView *webView = (UIWebView *)self.webView;
        webView.scalesPageToFit = scalesPageToFit;
    }
}

#pragma mark - Public Methods

- (BOOL)isWKWebView {
    return mis_isWKWebView;
}

- (NSString *)title {
    if (mis_isWKWebView) {
        WKWebView *webView = (WKWebView *)self.webView;
        return webView.title;
    } else {
        UIWebView *webView = (UIWebView *)self.webView;
        return [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

- (BOOL)canGoBack {
    if (mis_isWKWebView) {
        WKWebView *webView = (WKWebView *)self.webView;
        return [webView canGoBack];
    } else {
        UIWebView *webView = (UIWebView *)self.webView;
        return [webView canGoBack];
    }
}

- (BOOL)canGoForward {
    if (mis_isWKWebView) {
        WKWebView *webView = (WKWebView *)self.webView;
        return [webView canGoForward];
    } else {
        UIWebView *webView = (UIWebView *)self.webView;
        return [webView canGoForward];
    }
}

- (void)loadRequest:(NSURLRequest *)request {
    if (mis_isWKWebView) {
        WKWebView *webView = (WKWebView *)self.webView;
        if (self.spliceSecurityParams) {
            NSMutableURLRequest *req = request.mutableCopy;
            [self setupSecurityParams:req];
            [webView loadRequest:req];
        } else {
            [webView loadRequest:request];
        }
    } else {
        UIWebView *webView = (UIWebView *)self.webView;
        if (self.spliceSecurityParams) {
            NSMutableURLRequest *req = request.mutableCopy;
            [self setupSecurityParams:req];
            [webView loadRequest:req];
        } else {
            [webView loadRequest:request];
        }
    }
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
    if (mis_isWKWebView) {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView loadHTMLString:string baseURL:baseURL];
    } else {
        UIWebView *webView = (UIWebView *)self.webView;
        [webView loadHTMLString:string baseURL:baseURL];
    }
}

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL {
    if (mis_isWKWebView) {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView loadData:data MIMEType:MIMEType characterEncodingName:textEncodingName baseURL:baseURL];
    } else {
        UIWebView *webView = (UIWebView *)self.webView;
        [webView loadData:data MIMEType:MIMEType textEncodingName:textEncodingName baseURL:baseURL];
    }
}

- (void)goBack {
    if (mis_isWKWebView) {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView goBack];
    } else {
        UIWebView *webView = (UIWebView *)self.webView;
        [webView goBack];
    }
}

- (void)goForward {
    if (mis_isWKWebView) {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView goForward];
    } else {
        UIWebView *webView = (UIWebView *)self.webView;
        [webView goForward];
    }
}

- (void)reload {
    if (mis_isWKWebView) {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView reload];
    } else {
        UIWebView *webView = (UIWebView *)self.webView;
        [webView reload];
    }
}

- (void)reloadFromOrigin {
    if (mis_isWKWebView) {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView reloadFromOrigin];
    } else {
        UIWebView *webView = (UIWebView *)self.webView;
        NSString *requestUrl = webView.request.URL.absoluteString;
        [self evaluateJavaScript:[NSString stringWithFormat:@"window.location.replace('%@')", requestUrl]
               completionHandler:nil];
    }
}

- (void)stopLoading {
    if (mis_isWKWebView) {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView stopLoading];
    } else {
        UIWebView *webView = (UIWebView *)self.webView;
        [webView stopLoading];
    }
}

- (void)evaluateJavaScript:(NSString *)javaScriptString
         completionHandler:(void (^)(id obj, NSError *))completionHandler {
    if(mis_isWKWebView) {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
    } else {
        UIWebView *webView = (UIWebView *)self.webView;
        NSString *result = [webView stringByEvaluatingJavaScriptFromString:javaScriptString];
        if(completionHandler) {
            completionHandler(result, nil);
        }
    }
}

#pragma mark - Private

- (void)setupSecurityParams:(NSMutableURLRequest *)request {
//    NSInteger length = 5;
//    char data[length];
//    for (int x = 0; x < length; data[x++] = (char)('A' + (arc4random_uniform(26))));
//    
//    NSString *random = [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
//    NSString *account = [MISLoginManager sharedManager].loginData.userName;
//    NSString *token = [MISLoginManager sharedManager].loginData.token;
//    NSString *serverTimeInterval = [NSString stringWithFormat:@"%.0f", [MSServerTimeHelper serverTimeInterval]];
//    NSString *url = request.URL.absoluteString;
//    
//    NSMutableDictionary *misKey = [NSMutableDictionary dictionary];
//    [misKey setObject:random ?: @"" forKey:@"rand"];
//    [misKey setObject:serverTimeInterval ?: @"" forKey:@"time"];
//    [misKey setObject:url ?: @"" forKey:@"url"];
//    [misKey setObject:token ?: @"" forKey:@"token"];
//    NSString *misKeyJSON = [misKey mj_JSONString];
//    NSString *aesMisKeyJSON = [MSSecurity aes_encrypt:misKeyJSON];
//    aesMisKeyJSON = [self urlEncode:aesMisKeyJSON];
//    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:@"mobile" forKey:@"clientType"];
//    [params setObject:aesMisKeyJSON ?: @"" forKey:@"msKey"];
//    [params setObject:@"" forKey:@"msData"];
//    [params setObject:account forKey:@"account"]; // 外部使用MIS 账号参数
//    account = [account stringByAppendingString:@"_old"]; // 新版美事需要删除此行
//    [params setObject:account ?: @"" forKey:@"userName"]; // MIS 内部使用账号参数
//    
//    // 设置请求扩展数据，aes加密。H5接入方，需要调用后台参数解密
//    if (self.setRequestMISData) {
//        NSDictionary *misData = self.setRequestMISData();
//        NSLog(@"传进来的字典%@",misData);
//        NSString *misDataJSON = [misData mj_JSONString];
//        NSString *aesMisDataJSON = [MSSecurity aes_encrypt:misDataJSON];
//        aesMisDataJSON = [self urlEncode:aesMisDataJSON];
//        [params setObject:aesMisDataJSON ?: @"" forKey:@"msData"];
//    }
//    
//    NSMutableString *paramsString = [[NSMutableString alloc] init];
//    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        if (paramsString.length == 0) {
//            NSString *param = [NSString stringWithFormat:@"%@=%@", key, obj];
//            [paramsString appendString:param];
//        } else {
//            NSString *param = [NSString stringWithFormat:@"&%@=%@", key, obj];
//            [paramsString appendString:param];
//        }
//    }];
//    
//    // 若有POST参数、拼接原有POST请求参数
//    if (request.HTTPBody && request.HTTPBody.length > 0) {
//        NSString *postParams = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
//        [paramsString appendString:[NSString stringWithFormat:@"&%@", postParams]];
//    }
//    NSData *postBody = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postBody];
}

- (NSString *)urlEncode:(NSString *)input {
    NSString *output = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                              (CFStringRef)input,
                                                                                              NULL,
                                                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                                              kCFStringEncodingUTF8));
    return output;
}

@end
