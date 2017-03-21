//
//  QRCodeReaderAanimationLineView.m
//  MIS
//
//  Created by LIUZHEN on 2017/2/19.
//  Copyright © 2017年 58. All rights reserved.
//

#import "MSQRCodeReaderAanimationLineView.h"

@interface MSQRCodeReaderAanimationLineView ()

@property (nonatomic, assign) NSInteger num;
@property (nonatomic, assign) BOOL down;
@property (nonatomic, assign) NSTimer *timer;
@property (nonatomic, assign) BOOL isAnimationing;
@property (nonatomic, assign) CGRect animationRect;

@end

@implementation MSQRCodeReaderAanimationLineView

- (void)dealloc {
    [self stopAnimating];
}

- (void)startAnimatingWithRect:(CGRect)animationRect inView:(UIView *)parentView image:(UIImage *)image {
    if (_isAnimationing) {
        return;
    }
    
    _isAnimationing = YES;
    _animationRect = animationRect;
    _down = YES;
    _num =0;
    
    CGFloat centery = CGRectGetMinY(animationRect) + CGRectGetHeight(animationRect) / 2;
    CGFloat leftx = animationRect.origin.x + 5;
    CGFloat width = animationRect.size.width - 10;
    
    self.frame = CGRectMake(leftx, centery + 2 * _num, width, 2);
    self.image = image;
    
    [parentView addSubview:self];
    
    [self startAnimating_UIViewAnimation];
    //    [self startAnimating_NSTimer];
}

- (void)startAnimating_NSTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(scanLineAnimation) userInfo:nil repeats:YES];
}

- (void)startAnimating_UIViewAnimation {
    [self stepAnimation];
}

- (void)stepAnimation {
    if (!_isAnimationing) {
        return;
    }
    
    CGFloat leftx = _animationRect.origin.x + 5;
    CGFloat width = _animationRect.size.width - 10;
    
    self.frame = CGRectMake(leftx, _animationRect.origin.y + 8, width, 8);
    self.alpha = 0.0;
    self.hidden = NO;
    
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:3 animations:^{
        CGFloat leftx = _animationRect.origin.x + 5;
        CGFloat width = _animationRect.size.width - 10;
        
        weakSelf.frame = CGRectMake(leftx, _animationRect.origin.y + _animationRect.size.height - 8, width, 4);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [weakSelf performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.3];
    }];
}

- (void)scanLineAnimation {
    CGFloat centery = CGRectGetMinY(_animationRect) + CGRectGetHeight(_animationRect) / 2;
    CGFloat leftx = _animationRect.origin.x + 5;
    CGFloat width = _animationRect.size.width - 10;
    
    if (_down) {
        _num++;
        self.frame = CGRectMake(leftx, centery + 2 * _num, width, 2);
        if (centery+2*_num > (CGRectGetMinY(_animationRect) + CGRectGetHeight(_animationRect) - 5)) {
            _down = NO;
        }
    } else {
        _num--;
        self.frame = CGRectMake(leftx, centery+2*_num, width, 2);
        if (centery+2*_num < (CGRectGetMinY(_animationRect) + 5)) {
            _down = YES;
        }
    }
}

- (void)stopAnimating {
    if (_isAnimationing) {
        _isAnimationing = NO;
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        [self removeFromSuperview];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
