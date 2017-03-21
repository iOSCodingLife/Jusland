//
//  MSWebViewProgressView.m
//
//  Created by Satoshi Aasanoon 11/16/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import "MSWebViewProgressView.h"

@implementation MSWebViewProgressView

#pragma mark - Life cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfigure];
        [self setupSubviews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubviews];
}

- (void)setupConfigure {
    _tintColor = [UIColor ms_orangeColor];
    _barAnimationDuration = 0.27f;
    _fadeAnimationDuration = 0.27f;
    _fadeOutDelay = 0.1f;
}

#pragma mark - Setup subViews

- (void)setupSubviews {
    self.userInteractionEnabled = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIView *progressBarView = [[UIView alloc] initWithFrame:self.bounds];
    progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    progressBarView.backgroundColor = self.tintColor;
    self.progressBarView = progressBarView;
    [self addSubview:progressBarView];
    self.progress = 0.0f;
}

#pragma mark - Setter

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    BOOL isGrowing = progress > 0.0f;
    [UIView animateWithDuration:(isGrowing && animated) ? _barAnimationDuration : 0.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = _progressBarView.frame;
                         frame.size.width = progress * self.bounds.size.width;
                         _progressBarView.frame = frame;
                     }
                     completion:nil];
    
    if (progress >= 1.0) {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0f
                              delay:_fadeOutDelay
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _progressBarView.alpha = 0.0f;
                         }
                         completion:^(BOOL completed) {
                             CGRect frame = _progressBarView.frame;
                             frame.size.width = 0.0f;
                             _progressBarView.frame = frame;
                         }];
    } else {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _progressBarView.alpha = 1.0f;
                         }
                         completion:nil];
    }
}

@end
