//
//  MSQRCodeScanView.m
//  MIS
//
//  Created by LIUZHEN on 2017/2/18.
//  Copyright © 2017年 58. All rights reserved.
//

#import "MSQRCodeReaderMaskView.h"
#import "MSQRCodeReaderAanimationLineView.h"

@interface MSQRCodeReaderMaskView ()

// 扫码区域
@property (nonatomic, assign) CGRect scanRetangleRect;

// 线条扫码动画封装
@property (nonatomic, strong) MSQRCodeReaderAanimationLineView *scanAnimation;

// 线条在中间位置，不移动
@property (nonatomic, strong) UIImageView *scanLineStill;

@property (nonatomic, weak) UILabel *promptLabel;

@end

@implementation MSQRCodeReaderMaskView

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self setupSubviews];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.needDrawRetangle = YES;
    self.whRatio = 1.0;
    self.centerUpOffset = 44;
    self.xScanRetangleOffset = 80;
    self.colorRetangleLine = [UIColor whiteColor];
    self.notRecoginitonAreaColor = [UIColor colorWithHexString:@"#000000" colorAlpha:0.5f];
    
    self.colorAngle = [UIColor ms_orangeColor];
    self.anmiationStyle = MSRQCodeScanViewAnimationStyleLineMove;
    self.photoframeAngleW = 24;
    self.photoframeAngleH = 24;
    self.photoframeLineW = 2;
    
    self.photoframeAngleStyle = MSRQCodeScanViewPhotoframeAngleStyleOn;
    self.animationImage = [UIImage imageNamed:@"MSQRCode_Scan_Light"];
}

- (void)setupSubviews {
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.text = @"放入框内，即可自动扫描";
    promptLabel.textColor = [UIColor whiteColor];
    promptLabel.font = [UIFont ms_smallFont];
    [promptLabel sizeToFit];
    self.promptLabel = promptLabel;
    
    [self addSubview:promptLabel];
}

#pragma mark - Animation

/**
 *  开始扫描动画
 */
- (void)startScanningAnimation {
    switch (self.anmiationStyle) {
        case MSRQCodeScanViewAnimationStyleLineMove: {
            //线动画
            if (!_scanAnimation)
                _scanAnimation = [[MSQRCodeReaderAanimationLineView alloc] init];
            [_scanAnimation startAnimatingWithRect:_scanRetangleRect inView:self image:self.animationImage];
        }
            break;
        case MSRQCodeScanViewAnimationStyleLineStill: {
            if (!_scanLineStill) {
                CGRect stillRect = CGRectMake(_scanRetangleRect.origin.x + 20,
                                              _scanRetangleRect.origin.y + _scanRetangleRect.size.height / 2,
                                              _scanRetangleRect.size.width - 40,
                                              2);
                _scanLineStill = [[UIImageView alloc] initWithFrame:stillRect];
                _scanLineStill.image = self.animationImage;
            }
            [self addSubview:_scanLineStill];
        }
        default:
            break;
    }
}

/**
 *  结束扫描动画
 */
- (void)stopScanningAnimation {
    if (_scanAnimation) {
        [_scanAnimation stopAnimating];
    }
    
    if (_scanLineStill) {
        [_scanLineStill removeFromSuperview];
    }
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawScanRect];
}

