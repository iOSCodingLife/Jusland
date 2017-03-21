//
//  MSWebViewProgressView.h
// iOS 7 Style WebView Progress Bar
//
//  Created by Satoshi Aasano on 11/16/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSWebViewProgressView : UIView

/**
 *  进度
 */
@property (nonatomic, assign) CGFloat progress;

/**
 *  进度条视图
 */
@property (nonatomic, strong) UIView *progressBarView;

/**
 *  默认 0.1
 */
@property (nonatomic, assign) NSTimeInterval barAnimationDuration;

/**
 *  默认 0.27
 */
@property (nonatomic, assign) NSTimeInterval fadeAnimationDuration;

/**
 *  默认 0.1
 */
@property (nonatomic, assign) NSTimeInterval fadeOutDelay;

/**
 *  进度条色值 默认 [UIColor ms_orangeColor]
 */
@property (nonatomic, strong) UIColor *tintColor;

/**
 *  设置进度
 *
 *  @param progress 当前进度
 *  @param animated 是否显示动画
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
