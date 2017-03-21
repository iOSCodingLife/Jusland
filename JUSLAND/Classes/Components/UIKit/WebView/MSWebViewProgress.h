//
//  MSWebViewProgress.h
//
//  Created by Satoshi Aasano on 4/20/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern CGFloat const MSInitialProgressValue;
extern CGFloat const MSInteractiveProgressValue;
extern CGFloat const MSFinalProgressValue;

typedef void (^MSWebViewProgressBlock)(CGFloat progress);

@class MSWebViewProgress;

@protocol MSWebViewProgressDelegate <NSObject>

- (void)webViewProgress:(MSWebViewProgress *)webViewProgress updateProgress:(float)progress;

@end

@interface MSWebViewProgress : NSObject <UIWebViewDelegate>

/**
 *  进度条代理
 */
@property (nonatomic, weak) id <MSWebViewProgressDelegate> progressDelegate;

/**
 *  UIWebView 代理
 */
@property (nonatomic, weak) id <UIWebViewDelegate> webViewProxyDelegate;

/**
 *  设置进度回调
 */
@property (nonatomic, copy) MSWebViewProgressBlock progressBlock;

/**
 *  当前进度
 */
@property (nonatomic, readonly) CGFloat progress; // 0.0..1.0

/**
 *  进度条状态重置
 */
- (void)reset;

@end