- (void)drawScanRect {
    int XRetangleLeft = self.xScanRetangleOffset;
    CGSize sizeRetangle = CGSizeMake(self.frame.size.width - XRetangleLeft * 2, self.frame.size.width - XRetangleLeft * 2);
    if (self.whRatio != 1) {
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / self.whRatio;
        
        NSInteger hInt = (NSInteger)h;
        h = hInt;
        sizeRetangle = CGSizeMake(w, h);
    }
    
    // 扫码区域Y轴最小坐标
    CGFloat YMinRetangle = self.frame.size.height / 2.0f - sizeRetangle.height / 2.0f - self.centerUpOffset;
    CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
    CGFloat XRetangleRight = self.frame.size.width - XRetangleLeft;
    
    // 设置非识别区域颜色
    CGContextRef context = UIGraphicsGetCurrentContext();
    {
        CGFloat R, G, B, A;
        CGColorRef color = self.notRecoginitonAreaColor.CGColor;
        NSInteger numComponents = CGColorGetNumberOfComponents(color);
        if (numComponents == 4) {
            const CGFloat *components = CGColorGetComponents(color);
            R = components[0];
            G = components[1];
            B = components[2];
            A = components[3];
        }
        CGContextSetRGBFillColor(context, R, G, B, A);
        
        // 填充矩形
        // 扫码区域上面填充
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, YMinRetangle);
        CGContextFillRect(context, rect);
        
        // 扫码区域左边填充
        rect = CGRectMake(0, YMinRetangle, XRetangleLeft, sizeRetangle.height);
        CGContextFillRect(context, rect);
        
        // 扫码区域右边填充
        rect = CGRectMake(XRetangleRight, YMinRetangle, XRetangleLeft, sizeRetangle.height);
        CGContextFillRect(context, rect);
        
        // 扫码区域下面填充
        rect = CGRectMake(0, YMaxRetangle, self.frame.size.width,self.frame.size.height - YMaxRetangle);
        CGContextFillRect(context, rect);
        // 执行绘画
        CGContextStrokePath(context);
    }
    
    // 中间矩形区域(正方形)
    if (self.isNeedDrawRetangle) {
        CGContextSetStrokeColorWithColor(context, self.colorRetangleLine.CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextAddRect(context, CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height));
        CGContextStrokePath(context);
    }
    _scanRetangleRect = CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height);

    
    // 画矩形框4格外围相框角
    // 相框角的宽度和高度
    int wAngle = self.photoframeAngleW;
    int hAngle = self.photoframeAngleH;
    
    // 4个角的 线的宽度
    CGFloat linewidthAngle = self.photoframeLineW;
    
    // 画扫码矩形以及周边半透明黑色坐标参数
    CGFloat diffAngle = 0.0f;
    switch (self.photoframeAngleStyle) {
        case MSRQCodeScanViewPhotoframeAngleStyleOuter: {
            diffAngle = linewidthAngle / 3; // 框外面4个角，与框紧密联系在一起
        }
            break;
        case MSRQCodeScanViewPhotoframeAngleStyleOn: {
            diffAngle = 0;
        }
            break;
        case MSRQCodeScanViewPhotoframeAngleStyleInner: {
            diffAngle = -self.photoframeLineW / 2;
            
        }
            break;
        default: {
            diffAngle = linewidthAngle / 3;
        }
            break;
    }
    
    CGContextSetStrokeColorWithColor(context, self.colorAngle.CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, linewidthAngle);
    
    //
    CGFloat leftX = XRetangleLeft - diffAngle;
    CGFloat topY = YMinRetangle - diffAngle;
    CGFloat rightX = XRetangleRight + diffAngle;
    CGFloat bottomY = YMaxRetangle + diffAngle;
    
    // 左上角水平线
    CGContextMoveToPoint(context, leftX - linewidthAngle / 2, topY);
    CGContextAddLineToPoint(context, leftX + wAngle, topY);
    
    // 左上角垂直线
    CGContextMoveToPoint(context, leftX, topY - linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, topY+hAngle);
    
    // 左下角水平线
    CGContextMoveToPoint(context, leftX - linewidthAngle/2, bottomY);
    CGContextAddLineToPoint(context, leftX + wAngle, bottomY);
    
    // 左下角垂直线
    CGContextMoveToPoint(context, leftX, bottomY + linewidthAngle/2);
    CGContextAddLineToPoint(context, leftX, bottomY - hAngle);
    
    // 右上角水平线
    CGContextMoveToPoint(context, rightX + linewidthAngle / 2, topY);
    CGContextAddLineToPoint(context, rightX - wAngle, topY);
    
    // 右上角垂直线
    CGContextMoveToPoint(context, rightX, topY - linewidthAngle / 2);
    CGContextAddLineToPoint(context, rightX, topY + hAngle);
    
    // 右下角水平线
    CGContextMoveToPoint(context, rightX + linewidthAngle / 2, bottomY);
    CGContextAddLineToPoint(context, rightX - wAngle, bottomY);
    
    // 右下角垂直线
    CGContextMoveToPoint(context, rightX, bottomY + linewidthAngle / 2);
    CGContextAddLineToPoint(context, rightX, bottomY - hAngle);
    
    CGContextStrokePath(context);
    
    self.promptLabel.ms_bottom = bottomY + 40;
    self.promptLabel.ms_centerX = self.ms_centerX;
}

@end
